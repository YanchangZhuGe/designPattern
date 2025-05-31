<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
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
  <title>已添加的返还明细页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddPage()'" title="添加"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='javascript:window.history.back();'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_backdet_id{device_backdet_id}' name='device_backdet_id'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_backdet_id}' id='selectedbox_{device_backdet_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{unit_name}">单位</td>
					<td class="bt_info_odd" exp="{back_num}">返还数量</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">在队数量</td>
					<td class="bt_info_odd" exp="{actual_in_time}">实际进场时间</td>
					<td class="bt_info_even" exp="{planning_out_time}">实际离场时间</td>
					<td class="bt_info_odd" exp="{devremark}">备注</td>
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
			    
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="detailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备名称：</td>
				      <td  class="inquire_form6" ><input id="dev_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">规格型号：</td>
				      <td  class="inquire_form6"><input id="dev_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;单位：</td>
				      <td  class="inquire_form6"  ><input id="dev_unit" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">返还数量：</td>
				     <td  class="inquire_form6"><input id="back_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;总数量：</td>
				     <td  class="inquire_form6"><input id="total_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">在队数量：</td>
				     <td  class="inquire_form6"><input id="unuse_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				    <td  class="inquire_item6">离队数量：</td>
				     <td  class="inquire_form6"><input id="use_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">实际进场时间：</td>
				     <td  class="inquire_form6"><input id="actual_in_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;实际离场时间：</td>
				     <td  class="inquire_form6"><input id="planning_out_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6"></td>
				     <td  class="inquire_form6"></td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
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
	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
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
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';

	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	
	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select backdet.*,unitsd.coding_name as unit_name, ";
		str += "account.dev_unit,account.total_num,account.unuse_num,account.use_num,account.actual_in_time ";
		str += "from gms_device_collbackapp_detail backdet ";
		str += "left join gms_device_coll_account_dui account on backdet.dev_acc_id = account.dev_acc_id ";
		str += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
		str += "where backdet.device_backapp_id='<%=devicebackappid%>' ";
		str += " and backdet.bsflag='0'";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and account.dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and account.dev_model like '"+v_dev_ci_model+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		
	}
</script>
<script type="text/javascript">	
	//打开新增界面
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/backdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid=<%=devicebackappid%>','1050:680');
	}
	//打开修改界面
	function toModifyPage(){
		var length = 0;
		var selectedid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length!=1){
			alert("请选择一条记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/backdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid=<%=devicebackappid%>&devicebackdetids='+selectedid,'1050:680');
	}
	function dbclickRow(shuaId){
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/backdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid=<%=devicebackappid%>&devicebackdetids='+shuaId,'1050:680');
	}
	function toDelRecord(){
		var length = 0;
		var selectedid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
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
		if(confirm("一共选择了"+length+"条记录，是否执行删除？")){
			var sql = "update gms_device_collbackapp_detail set bsflag='1' where device_backdet_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(device_backdet_id){
    	var retObj;
    	var devicebackdetid;
		if(device_backdet_id!=null){
			devicebackdetid = device_backdet_id;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    devicebackdetid = ids;
		}
		var str = "select backdet.*, ";
		str += "account.dev_unit,account.total_num,account.unuse_num,account.use_num,account.actual_in_time,unitsd.coding_name as unit_name ";
		str += "from gms_device_collbackapp_detail backdet ";
		str += "left join gms_device_coll_account_dui account on backdet.dev_acc_id = account.dev_acc_id ";
		str += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
		str += "where backdet.device_backdet_id='"+devicebackdetid+"'";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		
		$("#dev_name","#detailMap").val(retObj[0].dev_name);
		$("#dev_model","#detailMap").val(retObj[0].dev_model);
		$("#dev_unit","#detailMap").val(retObj[0].unit_name);
		$("#back_num","#detailMap").val(retObj[0].back_num);
		$("#total_num","#detailMap").val(retObj[0].total_num);
		$("#unuse_num","#detailMap").val(retObj[0].unuse_num);
		$("#use_num","#detailMap").val(retObj[0].use_num);
		
		$("#actual_in_time","#detailMap").val(retObj[0].actual_in_time);
		$("#planning_out_time","#detailMap").val(retObj[0].planning_out_time);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	
</script>
</html>