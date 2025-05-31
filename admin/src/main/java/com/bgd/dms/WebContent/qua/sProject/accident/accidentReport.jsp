<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null){
		project_info_no = "";
	}
	String project_name = user.getProjectName();
	if(project_name == null){
		project_name = "";
	}
	
	Date sysdate=new Date();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String nowDate = df.format(sysdate);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function checkFormat(){
		var element = event.srcElement;
		var small_loss = element.value;
		var index = small_loss.indexOf('.');
		if(index == small_loss.length-1){
			element.value = small_loss.substring(0,small_loss.length-1);
		}
	}
	function checkIfDouble(){
		var element = event.srcElement;
		if(element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
			return true;
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode == 190 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			var small_loss = element.value;
			var index = small_loss.indexOf('.');
			if(event.keyCode == 190 && (small_loss == null || small_loss =='')){
				return false;
			}else if(event.keyCode == 190 && (small_loss != null && small_loss !='') && index !=(-1)){
				return false;
			}
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_ACCIDENT_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{accident_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{org_id}">填报单位</td>
			  <td class="bt_info_even" exp="{report_date}">填报日期</td>
			  <td class="bt_info_odd" exp="{accident_num}">质量事故次数</td>
			  <td class="bt_info_even" exp="<a href='#' onclick=reportShow('{accident_id}')><font color='blue'>报表</font></a>">报表</td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
        <li><a href="#" onclick="getTab(this,2)" >事故报告单</a></li>
        <li><a href="#" onclick="getTab(this,3)" >事故整改</a></li> 
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton> --%>
			  </tr>
			</table>
			<form action="" id="form0" name="form0" method="post" target="record">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    		<tr>
			     		<input type="hidden" name="accident_id" id="accident_id" value="" />
			     		<input type="hidden" name="project_info_no" id="project_info_no" value="" />
				    	<td class="inquire_item6">项目名称:</td>
				    	<td class="inquire_form6"><input name="project_name" id="project_name" type="text" class="input_width" value="" disabled="disabled"/></td>
				    	<td class="inquire_item6">填报标题:</td>
				    	<td class="inquire_form6"><input name="accident_title" id="accident_title" type="text" class="input_width" value="质量事故汇总表" disabled="disabled"/></td>
				    	<td class="inquire_item6"><font color="red">*</font>填报单位:</td>
				    	<td class="inquire_form6"><input name="org_id" id="org_id" type="text" class="input_width" value="" /></td>
				    </tr>
				    <tr>
				    	<td class="inquire_item6"><font color="red">*</font>填报日期:</td>
				    	<td class="inquire_form6"><input name="report_date" id="report_date" type="text" class="input_width" value="<%=nowDate %>" readonly="readonly" />
				    		<!--<img width="16" height="16" id="cal_button7" style="cursor: hand;" 
				    		onmouseover="calDateSelector(report_date,cal_button7);"  src="<%=contextPath %>/images/calendar.gif" />-->
				    	</td>
				    	<td class="inquire_item6"><font color="red">*</font>单位领导姓名:</td>
				    	<td class="inquire_form6"><input name="leader_id" id="leader_id" type="text" class="input_width" value="" /></td>
				    	<td class="inquire_item6"><font color="red">*</font>分管领导姓名:</td>
				    	<td class="inquire_form6"><input name="super_id" id="super_id" type="text" class="input_width" value="" /></td>
				    </tr>
				    <tr>	
				    	<td class="inquire_item6">办公电话:</td>
				    	<td class="inquire_form6"><input name="office_num" id="office_num" type="text" class="input_width" value="" /></td>
				    	<td class="inquire_item6"><font color="red">*</font>质量管理部门:</td>
				    	<td class="inquire_form6"><input name="depart_id" id="depart_id" type="text" class="input_width" value="" /></td>
				    	<td class="inquire_item6"><font color="red">*</font>负责人姓名:</td>
				    	<td class="inquire_form6"><input name="charge_id" id="charge_id" type="text" class="input_width" value="" /></td>
				     </tr>
				  	<tr>
				  		<td class="inquire_item6"><font color="red">*</font>一般质量事故次数:</td>
				    	<td class="inquire_form6"><input name="small_num" id="small_num" type="text" class="input_width" value="" 
				    		onkeydown="javascript:return checkIfNum(event);"/></td>
				    	<td class="inquire_item6">累计直接经济损失（万元）:</td>
				    	<td class="inquire_form6"><input name="small_loss" id="small_loss" type="text" class="input_width" value="" 
							onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
						<td class="inquire_item6">办公电话、手机:</td>
				    	<td class="inquire_form6"><input name="office_tel" id="office_tel" type="text" class="input_width" value="" /></td>
				    </tr>
				  	<tr>
				  		<td class="inquire_item6"><font color="red">*</font>较大质量事故次数:</td>
				    	<td class="inquire_form6"><input name="large_num" id="large_num" type="text" class="input_width" value="" 
				    		onkeydown="javascript:return checkIfNum(event);"/></td>
				    	<td class="inquire_item6">累计直接经济损失（万元）:</td>
				    	<td class="inquire_form6"><input name="large_loss" id="large_loss" type="text" class="input_width" value="" 
							onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
				    	<td class="inquire_item8">国家不合格批次:</td>
				    	<td class="inquire_form8"><input name="nation" id="nation" type="text" class="input_width" value="" /></td>
				    </tr>
				  	<tr>
				  		<td class="inquire_item6"><font color="red">*</font>重大质量事故次数:</td>
				    	<td class="inquire_form6"><input name="great_num" id="great_num" type="text" class="input_width" value="" 
				    		onkeydown="javascript:return checkIfNum(event);"/></td>
				    	<td class="inquire_item6">累计直接经济损失（万元）:</td>
				    	<td class="inquire_form6"><input name="great_loss" id="great_loss" type="text" class="input_width" value="" 
				    		onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
				    	<td class="inquire_item8">省(市、自治区)不合格批次:</td>
				    	<td class="inquire_form8"><input name="province" id="province" type="text" class="input_width" value="" /></td>
				    </tr>
				  	<tr>
				    	<td class="inquire_item6"><font color="red">*</font>特大质量事故次数:</td>
				    	<td class="inquire_form6"><input name="super_num" id="super_num" type="text" class="input_width" value="" 
				    		onkeydown="javascript:return checkIfNum(event);"/></td>
				    	<td class="inquire_item6">累计直接经济损失（万元）:</td>
				    	<td class="inquire_form6"><input name="super_loss" id="super_loss" type="text" class="input_width" value="" 
				    		onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
				    	<td class="inquire_item8">集团公司不合格批次:</td>
				    	<td class="inquire_form8"><input name="corporation" id="corporation" type="text" class="input_width" value="" /></td>
				    </tr>
				  	<tr>
				  		<td class="inquire_item8">备注:</td>
				    	<td class="inquire_form8"><input name="spare1" id="spare1" type="text" class="input_width" value="" /></td>
				    </tr>
				</table>
			</form> 
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
			<iframe width="100%" height="100%" name="report" id="report" frameborder="0" src="" marginheight="0" marginwidth="0" >
			</iframe>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <auth:ListButton functionId="" css="bc" event="onclick='newSubmit()'" title="保存"></auth:ListButton>
			  </tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			    	<td class="inquire_item4"><font color="red">*</font>整改完成日期:</td>
			    	<td class="inquire_form4"><input name="change_date" id="change_date" type="text" class="input_width" value="" readonly="readonly" />
			    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" 
			    		onmouseover="calDateSelector(change_date,cal_button7);"  src="<%=contextPath %>/images/calendar.gif" /></td>
			    	<td class="inquire_item4"><font color="red">*</font>填报人:</td>
			    	<td class="inquire_form4"><input name="change_id" id="change_id" type="text" class="input_width" value="" /></td>
			    </tr>
			  	<tr>
			  		<td class="inquire_item4">处理情况说明:</td>
			    	<td class="inquire_form4" colspan="3"><textarea rows="" cols="" class="textarea" id="change_note" name="change_note"></textarea></td>
			    </tr>
			</table>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getAccidentList";
	var org_id = '';
	function refreshData(orgId){
		var project_id  = '<%=project_info_no%>';
		if(project_id ==''){
			alert("请选择项目");
			return;
		}
		var project_name  = '<%=project_name%>';
		org_id = orgId;
		document.getElementById("project_info_no").value = project_id;
		document.getElementById("project_name").value = project_name;
		cruConfig.submitStr = "project_info_no="+project_id;
		setTabBoxHeight();
		queryData(1);
	}
	refreshData('');
	/* 详细信息 */
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
		var retObj = jcdpCallService("QualityItemsSrv","getAccidentDetail", "accident_id=" + id);
		document.getElementById("report").src = "<%=contextPath%>/qua/sProject/accident/reportList.jsp?accident_id="+id;
		document.getElementById("accident_id").value = id;
		document.getElementById("org_id").value = retObj.accidentDetail.orgId;
		document.getElementById("report_date").value = retObj.accidentDetail.reportDate;
		document.getElementById("leader_id").value = retObj.accidentDetail.leaderId;
		document.getElementById("super_id").value = retObj.accidentDetail.superId;
		document.getElementById("office_num").value = retObj.accidentDetail.officeNum;
		document.getElementById("depart_id").value = retObj.accidentDetail.departId;
		document.getElementById("charge_id").value = retObj.accidentDetail.chargeId;
		document.getElementById("office_tel").value = retObj.accidentDetail.officeTel;
		document.getElementById("small_num").value = retObj.accidentDetail.smallNum;
		document.getElementById("small_loss").value = retObj.accidentDetail.smallLoss;
		document.getElementById("large_num").value = retObj.accidentDetail.largeNum;
		document.getElementById("large_loss").value = retObj.accidentDetail.largeLoss;
		document.getElementById("great_num").value = retObj.accidentDetail.greatNum;
		document.getElementById("great_loss").value = retObj.accidentDetail.greatLoss;
		document.getElementById("super_num").value = retObj.accidentDetail.superNum;
		document.getElementById("super_loss").value = retObj.accidentDetail.superLoss;
		document.getElementById("nation").value = retObj.accidentDetail.nation;
		document.getElementById("province").value = retObj.accidentDetail.province;
		document.getElementById("corporation").value = retObj.accidentDetail.corporation;
		document.getElementById("spare1").value = retObj.accidentDetail.spare1;
		document.getElementById("change_date").value = retObj.accidentDetail.changeDate;
		document.getElementById("change_id").value = retObj.accidentDetail.changeId;
		document.getElementById("change_note").value = retObj.accidentDetail.changeNote;
		var accident_num =retObj.accidentDetail.smallNum-(-retObj.accidentDetail.largeNum)-(-retObj.accidentDetail.greatNum)-(-retObj.accidentDetail.superNum);
		if(accident_num>0){
			alert("请填写"+accident_num+"张事故报告单");
		}
	}
	/* 修改 */
	function newSubmit() {
		var accident_id = document.getElementById("accident_id").value;
		if(accident_id==null || accident_id==""){
			alert("请选择一条质量事故!");
			return;
		}
		var obj = document.getElementById("change_date") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("整改完成日期不能为空!");
			return ;
		}
		obj = document.getElementById("change_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("填报人不能为空!");
			return ;
		}
		var change_date = document.getElementById("change_date").value;
		var change_id = document.getElementById("change_id").value;
		var change_note = document.getElementById("change_note").value;
		var sql = "update bgp_qua_accident t set t.change_date=to_date('"+change_date+"','yyyy-MM-dd') ,t.change_id='"+change_id+"' ,t.change_note='"+change_note+"' where t.accident_id='"+accident_id+"'";
		var retObj = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+sql);
		if(retObj!=null && retObj.returnCode=='0'){
			alert("修改成功");
		}
	}
	function checkValue(){
		var obj = document.getElementById("org_id") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("填报单位不能为空!");
			return false;
		}
		obj = document.getElementById("report_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("填报日期不能为空!");
			return false;
		}
		obj = document.getElementById("leader_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("单位领导不能为空!");
			return false;
		}
		obj = document.getElementById("super_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("分管领导不能为空!");
			return false;
		}
		obj = document.getElementById("depart_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("质量管理部门不能为空!");
			return false;
		}
		obj = document.getElementById("charge_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("负责人不能为空!");
			return false;
		}
		obj = document.getElementById("small_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("一般质量事故次数不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("small_loss").value = '0';
		}
		obj = document.getElementById("large_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("较大质量事故不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("large_loss").value = '0';
		}
		obj = document.getElementById("great_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("重大质量事故次数不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("great_loss").value = '0';
		}
		obj = document.getElementById("super_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("特大质量事故次数不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("super_loss").value = '0';
		}
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function toAdd() { 
		if(document.getElementById("project_name")==null || document.getElementById("project_name").value ==''){
			alert("请选择项目!");
			return;
		}
		var project_info_no = document.getElementById("project_info_no").value;
		var projectName = document.getElementById("project_name").value;
		popWindow("<%=contextPath%>/qua/sProject/accident/accidentEdit.jsp");
	}
	function toEdit() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var accident_id = '';
		for (var i = 1;i< objLen-1 ;i++){   
		    if (obj [i].checked==true) { 
		    	accident_id=obj [i].value;
				var project_info_no = document.getElementById("project_info_no").value;
				var projectName = document.getElementById("project_name").value;
				popWindow("<%=contextPath%>/qua/sProject/accident/accidentEdit.jsp?accident_id="+accident_id);
				return;
		  	}   
		} 
		alert("请选择修改的记录!")
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var accident_id = '';
		var substr = '';
		if(window.confirm("你确定要删除?")){
			for (var i = objLen-2;i > 0;i--){  
				if (obj [i].checked==true) { 
					accident_id=obj [i].value;
			    	var sql = "update bgp_qua_accident t set t.bsflag = '1' where t.accident_id='"+accident_id+"';";
					substr = substr + sql;
				}
			}
			var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+substr);
			if(retObj!=null && retObj.returnCode =='0'){
				alert("删除成功!");
			}
		}
		refreshData();
	}
	function reportShow(accident_id){
		popWindow('<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=QUA_ACCIDENT_S&noLogin=admin&tokenId=admin&KeyId='+accident_id,'1085:720');
	}
	function frameSize(){
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

</body>
</html>
