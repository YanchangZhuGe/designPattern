<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
  

<%@taglib prefix="auth" uri="auth"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getEmpId();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	
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
<title>人员项目经历审核</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>	  
 			    <td class="ali_cdn_name">项目名称</td>
			    <td  width="20%">		    
			    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
    			<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
    			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
    			 </td>
			    <td class="ali_cdn_name" align="left">审核状态：</td>
			    <td class="ali_cdn_input"  align="left">
			    <select id="lockedIf" name="lockedIf"   class="select_width" >
				<option  selected="selected">请选择</option>
				<option value="0" >待审核</option>
				<option value="1">审核通过</option>
				<option value="2">审核不通过</option>
			    </select>
		    	</td>		 
		 		<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <td  class="ali1"> 
			    <auth:ListButton functionId="" css="sptg" event="onclick='shenhe()'" title="审核通过"> </auth:ListButton> 			  
			    <auth:ListButton functionId="" css="spbtg" event="onclick='shenheNo()'" title="审核不通过"> </auth:ListButton>			    
			    <auth:ListButton functionId="F_HUMAN_0011" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    </td>

			  </tr>
			   
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" style="height:100%">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='chx_entity_id' value='{relation_no}-{locked_if}-{project_type}' id='chx_entity_id' onclick='doCheck(this)'/>" >
			      <input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)">
			      </td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{locked_if_name}">审核状态</td>
			      <td class="bt_info_odd" exp="{employee_cd}">员工编号</td>
			  	<%  if(orgSubjectionId!=null && orgSubjectionId.length()>9 && orgSubjectionId.substring(0, 10).equals("C105001005")){%>
				<td class="bt_info_even" 	 exp="{spare2}">职工编号</td>
			     <%} %>
			      <td class="bt_info_even" exp="{employee_name}">姓名</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{team_name}">班组</td>
			      <td class="bt_info_odd" exp="{work_post_name}">岗位</td>
			      <td class="bt_info_even" exp="{plan_start_date}">计划进入项目时间</td>
			      <td class="bt_info_odd" exp="{plan_end_date}">计划离开项目时间</td>
			      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_odd" exp="{actual_end_date}">实际离开项目时间</td>
			      <td class="bt_info_even" exp="{sub_date}">参与项目天数</td>
			      <td class="bt_info_odd" exp="{project_evaluate}">人员评价</td>
			    </tr>
			  </table>
			  
			</div>
			<div id="fenye_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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

//cruConfig.queryStr = "";
//cruConfig.queryService = "ucmSrv";
//cruConfig.queryOp = "getDocsInFolder";
//cruConfig.queryRetTable_id = "";
 
 var orgS_id='<%=orgS_id%>';
 
function refreshData(){
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name,p.project_type, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name,   nvl( hr.plan_start_date,dl.plan_start_date)plan_start_date ,nvl(hr.spare1,he.org_id) org_id,  nvl( hr.plan_end_date,dl.plan_end_date) plan_end_date , hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr   left join  bgp_human_prepare_human_detail dl   on dl.employee_id=hr.employee_id       and hr.team = dl.team      and hr.work_post = dl.work_post    and dl.bsflag = '0'  and dl.actual_start_date is not null and dl.actual_end_date is not null  and dl.plan_start_date is not null and dl.plan_end_date is not null       inner    join bgp_human_prepare pt            on dl.prepare_no = pt.prepare_no     and pt.prepare_status = '2'  and pt.bsflag='0'    and pt.project_info_no = hr.project_info_no   left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'    left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'   where hr.bsflag='0'  and  hr.locked_if='0'  and s.org_subjection_id like '"+orgS_id+"%'  order by hr.create_date desc";
	 //cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name,p.project_type, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name,    hr.plan_start_date  ,nvl(hr.spare1,he.org_id) org_id,   hr.plan_end_date  , hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr      left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'    left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'   where hr.bsflag='0'  and  hr.locked_if='0'  and s.org_subjection_id like '"+orgS_id+"%'  order by hr.create_date desc";
	 
	cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectRelation.jsp";
	queryData(1);
}


