<%@page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
	    String contextPath = request.getContextPath();
	    UserToken user = OMSMVCUtil.getUserToken(request);
	    String userName = (user==null)?"":user.getUserName();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String curDate = format.format(new Date());
    	String orgId = (user==null)?"":user.getCodeAffordOrgID();
    	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />

<%@ include file="/common/pmd_add.jsp"%>
<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "新建--临时工CRU";
var eliteIf = new Array(
['0','否'],['1','是']
);

var genderOps = new Array(
['1','男'],['0','女']
);
var engineerIf=new Array(
		['0','否'],['1','是']		
		);
var projectIf=new Array(
		['0','不在项目'],['1','在项目']		
		);
var jcdp_codes_items = null;
var jcdp_codes = new Array(
		['employeeEducationLevel','文化程度',"SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id = '0500100004' and t.bsflag = '0' order by t.coding_show_id"],
		['humanNation','民族',"SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id = '0500100001' and t.bsflag = '0' order by t.coding_show_id"],
		['teamCode','班组表',"SELECT t.coding_code_id AS value, t.coding_name AS label from comm_coding_sort_detail t where t.coding_sort_id  ='0110000001' and t.bsflag='0' and length(t.coding_code) = 2 order by t.coding_show_id"],
		['postCode','岗位',"select t.coding_code_id AS value, t.coding_name AS label,t.coding_show_id as coding_show_id from comm_coding_sort_detail t where t.coding_sort_id  ='0500100011' and t.bsflag='0'"],
		['engineerCode','用工性质',"select t.coding_code_id AS value, t.coding_name AS label,t.coding_show_id as coding_show_id from comm_coding_sort_detail t where t.coding_sort_id  ='0110000059' and t.bsflag='0'"]
);



