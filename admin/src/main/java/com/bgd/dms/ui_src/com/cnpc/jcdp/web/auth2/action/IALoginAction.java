package com.cnpc.jcdp.web.auth2.action;

import java.security.cert.X509Certificate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.soa.msg.ISOAMsg;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.ReturnCodeMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgImpl;
import com.cnpc.jcdp.soa.srvMng.SrvCfgPool;
import com.cnpc.jcdp.srvMng.pojo.MessageConfig;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;

/*
 * 身份认证（Identity Authentication)
 */
public class IALoginAction extends LoginAction {

	@Override
	public ActionForward preExecute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		X509Certificate[] ca = (X509Certificate[]) request.getAttribute("javax.servlet.request.X509Certificate");
		if (request.getHeader("dftmaccount") == null || ca == null || ca.length == 0) {
			ISOAMsg responseDTO = new SrvMsgImpl(null);
			ReturnCodeMsg codeMsg = new ReturnCodeMsg(AuthConstant.SP_AUTH_IA_ERROR);
			MessageConfig msgCfg = SrvCfgPool.getMessageConfig(codeMsg.getRetCode());
			String charset = request.getLocale().toString().toUpperCase(), msgContent = null;
			if (charset.indexOf("ZH") >= 0) {
				msgContent = msgCfg.getCnMsg();
			} else if (charset.indexOf("EN") >= 0) {
				msgContent = msgCfg.getEnMsg();
			} else {
				msgContent = msgCfg.getOtherMsg();
			}
			codeMsg.setRetMsg(msgContent);
			responseDTO.setReturnCodeMsg(codeMsg);
			responseDTO.setValue("ReturnCodeMsg", codeMsg);
			request.setAttribute(MVCConstant.RESPONSE_DTO, responseDTO);
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		}
		return super.preExecute(mapping, form, request, response);
	}

	@Override
	public void setDTOValue(ISrvMsg requestDTO, ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		super.setDTOValue(requestDTO, mapping, form, request, response);
		requestDTO.setValue("loginId", request.getHeader("dftmaccount").toString());
		X509Certificate[] ca=(X509Certificate[])request.getAttribute("javax.servlet.request.X509Certificate");
		String DN=ca[0].getSubjectDN().toString();
		String[] dncontent = DN.split(",");
		String numbers[] = dncontent[0].split("=");
		String canumber = numbers[1];
		requestDTO.setValue("cerficate", canumber);
	}

}
