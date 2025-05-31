<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devTreeId = request.getParameter("devTreeId");
	String orgSubId = request.getParameter("orgSubId");
	String country = request.getParameter("country");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
  <title>设备调剂</title> 
 </head>
 <body style="background:#fff" onload="refreshData()">
  <input id="export_name" name="export_name" value="大型设备" type='hidden' />
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
			    <td class="ali_cdn_name" >牌照号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_license_num" name="s_license_num" type="text" /></td>
			    <td class="ali_cdn_name" >自编号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_self_num" name="s_self_num" type="text" /></td>
			     <td class="ali_cdn_name" >实物标识号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_sign" name="s_dev_sign" type="text" /></td>
      			<td class="ali_query">
				    <span class="cx"><a href="####" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>		
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="dxsbzyc_tj" css="yd" event="onclick='toCopy()'" title="调剂"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{erp_id}">ERP编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name_desc}">所在单位</td>
					<td class="bt_info_even" exp="{tech_stat_desc}">技术状况</td>
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_even" exp="{dev_position}">所在位置</td>
					<td class="bt_info_odd" exp="{ifcountry_tmp}">国内/国外</td>
					<td class="bt_info_even" exp="{spare1}">备注1</td>
					<td class="bt_info_odd" exp="{spare2}">备注2</td>
					<td class="bt_info_even" exp="{spare3}">备注3</td>
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
	var orgSubId = '<%=orgSubId%>';
	var country = '<%=country%>';
	//查询
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var v_self_num = document.getElementById("s_self_num").value;
		var v_dev_sign = document.getElementById("s_dev_sign").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"license_num","value":v_license_num});
		obj.push({"label":"self_num","value":v_self_num});
		obj.push({"label":"dev_sign","value":v_dev_sign});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		document.getElementById("s_license_num").value="";
		document.getElementById("s_self_num").value="";
		document.getElementById("s_dev_sign").value="";
		refreshData("");
    }
	//页面加载刷新
	function refreshData(arrObj){
		var str = "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '国内') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id,"
			+ " t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type,"
			+ " t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.using_stat,t.saveflag,t.spare1,t.spare2,t.spare3,t.spare4,"
			+ " case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' when t.owning_sub_id like 'C105001002%' then '新疆物探处'"
			+ " when t.owning_sub_id like 'C105001003%' then '吐哈物探处' when t.owning_sub_id like 'C105001004%' then '青海物探处'"
			+ " when t.owning_sub_id like 'C105005004%' then '长庆物探处' when t.owning_sub_id like 'C105005000%' then '华北物探处'"
			+ " when t.owning_sub_id like 'C105005001%' then '新兴物探开发处' when t.owning_sub_id like 'C105007%' then '大港物探处'"
			+ " when t.owning_sub_id like 'C105063%' then '辽河物探处' when t.owning_sub_id like 'C105086%' then '深海物探处'"
			+ " when t.owning_sub_id like 'C105008%' then '综合物化处' when t.owning_sub_id like 'C105002%' then '国际勘探事业部'"
			+ " when t.owning_sub_id like 'C105006%' then '装备服务处' when t.owning_sub_id like 'C105003%' then '研究院'"
			+ " when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else info.org_abbreviation end as owning_org_name_desc,"
			+ " i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc from gms_device_account t"
			+ " left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0'"
			+ " left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0'"
			+ " left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat"
			+ " left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat"
			+ " left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat"
			+ " left join dms_device_tree tree on tree.device_code=t.dev_type"
			+ " where t.bsflag='0' and t.ifunused='1' and t.ifproduction='5110000186000000001' and t.tech_stat = '0110000006000000001'"
			+ " and t.account_stat = '0110000013000000003' and t.using_stat = '0110000007000000002'"
			+ " and (tree.dev_tree_id like 'D002%' or tree.dev_tree_id like 'D003%' or tree.dev_tree_id like 'D006%' or tree.dev_tree_id like 'D004%'  or tree.dev_tree_id like 'D002%') ";
		
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label!='project_name'){
					str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}else{
					str += "and p.project_name like '%"+arrObj[key].value+"%' ";
				}
			}
		}
		if(orgSubId!='null'){
			str += " and t.owning_sub_id like '"+orgSubId+"%'";
		}
		if(country!='null'){
			if(country=="1"){
				str += " and t.ifcountry = '国内' ";
			}
			if(country=="2"){
				str += " and t.ifcountry = '国外' ";
			}
		}
		if(devTreeId!="null"){
			var strs= new Array();
				strs = devTreeId.split(","); //字符分割 
				str += " and ( ";
			for (i=0;i<strs.length ;i++ ) { 
				if(i==0){
					str += " tree.dev_tree_id like '"+strs[i]+"%' ";
				}else{
					str += " or tree.dev_tree_id like '"+strs[i]+"%' ";
				}
			} 
			str += " )";
		}
		str += " order by t.dev_type,t.owning_sub_id ";
		cruConfig.queryStr = str;
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
	//调剂
	function toCopy(){
 		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
	    var temp = ids.split(",");
		var dev_ids = "";
		for(var i=0;i<temp.length;i++){
			if(dev_ids!=""){
				dev_ids += ","; 
			}
			dev_ids += "'"+temp[i]+"'";
		}
		var ownsubid = "";//转出单位subid
		var retObj = jcdpCallService("DevInsSrv", "gettjCheckInfo", "devaccid="+dev_ids);
		if(typeof retObj.devMap!="undefined"){
			ownsubid = retObj.devMap.owning_sub_id;
			if(retObj.devMap.tjflag > 0){
				alert("正在调剂的设备不能进调剂!");
				return;
			}
			if(ownsubid.indexOf(",")>0){
				alert("请选择同一个物探处的设备进行调剂!");
				return;
			}
			if(confirm('确定要将设备进行调剂么?')){  
				popWindow("<%=contextPath%>/rm/dm/deviceXZAccount/devMixForxztjNewApply.jsp?devaccid="+dev_ids+"&subid="+ownsubid+"&addupflag=add",'1080:680','-填写调剂申请'); 				
			}
		}
	}
</script>
</html>