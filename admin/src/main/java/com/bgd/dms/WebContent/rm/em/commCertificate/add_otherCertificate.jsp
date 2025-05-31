<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

    String action = request.getParameter("action");
    String addButtonDisplay="";
    if("view".equals(action)) addButtonDisplay="none";
    String codingCode = request.getParameter("codingCode");
    String codingCodeId = request.getParameter("codingCodeId");

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
['BGP_COMM_HUMAN_CERTIFICATE']
);
var defaultTableName = 'BGP_COMM_HUMAN_CERTIFICATE';
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
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}

function save(){
	if(checkForm()){
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/rm/em/toSaveCommHumanCertificate.srq";
		form.submit();
		newClose();
	}
}

function checkForm(){
	return true;
}

function savejsp(){
	
	var coding_code=document.getElementById("coding_code").value;
	var coding_code_id=document.getElementById("coding_code_id").value;
	
	var rowNum = document.getElementById("lineNum").value;	
	
	var rowParams = new Array();
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
		
		var bsflag = document.getElementsByName("bsflag_"+i)[0].value;
		var certificate_no = document.getElementsByName("certificate_no_"+i)[0].value;			
		var employee_id = document.getElementsByName("employee_id_"+i)[0].value;			
		var work_unit = document.getElementsByName("work_unit_"+i)[0].value;			
		var training_institutions = document.getElementsByName("training_institutions_"+i)[0].value;			
		var training_date = document.getElementsByName("training_date_"+i)[0].value;			
		var training_type = document.getElementsByName("training_type_"+i)[0].value;			
		var emergency_type = document.getElementsByName("emergency_type_"+i)[0].value;			
		var against_date = document.getElementsByName("against_date_"+i)[0].value;			
		var against_post = document.getElementsByName("against_post_"+i)[0].value;			
		var medical_date = document.getElementsByName("medical_date_"+i)[0].value;			
		
		rowParam['coding_code'] = coding_code;		
		rowParam['coding_code_id'] = coding_code_id;		
		rowParam['bsflag'] = bsflag;		
		rowParam['certificate_no'] = certificate_no;
		rowParam['employee_id'] = employee_id;
		rowParam['work_unit'] = work_unit;
		rowParam['training_institutions'] = encodeURI(encodeURI(training_institutions));
		rowParam['training_date'] = training_date;
		rowParam['training_type'] = encodeURI(encodeURI(training_type));
		rowParam['emergency_type'] = encodeURI(encodeURI(emergency_type));
		rowParam['against_date'] = against_date;
		rowParam['against_post'] = encodeURI(encodeURI(against_post));
		rowParam['medical_date'] = medical_date;
		
		rowParam['creator'] = '<%=userName%>';
		rowParam['updator'] = '<%=userName%>';
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';


		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams);

		saveFunc("bgp_comm_human_certificate",rows);

		top.frames('list').frames('mainFrame').loadDataDetail(coding_code_id);
		
		newClose();
}


function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
	}	
}

function openSearch(rowNum){
	
	popWindow('<%=contextPath%>/rm/em/commCertificate/searchHumanList.jsp?rowid='+rowNum,'800:605'); 	
}

function getMessage(arg){
	var rowNum = document.getElementsByName("showMessage")[0].value=arg[0];
	var result = document.getElementsByName("showMessage2")[0].value=arg[1];
	
	if(result!="" && result!=undefined ){
		
		var checkStr = result.split(",");
        document.getElementById("employeeId_"+rowNum).value = result.split("-")[0];
        document.getElementById("employeeName_"+rowNum).value = result.split("-")[1];
        document.getElementById("workUnit_"+rowNum).value = result.split("-")[2];
        document.getElementById("orgName_"+rowNum).value = result.split("-")[3];
	}
}

function selectEmployee(rowNum){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("employeeId_"+rowNum).value = teamInfo.fkValue;
        document.getElementById("employeeName_"+rowNum).value = teamInfo.value;
    }
}

//选择申请单位
function selectOrg(rowNum){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("workUnit_"+rowNum).value = teamInfo.fkValue;
        document.getElementById("orgName_"+rowNum).value = teamInfo.value;
    }
}

