<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_event_id = "";
	String second_org = "";
	String third_org = "";
	String second_org2 = "";
	String third_org2 = "";
	String event_name = "";
	String event_type = "";
	String event_property = "";
	String event_date = "";
	String event_place = "";
	String write_date = "";
	String out_flag = "";
	String out_name = "";
	String report_name = "";
	String report_date = "";
	
	String number_owner = "";
	String number_out = "";
	String number_stock = "";
	String number_group = "";
	String number_hours = "";
	
	String analyze_name = "";
	String analyze_work = "";
	String result_date = "";
	String duty_name = "";
	String event_process = "";
	String event_reason = "";
	String event_describe = "";
	String event_result = "";
	
	String first_money = "";
	String second_money = "";
	String all_money = "";
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}

//	String index = "1";
	if(resultMsg!=null){
	 	 hse_event_id = resultMsg.getValue("hse_event_id");
		 second_org = resultMsg.getValue("second_org");
		 third_org = resultMsg.getValue("third_org");
		 second_org2 = resultMsg.getValue("second_org2");
		 third_org2 = resultMsg.getValue("third_org2");
		 event_name = resultMsg.getValue("event_name");
		 event_type = resultMsg.getValue("event_type");
		 event_property = resultMsg.getValue("event_property");
		 event_date = resultMsg.getValue("event_date");
		 event_place = resultMsg.getValue("event_place");
		 write_date = resultMsg.getValue("write_date");
		 out_flag = resultMsg.getValue("out_flag");
		 out_name = resultMsg.getValue("out_name");
		 report_name = resultMsg.getValue("report_name");
		 report_date = resultMsg.getValue("report_date");
		
		 number_owner = resultMsg.getValue("number_owner");
		 number_out = resultMsg.getValue("number_out");
		 number_stock = resultMsg.getValue("number_stock");
		 number_group = resultMsg.getValue("number_group");
		 number_hours = resultMsg.getValue("number_hours");
		
		 analyze_name = resultMsg.getValue("analyze_name");
		 analyze_work = resultMsg.getValue("analyze_work");
		 result_date = resultMsg.getValue("result_date");
		 duty_name = resultMsg.getValue("duty_name");
		 event_process = resultMsg.getValue("event_process");
		 event_reason = resultMsg.getValue("event_reason");
		 event_describe = resultMsg.getValue("event_describe");
		 event_result = resultMsg.getValue("event_result");
		
		 first_money = resultMsg.getValue("first_money");
		 second_money = resultMsg.getValue("second_money");
		 all_money = resultMsg.getValue("all_money");
		 
//		 index = resultMsg.getValue("index");
	}
//	int index22 = Integer.parseInt(index);
    
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
<body onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_event_id" name="hse_event_id" value="<%=hse_event_id %>"/>
<input type="hidden" id="isProject" name="isProject" value="<%=isProject %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
				     	<td class="inquire_item6">单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
				      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				      	<%} %>
				      	</td>
				     	<td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				      	<%} %>
				      	</td>
				      	<td class="inquire_item6">下属单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
				      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item6"><font color="red">*</font>事件名称：</td>
				      	<td class="inquire_form6"><input type="text" id="event_name" name="event_name" class="input_width"  value="<%=event_name%>"/></td>
				     	<td class="inquire_item6"><font color="red">*</font>事件类型：</td>
				      	<td class="inquire_form6">
				      		<select id="event_type" name="event_type" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >工业生产安全事件</option>
					          <option value="2" >火灾事件</option>
					          <option value="3" >道路交通事件</option>
					          <option value="4" >其他事件</option>
						    </select>
				      	</td>
				    	<td class="inquire_item6"><font color="red">*</font>事件时间：</td>
				      	<td class="inquire_form6"><input type="text" id="event_date" name="event_date" class="input_width"   value="<%=event_date %>" readonly="readonly"/>
				      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(event_date,tributton1);" />&nbsp;</td>
				     </tr>
				     <tr>
				     	<td class="inquire_item6"><font color="red">*</font>事件性质：</td>
				      	<td class="inquire_form6">
				      		<select id="event_property" name="event_property" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >限工事件</option>
					          <option value="2" >医疗事件</option>
					          <option value="3" >急救箱事件</option>
					          <option value="4" >经济损失事件</option>
					          <option value="5" >未遂事件</option>
						    </select>
				      	</td>
					    <td class="inquire_item6"><font color="red">*</font>事件地点：</td>
					    <td class="inquire_form6"><input type="text" id="event_place" name="event_place" class="input_width" value="<%=event_place %>"/></td>
					    <td class="inquire_item6"><font color="red">*</font>填报日期：</td>
					    <td class="inquire_form6"><input type="text" id="write_date" name="write_date" class="input_width" value="<%=write_date %>" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(write_date,tributton2);" />&nbsp;</td>
					  </tr>
					  <tr>
					  <td class="inquire_item6"><font color="red">*</font>是否为承包商：</td>
					    <td class="inquire_form6">
						<select id="out_flag" name="out_flag" class="select_width" onclick="outMust()">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					    <td class="inquire_item6"><font color="red" id="out_must" style="display: none;">*</font>承包商名称：</td>
					    <td class="inquire_form6"><input type="text" id="out_name" name="out_name" class="input_width" value="<%=out_name %>"/></td>
					   <td class="inquire_item6">报告人：</td>
					    <td class="inquire_form6"><input type="text" id="report_name" name="report_name" class="input_width" value="<%=report_name %>"/></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">报告时间：</td>
					    <td class="inquire_form6"><input type="text" id="report_date" name="report_date" class="input_width" value="<%=report_date %>" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton3);" />&nbsp;</td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

