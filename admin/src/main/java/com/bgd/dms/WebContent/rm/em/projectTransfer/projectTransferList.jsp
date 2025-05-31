<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  String orgSubjectionId = (user==null)?"":user.getOrgSubjectionId();  
  String orgS_id=(user==null)?"":user.getSubOrgIDofAffordOrg();
	
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  String appDate = df.format(new Date());
 
  String projectInfoNo = (user==null)?"":user.getProjectInfoNo();
  
  String projectType = (user==null)?"":user.getProjectType();	
  if(projectType !=null ){
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
	}
	
	if("5000100004000000009".equals(projectType)){//综合物化探
	//	response.sendRedirect(contextPath+"/rm/em/singleHuman/humanRequired/humanRequiredListZh.jsp");
	}
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
<title>项目转移列表</title>
</head>

<body style="background:#fff"  onload="refreshData()">
        <div id="list_table" >
      <div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
          <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
 
  	    <td class="ali_cdn_name">转入项目</td>
 	       <td  width="20%">	
 					<input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
	  		    	<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
	  			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>  
 
       </td>
          <td class="ali_cdn_name">调配状态</td>
				    <td  width="20%">
				    <select name="s_proc_status" id="s_proc_status" class="select_width" >
				    <option value="">请选择</option>
				    <option value="2">待转移</option>
				    <option value="1">已转移</option>    
				      <option value="0">转移中</option>   
				    </select>			     
		  </td>
				    
				    
          <td class="ali_query">
		    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	       </td>
	       <td class="ali_query">
		    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
	    	</td>
            <td width="25%">&nbsp;</td>   
          <auth:ListButton functionId="" css="zj" event="onclick='shenqingAdd()'" title="JCDP_btn_add"></auth:ListButton>
          <auth:ListButton functionId="" css="xg" event="onclick='xiugai()'" title="JCDP_btn_edit"></auth:ListButton>
          <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
          <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
          <auth:ListButton functionId="F_HUMAN_0016" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
        
        </tr>
         
      </table>
      </td>
          <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
        </tr>
      </table>
      </div>
      <div id="table_box">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
          <tr>
            <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{ptransfer_id},{zy_status},{aproject_info_no},{bproject_info_no}' id='rdo_entity_id_{ptransfer_id}' onclick='chooseOne(this);' />" >选择</td>
            <td class="bt_info_even" autoOrder="1">序号</td>
            <td class="bt_info_odd" exp="{transfer_name}">转移单名称</td>
            <td class="bt_info_even" exp="{ap_name}" >转出项目</td>
            <td class="bt_info_odd" exp="{bp_name}">转入项目</td>   
            <td class="bt_info_even" exp="{back_hname}">经办人</td>
            <td class="bt_info_odd" exp="{zy_status_name}">状态</td>
            <td class="bt_info_even" exp="{deploy_date}">已转移时间</td>
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
          <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">单据明细</a></li>
          <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
          <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
        </ul>
      </div>
      
      <div id="tab_box" class="tab_box">
        <div id="tab_box_content0" class="tab_box_content">
         <table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
            <tr class="bt_info">
                  <td>序号</td>
                  <td>用工性质</td>
                  <td>姓名</td>                
                  <td>班组</td>
                  <td>岗位</td>
                  <td>员工编号</td>
                    <td>开始日期</td>
                      <td>结束日期</td>
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
//  $("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
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
var projectType ="<%=projectType%>";

