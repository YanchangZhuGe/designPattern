/**
 * 
 */
package com.cnpc.jcdp.webapp.util;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.cfg.SystemConfig;
import com.cnpc.jcdp.common.UserProfile;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.sais.ibp.auth2.util.GMSUserUtil;
import com.cnpc.sais.ibp.auth2.util.RoleUtil;
import com.cnpc.sais.ibp.auth2.util.UserUtil;

/**
 * @author rechete
 *
 */
public class SessionTimeOutFilter implements Filter{
	  private FilterConfig filterConfig;
	  private List<String> extPaths = new ArrayList();

	  public void destroy() { 
		  this.filterConfig = null;
	  }

	  public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
	    throws IOException, ServletException
	  {
	    HttpServletRequest req = (HttpServletRequest)request;
	    HttpServletResponse resp = (HttpServletResponse)response;
	    String ctxPath = req.getContextPath();
	  //�������������ƽ̨��ת�ķ���
  	  //���Ȼ��appcode���������appcode����Ϊpss����������Ǵ���������ƽ̨��ת������
  	  //���username��Ϣ����������������֤����ȫ���δ��û�
  	  //���ݻ�õ�username���г�������֤���Ĭ�ϵ�¼����
  	  //ͬʱ��������ת�ķ��ʷ�ʽ�Ļ�sessionʧЧ��Ҫ���½��е�¼
	    /**���ϵͳ����ҳ�������Ӵ��� ��ʼ**/
  	  String appcode = req.getParameter("appcode");
  	  if(StringUtils.isNotBlank(appcode)){
  		  appcode = Base64Util.decodeStr(appcode.replace("-", "+").replace("_", "/"));
  	  }
  	  if(StringUtils.isNotEmpty(appcode) && "pss".equals(appcode) && OMSMVCUtil.getUserToken(req)==null){
  		  //���к�̨��½
  		  //����û���
  		  String username = req.getParameter("username");
  		  if(StringUtils.isNotBlank(username)){
  			  username = Base64Util.decodeStr(username.replace("-", "+").replace("_", "/"));
  			  String loginip = req.getRemoteAddr();
  			 /* String charset =req.getSession().getAttribute(Globals.LOCALE_KEY).toString();
  			  if(StringUtils.isEmpty(charset)){
  				  charset = "UTF-8";
  			  }*/
  			  //����û�
  			  GMSUserUtil util = new GMSUserUtil();
  			  UserToken user = util.authUserNoPassword(username, loginip);
  			  if(user ==null){
  				  ((HttpServletResponse)response).sendRedirect(req.getContextPath()+ this.filterConfig.getInitParameter("loginJSP"));
  			  }else{
  				  user.setCharset("zh-CN");
  				  util.setUserProperty(user);
  				  UserUtil userUtil = new UserUtil();
  				  Map userProfile = userUtil.queryUserProfile(user.getUserId());
  				  String funcCodes = RoleUtil.getFunctionCodesByRoleIds(user.getRoleIds());
  				  //����session
  				  JcdpMVCUtil.setUserToken(req,user);
  				String userMainPage = PagerFactory.defaultMainPage;
  				  if(userProfile!=null){
  					  UserProfile profile = new UserProfile();
					  try {
						  BeanUtils.populate(profile, userProfile);
					  } catch (IllegalAccessException e) {
						  e.printStackTrace();
					  } catch (InvocationTargetException e) {
						  e.printStackTrace();
					  }
					  profile.setTptId((String) userProfile.get("tmptId"));
					  userMainPage = PagerFactory.tptMainPages.get(profile.getTptId());
					  if(userMainPage!=null && !userMainPage.trim().equals("") && !userMainPage.trim().startsWith("/")){
					  	userMainPage = "/"+userMainPage;
					  }
					  JcdpMVCUtil.setUserProfile(req,profile);
  				  }
  				  if(StringUtils.isNotBlank(funcCodes)){
  					  JcdpMVCUtil.setUserFuncCodes(req, funcCodes);
  				  }
  				  filterChain.doFilter(request, response);
  			  }
  		  }else{
  			  ((HttpServletResponse)response).sendRedirect(req.getContextPath()+ this.filterConfig.getInitParameter("loginJSP"));
  		  }
  	  }else{
  		/**���ϵͳ����ҳ�������Ӵ��� ����**/
  		if ((req != null) && JcdpMVCUtil.getUserToken(req)==null) {
  	      if (isExtendPath(ctxPath,req.getRequestURI())) {
  	        filterChain.doFilter(request, response);
  	      } else {
  			  if("rtAsync".equals(req.getHeader("rtCallTyper"))){
  	    		  JSONObject returnObject = new JSONObject();
  	    		  returnObject.put("returnCode", -9);
  	    		  returnObject.put("returnMsg", "SessionʧЧ�������µ�¼��");
  	    		  response.setContentType("text/json; charset="+SystemConfig.DEFALT_ENCODING); 
  	  			  response.getWriter().print(returnObject.toString());
  	    	  }else{
  	    		  ((HttpServletResponse)response).sendRedirect(req.getContextPath()+ this.filterConfig.getInitParameter("loginJSP"));
  	    	  }
  	      }
  	    } else {
  	    	filterChain.doFilter(request, response);
  	    }
  	  }
	  }

	  public void init(FilterConfig filterConfig)
	    throws ServletException
	  {
	    this.filterConfig = filterConfig;
	    if (filterConfig.getInitParameter("extpaths") != null)
	    {
	      String[] _extPaths = filterConfig.getInitParameter("extpaths").trim().split(",");
	      if (_extPaths != null)
	      {
	        for (int index = 0; index < _extPaths.length; ++index)
	        {
	          this.extPaths.add(_extPaths[index].trim());
	        }
	      }
	    }
	  }

	  /**
	   * 
	   * @param ctxPath
	   * @param path:���ʵ�url
	   * @return
	   */
	  private boolean isExtendPath(String ctxPath,String path)
	  {
	    boolean result = false;
	    
	    if (path!=null) 	 
		    for (int i = 0; i < extPaths.size(); i++){
		      String url = ctxPath+extPaths.get(i);
		      if (path.indexOf(url)>=0){
			      result = true;
			      break;		    	  
		      }
		    }

	    return result;
	  }
	  

}
