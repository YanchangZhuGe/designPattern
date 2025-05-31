<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String project_name = user.getProjectName();
	Date date = new Date();
	date.setMonth(0);
	date.setDate(1);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String start_date = df.format(date);
	String end_date = df.format(new Date());
	
	//response.sendRedirect(contextPath+"/pm/page3.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript">
var checked = false;
function doCheck(){
	if(checked){
		var chk = document.getElementsByName("chk_entity_id");
		var len = chk.length;
		for(var i =0;i<len;i++){
			chk[i].checked = false;
		}
		checked = false;
	}
	else{
		var chk = document.getElementsByName("chk_entity_id");
		var len = chk.length;
		for(var i =0;i<len;i++){
			chk[i].checked = true;
		}
		checked = true;
	}
}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			    <td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">统计周期:</td>
				    		<td class="ali_cdn_input"><input type="text" id="start_date" name="start_date" value="<%=start_date %>" class="input_width" readonly="readonly" style="width: 70%;"/>
				    		<img width="16" height="16" id="cal_button1" style="cursor: hand;" onmouseover="calDateSelector(start_date,cal_button1);" src="<%=contextPath %>/images/calendar.gif" />&nbsp;&nbsp;至&nbsp;</td>
	    					<td class="ali_cdn_input">
	    					<input type="text" id="end_date" name="end_date" value ="<%=end_date %>" class="input_width" readonly="readonly" style="width: 70%;"/>
	    					<img width="16" height="16" id="cal_button2" style="cursor: hand;" onmouseover="calDateSelector(end_date,cal_button2);" src="<%=contextPath %>/images/calendar.gif" /></td>
						    <td class="ali_query"><span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span> </td>
				    		<td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span> </td>
						    <td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	  	<!-- <tr style="height: 40px;">
	      <td class="bt_info_even" exp="{spare1}" colspan="7" ></td>
	    </tr> -->
	    <tr >
	      <td class="bt_info_odd" exp="{evaluation}"></td> 
	      <td class="bt_info_even" exp="{rownum}">名次</td>
	      <td class="bt_info_odd" exp="<a href='#' onclick=projectDetail('{project_info_no}','{project_name}')> <font color='blue'>{project_name}</font></a>">项目名称</td>
	      <td class="bt_info_even" exp="{wtc}">物探处</td>
	      <td class="bt_info_odd" exp="{team}">队号</td>
	      <td class="bt_info_even" exp="{score}">分数</td>
	    </tr>
	  </table>
	</div>
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table" style="display: none;">
			<tr>
				<td align="right">第1/1页，共0条记录</td>
				<td width="10">&nbsp;</td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				<td width="50">到 <label><input type="text" name="textfield" id="textfield" style="width:20px;" /></label></td>
				<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			</tr>
		</table>
	</div>
  </div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	function refreshData(){
		var start_date = document.getElementById("start_date").value;
		var end_date = document.getElementById("end_date").value;
		cruConfig.queryStr = "select case when rownum<=2 then'优秀' when rownum>=3 and rownum<=9 then'合格' else'较差'end evaluation, "+
			" rownum ,dd.* from(select p.project_info_no ,p.project_name ,s.org_short_name wtc,i.org_abbreviation team , "+
			" sum(t.evaluate_weight-t.evaluate_score) score from bgp_pm_evaluate_project t "+
			" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0' "+
			" join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" join pub_org s on d.org_subjection_id like s.org_code||'%' and s.org_code !='C105' "+
			" join comm_org_information i on d.org_id = i.org_id and i.bsflag ='0' "+
			" where t.bsflag ='0' and t.parent_id ='ROOT' and t.submit_flag ='1' and t.modifi_date >= to_date('"+start_date+"','yyyy-MM-dd') "+
			" and to_date(to_char(t.modifi_date,'yyyy-MM-dd'),'yyyy-MM-dd') <= to_date('"+end_date+"','yyyy-MM-dd') "+
			" group by p.project_info_no ,p.project_name ,i.org_abbreviation ,s.org_short_name order by sum(t.evaluate_weight-t.evaluate_score) desc)dd";
		queryData(1);
	}
	refreshData();
	var obj = {};
	function projectDetail(project_info_no,project_name){
		project_name = encodeURI(project_name);
		//window.showModalDialog("<%=contextPath%>/pm/projectEvaluation/evaluation_project.jsp?project_info_no="+project_info_no+"&project_name="+project_name,obj,"dialogWidth:1200px;dialogHeight:720px;");
		window.open("<%=contextPath%>/pm/projectEvaluation/evaluation_project.jsp?project_info_no="+project_info_no+"&project_name="+project_name);
	}
</script>
</body>
</html>

