<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">

		<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    <tr>
		    	<td class="inquire_item6">项目名称：</td>
		      	<td class="inquire_form6">
				<input type="hidden" id="projectInfoNo" name="projectInfoNo" value=""/>
				<input type="text"  readonly="readonly" value="" id="projectName" name="projectName" class='input_width'></input>
				</td>
		      	<td class="inquire_item6">申请单位：</td>
		      	<td class="inquire_form6">
				<input type="hidden" value="" id="applyCompany" name="applyCompany"></input>
				<input type="text" value="" id="applicantOrgName" name="applicantOrgName" class='input_width' readonly="readonly"></input>
				</td>
		      	<td class="inquire_item6">&nbsp;</td>
		      	<td class="inquire_form6">&nbsp;</td>
		    </tr>
		    <tr>
		    	<td class="inquire_item6">申请单号：</td>
		      	<td class="inquire_form6">
		      	<input type="hidden" id="professNo" name="professNo" value=""/>
				<input type="text" style="color: gray;" value="" id="applyNo"  name="applyNo" class='input_width' readonly="readonly"></input>
				</td>
		      	<td class="inquire_item6">提交人：</td>
		      	<td class="inquire_form6">
				<input type="hidden" value="" id="applicantId" name="applicantId"></input>
				<input type="text" value="" id="applicantName" name="applicantName" class='input_width' readonly="readonly"></input>
				</td>
		      	<td class="inquire_item6">提交时间：</td>
		      	<td class="inquire_form6">
				<input type="text" value="" id="applyDate" name="applyDate" class='input_width' readonly="readonly"/>
				&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(applyDate,tributton1);" />
				</td>
		    </tr>
		</table>
		</div>  

			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">岗位需求</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">作业需求</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">人工成本计划</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>计划人数</td>
				            <td>其中专业化人数</td>
				            <td>计划进入项目时间</td>			
				            <td>计划离开项目时间</td>          
				            <td>预计在项目天数</td>
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="taskList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
 							<td>序号</td>
				    	    <td>作业名称</td>
				            <td>计划开始时间</td>
				            <td>计划结束时间</td>		
				            <td>原定工期</td>
				            <td>班组</td>			
				            <td>岗位</td> 
				            <td>计划人数</td>
				            <td>其中专业化人数</td>
				            <td>计划进入时间</td>
				            <td>计划离开时间</td>		
				            <td>天数</td>				
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	                <tr>
	                  <td class="inquire_item6">项目承包期：</td>
	                  <td class="inquire_form6">
	                  <input name="project_contract" id="project_contract" class="input_width" value="" type="text" readonly="readonly" />
	                  <input name="artificial_no" id="artificial_no" class="input_width" value="" type="hidden" />月
	                  </td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	                <tr>
	                  <td class="inquire_item6">准结期：</td>
	                  <td class="inquire_form6"><input name="standard_knot" id="standard_knot"  value="" class="input_width" type="text" readonly="readonly"/>月</td>
	                  <td class="inquire_item6">定额施工期：</td>
	                  <td class="inquire_form6"><input name="norm_construction" id="norm_construction" value="" class="input_width" type="text" readonly="readonly"/>月</td>
	                  <td class="inquire_item6">项目轮休期：</td>
	                  <td class="inquire_form6"><input name="turn_rest" id="turn_rest"   value="" class="input_width" type="text" readonly="readonly"/>月</td>	                                   
	                </tr>
	                  <tr><td colspan="6">&nbsp;</td></tr>
	                <tr>
	                  <td class="inquire_item6">定员：</td>
	                  <td class="inquire_form6"><input name="project_staff"  id="project_staff"   value="" class="input_width" type="text" readonly="readonly"/>人</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	               <tr>	                 
	                  <td class="inquire_item6">合同化员工：</td>
	                  <td class="inquire_form6"><input name="contract_emp"  id="contract_emp"  value=""  class="input_width" type="text" readonly="readonly"/>人</td>
	                  <td class="inquire_item6">市场化用工：</td>
	                  <td class="inquire_form6"><input name="market_emp"  id="market_emp" value=""   class="input_width" type="text" readonly="readonly"/>人</td>
					  <td class="inquire_item6">临时季节性用工：</td>
	                  <td class="inquire_form6"><input name="temp_emp"  id="temp_emp"  value=""  class="input_width" type="text" readonly="readonly"/>人</td>
	                </tr>
	               <tr>	                  
	                  <td class="inquire_item6">劳务用工：</td>
	                  <td class="inquire_form6"><input name="service_emp"  id="service_emp"  value=""  class="input_width" type="text" readonly="readonly"/>人</td>
	                  <td class="inquire_item6">再就业人员：</td>
	                  <td class="inquire_form6"><input name="reemp_emp"  id="reemp_emp"  value=""  class="input_width" type="text" readonly="readonly"/>人</td>
	               	  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	                  <tr><td colspan="6">&nbsp;</td></tr>
	                 <tr>
	                  <td class="inquire_item6">项目人工费投入计划：</td>
	                  <td class="inquire_form6"><input name="sum_human_cost"  id="sum_human_cost"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	                <tr>	                 
	                  <td class="inquire_item6">合同化员工工资总额：</td>
	                  <td class="inquire_form6"><input name="contract_cost"  id="contract_cost"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">合同化员工补贴总额：</td>
	                  <td class="inquire_form6"><input name="contract_weal"  id="contract_weal"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">合同化员工工资计提：</td>
	                  <td class="inquire_form6"><input name="contract_jiti"  id="contract_jiti"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                </tr>
	                <tr>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="contract_other"  id="contract_other"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">市场化用工工资总额：</td>
	                  <td class="inquire_form6"><input name="market_cost"  id="market_cost"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">市场化用工补贴总额：</td>
	                  <td class="inquire_form6"><input name="market_weal"  id="market_weal"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                </tr>
	                <tr>
	                  <td class="inquire_item6">市场化员工工资计提：</td>
	                  <td class="inquire_form6"><input name="market_jiti"  id="market_jiti"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="market_other"  id="market_other"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">临时季节用工劳务费总额：</td>
	                  <td class="inquire_form6"><input name="temp_cost"  id="temp_cost"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>	                  
	                </tr>
	                <tr>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="temp_other"  id="temp_other"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">劳务用工劳务费总额：</td>
	                  <td class="inquire_form6"><input name="service_cost"  id="service_cost"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="service_other"  id="service_other"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>                  
	                </tr>
	                <tr>
	                  <td class="inquire_item6">再就业人员总额：</td>
	                  <td class="inquire_form6"><input name="reemp_cost"  id="reemp_cost"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>	             	                  
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="reemp_other"  id="reemp_other"  value=""  class="input_width" type="text" readonly="readonly"/>万元</td>
	               	  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
					</table>				
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
				</div>
		 	</div>
