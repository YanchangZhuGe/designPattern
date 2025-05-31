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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>设备编码流程归属列表</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">设备编码</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_code" name="s_dev_ci_code" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">流程模板类型</td>
			    <td class="ali_cdn_input">
			    	<input id="s_model_name" name="s_model_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddOwnershipPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyOwnershipPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelOwnershipPage()'" title="删除"></auth:ListButton>
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
			     <tr id='device_app_id_{device_app_id}' name='device_app_id' ondblclick='toModifyDetail(this)' idinfo='{device_app_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dc_ownship_id}' id='selectedbox_{dc_ownship_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_ci_code}">设备编码</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_odd" exp="{promodel_name}">流程模板类型</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备编码：</td>
				      <td  class="inquire_form6" ><input id="dev_ci_code" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">设备名称：</td>
				      <td  class="inquire_form6"><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;规格型号：</td>
				      <td  class="inquire_form6"  ><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
				    <tr>
				      <td  class="inquire_item6">流程模板类型：</td>
				      <td  class="inquire_form6" ><input id="procmodel_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6"></td>
				      <td  class="inquire_form6">&nbsp;</td>
				      <td  class="inquire_item6"></td>
				      <td  class="inquire_form6"></td>
				     </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
				</div>
				<div id="tab_box_content2" name="tab_box_content3" class="tab_box_content" style="display:none">
					<table id="approveList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>模板名称</td>
				            <td>序号</td>
				            <td>序号</td>		
				            <td>审批情况</td>
				            <td>审批意见</td>			
				            <td>审批人</td> 
				            <td>审批时间</td>			
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content3" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content4" name="tab_box_content2" class="tab_box_content" style="display:none">
					
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
	
	function searchDevData(){
		var v_dev_ci_code = $("#s_dev_ci_code").val();
		var v_model_name = $("#s_model_name").val();
		refreshData(v_dev_ci_code,v_model_name);
	}
	
    function refreshData(v_dev_ci_code,v_model_name){
		var str = "select dc_ownship_id,dev_ci_code,dev_ci_name,dev_ci_model,promodel_name,promodel_id from gms_device_codeos ";
		if(v_dev_ci_code!=undefined && v_dev_ci_code!=''){
			str += "and dev_ci_code = '"+v_dev_ci_name+"' ";
		}
		if(v_model_name!=undefined && v_model_name!=''){
			str += "and promodel_name like '"+v_model_name+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(dc_ownship_id){
    	var retObj;
		if(dc_ownship_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevCodeOSInfo", "dcownshipid="+dc_ownship_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevCodeOSInfo", "dcownshipid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.devownshipMap.dc_ownship_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devownshipMap.dc_ownship_id+"']").removeAttr("checked");
		//给数据回填
		$("#dev_ci_code","#projectMap").val(retObj.devownshipMap.dev_ci_code);
		$("#dev_ci_name","#projectMap").val(retObj.devownshipMap.dev_ci_name);
		$("#dev_ci_model","#projectMap").val(retObj.devownshipMap.dev_ci_model);
		$("#procmodel_name","#projectMap").val(retObj.devownshipMap.promodel_name);
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
    
    function toAddOwnershipPage(){
		popWindow('<%=contextPath%>/rm/dm/ownership/ownership_new.jsp');
	}
	function toModifyOwnershipPage(){
		var length = 0;
		var selectedid = "";
		var deviceappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				deviceappid = this.value;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devmixPlan/mixplan_modify.jsp?deviceappid='+deviceappid);
	}
	function toDelOwnershipPage(){
		var length = 0;
		var selectedid = "";
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
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_app set bsflag='1' where device_app_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	} 

</script>
</html>