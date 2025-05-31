<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String applyId = request.getParameter("applyId");
	String applyYear = request.getParameter("applyYear");
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
		    			<legend>其他说明</legend>
			    		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_form6" colspan="4">
									<textarea  id="remark" name="remark" class="textarea" readonly="readonly"></textarea>
								</td>
						  	</tr>
					  	</table>
						<table id="render_file_table"  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
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
	//加载页面时渲染已上传的文件
	function insertFile(name,type,id){
		$("#render_file_table").append(
				"<tr class='f_tr'>"+
					"<td style='width:10%;'>&nbsp;&nbsp;文档：</td>"+
					"<td style='width:80%;'><a href='"+contextpath+"/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"</tr>"	
			);
	}
</script>
</html>

