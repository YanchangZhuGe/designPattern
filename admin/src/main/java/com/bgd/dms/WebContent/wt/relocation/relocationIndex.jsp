<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}

	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>项目资源配置方案</title>
</head>

<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td class="ali_cdn_name"></td>
				    <td class="ali_cdn_input"></td>
				    <td class="ali_cdn_name"></td>
				    <td class="ali_cdn_input"></td>
				    <td class="ali_cdn_name"></td>
				    <td class="ali_cdn_input"></td>
				    <td class="ali_cdn_name"></td>
				    <td class="ali_cdn_input"></td>
				    <td class="ali_query">
				    </td>
				    <td class="ali_query">
				    </td>
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
				    <auth:ListButton functionId="" css="xg" event="onclick='toMod()'" title="编辑"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDel()'" title="删除"></auth:ListButton>
				     <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
				    <auth:ListButton functionId="" css="dc" event="onclick='toPrint()'" title="打印动迁申请书"></auth:ListButton>
				  </tr>
				</table>
				</td>
				    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				  </tr>
				</table>
			</div>
			
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="tableHeaderId">
			    <tr>
			      <td class="bt_info_odd" >项目名称</td>
			      <td class="bt_info_odd" >施工地区</td>
			      <td class="bt_info_odd" >勘探方法</td>
			      <td class="bt_info_odd" >施工队伍</td>
			      <td class="bt_info_odd" >队经理</td>
			      <td class="bt_info_odd">申请日期</td>
			      <td class="bt_info_odd">审批状态</td>
			    </tr>
			    <tr>
			     
			      <td id="td_project_name" class="odd_odd" ></td>
			      <td id="td_construction_area" class="odd_even" ></td>
			      <td id="td_method_code" class="odd_odd" ></td>
			      <td id="td_work_team" class="odd_even" ></td>
			     <td id="td_team_manager" class="odd_odd" ></td>
			      <td id="td_create_date" class="odd_even" ></td>
			     <td id="td_status" class="odd_odd" ></td>
			    </tr>
			  </table>
			</div>
			
			
			
			<%---########################################## 属性标签页头  ################################################ --%>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">设备配置</a></li>
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">人员配置</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			  </ul>
			</div>
			<%---########################################## 属性标签页头END  ################################################ --%>
			
			
			
			
			
			<div id="tab_box" class="tab_box">
			
			
			
			<%---########################################## 0基本信息 ################################################ --%>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					
			
					  <tr>
					    <td class="inquire_item6">项目名称：</td>
					    <td class="inquire_form6">
						    <input type="text" id="project_name" name="project_name" class="input_width" readonly="readonly" disabled="disabled"/>
					    </td>
					    <td class="inquire_item6">施工地区：</td>
					    <td class="inquire_form6"><input type="text" id="construction_area" name="construction_area" class="input_width"  disabled="disabled" readOnly="readonly"/></td>
					    <td class="inquire_item6">勘探方法：</td>
					    <td class="inquire_form6"><input type="text" id="method_code" name="method_code" class="input_width" readonly="readonly" disabled="disabled"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">施工队伍：</td>
						<td class="inquire_form6"><input type="text" id="work_team" name="work_team" class="input_width" readonly="readonly" disabled="disabled"/></td>
					    <td class="inquire_item6">队经理：</td>
						<td class="inquire_form6" id="item0_19"><input type="text" id="team_manager" name="team_manager" class="input_width" readonly="readonly" disabled="disabled"/></td>
					    <td class="inquire_item6">申请日期：</td>
					    <td class="inquire_form6"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly" disabled="disabled"/></td>
					  </tr>
					  <tr>
					  <%-- 
						<td class="inquire_item6">审批状态：</td>
						<td class="inquire_form6"><input type="text" id="status" name="status" class="input_width" readonly="readonly" disabled="disabled"/></td>
						--%>
					    <td class="inquire_item6"></td>
						<td class="inquire_form6"></td>
						 <td class="inquire_item6"></td>
						<td class="inquire_form6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">主要技术资料清单：</td>
						<td class="inquire_form6" colspan="5"><input name="technical_data" id="technical_data" class="input_width" type="file"  /><div id="file1"></div></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">动迁计划：</td>
						<td class="inquire_form6" colspan="5"><input name="relocation_plan" id="relocation_plan" class="input_width" type="file"  /><div id="file2"></div></td>
					  </tr>
					</table>
				</div>
				<%---########################################## 基本信息END ################################################ --%>
				
				
				
				<%---########################################## 1设备配置 ################################################ --%>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="devList" id="devList" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<%---########################################## 设备配置END ################################################ --%>
				
				<%---########################################## 2人员配置  ################################################ --%>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="peopleList" id="peopleList" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<%---########################################## 人员配置END  ################################################ --%>
				
				
				<%---########################################## 3审批流程  ################################################ --%>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
					
				</div>
				<%---########################################## 审批流程END  ################################################ --%>
				
				
				<%---########################################## 备注  ################################################ --%>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<%---########################################## 备注END  ################################################ --%>
				
			</div>
		  </div>

