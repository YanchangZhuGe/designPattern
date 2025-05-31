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
	
	String target = "";
	String sqlTarget = "select * from bgp_hse_environment_target t where t.bsflag='0'";
	Map mapTarget = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlTarget);
	if(mapTarget!=null){
		target = (String)mapTarget.get("target");
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
      	<input type="hidden" id="father_info_id" name="father_info_id" value=""/>
      	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="sz" event="onclick='toSet()'" title="设置"></auth:ListButton>
			     <auth:ListButton functionId="" css="bc" event="onclick='toSave()'" title="保存"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<table id="showTable" width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="black" class="tab_line_height" style="margin-top: 10px;">
				<tr style="height: 50px;">
					<td align="center" colspan="10"><span style="font-size: 28px;font-family: Arial;padding-top: 11px;margin-bottom: 30px;">环境信息</span></td>
				</tr>
				<tr align="center">
					<td rowspan="2">序号</td>
					<td rowspan="2">单位</td>
					<td rowspan="2">生活源排污口</td>
					<td rowspan="2">工业源排污口</td>
					<td>工业源COD</td>
					<td rowspan="2">水处理设施总数(台)</td>
					<td colspan="4">锅炉烟气处理设施</td>
				</tr>
				<tr align="center">
					<td>集团指标:<span id="target"><%=target %></span></td>
					<td>总数</td>
					<td>燃煤锅炉(个)</td>
					<td>燃气锅炉(个)</td>
					<td>运行情况</td>
				</tr>
				<tr align="center">
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
		
		form.action="<%=contextPath%>/hse/yxControl/saveEnvironmentInfo.srq?ids="+ids;
		form.submit();
	}
	
	function toSet(){
		popWindow("<%=contextPath%>/hse/environmentManage/environmentInfo/setEnvironmentTarget.jsp");
	}

	function toShowTable(hse_info_id,org_sub_id,org_name,life_number,industry_number,industry_cod,water_number,boiler_number,boiler_coal,boiler_gas,boiler_condition){
		
		var table=document.getElementById("showTable");
		debugger;
		var tr = table.insertRow(table.rows.length-1);
		var rowNum = tr.rowIndex-2;	
		var lineId = "row_" + rowNum;
//		tr.align="center";
		tr.id=lineId;
		var td = tr.insertCell(0);
		td.align="center";
		td.innerHTML = "<input type='hidden' id='order' name='order' value='"+rowNum+"'/><input type='hidden' id='hse_info_id"+rowNum+"' name='hse_info_id"+rowNum+"' value='"+hse_info_id+"' /><input type='hidden' id='org_sub_id"+rowNum+"' name='org_sub_id"+rowNum+"' value='"+org_sub_id+"' />"+rowNum;
		
		td = tr.insertCell(1);
		td.innerHTML = org_name;
		
		td = tr.insertCell(2);
		td.align="center";
		td.innerHTML = "<input type='text' id='life_number"+rowNum+"' name='life_number"+rowNum+"' value='"+life_number+"' size='12' onchange='ifNumber(\""+rowNum+"\");totalNumber()'/>";
		
		td = tr.insertCell(3);
		td.align="center";
	 	td.innerHTML = "<input type='text' id='industry_number"+rowNum+"' name='industry_number"+rowNum+"' value='"+industry_number+"' size='12' onchange='ifNumber2(\""+rowNum+"\");totalNumber2()' />";
		
		td = tr.insertCell(4);
		td.align="center";
		td.innerHTML = "<input type='text' id='industry_cod"+rowNum+"' name='industry_cod"+rowNum+"' value='"+industry_cod+"' onchange='ifNumber3(\""+rowNum+"\");totalNumber3()' />";
		
		td = tr.insertCell(5);
		td.align="center";
		td.innerHTML = "<input type='text' id='water_number"+rowNum+"' name='water_number"+rowNum+"' value='"+water_number+"'  size='15' onchange='ifNumber4(\""+rowNum+"\");totalNumber4()' />";
		
		td = tr.insertCell(6);
		td.align="center";
		td.innerHTML = "<input type='text' id='boiler_number"+rowNum+"' name='boiler_number"+rowNum+"' value='"+boiler_number+"' size='12' onchange='ifNumber5(\""+rowNum+"\");totalNumber5()'/>";
		
		td = tr.insertCell(7);
		td.align="center";
		td.innerHTML = "<input type='text' id='boiler_coal"+rowNum+"' name='boiler_coal"+rowNum+"' value='"+boiler_coal+"' size='12' onchange='ifNumber6(\""+rowNum+"\");totalNumber6()' />";
		td = tr.insertCell(8);
		td.align="center";
		td.innerHTML = "<input type='text' id='boiler_gas"+rowNum+"' name='boiler_gas"+rowNum+"' value='"+boiler_gas+"' size='12' onchange='ifNumber7(\""+rowNum+"\");totalNumber7()' />";
		td = tr.insertCell(9);
		td.align="center";
		td.innerHTML = "<textarea id='boiler_condition"+rowNum+"' name='boiler_condition"+rowNum+"' >"+boiler_condition+"</textarea>";
	}


	function ifNumber(rowNum){		
		var life_number = document.getElementById("life_number"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		if(life_number!=""){
			if(!re.test(life_number)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	function totalNumber(){
		var totalLife = 0;
		var orders = document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var lifeNumber = document.getElementById("life_number"+orders[i].value).value;
			totalLife += Number(lifeNumber);
		}
		document.getElementById("totalLife").value = toDecimal(totalLife);
	}
	function ifNumber2(rowNum){		
		var industry_number = document.getElementById("industry_number"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		if(industry_number!=""){
			if(!re.test(industry_number)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	function totalNumber2(){
		var totalIndustry = 0;
		var orders = document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var industryNumber = document.getElementById("industry_number"+orders[i].value).value;
			totalIndustry += Number(industryNumber);
		}
		document.getElementById("totalIndustry").value = toDecimal(totalIndustry);
	}
	function ifNumber3(rowNum){		
		var industry_cod = document.getElementById("industry_cod"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		if(industry_cod!=""){
			if(!re.test(industry_cod)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	function totalNumber3(){
		var totalCOD = 0;
		var orders = document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var industryCOD = document.getElementById("industry_cod"+orders[i].value).value;
			totalCOD += Number(industryCOD);
		}
		document.getElementById("totalCOD").value = toDecimal(totalCOD);
	}
	
	function ifNumber4(rowNum){		
		var water_number = document.getElementById("water_number"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		if(water_number!=""){
			if(!re.test(water_number)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	function totalNumber4(){
		var totalWater = 0;
		var orders = document.getElementsByName("order");
		debugger;
		for(var i=0;i<orders.length;i++){
			var waterNumber = document.getElementById("water_number"+orders[i].value).value;
			totalWater += Number(waterNumber);
		}
		document.getElementById("totalWater").value = toDecimal(totalWater);
	}
	
	function ifNumber5(rowNum){		
		var boiler_number = document.getElementById("boiler_number"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		
		if(boiler_number!=""){
			if(!re.test(boiler_number)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	function totalNumber5(){
		var totalBoiler = 0;
		var orders = document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var boilerNumber = document.getElementById("boiler_number"+orders[i].value).value;
			totalBoiler += Number(boilerNumber);
		}
		document.getElementById("totalBoiler").value = toDecimal(totalBoiler);
	}
	
	function ifNumber6(rowNum){		
		var boiler_coal = document.getElementById("boiler_coal"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		if(boiler_coal!=""){
			if(!re.test(boiler_coal)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	
	function totalNumber6(){
		var totalCoal = 0;
		var orders = document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var boilerCoal = document.getElementById("boiler_coal"+orders[i].value).value;
			totalCoal += Number(boilerCoal);
		}
		document.getElementById("totalCoal").value = toDecimal(totalCoal);
	}
	
	function ifNumber7(rowNum){		
		var boiler_gas = document.getElementById("boiler_gas"+rowNum).value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    
		
		if(boiler_gas!=""){
			if(!re.test(boiler_gas)){
			       alert("请填写正确的数字！");
			       return true;
			    }
		}
	}
	function totalNumber7(){
		var totalGas = 0;
		var orders = document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var boilerGas = document.getElementById("boiler_gas"+orders[i].value).value;
			totalGas += Number(boilerGas);
		}
		totalGas.toFixed(3);
		document.getElementById("totalGas").value = toDecimal(totalGas);
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
			var checkSql="select ei.*,ho.org_sub_id sub_id,oi.org_abbreviation org_name from bgp_hse_org ho left join  bgp_hse_environment_info ei on ei.org_sub_id=ho.org_sub_id left join comm_org_subjection os on ho.org_sub_id=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where  ho.father_org_sub_id='<%=father_id%>' order by ho.order_num asc";
			var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize=100');
			var datas = queryRet.datas;
			debugger;
			if(datas==null||datas==""){
			}else{
				for(var i = 0; i<datas.length; i++) {
					toShowTable(
							datas[i].hse_info_id ? datas[i].hse_info_id : "",
							datas[i].sub_id ? datas[i].sub_id : "",
							datas[i].org_name ? datas[i].org_name : "",
							datas[i].life_number ? datas[i].life_number : "",
							datas[i].industry_number ? datas[i].industry_number : "",
							datas[i].industry_cod ? datas[i].industry_cod : "",
							datas[i].water_number ? datas[i].water_number : "",
							datas[i].boiler_number ? datas[i].boiler_number : "",
							datas[i].boiler_coal ? datas[i].boiler_coal : "",
							datas[i].boiler_gas ? datas[i].boiler_gas : "",
							datas[i].boiler_condition ? datas[i].boiler_condition : ""
						);
				}
			}
		
		var checkSql2="select * from bgp_hse_environment_info where org_sub_id = '<%=father_id%>'";
	    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2+'&&pageSize=100');
		var datas2 = queryRet2.datas;
		if(datas2!=null&&datas2!=""){
			document.getElementById("father_info_id").value = datas2[0].hse_info_id;
		}
		
		totalNumber();
		totalNumber2();
		totalNumber3();
		totalNumber4();
		totalNumber5();
		totalNumber6();
		totalNumber7();
	}	
</script>

</html>

