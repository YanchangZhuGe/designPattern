<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String orgSub = request.getParameter("orgSub");
	String paramS = request.getParameter("paramS");
 
	if(orgSub == null || "".equals(orgSub)){
		orgSub = user.getSubOrgIDofAffordOrg();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
<style type="text/css">
.select_height{height:20px;margin:0,0,0,0;}
SELECT {
	margin-bottom:0;
    margin-top:0;
	border:1px #52a5c4 solid;
	color: #333333;
	FONT-FAMILY: "微软雅黑";font-size:9pt;
}
.tongyong_box_title {
	width:100%;
	height:auto;
	background:url(<%=contextPath%>/dashboard/images/titlebg.jpg);
	text-align:left;
	text-indent:12px;
	font-weight:bold;
	font-size:14px;
	color:#0f6ab2;
	line-height:22px;
}
</style>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart();getApplyTeam();">
<div id="list_content" id="div1"  >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%">
						<div id="div1" >
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span>
							<span class="gd"><a href="#"></a></span>
							<%-- <code:codeSelect name='s_team1' option="teamOps" addAll="true"  cssClass="select_height"   selectedValue='' onchange="changeTeam1()"/> --%>	
							 <input type='hidden' id="select_value" name="select_value" value=""/>
							<select cssClass="select_height"  id="s_team1" name="s_team1" onchange="changeTeam1()" ></select>						
							</div>
						<div class="tongyong_box_content_left"  id="chartContainer1" >
			 
						</div>
						</div>
						</div>
						<div id="div2" style="display:none;" >    <div id="A">
						<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
						    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>		
						    <td>&nbsp;</td>
						
						    <auth:ListButton functionId="" css="fh" event="onclick='listReturn()'" title="返回"></auth:ListButton> 
						 
						  </tr>
						</table>
						</td>
						    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
						  </tr>
						</table>
						</div>
							</div>
						
						   <div id="B" style="display:none;">
						 <div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
						    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>		
						    <td>&nbsp;</td>
			  
						    <auth:ListButton functionId="" css="fh" event="onclick='listReturnOne()'" title="返回"></auth:ListButton> 
					 
						  </tr>
						</table>
						</td>
						    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
						  </tr>
						</table>
						</div>
						</div>
						
						<table id="humanDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" >
						  <tr class="bt_info">
						       <td>序号</td>
						       <td>性别</td>
						       <td>姓名</td>
						       <td>班组</td>
						       <td>岗位</td>		
						   </tr>            
						</table>
						</div>
					  	<div id="div3"  style="display:none;" >
						<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
						    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>		
						    <td>&nbsp;</td>
						    <auth:ListButton functionId="" css="fh" event="onclick='listReturnTeam()'" title="JCDP_btn_return"></auth:ListButton> 
						  </tr>
						</table>
						</td>
						    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
						  </tr>
						</table>
						</div>
						 
						<div class="tongyong_box_content_left"  id="chartContainer3" >
			 
						</div>
					 
						</div>
			 
					
					
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>

</body>
<script type="text/javascript">

var subParams= '<%=orgSub%>';

/* var orgId =subParams.split("_")[1];
var paramS =subParams.split("_")[0]; */
 var orgId = '<%=orgSub%>';
 var paramS = '<%=paramS%>';


 function getFusionChart(){
	 				
		var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId1", "100%", "360", "0", "0" );    
		myChart1.setXMLUrl("<%=contextPath%>/rm/em/getChart15.srq?orgId="+orgId+"&paramS="+paramS);      
		myChart1.render("chartContainer1"); 

}
 
 function getPostChart(team){ 
	 if(team =='1'){
		 myJS(team);
			document.getElementById("div1").style.display="none"; 
			document.getElementById("div2").style.display="block";
			document.getElementById("div3").style.display="none";
	 }else{
		var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId3", "100%", "360", "0", "0" );    
		myChart1.setXMLUrl("<%=contextPath%>/rm/em/getChartPost15.srq?orgId="+orgId+"&paramS="+paramS+"&setTeam="+team);      
		document.getElementsByName("select_value")[0].value=team; 
		myChart1.render("chartContainer3"); 
		document.getElementById("div1").style.display="none"; 
		document.getElementById("div2").style.display="none";
		document.getElementById("div3").style.display="block";
	 }
}

 function getApplyTeam(){ 
 	var selectObj = document.getElementById("s_team1"); 
 
 	document.getElementById("s_team1").innerHTML="";
 	selectObj.add(new Option('请选择',""),0);

 	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	
 	for(var i=0;i<applyTeamList.detailInfo.length;i++){
 		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
 	}   	
  

 }
 function changeTeam1(){ 
     var chartReference = FusionCharts("myChartId1");     
     var s_team = document.getElementsByName("s_team1")[0].value; 
     chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart15.srq?orgId="+orgId+"&setTeam="+s_team+"&paramS="+paramS);
     chartReference.render("chartContainer1"); 
 }
 
 
 function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
 
 function myJS(post){
	var sqlStr="";
 if(post =='1'){
		document.getElementById("A").style.display="none";
		document.getElementById("B").style.display="block";
	 sqlStr =" and d1.coding_name  is null and d2.coding_name  is null ";
 }else  if(post =='11'){
		document.getElementById("A").style.display="block";
		document.getElementById("B").style.display="none";
		
		var setTeam=document.getElementsByName("select_value")[0].value; 
	 sqlStr =" and d1.coding_name  is not  null and d2.coding_name  is null and h.set_team = '"+setTeam+"' ";
 }else{
		document.getElementById("A").style.display="block";
		document.getElementById("B").style.display="none";
	 sqlStr =" and h.set_post='"+post+"' ";
 }
		var querySql = " select t.*,rownum from ( select distinct e.employee_id,e.employee_name,h.employee_gz,decode(e.employee_gender,'0','女','1','男') employee_gender,d1.coding_name team_name,d2.coding_name post_name from comm_human_employee e inner join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0'    left join comm_coding_sort_detail d1 on h.set_team=d1.coding_code_id and d1.bsflag='0' left join comm_coding_sort_detail d2 on h.set_post=d2.coding_code_id and d2.bsflag='0'  left join comm_org_subjection s on e.org_id=s.org_id and s.bsflag='0' where e.bsflag = '0' and h.person_status = '0'  "+sqlStr+" and s.org_subjection_id like '"+orgId+"%25' and h.EMPLOYEE_GZ = '"+paramS+"' order by e.employee_name ) t ";
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		deleteTableTr("humanDetailList");
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("humanDetailList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var employee_id = datas[i].employee_id;
				var employee_gz = datas[i].employee_gz;
				
				var td = tr.insertCell(1);
				td.innerHTML = "<a href=javascript:commHumanView('"+employee_id+"-"+employee_gz+"')>"+datas[i].employee_name+"</a>";
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].employee_gender;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].team_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].post_name;
				
			}
		}
		document.getElementById("div1").style.display="none";
		document.getElementById("div2").style.display="block";  
		document.getElementById("div3").style.display="none";
 }
 
function listReturn(){
	document.getElementById("div1").style.display="none"; 
	document.getElementById("div2").style.display="none";
	document.getElementById("div3").style.display="block";
} 

function listReturnOne(){
	document.getElementById("div1").style.display="block"; 
	document.getElementById("div2").style.display="none";
	document.getElementById("div3").style.display="none";
}

function listReturnTeam(){
	document.getElementById("div1").style.display="block"; 
	document.getElementById("div2").style.display="none";
	document.getElementById("div3").style.display="none";
}

 function commHumanView(ids){

	 popWindow('<%=contextPath%>/rm/em/humanChart/commHumanView.jsp?ids='+ids,'800:700');
 }
 
</script>  
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

