<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String[][] infos = {
			  {"F_PM_WR_002","落实收入价值工作量","BGP_WR_WORKLOAD_INFO","bsflag='0'"},
			  {"F_PM_WR_022","非地震落实收入价值工作量","BGP_WR_WORKLOAD_INFO","bsflag='0'"},
			  {"F_PM_WR_023","非采集落实收入价值工作量","BGP_WR_WORKLOAD_INFO","bsflag='0'"},
			  {"F_PM_WR_013","项目情况","bgp_wr_acq_project_info","bsflag='0'"},
			  {"F_PM_WR_024","VSP采集项目情况","bgp_wr_acq_project_info","bsflag='0'"},
			  {"F_PM_WR_014","公司重点项目动态","bgp_wr_stress_project_info","bsflag='0'"},
			  {"F_PM_WR_015","公司勘探船只动态","bgp_wr_sail_info","bsflag='0'"},
			  {"F_PM_WR_016","地震采集项目运行动态","BGP_WR_PROJECT_DYNAMIC","bsflag='0' and project_type='1'"},
			  {"F_PM_WR_017","VSP项目运行动态","BGP_WR_PROJECT_DYNAMIC","bsflag='0' and project_type='2'"},
			  {"F_PM_WR_008","非地震项目运行动态","BGP_WR_PROJECT_DYNAMIC","bsflag='0' and project_type='3'"},
			  {"F_PM_WR_004","处理解释项目运行动态","BGP_WR_PROJECT_DYNAMIC","bsflag='0' and project_type='4'"},
			  {"F_PM_WR_006","技术支持情况","BGP_WR_HOLD_INFO","bsflag='0'"},
			  {"F_PM_WR_009","主要地震仪器情况（海上和辽河）","BGP_WR_INSTRUMENT_INFO","bsflag='0'"},
			  {"F_PM_WR_010","主要地震仪器情况","BGP_WR_INSTRUMENT_INFO","bsflag='0'"},
			  {"F_PM_WR_011","国际可控震源情况","BGP_WR_FOCUS_INFO","bsflag='0' and country='2'"},
			  {"F_PM_WR_012","国内测量仪器及可控震源情况","BGP_WR_FOCUS_INFO","bsflag='0'"},
			  {"F_PM_WR_020","检波器情况","bgp_geophone_info","bsflag='0'"},
			  {"F_PM_WR_007","物资供应动态","bgp_wr_material_info","bsflag='0'"}
	};
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>生产周报列表页面</title>
<script language="javaScript">
var pageTitle = "非地震项目情况";
cruConfig.contextPath =  "<%=contextPath%>";

var substatus = new Array(
['0','未提交'],[2,'待审批'],['1','审批通过'],['3','审批不通过']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height());
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


    function toAdd(){
    	window.location='selectWeek.jsp';
    }
    
  	function toEdit(){
  		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');

	    var org_id = tempa[0];
	    var week_date = tempa[1];
	    var subflag = tempa[2];
	    var week_end_date = tempa[3];
	    	    
	    if(subflag == '0' || subflag == '3'){
	    	window.location = "editIndex.jsp?org_id="+org_id+"&week_date="+week_date+"&week_end_date="+week_end_date+"&action=edit";
	    }else{
	    	alert("该记录已经提交或者审批通过，不能修改!"); 
	    	return; 
	    }
	    
	}
	
  	function toDelete(){
  		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');

	    var org_id = tempa[0];
	    var week_date = tempa[1];
	    var subflag = tempa[2];
	    
	    if(subflag == '0'){
	    	var sql = "update bgp_wr_record set bsflag='1' where create_org_id='<%=user.getOrgId()%>' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
	    	<%
			for(int i=0;i<infos.length;i++){
				if(JcdpMVCUtil.hasPermission(infos[i][0], request)){
					if(infos[i][0].equals("F_PM_WR_007")){// 物资供应数据，需要用组织机构隶属id去like当前用户隶属ID查询
			%>
			sql +="update <%=infos[i][2]%> set bsflag='1' where <%=infos[i][3]%>  and org_subjection_id like '<%=user.getSubOrgIDofAffordOrg()%>%25' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
			<%      }else{%>
			sql +="update <%=infos[i][2]%> set bsflag='1' where <%=infos[i][3]%>  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
			<%
					}
				}
			}
			%>
			deleteEntities(sql);
	    }else{
	    	alert("该记录已经提交或者审批，不能删除!"); 
	    	return; 
	    }
	    	    
	}
	
	function JcdpButton3OnClick(){
		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');
	    var org_id = tempa[0];
	    var week_date = tempa[1];
	    var subflag = tempa[2];
	    var week_end_date = tempa[3];
	    var record_id = tempa[4];
	    var week_num = tempa[5];
	    var create_org_name = tempa[6];
	    	    
	    
	    if(subflag == '0' || subflag=='3'){
	    	 // 检查相关的数据，是否都已经录入
		    /*
		    var checkSql="";
		    var queryRet;
		    var datas;
	    	<%
			for(int i=0;i<infos.length;i++){
				if(JcdpMVCUtil.hasPermission(infos[i][0], request)){
					if(infos[i][0].equals("F_PM_WR_007")){// 物资供应数据，需要用组织机构隶属id去like当前用户隶属ID查询
			%>
			checkSql="select count(*) as datas_length from <%=infos[i][2]%> where <%=infos[i][3]%>  and instr(org_subjection_id,'<%=user.getSubOrgIDofAffordOrg()%>')>0 and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			<%      }else{%>
			checkSql="select count(*) as datas_length from <%=infos[i][2]%> where <%=infos[i][3]%>  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			<%
					}
			%>
			queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			datas = queryRet.datas;
			if(!datas || !datas[0] || datas[0].datas_length==0){
			    alert("<%=infos[i][1]%>没有录入，不能提交");
			    return;
			}
			
			<%
				}
			}
			%>
		    */			
		    var applyType='wrAudit';
		    var audit_url="/pm/wr/getWeekPrintAudit.srq";
		    var view_url="/pm/wr/getWeekPrintView.srq";

		    var submitStr='proc_view_url='+view_url
		    +'&proc_audit_url='+audit_url
		    +'&proc_applyType='+applyType
		    +'&proc_id='+record_id
		    +'&proc_tableName=bgp_wr_record&proc_tableKeyName=record_id&proc_tableKeyValue='+record_id
		    +'&proc_recordId='+record_id
		    +'&proc_week_date='+week_date
		    +'&proc_week_end_date='+week_end_date
		    +'&proc_create_org_name='+create_org_name
		    +'&proc_busKey=wrAudit';

			submitStr+='&businessId=37';
			submitStr = encodeURI(submitStr);
			submitStr = encodeURI(submitStr);

  			var result = jcdpCallService('workFlowSrv','startExamine',submitStr); 
  			if(result.returnCode=="0"){
  			    // 准备提交数据
  		    	var sql = "update bgp_wr_record set subflag='2' where create_org_id='<%=user.getOrgId()%>' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
  		    	<%
  				for(int i=0;i<infos.length;i++){
  					if(JcdpMVCUtil.hasPermission(infos[i][0], request)){
  						if(infos[i][0].equals("F_PM_WR_007")){// 物资供应数据，需要用组织机构隶属id去like当前用户隶属ID查询
  				%>
  				sql +="update <%=infos[i][2]%> set subflag='2' where <%=infos[i][3]%>  and instr(org_subjection_id,'<%=user.getSubOrgIDofAffordOrg()%>')>0 and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
  				<%      }else{%>
  				sql +="update <%=infos[i][2]%> set subflag='2' where <%=infos[i][3]%>  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
  				<%
  						}
  					}
  				}
  				%>
 				//updateEntitiesBySql(sql,"提交");
 				
 				if (!window.confirm("确认要提交吗?")) {
 						return;
 				}
 				var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
 				var params = "sql="+sql;
 				params += "&ids="+ids;
 				var retObject = syncRequest('Post',path,params);
 				if(retObject.returnCode!=0) alert(retObject.returnMsg);
 				else queryData(cruConfig.currentPage);
 				
 				alert("提交成功");
  				queryData(cruConfig.currentPage);
  			}else{
  				alert("提交失败");
  			}
  			
	    }else if(subflag == '2'){
	    	alert("该记录已经提交，不能再次提交!"); 
	    	return; 
	    }else if(subflag == '1'){
	    	alert("该记录审批通过，不能再次提交!"); 
	    	return; 
	    }
	    
	}

