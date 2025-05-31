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

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}



function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/td/toSaveTdStandDoc.srq";
		form.submit();
		newClose();
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
	if(!notNullForCheck("file","申请领取标准列表")) return false;
	if(!notNullForCheck("projectInfoNo","申请人所属项目")) return false;
	if(!notNullForCheck("receiveOrg","申请人所属单位")) return false;
	if(!notNullForCheck("docFileType","标准类别")) return false;
	return true;
}

function page_init(){

	var fileId = '<%=request.getParameter("id")%>';	
	var docType = '<%=request.getParameter("docType")%>';	
	
	if(fileId!='null'){
		var querySql = " select t.file_id,t.file_name,t.ucm_id,t.doc_type,t.doc_file_type,t.parent_file_id,to_char(t.upload_date,'yyyy-MM-dd') upload_date,t.creator_id,e.employee_name,t.receive_id, e1.employee_name receive_name, t.project_info_no, p.project_name,t.receive_org,i.org_name receive_org_name from bgp_doc_gms_file t left join comm_human_employee e on t.creator_id=e.employee_id and e.bsflag='0' left join gp_task_project p on p.project_info_no=t.project_info_no left join comm_human_employee e1 on t.receive_id = e1.employee_id  left join comm_org_information i on t.receive_org=i.org_id where t.file_id='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas!=null && datas.length>0){
			document.getElementById("projectInfoNo").value = datas[0].project_info_no;
			document.getElementById("projectName").value = datas[0].project_name;
			document.getElementById("creatorId").value = datas[0].creator_id;
			document.getElementById("employeeName").value = datas[0].employee_name;
			document.getElementById("receiveOrg").value = datas[0].receive_org;
			document.getElementById("receiveOrgName").value = datas[0].receive_org_name;
			document.getElementById("uploadDate").value = datas[0].upload_date;
			document.getElementById("docType").value = datas[0].doc_type;
			document.getElementById("fileId").value = datas[0].file_id;
			var ucmId = datas[0].ucm_id;
			document.getElementById("ucmId").value = ucmId;			
			document.getElementById("fileUrl").href = "<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+ucmId;
			document.getElementById("fileUrl").style.display = "block";
			var docFileType = datas[0].doc_file_type;
			
			var item = document.getElementById("docFileType");
		    for(var i=0;i<item.options.length;i++)
	        {
	            if(item.options[i].value == docFileType)
	            {
	            	item.options[i].selected = true;
	                break;
	            }
	        }
		}
						
	}else{
		
		document.getElementById("docType").value = docType;
		var querySql = " select e.employee_id,e.employee_name from comm_human_employee e where e.employee_id='<%=userId%>' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas!=null && datas.length>0){
			document.getElementById("creatorId").value = datas[0].employee_id;
			document.getElementById("employeeName").value = datas[0].employee_name;
		}	
		
		var querySql1 = " select e.project_info_no,e.project_name from gp_task_project e where e.project_info_no='<%=projectInfoNo%>' ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		if(datas1!=null && datas1.length>0){
			document.getElementById("projectInfoNo").value = datas1[0].project_info_no;
			document.getElementById("projectName").value = datas1[0].project_name;
		}
		
	}		
}

//选择项目
function selectTeam(){

    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
    if(result!=""){
    	var checkStr = result.split("-");	
	        document.getElementById("projectInfoNo").value = checkStr[0];
	        document.getElementById("projectName").value = checkStr[1];
    }
}


//选择单位
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("receiveOrg").value = teamInfo.fkValue;
        document.getElementById("receiveOrgName").value = teamInfo.value;
    }
}
//选择人
function selectEmployee(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("receiveId").value = teamInfo.fkValue;
        document.getElementById("receiveName").value = teamInfo.value;
    }
}
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
 	       <td class="inquire_item4">申请人：</td>
           <td class="inquire_form4">
          
           <input name="docType" id="docType" class="input_width" value="" type="hidden" readonly="readonly"/>
           <input name="fileId" id="fileId" class="input_width" value="" type="hidden" readonly="readonly"/>
           <input name="creatorId" id="creatorId" class="input_width" value="" type="hidden" readonly="readonly"/>
           <input name="employeeName" id="employeeName" class="input_width" value="" type="text" readonly="readonly"/>
           <input name="ucmId" id="ucmId" class="input_width" value="" type="hidden" readonly="readonly"/>
           </td>
           <td class="inquire_item4">申请日期：</td>
           <td class="inquire_form4">
           <input name="uploadDate" id="uploadDate" class="input_width" value="<%=curDate%>" type="text" />    
           <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
			onmouseover="calDateSelector(uploadDate,tributton1);" />      
           </td>
	  </tr>	 
	   	 <tr>
 	       <td class="inquire_item4">申请人所属单位：</td>
           <td class="inquire_form4">
           		<input name="receiveOrg" id="receiveOrg" class="input_width" value="" type="hidden" readonly="readonly"/>
           		<input name="receiveOrgName" id="receiveOrgName" class="input_width" value="" type="text" readonly="readonly"/>
           		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>   
           </td>
 	       <td class="inquire_item4">申请人所属项目：</td>
           <td class="inquire_form4">
           		 <input name="projectInfoNo" id="projectInfoNo" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>
           		<input name="projectName" id="projectName" class="input_width" value="" type="text" readonly="readonly"/>
           </td>
	  </tr>	
 	 <tr>
 	       <td class="inquire_item4">标准类别：</td>
           <td class="inquire_form4">
           <select name="docFileType" id="docFileType" class="select_width">
	           <option value=''>请选择</option>
	           <option value='0110000061000000020'>企业标准</option>
	           <option value='0110000061000000021'>国家标准</option>	          
	           <option value='0110000061000000023'>行业标准</option>
	           <option value='0110000061000000022'>其他标准</option>
           </select>
           </td>
           <td class="inquire_item4">申请领取标准列表：</td>
           <td class="inquire_form4">
           <input name="file" id="file" class="input_width" value="" type="file" />
           <a href="" id="fileUrl" name="fileUrl" style="display:none">下载</a></td>  
           <td class="inquire_item4">&nbsp;</td>        
           <td class="inquire_form4">&nbsp;</td>        
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
