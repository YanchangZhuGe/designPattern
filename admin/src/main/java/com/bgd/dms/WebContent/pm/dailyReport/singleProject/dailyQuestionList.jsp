<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	String produceDate = request.getParameter("produceDate");
	if(produceDate == null || "".equals(produceDate)){
		produceDate = null;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title></title>
</head>
<body style="background:#fff" >
      	<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="{produce_date}">问题日期</td>
			      <td class="bt_info_even" exp="{bug_code}" func="getOpValue,bugCode1">问题分类</td>
			      <td class="bt_info_odd" exp="{q_description}">问题描述</td>
			      <td class="bt_info_even" exp="{resolvent}">解决方案</td>
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
		  </div>
</body>
<script type="text/javascript">
var bugCode1 = new Array(
		['5000100005000000001','人员']
		,['5000100005000000002','物资']
		,['5000100005000000003','设备']
		,['5000100005000000004','HSE']
		,['5000100005000000005','后勤']
		,['5000100005000000006','工农、社区关系']
		,['5000100005000000007','技术']
		,['5000100005000000008','生产']
		,['5000100005000000009','甲方信息']
		,['5000100005000000010','自然因素']
		,['5000100005000000011','质量']
		,['5000100005000000012','财务经营']
		,['5000100005000000013','其他']
		);
function frameSize(){
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
}
//frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var retObj = jcdpCallService("DailyReportSrv", "queryDailyQuestionList", "projectInfoNo=<%=projectInfoNo %>&produceDate=<%=produceDate %>");
	debugger;
	if(retObj.totalRows == 0){
		parent.document.all("dailyQuestion").style.height = 0; 
		parent.document.all("dailyQuestion").style.width = 0; 
	}
	else{
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "";
		cruConfig.queryService = "DailyReportSrv";
		cruConfig.queryOp = "queryDailyQuestionList";
		cruConfig.submitStr = "projectInfoNo=<%=projectInfoNo %>&produceDate=<%=produceDate %>";	

		// function onload(){
			queryData(1);
			parent.document.all("dailyQuestion").style.height=document.body.scrollHeight; 
			parent.document.all("dailyQuestion").style.width=document.body.scrollWidth; 
		//} 
	}

	// 复杂查询
/*      function refreshData(q_code_name,q_code_type_name){
		
		//document.getElementById("code_name").value = q_code_name;
		
		queryData(1);
	}  */
	// 简单查询
	function simpleRefreshData(){
		var q_name = document.getElementById("code_name").value;
		refreshData(q_name,"");
	}

	function toAdd(){
		

	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    //var params = ids.split(',');
	   // alert("The params is:"+params);
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ProjectCodeSrv", "deleteCodeAssignment", "objectId="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
	}
	
	function dbclickRow(ids){
			
	}
	
</script>
</html>