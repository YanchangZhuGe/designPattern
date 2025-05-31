<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.net.URLDecoder" %>
<%@taglib prefix="ep" uri="ep" %>
<%
	String contextPath = request.getContextPath(); 
	String project_info_id = request.getParameter("project_info_id");
	String project_name = request.getParameter("project_name");
	if(project_name != ""){
		project_name = URLDecoder.decode(project_name,"UTF-8");
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>项目组信息</title>
</head>
<body onload="refreshData()">
	<form name="form1" id="form1" method="post" action="<%=contextPath%>/wt/prointe/saveOrUpdatePerjPersonWt.srq">
		<div id="new_table_box">
		  <div id="new_table_box_content">
		    <div id="new_table_box_bg">
		    	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		    		<tr>		    
					    <td class="inquire_item4">项目名称：</td>
					    <td class="inquire_form4" colspan="3">
					    	<span class="label123" id="project_name" name="project_name"><%=project_name %></span> 
					    </td>
					</tr>
					<tr>		    
					    <td class="inquire_item4">创建人：</td>
					    <td class="inquire_form4" >
					    	<span class="label123" id="creator_name" name="creator_name"></span> 
					    </td>
					    <td class="inquire_item4">创建日期：</td>
					    <td class="inquire_form4" >
					    	<span class="label123" id="create_date" name="create_date"></span> 
					    </td>
					</tr>
		    	</table>
		    
		    	<div style="border-bottom:1px solid black;height:10px;margin-bottom:10px;"></div>
					<div id="list_table">
						<div id="inq_tool_box">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
				 				 <tr>
				   					 <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				   					 <td background="<%=contextPath%>/images/list_15.png">
				   					 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						 				 <tr>	
						   					 <td>&nbsp;</td>
								    		<TD class=ali_btn><SPAN class=zj><A title="增加一行" onclick='addRow()' href="#"></A></SPAN></TD>
						  				 </tr>
										</table>
									</td>
				    				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				  				</tr>
							</table>
						</div>
				
						<div id="table_box">
				 			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
						   		<tr>
							      <td class="bt_info_even" autoOrder="1" width="30px">序号</td> 
							      <td class="bt_info_odd"  width="150px"><FONT title=红色*表示此项必填 color=red>* </FONT>成员姓名</td>
							      <td class="bt_info_even" width="150px"><FONT title=红色*表示此项必填 color=red>* </FONT>组内职务</td>
							      <td class="bt_info_odd" width="150px">进入项目时间</td>
							      <td class="bt_info_even" width="150px">备注</td>
							      <td class="bt_info_odd"  width="30px">删除</td>
						    	</tr>
				 			 </table>
						</div>			
			 		</div>	
				</div>
			
			
			    <div id="oper_div">
			    	<auth:ListButton functionId="" css="bc_btn" event="onclick='toSubmit()'"></auth:ListButton>
			        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>        
			    </div>
			</div>
		</div> 
	</form>
</body>

<script type="text/javascript">
var myDate = new Date();
function refreshData(){	
	
var str = "select p.project_name,emp.EMPLOYEE_ID,emp.EMPLOYEE_NAME,pp.PROJPERSON_ID,pp.POSITION,pp.IN_PROJECT_DATE,pp.REMARK,pp.creator_name,to_char(pp.create_date,'yyyy-MM-dd') as create_date "
	+"from GP_OPS_PROINTE_PROJPERSON_WT pp "
	+"left join COMM_HUMAN_EMPLOYEE emp on emp.EMPLOYEE_ID=pp.PERSONNEL_ID and emp.BSFLAG='0' "
	+"right join gp_task_project p on p.project_info_no=pp.project_info_no and p.bsflag='0' " 
	+"where pp.PROJECT_INFO_NO='<%=project_info_id%>' and pp.bsflag='0' ";
	var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
	var retObj = detailRet.datas;
	$(retObj).each(function(index, obj){
		$('#create_date').html(obj['create_date']);
		$('#creator_name').html(obj['creator_name']);
		$('#project_name').html(obj['project_name']);
		addRow();
		$('#projpersonId' + index).val(obj['projperson_id']);
		$('#personnalId' + index).val(obj['employee_id']);
		$('#personnalName' + index).val(obj['employee_name']);
		$('#position' + index).val(obj['position']);
		$('#in_project_date' + index).val(obj['in_project_date']);
		$('#remark' + index).val(obj['remark']);
	});
}
	//提交表单
	function toSubmit(){
		var ids = document.getElementsByName("rowId");
		var rowIds = "";
	    for (i=0; i<ids.length; i++){   
	    	rowIds += "," + ids[i].value;
	    } 
	    rowIds = rowIds =="" ? "" : rowIds.substr(1);
		var str = $("#form1").serialize();		
		str+="&rowIds="+rowIds+"&project_info_id=<%=project_info_id %>";  	
		var result = jcdpCallService("WtProinteSrv", "saveOrUpdatePerjPersonWt", str);
		var ctt = top.frames('list');
		ctt.location.reload();
		newClose();
		
	}
	
	//添加一行
	var rowCount = 0;
	function addRow(){
		$("#queryRetTable").append("<tr id='tr"+rowCount+"'>" +
			"<td align='center'>"+(rowCount+1)+"<input name='rowId' type='hidden' value='"+rowCount+"' /><input id='projpersonId"+rowCount+"' name='projpersonId"+rowCount+"' type='hidden' value=''/></td>" + 
			"<td align='center'><input class='input_width hiddenDeptId'  type='hidden' id='personnalId" + rowCount + "' name='personnalId" + rowCount + "'  /> <input  class='input_width easyui-validatebox' id='personnalName" + rowCount + "' name='personnalName" + rowCount + "' fkValue='' required readonly data-options=tipPosition:'bottom' /> <img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='selectPerson(" + rowCount + ")'/></td>" + 			
			"<td align='center'><select id='position" + rowCount + "' name='position" + rowCount + "' class='input_width easyui-validatebox'  data-options=tipPosition:'bottom' required  style='height:25px;'><option value='''>请选择</option><option value='5110000143000000002'>项目长</option><option value='5110000143000000003'>主任工程师</option><option value='5110000143000000004'>副项目长</option><option value='5110000143000000005'>处理员</option><option value='5110000143000000006'>解释员</option></select></td>" + 
			"<td align='center'><input id='in_project_date" + rowCount + "' name='in_project_date" + rowCount + "' class='input_width ' readonly /><img width='20' height='22' id='cal_button" + rowCount + "' style='cursor: hand;' onmouseover='calDateSelector(in_project_date" + rowCount + ",cal_button" + rowCount + ");' src='<%=contextPath %>/images/calendar.gif' /></td>" + 
			"<td align='center'><INPUT class='input_width ' name='remark" + rowCount + "' id='remark" + rowCount + "' value='' ></td>" + 
			"<td align='center'><SPAN class=sc><A title='删除本行' onclick='deleteRow(" + rowCount + ");return false;' href='#' style='background:url(\"<%=contextPath%>/images/images/sc.png\") no-repeat;'></A></SPAN><input type='hidden' class='hiddenIndexesId' id='indexes_id-" + rowCount + "' name='indexes_id-" + rowCount + "' value=''/></td>" + 
			"</tr>");
		rowCount++;
	}
	
	//删除单行
	function deleteRow(rowNum){
		$("#tr"+rowNum).remove();
	}
	
	function selectPerson(index){
	    var teamInfo = {
	            fkValue:"",
	            value:""
	        };
	        window.showModalDialog('<%=contextPath%>/wt/prointe/selectOrgHrWt.jsp?select=employeeId',teamInfo);
	        if(teamInfo.fkValue!=""){
		        $("#personnalId"+index).val(teamInfo.fkValue);
		        $("#personnalName"+index).val(teamInfo.value);
	      	 }
	}
</script>
</html>