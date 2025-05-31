<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<title>基线项目列表</title>

<script language="javaScript">
var projectObjectId="";
cruConfig.contextPath =  "<%=contextPath%>";

function goBack(){
		location.href="<%=contextPath%>/p6/editProjectPlan/index.jsp";
}



function page_init(){
	var str="select OBJECT_ID,WBS_OBJECT_ID,BASELINE_PROJECT_ID from bgp_p6_project where BSFLAG='0' and PROJECT_INFO_NO='<%=projectInfoNo%>'";
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
	var retObj = unitRet.datas;
  //  var isSingle = true;
	projectObjectId=retObj[0].object_id;

	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "P6ProjectSrv";
	cruConfig.queryOp = "queryBaselineProject";
	cruConfig.submitStr = "isSingle=true&projectObjectId="+projectObjectId;
	queryData(1);
	var baseProjectId=retObj[0].baseline_project_id;
	document.getElementById("rdo_entity_id_"+baseProjectId).checked = true;
	
	
}

function deleteBaseLineProject(){
    var id = getSelIds('rdo_entity_id');
    if(id==''){ 
        alert("请先选中一条记录!");
 		return;
	}	
	var ids = id.split(",");
	var projects = "";
	for(var i=0;i<ids.length;i++){
		var project = ids[i].split("~");
		if(i<ids.length-1){
			projects+=project[0]+",";
		}else{
			projects+=project[0];
		}
	}

	var obj = jcdpCallService("P6ProjectPlanSrv", "deleteBaseLineProject", "p6_object_ids="+projects);
	if(obj != null && obj.message =='true') {
		alert("删除成功");
		page_init();
	}else{
		alert("删除失败");

	}
    	
}
function add(){
	var obj = jcdpCallService("P6ProjectPlanSrv", "addBaseLineProject", "p6_object_id="+projectObjectId);
	if(obj != null && obj.message =='true') {
		alert("添加成功");
		page_init();
	}else{
		alert("添加失败");
	}
	
}


function selectProjectAsBaseline(){
    var id = getSelIds('rdo_entity_id');
    if(id==''){ 
        alert("请先选中一条记录!");
 		return;
	}	
	var ids = id.split("~");
	var baseLine=ids[0];
	var obj = jcdpCallService("P6ProjectPlanSrv", "selectProjectAsBaseline", "p6_object_id="+projectObjectId+"&baseLine="+baseLine);
	if(obj != null && obj.message =='true') {
		alert("分配目标项目成功");
		page_init();
		
	}else{
		alert("分配目标项目失败");
	}
	
}
function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");  
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
} 
</script>

</head>
<body onload="page_init()" style="background:#cdddef">

<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td>&nbsp;</td>
		    <!--
		    <auth:ListButton functionId="" css="fh" event="onclick='goBack()'" title="JCDP_btn_back"></auth:ListButton>
		      -->
		    <auth:ListButton functionId="" css="zj" event="onclick='add()'" title="JCDP_btn_add"></auth:ListButton>		    
		    <auth:ListButton functionId="" css="sc" event="onclick='deleteBaseLineProject()'" title="JCDP_btn_delete"></auth:ListButton>
		    <auth:ListButton functionId="" css="tj" event="onclick='selectProjectAsBaseline()'" title="JCDP_btn_submit"></auth:ListButton>

		  </tr>
		  
		</table>
		</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		  </tr>
		</table>
	</div>

	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id}~{wbs_object_id}' id='rdo_entity_id_{object_id}' onclick='chooseOne(this)'/>" >选择</td>
	      <td class="bt_info_even" autoOrder="1">序号</td>
	      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
	      <td class="bt_info_even" exp="{project_id}" >项目编号</td>
	    </tr>
	  </table>
	</div>
	<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
	  <tr>
	    <td align="right">第1/1页，共0条记录</td>
	    <td width="10">&nbsp;</td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
	    <td width="50">到 
	      <label>
	        <input type="text" name="textfield" id="textfield" style="width:20px;" />
	      </label></td>
	    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
	  </tr>
	</table>
</div>
</body>
</html>