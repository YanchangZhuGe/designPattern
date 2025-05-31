<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	String devicebackdetids = request.getParameter("devicebackdetids");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[0];
	String backtypeziyou = backTypeIDs[1];
	String[] backTypeNames = rb.getString("BackTypeName").split("~", -1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>返还明细添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">返还申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devicebackappid%>" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请单名称:</td>
          <td class="inquire_item4" >
          	<input name="backapp_name" id="backapp_name" class="input_width" type="text" value="" readonly/>
          </td>
          
        </tr>
        <tr>
         <td class="inquire_item4" >返还申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="" readonly/>
          </td>
          <td class="inquire_item4" ></td>
          <td class="inquire_form4" ></td>
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
	  <fieldset style="margin-left:2px"><legend>返还申请明细</legend>
		  <div style="height:105px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%">选择</td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="5%">单位</td>
					<td class="bt_info_odd" width="8%">总数量</td>
					<td class="bt_info_even" width="8%">在队数量</td>
					<td class="bt_info_odd" width="8%">离队数量</td>
					<td class="bt_info_even" width="8%">返还数量</td>
					<td class="bt_info_odd" width="13%">实际进场时间</td>
					<td class="bt_info_even" width="13%">实际离场时间</td>
					<td class="bt_info_odd" width="13%">备注</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	$().ready(function(){
		$("#addProcess").click(function(){
			var projectInfoNo = $("#projectInfoNo").val();
			var backdevtype = $("#backdevtype").val();
			var paramobj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/collectDevBack/selectAccountForBack.jsp?projectinfono="+projectInfoNo+"&backdevtype="+backdevtype,paramobj,"dialogWidth=820px;dialogHeight=380px");
			if(vReturnValue == undefined){
				return;
			}
			var accountidinfos = vReturnValue.split("|","-1");
			var condition ="(";
			
				for(var index=0;index<accountidinfos.length;index++){
					if(index==0)
						condition += "'"+accountidinfos[index]+"'";
					else
						condition += ",'"+accountidinfos[index]+"'";
					
				}
				condition += ") ";
			
			var devdetSql = "select account.*,teamsd.coding_name as unit_name ";
				devdetSql += "from gms_device_coll_account_dui account ";
				devdetSql += "join comm_coding_sort_detail teamsd on account.dev_unit=teamsd.coding_code_id ";
				devdetSql += "where account.dev_acc_id in "+condition ;
				devdetSql += " and account.project_info_id='"+projectInfoNo+"' ";
				devdetSql += " order by account.planning_out_time";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				var retObj = proqueryRet.datas;
				for(var index=0;index<retObj.length;index++){
					var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
					innerhtml += "<td><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index].dev_acc_id+"'/></td>";
					
					innerhtml += "<td>"+retObj[index].dev_name+"</td>";
					innerhtml += "<td>"+retObj[index].dev_model+"</td>";
					innerhtml += "<td>"+retObj[index].dev_unit+"</td>";
					innerhtml += "<td>"+retObj[index].total_num+"</td>";
					innerhtml += "<td>"+retObj[index].unuse_num+"</td>";
					innerhtml += "<td>"+retObj[index].use_num+"</td>";
					innerhtml += "<td><input name='back_num"+index+"' id='back_num"+index+"' detindex='"+index+"' maxnum='"+retObj[index].unuse_num+"' class='input_width' type='text' value='' onkeyup='checkAssignNum(this)'></input></td>";
					innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
					innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index].dev_acc_id+"' style='line-height:15px' value='"+retObj[index].planning_out_time+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
					innerhtml += "<td><input name='devremark"+index+"' id='devremark"+index+"' detindex='"+index+"' type='text' size='14' value='' /></td>";
					innerhtml += "</tr>";
					$("#processtable").append(innerhtml);
				}
				$("#processtable>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable>tr:odd>td:even").addClass("odd_even");
				$("#processtable>tr:even>td:odd").addClass("even_odd");
				$("#processtable>tr:even>td:even").addClass("even_even");
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked == true){
					var id=this.id;
					$("#tr"+id).remove();
				}
			});
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		});
	});
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var idinfos;
		var lineinfo;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(count == 0){
				idinfos = this.id;
				lineinfo = this.seqinfo;
			}else{
				idinfos = idinfos+"~"+this.id;
				lineinfo = lineinfo+"~"+this.seqinfo;
			}
			count++;
		});
		
		if(count == 0){
			alert('请添加返还申请明细信息！');
			return;
		}
		var selectedlines = lineinfo.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#back_num"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的返还数量!");
			return;
		}
		var devicebackdetids = "<%=devicebackdetids%>";
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollBackDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&lineinfo="+lineinfo+"&action=update&devicebackdetids="+devicebackdetids;
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=devicebackappid%>'!=null){
			var proSql = "select backapp.back_org_id,backapp_name,backapp.backdate,backapp.back_employee_id,backapp.device_backapp_no,";
			proSql += "backapp.remark,pro.project_info_no,pro.project_name,";
			proSql += "backorg.org_name as back_org_name,emp.employee_name as back_emp_name ";
			proSql += "from gms_device_collbackapp backapp left join gp_task_project pro on backapp.project_info_id=pro.project_info_no ";
			proSql += "left join comm_org_information backorg on backorg.org_id=backapp.back_org_id ";
			proSql += "left join comm_human_employee emp on emp.employee_id=backapp.back_employee_id ";
			proSql += "where backapp.project_info_id= '<%=projectInfoNo%>' and backapp.device_backapp_id='<%=devicebackappid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#backapp_name").val(retObj[0].backapp_name);
			$("#device_backapp_no").val(retObj[0].device_backapp_no);
			
			var devicebackdetids = "<%=devicebackdetids%>";
			
			
            var devdetSql = "select det.*,account.dev_unit,account.total_num,account.unuse_num,account.use_nmum,account.actual_in_time,unitsd.coding_name as unit_name ";
				devdetSql += "from gms_device_collbackapp_detail det ";
				devdetSql += "left join gms_device_coll_account_dui account on det.dev_acc_id=account.dev_acc_id ";
				devdetSql += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
				devdetSql += "where det.device_backdet_id ='"+devicebackdetids+"' ";

				devdetSql += " order by account.planning_out_time";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				var retObj = proqueryRet.datas;
				for(var index=0;index<retObj.length;index++){
					var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
					innerhtml += "<td><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index].dev_acc_id+"'/></td>";
					
					innerhtml += "<td>"+retObj[index].dev_name+"</td>";
					innerhtml += "<td>"+retObj[index].dev_model+"</td>";
					innerhtml += "<td>"+retObj[index].unit_name+"</td>";
					innerhtml += "<td>"+retObj[index].total_num+"</td>";
					innerhtml += "<td>"+retObj[index].unuse_num+"</td>";
					innerhtml += "<td>"+retObj[index].use_nmum+"</td>";
					innerhtml += "<td><input name='back_num"+index+"' id='back_num"+index+"' detindex='"+index+"' maxnum='"+retObj[index].unuse_num+"' class='input_width' type='text' value='"+retObj[index].back_num+"' onkeyup='checkAssignNum(this)'></input></td>";
					innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
					innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index].dev_acc_id+"' style='line-height:15px' value='"+retObj[index].planning_out_time+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
					innerhtml += "<td><input name='devremark"+index+"' id='devremark"+index+"' detindex='"+index+"' type='text' size='14' value='"+retObj[index].devremark+"' /></td>";
					innerhtml += "</tr>";
					$("#processtable").append(innerhtml);
				}
				$("#processtable>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable>tr:odd>td:even").addClass("odd_even");
				$("#processtable>tr:even>td:odd").addClass("even_odd");
				$("#processtable>tr:even>td:even").addClass("even_even");
			
			
		}
		
		
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var maxnum = parseInt($(obj).attr("maxnum"));
		var applyednumval = parseInt($("#back_num"+index).val(),10);
		
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("返还数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>maxnum){
				alert("返还数量必须小于等于在队数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

