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
<title>新建维修返还调配单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin-left:2px"><legend>调配单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">转出单位:</td>
          <td class="inquire_form4">
          	<input name="own_org_name" id="own_org_name" class="input_width" type="text" value="" readonly/><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOwnOrgPage()"  />
          	<input name="own_org_id" id="own_org_id" class="input_width" type="hidden" value="" />
          </td>
          <td class="inquire_item4">接收单位</td>
          <td class="inquire_form4">
          	<input name="usage_org_name" id="usage_org_name" class="input_width" type="text" value="" readonly/><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOutOrgPage()"  />
            <input name="usage_org_id" id="usage_org_id" class="input_width" type="hidden" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还调拨单号:</td>
          <td class="inquire_form4">
          	<input name="repair_info_no" id="repair_info_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
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
					<td class="bt_info_odd" width="13%">返还时间</td>
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
	function showOwnOrgPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/common/selectOrgHR.jsp",obj,"dialogWidth=480px;dialogHeight=250px");
		$("#own_org_id").val(obj.fkValue);
		$("#own_org_name").val(obj.value);
	}
	function showOutOrgPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/common/selectOrgHR.jsp",obj,"dialogWidth=480px;dialogHeight=250px");
		$("#usage_org_id").val(obj.fkValue);
		$("#usage_org_name").val(obj.value);
	}
	$().ready(function(){
		$("#addProcess").click(function(){
			var paramobj = new Object();
			//TODO 拼condition,排除其他单子已经添加了的明细信息
			var own_org_id = $("#own_org_id").val();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccountForRepairMixForm.jsp?own_org_id="+own_org_id,paramobj,"dialogWidth=820px;dialogHeight=380px");
			var seq = $("tr","#processtable").size();
			var returnvalues;
			if(vReturnValue!=undefined){
				returnvalues = vReturnValue.split('~');
				var innerhtml = "<tr id='tr"+returnvalues[0]+"' name='tr'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+returnvalues[0]+"'/></td>";
				innerhtml += "<td>"+(seq+1)+"<input type='hidden' id='backdetid'"+seq+" seqinfo='"+seq+"' name='backdetid' value='"+returnvalues[0]+"'></td>";
				innerhtml += "<td>"+returnvalues[1]+"</td>";
				innerhtml += "<td>"+returnvalues[2]+"</td>";
				innerhtml += "<td>"+returnvalues[3]+"</td>";
				innerhtml += "<td>"+returnvalues[4]+"</td>";
				innerhtml += "<td>"+returnvalues[5]+"</td>";
				innerhtml += "<td>"+returnvalues[6]+"</td>";
				innerhtml += "<td><input name='senddate"+seq+"' id='senddate"+seq+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+seq+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(senddate"+seq+",tributton2"+seq+");'/></td>";
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
		var seqinfos = "";
		if(backdetids==0){
			alert("请添加调配明细信息!");
			return;
		}else{
			backdetids = "";
			$("input[name='backdetid']").each(function(i){
				if(i==0){
					backdetids = "('"+this.value;
					seqinfos = this.seqinfo;
				}else{
					backdetids += "','"+this.value;
					seqinfos = "~"+this.seqinfo;
				}
			});
			backdetids += "')";
		}
		alert(seqinfos)
		//维修调配单号 置为 空
		$("#repair_info_no").val();
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveRIFBackInfo.srq?state=0&seqinfos="+seqinfos+"&devaccids="+backdetids+"&repairtype=2";
		document.getElementById("form1").submit();
	}
	
	function submitInfo(){
		var backdetids = $("input[name='backdetid']").size();
		var seqinfos = "";
		if(backdetids==0){
			alert("请添加调配明细信息!");
			return;
		}else{
			backdetids = "";
			$("input[name='backdetid']").each(function(i){
				if(i==0){
					backdetids = "('"+this.value;
					seqinfos = this.seqinfo;
				}else{
					backdetids += "','"+this.value;
					seqinfos = "~"+this.seqinfo;
				}
			});
			backdetids += "')";
		}
		$("#repair_info_no").val();
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveRIFBackInfo.srq?state=9&seqinfos="+seqinfos+"&devaccids="+backdetids+"&repairtype=2";
		document.getElementById("form1").submit();
	}
</script>
</html>

