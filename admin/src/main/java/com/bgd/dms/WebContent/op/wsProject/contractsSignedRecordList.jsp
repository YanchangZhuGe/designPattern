<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = (String)user.getOrgId();
	String org_subjection_id = (String)user.getSubOrgIDofAffordOrg();
	String user_id = (String)user.getUserId();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String project_year = request.getParameter("project_year");
	String ifcarry = request.getParameter("ifcarry");
	String project_info_id = request.getParameter("project_info_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

<script type="text/javascript" >
cruConfig.contextPath =  "<%=contextPath%>";


function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");   
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
}   
function toEdit(){
	ids = getSelIds('chk_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    var params = ids.split(',');
	for(var i=0;i<params.length;i++){
		
		var contracts_signed = document.getElementById("contracts_signed"+params[i]).value;
		var complete_value = document.getElementById("complete_value"+params[i]).value;
		
	  	popWindow('<%=contextPath%>/op/wsProject/contractsSignedMoneyEdit.jsp?project_info_id='+params[i]+'&contracts_signed='+contracts_signed+'&complete_value='+complete_value);         		
	}
	
}

function refreshData(){
		var str = "select re.*, case wf.PROC_STATUS when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' end as PROC_STATUS from BGP_OP_MONEY_CONFIRM_RECORD_WS re left join COMMON_BUSI_WF_MIDDLE wf on wf.BUSINESS_ID=re.RECORD_ID and wf.BSFLAG='0'"
			+"where re.PROJECT_INFO_ID='<%=project_info_id%>' and re.YEAR='<%=project_year%>' order by re.create_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
}

function loadDataDetail(ids){
	//载入费用详细信息

			
}


</script>
<title>列表页面</title>
</head>
<body onload="refreshData()" >
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{proc_status}' id='chk_entity_id' onclick='chooseOne(this)'/>" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_even" exp="{create_date}">日期</td> 
			  	<td class="bt_info_odd" exp="{contracts_signed}">原预计完成价值工作量(万元)</td>
			  	<td class="bt_info_even" exp="{contracts_signed_change}">审批预计完成价值工作量(万元)</td>
			  	<td class="bt_info_even" exp="{complete_value}">原完成价值工作量(万元)</td>
			  	<td class="bt_info_even" exp="{complete_value_change}">预计完成价值工作量(万元)</td>
			  	<td class="bt_info_even" exp="{proc_status}">审批状态</td>
			</tr>
		</table>
	</div> 
  
	<div id="fenye_box">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		 
		  </tr>
		</table>
	</div>
	
	<div class="lashen" id="line"></div>

			
<script type="text/javascript">
function frameSize(){
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-10);
	
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

</body>
</html>
