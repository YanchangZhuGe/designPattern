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

    String action = request.getParameter("action");
    String addButtonDisplay="";
    if("view".equals(action)) addButtonDisplay="none";
    String projectInfoNo = request.getParameter("projectInfoNo");
    String artificialNo = request.getParameter("artificialNo");

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


function save(){

	var artificial_no = document.getElementById("artificial_no").value;
	var project_info_no = document.getElementById("project_info_no").value;
//	var plan_no = document.getElementById("plan_no").value;
	var project_contract = document.getElementById("project_contract").value;
	var norm_construction = document.getElementById("norm_construction").value;
	var standard_knot = document.getElementById("standard_knot").value;
	var turn_rest = document.getElementById("turn_rest").value;
	var project_staff = document.getElementById("project_staff").value;
	var contract_emp = document.getElementById("contract_emp").value;
	var market_emp = document.getElementById("market_emp").value;
	var temp_emp = document.getElementById("temp_emp").value;
	var service_emp = document.getElementById("service_emp").value;
	var reemp_emp = document.getElementById("reemp_emp").value;
	var sum_human_cost = document.getElementById("sum_human_cost").value;
	var contract_cost = document.getElementById("contract_cost").value;
	var contract_weal = document.getElementById("contract_weal").value;
	var contract_jiti = document.getElementById("contract_jiti").value;	
	var contract_other = document.getElementById("contract_other").value;	
	var market_cost = document.getElementById("market_cost").value;
	var market_weal = document.getElementById("market_weal").value;
	var market_jiti = document.getElementById("market_jiti").value;
	var market_other = document.getElementById("market_other").value;
	var temp_cost = document.getElementById("temp_cost").value;
	var temp_other = document.getElementById("temp_other").value;
	var service_cost = document.getElementById("service_cost").value;
	var service_other = document.getElementById("service_other").value;
	var reemp_cost = document.getElementById("reemp_cost").value;
	var reemp_other = document.getElementById("reemp_other").value;
		
		var rowParams = new Array();
		var rowParam = {};
		rowParam['artificial_no'] = artificial_no;		
		rowParam['project_info_no'] = project_info_no;		
//		rowParam['plan_no'] = plan_no;		
		rowParam['project_contract'] = project_contract;
		rowParam['norm_construction'] = norm_construction;
		rowParam['standard_knot'] = standard_knot;
		rowParam['turn_rest'] = turn_rest;
		rowParam['project_staff'] = project_staff;
		rowParam['contract_emp'] = contract_emp;
		rowParam['market_emp'] = market_emp;
		rowParam['temp_emp'] = temp_emp;
		rowParam['service_emp'] = service_emp;
		rowParam['reemp_emp'] = reemp_emp;
		rowParam['sum_human_cost'] = sum_human_cost;
		rowParam['contract_cost'] = contract_cost;
		rowParam['contract_weal'] = contract_weal;
		rowParam['contract_jiti'] = contract_jiti;
		rowParam['contract_other'] = contract_other;
		rowParam['market_cost'] = market_cost;
		rowParam['market_weal'] = market_weal;
		rowParam['market_jiti'] = market_jiti;
		rowParam['market_other'] = market_other;
		rowParam['temp_cost'] = temp_cost;
		rowParam['temp_other'] = temp_other;
		rowParam['service_cost'] = service_cost;
		rowParam['service_other'] = service_other;
		rowParam['reemp_cost'] = reemp_cost;
		rowParam['reemp_other'] = reemp_other;

		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';
		rowParam['bsflag'] = '0';

		rowParams[rowParams.length] = rowParam;
		var rows=JSON.stringify(rowParams);

		saveFunc("bgp_human_artificial_cost",rows);	
		
		top.frames('list').loadDataDetail('<%=projectInfoNo%>');
		newClose();
}



