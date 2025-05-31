<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String oil_info_id=request.getParameter("oil_info_id");
	String dev_appdet_id = request.getParameter("ids");
	
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
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:380px">
      <fieldset><legend>定人定机</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="" name=""  class="input_width" type="text" readonly/>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
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
	  		<tbody id="OPERATOR_body">
		  		<tr>
			  		<td class="inquire_item6">操作手1</td>
					<td class="inquire_form6">
						<input name="operator_id" id="operator_id"  class="input_width" type="hidden" />
						<input name="operator_name" id="operator_name"  class="input_width" type="text"   readonly />
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
	var dev_appdet_id='<%=dev_appdet_id%>';
	var oil_info_id='<%=oil_info_id%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
		
	function submitInfo(){
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/GMS_DEVICE_EQUIPMENT_OPERATOR.srq?state=9&ids="+dev_appdet_id;
			document.getElementById("form1").submit();
		}
	}
	
	var PROJECT_INFO_ID;
	
	function loadDataDetail(){
		if(oil_info_id=="null"){
			var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from Gms_Device_Account_Unpro b where dev_acc_id='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;			
		}else{
			var querySql="select a.*,d.employee_id,d.employee_name,b.dev_name,b.dev_model,b.self_num,b.license_num,b.owning_org_name,b.usage_org_name,b.tech_stat from GMS_DEVICE_EQUIPMENT_OPERATOR a left join Gms_Device_Account_Unpro b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id left join comm_human_employee d on a.OPERATOR_ID=d.employee_id where a.DEVICE_ACCOUNT_ID='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			removrow();
			for(var i=0;i<basedatas.length;i++){
				var arrayObj = {"label":basedatas[i].operator_name,"value":basedatas[i].employee_id}; 
				addrow(arrayObj);
			}			
		}			
	}
	function  getOILMODEL(obj){
		var obj1=$("#OIL_MODEL");
		if(obj.value=="0110000043000000001"){
			
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400025' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--",""));  
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
		}else if(obj.value=="0110000043000000002" ){
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400026' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--","")); 
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
		}else{
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400040' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--",""));  
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
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
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden  /><input name=operator_name id=operator_name  class=input_width type=text readonly /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; readonly onclick=showOrgPage(this) />";
		}else{
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden value="+obj.value+"  /><input name=operator_name id=operator_name  class=input_width type=text  value='"+obj.label+"'  readonly /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
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
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/device-xd/searchZHOperatorList.jsp",obj,"dialogWidth=880px;dialogHeight=480px");
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
 