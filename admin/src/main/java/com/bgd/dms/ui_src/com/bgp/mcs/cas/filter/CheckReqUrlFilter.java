package com.bgp.mcs.cas.filter;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;
import com.richfit.eiap.app.cas.EiapPrincipal;
import com.richfit.eiap.app.cas.EiapPrincipalException;

/**
 * @Title: CheckReqUrlFilter.java
 * @Package com.bgp.mcs.cas.filter
 * @Description: 统一认证
 * @author wuhj
 * @date 2014-8-19 上午10:51:10
 * @version V1.0
 */
public class CheckReqUrlFilter implements Filter
{

	@Override
	public void destroy()
	{
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException
	{ 
		HttpServletRequest req = (HttpServletRequest)request; 
		UserToken userToken = OMSMVCUtil.getUserToken(req);
		 
		Object loginout = req.getSession().getAttribute("loginout");
		
		if(userToken == null){ 
			
			String regEx = "^10.\\d{1,3}.\\d{1,3}.\\d{1,3}";
			String remoteAddr = request.getRemoteAddr();
			
			Pattern pat = Pattern.compile(regEx);  
			Matcher mat = pat.matcher(remoteAddr);
			
			boolean flag = mat.find();
			
			if (flag)
			{
				request.setAttribute("filterName", "EiapCasFilter_LocalNet");
			} else  
			{
				request.setAttribute("filterName", "EiapCasFilter_RemoteNet");
			}

			chain.doFilter(request, response);
		} else  if(loginout!=null && loginout.equals("loginout")){ 
			
			JcdpMVCUtil.clearSession(req);
			HttpServletResponse resq = (HttpServletResponse)response;
			resq.sendRedirect(req.getContextPath());
		} else {

			chain.doFilter(request, response);
		}



	}

	@Override
	public void init(FilterConfig arg0) throws ServletException
	{
		// TODO Auto-generated method stub

	}

}
