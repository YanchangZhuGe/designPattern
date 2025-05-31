<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = (String)user.getOrgId();
	String org_subjection_id = (String)user.getSubOrgIDofAffordOrg();
	String user_id = (String)user.getUserId();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = request.getParameter("project_info_no") != null ? request.getParameter("project_info_no"):"";

	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
  
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/iframeTools.js"></script>
<script type="text/javascript" >
cruConfig.contextPath =  "<%=contextPath%>";

$(function() {
	$("#chk_all").click(function(){
		if($("#chk_all").attr("checked") == "checked"){
	    	$("input[name='chk_entity_id']").attr("checked","checked");
		}
		else{
	    	$("input[name='chk_entity_id']").removeAttr("checked");
		}
	});
});

function refreshData(exploration_method,proc_status){ 
	var key=$("#expName").val();
	 exploration_method = key.split("_")[1];
	 proc_status=$("#procStatus").val();
	createTd();
		var str = "select zb.STATUS as proc_status,zb.EXPLORATION_METHOD, zb.DAILY_GPS_CONTROL_POINT, zb.DAILY_COORDINATE_POINT, zb.DAILY_MEASUREMENT_POINT, zb.DAILY_TERRAIN_CORRECT_POINT, zb.DAILY_TC_CHECK_POINT, zb.DAILY_WORKLOAD, zb.DAILY_BASIC_POINT, zb.DAILY_CHECK_POINT, zb.DAILY_REWORK_POINT, zb.DAILY_FIRST_GRADE, zb.DAILY_CONFORMING_PRODUCTS, zb.DAILY_NON_CONFORMING_PRODUCTS, zb.DAILY_NULL_POINT, zb.DAILY_BASE_STATION, zb.DAILY_WELL_SOUNDING_POINT, zb.DAILY_GRAVITY_DATUM_POINT, zb.DAILY_MAGNETISM_BASE_STATION, zb.DAILY_PHYSICAL_POINT, zb.PRODUCE_DATE, zb.DAILY_FIRST_RATIO, zb.VSP_TEAM_NO, zb.DAILY_REPORT_ID, zb.DAILY_INSTRUMENT_USE, zb.DAILY_INSTRUMENT_ALL, zb.TASK_STATUS, zb.UPLOAD_FILE_UCMDOCID, zb.FILE_NAME,"
			+" wt.DAILY_NO_WT, wt.PROJECT_INFO_NO, wt.ORG_ID, wt.AUDIT_STATUS, wt.AUDIT_DATE, wt.RATIFIER, wt.WEATHER, wt.IF_BUILD, wt.STOP_REASON, wt.PAUSE_REASON ,"
			+" qe.BUG_CODE,qe.BUG_NAME,qe.Q_DESCRIPTION,qe.RESOLVENT ,substr(qe.Q_DESCRIPTION,0,8) as q_d ,"
			+"team.ORG_ABBREVIATION "
			+" from GP_OPS_DAILY_REPORT_ZB zb "
			+" left join GP_OPS_DAILY_REPORT_WT wt on wt.DAILY_NO_WT=zb.DAILY_NO_WT and wt.BSFLAG='0'"
			+" left join GP_OPS_DAILY_QUESTION qe on qe.DAILY_REPORT_ID=zb.DAILY_REPORT_ID and qe.BSFLAG='0'"
			+" left join COMM_ORG_INFORMATION team on team.ORG_ID=zb.VSP_TEAM_NO and team.BSFLAG='0' "
			+" where zb.BSFLAG='0' and zb.PROJECT_INFO_NO='<%=projectInfoNo%>' ";
			if(exploration_method!=""&&exploration_method!=null){
				str = str+" and zb.EXPLORATION_METHOD='"+exploration_method+"'"
			}
			if(proc_status==""||proc_status==null){
				str = str+" and zb.STATUS='1'"
			}else{
				str = str+" and zb.STATUS='"+proc_status+"'"
			}
		cruConfig.queryStr = str+"  order by zb.produce_date asc";
		queryData(cruConfig.currentPage);
}

