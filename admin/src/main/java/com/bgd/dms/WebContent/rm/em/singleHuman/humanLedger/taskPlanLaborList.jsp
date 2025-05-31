<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String taskObjectId = request.getParameter("taskObjectId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String laborCategory = request.getParameter("laborCategory");
 
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

  <title>作业级页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><input id="s_employee_name" name="s_employee_name" type="text" class="input_width"  onkeypress="simpleRefreshData()"/></td>
			    <td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><input id="s_employee_cd" name="s_employee_cd" type="text" class="input_width" onkeypress="simpleRefreshData()"/></td>
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>
			    <td>&nbsp;</td>
			    <td>	    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> </td>
  	 
	 
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{labor_id}' id='rdo_entity_id_{labor_id}'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>			      
			      <td class="bt_info_odd" exp="{employee_name}">员工姓名</td>
			      <td class="bt_info_even" exp="{employee_id_code_no}">身份证号</td>
			      <td class="bt_info_odd" exp="{apply_team_name}">班组</td>
			      <td class="bt_info_even" exp="{post_name}">岗位</td>
			      <td class="bt_info_odd" exp="{start_date}">预计进入项目时间</td>
			      <td class="bt_info_even" exp="{end_date}">预计离开项目时间</td> 
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">作业信息</a></li>			
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    
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
	var taskIds = '<%=taskId%>';
	var taskObjectIds = '<%=taskObjectId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
 
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("s_employee_name").value;
			refreshData(undefined, q_file_name);
		}
	}
	
	function refreshData(taskId,projectInfoNo){
 
		if(taskId==undefined){
			taskId = taskIds;
		}
		
		if(projectInfoNo==undefined){
			projectInfoNo = projectInfoNos;
		}
		
		cruConfig.queryStr = "select distinct t.labor_deploy_id,        t.labor_id,        l.employee_name,        l.employee_id_code_no,        t.project_info_no,        t.start_date,        t.end_date,  d2.deploy_detail_id,        d2.apply_team,        d2.post,        d3.coding_name apply_team_name,        d4.coding_name post_name,        round( case when nvl(t.end_date, sysdate) - t.start_date > 0 then nvl(t.end_date, sysdate) - t.start_date  -(-1) else 0 end ) days   from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id and d2.bsflag='0'  left join bgp_comm_human_labor l on t.labor_id = l.labor_id   left join comm_coding_sort_detail d3 on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4 on d2.post = d4.coding_code_id  left join bgp_comm_human_receive_labor lr     on lr.labor_id=l.labor_id   where t.bsflag = '0' and t.project_info_no =  '"+projectInfoNos+"'   lr.task_id ='"+taskObjectIds+"' and l.if_engineer='<%=laborCategory%>' and t.start_date is not null and  t.end_date is null ";
		cruConfig.currentPageUrl = "/rm/em/singleHuman/humanLedger/taskPlanLaborList.jsp";
		queryData(1); 
	}


	 
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
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
	
 
	
	 
    //chooseOne()函式，參數為觸發該函式的元素本身   
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

	 
    function loadDataDetail(ids){
     	 

		  document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;		    
		    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		    
		    var querySql = "select rownum,p.* from (select a.name,a.planned_duration,a.planned_start_date,a.planned_finish_date from bgp_comm_human_receive_labor t left join bgp_p6_activity a on t.task_id=a.object_id and a.bsflag='0' where t.bsflag='0' and t.labor_id='"+ids+"') p ";
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
					td.innerHTML = datas[i].planned_start_date;
		
					var td = tr.insertCell(3);
					td.innerHTML = datas[i].planned_finish_date;

					var td = tr.insertCell(4);
					td.innerHTML = datas[i].planned_duration;
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