<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	
	String projectType = "5000100004000000008";
	if (request.getParameter("projectType") != null) {
		projectType = request.getParameter("projectType");
	}

	String projectFatherNo = request.getParameter("projectFatherNo");
	if ("".equals(projectFatherNo) || projectFatherNo == null) {
		projectFatherNo = "";
	}

	IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
	String sql = " select project_year from gp_task_project where project_info_no = '"+projectFatherNo+"'";
	Map map = jdbcDAO.queryRecordBySQL(sql);
	
	String projectYear = map.get("project_year").toString();
	
	String orgSubjectionId = "C105";
	if (request.getParameter("orgSubjectionId") != null) {
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId = "C6000000000001";
	if (request.getParameter("orgId") != null) {
		orgId = request.getParameter("orgId");
	}
	String projectFatherName = request
			.getParameter("projectFatherName") == null
			? ""
			: java.net.URLDecoder.decode(
					request.getParameter("projectFatherName"), "utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/extjs/ext-all.js"></script>
</head>
<body>
	<form name="form1" id="form1" method="post"
		action="<%=contextPath%>/ws/pm/project/test2.srq">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tab_box" class="tab_box">
					<div id="tab_box_content0" class="tab_box_content">
						<table width="100%" border="1" cellspacing="0" cellpadding="0"
							class="tab_line_height" id="Offsettable">
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目名：</td>
								<td class="inquire_form4" id="item0_0">
								    <input type="hidden"
									id="project_father_no" name="project_father_no"
									value="<%=projectFatherNo%>" class="input_width" />
									<input type="text" id="project_name" name="project_name" value=""
									class="input_width" /></td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text"
									id="project_id" name="project_id" value="从ERP系统自动获取"
									disabled="disabled" class="input_width_no_color" /></td>
							</tr>
							<tr>
							<td class="inquire_item4"><span class="red_star">*</span>井号：</td>
							<td class="inquire_form4" id="item0_9"><input type="text"
									id="well_no" name="well_no" value=""
									class="input_width" /></td>
							<td class="inquire_item4"><span class="red_star">*</span>预测价值工作量：</td>
							<td class="inquire_form4" id="item0_9"><input type="text"
									id="project_income" name="project_income" value=""
									class="input_width" />万元</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2"><input type="hidden"
									id="project_type" name="project_type" value="<%=projectType%>"
									class="input_width" /> <select class=select_width
									name="project_type_name" id="project_type_name"
									disabled="disabled">
										<option value='5000100004000000008'>井中地震</option>
								</select></td>
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5">
								<input type="text"
									id="project_year" name="project_year" value="<%=projectYear%>"
									class="input_width_no_color" readonly="readonly"/> 
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>甲方交井时间：</td>
								<td class="inquire_form4" id="item0_6"><input type="text"
									id="start_time" name="start_time" value=""
									class="input_width" readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=contextPath%>/images/calendar.gif" id="tributton1"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(start_time,tributton1);" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>预计完工时间：</td>
								<td class="inquire_form4" id="item0_7"><input type="text"
									id="end_time" name="end_time" value=""
									class="input_width" readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=contextPath%>/images/calendar.gif" id="tributton2"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(end_time,tributton2);" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>带队领导：</td>
								<td class="inquire_form4" id="item0_9"><input type="text"
									id="project_man" name="project_man" value=""
									class="input_width" /></td>
								<td class="inquire_item4"><span class="red_star">*</span>项目重要程度：</td>
								<td class="inquire_form4" id="item0_8">
									<select name="is_main_project" id="is_main_project" class="select_width">
										<option value="">--请选择--</option>
										<option value="0300100008000000001">集团重点</option>
										<option value="0300100008000000002">地区（局）重点</option>
										<option value="0300100008000000005" selected="selected">正常</option>
									</select>

								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>国内/国外：</td>
								<td class="inquire_form4" id="item0_12"><select
									class=select_width name=project_country id="project_country">
										<option value="1">国内</option>
										<option value="2">国外</option>
								</select></td>
								<td class="inquire_item4"><span class="red_star">*</span>甲方单位：</td>
								<td class="inquire_form4" id="item0_13"><input
									id="manage_org" name="manage_org" value="" type="hidden"
									class="input_width" /> <input id="manage_org_name"
									name="manage_org_name" value="" type="text" class="input_width"
									readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=request.getContextPath()%>/images/magnifier.gif"
									style="cursor: hand;" border="0"
									onclick="selectManageOrgCode('manage_org','manage_org_name');" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>施工队伍：</td>
								<td class="inquire_form4" id="item0_19">
									<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
									<input id="org_name" name="org_name" value="" type="text" class="input_width_no_color" readonly="readonly" />
									&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目业务类型：</td>
								<td class="inquire_form4" id="item0_17"><code:codeSelect
										cssClass="select_width" name='project_business_type'
										option="projectBusinessType" selectedValue="" addAll="true" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>利润中心：</td>
								<td class="inquire_form4" id="item0_18">
								<input type="hidden" id="prctr" name="prctr" value="G0150100" class="input_width" />
								<input type="text" id="prctr_name" name="prctr_name" value="新兴物探开发处" class="input_width_no_color" readonly="readonly" /> &nbsp;&nbsp;
								</td>
								<td class="inquire_item4"></td>
								<td class="inquire_item4"></td>
							</tr>
							
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>常规项目：</td>
								<td>
									<input type="hidden" id="project_common" value="" />
								    <input type="radio" name="project_common" id="project_common1"  value="1" checked="checked"/>常规项目&nbsp;&nbsp;
									<input type="radio" name="project_common" id="project_common0"  value="0" />非常规项目
								</td>
							</tr>
							
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>激发方式：</td>
								<td colspan="3">
									<input type="hidden" id="build_method" name="build_method" value="" class="input_width" /> 
									<input type="checkbox" name="build_method_name" value="5000100003000000001" id="5000100003000000001" />井炮&nbsp;&nbsp;
									<input type="checkbox" name="build_method_name" value="5000100003000000002" id="5000100003000000002" />震源&nbsp;&nbsp;
									<input type="checkbox" name="build_method_name" value="5000100003000000003" id="5000100003000000003" />气枪&nbsp;&nbsp;
									<input type="checkbox" name="build_method_name" value="5000100003000000010" id="5000100003000000010" />井下扫描源&nbsp;&nbsp;
									<input type="checkbox" name="build_method_name" value="5000100003000000011" id="5000100003000000011" />井下脉冲源&nbsp;&nbsp;
									<input type="checkbox" name="build_method_name" value="5000100003000000012" id="5000100003000000012" />其他&nbsp;&nbsp;
								</td>
							</tr>
							
							<tr>
								<input type="hidden" id="build_type" name="build_type" value="" class="input_width" />
								<td class="inquire_item4"><span class="red_star">*</span>激发设备型号：</td>
								<td colspan="3"><input type="radio" name="build_type" id="build_type_1" checked="checked" value="zy"/>可控震源型号<input id="source_version" name="source_version" type="text" />可控震源台数<input id="source_num" name="source_num" type="text" /></td>
							</tr>
							
							<tr>
								<td class="inquire_item4"></td>
								<td colspan="3"><input type="radio" name="build_type" id="build_type_2" value="zj"/>钻机型号&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="drill_version" name="drill_version" type="text" />钻机台数&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="drill_depth" name="drill_depth" type="text" /></td>
							</tr>
							<tr>
								<td class="inquire_item4"></td>
								<td colspan="3"><input type="radio" name="build_type" id="build_type_3" value="qt"/>其他设备型号<input id="qt_version" name="qt_version" type="text" /> 其他设备数量<input id="qt_num" name="qt_num" type="text" /></td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>仪器型号：</td>
								<td class="inquire_item4"><input type="text"
									id="instrument_model" name="instrument_model" value=""
									class="input_width" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>仪器级数：</td>
								<td class="inquire_item4"><input type="text"
									id="instrument_level" name="instrument_level" value=""
									class="input_width" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>动迁车辆(台)：</td>
								<td class="inquire_item4"><input type="text"
									id="relocation_vehicle" name="relocation_vehicle" value=""
									class="input_width" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>完钻井深(米)：</td>
								<td class="inquire_item4"><input type="text"
									id="total_depth" name="total_depth" value=""
									class="input_width" />
								</td>
								
							</tr>
							<tr>
								<td class="inquire_item4">最大井斜深度(度)：</td>
								<td class="inquire_item4"><input type="text"
									id="well_deviation_depth" name="well_deviation_depth" value=""
									class="input_width" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>最大井深(米)：</td>
								<td class="inquire_item4"><input type="text"
									id="max_well_depth" name="max_well_depth" value=""
									class="input_width" />
								</td>
								
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>最大井温(℃)：</td>
								<td class="inquire_item4"><input type="text"
										id="well_temperature" name="well_temperature" value=""
										class="input_width" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>井压力：</td>
								<td class="inquire_item4"><input type="text"
									id="well_pressure" name="well_pressure" value=""
									class="input_width" />
								</td>
								
							</tr>
							
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>井身结构：</td>
								<td class="" colspan="3">
								套管井段：<input type="text" id="drivepipe_depth" name="drivepipe_depth" value=""/>
								最小套管尺寸：<input type="text" id="drivepipe_size" name="drivepipe_size" value=""/>
								裸眼井段：<input type="text" id="open_hole_depth" name="open_hole_depth" value=""/>
								</td>
							</tr>
							
						</table>
					</div>
				</div>
			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="save()"></a> </span> <span
					class="gb_btn"><a href="#" onclick="newClose()"></a> </span>
			</div>
		</div>
	</form>
</body>

<script type="text/javascript">
//根据上一页选择对项目类型下拉框赋值
var projectType="<%=projectType%>";
var projectFatherName="<%=projectFatherName%>";
var projectFatherNo="<%=projectFatherNo%>";
var orgId = "<%=orgId%>";
if(""!=projectFatherNo){
	var obj = jcdpCallService("WtProjectSrv","getOrgNameByOrgId","orgId="+orgId);
	if(obj != null) {
		$("#org_name").val(obj.org_abbreviation);
		$("#org_id").val(orgId);
	}
}

var sel = document.getElementById("project_type_name").options;
for(var i=0;i<sel.length;i++)
{
    if(projectType==sel[i].value)
    {
       document.getElementById('project_type_name').options[i].selected=true;
    }
}

function selectManageOrg(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100100014',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('manage_org').value = teamInfo.fkValue;
		document.getElementById('manage_org_name').value = teamInfo.value;
	}
}


function selectTeam(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectTeam.jsp',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('org_id').value = teamInfo.fkValue;
		document.getElementById('org_name').value = teamInfo.value;
	}
}



