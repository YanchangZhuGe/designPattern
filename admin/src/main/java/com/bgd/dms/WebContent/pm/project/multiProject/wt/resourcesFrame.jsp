<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String	projectInfoNo=request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
	String	projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String	projectName= request.getParameter("projectName")==null?user.getProjectName():java.net.URLDecoder.decode(request.getParameter("projectName"),"utf-8");
	//action=="view" 审批页面
	String action = request.getParameter("action")==null?"":request.getParameter("action");
	String signle = request.getParameter("signle")==null?"":request.getParameter("signle");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>项目资源配置</title>
</head>
<body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="list_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				  <td>
					  <ul id="tags" class="tags">
					    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
					    <li id="tag3_1"><a href="#" onclick="getTab3(1)">人员配置</a></li>
					    <li id="tag3_2"><a href="#" onclick="getTab3(2)">设备配置</a></li>
					    <%if(!"view".equals(action)||"0".equals(signle)){%>
					    	<li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
					    <%}%>
					  </ul>
				  </td>
				  <td >
				  <%if(!"view".equals(action)){%>
				  	<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
				  <%}%>
				  </td>
			  </tr>
			  </table>
			</div>
			<div id="tab_box" class="tab_box">
				<form name="resourcesForm" id="resourcesForm"  method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
				    <%if(!"view".equals(action)){%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateResources()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	                </table>
	                <%}%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item4">项目名称：</td>
							<td class="inquire_form4">
						    	<input type="hidden" id="resources_id" name="resources_id" />
							    <input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>"/>
							    <input type="text" id="project_name" name="project_name" value="<%=projectName%>" class="input_width" readonly="readonly"/>
					    	</td>
						    <td class="inquire_item4"></td>
						    <td class="inquire_form4"></td>
					  	</tr>
					  	<tr>
						    <td class="inquire_item4">施工队伍：</td>
						    <td class="inquire_form4"><input type="text" id="org_name" name="org_name" class="input_width" readonly="readonly"/></td>
						    <td class="inquire_item4">作业组数量：</td>
							<td class="inquire_form4"><input type="text" value="" id="working_group" name="working_group" class="input_width"/></td>
					  	</tr>
					  	<tr>
					  		<td class="inquire_item4">队经理：</td>
							<td class="inquire_form4"><input type="text" id="team_manager" name="team_manager" class="input_width"/></td>
							<td class="inquire_item4">副队经理：</td>
							<td class="inquire_form4"><input type="text" id="team_manager_f" name="team_manager_f" class="input_width"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">指导员：</td>
							<td class="inquire_form4"><input type="text" id="instructor" name="instructor" class="input_width"/></td>
							<td class="inquire_item4">工期要求：</td>
							<td class="inquire_form4"><input type="text" id="time_limit" name="time_limit" class="input_width"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">工作量：</td>
							<td id="item_workload" class="inquire_form4" colspan="3"></td>
						</tr>
					  	<tr>
					  		<td class="inquire_item4">地形：</td>
							<td id="item_landform" class="inquire_form4" colspan="3" ></td>
					  	</tr>
					</table>
				</div>
				</form>
				<div id="tab_box_content1" style="display:none;width:100%;height:500px;overflow:auto;border:1px #aebccb solid;background:#fff;">
					<iframe width="100%" height="100%" name="human" id="human" scroll="auto" ></iframe>
				</div>
				
				<div id="tab_box_content2" style="display:none;width:100%;height:500px;overflow:auto;border:1px #aebccb solid;background:#fff;">
					<iframe width="100%" height="100%" name="dev" id="dev" scrolling="yes"></iframe>
				</div>
				
				<div id="tab_box_content3" style="display:none;width:100%;height:500px;overflow:auto;border:1px #aebccb solid;background:#fff;">
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

