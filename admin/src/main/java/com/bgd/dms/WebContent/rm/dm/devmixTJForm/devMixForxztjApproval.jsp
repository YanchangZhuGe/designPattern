<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String  mixId=request.getParameter("mixId");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/aside.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/listTable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>资源池设备调剂-录入</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<input type='hidden' name='selectWzId' id='selectWzId'/>
<input type='hidden' name='device_mixInfo_id' id='device_mixInfo_id' value="<%=mixId%>"/>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend>调剂申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >调剂单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" > 调剂单名称:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_name" id="mixinfo_name" class="input_width" type="text"  value="" />
          </td>
        </tr>
        <tr>
         <td class="inquire_item4" > 转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
           <td class="inquire_item4" > 转入单位:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
        <tr>
        </tr>
        <tr>
          <td class="inquire_item4" > &nbsp;转入项目名称</td>
          <td class="inquire_form4" >
          	<input name="input_name" id="input_name" class="input_width" type="text" value=""  readonly/>
          	<input name="inProjectInfoNo" id="inProjectInfoNo" class="input_width" type="hidden" value=""/>
          </td>
          <td class="inquire_item4">调剂人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
        </td>
        </tr>
        <tr>
         	<td class="inquire_item4"> &nbsp;调剂时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="" readonly/><img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(apply_date,tributton2);" />
          </td>
        </tr>
      </table>
      </fieldSet>
     
	  <fieldSet style="margin-left:2px"><legend>设备调剂明细</legend>
		  <div style="height:130px;overflow:auto">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='devbackinfo' name='devbackinfo'/></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
				 <td class="bt_info_odd" width="10%"><font color='red'>计划进场时间</font></td>
				<td class="bt_info_even" width="12%"><font color='red'>计划离场时间</font></td>
				</tr>
			   </table>
				<div style="height:190px;overflow:auto;">
				<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			  		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
        <fieldSet style="margin-left:2px"><legend><font color=red>审批</font></legend>
		
		      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >审批意见:</td>
          <td class="inquire_form4"  >
  <textarea id="approval_desc" name="approval_desc" rows="3"  cols="65"></textarea>          </td>
        </tr>
 
      </table>
		</fieldSet>
    
    
    </div>
    
    <div id="oper_div">
       
     <span class='pass_btn'><a href='#' onclick='submitInfo(1)' ></a></span>
				<span class='nopass_btn'><a href='#' onclick='submitInfo(2)' ></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function submitInfo(str){
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/approvalXZ.srq?str="+str;
		document.getElementById("form1").submit();
	}
	//转入项目
	function showProjectPage(str){
		var in_org_id=document.getElementById("in_org_id").value;
		
		if(in_org_id=="")
			{
			alert("请选择转入单位!");
			return;
			}
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devmixTJForm/selectProject.jsp?orgSubjectionId='+in_org_id,"test",'dialogWidth=800px;dialogHeight=450px');
		if(returnValue==null){
			return;
		}
		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var name = strs[1];
		var id = strs[0];
		document.getElementById("inProjectInfoNo").value=id;
		document.getElementById("input_name").value=name;
		
	}
	var mixId='<%=mixId%>';
	function refreshData()
	{
		if(mixId!='null')
		{
			var baseData;
			 baseData = jcdpCallService("DevInsSrv", "getMixDeviceInfo", "mixId="+mixId);
				if(baseData.devMap!=null)
					{
						document.getElementById("mixinfo_no").value=baseData.devMap.mixinfo_no ;
						document.getElementById("mixinfo_name").value=baseData.devMap.mixinfo_name ;
						document.getElementById("in_org_name").value=baseData.devMap.inorgname;
						document.getElementById("in_org_id").value=baseData.devMap.in_org_id;
						document.getElementById("out_org_name").value=baseData.devMap.outorgname;
						document.getElementById("out_org_id").value=baseData.devMap.out_org_id;
						document.getElementById("input_name").value=baseData.devMap.project_name ;
						document.getElementById("inProjectInfoNo").value=baseData.devMap.project_info_no;
						document.getElementById("apply_date").value=baseData.devMap.create_date;
						document.getElementById("back_employee_name").value=baseData.devMap.user_name;
					}
				
				
				if(baseData.datas!=null)
				{
					//通过查询结果动态填充使用情况select;
					for (var i=0; i< baseData.datas.length; i++) {
						tr_id=$("#processtable0 tr").length;
						var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='devid' id='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
						innerhtml += "<td><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_name+"' readonly />";
						innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_model+"' readonly />";
						innerhtml += "<td><input name='self_num"+tr_id+"' id='self_num"+tr_id+"'   size='16' value='"+baseData.datas[i].self_num+"' readonly />";
						innerhtml += "<td><input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_sign+"' readonly />";
						innerhtml += "<td><input name='plan_start_date"+tr_id+"' id='plan_start_date"+tr_id+"' value='"+baseData.datas[i].dev_plan_start_date+"'   size='16' readonly />";
						innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton1"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(plan_start_date"+tr_id+",tributton1"+tr_id+");'/></td>";
						innerhtml += "<td><input name='plan_end_date"+tr_id+"' id='plan_end_date"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_plan_end_date+"' readonly />";
						innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(plan_end_date"+tr_id+",tributton2"+tr_id+");'/></td>";
						$("#processtable0").append(innerhtml);
						}
				
					$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
					$("#processtable0>tr:odd>td:even").addClass("odd_even");
					$("#processtable0>tr:even>td:odd").addClass("even_odd");
					$("#processtable0>tr:even>td:even").addClass("even_even");
					}
				
				
				
		}
		
	}
	
	
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue;
		if(str=="out_org")
			{
		 returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?orgId=C6000000000001","test","");
			}
		else
			{
			returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
			}
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		//var orgId = strs[1].split(":");
		//document.getElementById(str+"_id").value = orgId[1];
		var orgSubId = strs[2].split(":");
		document.getElementById(str+"_id").value = orgSubId[1];
		if(str=="out_org")
			{
			$("#processtable0").empty();
			}
		if(str=="in_org")
		{
		document.getElementById("input_name").value="";
		document.getElementById("inProjectInfoNo").value="";
		}
	}
	
	
	function toAddzy(){
	var out_org_id=document.getElementById("out_org_id").value;
		
		if(out_org_id=="")
			{
			alert("请选择转出单位!");
			return;
			}
		
		
		var selectWzId='';
		$("input[name='devid']").each(function(){
			if(selectWzId!=""){
				selectWzId += ","; 
			}
			selectWzId += "'"+this.id+"'";
		});
		var selected = window.showModalDialog("<%=contextPath%>/rm/dm/devmixTJForm/selectAccountForXZ.jsp?out_org_id="+out_org_id+"&selectWzId="+selectWzId,"","dialogWidth=1240px;dialogHeight=480px");
		var wz_id = selected;
		document.getElementById("selectWzId").value = wz_id;
		if(selected!=null&&selected!=""){
			addLine();
		}
		}
	
	function addLine(){
		var wz_id=document.getElementById("selectWzId").value;
		var baseData;
		 baseData = jcdpCallService("DevInsSrv", "getdeviceInfo", "wz_id="+wz_id);
		 if(baseData.datas!=null)
			{
				for (var i=0; i< baseData.datas.length; i++) {
					tr_id=$("#processtable0 tr").length;
					var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='devid' id='"+baseData.datas[i].dev_acc_id+"' size='16'  type='hidden' />";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
					innerhtml += "<td><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_name+"' readonly />";
					innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_model+"' readonly />";
					innerhtml += "<td><input name='self_num"+tr_id+"' id='self_num"+tr_id+"'   size='16' value='"+baseData.datas[i].self_num+"' readonly />";
					innerhtml += "<td><input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"'   size='16' value='"+baseData.datas[i].dev_sign+"' readonly />";
					innerhtml += "<td><input name='plan_start_date"+tr_id+"' id='plan_start_date"+tr_id+"'   size='16' readonly />";
					innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton1"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(plan_start_date"+tr_id+",tributton1"+tr_id+");'/></td>";
					innerhtml += "<td><input name='plan_end_date"+tr_id+"' id='plan_end_date"+tr_id+"'   size='16' readonly />";
					innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(plan_end_date"+tr_id+",tributton2"+tr_id+");'/></td>";
					$("#processtable0").append(innerhtml);
					}
			
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
				}
		
	}
	function deleteMatHave(){
		$("input[name='idinfo']").each(function(){
			if(this.checked == true){
				$('#tr'+this.id,"#processtable0").remove();
			}
		});
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}

</script>
</html>

