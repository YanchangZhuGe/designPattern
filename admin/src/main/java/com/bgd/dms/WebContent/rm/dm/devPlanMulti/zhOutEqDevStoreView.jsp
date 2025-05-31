<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devappid = request.getParameter("devAppId");
	String assigntype = request.getParameter("assignType");	
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

  <title>多项目-出库分配-出库分配(自有)-查看子页面</title> 
 </head> 
 
 <body style="background:#fff;" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box1" style="height:335px;">
			  <table style="" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='{device_app_detid}' name='{device_app_detid}'>
			     	<!-- <td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_app_detid}' id='selectedbox_{device_app_detid}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td> -->
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_type}">设备型号</td>
					<td class="bt_info_even" exp="{apply_num}">审批数量</td>
					<% if(!assigntype.equals("S9997")) {  //大港自有地震仪器%>
						<td class="bt_info_odd" exp="{mixed_num}">已调配数量</td>
					<%} %>
					<td class="bt_info_even" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_odd" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_even" exp="{out_org_name}">出库单位</td>
					<td class="bt_info_odd" exp="{purpose}">备注</td>
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

	var assigntype_tmp = "<%=assigntype%>";
	var devappid_tmp = "<%=devappid%>";

	function refreshData(){
		var str = "select d.device_app_detid,d.dev_name,";
			if(assigntype_tmp == 'S9997'){//大港自有地震仪器显示仪器型号
				str += "(select coding_name from comm_coding_sort_detail where coding_code_id = d.dev_type) as dev_type,";
			}else{
				str += "d.dev_type,";
			}			
			str += "d.apply_num,d.plan_start_date,d.plan_end_date,d.purpose,";
			str += "nvl(tmp.mixed_num, 0) mixed_num,u.user_name,org.org_abbreviation as out_org_name ";
			str += "from gms_device_app_detail d left join comm_org_information org on d.dev_out_org_id = org.org_id ";
			str += "inner join gms_device_app ttt on d.device_app_id=ttt.device_app_id ";
			str += "inner join p_auth_user u on ttt.creator_id=u.emp_id ";
			str += "left join (select device_app_detid,sum(assign_num) as mixed_num  from gms_device_appmix_main amm ";
			str += "where amm.bsflag = '0' group by device_app_detid)tmp on tmp.device_app_detid = d.device_app_detid ";
			str += "where d.device_app_id = '"+devappid_tmp+"' ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
</script>
</html>