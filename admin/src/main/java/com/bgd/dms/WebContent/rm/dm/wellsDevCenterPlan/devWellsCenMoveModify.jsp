<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devMovId = request.getParameter("devMovId");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	
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
<title>多项目-井中设备转移修改页面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">转移申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >&nbsp;转出单位名称</td>
          <td class="inquire_form4" >
          	<input name="output_name" id="output_name" class="input_width" type="text" value="井中设备分中心"  readonly/>
          	<input name="outProjectInfoNo" id="outProjectInfoNo" class="input_width" type="hidden" value="C6000000007250"/>
          </td>
          <td class="inquire_item4" ><font color=red>*</font>&nbsp;转入项目名称</td>
          <td class="inquire_form4" >
          	<input name="input_name" id="input_name" class="input_width" type="text" value=""  readonly/>
          	<input name="inProjectInfoNo" id="inProjectInfoNo" class="input_width" type="hidden" value=""/>
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showInProjectPage()"  />
          </td>
        </tr>
        <tr>
        <td class="inquire_item4">转移申请单号:</td>
          <td class="inquire_form4">
          	<input name="dev_mov_no" id="dev_mov_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          	<input name="dev_mov_id" id="dev_mov_id" class="input_width" type="hidden" value="<%=devMovId %>" readonly/>
          </td>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input class="input_width" type="text" name="dev_mov_name" id="dev_mov_name"  value=''/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          	<td class="inquire_item4"><font color=red>*</font>&nbsp;申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="" readonly/><img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(apply_date,tributton2);" />
          </td>
          </td>
        </tr>
      </table>
      </fieldset>
      <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td style="width:90%"></td>
				<td><span class="zj"><a href="#" id="addProcess" name="addProcess" ></a></span></td>
			    <td><span class="sc"><a href="#" id="delProcess" name="delProcess" ></a></span></td>
			    <td style="width:1%"></td>
			</tr>
		  </table>
	  </div>
	  <fieldset style="margin-left:2px"><legend>转移申请明细</legend>
		  <div style="height:220px;overflow:auto">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='devbackinfo' name='devbackinfo'/></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<!-- <td class="bt_info_odd" width="15%">AMIS设备编号</td> -->
					<td class="bt_info_odd" width="15%">ERP设备编号</td>
					<td class="bt_info_even" width="4%">数量</td>
					<!-- <td class="bt_info_odd" width="10%">计划离场时间</td>
					<td class="bt_info_even" width="12%"><font color='red'>实际离场时间</font></td> -->
				</tr>
			   </table>
				<div style="height:190px;overflow:auto;">
				<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			  		<tbody id="processtable" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
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
			var selectStr = null;
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){					
					if(i==0){
						selectStr = "'"+this.id;
					}else{
						selectStr += "','"+this.id;
					}
				}
			});
			if(selectStr!=null){
				selectStr = selectStr + "'";
			}
			paramobj.selectStr = selectStr;
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/wellsDevCenterPlan/selectAccForWellsCen.jsp?",paramobj,"dialogWidth=1200px;dialogHeight=480px");
			
			if(vReturnValue == undefined){
				return;
			}
			var accountidinfos = vReturnValue.split("|","-1");
			var condition ="";
			if(accountidinfos.length == 1){
				var accountids = accountidinfos[0].split("~", -1);
				condition = "('"+accountids[0]+"') ";
			}else{
				for(var index=0;index<accountidinfos.length;index++){
					var accountids = accountidinfos[index].split("~", -1);
					if(index == 0){
						condition = "('"+accountids[0]+"'";
					}else{
						condition += ",'"+accountids[0]+"'";
					}
				}
				condition += ") ";
			}

			var devdetSql = "select account.dev_acc_id,account.asset_coding, ";
			devdetSql += "account.dev_coding,account.self_num,account.dev_sign, ";
			devdetSql += "account.license_num,account.actual_in_time,to_char(account.planning_out_time,'yyyy-mm-dd') as planning_out_time, ";
			devdetSql += "account.dev_name,account.dev_model ";
			devdetSql += "from gms_device_account_wells account ";
			devdetSql += "where account.bsflag = '0' and account.dev_acc_id in "+condition ;
			devdetSql += "order by account.planning_out_time,account.dev_type";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
				var retObj = proqueryRet.datas;
				addLine(retObj);
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){
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
	function addLine(retObj){
		var rows = document.getElementById("processtable").rows.length;
		for(var index=rows;index<rows+retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index-rows].dev_acc_id+"' name='tr' midinfo='"+retObj[index-rows].dev_acc_id+"'>";
			innerhtml += "<td width='4%'><input type='checkbox' name='idinfo' id='"+retObj[index-rows].dev_acc_id+"' checked/></td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].self_num+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index-rows].dev_sign+"</td>";
			innerhtml += "<td width='11%'>"+retObj[index-rows].license_num+"</td>";
			innerhtml += "<td width='15%'>"+retObj[index-rows].dev_coding+"</td>";
			innerhtml += "<td width='4%'>1</td>";
			//innerhtml += "<td width='10%'>"+retObj[index-rows].planning_out_time+"</td>";
			//innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='"+retObj[index-rows].planning_out_time+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var idinfos;
		var enddateinfo;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(count == 0){
				idinfos = this.id;
				enddateinfo = $("input[id^='enddate'][devaccid='"+this.id+"']").val();
			}else{
				idinfos = idinfos+"~"+this.id;
				enddateinfo = enddateinfo+"~"+$("input[id^='enddate'][devaccid='"+this.id+"']").val();
			}
			count++;
		});
		if(count == 0){
			alert('请添加返还申请明细信息！');
			return;
		}
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsCenDevMoveApply.srq?count="+count+"&idinfos="+idinfos+"&enddateinfo="+enddateinfo;
			document.getElementById("form1").submit();
		}
	}
	var devMovId = '<%=devMovId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
	function refreshData(){
		var retObj;
		var basedatas;
		var proSql = "select t.dev_mov_id,t.dev_mov_no,t.out_project_info_id,t.in_project_info_id,t.dev_mov_name,";
			proSql += "outgp.project_name as out_progect_name,ingp.project_name as in_project_name,u.user_name as opertor,";
			proSql += "t.opertor_id,t.apply_date from gms_device_move t left join gp_task_project outgp on t.out_project_info_id=outgp.project_info_no ";
			proSql += "left join gp_task_project ingp on t.in_project_info_id=ingp.project_info_no left join p_auth_user u on t.opertor_id=u.user_id ";
			proSql += "where t.dev_type = 'wcdev' and t.bsflag='0' and t.dev_mov_id='"+devMovId+"'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		
		if(proqueryRet!=null && proqueryRet.returnCode =='0'){
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#dev_mov_no").val(retObj[0].dev_mov_no);
			$("#dev_mov_name").val(retObj[0].dev_mov_name);
			$("#input_name").val(retObj[0].in_project_name);
			//$("#output_name").val(retObj[0].out_progect_name);
			//$("#outProjectInfoNo").val(retObj[0].out_project_info_id);
			$("#input_name").val(retObj[0].in_project_name);
			$("#inProjectInfoNo").val(retObj[0].in_project_info_id);
			$("#back_employee_name").val(retObj[0].opertor);
			$("#back_employee_id").val(retObj[0].opertor_id);
			$("#apply_date").val(retObj[0].apply_date);
		}
		//查询转移设备明细
		if(devMovId!=null && devMovId!=''){
		
			var devdetSql = "select dui.dev_coding,dui.dev_name,t.dev_acc_id,dui.dev_model,dui.self_num,dui.license_num,dui.dev_sign,dui.asset_coding,dui.actual_in_time,t.actual_out_time as planning_out_time "+
           					"from gms_device_move_detail t left join gms_device_account_wells dui on t.dev_acc_id = dui.dev_acc_id "+
                			"where t.dev_mov_id = '"+devMovId+"' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
			var retObj = proqueryRet.datas;
			addLine(retObj);
		}
	}
	$().ready(function(){
		$("#devbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
		});
	});
	//转入项目
	function showInProjectPage(){
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devmove/selectWellsProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view',"test",'dialogWidth=800px;dialogHeight=450px');
		
		var strs = new Array(); //定义一数组
		strs = returnValue.split("~"); //字符分割
		var name = strs[0].split(":");
		$("#input_name").val(name[1]);
		var id = strs[1].split(":");
		$("#inProjectInfoNo").val(id[1]);
   }
</script>
</html>

