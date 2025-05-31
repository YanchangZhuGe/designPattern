<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String folderId = "";
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>文档综合查询</title>
</head>

<body style="background:#fff">


			<div id="query_box" style="overflow-y:auto;">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info">
		        <tr>
			    	<td colspan="4" align="center">文档综合查询</td>
		    	</tr>
		        <tr>
		          <td class="inquire_item4">文档编号:</td>
		          <td class="inquire_form4"><input name="file_number" class="input_width" type="text" /></td>
		          <td class="inquire_item4">文档标题:</td>
		          <td class="inquire_form4"><input name="file_name" class="input_width" type="text" /></td>
		        </tr>
		        <tr>
		          <td class="inquire_item4">关键字:</td>
		          <td class="inquire_form4"><input name="doc_keyword" class="input_width" type="text" /></td>  
		          <td class="inquire_item4">重要程度:</td>
		          <td class="inquire_form4">
		 	      	<select name="doc_importance" class="select_width">
			      		<option value="">-请选择-</option>
			      		<option value="1">高</option>
			      		<option value="2">中</option>
			      		<option value="3">低</option>
			      	</select>         
		          </td>
		        </tr>
		        <tr>
		          <td class="inquire_item4">文档类型:</td>
		          <td class="inquire_form4">
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="word"/>Word
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="excel"/>Excel
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="ppt"/>PowerPoint
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="pdf"/>PDF
		          </td>
		          <td class="inquire_form4">
				  &nbsp;
		          </td>
		          <td class="inquire_form4">
				  &nbsp;
		          </td>

		        </tr>
		        <tr>
		          <td class="inquire_item4">&nbsp;</td>
		          <td class="inquire_form4">
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="txt"/>TXT
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="picture"/>图片文件
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="compress"/>压缩文件
		          <input type="checkbox" name="type_checkbox" id="type_checkbox" value="other"/>其他文件		          
		          </td>
		          <td class="inquire_form4">&nbsp;</td>
		          <td class="inquire_form4">&nbsp;</td>
		        </tr>
		        <tr>
		          <td class="inquire_item4">上传日期:</td>
		          <td class="inquire_form4">
		          <input name="create_date_s" class="input_width" type="text" readonly="readonly"/>&nbsp;&nbsp;
          		  <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(create_date_s,tributton1);" />
		          </td>
		          <td class="inquire_item4">到：</td>
		          <td class="inquire_form4">
		          <input name="create_date_e" class="input_width" type="text" readonly="readonly"/>&nbsp;&nbsp;
          		  <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(create_date_e,tributton2);" />
		          </td>
		        </tr>
		        <tr>
		          <td class="inquire_item4">所属项目:</td>
		          <td class="inquire_form4">
		          <input name="project_name" id="project_name" class="input_width" type="text" />
		          <input name="project_id" id="project_id" class="input_width" type="hidden" />
		          <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectProject()"/>
		          </td>
		          <td class="inquire_item4">上传人:</td>
		          <td class="inquire_form4">
		          <input name="creator_name" id="creator_name" class="input_width" type="text" />
		          <input name="creator_id" id="creator_id" class="input_width" type="hidden" />
		          <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson()"/>
		          </td>

		        </tr>
		
			  </table>
			  
			<div id="oper_div">
		    	<%-- <auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton> --%>
		    	<auth:ListButton functionId="" css="tj_btn" event="onclick='searchFileList()'"></auth:ListButton>
    		</div>
		
			</div>

      	<div id="list_table">
			<div class="lashen" id="line"></div>		
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}:{ucm_id}' id='rdo_entity_id_{file_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{file_number}">文档编号</td>
			      <td class="bt_info_even" exp="{file_name}">文档标题</td>
			      <td class="bt_info_odd" exp="{doc_keyword}">关键字</td>
			      <td class="bt_info_even" exp="{doc_importance_value}">重要程度</td>
			      <td class="bt_info_odd" exp="{the_file_type}">文档类型</td>
			      <td class="bt_info_even" exp="{create_date}">上传日期</td>
			      <td class="bt_info_odd" exp="{user_name}">上传人</td>
			      <td class="bt_info_even" exp="{project_name}">所属项目</td>
			    </tr>
			  </table>
			</div>			
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
		  </div>
	<table id="newTitleTable"></table>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen2);