</body>
<script type="text/javascript">
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

<script type="text/javascript">



//得到当前记录的id 用来取备注信息
	var projectInfoNo = "<%=projectInfoNo%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var delDeviceIds="";
	var delHumanIds="";


	var relocationId = '';//记录ID
	var relocationStatus = '';//记录审批状态
	
	
	function refreshData(){

		relocationId = '';//记录ID
		relocationStatus = '';//记录审批状态
		clearLoadData();
		//1查询GP_WT_PROJECT_RELOCATION
		// 取数据 只有一条
		var retObj = jcdpCallService("WtRelocationSrv", "getRelocationData", "");

		if(retObj.relocationMap!=null){
			processNecessaryInfo={         
	    		businessTableName:"gp_wt_project_relocation",    //置入流程管控的业务表的主表表明
	    		businessType:"5110000004100000093",       //业务类型 即为之前设置的业务大类
	    		businessId:retObj.relocationMap.id,         //业务主表主键值
	    		businessInfo:retObj.relocationMap.project_name+'动迁申请',        //用于待审批界面展示业务信息
	    		applicantDate:'<%=appDate%>'       //流程发起时间
	    	}; 
	    	processAppendInfo={ 
	   			id:retObj.relocationMap.id,	
	   			action:'view',
				projectInfoNo:retObj.relocationMap.project_info_no,
				projectName:retObj.relocationMap.project_name
	    	};
		    loadProcessHistoryInfo();

		    

			document.getElementById("td_project_name").innerText =retObj.relocationMap.project_name;
			document.getElementById("td_construction_area").innerText =retObj.relocationMap.construction_area;
			//document.getElementById("td_method_code").innerText =retObj.relocationMap.method_code;
			document.getElementById("td_method_code").innerText =retObj.relocationMap.method_code;
			
			document.getElementById("td_work_team").innerText =retObj.relocationMap.work_team;
			document.getElementById("td_team_manager").innerText =retObj.relocationMap.team_manager;
			document.getElementById("td_create_date").innerText =retObj.relocationMap.create_date;
			document.getElementById("td_status").innerText =retObj.relocationMap.proc_status_name;
			

			
			
			relocationId = retObj.relocationMap.id;//记录ID
			relocationStatus = retObj.relocationMap.proc_status;//审核状态


			setTab0();
			
			<%--
			
			//tr.insertCell().innerHTML =retObj.relocationMap.vsp_team_no;
			//tr.insertCell().innerHTML =retObj.relocationMap.creator;


			--%>
			
						//rsMap.put("technical_data", fileUcmId);//主要技术资料清单
						//rsMap.put("relocation_plan", fileUcmId);//动迁计划
			
			
		}

	}

	//设置数据
	function setTab0(){
		var retObj = jcdpCallService("WtRelocationSrv", "getRelocationData", "");
		if(retObj.relocationMap!=null){
			document.getElementById("project_name").innerText =retObj.relocationMap.project_name;
			document.getElementById("construction_area").innerText =retObj.relocationMap.construction_area;
			document.getElementById("method_code").innerText =retObj.relocationMap.method_code;
			document.getElementById("work_team").innerText =retObj.relocationMap.work_team;
			document.getElementById("team_manager").innerText =retObj.relocationMap.team_manager;
			document.getElementById("create_date").innerText =retObj.relocationMap.create_date;
			//document.getElementById("status").innerText =retObj.relocationMap.status;

			if(retObj.relocationMap.technical_data!=null&&retObj.relocationMap.technical_data!=''){
				document.getElementById("file1").innerHTML ="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj.relocationMap.technical_data+"&emflag=0>"+retObj.relocationMap.technical_data_filename+"</a>";
			}
			if(retObj.relocationMap.relocation_plan!=null&&retObj.relocationMap.relocation_plan!=''){
				document.getElementById("file2").innerHTML ="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj.relocationMap.relocation_plan+"&emflag=0>"+retObj.relocationMap.relocation_plan_filename+"</a>";
			}

			
		}
	}
	function clearLoadData(){
		document.getElementById("project_name").innerText ="";
		document.getElementById("construction_area").innerText ="";
		document.getElementById("method_code").innerText ="";
		document.getElementById("work_team").innerText ="";
		document.getElementById("team_manager").innerText ="";
		document.getElementById("create_date").innerText ="";
		//document.getElementById("status").innerText ="";
	}
	<%----------------------------------------------------------------------------------------%>
	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		
		if(index == 1){
			$("#devList").attr("src","<%=contextPath%>/pm/project/multiProject/wt/resourcesDev.jsp?projectInfoNo="+projectInfoNo);
		}else if(index == 2 ){
			$("#peopleList").attr("src","<%=contextPath%>/pm/project/multiProject/wt/resourcesHuman.jsp?projectInfoNo="+projectInfoNo);
		}else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+relocationId);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function toAdd(){
		//先判断当前项目是否以存在动迁信息
		if(relocationId!=null&&relocationId!=''){
			//不存在则弹出页面
			alert("已存在动迁申请,不能重复添加!");
		}else{
			popWindow('<%=contextPath%>/wt/relocation/relocationAdd.jsp','1050:680');
		}
	}

	function toDel(){

		if(relocationStatus == '1' || relocationStatus == '3'){
			alert("该信息已提交!");
			return;
		}

		if(relocationId!=null&&relocationId!=''){
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("WtRelocationSrv", "delRelocationData", "rid="+relocationId);
				
			}
			if(retObj.issuccess=='ok'){
				alert("删除操作成功!");
				relocationId = '';//记录ID
				relocationStatus = '';
				document.getElementById("td_project_name").innerText ='';
				document.getElementById("td_construction_area").innerText ='';
				document.getElementById("td_method_code").innerText ='';
				document.getElementById("td_work_team").innerText ='';
				document.getElementById("td_team_manager").innerText='';
				document.getElementById("td_create_date").innerText ='';
				document.getElementById("td_status").innerText ='';
				clearLoadData();
			}
		}else{
			alert("不存在动迁申请!");
		}
	}

	function toMod(){
		if(relocationId==''){
			alert("无动迁计划");
			return;
		}

		
		if(relocationStatus == '1' || relocationStatus == '3'){
			alert("该信息已提交!");
			return;
		}
		
			//未提交 可修改
			popWindow('<%=contextPath%>/wt/relocation/relocationAdd.jsp?id='+relocationId,'1050:680');
	}

	function toSubmit(){
		if(relocationId!=null&&relocationId!=''){
		

			if (!window.confirm("确认要提交吗?")) {
				return;
			}		
			submitProcessInfo();
			refreshData();
		}else{
			alert("无动迁申请数据!");
		}
	}

	

	function toPrint(){
		if(relocationId==''){
			alert("无动迁计划");
			return;
		}
		window.open("<%=contextPath%>/wt/relocation/printRelocationApply.jsp?projectInfoNo="+projectInfoNo,"打印","toolbar=no,left=350,top=150,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=800,height=900");
	}

	


	
	
	
	
	
