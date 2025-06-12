package com.bgp.mcs.web.pm.gmsChart.action;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * @author qukj
 *
 */
public class queryXMLDataAction extends WSAction{
	
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);

		if(msg==null || msg.isDefaultFailedRet()){
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		}
		else{
			//Thread.sleep(100);
			
			log.debug("开始生成xml数据");

			String xmlStr = msg.getValue("Str");			
			
			response.setContentType("text/xml; charset=UTF-8");
			
			OutputStream os = response.getOutputStream();
			
			os.write(new byte[] { (byte) 0xEF, (byte) 0xBB, (byte) 0xBF });
			
			os.write(xmlStr.getBytes("UTF-8"));
			
			os.flush();

			log.debug(xmlStr);
			log.debug("生成xml数据成功");
			
		}
		return null;
	}
}