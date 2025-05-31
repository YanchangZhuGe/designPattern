<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//String oil_info_id=request.getParameter("oil_info_id");
	String dev_acc_id = request.getParameter("ids");
	String projectInfoNo = user.getProjectInfoNo();	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>定人定机(综合物化探)</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:380px">
      <fieldset><legend>定人定机</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="project_name" name="project_name"  class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
				<input id="team_dev_id" name="team_dev_id" class="input_width"  type="hidden" readonly/>
			</td>
		  </tr>
		  <tr>		 	
		  	<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			</td>			
		  </tr>
		  <tr>
		  	<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">实物标识号</td>
			<td class="inquire_form6"><input name="dev_sign" id="dev_sign"  class="input_width" type="text" readonly /></td>
		  </tr>
	  </table>	  
	  </fieldset>
	  <!-- <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td>&nbsp;</td>
		    	<auth:ListButton functionId="" css="zj" event="onclick='addrow()'" title="增加"></auth:ListButton>
		    	<auth:ListButton functionId="" css="sc" event="onclick='removrow()'" title="删除"></auth:ListButton>
			</tr>
		  </table>
	  </div> -->
	  <fieldset><legend>操作手</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body">
		  		<tr>
			  		<td class="inquire_item6">操作手1</td>
					<td class="inquire_form6">
						<input name="operator_id" id="operator_id"  class="input_width" type="hidden" />
						<input name="operator_name" id="operator_name"  class="input_width" type="text" />
						<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgPage(this)" />
					</td>
				</tr>
			</tbody>
	  	</table>
	  </fieldset>
	</div>
	<div id="oper_div" style="margin-bottom:5px">
		<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	</div>
    </div>   
</div>
</form>
</body>
<script type="text/javascript"> 
	var devaccid='<%=dev_acc_id%>';
	var projectiniono='<%=projectInfoNo%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
		
	function submitInfo(){
		if(confirm("确认提交？")){			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toZHDevOperator.srq?state=9&ids="+devaccid+"&projectno="+projectiniono;
			document.getElementById("form1").submit();
		}
	}
		
	function loadDataDetail(){
		var querySql = "select t.team_dev_acc_id,emp.employee_name as operator_name,emp.employee_id,acc.dev_name,acc.dev_model,";
			querySql += "acc.self_num,acc.license_num,acc.dev_sign,pro.project_name ";
			querySql += "from gms_device_appmix_detail t ";
			querySql += "left join gms_device_equipment_operator oper on t.dev_acc_id = oper.fk_dev_acc_id and oper.project_info_id = t.project_no and oper.bsflag='0' ";
			querySql += "left join comm_human_employee emp on emp.employee_id = oper.operator_id ";
			querySql += "left join gms_device_account acc on t.dev_acc_id = acc.dev_acc_id ";
			querySql += "left join gp_task_project pro on t.project_no = pro.project_info_no ";
			querySql += "where acc.dev_acc_id ='"+devaccid+"' and t.project_no ='"+projectiniono+"' " ;
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		$("#dev_name")[0].value=basedatas[0].dev_name;
		$("#dev_model")[0].value=basedatas[0].dev_model;
		$("#self_num")[0].value=basedatas[0].self_num;
		$("#license_num")[0].value=basedatas[0].license_num;
		$("#dev_sign")[0].value=basedatas[0].dev_sign;
		$("#project_name")[0].value=basedatas[0].project_name;
		$("#team_dev_id")[0].value=basedatas[0].team_dev_acc_id;
		removrow();
		for(var i=0;i<basedatas.length;i++){
			var arrayObj = {"label":basedatas[i].operator_name,"value":basedatas[i].employee_id}; 
			addrow(arrayObj);
		}			
	}

	var optnum=1;
	function addrow(obj){
		
		optnum++;
		
		var newTr=OPERATOR_body.insertRow();
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="操作手"+optnum;
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		if(obj==undefined){
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden  /><input name=operator_name id=operator_name  class=input_width type=text /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
		}else{
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden value='"+obj.value+"'  /><input name=operator_name id=operator_name  class=input_width type=text value='"+obj.label+"'  readonly /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
		}
		
	}
	
	function removrow(){		
		if(optnum>0){
			$("#OPERATOR_body  tr:last").remove(); 
			optnum--;
		}		
	}
		
	function showOrgPage(oo){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/device-xd/selectOutOrgId.jsp?PROJECT_INFO_ID="+projectiniono,obj,"dialogWidth=305px;dialogHeight=420px");
		
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var ips=oo.parentNode.getElementsByTagName("input");
			ips
			ips[0].value=returnvalues[0];
			ips[1].value=returnvalues[1];
		}
	}
</script>
</html>
 