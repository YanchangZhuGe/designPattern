<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	
	String projectInfoNo = request.getParameter("project_info_no");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<title>基线项目列表</title>

<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";

function page_init(project_name){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "P6ProjectPlanSrv";
	cruConfig.queryOp = "getPlanTemplateList";
	if(project_name != undefined && project_name != ""){
		cruConfig.submitStr = "project_info_no=<%=projectInfoNo %>&project_name="+project_name;
	}else{
		cruConfig.submitStr = "project_info_no=<%=projectInfoNo %>";
	}
	queryData(1);
}

function dbclickRow(id){
	
}

function reload(){
	var ctt = top.frames['list'];
	if(ctt != "" && ctt != undefined){
		ctt.location.reload();
	}
}

function simpleSearch(){
	var project_name = document.getElementById("project_name").value;
	page_init(project_name);
}

function clearQueryText(){
	document.getElementById("project_name").value = "";
}

function toSelect(){
    ids = getSelIds('rdo_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    
    var idss = ids.split(",");
    if(idss.length > 3){
    	alert("只能选择一条记录!");
    	return;
    }
	
    if(confirm('大约耗时3分钟，请耐心等待。确定要导入吗?')){  
    	
		var projectObjectId = idss[0];
		var wbsObjectId = idss[1];
		var projectInfoNo = idss[2];
		
		var str = "project_info_no="+projectInfoNo+"&template_project_objctId="+projectObjectId+"&template_project_wbsId="+wbsObjectId;
		var obj = jcdpCallService("P6ProjectPlanSrv", "importPlanTemplate", str);
		if(obj != null && obj.message == "success") {
			alert("导入成功");
			reload();
			newClose();
		}else{
			alert(obj.message);
		}
    }
}

function toView(){
    ids = getSelIds('rdo_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    
    var idss = ids.split(",");
    if(idss.length > 3){
    	alert("只能选择一条记录!");
    	return;
    }
	
	var projectObjectId = idss[0];
	var wbsObjectId = idss[1];
	var projectInfoNo = idss[2];
		
	popWindow('<%=contextPath%>/p6/editProjectPlan/viewPlan.jsp?project_info_no='+projectInfoNo+'&project_object_id='+projectObjectId);
}

</script>

</head>
<body onload="page_init('')" style="background:#cdddef">

<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    	<td class="ali_cdn_name">项目名称:</td>
			    <td class="ali_cdn_input">
				    <input id="project_name" name="project_name" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="ck" event="onclick='toView()'" title="查看模版"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSelect()'" title="选择模版"></auth:ListButton>
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
	      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id},{wbs_object_id},{project_info_no}' id='rdo_entity_id_{object_id}' onclick=doCheck(this)/>" >选择</td>
	      <td class="bt_info_even" autoOrder="1">序号</td>
	      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{object_id}' value='{project_name}'/>" >项目名称</td>
	      <td class="bt_info_even" exp="{org_name}">施工队伍</td>
	      <td class="bt_info_odd" exp="{project_year}">年度</td>
	      <td class="bt_info_even" exp="{create_date}">创建时间</td>
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