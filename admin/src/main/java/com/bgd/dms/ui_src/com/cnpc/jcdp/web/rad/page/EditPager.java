/**
 * ����ʵ����޸�ҳ��
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADUtil;
import com.cnpc.jcdp.web.rad.util.RADConst.PMDAction;

/**
 * @author rechete
 *
 */
@SuppressWarnings({"serial","unused"})
public class EditPager extends BasePager{
	protected boolean isContainFileField = false;
	protected boolean isContainFilesField = false;
	protected String sql;
	protected String itemsSql;
	protected String lineRange;
	
	//����ӡ�ύ��ť�͹رհ�ť���������ӱ�Ĳ鿴ҳ��
	protected boolean noSubmitButton = false;
	//����ӡ�رհ�ť�����ڲ˵����еĲ˵��༭ҳ��
	protected boolean noCloseButton = false;
	
	protected String popSize;
	
	public EditPager(){
		pmdAction = RADConst.PMDAction.S_U;		
	}
	
	public boolean isNoCloseButton(){
		return noCloseButton;
	}
	
	public boolean isNoSubmitButton(){
		return noSubmitButton;
	}
	
	public String getPopSize(){
		return popSize;
	}
	
	public  void printPagerScript()throws IOException{
		if("toJsp".equals(action)){
	    	  if(isViewAction())
	    		  print("<%@ include file=\"/common/pmd_view.jsp\"%>\r\n");
	    	  else if(isAddAction())
	    		  print("<%@ include file=\"/common/pmd_add.jsp\"%>\r\n");
	    	  else print("<%@ include file=\"/common/pmd_edit.jsp\"%>\r\n");
	      }
	      else{
		      print("<link rel=\"stylesheet\" type=\"text/css\" media=\"all\" href=\"");
		      print(contextPath);
		      print("/css/calendar-blue.css\"  />\r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/calendar.js\"></script>\r\n");
		      print("<script type=\"text/JavaScript\" src=\"");
		      print(contextPath);
		      print("/js/calendar-en.js\"></script>\r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/calendar-setup.js\"></script>\r\n");
		      print("\r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/rt/rt_base.js\"></script>\r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/rt/rt_cru.js\"></script>\r\n");  
		     
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/rt/proc_base.js\"></script>\r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/rt/fujian.js\"></script>\r\n");
		      
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/rt/rt_validate.js\"></script>\r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      if(isViewAction())
		    	  print("/js/rt/rt_view.js\"></script> \r\n");
		      else if(isAddAction())
		    	  print("/js/rt/rt_add.js\"></script> \r\n");
		      else print("/js/rt/rt_edit.js\"></script> \r\n");
		      print("<script type=\"text/javascript\" src=\"");
		      print(contextPath);
		      print("/js/json.js\"></script> \r\n");      
		      print("\r\n");
	      }
	      print("<!--Remark JavaScript����-->\r\n");
	      print("<script language=\"javaScript\">\r\n");
	      
	      printJavaScript(request);
	
