<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	UserToken user = OMSMVCUtil.getUserToken(request);
	//单项目
	String single =request.getParameter("single")==null?"":request.getParameter("single");
	String	projectInfoNo=request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
	String	projectName= request.getParameter("projectName")==null?user.getProjectName():java.net.URLDecoder.decode(request.getParameter("projectName"),"utf-8");
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
<title>无标题文档</title>
</head>

<body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <%if(!"0".equals(single)){ %>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="jl" event="onclick='toModifyDetail()'" title="编辑明细"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			    <%}%>
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
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{mid}-{proc_status}-{plan_id}-{device_addapp_id}' id='rdo_entity_id_{mid}'  onclick='chooseOne(this);' />" >选择</td>
			      	<td class="bt_info_even" exp="{plan_no}">人员配置单号</td>
			      	<td class="bt_info_odd" exp="{device_addapp_no}">设备配置单号</td>
			      	<td class="bt_info_odd" exp="{memo}">申请理由</td>
			      	<td class="bt_info_odd" exp="{create_date}">创建日期</td>
			      	<td class="bt_info_odd" exp="{proc_status_name}">审批状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">人员配置</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">设备配置</a></li>
		    	<li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item4">项目名称：</td>
							<td class="inquire_form4">
						    	<input type="hidden" id="resources_id" name="resources_id" />
							    <input type="hidden" id="project_info_no" name="project_info_no" value=""/>
							    <input type="text" id="project_name" name="project_name" value="" class="input_width" readonly="readonly"/>
					    	</td>
						    <td class="inquire_item4">施工队伍：</td>
						    <td class="inquire_form4"><input type="text" id="org_name" name="org_name" class="input_width" readonly="readonly"/></td>
					  	</tr>
					  	<tr>
					  	 	<td class="inquire_item4">作业组数量：</td>
							<td class="inquire_form4"><input type="text" value="" id="working_group" name="working_group" class="input_width" readonly="readonly"/></td>
					  		<td class="inquire_item4">队经理：</td>
							<td class="inquire_form4"><input type="text" id="team_manager" name="team_manager" class="input_width" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">副队经理：</td>
							<td class="inquire_form4"><input type="text" id="team_manager_f" name="team_manager_f" class="input_width" readonly="readonly"/></td>
							<td class="inquire_item4">指导员：</td>
							<td class="inquire_form4"><input type="text" id="instructor" name="instructor" class="input_width" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">工期要求：</td>
							<td class="inquire_form4"><input type="text" id="time_limit" name="time_limit" class="input_width" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">工作量：</td>
							<td id="item_workload" class="inquire_form4" colspan="3"></td>
						</tr>
					  	<tr>
					  		<td class="inquire_item4">地形：</td>
							<td id="item_landform" class="inquire_form4" colspan="3"></td>
					  	</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>计划人数<span id="people_number"></span></td>
				            <td>备注</td>
				        </tr>            
			        </table>
				</div>
				
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table id="devList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				            <td>设备名称</td>		
				            <td>规格型号</td>
				            <td>单位</td>
				            <td>需求数量</td>
				            <td>备注</td>
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
			</div>
		  </div>
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


	function dialogOpen(tt,w,h,src){
	var $parent = top.$;
//	alert($parent("#dialog").length)
	var dialogDiv = top.$("<div ></div>");
	var dialogContent = top.$("<iframe class=\"frame_dialog\" src=\""+src+"\" frameborder=\"0\" scrolling=\"yes\"></iframe>");
	if($parent("#dialog").length == 0)
		$parent("#dialog_wrap").append(dialogDiv);

	dialogDiv.append(dialogContent);
	dialogDiv.dialog({
		bgiframe: true,
		draggable:false,
		resizable: false,
		title: tt,
		height: h,
		width: w,
		modal: true,
		autoOpen : true
	});
	dialogDiv.bind('dialogclose', function(event, ui) {
	    refreshData();
	});
	dialogContent.css('width',w-35);
	top.topDialogs.push( [ dialogContent, dialogDiv ] );
}




	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var businessType="";
	var businessType_2 = "";
	var projectInfoNo="<%=projectInfoNo%>";
	var projectName="<%=projectName%>";
	var addFlag="1";
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function refreshData(){
		//首先要查询资源配置计划的审批状态  所以需要把businessType当做查询条件  这时候是资源配置计划的 businessType 而不是 资源补充计划的businessType
		var obj_ =  jcdpCallService("WtProjectSrv", "getProjectDep","projectInfoNo="+projectInfoNo);
		if(obj_.project_department!=null){
			var pro_dep = obj_.project_department;
			if(pro_dep=="C6000000000124"){//海外项目部
				businessType = "5110000004100001019";
				businessType_2="5110000004100001015";
			}
			if(pro_dep=="C6000000004707"){//工程项目部
				businessType = "5110000004100001016";
				businessType_2="5110000004100001012";
			}
			if(pro_dep=="C6000000005592"){//北疆项目部
				businessType = "5110000004100001022";
				businessType_2="5110000004100001013";
			}
			if(pro_dep=="C6000000005594"){//东部项目部
				businessType = "5110000004100001024";
				businessType_2="5110000004100001020";
			}
			if(pro_dep=="C6000000005595"){//敦煌项目部
				businessType = "5110000004100001023";
				businessType_2="5110000004100001018";
			}
			if(pro_dep=="C6000000005605"){//塔里木项目部
				businessType = "5110000004100001021";
				businessType_2="5110000004100001017";
			}
		}
		//查询基本信息
		var querySql = "select allapp.device_allapp_id, ";
		querySql += " nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += " from gms_device_allapp allapp left join common_busi_wf_middle wfmiddle on allapp.project_info_no=wfmiddle.business_id and wfmiddle.business_type='"+businessType+"'";
		querySql += " where allapp.bsflag='0' and allapp.project_info_no='"+projectInfoNo+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		basedatas = queryRet.datas;
		if(basedatas.length == 0){
			alert("该项目未填写项目资源配置,请检查!");
		}else if(basedatas.length == 1&&basedatas[0].proc_status == ''){
			alert("该项目未提交项目资源配置,请检查!");
		}else if(basedatas.length == 1&&basedatas[0].proc_status == '1'){
			alert("该项目提交的项目资源配置审批中，请查看审批信息!");
		}else if(basedatas.length == 1&&basedatas[0].proc_status == '4'){
			alert("该项目提交的项目资源配置审批不通过，请查看审批信息!");
		}else{
			addFlag="0";
		}

		cruConfig.queryStr = "select m.mid,m.memo,m.p.project_info_no,p.project_type,p.project_name,h.plan_id,h.plan_no,d.device_addapp_id,d.device_allapp_id,d.device_addapp_no,m.create_date,wf.proc_status,decode(wf.proc_status,'1','待审批','3','审批通过','4', '审批不通过','未提交') proc_status_name from gp_middle_resources m "+
			"left join bgp_comm_human_plan h on m.human_id=h.plan_id and h.bsflag='0' "+
			"left join gms_device_allapp_add d on m.dev_id=d.device_addapp_id and d.bsflag='0' "+
			"left join gp_task_project p on m.project_info_no=p.project_info_no and p.bsflag='0' "+
			"left join common_busi_wf_middle wf on m.mid=wf.business_id and wf.business_type='"+businessType_2+"' and wf.bsflag='0' "+
			"where m.supplyflag='0' and m.bsflag='0' ";
		if(""!=projectInfoNo){
			cruConfig.queryStr += "and m.project_info_no='"+projectInfoNo+"' ";
		}
		cruConfig.queryStr += " order by m.create_date desc ";
		queryData(1);

		//------------------------------基本信息-------------------------------
		var retObj = jcdpCallService("WtProjectSrv", "getProjectResourcesInfo","projectInfoNo="+projectInfoNo);
		if(retObj.map!=null){
			var pro_dep = retObj.map.project_department;
			//<option value="C6000000000124">海外项目部</option>
			//<option value="C6000000004707">工程项目部</option>
			//<option value="C6000000005592">北疆项目部</option>
			//<option value="C6000000005594">东部项目部</option>
			//<option value="C6000000005595">敦煌项目部</option>
			//<option value="C6000000005605">塔里木项目部</option>
			if(pro_dep=="C6000000000124"){
				businessType = "5110000004100001015";
			}
			if(pro_dep=="C6000000004707"){
				businessType = "5110000004100001012";
			}
			if(pro_dep=="C6000000005592"){
				businessType = "5110000004100001013";
			}
			if(pro_dep=="C6000000005594"){
				businessType = "5110000004100001020";
			}
			if(pro_dep=="C6000000005595"){
				businessType = "5110000004100001018";
			}
			if(pro_dep=="C6000000005605"){
				businessType = "5110000004100001017";
			}
		}
		
		document.getElementById("resources_id").value=retObj.map==null?"":retObj.map.resources_id;
	    document.getElementById("project_info_no").value=retObj.map==null?"":retObj.map.project_info_no;
	    document.getElementById("project_name").value=retObj.map==null?"":retObj.map.project_name;
	    document.getElementById("org_name").value=retObj.map==null?"":retObj.orgMap.org_name;
	    document.getElementById("working_group").value=retObj.map==null?"":retObj.map.working_group;
	    document.getElementById("team_manager").value=retObj.map==null?"":retObj.map.team_manager;
	    document.getElementById("team_manager_f").value=retObj.map==null?"":retObj.map.team_manager_f;
	    document.getElementById("instructor").value=retObj.map==null?"":retObj.map.instructor;
	    document.getElementById("time_limit").value=retObj.map==null?"":retObj.map.time_limit;
	    if(retObj.map!=null){
	    	var word_load=retObj.map.work_load==null?"":retObj.map.work_load;
		    word_load=word_load.replace(new RegExp("m2", 'g'),"m&sup2");
		    var landform=retObj.map.landform==null?"":retObj.map.landform;
		    landform=landform.replace(new RegExp("m2", 'g'),"m&sup2");
		    //工作量
		    document.getElementById("item_workload").innerHTML="<textarea id='work_load'  name='work_load' cols='63' rows='10' readonly='true'>"+word_load+"</textarea>";
		    //地形
		    document.getElementById("item_landform").innerHTML="<textarea id='landform' name='landform' cols='63' rows='5' readonly='true'>"+landform+"</textarea>";
	    }
	    
	}

	
	function loadDataDetail(ids){
		processNecessaryInfo={                          //流程引擎关键信息
			businessTableName:"gp_middle_resources",    //置入流程管控的业务表的主表表明
			businessType:businessType,                  //业务类型 即为之前设置的业务大类
			businessId:ids.split("-")[0],               // mid
			businessInfo:"项目资源补充配置",            //用于待审批界面展示业务信息
			applicantDate:"<%=appDate%>"                //流程发起时间
		};
		processAppendInfo={                             //流程引擎附加临时变量信息
			mid:ids.split("-")[0],
			projectInfoNo:projectInfoNo,
			action:"view",
			projectName:projectName
		};
		loadProcessHistoryInfo();

	    //--------------------人员配置---------------------------
		//计算合计人数
		var querySql1 = "select sum(nvl(d.people_number, 0)) people_number from bgp_comm_human_plan_detail d "+
			"where d.spare1='"+ids.split("-")[2]+"' and d.project_info_no='"+projectInfoNo+"' and d.bsflag='0' and d.resourceflag='0' ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql1);
		var datas1 = queryRet1.datas;
		if(null!=datas1&&datas1.length>0){
			$("#people_number").html(datas1[0].people_number==""?"":("(共"+datas1[0].people_number+"人)"));
		}

		
	    deleteTableTr("planDetailList");
	    var querySql="select rownum,d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums,d.notes "+
			"from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' "+
			"left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' "+
			"where d.spare1='"+ids.split("-")[2]+"' "+
			"and d.project_info_no='"+projectInfoNo+"' and d.bsflag='0' and d.resourceflag='0'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
	    if(null!=datas){
			for (var i = 0; i< queryRet.datas.length;i++) {
				var tr = document.getElementById("planDetailList").insertRow();		
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].apply_team_name;
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].post_name;
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].people_number;
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].notes;
			}
		}	

	    //--------------------设备配置---------------------------
	    deleteTableTr("devList");
	    var str = "select * from ("
			str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
			str += "p6.name as jobname,pro.project_name,";
			str += "case when alldet.dev_name is null then (case when alldet.isdevicecode = 'N' then ci.dev_ci_name else ct.dev_ct_name end) else alldet.dev_name end as dev_ci_name,";
			str += "case when alldet.dev_type is null then (case when alldet.isdevicecode='N' then ci.dev_ci_model else '' end) else alldet.dev_type end as dev_ci_model, ";
			str += "alldet.apply_num,alldet.teamid,alldet.team, ";
			str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
			str += "alldet.plan_start_date,alldet.plan_end_date,'非采集附属设备' as managetype,'0' as seqinfo  ";
			str += "from gms_device_allapp_detail alldet ";
			str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
			str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
			str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
			str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
			str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
			str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
			str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
			str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where alldet.device_addapp_id = '"+ids.split("-")[3]+"' and (alldet.bsflag = '0' or alldet.bsflag='0') ";
			str += "union "
			str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
			str += "p6.name as jobname,pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
			str += "alldet.apply_num,alldet.teamid,alldet.team, ";
			str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
			str += "alldet.plan_start_date,alldet.plan_end_date,'采集附属设备' as managetype,'1' as seqinfo  ";
			str += "from gms_device_allapp_colldetail alldet ";
			str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
			str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
			str += "left join comm_coding_sort_detail devtype on alldet.dev_codetype = devtype.coding_code_id ";
			str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
			str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
			str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
			str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where alldet.device_addapp_id = '"+ids.split("-")[3]+"' and (alldet.bsflag = '0' or alldet.bsflag='0') ";
			str += ") order by seqinfo ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+str);
		var datas1 = queryRet1.datas;
		if(null!=datas1){
			for (var i = 0; i<datas1.length; i++) {
				var tr = document.getElementById("devList").insertRow();		
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				//var td = tr.insertCell(0);
				//td.innerHTML = datas1[i].teamname;
				var td = tr.insertCell(0);
				td.innerHTML = datas1[i].dev_ci_name;
				var td = tr.insertCell(1);
				td.innerHTML = datas1[i].dev_ci_model;
				var td = tr.insertCell(2);
				td.innerHTML = datas1[i].unitname;
				var td = tr.insertCell(3);
				td.innerHTML = datas1[i].apply_num;
				var td = tr.insertCell(4);
				td.innerHTML = datas1[i].purpose;
			}
		}	
    }
	    
	function toAdd(){
		if("1"==addFlag){
			alert("不能操作!");
			return;
		}
		popWindow("<%=contextPath%>/pm/project/multiProject/wt/resourcesProject.jsp?projectInfoNo="+projectInfoNo+"&projectName="+encodeURI(encodeURI(projectName)),"900:700");
	}

	function toModifyDetail(){
		if("1"==addFlag){
			alert("不能操作!");
			return;
		}
		ids = getSelIds('rdo_entity_id');
	    
		if (""==ids) {
			alert("请选择一条记录!");
			return;
		}
		if(ids.split("-")[1] == '1' || ids.split("-")[1] == '3'){
			alert("该申请单已提交!");
			return;
		}
		
		popWindow("<%=contextPath%>/pm/project/multiProject/wt/resourcesSupplyFrame.jsp?projectInfoNo="+projectInfoNo+"&mid="+ids.split("-")[0],"900:750");
	}

	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if (""==ids) {
			alert("请选择一条记录!");
			return;
		}
		if(ids.split("-")[1] == '1' || ids.split("-")[1] == '3'){
			alert("该申请单已提交!");
			return;
		}
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WtProjectSrv", "deleteMiddleResources","mid="+ids.split("-")[0]+"&humanId="+ids.split("-")[2]+"&devId="+ids.split("-")[3]);
			queryData(cruConfig.currentPage);
		}
	}
	
	function toSubmit(){
		if("1"==addFlag){
			alert("不能操作!");
			return;
		}
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if (!window.confirm("确认要提交吗?")) {
			return;
		}	
		submitProcessInfo();
		refreshData();
	}
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }  

	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
</script>

</body>
</html>