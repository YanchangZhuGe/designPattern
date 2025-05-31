<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = user.getProjectType();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>物资台账编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload='getApplyTeam()'>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
    <tr>
    <td>
    发放方式：
    </td>
    <td >
    	<input type="radio" name="coding_code" value="1" onclick='checkdiv(1)'>单机计划
    </td>
    <td>
    	<input type="radio" name="coding_code" value="2" onclick='checkdiv(2)' checked='checked'>班组计划
    </td>
     <td>
    	<input type="radio" name="coding_code" value="3" onclick='checkdiv(3)' >其他
    </td>
    </tr>
</table>
<div style="display:" id="iDBody1">
<table>
	<tr>
		<td class="ali_cdn_input">
			使用班组：
		</td>
		<td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" ></select></td>
	</tr>
</table>
</div> 
<div style="display: none" id="iDBody2">
<input type='hidden' name='device_id' id='device_id' >
<table>
	<tr>
		<td class="ali_cdn_input">
			设备名称：
		</td>
		<td class="ali_cdn_input">
		<input type="hidden" id="device_id" name="device_id" class="input_width"  value=""/>
		<input type='text' name='device_name' id='device_name' class="input_width" >
		</td>
		<td class="ali_cdn_input">
			<input type='button' style='width:20px' value='...' onclick='showDevPage()'/>
		</td>
	</tr>
</table>
</div> 
</div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var projectInfoNo = "<%=projectInfoNo%>";
	function checkdiv(value){
		switch(value){
		case 1:{
			 document.getElementById('iDBody1').style.display = "none";
		     document.getElementById('iDBody2').style.display = "";
		     break;
			}
		case 2:{
			 document.getElementById('iDBody1').style.display = "";
		     document.getElementById('iDBody2').style.display = "none";
		     break;
			}
		case 3:{
			 document.getElementById('iDBody1').style.display = "none";
		     document.getElementById('iDBody2').style.display = "none";
		     break;
			}
		}
		}
	function getApplyTeam(){
    	var selectObj = document.getElementById("s_apply_team"); 
    	document.getElementById("s_apply_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

//    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
    	selectObj.add(new Option("储备","CB001"),applyTeamList.detailInfo.length+1);
    	selectObj.add(new Option("配件","PJ001"),applyTeamList.detailInfo.length+2);
    }		
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccount.jsp?projectinfono="+projectInfoNo,obj,"dialogWidth=820px;dialogHeight=380px");

		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var deviceId = returnvalues[0];
			var deviceName = returnvalues[2];
			
			var checkSql="select * from gms_device_account_dui where dev_acc_id='"+deviceId+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				for (var i = 0; i<datas.length; i++) {
					var deviceCode = datas[0].dev_type;		
				}
			}
			document.getElementById("device_name").value = deviceName;
			document.getElementById("device_id").value = deviceCode;
			showDatas(deviceCode);
		}
	}			
	function save(){
		var val = document.getElementsByName("coding_code");
		for(var i=0;i<val.length;i++){
				if(val[i].checked ==true){
						if(val[i].value == "1"){
							var deviceName=document.getElementById("device_name").value;
							var deviceCode=document.getElementById("device_id").value;
							document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/warehouse/out/grant/grantOutDevice.jsp?deviceName="+deviceName+"&deviceCode="+deviceCode;	
							}
						else{
							if(val[i].value == "2"){
								var selectId = document.getElementById("s_apply_team").value; 
								var selectText = document.getElementById("s_apply_team").options[window.document.getElementById("s_apply_team").selectedIndex].text;
								document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/warehouse/out/grant/grantOut.jsp?selectId="+selectId+"&selectText="+selectText;
							}
							else{
								document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/warehouse/out/grant/grantOutOther.jsp";	
								}
						}
					}
					
			}
		document.getElementById("form1").submit();
	}	
</script>
</html>