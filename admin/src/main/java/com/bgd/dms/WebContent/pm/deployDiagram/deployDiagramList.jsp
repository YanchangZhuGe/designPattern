<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>部署图列表</title>
</head>
<body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_query" width="80%"></td>
			    <td  width="10%">&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='object_id_{object_id}' name='object_id' idinfo='{object_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}' id='rdo_entity_id_{file_id}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="<a href='#'  onclick=viewImage('{ucm_id}')>{file_name}</a>">文档名称</td>
			      <td class="bt_info_odd" exp="{employee_name}">创建人</td>
			      <td class="bt_info_even" exp="{upload_date}">创建时间</td>
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
</div>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var projectInfoNo = "<%=projectInfoNo%>";
function refreshData(){
	
	cruConfig.queryStr = " select t.* from ( select t.file_id,t.file_name,t.ucm_id,to_char(t.upload_date,'yyyy-MM-dd') upload_date,e.employee_name,t.project_info_no,p.project_name from bgp_doc_gms_file t left join comm_human_employee e on t.creator_id=e.employee_id and e.bsflag='0' left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0'  where t.bsflag='0' and t.doc_type='0110000061000000075'  and t.project_info_no = '<%=projectInfoNo %>' order by t.upload_date desc ) t where 1=1  ";
	queryData(1);
}


function toDelete(){
	var ids = getSelIds('rdo_entity_id');
	if(ids==''){ alert("请先选中一条记录!");
	     	return;
	}
	if(confirm('确定要删除吗?')){  
		var retObj = jcdpCallService("DeployDiagramSrv", "deleteDeployDiagram", "objectIds="+ids);
		queryData(cruConfig.currentPage);
	}
	if(retObj.actionStatus=='ok'){
		alert("删除操作成功!");
	}
}

function viewImage(objId){
	popWindow("<%=contextPath%>/pm/deployDiagram/view.jsp?objectId="+objId);
}
</script>
</html>