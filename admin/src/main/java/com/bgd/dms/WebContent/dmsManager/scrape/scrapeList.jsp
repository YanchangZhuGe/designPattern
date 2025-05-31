<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String code = request.getParameter("code");
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String orgCode = user.getOrgCode();
	String orgId = user.getOrgId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<%@include file="/common/include/easyuiresource.jsp"%>
<title>项目页面</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">报废单号</td>
			    <td class="ali_cdn_input"><input id="s_scrape_apply_no" name="s_scrape_apply_no" type="text" class="input_width" /></td>     
			    <td class="ali_cdn_name">批复单号</td>
			    <td class="ali_cdn_input"><input id="s_scrape_report_no" name="s_scrape_report_no" type="text" class="input_width" /></td>
      			<!-- <td class="ali_cdn_input"><input id="s_app_no" name="s_app_no" type="hidden" class="input_width"/></td> -->
			    <!-- <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input"><input id="s_self_num" name="s_self_num" type="text" /></td> -->
			    <!-- <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input"><input id="s_license_num" name="s_license_num" type="text" /></td> -->
      			<td class="ali_cdn_name">报废原因</td>
			    <td class="ali_cdn_input" style="width: 130px;">
			    	<select name="s_scrape_type" id="s_scrape_type">
			    		<option value="">--请选择--</option>
			    		<option value="0">正常报废</option>
			    		<option value="1">技术淘汰</option>
			    		<option value="2">毁损</option>
			    		<option value="3">盘亏</option>
			    	</select>
			    </td>
			    <td class="ali_cdn_name">资产状况</td>
	            <td class="ali_cdn_input" style="width: 130px;">
	          		<select name="s_account_stat" id="s_account_stat">
            			<option value="">--请选择--</option>
      					<option value="0110000013000000001">报废</option>
      					<option value="0110000013000000002">已处置</option>
      					<option value="0110000013000000003">在账</option>
      					<!--
      					<option value="0110000013000000005">外租</option>
      					<option value="0110000013000000006">不在账</option>
      					option value="0110000013000000002">处理</option>
      					<option value="0110000013000000004">已合并</option-->
	            	</select>
	            </td>
			    <td class="ali_cdn_name">排序:</td>
			    <td class="ali_cdn_input" style="width: 130px;">
	          		<select name="s_order_number" id="s_order_number">
      					<option value="dev_coding">设备编号</option>
      					<option value="dev_name" selected>设备名称</option>
      					<option value="dev_type">设备编码</option>
      					<option value="asset_coding">资产编码</option>
      					<option value="dev_model">规格型号</option>
      					<option value="org_name">所属单位</option>
      					<option value="producting_date">投产日期</option>
	            	</select>
	            </td>
	            <td class="ali_cdn_input" style="width: 130px;">
	          		<select name="s_order_desc" id="s_order_desc">
      					<option value="asc" selected>从小到大</option>
      					<option value="desc">从大到小</option>
	            	</select>
	            </td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>			          			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{erp_id}">设备编号</td>
					<td class="bt_info_odd" exp="{old_erp_id}">旧设备编号</td>
					<td class="bt_info_even" exp="{dev_type}">设备编码</td>
					<td class="bt_info_even" exp="{asset_coding}">资产编码</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{handle_date}">处理时间</td>
					<td class="bt_info_even" exp="{asset_value}">原值</td>
					<td class="bt_info_even" exp="{net_value}">净值</td>
					<!-- <td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td> -->
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_12"><a href="#"  onclick="getTab3(12);loaddata('',12)">报废审批信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3);loaddata('',3)">附件</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_acc_name" name=""  class="input_width" type="text" /></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_acc_model" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">设备编码</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" /></td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">牌照号</td>
						    <td class="inquire_form6"><input id="dev_acc_license" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">发动机号</td>
						    <td class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">底盘号</td>
						    <td class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" /></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">资产状况</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">技术状况</td>
						    <td class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">使用状况</td>
						    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">固定资产原值</td>
						    <td class="inquire_form6"><input id="dev_asset_value" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">固定资产净值</td>
						    <td class="inquire_form6"><input id="dev_net_value" name="" class="input_width" type="text" /></td>
						  </tr>
						               
			        </table>
				</div>
			<div id="tab_box_content10" class="tab_box_content" style="display:none;">
				<table id="remarkTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">备注</td>
						    <td class="inquire_form6"><input id="dev_acc_remark" name=""  class="input_width" type="text" /></td>
						 </tr>
				</table>
			</div>
			<div id="tab_box_content12" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="bfczxqqd" id="bfczxqqd" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				<!-- <table id="" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tbody id="assign_body"></tbody>
				</table> -->
			</div>
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
		 </div>
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	/* cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrvNew";
	cruConfig.queryOp = "queryScrapeInfoNew"; */
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		debugger;
		/* var v_license_num = document.getElementById("s_license_num").value;
		var v_self_num = document.getElementById("s_self_num").value; */
		var v_scrape_type = document.getElementById("s_scrape_type").value;
		var v_account_stat = document.getElementById("s_account_stat").value;
		var v_order_number = document.getElementById("s_order_number").value;
		var v_order_desc = document.getElementById("s_order_desc").value;
		var objorder = new Array();
		objorder.push({"label":"order_number","value":v_order_number});
		objorder.push({"label":"order_desc","value":v_order_desc});
		
		var obj = new Array();
		obj.push({"label":"scrape_type","value":v_scrape_type});
		obj.push({"label":"account_stat","value":v_account_stat});
		var v_scrape_apply_no = document.getElementById("s_scrape_apply_no").value;//报废申请
		var objApp= new Array();
		objApp.push({"label":"app.scrape_apply_no","value":v_scrape_apply_no});
		
		var v_scrape_report_no = document.getElementById("s_scrape_report_no").value;//报废批复
		var objRep= new Array();
		objRep.push({"label":"rep.scrape_report_no","value":v_scrape_report_no});
		
		refreshData(obj,objApp,objRep,undefined,objorder);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_scrape_apply_no").value="";
		document.getElementById("s_scrape_report_no").value="";
		document.getElementById("s_account_stat").value="";
		document.getElementById("s_scrape_type").value="";
	 
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj,objApp,objRep,objDis,objorder){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '国内') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id,t.old_dev_coding as old_erp_id,"
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.spare1,t.spare2,t.spare3, "
				+ "info.org_name as owning_org_name_desc, "
				//处理时间  报废/在账 ：批复时间  ;处置:处置结果时间
				+ "case when sd.handle_flag='1' then sd.handle_date when sd.scrape_flag='1' then sd.scrape_date else null end handle_date,"
				+ "i.org_name usage_org_name_desc,co.coding_name as account_stat_desc from (select spare1,spare2,spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,old_dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account tt union all select '' spare1,'' spare2,'' spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,old_dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account_b) t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ "join dms_scrape_detailed sd on sd.foreign_dev_id = t.dev_acc_id and sd.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where bsflag='0') and sd.bsflag='0' "
				+ "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat ";
		}else{
			str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '国内') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id,t.old_dev_coding as old_erp_id,"
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.spare1,t.spare2,t.spare3, "
				+ "info.org_name as owning_org_name_desc, "
				//处理时间  报废/在账 ：批复时间  ;处置:处置结果时间
				+ "case when sd.handle_flag='1' then sd.handle_date when sd.scrape_flag='1' then sd.scrape_date else null end handle_date,"
				+ "i.org_name usage_org_name_desc,co.coding_name as account_stat_desc from (select spare1,spare2,spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,old_dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account tt union all select '' spare1,'' spare2,'' spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,old_dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account_b) t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ "join dms_scrape_detailed sd on sd.foreign_dev_id = t.dev_acc_id and sd.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where bsflag='0') and sd.bsflag='0' "
		        + "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat ";
			}
			str +=" where t.owning_sub_id like '"+userid+"%' ";
			str +="and (t.account_stat = '0110000013000000001' or t.account_stat = '0110000013000000002' or t.tech_stat='0110000006000000005')";
		for(var key in arrObj) {
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label=='source_from'){
					if(arrObj[key].value=="0"){//0表示经报废系统处理的数据
						str += " and scrape_apply_id is  not null ";
					}else if(arrObj[key].value=="1"){//表示历史已有的报废数据
						str += " and scrape_apply_id is null ";
					}
				}else if(arrObj[key].label=='org_name'){
					str += " and info.org_name like '%"+arrObj[key].value+"%' ";
				}else if(arrObj[key].label=='scrape_type'){
					str += " and sd.scrape_type = '"+arrObj[key].value+"' ";
				}else if(arrObj[key].label=='collect_date'){
					str +=" and sd.scrape_apply_id in";
					str +=" (select app.scrape_apply_id from dms_scrape_apply app where app.scrape_collect_id in(select co1.scrape_collect_id from dms_scrape_collect co1";
					str +=" where co1.bsflag = '0' and to_char(co1.collect_date, 'yyyy') = '"+arrObj[key].value+"'))";
				}
				else {
					str += " and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}
			}
		}
		if(objApp!=undefined)
		if(objApp[0].value!=undefined && objApp[0].value!=''){
			//str +=" and (t.dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.scrape_apply_id in(select app.scrape_apply_id from dms_scrape_apply app where 1=1 ";
			//str += " and "+objApp[0].label+" like '%"+objApp[0].value+"%' ";
			//str +="))";
			//str +=" or t.old_dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.scrape_apply_id in(select app.scrape_apply_id from dms_scrape_apply app where 1=1 ";
			//str += " and "+objApp[0].label+" like '%"+objApp[0].value+"%' ";
			//str +=")))";
			str +=" and sd .scrape_apply_id in ( select app.scrape_apply_id ";
			str +=" from dms_scrape_apply app where 1 = 1 and app.bsflag='0'";
            str +=" and app.scrape_apply_no like '%"+objApp[0].value+"%')";
		}
		if(objRep!=undefined)
		if(objRep[0].value!=undefined && objRep[0].value!=''){
			//str +=" and (t.dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_report_id in(select scrape_report_id from dms_scrape_report rep where 1=1 ";
			//str += " and "+objRep[0].label+" like '%"+objRep[0].value+"%' ";
			//str +=")))";
			//str +=" or t.old_dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_report_id in(select scrape_report_id from dms_scrape_report rep where 1=1 ";
			//str += " and "+objRep[0].label+" like '%"+objRep[0].value+"%' ";
			//str +="))))";
			 str +=" and sd .scrape_apply_id in (select scrape_apply_id ";
          	 str +=" from dms_scrape_apply ";
         	 str +=" where scrape_report_id in ";
             str +=" (select scrape_report_id ";
             str +=" from dms_scrape_report rep ";
             str +=" where 1 = 1 and rep.bsflag='0' and  rep.scrape_report_no like '%"+objRep[0].value+"%'))";
			
		}
		if(objDis!=undefined)
		if(objDis[0].value!=undefined && objDis[0].value!=''){
			str +="and (t.dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.dispose_apply_id in(select dis.dispose_apply_id from dms_dispose_apply dis where 1=1 ";
			str += "and "+objDis[0].label+" like '%"+objDis[0].value+"%' ";
			str +="))";
			str +="or t.old_dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.dispose_apply_id in(select dis.dispose_apply_id from dms_dispose_apply dis where 1=1 ";
			str += "and "+objDis[0].label+" like '%"+objDis[0].value+"%' ";
			str +=")))";
		}
		if(objorder!=undefined)
		if(objorder[0].value!=undefined && objorder[0].value!=''){
			if(objorder[0].value=='org_name'){
				str	+= "order by info."+objorder[0].value+" "+objorder[1].value;
			}else{
				str	+= "order by t."+objorder[0].value+" "+objorder[1].value;
			}
			
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	  //选择一条记录
	  function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else 
	             {obj[i].checked = true;  
	              checkvalue = obj[i].value;
	             } 
	        }   
	    }   
	
	  var selectedTagIndex = 0;
    //点击记录查询明细信息
    function loadDataDetail(shuaId){       
    	var retObj;
		if(shuaId!=null){		     
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+shuaId);			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+ids);
		}
		
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            obj[i].checked = false;
	        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//------------------------------------------------------------------------------------
		document.getElementById("dev_acc_name").value =retObj.deviceaccMap.dev_name;
		document.getElementById("dev_acc_sign").value =retObj.deviceaccMap.dev_sign;
		document.getElementById("dev_acc_model").value =retObj.deviceaccMap.dev_model;
		document.getElementById("dev_acc_self").value =retObj.deviceaccMap.self_num;
		document.getElementById("dev_acc_license").value =retObj.deviceaccMap.license_num;
		document.getElementById("dev_acc_assetcoding").value =retObj.deviceaccMap.asset_coding;
		document.getElementById("dev_acc_using_stat").value =retObj.deviceaccMap.using_stat_desc;
		document.getElementById("dev_acc_tech_stat").value =retObj.deviceaccMap.tech_stat_desc;
		document.getElementById("dev_acc_engine_num").value =retObj.deviceaccMap.engine_num;
		document.getElementById("dev_acc_chassis_num").value =retObj.deviceaccMap.chassis_num;
		document.getElementById("dev_acc_asset_stat").value =retObj.deviceaccMap.stat_desc;		
		document.getElementById("dev_acc_remark").value =retObj.deviceaccMap.remark;
		document.getElementById("dev_type").value =retObj.deviceaccMap.dev_type;
		document.getElementById("dev_acc_producting_date").value =retObj.deviceaccMap.producting_date;
		document.getElementById("dev_asset_value").value =retObj.deviceaccMap.asset_value;
		document.getElementById("dev_net_value").value =retObj.deviceaccMap.net_value;
				
		if(shuaId==null)
			shuaId = ids;
		loaddata(shuaId,selectedTagIndex);		
    }
	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/dmsManager/scrape/devquery_arichive.jsp');
    }
    /**
	 * 延迟加载*****************************************************************************************************************************
	 * @param {Object} index
	 */
	function loaddata(ids,index){
		selectedTagIndex=index;		
		if (ids == "") {			
			var ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请先选中一条记录!");
				return;
			}
		}
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(index==12){
			bfczxqqd(ids);
		} 
		if(index==3){
			get_common_doc(ids);
		}
			
	}
 //添加的根据设备编码获取相关报废操作附件的方法
 function get_common_doc(currentid) {
	$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_coll_list.jsp?relationId="+currentid);
 }
/**
* 报废处置详情清单****************************************************************************************************************************
* @param {Object} shuaId
*/
function bfczxqqd(shuaId){
	var scrape_org_id = '<%=orgId%>';//所属组织部门	
	var foreign_dev_id = shuaId;//总台账设备id
    var scrape_detailed_id = jcdpCallService("ScrapeSrvNew", "getDevId", "foreign_dev_id="+foreign_dev_id).scrape_detailed_id;
    if(scrape_detailed_id!=0){
    	$("#bfczxqqd").attr("src","<%=contextPath%>/dmsManager/scrape/scrapeDisposeDetailsList.jsp?scrape_detailed_id="+scrape_detailed_id);
    }else{
    	alert("未找到该设备!");
    }
}
</script>
</html>