<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
    String folderID = request.getParameter("id").toString();
    
    System.out.println("The folderID is:"+folderID);  
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传文档</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<!-- 上传控件相关的js css-->
<link rel="stylesheet" href="<%=contextPath %>/js/upload/uploadify.css" type="text/css"></link>
<script type="text/javascript" src="<%=contextPath %>/js/upload/jquery.uploadify.v2.1.4.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/uploadfile.js"></script>
</head>
<body>
<form name="form1" id="form1" method="post" action="<%=contextPath%>/doc/uploadFileNew.srq">

<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	
  	<tr>
    	<td colspan="4" align="center">上传文档
    	<input type="hidden" name="folder_id" value="<%=folderID%>"/>
    	<input type="hidden" name="upload_file_name" id="upload_file_name" />
    	</td>
    	
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>文档编号：</td>
      	<td class="inquire_form4"><input type="text" name="doc_number" id="doc_number" class="input_width" /></td>
		<td class="inquire_item4">文档标题：</td>
      	<td class="inquire_form4"><input type="text" name="doc_name" id="doc_name" class="input_width" /></td>
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>文档：</td>
    	<td colspan = "3"> 
       	 	<div style="float:left" id="fileQueue" style="border:1px solid green;width:400px"></div>
			<div id="file_content" style="float:left"> <input type="file"  name="file" id="file"/>	 </div>
			<div id="status-message"></div> 
		</td>	
    </tr>
  	<tr>
    	<td colspan="4" align="center">
    		<input type="button" id="showall" name="showall" value="显示其他字段" onclick="showAll()"/>
    	</td>   	
    </tr>
	</table>

<div id="showinfo" style="display:none;">
    <table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	    <tr>
        <td class="inquire_item4">文档类型：</td>
      	<td class="inquire_form4">
      		<select name="doc_type" id="doc_type" class="select_width">
	      		<option value="0">-请选择-</option>
	      		<option value="word">word</option>
	      		<option value="excel">excel</option>
	      		<option value="ppt">PowerPoint</option>
	      		<option value="pdf">PDF</option>
	      		<option value="txt">TXT</option>
	      		<option value="picture">图片文件</option>
	      		<option value="compress">压缩文件</option>
	      		<option value="other">其他文件</option>
	      	</select>
      	</td>
		<td class="inquire_item4">重要程度：</td>
      	<td class="inquire_form4">
	      	<select name="doc_importance" id="doc_importance" class="select_width">
	      		<option value="0">-请选择-</option>
	      		<option value="1">高</option>
	      		<option value="2">中</option>
	      		<option value="3">低</option>
	      	</select>
      	</td>
    </tr>    
   <tr>
      	<td class="inquire_item4">关键字</td>
      	<td class="inquire_form4">
      		<input type="text" name="doc_keyword" id="doc_keyword" class="input_width"/>
      	</td>
      	<td class="inquire_item4">是否模板：</td>
      	<td class="inquire_form4">
      	    <select name="doc_template" id="doc_template" class="select_width">
	      		<option value="0">-请选择-</option>
	      		<option value="1">是</option>
	      		<option value="2">否</option>
	      	</select>
      	</td>
    </tr> 
    <tr>
		<td class="inquire_item4">摘要：</td>
      	<td class="inquire_form4"><input type="text" name="doc_brief" id="doc_brief" class="input_width"/></td>
      	<td class="inquire_item4">分数</td>
      	<td class="inquire_form4">
      		<select name="doc_score" id="doc_score" class="select_width">
	      		<option value="0">-请选择-</option>
	      		<option value="10">10</option>
	      		<option value="20">20</option>
	      		<option value="30">30</option>
	      		<option value="40">40</option>
	      		<option value="50">50</option>
	      		<option value="60">60</option>
	      		<option value="70">70</option>
	      		<option value="80">80</option>
	      		<option value="90">90</option>
	      		<option value="100">100</option>
	      	</select>
      	</td>
    </tr>    
	</table>
</div>

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
	
	cruConfig.contextPath =  "<%=contextPath%>";
	var nowDate = new Date();
	var folder_id = "<%=folderID%>";
	var fileNumber = "";
	var fileNumberFormat = "";
	var fileAbbr = "";
	var querySql = "Select n.file_number_value as file_number_format,b.file_abbr FROM bgp_doc_gms_file b join bgp_doc_file_number n on b.file_number_format = n.bgp_doc_file_number_id WHERE b.file_id = '"+folder_id+"' and b.bsflag='0' and b.is_file='0' and b.ucm_id is null";
	var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
	if(queryOrgRet.datas.length != 0){
		fileNumberFormat = queryOrgRet.datas[0].file_number_format; 
		fileAbbr = queryOrgRet.datas[0].file_abbr; 
	}
	if(fileNumberFormat != ""){
		var params = fileNumberFormat.split("_");
		fileNumber = fileNumber+params[0];
		for(var i=1;i<params.length;i++){
			var param = params[i];
			if(param == "[folder]"){
				if(fileAbbr != ""){
					fileNumber= fileNumber+"-"+fileAbbr;
				}
				continue;
			}
			if(param == "[year]"){
				fileNumber= fileNumber+"-"+getYearValue();
				continue;
			}
			if(param == "[month]"){
				fileNumber= fileNumber+getMonthValue();
				continue;
			}
			if(param == "[day]"){
				fileNumber= fileNumber+getDateValue();
				continue;
			}
		}
		
		if(params[params.length-1] != "year"&&params[params.length-1] != "month" && params[params.length-1] != "day"){
			var lastLength = params[params.length-1];
			var timeValue = getTimeValue()+"";
			var timeValueLength = timeValue.length;
			var lastStr = timeValue.substring(timeValueLength-4,timeValueLength);
			fileNumber = fileNumber + "-" + lastStr;
		}
		document.getElementById("doc_number").value = fileNumber;
	}	
		

	function cancel()
	{
		window.close();
	}
										
	function save(){	
		if (!checkForm()) return;
		document.getElementById("form1").submit();
	}
	
	function checkForm(){ 	

		if (!isTextPropertyNotNull("doc_content", "文档内容")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}		
	
	function refreshData(){
			if(checkUploadFile()){
				document.getElementById("form1").submit();
			}
	}
	
	function showAll(){
		var showall = document.getElementById("showall").value;
		if(showall == "隐藏其他字段"){
			document.getElementById("showinfo").style.display="none";
			document.getElementById("showall").value = "显示其他字段";
		}else if(showall == "显示其他字段"){
			document.getElementById("showinfo").style.display="";
			document.getElementById("showall").value = "隐藏其他字段";
		}	
	}
	
</script>
</html>