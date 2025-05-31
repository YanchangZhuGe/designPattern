<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectinfono = request.getParameter("projectInfoNo");
	String mixtypeid = request.getParameter("mixtypeid");
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

 <title>查询队级返还页面</title> 
 </head> 
 
 <body style="background:#F1F2F3;overflow:auto" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_acc_id_head' name='dev_acc_id'>					
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{unit_name}">单位</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">在队数量</td>
					<td class="bt_info_odd" exp="{use_num}">离队数量</td>
					<td class="bt_info_odd" exp="{actual_in_time}">实际进场时间</td>
					<td class="bt_info_even" exp="{planning_out_time}">计划离场时间</td>
					<td class="bt_info_odd" exp="{out_org_name}">出库单位</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
<script type="text/javascript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.8);
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
	var projectInfoNos = '<%=projectinfono%>';
	var mixtypeids = '<%=mixtypeid%>';
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	var projectInfoNos = '<%=projectinfono%>';

	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = "select account.*,unitsd.coding_name as unit_name,n.org_abbreviation as out_org_name ";
			str += "from gms_device_coll_account_dui account ";
			str += "left join gms_device_collectinfo info on info.device_id = account.device_id ";
			str += "left join comm_org_information n on n.org_id=account.out_org_id ";
			str += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
			str += "where account.project_info_id='"+projectInfoNos+"' ";
			if(mixtypeids == '1'){//电源站
				str += "and info.dev_code like '02%' ";
			}else if(mixtypeids == '2'){//采集站
				str += "and info.dev_code like '01%' ";
			}else if(mixtypeids == '3'){//交叉站
				str += "and info.dev_code like '03%' ";
			}else if(mixtypeids == '4'){//交叉线
				str += "and (info.dev_code like '0501%' or info.dev_code like '0502%' or info.dev_code like '0503%' ";
				str += "or info.dev_code like '0504%' or info.dev_code like '0505%' or info.dev_code like '0508%') ";
			}else if(mixtypeids == '5'){//排列电缆
				str += "and (info.dev_code like '0506%' or info.dev_code like '0507%') ";
			}
			if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
				str += "and account.dev_name like '"+v_dev_ci_name+"%' ";
			}
			if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
				str += "and account.dev_model like '"+v_dev_ci_model+"%' ";
			}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function submitInfo(){
		var length = 0;
		var selectedids = "";
		$("input[type='checkbox'][name='idinfo']").each(function(i){
			if(this.checked == true){
				if(length != 0){
					selectedids += "|"
				}
				selectedids += this.value;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
	$().ready(function(){
		$("#collbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name='idinfo']").attr('checked',checkvalue);
		});
		
		
	});
</script>
</html>