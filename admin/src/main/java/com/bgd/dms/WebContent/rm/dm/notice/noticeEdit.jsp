<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
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
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = user.getUserName();
	
	String notice_id = request.getParameter("notice_id");
	if ("".equals(notice_id) || null == notice_id) {
		notice_id = "";
	}

	java.util.Calendar c = java.util.Calendar.getInstance();
	java.text.SimpleDateFormat f = new java.text.SimpleDateFormat(
			"yyyy-MM-dd");
	String nowTime = f.format(c.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>通知公告管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
.textarea {
	FONT-SIZE: 12px;
	COLOR: #333333;
	FONT-FAMILY: "微软雅黑";
	background: #FFF;
	line-height: 20px;
	border: 1px solid #a4b2c0;
	height: 160px;
	width: 95.5%;
	margin-bottom: 1px;
	margin-top: 1px;
	word-break: break-all;
}

#new_table_box {
	width: auto;
	height: 565px;
}

#new_table_box_content {
	width: auto;
	height: 540px;
	border: 1px #999 solid;
	background: #cdddef;
	padding: 15px;
}

#new_table_box_bg {
	width: auto;
	height: 500px;
	border: 1px #aebccb solid;
	background: #f1f2f3;
	padding: 5px;
	overflow: auto;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post"
		enctype="multipart/form-data" action="">

		<div id="new_table_box">
			<div id="new_table_box_content">
				<div id="new_table_box_bg">
					<fieldSet style="margin: 2px:padding:2px;">
						<legend>通知公告基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">

							<tr>
								<td class="inquire_item4"><font color='red'>*</font>标题: <input
									type="hidden" id="notice_id" name="notice_id"
									value='<%=notice_id%>'> </td>
								<td class="inquire_form4" colspan="3"><input
									name="notice_title" id="notice_title" class="input_width"
									type="text" value="" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">创建人:</td>
								<td class="inquire_form4"><input name="real_user_name"
									value='<%=userName%>' id="real_user_name" class="input_width"
									type="text" style="color: #DDDDDD;" readonly /></td>
								<td class="inquire_item4">创建时间:</td>
								<td class="inquire_form4"><input name="create_date"
									id="create_date" class="input_width" type="text"
									value="<%=nowTime%>" readonly style="width: 50%" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">公告类型:</td>
								<td class="inquire_form4"><select name="notice_type"
									id="notice_type">
										<option value='0' selected="selected">普通</option>
										<option value='1'>置顶</option>
								</select></td>

							</tr>
						</table>
					</fieldSet>

					<fieldSet style="margin: 2px:padding:2px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td align="right" width="5%">内容:</td>
								<td class="inquire_form4" colspan="3"><textarea
										id="notice_content" name="notice_content" class="textarea"></textarea></td>
							</tr>
							<tr>
								<table style="margin-left: 40px;">
									<tr>
										<td>&nbsp;</td>
										<td colspan="1"><span style="font-size: 12px;">添加附件</span></td>
										<td class='ali_btn' colspan="2"><span class='zj'><a
												href='javascript:void(0);' onclick='insertTr("file_table6")'
												title='添加'></a></span></td>
									</tr>
								</table>
								<table id="file_table6" border="0" cellpadding="0"
									cellspacing="0" class="tab_line_height" width="100%"></table>
							</tr>
						</table>
					</fieldSet>
				</div>
				<div id="oper_div">

					<span class="tj_btn"><a href="#" onclick="saveInfo()"></a></span> <span
						class="gb_btn"><a href="#" onclick="newClose()"></a></span>
				</div>
			</div>

		</div>

	</form>
</body>

<script type="text/javascript">
    var notice_id='<%=notice_id%>';
    function refreshData(){
    	var retObj;
    	if(""!=notice_id){
            retObj = jcdpCallService("DevInsSrv", "getNoticeDetail", "notice_id="+notice_id);
			$("#notice_title").val(retObj.notice.NOTICE_TITLE);
			$("#notice_id").val(notice_id);
			$("#real_user_name").val(retObj.notice.REAL_USER_NAME);
			$("#create_date").val(retObj.notice.CREATE_DATE);
			$("#notice_type").val(retObj.notice.NOTICE_TYPE);
			$("#notice_content").val(retObj.notice.NOTICE_CONTENT);
			retObj = jcdpCallService("DevInsSrv", "getNoticeUpFile", "notice_id="+notice_id);
		
			if(retObj.upFile!=null)
			{
			$("#file_table6").empty();
			for (var tr_id = 1; tr_id<=retObj.upFile.length; tr_id++) {
				insertFile(retObj.upFile[tr_id-1].file_name,retObj.upFile[tr_id-1].file_type,retObj.upFile[tr_id-1].file_id,tr_id-1);
			}
			}
    	}
			
    	
    }	
    
	//插入文件
    function insertFile(name,type,id,tmp){
		
    		$("#file_table6").append(
    					"<tr class='file_tr'>"+
    					"<td  align='right' width='6%'>附件：</td>"+
    					
    	      			"<td  align='left' colspan='3'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' value='"+name+"' /></a></td>"+
    					"<td ><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\") title='删除'></a></span></td>"+
    					"</tr>"
    			);
    }
	
  //删除文件
	function deleteFile(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().remove();
		    jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	}
    //插入行
    function insertTr(obj){
   
        var tmp=$("#"+obj+ "  tr").length;
    	$("#"+obj+"").append(
    		"<tr class='file_tr'>"+
    			"<td  align='right' width='6%'>附件：</td>"+
      			"<td align='left' width='42%'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' /></td>"+
    			"<td align='right' width='6%'>附件名：</td>"+
    			"<td  align='left' width='42%'><input type='text'  style='width:80%' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"'  /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
    			"<td ><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td>"+
    		"</tr>"	
    	);

    }
	
  
 
    //删除行
    function deleteInput(item){
    	$(item).parent().parent().parent().remove();
    }
    
    function getFileInfo(item){
    	var docPath = $(item).val();
    	var order = $(item).attr("id").split("__")[1];
    	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
    	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
    	$("#doc_name__"+order).val(docTitle);//文件name
    	
    }
	function saveInfo(){	
		if (!checkForm()) return;
		var form = document.getElementById("form1");
		form.action="<%=contextPath%>/common/notice/noticeEdit.srq";
		form.submit();
	}
	function checkForm() {
		var notice_title = $.trim($("#notice_title").val());
		if ("" == notice_title || notice_title == undefined) {
			alert("请填写标题");
			return false;
		}
		return true;
	}
</script>
</html>