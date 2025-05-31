<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());

//处理主表信息
ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
  
BgpHumanPlanDetail detailInfo = 
		(BgpHumanPlanDetail) resultMsg.getMsgElement("detailInfo").toPojo(BgpHumanPlanDetail.class);
	
  // Map sumAll =(Map)resultMsg.getMsgElement("sumAll").toMap();

 
List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
List<BgpHumanPlanDetail> beanList=new ArrayList<BgpHumanPlanDetail>(0);
if(list!=null){
	beanList = new ArrayList<BgpHumanPlanDetail>(list.size());	
	for (int i = 0; i < list.size(); i++) {
		beanList.add((BgpHumanPlanDetail) list.get(i).toPojo(
				BgpHumanPlanDetail.class));
	}
}

%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

var currentCount=parseInt('0');
var deviceCount = parseInt('0');
 
 
 
function sucess() {

	if(currentCount==0){
		alert("请添加一条培训信息后再点击保存");
		return ;
	}
	if(checkForm()){
		var form = document.getElementById("CheckForm");
 
		form.action = "<%=contextPath%>/rm/em/toSaveHumanPlan.srq";
		form.submit();
		alert('保存成功');
		newClose();
	}
}

function checkForm(){	

	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck=rowFlag.split(",");
	for(var i=0;i<deviceCount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i) isCheck =false;
		}
		if(isCheck){
			if(!notNullForCheck("fy"+i+"trainContent","培训内容")) return false;
 
		
		}
		//var projectEvaluate = document.getElementById("fy"+i+"projectEvaluate").value;
	//	var sprojectEvaluate = encodeURI(encodeURI(projectEvaluate));
		//alert(sprojectEvaluate);
	}

 

	return true;
	
}
 

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}
function isNumberForCheck(filedName,fieldInfo){
	var valNumber = document.getElementById(filedName).value;
	var re=/^[1-9]+[0-9]*]*$/;
	if(valNumber!=null&&valNumber!=""){
		if(!re.test(valNumber)){
			alert(fieldInfo+"格式不正确,请重新输入");
			return false;
		}else{
			return true;
		}
	}else{
		return true;
	}
}

var currentCount=parseInt('0');
var deviceCount = parseInt('0');
var listSize =parseInt('<%=beanList.size()%>');  
deviceCount=deviceCount+listSize;
currentCount=currentCount+listSize;
 

 
 
