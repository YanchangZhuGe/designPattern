<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String org_sub_id = request.getParameter("org_sub_id");
	
	System.out.println(org_sub_id);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body>
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
				     	<td class="inquire_item4">队伍名称：</td>
				      	<td class="inquire_form4">
				      	<input type="text" id="org_name" name="org_name" class="input_width" />
				      	</td>
				     	<td class="inquire_item4">队伍简称：</td>
				      	<td class="inquire_form4">
				      	<input type="text" id="org_abbreviation" name="org_abbreviation" class="input_width" />
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item4">队伍同意编号：</td>
				      	<td class="inquire_form4"><input type="text" id="team_id" name="team_id" class="input_width" /></td>
				     	<td class="inquire_item4">队伍类型：</td>
				      	<td class="inquire_form4">
				      	<select id="team_specialty" name="team_specialty" class="select_width" disabled="disabled">
					       <%
					          	String sql = "SELECT t.coding_code_id ,t.coding_name  FROM comm_coding_sort_detail t where t.superior_code_id='0100100015000000028' and t.bsflag='0' order by t.coding_show_id";
					          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					          	for(int i=0;i<list.size();i++){
					          		Map map = (Map)list.get(i);
					          		String coding_id = (String)map.get("codingCodeId");
					          		String coding_name = (String)map.get("codingName");
					       %>
					       <option value="<%=coding_id %>" ><%=coding_name %></option>
					       <%} %>
						</select>
				      	</td>
				     </tr>
				     <tr>
				     	<td class="inquire_item4">队经理：</td>
				      	<td class="inquire_form4"><input type="text" id="headerName" name="headerName" class="input_width" /></td>
				    	<td class="inquire_item4">基地：</td>
				      	<td class="inquire_form4">
							<input type="text" id="team_base" name="team_base" class="input_width"/>
				      	</td>
				     </tr>
				     <tr>
				    	<td class="inquire_item4">组建时间：</td>
				      	<td class="inquire_form4"><input type="text" id="comp_date" name="comp_date" class="input_width" /></td>
				     	<td class="inquire_item4">是否重点队：</td>
				      	<td class="inquire_form4">
				      	<select id="if_majorteam" name="if_majorteam" class="select_width" disabled="disabled">
					        <option value="0">不是重点队</option>
  							<option value="1">重点队</option>
						</select>
				      	</td>
				     </tr>
				      <tr>
				    	<td class="inquire_item4">是否在册：</td>
				      	<td class="inquire_form4">
					      	<select id="if_registered" name="if_registered" class="select_width" disabled="disabled">
						        <option value="0">不在册</option>
  								<option value="1">在册</option>
							</select>
				      	</td>
				     	<td class="inquire_item4">当前状态：</td>
				      	<td class="inquire_form4">
				      	<select id="cur_state" name="cur_state" class="select_width" disabled="disabled">
				      	 <%
					          	String sql2 = "SELECT t.coding_code_id ,t.coding_name  FROM comm_coding_sort_detail t where t.coding_sort_id='0100600003' and t.bsflag='0' order by t.coding_show_id";
					          	List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
					          	for(int i=0;i<list2.size();i++){
					          		Map map2 = (Map)list2.get(i);
					          		String coding_id = (String)map2.get("codingCodeId");
					          		String coding_name = (String)map2.get("codingName");
					       %>
					       <option value="<%=coding_id %>" ><%=coding_name %></option>
					       <%} %>
					       
						</select>
				      	</td>
				     </tr>
				      <tr>
				    	<td class="inquire_item4">当前工作位置：</td>
				      	<td class="inquire_form4"><input type="text" id="curr_position" name="curr_position" class="input_width" /></td>
				     	<td class="inquire_item4">显示序号：</td>
				      	<td class="inquire_form4">
				      		<input type="text" id="coding_show_id" name="coding_show_id" class="input_width" />
				      	</td>
				     </tr>
				      <tr>
				    	<td class="inquire_item4">电子邮箱：</td>
				      	<td class="inquire_form4"><input type="text" id="email" name="email" class="input_width"/></td>
				     	<td class="inquire_item4">联系电话：</td>
				      	<td class="inquire_form4">
				      		<input type="text" id="phone_num" name="phone_num" class="input_width" />
				      	</td>
				     </tr>
				      <tr>
				    	<td class="inquire_item4">通讯地址：</td>
				      	<td class="inquire_form4"><input type="text" id="post_address" name="post_address" class="input_width" /></td>
				     	<td class="inquire_item4">邮政编码：</td>
				      	<td class="inquire_form4">
				      		<input type="text" id="post_code" name="post_code" class="input_width" />
				      	</td>
				     </tr>
				      <tr>
				    	<td class="inquire_item4">队伍描述：</td>
				      	<td class="inquire_form4">
				      		<textarea id="org_desc" name="org_desc" class="textarea"></textarea>
				      	</td>
				     </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
toEdit();
function toEdit(){
	var checkSql="select oi.*,os.org_subjection_id,os.father_org_id,os.start_date,os.end_date,os.code_afford_if,os.code_afford_org_id,os.coding_show_id,ot.team_id,ot.team_specialty,ot.operation_field,ot.header,ot.team_base,ot.comp_date,ot.if_majorteam,ot.if_registered,ot.cur_state,ot.curr_position,che.employee_name as header_name from comm_org_information oi left join comm_org_subjection os on oi.org_id = os.org_id and os.bsflag='0' left join  comm_org_team ot on ot.org_id = oi.org_id and ot.bsflag='0' left join comm_human_employee che on ot.header = che.employee_id and che.bsflag='0' where oi.bsflag='0' and os.org_subjection_id = '<%=org_sub_id%>'";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas==null||datas==""){
	}else{
		document.getElementById("org_name").value=datas[0].org_name;
		document.getElementById("org_abbreviation").value=datas[0].org_abbreviation;
		document.getElementById("team_id").value=datas[0].team_id;
		document.getElementById("team_specialty").value=datas[0].team_specialty;
		document.getElementById("headerName").value=datas[0].header_name;
		document.getElementById("team_base").value=datas[0].team_base;
		document.getElementById("comp_date").value=datas[0].comp_date;
		document.getElementById("if_majorteam").value=datas[0].if_majorteam;
		document.getElementById("if_registered").value=datas[0].if_registered;
		document.getElementById("cur_state").value=datas[0].cur_state;
		document.getElementById("curr_position").value=datas[0].curr_position;
		document.getElementById("coding_show_id").value=datas[0].coding_show_id;
		document.getElementById("email").value=datas[0].email;
		document.getElementById("phone_num").value=datas[0].phone_num;
		document.getElementById("post_address").value=datas[0].post_address;
		document.getElementById("post_code").value=datas[0].post_code;
		document.getElementById("org_desc").value=datas[0].org_desc;
	}
} 

</script>
</html>