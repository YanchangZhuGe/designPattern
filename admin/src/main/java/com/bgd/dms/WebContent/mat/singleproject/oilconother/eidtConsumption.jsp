<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form" id="form" method="post" action="">
<input type='hidden' name='teammat_out_id' id='teammat_out_id' value='<gms:msg msgTag="matInfo" key="teammat_out_id"/>'/>
<input type="hidden" id="out_type" name="out_type" class="input_width"  value="4"/>
<input type="hidden" id="wz_type" name="wz_type" value=""></input>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%;overflow: hidden;">
      <fieldSet style="margin-left:2px"><legend>基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
               <tr>
			<td class="inquire_item4">分包商:</td>
		 	<td class="inquire_form4">
		      	<input type="text" id="drawer" name="drawer" class="input_width"  value="<gms:msg msgTag="matInfo" key="drawer"/>"/>
			</td>
			</td>
       		<td class="inquire_item4"><font color="red">*</font>油料来源:</td>
		 	<td class="inquire_form4">
				<select id="oil_from" name="oil_from" class="select_width">
		 		<option value=''>请选择</option>
		 		<option value='0'>油库</option>
		 		<option value='1'>加油站</option>
		 		</select>
			</td>
        </tr>
        <tr>
			<td class="inquire_item4"><font color="red">*</font>使用班组:</td>
		 	<td class="inquire_form4">
		 		<select id="team_id" name="team_id"  class="select_width">
				</select>
		 	</td>
       		<td class="inquire_item4"><font color="red">*</font>油料用途:</td>
		 	<td class="inquire_form4">
				<select id="use_user" name="use_user" class="select_width">
				</select>
			</td>
        </tr>
        <tr>
       	   <td class="inquire_item4"><font color="red">*</font>油品名称:</td>
		 	<td class="inquire_form4">
		 		<select id='oil_type' name='oil_type' class='select_width' style="width: 30%;" onchange="selectOilType()">
				        <option value='1'>车用汽油</option>
				 		<option value='2'>轻柴油</option>
				</select>
		 		<select id="wz_id" name="wz_id" class="select_width" style="width: 50%;" onchange="ifOilNum()">
<!-- 		 		<option value=''>请选择</option>
		 		<option value='11000051822'>车用汽油 90#</option>
		 		<option value='10001037161'>车用汽油 92#</option>
		 		<option value='11004534305'>车用汽油 93#</option>
		 		<option value='10000189078'>车用汽油 95#</option>
		 		<option value='11000062340'>车用汽油 97#</option>
		 		<option value='11003426794'>轻柴油 0# 多元</option>
		 		<option value='11003308799'>轻柴油 RC-0℃</option>
		 		<option value='11003308800'>轻柴油 RC-10℃</option>
		 		<option value='11003308801'>轻柴油 RC-20℃</option>
		 		<option value='11003308804'>轻柴油 RC-30℃</option>
		 		<option value='11003308802'>轻柴油 RC-35℃</option>
		 		<option value='11003308803'>轻柴油 RC-50℃</option>
		 		<option value='11003308805'>轻柴油 RC+5</option>
 -->		 		
		 		</select>
		 	</td>
       		<td class="inquire_item6"><font color="red">*</font>加油时间:</td>
		<td class="inquire_item6"><input type="text" name="outmat_date" id="outmat_date"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="outmat_date"/>"  />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(outmat_date,tributton1);" />
			</td>
        </tr>
         <tr>
       	   	<td class="inquire_item4"><font color="red">*</font>油品单价(升):</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="actual_price" name="actual_price" class="input_width" onblur="changevalue()"  value="<gms:msg msgTag="matInfo" key="actual_price"/>"/>
		 	</td>
<!-- 		<td class="inquire_item4">油品单位:</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="wz_priceik" name="wz_priceik" class="input_width"  value="升" readonly/>
			</td>
 -->       			
         	<td class="inquire_item4"><font color="red">*</font>使用数量(升):</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="oil_num" name="oil_num" class="input_width"  value="<gms:msg msgTag="matInfo" key="oil_num"/>" onblur="changevalue()" readonly="readonly"/>
			</td>
        </tr>
         <tr>
       	   	<td class="inquire_item4">使用数量(吨):</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="mat_num" name="mat_num" class="input_width"  value="<gms:msg msgTag="matInfo" key="mat_num"/>" readonly/>
		 	</td>
       		<td class="inquire_item4">消耗金额:</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="total_money" name="total_money" class="input_width"  value="<gms:msg msgTag="matInfo" key="total_money"/>"/>
			</td>
        </tr>
      </table>
      </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="bc_btn" ><a id="subButton" href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
function submitInfo(){
	if(checkText()){
		return;
	}
	//判断是否油库，油库wz_type=0
	var oil_from = document.getElementById("oil_from").value;
	if(oil_from=="0"){
		document.getElementById("wz_type").value="0";
	}
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/mat/singleproject/oilconother/eidtConsumption.srq";
	form.submit();
}

