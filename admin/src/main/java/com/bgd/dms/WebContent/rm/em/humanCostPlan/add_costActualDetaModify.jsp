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
	String projectInfoNoType = user.getProjectType();
	String projectInfoNo = user.getProjectInfoNo();
	String orgAffordId = user.getSubOrgIDofAffordOrg();

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
	var projectInfoNo = document.getElementById("s_project_info_no").value;	
	var appDate = document.getElementById("s_app_date").value;
	var projectInfoNoType ="<%=projectInfoNoType%>";
	
	if(projectInfoNoType!=null){
		if(projectInfoNoType == "5000100004000000009" ){ 
			 document.getElementById("ldDiv").style.display="none";
			 document.getElementById("zhDiv").style.display="block";
			 
			 document.getElementById("zhView").src = "<%=contextPath%>/rm/em/humanCostPlan/zh_costActualDetaModify.jsp?projectInfoNo="+projectInfoNo+"&appDate="+appDate;

		}else {
			 document.getElementById("ldDiv").style.display="block";
			 document.getElementById("zhDiv").style.display="none";
			 
			 document.getElementById("ldView").src = "<%=contextPath%>/rm/em/humanCostPlan/ld_costActualDetaModify.jsp?projectInfoNo="+projectInfoNo+"&appDate="+appDate;

		}
		
	}else{
		document.getElementById("ldView").src = "<%=contextPath%>/rm/em/humanCostPlan/ld_costActualDetaModify.jsp?projectInfoNo="+projectInfoNo+"&appDate="+appDate;
	}
}
           

function simpleSearch(){
	var projectInfoNo = document.getElementById("s_project_info_no").value;	
	var appDate = document.getElementById("s_app_date").value;
	var project_type = document.getElementById("project_type").value;
	if(project_type !="" && project_type !=null){
		if(project_type == "5000100004000000009" ){ 
			 document.getElementById("ldDiv").style.display="none";
			 document.getElementById("zhDiv").style.display="block";
			 
			 document.getElementById("zhView").src = "<%=contextPath%>/rm/em/humanCostPlan/zh_costActualDetaModify.jsp?projectInfoNo="+projectInfoNo+"&appDate="+appDate;

		}else {
			 document.getElementById("ldDiv").style.display="block";
			 document.getElementById("zhDiv").style.display="none";
			 
			   document.getElementById("ldView").src = "<%=contextPath%>/rm/em/humanCostPlan/ld_costActualDetaModify.jsp?projectInfoNo="+projectInfoNo+"&appDate="+appDate;

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

//选择项目
function selectTeam(){

    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
    if(result!=""){
    	var checkStr = result.split("-");	
    	
	        document.getElementById("s_project_info_no").value = checkStr[0];
	        document.getElementById("s_project_name").value = checkStr[1];
	        document.getElementById("project_type").value = checkStr[2];
    }
}
</script>

</head>
<body onload="page_init();" style="overflow-y:hidden;height:500px;">
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali_cdn_name" width="20%">项目名称：</td>
    <td  width="20%">
     <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
     <input name="s_project_name" id="s_project_name" class="input_width" value="" type="text" readonly="readonly"/>   
     <input name="project_type" id="project_type" class="input_width" value="" type="hidden" readonly="readonly"/> 
     <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>     
    </td>
    <td class="ali_cdn_name" width="20%">日期</td>
    <td  width="20%">
     <input name="s_app_date" id="s_app_date" class="input_width" value="<%=curDate%>" type="text" readonly="readonly"/>
          <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calMonthSelector(s_app_date,tributton1);" />
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
<div  id="ldDiv"  style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%;height:100%;"> 
	<iframe width="100%" height="100%" name="ldView" id="ldView" frameborder="0" src="" marginheight="0" marginwidth="0" >
	</iframe>
 

</div> 
<div  id="zhDiv"   style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%;height:100%;display:none;" >
<iframe width="100%" height="100%" name="zhView" id="zhView" frameborder="0" src="" marginheight="0" marginwidth="0" >
</iframe>
</div>


</body>
</html>