//var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
//var showTabBox = document.getElementById("tab_box_content0");

document.getElementById("event_type").value='<%=event_type%>';
document.getElementById("event_property").value='<%=event_property%>';
document.getElementById("out_flag").value='<%=out_flag%>';

var hse_event_id = '<%=hse_event_id%>';
var number_hours = '<%=number_hours%>';
var duty_name = '<%=duty_name%>';


cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
	
}

	function queryOrg(){
		debugger;
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.flag=="true"){
			var len = retObj.list.length;
			if(len>0){
				document.getElementById("second_org").value=retObj.list[0].orgSubId;
				document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
			}
			if(len>1){
				document.getElementById("third_org").value=retObj.list[1].orgSubId;
				document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
			}
			if(len>2){
				document.getElementById("fourth_org").value=retObj.list[2].orgSubId;
				document.getElementById("fourth_org2").value=retObj.list[2].orgAbbreviation;
			}
		}
	}


//if(hse_event_id!=""){
//		var index = index22;
//		getTab3(index);
//}

//function getTab3(index) {  
//	if(hse_event_id==""){
///		alert("请先填写基本信息");
//		return;
//	}
//	var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
///	var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
//	selectedTag.className ="";
//	selectedTabBox.style.display="none";
//
///	selectedTagIndex = index;
//	
//	selectedTag = document.getElementById("tag3_"+selectedTagIndex);
//	selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
//	selectedTag.className ="selectTag";
//	selectedTabBox.style.display="block";
//	document.getElementById("selectedTagIndex").value=selectedTagIndex;
//}

function outMust(){
	if(document.getElementById("out_flag").value=="1"){
		document.getElementById("out_must").style.display="";
		document.getElementById("out_name").disabled="";
	}else{
		document.getElementById("out_must").style.display="none";
		document.getElementById("out_name").disabled="disabled";
	}
}

function addMoney(){
	var first_money = document.getElementById("first_money").value;
	var second_money = document.getElementById("second_money").value;
	first_money = Number(first_money);
	second_money = Number(second_money);
	document.getElementById("all_money").value=first_money+second_money;
}


function submitButton(){
	var form = document.getElementById("form");
		if(checkText0()){
			return;
		}
//	form.action="<%=contextPath%>/hse/accident/addEvent.srq";
	form.action="<%=contextPath%>/hse/accident/addEvent2.srq";
	form.submit();
}

function closeButton(){
	var ctt = top.frames('list');
	ctt.refreshData();
	newClose();
}

function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("second_org").value = teamInfo.fkValue;
        document.getElementById("second_org2").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("second_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
			}
   
}

function selectOrg3(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("third_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
		        document.getElementById("fourth_org2").value = teamInfo.value;
			}
}

