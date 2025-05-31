<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%
	String contextPath = request.getContextPath();
	System.out.println("--------->"+request.getInputStream().toString());
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>


<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
	var content="";
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
		if(filename !=""){
			if(check(filename)){
				document.getElementById("confirmButton").disabled="disabled";			
				document.getElementById("fileForm").submit();
			}
		}	
	}
	function alertError(str){
		
		alert(str);
	}
	function returnFile(){
		var returncheck = "";
		if(content != ""){			
			returncheck = content;			
		}

		window.returnValue = returncheck;
		window.close();
	}
	function returnNull(){
		window.returnValue = "";
		window.close();
	}
	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
			
</script>
<title>选择要导入的文件</title>
</head>
<body>
<form action="<%=contextPath%>/rm/em/singleHuman/supplyHumanPlan/humanPlanImportFile_t.jsp" id="fileForm" method="post" enctype="multipart/form-data" target="targetIframe">
<table width="96%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	<tr>
		<td class="inquire_item4">选择文件：</td>
		<td class="inquire_form4"><input type="file" id="fileName" name="fileName" onChange="uploadFile()" class="input_width">
	</tr>
</table>

    <div id="oper_div">
        <input name="Submit" type="button"  id="confirmButton"  onClick="returnFile()" value="确定" />
		<input name="Submit" type="button"  id="confirmButton"  onClick="returnNull()" value="取消" />
    </div>

<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>