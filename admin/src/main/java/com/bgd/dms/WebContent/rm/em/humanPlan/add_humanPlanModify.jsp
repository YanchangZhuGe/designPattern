<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

    String projectInfoNo = request.getParameter("projectInfoNo");
    String projectInfoType = request.getParameter("projectInfoType");
    String paramNo = request.getParameter("paramNo");
    String planIds = request.getParameter("planIds");
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['BGP_HUMAN_ARTIFICIAL_COST']
);
var defaultTableName = 'BGP_HUMAN_ARTIFICIAL_COST';
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
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}

var paramNo='<%=paramNo%>';
var planIds='<%=planIds%>';
var projectInfoType='<%=projectInfoType%>';

var projectInfoNo = '<%=request.getParameter("projectInfoNo")%>';	
function page_init(){ 

//	var action = '<%=request.getParameter("action")%>';
	if(projectInfoNo!='null'){
		var querySql0 ="";
		var queryRet0=null;
		var datas0=null;
		var querySql1="";
		var queryRet1=null;
		var datas1=null 
		
		
		var querySql2="";
		var queryRet2=null;
		var datas2=null 
		
		var querySql3="";
		var queryRet3=null;
		var datas3=null 
		
		
	       if(paramNo !='null' && paramNo !=''){  
	    	   if(paramNo=='0'){ 
	    			  querySql0 = "select  t.plan_id,t.project_info_no,p.project_name,t.plan_no,t.apply_company,i.org_name,t.applicant_id,e.employee_name,t.apply_date,t.proc_status from bgp_comm_human_plan t left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  left join comm_org_information i on t.apply_company=i.org_id and i.bsflag='0'  left join comm_human_employee e on t.applicant_id=e.employee_id and e.bsflag='0' where t.bsflag='0' and t.spare1='"+paramNo+"'  and t.plan_id='"+planIds+"' and t.project_info_no='"+projectInfoNo+"'";
	    			  queryRet0 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql0);
	    			  datas0 = queryRet0.datas; 
		    			 if(datas0 != null){
		    				document.getElementById("project_name").value=datas0[0].project_name;
		    				document.getElementById("plan_no").value=datas0[0].plan_no;
		    				document.getElementById("employee_name").value=datas0[0].employee_name;
		    				document.getElementById("apply_date").value=datas0[0].apply_date;		
		    				// 项目是否在p6中 
							
							 querySql2 = " select t.object_id , t.wbs_object_id   from bgp_p6_project t where   t.bsflag='0' and  t.project_info_no = '"+projectInfoNo+"'";
			    			  queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql2);
			    			  datas2 = queryRet2.datas;
				    			 if(datas2 != null){
				    				 
				    				 querySql3 = "  select w.object_id  as ids    from bgp_p6_project_wbs w  where w.parent_object_id = '"+datas2[0].wbs_object_id+"'   and w.bsflag = '0'  union all  select to_number(to_char(a.object_id) || to_char(a.project_object_id)) as ids   from bgp_p6_activity a   where a.wbs_object_id = '"+datas2[0].wbs_object_id+"'     and a.bsflag = '0'  ";
					    			  queryRet3 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql3);
					    			  datas3 = queryRet3.datas;
					    			  if(datas3.length>0){
						    	 
				    				 
						    			  querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date)+1  nums,a.name,a.planned_start_date,a.planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'     left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'  where d.project_info_no='"+projectInfoNo+"' and d.spare1='"+datas0[0].plan_id+"' and d.bsflag='0' ) p ";
						    			  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
						    			  datas1 = queryRet1.datas;
					    			 }else{
					    				 
						    			  querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date)+1  nums,  '-' name, '-'  planned_start_date,  '-'  planned_finish_date,   '-' planned_duration   from bgp_comm_human_plan_detail d    left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'    left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'    where d.project_info_no='"+projectInfoNo+"' and d.spare1='"+datas0[0].plan_id+"' and d.bsflag='0' ) p ";
						    			  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
						    			  datas1 = queryRet1.datas;
					    				 
					    			 }
				    			 } 
		    			 }
	    	   }
	    	   
	       }else{
 
				  querySql0 = "select  t.project_info_no,p.project_name,t.plan_no,t.apply_company,i.org_name,t.applicant_id,e.employee_name,t.apply_date,t.proc_status from bgp_comm_human_plan t left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  left join comm_org_information i on t.apply_company=i.org_id and i.bsflag='0'  left join comm_human_employee e on t.applicant_id=e.employee_id and e.bsflag='0' where t.bsflag='0'   and t.spare1 is null  and t.project_info_no='"+projectInfoNo+"'";
				  queryRet0 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql0);
				  datas0 = queryRet0.datas;
					if(datas0 != null){
						document.getElementById("project_name").value=datas0[0].project_name;
						document.getElementById("plan_no").value=datas0[0].plan_no;
						document.getElementById("employee_name").value=datas0[0].employee_name;
						document.getElementById("apply_date").value=datas0[0].apply_date;		
					}
					// 项目是否在p6中 
					
					 querySql2 = " select t.object_id , t.wbs_object_id   from bgp_p6_project t where   t.bsflag='0' and  t.project_info_no = '"+projectInfoNo+"'";
	    			  queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql2);
	    			  datas2 = queryRet2.datas; 
		    			 if(datas2 != null){
		    				 
		    				 
		    				 querySql3 = "  select w.object_id  as ids    from bgp_p6_project_wbs w  where w.parent_object_id = '"+datas2[0].wbs_object_id+"'   and w.bsflag = '0'  union all  select to_number(to_char(a.object_id) || to_char(a.project_object_id)) as ids   from bgp_p6_activity a   where a.wbs_object_id = '"+datas2[0].wbs_object_id+"'     and a.bsflag = '0'  ";
			    			  queryRet3 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql3);
			    			  datas3 = queryRet3.datas;
			    			  if(datas3.length>0){
				    	 
				    			
			   				  querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date)+1  nums,a.name,a.planned_start_date,a.planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'   left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'  where d.project_info_no='"+projectInfoNo+"'  and d.spare1 is null  and d.bsflag='0' ) p ";
							  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
							  datas1 = queryRet1.datas;
								 
			    			 }else{ 
				   				  querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date)+1  nums,    '-' name, '-'  planned_start_date,  '-' planned_finish_date,   '-' planned_duration  from bgp_comm_human_plan_detail d     left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'    left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'    where d.project_info_no='"+projectInfoNo+"'  and d.spare1 is null  and d.bsflag='0' ) p ";
								  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
								  datas1 = queryRet1.datas;
			    			 }
			    			 
		    			 }
	       }
			
		var sumNum=0;
		var zNum=0;
		if(datas1 != null){
			for (var i = 0; i< queryRet1.datas.length; i++) {
				
				var tr = document.getElementById("taskList").insertRow();		

            	if(i % 2 == 1){  
              		classCss = "even_";
            	}else{ 
            		classCss = "odd_";
            	}
              	
				var td = tr.insertCell(0);
				td.className=classCss+"odd";
				td.innerHTML = datas1[i].rownum;
				
				var td = tr.insertCell(1);
				td.className=classCss+"even";
				td.innerHTML = datas1[i].name;
				
				var td = tr.insertCell(2);
				td.className=classCss+"odd";
				td.innerHTML = datas1[i].planned_start_date;

				var td = tr.insertCell(3);
				td.className=classCss+"even";
				td.innerHTML = datas1[i].planned_finish_date;
				
				var td = tr.insertCell(4);
				td.className=classCss+"odd";
				td.innerHTML = datas1[i].planned_duration;
				
				var td = tr.insertCell(5);
				td.className=classCss+"even";
				td.innerHTML = datas1[i].apply_team_name;
				
				var td = tr.insertCell(6);
				td.className=classCss+"odd";
				td.innerHTML = datas1[i].post_name;

				var td = tr.insertCell(7);
				td.className=classCss+"even";
				td.innerHTML = datas1[i].people_number;
				var numSum=datas1[i].people_number;
				sumNum=parseInt(numSum)+parseInt(sumNum); 
				var td = tr.insertCell(8);
				td.className=classCss+"odd";
				td.innerHTML = datas1[i].profess_number;
				var numZ=datas1[i].profess_number;
				zNum=parseInt(numZ)+parseInt(zNum);
				var td = tr.insertCell(9);
				td.className=classCss+"even";
				td.innerHTML = datas1[i].plan_start_date;
				
				var td = tr.insertCell(10);
				td.className=classCss+"odd";
				td.innerHTML = datas1[i].plan_end_date;
				
				var td = tr.insertCell(11);
				td.className=classCss+"even";
				td.innerHTML = datas1[i].nums;

			}
		}
		
		document.getElementById("sumNum").innerText=sumNum; 
		document.getElementById("zNum").innerText=zNum; 
	}

}

