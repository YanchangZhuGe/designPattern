package com.bgp.mcs.web.qua.action;

import java.io.Writer;

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
public class QualityChartAction extends WSAction{

	/*public ActionForward servieCall(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
	    throws Exception
	{
	    ServiceCallConfig servicecallconfig;
	    
	    if(request.getParameter("serviceName")!=null && request.getParameter("operationName")!=null){
	    	servicecallconfig = new ServiceCallConfig();
	    	servicecallconfig.setServiceName(request.getParameter("serviceName"));
			servicecallconfig.setOperationName(request.getParameter("operationName"));
	    }else{
	    	servicecallconfig = mapping.getDefaultServiceCallConfig();
	    }
	    if(servicecallconfig== null)
	        return null;
	    ISrvMsg isrvmsg;
	    if((isrvmsg = createDTO(mapping, form, request, response)) == null)
	    {
	        return null;
	    } else
	    {
	        setDTOValue(isrvmsg, mapping, form, request, response);
	        ISrvMsg isrvmsg1 = ServiceCallFactory.getIServiceCall().callWithDTO(null, isrvmsg, servicecallconfig);
	        request.setAttribute("responseDTO", isrvmsg1);
	        return null;
	    }
	}*/
	
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);

		if(msg==null || msg.isDefaultFailedRet()){
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		}
		else{
			log.debug("开始生成xml数据");

			response.setContentType("text/xml; charset=UTF-8");
			Writer out = response.getWriter();
			String Str = (String)msg.getValue("Str");
			Str = java.net.URLDecoder.decode(Str,"UTF-8");
			System.out.println(Str);
			log.debug(Str);
			log.debug("生成xml数据成功");
			out.write(Str);
			out.flush();
			
			
		}
		return null;
	}
}