var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['bgp_comm_human_labor']
);
var defaultTableName = 'bgp_comm_human_labor';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
var fields = new Array(
['labor_id','Id','Hide','TEXT',,,,,,,]
,['employee_name','姓名','Edit','TEXT','50',,,,'non-empty',,]
,['employee_gender','性别','Edit','SEL_OPs',,,,genderOps,'non-empty',,]
,['employee_birth_date','出生年月','Edit','D',,,,,'non-empty',,]
,['employee_nation','民族','Edit','SEL_Codes',,,,'humanNation','non-empty',,]
,['employee_id_code_no','身份证号','Edit','TEXT','18',,,,'non-empty',,'onblur=onBulrs()']
,['employee_education_level','文化程度','Edit','SEL_Codes',,,,'employeeEducationLevel',,,]
,['employee_address','家庭住址','Edit','TEXT','100',,,,,,]
,['phone_num','联系电话','Edit','N','32',,,,,,]
,['employee_health_info','健康信息','Edit','TEXT','32',,,,,,]
,['elite_if','是否骨干','Edit','SEL_OPs',,,,eliteIf,,,]
,['apply_team','班组','Edit','SEL_Codes',,,,'teamCode',,,'onchange=changePost()']
,['post','岗位','Edit','SEL_Codes',,,,,,,]
,['workerfrom','用工来源','Edit','FK',,'$ENTITY.workerfrom:$ENTITY.workerfrom_name',,'<%=contextPath%>/common/selectCode.jsp?codingSortId=0110000025',,,'readOnly']
,['technical_title','技术职称','Edit','FK',,'$ENTITY.technical_title:$ENTITY.technical_title_name',,'<%=contextPath%>/common/selectCode.jsp?codingSortId=0500100008',,,'readOnly']
,['mobile_number','手机号码','Edit','TEXT','32',,,,,,]
,['if_project','项目状态','Edit','SEL_OPs',,,,projectIf,,,]  
,['owning_org_id','组织机构','Edit','FK',,'$ENTITY.org_id:$ENTITY.org_name',,'<%=contextPath%>/common/selectOrg.jsp?codingSortId=0110000001','non-empty',,'readOnly']
,['owning_subjection_org_id','组织机构隶属关系','Hide','TEXT','50',,,,,,]
,['if_engineer','用工性质','Edit','SEL_Codes',,,,'engineerCode','non-empty',,]
,['postal_code','邮编','Edit','TEXT','50',,,,,,]
,['cont_num','劳动合同编号','Edit','TEXT','50',,,,,,]
,['specialty','技能','Edit','MEMO','1000',,,,,,]
,['create_date','录入日期','Hide','D',,'CURRENT_DATE_TIME',,,,,]
,['creator','录入人','Hide','TEXT',,'<%=user.getUserId()%>',,,,,]
,['bsflag','','Hide','TEXT',,'0',,,,,]
,['updator','修改人','Hide','TEXT',,'<%=user.getUserId()%>',,,,,]
,['modifi_date','修改时间','Hide','D',,'CURRENT_DATE_TIME',,,,,]
);
var uniqueFields = ':';
var fileFields = ':';
var defaultPost = "";
function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/humanLabor/commHumanLabor/laborMessage.jsp";
	cru_init();
	var id = '<%=request.getParameter("id")%>';
	if(id != ""){
		var retObject=jcdpCallService("HumanLaborMessageSrv","checkHumanLaborCodeNo","id="+id);		
		if(retObject.laborMes!=null){
			for (var i = 0; i < retObject.laborMes.length; i++) {
				var	datas=retObject.laborMes[i];
				document.getElementById("labor_id").value=datas.labor_id;
				document.getElementById("employee_name").value=datas.employee_name;		
	  			setOpitionValue("employee_gender",datas.employee_gender);
	  			setOpitionValue("employee_nation",datas.employee_nation);
	  			setOpitionValue("elite_if",datas.elite_if);
	  			setOpitionValue("employee_education_level",datas.employee_education_level);
				document.getElementById("employee_birth_date").value=datas.employee_birth_date;
				document.getElementById("employee_id_code_no").value=datas.employee_id_code_no;
				document.getElementById("employee_address").value=datas.employee_address;
				document.getElementById("phone_num").value=datas.phone_num;
				document.getElementById("employee_health_info").value=datas.employee_health_info;
				document.getElementById("specialty").value=datas.specialty;
				document.getElementById("workerfrom").fkValue=datas.workerfrom;
				document.getElementById("workerfrom").value=datas.workerfrom_name;
				document.getElementById("technical_title").fkValue=datas.technical_title;	
				document.getElementById("technical_title").value=datas.technical_title_name;	
				document.getElementById("owning_org_id").fkValue=datas.org_id;	
				document.getElementById("owning_org_id").value=datas.org_name;
				setOpitionValue("if_engineer",datas.if_engineer);
				setOpitionValue("if_project",datas.if_project);
				setOpitionValue("apply_team",datas.apply_team);	 
				//setOpitionValue("post",datas.post);
				defaultPost=datas.post;
				document.getElementById("mobile_number").value=datas.mobile_number;
				document.getElementById("postal_code").value=datas.postal_code;
				document.getElementById("cont_num").value=datas.cont_num;
				document.getElementById("owning_subjection_org_id").value=datas.owning_subjection_org_id;
		     }
		}
	}	
}
function testBack(){
 window.history.back();
}

