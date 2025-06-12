package com.cnpc.jcdp.web.rad2.page;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Entities.EscapeMode;
import org.jsoup.parser.Tag;
import org.jsoup.select.Elements;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.cfg.SystemConfig;
import com.cnpc.jcdp.web.rad.page.QueryListPager;
import com.cnpc.jcdp.web.rad.util.DocUtil;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;
import com.cnpc.sais.web.cpc.CommonConst;

@SuppressWarnings({"serial","unused","unchecked"})
public class QueryListPager2 extends QueryListPager {
	private Document doc;
	private QUERY_CDT_TYPE cdt_type = QUERY_CDT_TYPE.SELECT;
	private File tmptFile;
	//默认有查询条件
	public void setHasCdts(boolean hasCdts) {
		this.hasCdts = hasCdts;
	}
	
	public Document getDoc() {
		return doc;
	}

	public void setDoc(Document doc) {
		this.doc = doc;
	}

	public boolean hasQueryCdts(){
    	return super.hasQueryCdts();
    }
	
	protected void readTmpt(HttpServletRequest request) throws IOException{
		String contextPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
		if(request.getContextPath().startsWith("/")){
			contextPath = contextPath + request.getContextPath();
		}
		else{
			contextPath = contextPath + "/" + request.getContextPath();
		}
//		System.out.println("contextPath = "+contextPath);
		String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getRequestURI();
		String suffix = path.substring(path.lastIndexOf(".")+1);
		path = path.replace(suffix, "html");
		Document doc = null;
		String localPath = SystemConfig.WEB_ROOT_PATH.substring(0, SystemConfig.WEB_ROOT_PATH  
                .indexOf("/WEB-INF/classes")) +path.replace(contextPath,"");
		File file=new File(localPath);
		if(file.exists()){
			doc = Jsoup.parse(file, null);
		}else{
			String filePath=contextPath + "/html/";
			String  templatePath = getTlHd().getSingleNodeValue("PageTemplate");
			if(templatePath!=null){
				if(templatePath.startsWith("/"))
					templatePath=templatePath.substring(1);
				filePath += templatePath;
			}else{
				filePath += "cn/list.html";
			}
			localPath = SystemConfig.WEB_ROOT_PATH.substring(0, SystemConfig.WEB_ROOT_PATH  
	                .indexOf("/WEB-INF/classes")) +filePath.replace(contextPath,"");
			file=new File(localPath);
			doc = Jsoup.parse(file,null);
		}
		this.setDoc(doc);
	}
	
	public void process(HttpServletRequest request, HttpServletResponse response)
  	throws java.io.IOException, ServletException {
  	  try {
		  response.setContentType("text/html;charset=utf-8");
		  response.setHeader("Pragma","No-cache"); 
		  response.setHeader("Cache-Control","no-cache"); 
		  response.setDateHeader("Expires", 0);
		  //导入模板
		  readTmpt(request);
		
		  
		//处理需要打印的js和title
		  printHeader(request);
		      
		  //处理body部分
		  printBody(request);
		  
		//输出
		  getDoc().outputSettings().escapeMode(EscapeMode.xhtml);
		  getDoc().outputSettings().prettyPrint(true);
		  String html = getDoc().html();
		  print(html);
	  } catch (Throwable t) {
		  t.printStackTrace();
	  } finally {
		 if(out!=null) flush();
	  }
    }

	/**
	 * 处理头部
	 * @param request
	 * @throws IOException 
	 */
	protected void printHeader(HttpServletRequest request) throws IOException {
		printCSS(request);
		
		printPagerScript(request);
	}

	private void printCSS(HttpServletRequest request) {
		Elements css = getDoc().getElementsByTag("link");
		
		for(int i=0;i<css.size();i++){
			String href = css.get(i).attr("href");
			if(href != null && !href.equals("")){
				if(href.charAt(0) == '/'){
					css.get(i).attr("href",contextPath + href);
				}
				else{
					css.get(i).attr("href",contextPath +"/"+ href);
				}
			}
		}
	}