</div>
</body>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("s_employee_name").value;
			refreshData(undefined, q_file_name);
		}
	}
	
	function toSubmit() {	
		
	//		var ids = getSelIds('rdo_entity_id');
			ids = getSelectedValue();
			jcdpCallService("HumanCommInfoSrv","submitHumanPlan","projectInfoNo="+ids+"&procStatus=2");	
			submitProcessInfo();
			 refreshData();
			alert("提交成功");
	}
	
	function toAdd(){
		ids = getSelectedValue();
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		}
		popWindow('<%=contextPath%>/rm/em/humanPlan/add_artificialCostModify.jsp?projectInfoNo='+ids,'1000:800');
	
	}
	
	function toEdit(){

		ids = getSelectedValue();
	//	var ids = getSelIds('rdo_entity_id');
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		}
		popWindow('<%=contextPath%>/rm/em/humanPlan/add_artificialCostModify.jsp?projectInfoNo='+ids,'1000:800');
	
	}
	
	function refreshData(){

		cruConfig.queryStr = "select  decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, t.project_info_no,p.project_name,t.plan_no,t.apply_company,i.org_name,t.applicant_id,e.employee_name,t.apply_date,t.proc_status from bgp_comm_human_plan t left join common_busi_wf_middle te on    te.business_id=t.project_info_no   and te.bsflag='0' and business_type='8ad878dd38a35eb20138c0d2ba0f0183'    left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  left join comm_org_information i on t.apply_company=i.org_id and i.bsflag='0'  left join comm_human_employee e on t.applicant_id=e.employee_id and e.bsflag='0' where t.bsflag='0'  ";
		cruConfig.currentPageUrl = "/rm/singleHuman/humanRequest/taskPlanList.jsp";
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		
	}


    function loadDataDetail(ids){
    	
    	 processNecessaryInfo={         
   	    		businessTableName:"bgp_comm_human_plan",    //置入流程管控的业务表的主表表明
   	    		businessType:"8ad878dd38a35eb20138c0d2ba0f0183",        //业务类型 即为之前设置的业务大类
   	    		businessId:ids,         //业务主表主键值
   	    		businessInfo:"多项目 人力需求计划审核",        //用于待审批界面展示业务信息
   	    		applicantDate:'<%=appDate%>'       //流程发起时间
   	    	}; 
     
    	 
    	var querySql = "select rownum,p.* from (select p.apply_team_name, p.post_name,p.apply_team, p.post,sum(nvl(p.people_number,0)) people_number , sum(nvl(p.profess_number,0)) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date)) nums from ( select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where d.project_info_no='"+ids+"' and d.bsflag='0' ) p group by p.apply_team_name,p.post_name ,p.apply_team, p.post ) p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		var querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums,a.name,a.planned_start_date,a.planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where d.project_info_no='"+ids+"' and d.bsflag='0' ) p ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		deleteTableTr("planDetailList");
		deleteTableTr("taskList");
		
		loadProcessHistoryInfo();
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
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
				td.innerHTML = datas[i].profess_number;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].plan_start_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].plan_end_date;
				
				var td = tr.insertCell(7);
				td.innerHTML = datas[i].nums;

			}
		}	
			
		if(datas1 != null){
			for (var i = 0; i< queryRet1.datas.length; i++) {
				
				var tr = document.getElementById("taskList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

              	
				var td = tr.insertCell(0);
				td.innerHTML = datas1[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas1[i].name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas1[i].planned_start_date;

				var td = tr.insertCell(3);
				td.innerHTML = datas1[i].planned_finish_date;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas1[i].planned_duration;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas1[i].apply_team_name;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas1[i].post_name;

				var td = tr.insertCell(7);
				td.innerHTML = datas1[i].people_number;
				
				var td = tr.insertCell(8);
				td.innerHTML = datas1[i].profess_number;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas1[i].plan_start_date;
				
				var td = tr.insertCell(10);
				td.innerHTML = datas1[i].plan_end_date;
				
				var td = tr.insertCell(11);
				td.innerHTML = datas1[i].nums;

			}
		}			
		
		var querySql = "select t.* from bgp_human_artificial_cost t where t.project_info_no='"+ids+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null){			
			document.getElementById("artificial_no").value=datas[0].artificial_no;
//			document.getElementById("plan_no").value=datas[0].plan_no;
			document.getElementById("project_contract").value=datas[0].project_contract;
			document.getElementById("norm_construction").value=datas[0].norm_construction;
			document.getElementById("standard_knot").value=datas[0].standard_knot;
			document.getElementById("turn_rest").value=datas[0].turn_rest;
			document.getElementById("project_staff").value=datas[0].project_staff;
			document.getElementById("contract_emp").value=datas[0].contract_emp;
			document.getElementById("market_emp").value=datas[0].market_emp;
			document.getElementById("temp_emp").value=datas[0].temp_emp;
			document.getElementById("service_emp").value=datas[0].service_emp;
			document.getElementById("reemp_emp").value=datas[0].reemp_emp;
			document.getElementById("sum_human_cost").value=datas[0].sum_human_cost;
			document.getElementById("contract_cost").value=datas[0].contract_cost;
			document.getElementById("contract_weal").value=datas[0].contract_weal;
			document.getElementById("contract_jiti").value=datas[0].contract_jiti;
			document.getElementById("contract_other").value=datas[0].contract_other;
			document.getElementById("market_cost").value=datas[0].market_cost;
			document.getElementById("market_weal").value=datas[0].market_weal;
			document.getElementById("market_jiti").value=datas[0].market_jiti;
			document.getElementById("market_other").value=datas[0].market_other;
			document.getElementById("temp_cost").value=datas[0].temp_cost;
			document.getElementById("temp_other").value=datas[0].temp_other;
			document.getElementById("service_cost").value=datas[0].service_cost;
			document.getElementById("service_other").value=datas[0].service_other;
			document.getElementById("reemp_cost").value=datas[0].reemp_cost;
			document.getElementById("reemp_other").value=datas[0].reemp_other;
			
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
</html>