function loadDataDetail(ids){

	  document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0]; 
	  document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
	  
	var querySql = "select  rownum,  sd.coding_name team_name,    sd2.coding_name work_post_name,           nvl( hr.plan_start_date,dl.plan_start_date)plan_start_date ,        nvl( hr.plan_end_date,dl.plan_end_date) plan_end_date,   d3.coding_name project_evaluate_name  from bgp_project_human_relation hr  left join  bgp_human_prepare_human_detail dl   on dl.employee_id=hr.employee_id       and hr.team = dl.team      and hr.work_post = dl.work_post    and dl.bsflag = '0'  and dl.actual_start_date is not null and dl.actual_end_date is not null  and dl.plan_start_date is not null and dl.plan_end_date is not null       inner    join bgp_human_prepare pt            on dl.prepare_no = pt.prepare_no     and pt.prepare_status = '2'  and pt.bsflag='0'    and pt.project_info_no = hr.project_info_no  left join comm_human_employee he    on hr.employee_id = he.employee_id   and he.bsflag = '0'  left join comm_human_employee_hr he1    on hr.employee_id = he1.employee_id  left join comm_coding_sort_detail sd    on hr.team = sd.coding_code_id   and sd.bsflag = '0'  left join comm_coding_sort_detail d3    on hr.project_evaluate = d3.coding_code_id  left join comm_coding_sort_detail sd2    on hr.work_post = sd2.coding_code_id   and sd2.bsflag = '0'  left join gp_task_project p    on hr.project_info_no = p.project_info_no   and p.bsflag = '0' where hr.bsflag = '0'  and hr.relation_no='"+ids.split("-")[0]+"' ";
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
			td.innerHTML = datas[i].plan_start_date;

			var td = tr.insertCell(4);
			td.innerHTML = datas[i].plan_end_date;

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

