<%@page import="org.springframework.context.annotation.Bean"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getOrgSubjectionId();
	
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String sub_id = "";
	String father_organ_flag = "";
	String organ_flag = "";
	if(list.size()>2){
	 	Map map = (Map)list.get(0);
	 	Map mapOrg = (Map)list.get(1);
	 	father_id = (String)mapOrg.get("orgSubId");
	 	organ_flag = (String)mapOrg.get("organFlag");
	 	if(organ_flag.equals("0")){
	 		father_id = "C105";
	 	}
	}else{
		father_id = "C105";
 		organ_flag = "0";
	}
	
	
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
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table" style="height: 430px;overflow: auto;">
      	<form name="form" id="form"  method="post" action="">
      	<input type="hidden" id="father_id" name="father_id" value="<%=father_id%>"/>
      	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="sz" event="onclick='toSet()'" title="设置"></auth:ListButton>
			     <auth:ListButton functionId="" id="saveButton" css="bc" event="onclick='toSave()'" title="保存"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<table id="showTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr style="height: 50px;">
					<td align="center" colspan="10"><span style="font-size: 28px;font-family: Arial;padding-top: 11px;margin-bottom: 30px;">职业健康状况</span></td>
				</tr>
				<tr align="center">
					<td rowspan="2">序号</td>
					<td rowspan="2">单位</td>
					<td>职业健康体检率</td>
					<td colspan="3">职业病危害作业场所</td>
					<td>职业病危害作业场所体检率</td>
				</tr>
				<tr align="center">
					<td>集团指标:<span id="health_target"></span></td>
					<td>总数</td>
					<td>固定场所</td>
					<td>接害人员</td>
					<td>集团指标:<span id="places_target"></span></td>
				</tr>
<!-- 				<tr align="center">
					<td id="totalNum"></td>
					<td>合计</td>
					<td><input type="text" id="totalLife" name="totalLife" size="12"></input></td>
					<td><input type="text" id="totalIndustry" name="totalIndustry" size="12"></input></td>
					<td><input type="text" id="totalCOD" name="totalCOD"></input></td>
					<td><input type="text" id="totalWater" name="totalWater" size="15"></input></td>
					<td><input type="text" id="totalBoiler" name="totalBoiler" size="12"></input></td>
					<td><input type="text" id="totalCoal" name="totalCoal" size="12"></input></td>
					<td><input type="text" id="totalGas" name="totalGas" size="12"></input></td>
					<td></td>
				</tr>
 -->
			</table>
			</form>
		  </div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	
	
	function refreshData(){
		toEdit();
	}
	function toSave(){
		
		var form = document.getElementById("form");
		var ids ="";
		var orders = document.getElementsByName("order");
		//算出添加的多少行，并且value值
		for(var i=0;i<orders.length;i++){
			order = orders[i].value;
			if(ids!="") ids += ",";
			ids = ids + order;
		}
		
		form.action="<%=contextPath%>/hse/yxControl/saveProfessionalHealth.srq?ids="+ids;
		form.submit();
		alert("保存成功!");
	}
	
	function toSet(){
		popWindow("<%=contextPath%>/hse/professionalHealth/setHealthTarget.jsp");
	}

	function toShowTable(hse_professional_id,org_sub_id,org_name,percent_health,total_num,places,people_num,percent_places){
		
		var table=document.getElementById("showTable");
		debugger;
		var tr = table.insertRow(table.rows.length);
		var rowNum = tr.rowIndex-2;	
		var lineId = "row_" + rowNum;
//		tr.align="center";
		tr.id=lineId;
		var td = tr.insertCell(0);
		td.align="center";
		td.innerHTML = "<input type='hidden' id='order' name='order' value='"+rowNum+"'/><input type='hidden' id='hse_professional_id"+rowNum+"' name='hse_professional_id"+rowNum+"' value='"+hse_professional_id+"' /><input type='hidden' id='org_sub_id"+rowNum+"' name='org_sub_id"+rowNum+"' value='"+org_sub_id+"' />"+rowNum;
		
		td = tr.insertCell(1);
		td.innerHTML = org_name;
		
		td = tr.insertCell(2);
		td.align="center";
		td.innerHTML = "<input type='text' id='percent_health"+rowNum+"' name='percent_health"+rowNum+"' value='"+percent_health+"' size='12' />";
		
		td = tr.insertCell(3);
		td.align="center";
	 	td.innerHTML = "<input type='text' id='total_num"+rowNum+"' name='total_num"+rowNum+"' value='"+total_num+"' size='12' />";
		
		td = tr.insertCell(4);
		td.align="center";
		td.innerHTML = "<input type='text' id='places"+rowNum+"' name='places"+rowNum+"' value='"+places+"'  />";
		
		td = tr.insertCell(5);
		td.align="center";
		td.innerHTML = "<input type='text' id='people_num"+rowNum+"' name='people_num"+rowNum+"' value='"+people_num+"'  size='15'  />";
		
		td = tr.insertCell(6);
		td.align="center";
		td.innerHTML = "<input type='text' id='percent_places"+rowNum+"' name='percent_places"+rowNum+"' value='"+percent_places+"' size='12' />";
		
	}


	//保留小数后几位   四舍五入
	function toDecimal(x) {   
	    var f = parseFloat(x);   
	    if (isNaN(f)) {   
	        return;   
	    }   
	    f = Math.round(x*1000)/1000;   
	    return f;   
	}

	function toEdit(){
			for(var j =3;j <document.getElementById("showTable")!=null && j < document.getElementById("showTable").rows.length ;){
				document.getElementById("showTable").deleteRow(j);
			}
			var checkSql="select ei.*,ho.org_sub_id sub_id,oi.org_abbreviation org_name from bgp_hse_org ho left join  bgp_hse_professional_health ei on ei.org_sub_id=ho.org_sub_id left join comm_org_subjection os on ho.org_sub_id=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where  ho.father_org_sub_id='<%=father_id%>' order by ho.order_num asc";
			var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize=100');
			var datas = queryRet.datas;
			debugger;
			if(datas==null||datas==""){
			}else{
				for(var i = 0; i<datas.length; i++) {
					toShowTable(
							datas[i].hse_professional_id ? datas[i].hse_professional_id : "",
							datas[i].sub_id ? datas[i].sub_id : "",
							datas[i].org_name ? datas[i].org_name : "",
							datas[i].percent_health ? datas[i].percent_health : "",
							datas[i].total_num ? datas[i].total_num : "",
							datas[i].places ? datas[i].places : "",
							datas[i].people_num ? datas[i].people_num : "",
							datas[i].percent_places ? datas[i].percent_places : ""
						);
				}
			}

		var checkSql2="select * from bgp_hse_health_target t where t.bsflag='0'";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize=100');
		var datas2 = queryRet2.datas;
		if(datas2!=null&&datas2!=""){
			document.getElementById("health_target").innerHTML = datas2[0].health_target;
			document.getElementById("places_target").innerHTML = datas2[0].places_target;
		}
		
		
//		var checkSql2="select * from bgp_hse_environment_info where org_sub_id = '<%=father_id%>'";
//	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize=100');
//		var datas2 = queryRet2.datas;
//		if(datas2!=null&&datas2!=""){
//			document.getElementById("father_info_id").value = datas2[0].hse_info_id;
//		}
		
//		totalNumber();
//		totalNumber2();
//		totalNumber3();
//		totalNumber4();
//		totalNumber5();
//		totalNumber6();
//		totalNumber7();
	}	
</script>

</html>

