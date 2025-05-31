<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);
	
	String sub_id = request.getParameter("sub_id");
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
<div id="list_table" >
  <div id="new_table_box_content" style="width: 100%;padding: 0px;" >
    <div id="new_hour_table" style="width: 100%;background: #f1f2f3;overflow: auto;">
			<table id="hourTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr style="height: 50px;">
					<td align="center" colspan="6"><span style="font-size: 28px;font-family: Arial;padding-top: 11px;margin-bottom: 30px;">百万工时统计</span></td>
				</tr>
				
				<tr align="center">
					<td>序号</td>					
					<td>单位</td>					
					<td>工时</td>					
					<td>百万工时可记录事件发生率</td>					
					<td>百万工时损工伤亡发生率</td>					
					<td>百万工时死亡事故发生率</td>					
				</tr>
				<tr id="lastTr" align="center">
				<td>合计</td>
				<td>合计</td>
				<td><span id="all_hour"></span></td>
				<td><span id="all_record"></span></td>
				<td><span id="all_injure"></span></td>
				<td><span id="all_die"></span></td>
				</tr>
				<tr align="center">
				<td>集团指标</td>
				<td>集团指标</td>
				<td><span></span></td>
				<td><span id="record_target"></span></td>
				<td><span id="injure_target"></span></td>
				<td><span id="die_target"></span></td>
				</tr>
			</table>
</div>
</div> 
</div>
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
$("#new_table_box_content").css("height",$(window).height()-5);
$("#new_hour_table").css("height",$(window).height()-5);
toEdit();


function toShow(num,project_name,workhour,record_percent,injure_percent,die_percent,project_info_no){
	
	var table=document.getElementById("hourTable");
	
	var tr = table.insertRow(table.rows.length-2);
	tr.align="center";
	var td = tr.insertCell(0);
	td.innerHTML = Number(num)+1;
	
	td = tr.insertCell(1);
	td.innerHTML = "<span>"+project_name+"</span>";
	
	td = tr.insertCell(2);
	td.innerHTML = workhour;
	
	td = tr.insertCell(3);
	td.innerHTML = toDecimal(record_percent*100)+"%";
	
	td = tr.insertCell(4);
	td.innerHTML = toDecimal(injure_percent*100)+"%";
	
	td = tr.insertCell(5);
	td.innerHTML = toDecimal(die_percent*100)+"%";
	
}

function toDecimal(x) {   
    var f = parseFloat(x);   
    if (isNaN(f)) {   
        return;   
    }   
    f = Math.round(x*100)/100;   
    return f;   
}

	function toEdit(){
		
		var checkSql="select tp.project_name,tp.project_info_no,ws.workhour,ws.record_percent,ws.injure_percent,ws.die_percent  from gp_task_project tp join gp_task_project_dynamic td on tp.project_info_no=td.project_info_no and tp.exploration_method=td.exploration_method and td.bsflag='0' join bgp_hse_workhour_single ws on ws.project_info_no=tp.project_info_no and ws.bsflag='0' where to_char(ws.create_date,'yyyy-MM-dd')='<%=today%>' and td.org_subjection_id like '<%=sub_id%>%' ";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(checkSql))+'&&pageSize=100');
		var datas = queryRet.datas;
		if(datas==null||datas==""){
				
		}else{
			for (var i = 0; i<datas.length; i++) {
				toShow(
						i,
						datas[i].project_name ? datas[i].project_name : "",
						datas[i].workhour ? datas[i].workhour : "",
						datas[i].record_percent ? datas[i].record_percent : "",
						datas[i].injure_percent ? datas[i].injure_percent : "",
						datas[i].die_percent ? datas[i].die_percent : "",
						datas[i].project_info_no ? datas[i].project_info_no : ""
					);
			}
		}
		 
		var checkSql2="select sum(ws.workhour) all_hour,sum(ws.record_percent) all_record,sum(ws.injure_percent) all_injure,sum(ws.die_percent) all_die from gp_task_project tp join gp_task_project_dynamic td on tp.project_info_no=td.project_info_no and tp.exploration_method=td.exploration_method and td.bsflag='0' join bgp_hse_workhour_single ws on ws.project_info_no=tp.project_info_no and ws.bsflag='0' where to_char(ws.create_date,'yyyy-MM-dd')='<%=today%>' and td.org_subjection_id like '<%=sub_id%>%'";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(checkSql2))+'&&pageSize=100');
		var datas2 = queryRet2.datas;
		if(datas2==null||datas2==""){
		}else{
			var all_hour = datas2[0].all_hour ? datas2[0].all_hour : "";
			var all_record = datas2[0].all_record ? datas2[0].all_record : "";
			var all_injure = datas2[0].all_injure ? datas2[0].all_injure : "";
			var all_die = datas2[0].all_die ? datas2[0].all_die : "";
			document.getElementById("all_hour").innerHTML = all_hour;
			document.getElementById("all_record").innerHTML = toDecimal(all_record*100)+"%";
			document.getElementById("all_injure").innerHTML = toDecimal(all_injure*100)+"%";
			document.getElementById("all_die").innerHTML = toDecimal(all_die*100)+"%";
		}
		
		var checkSql3="select * from bgp_hse_workhour_target where bsflag = '0'";
	    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
		var datas3 = queryRet3.datas;
		debugger;
		if(datas3==null||datas3==""){
			
		}else{
			document.getElementById("record_target").innerHTML = datas3[0].record_percent;
			document.getElementById("injure_target").innerHTML = datas3[0].injure_percent;
			document.getElementById("die_target").innerHTML = datas3[0].die_percent;
		}
	} 

</script>
</html>