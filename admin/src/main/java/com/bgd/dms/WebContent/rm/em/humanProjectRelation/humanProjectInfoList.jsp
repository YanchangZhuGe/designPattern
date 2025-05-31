<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgS_id=user.getSubOrgIDofAffordOrg();
	String folderId = "";
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>人员项目经理维护</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="file_name" class="input_width" name="file_name" type="text" /></td>
			    <td class="ali_cdn_name">员工编号</td>
			    <td class="ali_cdn_input"><input id="spare21" class="input_width" name="spare21" type="text" /></td>
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>
			    <td></td>
			    <td> 			    
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="F_HUMAN_0012" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    </td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{relation_no},{locked_if}' id='rdo_entity_id_{relation_no}' onclick='chooseOne(this)'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_cd}">员工编号</td>			   
			      <td class="bt_info_even" exp="{employee_name}">姓名</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{team_name}">班组</td>
			      <td class="bt_info_odd" exp="{work_post_name}">岗位</td>
			      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_odd" exp="{actual_end_date}">实际离开项目时间</td>
			      <td class="bt_info_even" exp="{sub_date}">参与项目天数</td>
			      <td class="bt_info_odd" exp="{project_evaluate_name}">人员评价</td>
			    </tr>
			  </table>
			  </div>
			<div id="fenye_box"   style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">岗位明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div id="inq_tool_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr align="right">
						<td width="95%">&nbsp;</td>
					    
					  </tr>
					</table>
					</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					  </tr>
					</table>
					</div>
					
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	<td>序号</td>
			    	    <td>班组</td>
			    	    <td>岗位</td>
			            <td>进入时间</td>
			            <td>离开时间</td>		
			            <td>人员评价</td>	
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
var orgS_id='<%=orgS_id%>';
//cruConfig.queryStr = "";
//cruConfig.queryService = "ucmSrv";
//cruConfig.queryOp = "getDocsInFolder";
//cruConfig.queryRetTable_id = "";
function simpleRefreshData(){
	if (window.event.keyCode == 13) {	
		var file_name = document.getElementById("file_name").value; 
		var  spare21=document.getElementById("spare21").value; 
		if(file_name!=''&& file_name!=null){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0' where hr.bsflag='0' and he.employee_name like'%"+file_name+"%' order by hr.modifi_date desc ";
		cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
		queryData(1);
		}else if(spare21!='' && spare21!=null) {
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0' where hr.bsflag='0' and he1.employee_cd like'%"+spare21+"%' order by hr.modifi_date desc ";
			cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
			queryData(1);
			
		}else{
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0' where hr.bsflag='0' order by hr.modifi_date desc ";
		 
			cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
			queryData(1);
		}
	}
	
}


function getTab3(index) {  
  var selectedTag0 = document.getElementById("tag3_0");
  var selectedTabBox0 = document.getElementById("tab_box_content0");
  var selectedTag1 = document.getElementById("tag3_1");
  var selectedTabBox1 = document.getElementById("tab_box_content1");
  var selectedTag2 = document.getElementById("tag3_2");
  var selectedTabBox2 = document.getElementById("tab_box_content2");
  var selectedTag3 = document.getElementById("tag3_3");
  var selectedTabBox3 = document.getElementById("tab_box_content3");
  
  if (index == '1'){
    selectedTag1.className ="selectTag";
    selectedTabBox1.style.display="block";
    selectedTag0.className ="";
    selectedTabBox0.style.display="none";
    selectedTag2.className ="";
    selectedTabBox2.style.display="none";
    selectedTag3.className ="";
    selectedTabBox3.style.display="none";
    
  }
   if (index == '0'){
    selectedTag0.className ="selectTag";
    selectedTabBox0.style.display="block";
    selectedTag1.className ="";
    selectedTabBox1.style.display="none";
    selectedTag2.className ="";
    selectedTabBox2.style.display="none";
    selectedTag3.className ="";
    selectedTabBox3.style.display="none";
    
  }
   if (index == '2'){
    selectedTag2.className ="selectTag";
    selectedTabBox2.style.display="block";
    selectedTag1.className ="";
    selectedTabBox1.style.display="none";
    selectedTag0.className ="";
    selectedTabBox0.style.display="none";
    selectedTag3.className ="";
    selectedTabBox3.style.display="none";
    
  }
   if (index == '3'){
	    selectedTag3.className ="selectTag";
	    selectedTabBox3.style.display="block";
	    selectedTag1.className ="";
	    selectedTabBox1.style.display="none";
	    selectedTag0.className ="";
	    selectedTabBox0.style.display="none";
	    selectedTag2.className ="";
	    selectedTabBox2.style.display="none";
	    
	  }
   
}