function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "select distinct d.record_id,   d.proc_status, decode(d.proc_status,'1', '待审核','3', '审核通过', '4','审核不通过', '未提交') proc_status_name,o.org_name as create_org_name,d.week_date,d.week_end_date,d.week_num,d.subflag,d.org_id,d.create_org_id from BGP_WR_RECORD d,comm_org_information o where d.create_org_id=o.org_id and d.bsflag='0' and d.create_org_subjection_id = '<%=user.getOrgSubjectionId()%>' order by week_date desc";
	queryData(1);
}

var fields = new Array();
fields[0] = ['week_date','周报日期','D'];
fields[1] = ['subflag','状态','TEXT',,,'SEL_OPs',substatus];
	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}


function cmpQuery(){
	var qStr = generateCmpQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function classicQuery(){
	var qStr = generateClassicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+JSON.stringify(rowParams);
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}

</script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body onload="page_init()" style="background:#fff">
<div id="list_table">
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali3">周报开始日期</td>
    <td class="ali1"><input id="week_date" name="week_date" type="text"  onkeypress="simpleRefreshData()"/></td>
    <td>&nbsp;</td>
    <!--  <td><span class="gl"><a href="#" onclick="toSearch()" title="JCDP_btn_query"></a></span></td> -->
    <td><span class="zj"><a href="#" onclick="toAdd()" title="JCDP_btn_add"></a></span></td>
    <td><span class="xg"><a href="#" onclick="toEdit()" title="JCDP_btn_edit"></a></span></td>
    <td><span class="sc"><a href="#" onclick="toDelete()" title="JCDP_btn_delete"></a></span></td>
    <td><span class="tj"><a href="#" onclick="JcdpButton3OnClick()" title="JCDP_btn_submit"></a></span></td>
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>

<div id="table_box">
<table border="0"  cellspacing="0"  cellpadding="0"  class="tab_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="bt_info_odd" 	 exp="<input type='radio' name='chx_entity_id' value='{org_id},{week_date},{subflag},{week_end_date},{record_id},{week_num},{create_org_name}'>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td> 
		<td class="bt_info_odd" 	 exp="<a href=javascript:link2self('editIndex.jsp?org_id={org_id}&week_date={week_date}&week_end_date={week_end_date}&action=view')>{week_date}</a>">周报日期</td>		
		<td class="bt_info_even" 	 exp="{subflag}" func="getOpValue,substatus">状态</td>
		<td class="bt_info_odd" 	 exp="{create_org_name}">单位</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
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
</body>

<script type="text/javascript">
function calDateSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    true,
		singleClick    :    true,
		step        : 1,
		disableFunc: function(date) {
	        if (date.getDay() != 0) {
	            return true;
	        } else {
	            return false;
	        }
	    }
	    });
}
</script>
</html>