function page_init(){

	var projectInfoNo = '<%=request.getParameter("projectInfoNo")%>';	
//	var action = '<%=request.getParameter("action")%>';
	if(projectInfoNo!='null'){
		var querySql = "select t.* from bgp_human_artificial_cost t where t.project_info_no='"+projectInfoNo+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && queryRet.datas.length; i++) {
			
			document.getElementById("artificial_no").value=datas[i].artificial_no;
//			document.getElementById("project_info_no").value=datas[i].project_info_no;
//			document.getElementById("plan_no").value=datas[i].plan_no;
			document.getElementById("project_contract").value=datas[i].project_contract;
			document.getElementById("norm_construction").value=datas[i].norm_construction;
			document.getElementById("standard_knot").value=datas[i].standard_knot;
			document.getElementById("turn_rest").value=datas[i].turn_rest;
			document.getElementById("project_staff").value=datas[i].project_staff;
			document.getElementById("contract_emp").value=datas[i].contract_emp;
			document.getElementById("market_emp").value=datas[i].market_emp;
			document.getElementById("temp_emp").value=datas[i].temp_emp;
			document.getElementById("service_emp").value=datas[i].service_emp;
			document.getElementById("reemp_emp").value=datas[i].reemp_emp;
			document.getElementById("sum_human_cost").value=datas[i].sum_human_cost;
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

}

function calculateCost(){
	
	var sumTotalCharge=0;
	
	var contract_cost = document.getElementById("contract_cost").value;
	var contract_weal = document.getElementById("contract_weal").value;
	var contract_other = document.getElementById("contract_other").value;
	var market_cost = document.getElementById("market_cost").value;
	var market_weal = document.getElementById("market_weal").value;
	var market_other = document.getElementById("market_other").value;
	var temp_cost = document.getElementById("temp_cost").value;
	var temp_other = document.getElementById("temp_other").value;
	var service_cost = document.getElementById("service_cost").value;
	var service_other = document.getElementById("service_other").value;
	var reemp_cost = document.getElementById("reemp_cost").value;
	var reemp_other = document.getElementById("reemp_other").value;
	
	if(checkNum("contract_cost")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(contract_cost);
	}
	if(checkNum("contract_weal")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(contract_weal);
	}
	if(checkNum("contract_other")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(contract_other);
	}
	if(checkNum("market_cost")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(market_cost);
	}
	if(checkNum("market_weal")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(market_weal);
	}
	if(checkNum("market_other")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(market_other);
	}
	if(checkNum("temp_cost")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(temp_cost);
	}
	if(checkNum("temp_other")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(temp_other);
	}
	if(checkNum("service_cost")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(service_cost);
	}
	if(checkNum("service_other")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(service_other);
	}
	if(checkNum("reemp_cost")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(reemp_cost);
	}
	if(checkNum("reemp_other")){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(reemp_other);
	}

	document.getElementById("sum_human_cost").value=substrin(sumTotalCharge);
		
}

function calculateEmp(){
	
	var sumProjectStaff=0;
	
	var contract_emp = document.getElementById("contract_emp").value;
	var market_emp = document.getElementById("market_emp").value;
	var temp_emp = document.getElementById("temp_emp").value;
	var service_emp = document.getElementById("service_emp").value;
	var reemp_emp = document.getElementById("reemp_emp").value;
	
	if(checkNaN("contract_emp")){
		sumProjectStaff = parseInt(sumProjectStaff)+parseInt(contract_emp);
	}
	if(checkNaN("market_emp")){
		sumProjectStaff = parseInt(sumProjectStaff)+parseInt(market_emp);
	}
	if(checkNaN("temp_emp")){
		sumProjectStaff = parseInt(sumProjectStaff)+parseInt(temp_emp);
	}
	if(checkNaN("service_emp")){
		sumProjectStaff = parseInt(sumProjectStaff)+parseInt(service_emp);
	}
	if(checkNaN("reemp_emp")){
		sumProjectStaff = parseInt(sumProjectStaff)+parseInt(reemp_emp);
	}

	document.getElementById("project_staff").value=substrin(sumProjectStaff);
		
}

function checkNaN(numids){

	 var str = document.getElementById(numids).value;
	 if(str!=""){		 
		if(isNaN(str)){
			alert("请输入数字");
			document.getElementById(numids).value="";
			return false;
		}else{
			return true;
		}
	  }
}

function checkNum(numids){
	 var pattern =/^[0-9]+([.]\d{1,2})?$/;
	 var str = document.getElementById(numids).value;
	 if(str!=""){
		 if(!pattern.test(str)){
		     alert("请输入数字(例:0.00),最高保留两位小数");
		     document.getElementById(numids).value="";
		     return false;
		 }else{
			 return true;
		 }
	  }
}
function substrin(str)
{ 
	str = Math.round(str * 10000) / 10000;
	return(str); 
 }
 
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">

    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
	                  <td class="inquire_item6">项目承包期：</td>
	                  <td class="inquire_form6">
	                  <input name="project_info_no" id="project_info_no" value="<%=projectInfoNo %>" class="input_width" type="hidden" />
	                  <input name="artificial_no" id="artificial_no" class="input_width" value="" type="hidden" />
	                  <input name="project_contract" id="project_contract" class="input_width" value="" type="text" />月
	                  </td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	                <tr>
	                  <td class="inquire_item6">准结期：</td>
	                  <td class="inquire_form6"><input name="standard_knot" id="standard_knot"  value="" class="input_width" type="text"  />月</td>
	                  <td class="inquire_item6">定额施工期：</td>
	                  <td class="inquire_form6"><input name="norm_construction" id="norm_construction" value="" class="input_width" type="text"  />月</td>
	                  <td class="inquire_item6">项目轮休期：</td>
	                  <td class="inquire_form6"><input name="turn_rest" id="turn_rest"   value="" class="input_width" type="text"  />月</td>	                                   
	                </tr>
	                  <tr><td colspan="6">&nbsp;</td></tr>
	                <tr>
	                  <td class="inquire_item6">定员：</td>
	                  <td class="inquire_form6"><input name="project_staff"  id="project_staff"   value="" class="input_width" type="text"  />人</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	               <tr>	                 
	                  <td class="inquire_item6">合同化员工：</td>
	                  <td class="inquire_form6"><input name="contract_emp"  id="contract_emp"  value="" onblur="calculateEmp()" class="input_width" type="text"  />人</td>
	                  <td class="inquire_item6">市场化用工：</td>
	                  <td class="inquire_form6"><input name="market_emp"  id="market_emp" value=""  onblur="calculateEmp()" class="input_width" type="text"  />人</td>
					  <td class="inquire_item6">临时季节性用工：</td>
	                  <td class="inquire_form6"><input name="temp_emp"  id="temp_emp"  value="" onblur="calculateEmp()" class="input_width" type="text"  />人</td>
	                </tr>
	               <tr>	                  
	                  <td class="inquire_item6">劳务用工：</td>
	                  <td class="inquire_form6"><input name="service_emp"  id="service_emp"  value="" onblur="calculateEmp()" class="input_width" type="text"  />人</td>
	                  <td class="inquire_item6">再就业人员：</td>
	                  <td class="inquire_form6"><input name="reemp_emp"  id="reemp_emp"  value="" onblur="calculateEmp()" class="input_width" type="text"  />人</td>
	               	  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	                  <tr><td colspan="6">&nbsp;</td></tr>
	                 <tr>
	                  <td class="inquire_item6">项目人工费投入计划：</td>
	                  <td class="inquire_form6"><input name="sum_human_cost"  id="sum_human_cost"  value=""  class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
	                <tr>	                 
	                  <td class="inquire_item6">合同化员工工资总额：</td>
	                  <td class="inquire_form6"><input name="contract_cost"  id="contract_cost"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">合同化员工补贴总额：</td>
	                  <td class="inquire_form6"><input name="contract_weal"  id="contract_weal"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">合同化员工工资计提：</td>
	                  <td class="inquire_form6"><input name="contract_jiti"  id="contract_jiti"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                </tr>
	                <tr>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="contract_other"  id="contract_other"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">市场化用工工资总额：</td>
	                  <td class="inquire_form6"><input name="market_cost"  id="market_cost"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">市场化用工补贴总额：</td>
	                  <td class="inquire_form6"><input name="market_weal"  id="market_weal"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                </tr>
	                <tr>
	                  <td class="inquire_item6">市场化员工工资计提：</td>
	                  <td class="inquire_form6"><input name="market_jiti"  id="market_jiti"  value=""  onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="market_other"  id="market_other"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">临时季节用工劳务费总额：</td>
	                  <td class="inquire_form6"><input name="temp_cost"  id="temp_cost"  value=""  onblur="calculateCost()" class="input_width" type="text"  />万元</td>	                  
	                </tr>
	                <tr>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="temp_other"  id="temp_other"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">劳务用工劳务费总额：</td>
	                  <td class="inquire_form6"><input name="service_cost"  id="service_cost"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="service_other"  id="service_other"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>                  
	                </tr>
	                <tr>
	                  <td class="inquire_item6">再就业人员总额：</td>
	                  <td class="inquire_form6"><input name="reemp_cost"  id="reemp_cost"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>	             	                  
	                  <td class="inquire_item6">其他费用：</td>
	                  <td class="inquire_form6"><input name="reemp_other"  id="reemp_other"  value="" onblur="calculateCost()" class="input_width" type="text"  />万元</td>
	               	  <td class="inquire_item6">&nbsp;</td>
	                  <td class="inquire_form6">&nbsp;</td>
	                </tr>
 	
					</table>
</div>  

    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
</html>
