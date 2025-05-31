<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
	String	projectType=request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String signle = request.getParameter("signle")==null?"":request.getParameter("signle");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<title>人工成本补充计划</title> 
</head> 
 
<body style="background:#fff" onload="refreshData();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
		  	  <td width="80%">&nbsp;&nbsp;<b><label id="labelName" name="labelName" ></label></b></td>
				<%if("".equals(signle)){%>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="添加理由"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
				<%if("5000100004000000009".equals(projectType)){%>
				<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="下载模板"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="导入"></auth:ListButton>							
				<%}%>
				<auth:ListButton functionId="" css="jl" event="onclick='toModifyDetail()'" title="查看明细"></auth:ListButton>
				<%}%>

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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{plan_id}' id='rdo_entity_id_{plan_id}' onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd"  exp="<a href='#' onclick=view_page('{plan_id}')><font color='blue'>{plan_no}</font></a>" >提交单号</td>
			      <td class="bt_info_even" exp="{apply_reason}">申请理由</td>
			      <td class="bt_info_odd"  exp="{employee_name}">创建人</td>
			      <td class="bt_info_even" exp="{modifi_dates}">提交日期</td>
			      
			     </tr> 			        
		    </table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
	</div>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var costState = "1";
var projectType = "<%=projectType%>";

var querySqlON = "    select project_name  from gp_task_project where project_info_no='<%=projectInfoNo%>' and bsflag='0' ";
var queryRetON = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+querySqlON);		
var datas = queryRetON.datas;
if(datas != null && datas != ''){
	document.getElementById("labelName").innerText=datas[0].project_name; 
}

function refreshData(){
	cruConfig.queryStr = "select c.cost_state,c.plan_id,substr(c.apply_reason,0,32)apply_reason,e.employee_name,p.project_name,to_char(c.modifi_date,'yyyy-mm-dd hh:ss')modifi_dates,c.modifi_date,c.project_info_no,"+
			"(select wmsys.wm_concat(i.org_abbreviation) "+
				"from gp_task_project_dynamic d left join comm_org_information i on d.org_id = i.org_id and i.bsflag = '0' "+
				"where p.project_info_no = d.project_info_no  and d.bsflag = '0') org_name,nvl(c.plan_no, '申请提交后系统自动生成') plan_no "+
		"from bgp_comm_human_plan_cost c  left join gp_task_project p  on p.project_info_no = c.project_info_no  and p.bsflag = '0' "+
		"left join comm_human_employee e  on c.creator = e.employee_id  and e.bsflag = '0' "+
		"where c.cost_state = '"+costState+"' and c.bsflag = '0' and c.spare5 = '1'  and c.project_info_no ='<%=projectInfoNo%>' "+
		"order by c.modifi_date desc  ";
	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanCostPlan/humanCostPlanSupplyList.jsp";
	queryData(1);
}

function toAdd(){
	popWindow("<%=contextPath%>/rm/em/singleHuman/humanCostPlan/add_humanCostSupplyMain.jsp?projectInfoNo=<%=projectInfoNo%>");
}


function view_page(plan_id){		
	if(plan_id != ""){
		if(projectType == "5000100004000000009"){
			window.location= "<%=contextPath%>/rm/em/singleHuman/humanCostPlan/humanCostPlanSupplyManagerZh.jsp?projectType=<%=projectType%>&projectInfoNo=<%=projectInfoNo%>&signle=<%=signle%>&planIds="+plan_id+"&costState="+costState;
			
		}else{
		window.location= "<%=contextPath%>/rm/em/singleHuman/humanCostPlan/humanCostPlanSupplyManager.jsp?projectInfoNo=<%=projectInfoNo%>&signle=<%=signle%>&planIds="+plan_id+"&costState="+costState;
		}
	}
}

function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");   
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
} 

function toModifyDetail(){
	ids = getSelIds('rdo_entity_id');
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	this.view_page(ids.split("-")[1]);
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
	var sql = "update bgp_comm_human_plan_cost t set t.bsflag='1' ,t.spare5='1'  where t.plan_id ='"+ids.split("-")[1]+"' ";
	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids="+ids;
	var retObject = syncRequest('Post',path,params);
	//把根据plan_id主键把子表信息也删除  
	var sql2 = "update bgp_comm_human_cost_plan_sala t set t.bsflag='1' ,t.spare5='1'  where t.plan_id ='"+ids.split("-")[1]+"' ";
	var path2 = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params2 = "deleteSql="+sql2;
	params2 += "&ids="+ids;
	var retObject = syncRequest('Post',path2,params2); 
	refreshData();
}


function toDownload(){
	var elemIF = document.createElement("iframe");  
	var iName ="综合人工成本补充计划";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	
	elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanCostPlan/hcostPlans.xlsx&filename="+iName+".xlsx";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

function importData(){ 
	popWindow('<%=contextPath%>/rm/em/singleHuman/humanCostPlan/humanCPlanIFileZhs.jsp?costState=1&projectType=<%=projectType%>&projectInfoNo=<%=projectInfoNo%>','700:600');
	
}

</script>
</body>
</html>