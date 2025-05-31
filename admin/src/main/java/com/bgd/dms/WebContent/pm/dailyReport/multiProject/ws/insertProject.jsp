<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();

	String projectType = "";
	if(request.getParameter("projectType") != null){
		projectType = request.getParameter("projectType");
	}
	
	String projectFatherNo=request.getParameter("projectFatherNo");
	if("".equals(projectFatherNo) || projectFatherNo == null){
		projectFatherNo = "";
	}
	
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	String projectFatherName=request.getParameter("projectFatherName")==null?"":java.net.URLDecoder.decode(request.getParameter("projectFatherName"),"utf-8");
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
</head>
<body>
	<form name="form1" id="form1" method="post" action="<%=contextPath%>/ws/pm/project/test2.srq">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>项目名：</td>
									<td class="inquire_form4" id="item0_0">
									<input type="hidden" id="project_father_no" name="project_father_no" value="<%=projectFatherNo%>" class="input_width" />
									<input type="text" id="project_name" name="project_name" value="" class="input_width" />
									</td>
									<td class="inquire_item4">项目编号：</td>
									<td class="inquire_form4" id="item0_1"><input type="text" id="project_id" name="project_id" value="从ERP系统自动获取" disabled="disabled" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">项目类型：</td>
									<td class="inquire_form4" id="item0_2">
										<input type="hidden" id="project_type" name="project_type" value="<%=projectType%>" class="input_width" />
										<select class=select_width name="project_type_name" id="project_type_name" disabled="disabled">
											<option value='5000100004000000008'>井中项目</option>
											<option value='5000100004000000001'>陆地项目</option>
											<option value='5000100004000000007'>陆地和浅海项目</option>
											<option value='5000100004000000009'>综合物化探</option>
											<option value='5000100004000000010'>滩浅海地震</option>
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
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>项目重要程度：</td>
									<td class="inquire_form4" id="item0_8"><code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" /></td>
									<td class="inquire_item4"><span class="red_star">*</span>勘探方法：</td>
									<td class="inquire_form4" id="item0_11">
										<select class=select_width name=exploration_method  id="exploration_method" >
												<option value="0300100012000000002">二维地震</option>
												<option value="0300100012000000003">三维地震</option>
												<option value="0300100012000000023">四维地震</option>
												<option value="0300100012000000028">多波</option>
												<option value="0300100012000000027">其它</option>
										</select>
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
									<td class="inquire_item4">甲方单位：</td>
									<td class="inquire_form4" id="item0_13">
										<input id="manage_org" name="manage_org" value="" type="hidden" class="input_width" />
										<input id="manage_org_name" name="manage_org_name" value="" type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectManageOrg()" />
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
									<td class="inquire_item4"><span class="red_star">*</span>施工队伍：</td>
									<td class="inquire_form4" id="item0_19">
										<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
										<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>项目业务类型：</td>
									<td class="inquire_form4" id="item0_17">
										<code:codeSelect cssClass="select_width" name='project_business_type' option="projectBusinessType" selectedValue="" addAll="true" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>利润中心：</td>
									<td class="inquire_form4" id="item0_18">
										<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
										<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" />
									</td>
									<td class="inquire_item4">区带：</td>
									<td class="inquire_form4"><input id="zone" name="zone" value="" type="text" class="input_width" /></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>激发方式：</td>
									<td colspan="3">
										<input type="hidden" id="build_method" name="build_method" value="" class="input_width" />
										<input type="checkbox" name="build_method_name" value="5000100003000000001" id="5000100003000000001">井炮&nbsp;&nbsp;</input>
										<input type="checkbox" name="build_method_name" value="5000100003000000002" id="5000100003000000002">震源&nbsp;&nbsp;</input>
										<input type="checkbox" name="build_method_name" value="5000100003000000003" id="5000100003000000003">气枪</input>
										<input type="checkbox" name="build_method_name" value="5000100003000000010" id="5000100003000000010">井下扫描源&nbsp;&nbsp;</input>
										<input type="checkbox" name="build_method_name" value="5000100003000000011" id="5000100003000000011">井下脉冲源&nbsp;&nbsp;</input>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>观测类型：</td>
									<td colspan="3">
										<input type="hidden" id="view_type" name="view_type" value="" class="input_width" />
										<input type="checkbox" name="view_type_name" value="5110000053000000001">零偏VSP（Zero offset-VSP）</input>
										<input type="checkbox" name="view_type_name" value="5110000053000000002">非零偏VSP（Offset-VSP）</input>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"></td>
									<td colspan="3">
										<input type="checkbox" name="view_type_name" value="5110000053000000003">Walkaway-VSP&nbsp;&nbsp;</input>
										<input type="checkbox" name="view_type_name" value="5110000053000000005">3D-VSP&nbsp;&nbsp;</input>
										<input type="checkbox" name="view_type_name" value="5110000053000000004">Walkaround-VSP&nbsp;&nbsp;</input>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"></td>
									<td colspan="3">
										<input type="checkbox" name="view_type_name" value="5110000053000000006">微地震井中监测&nbsp;&nbsp;</input>
										<input type="checkbox" name="view_type_name" value="5110000053000000007">微地震地面监测&nbsp;&nbsp;</input>
										<input type="checkbox" name="view_type_name" value="5110000053000000008">井间地震&nbsp;&nbsp;</input>
										<input type="checkbox" name="view_type_name" value="5110000053000000009">随钻地震&nbsp;&nbsp;</input>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">项目投资：</td>
									<td class="inquire_form4"><input type="text" id="project_cost" name="project_cost" value="" class="input_width"/>
									</td>
									<td class="inquire_item4">项目负责人：</td>
									<td class="inquire_form4"><input type="text" id="project_man" name="project_man" value="" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">一级构造单元：</td>
									<td class="inquire_form4"><input type="text" id="unit_one" name="unit_one" value="" class="input_width" />
									</td>
									<td class="inquire_item4">二级构造单元：</td>
									<td class="inquire_form4"><input type="text" id="unit_two" name="unit_two" value="" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">项目来源：</td>
									<td class="inquire_form4">
									<select class=select_width name="project_source" id="project_source">
										<option value='5110000054000000001'>矿保</option>
										<option value='5110000054000000002'>风险</option>
										<option value='5000100004000000003'>预探</option>
										<option value='5000100004000000004'>油藏评价</option>
										<option value='5000100004000000005'>油田开发</option>
										<option value='5000100004000000006'>天然气开发</option>
										<option value='5000100004000000007'>页岩气</option>
										<option value='5000100004000000008'>煤层气</option>
										<option value='5000100004000000009'>其它</option>
									</select>
									</td>
									<td class="inquire_item4">仪器型号：</td>
									<td class="inquire_form4"><input type="text" id="instrument_model" name="instrument_model" value="" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">井下仪器级数：</td>
									<td class="inquire_form4"><input type="text" id="instrument_num" name="instrument_num" value="" class="input_width" />
									</td>
									<td class="inquire_item4">井下仪器间距：</td>
									<td class="inquire_form4"><input type="text" id="instrument_space" name="instrument_space" value="" class="input_width" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">常规项目：</td>
									<td colspan="3">
										<input type="radio" name="project_common" id="project_common" value="1"/>常规项目&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="radio" name="project_common" id="project_common"  value="0"/>非常规项目
									</td>
								</tr>
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
//根据上一页选择对项目类型下拉框赋值
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
	window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100100014',teamInfo);
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

