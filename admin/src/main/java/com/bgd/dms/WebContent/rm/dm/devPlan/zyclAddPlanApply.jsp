<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//String projectInfoNo = request.getParameter("projectInfoNo");
	//String deviceaddappid = request.getParameter("deviceaddappid");
	//String deviceallappid = request.getParameter("deviceallappid");
	//String taskId = request.getParameter("taskId");
	//String taskName = new String(request.getParameter("taskName").getBytes("ISO-8859-1"),"utf-8");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String zcflag = request.getParameter("zcFlag");
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
     <fieldset style="margin-left:2px"><legend >申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="<%=user.getProjectName() %>" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="" />
          </td>
           <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请人:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="<%=user.getUserName() %>" readonly/>
          </td>
          <td class="inquire_item4" >申请单位名称:</td>
          <td class="inquire_form4" >
          	<input name="app_org" id="app_org" class="input_width" type="text"  value="<%=user.getOrgName() %>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请时间:</td>
          <td class="inquire_form4" >
          	<input name="app_date" id="app_date" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >工序:</td>
          <td class="inquire_form4" >
          	<input name="jobname" id="jobname" class="input_width" type="text"  value="<%=user.getProjectName()%>" readonly/>
          </td>
         </tr> 
      </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>设备计划信息</legend>
		<div id="tag-container_4" style="float:left">
		  <ul id="tags" class="tags">
		  <% if(zcflag!=null&&!"".equals(zcflag)&&"Z".equals(zcflag)){ %>
		    	<li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">可控震源</a></li>
		   <% }else{%>
		   		<li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">测量仪器</a></li>
		   <%} %>
		  </ul>
		</div>
		<div id="oprdiv0" name="oprdiv" style="float:left;width:70%;overflow:auto;">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td>&nbsp;</td>
			    	<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv0" name="resultdiv" style="float:left;height:220px;">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
		       		<td class="bt_info_even"><input type="checkbox" name="alldetinfo" id="alldetinfo" /></td>
					<td class="bt_info_odd" width="16%">班组</td>
					<td class="bt_info_even" width="17%">设备名称</td>
					<td class="bt_info_odd" width="16%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="7%">需求数量</td>
					<td class="bt_info_even" width="13%">开始时间</td>
					<td class="bt_info_odd" width="13%">结束时间</td>
					<td class="bt_info_even" width="11%">用途</td>
				</tr>
		      </table>
		      <div style="height:183px;overflow:auto;">
		      	<table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
		  </div>
		</fieldset>
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
var zcflag = '<%=zcflag%>';
var projectType="<%=projectType%>";
function downloadModel(modelname,filename){
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".xls&filename="+filename+".xls";
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
			innerhtml += "<td width='16%'><select name='team"+i+"' id='team"+i+"' /></select></td>";
			
			innerhtml += "<td width='17%'><input name='devicename"+i+"' id='devicename"+i+"' style='line-height:15px' value='"+tdData[1]+"' size='15' type='text' />";
			innerhtml += "<td width='16%'><input name='devicetype"+i+"' id='devicetype"+i+"' value='"+tdData[2]+"' size='16'  type='text' /></td>";
			innerhtml += "<td width='7%'><select name='unit"+i+"' id='unit"+i+"' /></select></td>";
			innerhtml += "<td width='7%'><input name='neednum"+i+"' id='neednum"+i+"' value='"+tdData[4]+"' size='4' type='text' onkeyup='checkAppNum(this)'/></td>";
			innerhtml += "<td width='13%'><input name='startdate"+i+"' id='startdate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[5]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+i+",tributton2"+i+");'/></td>";
			innerhtml += "<td width='13%'><input name='enddate"+i+"' id='enddate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[6]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+i+",tributton3"+i+");'/></td>";
			innerhtml += "<td width='11%'><input name='purpose"+i+"' value='"+tdData[7]+"' size='10' type='text'/></td>";
			
			innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
				//查询公共代码，并且回填到界面的单位中
				var teamObj;
				var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
					teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
					if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
						//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
						teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
					}else{
						teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
					}
					teamSql += "order by t.coding_show_id ";
				var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
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
				$("#team"+i).append(teamoptionhtml);
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
			innerhtml += "<td width='16%'><select name='team"+tr_id+"' id='team"+tr_id+"' /></select></td>";
			
			innerhtml += "<td width='17%'><input name='devicename"+tr_id+"' id='devicename"+tr_id+"' style='line-height:15px' value='' size='15' type='text' />";
			innerhtml += "</td>";
			
			innerhtml += "<td width='16%'><input name='devicetype"+tr_id+"' id='devicetype"+tr_id+"' value='' size='16'  type='text' />";
			innerhtml += "<input name='signtype"+tr_id+"' id='signtype"+tr_id+"' value='' type='hidden' />";
			innerhtml += "<input name='isdevicecode"+tr_id+"' id='isdevicecode"+tr_id+"' value='' type='hidden' /></td>";
			
			innerhtml += "<td width='7%'><select name='unit"+tr_id+"' id='unit"+tr_id+"' /></select></td>";
			innerhtml += "<td width='7%'><input name='neednum"+tr_id+"' id='neednum"+tr_id+"' value='' size='4' type='text' onkeyup='checkAppNum(this)'/></td>";
			innerhtml += "<td width='13%'><input name='startdate"+tr_id+"' id='startdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+tr_id+",tributton2"+tr_id+");'/></td>";
			innerhtml += "<td width='13%'><input name='enddate"+tr_id+"' id='enddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+tr_id+",tributton3"+tr_id+");'/></td>";
			innerhtml += "<td width='11%'><input name='purpose"+tr_id+"' value='' size='10' type='text'/></td>";
			innerhtml += "</tr>";
			
			$("#processtable0").append(innerhtml);
			//查询公共代码，并且回填到界面的单位中
			var teamObj;
			var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
				teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
				if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
					//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
					teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
				}else{
					teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
				}
				teamSql += "order by t.coding_show_id ";
			var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
			var teamoptionhtml = "";
			for(var index=0;index<teamObj.length;index++){
				teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
			}
			$("#team"+tr_id).append(teamoptionhtml);
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
				var teamName;
				var devType;
				var unit;
				var tdData = trData[i].split("@");
				teamName = tdData[0];
				devType = tdData[2];
				unit = tdData[3];
				var innerhtml = "<tr id='tr"+i+"' name='tr"+i+"' collseq='"+i+"'>";
				
				innerhtml += "<td><input type='checkbox' name='collidinfo' id='"+i+"'/></td>";
				innerhtml += "<td><select name='collteam"+i+"' id='collteam"+i+"' /></select></td>";
				
				innerhtml += "<td><input name='colldevicename"+i+"' id='colldevicename"+i+"' style='line-height:15px' value='"+tdData[1]+"' size='15' type='text' /></td>";
				
				innerhtml += "<td><select name='colldevicetype"+i+"' id='colldevicetype"+i+"' class='select_width' ></selcted></td>";
				
				innerhtml += "<td><select name='collunit"+i+"' id='collunit"+i+"' /></select></td>";
				innerhtml += "<td><input name='collneednum"+i+"' id='collneednum"+i+"' class='input_width' value='"+tdData[4]+"' size='10' type='text' onkeyup='checkAppNum(this)'/></td>";
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
				//查询公共代码，并且回填到界面的班组中
				var teamObj;
				var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
					teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
					if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
						//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
						teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
					}else{
						teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
					}
					teamSql += "order by t.coding_show_id ";
				var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
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
				$("#collteam"+i).append(teamoptionhtml);
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
			innerhtml += "<td><select name='collteam"+tr_id+"' id='collteam"+tr_id+"' /></select></td>";
			
			innerhtml += "<td><input name='colldevicename"+tr_id+"' id='colldevicename"+tr_id+"' style='line-height:15px' value='用户输入名称' size='15' type='text' /></td>";
			
			innerhtml += "<td><select name='colldevicetype"+tr_id+"' id='colldevicetype"+tr_id+"' class='select_width' ></selcted></td>";
			
			innerhtml += "<td><select name='collunit"+tr_id+"' id='collunit"+tr_id+"' /></select></td>";
			innerhtml += "<td><input name='collneednum"+tr_id+"' id='collneednum"+tr_id+"' class='input_width' value='' size='10' type='text' onkeyup='checkAppNum(this)'/></td>";
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
			//查询公共代码，并且回填到界面的班组中
			var teamObj;
			var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
				teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
				if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
					//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
					teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
				}else{
					teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
				}
				teamSql += "order by t.coding_show_id ";
			var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
			var teamoptionhtml = "";
			for(var index=0;index<teamObj.length;index++){
				teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
			}
			$("#collteam"+tr_id).append(teamoptionhtml);
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
	function checkAppNum(obj){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("调配数量必须为数字，且大于0!");
			obj.value = "";
		}
	}
	function submitInfo(){
		if(confirm("确认提交？")){
			alert("提交成功!");
			newClose();
			return;			
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
			if(this.value == ""){
				startdateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				startdateflag = "3";
				return;
			}
		});
		var enddateflag;
		$("input[type='text'][name^='enddate']").each(function(){
			if(this.value == ""){
				enddateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				enddateflag = "3";
				return;
			}
		});
		if(startdateflag == "2"){
			alert("计划开始时间不能为空，请检查所有日期字段!");
			return;
		}else if(startdateflag == "3"){
			alert("计划开始时间格式错误，请检查所有日期字段!");
			return;
		}
		if(enddateflag == "2"){
			alert("计划结束时间不能为空，请检查所有日期字段!");
			return;
		}else if(enddateflag == "3"){
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
		if(startdateflag == "2"){
			alert("计划开始时间不能为空，请检查所有日期字段!");
			return;
		}else if(startdateflag == "3"){
			alert("计划开始时间格式错误，请检查所有日期字段!");
			return;
		}
		if(enddateflag == "2"){
			alert("计划结束时间不能为空，请检查所有日期字段!");
			return;
		}else if(enddateflag == "3"){
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
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAddAppDetailInfo.srq?count="+count+"&line_infos="+line_infos+"&collcount="+collcount+"&collline_infos="+collline_infos;
		document.getElementById("form1").submit();
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
		var taskName = getQueryString("taskName");
		$("#jobname").text(taskName);
		var retObj;
		var basedatas;
		var proSql = "select project.project_name,devapp.device_addapp_id,devapp.device_addapp_no,devapp.device_addapp_name, ";
			proSql += "to_char(sysdate,'yyyy-mm-dd') as appdate "; 
			proSql += "from gms_device_allapp_add devapp left join gp_task_project project on devapp.project_info_no=project.project_info_no "; 
			proSql += "where devapp.bsflag='0' and devapp.device_addapp_id=''";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;

		if(retObj.length>=1){
			$("#project_name").text(retObj[0].project_name);
			$("#device_addapp_name").text(retObj[0].device_addapp_name);
			$("#device_addapp_id").val(retObj[0].device_addapp_id);
			$("#showappdate").text(retObj[0].appdate);
			$("#appdate").val(retObj[0].appdate);
		}
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

