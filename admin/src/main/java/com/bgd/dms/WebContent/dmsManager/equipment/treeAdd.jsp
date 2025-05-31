<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String id = request.getParameter("id");
	String pid = request.getParameter("pid");
	String name = new String(request.getParameter("name").getBytes("iso-8859-1"),"utf-8");
	String whole = request.getParameter("whole");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
<style type="text/css">
#new_table_box_content {
width:auto;
height:620px;
border:1px #999 solid;
background:#cdddef;
padding:15px;
}
#new_table_box_bg {
width:auto;
height:487px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
</style>
<title>勘探名录树</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data" >
	<div id="new_table_box">
	<div id="new_table_box_content">
	<div id="new_table_box_bg">
	<fieldSet style="margin:2px:padding:2px;"><legend>增加/修改</legend>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	    <tr>
	    	<td>&nbsp;</td>
	        <td><input type="hidden"/></td>
	    	<td class="inquire_item4">&nbsp;父节点编码为：</td>
    		<td class="inquire_form4" ><input name="pid" id="pid" value="<%=id%>" class="input_width " type='text' disabled='disabled'/></td>
	    </tr>
	    <tr>
    		<td class="inquire_item4"><font color="red">*</font>&nbsp;序列号：</td>
    		<td class="inquire_form4" class="inquire_form4"><input name="serial_number" id="serial_number"onkeyup="javascript:combineEqcode(this)" onblur="javascript:checkManageEqcode(this)" class="input_width easyui-validatebox main"  type="text" value=""  data-options="validType:'length[0,30]'" maxlength="30" required/><span id='seqinfo' style='color:red'></span></td>
	    	<td class="inquire_item4">&nbsp;设备编码：</td><!-- disabled='disabled'  -->
    		<td class="inquire_form4" ><input name="id" id="id" type="text" value="" class="input_width " disabled='disabled'/></td>
	    </tr>
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;设备名称：</td>
      		<td class="inquire_form4" ><input name="name" id="name" class="input_width easyui-validatebox main"  type="text" value=""  data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	     </tr>
	     
	    </table>
		</fieldSet>
		<div id="oper_div" style="text-align: right">
	     	<span class="bc_btn"><a href="#" id ="submitButton" onclick="saveInfo()"></a></span>
	       <!-- <span class="gb_btn"><a href="#" onclick="newClose()"></a></span> -->
   		</div>	
		</div>
		</div>
	</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var addedseqinfo;
	var flag_public = 0;	
	var id ="<%=id%>";
	var pid ="<%=pid%>";
	var name ="<%=name%>";
	var whole = "<%=whole%>";
	
	function refreshData(){
		var baseData; 
		 if('<%=whole%>'!='null'){ 
			var serial_number =id.substring(pid.length);
			$("#id").val(id);
			$("#pid").val(pid);
			$("#name").val(name);
			$("#serial_number").val(serial_number);
		}
	}
	
	function combineEqcode(obj){
		if(pid==""){
			$("#serial_number").val(obj.value);
			$("#id").val(""+obj.value);
		}else{
			$("#serial_number").val(obj.value);
			if(pid !="null"){
				$("#id").val(id+obj.value);
			}
			if(pid == "null"){
				$("#id").val("0"+obj.value);
			}
			if(""+obj.value ==""){
				$("#id").attr("value","");
			}
		}
	}
	function checkManageEqcode(obj){
		var id = $("#id").val();
		retObj = jcdpCallService("EquipmentParMan", "getTreeId", "id="+id);
		var checkdatas = retObj.deviceappMap; 
		if(checkdatas!=undefined && checkdatas.length>0){
			var alertinfo = "此编码已被名称为["+checkdatas[0].name+"]";
			if(checkdatas[0].is_leaf == '1'){
				alertinfo += ",规格型号为["+checkdatas[0].id+"]的记录占用,请查看!";
			}
			$.messager.alert("提示",alertinfo);
			//序列号设置为空
			$("#serial_number").val("");
			$("#id").val("");
			$("#seqinfo").text("");
		}else{
			$("#seqinfo").text("序列号可用...");
		}
	}
	//保存
	function saveInfo(){debugger;
	var serial_number = $.trim($("#serial_number").val());
		if(serial_number.length <= 0){
			$.messager.alert("提示","序列号不能为空!");
			return;
		}	 
		var id = $.trim($("#id").val());
		if(id.length <=0){
			$.messager.alert("提示","子集id不能为空!");
			return;
		}	 
		var pid = $.trim($("#pid").val());
		if(pid.length <=0){
			$.messager.alert("提示","父级id不能为空!");
			return;
		}	 
		var name = $.trim($("#name").val());
		if(name.length<=0){
		$.messager.alert("提示","设备名称不能为空!");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/addZtree.srq?id="+id+"&pid="+pid+"&whole="+whole;
    			document.getElementById("form1").submit();
    			
            }
        });	
	}
	
</script>
</html>

