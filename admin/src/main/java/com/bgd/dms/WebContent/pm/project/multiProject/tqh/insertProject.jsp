<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	String projectType = request.getParameter("projectType")==null?"":request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
</head>
<body>
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" style="overflow: hidden;">
					<div id="tab_box" class="tab_box" style="overflow: hidden;">
						<div id="tab_box_content0" class="tab_box_content">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<!-- 
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>EPS：</td>
									<td class="inquire_form4" colspan="3"><input type="text" id="eps" name="eps" value="" class="input_width" /></td>
								</tr>
							 -->
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>项目名：</td>
									<td class="inquire_form4" id="item0_0"><input type="text" id="project_name" name="project_name" value="" class="input_width" />
									</td>
									<td class="inquire_item4">项目编号：</td>
									<td class="inquire_form4" id="item0_1"><input type="text" id="project_id" name="project_id" value="从ERP系统自动获取" disabled="disabled" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">项目类型：</td>
									<td class="inquire_form4" id="item0_2">
										<input type="hidden" id="project_type" name="project_type" value="<%=projectType%>" class="input_width" />
										<select class=select_width name="project_type_name" id="project_type_name" >
											<option value='5000100004000000001'>陆地项目</option>
											<option value='5000100004000000002'>浅海项目</option>
											<option value='5000100004000000010'>滩浅海过渡带</option>
										</select>
									</td>
									<td class="inquire_item4">项目状态：</td>
									<td class="inquire_form4" id="item0_3">
										<select name="project_status" id="project_status" class="select_width">
											<option value="5000100001000000001">项目启动</option>
											<option value="5000100001000000002">正在施工</option>
											<option value="5000100001000000003">项目结束</option>
											<option value="5000100001000000004">项目暂停</option>
											<option value="5000100001000000005">施工结束</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>市场范围：</td>
									<td class="inquire_form4" id="item0_4">
										<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
										<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /></td>
									<td class="inquire_item4">年度：</td>
									<td class="inquire_form4" id="item0_5">
										    <select id="project_year" name="project_year" class="select_width">
										    <%
										    Date date = new Date();
										    int years = date.getYear()+ 1900 - 10;
										    int year = date.getYear()+1900;
										    for(int i=0; i<20; i++){
										    %>
										    <option value="<%=years %>" <%	if(years == year) {  %> selected="selected" <% } %> > <%=years %> </option>
										    <%
										    years++;
										    }
										     %>
										    </select>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>计划采集开始时间：</td>
									<td class="inquire_form4" id="item0_6">
										<input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" />
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>计划采集结束时间：</td>
									<td class="inquire_form4" id="item0_7"><input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
									&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_end_time,tributton2);" />
									</td>
								</tr>
								
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>合同开始时间：</td>
									<td class="inquire_form4" id="item0_9">
										<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_start_date,tributton3);" />
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>合同结束时间：</td>
									<td class="inquire_form4" id="item0_10">
										<input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_end_date,tributton4);" />
									</td>
								</tr>
								<!-- 
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>项目预计开始时间：</td>
									<td class="inquire_form4" id="item0_20">
										<input type="text" id="project_plan_start_date" name="project_plan_start_date" value="" class="input_width" />
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(project_plan_start_date,tributton5);" />
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>项目预计结束时间：</td>
									<td class="inquire_form4" id="item0_21">
										<input type="text" id="project_plan_end_date" name="project_plan_end_date" value="" class="input_width" />
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(project_plan_end_date,tributton6);" />
									</td>
								</tr>
								 -->
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>项目重要程度：</td>
									<td class="inquire_form4" id="item0_8"><code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" /></td>
									<td class="inquire_item4"><span class="red_star">*</span>项目业务类型：</td>
									<td class="inquire_form4" id="item0_17">
										<code:codeSelect cssClass="select_width" name='project_business_type' option="projectBusinessType" selectedValue="" addAll="true" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>国内/国外：</td>
									<td class="inquire_form4" id="item0_12">
										<select class=select_width name=project_country id="project_country">
												<option value="1">国内</option>
												<option value="2">国外</option>
										</select>
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>甲方单位：</td>
									<td class="inquire_form4" id="item0_13">
										<input id="manage_org" name="manage_org" value="" type="hidden" class="input_width" />
										<input id="manage_org_name" name="manage_org_name" value="" type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectManageOrgCode('manage_org','manage_org_name');" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>勘探类型：</td>
									<td class="inquire_form4" id="item0_14">
										<select class=select_width name=explore_type>
											<option value='1'>普查</option>
											<option value='2'>详查</option>
											<option value='3'>预探</option>
											<option value='4'>评价</option>
											<option value='5'>开发</option>
											<option value='6'>其它</option>
										</select>
									</td>
									<td class="inquire_item4">资料处理单位：</td>
									<td class="inquire_form4" id="item0_15">
										<input type="text" id="processing_unit" name="processing_unit" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>勘探方法：</td>
									<td class="inquire_form4" id="item0_11">
										<select class=select_width name=exploration_method  id="exploration_method" onChange="changeExploration(this.value)">
											<option value="0300100012000000002">二维地震</option>
											<option value="0300100012000000003">三维地震</option>
											<!-- <option value="0300100012000000029">二维/三维</option> -->
										</select>
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>激发方式：</td>
									<td class="inquire_form4" id="item0_16">
										<select class=select_width name=build_method  id="build_method">
											<option value='5000100003000000003'>气枪</option>
											<option value='5000100003000000001'>井炮</option>
											<option value='5000100003000000004'>井炮/震源</option>
											<option value='5000100003000000005'>气枪/井炮</option>
											<option value='5000100003000000007'>气枪/井炮/震源</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>利润中心：</td>
									<td class="inquire_form4" id="item0_18">
										<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
										<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" />
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>施工队伍：</td>
									<td class="inquire_form4" id="item0_19">
										<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
										<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
									</td>
								</tr>
								<%-- <tr>
									<td class="inquire_item4">动迁时间：</td>
									<td class="inquire_form4">
										<input type="text" id="transit_time" name="transit_time" value="" class="input_width" />
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(transit_time,tributton5);" />
									</td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr> --%>
							</table>
						</div>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
	</form>
