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
	
	String isGuoNei=request.getParameter("isGuoNei");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>物探处收入情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
</head>
<body style="background: #C0E2FB; overflow-y: auto;overflow-x:hidden;width: 780px" onload="drawPage()" >
<input type="hidden" id="lineNum" value="0"/>
<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="98%">
    <tr class="bt_info">
      <td class="tableHeader">单位</td>
      <td class="tableHeader">类型</td>
      <td class="tableHeader">实际完成价值工作量(万元)</td>
      <td class="tableHeader">完成工作量km/km2</td>
      <td class="tableHeader">完成炮数</td>
    </tr>
  </table>
  </body>
  
  <script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
function drawPage(){
	var retObj = jcdpCallService("OPCostSrv","getCompareSectionIncomeTwoThreeInfo","isGuoNei=<%=isGuoNei%>");
	if(retObj.datas != null){
		var price2_heji=0;
		var workload2d_heji=0;
		var sp2_heji=0;
		
		var price2_heji3=0;
		var workload2d_heji3=0;
		var sp2_heji3=0;
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
			td1.innerHTML = "<a href='#' onclick=open1('"+record.org_subjection_id+"')>"+record.w_label+"</a>";
			tr.insertCell().innerHTML = '二维';
			tr.insertCell().innerHTML = record.price2;
			tr.insertCell().innerHTML = record.workload_2d;
			tr.insertCell().innerHTML = record.sp_2;
			
			//price2_heji+=parseInt(record.price2);
				debugger;
			price2_heji=fixMath(price2_heji,record.price2,'+');
			workload2d_heji=fixMath(workload2d_heji,record.workload_2d,'+');
			sp2_heji=fixMath(sp2_heji,record.sp_2,'+');
			
			var tr = document.getElementById("lineTable").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.height= 25;
			// 单元格
			var td2=tr.insertCell();
			td2.innerHTML = "<a href='#' onclick=open1('"+record.org_subjection_id+"')>"+record.w_label+"</a>";
			tr.insertCell().innerHTML = '三维';
			tr.insertCell().innerHTML = record.price3;
			tr.insertCell().innerHTML = record.workload_3d;
			tr.insertCell().innerHTML = record.sp_3;
			
			
			//price2_heji3+=parseInt(record.price3);
			//workload2d_heji3+=parseInt(record.workload_3d);
			//sp2_heji3+=parseInt(record.sp_3);
			
			price2_heji3=fixMath(price2_heji3,record.price3,'+');
			price2_heji3=fixMath(workload2d_heji3,record.workload_3d,'+');
			price2_heji3=fixMath(sp2_heji3,record.sp_3,'+');
			
			
			
			td2.parentNode.removeChild(td2);
			td1.rowSpan++;
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
			tr.insertCell().innerHTML = '二维';
			tr.insertCell().innerHTML = price2_heji;
			tr.insertCell().innerHTML = workload2d_heji;
			tr.insertCell().innerHTML = sp2_heji;
			
			var tr = document.getElementById("lineTable").insertRow();
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.height= 25;
			// 单元格
			var td2=tr.insertCell();
			td2.innerHTML = "<a href='#'>合计</a>";
			tr.insertCell().innerHTML = '三维';
			tr.insertCell().innerHTML = price2_heji3;
			tr.insertCell().innerHTML = workload2d_heji3;
			tr.insertCell().innerHTML = sp2_heji3;
			
			td2.parentNode.removeChild(td2);
			td1.rowSpan++;
			
		document.getElementById("lineNum").value = retObj.datas.length;
	}
}

function toDecimal(x) {  
    var f = parseFloat(x);  
    if (isNaN(f)) {  
        return;  
    }  
    f = Math.round(x*100)/100;  
    return f;  
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
        return   toDecimal(eval( "( "+m+op+n+ ")/ "+c)); 
    }
function open1(orgCode){
	var obj=new Object();
	window.showModalDialog("<%=contextPath%>/op/costDashBoard/companySectionZQTable.jsp?orgId="+orgCode,obj,"dialogWidth=820px;dialogHeight=600px");
}
</script>
  </html>