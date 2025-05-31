<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org").value; 
		var audit_date = document.getElementById("audit_date").value;  
		var audit_date2 = document.getElementById("audit_date2").value;   
 
		var isProject = "<%=isProject%>";
		var sql = ""; 
		if(isProject=="1"){
			// sql = getMultipleSql2("t."); 
		}else if(isProject=="2"){
			sql = "and t.project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = " select  ion.org_name,t.order_no,t.audit_unit,t.audit_date   from  BGP_NOACCORDWITH_ORDER t  join comm_org_subjection os1     on t.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id   where tr.bsflag='0'   "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and t.audit_unit = '"+org_sub_id+"'";
		}
		 
		if(plan_date!=''&&plan_date!=null){
			sql = sql+" and t.audit_date >= to_date('"+audit_date+"','yyyy-MM-dd')";
		}
		if(plan_date2!=''&&plan_date2!=null){
			sql = sql+" and t.audit_date <= to_date('"+audit_date2+"','yyyy-MM-dd')";
		}
		 
		sql = sql+" order by t.modifi_date desc";
 
		ctt.refreshData2(sql);
		newClose();
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
 
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
	        <td class="inquire_item6">被检查/审核单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	      	 <td class="inquire_item6">检查/审核日期：</td>
			  <td class="inquire_form6"><input type="text" id="audit_date" name="audit_date" class="input_width" readonly="readonly"/>
			  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(audit_date,tributton1);" />&nbsp;</td>
			  <td class="inquire_item6">至</td>
			  <td class="inquire_form6"><input type="text" id="audit_date2" name="audit_date2" class="input_width" readonly="readonly"/>
			  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(audit_date2,tributton2);" />&nbsp;</td>
	        </tr>
   
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>

