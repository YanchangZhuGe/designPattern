package com.cnpc.jcdp.web.rad2.page;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.web.rad.page.BasePager;
import com.cnpc.jcdp.web.rad.page.PMDProcessor;
import com.cnpc.jcdp.web.rad.util.PMDRequest;
import com.cnpc.jcdp.web.rad.util.PagerFactory2;
import com.cnpc.jcdp.web.rad.util.RADUtil;

public class PMDProcessor2 extends PMDProcessor {
	
	public void process(HttpServletRequest request,
            HttpServletResponse response)
    	throws IOException, ServletException {
    	PMDRequest stlReq = null;
    	
    	try{
    		stlReq = RADUtil.getStlRequest(request);
    		BasePager pager = PagerFactory2.getPMDPager(stlReq);
        	pager.setStlRequest(stlReq);
        	pager.service(request, response);    		
    	}catch(Exception ex){
    		ex.printStackTrace();
    		log.error(ex);
    	}    	
    }
}