function onBulrs(){
	var employee_id_code_no=document.getElementById("employee_id_code_no").value;
	var subId="<%=orgSubjectionId%>";
	if(document.getElementById("Submit2").style.display != "none"){
		if(employee_id_code_no != ""){
			var querySql="select * from( select  l.labor_id, l.employee_name, l.employee_gender, l.employee_id_code_no, lt.list_id,  lt.bl_status, lt.bsflag, lt.employee_id_code_no as employee_idCode from bgp_comm_human_labor l left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id where lt.list_id is not null order by lt.create_date desc) d   where d.employee_id_code_no='"+employee_id_code_no+"' and d.bsflag='0' and d.owning_subjection_org_id='"+subId+"'";
			var queryRet=syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
			var datas=queryRet.datas;
			if(datas!=null && queryRet.datas.length){
				for(var i=0;i<queryRet.datas.length;i++){
					document.getElementsByName("listId")[0].value=datas[i].list_id;				
				}
				var listId=document.getElementsByName("listId")[0].value;
				var url="<%=contextPath%>/rm/em/humanLabor/commHumanLabor/laborBlistModify.jsp?id="+listId+"&amp;action=edit";
				//window.open(url, "newwindow", "height=500, width=600, top=200, left=350,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
				showModalDialog(url,'','dialogWidth:900px;dialogHeight:500px;status:yes');
				document.getElementById("employee_id_code_no").value="";
				return;
			}
			var retObject=jcdpCallService("HumanLaborMessageSrv","checkHumanLaborCodeNo","employee_id_code_no="+employee_id_code_no);		
			if(retObject.laborMes!=null){
				for (var i = 0; i < retObject.laborMes.length; i++) {
					var	datas=retObject.laborMes[i];
					document.getElementById("labor_id").value=datas.labor_id;
					document.getElementById("employee_name").value=datas.employee_name;		
		  			setOpitionValue("employee_gender",datas.employee_gender);
		  			setOpitionValue("employee_nation",datas.employee_nation);
		  			setOpitionValue("elite_if",datas.elite_if);
		  			setOpitionValue("employee_education_level",datas.employee_education_level);
					document.getElementById("employee_birth_date").value=datas.employee_birth_date;
					document.getElementById("employee_id_code_no").value=datas.employee_id_code_no;
					document.getElementById("employee_address").value=datas.employee_address;
					document.getElementById("phone_num").value=datas.phone_num;
					document.getElementById("employee_health_info").value=datas.employee_health_info;
					document.getElementById("specialty").value=datas.specialty;
					document.getElementById("workerfrom").fkValue=datas.workerfrom;
					document.getElementById("workerfrom").value=datas.workerfrom_name;
					document.getElementById("technical_title").fkValue=datas.technical_title;
					document.getElementById("technical_title").value=datas.technical_title_name;
					document.getElementById("owning_org_id").fkValue=datas.org_id;	
					document.getElementById("owning_org_id").value=datas.org_name;	
					setOpitionValue("apply_team",datas.apply_team);
					defaultPost=datas.post;
					setOpitionValue("if_engineer",datas.if_engineer);
					setOpitionValue("if_project",datas.if_project);
					document.getElementById("mobile_number").value=datas.mobile_number;
					document.getElementById("postal_code").value=datas.postal_code;
					document.getElementById("cont_num").value=datas.cont_num;
					document.getElementById("owning_subjection_org_id").value=datas.owning_subjection_org_id;
					changePost();
			     }
			}
		}		
	}
}
function setOpitionValue(objectName,value){
	var name =getElementByTypeAndName('SELECT',objectName);
 if(name!=null){
	for(var i=0;i<name.options.length;i++){
		if(name.options[i].value==value){
			name.options[i].selected=true;
			break;
		}
	}
 }
}
function checkHumanLaborCode(){
    var employee_id_code_no=document.getElementById("employee_id_code_no").value;
    var phone_num=document.getElementById("phone_num").value;
    var warnings = "";
	
	if(isNaN(phone_num)){
		warnings="联系电话只能为数字，请正确输入";
		return warnings;	
	}
	
	return "";
}


function checkHumanLaborContNum(){
	var if_engineer =getElementByTypeAndName('SELECT','if_engineer').value;
	 var cont_num=document.getElementById("cont_num").value;
	   var warnings = "";
	if(if_engineer!=null){
			 if(if_engineer=="0110000059000000004"){
 
			 }else{
				 if(cont_num == null || cont_num==""){
			    		warnings="劳动合同编号不能为空!";
			    		return warnings;	
			    	} 
	 }
	 }
	return "";
}

