<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	String projectType = request.getParameter("projectType")==null?"":request.getParameter("projectType");
	String deviceaddappid = request.getParameter("deviceaddappid")==null?"":request.getParameter("deviceaddappid"); //补充配置计划主表ID
	String deviceallappid = request.getParameter("deviceallappid")==null?"":request.getParameter("deviceallappid");//配置计划主表ID
	String teamtype = request.getParameter("teamtype")==null?"":request.getParameter("teamtype");
	String resourceFlag = request.getParameter("resourceFlag")==null?"":request.getParameter("resourceFlag");
	String mid=request.getParameter("mid")==null?"":request.getParameter("mid");    //中间表id
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
		<div id="tag-container_4" style="float:left">
		  <ul id="tags" class="tags">
		    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">单台管理</a></li>
		    <!-- <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">批量管理</a></li> -->
		  </ul>
		</div>
		<div id="oprdiv0" name="oprdiv" style="float:left;width:70%;overflow:auto;">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ><input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          			<input name="device_addapp_id" id="device_addapp_id" type="hidden" value="<%=deviceaddappid%>" />
          			<input name="device_allapp_id" id="device_allapp_id" type="hidden" value="<%=deviceallappid%>" />
          			<input name="teamtype" id="teamtype" type="hidden" value="<%=teamtype%>" /></td>
			  		<td class="ali_cdn_input" ></td>
			    	<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加按台管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除按台管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="xz" event="onclick='downloadModel(\"dev_model\",\"单台设备配置计划模板\")'" title="下载excel模板"></auth:ListButton>
			    	<auth:ListButton functionId="" css="dr" event="onclick='exportInData()'" title="导入excel模板"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv0" name="resultdiv" style="float:left;height:220px;">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
		       		<td class="bt_info_even"><input type="checkbox" name="alldetinfo" id="alldetinfo" /></td>
					<!-- <td class="bt_info_odd" width="16%">班组</td> -->
					<td class="bt_info_even" width="25%">设备名称</td>
					<td class="bt_info_odd" width="16%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="7%">需求数量</td>
					<td class="bt_info_even" width="13%">开始时间</td>
					<td class="bt_info_odd" width="13%">结束时间</td>
					<td class="bt_info_even" width="20%">备注</td>
				</tr>
		      </table>
		      <div style="height:183px;overflow:auto;">
		      	<table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
		  </div>
		  <div id="oprdiv1" name="oprdiv" style="float:left;width:70%;overflow:auto;display:none">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ><a href="javascript:downloadModel('coll_model','采集设备配置计划模板')">采集设备配置计划模板</a></td>
			  		<auth:ListButton functionId="" css="dr" event="onclick='exportCollData()'" title="导入excel"></auth:ListButton>
			    	<auth:ListButton functionId="" css="zj" event="onclick='addCollRows()'" title="添加按量管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delCollRows()'" title="删除按量管理设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv1" name="resultdiv" style="float:left;height:210px;overflow:auto;display:none">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
		       		<td class="bt_info_even"><input type="checkbox" name="colldetinfo" id="colldetinfo" /></td>
					<td class="bt_info_odd" width="16%">班组</td>
					<td class="bt_info_even" width="17%">设备名称</td>
					<td class="bt_info_odd" width="16%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="7%">需求道数</td>
					<td class="bt_info_even" width="13%">开始时间</td>
					<td class="bt_info_odd" width="13%">结束时间</td>
					<td class="bt_info_even" width="11%">用途</td>
				</tr>
			   <tbody id="processtable1" name="processtable" >
			   </tbody>
		      </table>
		  </div>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