<%--------------------------------------------------------------------------------------------------------------
function toPrint(){
		ids = getSelectedValue();
		alert(ids.split("-")[0]);
		window.open("<%=contextPath%>/wt/pm/project/multiProject/viewResources.jsp?resourcesId="+ids.split("-")[0],"打印","toolbar=no,left=350,top=150,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=1000");
	}
	//简单查询
	function simpleRefreshData(){
		var projectName = document.getElementById("projectName").value;
		var str = "";
		if(''!=projectName){
			str += " and p.project_name like '%"+projectName+"%' ";
		}
		refreshData(str);
	}

//列表页面选中
	function loadDataDetail(ids){
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		clearLoadData();
		var retObj = jcdpCallService("WtProjectResourcesSrv", "getProjectResourcesInfo", "resourcesId="+ids.split("-")[0]);

	    
	    

	    document.getElementById("resources_id").value= retObj.map.resources_id;
	    document.getElementById("project_info_no").value= retObj.map.project_info_no;
	    document.getElementById("project_name").value= retObj.map.project_name;
	    document.getElementById("org_name").value= retObj.orgMap.org_name;
	    document.getElementById("working_group").value= retObj.map.working_group;
	    document.getElementById("team_manager").value= retObj.map.team_manager;
	    document.getElementById("instructor").value= retObj.map.instructor;
	    document.getElementById("time_limit").value= retObj.map.time_limit;
	    document.getElementById("work_load").value= retObj.map.work_load;
	    document.getElementById("landform").value= retObj.map.landform;
	    document.getElementById("create_unit").value= retObj.map.create_unit;
	    document.getElementById("employee_name").value= retObj.map.employee_name;
	    document.getElementById("create_date").value= retObj.map.create_date;

		//设备配置信息
		$("#processtable0").html("");
		if(null!=retObj.deviceMap){
	    	addRows(retObj.deviceMap);
		}
		//人员配置信息
		$("#processtable1").html("");
		if(null!=retObj.humanMap){
	    	addRows1(retObj.humanMap);
		}
	}

	
	function clearLoadData(){
		document.getElementById("resourcesForm").reset();
		document.getElementById("deviceForm").reset();
		document.getElementById("humanForm").reset();
	}
	
	
