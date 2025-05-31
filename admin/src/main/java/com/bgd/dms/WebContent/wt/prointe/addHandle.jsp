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
    String project_name=user.getProjectName();
    String project_info_no=user.getProjectInfoNo();
    String id=request.getParameter("id");
     String curDate = format.format(new Date());
 
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
<script type="text/javascript" src="<%=contextPath%>/js/stream-v1.js"></script>
<link href="<%=contextPath%>/css/stream-v1.css" rel="stylesheet" type="text/css" />	


 

</head>
<body onload="page_init();">
	<form id="CheckForm" action="" method="post" >
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
				 
							<table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
							       <td class="inquire_item4"><span class="red_star">*</span>项目名称：</td>
						           <td class="inquire_form4">
						                <input name="projectName" id="projectName" class="input_width" value="<%=project_name %>" type="text" readonly="readonly"/>
						                <input name="project_info_no" id="project_info_no" class="input_width" value="<%=project_info_no %>" type="hidden" />
						                <input name="design_id" id="design_id" class="input_width" value="<%=id %>" type="hidden" />
						                
 						           </td>
							       <td class="inquire_item4"><span class="red_star">*</span>编写人：</td>
						           <td class="inquire_form4">
						               <input name="writer" id="writer" class="input_width" value="" type="text" />
 						           </td>
 						         </tr>
 						         <tr>
									<td class="inquire_item4">处理计划开始时间：</td>
									<td class="inquire_form4">
									    <input name="proces_plan_startdate" id="proces_plan_startdate" class="input_width" value="" type="text" readonly="readonly"/>
									  &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(proces_plan_startdate,tributton1);" />
									</td>
									<td class="inquire_item4">处理计划结束时间：</td>
									<td class="inquire_form4">
									    <input name="proces_plan_enddate" id="proces_plan_enddate" class="input_width" value="" type="text" readonly="readonly"/>
									  &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(proces_plan_enddate,tributton2);" />
									</td>
							     </tr>
								
								<tr>
									<td class="inquire_item4">解释计划开始时间：</td>
									<td class="inquire_form4">
									    <input name="interp_plan_startdate" id="interp_plan_startdate" class="input_width" value="" type="text" readonly="readonly"/>
									  &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(interp_plan_startdate,tributton3);" />
									</td>
									<td class="inquire_item4">解释计划结束时间：</td>
									<td class="inquire_form4">
									    <input name="interp_plan_senddate" id="interp_plan_senddate" class="input_width" value="" type="text" readonly="readonly"/>
									  &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(interp_plan_senddate,tributton4);" />
									</td>
							    </tr>
								<tr>
								<td class="inquire_item4">处理解释设计：</td>
								<td class="inquire_form4">
								<input type="text" name="file_name"  id="file_name" readonly style="background:#CCCCCC"></input>
								</td>
								 
							 
								
							  </tr>
							  <tr>
							  	<td class="inquire_item4"><font color="red">*</font>文档：</td>
		    	                 <td class="inquire_form4" colspan="3">
		    	                 	<div id="i_select_files" ></div>
			   	                	<div id="i_stream_files_queue" ></div> 
				                 </td>
		   
								
							    </tr>
							</table>
					 
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
	</form>
	<script language="javaScript">
 

  
cruConfig.contextPath =  "<%=contextPath%>";

 

function save(){
	if (!checkForm()) return;
	if(!checkUploadFileSuc()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/wt/prointe/saveOrUpdateHandle.srq";
	form.submit();
	var ctt = top.frames('list');
	ctt.location.reload();
	newClose();
 
}

function checkForm(){
	if(null!=document.getElementById("projectName")){
		if (!isTextPropertyNotNull("projectName", "项目名称")) return false;	
	}
	if (!isTextPropertyNotNull("writer","编写人")) return false;	
 
	return true;
}

function page_init(){
	debugger;
 		var querySql="select tb.* , p.PROJECT_NAME "
			+"FROM GP_OPS_PROINTE_DESIGN_WT tb left join GP_TASK_PROJECT p on tb.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.BSFLAG='0' "
			+"where tb.BSFLAG='0' and tb.design_id='<%=id%>'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas[0]!=null){
			$("#project_name").val(datas[0].project_name);
			$("#writer").val(datas[0].writer);
			$("#proces_plan_startdate").val(datas[0].proces_plan_startdate);
			$("#proces_plan_enddate").val(datas[0].proces_plan_enddate);
			$("#interp_plan_startdate").val(datas[0].interp_plan_startdate);
			$("#interp_plan_senddate").val(datas[0].interp_plan_senddate);
			$("#file_name").val(datas[0].file_name);

		 
 
	}
		
}

/**
 * 配置文件（如果没有默认字样，说明默认值就是注释下的值）
 * 但是，on*（onSelect， onMaxSizeExceed...）等函数的默认行为
 * 是在ID为i_stream_message_container的页面元素中写日志
 * 在线文档上传
 */
 var config = {
	        multipleFiles: true, /** 多个文件一起上传, 默认: false */
	        swfURL : "<%=contextPath%>/swf/FlashUploader.swf", /** SWF文件的位置 */
	        tokenURL : "<%=contextPath%>/tk", /** 根据文件名、大小等信息获取Token的URI（用于生成断点续传、跨域的令牌） */
	        frmUploadURL : "<%=contextPath%>/fd;", /** Flash上传的URI */
	        uploadURL : "<%=contextPath%>/upload", /** HTML5上传的URI */
	        browseFileBtn : "<div id='selectFile' style='color:red' >选择上传文件</div>",
	        simLimit : 1,
	        onComplete :  function(file) {
	            document.getElementById("file_name").value = file.name;
		          //  alert("文件：  已上传成功！");
	        	  },
	        onUploadError: function(status, msg) {
	        	      alert("上传文件出错，代码：" + status
	        	       + "|错误：" + msg);
	         }
	    };
	    var _t = new Stream(config);
	    
	    
		function  checkUploadFileSuc(){
		    var fileName = document.getElementById("file_name").value;
		    if(fileName == null || fileName==""){
			    alert("请选择文件后在提交！");
			    return false;
		    }
		    return true;
		}

</script>
</body>
</html>
