<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	String businessType=request.getParameter("businessType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>项目费用方案管理</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
					    <td>&nbsp;</td>
			    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{node_config_id}' id='rdo_entity_id_{node_config_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{business_node_type}">小类名称</td>
			      <td class="bt_info_even" exp="{node_type_name}">挂靠类型</td>
			      <td class="bt_info_odd" exp="{node_link}">挂靠链接</td>
			      <td class="bt_info_even" exp="{node_link_param}">挂靠参数</td>
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
			<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">标签1</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">标签2</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">标签3</a></li>
				    <li id="tag3_3"><a href="#" onclick="getTab3(3)">标签4</a></li>
				    <li id="tag3_4"><a href="#" onclick="getTab3(4)">标签5</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box" style="overflow:hidden;">
				    <div id="tab_box_content0" class="tab_box_content">
				    </div>
				    <div id="tab_box_content1" class="tab_box_content">
				    </div>
				    <div id="tab_box_content2" class="tab_box_content">
				    </div>
				    <div id="tab_box_content3" class="tab_box_content">
				    </iframe>
				    </div>
				    <div id="tab_box_content4" class="tab_box_content">
				    </div>
			</div>
</body>

<script type="text/javascript">
	$(document).ready(readyForSetHeight);
	frameSize();
	$(document).ready(lashen);
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	var businessType = '<%=businessType%>';
	
	function refreshData(){
		cruConfig.queryStr = "select t.*,decode(t.node_link_type,'0','公共审批页面','自定义审批页面') node_type_name from common_busi_node_config_dms t WHERE t.bsflag=0 and  t.config_id='"+businessType+"'";
		cruConfig.currentPageUrl = "/pm/bpm/common/procTypeList.jsp";
		queryData(1);
	}
	function toView(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/bpm/common/businessWFNodeConfig.upmd?pagerAction=edit2View&id='+ids);
	}
	function toAdd(){
		popWindow('<%=contextPath%>/pm/bpm/common/businessWFNodeConfig.upmd?pagerAction=edit2Add&config_id=<%=businessType%>');
		//popWindow('<%=contextPath%>/pm/bpm/common/businessWFNodeConfig.jsp?pagerAction=edit2Add&config_id=<%=businessType%>');
	}

	
	function toEdit() {
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/bpm/common/businessWFNodeConfig.upmd?pagerAction=edit2Edit&config_id=<%=businessType%>&id='+ids);
	}
	function toDelete(){

		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update common_busi_node_config_dms t set t.bsflag='1' where t.node_config_id ='"+ids+"'";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		refreshData();
	}

	function loadDataDetail(ids){
		
	}
	
</script>
</html>