<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	String projectType = "";
	if (request.getParameter("projectType") != null) {
		projectType = request.getParameter("projectType");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
</head>
<body>
	<form name="form1" id="form1" method="post"
		action="<%=contextPath%>/ws/pm/project/test2.srq">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tab_box" class="tab_box">
					<div id="tab_box_content0" class="tab_box_content">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目名：</td>
								<td class="inquire_form4" id="item0_0"><input type="text"
									id="project_name" name="project_name" value=""
									class="input_width" /></td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text"
									id="project_id" name="project_id" value="从ERP系统自动获取"
									disabled="disabled" class="input_width" /></td>
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
								<td class="inquire_item4"><span class="red_star">*</span>指标金额</td>
								<td class="inquire_item4"><input id="project_target_money"
									name="project_target_money" value="" type="text"
									class="input_width" /><span>万元</span>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>市场范围：</td>
								<td class="inquire_form4" id="item0_4"><input
									id="market_classify" name="market_classify" value="0100500006000000001"
									type="hidden" class="input_width" /> <input
									id="market_classify_name" name="market_classify_name" value="国内"
									type="text" class="input_width" readonly="readonly" />
									&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif"
									style="cursor: hand;" border="0"
									onclick="selectMarketClassify()" /></td>
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5"><select
									id="project_year" name="project_year" class="select_width">
										<%
											Date date = new Date();
											int years = date.getYear() + 1900 - 10;
											int year = date.getYear() + 1900;
											for (int i = 0; i < 20; i++) {
										%>
										<option value="<%=years%>" <%if (years == year) {%>
											selected="selected" <%}%>>
											<%=years%>
										</option>
										<%
											years++;
											}
										%>
								</select></td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>国内/国外：</td>
								<td class="inquire_form4" id="item0_12"><select
									class=select_width name=project_country id="project_country">
										<option value="1">国内</option>
										<option value="2">国外</option>
								</select></td>
								<td class="inquire_item4"><span class="red_star">*</span>施工队伍：</td>
								<td class="inquire_form4" id="item0_19">
									<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
									<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly="readonly"/>
									&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="save()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
			
		</div>
	</form>
</body>

<script type="text/javascript">
//根据上一页选择对项目类型下拉框赋值
var projectType="<%=projectType%>";
var org_id = "<%=org_id%>"
var obj = jcdpCallService("WsProjectSrv","getOrgNameById","org_id="+org_id);
if(obj != null) {
	$("#org_name").val(obj.orgNameMap.org_name);
	$("#org_id").val(obj.orgNameMap.org_id);
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
		var params = $("#form1").serialize();
		cruConfig.contextPath = '<%=contextPath%>';
		var retObj = jcdpCallService("WsProjectSrv", "addProject", params);
		var msg = retObj.message;
		if (msg == "exist") {
			alert("小队年度项目已经存在!");
			return;
		} else {
			alert("创建成功!");
		}
		newClose();
	}
   


	function checkForm() {
		var project_name = document.getElementById("project_name").value;
		if(project_name.length==0){
			alert("项目名称不能为空!");
			return;
		}
		
		var market_classify = document.getElementById("market_classify").value;
		if(market_classify.length==0){
			alert("市场范围不能为空!");
			return;
		}
		
		var project_country = document.getElementById("project_country").value;
		if(project_country.length==0){
			alert("国内国外不能为空!");
			return;
		}
		return true;
	}
</script>
</html>