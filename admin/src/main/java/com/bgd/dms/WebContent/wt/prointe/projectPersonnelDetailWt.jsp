<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String project_info_id = request.getParameter("project_info_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>项目成员明细列表</title>
</head>
<body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			     	 <td class="bt_info_even" autoOrder="1">序号</td> 
			      	<td class="bt_info_odd" exp="{employee_name}">成员姓名</td>
					<td class="bt_info_even" exp="{position}" func="getOpValue,position_">组内职务</td>
					<td class="bt_info_odd" exp="{in_project_date}">参与项目时间</td>
					<td class="bt_info_even" exp="{remark}">备注</td>
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
			
		  </div>

</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
var position_ = new Array(
		['5110000143000000002','项目长'],['5110000143000000003','主任工程师'],['5110000143000000004','副项目长'],
		['5110000143000000005','处理员'],['5110000143000000006','解释员'],['','']	                 		
);

// 复杂查询
function refreshData(){
	var str = "select emp.EMPLOYEE_ID,emp.EMPLOYEE_NAME,pp.POSITION,pp.IN_PROJECT_DATE,pp.REMARK "
		+"from GP_OPS_PROINTE_PROJPERSON_WT pp "
		+"left join COMM_HUMAN_EMPLOYEE emp on emp.EMPLOYEE_ID=pp.PERSONNEL_ID and emp.BSFLAG='0'"
		+"where pp.PROJECT_INFO_NO='<%=project_info_id%>' and pp.bsflag='0' ";
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
}

function frameSize(){
	$("#table_box").css("height",$(window).height()*0.8);
}

$(function(){

	frameSize();
	$(window).resize(function(){
  		frameSize();
	});
	
});


</script>

</html>