function shenqingAdd(){
	popWindow('<%=contextPath%>/rm/em/projectTransfer/pTransferAdd.jsp','950:680');

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


function xiugai(){

	ids = getSelectedValue();
	  if (ids == '') {
	    alert("请选择一条记录!");
	    return;
	  }    
	  var tempa = ids.split(',');  
	  var ptransfer_id =  tempa[0];   
	  var zy_status =  tempa[1];   
	  var aproject_info_no =  tempa[2];  
	  var bproject_info_no =  tempa[3];  
	  
	  if(zy_status == 1){
	  	alert("该单据已提交,不允许修改");
	  	return;
	  }
 
  popWindow('<%=contextPath%>/rm/em/projectTransfer/pTransferAdd.jsp?ptransfer_id='+ptransfer_id,'900:680');

}

function toDelete(){
   
	ids = getSelectedValue();
	  if (ids == '') {
	    alert("请选择一条记录!");
	    return;
	  }    
	  var tempa = ids.split(',');  
	  var ptransfer_id =  tempa[0];   
	  var zy_status =  tempa[1];   
	  var aproject_info_no =  tempa[2];  
	  var bproject_info_no =  tempa[3];  
	  
	  if(zy_status == "1"){
	  	alert("该单据已提交,不允许删除");
	  	return;
	  }
 
	  
	   if(zy_status == "0"){
		  	 alert("该单据转移中,不允许删除");
		  	 return;
	    }
	  
	  
	  if (!window.confirm("确认要删除吗?")) {
		    return;
	  }
 
		    var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
			var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PTRANSFER&JCDP_TABLE_ID='+ptransfer_id +'&bsflag=1';
		    syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));   
		
		    
		 
		var querySql1 = "select distinct t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   t.ACTUAL_START_DATE,  t.ACTUAL_END_DATE,  t.plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name , t.zy_type  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id    left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id    left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where   t.zy_type='"+ptransfer_id+"'  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id is null  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME  ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		if(datas1 != null){	 
		     for (var i = 0; i< queryRet1.datas.length; i++) {    
		    	 var xz_type_s=datas1[i].xz_type;
		    	 var pk_id_s=datas1[i].pk_ids;
		    	 
		    	 if(xz_type_s == "1"){
			   		  var submitStr1 = 'JCDP_TABLE_NAME=bgp_human_prepare_human_detail&JCDP_TABLE_ID='+pk_id_s+'&zy_type='; 
		    		  syncRequest('Post',paths,encodeURI(encodeURI(submitStr1)));  //如果有人转移修改 状态 0 待转移	
		     
					}else{ 
						var submitStr2 = 'JCDP_TABLE_NAME=bgp_comm_human_labor_deploy&JCDP_TABLE_ID='+pk_id_s+'&zy_type='; 
			    		syncRequest('Post',paths,encodeURI(encodeURI(submitStr2)));  //如果有人转移修改 状态 0 待转移	

					}
		    	 
		    	  
		     } 
		}
		
		
	  refreshData();
	  
	   
}


var selectedTagIndex = 0;
var showTabBox = document.getElementById("tab_box_content0");


function refreshData(){
	 
  cruConfig.queryStr = "select  decode(t.zy_status,   '1',   '已转移','0','转移中','2','待转移') zy_status_name,  t.ptransfer_id,t.transfer_name,t.aproject_info_no,pt.project_name ap_name ,bt.project_name bp_name ,t.bproject_info_no,t.back_hname,t.back_hid,t.zy_status, t.deploy_date  ,t.spare1,t.spare2  from  bgp_comm_human_ptransfer t  left join gp_task_project  pt  on t.aproject_info_no=pt.project_info_no and pt.bsflag='0'  left  join   gp_task_project  bt  on t.bproject_info_no=bt.project_info_no and bt.bsflag='0'  where  t.bsflag='0' and t.spare2 like '%<%=orgS_id%>%'  and t.locked_if is null order by t.modifi_date desc"; 
  cruConfig.currentPageUrl = "/rm/em/singleHuman/humanRequired/humanRequiredList.jsp";
  queryData(1);
}
 
   
function simpleSearch(){ 
 
	var s_project_info_no = document.getElementById("s_project_name").value;
	var s_proc_status = document.getElementById("s_proc_status").value;

	var str = " 1=1 ";
	
	if(s_project_info_no!=''){			
		str += "  and  bp_name like '%"+s_project_info_no+"%' ";						
	}	
	if(s_proc_status!=''){			
		str += " and zy_status like '"+s_proc_status+"%' ";						
	}
	
	cruConfig.cdtStr = str;
	refreshData();
	 
}
function clearQueryText(){ 
	document.getElementById("s_project_info_no").value="";
	document.getElementById("s_project_name").value="";
	document.getElementById("s_proc_status").value="";
}