</script>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo="<%=projectInfoNo%>";
	var action="<%=action%>";
	var lineUnitCL="";
	var idinfo=""; //计划的id
	//var taskObjectId="";
	//var taskName="";
	var businessType="";
	var mid="";
	var proc_status="";
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function refreshData(){
		//--------------------------------人力主表ID planId.planId ------------------------------
		var planId = jcdpCallService("HumanCommInfoSrv","submitHumanPlan","projectInfoNo="+projectInfoNo);	
		//--------------------------------设备主表ID idinfo--------------------------------
		var projectInfoNos ="<%=projectInfoNo%>";
		var strra = "select t.* from bgp_p6_project t where  t.project_info_no = '"+projectInfoNos+"'";
		var p6sql = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+strra);
		//if(p6sql.datas.length==0){
		//	alert("该项目无P6任务");
		//}else{
			this.getDevInfo();
		//}
		//------------------------------生成中间表-----------------------------
		
		var ret = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo="+projectInfoNo);
		var pro_dep = ret.map.project_department;

		//<option value="C6000000000124">海外项目部</option>
		//<option value="C6000000004707">工程项目部</option>
		//<option value="C6000000005592">北疆项目部</option>
		//<option value="C6000000005594">东部项目部</option>
		//<option value="C6000000005595">敦煌项目部</option>
		//<option value="C6000000005605">塔里木项目部</option>

		
		if(pro_dep=="C6000000000124"){
			businessType = "5110000004100001019";
		}
		if(pro_dep=="C6000000004707"){
			businessType = "5110000004100001016";
		}
		if(pro_dep=="C6000000005592"){
			businessType = "5110000004100001022";
		}
		if(pro_dep=="C6000000005594"){
			businessType = "5110000004100001024";
		}
		if(pro_dep=="C6000000005595"){
			businessType = "5110000004100001023";
		}
		if(pro_dep=="C6000000005605"){
			businessType = "5110000004100001021";
		}
		
		
		var querySql = "select r.mid,wf.proc_status from gp_middle_resources r left join common_busi_wf_middle wf "+
			"on r.project_info_no=wf.business_id and wf.business_type='"+businessType+"' and wf.bsflag='0' "+
			"where r.project_info_no='"+projectInfoNo+"' and r.supplyflag is null ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(null!=datas&&datas.length>0){
			mid=datas[0].mid;
			// '1'待审批  '3'审批通过     '4'审批不通过    ''未提交
			if("1"==datas[0].proc_status||"3"==datas[0].proc_status){
				action="view";
				proc_status=datas[0].proc_status;
			}
		}
		//------------------------------基本信息-------------------------------
		var retObj = jcdpCallService("WtProjectSrv", "getProjectResourcesInfo","projectInfoNo="+projectInfoNo);
		if(null!=retObj.map){//从项目资源配置表读取信息
			document.getElementById("resources_id").value= retObj.map.resources_id;
		    document.getElementById("project_info_no").value= retObj.map.project_info_no;
		    document.getElementById("project_name").value= retObj.map.project_name;
		    document.getElementById("org_name").value= retObj.orgMap.org_name;
		    document.getElementById("working_group").value= retObj.map.working_group;
		    document.getElementById("team_manager").value= retObj.map.team_manager;
		    document.getElementById("team_manager_f").value= retObj.map.team_manager_f;
		    document.getElementById("instructor").value= retObj.map.instructor;
		    document.getElementById("time_limit").value= retObj.map.time_limit;
		    //工作量
		    var word_load=retObj.map.work_load;
		    word_load=word_load.replace(new RegExp("m2", 'g'),"m&sup2");
		    document.getElementById("item_workload").innerHTML="<textarea id='work_load'  name='work_load' cols='63' rows='10'>"+word_load+"</textarea>";
		    //地形
		    var landform=retObj.map.landform;
		    landform=landform.replace(new RegExp("m2", 'g'),"m&sup2");
		    document.getElementById("item_landform").innerHTML="<textarea id='landform' name='landform' cols='63' rows='5'>"+landform+"</textarea>";
		}else{//从项目信息中读取
			//工作量
			document.getElementById("item_workload").innerHTML="<textarea id='work_load'  name='work_load' cols='63' rows='10'>"+this.getWorkLoad()+"</textarea>";
			//地形
			document.getElementById("item_landform").innerHTML="<textarea id='landform' name='landform' cols='63' rows='5'>"+this.getLandForm()+"</textarea>";
			//施工队伍
		    retObj = jcdpCallService("WtProjectSrv", "getProjectOrgNames", "projectInfoNo="+projectInfoNo);
		    if(null!=retObj.orgNameMap){
				document.getElementById("org_name").value =retObj.orgNameMap.org_name;
			}
		}
		//人员配置
	    document.getElementById("human").src = "<%=contextPath%>/pm/project/multiProject/wt/resourcesHuman.jsp?projectInfoNo="+projectInfoNo+"&projectType=<%=projectType%>&action="+action;
	    //if(p6sql.datas.length>0){
		    //设备配置
		    document.getElementById("dev").src = "<%=contextPath%>/pm/project/multiProject/wt/resourcesDev.jsp?projectInfoNo="+projectInfoNo+"&idinfo="+idinfo+"&projectType=<%=projectType%>&action="+action;
	    //}
	    processNecessaryInfo={        //流程引擎关键信息
				businessTableName:"gp_middle_resources",    //置入流程管控的业务表的主表表明
				businessType:businessType,        //业务类型 即为之前设置的业务大类
				businessId:projectInfoNo,           //业务主表主键值
				businessInfo:"项目资源配置",        //用于待审批界面展示业务信息
				applicantDate:"<%=appDate%>"       //流程发起时间
			};
		processAppendInfo={ //流程引擎附加临时变量信息
				projectInfoNo:projectInfoNo,
				action:"view",
				projectName:document.getElementById("project_name").value
			};
		loadProcessHistoryInfo();
	}
