/**
 * 查询列表数据
 */
package com.cnpc.jcdp.web.rad.action;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.util.JsonUtil;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.util.ActionUtils;

public class QueryListAction extends WSAction {
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		try {
			JSONObject returnObject = new JSONObject();
			if (msg == null) {
				log.error("QueryListAction.executeResponse(),msg is null!");
				returnObject.put("returnCode", 1);
				returnObject.put("returnMsg", "响应数据为空");
			} else if (!msg.isSuccessRet()) {
				log.error("QueryListAction.executeResponse(),msg retCode is ["
						+ msg.getRetCode() + "]");
				returnObject.put("returnCode", 2);
				// returnObject.put("returnMsg", "请求服务失败!");
				returnObject.put("returnMsg", msg.getRetMsg());
			} else {
				returnObject.put("returnCode", 0);
				returnObject.put("returnMsg", "请求数据成功!");
				returnObject.put("totalRows", msg.getValue("totalRows"));

				List<MsgElement> msgs = msg.getMsgElements("datas");
				List<Map> mapList = null;
				if (msgs != null) {
					mapList = ActionUtils.listWithMap(msgs);
				}
				returnObject.put("datas", JsonUtil.list2json(mapList));
			}
			response.setContentType("text/json; charset=utf-8");
			response.getWriter().print(returnObject.toString());
		} catch (Throwable e) {
			log.error(e);
		}
		return null;
	}
}