function tosubmit(status){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
	var retObj = jcdpCallService("WtDailyReportSrv", "submitDailyReportWt", "daily_report_ids="+ids+"&status="+status);
	if(retObj.message=='success'){
		alert("成功");
	}	
	searchDevData();
}
function loadDataDetail(ids){

}

function searchDevData(){
	var key=$("#expName").val();
	var exploration_method = key.split("_")[1];
	var proc_status=$("#procStatus").val();
	refreshData(exploration_method,proc_status);
}
var if_build_ = new Array(
		["",""],["1","动迁"],["2","踏勘"],["3","建网"],["4","培训"],["5","试验"],["6","采集"],["7","整理"],["8","验收"],["9","遣散"],["10","归档"],["11","停工"],["12","暂停"],["13","结束"]
	);
var weather_ = new Array(
		["",""],["1","晴"],["2","阴"],["3","多云"],["4","雨"],["5","雾"],["6","霾"],["7","霜冻"],["8","暴风"],["9","台风"],["10","暴风雪"],["11","雪"],["12","雨夹雪"],["13","冰雹"],["14","浮尘"],["15","扬沙"],["16","其它"],["17","大风"]
	);
var task_status_ = new Array(
		["",""],["1","采集"],["2","停工"],["3","暂停"],["4","结束"]
	);
var pause_stop_reason_ = new Array(
		["",""],["1","仪器因素"],["2","人员因素"],["3","气候因素"],["4","工农协调因素"],["5","油公司因素"],["6","其它"]
	);
var status_ = new Array(
		["",""],["Not Started","未开始"],["In Progress","正在进行"],["Completed","完成"]
	);
var bug_code_ = new Array(
		["",""],["5000100005000000001","人员"],["5000100005000000002","物资"],["5000100005000000003","设备"],["5000100005000000004","HSE"],["5000100005000000005","后勤"],["5000100005000000006","工农、社区关系"],["5000100005000000007","技术"],
		["5000100005000000008","生产"],["5000100005000000009","甲方信息"],["5000100005000000010","自然因素"],["5000100005000000011","质量"],["5000100005000000012","财务经营"],["5000100005000000013","其它"]
	);
var proc_status_ = new Array(
		["1","待审批"],["3","审批通过"],["4","审批不通过"]
	);                                                                                                                                               