function toExportExcel(){
	window.open("<%=contextPath%>/rm/em/exportHumanPlanM.srq?projectInfoNo=<%=projectInfoNo%>&plan_id="+planIds+"&paramNo="+paramNo+"&projectInfoType="+projectInfoType);

}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">

    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
         <td class="inquire_item8">项目名称：</td>
         <td class="inquire_form8"><input name="plan_id" id="plan_id" value="" class="input_width" type="hidden" /> <input name="project_name" id="project_name" value="" class="input_width" type="text" /></td>
         <td class="inquire_item8">申请单号：</td>
         <td class="inquire_form8"><input name="plan_no" id="plan_no"  value="" class="input_width" type="text"  /></td>
         <td class="inquire_item8">提交人：</td>
         <td class="inquire_form8"><input name="employee_name" id="employee_name" value="" class="input_width" type="text"  /></td>
         <td class="inquire_item8">提交日期：</td>
         <td class="inquire_form8"><input name="apply_date" id="apply_date"   value="" class="input_width" type="text"  /></td>	                                   
       </tr>
	</table>
</div>  

<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td  >计划人数合计：&nbsp;<label id="sumNum" name="sumNum" style="color:red;">0</label> &nbsp;&nbsp; 
		        其中专业化人数合计：&nbsp;<label id="zNum" name="zNum" style="color:red;">0</label></td> 
			
		    <td>&nbsp;</td>
		    <auth:ListButton css="xz" event="onclick='toExportExcel()'" title="JCDP_btn_exportTemplate"></auth:ListButton>
		  </tr>
		</table>
	</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>

<div style="width:100%;overflow-x:scroll;overflow-y:scroll;"> 			
	<table id="taskList" width="1400" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd">序号</td>
    	    <td class="bt_info_even">作业名称</td>
            <td class="bt_info_odd">计划开始时间</td>
            <td class="bt_info_even">计划结束时间</td>		
            <td class="bt_info_odd">原定工期</td>
            <td class="bt_info_even">班组</td>
            <td class="bt_info_odd">岗位</td>			
            <td class="bt_info_even">计划人数</td> 
            <td class="bt_info_odd">其中专业化人数</td>			
            <td class="bt_info_even">计划进入时间</td> 
            <td class="bt_info_odd">计划离开时间</td>        
            <td class="bt_info_even">天数</td>
        </tr>
     </table>
</div>

</body>
</html>
