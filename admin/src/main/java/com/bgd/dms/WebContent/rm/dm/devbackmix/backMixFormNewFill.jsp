<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgid = user.getCodeAffordOrgID();
	int length = orgid.length();
	String empId = user.getEmpId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
<title>新建返还调配单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin-left:2px"><legend>调配单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4">
          	<select name="device_backapp_id" id="device_backapp_id" class="select_width"></select>
          </td>
          <td class="inquire_item4">项目名称</td>
          <td class="inquire_form4">
            <input name="project_name" id="project_name" class="input_width" type="text" readonly>
          	<input name="project_info_no" id="project_info_no" type="hidden">
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="usage_org_name" id="usage_org_name" class="input_width" type="text" readonly/>
          	<input name="usage_org_id" id="usage_org_id" class="input_width" type="hidden" />
          </td>
          <td class="inquire_item4">接收单位</td>
          <td class="inquire_form4">
          	<input name="own_org_name" id="own_org_name" class="input_width" type="text" /><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOutOrgPage()"  />
          	<input name="own_org_id" id="own_org_id" class="input_width" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还调拨单号:</td>
          <td class="inquire_form4">
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
          <td class="inquire_item4">开据人</td>
          <td class="inquire_form4">
          	<input name="print_emp_name" id="print_emp_name" class="input_width" type="text" value="<%=userName%>" readonly/>
          	<input name="print_emp_id" id="print_emp_id" class="input_width" type="hidden" value="<%=empId%>" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
	  <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td style="width:80%"></td>
				<td><span class="zj"><a href="#" id="addProcess" name="addProcess" ></a></span></td>
			    <td><span class="sc"><a href="#" id="delProcess" name="delProcess" ></a></span></td>
			    <td style="width:5%"></td>
			</tr>
		  </table>
	  </div>
	  <div id="tab_box" class="tab_box">
		<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" style="height:200px">
			  <table width="99%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="11%">选择</td>
					<td class="bt_info_even" width="11%">序号</td>
					<td class="bt_info_odd" width="11%">设备编码</td>
					<td class="bt_info_even" width="11%">设备名称</td>
					<td class="bt_info_odd" width="11%">规格型号</td>
					<td class="bt_info_even" width="11%">自编号</td>
					<td class="bt_info_odd" width="11%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<td class="bt_info_odd" width="13%">计划进场时间</td>
					<td class="bt_info_even" width="13%">计划离场时间</td>
				</tr>
			   <tbody id="detailtable" name="detailtable">
			   </tbody>
		      </table>
		 </div>
	  </div>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
	}
	$().ready(function(){
		$("#addProcess").click(function(){
			var project_info_no = $("#project_info_no").val();
			if(project_info_no==''){
				alert("请选择返还申请单信息!");
				return;
			}
			var own_org_id = $("#own_org_id").val();
			if(own_org_id==''){
				alert("请选择接收单位信息!");
				return;
			}
			var paramobj = new Object();
			//TODO 拼condition,排除其他单子已经添加了的明细信息
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccountForBackMixForm.jsp?own_org_id="+own_org_id+"&projectinfono="+project_info_no,paramobj,"dialogWidth=820px;dialogHeight=380px");
			var seq = $("tr","#processtable").size();
			var returnvalues;
			if(vReturnValue!=undefined){
				returnvalues = vReturnValue.split('~');
				var innerhtml = "<tr id='tr"+returnvalues[0]+"' name='tr'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+returnvalues[0]+"'/></td>";
				innerhtml += "<td>"+(seq+1)+"<input type='hidden' id='backdetid'"+seq+" name='backdetid' value='"+returnvalues[0]+"'></td>";
				innerhtml += "<td>"+returnvalues[1]+"</td>";
				innerhtml += "<td>"+returnvalues[2]+"</td>";
				innerhtml += "<td>"+returnvalues[3]+"</td>";
				innerhtml += "<td>"+returnvalues[4]+"</td>";
				innerhtml += "<td>"+returnvalues[5]+"</td>";
				innerhtml += "<td>"+returnvalues[6]+"</td>";
				innerhtml += "<td>"+returnvalues[7]+"</td>";
				innerhtml += "<td>"+returnvalues[8]+"</td>";
				innerhtml += "</tr>";
			
				$("#detailtable").append(innerhtml);
				//异步查询设备明细信息，回填到设备明细中
			}
			$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#detailtable>tr:odd>td:even").addClass("odd_even");
			$("#detailtable>tr:even>td:odd").addClass("even_odd");
			$("#detailtable>tr:even>td:even").addClass("even_even");
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){
					var id=this.id;
					$("#tr"+id).remove();
				}
			});
			$("#detailtable>tbody>tr>td:odd").addClass("odd_odd");
			$("#detailtable>tbody>tr>td:even").addClass("odd_even");
			$("#detailtable>tbody>tr>td:odd").addClass("even_odd");
			$("#detailtable>tbody>tr>td:even").addClass("even_even");
		});
	});
	function saveInfo(){
		var backdetids = $("input[name='backdetid']").size();
		if(backdetids==0){
			alert("请添加调配明细信息!");
			return;
		}else{
			backdetids = "";
			$("input[name='backdetid']").each(function(i){
				if(i==0){
					backdetids = "('"+this.value;
				}else{
					backdetids += "','"+this.value;
				}
			});
			backdetids += "')";
		}
		//返还调配单号 置为 空
		$("#mixinfo_no").val();
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackMDFInfo.srq?state=0&backdetids="+backdetids;
		document.getElementById("form1").submit();
	}
	
	function submitInfo(){
		var backdetids = $("input[name='backdetid']").size();
		if(backdetids==0){
			alert("请添加调配明细信息!");
			return;
		}else{
			backdetids = "";
			$("input[name='backdetid']").each(function(i){
				if(i==0){
					backdetids = "('"+this.value;
				}else{
					backdetids += "','"+this.value;
				}
			});
			backdetids += "')";
		}
		$("#mixinfo_no").val();
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMDFInfo.srq?state=9&backdetids="+backdetids;
		document.getElementById("form1").submit();
	}
