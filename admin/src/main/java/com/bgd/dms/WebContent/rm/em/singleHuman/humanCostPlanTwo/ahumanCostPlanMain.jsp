<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.bgp.mcs.service.common.CodeSelectOptionsUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>  
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>  
<%@ taglib uri="code" prefix="code"%> 


<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_Id = user.getProjectInfoNo();
 
	String projectType = user.getProjectType();
	String businessType_s="5110000004100000048";
	
	if(projectType.equals("5000100004000000008")){
		businessType_s="5110000004100001050";
	}
	
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String costState = request.getParameter("costState");
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
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
    			<td class="ali_cdn_name">单据状态</td>
			    <td  width="20%">
			    <select name="s_proc_status" id="s_proc_status" class="select_width" >
			    <option value="">请选择</option>
			    <option value="1">待审核</option>
			    <option value="3">审批通过</option>
			    <option value="4">审批不通过</option>
			    </select>			     
			    </td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='submitProcessInfo()'" title="JCDP_btn_submit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>	
			  	<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{plan_id}-{proc_status}-{cost_state}' id='rdo_entity_id_{plan_id}' onclick='chooseOne(this);doCheck(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd"  exp="<a href='#' onclick=view_page('{plan_id}','{cost_state}')><font color='blue'>{plan_no}</font></a>" >提交单号</td>
			      <td class="bt_info_even" exp="{apply_reason}">申请理由</td>
			      <td class="bt_info_odd"  exp="{employee_name}">创建人</td>
			      <td class="bt_info_even" exp="{modifi_dates}">提交日期</td>
			      <td class="bt_info_odd"  exp="{proc_status_name}">单据状态</td>
			      
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li> 
			    <li  id="tag3_1" ><a href="#" onclick="getTab3(1)">详细信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">审批流程</a></li>		    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
					<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		            <tr align="right" height="20">
		              <td>&nbsp;</td>
		              <td width="30"><span class="bc"><a href="#" onclick="toUpdateMain()"></a></span></td>
		              <td width="5"></td>
		            </tr>
		     	 </table>
		     	 
					<table  id="planME" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					<tr>
				     	<td class="inquire_item6">单号：</td>
				      	<td class="inquire_form6"> 
				      	<input type="hidden" id="plan_id" name="plan_id"   class="input_width" />
				      	<input type="text" id="plan_no" name="plan_no"   class="input_width" />
				       	</td>
				     	<td class="inquire_item6">项目名称：</td>
				      	<td class="inquire_form6">
				      	<input type="text" id="project_name" name="project_name"  style="width:280px;"  />
				      	 
				      	</td>
				      	
				     </tr>
					 <tr>
					    <td class="inquire_item6">提交人：</td>
				      	<td class="inquire_form6">
				      	<input type="text" id="submitUser" name="submitUser" class="input_width"   /> 
				      	</td>
				    	<td class="inquire_item6">提交日期：</td>
				      	<td class="inquire_form6">
				      	<input type="text" id="apply_date" name="apply_date"  style="width:280px;"    readonly="readonly"/>
				      	</td>
			     	</tr> 
			     	<tr>
			    	<td class="inquire_item6"><font color="red">*</font>申请理由：</td>
			      	<td class="inquire_form6" colspan="3"><textarea id="spare3" name="spare3" class="textarea"></textarea></td>
			         </tr>
		
				</table>
				</div>
					
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="mainF" id="mainF" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
 
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>				
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
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
	var org_subjection_idA="<%=orgSubjectionId%>";
	var costState = "<%=costState%>";
	var twoState = "1";
//	cruConfig.funcCode = "F_HUMAN_003";
	
	// 简单查询
	function simpleSearch(){
 
		var s_proc_status = document.getElementById("s_proc_status").value;

		var str = " 1=1 ";
 
		if(s_proc_status!=''){			
			str += " and proc_status like '"+s_proc_status+"%' ";						
		}
		cruConfig.cdtStr = str;
		refreshData();
	}
	
    
	function clearQueryText(){ 
 
		document.getElementById("s_proc_status").value="";
		cruConfig.cdtStr = "";
	}
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   
    
	
	function view_page(plan_id,cost_state){		
		if(plan_id != ""){
			window.location= "<%=contextPath%>/rm/em/singleHuman/humanCostPlanTwo/humanCostPlanManager.jsp?buttonN=1&planIds="+plan_id+"&costState="+cost_state;
		}
			
	}
	
	
	function refreshData(){

		cruConfig.queryStr = " select   c.cost_state ,decode(te.proc_status,  '1',  '待审批',  '3',  '审批通过',    '4',  '审批不通过',  te.proc_status) proc_status_name, c.plan_id,substr(c.apply_reason,0,32)apply_reason, e.employee_name,  p.project_name,to_char(c.modifi_date,'yyyy-mm-dd hh:ss')modifi_dates,c.modifi_date,c.project_info_no,  (select wmsys.wm_concat(i.org_abbreviation)  from gp_task_project_dynamic d  left join comm_org_information i  on d.org_id = i.org_id  and i.bsflag = '0'  where p.project_info_no = d.project_info_no  and d.bsflag = '0') org_name,  nvl(c.plan_no, '申请提交后系统自动生成') plan_no,   te.proc_status   from  bgp_comm_human_plan_cost c  left join gp_task_project p  on p.project_info_no = c.project_info_no     and p.bsflag = '0'     left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'  left join comm_human_employee e  on c.creator = e.employee_id  and e.bsflag = '0'      where   c.cost_state = '"+costState+"'  and c.bsflag = '0'  and c.spare5 = '1'  and c.project_info_no = '<%=project_Id%>'  order by c.modifi_date desc  ";
		cruConfig.currentPageUrl = "/rm/em/singleHuman/humanCostPlanTwo/ahumanCostPlanMain.jsp";
		queryData(1);
		//loadProcessHistoryInfo();
	}

	function toAdd(){
	// alert('<%=costState%>'); 
		  popWindow("<%=contextPath%>/rm/em/singleHuman/humanCostPlanTwo/addMainPage.jsp?projectInfoNo=<%=project_Id%>&costState="+costState);
		//var planId = jcdpCallService("HumanCommInfoSrv","saveHumanPlanCostTwo","projectInfoNo=<%=project_Id%>&costState=<%=costState%>&twoState=1");	
		 
		//window.location= "<%=contextPath%>/rm/em/singleHuman/humanCostPlanTwo/humanCostPlanManager.jsp?buttonN=1&planIds="+planId.planId+"&costState=<%=costState%>";
		
		
	}
	
	function toEdit(){
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
	    var proc_status=ids.split("-")[2];
		if(proc_status == '1' || proc_status == '3'){
			alert("该需求计划已提交,不能修改");
			return;
		}
 
		window.location= "<%=contextPath%>/rm/em/singleHuman/humanCostPlanTwo/humanCostPlanManager.jsp?buttonN=1&planIds="+ids.split("-")[1]+"&costState="+ids.split("-")[3];
		
	}
	

	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


function submitProcessInfo(){	
	ids = getSelectedValue();
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
    var id_s=ids.split("-")[1];
 
    var proc_status=ids.split("-")[2];
	if(proc_status == '1' || proc_status == '3'){
		alert("该需求计划已提交,不能重复提交");
		return;
	} 
 
	  popWindow('<%=contextPath%>/rm/em/singleHuman/humanCostPlanTwo/add_costPlanModify.jsp?buttionN=1&planId='+id_s,'900:700');
	}
	 

function toUpdateMain(){ 
	if(checkText0()){
		return;
	} 
	var spare3=document.getElementById("spare3").value;
	spare3 = encodeURI(spare3);
	spare3 = encodeURI(spare3);
	
	var plan_id=document.getElementById("plan_id").value;
	var planId = jcdpCallService("HumanCommInfoSrv","saveHumanPlanCostTwo","projectInfoNo=<%=project_Id%>&costState=<%=costState%>&twoState=1&plan_id="+plan_id+"&applyReason="+spare3);
	//var planId = jcdpCallService("HumanCommInfoSrv","submitSupplyHumanPlan","projectInfoNo=<%=project_Id%>&plan_id="+plan_id+"&shenText="+spare3);	
	if(planId.planId!=""){
	refreshData();
	alert("保存成功!");
	}
}

function checkText0(){
	var spare3=document.getElementById("spare3").value;
 
	if(spare3==""){
		alert("申请理由不能为空，请填写");
		return true;
	}
	return false;
}



    function loadDataDetail(ids){ 
    	  processNecessaryInfo={         
    	    		businessTableName:"bgp_comm_human_plan_cost",    //置入流程管控的业务表的主表表明
    	    		businessType:'<%=businessType_s%>',        //业务类型 即为之前设置的业务大类
    	    		businessId:ids.split("-")[1],         //业务主表主键值
    	    		businessInfo:"单项目人工成本计划流程",        //用于待审批界面展示业务信息
    	    		applicantDate:'<%=appDate%>'    //流程发起时间
    	    	
    	    	}; 
    	    	processAppendInfo={ 
    	    			id: ids.split("-")[1],
    	    			projectInfoNo:'<%=project_Id%>',
    	    			twoState:'1',
    	    			buttonView:"false",
    	    			projectName:'<%=user.getProjectName()%>'
    	    				
    	    	};    	
    	
    	document.getElementById("mainF").src = "<%=contextPath%>/rm/em/singleHuman/humanCostPlanTwo/add_costPlanModify.jsp?buttionN=0&planId="+ids.split("-")[1]; 
   	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[1];   	    
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[1];
   	
   	    loadProcessHistoryInfo(); 
		var querySql2 = "  select  c.apply_reason, c.cost_state ,decode(te.proc_status,  '1',  '待审批',  '3',  '审批通过',    '4',  '审批不通过',  te.proc_status) proc_status_name, c.plan_id, e.employee_name,  p.project_name,to_char(c.modifi_date,'yyyy-mm-dd hh:ss')modifi_dates,c.modifi_date,c.project_info_no,  (select wmsys.wm_concat(i.org_abbreviation)  from gp_task_project_dynamic d  left join comm_org_information i  on d.org_id = i.org_id  and i.bsflag = '0'  where p.project_info_no = d.project_info_no  and d.bsflag = '0') org_name,  nvl(c.plan_no, '申请提交后系统自动生成') plan_no,   te.proc_status   from  bgp_comm_human_plan_cost c  left join gp_task_project p  on p.project_info_no = c.project_info_no     and p.bsflag = '0'     left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'  left join comm_human_employee e  on c.creator = e.employee_id  and e.bsflag = '0'      where   c.cost_state = '"+costState+"'  and c.bsflag = '0'  and c.spare5 = '1'  and c.project_info_no = '"+ids.split("-")[0]+"'     and c.plan_id='"+ids.split("-")[1]+"'   ";
		var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=1&querySql='+querySql2);
		var datas2 = queryRet2.datas;
		
		if(datas2 != null && datas2 !=""){ 
			document.getElementById("plan_id").value=datas2[0].plan_id;
			document.getElementById("plan_no").value=datas2[0].plan_no;
			document.getElementById("project_name").value=datas2[0].project_name;
			document.getElementById("spare3").value=datas2[0].apply_reason;
			document.getElementById("submitUser").value=datas2[0].employee_name;
			document.getElementById("apply_date").value=datas2[0].modifi_dates;
			
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
	
function toDelete(){
		ids = getSelectedValue();
		//ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
	    var proc_status=ids.split("-")[2];
		if(proc_status == '1' || proc_status == '3'){
			alert("该需求计划已提交,不能删除");
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

		var sql = "update bgp_comm_human_plan_cost t set t.bsflag='1' ,t.spare5='1'  where t.plan_id ='"+ids.split("-")[1]+"' ";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		//把根据plan_id主键把子表信息也删除  
		
		
		var sql2 = "update bgp_comm_human_cost_plan t set t.bsflag='1' ,t.spare5='1'  where t.plan_id ='"+ids.split("-")[1]+"' ";
		var path2 = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params2 = "deleteSql="+sql2;
		params2 += "&ids="+ids;
		var retObject = syncRequest('Post',path2,params2); 
		  
		var querySql1 = " select t.plan_deta_id,d.coding_name employee_gz_name from bgp_comm_human_cost_plan_deta t left join comm_coding_sort_detail d on t.employee_gz=d.coding_code_id left join bgp_comm_human_plan_cost c on t.plan_id=c.plan_id and c.cost_state='<%=costState%>' and c.bsflag='0' and c.spare5='1' where t.spare5='1' and t.bsflag='0'  and c.plan_id='"+ids.split("-")[1]+"'";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		if(datas1 != null){	 
		     for (var i = 0; i< queryRet1.datas.length; i++) {    
 				var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
   				var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PLAN_DETAIL&JCDP_TABLE_ID='+datas1[i].plan_deta_id +'&bsflag=1&modifi_date=<%=appDate%>';
   			    syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));  //提交人员调配单是同时更新 人员表中的 调配状态“已调配”		
 
		     } 
		}
		 
		refreshData();


	}
	
	
</script>
</html>