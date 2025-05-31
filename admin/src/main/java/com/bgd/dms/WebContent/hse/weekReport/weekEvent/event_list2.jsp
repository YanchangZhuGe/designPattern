<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
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
			      <td class="bt_info_even" autoOrder="1" exp="<input type='hidden' name='qwe' value='{hse_event_id}' id='' onclick='loadDataDetail();'/>">序号</td> 
			      <td class="bt_info_odd" exp="{org_name}">二级单位</td>
			      <td class="bt_info_even" exp="{die_event}">死亡事故</td>
			      <td class="bt_info_odd" exp="{harm_event}">重伤事故</td>
			      <td class="bt_info_even" exp="{injure_event}">轻伤事故</td>
			      <td class="bt_info_odd" exp="{work_event}">工作受限</td>
			      <td class="bt_info_even" exp="{medic_event}">医疗处置</td>
			      <td class="bt_info_odd" exp="{aid_event}">急救事件</td>
			      <td class="bt_info_even" exp="{not_event}">未遂事件</td>
			      <td class="bt_info_odd" exp="{money_event}">财产损失事故</td>
			      <td class="bt_info_even" exp="{total_event}">合计</td>
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

	cruConfig.contextPath =  "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select e.*,i.org_abbreviation as org_name from bgp_hse_common c join bgp_hse_week_event e on c.hse_common_id=e.hse_common_id  join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag='0' join comm_org_information i on s.org_id=i.org_id and i.bsflag='0' where c.bsflag='0' and s.father_org_id='<%=org_id%>' and c.week_start_date=to_date('<%=week_date%>','yyyy-MM-dd') order by c.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "viewAccident", "hse_accident_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "viewAccident", "hse_accident_id="+ids);
		}
		document.getElementById("hse_accident_id").value =retObj.map.hseAccidentId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("accident_name").value =retObj.map.accidentName;
		document.getElementById("accident_type").value = retObj.map.accidentType;
		document.getElementById("accident_date").value = retObj.map.accidentDate;
		document.getElementById("accident_place").value = retObj.map.accidentPlace;
		document.getElementById("workplace_flag").value = retObj.map.workplaceFlag;
		document.getElementById("out_flag").value = retObj.map.outFlag;
		document.getElementById("out_type").value = retObj.map.outType;
		document.getElementById("out_name").value = retObj.map.outName;
		document.getElementById("accident_money").value = retObj.map.accidentMoney;
		document.getElementById("number_die").value = retObj.map.numberDie;
		document.getElementById("number_harm").value = retObj.map.numberHarm;
		document.getElementById("number_injure").value = retObj.map.numberInjure;
		document.getElementById("number_lose").value = retObj.map.numberLose;
		document.getElementById("accident_process").value = retObj.map.accidentProcess;
		document.getElementById("accident_reason").value = retObj.map.accidentReason;
		document.getElementById("accident_result").value = retObj.map.accidentResult;
		document.getElementById("accident_sugg").value = retObj.map.accidentSugg;
		document.getElementById("write_date").value = retObj.map.writeDate;
		document.getElementById("write_name").value = retObj.map.writeName;
		document.getElementById("duty_name").value = retObj.map.dutyName;
		
	}
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/accidentNews/addAccident.jsp");
		
	}
	
	
	
</script>

</html>

