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
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����˽�
 *       
 * ������������ת���ⲿϵͳ������
 * 
 * url��/$bireport/**����url��ת��bi����ϵͳ
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
		
		if(!servletPath.equals("/$")){ // url���� /$/**���ض����ⲿϵͳ�������ض��򵽱�ϵͳ
			
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
			
			// �����ĿID
			if(queryStr.indexOf("projectInfoNo")<0){
				sysAdd += "&projectInfoNo="+user.getProjectInfoNo();
			}
			// BI�����滻tokenId=admin
			String tokenId= MadeToken.madeTokenId(user.getLoginId(), user.getUserPwd());
			//String tokenId= MadeToken.madeTokenId("admin", "wtsc");
			sysAdd = sysAdd.replaceAll("tokenId=admin", "tokenId="+tokenId);
		}
		
		resp.sendRedirect(sysAdd);
		
	}
}