function getTab3(index) {  
	  var selectedTag0 = document.getElementById("tag3_0");
	  var selectedTabBox0 = document.getElementById("tab_box_content0");
	  var selectedTag1 = document.getElementById("tag3_1");
	  var selectedTabBox1 = document.getElementById("tab_box_content1");
	  var selectedTag2 = document.getElementById("tag3_2");
	  var selectedTabBox2 = document.getElementById("tab_box_content2");
	  
	  if (index == '1'){
	    selectedTag1.className ="selectTag";
	    selectedTabBox1.style.display="block";
	    selectedTag0.className ="";
	    selectedTabBox0.style.display="none";
	    selectedTag2.className ="";
	    selectedTabBox2.style.display="none";
 
	    
	  }
	   if (index == '0'){
	    selectedTag0.className ="selectTag";
	    selectedTabBox0.style.display="block";
	    selectedTag1.className ="";
	    selectedTabBox1.style.display="none";
	    selectedTag2.className ="";
	    selectedTabBox2.style.display="none";
 
	    
	  }
	   if (index == '2'){
	    selectedTag2.className ="selectTag";
	    selectedTabBox2.style.display="block";
	    selectedTag1.className ="";
	    selectedTabBox1.style.display="none";
	    selectedTag0.className ="";
	    selectedTabBox0.style.display="none";
 
	    
	  }
	  
	   
	}


	 function head_chx_box_changed(headChx){
			var chxBoxes = document.getElementsByName("chx_entity_id");
			if(chxBoxes==undefined) return;
			for(var i=0;i<chxBoxes.length;i++){
			  if(!chxBoxes[i].disabled){
					chxBoxes[i].checked = headChx.checked;	
					doCheck(chxBoxes[i]);
			  }
			  
			}
	}
	//保存的checkbox拼接的值
	var checked="";

	function doCheck(id){

		//序号
		var num = -1;
		//新的check值
		var newcheck = "";
		//拼接的值不为空

		if(checked != ""){
			var checkStr = checked.split(",");
			for(var i=0;i<checkStr.length-1; i++){
				//如果check中存在  选择的id值
				if(checkStr[i] == id.value){
					//记录位置
					num = i;		
					break;	
				}
			}
	        //判断num是否有值
			if(num != -1 ){
				if(id.checked==false){
					for(var j=0;j<checkStr.length-1; j++){
						if( j != num ){
							newcheck += checkStr[j] + ',';
						}
					}
					checked = newcheck;
				}
			}else{
				//直接拼
				if(id.checked==true){
					checked= checked + id.value + ',';	
				}		
			}
		}else{
			checked = id.value + ',';
			
		}
		
	}
	 
	function shenhe(){

	 	if(checked == ""){
			alert("请选择一条记录!");
			return;
		}
	 	
	    var tempa = checked.split(',');
	    var relation_nos = "";
	    var p_types="";
	    for(var i=0;i<tempa.length-1; i++){

	    	var tempas = tempa[i];
	    	var tempal = tempas.split("-");
		    var relation_no =  tempal[0];    
		    p_types =  tempal[2];   
		    
		    if( i == tempa.length-2){
				relation_nos = relation_nos +"'"+ relation_no+"'" ;
			}else{
				relation_nos = relation_nos + "'"+ relation_no+"',";
			}
		    
		}    
	    
	    
		var sql = "update bgp_project_human_relation set locked_if='1',modifi_date=sysdate where relation_no in ("+relation_nos+")";
		updateEntitiesBySql(sql,"提交");
//		
		//查询选中的信息在井中项目的人员
	    var sqlButton = "   select rt.employee_id,rt.relation_no,rt.project_evaluate,rt.spare1,pt.project_info_no ,rt.team,rt.work_post ,  rt.actual_start_date,   rt.actual_end_date     from  bgp_project_human_relation rt left join  gp_task_project  pt on rt.project_info_no=pt.project_info_no and pt.bsflag='0'  where rt.bsflag='0' and  rt.relation_no in ("+relation_nos+") and pt.project_type='5000100004000000008'   "; 
		var queryRetNum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=1000&querySql='+sqlButton);		
		var datas = queryRetNum.datas; 
		if(datas != null && datas != ''){
			for (var i = 0; i< datas.length; i++) {
				 var e_id=datas[i].employee_id;   //井中项目的人
			     var p_id=datas[i].project_info_no;  
			      
			   //查询父项目下的所有子项目 
				    var sqlButtonZ = " select p.project_father_no ,p.project_info_no AS project_info_no,    p.project_name AS project_name,  p.project_common AS project_common,   p.project_status AS project_status,  ccsd.coding_name AS manage_org_name,  DECODE(rpt.START_DATE, NULL, p.START_TIME) AS acquire_start_time,  DECODE(rpt.end_DATE, NULL, p.END_TIME) AS acquire_end_time,  oi.org_abbreviation AS team_name,  dy.is_main_team AS is_main_team  from gp_task_project p  join gp_task_project_dynamic dy  on dy.project_info_no = p.project_info_no  and dy.bsflag = '0'  and p.bsflag = '0'  and p.project_father_no = '"+p_id+"'  and p.project_type = '5000100004000000008'  and dy.is_main_team = '1'  left join comm_org_information oi  on dy.org_id = oi.org_id  left join comm_coding_sort_detail ccsd  on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'  LEFT JOIN (SELECT DISTINCT rpt.project_info_no,  rpt.start_date,  rpt.end_date  FROM bgp_ws_daily_report rpt  JOIN COMMON_BUSI_WF_MIDDLE wf  ON wf.BUSINESS_ID = rpt.PROJECT_INFO_NO  AND wf.bsflag = '0'  AND rpt.bsflag = '0'  AND wf.BUSI_TABLE_NAME = 'bgp_ws_daily_report'  AND wf.PROC_STATUS = '3') rpt  ON rpt.project_info_no = p.project_info_no "; 
					var queryRetNumZ = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+sqlButtonZ);		
					var datasZ = queryRetNumZ.datas; 
					if(datasZ != null && datasZ != ''){
						for (var j = 0; j< datasZ.length; j++) {
							  var zp_id=datasZ[j].project_info_no; //子项目id
						  //增加子项目项目经历信息
						// 	  var aDate = new Date(datas[i].actual_start_date.replace(/\-/g, "\/"));   
						//	  var sDate = new Date(datasZ[j].acquire_start_time.replace(/\-/g, "\/"));
						//	  var eDate = new Date(datasZ[j].acquire_end_time.replace(/\-/g, "\/")); 
						//	  if(aDate <= sDate && aDate  <= eDate ){alert(datasZ[j].project_name);}
							   
							 if(datasZ[j].acquire_start_time >= datas[i].actual_start_date && datasZ[j].acquire_start_time <= datas[i].actual_end_date ){
									var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq'; 
					 				var submitStr = 'JCDP_TABLE_NAME=BGP_PROJECT_HUMAN_RELATION&JCDP_TABLE_ID=&PROJECT_INFO_NO='+zp_id+'&EMPLOYEE_ID='+e_id+'&BSFLAG=0&LOCKED_IF=1&SPARE1='+ datas[i].spare1+'&PLAN_START_DATE='+datasZ[j].acquire_start_time+'&PLAN_END_DATE='+datasZ[j].acquire_end_time+'&ACTUAL_START_DATE='+datasZ[j].acquire_start_time+'&ACTUAL_END_DATE='+datasZ[j].acquire_end_time+'&TEAM='+datas[i].team+'&WORK_POST='+datas[i].work_post+'&PROJECT_EVALUATE='+datas[i].project_evaluate
					 				+'&updator=<%=userName%>&modifi_date=<%=curDate%>&CREATOR=<%=userName%>&CREATE_DATE=<%=curDate%>&spare2=zi';
					 			    syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   
    			
							 } 
							  
				 		 	//  if(datas[i].actual_start_date <= datasZ[j].acquire_start_time || datas[i].actual_start_date  <= datasZ[j].acquire_end_time ){

//											 // }
						}
					
					} 
			}
		
		} 
		
	//	var retuObj = jcdpCallService("HumanLaborMessageSrv", "doHumanReturnafterRelation","relation_nos="+relation_nos);
		checked="";
	}
		
	function shenheNo(){
		if(checked == ""){
				alert("请选择一条记录!");
				return;
		}

	    var tempa = checked.split(',');
	    var relation_nos = "";
	    for(var i=0;i<tempa.length-1; i++){

	    	var tempas = tempa[i];
	    	var tempal = tempas.split("-");
		    var relation_no =  tempal[0];    
			if( i == tempa.length-2){
				relation_nos = relation_nos +"'"+ relation_no+"'" ;
			}else{
				relation_nos = relation_nos + "'"+ relation_no+"',";
			}
		    
		}

		var sql = "update bgp_project_human_relation set locked_if='2',modifi_date=sysdate where relation_no in ("+relation_nos+")";
	    updateEntitiesBySql(sql,"提交");
	    var retuObj = jcdpCallService("HumanLaborMessageSrv", "doHumanReturnafterRelation","relation_nos="+relation_nos);
	    checked="";
	}

	
	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[0];
		        document.getElementById("s_project_name").value = checkStr[1];
	    }
	}
	
	function viewLink(relation_no){
		popWindow("<%=contextPath%>/rm/em/humanProjectRelation/laborModify.upmd?id="+relation_no+"&pagerAction=edit2View");
	}
	
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;
		var lockedIf = document.getElementById("lockedIf").value;
		cruConfig.cdtType = 'form';
	 
		if(s_project_info_no!='' && lockedIf=='' ){	 
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name, hr.plan_start_date,nvl(hr.spare1,he.org_id) org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'     left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'   where hr.bsflag='0'  and s.org_subjection_id like '"+orgS_id+"%'   and  p.project_name   like '%"+s_project_info_no+"%' order by hr.create_date desc";
		    cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectRelation.jsp";
			queryData(1);
			
		}	
		if(lockedIf!='' && s_project_info_no=='' ){				
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name, hr.plan_start_date,nvl(hr.spare1,he.org_id) org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'     left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'   where hr.bsflag='0'  and s.org_subjection_id like '"+orgS_id+"%'   and  hr.locked_if ='"+lockedIf+"'  order by hr.create_date desc";
		    cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectRelation.jsp";
			queryData(1);
		}
		
		if(lockedIf!='' && s_project_info_no!='' ){				
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name, hr.plan_start_date,nvl(hr.spare1,he.org_id) org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'    left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0'  where hr.bsflag='0' and s.org_subjection_id like '"+orgS_id+"%'    and  hr.locked_if ='"+lockedIf+"'  and   p.project_name   like '%"+s_project_info_no+"%'   order by hr.create_date desc";
		    cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectRelation.jsp";
			queryData(1);
		}
		
		if(lockedIf=='' && s_project_info_no=='' ){				
			cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name, hr.plan_start_date,nvl(hr.spare1,he.org_id) org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0'   left join comm_org_subjection s on he.org_id = s.org_id and s.bsflag = '0' where hr.bsflag='0'   and  hr.locked_if ='0'  and s.org_subjection_id like '"+orgS_id+"%'    order by hr.create_date desc";
		    cruConfig.currentPageUrl = "/rm/em/humanProjectRelation/humanProjectRelation.jsp";
			queryData(1);
		}
	}
	
    
	function clearQueryText(){ 
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		document.getElementById("lockedIf").value="";
		cruConfig.cdtStr = "";
	}
</script>

</html>