function xiangQ(q_d){
	var content = $("#"+q_d).val();
	 art.dialog({
		 id:'KDf435',
		 left:200,
		 opacity: 0.87,
		    padding: 0,
		    width: '300',
		    height: 80,
		    title: '详细信息',
		    content: content   
		});
}
function dd(){
	art.dialog.list['KDf435'].close();
}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff"  onload="refreshData();frameSize()" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="ali_cdn_name">勘探方法：</td>
			 	    <td class="ali_cdn_input"><select id="expName" onchange="searchDevData()"></select></td>					
			 	    <td class="ali_cdn_name">审批状态：</td>
			 	    <td class="ali_cdn_input">
			 	    <select id="procStatus" onchange="searchDevData()">
			 	    	<option value="1" selected="selected">待审批</option>
			 	    	<option value="3">审批通过</option>
			 	    	<option value="4">审批不通过</option>
			 	    </select></td>
			 	    <td>&nbsp;</td>
			 	    <auth:ListButton functionId="" css="tj" event="onclick='tosubmit(3)'" title="审批通过"></auth:ListButton>
			 	    <auth:ListButton functionId="" css="gb" event="onclick='tosubmit(4)'" title="审批不通过"></auth:ListButton>  
				</tr>
			</table>
				</td>
				 <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	</div>
	<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr id="dailyTr">		
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{daily_report_id}' id='chk_entity_id' />" ><input id="chk_all" type="checkbox" value=""/></td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="{produce_date}">日期</td>
			  	<td class="bt_info_odd" exp="{if_build}" func="getOpValue,if_build_">项目状态</td>
			  	<td class="bt_info_odd" exp="{weather}" func="getOpValue,weather_">天气情况</td>
			  	<td class="bt_info_odd" exp="{org_abbreviation}">施工小队</td>
			  	<td class="bt_info_odd" exp="{task_status}" func="getOpValue,task_status_">采集状态</td>
			  	<td class="bt_info_odd" exp="{stop_reason}" func="getOpValue,pause_stop_reason_">停工，暂停原因</td>
			  	<!--<td class="bt_info_odd" exp="{status}">任务状态</td>-->
			  	<td class="bt_info_odd" exp="{daily_instrument_use}">在用仪器</td>
			  	<td class="bt_info_odd" exp="{daily_instrument_all}">总计仪器</td>
			  	<td class="bt_info_odd" exp="{bug_code}" func="getOpValue,bug_code_">问题分类</td>
			  	<td class="bt_info_odd" exp="<input id='q_d_{daily_report_id}' type='hidden' value='{q_description}'/><span style='cursor:hand' onmouseout=dd() onmouseover=xiangQ('q_d_{daily_report_id}')>{q_d}</span> ">问题描述</td>
			  	<td class="bt_info_odd" exp="{resolvent}">解决方案</td>
			  	<td class="bt_info_odd" exp="{daily_coordinate_point}">坐标点</td>
			  	<td class="bt_info_odd" exp="{daily_physical_point}">物理点</td>
			  	<td class="bt_info_odd" exp="{daily_check_point}">检查点</td>

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
<script type="text/javascript">
var querySql="select mp.ACTIVITY_OBJECT_ID,mp.EXPLORATION_METHOD,de.CODING_NAME from bgp_activity_method_mapping mp "
	+"left join COMM_CODING_SORT_DETAIL de on de.CODING_CODE_ID=mp.EXPLORATION_METHOD and de.BSFLAG='0' "
	+"where mp.PROJECT_INFO_NO='<%=projectInfoNo%>' and mp.BSFLAG='0' and mp.EXPLORATION_METHOD!='5110000056000000045'";

var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
var datas = queryRet.datas;
if(datas!=null){
	for(var i=0;i<datas.length;i++){
		var activity_object_id = datas[i].activity_object_id;
		var exploration_method = datas[i].exploration_method;
		var name = datas[i].coding_name;
		if(i==0){
		      $("#expName").append("<option value='"+activity_object_id+"_"+exploration_method+"' selected='selected'>"+name+"</option>");   
		}else{
		      $("#expName").append("<option value='"+activity_object_id+"_"+exploration_method+"'>"+name+"</option>");   
		}
	}
}
//createTd();
var trCid="";

function createTd(){

	var key=$("#expName").val();
	var activity_object_id = key.split("_")[0];
	var tdRetObj = jcdpCallService("WtDailyReportSrv", "exportDailyTableTitleWt", "project_info_no=<%=projectInfoNo%>&activity_object_id="+activity_object_id);
	var tdData = tdRetObj.tdList;

	if(trCid!=""){
		var trCids = trCid.split(",");
		for(var i=0;i<trCids.length;i++){
			if(trCids[i]!=""){
				$("#"+trCids[i]).remove();
			}
		}
	}
	$("#status").remove();
	
	if(tdData!=null){
		for(var y=0;y<tdData.length;y++){
			var tdMap = tdData[y];
			var tdExp = tdMap.coloum;
			var tdName = tdMap.name;		
			trCid+="Custom"+y+",";
		   var tdStr='<td id="Custom'+y+'" class="bt_info_odd" exp="{'+tdExp+'}">'+tdName+'</td>';
			$("#dailyTr").append(tdStr);
		}	
	}
	   var tdstauts='<td id="status" class="bt_info_odd" exp="{proc_status}" func="getOpValue,proc_status_">审批状态</td>';
	   
		$("#dailyTr").append(tdstauts);
	
			
}

function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
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

</body>
</html>
