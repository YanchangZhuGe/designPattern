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
   
    String action = request.getParameter("action")==null?"":request.getParameter("action");
    String codingCodeId = request.getParameter("codingCodeId")==null?"":request.getParameter("codingCodeId");
    String codingLever = request.getParameter("codingLever")==null?"":request.getParameter("codingLever");
    String codingSortId = request.getParameter("codingSortId")==null?"":request.getParameter("codingSortId");
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
['comm_coding_sort_deatil']
);
var defaultTableName = 'comm_coding_sort_deatil';
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
var codingSortId="<%=codingSortId%>";
var codingCodeId="<%=codingCodeId%>"
var codingLever="<%=codingLever%>"	
var action="<%=action%>";

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
}


function update(){
	var coding_code_id = document.getElementById("coding_code_id").value;	
	var coding_name = document.getElementById("coding_name").value;
	
	var rowParams = new Array();
	var rowParam = {};
	rowParam['coding_code_id'] = coding_code_id;		
	rowParam['coding_name'] = encodeURI(encodeURI(coding_name));		

	rowParam['create_date'] = '<%=curDate%>';
	rowParam['modifi_date'] = '<%=curDate%>';
	rowParam['bsflag'] = '0';

	rowParams[rowParams.length] = rowParam;
	var rows=JSON.stringify(rowParams);

	saveFunc("comm_human_coding_sort",rows);	

	top.frames('list').refreshTree();
	newClose();
}

function save(){
	var params = $("#myForm").serialize();
	var obj = jcdpCallService("HumanCommInfoSrv","saveHumanCostPlanCodes",params);
	top.frames('list').refreshTree();
	newClose();
}


function page_init(){
	document.getElementById("coding_sort_id").value=codingSortId;
	if("edit"==action){//修改
		var querySql = "select t.* from comm_human_coding_sort t where t.coding_code_id='"+codingCodeId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(null!=datas){
			document.getElementById("coding_code_id").value=codingCodeId;
			document.getElementById("coding_name").value=datas[0].coding_name;
			document.getElementById("superior_code_id").value=datas[0].superior_code_id;
			document.getElementById("coding_lever").value=datas[0].coding_lever;
		}
	}else{//新增
		var querySql = "select '000000000'||to_char(max(coding_code_id)+1) as coding_code_id from comm_human_coding_sort";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(null!=datas){
			document.getElementById("superior_code_id").value=codingCodeId;
			document.getElementById("coding_code_id").value=datas[0].coding_code_id;
			document.getElementById("coding_lever").value=Number(codingLever)+1;
		}
	}
}

 
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">
    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
    <form name="myForm" id="myForm"  method="post" action="">
	 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	 	 <tr>
	 	       <td class="inquire_item4">编码：</td>
	           <td class="inquire_form4"><input name="coding_code_id" id="coding_code_id" class="input_width" value="" type="text" readonly="readonly"/></td>
	           <td class="inquire_item4">名称：</td>
	           <td class="inquire_form4">
		       		<input name="coding_name" id="coding_name" class="input_width" value="" type="text" />          
		            <input name="superior_code_id" id="superior_code_id" class="input_width" value="" type="hidden" />
	             	<input name="coding_sort_id" id="coding_sort_id" class="input_width" value="" type="hidden" /> 
	             	<input name="coding_lever" id="coding_lever" class="input_width" value="" type="hidden" /> 
	           </td>
		  </tr>
	 	</table>
	 </form>
	</div>  
    <div id="oper_div">
     	<%if("add".equals(action)){ %>
      	  <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <%}else{ %>
      	  <span class="bc_btn"><a href="#" onclick="update()"></a></span>
        <%} %>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
</html>
