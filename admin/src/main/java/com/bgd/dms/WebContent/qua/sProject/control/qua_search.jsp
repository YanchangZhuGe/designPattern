<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript">
	function page_init(){
		cruConfig.contextPath = '<%=contextPath%>';
		var retObj = jcdpCallService("QualityItemsSrv", "getQualityType", "qualityType=''");
		if(retObj!=null){
			var selObj = document.getElementById("quality_type");
			if(selObj!=null){
				for(var i=0;retObj.qualityType[i]!=null;i++){
					selObj.options[i+1] = 
						new Option(retObj.qualityType[i].label,retObj.qualityType[i].value);
				}
			}
		}
	}
	
	function getRecordType(){
		var value = document.getElementById("quality_type").options.value;
		var selectObj=$("#quality_type");
		var selectName=selectObj.val();
		if(value!=null &&value!='0'){
			var retObj = jcdpCallService("QualityItemsSrv", "getRecordType", "qualityType="+value);
			var selObj = document.getElementById("record_type");
			for(var i=0;selObj.options[i]!=null;){
				selObj.options[i] = null;
			}
			for(var i=0;retObj.recordType[i]!=null;i++){
				selObj.options[i] = 
					new Option(retObj.recordType[i].codingName,retObj.recordType[i].codingCodeId);
			}
		}
		else{
			var selObj = document.getElementById("record_type");
			for(var i=0;selObj.options[i]!=null;){
				selObj.options[i] = null;
			}
		}
	}
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3" onload="page_init()">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">质量检查项类型:</td>
          <td class="inquire_form4">
			<select id="quality_type" name="quality_type" onchange="getRecordType()">
    			<option value="0">请选择</option>
    		</select>
			</td>
          <td class="inquire_item4">记录项类型:</td>
          <td class="inquire_form4">
			<select id="record_type" name="record_type">
				<option value="0">请选择</option>
    		</select>
			</td>
        </tr>
        <tr>
          <td class="inquire_item4">状态:</td>
          <td class="inquire_form4">
			<select id="status" name="status">
    			<option value="1">新建</option>
    			<option value="2">合格</option>
    			<option value="3">整改合格</option>
    			<option value="4">不合格</option>
    		</select>
			</td>
          <td class="inquire_item4">检查日期:</td>
          <td class="inquire_form4"><input name="check_date" type="text" value=""/>
    		<img width="16" height="16" id="cal_button6" style="cursor: hand;" 
    		onmouseover="calDateSelector(check_date,cal_button6);" 
    		src="<%=contextPath %>/images/calendar.gif" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">创建日期:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
          <td class="inquire_item4">创建人:</td>
          <td class="inquire_form4"><input name="" class="input_width" type="text" /></td>
        </tr>
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="refreshData()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>


</html>

