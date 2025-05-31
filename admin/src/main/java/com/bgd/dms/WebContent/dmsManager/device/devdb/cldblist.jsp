<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String userid = user.getUserId();
	String org_id = request.getParameter("org_id");
	System.out.println(org_id + ":org_id");
	String startDate = request.getParameter("startDate");
	System.out.println(startDate + ":startDate");
	String endDate = request.getParameter("endDate");
	System.out.println(endDate + ":endDate");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
function exportDataDoc(exportFlag){
		
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		var db_from_org = document.getElementById("s_db_from_org").value;
		var db_into_org = document.getElementById("s_db_into_org").value;
		var  db_apply_id;
		$("input[type='checkbox'][name='selectedbox']").each(function (){
			    if($(this).attr("checked")=='checked'){
			    	db_apply_id=$(this).val()+",";
			    	
			    }
		});
		if(db_apply_id==undefined||db_apply_id==null){
			//alert("请选择一条需要导出的调拨单记录");
			//return ;
			db_apply_id="";
			$("input[type='checkbox'][name='selectedbox']").each(function (){
			    	db_apply_id+=$(this).val()+",";
		});
		}
			submitStr = "exportFlag="+exportFlag+"&db_from_org="+db_from_org+"&db_into_org="+db_into_org+"&db_apply_id="+db_apply_id;
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
</script>

<title>调拨记录</title>
</head>

<body style="background: #F1F2F3" onload="refreshData()">
	<div id="list_table">

		<div id="table_box">
			<table width="98%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id="queryRetTable">
				<tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id'
					idinfo='{dev_acc_id}'>

					<td class="bt_info_odd" exp="{db_date}">调拨日期</td>
					<td class="bt_info_even" exp="{db_from_org}">调出单位</td>
					<td class="bt_info_odd" exp="{db_into_org}">调入单位</td>
					<td class="bt_info_even" exp="{creator}">创建人</td>
					<td class="bt_info_odd" exp="{dev_code}">设备编号</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_zc_no}">资产编号</td>
					<td class="bt_info_even" exp="{dev_zc_jz}">净值</td>
					<td class="bt_info_odd" exp="{dev_zzd_no}">转资单号</td>
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
})	
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

	function refreshData() {
		var org_id = "<%=org_id%>";
		var startDate = "<%=startDate%>";
		var endDate = "<%=endDate%>";
		//var str = "select   t.db_date,"
		//		+ "(select org_name from comm_org_information  m  where  m.org_id=t.db_from_org) as db_from_org  "
		//		+ "  ,(select org_name from comm_org_information  m  where  m.org_id=t.db_into_org) as db_into_org ,t.creator, w.dev_code,w.dev_name,w.dev_zc_no ,w.dev_zc_jz,w.dev_zzd_no     from dms_device_cldb_apply   t left join "
		//		+ "    dms_device_cldb_apply_detail w on t.db_apply_id=w.db_apply_id where t.db_apply_id='"
		//		+ db_apply_id + "'";
		var str = "	 select ( select   p.org_hr_short_name  from bgp_comm_org_hr_gms  hr ,bgp_comm_org_hr  p where hr.org_hr_id=p.org_hr_id and hr.org_gms_id=t.db_from_org) as db_from_org ,t.db_date,(    select   p.org_hr_short_name  from bgp_comm_org_hr_gms  hr ,bgp_comm_org_hr  p where hr.org_hr_id=p.org_hr_id and hr.org_gms_id=t.db_into_org) as db_into_org ,t.creator,w.dev_code,w.dev_name,w.dev_zc_no,w.dev_zc_jz,w.dev_zzd_no"
				+ "	 from dms_device_cldb_apply t"
				+ "	 left join dms_device_cldb_apply_detail w"
				+ "	  on t.db_apply_id = w.db_apply_id"
				+ "	  where t.db_date>=to_date('"+startDate+"','yyyy-mm-dd')"
				+ "	  and t.db_date<=to_date('"+endDate+"','yyyy-mm-dd')"
				+ "	   and t.db_from_org='"+org_id+"'"
				+ "	   union All"
				+ "	 select ( select   p.org_hr_short_name  from bgp_comm_org_hr_gms  hr ,bgp_comm_org_hr  p where hr.org_hr_id=p.org_hr_id and hr.org_gms_id=t.db_from_org) as db_from_org ,t.db_date,(    select   p.org_hr_short_name  from bgp_comm_org_hr_gms  hr ,bgp_comm_org_hr  p where hr.org_hr_id=p.org_hr_id and hr.org_gms_id=t.db_into_org) as db_into_org ,t.creator,w.dev_code,w.dev_name,w.dev_zc_no,w.dev_zc_jz,w.dev_zzd_no"
				+ "	 from dms_device_cldb_apply t"
				+ "	  left join dms_device_cldb_apply_detail w"
				+ "	   on t.db_apply_id = w.db_apply_id"
				+ "	   where t.db_date>=to_date('"+startDate+"','yyyy-mm-dd')"
				+ "	   and t.db_date<=to_date('"+endDate+"','yyyy-mm-dd')"
				+ " and t.db_into_org='"+org_id+"'";

		cruConfig.queryStr = str;
		cruConfig.pageSize = 20;
		queryData(cruConfig.currentPage);
	}
</script>
</html>