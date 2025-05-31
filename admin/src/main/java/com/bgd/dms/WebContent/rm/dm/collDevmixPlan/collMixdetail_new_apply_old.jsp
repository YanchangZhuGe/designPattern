<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
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
<title>调配明细添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=deviceappid%>" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >配置计划单号:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >配置计划单名称:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配申请明细(采集附属设备)</legend>
		  <div style="height:80px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="5%">选择</td>
					<td class="bt_info_odd" width="5%">工序</td>
					<td class="bt_info_even" width="8%">班组</td>
					<td class="bt_info_odd" width="12%">申请名称</td>
					<td class="bt_info_even" width="15%">申请型号</td>
					<td class="bt_info_odd" width="3%">计量单位</td>
					<td class="bt_info_even" width="6%">需求道数</td>
					<td class="bt_info_odd" width="6%">已申请道数</td>
					<td class="bt_info_even" width="6%">申请道数</td>
					<td class="bt_info_odd" width="10%">用途</td>
					<td class="bt_info_even" width="12%">开始时间</td>
					<td class="bt_info_odd" width="12%">结束时间</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldset>
      <fieldset>
      	<table style="width:95%;" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="10%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="分配具体明细"></a></span></td>
          <td width="30%">
          <td id="selectmodeltd" width="50%" align="right" style="display:none">
          	<select id="selectmodel" name="selectmodel" class="select_width" style="width:180px">
          		<option value="">请选择模板...</option>
          	</select>&nbsp;&nbsp;&nbsp;&nbsp;
          </td>
          <td id="addtd" width="5%" align="right" style="display:none"><span class="zj"><a href="#" id="addbtn" onclick='toAddRowInfo()' title="新增"></a></span></td>
		  <td id="deltd" width="5%" align="right" style="display:none"><span class="sc"><a href="#" id="delbtn" onclick='toDelRowInfo()' title="删除"></a></span></td>
        </tr>
      </table>
	    <div id="tag-container_3" style="width:98%;">
		  <ul id="tags" class="tags">
		  </ul>
		</div>
		<div id="tab_box" class="tab_box" style="width:98%;height:120px;overflow:auto">
		</div>
		</fieldset>
		 <fieldset style="margin-left:2px"><legend>附属设备</legend>
		  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td width="5%"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
	          <td width="5%"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
	          <td width="90%"></td>
	        </tr>
	      </table>
		  <div id="tab_box" class="tab_box" style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_odd" width="4%">选择<input type="checkbox" name="alldetinfo" id="alldetinfo" checked/></td>
						<td class="bt_info_even" width="12%">班组</td>
						<td class="bt_info_odd" width="12%">设备名称</td>
						<td class="bt_info_even" width="12%">规格型号</td>
						<td class="bt_info_odd" width="10%">计量单位</td>
						<td class="bt_info_even" width="10%">调配数量</td>
						<td class="bt_info_odd" width="10%">备注</td>
					</tr>
				</table>
				<div style="height:90px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	 	<tbody id="addeddetailtable" name="addeddetailtable">
			    	</tbody>
					</table>
				</div>
			</div>
       </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var subcount = 0;
		var line_infos;
		var idinfos;
		var sub_line_infos;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked == true){
				var keyinfo = this.value;
				if(count == 0){
					line_infos = this.id;
					idinfos = keyinfo;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+keyinfo;
				}
				$("input[type='checkbox'][name='idinfo']","#detailList"+keyinfo).each(function(i){
					if(count == 0 ){
						if(i==0){
							sub_line_infos = this.id;
						}else{
							sub_line_infos += "@"+this.id;
						}
					}else{
						if(i==0){
							sub_line_infos += this.id;
						}else{
							sub_line_infos += "@"+this.id;
						}
					}
				});
				if(sub_line_infos!=undefined && sub_line_infos.length>0){
					sub_line_infos += "~";
				}
				count++;
			}
		});
		if(count == 0){
			alert('请选择调配设备申请明细信息！');
			return;
		}
		if(sub_line_infos == undefined){
			alert('请添加采集设备明细信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#applynum"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的申请数量!");
			return;
		}else{
			var subwrongflag = false;
			//判断子表是否有未填的设备明细数量
			sub_line_infos = sub_line_infos.substr(0,sub_line_infos.length-1);
			var checkinfos = sub_line_infos.split("~",-1);
			for(var index=0;index<checkinfos.length;index++){
				var checkinfo = checkinfos[index];
				var checksubinfos = checkinfo.split("@",-1);
				for(var j=0;j<checksubinfos.length;j++){
					var valueinfo = $("#apply_num"+checksubinfos[index]).val();
					if(valueinfo == ""){
						subwrongflag = true;
					}
				}
			}
			if(subwrongflag){
				alert("请设置采集设备明细的需求数量!");
				return;
			}
		}
		//数据都没问题，增加对道数申请的提示
		var appdaonum = $("input[id^='applynum']")[0].value;
		var totaldaonum =0;
		$("input[id^='totalslotnum']").each(function(i){
			if(this.value!=""){
				totaldaonum += parseInt(this.value,10);
			}
		});
		if(totaldaonum>appdaonum){
			if(!confirm("您添加的明细总道数为["+totaldaonum+"],大于申请道数["+appdaonum+"],是否继续?")){
				return;
			}
		}
		//补充明细的seq信息
		var addedcount = $("input[type='text'][name^='addeddevicename']","#addeddetailtable").size();
		var addedline_info;
		$("input[type='text'][name^='addeddevicename']","#addeddetailtable").each(function(i){
			var idindex = this.idindex;
			if(i==0){
				addedline_info = idindex;
			}else{
				addedline_info += "~"+idindex;
			}
		});
		alert(addedcount);
		alert(addedline_info);
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollMixAppDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&line_infos="+line_infos+"&sub_line_infos="+sub_line_infos+"&addedcount="+addedcount+"$addedline_info="+addedline_info;
		document.getElementById("form1").submit();
	}
	function toAddRowInfo(){
		var obj = new Object();
		var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		if(data!=undefined){
			//查找现在的显示标签页
			var divobj;
			$("div[name^='tab_box_content']","#tab_box").each(function(i){
				if(this.style.display == 'block'){
					divobj = this.idinfo;
				}
			});
			if(divobj == undefined)
				return;
			//查找最大的index
			var maxseqinfo = $("#detailList"+divobj+">tr:last").attr("seqinfo");
			if(maxseqinfo == undefined || maxseqinfo == ''){
				maxseqinfo = 0;
			}
			var currentseq = parseInt(maxseqinfo,10)+1;
			var innerhtml = "<tr id='tr"+divobj+currentseq+"' name='tr"+divobj+currentseq+"' seqinfo='"+currentseq+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+divobj+currentseq+"'/></td>";
			innerhtml += "<td>"+currentseq+"<input type='hidden' id='device_id"+divobj+currentseq+"' name='device_id"+divobj+currentseq+"' value='"+data.device_id+"'></td>";
			innerhtml += "<td><input name='devicename"+divobj+currentseq+"' id='devicename"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_name+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicemodel"+divobj+currentseq+"' id='devicemodel"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_model+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><select id='unitList"+divobj+currentseq+"' name='unitList"+divobj+currentseq+"' style='select_width'></select></td>";
			innerhtml += "<td><input name='devslotnum"+divobj+currentseq+"' id='devslotnum"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_slot_num+"' size='6' type='text' onclick='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='apply_num"+divobj+currentseq+"' id='apply_num"+divobj+currentseq+"' style='line-height:15px' value='' size='10' type='text' onclick='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='totalslotnum"+divobj+currentseq+"' id='totalslotnum"+divobj+currentseq+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
			innerhtml += "</tr>";
			$("#detailList"+divobj).append(innerhtml);
			
			$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
			$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
			$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
			$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
			//给当前这个单位追加数据
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#unitList"+divobj+currentseq).append(optionhtml);
		}
	}
	function toDelRowInfo(){
		//查找现在的显示标签页
		var divobj;
		$("div[name^='tab_box_content']","#tab_box").each(function(i){
			if(this.style.display == 'block'){
				divobj = this.idinfo;
			}
		})
		if(divobj == undefined)
			return;
		$("input[type='checkbox'][name='idinfo']","#detailList"+divobj).each(function(i){
			if(this.checked == true){
				var id=this.id;
				$("#tr"+id,"#detailList"+divobj).remove();
			}
		});
		$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
		$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
		$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
		$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
	}
	$().ready(function(){
		$("#selectmodel").change(function(){
			var value = $("#selectmodel").val();
			if(value == ''){
				return;
			}
			//获得当前显示的填报明细，给重新复制
			var divobj;
			$("div[name^='tab_box_content']","#tab_box").each(function(i){
				if(this.style.display == 'block'){
					divobj = this.idinfo;
				}
			})
			if(divobj == undefined)
				return;
			//先查询模板的子记录
			var querySql = "select sub.device_id,sub.device_name,sub.device_model,sub.unit_id,";
			querySql += "detail.coding_name as unit_name,sub.device_slot_num ";
			querySql += "from gms_device_collmodel_sub sub ";
			querySql += "left join gms_device_collectinfo ci on sub.device_id=ci.device_id ";
			querySql += "left join gms_device_collmodel_main main on main.model_mainid=sub.model_mainid ";
			querySql += "left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id ";
			querySql += "where main.bsflag='0' and sub.model_mainid='"+value+"' order by ci.dev_code ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				$("#detailList"+divobj).empty();
				var lineinfo;
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					lineinfo = index+1;
					var innerhtml = "<tr id='tr"+divobj+lineinfo+"' name='tr"+divobj+lineinfo+"' seqinfo='"+lineinfo+"'>";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+divobj+lineinfo+"' /></td>";
					innerhtml += "<td>"+lineinfo+"<input type='hidden' id='device_id"+divobj+lineinfo+"' name='device_id"+divobj+lineinfo+"' value='"+basedatas[index].device_id+"'></td>";
					innerhtml += "<td><input name='devicename"+divobj+lineinfo+"' id='devicename"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_name+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='devicemodel"+divobj+lineinfo+"' id='devicemodel"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_model+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='unit_name"+divobj+lineinfo+"' id='unit_name"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].unit_name+"' size='4' type='text' readonly/>";
					innerhtml += "<input name='unitList"+divobj+lineinfo+"' id='unitList"+divobj+lineinfo+"' value='"+basedatas[index].unit_id+"' type='hidden' /></td>";
					innerhtml += "<td><input name='devslotnum"+divobj+lineinfo+"' id='devslotnum"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_slot_num+"' size='6' type='text' readonly/></td>";
					innerhtml += "<td><input name='apply_num"+divobj+lineinfo+"' id='apply_num"+divobj+lineinfo+"' checkinfo='"+divobj+lineinfo+"' style='line-height:15px' value='' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
					innerhtml += "<td><input name='totalslotnum"+divobj+lineinfo+"' id='totalslotnum"+divobj+lineinfo+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
					innerhtml += "</tr>";
					$("#detailList"+divobj).append(innerhtml);
				}
				$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
				$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
				$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
				$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
			}
		})
	});
	function checkInputNum(obj){
		var lineid = obj.checkinfo;
		var devslotnum = $("#devslotnum"+lineid).val();
		if(devslotnum == ""){
			devslotnum = 0;
		}
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value==""){
			$("#totalslotnum"+lineid).val("");
			return;
		}
		if(!re.test(value)){
			alert("明细需求数量必须为数字!");
			obj.value = "";
			$("#totalslotnum"+lineid).val("");
        	return false;
		}
		$("#totalslotnum"+lineid).val(parseInt(devslotnum)*parseInt(value));
	}
	var seqinfo = 0;
	function toMixDetailInfos(){
		seqinfo++;
		var valueinfo ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked == true){
				valueinfo = this.value; 
			}
		});
		if(valueinfo == undefined)
			return;
		var size = $("div[id='tab_box_content"+valueinfo+"']","#tab_box").size();
		if(size==1){
			//给当前显示，其他的都隐藏
			$("div","#tab_box").hide();
			$("div[id='tab_box_content"+valueinfo+"']","#tab_box").show();
			//给标签页加个选中样式
			$("li","#tag-container_3").removeClass("selectTag");
			$("li[id='tag3_"+valueinfo+"']","#tag-container_3").addClass("selectTag");
		}else{
			var showid ;
			var showmodeltype ;
			$("input[type='checkbox'][name='detinfo']").each(function(){
				if(this.checked == true){
					showid = this.id;
					showmodeltype = this.devcodetype;
				}
			});
			var showname = $("#devicename"+showid).val()+"("+$("#devicetype"+showid).val()+")";
			var taginnerhtml = "<li id='tag3_"+valueinfo+"'><a href='#' onclick=getContentTab('"+valueinfo+"')>"+showname+"</a></li>";
			$("#tags").append(taginnerhtml);
			var containhtml = "<div style='width:97.5%' id='tab_box_content"+valueinfo+"' name='tab_box_content"+valueinfo+"' idinfo='"+valueinfo+"' style='width:97%' class='tab_box_content'>";
			containhtml += "<table border='0' cellpadding='0' cellspacing='0'  class='tab_line_height' style='width:99%' style='margin-top:10px;background:#efefef'>";
			containhtml += "<tr class='bt_info'><td class='bt_info_odd'>选择</td><td class='bt_info_even'>序号</td><td class='bt_info_odd'>设备名称</td><td class='bt_info_even'>规格名称</td>";
			containhtml += "<td class='bt_info_odd'>计量单位</td><td class='bt_info_even'>道数</td><td class='bt_info_odd'>需求数量</td><td class='bt_info_even'>总道数</td></tr>";
			containhtml += "<tbody id='detailList"+valueinfo+"' name='detailList"+valueinfo+"'></tbody></table></div> ";
			$("#tab_box").append(containhtml);
			//给当前显示，其他的都隐藏
			$("div","#tab_box").hide();
			$("div[id='tab_box_content"+valueinfo+"']","#tab_box").show();
			//给标签页加个选中样式
			$("li","#tag-container_3").removeClass("selectTag");
			$("li[id='tag3_"+valueinfo+"']","#tag-container_3").addClass("selectTag");
			//模板归零
			var querySql = "select model_mainid,model_name ";
			querySql += "from gms_device_collmodel_main main ";
			querySql += "where main.bsflag='0' and model_type='"+showmodeltype+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					var innerhtml = "<option value='"+basedatas[index].model_mainid+"'>"+basedatas[index].model_name+"</option>";
					$("#selectmodel").append(innerhtml);
				}
			}
			//给模板放进内容 end
			$("#selectmodel").val("");
			$("#selectmodeltd").show();
			$("#addtd").show();
			$("#deltd").show();
		}
	}
	function getContentTab(index) {
		$("li","#tag-container_3").removeClass("selectTag");
		$("li[id='tag3_"+index+"']","#tag-container_3").addClass("selectTag");
		$("div","#tab_box").hide();
		$("div[id='tab_box_content"+index+"']","#tab_box").show();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=deviceappid%>'!=null){
			var prosql = "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_name_input as dev_ci_name,aad.dev_codetype,";
			prosql += "devtype.coding_name as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
			prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
			prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
			prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
			prosql += "from gms_device_allapp_colldetail aad ";
			prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
			prosql += "left join comm_coding_sort_detail devtype on aad.dev_codetype = devtype.coding_code_id ";
			prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
			prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
			prosql += "left join gms_device_collapp da on allapp.device_allapp_id=da.device_allapp_id ";
			prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
			prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
			prosql += "left join ";
			prosql += "(select device_allapp_detid,dev_name_input,dev_codetype,sum(apply_num) as applyed_num ";
			prosql += "from (select cdet.project_info_no,cdet.bsflag,cdet.device_allapp_detid,cdet.dev_name_input,cdet.dev_codetype,cdet.apply_num ";
			prosql += "from gms_device_app_colldetail cdet join gms_device_collapp ca on cdet.device_app_id=ca.device_app_id and ca.bsflag='0') tmp2 ";
			prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_name_input,dev_codetype) ";
			prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
			prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0' ";
			prosql += "order by aad.teamid,aad.team ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		}
		//回填基本信息
		$("#project_name").val(retObj[0].project_name);
		$("#device_allapp_no").val(retObj[0].device_allapp_no);
		$("#device_allapp_name").val(retObj[0].device_allapp_name);
		for(var index=0;index<retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_allapp_detid+"' devcodetype='"+retObj[index].dev_codetype+"'/></td>";
			innerhtml += "<td><input name='jobname"+index+"' id='jobname"+index+"' style='line-height:15px' value='"+retObj[index].jobname+"' size='12' type='text' readonly/>";
			innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' /></td>";
			innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"' type='text' readonly/>";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";
			
			innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicetype"+index+"' id='devicetype"+index+"' value='"+retObj[index].dev_ci_model+"' size='15'  type='text' readonly/>";
			innerhtml += "<input name='dev_codetype"+index+"' id='dev_codetype"+index+"' value='"+retObj[index].dev_codetype+"' type='hidden' /></td>";
			
			innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='3' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";
			
			innerhtml += "<td><input name='neednum"+index+"' id='neednum"+index+"' value='"+retObj[index].require_num+"' size='5' type='text' /></td>";
			innerhtml += "<td><input name='applyednum"+index+"' id='applyednum"+index+"' value='"+retObj[index].applyed_num+"' size='5' type='text' readonly/></td>";
			innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' detindex='"+index+"' value='' size='5' type='text' onkeyup='checkAssignNum(this)'/></td>";
			
			innerhtml += "<td><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var neednumval = parseInt($("#neednum"+index).val(),10);
		var applyednumval = parseInt($("#applyednum"+index).val(),10);
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("申请数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>neednumval){
				if(!confirm("您添加的申请道数为["+value+"],大于需求道数["+neednumval+"],是否继续?")){
					obj.value = "";
					return false;
				}
			}else if((parseInt(value,10)+applyednumval)>neednumval){
				if(!confirm("您添加的申请道数为["+value+"],大于未申请道数["+(parseInt(neednumval,10)-parseInt(applyednumval,10))+"],是否继续?")){
					obj.value = "";
					return false;
				}
			}
		}
	}
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		//获得第一行的team信息
		var teamname = $("input[name^='teamname'][type='text']")[0].value;
		var team = $("input[name^='team'][type='hidden']")[0].value;
		addedseqinfo++;
		var innerhtml = "<tr id='tr"+addedseqinfo+"' name='tr"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+addedseqinfo+"'/></td>";
		innerhtml += "<td width='12%'><input name='addedteamname"+addedseqinfo+"' id='addedteamname"+addedseqinfo+"' value='"+teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
		innerhtml += "<input name='addedteam"+addedseqinfo+"' id='addedteam"+addedseqinfo+"' value='"+team+"' type='hidden' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedunit"+addedseqinfo+"' id='addedunit"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='8' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedassignnum"+addedseqinfo+"' id='addedassignnum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)'/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function toDelAddedDetailInfos(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id.substr(8);
				$("#tr"+index).remove();
			}
		});
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
</script>
</html>

