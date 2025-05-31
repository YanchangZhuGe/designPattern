<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getOrgSubjectionId();
	String orgSub = user.getSubOrgIDofAffordOrg();
	//String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String projectCommon = user.getProjectCommon();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>多项目-出库分配-出库分配(综合物化探)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">单位名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_org_name" name="s_org_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">分配状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_assign_state" name="s_assign_state" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">未分配</option>
						<option value="1">已分配</option>
			    	</select>
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jl" event="onclick='toModifyDetail()'" title="明细出库"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_allapp_id}' name='device_allapp_id' idinfo='{device_allapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_allapp_id}~{allapp_type}~{business_type}~{project_info_no}' id='selectedbox_{device_allapp_id}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="<a onclick=viewProject('{project_info_no}')>{project_name}</a>">项目名称</td>
					<td class="bt_info_even" exp="{device_allapp_no}">计划单号</td>
					<td class="bt_info_odd" exp="{device_allapp_name}">计划名称</td>
					<td class="bt_info_even" exp="{org_name}">申请单位名称</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{appdate}">申请时间</td>
					<!-- <td class="bt_info_odd" exp="{create_date}">创建时间</td> -->
					<td class="bt_info_odd" exp="{modifi_date}">审批时间</td>
					<td class="bt_info_even" exp="{assign_desc}">分配状态</td>
					<td class="bt_info_odd" exp="<a onclick=viewStore('{device_allapp_id}','{assign_state}','{allapp_type}')>查看</a>">调配进度</td>					
			     </tr> 
			     <tr>
				     <td  class="inquire_item6">调配进度：</td>
				     <td  class="inquire_form6"><input id="createdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			    <!-- <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li> -->
			  </ul>
			</div>
			 <div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_allapp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请单号：</td>
				      <td  class="inquire_form6"  ><input id="device_allapp_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">申请单位名称：</td>
				     <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;申请人：</td>
				     <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="appdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <!-- <td  class="inquire_item6">创建时间：</td>
				     <td  class="inquire_form6"><input id="createdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> -->
				     <td  class="inquire_item6">&nbsp;审批时间：</td>
				     <td  class="inquire_form6"><input id="approvedate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;分配状态：</td>
				     <td  class="inquire_form6"><input id="assign_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table id="detailtitletable" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" style="margin-top:10px;background:#efefef;width:100%"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">项目名称</td>
							<td class="bt_info_even">班组</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">申请数量</td>
							<td class="bt_info_odd">审批数量</td>
							<td class="bt_info_even">申请人</td>
							<td class="bt_info_odd">用途</td>
							<td class="bt_info_even">计划开始时间</td>
							<td class="bt_info_odd">计划结束时间</td>
				        </tr>				        
				        <tbody id="detailMap" name="detailMap" >
					   	</tbody>				   	 
					</table>
					<div style="height:70%;overflow:auto;">
				      	<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   		<tbody id="detailMap" name="detailMap" >
					   		</tbody>
				      	</table>
			        </div>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

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
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
			}
		});
	    var info = currentid.split("~" , -1); 	        
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(info[0] != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select * from ("
				str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,";
				str += "alldet.dev_name as dev_ci_name,";
				str += "alldet.dev_type as dev_ci_model, ";
				str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
				str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
				str += "alldet.plan_start_date,alldet.plan_end_date,'单台管理' as managetype,'0' as seqinfo  ";
				str += "from gms_device_allapp_detail alldet ";
				str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
				str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
				str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
				str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
				str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
				str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
				str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
				str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where devapp.device_allapp_id = '"+info[0]+"' and alldet.bsflag='0' and alldet.device_addapp_id is null ";
				str += "union all "
				str += "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
				str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
				str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
				str += "alldet.plan_start_date,alldet.plan_end_date,'批量管理' as managetype,'1' as seqinfo  ";
				str += "from gms_device_allapp_colldetail alldet ";
				str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
				str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
				str += "left join comm_coding_sort_detail devtype on alldet.dev_codetype = devtype.coding_code_id ";
				str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
				str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
				str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
				str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where devapp.device_allapp_id = '"+info[0]+"' and alldet.bsflag='0' ";
				str += ") order by seqinfo ";
				
				var param = new Object();
				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}else if(index == 2){					
			//工作流信息
	        processNecessaryInfo={        							//流程引擎关键信息
	        	businessTableName:"gp_middle_resources",    			//置入流程管控的业务表的主表表明
	        	businessType:info[2],    //业务类型 即为之前设置的业务大类
	        	businessId:info[3]           				//业务主表主键值
	        }
	    	loadProcessHistoryInfo();
		}else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].project_name+"</td><td>"+datas[i].teamname+"</td>";
			innerHTML += "<td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td><td>"+datas[i].unitname+"</td>";
			innerHTML += "<td>"+datas[i].apply_num+"</td><td>"+datas[i].approve_num+"</td><td>"+datas[i].employee_name+"</td><td>"+datas[i].purpose+"</td>";
			innerHTML += "<td>"+datas[i].plan_start_date+"</td><td>"+datas[i].plan_end_date+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	//调用此方法，可以实现上下两个table的方式实现表头固定和对齐，参考planMaininfoList.jsp的#detailtitletable和#detailMap
	function aligntitle(titletrid,filterobj){
		var titlecells = $("tr",titletrid)[0].cells;
		var contenttr = $("tr",filterobj)[0];
		if(contenttr==undefined)
			return;
		var contentcells = contenttr.cells
		for(var index=0;index<titlecells.length;index++){
			var widthinfo = contentcells[index].offsetWidth;
			if(widthinfo>0){
				titlecells[index].width = widthinfo+'px';
			}
		}
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	var projectName = '<%=projectName%>';
	var projectType="<%=projectType%>";
	var projectCommon="<%=projectCommon%>";
	var userId="<%=userId%>";
	
	//var ret = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo="+projectInfoNos);
	//var pro_dep = ret.map.project_department;
			
	//if(pro_dep=="C6000000000124"){businessType = "5110000004100001019";}//海外项目部
	//if(pro_dep=="C6000000004707"){businessType = "5110000004100001016";}//工程项目部									
	//if(pro_dep=="C6000000005592"){businessType = "5110000004100001022";}//北疆项目部		
	//if(pro_dep=="C6000000005594"){businessType = "5110000004100001024";}//东部项目部
	//if(pro_dep=="C6000000005595"){businessType = "5110000004100001023";}//敦煌项目部
//	if(pro_dep=="C6000000005605"){businessType = "5110000004100001021";}//塔里木项目部
		
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function clearQueryText(){
		$("#s_project_name").val("");
		$("#s_org_name").val("");
		$("#s_assign_state").val("");
	}
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		var v_assign_state = document.getElementById("s_assign_state").value;
		refreshData(v_project_name,v_org_name,v_assign_state);
	}
	function getdate() { 
		var now = new Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}

    function refreshData(v_project_name,v_org_name,v_assign_state){

		var str = "select wfmiddle.business_type,devapp.allapp_type,pro.project_name,devapp.device_allapp_id,devapp.device_allapp_no,devapp.device_allapp_name,devapp.project_info_no,";
			str += "devapp.org_id,devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,devapp.assign_state, ";
			str += "case devapp.assign_state when '0' then '未分配' when '1' then '已分配' else '未分配' end as assign_desc,";
			str += "org.org_abbreviation as org_name,emp.employee_name ";
			str += "from gms_device_allapp devapp   left join gp_middle_resources s   on s.project_info_no=devapp.project_info_no  and s.bsflag='0' ";
	        str += "left join common_busi_wf_middle wfmiddle  on wfmiddle.business_id = s.mid and wfmiddle.bsflag='0' ";			
	        //str += "and wfmiddle.business_type = '"+businessType+"' ";
	        str += "and wfmiddle.business_type in ('5110000004100001019','5110000004100001016','5110000004100001022','5110000004100001024','5110000004100001023','5110000004100001021' )";
			str += "left join comm_org_information org on devapp.org_id = org.org_id  ";
			str += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
	        str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' ";
			str += "where wfmiddle.proc_status = '3' and devapp.bsflag = '0' ";
			//综合物化探：C105008038-测绘服务中心; C105008042-机动设备服务中心; C105008001-仪器服务中心
			if(userId == 'C105008038' || userId == 'C105008042' || userId == 'C105008001'){			
				str += "and devapp.org_subjection_id like '%C105008%' ";
				
			}//综合物化探：C105008037-北疆项目部; C105008039-东部项目部; C105008040-敦煌项目部
			 //           C105008044-塔里木项目部; C105008003-海外项目部; C105008002-工程项目部;
			else if(userId == 'C105008037' || userId == 'C105008039' || userId == 'C105008040'
				|| userId == 'C105008044' || userId == 'C105008003' || userId == 'C105008002')
			{
				str += "and devapp.org_subjection_id like '%C105008%' ";

				if(userId == 'C105008037'){
					str += "and pro.project_department = 'C6000000005592' "
				}else if(userId == 'C105008039'){
					str += "and pro.project_department = 'C6000000005594' "
				}else if(userId == 'C105008040'){
					str += "and pro.project_department = 'C6000000005595' "
				}else if(userId == 'C105008044'){
					str += "and pro.project_department = 'C6000000005605' "
				}else if(userId == 'C105008003'){
					str += "and pro.project_department = 'C6000000000124' "
				}else if(userId == 'C105008002'){
					str += "and pro.project_department = 'C6000000004707' "
				}
			}else{
				str += "and devapp.org_subjection_id like '%<%=orgSub%>%' ";
			}
					
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and pro.project_name like '%"+v_project_name+"%' ";
		}
		if(v_org_name!=undefined && v_org_name!=''){
			str += "and org.org_name like '%"+v_org_name+"%' ";
		}
		if(v_assign_state!=undefined && v_assign_state!=''){
			if(v_assign_state == '1'){//已分配
				str += "and devapp.assign_state = '1' ";
			}else{//未分配
				str += "and (devapp.assign_state != '1' or devapp.assign_state is null) ";
			}					
		}
		str += " order by devapp.assign_state nulls first,devapp.appdate desc,project_info_no";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}

	 function viewStore(id,state,assignType){
		if(state=='0' || state==''){
			alert("该计划没有指定出库单位,暂不能查看详细调配信息!");
		}else{
			var str = "select device_app_id from gms_device_app where device_allapp_id = '"+id+"' and bsflag = '0' ";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			var devappid = unitRet.datas[0].device_app_id;
		
			if(devappid != ''){
				popWindow('<%=contextPath%>/rm/dm/devPlanMulti/zhOutEqDevStoreView.jsp?devAppId='+devappid+'&assignType='+assignType,'1050:610');
			}
		}			
	}
		
    function loadDataDetail(shuaId){
	    var info = shuaId.split("~" , -1); 	        
    	var retObj;

		if(info[0]!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getZhDevAllAppBaseInfo", "deviceallappid="+info[0]+"&pbflag=Y&busitype="+info[2]);			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    info = ids.split("~" , -1);
			 retObj = jcdpCallService("DevCommInfoSrv", "getZhDevAllAppBaseInfo", "deviceallappid="+info[0]+"&pbflag=Y&busitype="+info[2]);			
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_allapp_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_allapp_id+"']").removeAttr("checked");
		//给数据回填
		$("#project_name","#projectMap").val(retObj.deviceappMap.project_name);
		$("#device_allapp_name","#projectMap").val(retObj.deviceappMap.device_allapp_name);
		$("#device_allapp_no","#projectMap").val(retObj.deviceappMap.device_allapp_no);
		$("#assign_desc","#projectMap").val(retObj.deviceappMap.assign_desc);
		$("#org_name","#projectMap").val(retObj.deviceappMap.org_name);
		$("#employee_name","#projectMap").val(retObj.deviceappMap.employee_name);
		$("#appdate","#projectMap").val(retObj.deviceappMap.appdate);
		$("#approvedate","#projectMap").val(retObj.deviceappMap.modifi_date);
		
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	function toModifyDetail(obj){

		var v_assign_desc = document.getElementById("assign_desc").value;	
		if(v_assign_desc == '已分配'){
			alert("明细已出库,请查看！");
			return;
		}
		var idinfo = null;
		var length = 0;
		if(obj!=undefined){
			idinfo = obj.idinfo;
		}else{
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked == true){
					idinfo = this.value;
					length = length+1;
				}
			});
			if(length == 0){
				alert("请选择记录！");
				return;
			}
		}
	    var info = idinfo.split("~" , -1);
		
		if(info != ''){
	   		popWindow('<%=contextPath%>/rm/dm/devPlanMulti/zhDevListOutStoreDet.jsp?projectInfoNo='+info[3]+'&deviceallappid='+info[0]+'&allapp_type='+info[1],'1050:680');
		}
	}
	 function viewProject(projectNo){
			if(projectNo != ''){
				popWindow('<%=contextPath%>/rm/dm/project/viewProject.jsp?projectInfoNo='+projectNo,'1080:680');						
			}		
	}
	function dbclickRow(shuaId){
		var v_assign_desc = document.getElementById("assign_desc").value;		
		if(v_assign_desc == '已分配'){
			alert("明细已出库,请查看！");
			return;
		}		
		var info = shuaId.split("~" , -1);

	    if(info != ''){
	   		popWindow('<%=contextPath%>/rm/dm/devPlanMulti/zhDevListOutStoreDet.jsp?projectInfoNo='+info[3]+'&deviceallappid='+info[0]+'&allapp_type='+info[1],'1050:680');
		}
	}   

</script>
</html>