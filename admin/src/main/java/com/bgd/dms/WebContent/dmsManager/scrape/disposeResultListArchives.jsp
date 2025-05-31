<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dispose_method_id = request.getParameter("dispose_method_id");
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

  <title>报废台账</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData('','','<%=dispose_method_id%>')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			     <td class="ali_cdn_name">处置结果名称</td>
			    <td class="ali_cdn_input">
			    	<input id="dispose_method_name" name="dispose_method_name" type="text" class="input_width" />
			    </td>
			       <td class="ali_cdn_name">处置结果单号</td>
			    <td class="ali_cdn_input">
			    	<input id="dispose_method_no" name="dispose_method_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dispose_method_id{dispose_method_id}' name='dispose_method_id' ondblclick='toModifyDetail(this)' idinfo='{dispose_method_id}'>
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{dispose_method_id}' id='selectedbox_{dispose_method_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dispose_method_name}">报废处置结果名称</td>
					<td class="bt_info_even" exp="{dispose_method_no}">报废处置结果单号</td>
					<td class="bt_info_even" exp="{dispose_date}">处置时间</td>
					<td class="bt_info_even" exp="{dispose_place}">处置地点</td>
					<td class="bt_info_even" exp="{employee_name}">操作人</td>
					<td class="bt_info_odd" exp="{org_name}">操作单位</td>
					<td class="bt_info_even" exp="{check_date}">操作时间</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">处置结果</a></li>
			  </ul>
			</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">处置结果单号：</td>
				      <td  class="inquire_form6" ><input id="dispose_method_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">处置结果名称：</td>
				      <td  class="inquire_form6"><input id="dispose_method_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;操作单位：</td>
				      <td  class="inquire_form6"  ><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				    <tr>
				      <td  class="inquire_item6">处置时间：</td>
				      <td  class="inquire_form6" ><input id="dispose_date" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">处置地点：</td>
				      <td  class="inquire_form6"><input id="dispose_place" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;操作人：</td>
				      <td  class="inquire_form6"  ><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">操作时间：</td>
				      <td  class="inquire_form6"><input id="check_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
					</table>
				</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd">序号</td>
				          <td class="bt_info_even">资产编码</td>
					      <td class="bt_info_odd">设备编号</td>
					      <td class="bt_info_even">设备名称</td>
					      <td class="bt_info_odd">规格型号</td>
					      <td class="bt_info_even">牌照号</td>
					      <td class="bt_info_odd">启用时间</td>
					      <td class="bt_info_even">折旧年限</td>
					      <td class="bt_info_odd">事业部</td>
					      <td class="bt_info_even">经理部</td>
					      <td class="bt_info_odd">部门/小队</td>
					      <td class="bt_info_even">数量</td>
					      <td class="bt_info_odd">原值</td>
					      <td class="bt_info_even">累计折旧</td>
					      <td class="bt_info_odd">减值准备</td>
					      <td class="bt_info_even">净额</td>
					      <td class="bt_info_odd">报废原因</td>
					      <td class="bt_info_even">责任单位</td>
							<td class="bt_info_even" width="5%">报废日期</td>
							<td class="bt_info_even" width="5%">处置日期</td>
							<td class="bt_info_even" width="5%">处置方式</td>
							<td class="bt_info_even" width="5%">公司公文批号</td>
							<td class="bt_info_even" width="10%">备注</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
					<div id="tab_box" class="tab_box">
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content">
					<iframe width="100%" height="100%" name="attachementResult" id="attachementResult" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				
