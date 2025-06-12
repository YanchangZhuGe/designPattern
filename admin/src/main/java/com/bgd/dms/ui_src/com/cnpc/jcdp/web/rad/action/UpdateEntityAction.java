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
public class UpdateEntityAction extends WSAction{
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		try {
			JSONObject returnObject = new JSONObject();
			if (msg == null) {
				log.error("AddEntityAction.executeResponse(),msg is null!");
				returnObject.put("returnCode", 1);
				returnObject.put("returnMsg", "响应数据为空");
			} else if (!msg.isSuccessRet()) {
				log.error("AddEntityAction.executeResponse(),msg retCode is ["
								+ msg.getRetCode() + "]");
				returnObject.put("returnCode", 2);
				returnObject.put("returnMsg", "请求服务失败!");
			} else {
				returnObject.put("returnCode", 0);
				returnObject.put("returnMsg", "编辑实体成功!");
			}			
			
			response.setContentType("text/json; charset=utf-8"); 
			response.getWriter().print(returnObject.toString());
		} catch (Throwable e) {
			log.error(e);
		}		
		return null;
	}

}
