<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_app_id = request.getParameter("dev_app_id") == null ? ""
			: request.getParameter("dev_app_id");
	String dev_mix_id = request.getParameter("dev_mix_id") == null ? ""
			: request.getParameter("dev_mix_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
			type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
			rel="stylesheet" type="text/css" />
		<script type="text/javascript"
			src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript"
			src="<%=contextPath%>/js/dialog_open1.js"></script>
		<title>按台设备的调配调剂</title>
	</head>
	<body style="background:#fff" onload="refreshData()">
		<div id="new_table_box" style="width:98%">
			<div id="new_table_box_content" style="width:100%">
				<div id="new_table_box_bg" style="width:95%">
					<fieldset>
						<legend>
							设备调配单
						</legend>
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" id="devApp">
							<tr>
								<td class="inquire_item6">
									项目名称
								</td>
								<td class="inquire_form6">
									<input id="project_name" name="project_name" value=''
										class="input_width" type="text" readonly />
								</td>
								<td class="inquire_item6">
									申请人
								</td>
								<td class="inquire_form6">
									<input id="employee_name" name="employee_name" value=''
										class="input_width" type="text" readonly />
								</td>
							</tr>
							<tr>
								<td class="inquire_item6">
									申请单单号
								</td>
								<td class="inquire_form6">
									<input id="device_app_no" name="device_app_no" value=''
										class="input_width" type="text" readonly />
								</td>
								<td class="inquire_item6">
									申请单名称
								</td>
								<td class="inquire_form6">
									<input id="device_app_name" name="device_app_name" value=''
										class="input_width" type="text" readonly />
								</td>
							</tr>
							<tr>
								<td class="inquire_item6">
									转入单位
								</td>
								<td class="inquire_form6">
									<input id="in_org_name" name="in_org_name" value=''
										class="input_width" type="text" readonly />
									<input id="in_org_id" name="in_org_id" value='' type="hidden" />
								</td>
								<td class="inquire_item6">
									转出单位
								</td>
								<td class="inquire_form6">
									<input id="out_org_name" name="out_org_name" value=''
										class="input_width" type="text" readonly />
									<img src="<%=contextPath%>/images/magnifier.gif" width="16"
										height="16" style="cursor:hand;"
										onclick="showOrgTreePage('out_org')" />
									<input id="out_org_id" name="out_org_id" class="" type="hidden" />
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset>
						<legend>
							调配单基本信息
						</legend>
						<div>
							<table width="100%" border="0" cellspacing="0" cellpadding="0"
								class="tab_info" id="devAppDet">
								<tr>
									<td id="team" class="bt_info_even" width="12%">
										班组
									</td>
									<td id="dev_ci_name" class="bt_info_odd" width="14%">
										设备名称
									</td>
									<td id="dev_ci_model" class="bt_info_even" width="14%">
										规格型号
									</td>
									<td id="unitinfo" class="bt_info_odd" width="12%">
										单位
									</td>
									<td id="purpose" class="bt_info_even" width="12%">
										用途
									</td>
									<td id="apply_num" class="bt_info_odd" width="12%">
										申请数量
									</td>
									<td id="remain_num" class="bt_info_even" width="12%">
										剩余数量
									</td>
									<td id="assign_num" class="bt_info_odd" width="12%">
										调配数量
									</td>
								</tr>
								<tbody id="devAppDetBody"></tbody>
							</table>
						</div>
					</fieldset>
				</div>
				<div id="oper_div" style="margin-bottom:5px">
					<!--<span id="tjbtn" class="tj_btn"><a id="tja" href="#"
						onclick="submitInfo()"></a> </span> -->
					<span id="bcbtn" class="bc_btn"><a href="#"
						onclick="saveInfo()"></a> </span>
					<span id="gbbtn" class="gb_btn"><a href="#"
						onclick="newClose()"></a> </span>
				</div>
			</div>
		</div>
		<script>
	cruConfig.contextPath =  "<%=contextPath%>";
	var devAppId = '<%=dev_app_id%>',
		devMixId = '<%=dev_mix_id%>',
		sql = null,
		devApp = null,
		devAppDet = null,
		count = 1;
	function toEdit(e){
		e = e || window.event;
		if(!$.trim($("#out_org_name").val())){
			alert("请先选择转出单位");
			e.returnValue = false;
			return false;
		}else{
			var tr = $(e.srcElement).closest("tr"),td = $("td:last-child",tr);
			if(td.attr("isclicked") == "true" || tr.attr("isvalidate") != "1" ){
				return;
			}
		   	td.each(function(){
	   			$(this).html(function(index,html){
		   				$(this).attr('oldvalue',html);
		   				return "<input type=text size=12 onblur=_blurHandler(this) value="+html+">";
		   			});
		   		$("input",this).css({'text-align':'center','line-height':'18px'}).focus();
	   		}).attr("isclicked",true);
		}
	}
	function _blurHandler(src){
		var td = $(src).closest("td"),prevTd = td.prev(),num = prevTd.text() - 0 ,oldValue = td.attr("oldvalue") - 0;
		if(src.value == ""){
			td.removeAttr("isclicked");
			prevTd.text(num + oldValue - src.value);
			td.empty().text(src.value);
		}else{
			if(!/^0$|^[1-9]\d*$/.test(src.value)){
				src.value=td.attr("oldvalue");
				alert("请输入数字");
				$(src).focus();
			}else{
				var oldValue = td.attr("oldvalue") - 0;
				if(src.value - oldValue > num){
					src.value = td.attr("oldvalue");
					alert("调配数量不能超过剩余数量");
					$(src).focus();
				}else{
					td.removeAttr("isclicked");
					td.attr("oldvalue",src.value);
					prevTd.text(num + oldValue - src.value);
					td.empty().text(src.value);
				}
			}
		}
	}
	function refreshData(){
		getDevAppData();
		getDevAppDetData();
		refreshCss();
		if($("#out_org_name").val())
			$("#out_org_name").next().hide();
	}
	function refreshCss(){
		$("#devAppDetBody>tr:odd>td:odd").addClass("odd_odd");
		$("#devAppDetBody>tr:odd>td:even").addClass("odd_even");
		$("#devAppDetBody>tr:even>td:odd").addClass("even_odd");
		$("#devAppDetBody>tr:even>td:even").addClass("even_even");
		if($("#out_org_name").val()){
			//更改样式，给字设置成淡灰色
			//$("tr[isvalidate!='1'] td","#devAppDetBody").css('background','#E0E0E0');
			$("tr[isvalidate!='1'] td","#devAppDetBody").css('color','#D0D0D0');
		}
	}
	function getDevAppData(){
		if(devAppId){
			sql = 	"SELECT p.project_name,\n" +
						"   t.project_info_no,t.app_org_id,t.mix_org_id,\n"+
						"       u.employee_name AS employee_name,\n" + 
						"       t.device_app_no,t.mix_type_id,\n" + 
						"       t.device_app_name,t.mix_type_name,t.mix_user_id,\n" + 
						"		gf.out_org_id,\n"  +
						"       (select c1.org_abbreviation from comm_org_information c1 where c1.org_id = gf.out_org_id) as out_org_name,\n"+
						"       c.org_abbreviation AS in_org_name\n" + 
						"  FROM gms_device_app t left join gms_device_mixinfo_form gf on t.device_app_id = gf.device_app_id and gf.device_mixinfo_id "+(devMixId == "" ? "is null" : "='"+devMixId+"'")+ 
						"  LEFT JOIN gp_task_project p\n" + 
						"    ON t.project_info_no = p.project_info_no\n" + 
						"  LEFT JOIN comm_human_employee u\n" + 
						"    ON t.employee_id = u.employee_id\n" + 
						"  LEFT JOIN comm_org_information c\n" + 
						"    ON c.org_id = t.app_org_id where t.device_app_id = '"+devAppId+"'";
			devApp = jcdpQueryRecords(sql);
			if(devApp.returnCode == "0" && devApp.datas && devApp.datas.length > 0){
				for(var i = 0 ,datas = devApp.datas , length = datas.length ; i < length ;i++){
					for(var j in datas[i]){
						if(j == "out_org_id"){
							$("#"+j).attr("oldvalue",datas[i][j]);
						}
						$("#"+j).val(datas[i][j]);
					}
				}
			}
		}
	}
	function getDevAppDetData(){
		var str = "" , out_org_id = $("#out_org_id").val();
		if(out_org_id){
			str = 	" case when exists (select 1 from gms_device_account ga where ga.owning_org_id = '"+out_org_id+"'" + 
					" and (ga.dev_type = gd.dev_ci_code or ga.dev_type like 'S'||gd.dev_ci_code||'%25')) then '1' else '0' end as isvalidate,";
		}
		sql = 	"select gd.apply_num,gd.dev_ci_code,gd.isdevicecode,\n" + 
				"       gm.assign_num,\n" + 
				"case when gd.isdevicecode='N' then gc.dev_ci_name else ct.dev_ct_name end as dev_ci_name,\n"+
				"case when gd.isdevicecode='N' then gc.dev_ci_model else '' end as dev_ci_model,\n"+
				"       gm.device_mix_subid,\n" + 
				"       gd.device_app_detid,\n" + 
				"       cd1.coding_name AS team,\n" + str+					
				"       gd.apply_num -\n" + 
				"       (SELECT CASE WHEN SUM(gm.assign_num) IS NULL THEN 0 ELSE SUM(gm.assign_num) END FROM gms_device_appmix_main gm\n" + 
				"         WHERE gm.device_app_detid = gd.device_app_detid) AS remain_num,\n" + 
				"       CASE\n" + 
				"         WHEN cd2.coding_name IS NULL THEN\n" + 
				"          gd.teamid\n" + 
				"         ELSE\n" + 
				"          cd2.coding_name\n" + 
				"       END AS teamid,\n" + 
				"       cd3.coding_name AS unitinfo\n" + 
				"  from gms_device_app_detail gd\n" + 
				"  LEFT JOIN gms_device_codeinfo gc ON gd.dev_ci_code = gc.dev_ci_code\n" + 
				"  LEFT JOIN gms_device_codetype ct ON gd.dev_ci_code = ct.dev_ct_code\n" +
				"  LEFT JOIN gms_device_appmix_main gm\n" + 
				"    ON gm.device_app_detid = gd.device_app_detid\n" + 
				"   AND gm.device_mixinfo_id "+   (devMixId == "" ? "is null" :"='"+devMixId+"'")+ 
				"  LEFT JOIN comm_coding_sort_detail cd1\n" + 
				"    ON cd1.coding_code_id = gd.team\n" + 
				"  LEFT JOIN comm_coding_sort_detail cd2\n" + 
				"    ON cd2.coding_code_id = gd.teamid\n" + 
				"  LEFT JOIN comm_coding_sort_detail cd3\n" + 
				"    ON cd3.coding_code_id = gd.unitinfo\n" + 
				" WHERE gd.device_app_id = '"+devAppId+"'";
		sql=encodeURI(sql);
		devAppDet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		if(devAppDet.returnCode == "0" && devAppDet.datas && devAppDet.datas.length > 0){
			//retObj = proqueryRet.datas;
			var table = $("#devAppDetBody"),ids = $("tr td","#devAppDet").map(function(){
				return $(this).attr("id");
			});
			table.empty();
			for(var i = 0 ,datas = devAppDet.datas , length = datas.length ; i < length ;i++){
				var tr = $("<tr>"),data = datas[i];
				for(var j = 0 ,len = ids.length ; j < len ;j++){
					var td = $("<td>");
					td.text(data[ids[j]]);
					tr.append(td);
					if(j == len-1){
						td.attr("oldvalue",data[ids[j]]);
					}
				}
				tr.attr({
					'isvalidate' : data.isvalidate,
					'DEVICE_APP_DETID' : data.device_app_detid
				});
				tr.dblclick(function(e){
					toEdit(e);
				});
				table.append(tr);
			}
		}
	}
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array();
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); 
		var names = strs[0].split(":");
		var orgId = strs[1].split(":");
		var oldValue = document.getElementById(str+"_name").value;
		if(oldValue != names[1]){
			document.getElementById(str+"_name").value = names[1];
			document.getElementById(str+"_id").value = orgId[1];
			getDevAppDetData();
			refreshCss();
		}
		
	}
	
	function beforeSave(){
		var trs = $("tr","#devAppDetBody");
		var out_org_id =  $("#out_org_id").val();
		if(!out_org_id){
			alert("请选择转出单位");
			return false;
		}
		var data = {};
		var length = trs.length,array = [],isDeleteDevMix = true;
		for(var i = 0 ; i < length ; i++){
			var assign_num = $("td:last-child",trs[i]).text() - 0;
			array.push({
				assign_num  : assign_num,
				device_app_detid : devAppDet.datas[i].device_app_detid,
				dev_ci_code : devAppDet.datas[i].dev_ci_code,
				isdevicecode : devAppDet.datas[i].isdevicecode
			});
			if(isDeleteDevMix && assign_num > 0){
				isDeleteDevMix = false;
			}
		}
		data.device_mixinfo_id = devMixId;
		data.out_org_id = $("#out_org_id").val();
		data.device_app_id = devAppId;
		data.datas = array;
		data.mix_org_id = devApp.datas[0].mix_org_id;
		data.mix_type_id = devApp.datas[0].mix_type_id;
		data.mix_user_id = devApp.datas[0].mix_user_id;
		data.mix_type_name = devApp.datas[0].mix_type_name;
		data.project_info_no = devApp.datas[0].project_info_no;
		data.in_org_id = devApp.datas[0].app_org_id;
		if(isDeleteDevMix && devMixId && $("#out_org_id").attr("oldvalue")){
			var c = window.confirm("因为没有分配调配明细,需要删除该调配单吗?");
			if(c){
				data.isdelete = true;
			}else{
				data.isdelete = false;
			}
		}else if(isDeleteDevMix && devMixId == "" && !$("#out_org_id").attr("oldvalue")){
			var c = window.confirm("因为没有分配调配明细,需要保存该调配单吗?");
			if(c){
				data.issave = true;
			}else{
				data.issave = false;
			}	
		}
		alert($.toJSON(data))
		var retObj = jcdpCallService("DevCommInfoSrv", "saveDevAppMixMain", "data="+$.toJSON(data));
		return retObj;
	}
	function saveInfo(){
		var retObj = beforeSave();
		if(retObj.returnCode == "0"){
			alert("数据保存成功");
			var ctt = parent.frames['list'].frames;
			ctt.window.refreshData();
			newClose();
		}else{
			alert(retObj.returnMsg);
		}
	}
