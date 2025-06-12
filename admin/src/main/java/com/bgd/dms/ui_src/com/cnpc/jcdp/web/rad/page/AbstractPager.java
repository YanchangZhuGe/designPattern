/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.util.JavaBeanUtils;
import com.cnpc.jcdp.web.rad.util.PMDRequest;
import com.cnpc.jcdp.web.rad.util.RADConst.PMDAction;

/**
 * @author rechete
 *
 */
public abstract class AbstractPager extends HttpServlet{	
	protected ILog log = LogFactory.getLogger(getClass());
	protected HttpServletRequest request;	
	protected PrintWriter jspWriter;
	protected PrintWriter out = null;
	protected UserToken user;
	protected String contextPath;

	
	public String getContextPath() {
		return contextPath;
	}

	protected Map params = new HashMap();

	//标识是否为toJsp请求
	protected String action;
	//标识Add,Edit
	protected String pmdAction;
  
	public void setPmdAction(String pmdAction) {
		this.pmdAction = pmdAction;
	}

	protected PMDRequest stlReq;
	protected ConfigHandler tlHd;	
	
    public ConfigHandler getTlHd() {
		return tlHd;
	}

    public boolean isToJspRequest(){
    	return "toJsp".equals(action);
    }
    
	public void setStlRequest(PMDRequest req){
    	this.stlReq = req;  
    	this.tlHd = req.getTlHd();
    }
    
    public void println(String s)throws IOException{
    	print(s);
    	print("\r\n");
    }
    
    public void print(String s)throws IOException{
    	if("toJsp".equals(action)){
    		jspWriter.print(s);
    	}
    	else{
    		out.print(s);
    	}
    }
    
    protected void flush()throws IOException{
    	if("toJsp".equals(action)){
    		jspWriter.flush();
    	}
    	else{
    		out.flush();
    	}   	
    }
    

    
    

    
    public boolean isViewAction(){
    	return (pmdAction.equals(PMDAction.C_R) || pmdAction.equals(PMDAction.S_R));
    }
    
    public boolean isAddAction(){
    	return (pmdAction.equals(PMDAction.C_C) || pmdAction.equals(PMDAction.S_C));
    }
    
    public boolean isEditAction(){
    	return (pmdAction.equals(PMDAction.C_U) || pmdAction.equals(PMDAction.S_U));
    } 
    
    /**
     * 是否为主子表CRU
     * @return
     */
    public boolean isComplexAction(){
    	return (pmdAction.equals(PMDAction.C_U) || pmdAction.equals(PMDAction.C_C) || pmdAction.equals(PMDAction.C_R));
    }    
    
    protected void printSavedParams()throws IOException{
    	String savedParams = tlHd.getSingleNodeValue("SavedParams");
    	if(savedParams==null) return;
    	
    	println("");
    	println("var jcdpPageParams = {};");
    	String[] paramAr = savedParams.split(",");
    	for(int i=0;i<paramAr.length;i++){
    		addParam(paramAr[i]);
    		println("jcdpPageParams['"+paramAr[i]+"'] = '"+params.get(paramAr[i])+"';");
    	}
    	println("");
    }

    /**
     * 查找str中的$PARAM.，根据参数名从request中读取并放入params中
     * @param str
     * @param request
     */
  	protected void addParams(String str,HttpServletRequest request){
  		if(str==null) return;
  		
  		Enumeration pNames=request.getParameterNames();
		while(pNames.hasMoreElements()){
  		    String name=(String)pNames.nextElement();
  		    String value=request.getParameter(name);
	    
			if(value==null) return;
			try{
				value = new String(value.getBytes("ISO-8859-1"),"UTF-8");
			}catch(Exception ex){
				log.error(ex);
				value = "";
			}
			if("toJsp".equals(action)){
				value = "<%="+name+"%>";
			}	    			
			params.put(name, value);		
		}
	}

  		
//		Pattern pattern = Pattern.compile("\\u0024PARAM\\.");
//		Matcher matcher = pattern.matcher(str);
//		while(matcher.find()){
//			String key = matcher.group();
//			key = key.substring(7);
//			addParam(key);
///*			String value = request.getParameter(key);
//			if(value==null) continue;
//			try{
//				value = new String(value.getBytes("ISO-8859-1"),"GBK");
//			}catch(Exception ex){
//				log.error(ex);
//				value = "";
//			}
//			if("toJsp".equals(action)){
//				value = "<%="+key+"%>";
//    		}	    			
//			params.put(key, value);	*/		
//		}  		
  	
