<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());
 
 
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
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
cruConfig.contextPath='<%=contextPath%>';
cruConfig.cdtType = 'form';
var currentCount=parseInt('0');
var deviceCount = parseInt('0');
 
function sucess11(){ 
	var deviceCount = document.getElementById("equipmentSize").value;
	alert(deviceCount);
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"check").checked == true){
			isCheck=false;
		}
	}
	if(isCheck){
		alert("请选择一条记录");
		return false;
	}else{
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('保存成功');
		newClose();
		return true;
	}
	
 
}

 
function sucess(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('保存成功');
		newClose();
	}
}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"check").checked == true){
			isCheck=false;
		}
	}
	if(isCheck){
		alert("请选择一条记录");
		return false;
	}else{
		return true;
	}
	

}
	
function pageInit(){ 
	//通过查询结果动态填充使用情况select;
	var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000007' and bsflag='0'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	usingdatas = queryRet.datas; 
	var testOption=document.getElementById("use_situation");
	testOption.add(new Option('请选择',""),0);
	
	if(usingdatas != null){
		for (var i = 0; i< queryRet.datas.length; i++) {
			document.getElementById("use_situation").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
		}
	}
	//技术状况默认完好
	//document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
	document.getElementById("technical_conditions").options.add(new Option("请选择",""));
}

/**
 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
 */
function selectUse(){
	document.getElementById("technical_conditions").options.length=0;
	if(document.getElementById("use_situation").value=='0110000007000000001' || document.getElementById("use_situation").value=='0110000007000000002')
	{
		document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
	}
	else{
		document.getElementById("technical_conditions").options.add(new Option("待报废","0110000006000000005"));
		document.getElementById("technical_conditions").options.add(new Option("待修","0110000006000000006"));
		document.getElementById("technical_conditions").options.add(new Option("在修","0110000006000000007"));
		document.getElementById("technical_conditions").options.add(new Option("验收","0110000006000000013"));
	}
}

/**
 * 选择设备树
**/
function showDevTreePageS(){
	//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
	var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp","test","");
	var strs= new Array(); //定义一数组
	strs=returnValue.split("~"); //字符分割
	var names = strs[0].split(":");
	var name = names[1].split("(")[0];
	var model = names[1].split("(")[1].split(")")[0];
	//alert(returnValue);
	document.getElementById("facilities_name").value = name;
	document.getElementById("specifications").value = model; 
}
 

function showDevTreePage(){
	//window.open("/gms3/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
	var returnValue=window.showModalDialog("/gms3/rm/dm/tree/selectDeviceTreeForSubNode.jsp","test","");
	var strs= new Array(); //定义一数组
	strs=returnValue.split("~"); //字符分割
	var names = strs[0].split(":");
	var name = names[1].split("(")[0];
	var model = names[1].split("(")[1].split(")")[0];
	//alert(returnValue);
	document.getElementById("facilities_name").value = name;
	document.getElementById("specifications").value = model; 
}
 


