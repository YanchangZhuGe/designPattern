<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="wf" prefix="wf"%> 
<%@ taglib uri="auth" prefix="auth"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	if(projectInfoNo==null){
		projectInfoNo = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH24:mm:ss");
	String appDate = df.format(new Date());
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/qua/commom/quality.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<%-- <script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script> --%>
<style type="text/css">
</style>
<script type="text/javascript" >
	
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr >
				    <td class="ali_cdn_name">标准类型</td>
				    <td class="ali_cdn_input">
					    <select id="file_type" name="file_type" onchange="refreshData()" class="select_width">
					    	<option value="%">请选择</option>
					    	<!-- <option value="国家">国家标准</option>
					    	<option value="企业">企业标准</option>
					    	<option value="行业">行业标准</option> -->
					    </select></td>
				    <td class="ali_cdn_name">文档名称</td>
				    <td class="ali_cdn_input"><input type="text" id="name" name="name" class="input_width"/></td>
				    <td class="ali_query"><span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span> </td>
				    <td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span> </td>
				    <td>&nbsp;</td>
				    <%-- <auth:ListButton functionId="F_QUA_FILE_001" css="sc" event="onclick='queryDelete()'" title="JCDP_btn_delete"></auth:ListButton> --%>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</div>
	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{qua_file_id}' />" >
	      	<input type='checkbox' name='chk_entity_id' value='' onclick='check()'/></td>
	      <td class="bt_info_even" autoOrder="1">序号</td> 
	      <td class="bt_info_odd" exp="<a href='#' onclick=openFile('{ids}')><font color='blue'>{file_name}</font></a>">文档名称</td>
	      <td class="bt_info_even" exp="{user_name}">上传者</td>
	      <td class="bt_info_odd" exp="{create_date}">上传日期</td>
	    </tr>
	  </table>
	</div>
  	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
    </div>
    <div class="lashen" id="line"></div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-10);
	function clearQueryText(){
		document.getElementById("file_type").options[0].selected = true;
		document.getElementById("name").value = "";
		refreshData();
	}
	function getFileType(){
		var typeObj = document.getElementById("file_type");
		var querySql = "select t.* from bgp_doc_gms_file t where t.bsflag ='0' and t.is_file ='0' "+
		"and t.project_info_no is null and t.parent_file_id ='8ad878dd38c37ae40138e4d5f6830130' and t.file_name like'%标准%'";
		var retObj = syncRequest("Post" , cruConfig.contextPath + appConfig.queryListAction , "querySql="+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode =='0'){
			if(retObj.datas!=null && retObj.datas.length>0){
				for(var i =0 ;i<retObj.datas.length;i++){
					var data = retObj.datas[i];
					var type_id = data.file_id;
					var type_name = data.file_name;
					typeObj.options[i+1] = new Option(type_name ,type_id);
				}
			}
		}
	}
	getFileType();
	function refreshData(){
		var project = '<%=projectInfoNo%>';
		if(project==null || project==''){
			alert("请选择项目");
			return;
		}
		var value = document.getElementById("file_type").options.value;
		var name = document.getElementById("name").value;
		cruConfig.queryStr = "select t.qua_file_id ,t.file_id , f.file_name , f.creator_id , u.user_name, f.create_date , "+
		" concat(concat(t.file_id,':'),f.ucm_id) ids from bgp_qua_files t  "+
		" join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0' "+
		" join p_auth_user u on f.creator_id = u.user_id and u.bsflag ='0' "+
		" where t.bsflag = '0' and u.bsflag = '0' and f.bsflag='0' "+
		" and t.project_info_no = '"+project+"' "+
		" and f.file_name like '%"+name+"%' and f.parent_file_id like '%"+value+"%' order by f.modifi_date desc";
		queryData(1);
	}
	refreshData();
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var tr =  obj.parentNode ;
    		obj = tr.cells[0].firstChild;
    		obj.checked = true;
    	}
	}
	function loadProcess(){
		var project_info_no = '<%=projectInfoNo%>'
			processNecessaryInfo={
	    			businessTableName:"bgp_qua_files",	
	    			businessType:"5110000004100000043", 
	    			businessId: project_info_no,
	    			businessInfo:"发起了申请质量引用标准审批",
	    			applicantDate: '<%=appDate%>'
	   		};
	    	
	   		processAppendInfo = {
	   				project_info_no: project_info_no
	   		};
	   		deleteTableTr('processInfoTab');
	   		loadProcessHistoryInfo();
	}
	function openFile(ids){
		var ucm_id = ids.split(":")[0];
		if(ucm_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ucm_id);
			var fileExtension = '';
			if(retObj.docInfoMap !=null && retObj.docInfoMap.dWebExtension!=null ){
				fileExtension = retObj.docInfoMap.dWebExtension;
			}
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+ucm_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
	}
</script>
</body>
</html>

