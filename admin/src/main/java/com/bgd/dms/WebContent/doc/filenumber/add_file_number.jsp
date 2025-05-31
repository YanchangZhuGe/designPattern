<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
    //获取当前的项目编号，作为树的最顶层
    //String node_id = request.getParameter("nodeID").toString();
    //String node_text = new String(request.getParameter("nodeText").toString().getBytes(),"UTF-8");
    //String node_number= request.getParameter("nodeNumber").toString();
    //String folder_id = request.getParameter("folderID").toString();
    //System.out.println("node number is:"+node_number);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传文档公共</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
</head>
<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>		
    	<td colspan="4" align="center">设置文档编号(前缀+文件夹编号+日期+尾号)</td>
    </tr>
    <tr>
    	<td class="inquire_item4">
    		编号名称：
    	</td>
      	<td class="inquire_form4">
      		<input type="text" name="number_name" id="number_name" class="input_width"/>
      	</td>
    	<td class="inquire_item4">
    		编号前缀：
    	</td>
      	<td class="inquire_form4">
      		<input type="text" name="number_prefix" id="number_prefix" class="input_width"/>
      	</td>
    </tr>
    <tr> 	
        <td class="inquire_item4">
      		是否使用所属文件夹编号：
      	</td>
      	<td class="inquire_form4">
			<input type="checkbox" name="folderAbbr_checkbox" id="folderAbbr_checkbox"/>
      	</td>
      	<td class="inquire_item4">
      		日期格式：
      	</td>
      	<td class="inquire_form4">
      		<input type="checkbox" name="year_checkbox" id="year_checkbox"/>年
      		<input type="checkbox" name="month_checkbox" id="month_checkbox"/>月
      		<input type="checkbox" name="day_checkbox" id="day_checkbox"/>日
      	</td>
    </tr>
    <tr>
    	<td class="inquire_item4">尾号位数：</td>
      	<td class="inquire_form4">
			<select name="serialNumber" id="serialNumber" class="select_width">
				<option value="0">--无--</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
			</select>
		</td>
		<td class="inquire_item4"><span><a href="#" onclick="viewFormat()">预览</a></span></td>
      	<td class="inquire_form4">
      		<input type="text" name="formatText" id="formatText" class="input_width"/>
      		<input type="hidden" name="saveText" id="saveText"/>
      	</td>
    </tr>          
</table>
</div>
    <div id="oper_div">
        <auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	
	var module_name = top.frames("topFrame").selectedTag.childNodes[0].innerHTML;
	var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;
	

	function cancel()
	{
		window.close();
	}
										
	function refreshData(){
		viewFormat();
		
		var useFolderabbr = "0";
		var useYear = "0";
		var useMonth = "0";
		var useDay = "0";
		
		//encodeURI(encodeURI(service_info));
		var saveData = document.getElementById("saveText").value;
		var demoData = document.getElementById("formatText").value;
		var numberName = document.getElementById("number_name").value;
		var numberPrefix = document.getElementById("number_prefix").value;
		
		if(document.getElementById("folderAbbr_checkbox").checked == true){
			useFolderabbr = "1";
		}
		if(document.getElementById("year_checkbox").checked == true){
			useYear = "1";
		}
		if(document.getElementById("month_checkbox").checked == true){
			useMonth = "1";
		}
		if(document.getElementById("day_checkbox").checked == true){
			useDay = "1";
		}
		var serialNumberLength = document.getElementById("serialNumber").value;
		
		if(saveData != ""){
			alert("保存数据");
			document.getElementById("form1").action = "<%=contextPath%>/doc/saveNumberFormat.srq?userfolderabbr="+useFolderabbr+"&useyear="+useYear+"&usemonth="+useMonth+"&useday="+useDay+"&seriallength="+serialNumberLength+"&savetext="+saveData+"&numberprefix="+numberPrefix+"&numbername="+numberName;
			document.getElementById("form1").submit();
		}else{
			alert("请填写格式信息!");
			document.getElementById("formatText").value = "";
			return;
		}
	}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("doc_number", "文档编号")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}	
	
	function viewFormat(){
		var demo_text = "";
		var save_text = "";
		
		var number_name = document.getElementById("number_name").value;
		if(number_name == ""||number_name == undefined){
			alert("请填写编号名称");
			return;
		}
		
		var number_prefix = document.getElementById("number_prefix").value;
		if(number_prefix != ""&&number_prefix != undefined){
			demo_text = demo_text+number_prefix;
			save_text = save_text + number_prefix;
		}else{
			alert("请填写前缀");
			return;
		}
		
		if(document.getElementById("folderAbbr_checkbox").checked == true){
			demo_text = demo_text+"-SCYB";
			save_text = save_text +"_[folder]";
		}
		
		if(document.getElementById("year_checkbox").checked == true){
			demo_text = demo_text+"-2012";
			save_text = save_text +"_[year]";
		}
		
		if(document.getElementById("month_checkbox").checked == true){
			demo_text = demo_text+"08";
			save_text = save_text +"_[month]";
		}

		if(document.getElementById("day_checkbox").checked == true){
			demo_text = demo_text+"23";
			save_text = save_text +"_[day]";
		}
		
		var serialNumberLength = parseInt(document.getElementById("serialNumber").value);
		var serialNumber="";
		if(serialNumberLength != 0){
			for(var k=0;k<serialNumberLength;k++){
				serialNumber=serialNumber+"0";
			}
			demo_text = demo_text + "-"+serialNumber;
			save_text = save_text + "_"+serialNumberLength;
		}
		document.getElementById("formatText").value = demo_text;
		document.getElementById("saveText").value = save_text;
	}
</script>

</html>