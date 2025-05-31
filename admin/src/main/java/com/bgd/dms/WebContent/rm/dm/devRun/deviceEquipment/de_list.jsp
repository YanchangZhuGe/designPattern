<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();    
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();	
	String taskId = request.getParameter("taskId");	
	String projectInfoNo = user.getProjectInfoNo();	
    String code = request.getParameter("code");   
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String projectCommon = user.getProjectCommon();
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
<script type="text/javascript" src="<%=contextPath%>/js/Calendar1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>定人定机</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_self_num" name="s_self_num" type="text" /></td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_license_num" name="s_license_num" type="text" /></td>
			     <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_dev_sign" name="s_dev_sign" type="text" /></td>
			    <td>&nbsp;</td>
			    	<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			     <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
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
					<td class="bt_info_even" exp="<input type='checkbox'  name='rdo_entity_id' value='{dev_acc_id}' usingstat='{using_stat_desc}' id='rdo_entity_id_{dev_acc_id}'/>" >选择</td>			
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<!--<td class="bt_info_even" exp="{asset_coding}">AMIS资产编号</td>-->
					<td class="bt_info_even" exp="{erp_id}">ERP设备编号</td>	
<!-- 					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td> -->
<!-- 					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td> -->
<!-- 					<td class="bt_info_odd" exp="{org_abbreviation}">所属单位</td> -->
					<td class="bt_info_odd" exp="{alloprinfo}">操作手</td>
					<td class="bt_info_even" exp="<input type='button' name='{dev_acc_id}' value='设置' onClick='setDE(this)' id='set_{dev_acc_id}'/>" >设置</td>
