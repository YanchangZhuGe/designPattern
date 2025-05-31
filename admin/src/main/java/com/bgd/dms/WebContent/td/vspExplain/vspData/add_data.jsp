<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
		String contextPath = request.getContextPath();
		UserToken user = OMSMVCUtil.getUserToken(request);
		String userId = (user==null)?"":user.getEmpId();
		String userName = (user==null)?"":user.getUserName();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String curDate = format.format(new Date());
		
		String businessType = request.getParameter("docType")==null?"":request.getParameter("docType");
		String parent_file_id = request.getParameter("parent_file_id")==null?"":request.getParameter("parent_file_id");
		String id = request.getParameter("id")==null?"":request.getParameter("id");
		String fileAbbr = request.getParameter("fileAbbr")==null?"":request.getParameter("fileAbbr");
		String p_type = request.getParameter("p_type")==null?"":request.getParameter("p_type");
		
		String a_types="";
		String b_types="";
		String audit_types="";
	    if(businessType.equals("0110000061200000004")){
	    	  a_types="0110000061200000014";
	    	  b_types="0110000061200000024";
	    	  audit_types="0110000061200000003";
	    }else{
		  	  a_types="0110000061200000034";
		  	  b_types="0110000061200000044";
			  audit_types="0110000061200000008";
	    }
	    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!--Remark JavaScript定义-->

</head>
<body onload="page_init();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"> 文档编号：</td>
									<td class="inquire_form4">
							             <input name="data_id" id="data_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>          
							           	<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/> 
							         	<input name="upload_status" id="upload_status" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="parent_file_id" id="parent_file_id" class="input_width" value="<%=parent_file_id%>" type="hidden" readonly="readonly"/>
										<input  name="ucm_id_a" id="ucm_id_a" class="input_width" value="自动生成" type="text" readonly="readonly"/>
									</td>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"> <input name="project_name" id="project_name" class="input_width" value="" type="text" readonly="readonly"/></td> 
				 
								</tr>
								<tr>
									<td class="inquire_item4">上传人：</td>
									<td class="inquire_form4"><input type="text" id="the_heir" name="the_heir" value="<%=userName%>" class="input_width" /></td>
									<td class="inquire_item4">验收时间：</td>
									<td class="inquire_form4"> 
										<input type="text" id="upload_time" name="upload_time" value="<%=curDate%>" class="input_width" readonly="readonly"/> 
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(upload_time,tributton1);" />
								 
									</td>
								</tr>
								
								<tr>
									<td class="inquire_item4">甲方验收意见书：</td>
									<td colspan="2">
										<input type="hidden" id="pk_<%=b_types%>" name="pk_<%=b_types%>" value=""/>
										<input type="file" name="<%=b_types%>" id="<%=b_types%>" class="input_width"/>
										<div id="down_<%=b_types%>"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								
								<tr>
									<td class="inquire_item4"> 上交甲方资料清单：</td>
									<td colspan="2">
										<input type="hidden" id="pk_<%=a_types%>" name="pk_<%=a_types%>" value=""/>
										<input type="file" name="<%=a_types%>" id="<%=a_types%>" class="input_width"/>
					    				<div id="down_<%=a_types%>"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								
								 <% 
							  		  if(businessType.equals("0110000061200000009")){
							    %>
								<tr>
									<td class="inquire_item4">备注：</td>
									<td colspan="3">
									<textarea  style="width:520px; height:80px;" id="memos" name="memos"   class="textarea" ></textarea>
									</td>
								</tr>
												 <%
							   		 }  
				  				%> 
				  						<tr>
									<td class="inquire_item4"> </td>
									<td colspan="2">
									 
									</td>
									<td class="inquire_form4"></td>
								</tr>
								
							</table>
						</div>
					</div>
					 
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
			 
				</div>
			</div>
	</form>
</body>

<script language="javaScript">
var cruTitle = "";
 
cruConfig.contextPath =  "<%=contextPath%>";
	var p_type="<%=p_type%>"
	var fileId = '<%=request.getParameter("id")%>'; 
	var sub_doc_type='<%=businessType%>';

