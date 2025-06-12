/**
 * 
 */
package com.cnpc.jcdp.web.rad.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;

import com.cnpc.jcdp.cfg.SystemConfig;
import com.cnpc.jcdp.common.TreeNodeData;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.webapp.constant.MVCConstant;

/**
 * @author rechete
 *
 */
public class QueryEntityAction extends WSAction{
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		String forward = request.getParameter("forward");
		return new ActionForward(forward);
	}

}