<!-- 					<td class="bt_info_odd" exp="{actual_in_time}">进队日期</td> -->
<!-- 					<td class="bt_info_even" exp="{actual_out_time}">离队日期</td> -->
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
				<li class="selectTag" id="tag3_1" ><a href="#" onclick="getContentTab(this,1)">变更记录</a></li>	
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_acc_name" name=""  class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_acc_model" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">设备编码</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" readonly/></td>
						 </tr>
						 <tr>
						    <!--<td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" readonly/></td>-->
						    <td class="inquire_item6">ERP设备编号</td>
						    <td class="inquire_form6"><input id="dev_acc_erpid" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">主机序列号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">出厂编号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">牌照号</td>
						    <td class="inquire_form6"><input id="dev_acc_license" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">发动机号</td>
						    <td class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">底盘号</td>
						    <td class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">资产状况</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">技术状况</td>
						    <td class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">使用状况</td>
						    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						               
			        </table>
				</div>
				
				
				
				<!--定人定机-->
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="djMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_even">操作手</td>
						<td class="bt_info_even">变更时间</td>
							<td class="bt_info_even">变更原因</td>
							<td class="bt_info_even">附件</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
				</div>
							
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid+"&sonFlag="+sonFlag);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid+"&sonFlag="+sonFlag);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid+"&sonFlag="+sonFlag);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectType="<%=projectType%>";
	var projectCommon="<%=projectCommon%>";//是否为非常规项目
	var ret;
	var retFatherNo;
	var sonFlag = null;//是否为子项目标志
	var project_num = 0;

	$().ready(function(){

		//井中地震获取子项目的父项目编号 
		if(projectInfoNos!=null && projectType == "5000100004000000008"){
			if(projectCommon == '1'){//常规项目
				ret = jcdpCallService("DevCommInfoSrv", "getFatherNoInfo", "projectInfoNo="+projectInfoNos);
				retFatherNo = ret.deviceappMap.project_father_no;
			}else if(projectCommon == '0'){//非常规项目
				ret = jcdpCallService("DevCommInfoSrv", "getNoCommonFatherNoInfo", "projectInfoNo="+projectInfoNos);
				retFatherNo = ret.deviceappMap.project_str;
				project_num = retFatherNo.split(",").length;
			}else{
				retFatherNo = '';
			}
		}

		//井中地震子项目屏蔽新增、修改、删除、提交、编辑明细按钮
	    if(projectType == "5000100004000000008" && retFatherNo.length>=1){
	    	sonFlag = 'Y';
	    	$(".dr").hide();//导入
			$(".zj").hide();
			$(".sc").hide();
			$(".xg").hide();
			$(".xz").hide();
	    }else{
	    	sonFlag = 'N';
	    }
	});

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_self_num = document.getElementById("s_self_num").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var v_dev_sign = document.getElementById("s_dev_sign").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"self_num","value":v_self_num});
		obj.push({"label":"license_num","value":v_license_num});
		obj.push({"label":"dev_sign","value":v_dev_sign});
		var dateobj = new Object();
	
		refreshData(obj,dateobj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_self_num").value="";
		document.getElementById("s_license_num").value="";
		document.getElementById("s_dev_sign").value="";
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj,dateobj){
		var userid = '<%=userOrgId%>';
		
		var str = "select t.*,t.dev_coding as erp_id,org.org_abbreviation,";
			str += "usingsd.coding_name as using_stat_desc,";
			str += "techsd.coding_name as tech_stat_desc,";
			str += "accountsd.coding_name as account_stat_desc,oprtbl.operator_name as alloprinfo ";
			str += "from gms_device_account t ";
			str += "left join (select device_account_id,operator_name from ( ";
			str += "select tmp.device_account_id,tmp.operator_name,row_number() ";
			str += "over(partition by device_account_id order by length(operator_name) desc ) as seq " ;
			str += "from (select device_account_id,wmsys.wm_concat(operator_name) ";
			str += "over(partition by device_account_id order by operator_name) as operator_name ";
			str += "from gms_device_equipment_operator where bsflag='0') tmp ) tmp2 where tmp2.seq=1) oprtbl on t.dev_acc_id = oprtbl.device_account_id ";
			str += "left join comm_coding_sort_detail usingsd on t.using_stat=usingsd.coding_code_id ";
			str += "left join comm_coding_sort_detail techsd on t.tech_stat=techsd.coding_code_id ";
			str += "left join comm_coding_sort_detail accountsd on t.account_stat=accountsd.coding_code_id ";
			str += "left join comm_org_information org on t.owning_org_id=org.org_id ";
			str += "where t.bsflag='0'  and t.account_stat!='0110000013000000005' and t.ifproduction='5110000186000000002' and  (t.dev_type like 'S08%' or t.dev_type like 'S09%'  or t.dev_type like 'S07%' or t.dev_type like 'S13%') and t.owning_sub_id like '<%=userOrgId%>%' ";	
			
			for(var key in arrObj) { 
				if(arrObj[key].value!=undefined && arrObj[key].value!=''){
					str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";	
				}
			}
			str += "order by oprtbl.operator_name asc, t.dev_type asc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	var actualOutTime;
    function loadDataDetail(shuaId){
		
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		if(shuaId!=null){
			var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT t where dev_acc_id= '"+shuaId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
			 //retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
			
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT t where dev_acc_id= '"+ids+"'"  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		    // retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+ids);
		}
		
		document.getElementById("dev_acc_name").value =retObj[0].dev_name;
		document.getElementById("dev_acc_sign").value =retObj[0].dev_sign;
		document.getElementById("dev_acc_model").value =retObj[0].dev_model;
		document.getElementById("dev_acc_self").value =retObj[0].self_num;
		document.getElementById("dev_acc_license").value =retObj[0].license_num;
		//document.getElementById("dev_acc_assetcoding").value =retObj[0].asset_coding;
		document.getElementById("dev_acc_erpid").value =retObj[0].erp_id;
		document.getElementById("dev_acc_using_stat").value =retObj[0].using_stat_desc;
		document.getElementById("dev_acc_tech_stat").value =retObj[0].tech_stat_desc;
		document.getElementById("dev_acc_producting_date").value =retObj[0].producting_date;
		document.getElementById("dev_acc_engine_num").value =retObj[0].engine_num;
		document.getElementById("dev_acc_chassis_num").value =retObj[0].chassis_num;
		document.getElementById("dev_acc_asset_stat").value =retObj[0].account_stat_desc;

		actualOutTime = retObj[0].actual_out_time;
		//alert(actualOutTime);
		
		
		document.getElementById("dev_type").value =retObj[0].dev_type;
		if(shuaId==null)
			shuaId = ids;
		loaddata(shuaId,selectedTagIndex);
		
		
    }
	
	
        
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/device-xd/devquery.jsp');
    }
	
	/**
	 * 获取日期
	 * @param {Object} obj
	 */
	function getdate(obj){
    var dev_appdet_id;
	var ye;
	var me;
	var vall=obj.lin.split("&");
	for(var i=0;i<vall.length;i++){
		var temp= vall[i].split("=");
		if(temp[0]=="device_acc_id"){
			dev_appdet_id= temp[1];
		}
		if(temp[0]=="ye"){
			ye= temp[1];
		}
		if(temp[0]=="me"){
			me= temp[1];
		}
	}
    	var querySql="select to_char(a.next_maintain_date,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month,to_char(a.NEXT_MAINTAIN_DATE,'dd') as day,a.* from BGP_COMM_DEVICE_MAINTAIN a where a.device_account_id='"+dev_appdet_id+"' and to_char(a.NEXT_MAINTAIN_DATE,'yyyy')='"+ye+"' and to_char(a.NEXT_MAINTAIN_DATE,'mm')='"+me+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		var basedatas = queryRet.datas;
		calendar2(basedatas);
    }

	
	  /*****************************************************************************************************************************
	   * 公共复选框选择
	   */
	  function setGl2(obj,divid){
		var tableobj = obj.parentNode;
    	$("#"+tableobj.id+">tr:odd>td:odd","#"+divid).css("background-color","#e3e3e3");
		$("#"+tableobj.id+">tr:even>td:odd","#"+divid).css("background-color","#ebebeb");
		$("#"+tableobj.id+">tr:odd>td:even","#"+divid).css("background-color","#f6f6f6");
		$("#"+tableobj.id+">tr:even>td:even","#"+divid).css("background-color","#FFFFFF");
		$("input[type='checkbox']","#"+divid).removeAttr("checked");
    	var columnsObj=obj.cells;
    	columnsObj[0].childNodes[0].checked=true;
    	for(var i=0;i<columnsObj.length;i++){
    		columnsObj[i].style.background="#ffc580";
    	}
    }
	
	/**
	 * 定人定机************************************************************************************************************************
	 */
	function drdj(shuaId){
		if (shuaId != null) {
			var querySql="select to_char(p.create_date,'yyyy-mm-dd') as createdate,p.operator_name,p.change_reason,p.change_file,f.file_name  from GMS_DEVICE_EQUIPMENT_OPERATOR p   left join BGP_DOC_GMS_FILE f on f.file_id=p.change_file where p.fk_dev_acc_id='"+shuaId+"' order by p.create_date desc ";
			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
			
			var size = $("#assign_body", "#tab_box_content1").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content1").children("tr").remove();
			}
			var dj_body1 = $("#assign_body", "#tab_box_content1")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr=dj_body1.insertRow()
					newTr.insertCell().innerText=retObj[i].operator_name;
					newTr.insertCell().innerText=retObj[i].createdate;
					newTr.insertCell().innerText=retObj[i].change_reason;
					var newTd=newTr.insertCell();
					newTd.innerHTML="<a onclick=' toDownload(\""+retObj[i].change_file+"\") ' href='#'/>"+retObj[i].file_name+"</a>";
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content1').addClass("even_even");
	}
	function toDownload(fileid)
	{
		window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+fileid;
	}
	
    //修改界面
     function toEditDJ(obj){  
     	if(obj==undefined){
     		$("input[type='checkbox']", "#djMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/dj.jsp?ids="+ids+"&oil_info_id=111"); 
	  } 
	  function toDeleteDJ(){
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+ids);
				
				queryData(cruConfig.currentPage);
				
			}

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
				//			    alert("请先选中一条记录!");
				return;
			}
		}
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		drdj(ids);
	}

	 //隐藏或显示操作权限按钮(设备所属单位为装备服务处，则隐藏其操作权限按钮)
	 function hideOrShowOperButton(flag,index){
		// 标签页id
		var tabId='';
		
		//定人定机
		if(index==12){
			tabId='tab_box_content12';
		}
		
	 	//操作名称
	 	var operName=['添加','修改','删除','导入'];
	 	if(flag){
		 	if(tabId!=''){
		 		for(var j=0;j<operName.length;j++){
		 			//获取操作标签
		 			var operTag=$("#"+tabId+" a[title='"+operName[j]+"']");
		 			if(operTag){
		 				operTag.hide();
		 			}
		 			
		 		}
		 	}	
		}else{
			if(tabId!=''){
		 		for(var j=0;j<operName.length;j++){
		 			//获取操作标签
		 			var operTag=$("#"+tabId+" a[title='"+operName[j]+"']");
		 			if(operTag){
		 				operTag.show();
		 			}
		 			
		 		}
		 	}	
		}
	 }
	 //根据设备id隐藏操作权限按钮
	 function hideOrShowOperButtonBydevAccId(devAccId,index){
		
	 }
	 
	 function setDE(id){
		 popWindow("<%=contextPath%>/rm/dm/devRun/deviceEquipment/de_edit.jsp?ids="+id.name);  
	 }
	 
</script>

</html>