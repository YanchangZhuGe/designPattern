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
 * ���������
 * ����/cache��ͷ��get������д���
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
		uri = uri.replaceFirst(hreq.getContextPath(), ""); // ȥ��·���еĵ�һ��/DMS���Է������forward
		uri = uri.replaceFirst("/cache", "");// ȥ��·���еĵ�һ��/cache
		
		String query = getQuery(hreq.getQueryString());// ȥ����FusionCharts�ֶ���ӵ�url�ϵ�FCTIME=xxxx����
		
		String method = hreq.getMethod();
		
		if("GET".equals(method)){// ֻ��get�������л���
			
			// ����key����uri����ѯ�ַ������û�������λ������
			Object key = CacheUtil.genKey(uri, query, OMSMVCUtil.getUserToken(hreq).getSubOrgIDofAffordOrg());
			
			//System.out.println(key);
			
			// �ӻ������ȡֵ
			Object value = CacheUtil.get(key);
			
			// ���ֵΪ�գ�ִ�м���
			if(value==null){
				
				ResponseWrapper wrapper=new ResponseWrapper(hresp);  
				
				//System.out.
				hreq.getRequestDispatcher(uri).forward(hreq, wrapper);
				
				value = wrapper.toResponseContent();
				
				// ���뻺��
				CacheUtil.set(key, value);
			}
			
			ResponseContent c = (ResponseContent)value;
			
			hresp.setContentType(c.getContentType());
			hresp.setCharacterEncoding("utf-8");
			hresp.setHeader("Cache-Control", "14400");// ����4��Сʱ
			hresp.setHeader("Last-Modified", (new Date()).toGMTString());// ����޸�ʱ��
			hresp.getOutputStream().write(c.getContent());
			
		}else{
			hreq.getRequestDispatcher(uri+"?"+query).forward(hreq, hresp);
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		this.encoding = filterConfig.getInitParameter("encoding");
	}

	/**
	 * ȥ��query���FCTime����
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
