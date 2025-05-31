<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectinfono = request.getParameter("projectinfono");
	String out_org_id = request.getParameter("outorgid")==null?"":request.getParameter("outorgid");
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
 <title>查询队级返还页面</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
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
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
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
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

	var projectInfoNos = '<%=projectinfono%>';
	var out_org_id = '<%=out_org_id%>';

	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select account.dev_acc_id,account.asset_coding, ";
		str += "account.dev_coding,account.self_num,account.dev_sign, ";
		str += "account.license_num,account.actual_in_time,account.planning_out_time, ";
		str += "account.dev_name,account.dev_model ";
		str += "from gms_device_account_dui account ";
		str += "where account.project_info_id='"+projectInfoNos+"' ";
		if(out_org_id != null && out_org_id != ""){
			str += "and account.out_org_id='"+out_org_id+"' ";
		}
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and account.dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and account.dev_model like '"+v_dev_ci_model+"%' ";
		}
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"'/></td>";
			innerhtml += "<td>"+retObj[index].dev_coding+"</td>";
			innerhtml += "<td>"+retObj[index].dev_name+"</td>";
			innerhtml += "<td>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td>"+retObj[index].self_num+"</td>";
			innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td>"+retObj[index].license_num+"</td>";
			innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
			innerhtml += "<td>"+retObj[index].planing_out_time+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
	}
	function submitInfo(){
		var selectedids;
		var count = 0;
		$("input[type='checkbox'][name='idinfo']").each(function(i){
			if(this.checked){
				if(count==0){
					selectedids = this.value;
				}else{
					selectedids += "~"+this.value;
				}
				count = count+1;
			}
		});
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
</script>
</html>