<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
    String devicebackinfoid = request.getParameter("id");
    
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>配置计划申请</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="v_dev_name" name="v_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="v_dev_model" name="v_dev_model" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toSumbitDevApp()'" title="验收"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="JCDP_btn_back"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_backapp_id}' name='device_backapp_id'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_backdet_id}' recstate='{isleaving}' id='selectedbox_{device_backdet_id}' />" >选择</td><!-- <input type='checkbox' name='selectedbox' id='selectedbox' onclick='check()'/></td> -->
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="可控震源">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_coding}">AMIS资产编号</td>
					<td class="bt_info_odd" exp="{dev_position}">存放地</td>
					<td class="bt_info_even" exp="{stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{isleaving}">验收状态</td>
					<td class="bt_info_even" exp="{check_time}">验收时间</td>
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
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">AMIS资产编号：</td>
				      <td   class="inquire_form6" ><input id="dev_coding" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">&nbsp;设备名称：</td>
				      <td  class="inquire_form6"  ><input id="dev_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">规格型号：</td>
				     <td  class="inquire_form6"><input id="dev_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">&nbsp;自编号：</td>
				     <td  class="inquire_form6"><input id="self_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">实物标识号：</td>
				     <td  class="inquire_form6"><input id="dev_sign" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;牌照号：</td>
				     <td  class="inquire_form6"><input id="license_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				    </tr>
				    
				    <tr>
				     <td  class="inquire_item6">资产状况：</td>
				     <td  class="inquire_form6"><input id="stat_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td class="inquire_item6">实际进场时间</td>
					 <td class="inquire_form6"><input id="actual_in_time" name="actual_in_time" class="input_width" type="text" /></td>
					 <td class="inquire_item6">计划离场时间</td>
					 <td class="inquire_form6"><input id="planning_out_time" name="planning_out_time" class="input_width" type="text" /></td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					
				</div>
			    <div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none">
					
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
		$(filternotobj).hide();
		$(filterobj).show();
	}

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	//全选
	var checked = false;
	 function check(){
	 		var chk = document.getElementsByName("selectedbox");
	 		for(var i = 0; i < chk.length; i++){ 
	 			if(!checked){ 
	 				chk[i].checked = true; 
	 			}
	 			else{
	 				chk[i].checked = false;
	 			}
	 		} 
	 		if(checked){
	 			checked = false;
	 		}
	 		else{
	 			checked = true;
	 		}
	 	}
	
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    var dev_acc_id="";
    function loadDataDetail(devaccid){
    	var retObj;
		if(devaccid!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getStockDetailInfo", "devbackid="+devaccid);
			 
		}else{
			var ids = getSelIds('selectedbox');
			
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getStockDetailInfo", "devbackid="+ids.split(",")[0]);
		}
		//取消选中框--------------------------------------------------------------------------
    	//var obj = document.getElementsByName("selectedbox");  
	   //     for (i=0; i<obj.length; i++){   
	    //        obj[i].checked = false;   
	             
	    //    } 
		//选中这一条checkbox
		//$("#selectedbox_"+retObj.devStockMap.device_backdet_id).attr("checked","checked");
		//------------------------------------------------------------------------------------
		document.getElementById("dev_coding").value =retObj.devStockMap.dev_coding;
		document.getElementById("dev_name").value =retObj.devStockMap.dev_name;
		document.getElementById("dev_model").value =retObj.devStockMap.dev_model;
		document.getElementById("self_num").value =retObj.devStockMap.self_num;
		document.getElementById("dev_sign").value =retObj.devStockMap.dev_sign;
		document.getElementById("license_num").value =retObj.devStockMap.license_num;
		document.getElementById("stat_desc").value =retObj.devStockMap.stat_desc;
		document.getElementById("actual_in_time").value =retObj.devStockMap.actual_in_time;
		document.getElementById("planning_out_time").value =retObj.devStockMap.planning_out_time;
		dev_acc_id=retObj.devStockMap.dev_acc_id;
		
    }

	function searchDevData(){
		var v_dev_name = document.getElementById("v_dev_name").value;
		var v_dev_model = document.getElementById("v_dev_model").value;
		refreshData(v_dev_name, v_dev_model);
	}
	function refreshData(v_dev_name,v_dev_model){
		var str = "select backdet.*,dui.dev_name,dui.dev_model,dui.check_time,sd.coding_name as stat_desc, ";
		str += "case backdet.state when '0' then '未验收' when '1' then '已验收' end as isleaving ";
		str += "from gms_device_backapp_detail backdet ";
		str += "left join gms_device_account_dui dui on backdet.dev_acc_id=dui.dev_acc_id ";
		str += "left join comm_coding_sort_detail sd on dui.account_stat=sd.coding_code_id ";
		//回头给这个C105006 换成 orgsubid
		str += "where backdet.device_backapp_id='<%=devicebackinfoid%>' ";
		//补充查询条件
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and dui.dev_name = '"+v_dev_name+"' ";
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "and dui.dev_model = '"+v_dev_model+"' ";
		}
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	function toSumbitDevApp(){
		var ids = getSelIds('selectedbox');  
	  	if(ids==''){
	  		alert("请选择一条记录!");
	  		return;
	  	}
	  	selId = ids.split(','); 
	  	var idss = "";
		var querysql = "select * from gms_device_backapp_detail det where det.state = '1' ";
			querysql += "and det.device_backdet_id in (";		
			for(var i=0;i<selId.length;i++){
				if(idss!="") idss += ",";
				idss += "'"+selId[i]+"'";
			}
		querysql = querysql+idss+")";
		
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql+'&pageSize=1000');
		var basedatas = queryRet.datas;
		
		if(basedatas.length == 0){
			popWindow('<%=contextPath%>/rm/dm/kkzy/stockinSubmit.jsp?id='+selId,'800:680');
		}else{
			alert("存在已验收的设备！");
			return;
		}	  
	}
	function dbclickRow(shuaId){
		toSumbitDevApp();
	}
	function toBack(){
		window.location.href='stockinMainInfoList.jsp';
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
</script>
</html>