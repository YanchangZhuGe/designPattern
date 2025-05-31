<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
	String condition = request.getParameter("condition");
	String own_org_id = request.getParameter("own_org_id");
	String projectinfono = request.getParameter("projectinfono");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

 <title>查询多项目的设备台账</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
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
			     	<td class="bt_info_odd">选择</td>
			     	<td class="bt_info_even">设备编码</td>
					<td class="bt_info_odd">设备名称</td>
					<td class="bt_info_even">规格型号</td>
					<td class="bt_info_odd">自编号</td>
					<td class="bt_info_even">实物标识号</td>
					<td class="bt_info_odd">牌照号</td>
					<td class="bt_info_even">实际进场时间</td>
					<td class="bt_info_odd">计划离场时间</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
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
		 </div>
	</div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

	var length = <%=orgidlength%>;
	var condition ="<%= condition %>";

	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select bad.device_backdet_id,bad.dev_acc_id,bad.dev_coding,ci.dev_ci_name,ci.dev_ci_model,";
		str += "bad.self_num,bad.dev_sign,bad.license_num,bad.actual_in_time,bad.planning_out_time ";
		str += "from gms_device_backapp_detail bad ";
		str += "left join gms_device_backapp ba on bad.device_backapp_id = ba.device_backapp_id ";
		str += "left join gms_device_account_dui dui on dui.dev_acc_id = bad.dev_acc_id ";
		str += "left join gms_device_codeinfo ci on dui.dev_type = ci.dev_ci_code ";
		str += "where bad.state = '0' and bad.device_mixinfo_id is null ";
		str += "and ba.project_info_id = '<%=projectinfono%>' ";
   		str += "and dui.owning_org_id = '<%=own_org_id%>' ";
   		//等有了设备，给这个条件放开，不能选择外租设备
   		//str += "and dui.account_stat != '0110000013000000005' ";
   		if(condition!="null"&&condition!=""){
			str += condition;
		}
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and ci.dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and ci.dev_model like '"+v_dev_ci_model+"%' ";
		}
		str += "order by planning_out_time ";
		alert(str);
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].device_backdet_id+"' name='tr' midinfo='"+retObj[index].device_backdet_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].device_backdet_id+"' value='"+retObj[index].device_backdet_id+"'/></td>";
			innerhtml += "<td>"+retObj[index].dev_coding+"</td>";
			innerhtml += "<td>"+retObj[index].dev_ci_name+"</td>";
			innerhtml += "<td>"+retObj[index].dev_ci_model+"</td>" ;
			innerhtml += "<td>"+retObj[index].self_num+"</td>";
			innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td>"+retObj[index].license_num+"</td>";
			innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
			innerhtml += "<td>"+retObj[index].planning_out_time+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
	}
	function submitInfo(){
		var obj = document.getElementsByName("idinfo");
		var count = 0;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				count ++;
			}
		}
		if(count != 1){
			alert("请选择一条记录!");
			return;
		}
		var selectedids = null;
		var columnsObj = null;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				selectedids = selectedobj.value;
				columnsObj = selectedobj.parentNode.parentNode.cells;
				break;
			}
		}
		//返回信息是 设备名称+ 规格型号 + 调配数量 + 调配人 + 调配时间 + 班组 + 计划开始时间
		selectedids += "~"+columnsObj[1].innerText+"~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText;
		selectedids += "~"+columnsObj[5].innerText+"~"+columnsObj[6].innerText+"~"+columnsObj[7].innerText+"~"+columnsObj[8].innerText;
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
</script>
</html>