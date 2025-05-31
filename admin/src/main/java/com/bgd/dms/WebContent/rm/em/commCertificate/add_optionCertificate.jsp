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
    String codingCodeId = request.getParameter("codingCodeId")==null?"":request.getParameter("codingCodeId");
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
		var certificate_num = document.getElementsByName("certificate_num_"+i)[0].value;			
		var issuing_agency = document.getElementsByName("issuing_agency_"+i)[0].value;			
		var issuing_date = document.getElementsByName("issuing_date_"+i)[0].value;			
		var certificate_site = document.getElementsByName("certificate_site_"+i)[0].value;			
		var qualification_name = document.getElementsByName("qualification_name_"+i)[0].value;			
		var professional = document.getElementsByName("professional_"+i)[0].value;			
		var qualification_level = document.getElementsByName("qualification_level_"+i)[0].value;			
		var validity = document.getElementsByName("validity_"+i)[0].value;			
		var drive_type = document.getElementsByName("drive_type_"+i)[0].value;			
		var start_date = document.getElementsByName("start_date_"+i)[0].value;		
		var medical_date = document.getElementsByName("medical_date_"+i)[0].value;			
		var training_institutions = document.getElementsByName("training_institutions_"+i)[0].value;			
		var doctor_qualification = document.getElementsByName("doctor_qualification_"+i)[0].value;			
		var practice_site = document.getElementsByName("practice_site_"+i)[0].value;			
		var practice_type = document.getElementsByName("practice_type_"+i)[0].value;			
		var practice_scope = document.getElementsByName("practice_scope_"+i)[0].value;			
		var practice_num = document.getElementsByName("practice_num_"+i)[0].value;			
		
		rowParam['coding_code'] = coding_code;		
		rowParam['coding_code_id'] = coding_code_id;		
		rowParam['bsflag'] = bsflag;		
		rowParam['certificate_no'] = certificate_no;
		rowParam['employee_id'] = employee_id;		
		rowParam['work_unit'] = work_unit;		
		rowParam['issuing_agency'] = encodeURI(encodeURI(issuing_agency));
		rowParam['issuing_date'] = issuing_date;
		rowParam['certificate_num'] = certificate_num;
		rowParam['certificate_site'] = encodeURI(encodeURI(certificate_site));
		rowParam['qualification_name'] = encodeURI(encodeURI(qualification_name));
		rowParam['professional'] = encodeURI(encodeURI(professional));
		rowParam['qualification_level'] = encodeURI(encodeURI(qualification_level));
		rowParam['validity'] = validity;
		rowParam['drive_type'] = encodeURI(encodeURI(drive_type));
		rowParam['start_date'] = start_date;
		rowParam['medical_date'] = medical_date;
		rowParam['training_institutions'] = encodeURI(encodeURI(training_institutions));
		rowParam['doctor_qualification'] = encodeURI(encodeURI(doctor_qualification));
		rowParam['practice_site'] = encodeURI(encodeURI(practice_site));
		rowParam['practice_type'] = encodeURI(encodeURI(practice_type));
		rowParam['practice_scope'] = encodeURI(encodeURI(practice_scope));
		rowParam['practice_num'] = encodeURI(encodeURI(practice_num));

		
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

