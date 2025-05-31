<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

	String projectInfoNo = user.getProjectInfoNo();
	String orgAffordId = user.getSubOrgIDofAffordOrg();

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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>

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
['BGP_COMM_HUMAN_COST_PLAN']
);
var defaultTableName = 'BGP_COMM_HUMAN_COST_PLAN';
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

 //选择项目
   function selectTeam(){

       var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
       if(result!=""){
       	var checkStr = result.split("-");	
	        document.getElementById("s_project_info_no").value = checkStr[0];
	        document.getElementById("s_project_name").value = checkStr[1];
       }
   }




function simpleSearch(){

	var projectInfoNo = document.getElementById("s_project_info_no").value;	
	var orgAffordId = "<%=orgAffordId%>";
	
	if(projectInfoNo==''){
		alert("请选择项目");
		return;
	}
	
	if(projectInfoNo!=''){
		var querySql = "select p.project_name, (select wmsys.wm_concat(i.org_abbreviation) from  gp_task_project_dynamic d  left join  comm_org_information i on d.org_id=i.org_id and i.bsflag='0' where p.project_info_no=d.project_info_no  and d.bsflag='0'  )  org_name,   nvl(d3.workarea, p.workarea_no) as workarea_name,d4.coding_name surface_type from gp_task_project p left join gp_workarea_diviede d3 on p.workarea_no = d3.workarea_no and d3.bsflag='0'  left join comm_coding_sort_detail d4 on d3.surface_type=d4.coding_code_id and d4.bsflag='0' where p.bsflag='0' and p.project_info_no='"+projectInfoNo+"'";		
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			
			document.getElementById("project_name").value=datas[0].project_name;
			document.getElementById("org_name").value=datas[0].org_name;
			document.getElementById("workarea_name").value=datas[0].workarea_name;
			document.getElementById("surface_type").value=datas[0].surface_type;			
		}			
	}

	if(projectInfoNo!=''){
		var querySql = "select sum(t.work_load) work_load, sum(t.fix_num) fix_num, sum(t.daily_acti) daily_acti , sum(t.const_month)  const_month, sum(t.nodal_period)nodal_period , sum(t.const_period )const_period, sum(t.holoday_season )holoday_season, sum(t.wages_month) wages_month, sum(t.acti_work_mon) acti_work_mon   from bgp_comm_human_cost_plan t   inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'    and te.proc_status='3'   )c  on t.plan_id = c.plan_id    where t.project_info_no='"+projectInfoNo+"' and  t.bsflag='0'  and t.org_subjection_id not like 'C105006%25'";		
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			
			document.getElementById("work_load").value=datas[0].work_load;
			document.getElementById("fix_num").value=datas[0].fix_num;
			document.getElementById("daily_acti").value=datas[0].daily_acti;
			
			document.getElementById("const_month").value=datas[0].const_month;
			document.getElementById("nodal_period").value=datas[0].nodal_period;
			document.getElementById("const_period").value=datas[0].const_period;
			
			document.getElementById("holoday_season").value=datas[0].holoday_season;
			document.getElementById("wages_month").value=datas[0].wages_month;
			document.getElementById("acti_work_mon").value=datas[0].acti_work_mon;
			
		}			
	}
	
	deleteTableTr("lineTable");
	deleteTableTr("salalineTable");
	
	if(projectInfoNo!=''){
		var querySql = "select  t.show_order,d.coding_name employee_gz_name ,sum(gz_num) gz_num,sum(sys_wage) sys_wage ,sum(post_allow) post_allow,sum(area_allow) area_allow,sum(month_allow) month_allow,sum(lunch_wage) lunch_wage,sum(food_wage) food_wage from bgp_comm_human_cost_plan_deta t left join comm_coding_sort_detail d on t.employee_gz=d.coding_code_id  inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'    and te.proc_status='3'   )c  on t.plan_id = c.plan_id  where t.project_info_no='"+projectInfoNo+"' and  t.bsflag='0'  and t.org_subjection_id not like 'C105006%25'  group by  t.show_order,d.coding_name order by t.show_order  ";
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		for (var i = 0; i<datas.length; i++) {		
			
			var tr = document.getElementById("lineTable").insertRow();	
			
         	if(i % 2 == 1){  
         		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
			
			var td = tr.insertCell(0);
			td.innerHTML = datas[i].employee_gz_name;
			
			var td = tr.insertCell(1);
			td.innerHTML = datas[i].gz_num;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].sys_wage;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].post_allow;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].area_allow;
		
			var td = tr.insertCell(5);
			td.innerHTML = datas[i].month_allow;
			
			var td = tr.insertCell(6);
			td.innerHTML = datas[i].lunch_wage;
			
			var td = tr.insertCell(7);
			td.innerHTML = datas[i].food_wage;
			
		}	

	}
		
	if(projectInfoNo!=''){
		var querySqlSum = "select  sum(( t.sum_human_cost14 + t.sum_human_cost22 ))sum_cost  from (select t.coding_name,t.coding_code,  sum(s.sum_human_cost) sum_human_cost1, nvl( sum(s.sum_human_cost),0) sum_human_cost14, sum(s1.sum_human_cost) sum_human_cost2,nvl(sum(s1.sum_human_cost),0) sum_human_cost22 ,  ct.t_color  from comm_human_coding_sort t     left join  ( select sum(s1.sum_human_cost) sum_human_cost,s1.subject_id  from  bgp_comm_human_cost_plan_sala  s1   inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'    and c.cost_state = '1'  and te.proc_status='3'   )c  on s1.plan_id = c.plan_id   where  s1.project_info_no =  '"+projectInfoNo+"'    and s1.org_subjection_id  not  like'C105006%25'   and s1.bsflag = '0'    group by  s1.subject_id  ) s      on t.coding_code_id = s.subject_id      left join  ( select sum(s1.sum_human_cost) sum_human_cost,s1.subject_id  from  bgp_comm_human_cost_plan_sala  s1   inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'    and c.cost_state = '0'  and te.proc_status='3'   )c  on s1.plan_id = c.plan_id  where  s1.project_info_no =  '"+projectInfoNo+"'    and s1.org_subjection_id  not  like'C105006%25'   and s1.bsflag = '0'    group by  s1.subject_id  ) s1      on t.coding_code_id = s1.subject_id  left join  (   select  distinct coding_code,'#4BAA34'as  t_color  from comm_human_coding_sort where length(coding_code) ='2' and bsflag='0' ) ct    on ct.coding_code=t.coding_code  where t.coding_sort_id = '0000000002'  and t.bsflag = '0'  and  length(t.coding_code) = '2'    group by t.coding_name,t.coding_code,t.coding_show_order ,ct.t_color  order by t.coding_code, t.coding_show_order ,ct.t_color) t ";
		var querySql = "select t.* ,( t.sum_human_cost14 + t.sum_human_cost22 )sum_cost  from (select t.coding_name,t.coding_code,  sum(s.sum_human_cost) sum_human_cost1, nvl( sum(s.sum_human_cost),0) sum_human_cost14, sum(s1.sum_human_cost) sum_human_cost2,nvl(sum(s1.sum_human_cost),0) sum_human_cost22 ,  ct.t_color  from comm_human_coding_sort t     left join  ( select sum(s1.sum_human_cost) sum_human_cost,s1.subject_id  from  bgp_comm_human_cost_plan_sala  s1   inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'    and c.cost_state = '1'  and te.proc_status='3'   )c  on s1.plan_id = c.plan_id   where  s1.project_info_no =  '"+projectInfoNo+"'    and s1.org_subjection_id  not  like'C105006%25'   and s1.bsflag = '0'    group by  s1.subject_id  ) s      on t.coding_code_id = s.subject_id      left join  ( select sum(s1.sum_human_cost) sum_human_cost,s1.subject_id  from  bgp_comm_human_cost_plan_sala  s1   inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'    and c.cost_state = '0'  and te.proc_status='3'   )c  on s1.plan_id = c.plan_id  where  s1.project_info_no =  '"+projectInfoNo+"'    and s1.org_subjection_id  not  like'C105006%25'   and s1.bsflag = '0'    group by  s1.subject_id  ) s1      on t.coding_code_id = s1.subject_id  left join  (   select  distinct coding_code,'#4BAA34'as  t_color  from comm_human_coding_sort where length(coding_code) ='2' and bsflag='0' ) ct    on ct.coding_code=t.coding_code  where t.coding_sort_id = '0000000002'  and t.bsflag = '0'  group by t.coding_name,t.coding_code,t.coding_show_order ,ct.t_color  order by t.coding_code, t.coding_show_order ,ct.t_color) t ";
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		querySqlSum=encodeURI(querySqlSum);
		var queryRetSum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlSum);
		var datasSum = queryRetSum.datas;
 
		 if( datasSum.length !=null	){
			
			var tr = document.getElementById("salalineTable").insertRow();	
			 
			if (datasSum[0].sum_cost !=''){ 
				tr.align="center";
				tr.style.color="#4BAA34";
				var td = tr.insertCell(0);
				//对一级菜单coding_code ,做处理加颜色  ,加序号
 
				td.innerHTML ="总计";
			} 
	
			var td = tr.insertCell(1);
			td.innerHTML = datasSum[0].sum_cost;
			
			var td = tr.insertCell(2);
			td.innerHTML = "";
			
			var td = tr.insertCell(3);
			td.innerHTML = "";
				
			var td = tr.insertCell(4);
			td.innerHTML = "";
		 
	}
		
		for (var i = 0; i<datas.length; i++) {		
			
			var tr = document.getElementById("salalineTable").insertRow();	
			 
			if (datas[i].t_color !=''){
				tr.align="center";
				tr.style.color= datas[i].t_color;
				var td = tr.insertCell(0);
				//对一级菜单coding_code ,做处理加颜色  ,加序号
					var coding_code=datas[i].coding_code;
					var codeC = coding_code.substr(0,1);
					var codeD="";
					if(codeC=='0'){ 
						codeD=coding_code.substring(1);
					}else{
						codeD=datas[i].coding_code;
					}
 
				td.innerHTML =codeD+". "+datas[i].coding_name;
			}else{
	         	if(i % 2 == 1){  
	         		tr.className = "even";
				}else{ 
					tr.className = "odd";
				}
	         	var td = tr.insertCell(0);
				td.innerHTML = datas[i].coding_name;
			}
			
			
	
			var td = tr.insertCell(1);
			td.innerHTML = datas[i].sum_cost;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].sum_human_cost1;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].sum_human_cost2;
				
			var td = tr.insertCell(4);
			td.innerHTML = "";
		}	
		
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
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();" style="overflow-y:auto">
<div>
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali_cdn_name" width="20%">项目名称：</td>
    <td  width="20%">
     <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
     <input name="s_project_name" id="s_project_name" class="input_width" value="" type="text" readonly="readonly"/>   
     <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>     
    </td>
 	<td class="ali_query" width="20%">
   		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
  	</td>
	<td>&nbsp;</td>
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
         <td class="inquire_item4">项目名称：</td>
         <td class="inquire_form4"><input name="project_name" id="project_name" class="input_width" value="" type="text" /></td>
         <td class="inquire_item4">施工单位:</td>
         <td class="inquire_form4"><input name="org_name" id="org_name" class="input_width" value="" type="text" /></td>
       </tr>
       <tr>
         <td class="inquire_item4">施工地区：</td>
         <td class="inquire_form4"><input name="workarea_name" id="workarea_name"  value="" class="input_width" type="text" /></td>
         <td class="inquire_item4">施工地表、地类：</td>
         <td class="inquire_form4"><input name="surface_type" id="surface_type" value="" class="input_width" type="text" /></td>                                   
       </tr>
       <tr>
         <td class="inquire_item4">主要采集方法：</td>
         <td class="inquire_form4" colspan="3"><input value="" class="input_width" type="text" /></td>
       </tr>
	</table>	
