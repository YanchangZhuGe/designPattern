<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String taskObjectId = request.getParameter("taskObjectId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
	String businessType_s="5110000004100000022";
	String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
		businessType_s="5110000004100001057";
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
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
				<auth:ListButton functionId="" css="tj" event="onclick='submitProcessInfo()'" title="JCDP_btn_submit"></auth:ListButton>
				<auth:ListButton functionId="" css="jd" event="onclick='toTj()'" title="统计"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{apply_team}-{post}-{plan_detail_id}' id='rdo_entity_id_{plan_detail_id}' />" >选择</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">作业</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
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
				            <td>班组</td>			
				            <td>岗位</td> 
				            <td>计划人数</td>
				            <td>其中专业化人数</td>
				            <td>计划进入时间</td>
				            <td>计划离开时间</td>		
				            <td>天数</td>			
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
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
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
	var projectInfoNos = '<%=projectInfoNo%>';

	
	function refreshData(taskId,projectInfoNo){
		
		if(taskId==undefined){
			taskId = taskIds;
		}
		if(projectInfoNo==undefined){
			projectInfoNo = projectInfoNos;
		}

		cruConfig.queryStr = "select p.apply_team_name, p.post_name,p.apply_team,p.plan_detail_id, p.post,sum(nvl(p.people_number,0)) people_number , sum(nvl(p.profess_number,0)) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date) + 1 ) nums from ( select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date + 1 ) nums from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' and s1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' and s2.coding_mnemonic_id='<%=projectType%>'  where d.project_info_no='"+projectInfoNo+"' and d.spare1 is null  and d.bsflag='0' ) p group by p.apply_team_name,p.post_name ,p.apply_team, p.post ,p.plan_detail_id  ";
		cruConfig.currentPageUrl = "/rm/em/singleHuman/humanPlan/rootPlanList.jsp";
		queryData(1);
		configProecessInfo();
		loadProcessHistoryInfo();
		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	
	function toTj(){
	      popWindow("<%=contextPath%>/rm/em/singleHuman/humanPlan/selectCharts.jsp","900:680");
		//popWindow('<%=contextPath%>/rm/em/singleHuman/humanPlan/humanPostChart.jsp?team='+'0110000001000000001','800:680');
	}
	
	function configProecessInfo() {	    
		
		var planId = jcdpCallService("HumanCommInfoSrv","submitHumanPlan","projectInfoNo=<%=projectInfoNo%>");	

		processNecessaryInfo={        //流程引擎关键信息
				businessTableName:"bgp_comm_human_plan",    //置入流程管控的业务表的主表表明
				businessType:"<%=businessType_s%>",        //业务类型 即为之前设置的业务大类
				businessId:planId.planId,           //业务主表主键值
				businessInfo:"单项目需求计划申请",        //用于待审批界面展示业务信息
				applicantDate:"<%=appDate%>"       //流程发起时间
			};
		processAppendInfo={ //流程引擎附加临时变量信息
				projectInfoNo:'<%=projectInfoNo%>',
				projectInfoType:'<%=projectType%>',
				projectName:'<%=user.getProjectName()%>'
			};
		
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

 		    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[2]; 		    
 		    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[2];
 		    
    	var querySql = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date + 1 ) nums,a.name,a.planned_start_date,a.planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' and s1.coding_mnemonic_id='<%=projectType%>' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'  and s2.coding_mnemonic_id='<%=projectType%>' where d.project_info_no='<%=projectInfoNo%>' and d.spare1 is null  and d.apply_team='"+ids.split("-")[0]+"' and d.post='"+ids.split("-")[1]+"' and d.bsflag='0' ) p ";
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
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].apply_team_name;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].post_name;

				var td = tr.insertCell(7);
				td.innerHTML = datas[i].people_number;
				
				var td = tr.insertCell(8);
				td.innerHTML = datas[i].profess_number;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas[i].plan_start_date;
				
				var td = tr.insertCell(10);
				td.innerHTML = datas[i].plan_end_date;
				
				var td = tr.insertCell(11);
				td.innerHTML = datas[i].nums;

			}
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
	
	function submitProcessInfo(){
		
		if('configProecessInfo' in window){
			configProecessInfo();
		}
		var updateM = jcdpCallService("HumanCommInfoSrv","submitHumanPlanUpdate","projectInfoNo=<%=projectInfoNo%>");	
		//查询流程是否已提交
		var submitStr='businessTableName='+processNecessaryInfo.businessTableName+'&businessType='+processNecessaryInfo.businessType+'&businessId='+processNecessaryInfo.businessId;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		processStatusInfo.procStatus=procStatus;
		
		if(processStatusInfo.procStatus=='3'||processStatusInfo.procStatus=='1'){
			alert("需求提交后不得更改，请确认提交");
			return ;
		}
		var submitStr="startProcess=true";
		for(i in processNecessaryInfo){
			submitStr+="&"+i+"="+processNecessaryInfo[i];
			if(processNecessaryInfo[i]==null||processNecessaryInfo[i]==""||processNecessaryInfo[i]==undefined){
				alert(i+"未设置值,请设置后再进行提交");
				return false;
			}
		}
		for(j in processAppendInfo){
			submitStr+="&wfVar_"+j+"="+processAppendInfo[j];
		}
		
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		retObject = jcdpCallService('WFCommonSrv','startWFProcess',submitStr)
		alert('提交成功');
		loadProcessHistoryInfo();
	}
	
	
</script>
</html>