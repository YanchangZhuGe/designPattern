<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%> 
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = df.format(new Date());
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectType = "5000100004000000008"; 
	String projectFatherNo = request.getParameter("projectFatherNo");
	if ("".equals(projectFatherNo) || projectFatherNo == null) {
		projectFatherNo = "";
	}

	IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
	String sql = " select project_year from GP_WS_PROJECT where ws_project_no = '"+projectFatherNo+"'";
	Map map = jdbcDAO.queryRecordBySQL(sql);
	
	String projectYear = map.get("project_year").toString();
	String optionType= request.getParameter("optionType");
	String projectFatherName = request
			.getParameter("projectFatherName") == null
			? ""
			: java.net.URLDecoder.decode(
					request.getParameter("projectFatherName"), "utf-8");
	
	String org_id = user.getOrgId();
	String org_sub_id = user.getOrgSubjectionId();
	String userName=user.getUserName();
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
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
		action="">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tab_box" class="tab_box">
					<div id="tab_box_content0" class="tab_box_content">
						<table width="100%" border="1" cellspacing="0" cellpadding="0"
							class="tab_line_height" id="Offsettable">
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目名称：</td>
								<td class="inquire_form4" id="item0_0">
								    <input type="hidden"
									id="ws_project_no" name="ws_project_no"
									value="<%=projectFatherNo%>" class="input_width" />
									<input type="hidden" id="ws_detail_no" name="ws_detail_no" value=""
									class="input_width" />
									
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
							 <td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2"><input type="hidden"
									id="project_type" name="project_type" value="<%=projectType%>"
									class="input_width" /> <select class=select_width
									name="project_type_name" id="project_type_name"
									disabled="disabled">
										<option value='5000100004000000008'>井中地震</option>
								</select></td>
							</tr>
							<tr> 
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5">
								<input type="text"
									id="project_year" name="project_year" value="<%=projectYear%>"
									class="input_width_no_color" readonly="readonly"/> 
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目重要程度：</td>
								<td class="inquire_form4" id="item0_8">
									<select name="is_main_project" id="is_main_project" class="select_width">
										<option value="">--请选择--</option>
										<option value="1">集团重点</option>
										<option value="2">地区（局）重点</option>
										<option value="3" selected="selected">正常</option>
									</select>

								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目开始时间：</td>
								<td class="inquire_form4" id="item0_6"><input type="text"
									id="start_time" name="start_time" value=""
									class="input_width" readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=contextPath%>/images/calendar.gif" id="tributton1"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(start_time,tributton1);" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目结束时间：</td>
								<td class="inquire_form4" id="item0_7"><input type="text"
									id="end_time" name="end_time" value=""
									class="input_width" readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=contextPath%>/images/calendar.gif" id="tributton2"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(end_time,tributton2);" />
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
							<td class="inquire_item4"><span class="red_star">*</span>利润中心：</td>
								<td class="inquire_form4" id="item0_18">
								<input type="hidden" id="prctr" name="prctr" value="G0150100" class="input_width" />
								<input type="text" id="prctr_name" name="prctr_name" value="新兴物探开发处" class="input_width_no_color" readonly="readonly" /> &nbsp;&nbsp;
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目业务类型：</td>
								<td class="inquire_form4" id="item0_17">
								<select
									class=select_width name=project_business_type id="project_business_type"> 
										<option value="">--请选择--</option>
										<option value="1">处理</option>
										<option value="2">解释</option>
										<option value="3">处理,解释</option>
								</select>
								 
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

var sel = document.getElementById("project_type_name").options;
for(var i=0;i<sel.length;i++)
{
    if(projectType==sel[i].value)
    {
       document.getElementById('project_type_name').options[i].selected=true;
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
 
		var project_name = document.getElementById("project_name").value;
		if(project_name.length==0){
			alert("项目名不能为空");
			return false;
		}
		 
		
		var well_no = document.getElementById("well_no").value;
		if(well_no.length==0){
			alert("井号不能为空");
			return false;
		}
		
		
		var start_time = document.getElementById("start_time").value;
		if(start_time.length==0){
			alert("项目开始时间不能为空");
			return false;
		}
		
		var end_time = document.getElementById("end_time").value;
		if(end_time.length==0){
			alert("项目结束时间不能为空");
			return false;
		}
		
		var manage_org = document.getElementById("manage_org").value;
		if(manage_org.length==0){
			alert("甲方单位不能为空");
			return false;
		} 
		
		return true;
	}
	
	
	function save() {
		if (!checkForm()) return; 
		var rowParams = new Array(); 
			var rowParam = {};		
			var   ws_detail_no= document.getElementsByName("ws_detail_no")[0].value; 
			var   project_name= document.getElementsByName("project_name")[0].value;
			var   project_type= document.getElementsByName("project_type")[0].value; 
			var   project_year= document.getElementsByName("project_year")[0].value; 
			var   well_no= document.getElementsByName("well_no")[0].value; 
			var   is_main_project= document.getElementsByName("is_main_project")[0].value;
			
			var   start_time= document.getElementsByName("start_time")[0].value;
			var   end_time= document.getElementsByName("end_time")[0].value;
			var   project_country= document.getElementsByName("project_country")[0].value;
			var   manage_org= document.getElementsByName("manage_org")[0].value;
			var   prctr= document.getElementsByName("prctr")[0].value;
			var   prctr_name= document.getElementsByName("prctr_name")[0].value;
			var   project_business_type= document.getElementsByName("project_business_type")[0].value;
			 
			 rowParam['ws_project_no'] = '<%=projectFatherNo%>';
			 rowParam['project_name'] = encodeURI(encodeURI(project_name));
			 rowParam['project_type'] = encodeURI(encodeURI(project_type));
			 rowParam['project_year'] = encodeURI(encodeURI(project_year));
			 
			 rowParam['well_no'] = well_no;
			 rowParam['is_main_project'] = is_main_project;
			 rowParam['start_time'] = start_time;
			 rowParam['end_time'] = end_time;
			 rowParam['project_country'] = project_country;
			 rowParam['manage_org'] = manage_org;
			 rowParam['prctr'] = prctr;
			 rowParam['prctr_name'] = encodeURI(encodeURI(prctr_name));
			 rowParam['project_business_type'] = project_business_type;
			 
			 rowParam['option_type'] = '<%=optionType%>';
		  
			 if(ws_detail_no !=null && ws_detail_no !=''){
				    rowParam['ws_detail_no'] = ws_detail_no; 
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		 
					rowParam['bsflag'] = '0';
					
			  }else{
				    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] ='<%=curDate%>';
					rowParam['modifi_date'] = '<%=curDate%>';	
					rowParam['org_id'] = '<%=org_id%>';	
					rowParam['org_sub_id'] = '<%=org_sub_id%>';	
					rowParam['bsflag'] =	'0'; 
				  
			  }  				 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	   
				saveFunc("GP_WS_PROJECT_DETAIL",rows);	
  
/* 		if(""==projectFatherNo){
			parent.list.frames[1].location.reload();
			newClose();
		}  */
			var projFName=encodeURI(encodeURI(projectFatherName));
			window.location ='<%=contextPath%>/td/vspExplain/vspProject/subProjectList.jsp?projectFatherName='+projFName+'&projectFatherNo=<%=projectFatherNo%>&optionType=<%=optionType%>';
		 
	}
</script>
</html>