function page_init(){
 
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	
	var docType = '<%=request.getParameter("docType")%>';	
	
	if(fileId!='null'){
		var querySql = " select t.*   from (select t.project_info_no,t.doc_type,  f.doc_file_type,p.project_name,decode( t.upload_status,'0','未上传','1','已上传',  t.upload_status) upload_status_name,    t.data_id,t.the_heir,t.upload_time, nvl(t.upload_status,0)upload_status,    f.ucm_id  ,     f.file_name, f.file_id,f.file_abbr  ,t.memos     from GP_WS_VSP_DATA t       left join bgp_doc_gms_file f   on t.data_id = f.relation_id   and f.bsflag='0'     left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no   where t.bsflag = '0'   and t.doc_type = '<%=businessType%>' and t.data_id='"+fileId+"'   ) t ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){ 
			
			document.getElementById("data_id").value = datas[0].data_id;
			document.getElementById("doc_type").value = datas[0].doc_type;
			document.getElementById("business_type").value = "<%=businessType%>"; 
			document.getElementById("project_name").value = datas[0].project_name;
			document.getElementById("project_info_no").value = datas[0].project_info_no;
			document.getElementById("file_abbr").value = "<%=fileAbbr%>";
			document.getElementById("parent_file_id").value = "<%=parent_file_id%>";
			document.getElementById("upload_status").value = datas[0].upload_status;
			
			if(sub_doc_type =="0110000061200000009" ){
				document.getElementById("memos").value = datas[0].memos;
			 }
			
			if(p_type!="0"){
				document.getElementById("ucm_id_a").value = datas[0].ucm_id;
				document.getElementById("the_heir").value = datas[0].the_heir;
				document.getElementById("upload_time").value = datas[0].upload_time;
			}
			
			 
			for(var i=0;i<datas.length;i++){
				if(""!=datas[i].ucm_id){
					var ucmId=datas[i].ucm_id;
					document.getElementById("pk_"+datas[i].doc_file_type).value =ucmId;
 
					$("#down_"+datas[i].doc_file_type).html("");
					$("#down_"+datas[i].doc_file_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+datas[i].file_name+"</a>");
				}
			}
		}
	} 	
}


function save(){  
	if(p_type=='1' ){ 
		var b_types=document.getElementById("pk_<%=b_types%>").value;
		var a_types=document.getElementById("pk_<%=a_types%>").value;
		if(b_types =="" && a_types ==""){
			alert("请上传附件"); return;
		}
  
	}else{ 
		var b_types=document.getElementById("<%=b_types%>").value;
		var a_types=document.getElementById("<%=a_types%>").value;
		if(b_types =="" && a_types ==""){
			alert("请上传附件"); return;
		}
 
	}  document.getElementById("upload_status").value ="1";
	  
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/ws/toSaveVspData.srq?businessType=<%=businessType%>";
	form.submit();
	newClose();
}
 
function checkForm(){
 
	if(p_type=='1'){ 
		var b_types=document.getElementById("pk_<%=b_types%>").value;
		var a_types=document.getElementById("pk_<%=a_types%>").value;
		if(b_types =="" && a_types ==""){
			alert("请上传附件"); return;
		}
		if(b_types !="" && a_types !=""){ 
			document.getElementById("upload_status").value ="1";
		}
	<%--  if (!isTextPropertyNotNull("pk_<%=a_types%>", "上交甲方资料清单")) return false;	 --%>	
	}else{
	<%--  if (!isTextPropertyNotNull("<%=a_types%>", "上交甲方资料清单")) return false;	 --%>
		var b_types=document.getElementById("<%=b_types%>").value;
		var a_types=document.getElementById("<%=a_types%>").value;
		if(b_types =="" && a_types ==""){
			alert("请上传附件"); return;
		}
		if(b_types !="" && a_types !=""){ 
			document.getElementById("upload_status").value ="1";
		}
	}
 
}


</script>
</html>
