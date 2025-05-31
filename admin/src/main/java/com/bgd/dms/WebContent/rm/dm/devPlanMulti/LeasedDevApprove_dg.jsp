<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>多项目-计划审批-外租设备申请-审批(大港)</title>
 </head>

 <body style="background:#fff" >
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">审批状态</td>
			    <td class="ali_cdn_input">
			    <select id="isdone" class="input_width">
			    	<option value="0">待审批</option>
			    	<option value="1">已审批</option>
			    </select>
			    </td>

	       			<td class="ali_cdn_name">项目名称</td>
			    	<td class="ali_cdn_input"><input type="text" id="projectName" name="projectName"/></td>		    
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
				<td>&nbsp;</td>
			    <auth:ListButton  css="dk" event="onclick='toAudit()'" title="JCDP_btn_audit"></auth:ListButton>
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
			      <td>项目名称</td>
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
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">审批流程</a></li>
			</ul>
		</div>
		
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
							class="tab_line_height" width="100%" style="background: #efefef">
						<tr>	 
		 					<td class="bt_info_even">序号</td>   
							<td class="bt_info_odd">项目名称</td>
							<td class="bt_info_even">班组</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">申请数量</td>
							<td class="bt_info_even">申请人</td>
							<td class="bt_info_odd">用途</td>
							<td class="bt_info_even">计划开始时间</td>
							<td class="bt_info_odd">计划结束时间</td>							
						</tr>
					</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none">
				<wf:startProcessInfo title=""/>
			</div>
		</div>
</body>

<script type="text/javascript">

$(document).ready(readyForSetHeight);
frameSize();	
$(document).ready(lashen);
</script>
</html>