<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page  import="java.util.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String	projectInfoNo=request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	String	projectName= request.getParameter("projectName")==null?user.getProjectName():java.net.URLDecoder.decode(request.getParameter("projectName"),"utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>项目资源补充配置方案</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
</head>
<body>
	<form name="form" id="form" method="post" action="<%=contextPath%>/ws/pm/project/test2.srq">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>申请理由：</td>
						            <td class="inquire_form4" colspan="3">
						            	<textarea name="shenText" id="shenText" rows="8" cols="33"></textarea>
						            </td>
								</tr>
								<!-- <tr>
						          <td class="inquire_item4">配置补充计划单名称：</td>
						          <td class="inquire_form4" colspan="3">
						          	<input name="device_addapp_name" id="device_addapp_name" class="input_width" type="text" value="" />
						          </td>
						        </tr> -->
							</table>
						</div>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
	</form>
	
<script type="text/javascript">
var projectInfoNo="<%=projectInfoNo%>";
var projectName="<%=projectName%>";
	function save(){
		if (!isTextPropertyNotNull("shenText", "申请理由")) return false;
		
		var shenText=document.getElementById("shenText").value;
		//--------------------------------生成人力补充配置主表ID planId.planId ------------------------------
		var shenText=document.getElementById("shenText").value;
		
		//alert(retObj.device_addapp_id);

		//------------------------------生成中间表-----------------------------
		debugger;
		var retObj = jcdpCallService("WtProjectSrv","saveMiddleResources","supplyflag=0&memo="+shenText+"&project_info_no="+projectInfoNo);
		//top.frames('list').refreshData();
		parent.list.frames[1].location.reload();
		//popWindow("<%=contextPath%>/pm/project/multiProject/wt/resourcesSupplyFrame.jsp?projectInfoNo="+projectInfoNo+"&mid="+retObj.mid,"900:750");
		window.location.href="<%=contextPath%>/pm/project/multiProject/wt/resourcesSupplyFrame.jsp?projectInfoNo="+projectInfoNo+"&mid="+retObj.mid;
	}

</script>
</body>
</html>