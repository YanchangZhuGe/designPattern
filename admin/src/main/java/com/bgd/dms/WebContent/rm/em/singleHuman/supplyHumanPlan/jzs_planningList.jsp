<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	String splan_id = request.getParameter("splanId");
	String show_p = request.getParameter("show_p");
	
	String projectName=user.getProjectName();
	projectName=java.net.URLDecoder.decode(projectName,"utf-8");
	String projectType =user.getProjectType();
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
<title>计划编制</title> 
</head> 
 
 <body style="background:#fff" onload="refreshData();loadApplyTeam('<%=projectType%>')">
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
				
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>	
		 
				<auth:ListButton functionId="" css="jd" event="onclick='toTj()'" title="统计"></auth:ListButton>
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
			  <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>

			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr class="bt_info">
			    	    <td>序号</td>
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
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>	
				</div>
				 
		  	</div>
	</div>
</body>
<script type="text/javascript">
function frameSize(){
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
	var projectInfoNo ="<%=projectInfoNo%>";
	var projectName="<%=projectName%>";
	var projectType="<%=projectType%>";
	var proc_status = "";
	
	
	
	function refreshData(){
 

		cruConfig.queryStr = "select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date)+1 nums,d.notes from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where    d.project_info_no='"+projectInfoNo+"' and d.spare1 ='<%=splan_id%>' and d.bsflag='0' ";
		cruConfig.currentPageUrl = "/rm/em/planning/planningList.jsp";
		queryData(1);

 
	}
	function toBack(){
		 window.parent.location='supplyHumanPlan.jsp'; 
	}
	 
	
	function toTj(){
		  popWindow("<%=contextPath%>/rm/em/singleHuman/supplyHumanPlan/selectCharts.jsp?splan_id=<%=splan_id%>","900:680");
 
		//popWindow('<%=contextPath%>/rm/em/singleHuman/humanPlan/humanPostChart.jsp?team='+'0110000001000000001','800:680');
	}
	
	function toAdd(){
		 
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanPlan/jz_add_planning.jsp?projectInfoNo=<%=projectInfoNo%>&projectType=<%=projectType%>&planId=<%=splan_id%>','1000:800');
	}
		
	function toEdit() {
 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanPlan/jz_add_planning.jsp?projectInfoNo=<%=projectInfoNo%>&projectType=<%=projectType%>&planId=<%=splan_id%>&id='+ids,'1000:800');
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

		var sql = "update bgp_comm_human_plan_detail t set t.bsflag='1' where t.plan_detail_id ='"+ids+"' ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();
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
    	 
		 var  querySql1 = "select rownum,p.* from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date)+1  nums  from bgp_comm_human_plan_detail d   left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'     left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'    where d.plan_detail_id='"+ids+"'  and d.spare1 ='<%=splan_id%>'  and d.bsflag='0' ) p ";
		 var  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		 var  datas1 = queryRet1.datas;
			deleteTableTr("planDetailList");
		 if(datas1 != null){
				for (var i = 0; i< queryRet1.datas.length; i++) {
					
					var tr = document.getElementById("planDetailList").insertRow();		

	            	if(i % 2 == 1){  
	              		classCss = "even_";
	            	}else{ 
	            		classCss = "odd_";
	            	}
	              	
					var td = tr.insertCell(0);
					td.className=classCss+"odd";
					td.innerHTML = datas1[i].rownum; 
					
					var td = tr.insertCell(1);
					td.className=classCss+"even";
					td.innerHTML = datas1[i].apply_team_name;
					
					var td = tr.insertCell(2);
					td.className=classCss+"odd";
					td.innerHTML = datas1[i].post_name;

					var td = tr.insertCell(3);
					td.className=classCss+"even";
					td.innerHTML = datas1[i].people_number;
 
					var td = tr.insertCell(4);
					td.className=classCss+"odd";
					td.innerHTML = datas1[i].profess_number;
			 
					var td = tr.insertCell(5);
					td.className=classCss+"even";
					td.innerHTML = datas1[i].plan_start_date;
					
					var td = tr.insertCell(6);
					td.className=classCss+"odd";
					td.innerHTML = datas1[i].plan_end_date;
					
					var td = tr.insertCell(7);
					td.className=classCss+"even";
					td.innerHTML = datas1[i].nums;

				}
			}
			
		 
		 
    	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids; 		    
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
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
		refreshData();
	}
	
	function clearQueryText(){ 
		document.getElementById("s_apply_team").value="";
    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);
	}
</script>
<script type="text/javascript" src="<%=contextPath%>/common/applyTeam.js"></script>
</html>