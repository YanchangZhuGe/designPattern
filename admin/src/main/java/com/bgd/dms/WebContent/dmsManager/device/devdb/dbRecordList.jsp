<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@ include file="/common/rptHeader.jsp"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>

<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String userid = user.getUserId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
function dataSelector(inputField,tributton)
{    
	Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    true,
		step	       :	1
    });
}

function toChoseOrgFrom(){
	var  obj=new Object();
	var returnValue= window.showModalDialog('<%=contextPath%>/dmsManager/device/devdb/selectOrgHR.jsp',obj,'dialogWidth=512px;dialogHigth=400px');
	//'orgName:'+node.text+'~orgId:'+fkValue+'~orgSubId:'+subValue;
	var orgArr=returnValue.split("~");
	
	$("#s_db_from_org_name").val(orgArr[0].split(":")[1]);
	$("#s_db_from_org").val(orgArr[1].split(":")[1]);
	
}
function toChoseOrgInto(){
	var  obj=new Object();
	var returnValue= window.showModalDialog('<%=contextPath%>/dmsManager/device/devdb/selectOrgHR.jsp',obj,'dialogWidth=512px;dialogHigth=400px');
	//'orgName:'+node.text+'~orgId:'+fkValue+'~orgSubId:'+subValue;
	var orgArr=returnValue.split("~");
	$("#s_db_into_org_name").val(orgArr[0].split(":")[1]);
	$("#s_db_into_org").val(orgArr[1].split(":")[1]);
}
</script>

<title>调拨记录</title>
</head>