function addLine(certificate_nos,employee_ids, employee_names, work_units, org_names, training_institutionss, training_dates, training_types, emergency_types, against_dates, against_posts, medical_dates,document_ids,certificate_nums,qualification_names){
	
	var certificate_no = "";
	var employee_id = "";
	var employee_name = "";
	var work_unit = "";
	var org_name = "";
	var training_institutions = "";
	var training_date = "";
	var training_type = "";
	var emergency_type = "";
	var against_date = "";
	var against_post = "";
	var medical_date = "";
	var document_id = "";
	var qualification_name="";
	var certificate_num = "";
	
	if(certificate_nos != null && certificate_nos != ""){
		certificate_no=certificate_nos;
	}
	if(employee_ids != null && employee_ids != ""){
		employee_id=employee_ids;
	}
	if(employee_names != null && employee_names != ""){
		employee_name=employee_names;
	}
	if(work_units != null && work_units != ""){
		work_unit=work_units;
	}
	if(org_names != null && org_names != ""){
		org_name=org_names;
	}
	if(training_institutionss != null && training_institutionss != ""){
		training_institutions=training_institutionss;
	}
	if(training_dates != null && training_dates != ""){
		training_date=training_dates;
	}
	if(training_types != null && training_types != ""){
		training_type=training_types;
	}
	if(emergency_types != null && emergency_types != ""){
		emergency_type=emergency_types;
	}
	if(against_dates != null && against_dates != ""){
		against_date=against_dates;
	}
	if(against_posts != null && against_posts != ""){
		against_post=against_posts;
	}
	if(medical_dates != null && medical_dates != ""){
		medical_date=medical_dates;
	}
	if(document_ids != null && document_ids != ""){
		document_id=document_ids;
	}
	if(qualification_names != null && qualification_names != ""){
		qualification_name=qualification_names;
	}
	
	if(certificate_nums != null && certificate_nums != ""){
		certificate_num=certificate_nums;
	}
	
	var rowNum = document.getElementById("lineNum").value;	
	
	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	var trainingDate = "trainingDate_"+rowNum;
	var againstDate = "againstDate_"+rowNum;
	var medicalDate = "medicalDate_"+rowNum;
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="certificateNo' + '_' + rowNum + '" id="certificateNo' + '_' + rowNum + '" value="'+certificate_no+'"/>'+'<input type="hidden"  name="employeeId' + '_' + rowNum + '" id="employeeId' + '_' + rowNum + '" value="'+employee_id+'"/>'+'<input type="text" readonly="readonly"  id="employeeName' + '_' + rowNum + '"  name="employeeName' + '_' + rowNum + '" value="'+employee_name+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" onclick="openSearch(\''+rowNum+'\')"/>';
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden" id="workUnit' + '_' + rowNum + '" name="workUnit' + '_' + rowNum + '" value="'+work_unit+'"/>'+'<input type="text" readonly="readonly"   id="orgName' + '_' + rowNum + '"  name="orgName' + '_' + rowNum + '" value="'+org_name+'" onFocus="this.select()"/>';
    
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text"  name="qualificationName' + '_' + rowNum + '"  id="qualificationName' + '_' + rowNum + '" value="'+qualification_name+'" onFocus="this.select()"  />';
	
	
	
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text"  name="certificateNum' + '_' + rowNum + '"  id="certificateNum' + '_' + rowNum + '" value="'+certificate_num+'" onFocus="this.select()"/>';
	
	
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="trainingInstitutions' + '_' + rowNum + '" id="trainingInstitutions' + '_' + rowNum + '" value="'+training_institutions+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" readonly="readonly"  name="trainingDate' + '_' + rowNum + '" id="trainingDate' + '_' + rowNum + '" value="'+training_date+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+trainingDate+',tributton1'+rowNum+');" />';
	
	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="trainingType' + '_' + rowNum + '" id="trainingType' + '_' + rowNum + '" value="'+training_type+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="emergencyType' + '_' + rowNum + '" id="emergencyType' + '_' + rowNum + '" value="'+emergency_type+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(8);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly" name="againstDate' + '_' + rowNum + '" id="againstDate' + '_' + rowNum + '" value="'+against_date+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+againstDate+',tributton2'+rowNum+');" />'+'<input type="hidden"   name="bsflag' + '_' + rowNum + '" value="0"/>';
	
	var td = tr.insertCell(9);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="againstPost' + '_' + rowNum + '" id="againstPost' + '_' + rowNum + '" value="'+against_post+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(10);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly" name="medicalDate' + '_' + rowNum + '" id="medicalDate' + '_' + rowNum + '" value="'+medical_date+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton3'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+medicalDate+',tributton3'+rowNum+');" />';
	
	var td = tr.insertCell(11);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden" name="oldDocumentId' + '_' + rowNum + '"  id="oldDocumentId' + '_' + rowNum + '"  value="'+document_id+'" />'+'<input type="file" name="documentId' + '_' + rowNum + '" id="documentId' + '_' + rowNum + '" value="" onFocus="this.select()"/>';
	
	var td = tr.insertCell(12);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<span class="sc" style="display:<%=addButtonDisplay%>"><a href="#" onclick="deleteLine(\'' + tr.id + '\')"></a></span>';
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
		
}

