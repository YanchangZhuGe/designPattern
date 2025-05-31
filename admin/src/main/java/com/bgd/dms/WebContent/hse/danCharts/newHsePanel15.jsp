<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath=request.getContextPath();

	//隐患级别 特大，重大，较大，一般数量
	String first_big_dan = "0";
	String second_big_dan = "0";
	String third_big_dan = "0";
	String usual_dan = "0";
	
	String sqlLevel = "select count(t.hidden_no) hidden_num, t.hidden_level from bgp_hse_hidden_information t where t.bsflag = '0' group by t.hidden_level order by t.hidden_level asc ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlLevel);
	for(int i=0;i<list.size();i++){
		Map map = (Map)list.get(i);
		String hidden_level = (String)map.get("hiddenLevel");
		if(hidden_level.equals("1")){
			first_big_dan = (String)map.get("hiddenNum");
		}
		if(hidden_level.equals("2")){
			second_big_dan = (String)map.get("hiddenNum");
		}
		if(hidden_level.equals("3")){
			third_big_dan = (String)map.get("hiddenNum");
		}
		if(hidden_level.equals("4")){
			usual_dan = (String)map.get("hiddenNum");
		}
	}

	//未整改隐患
	String no_modify_dan = "0";
	String sqlModify = "select count(d.mdetail_no) no_modify_dan from bgp_hse_hidden_information t left join bgp_hidden_information_detail d on t.hidden_no = d.hidden_no and d.bsflag = '0' where t.bsflag = '0' and d.rectification_state = '2'";
	Map mapModify = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlModify);
	if(mapModify!=null){
		no_modify_dan = (String)mapModify.get("noModifyDan");
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
			<td>一般</td>
			<td>未整改隐患</td>
		</tr>
		<tr class="even">
			<td><%=second_big_dan %></td>
			<td><%=third_big_dan %></td>
			<td><%=usual_dan %></td>
			<td><%=no_modify_dan %></td>
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

