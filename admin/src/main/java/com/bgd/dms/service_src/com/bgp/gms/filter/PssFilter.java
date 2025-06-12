package com.bgp.gms.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.webapp.util.Base64Util;
import com.cnpc.jcdp.webapp.util.EscapeUtils;

public class PssFilter implements Filter {

	@Override
	public void destroy() {
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void doFilter(ServletRequest req, ServletResponse resp,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest request = (HttpServletRequest)req;
    	HttpServletResponse response = (HttpServletResponse)resp;
    	
    	//如果访问的url中包含参数pss_flg，则次请求为从管理平台发起的，参数默认值为psssysflg
    	//如果请求中menu_flg='1'，则访问的是首页，不做首页面跳转
    	String pss_flg = request.getParameter("pss_flg");
    	
    	if(pss_flg!=null){
    		HttpSession session = request.getSession();
    		pss_flg = decodeString(pss_flg);
    		session.setAttribute("pss_flg", pss_flg);
    		String menu_flg = request.getParameter("menu_flg");
        	menu_flg = decodeString(menu_flg);
    		
        	String menu1l = request.getParameter("menu1l");
        	String menu2l = request.getParameter("menu2l");
        	String menu3l = request.getParameter("menu3l");
        	String menu4l = request.getParameter("menu4l");
        	
    		if(StringUtils.isNotEmpty(menu1l)){
    			menu1l = decodeString(menu1l);
    			session.setAttribute("menu1l", menu1l);
    		}
    		if(StringUtils.isNotEmpty(menu2l)){
    			menu2l = decodeString(menu2l);
    			session.setAttribute("menu2l", menu2l);
    		}
    		if(StringUtils.isNotEmpty(menu3l)){
    			menu3l = decodeString(menu3l);
    			session.setAttribute("menu3l", menu3l);
    		}
    		if(StringUtils.isNotEmpty(menu4l)){
    			menu4l = decodeString(menu4l);
    			session.setAttribute("menu4l", menu4l);
    		}
    		Map m = request.getParameterMap();
    		Map m_ = new HashMap(m);
    		m = null;
    		m_.remove("pss_flg");
    		m_.remove("menu_flg");
    		m_.remove("menu1l");
    		m_.remove("menu2l");
    		m_.remove("menu3l");
    		m_.remove("menu4l");
    		
    		Iterator ite = m_.entrySet().iterator();
    		while (ite.hasNext()) {
				Map.Entry e = (Map.Entry) ite.next();
				e.setValue(decodeString(e.getValue()==null?null:((String[])e.getValue())[0]));
			}
    		
    		String str = JSONObject.fromObject(m_).toString();
    		session.setAttribute("pss_param_map", str);
    		if(StringUtils.isNotEmpty(menu_flg)){
    			session.setAttribute("menu_flg", menu_flg);
    			//response.sendRedirect(request.getContextPath()+request.getServletPath());
    		}
    	}
    	chain.doFilter(request, response);
	}

	private String decodeString(String src) {
		if(StringUtils.isNotBlank(src)){
			return Base64Util.decodeStr(src.replace("-", "+").replace("_", "/"));
		}
		return null;
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
	}

}
