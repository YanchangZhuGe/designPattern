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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>采集设备模板列表</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">模板名称</td>
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
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddNewModelPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyModelPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelModelPage()'" title="删除"></auth:ListButton>
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
			     <tr id='device_app_id_{model_mainid}' name='model_mainid' idinfo='{model_mainid}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{model_mainid}' id='selectedbox_{model_mainid}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{model_name}">模板名称</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">模板名称：</td>
				      <td  class="inquire_form6" ><input id="model_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">创建单位：</td>
				      <td  class="inquire_form6"><input id="create_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;创建人：</td>
				      <td  class="inquire_form6"  ><input id="creator_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td class="bt_info_odd">序号</td>
				            <td class="bt_info_even">设备名称</td>
				            <td class="bt_info_odd">规格型号</td>		
				            <td class="bt_info_even">计量单位</td>
				            <td class="bt_info_odd">道数</td>
				            <td class="bt_info_even">备注</td>			
				        </tr>
				        <tbody id="detailList" name="detailList" >
				        </tbody>            
			        </table>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					
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
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = " select device_name,device_model,detail.coding_name as unit_name,device_slot_num,remark ";
				str += " from gms_device_collmodel_sub sub "
				str += " left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id ";
				str += " where model_mainid='"+currentid+"' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].device_name+"</td><td>"+datas[i].device_model+"</td>";
			innerHTML += "<td>"+datas[i].unit_name+"</td><td>"+datas[i].device_slot_num+"</td><td>"+datas[i].remark+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function searchDevData(){
		var v_model_name = $("#s_model_name").val();
		refreshData(v_model_name);
	}
	
    function refreshData(v_model_name){
		var str = "select main.model_mainid,main.model_name,create_org_id,org.org_name as create_org_name,main.creator,";
		str += "emp.employee_name as creator_name,main.create_date from gms_device_collmodel_main main ";
		str += "left join comm_org_information org on main.create_org_id=org.org_id ";
		str += "left join comm_human_employee emp on main.creator = emp.employee_id ";
		str += "where main.bsflag='0' ";
		if(v_model_name!=undefined && v_model_name!=''){
			str += "and main.promodel_name like '%"+v_model_name+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(model_mainid){
		var retObj;
		var basedatas;
		//查询基本信息
		var str = "select main.model_mainid,main.model_name,create_org_id,org.org_name as create_org_name,main.creator,";
		str += "emp.employee_name as creator_name,main.create_date from gms_device_collmodel_main main ";
		str += "left join comm_org_information org on main.create_org_id=org.org_id ";
		str += "left join comm_human_employee emp on main.creator = emp.employee_id ";
		str += "where main.bsflag='0' and  main.model_mainid='"+model_mainid+"' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		basedatas = queryRet.datas;
		//回填基本信息
		
		//选中这一条checkbox
		$("#selectedbox_"+basedatas[0].model_mainid).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+basedatas[0].model_mainid+"']").removeAttr("checked");
		//给数据回填
		$("#model_name","#projectMap").val(basedatas[0].model_name);
		$("#create_org_name","#projectMap").val(basedatas[0].create_org_name);
		$("#creator_name","#projectMap").val(basedatas[0].creator_name);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    
    function toAddNewModelPage(){
		popWindow('<%=contextPath%>/rm/dm/collmodel/collModelnew.jsp');
	}
	function toModifyModelPage(){
		var length = 0;
		var model_mainid;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				model_mainid = this.value;
				length = length+1;
			}
		});
		if(length != 1){
			alert("请选择一条记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/collmodel/collModelModify.jsp?model_mainid='+model_mainid);
	}
	function toDelModelPage(){
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
			var sql = "update gms_device_collmodel_main set bsflag='1' where model_mainid in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	} 

</script>
</html>