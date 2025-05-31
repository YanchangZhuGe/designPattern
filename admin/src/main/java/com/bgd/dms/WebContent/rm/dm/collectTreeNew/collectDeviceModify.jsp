<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String pageAction = request.getParameter("pageAction");
	String device_id = request.getParameter("device_id");
	String dev_code = request.getParameter("dev_code");
	String node_level = request.getParameter("node_level");
	int nodelevel = Integer.parseInt(node_level);
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
      <fieldSet style="margin:30px;padding:2px;"><legend>修改</legend>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td class="inquire_item4" >节点类型:</td>
	          <td class="inquire_form4" >
	          	<select name="isleaf" id="isleaf" >
	          		<option value="0">非叶子节点</option>
	          		<option value="1">叶子节点</option>
	          	</select>
	          </td>
	          <td class="inquire_item4" ></td>
	          <td class="inquire_form4">
	          	父节点编码为:<b id="parent_node_code"></b>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >序列号:</td>
	          <td class="inquire_form4" >
	          	<input name="seq" id="seq" size="15" type="text" value="" onkeyup="javascript:combineEqcode(this)" onblur="javascript:checkManageEqcode(this)" />
	          </td>
	          <td class="inquire_item4" >设备编码:</td>
	          <td class="inquire_form4" >
	          	<input name="showcode" id="showcode" size="30" type="text" value="" disabled />
	          	<input name="code" id="code" type="hidden" value=""  />
	          	<input type="hidden" name="device_id" id="device_id" value="<%=device_id%>" />
	          	<input type="hidden" name="parent_node_id" id="parent_node_id" value="" />
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
        	<p>&nbsp;&nbsp;&nbsp;&nbsp;父节点级别为<b id='parent_node_level'></b>，当前节点级别为：<b id='node_level'></b>。</p>
        	<input type="hidden" name="level" id="level" value=""/>
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
	var device_id = '<%=device_id%>';
	$().ready(function(){
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
		//先查询本条的基本信息，带上父节点的code和级别信息
		var basesql = "select base.device_id,base.dev_name,base.dev_model,base.dev_code,base.node_level,base.dev_slot_num,base.node_type_id,"+
			"base.node_parent_id,base.is_leaf,base.node_iscoll,parent.dev_code as parent_dev_code,parent.node_level as parent_node_level "+
			"from gms_device_collectinfo base left join gms_device_collectinfo parent on base.node_parent_id=parent.device_id "+
			"where base.device_id='"+device_id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+basesql);
		basedatas = queryRet.datas;
		if(basedatas!=undefined && basedatas.length>0){
			$("#isleaf").val(basedatas[0].is_leaf);
			if(basedatas[0].is_leaf=='1'){
				$("#iscoll").removeAttr("disabled");
				$("#model").removeAttr("disabled");
			}
			$("#parent_node_code").text(basedatas[0].parent_dev_code);
			$("#showcode").val(basedatas[0].dev_code);
			$("#parent_node_id").val(basedatas[0].node_parent_id);
			var dev_code = basedatas[0].dev_code;
			var parent_dev_code = basedatas[0].parent_dev_code;
			$("#code").val(dev_code);
			var seqinfo = dev_code.substr(parent_dev_code.length);
			$("#seq").val(seqinfo);
			$("#parent_node_level").text(basedatas[0].parent_node_level);
			$("#node_level").text(basedatas[0].node_level);
			$("#level").val(basedatas[0].node_level);
			$("#name").val(basedatas[0].dev_name);
			$("#model").val(basedatas[0].dev_model);
			if(basedatas[0].node_iscoll=='1'){
				$("#iscoll").attr("checked","checked");
				$("#daoinfo").removeAttr("disabled");
				$("#daoinfo").val(basedatas[0].dev_slot_num);
				$("#type").removeAttr("disabled");
				$("#type").val(basedatas[0].node_type_id);
			}
			if(basedatas[0].is_leaf == '0'){
				//如果是非叶子节点，判断下属是否已经存在了节点，如果有，那么不能将非叶子节点改为叶子节点
				var subsql = "select count(1) as subcount from gms_device_collectinfo where node_parent_id='"+device_id+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+subsql);
				var detdatas = queryRet.datas;
				if(detdatas!=undefined && detdatas.length>0){
					if(detdatas[0].subcount>0){
						$("#isleaf").attr("disabled","disabled");
						$("#isleaf").after("<span style='color:red' >该节点存在子节点，不能修改节点信息!</span>");
					}else{
						$("#isleaf").removeAttr("disabled");
					}
				}
			}
		}
		
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
		alert("将设备编码进行查询，看是否唯一...");
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
			if($("#iscoll")[0].checked==true){
				issrollinfo = '1';
			}
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollectDeviceNew.srq?pageAction=<%=pageAction%>&issrollinfo="+issrollinfo;
		document.getElementById("form1").submit();
	}
</script>
</html>