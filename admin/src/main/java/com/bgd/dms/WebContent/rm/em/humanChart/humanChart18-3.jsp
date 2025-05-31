<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	String team = "";
	if(request.getParameter("team") != null && !"".equals(request.getParameter("team"))){
		team = request.getParameter("team");
	}
	
	String postSort = "";
	if(request.getParameter("postSort") != null && !"".equals(request.getParameter("postSort"))){
		postSort = request.getParameter("postSort");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
<style type="text/css">
.select_height{height:20px;margin:0,0,0,0;}
SELECT {
	margin-bottom:0;
    margin-top:0;
	border:1px #52a5c4 solid;
	color: #333333;
	FONT-FAMILY: "微软雅黑";font-size:9pt;
}
.tongyong_box_title {
	width:100%;
	height:auto;
	background:url(<%=contextPath%>/dashboard/images/titlebg.jpg);
	text-align:left;
	text-indent:12px;
	font-weight:bold;
	font-size:14px;
	color:#0f6ab2;
	line-height:22px;
}
</style>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%">
						<div class="tongyong_box" >
						<div class="tongyong_box_title" ><span class="kb"><a
							href="#">人员列表</a></span>
							<span class="gd"><a href="#"></a></span>
							
							</div>
						<div id="chartContainer1" style="height: 400px;">
			 				<table id="humanDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" >
					    	<tr class="bt_info">
					    	    <td>序号</td>
					    	    <td>姓名</td>
					            <td>班组</td>
					            <td>岗位</td>		
					            <td>进入项目时间</td>	
					            <td>离开项目时间</td>	
					        </tr>            
				           </table>
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">

 var team = '<%=team%>';
 var postSort = '<%=postSort%>';
 function getFusionChart(){
	 
		var querySql = "select rownum ,t.* from (select p.* from ( select p.EMPLOYEE_ID, p.EMPLOYEE_NAME,p.employee_gz, d1.coding_name team_name,d2.coding_name work_post_name,p.ACTUAL_START_DATE,p.ACTUAL_END_DATE   from view_human_project_relation p  left join comm_coding_sort_detail d1 on p.TEAM = d1.coding_code_id   left join comm_coding_sort_detail d2 on p.WORK_POST = d2.coding_code_id  where p.project_info_no = '<%=projectInfoNo%>'  ";
		
		if(team != ''){
			querySql+="and ( p.WORK_POST ='<%=team%>' or p.TEAM = '<%=team%>' )";
		}
		
		querySql+="and p.EMPLOYEE_GZ in ('0110000019000000001','0110000019000000002') ) p ) t join comm_human_employee_hr h on t.EMPLOYEE_ID=h.employee_id and h.post_sort is not null ";
		
		if(postSort != ''){
			querySql += " where h.post_sort ='"+postSort+"'";
		}
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("humanDetailList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var employee_id = datas[i].employee_id;
				var employee_gz = datas[i].employee_gz;
				
				var td = tr.insertCell(1);
				td.innerHTML = "<a href=javascript:commHumanView('"+employee_id+"-"+employee_gz+"')>"+datas[i].employee_name+"</a>";
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].team_name;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].work_post_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].actual_start_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].actual_end_date;

			}
		}

}
  
	
 function commHumanView(ids){

	 popWindow('<%=contextPath%>/rm/em/humanChart/commHumanView.jsp?ids='+ids,'800:700');
 }

 
</script>  
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
</script>
</html>

