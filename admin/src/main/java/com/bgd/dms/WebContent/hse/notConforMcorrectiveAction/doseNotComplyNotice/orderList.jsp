<%@ page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
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
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
	
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = "2";
		//isProject = resultMsg.getValue("isProject");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
  <title>不符合通知单</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">审核单位</td>
			    <td class="ali_cdn_input"><input id="orgName1" name="orgName1" type="text" /></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td> 
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    </td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0"   class="tab_info" id="queryRetTable">		
			     <tr>    
			      <td class="bt_info_odd" 	 exp="<input type='checkbox' name='chx_entity_id'  id='chx_entity_id{order_no}' value='{order_no}' \>"> 
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
					<td class="bt_info_even" 	 autoOrder="1">序号</td>
					<td class="bt_info_odd" 	 exp="{org_name}" >被检查/审核单位</td>
					<td class="bt_info_even" 	 exp="{audit_date}">检查/审核日期</td>
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
		 
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
var checked = false;
function check(){
	var chk = document.getElementsByName("chx_entity_id");
	for(var i = 0; i < chk.length; i++){ 
		if(!checked){ 
			chk[i].checked = true; 
		}
		else{
			chk[i].checked = false;
		}
	} 
	if(checked){
		checked = false;
	}
	else{
		checked = true;
	}
}

</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
 
	function toAdd(){
		 
		popWindow('<%=contextPath%>/hse/notConforMcorrective/edit.srq?projectInfoNo=<%=projectInfoNo%>&func=1','1024:800');
	
	}
	function dbclickRow(ids){ 
	    var tempa = ids.split(',');		
	    var train_plan_no =  tempa[0];    
 
			popWindow("<%=contextPath%>/hse/notConforMcorrective/edit.srq?projectInfoNo=<%=projectInfoNo%>&id="+train_plan_no+"&update=true&func=1","1024:800");
	}
	
	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var train_plan_no =  tempa[0];    
 
			popWindow("<%=contextPath%>/hse/notConforMcorrective/edit.srq?projectInfoNo=<%=projectInfoNo%>&id="+train_plan_no+"&update=true&func=1","1024:800");
			//editUrl = "/rm/em/toHumanPrepareEdit.srq?id="+requirement_no+"&update=true"+"&prepareNo="+prepare_no+"&func=1";
	    	//window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	
	}
	function toSearch(){
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotComplyNotice/hse_search.jsp?isProject=<%=isProject%>");
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
 
	   	var tempIds = ids.split(",");
		var id = "";
		for(var i=0;i<tempIds.length;i++){
			id = id + "'" + tempIds[i] + "'";
			if(i != tempIds.length -1){
				id = id + ",";
			
			}
		} 
		var sql = "update BGP_NOACCORDWITH_ORDER set bsflag='1' where order_no in ("+id+")"; 
		deleteEntities(sql);
		alert('删除成功！');
	}
	
	 
	function refreshData(){
		var isProject = "<%=isProject%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId()%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			retObj = jcdpCallService("HseSrv", "queryOrg", "");
			var querySqlAdd = " and (t.audit_unit like '" +org_subjection_id+"%' or t.org_subjection_id like '"+org_subjection_id+"%')";
			if(retObj.flag!="false"){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag=="0"){
						querySqlAdd = " and t.audit_unit like 'C105%'";
					}else{
						if(len>1){
							if(retObj.list[1].organFlag=="0"){
								querySqlAdd = " and (t.audit_unit like '" + retObj.list[0].orgSubId +"%' or t.org_subjection_id like '"+org_subjection_id+"%')";
							}else{
								if(len>2){
									if(retObj.list[2].organFlag=="0"){
										querySqlAdd = " and (t.audit_unit like '" + retObj.list[1].orgSubId +"%'or t.org_subjection_id like '"+org_subjection_id+"%')";
									}
								}
							}
						}
					}
				}
			}
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select  ion.org_name,t.order_no,t.audit_unit,t.audit_date   from  BGP_NOACCORDWITH_ORDER t  join comm_org_subjection os1     on t.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id  where t.bsflag='0' "+querySqlAdd+" order by t.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotComplyNotice/orderList.jsp";
		queryData(1);
	}
	 
	
	// 简单查询
	function simpleSearch(){
			var changeName = document.getElementById("orgName1").value;
				if(changeName!=''&& changeName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = " select  ion.org_name,t.order_no,t.audit_unit,t.audit_date   from  BGP_NOACCORDWITH_ORDER t  join comm_org_subjection os1     on t.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id  where t.bsflag='0'  and ion.org_name like'%"+changeName+"%' order by t.modifi_date desc ";
					cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotComplyNotice/orderList.jsp";
					queryData(1);
				}else{
				 
					refreshData();
				}
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotComplyNotice/orderList.jsp";
		queryData(1);
	}
 
	
	function clearQueryText(){
		document.getElementById("orgName1").value = "";
	}

 
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function loadDataDetail(shuaId){
//		var obj = event.srcElement;
//		if(obj.tagName.toLowerCase() =='td'){
//			obj.parentNode.cells[0].firstChild.checked = 'checked';
//		}
//	 
		
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
	
</script>
</html>