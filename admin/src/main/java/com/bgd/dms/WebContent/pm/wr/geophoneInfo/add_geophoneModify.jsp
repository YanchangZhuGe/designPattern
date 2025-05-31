<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());
Calendar cal=Calendar.getInstance();
cal.setTime(new Date());
cal.set(Calendar.DAY_OF_WEEK, Calendar.FRIDAY);
String friDate = format.format(cal.getTime());
String action = request.getParameter("action");
String addButtonDisplay="";
if("view".equals(action))addButtonDisplay="none";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>


<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 


<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "新建--重点项目动态CRU";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['BGP_GEOPHONE_INFO']
);
var defaultTableName = 'BGP_GEOPHONE_INFO';
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
	cruConfig.openerUrl = "/pm/wr/sailInfo/sailInfoList.lpmd";
	cru_init();
}

var org_id="<%=user.getCodeAffordOrgID() %>"
var org_subjection_id="<%=user.getSubOrgIDofAffordOrg() %>"
function save(){
	
	var week_date=document.getElementById("week_date").value;
	
	var rowNum = document.getElementById("lineNum").value;	
		
	var rowParams = new Array();
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
					
		var geophone_id = document.getElementsByName("geophone_id_"+i)[0].value;			
		var geophone_type = document.getElementsByName("geophone_type_"+i)[0].value;			
		var total_num = document.getElementsByName("total_num_"+i)[0].value;
		var use_num = document.getElementsByName("use_num_"+i)[0].value;
		var notuse_num = document.getElementsByName("notuse_num_"+i)[0].value;
		var scrapped_num = document.getElementsByName("scrapped_num_"+i)[0].value;
		var rent_num = document.getElementsByName("rent_num_"+i)[0].value;
		var plan_num = document.getElementsByName("plan_num_"+i)[0].value;
		var bsflag = document.getElementsByName("bsflag_"+i)[0].value;

		
		rowParam['org_id'] = org_id;
		rowParam['org_subjection_id'] = org_subjection_id;
		rowParam['week_date'] = week_date;
		
		rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['mondify_date'] = '<%=curDate%>';
		
		rowParam['bsflag'] = bsflag;
		rowParam['subflag'] = '0';
		
		rowParam['geophone_id'] = geophone_id;
		rowParam['geophone_type'] = encodeURI(encodeURI(geophone_type));
		rowParam['total_num'] = total_num;
		rowParam['use_num'] = use_num;
		rowParam['notuse_num'] = notuse_num;
		rowParam['scrapped_num'] = scrapped_num;
		rowParam['rent_num'] = rent_num;
		rowParam['plan_num'] = plan_num;
		
		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_geophone_info",rows);	
}
function afterSave(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		alert(successHint);
		//cancel();
	}
}
function cancel()
{
	//window.parent.getNextTab();
}
function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
	}	
}


function addLine(geophone_ids,geophone_types,total_nums,use_nums,notuse_nums,scrapped_nums,rent_nums,plan_nums){
	
	var geophone_id = "";
	var geophone_type = "";
	var total_num = "";
	var use_num = "";
	var notuse_num = "";
	var scrapped_num = "";
	var rent_num = "";
	var plan_num = "";

	if(geophone_ids != null && geophone_ids != ""){
		geophone_id=geophone_ids;
	}
	if(geophone_types != null && geophone_types != ""){
		geophone_type=geophone_types;
	}
	if(total_nums != null && total_nums != ""){
		total_num=total_nums;
	}
	if(use_nums != null && use_nums != ""){
		use_num=use_nums;
	}
	if(notuse_nums != null && notuse_nums != ""){
		notuse_num=notuse_nums;
	}
	if(scrapped_nums != null && scrapped_nums != ""){
		scrapped_num=scrapped_nums;
	}
	if(rent_nums != null && rent_nums != ""){
		rent_num=rent_nums;
	}
	if(plan_nums != null && plan_nums != ""){
		plan_num=plan_nums;
	}
	
	var rowNum = document.getElementById("lineNum").value;	
	
	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "row_" + rowNum + "_";

	tr.insertCell().innerHTML = '<input type="hidden" class="input_width" name="geophone_id' + '_' + rowNum + '" value="'+geophone_id+'"/>'+'<input name="geophone_type' + '_' + rowNum + '" maxlength="32" value="'+geophone_type+'" onFocus="this.select()" />';
	tr.insertCell().innerHTML = '<input type="text" name="total_num' + '_' + rowNum + '" value="'+total_num+'" onFocus="this.select()"/>';
	tr.insertCell().innerHTML = '<input type="text" name="use_num' + '_' + rowNum + '" value="'+use_num+'" onFocus="this.select()"/>';
	tr.insertCell().innerHTML = '<input type="text" name="notuse_num' + '_' + rowNum + '" value="'+notuse_num+'" onFocus="this.select()"/>';
	tr.insertCell().innerHTML = '<input type="text" name="scrapped_num' + '_' + rowNum + '" value="'+scrapped_num+'" onFocus="this.select()"/>';
	tr.insertCell().innerHTML = '<input type="text" name="rent_num' + '_' + rowNum + '" value="'+rent_num+'" onFocus="this.select()"/>';
	tr.insertCell().innerHTML = '<input type="text" name="plan_num' + '_' + rowNum + '" value="'+plan_num+'" onFocus="this.select()"/>';
	var td = tr.insertCell();
	td.style.display = "<%=addButtonDisplay%>";
	td.innerHTML = '<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
		
}

