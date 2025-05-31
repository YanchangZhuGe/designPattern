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
	  String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date()); 
	String ids = request.getParameter("ids");

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
 
 <body style="background:#fff" onload="loadDataDetail('<%=ids%>')">
      	 
			 <div id="tag-container_3">
			  <ul id="tags" class="tags">
 
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">申请理由</a></li> 	
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">岗位需求</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">基本信息</a></li> 
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>		 
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">审批流程</a></li>
			  </ul>
		   </div>
			  <div id="tab_box" class="tab_box" style="height:250px;overflow:auto;overflow-x:hidden;">
			  
			  <div id="tab_box_content0" class="tab_box_content">
				 
				<table  id="planME" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				<tr>
			     	<td class="inquire_item6">单号：</td>
			      	<td class="inquire_form6"> 
			      	<input type="hidden" id="plan_id" name="plan_id"   class="input_width" />
			      	<input type="text" id="plan_no" name="plan_no"   class="input_width" />
			       	</td>
			     	<td class="inquire_item6">项目名称：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="project_namek" name="project_namek"  style="width:280px;"  />
			      	 
			      	</td>
			      	
			     </tr>
				 <tr>
				    <td class="inquire_item6">提交人：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="submitUser" name="submitUser" class="input_width"   /> 
			      	</td>
			    	<td class="inquire_item6">提交日期：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="apply_date" name="apply_date"  style="width:280px;"    readonly="readonly"/>
			      	</td>
		     	</tr> 
		     	<tr>
		    	<td class="inquire_item6">申请理由：</td>
		      	<td class="inquire_form6" colspan="3"><textarea id="spare3" name="spare3" class="textarea"></textarea></td>
		         </tr>

			</table>
			</div> 
			  
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr class="bt_info">
			    	    <td>序号</td>
			            <td>班组</td>
			            <td>岗位</td>		
			            <td>计划人数</td>
			            <td>计划进入时间</td>
			            <td>计划离开时间</td>		
			            <td>天数</td>	
			        </tr>            
			        </table>
				</div>
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item6">项目名称：</td>
						<td class="inquire_form6">
					    	<input type="hidden" id="resources_id" name="resources_id" />
						    <input type="hidden" id="project_info_no" name="project_info_no" value=""/>
						    <input type="text" id="project_name" name="project_name" value="" class="input_width" readonly="readonly"/>
				    	</td>
					    <td class="inquire_item6">施工队伍：</td>
					    <td class="inquire_form6"><input type="text" id="org_name" name="org_name" class="input_width" readonly="readonly"/></td>
					    <td class="inquire_item6">作业组数量：</td>
						<td class="inquire_form6"><input type="text" value="" id="working_group" name="working_group" class="input_width" readonly="readonly"/></td>
				  	</tr>
				  	<tr>
				  		<td class="inquire_item6">队经理：</td>
						<td class="inquire_form6"><input type="text" id="team_manager" name="team_manager" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">副队经理：</td>
						<td class="inquire_form6"><input type="text" id="team_manager_f" name="team_manager_f" class="input_width" readonly="readonly"/></td>
						<td class="inquire_item6">指导员：</td>
						<td class="inquire_form6"><input type="text" id="instructor" name="instructor" class="input_width" readonly="readonly"/></td>
					</tr>
					<tr>
						<td class="inquire_item6">工期要求：</td>
						<td class="inquire_form6"><input type="text" id="time_limit" name="time_limit" class="input_width" readonly="readonly"/></td>
					</tr>
					<tr>
						<td class="inquire_item6">工作量：</td>
						<td id="item_workload" class="inquire_form6" colspan="3"></td>
					</tr>
				  	<tr>
				  		<td class="inquire_item6">地形：</td>
						<td id="item_landform" class="inquire_form6" colspan="3"></td>
				  	</tr>
				  </table>
			   </div>
			   
					
			    <div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>	
				</div>		
					
	
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		       	
				 </div>
				 
			 </div>
			 
 
