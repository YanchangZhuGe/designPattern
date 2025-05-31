<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String devicehirebackid = request.getParameter("devicehirebackid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>外租设备添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin:2px:padding:2px;"><legend>外租申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">外租返还单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="device_hire_out_name" id="device_hire_out_name" class="input_width" type="text" value="" />
          	<input name="device_hire_out_id" id="device_hire_out_id" class="input_width" type="hidden" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">外租返还单号:</td>
          <td class="inquire_form4">
          	<input name="device_hire_out_no" id="device_hire_out_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">返还时间:</td>
          <td class="inquire_form4">
          	<input name="out_date" id="out_date" class="input_width" type="text" value="" readonly/>
          	<img src='<%=contextPath%>/images/calendar.gif' id='tributton2' width='16' height='16' style='cursor: hand;'onmouseover='calDateSelector(out_date,tributton2);'/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">经办人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>设备申请明细</legend>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even">计量单位</td>
					<td class="bt_info_odd" >自编号</td>
					<td class="bt_info_even">实物标识号</td>
					<td class="bt_info_odd" >牌照号</td>
				</tr>
				</table>
			   <div style="height:190px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
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
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var line_infos;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
				}else{
					line_infos += "~"+this.id;
				}
				count++;
			}
		});
		if(count == 0){
			alert('请选择调配设备申请明细信息！');
			return;
		}
		
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devhireout/hireOut_new_apply.srq?count="+count+"&line_infos="+line_infos;
		document.getElementById("form1").submit();
	}
	function checkDevrental(obj){
		var value = obj.value;
		var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("申请数量必须为数字!");
			obj.value = "";
        	return false;
		}
	}
	function refreshData(){
		var querySql = "select t.device_hire_out_id,t.device_hire_out_no,t.device_hire_out_name,t.out_date,d.dev_acc_id,d.dev_name,d.dev_model,d.self_num,d.dev_sign,d.license_num from gms_device_hire_out t left join gms_device_hire_out_detail d on t.device_hire_out_id=d.device_hire_out_id where t.device_hire_out_id='<%=devicehirebackid%>'";
		var dataret = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		var retObj = dataret.datas;
		for(var index=0;index<retObj.length;index++){
			$("#device_hire_out_id").val(retObj[0].device_hire_out_id);
			$("#device_hire_out_no").val(retObj[0].device_hire_out_no);
			$("#device_hire_out_name").val(retObj[0].device_hire_out_name);
			$("#out_date").val(retObj[0].out_date);
		}
		addLine(retObj);
	}
	function addRows(value){
			var paramobj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devhireout/selectAccountForBack.jsp",paramobj,"dialogWidth=800px;dialogHeight=480px");
			if(vReturnValue == undefined){
				return;
			}
			var accountidinfos = vReturnValue.split("|","-1");
			var condition ="";
			if(accountidinfos.length == 1){
				var accountids = accountidinfos[0].split("~", -1);
				condition = "('"+accountids[0]+"') ";
			}else{
				for(var index=0;index<accountidinfos.length;index++){
					var accountids = accountidinfos[index].split("~", -1);
					if(index == 0){
						condition = "('"+accountids[0]+"'";
					}else{
						condition += ",'"+accountids[0]+"'";
					}
				}
				condition += ") ";
			}
			var devdetSql="select * from gms_device_account account where account.dev_acc_id in "+condition ;
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
			var retObj = proqueryRet.datas;
			addLine(retObj);
	};
	function addLine(retObj){
		var rows = document.getElementById("processtable0").rows.length;
		for(var index=rows;index<rows+retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index-rows].dev_acc_id+"' name='tr' midinfo='"+retObj[index-rows].dev_acc_id+"'>";
			innerhtml += "<td width='4%'><input type='checkbox' name='idinfo' id='"+retObj[index-rows].dev_acc_id+"'/></td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].self_num+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index-rows].dev_sign+"</td>";
			innerhtml += "<td width='11%'>"+retObj[index-rows].license_num+"</td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}
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
</script>
</html>

