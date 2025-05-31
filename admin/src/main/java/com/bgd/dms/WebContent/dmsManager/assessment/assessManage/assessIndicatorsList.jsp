<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
  <title>考核指标</title>
 </head>
 <body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">指标名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_assess_name" name="s_assess_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="####" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddNewAssessPage()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyAssessPage()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelAssessPage()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{assess_mainid}' id='selectedbox_{assess_mainid}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{assess_name}">指标名称</td>
					<td class="bt_info_even" exp="{create_org_name}">创建单位</td>
					<td class="bt_info_odd" exp="{creator_name}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="####" onclick="getContentTab(this,0)">基本信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="assessMainMap" name="assessMainMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">指标名称：</td>
				      <td  class="inquire_form6" ><input id="s_assess_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">创建单位：</td>
				      <td  class="inquire_form6"><input id="s_create_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;创建人：</td>
				      <td  class="inquire_form6"><input id="s_creator_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
				    <tr>
				      <td  class="inquire_item6">设备类型：</td>
				      <td  class="inquire_form6" ><input id="s_dev_type" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">资产状况：</td>
				      <td  class="inquire_form6"><input id="s_account_stat" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">生产设备：</td>
				      <td  class="inquire_form6"><input id="s_ifproduction" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
				    <tr>
				      <td  class="inquire_item6">国内/国外：</td>
				      <td  class="inquire_form6"><input id="s_ifcountry" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">指标值上限：</td>
				      <td  class="inquire_form6"><input id="s_assess_ceiling" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">指标值下限：</td>
				      <td  class="inquire_form6"><input id="s_assess_floor" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.61);
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});	

$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DeviceAssessInfoSrv";
	cruConfig.queryOp = "queryAssessList";
	
	function searchDevData(){
		var v_assess_name = $("#s_assess_name").val();
		refreshData(v_assess_name);
	}

	function clearQueryText(){
		$("#s_assess_name").val("");
	}
	
    function refreshData(v_assess_name){
        var str="";
		if(v_assess_name!=undefined && v_assess_name!=''){
			str += "&assess_name="+v_assess_name;
		}
		cruConfig.submitStr = str;
		queryData(1);
	}
	
    refreshData("");
    
    function loadDataDetail(assess_mainid){
    	var retObj;
		if(assess_mainid!=null){
			 retObj = jcdpCallService("DeviceAssessInfoSrv", "getAssessBaseInfo", "assessmainid="+assess_mainid);			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DeviceAssessInfoSrv", "getAssessBaseInfo", "assessmainid="+assess_mainid);
		}
		//选中这一条
		$("#selectedbox_"+retObj.assessMainMap.assess_mainid).attr("checked","checked");
		//给数据回填
		$("#s_assess_name","#assessMainMap").val(retObj.assessMainMap.assess_name);
		$("#s_create_org_name","#assessMainMap").val(retObj.assessMainMap.create_org_name);
		$("#s_creator_name","#assessMainMap").val(retObj.assessMainMap.creator_name);
		$("#s_dev_type","#assessMainMap").val(retObj.assessMainMap.dev_type_name);
		$("#s_account_stat","#assessMainMap").val(retObj.assessMainMap.account_stat_name);
		$("#s_ifproduction","#assessMainMap").val(retObj.assessMainMap.ifproduction_name);
		$("#s_ifcountry","#assessMainMap").val(retObj.assessMainMap.ifcountry_name);
		$("#s_assess_ceiling","#assessMainMap").val(retObj.assessMainMap.assess_ceiling);
		$("#s_assess_floor","#assessMainMap").val(retObj.assessMainMap.assess_floor);
    }
    
    function toAddNewAssessPage(){
		popWindow('<%=contextPath%>/dmsManager/assessment/assessManage/assessIndi_new.jsp','800:480','-新增指标信息');
	}
	function toModifyAssessPage(){
		var length = 0;
		var assess_mainid;
		$("input[type='radio'][name='selectedbox']").each(function(){
			if(this.checked){
				assess_mainid = this.value;
				length = length+1;
			}
		});
		if(length != 1){
			alert("请选择一条记录！");
			return;
		}
		popWindow('<%=contextPath%>/dmsManager/assessment/assessManage/assessIndi_up.jsp?assess_mainid='+assess_mainid,'800:480','-修改指标信息');
	}
	function toDelAssessPage(){
		var length = 0;
		var selectedid="";
		$("input[type='radio'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var retObj = jcdpCallService("DeviceAssessSrv", "delAssessInfo", "delassessmainid="+selectedid);
			refreshData();
		}
	} 

</script>
</html>