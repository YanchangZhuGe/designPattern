<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	
	if(projectInfoNo == null || "".equals(projectInfoNo) || "null".equals(projectInfoNo)) {
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
	
	//是否是审批查看
	String action = request.getParameter("action")==null?"":request.getParameter("action");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
	
	String orgId = user.getOrgId();
	
	String projectType="5000100004000000008";
	
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
	//保存结果
	String message = null;
	if (respMsg != null && respMsg.getValue("message") != null) {
		message = respMsg.getValue("message");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>
<body>
<div id="new_table_box">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tab_box" class="tab_box" style="overflow: hidden;">
					<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6" id="item0_0">
					    <input type="hidden" id="project_info_no" name="project_info_no" /><input type="text" id="project_name" name="project_name" class="input_width" />
					    <input type="hidden" id="project_father_no" name="project_father_no" value="" class="input_width" />
					    </td>
					    <td class="inquire_item6">项目编号：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="project_id" name="project_id" class="input_width_no_color"  disabled="disabled" readOnly="readonly"/></td>
					    <td class="inquire_item6">项目类型：</td>
					    <td class="inquire_form6" id="item0_2">
					    	<code:codeSelect cssClass="select_width"  name='project_type' option="projectType"  selectedValue=""  addAll="true" />
					    </td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"><span class="red_star">*</span>指标金额：</td>
					    <td class="inquire_item6"><input id="project_target_money" name="project_target_money" value="" type="text" class="input_width" /><span>万元</span></td>
					    <td class="inquire_item6">市场范围：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
							<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /></td>
					    </td>
					    <td class="inquire_item6">年度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<select id="project_year" name="project_year" class="select_width">
						    <%
						    Date date = new Date();
						    int years = date.getYear()+ 1900 - 10;
						    int year = date.getYear()+1900;
						    for(int i=0; i<20; i++){
						    %>
						    <option value="<%=years %>" > <%=years %> </option>
						    <%
						    years++;
						    }
						     %>
						    </select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form6" id="item0_19">
							<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width" />
						</td>
					    <td class="inquire_item6">国内/国外：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<select class="select_width" name="project_country" id="project_country">
								<option value='1'>国内</option>
								<option value='2'>国外</option>
							</select>
					    </td>
					  </tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var orgSubjectionId= "<%=orgSubjectionId%>";
var orgId="<%=orgId %>";
var message="<%=message%>";
var projectType="<%=projectType%>"
var businessType="5110000004100000080";
var projectInfoNo = "<%=projectInfoNo%>"


var projectYear = document.getElementById("project_year").value;
var retObj = jcdpCallService("WsProjectSrv", "getProjectDetail", "projectInfoNo="+projectInfoNo+"&orgSubjectionId="+orgSubjectionId+"&projectYear="+projectYear);

document.getElementById("project_info_no").value=retObj.map.project_info_no;
document.getElementById("project_father_no").value=retObj.map.project_father_no;
document.getElementById("project_name").value=retObj.map.project_name;
document.getElementById("project_id").value=retObj.map.project_id;
//项目类型
var sel = document.getElementById("project_type").options;
var value = retObj.map.project_type;
for(var i=0;i<sel.length;i++){
    if(value==sel[i].value){
       document.getElementById('project_type').options[i].selected=true;
    }
}

//国内 国外
sel = document.getElementById("project_country").options;
value = retObj.map.project_country;
for(var i=0;i<sel.length;i++){
    if(value==sel[i].value){
       document.getElementById('project_country').options[i].selected=true;
    }
}

document.getElementById("market_classify").value= retObj.map.market_classify;
document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
document.getElementById("project_year").value= retObj.map.project_year;
document.getElementById("org_id").value= retObj.dynamicMap.org_id;
document.getElementById("org_name").value= retObj.dynamicMap.org_name;
document.getElementById("project_target_money").value= retObj.map.project_target_money;
</script>
</html>