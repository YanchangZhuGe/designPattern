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
cruConfig.contextPath='<%=contextPath %>';
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

function getHazardBig(){
	var selectObj = document.getElementById("hazard_big"); 
	document.getElementById("hazard_big").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

	var queryHazardBig=jcdpCallService("HseOperationSrv","queryHazardBig","");	
 
	for(var i=0;i<queryHazardBig.detailInfo.length;i++){
		var templateMap = queryHazardBig.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("hazard_center");
	document.getElementById("hazard_center").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

function getHazardCenter(){
    var hazardBig = "hazardBig="+document.getElementById("hazard_big").value;   
	var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);	

	var selectObj = document.getElementById("hazard_center");
	document.getElementById("hazard_center").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(HazardCenter.detailInfo!=null){
		for(var i=0;i<HazardCenter.detailInfo.length;i++){
			var templateMap = HazardCenter.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
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
        document.getElementById("org_sub_id2").value = teamInfo.value;
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
		        document.getElementById("second_org2").value = teamInfo.value;
			}
   
}

function selectOrg3(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("second_org").value;
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
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
			}
}
function clearQueryText(){
	 document.getElementsByName("org_sub_id")[0].value="";
	 document.getElementsByName("org_sub_id2")[0].value="";
	 document.getElementsByName("second_org")[0].value="";	
	 document.getElementsByName("second_org2")[0].value="";	
     document.getElementsByName("third_org")[0].value="";	
     document.getElementsByName("third_org2")[0].value="";     
    document.getElementsByName("operation_post")[0].value="";
	document.getElementsByName("hidden_name")[0].value="";	
	document.getElementsByName("identification_method")[0].value="";			
    document.getElementsByName("hazard_big")[0].value="";	
	document.getElementsByName("hazard_center")[0].value="";
	document.getElementsByName("recognition_people")[0].value="";    
	document.getElementsByName("report_date")[0].value="";
 
}

function simpleSearch(){
	 var ctt = self.parent.frames["leftframe"];
     var paramS=ctt.document.getElementsByName("paramS")[0].value; 
     if(paramS !=null && paramS!=''){
    	 var arrayObj = new Array();
    		var t=document.getElementById("table1").childNodes.item(0);
    			for(var i=0;i< t.childNodes.length;i++)
    		{
    			for(var j=1;j<t.childNodes(i).childNodes.length;j=j+2)
    	      {
    	      	arrayObj.push({"label":t.childNodes(i).childNodes[j].firstChild.name,"value":t.childNodes(i).childNodes[j].firstChild.value}); 
    	      }
    		}
    		 var ctt = self.parent.frames["leftframe"];
    	  //   ctt.deleteTableTr("equipmentTableInfo");
    	 
    	     ctt.refreshData(arrayObj); 
    	  //  self.parent.frames["leftframe"].location="<%=contextPath %>/hse/notConforMcorrectiveAction/rectificationProblem/leftPage.jsp?arrayObj="+arrayObj;
     }else{
    	 alert('请先选择录入类别!');
     }
	
}

function add(){ 
	   var certificate = document.getElementsByName("checkbox"); 
		var certificate_no = "";
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ",";
				}
			}
			 var ctt = self.parent.frames["leftframe"];
		     ctt.document.getElementsByName("paramS")[0].value=certificate_no; 
	}
</script>
<title>隐患信息查询</title>
</head>
<body    onload="getHazardBig();"  >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<fieldSet style="margin-left:2px"><legend>请先选择录入类别</legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
	 <tr > 
	  <td   align="center"> <font color=black size="3px">评价信息</font> 
	  <input type="checkbox" name="checkbox" value="1" id="checkbox1" onclick="add()"/>
	  </td>
	   <td   align="center"><font color=black size="3px">整改信息</font> 
	  <input type="checkbox" name="checkbox" value="2" id="checkbox2" onclick="add()"/>  		
	  </td>
	  <td   align="center"><font color=black size="3px">奖励信息</font> 
	  <input type="checkbox" name="checkbox" value="3" id="checkbox3" onclick="add()"/>  		
	  </td>
	</tr>		  
	</table>
</fieldSet>
<fieldSet style="margin-left:2px"><legend>选择查询条件</legend>
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height"   id="table1" width="1000px"> 

<tr  >
	  <td class="inquire_item6">单位：</td>
  	<td class="inquire_form6">
  	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
    	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"  style="width:180px;"    <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
  	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
  	<%} %>
  	</td>
    	<td class="inquire_item6">基层单位：</td>
  	<td class="inquire_form6">
  	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
  	  <input type="text" id="second_org2" name="second_org2" class="input_width"   style="width:180px;"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
  	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
  	<%} %>
  	</td>    		    
    <td class="inquire_item6">下属单位：</td>
  	<td class="inquire_form6"> 
	<input type="hidden" id="third_org" name="third_org" class="input_width" />
  	<input type="text" id="third_org2" name="third_org2" class="input_width"    <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
  	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
  	<%}%>
  	</td>
	</tr>
	<tr  >
	
	<td class="inquire_item4">作业场所/岗位：</td> 
	<td class="inquire_form4">	 
	<input type="text" id="operation_post" name="operation_post" class="input_width"   style="width:180px;" /> 
	
	</td> 
	<td  class="inquire_item4"><font color=red></font>&nbsp;隐患名称：</td>
	<td class="inquire_form4">	 
	<input type="text" id="hidden_name" name="hidden_name" class="input_width"    style="width:180px;" />
		</td>
	<td class="inquire_item4">识别方法：</td> 
	<td class="inquire_form4">	 
	 <select id="identification_method" name="identification_method" class="select_width"  style="width:180px;">
	 <option value="" >请选择</option>
	 <option value="1" >集中识别</option>
	 <option value="2" >随机识别</option>
	 <option value="3" >专项识别</option>
	 <option value="4" >来访者识别</option>
	</select> 
	</td>	
	</tr>
	<tr  >
	<td  class="inquire_item4"><font color=red></font>&nbsp;上报日期：</td>
	<td class="inquire_form4">	 
	<input type="text" id="report_date" name="report_date" class="input_width" style="width:180px;"  style="width:180px;"   />
	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton2);" />&nbsp;</td>
	<td  class="inquire_item4"><font color=red></font>&nbsp;危害因素大类：</td>
	<td class="inquire_form4">	 
	  <select id="hazard_big" name="hazard_big" class="select_width" onchange="getHazardCenter()"  style="width:180px;"></select> 
		</td>
	<td class="inquire_item4">危害因素中类：</td> 
	<td class="inquire_form4">	 
	<select id="hazard_center" name="hazard_center" class="select_width"  style="width:180px;">
	</td>	 
	</tr>
	 
	</table>
</fieldSet>
<table  width="1024px;" border="0" cellspacing="0" cellpadding="0"   >
<tr> 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="1024px" border="0" cellspacing="0" cellpadding="0">
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