function selectTeam(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
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
		var projectFatherNo=document.getElementById("project_father_no").value;
		var params = $("#form1").serialize();
		cruConfig.contextPath = '<%=contextPath%>';
		var retObj = jcdpCallService("WsProjectSrv", "addProject",params);
		if(""==projectFatherNo){
			parent.list.frames[1].location.reload();
			newClose();
		}else{
			var projectFatherName="<%=projectFatherName%>";
			window.location ='<%=contextPath%>/ws/pm/project/multiProject/projectList.jsp?projectFatherName='+encodeURI(encodeURI(projectFatherName))+'&projectFatherNo=<%=projectFatherNo%>&orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId%>';
		}
	
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
		if (!isTextPropertyNotNull("design_start_date", "合同开始时间")) {		
			document.form1.design_start_date.focus();
			return false;	
		}
		if (!isTextPropertyNotNull("design_end_date", "合同结束时间")) {		
			document.form1.design_end_date.focus();
			return false;	
		}
		if($("#is_main_project").val() == ""){
			alert("请选择 项目重要程度!");
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
		
		//激发方式字符串拼接
		var checkboxArray = document.getElementsByName("build_method_name");
		var str="";
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
		
		//观测类型字符串拼接
		checkboxArray = document.getElementsByName("view_type_name");
		str="";
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				str+=checkboxArray[i].value+",";
			}
		}
		str =str.substring(0,str.lastIndexOf(','));
		if (""!=str) {		
			document.getElementById('view_type').value=str;
		}else{
			alert("请选择观测类型!");
			return false;
		}
	
		if (!isValidFloatProperty13_3("project_cost","项目投资")) return false;  
		if (!isValidFloatProperty13_3("instrument_num","井下仪器级数")) return false; 
		if (!isValidFloatProperty13_3("instrument_space","井下仪器间距")) return false;
		if (!isLimitB32("zone","区带")) return false;  
		if (!isLimitB20("project_man","项目负责人")) return false;  
		if (!isLimitB32("unit_one","一级构造单元")) return false;  
		if (!isLimitB32("unit_two","二级构造单元")) return false;  
		if (!isLimitB32("instrument_model","仪器型号")) return false;
		
		return true;
	}
	
</script>
</html>