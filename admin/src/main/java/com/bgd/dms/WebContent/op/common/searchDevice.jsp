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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>


<title>信息查询</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">   
      <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1" class="tab_line_height">
        <tr>  
          <td class="inquire_item4">设备名称:</td>
          <td class="inquire_form4"><input id="dev_name"  name="dev_name" value="" class="input_width" type="text" /></td>
          <td class="inquire_item4">自编号:</td>
          <td class="inquire_form4"><input id="dev_self" name="dev_self" value="" class="input_width"  type="text"/></td>
        </tr>
        <tr>
          <td class="inquire_item4">牌照号:</td>
          <td class="inquire_form4"><input id="license_num" name="license_num" value="" class="input_width"  type="text"/></td>
          <td class="inquire_item4">实物标识号:</td>
          <td class="inquire_form4"><input id="dev_sign" name="dev_sign" value="" class="input_width"  type="text"/></td>
        </tr>
        <tr>
          <td class="inquire_item4">AMIS资产编号:</td>
          <td class="inquire_form4"><input id="asset_coding" name="asset_coding" value="" class="input_width"  type="text"/></td>
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
	var dev_name = $("#dev_name").val();
	var dev_self = $("#dev_self").val();
	var dev_sign = $("#dev_sign").val();
	var asset_coding = $("#asset_coding").val();
	var license_num = $("#license_num").val();
	var str = "";
	
	if(dev_name!=''){
		str = str + "&devName="+dev_name;
	}
	if(dev_self!=''){
		str = str + "&devSelf="+dev_self;
	}
	if(dev_sign!=''){
		str = str + "&devSign="+dev_sign;
	}
	if(asset_coding!=''){
		str = str + "&assetCoding="+asset_coding;
	}
	if(license_num!=''){
		str = str + "&licenseNum="+license_num;
	}
 	top.frames('list').popSearch(str);
	newClose();
	 
}

 
 
</script>
</html>

