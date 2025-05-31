<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
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
      <fieldset style="margin-left:2px"><legend>模板基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >
          	模板名称:
          </td>
          <td class="inquire_item4" >
          	<input name="dev_model_name" id="dev_model_name" class="input_width" type="text"  value=""  />
          	<input name="model_type" id="model_type" class="input_width" type="hidden"  value=""  />
          </td>
           <td class="inquire_item4" > </td>
           <td class="inquire_item4" > </td>
          </tr>
      </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>设备信息</legend>
		<div id="tag-container_4" style="float:left">
		  <ul id="tags" class="tags">
		    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">单台管理</a></li>
		    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">批量管理</a></li>
		  </ul>
		</div>
		<div id="oprdiv0" name="oprdiv" style="float:left;width:70%;overflow:auto;">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_query">
			    	<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加按台管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除按台管理设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv0" name="resultdiv" style="float:left;height:210px;">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="17%">设备名称</td>
					<td class="bt_info_odd" width="16%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="11%">备注</td>
				</tr>
		      </table>
		      <div style="height:183px;overflow:auto;">
		      	<table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
		  </div>
		  <div id="oprdiv1" name="oprdiv" style="float:left;width:70%;overflow:auto;display:none">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_query">
			    	<auth:ListButton functionId="" css="zj" event="onclick='addCollRows()'" title="添加按量管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delCollRows()'" title="删除按量管理设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv1" name="resultdiv" style="float:left;height:210px;overflow:auto;display:none">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="17%">设备名称</td>
					<td class="bt_info_odd" width="16%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="11%">备注</td>
				</tr>
			   <tbody id="processtable1" name="processtable1" >
			   </tbody>
		      </table>
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
		$("#model_type").append(index);
	}
	function addRows(){
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
		innerhtml += "<td width='16%'><input type='checkbox' name='idinfo' id='"+tr_id+"'/>";
		
		innerhtml += "<input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly/>";
		innerhtml += "<input type='button' style='width:20px' value='...' onclick='showDevPage("+tr_id+")'/></td>";
		
		innerhtml += "<td width='16%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='' size='16'  type='text' />";
		innerhtml += "<input name='sign_type"+tr_id+"' id='sign_type"+tr_id+"' value='' type='hidden' />";
		innerhtml += "<input name='is_dev_code"+tr_id+"' id='is_dev_code"+tr_id+"' value='' type='hidden' /></td>";
		
		innerhtml += "<td width='7%'><select name='unit"+tr_id+"' id='unit"+tr_id+"' /></select></td>";
		innerhtml += "<td width='11%'><input name='purpose"+tr_id+"' value='' size='10' type='text'/></td>";
		innerhtml += "</tr>";
		
		$("#processtable0").append(innerhtml);
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
	};
	function delRows(){
		$("input[name='idinfo']").each(function(){
			if(this.checked == true){
				$('#tr'+this.id,"#processtable0").remove();
			}
		});
		
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	function addCollRows(){
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
		
		innerhtml += "<td><input type='checkbox' name='collidinfo' id='"+tr_id+"'/>";
		innerhtml += "<input name='coll_dev_name"+tr_id+"' id='coll_dev_name"+tr_id+"' style='line-height:15px' value='用户输入名称' size='15' type='text' /></td>";
		
		innerhtml += "<td><select name='coll_dev_type"+tr_id+"' id='coll_dev_type"+tr_id+"' class='select_width' ></selcted></td>";
		
		innerhtml += "<td><select name='coll_unit"+tr_id+"' id='coll_unit"+tr_id+"' /></select></td>";
		innerhtml += "<td><input name='coll_purpose"+tr_id+"' id='coll_purpose"+tr_id+"' class='input_width' value='' size='10' type='text'/></td>";
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
		$("#coll_dev_type"+tr_id).append(colltypeoptionhtml);
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
		$("#coll_unit"+tr_id).append(optionhtml);
		
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
	};
	function delCollRows(){
		$("input[name='collidinfo']").each(function(){
			if(this.checked==true){
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
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devModel/toSaveModelDetailInfo.srq?count="+count+"&line_infos="+line_infos+"&collcount="+collcount+"&collline_infos="+collline_infos;
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
				$("input[name='dev_name"+trid+"']","#processtable0").val(devicename);
				$("input[name='dev_type"+trid+"']","#processtable0").val(devicetype);
			}else{
				$("input[name='dev_name"+trid+"']","#processtable0").val(obj.name);
				$("input[name='dev_type"+trid+"']","#processtable0").val("");
			}
			$("input[name='sign_type"+trid+"']","#processtable0").val(obj.code);
			$("input[name='is_dev_code"+trid+"']","#processtable0").val(obj.isdevicecode);
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
</script>
</html>

