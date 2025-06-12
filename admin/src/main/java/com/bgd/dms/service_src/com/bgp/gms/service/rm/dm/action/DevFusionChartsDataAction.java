package com.bgp.gms.service.rm.dm.action;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.webapp.constant.MVCConstant;

public class DevFusionChartsDataAction extends WSAction {

	@Override
	public ActionForward executeResponse(ActionMapping arg0, ActionForm arg1,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		response.setContentType("text/xml; charset=UTF-8");
		
		OutputStream os = response.getOutputStream();
		
		os.write(new byte[] { (byte) 0xEF, (byte) 0xBB, (byte) 0xBF });
		
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		/** 
		 * <chart caption='²âÊÔ' xAxisName='Week' yAxisName='Sales' numberPrefix='$'><set /></chart>
		 */
	
		String xmldata = msg.getValue("xmldata");
		
		os.write(xmldata.getBytes("UTF-8"));
		
		os.flush();
		
		return null;
	}
}
