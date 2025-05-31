<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = (String)user.getOrgId();
	String org_subjection_id = (String)user.getSubOrgIDofAffordOrg();
	String user_id = (String)user.getUserId();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	String projectType = user.getProjectType();

	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());


	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var file_id = '';
	var ucm_id = '';
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
	function view_doc(file_id){
		if(file_id != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
			var fileExtension = retObj.docInfoMap.dWebExtension;
			window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
		}else{
	    	alert("该条记录没有文档");
	    	return;
		}
			
	}
</script>
<title>列表页面</title>
</head>
<body  scroll="no" ><!-- style="background:#fff" onload="refreshData()" -->

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			   	<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{ids}' onclick=check(this)/>" >
			  		<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="<input type='hidden' id ='file_name' value='{file_name}'/> {project_name} ">项目名称</td>
			  	<td class="bt_info_even" exp="{pro_status}">审批情况</td>
			  	<td class="bt_info_odd" exp="{create_date}">提交时间</td>
			  	<td class="bt_info_even" exp="{modifi_date}">审批时间</td>
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
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">计划文档</a></li>
        <li><a href="#" onclick="getTab(this,2)" >流程</a></li>
        <li><a href="#" onclick="getTab(this,3)" >备注</a></li>
        <!-- <li><a href="#" onclick="getTab(this,4)" >分类码</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow-y:auto;">
		<div id="tab_box_content1" class="tab_box_content" > 
			<iframe width="100%" height="100%" src="" name="attachement" id="attachement" frameborder="0"  marginheight="0" marginwidth="0" >
			</iframe>
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<wf:startProcessInfo   title=""/><!-- buttonFunctionId="F_QUA_SINGLE_001" -->
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4">备注:</td>
			    	<td class="inquire_form4"><textarea id="note" name="note" cols="" rows="" class="textarea"></textarea></td>
			    </tr>
		    </table> 
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var file_name = '';
	var id = "";
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (var i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	function createTable(){
		queryData(1);
		var obj = document.getElementById("queryRetTable").rows[1];
		if(obj!=null && obj.cells[0]!=null){
			var ids = obj.cells[0].firstChild.value;
			var index = ids.indexOf(":");
			file_id = ids.substring(0,index);
			ucm_id = ids.substring(index);
		}
	}
	function getNote(){
		var project_info_no = '<%=project_info_no%>';
		var org_id = '<%=org_id%>';
		var org_subjection_id = '<%=org_subjection_id%>';
		var user_id = '<%=user_id%>';
		var sql = "select t.control_id ,t.project_info_no ,t.file_id ,t.file_name ,t.note from bgp_qua_control t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode=='0'){
			if(retObj.datas == null || retObj.datas.length <=0){
				sql = "insert into bgp_qua_control(control_id ,project_info_no ,org_id ,org_subjection_id ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
					" values((select lower(sys_guid()) from dual),'"+project_info_no+"' ,'"+org_id+"' ,'"+org_subjection_id+"' ," +
					" '0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');";
				var insert = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+sql);
			}else if(retObj.datas != null && retObj.datas.length > 0){
				var data = retObj.datas[0];
				var control_id = data.control_id;
				id = control_id ;
				var control_file_id = data.file_id;
				if(control_file_id==null || control_file_id==''){
					sql = "select t.file_id ,t.file_name from bgp_doc_gms_file t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"' and t.relation_id like'control:%'";
					retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
					if(retObj!=null && retObj.returnCode=='0'){
						if(retObj.datas != null && retObj.datas[0]!=null && retObj.datas.length >0){
							var data = retObj.datas[0];
							var file_id = data.file_id;
							var file_name = data.file_name
							sql =  "update bgp_qua_control t set t.control_id ='"+control_id+"' ,t.updator_id='"+user_id+"' ," +
							" t.modifi_date = sysdate ,t.project_info_no ='"+project_info_no+"', t.file_id ='"+file_id+"' ,"+
							" t.file_name ='"+file_name+"' where t.control_id ='"+control_id+"';" ;
						    var update = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+sql);
						}
					}
				}
			}
		}
		sql = "select t.control_id ,t.project_info_no ,t.file_id ,t.file_name ,t.note from bgp_qua_control t where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'";
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj.datas != null && retObj.datas.length > 0){
			var data = retObj.datas[0];
			var control_id = data.control_id;
			var note = data.note;
			document.getElementById("note").value = note;
			id = control_id ;
		}
	}
	function refreshData(){
		getNote();
		
		var org_subjection_id = '<%=org_subjection_id%>';
		var relationId =  'control:' + org_subjection_id;
		var project_info_no = '<%=project_info_no%>';
		document.getElementById("attachement").src='<%=contextPath%>/qua/sProject/plan/file_list.jsp?qualityControl=1&relationId='+relationId+'&project_info_no='+project_info_no;
		cruConfig.queryStr = " select d.* from(select dd.* from ("+
		" select  distinct t.file_id,concat(concat(f.file_id ,':'),f.ucm_id) ids ,f.file_name ,f.ucm_id ," +
		" decode(wf.proc_status,'1','待审核','3','审核通过','4','审核不通过','5','退回','未上报') pro_status ," +
		" r.examine_start_date create_date ,substr(r.examine_end_date,0,10) modifi_date ,p.project_name " +
		" from bgp_qua_control t" +
		" join bgp_doc_gms_file f on t.file_id = f.file_id and f.bsflag ='0'" +
		" join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'" +
		" left join common_busi_wf_middle wf on t.file_id = wf.business_id and wf.bsflag='0'" +
		" left join wf_r_examineinst r on wf.proc_inst_id = r.procinst_id and r.examine_end_date is not null" +
		" where t.bsflag = '0' and t.project_info_no ='"+project_info_no+"'"+
		" )dd order by dd.modifi_date desc ) d where rownum =1";
		queryData(1);
		frameSize();
		resizeNewTitleTable();
		var obj = document.getElementById("queryRetTable").rows[1];
		if(obj!=null && obj.cells[0]!=null){
			if(obj.cells[0].firstChild.value!=null){
				var ids = obj.cells[0].firstChild.value;
				var index = ids.indexOf(":");
				file_id = ids.substring(0,index);
				ucm_id = ids.substring(index-(-1));
				file_name = obj.cells[2].firstChild.value;
			}
		}
		if(file_id==null || file_id==''){
			alert("没有上传文档");
			return ;
		}
		var fileExtension = '';
		var ids = file_id + ":" +ucm_id;
		if(ids != ""){
			var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+ids);
			if(retObj!=null && retObj.returnCode=='0'){
				if(retObj.docInfoMap!=null && retObj.docInfoMap.dWebExtension!=null){
					fileExtension= retObj.docInfoMap.dWebExtension;
				}
			}
		}else{
	    	alert("该条记录没有文档");
	    	return;
		} 

		processNecessaryInfo={
			businessTableName:"BGP_DOC_GMS_FILE",	
			businessType:"5110000004100000019", 
			businessId: file_id,
			businessInfo:file_name,
			applicantDate: '<%=appDate%>'
		};
		
		processAppendInfo = {
				control_id: id
		};
		loadProcessHistoryInfo();
	}
	refreshData();
	
	function loadBusinessInfoStatus(){
		createTable();
	}
	
	/* 输入的是否是数字 */
	function checkIfNum(event){
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			return false;
		}
	}
	/* 详细信息 */
	function loadDataDetail(record_id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
	
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function toAdd() {
		if(file_id==null || file_id==''){
			alert('请上传质量控制计划文档!');
		}
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var recordId = '';
		var dConfirm = false;
		for (var i = 0;i< objLen;i++){   
			if (obj [i].checked==true) { 
				recordId=obj [i].value;
				var text = '你确定要删除第'+i+'行吗?';
				if(dConfirm || window.confirm(text)){
			    	dConfirm = true;
			    	 var retObj = jcdpCallService("QualityItemsSrv","deleteRecord", "record_id="+recordId);
				}
			}   
		} 
		if(dConfirm == false){
			alert("请选择删除的记录!")
		}
		
	}
	/* 修改 */
	function newSubmit() {
		var substr ='';
		var control_id = id;
		var note = document.getElementById("note").value;
		var user_id ='<%=user_id%>';
		if(control_id!=null && control_id!=''){
			substr = "update bgp_qua_control t set t.project_info_no ='<%=project_info_no%>' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,note='"+note+"'"+
			" where t.control_id ='"+control_id+"';"
		}
		if(substr!=''){
			var retObj = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+substr);
			if(retObj.returnCode =='0'){
				alert("保存成功!");
			}
		}else{
			alert("保存失败!");
		}
	}
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);
</script>

</body>
</html>
