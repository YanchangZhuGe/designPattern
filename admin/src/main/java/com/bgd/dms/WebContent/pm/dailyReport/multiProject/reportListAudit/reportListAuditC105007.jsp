<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page  import="java.net.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	String orgSubjectionId = "C105";
	UserToken user = OMSMVCUtil.getUserToken(request);
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	String project_info_no = request.getParameter("project_info_no") != null ? request.getParameter("project_info_no"):"";
	String project_name = request.getParameter("projectName") != null ? request.getParameter("projectName"):"";
	if(project_name != ""){
		project_name = URLDecoder.decode(project_name,"UTF-8");
	}
	String exploration_method = user.getExplorationMethod();
	System.out.print(exploration_method);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td><b><%=project_name %></b>&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton tdid="tj" functionId="" css="tj" event="onclick='audit(3)'" title="JCDP_btn_audit"></auth:ListButton>
		    	<auth:ListButton tdid="gb" functionId="" css="gb" event="onclick='audit(4)'" title="JCDP_btn_audit"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no},{daily_no},{produce_date}' id='rdo_entity_id_{daily_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{produce_date}<input type='hidden' name='audit_status_{daily_no}' id='audit_status_{daily_no}' value='{audit_status}'/>" >施工日期</td>
			      <td class="bt_info_even" exp="{daily_sp}" >日完成炮数</td>
			      <td class="bt_info_odd" exp="{daily_workload}" >日完成工作量</td>			
			      <td class="bt_info_even" exp="{total_sp}" >累计完成炮数</td>
	 
			        <%
			      if(exploration_method.equals("0300100012000000002")){
			    	  %>
			    	    <td class="bt_info_odd" exp="{total_workload} km"  align="center" >累计完成工作量(km)</td>
			   	  <%
			      }else{
			    	  %>
			    	    <td class="bt_info_odd" exp="{total_workload} km²"   align="center" >累计完成工作量(km²)</td>
		
			     <%
			      }
			      %>
			      <td class="bt_info_even" exp="{radio}%" >项目完成进度%</td>
			      <td class="bt_info_odd" exp="{audit_status}" func="getOpValue,audit_status1">审批状态</td>
			      <td class="bt_info_even" exp="<a href='#'  onclick=openGis('{project_info_no}')>查看</a>" >日报进度图</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
		  </div>

</body>
<script type="text/javascript">

var audit_status1 = new Array(['0','未提交'],['1','待审批'],['2',''],['3','审批通过'],['4','审批不通过']);

function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
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
	var orgSubjectionId = "<%=orgSubjectionId %>";
	var projectInfoNo = "<%=project_info_no%>";
	cruConfig.queryService = "";
	cruConfig.queryOp = "";
	
	// 复杂查询
	function refreshData(){
		cruConfig.queryStr = " with daily_report as(select t.produce_date ,sum(nvl(daily_jp_acquire_shot_num,0)+nvl(daily_qq_acquire_shot_num,0)+nvl(daily_acquire_sp_num,0)) daily_sp,"+
		" sum(nvl(daily_qq_acquire_workload,0)+nvl(daily_jp_acquire_workload,0)+nvl(daily_acquire_workload,0)) daily_workload,t.project_info_no,"+
		" t.daily_no,t.audit_status  from gp_ops_daily_report t where t.bsflag ='0' and (t.audit_status = '1' or t.audit_status = '3')"+
		" and t.project_info_no ='<%=project_info_no%>' group by t.produce_date,t.project_info_no,t.daily_no,t.audit_status order by t.produce_date desc )"+
		" select dd.*,case nvl(design_workload,0) when 0 then 0 else round(nvl(total_workload,0)/nvl(design_workload,0)*10000)/100.0 end radio"+
		" from( select d.*,(select sum(r.daily_sp) from daily_report r where r.produce_date <= d.produce_date) total_sp,"+
		" (select sum(r.daily_workload) from daily_report r where r.produce_date <= d.produce_date) total_workload,"+
		" case pd.exploration_method when '0300100012000000003' then (case pd.work_load3 when '3' then pd.design_object_area"+
		" when '2' then pd.design_data_area else pd.design_execution_area end) else (case pd.work_load2 when '3' then pd.design_object_workload"+
		" when '2' then pd.design_data_workload else pd.design_physical_workload end) end design_workload"+
		" from daily_report d left join gp_task_project_dynamic pd on d.project_info_no = pd.project_info_no and pd.bsflag ='0')dd order by dd.produce_date desc";
		queryData(1);
	}

	refreshData();
	// 简单查询
	function simpleRefreshData(){
		refreshData();
	}
	
	function loadDataDetail(id){
		//var ids = getSelIds('rdo_entity_id');
	    if(id==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    
	    var idss = id.split(",");
	    var ids = idss[0];
	    var ids1 = idss[1];
	    var ids2 = idss[2];
	}
	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");


	function toDelete(){

		var dailyNos = "";
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    
	    var params = ids.split(',');
	    var flag = true;
	    var i=1;
	    while(flag){
	    	dailyNos = dailyNos+","+params[i];
	    	var audit_status = document.getElementById("audit_status_"+params[i]).value;
		    if(audit_status == "3"){
		    	alert("有已经审批通过的，不能删除！");
		    	return;
		    }
	    	
	    	i=i+3;
	    	if(i > params.length){
	    		flag = false;
	    	}
	    }
	    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("DailyReportSrv", "deleteDailyReport", "dailyNos="+dailyNos.substr(1));
			queryData(cruConfig.currentPage);
		}
		
	}
	
	function dbclickRow(ids){
		var idss = ids.split(",");
	    var ids = idss[0];
	    var ids1 = idss[1];
	    var ids2 = idss[2];
	    var querySql = "select d.org_subjection_id from gp_task_project t join gp_task_project_dynamic d on t.project_info_no = d.project_info_no"+
	    	" where t.bsflag ='0' and d.bsflag ='0' and t.project_info_no ='<%=project_info_no%>'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode =='0' && retObj.datas[0]!=null){
			var org_subjection_id = retObj.datas[0].org_subjection_id == null?"":retObj.datas[0].org_subjection_id;
			if(org_subjection_id!=null && org_subjection_id.indexOf("C105007")!=-1){//如果是大港物探处
				open('<%=contextPath%>/pm/dailyReport/multiProject/viewDailyReportC105007.jsp?daily_no='+ids1+'&project_info_no='+ids+'&produce_date='+ids2);
			}else{
				popWindow('<%=contextPath%>/pm/dailyReport/multiProject/viewDailyReport.jsp?daily_no='+ids1+'&project_info_no='+ids+'&produce_date='+ids2,'1280:800');
			}
		}
	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/dailyReport/multiProject/daily_search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	// 审批日报
	function audit(audit_status){
		//debugger;
		var dailyNos = "";
	    row_data_str = getSelIds('rdo_entity_id');
	    if(row_data_str==''){ alert("请先选中一条记录!");
	     	return;
	    }else{
	    	var row_data = row_data_str.split(",") ;
		    var projectInfoNo = row_data[0] ;
		    var dailyNo = row_data[1] ;
		    var produceDate = row_data[2] ; 	
		    var retObj = jcdpCallService("DailyReportSrv", "getDailyReportInfo", "dailyNo="+dailyNo+"&projectInfoNo="+projectInfoNo+"&produceDate="+produceDate);
		    var if_build = retObj.dailyMap.IF_BUILD ; 	
			var audit_status_tmp = retObj.dailyMap.AUDIT_STATUS ;	//审批状态  
			if( !strIsNullOrEmpty(audit_status_tmp) ){
				if( audit_status_tmp=="1" || audit_status_tmp=="2" ){		/* 审批状态 处于“待审批”和“审批中的”的前提下，可以审批 */
					var retObj = jcdpCallService("DailyReportSrv", "auditDailyReport", "dailyNo="+dailyNo+"&projectInfoNo="+projectInfoNo+"&produceDate="+produceDate+"&audit_status="+audit_status+"&if_build="+if_build);
					queryData(cruConfig.currentPage);	//审批后刷新数据
				}else{	/* 审批状态 处于“修订（尚未提交）”、“审批通过”和“审批不通过”的前提下，不能审批 */
					var msg="";
					if(audit_status_tmp=="0"){
						msg="该日报尚未提交！";
					}else if(audit_status_tmp=="3"){
						msg="该日报已审批通过！";
					}else if(audit_status_tmp=="4"){
						msg="该日报审批未通过！";
					}
					if(msg!=""){
						alert(msg);
					}
				}
			}
	    }
	}
	
	function openGis(projectInfoNo){
		popWindow("http://10.21.8.26/GeoCreator/Templete.html?projNo=8ad8827334181c0e01341ce0874300d6&time=2012-10-25&spType=cj&upstate=true&orgid=C6000000000001&orgsubid=C105&url=10.88.2.240:80","1280:800");
	}
	
	//测试函数
	function alertmsg(){
		alert("222222");
	}
	
</script>

</html>

