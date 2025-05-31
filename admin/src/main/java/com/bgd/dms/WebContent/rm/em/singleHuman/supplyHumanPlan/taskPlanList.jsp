<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String splan_id = request.getParameter("splanId");
	String taskObjectId = request.getParameter("taskObjectId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String show_p = request.getParameter("show_p");
	
	String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
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

  <title>作业级页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" onchange="getPost()"></select></td>
			    <td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><select class="select_width"  id="s_post" name="s_post" ></select></td>
	   			<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				<td>&nbsp;</td>
				  <auth:ListButton functionId=""  id="zj"  css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton> 
				  <auth:ListButton functionId="" id="xg"  css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
				 <auth:ListButton functionId="" id="sc"  css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton> 
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回上级"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{plan_detail_id}' id='rdo_entity_id_{plan_detail_id}'  onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{apply_team_name}">班组</td>
			      <td class="bt_info_even" exp="{post_name}">岗位</td>
			      <td class="bt_info_odd" exp="{people_number}">计划人数</td>
			      <td class="bt_info_odd" exp="{profess_number}">其中专业化人数</td>
			      <td class="bt_info_even" exp="{plan_start_date}">计划进入时间</td>
			      <td class="bt_info_odd" exp="{plan_end_date}">计划离开时间</td>
			      <td class="bt_info_even" exp="{nums}">天数</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">作业</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item4">作业名称：</td>
			      <td class="inquire_form4" ><input id="name" class="input_width" type="text"  readonly/></td>
			      <td class="inquire_item4">原定工期：</td>
			      <td class="inquire_form4" ><input id="planned_duration" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>
			      <td class="inquire_item4">计划开始日期：</td>
			      <td class="inquire_form4" ><input id="planned_start_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item4">计划结束日期：</td>
			      <td class="inquire_form4" ><input id="planned_finish_date" class="input_width" type="text" readonly/> </td>
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
	var taskIds = '<%=taskObjectId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
	var splan_id = '<%=splan_id%>';
	var show_p = '<%=show_p%>';
 
	//if(show_p=='0'){  判断是否只读
		//document.getElementById("xg").style.display="none";
		//document.getElementById("zj").style.display="none";
		//document.getElementById("sc").style.display="none";
	//}
	
	var proc_status = "";
	
	function refreshData(taskId,projectInfoNo){
		if(taskId==undefined){
			taskId = taskIds;
		}
		if(projectInfoNo==undefined){
			projectInfoNo = projectInfoNos;
		}
		
		var querySql = "select r.proc_status from bgp_comm_human_plan p left join common_busi_wf_middle r on p.plan_id=r.business_id and r.bsflag='0' where p.bsflag='0' and p.spare1='0' and p.plan_id='"+splan_id+"' and  p.project_info_no='"+projectInfoNo+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			proc_status = datas[0].proc_status;
		}

		cruConfig.queryStr = "select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date + 1 ) nums from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'  and s1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'  and s2.coding_mnemonic_id='<%=projectType%>'  where d.task_id='"+taskId+"' and d.spare1='"+splan_id+"'  and d.project_info_no='"+projectInfoNo+"' and d.bsflag='0' ";
		cruConfig.currentPageUrl = "/rm/em/singleHuman/supplyHumanPlan/taskPlanList.jsp";
		queryData(1);
		
		loadDataDetail();
	}


	function toAdd(){ 
		popWindow('<%=contextPath%>/rm/em/singleHuman/supplyHumanPlan/add_taskPlanModify.jsp?taskId=<%=taskObjectId%>&projectInfoNo=<%=projectInfoNo%>&splanId=<%=splan_id%>','1000:800');
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
	
	function toEdit() {
	    
	//	ids = getSelIds('rdo_entity_id');
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
 
		popWindow('<%=contextPath%>/rm/em/singleHuman/supplyHumanPlan/add_taskPlanModify.jsp?taskId=<%=taskObjectId%>&projectInfoNo=<%=projectInfoNo%>&splanId=<%=splan_id%>&id='+ids,'1000:800');
	}
	
	function toDelete(){
		
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
 
		
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		
//		var tempIds = ids.split(",");
//		var id = "";
//		for(var i=0;i<tempIds.length;i++){
//			id = id + "'" + tempIds[i] + "'";
//			if(i != tempIds.length -1){
//				id = id + ",";
//			}
//		}

		var sql = "update bgp_comm_human_plan_detail t set t.bsflag='1' where t.plan_detail_id ='"+ids+"' ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();


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
		    
		var querySql = "select t.name,t.planned_duration,t.planned_start_date,t.planned_finish_date from bgp_p6_activity t where t.object_id ='<%=taskObjectId%>'";

		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			document.getElementById("name").value=datas[0].name;
			document.getElementById("planned_duration").value=datas[0].planned_duration;
			document.getElementById("planned_start_date").value=datas[0].planned_start_date;
			document.getElementById("planned_finish_date").value=datas[0].planned_finish_date;

		}
						
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
    
	// 简单查询
	function simpleSearch(){

		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;

		var str = " 1=1 ";
		
		if(s_apply_team!=''){			
			str += " and apply_team like '"+s_apply_team+"%' ";
			
			if(s_post!=''){			
				str += " and post like '"+s_post+"%' ";
			}else{
				str += " and post like '%' ";
			}
			
		}else{
			str += " and apply_team like '%' ";
		}

		cruConfig.cdtStr = str;
		refreshData(undefined,undefined);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_apply_team").value="";
    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);
	}
	
	function toBack(){
		 window.parent.location='supplyHumanPlan.jsp'; 
	}
	
</script>
</html>