<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #C0E2FB; overflow-y: auto" >
	<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%"  style="table-layout: fixed;word-break: break-all; word-wrap break-word;">
		<tr class="bt_info">
			<td>序号</td>
			<td>单位</td>
			<td>基层单位</td>
			<td width="40%" >危害因素描述</td>
			<td>因素状态</td>
			<td>因素级别</td>
			<td width="25%">风险削减措施</td>
			
		</tr>
	</table>	   
</body>
<script type="text/javascript">
	
	queryData();
function toAddLine(hidden_description,hidden_level,rectification_state,rectification_measures,org_name,second_name){
	var	orgName = "asdf";
	
	var table=document.getElementById("lineTable");
	
	var autoOrder = document.getElementById("lineTable").rows.length;
	var newTR = document.getElementById("lineTable").insertRow(autoOrder);
	newTR.className = 'even';
	if(autoOrder%2==0){
		newTR.className = 'odd';
	}
	
	var td = newTR.insertCell(0);
	td.innerHTML = autoOrder;
	
    td = newTR.insertCell(1);
    td.innerHTML = org_name;
    
    td = newTR.insertCell(2);
    td.innerHTML = second_name;
    
    td = newTR.insertCell(3);
    td.innerHTML = hidden_description;
    td.style.wordWrap = "break-word";
    td.style.wordBreak = "break-all";
    
    td = newTR.insertCell(4);
    td.innerHTML = rectification_state;
    
    td = newTR.insertCell(5);
    td.innerHTML = hidden_level;
    
    td = newTR.insertCell(6);
    td.innerHTML = rectification_measures;
    
}
	
	function queryData(){
		var checkSql="select hi.hidden_no, hi.hidden_description,decode(hi.hidden_level,'1','特大','2','重大','3','较大','4','一般') hidden_level,decode(hd.rectification_state,'1','已整改','2','未整改','3','正在整改','未整改') rectification_state,hd.rectification_measures,oi.org_abbreviation org_name,oi1.org_abbreviation second_name from bgp_hse_hidden_information hi left join bgp_hidden_information_detail hd on hi.hidden_no = hd.hidden_no and hd.bsflag = '0' left join comm_org_subjection os on hi.org_sub_id = os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'  left join comm_org_subjection os1 on hi.second_org = os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0'  where hi.bsflag = '0' and( hd.rectification_state = '2' or hd.rectification_state is null)  and hi.project_no = '<%=project_info_no%>'  order by hi.modifi_date desc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=10000&querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas!=null||datas!=""){
			if(datas.length==0){
				toAddLine("","","","","","");
			}else{
				for (var i = 0; i<datas.length; i++) {		
					toAddLine(
							datas[i].hidden_description ? datas[i].hidden_description : "",
							datas[i].hidden_level ? datas[i].hidden_level : "",
							datas[i].rectification_state ? datas[i].rectification_state : "",
							datas[i].rectification_measures ? datas[i].rectification_measures : "",
							datas[i].org_name ? datas[i].org_name : "",
							datas[i].second_name ? datas[i].second_name : ""
						);
				}
			}
		}else{
			toAddLine("","","","","","");
		}
	}
</script>
</html>

