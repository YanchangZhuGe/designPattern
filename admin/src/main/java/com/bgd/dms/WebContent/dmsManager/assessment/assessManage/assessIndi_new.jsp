<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%> 
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>新增考核指标</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content" style="height: 500px;">
    <div id="new_table_box_bg" style="height: 350px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<tr>
      		<td>
		      <fieldset style="margin-left:2px"><legend>指标基本信息</legend>
			      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			        <tr>
			          <td class="inquire_item6" align="left">指标类型:</td>
			          <td class="inquire_form6" style="padding-right:20px">
			          	<select id="assess_type" name="assess_type">
			          	</select>
			          </td>
			          <td class="inquire_item6" align="left">指标值上限(%):</td>
					  <td class="inquire_form6" style="padding-right:20px">
						<input name="assess_ceiling" id="assess_ceiling" class="input_width" type="text"  onblur='checkAssessNum(this,"cei")' value="100" />
					  </td>
					  <td class="inquire_item6" align="left">指标值下限(%):</td>
					  <td class="inquire_form6" style="padding-right:20px">
						<input name="assess_floor" id="assess_floor" class="input_width" type="text"  onblur='checkAssessNum(this,"flo")' value="0" />
					  </td>
			        </tr>
			      </table>
		      </fieldset>
      		</td>
      	</tr>
      </table>
      <fieldset style="margin-left:2px"><legend><font color=red>*</font>&nbsp;设备类型</legend>
	    <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  	  <input type="hidden" id="dev_type_value" name="dev_type_value"/>
	  	  <input type="button" value="    选择" style="width:70px;height:25px;background-image:url(<%=contextPath %>/css/dms_home/images/ico-xuanze.png); background-repeat:no-repeat; background-position:5px 2px;" onclick="selectAssessDev()"/>
			<td class="inquire_form6" colspan="5">
				<textarea id="type_name" name="type_name" rows="2" cols="80" readonly></textarea>
			</td>		  	
	  </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend><font color=red>*</font>&nbsp;资产状况</legend>
		<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  	  <input type="hidden" id="account_stat_value" name="account_stat_value"></input>
		  	<%
				String sql1 = "select d.coding_sort_id,d.coding_code_id,d.coding_name from comm_coding_sort_detail d where d.coding_sort_id = '0110000013' and d.spare2 = '1' and d.bsflag = '0' order by d.coding_code_id";
				
				 List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1); 
				 for (int i = 0; i < list1.size(); i=i+3) {					
					String codingName = "";
					String codingCodeId = "";
					String codingName2 = "";
					String codingCodeId2 = "";
					String codingName3 = "";
					String codingCodeId3 = "";				
			%>
		  <tr>
			<%if(i<list1.size()){
				Map map = (Map)list1.get(i);
				codingName = (String)map.get("codingName");
				codingCodeId = (String)map.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox"  id="account_stat<%=codingCodeId%>" name="account_stat" value="<%=codingCodeId%>"/> 
				<span id="naccount_stat<%=codingCodeId%>"> <%=codingName%> </span>
			</td>
			<%} 
			if(i+1<list1.size()){
				Map map2 = (Map)list1.get(i+1);
				codingName2 = (String)map2.get("codingName");
				codingCodeId2 = (String)map2.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox" id="account_stat<%=codingCodeId2%>" name="account_stat" value="<%=codingCodeId2%>"/> 
				<span id="naccount_stat<%=codingCodeId2%>"> <%=codingName2%> </span>
			</td>
			<%} 
			if(i+2<list1.size()){
				Map map3 = (Map)list1.get(i+2);
				codingName3 = (String)map3.get("codingName");
				codingCodeId3 = (String)map3.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox" id="account_stat<%=codingCodeId3%>" name="account_stat" value="<%=codingCodeId3%>"/> 
				<span id="naccount_stat<%=codingCodeId3%>"> <%=codingName3%> </span>
			</td>
			<%} %>
		  </tr>
		  <%} %>
	  </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend><font color=red>*</font>&nbsp;生产设备</legend>
		<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  	  <input type="hidden" id="dev_produce_value" name="dev_produce_value"></input>
		  	<%
				String sql2 = "select d.coding_sort_id,d.coding_code_id,d.coding_name from comm_coding_sort_detail d where d.coding_sort_id = '5110000186' and d.bsflag = '0' order by d.coding_code_id";
				
				 List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2); 
				 for (int i = 0; i < list2.size(); i=i+2) {					
					String codingName = "";
					String codingCodeId = "";
					String codingName2 = "";
					String codingCodeId2 = "";			
			%>
		  <tr>
			<%if(i<list2.size()){
				Map map = (Map)list2.get(i);
				codingName = (String)map.get("codingName");
				codingCodeId = (String)map.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox"  id="dev_produce<%=codingCodeId%>" name="dev_produce" value="<%=codingCodeId%>"/> 
				<span id="ndev_produce<%=codingCodeId%>"> <%=codingName%> </span>
			</td>
			<%} 
			if(i+1<list2.size()){
				Map map2 = (Map)list2.get(i+1);
				codingName2 = (String)map2.get("codingName");
				codingCodeId2 = (String)map2.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox" id="dev_produce<%=codingCodeId2%>" name="dev_produce" value="<%=codingCodeId2%>"/> 
				<span id="ndev_produce<%=codingCodeId2%>"> <%=codingName2%> </span>
			</td>
			<%}%>
		  </tr>
		  <%} %>
	  </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend><font color=red>*</font>&nbsp;国内/国外</legend>
		<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  	  <input type="hidden" id="dev_ifcountry_value" name="dev_ifcountry_value"></input>
		  	<%
				String sql3 = "select d.coding_sort_id,d.coding_code_id,d.coding_name from comm_coding_sort_detail d where d.coding_sort_id = '5110000195' and d.bsflag = '0' order by d.coding_code_id";
				
				 List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3); 
				 for (int i = 0; i < list3.size(); i=i+2) {					
					String codingName = "";
					String codingCodeId = "";
					String codingName2 = "";
					String codingCodeId2 = "";			
			%>
		  <tr>
			<%if(i<list3.size()){
				Map map = (Map)list3.get(i);
				codingName = (String)map.get("codingName");
				codingCodeId = (String)map.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox"  id="dev_ifcountry<%=codingCodeId%>" name="dev_ifcountry" value="<%=codingCodeId%>"/> 
				<span id="ndev_ifcountry<%=codingCodeId%>"> <%=codingName%> </span>
			</td>
			<%} 
			if(i+1<list3.size()){
				Map map2 = (Map)list3.get(i+1);
				codingName2 = (String)map2.get("codingName");
				codingCodeId2 = (String)map2.get("codingCodeId");
			%>
			<td class="inquire_form6" style="padding-left: 20px;">
				<input type="checkbox" id="dev_ifcountry<%=codingCodeId2%>" name="dev_ifcountry" value="<%=codingCodeId2%>"/> 
				<span id="ndev_ifcountry<%=codingCodeId2%>"> <%=codingName2%> </span>
			</td>
			<%}  %>
		  </tr>
		  <%} %>
	  </table>
     </fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a id="submitButton" href="####" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function loadDataDetail(){
		var retObj = jcdpCallService("DeviceAssessInfoSrv", "getAllAssessInfo", "");
		var assesstypeoptionhtml = "";
		
		if(retObj!=null && retObj.returnCode=='0'){
			for(var index=0;index<retObj.assesslist.length;index++){
				assesstypeoptionhtml +=  "<option name='assesstypecode' id='assesstypecode"+index+"' value='"+retObj.assesslist[index].value+"'>"+retObj.assesslist[index].label+"</option>";
			}
			$("#assess_type").append(assesstypeoptionhtml);
		}
	}
	
	function saveInfo(){

		var assess_type = document.getElementById("assess_type").value;
		
		var retObj = jcdpCallService("DeviceAssessInfoSrv", "getAssessExist", "assesstype="+assess_type);
		
		if(retObj != null&&retObj!=""){
			if(retObj.existtmp == '1'){
				alert("此指标已存在，不能新增!");
				return;
			}
		}

		var assessceiling = parseInt($("#assess_ceiling").val(),10);
		var assessfloor = parseInt($("#assess_floor").val(),10);
		if((assessceiling >0) && (assessfloor > assessceiling)){
			alert("指标值下限不能大于上限!");
			return;
		}
		
		var dev_type_value = document.getElementById("dev_type_value").value;//设备类型
		if(dev_type_value == ''){
			alert("设备类型不能为空!");
			return;
		}
		
		var account_stat_value = "";//资产状况
		var account_stat = document.getElementsByName("account_stat");
		for(var j=0;j<account_stat.length;j++){
			if(account_stat[j].checked==true){
				if(account_stat_value!=""){
					account_stat_value += ",";
				}
				account_stat_value += account_stat[j].value;
			}
 	  	}
		if(account_stat_value == ''){
			alert("资产状况不能为空!");
			return;
		}
		document.getElementById("account_stat_value").value=account_stat_value;
		
		var dev_produce_value = "";//生产设备
		var dev_produce = document.getElementsByName("dev_produce");
		for(var j=0;j<dev_produce.length;j++){
			if(dev_produce[j].checked==true){
				if(dev_produce_value!=""){
					dev_produce_value += ",";
				}
				dev_produce_value += dev_produce[j].value;
			}
 	  	}
		if(dev_produce_value == ''){
			alert("生产设备不能为空!");
			return;
		}
		document.getElementById("dev_produce_value").value=dev_produce_value;
		
		var dev_ifcountry_value = "";//国内/国外
		var dev_ifcountry = document.getElementsByName("dev_ifcountry");
		for(var j=0;j<dev_ifcountry.length;j++){
			if(dev_ifcountry[j].checked==true){
				if(dev_ifcountry_value!=""){
					dev_ifcountry_value += ",";
				}
				dev_ifcountry_value += dev_ifcountry[j].value;
			}
 	  	}
		if(dev_ifcountry_value == ''){
			alert("国内/国外不能为空!");
			return;
		}
		document.getElementById("dev_ifcountry_value").value=dev_ifcountry_value;
		
		if(window.confirm("确认保存?")){
			$.messager.progress({title:'请稍后',msg:'处理中...'}); 
			$("#submitButton").attr({"disabled":"disabled"});
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveAssessInfo.srq?";
			document.getElementById("form1").submit();
		}
	}

	//选择单台设备
	function selectAssessDev(){
		var obj = new Object();

		var vReturnValue = window.showModalDialog("<%=contextPath%>/dmsManager/assessment/assessManage/selectAssessDev.jsp",obj,"dialogWidth=550px;dialogHeight=480px");
		
		if(typeof vReturnValue!="undefined"){
			var idName = vReturnValue.split("~");
			
			document.getElementById("dev_type_value").value=idName[0];
			document.getElementById("type_name").value=idName[1];
		}
	}

	function checkAssessNum(obj,str){
		var assessValue = obj.value;
		var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
		if(assessValue==""){
			if(str=="cei"){
				$("#assess_ceiling").val("");
				alert("指标值上限不能为空!");
			}else{
				$("#assess_floor").val("");
				alert("指标值下限不能为空!");
			}
			return;
		}else{
			var assessValue = parseInt(assessValue,10);
			if(str=="cei"){
				if(!re.test(assessValue)){
					$("#assess_ceiling").val("");
					alert("指标值上限必须为数字!");
					return;
				}
				if(assessValue > 100){
					$("#assess_ceiling").val("");
					alert("指标值上限不能超过100!");
					return;
				}				
			}else if(str=="flo"&&!re.test(assessValue)){
				$("#assess_floor").val("");
				alert("指标值下限必须为数字!");
				return;
			}
		}
	}
	
</script>
</html>

