<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String pageAction = request.getParameter("pageAction");
	String parent_device_id = request.getParameter("parent_device_id");
	String parent_dev_code = request.getParameter("parent_dev_code");
	String node_level = request.getParameter("parent_node_level");
	int parentLevel = Integer.parseInt(node_level);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>批量设备编码维护</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="height:440px">
  <div id="new_table_box_content" style="height:400px">
  <div id="new_table_box_bg" style="height:350px">
      <fieldSet style="margin:30px;padding:2px;"><legend>新增</legend>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td class="inquire_item4" >节点类型:</td>
	          <td class="inquire_form4" >
	          	<select name="isleaf" id="isleaf" >
	          		<option value="0">非叶子节点</option>
	          		<option value="1">叶子节点</option>
	          	</select>
	          </td>
	          <td class="inquire_item4" >父节点编码为:</td>
	          <td class="inquire_form4">
	          	<b><%=parent_dev_code%></b>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >序列号:</td>
	          <td class="inquire_form4" >
	          	<input name="seq" id="seq" size="15" type="text" value="" onkeyup="javascript:combineEqcode(this)" onblur="javascript:checkManageEqcode(this)" />
	          	<span id='seqinfo' style='color:red'></span>
	          </td>
	          <td class="inquire_item4" >设备编码:</td>
	          <td class="inquire_form4" >
	          	<input name="showcode" id="showcode" size="30" type="text" value="" disabled />
	          	<input name="code" id="code" type="hidden" value=""  />
	          	<input type="hidden" name="parent_node_id" id="parent_node_id" value="<%=parent_device_id%>" />
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >设备名称:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input name="name" id="name" size="30" type="text"  value="" />
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >规格型号:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input name="model" id="model" size="30" type="text"  value="" disabled/>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >是否为采集设备编码:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input type="checkbox" name="iscoll" id="iscoll" disabled/>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >道数:</td>
	          <td class="inquire_form4" colspan="3">
	          	<input name="daoinfo" id="daoinfo" size="30" type="text"  value="" onkeyup="checkDaoinfo(this)" disabled/>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >设备型号:</td>
	          <td class="inquire_form4" colspan="3">
	          	<select id="type" name="type" disabled>
	          		<option value=""></option>
	          	</select>
	          </td>
	        </tr>
	      </table>
      </fieldSet>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr><td>
        	<p>&nbsp;&nbsp;&nbsp;&nbsp;父节点级别为<%= parentLevel %>，当前节点级别为：<%=parentLevel+1%>。</p>
        	<input type="hidden" name="level" id="level" value="<%=parentLevel+1%>"/>
        </td></tr>
        <tr><td>
        	<p style="color:red">&nbsp;&nbsp;&nbsp;&nbsp;备注：第一级编码由两位序列号组成;节点编码由父级编码和两位序列号组成。</p>
        </td></tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var parentDevcode = '<%=parent_dev_code%>';
	$().ready(function(){
		$("#isleaf").change(function(){
			// 如果是叶子节点
			if(this.value == "1"){
				$("#model").removeAttr("disabled");
				$("#iscoll").removeAttr("disabled");
			}else{
				$("#model").attr("value","");
				$("#daoinfo").attr("value","");
				$("#iscoll").removeAttr("checked");
				$("#model").attr("disabled","disabled");
				$("#iscoll").attr("disabled","disabled");
				$("#daoinfo").attr("disabled","disabled");
				$("#type").attr("disabled","disabled");
			}
		});
		$("#iscoll").change(function(){
			if(this.checked){
				$("#daoinfo").removeAttr("disabled");
				$("#type").removeAttr("disabled");
			}else{
				$("#daoinfo").attr("value","");
				$("#daoinfo").attr("disabled","disabled");
				$("#type").attr("disabled","disabled");
			}
		});
		//给设备型号编码加载到设备型号中
		var querySql = "select coding_name as name,coding_code_id as id ";
		querySql += "from comm_coding_sort_detail where coding_sort_id='5110000031' order by coding_show_id";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		basedatas = queryRet.datas;
		if(basedatas!=undefined && basedatas.length>0){
			var innerhtml = "";
			//回填基本信息
			for(var index=0;index<basedatas.length;index++){
				lineinfo = index+1;
				innerhtml += "<option value='"+basedatas[index].id+"'>"+basedatas[index].name+"</option>";
			}
			$("#type").append(innerhtml);
		}
	});
	function combineEqcode(obj){
		if(parentDevcode==""){
			$("#showcode").val(obj.value);
			$("#code").val(obj.value);
		}else{
			$("#showcode").val(parentDevcode+obj.value);
			$("#code").val(parentDevcode+obj.value);
		}
	}
	function checkManageEqcode(obj){
		var devcode = $("#code").val();
		var checksql = "select device_id,dev_name,dev_model,is_leaf from gms_device_collectinfo where dev_code='"+devcode+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+checksql);
		var checkdatas = queryRet.datas;
		if(checkdatas!=undefined && checkdatas.length>0){
			var alertinfo = "此编码已被名称为["+checkdatas[0].dev_name+"]";
			if(checkdatas[0].is_leaf == '1'){
				alertinfo += ",规格型号为["+checkdatas[0].dev_model+"]的记录占用,请查看!";
			}
			alert(alertinfo);
			//序列号设置为空
			$("#seq").val("");
			$("#showcode").val("");
			$("#code").val("");
			$("#seqinfo").text("");
		}else{
			$("#seqinfo").text("序列号可用...");
		}
	}
	function checkDaoinfo(obj){
		if(obj.value!=null){
			if(!/\d+$/.test(obj.value)){
				alert("道数信息只能为数字!");
				obj.value="";
				return;
			}
		}
	}
	function saveInfo(){
		var issrollinfo = '0';
		//1. 设备编码不能为空
		if($("#code").val()==""){
			alert("设备编码不能为空,请输入!");
			return;
		}
		//2. 设备名称不能为空
		if($("#name").val()==""){
			alert("设备名称不能为空,请输入!");
			return;
		}
		//3. 如果是叶子节点，那么规格型号 不能为空；如果是采集设备，那么道数不能为空,设备型号也不为空。
		if($("#isleaf").val()=="1"){
			if($("#model").val()==""){
				alert("规格型号不能为空,请输入!");
				return;
			}
			if($("#iscoll")[0].checked==true&&$("#daoinfo").val()==""){
				alert("道数不能为空,请输入!");
				return;
			}
			if($("#iscoll")[0].checked==true&&$("#type").val()==""){
				alert("设备型号不能为空,请输入!");
				return;
			}
		}else{
			issrollinfo = '1';
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollectDeviceNew.srq?pageAction=<%=pageAction%>&issrollinfo="+issrollinfo;
		document.getElementById("form1").submit();
	}
</script>
</html>