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

function save(){
	if (!checkForm()) return;
	//业务编号ID
	var objPlan = jcdpCallService("WsTecnicalBasicSrv","submitTecnicalPlan","projectInfoNo=<%=projectInfoNo%>&businessType=<%=businessType%>");
	
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/wt/toSaveWorkDesignDoc.srq";
	form.submit();
	newClose();
}

function checkForm(){
	if (!isTextPropertyNotNull("title", "角点编号")) return false;	
	if (!isTextPropertyNotNull("north_location", "角点北坐标")) return false;	
	if (!isTextPropertyNotNull("south_location", "角点南坐标")) return false;	
	if (!isValidFloatProperty12_2("north_location","角点北坐标")) return false;  
	if (!isValidFloatProperty12_2("south_location","角点南坐标")) return false;  
	return true;
}

function page_init(){
	var fileId = '<%=request.getParameter("id")%>';	
	var businessType = '<%=businessType%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	

	if(fileId!='null'){
		var querySql = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.north_location,b.south_location from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			document.getElementById("tecnical_id").value = datas[0].tecnical_id;
			document.getElementById("title").value = datas[0].title;
			document.getElementById("north_location").value = datas[0].north_location;
			document.getElementById("south_location").value = datas[0].south_location;
			document.getElementById("business_type").value = datas[0].business_type;
		}
	}else{
		document.getElementById("business_type").value = businessType;
		document.getElementById("file_abbr").value = fileAbbr;
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
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>角点编号：</td>
									<td class="inquire_form4">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input type="text" id="title" name="title" value="" class="input_width" />
									</td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>角点北坐标：</td>
									<td class="inquire_form4"><input type="text" id="north_location" name="north_location" value="" class="input_width" /></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>角点东坐标：</td>
									<td class="inquire_form4"><input type="text" id="south_location" name="south_location" value="" class="input_width" /></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"></td>
									<td colspan="2"><span style="display:none">
									<input type="file" name="file" id="file" class="input_width"/>
					    				</span></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
									<td class="inquire_item4"></td>
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
