<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String org_subjection_id = user.getOrgSubjectionId();
	
	System.out.println(org_subjection_id);
	
	String second_org = "" ;
	String sqlOrg = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrg);
	if(listOrg.size()>0){
		Map mapOrg = (Map)listOrg.get(0);
		second_org = (String)mapOrg.get("orgSubId");
	}
	
	//违章级别 特大，重大，较大，一般数量
	String first_big_rule = "0";
	String second_big_rule = "0";
	String third_big_rule = "0";
	String usual_rule = "0";
	String sql = "select count(t.illegal_no) illegal_num,t.illegal_level  from bgp_illegal_management t where t.bsflag='0' and t.org_sub_id='"+second_org+"' group by t.illegal_level";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	for(int i=0;i<list.size();i++){
		Map map = (Map)list.get(i);
		String illegal_level = (String)map.get("illegalLevel");
		if(illegal_level.equals("0")){
			first_big_rule = (String)map.get("illegalNum");
		}
		if(illegal_level.equals("1")){
			second_big_rule = (String)map.get("illegalNum");
		}
		if(illegal_level.equals("2")){
			third_big_rule = (String)map.get("illegalNum");
		}
		if(illegal_level.equals("3")){
			usual_rule = (String)map.get("illegalNum");
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #C0E2FB; overflow-y: auto" >
	<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
		<tr class="bt_info">
			<td>重大</td>
			<td>较大</td>
		</tr>
		<tr class="even">
			<td><%=second_big_rule %></td>
			<td><%=third_big_rule %></td>
		</tr>
	</table>	   
</body>
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

