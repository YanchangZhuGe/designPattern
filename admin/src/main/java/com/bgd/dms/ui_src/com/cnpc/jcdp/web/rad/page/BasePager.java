/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.PMDRequest;
import com.cnpc.jcdp.web.rad.util.RADConst.PMDAction;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;

/**
 * @author rechete
 * Revision History:
 * 2011.04.05 rechete
 * public boolean hasAuth(String funcCode) 将funcCode中的,V和,A过滤掉
 */
public abstract class BasePager extends AbstractPager{	
	protected int cruTableHeight;
	protected BaseTmpt tpt;

	protected Map pmdJsFuncNames = new HashMap();
	
	public void setTpt(BaseTmpt tpt) {
		this.tpt = tpt;
	}
	
	public int getCruTableHeight(){
		return cruTableHeight;
	}

	protected void addFieldParams(HttpServletRequest request, HttpServletResponse response)throws Exception{
		List<ICfgNode> nodes = tlHd.selectNodes("//EntityFields/field");
		if(nodes==null) return;
		for(int i=0;i<nodes.size();i++){
			String defaultValue = nodes.get(i).getAttrValue("defaultValue");
			if(defaultValue!=null) addParams(defaultValue,request);
		}
    }
	
	/**
	 * 将pmd页面中定义的函数名称写入pmdJsFuncNames
	 * @param jsStr：pmd文件中获取的js字符串
	 * @param funcNames：关注的函数名称，格式如page_init()
	 */
	protected void addJsFuncs(String jsStr,List<String> funcNames){
		for(int i=0;i<funcNames.size();i++){
			if(jsStr.indexOf("function "+funcNames.get(i)+"{")>=0){
//				System.out.println("---------------------------------------------------"+funcNames.get(i));
				pmdJsFuncNames.put(funcNames.get(i), "true");
			}
		}
	}	
	
    /**
     * 编码表定义
     * @throws IOException
     */
    protected void printJcdpCodes()throws IOException{
  		print("var jcdp_codes_items = null;\r\n");
  		print("var jcdp_codes = new Array(\r\n");
  		List<ICfgNode> nodes = tlHd.selectNodes("//Codes/Code");
  		if(nodes!=null){  		
	  		StringBuffer sb = new StringBuffer("");
	  		if(nodes!=null)
		  		for(int i=0;i<nodes.size();i++){
		  			ICfgNode node = nodes.get(i);
		  			if(i>0) sb.append(",\r\n");
		  			sb.append("['"+node.getAttrValue("name")+"','"+node.getValue()+"'");
		  			String sql = null;
		  			String b_code_id = node.getAttrValue("b_code_id");
		  			String sais_code_name = node.getAttrValue("sais_code_name");
		  			if(sais_code_name!=null){
		  				ICfgNode codeNode = PagerFactory.getCodeNode(sais_code_name);
		  				b_code_id = codeNode.getAttrValue("b_code_id");
		  				if(b_code_id==null){
		  					sql = codeNode.getAttrValue("sql");
		  				}
		  			}
		  			
	  				if(b_code_id!=null){
		  				sql = "SELECT item_c_name AS label,item_id AS value FROM b_code_item WHERE parent_id='"+b_code_id+"' ORDER BY show_seq";
		  			}
	  				else if(sql==null) sql = node.getAttrValue("sql");		  			
		  			if(sql!=null){
		  				//对code中的SQL进行$USER $PARM $SESSION等信息过滤
		  				sql=super.replaceParamsAndUserProp(sql);
		  				sb.append(",\""+sql+"\"");
		  				String fdName = node.getAttrValue("fdName");
		  				if(fdName!=null) sb.append(",'"+fdName+"'");
		  			}
		  			sb.append("]");
		  		}
	  		print(sb.toString()); 
  		}
        print(");\r\n");
        print("\r\n");  	
    }
    
