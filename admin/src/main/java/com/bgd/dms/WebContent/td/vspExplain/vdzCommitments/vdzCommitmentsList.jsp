<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory,com.bgp.gms.service.td.srv.TdDocServiceSrv"%> 

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = user.getProjectInfoNo();
	
	String fileAbbr = request.getParameter("fileAbbr");
	if(fileAbbr==null || "".equals(fileAbbr)){
		fileAbbr = resultMsg.getValue("fileAbbr");
	}

	String doc_type = request.getParameter("doc_type");
	if(doc_type==null || "".equals(doc_type)){
		doc_type = resultMsg.getValue("doc_type");
	}

 

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

  <title>处理解释任务书</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    	<td class="ali_cdn_name">项目名称</td>
			    <td  width="20%" > <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
    			<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
    			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   </td>
			  	<td class="ali_cdn_name">单据状态</td>
			    <td class="ali_cdn_input"><select name="s_proc_status" id="s_proc_status" class="select_width" >
			    <option value="">请选择</option>
			    <option value="1">未下达</option>
			    <option value="2">已下达</option>
			    </select></td>
			    <td class="ali_cdn_name">年度</td>
			    <td class="ali_cdn_input"><select name="s_proc_year" id="s_proc_year" class="select_width" >
			    <option value="">请选择</option>
			    <option value="2012">2012</option>
			   	    <option value="2013">2013</option>
			   	    	    <option value="2014">2014</option>
			   	    	    	    <option value="2015">2015</option>
			   	    	    	    	    <option value="2016">2016</option>
			   	    	    	    	    	    <option value="2017">2017</option>
			   	    	    	    	    	    	    <option value="2018">2018</option>
			   	    	    	    	    	    	    	    <option value="2019">2019</option>
			   	    	    	    	    	    	    	    	    <option value="2020">2020</option>
			   	    	    	    	    	    	    	    	    	    <option value="2021">2021</option>
			   	    	    	    	    	    	    	    	    	    	    <option value="2022">2022</option>
			   	    	    	    	    	    	    	    	    	    	    	    <option value="2023">2023</option>
			   	    	    	    	    	    	    	    	    	    	    	     <option value="2024">2024</option>
			   	    	    	    	    	    	    	    	    	    	    	      <option value="2025">2025</option>
			   	    	    	    	    	    	    	    	    	    	    	    
			    </select></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd(1)'" title="JCDP_btn_add"></auth:ListButton>	  	
			  	<auth:ListButton functionId="" css="xg" event="onclick='toAdd(0)'" title="JCDP_btn_edit"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
 				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{commitments_id}-{status_type}-{project_info_no}' id='rdo_entity_id_{commitments_id}' onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">采集资料上交清单 </td>	
			      <td class="bt_info_odd" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id_a}&emflag=0>{file_name_a}</a>">处理解释任务书</td>
			      <td class="bt_info_even" exp="{give_people}">下达人</td>		
			      <td class="bt_info_odd" exp="{todeal_people}">处理人员</td>
			      <td class="bt_info_even" exp="{explain_people}">解释人员</td>
			      <td class="bt_info_odd" exp="{give_time}">下达时间</td>
			      <td class="bt_info_even" exp="{proc_status_name}">状态</td>	
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			  <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>	
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
   
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				 <table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">文档编号： </td>
									<td class="inquire_form4"> <input  name="ucm_id_a" id="ucm_id_a" class="input_width" value="自动生成" type="text" readonly="readonly"/></td>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"> <input name="project_name" id="project_name" class="input_width" value="" type="text" readonly="readonly"/></td> 
				 
								</tr>
								<tr>
									<td class="inquire_item4">采集资料上交清单：</td>
									<td class="inquire_form4"  >
									<input name="commitments_id" id="commitments_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="outsourcing" id="outsourcing" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="status_type" id="status_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="s_id" id="s_id" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="s_name" id="s_name" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="a_s_id" id="a_s_id" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="a_s_name" id="a_s_name" class="input_width" value="" type="hidden" readonly="readonly"/>
 
								 		<div id="down_0110000061100000124"></div>
									</td>
									<td  class="inquire_item4"><span class="red_star">*</span>处理解释任务书</td>
									<td  class="inquire_form4" >
					    				<div id="down_0110000061200000006"></div>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">下达人：</td>
									<td class="inquire_form4">
										<input type="text" id="give_people" name="give_people" value="" class="input_width" />
										 
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>是否为外协人员：</td>
									<td class="inquire_form4"> 	否 <input type="radio" name="radioType" value="1" id="radioType1" onclick="radioValue()"/>  是<input type="radio" name="radioType" value="2" id="radioType2" onclick="radioValue()"/>  </td>
					 
								</tr>
								 <tr id="tr4">
									<td class="inquire_item4">处理人员：</td>
									<td class="inquire_form4"> 
								 		<input name="todeal_people" id="todeal_people" class="input_width" value="" type="text" readonly="readonly"/>
								 			 
									</td>
									<td></td>
									<td></td>
					 
								</tr>
								<tr id="tr5">
									<td class="inquire_item4">处理计划开始时间：</td>
									<td class="inquire_form4">
									 	<input type="text" id="t_start_time" name="t_start_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(t_start_time,tributton1);" />
									</td>
									<td class="inquire_item4">处理计划完成时间：</td>
									<td class="inquire_form4"> 
											 <input type="text" id="t_end_time" name="t_end_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(t_end_time,tributton2);" /></td>
								</tr>
								  <tr id="tr6">
									<td class="inquire_item4">解释人员：</td>
									<td class="inquire_form4"> 
								 		<input name="explain_people" id="explain_people" class="input_width" value="" type="text" readonly="readonly"/>
								 			 
									</td>
									<td></td>
									<td> </td>
					 
								</tr>
									<tr id="tr7">
									<td class="inquire_item4">解释计划开始时间：</td>
									<td class="inquire_form4">
									 	<input type="text" id="e_start_time" name="e_start_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(e_start_time,tributton3);" />
								
										 
									</td>
									<td class="inquire_item4">解释计划完成时间：</td>
									<td class="inquire_form4"> 
									<input type="text" id="e_end_time" name="e_end_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(e_end_time,tributton4);" />
								
									</td>
					 
								</tr>
					 
									<tr id="tr8">
									<td class="inquire_item4">外协单位：</td>
									<td  colspan="3">
									  <input type="text" id="outsourcing_personnel" name="outsourcing_personnel" value=""  style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;" />
										 
									</td>
					 
					 
								</tr>
								 <tr  >
									<td class="inquire_item4"> </td>
									<td  colspan="3">
									   	 
									</td> 
					 
								</tr>
								 
							</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>		
				</div>
				 
		 	</div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
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
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var fileAbbr = '<%=fileAbbr%>';
	
	function refreshData(){
  
		cruConfig.queryStr = "  select t.* from ( select  t.commitments_id,  to_char( t.give_time,'yyyy') year_s,t.project_info_no,  p.project_name,  t.tecnical_id,decode(t.status_type,   '1',   '未下达',  '2',  '已下达', t.status_type) proc_status_name,  t.give_people,t.outsourcing,t.todeal_people,t.todeal_people_s,t.t_start_time,t.t_end_time,t.explain_people,t.explain_people_s,t.e_start_time,t.e_end_time,t.give_time,nvl(t.status_type,0)status_type ,  f.ucm_id as ucm_id,  f.file_name as file_name,  f2.ucm_id as ucm_id_a,  f2.file_name as file_name_a  from GP_WS_VSP_COMMITMENTS t  left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '0110000061100000124'  and bsflag = '0'  group by relation_id,  doc_file_type)) f  on t.tecnical_id = f.relation_id   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '0110000061200000006'  and bsflag = '0'  group by relation_id,  doc_file_type)) f2  on t.commitments_id = f2.relation_id    left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no   where t.bsflag = '0'  and t.doc_type = '0110000061200000006'  order by t.modifi_date desc  , t.status_type asc ) t   ";
		cruConfig.currentPageUrl = "/td/vspExplain/vspCommitments/commitmentsList.jsp";
		queryData(1);
	}

	
	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/td/vspExplain/vdzCommitments/searchJzProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[0];
		        document.getElementById("s_project_name").value = checkStr[1];
	    }
	}
	
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSubmit(){
		ids = getSelectedValue(); 
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split("-")[1] == '2' ){
			alert("该单据已下达不可提交!");
			return;
		}
		
		if (!window.confirm("确认要提交吗?")) {
			return;
		}		
	 
		    var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
			var submitStr = 'JCDP_TABLE_NAME=GP_WS_VSP_COMMITMENTS&JCDP_TABLE_ID='+ids.split("-")[0]+'&status_type=2&give_time=<%=appDate%>'; 
		   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
 
		refreshData();
	}
	function toDelete(){ 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split("-")[1] == '2' ){
			alert("该单据已下达不可删除!");
			return;
		}
		
		if (!window.confirm("确认要删除吗?")) {
			return;
		}	
		
		var sql = "update GP_WS_VSP_COMMITMENTS t set t.bsflag='1' where t.commitments_id ='"+ids.split("-")[0]+"' "; 
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids.split("-")[0];
		var retObject = syncRequest('Post',path,params);
		 
		refreshData();
	}
    function loadDataDetail(ids){
 
	   var  fileId=ids.split("-")[0];
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
   	  	document.getElementById("down_0110000061100000124").innerHTML="";
   	  	document.getElementById("down_0110000061200000006").innerHTML="";
   	        document.getElementById("todeal_people").value ="";
			document.getElementById("t_start_time").value = "";
			document.getElementById("t_end_time").value = "";
			document.getElementById("explain_people").value ="";     					 
			document.getElementById("e_start_time").value ="";
			document.getElementById("e_end_time").value = "";
		    document.getElementById("outsourcing_personnel").value ="";
		    
   		if(fileId !='null'){
   			var querySql = " select t.* from ( select  t.commitments_id, t.outsourcing_personnel,t.doc_type, to_char( t.give_time,'yyyy') year_s,t.project_info_no,  p.project_name,  t.tecnical_id,decode(t.status_type,   '1',   '未下达',  '2',  '已下达', t.status_type) proc_status_name,  t.give_people,t.outsourcing,t.todeal_people,t.todeal_people_s,t.t_start_time,t.t_end_time,t.explain_people,t.explain_people_s,t.e_start_time,t.e_end_time,t.give_time,t.status_type , f.file_id,  f.ucm_id ,  f.file_name,f2.file_id file_id_a, f2.file_abbr file_abbr_a, f2.ucm_id as ucm_id_a,  f2.file_name as file_name_a  from GP_WS_VSP_COMMITMENTS t  left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '0110000061100000124'  and bsflag = '0'  group by relation_id,  doc_file_type)) f  on t.tecnical_id = f.relation_id   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '0110000061200000006'  and bsflag = '0'  group by relation_id,  doc_file_type)) f2  on t.commitments_id = f2.relation_id     left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no  where t.bsflag = '0'  and t.doc_type = '0110000061200000006'   and t.commitments_id='"+fileId+"'   ) t ";
   			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
   			var datas = queryRet.datas;
   			if(datas!=null && datas.length>0){
   				document.getElementById("commitments_id").value = datas[0].commitments_id;
   				document.getElementById("doc_type").value = datas[0].doc_type;
   				document.getElementById("business_type").value = "<%=doc_type%>";
   	 
   				if(datas[0].ucm_id_a ==""){
   					document.getElementById("ucm_id_a").value ="自动生成";
   				}else{
   					document.getElementById("ucm_id_a").value = datas[0].ucm_id_a;
   				}
   				document.getElementById("project_name").value = datas[0].project_name;
   				document.getElementById("project_info_no").value = datas[0].project_info_no;
   				document.getElementById("file_abbr").value = "<%=fileAbbr%>";
 
   				document.getElementById("status_type").value = "1";
   	 
   				var str=datas[0].file_name==""?"":datas[0].file_name.substr(0,30)+'...';
   				$("#down_0110000061100000124").append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id+"&emflag=0>"+str+"</a>");
   	 
   				if(datas[0].ucm_id_a!=""){ 
   					var str_a=datas[0].file_name_a==""?"":datas[0].file_name_a.substr(0,30)+'...';
   					$("#down_0110000061200000006").append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id_a+"&emflag=0>"+str_a+"</a>");
   		  		 }
   				if(datas[0].give_people ==""){
   					document.getElementById("give_people").value ="";
   				}else{
   					document.getElementById("give_people").value = datas[0].give_people;
   				}
   				
   				
   				if (datas[0].outsourcing!=""){
   					if(datas[0].outsourcing=="1"){ //否
   						document.getElementById("radioType1").checked=true ;
   				 		document.getElementById("tr4").style.display = "";
   				 		document.getElementById("tr5").style.display = "";
   				 		document.getElementById("tr6").style.display = "";
   				 		document.getElementById("tr7").style.display = "";
   				 		document.getElementById("tr8").style.display = "none";
   		 
	   					document.getElementById("todeal_people").value = datas[0].todeal_people;
   	   					document.getElementById("t_start_time").value = datas[0].t_start_time;
   	   					document.getElementById("t_end_time").value = datas[0].t_end_time;
   	   					document.getElementById("explain_people").value =datas[0].explain_people;      					 
   	   					document.getElementById("e_start_time").value = datas[0].e_start_time;
   	   					document.getElementById("e_end_time").value = datas[0].e_end_time;
   					}else{
   						document.getElementById("radioType2").checked=true ;
   						document.getElementById("tr4").style.display = "none";
   				 		document.getElementById("tr5").style.display = "none";
   				 		document.getElementById("tr6").style.display = "none";
   				 		document.getElementById("tr7").style.display = "none";
   				 		document.getElementById("tr8").style.display = "";
   						
   	                   document.getElementById("outsourcing_personnel").value = datas[0].outsourcing_personnel;
   					}
   					
   				} else{
   					document.getElementById("radioType1").checked=true ;
   					    document.getElementById("tr4").style.display = "";
				 		document.getElementById("tr5").style.display = "";
				 		document.getElementById("tr6").style.display = "";
				 		document.getElementById("tr7").style.display = "";
				 		document.getElementById("tr8").style.display = "none";
   				}
   	    
   			}
   			 
   		} 	
		

    }

 
    function toAdd(typeOption){
    	
    	if(typeOption == '1'){
    		popWindow('<%=contextPath%>/td/vspExplain/vdzCommitments/add_vdzCommitments.jsp?docType=0110000061200000006&fileAbbr='+fileAbbr+'&parent_file_id=&id=&p_type=1','800:700');
    	}else if(typeOption == '0') {
    		ids = getSelectedValue();
    		if (ids == '') {
    			alert("请选择一条记录!");
    			return;
    		}
     
/*     			if(ids.split("-")[1] == '2' ){
    				alert("该单据已下达不可修改!");
    				return;
    			} */
    		
        	popWindow('<%=contextPath%>/td/vspExplain/vdzCommitments/add_vdzCommitments.jsp?docType=0110000061200000006&fileAbbr='+fileAbbr+'&parent_file_id=&id='+ids.split("-")[0]+'&p_type=0','800:700');

    	}
    }
	 
	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	 
 
	// 简单查询
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;
		var s_proc_status = document.getElementById("s_proc_status").value;
		var s_proc_year = document.getElementById("s_proc_year").value;
		
		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += " and project_name like '%"+s_project_info_no+"%' ";						
		}	
		if(s_proc_status!=''){			
			str += " and status_type like '"+s_proc_status+"%' ";						
		}
		if(s_proc_year!=''){			
			str += " and year_s = '"+s_proc_year+"' ";						
		}
		
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	
	
	function clearQueryText(){ 
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		document.getElementById("s_proc_status").value="";
		document.getElementById("s_proc_year").value="";
		
		cruConfig.cdtStr = "";
	}
	
	 function chooseOne(cb){   
	        //先取得同name的chekcBox的集合物件   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
	            //else  obj[i].checked = cb.checked;   
	            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
	            else obj[i].checked = true;   
	        }   
	    }   
</script>
</html>