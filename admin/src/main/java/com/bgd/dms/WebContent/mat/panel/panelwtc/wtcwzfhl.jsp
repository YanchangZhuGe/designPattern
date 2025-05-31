<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	if(orgSubjectionId==null||orgSubjectionId==""){
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>项目列表</title>
<script language="javaScript">

function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	$("#table_box").css("height",$(window).height()*0.85);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

cruConfig.contextPath =  "<%=contextPath%>";
function refreshData(){
//	 var sql = "select a.project_name,a.jh_money,b.sj_money,round((case when a.jh_money is null then 0 else((a.jh_money-b.sj_money)/a.jh_money) end),2) value from ("
	 var sql = "select a.project_name,a.jh_money,b.sj_money,round((case when a.jh_money is null then 0 else(b.sj_money/a.jh_money) end),2) value from ("
	    	sql += " select gp.project_name,gp.project_info_no,sum(t.cost_detail_money) jh_money from view_op_target_plan_money_f t inner join gp_task_project gp on t.project_info_no=gp.project_info_no and gp.bsflag='0' where t.bsflag='0'" 
	    		sql += " and (t.node_code ='S01001006001'or t.node_code ='S01001006004001002'or t.node_code ='S01001006004001001'or t.node_code ='S01001006004001003001'or t.node_code ='S01001006004001003002'"
	    		sql += " or t.node_code ='S01001006003'or t.node_code ='S01001006002'or t.node_code ='S01001004001002'or t.node_code ='S01001004001003'or t.node_code ='S01001004001001'"
	    		sql += " or t.node_code ='S01001004001004001'or t.node_code ='S01001004001004003'or t.node_code ='S01001002004003'or t.node_code ='S01001002004006'or t.node_code ='S01001002004001'"
	    		sql += " or t.node_code ='S01001002004007'or t.node_code ='S01001002004002'or t.node_code ='S01001002004005'or t.node_code ='S01001003004001'or t.node_code ='S01001003002')"
	    		sql += " group by gp.project_name,gp.project_info_no) a inner join ("
	    		sql += " select gp.project_info_no,sum(d.total_money) sj_money from  GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gp_task_project gp on gp.project_info_no=d.project_info_no and gp.bsflag='0' where d.bsflag='0' and d.org_subjection_id like '<%=orgSubjectionId%>%' and to_char(d.create_date,'yyyy')= to_char(sysdate,'yyyy') group by gp.project_info_no)b"
	    		sql += " on a.project_info_no=b.project_info_no";  
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/panelwtc/wtcwzfhl.jsp";
	queryData(1);
}
</script>
</head>
<body onload="refreshData()" style="background:#fff">
<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
				  	<td class="bt_info_odd" exp="{project_name}" >项目名称</td>
				  	<td class="bt_info_even" exp="{jh_money}">目标成本</td>
				  	<td class="bt_info_odd" exp="{sj_money}" >实际消耗</td>
				  	<td class="bt_info_even" exp="{value}">符合率</td>
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
			<div class="lashen" id="line"></div>
</div>
</body>
</html>