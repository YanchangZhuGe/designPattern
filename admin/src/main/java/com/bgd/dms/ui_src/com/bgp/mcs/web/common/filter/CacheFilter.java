package com.bgp.mcs.web.common.filter;

import java.io.IOException;
import java.util.Date;
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

import com.bgp.mcs.service.util.CacheUtil;
import com.bgp.mcs.web.common.util.ResponseContent;
import com.bgp.mcs.web.common.util.ResponseWrapper;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;
/**
 * 缓存过滤器
 * 对以/cache开头的get请求进行处理
 * @author qukj
 *
 */
public class CacheFilter implements Filter {
	protected String encoding = null;

	public void destroy() {
		this.encoding = null;
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest hreq = (HttpServletRequest)request;
		HttpServletResponse hresp = (HttpServletResponse)response;
		
		String uri = hreq.getRequestURI();
		uri = uri.replaceFirst(hreq.getContextPath(), ""); // 去掉路径中的第一个/DMS，以方便进行forward
		uri = uri.replaceFirst("/cache", "");// 去掉路径中的第一个/cache
		
		String query = getQuery(hreq.getQueryString());// 去掉由FusionCharts字段添加到url上的FCTIME=xxxx参数
		
		String method = hreq.getMethod();
		
		if("GET".equals(method)){// 只对get方法进行缓存
			
			// 生成key，以uri、查询字符串、用户所属单位来生成
			Object key = CacheUtil.genKey(uri, query, OMSMVCUtil.getUserToken(hreq).getSubOrgIDofAffordOrg());
			
			//System.out.println(key);
			
			// 从缓存里获取值
			Object value = CacheUtil.get(key);
			
			// 如果值为空，执行计算
			if(value==null){
				
				ResponseWrapper wrapper=new ResponseWrapper(hresp);  
				
				//System.out.
				hreq.getRequestDispatcher(uri).forward(hreq, wrapper);
				
				value = wrapper.toResponseContent();
				
				// 放入缓存
				CacheUtil.set(key, value);
			}
			
			ResponseContent c = (ResponseContent)value;
			
			hresp.setContentType(c.getContentType());
			hresp.setCharacterEncoding("utf-8");
			hresp.setHeader("Cache-Control", "14400");// 缓存4个小时
			hresp.setHeader("Last-Modified", (new Date()).toGMTString());// 最后修改时间
			hresp.getOutputStream().write(c.getContent());
			
		}else{
			hreq.getRequestDispatcher(uri+"?"+query).forward(hreq, hresp);
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		this.encoding = filterConfig.getInitParameter("encoding");
	}

	/**
	 * 去掉query里的FCTime参数
	 * @param uri
	 * @return
	 */
	private String getQuery(String uri){
		if(uri==null || uri.trim().equals("")) return "";
		
		Pattern p = Pattern.compile("(^|&)(FCTime=[\\d]+)(&|$)");
		Matcher m = p.matcher(uri);
		String ret;
		if(m.find()){
			if("&".equals(m.group(1))){
				ret = m.replaceFirst(m.group(3));
			}else{
				ret = m.replaceFirst("");
			}
		}else{
			ret = uri;
		}
		
		return ret;
	}
	
//	public static void main(String[] args) {
//		String uri = "";
//		CacheFilter filter = new CacheFilter();
//
//		System.out.println(filter.getQuery(uri));
//	}
	
}