<body style="background: #cdddef" onload="searchDevData()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="right" style="width: 90px">调入单位:</td>
								<td  width="15%"><input id="s_db_into_org_name" name="s_db_into_org_name"
									type="text" /> <img
									src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;" onclick="toChoseOrgInto()" />
									<input type="hidden" id="s_db_into_org" /></td>
								<td class="ali_cdn_name" style="width: 90px">调出单位:</td>
								<td  width="15%"><input id="s_db_from_org_name" name="s_db_from_org_name"
									type="text" /> <img
									src="<%=contextPath%>/images/magnifier.gif" width="16"
									height="16" style="cursor: hand;" onclick="toChoseOrgFrom()" />
									<input type="hidden" id="s_db_from_org" /></td>
									
									<td width="6%"  align="right">调拨日期:</td>
								<td ><input type="text"
									id="startDate" name="startDate" 
									style="width: 100px" readonly="readonly" /><img
									src="<%=contextPath%>/images/calendar.gif" id="tributton1"
									width="16" height="16" style="cursor: hand;"
									onmouseover="dataSelector(startDate,tributton1);" />
								至
								<input type="text"
									id="endDate" name="endDate" 
									style="width: 100px" readonly="readonly" /><img
									src="<%=contextPath%>/images/calendar.gif" id="tributton2"
									width="16" height="16" style="cursor: hand;"
									onmouseover="dataSelector(endDate,tributton2);" /></td>

								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td><auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton></td>
								
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr id='db_apply_id_{db_apply_id}' name='db_apply_id'>
					<td class="bt_info_odd"
						exp="<input type='checkbox' name='selectedbox' value='{db_apply_id}' id='selectedbox_{db_apply_id}' onclick='chooseOne(this);loadDataDetail();'/>">选择</td>
					<td class="bt_info_odd" exp="{db_date}">调拨日期</td>
					<td class="bt_info_even" exp="{db_into_org}">调入单位</td>
					<td class="bt_info_odd" exp="{db_from_org}">调出单位</td>
					<td class="bt_info_even" exp="{dev_zc_jz}">金额</td>
					<td class="bt_info_odd" exp="{creator}">调拨人</td>

				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getContentTab(this,0)">基本信息</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content">
				<table id="projectMap" name="projectMap" border="0" cellpadding="0"
					cellspacing="0" class="tab_line_height" width="100%"
					style="margin-top: 10px; background: #efefef">
					<tr>
						<td class="inquire_item6">调拨日期：</td>
						<td class="inquire_form6"><input id="db_date"
							class="input_width" type="text" value="" disabled />&nbsp;</td>
						<td class="inquire_item6">调出单位：</td>
						<td class="inquire_form6"><input id="db_from_org"
							class="input_width" type="text" value="" disabled />&nbsp;</td>
						<td class="inquire_item6">调入单位</td>
						<td class="inquire_form6"><input id="db_into_org"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">调拨状态：</td>
						<td class="inquire_form6"><input id="dbflag"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">调拨人：</td>
						<td class="inquire_form6"><input id="creator"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6"></td>
						<td class="inquire_form6">&nbsp;</td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content1" name="tab_box_content1"
				class="tab_box_content" idinfo="" style="display: none">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd" width="5%">序号</td>
						<td class="bt_info_even" width="20%">设备编号</td>
						<td class="bt_info_odd" width="20%">设备名称</td>
						<td class="bt_info_odd" width="20%">资产编号</td>
						<td class="bt_info_even" width="15%">净值</td>
						<td class="bt_info_odd" width="18%">转资单号</td>

					</tr>
					<tbody id="detailList" name="detailList"></tbody>
				</table>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
	
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	;
    function toStockDetailPage(obj){
    	window.location.href = "subStockin.jsp?id="+obj;
    }

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		var basedatas;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
	
		if(index == 1){
			
			//动态查询明细
			var db_apply_id="" ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					db_apply_id = this.value;
				}
			});
			if(""==db_apply_id||db_apply_id==undefined){
				$(filternotobj).hide();
				$(filterobj).show();
				return;
			}else{
                var str = " select *  from dms_device_cldb_apply_detail  t  where t.db_apply_id='"+db_apply_id+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
			
				var filtermapid = "#detailList";
				$(filtermapid).empty();
				appendDataToDetailTab(filtermapid,basedatas);
			}
			
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_code+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_zc_no+"</td>";
			innerHTML += "<td>"+datas[i].dev_zc_jz+"</td><td>"+datas[i].dev_zzd_no+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	
	$(document).ready(lashen);
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
    
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else 
	             {obj[i].checked = true;  
	              checkvalue = obj[i].value;
	             } 
	        }      
    }
    function loadDataDetail(){
    	  var db_apply_id;
		 $("input[type='checkbox'][name='selectedbox']").each(function (i){
			 if($(this).attr('checked')=='checked'){
				 db_apply_id=$(this).val();
			 }
			 
		 });
		//取消选中框--------------------------------------------------------------------------
	   // var str = " select * from dms_device_cldb_apply t  where t.bsflag='0' and t.db_apply_id='"+db_apply_id+"'";
	    var str = " select  db_apply_id, db_date,( select p.org_hr_short_name  from bgp_comm_org_hr_gms hr  left join bgp_comm_org_hr  p  on p.org_hr_id=hr.org_hr_id where   hr.org_gms_id=t.db_from_org) as db_from_org ,"+
		"  (  select p.org_hr_short_name  from bgp_comm_org_hr_gms hr  left join bgp_comm_org_hr  p  on p.org_hr_id=hr.org_hr_id where   hr.org_gms_id=t.db_into_org) as db_into_org ,dbflag,creator "+
		"  from dms_device_cldb_apply t  where t.bsflag='0'";
	    str+="   and t.db_apply_id='"+db_apply_id+"'";
		//补充查询条件
	    var unitRet = syncRequest('Post','<%=contextPath%>'
				+ appConfig.queryListAction, 'querySql=' + str);
		retObj = unitRet.datas;
		$("#db_date").val(retObj[0].db_date);
		$("#db_from_org").val(retObj[0].db_from_org);
		$("#db_into_org").val(retObj[0].db_into_org);
		$("#dbflag").val(retObj[0].dbflag);
		$("#creator").val(retObj[0].creator);
		 var str = " select *  from dms_device_cldb_apply_detail  t  where t.db_apply_id='"+db_apply_id+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			basedatas = queryRet.datas;
			var filtermapid = "#detailList";
			$(filtermapid).empty();
			appendDataToDetailTab(filtermapid,basedatas);
		
	}

	function searchDevData() {
		var db_from_org = document.getElementById("s_db_from_org").value;
		var db_into_org = document.getElementById("s_db_into_org").value;
		var  startDate= document.getElementById("startDate").value;
		var  endDate= document.getElementById("endDate").value;

		refreshData(db_from_org, db_into_org,startDate,endDate);
	}

	//清空查询条件
	function clearQueryText() {
		document.getElementById("s_db_from_org").value = "";
		document.getElementById("s_db_into_org").value = "";
		document.getElementById("s_db_from_org_name").value = "";
		document.getElementById("s_db_into_org_name").value = "";
		document.getElementById("startDate").value = "";
		document.getElementById("endDate").value = "";
		
	}

	function refreshData(db_from_org, db_into_org,startDate,endDate) {
		var str = " select (select sum(dev_zc_jz) from Dms_Device_Cldb_Apply_Detail k  where k.db_apply_id=t.db_apply_id ) as dev_zc_jz, db_apply_id, db_date,( select p.org_hr_short_name  from bgp_comm_org_hr_gms hr  left join bgp_comm_org_hr  p  on p.org_hr_id=hr.org_hr_id where   hr.org_gms_id=t.db_from_org) as db_from_org ,"
				+ "  (  select p.org_hr_short_name  from bgp_comm_org_hr_gms hr  left join bgp_comm_org_hr  p  on p.org_hr_id=hr.org_hr_id where   hr.org_gms_id=t.db_into_org) as db_into_org ,dbflag,creator "
				+ "  from dms_device_cldb_apply t  where t.bsflag='0'";
		//补充查询条件
		if (db_from_org != undefined && db_from_org != '') {
			str += "    and t.db_from_org = '" + db_from_org + "'";
		}
		if (db_into_org != undefined && db_into_org != '') {
			str += "    and t.db_into_org  =  '" + db_into_org + "'";
		}
		
		if (startDate != undefined && startDate != '') {
			str += "    and t.db_date  >=to_date('"+startDate+"','yyyy-mm-dd')";
		}
		
		if (endDate != undefined && endDate != '') {
			str += "    and t.db_date  <= to_date('"+endDate+"','yyyy-mm-dd')";
		}
		str += "order by db_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
</script>
</html>