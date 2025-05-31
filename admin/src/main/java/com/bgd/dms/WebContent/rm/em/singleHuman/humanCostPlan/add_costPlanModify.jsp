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
    
	String projectType = user.getProjectType();
	String businessType_s="5110000004100000048";
	
	if(projectType.equals("5000100004000000008")){
		businessType_s="5110000004100001050";
	}
    
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null || "".equals(projectInfoNo)){
		 projectInfoNo = user.getProjectInfoNo();
	}
	String planId = request.getParameter("id");
	if(planId==null || "".equals(planId)){
		planId = request.getParameter("planId");
	}

	

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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
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
	
cruConfig.contextPath =  "<%=contextPath%>";

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}


function toSubmit(){

    processNecessaryInfo={         
    		businessTableName:"bgp_comm_human_plan_cost",    //置入流程管控的业务表的主表表明
    		businessType:'<%=businessType_s%>',        //业务类型 即为之前设置的业务大类
    		businessId:'<%=planId%>',         //业务主表主键值
    		businessInfo:"单项目人工成本计划流程",        //用于待审批界面展示业务信息
    		applicantDate:'<%=curDate%>'       //流程发起时间
    	}; 
    	processAppendInfo={ 
    			id: '<%=planId%>',
    			projectInfoNo:'<%=projectInfoNo%>',
    			buttonView:"false"
    	};  
    	
	if (!window.confirm("确认要提交吗?")) {
			return;
	}	
	
	var querySql = "select t.middle_id from common_busi_wf_middle t where t.business_id='<%=planId%>' and t.business_type='<%=businessType_s%>' and t.proc_status <>'4'";		
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	
	if(datas!=null && datas.length>0){
		alert("该申请单已提交!");
		return;
	}
	
	jcdpCallService("HumanCommInfoSrv","updateHumanPlanNo","planId=<%=planId%>");	
	
	submitProcessInfo();
	//top.frames('list').refreshTree();	
	top.frames('list').location.reload();
	newClose();
}



