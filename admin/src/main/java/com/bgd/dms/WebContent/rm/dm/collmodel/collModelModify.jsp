<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%
	String contextPath = request.getContextPath();
	String model_mainid = request.getParameter("model_mainid");
	System.out.println("model_mainid == "+model_mainid);
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
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css">
<script>var _path='<%=contextPath%>'</script>
<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script src="<%=contextPath%>/js/extjs/ext-all-debug.js"></script>
<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>新增采集附属设备模板</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;padding:2px;"><legend>模板基本信息</legend>
      <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" align="left">模板名称:</td>
           <td class="inquire_form4" style="padding-right:20px">
          	<input name="model_name" id="model_name" style='line-height:15px' class="input_width" type="text" value="" />
          	<input name="model_mainid" id="model_mainid" type="hidden" value="" />
          </td>
          <td class="inquire_item4" align="left">模板类型:</td>
          <td class="inquire_form4" style="padding-right:20px">
          	<select id="model_type" name="model_type">
          	</select>
          </td>
        </tr>
      </table>
      </fieldset>
      <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="30%">
          	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;已有模板：
          	<select id="modelList" name="modelList" style="select_width">
				<option value="">请选择...</option>
          	</select>
          </td>
          <td><span class="jl"><a href="#" id="addbtn" onclick='toCopyInfos()' title="复制模板"></a></span></td>
          <td width="50%"></td>
          	<td align="right"><span class="zj"><a href="#" id="addbtn" onclick='toAddRowInfo()' title="新增"></a></span></td>
          	<td align="right">&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td align="right"><span class="sc"><a href="#" id="delbtn" onclick='toDelRowInfo()' title="删除"></a></span></td>
        </tr>
      </table>
      <fieldset style="margin:2px;padding:2px;"><legend>模板明细信息</legend>
      <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
			<td class="bt_info_even" >选择</td>
			<!-- <td class="bt_info_even" >序号</td> -->
			<td class="bt_info_odd" >设备名称</td>
			<td class="bt_info_even" >规格型号</td>
			<td class="bt_info_odd" >计量单位</td>
			<td class="bt_info_even" >道数</td>
			<td class="bt_info_odd" >备注</td>
        </tr>
        <tbody id="newDeviceModelList" name="newDeviceModelList"></tbody>
      </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function refreshData(){
		//回填模板类型
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
		$("#model_type").append(colltypeoptionhtml);
		var basedatas;
		var queryRet;
		//查询基本信息
		var querySql = "select model_mainid,model_name ";
		querySql += "from gms_device_collmodel_main main ";
		querySql += "where main.bsflag='0' ";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		basedatas = queryRet.datas;
		if(basedatas!=undefined && basedatas.length>0){
			//回填基本信息
			for(var index=0;index<basedatas.length;index++){
				var innerhtml = "<option value='"+basedatas[index].model_mainid+"'>"+basedatas[index].model_name+"</option>";
				$("#modelList").append(innerhtml);
			}
		}
		var model_mainid = '<%=model_mainid%>';
		var querySql = "select main.model_name,main.model_type,sub.* ";
		querySql += "from gms_device_collmodel_main main ";
		querySql += "left join gms_device_collmodel_sub sub on sub.model_mainid=main.model_mainid ";
		querySql += "where main.model_mainid='"+model_mainid+"' and main.bsflag='0' ";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		retObj = queryRet.datas;
		if(retObj&&retObj.length>1){
			$("#model_mainid").val(retObj[0].model_mainid);
			$("#model_name").val(retObj[0].model_name);
			$("#model_type").val(retObj[0].model_type);
			$("#modelList").val(retObj[0].model_mainid);
			
			for(var index=0;index<retObj.length;index++){
				toAddRowInfo();
				$("#device_id"+(index+1)).val(retObj[index].device_id);
				$("#devicename"+(index+1)).val(retObj[index].device_name);
				$("#devicemodel"+(index+1)).val(retObj[index].device_model);
				$("#unitList"+(index+1)).val(retObj[index].unit_id);
				$("#devslotnum"+(index+1)).val(retObj[index].device_slot_num);
				$("#remark"+(index+1)).val(retObj[index].remark);
			}
		}
	}
	var maxseqinfo = 0;
	var showseqinfo = 0;
	function toAddRowInfo(){
		maxseqinfo ++;
		showseqinfo ++;
		var innerhtml = "<tr id='tr"+maxseqinfo+"' name='tr'>";
		innerhtml += "<td><input type='checkbox' name='idinfo' id='"+maxseqinfo+"' checked/><input type='hidden' id='device_id"+maxseqinfo+"' name='device_id"+maxseqinfo+"' seqinfo='"+maxseqinfo+"' value=''></td>";
		//innerhtml += "<td>"+showseqinfo+"<input type='hidden' id='device_id"+maxseqinfo+"' name='device_id"+maxseqinfo+"' seqinfo='"+maxseqinfo+"' value=''></td>";
		innerhtml += "<td><input name='devicename"+maxseqinfo+"' id='devicename"+maxseqinfo+"' style='line-height:15px' value='' size='15' type='text' readonly/>";
		innerhtml += "<input type='button' style='width:20px' value='...' onclick='showDevCodePage("+maxseqinfo+")'/></td>";
		innerhtml += "<td><input name='devicemodel"+maxseqinfo+"' id='devicemodel"+maxseqinfo+"' style='line-height:15px' value='' size='15' type='text' readonly/></td>";
		innerhtml += "<td><select id='unitList"+maxseqinfo+"' name='unitList"+maxseqinfo+"' style='select_width'></select></td>";
		innerhtml += "<td><input name='devslotnum"+maxseqinfo+"' id='devslotnum"+maxseqinfo+"' style='line-height:15px' value='' size='6' type='text' /></td>";
		innerhtml += "<td><input name='remark"+maxseqinfo+"' id='remark"+maxseqinfo+"' style='line-height:15px' value='' size='25' type='text' /></td>";
		innerhtml += "</tr>";
		$("#newDeviceModelList").append(innerhtml);
		//查询单位编码，回填到新家的select中
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
		$("#unitList"+maxseqinfo).append(optionhtml);
		
		$("#newDeviceModelList>tr:odd>td:odd").addClass("odd_odd");
		$("#newDeviceModelList>tr:odd>td:even").addClass("odd_even");
		$("#newDeviceModelList>tr:even>td:odd").addClass("even_odd");
		$("#newDeviceModelList>tr:even>td:even").addClass("even_even");
	}
	function showDevCodePage(lineobj){
		var obj = new Object();
		var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		if(data!=undefined){
			$("#devicename"+lineobj).val(data.dev_name);
			$("#devicemodel"+lineobj).val(data.dev_model);
			$("#device_id"+lineobj).val(data.device_id);
			$("#devslotnum"+lineobj).val(data.dev_slot_num);
		}
	}
	function toDelRowInfo(lineinfo){
		$("input[type='checkbox'][name='idinfo']").each(function(i){
			if(this.checked){
				var id=this.id;
				$("#tr"+id,"#newDeviceModelList").remove();
				showseqinfo = showseqinfo-1;
			}
		});
		//重新编号
		//$("#newDeviceModelList>tr").each(function(i){
		//	var colcells = this.cells;
		//	colcells[1].innerHTML = (i+1);
		//});
		$("#newDeviceModelList>tr>td:odd").addClass("odd_odd");
		$("#newDeviceModelList>tr>td:even").addClass("odd_even");
		$("#newDeviceModelList>tr:even>td:odd").addClass("even_odd");
		$("#newDeviceModelList>tr:even>td:even").addClass("even_even");
		
	}
	function toCopyInfos(){
		var selectedvalue = $("#modelList").val();
		if(selectedvalue==''){
			return;
		}
		//先清除所有的信息
		$("#newDeviceModelList").empty();
		maxseqinfo = 0;
		showseqinfo = 0;
		//查找对应的明细信息，以行的形式加载到里面来
		var querySql = "select main.model_name,sub.* ";
		querySql += "from gms_device_collmodel_main main ";
		querySql += "left join gms_device_collmodel_sub sub on sub.model_mainid=main.model_mainid ";
		querySql += "where main.model_mainid='"+selectedvalue+"' and main.bsflag='0' ";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		retObj = queryRet.datas;
		var optionhtml = "";
		for(var index=0;index<retObj.length;index++){
			toAddRowInfo();
			$("#device_id"+(index+1)).val(retObj[index].device_id);
			$("#devicename"+(index+1)).val(retObj[index].device_name);
			$("#devicemodel"+(index+1)).val(retObj[index].device_model);
			$("#unitList"+(index+1)).val(retObj[index].unit_id);
			$("#devslotnum"+(index+1)).val(retObj[index].device_slot_num);
			$("#remark"+(index+1)).val(retObj[index].remark);
		}
	}
	function saveInfo(){
		var modelname = $("#model_name").val();
		if(modelname == ''){
			alert("模板名称不能为空!");
			return;
		}
		var count = 0;
		var j = 0;
		var seqinfos;
		var backdetids;
		var fillAlldetailFlag = true;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(this.checked){
				var index  = this.id;
				var deviceid = $("#device_id"+index).val();
				if(deviceid == ""){
					fillAlldetailFlag = false;
					j++;
				}
				if(count == 0){
					backdetids = "('"+deviceid;
					seqinfos = this.id;
				}else{
					backdetids += "','"+deviceid;
					seqinfos += "~"+this.id;
				}
				count++;
			}
		});
		
		if(count == 0){
			alert('请填写模板明细信息！');
			return;
		}else{
			backdetids += "')";
		}

		if(!fillAlldetailFlag){
			alert("请选择设备信息!");
			return;
		}
		if(window.confirm("确认修改?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveModelInfo.srq?seqinfos="+seqinfos+"&ids="+backdetids;
			document.getElementById("form1").submit();
		}
	}
</script>
</html>

