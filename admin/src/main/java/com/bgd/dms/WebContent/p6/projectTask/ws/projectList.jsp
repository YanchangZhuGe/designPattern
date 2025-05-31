<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
	
	String orgId = user.getOrgId();
	
	String projectType="5000100004000000008";
	
	String projectInfoNo = user.getProjectInfoNo(); 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
</head>
<body style="background:#fff">
   <div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  	<tr>
				  	<td rowspan="6">&nbsp</td>
				   	<auth:ListButton functionId="" css="dk" event="onclick='toSon()'" title="子项目管理"></auth:ListButton>
				  	</tr>
				</table>
			</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		  </tr>
		</table>
	</div>
	<div id="table_box">
	  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{project_name}' id='rdo_entity_id_{project_info_no}' onclick='chooseOne(this);'/>" >选择</td>
	      <td class="bt_info_even" autoOrder="1">序号</td>
	      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
	      <td class="bt_info_even" exp="{project_target_money}">指标金额(万元)</td>
	      <td class="bt_info_odd" exp="{project_year}">年度</td>
	      <td class="bt_info_even" exp="{team_name}">施工队伍</td>
	      <td class="bt_info_odd" exp="{project_country}" func="getOpValue,projectCountry_view">国内/国外</td>
	    </tr>
	  </table>
	</div>
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
	var projectCountry_view = new Array(['1','国内'],['2','国外']);
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "WsProjectSrv";
	cruConfig.queryOp = "queryProjects";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var orgId="<%=orgId %>";
	var projectType="<%=projectType%>"
	var businessType="5110000004100000080";
	var projectInfoNo = "<%=projectInfoNo%>"
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "projectType="+projectType+"&orgSubjectionId="+orgSubjectionId+"&projectInfoNo="+projectInfoNo;
		queryData(1);
	}

	function toSon(){
		
		ids = getSelIds('rdo_entity_id');
		if(""!=ids){
	    	if(ids.indexOf(",")==-1){
		    	var projectFatherName=encodeURI(encodeURI(ids.split("-")[1]));
		    	location.href='<%=contextPath%>/p6/projectTask/ws/subProjectList.jsp?projectInfoNo=<%=projectInfoNo%>&isSingle=true&isws=true';
	    	}else{
	    		alert("只能选择一条项目信息！")
		    }
	 	}else{
			alert("请选择一条项目信息！");
		}
		
	    
	}
	
 	function chooseOne(cb){
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){
            if (obj[i]!=cb){
            	obj[i].checked = false;
            }else {
            	obj[i].checked = true;
            }
        }
    }
	
</script>
</html>