jQuery.extend({
	toJSON : function (object){
				var type = typeof object;
				if ('object' == type){
					if (Array == object.constructor)
	             		type = 'array';
	            	else if (RegExp == object.constructor)
	             		type = 'regexp';
	            	else
	             		type = 'object';
	           	}
	            switch(type){
					case 'undefined':
	               	case 'unknown': 
	             		return;
	             		break;
	            	case 'function':
	               	case 'boolean':
	            	case 'regexp':
	             		return object.toString();
	             		break;
	            	case 'number':
	             		return isFinite(object) ? object.toString() : 'null';
	               		break;
	            	case 'string':
	             		return '"' + object.replace(/(\\|\")/g,"\\$1").replace(/\n|\r|\t/g,
							function(){   
	                        	var a = arguments[0];                   
				                return  (a == '\n') ? '\\n':   
				                               (a == '\r') ? '\\r':   
				                               (a == '\t') ? '\\t': ""  
				                     }) + '"';
	             		break;
	            	case 'object':
	             		if (object === null) return 'null';
	                	var results = [];
	                	for (var property in object) {
	                  		var value = jQuery.toJSON(object[property]);
	                  		if (value !== undefined)
	                    		results.push(jQuery.toJSON(property) + ':' + value);
	                	}
	                	return '{' + results.join(',') + '}';
	             		break;
	            	case 'array':
	             		var results = [];
	                	for(var i = 0; i < object.length; i++){
	              			var value = jQuery.toJSON(object[i]);
	                   		if (value !== undefined) results.push(value);
	             		}
	                	return '[' + results.join(',') + ']';
	             		break;
	              }
			}
	});
</script>
	</body>
</html>
