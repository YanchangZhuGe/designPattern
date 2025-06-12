package com.bgp.mcs.web.doc.action;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class ViewTxtFileAction extends WSAction {
	MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");

	@Override
	public ActionForward executeResponse(ActionMapping actionmapping, ActionForm actionform,
			HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse) throws Exception {
		// TODO Auto-generated method stub
		ISrvMsg isrvmsg = (ISrvMsg)httpservletrequest.getAttribute("responseDTO");
		
		String docId = isrvmsg.getValue("docid");
		String logFileId = isrvmsg.getValue("logFileId");
		String userId = isrvmsg.getValue("userId");
		String orgId = isrvmsg.getValue("orgId");
		String orgSubId = isrvmsg.getValue("orgSubId");
		String docAction = isrvmsg.getValue("docaction");		
		
		String docTitle = myUcm.getDocTitle(docId);
		byte[] docData = myUcm.getFile(docId);

		httpservletresponse.setContentType("text/plain;charset=GBK");
       
        PrintWriter out = httpservletresponse.getWriter();
		InputStream is = new ByteArrayInputStream(docData);
		InputStreamReader isr = new InputStreamReader(is);
		BufferedReader br = new BufferedReader(isr);
		String line = br.readLine();
		while(line != null){
			out.write(line);
			out.write("\n");
			line = br.readLine();
		}
		
        out.flush(); //强制清出缓冲区 
        out.close();
        //写入下载的日志
        if(logFileId!=""&&logFileId!=null){
        	//action不是空值，表示是查看  action是空值，表示是下载是2,查看是5
        	String fileVersion = isrvmsg.getValue("fileVersion");
        	if("view".equals(docAction)){
        		myUcm.docLog(logFileId, fileVersion,5, userId, userId, userId,orgId,orgSubId,docTitle);
        	}else{
        		myUcm.docLog(logFileId, fileVersion, 2, userId, userId, userId,orgId,orgSubId,docTitle);
        	}
                   	
        }              
		return null;
	}
	
}