//	var selectedTagIndex = 0;
//	var showTabBox = document.getElementById("tab_box_content0");
function clearQueryText(){
		document.getElementById("projectName").value = '';
	}
//---------------------------------- 设 备 配 置 ----------------------------------------------------------------------------
	function addRows(value){
		if(""==document.getElementById("resources_id").value){
			alert("请先选择一条项目信息!");
			return;
		}
		if(null!=value&& value !=undefined){
			for(var i=0;i<value.length;i++){
				var innerhtml = "";
				var unit=value[i].unit;
				innerhtml += "<tr id='tr"+i+"' name='tr"+i+"' collseq='"+i+"'>";
				innerhtml += "<td width='2%'><input type='checkbox' name='idinfo' id='"+i+"'/><input name='device_id"+i+"' id='device_id"+i+"' value='"+value[i].device_id+"' type='hidden' /></td>";
				innerhtml += "<td width='17%'><input name='device_name"+i+"' id='device_name"+i+"' value='"+value[i].device_name+"' type='text' /></td>";
				innerhtml += "<td width='7%'><input name='neednum"+i+"' id='neednum"+i+"' value='"+value[i].neednum+"' size='4' type='text' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/></td>";
				innerhtml += "<td width='7%'><select name='unit"+i+"' id='unit"+i+"' /></select></td>";
				innerhtml += "<td width='16%'><input name='device_code"+i+"' id='device_code"+i+"' value='"+value[i].device_code+"' type='text' /></td>";
				innerhtml += "<td width='11%'><input name='memo"+i+"'  id='memo"+i+"' value='"+value[i].memo+"' type='text'/></td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
				//查询公共代码，并且回填到界面的单位中
				var retObj;
				var unitSql = "select sd.coding_code_id,coding_name "+
					"from comm_coding_sort_detail sd where coding_sort_id ='5110000038' order by coding_code";
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
				retObj = unitRet.datas;
				var optionhtml = "";
				for(var index=0;index<retObj.length;index++){
					if(retObj[index].coding_code_id ==unit){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
					}
					else{
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
					}
				}
					$("#unit"+i).append(optionhtml);
			}
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
			}
		else{
			tr_id = $("#processtable0>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
			innerhtml += "<td width='2%'><input type='checkbox' name='idinfo' id='"+tr_id+"'/>";
			innerhtml += "<td width='17%'><input name='device_name"+tr_id+"' id='device_name"+tr_id+"' value='' type='text' /></td>";
			innerhtml += "<td width='7%'><input name='neednum"+tr_id+"' id='neednum"+tr_id+"' value='' size='4' type='text' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/></td>";
			innerhtml += "<td width='7%'><select name='unit"+tr_id+"' id='unit"+tr_id+"' /></select></td>";
			innerhtml += "<td width='16%'><input name='device_code"+tr_id+"' id='device_code"+tr_id+"' value='' type='text' /></td>";
			innerhtml += "<td width='11%'><input name='memo"+tr_id+"' id='memo"+tr_id+"' value='' type='text'/></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
			//查询公共代码，并且回填到界面的单位中
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name "+
				"from comm_coding_sort_detail sd "+
				"where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#unit"+tr_id).append(optionhtml);
			
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		}
	};

