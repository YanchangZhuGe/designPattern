<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="java.text.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectName = user.getProjectName();
	if(projectName==null){
		projectName = "";
	}
	
	String taskbookId = request.getParameter("taskbookId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null){
		projectInfoNo = user.getProjectInfoNo();
	}
	Date sysdate=new Date();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String nowDate = df.format(sysdate);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head> 
    <title>处理解释任务书</title> 
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/stream-v1.css" rel="stylesheet" type="text/css" />	
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/stream-v1.js"></script>
 </head> 
 
 <body onload="refreshData()">
 <form name="form1" id="form1" method="post" action="<%=contextPath%>/wt/prointe/saveOrUpdateTaskBookWt.srq">
 <input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo %>"/>
 <input type="hidden" id="upload_file_name" name="upload_file_name" value=""/>
 <input type="hidden" id="taskbook_id" name="taskbook_id" value="<%=taskbookId %>"/>
 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
	    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	     	<tr>
		    	<td class="inquire_item4"><font color="red">*</font>项目名称:</td>
		    	<td class="inquire_form4"><input name="project_name" id="project_name" type="text" class="input_width" value="<%=projectName %>" readonly="readonly" /></td>
		    	<td class="inquire_item4"><font color="red">*</font>下达人:</td>
		    	<td class="inquire_form4"><input name="issuer" id="issuer" type="text" class="input_width" value=""  /></td>
		    </tr>
	    	<tr>
		    	<td class="inquire_item4"><font color="red">*</font>投资单位:</td>
		    	<td class="inquire_form4"><input name="investment_unit" id="investment_unit" type="text" class="input_width" value="" /></td>
		    	<td class="inquire_item4"><font color="red">*</font>处理解释负责人:</td>
		    	<td class="inquire_form4"><input name="prointe_head" id="prointe_head" type="text" class="input_width" value="" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item4"><font color="red">*</font>文档名称：</td>
				<td class="inquire_form4"><input name="file_name" id="file_name" type="text" class="input_width" size="50" value="" /></td>
		    </tr> 
			<tr>
		    	<td class="inquire_item4"><font color="red">*</font>文档：</td>
		    	<td colspan = "3">
		    		<div id="i_select_files"></div>
			   	 	<div id="i_stream_files_queue"></div> 
				</td>
		    </tr>  
	    </table> 
    	<div id="showinfo" style="display:none;"></div> 
  <div id="oper_div">
	<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
 	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
  </div> 
  </div>
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var querySql="SELECT tb.TASKBOOK_ID, tb.PROJECT_INFO_NO, tb.FILE_NAME, tb.UCM_ID, tb.CREATE_DATE, tb.UPDATATOR, tb.BSFLAG, tb.ISSUER, tb.INVESTMENT_UNIT, tb.PROINTE_HEAD,"
			+"p.PROJECT_NAME "
			+"FROM GP_OPS_PROINTE_TASKBOOK_WT tb left join GP_TASK_PROJECT p on tb.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.BSFLAG='0' "
			+"where tb.BSFLAG='0' and tb.TASKBOOK_ID='<%=taskbookId%>'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null){
			$("#project_name").val(datas[0].project_name);
			$("#issuer").val(datas[0].issuer);
			$("#investment_unit").val(datas[0].investment_unit);
			$("#prointe_head").val(datas[0].prointe_head);
			$("#file_name").val(datas[0].file_name);
		}
	}
	function newSubmit() {
		if (!checkForm()) return;
		document.getElementById("form1").submit();
		var ctt = top.frames('list');
		ctt.location.reload();
		newClose();
		
	}
	function checkForm(){ 	
		var prointe_head = $("#prointe_head").val();
		var issuer = $("#issuer").val();
		var file_name = $("#file_name").val();
		
		if (file_name==""||file_name==null){
			alert("文件不能为空！");		
			return false;	
		}		
		if (issuer==""||issuer==null){
			alert("下达人不能为空！");		
			return false;	
		}		
		if (prointe_head==""||prointe_head==null){
			alert("负责人不能为空！");		
			return false;	
		}
		return true;
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
		            document.getElementById("upload_file_name").value = file.name;
		            
		          //  alert("文件：  已上传成功！");
		        	  },
		        onUploadError: function(status, msg) {
		        	      alert("上传文件出错，代码：" + status
		        	       + "|错误：" + msg);
		         }
		    };
		    var _t = new Stream(config);
	
</script>
</body>
</html>