	/**
	 * 处理body
	 * @param request
	 */
	protected void printBody(HttpServletRequest request) {
		Element body = getDoc().body();
		body.attr("onload", "page_init()");
		//处理列表上面的按钮
		printBodyButtons();
		
		//查询条件
		printQueryCdt();
		
		//list2Select 选择按钮
		if(getListType()==LISTTYPE.List2Sel) printSelectButton();
			
		//查询结果
		printTable();
	}
	private void printTable() {
		//给导航栏的input输入框添加事件
		getDoc().body().getElementById("changePage").attr("onkeydown", "javascript:changePage()");
		//生成列表表头
		List<ICfgNode> nodes = getTlHd().selectNodes("DataList/data");
		Element tr = new Element(Tag.valueOf("tr"),"");
		getDoc().body().getElementById("queryRetTable").appendChild(tr);   //在table中构造一个tr子元素
		//解析表头数据
		for(int i=0;i<nodes.size();i++){   
			ICfgNode node = nodes.get(i);
			String exp = node.getAttrValue("exp");
			exp = replaceListExp(exp);
			Element th = new Element(Tag.valueOf("th"),"");
			tr.appendChild(th);
			th.attr("exp",exp);
			String func = node.getAttrValue("func");
			if(func!=null){
				func = replaceListExp(func);
				th.attr("func", func);
			}
			if(node.getAttrValue("isShow")!=null){
				th.attr("isShow", node.getAttrValue("isShow"));
				if("Hide".equals(node.getAttrValue("isShow")) || "TextHide".equals(node.getAttrValue("isShow"))){
					th.attr("style", "display:none");
				}
			}
			if(node.getAttrValue("fieldName")!=null){
				th.attr("fieldName", node.getAttrValue("fieldName"));
			}
			if(node.getAttrValue("size")!=null){
				th.attr("size", node.getAttrValue("size"));
			}
			if(node.getAttrValue("width")!=null){
				th.attr("width", node.getAttrValue("width"));
			}
//			sb.append(">");
			if(exp!=null && exp.indexOf("type='checkbox'")>0 && exp.indexOf("name='chx_entity_id'")>0){
				Element chb = new Element(Tag.valueOf("input"),"");
				chb.attr("type", "checkbox");
				chb.attr("id","headChxBox");
				chb.attr("onclick", "head_chx_box_changed(this)");
				th.appendChild(chb);
			}
			else{ 
//				sb.append(node.getValue());
				th.appendText(node.getValue());
			}
//			sb.append("</th>\r\n");
//			pager.print(sb.toString());
		}
		
	}

	/**
	 * 针对List2Select页面，打印确认按钮
	 */
	protected void printSelectButton() {
		getDoc().getElementById("btn_submit").attr("style", "visibility:visible");
		getDoc().getElementById("btn_submit").attr("onClick", "selectEntities()");
		getDoc().getElementById("btn_close").attr("style", "visibility:visible");
		getDoc().getElementById("btn_close").attr("onClick", "window.close()");
	}

	private void printQueryCdt() {
		if(hasQueryCdts()) {
			//需要将查询按钮，加、减按钮添加事件。classicQuery查询条件平铺，cmpQuery查询条件是下拉框形式
			String queryTableId=getDoc().body().getElementsByClass("table_search").attr("id");
			if(queryTableId.equals("queryCdtTable")){
				getDoc().body().getElementsByClass("btn_search").attr("onClick", "classicQuery()");
			}
			else{
				getDoc().body().getElementsByClass("btn_search").attr("onClick", "cmpQuery()");
			}
			getDoc().body().getElementsByClass("btn_addSR").attr("onClick", "addSearchRow()");
			getDoc().body().getElementsByClass("btn_delSR").attr("onClick", "deleteSearchRow()");
		}
		else{   //去掉查询条件
			Element search = getDoc().getElementById("searchDiv");
			if(search != null){
				search.remove();
			}
		}
	}


