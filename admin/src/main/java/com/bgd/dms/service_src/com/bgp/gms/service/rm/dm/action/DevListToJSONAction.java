package com.bgp.gms.service.rm.dm.action;

import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.srvclient.IServiceCall;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * @ClassName: DevListToJSONAction(echarts图表使用)
 * @Description: list转json
 * @author dz
 */
public class DevListToJSONAction extends WSAction {
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
		servicecallconfig.setServiceName(request.getParameter("JCDP_SRV_NAME"));
		servicecallconfig
				.setOperationName(request.getParameter("JCDP_OP_NAME"));

		ISrvMsg isrvmsg;
		if ((isrvmsg = SrvMsgUtil.createISrvMsg(servicecallconfig
				.getOperationName())) == null) {
			return null;
		} else {
			setDTOValue(isrvmsg, mapping, form, request, response);
			setUserToken(isrvmsg, mapping, form, request, response);
			IServiceCall cal = ServiceCallFactory.getIServiceCall();
			ISrvMsg isrvmsg1 = cal.callWithDTO(request, isrvmsg, servicecallconfig);
			request.setAttribute("responseDTO", isrvmsg1);
			return null;
		}
	}
	
	@Override
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentType("text/json");		
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		if (msg.isSuccessRet()) {
			List<MsgElement> datas = msg.getMsgElements("datas");
			JSONArray rows = new JSONArray();
			if (datas != null) {
				for (MsgElement data : datas) {
					Map row = data.toMap();					
					JSONObject o = JSONObject.fromObject(row);					
					rows.add(o);
				}
			}
			PrintWriter pw = response.getWriter();
			if(StringUtils.isNotBlank(request.getParameter("root"))){
				JSONObject root = new JSONObject();
				root.put(request.getParameter("root"), rows);
				pw.print(root);
			}else{
				pw.print(rows);
			}
			pw.flush();
			pw.close();
		}
		return null;
	}
}
