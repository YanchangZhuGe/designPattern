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

	SimpleDateFormat df = new SimpleDateFormat("yyyy");
	String appDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

  

<script type="text/javascript" >
cruConfig.contextPath =  "<%=contextPath%>";
var proc_status="";
function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");   
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
}   
function toDelete(){
	ids = getSelIds('chk_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    var params = ids.split('~');
    if(params.length>4){
        alert("请选择一条记录!");
    	return;
    }
    if(params[0]=='1'){
    	var retObj = jcdpCallService("OPCostSrv", "deleteCarry", "carryover_id="+params[3]);
    	if(retObj.message=='success'){
    		alert("成功");	
    		searchDevData();
     	 }
    }else{
  	alert("非结转项目不可删除！");	
	}
}	

function toEdit(){
	ids = getSelIds('chk_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    var params = ids.split('~');
    if(params.length>4){
        alert("请选择一条记录!");
    	return;
    }
    if(proc_status==""||proc_status=="3"||proc_status=="4"){
		popWindow('<%=contextPath%>/op/wsProject/contractsSignedMoneyEdit.jsp?project_info_id='+params[1]+'&ifcarry='+params[0]+'&project_year='+params[2]);         		
      }else{
            alert("有审批流程在进行！");
      }
}

function toCarryover(ids){
	ids = getSelIds('chk_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    var params = ids.split('~');
    if(params.length>4){
        alert("请选择一条记录!");
    	return;
    }
	popWindow('<%=contextPath%>/op/wsProject/moneyCarryover.jsp?project_info_id='+params[1]+'&ifcarry='+params[0]+'&project_year='+params[2]);         		
}

function refreshData(year,obs_name){
	year=$("#year").val();
		var str = "select '0' ifcarry,'' as CARRYOVER_ID, t1.DAILY_ID,t1.PROJECT_INFO_NO,t1.ORG_NAME,t1.BASIN,t1.WELL_NUMBER,t1.PROJECT_INCOME,t1.START_DATE,t1.END_DATE,re3.CONTRACTS_SIGNED_CHANGE,re3.COMPLETE_VALUE_CHANGE,p.project_year  from ("
				+" SELECT DAILY_ID,PROJECT_INFO_NO,ORG_NAME,BASIN,WELL_NUMBER,CODING_NAME,CONTRACTS_SIGNED,project_income,PROJECT_STATUS,START_DATE,END_DATE, CASE CONTRACTS_MONEY_STAUTS WHEN '1' THEN '已确认' ELSE '未确认' END AS CONTRACTS_MONEY_STAUTS,COMPLETE_VALUE FROM BGP_WS_DAILY_REPORT WHERE BSFLAG='0' and DAILY_ID IN" 
				+" (SELECT MAX(DAILY_ID) FROM BGP_WS_DAILY_REPORT rt left join COMMON_BUSI_WF_MIDDLE wf on rt.PROJECT_INFO_NO=wf.BUSINESS_ID and wf.BSFLAG='0'WHERE rt.BSFLAG='0' AND wf.PROC_STATUS='3' and wf.busi_table_name='bgp_ws_daily_report' GROUP BY rt.PROJECT_INFO_NO)"
				+" ) t1 left join gp_task_project p on p.PROJECT_INFO_NO=t1.PROJECT_INFO_NO  and p.BSFLAG='0' left join("
				+" select wm_concat(distinct VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct BUILD_METHOD) as BUILD_METHOD, PROJECT_INFO_NO from BGP_WS_DAILY_REPORT where BSFLAG='0' group by PROJECT_INFO_NO"
				+" ) vb on vb.PROJECT_INFO_NO=t1.PROJECT_INFO_NO left join( "
				+"select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.YEAR   from BGP_OP_MONEY_CONFIRM_RECORD_WS re right join "
				+"(select max(rr.CREATE_DATE) as CREATE_DATE,rr.PROJECT_INFO_ID,rr.YEAR from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' "
				+"group by rr.PROJECT_INFO_ID,rr.YEAR) tt on tt.CREATE_DATE=re.CREATE_DATE"
				+" ) re3 on re3.PROJECT_INFO_ID=t1.PROJECT_INFO_NO and re3.year=p.project_year "
				+" where 1=1 and p.project_year is not null ";
		if(year!=undefined && year!=''){
			str+=" and p.project_year='"+year+"'";
		}
		if(obs_name!=undefined && obs_name!=''){
			str+=" and t1.org_name='"+obs_name+"'";
		}
		/*
		if(v_strat_time!=undefined && v_strat_time!=''){
			str +=" and t1.START_DATE>=to_date('"+v_strat_time+"','yyyy-mm-dd') ";
		}
		if(v_end_time!=undefined && v_end_time!=''){
			str +=" and t1.END_DATE<=to_date('"+v_end_time+"','yyyy-mm-dd') ";
		}
		*/
	
		str+=" union "
		+"select '1' ifcarry, cr.CARRYOVER_ID,'' as DAILY_ID,cr.PROJECT_INFO_NO,da.ORG_NAME,da.BASIN,da.WELL_NUMBER||'(结转)' as WELL_NUMBER,da.PROJECT_INCOME,da.START_DATE,da.END_DATE,decode(cr.wf1.CONTRACTS_SIGNED_CHANGE,'',cr.CONTRACTS_SIGNED_CARRYOVER,cr.wf1.CONTRACTS_SIGNED_CHANGE) as CONTRACTS_SIGNED_CHANGE,decode(wf1.COMPLETE_VALUE_CHANGE,'',cr.COMPLETE_VALUE_CARRYOVER,wf1.COMPLETE_VALUE_CHANGE) as COMPLETE_VALUE_CHANGE,cr.year as project_year from BGP_OP_PROJECT_MONEY_CARRYOVER cr "
		+" left join BGP_OP_MONEY_CONFIRM_RECORD_WS re on cr.PROJECT_INFO_NO=re.PROJECT_INFO_ID and cr.YEAR=re.year and re.BSFLAG='0'"
		+" left join("
		+" select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.year  from BGP_OP_MONEY_CONFIRM_RECORD_WS re "
		+" where re.CREATE_DATE in "
		+" (select max(rr.CREATE_DATE) from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' group by rr.PROJECT_INFO_ID,rr.year)"
		+" group by PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.CREATE_DATE,re.year"
		+" )  wf1 on wf1.PROJECT_INFO_ID=cr.PROJECT_INFO_NO and wf1.year=cr.YEAR "
		+" left join BGP_WS_DAILY_REPORT da on da.PROJECT_INFO_NO=cr.PROJECT_INFO_NO and da.BSFLAG='0' "
		+" left join ("
		+" select wm_concat(distinct t4.VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct t4.BUILD_METHOD) as BUILD_METHOD, t4.PROJECT_INFO_NO from BGP_WS_DAILY_REPORT t4 where t4.BSFLAG='0' group by t4.PROJECT_INFO_NO"
		+" ) t3 on cr.PROJECT_INFO_NO=t3.PROJECT_INFO_NO where 1=1 and cr.bsflag='0'";


		if(year!=undefined && year!=''){
			str+=" and cr.year='"+year+"'";
		}
		if(obs_name!=undefined && obs_name!=''){
			str+=" and da.org_name='"+obs_name+"'";
		}
		/*
		if(v_strat_time==undefined && v_end_time==undefined){
			str+=" and cr.year='<%=appDate%>'";
		}
		if(v_strat_time!=undefined && v_strat_time!=''){
			str +=" and da.START_DATE>=to_date('"+v_strat_time+"','yyyy-mm-dd') ";
		}
		if(v_end_time!=undefined && v_end_time!=''){
			str +=" and da.END_DATE<=to_date('"+v_end_time+"','yyyy-mm-dd') ";
		}
		*/
		//str +=" ORDER BY t1.START_DATE ";

		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
}


/*
function tosubmit(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    var params = ids.split('~');
	for(var i=0;i<params.length;i++){
		
	var contracts_signed = document.getElementById("contracts_signed"+params[i]).value;
	var complete_value = document.getElementById("complete_value"+params[i]).value;
	
	var retObj = jcdpCallService("OPCostSrv", "saveFCSM", "project_info_id="+params[i]+"&contracts_signed="+contracts_signed+"&complete_value="+complete_value);
		if(retObj.message!='success'){
			//alert("第"+i+"条失败");
		}
	}	
	alert("成功");
	searchDevData();
}
*/
function loadDataDetail(ids){
		
	//载入费用详细信息
	var querySql="";
    var params = ids.split('~');
	if(params[0]=='0'){
		querySql = "select p.project_name,t2.PROJECT_INFO_NO,t2.org_name,t2.well_number,t2.coding_name,t2.project_status,t3.build_method,t3.view_type,t2.project_income,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE from ("
			+"select t1.DAILY_ID,t1.PROJECT_INFO_NO,t1.ORG_NAME,t1.BASIN,t1.WELL_NUMBER,t1.CODING_NAME,t1.CONTRACTS_SIGNED,t1.project_income,t1.PROJECT_STATUS,t1.START_DATE,END_DATE from BGP_WS_DAILY_REPORT t1 where t1.DAILY_ID=(select max(t.DAILY_ID) from BGP_WS_DAILY_REPORT t where  t.PROJECT_INFO_NO='"+params[1]+"')"
			+") t2 left join ("
			+"select wm_concat(distinct t4.VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct t4.BUILD_METHOD) as BUILD_METHOD, t4.PROJECT_INFO_NO from BGP_WS_DAILY_REPORT t4 where t4.BSFLAG='0' group by t4.PROJECT_INFO_NO"
			+") t3 on t2.PROJECT_INFO_NO=t3.PROJECT_INFO_NO"
			+" left join GP_TASK_PROJECT p on  t2.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.bsflag='0' left join "
			+"( "
			+"select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.YEAR   from BGP_OP_MONEY_CONFIRM_RECORD_WS re right join "
			+"(select max(rr.CREATE_DATE) as CREATE_DATE,rr.PROJECT_INFO_ID,rr.YEAR from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' "
			+"group by rr.PROJECT_INFO_ID,rr.YEAR) tt on tt.CREATE_DATE=re.CREATE_DATE"
			+") re on t2.PROJECT_INFO_NO=re.PROJECT_INFO_ID and re.year='"+params[2]+"'";
	
	}else if(params[0]=='1'){
		querySql="select p.PROJECT_NAME||'(结转)' as project_name, t3.build_method,t3.view_type,da.coding_name,da.project_status,cr.PROJECT_INFO_NO,da.ORG_NAME,da.BASIN,da.WELL_NUMBER||'(结转)' as WELL_NUMBER,da.PROJECT_INCOME,da.START_DATE,da.END_DATE,decode(cr.wf1.CONTRACTS_SIGNED_CHANGE,'',cr.CONTRACTS_SIGNED_CARRYOVER,cr.wf1.CONTRACTS_SIGNED_CHANGE) as CONTRACTS_SIGNED_CHANGE,decode(wf1.COMPLETE_VALUE_CHANGE,'',cr.COMPLETE_VALUE_CARRYOVER,wf1.COMPLETE_VALUE_CHANGE) as COMPLETE_VALUE_CHANGE from BGP_OP_PROJECT_MONEY_CARRYOVER cr "
			+"left join BGP_OP_MONEY_CONFIRM_RECORD_WS re on cr.PROJECT_INFO_NO=re.PROJECT_INFO_ID and cr.YEAR=re.year and re.BSFLAG='0'"
			+"left join("
			+"select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.YEAR   from BGP_OP_MONEY_CONFIRM_RECORD_WS re right join "
			+"(select max(rr.CREATE_DATE) as CREATE_DATE,rr.PROJECT_INFO_ID,rr.YEAR from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' "
			+"group by rr.PROJECT_INFO_ID,rr.YEAR) tt on tt.CREATE_DATE=re.CREATE_DATE"
			+")  wf1 on wf1.PROJECT_INFO_ID=cr.PROJECT_INFO_NO and wf1.year=cr.YEAR "
			+"left join BGP_WS_DAILY_REPORT da on da.PROJECT_INFO_NO=cr.PROJECT_INFO_NO and da.BSFLAG='0' "
			+" left join GP_TASK_PROJECT p on  cr.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.bsflag='0'  left join ("
			+"select wm_concat(distinct t4.VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct t4.BUILD_METHOD) as BUILD_METHOD, t4.PROJECT_INFO_NO from BGP_WS_DAILY_REPORT t4 where t4.BSFLAG='0' group by t4.PROJECT_INFO_NO"
			+") t3 on cr.PROJECT_INFO_NO=t3.PROJECT_INFO_NO where cr.PROJECT_INFO_NO='"+params[1]+"' and cr.YEAR='"+params[2]+"'";
				
	}
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas!=null){
		$("#project_name").val(datas[0].project_name);
		$("#org_name").val(datas[0].org_name);
		$("#well_number").val(datas[0].well_number);
		$("#coding_name").val(datas[0].coding_name);
		$("#project_status").val(datas[0].project_status);
		$("#build_method").val(datas[0].build_method);
		$("#view_type").val(datas[0].view_type);
		$("#contracts_signed").val(datas[0].contracts_signed_change);
		$("#project_income").val(datas[0].project_income);
		$("#complete_value").val(datas[0].complete_value_change);	
	}
	$("input[type='checkbox'][name='chk_entity_id'][id!='chk_entity_id"+ids+"']").removeAttr("checked");
	//选中这一条checkbox
	$("input[type='checkbox'][name='chk_entity_id'][id='chk_entity_id"+ids+"']").attr("checked",'true');

	var record_id="";
	var reSql="select wf.PROC_STATUS,t1.RECORD_ID from BGP_OP_MONEY_CONFIRM_RECORD_WS t1 left join COMMON_BUSI_WF_MIDDLE wf on t1.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where t1.CREATE_DATE=(select max(re.CREATE_DATE) from BGP_OP_MONEY_CONFIRM_RECORD_WS re where re.PROJECT_INFO_ID='"+params[1]+"' and re.YEAR='"+params[2]+"' and re.BSFLAG='0')";
	var recoedObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+reSql);

	if(recoedObj.datas!=""){
		var redatas = recoedObj.datas;
		record_id=redatas[0].record_id;
		 if(redatas[0].proc_status!=null){
			 proc_status=redatas[0].proc_status;
		}else{
			 proc_status="";	
		}
			processNecessaryInfo={
					businessTableName:"BGP_OP_MONEY_CONFIRM_RECORD_WS",
					businessType:"5110000004100001086",
					businessId:record_id,
					businessInfo:"井中项目金额确认申请",
					applicantDate:"<%=appDate%>"
			};
				
			processAppendInfo={
						projectInfoNo:params[1],
						record_id:record_id

			};
			loadProcessHistoryInfo();	
	}else{
		 proc_status="";	
	}


	getContentTab(undefined,selectedTagIndex);
}

var selectedTagIndex = 0;
function getContentTab(obj,index){ 
	
	debugger;
	selectedTagIndex = index;
	if(obj!=undefined){
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";
	}
	var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
	var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
	var info;
	$("input[type='checkbox'][name='chk_entity_id']").each(function(){
		if(this.checked){
			var currentid = this.value;
			info = currentid.split("~",-1);
			if(index == 1){
				$("#attachement").attr("src","<%=contextPath%>/op/wsProject/contractsSignedRecordList.jsp?project_info_id="+info[1]+"&project_year="+info[2]+"&ifcarry="+info[0]);
				
			}else if(index == 4){
			//	$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId=1111");
			}
		}		
		});

	$(filternotobj).hide();
	$(filterobj).show();

}
function searchDevData(){
	var year = $("#year").val();
	var obs_name = $("#obs_name").val();
	
	//var v_strat_time = document.getElementById("start_time").value;
	//var v_end_time = document.getElementById("end_time").value;
	refreshData(year,obs_name);
}

</script>
<title>列表页面</title>
</head>
<body onload="refreshData()" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<!--  
					<td class="ali_cdn_name">开始时间：</td>
			 	    <td class="ali_cdn_input"><input class="input_width" id="start_time" name="start_time" type="text" />
			 	    </td>
			 	    <td class="ali_btn">
			 	    <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_time,tributton1);" />
			 	    </td>
			 	    <td class="ali_cdn_name">结束时间：</td>
			 	    <td class="ali_cdn_input"><input class="input_width" id="end_time" name="end_time" type="text" />
			 	    </td>
			 	    <td class="ali_btn">
			 	    <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_time,tributton2);" />
			 	    </td>
			 	-->    
			 		<td class="ali_cdn_name">年度：</td>
			 	    <td class="ali_cdn_input">
					<select id="year" name="year">
						<option value="">全部</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select>
			 	    </td>
			 	    <td class="ali_cdn_name">队伍：</td>
			 	    <td class="ali_cdn_input">
					<select id="obs_name" name="obs_name">
						<option value="">全部</option>
						<option value="2504队">2504队</option>
						<option value="2508队">2508队</option>
						<option value="2513队">2513队</option>
						<option value="2514队">2514队</option>
						<option value="2517队">2517队</option>
						<option value="2518队">2518队</option>
						<option value="2521队">2521队</option>
						<option value="2522队">2522队</option>
					</select>
			 	    </td>
			  		  <td class="ali_cdn_input"><span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span></td>
			 	    
			 	    <td>&nbsp;</td>
			 	    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			 	    <auth:ListButton functionId="" css="jh" event="onclick='toCarryover()'" title="结转"></auth:ListButton>
			 	    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			 	    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			 	    
			 	    
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
				<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{ifcarry}~{project_info_no}~{project_year}~{carryover_id}' id='chk_entity_id{ifcarry}~{project_info_no}~{project_year}~{carryover_id}' onclick='chooseOne(this)'/>" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="{org_name}">施工队伍</td>
			  	<td class="bt_info_even" exp="{basin}">地区(盆地)</td>
			  	<td class="bt_info_odd" exp="{well_number}">施工井号</td>
			  	<td class="bt_info_odd" exp="{start_date}">开工时间</td>
			  	<td class="bt_info_even" exp="{end_date}">完工时间</td>
			  	<td class="bt_info_odd" exp="{project_year}">年度</td>			  	
			  	<td  class="bt_info_even" exp="<input type='hidden' id='contracts_signed{project_info_no}' name='contracts_signed' value='{contracts_signed_change}'>{contracts_signed_change}">已签到合同额(万元)</td>
			  	<td  class="bt_info_odd" exp="{project_income}">预计完成价值工作量(万元)</td>
			  	<td  class="bt_info_even" exp="<input type='hidden' id='complete_value{project_info_no}' name='complete_value' value='{complete_value_change}'>{complete_value_change}">完成价值工作量(万元)</td>
			  
			  	<td class="bt_info_odd" exp="{contracts_signed_change}" isShow="Hide">已签到合同额(万元)</td>
			  	<td class="bt_info_odd" exp="{complete_value_change}" isShow="Hide">完成价值工作量(万元)</td>


			  
			  	<!--<td class="bt_info_even" exp="{contracts_money_stauts}">状态</td>-->	
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li id="tag3_0" class="selectTag"><a href="#" onclick="getContentTab(this,0)">详细信息</a></li>
        <li id="tag3_1" ><a href="#" onclick="getContentTab(this,1)">审批金额记录</a></li>
        <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">流程</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow-y:auto;">
	
		<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" >
			    <table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
			    
			     	<tr>
				    	<td class="inquire_item8">项目名称:</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="project_name" value=""/></td>
				    	<td class="inquire_item8">施工队伍:</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="org_name" value=""/></td>
				    	<td class="inquire_item8">施工井号:</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="well_number" value=""/></td>
				    	<td class="inquire_item8">甲方单位:</td>
				    	<td class="inquire_form8"><input readonly="readonly"  class="input_width_no_color" id="coding_name" value=""/></td>
				    </tr>     	
				    <tr>
				    	<td class="inquire_item8">项目状态:</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="project_status" value="" /></td>
				    	<td class="inquire_item8">激发方式:</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="build_method"/ value=""></td>
				    	<td class="inquire_item8">观测类型:</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="view_type" value="" /></td>
				    	<td class="inquire_item8">已签到合同额(万元):</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="contracts_signed" value=""/></td>
				    </tr>
				    <tr>
				    	<td class="inquire_item8">预计完成价值工作量(万元):</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="project_income" value=""></td>
				    	<td class="inquire_item8">完成价值工作量(万元):</td>
				    	<td class="inquire_form8"><input readonly="readonly" class="input_width_no_color" id="complete_value" value=""></td>
			
				    </tr>
				 </table>
		</div>
		<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">					
				<wf:startProcessInfo  buttonFunctionId="F_OP_001" title=""/>		
		</div>

	</div>
</div>	
<script type="text/javascript">
$("#year").val('<%=appDate%>');

function chooseOne(cb){   
    var obj = document.getElementsByName("chk_entity_id");
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }
}  
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

</body>
</html>