//---------------------------------- 人员 配 置 ----------------------------------------------------------------------------

function delRows(){
		$("input[name='idinfo']").each(function(){
			if(this.checked){
				delDeviceIds +=$("#device_id"+this.id).val()+","
				$('#tr'+this.id,"#processtable0").remove();
			}
		});
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	
	function toUpdateDevice(){
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	

		if(ids.split("-")[2] == '1' || ids.split("-")[2] == '3'){
			alert("该信息已提交!");
			return;
		}
		
		var numflag = "1";
		$("input[type='text'][name^='device_name']").each(function(){
			if(this.value == ""){
				numflag = "12";
				return;
			}
		});
		if(numflag == "12"){
			alert("请选择设备名称和规格型号!");
			return false;
		}
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		$("input[type='text'][name^='neednum']").each(function(){
			if(this.value == ""){
				numflag = "2";
				return;
			}
		});
		if(numflag == "2"){
			alert("申请数量不能为空!");
        	return false;
		}

		//保留按量的行信息
		var collcount = 0;
		var collline_infos = '';
		$("tr","#processtable0").each(function(){
			if(this.collseq!=undefined){
				if(collcount == 0){
					collline_infos = this.collseq;
				}else{
					collline_infos = collline_infos+"~"+this.collseq;
				}
				collcount++;
			}
		});
		if(collcount == 0){
			alert('请添加设备配置明细！');
			return;
		}
		var params = $("#deviceForm").serialize();
		params+="&resourcesId="+document.getElementById("resources_id").value;
		params+="&collcount="+collcount;
		params+="&collline_infos="+collline_infos;
		params+="&delDeviceIds="+delDeviceIds;
		var obj = jcdpCallService("WtProjectResourcesSrv", "saveDeviceResources",params);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}

	function addRows1(value){
		if(""==document.getElementById("resources_id").value){
			alert("请先选择一条项目信息!");
			return;
		}
		if(null!=value&& value !=undefined){
			for(var i=0;i<value.length;i++){
				var innerhtml = "";
				//var unit=value[i].unit;
				var team=value[i].human_team;
				var post=value[i].human_post;
				innerhtml += "<tr id='tr"+i+"' name='tr"+i+"' collseq='"+i+"'>";
				innerhtml += "<td width='2%'><input type='checkbox' name='idinfo' id='"+i+"'/><input name='human_id"+i+"' id='human_id"+i+"' value='"+value[i].human_id+"' type='hidden' /></td>";
				innerhtml += "<td width='25%'><select style='width:120px' name='human_team"+i+"' id='human_team"+i+"' onchange='changeTeam("+i+")'/></select></td>";
				innerhtml += "<td width='30%'><select style='width:200px' name='human_post"+i+"' id='human_post"+i+"' /></select></td>";
				innerhtml += "<td width='15%'><input name='human_nums"+i+"' id='human_nums"+i+"' value='"+value[i].human_nums+"' size='8' type='text' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/></td>";
				innerhtml += "<td><input name='note"+i+"' id='note"+i+"' value='"+value[i].note+"' type='text'/></td>";
				innerhtml += "</tr>";
				$("#processtable1").append(innerhtml);
				//查询公共代码，并且回填到界面的班组中
				var retObj;
				var teamSql="select t.coding_code_id,t.coding_name from comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2  order by t.coding_show_id";
				var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
				retObj = teamRet.datas;
				var optionhtml = "";
				for(var index=0;index<retObj.length;index++){
					if(retObj[index].coding_code_id ==team){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
					}
					else{
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
					}
				}
				$("#human_team"+i).append(optionhtml);
				//查询公共代码，并且回填到界面的岗位中
				var postSql="select t.coding_code_id,t.coding_name from comm_coding_sort_detail t, (select coding_sort_id, coding_code  from comm_coding_sort_detail where coding_code_id = '"+team+"' and bsflag='0' ) d where t.coding_sort_id = d.coding_sort_id and t.bsflag = '0' and t.coding_code like d.coding_code || '__' order by t.coding_show_id";
				var postRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+postSql+'&pageSize=1000');
				retObj = postRet.datas;
				var posthtml = "";
				for(var index=0;index<retObj.length;index++){
					
					if(retObj[index].coding_code_id ==post){
						posthtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
					}
					else{
						posthtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
					}
				}
				$("#human_post"+i).append(posthtml);
			}
				$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable1>tr:odd>td:even").addClass("odd_even");
				$("#processtable1>tr:even>td:odd").addClass("even_odd");
				$("#processtable1>tr:even>td:even").addClass("even_even");
			}
		else{
			tr_id = $("#processtable1>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
			innerhtml += "<td width='2%'><input type='checkbox' name='idinfo' id='"+tr_id+"'/>";
			innerhtml += "<td width='25%'><select style='width:120px' name='human_team"+tr_id+"' id='human_team"+tr_id+"' onchange='changeTeam("+tr_id+")'/></select></td>";
			innerhtml += "<td width='30%'><select style='width:200px' name='human_post"+tr_id+"' id='human_post"+tr_id+"' /></select></td>";
			innerhtml += "<td width='15%'><input name='human_nums"+tr_id+"' id='human_nums"+tr_id+"' value='' size='8' type='text' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/></td>";
			innerhtml += "<td><input name='note"+tr_id+"' id='note"+tr_id+"' value='' type='text'/></td>";
			innerhtml += "</tr>";
			$("#processtable1").append(innerhtml);
			//查询公共代码，并且回填到界面的班组中
			var teamSql="select t.coding_code_id,t.coding_name from comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2  order by t.coding_show_id";
			var retObj;
			var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			retObj = teamRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#human_team"+tr_id).append(optionhtml);
			//查询公共代码，并且回填到界面的岗位中
			var postSql="select t.coding_code_id,t.coding_name from comm_coding_sort_detail t, (select coding_sort_id, coding_code  from comm_coding_sort_detail where coding_code_id = '0110000001000000001' and bsflag='0' ) d where t.coding_sort_id = d.coding_sort_id and t.bsflag = '0' and t.coding_code like d.coding_code || '__' order by t.coding_show_id";
			var postRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+postSql+'&pageSize=1000');
			retObj = postRet.datas;
			var posthtml = "";
			for(var index=0;index<retObj.length;index++){
				posthtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#human_post"+tr_id).append(posthtml);
			$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable1>tr:odd>td:even").addClass("odd_even");
			$("#processtable1>tr:even>td:odd").addClass("even_odd");
			$("#processtable1>tr:even>td:even").addClass("even_even");
		}
	};
function changeTeam(tr_id){
	    var applyTeam = "applyTeam="+getElementByTypeAndName('SELECT','human_team'+tr_id).value;  
		var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);
	 	var well_num_control = getElementByTypeAndName('SELECT','human_post'+tr_id);
	 	var len=well_num_control.options.length;
		for(var i=0;i<len;i++){
			well_num_control.options.remove(0);
		}
		if(applyPost.detailInfo!=null){
			for(var i=0;i<applyPost.detailInfo.length;i++){
				var templateMap = applyPost.detailInfo[i];
				well_num_control.options[well_num_control.options.length]=new Option(templateMap.label,templateMap.value); 
			}
		}
	}
