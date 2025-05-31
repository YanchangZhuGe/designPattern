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
					<td>百万工时可记录事件人数发生率</td>					
					<td>百万工时损工伤亡发生率</td>					
					<td>百万工时死亡率</td>					
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


function toShow(num,org_name,workhour,record_percent,injure_percent,die_percent){
	
	var table=document.getElementById("hourTable");
	
	var tr = table.insertRow(table.rows.length-2);
	tr.align="center";
	var td = tr.insertCell(0);
	td.innerHTML = Number(num)+1;
	
	td = tr.insertCell(1);
	td.innerHTML = org_name;
	
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
		debugger;
		var checkSql="select t.org_sub_id, os.org_id, oi.org_abbreviation,t.order_num ,wa.workhour,wa.record_percent,wa.injure_percent,wa.die_percent from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' left join bgp_hse_workhour_all wa on t.org_sub_id = wa.subjection_id and wa.bsflag='0' and to_char(wa.create_date,'yyyy-MM-dd')='<%=today%>' where t.father_org_sub_id ='<%=sub_id%>' ";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize=100');
		var datas = queryRet.datas;
		if(datas==null||datas==""){
				
		}else{
			for (var i = 0; i<datas.length; i++) {
				toShow(
						i,
						datas[i].org_abbreviation ? datas[i].org_abbreviation : "",
						datas[i].workhour ? datas[i].workhour : "",
						datas[i].record_percent ? datas[i].record_percent : "",
						datas[i].injure_percent ? datas[i].injure_percent : "",
						datas[i].die_percent ? datas[i].die_percent : ""
					);
			}
		}
		
		var checkSql2="select sum(wa.workhour) all_hour,sum(wa.record_percent) all_record,sum(wa.injure_percent) all_injure,sum(wa.die_percent) all_die from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id = t.org_sub_id and os.bsflag = '0' join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0' left join bgp_hse_workhour_all wa on t.org_sub_id = wa.subjection_id and wa.bsflag='0' and to_char(wa.create_date,'yyyy-MM-dd')='<%=today%>' where t.father_org_sub_id ='<%=sub_id%>'";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize=100');
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