function loadDataDetail(ids){
	  var tempa = ids.split(',');
	    var ids = tempa[0];
	    
	  document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;	    
	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+ids;	
	    
	var querySql = "select  rownum,  sd.coding_name team_name,    sd2.coding_name work_post_name,       hr.actual_start_date,        hr.actual_end_date,   d3.coding_name project_evaluate_name  from bgp_project_human_relation hr  left join comm_human_employee he    on hr.employee_id = he.employee_id   and he.bsflag = '0'  left join comm_human_employee_hr he1    on hr.employee_id = he1.employee_id  left join comm_coding_sort_detail sd    on hr.team = sd.coding_code_id   and sd.bsflag = '0'  left join comm_coding_sort_detail d3    on hr.project_evaluate = d3.coding_code_id  left join comm_coding_sort_detail sd2    on hr.work_post = sd2.coding_code_id   and sd2.bsflag = '0'  left join gp_task_project p    on hr.project_info_no = p.project_info_no   and p.bsflag = '0' where hr.bsflag = '0'   and hr.spare1 is null   and hr.relation_no='"+ids+"' ";
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
			td.innerHTML = datas[i].team_name;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].work_post_name;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].actual_start_date;

			var td = tr.insertCell(4);
			td.innerHTML = datas[i].actual_end_date;

			var td = tr.insertCell(5);
			td.innerHTML = datas[i].project_evaluate_name;
		}
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


function simpleSearch(){ 
	var file_name = document.getElementById("file_name").value; 
	var  spare21=document.getElementById("spare21").value; 
	if(file_name =='' && spare21 ==''){ 
		refreshData();
	}else{
		
    if(spare21 !='' && file_name !=''){
    	cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'  left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'  where hr.bsflag='0' and hr.spare1 is null  and s.org_subjection_id like '"+orgS_id+"%'  and he1.employee_cd like'%"+spare21+"%' and he.employee_name like'%"+file_name+"%' order by hr.modifi_date desc ";
		cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
		queryData(1);
			return ;
    	
    }else if(file_name!=''&& file_name!=null){ 
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'  left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'  where hr.bsflag='0' and hr.spare1 is null  and s.org_subjection_id like '"+orgS_id+"%'  and he.employee_name like'%"+file_name+"%' order by hr.modifi_date desc ";
		cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
		queryData(1);
			return ;
	 }else  if(spare21!=''&& spare21!=null){ 
	    	 cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'  left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'  where hr.bsflag='0' and hr.spare1 is null   and s.org_subjection_id like '"+orgS_id+"%'  and he1.employee_cd like'%"+spare21+"%' order by hr.modifi_date desc ";
			cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
			queryData(1);
			return ;
	 } 
	
	}
 
}
function clearQueryText(){
		  document.getElementById("file_name").value=''; 
	      document.getElementById("spare21").value='';
}
function viewLink(relation_no){
	popWindow("<%=contextPath%>/rm/em/humanProjectRelation/laborModify.upmd?id="+relation_no+"&pagerAction=edit2View");
}
function refreshData(){
	//if(id!=undefined){
	//	orgSubId = id;
	//}
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' )employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he.employee_name, he1.spare2, he1.employee_cd, hr.plan_start_date,he.org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, hr.project_evaluate,d3.coding_name project_evaluate_name  from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0'   left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0'  left join comm_coding_sort_detail  d3 on hr.project_evaluate = d3.coding_code_id left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0' left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'  left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'  where hr.bsflag='0' and hr.spare1 is null  and s.org_subjection_id like '"+orgS_id+"%'  order by hr.modifi_date desc ";
 
	cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectInfoList.jsp";
	queryData(1);
}
 
	function toAdd(){

		popWindow('<%=contextPath%>/rm/em/tohumanProjectRelatSave.srq','800:800');
 
		refreshData();
		//popWindow('<%=contextPath%>/doc/singleproject/close_page.jsp');
	}
 
	function toAddPeople(){

		popWindow('<%=contextPath%>/rm/em/toProjectHumanRelatSave.srq','800:800');
		refreshData();
	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var tempa = ids.split(',');
	    var id = tempa[0];
	    var locked = tempa[1];
	    if(locked == 1){
	    	alert("该记录已审核通过，不能删除!");   
	    	return; 
	    }
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HumanLaborMessageSrv", "deleteUpdateProjectInfo", "projectId="+id);
			queryData(cruConfig.currentPage);
		}
		 
 
	}

	function toSearch(){
		popWindow('<%=contextPath%>/rm/em/humanProjectRelation/project_search.jsp');
	}
	function  toEdit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	     alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	    var id = tempa[0];
	    var locked = tempa[1];
	    if(locked == 1){
	    	alert("该记录已审核通过，不能修改!");   
	    	return; 
	    }
	    popWindow('<%=contextPath%>/rm/em/tohumanProjectRelatEdit.srq?id='+id,'800:800');
		queryData(cruConfig.currentPage);
		
		
	}
	function toDownload(){
		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var tempa = ids.split(',');
	    var ids = tempa[0];
	    window.location = "<%=contextPath%>/doc/downloadDoc.srq?docId="+ids;
	    
	}
	
	 
	function viewProcInfo(){
		var editUrl="/BPM/viewProcinst.jsp?procinstId="+procinstId;
		window.showModalDialog("<%=contextPath%>"+editUrl," ","dialogWidth:1024px;   dialogHeight:768px");
	}
	
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
</script>

</html>

