<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String contextPath = request.getContextPath();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>项目预警情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body style="background: #C0E2FB; overflow-y: auto;overflow-x:hidden;" onload="drawPage()" >
<input type="hidden" id="lineNum" value="0"/>
<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td>&nbsp;</td>
			  		<auth:ListButton functionId="" css="dc" event="onclick='toExport()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" >
			    	<tr class="bt_info">
			    		  <td class="tableHeader">费用科目</td>
					      <td class="tableHeader">计划成本(万元)</td>
					      <td class="tableHeader">当前实际成本(万元)</td>
					      <td class="tableHeader">超出金额(万元)</td>
					      <td class="tableHeader">超出比例%</td>
			        </tr>            
			   </table>
			</div>
  </div>  
  
  </body>
  
  <script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
function drawPage(){
	var retObj = jcdpCallServiceCache("OPCostSrv","getTeamYJInfo","projectInfoNo=<%=projectInfoNo%>");
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
			if(record.radio.replace('%','')>80){
				debugger;
				var td1=tr.insertCell();
				td1.bgColor ='red';
				td1.innerHTML = record.cost_name;
				td1=tr.insertCell();
				td1.bgColor ='red';
				td1.innerHTML = Math.round(record.plan_money/10000.0*100)/100.0;
				td1=tr.insertCell();
				td1.bgColor ='red';
				td1.innerHTML = Math.round(record.actual_money/10000.0*100)/100.0;
				td1=tr.insertCell();
				td1.bgColor ='red';
				td1.innerHTML = Math.round(record.plus_money/10000.0*100)/100.0;
				td1=tr.insertCell();
				td1.bgColor ='red';
				td1.innerHTML = record.radio;
			}else{
				tr.insertCell().innerHTML = record.cost_name;
				tr.insertCell().innerHTML = Math.round(record.plan_money/10000.0*100)/100.0;
				tr.insertCell().innerHTML = Math.round(record.actual_money/10000.0*100)/100.0;;
				tr.insertCell().innerHTML = Math.round(record.plus_money/10000.0*100)/100.0;;
				tr.insertCell().innerHTML = record.radio;
			}
		}
		document.getElementById("lineNum").value = retObj.datas.length;
	}
}
function toExport(){
	var file_name = encodeURI(encodeURI("成本预警"));
	window.open(cruConfig.contextPath+"/op/OPCostSrv/commExportExcel.srq?export_function=exportWarning&project_info_no=<%=projectInfoNo%>&file_name="+file_name)
}
</script>
  </html>