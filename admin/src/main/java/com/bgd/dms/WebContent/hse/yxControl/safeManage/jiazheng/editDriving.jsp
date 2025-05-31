<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	Map map  = resultMsg.getMsgElement("map").toMap();
	String driving_type = (String)map.get("drivingType");
	String hseID = (String)map.get("hseDrivingId");
	String remarkID = (String)map.get("remarkId");
	System.out.println(driving_type);
	System.out.println(hseID);
	System.out.println(remarkID);
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
<body>
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					<input type="hidden" id="driving_type" name="driving_type" value="<%=driving_type%>">
					<input type="hidden" id="hse_driving_id" name="hse_driving_id" value="<%=(String)map.get("hseDrivingId")%>">
					<input type="hidden" id="remark_id" name="remark_id" value="<%=(String)map.get("remarkId")%>">
					<%if(driving_type.equals("2")){%>
						<tr>
					     	<td class="inquire_item6"><font color="red">*</font>二级单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org" name="second_org" class="input_width"  value="<%=(String)map.get("secondOrg")%>"/>
					      	<input type="text" id="second_org2" name="second_org2" class="input_width"  value="<%=(String)map.get("secondOrgName") %>" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	</td>
					     	<td class="inquire_item6"><font color="red">*</font>基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org" name="third_org" class="input_width"  value="<%=(String)map.get("thirdOrg") %>" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"   value="<%=(String)map.get("thirdOrgName") %>" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>姓名：</td>
					      	<td class="inquire_form6"><input type="text" id="name" name="name" class="input_width"  value="<%=(String)map.get("name") %>"/></td>
					     </tr>
						 <tr>
					     	<td class="inquire_item6"><font color="red">*</font>性别：</td>
					      	<td class="inquire_form6">
					      		<select id="sex" name="sex" class="select_width">
						          <option value="" >请选择</option>
						          <option value="1" >男</option>
						          <option value="2" >女</option>
							    </select>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>出生年月：</td>
					      	<td class="inquire_form6"><input type="text" id="birthday" name="birthday" class="input_width"   value="<%=(String)map.get("birthday") %>" readonly="readonly"/>
					      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(birthday,tributton1);" />&nbsp;</td>
					      	<td class="inquire_item6"><font color="red">*</font>人员职务：</td>
					      	<td class="inquire_form6">
					      		<select id="duty" name="duty" class="select_width">
						          <option value="" >请选择</option>
						          <option value="1" >处级</option>
						          <option value="2" >科级</option>
						          <option value="3" >其他</option>
							    </select>
					      	</td>
					     </tr>
					     <tr>
					     	<td class="inquire_item6"><font color="red">*</font>身份证号：</td>
					      	<td class="inquire_form6"><input type="text" id="card_id" name="card_id" class="input_width"  value="<%=(String)map.get("cardId") %>"/></td>
						    <td class="inquire_item6"><font color="red">*</font>准驾证档案编号：</td>
						    <td class="inquire_form6"><input type="text" id="file_number" name="file_number" class="input_width" value="<%=(String)map.get("fileNumber") %>"/></td>
						    <td class="inquire_item6"><font color="red">*</font>准驾车型：</td>
						    <td class="inquire_form6"><input type="text" id="car_type" name="car_type" class="input_width" value="<%=(String)map.get("carType") %>"/></td>
						  </tr>
						  <tr>
						  <td class="inquire_item6"><font color="red">*</font>准驾证编号：</td>
						    <td class="inquire_form6"><input type="text" id="driving_number" name="driving_number" class="input_width" value="<%=(String)map.get("drivingNumber") %>"></input></td>
						    <td class="inquire_item6"><font color="red">*</font>发证单位：</td>
						    <td class="inquire_form6"><input type="text" id="sign_org" name="sign_org" class="input_width" value="<%=(String)map.get("signOrg") %>"/></td>
						   <td class="inquire_item6"><font color="red">*</font>签发人：</td>
						    <td class="inquire_form6"><input type="text" id="signer" name="signer" class="input_width" value="<%=(String)map.get("signer") %>"/></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>签发日期：</td>
						    <td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width" value="<%=(String)map.get("signDate") %>" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton3);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>有效期：</td>
						    <td class="inquire_form6"><input type="text" id="expiry_date" name="expiry_date" class="input_width" value="<%=(String)map.get("expiryDate") %>" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(expiry_date,tributton4);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>二级单位联系人：</td>
						    <td class="inquire_form6"><input type="text" id="contract_person" name="contract_person" class="input_width" value="<%=(String)map.get("contractPerson") %>"/></td>
						  </tr>
						  <tr>
   						    <td class="inquire_item6"><font color="red">*</font>联系电话：</td>
						    <td class="inquire_form6"><input type="text" id="contract_phone" name="contract_phone" class="input_width" value="<%=(String)map.get("contractPhone")%>"/></td>
   						    <td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
   						    <td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
						  </tr>
					<%}else{ %>
						  <tr>
					     	<td class="inquire_item6"><font color="red">*</font>二级单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org" name="second_org" class="input_width"  value="<%=(String)map.get("secondOrg") %>"/>
					      	<input type="text" id="second_org2" name="second_org2" class="input_width"  value="<%=(String)map.get("secondOrgName") %>" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	</td>
					     	<td class="inquire_item6"><font color="red">*</font>基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org" name="third_org" class="input_width"  value="<%=(String)map.get("thirdOrg") %>" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"   value="<%=(String)map.get("thirdOrgName") %>" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>姓名：</td>
					      	<td class="inquire_form6"><input type="text" id="name" name="name" class="input_width"  value="<%=(String)map.get("name") %>"/></td>
					     </tr>
						 <tr>
					     	<td class="inquire_item6"><font color="red">*</font>性别：</td>
					      	<td class="inquire_form6">
					      		<select id="sex" name="sex" class="select_width">
						          <option value="" >请选择</option>
						          <option value="1" >男</option>
						          <option value="2" >女</option>
							    </select>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>出生年月：</td>
					      	<td class="inquire_form6"><input type="text" id="birthday" name="birthday" class="input_width"   value="<%=(String)map.get("birthday") %>" readonly="readonly"/>
					      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(birthday,tributton1);" />&nbsp;</td>
					     	<td class="inquire_item6"><font color="red">*</font>身份证号：</td>
					      	<td class="inquire_form6"><input type="text" id="card_id" name="card_id" class="input_width"  value="<%=(String)map.get("cardId") %>"/></td>
					     </tr>
					     <tr>
						    <td class="inquire_item6"><font color="red">*</font>准驾证档案编号：</td>
						    <td class="inquire_form6"><input type="text" id="file_number" name="file_number" class="input_width" value="<%=(String)map.get("fileNumber") %>"/></td>
						    <td class="inquire_item6"><font color="red">*</font>准驾车型：</td>
						    <td class="inquire_form6"><input type="text" id="car_type" name="car_type" class="input_width" value="<%=(String)map.get("carType") %>"/></td>
						  <td class="inquire_item6"><font color="red">*</font>准驾证编号：</td>
						    <td class="inquire_form6"><input type="text" id="driving_number" name="driving_number" class="input_width" value="<%=(String)map.get("drivingNumber") %>"></input></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>发证单位：</td>
						    <td class="inquire_form6"><input type="text" id="sign_org" name="sign_org" class="input_width" value="<%=(String)map.get("signOrg") %>"/></td>
						   <td class="inquire_item6"><font color="red">*</font>签发人：</td>
						    <td class="inquire_form6"><input type="text" id="signer" name="signer" class="input_width" value="<%=(String)map.get("signer") %>"/></td>
						    <td class="inquire_item6"><font color="red">*</font>签发日期：</td>
						    <td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width" value="<%=(String)map.get("signDate") %>" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton3);" />&nbsp;</td>
						  </tr>
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>有效期：</td>
						    <td class="inquire_form6"><input type="text" id="expiry_date" name="expiry_date" class="input_width" value="<%=(String)map.get("expiryDate") %>" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(expiry_date,tributton4);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>二级单位联系人：</td>
						    <td class="inquire_form6"><input type="text" id="contract_person" name="contract_person" class="input_width" value="<%=(String)map.get("contractPerson") %>"/></td>
						   <td class="inquire_item6"><font color="red">*</font>联系电话：</td>
						    <td class="inquire_form6"><input type="text" id="contract_phone" name="contract_phone" class="input_width" value="<%=(String)map.get("contractPhone")%>"/></td>
						  </tr>
					  <%} %>
					  <tr>
					  	<td class="inquire_item6">备注：</td>
					  	<td class="inquire_form6" colspan="5"><textarea id="memo" name="memo" class="textarea"><%=(String)map.get("notes") %></textarea></td>
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
document.getElementById("sex").value="<%=(String)map.get("sex") %>";
document.getElementById("duty").value = "<%=(String)map.get("duty")%>"