</script>
<script type="text/javascript"> 
	$().ready(function(){
		$("#device_backapp_id").change(function(){
			var proid = $("option[selected='selected']","#device_backapp_id").attr("proid");
			var proinfos = proid.split("~");
			$("#project_info_no").val(proinfos[0]);
			$("#project_name").val(proinfos[1]);
			var usageorg = $("option[selected='selected']","#device_backapp_id").attr("usageorg");
			var usageorginfos = usageorg.split("~");
			$("#usage_org_id").val(usageorginfos[0]);
			$("#usage_org_name").val(usageorginfos[1]);
		});
	});
	function showOutOrgPage(){
		var devicebackappid = $("#device_backapp_id").val();
		if(devicebackappid==""){
			alert("请选择调配单信息!");
			return;
		}
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devbackmix/selectOwnOrgId.jsp?devbackappid="+devicebackappid,obj,"dialogWidth=480px;dialogHeight=250px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("#own_org_id").val(returnvalues[0]);
			$("#own_org_name").val(returnvalues[1]);
		}
	}
	function refreshData(){
		var proSql = "select device_backapp_id,device_backapp_no,backapp_name,project_info_id,pro.project_name,back_org_id,org.org_name as usage_org_name ";
			proSql += "from gms_device_backapp backapp ";
			proSql += "left join gp_task_project pro on backapp.project_info_id=pro.project_info_no ";
			proSql += "left join comm_org_information org on org.org_id=backapp.back_org_id ";
			proSql += "where bsflag='0' and backmix_org_id='<%=orgid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
		if(retObj.length>=1){
			var innerHtml = "<option value='' inorg='~' >请选择返还单信息</option>";
			for(var index=0;index<retObj.length;index++){
				innerHtml += "<option value='"+retObj[index].device_backapp_id+"' proid='"+retObj[index].project_info_id+"~"+retObj[index].project_name+"' usageorg='"+retObj[index].back_org_id+"~"+retObj[index].usage_org_name+"'>"+retObj[index].backapp_name+"</option>";
			}
			$("#device_backapp_id").append(innerHtml);
		}else{
			var innerHtml = "<option value=''>请选择返还单信息</option>";
			$("#device_backapp_id").append(innerHtml);
		}
	}
</script>
</html>

