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
	String projectInfoNo = user.getProjectInfoNo();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());

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
          <td class="inquire_item4">设备名称:</td>
          <td class="inquire_form4"><input id="s_dev_name"  name="s_dev_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">自编号:</td>
          <td class="inquire_form4"><input id="s_self_num" name="s_self_num" class="input_width"  type="text"/></td>
        </tr>
        <tr>
          <td class="inquire_item4">牌照号:</td>
          <td class="inquire_form4"><input id="s_license_num"  name="s_license_num" class="input_width" type="text" /></td>
          <td class="inquire_item4">创建人:</td>
          <td class="inquire_form4"><input id="s_user_name"  name="s_user_name" class="input_width" type="text" /></td>
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
	var str ='';
	str +="select t.teammat_out_id,t.procure_no,t.total_money,t.outmat_date,t.device_use_name,c.dev_name,c.self_num,c.license_num,t.create_date,u.user_name from gms_mat_teammat_out t left join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' left join gms_device_account_dui c on t.dev_acc_id = c.dev_acc_id where t.out_type='3' and t.bsflag='0'and t.project_info_no='<%=projectInfoNo%>'";
	
	var s_dev_name = document.getElementById("s_dev_name").value;
	var s_self_num = document.getElementById("s_self_num").value;
	var s_license_num = document.getElementById("s_license_num").value;
	var s_user_name = document.getElementById("s_user_name").value;
	
	if(s_dev_name!=''){
		str +="and c.dev_name like '%"+s_dev_name+"%'";
	}
	if(s_self_num!=''){
		str +="and c.self_num like '%"+s_self_num+"%'";
	}
	if(s_license_num!=''){
		str +=" and c.license_num like '%"+s_license_num+"%'";
	}
	if(s_user_name!=''){
		str +="and t.use_user like '%"+s_user_name+"%'";
	}
	str +=" order by t.outmat_date desc";
	parent.frames['list'].popSearch(str);
	newClose();
	 
}

 
 
</script>
</html>

