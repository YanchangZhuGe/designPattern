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

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
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
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td  width="20%">		    
			    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
    			<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
    			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
    			 </td>
    			<td class="ali_cdn_name">单据状态</td>
			    <td  width="20%">
			    <select name="s_proc_status" id="s_proc_status" class="select_width" >
			    <option value="">请选择</option>
			    <option value="1">待审核</option>
			    <option value="3">审批通过</option>
			    <option value="4">审批不通过</option>
			    </select>			     
			    </td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			  	<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{plan_id}-{gid}-{project_type}' id='rdo_entity_id_{project_info_no}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{plan_no}">单号</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{employee_name}">提交人</td>
			      <td class="bt_info_even" exp="{apply_date}">提交日期</td>
			      <td class="bt_info_odd" exp="{proc_status_name}">单据状态</td>
			      
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
			<div id="view1" style="display:block;">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">岗位需求</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">作业需求</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">审批流程</a></li>			    
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
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>				
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
				</div>
		 	</div>
	  </div>
			 <div id="view2" style="display:none;height:300px;" > 
						<iframe width="100%" height="100%" name="zdP" id="zdP" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
		   
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_idA="<%=orgSubjectionId%>";
//	cruConfig.funcCode = "F_HUMAN_003";
	
	// 简单查询
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;
		var s_proc_status = document.getElementById("s_proc_status").value;

		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += " and project_name like '%"+s_project_info_no+"%' ";						
		}	
		if(s_proc_status!=''){			
			str += " and proc_status like '"+s_proc_status+"%' ";						
		}
		cruConfig.cdtStr = str;
		refreshData();
	}
	
    
	function clearQueryText(){ 
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		document.getElementById("s_proc_status").value="";
		cruConfig.cdtStr = "";
	}
	
	function refreshData(){

		cruConfig.queryStr = "select * from (select  '1' gid,decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, t.project_info_no,p.project_type,p.project_name,t.plan_no,t.plan_id,t.apply_company org_id,i.org_name,t.applicant_id,e.employee_name,t.apply_date,te.proc_status from bgp_comm_human_plan t left join common_busi_wf_middle te on    te.business_id =t.plan_id   and te.bsflag='0' and business_type  in ('5110000004100000022','5110000004100001057') left    join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  left join comm_org_information i on t.apply_company=i.org_id and i.bsflag='0'   left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join comm_human_employee e on t.applicant_id=e.employee_id and e.bsflag='0' where t.bsflag='0'  and t.spare1 is null  and cosb.org_subjection_id like'"+org_subjection_idA+"%'  and te.proc_status is not null   union all  select  '2'gid,decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, t.project_info_no,p.project_type,p.project_name,t.plan_no,t.plan_id,t.apply_company org_id,i.org_name,t.applicant_id,e.employee_name,t.apply_date,te.proc_status from bgp_comm_human_plan t left join common_busi_wf_middle te on    te.business_id =t.project_info_no    and te.bsflag='0' and business_type in('5110000004100001019','5110000004100001016','5110000004100001022','5110000004100001024','5110000004100001023','5110000004100001021','5110000004100000095')   left  join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  left join comm_org_information i on t.apply_company=i.org_id and i.bsflag='0'   left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join comm_human_employee e on t.applicant_id=e.employee_id and e.bsflag='0' where t.bsflag='0'  and t.spare1 is null  and cosb.org_subjection_id like'"+org_subjection_idA+"%'  and te.proc_status is not null   ) t  order by  t.proc_status asc , t.apply_date desc  ";
		cruConfig.currentPageUrl = "/rm/singleHuman/humanRequest/taskPlanList.jsp";
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

 
	
	
    function loadDataDetail(ids){
    	var viewP=ids.split("-")[2];
    	
		var project_type= ids.split("-")[3];    	
    	var businessType_s="5110000004100000022";
    	if(project_type =='5000100004000000008'){
    		businessType_s="5110000004100001057";
    	}
    	
  	  if(viewP == "1"){
  		  document.getElementById("view1").style.display="block";
	       document.getElementById("view2").style.display="none";
    	 processNecessaryInfo={         
   	    		businessTableName:"bgp_comm_human_plan",    //置入流程管控的业务表的主表表明
   	    		businessType:businessType_s,        //业务类型 即为之前设置的业务大类
   	    		businessId:ids.split("-")[1],         //业务主表主键值
   	    		businessInfo:"单项目需求计划申请",        //用于待审批界面展示业务信息
   	    		applicantDate:'<%=appDate%>'       //流程发起时间
   	    	}; 
     
    		
   	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[1];   	    
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[1];
   	    
    	var querySql = "select rownum,p.* from (select p.apply_team_name, p.post_name,p.apply_team, p.post,sum(nvl(p.people_number,0)) people_number , sum(nvl(p.profess_number,0)) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date))+1 nums from ( select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where d.project_info_no='"+ids.split("-")[0]+"' and d.spare1 is null  and d.bsflag='0' ) p group by p.apply_team_name,p.post_name ,p.apply_team, p.post ) p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		var querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) +1 nums,a.name,a.planned_start_date,a.planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id || '' and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where d.project_info_no='"+ids.split("-")[0]+"' and d.spare1 is  null  and d.bsflag='0' ) p ";
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
		
  	  }else{
 
  	    	document.getElementById("view1").style.display="none";
	       document.getElementById("view2").style.display="block";
	       document.getElementById("zdP").src = "<%=contextPath%>/rm/em/humanPlan/oD.jsp?ids="+encodeURI(encodeURI(ids,'UTF-8'),'UTF-8'); 
	   
  		  
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