<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo="";
	if(request.getParameter("project_info_no")!=null){
		projectInfoNo=request.getParameter("project_info_no");
	}else{
		projectInfoNo=user.getProjectInfoNo(); 
	}
	String project_name=user.getProjectName();
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
 <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

  <title>处理解释设计</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
   				
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
			       <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{design_id}' id='rdo_entity_id_{design_id}'  onclick=doCheck(this)/>" >选择</td>
			       <td class="bt_info_even" autoOrder="1">序号</td>
			       <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			       <td class="bt_info_odd" exp="<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">处理解释设计</td>
			       <td class="bt_info_odd" exp="{writer}" width="200">编写人</td>	
			       <td class="bt_info_odd" exp="{status}">审批状态</td>
			       <td class="bt_info_odd" exp="{create_date}">上传日期</td>
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="12" height="12" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="12" height="12" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="12" height="12" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="12" height="12" /></td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>		    
			    <li class="selectTag" id="tag3_1" ><a href="#" onclick="getTab3(1)">审批流程</a></li>		    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6"> <input type="text" id="project_name" name="project_name" /></td>
					    <td class="inquire_item6"><span class="red_star">*</span>编写人： </td>
					    <td class="inquire_form6" ><input type="text" id="writer" name="writer" /></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"> 处理计划开始时间：</td>
					    <td class="inquire_form6"> 
					         <input type="text" id="proces_plan_startdate" name="proces_plan_startdate" />
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(proces_plan_startdate,tributton1);" />
					    </td>
					    <td class="inquire_item6"> 处理计划结束时间： </td>
					    <td class="inquire_form6" >
					         <input type="text" id="proces_plan_enddate" name="proces_plan_enddate" />
		    			&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(proces_plan_enddate,tributton2);" />
					    </td>
					  </tr>
					    <tr>
					  	<td class="inquire_item6"> 解释计划开始时间：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="interp_plan_startdate" name="interp_plan_startdate" />
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(interp_plan_startdate,tributton3);" />
					    
					    </td>
					    <td class="inquire_item6"> 解释计划结束时间： </td>
					    <td class="inquire_form6" >
					    <input type="text" id="interp_plan_senddate" name="interp_plan_senddate" />
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(interp_plan_senddate,tributton4);" />
					    
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">处理解释设计</td>
					    <td class="inquire_form6" >
					    <input type="text"  name="file_name"  id="file_name" readonly style="background:#CCCCCC"/>
					    </td>
					  </tr>
			        </table>
				</div>
				 
				 
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo   title=""/>		
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
 
	
	function refreshData(){
		debugger;
		var projectInfoNo="<%=projectInfoNo%>";
 		var str="select wt.* , case when  e.proc_status='1' then '待审批'  when  e.proc_status='3' then '审批通过' "+
 		" when  e.proc_status='4' then '审批不通过' else '未提交' end  status  ,t.project_name from GP_OPS_PROINTE_DESIGN_WT wt "+
 		"  left join   COMMON_BUSI_WF_MIDDLE  e on e.business_id=wt.design_id and e.busi_table_name='GP_OPS_PROINTE_DESIGN_WT' and e.bsflag='0'"+
 		" left join gp_task_project t on t.project_info_no=wt.project_info_no and t.bsflag='0' where wt.bsflag='0' and wt.project_info_no='"+ projectInfoNo+"'";
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
    	   if(ids==''){ 
   		    alert("请先选中一条记录!");
        		return;
   	    }
    	   debugger;
     	   var retObj = jcdpCallService("WtProinteSrv", "getProjectInfo", "design_id="+ids);
     		document.getElementById("project_name").value= retObj.map.projectName; 
     		document.getElementById("writer").value= retObj.map.writer; 
     		document.getElementById("proces_plan_startdate").value= retObj.map.procesPlanStartdate; 
     		document.getElementById("proces_plan_enddate").value= retObj.map.procesPlanEnddate; 
     		document.getElementById("interp_plan_startdate").value= retObj.map.interpPlanStartdate; 
     		document.getElementById("interp_plan_senddate").value= retObj.map.interpPlanSenddate; 
     		document.getElementById("file_name").value= retObj.map.fileName; 

     		  processNecessaryInfo={         
        	    		businessTableName:"GP_OPS_PROINTE_DESIGN_WT",    //置入流程管控的业务表的主表表明
        	    		businessType:"5110000004100001093",        //业务类型 即为之前设置的业务大类
        	    		business_id:ids,         //业务主表主键值
        	    		businessInfo: '处理解释设计审批',        //用于待审批界面展示业务信息
        	    		applicantDate:'<%=appDate%>' ,      //流程发起时间
        	    		project_info_no:"12312312312",
        	    		projectName:retObj.map.projectName	 
        	    	}; 
     			processAppendInfo={ 
     					businessId:ids,
        	    	};
     	  	  
        	    	loadProcessHistoryInfo();
       }
    
    
    function toAdd(){
    	popWindow("<%=contextPath%>/wt/prointe/addHandle.jsp?id=",'800:680');
		queryData(cruConfig.currentPage);

 
    }
    
	function toEdit() {
		debugger;
		id = getSelIds("rdo_entity_id").split("-")[0];
		if (""==id) {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/wt/prointe/addHandle.jsp?id='+id,'800:680');
 	}
	
	function toDelete(){
		debugger;
		id = getSelIds("rdo_entity_id").split("-")[0];
		if (""==id) {
			alert("请选择一条记录!");
			return;
		}
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WtProinteSrv", "deleteHandle", "ids="+id);
			queryData(cruConfig.currentPage);
		}
		refreshData();
	}
 
	 
	   
 
	
	 
</script>
</html>