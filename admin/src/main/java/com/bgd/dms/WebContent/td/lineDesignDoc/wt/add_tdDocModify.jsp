<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String isSingle=request.getParameter("isSingle")==null?"true":request.getParameter("isSingle");
    String businessType = request.getParameter("businessType")==null?"":request.getParameter("businessType");
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
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
var isSingle='<%=isSingle%>';

function save(){
	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/wt/toSaveLineDesignDoc.srq?isSingle="+isSingle;
	form.submit();
	newClose();
}

function checkForm(){
	if(null!=document.getElementById("projectName")){
		if (!isTextPropertyNotNull("projectName", "项目名称")) return false;	
	}
	if(""==document.getElementById("pk_0110000061100000043").value){
		if (!isTextPropertyNotNull("0110000061100000043", "测点设计坐标")) return false;	
	}
	return true;
}

function page_init(){
	var fileId = '<%=request.getParameter("id")%>';	
	var businessType = '<%=request.getParameter("businessType")%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	

	if(fileId!='null'){
		var querySql = " select * from(select b.project_info_no,p.project_name,t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.written_unit,b.written_time,b.writer,b.auditor,b.leader,b.exploration_method from gp_ws_tecnical_basic b left join gp_task_project p on b.project_info_no=p.project_info_no and p.bsflag='0' left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			document.getElementById("tecnical_id").value = datas[0].tecnical_id;
			if(null!=document.getElementById("projectName")){
				document.getElementById("projectName").value = datas[0].project_name;
			}
			document.getElementById("project_info_no").value = datas[0].project_info_no;
			document.getElementById("business_type").value = datas[0].business_type;
			for(var i=0;i<datas.length;i++){
				if(""!=datas[i].ucm_id){
					var ucmId=datas[i].ucm_id;
					document.getElementById("pk_"+datas[i].doc_file_type).value =ucmId;
					$("#down_"+datas[i].doc_file_type).html("");
					$("#down_"+datas[i].doc_file_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+datas[i].file_name+"</a>");
				}
			}
		}
	}else{
		document.getElementById("business_type").value = businessType;
		document.getElementById("file_abbr").value = fileAbbr;
	}		
}

function toDownload(){
	var elemIF = document.createElement("iframe");  
	var iName ="测线设计文档模板";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	
	elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/td/lineDesignDoc/wt/lineDesignList.xls&filename="+iName+".xls";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

//选择项目
function selectTeam(){
    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
    if(result!=""){
    	var checkStr = result.split("-");	
	        document.getElementById("project_info_no").value = checkStr[0];
	        document.getElementById("projectName").value = checkStr[1];
    }
}
</script>
</head>
<body onload="page_init();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>测点设计坐标：</td>
									<td colspan="2">
										<input type="hidden" id="pk_0110000061100000043" name="pk_0110000061100000043" value=""/>
										<input type="file" name="0110000061100000043" id="0110000061100000043" class="input_width"/>
					    				<div id="down_0110000061100000043"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4">测线设计文档：</td>
									<td colspan="2">
										<input type="hidden" id="pk_0110000061100000012" name="pk_0110000061100000012" value=""/>
										<input type="file" name="0110000061100000012" id="0110000061100000012" class="input_width"/>
					    				<div id="down_0110000061100000012"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4">测线设计文档模板：</td>
									<td colspan="2">
					    				<a style='color:blue;'  onclick="toDownload();">下载</a>
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
</html>
