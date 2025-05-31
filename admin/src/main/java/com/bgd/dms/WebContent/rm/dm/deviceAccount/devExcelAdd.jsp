<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String message = "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">    
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">    
<META HTTP-EQUIV="Expires" CONTENT="0">  
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
</head>
<body class="bgColor_f3f3f3" onload="">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    <fieldset><legend>基本信息</legend>
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
			<td class="inquire_item6"><font color=red>*</font>&nbsp;设备名称</td>
			<td class="inquire_form6">
				<input id="dev_name" name="dev_name"  class="input_width" type="text" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTreePage()"  />
			</td>
			<td class="inquire_item6"><font color=red>*</font>&nbsp;规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" readonly/></td>
			<td class="inquire_item6"><font color=red>*</font>&nbsp;设备编码</td>
			<td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" readonly/></td>			
		</tr>
		<tr>
			<td class="inquire_item6"><font color=red>*</font>所属单位</td>
			<td class="inquire_form6">
				<input id="owning_org_name" name="owning_org_name" class="input_width" type="text" />
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
				<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
				<input id="owning_sub_id" name="owning_sub_id" class="" type="hidden" />
			</td>
		</tr>
		<tr>
			<td class="inquire_item6"><font color='red'>*</font>&nbsp;文件路径：</td>
		    <td class="inquire_form6"><input id="doc_excel" name="doc_excel" type="file"  /></td>
		</tr>
      </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
<div id="dialog-modal" title="正在执行..." style="display:none;">请不要关闭...</div>
</form>
</body>
<script type="text/javascript"> 

	function openMask(){
		$( "#dialog-modal" ).dialog({
		height: 140,
		modal: true,
		draggable: false
		});
	}
	/**
	 * 提交
	 */
	function save(){

		if(document.getElementById("dev_name").value==""){
			alert("请输入设备名称");
			return;
		}
		if(document.getElementById("dev_model").value==""){
			alert("请输入设备型号");
			return;
		}
		if(document.getElementById("dev_type").value==""){
			alert("请输入设备编码");
			return;
		}
		if(document.getElementById("owning_org_name").value==""){
			alert("请输入所属单位");
			return;
		}
		if(document.getElementById("doc_excel").value==""){
			alert("请上传EXCLE文件！");
			return;
		}
		var dev_filename = document.getElementById("doc_excel").value;
		if(dev_filename !=""){		
			if(check(dev_filename)){
				openMask();
				document.getElementById("form1").action="<%=contextPath%>/rm/dm/deviceAccount/saveDevExcel.srq";
				document.getElementById("form1").submit();
			}
		}
	}
	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
	/**
	 * 选择设备树
	**/
	function showDevTreePage(){
		//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTreeForSubNode.jsp","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var name = names[1].split("(")[0];
		var model = names[1].split("(")[1].split(")")[0];
		//alert(returnValue);
		document.getElementById("dev_name").value = name;
		document.getElementById("dev_model").value = model;
		
		var codes = strs[1].split(":");
		var code = codes[1];
		document.getElementById("dev_type").value = code;
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("owning_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = orgId[1];

		var orgSubId = strs[2].split(":");
		document.getElementById("owning_sub_id").value = orgSubId[1];
	}
</script>
</html>

