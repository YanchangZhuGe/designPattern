<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
  <title>转资列表</title>
 </head>
 <body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			   <td class="ali_cdn_name">转资单号</td>
			    <td class="ali_cdn_input">
			    	<input id="zz_no" name="zz_no" type="text" class="input_width" />
			    </td>
			    	<td class="ali_cdn_name">转资状态：</td>
				  		<td class="ali_cdn_input">
							 <select id="zz_state" name="zz_state" type="text" class="select_width">
							      <option value="">请选择</option>
								  <option value="1">创建</option>
								  <option value="2">申请</option>
								  <option value="3">未转资</option>
								  <option value="4">已转资</option>
							 </select>
						</td>			    
			    <td class="ali_query">
			    	<span class="cx"><a href="####" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="####" onclick="clearQueryText()" title="清除"></a></span>
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
			     <tr id='zz_id{zz_id}' name='zz_id' ondblclick='toModifyDetail(this)' idinfo='{zz_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{zz_id}' id='selectedbox_{zz_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{zz_no}">转资单号</td>
					<td class="bt_info_even" exp="{zz_num}">转资台数</td>
					<td class="bt_info_odd" exp="{zz_money}">转资总金额</td>
					<td class="bt_info_even" exp="{batch_plan}">批次计划</td>
					<td class="bt_info_odd" exp="{creator}">创建人</td>
					<td class="bt_info_even" exp="{org_name}">转资机构</td>
					<td class="bt_info_odd" exp="{lifnr_name}">供应商名称</td>
					<td class="bt_info_even" exp="{zz_date}">转资日期</td>
					<td class="bt_info_odd" exp="{zz_state_desc}">状态</td>
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
			    <li id="tag3_1"><a href="####" onclick="getContentTab(this,1)">明细信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:1px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">转资单号：</td>
				      <td  class="inquire_form6" ><input id="zz_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">转资台数：</td>
				      <td  class="inquire_form6"><input id="zz_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;转资总金额：</td>
				      <td  class="inquire_form6"  ><input id="zz_money" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
				    <tr>
				      <td  class="inquire_item6">&nbsp;批次计划：</td>
				      <td  class="inquire_form6"  ><input id="batch_plan" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;创建人：</td>
				      <td  class="inquire_form6"  ><input id="creator" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">转资机构：</td>
				      <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				     <tr>
				       <td  class="inquire_item6">&nbsp;供应商名称：</td>
				       <td  class="inquire_form6"  ><input id="lifnr_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				       <td  class="inquire_item6">&nbsp;转资日期：</td>
				       <td  class="inquire_form6"  ><input id="zz_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				       <td  class="inquire_item6">转资状态：</td>
				       <td  class="inquire_form6"><input id="zz_state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
					</table>
				</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:1px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="3%">序号</td>
							<td class="bt_info_odd" width="9%">设备名称</td>
							<td class="bt_info_even" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">设备编号</td>
							<td class="bt_info_odd" width="5%">投产日期</td>
							<td class="bt_info_even" width="10%">购置金额</td>
				        </tr>
					</table>
					<div style="height:70%;overflow:auto;">
				      	<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   		<tbody id="detailMap" name="detailMap" >
					   		</tbody>
				      	</table>
			        </div>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ZzSrv";
	cruConfig.queryOp = "queryZzList";
	var path = "<%=contextPath%>";


function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
	refreshData();
})	
	function searchDevData(){
		var zz_no = document.getElementById("zz_no").value;
		var zz_state = document.getElementById("zz_state").value;
		refreshData(zz_no,zz_state);
	}
	function clearQueryText(){
		document.getElementById("zz_no").value = "";
		document.getElementById("zz_state").value = "";
		refreshData("","","");
	}
    function refreshData(zz_no,zz_state){
      	var temp = "";
		if(typeof zz_no!="undefined" && zz_no!=""){
			temp += "&zz_no="+zz_no;
		}
		if(typeof zz_state!="undefined" && zz_state!=""){
			temp += "&zz_state="+zz_state;
		}
		temp += "&flag=1&fromPage=0";
		cruConfig.submitStr = temp;	
		queryData(1);
	}
    function loadDataDetail(zz_id){
		selected_id=zz_id;
    	var retObj;
		retObj = jcdpCallService("ZzSrv", "getZzInfo", "zz_id="+selected_id);
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceMap.zz_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceMap.zz_id+"']").removeAttr("checked");
		//给数据回填
		$("#zz_no","#scrapeMap").val(retObj.deviceMap.zz_no);
		$("#zz_state_desc","#scrapeMap").val(retObj.deviceMap.zz_state_desc);
		$("#zz_money","#scrapeMap").val(retObj.deviceMap.zz_money);
		$("#zz_num","#scrapeMap").val(retObj.deviceMap.zz_num);
		$("#batch_plan","#scrapeMap").val(retObj.deviceMap.batch_plan);
		$("#creator","#scrapeMap").val(retObj.deviceMap.creator);
		$("#org_name","#scrapeMap").val(retObj.deviceMap.org_name);
		$("#lifnr_name","#scrapeMap").val(retObj.deviceMap.lifnr_name);
		$("#zz_date","#scrapeMap").val(retObj.deviceMap.zz_date);
		if(selectedTagIndex == 1){
			var baseData;
			retObj = jcdpCallService("ZzSrv", "getZzDetailInfo", "zz_id="+selected_id);
			basedatas = retObj.datas;
			var filtermapid = "#detailMap";
			$(filtermapid).empty();//先清空
			if(basedatas!=undefined && basedatas.length>=1){
				appendDataToDetailTab(filtermapid,basedatas);
			}
		}
		if(selectedTagIndex == 3){
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
			contentSelectedTag.className ="selectTag";
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
		//对标题行的宽度进行设置
		aligntitle("#detailtitletable","#detailMap");
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].eqktx+"</td><td>"+datas[i].typbz+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td><td>"+datas[i].inbdt+"</td><td>"+datas[i].answt+"</td>";
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
    
</script>
</html>