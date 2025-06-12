package com.bgp.mcs.web.pm.project;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bgp.mcs.service.pm.service.project.DesignSpsSrv;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class DownloadDBDataAction extends WSAction {
	DesignSpsSrv spsSrv = (DesignSpsSrv) BeanFactory.getBean("DesignSpsSrv");
	@Override
	public ActionForward executeResponse(ActionMapping actionmapping, ActionForm actionform,
			HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse) throws Exception {
		ISrvMsg isrvmsg = (ISrvMsg)httpservletrequest.getAttribute("responseDTO");
		String spsfileNo = isrvmsg.getValue("spsfileNo");
		String colName =  isrvmsg.getValue("colName");
		
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		String fileName = format.format(date) + ".txt";
		byte[] outData = spsSrv.getBlobContent(spsfileNo, colName);
		httpservletresponse.setContentType("application/x-msdownload");
		httpservletresponse.setHeader("Content-Disposition",
                           "attachment;" + "filename="+ fileName);
		OutputStream out = httpservletresponse.getOutputStream();
		
 	    out.write(outData);
        out.flush();
        out.close();
		return null;
	}
}