</div> 

<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
         <td class="inquire_item6">工作量（炮数）：</td>
         <td class="inquire_form6"><input name="work_load" id="work_load" class="input_width" value="" type="text" /></td>
         <td class="inquire_item6">定员:</td>
         <td class="inquire_form6"><input name="fix_num" id="fix_num" class="input_width" value="" type="text" /></td>
         <td class="inquire_item6">日效（定额）:</td>
         <td class="inquire_form6"><input name="daily_acti" id="daily_acti" class="input_width" value="" type="text" /></td>
       </tr>
       <tr>
         <td class="inquire_item6">定额施工月：</td>
         <td class="inquire_form6"><input name="const_month" id="const_month"  value="" class="input_width" type="text" /></td>
         <td class="inquire_item6">准结期：</td>
         <td class="inquire_form6"><input name="nodal_period" id="nodal_period" value="" class="input_width" type="text" /></td>
         <td class="inquire_item6">承包期（月）：</td>
         <td class="inquire_form6"><input name="const_period" id="const_period"   value="" class="input_width" type="text" /></td>	                                   
       </tr>
       <tr>
         <td class="inquire_item6">休假期(月）：</td>
         <td class="inquire_form6"><input name="holoday_season"  id="holoday_season"   value="" class="input_width" type="text" /></td>
         <td class="inquire_item6">工资月（含休假期）:</td>
         <td class="inquire_form6"><input name="wages_month"  id="wages_month"   value="" class="input_width" type="text" /></td>
         <td class="inquire_item6">实际工作月（计划）:</td>
         <td class="inquire_form6"><input name="acti_work_mon"  id="acti_work_mon"   value="" class="input_width" type="text" /></td>
       </tr>
	</table>	
</div>  

<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" id="lineTable" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    	<tr>
  	      <td class="bt_info_odd">员工类型</td>
  	      <td class="bt_info_even">人数</td>
          <td class="bt_info_odd">制度工资（元）/劳务费</td>
          <td class="bt_info_even">上岗津贴（元/日）</td>		
          <td class="bt_info_odd">地区津贴（元/月）</td>
          <td class="bt_info_even">月奖金（元）</td>			
          <td class="bt_info_odd">误餐费（元/日）</td>           
          <td class="bt_info_even">伙食费（元/月）</td> 
        </tr>
	</table>	
</div> 

<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%;">
 	<table width="99%" id="salalineTable" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    	<tr>
  	      <td class="bt_info_odd">项目</td>
  	      <td class="bt_info_even">总计（万元）</td>
          <td class="bt_info_odd">物探处（万元）</td>
          <td class="bt_info_even">专业化单位（万元）</td>		         
          <td class="bt_info_even">备注</td> 
        </tr>
	</table>	
</div> 
</div>
</body>
</html>
