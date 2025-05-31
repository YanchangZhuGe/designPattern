<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String dev_acc_id=request.getParameter("dev_acc_id");
	if(dev_acc_id==null){
	dev_acc_id="";
	}
	String devspecial_id=request.getParameter("devspecial_id");
	if(devspecial_id==null){
	devspecial_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 <%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备添加</title>
</head>
<body class="bgColor_f3f3f3" onload="pageInit()">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data" >
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    <fieldset><legend>审验信息&nbsp;&nbsp;  </legend> 
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;检验单位</td>
				<td class="inquire_form6">
					<input id="dev_acc_id" name="dev_acc_id" class="easyui-textbox" value="<%=dev_acc_id%>" type="hidden" />		
					<input id="dev_acc_id" name="devspecial_id" class="easyui-textbox" value="<%=devspecial_id%>" type="hidden" />					 			 
					<input id="check_unit" name="check_unit"  class="input_width" type="text" />
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;检验日期</td>
				<td class="inquire_form6">
				  <input type="text" name="check_date" id="check_date"  class="input_width easyui-datebox" style="width:130px" editable="false" required/>
				</td>
				<!--<td class="inquire_item6"><font color=red>*</font>&nbsp;检验类别</td>
				<td class="inquire_form6"><input id="check_type" name="check_type" class="input_width" type="text"  /></td>-->
				<td class="inquire_item6"><font color=red>*</font>&nbsp;检验结论</td>
				<td class="inquire_form6">
				<input id="check_result" name="check_result" class="input_width" type="text" />	 
				</td>
			  </tr>
				<tr>
				<!--<td class="inquire_item6"><font color=red>*</font>&nbsp;安全级别</td>
				<td class="inquire_form6"><input id="safe_level" name="safe_level" class="input_width" type="text" /></td>-->
				<td class="inquire_item6">主要问题</td>
				<td class="inquire_form6"><input id="main_question" name="main_question" class="input_width" type="text" /></td>				
				<td class="inquire_item6">下次检验日期</td>
				<td class="inquire_form6"> 
				  <input type="text" name="next_date" id="next_date"   class="input_width easyui-datebox" style="width:130px" editable="false" required/>
				</td>
				   
			<td class="inquire_item6">&nbsp;报告附件：</td>
  			<td class="inquire_form6" colspan="1"><input type="file" name='bg_file' id='bg_file' class="input_width" style="width: 100%"/></td>
		 
			  </tr>
			  <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_skill_tablePublic">
				<input name="skill_parameter_report" id="skill_parameter_report" type="hidden" />
			 </table>
		   </td>
		 </tr>
      </table>
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
	
	function pageInit(){
		var devspecial_id='<%=devspecial_id%>';
	 
		if(devspecial_id!=''){
		var querySql="select * from GMS_DEVICE_DEVSPECIAL where devspecial_id='"+devspecial_id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		datas = queryRet.datas;
		document.getElementById("check_unit").value=datas[0].check_unit;
		//document.getElementById("check_type").value=datas[0].check_type;
		document.getElementById("check_result").value=datas[0].check_result;
		//document.getElementById("safe_level").value=datas[0].safe_level;
		document.getElementById("main_question").value=datas[0].main_question;
 		$("#next_date").datebox('setValue',datas[0].next_date);
		$("#check_date").datebox('setValue',datas[0].check_date);
		}
		

	}
	 
 	/**
	 * 提交
	 */
	function submitInfo(){

		if(document.getElementById("check_unit").value==""){
			alert("请输入检验单位");
			return;
		}
		if($("#check_date").datebox('getValue')==""){
			alert("请输入检验日期");
			return;
		}
		//var devtype = document.getElementById("check_type").value;
		//if(devtype==""){
		//	alert("请输入检验类别");
		//	return;
	//	}
		var check_result = $("#check_result").val();
		if(check_result==""){
			alert("请输入检验结论");
			return;
		}
		//if(document.getElementById("safe_level").value==""){
		//	alert("请输入安全级别");
		//	return;
		//}
		if(document.getElementById("main_question").value==""){
			alert("请输入主要问题");
			return;
		}
		if($("#next_date").datebox('getValue')==""){
			alert("请输入下次检验时间");
			return;
		}
		var querySql;
	  
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitCheck.srq";
			document.getElementById("form1").submit();
		 
	} 
	
</script>
</html>

