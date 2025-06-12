package com.bgp.mcs.web.common.action;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.webapp.constant.MVCConstant;

/**
 * 
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：打印后台产生的文件到浏览器
 */
public class PrintServiceGenedFileAction extends WSAction{
	
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		if(msg==null || msg.isDefaultFailedRet()){
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		}
		else if(msg.isSuccessRet()){
			ISrvMsg isrvmsg;
	        if((isrvmsg = (ISrvMsg)request.getAttribute("responseDTO")) == null)
	            return mapping.findForward("failed");
	        if(isrvmsg.isDefaultFailedRet())
	            return mapping.findForward("failed");
	        WSFile wsfile = ((MQMsgImpl)isrvmsg).getFile();

	        response.setContentType(wsfile.getType());
	        response.setCharacterEncoding("GBK");
//	        response.setHeader("Content-Disposition", (new StringBuilder()).append(a.a("t`btr|\177ps`%spx\177{dych")).append(new String(s.getBytes(), a.a("]FX9(-&-1d"))).toString());
	        ServletOutputStream servletoutputstream = response.getOutputStream();
	        servletoutputstream.write(wsfile.getFileData());
	        servletoutputstream.flush();
	        servletoutputstream.close();
	        return null;
		}
		else{
			return mapping.findForward(MVCConstant.FORWARD_BUSI_EX);
		}
	}
}