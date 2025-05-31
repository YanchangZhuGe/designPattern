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
	String projectInfoNo = user.getProjectInfoNo();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
	
	String businessType = request.getParameter("docType")==null?"":request.getParameter("docType");
	String parent_file_id = request.getParameter("parent_file_id")==null?"":request.getParameter("parent_file_id");
	String id = request.getParameter("id")==null?"":request.getParameter("id");
	String fileAbbr = request.getParameter("fileAbbr")==null?"":request.getParameter("fileAbbr");
	String p_type = request.getParameter("p_type")==null?"":request.getParameter("p_type");
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
							<table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"> 文档编号：</td>
									<td class="inquire_form4">
							             <input name="audit_id" id="audit_id" class="input_width" value="" type="hidden" readonly="readonly"/>
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
									<td class="inquire_item4">上传时间：</td>
									<td class="inquire_form4"> 
										<input type="text" id="upload_time" name="upload_time" value="<%=curDate%>" class="input_width" readonly="readonly"/> 
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(upload_time,tributton1);" />
								 
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>成果报告：</td>
									<td  >
										<input type="hidden" id="pk_<%=businessType%>_0" name="pk_<%=businessType%>_0" value=""/>
										<input type="file" name="<%=businessType%>_0" id="<%=businessType%>_0" class="input_width"/>
										<div id="down_<%=businessType%>_0"></div>
									</td>
									<td></td>
									<td><img id="add_1" onclick="addRow()" src="<%=contextPath%>/images/images/zj.png" width="20" height="20" style="cursor: hand;"/></td>
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
<script type="text/javascript">
//审批页面 隐藏添加图片按钮
/* if("view"==action){
	$("[id^=add_]").css("display","none");
} */
</script>
</body>
<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
  
cruConfig.contextPath =  "<%=contextPath%>";
    var p_type="<%=p_type%>"
	var fileId = '<%=request.getParameter("id")%>'; 
function page_init(){
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	
	var docType = '<%=request.getParameter("docType")%>';	
	
	if(fileId!='null'){
		var querySql = " select t.*   from (select t.project_info_no,t.doc_type, p.project_name,decode( t.upload_status,'0','未上传','1','已上传',  t.upload_status) upload_status_name,    t.audit_id,t.the_heir,t.upload_time, nvl(t.upload_status,0)upload_status,    f.ucm_id  ,     f.file_name, f.file_id,f.file_abbr       from GP_WS_VSP_AUDIT t       left join bgp_doc_gms_file f   on t.audit_id = f.relation_id   and f.bsflag='0'     left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no   where t.bsflag = '0'   and t.doc_type = '<%=businessType%>' and t.audit_id='"+fileId+"'   ) t";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			
			document.getElementById("audit_id").value = datas[0].audit_id;
			document.getElementById("doc_type").value = datas[0].doc_type;
			document.getElementById("business_type").value = "<%=businessType%>"; 
			document.getElementById("project_name").value = datas[0].project_name;
			document.getElementById("project_info_no").value = datas[0].project_info_no;
			document.getElementById("file_abbr").value = "<%=fileAbbr%>";
			document.getElementById("parent_file_id").value = "<%=parent_file_id%>";
			document.getElementById("upload_status").value = datas[0].upload_status;
			
			if(p_type!="0"){
				document.getElementById("ucm_id_a").value = datas[0].ucm_id;
				document.getElementById("the_heir").value = datas[0].the_heir;
				document.getElementById("upload_time").value = datas[0].upload_time;
			}
			
			for(var i=0;i<datas.length;i++){
				if(""!=datas[i].ucm_id){
					var ucmId=datas[i].ucm_id;
					if(i>=1){
						addRow();
					}
					document.getElementById("pk_<%=businessType%>_"+i).value =ucmId;
					var str=datas[i].file_name==""?"":datas[i].file_name.substr(0,10)+'...';
					$("#down_<%=businessType%>_"+i).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+str+"</a>");
				}
			}
		}
	} 
}


var i=0;
function addRow(){
	var num=++i;
	var tr=document.all.tableDoc.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='pk_<%=businessType%>_"+num+"' name='pk_<%=businessType%>_"+num+"' value=''/>";
  	
	var td = tr.insertCell(1);
	td.innerHTML="<input type='file' name='<%=businessType%>_"+num+"' id='<%=businessType%>_"+num+"' class='input_width'/><div id='down_<%=businessType%>_"+num+"'></div>";

	tr.insertCell(2).innerHTML="";
 
		tr.insertCell(3).innerHTML="<img name='"+num+"' onclick='delRow()' src='<%=contextPath%>/images/delete.png' width='20' height='20' style='cursor: hand;'/>";
 
}

function delRow(){
	//获得当前点击标签的附件ucm_id值 
    var oldUcmId=$("#pk_<%=businessType%>_"+event.srcElement.name).val();
    //如果存在旧文件，则先删除
	if(""!=oldUcmId&&null!==oldUcmId){
		if (!window.confirm("确认要删除吗?")) {
			return;
		}	
		var sql =" update bgp_doc_gms_file t set t.bsflag='1' where ucm_id="+oldUcmId;
		retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
	}
	                          
	document.all.tableDoc.deleteRow(window.event.srcElement.parentElement.parentElement.rowIndex);
}


function save(){
	if (!checkForm()) return;
	document.getElementById("upload_status").value ="1";
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/ws/toSaveVspAudit.srq?businessType=<%=businessType%>";
	form.submit();
	newClose();
}

function checkForm(){
 
	if(p_type=='1'){ 
		if (!isTextPropertyNotNull("pk_<%=businessType%>_0", "成果报告")) return false;	
	}else{
		if (!isTextPropertyNotNull("<%=businessType%>_0", "成果报告")) return false;	
	}  
	 

	return true;
}


</script>
</html>
