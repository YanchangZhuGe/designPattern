package com.bgp.mcs.service.pm.service.downloadAcquireFile;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.sql.DecodeCaseFragment;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class DownloadAcquireFileAction extends WSAction {

	MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	@Override
	public ActionForward executeResponse(ActionMapping actionmapping, ActionForm actionform,
			HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse) throws Exception {
		ISrvMsg isrvmsg = (ISrvMsg)httpservletrequest.getAttribute("responseDTO");
		
		String fileName = isrvmsg.getValue("fileName");
		byte[] fileContent = (byte[])((Object)isrvmsg.getValue("fileContent"));
		
		fileName = fileName + ".txt";
		httpservletresponse.setContentType("application/x-msdownload");
		httpservletresponse.setHeader("Content-Disposition",
                           "attachment;" + "filename="+ new String(fileName.getBytes(), "ISO-8859-1"));
        
        OutputStream out = httpservletresponse.getOutputStream();
        
 	   	out.write(fileContent);
        out.flush(); //强制清出缓冲区 
        out.close();
              
		return null;
	}	
}
