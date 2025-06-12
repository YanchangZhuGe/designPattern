package com.cnpc.jcdp.web.auth2.action;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.webapp.constant.MVCConstant;

import net.sf.json.JSONObject;


import com.cnpc.jcdp.cfg.SystemConfig;
import com.cnpc.jcdp.common.TreeNodeData;

import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;


/**
 * Project：CNLC OMS(MVC)
 * 
 * Creator：rechete
 * 
 * Creator Time:2008-5-8 上午9:28:47
 * 
 * Description：load menu nodes dynamically
 * 
 * Revision history：
 * 
 */

public class DyncLoadMenuAction extends WSAction{
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		try {
			JSONObject returnObject = new JSONObject();
			if (msg == null) {
				log.error("DyncLoadMenuAction.executeResponse(),msg is null!");
				returnObject.put("returnCode", 1);
				returnObject.put("returnMsg", "响应数据为空");
			} else if (!msg.isSuccessRet()) {
				log
						.error("DyncLoadMenuAction.executeResponse(),msg retCode is ["
								+ msg.getRetCode() + "]");
				returnObject.put("returnCode", 2);
				returnObject.put("returnMsg", "请求服务失败!");
			} else {
				returnObject.put("returnCode", 0);
				returnObject.put("returnMsg", "请求数据成功!");
				List<MsgElement> msgs = msg.getMsgElements("nodes");
				List<TreeNodeData> nodes = new ArrayList<TreeNodeData>();
				if (msgs != null && msgs.size() > 0)
					for (int i = 0; i < msgs.size(); i++) {
						TreeNodeData node = (TreeNodeData) msgs.get(i).toPojo(
								TreeNodeData.class);
						//DataAuthConfig.addAuth2Node(node);
						if(node.getUrl()!=null && node.getUrl().startsWith("../")){
							node.setUrl(node.getUrl().substring(3));
						}
						nodes.add(node);
					}
				returnObject.put("nodes", nodes);
			}
			
			
			response.setContentType("text/json; charset=utf-8"); 
			response.getWriter().print(returnObject.toString());
		} catch (Throwable e) {
			e.printStackTrace();
			// TODO: handle exception
		}		
		return null;
	}
	

}
