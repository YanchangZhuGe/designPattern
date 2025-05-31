<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLDecoder"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String device_mixinfo_id = request.getParameter("device_mixinfo_id");
	String device_app_id = request.getParameter("device_app_id");
	String device_app_no = new String(request.getParameter("device_app_no").getBytes("ISO-8859-1"),"UTF-8").trim();
	String project_name = new String(request.getParameter("project_name").getBytes("ISO-8859-1"),"UTF-8").trim();
	String in_org_name = new String(request.getParameter("in_org_name").getBytes("ISO-8859-1"),"UTF-8").trim();
	String out_org_name = new String(request.getParameter("out_org_name").getBytes("ISO-8859-1"),"UTF-8").trim();
	String device_app_name = new String(request.getParameter("device_app_name").getBytes("ISO-8859-1"),"UTF-8").trim();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
  <title>设备类型的调配调剂</title> 
 </head>
<body style="background:#fff" onload="refreshData()">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset><legend>调配基本信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
		  	<td class="inquire_item6">申请单单号</td>
		  	<td class="inquire_form6">
		  		<input id="device_app_no" name="device_app_no" value='<%=device_app_no %>' class="input_width" type="text" readonly/>
		  	</td>
		  	<td class="inquire_item6">申请单名称</td>
			<td class="inquire_form6">
				<input id="device_app_name" name="device_app_name" value='<%=device_app_name %>' class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="project_name" name="project_name" value='<%=project_name %>' class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">转入单位</td>
			<td class="inquire_form6">
				<input id="in_org_name" name="in_org_name" value='<%=in_org_name %>' class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">转出单位</td>
			<td class="inquire_form6">
				<input id="out_org_name" name="out_org_name" value='<%=out_org_name%>' class="input_width" type="text" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage('out_org')" />
				<input id="out_org_id" name="out_org_id" class=""	type="hidden" />
			</td>
				
		  </tr>
		  </table>
	  </fieldset>
	  <fieldset>
	  	<legend>调配明细信息</legend>
	   <div id="table_box">
	   		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	   			<%--		
				     <tr>
						<td exp={device_name} class="bt_info_even" width="14%">设备名称</td>
						<td exp={device_model} class="bt_info_even" width="14%">设备类型</td>
						<td exp={device_type} class="bt_info_even" width="14%">设备型号</td>
						<td exp={device_slot_num} class="bt_info_even" width="10%">总道数</td>
						<td exp={device_num} class="bt_info_even" width="10%">计划数量</td>
						<td exp={device_remain_num} class="bt_info_even" width="12%">剩余调配数量</td>
						<td exp={org_mixed_num} class="bt_info_even" width="14%">单位预调配数量</td>
						<td exp={org_unuse_num} class="bt_info_even" width="14%">单位空闲数量</td>
						<td exp={mix_num}></td>
						<td exp={device_id}></td>
				     </tr> 
			     --%>
			     <tr>
					<td name=device_name class="bt_info_even" width="14%">设备名称</td>
					<td name=device_model class="bt_info_even" width="14%">设备型号</td>
					<td name=type_name class="bt_info_even" width="14%">设备类型</td>
					<td name=device_slot_num class="bt_info_even" width="12%">总道数</td>
					<td name=device_num class="bt_info_even" width="12%">计划数量</td>
					<td name=unit_name class="bt_info_even" width="12%">计量单位</td>
					<td name=device_remain_num class="bt_info_even" width="12%">剩余调配数量</td>
					<td name=org_mixed_num class="bt_info_even" width="14%">单位预调配数量</td>
					<td name=org_unuse_num class="bt_info_even" width="14%">单位空闲数量</td>
					<td name=mix_num style="display: none"></td>
					<td name=device_id style="display: none"></td>
			     </tr> 
			     <tbody id="listbody"></tbody>
			  </table>
		</div>
		<%--
			<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				  <tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到 
				      <label>
				        <input  onchange="" type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label>
				    </td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			 </div>
		 --%>
		</fieldset>
    	</div>
    	<div id="oper_div" style="margin-bottom:5px">
		 	<span id="tjbtn" class="tj_btn"><a id="tja" href="#" onclick="submitInfo()"></a></span>
		 	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
		    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	  	</div>
	</div>
</div>
</body>
<script>

