<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>信息查询</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">   
      <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1" class="tab_line_height">
        <tr>  
          <td class="inquire_item4">自编号:</td>
          <td class="inquire_form4"><input id="s_self_num" name="s_self_num" class="input_width"  type="text"/></td>
          <td class="inquire_item4">牌照号:</td>
          <td class="inquire_form4"><input id="s_license_num"  name="s_license_num" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">实物标识号:</td>
          <td class="inquire_form4"><input id="s_dev_sign"  name="s_dev_sign" class="input_width" type="text" /></td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
        </tr>
      </table>
     
    </div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
  </div>
</div>
</body>
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

function refreshData(){
	var str = "select mp.fk_dev_acc_id,max(mp.plan_num) plan_num,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign from gms_device_maintenance_plan mp ";
	str+="left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id where acc.bsflag='0' and acc.owning_sub_id like '<%=orgSubId%>%'  ";
	
	var s_self_num = document.getElementById("s_self_num").value;
	var s_license_num = document.getElementById("s_license_num").value;
	var s_dev_sign = document.getElementById("s_dev_sign").value;
	if(s_self_num!=''){
		str +="and acc.self_num like '%"+s_self_num+"%'";
	}
	if(s_license_num!=''){
		str +=" and acc.license_num like '%"+s_license_num+"%'";
	}
	if(s_dev_sign!=''){
		str +="and acc.dev_sign like '%"+s_dev_sign+"%'";
	}
	str +="group by fk_dev_acc_id,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign ";
	parent.frames['list'].popSearch(str);
	newClose();
}
 
 
</script>
</html>