function selectMarketClassify(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100500006',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('market_classify').value = teamInfo.fkValue;
		document.getElementById('market_classify_name').value = teamInfo.value;
	}
}


function selectManageOrgCode(objId,objName){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectManageOrg.jsp',teamInfo,'dialogWidth=600px;dialogHeight=600px');
	if(teamInfo.fkValue!=""){
		document.getElementById(objId).value = teamInfo.fkValue;
		document.getElementById(objName).value = teamInfo.value;
    }
}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}
	
	function checkForm(){
		var checkboxArray;
		var well_val="";
		var poin_val="";
		var acquire_level="";
		var str="";
		
		var project_name = document.getElementById("project_name").value;
		if(project_name.length==0){
			alert("项目名不能为空");
			return false;
		}
		
		var project_income = document.getElementById("project_income").value;
		if(project_income.length==0){
			alert("预测价值工作量不能为空");
			return false;
		}
		
		
		var well_no = document.getElementById("well_no").value;
		if(well_no.length==0){
			alert("井号不能为空");
			return false;
		}
		
		
		var start_time = document.getElementById("start_time").value;
		if(start_time.length==0){
			alert("甲方交井时间不能为空");
			return false;
		}
		
		var end_time = document.getElementById("end_time").value;
		if(end_time.length==0){
			alert("预计完工时间不能为空");
			return false;
		}
		
		var manage_org = document.getElementById("manage_org").value;
		if(manage_org.length==0){
			alert("甲方单位不能为空");
			return false;
		}
		
		var instrument_model = document.getElementById("instrument_model").value;
		if(instrument_model.length==0){
			alert("仪器型号不能为空");
			return false;
		}
		
		
		var instrument_level = document.getElementById("instrument_level").value;
		if(instrument_level.length==0){
			alert("仪器级数不能为空");
			return false;
		}
		
		var instrument_level = document.getElementById("instrument_level").value;
		if(instrument_level.length==0){
			alert("仪器级数不能为空");
			return false;
		}
		
		
		var relocation_vehicle = document.getElementById("relocation_vehicle").value;
		if(relocation_vehicle.length==0){
			alert("动迁车辆不能为空");
			return false;
		}
		
		
		var total_depth = document.getElementById("total_depth").value;
		if(total_depth.length==0){
			alert("完钻井深不能为空");
			return false;
		}
		
		var well_temperature = document.getElementById("well_temperature").value;
		if(well_temperature.length==0){
			alert("最大井温不能为空");
			return false;
		}
		
		var well_pressure = document.getElementById("well_pressure").value;
		if(well_pressure.length==0){
			alert("井压力不能为空");
			return false;
		}
		
		
		var project_man = document.getElementById("project_man").value;
		if(project_man.length==0){
			alert("带队领导不能为空");
			return false;
		}
		
		
		//拼接激发方式
		checkboxArray = document.getElementsByName("build_method_name");
		str="";
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				str+=checkboxArray[i].value+",";
			}
		}
		str =str.substring(0,str.lastIndexOf(','));
		if (""!=str) {
			document.getElementById('build_method').value=str;
		}else{
			alert("请选择激发方式!");
			return false;
		}
		
		
		//激发类型
		checkboxArray = document.getElementsByName("build_type");
		str="";
		var version_val;
		var num_val;
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				str=checkboxArray[i].value;
				if(str=="zy"){
					var source_version = document.getElementById('source_version').value
					var source_num = document.getElementById('source_num').value
					if(source_version==""||source_version.length==0){
						alert("请输入震源型号");
						return ;
					}else{
						version_val = source_version;
					}
					if(source_num==""||source_num.length==0){
						alert("请输入震源台数");
						return ;
					}else{
						num_val = source_num;
					}
				}
				
				if(str=="zj"){
					var drill_version = document.getElementById('drill_version').value
					var drill_depth = document.getElementById('drill_depth').value
					if(drill_version==""||drill_version.length==0){
						alert("请输入钻井型号");
						return ;
					}else{
						version_val = drill_version;
					}
					if(drill_depth==""||drill_depth.length==0){
						alert("请输入钻井深度");
						return ;
					}else{
						num_val = drill_depth;
					}
				}
				
				if(str=="qt"){
					var qt_version = document.getElementById('qt_version').value
					var qt_num = document.getElementById('qt_num').value
					if(qt_version==""||qt_version.length==0){
						alert("请输入其他设备型号");
						return ;
					}else{
						version_val = qt_version;
					}
					if(qt_num==""||qt_num.length==0){
						alert("请输入其他设备台数");
						return ;
					}else{
						num_val = qt_num;
					}
				}
			}
		}
		document.getElementById('build_type').value=str+"@"+version_val+"@"+num_val;
		
		
		
		
		
		
		//常规/非常规
		checkboxArray = document.getElementsByName("project_common");
		str="";
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				str=checkboxArray[i].value;
			}
		}
		document.getElementById('project_common').value=str;
		
		return true;
	}
	
	
	function save() {
		if (!checkForm()) return;
		var params = $("#form1").serialize();
		cruConfig.contextPath = '<%=contextPath%>';
		
		var str = "project_father_no="+document.getElementById("project_father_no").value;
		str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
		str += "&project_type="+document.getElementById("project_type").value;
		str += "&project_year="+document.getElementById("project_year").value;
		str += "&start_time="+document.getElementById("start_time").value;
		str += "&end_time="+document.getElementById("end_time").value;
		str += "&is_main_project="+document.getElementById("is_main_project").value;
		str += "&project_country="+document.getElementById("project_country").value;
		str += "&manage_org="+document.getElementById("manage_org").value;
		str += "&manage_org_name="+document.getElementById("manage_org_name").value;
		str += "&org_id="+document.getElementById("org_id").value;
		str += "&org_name="+document.getElementById("org_name").value;
		str += "&project_business_type="+document.getElementById("project_business_type").value;
		str += "&prctr="+document.getElementById("prctr").value;
		str += "&prctr_name="+document.getElementById("prctr_name").value;
		str += "&project_man="+document.getElementById("project_man").value;
		str += "&project_common="+document.getElementById("project_common").value;
		str += "&build_method="+document.getElementById("build_method").value;
		str += "&build_type="+document.getElementById("build_type").value;
		
		
		str += "&well_no="+document.getElementById("well_no").value;
		str += "&project_income="+document.getElementById("project_income").value;
		str += "&instrument_model="+document.getElementById("instrument_model").value;
		str += "&instrument_level="+document.getElementById("instrument_level").value;
		str += "&relocation_vehicle="+document.getElementById("relocation_vehicle").value;
		str += "&total_depth="+document.getElementById("total_depth").value;
		str += "&well_deviation_depth="+document.getElementById("well_deviation_depth").value;
		str += "&max_well_depth="+document.getElementById("max_well_depth").value;
		str += "&well_temperature="+document.getElementById("well_temperature").value;
		str += "&well_pressure="+document.getElementById("well_pressure").value;
		str += "&drivepipe_depth="+document.getElementById("drivepipe_depth").value;
		str += "&drivepipe_size="+document.getElementById("drivepipe_size").value;
		str += "&open_hole_depth="+document.getElementById("open_hole_depth").value;
		
		
		var retObj = jcdpCallService("WsProjectSrv", "addSubProject",str);
		
		if(""==projectFatherNo){
			parent.list.frames[1].location.reload();
			newClose();
		}else{
			var projFName=encodeURI(encodeURI(projectFatherName));
			window.location ='<%=contextPath%>/pm/project/singleProject/ws/subProjectList.jsp?projectFatherName='+projFName+'&projectFatherNo=<%=projectFatherNo%>&orgSubjectionId=<%=orgSubjectionId%>&projectType='+projectType;
		}
	}
</script>
</html>