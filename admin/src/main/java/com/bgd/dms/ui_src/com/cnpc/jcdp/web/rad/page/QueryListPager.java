/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.SkipPageException;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.PMDRequest;
import com.cnpc.jcdp.web.rad.util.RADUtil;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.RECORD_SEL_TYPE;
//import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;

/**
 * @author rechete
 *
 */
public class QueryListPager extends BasePager{
	//列表类型:普通列表，关系选择列表，外键选择列表，主子表1的子表列表
	//protected enum LISTTYPE  {List2View,List2Sel,List2Link,List2Compose};
	private String sql;
	
	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}

	public QueryListPager(){
		pmdAction = RADConst.PMDAction.M_S;
	}
	
	//默认有查询条件
	protected boolean hasCdts = true;

	public void setHasCdts(boolean hasCdts) {
		this.hasCdts = hasCdts;
	}

	protected LISTTYPE listType;
	
	public LISTTYPE getListType(){
		return listType;
	}

    public boolean isList2Compose() {
		return listType==LISTTYPE.List2Compose;
	}
    
    public boolean hasQueryCdts(){
    	return hasCdts;
    }

	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
    	List<ICfgNode> nodes = tlHd.selectNodes("//QueryCondition/cdt_fields/field");
    	if(nodes==null || nodes.size()==0) {
//    		hasCdts = false;
    		this.setHasCdts(false);
    	}
    	
