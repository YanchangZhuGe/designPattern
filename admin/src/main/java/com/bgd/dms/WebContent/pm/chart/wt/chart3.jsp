<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId == null || "".equals(orgSubjectionId)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<title>综合物化探项目运行动态</title>
</head>
<body style="overflow-y: auto;background:#C0E2FB;">
<table id="lineTable" border="1" align="center" width="100%">
	<tr background="blue" class="bt_info">
      <td class="tableHeader" colspan="11">综合物化探项目运行动态表</td>
    </tr>
    <tr background="blue" class="bt_info">
      <td class="tableHeader"  id="td2" colspan="11" align="left"></td>
    </tr>
    <tr background="blue" class="bt_info">
      <td class="tableHeader"  id="td3" colspan="11" align="right"></td>
    </tr>
    <tr background="blue" class="bt_info">
      <td class="tableHeader" rowspan="2">项目名称</td>
      <td class="tableHeader" rowspan="2">甲方单位</td>
      <td class="tableHeader" rowspan="2">队号</td>
    
      <td class="tableHeader" rowspan="2">勘探方法</td>
    
      <td class="tableHeader"  colspan="2">设计</td>
      <td class="tableHeader"  colspan="2">完成</td>
      <td class="tableHeader" rowspan="2">进度</td>
      <td class="tableHeader" rowspan="2">状态</td>
    </tr>
    <tr background="blue" class="bt_info">
    	<td class="tableHeader" >km/km²</td>
    	<td class="tableHeader" >物理点数</td>
    	<td class="tableHeader" >km/km²</td>
    	<td class="tableHeader" >物理点数</td>
    </tr>
</table>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
debugger;
var retObj = jcdpCallService("ChartSrv","getWtProjectDynamic","orgSubjectionId=<%=orgSubjectionId %>");
if(null!=retObj.map){
	var td2 = document.getElementById("td2");
	td2.innerHTML = "截止到"+retObj.map.endDate+"，正在运行的项目"+retObj.map.workNum+"个，正在准备的项目"+retObj.map.readyNum+"个，已完工的项目"+retObj.map.stopNum+"个";

	var td3 = document.getElementById("td3");
	td3.innerHTML = "起止日期："+retObj.map.startDate+" 至 "+retObj.map.endDate;
}
var beforeProjNo="";
if(null!=retObj.list){
	for (var i = 0; i < retObj.list.length ; i++) {
		var data = retObj.list[i];
		var rowNum = i;
		var tr = document.getElementById("lineTable").insertRow();
	
		tr.id="line_"+rowNum;
		
		if(data.project_info_no!=beforeProjNo){//合并行判断
			//项目名称
			var td = tr.insertCell();
			td.setAttribute("rowspan",data.nums);
			td.innerHTML = data.project_name;   
			
			//甲方单位
			var td1 = tr.insertCell();
			td1.setAttribute("rowspan",data.nums);
			td1.innerHTML =data.manage_org_name;

			//队号
			var td2 = tr.insertCell();
			td2.setAttribute("rowspan",data.nums);
			td2.innerHTML =data.team_name;
		}
		tr.insertCell().innerHTML = data.exploration_method;
		tr.insertCell().innerHTML = data.line_length;
		tr.insertCell().innerHTML = data.physics_point;
		tr.insertCell().innerHTML = data.workload;
		tr.insertCell().innerHTML = data.physical_point;
		//完成的坐标点数/设计坐标点数，如果坐标点为空，则是完成的（km/km2）/（km/km2）。
		if(""!=data.physics_point&&""!=data.physical_point){
			tr.insertCell().innerHTML =data.jd2==""?"":parseFloat(data.jd2).toFixed(2)+"%";
		}else{
			tr.insertCell().innerHTML =data.jd1==""?"":parseFloat(data.jd1).toFixed(2)+"%";
		}
		
		if(data.project_info_no!=beforeProjNo){//合并行判断
			//状态
			var td = tr.insertCell();
			td.setAttribute("rowspan",data.nums);
			if(data.project_status=="5000100001000000001"){
				td.innerHTML = "项目启动"; 
			}else if(data.project_status=="5000100001000000002"){
				td.innerHTML = "正在施工"; 
			}else if(data.project_status=="5000100001000000003"){
				td.innerHTML = "项目结束"; 
			}else if(data.project_status=="5000100001000000004"){
				td.innerHTML = "项目暂停"; 
			}else{
				td.innerHTML = "施工结束"; 
			}
			

		}
		beforeProjNo=data.project_info_no; //保存前一条记录的项目编号
	}
}
</script>  
</html>
