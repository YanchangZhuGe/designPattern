<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	System.out.println("projectInfoNo:"+projectInfoNo);
    String code = request.getParameter("code");
    String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
      	<%---
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			     <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">进队时间&nbsp;&nbsp;</td>
			    <td style="width:250px;">
			    	<input id="s_start_date" name="s_start_date" type="text" size="12"/><img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(s_start_date,tributton1);" />
			    	&nbsp;至&nbsp;
			    	<input id="s_end_date" name="s_end_date" type="text" size="12"/><img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(s_end_date,tributton2);" />
			    </td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
      			 <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="多条件查询"></auth:ListButton>
			    
			    <auth:ListButton functionId="" css="sx" event="onclick='doChangeTeam()'" title="进场信息调整"></auth:ListButton>
			    <auth:ListButton functionId="" css="bb" event="onclick='doValidopr()'" title="启用设备"></auth:ListButton>
			    
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出"></auth:ListButton>
				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			 --%>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' usingstat='{using_stat_desc}' id='rdo_entity_id_{dev_acc_id}'/>" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<%-- 
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					--%>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<%-- 
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{asset_coding}">AMIS资产编号</td>
					<td class="bt_info_odd" exp="{team_name}">班组</td>
					<td class="bt_info_even" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{asset_value}">固定资产原值</td>
					--%>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{alloprinfo}">操作手</td>
					<%-- 
					<td class="bt_info_even" exp="{actual_in_time}">进队日期</td>
					<td class="bt_info_odd" exp="{stop_date}">报停日期</td>
					<td class="bt_info_even" exp="{restart_date}">启动日期</td>
					<td class="bt_info_odd" exp="{actual_out_time}">离队日期</td>
					--%>
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
			
			
		 </div>
</div>
</body>
<script type="text/javascript">
function setTabBoxHeight1(){
	if(lashened==0){
		$("#table_box").css("height",$(window).height()*0.91);
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
	$("#tab_box .tab_box_content").each(function(){
		if($(this).children('iframe').length > 0){
			$(this).css('overflow-y','hidden');
		}
	});
}
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight1();
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
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_start_date = document.getElementById("s_start_date").value;
		var v_end_date = document.getElementById("s_end_date").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"actual_in_time_s","value":v_start_date});
		obj.push({"label":"actual_in_time_e","value":v_end_date});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_start_date").value="";
		document.getElementById("s_end_date").value="";
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj){
		var userid = '<%=userOrgId%>';
		
		var str = "select t.*,org.org_abbreviation owning_org_name_desc,teamsd.coding_name as team_name,oprtbl.operator_name as alloprinfo,";
		str += "sdc.coding_name as using_stat_desc,sdt.coding_name as tech_stat_desc,sda.coding_name as account_stat_desc ";
		str += "from gms_device_account_dui t ";
		str += "left join (select device_account_id,operator_name from ( "
			+"select tmp.device_account_id,tmp.operator_name,row_number() "
			+"over(partition by device_account_id order by length(operator_name) desc ) as seq " 
			+"from (select device_account_id,wmsys.wm_concat(operator_name) "
			+"over(partition by device_account_id order by operator_name) as operator_name "
			+"from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on t.dev_acc_id = oprtbl.device_account_id ";
		str += "left join comm_coding_sort_detail sdc on sdc.coding_code_id = t.using_stat ";
		str += "left join comm_coding_sort_detail sdt on sdt.coding_code_id = t.tech_stat ";
		str += "left join comm_coding_sort_detail sda on sda.coding_code_id = t.account_stat ";
		str += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = t.dev_team ";
		str += "left join comm_org_information org on org.org_id = t.owning_org_id ";
		str += "where t.project_info_id='"+projectInfoNos+"' ";
		
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label.indexOf("actual_in_time")==-1){
					str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}else{
					if(arrObj[key].label.indexOf("actual_in_time_e")==-1){
						str += "and t.actual_in_time >= to_date('"+arrObj[key].value+"','yyyy-mm-dd') ";
					}else{
						str += "and t.actual_in_time <= to_date('"+arrObj[key].value+"','yyyy-mm-dd') ";
					}
				}
			}
		}
		str += "order by t.dev_type,t.actual_in_time desc ";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	
    function loadDataDetail(shuaId){
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		if(shuaId!=null){
			var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT_DUI t where dev_acc_id= '"+shuaId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
			 //retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT_DUI t where dev_acc_id= '"+ids+"'"  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		}

		document.getElementById("dev_acc_name").value =retObj[0].dev_name;
		document.getElementById("dev_acc_sign").value =retObj[0].dev_sign;
		document.getElementById("dev_acc_model").value =retObj[0].dev_model;
		document.getElementById("dev_acc_self").value =retObj[0].self_num;
		document.getElementById("dev_acc_license").value =retObj[0].license_num;
		document.getElementById("dev_acc_assetcoding").value =retObj[0].asset_coding;
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
    	popWindow('<%=contextPath%>/rm/dm/device-xd/devquery.jsp');
    }
    function doChangeTeam(){
    	var s_dev_acc_id ;
    	var s_using_stat ;
    	$("input[type='checkbox'][name='rdo_entity_id']").each(function(i){
    		if(this.checked){
    			s_dev_acc_id = this.value;
    		}
    	});
		if(s_dev_acc_id==undefined){
			alert("请选择需要修改班组的台账记录!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/device-xd/confirmTeamInfo.jsp?dev_acc_id='+s_dev_acc_id,"900:600");
    }
    function confirmTeamInfo(dev_acc_id,teaminfo,account_stat,actindate){
    	if(window.confirm("是否修改此台账记录的进场信息?")){
    		var updatesql = "update gms_device_account_dui set dev_team='"+teaminfo+"' ";
    		if('0110000013000000005'==account_stat&&actindate!=null){
    			updatesql += ",actual_in_time=to_date('"+actindate+"','yyyy-mm-dd') ";
    		}
    		updatesql += "where dev_acc_id='"+dev_acc_id+"'";
    		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+updatesql+"&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
    }
    function doValidopr(){
    	var s_dev_acc_id ;
    	var s_using_stat ;
    	$("input[type='checkbox'][name='rdo_entity_id']").each(function(i){
    		if(this.checked){
    			s_dev_acc_id = this.value;
    			s_using_stat = this.usingstat;
    		}
    	});
		if(s_dev_acc_id==undefined){
			alert("请选择需要启用的台账记录!");
			return;
		}
		if(s_using_stat!='停用'){
			alert("启用功能处理的台账状态必须为[停用]!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/device-xd/confirmDateInfo.jsp?dev_acc_id='+s_dev_acc_id,"600:400");
    }
    function confirmDateInfo(dev_acc_id,restartdate){
    	if(window.confirm("是否启用此台账记录?")){
			retObj = jcdpCallService("DevCommInfoSrv", "saveDuiAccValidInfo", "dev_acc_id="+dev_acc_id+"&restartdate="+restartdate);
			refreshData();
		}
    }
</script>
</html>