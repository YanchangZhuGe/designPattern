<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>查询条件</title>
		<meta charset="UTF-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
	</head>
	<body class="bgColor_f3f3f3" onload="init();">
		<form name="form1" id="form1" method="post" action="">
			<input type="hidden" id="detail_count" value="" />
			<div id="new_table_box">
				<div id="new_table_box_content">
					<div id="new_table_box_bg">
						<fieldset>
							<legend>
								采集设备基本信息
							</legend>
							<table id="table1" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">
										采集设备名称
									</td>
									<td class="inquire_form4">
										<input name="dev_name" id="dev_name" class="input_width"
											type="text" />
									</td>
									<td class="inquire_item4">
										采集设备型号
									</td>
									<td class="inquire_form4">
										<input name="dev_model" id="dev_model" class="input_width"
											type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">
										采集设备类型
									</td>
									<td class="inquire_form4" id="here"></td>
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
						<fieldset>
							<legend>
								采集设备扩展信息
							</legend>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">
										总数量
									</td>
									<td class="inquire_form4">
										<input name="total_num" id="total_num" class="input_width"
											type="text" />
									</td>
									<td class="inquire_item4">
										所在位置
									</td>
									<td class="inquire_form4">
										<input name="dev_position" id="dev_position"
											class="input_width" type="text" />
									</td>
								</tr>
								<tr>
								<td class="inquire_item4">
										闲置数量
									</td>
									<td class="inquire_form4">
										<input name="unuse_num" id="unuse_num" class="input_width"
											type="text" />
									</td>
									
									<td class="inquire_item4">
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
								</tr>
								<tr>
									<td class="inquire_item4">
										在用数量
									</td>
									<td class="inquire_form4">
										<input name="use_num" id="use_num" class="input_width"
											type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">
										其他数量
									</td>
									<td class="inquire_form4">
										<input name="other_num" id="other_num" class="input_width"
											type="text" />
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
		<script src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
		<script> 
	$(function(){
		var ctt = parent.frames['list'].frames[1];
		var value = ctt.document.getElementById("type_id").value;
		$("#type_id",ctt.document).clone().val(value).appendTo($("#here"));
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
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	function init(){
		var ctt = parent.frames['list'].frames[1];
		document.getElementById("dev_name").value=ctt.document.getElementById("query_dev_name").value;
		var retObj;
		var unitSql = "select sd.coding_code_id,coding_name ";
		unitSql += "from comm_coding_sort_detail sd "; 
		unitSql += "where coding_sort_id ='0110000004' order by coding_code";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
		retObj = unitRet.datas;
		var optionhtml = "";
		for(var index=0;index<retObj.length;index++){
			optionhtml +=  "<option value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
		}
		$("#dev_unit").append(optionhtml);
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
    	var ctt = parent.frames['list'].frames[1];
    	ctt.document.getElementById("query_dev_name").value = document.getElementById("dev_name").value;
    	ctt.document.getElementById("type_id").value = document.getElementById("type_id").value;
	    ctt.refreshData(arrayObj);
		newClose();
	}
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(returnValue){
			strs=returnValue.split("~"); //字符分割
			var names = strs[0].split(":");
			document.getElementById(str+"_name").value = names[1];
			
			var orgId = strs[1].split(":");
			document.getElementById(str+"_id").value = orgId[1];
		}
		
	}
</script>
	</body>
</html>

