<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
			type="text/css" />
		<link rel="stylesheet" type="text/css" media="all"
			href="<%=contextPath%>/css/calendar-blue.css" />
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript"
			src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript"
			src="<%=contextPath%>/js/calendar-setup.js"></script>
		<script type="text/javascript"
			src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
		<title>查询条件</title>
	</head>
	<body class="bgColor_f3f3f3" onload="init();">
		<form name="form1" id="form1" method="post" action="">
			<input type="hidden" id="detail_count" value="" />
			<div id="new_table_box">
				<div id="new_table_box_content">
					<div id="new_table_box_bg">
						<fieldset>
							<legend>
								队级采集设备台账基本信息
							</legend>
							<table id="table1" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										采集设备名称
									</td>
									<td class="inquire_form6">
										<input id="dev_name" name="dev_name" class="input_width"
											type="text" />
									</td>
									<td class="inquire_item6">
										采集设备型号
									</td>
									<td class="inquire_form6">
										<input name="dev_model" class="input_width" type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										采集设备类型
									</td>
									<td class="inquire_form6">
										<select class="select_width" id="type_id" name="type_id">
											<option value="">
												--请选择--
											</option>
										</select>
									</td>
									<td class="inquire_item6">
										是否离场
									</td>
									<td class="inquire_form6">
										<select class="select_width" id="is_leaving" name="is_leaving">
											<option value="">
												--请选择--
											</option>
											<option value="0">
												否
											</option>
											<option value="1">
												是
											</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										总数量
									</td>
									<td class="inquire_form6">
										<input id="total_num" name="total_num" class="input_width"
											type="text" />
									</td>
									<td class="inquire_item6">
										在队数量
									</td>
									<td class="inquire_form6">
										<input id="unuse_num" name="unuse_num" class="input_width"
											type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										离队数量
									</td>
									<td class="inquire_form6">
										<input id="use_num" name="use_num" class="input_width"
											type="text" />
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>
								队级采集设备台账扩展信息
							</legend>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										所属单位
									</td>
									<td class="inquire_form6">
										<input id="owning_org_name" readonly="readonly"
											name="owning_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('owning_org')" />
										<input id="owning_org_id" name="owning_org_id" class=""
											type="hidden" />
									</td>
									<td class="inquire_item6">
										所属单位隶属
									</td>
									<td class="inquire_form6">
										<input id="owning_sub_name" readonly="readonly"
											name="owning_sub_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('owning_sub')" />
										<input id="owning_sub_id" name="owning_sub_id" class=""
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										所在单位
									</td>
									<td class="inquire_form6">
										<input id="usage_org_name" readonly="readonly"
											name="usage_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('usage_org')" />
										<input id="usage_org_id" name="usage_org_id" class=""
											type="hidden" />
									</td>
									<td class="inquire_item6">
										所在单位隶属
									</td>
									<td class="inquire_form6">
										<input id="usage_sub_name" readonly="readonly"
											name="usage_sub_name" " class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('usage_sub')" />
										<input id="usage_sub_id" name="usage_sub_id" class=""
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										计划进场时间
									</td>
									<td class="inquire_form6">
										<input id="planning_in_time" readonly="readonly"
											name="planning_in_time" class="input_width" type='text' />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton1' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("planning_in_time","colltributton1");' />
									</td>
									<td class="inquire_item6">
										计划离场时间
									</td>
									<td class="inquire_form6">
										<input id="planning_out_time" readonly="readonly" name="planning_out_time"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton2' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("planning_out_time","colltributton2");' />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										实际进场时间
									</td>
									<td class="inquire_form6">
										<input id="actual_in_time" readonly="readonly" name="actual_in_time"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton3' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("actual_in_time","colltributton3");' />
									</td>
									<td class="inquire_item6">
										实际离场时间
									</td>
									<td class="inquire_form6">
										<input id="actual_out_time" name="actual_out_time" readonly="readonly"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton4' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("actual_out_time","colltributton4");' />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										所在位置
									</td>
									<td class="inquire_form6">
										<input id="dev_position" name="dev_position"
											class="input_width" type="text" />
									</td>
									<td class="inquire_item6">
										转出单位
									</td>
									<td class="inquire_form6">
										<input id="out_org_name" readonly="readonly"
											name="out_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('out_org')" />
										<input id="out_org_id" name="out_org_id" class=""
											type="hidden" />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										转入单位
									</td>
									<td class="inquire_form6">
										<input id="in_org_name" readonly="readonly" name="in_org_name"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('in_org')" />
										<input id="in_org_id" name="in_org_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										计量单位
									</td>
									<td class="inquire_form6">
										<select id="dev_unit" name="dev_unit"' class="select_width">
											<option value="">--请选择--</option>
										</select>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="submitInfo()"></a>
						</span>
						<span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
		</form>
	</body>
	<script> 
	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				if(this.checked == true){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById(str+"_id").value = orgId[1];
	}
	function init(){
		var sql = "&querySql=select dev_name , device_id from gms_device_collectinfo where is_leaf != 1";
		var path = '<%=contextPath%>'+appConfig.queryListAction;
		var retObject = syncRequest('Post',path,sql);
		if(retObject.datas && retObject.datas.length > 0){
			for(var i = 0 ,datas=retObject.datas, length = retObject.datas.length ; i < length ; i++){
				$("#type_id").append("<option value='"+datas[i].device_id+"'>"+datas[i].dev_name+"</option");
			}
		}
		var unitSql = "select sd.coding_code_id,coding_name ";
		unitSql += "from comm_coding_sort_detail sd "; 
		unitSql += "where coding_sort_id ='0110000004' order by coding_code";
		var retObject = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
		if(retObject.datas && retObject.datas.length > 0){
			var optionhtml = "" , retObj = retObject.datas;
			for(var index=0 , length = retObj.length;index<length;index++){
				optionhtml +=  "<option value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#dev_unit").append(optionhtml);
		}
		var ctt = parent.frames['list'].frames;
		document.getElementById("dev_name").value=ctt.document.getElementById("s_dev_name").value;
		document.getElementById("is_leaving").value=ctt.document.getElementById("s_is_leaving").value;
	}
	function submitInfo(){
		var arrayObj = new Array();
		var tables = document.getElementsByTagName("table");
		for(var p = 0 ,length = tables.length ; p < length ; p++){
			var t = tables[p].childNodes.item(0);
			for(var i=0,length1 = t.childNodes.length;i < length1 ; i++){
	   			var childNode = t.childNodes[i];
	    		for(var j=1,length2 = childNode.childNodes.length;j < length2 ; j=j+2){
	    			var node = childNode.childNodes[j];
	    			if(node.childNodes.length == 6){
	    				var value = node.childNodes[4].value;
	    				if(value)
	    					arrayObj.push({"label":node.childNodes[4].name,"value":value}); 
	    			}else{
	    				var value = node.firstChild.value;
	    				if(value){
	    					arrayObj.push({"label":node.firstChild.name,"value":value}); 
	    				}
	    			}
	          	}
    		}
		}
    	var ctt = parent.frames['list'].frames;
    	ctt.document.getElementById("s_dev_name").value = document.getElementById("dev_name").value;
    	ctt.document.getElementById("s_is_leaving").value = document.getElementById("is_leaving").value;
	    ctt.refreshData(arrayObj);
	    newClose();
	}
</script>
</html>

