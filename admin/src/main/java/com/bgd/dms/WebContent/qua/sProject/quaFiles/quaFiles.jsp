<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("project_info_no");
	if(projectInfoNo==null){
		projectInfoNo = "";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/qua/commom/quality.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css">
</style>
<script type="text/javascript" >
	
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr >
				    <td class="ali_cdn_name">标准类型</td>
				    <td class="ali_cdn_input">
					    <select id="file_type" name="file_type" onchange="refreshData()" class="select_width">
					    	<option value="%%">请选择</option>
					    	<option value="GB">国家标准</option>
					    	<option value="CB">企业标准</option>
					    </select></td>
				    <td class="ali_cdn_name">文档名称</td>
				    <td class="ali_cdn_input"><input type="text" id="name" name="name" class="input_width"/></td>
				    <td class="ali_query"><span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span> </td>
				    <td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span> </td>
				    <td>&nbsp;</td>
				    <%-- <auth:ListButton functionId="" css="sc" event="onclick='queryDelete()'" title="JCDP_btn_delete"></auth:ListButton> --%>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</div>
	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{qua_file_id}' />" >
	      	<input type='checkbox' name='chk_entity_id' value='' onclick='check()'/></td>
	      <td class="bt_info_even" autoOrder="1">序号</td> 
	      <td class="bt_info_odd" exp="<a href='#' onclick=openFile('{ids}')><font color='blue'>{file_name}</font></a>">文档名称</td>
	      <td class="bt_info_even" exp="{user_name}">上传者</td>
	      <td class="bt_info_odd" exp="{create_date}">上传日期</td>
	    </tr>
	  </table>
	</div>
  	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
  </div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getQuaFiles";  //cruConfig.queryOp = "toCheckSummary";
	var queryIndex = 0;
	var chooseIndex = 0;
	var chooseRows = 0;
	function clearQueryText(){
		document.getElementById("file_type").options[0].selected = true;
		document.getElementById("name").value = "";
		refreshData();
	}
	function refreshData(){
		var project = '<%=projectInfoNo%>';
		if(project==null || project==''){
			alert("请选择项目");
			return;
		}
		var value = document.getElementById("file_type").options.value;
		var name = document.getElementById("name").value;
		cruConfig.submitStr = "project_info_no="+project+"&file_type="+value+"&name="+name;
		queryData(1);
	}
	refreshData();
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var tr =  obj.parentNode ;
    		obj = tr.cells[0].firstChild;
    		obj.checked = true;
    	}
    	else if(obj.tagName.toLowerCase() == "input"){
    		if(obj.checked == false){
    			document.getElementById("queryRetTable").rows[0].cells[0].firstChild.checked = false;
    		}
    	}
    	var trs = document.getElementById("queryRetTable").rows;
		for(var i = 1;i<trs.length ;i++){
			var input = trs[i].cells[0].firstChild;
			if(input.checked ==false){
				return;
			}
		}
		document.getElementById("queryRetTable").rows[0].cells[0].firstChild.checked = true;
	}
	function queryQuaFiles(){
		refreshData();
	}
	function newSubmit(fileId){
		if(!checkIfExist(fileId)){
			var retObj = jcdpCallService("QualityItemsSrv","saveQuaFilesTeam", "file_id="+fileId);
		}
		refreshData();
	}
	function checkIfExist(value){
		var retObj = jcdpCallService("QualityItemsSrv","checkIfExisTeam", "file_id="+value);
		var map = retObj.checkIfExist;
		debugger;
		if(map==null || map.file_id==null ||map.file_id==''){
			return false;
		}
		return true;
	}
	function queryDelete(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var value = '';
		for (var i = objLen-2;i >= chooseRows ;i--){   
	       if (obj [i].checked==true && i!=chooseIndex) { 
	    	   value=obj[i].value;
	    	   var text = '您确定删除第'+i+"行?";
		       if(window.confirm(text)){
		    	   document.getElementById("queryRetTable").deleteRow(i);
		    	   var retObj = jcdpCallService("QualityItemsSrv","deleteQuaFiles", "qua_file_id="+value);
		    	   changeAutoOrder();
		       }
	       } 
		}
		refreshData();
	}
	function changeAutoOrder(){
		var autoOrder = document.getElementById("queryRetTable").rows.length;
		for(var i =1;i<autoOrder;i++){
			var tr = document.getElementById("queryRetTable").rows[i];
			tr.cells[1].innerHTML = i;
		}
	}
	function openFile(ids){
		var ucm_id = ids.split(":")[1];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
</script>
</body>
</html>