function checkText0(){
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	var fourth_org2=document.getElementById("fourth_org2").value;
	var event_name=document.getElementById("event_name").value;
	var event_type=document.getElementById("event_type").value;
	var event_property=document.getElementById("event_property").value;
	var event_date=document.getElementById("event_date").value;
	var event_place=document.getElementById("event_place").value;
	var write_date=document.getElementById("write_date").value;
	var out_flag = document.getElementById("out_flag").value;
	var out_name = document.getElementById("out_name").value;
	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	if(event_name==""){
		alert("事件名称不能为空，请填写！");
		return true;
	}
	if(event_type==""){
		alert("事件类型不能为空，请选择！");
		return true;
	}
	if(event_property==""){
		alert("事件性质不能为空，请选择！");
		return true;
	}
	if(event_date==""){
		alert("事件日期不能为空，请填写！");
		return true;
	}
	if(event_place==""){
		alert("事件地点不能为空，请填写！");
		return true;
	}
	if(write_date==""){
		alert("填报日期不能为空，请填写！");
		return true;
	}
	if(out_flag==""){
		alert("是否为承包商不能为空，请选择！");
		return true;
	}
	if(out_flag=="1"){
		if(out_name==""){
			alert("承包商名称不能为空，请填写！");
			return true;
		}
	}
	return false;
}

function checkText1(){
	var number_owner = document.getElementById("number_owner").value;
	var number_out=document.getElementById("number_out").value;
	var number_stock=document.getElementById("number_stock").value;
	var number_group=document.getElementById("number_group").value;
	var number_hours=document.getElementById("number_hours").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    
	if(number_owner==""){
		alert("本企业伤害人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_owner))
	   {
	       alert("本企业伤害人数请输入数字！");
	       return true;
	    }
	if(number_out==""){
		alert("外部承包商伤害人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_out))
	   {
	       alert("外部承包商伤害人数请输入数字！");
	       return true;
	    }
	if(number_stock==""){
		alert("股份承包商伤害人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_stock))
	   {
	       alert("股份承包商伤害人数请输入数字！");
	       return true;
	    }
	if(number_group==""){
		alert("集团承包商伤害人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_group))
	   {
	       alert("集团承包商伤害人数请输入数字！");
	       return true;
	    }
	if(number_hours==""){
		alert("限工工时不能为空，请填写！");
		return true;
	}
	if (!re.test(number_hours))
	   {
	       alert("限工工时请输入数字！");
	       return true;
	    }
	return false;
}

function checkText2(){
	var result_date=document.getElementById("result_date").value;
	var duty_name=document.getElementById("duty_name").value;
	var event_process=document.getElementById("event_process").value;
	var event_reason = document.getElementById("event_reason").value;
	var event_describe=document.getElementById("event_describe").value;
	var event_result=document.getElementById("event_result").value;
	if(result_date==""){
		alert("纠正预防措施完成时间不能为空，请填写！");
		return true;
	}
	if(duty_name==""){
		alert("责任人不能为空，请填写！");
		return true;
	}
	if(event_process==""){
		alert("事件经过描述不能为空，请填写！");
		return true;
	}
	if(event_reason==""){
		alert("事件原因不能为空，请填写！");
		return true;
	}
	if(event_describe==""){
		alert("事件原因描述不能为空，请填写！");
		return true;
	}
	if(event_result==""){
		alert("采取的纠正预防措施不能为空，请填写！");
		return true;
	}
	return false;
}

function checkText3(){
	var first_money = document.getElementById("first_money").value;
	var second_money = document.getElementById("second_money").value;
	var all_money = document.getElementById("all_money").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    
	if(first_money==""){
		alert("直接经济损失不能为空，请填写！");
		return true;
	}
	if (!re.test(first_money))
	   {
	       alert("直接经济损失请输入数字！");
	       return true;
	    }
	if(second_money==""){
		alert("间接经济损失不能为空，请填写！");
		return true;
	}
	if (!re.test(second_money))
	   {
	       alert("间接经济损失请输入数字！");
	       return true;
	    }
	if(all_money==""){
		alert("经济损失合计不能为空，请填写！");
		return true;
	}
	if (!re.test(all_money))
	   {
	       alert("经济损失合计请输入数字！");
	       return true;
	    }
	return false;
}


</script>
</html>