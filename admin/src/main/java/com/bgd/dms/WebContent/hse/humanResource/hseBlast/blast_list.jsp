<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project = request.getParameter("project");
	if(project==null||project.equals("")){
		project = resultMsg.getValue("project");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="name" name="name" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
		         <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="dr" event="onclick='toUploadFile()'" title="导入" ></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_blast_id}' id='rdo_entity_id_{hse_blast_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{second_org_name}</font>">单位</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{third_org_name}</font>">基层单位</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{fourth_org_name}</font>">下属单位</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{employee_name}</font>">姓名</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{certificate_name}</font>">证件名称</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{certificate_num}</font>">证件编号</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{certificate_org}</font>">发证机关</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{days}</font>">临近审验日期时间</td>
			      
			      <td class="bt_info_odd" exp="{second_org_name}" isShow='Hide' isExport='Show'>单位</td>
			      <td class="bt_info_odd" exp="{third_org_name}" isShow='Hide' isExport='Show'>基层单位</td>
			      <td class="bt_info_odd" exp="{employee_name}" isShow='Hide' isExport='Show'>姓名</td> 
			      <td class="bt_info_odd" exp="{sex_type}" isShow='Hide' isExport='Show'>性别</td>
			      <td class="bt_info_odd" exp="{code_id}" isShow='Hide' isExport='Show'>身份证号</td>
			      <td class="bt_info_odd" exp="{certificate_name}" isShow='Hide' isExport='Show'>证件名称</td>
			      <td class="bt_info_odd" exp="{certificate_num}" isShow='Hide' isExport='Show'>证件编号</td>
			      <td class="bt_info_odd" exp="{certificate_org}" isShow='Hide' isExport='Show'>发证机关</td> 
			      <td class="bt_info_odd" exp="{check_date}" isShow='Hide' isExport='Show'>审验日期截止到</td>
			      
			      
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">涉爆信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<input type="hidden" id="hse_blast_id" name="hse_blast_id"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						  <td class="inquire_item6">单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="second_org" name="second_org" class="input_width" readonly="readonly"/>
					      	</td>
					     	<td class="inquire_item6">基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="third_org" name="third_org" class="input_width" readonly="readonly"/>
					      	</td>
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="fourth_org" name="fourth_org" class="input_width" readonly="readonly"/>
					      	</td>
					  </tr>
					  <tr>
					    	<td class="inquire_item6">姓名：</td>
				      		<td class="inquire_form6">
						      	<input type="text" id="employeeName" name="employeeName" class="input_width"  value="" readonly="readonly"/>
				      		</td>
						    <td class="inquire_item6">性别：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="sex" name="sex" class="input_width" readonly="readonly"/>
							</td>
							<td class="inquire_item6">身份证号：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="codeId" name="codeId" class="input_width" readonly="readonly"/>
							</td>
					  </tr>	
					  <tr>
							<td class="inquire_item6">学历：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="education_level" name="education_level" class="input_width" readonly="readonly"/>
							</td>
						  	<td class="inquire_item6">职称：</td>
						    <td class="inquire_form6">
								<input type="text" id="techTitle" name="techTitle" class="input_width" readonly="readonly"/>
						    </td>
						    <td class="inquire_item6">用工方式</td>
						    <td class="inquire_form6">
						    	<input type="text" id="human_scotter" name="human_scotter" class="input_width" readonly="readonly"/>
							</td>
					  </tr>
					  <tr>
						  	<td class="inquire_item6">是否在岗：</td>
						    <td class="inquire_form6">
								<input type="text" id="personStatus" name="personStatus" class="input_width" readonly="readonly"/>
							</td>
						    <td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
						   	<td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<form name="form1" id="form1"  method="post" action="">
					<input type="hidden" id="project" name="project" value="<%=project %>"></input>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
			                  <td>&nbsp;</td>
			                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
			                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
				    	<td class="inquire_item6"><font color="red">*</font>选择人员：</td>
				      	<td class="inquire_form6">
							<input type="hidden" id="employee_id" name="employee_id" class="input_width"  value=""/>
					      	<input type="text" id="employee_name" name="employee_name" class="input_width"  value=""/>
					      	<input type="button" style="width:20px" value="..." onclick="showHuman()"/>
				      	</td>
					   	<td class="inquire_item6"><font color="red">*</font>是否在岗：</td>
					   	<td class="inquire_form6">
					   		<select id="person_status" name="person_status" class="select_width">
						       <option value="" >请选择</option>
						       <option value="是" >是</option>
						       <option value="否" >否</option>
							</select>
					   	</td>
				     	<td class="inquire_item6"><font color="red">*</font>证件名称：</td>
				      	<td class="inquire_form6">
				      		<input type="text" id="certificate_name" name="certificate_name" class="input_width"></input>
				      	</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"><font color="red">*</font>证件编号：</td>
					    <td class="inquire_form6">
							<input type="text" id="certificate_num" name="certificate_num" class="input_width"></input>
						</td>
					  	<td class="inquire_item6"><font color="red">*</font>发证单位：</td>
					    <td class="inquire_form6">
							<input type="text" id="certificate_org" name="certificate_org" class="input_width"></input>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>审验日期截止到：</td>
					   	<td class="inquire_form6"><input type="text" id="check_date" name="check_date" class="input_width"  readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);" />&nbsp;
					    </td>
					  </tr>
					</table>
					</form>
				</div>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

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
	
	// 复杂查询
	function refreshData(){
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select * from (select hb.hse_blast_id,hb.project_info_no,hb.check_date, hb.bsflag,hb.modifi_date,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,hb.certificate_name,hb.certificate_num,hb.certificate_org,hb.check_date-to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd') days,case when months_between(hb.check_date,sysdate)<=0 then 'red'  when months_between(hb.check_date, sysdate)>2 then '' else 'orange' end color,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_blast hb left join comm_human_employee ee on hb.employee_id=ee.employee_id and ee.bsflag='0' left join comm_org_subjection os1 on hb.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hb.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hb.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0'   left join bgp_comm_human_labor la on la.labor_id=hb.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0'  where hb.bsflag='0' ) where bsflag='0' "+querySqlAdd+" order by modifi_date desc";
		cruConfig.currentPageUrl = "hse/humanResource/hseBlast/blast_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "hse/humanResource/hseBlast/blast_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
		var name = document.getElementById("name").value;
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		if(name!=''&&name!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select * from (select hb.hse_blast_id,hb.project_info_no,hb.check_date, hb.bsflag,hb.modifi_date,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,hb.certificate_name,hb.certificate_num,hb.certificate_org,hb.check_date-to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd') days,case when months_between(hb.check_date,sysdate)<=0 then 'red'  when months_between(hb.check_date, sysdate)>2 then '' else 'orange' end color,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_blast hb left join comm_human_employee ee on hb.employee_id=ee.employee_id and ee.bsflag='0' left join comm_org_subjection os1 on hb.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hb.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hb.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0'   left join bgp_comm_human_labor la on la.labor_id=hb.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0'  where hb.bsflag='0' ) where bsflag='0' "+querySqlAdd+" and employee_name like '%"+name+"%' order by modifi_date desc";
			cruConfig.currentPageUrl = "hse/humanResource/hseBlast/blast_list.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("name").value = "";
	}
	
  	function toUploadFile(){
		popWindow("<%=contextPath%>/hse/humanResource/hseBlast/humanImportFile.jsp?project=<%=project%>");
     }
	 
  	
	function showHuman(){
	    var project = "<%=project%>";
	    var result = "";
	    if(project=="1"){
	    	result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanMultiple.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
	    }else if(project=="2"){
	    	result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanSingle.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
	    }
	    if(result!=null && result!=""){
	    	var checkStr=result.split(",");
	    	for(var i=0;i<checkStr.length-1;i++){
	    		var testTemp = checkStr[i].split("-");
	    		document.getElementById("employee_id").value = testTemp[0];
	    	    document.getElementById("employee_name").value = testTemp[1];
	       	}	
	   }
	  }
	
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "queryBlast", "hse_blast_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryBlast", "hse_blast_id="+ids);
		}
		document.getElementById("hse_blast_id").value =retObj.map.hseBlastId;
		document.getElementById("second_org").value =retObj.map.secondOrgName;
		document.getElementById("third_org").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org").value =retObj.map.fourthOrgName;
		document.getElementById("employeeName").value =retObj.map.employeeName;
		document.getElementById("sex").value = retObj.map.sexType;
		document.getElementById("codeId").value = retObj.map.codeId;
		document.getElementById("education_level").value = retObj.map.codingName;
		document.getElementById("techTitle").value = retObj.map.title;
		document.getElementById("human_scotter").value = retObj.map.humanScotter;
		document.getElementById("personStatus").value = retObj.map.personStatus;
		
		
		document.getElementById("employee_id").value = retObj.map.employeeId;
		document.getElementById("employee_name").value = retObj.map.employeeName;
		document.getElementById("person_status").value = retObj.map.personStatus;
		document.getElementById("certificate_name").value = retObj.map.certificateName;
		document.getElementById("certificate_num").value = retObj.map.certificateNum;
		document.getElementById("certificate_org").value = retObj.map.certificateOrg;
		document.getElementById("check_date").value = retObj.map.checkDate;

	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/humanResource/hseBlast/addBlast.jsp?project=<%=project%>");
	}
	
	function toUpdate(){ 
		if(checkText()){
			return;
		}
		var hse_blast_id = document.getElementById("hse_blast_id").value;
		var form = document.getElementById("form1");
		form.action="<%=contextPath%>/hse/resource/saveBlast.srq?project=<%=project%>&&hse_blast_id="+hse_blast_id;
		form.submit();
	} 
	
	function checkText(){
		var employee_id = document.getElementById("employee_id").value;
		var person_status = document.getElementById("person_status").value;
		var certificate_name = document.getElementById("certificate_name").value;
		var certificate_num = document.getElementById("certificate_num").value;
		var certificate_org = document.getElementById("certificate_org").value;
		var check_date = document.getElementById("check_date").value;
		if(employee_id==""){
			alert("人员姓名不能为空，请选择！");
			return true;
		}
		if(person_status==""){
			alert("时候在岗不能为空，请填写！");
			return true;
		}
		if(certificate_name==""){
			alert("证件名称不能为空，请填写！");
			return true;
		}
		if(certificate_num==""){
			alert("证件编号不能为空，请填写！");
			return true;
		}
		if(certificate_org==""){
			alert("发证机关不能为空，请选择！");
			return true;
		}
		if(check_date==""){
			alert("审验截止日期不能为空，请填写！");
			return true;
		}
		return false;
	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteBlast", "hse_blast_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/humanResource/hseBlast/blast_search.jsp?project=<%=project %>");
	}
	
	
</script>

</html>

