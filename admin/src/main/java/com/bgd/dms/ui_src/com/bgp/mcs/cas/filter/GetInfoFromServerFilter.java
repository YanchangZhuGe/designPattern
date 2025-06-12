package com.bgp.mcs.cas.filter;

import java.io.IOException;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserProfile;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.mvc.Globals;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;
import com.cnpc.sais.ibp.auth2.srv.LoginAndMenuTreeSrv;
import com.richfit.eiap.app.cas.EiapPrincipal;
import com.richfit.eiap.app.cas.EiapPrincipalException;

/**
 * @Title: GetInfoFromServerFilter.java
 * @Package com.bgp.mcs.cas.filter
 * @Description: 统一认证：获取用户登录信息
 * @author wuhj
 * @date 2014-8-19 下午3:41:16
 * @version V1.0
 */
public class GetInfoFromServerFilter implements Filter
{
	protected String encoding = null;
	@Override
	public void destroy()
	{
		this.encoding = null;
		
	}

  
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException
	{
		if (request.getCharacterEncoding() == null){
			String encoding = this.encoding;
			if (encoding != null) {
				request.setCharacterEncoding(encoding);
				response.setCharacterEncoding(encoding);
			}
		}
		
		HttpServletRequest req = (HttpServletRequest) request;
		
		String servletPath = req.getServletPath();
		
		if (  !servletPath.contains("login.jsp")  )
		{
			UserToken userToken = OMSMVCUtil.getUserToken(req);
			 
			if (userToken == null)
			{
				try
				{ 
					
					Map attributes = EiapPrincipal.getAttributes();
					String loginId = (String) attributes.get("cnpcAccount");
					String remoteAddr = request.getRemoteAddr();
					
					Map map = null;
					if (loginId != null)
					{

						loginId = loginId.substring(0,loginId.indexOf("@cnpc.com.cn"));

						LoginAndMenuTreeSrv loginAndMenuTree = (LoginAndMenuTreeSrv) BeanFactory
								.getBean("IBPLoginAndMenuTree");

						Object charset =req.getAttribute(Globals.LOCALE_KEY);
						
						if(charset==null)
							charset ="UTF-8";

						map = loginAndMenuTree.updateUserLoginBGPSFRZ(loginId,
								remoteAddr, charset.toString());
						UserToken userToken0 = (UserToken) map.get("userToken");
						// 把用户信息放到Session里面
						JcdpMVCUtil.setUserToken(req, userToken0);

						Map mapUserProfile = (Map) map.get("userProfile");
						// 把用户平台信息放到Session里面
						if (mapUserProfile != null && !mapUserProfile.isEmpty())
						{
							String userMainPage = PagerFactory.defaultMainPage;

							UserProfile userProfile = new UserProfile();
							userProfile.setTptId((String) mapUserProfile
									.get("tmptId"));

							userMainPage = PagerFactory.tptMainPages
									.get(userProfile.getTptId());

							if (userMainPage != null
									&& !userMainPage.trim().equals("")
									&& !userMainPage.trim().startsWith("/"))
							{
								userMainPage = "/" + userMainPage;
							}
							JcdpMVCUtil.setUserProfile(req, userProfile);
						}
						String funcCodes = (String) map.get("funcCodes");

						JcdpMVCUtil.setUserFuncCodes(req, funcCodes);

					}

				} catch (EiapPrincipalException e)
				{
					e.printStackTrace();
				}
			}
		}
		chain.doFilter(request, response);

	}
 
	@Override
	public void init(FilterConfig filterConfig) throws ServletException
	{
		this.encoding = filterConfig.getInitParameter("encoding");
		
	}
 

}
