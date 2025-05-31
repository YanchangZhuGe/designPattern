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
		String id = request.getParameter("id")==null?"":request.getParameter("id");
		String fileAbbr = request.getParameter("fileAbbr")==null?"":request.getParameter("fileAbbr");
		String p_size = request.getParameter("pageSize")==null?"":request.getParameter("pageSize");
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
									<td class="inquire_item4"> 上传人：</td>
									<td class="inquire_form4">
							             <input name="idata_id" id="idata_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="doc_type" id="doc_type" class="input_width" value="<%=businessType%>" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="<%=fileAbbr%>" type="hidden" readonly="readonly"/>          
							           	<input name="business_type" id="business_type" class="input_width" value="<%=businessType%>" type="hidden" readonly="readonly"/> 
							         	<input name="upload_status" id="upload_status" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="p_size" id="p_size" class="input_width" value="<%=p_size%>" type="hidden" readonly="readonly"/>
							             <input name="data_length" id="data_length" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input type="text" id="the_heir" name="the_heir" value="<%=userName%>" class="input_width" />
									</td>
									
									<td class="inquire_item4">上传时间：</td>
									<td class="inquire_form4"> 
										<input type="text" id="upload_time" name="upload_time" value="<%=curDate%>" class="input_width" readonly="readonly"/> 
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(upload_time,tributton1);" />
								 
									</td>
									
									
								</tr>

								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>内部资料上交清单：</td>
									<td colspan="2">
										<input type="hidden" id="pk_<%=businessType%>" name="pk_<%=businessType%>" value=""/>
										<input type="file" name="<%=businessType%>" id="<%=businessType%>" class="input_width"/>
					    				<div id="down_<%=businessType%>"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
							    <tr>
									<td class="inquire_item4">项目名称：</td>
									<td  colspan="3" > 
									<textarea  style="width:520px; height:250px;" id="project_name" name="project_name"   class="textarea" ></textarea>
	  							    </td> 
				 
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

<script language="javaScript">
var cruTitle = "";
 
cruConfig.contextPath =  "<%=contextPath%>";
	var p_size = '<%=p_size%>'; 


function page_init(){
 
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	
	var docType = '<%=request.getParameter("docType")%>';	
 
	if(p_size>0){
		var querySql = " select t.*   from (select t.project_info_no,   p.project_name,     t.idata_id   from GP_WS_VSP_INTERNADATA t   left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no     where t.bsflag = '0'       and t.doc_type = '<%=businessType%>'       and t.upload_status='0' and　 t.idata_id in (<%=id%>)    ) t ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){ 
			 var p_name="";
			 var p_id="";
			 var i_id="";
			for(var i=0;i<datas.length;i++){ 
				var nums=i+1;
				p_name = p_name + "\n" + nums+": "+ datas[i].project_name;
				p_id = p_id + "," + datas[i].project_info_no;
				i_id = i_id + "," + datas[i].idata_id ;
			 
			}
			document.getElementById("project_info_no").value =p_id.substr(1);
			document.getElementById("project_name").value =p_name.substr(1);
			document.getElementById("idata_id").value =i_id.substr(1); 
			document.getElementById("data_length").value=datas.length;
		}
		
		
	} 	
}


function save(){
	if (!checkForm()) return;
	document.getElementById("upload_status").value ="1";
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/ws/toSaveVspIdata.srq?businessType=<%=businessType%>";
	form.submit();
	newClose();
}
 
function checkForm(){
 
		if (!isTextPropertyNotNull("<%=businessType%>", "内部资料上交清单")) return false;	
		 
	return true;
}


</script>
</html>
