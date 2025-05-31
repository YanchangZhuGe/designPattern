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
		alert("��ѡ��һ����¼");
		return false;
	}else{
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('����ɹ�');
		newClose();
		return true;
	}
	
 
}

 
function sucess(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('����ɹ�');
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
		alert("��ѡ��һ����¼");
		return false;
	}else{
		return true;
	}
	

}
	

 

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"����Ϊ��");
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
			alert(fieldInfo+"��ʽ����ȷ,����������");
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
	selectObj.add(new Option('��ѡ��',""),0);

	var queryHazardBig=jcdpCallService("HseOperationSrv","queryHazardBig","");	
 
	for(var i=0;i<queryHazardBig.detailInfo.length;i++){
		var templateMap = queryHazardBig.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("hazard_center");
	document.getElementById("hazard_center").innerHTML="";
	selectObj1.add(new Option('��ѡ��',""),0);
}

function getHazardCenter(){
    var hazardBig = "hazardBig="+document.getElementById("hazard_big").value;   
	var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);	

	var selectObj = document.getElementById("hazard_center");
	document.getElementById("hazard_center").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
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

 
function clearQueryText(){
	 document.getElementsByName("org_sub_id")[0].value="";
	 document.getElementsByName("org_sub_id2")[0].value="";
	 document.getElementsByName("second_org")[0].value="";	
	 document.getElementsByName("second_org2")[0].value="";	
 
    document.getElementsByName("supplies_name")[0].value="";
	document.getElementsByName("supplies_category")[0].value="";	
	document.getElementsByName("acquisition_time")[0].value="";	
	document.getElementsByName("unit_measurement")[0].value="";	
	
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
	}
	 var ctt = self.parent.frames["leftframe"];
     ctt.deleteTableTr("queryRetTable");
     ctt.refreshData(arrayObj); 
  //  self.parent.frames["leftframe"].location="<%=contextPath %>/hse/notConforMcorrectiveAction/rectificationProblem/leftPage.jsp?arrayObj="+arrayObj;
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
<title>���������Ϣ</title>
</head>
<body    onload="getHazardBig();"  >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<fieldSet style="margin-left:2px"><legend>ѡ��¼����Ϣ</legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
	 <tr > 
	  <td   align="center"> <font color=black size="2px">������</font> 
	  <input type="checkbox" name="checkbox" value="1" id="checkbox1" onclick="add()"/>
	  </td>
	  <td   align="center"> <font color=black size="2px">�������</font> 
	  <input type="checkbox" name="checkbox" value="2" id="checkbox2" onclick="add()"/>
	  </td>
	   <td   align="center"><font color=black size="2px">�ͺ�/���</font> 
	  <input type="checkbox" name="checkbox" value="3" id="checkbox3" onclick="add()"/>  		
	  </td>
	  <td   align="center"><font color=black size="2px">����ʱ��</font> 
	  <input type="checkbox" name="checkbox" value="4" id="checkbox4" onclick="add()"/>  		
	  </td>

	</tr>	
	 <tr > 
	  <td   align="center"> <font color=black size="2px">��Ч�ڽ�ֹ��</font> 
	  <input type="checkbox" name="checkbox" value="5" id="checkbox5" onclick="add()"/>
	  </td>
	   <td   align="center"><font color=black size="2px">У���ڽ�ֹ��</font> 
	  <input type="checkbox" name="checkbox" value="6" id="checkbox6" onclick="add()"/>  		
	  </td>
	  <td   align="center"><font color=black size="2px">���λ��</font> 
	  <input type="checkbox" name="checkbox" value="7" id="checkbox7" onclick="add()"/>  		
	  </td>	  

	</tr>	
 	
	</table>
</fieldSet>
<fieldSet style="margin-left:2px"><legend>ѡ���ѯ����</legend>
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height"   id="table1" width="1000px"> 
<tr  >
<td class="inquire_item6">��λ��</td>
<td class="inquire_form6">
<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"  style="width:180px;"    <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
<%} %>
</td>
	<td class="inquire_item6">������λ��</td>
<td class="inquire_form6">
 <input type="hidden" id="second_org" name="second_org" class="input_width" />
  <input type="text" id="second_org2" name="second_org2" class="input_width"   style="width:180px;"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
<%} %>
</td>    		    
<td class="inquire_item4">�������</td> 
<td class="inquire_form4">	 
<select id="supplies_category" name="supplies_category" class="select_width"  style="width:180px;">
 <option value="" >��ѡ��</option>
 <option value="1" >�������</option>
 <option value="2" >ҽ�Ƽ���</option>
 <option value="3" >������Ԯ</option>
 <option value="4" >�����Ѵ</option>
 <option value="5" >Ӧ������</option>
 <option value="6" >��ͨ����</option>
 <option value="7" >ͨѶ����</option>
 <option value="8" >�����</option>
 <option value="9" >��������</option>
 <option value="10" >�����Ʋ�</option>
 <option value="11" >��������</option>
 <option value="12" >����</option>
</select> 
</td>	

</tr>

<tr  >

<td  class="inquire_item4"><font color=red></font>&nbsp;�������ƣ�</td>
<td class="inquire_form4">	 
<input type="text" id="supplies_name" name="supplies_name" class="input_width"    style="width:180px;" />
</td>

<td  class="inquire_item4"><font color=red></font>&nbsp;����ʱ�䣺</td>
<td class="inquire_form4">	 
<input type="text" id="acquisition_time" name="acquisition_time" class="input_width"   style="width:180px;"  /> 
<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time,tributton1);" /> 
</td>

<td  class="inquire_item4"><font color=red></font>&nbsp;������λ��</td>
<td class="inquire_form4">	 
<input type="text" id="unit_measurement" name="unit_measurement" class="input_width"    style="width:180px;" />
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