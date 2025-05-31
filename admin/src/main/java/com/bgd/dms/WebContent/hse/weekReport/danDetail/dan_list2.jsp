<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	Date now = new Date();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>

<body class="bgColor_f3f3f3"  onload="refreshData()">
      	<fieldSet style="margin-left:2px"><legend>下属单位信息</legend>
      	<div id="list_table" >
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_even" autoOrder="1" exp="<input type='hidden' name='rdo_entity_id' value='{hse_danger_id}' id='rdo_entity_id_{hse_danger_id}' onclick='loadDataDetail();'/>">序号</td> 
			      <td class="bt_info_odd" exp="{org_name2}">单位</td>
			      <td class="bt_info_even" exp="{org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{dan_describe}">危害因素描述</td>
			      <td class="bt_info_even" exp="{dan_type}">因素状态</td>
			      <td class="bt_info_odd" exp="{dan_level}">因素级别</td>
			      <td class="bt_info_even" exp="{dan_step}">风险削减情况</td>
			      <td class="bt_info_odd" exp="{dan_note}">备注</td>
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
		  </fieldSet>
</body>

<script type="text/javascript">
	$("#table_box").css("height",$(window).height()-55);
	
	$(function(){
		$(window).resize(function(){
			$("#table_box").css("height",$(window).height()-55);
		});
	})
	cruConfig.contextPath =  "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select d.hse_danger_id,case when length(d.dan_describe)>5 then concat(substr(d.dan_describe, 1, 5), '...') else d.dan_describe end dan_describe,"
     						+"case when length(d.dan_step)>5 then concat(substr(dan_step, 1, 5), '...') else d.dan_step end dan_step,"
     						+"case when length(d.dan_note)>5 then concat(substr(dan_note, 1, 5), '...') else d.dan_note end dan_note,"
    						+"decode(d.dan_type, '1','已整改','2','未整改','3','正在整改') dan_type, decode(d.dan_level, '2', '重大', '1', '特大','') dan_level,i.org_abbreviation as org_name,i2.org_abbreviation as org_name2"
							+" from bgp_hse_common c join bgp_hse_dan_detail d on c.hse_common_id = d.hse_common_id join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag = '0'"
 							+" join comm_org_information i on s.org_id = i.org_id and i.bsflag = '0' join comm_org_subjection s2 on s.father_org_id = s2.org_subjection_id and s2.bsflag = '0'"
							+" join comm_org_information i2 on s2.org_id = i2.org_id and i2.bsflag = '0' where c.bsflag = '0' and s.father_org_id = '<%=org_id%>'"
							+" and c.week_start_date = to_date('<%=week_date%>', 'yyyy-MM-dd') order by c.modifi_date desc, d.dan_order asc";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	
	function loadDataDetail(shuaId){
		debugger;
		if(shuaId!=null){
			popWindow("<%=contextPath%>/hse/weekReport/danDetail/showDetail.jsp?hse_danger_id="+shuaId);
		}else{
			alert("请选择一条记录");
			return;
		}
		
	}
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/accidentNews/addAccident.jsp");
		
	}
	
	
	
</script>

</html>