function getEquipmentOne(){
	var selectObj = document.getElementById("e_one"); 
	document.getElementById("e_one").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

	var queryEquipmentOne=jcdpCallService("HseOperationSrv","queryeQuipmentOne","");	
 
	for(var i=0;i<queryEquipmentOne.detailInfo.length;i++){
		var templateMap = queryEquipmentOne.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("e_two");
	document.getElementById("e_two").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

function getEquipmentTwo(){
    var EquipmentOne = "equipmentOne="+document.getElementById("e_one").value;   
	var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);	

	var selectObj = document.getElementById("e_two");
	document.getElementById("e_two").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(EquipmentTwo.detailInfo!=null){
		for(var i=0;i<EquipmentTwo.detailInfo.length;i++){
			var templateMap = EquipmentTwo.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
	}
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

 
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
        document.getElementById("org_name").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("org_sub_id").value;
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
		    	 document.getElementById("second_org").value = teamInfo.fkValue; 
		        document.getElementById("second_org_name").value = teamInfo.value;
			}
   
}

 
function clearQueryText(){
	 document.getElementsByName("org_sub_id")[0].value="";
	 document.getElementsByName("org_name")[0].value="";
	 document.getElementsByName("second_org")[0].value="";	
	 document.getElementsByName("second_org_name")[0].value="";	   
     document.getElementsByName("e_one")[0].value="";
	 document.getElementsByName("e_two")[0].value="";
	 document.getElementsByName("facilities_name")[0].value="";
	 document.getElementsByName("specifications")[0].value="";
 	 document.getElementsByName("technical_conditions")[0].value="";
	 document.getElementsByName("use_situation")[0].value=""; 
	 document.getElementsByName("release_date")[0].value="";
	 document.getElementsByName("paizhaohao")[0].value="";	 
 
}

function simpleSearch(){
	var arrayObj = new Array();
	var t=document.getElementById("table1").childNodes.item(0);
		for(var i=0;i< t.childNodes.length;i++)
	{
		for(var j=1;j<t.childNodes(i).childNodes.length;j=j+2)
      {
      	arrayObj.push({"label":t.childNodes(i).childNodes[j].firstChild.name,"value":t.childNodes(i).childNodes[j].firstChild.value}); 
      }
   		//arrayObj.push(t.childNodes(i).childNodes[1].firstChild.value);
  		//arrayObj.push(t.childNodes(i).childNodes[3].firstChild.value);  
	}
	 var ctt = self.parent.frames["leftframe"];
     ctt.refreshData(arrayObj); 
  //  self.parent.frames["leftframe"].location="<%=contextPath %>/hse/notConforMcorrectiveAction/rectificationProblem/leftPage.jsp?arrayObj="+arrayObj;
}

</script>
<title>设备设施台账查询</title>
</head>
<body  onload="pageInit();getEquipmentOne();" >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height"   id="table1" width="1000px"> 
	<tr  >
		  <td class="inquire_item6">单位：</td>
	  	<td class="inquire_form6"> 
	    	<input type="text" id="org_name" name="org_name" class="input_width"  style="width:180px;"    <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
	  	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
	  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	  	<%} %>	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />	
	  	</td>
	    	<td class="inquire_item6">二级单位：</td>
	  	<td class="inquire_form6"> 
	  	  <input type="text" id="second_org_name" name="second_org_name" class="input_width"   style="width:180px;"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
	  	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
	  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	  	<%} %>	  	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
	  	</td>    		    
	  	 <td class="inquire_item6">出厂日期：</td> 					   
		    <td class="inquire_form6"  align="center" > 
		    <input type="text" id="release_date" name="release_date" class="input_width"   style="width:180px;"    />
		    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(release_date,tributton1);" />&nbsp;</td>
	</tr>
	<tr > 
		<td class="inquire_item6">设备设施名称：</td>
	    <td class="inquire_form6">
	    <input type="text" id="facilities_name" name="facilities_name" class="input_width"  style="width:180px;"    />    	
	    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTreePage()"  />
	    </td>	 
		<td class="inquire_item6">规格型号：</td>
		<td class="inquire_form6"><input type="text" id="specifications" name="specifications" class="input_width"   style="width:180px;"    /></td>					 
		 <td class="inquire_item6">牌照号：</td>
		    <td class="inquire_form6"> 
		    <input type="text" id="paizhaohao" name="paizhaohao" class="input_width"  style="width:180px;"    />    		
		 </td>
	</tr>
	<tr  >
	    <td class="inquire_item6">使用状况：</td> 					   
	    <td class="inquire_form6"  align="center" > 
	    <select id="use_situation" name="use_situation" class="select_width" onchange="selectUse()"  style="width:180px;"  > 
		</select> 	
	    </td>    
	    <td class="inquire_item6">技术状况：</td>
	    <td class="inquire_form6">  
	    <select id="technical_conditions" name="technical_conditions" class="select_width"  style="width:180px;"  >
		</select> 		
	    </td>
	    <td class="inquire_item6">设备设施类别一：</td> 					   
	    <td class="inquire_form6"  align="center" > 
	    <select id="e_one" name="e_one" class="select_width" onchange="getEquipmentTwo()"  style="width:180px;"  ></select> 	
	    </td> 
	  </tr>	
	</tr>
	<tr > 
	    <td class="inquire_item6">设备设施类别二：</td>
	    <td class="inquire_form6"> 
	    <select id="e_two" name="e_two" class="select_width"  style="width:180px;"  >
		</select> 			
	    </td>
	</tr>
</table>
 
<table  width="1000px;" border="0" cellspacing="0" cellpadding="0"   >
<tr> 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="1000px" border="0" cellspacing="0" cellpadding="0">
<tr align="right"> 
	<td class="ali_query"></td>
	<td class="ali_query"></td>
	<td class="ali_query"></td>
	<td class="ali_query"></td>
	<td class="ali_query">&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td class="ali_query">&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td class="ali_query">
  <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
 
  <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form>
</body>
</html>