function delRows1(){
		$("input[name='idinfo']").each(function(){
			if(this.checked){
				delHumanIds +=$("#human_id"+this.id).val()+","
				$('#tr'+this.id,"#processtable1").remove();
			}
		});
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
	};
function toUpdateHuman(){
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	

		if(ids.split("-")[2] == '1' || ids.split("-")[2] == '3'){
			alert("该信息已提交!");
			return;
		}
		
		//保留按量的行信息
		var collcount = 0;
		var collline_infos = '';
		$("tr","#processtable1").each(function(){
			if(this.collseq!=undefined){
				if(collcount == 0){
					collline_infos = this.collseq;
				}else{
					collline_infos = collline_infos+"~"+this.collseq;
				}
				collcount++;
			}
		});
		if(collcount == 0){
			alert('请添加人员配置明细！');
			return;
		}

		var numflag = "1";
		$("input[type='text'][name^='human_nums']").each(function(){
			if(this.value == ""){
				numflag = "2";
				return;
			}
		});
		if(numflag == "2"){
			alert("申请人数不能为空!");
        	return false;
		}
		
		var params = $("#humanForm").serialize();
		params+="&resourcesId="+document.getElementById("resources_id").value;
		params+="&collcount="+collcount;
		params+="&collline_infos="+collline_infos;
		params+="&delHumanIds="+delHumanIds;
		var obj = jcdpCallService("WtProjectResourcesSrv", "saveHumanResources",params);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
	function toUpdateResources(){
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	

		if(ids.split("-")[2] == '1' || ids.split("-")[2] == '3'){
			alert("该信息已提交!");
			return;
		}
		
		if(document.getElementById("tab_box_content0").style.display==""||document.getElementById("tab_box_content0").style.display=="block"){
			if(!checkText0()){
				return;
			}
		}
		if(document.getElementById("tab_box_content1").style.display==""||document.getElementById("tab_box_content1").style.display=="block"){
	        if (!isTextPropertyNotNull("notes", "地质任务")) return false;
		}
		var params = $("#resourcesForm").serialize();
		var obj = jcdpCallService("WtProjectResourcesSrv","saveProjectResources",params);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
	function checkText0() {
		if (!isTextPropertyNotNull("project_name", "项目名称")) return false;	
		if (!isValidFloatProperty12_0("working_group","作业组数量")) return false;  
		if (!isLimitB20("team_manager","队经理")) return false;  
		if (!isLimitB20("instructor","指导员")) return false;  
		if (!isLimitB100("time_limit","工期要求")) return false;  
		if (!isLimitB1000("work_load","工作量")) return false;  
		if (!isLimitB100("landform","地形")) return false;  
		return true;
	}
--%>
</script>

</html>