//加一行人员
function addDevice1(){
  
  //添加tr
	var tr = document.getElementById("equipmentTableInfo").insertRow();

	tr.align ="center";
	tr.id = "fy"+deviceCount+"trflag";

  	if(deviceCount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
  //需求子表id,为空
 	tr.insertCell().innerHTML  =currentCount+1+'<input type="hidden" id="fy'+deviceCount+'trainDetailNo" name="fy'+deviceCount+'trainDetailNo" value=""/>';

 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainContent" name="fy'+deviceCount+'trainContent"  value="" class="input_width" />';	
	//请选择
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainNumber" name="fy'+deviceCount+'trainNumber"  value="" class="input_width" />';	
	//请选择
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainClass" name="fy'+deviceCount+'trainClass"  onblur="allNumber();"  value="" class="input_width" />';
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainCost"  onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainCost"  value="" class="input_width" />';	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainTransportation"  onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainTransportation"  value="" class="input_width" />';	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainMaterials"  onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainMaterials"  value="" class="input_width" />';	
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainPlaces"  onblur="calculateCost('+deviceCount+');allNumber();" name="fy'+deviceCount+'trainPlaces"  value="" class="input_width" />';
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainAccommodation" onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainAccommodation"  value="" class="input_width" />';	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainOther" onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainOther"  value="" class="input_width" />';	
  
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainTotal"  readonly="readonly"  name="fy'+deviceCount+'trainTotal"  value="" class="input_width" />';	
 
	tr.insertCell().innerHTML= '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice(' +deviceCount + ')"/>';

	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;
	
	
	
	
	

}
 
function deleteDevice(deviceNum){

	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("fy"+deviceNum+"trainDetailNo").value;
 
	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
	}	

	var rowDevice = document.getElementById("fy"+deviceNum+"trflag"); 
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;

	//删除后重新排列序号
	deleteChangeInfoNum('trainDetailNo');

}
function deleteChangeInfoNum(warehouseDetailId){
	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck=rowFlag.split(",");
	var num=1;
	for(var i=0;i<deviceCount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
			document.getElementById("fy"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("fy"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}	
}


 
</script>
<title>人员培训记录添加</title>
</head>
<body  > 
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info" id="equipmentTableInfo">
<tr  >
 <td  align="center" colspan="10"><font color=black size="4px">教学内容及费用</font></td>
 </tr>
<tr  > 
	<TD  class="bt_info_even" width="45%" >培训内容</TD>
	<TD  class="bt_info_odd"  width="5%">人数</TD>
	<TD class="bt_info_even"  width="5%">学时</TD>
	<TD  class="bt_info_odd"   width="5%"><font color=black>授课费</font></TD>
	<TD class="bt_info_even"  width="5%"><font color=black>交通费</font> </TD>
	<TD  class="bt_info_odd"  width="5%"><font color=black>材料费</font></TD>
	<TD class="bt_info_even"   width="5%"><font color=black>场地费 </font></TD>
	<TD class="bt_info_odd" width="5%"><font color=black>食宿费 </font></TD>
	<TD class="bt_info_even"  width="5%" ><font color=black>其他费用</font> </TD>
	<TD class="bt_info_odd"  width="7%" ><font color=black>费用合计（元）</font> </TD>
	<input type="hidden" id="equipmentSize" name="equipmentSize"   value="<%=beanList.size()%>" />
	<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
	<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
	</TD>
 </tr>
	 	<tr class="odd" id="trflag"  >
		<td><input type="hidden" name="trainDetailNo" id="trainDetailNo" value="<%=detailInfo.getTrainDetailNo()==null?"":detailInfo.getTrainDetailNo()%>"/> 
		 <input type="text" class="input_width" style="width:490px;" id="trainContent" name="trainContent" value="<%=detailInfo.getTrainContent()==null?"":detailInfo.getTrainContent()%>"   />&nbsp;
		</td>
		<td><input type="text" class="input_width"  style="width:40px;"id="trainNumber" name="trainNumber"     value="<%=detailInfo.getTrainNumber()==null?"":detailInfo.getTrainNumber()%>"  />&nbsp;
		</td> 
		<td><input type="text"class="input_width" style="width:40px;" name="trainClass" id="trainClass"    value="<%=detailInfo.getTrainClass()==null?"":detailInfo.getTrainClass()%>"    />&nbsp;</td>
		<td><input type="text" class="input_width" style="width:40px;" name="trainCost"   id="trainCost"       value="<%=detailInfo.getTrainCost()==null?"":detailInfo.getTrainCost()%>" />&nbsp;</td>
		<td><input type="text" class="input_width" style="width:40px;" name="trainTransportation"   id="trainTransportation"      value="<%=detailInfo.getTrainTransportation()==null?"":detailInfo.getTrainTransportation()%>" />&nbsp;</td>
		<td><input type="text" class="input_width"  style="width:40px;" name="trainMaterials"   id="trainMaterials"     value="<%=detailInfo.getTrainMaterials()==null?"":detailInfo.getTrainMaterials()%>"    />&nbsp;</td>
		<td><input type="text" class="input_width"  style="width:40px;" name="trainPlaces"   id="trainPlaces"      value="<%=detailInfo.getTrainPlaces()==null?"":detailInfo.getTrainPlaces()%>" />&nbsp;</td>
		<td><input type="text" class="input_width"  style="width:40px;" name="trainAccommodation"   id="trainAccommodation"       value="<%=detailInfo.getTrainAccommodation()==null?"":detailInfo.getTrainAccommodation()%>" />&nbsp;</td>
		 <td><input type="text" class="input_width"  style="width:40px;" name="trainOther"   id="trainOther"     value="<%=detailInfo.getTrainOther()==null?"":detailInfo.getTrainOther()%>" />&nbsp;</td>
		<td><input type="text"  class="input_width" style="width:80px;" name="trainTotal" readonly="readonly" id="trainTotal"      value="<%=detailInfo.getTrainTotal()==null?"":detailInfo.getTrainTotal()%>" />&nbsp;</td>
	 
		</tr>	
	  
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td></td>
  <td><span class="zj"  ><a href="#" onclick="addDevice1()"></a></span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

  <td> </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>
 
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info" width="100%" id="equipmentTableInfo">
	<tr  > 
	    <TD  class="bt_info_odd"   width="5%" >序号</TD>
		<TD  class="bt_info_even"   width="25%" ><font color=red>姓名</font></TD>
		<TD  class="bt_info_odd"  width="10%" ><font color=red>用工类别</font></TD>
		<TD  class="bt_info_odd"  width="5%" ><font color=red></font></TD>
		<TD  class="bt_info_even"  width="25%"  ><font color=red>培训时间</font></TD>
		<TD class="bt_info_odd"  width="20%"  ><font color=red>考核结果</font></TD>
		 <input type="hidden" id="equipmentSize" name="equipmentSize"   value="<%=beanList.size()%>" />
		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
 
		</TD>
		<TD class="bt_info_even" width="5%"  >操作</TD>
	</tr>
		 <%
			for (int i = 0; i < beanList.size(); i++) {
				String className = "";
				if (i % 2 == 1) {
					className = "odd";
				} else {
					className = "even";
				} 
				BgpHumanPlanDetail applyDetailInfo = beanList.get(i);
				String ss="fy"+String.valueOf(i)+"deviceUnit";
		  %>
			<tr class="<%=className%>" id="fy<%=i%>trflag"  >
			
			<td><%=i+1 %><input type="hidden" name="fy<%=i%>trainDetailNo" id="fy<%=i%>trainDetailNo" value="<%=applyDetailInfo.getTrainDetailNo()==null?"":applyDetailInfo.getTrainDetailNo()%>"/></td>
			<td><input type="text" class="input_width" id="fy<%=i%>trainContent" name="fy<%=i%>trainContent" value="<%=applyDetailInfo.getTrainContent()==null?"":applyDetailInfo.getTrainContent()%>"   />&nbsp;
			</td>
			<td><input type="text" class="input_width" id="fy<%=i%>trainNumber" name="fy<%=i%>trainNumber"     value="<%=applyDetailInfo.getTrainNumber()==null?"":applyDetailInfo.getTrainNumber()%>"  />&nbsp;
			</td> 
			<td><input type="text"class="input_width"  name="fy<%=i%>trainClass" id="fy<%=i%>trainClass"  onblur="allNumber();"  value="<%=applyDetailInfo.getTrainClass()==null?"":applyDetailInfo.getTrainClass()%>"    />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainCost"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainCost"       value="<%=applyDetailInfo.getTrainCost()==null?"":applyDetailInfo.getTrainCost()%>" />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainTransportation"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainTransportation"      value="<%=applyDetailInfo.getTrainTransportation()==null?"":applyDetailInfo.getTrainTransportation()%>" />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainMaterials"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainMaterials"     value="<%=applyDetailInfo.getTrainMaterials()==null?"":applyDetailInfo.getTrainMaterials()%>"    />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainPlaces"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainPlaces"      value="<%=applyDetailInfo.getTrainPlaces()==null?"":applyDetailInfo.getTrainPlaces()%>" />&nbsp;</td>
			<td><input type="text" class="input_width"  name="fy<%=i%>trainAccommodation"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainAccommodation"       value="<%=applyDetailInfo.getTrainAccommodation()==null?"":applyDetailInfo.getTrainAccommodation()%>" />&nbsp;</td>
			 <td><input type="text" class="input_width" name="fy<%=i%>trainOther"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainOther"     value="<%=applyDetailInfo.getTrainOther()==null?"":applyDetailInfo.getTrainOther()%>" />&nbsp;</td>
			<td><input type="text"  class="input_width" name="fy<%=i%>trainTotal" readonly="readonly" id="fy<%=i%>trainTotal"      value="<%=applyDetailInfo.getTrainTotal()==null?"":applyDetailInfo.getTrainTotal()%>" />&nbsp;</td>
			<td ><input type="hidden" name="order" value=""/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice('<%=i%>')"/></td>
		 
			</tr>	
		  <%
			}
		  %>
		 
</table>	 
 
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
 
  <td  >
  <span  class="bc_btn"><a href="#" onclick="sucess(); "></a></span>
  <span class="gb_btn"><a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form>
</body>
</html>