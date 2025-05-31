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
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<style type="text/css">
#my_table_box {
width:auto;
height:135px;
}
#my_table_box_content {
width:auto;
height:125px;
border:1px #999 solid;
background:#cdddef;
padding:15px;
}
#my_table_box_bg {
width:auto;
height:60px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
</style>
<title>导入页</title>
</head>
<body class="bgColor_f3f3f3" onload="">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<input type="hidden" id="detail_count" value="" />
<div id="#my_table_box">
  <div id="my_table_box_content">
    <div id="my_table_box_bg">
    <fieldset><legend>导入文件</legend>
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		<tr>
			<td class="inquire_item6"><font color='red'>*</font>&nbsp;文件路径：</td>
		    <td class="inquire_form6"><input id="doc_excel" name="doc_excel" type="file"  /></td>
		</tr>
      </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="window.close()"></a></span>
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
	function ReadExcel(filePath) {
        var tempStr = "";
        //得到文件路径的值
        //var filePath = document.getElementById("upfile").value;
        //创建操作EXCEL应用程序的实例
        var oXL = new ActiveXObject("Excel.application");
               //打开指定路径的excel文件
        var oWB = oXL.Workbooks.open(filePath);
        //操作第一个sheet(从一开始，而非零)
        oWB.worksheets(1).select();
        var oSheet = oWB.ActiveSheet;
        //使用的行数
		var rows = oSheet .usedrange.rows.count; 
        try {
             for (var i = 2; i <= rows; i++) {
                 if (oSheet.Cells(i, 2).value == "null" || oSheet.Cells(i, 3).value == "null") break;
                 var a = oSheet.Cells(i, 2).value.toString() == "undefined" ? "": oSheet.Cells(i, 2).value;
                 tempStr += (" " + oSheet.Cells(i, 2).value + " " + oSheet.Cells(i, 3).value + " " + oSheet.Cells(i, 4).value + " " + oSheet.Cells(i, 5).value + " " + oSheet.Cells(i, 6).value + "\n");
             }
        } catch(e) {
                       document.getElementById("txtArea").value = tempStr;
        }
        alert(tempStr);
        //退出操作excel的实例对象
        oXL.Application.Quit();
        //手动调用垃圾收集器
        CollectGarbage();
	}

	/**
	 * 提交
	 */
	function save(){

		if(document.getElementById("doc_excel").value==""){
			alert("请上传EXCLE文件！");
			return;
		}
		var dev_filename = document.getElementById("doc_excel").value;
		if(dev_filename !=""){		
			if(check(dev_filename)){
				openMask();
				Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/saveSrcExceldync.srq",
					method : 'Post',
					isUpload : true,  
					form : "form1",
					success : function(resp){
						var myData = eval("("+resp.responseText+")");
						var nodes = myData.nodes;
						alert(myData.returnMsg);
						window.returnValue=nodes;
						window.close();
					},
					failure : function(resp){// 失败
						var myData = eval("("+resp.responseText+")");
						alert(myData.returnMsg);
					}
				}); 
				<%-- document.getElementById("form1").action="<%=contextPath%>/dmsManager/scrape/saveDevExcelw.srq";
				document.getElementById("form1").submit(); --%>
				
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

