<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>';

var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['bgp_comm_human_receive_process']
);
var defaultTableName = 'bgp_comm_human_receive_process';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.openerUrl = "/rm/singleHuman/humanRequest/taskPlanList.jsp";
	cru_init();
	
}

</script>
</head>
<body onload="page_init();" style="overflow-y:auto">
<form id="CheckForm" action="" method="post" target="list" >
	<div>
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
            <td class="bt_info_odd" width="5%">序号</td>
            <td class="bt_info_even" width="8%">员工姓名</td>
            <td class="bt_info_odd" width="10%">班组</td>		
            <td class="bt_info_even" width="10%">岗位</td>
            <td class="bt_info_odd" width="12%">实际进入项目时间</td>			
            <td class="bt_info_even" width="12%">实际离开项目时间</td> 
            <td class="bt_info_odd" width="10%">用工类型</td>			
            <td class="bt_info_even" width="10%">学历</td> 
        </tr>
       <% if(resultMsg != null){
		List<MsgElement> list = resultMsg.getMsgElements("datas");
		if(list != null){
			for(int i=0;i<list.size();i++){				
				MsgElement msg = (MsgElement)list.get(i);
				Map map = msg.toMap();
				String className = "";
				if (i % 2 == 0) {
					className = "odd_";
				} else {
					className = "even_";
				}
		%>
		   <tr>				   
		   	<td class="<%=className%>odd"><%=i+1%></td>
		   	<td class="<%=className%>even"><%=map.get("employee_name")==null?"":map.get("employee_name")%></td>
		   	<td class="<%=className%>odd"><%=map.get("team_name")==null?"":map.get("team_name")%></td>
		   	<td class="<%=className%>even"><%=map.get("work_post_name")==null?"":map.get("work_post_name")%></td>
		   	<td class="<%=className%>odd"><%=map.get("actual_start_date")==null?"":map.get("actual_start_date")%></td>
		   	<td class="<%=className%>even"><%=map.get("actual_end_date")==null?"":map.get("actual_end_date")%></td>
		   	<td class="<%=className%>odd"><%=map.get("employee_gz_name")==null?"":map.get("employee_gz_name")%></td>
		   	<td class="<%=className%>even"><%=map.get("employee_education_level")==null?"":map.get("employee_education_level")%></td>
		   </tr>				   				   				   
		<%
			}			
		}		
	}%>
     </table>
	</div>  
</form>
</body>
</html>
