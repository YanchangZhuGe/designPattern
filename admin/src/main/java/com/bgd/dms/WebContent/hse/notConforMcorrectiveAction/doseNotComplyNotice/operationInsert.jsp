<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.mcs.service.hse.service.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());
String projectInfoNo = user.getProjectInfoNo();
if (projectInfoNo == null || projectInfoNo.equals("")){
	projectInfoNo = "";
}
//处理主表信息
ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
  
HseOperation applyInfo = new HseOperation();
if(resultMsg!=null && resultMsg.getMsgElement("applyInfo") != null){
	applyInfo=(HseOperation) resultMsg.getMsgElement("applyInfo").toPojo(HseOperation.class);
	
}
 
//  List<MsgElement>trainInfo = new ArrayList<MsgElement>(0);
//  if(resultMsg!=null && resultMsg.getMsgElements("trainInfo") != null){
  //	trainInfo = resultMsg.getMsgElements("trainInfo");
 // }  
 
List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
List<HseOperationDetail> beanList=new ArrayList<HseOperationDetail>(0);
if(list!=null){
	beanList = new ArrayList<HseOperationDetail>(list.size());	
	for (int i = 0; i < list.size(); i++) {
		beanList.add((HseOperationDetail) list.get(i).toPojo(
				HseOperationDetail.class));
	}
}

%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
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
		alert("请添加一条不符合描述信息后再点击保存");
		return ;
	}
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/hse/notConforMcorrective/save.srq";
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
			if(!notNullForCheck("fy"+i+"noConformity","不符合描述")) return false;
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
 

 

function checkNaN(numids){

	 var str = document.getElementById(numids).value;
 
	 if(str!=""){		 
		if(isNaN(str)){
			alert("请输入数字");
			document.getElementById(numids).value="";
			return false;
		}else{
			return true;
		}
	  }

}

function toUploadFile(){
	var obj=window.showModalDialog('<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotComplyNotice/humanImportFile.jsp',"","dialogHeight:500px;dialogWidth:600px");
	 
	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){ 
			var check = checkStr[i].split("@");   
			addDevice1("","0",check[0],check[1],check[2],check[3]);
			
		}
		
	}

}
 

//加一行人员
function addDevice1(orderDetailNos,bsflags,noConformitys,noConformNums,suggestionss,periods){
	 
	var orderDetailNo="";
	var noConformity="";
	var noConformNum="";
	var suggestions="";
	var period="";
	var bsflag="";
	
	if(orderDetailNos != null && orderDetailNos != ""){
		orderDetailNo =orderDetailNos;
	}	
	if(noConformitys != null && noConformitys != ""){
		noConformity =noConformitys;
	}
	if(noConformNums != null && noConformNums != ""){
		noConformNum =noConformNums;
	}
	if(suggestionss != null && suggestionss != ""){
		suggestions =suggestionss;
	}
	if(periods != null && periods != ""){
		period =periods;
	}
 
  //添加tr
	var tr = document.getElementById("equipmentTableInfo").insertRow();

	tr.align ="center";
	tr.id = "fy"+deviceCount+"trflag";

  	if(deviceCount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
  //需求子表id,为空orderDetailNo,noConformity,noConformNum,suggestions,period
 	tr.insertCell().innerHTML  =currentCount+1+'<input type="hidden" id="fy'+deviceCount+'orderDetailNo" name="fy'+deviceCount+'orderDetailNo" value="'+orderDetailNo+'"/><input type="hidden" id="fy'+deviceCount+'bsflag" name="fy'+deviceCount+'bsflag" value="0"/>';

 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'noConformity" style="width:150px;" name="fy'+deviceCount+'noConformity"  value="'+noConformity+'" class="input_width" />';	
	//请选择 
 	tr.insertCell().innerHTML =  '<input type="text" maxlength="32" id="fy'+deviceCount+'noConformNum"  style="width:150px;"  name="fy'+deviceCount+'noConformNum"  value="'+noConformNum+'" class="input_width" />';	
 	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'suggestions" style="width:150px;"  name="fy'+deviceCount+'suggestions"  value="'+suggestions+'" class="input_width" />';	
	//请选择
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'period" style="width:150px;"  name="fy'+deviceCount+'period"   value="'+period+'" class="input_width" readonly="true" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1' + deviceCount + '" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(fy'+deviceCount+'period,tributton1' + deviceCount + ');" />';
 	tr.insertCell().innerHTML = '<input type="text" maxlength="22" id="fy'+deviceCount+'spare1" style="width:150px;"  name="fy'+deviceCount+'spare1"  readonly="true"  value="未关闭" class="input_width" />';	
	tr.insertCell().innerHTML= '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice('+deviceCount+')"/>';

	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;

}
 
function deleteDevice(deviceNum){
 
	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("fy"+deviceNum+"orderDetailNo").value;
 
	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
		//删除子表信息
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		var submitStr='JCDP_TABLE_NAME=BGP_HSE_ORDER_DETAIL&JCDP_TABLE_ID='+rowDeleteId+'&bsflag=1';
		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));
		deleteChangeInfoNum2('orderDetailNo')
	}	

	var rowDevice = document.getElementById("fy"+deviceNum+"trflag"); 
 	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;

	//删除后重新排列序号
	deleteChangeInfoNum('orderDetailNo');

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
		 
			 document.getElementById("fy"+warehouseDetailId+"bsflag").value="1"; 
		 
			
			num+=1;
		}
	}	
}

