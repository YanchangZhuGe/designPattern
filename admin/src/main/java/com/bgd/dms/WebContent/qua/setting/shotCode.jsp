<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	String name = "单炮二级品原因";
	if(project_type!=null && project_type.trim().equals("5000100004000000009")){
		name = "资料评价原因";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" language="javascript">
//简单查询
function simpleSearch(){
	var sortId = document.getElementById("sortId");
	if (window.event.keyCode == 13) {
		
		var shot_name = document.getElementById("shot_name");
		if(shot_name!=null && sortId!=null && !shot_name.value =='' && !sortId.value ==''){
			shot_name = shot_name.value;
			sortId = sortId.value;
			refreshCodeData(sortId,shot_name);
		}else{
			refreshCodeData(sortId.value,'');
		}
	}
}
var checked = false;
function doCheck(){
	if(checked){
		var chk = document.getElementsByName("chk_entity_id");
		var len = chk.length;
		for(var i =0;i<len;i++){
			chk[i].checked = false;
		}
		checked = false;
	}
	else{
		var chk = document.getElementsByName("chk_entity_id");
		var len = chk.length;
		for(var i =0;i<len;i++){
			chk[i].checked = true;
		}
		checked = true;
	}
}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="F_QUA_SETTING_002" css="tj" event="onclick='submit()'" title="JCDP_btn_submit"></auth:ListButton>
				    <auth:ListButton functionId="F_QUA_SETTING_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="F_QUA_SETTING_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</div>
	<input type="hidden" name="sortId" id="sortId" value=""/>
	<input type="hidden" name="sortName" id="sortName" value=""/>
	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{code_id}' title='{locked_if}' {locked} />" >
			<input type='checkbox' name='chk_entity_id' value=''  /></td>
	      <td class="bt_info_even" autoOrder="1">序号</td> 
	      <td class="bt_info_odd" exp="{name}"><%=name %></td>
	      <td class="bt_info_even" exp="{spare1}">备注</td>
	    </tr>
	  </table>
	</div>
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
  </div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "toSingleShot";
	//cruConfig.queryRetTable_id = "";
	var sortId= ""; 
	var sortName="";
	var rows = 1; //table中总行数
	var rowIndex = 0;//选中的行号
	var modify = false;//修改
	var add = false; //添加行
	var modifyId = "";//待修改的id
	var modifyIndex = 0;//待修改的行号
	// 复杂查询
	function refreshCodeData(id ,name){
		rowIndex = 0;//选中的行号
		modify = false;//修改
		add = false; //添加行
		modifyId = "";//待修改的id
		modifyIndex = 0;//待修改的行号
		sortId = id;
		sortName = name;
		cruConfig.submitStr = "sortId="+id+"&sortName="+name+"&project_type=<%=project_type %>";	
		cruConfig.pageSize = cruConfig.pageSizeMax;
		queryData(1);
		dClick();
		document.getElementById("sortId").value = sortId;
		document.getElementById("sortName").value = sortName;
		rows = cruConfig.totalRows;
		rows = document.getElementById("queryRetTable").rows.length;
	}
	refreshCodeData('5000100100','');
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-10);
	function dClick(){
		var obj = document.getElementById("queryRetTable");
		for(var i = 1;i<obj.rows.length;i++){
			var tr = obj.rows[i];
			tr.ondblclick = function(){
				toModify();
			}
		}
		
	}
	function loadDataDetail(){
		var obj = event.srcElement;  
    	if(obj.tagName.toLowerCase()   ==   "td"){   
    		var   tr   =  obj.parentNode ;
    		var locked = tr.cells[0].firstChild.title;
	   		if(locked!=null && locked!='不可修改'){
	   			tr.cells[0].firstChild.checked = true;
	   		}
    		if(rowIndex!=tr.rowIndex && rowIndex !=0){
       			var oldTr = document.getElementById("queryRetTable").rows[rowIndex];
       			var cells = oldTr.cells;
       			for(var j=0;j<cells.length;j++){
       				// 设置列样式
       				if(rowIndex%2==0){
       					if(j%2==1) cells[j].style.background = "#FFFFFF";
       					else cells[j].style.background = "#f6f6f6";
       				}else{
       					if(j%2==1) cells[j].style.background = "#ebebeb";
       					else cells[j].style.background = "#e3e3e3";
       				}
       			}
    		} 
    		if((add || modify) && tr.rowIndex !=rowIndex){
    			alert("请先保存!");
    			return;
    		}
    		rowIndex = tr.rowIndex;
    	}else if(obj.tagName.toLowerCase()   ==   "input"){
    		
    		if(obj.type == 'checkbox'){
    			var   tr   =  obj.parentNode.parentNode ;
        		if(rowIndex!=tr.rowIndex && rowIndex !=0){
           			var oldTr = document.getElementById("queryRetTable").rows[rowIndex];
           			var cells = oldTr.cells;
           			for(var j=0;j<cells.length;j++){
           				// 设置列样式
           				if(rowIndex%2==0){
           					if(j%2==1) cells[j].style.background = "#FFFFFF";
           					else cells[j].style.background = "#f6f6f6";
           				}else{
           					if(j%2==1) cells[j].style.background = "#ebebeb";
           					else cells[j].style.background = "#e3e3e3";
           				}
           			}
        		} 
        		if((add || modify) && tr.rowIndex !=rowIndex){
        			alert("请先保存!");
        			return;
        		}
        		rowIndex = tr.rowIndex;
    		}
    	} 
	}
	function toAdd(){
		if(add || modify){
			alert("请先保存!");
			return;
		}
		add = true;
		var autoOrder = document.getElementById("queryRetTable").rows.length;
		rowIndex = autoOrder;
		modifyIndex = rowIndex;
		var sortName = document.getElementById("queryRetTable").rows[autoOrder-1].cells[3].innerHTML;
		var tr = document.getElementById("queryRetTable").rows[autoOrder-1];
		
		var newTR = document.getElementById("queryRetTable").insertRow(document.getElementById("queryRetTable").rows.length);
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
		var cell = tr.cells[0].firstChild;
        var htmlId = cell.value;
       
       	var querySql = "select substr(nvl(max(t.coding_code_id),'5000100100000000000'),5) code_id from comm_coding_sort_detail t where t.coding_sort_id = '5000100100'";
       	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
       	if(retObj!=null && retObj.returnCode =='0'){
       		htmlId = retObj.datas[0].code_id;
       	}
       	htmlId = '5000'+(parseInt(htmlId)+1);
        var td = newTR.insertCell(0);
        modifyId = htmlId ;
        modifyIndex = newTR.rowIndex ;
        td.innerHTML = "<input type='checkbox' name='chk_entity_id' value='"+htmlId+"'/>";
        td.className = tdClass+'_odd';
        if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}

        td = newTR.insertCell(1);
        td.innerHTML = autoOrder;
        td.className =tdClass+'_even'
        if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
        
        td = newTR.insertCell(2);
        td.innerHTML = "<input name='name' id='name' type='text' value='' onkeydown='saveCode()' class='input_width'/>";
        td.className = tdClass+'_odd';
        if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
        
        td = newTR.insertCell(3);

        td.innerHTML = "<input name='spare1' id='spare1' type='text'  value='' onkeydown='saveCode()' class='input_width'/>";
        td.className =tdClass+'_even'
        if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
        newTR.onclick = function(){
        	rowIndex = newTR.rowIndex;
        	var obj = event.srcElement;
        	if(obj.tagName.toLowerCase() == 'td'){
        		var tr = obj.parentNode ;
        		tr.cells[0].firstChild.checked = true;
        	}
        	// 取消之前高亮的行
        	if(rowIndex>0){
        		for(var i=1;i<document.getElementById("queryRetTable").rows.length;i++){
	    			var oldTr = document.getElementById("queryRetTable").rows[i];
	    			var cells = oldTr.cells;
	    			for(var j=0;j<cells.length;j++){
	    				cells[j].style.background="#96baf6";
	    				// 设置列样式
	    				if(i%2==0){
	    					if(j%2==1) cells[j].style.background = "#FFFFFF";
	    					else cells[j].style.background = "#f6f6f6";
	    				}else{
	    					if(j%2==1) cells[j].style.background = "#ebebeb";
	    					else cells[j].style.background = "#e3e3e3";
	    				}
	    			}
        		}
    		} 
			// 设置新行高亮
			var cells = this.cells;
			for(var i=0;i<cells.length;i++){
				cells[i].style.background="#ffc580";
			}
		}
	}
	function toModify(){
		if(add || modify){
			alert("请先保存!");
			return;
		}
		if(rowIndex ==0){
			alert('不可修改');
			return;
		}
		else{
 			var tr = document.getElementById("queryRetTable").rows[rowIndex];
 			var locked = tr.cells[0].firstChild.title;
			if(locked!=null && locked=='不可修改'){
				alert('不可修改');
				return ;
			}
			modify = true;
 			modifyIndex = tr.rowIndex;
			modifyId = tr.cells[0].firstChild.value; 
			var name = tr.cells[2].innerHTML;
			var spare1 = tr.cells[3].innerHTML;
			tr.cells[2].innerHTML = "<input name='name' id='name' type='text'  value='' onkeydown='saveCode()'/>";
			tr.cells[3].innerHTML = "<input name='spare1' id='spare1' type='text'  value='' onkeydown='saveCode()' />";
			if(name!=null && name !=''){
				document.getElementById("name").value = name;
			}
			if(spare1!=null && spare1 !='&nbsp;' && spare1 !=''){
				document.getElementById("spare1").value = spare1;
			}
		}
	}
	
	function toDelete(){
	 	if(add || modify){
			alert("请先保存!");
			return;
		}
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var codeId = '';
		var text = "您确定要删除?";
		if(window.confirm(text)){
			for (var i = 1;i< objLen;i++){
				var locked = obj[i].title;
				if(locked!=null && locked!='不可修改'){
					if ( obj [i].checked==true) {
			        	codeId=obj[i].value;
			        	var retObj = jcdpCallService("QualityItemsSrv","deleteSingleCode", "code_id="+codeId+"&project_type=<%=project_type%>");
			        }
				}
			 }
		}
		 refreshCodeData(sortId,'');
		 parent.mainTopframe.refreshTree();
	}
	function saveCode(){
		if(event.keyCode==13)
	    {
			if(!add && !modify){
				return;
			}
	        if(window.confirm('你确定保存所修改的内容吗?')){
		        var status = 'modify';
		        if((rows-1)<rowIndex){
		        	status = 'add';
		        }
		        var sort = sortId;
				var id = modifyId;
				var name = document.getElementById("name").value;
				if(name==null || name ==''){
					name = '';
					alert('评价项不可空');
					return;
				}
				var submitStr = 'sortId='+sort+'&id='+id+"&name="+name+"&status="+status+"&project_type=<%=project_type%>";
				var spare1 = document.getElementById("spare1").value;
				if(spare1!=null && spare1!=''){
					submitStr = submitStr + "&spare1="+spare1;
				}
				return;
				var retObj = jcdpCallService("QualityItemsSrv", "saveSingleShot", submitStr);
				if(retObj.returnCode=='0'){
					var tr = document.getElementById("queryRetTable").rows[modifyIndex];
					var name = document.getElementById("name").value;
					var spare1 = document.getElementById("spare1").value;
					tr.cells[2].innerHTML = name;
					tr.cells[3].innerHTML = spare1;
				}
				modify = false;
				add = false;
				parent.mainTopframe.refreshTree();
				refreshCodeData(sortId,sortName);
	        }
	    }
		
	}
	function submit(){
        if(window.confirm('你确定保存所修改的内容吗?')){
	        var status = 'modify';
	        if((rows-1)<rowIndex){
	        	status = 'add';
	        }
	        var sort = sortId;
			var id = modifyId;
			var name = document.getElementById("name").value;
			if(name==null || name ==''){
				name = '';
				alert('评价项不可空');
				return;
			}
			var spare1 = document.getElementById("spare1").value;
			var submitStr = 'sortId='+sort+'&id='+id+"&name="+name+"&status="+status+"&project_type=<%=project_type%>";
			var spare1 = document.getElementById("spare1").value;
			if(spare1!=null && spare1!='' && spare1!=' '){
				submitStr = submitStr + "&spare1="+spare1;
			}
			var retObj = jcdpCallService("QualityItemsSrv", "saveSingleShot", submitStr);
			if(retObj.returnCode=='0'){
				var tr = document.getElementById("queryRetTable").rows[modifyIndex];
				var name = document.getElementById("name").value;
				var spare1 = document.getElementById("spare1").value;
				tr.cells[2].innerHTML = name;
				tr.cells[3].innerHTML = spare1;
				
			}
			modify = false;
			add = false;
        }
        parent.mainTopframe.refreshTree();
        refreshCodeData(sortId,sortName);
	}
	
</script>
</body>
</html>

