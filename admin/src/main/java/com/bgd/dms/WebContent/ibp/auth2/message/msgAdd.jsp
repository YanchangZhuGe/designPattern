<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String msg_id=request.getParameter("msg_id");
	if(null==msg_id){
		msg_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
label{
            position: relative;
        }
  		.fileInput{
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
        }
        .btnIput{
            margin-right: 5px;
        }
        .textInput{
            color: red;
        }
</style>
<title>消息基本信息</title>
</head>

<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
     <fieldset style="margin:2px;padding:2px;"><legend>消息基本信息</legend>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	  <tr style="text-align: left">
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;消息内容:</td>
		  <td><input name="content" id="content"  class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,128]'" maxlength="128"  required/></td>		
	  </tr>
	   <tr style="text-align: left">
	  	  <td class="inquire_item4" width="10%" style="text-align: center;">&nbsp;展示截止日期:</td>
		  <td><input name="show_date" style="width: 90%" id="show_date"  class="input_width easyui-datebox" type="text"  data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;"><span>&nbsp;附件:</span></td>
		  <td class='inquire_form' id="msg_purchase_td">
		  <span class="zj"><a href="javascript:void(0);" onclick="excelDataAdd('msg_purchase')" title="添加附件"></a>
		  
		  </td>
	  </tr>
	  </table> 
	  <div id="oper_div" style="text-align: right;">
     	<span class="bc_btn"><a href="####" id="submitButton" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
   	  </div>
</div>
</div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
 	cruConfig.queryStr = ""; 
	cruConfig.queryService = "ModelApply";
	var flag="<%=flag%>";
	var msg_id= "<%=msg_id%>";
	$().ready(function(){
		//禁止日期框手动输入
		$("#show_date").datebox({
			editable: false
        });
	});
	//新增附件
	function excelDataAdd(status){
			insertTrPublic(status);
	}
	
	//新增插入文件
	var fileOrders = 0;
	function insertTrPublic(obj){
			$("#"+obj+"_td").append(
					"</br><label for='"+obj+"__"+fileOrders+"'>"+
						"<input type='button' id='btn' value='选择文件' class='btnIput'><span id='text1' class='textInput'>请上传文件</span>"+
				  		"<input type='file' name='"+obj+"__"+fileOrders+"' id='"+obj+"__"+fileOrders+"' onchange='backName(this)' class='fileInput' style='width:100%;text-align:left'/>"+
					"</label>"
				);

		fileOrders++;
	}
	function backName(obj){
	       $(obj).prev().html(document.getElementById($(obj).attr("id")).files[0].name);
	}
	$(function(){
		if("update"==flag){
			var retObj = jcdpCallService("EquipmentSelectionApply", "getMsgInfo", "msg_id="+msg_id);
			
			if(typeof retObj.str!="undefined"){
				
				var data = retObj.str;
				$("#content").val(data.content);
				$('#show_date').datebox('setValue',data.show_date);

			}
			if(typeof retObj.fdataPublic!="undefined"){ 
				// 有附件显示附件
				for (var i = 0; i<retObj.fdataPublic.length; i++) {
						$("#msg_purchase_td").append("</br><span class='textInput'>"+retObj.fdataPublic[i].file_name+"<span class='sc'><a href='javascript:void(0);' onclick='deleteFilePublic(this,\""+retObj.fdataPublic[i].file_id+"\")'  title='删除'></a></span></span>");
				}
			}
		}
	});
	//删除文件
	function deleteFilePublic(item,id){
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
				$(item).parent().parent().prev().remove()
				$(item).parent().parent().remove();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			}
        });
	}
	// 保存
	function saveInfo(){
		var content = $.trim($("#content").val());
		if(content.length<=0){
			$.messager.alert("提示","消息内容不能为空!");
			return false;
		}
		var show_date = $.trim($('#show_date').datebox('getValue'));

		if(show_date.length<=0){
			$.messager.alert("提示","展示截止日期不能为空!");
			return false;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/addMsgInfo.srq?flag="+flag+"&msg_id="+msg_id;
    			document.getElementById("form1").submit();
            }
        });
	}
</script>
</html>

