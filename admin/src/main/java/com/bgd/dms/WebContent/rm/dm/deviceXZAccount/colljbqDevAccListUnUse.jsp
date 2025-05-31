<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
 	UserToken user = OMSMVCUtil.getUserToken(request);
	String contextPath = request.getContextPath();
	String devTreeId = request.getParameter("devTreeId");
	
	String userSubid = request.getParameter("orgSubId");
	if(userSubid==null){
	userSubid=user.getOrgSubjectionId();
	}
	String country = request.getParameter("country");
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
		String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(userOrgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
  <title>设备调剂</title> 
 </head>
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			   
      			<td class="ali_query">
				    <span class="cx"><a href="####" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
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
			  <table style="width:98.5%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_even" exp="{dev_type}">采集设备类型</td>
					<td class="bt_info_odd" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_even" exp="{unit_name}">计量单位</td>
					<td class="bt_info_odd" exp="{owning_org_name}">所属单位</td>
					<td class="bt_info_even" exp="{usage_org_name}">所在单位</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">闲置数量</td>
					<td class="bt_info_odd" exp="{use_num}">在用数量</td>
					<td class="bt_info_even" exp="{other_num}">其他数量</td>
					<td class="bt_info_odd" exp="{ifcountry}">国内/国外</td>
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
$(function(){
	$(window).resize(function(){
		if(lashened==0){
			$("#table_box").css("height",'200px');
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-100);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	});
})
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var devTreeId = '<%=devTreeId%>';
	var orgSubId = '<%=userSubid%>';
 	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var orgLength = orgSubId.length;
	var country = '<%=country%>';
	//查询
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		refreshData("");
    }
	//点击树节点查询
	function refreshData(arrObj){
	
		var sql = "";
	 
			sql += "select tmp.* from (select acc.owning_org_id,suborg.org_subjection_id,acc.usage_org_id,acc.dev_acc_id,acc.dev_unit,nvl(acc.total_num, 0) total_num,nvl(acc.unuse_num, 0) unuse_num,acc.dev_name,acc.dev_model,nvl(acc.use_num, 0) use_num,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,nvl(acc.other_num, 0) other_num,ci.dev_code,ci.dev_name as dev_type, "+
					"usageorg.org_abbreviation as usage_org_name,unitsd.coding_name as unit_name, case when suborg.org_subjection_id like 'C105001005%' then '塔里木物探处' when suborg.org_subjection_id like 'C105001002%' then '新疆物探处' when suborg.org_subjection_id like 'C105001003%' then '吐哈物探处' when suborg.org_subjection_id like 'C105001004%' then '青海物探处' when suborg.org_subjection_id like 'C105005004%' then '长庆物探处' when suborg.org_subjection_id like 'C105005000%' then '华北物探处' when suborg.org_subjection_id like 'C105005001%' then '新兴物探处' when suborg.org_subjection_id like 'C105007%' then '大港物探处' when suborg.org_subjection_id like 'C105063%' then '辽河物探处' when suborg.org_subjection_id like 'C105006%' then '装备服务处' when suborg.org_subjection_id like 'C105002%' then '国际勘探事业部' when suborg.org_subjection_id like 'C105003%' then '研究院'  when suborg.org_subjection_id like 'C105008%' then '综合物化处' when suborg.org_subjection_id like 'C105015%' then '井中地震中心'else '' end as owning_org_name "+
					",acc.usage_sub_id from gms_device_coll_account acc "+
					"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
					"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id and usageorg.bsflag = '0' "+
					"left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0' "+
					"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
					"where acc.bsflag='0' and ci.is_leaf = '1' and ( acc.owning_sub_id like '<%=userSubid%>%' or acc.usage_sub_id like '<%=userSubid%>%' ) "+
					")tmp where 1=1 and (tmp.dev_code like '04%' or tmp.dev_code like '06%' ) ";
			for(var key in arrObj){
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				sql += " and tmp."+arrObj[key].label+" like '%"+arrObj[key].value+"%'";
			}
		}
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	//固定表头
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable);
		newTitleTable.style.top=y+"px";
			
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;		
	}
	 
</script>
</html>