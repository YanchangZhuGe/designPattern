package com.cnpc.sais.web.inter.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.web.inter.cache.CacheUser;
import com.cnpc.sais.web.inter.cache.ICacheUser;

public class InterAction extends WSAction {


	@Override
	public ActionForward servieCall(ActionMapping arg0, ActionForm arg1,
			HttpServletRequest arg2, HttpServletResponse arg3) throws Exception {
		ICacheUser cache = CacheUser.getInstance();
		cache.loadCache();	
		return arg0.findForward("success");
	}

}
