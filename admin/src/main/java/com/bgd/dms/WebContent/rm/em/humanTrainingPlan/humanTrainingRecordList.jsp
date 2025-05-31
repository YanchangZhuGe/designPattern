<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo =user.getProjectInfoNo();
	String subOrgId = (user==null)?"":user.getSubOrgIDofAffordOrg();
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

  <title>多项目人员培训记录</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td  width="5%">	 项目名称   </td>
			    <td  width="25%">		    
			    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
		    	<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
			     </td>
		 
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				
			    <td width="55%">&nbsp;</td>
			 
 			    <td> </td>
			   
  				
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
			      <td class="bt_info_odd" 	 exp="<input type='checkbox' name='chx_entity_id'  id='chx_entity_id{train_detail_no}' value='{train_detail_no},{train_edit_struts}'\>"> </td>
					<td class="bt_info_even" 	 autoOrder="1">序号</td>
					<td class="bt_info_odd" 	 exp="{project_name}">项目名称</td>
					<td class="bt_info_even" 	 exp="{applicant_org_name}">所属单位</td>
					<td class="bt_info_odd" 	 exp="{train_content}" >培训内容</td>
					<td class="bt_info_even" 	 exp="{days}">天数</td>
					<td class="bt_info_odd" 	 exp="{train_number}">人数</td>
					<td class="bt_info_even" 	 exp="{train_class}">学时</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">单据明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
 
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top:2px;" >
				    	<tr  >
				    	  <td  class="bt_info_odd">序号</td>
				            <td  class="bt_info_even">姓名</td>
				            <td class="bt_info_odd">用工类别</td>
	 
				       
				            <td class="bt_info_even">考核结果</td>
				            <td class="bt_info_odd">备注</td>
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
	    var train_plan_no =  tempa[0];    
	    var proc_status = tempa[1];		  
	    if(proc_status == 2 ){
	        alert("该信息单已提交不能修改!");
	    	return;
	    }
		 
	 
			popWindow("<%=contextPath%>/rm/em/toHumanPlanEdit.srq?id="+train_plan_no+"&update=true&func=1","1024:800");
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
	
	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[0];
		        document.getElementById("s_project_name").value = checkStr[1];
	    }
	}
	 
	
	// 简单查询
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;

		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += "  and  project_name like '"+s_project_info_no+"%' ";						
		}	
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		
	}
	
	
	function refreshData(){
		 
		cruConfig.queryStr = " select* from (select dl.train_detail_no,dl.train_edit_struts ,    to_date( dl.train_end_date,'yyyy-mm-dd') -to_date(dl.train_start_date,'yyyy-mm-dd')+1 days, dl.create_date,   p.project_name,   p.project_info_no   ,      nvl( pn.org_name ,i.org_abbreviation) applicant_org_name, dl.train_content,dl.train_number,dl.train_class ,nvl(dl.train_cost ,'0') train_cost,nvl(dl.train_transportation,'0')train_transportation,nvl(dl.train_materials,'0') train_materials,nvl(dl.train_places,'0') train_places,nvl(dl.train_accommodation,'0') train_accommodation,nvl(dl.train_other,'0') train_other,nvl(dl.train_total,'0') train_total  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'  left join gp_task_project p         on pn.project_info_no = p.project_info_no          and p.bsflag = '0'            left join comm_org_information i    on pn.spare1 = i.org_id   and i.bsflag = '0'   where dl.bsflag='0' and pn.spare3 like '<%=subOrgId%>%'  " +
				"  union all  select dl.train_detail_no,dl.train_edit_struts ,  to_date( dl.train_end_date,'yyyy-mm-dd') -to_date(dl.train_start_date,'yyyy-mm-dd')+1 days,  dl.create_date,    p.project_name,    p.project_info_no   ,      nvl( dl.org_name ,i.org_abbreviation)  applicant_org_name,dl.train_content,dl.train_number,dl.train_class ,nvl(dl.train_cost ,'0') train_cost,nvl(dl.train_transportation,'0')train_transportation,nvl(dl.train_materials,'0') train_materials,nvl(dl.train_places,'0') train_places,nvl(dl.train_accommodation,'0') train_accommodation,nvl(dl.train_other,'0') train_other,nvl(dl.train_total,'0') train_total  from BGP_COMM_HUMAN_TRAINING_DETAIL dl   left join gp_task_project p         on dl.spare1 = p.project_info_no          and p.bsflag = '0'            left join comm_org_information i    on dl.spare2 = i.org_id   and i.bsflag = '0'   where dl.bsflag='0'  and  dl.train_plan_no is null  and dl.spare3 like '<%=subOrgId%>%'  ) t   order by t.create_date desc  "; 
		cruConfig.currentPageUrl = "/rm/em/humanTrainingPlan/humanTrainingRecordList.jsp";
		queryData(1);

		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

 

    function loadDataDetail(ids){
    	 var tempa = ids.split(',');		
 	    ids =  tempa[0];
    	
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    
 		var querySql ="select d.employee_type,    d.train_result,d.notes,     d.train_date,   decode(ls.employee_name,'',es.employee_name,ls.employee_name) employee_name  from BGP_COMM_HUMAN_TRAINING_RECORD d  left  join  BGP_COMM_HUMAN_TRAINING_DETAIL l  on d.train_detail_no=l.train_detail_no   left join bgp_comm_human_labor ls on d.employee_id = ls.labor_id left join comm_human_employee es on d.employee_id = es.employee_id where d.bsflag = '0'   and d.train_detail_no = '"+ids+"'     order by d.create_date desc " ;
 			//"select d.employee_type,    d.train_result,d.notes,     d.train_date,    ls.labor_name,     es.train_name  from BGP_COMM_HUMAN_TRAINING_RECORD d  left  join  BGP_COMM_HUMAN_TRAINING_DETAIL l  on d.train_detail_no=l.train_detail_no  left join (select lt.list_id,  l.labor_id,    l.employee_name as labor_name,   l.employee_id_code_no from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt  on l.labor_id = lt.labor_id                and lt.bsflag = '0'  where l.bsflag = '0'         and lt.list_id is null) ls   on d.employee_id_code = ls.employee_id_code_no  left join (select e.employee_id,                    e.employee_name as train_name,  e.employee_id_code_no  from comm_human_employee e   where e.bsflag = '0') es   on d.employee_id = es.employee_id where d.bsflag = '0'   and d.train_detail_no = '"+ids+"'     order by d.create_date desc";
 		
 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
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
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].employee_name;
				
				if(datas[i].employee_type == '0'){
					var td = tr.insertCell(2);
					td.innerHTML = '再就业人员';
				}else if(datas[i].employee_type == '1'){
					var td = tr.insertCell(2);
					td.innerHTML = '合同化员工';
				} else if(datas[i].employee_type == '2'){
					var td = tr.insertCell(2);
					td.innerHTML = '市场化用工';
				} else if(datas[i].employee_type == '3'){
					var td = tr.insertCell(2);
					td.innerHTML = '劳务用工';
				}  
				else if(datas[i].employee_type == '4'){
					var td = tr.insertCell(2);
					td.innerHTML = '临时工固定期限合同';
				}  else if(datas[i].employee_type == '5'){
					var td = tr.insertCell(2);
					td.innerHTML = '完成一定工作任务';
				}  else if(datas[i].employee_type == '6'){
					var td = tr.insertCell(2);
					td.innerHTML = '非全日制用工';
				} 
				
				
				else{
					var td = tr.insertCell(2);
					td.innerHTML = datas[i].employee_type;
				}			
	 
//				var td = tr.insertCell(3);
//				td.innerHTML = datas[i].train_date;
 				
				if(datas[i].train_result =='0'){
					var td = tr.insertCell(3);
					td.innerHTML = '合格';
				}else if (datas[i].train_result =='1'){
					var td = tr.insertCell(3);
					td.innerHTML = '不合格';
				}else{
					var td = tr.insertCell(3);
					td.innerHTML = datas[i].train_result;					
				}
				
				
				var td = tr.insertCell(4);
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