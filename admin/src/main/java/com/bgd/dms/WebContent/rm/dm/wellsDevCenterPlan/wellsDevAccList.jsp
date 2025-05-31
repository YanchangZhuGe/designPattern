<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userid = user.getEmpId();
    String userOrgId = user.getSubOrgIDofAffordOrg();
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
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>多项目-井中设备分中心-设备台账</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name" style="width:60px;padding-right:0px">设备名称</td>
			    <td class="ali_cdn_input" style="width:100px"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <!-- <td class="ali_cdn_name" style="width:60px;padding-right:0px">规格型号</td>
			    <td class="ali_cdn_input" style="width:100px"><input id="s_dev_model" name="s_dev_model" type="text" /></td> -->
			    <td class="ali_cdn_name" style="width:60px;padding-right:0px">自编号</td>
			    <td class="ali_cdn_input" style="width:100px"><input id="s_self_num" name="s_self_num" type="text" /></td>
			    <td class="ali_cdn_name" style="width:60px;padding-right:0px">牌照号</td>
			    <td class="ali_cdn_input" style="width:100px"><input id="s_license_num" name="s_license_num" type="text" /></td>
			    <td class="ali_cdn_name" style="width:60px;padding-right:0px">实物标识号</td>
			    <td class="ali_cdn_input" style="width:100px"><input id="s_dev_sign" name="s_dev_sign" type="text" /></td>
			    <td class="ali_cdn_name">使用情况:</td>
          		<td class="ali_cdn_input" style="width:100px">
          			<select id="s_using_stat" name="s_using_stat" class="select_width">
            			<option value="">--请选择--</option>
            			<option value="0110000007000000002">闲置</option>
            			<option value="0110000007000000001">在用</option>
      					<option value="0110000007000000006">其他</option>
            		</select>
          		</td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
      			 <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="多条件查询"></auth:ListButton>
			    <!--<auth:ListButton functionId="" css="sx" event="onclick='doChangeTeam()'" title="进场信息调整"></auth:ListButton>
			    <auth:ListButton functionId="" css="bb" event="onclick='doValidopr()'" title="启用设备"></auth:ListButton>
			    <auth:ListButton functionId="" css="rlfprw" event="onclick='doTransfer()'" title="转移返还"></auth:ListButton>-->
			    <auth:ListButton functionId="" css="fh" event="onclick='doDevReturn()'" title="返还"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出"></auth:ListButton>
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
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' isleaving='{is_leaving}' usingstat='{using_stat}' fkdevaccid='{fk_dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'/>" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{dev_coding}">ERP设备编号</td>
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name_desc}">所在单位</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
					<td class="bt_info_even" exp="{project_name_desc}">项目名称</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{devback_desc}">是否返还</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getContentTab(this,6)">资产价值</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
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
						     <!-- <td class="inquire_item6">AMIS资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td> -->
						    <td class="inquire_item6">ERP设备编号</td>
						    <td class="inquire_form6"><input id="dev_erp_id" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" /></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">主机序列号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">出厂编号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
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
						    <td class="inquire_item6">是否停用</td>
						    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
						  </tr>						               
			        </table>
				</div>
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none;">
					<table id="assetTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">固定资产原值</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_value" name=""  class="input_width" type="text" /></td>
						    <td class="inquire_item6">固定资产净值</td>
						    <td class="inquire_form6"><input id="dev_acc_net_value" name="" class="input_width" type="text" /></td>
						 </tr>
					</table>
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
function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		$(filternotobj).hide();
		$(filterobj).show();
	}
