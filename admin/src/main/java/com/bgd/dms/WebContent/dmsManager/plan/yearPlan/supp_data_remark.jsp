<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	//需求报表是否保存成功
  	//String operationFlag = responseDTO.getValue("operationFlag");
  	//申请id
  	String applyId = responseDTO.getValue("applyId");
  	//申请年度
  	String applyYear = responseDTO.getValue("applyYear");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<title>其他说明</title>
</head>

<body style="background:#cdddef">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
							<auth:ListButton functionId="" css="gb" event="onclick='toClose()'" title="关闭"></auth:ListButton>
				  		</tr>
					</table>
				</td>
			   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	</div>
	<div id="title_box_0" class="tongyong_box_title">
		<span id="list_div_0_span" style="display:block;text-align:center;">其他说明</span>
	</div>
	<form name="form" id="form" method="post" enctype="multipart/form-data" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateRemarkInfo.srq">
		<!--其他说明id -->
		<input name="remark_id" id="remark_id" type="hidden"/>
		<!--申请id -->
		<input name="apply_id" id="apply_id" type="hidden" value="<%=applyId%>"/>
		<!--申请年度 -->
		<input name="apply_year" id="apply_year" type="hidden" value="<%=applyYear%>"/>
		<div id="new_table_box">
			<div id="new_table_box_content">
		    	<div id="new_table_box_bg">
		    		<fieldset>
			    		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_form6" colspan="4">
									<textarea  id="remark" name="remark" class="textarea"></textarea>
								</td>
						  	</tr>
					  	</table>
						<table id="render_file_table"  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
					</fieldset>
					<fieldset>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td style="width:85%;"></td>
								<td class="inquire_item6">添加附件</td>
								<td class="ali_btn">
									<span class='zj'>
										<a href='javascript:void(0);' onclick='insertTr()'  title='添加'></a>
									</span>
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset>
						<table id="add_file_table" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
					</fieldset>
				</div> 
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	var contextpath= "<%=contextPath%>";
	var applyId= "<%=applyId%>";
	$(function(){
		var retObj = jcdpCallService("YearPlanSrv", "getRemarkInfo", "applyId="+applyId);
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				if(datas[i].is_file=='0'){
					$("#remark_id").val(datas[0].remark_id);
					$("#remark").val(datas[0].remark);
				}else{
					insertFile(datas[i].file_name,datas[i].file_type,datas[i].file_id);
				}
			}
		}
	});
	
	//保存
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
	//关闭操作
	function toClose(){
		parent.location.href='<%=contextPath %>/dmsManager/plan/yearPlan/apply_list.jsp';	
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
					"<td style='width:1%;'></td>"+
					"<td style='width:15%;'>文档：</td>"+
					"<td style='width:70%;'><a href='"+contextpath+"/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td style='width:10%;' class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\") title='删除'></a></span></td>"+
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

