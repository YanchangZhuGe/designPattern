<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib prefix="ep" uri="ep" %>
<%
	String contextPath = request.getContextPath(); 
	String applyId = request.getParameter("applyId");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<title>编辑附件信息</title>
</head>
<body>
	<form name="form" id="form" method="post" enctype="multipart/form-data" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateSuppDataFile.srq">
		<div id="new_table_box">
			<div id="new_table_box_content">
		    	<div id="new_table_box_bg">
		    		<input type="hidden" id="apply_id" name="apply_id" value="<%=applyId%>"/>
		    		<fieldset>	
						<table id="render_file_table"  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
					</fieldset>
					<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
						<tr>
							<tr>
							<td class="inquire_item6">添加附件</td>
							<td class="inquire_form6 ali_btn">
								<span class='zj'>
									<a href='javascript:void(0);' onclick='insertTr()'  title='添加'></a>
								</span>
							</td>
						</tr>
					</table>
					<fieldset>	
						<table id="add_file_table" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
					</fieldset>	
					<div>
					    <div id="oper_div">
					    	<auth:ListButton functionId="" css="tj_btn" event="onclick='toSubmit()'"></auth:ListButton>
					        <auth:ListButton functionId="" css="gb_btn" event="onclick='toClose()'"></auth:ListButton>        
					    </div>
					</div>
				</div> 
			</div>
		</div>
	</form>
</body>

<script type="text/javascript">
	var contextpath= "<%=contextPath%>";
	var applyId= "<%=applyId%>";
	$(function(){
		var retObj = jcdpCallService("YearPlanSrv", "getFileInfo", "applyId="+applyId);
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				insertFile(datas[i].file_name,datas[i].file_type,datas[i].file_id);
			}
		}
	});
	
	//保存
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
	//关闭
	function toClose(){
		//刷新列表
		top.frames['list'][2].refreshData();
		newClose();
	}
	//插入上传文件行
	function insertTr(){
		var tmp=new Date().getTime();
		$("#add_file_table").append(
			"<tr class='file_tr'>"+
				"<td class='inquire_item5'>附件：</td>"+
      			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
				"<td class='inquire_item5'>附件名：</td>"+
				"<td class='inquire_form5'>"+
					"<input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' />"+
					"<input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);

	}
	//加载页面时渲染已上传的文件
	function insertFile(name,type,id){
		$("#render_file_table").append(
				"<tr class='f_tr'>"+
	      			"<td style='width:20%;'></td>"+
					"<td>文档：</td><td ><a href='"+contextpath+"/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\") title='删除'></a></span></td>"+
				"</tr>"	
			);
	}
	//删除添加的文件
	function deleteInput(item){
		$(item).parent().parent().parent().remove();
	}
	//删除文件
	function deleteFile(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().remove();
			jcdpCallService("YearPlanSrv", "deleteFile", "id="+id);
		}
	}
	//获取文件信息
	function getFileInfo(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("__")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#doc_name__"+order).val(docTitle);//文件name
		var docExt = docName.substring(docName.lastIndexOf("\.")+1);//后缀名
		if(docExt!=""&&docExt!=undefined){
			if(docExt =="doc" || docExt == "docx"){
				$("#doc_type__"+order).val("word");
			}else if(docExt =="xls" || docExt == "xlsx"){
				$("#doc_type__"+order).val("excel");
			}else if(docExt =="ppt" || docExt == "pptx"){
				$("#doc_type__"+order).val("ppt");
			}else if(docExt =="pdf"){
				$("#doc_type__"+order).val("pdf");
			}else if(docExt =="txt"){
				$("#doc_type__"+order).val("txt");
			}else if(docExt =="jpg" || docExt == "jpeg"|| docExt == "bmp"|| docExt == "png"|| docExt == "gif"){
				$("#doc_type__"+order).val("picture");
			}else if(docExt =="rar" || docExt == "zip"||docExt == "7z"){
				$("#doc_type__"+order).val("compress");
			}else{
				$("#doc_type__"+order).val("other");
			}
		}
	}
</script>
</html>