package com.bgp.mcs.service.ma.marketInfoInput;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class WSForwardAction extends WSAction {

	
	public ActionForward executeResponse(ActionMapping actionMapping, ActionForm actionForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ISrvMsg isrvmsg;
		if ((isrvmsg = (ISrvMsg) request.getAttribute("responseDTO")) == null)
			return actionMapping.findForward("failed");
		if (isrvmsg.isSuccessRet()){
			String forwardName=isrvmsg.getValue("strutsForwardName");
			if(forwardName!=null&&!"".equals(forwardName)){
				return actionMapping.findForward(forwardName);
			}else{
				return actionMapping.findForward("success");
			}
		}
		if (isrvmsg.isDefaultFailedRet())
			return actionMapping.findForward("failed");
		return actionMapping.findForward("success");
	}
	
}