</script>
<script>
	var device_mixinfo_id = '<%=device_mixinfo_id%>';
	var device_app_id = '<%=device_app_id%>';
	var out_org_name = '<%=out_org_name%>';
	var devMixSub = null;
	cruConfig.contextPath =  "<%=contextPath%>";
	function refreshData(){
		var sql = "" , str1 = "" , str2 = "";
		if(device_mixinfo_id){
			str1 = "p.org_mixed_num as mix_num,";
			str2 = 	"(SELECT ga.unuse_num\n" +
					"                 FROM gms_device_coll_account ga ,comm_org_information c \n" + 
					"                WHERE ga.usage_org_id =  c.org_id and c.org_abbreviation = '"+out_org_name+"'\n" + 
					"                  AND ga.device_id = t3.device_id\n" + 
					"                  AND ga.bsflag = '0') AS org_unuse_num,\n" + 
					"              (SELECT gm.mix_num\n" + 
					"                 FROM gms_device_coll_mixsub gm, gms_device_collmix_form gf\n" + 
					"                WHERE gf.device_mixinfo_id = gm.device_mixinfo_id\n" + 
					"                  AND gm.device_detsubid = t3.device_detsubid\n" + 
					"                  AND gm.device_mixinfo_id = '"+device_mixinfo_id+"') AS org_mixed_num,";
		}
		sql = 	"SELECT p.*,"+str1+"p.device_num - p.device_mixed_num AS device_remain_num" + 
				"  FROM (SELECT t3.device_detsubid,\n" + 
				"               t3.device_app_detid,\n" + 
				"               t3.device_id,\n" + 
				"               t3.device_name,\n" + 
				"               t3.device_model,\n" + 
				"               t3.device_slot_num,\n" + str2+
				"               (SELECT c2.dev_name\n" + 
				"                  FROM gms_device_collectinfo c1, gms_device_collectinfo c2\n" + 
				"                 WHERE c1.device_id = t3.device_id\n" + 
				"                   AND c1.node_parent_id = c2.device_id) AS type_name,\n" + 
				"               t3.device_num,\n" + 
				"               (SELECT d.coding_name\n" + 
				"                  FROM comm_coding_sort_detail d\n" + 
				"                 WHERE d.coding_code_id = t3.unit_id) AS unit_name,\n" + 
				"               t3.unit_id,\n" + 
				"               (SELECT CASE\n" + 
				"                         WHEN SUM(gm.mix_num) IS NULL THEN\n" + 
				"                          0\n" + 
				"                         ELSE\n" + 
				"                          SUM(gm.mix_num)\n" + 
				"                       END\n" + 
				"                  FROM gms_device_coll_mixsub gm\n" + 
				"                 WHERE gm.device_detsubid = t3.device_detsubid) AS device_mixed_num\n" + 
				"          FROM gms_device_collapp t1\n" + 
				"         INNER JOIN gms_device_app_colldetail t2\n" + 
				"            ON t1.device_app_id = t2.device_app_id\n" + 
				"           AND t2.bsflag = '0'\n" + 
				"         INNER JOIN gms_device_app_colldetsub t3\n" + 
				"            ON t2.device_app_detid = t3.device_app_detid\n" + 
				"         WHERE t1.device_app_id = '"+device_app_id+"'\n" + 
				"           AND t1.bsflag = '0') p";
		var retObject = jcdpQueryRecords(sql);
		if(out_org_name){
			$("#out_org_name").next().hide();
		}
		if(retObject.returnCode == "0" && retObject.datas && retObject.datas.length > 0){
			devMixSub = retObject.datas;
			var names = cruConfig.names = $("tr:eq(0) td","#queryRetTable").map(function(){
				return $(this).attr("name");
			}).get();
			var length = devMixSub.length;
			var listbody = "#listbody";
			for(var i = 0 ;i < length ; i++){
				var item = devMixSub[i],tr = $("<tr>");
				tr.dblclick(function(e){toEdit(e);});
				tr.attr("ordernum",i+1);
				for(var j = 0 , len = names.length ; j < len ;j++){
					var td = $("<td>");
					if(j >= len - 2){
						td.css("display","none");
					} 
					td.appendTo(tr).text(item[names[j]]);
					if(j == 7){
						if(td.text() == "-1"){
							td.attr("actionType","add");
							td.text(0);
						}
					}
				}
				setMaxValue(tr);
				$(listbody).append(tr);			
			}
			$(listbody+">tr:odd>td:odd").addClass("odd_odd");
			$(listbody+">tr:odd>td:even").addClass("odd_even");
			$(listbody+">tr:even>td:odd").addClass("even_odd");
			$(listbody+">tr:even>td:even").addClass("even_even");
		}
	}
	function setMaxValue(tr){
		var num1 = $("td:eq(6)",tr).text() - 0 ,
					    num2 = $("td:eq(7)",tr).text() - 0 ,
					    num3 = $("td:eq(8)",tr).text() - 0 ,
					    maxvalue = 0;
				if((num1 + num2) > num3){
					maxvalue = num3;
				}else{
					maxvalue = num1+num2;
				}
		$("td:eq(7)",tr).attr("maxvalue",maxvalue);
	}
	function toEdit(e){
		e = e || window.event;
		if(!$.trim($("#out_org_name").val())){
			alert("请先选择转出单位");
			e.returnValue = false;
			return false;
		}else{
			var tr = $(e.srcElement).closest("tr");
		    $("td:eq(7)",tr).each(function(){
		   		if($(this).attr('isdbclick') != 'true'){
		   			$(this).attr('isdbclick','true').html(function(index,html){
		   				$(this).attr('oldvalue',html);
		   				return "<input type=text size=9 onblur=_blurHandler(this) value="+html+">";
		   			});
		   			$("input",this).css({'text-align':'center','line-height':'18px'}).focus();
		   		}
	   		});
		}
	}
	function _blurHandler(el){
		var tr = $(el).closest("tr"),
			td = $("td:eq(7)",tr),
			orgMn = $(el).val(),
			orgMnOld = td.attr("oldvalue") - 0,
		    maxvalue = td.attr("maxvalue") - 0 ,  
			msg = "",
			regexp = /^\d+$/;
			if(regexp.test(orgMn)){
				if(orgMn > maxvalue){
					msg += "调配数量不正确,最大只能为"+maxvalue;
				}
				if(msg.length > 0){
				    td.attr("isValidate","false");
					$(el).focus();
					alert(msg);
					$(el).val(orgMnOld);
					return false;
				}else{
					td.attr("isValidate","true");
					td.attr("isdbclick","false");
					$("td:eq(6)",tr).text($("td:eq(6)",tr).text() - orgMn + orgMnOld);
					td.empty().text(orgMn);
				}
			}else{
				td.attr("isValidate","false");
				alert("数量,必须为非负整数");
				$(el).focus();
				return false;
			}
	} 
    function changeOrgDevList(orgId){
    	var deviceIds = $("tr:gt(0) td:last-child","#queryRetTable").not(function(){
    		if("" == $.trim($(this).text())){
    			return true;
    		}
    	}).map(function(){
    		return $(this).text();
    	}).get().join("','");
    	var sql = 	"SELECT t.device_id , t.unuse_num\n" +
					"  FROM gms_device_coll_account t\n" + 
					" WHERE t.device_id IN ('"+deviceIds+"')\n" + 
					"  AND t.bsflag = '0' and  t.usage_org_id = '"+orgId+"'";
    	var retObj = jcdpQueryRecords(sql);
    	if(retObj.returnCode == 0){
    		$("tr:gt(0)","#queryRetTable").each(function(){
					$("td",this).slice(-4,-2).text('');
			});
    		if(retObj.datas){
    			$.each(retObj.datas,function(i,n){
    				var deviceId = n.device_id,
    					tr = $("tr:has(td:contains("+deviceId+"))","#queryRetTable"),
    					td = tr.find("td:nth-child(9)");
   				 	td.text(n.unuse_num);
   				 	setMaxValue(tr);
    			});
    		}
    	}else{
    		alert(retObj.returnMsg);
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
			changeOrgDevList(orgId[1]);
		}
	}
	function saveInfo(){
		if(!$.trim($("#out_org_name").val())){
			alert("请先选择转出单位");
			return false;
		}
		if(checkData() !== false){
			var newOrgOutName = $("#out_org_name").val();
			if(newOrgOutName == '<%=out_org_name%>'){
				var datas = [],
					length = cruConfig.items.length,
				    trs = $("tr:gt(0)","#queryRetTable").slice(0,length);
				for(var i = 0 ; i < trs.length ;i++){
					var deviceId = $("td:last-child",trs[i]).text(),
						td = $("td:eq(7)",trs[i]),
						orgMn = td.text(),
						orgUn = $("td:eq(8)",trs[i]).text(),
						mixnum = $("td:eq(9)",trs[i]).text();
					if( orgMn == "0" && (td.attr('actionType') == 'add' || mixnum == "0")){
						continue;
					}
					if(td.attr('actionType') == 'add'){ 
						var values = cruConfig.items[i];
						datas.push({
							device_mixinfo_id : '<%=device_mixinfo_id%>',
							device_detsubid : values.device_detsubid,
							device_id : values.device_id,
							device_name : values.device_name,
							device_model : values.device_model,
							device_slot_num : values.device_slot_num,
							device_num : values.device_num,
							unit_id : values.unit_id,
							mix_num : orgMn,
							actionType : 'add'
						});
					}else if(orgMn == "0"){
						datas.push({
							device_id     : deviceId,
							device_mixinfo_id : '<%=device_mixinfo_id%>',
							actionType : 'delete'	
						});
					}else if(orgMn != mixnum){
						datas.push({
							mix_num  : orgMn,
							device_id     : deviceId,
							device_mixinfo_id : '<%=device_mixinfo_id%>',
							actionType : 'update'	
						});
					}
				}
				if(datas.length > 0 ){
					var retObj = jcdpCallService("DevCommInfoSrv", "toUpdateOrSaveCollectMixSub", "datas="+(JSON.stringify ||$.toJSON)(data));
					if(retObj.returnCode == 0){
						alert("数据保存成功");
						var ctt = parent.frames['list'].frames;
						ctt.window.refreshData();
						newClose();
					}else{
						alert(retObj.returmMsg);
					}
				}else{
					newClose();
				}
			}else{
				
			}
		}
	}
	function checkData(){
		var msg = "";
		var length = cruConfig.items.length;
		$("tr:gt(0)","#queryRetTable").slice(0,length).each(function(){
			var td = $(this).find("td:eq(7)");
			if(td.attr("isValidate") && td.attr("isValidate") != "true"){
				msg +=td.text()+"验证不通过\n";
			}
		});
		if(msg.length > 0){
			alert(msg);
			return false;
		}
	}
	function submitInfo(){
		var ctt = parent.frames['list'].frames;
		ctt.window.toEdit();
		ctt.window.refreshData();
		newClose();
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
</html>
 