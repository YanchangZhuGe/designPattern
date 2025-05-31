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
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
    String curDate = format.format(new Date());
    
	String projectInfoNo = user.getProjectInfoNo();		
	String orgAffordId = user.getSubOrgIDofAffordOrg();
	String orgSubjectionId = user.getOrgSubjectionId();
	
	String orgSql = "";
	
	if(orgAffordId.startsWith("C105006")){
		orgSql = " like  'C105006%25' ";
	}else{
		orgSql = " not like  'C105006%25' ";
	}
	//1为物探处0为专业化单位
	String costState = "1";	
	if(orgSubjectionId!=null && orgSubjectionId.length()>7 && orgSubjectionId.substring(0, 7).startsWith("C105006")){
		costState = "0";
	}
	


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
['bgp_comm_human_cost_plan_deta']
);
var defaultTableName = 'bgp_comm_human_cost_plan_deta';
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

function simpleSearch(){
	
	 page_init();
 
}

function page_init(){

	var projectInfoNo = '<%=projectInfoNo%>';	
	var orgAffordId = "<%=orgAffordId%>";
	var costState = "<%=costState%>";
	
	var appDate = document.getElementById("app_date").value;
	
	if(projectInfoNo!='null'){
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
	 
	if(projectInfoNo!='null'){
		var querySql = "select t.coding_name,sum(c.sum_human_cost) sum_cost, s1.sum_human_cost sum_cost_act, s.sum_human_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost,s.serv_cost, t.coding_code, t.coding_show_order , ct.t_color ,sum(c.sum_human_cost)-nvl(s1.sum_human_cost,0) last_num  from comm_human_coding_sort t   left join (select s.project_info_no, s.subject_id, sum(s.sum_human_cost) sum_human_cost, sum(s.cont_cost) cont_cost, sum(s.mark_cost) mark_cost, sum(s.temp_cost) temp_cost, sum(s.reem_cost) reem_cost, sum(s.serv_cost) serv_cost from bgp_comm_human_cost_act_deta s where s.project_info_no = '"+projectInfoNo+"' and s.bsflag='0'  and s.org_subjection_id <%=orgSql%> and to_char(s.app_date, 'yyyy-MM') <= '"+appDate+"'  group by s.project_info_no, s.subject_id) s1 on t.coding_code_id =  s1.subject_id  left join bgp_comm_human_cost_act_deta s on t.coding_code_id = s.subject_id and s.bsflag='0' and s.project_info_no='"+projectInfoNo+"' and s.org_subjection_id <%=orgSql%> and to_char(s.app_date,'yyyy-MM')='"+appDate+"' left join bgp_comm_human_cost_plan_sala c on t.coding_code_id=c.subject_id  and c.project_info_no='"+projectInfoNo+"' and c.org_subjection_id <%=orgSql%> and c.bsflag='0'  inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0'   and c.cost_state = '"+costState+"'    and te.proc_status='3'   )c1  on c1.plan_id = c.plan_id    left join (select distinct coding_code, '#4BAA34' as t_color   from comm_human_coding_sort   where length(coding_code) = '2'   and bsflag = '0') ct on ct.coding_code = t.coding_code     where t.coding_sort_id = '0000000002' and t.bsflag = '0'   group by t.coding_name,   t.coding_code, t.coding_show_order, s1.sum_human_cost,   s.sum_human_cost,    s.cont_cost, s.mark_cost,   s.temp_cost,      s.reem_cost,    s.serv_cost , ct.t_color   order by t.coding_code, t.coding_show_order";
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		deleteTableTr("lineTable");
		for (var i = 0; i<datas.length; i++) {
			
			var tr = document.getElementById("lineTable").insertRow();	
			
//         	if(i % 2 == 1){  
//         		tr.className = "even";
//			}else{ 
//				tr.className = "odd";
//			}
         	
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
		 
         	
// 			var td = tr.insertCell(0);
//			td.innerHTML = datas[i].coding_name;
			
 			var td = tr.insertCell(1);
			td.innerHTML = datas[i].sum_cost;
			
 			var td = tr.insertCell(2);
			td.innerHTML = datas[i].sum_cost_act;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].sum_human_cost;
			
			var td = tr.insertCell(4);
			td.innerHTML = datas[i].cont_cost;
			
			var td = tr.insertCell(5);
			td.innerHTML = datas[i].mark_cost;
		
			var td = tr.insertCell(6);
			td.innerHTML = datas[i].temp_cost;
			
			var td = tr.insertCell(7);
			td.innerHTML = datas[i].reem_cost;
			
			var td = tr.insertCell(8);
			td.innerHTML = datas[i].serv_cost;
			
			var td = tr.insertCell(9);
			td.innerHTML = datas[i].last_num;
						
		}		
	}

}

function calMonthSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    false,
		step	       :	1
    });
}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();" style="overflow-y:auto">
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali_cdn_name" width="20%">日期</td>
    <td  width="20%">
     <input name="app_date" id="app_date" class="input_width" value="<%=curDate%>" type="text" readonly="readonly"/>
          <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calMonthSelector(app_date,tributton1);" />
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
         <td class="inquire_item4">区块（矿权）：</td>
         <td class="inquire_form4"><input name="workarea_name" id="workarea_name"  value="" class="input_width" type="text" /></td>
         <td class="inquire_item4">施工地表、地类：</td>
         <td class="inquire_form4"><input name="surface_type" id="surface_type" value="" class="input_width" type="text" /></td>                                   
       </tr>
       <tr>
         <td class="inquire_item4">主要采集方法：</td>
         <td class="inquire_form4" colspan="3"><input  value="" class="input_width" type="text" /></td>
       </tr>
	</table>	
</div> 
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" id="lineTable" border="0" cellspacing="0" cellpadding="0">
    	<tr>
  	      <td class="bt_info_odd">项目</td>
  	      <td class="bt_info_even">计划总额（万元）</td>
          <td class="bt_info_odd">至本月末累计人工费发生总额</td>
          <td class="bt_info_even">本月人工成本发生总额</td>		
          <td class="bt_info_odd">合同化员工</td>
          <td class="bt_info_even">市场化用工</td>			
          <td class="bt_info_odd">临时季节工</td>           
          <td class="bt_info_even">再就业人员</td> 
          <td class="bt_info_odd">劳务派遣</td> 
          <td class="bt_info_even">人工成本计划总额与实际发生差额</td> 
        </tr>
	</table>	
</div>  


</body>
</html>
