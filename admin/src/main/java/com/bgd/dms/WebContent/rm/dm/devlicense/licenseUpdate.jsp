<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String licensetype = request.getParameter("licensetype");
	String devaccid = request.getParameter("devaccid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备入库明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
                
				<td class="inquire_item6"><font color=red>*</font>&nbsp;注册登记日期</td>
				<td class="inquire_form6"><input id="dev_reg_date" name="dev_reg_date" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(dev_reg_date,tributton1);" />
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;审检周期</td>
				<td class="inquire_form6">
				<select class="input_width"   name="dev_audie_cycle" id="dev_audie_cycle">
					<option value="5110000037000000001" selected="selected">6月</option>
					<option value="5110000037000000002">12月</option>
					<option value="5110000037000000003">24月</option>
				</select>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;末次审检时间</td>
				<td class="inquire_form6"><input id="last_audit_date" name="last_audit_date" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(last_audit_date,tributton2);" />
				</td>
				
			  </tr>
				<tr>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;有效期限</td>
				<td class="inquire_form6"><input id="validate_end" name="validate_end" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(validate_end,tributton3);" />
				</td>
				
				<td class="inquire_item6">有效天数</td>
				<td class="inquire_form6">
					<input id="date_num" name="date_num" class="input_width" type="text" readonly="readonly" />
				</td>
				<td class="inquire_item6">计划时间1</td>
				<td class="inquire_form6"><input id="plan_audit_date_1" name="plan_audit_date_1" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(plan_audit_date_1,tributton4);" />
				</td>
				
			  </tr>
			  <tr>
			  	<td class="inquire_item6">计划时间2</td>
				<td class="inquire_form6"><input id="plan_audit_date_2" name="plan_audit_date_2" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(plan_audit_date_2,tributton5);" />
				</td>
				<td class="inquire_item6">计划时间3</td>
				<td class="inquire_form6"><input id="plan_audit_date_3" name="plan_audit_date_3" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(plan_audit_date_3,tributton6);" />
				</td>
				<td class="inquire_item6">计划时间4</td>
				<td class="inquire_form6"><input id="plan_audit_date_4" name="plan_audit_date_4" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton7" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(plan_audit_date_4,tributton7);" />
				</td>
			  </tr>
				
      </table>
      
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
	var dev_license_id="";
	
	function loadDataDetail(){
		
		var dev_acc_id = '<%=devaccid%>';
		var licensetype = '<%=licensetype%>';
		var retObj;
		if(dev_acc_id!=null){
		    var querySql="select * ";
		    	querySql+="from gms_device_license ";
				querySql+="where dev_acc_id='"+dev_acc_id+"' and license_type="+licensetype;
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		        retObj = queryRet.datas;
		}
		
		document.getElementById("dev_reg_date").value =retObj[0].dev_reg_date;
		document.getElementById("dev_audie_cycle").value =retObj[0].dev_audie_cycle;
		document.getElementById("last_audit_date").value =retObj[0].last_audit_date;
		document.getElementById("validate_end").value =retObj[0].validate_end;
		document.getElementById("plan_audit_date_1").value =retObj[0].plan_audit_date_1;
		document.getElementById("plan_audit_date_2").value =retObj[0].plan_audit_date_2;
		document.getElementById("plan_audit_date_3").value =retObj[0].plan_audit_date_3;
		document.getElementById("plan_audit_date_4").value =retObj[0].plan_audit_date_4;
		
		dev_license_id=retObj[0].dev_license_id;
		var licensetype = '<%=licensetype%>';
		
	}
	
	
	function submitInfo(){
		if(document.getElementById("dev_reg_date").value==""){
			alert("注册登记日期不能为空！");
			return;
		}
		if(document.getElementById("dev_audie_cycle").value==""){
			alert("审检周期不能为空！");
			return;
		}
		if(document.getElementById("last_audit_date").value==""){
			alert("末次审检时间不能为空！");
			return;
		}
		if(document.getElementById("validate_end").value==""){
			alert("有效期限不能为空！");
			return;
		}
		
		
		var dev_acc_id = '<%=devaccid%>';
		var licensetype = '<%=licensetype%>';
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitLicense.srq?dev_acc_id="+dev_acc_id+"&licensetype="+licensetype+"&dev_license_id="+dev_license_id;
		document.getElementById("form1").submit();
		//newClose();
		
	}
	
</script>
</html>

