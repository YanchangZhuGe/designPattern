<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String add_mod_flag=request.getParameter("addmodflag");
	String devaccid = request.getParameter("ids");
	String fk_id = request.getParameter("fkid");
	
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
  <title>定人定机</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:705px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:380px">
      <fieldset><legend>定人定机</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="project_name" name="project_name"  class="input_width" type="text" readonly/>
				<input id="projectno" name="projectno" type ="hidden" value=""/>
			</td>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="devaccid" name="devaccid" type ="hidden" value="<%=devaccid%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
				<input id="fkdevaccid" name="fkdevaccid" class="input_width"  type="hidden" readonly/>
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
		  </tr>
	  </table>	  
	  </fieldset>
	  <div style="overflow:auto">
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
	  </div>
	  <fieldset><legend>操作手</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="operator_body">
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
	var devaccid='<%=devaccid%>';
	var add_mod_flag='<%=add_mod_flag%>';
	var fk_id='<%=fk_id%>';
	
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
		
	function submitInfo(){
		if(confirm("提交后数据不能修改，确认提交？")){			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toDevOperator.srq?state=9&ids="+devaccid+"&fk_id="+fk_id+"&add_mod_flag="+add_mod_flag;
			document.getElementById("form1").submit();
		}
	}
	
	var project_info_id;
	
	function loadDataDetail(){
		if(add_mod_flag=="0"){
			var querySql="select b.fk_dev_acc_id,b.project_info_id,c.project_name, dev_name,dev_model,self_num,license_num ";
				querySql+="from gms_device_account_dui b left join gp_task_project c on b.project_info_id=c.project_info_no where dev_acc_id='"+devaccid+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#project_name")[0].value=basedatas[0].project_name;
			$("#projectno")[0].value=basedatas[0].project_info_id;
			$("#fkdevaccid")[0].value=basedatas[0].fk_dev_acc_id;
			
			project_info_id=basedatas[0].project_info_id;
			
		}else{
			var querySql="select b.fk_dev_acc_id,a.operator_name,a.operator_id,d.employee_id,d.employee_name,b.dev_name,b.dev_model,";
				querySql+="b.self_num,b.license_num,c.project_name,b.project_info_id from gms_device_equipment_operator a ";
				querySql+="left join gms_device_account_dui b on a.device_account_id=b.dev_acc_id ";
				querySql+="left join gp_task_project c on b.project_info_id=c.project_info_no ";
				querySql+="left join comm_human_employee d on a.operator_id=d.employee_id ";
				querySql+="where a.entity_id='"+fk_id+"' " ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#project_name")[0].value=basedatas[0].project_name;
			$("#projectno")[0].value=basedatas[0].project_info_id;
			$("#fkdevaccid")[0].value=basedatas[0].fk_dev_acc_id;
			project_info_id=basedatas[0].project_info_id;
			removrow();
			for(var i=0;i<basedatas.length;i++){
				var arrayObj = {"label":basedatas[i].operator_name,"value":basedatas[i].employee_id}; 
				addrow(arrayObj);
			}			
		}			
	}
	var optnum=1;
	function addrow(obj){
		
		optnum++;
		
		var newTr=operator_body.insertRow();
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="操作手"+optnum;
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		if(obj==undefined){
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden  /><input name=operator_name id=operator_name  class=input_width type=text /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
		}else{			
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden value='"+obj.value+"'  /><input name=operator_name id=operator_name  class=input_width type=text value='"+obj.label+"' /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
		}
		
	}
	function removrow(){
		
		if(optnum>0){
			$("#operator_body  tr:last").remove(); 
			optnum--;
		}		
	}
		
	function showOrgPage(oo){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/device-xd/selectOutOrgId.jsp?project_info_id="+project_info_id,obj,"dialogWidth=305px;dialogHeight=420px");
		
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
 