function lashen2() {
	var oLine = $("#line")[0];
	if(oLine==null) return;
	oLine.onmousedown = function(e) {
		var disY = (e || event).clientY;
		oLine.top = oLine.offsetTop;
		document.onmousemove = function(e) {
			var iT = oLine.top + ((e || event).clientY - disY)-70;
			$("#query_box").css("height",iT);
			lashened = 1;
			getObj('newTitleTable').style.width = getObj('queryRetTable').clientWidth;
			//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-27);
			setTabBoxHeight();
		};
		document.onmouseup = function() {
			document.onmousemove = null;
			document.onmouseup = null;
			oLine.releaseCapture && oLine.releaseCapture()
		};
		oLine.setCapture && oLine.setCapture();
		return false;
	}
}
function setTabBoxHeight(){
	$("#table_box").children("div").css("height",$(window).height()-$("#query_box").height()-$("#line").height()-10);
}
function createNewTitleTable(){}
function resizeNewTitleTable(){}
</script>

<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ucmSrv";
	cruConfig.queryOp = "complexFileSearch";
	//cruConfig.queryRetTable_id = "";
	var file_number = "";
	var file_name="";
	var doc_keyword = "";
	var doc_importance = "";
	var doc_type = "";
	var create_date_start = "";
	var create_date_end = "";
	var creator_id = "";
	var project_id = ""
	
	
	// 复杂查询
	function refreshData(q_file_number, q_file_name,q_doc_type,q_doc_keyword,q_doc_importance,q_create_date_start,q_create_date_end,q_creator_id,q_project_id){
		if(q_file_number==undefined) q_file_number = file_number;
		file_number = q_file_number;
	
		if(q_file_name==undefined) q_file_name = file_name;
		file_name = q_file_name;
		
		if(q_doc_keyword==undefined) q_doc_keyword = doc_keyword;
		doc_keyword = q_doc_keyword;
		
		if(q_doc_importance==undefined) q_doc_importance = doc_importance;
		doc_importance = q_doc_importance;
		
		if(q_doc_type==undefined) q_doc_type = doc_type;
		doc_type = q_doc_type;
		
		if(q_create_date_start==undefined) q_create_date_start = create_date_start;
		create_date_start = q_create_date_start;
		
		if(q_create_date_end==undefined) q_create_date_end = create_date_end;
		create_date_end = q_create_date_end;
		
		if(q_creator_id==undefined) q_creator_id = creator_id;
		creator_id = q_creator_id;
		
		if(q_project_id==undefined) q_project_id = project_id;
		project_id = q_project_id;

		cruConfig.submitStr = "file_number="+q_file_number+"&file_name="+q_file_name+"&doc_type="+q_doc_type+"&doc_keyword="+q_doc_keyword+"&doc_importance="+q_doc_importance+"&create_date_start="+q_create_date_start+"&create_date_end="+q_create_date_end+"&creator_id="+q_creator_id+"&project_id="+q_project_id;	
		queryData(1);
	}
	//refreshData(undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined);
	function searchFileList(){
		var type_params = "";
		var fileNumber = document.getElementsByName("file_number")[0].value;
		var fileName= document.getElementsByName("file_name")[0].value;
		var docKeyword = document.getElementsByName("doc_keyword")[0].value;
		var docImportance = document.getElementsByName("doc_importance")[0].value;
		var docTypes = document.getElementsByName("type_checkbox");
		for(var i=0;i<docTypes.length;i++){
			if(docTypes[i].checked){
				type_params = type_params+",'"+docTypes[i].value+"'";
			}
		}
		var createDateStart = document.getElementsByName("create_date_s")[0].value;
		var createDateEnd = document.getElementsByName("create_date_e")[0].value;
		var creatorId = document.getElementsByName("creator_id")[0].value;
		var projectId = document.getElementsByName("project_id")[0].value;
		refreshData(fileNumber,fileName,type_params.substr(1),docKeyword,docImportance,createDateStart,createDateEnd,creatorId,projectId);
	}
	
	function cancel()
	{
		window.close();
	}
										
	function save(){	
		document.getElementById("form1").submit();
	}
	//选取人员
	function selectPerson(){
	    var personInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select=userId',personInfo);
	    if(personInfo.fkValue!=""&&personInfo.value!=""){
	        document.getElementById("creator_id").value = personInfo.fkValue;
	        document.getElementById("creator_name").value = personInfo.value;
	    }
	}
	//选择项目
	function selectProject(){
	    var projInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectProject.lpmd',projInfo);
	    if(projInfo.fkValue!=""&&projInfo.value!=""){
	        document.getElementById("project_id").value = projInfo.fkValue;
	        document.getElementById("project_name").value = projInfo.value;
	    }
	}
	
	function dbclickRow(ids){
		var file_id = ids.split(":")[0];
		var ucm_id = ids.split(":")[1];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);			
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
		
	}

</script>

</html>