    protected void printSelOptions()throws IOException{
    	List<ICfgNode> selNodes = tlHd.selectNodes("Options/Select");
    	if(selNodes==null) return;
  		for(int i=0;i<selNodes.size();i++){
  			ICfgNode selNode = selNodes.get(i);
  			print("var "+selNode.getAttrValue("name")+" = new Array(\r\n");
  			String sais_select_name = selNode.getAttrValue("sais_select_name");
  			if(sais_select_name!=null){
  				print(PagerFactory.getOptionsStr(selNode.getAttrValue("name"))+"\r\n");
  			}
  			else{
	  			List<ICfgNode> options = selNode.selectNodes("option");  
	  			StringBuffer optionSb = new StringBuffer("");
	  			for(int j=0;j<options.size();j++){
	  				ICfgNode option = options.get(j);
	  				if(j>0) optionSb.append(",");
	  				optionSb.append("['"+option.getAttrValue("value")+"','"+option.getValue()+"']");
	  			}
	  			print(optionSb.toString()+"\r\n");
  			}
  			print(");\r\n\r\n");
  		}    	
    }
    

  	
  	
  	

  	

  	

  	
  	/**
  	 * 
  	 * @param titleType 
  	 */
  	protected void printTitle(int titleType)throws IOException{
  		switch(titleType){
  		case RADConst.TitleType.TAB:
			  print("<!--Remark 标题-->\r\n");
			  print("<div id=\"nav\">\r\n");
			  print("    <ul><li id=\"cruTitle\" class=\"bg_image_onclick\"></li></ul>\r\n");
			  print("</div>\r\n");
			  print("\r\n");  			
  			break;
  		case RADConst.TitleType.Hint:
  	        print("<div id=\"hintTitle\">\r\n");
  	        print("<span id=\"cruTitle\"></span>\t\r\n");
  	        print("</div>\r\n");     
  	        print("<div>\r\n");
  	        print("<span id=\"cruTitle\"></span>\t\r\n");
  	        print("</div>\r\n");   			
  			break;  	
  		case RADConst.TitleType.SUB_Hint:
  	        print("<div id=\"subHintTitle\">\r\n");
  	        print("<span id=\"cruTitle\"></span>\t\r\n");
  	        print("</div>\r\n");      print("<div>\r\n");
  	        print("<span id=\"cruTitle\"></span>\t\r\n");
  	        print("</div>\r\n");   			
  			break;    			
  		} 
        print("\r\n");
  	}
  	
    /**
     * 从sql及EntityFields的默认值中取PARAM.参数并预处理
     * @param request
     * @param response
     * @throws Exception
     */
    private void beforeProcess(HttpServletRequest request, HttpServletResponse response)throws Exception{   	
    	action = request.getParameter("action");
    	if("toJsp".equals(action)){
    		String fileName = stlReq.getFileName();
    		fileName = fileName.substring(1,fileName.length()-4)+"jsp";
    		jspWriter = new PrintWriter(RADConst.WEB_ROOT+fileName);
    		
    		contextPath = "<%=contextPath%>";
    		println("<%@ page contentType=\"text/html;charset=GBK\"%>");
    		println("<%@page import=\"com.cnpc.jcdp.common.UserToken\"%>");
    		println("<%@page import=\"com.cnpc.jcdp.webapp.util.OMSMVCUtil\"%>");
    		println("<%");
    		println("\tString contextPath = request.getContextPath();");
    		println("\tUserToken user = OMSMVCUtil.getUserToken(request);");
    		
    		Object[] keys = params.keySet().toArray();
			for(int i=0;i<keys.length;i++){
				String key = keys[i].toString();
				params.put(key, "<%="+key+"%>");
				println("\tString "+key+" = request.getParameter(\""+key+"\");");
			}   		
    		println("%>");
    	}
    }  	
    
    public boolean hasAuth(String funcCode){
    	//F_IBP_AUTH_001,A 加,A表示进行功能权限验证
    	if(!funcCode.contains(",A")) return true;
    	
    	funcCode = funcCode.split(",")[0];
    	return JcdpMVCUtil.hasPermission(funcCode, request);
    }
  	
    public void service(HttpServletRequest request, HttpServletResponse response)
		throws java.io.IOException, ServletException {
		try{
	    	//out = response.getOutputStream();
	    	this.request = request;
	    	response.setCharacterEncoding("GBK");
	    	out = response.getWriter();
	    	contextPath = request.getContextPath();
	    	user = OMSMVCUtil.getUserToken(request);
	    	
	    	List<ICfgNode> nodes = tlHd.selectNodes("//EntityFields/field");
	    	if(nodes!=null)
		    	for(int i=0;i<nodes.size();i++){
		    		String dftValue = nodes.get(i).getAttrValue("defaultValue");
		    		if(dftValue==null || "".equals(dftValue.trim())) continue;
		    		Pattern pattern = Pattern.compile("\\u0024PARAM.(\\w)+");
		    		Matcher matcher = pattern.matcher(dftValue);
		    		while(matcher.find()){
		    			String key = matcher.group();
		    			key = key.substring(7);
		    			String value = request.getParameter(key);
		    			if("toJsp".equals(action)){
		    				value = "<%="+key+"%>";
		        		}	    			
		    			params.put(key, value);
		    		}
		    	}
	    	
			initPager(request,response);
			beforeProcess(request,response);
			process(request,response);
		}catch(Exception ex){
			log.error(ex);
		}
    }  	
    
    protected abstract void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception;

    protected abstract void process(HttpServletRequest request, HttpServletResponse response)
  		throws java.io.IOException, ServletException ;
    
}