function page_init(){
	
	queryCertificateList();
	var certificate_no = '<%=request.getParameter("id")%>';	
//	var action = '<%=request.getParameter("action")%>';
	if(certificate_no!='null'){
		var querySql = "select s.certificate_no,s.coding_code_id,s.coding_code,s.employee_id,e.employee_name,s.work_unit, i.org_name, s.training_institutions,s.training_date, s.training_type, s.emergency_type,s.against_date, s.against_post, s.medical_date,s.document_id ,s.qualification_name , s.certificate_num  from bgp_comm_human_certificate s left join comm_human_employee e on s.employee_id = e.employee_id and e.bsflag = '0' left join comm_org_information i on s.work_unit = i.org_id  and i.bsflag = '0' left join comm_org_subjection su on e.org_id = su.org_id  and su.bsflag = '0' where s.bsflag = '0' and s.certificate_no='<%=request.getParameter("id")%>'  order by s.modifi_date";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && queryRet.datas.length; i++) {
			addLine(datas[i].certificate_no,datas[i].employee_id,datas[i].employee_name,datas[i].work_unit,datas[i].org_name,datas[i].training_institutions,datas[i].training_date,datas[i].training_type,datas[i].emergency_type,datas[i].against_date,datas[i].against_post,datas[i].medical_date,datas[i].document_id,datas[i].certificate_num,datas[i].qualification_name);
		}			
	}
}

function queryCertificateList(){
	
	var query1Sql = "select t.coding_code_id AS value, t.coding_name AS label from comm_human_coding_sort t where t.coding_lever='1' and t.coding_code_id='<%=codingCode%>' order by t.coding_show_order ";
	var query1Ret = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+query1Sql);
	var datas1 = query1Ret.datas;
	var selectObj1 = document.getElementById("coding_code");
	document.getElementById("coding_code").innerHTML="";
	if(datas1!=null){
		for(var i=0;i<datas1.length;i++){
			var option = new Option(datas1[i].label,datas1[i].value);
			selectObj1.add(option,i);
		}
	}
		
	var query2Sql = "SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_human_coding_sort t where t.coding_lever='2' and t.bsflag = '0' and t.superior_code_id='<%=codingCode%>' order by t.coding_show_order ";
	var query2Ret = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+query2Sql);
	var datas2 = query2Ret.datas;
	var selectObj2 = document.getElementById("coding_code_id");
	document.getElementById("coding_code_id").innerHTML="";
	if(datas2!=null){
		for(var i=0;i<datas2.length;i++){
			var option = new Option(datas2[i].label,datas2[i].value);
			if(datas2[i].value == '<%=codingCodeId%>'){
				option.selected=true;
			}
			selectObj2.add(option,i);
		}
	}
}

function importData(){
	var obj=window.showModalDialog('<%=contextPath%>/rm/em/commCertificate/otherImportFile.jsp',"","dialogHeight:500px;dialogWidth:600px");

	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){
			var check = checkStr[i].split("@");
			addLine("",check[11],check[12],check[13],check[14],check[4],check[5],check[6],check[7],check[8],check[9],check[10],"",check[3],check[2]);
		}
		
	}
}


</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">
<form id="CheckForm" action="" method="post" target="mainFrame" enctype="multipart/form-data">
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    <tr>
    	<td class="inquire_item4">岗位类别：</td>
      	<td class="inquire_form4"><select id="coding_code" class="select_width"  name="coding_code" ></select></td>
      	<td class="inquire_item4">资格证书类别：</td>
      	<td class="inquire_form4"><select id="coding_code_id" class="select_width"  name="coding_code_id" ></select></td>
    </tr>
</table>
</div>  
	<div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr align="right">
		<td width="93%">&nbsp;
		<input type="hidden" name="showMessage" value=""/>
		<input type="hidden" name="showMessage2" value=""/>
		</td>
	    <td><span class="zj" style="display:<%=addButtonDisplay%>"><a href="#" onclick="addLine()"></a></span>
	        <span class="dr" style="display:<%=addButtonDisplay%>"><a href="#" onclick="importData()"></a></span>
	    </td>
	  </tr>
	</table>
	</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
	</table>
	</div>
<div  style="width:1000;overflow-x:scroll;overflow-y:scroll;">			
	<table id="lineTable" width="1500" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd">姓名</td>
            <td class="bt_info_even">工作单位</td>
            <td class="bt_info_odd">资格证名称</td>
            <td class="bt_info_even">资格证编号</td>
            <td class="bt_info_odd">培训机构</td>
            <td class="bt_info_even">培训时间</td>
            <td class="bt_info_odd">培训种类</td>
            <td class="bt_info_even">急救种类</td>
            <td class="bt_info_odd">接害时间</td>
            <td class="bt_info_even">接害岗位</td>			
            <td class="bt_info_odd">体检时间</td>    
            <td class="bt_info_even">文档上传</td>       
            <td class="bt_info_odd" style="display:<%=addButtonDisplay%>">操作
            <input type="hidden" id="lineNum"  name="lineNum" value="0"/>
             <input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" /></td> 
        </tr>
    </table>	
</div>
    <div id="oper_div">
        <span class="bc_btn" style="display:<%=addButtonDisplay%>"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>
</html>
