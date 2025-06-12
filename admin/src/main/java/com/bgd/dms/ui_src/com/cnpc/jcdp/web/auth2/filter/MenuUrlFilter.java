package com.cnpc.jcdp.web.auth2.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;

@SuppressWarnings("unused")
public class MenuUrlFilter implements Filter
{
	
	private FilterConfig filterConfig;

	private static  Map<String, String> menuUserCache = new Hashtable<String,String>();

	private String excludePath = "";

	private static String sql ="SELECT t.menu_url, p.user_id\n" +
						"  FROM P_AUTH_MENU_DMS t\n" + 
						"  LEFT JOIN (SELECT pur.user_id, prm.menu_id\n" + 
						"               FROM p_auth_role_dms      pr,\n" + 
						"                    p_auth_role_menu_dms prm,\n" + 
						"                    P_AUTH_USER_ROLE_DMS pur\n" + 
						"              WHERE pur.role_id = pr.role_id\n" + 
						"                AND pr.role_id = prm.role_id) p\n" + 
						"    ON p.menu_id = t.menu_id\n" + 
						" WHERE t.menu_url IS NOT NULL\n" + 
						"   AND NOT EXISTS\n" + 
						" (SELECT 1\n" + 
						"          FROM (SELECT m.menu_url\n" + 
						"                  FROM P_AUTH_MENU_DMS m, p_auth_role_menu_dms r\n" + 
						"                 WHERE r.role_id = '"+AuthConstant.COMMON_ROLE_ID+"'\n" + 
						"                   AND r.menu_id = m.menu_id\n" + 
						"                   AND m.menu_url IS NOT NULL) m\n" + 
						"         WHERE m.menu_url = t.menu_url)";

	public void doFilter(ServletRequest req, ServletResponse resp,
			FilterChain filterChain) throws IOException, ServletException {
		HttpServletRequest hreq = (HttpServletRequest) req;
		HttpServletResponse hresp = (HttpServletResponse) resp;
		UserToken userToken = OMSMVCUtil.getUserToken(hreq);
		String hreqUrl = hreq.getServletPath();
		if(menuUserCache.size() == 0 ){
			refreshMenuUserCache();
		}
		if (isExcludePath(hreqUrl) || !menuUserCache.containsKey(hreqUrl) || userToken != null && userToken.getRoleIds().indexOf(AuthConstant.SUPER_ROLE_ID) >= 0) {
			filterChain.doFilter(req, resp);
		} else {
			if (userToken != null && menuUserCache.get(hreqUrl).indexOf("@" + userToken.getUserId()) < 0) {
				hresp.setCharacterEncoding("UTF-8");
				hresp.setContentType("text/html; charset=UTF-8");
				PrintWriter out = hresp.getWriter();
				if (out != null) {
					out.println("<script>alert('JCDP_forbid');if(top.window !== window){window.close();}else{window.location.href=\""
									+ hreq.getScheme()
									+ "://"
									+ hreq.getServerName()
									+ ":"
									+ hreq.getServerPort()
									+ hreq.getContextPath() + "/\";}</script>");
					out.flush();
					out.close();
				}
			} else {
				filterChain.doFilter(req, resp);
			}
		}
	}

	private boolean isExcludePath(String hreqUrl) {
		return false;
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
		if (filterConfig.getInitParameter("extpaths") != null) {
			this.excludePath = filterConfig.getInitParameter("extpaths").trim();
		}
	}

	public void destroy() {
		filterConfig = null;
		menuUserCache = null;
		sql = null;
	}
	public static  void refreshMenuUserCache() {
		Map<String, StringBuffer> temp = new HashMap<String, StringBuffer>();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<Map> result = jdbcDao.queryRecords(sql);
		for (Map<String, String> m : result) {
			String menuUrl = m.get("menu_url");
			if(menuUrl != null){
				menuUrl = menuUrl.startsWith("/") ? m.get("menu_url") : "/" + m.get("menu_url");
				if (!temp.containsKey(menuUrl)) {
					temp.put(menuUrl, new StringBuffer());
				}
				if(!"".equals(StringUtils.trimToEmpty(m.get("user_id")))){
					temp.get(menuUrl).append("@" + m.get("user_id"));
				}
			}
		}
		menuUserCache.clear();
		for (Entry<String, StringBuffer> entry : temp.entrySet()) {
			menuUserCache.put(entry.getKey(), entry.getValue().toString());
		}
	}
}