function deleteChangeInfoNum2(warehouseDetailId){
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
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var auditUnit = document.getElementById("auditUnit").value;
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	 document.getElementById("auditUnit").value = teamInfo.fkValue;
        document.getElementById("orgName").value = teamInfo.value;
       
    }
}
 

function toDownload(){
	var elemIF = document.createElement("iframe");  
 
	var iName ="不符合通知单模板";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	
	elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/hse/notConforMcorrectiveAction/doseNotComplyNotice/ImpleOperation.xlsx&filename="+iName+".xlsx";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

</script>
<title>人员培训计划添加</title>
</head>
<body  > 
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr  >
	<td  align="center" colspan="5"><font color=black size="4px">不符合通知单</font></td>
	</tr>
	<tr   >
	<td  align="right"><font color=red></font>&nbsp;被检查/审核单位：</td>
	<td >
	<input type="hidden" id="orderNo" name="orderNo" value="<%=applyInfo.getOrderNo()==null?"":applyInfo.getOrderNo()%>"/>
	<input type="hidden" id="projectNo" name="projectNo" value="<%=applyInfo.getProjectNo()==null?projectInfoNo:applyInfo.getProjectNo()%>"/>
	<input type="hidden"     id="auditUnit" value="<%=applyInfo.getAuditUnit()==null?"":applyInfo.getAuditUnit()%>"  name="auditUnit" class='input_width' readonly="readonly"></input>	
	<input type="text"    id="orgName"   value="<%=applyInfo.getOrgName()==null?"":applyInfo.getOrgName()%>"    name="orgName" class='input_width' readonly="readonly"></input>	
	  <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	</td>
	<td  align="right"> 检查/审核日期：</td> 
	<td > <input type="text" id="auditDate" name="auditDate" class="input_width"   value="<%=applyInfo.getAuditDate()==null?"":applyInfo.getAuditDate()%>"    readonly="readonly"/>
    <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(auditDate,tributton1);" />&nbsp;</td>	
    </tr>


	<tr  >
	  <td height="21" colspan="4" >  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 请你单位对以下存在的不符合，逐条进行原因分析，制定纠正措施和预防措施，并将原因分析、纠正和预防措施、 验证结果同本通知单于：	   </td>
    </tr>
	<tr   >
	  <td colspan="4"  >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<input type="text" id="amonth" name="amonth" style="width:50px;"  value="<%=applyInfo.getAmonth()==null?"":applyInfo.getAmonth()%>"  />月
	    <input type="text" id="aday" name="aday" value="<%=applyInfo.getAday()==null?"":applyInfo.getAday()%>"  style="width:50px;"/>
	    日前报
        <input type="text" id="reporter" name="reporter" value="<%=applyInfo.getReporter()==null?"":applyInfo.getReporter()%>"    style="width:250px;" />
        。以上问题委托 
        <input type="text" id="client" name="client" value="<%=applyInfo.getClient()==null?"":applyInfo.getClient()%>"   style="width:250px;" />
      进行跟踪验证。</td>
    </tr>
	<tr  align="right" >
	  <td height="21" >验证情况：</td>
	  <td colspan="3"  ><input type="text" id="validationSituation" name="validationSituation"  value="<%=applyInfo.getValidationSituation()==null?"":applyInfo.getValidationSituation()%>"  class="input_width" style="width:800px;" /></td>
    </tr>
	
	<tr   >
 
	<td align="right" ><font color=red></font>&nbsp;验证人：</td>
	<td ><input type="text" id="verifierSignature" name="verifierSignature" value="<%=applyInfo.getVerifierSignature()==null?"":applyInfo.getVerifierSignature()%>" /></td>
 
 	<td  align="right"> 验证日期：</td> 
	<td > <input type="text" id="verifyDate" name="verifyDate" class="input_width"  value="<%=applyInfo.getVerifyDate()==null?"":applyInfo.getVerifyDate()%>"  readonly="readonly"/>
    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(verifyDate,tributton2);" />&nbsp;</td>	
    </tr>
	<tr  >
	
		<td align="right" ><font color=red></font>&nbsp;审核/检查组成员：</td>
		<td >
		<input type="TEXT" id="inspectionTeam" name="inspectionTeam" value="<%=applyInfo.getInspectionTeam()==null?"":applyInfo.getInspectionTeam()%>"  class='input_width'/>		</td>
		<td align="right" >被检查/审核单位负责人：</td> 
		<td >
		<input type="TEXT" value="<%=applyInfo.getPersonCharge()==null?"":applyInfo.getPersonCharge()%>"   id="personCharge" name="personCharge" class='input_width' ></input>		</td>	
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a  href="javascript:toDownload()">下载不符合通知单模板</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</td>

  <td> 
  <auth:ListButton functionId="" css="dr" event="onclick='toUploadFile()'" title="快速导入"></auth:ListButton>
  <auth:ListButton functionId="" css="zj" event="onclick='addDevice1()'" title="JCDP_btn_add"></auth:ListButton>
    </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>
 
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="equipmentTableInfo">
	<tr  > 
	    <TD  class="bt_info_even"  width="5%">序号</TD>
		<TD  class="bt_info_odd" width="15%" >不符合描述</TD>
		<TD  class="bt_info_even" width="15%" >不符合条款号</TD>
		<TD  class="bt_info_odd"  width="15%">整改建议/要求</TD>
		<TD class="bt_info_even"  width="15%">整改期限</TD>		 
		<TD  class="bt_info_odd"  width="15%">关闭情况</TD>
		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="<%=beanList.size()%>" />
		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
 
		</TD>
		<TD class="bt_info_even" width="3%">操作</TD>
	</tr>
		 <%
			for (int i = 0; i < beanList.size(); i++) {
				String className = "";
				if (i % 2 == 1) {
					className = "odd";
				} else {
					className = "even";
				} 
				HseOperationDetail applyDetailInfo = beanList.get(i);
				String ss="fy"+String.valueOf(i)+"deviceUnit";
		  %>
			<tr class="<%=className%>" id="fy<%=i%>trflag" > 
			<td><%=i+1 %><input type="hidden" name="fy<%=i%>orderDetailNo" id="fy<%=i%>orderDetailNo" value="<%=applyDetailInfo.getOrderDetailNo()==null?"":applyDetailInfo.getOrderDetailNo()%>"/>
			<input type="hidden" name="fy<%=i%>bsflag" id="fy<%=i%>bsflag" value=""/></td>		 
			<td><input type="text" class="input_width" style="width:150px;"  id="fy<%=i%>noConformity" name="fy<%=i%>noConformity" value="<%=applyDetailInfo.getNoConformity()==null?"":applyDetailInfo.getNoConformity()%>"  />&nbsp;
			</td>		 		 
			<td><input type="text" class="input_width" style="width:150px;"   id="fy<%=i%>noConformNum" name="fy<%=i%>noConformNum"    value="<%=applyDetailInfo.getNoConformNum()==null?"":applyDetailInfo.getNoConformNum()%>"  />&nbsp;
			</td> 
			<td><input type="text"class="input_width" style="width:150px;"   name="fy<%=i%>suggestions" id="fy<%=i%>suggestions" value="<%=applyDetailInfo.getSuggestions()==null?"":applyDetailInfo.getSuggestions()%>"    />&nbsp;</td>
			<td><input type="text" class="input_width" style="width:150px;"  name="fy<%=i%>period" id="fy<%=i%>period"       value="<%=applyDetailInfo.getPeriod()==null?"":applyDetailInfo.getPeriod()%>" />
			 <img src="<%=contextPath%>/images/calendar.gif" id="tributton1<%=i%>" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(fy<%=i%>period,tributton1<%=i%>);" />
			&nbsp;</td>
			<td><input type="text" class="input_width" style="width:150px;"  readonly="true" id="fy<%=i%>spare1" name="fy<%=i%>spare1"    value="<%=applyDetailInfo.getSpare1()==null?"未关闭":applyDetailInfo.getSpare1()%>"  />&nbsp;
			</td>
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
  <span  class="tj_btn"><a href="#" onclick="sucess(); "></a></span>
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