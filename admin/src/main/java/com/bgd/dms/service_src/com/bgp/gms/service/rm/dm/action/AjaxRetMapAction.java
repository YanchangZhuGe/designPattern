
package com.bgp.gms.service.rm.dm.action;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
 * 
 * @author dz
 *
 */
public class AjaxRetMapAction extends WSAction {
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
		servicecallconfig.setServiceName(request.getParameter("JCDP_SRV_NAME"));
		servicecallconfig.setOperationName(request.getParameter("JCDP_OP_NAME"));

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

		response.setContentType("text/html; charset=UTF-8");
		
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);

		if (msg.isSuccessRet()) {
			MsgElement msgele =  msg.getMsgElement("data");
			Map dataMap = null;
			if(msgele != null){
				dataMap =msgele.toMap();
			}
			JSONArray json = JSONArray.fromObject(dataMap); 
			PrintWriter pw = response.getWriter();
			pw.print(json);
			pw.flush();
			pw.close();	
		}
		return null;
	}
}