  	@SuppressWarnings("unchecked")
	private void addParam(String key){
  		String value = request.getParameter(key);
		if(value==null) return;
		try{
			value = new String(value.getBytes("ISO-8859-1"),"UTF-8");
		}catch(Exception ex){
			log.error(ex);
			value = "";
		}
		if("toJsp".equals(action)){
			value = "<%="+key+"%>";
		}	    			
		params.put(key, value);		  		
  	}
  	
  	/**
  	 * 将paramStr中的参数替换成对应的值，如果toJsp替换成<%=key%>
  	 * @param paramStr
  	 * @return
  	 */
  	protected String replaceParams(String paramStr){
  		Enumeration pNames=request.getParameterNames();
  		while(pNames.hasMoreElements()){
  			String name=(String)pNames.nextElement();
  			Pattern pattern = Pattern.compile("\\u0024PARAM\\."+name);
			Matcher matcher = pattern.matcher(paramStr);
			while(matcher.find()){
				String str = matcher.group();
				String key = str.substring(7);
				Object value = params.get(key);
				if(value!=null){
					paramStr = paramStr.replaceAll("\\u0024PARAM."+key,value.toString());
				}
			}  	
  		}
		//paramStr = replaceUserProperties(paramStr);
		return paramStr;
  	}  
  	
  	protected String replaceParamsAndUserProp(String value){
  		if(value==null) return null;
  		value = replaceUserProperties(value);
  		value = replaceParams(value);
  		value = replaceSessionProperties(value);
  		return value;
  	}
  	
  	public String replaceListExp(String value){
  		if(value==null) return null;
  		value = replaceUserProperties(value);
  		value = replaceParams(value);
  		value = replaceSessionProperties(value);
  		value = value.replaceAll("href='/", "href='"+getContextPath()+"/");
  		value = value.replaceAll("popWindow\\u0028'/", "popWindow('"+getContextPath()+"/");
  		return value;
  	}
  	
  	/**
  	 * 将默认值中的$PARAM. $USER.替换掉
  	 * @param type
  	 * @return
  	 */
  	protected String replaceUserProperties(String value){
  		if(value==null) return null;
  		ConfigHandler cfgHdl = ConfigFactory.getCfgHandler();
  		String userProperties = cfgHdl.getSingleNodeValue("//userProperties");
  		String[] upArray = userProperties.split(",");
  		for(int i=0;i<upArray.length;i++){
  			String pName = upArray[i];
  			String methodName = "get"+pName.substring(0,1).toUpperCase()+pName.substring(1);
  			if("toJsp".equals(action))
  				value = value.replaceAll("\\u0024USER."+pName, "<%=user."+methodName+"()%>");
  			else{
  				String pValue = "";
  				try{
  					if(user!=null){
  						Object obj = JavaBeanUtils.getDeclaredProperty(user, pName);
  						if(obj!=null) pValue = obj.toString();
  					}
  				}catch(Exception ex){log.error(ex);}
  				value = value.replaceAll("\\u0024USER."+pName, pValue);
  			}
  		}

  		return value;
  	} 
	/**
  	 * 将默认值中的$PARAM. $SESSION.替换掉
  	 * @param type
  	 * @return
  	 */
  	protected String replaceSessionProperties(String paramStr){
  		Pattern pattern = Pattern.compile("\\u0024SESSION.(\\w)+");
		Matcher matcher = pattern.matcher(paramStr);
		while(matcher.find()){
			String str = matcher.group();
			String key = str.substring(9);
			String pValue = "";
			if("toJsp".equals(action))
				paramStr = paramStr.replaceAll("\\u0024SESSION."+key, "<%=request.getSession().getAttribute(\""+key+"\")%>");
			else{
				try{
					if(request.getSession()!=null){
						Object obj = request.getSession().getAttribute(key);
						if(obj!=null) pValue = obj.toString();
					}
				}catch(Exception ex){log.error(ex);}
			}
			paramStr = paramStr.replaceAll("\\u0024SESSION."+key, pValue);
		}  		
		//paramStr = replaceUserProperties(paramStr);
		return paramStr;
  	} 
  	
  	public  void printPagerScript()throws IOException{
  		
  	}
}