function addLine(certificate_nos,employee_ids, employee_names, work_units, org_names,certificate_nums,  issuing_agencys, issuing_dates,  certificate_sites,  qualification_names,  professionals,  qualification_levels, validitys, drive_types,  start_dates, medical_dates,  training_institutionss,  doctor_qualifications, practice_sites, practice_types,  practice_scopes,  practice_nums,document_ids){
	
	 var certificate_no = "";
     var employee_id = "";
     var employee_name = "";
     var work_unit = "";
     var org_name = "";
     var certificate_num = "";
     var issuing_agency = "";
     var issuing_date = "";
     var certificate_site = "";
     var qualification_name = "";
     var professional = "";
     var qualification_level = "";
     var validity = "";
     var drive_type = "";
     var start_date = "";
     var medical_date = "";
     var training_institutions = "";
     var doctor_qualification = "";
     var practice_site = "";
     var practice_type = "";
     var practice_scope = "";
     var practice_num = "";
     var document_id = "";
     
	
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
	if(issuing_agencys != null && issuing_agencys != ""){
		issuing_agency=issuing_agencys;
	}
	if(certificate_nums != null && certificate_nums != ""){
		certificate_num=certificate_nums;
	}
	if(issuing_dates != null && issuing_dates != ""){
		issuing_date=issuing_dates;
	}
	if(certificate_sites != null && certificate_sites != ""){
		certificate_site=certificate_sites;
	}
	if(qualification_names != null && qualification_names != ""){
		qualification_name=qualification_names;
	}
	if(professionals != null && professionals != ""){
		professional=professionals;
	}
	if(qualification_levels != null && qualification_levels != ""){
		qualification_level=qualification_levels;
	}	
	if(validitys != null && validitys != ""){
		validity=validitys;
	}
	if(drive_types != null && drive_types != ""){
		drive_type=drive_types;
	}
	if(start_dates != null && start_dates != ""){
		start_date=start_dates;
	}
	if(medical_dates != null && medical_dates != ""){
		medical_date=medical_dates;
	}
	if(training_institutionss != null && training_institutionss != ""){
		training_institutions=training_institutionss;
	}
	if(doctor_qualifications != null && doctor_qualifications != ""){
		doctor_qualification=doctor_qualifications;
	}
	if(practice_sites != null && practice_sites != ""){
		practice_site=practice_sites;
	}
	if(practice_types != null && practice_types != ""){
		practice_type=practice_types;
	}
	if(practice_scopes != null && practice_scopes != ""){
		practice_scope=practice_scopes;
	}
	if(practice_nums != null && practice_nums != ""){
		practice_num=practice_nums;
	}
	if(document_ids != null && document_ids != ""){
		document_id=document_ids;
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

	var issuingDate = "issuingDate_"+rowNum;
	var validityDate = "validity_"+rowNum;
	var startDate = "startDate_"+rowNum;
	var medicalDate = "medicalDate_"+rowNum;
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="certificateNo' + '_' + rowNum + '" id="certificateNo' + '_' + rowNum + '" value="'+certificate_no+'"/>'+'<input type="hidden"   name="employeeId' + '_' + rowNum + '" id="employeeId' + '_' + rowNum + '" name="employeeId' + '_' + rowNum + '" value="'+employee_id+'"/>'+'<input type="text" readonly="readonly"   id="employeeName' + '_' + rowNum + '"  name="employeeName' + '_' + rowNum + '" value="'+employee_name+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" onclick="openSearch(\''+rowNum+'\')"/>';
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden" id="workUnit' + '_' + rowNum + '" name="workUnit' + '_' + rowNum + '" value="'+work_unit+'"/>'+'<input type="text" readonly="readonly"    id="orgName' + '_' + rowNum + '"  name="orgName' + '_' + rowNum + '" value="'+org_name+'" onFocus="this.select()"/>';
  
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="certificateNum' + '_' + rowNum + '" id="certificateNum' + '_' + rowNum + '" value="'+certificate_num+'" onFocus="this.select()"/>';
	
	
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="issuingAgency' + '_' + rowNum + '" id="issuingAgency' + '_' + rowNum + '" value="'+issuing_agency+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text"    readonly="readonly"  name="issuingDate' + '_' + rowNum + '"  id="issuingDate' + '_' + rowNum + '" value="'+issuing_date+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+issuingDate+',tributton1'+rowNum+');" />';

	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="certificateSite' + '_' + rowNum + '" id="certificateSite' + '_' + rowNum + '" value="'+certificate_site+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="qualificationName' + '_' + rowNum + '"  id="qualificationName' + '_' + rowNum + '" value="'+qualification_name+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="professional' + '_' + rowNum + '"  id="professional' + '_' + rowNum + '" value="'+professional+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(8);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="qualificationLevel' + '_' + rowNum + '" id="qualificationLevel' + '_' + rowNum + '" value="'+qualification_level+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(9);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" readonly="readonly" name="validity' + '_' + rowNum + '"  id="validity' + '_' + rowNum + '" value="'+validity+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+validityDate+',tributton2'+rowNum+');" />';

	
	var td = tr.insertCell(10);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="driveType' + '_' + rowNum + '" id="driveType' + '_' + rowNum + '" value="'+drive_type+'"/>';
	
	var td = tr.insertCell(11);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" readonly="readonly"  name="startDate' + '_' + rowNum + '"  id="startDate' + '_' + rowNum + '" value="'+start_date+'"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton3'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+startDate+',tributton3'+rowNum+');" />';
    
	var td = tr.insertCell(12);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly"  name="medicalDate' + '_' + rowNum + '"  id="medicalDate' + '_' + rowNum + '" value="'+medical_date+'" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton4'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+medicalDate+',tributton4'+rowNum+');" />';
	
	var td = tr.insertCell(13);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="trainingInstitutions' + '_' + rowNum + '"  id="trainingInstitutions' + '_' + rowNum + '" value="'+training_institutions+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(14);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="doctorQualification' + '_' + rowNum + '" id="doctorQualification' + '_' + rowNum + '" value="'+doctor_qualification+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(15);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="practiceSite' + '_' + rowNum + '" id="practiceSite' + '_' + rowNum + '" value="'+practice_site+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(16);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="practiceType' + '_' + rowNum + '" id="practiceType' + '_' + rowNum + '" value="'+practice_type+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(17);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="practiceScope' + '_' + rowNum + '" id="practiceScope' + '_' + rowNum + '" value="'+practice_scope+'" onFocus="this.select()"/>';
	
	var td = tr.insertCell(18);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text"  name="practiceNum' + '_' + rowNum + '"  id="practiceNum' + '_' + rowNum + '" value="'+practice_num+'" onFocus="this.select()"/>'+'<input type="hidden"    name="bsflag' + '_' + rowNum + '"  id="bsflag' + '_' + rowNum + '" value="0"/>';

	var td = tr.insertCell(19);
	td.className=classCss+"even";
	td.innerHTML =  '<input type="hidden" name="oldDocumentId' + '_' + rowNum + '"  id="oldDocumentId' + '_' + rowNum + '"  value="'+document_id+'" />'+'<input type="file"  name="documentId' + '_' + rowNum + '"  id="documentId' + '_' + rowNum + '" value="" onFocus="this.select()"/>';

	
	var td = tr.insertCell(20);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<span class="sc" style="display:<%=addButtonDisplay%>"><a href="#" onclick="deleteLine(\'' + tr.id + '\')"></a></span>';
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
	
 
	
}

function page_init(){
	
	queryCertificateList();
	var certificate_no = '<%=request.getParameter("id")%>';	
//	var action = '<%=request.getParameter("action")%>';
	if(certificate_no!='null'){
		var querySql = "select s.certificate_no, s.coding_code_id, s.coding_code,s.employee_id, e.employee_name,s.work_unit,i.org_name,s.certificate_num, s.issuing_agency, s.issuing_date, s.certificate_site, s.qualification_name, s.professional, s.qualification_level,s.validity, s.drive_type, s.start_date,s.medical_date, s.training_institutions, s.doctor_qualification, s.practice_site,s.practice_type, s.practice_scope, s.practice_num,s.document_id from bgp_comm_human_certificate s left join comm_human_employee e on s.employee_id = e.employee_id and e.bsflag = '0' left join comm_org_information i on s.work_unit = i.org_id  and i.bsflag = '0' left join comm_org_subjection su on e.org_id = su.org_id  and su.bsflag = '0' where s.bsflag = '0' and s.certificate_no='<%=request.getParameter("id")%>'  order by s.modifi_date";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && queryRet.datas.length; i++) {
			addLine(datas[i].certificate_no, datas[i].employee_id,datas[i].employee_name,datas[i].work_unit,datas[i].org_name,datas[i].certificate_num, datas[i].issuing_agency,  datas[i].issuing_date, datas[i].certificate_site, datas[i].qualification_name, datas[i].professional, datas[i].qualification_level,datas[i].validity, datas[i].drive_type, datas[i].start_date,datas[i].medical_date, datas[i].training_institutions, datas[i].doctor_qualification, datas[i].practice_site,datas[i].practice_type, datas[i].practice_scope, datas[i].practice_num,datas[i].document_id);
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
	var obj=window.showModalDialog('<%=contextPath%>/rm/em/commCertificate/optionImportFile.jsp',"","dialogHeight:500px;dialogWidth:600px");

	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){
			var check = checkStr[i].split("@");
			addLine("",check[19], check[20], check[21], check[22],check[2],  check[3], check[4],  check[5],  check[6],  check[7],  check[8], check[9], check[10],  check[11], check[12],  check[13],  check[14], check[15], check[16],  check[17],  check[18],"");
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
      	<td class="inquire_form4"><select id="coding_code_id" class="select_width" name="coding_code_id" ></select></td>
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
	     <span class="dr" style="display:<%=addButtonDisplay%>"><a href="#" onclick="importData()"></a></span></td>
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
            <td class="bt_info_odd">资格证编号</td>
            <td class="bt_info_even">资格证签发单位</td>
            <td class="bt_info_odd">资格证签发日期</td>
            <td class="bt_info_even">发证地</td>
            <td class="bt_info_odd">资格证名称</td>
            <td class="bt_info_even">专业类别</td>
            <td class="bt_info_odd">资格级别</td>
            <td class="bt_info_even">有效期</td>
            <td class="bt_info_odd">准驾车型</td>
            <td class="bt_info_even">起始日期</td>
            <td class="bt_info_odd">体检日期</td>
            <td class="bt_info_even">培训机构</td>
            <td class="bt_info_odd">医师资格</td>
            <td class="bt_info_even">执业地点</td>
            <td class="bt_info_odd">执业类别</td>
            <td class="bt_info_even">执业范围</td>
            <td class="bt_info_odd">执业证号</td>  
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
