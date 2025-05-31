<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubjectionId = user.getOrgSubjectionId();
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
<input type="hidden" id="hse_workhour_id" name="hse_workhour_id" value=""/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table id="hourTable" width="100%" border="1" bordercolor="black" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
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
				      	<td class="inquire_form6" colspan="2">
				      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
				      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item6">员工总数：</td>
				      	<td class="inquire_form6" colspan="3"><span id="total_people_num"></span></td>
				      	<td class="inquire_item6">开始统计时间：</td>
				      	<td class="inquire_form6" colspan="2"><input type="text" id="start_date" name="start_date" class="input_width"   value=""/>
						      		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_date,tributton1);" />&nbsp;
						      	</td>
				     </tr>
				     <tr align="center">
				     	<td >作业性质：</td>
				      	<td >24小时</td>
				      	<td >16小时</td>
					    <td >12小时</td>
					    <td >8小时</td>
					    <td >4小时</td>
					    <td >2小时</td>
					  </tr>
					  <tr>
					  	<td>员工数量</td>
					  	<td><input type="text" id="people_num_1" name="people_num_1" value=""></input></td>
					  	<td><input type="text" id="people_num_2" name="people_num_2" value=""></input></td>
					  	<td><input type="text" id="people_num_3" name="people_num_3" value=""></input></td>
					  	<td><input type="text" id="people_num_4" name="people_num_4" value=""></input></td>
					  	<td><input type="text" id="people_num_5" name="people_num_5" value=""></input></td>
					  	<td><input type="text" id="people_num_6" name="people_num_6" value=""></input></td>
					  </tr>
					  <tr id="relaxRow" valign="top" align="center">
					  	<td valign="center">休息状况：</td>
					  </tr>
					  <tr>
					  	<td>工时</td>
					  	<td colspan="6"></td>
					  </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

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
	
	showWeek();
	
	function showWeek(){
		var table = document.getElementById("hourTable");
		var tr = document.getElementById("relaxRow");
		var td="";
		for(var i=1;i<7;i++){
			td = tr.insertCell(i);
			td.innerHTML = "<input type='checkbox' name='monday_"+i+"' id='monday_"+i+"' value='1'>星期一</input><br /><input type='checkbox' name='tuesday_"+i+"' id='tuesday_"+i+"' value='1'>星期二</input><br /><input type='checkbox' name='wednesday_"+i+"' id='wednesday_"+i+"' value='1'>星期三</input><br /><input type='checkbox' name='thursday_"+i+"' id='thursday_"+i+"' value='1'>星期四</input><br /><input type='checkbox' name='friday_"+i+"' id='friday_"+i+"' value='1'>星期五</input><br /><input type='checkbox' name='saturday_"+i+"' id='saturday_"+i+"' value='1'>星期六</input><br /><input type='checkbox' name='sunday_"+i+"' id='sunday_"+i+"' value='1'>星期日</input><br />";
		}
		toEdit();
	}
	

function submitButton(){
	debugger;
	var re = /^[0-9]+[0-9]*$/;
	
	var start_date = document.getElementById("start_date").value;
	if(start_date==""){
		alert("开始统计时间为必填项，请选择日期");
		return;
	}else{
		var temp = start_date.split("-");
		var sdate = new Date(temp[0],parseInt(temp[1])-1,temp[2]);
		var today = new Date();
		if(sdate.valueOf()>today.valueOf()){
			alert("选择日期不得大于当前日期！");
			return;
		}
	}
	
	for(var i=1;i<7;i++){
		var people_num = document.getElementById("people_num_"+i).value;
		if(people_num!=""){
			if (!re.test(people_num)){
				alert("员工数量请输入数字且为整数！");
				return;
			}
		}
	}
	
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/workhour/hourSet.srq";
	form.submit();
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
        
        document.getElementById("third_org").value = "";
        document.getElementById("third_org2").value = "";
        
        document.getElementById("fourth_org").value = "";
        document.getElementById("fourth_org2").value = "";
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
		        
		       	document.getElementById("fourth_org").value = "";
		       	document.getElementById("fourth_org2").value = "";
		        
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


	function toEdit(){ 
		for(var i=1;i<7;i++){
			var checkSql="select ws.hse_workhour_id id,ws.start_date , wd.* from bgp_hse_workhour_set ws left join bgp_hse_workhour_detail wd on ws.hse_workhour_id = wd.hse_workhour_id where ws.bsflag = '0' and ws.project_info_no is null and ws.subjection_id='<%=orgSubjectionId%>' and wd.type='"+i+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
				
			}else{
				document.getElementById("hse_workhour_id").value = datas[0].id;
				document.getElementById("start_date").value = datas[0].start_date;
				document.getElementById("people_num_"+i).value = datas[0].people_num;
				var monday = datas[0].monday;
				var tuesday = datas[0].tuesday;
				var wednesday = datas[0].wednesday;
				var thursday = datas[0].thursday;
				var friday = datas[0].friday;
				var saturday = datas[0].saturday;
				var sunday = datas[0].sunday;
				if(monday=="1"){
					document.getElementById("monday_"+i).checked = true;
				}
				if(tuesday=="1"){
					document.getElementById("tuesday_"+i).checked = true;
				}
				if(wednesday=="1"){
					document.getElementById("wednesday_"+i).checked = true;
				}
				if(thursday=="1"){
					document.getElementById("thursday_"+i).checked = true;
				}
				if(friday=="1"){
					document.getElementById("friday_"+i).checked = true;
				}
				if(saturday=="1"){
					document.getElementById("saturday_"+i).checked = true;
				}
				if(sunday=="1"){
					document.getElementById("sunday_"+i).checked = true;
				}
			}
		}
		var checkSql22 ="select  count(ee.employee_id) num  from comm_human_employee ee join comm_org_subjection os on ee.org_id = os.org_id and os.bsflag='0' where ee.bsflag='0' and os.org_subjection_id like '<%=orgSubjectionId%>%'";
		checkSql22 = encodeURI(encodeURI(checkSql22));
	    var queryRet22 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql22);
		var datas22 = queryRet22.datas;
		if(datas22!=null){
			document.getElementById("total_people_num").innerHTML = datas22[0].num;
		}
	} 



</script>
</html>