function page_init(){

	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!=null){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		var querySql = "select t.* from BGP_GEOPHONE_INFO t where to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and t.bsflag='0' and org_id = '"+org_id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		
		
		if(queryRet.datas.length!='0'){//view,edit,add三种情况，都是先选取本期数据，如果有，进行填充
			
			var datas = queryRet.datas;
			for (var i = 0; datas && i<queryRet.datas.length; i++) {	
				addLine(datas[i].geophone_id,datas[i].geophone_type,datas[i].total_num,datas[i].use_num,datas[i].notuse_num,datas[i].scrapped_num,datas[i].rent_num,datas[i].plan_num);
			}
			//alert("本期数据");
		}else if(action=='add'||action=='edit'){//view没本期数据的话，空白；add和edit，无本期数据，选择上期数据，不带ID
			var pre_date=getPreDate(data_week_date);
			
			querySql = "select t.* from BGP_GEOPHONE_INFO t where t.week_date = to_date('"+pre_date+"','yyyy/MM/dd') and t.bsflag='0' and org_id = '"+org_id+"'";
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
			
			if(queryRet.datas.length!='0'){
				var datas = queryRet.datas;
				for (var i = 0; datas && queryRet.datas.length; i++) {	
					datas[i].geophone_id="";
					addLine(datas[i].geophone_id,datas[i].geophone_type,datas[i].total_num,datas[i].use_num,datas[i].notuse_num,datas[i].scrapped_num,datas[i].rent_num,datas[i].plan_num);
				}
				document.getElementById("msg").innerHTML="<font color='red'>注意：显示为上周数据，请修改后点击“下一步”</font> ";
			}
		}
	}
	
}
function getPreDate(date){//获取上周周报的时间
	//alert("in getPreDate");
	var reg = new RegExp("-","g"); //创建正则RegExp对象       
	var date2= date.replace(reg,"\/");
	var d=Date.parse(date2); 
	d=d-7*24*60*60*1000;
	d=new Date(d);
	var res=d.getFullYear()+'-'+(parseInt(d.getUTCMonth())+1)+'-'+d.getDate();
	return res;
}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init()" style="background:#fff">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">周报开始日期：</td>
			    <td class="ali1"><input type="text" id="week_date" class="input_width4"  name="week_date" value="" readonly></td>
			    <td class="ali3">周报结束日期：</td>
			    <td class="ali1"><input type="text" id="week_end_date" class="input_width4"  name="week_end_date" value="" readonly></td>
			    <td><span class="zj"><a href="#" onclick="addLine()"></a></span></td>
			  </tr>
			</table>
		</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height" width="100%"  id="lineTable" >
    <tr background="blue" class="bt_info">
      <td class="tableHeader" width="15%">检波器型号</td>
      <td class="tableHeader" width="15%">总量</td>
      <td class="tableHeader" width="15%">在用</td>
      <td class="tableHeader" width="15%">闲置</td>
      <td class="tableHeader" width="15%">待报废</td>
      <td class="tableHeader" width="15%">外租</td>
      <td class="tableHeader" width="15%">计划使用</td>
      <td class="tableHeader" width="10%" style="display:<%=addButtonDisplay%>"><input type="hidden" id="lineNum" value="0"/>删除</td> 
    </tr>

</table>
  
<div id="oper_div">
<%
if(!"view".equals(request.getParameter("action"))){
%>
<span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%	
}
%>
</div>
</body>
</html>