//---------------获得设备----------------
function getDevInfo(){
	//检查本项目是否存在bsflag为0的申请单
	var str = "select devapp.device_allapp_id from gms_device_allapp devapp where devapp.bsflag = '0' and devapp.project_info_no='"+projectInfoNo+"'";
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
	if(unitRet.datas.length > 0){
		//已存在设备配置计划主表
		//var tob = syncRequest('Post','<%=contextPath%>/p6/resourceAssignment/getTasks.srq','projectInfoNo='+projectInfoNo);
		idinfo=unitRet.datas[0].device_allapp_id;
		//taskObjectId=tob[0].other1;
		//taskName=tob[0].name;
	}else{
		var params = "";
		var retObj;
		var basedatas;
		//查询基本信息
		var querySql = "select pro.project_name,to_char(sysdate,'yyyy-mm-dd') as currentdate from gp_task_project pro "+
			"where pro.bsflag='0' and pro.project_info_no='"+projectInfoNo+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		basedatas = queryRet.datas;
		//回填基本信息
		params+="&project_name="+basedatas[0].project_name;
		params+="&projectInfoNo="+projectInfoNo;
		params+="&device_allapp_name=设备计划统一调配";//不知值从哪取
		params+="&device_allapp_no=";//保存后自动生成..
		params+="&appdate="+basedatas[0].currentdate;
		params+="&org_id=<%=user.getOrgId()%>";
		params+="&org_name=<%=user.getOrgName()%>";
		params+="&employee_id=<%=user.getEmpId()%>";
		params+="&employee_name=<%=user.getUserName()%>";
		params+="&state=0";
		var retObj = jcdpCallService("DevCommInfoSrv", "saveDevAllAppBaseInfo", params);
		if(retObj.returnCode==0){
			//4 跳转到添加明细列表页面 进行修改
			var unitRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);//取计划id
			//var tob = syncRequest('Post','<%=contextPath%>/p6/resourceAssignment/getTasks.srq','projectInfoNo='+projectInfoNo);//取任务
			idinfo=unitRet1.datas[0].device_allapp_id;
			//taskObjectId=tob[0].other1;
			//taskId=tob[0].taskId;
			//taskName=tob[0].name;
		}
	}
}
//---------------获得地形----------------
	function getLandForm(){
		var obj = jcdpCallService("WtProjectSrv", "queryMeasureList", "measureType=0&projectInfoNo="+projectInfoNo);
	    var str="";
	    if(0!=obj.total_jb_gy_one){
			str+="高原Ⅰ类："+obj.total_jb_gy_one.substring(0,obj.total_jb_gy_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_gy_two){
			str+="高原Ⅱ类："+obj.total_jb_gy_two.substring(0,obj.total_jb_gy_two.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_gy_three){
			str+="高原Ⅲ类："+obj.total_jb_gy_three.substring(0,obj.total_jb_gy_three.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_gy_four){
			str+="高原Ⅳ类："+obj.total_jb_gy_four.substring(0,obj.total_jb_gy_four.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_mountain_one){
			str+="山地Ⅰ类："+obj.total_jb_mountain_one.substring(0,obj.total_jb_mountain_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_mountain_two){
			str+="山地Ⅱ类："+obj.total_jb_mountain_two.substring(0,obj.total_jb_mountain_two.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_zz_one){
			str+="海滩沼泽Ⅰ类："+obj.total_jb_zz_one.substring(0,obj.total_jb_zz_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_zz_two){
			str+="海滩沼泽Ⅱ类："+obj.total_jb_zz_two.substring(0,obj.total_jb_zz_two.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_zz_three){
			str+="海滩沼泽Ⅲ类："+obj.total_jb_zz_three.substring(0,obj.total_jb_zz_three.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_zz_four){
			str+="海滩沼泽Ⅳ类："+obj.total_jb_zz_four.substring(0,obj.total_jb_zz_four.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_desert_one){
			str+="沙漠Ⅰ类："+obj.total_jb_desert_one.substring(0,obj.total_jb_desert_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_desert_two){
			str+="沙漠Ⅱ类："+obj.total_jb_desert_two.substring(0,obj.total_jb_desert_two.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_desert_three){
			str+="沙漠Ⅲ类："+obj.total_jb_desert_three.substring(0,obj.total_jb_desert_three.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_hty_one){
			str+="黄土塬Ⅰ类："+obj.total_jb_hty_one.substring(0,obj.total_jb_hty_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_hty_two){
			str+="黄土塬Ⅱ类："+obj.total_jb_hty_two.substring(0,obj.total_jb_hty_two.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_cy_one){
			str+="戈壁草原Ⅰ类："+obj.total_jb_cy_one.substring(0,obj.total_jb_cy_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_cy_two){
			str+="戈壁草原Ⅱ类："+obj.total_jb_cy_two.substring(0,obj.total_jb_cy_two.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_py_one){
			str+="平原Ⅰ类："+obj.total_jb_py_one.substring(0,obj.total_jb_py_one.indexOf("."))+lineUnitCL+"，";
		}if(0!=obj.total_jb_py_two){
			str+="平原Ⅱ类："+obj.total_jb_py_two.substring(0,obj.total_jb_py_two.indexOf("."))+lineUnitCL+"，";
		}
		return str;
	}

//---------------获得工作量----------------
	function getWorkLoad(){
	    retObj = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo="+projectInfoNo);
		var str="";
		if(null!=retObj.workloadMap){
			for(var i=0;i<retObj.workloadMap.length;i++){
				var exploration_method=retObj.workloadMap==null?"":retObj.workloadMap[i].exploration_method;
				var mapName=retObj.workloadMap==null?"":retObj.workloadMap[i].exploration_method_name;
				var mapCode=retObj.workloadMap==null?"":retObj.workloadMap[i].superior_code_id;
				var workload_id=retObj.workloadMap==null?"":retObj.workloadMap[i].workload_id;
				var line_num=retObj.workloadMap==null?"":retObj.workloadMap[i].line_num;
				var line_length=retObj.workloadMap==null?"":retObj.workloadMap[i].line_length;
				var lineUnit=retObj.workloadMap==null?"":retObj.workloadMap[i].line_unit;
				var location_point=retObj.workloadMap==null?"":retObj.workloadMap[i].location_point;
				var repeat_point=retObj.workloadMap==null?"":retObj.workloadMap[i].repeat_point;
				var point_distance=retObj.workloadMap==null?"":retObj.workloadMap[i].point_distance;
				var line_distance=retObj.workloadMap==null?"":retObj.workloadMap[i].line_distance;
				var base_length=retObj.workloadMap==null?"":retObj.workloadMap[i].base_length;
				var gravity_point=retObj.workloadMap==null?"":retObj.workloadMap[i].gravity_point;
				var check_point=retObj.workloadMap==null?"":retObj.workloadMap[i].check_point;
				var physics_point=retObj.workloadMap==null?"":retObj.workloadMap[i].physics_point;
				var well_point=retObj.workloadMap==null?"":retObj.workloadMap[i].well_point;
				var line_unit="";
				if("1"==lineUnit){
					line_unit="m";
				}else if("2"==lineUnit){
					line_unit="km";
				}else if("3"==lineUnit){
					line_unit="m&sup2";
				}else if("4"==lineUnit){
					line_unit="km&sup2";
				}
				//重力
				if("5110000056000000001"==mapCode){
					str += addRow1(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
				}
				//磁力  人工场源电磁法 化探
				if("5110000056000000002"==mapCode||"5110000056000000004"==mapCode||"5110000056000000005"==exploration_method){
					str += addRow2(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
				}
				//天然场源电磁法
				if("5110000056000000003"==mapCode){
					str += addRow3(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
				}
				//工程勘探
				if("5110000056000000006"==mapCode){
					str += addRow4(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
				}
				if("5110000056000000045"==exploration_method){//测量
					lineUnitCL=line_unit;
				}
			}
		}
		return str;		
	}
	
	function addRow1(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
		var str=mapName;
		if(""!=line_num){
			str+="测线"+line_num+"条";
		}
		if(""!=line_length){
			str+="，勘探面积/剖面长度"+line_length+line_unit;
		}
		if(""!=point_distance){
			str+="，点距"+point_distance+"km";
		}
		if(""!=line_distance){
			str+="，线距"+line_distance+"km";
		}
		if(""!=base_length){
			str+="，基线长度"+base_length+"km";
		}
		if(""!=gravity_point){
			str+="，重力基点"+gravity_point+"个";
		}
		if(""!=location_point){
			str+="，坐标点"+location_point+"个";
		}
		if(""!=physics_point){
			str+="，物理点"+physics_point+"个";
		}
		str+="；\n";
		return str;
	}

	function addRow2(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
		var str=mapName;
		if(""!=line_num){
			str+="测线"+line_num+"条";
		}
		if(""!=line_length){
			str+="，勘探面积/剖面长度"+line_length+line_unit;
		}
		if(""!=point_distance){
			str+="，点距"+point_distance+"km";
		}
		if(""!=line_distance){
			str+="，线距"+line_distance+"km";
		}
		if(""!=location_point){
			str+="，坐标点"+location_point+"个";
		}
		if(""!=check_point){
			str+="，检查点"+check_point+"个";
		}
		if(""!=physics_point){
			str+="，物理点"+physics_point+"个";
		}
		str+="；\n";
		return str;
	}

	function addRow3(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
		var str=mapName;
		if(""!=line_num){
			str+="测线"+line_num+"条";
		}
		if(""!=line_length){
			str+="，勘探面积/剖面长度"+line_length+line_unit;
		}
		if(""!=point_distance){
			str+="，点距"+point_distance+"km";
		}
		if(""!=line_distance){
			str+="，线距"+line_distance+"km";
		}
		if(""!=location_point){
			str+="，坐标点"+location_point+"个";
		}
		if(""!=well_point){
			str+="，井旁测深点"+well_point+"个";
		}
		if(""!=check_point){
			str+="，检查点"+check_point+"个";
		}
		if(""!=physics_point){
			str+="，物理点"+physics_point+"个";
		}
		str+="；\n";
		return str;
	}

	function addRow4(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
		var str=mapName;
		if(""!=line_num){
			str+="测线"+line_num+"条";
		}
		if(""!=line_length){
			str+="，勘探面积/剖面长度"+line_length+line_unit;
		}
		if(""!=point_distance){
			str+="，点距"+point_distance+"km";
		}
		if(""!=line_distance){
			str+="，线距"+line_distance+"km";
		}
		if(""!=location_point){
			str+="，坐标点"+location_point+"个";
		}
		if(""!=check_point){
			str+="，检查点"+check_point+"个";
		}
		if(""!=physics_point){
			str+="，物理点"+physics_point+"个";
		}
		if(""!=gravity_point){
			str+="，重力基点"+gravity_point+"个";
		}
		if(""!=well_point){
			str+="，井旁测深点"+well_point+"个";
		}
		str+="；\n";
		return str;
	}

	function toUpdateResources(){
		if("1"==proc_status||"3"==proc_status){
			alert("该项目配置计划已提交!");
			return;
		}
		if (!checkForm()) return;
		var params = $("#resourcesForm").serialize();
		var retObj = jcdpCallService("WtProjectSrv","saveProjectResources",params);
		if(retObj != null &&retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}

	function toSubmit(){
		var businessType = '';
		var retObj = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo="+projectInfoNo);
		var pro_dep = retObj.map.project_department;
		//5110000004100001005 东部
		//5110000004100001006 海外
		//5110000004100001007 塔里木
		//5110000004100001008 北疆
		//5110000004100001009 工程部
		//5110000004100001010 敦煌
		if(pro_dep=="C6000000000124"){
			businessType = "5110000004100001006";
		}
		if(pro_dep=="C6000000004707"){
			businessType = "5110000004100001009";
		}
		if(pro_dep=="C6000000005592"){
			businessType = "5110000004100001008";
		}
		if(pro_dep=="C6000000005594"){
			businessType = "5110000004100001005";
		}
		if(pro_dep=="C6000000005595"){
			businessType = "5110000004100001010";
		}
		if(pro_dep=="C6000000005605"){
			businessType = "5110000004100001007";
		}
		
		var submitStr='businessTableName=gp_task_project&businessType='+businessType+'&businessId='+projectInfoNo;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		if(procStatus=='3'){//如果项目未通过审核 资源配置计划不能提交
			if("1"==proc_status||"3"==proc_status){
				alert("该项目配置计划已提交!");
				return;
			}
			if (!window.confirm("确认要提交吗?")) {
				return;
			}		
			submitProcessInfo();
		}else{
			alert("项目未通过审核暂时不能提交项目资源配置");
		}
		
		
	}

	function checkForm(){ 	
		if (!isTextPropertyNotNull("project_name", "项目名称")) return false;	
		if (!isLimitB100("working_group","作业组数量")) return false;  
		if (!isLimitB20("team_manager","队经理")) return false; 
		if (!isLimitB20("team_manager_f","副队经理")) return false;
		if (!isLimitB20("instructor","指导员")) return false;  
		if (!isLimitB100("time_limit","工期要求")) return false;  
		if (!isLimitB1000("work_load","工作量")) return false;  
		if (!isLimitB1000("landform","地形")) return false;  
		return true;
	}
</script>
</body>
</html>