//    	sql = tlHd.getSingleNodeValue("//QuerySQL/sql");
//    	sql = RADUtil.deleteLineFeed(sql);
//    	addParams(sql,request); 
    	
    	String sql1 = tlHd.getSingleNodeValue("//QuerySQL/sql");
    	this.setSql(RADUtil.deleteLineFeed(sql1));
    	addParams(this.getSql(),request);
    	
    	List<ICfgNode> buttonNodes = tlHd.selectNodes("//Buttons/Button");
    	if(buttonNodes!=null)
	    	for(int i=0;i<buttonNodes.size();i++)
	    		addParams(buttonNodes.get(i).getValue(),request); 
    	if("listItems".equals(request.getParameter("pagerAction"))) listType = LISTTYPE.List2Compose;
    	else listType = LISTTYPE.List2View;
    }
    
    public void process(HttpServletRequest request, HttpServletResponse response)
  	throws java.io.IOException, ServletException {
  	  try {
		  response.setContentType("text/html;charset=GBK");
		  response.setHeader("Pragma","No-cache"); 
		  response.setHeader("Cache-Control","no-cache"); 
		  response.setDateHeader("Expires", 0);
		  tpt.printHeader();		  
		  tpt.printBody();
	  } catch (Throwable t) {
		  t.printStackTrace();
	  } finally {
		 if(out!=null) flush();
	  }
    }
    
    public  void printPagerScript()throws IOException{
        if("toJsp".equals(action)){
      	  print("<%@ include file=\"/common/pmd_list.jsp\"%>\r\n");
        }
        else{
  	      print("<script type=\"text/javascript\" src=\"");
  	      print(contextPath);
  	      print("/js/rt/rt_list.js\"></script>  \r\n");
  	      print("<script type=\"text/javascript\" src=\"");
  	      print(contextPath);
  	      print("/js/rt/rt_base.js\"></script>\r\n");
  	      print("<script type=\"text/javascript\" src=\"");
  	      print(contextPath);
  	      print("/js/rt/rt_validate.js\"></script>\r\n");  	      
  	      print("<script type=\"text/javascript\" src=\"");
  	      print(contextPath);
  	      print("/js/rt/rt_search.js\"></script>\r\n");
  	      print("<script type=\"text/javascript\" src=\"");
  	      print(contextPath);
  	      print("/js/json.js\"></script>\r\n");      
  	      print("\r\n");
        }
        if(listType!=LISTTYPE.List2View) print("<title>选择页面</title>\r\n");
        else print("<title>列表页面</title>\r\n");
        print("</head>\r\n");
        print("<script language=\"javaScript\">\r\n");
        print("<!--Remark JavaScript定义-->\r\n");
        printJavaScript(request);
        print("</script>\r\n");
        if(listType==LISTTYPE.List2Link)println("<base target=\"_self\">"); 
        print("\r\n");    	
    }
    

	protected void printPmdJs()throws IOException{
  	    String jsStr = tlHd.getSingleNodeValue("//JavaScripts");  	    
  	    if(jsStr==null) return;
    	println(jsStr);
    	
    	List<String> funcNames = new ArrayList();
    	funcNames.add("page_init()");
    	funcNames.add("onlineEdit(rowParams)");    	
    	funcNames.add("cmpQuery()");
    	funcNames.add("classicQuery()"); 
    	funcNames.add("basicQuery()");    
    	List<ICfgNode> nodes = tlHd.selectNodes("//Buttons/Button");
  		if(nodes!=null)
	        for(int i=0;i<nodes.size();i++){
	        	ICfgNode node = nodes.get(i);
	        	funcNames.add(getButtonJsFuncName(node,i));
	        }
	        
    	addJsFuncs(jsStr,funcNames);   
	}  
  
  	protected void printJavaScript(HttpServletRequest request)throws IOException{
  		String pageTitle = tlHd.getSingleNodeValue("//PageTitle");
//  		print("var JSON = {}; \r\n");
//  		print("JSON.objectToJSONString = Object.prototype.toJSONString; \r\n");

  		print("var pageTitle = \""+pageTitle+"\";\r\n");
  		print("cruConfig.contextPath =  \""+contextPath+"\";\r\n");
  		
  		printSavedParams();
  		
  		printSelOptions();
  		printJcdpCodes();

  		printPageInit();
        
        //按钮栏的js函数
        printButtonJs(request);
        printPmdJs();
        if(!hasQueryCdts()) return;        
        //打印查询条件和查询函数
  		List<ICfgNode> nodes = tlHd.selectNodes("//QueryCondition/cdt_fields/field");
  	    print("var fields = new Array();\r\n");
  	    for(int i=0;i<nodes.size();i++){
  	    	ICfgNode node = nodes.get(i);
  	    	StringBuffer sb = new StringBuffer("fields["+i+"] = ['");
  	    	sb.append(node.getAttrValue("name")+"','"+node.getValue());
  	    	String type = node.getAttrValue("type");
  	    	if(type==null) type = "TEXT";
  	    	sb.append("','"+type+"'");  	    	
  	    	
  	    	String maxLength = node.getAttrValue("maxLength");
  	    	if(maxLength!=null) sb.append(",'"+maxLength+"'");
  	    	else sb.append(",");
  	    	
  	    	String size = node.getAttrValue("size");
  	    	if(size!=null) sb.append(",'"+size+"'");
  	    	else sb.append(",");
  	    	
  	    	String selType = node.getAttrValue("selType");  	    	
  	    	if(selType!=null){  
  	    		String selValue = node.getAttrValue("selValue");
  	    		if(selValue!=null){
  	    			if(!"SEL_OPs".equals(selType)) selValue = "'"+selValue+"'";
  	    			sb.append(",'"+selType+"',"+selValue);
  	    		}
   	    	}
  	    	
  	    	while(sb.charAt(sb.length()-1)==',') sb.deleteCharAt(sb.length()-1);
  	    	
  	    	sb.append("];\r\n");
  	    	print(sb.toString());
  	    }
  	    print("\t\r\n");
  	    
  	    print("function basicQuery(){\r\n");
  	    print("\tvar qStr = generateBasicQueryStr();\r\n");
  	    print("\tcruConfig.cdtStr = qStr;\r\n");  	    
  	    print("\tqueryData(1);\r\n");
  	    print("}\r\n");
  	    print("\r\n");
  	    print("\r\n");
  	    
  	    print("function cmpQuery(){\r\n");
  	    print("\tvar qStr = generateCmpQueryStr();\r\n");
  	    print("\tcruConfig.cdtStr = qStr;\r\n");
  	    print("\tqueryData(1);\r\n");  	    
  	    print("}\r\n");
  	    print("\r\n"); 
  	    
  	    print("function classicQuery(){\r\n");
  	    print("\tvar qStr = generateClassicQueryStr();\r\n");
  	    print("\tcruConfig.cdtStr = qStr;\r\n");
  	    print("\tqueryData(1);\r\n");  	    
  	    print("}\r\n");
  	    print("\r\n");   	    
  	    
  	    if(!pmdJsFuncNames.containsKey("onlineEdit(rowParams)")){
	  	    print("function onlineEdit(rowParams){\r\n");
		    print("\tvar path = cruConfig.contextPath+cruConfig.editAction;\r\n");
		    print("\tObject.prototype.toJSONString =JSON.objectToJSONString; \r\n");
		    print("\tvar params = cruConfig.editTableParams+\"&rowParams=\"+rowParams.toJSONString();\r\n");
		    print("\tvar retObject = syncRequest('Post',path,params);\r\n");
		    print("\tif(retObject == null) return false;\r\n");
		    println("\tif(retObject.returnCode!=0){");
		    println("\t\talert(retObject.returnMsg);");
		    println("\t\treturn false;");
		    println("\t}else return true;");
		    println("}");
		    println(""); 
  	    }
  	}
  	
  	public String getButtonJsFuncName(ICfgNode node,int i){
  		String ret = null;
  		if("Add".equals(node.getAttrValue("Type"))) ret = "toAdd()";
  		else if("Edit".equals(node.getAttrValue("Type"))) ret = "toEdit()";
  		else if("View".equals(node.getAttrValue("Type"))) ret = "toView()";
  		else if("Delete".equals(node.getAttrValue("Type"))) ret = "toDelete()";
  		else if("Back".equals(node.getAttrValue("Type"))) ret = "toBack()";  
  		else ret = "JcdpButton"+i+"OnClick()";
  		return ret;
  	}
  	
  	/**
  	 * 输出按钮栏的js函数
  	 */
  	protected void printButtonJs(HttpServletRequest request)throws IOException{
  		PAGER_OPEN_TYPE open_type = tpt.getOPEN_TYPE();
  		List<ICfgNode> nodes = tlHd.selectNodes("//Buttons/Button");
  		if(nodes==null) return;
  		String jsFuncName = null;
        for(int i=0;i<nodes.size();i++){
        	ICfgNode node = nodes.get(i);
        	jsFuncName = getButtonJsFuncName(node,i);
        	if(pmdJsFuncNames.get(jsFuncName)!=null) continue;
        	if("Add".equals(node.getAttrValue("Type"))){
                print("function "+jsFuncName+"{\r\n");
                String addUrl = node.getValue();
                if(addUrl.startsWith("/"))
                	addUrl = contextPath+addUrl;
                addUrl = super.replaceParams(addUrl);
                if(addUrl.indexOf("?")<=0) addUrl += "?";  
                else addUrl += "&";
                addUrl += "pagerAction=edit2Add";                
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	println("\twindow.location='"+addUrl+"&backUrl='+cruConfig.currentPageUrl;");
                }
                else{
                	String size = node.getAttrValue("size");
                	print("\tpopWindow(\""+addUrl+"\"");
	                if(size!=null) print(",\""+size+"\"");
	                print(");\r\n");
                }
                print("}\r\n");
                print("\r\n");         		
        	}
        	else if("Edit".equals(node.getAttrValue("Type"))){
        		print("function "+jsFuncName+"{\r\n");
                print("\tids = getSelIds('chx_entity_id');\r\n");
                print("\tif(ids==''){\r\n");
                print("\t\talert(\"请先选中一条记录!\");\r\n");
                print("\t\treturn;\r\n");
                print("\t}\r\n");                
                print("\tselId = ids.split(',')[0];\r\n");
                String editUrl = node.getValue();
                if(editUrl.startsWith("/"))
                	editUrl = contextPath+editUrl;                
                if(editUrl.indexOf("?")<=0) editUrl += "?"; 
                if(editUrl.indexOf("id={id}")<=0) editUrl += "id={id}";               	 
                print("\teditUrl = \""+editUrl+"\";\r\n");
                print("\teditUrl = editUrl.replace('{id}',selId);\r\n");
                print("\teditUrl += '&pagerAction=edit2Edit';\r\n");
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	println("\twindow.location=editUrl+\"&backUrl=\"+cruConfig.currentPageUrl;");
                }
                else{
                	print("\tpopWindow(editUrl);\r\n");  
                }         
                print("}\r\n");
                print("\r\n");         		
        	}         
        	else if("View".equals(node.getAttrValue("Type"))){
        		print("function "+jsFuncName+"{\r\n");
                print("\tids = getSelIds('chx_entity_id');\r\n");
                print("\tif(ids==''){\r\n");
                print("\t\talert(\"请先选中一条记录!\");\r\n");
                print("\t\treturn;\r\n");
                print("\t}\r\n");                
                print("\tselId = ids.split(',')[0];\r\n");
                String editUrl = node.getValue();
                if(editUrl.startsWith("/"))
                	editUrl = contextPath+editUrl;                
                if(editUrl.indexOf("?")<=0) editUrl += "?"; 
                if(editUrl.indexOf("id={id}")<=0) editUrl += "id={id}";               	 
                print("\teditUrl = \""+editUrl+"\";\r\n");
                print("\teditUrl = editUrl.replace('{id}',selId);\r\n");
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	println("\twindow.location=editUrl+\"&backUrl=\"+cruConfig.currentPageUrl;");
                }
                else{
                	print("\tpopWindow(editUrl);\r\n");  
                }         
                print("}\r\n");
                print("\r\n");         		
        	}               	
        	else if("Delete".equals(node.getAttrValue("Type"))){
        		print("function "+jsFuncName+"{\r\n");
        		String funcCode = node.getAttrValue("funCode");
        		String sql = node.getValue();
        		sql = super.replaceParamsAndUserProp(sql);
        		//业务一致性验证 
        		if(funcCode!=null && funcCode.contains(",V")){
        			print("\tdeleteEntities(\""+sql+"\",\""+funcCode.split(",")[0]+"\");\r\n");
        		}
        		else print("\tdeleteEntities(\""+sql+"\");\r\n");
                print("}\r\n");
                print("\r\n");  
        	}
            else if("Back".equals(node.getAttrValue("Type"))){
            	print("function "+jsFuncName+"{\r\n");
                print("\twindow.history.back(-1);;\r\n");
                print("}\r\n");
                print("\r\n");         		
           }
            else if("link".equals(node.getAttrValue("Type"))){
            	print("function "+jsFuncName+"{\r\n");
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	println("\twindow.location=\""+node.getValue()+"\";");
                }
                else{
                	print("\tpopWindow(\""+node.getValue()+"\");\r\n");  
                }                  
                print("}\r\n");
                print("\r\n");         		
            }        	
           else {
        	   print("function "+jsFuncName+"{\r\n");
                print("\tupdateEntitiesBySql(\""+node.getValue()+"\",\""+node.getAttrValue("Label")+"\");\r\n");
                print("}\r\n");
                print("\r\n");         		
           }
        }
  	}
  	
  	
  	public List<String> getColDatas(){
  		List ret = new ArrayList();
  		List<ICfgNode> nodes = tlHd.selectNodes("DataList/data");
  		for(int i=0;i<nodes.size();i++){
			ICfgNode node = nodes.get(i);
			String exp = node.getAttrValue("exp");
			if(exp!=null && exp.indexOf("type='checkbox'")>0 && exp.indexOf("name='chx_entity_id'")>0 && tpt.getSel_type()==RECORD_SEL_TYPE.RadioButton){
				//exp = "<input type='radio' id='headChxBox' name='chx_entity_id' value='{func_id}'>";
				String pageSelType = request.getParameter("pageSelType");
				if(!("CheckBox".equals(pageSelType) || RADConst.PMDAction.L2S.equals(pmdAction)))
					exp = exp.replace("type='checkbox'", "type='radio'");
			}
			else {
				exp = exp.replaceAll("href='//", "href='"+contextPath+"/");
				if(tpt.getOPEN_TYPE()==PAGER_OPEN_TYPE.LINK)
					exp = exp.replaceAll("popWindow\\u0028'", "link2self('");
				else exp = exp.replaceAll("popWindow\\u0028'", "popWindow('");
			}
			StringBuffer sb = new StringBuffer("\t exp=\""+exp+"\"");
			if(node.getAttrValue("func")!=null)
				sb.append(" func=\""+node.getAttrValue("func")+"\"");
			if(node.getAttrValue("isShow")!=null){
				sb.append(" isShow=\""+node.getAttrValue("isShow")+"\"");
				if("Hide".equals(node.getAttrValue("isShow")) || "TextHide".equals(node.getAttrValue("isShow")))
					sb.append(" style=\"display:none\"");
			}
			if(node.getAttrValue("fieldName")!=null)
				sb.append(" fieldName=\""+node.getAttrValue("fieldName")+"\"");
			if(node.getAttrValue("size")!=null)
				sb.append(" size=\""+node.getAttrValue("size")+"\"");			
			sb.append(">");
			if(exp!=null && exp.indexOf("type='checkbox'")>0 && exp.indexOf("name='chx_entity_id'")>0 && tpt.getSel_type()==RECORD_SEL_TYPE.Checkbox){
				sb.append("<input type='checkbox' id='headChxBox' onclick=\"head_chx_box_changed(this)\">");
			}
			else sb.append(node.getValue());
			sb.append("</td>");
			ret.add(sb.toString());
		} 	   
  		return ret;
  	}
  	
  	
  	private void printQueryList()throws IOException{
  		List<ICfgNode> nodes = tlHd.selectNodes("DataList/data");
 		
	    print("<div style=\"OVERFLOW-y:scroll;\">\r\n");
	    print("<table class=\"rtTable\" id=\"queryRetTable\"");
	    
	    print(">\r\n");
	    print("<thead>\r\n");
	    print("<tr>\r\n");	    
		for(int i=0;i<nodes.size();i++){
			ICfgNode node = nodes.get(i);
			String exp = node.getAttrValue("exp");
			exp = exp.replaceAll("href='/", "href='"+contextPath+"/");
			exp = exp.replaceAll("popWindow\\u0028'/", "popWindow('"+contextPath+"/");
			StringBuffer sb = new StringBuffer("\t<td exp=\""+exp+"\"");
			if(node.getAttrValue("func")!=null)
				sb.append(" func=\""+node.getAttrValue("func")+"\"");
			if(node.getAttrValue("isShow")!=null){
				sb.append(" isShow=\""+node.getAttrValue("isShow")+"\"");
				if("Hide".equals(node.getAttrValue("isShow")) || "TextHide".equals(node.getAttrValue("isShow")))
					sb.append(" style=\"display:none\"");
			}
			if(node.getAttrValue("fieldName")!=null)
				sb.append(" fieldName=\""+node.getAttrValue("fieldName")+"\"");
			if(node.getAttrValue("size")!=null)
				sb.append(" size=\""+node.getAttrValue("size")+"\"");			
			sb.append(">");
			if(exp!=null && exp.indexOf("type='checkbox'")>0 && exp.indexOf("name='chx_entity_id'")>0){
				sb.append("<input type='checkbox' id='headChxBox' onclick=\"head_chx_box_changed(this)\">");
			}
			else sb.append(node.getValue());
			sb.append("</td>\r\n");
			print(sb.toString());
		} 	    
/*	    print("\t<td data_id=\"serviceName\">姓名</td>\r\n");
	    print("\t<td data_id=\"createTime\">生日</td>\r\n");
	    print("\t<td data_id=\"age\">性别</td>\r\n");
	    print("\t<td data_id=\"userId\">英语</td>\r\n");
	    print("\t<td data_id=\"roleId\">历史</td>\r\n");*/
	    print("</tr>\r\n");
	    print("</thead>\r\n");
	    print("</table>\r\n");
	    print("</div>\r\n");
	    print("\r\n");	  
  	}  
  	
  	protected void printButtons()throws IOException{
  		//不是列表查看页面，无上面的新增、编辑、删除按钮，返回
  		if(listType!=LISTTYPE.List2View) return;
  		
  		List<ICfgNode> nodes = tlHd.selectNodes("//Buttons/Button");
  		if(nodes==null || nodes.size()==0) return;
        print("<div id=\"div_button\">\r\n");
        print("<table  cellSpacing=0 cellPadding=0 border=0 >\r\n");
        print("<tr>\r\n");
        print("<td>\r\n");
  		
  		
	        for(int i=0;i<nodes.size();i++){
	        	ICfgNode node = nodes.get(i);
	        	if("Add".equals(node.getAttrValue("Type")))
	        		print("<input class=\"button general\" type=\"button\" value=\"添加\" onClick=\"toAdd()\">\r\n");
	        	else if("Edit".equals(node.getAttrValue("Type")))
	        		print("<input class=\"button general\" type=\"button\" value=\"编辑\" onClick=\"toEdit()\">\r\n");
	        	else if("Delete".equals(node.getAttrValue("Type")))
	        		print("<input class=\"button prompt\" type=\"button\" value=\"删除\" onClick=\"toDelete()\">\r\n");
	        	else if("Back".equals(node.getAttrValue("Type")))
	        		print("<input class=\"button other\" type=\"button\" value=\"返回\" onClick=\"toBack()\">\r\n");
	        	else 
	        		print("<input class=\"button other\" type=\"button\" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
	        	
	        }        
        
        
/*        print("<input class=\"button general\" type=\"button\" value=\"添加\" onClick=\"add()\">\r\n");
        print("<input class=\"button general\" type=\"button\" value=\"编辑\" onClick=\"edit()\">\r\n");
        print("<input class=\"button prompt\" type=\"button\" value=\"删除\" onClick=\"doBillDelete('purchase',getObj('entity').value)\">\r\n");
        print("<input class=\"button other\" type=\"button\" value=\"详情\" onClick=\"doBillDetail('purchase',getObj('entity').value,1000,700)\">\r\n");
        print("<input class=\"button other\" type=\"button\" value=\"导出\" onClick=\"doExport(getObj('entity').value,600,500)\">\r\n");
*/        
        print("</td>\r\n");
        print("</tr>\r\n");
        print("</table>\r\n");
        print("</div>\r\n");
        print("\r\n");  		
  	}
  
    
    /**
     * 用于列表选择页面时，打印确认按钮
     * @throws IOException
     */
    protected void printOtherButton()throws IOException{}
    
  	/**
  	 * 用于列表选择页面时，重载该方法
  	 * @throws IOException
  	 */  	
    protected void printPageInit()throws IOException{
    	if(pmdJsFuncNames.get("page_init()")!=null) return;
  	    //String sql = tlHd.getSingleNodeValue("//QuerySQL/sql");

        print("function page_init(){\r\n");
        print("\tvar titleObj = getObj(\"cruTitle\");\r\n");
        print("\tif(titleObj!=undefined) titleObj.innerHTML = pageTitle;\r\n");
  	    //print("\tcruConfig.contextPath = \""+contextPath+"\";\r\n"); 
  	    String funcCode = tlHd.getSingleNodeValue("QuerySQL/funcCode");
  	    if(funcCode!=null){
  	    	print("\tcruConfig.funcCode = \""+funcCode+"\";\r\n"); 
  	    }
  	    
  	    //add for service call
  	    //2010.10.20 by rechete
  	    String opName = tlHd.getSingleNodeValue("QueryService/opName");
  	    if(opName!=null){  	    	 
  	    	String srvName = tlHd.selectSingleNode("QueryService").getAttrValue("name");
  	    	println("\tcruConfig.queryService = '"+srvName+"';\r\n"); 
  	    	println("\tcruConfig.queryOp = '"+opName+"';\r\n"); 
  	    }
  	    //end
  	    
  	    if(tpt.getCdt_type()==QUERY_CDT_TYPE.FORM)
  	    	println("\tcruConfig.cdtType = 'form';");  
    	if(listType==LISTTYPE.List2Link){
    		println("\tcruConfig.cruAction = 'list2Link';");  
      	}  	    
  	    if(listType==LISTTYPE.List2Sel){
  	    	println("\tvar submitStr = \"toSelColumnName="+tlHd.getSingleNodeValue("//QuerySQL/toSelField")+"\";");
  	    	println("\tsubmitStr += \"&rlTableName="+params.get("rlTableName")+"\";");
  	    	println("\tsubmitStr += \"&rlColumnName="+params.get("rlColumnName")+"\";");
  	    	println("\tsubmitStr += \"&rlColumnValue="+params.get("rlColumnValue")+"\";");
  	    	println("\tcruConfig.relationParams = submitStr;");
  	    	print("\tqueryRelationedIds(submitStr);\r\n");
  	    }

  	    
  	    if(hasCdts) print("\tcdt_init();\r\n");
  	    print("\tcruConfig.queryStr = \""+replaceParamsAndUserProp(this.getSql())+"\";\r\n");   
  	    println("\tcruConfig.currentPageUrl = \""+request.getServletPath()+"\";");   
  	    print("\tqueryData(1);\r\n");  
  	    
  	    initEditParams();

        print("}\r\n");
        print("\r\n"); 
    }
    
    /**
     * 初试话在线编辑参数
     * @throws IOException
     */
    private void initEditParams()throws IOException{
    	ICfgNode dataList = tlHd.selectSingleNode("DataList");
  	    List<ICfgNode> dataNodes = dataList.selectNodes("data");
	    StringBuffer sbFdNames = new StringBuffer("");
	    for(int i=0;i<dataNodes.size();i++){
	    	ICfgNode dataNode = dataNodes.get(i);
	    	if("Edit".equals(dataNode.getAttrValue("isShow")) || "Hide".equals(dataNode.getAttrValue("isShow"))){
	    		if(dataNode.getAttrValue("fieldName")!=null) sbFdNames.append(","+dataNode.getAttrValue("fieldName").trim());
	    		else{
	    			String expValue = dataNode.getAttrValue("exp");
	    			sbFdNames.append(","+expValue.substring(1,expValue.length()-1));	    			
	    		}
	    	}	    		
	    }
	    if(sbFdNames.toString().equals("")) return;
	    
	    println("\tcruConfig.editedColumnNames = \""+sbFdNames.toString().substring(1)+"\";");  	    
	    String editAction = dataList.getAttrValue("editAction");
	    if(editAction!=null && !"".equals(editAction.trim()))
	    	println("\tcruConfig.editAction=\""+editAction.trim()+"\";");
	    String editTableName = dataList.getAttrValue("editTableName");
	    if(editTableName!=null && !"".equals(editTableName.trim()))
	    	println("\tcruConfig.editTableParams = \"tableName="+editTableName.trim()+"\";");
    }
}
