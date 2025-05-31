<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String laborCategory = request.getParameter("laborCategory");
	String projectInfoNo = user.getProjectInfoNo();
	  String projectType = user.getProjectType();
	String empId = user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String message = "";
    
	if(respMsg != null){
		laborCategory = respMsg.getValue("laborCategory");
		message = respMsg.getValue("message");
	}
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" />  
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" />  
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td  width="4%" >姓名：</td>
			    <td width="5%"  ><input  style="width:100px;" id="s_employee_name" name="s_employee_name" type="text"  /></td>
			    <td width="3%" >&nbsp;&nbsp;班组</td>
			    <td width="5%"  ><select   style="width:100px;"  id="s_apply_team" name="s_apply_team" onchange="getPost()"></select></td>
			    <td width="3%" >&nbsp;&nbsp;岗位</td>
			    <td width="5%" ><select   style="width:100px;"  id="s_post" name="s_post" ></select></td>
	
			    
			     <% 
			        if("5000100004000000008".equals(projectType)){
						  %>
				 <td width="5%" >&nbsp;接收状态</td>
			    <td width="5%"  >
			 	 <select  style="width:100px;" id="s_fen" name="s_fen" >
				       <option value="" >请选择</option>
				       <option value="1" >已接收 </option>
				       <option value="0" selected="selected" >未接收</option>			
				       <option value="3" >未报道 </option>			    
				    </select> 
			    <%
					}else{
				 %>	
				  <td width="5%" >&nbsp;分配任务</td>
			    <td width="5%"  >
				  <select  style="width:100px;" id="s_fen" name="s_fen" >
				       <option value="" >请选择</option>
				       <option value="1" >已分配 </option>
				       <option value="0" selected="selected" >未分配</option>						    
				    </select> 
				 
				  <%
					}
				  %>
				  
				   
				    <input type='hidden' id="szButton" name="szButton" value=""/>
			    </td>
			    
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				   <% 
			        if(!"5000100004000000009".equals(projectType)){
						  %>
			    <td>&nbsp;可接收剩余人数为:&nbsp;<label id="labelNum" name="labelNum" style="color:red;">0</label></td>
			    <%
					}else{
				 %>	
				 <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>	
				 
				  <%
					}
				  %>
			    <auth:ListButton functionId="" id="sz"  css="sz" event="onclick='toShuman()'" title="选择父项目人员"></auth:ListButton>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>	
				<auth:ListButton functionId="" css="rlfprw" event="onclick='add_selectTree()'" title="人员接收"></auth:ListButton>	
				<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="JCDP_btn_import"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{labor_deploy_id}-{deploy_detail_id}-{labor_id}-{receive_no}-{sz_type}' id='rdo_entity_id_{humanDetailNo}'/>" >
			       <input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>			      
			      <td class="bt_info_odd" exp="{employee_name}">员工姓名</td>
			      <td class="bt_info_even" exp="{employee_id_code_no}">身份证号</td>
			      <td class="bt_info_even" exp="{cont_num}">劳动合同编号</td>
			      <td class="bt_info_odd" exp="{apply_team_name}">班组</td>
			      <td class="bt_info_even" exp="{post_name}">岗位</td>
			      <td class="bt_info_odd" exp="{start_date}">预计进入项目时间</td>
			      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_even" exp="{end_date}">实际离开项目时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">作业</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				    	    <td>作业名称</td>
				            <td>计划开始时间</td>
				            <td>计划结束时间</td>		
				            <td>原定工期</td>	
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
	var message =  "<%=message%>";
	var projectTyp='<%=user.getProjectType()%>';
	
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("s_employee_name").value;
			refreshData(undefined, q_file_name);
		}
	}
 
	if(message != "" && message != 'null'){
		refreshData();
		alert(message);
		
	}
	
	function toShuman(){
		var project_father_no=document.getElementById("szButton").value; 
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/szLaborAcceptList.jsp?fatherNo='+project_father_no+'&params=<%=laborCategory%>','830:600');
		
	}
	
 
	function toAdd(){
	      if(projectTyp!="5000100004000000009"){
			var numSum=document.getElementById("labelNum").innerText;
			if(numSum=='0'){
				alert('可接收剩余人数为0,不可添加!');return;
			}
			
			
		}
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/add_laborAcceptModify.jsp?projectInfoNo=<%=projectInfoNo%>&laborCategory=<%=laborCategory%>','1000:800');
	}
	
	function toSubmit() {	
		
		ids = getSelectedValue();
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		}
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanAccept/add_humanAcceptModify.jsp?id='+ids.split("-")[0]+'&projectInfoNo=<%=projectInfoNo%>','1000:800');

	}
	
	function toDownload(){
		var elemIF = document.createElement("iframe");  
		
		var iName ="临时工人员接收";  
		iName = encodeURI(iName);
		iName = encodeURI(iName);
		
		if(projectTyp!="" && projectTyp !="null"){
			if(projectTyp =="5000100004000000006"){  //深海模板
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/laborAccept/importLaborListSh.xls&filename="+iName+".xls";
			}else if (projectTyp =="5000100004000000009"){  // 综合模板
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/laborAccept/importLaborListZh.xls&filename="+iName+".xls";
			}else { //其他类型
				elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/laborAccept/importLaborListLd.xls&filename="+iName+".xls";
			}
		}
		
		 	elemIF.style.display = "none";  
		   document.body.appendChild(elemIF);  
	}
	
	function refreshData(){
		
		var querySqlNum = "      select  nvl(sum(p.people_number),0) people_number, nvl(sum(p.audit_number),0) audit_number         from bgp_project_human_post p    inner join bgp_project_human_requirement r   on p.requirement_no = r.requirement_no    left join common_busi_wf_middle te           on te.business_id = r.requirement_no and te.bsflag = '0'  where p.bsflag = '0'  and te.proc_status='3'   and r.project_info_no =  '<%=projectInfoNo%>' ";
		var queryRetNum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlNum);		
		var datas = queryRetNum.datas;
		
		var querySqlAdd = "     select distinct count(t.labor_deploy_id) labor_num    from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2    on t.labor_deploy_id = d2.labor_deploy_id   and d2.bsflag = '0'  left join bgp_comm_human_labor l    on t.labor_id = l.labor_id    where t.bsflag = '0'  and t.between_param  is null   and t.project_info_no = '<%=projectInfoNo%>'   and t.end_date is   null   ";
		var queryRetAdd = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlAdd);		
		var datasAdd = queryRetAdd.datas;
		
		var sumNum=datas[0].audit_number;
		var numJieshou=datasAdd[0].labor_num;
	      if(projectTyp!="5000100004000000009"){
		document.getElementById("labelNum").innerText=sumNum-numJieshou; 
	      }
		
		//查询是否 子项目
	    var sqlButton = " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='<%=projectInfoNo%>' and  t.bsflag='0' and t.project_father_no is not  null "; 
		var queryRetNum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+sqlButton);		
		var datas = queryRetNum.datas; 
		if(datas != null && datas != ''){
			for (var i = 0; i< datas.length; i++) {
				 document.getElementById("szButton").value=datas[i].project_father_no; 
				 document.getElementById("sz").style.display="block";
				 
			}
		
		}else{
			 document.getElementById("sz").style.display="none";
		}
	 
		
		
		cruConfig.queryService = "HumanLaborMessageSrv";
		cruConfig.queryOp = "queryLaborAcceptReturnList";
		var str="projectInfoNo=<%=projectInfoNo%>";		
	    	str+=" &laborCategory=<%=laborCategory%> &sfen=0";
		cruConfig.submitStr =str;		
		queryData(1);
	}
	
	function simpleSearch(){
		
		var s_employee_name = document.getElementById("s_employee_name").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;		
		var s_fen = document.getElementById("s_fen").value;   
		
		var str = "projectInfoNo=<%=projectInfoNo%>";
	     	str+="&laborCategory=<%=laborCategory%>";
		if(s_employee_name != ''){
			str+="&employee_name="+s_employee_name;
		}
		if(s_apply_team != ''){
			str+="&apply_team="+s_apply_team;
		}
		if(s_post != ''){
			str+="&post="+s_post;
		}
		if(s_fen != ''){
			str+="&sfen="+s_fen;
		}
		
		cruConfig.submitStr = str;			
		queryData(1);
		
	}

	function clearQueryText(){ 
		 document.getElementById("s_employee_name").value=""; 
		 document.getElementById("s_apply_team").value="";
		 document.getElementById("s_fen").value="";
	     var selectObj = document.getElementById("s_post");
	     document.getElementById("s_post").innerHTML="";
	     selectObj.add(new Option('请选择',""),0);
	     cruConfig.cdtStr = "";
	}
	
	function toSearch(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/doc_search.jsp');
	}
	
	function getApplyTeam(){
		var selectObj = document.getElementById("s_apply_team"); 
		document.getElementById("s_apply_team").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
	
		var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	
		for(var i=0;i<applyTeamList.detailInfo.length;i++){
			var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("s_post");
		document.getElementById("s_post").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	function getPost(){
	    var applyTeam = "applyTeam="+document.getElementById("s_apply_team").value;   
		var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	
	
		var selectObj = document.getElementById("s_post");
		document.getElementById("s_post").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(applyPost.detailInfo!=null){
			for(var i=0;i<applyPost.detailInfo.length;i++){
				var templateMap = applyPost.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}

	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

    function loadDataDetail(ids){
    	
    	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];
  	    
  	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
  	    
  	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+ids.split("-")[0];
  	
		var querySql = "select rownum,p.* from (select a.name,a.planned_duration,a.planned_start_date,a.planned_finish_date,to_char(a.start_date,'yyyy-MM-dd')start_date,  to_char(a.finish_date,'yyyy-MM-dd') end_date  from bgp_comm_human_receive_labor t  left join bgp_p6_activity a on t.task_id=a.object_id and a.bsflag='0'  where t.bsflag='0' and t.deploy_detail_id='"+ids.split("-")[1]+"' and t.labor_id='"+ids.split("-")[2]+"' ) p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);		
		var datas = queryRet.datas;
		
		deleteTableTr("planDetailList");
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
			
				var tr = document.getElementById("planDetailList").insertRow();		
				
	          	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
	
	          					
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].start_date;
	
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].end_date;

				var array1 = datas[i].start_date.split("-"); 
				var array2 = datas[i].end_date.split("-"); 	
				var dt1 = new Date(); 
				dt1.setFullYear(array1[0]); 
				dt1.setMonth(array1[1] - 1); 
				dt1.setDate(array1[2]); 
				var dt2 = new Date(); 
				dt2.setFullYear(array2[0]); 
				dt2.setMonth(array2[1] - 1); 
				dt2.setDate(array2[2]); 	
				var distance = dt2.getTime() - dt1.getTime(); //毫秒数	
				var days = distance / (24 * 60 * 60 * 1000);//算出天数 
				
				var td = tr.insertCell(4);
				td.innerHTML = parseInt(days)+1;
			}
		}
  		
    }
    
	function toDelete(){
		
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		var s_fen = document.getElementById("s_fen").value;  
		if(s_fen =='1'){
			alert('已接收或分配任务人员不可删除!');return;
		}
		if(s_fen =='3'){
			alert('未报道人员不可再次删除!');return;
		}
		var tempIds = ids.split(",");		
		var deployNos = "";
		var detailNos = "";
		var laobrIds="";
		var deployNosType = "";
		
		var receive_no=tempIds[0].split("-")[3] ;
		if(receive_no !='' && receive_no !='null'){
			alert("该人员已分配任务,不能删除");
			return;
		}
		
		if (!window.confirm("确认删除吗?")) {
			return;
		}
				 
			
		for(var i=0;i<tempIds.length;i++){		
			
			var szType=tempIds[i].split("-")[4];
			if(szType == '0'){ // 自己调配人员 
				deployNos = deployNos + "," + "'" + tempIds[i].split("-")[0] + "'";	
				detailNos = detailNos + "," + "'" + tempIds[i].split("-")[1] + "'";	
				laobrIds = laobrIds + "," + "'" + tempIds[i].split("-")[2] + "'";	
			}else  if(szType == '1'){  //父项目人员  
				deployNosType = deployNosType + "," + "'" + tempIds[i].split("-")[0] + "'";	
				
			}

		}
		
		var sql1 = "update bgp_comm_human_labor_deploy t set t.bsflag='1',t.modifi_date=sysdate where t.labor_deploy_id in ("+deployNos.substr(1)+") ";
		var sql2 = "update bgp_comm_human_deploy_detail t set t.bsflag='1',t.modifi_date=sysdate where t.deploy_detail_id in ("+detailNos.substr(1)+") ";
		var sql3 = "update bgp_comm_human_labor t set t.if_project='0',t.modifi_date=sysdate where t.labor_id  in ("+laobrIds.substr(1)+") ";
		
		var sql4 = "update bgp_comm_human_labor_deploy t set t.project_father_no='',t.actual_start_date='',t.modifi_date=sysdate where t.labor_deploy_id in ("+deployNosType.substr(1)+") ";
		
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+deployNos);
		var retObject1 = syncRequest('Post',path,"deleteSql="+sql2+"&ids="+detailNos);
		var retObject2 = syncRequest('Post',path,"deleteSql="+sql3+"&ids="+laobrIds);
		var retObject3 = syncRequest('Post',path,"deleteSql="+sql4+"&ids="+deployNosType);
		
		refreshData();

	}
	
	function toDeleteSub(){
		
		var task_id = document.getElementsByName("task_id");
		var str_task_id = "";
		var flag = true;
		if(task_id != null){
			for(var i=0;i<task_id.length;i++){
				if(task_id[i].checked == true){
					flag = false;
					str_task_id = str_task_id + "," + "'" + task_id[i].value + "'";	
				}			
			}
		}
		if(flag){
			alert("请选择一条记录");
		}else{
			if (!window.confirm("确认删除吗?")) {
				return;
			}
			
			var sql1 = "update bgp_comm_human_receive_labor t set t.bsflag='1',t.modifi_date=sysdate where t.receive_no in ("+str_task_id.substr(1)+") ";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+str_task_id);

		}
		
		loadDataDetail();

	}
	
	function importData(){
	      if(projectTyp!="5000100004000000009"){
				var numSum=document.getElementById("labelNum").innerText;
				if(numSum=='0'){
					alert('可接收剩余人数为0,不可导入添加!');return;
				}
	      }
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/humanPlanImportFile.jsp?laborCategory=<%=laborCategory%>&numSum='+numSum,'700:600');
		
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
	
	function selectTree(){

		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		  var teamInfo = {
			  TaskIds:"",
			  Names:"",
			  StartDates:"",
			  EndDates:"",
			  CheckOther1s:""
		  }; 
		  window.showModalDialog('<%=contextPath%>/p6/tree/selectTree.jsp?projectInfoNo=<%=projectInfoNo%>',teamInfo);
		  
		  if(teamInfo.CheckOther1s != ""){
			  			  
			  var taskIds = teamInfo.CheckOther1s.split(",");
			  ids = getSelIds('rdo_entity_id');
			  var rowParams = new Array();
			  
			  for(var i=0;i<taskIds.length;i++){				  
					var tempIds = ids.split(",");			
					for(var j=0;j<tempIds.length;j++){						
						var rowParam = {};
						
						rowParam['creator'] = '<%=empId%>';
						rowParam['updator'] = '<%=empId%>';
						rowParam['modifi_date'] = '<%=curDate%>';
						rowParam['modifi_date'] = '<%=curDate%>';
						rowParam['bsflag'] = '0';
						rowParam['task_id'] = taskIds[i];
						rowParam['project_info_no'] = '<%=projectInfoNo%>';
						rowParam['deploy_detail_id'] = tempIds[j].split("-")[1];
						rowParam['labor_id'] = tempIds[j].split("-")[2];
						rowParams[rowParams.length] = rowParam;
					}				  
			  }
				var rows=JSON.stringify(rowParams);
				saveFunc("bgp_comm_human_receive_labor",rows);	
			
		  }
		  loadDataDetail(ids);
	}
	
	function add_selectTree(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var s_fen = document.getElementById("s_fen").value;   
		if(s_fen !='0'){
			alert('请选择未接收或未分配任务的人员!');return;
		}
		
		var tempIds = ids.split(",");		 
		var receive_no=tempIds[0].split("-")[3] ;
		if(receive_no !='' && receive_no !='null'){
			alert("该人员已分配任务");
			return;
		}
		
		var deployNos = "";
		var detailNos = ""; 
		
		for(var i=0;i<tempIds.length;i++){			
			deployNos = deployNos + "," + "'" + tempIds[i].split("-")[0] + "'";	
			detailNos = detailNos + "," + "'" + tempIds[i].split("-")[1] + "'";	
		}
		 
		popWindow('<%=contextPath%>/rm/em/queryLaborAcceptNew.srq?laborCategory=<%=laborCategory%>&ids='+deployNos.substr(1)+'&projectInfoNo=<%=projectInfoNo%>&pageSize='+tempIds.length,'900:700');

		
	}
	
	
	function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("rdo_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
		  }		  
		}
	}
	
</script>
</html>