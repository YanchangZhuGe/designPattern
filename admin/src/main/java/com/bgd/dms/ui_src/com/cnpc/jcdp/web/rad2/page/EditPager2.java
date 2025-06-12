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
import com.cnpc.jcdp.web.rad.page.EditPager;
import com.cnpc.jcdp.web.rad.util.DocUtil;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADUtil;
import com.cnpc.jcdp.web.rad.util.RADConst.PMDAction;

public class EditPager2 extends EditPager {
	private Document doc;
	public Document getDoc() {
		return doc;
	}

	public void setDoc(Document doc) {
		this.doc = doc;
	}
	public EditPager2(){
		pmdAction = RADConst.PMDAction.S_U;		
	}
	
	protected void readTmpt(HttpServletRequest request) throws IOException{
//		String contextPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+request.getContextPath();
		String contextPath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
		if(request.getContextPath().startsWith("/")){
			contextPath = contextPath + request.getContextPath();
		}
		else{
			contextPath = contextPath + "/" + request.getContextPath();
		}
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
				filePath += "cn/cru.html";
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
  		  noCloseButton = "true".equals(request.getParameter("noCloseButton"));
		  response.setContentType("text/html;charset=utf-8");
		  response.setHeader("Pragma","No-cache"); 
		  response.setHeader("Cache-Control","no-cache"); 
		  response.setDateHeader("Expires", 0);
		  //导入模板
		  this.readTmpt(request);
		
		  
		//处理需要打印的js和title
		  printHeader(request);
		      
		  //处理body部分
		  printBody(request);
		  
		//输出
		  doc.outputSettings().escapeMode(EscapeMode.xhtml);
//		  System.out.println(doc.outputSettings().charset());
		  doc.outputSettings().prettyPrint(true);
		  String html = doc.html();
//		  String html = doc.html().replaceAll("\n", "\r\n");
		  print(html);
	  } catch (Throwable t) {
		  t.printStackTrace();
	  } finally {
		 if(out!=null) flush();
	  }
    }

	private void printBody(HttpServletRequest request) {
		Element body = doc.body();
		body.attr("onload", "page_init()");
		if(!isNoSubmitButton()) printSubmitButtons();
	}

	private void printSubmitButtons() {
		Element em = doc.getElementById("cruButton");
	      if(isComplexAction()){
	    	  //子表增删按钮区
	    	  Element addButton = em.appendElement("input");
	    	  addButton.attr("type","button");
	    	  addButton.attr("class", "btn btn_add");
	    	  addButton.attr("onClick", "addItem()");
	    	  
	    	  Element del = em.appendElement("input");
	    	  del.attr("type","button");
	    	  del.attr("class", "btn btn_del");
	    	  del.attr("onClick", "deleteItem()");
	    	  
	      }
//	      doc.getElementById("cruButtonSubmit").attr("style", "display:none");
//	      doc.getElementById("cruButtonClose").attr("style", "display:none");
	      //页面保存按钮区
	      if(!isViewAction()){
	    	  if(doc.getElementById("cruButtonSubmit")==null){
	    		  Element addButton = em.appendElement("input");
		    	  addButton.attr("type","button");
		    	  addButton.attr("class", "btn btn_submit");
		    	  addButton.attr("onClick", "submitFunc()");
	    	  }
//	    	  pager.print("\t\t<input type=\"button\" class=\"cuteBtn\" value=\"保存\" onClick=\"submitFunc()\"/>\r\n");
	    	  else
	    	  doc.getElementById("cruButtonSubmit").attr("style", "");
	      }
	     
	      if(!isNoCloseButton()){
	       	  if(doc.getElementById("cruButtonClose")==null){
	    		  Element addButton = em.appendElement("input");
		    	  addButton.attr("type","button");
		    	  addButton.attr("class", "btn btn_close");
		    	  addButton.attr("onClick", "newClose()");
	    	  } else
//	    	  pager.print("\t\t<input type=\"button\" class=\"cuteBtn\" value=\"关闭\" onClick=\"parent.parent.parent.GB_hide();\"/>\r\n");
	    	  doc.getElementById("cruButtonClose").attr("style", "");
	      }
		
	}

	protected void printHeader(HttpServletRequest request) throws IOException {
		//处理css
		Elements css = doc.getElementsByTag("link");
		
		for(int i=0;i<css.size();i++){
			String href = css.get(i).attr("href");
			if(href != null || !href.equals("")){
				if(href.charAt(0) == '/'){
					css.get(i).attr("href",contextPath + href);
				}
				else{
					css.get(i).attr("href",contextPath +"/"+ href);
				}
			}
		}
		
		//处理script
		Element head = doc.head();
    	if(head == null)
    		return;
    	Elements scripts = head.getElementsByTag("script");
    	Element point;
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
    	Element newJs = DocUtil.createScriptEm(contextPath+"/js/calendar.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/calendar_lan.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/calendar-setup.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_base.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_cru.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/rt_cru_lan.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/proc_base.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/fujian.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_validate.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/JCDP_SAIS_JS/rt_validate_lan.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/rt/rt_edit.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm(contextPath+"/js/json.js");
    	point.after(newJs);
    	point = newJs;
    	newJs = DocUtil.createScriptEm("");
        point.after(newJs);
    	point = newJs;
    	printJavaScript(point,request);
    
	}

	protected void printJavaScript(Element em, HttpServletRequest request) throws IOException {
		String pageTitle = tlHd.getSingleNodeValue("//PageTitle");
		//em.appendText("var JSON = {};\r\n");
		//em.appendText("JSON.objectToJSONString = Object.prototype.toJSONString;\r\n");
  		em.appendText("var cruTitle = \""+composeTitle(pageTitle)+"\";\r\n");
  		
  		printSavedParams(em);
  		
  		printSelOptions(em);  		
  		printJcdpCodes(em);
  		
  		em.appendText("var jcdp_record = null;\n");
  		printFields(em,request,PMDAction.S_U);
  	    
  		printPmdJs(em);
  		
  	    printPageInit(em);
  	    
  	    printSubmitJs(em);
  	    
  	    printAfterSubmitJs(em);
  	    
  	    printOtherJs(em);
	}

	private void printOtherJs(Element em) {
		// TODO Auto-generated method stub
		
	}

	private void printAfterSubmitJs(Element em) {
		if(pmdJsFuncNames.get("afterSubmit(retObject,successHint,failHint)")!=null) return;
  		em.appendText("function afterSubmit(retObject,successHint,failHint){\n");
  		em.appendText("\tif(retObject==null){ alert('retObject==null');return;}\n");
  		em.appendText("\tif(successHint==undefined) successHint = \"JCDP_alert_OK\";\n");
  		em.appendText("\tif(failHint==undefined) failHint = \"JCDP_alert_FAIL\";\n");
  		em.appendText("\tif (retObject.returnCode != \"0\") alert(failHint);\n");
  		em.appendText("\telse{\n");
  		if(request.getParameter("backUrl")==null){
  			em.appendText("\t\talert(successHint);\n");
//	        System.out.println(tpt.getClass().getName());
//	        System.out.println(tpt.getParentRefreshFunc());
//	        System.out.println(tpt.getWindowCloseFunc());
  			em.appendText("\t\trefreshData();\n");
  			em.appendText("\t\tnewClose();\n");
//	        print("\t\twindow.opener.refreshData();\r\n");
//	        print("\t\twindow.close();\r\n");
        }else{
        	em.appendText("\t\twindow.location = cruConfig.contextPath+cruConfig.openerUrl;\n");
        }      		
  		em.appendText("\t}\n");
  		em.appendText("}\n");
	}

	private void printSubmitJs(Element em) {
		if(pmdJsFuncNames.get("submitFunc()")!=null) return;
  		
  		em.appendText("");
//  		System.out.println("**************"+isContainFileField);
  		if(isContainFileField && (isAddAction()||isEditAction())){  
  			if(pmdJsFuncNames.get("submitFunc()")==null){
  				em.appendText("function submitFunc(){");
  				em.appendText("\tsubmitStr = getSubmitStr();\n");
  				em.appendText("\tif(submitStr == null) return;\n");
  				if(isContainFilesField){
  					em.appendText("\tvar uploadFile=checkUploadFiles();");
  				}else{
  					em.appendText("\tvar uploadFile=checkUploadFile();");
  				}
  				em.appendText("\tif(uploadFile=='true'){");
  				em.appendText("\tdocument.fileForm.action = cruConfig.contextPath+appConfig.uploadFileAction;\n");
  				em.appendText("\tdocument.fileForm.submit();\n");
  				em.appendText("\t}else{");
  				em.appendText("\tvar path = cruConfig.contextPath+cruConfig.addOrUpdateAction;");
  				em.appendText("\tvar retObject = syncRequest('Post',path,submitStr);");
  				em.appendText("\tafterSubmit(retObject);");
  				em.appendText("\t}");
  				em.appendText("}\n");
  			}
  			if(pmdJsFuncNames.get("toSubmitForm(uploadRet)")!=null) return;
  			em.appendText("function toSubmitForm(uploadRet){");
  		}  		
  		
  		if(!(isContainFileField && (isAddAction()||isEditAction()))) em.appendText("function submitFunc(){\n");
  		if(isContainFileField && (isAddAction()||isEditAction())){ 
  			em.appendText("\tif(uploadRet.returnCode!=0){");
  			em.appendText("\t\talert(uploadRet.returnMsg);");
  			em.appendText("\t\treturn;");
  			em.appendText("\t}\n");
  		}
        //多表修改
        if(tlHd.selectNodes("//Tables/Table")!=null){
        	em.appendText("	var submitStr = \"jcdp_tables=\"+JSON.stringify(tables);\n");
        	em.appendText("	for(var i=0;i<tables.length;i++){\n");
        	em.appendText("	  var tableName = tables[i][0];\n");
        	em.appendText("	  var tSubmitStr = '';\n");
        	em.appendText("	  if(tableName==defaultTableName) tSubmitStr = getSubmitStr();\n");
        	em.appendText("	  else 	tSubmitStr = getSubmitStr(tableName);\n");
        	em.appendText("     if(tSubmitStr == null) return;\n");
        	em.appendText("	  submitStr += \"&\"+tableName+\"=\"+JSON.stringify(submitStr2Array(tSubmitStr));\n");
        	em.appendText("	}\n");
        	em.appendText("	var path = cruConfig.contextPath+cruConfig.updateMulTableAction;\n");
        	em.appendText("	var retObject = syncRequest('Post',path,submitStr);\n");
        }else{//单表修改
        	em.appendText("\tvar path = cruConfig.contextPath+cruConfig.addOrUpdateAction;\n");
        	em.appendText("\tsubmitStr = getSubmitStr();\n");
        	em.appendText("\tif(submitStr == null) return;\n");   
	        
	        if(isContainFileField && (isAddAction()||isEditAction())){
	        	em.appendText("\tvar fileFieldsIndex = getFileFieldsIndex();\n");
	        	em.appendText("\tsubmitStr += \"&fileFieldsIndex=\"+fileFieldsIndex+\"&fileMsgId=\"+uploadRet.msgId;\n");   
	        }
	        em.appendText("\tvar retObject = syncRequest('Post',path,submitStr);\n");
        }
        em.appendText("\tafterSubmit(retObject);\n");
        em.appendText("}\n");
		
	}

	private void printPageInit(Element em) {
		if(pmdJsFuncNames.get("page_init()")!=null) return;
  		em.appendText("\n");
  		em.appendText("function page_init(){\n");
//  		em.appendText("\tgetObj('cruTitle').innerHTML = cruTitle;\n");
  		em.appendText("\tsetCruTitle();\n");
  		em.appendText("\tcruConfig.contextPath = \"");
  		em.appendText(contextPath);
  		em.appendText("\";\n");
        String backUrl = request.getParameter("backUrl");
        if(backUrl!=null)
        	em.appendText("\tcruConfig.openerUrl = \""+request.getParameter("backUrl")+"\";");
        if("1".equals(lineRange))
        	em.appendText("\tcruConfig.lineRange = '1';\n");        
		sql = replaceParamsAndUserProp(sql);
		em.appendText("\tcruConfig.querySql = \""+sql+"\";\n");
		em.appendText("\tcru_init();\n");
		em.appendText("}\n");  		
		
	}

	private void printPmdJs(Element em) {
		String jsStr = tlHd.getSingleNodeValue("//JavaScripts/CRU"); 
  	    List<String> funcNames = new ArrayList();
  	    funcNames.add("page_init()");
        funcNames.add("submitFunc()");
        funcNames.add("toSubmitForm(uploadRet)");
        funcNames.add("afterSubmit(retObject,successHint,failHint)");
  	    if(jsStr!=null){
  	    	em.appendText(jsStr);
  	    	addJsFuncs(jsStr,funcNames);
  	    }
  	    if(super.isEditAction()){
  	    	jsStr = tlHd.getSingleNodeValue("//JavaScripts/U");
  	    	if(jsStr!=null){
  	    		em.appendText(jsStr);  	    	
  	    		addJsFuncs(jsStr,funcNames);
  	    	}
  	    }
  	    if(super.isAddAction()){
  	    	jsStr = tlHd.getSingleNodeValue("//JavaScripts/C");
  	    	if(jsStr!=null){
  	    		em.appendText(jsStr);  	    	
  	    		addJsFuncs(jsStr,funcNames);
  	    	}	    	
  	    }
  	    if(super.isViewAction()){
  	    	jsStr = tlHd.getSingleNodeValue("//JavaScripts/R");
  	    	if(jsStr!=null){
  	    		em.appendText(jsStr);  	    	
  	    		addJsFuncs(jsStr,funcNames);
  	    	}	    	
  	    }    	    
	}

	private void printFields(Element em, HttpServletRequest request, String su) {
		List<ICfgNode> tables = tlHd.selectNodes("//Tables/Table");
  		String tableName = tlHd.getSingleNodeValue("//QuerySQL/tableName"); 
  		if(tables!=null){
//  		println("/**");
//			println(" 表单字段要插入的数据库表定义");
//			println("*/");  			
  			em.appendText("var tables = new Array(");
  			for(int i=0;i<tables.size();i++){
  				ICfgNode table = tables.get(i);
  				if(i>0) em.appendText(",");
  				em.appendText("['"+table.getAttrValue("name")+"'");
  				if(isAddAction()){
  	  				String value = table.getValue();
  	  				if(value!=null && !"".equals(value.trim())) em.appendText(",'"+value.trim()+"'");  					
  				}
  				em.appendText("]\n"); 				
  			}
  			em.appendText(");\n");
  			em.appendText("var defaultTableName = '"+tableName+"';\n");
  		}
  		
  		em.appendText("/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，");
  		em.appendText("   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，");
  		em.appendText("             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，");
  		em.appendText("   4最大输入长度，");
  		em.appendText("   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，");  	
  		if(PMDAction.S_U.equals(action) || PMDAction.S_R.equals(action)){
  			em.appendText("           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，");
  		} 		
  		em.appendText("           其他默认值");
  		em.appendText("   6输入框的长度，7下拉框、自动编码的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*");
  		em.appendText("   9 Column Name，10 Event,11 Table Name");
  		em.appendText("*/\n");
  		List<ICfgNode> nodes = tlHd.selectNodes("//EntityFields/field");
  		em.appendText("var fields = new Array("); 	    
  	    if(tlHd.selectNodes("//Tables/Table")==null){
  	    	em.appendText("['JCDP_TABLE_NAME',null,'Hide','TEXT',null,'"+tableName+"']\n");
  	  	    if(isEditAction()){
  	  	    	String id = "";
  	  	    	if(params.get("id")!=null) id = params.get("id").toString();
  	  	    em.appendText(",['JCDP_TABLE_ID',null,'Hide','TEXT',null,'"+id+"']\n");
  	  	    }  	    	
  	    }
  	    String uniqueFields = ":";
  	    String fileFields = ":";
  	    float tableRows = 0;
  	    cruTableHeight = 0;
  	    for(int i=0;i<nodes.size();i++){
  	    	ICfgNode node = nodes.get(i);
  	    	if(!isContainField(node.getAttrValue("action"))) continue;
  	    	if("true".equals(node.getAttrValue("isUnique")))
  	    		uniqueFields += node.getAttrValue("name")+":";
  	    	//0:name
  	    	StringBuffer sb = new StringBuffer();
  	    	String fieldName = node.getAttrValue("name");
  	    	String fieldTable = node.getAttrValue("table");
  	    	//if(fieldTable!=null) fieldName = fieldTable+"."+fieldName;
  	    	if(i==0 && tlHd.selectNodes("//Tables/Table")!=null) sb.append("['"+fieldName+"'");
  	    	else sb.append(",['"+fieldName+"'");
  	    	//1:label
  	    	String label = node.getValue();
  	    	label = RADUtil.deleteLineFeed(label);
  	    	if(label==null) label = ",";
  	    	else label = ",'"+label+"'";
  	    	//2:是否隐藏
  	    	String isShow = node.getAttrValue("isShow");
  	    	if(isShow==null) isShow = "Edit";
  	    	isShow = ",'"+isShow+"'";
  	    	//3:字段类型(SEL_OPs,SEL_Codes)
  	    	String type = node.getAttrValue("type");
  	    	if("FILE".equals(type)|| "FILES".equals(type) || "BYTES".equals(type)){//附件字段
  	    		fileFields += node.getAttrValue("name")+":";
  	    	}
  	    	else if(type==null) type = "TEXT";
  	    	if("FILES".equals(type)){
  	    		isContainFilesField = true;
  	    	}
  	    	type = ",'"+type+"'";

  	    	//4:最大输入长度
  	    	String maxLength = node.getAttrValue("maxLength");
  	    	if(maxLength==null) maxLength = ",";
  	    	else maxLength = ",'"+maxLength+"'";  	    	
  	    	//5:默认值
  	    	String defaultValue = node.getAttrValue("defaultValue");
  	    	defaultValue = replaceParamsAndUserProp(defaultValue);
  	    	if(defaultValue==null) defaultValue = ",";
  	    	else defaultValue = ",'"+defaultValue+"'";  
  	    	//6:输入框宽度
  	    	String size = node.getAttrValue("size");
  	    	if(size==null){
  	    		if(",'MEMO'".equals(type)) size = ",'"+RADConst.DEFAULT_MEMO_COLS+":"+RADConst.DEFAULT_MEMO_ROWS+"'";  	
  	    		else size = ",";
  	    	}
  	    	else{
  	    		if(",'MEMO'".equals(type) && size.indexOf(":")<=0) size += ":"+RADConst.DEFAULT_MEMO_ROWS;//增加默认行数
  	    		size = ",'"+size+"'"; 	    	
  	    	}
  	    	//计算高度
  	    	if(!",'Hide'".equals(isShow)){
  	    		if(",'MEMO'".equals(type)){ 	    			 
  	    			cruTableHeight +=  5+15*Integer.parseInt(size.substring(size.indexOf(":")+1,size.length()-1));
  	    			tableRows = Math.round(tableRows);
  	    		}else tableRows += 0.5;
  	    	}
  	    	
  	    	//7:下拉框的值或弹出链接
  	    	String selValue = node.getAttrValue("selValue");
  	    	if(selValue==null) selValue = ",";
  	    	else{
  	    		if("FK".equals(node.getAttrValue("type"))){
  	    			if(selValue!=null && selValue.startsWith("/"))
  	    				selValue = this.contextPath+selValue;
  	    			if(selValue!=null) selValue = ",'"+selValue+"'";
  	    			else selValue = ",";
  	    		}else if("SEL_OPs".equals(node.getAttrValue("type"))){
  	    			selValue = ","+selValue;
  	    		}
  	    		else selValue = ",'"+selValue+"'";  	    	
  	    	}
  	    	//8:是否非空
  	    	String nonEmpty = node.getAttrValue("nonEmpty");
  	    	if("true".equals(nonEmpty)) nonEmpty = ",'non-empty'";
  	    	else nonEmpty = ",";
  	    	//9:Column
  	    	String column = getFieldValue(node.getAttrValue("column"));
  	    	//10:Event
  	    	String event = getFieldValue(node.getAttrValue("event"));
  	    	if(fieldTable!=null) fieldTable = ",'"+fieldTable+"'";
  	    	else fieldTable = "";
  	    	sb.append(label+isShow+type+maxLength+defaultValue+size+selValue);
  	    	sb.append(nonEmpty+column+event+fieldTable+"]");
  	    	em.appendText(sb.toString());
  	    }
  	    em.appendText(");\n");
  	    cruTableHeight += Math.round(tableRows)*25;
  	    
  	    em.appendText("var uniqueFields = '"+uniqueFields+"';\n");  
  	    em.appendText("var fileFields = '"+fileFields+"';\n");  
  	    if(!":".equals(fileFields)) 
  	    	isContainFileField = true;
		
	}

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
		  			if(i>0) sb.append(",\r\n");
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
//		  				if(fdName!=null) 
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
  		em.appendText(");\n");
  		em.appendText("\n");  	
		
	}

	private void printSavedParams(Element em) {
		String savedParams = tlHd.getSingleNodeValue("SavedParams");
    	if(savedParams==null) return;
    	
    	em.appendText("var jcdpPageParams = {}; \n");
    	String[] paramAr = savedParams.split(",");
    	for(int i=0;i<paramAr.length;i++){
    		addParam(paramAr[i]);
    		em.appendText("jcdpPageParams['"+paramAr[i]+"'] = '"+params.get(paramAr[i])+"';");
    	}
    	em.appendText("\n");
	}
	/**
	 * 根据参数名取参数值，需要将值从ISO-8859-1转换成UTF-8编码
	 * @param key
	 */
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
	
	protected void printSelOptions(Element em)throws IOException{
    	List<ICfgNode> selNodes = tlHd.selectNodes("Options/Select");
    	if(selNodes==null) return;
  		for(int i=0;i<selNodes.size();i++){
  			ICfgNode selNode = selNodes.get(i);
  			em.appendText("var "+selNode.getAttrValue("name")+" = new Array(\n");
  			String sais_select_name = selNode.getAttrValue("sais_select_name");
  			String optStr = "";
  			if(sais_select_name!=null){
//  				em.appendText(PagerFactory.getOptionsStr(selNode.getAttrValue("name"))+"\n");
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
	  			optStr = optionSb.toString()+"\n";
//	  			em.appendText(optionSb.toString()+"\n");
  			}
  			String noNull = selNode.getAttrValue("noNull");
  			if("false".equals(noNull)){  //判断是否加空option
  				optStr = "['',' ']," + optStr;
			}
  			em.appendText(optStr);
  			em.appendText(");\n\n");
  		}    	
    }
}
