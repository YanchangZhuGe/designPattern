/**
 * 
 */
package com.cnpc.jcdp.web.rad.action;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.cnpc.jcdp.cfg.SystemConfig;
import com.cnpc.jcdp.common.UserProfile;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.util.JsonUtil;
import com.cnpc.jcdp.web.tcg.ajax.action.AjaxCallAction;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.util.ActionUtils;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * @author rechete
 *
 */
public class UpdateUserProfileAction extends AjaxCallAction{
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {		
		ActionForward forward = super.executeResponse(mapping, form, request, response);
		UserProfile prof = JcdpMVCUtil.getUserProfile(request);
		if(prof!=null){
			prof.setTptId(request.getParameter("tmpt_id"));
		}
		return forward;
	}
}