function submitFunc(){
		testClick();		
		var warning = checkHumanLaborContNum();
		if(warning != ""){
			alert(warning);
			return;
		}
	var submitStr = "jcdp_tables="+tables.toJSONString();
	for(var i=0;i<tables.length;i++){
	  var tableName = tables[i][0];
	  var tSubmitStr = '';
	  if(tableName==defaultTableName) tSubmitStr = getSubmitStr();
	  else 	tSubmitStr = getSubmitStr(tableName);
      if(tSubmitStr == null) return;
	   submitStr += "&"+tableName+"="+submitStr2Array(tSubmitStr).toJSONString();
	}
	
	
	var path = cruConfig.contextPath+cruConfig.updateMulTableAction;
	var retObject = syncRequest('Post',path,submitStr);
	afterSubmit(retObject);
}

function afterSubmit(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		window.location = cruConfig.contextPath+cruConfig.openerUrl;
	}
}

//提示提交结果
function afterSave(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		//alert(successHint);
		window.location="<%=contextPath%>/rm/em/humanLabor/commHumanLabor/laborMessage.jsp";
	}
}
//获取组织机构隶属关系subId
function testClick(){
	var orgId=document.getElementById("owning_org_id").fkValue;
	if(orgId!=null){
		var querySql ="select sb.org_subjection_id  from comm_org_subjection sb  where sb.bsflag='0' and  sb.org_id='"+orgId+"'"
		var queryRet = syncRequest('Post','/BGPMCS'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas.length>0){
		document.getElementById("owning_subjection_org_id").value=datas[0].org_subjection_id;
		}
	
	}
}

//班组岗位联动 方法
function changePost(){
    var applyTeam = "applyTeam="+getElementByTypeAndName('SELECT','apply_team').value;  
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);
 	var well_num_control = getElementByTypeAndName('SELECT','post');
	for(var i=well_num_control.options.length-1;i>0;i--){
		well_num_control.options.remove(i);
	}
	if(applyPost.detailInfo!=null){
		for(var i=0;i<applyPost.detailInfo.length;i++){
			var templateMap = applyPost.detailInfo[i];
			well_num_control.options[well_num_control.options.length]=new Option(templateMap.label,templateMap.value); 
			if(templateMap.value==defaultPost){
				well_num_control.selectedIndex = well_num_control.options.length-1;
			}
		}
	}
}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init(); changePost();">
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_page_title" >
<tr>
	<td height=1 colspan="4" align=left></td>
</tr>
<tr>
	<td width="5%"  height=28 align=left ><img src="<%=contextPath%>/images/oms_index_09.gif" width="100%" height="28" /></td>
	<td id="cruTitle" width="40%" align=left background="<%=contextPath%>/images/oms_index_11.gif" class="text11">
 </td>
	<td width="5%" align=left ><img src="<%=contextPath%>/images/oms_index_13.gif" width="100%" height="28" /></td>
	<td width="50%" align=left style="background:url(<%=contextPath%>/images/oms_index_14.gif) repeat-x;">&nbsp;</td>
</tr>
</table>	
  <form name='fileForm' encType='multipart/form-data'  method='post' target='hidden_frame'>
<table id="rtCRUTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
<SPAN id=hiddenFields>
</SPAN>
  <tr>
    <td colspan="4" class="ali4">
    <input name="Submit2" type="button" class="iButton2" id="Submit2" onClick="submitFunc()" value="保存" style="display:<%="view".equals(request.getParameter("action"))?"none":"" %>"/>
    <input type="hidden" name="listId" id="listId" />
    <input name="Submit" type="button" class="iButton2"  onClick="testBack();" value="返回" /></td>
  </tr>
</table>
</form>  <iframe name='hidden_frame' width='1' height='1' marginwidth='0' marginheight='0' scrolling='no' frameborder='0'></iframe>
</body>
</html>
