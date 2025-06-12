/**
 * 
 */
package com.cnpc.jcdp.web.rad.util;

import javax.servlet.http.HttpServletRequest;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserProfile;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;
import com.cnpc.sais.web.cpc.cache.pojo.CompResource;

/**
 * @author rechete
 *
 */
public class RADUtil {
	private static ILog log = LogFactory.getLogger(RADUtil.class);
	public static String deleteLineFeed(String str){
		if(str==null) return null;
		str = str.replaceAll("\r\n", " ");
		str = str.replaceAll("\n", " ");
		return str;
	}
	
	public static PMDRequest getStlRequest(HttpServletRequest req)throws Exception{
		PMDRequest stlReq = new PMDRequest();
		String fileName = req.getServletPath(),
			   pageAction  = req.getParameter("pagerAction");
		ConfigHandler configHandler = getConfigHandler(fileName);
		stlReq.setFileName(fileName);
		stlReq.setPagerAction(pageAction);
	
 	    stlReq.setTlHd(configHandler);
 	    
// 	    if("edit2View".equals(fileName)){
// 	    	fileName = fileName.substring(0,fileName.length()-4)+"2View.pmd";
// 	    }
 	    
 	    UserProfile profile = JcdpMVCUtil.getUserProfile(req);
 	    stlReq.setTptId(profile!=null?profile.getTptId():"");
		return stlReq;
	}
	
	/**
	 * 组件容器响应请求
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	public static PMDRequest getStlRequest(HttpServletRequest req,CompResource res)throws Exception{
		PMDRequest stlReq = new PMDRequest();
//		stlReq.setFileName(req.getServletPath());
		stlReq.setFileName(req.getRequestURI());
		stlReq.setPagerAction(req.getParameter("pagerAction"));
		
		String reqFile = stlReq.getFileName();		
 	    stlReq.setTlHd((ConfigHandler)res.getContent());
 	    
 	    if("edit2View".equals(stlReq)){
 	    	reqFile = reqFile.substring(0,reqFile.length()-4)+"2View.pmd";
 	    }
 	    
 	    UserProfile profile = JcdpMVCUtil.getUserProfile(req);
 	    stlReq.setTptId(profile!=null?profile.getTptId():"");
		return stlReq;
	}	
	
	public static ConfigHandler getConfigHandler(String reqFile)throws Exception{
		if(reqFile.startsWith("/") || reqFile.startsWith("\\")) reqFile = reqFile.substring(1);
 	    String fullFileName = RADConst.WEB_ROOT+reqFile;
 	    log.debug("pmd文件路径："+fullFileName);
 	    return ConfigFactory.getXMLHandlerByFullFilename(fullFileName);
	}
	
}
