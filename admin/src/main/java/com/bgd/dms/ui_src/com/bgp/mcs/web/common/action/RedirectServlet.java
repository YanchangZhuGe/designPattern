package com.bgp.mcs.web.common.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;
import com.richfit.bi.portal.token.MadeToken;
/**
 * 
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：处理跳转到外部系统的链接
 * 
 * url：/$bireport/**，此url跳转到bi报表系统
 */
public class RedirectServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6303786178422804254L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String servletPath = req.getServletPath();
		
		String sysAdd;
		
		if(!servletPath.equals("/$")){ // url不是 /$/**，重定向到外部系统，否则重定向到本系统
			
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			
			sysAdd = cfgHd.getSingleNodeValue("//external_url/"+servletPath.substring(2));		
			
		}else{
			sysAdd = req.getContextPath();
		}
		
		sysAdd += req.getPathInfo();
		
		String queryStr = req.getQueryString();
		
		if(queryStr!=null && !queryStr.equals("")){
			sysAdd += "?" + queryStr;
		}else{
			queryStr = "";
		}
		
		if(servletPath.equals("/$bireport")){
			
			UserToken user = OMSMVCUtil.getUserToken(req);
			
			// 添加项目ID
			if(queryStr.indexOf("projectInfoNo")<0){
				sysAdd += "&projectInfoNo="+user.getProjectInfoNo();
			}
			// BI报表，替换tokenId=admin
			String tokenId= MadeToken.madeTokenId(user.getLoginId(), user.getUserPwd());
			//String tokenId= MadeToken.madeTokenId("admin", "wtsc");
			sysAdd = sysAdd.replaceAll("tokenId=admin", "tokenId="+tokenId);
		}
		
		resp.sendRedirect(sysAdd);
		
	}
}
