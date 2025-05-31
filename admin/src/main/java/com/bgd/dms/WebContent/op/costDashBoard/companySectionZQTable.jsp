<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String contextPath = request.getContextPath();	
	String orgId=request.getParameter("orgId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>物探处收入情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
</head>
<body style="background: #C0E2FB; overflow-y: no;width: 820px" onload="drawPage()">
<input type="hidden" id="lineNum" value="0"/>
<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
    <tr class="bt_info">
      <td class="tableHeader">项目名称</td>
      <td class="tableHeader">类型</td>
      <td class="tableHeader">队伍</td>
      <td class="tableHeader">实际完成价值工作量(万元)</td>
      <td class="tableHeader">完成工作量km/km2</td>
      <td class="tableHeader">完成炮数</td>
      <td class="tableHeader">进度%</td>
      <td class="tableHeader">采集开始时间</td>
      <td class="tableHeader">采集结束时间</td>
      <td class="tableHeader">项目状况</td>
    </tr>
  </table>
  </body>
  
  <script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
function drawPage(){
	var retObj = jcdpCallService("OPCostSrv","getSectionCompareTeamIncomeInfo","orgId=<%=orgId%>");
	var price_heji=0;
	var workload_heji=0;
	var finish_sp_heji=0;
	if(retObj.datas != null){
		for(var i=0;i<retObj.datas.length;i++){
			var record = retObj.datas[i];
			var rowNum = i;
			var tr = document.getElementById("lineTable").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.height= 25;
			// 单元格
			var td1=tr.insertCell();
			td1.innerHTML = "<a href='#' onclick=open1('"+record.project_info_no+"')>"+record.team_id+"</a>";
			tr.insertCell().innerHTML = record.exploration_method;
			tr.insertCell().innerHTML = record.team_name;
			tr.insertCell().innerHTML = record.price;
			tr.insertCell().innerHTML = record.workload;
			tr.insertCell().innerHTML = record.finish_sp;
			tr.insertCell().innerHTML = record.jd;
			tr.insertCell().innerHTML = record.acquire_start_time;
			tr.insertCell().innerHTML = record.acquire_end_time;
			tr.insertCell().innerHTML = record.project_status;
			price_heji=fixMath(price_heji,record.price,'+');
			workload_heji=fixMath(workload_heji,record.workload,'+');
			finish_sp_heji=fixMath(finish_sp_heji,record.finish_sp,'+');
			
		}
			var tr = document.getElementById("lineTable").insertRow();
			if(retObj.datas.length % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.height= 25;
			// 单元格
			var td1=tr.insertCell();
			td1.innerHTML = "<a href='#'>合计</a>";
			tr.insertCell().innerHTML = '&nbsp;';
			tr.insertCell().innerHTML = '&nbsp;';
			tr.insertCell().innerHTML = price_heji;
			tr.insertCell().innerHTML = workload_heji;
			tr.insertCell().innerHTML = finish_sp_heji;
			tr.insertCell().innerHTML = '&nbsp;';
			tr.insertCell().innerHTML = '&nbsp;';
			tr.insertCell().innerHTML = '&nbsp;';
			tr.insertCell().innerHTML = '&nbsp;';
		document.getElementById("lineNum").value = retObj.datas.length;
	}
}


function  fixMath(m,   n,   op)   
    { 
        var   a   =   (m+ " "); 
        var   b   =   (n+ " "); 
        var   x   =   1; 
        var   y   =   1; 
        var   c   =   1; 
        if(a.indexOf( ". ")> 0)   { 
            x   =   Math.pow(10,   a.length   -   a.indexOf( ". ")   -   1); 
        } 
        if(b.indexOf( ". ")> 0)   { 
            y   =   Math.pow(10,   b.length   -   b.indexOf( ". ")   -   1); 
        } 
        switch(op) 
        { 
            case   '+ ': 
            case   '- ': 
                c   =   Math.max(x,y); 
                m   =   Math.round(m*c); 
                n   =   Math.round(n*c); 
                break; 
            case   '* ': 
                c   =   x*y 
                m   =   Math.round(m*x); 
                n   =   Math.round(n*y); 
                break; 
            case   '/ ': 
                c   =   Math.max(x,y); 
         
                m   =   Math.round(m*c); 
                n   =   Math.round(n*c); 
                c   =   1; 
                break; 
        } 
        return   eval( "( "+m+op+n+ ")/ "+c); 
    }
function open1(project_info_no){
	var obj=new Object();
	window.showModalDialog("<%=contextPath%>/op/costDashBoard/team11.jsp?projectInfoNo="+project_info_no,obj,"dialogWidth=800px;dialogHeight=600px");
}
</script>
  </html>