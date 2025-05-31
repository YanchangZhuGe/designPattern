<%@page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceallappid = request.getParameter("deviceallappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	//当前时间
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String nowdate = format.format(new Date());
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
<title>多项目-井中设备分中心-编辑明细子页面-添加设备需求界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend>设备申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >
          	申请单名称:
          	<input name="device_allapp_id" id="device_allapp_id" type="hidden" value="<%=deviceallappid%>" />
          </td>
          	<td class="inquire_form4" name="device_allapp_name" id="device_allapp_name" >
          </td>
           <td class="inquire_item4" >
          	申请单号:
          </td>
          	<td class="inquire_form4" name="device_allapp_no" id="device_allapp_no" >
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">明细添加时间:</td>
          	<input name="appdate" id="appdate" class="input_width" type="hidden" readonly/>
          <td class="inquire_form4" name="showappdate" id="showappdate" >
          </td>
          <td class="inquire_item4">明细添加人:</td>
          	<input name="employee_id" class="input_width" type="hidden" value="<%=userId%>"/>
          <td class="inquire_form4">
          	<%=userName%>
          </td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>设备申请信息</legend>
		<div id="tag-container_4" style="float:left">
		  <ul id="tags" class="tags">
		  </ul>
		</div>
		<div id="oprdiv0" name="oprdiv" style="float:left;width:70%;overflow:auto;">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ><a href="javascript:downloadModel('dev_model','单台设备配置计划模板')">单台设备配置计划模板</a></td>
			  		<auth:ListButton functionId="" css="dr" event="onclick='exportInData()'" title="导入excel"></auth:ListButton>
			    	<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv0" name="resultdiv" style="height:220px;">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
		       		<td class="bt_info_odd"><input type="checkbox" name="alldetinfo" id="alldetinfo" /></td>
					<td class="bt_info_even" width="20%">设备名称</td>
					<td class="bt_info_odd" width="20%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="7%">需求数量</td>
					<td class="bt_info_even" width="13%">开始时间</td>
					<td class="bt_info_odd" width="13%">结束时间</td>
					<td class="bt_info_even" width="15%">用途</td>
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
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var file="/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".xls";
		window.location.href="<%=contextPath%>"+file+"&filename="+filename+".xls";
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

	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=deviceallappid%>'!=null&&'<%=deviceallappid%>'!='null'){
			var proSql = "select devapp.device_allapp_id,devapp.device_allapp_no,devapp.device_allapp_name,devapp.remark, ";
			proSql += "to_char(sysdate,'yyyy-mm-dd') as appdate "; 
			proSql += "from gms_device_allapp devapp "; 
			proSql += "where devapp.bsflag='0' and devapp.device_allapp_id='<%=deviceallappid%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+'&pageSize=1000');
			retObj = proqueryRet.datas;
		}
		if(retObj.length>=1){
			$("#device_allapp_name").text(retObj[0].device_allapp_name);
			$("#device_allapp_no").text(retObj[0].device_allapp_no);
			$("#showappdate").text(retObj[0].appdate);
			$("#appdate").val(retObj[0].appdate);
		}
	}
	
	function addRows(value){
		
		if(value!="" && value !=undefined){
			var trData = value.split(",");
			for(var i=0;i<trData.length;i++){
				var innerhtml = "";
				var unit;
				var tdData = trData[i].split("@");
				teamName = tdData[0];
				unit = tdData[3];
				innerhtml += "<tr id='tr"+i+"' name='tr"+i+"' seq='"+i+"'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+i+"'/></td><td width='16%'>";				
				innerhtml += "<td width='20%'><input name='devicename"+i+"' id='devicename"+i+"' style='line-height:15px' value='"+tdData[1]+"' size='15' type='text' />";
				innerhtml += "<td width='20%'><input name='devicetype"+i+"' id='devicetype"+i+"' value='"+tdData[2]+"' size='16'  type='text' /></td>";
				innerhtml += "<td width='7%'><select name='unit"+i+"' id='unit"+i+"' /></select></td>";
				innerhtml += "<td width='7%'><input name='neednum"+i+"' id='neednum"+i+"' value='"+tdData[4]+"' size='4' type='text' onkeyup='checkAppNum(this,\"approvenum"+i+"\")'/>";
				innerhtml += "<input name='approvenum"+i+"' id='approvenum"+i+"' value='"+tdData[4]+"' size='4' type='hidden'/></td>";
				innerhtml += "<td width='13%'><input name='startdate"+i+"' id='startdate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[5]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+i+",tributton2"+i+");'/></td>";
				innerhtml += "<td width='13%'><input name='enddate"+i+"' id='enddate"+i+"' style='line-height:15px' size='10' type='text' value='"+tdData[6]+"'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+i+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+i+",tributton3"+i+");'/></td>";			
				innerhtml += "<td width='15%'><input name='purpose"+i+"' value='"+tdData[7]+"' size='10' type='text'/></td>";
				
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
					if(retObj[index].coding_name ==unit){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
					}else{
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
					}
				}
				$("#unit"+i).append(optionhtml);
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		}else{
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
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"'/></td>";			
			innerhtml += "<td width='20%'><input name='devicename"+tr_id+"' id='devicename"+tr_id+"' style='line-height:15px' value='' size='15' type='text' /></td>";
			innerhtml += "<td width='20%'><input name='devicetype"+tr_id+"' id='devicetype"+tr_id+"' value='' size='16'  type='text' /></td>";
			innerhtml += "<td width='7%'><select name='unit"+tr_id+"' id='unit"+tr_id+"' /></select></td>";
			innerhtml += "<td width='7%'><input name='neednum"+tr_id+"' id='neednum"+tr_id+"' value='' size='4' type='text' onkeyup='checkAppNum(this,\"approvenum"+tr_id+"\")'/>";
			innerhtml += "<input type='hidden' id='approvenum"+tr_id+"' name='approvenum"+tr_id+"'></td>";			
			innerhtml += "<td width='13%'><input value='' name='startdate"+tr_id+"' id='startdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+tr_id+",tributton2"+tr_id+");'/></td>";
			innerhtml += "<td width='13%'><input value='' name='enddate"+tr_id+"' id='enddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+tr_id+",tributton3"+tr_id+");'/></td>";
			innerhtml += "<td width='15%'><input name='purpose"+tr_id+"' value='' size='10' type='text'/></td>";
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
		}
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

	function checkAppNum(obj,approveobj){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("调配数量必须为数字，且大于0!");
			obj.value = "";
		}
		document.getElementById(approveobj).value=obj.value;
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
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAppDetailInfo.srq?count="+count+"&line_infos="+line_infos;
		document.getElementById("form1").submit();
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