$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var userid = '<%=userid%>';
	
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		//var v_dev_model = document.getElementById("s_dev_model").value;
		var v_self_num = document.getElementById("s_self_num").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var v_dev_sign = document.getElementById("s_dev_sign").value;
		var v_using_stat = document.getElementById("s_using_stat").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		//obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"dev_sign","value":v_dev_sign});
		obj.push({"label":"using_stat","value":v_using_stat});
		obj.push({"label":"self_num","value":v_self_num});
		obj.push({"label":"license_num","value":v_license_num});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		//document.getElementById("s_dev_model").value="";
		document.getElementById("s_self_num").value="";
		document.getElementById("s_license_num").value="";
		document.getElementById("s_dev_sign").value="";
		document.getElementById("s_using_stat").value="";
    }

	function refreshData(arrObj){
		
		var str = "select pro.project_name as project_name_desc,useorg.org_abbreviation as usage_org_name_desc,t.fk_dev_acc_id,t.dev_acc_id,t.using_stat,t.dev_coding,t.dev_name,t.license_num,t.self_num,t.dev_model,t.dev_sign,t.dev_position,";
			str += "t.is_leaving,case t.is_leaving when '0' then '未返还' when '1' then '已返还' end as devback_desc,";
			str += "org.org_abbreviation owning_org_name_desc,sdc.coding_name as using_stat_desc,sdt.coding_name as tech_stat_desc,sda.coding_name as account_stat_desc ";
			str += "from gms_device_account_wells t ";
			str += "left join comm_coding_sort_detail sdc on sdc.coding_code_id = t.using_stat ";
			str += "left join comm_coding_sort_detail sdt on sdt.coding_code_id = t.tech_stat ";
			str += "left join comm_coding_sort_detail sda on sda.coding_code_id = t.account_stat ";
			str += "left join comm_org_information org on org.org_id = t.owning_org_id ";
			str += "left join gp_task_project pro on pro.project_info_no=t.project_info_id ";
			str += "left join comm_org_information useorg on useorg.org_id=t.usage_org_id ";
			str += "where t.bsflag = '0' ";	  
				
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label.indexOf("actual_in_time")==-1){
					if(arrObj[key].label=='owning_org_name'){
						str += "and org.org_abbreviation like '%"+arrObj[key].value+"%' ";
					}else{
						str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
					}
				}else{
					if(arrObj[key].label.indexOf("actual_in_time_e")==-1){
						str += "and t.actual_in_time >= to_date('"+arrObj[key].value+"','yyyy-mm-dd') ";
					}else{
						str += "and t.actual_in_time <= to_date('"+arrObj[key].value+"','yyyy-mm-dd') ";
					}
				}
			}
		}
		str += "order by t.dev_type ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	
    function loadDataDetail(shuaId){
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		if(shuaId!=null){
			var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from gms_device_account_wells t where dev_acc_id= '"+shuaId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from gms_device_account_wells t where dev_acc_id= '"+ids+"'"  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		}

		document.getElementById("dev_acc_name").value =retObj[0].dev_name;
		document.getElementById("dev_acc_sign").value =retObj[0].dev_sign;
		document.getElementById("dev_acc_model").value =retObj[0].dev_model;
		document.getElementById("dev_acc_self").value =retObj[0].self_num;
		document.getElementById("dev_acc_license").value =retObj[0].license_num;
	  //document.getElementById("dev_acc_assetcoding").value =retObj[0].asset_coding;
		document.getElementById("dev_erp_id").value =retObj[0].erp_id;
		document.getElementById("dev_acc_using_stat").value =retObj[0].using_stat_desc;
		document.getElementById("dev_acc_tech_stat").value =retObj[0].tech_stat_desc;
		document.getElementById("dev_acc_producting_date").value =retObj[0].producting_date;
		document.getElementById("dev_acc_engine_num").value =retObj[0].engine_num;
		document.getElementById("dev_acc_chassis_num").value =retObj[0].chassis_num;
		document.getElementById("dev_acc_asset_stat").value =retObj[0].account_stat_desc;
		
		document.getElementById("dev_acc_asset_value").value =retObj[0].asset_value;
		document.getElementById("dev_acc_net_value").value =retObj[0].net_value;
		
		document.getElementById("dev_type").value =retObj[0].dev_type;
		
    }
	
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevquery.jsp');
    }
    function doDevReturn(){
    	var s_dev_acc_id;
    	var s_is_leaving;
    	var s_using_stat;
    	var s_fk_dev_acc_id;
    	$("input[type='checkbox'][name='rdo_entity_id']").each(function(i){
    		if(this.checked){
    			s_dev_acc_id = this.value;
    			s_is_leaving = this.isleaving;
    			s_using_stat = this.usingstat;
    			s_fk_dev_acc_id = this.fkdevaccid;
    		}
    	});
    	
		if(s_dev_acc_id==undefined){
			alert("请选择需要返还的设备!");
			return;
		}
		if(s_is_leaving=='1'){
			alert("此设备已返还!");
			return;
		}
		if(s_using_stat!='0110000007000000002'){
			alert("在用设备不能返还!");
			return;
		}

    	if(window.confirm("确认返还设备?")){
    		jcdpCallService("DevCommInfoSrv", "wellsCenterDevBack", "devaccid="+s_dev_acc_id+"&fkdecaccid="+s_fk_dev_acc_id+"&userid="+userid);
        }
    	refreshData();
    }
</script>
</html>