function page_init(){

	var projectInfoNo = '<%=projectInfoNo%>';	
	var planId = '<%=planId%>';

	
	if(planId!='null'){
		var querySql = "select p.project_name, (select wmsys.wm_concat(i.org_abbreviation) from  gp_task_project_dynamic d  left join  comm_org_information i on d.org_id=i.org_id and i.bsflag='0' where p.project_info_no=d.project_info_no  and d.bsflag='0'  )  org_name,   nvl(d3.workarea, p.workarea_no) as workarea_name,d4.coding_name surface_type,nvl(c.plan_no,'申请提交后系统自动生成') plan_no  from gp_task_project p left join gp_workarea_diviede d3 on p.workarea_no = d3.workarea_no and d3.bsflag='0'  left join comm_coding_sort_detail d4 on d3.surface_type=d4.coding_code_id and d4.bsflag='0'  left join bgp_comm_human_plan_cost c on p.project_info_no=c.project_info_no  and c.bsflag='0'    where p.bsflag='0'  and c.plan_id='"+planId+"'   ";		
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null &&  datas!=''){
			
			document.getElementById("project_name").value=datas[0].project_name;
			document.getElementById("org_name").value=datas[0].org_name;
			document.getElementById("workarea_name").value=datas[0].workarea_name;
			document.getElementById("surface_type").value=datas[0].surface_type;			
			document.getElementById("plan_no").value=datas[0].plan_no;		
		}			
	}

	if(planId!='null'){
		var querySql = "select t.* from bgp_comm_human_cost_plan t left join bgp_comm_human_plan_cost c on t.plan_id=c.plan_id and c.bsflag='0'    where c.plan_id='"+planId+"'    and t.bsflag='0'  and t.project_info_no='"+projectInfoNo+"' ";		

		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null && datas!='' ){ 
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
	
	if(planId!='null'){
		var querySql = "select t.*,d.coding_name employee_gz_name from bgp_comm_human_cost_plan_deta t left join comm_coding_sort_detail d on t.employee_gz=d.coding_code_id left join bgp_comm_human_plan_cost c on t.plan_id=c.plan_id and c.bsflag='0'     where c.plan_id='"+planId+"' and t.project_info_no='"+projectInfoNo+"'     and t.bsflag='0'  order by t.show_order  ";

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
		
	if(planId!='null'){
		var querySql = " select t.*  from (select '' coding_code_id,  '' coding_code,  '' plan_sala_id,  '' project_info_no,  sum(s.sum_human_cost) sum_human_cost,  sum(s.cont_cost) cont_cost,  sum(s.mark_cost) mark_cost,  sum(s.temp_cost) temp_cost,  sum(s.reem_cost) reem_cost,  sum(s.serv_cost) serv_cost,  '' subject_id,  '' notes1,  '总计' coding_name,  1 coding_show_order,  '#4BAA34' t_color    from comm_human_coding_sort t  left join (select s.* from bgp_comm_human_cost_plan_sala s inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no     and c.bsflag='0'   and s.plan_id = c.plan_id    where   s.bsflag='0' ) s on t.coding_code_id = s.subject_id     where t.coding_sort_id = '0000000002'  and t.bsflag = '0'  and s.plan_id = '"+planId+"'    and length(t.coding_code) = '2') t  " +
				" union all select  w.* from ( select t.coding_code_id, t.coding_code,  s.plan_sala_id,s.project_info_no,s.sum_human_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost,s.serv_cost,s.subject_id,s.notes notes1,  t.coding_name, t.coding_show_order,  ct.t_color  from comm_human_coding_sort t  left join (select s.* from bgp_comm_human_cost_plan_sala s inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no     and c.bsflag='0'   and s.plan_id = c.plan_id    where   s.bsflag='0' ) s on t.coding_code_id = s.subject_id       left join (select distinct coding_code, '#4BAA34' as t_color   from comm_human_coding_sort   where length(coding_code) = '2'   and bsflag = '0') ct on ct.coding_code = t.coding_code    where t.coding_sort_id = '0000000002'  and t.bsflag = '0'  and s.plan_id = '"+planId+"'  order by t.coding_code, t.coding_show_order  )w ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		for (var i = 0; i<datas.length; i++) {		
			
			var tr = document.getElementById("salalineTable").insertRow();	
			
//         	if(i % 2 == 1){  
//         		tr.className = "even";
//			}else{ 
//				tr.className = "odd";
//			}
//			
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
		 
        	
//			var td = tr.insertCell(0);
//			td.innerHTML = datas[i].coding_name;
			
			var td = tr.insertCell(1);
			td.innerHTML = datas[i].sum_human_cost;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].cont_cost;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].mark_cost;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].temp_cost;
		
			var td = tr.insertCell(5);
			td.innerHTML = datas[i].reem_cost;
			
			var td = tr.insertCell(6);
			td.innerHTML = datas[i].serv_cost;
			
			var td = tr.insertCell(7);
			td.innerHTML = datas[i].notes1;
			
		}	
		
	}

}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();" style="overflow-y:auto">
<div>
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
         <td class="inquire_item4">项目名称：</td>
         <td class="inquire_form4"><input name="project_name" id="project_name" class="input_width" value="" type="text" /></td>
         <td class="inquire_item4">施工单位:</td>
         <td class="inquire_form4"><input name="org_name" id="org_name" class="input_width" value="" type="text" />
         </td>
       </tr>
       <tr>
         <td class="inquire_item4">申请单号：</td>
         <td class="inquire_form4"><input name="plan_no" id="plan_no" class="input_width" value="" type="text" /></td>
         <td class="inquire_item4">&nbsp;</td>
         <td class="inquire_form4">&nbsp;</td>
       </tr>
       <tr>
         <td class="inquire_item4">区块（矿权）：</td>
         <td class="inquire_form4"><input name="workarea_name" id="workarea_name"  value="" class="input_width" type="text" /></td>
         <td class="inquire_item4">施工地表、地类：</td>
         <td class="inquire_form4"><input name="surface_type" id="surface_type" value="" class="input_width" type="text" /></td>                                   
       </tr>
       <tr>
         <td class="inquire_item4">主要采集方法：</td>
         <td class="inquire_form4" colspan="3"><input name=""  id=""   value="" class="input_width" type="text" /></td>
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
          <td class="bt_info_odd">合同化员工</td>
          <td class="bt_info_even">市场化用工</td>		
          <td class="bt_info_odd">临时季节工</td>
          <td class="bt_info_even">再就业人员</td>			
          <td class="bt_info_odd">劳务派遣</td>           
          <td class="bt_info_even">备注</td> 
        </tr>
	</table>	
</div> 
</div>
<% 
String buttonView = request.getParameter("buttonView"); 
if("true".equals(buttonView)){
%>
    <div id="oper_div">
        <span class="tj_btn"><a href="#" onclick="toSubmit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    <%} %>
</body>
</html>