function toSubmit(){
 
  ids = getSelectedValue();
  if (ids == '') {
    alert("请选择一条记录!");
    return;
  }    
  var tempa = ids.split(',');  
  var ptransfer_id =  tempa[0];   
  var zy_status =  tempa[1];   
  var aproject_info_no =  tempa[2];  
  var bproject_info_no =  tempa[3];  
  
  if(zy_status == "1"){
  	alert("该单据已提交,不允许再次提交");
  	return;
  }
	if(zy_status == "2" ){
      alert("该单据无数据,请先添加人员!");
  	return;
  }

	if (!window.confirm("确认要提交吗?")) {
		return;
	}
	
    var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
	var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PTRANSFER&JCDP_TABLE_ID='+ptransfer_id +'&zy_status=1&deploy_date=<%=appDate%>';
    syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));   
 
	
	var querySql1 = "select t.*  from (select distinct t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   t.ACTUAL_START_DATE,  t.ACTUAL_END_DATE,  t.plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name , t.zy_type  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id    left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id    left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where   t.zy_type='"+ptransfer_id+"'  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id is null  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME) t  where 1 = 1  ";
	var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
	var datas1 = queryRet1.datas; 
	if(datas1 != null){	 
	     for (var i = 0; i< queryRet1.datas.length; i++) {     
	    		var submitStrs = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PT_DETAIL&JCDP_TABLE_ID=&ptransfer_id='+ptransfer_id+'&aproject_info_no='+aproject_info_no+'&bproject_info_no='+bproject_info_no+'&start_date=<%=appDate%>&employee_gz='+datas1[i].employee_gz
	    		+'&employee_gz_name='+datas1[i].employee_gz_name+'&creator=<%=user.getUserName()%>&updator=<%=user.getUserName()%>&create_date=<%=appDate%>&modifi_date=<%=appDate%>&bsflag=0&team_s='+datas1[i].team+'&post_s='+datas1[i].work_post+'&team_name='+datas1[i].team_name+'&work_post_name='+datas1[i].work_post_name
	    	 	+'&employee_name='+datas1[i].employee_name+'&employee_cd='+datas1[i].employee_cd+'&employee_id='+datas1[i].employee_id+'&xz_type='+datas1[i].xz_type+'&pk_ids='+datas1[i].pk_ids;
	    	    syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));  //新增保存主表信息			

	     } 
	}
	
  loadDataDetail(ptransfer_id+',1');
  refreshData();
  
}

    
   function chooseOne(cb){   
          var obj = document.getElementsByName("rdo_entity_id");   
          for (i=0; i<obj.length; i++){   
              if (obj[i]!=cb) obj[i].checked = false;   
              else obj[i].checked = true;   
          }   
      }   
   
   
   
   function loadDataDetail(ids){
	   var ptransfer_id = ids.split(",")[0];  
	   var zy_status = ids.split(",")[1];
	    
          
     document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split(",")[0];  	    
     document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split(",")[0];
     
	     if(zy_status == "1" ){
	    	 
	    	 var querySql = "select t.aproject_info_no,t.bproject_info_no,t.start_date,t.end_date,t.ptdetail_id,t.ptransfer_id,t.pk_ids,t.xz_type,t.employee_id,t.employee_cd,t.employee_name,t.team_name,t.team_s,t.post_s,t.work_post_name,t.employee_gz_name,t.employee_gz from  BGP_COMM_HUMAN_PT_DETAIL  t  where t.bsflag='0' and t.ptransfer_id='"+ptransfer_id+"'  ";
	         var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
	         var datas = queryRet.datas;      
	         deleteTableTr("professDetailList");
	           
	         loadProcessHistoryInfo();
	          
	          if(datas != null){
		            for (var i = 0; i< queryRet.datas.length; i++) {
		              
		              var tr = document.getElementById("professDetailList").insertRow();    
		              
		            	if(i % 2 == 1){  
		              		tr.className = "odd";
		    			}else{ 
		    				tr.className = "even";
		    			}
	  
		              var td = tr.insertCell(0);
		              td.innerHTML = i+1  
		              
		              var td = tr.insertCell(1);
		              td.innerHTML = datas[i].employee_gz_name;
		              
		              var td = tr.insertCell(2);
		              td.innerHTML = datas[i].employee_name;
		 
		              var td = tr.insertCell(3);
		              td.innerHTML = datas[i].team_name;
		             
		              var td = tr.insertCell(4);
		              td.innerHTML = datas[i].work_post_name;
		                                                         
		              var td = tr.insertCell(5);
		              td.innerHTML = datas[i].employee_cd;
		              var td = tr.insertCell(6);
		              td.innerHTML =datas[i].start_date;
		              var td = tr.insertCell(7);
		              td.innerHTML = datas[i].end_date;
		               
		            }
	          }  
	           
	    	 
	          
	          
	    	 
	     }else{
	    	 
	    	 var querySql = "select t.*  from (select distinct t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   t.ACTUAL_START_DATE,  t.ACTUAL_END_DATE,  t.plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name , t.zy_type  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id    left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id    left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where   t.zy_type='"+ptransfer_id+"'  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id is null  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME) t  where 1 = 1  ";
	         var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
	         var datas = queryRet.datas;      
	         deleteTableTr("professDetailList");
	           
	         loadProcessHistoryInfo();
	          
	          if(datas != null){
		            for (var i = 0; i< queryRet.datas.length; i++) {
		              
		              var tr = document.getElementById("professDetailList").insertRow();    
		              
		            	if(i % 2 == 1){  
		              		tr.className = "odd";
		    			}else{ 
		    				tr.className = "even";
		    			}
	  
		              var td = tr.insertCell(0);
		              td.innerHTML = i+1  
		              
		              var td = tr.insertCell(1);
		              td.innerHTML = datas[i].employee_gz_name;
		              
		              var td = tr.insertCell(2);
		              td.innerHTML = datas[i].employee_name;
		 
		              var td = tr.insertCell(3);
		              td.innerHTML = datas[i].team_name;
		             
		              var td = tr.insertCell(4);
		              td.innerHTML = datas[i].work_post_name;
		                                                         
		              var td = tr.insertCell(5);
		              td.innerHTML = datas[i].employee_cd;
		                  
		              var td = tr.insertCell(6);
		              td.innerHTML ="";
		              var td = tr.insertCell(7);
		              td.innerHTML = "";
		            }
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
    
</script>

</html>