</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "queryDisposeResultList";
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
		var dispose_method_no = document.getElementById("dispose_method_no").value;
		var dispose_method_name = document.getElementById("dispose_method_name").value;
		refreshData(dispose_method_name, dispose_method_no,'');
	}
	function clearQueryText(){
		 document.getElementById("dispose_method_no").value="";
		 document.getElementById("dispose_method_name").value="";
		refreshData("", "",'');
	}
 function refreshData(dispose_method_name, dispose_method_no,dispose_method_id){
      	var temp = "";
		if(typeof dispose_method_name!="undefined" && dispose_method_name!=""){
			temp += "&dispose_method_name="+dispose_method_name;
		}
		if(typeof dispose_method_no!="undefined" && dispose_method_no!=""){
			temp += "&dispose_method_no="+dispose_method_no;
		}
		if(typeof dispose_method_id!="undefined" && dispose_method_id!=""){
			temp += "&dispose_method_id="+dispose_method_id;
		}
		cruConfig.submitStr = temp;	
		queryData(1);

	}
	
	function loadDataDetail(dispose_method_id){
    	var retObj;
		if(dispose_method_id!=null){
			 retObj = jcdpCallService("ScrapeSrv", "getDisposeMethodInfo", "dispose_method_id="+dispose_method_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("ScrapeSrv", "getDisposeMethodInfo", "dispose_method_id="+ids);
		}
	
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceMap.dispose_method_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceMap.dispose_method_id+"']").removeAttr("checked");
		//给数据回填
		$("#dispose_method_no","#scrapeMap").val(retObj.deviceMap.dispose_method_no);
		$("#dispose_method_name","#scrapeMap").val(retObj.deviceMap.dispose_method_name);
		$("#check_date","#scrapeMap").val(retObj.deviceMap.check_date);
		$("#dispose_date","#scrapeMap").val(retObj.deviceMap.dispose_date);
		$("#dispose_place","#scrapeMap").val(retObj.deviceMap.dispose_place);
		$("#employee_name","#scrapeMap").val(retObj.deviceMap.employee_name);
		$("#org_name","#scrapeMap").val(retObj.deviceMap.org_name);
			//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
	
    }
      function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");  
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    } 
    function toAddDisposePage(){
		popWindow('<%=contextPath%>/dmsManager/scrape/disposeResultAdd.jsp');
	}
	function toModifyDisposePage(){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
	popWindow('<%=contextPath%>/dmsManager/scrape/disposeResultAdd.jsp?dispose_method_id='+ids);
	}
	
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
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
			var retObj;
		   retObj = jcdpCallService("ScrapeSrv", "getDisposeResultInfo", "dispose_method_id="+ids);
		   basedatas = retObj.datas;
		  	$(filtermapid).empty();
		   if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
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
		
		
		if(index == 2){//由参与人员改成处置结果
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
			$("#attachementResult").attr("src","<%=contextPath%>/dmsManager/scrape/disposeResultAddForEmp.jsp?dispose_method_id="+ids);
		   
		}
		
		<%-- else if(index == 3){//附件不需要
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		} --%>
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_type+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td>";
			innerHTML += "<td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].producting_date+"</td>";
			innerHTML += "<td>"+datas[i].dev_date+"</td>";
			innerHTML += "<td>"+datas[i].org_name+"</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>1</td>";
			innerHTML += "<td>"+datas[i].asset_value+"</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>"+datas[i].net_value+"</td>";
			if(datas[i].scrape_type=="0"){
				innerHTML += "<td>正常报废</td>";
			}else if(datas[i].scrape_type=="1"){
				innerHTML += "<td>技术淘汰</td>";
			}else if(datas[i].scrape_type=="2"){
				innerHTML += "<td>毁损</td>";
			}else if(datas[i].scrape_type=="3"){
				innerHTML += "<td>盘亏</td>";
			}
			innerHTML += "<td>/</td>";
			innerHTML += "<td>"+datas[i].scrape_date+"</td>";
			innerHTML += "<td>"+datas[i].handle_date+"</td>";
			innerHTML += "<td>"+datas[i].dispose_method_type+"</td>";
			innerHTML += "<td>"+datas[i].batch_number+"</td>";
			innerHTML += "<td>"+datas[i].bak1+"</td></tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function appendDataToDetailTab1(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].name+"</td><td>"+datas[i].org_name+"</td>";
			innerHTML += "<td>"+datas[i].position+"</td></tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	$(document).ready(lashen);
</script>

</html>