<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Date"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	
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
<title>调配明细添加界面</title>
</head>
<body class="bgColor_f3f3f3;overflow:auto" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">转移申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >转出项目名称</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" style="color:#B0B0B0;" readonly/>
          	<input name="outProjectInfoNo" id="outProjectInfoNo" class="input_width" type="hidden" value="<%=projectInfoNo%>"/>
          </td>
          <td class="inquire_item4" ><font color=red>*</font>&nbsp;转入项目名称</td>
          <td class="inquire_form4" >
          	<input name="input_name" id="input_name" class="input_width" type="text" value="" style="color:#B0B0B0;" readonly/>
          	<input name="inProjectInfoNo" id="inProjectInfoNo" class="input_width" type="hidden" value=""/>
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevPage()"  />
          </td>
        </tr>
        <tr>
        <td class="inquire_item4">转移申请单号:</td>
          <td class="inquire_form4">
          	<input name="dev_mov_no" id="dev_mov_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
          <td class="inquire_item4">转移申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input class="input_width" type="text" name="dev_mov_name" id="dev_mov_name"  value=''/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          	<td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=appDate %>" readonly/><img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(apply_date,tributton2);" />
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
					<td class="bt_info_even" width="5%">单位</td>
					<td class="bt_info_odd" width="8%">总数量</td>
					<td class="bt_info_even" width="8%">在队数量</td>
					<td class="bt_info_odd" width="8%">已离队数量</td>
					<td class="bt_info_even" width="8%">本次转移数量</td>
					<td class="bt_info_odd" width="13%">实际进场时间</td>
					<td class="bt_info_even" width="13%"><font color='red'>实际离场时间</font></td>
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
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/collMove/selectAccountForBack.jsp?projectinfono=<%=projectInfoNo%>&backdevtype="+backdevtype,paramobj,"dialogWidth=820px;dialogHeight=480px");
			
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

			var devdetSql = "select account.*,unitsd.coding_name as unit_name ";
				devdetSql += "from gms_device_coll_account_dui account ";
				devdetSql += "join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
				devdetSql += "where nvl(account.bsflag,0) != '1' and account.dev_acc_id in "+condition ;
				devdetSql += " and account.project_info_id='<%=projectInfoNo%>' ";
				devdetSql += " order by account.planning_out_time";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				var retObj = proqueryRet.datas;
				addLine(retObj)
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
			innerhtml += "<td width='4%'><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index-rows].dev_acc_id+"' checked/></td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td width='5%'>"+retObj[index-rows].unit_name+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index-rows].total_num+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index-rows].unuse_num+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index-rows].use_num+"</td>";
			var back_num = retObj[index-rows].back_num;
			if(back_num==null){
				back_num = "";
			}
			innerhtml += "<td width='8%'><input name='back_num"+index+"' id='back_num"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' detindex='"+index+"' maxnum='"+retObj[index-rows].unuse_num+"' size='5' type='text' value='"+back_num+"' onkeyup='checkAssignNum(this)'></input></td>";
			innerhtml += "<td width='13%'>"+retObj[index-rows].actual_in_time+"</td>";
			var actual_out = retObj[index-rows].actual_out;
			if(actual_out==null){
				actual_out = "";
			}
			innerhtml += "<td width='13%'><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='<%=appDate %>' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
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
		var movnum;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(count == 0){
				idinfos = this.id;
				enddateinfo = $("input[id^='enddate'][devaccid='"+this.id+"']").val();
				movnum = $("input[id^='back_num'][devaccid='"+this.id+"']").val();
			}else{
				idinfos = idinfos+"~"+this.id;
				enddateinfo = enddateinfo+"~"+$("input[id^='enddate'][devaccid='"+this.id+"']").val();
				movnum = movnum+"~"+$("input[id^='back_num'][devaccid='"+this.id+"']").val();
			}
			count++;
		});
		if(count == 0){
			alert('请添加转移申请明细信息！');
			return;
		}
		if(confirm("请注意修改“实际离场日期”，提交后不能更改。确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devmove/collMoveNewApply.srq?count="+count+"&idinfos="+idinfos+"&enddateinfo="+enddateinfo+"&movnum="+movnum;
			document.getElementById("form1").submit();
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		var proSql = "select project_info_no,project_name,to_char(sysdate,'yyyy-mm-dd') as backdate from gp_task_project where project_info_no= '<%=projectInfoNo%>' ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		
		if(proqueryRet!=null && proqueryRet.returnCode =='0'){
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#projectInfoNo").val(retObj[0].project_info_no);
			$("#backdate").val(retObj[0].backdate);
		}
	}
	$().ready(function(){
		$("#devbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
		});
	});
	//function showDevPage(){
	//	popWindow('<%=contextPath%>/rm/dm/collMove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','800:600');
   //}
    function showDevPage(){
		ret =  window.showModalDialog("<%=contextPath%>/rm/dm/devmove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view",null,"dialogWidth=800px;dialogHeight=480px");
		if(ret!=null){
			getMessage(ret);
		}				
	}
	
	function getMessage(arg){
		 var datas = "";
		 for(var i=0;i<arg.length;i++){
				datas +=arg[i];
		 }
		 var returnvalues = datas.split('@');
		 var name = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
		 var id = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
		 document.getElementById("input_name").value = name;
		 document.getElementById("inProjectInfoNo").value = id;
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
				alert("转移数量必须为数字!");
				obj.value = "";
	        	return false;
			}else{
				if(parseInt(value,10)>maxnum){
					alert("转移数量必须小于等于在队数量!");
					obj.value = "";
					return false;
				}
			}
		}

</script>
</html>