</body>

<script type="text/javascript">
var projectType="<%=projectType%>";

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
	//window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100100014',teamInfo);
	window.showModalDialog('<%=contextPath%>/common/selectManageOrg.jsp',teamInfo,'dialogWidth=600px;dialogHeight=600px');
	if(teamInfo.fkValue!=""){
		document.getElementById('manage_org').value = teamInfo.fkValue;
		document.getElementById('manage_org_name').value = teamInfo.value;
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
function selectPrctr(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/pm/comm/selectSAPProjectOrg.jsp', teamInfo);
		if (teamInfo.fkValue != "") {
			document.getElementById('prctr').value = teamInfo.fkValue;
			document.getElementById('prctr_name').value = teamInfo.value;
		}
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}

	function save() {
		if (!checkForm()) return;
		document.getElementById("project_type").value = document.getElementById("project_type_name").value;;
		Ext.MessageBox.wait('请等待','处理中');
		var params = $("#form1").serialize();
		cruConfig.contextPath = '<%=contextPath%>';
		var retObj = jcdpCallService("ProjectSrv", "addProject",params);
		parent.list.frames[1].location.reload();
		newClose();
	}

	function checkForm(){ 	

		if (!isTextPropertyNotNull("project_name", "项目名")) {		
			document.form1.project_name.focus();
			return false;	
		}
		
		if (!isTextPropertyNotNull("market_classify_name", "市场范围")) {		
			document.form1.market_classify_name.focus();
			return false;	
		}
		
		if (!isTextPropertyNotNull("acquire_start_time", "计划采集开始时间")) {		
			document.form1.acquire_start_time.focus();
			return false;	
		}
		
		if (!isTextPropertyNotNull("acquire_end_time", "计划采集结束时间")) {		
			document.form1.acquire_end_time.focus();
			return false;	
		}
		if($("#is_main_project").val() == ""){
			alert("请选择 项目重要程度!");
			return false;
		}
		if (!isTextPropertyNotNull("manage_org_name", "甲方单位")) {		
			document.form1.manage_org_name.focus();
			return false;	
		}
		if($("#build_method").val() == ""){
			alert("请选择 激发方式!");
			return false;
		}
		if($("#project_business_type").val() == ""){
			alert("请选择 项目业务类型!");
			return false;
		}
		if (!isTextPropertyNotNull("prctr_name", "利润中心")) {		
			document.form1.prctr_name.focus();
			return false;	
		}
		if (!isTextPropertyNotNull("org_name", "施工队伍")) {		
			document.form1.org_name.focus();
			return false;	
		}

		return true;
	}
	
	function refreshData() {
		document.getElementById("form1").submit();
		newClose();
	}

	function changeExploration(value){
		if("0300100012000000029"==value){//二维/三维
			$("#build_method").html("<option value='5000100003000000003'>气枪</option>"+
									"<option value='5000100003000000001'>井炮</option>");
		}else{
			$("#build_method").html("<option value='5000100003000000003'>气枪</option>"+
									"<option value='5000100003000000001'>井炮</option>"+
									"<option value='5000100003000000004'>井炮/震源</option>"+
									"<option value='5000100003000000005'>气枪/井炮</option>"+
									"<option value='5000100003000000007'>气枪/井炮/震源</option>");
		}
	}
</script>
</html>