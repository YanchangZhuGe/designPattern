<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	Date now = new Date();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>

<body class="bgColor_f3f3f3"  onload="refreshData()">
      	<fieldSet style="margin-left:2px"><legend>下属单位信息</legend>
      	<div id="list_table" >
			<div id="table_box" >
			  <table width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr class="bt_info">
				<td rowspan="2">序号</td>
				<td rowspan="2">单位</td>
				<td colspan="7" >GPS使用信息</td>
				<td colspan="3">GPS监控信息</td>
			</tr>
			<tr class="bt_info">
				<td>现有安装台数</td>
				<td>本周工作台数</td>
				<td>正常</td>
				<td>不正常</td>
				<td>待修</td>
				<td>不正常原因</td>
				<td>采取措施</td>
				<td>违章统计(台)</td>
				<td>违章原因</td>
				<td>采取措施</td>
			</tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
		  </div>
		  </fieldSet>
</body>

<script type="text/javascript">

	$("#table_box").css("height",$(window).height()-55);
	$(function(){
		$(window).resize(function(){
			$("#table_box").css("height",$(window).height()-55);
		});
	})	

	cruConfig.contextPath =  "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		debugger;
		cruConfig.queryStr = "select g.hse_gps_id,case when length(g.wrong_reason)>5 then concat(substr(g.wrong_reason, 1, 5), '...') else g.wrong_reason end wrong_reason,"
								+"case when length(g.wrong_step)>5 then concat(substr(g.wrong_step, 1, 5), '...') else g.wrong_step end wrong_step,"
						        +"case when length(g.rule_reason)>5 then concat(substr(g.rule_reason, 1, 5), '...') else g.rule_reason end rule_reason,"
						        +"case when length(g.rule_step)>5 then concat(substr(g.rule_step, 1, 5), '...') else g.rule_step end rule_step,"
						      	+"g.use_no,g.week_use_no,g.normal_no,g.wrong_no,g.fix_no,g.rule_no,i.org_abbreviation as org_name,i2.org_abbreviation as org_name2"
						        +" from bgp_hse_common c join bgp_hse_week_gps g on c.hse_common_id = g.hse_common_id join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag = '0'"
						        +" join comm_org_information i on s.org_id = i.org_id and i.bsflag = '0' join comm_org_subjection s2 on s.father_org_id = s2.org_subjection_id and s2.bsflag = '0'"
						        +" join comm_org_information i2 on s2.org_id = i2.org_id and i2.bsflag = '0' where c.bsflag = '0' and s.father_org_id = '<%=org_id%>'"
						        +" and c.week_start_date = to_date('<%=week_date %>', 'yyyy-MM-dd') order by c.modifi_date desc, to_number(g.gps_order) asc";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	
	function renderTable(tbObj,tbCfg){
		//更新导航栏
		renderNaviTable(tbObj,tbCfg);
		//删除上次的查询结果
		var headChxBox = getObj("headChxBox");
		if(headChxBox!=undefined) headChxBox.checked = false;
		for(var i=tbObj.rows.length-1;i>1;i--)
			tbObj.deleteRow(i);

		
		var datas = tbCfg.items;
		if(datas!=null)
		for(var i=0;i<datas.length;i++){
			toAddLine(
					datas[i].hse_gps_id ? datas[i].hse_gps_id : "",
					datas[i].org_name ? datas[i].org_name : "",
					datas[i].use_no ? datas[i].use_no : "",
					datas[i].week_use_no ? datas[i].week_use_no : "",
					datas[i].normal_no ? datas[i].normal_no : "",
					datas[i].wrong_no ? datas[i].wrong_no : "",
					datas[i].fix_no ? datas[i].fix_no : "",
					datas[i].wrong_reason ? datas[i].wrong_reason : "",
					datas[i].wrong_step ? datas[i].wrong_step : "",
					datas[i].rule_no ? datas[i].rule_no : "",
					datas[i].rule_reason ? datas[i].rule_reason : "",
					datas[i].rule_step ? datas[i].rule_step : "",
					i
				);
		}
		
		createNewTitleTable();
		resizeNewTitleTable();
	}
	
	function toAddLine(hse_gps_id,orgName,use_no,week_use_no,normal_no,wrong_no,fix_no,wrong_reason,wrong_step,rule_no,rule_reason,rule_step,order){
		var num = order+1;
		
		var hse_gps_id  = hse_gps_id ? hse_gps_id : "";
		var use_no = use_no ? use_no : ""; 
		var week_use_no = week_use_no ? week_use_no : ""
		var normal_no = normal_no ? normal_no : "";
		var wrong_no = wrong_no ? wrong_no : "";
		var fix_no = fix_no ? fix_no : "";
		var wrong_reason = wrong_reason ? wrong_reason : "";
		var wrong_step = wrong_step ? wrong_step : "";
		var rule_no = rule_no ? rule_no : "";
		var rule_reason = rule_reason ? rule_reason : "";
		var rule_step = rule_step ? rule_step : "";
		
		var table=document.getElementById("queryRetTable");
		
		var autoOrder = document.getElementById("queryRetTable").rows.length;
		var newTR = document.getElementById("queryRetTable").insertRow(autoOrder);
		newTR.ondblclick = function(){loadDataDetail(hse_gps_id);};
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
		
		var td = newTR.insertCell(0);
		td.innerHTML = "<input type='hidden' id='hse_gps_id"+num+"' value='"+hse_gps_id+"' />"+num;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(1);
	    td.innerHTML = orgName;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(2);
		td.innerHTML = use_no;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(3);
	    td.innerHTML =week_use_no;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(4);
		td.innerHTML = normal_no;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(5);
	    td.innerHTML = wrong_no;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(6);
		td.innerHTML = fix_no;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(7);
	    td.innerHTML = wrong_reason;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(8);
		td.innerHTML = wrong_step;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(9);
	    td.innerHTML = rule_no;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(10);
		td.innerHTML = rule_reason;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(11);
	    td.innerHTML = rule_step;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		
	}
	
	function createRow(html){
	    var div=document.createElement("div");
//	    div.style.overflow = "auto;
	    html="<table><tbody>"+html+"</tbody></table>"
	    div.innerHTML=html;
	    return div.lastChild.lastChild;
	}

	
	function loadDataDetail(hse_gps_id){
		var retObj;
		if(hse_gps_id!=null&&hse_gps_id!=""){
			 popWindow("<%=contextPath%>/hse/weekReport/GPS/showDetail.jsp?hse_gps_id="+hse_gps_id);
		}else{
			alert("请选择一条记录");
			return;
		}
	}
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/accidentNews/addAccident.jsp");
		
	}
	
	
	
</script>

</html>

