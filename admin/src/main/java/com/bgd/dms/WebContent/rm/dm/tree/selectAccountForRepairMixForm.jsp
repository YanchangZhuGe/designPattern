<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
	String own_org_id = request.getParameter("own_org_id");
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

 <title>查询多项目的设备台账</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box" style="height:64px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_131.png" width="6" height="64" /></td>
			    <td background="<%=contextPath%>/images/list_151.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_name" name="s_dev_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_model" name="s_dev_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name"></td>
			    <td class="ali_cdn_input">
			    	
			    </td>
			    <td class="ali_query">
			    	
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_sign" name="s_dev_sign" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_self_num" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_license_num" name="s_license_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_171.png" width="4" height="64" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}' {selectflag}/>" >选择</td>
					<td class="bt_info_odd" exp={asset_coding}>设备编号</td>
					<td class="bt_info_even" exp={dev_name}>设备名称</td>
					<td class="bt_info_odd" exp={dev_model}>规格型号</td>
					<td class="bt_info_even" exp={self_num}>自编号</td>
					<td class="bt_info_odd" exp={dev_sign}>实物标识号</td>
					<td class="bt_info_even" exp={license_num}>牌照号</td>
			     </tr>
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
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var length = <%=orgidlength%>;

	function refreshData(v_dev_sign,v_license_num){
	
		var str = "select account.dev_acc_id,account.asset_coding, ";
		str += "account.dev_coding,account.self_num,account.dev_sign, ";
		str += "account.license_num,account.dev_name,account.dev_model ";
		str += "from gms_device_account account ";
		str += "where (account.using_stat='0110000007000000002' or account.using_stat='0110000007000000006') ";
		//是否需要用选择的转出单位查找对应的所属单位信息卡
		//str += "and account.owning_org_id='<%=own_org_id%>' ";
		str += "and (substr(owning_sub_id,1,"+length+") = '<%=suborgid%>' or substr(usage_sub_id,1,"+length+") ='<%=suborgid%>') ";
		if(v_dev_sign!=undefined && v_dev_sign!=''){
			str += "and account.dev_sign like '"+v_dev_sign+"%' ";
		}
		if(v_license_num!=undefined && v_license_num!=''){
			str += "and account.license_num like '"+v_license_num+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
		/*
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"'/></td>";
			innerhtml += "<td>"+retObj[index].asset_coding+"</td>";
			innerhtml += "<td>"+retObj[index].dev_name+"</td>" ;
			innerhtml += "<td>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td>"+retObj[index].self_num+"</td>";
			innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td>"+retObj[index].license_num+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
		*/
	}
	function submitInfo(){
		var obj = document.getElementsByName("selectedbox");
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
		//返回信息是  台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号 
		selectedids += "~"+columnsObj[1].innerText+"~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText;
		selectedids += "~"+columnsObj[4].innerText+"~"+columnsObj[5].innerText+"~"+columnsObj[6].innerText;
		window.returnValue = selectedids;
		window.close();
	}
	function dbclickRow(shuaId){
		var obj = document.getElementsByName("selectedbox");
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
		//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号 
		selectedids += "~"+columnsObj[1].innerText+"~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText;
		selectedids += "~"+columnsObj[4].innerText+"~"+columnsObj[5].innerText+"~"+columnsObj[6].innerText;
		window.returnValue = selectedids;
		window.close();
	}
	function loadDataDetail(dev_acc_id){
		$("input[type='checkbox'][name='selectedbox']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][id='selectedbox_"+dev_acc_id+"'][disabled!='disabled']").attr("checked","checked");
    }
	function newClose(){
		window.close();
	}
</script>
</html>