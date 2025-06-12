
package com.bgp.gms.service.rm.dm.action;

import java.io.PrintWriter;
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
 * easyui datagrid json
 * @author dz
 *
 */
public class EasyUIDataGridAction extends WSAction {
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
			JSONObject ret = new JSONObject();
			String totalRows = msg.getValue("totalRows");
	 
			ret.put("total", Integer.parseInt(totalRows));
			List<MsgElement> datas = msg.getMsgElements("datas");
			List<MsgElement> footers = msg.getMsgElements("footer");
			JSONArray footer_rows = new JSONArray();
			if (footers != null) {
				for (MsgElement data : footers) {
					Map row = data.toMap();
					footer_rows.add(row);
				}				
			}
			JSONArray rows = new JSONArray();
			if (datas != null) {
				for (MsgElement data : datas) {
					Map row = data.toMap();
					rows.add(row);
				}				
			}
			ret.put("rows", rows);
			ret.put("footer", footer_rows);
			PrintWriter pw = response.getWriter();
			pw.print(ret);
			pw.flush();
			pw.close();
		}
		return null;
	}
}
