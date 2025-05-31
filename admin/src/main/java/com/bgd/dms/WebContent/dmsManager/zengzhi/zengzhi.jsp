<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>增值列表</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			   <td class="ali_cdn_name">增值单号</td>
			    <td class="ali_cdn_input">
			    	<input id="valueadd_id" name="valueadd_id" type="text" class="input_width" />
			    </td>
			    	<td class="ali_cdn_name">增值状态：</td>
				  				<td class="ali_cdn_input">
							   		<select id="bsflag" name="bsflag" type="text" class="select_width">
								    	<option value="">请选择</option>
								    	<option value="1">创建</option>
								    	<option value="2">申请</option>
								    	<option value="3">未增值</option>
								    	<option value="4">已增值</option>
								    </select>
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
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='zz_info_id{zz_info_id}' name='zz_info_id' ondblclick='toModifyDetail(this)' idinfo='{zz_info_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{zz_info_id}' id='selectedbox_{zz_info_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{valueadd_id}">增值单号</td>
					<td class="bt_info_even" exp="{valueadd_content}">增值内容</td>
					<!-- <td class="bt_info_even" exp="{isdevice_desc}">增值类型</td> -->
					<td class="bt_info_odd" exp="{amount_money}">增值总金额</td>
					<td class="bt_info_odd" exp="{creater}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">增值日期</td>
					<td class="bt_info_odd" exp="{bsflag_desc}">状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">增值单号：</td>
				      <td  class="inquire_form6" ><input id="valueadd_id" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">增值内容：</td>
				      <td  class="inquire_form6"><input id="valueadd_content" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;增值类型：</td>
				      <td  class="inquire_form6"  ><input id="isdevice_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">增值总金额：</td>
				      <td  class="inquire_form6"><input id="amount_money" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;创建人：</td>
				      <td  class="inquire_form6"  ><input id="creater" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;增值日期</td>
				      <td  class="inquire_form6"  ><input id="create_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				        <tr>
				      <td  class="inquire_item6">增值状态：</td>
				      <td  class="inquire_form6"><input id="baflag_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
					</table>
				</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="5%">序号</td>
							<td class="bt_info_odd" width="8%">设备名称</td>
							<td class="bt_info_even" width="8%">规格型号</td>
							<td class="bt_info_even" width="8%">设备编号</td>
							<td class="bt_info_odd" width="8%">增值金额</td>
							<td class="bt_info_even" width="8%">合同号</td>
							<td class="bt_info_even" width="8%">采购订单号</td>
							<td class="bt_info_even" width="8%">项目编号</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ZzSrv";
	cruConfig.queryOp = "queryzAddList";
	var path = "<%=contextPath%>";


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
	function searchDevData(){
		var valueadd_id = document.getElementById("valueadd_id").value;
		var bsflag = document.getElementById("bsflag").value;
		refreshData(valueadd_id,bsflag);
	}
	function clearQueryText(){
		document.getElementById("valueadd_id").value = "";
		document.getElementById("bsflag").value = "";
		refreshData("","");
	}
    function refreshData(valueadd_id,bsflag){
      	var temp = "";
		if(typeof valueadd_id!="undefined" && valueadd_id!=""){
			temp += "&valueadd_id="+valueadd_id;
		}
		if(typeof bsflag!="undefined" && bsflag!=""){
			temp += "&bsflag="+bsflag;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
    function loadDataDetail(zz_info_id){
		selected_id=zz_info_id;
    	var retObj;
    	retObj = jcdpCallService("ZzSrv", "getzAddInfo", "zz_info_id="+selected_id);
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceMap.zz_info_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceMap.zz_info_id+"']").removeAttr("checked");
		//给数据回填
		$("#valueadd_id","#scrapeMap").val(retObj.deviceMap.valueadd_id);
		$("#valueadd_content","#scrapeMap").val(retObj.deviceMap.valueadd_content);
		$("#bsflag_desc","#scrapeMap").val(retObj.deviceMap.bsflag_desc);
		$("#creater","#scrapeMap").val(retObj.deviceMap.creater);
		$("#create_date","#scrapeMap").val(retObj.deviceMap.create_date);
		$("#amount_money","#scrapeMap").val(retObj.deviceMap.amount_money);
		$("#isdevice_desc","#scrapeMap").val(retObj.deviceMap.isdevice_desc);
		if(selectedTagIndex == 1){
			var baseData;
			retObj = jcdpCallService("ZzSrv", "getzAddDetailInfo", "zz_info_id="+selected_id);
		    basedatas = retObj.datas;
			var filtermapid = "#detailMap";
			$(filtermapid).empty();//先清空
		    if(basedatas!=undefined && basedatas.length>=1){	
			    appendDataToDetailTab(filtermapid,basedatas);
			}
		}
		else if(selectedTagIndex == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+selected_id);
		}
		
    }
    function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox"); 
        
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   
    
    var selectedTagIndex = 0;
	var selected_id = "";//加载数据时，选中记录id
	function getContentTab(obj,index) {
		
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			
			var contentSelectedTag = obj.parentElement;
		} 
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		//$("input[type='checkbox'][name='selectedbox']").each(function(){
		//	if(this.checked){
		//		selected_id = this.value;
		//	}
		//});
		loadDataDetail(selected_id);
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].typbz+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td><td>"+datas[i].valueadd_money+"</td><td>"+datas[i].contract_num+"</td><td><a href='javascript:void(0);' onclick='showInfo("+datas[i].cg_order_num+")'>"+datas[i].cg_order_num+"</a></td><td>"+datas[i].zzzjitem+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	$(document).ready(lashen);
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
    //显示采购订单信息根据计划单号
	function showInfo(order_num){
		popWindow("<%=contextPath%>/dmsManager/purchase/purchase_list.jsp?order_num="+order_num);
	}
</script>
</html>