	private void printBodyButtons() {
		//首先将body中所有button都先设置为隐藏
  		Element body = getDoc().body();
  		Elements btns = body.getElementsByAttributeValue("type", "button");
  		for(int i=0;i<btns.size();i++){
  			Element btn = btns.get(i);
  			if(btn.parent().attr("class").equals("ctrlBtn")){
  				btn.attr("style", "display:none");
  			}
  		}
		
		//不是列表查看页面，无上面的新增、编辑、删除按钮，返回
//  		if(listType!=LISTTYPE.List2View) return;
		
  		List<ICfgNode> nodes = getTlHd().selectNodes("//Buttons/Button");
  		if(nodes==null || nodes.size()==0) return;
  		
        for(int i=0;i<nodes.size();i++){
        	ICfgNode node = nodes.get(i);
        	String funcCode = node.getAttrValue("funCode");
        	String authStr = "";
        	if(funcCode!=null && !"".equals(funcCode.trim())){
        		if(!hasAuth(funcCode)) authStr = "disabled";
        	}
        	if("Add".equals(node.getAttrValue("Type"))){
//        		pager.print("<input class=\"button general\" type=\"button\" value=\"添加\" "+authStr+" onClick=\"toAdd()\">\r\n");
        		body.getElementById("btn_add").attr("style", "");
        		body.getElementById("btn_add").attr("onClick", "toAdd()");
        		body.getElementById("btn_add").attr("value", body.getElementById("btn_add").attr("value"));
        		if("disabled".equals(authStr)){
        			body.getElementById("btn_add").attr("disabled", "disabled");
        		}
        	}
        	else if("Edit".equals(node.getAttrValue("Type"))){
//        		pager.print("<input class=\"button general\" type=\"button\" value=\"编辑\" "+authStr+" onClick=\"toEdit()\">\r\n");
        		body.getElementById("btn_edit").attr("style", "");
        		body.getElementById("btn_edit").attr("onClick", "toEdit()");
        		body.getElementById("btn_edit").attr("value", body.getElementById("btn_edit").attr("value"));
        		if("disabled".equals(authStr)){
        			body.getElementById("btn_edit").attr("disabled", "disabled");
        		}
        	}
        		
        	else if("Delete".equals(node.getAttrValue("Type"))){
//        		pager.print("<input class=\"button prompt\" type=\"button\" value=\"删除\" "+authStr+" onClick=\"toDelete()\">\r\n");
        		body.getElementById("btn_del").attr("style", "");
        		body.getElementById("btn_del").attr("onClick", "toDelete()");
        		body.getElementById("btn_del").attr("value", body.getElementById("btn_del").attr("value"));
        		if("disabled".equals(authStr)){
        			body.getElementById("btn_del").attr("disabled", "disabled");
        		}
        	}
        	else if("Back".equals(node.getAttrValue("Type"))){
//        		pager.print("<input class=\"button other\" type=\"button\" value=\"返回\" "+authStr+" onClick=\"toBack()\">\r\n");
        		body.getElementById("btn_back").attr("style", "");
        		body.getElementById("btn_back").attr("onClick", "toBack()");
        		body.getElementById("btn_back").attr("value", body.getElementById("btn_back").attr("value"));
        		if("disabled".equals(authStr)){
        			body.getElementById("btn_back").attr("disabled", "disabled");
        		}
        	}
        	else{   //构建新的button
//        		pager.print("<input class=\"button other\" type=\"button\" "+authStr+" value=\""+node.getAttrValue("Label")+"\" onClick=\"JcdpButton"+i+"OnClick()\">\r\n");
        		Elements ems = body.getElementsByAttributeValue("type", "button");
        		
        		Element em = new Element(Tag.valueOf("input"),"");
        		em.attr("class", body.getElementById("btn_normal").attr("class"));
        		em.attr("type","button");
        		em.attr("value", node.getAttrValue("Label"));
        		em.attr("onClick", "JcdpButton"+i+"OnClick()");
        		if("disabled".equals(authStr)){
        			em.attr("disabled", "disabled");
        		}
        		em = ems.get(ems.size()-1).after(em);  //挂在button组的最后一个
        	}
        	
        }        
        
        
		
	}

