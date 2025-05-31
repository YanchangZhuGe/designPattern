<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String project_info_no = user.getProjectInfoNo();
	
	//隐患级别 特大，重大，较大，一般数量
	String first_big_dan = "0";
	String second_big_dan = "0";
	String third_big_dan = "0";
	String usual_dan = "0";
	
	String sqlLevel = "select count(t.hidden_no) hidden_num, t.hidden_level from bgp_hse_hidden_information t where t.bsflag = '0' and t.project_no='"+project_info_no+"' group by t.hidden_level order by t.hidden_level asc ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sqlLevel);
	for(int i=0;i<list.size();i++){
		Map map = (Map)list.get(i);
		String hidden_level = (String)map.get("hiddenLevel");
		if(hidden_level.equals("1")){
			first_big_dan = (String)map.get("hiddenNum");
		}
		if(hidden_level.equals("2")){
			second_big_dan = (String)map.get("hiddenNum");
		}
		if(hidden_level.equals("3")){
			third_big_dan = (String)map.get("hiddenNum");
		}
		if(hidden_level.equals("4")){
			usual_dan = (String)map.get("hiddenNum");
		}
	}
	
	//未整改隐患
	String no_modify_dan = "0";
	String sqlModify = "select count(d.mdetail_no) no_modify_dan from bgp_hse_hidden_information t left join bgp_hidden_information_detail d on t.hidden_no = d.hidden_no and d.bsflag = '0' where t.bsflag = '0' and t.project_no='"+project_info_no+"' and d.rectification_state = '2'";
	Map mapModify = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlModify);
	if(mapModify!=null){
		no_modify_dan = (String)mapModify.get("noModifyDan");
	}
	
	//违章级别 特大，重大，较大，一般数量
	String first_big_rule = "0";
	String second_big_rule = "0";
	String third_big_rule = "0";
	String usual_rule = "0";
	String sql = "select count(t.illegal_no) illegal_num,t.illegal_level  from bgp_illegal_management t where t.bsflag='0' and t.project_no='"+project_info_no+"' group by t.illegal_level";
	List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	for(int i=0;i<list2.size();i++){
		Map map = (Map)list2.get(i);
		String illegal_level = (String)map.get("illegalLevel");
		if(illegal_level.equals("0")){
			first_big_rule = (String)map.get("illegalNum");
		}
		if(illegal_level.equals("1")){
			second_big_rule = (String)map.get("illegalNum");
		}
		if(illegal_level.equals("2")){
			third_big_rule = (String)map.get("illegalNum");
		}
		if(illegal_level.equals("3")){
			usual_rule = (String)map.get("illegalNum");
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/hse/danCharts/panel.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="overflow-y: auto; background: #c0e2fb;">
<div id="list_content" style="background: #c0e2fb;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="10px"></td>
						</tr>
						<tr>
						<td>
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">隐患识别统计</a></div>
						<table width="100%" cellspacing="0" cellpadding="0"class="tab_info" >
							<tr class="bt_info">
								<td>重大</td>
								<td>较大</td>
								<td>一般</td>
								<td>未整改隐患</td>
							</tr>
							<tr class="even">
								<td><%=second_big_dan %></td>
								<td><%=third_big_dan %></td>
								<td><%=usual_dan %></td>
								<td><%=no_modify_dan %></td>
							</tr>
						</table>	   
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td height="10px"></td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">违章行为统计</a></div>
							<table width="100%"  cellspacing="0" cellpadding="0"class="tab_info">
								<tr class="bt_info">
									<td>重大</td>
									<td>较大</td>
								</tr>
								<tr class="even">
									<td><%=second_big_rule %></td>
									<td><%=third_big_rule %></td>
								</tr>
							</table>	   
						</td>
						</tr>
						<tr>
							<td height="10px"></td>
						</tr>
						<tr>
						<td>
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">未整改隐患明细</a></div>
							<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%"  style="table-layout: fixed;word-break: break-all; word-wrap break-word;">
								<tr class="bt_info">
									<td>序号</td>
									<td>单位</td>
									<td>基层单位</td>
									<td>隐患名称</td>
									<td width="40%" >危害因素描述</td>
									<td>因素状态</td>
									<td>因素级别</td>
									<td width="25%">风险削减措施</td>
									
								</tr>
							</table>	 
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
	
	queryData();
function toAddLine(hidden_description,hidden_level,rectification_state,rectification_measures,org_name,second_name,hidden_name){
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
    td.innerHTML = hidden_name;
    
    td = newTR.insertCell(4);
    td.innerHTML = hidden_description;
    td.style.wordWrap = "break-word";
    td.style.wordBreak = "break-all";
    
    td = newTR.insertCell(5);
    td.innerHTML = rectification_state;
    
    td = newTR.insertCell(6);
    td.innerHTML = hidden_level;
    
    td = newTR.insertCell(7);
    td.innerHTML = rectification_measures;
    
    
}
	
	function queryData(){
		var checkSql="select hi.hidden_no, hi.hidden_name, hi.hidden_description,decode(hi.hidden_level,'1','特大','2','重大','3','较大','4','一般') hidden_level,decode(hd.rectification_state,'1','已整改','2','未整改','3','正在整改','未整改') rectification_state,hd.rectification_measures,oi.org_abbreviation org_name,oi1.org_abbreviation second_name from bgp_hse_hidden_information hi left join bgp_hidden_information_detail hd on hi.hidden_no = hd.hidden_no and hd.bsflag = '0' left join comm_org_subjection os on hi.org_sub_id = os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'  left join comm_org_subjection os1 on hi.second_org = os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0'  where hi.bsflag = '0' and( hd.rectification_state = '2' or hd.rectification_state is null)  and hi.project_no = '<%=project_info_no%>'  order by hi.modifi_date desc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=10000&querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas!=null||datas!=""){
			if(datas.length==0){
				toAddLine("","","","","","","");
			}else{
				for (var i = 0; i<datas.length; i++) {		
					toAddLine(
							datas[i].hidden_description ? datas[i].hidden_description : "",
							datas[i].hidden_level ? datas[i].hidden_level : "",
							datas[i].rectification_state ? datas[i].rectification_state : "",
							datas[i].rectification_measures ? datas[i].rectification_measures : "",
							datas[i].org_name ? datas[i].org_name : "",
							datas[i].second_name ? datas[i].second_name : "",
						    datas[i].hidden_name ? datas[i].hidden_name : ""
						);
				}
			}
		}else{
			toAddLine("","","","","","","");
		}
	}
</script>
</html>

