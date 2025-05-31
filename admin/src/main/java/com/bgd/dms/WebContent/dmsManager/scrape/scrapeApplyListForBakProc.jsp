<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
  	String scrape_apply_id = request.getParameter("scrape_apply_id");
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
<title>报废申请表</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>其他说明</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">其他说明:</td>
          <td class="inquire_form4" colspan="3">
           <textarea id="bak" name="bak"  class="textarea" readonly></textarea>
          </td>
        </tr>
        <tr>
         <table style="margin-left:40px;">
			<tr >
				<td>&nbsp;</td>
			</tr>
		</table>
			<table id="file_table6" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
        </tr>
      </table>    
      </fieldSet>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function saveInfo(){
		
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeother.srq";
		document.getElementById("form1").submit();
	}
	function refreshData(){
		if('<%=scrape_apply_id%>'!=null){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeOtherInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
			 $("#bak").val(baseData.deviceApplyMap.bak);
				
				if(baseData.fdata!=null)
				{
					$("#file_table6").empty();
					for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
						insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id);
					}
				}
		}
	}

	//插入行
	function insertTr(obj){
	var tmp=new Date().getTime();
		$("#"+obj+"").append(
			"<tr class='file_tr'>"+
				"<td class='inquire_item5'>附件：</td>"+
	  			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
				"<td class='inquire_item5'>附件名：</td>"+
				"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);

	}
	//删除行
	function deleteInput(item){
		$(item).parent().parent().parent().remove();
		checkInfoList();
		
	}
	function getFileInfo(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("__")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#doc_name__"+order).val(docTitle);//文件name
		
	}

		//插入文件
	function insertFile(name,type,id){
		
			$("#file_table6").append(
						"<tr>"+
						"<td class='inquire_form5'>附件:</td>"+
		      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
						"<td class='inquire_form5'></span></td>"+
						"</tr>"
				);
	}
	//删除文件
		function deleteFile(item,id){
			if(confirm('确定要删除吗?')){  
				$(item).parent().parent().parent().empty();
				var tmp=new Date().getTime();
				$("#file_table6").append("<tr><td class='inquire_item6'>附件:</td>"+
		    			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
		    			"<td class='inquire_form5'>附件名：</td>"+
						"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
						"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td></tr>");
					jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			}
		}
	
</script>
</html>