	public  void printPagerScript(HttpServletRequest request)throws IOException{
		Element point = null;
		if("toJsp".equals(action)){
//	      	  print("<%@ include file=\"/common/pmd_list.jsp\"%>\r\n");
	        }
        else{
        	Element head = getDoc().head();
        	if(head == null)
        		return;
        	Elements scripts = head.getElementsByTag("script");
        	
        	if(scripts == null || scripts.size() == 0){
        		point = head.getElementsByTag("title").first().previousElementSibling();  
        	}
        	else{
        		for(int i=0;i<scripts.size();i++){
        			String src = scripts.get(i).attr("src");
        			if(src != null && !src.equals("")){
        				if(src.charAt(0) == '/'){
        					scripts.get(i).attr("src",contextPath + src);
        				}
        				else{
        					scripts.get(i).attr("src",contextPath +"/"+ src);
        				}
        			}
        		}
        		point = scripts.last();
        	}
        	Element newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_list.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/rt_list_lan.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_base.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_validate.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_search.js");
        	point.after(newJs);
        	point = newJs;
        	/*国际化组件*/
        	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/rt_search_var.js");
        	point.after(newJs);
        	point = newJs;
        	
//        	newJs = DocUtil.createScriptEm(contextPath+"/js/json.js");
//        	point.after(newJs);
//        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/cute/rt_list_new.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/updateListTable.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm(contextPath+"/js/cute/kdy_search.js");
        	point.after(newJs);
        	point = newJs;
        	newJs = DocUtil.createScriptEm("");
	        point.after(newJs);
        	point = newJs;
        	printJavaScript(point,request);
        }
		
		//修改title
		Elements titles = getDoc().getElementsByTag("title");
		Element title = null;
    	if(titles == null || titles.size() == 0){
    		title = new Element(Tag.valueOf("title"),"");
    		getDoc().getElementsByTag("head").first().children().last().after(title);   //在head最后一个子元素后面新增一个title元素
    	}
    	else{
    		title = titles.first();
    		title.empty();
    	}
	        if(listType!=LISTTYPE.List2View){
	        	title.appendText("选择页面");
	        }
	        else title.appendText("列表页面");
        
        if(listType==LISTTYPE.List2Link){
        	Element base = new Element(Tag.valueOf("base"),"");
        	base.attr("target","_self");
        	point.after(base);
        }
	}
	
