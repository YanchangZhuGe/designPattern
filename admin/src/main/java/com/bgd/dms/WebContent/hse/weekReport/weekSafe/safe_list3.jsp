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
<title>无标题文档</title>
</head>

<body class="bgColor_f3f3f3"  onload="refreshData()">
      	<fieldSet style="margin-left:2px"><legend>下属单位信息</legend>
      	<div id="list_table" >
			<div id="table_box">
			  <table width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <input type="hidden" id="rowNum"></input>
			    <tr>
			      <td class="bt_info_odd">序号</td> 
			      <td class="bt_info_even" colspan="2">单位</td>
			      <td class="bt_info_odd">安全观察沟通次数/周</td>
			    </tr>
			  </table>
			</div>
		  </div>
		  </fieldSet>
</body>

<script type="text/javascript">

$("#table_box").css("height",$(window).height()-35);

$(function(){
	$(window).resize(function(){
		$("#table_box").css("height",$(window).height()-35);
	});
})	
	/*
	
	除物探处外的二级单位
	select c.hse_common_id,s.hse_safe_id,s.safe_times,oi.org_abbreviation org_name
	  from bgp_hse_common c
	  join bgp_hse_week_safe s on c.hse_common_id = s.hse_common_id
	  join comm_org_subjection os on c.org_id = os.org_subjection_id
	                             and os.bsflag = '0'
	  join comm_org_information oi on os.org_id = oi.org_id
	                              and oi.bsflag = '0'
	 where c.bsflag = '0'
	   and c.week_start_date = to_date('2012-07-06', 'yyyy-MM-dd') and os.father_org_id='C105'
	   and os.org_subjection_id not in ('C105002','C105003', 'C105001005', 'C105001002', 'C105001003', 'C105001004',
	        'C105005004', 'C105005000', 'C105005001', 'C105007','C105063')
	    */    

	
	// 复杂查询
	function refreshData(){
		var rowNum = 0;
		var checkSql = "select c.hse_common_id,s.hse_safe_id,os.org_subjection_id,s.safe_times,oi.org_abbreviation org_name"
			  				+" from bgp_hse_common c join bgp_hse_week_safe s on c.hse_common_id = s.hse_common_id"
			  				+" join comm_org_subjection os on c.org_id = os.org_subjection_id and os.bsflag = '0'"
			  				+" join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0'"
			 				+" where c.bsflag = '0' and c.week_start_date = to_date('<%=week_date%>', 'yyyy-MM-dd') "
			                +" and os.org_subjection_id  in ('C105002','C105003', 'C105001005', 'C105001002', 'C105001003', 'C105001004','C105005004', 'C105005000', 'C105005001', 'C105007','C105063')";
			        
		var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				rowNum = datas.length;
				for (var i = 0; i<datas.length; i++) {		
					
					toAddLine(
							datas[i].hse_safe_id ? datas[i].hse_safe_id : "",
							datas[i].org_name ? datas[i].org_name : "",
							datas[i].org_subjection_id ? datas[i].org_subjection_id : "",
							i
						);
				}	
			}
			
			document.getElementById("rowNum").value = rowNum ; 
			var checkSql2 = "select c.hse_common_id,s.hse_safe_id,s.safe_times,oi.org_abbreviation org_name"
				 +" from bgp_hse_common c join bgp_hse_week_safe s on c.hse_common_id = s.hse_common_id"
				 +" join comm_org_subjection os on c.org_id = os.org_subjection_id and os.bsflag = '0'"
				 +" join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0'"
				 +" where c.bsflag = '0' and c.week_start_date = to_date('<%=week_date%>', 'yyyy-MM-dd') and os.father_org_id='C105'"
			     +" and os.org_subjection_id not in ('C105002','C105003', 'C105001005', 'C105001002', 'C105001003', 'C105001004','C105005004', 'C105005000', 'C105005001', 'C105007','C105063')";
        
			var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
			var datas2 = queryRet2.datas;
			if(datas2==null||datas2==""){
			}else{
				for (var i = 0; i<datas2.length; i++) {		
					
					toAddLine2(
							datas2[i].hse_safe_id ? datas2[i].hse_safe_id : "",
							datas2[i].org_name ? datas2[i].org_name : "",
							datas2[i].safe_times ? datas2[i].safe_times : "",
							i
						);
				}		
			}
	}
	
	function toAddLine(hse_safe_id,orgName,orgId,order){
		var num = order+1;
		var teamTimes = 0;
		var otherTimes = 0;
		var sql = "select  sum(safe_times) as team_times from bgp_hse_common c join bgp_hse_week_safe ws on c.hse_common_id = ws.hse_common_id"
			 +" join comm_org_subjection os on os.org_subjection_id = c.org_id and os.bsflag = '0'"
			 +" join comm_org_team ot on os.org_id = ot.org_id  and ot.bsflag = '0'"
			 +" where c.bsflag='0' and c.week_start_date = to_date('<%=week_date%>', 'yyyy-MM-dd') and os.father_org_id = '"+orgId+"'";
		var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+sql);
		var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				teamTimes = datas[0].team_times;
			}
				
		var sql2 ="select sum(ws.safe_times) other_times from bgp_hse_common c join bgp_hse_week_safe ws on c.hse_common_id = ws.hse_common_id"
			  +" join comm_org_subjection os on os.org_subjection_id=c.org_id join comm_org_information oi on os.org_id = oi.org_id"
			  +" where c.bsflag='0' and c.week_start_date = to_date('<%=week_date%>', 'yyyy-MM-dd') and os.father_org_id = '"+orgId+"' and os.org_id not in (select ot.org_id from comm_org_team ot)";
		var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+sql2);
		var datas2 = queryRet2.datas;
			if(datas2!=null&&datas2!=""){
				otherTimes = datas2[0].other_times;
			}	
	
		var table=document.getElementById("queryRetTable");
		
		var autoOrder = document.getElementById("queryRetTable").rows.length;
		var newTR = document.getElementById("queryRetTable").insertRow(autoOrder);
		debugger;
		var tdClass = 'even';
		if(num%2==0){
			tdClass = 'odd';
		}
		var td = newTR.insertCell(0);
		td.rowSpan = "2";
		td.innerHTML = "<input type='hidden' id='hse_safe_id"+order+"' value='"+hse_safe_id+"' />"+num;
		td.className = tdClass+'_odd';
		if(num%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		td = newTR.insertCell(1);
		td.rowSpan = "2";
		td.innerHTML = orgName;
		td.className =tdClass+'_even'
	    if(num%2==0){
			td.style.background = "#F5F5DC";
		}else{
			td.style.background = "#ebebeb";
		}
		
		td = newTR.insertCell(2);
		td.innerHTML = "一线";
		td.className = tdClass+'_odd';
		if(num%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		td = newTR.insertCell(3);
		td.innerHTML = teamTimes;
		td.className =tdClass+'_even'
	    if(num%2==0){
			td.style.background = "#F5F5DC";
		}else{
			td.style.background = "#ebebeb";
		}
		
		var newTR2 = document.getElementById("queryRetTable").insertRow(autoOrder+1);
		td = newTR2.insertCell(0);
		td.innerHTML = "二线";
		td.className = tdClass+'_odd';
		if(num%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		td = newTR2.insertCell(1);
	 	td.innerHTML = otherTimes;
		td.className =tdClass+'_even'
	    if(num%2==0){
			td.style.background = "#F5F5DC";
		}else{
			td.style.background = "#ebebeb";
		}
		
		
//		var temp = "odd";
//		if(order%2 == 0){
//			//even
//			temp = "even";
//		} else {
//			//odd
//			temp = "odd";
//		}
//		var elem = createRow("<tr class="+temp+"><input type='hidden' id='hse_safe_id"+order+"' value='"+hse_safe_id+"' /><td rowspan='2'>"+num+"</td><td rowspan='2'>"+orgName+"</td><td>一线</td><td>"+teamTimes+"</td><tr class="+temp+"><td>二线</td><td>"+otherTimes+"</td></tr>");
//		table.appendChild(elem);
	}	
	
	function toAddLine2(hse_safe_id,orgName,safe_times,order){
		debugger;
		var num = order+1;
		var table=document.getElementById("queryRetTable");
		var rowNum = document.getElementById("rowNum").value;
		
		rowNum = num+Number(rowNum);
		var temp = "odd";
		if((rowNum-1)%2 == 0){
			//even
			temp = "even";
		} else {
			//odd
			temp = "odd";
		}
		var elem = createRow("<tr class="+temp+"><input type='hidden' id='hse_safe_id"+order+"' value='"+hse_safe_id+"' /><td>"+rowNum+"</td><td colspan='2'>"+orgName+"</td><td>"+safe_times+"</td></tr>");
		table.appendChild(elem);
	}
	
	function createRow(html){
	    var div=document.createElement("div");
	    html="<table><tbody>"+html+"</tbody></table>"
	    div.innerHTML=html;
	    return div.lastChild.lastChild;
	}
</script>

</html>

