<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String device_id = request.getParameter("device_id");
	String dev_code = request.getParameter("dev_code");
	String node_level = request.getParameter("node_level");
	int currentLevel = Integer.parseInt(node_level);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>批量设备编码维护</title>
</head>
<body class="bgColor_f3f3f3" >
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="height:440px">
  <div id="new_table_box_content" style="height:400px">
  <div id="new_table_box_bg" style="height:350px">
      <fieldSet style="margin-left:30px;margin-right:30px;margin-bottom:15px;padding:2px;"><legend>批量设备编码信息</legend>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td class="inquire_item4" >设备编码:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input name="showcode" id="showcode" size="20" type="text" value="<%=dev_code%>"  readonly/>
	          	<input name="code" id="code" type="hidden" value=""  />
	          </td>
	          <td class="inquire_item4" >设备名称:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input name="name" id="name" size="20" type="text"  value=""  readonly/>
	          </td>
	          <td class="inquire_item4" >规格型号:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input name="model" id="model" size="20" type="text"  value=""  readonly/>
	          </td>
	        </tr>
	      </table>
      </fieldSet>
      <!-- 操作按钮 -->
      <div id="list_table">
		 <div id="inq_tool_box">
		 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
	     		<td class="ali_cdn_name"></td>
			    <td class="ali_cdn_input"></td>
			    <td class="ali_cdn_name"></td>
			    <td class="ali_cdn_input"></td>
	     		<auth:ListButton functionId="" css="zj" event="onclick='toAddMappingPage()'" title="新增"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelMappingInfo()'" title="删除"></auth:ListButton>
			  </tr>
			</table>
		 </div>
	  </div>
      <fieldSet style="margin-left:30px;margin-right:30px;padding:2px;"><legend>单台设备编码&lt;已添加&gt;</legend>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	        	<td class="bt_info_odd" >选择</td>
				<td class="bt_info_even" >序号</td>
				<td class="bt_info_odd" >批量设备编码</td>
				<td class="bt_info_even" >单台设备编码</td>
				<td class="bt_info_odd" >设备名称</td>
				<td class="bt_info_even" >规格型号</td>
	        </tr>
	        <tbody id='mappinglist'"></tbody>
	      </table>
      </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var parentDevcode = '<%=dev_code%>';
	var count = 0;
	function toAddMappingPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDevCodeInfoForMater.jsp",obj);
		if(vReturnValue!=undefined){
			//添加一行
			var returnvalues = vReturnValue.split('~');
			var deviceId = returnvalues[0];
			var deviceCode = returnvalues[1];
			var devicename = returnvalues[2];
			var devicemodel = returnvalues[3];
			count++;
			var innerinfo = "<tr index='"+count+"'><td><input type='checkbox' id='selectval' name='selectval' index='"+count+"' value='' devcicode='"+deviceCode+"'/></td>";
			innerinfo += "<td id='seqtd'>"+count+"</td>";
			innerinfo += "<td>"+$("#code").val()+"</td>";
			innerinfo += "<td>"+deviceCode+"</td>";
			innerinfo += "<td>"+devicename+"</td>";
			innerinfo += "<td>"+devicemodel+"</td></tr>";
			$("#mappinglist").append(innerinfo);
		}
	}
	
	function toDelMappingInfo(){
		$("input[type='checkbox'][name='selectval']").each(function(i){
			if(this.checked){
				$("tr[index='"+this.index+"']").remove();
			}
		});
		//重新调整序号
		count = $("tr","#mappinglist").size();
		$("tr","#mappinglist").each(function(i){
			var tdnodes = this.cells;
			tdnodes[0].childNodes[0].index = (i+1);
			tdnodes[1].innerText = (i+1);
		});
	};
	$().ready(function(){
		//查询这条记录的基本信息，并关联所有已添加的记录信息，将信息回填到界面中。
		var querySql = "select ci.device_id,ci.dev_code,ci.dev_name,ci.dev_model,cm.mapping_id,"+
					"dci.dev_ci_code,dci.dev_ci_name,dci.dev_ci_model "+
					"from gms_device_collectinfo ci "+
					"left join gms_device_coll_mapping cm on ci.device_id = cm.device_id "+ 
					"left join gms_device_codeinfo dci on cm.dev_ci_code=dci.dev_ci_code "+
					"where ci.device_id='<%=device_id%>' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		basedatas = queryRet.datas;
		if(basedatas!=undefined && basedatas.length>0){
			//先回填基本信息
			$("#code").val(basedatas[0].device_id);
			$("#name").val(basedatas[0].dev_name);
			$("#model").val(basedatas[0].dev_model);
			if(basedatas.length==1){
				if(basedatas[0].dev_ci_code!=""){
					//向表格插入一行映射值
					var innerinfo = "<tr index='1'><td><input type='checkbox' id='selectval' name='selectval' index='1' value='"+basedatas[0].mapping_id+"' devcicode='"+basedatas[0].dev_ci_code+"'/></td>";
					innerinfo += "<td id='seqtd'>1</td>";
					innerinfo += "<td>"+basedatas[0].dev_code+"</td>";
					innerinfo += "<td>"+basedatas[0].dev_ci_code+"</td>";
					innerinfo += "<td>"+basedatas[0].dev_ci_name+"</td>";
					innerinfo += "<td>"+basedatas[0].dev_ci_model+"</td></tr>";
					count = 1;
				}
				$("#mappinglist").append(innerinfo);
			}else{
				//循环插入多行映射值
				for(var index=0;index<basedatas.length;index++){
					var innerinfo = "<tr index='"+(index+1)+"'> <td><input type='checkbox' id='selectval' name='selectval' index='"+(index+1)+"' value='"+basedatas[index].mapping_id+"' devcicode='"+basedatas[index].dev_ci_code+"'/></td>";
					innerinfo += "<td id='seqtd'>"+(index+1)+"</td>";
					innerinfo += "<td>"+basedatas[index].dev_code+"</td>";
					innerinfo += "<td>"+basedatas[index].dev_ci_code+"</td>";
					innerinfo += "<td>"+basedatas[index].dev_ci_name+"</td>";
					innerinfo += "<td>"+basedatas[index].dev_ci_model+"</td></tr>";
					$("#mappinglist").append(innerinfo);
					count += 1;
				}
			}
		}
	});
	function saveInfo(){
		//1. mapping记录不能为空
		if(count==0){
			alert("请添加编码映射明细!");
			return;
		}
		//mapping_ids and mapping_indexs 除外，还有 dev_ci_code信息，以~分割。
		var dev_ci_codes = "";
		var mapping_ids = "";
		var modifi_count = 0;
		var mapping_indexes = "";
		$("input[type='checkbox'][name='selectval']").each(function(i){
			if(i==0){
				dev_ci_codes = this.devcicode;
			}else{
				dev_ci_codes += "~"+this.devcicode;
			}
		});
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollectMapping.srq?detcount="+count+"&dev_ci_codes="+dev_ci_codes;
		document.getElementById("form1").submit();
	}
</script>
</html>