	protected void printJavaScript(Element em,HttpServletRequest request)throws IOException{
//		em.appendText("<!--Remark JavaScript定义-->\n");
		String pageTitle = tlHd.getSingleNodeValue("//PageTitle");
		//em.appendText("var JSON = {};\n");
		//em.appendText("JSON.objectToJSONString = Object.prototype.toJSONString;\n");
		em.appendText("var pageTitle = \""+pageTitle+"\";\n");
		em.appendText("cruConfig.contextPath =  \""+contextPath+"\";\n");
		if(user != null){
			em.appendText("cruConfig.userId =  \""+user.getUserId()+"\";\n");
		}
		em.appendText("\n");
		printPmdJs(em);
		
		printSavedParams(em);
		printSelOptions(em);
		
		printJcdpCodes(em);
  		printPageInit(em);
  		
  		printButtonJs(em);
        
        
        if(!hasQueryCdts()) return;        
        //打印查询条件
  		List<ICfgNode> nodes = tlHd.selectNodes("//QueryCondition/cdt_fields/field");
  	    em.appendText("var fields = new Array();\r\n");
  	    if(nodes != null){
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
	   	    	}else{
	   	    		sb.append(",,");
	   	    	}
	  	    	
	  	    	String cdt = node.getAttrValue("cdt");//查询字段匹配的条件，例如is表示的是=
	  	    	if(cdt!=null) sb.append(",'"+cdt+"'");
	  	    	else sb.append(",");
	  	    	//while(sb.charAt(sb.length()-1)==',') sb.deleteCharAt(sb.length()-1);
	  	    	
	  	    	sb.append("];\n");
	  	    	em.appendText(sb.toString());
	  	    }
  	    }
  	    em.appendText("\t\n");
  	    
  	    printBasicQuery(em); //打印查询函数
  	    printCmpQuery(em);
  	    printClassicQuery(em);
  
  	    if(!pmdJsFuncNames.containsKey("onlineEdit(rowParams)")){
  	    	em.appendText("function onlineEdit(rowParams){\r\n");
  	    	em.appendText("\tvar path = cruConfig.contextPath+cruConfig.editAction;\r\n");
  	    	em.appendText("\tObject.prototype.toJSONString =JSON.objectToJSONString; \r\n");
  	    	em.appendText("\tvar params = cruConfig.editTableParams+\"&rowParams=\"+rowParams.toJSONString();\r\n");
  	    	em.appendText("\tvar retObject = syncRequest('Post',path,params);\r\n");
  	    	em.appendText("\tif(retObject == null) return false;\r\n");
  	    	em.appendText("\tif(retObject.returnCode!=0){");
  	    	em.appendText("\t\talert(retObject.returnMsg);");
  	    	em.appendText("\t\treturn false;");
  	    	em.appendText("\t}else return true;");
  	    	em.appendText("}");
  	    	em.appendText(""); 
  	    }
	}
	
	private void printPmdJs(Element em) {
		String jsStr = tlHd.getSingleNodeValue("//JavaScripts");  	    
  	    if(jsStr==null) return;
    	em.appendText(jsStr);//是否需要为javascript中的$开始的参数进行替换
    	
    	List<String> funcNames = new ArrayList<String>();
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
	/**
	 * 打印basicQuery js
	 * @param em
	 */
	private void printBasicQuery(Element em) {
		if(pmdJsFuncNames.get("basicQuery()")!=null) return;
		 em.appendText("function basicQuery(){\r\n");
	  	 em.appendText("\tvar qStr = generateBasicQueryStr();\r\n");
	  	 em.appendText("\tcruConfig.cdtStr = qStr;\r\n");  	    
	  	 em.appendText("\tqueryData(1);\r\n");
	  	 em.appendText("}\r\n");
	  	 em.appendText("\r\n");
	  	 em.appendText("\r\n");
	}
	
	/**
	 * 打印cmpQuery js
	 * @param em
	 */
	private void printCmpQuery(Element em) {
		if(pmdJsFuncNames.get("cmpQuery()")!=null) return;
		em.appendText("function cmpQuery(){\r\n");
  	    em.appendText("\tvar qStr = generateCmpQueryStr();\r\n");
  	    em.appendText("\tcruConfig.cdtStr = qStr;\r\n");
  	    em.appendText("\tqueryData(1);\r\n");  	    
  		em.appendText("}\r\n");
  		em.appendText("\r\n"); 
	}
	
	/**
	 * 打印classicQuery js
	 * @param em
	 */
	private void printClassicQuery(Element em) {
		if(pmdJsFuncNames.get("classicQuery()")!=null) return;
		em.appendText("function classicQuery(){\r\n");
  		em.appendText("\tvar qStr = generateClassicQueryStr();\r\n");
  		em.appendText("\tcruConfig.cdtStr = qStr;\r\n");
  		em.appendText("\tqueryData(1);\r\n");  	    
  		em.appendText("}\r\n");
  		em.appendText("\r\n");   	
	}

	/**
	 * 按钮的js函数
	 * @param em
	 */
	protected void printButtonJs(Element em) {
//		PAGER_OPEN_TYPE open_type = tpt.getOPEN_TYPE();
		PAGER_OPEN_TYPE open_type = PAGER_OPEN_TYPE.POP;
  		List<ICfgNode> nodes = tlHd.selectNodes("//Buttons/Button");
  		if(nodes==null) return;
  		String jsFuncName = null;
        for(int i=0;i<nodes.size();i++){
        	ICfgNode node = nodes.get(i);
        	jsFuncName = getButtonJsFuncName(node,i);
        	if(pmdJsFuncNames.get(jsFuncName)!=null) continue;
        	if("Add".equals(node.getAttrValue("Type"))){
                em.appendText("function "+jsFuncName+"{\n");
                String addUrl = node.getValue();
                if(addUrl.startsWith("/"))
                	addUrl = contextPath+addUrl;
                addUrl = super.replaceParams(addUrl);
                if(addUrl.indexOf("?")<=0) addUrl += "?";  
                else addUrl += "&";
                addUrl += "pagerAction=edit2Add";                
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	em.appendText("\twindow.location='"+addUrl+"&backUrl='+cruConfig.currentPageUrl;\n");
                }
                else{
                	String size = node.getAttrValue("size");
                	em.appendText("\tpopWindow(\""+addUrl+"\"");
	                if(size!=null) em.appendText(",\""+size+"\"");
	                em.appendText(");\n");
                }
                em.appendText("}\n");
                em.appendText("\n");         		
        	}
        	else if("Edit".equals(node.getAttrValue("Type"))){
        		em.appendText("function "+jsFuncName+"{\n");
        		em.appendText("\tids = getSelIds('chx_entity_id');\n");
        		em.appendText("\tif(ids==''){\n");
        		em.appendText("\t\talert(\"JCDP_alert_choose_first!\");\n");
        		em.appendText("\t\treturn;\n");
        		em.appendText("\t}\n");                
        		em.appendText("\tselId = ids.split(',')[0];\n");
                String editUrl = node.getValue();
                if(editUrl.startsWith("/"))
                	editUrl = contextPath+editUrl;                
                if(editUrl.indexOf("?")<=0) editUrl += "?"; 
                if(editUrl.indexOf("id={id}")<=0) editUrl += "id={id}";               	 
                em.appendText("\teditUrl = \""+editUrl+"\";\n");
                em.appendText("\teditUrl = editUrl.replace('{id}',selId);\n");
                em.appendText("\teditUrl += '&pagerAction=edit2Edit';\n");
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	em.appendText("\twindow.location=editUrl+\"&backUrl=\"+cruConfig.currentPageUrl;\n");
                }
                else{
                	em.appendText("\tpopWindow(editUrl);\n");  
                }         
                em.appendText("}\n");
                em.appendText("\n");         		
        	}         
        	else if("View".equals(node.getAttrValue("Type"))){
        		em.appendText("function "+jsFuncName+"{\n");
        		em.appendText("\tids = getSelIds('chx_entity_id');\n");
        		em.appendText("\tif(ids==''){\n");
        		em.appendText("\t\talert(\"JCDP_alert_choose_first!\");\n");
        		em.appendText("\t\treturn;\n");
        		em.appendText("\t}\n");                
        		em.appendText("\tselId = ids.split(',')[0];\n");
                String editUrl = node.getValue();
                if(editUrl.startsWith("/"))
                	editUrl = contextPath+editUrl;                
                if(editUrl.indexOf("?")<=0) editUrl += "?"; 
                if(editUrl.indexOf("id={id}")<=0) editUrl += "id={id}";               	 
                em.appendText("\teditUrl = \""+editUrl+"\";\n");
                em.appendText("\teditUrl = editUrl.replace('{id}',selId);\n");
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	em.appendText("\twindow.location=editUrl+\"&backUrl=\"+cruConfig.currentPageUrl;\n");
                }
                else{
                	em.appendText("\tpopWindow(editUrl);\n");  
                }         
                em.appendText("}\n");
                em.appendText("\n");         		
        	}               	
        	else if("Delete".equals(node.getAttrValue("Type"))){
        		em.appendText("function "+jsFuncName+"{\n");
        		String funcCode = node.getAttrValue("funCode");
        		String sql = node.getValue();
        		sql = super.replaceParamsAndUserProp(sql);
        		//业务一致性验证 
        		if(funcCode!=null && funcCode.contains(",V")){
        			em.appendText("\tdeleteEntities(\""+sql+"\",\""+funcCode.split(",")[0]+"\");\n");
        		}
        		else em.appendText("\tdeleteEntities(\""+sql+"\");\n");
        		em.appendText("}\n");
        		em.appendText("\n");  
        	}
            else if("Back".equals(node.getAttrValue("Type"))){
            	em.appendText("function "+jsFuncName+"{\n");
            	em.appendText("\twindow.history.back(-1);;\n");
            	em.appendText("}\n");
            	em.appendText("\n");         		
           }
            else if("link".equals(node.getAttrValue("Type"))){
            	em.appendText("function "+jsFuncName+"{\n");
                if(open_type==PAGER_OPEN_TYPE.LINK && !isList2Compose()){
                	em.appendText("\twindow.location=\""+node.getValue()+"\";\n");
                }
                else{
                	em.appendText("\tpopWindow(\""+node.getValue()+"\");\n");  
                }                  
                em.appendText("}\n");
                em.appendText("\n");         		
            }        	
           else {
        	    em.appendText("\n");         		
           }
        }
		
	}

	/**
	 * 打印pageInit js
	 * @param em
	 */
	private void printPageInit(Element em) {
		if(pmdJsFuncNames.get("page_init()")!=null) return;
		//System.out.println(pmdJsFuncNames.size());
  	    //String sql = tlHd.getSingleNodeValue("//QuerySQL/sql");

        em.appendText("function page_init(){\n");
        if(listType == LISTTYPE.List2Sel){
        	em.appendText("\tsetCruTitle();\n");
        	em.appendText("\tcruConfig.cruAction = 'list2Select';\n"); 
        }else{
	        em.appendText("\tvar titleObj = getObj(\"cruTitle\");\n");
	        em.appendText("\tif(titleObj!=undefined) titleObj.innerHTML = pageTitle;\n");
        }
  	    String funcCode = tlHd.getSingleNodeValue("QuerySQL/funcCode");
  	    if(funcCode!=null){
  	    	em.appendText("\tcruConfig.funcCode = \""+funcCode+"\";\n"); 
  	    }
  	    
  	    //add for service call
  	    //2010.10.20 by rechete
  	    String opName = tlHd.getSingleNodeValue("QueryService/opName");
  	    if(opName!=null){  	    	 
  	    	String srvName = tlHd.selectSingleNode("QueryService").getAttrValue("name");
  	    	em.appendText("\tcruConfig.queryService = '"+srvName+"';\n"); 
  	    	em.appendText("\tcruConfig.queryOp = '"+opName+"';\n"); 
  	    }
  	    //end
  	    
  	    if(cdt_type == QUERY_CDT_TYPE.FORM)
  	    	em.appendText("\tcruConfig.cdtType = 'form';\n");  
    	if(listType==LISTTYPE.List2Link){
    		em.appendText("\tcruConfig.cruAction = 'list2Link';\n");  
      	}  	    
  	    if(listType==LISTTYPE.List2Sel){
  	    	em.appendText("\tvar submitStr = \"toSelColumnName="+tlHd.getSingleNodeValue("//QuerySQL/toSelField")+"\";\n");
  	    	em.appendText("\tsubmitStr += \"&rlTableName="+params.get("rlTableName")+"\";\n");
  	    	em.appendText("\tsubmitStr += \"&rlColumnName="+params.get("rlColumnName")+"\";\n");
  	    	em.appendText("\tsubmitStr += \"&rlColumnValue="+params.get("rlColumnValue")+"\";\n");
  	    	em.appendText("\tcruConfig.relationParams = submitStr;\n");
  	    	em.appendText("\tqueryRelationedIds(submitStr);\n");
  	    }

  	    
  	    if(hasQueryCdts()) em.appendText("\tcdt_init();\n");
  	    em.appendText("\tcruConfig.queryStr = \""+replaceParamsAndUserProp(this.getSql())+"\";\n");
  	    if(request.getRequestURI().contains(CommonConst.COMP_URL_PREFIX)){
  	    	 em.appendText("\tcruConfig.currentPageUrl = \"/"+request.getRequestURI().substring((request.getContextPath()+CommonConst.COMP_URL_PREFIX).length())+"\";\n");   
  	    }else{
  	    	em.appendText("\tcruConfig.currentPageUrl = \""+request.getRequestURI().substring((request.getContextPath()).length())+"\";\n");   
  	    }
  	    em.appendText("\tqueryData(1);\n"); 
  	    
  	    initEditParams(em);

  	    em.appendText("}\n");
  	    em.appendText("\n"); 
		
	}
	
	/**
     * 初始化在线编辑参数
     * @throws IOException
     */
    private void initEditParams(Element em){
    	ICfgNode dataList = tlHd.selectSingleNode("DataList");
  	    List<ICfgNode> dataNodes = dataList.selectNodes("data");
	    StringBuffer sbFdNames = new StringBuffer("");
	    for(int i=0;i<dataNodes.size();i++){
	    	ICfgNode dataNode = dataNodes.get(i);
	    	if("Edit".equals(dataNode.getAttrValue("isShow")) || "Hide".equals(dataNode.getAttrValue("isShow"))){
	    		if(dataNode.getAttrValue("fieldName")!=null) sbFdNames.append(","+dataNode.getAttrValue("fieldName").trim());
	    		else{
	    			String expValue = dataNode.getAttrValue("exp");
//	    			sbFdNames.append(","+expValue.substring(1,expValue.length()-1));
	    			sbFdNames.append(","+expValue);	
	    		}
	    	}	    		
	    }
	    if(sbFdNames.toString().equals("")) return;
	    
	    em.appendText("\tcruConfig.editedColumnNames = \""+sbFdNames.toString().substring(1)+"\";\n");  	    
	    String editAction = dataList.getAttrValue("editAction");
	    if(editAction!=null && !"".equals(editAction.trim()))
	    	em.appendText("\tcruConfig.editAction=\""+editAction.trim()+"\";\n");
	    String editTableName = dataList.getAttrValue("editTableName");
	    if(editTableName!=null && !"".equals(editTableName.trim()))
	    	em.appendText("\tcruConfig.editTableParams = \"tableName="+editTableName.trim()+"\";\n");
    }

	/**
	 * 打印编码js
	 * @param em
	 */
	private void printJcdpCodes(Element em) {
		em.appendText("var jcdp_codes_items = null;\n");
		em.appendText("var jcdp_codes = new Array(");
  		List<ICfgNode> nodes = tlHd.selectNodes("//Codes/Code");
  		if(nodes!=null){  		
	  		StringBuffer sb = new StringBuffer("");
	  		if(nodes!=null)
		  		for(int i=0;i<nodes.size();i++){
		  			/*name,中文名,sql,fdName,withNull*/
		  			ICfgNode node = nodes.get(i);
		  			if(i>0) sb.append(",\n");
		  			sb.append("['"+node.getAttrValue("name")+"','"+node.getValue()+"'");
		  			String sql = null;
		  			String b_code_id = node.getAttrValue("b_code_id");
		  			String sais_code_name = node.getAttrValue("sais_code_name");
		  			String noNull = node.getAttrValue("noNull");
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
		  		//		if(fdName!=null) 
		  				fdName = fdName == null?"":fdName;
		  				sb.append(",\""+fdName+"\"");
		  			}
		  			if("false".equals(noNull)){
		  				sb.append(",\"withNull\"");
		  			}
		  			sb.append("]");
		  		}
	  		em.appendText(sb.toString()); 
  		}
  		em.appendText(");\n\n");
	}

	/**
	 * 打印下拉框js定义
	 * @param em
	 */
	private void printSelOptions(Element em) {
		List<ICfgNode> selNodes = tlHd.selectNodes("Options/Select");
    	if(selNodes==null) return;
  		for(int i=0;i<selNodes.size();i++){
  			ICfgNode selNode = selNodes.get(i);
  			em.appendText("var "+selNode.getAttrValue("name")+" = new Array(\n");
  			String sais_select_name = selNode.getAttrValue("sais_select_name");
  			String optStr = "";
  			if(sais_select_name!=null){
  				optStr = PagerFactory.getOptionsStr(selNode.getAttrValue("name"))+"\n";
  			}
  			else{
  				List<ICfgNode> options = selNode.selectNodes("option");
  				StringBuffer optionSb = new StringBuffer("");
	  			for(int j=0;j<options.size();j++){
	  				ICfgNode option = options.get(j);
	  				if(j>0) optionSb.append(",");
	  				optionSb.append("['"+option.getAttrValue("value")+"','"+option.getValue()+"']");
	  			}
	  			optStr = optionSb.toString();
  			}
  			
  			String noNull = selNode.getAttrValue("noNull");
  			if("false".equals(noNull)){  //判断是否加空option
  				optStr = "['',' ']," + optStr;
			}
  			em.appendText(optStr);
  			em.appendText(");\n\n");
  		}    	
		
	}

	/**
	 * 打印预定义参数
	 * @param em
	 */
	protected void printSavedParams(Element em){
		String savedParams = tlHd.getSingleNodeValue("SavedParams");
    	if(savedParams !=null) {
	    	em.appendText("var jcdpPageParams = {}; \n");
	    	String[] paramAr = savedParams.split(",");
	    	for(int i=0;i<paramAr.length;i++){
	    		String value=null;
	    		if(paramAr[i].indexOf("USER.")==0){//从userToken中取值，取出的值不需要再转码
	    			value = super.replaceParamsAndUserProp("$"+paramAr[i]);
	    			if(value==null) continue;
	    		}else if(paramAr[i].indexOf("SESSION.")==0){//从session中取值
	    			value = super.replaceSessionProperties("$"+paramAr[i]);
	    			if(value==null) continue;
	    		}
	    		else{//从request中取值
	    			value = request.getParameter(paramAr[i]);
	    			if(value==null) continue;
		    		try{
		    			value = new String(value.getBytes("ISO-8859-1"),"UTF-8");
		    		}catch(Exception ex){
		    			log.error(ex);
		    			value = "";
		    		}
	    		}
	    		//转成jsp页面
//	    		if("toJsp".equals(action)){
//	    			value = "<%="+paramAr[i]+"%>";
//	    		}	    			
	    		params.put(paramAr[i], value);		  	
	    		em.appendText("jcdpPageParams['"+paramAr[i]+"'] = '"+params.get(paramAr[i])+"'; \n");
	    	}
	    	em.appendText("\n");
    	}
	}
}
