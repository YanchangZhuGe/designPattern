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
    String codingCodeId = request.getParameter("codingCodeId");
    String costState = request.getParameter("costState");
    String superiorCodeId = request.getParameter("superiorCodeId");
    
	String projectInfoNo = user.getProjectInfoNo();
	String orgId = user.getOrgId();
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgAffordId = user.getSubOrgIDofAffordOrg();


%>
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
['BGP_COMM_HUMAN_COST_ACT_DETA']
);
var defaultTableName = 'BGP_COMM_HUMAN_COST_ACT_DETA';
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

var costState = "<%=costState%>";
var projectInfoNo = "<%=projectInfoNo%>";
var orgId = "<%=orgId%>";
var orgSubjectionId = "<%=orgSubjectionId%>";
var superiorCodeId = "<%=superiorCodeId%>";
var orgAffordId = "<%=orgAffordId%>";

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}


function save(){

	var actual_deta_id = document.getElementById("actual_deta_id").value;	
	var sum_human_cost = document.getElementById("sum_human_cost").value;
	var cont_cost = document.getElementById("cont_cost").value;
	var mark_cost = document.getElementById("mark_cost").value;
	var temp_cost = document.getElementById("temp_cost").value;
	var reem_cost = document.getElementById("reem_cost").value;
	var serv_cost = document.getElementById("serv_cost").value;
	var subject_id = document.getElementById("subject_id").value;
	var app_date = document.getElementById("app_date").value;
	var spare1 = document.getElementById("spare1").value;
	
	var rowParams = new Array();
	var rowParam = {};
	
	rowParam['app_date'] = app_date;		
	rowParam['actual_deta_id'] = actual_deta_id;		
	rowParam['sum_human_cost'] = sum_human_cost;		
	rowParam['cont_cost'] = cont_cost;		
	rowParam['mark_cost'] = mark_cost;		
	rowParam['temp_cost'] = temp_cost;		
	rowParam['reem_cost'] = reem_cost;		
	rowParam['serv_cost'] = serv_cost;	
	
	rowParam['spare1'] = spare1;		
	rowParam['cost_state'] = costState;		
	rowParam['project_info_no'] = projectInfoNo;		
	rowParam['subject_id'] = subject_id;		
	rowParam['org_id'] = orgId;		
	rowParam['org_subjection_id'] = orgSubjectionId;		

	rowParam['create_date'] = '<%=curDate%>';
	rowParam['modifi_date'] = '<%=curDate%>';
	rowParam['bsflag'] = '0';

	rowParams[rowParams.length] = rowParam;
	var rows=JSON.stringify(rowParams);

	 saveFunc("bgp_comm_human_cost_act_deta",rows);	
		//情况s标题内容,先删除 父级数据
    	var sqlA="delete  from bgp_comm_human_cost_act_deta t   where t.subject_id='"+spare1+"'   and t.project_info_no='"+projectInfoNo+"'";
		 
		var pathA = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var paramsA = "deleteSql="+sqlA;
		paramsA += "&ids=";
		syncRequest('Post',pathA,paramsA);
	 
		//查询父级下的子级汇总，然后给父级增加
		var querySql = "select rownum, t.* from (  select tr.app_date, sum(tr.sum_human_cost) sum_human_cost ,sum(tr.cont_cost) cont_cost,sum(tr.mark_cost) mark_cost,sum(tr.temp_cost)temp_cost ,sum(tr.reem_cost) reem_cost,sum(tr.serv_cost)serv_cost  from ( select    to_char(  t.app_date,'yyyy-MM')app_date,   t.sum_human_cost,t.cont_cost,t.mark_cost,t.temp_cost,t.reem_cost,t.serv_cost                   from bgp_comm_human_cost_act_deta t    where t.project_info_no = '"+projectInfoNo+"'   and t.spare1='"+spare1+"'      and t.bsflag = '0'      and t.org_subjection_id like '"+orgAffordId+"' ) tr group by tr.app_date )t ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; i<datas.length; i++) { 
	    //添加s下合计内容
	    	var rowParamsA = new Array();
	    	var rowParamA = {}; 
		    	rowParamA['app_date'] = datas[i].app_date+"-01";		
		    	rowParamA['actual_deta_id'] = "";		
		    	rowParamA['sum_human_cost'] = datas[i].sum_human_cost;		
		    	rowParamA['cont_cost'] = datas[i].cont_cost;		
		    	rowParamA['mark_cost'] = datas[i].mark_cost;		
		    	rowParamA['temp_cost'] = datas[i].temp_cost;	
		    	rowParamA['reem_cost'] = datas[i].reem_cost;	
		    	rowParamA['serv_cost'] =  datas[i].serv_cost;
		     
		    	rowParamA['project_info_no'] = projectInfoNo;		
		    	rowParamA['subject_id'] = spare1;		
		    	rowParamA['org_id'] = orgId;		
		    	rowParamA['org_subjection_id'] = orgSubjectionId;		
		
		    	rowParamA['create_date'] = '<%=curDate%>';
		    	rowParamA['modifi_date'] = '<%=curDate%>';
		    	rowParamA['bsflag'] = '0';
		
		    	rowParamsA[rowParamsA.length] = rowParamA;
		    	var rowsA=JSON.stringify(rowParamsA); 
	    	saveFuncA("bgp_comm_human_cost_act_deta",rowsA);	
	    	
	}
	top.frames('list').refreshTree();
	newClose();
}