function checkText(){
	
	var re = /^[0-9]+(.[0-9]{1,4})?$/;
	var wz_id=document.getElementById("wz_id").value;
	var team_id=document.getElementById("team_id").value;
	var use_user=document.getElementById("use_user").value;
	var mat_num=document.getElementById("mat_num").value;
	var actual_price=document.getElementById("actual_price").value;
	var oil_from=document.getElementById("oil_from").value;
	var outmat_date = document.getElementById("outmat_date").value;
	var use_user = document.getElementById("use_user").value;
	if(oil_from==""){
		alert("油料来源不能为空！");
		return true;
	}
	if(team_id==""){
		alert("班组不能为空！");
		return true;
	}
	if(use_user==""){
		alert("油料用途不能为空！");
		return true;
	}
	if(wz_id==""){
		alert("油品名称不能为空！");
		return true;
	}
	if(outmat_date==""){
		alert("加油时间不能为空！");
		return true;
	}
	if(actual_price==""){
		alert("单价不能为空！");
		return true;
	}
	if(!re.test(actual_price)){
		alert("单价必须为数字，且大于0，小数位不能超过4位！");
		return true;
	}
	if(mat_num==""){
		alert("使用数量不能为空！");
		return true;
	}
	if(!re.test(mat_num)){
		alert("使用数量必须为数字，且大于0,小数位不能超过4位！");
		return true;
	}
	return false;
}
function refreshData(){
	var oil_type = "<gms:msg msgTag="matInfo" key="coding_code_id"/>";
	if(oil_type=="07030102"){  
		document.getElementById("oil_type").value = "1";
	}else if(oil_type=="07030301"){
		document.getElementById("oil_type").value = "2";
	}
	selectOilType();
	
	document.getElementById("wz_id").value = "<gms:msg msgTag="matInfo" key="wz_id"/>";
	document.getElementById("oil_from").value = "<gms:msg msgTag="matInfo" key="oil_from"/>";
	var obj = "<gms:msg msgTag="matInfo" key="team_id"/>";
	var val = "<gms:msg msgTag="matInfo" key="drawer"/>";
	var use = "<gms:msg msgTag="matInfo" key="use_user"/>";
    getApplyTeam(obj);
    getConUse(use);
    ifOilNum();
    showOilNum("<gms:msg msgTag="matInfo" key="oil_from"/>");
}
function getConUse(use){
	
	var selectObj = document.getElementById("use_user"); 
	document.getElementById("use_user").innerHTML="";
	
	var retObj=jcdpCallService("MatItemSrv","queryConUse","");	
	var taskList = retObj.matInfo;
	for(var i =0; taskList!=null && i < taskList.length; i++){
 		selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
	}
	selectObj.value = use;
	}
function getApplyTeam(obj){
	var selectObj = document.getElementById("team_id"); 
 	document.getElementById("team_id").innerHTML="";

// 	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
 	for(var i=0;i<applyTeamList.detailInfo.length;i++){
 		var templateMap = applyTeamList.detailInfo[i];
 		if(templateMap.value == obj){
				selectObj.add(new Option(templateMap.label,templateMap.value),0);
				}
 		else{
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
 		}
 	}   	
 	selectObj.options[0].selected='selected';
 }
function changevalue(){
	var wzId = document.getElementById("wz_id").value;
	var oil_price = document.getElementById("actual_price").value;
	var oil_num = document.getElementById("oil_num").value;
	var oil_type = document.getElementById("oil_type").value;
	var mat_num=0;
	if(oil_num ==""){
		oil_num = 0;
		}
	if(oil_price ==""){
		oil_price = 0;
		}
	if(wzId == ""){
		mat_num=0;
		}
	else if(oil_type=="1"){
		mat_num=Math.round((oil_num*0.75/1000)*10000)/10000;
	}
	else{
		mat_num=Math.round((oil_num*0.86/1000)*10000)/10000;
	}
	document.getElementById("mat_num").value=mat_num;
	
	document.getElementById("total_money").value = Math.round((oil_num*oil_price)*1000)/1000;
}

function ifOilNum(){
	var wz_id = document.getElementById("wz_id").value;
	if(wz_id!=null&&wz_id!=""){
		document.getElementById("oil_num").readOnly = false;
	}else{
		document.getElementById("oil_num").readOnly = true;
	}
}
function selectOilType(){
	var oil_type = document.getElementById("oil_type").value;
	debugger;
	document.getElementById("wz_id").innerHTML = "";
	var retObj=jcdpCallService("MatItemSrv","selectOilType","oil_type="+oil_type);
	if(retObj.list!=null){
		for (var i = 0; i< retObj.list.length; i++) {
			document.getElementById("wz_id").options.add(new Option(retObj.list[i].wzName,retObj.list[i].wzId)); 
		}
	}
}
</script>
</html>

