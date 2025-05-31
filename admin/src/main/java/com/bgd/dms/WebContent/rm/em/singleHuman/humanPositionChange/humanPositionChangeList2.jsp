<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = "8a9588b63618fc0d01361a93e0bf0018";

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

  <title>岗位变更</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  
			  <td class="ali_cdn_name">人员姓名</td>
		 	    <td class="ali_cdn_input"><input id="s_employee_name" class="input_width"  name="s_employee_name" type="text"   /></td>
			    
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>
			    <td  >&nbsp;</td>
			    <td> 			 
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    </td>		  
  				
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
			      <td class="bt_info_odd" 	 exp="<input type='checkbox' name='chx_entity_id'  id='chx_entity_id' value='{receive_no},{userId},{humanDetailNo},{employee_name},{employee_cd},{employee_id_code_no}'\>">复选框</td>
 				      <td class="bt_info_even" autoOrder="1">序号</td>
				      <td class="bt_info_odd" exp="{employee_cd}">员工编号</td>
				      <td class="bt_info_even" exp="{employee_id_code_no}">身份证号码</td>
				      <td class="bt_info_odd" exp="{employee_name}">员工姓名</td>
				      <td class="bt_info_even" exp="{team_name}">班组</td>
				      <td class="bt_info_odd" exp="{post_name}">岗位</td>
				      <td class="bt_info_even" exp="{start_date}">进入项目实际</td>
				      <td class="bt_info_odd" exp="{end_date}">离开项目实际</td>
				      <td class="bt_info_even" exp="{receive_no}">receive_no</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">岗位明细</a></li>
 
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top:2px;" >
					<tr class="bt_info">
				    	<td>序号</td>
			    	    <td>班组</td>
			    	    <td>岗位</td>
			            <td>计划开始时间</td>
			            <td>计划结束时间</td>		
			            <td>人员评价</td>	
 				        </tr>            
			        </table>
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
	var projectInfoNos = '<%=projectInfoNo%>';
	 
 
	function toAdd(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var train_detail_no =  tempa[0];   
	    var train_edit_struts = tempa[1];
 
	   // if(train_edit_struts == '0'){
	   // 	alert("该信息已经添加过人员！");
	    //	return;
	  //  }
		popWindow('<%=contextPath%>/rm/em/toHumanRecordEdit.srq?projectInfoNo=<%=projectInfoNo%>&func=1&id='+train_detail_no,'1024:800');
	
	}
	
	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var receive_no =  tempa[0];    
	      var userId  =  tempa[1];  
	    var userName = tempa[3];	
	    var employeeCd =  tempa[4];    
	    var codeNo = tempa[5];	
	    
	    if(proc_status == 2 ){
	        alert("该信息单已提交不能修改!");
	    	return;
	    }
		 
	 
			popWindow("<%=contextPath%>/rm/em/toHumanPositionEdit.srq?projectInfoNo=<%=projectInfoNo%>&id="+receive_no+"&update=true&func=1&userName="+userName+"&employeeCd="+employeeCd+"&=codeNo"+codeNo+"&userId="+userId,"1024:800");
			
		    //editUrl = "/rm/em/toHumanPrepareEdit.srq?id="+requirement_no+"&update=true"+"&prepareNo="+prepare_no+"&func=1";
	    	//window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    
	    var train_plan_no =  tempa[0];    
	    var proc_status = tempa[1];		    		  
	    

	    if(proc_status == 2){
	    	alert("该信息已通过,不允许删除");
	    	return;
	    }
			 	 
		var sql = "update BGP_COMM_HUMAN_TRAINING_PLAN set bsflag='1' where train_plan_no ='"+train_plan_no+"'";
		deleteEntities(sql);
		alert('删除成功！');
	}
	
	function toSubmit(){
		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    
	    var train_plan_no =  tempa[0];    
	    var proc_status = tempa[1];		    		  
	        		 
	    if(proc_status == 2){
	    	alert("该信息已提交,不允许再次提交");
	    	return;
	    }
			  
		var sql = "update BGP_COMM_HUMAN_TRAINING_PLAN set modifi_date=sysdate ,proc_status='2'  where train_plan_no ='"+train_plan_no+"'";
		updateEntitiesBySql(sql,"提交");
		refreshData();
		alert('提交成功！');
	}
	
	function refreshData(projectInfoNo){
		if(projectInfoNo==undefined){
			projectInfoNo = projectInfoNos;
		}
		cruConfig.queryStr = "select lr.receive_no,    t.labor_id as userId,  t.labor_deploy_id as humanDetailNo, '' employee_cd,     l.employee_id_code_no,   l.employee_name,   t.start_date,t.end_date,d3.coding_name team_name,d4.coding_name post_name  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2  on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l  on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id  left join comm_coding_sort_detail d4  on d2.post = d4.coding_code_id  left join bgp_comm_human_receive_labor lr  on lr.labor_id = t.labor_id  where t.bsflag = '0'  and lr.bsflag = '0'  and lr.project_info_no =  '"+projectInfoNos+"' union  select   sp.receive_no, d.employee_id  as userId, d.human_detail_no as humanDetailNo, h.employee_cd,'' employee_id_code_no,e.employee_name,d.actual_start_date as start_date ,d.actual_end_date as end_date ,cd.coding_name      team_name,cd2.coding_name     post_name  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no  inner join bgp_comm_human_receive_process sp  on d.employee_id = sp.employee_id  left join gp_task_project t  on sp.project_info_no = t.project_info_no  left join comm_coding_sort_detail cd  on d.team = cd.coding_code_id  left join comm_coding_sort_detail cd2  on d.work_post = cd2.coding_code_id  left join comm_human_employee e  on d.employee_id = e.employee_id  left join comm_human_employee_hr h  on d.employee_id = h.employee_id  where p.bsflag = '0'  and d.bsflag = '0'  and sp.bsflag = '0' and d.actual_start_date is not null  and sp.project_info_no =   '"+projectInfoNos+"'"; 
 
		cruConfig.currentPageUrl = "/rm/em/singleHuman/humanPositionChange/humanPositionChangeList.jsp";
		queryData(1);

		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

 

    function loadDataDetail(ids){
    	 var tempa = ids.split(',');		
 	    ids =  tempa[0];
 		var querySql = "select d.employee_type,    d.train_result,d.notes,     d.train_date,    ls.labor_name,     es.train_name  from BGP_COMM_HUMAN_TRAINING_RECORD d  left  join  BGP_COMM_HUMAN_TRAINING_DETAIL l  on d.train_detail_no=l.train_detail_no  left join (select lt.list_id,  l.labor_id,    l.employee_name as labor_name,   l.employee_id_code_no from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt  on l.labor_id = lt.labor_id                and lt.bsflag = '0'  where l.bsflag = '0'         and lt.list_id is null) ls   on d.employee_id_code = ls.employee_id_code_no  left join (select e.employee_id,                    e.employee_name as train_name,  e.employee_id_code_no  from comm_human_employee e   where e.bsflag = '0') es   on d.employee_id = es.employee_id where d.bsflag = '0'   and d.train_detail_no = '"+ids+"'     order by d.create_date desc";
 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		deleteTableTr("professDetailList");
  		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				var tr = document.getElementById("professDetailList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "even";
				}else{ 
					tr.className = "odd";
				}

               	var td = tr.insertCell(0);
				td.innerHTML = i+1; 
				
				if(datas[i].employee_type =='1'){
					var td = tr.insertCell(1);
					td.innerHTML = datas[i].train_name;
				}else{
					var td = tr.insertCell(1);
					td.innerHTML = datas[i].labor_name;
					
				}
				if(datas[i].employee_type == '0'){
					var td = tr.insertCell(2);
					td.innerHTML = '临时人员';
				}else if(datas[i].employee_type == '1'){
					var td = tr.insertCell(2);
					td.innerHTML = '正式人员';
				} else{
					var td = tr.insertCell(2);
					td.innerHTML = datas[i].employee_type;
				}			

				var td = tr.insertCell(3);
				td.innerHTML = datas[i].train_date;
				
				if(datas[i].train_result =='0'){
					var td = tr.insertCell(4);
					td.innerHTML = '合格';
				}else if (datas[i].train_result =='1'){
					var td = tr.insertCell(4);
					td.innerHTML = '不合格';
				}else{
					var td = tr.insertCell(4);
					td.innerHTML = datas[i].train_result;					
				}
				
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].notes;
				
 

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