	      print("</script>\r\n");		
	}

	/**
	 * ��ȡ����
	 */
    protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{	
		List<ICfgNode> nodes = tlHd.selectNodes("//EntityFields/field");
		if(nodes==null) return;
		for(int i=0;i<nodes.size();i++){
			String defaultValue = nodes.get(i).getAttrValue("defaultValue");
			if(defaultValue!=null) addParams(defaultValue,request);
		}
    	
    	sql = tlHd.getSingleNodeValue("//QuerySQL/sql");
    	sql = RADUtil.deleteLineFeed(sql);
    	addParams(sql,request);
    	
    	itemsSql = tlHd.getSingleNodeValue("//QueryItemsSQL/sql");
    	addParams(itemsSql,request);
    	
    	lineRange = request.getParameter("lineRange");
    }
    
    /**
     * ���headԪ���е�ҳ�����
     * @throws IOException
     */
    
	private void printHeadPageTitle()throws IOException{
        if(isViewAction())
      	  print("<title>JCDP_title_view</title>\r\n");
        else if(isAddAction())
      	  print("<title>JCDP_title_new</title>\r\n");
        else print("<title>JCDP_title_edit</title>\r\n");    	
    }
	
    public void process(HttpServletRequest request, HttpServletResponse response)
    	throws java.io.IOException, ServletException {
	  try {
		  noCloseButton = "true".equals(request.getParameter("noCloseButton"));
		  popSize = request.getParameter("popSize");
		  
		  response.setContentType("text/html;charset=GBK");
		  tpt.printHeader();		  
		  tpt.printBody();
	  } catch (Throwable t) {
		  t.printStackTrace();
	  } finally {
		 if(out!=null) flush();
	  }
    }
    
    public void printSubmitButtons(HttpServletRequest request)throws IOException{
	      println("<div style=\"padding-top:3;width:100%;height:10;\">");
	      print("\t<table cellSpacing=0 cellPadding=0 width=\"100%\" align=center border=0 class=\"small\"> \r\n");
	      if(isComplexAction()){
	          println("\t<!--Remark �ӱ���ɾ��ť��-->");
	          println("\t<tr>");
	          println("\t<td align=\"left\">");
	          println("\t<input type=\"button\" class=\"button approve\" value=\"���\" onClick=\"addItem()\"/>");
	          println("\t<input type=\"button\" class=\"button approve\" value=\"ɾ��\" onClick=\"deleteItem()\"/>");
	          println("\t</td>");
	          println("\t</tr>");    	  
	      }
	      println("\t<!--Remark ҳ�汣�水ť��-->");
	      print("\t<tr>\r\n");
	      print("\t\t<td colspan=\"4\" align=\"center\">\r\n");
	      if(!isViewAction())
	    	  print("\t\t<input type=\"button\" class=\"button save\" value=\"����\" onClick=\"submitFunc()\"/>\r\n");
	      if(!"true".equals(request.getParameter("noCloseButton"))){
//	    	  print("\t\t<input type=\"button\" class=\"button cancel\" value=\"�ر�\" onClick=\"window.close()\"/>\r\n");
	    	  System.out.println("*******************************");
	    	  System.out.println(tpt.getWindowCloseFunc());
	    	  print("\t\t<input type=\"button\" class=\"button cancel\" value=\"�ر�\" onClick=\""+tpt.getWindowCloseFunc()+"\"/>\r\n");
	      }
	      print("\t\t</td>\r\n");
	      print("\t</tr>\r\n");
	      print("\t</table>  \r\n"); 
	      println("</div>");  		
  	}
  
	/*protected void printItemsTable(HttpServletRequest request)throws IOException{
		  
	}*/

	protected String composeTitle(String pageTitle){
		String ret = null;
		if(pageTitle.indexOf("{CRU}")>=0){
			if(isViewAction())
	    		ret = pageTitle.replaceFirst("\\u007BCRU}", "JCDP_title_view");
	    	else if(isAddAction()) 
	    		ret = pageTitle.replaceFirst("\\u007BCRU}", "JCDP_title_new");
	    	else ret = pageTitle.replaceFirst("\\u007BCRU}", "JCDP_title_edit");
		}else{
			ret = "JCDP_title_edit----"+pageTitle;
	    	if(isViewAction())
	    		ret = "JCDP_title_view----"+pageTitle;
	    	else if(isAddAction()) ret = "JCDP_title_new----"+pageTitle;			
		}

    	return ret; 
    }
    

	
	/**
	 * ��pmd�ļ��л�ȡjs
	 */
	protected void printPmdJs()throws IOException{
  	    String jsStr = tlHd.getSingleNodeValue("//JavaScripts/CRU"); 
  	    List<String> funcNames = new ArrayList<String>();
  	    funcNames.add("page_init()");
        funcNames.add("submitFunc()");
        funcNames.add("toSubmitForm(uploadRet)");
        funcNames.add("afterSubmit(retObject,successHint,failHint)");
  	    if(jsStr!=null){
  	    	println(jsStr);
  	    	addJsFuncs(jsStr,funcNames);
  	    }
  	    if(super.isEditAction()){
  	    	jsStr = tlHd.getSingleNodeValue("//JavaScripts/U");
  	    	if(jsStr!=null){
  	    		println(jsStr);  	    	
  	    		addJsFuncs(jsStr,funcNames);
  	    	}
  	    }
  	    if(super.isAddAction()){
  	    	jsStr = tlHd.getSingleNodeValue("//JavaScripts/C");
  	    	if(jsStr!=null){
  	    		println(jsStr);  	    	
  	    		addJsFuncs(jsStr,funcNames);
  	    	}	    	
  	    }
  	    if(super.isViewAction()){
  	    	jsStr = tlHd.getSingleNodeValue("//JavaScripts/R");
  	    	if(jsStr!=null){
  	    		println(jsStr);  	    	
  	    		addJsFuncs(jsStr,funcNames);
  	    	}	    	
  	    }    	    
	}
	
  	private void printJavaScript(HttpServletRequest request)throws IOException{
  		String pageTitle = tlHd.getSingleNodeValue("//PageTitle");
  		print("var cruTitle = \""+composeTitle(pageTitle)+"\";\r\n");
  		
  		printSavedParams();
  		
  		printSelOptions();  		
  		printJcdpCodes();
  		
  		print("var jcdp_record = null;\r\n");
  		printFields(request,PMDAction.S_U);
  	    
  		printPmdJs();
  		
  	    printPageInit();
  	    
  	    printSubmitJs();
  	    
  	    printAfterSubmitJs();
  	    
  	    printOtherJs();
  	}
  	
  	protected void printOtherJs()throws IOException{
  		
  	}
  	
  	protected void printPageInit()throws IOException{
  		if(pmdJsFuncNames.get("page_init()")!=null) return;
  		print("\r\n");
        print("function page_init(){\r\n");
        print("\tgetObj('cruTitle').innerHTML = cruTitle;\r\n");
        print("\tcruConfig.contextPath = \"");
        print(contextPath);
        print("\";\r\n");
        String backUrl = request.getParameter("backUrl");
        if(backUrl!=null)
        	println("\tcruConfig.openerUrl = \""+request.getParameter("backUrl")+"\";");
        if("1".equals(lineRange))
        	print("\tcruConfig.lineRange = '1';\r\n");        
		sql = replaceParamsAndUserProp(sql);
        print("\tcruConfig.querySql = \""+sql+"\";\r\n");
        print("\tcru_init();\r\n");
        print("}\r\n");  		
  	} 
  	
  	/**
  	 * ��������
  	 * @throws IOException
  	 */
  	protected void printSubmitJs()throws IOException{
  		if(pmdJsFuncNames.get("submitFunc()")!=null) return;
  		
  		println("");
  		if(isContainFileField && (isAddAction()||isEditAction())){  
  			if(pmdJsFuncNames.get("submitFunc()")==null){
  	  			println("function submitFunc(){");
  		        print("\tsubmitStr = getSubmitStr();\r\n");
  		        print("\tif(submitStr == null) return;\r\n");
  				if(isContainFilesField){
  					println("\tvar uploadFile=checkUploadFiles();");
  				}else{
  					println("\tvar uploadFile=checkUploadFile();");
  				}
  		        println("\tif(uploadFile=='true'){");
  	  			println("\tdocument.fileForm.action = cruConfig.contextPath+appConfig.uploadFileAction;");
  	  			println("\tdocument.fileForm.submit();");
		        println("\t}else{");
		        println("\tvar path = cruConfig.contextPath+cruConfig.addOrUpdateAction;");
		        println("\tvar retObject = syncRequest('Post',path,submitStr);");
		        println("\tafterSubmit(retObject);");
		        println("\t}");
  	  	     	println("}");
  	  			println("");  				
  			}
  			if(pmdJsFuncNames.get("toSubmitForm(uploadRet)")!=null) return;
  			println("function toSubmitForm(uploadRet){");
  		}  		
  		
  		if(!(isContainFileField && (isAddAction()||isEditAction()))) print("function submitFunc(){\r\n");
  		if(isContainFileField && (isAddAction()||isEditAction())){ 
  			println("\tif(uploadRet.returnCode!=0){");
  			println("\t\talert(uploadRet.returnMsg);");
  			println("\t\treturn;");
  			println("\t}");
  		}
        //����޸�
        if(tlHd.selectNodes("//Tables/Table")!=null){
        	println("	var submitStr = \"jcdp_tables=\"+JSON.stringify(tables);");
			println("	for(var i=0;i<tables.length;i++){");
			println("	  var tableName = tables[i][0];");
			println("	  var tSubmitStr = '';");
			println("	  if(tableName==defaultTableName) tSubmitStr = getSubmitStr();");
			println("	  else 	tSubmitStr = getSubmitStr(tableName);");
			println("     if(tSubmitStr == null) return;");
			println("	  submitStr += \"&\"+tableName+\"=\"+JSON.stringify(submitStr2Array(tSubmitStr));");
			println("	}");
			println("	");
			println("	var path = cruConfig.contextPath+cruConfig.updateMulTableAction;");
			println("	var retObject = syncRequest('Post',path,submitStr);");
        }else{//�����޸�
	        print("\tvar path = cruConfig.contextPath+cruConfig.addOrUpdateAction;\r\n");
	        print("\tsubmitStr = getSubmitStr();\r\n");
	        print("\tif(submitStr == null) return;\r\n");   
	        
	        if(isContainFileField && (isAddAction()||isEditAction())){
	        	println("\tvar fileFieldsIndex = getFileFieldsIndex();");
	        	println("\tsubmitStr += \"&fileFieldsIndex=\"+fileFieldsIndex+\"&fileMsgId=\"+uploadRet.msgId;");   
	        }
	        print("\tvar retObject = syncRequest('Post',path,submitStr);\r\n");
        }
        println("\tafterSubmit(retObject);");
        print("}\r\n");
        println("");  		
  	}
  	
  	protected boolean isContainField(String fieldAction){
  		boolean ret = false;
  		
  		if(fieldAction==null) ret = true;
  		else if(isAddAction() && fieldAction.indexOf("C")>=0) ret = true;
  		else if(isViewAction() && fieldAction.indexOf("R")>=0) ret = true;
  		else if(isEditAction() && fieldAction.indexOf("U")>=0) ret = true;
  		
  		return ret;
  	}  	
  	
  	protected void printFields(HttpServletRequest request,String action)throws IOException{
  		List<ICfgNode> tables = tlHd.selectNodes("//Tables/Table");
  		String tableName = tlHd.getSingleNodeValue("//QuerySQL/tableName"); 
  		if(tables!=null){
  			println("/**");
			println(" ���ֶ�Ҫ��������ݿ����");
			println("*/");  			
  			println("var tables = new Array(");
  			for(int i=0;i<tables.size();i++){
  				ICfgNode table = tables.get(i);
  				if(i>0) print(",");
  				print("['"+table.getAttrValue("name")+"'");
  				if(isAddAction()){
  	  				String value = table.getValue();
  	  				if(value!=null && !"".equals(value.trim())) print(",'"+value.trim()+"'");  					
  				}
  				println("]"); 				
  			}
  			println(");");
  			println("var defaultTableName = '"+tableName+"';");
  		}
  		
  		println("/**0�ֶ�����1��ʾlabel��2�Ƿ���ʾ��༭��Hide,Edit,ReadOnly��");
  		println("   3�ֶ����ͣ�TEXT(�ı�),N(����),NN(����),D(����),EMAIL,ET(Ӣ��)��");
  		println("             MEMO(��ע)��SEL_Codes(�����),SEL_OPs(�Զ��������б�) ��FK(�����)��");
  		println("   4������볤�ȣ�");
  		println("   5Ĭ��ֵ��'CURRENT_DATE'��ǰ���ڣ�'CURRENT_DATE_TIME'��ǰ����ʱ�䣬");  	
  		if(PMDAction.S_U.equals(action) || PMDAction.S_R.equals(action)){
  			println("           �༭���޸�ʱ���Ϊ�ձ�ʾȡ0�ֶ�����Ӧ��ֵ��'{ENTITY.fieldName}'��ʾȡfieldName��Ӧ��ֵ��");
  		} 		
  		println("           ����Ĭ��ֵ");
  		println("   6�����ĳ��ȣ�7�������Զ������ֵ�򵯳�ҳ������ӣ�8 �Ƿ�ǿգ�ȡֵΪnon-empty�����������*");
  		println("   9 Column Name��10 Event,11 Table Name");
  		println("*/");
  		List<ICfgNode> nodes = tlHd.selectNodes("//EntityFields/field");
  	    print("var fields = new Array(\r\n"); 	    
  	    if(tlHd.selectNodes("//Tables/Table")==null){
  	  	    print("['JCDP_TABLE_NAME',null,'Hide','TEXT',null,'"+tableName+"']\r\n");
  	  	    if(isEditAction()){
  	  	    	String id = "";
  	  	    	if(params.get("id")!=null) id = params.get("id").toString();
  	  	    	print(",['JCDP_TABLE_ID',null,'Hide','TEXT',null,'"+id+"']\r\n");
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
  	    	//2:�Ƿ�����
  	    	String isShow = node.getAttrValue("isShow");
  	    	if(isShow==null) isShow = "Edit";
  	    	isShow = ",'"+isShow+"'";
  	    	//3:�ֶ�����(SEL_OPs,SEL_Codes)
  	    	String type = node.getAttrValue("type");
  	    	if("FILE".equals(type)|| "FILES".equals(type) || "BYTES".equals(type)){//�����ֶ�
  	    		fileFields += node.getAttrValue("name")+":";
  	    	}
  	    	else if(type==null) type = "TEXT";
  	    	if("FILES".equals(type)){
  	    		isContainFilesField = true;
  	    	}
  	    	type = ",'"+type+"'";  

  	    	//4:������볤��
  	    	String maxLength = node.getAttrValue("maxLength");
  	    	if(maxLength==null) maxLength = ",";
  	    	else maxLength = ",'"+maxLength+"'";  	    	
  	    	//5:Ĭ��ֵ
  	    	String defaultValue = node.getAttrValue("defaultValue");
  	    	defaultValue = replaceParamsAndUserProp(defaultValue);
  	    	if(defaultValue==null) defaultValue = ",";
  	    	else defaultValue = ",'"+defaultValue+"'";  
  	    	//6:�������
  	    	String size = node.getAttrValue("size");
  	    	if(size==null){
  	    		if(",'MEMO'".equals(type)) size = ",'"+RADConst.DEFAULT_MEMO_COLS+":"+RADConst.DEFAULT_MEMO_ROWS+"'";  	
  	    		else size = ",";
  	    	}
  	    	else{
  	    		if(",'MEMO'".equals(type) && size.indexOf(":")<=0) size += ":"+RADConst.DEFAULT_MEMO_ROWS;//����Ĭ������
  	    		size = ",'"+size+"'"; 	    	
  	    	}
  	    	//����߶�
  	    	if(!",'Hide'".equals(isShow)){
  	    		if(",'MEMO'".equals(type)){ 	    			 
  	    			cruTableHeight +=  5+15*Integer.parseInt(size.substring(size.indexOf(":")+1,size.length()-1));
  	    			tableRows = Math.round(tableRows);
  	    		}else tableRows += 0.5;
  	    	}
  	    	
  	    	//7:�������ֵ�򵯳�����
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
  	    	//8:�Ƿ�ǿ�
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
  	    	println(sb.toString());
  	    }
  	    print(");\r\n");
  	    cruTableHeight += Math.round(tableRows)*25;
  	    
  	    print("var uniqueFields = '"+uniqueFields+"';\r\n");  
  	    print("var fileFields = '"+fileFields+"';\r\n");  
  	    if(!":".equals(fileFields)) isContainFileField = true;
  	}
  	
  	protected String getFieldValue(String value){
  		String ret = ",";
  		if(value!=null) ret = ",'"+value+"'"; 
  		return ret;
  	}
  	
  	private void printAfterSubmitJs()throws IOException{
//  		System.out.println("****************************************************");
//  		System.out.println(pmdJsFuncNames);
  		if(pmdJsFuncNames.get("afterSubmit(retObject,successHint,failHint)")!=null) return;
  		println("function afterSubmit(retObject,successHint,failHint){");
  		println("\tif(retObject==null){ alert('retObject==null');return;}");
  		println("\tif(successHint==undefined) successHint = '�ύ�ɹ�';");
  		println("\tif(failHint==undefined) failHint = '�ύʧ��';");
  		print("\tif (retObject.returnCode != \"0\") alert(failHint);\r\n");
        print("\telse{\r\n");
        System.out.println("backUrl = " + request.getParameter("backUrl"));
  		if(request.getParameter("backUrl")==null){
	        println("\t\talert(successHint);");
//	        System.out.println(tpt.getClass().getName());
//	        System.out.println(tpt.getParentRefreshFunc());
//	        System.out.println(tpt.getWindowCloseFunc());
	        println("\t\t"+ tpt.getParentRefreshFunc()+ "\r\n");
	        println("\t\t"+ tpt.getWindowCloseFunc() +"\r\n");
//	        print("\t\twindow.opener.refreshData();\r\n");
//	        print("\t\twindow.close();\r\n");
        }else{
        	println("\t\twindow.location = cruConfig.contextPath+cruConfig.openerUrl;");
        }      		
  		println("\t}");
  		println("}");
  		println("");
  	}
}
