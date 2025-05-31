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
    String taskId = request.getParameter("taskId");
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
cruConfig.contextPath='<%=contextPath %>';

var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['BGP_COMM_HUMAN_PLAN']
);
var defaultTableName = 'BGP_COMM_HUMAN_PLAN';
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
	cruConfig.openerUrl = "/rm/singleHuman/humanRequest/taskPlanList.jsp";
	cru_init();
	
}


function save(){
	
	var task_id=document.getElementById("task_id").value;
	var project_info_no=document.getElementById("project_info_no").value;
	var rowNum = document.getElementById("lineNum").value;	
	
	var rowParams = new Array();
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
				
		var plan_detail_id = "";
		var apply_team = "";
		var post = "";
		var people_number = "";
		var plan_start_date = "";
		var plan_end_date = "";
		var nums = "";
		var notes = "";
		
		var plan_detail_id = document.getElementsByName("plan_detail_id_"+i)[0].value;			
		var apply_team = document.getElementsByName("apply_team_"+i)[0].value;			
		var post = document.getElementsByName("post_"+i)[0].value;			
		var people_number = document.getElementsByName("people_number_"+i)[0].value;			
		var plan_start_date = document.getElementsByName("plan_start_date_"+i)[0].value;			
		var plan_end_date = document.getElementsByName("plan_end_date_"+i)[0].value;			
		var notes = document.getElementsByName("notes_"+i)[0].value;			
		var bsflag = document.getElementsByName("bsflag_"+i)[0].value;			

		
		rowParam['task_id'] = task_id;		
		rowParam['project_info_no'] = project_info_no;		
		rowParam['bsflag'] = bsflag;		
		rowParam['plan_detail_id'] = plan_detail_id;
		rowParam['apply_team'] = apply_team;
		rowParam['post'] = post;
		rowParam['people_number'] = people_number;
		rowParam['plan_start_date'] = plan_start_date;
		rowParam['plan_end_date'] = plan_end_date;
		rowParam['notes'] = encodeURI(encodeURI(notes));

		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';

		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams);

		saveFunc("bgp_comm_human_plan_detail",rows);	
		top.frames('list').frames('mainRightframe').refreshData(task_id,project_info_no);
}






function page_init(){
	
	var plan_detail_id = '<%=request.getParameter("id")%>';	
//	var action = '<%=request.getParameter("action")%>';
	if(plan_detail_id!='null'){
		var querySql = "select d.plan_detail_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,d.people_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date + 1 ) nums,d.notes from bgp_comm_human_plan_detail d left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where d.plan_detail_id='"+plan_detail_id+"' and d.bsflag='0' order by d.modifi_date  ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && queryRet.datas.length; i++) {			
			addLine(datas[i].plan_detail_id,datas[i].apply_team,datas[i].post,datas[i].people_number,datas[i].plan_start_date,datas[i].plan_end_date,datas[i].nums,datas[i].notes);
		}			
	}

}


</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();" style="overflow-y:auto" >
	<div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	    <tr>
	    	<td class="inquire_item4">项目名称：</td>
	      	<td class="inquire_form4">	      	
	      	<input type="hidden" id="plan_id" name="plan_id" value="" class="input_width" />
	      	<input type="hidden" id="project_info_no" name="project_info_no" value="" class="input_width" />
	      	<input type="text" id="project_name" name="project_name" value="" class="input_width" />
	      	</td>
	      	<td class="inquire_item4">施工队伍：</td>
	      	<td class="inquire_form4"><input type="text" id="apply_company" name="apply_company" value="" class="input_width" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">计划提交人：</td>
	      	<td class="inquire_form4"><input type="text" id="applicant_id" name="applicant_id" value="" class="input_width" /></td>
	      	<td class="inquire_item4">提交时间：</td>
	      	<td class="inquire_form4"><input type="text" id="apply_date" name="apply_date" value="" class="input_width" /></td>
	    </tr>
	   	<tr>
	    	<td class="inquire_item4">单号：</td>
	      	<td class="inquire_form4"><input type="text" id="plan_no" name="plan_no" value="系统自动生成" /></td>
	      	<td class="inquire_item4">审批流程：</td>
	      	<td class="inquire_form4"><input type="text"  value="" class="input_width" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">备注：</td>
	      	<td class="inquire_form4"><input type="text" id="notes" name="notes" value="" class="input_width" /></td>
	      	<td class="inquire_item4">附件：</td>
	      	<td class="inquire_form4"><input type="text"  value="" class="input_width" /></td>
	    </tr>
	</table>
	</div>  

    <div ic="oper_div" align="center">
     	<span class="tj"><a href="#" onclick="save()"></a></span>
        <span class="gb"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
</html>