</body>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_idA="<%=orgSubjectionId%>";
//	cruConfig.funcCode = "F_HUMAN_003";
	 var idsA="<%=ids%>";
	 var businessType="";
		//生产管理项目补充配置计划 流程编码
		var retObj = jcdpCallService("WtProjectSrv", "getProjectResourcesInfo","projectInfoNo="+idsA.split("-")[0]);
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
		
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0"); 

    function loadDataDetail(ids){
		var querySql2 = " select gmr.mid, decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, t.project_info_no,p.project_name,t.plan_no,t.plan_id, t.spare3 ,t.apply_company org_id,i.org_name,t.applicant_id,e.employee_name,t.apply_date,te.proc_status from bgp_comm_human_plan t  left join  gp_middle_resources  gmr on  gmr.human_id=t.plan_id and gmr.supplyflag='0'    left join common_busi_wf_middle te on    te.business_id =gmr.mid   and te.bsflag='0' and te.business_type='"+businessType+"'  left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  left join comm_org_information i on t.apply_company=i.org_id and i.bsflag='0'   left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join comm_human_employee e on t.applicant_id=e.employee_id and e.bsflag='0' where t.bsflag='0' and t.spare1='0'        and t.plan_id  in ( select  h.plan_id from gp_middle_resources m     left join bgp_comm_human_plan h on m.human_id=h.plan_id and h.bsflag='0'   where m.supplyflag='0'   )  and t.project_info_no='"+ids.split("-")[0]+"'    and t.plan_id='"+ids.split("-")[1]+"'   ";
		var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=1&querySql='+querySql2);
		var datas2 = queryRet2.datas;
		
    	if(datas2 != null && datas2 !=""){ 
			document.getElementById("plan_id").value=datas2[0].plan_id;
			document.getElementById("plan_no").value=datas2[0].plan_no;
			document.getElementById("project_namek").value=datas2[0].project_name;
			document.getElementById("spare3").value=datas2[0].spare3;
			document.getElementById("submitUser").value=datas2[0].employee_name;
			document.getElementById("apply_date").value=datas2[0].apply_date;
			
		}	 
    	
    	
	       processNecessaryInfo={        //流程引擎关键信息
					businessTableName:"gp_middle_resources",    //置入流程管控的业务表的主表表明
					businessType:businessType,        //业务类型 即为之前设置的业务大类
					businessId:ids.split("-")[2],           // mid
					businessInfo:"项目资源补充配置",        //用于待审批界面展示业务信息
					applicantDate:"<%=appDate%>"       //流程发起时间
				};
			processAppendInfo={ //流程引擎附加临时变量信息
				mid:ids.split("-")[2],
				projectInfoNo:ids.split("-")[0],
				action:"view",
				projectName:ids.split("-")[3]
			};
			loadProcessHistoryInfo();
		
			//------------------------------基本信息-------------------------------
			var retObj = jcdpCallService("WtProjectSrv", "getProjectResourcesInfo","projectInfoNo="+ids.split("-")[0]);
			document.getElementById("resources_id").value=retObj.map==null?"":retObj.map.resources_id;
		    document.getElementById("project_info_no").value=retObj.map==null?"":retObj.map.project_info_no;
		    document.getElementById("project_name").value=retObj.map==null?"":retObj.map.project_name;
		    document.getElementById("org_name").value=retObj.map==null?"":retObj.orgMap.org_name;
		    document.getElementById("working_group").value=retObj.map==null?"":retObj.map.working_group;
		    document.getElementById("team_manager").value=retObj.map==null?"":retObj.map.team_manager;
		    document.getElementById("team_manager_f").value=retObj.map==null?"":retObj.map.team_manager_f;
		    document.getElementById("instructor").value=retObj.map==null?"":retObj.map.instructor;
		    document.getElementById("time_limit").value=retObj.map==null?"":retObj.map.time_limit;
		    //工作量
		    var word_load= retObj.map==null?"":retObj.map.work_load;
		    word_load=word_load.replace(new RegExp("m2", 'g'),"m&sup2");
		    document.getElementById("item_workload").innerHTML="<textarea id='work_load'  name='work_load' cols='63' rows='10' readonly='true'>"+word_load+"</textarea>";
		    //地形
		    var landform= retObj.map==null?"":retObj.map.landform;
		    landform=landform.replace(new RegExp("m2", 'g'),"m&sup2");
		    document.getElementById("item_landform").innerHTML="<textarea id='landform' name='landform' cols='63' rows='5' readonly='true'>"+landform+"</textarea>";

		    //--------------------人员配置---------------------------
		    deleteTableTr("planDetailList");
		    var querySql="select rownum,d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date + 1) nums,d.notes "+
				"from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' "+
				"left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' "+
				"where d.spare1='"+ids.split("-")[1]+"' "+
				"and d.project_info_no='"+ids.split("-")[0]+"' and d.bsflag='0' and d.resourceflag='0'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
			var datas = queryRet.datas;
		    if(null!=datas){
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
					td.innerHTML = datas[i].plan_start_date;
					var td = tr.insertCell(5);
					td.innerHTML = datas[i].plan_end_date;
					var td = tr.insertCell(6);
					td.innerHTML = datas[i].nums;
					
				}
			}	
		    
	   	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[1];   	    
	   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[1];
	   
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
	

	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[0];
		        document.getElementById("s_project_name").value = checkStr[1];
	    }
	}
	
</script>
</html>