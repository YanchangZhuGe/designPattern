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
    String action = request.getParameter("action");
    String addButtonDisplay="";
    if("view".equals(action))addButtonDisplay="none";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
['bgp_wr_stress_project_info']
);
var defaultTableName = 'bgp_wr_stress_project_info';
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

	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var data_week_end_date = '<%=request.getParameter("week_end_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = data_week_end_date;
		var querySql = "select t.*,p.project_name from bgp_wr_stress_project_info t left join gp_task_project p on t.project_info_no=p.project_info_no where t.org_id = '" + data_org_id + "' and to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and t.bsflag='0' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		//如果datas为空，并且是新增或修改页面，进行数据抽取
		if(action!='view' && datas.length==0){
			cruConfig.contextPath='<%=contextPath%>';
			queryRet = jcdpCallService('DataExtractSrv','getStressProjectInfo','week_date='+data_week_date+'&week_end_date='+data_week_end_date+'&org_id='+data_org_id);
			datas = queryRet.datas;
		}// 抽取完成
		
		for (var i = 0; datas && queryRet.datas.length; i++) {			
			addLine(
					datas[i].stresspro_id ? datas[i].stresspro_id : "",
					datas[i].project_info_no ? datas[i].project_info_no : "",
					datas[i].project_name ? datas[i].project_name : "",
					datas[i].project_content ? datas[i].project_content : ""
				);
		}			
	}
	
}


function save(){
	var org_id=document.getElementById("org_id").value;
	var org_subjection_id=document.getElementById("org_subjection_id").value;
	var week_date=document.getElementById("week_date").value;

	var rowNum = document.getElementById("lineNum").value;		
	var rowParams = new Array();
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
					
		var stresspro_id = document.getElementsByName("stresspro_id_"+i)[0].value;			
		var project_info_no = document.getElementsByName("project_info_no_"+i)[0].value;			
		var project_content = document.getElementsByName("project_content_"+i)[0].value;
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
		
		rowParam['stresspro_id'] = stresspro_id;
		rowParam['project_info_no'] = project_info_no;
		rowParam['project_content'] = encodeURI(encodeURI(project_content));
		
		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_wr_stress_project_info",rows);	
}

//提示提交结果
function afterSave(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		alert(successHint);
		cancel();
	}
}
function cancel()
{
	//window.parent.getNextTab();
}
function deleteLine(lineId){		
	debugger;
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


function addLine(stresspro_ids,project_info_nos,project_names,project_contents){
	var stresspro_id = "";
	var project_info_no = "";
	var project_name = "";
	var project_content = "";

	if(stresspro_ids != null && stresspro_ids != ""){
		stresspro_id=stresspro_ids;
	}
	if(project_info_nos != null && project_info_nos != ""){
		project_info_no=project_info_nos;
	}
	if(project_names != null && project_names != ""){
		project_name=project_names;
	}
	if(project_contents != null && project_contents != ""){
		project_content=project_contents;
	}

	var rowNum = document.getElementById("lineNum").value;	
	
	//var tr = document.getElementById("lineTable").insertRow();
	
	//tr.align="center";		

	//tr.id = "row_" + rowNum + "_";

	//tr.insertCell().innerHTML = '<input type="hidden" class="input_width" name="stresspro_id' + '_' + rowNum + '" value="'+stresspro_id+'"/>'+'<input type="hidden" class="input_width" name="project_info_no' + '_' + rowNum + '" onFocus="this.select()" value="'+project_info_no+'"/><input type="text" class="input_width" readonly name="project_name' + '_' + rowNum + '" value="'+project_name+'" onFocus="this.select()"/><img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectTeam(\'' + rowNum + '\')"/>';
	//tr.insertCell().innerHTML = '<textarea maxlength="300" name="project_content' + '_' + rowNum + '" onFocus="this.select()">'+project_content+'</textarea>'+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>';
	//var td = tr.insertCell();
	//td.style.display = "<%=addButtonDisplay%>";
	//td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="../../../images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
	
	var table=document.getElementById("lineTable");
	var temp = "odd";
	if(rowNum%2 == 0){
		//even
		temp = "even";
	} else {
		//odd
		temp = "odd";
	}
	var lineId = "row_" + rowNum + "_";
	var elem=createRow("<tr class="+temp+" id='"+lineId+"'><td class='inquire_item4'><input type='hidden' name = 'stresspro_id_"+rowNum+"' value='"+stresspro_id+"' /><input type='hidden' name='project_info_no_"+rowNum+"' onFocus='this.select()' value='"+project_info_no+"'/><input type='text' readonly='readonly' name='project_name_"+rowNum+"' value='"+project_name+"' onFocus='this.select()'/><img style='cursor:hand;' src='<%=contextPath%>/images/magnifier.gif' onclick='selectTeam(\""+rowNum+"\")'/></td><td class='inquire_item4'><textarea maxlength='300' name='project_content_"+rowNum+"' onFocus='this.select()'>"+project_content+"</textarea><input type='hidden' name='bsflag_"+rowNum+"' value='0'/></td><td class='inquire_item4'><input type='hidden' name='order' value='" + rowNum + "'/><img src='../../../images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/></td></tr>");
	table.appendChild(elem);
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
}

function createRow(html){
    var div=document.createElement("div");
    html="<table><tbody>"+html+"</tbody></table>"
    div.innerHTML=html;
    return div.lastChild.lastChild;
}
//选择项目
function selectTeam(i){

    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("project_info_no_"+i).value = teamInfo.fkValue;
        document.getElementById("project_name_"+i).value = teamInfo.value;
    }
}
</script>
</head>
<body onload="page_init()" style="background:#fff;overflow: auto;">
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
<input type="hidden" name="org_id" id="org_id" value="<%=user.getCodeAffordOrgID() %>">
<input type="hidden" name="org_subjection_id" id="org_subjection_id" value="<%=user.getSubOrgIDofAffordOrg()%>">

<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height" width="100%"  id="lineTable" >
    <tr class="bt_info">
      <td class="tableHeader" width="20%">项目名称</td>
      <td class="tableHeader" width="70%" >公司重点项目动态相关信息</td>
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
