<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//增加，修改标志
	String flag=request.getParameter("flag");
	//id
	String id=request.getParameter("id"); 
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
  <title>编辑设备信息（长期待摊费用表）</title> 
 </head>
<body style="background:#cdddef">
	<form name="form1" id="form1" method="post" action="<%=contextPath%>/dms/plan/devManager/saveOrUpdateConfigDevInfo.srq?flag=<%=flag%>"   enctype="multipart/form-data">
		<!-- 主键 -->
		<input  type ="hidden" id="devname_config_id" name="devname_config_id" class="input_width" />
		<div id="new_table_box" >
			<div id="new_table_box_content">
		    	<div id="new_table_box_bg" >
			  		<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  			<tr>
				  			<td class="inquire_item6">设备名称：</td>
							<td class="inquire_form6">
								<input id="dev_name" name="dev_name"  class="input_width" type="text"/>
							</td>
						  	<td class="inquire_item6">关联设备编码：</td>
							<td class="inquire_form6">
								<input id="relation_dev_code" name="relation_dev_code" class="input_width"  type="text" readonly/>
								<img width="16" height="16" style="cursor: hand;" onclick="selectDevCode()" src="<%=contextPath%>/images/magnifier.gif"/>
							</td>
					  		
					  </tr>
			 		</table>
				</div>
				<div id="oper_div">
					<span class="tj_btn">
					<a href="###" onclick="submitInfo()"></a> 
					</span>
					<span class="gb_btn"><a href="###" onclick="newClose()"></a></span>
				</div>
	    	</div>
		</div>
	</form>
</body> 
<script type="text/javascript" charset="utf-8"> 
	var flag='<%=flag%>';
	var id='<%=id%>';
	$(function(){
		//修改
		if(flag=="update"){
			var retObj = jcdpCallService("YearPlanSrv", "getConfigDevInfo", "id="+id);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".input_width").each(function(){
					var temp = this.id;
					$("#"+this.id).val(data[temp] != undefined ? data[temp]:"");
				});
			}
		}
	});
	//提交
	function submitInfo(){
		document.getElementById("form1").submit();
	}
	//关联设备编码
	function selectDevCode(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/dmsManager/plan/devManager/selectDev.jsp",obj,"dialogWidth=550px;dialogHeight=480px");
		if(typeof vReturnValue!="undefined"){
			$("#relation_dev_code").val(vReturnValue);
		}
	}

</script>
</html>
 