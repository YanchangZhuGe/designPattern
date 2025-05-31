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
  <title>考核指标列表</title>
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
			    	<input id="s_select_org" name="s_select_org" type="hidden" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="####" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="####" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddOrgAssessPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyOrgAssessPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelOrgAssessPage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
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
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{assess_id}' id='selectedbox_{assess_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{wtc_org_name}">单位名称</td>
					<td class="bt_info_even" exp="{assess_name}">指标名称</td>
					<td class="bt_info_odd" exp="{assess_value}">指标权重</td>
					<td class="bt_info_even" exp="{assess_org_ceiling}">指标值上限</td>
					<td class="bt_info_odd" exp="{assess_org_floor}">指标值下限</td>
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
					<table id="assessMap" name="assessMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
					  <td  class="inquire_item6">单位名称：</td>
				      <td  class="inquire_form6" ><input id="s_org_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">指标名称：</td>
				      <td  class="inquire_form6" ><input id="s_assess_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">指标权重：</td>
				      <td  class="inquire_form6" ><input id="s_assess_value" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				    </tr>
				    <tr>
				    <td  class="inquire_item6">指标值上限：</td>
				      <td  class="inquire_form6"><input id="s_assess_org_ceiling" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">指标值下限：</td>
				      <td  class="inquire_form6" ><input id="s_assess_org_floor" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">创建单位：</td>
				      <td  class="inquire_form6"><input id="s_create_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>				      
				     </tr>
				     <tr>
				     <td  class="inquire_item6">&nbsp;创建人：</td>
				      <td  class="inquire_form6"><input id="s_creator_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;创建时间：</td>
				      <td  class="inquire_form6"  ><input id="s_create_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;备注：</td>
				      <td  class="inquire_form6"  ><input id="s_remark" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
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
	cruConfig.queryOp = "queryOrgAssessList";
	var path = "<%=contextPath%>";
	
	function searchDevData(){
		var v_assess_name = $("#s_assess_name").val();
		refreshData("",v_assess_name);
	}

	function clearQueryText(){
		$("#s_assess_name").val("");
	}
	
    function refreshData(v_assess_name,fkValue){
        var str="";
		if(v_assess_name!=undefined && v_assess_name!=''){
			str += "&assess_name="+v_assess_name;
		}
		if(fkValue!=undefined && fkValue!=''){
			str += "&assess_org_id="+fkValue;
		}
		document.getElementById("s_select_org").value=fkValue;
		cruConfig.submitStr = str;
		queryData(1);
	}
	
    refreshData("", "");
    
    function loadDataDetail(assess_id){
    	var retObj;
		if(assess_id!=null){
			 retObj = jcdpCallService("DeviceAssessInfoSrv", "getOrgAssessBaseInfo", "assessid="+assess_id);			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DeviceAssessInfoSrv", "getOrgAssessBaseInfo", "assessid="+assess_id);
		}

		//给数据回填
		$("#s_org_name","#assessMap").val(retObj.assessOrgList[0].wtc_org_name);
		$("#s_assess_name","#assessMap").val(retObj.assessOrgList[0].assess_name);
		$("#s_assess_value","#assessMap").val(retObj.assessOrgList[0].assess_value);
		$("#s_create_org_name","#assessMap").val(retObj.assessOrgList[0].create_org_name);
		$("#s_creator_name","#assessMap").val(retObj.assessOrgList[0].creator_name);
		$("#s_create_date","#assessMap").val(retObj.assessOrgList[0].create_date);
		$("#s_remark","#assessMap").val(retObj.assessOrgList[0].remark);
		$("#s_assess_org_ceiling","#assessMap").val(retObj.assessOrgList[0].assess_org_ceiling);
		$("#s_assess_org_floor","#assessMap").val(retObj.assessOrgList[0].assess_org_floor);
    }
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    
    function toAddOrgAssessPage(){
        var selectorg = $("#s_select_org").val();
		popWindow('<%=contextPath%>/dmsManager/assessment/assessSetOrg/assessOrg_new.jsp?selectorg='+selectorg,'850:480');
	}
	function toModifyOrgAssessPage(){
		var ids = getSelIds('selectedbox');
		var selectorg = $("#s_select_org").val();
	  	if(ids==''){
	  		alert("请选择一条记录!");
	  		return;
	  	}
		popWindow('<%=contextPath%>/dmsManager/assessment/assessSetOrg/assessOrg_up.jsp?assessids='+ids+'&selectorg='+selectorg,'800:480');
	}
	function toDelOrgAssessPage(){
		var selectorg = $("#s_select_org").val();
		var length = 0;
		var selectedid="";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
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
			var retObj = jcdpCallService("DeviceAssessSrv", "delOrgAssessInfo", "delassessid="+selectedid);
			refreshData("",selectorg);
		}
	}

</script>
</html>