function submitButton(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
	form.action="<%=contextPath%>/hse/driving/addDriving.srq";
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
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("second_org").value;
    if(second==""||second==null){
    	alert("请先选择二级单位！");
    }else{
	    var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			var org_id = datas[0].org_id; 
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
		    }
		}
    }
}

function checkText(){
	var driving_type = document.getElementById("driving_type").value;
	var second_org=document.getElementById("second_org").value;
	var third_org=document.getElementById("third_org").value;
	var name=document.getElementById("name").value;
	var sex=document.getElementById("sex").value;
	var birthday=document.getElementById("birthday").value;
	var card_id=document.getElementById("card_id").value;
	var file_number=document.getElementById("file_number").value;
	var car_type = document.getElementById("car_type").value;
	var driving_number = document.getElementById("driving_number").value;
	var sign_org = document.getElementById("sign_org").value;
	var signer = document.getElementById("signer").value;
	var sign_date = document.getElementById("sign_date").value;
	var expiry_date = document.getElementById("expiry_date").value;
	var contract_person = document.getElementById("contract_person").value;
	var contract_phone = document.getElementById("contract_phone").value;
	if(second_org==""){
		alert("二级单位不能为空，请填写！");
		return true;
	}
	if(third_org==""){
		alert("基层单位不能为空，请填写！");
		return true;
	}
	if(name==""){
		alert("姓名不能为空，请填写！");
		return true;
	}
	if(sex==""){
		alert("性别不能为空，请选择！");
		return true;
	}
	if(birthday==""){
		alert("出生日期不能为空，请选择！");
		return true;
	}
	if(driving_type=="2"){
		var duty=document.getElementById("duty").value;
		if(duty==""){
			alert("人员职务不能为空，请选择！");
			return true;
		}
	}
	if(card_id==""){
		alert("身份证号不能为空，请填写！");
		return true;
	}
	if(file_number==""){
		alert("驾驶证编号不能为空，请填写！");
		return true;
	}
	if(car_type==""){
		alert("准驾车型不能为空，请选择！");
		return true;
	}
	if(driving_number==""){
		alert("准驾证编号不能为空，请填写！");
		return true;
	}
	if(sign_org==""){
		alert("发证单位不能为空，请填写！");
		return true;
	}
	if(signer==""){
		alert("签发人不能为空，请填写！");
		return true;
	}
	if(sign_date==""){
		alert("签发日期不能为空，请填写！");
		return true;
	}
	if(expiry_date==""){
		alert("有效期不能为空，请填写！");
		return true;
	}
	if(contract_person==""){
		alert("二级单位联系人不能为空，请填写！");
		return true;
	}
	if(contract_phone==""){
		alert("联系电话不能为空，请填写！");
		return true;
	}
	return false;
}

</script>
</html>