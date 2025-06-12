package com.cnpc.sais.web.inter.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.sais.web.inter.cache.CacheUser;
import com.cnpc.sais.web.inter.resource.ResourceInternational;
import com.cnpc.sais.web.inter.text.TextInternational;
import com.cnpc.sais.web.inter.util.CharResponseWrapper;

public class InternationalComponent implements Filter {
	private static String[] openers;

	private static String responseEncoding;

	private static String[] textRegular;

	private static String[] cssRegular;

	private static String[] imgRegular;

	private static String[] jsRegular;

	private FilterConfig filterConfig;

	private List<String> extPaths = new ArrayList<String>();

	public void destroy() {
		openers = null;
		responseEncoding = null;
		textRegular = null;
		cssRegular = null;
		imgRegular = null;
		jsRegular = null;
		filterConfig = null;
		extPaths = null;
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		if (isExtendPath(req.getContextPath(), req.getRequestURI())) {
			chain.doFilter(request, response);
		} else {
			response.setCharacterEncoding(responseEncoding);
			response.setContentType("text/xml;charset=" + responseEncoding);
			Locale lo = request.getLocale();
			String lan = CacheUser.getInstance().getLocaleValue(lo.getCountry().toLowerCase());
			CharResponseWrapper wrapper = new CharResponseWrapper((HttpServletResponse) response);
			chain.doFilter(request, wrapper);
			String resStr = wrapper.toString();
			if(!"".equals(resStr) && resStr != null){
				if (!resStr.equals("") && openers.length > 0 && Arrays.binarySearch(openers,RegularConstant.TEXT_REGULAR_OPEN) >= 0) {
					resStr = TextInternational.textRI(resStr, textRegular, lan);
				}
				if (openers.length > 0 && Arrays.binarySearch(openers,RegularConstant.IMG_REGULAR_OPEN) >= 0) {
					resStr = ResourceInternational.pictureRI(resStr, imgRegular,lan);
				}

				if (openers.length > 0 && Arrays.binarySearch(openers,RegularConstant.CSS_REGULAR_OPEN) >= 0) {
					resStr = ResourceInternational.cssRI(resStr, cssRegular, lan);
				}
				resStr = ResourceInternational.jsRI(resStr, jsRegular, lan);
				PrintWriter out = response.getWriter();
				out.println(resStr);
				out.close();
			}
		}
	}

	public void init(FilterConfig config) throws ServletException {
		String opener = config.getInitParameter("opener");
		openers = opener == null ? new String[0] : opener.trim().split(",");
		Arrays.sort(openers);
		String tr = config.getInitParameter(RegularConstant.REGULAR_TR);
		textRegular = tr == null ? RegularConstant.TEXT_REGULAR : mergeArray(tr.split(","), RegularConstant.TEXT_REGULAR);

		String cr = config.getInitParameter(RegularConstant.REGULAR_CR);
		cssRegular = cr == null ? RegularConstant.CSS_REGULAR : mergeArray(cr.split(","), RegularConstant.CSS_REGULAR);

		String ir = config.getInitParameter(RegularConstant.REGULAR_IR);
		imgRegular = ir == null ? RegularConstant.IMG_REGULAR : mergeArray(ir.split(","), RegularConstant.IMG_REGULAR);

		jsRegular = RegularConstant.JS_REGULAR;
		responseEncoding = config.getInitParameter("encoding");

		// 初始化extPaths，即不需要进行国际化过滤的路径
		this.filterConfig = config;
		if (filterConfig.getInitParameter("extpaths") != null) {
			String[] _extPaths = filterConfig.getInitParameter("extpaths").trim().split(",");
			if (_extPaths != null) {
				for (int index = 0; index < _extPaths.length; ++index) {
					this.extPaths.add(_extPaths[index].trim());
				}
			}
		}
	}

	private String[] mergeArray(String[] a1, String[] a2) {
		String[] array = new String[a1.length + a2.length];
		System.arraycopy(a1, 0, array, 0, a1.length);
		System.arraycopy(a2, 0, array, a1.length, a2.length);
		return array;
	}

	/**
	 * 
	 * @param ctxPath
	 * @param path:访问的url
	 * @return
	 */
	private boolean isExtendPath(String ctxPath, String path) {
		boolean result = false;
		if (path != null)
			for (int i = 0; i < extPaths.size(); i++) {
				String url = extPaths.get(i);
				if (path.indexOf(url) >= 0) {
					result = true;
					break;
				}
			}
		return result;
	}
}