var projectInfoNo="<%=projectInfoNo%>";
var deviceallappid="<%=deviceallappid%>";
var projectType="<%=projectType%>";
var mid="<%=mid%>";
$().ready(function(){
	$("#alldetinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
$().ready(function(){
	$("#colldetinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='collidinfo']").attr('checked',checkvalue);
	});
});
function downloadModel(modelname,filename){
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	var file="";
	if("5000100004000000009"==projectType){//综合物化探
		file="/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+"ZH.xls";
	}else{
		file="/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".xls";
	}
	window.location.href="<%=contextPath%>"+file+"&filename="+filename+".xls";
}
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
	function getContentTab(obj,index) {
		$("LI","#tag-container_4").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
		//给关联的按钮给隐藏
		var oprfilterobj = "div[name='oprdiv'][id='oprdiv"+index+"']";
		var oprfilternotobj = "div[name='oprdiv'][id!='oprdiv"+index+"']";
		$(oprfilternotobj).hide();
		$(oprfilterobj).show();
		//给结果区的数据DIV进行控制
		var resfilterobj = "div[name='resultdiv'][id='resultdiv"+index+"']";
		var resfilternotobj = "div[name='resultdiv'][id!='resultdiv"+index+"']";
		$(resfilternotobj).hide();
		$(resfilterobj).show();
	}
	function addRows(value){
		if(value!="" && value !=undefined){
			var trData = value.split(",");
			for(var i=0;i<trData.length;i++){
			var innerhtml = "";
			var teamName;
			var unit;
			var tdData = trData[i].split("@");
			teamName = tdData[0];
			unit = tdData[3];
			innerhtml += "<tr id='tr"+i+"' name='tr"+i+"' seq='"+i+"'>";
			innerhtml += "<td ><input type='checkbox' name='idinfo' id='"+i+"'/></td>";
			//innerhtml += "<td width='16%'><select name='team"+i+"' id='team"+i+"' /></select></td>";
			
			innerhtml += "<td width='25%'><input name='devicename"+i+"' id='devicename"+i+"' style='line-height:15px' value='"+tdData[1]+"' size='15' type='text' />";
			innerhtml += "<td width='16%'><input name='devicetype"+i+"' id='devicetype"+i+"' value='"+tdData[2]+"' size='16'  type='text' /></td>";
			innerhtml += "<td width='7%'><select name='unit"+i+"' id='unit"+i+"' /></select></td>";
			innerhtml += "<td width='7%'><input name='neednum"+i+"' id='neednum"+i+"' value='"+tdData[4]+"' size='4' type='text' onkeyup='checkAppNum(this,\"approvenum"+i+"\")'/>";
			//综合物化探 项目资源配置中 审批数量
			innerhtml += "<input name='approvenum"+i+"' id='approvenum"+i+"' value='"+tdData[4]+"' size='4' type='hidden'/></td>";
			
			innerhtml += "<td width='13%'><input name='startdate"+i+"' id='startdate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[5]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+i+",tributton2"+i+");'/></td>";
			innerhtml += "<td width='13%'><input name='enddate"+i+"' id='enddate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[6]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+i+",tributton3"+i+");'/></td>";
			innerhtml += "<td width='20%'><input name='purpose"+i+"' value='"+tdData[7]+"' size='10' type='text'/></td>";
			
			innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
				/**
				//查询公共代码，并且回填到界面的单位中
				var teamObj;
				var teamSql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and t.coding_mnemonic_id='"+projectType+"' and length(t.coding_code) <= 2";
				var teamRet = syncRequest('Post',''+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
				teamObj = teamRet.datas;
				var teamoptionhtml = "";
				for(var index=0;index<teamObj.length;index++){
					if(teamObj[index].label == teamName){
						teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"' selected>"+teamObj[index].label+"</option>";
						}
					else{
						teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
					}
				}
				$("#team"+i).append(teamoptionhtml);*/
				//查询公共代码，并且回填到界面的单位中
				var retObj;
				var unitSql = "select sd.coding_code_id,coding_name ";
				unitSql += "from comm_coding_sort_detail sd "; 
				unitSql += "where coding_sort_id ='5110000038' order by coding_code";
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
				retObj = unitRet.datas;
				var optionhtml = "";
				for(var index=0;index<retObj.length;index++){
					if(retObj[index].coding_name ==unit){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
						}
					else{
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
						}
				}
					$("#unit"+i).append(optionhtml);
			}
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
			}
		else{
			tr_id = $("#processtable0>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<td ><input type='checkbox' name='idinfo' id='"+tr_id+"'/></td>";
			//innerhtml += "<td width='16%'><select name='team"+tr_id+"' id='team"+tr_id+"' /></select></td>";
			
			innerhtml += "<td width='25%'><input name='devicename"+tr_id+"' id='devicename"+tr_id+"' style='line-height:15px' value='' size='15' type='text' />";
			innerhtml += "</td>";
			
			innerhtml += "<td width='16%'><input name='devicetype"+tr_id+"' id='devicetype"+tr_id+"' value='' size='16'  type='text' />";
			innerhtml += "<input name='signtype"+tr_id+"' id='signtype"+tr_id+"' value='' type='hidden' />";
			innerhtml += "<input name='isdevicecode"+tr_id+"' id='isdevicecode"+tr_id+"' value='' type='hidden' /></td>";
			
			innerhtml += "<td width='7%'><select name='unit"+tr_id+"' id='unit"+tr_id+"' /></select></td>";
			innerhtml += "<td width='7%'><input name='neednum"+tr_id+"' id='neednum"+tr_id+"' value='' size='4' type='text' onkeyup='checkAppNum(this,\"approvenum"+tr_id+"\")'/>";
			//综合物化探 项目资源配置中 审批数量
			innerhtml += "<input type='hidden' id='approvenum"+tr_id+"' name='approvenum"+tr_id+"'></td>";
			
			innerhtml += "<td width='13%'><input name='startdate"+tr_id+"' id='startdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+tr_id+",tributton2"+tr_id+");'/></td>";
			innerhtml += "<td width='13%'><input name='enddate"+tr_id+"' id='enddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+tr_id+",tributton3"+tr_id+");'/></td>";
			innerhtml += "<td width='20%'><input name='purpose"+tr_id+"' value='' size='10' type='text'/></td>";
			innerhtml += "</tr>";
			
			$("#processtable0").append(innerhtml);
			/**
			//查询公共代码，并且回填到界面的单位中
			var teamObj;
			var teamSql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and t.coding_mnemonic_id='"+projectType+"' and length(t.coding_code) <= 2";
			var teamRet = syncRequest('Post',''+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
			var teamoptionhtml = "";
			for(var index=0;index<teamObj.length;index++){
				teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
			}
			$("#team"+tr_id).append(teamoptionhtml);*/
			//查询公共代码，并且回填到界面的单位中
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#unit"+tr_id).append(optionhtml);
			
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		}
	};
	function delRows(){
		$("input[name='idinfo']").each(function(){
			if(this.checked){
				$('#tr'+this.id,"#processtable0").remove();
			}
		});
		
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	function addCollRows(value){
		if(value!="" && value !=undefined){
			var trData = value.split(",");
			for(var i=0;i<trData.length;i++){
				//var teamName;
				var devType;
				var unit;
				var tdData = trData[i].split("@");
				//teamName = tdData[0];
				devType = tdData[2];
				unit = tdData[3];
				var innerhtml = "<tr id='tr"+i+"' name='tr"+i+"' collseq='"+i+"'>";
				
				innerhtml += "<td><input type='checkbox' name='collidinfo' id='"+i+"'/></td>";
				//innerhtml += "<td><select name='collteam"+i+"' id='collteam"+i+"' /></select></td>";
				
				innerhtml += "<td><input name='colldevicename"+i+"' id='colldevicename"+i+"' style='line-height:15px' value='"+tdData[1]+"' size='15' type='text' /></td>";
				
				innerhtml += "<td><select name='colldevicetype"+i+"' id='colldevicetype"+i+"' class='select_width' ></selcted></td>";
				
				innerhtml += "<td><select name='collunit"+i+"' id='collunit"+i+"' /></select></td>";
				innerhtml += "<td><input name='collneednum"+i+"' id='collneednum"+i+"' class='input_width' value='"+tdData[4]+"' size='10' type='text' onkeyup='checkAppNum(this,\"collapprovenum"+i+"\")'/>";
				//综合物化探 项目资源配置中 审批数量
				innerhtml += "<input name='collapprovenum"+i+"' id='collapprovenum"+i+"' value='"+tdData[4]+"' size='4' type='hidden'/></td>";
				
				innerhtml += "<td><input name='collstartdate"+i+"' id='collstartdate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[5]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton2"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collstartdate"+i+",colltributton2"+i+");'/></td>";
				innerhtml += "<td><input name='collenddate"+i+"' id='collenddate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[6]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton3"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collenddate"+i+",colltributton3"+i+");'/></td>";
				innerhtml += "<td><input name='collpurpose"+i+"' class='input_width' value='"+tdData[7]+"' size='10' type='text'/></td>";
				innerhtml += "</tr>";
				
				$("#processtable1").append(innerhtml);

				var colltypeObj;
				var colltypeSql = "select t.coding_code_id as value,t.coding_name as label ";
				colltypeSql += "from comm_coding_sort_detail t "; 
				colltypeSql += "where t.coding_sort_id='5110000031' and t.bsflag='0' order by t.coding_show_id";
				var colltypeRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+colltypeSql+'&pageSize=1000');
				colltypeObj = colltypeRet.datas;
				var colltypeoptionhtml = "";
				for(var index=0;index<colltypeObj.length;index++){
					if(colltypeObj[index].label ==devType){
						colltypeoptionhtml +=  "<option name='colltypecode' id='colltypecode"+index+"' value='"+colltypeObj[index].value+"' selected>"+colltypeObj[index].label+"</option>";
						}
					else{
						colltypeoptionhtml +=  "<option name='colltypecode' id='colltypecode"+index+"' value='"+colltypeObj[index].value+"'>"+colltypeObj[index].label+"</option>";
						}
				}
				$("#colldevicetype"+i).append(colltypeoptionhtml);
				/**
				//查询公共代码，并且回填到界面的班组中
				var teamObj;
				var teamSql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and t.coding_mnemonic_id='"+projectType+"' and length(t.coding_code) <= 2";
				var teamRet = syncRequest('Post',''+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
				teamObj = teamRet.datas;
				var teamoptionhtml = "";
				for(var index=0;index<teamObj.length;index++){
					if(teamObj[index].label == teamName){
						teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"' selected>"+teamObj[index].label+"</option>";
					}
				else{

					teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
					}
				}
				$("#collteam"+i).append(teamoptionhtml);*/
				//查询公共代码，并且回填到界面的单位中
				var retObj;
				var unitSql = "select sd.coding_code_id,coding_name ";
				unitSql += "from comm_coding_sort_detail sd "; 
				unitSql += "where coding_sort_id ='5110000038' and coding_name='道' ";
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
				retObj = unitRet.datas;
				var optionhtml = "";
				for(var index=0;index<retObj.length;index++){
					if(retObj[index].coding_name == unit){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
					}
				else{
					optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
					}
				}
				$("#collunit"+i).append(optionhtml);
				
				}
			$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable1>tr:odd>td:even").addClass("odd_even");
			$("#processtable1>tr:even>td:odd").addClass("even_odd");
			$("#processtable1>tr:even>td:even").addClass("even_even");
			}
		else{
			tr_id = $("#processtable1>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
			
			innerhtml += "<td><input type='checkbox' name='collidinfo' id='"+tr_id+"'/></td>";
			//innerhtml += "<td><select name='collteam"+tr_id+"' id='collteam"+tr_id+"' /></select></td>";
			
			innerhtml += "<td><input name='colldevicename"+tr_id+"' id='colldevicename"+tr_id+"' style='line-height:15px' value='用户输入名称' size='15' type='text' /></td>";
			
			innerhtml += "<td><select name='colldevicetype"+tr_id+"' id='colldevicetype"+tr_id+"' class='select_width' ></selcted></td>";
			
			innerhtml += "<td><select name='collunit"+tr_id+"' id='collunit"+tr_id+"' /></select></td>";
			innerhtml += "<td><input name='collneednum"+tr_id+"' id='collneednum"+tr_id+"' class='input_width' value='' size='10' type='text' onkeyup='checkAppNum(this,\"collapprovenum"+tr_id+"\")'/>";
			//综合物化探 项目资源配置中 审批数量
			innerhtml += "<input type='hidden' id='collapprovenum"+tr_id+"' name='collapprovenum"+tr_id+"'></td>";

			innerhtml += "<td><input name='collstartdate"+tr_id+"' id='collstartdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collstartdate"+tr_id+",colltributton2"+tr_id+");'/></td>";
			innerhtml += "<td><input name='collenddate"+tr_id+"' id='collenddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collenddate"+tr_id+",colltributton3"+tr_id+");'/></td>";
			innerhtml += "<td><input name='collpurpose"+tr_id+"' class='input_width' value='' size='10' type='text'/></td>";
			innerhtml += "</tr>";
			
			$("#processtable1").append(innerhtml);
			//查询公共代码，并且回填到界面的申请类型中
			var colltypeObj;
			var colltypeSql = "select t.coding_code_id as value,t.coding_name as label ";
			colltypeSql += "from comm_coding_sort_detail t "; 
			colltypeSql += "where t.coding_sort_id='5110000031' and t.bsflag='0' order by t.coding_show_id";
			var colltypeRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+colltypeSql+'&pageSize=1000');
			colltypeObj = colltypeRet.datas;
			var colltypeoptionhtml = "";
			for(var index=0;index<colltypeObj.length;index++){
				colltypeoptionhtml +=  "<option name='colltypecode' id='colltypecode"+index+"' value='"+colltypeObj[index].value+"'>"+colltypeObj[index].label+"</option>";
			}
			$("#colldevicetype"+tr_id).append(colltypeoptionhtml);
			/**
			//查询公共代码，并且回填到界面的班组中
			var teamObj;
			var teamSql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and t.coding_mnemonic_id='"+projectType+"' and length(t.coding_code) <= 2";
			var teamRet = syncRequest('Post',''+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
			var teamoptionhtml = "";
			for(var index=0;index<teamObj.length;index++){
				teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
			}
			$("#collteam"+tr_id).append(teamoptionhtml);*/
			//查询公共代码，并且回填到界面的单位中
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' and coding_name='道' ";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#collunit"+tr_id).append(optionhtml);
			
			$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable1>tr:odd>td:even").addClass("odd_even");
			$("#processtable1>tr:even>td:odd").addClass("even_odd");
			$("#processtable1>tr:even>td:even").addClass("even_even");
		}
	};
	function delCollRows(){
		$("input[name='collidinfo']").each(function(){
			if(this.checked){
				$('#tr'+this.id,"#processtable1").remove();
			}
		});
		
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
	};
	function checkAppNum(obj,approveobj){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("调配数量必须为数字，且大于0!");
			obj.value = "";
		}
		//综合物化探 审批自动填写审批数量
		//if("5000100004000000009"==projectType){
			document.getElementById(approveobj).value=obj.value;
		//}
	}
	function submitInfo(){
		var obj_ =  jcdpCallService("WtProjectSrv", "getProjectDep","projectInfoNo="+projectInfoNo);
		var businessType = "";
		if(obj_.project_department!=null){
			var pro_dep = obj_.project_department;
			if(pro_dep=="C6000000000124"){
				businessType = "5110000004100001019";
			}
			if(pro_dep=="C6000000004707"){
				businessType = "5110000004100001016";
			}
			if(pro_dep=="C6000000005592"){
				businessType = "5110000004100001022";
			}
			if(pro_dep=="C6000000005594"){
				businessType = "5110000004100001024";
			}
			if(pro_dep=="C6000000005595"){
				businessType = "5110000004100001023";
			}
			if(pro_dep=="C6000000005605"){
				businessType = "5110000004100001021";
			}
		}
		
		
		var numflag = "1";
		$("input[type='text'][name^='devicename']").each(function(){
			if(this.value == ""){
				numflag = "12";
				return;
			}
		});
		if(numflag == "12"){
			alert("请选择设备名称和规格型号!");
			return false;
		}
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		$("input[type='text'][name^='neednum']").each(function(){
			if(this.value == ""){
				numflag = "2";
				return;
			}else if(!re.test(this.value)){
				numflag = "3";
				return;
			}
		});
		if(numflag == "3"){
			alert("调配数量必须为数字，且大于0!");
			$("input[type='text'][name^='neednum']").each(function(){
				if(!re.test(this.value)){
					this.value = "";
				}
			});
        	return false;
		}else if(numflag == "2"){
			alert("调配数量不能为空!");
        	return false;
		}
		//数字没啥问题，检查开始和结束时间
		var startdateflag;
		var datere = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
		$("input[type='text'][name^='startdate']").each(function(){
			var str=(this.value).replace(/(\s*$)/g,"");//删除右边的空格
			if(""==str){
				startdateflag = "2";
				return;
			}else if(!datere.test(str)){
				startdateflag = "3";
				return;
			}
		});
		var enddateflag;
		$("input[type='text'][name^='enddate']").each(function(){
			str=(this.value).replace(/(\s*$)/g,"");//删除右边的空
			if(""==str){
				enddateflag = "2";
				return;
			}else if(!datere.test(str)){
				enddateflag = "3";
				return;
			}
		});
		if(startdateflag == "3"){
			alert("计划开始时间格式错误，请检查所有日期字段!");
			return;
		}
		if(enddateflag == "3"){
			alert("计划结束时间格式错误，请检查所有日期字段!");
			return;
		}
		//保留按台的行信息
		var count = 0;
		var line_infos = '';
		$("tr","#processtable0").each(function(){
			if(this.seq!=undefined){
				if(count == 0){
					line_infos = this.seq;
				}else{
					line_infos = line_infos+"~"+this.seq;
				}
				count++;
			}
		});
		//检查按量管理的所有的数量字段 
		$("input[type='text'][name^='collneednum']").each(function(){
			if(this.value == ""){
				numflag = "2";
				return;
			}else if(!re.test(this.value)){
				numflag = "3";
				return;
			}
		});
		if(numflag == "3"){
			alert("调配数量必须为数字，且大于0!");
			$("input[type='text'][name^='collneednum']").each(function(){
				if(!re.test(this.value)){
					this.value = "";
				}
			});
        	return false;
		}else if(numflag == "2"){
			alert("调配数量不能为空!");
        	return false;
		}
		//数字没啥问题，检查按量管理的开始和结束时间
		$("input[type='text'][name^='collstartdate']").each(function(){
			if(this.value == ""){
				startdateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				startdateflag = "3";
				return;
			}
		});
		var enddateflag;
		$("input[type='text'][name^='collstartdate']").each(function(){
			if(this.value == ""){
				enddateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				enddateflag = "3";
				return;
			}
		});
		if(startdateflag == "3"){
			alert("计划开始时间格式错误，请检查所有日期字段!");
			return;
		}
		if(enddateflag == "3"){
			alert("计划结束时间格式错误，请检查所有日期字段!");
			return;
		}
		//保留按量的行信息
		var collcount = 0;
		var collline_infos = '';
		$("tr","#processtable1").each(function(){
			if(this.collseq!=undefined){
				if(collcount == 0){
					collline_infos = this.collseq;
				}else{
					collline_infos = collline_infos+"~"+this.collseq;
				}
				collcount++;
			}
		});
		if(count == 0 && collcount == 0){
			alert('请添加设备申请明细！');
			return;
		}
		
		
		//--------------------------------生成设备补充配置主表ID retObj.device_addapp_id---------------------------------------------
		var querySql = "select allapp.device_allapp_id,allapp.device_allapp_no,allapp.device_allapp_name,allapp.appdate as allappdate,";
		querySql += "pro.project_name,to_char(sysdate,'yyyy-mm-dd') as currentdate,org.org_name,emp.employee_name ";
		querySql += "from gms_device_allapp allapp  ";
		querySql += "left join gp_task_project pro on allapp.project_info_no=pro.project_info_no ";
		querySql += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.project_info_no and allwfmiddle.business_type='"+businessType+"' ";
		querySql += "left join comm_org_information org on allapp.org_id = org.org_id  ";
		querySql += "left join comm_human_employee emp on allapp.employee_id = emp.employee_id ";
		querySql += "where allapp.bsflag = '0' and  allapp.project_info_no='"+projectInfoNo+"' ";
		querySql += " and allwfmiddle.proc_status='3' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		basedatas = queryRet.datas;
		debugger;
		var params="&projectInfoNo="+projectInfoNo;
		//params+="&project_name="+projectName;
		params+="&device_allapp_no="+basedatas[0].device_allapp_no;
		params+="&device_allapp_name="+basedatas[0].device_allapp_name;
		params+="&device_addapp_name='补充设备配置计划'";//+document.getElementById("device_addapp_name").value;//配置补充计划单名称
		params+="&device_addapp_no=";//配置补充计划单号
		params+="&allappdate="+basedatas[0].allappdate;
		document.getElementById("device_allapp_id").value=basedatas[0].device_allapp_id;
		params+="&device_allapp_id="+basedatas[0].device_allapp_id;
		params+="&appdate="+basedatas[0].currentdate;
		params+="&org_id=<%=user.getOrgId()%>";  
		params+="&org_name=<%=user.getOrgName()%>";  
		params+="&employee_id=<%=user.getEmpId()%>";
		params+="&employee_name=<%=user.getUserName()%>"; 
		params+="&state=0";
		params+="&mid="+mid;
		var retObj = jcdpCallService("DevCommInfoSrv","saveDevAllAddAppBaseInfoZh",params);
		var device_addapp_id=retObj.device_addapp_id
		document.getElementById("device_addapp_id").value=device_addapp_id;
		
		
		var params = $("#form1").serialize();
		params+="&resourceFlag=<%=resourceFlag%>&bsflag=0";
		params+="&count="+count;
		params+="&line_infos="+line_infos;
		params+="&collcount="+collcount;
		params+="&collline_infos="+collline_infos;
		//params+="&device_allapp_id="+deviceallappid;

		var retObj = jcdpCallService("DevCommInfoSrv","saveDevAllAddAppDetailInfo",params);
		alert("保存成功");
		//top.frames[5].refreshData();
		// top.frames('list').frames('mainRightframe').test(12,123);
		
		// top.frames('list').frames('mainRightframe').refreshData(projectInfoNo);
		 //top.frames('list').frames('mainLeftframe').toshow();
		 //alert(top.frames.lenth);//.toshow();  
			//newClose();
		//
		window.returnValue=device_addapp_id;
		window.window.close();
	}

	
	function showDevPage(trid){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp",obj);
		if(obj.name!=undefined){
			//var returnvalues = vReturnValue.split('~',-1);
			//alert(vReturnValue)
			if(obj.name.indexOf("(")>0){
				var name = obj.name;
				var devicename = name.substr(0,(name.indexOf('(')-name.indexOf(':')-1));
				var devicetype = name.substr(name.indexOf('(')+1,(name.indexOf(')')-name.indexOf('(')-1));
				$("input[name='devicename"+trid+"']","#processtable0").val(devicename);
				$("input[name='devicetype"+trid+"']","#processtable0").val(devicetype);
			}else{
				$("input[name='devicename"+trid+"']","#processtable0").val(obj.name);
				$("input[name='devicetype"+trid+"']","#processtable0").val("");
			}
			$("input[name='signtype"+trid+"']","#processtable0").val(obj.code);
			$("input[name='isdevicecode"+trid+"']","#processtable0").val(obj.isdevicecode);
			/*
			var devicename = returnvalues[0].substr(returnvalues[0].indexOf(':')+1,(returnvalues[0].indexOf('(')-returnvalues[0].indexOf(':')-1));
			var devicetype = returnvalues[0].substr(returnvalues[0].indexOf('(')+1,(returnvalues[0].indexOf(')')-returnvalues[0].indexOf('(')-1));
			var deviceCode = returnvalues[1].substr(returnvalues[1].indexOf(':')+1,(returnvalues[1].length-returnvalues[1].indexOf(':')));
			$("input[name='devicename"+trid+"']","#processtable0").val(devicename);
			$("input[name='devicetype"+trid+"']","#processtable0").val(devicetype);
			$("input[name='signtype"+trid+"']","#processtable0").val(deviceCode);
			*/
		}
	}
	function refreshData(){
	}
	
	function exportInData(){
		 var obj=window.showModalDialog('<%=contextPath%>/rm/dm/devPlan/devdetailExcelAdd.jsp',"","dialogHeight:500px;dialogWidth:600px");
			obj = decodeURI(obj,'UTF-8');
			obj = decodeURI(obj,'UTF-8');
			 if(obj!="" && obj!=undefined ){
				 addRows(obj);
			 }			
		}
	function exportCollData(){
		 var obj=window.showModalDialog('<%=contextPath%>/rm/dm/devPlan/devdetailExcelAdd.jsp',"","dialogHeight:500px;dialogWidth:600px");
			obj = decodeURI(obj,'UTF-8');
			obj = decodeURI(obj,'UTF-8');
			 if(obj!="" && obj!=undefined ){
				 addCollRows(obj);
			 }			
		}
</script>
</html>

