package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.util.ContainerUtil;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADUtil;
import com.cnpc.jcdp.web.rad.util.PMDRequest;

public class PMDProcessor extends HttpServlet{
	protected ILog log = LogFactory.getLogger(getClass());
	
    public void init() throws ServletException {
    	RADConst.WEB_ROOT = ContainerUtil.getServletContext(this);
//    	System.out.println("PMD WebRoot:"+RADConst.WEB_ROOT);
        log.info("PMD WebRoot:"+RADConst.WEB_ROOT);
    }

    public void doGet(HttpServletRequest request,
            HttpServletResponse response)
      throws IOException, ServletException {

      process(request, response);

    }
    
    public void doPost(HttpServletRequest request,
            HttpServletResponse response)
      throws IOException, ServletException {

      process(request, response);

    } 
    
    public void process(HttpServletRequest request,
            HttpServletResponse response)
    	throws IOException, ServletException {
    	PMDRequest stlReq = null;
    	try{
    		stlReq = RADUtil.getStlRequest(request);
    		BasePager pager = PagerFactory.getPMDPager(stlReq);
        	pager.setStlRequest(stlReq);
        	pager.service(request, response);    		
    	}catch(Exception ex){
    		ex.printStackTrace();
    		log.error(ex);
    	}    	
    }
}
