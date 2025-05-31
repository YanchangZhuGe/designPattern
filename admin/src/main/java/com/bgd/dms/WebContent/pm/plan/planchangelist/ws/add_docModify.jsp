<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
    String ids = request.getParameter("ids");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<!-- 上传控件相关的js css-->
<link rel="stylesheet" href="<%=contextPath %>/js/upload/uploadify.css" type="text/css"></link>
<script type="text/javascript" src="<%=contextPath %>/js/upload/jquery.uploadify.v2.1.4.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/uploadfile.js"></script>
<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['comm_coding_sort_deatil']
);
var defaultTableName = 'comm_coding_sort_deatil';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	
cruConfig.contextPath =  "<%=contextPath%>";

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/pm/project/doc/saveSingleDocJH.srq";
		form.submit();
//		newClose();
	}
}

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}

function checkForm(){
	if(!notNullForCheck("doc_name","文档名称")) return false;
	return true;
}

function writeDocName(){
	var fileName = document.getElementById("file").value;
	var asd = fileName.lastIndexOf("\\");
	fileName = fileName.substr(asd+1);
	document.getElementById("doc_name").value = fileName;
}

function page_init(){
	debugger;
	var fileId = '<%=request.getParameter("id")%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	

	if(fileId!='null'){
		var querySql = " select t.file_id,t.file_name,t.ucm_id,t.file_abbr,to_char(t.create_date,'yyyy-MM-dd') create_date,t.creator_id,e.user_name from bgp_doc_gms_file t left join p_auth_user e on t.creator_id=e.user_id and e.bsflag='0'  where t.file_id='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas!=null && datas.length>0){
			document.getElementById("employeeName").value = datas[0].user_name;
			document.getElementById("createDate").value = datas[0].create_date;
			document.getElementById("doc_name").value = datas[0].file_name;
			document.getElementById("fileAbbr").value = datas[0].file_abbr;
			document.getElementById("fileId").value = datas[0].file_id;
			document.getElementById("ucmId").value = datas[0].ucm_id;
//			var retObj = jcdpCallService("HseSrv", "getFileName", "ucmId="+datas[0].ucm_id);
//			document.getElementById("doc_name").innerHTML = retObj.fileName;
//			document.getElementById("doc_name").href = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id+"&&emflag=0";
		}
		
	}else{
//		document.getElementById("doc_name").display = true;
		document.getElementById("employeeName").value = "<%=user.getUserName()%>";
		document.getElementById("fileAbbr").value = fileAbbr;
	}
	
	
}

 
</script>
</head>
<body onload="page_init();">
<form id="CheckForm" action="" method="post" >
<input type="hidden" name="upload_file_name" id="upload_file_name"/>
<input type="hidden" name="doc_type" id="doc_type"/>
    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
 	       <td class="inquire_item4">创建人：</td>
           <td class="inquire_form4">
           <input name=fileId id="fileId" class="input_width" value="" type="hidden" readonly="readonly"/>
           <input name="projectInfoNo" id="projectInfoNo" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>
           <input name="fileAbbr" id="fileAbbr" class="input_width" value="" type="hidden" readonly="readonly"/>
           <input name="employeeName" id="employeeName" class="input_width" value="" type="text" readonly="readonly"/>
           <input name="ucmId" id="ucmId" class="input_width" value="" type="hidden" readonly="readonly"/>
            <input name="relation_id" id="relation_id" class="input_width" value="<%=ids %>" type="hidden" readonly="readonly"/>
           </td>
           <td class="inquire_item4">创建时间：</td>
           <td class="inquire_form4">
           <input name="createDate" id="createDate" class="input_width" value="<%=curDate%>" type="text" />    
           <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
			onmouseover="calDateSelector(createDate,tributton1);" />      
           </td>
	  </tr>	 
 	 <tr>
 	       <td class="inquire_item4">文档名称：</td>
           <td class="inquire_form4"><input name="doc_name" id="doc_name" class="input_width" value="" type="text" /></td>
           <!--  
           <td class="inquire_item4">附件：</td>
           <td class="inquire_form4"><a id="doc_name" style="float: left;" href="" ></a>
           <input name="file" id="file" class="input_width" value="" type="file" onchange="writeDocName()"/>          
           </td>
           -->
	  </tr>	 
	  <tr>
    	<td class="inquire_item4"><font color="red">*</font>附件：</td>
    	<td colspan = "3"> 
       	 	<div style="float:left" id="fileQueue" style="border:1px solid green;width:400px"></div>
			<div id="file_content" style="float:left"> <input type="file"  name="file" id="file"/>	 </div>
			<div id="status-message"></div> 
		</td>
      </tr>	             
 	</table>
	</div>  

    <div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>
</html>