//保存
function saveFuncA(tableName,rowParams){
	var path = getContextPath()+"/rad/addOrUpdateEntities.srq";
	submitStr = "tableName="+tableName+"&"+"rowParams="+rowParams;
	//alert(submitStr);
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);
 
}

function page_init(){

	var codingCodeId = '<%=request.getParameter("codingCodeId")%>';	
	var id = '<%=request.getParameter("id")%>';	

	if(id!='null'){
		var querySql = "select t.* from bgp_comm_human_cost_act_deta t where t.actual_deta_id='"+id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
	
		if(datas!=null && datas.length>0){
			
			document.getElementById("actual_deta_id").value=datas[0].actual_deta_id;
			document.getElementById("sum_human_cost").value=datas[0].sum_human_cost;
			document.getElementById("cont_cost").value=datas[0].cont_cost;
			document.getElementById("mark_cost").value=datas[0].mark_cost;
			document.getElementById("temp_cost").value=datas[0].temp_cost;
			document.getElementById("reem_cost").value=datas[0].reem_cost;
			document.getElementById("serv_cost").value=datas[0].serv_cost;
			document.getElementById("subject_id").value=datas[0].subject_id;
			document.getElementById("app_date").value=datas[0].app_date; 
			document.getElementById("spare1").value=datas[0].spare1;
			
		}
		
	}else{
		document.getElementById("subject_id").value=codingCodeId;
		document.getElementById("spare1").value=superiorCodeId;
		
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
 


function calculateCost(){
	var sumTotalCharge=0;
 
	var cont_cost = document.getElementById("cont_cost").value;
	var mark_cost = document.getElementById("mark_cost").value;
	var reem_cost = document.getElementById("temp_cost").value;
	var recruit_cost = document.getElementById("reem_cost").value;
	var worker_cost = document.getElementById("serv_cost").value;
	if(""!=cont_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(cont_cost);
	}
	if(""!=mark_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(mark_cost);
	}
	if(reem_cost != ''){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(reem_cost);
	}
	if(""!=recruit_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(recruit_cost);
	}
	if(""!=worker_cost){
		sumTotalCharge = parseFloat(sumTotalCharge)+parseFloat(worker_cost);
	}
	document.getElementById("sum_human_cost").value=substrin(sumTotalCharge);
}

function substrin(str){ 
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
 	       <td class="inquire_item4">日期：</td>
           <td class="inquire_form4">
           <input name="app_date" id="app_date" class="input_width" value="" type="text" readonly="readonly"/>
           <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(app_date,tributton1);" />
           <input name="actual_deta_id" id="actual_deta_id" class="input_width" value="" type="hidden" />
           <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" />
           <input name="subject_id" id="subject_id" class="input_width" value="" type="hidden" />
           <input name="spare1" id="spare1" class="input_width" value="" type="hidden" />
           
           </td>
           <td class="inquire_item4">&nbsp;</td>
           <td class="inquire_form4">&nbsp;</td>
	  </tr>
 	 <tr>
 	       <td class="inquire_item4">本月人工成本发生总额：</td>
           <td class="inquire_form4">
           <input name="sum_human_cost" id="sum_human_cost" class="input_width" value=""  readonly="readonly" type="text" />
           </td>
           <td class="inquire_item4">合同化员工：</td>
           <td class="inquire_form4">
           <input name="cont_cost" id="cont_cost" class="input_width" onblur="calculateCost()"  value="" type="text" />          
           </td>
	  </tr>
	  <tr>
 	       <td class="inquire_item4">市场化用工：</td>
           <td class="inquire_form4">
           <input name="mark_cost" id="mark_cost" class="input_width" onblur="calculateCost()"  value="" type="text" />
           </td>
           <td class="inquire_item4">再就业人员：</td>
           <td class="inquire_form4">
           <input name="temp_cost" id="temp_cost" class="input_width"  onblur="calculateCost()" value="" type="text" />          
           </td>
	  </tr>  
	  <tr>
 	       <td class="inquire_item4">招聘骨干：</td>
           <td class="inquire_form4">
           <input name="reem_cost" id="reem_cost" class="input_width" onblur="calculateCost()" value="" type="text"/>
           </td>
           <td class="inquire_item4">外雇工：</td>
           <td class="inquire_form4">
           <input name="serv_cost" id="serv_cost" class="input_width" onblur="calculateCost()"  value="" type="text" />          
           </td>
	  </tr>         
 	</table>
</div>  

    <div id="oper_div">
		<span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
</html>
