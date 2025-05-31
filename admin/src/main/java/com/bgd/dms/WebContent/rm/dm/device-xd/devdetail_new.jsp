<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String taskId = request.getParameter("taskId");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
          <td class="inquire_item4">设备名称:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">规格型号:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
        
        <tr>
          <td class="inquire_item4"><span class="red_star">*</span>设备类型:</td>
          <td class="inquire_form4"><select name="select" id="select" class="select_width">
            <option>账内</option>
            <option>账外</option>
            <option>外租</option>
            </select></td>
          <td class="inquire_item4">实物标识号:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">自编号:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">牌照号:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">资产编码:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">所属单位:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">所在单位:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">所在地:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">使用情况:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">技术状况:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">设备负责人:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">固定资产原值:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">固定资产净值:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">出厂日期:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">投产日期:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
		<tr>
          <td class="inquire_item4">批次:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          
        </tr>
		
        <tr>
          <td class="inquire_item4">备注:</td>
          <td colspan="3" class="inquire_form4"><textarea name="textarea" id="textarea" cols="45" rows="5"></textarea></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
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
	function submitInfo(){
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevInfo.srq";
		document.getElementById("form1").submit();
	}
</script>
</html>

