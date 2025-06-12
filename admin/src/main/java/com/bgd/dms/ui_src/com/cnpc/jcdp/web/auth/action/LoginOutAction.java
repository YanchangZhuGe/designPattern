package com.cnpc.jcdp.web.auth.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * 
* @ClassName: LoginOutAction
* @Description: ϵͳ�˳���SessionʧЧ
* @author wuhj
* @date 2013-9-26 ����2:09:09
*
 */
public class LoginOutAction  extends WSAction {
	
	@Override
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		JcdpMVCUtil.clearSession(request);
		
		return null;
	}



}
