<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devmixappid = request.getParameter("devMixAppId");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>自有设备调配单列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      <div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0"></table>						
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
			 <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='{device_app_detid}' name='{device_app_detid}'>
			     	<!-- <td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_app_detid}' id='selectedbox_{device_app_detid}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td> -->
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_type}">设备型号</td>
					<td class="bt_info_even" exp="{apply_num}">申请数量</td>
					<td class="bt_info_odd" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_odd" exp="{mix_org_name}">调剂单位</td>
					<td class="bt_info_even" exp="{purpose}">备注</td>
			     </tr> 
			 </table>
		</div>
		<div id="fenye_box"  style="display:block">
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
			      </label>
			    </td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
</div>
</body>
<script type="text/javascript">
	function frameSize(){
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();
		
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})
	var selectedTagIndex = 0;
	
	function appendDataToDetailTab(filterobj,datas){
			for(var i=0;i<basedatas.length;i++){
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
				innerHTML += "<td>"+datas[i].asset_coding+"</td><td>"+datas[i].self_num+"</td>";
				innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
				innerHTML += "</tr>";
				
				$(filterobj).append(innerHTML);
			}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function refreshData(){
		var str = "select n.org_abbreviation as mix_org_name,d.* from gms_device_dismixapp_detail d left join gms_device_dismixapp p on d.device_mixapp_id = p.device_mixapp_id ";
			str += "left join comm_org_subjection org on p.mix_org_id = org.org_subjection_id left join comm_org_information n on org.org_id = n.org_id "; 
			str += "where d.device_mixapp_id='<%=devmixappid%>'";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
</script>
</html>