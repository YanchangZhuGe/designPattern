package com.bgp.mcs.web.pm.structunit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.Globals;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.webapp.constant.MVCConstant;

public class StructUnitAddAction extends WSAction{
	public void setDTOValue(
            ISrvMsg requestDTO ,
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {    	
        if( requestDTO  == null )
        	return;
        super.setDTOValue(requestDTO, mapping, form, request, response);
        String charset =request.getSession().getAttribute(Globals.LOCALE_KEY).toString();
        requestDTO.setValue("loginIp", request.getRemoteAddr());
        requestDTO.setValue("charset", charset);
    }
	
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		
		System.out.println("=======================================at action!");
		
		ActionForward forward =  mapping.findForward(MVCConstant.FORWARD_SUCESS);
		return forward;
	}
}
