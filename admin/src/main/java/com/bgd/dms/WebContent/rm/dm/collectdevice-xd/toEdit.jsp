<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String devaccid = request.getParameter("id");
%>
<!DOCTYPE>
<html>
	<head>
		<title>队级采集设备台账明细</title>
		<meta charset="UTF-8" />
<!--[if lt IE 9]>
    		<script src="<%=contextPath%>/js/html5.js"></script>
<![endif]-->
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
			rel="stylesheet" />
		<link rel="stylesheet" href="<%=contextPath%>/css/cn/style.css" />
		<link href="<%=contextPath%>/css/common.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/main.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" />
		<link rel="stylesheet"
			href="<%=contextPath%>/skin/cute/style/style.css" />
		<link rel="stylesheet" media="all"
			href="<%=contextPath%>/css/calendar-blue.css" />
		<link rel="stylesheet"
			href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" />
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
	</head>
	<body class="bgColor_f3f3f3" onload="pageInit()">
		<form name="form1" id="form1" method="post" action="">
			<input type="hidden" id="detail_count" value="" />
			<div id="new_table_box">
				<div id="new_table_box_content">
					<div id="new_table_box_bg">
						<fieldset>
							<legend>
								队级采集设备台账基本信息
							</legend>
							<table id="table1" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										采集设备名称
									</td>
									<td class="inquire_form6">
										<input id="dev_name" name="dev_name" readonly="readonly"
											class="input_width" type="text" />
										<input id="device_id" name="device_id" class="" type="hidden" />
										<input id="dev_acc_id" name="dev_acc_id" type="hidden" class="" value="" />
									</td>
									<td class="inquire_item6">
										采集设备型号
									</td>
									<td class="inquire_form6">
										<input id="dev_model" readonly="readonly" name="dev_model" class="input_width" type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										采集设备类型
									</td>
									<td class="inquire_form6">
											<input id="type_name" readonly="readonly" name="type_name"
												class="input_width" type="text" />
											<input id="type_id" name="type_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										是否离场
									</td>
									<td class="inquire_form6">
										<select class="select_width" id="is_leaving" name="is_leaving">
											<option value="">
												--请选择--
											</option>
											<option value="0">
												否
											</option>
											<option value="1">
												是
											</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										项目名称
									</td>
									<td class="inquire_form6">
										<input id="project_info_name" value="" readonly="readonly" name="project_info_name"
											class="input_width" type="text" />
										<input id="project_info_id" name="project_info_id"  type="hidden" />
									</td>
									<td class="inquire_item6">
										总数量
									</td>
									<td class="inquire_form6">
										<input id="total_num" name="total_num" class="input_width"
											type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										在队数量
									</td>
									<td class="inquire_form6">
										<input id="unuse_num" name="unuse_num" class="input_width"
											type="text" />
									</td>
									<td class="inquire_item6">
										离队数量
									</td>
									<td class="inquire_form6">
										<input id="use_num" name="use_num" class="input_width"
											type="text" />
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset>
							<legend>
								队级采集设备台账扩展信息
							</legend>
							<table id="table2" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										所属单位
									</td>
									<td class="inquire_form6">
										<input id="owning_org_name" readonly="readonly"
											name="owning_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('owning_org')" />
										<input id="owning_org_id" name="owning_org_id" class=""
											type="hidden" />
									</td>
									<td class="inquire_item6">
										所属单位隶属
									</td>
									<td class="inquire_form6">
										<input id="owning_sub_name" readonly="readonly"
											name="owning_sub_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('owning_sub')" />
										<input id="owning_sub_id" name="owning_sub_id" class=""
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										所在单位
									</td>
									<td class="inquire_form6">
										<input id="usage_org_name" readonly="readonly"
											name="usage_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('usage_org')" />
										<input id="usage_org_id" name="usage_org_id" class=""
											type="hidden" />
									</td>
									<td class="inquire_item6">
										所在单位隶属
									</td>
									<td class="inquire_form6">
										<input id="usage_sub_name" readonly="readonly"
											name="usage_sub_name" " class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('usage_sub')" />
										<input id="usage_sub_id" name="usage_sub_id" class=""
											type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										计划进场时间
									</td>
									<td class="inquire_form6">
										<input id="planning_in_time" readonly="readonly"
											name="planning_in_time" class="input_width" type='text' />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton1' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("planning_in_time","colltributton1");' />
									</td>
									<td class="inquire_item6">
										计划离场时间
									</td>
									<td class="inquire_form6">
										<input id="planning_out_time" readonly="readonly" name="planning_out_time"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton2' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("planning_out_time","colltributton2");' />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										实际进场时间
									</td>
									<td class="inquire_form6">
										<input id="actual_in_time" readonly="readonly" name="actual_in_time"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton3' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("actual_in_time","colltributton3");' />
									</td>
									<td class="inquire_item6">
										实际离场时间
									</td>
									<td class="inquire_form6">
										<input id="actual_out_time" name="actual_out_time" readonly="readonly"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/calendar.gif"
											id='colltributton4' width='16' height='16'
											style='cursor: hand;'
											onmouseover='calDateSelector("actual_out_time","colltributton4");' />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										所在位置
									</td>
									<td class="inquire_form6">
										<input id="dev_position" name="dev_position"
											class="input_width" type="text" />
									</td>
									<td class="inquire_item6">
										转出单位
									</td>
									<td class="inquire_form6">
										<input id="out_org_name" readonly="readonly"
											name="out_org_name" class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('out_org')" />
										<input id="out_org_id" name="out_org_id" class=""
											type="hidden" />
									</td>

								</tr>
								<tr>
									<td class="inquire_item6">
										转入单位
									</td>
									<td class="inquire_form6">
										<input id="in_org_name" readonly="readonly" name="in_org_name"
											class="input_width" type="text" />
										<img src="<%=contextPath%>/images/magnifier.gif" width="16"
											height="16" style="cursor:hand;"
											onclick="showOrgTreePage('in_org')" />
										<input id="in_org_id" name="in_org_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										计量单位
									</td>
									<td class="inquire_form6">
										<input id="dev_unit" name="dev_unit" class="input_width"
											type="text" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="submitInfo()"></a>
						</span>
						<span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
		</form>
		<script src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script src="<%=contextPath%>/js/table.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
		<script src="<%=contextPath%>/js/calendar.js"></script>
		<script src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script src="<%=contextPath%>/js/calendar-setup.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_cru.js"></script>
		<script src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
		<script src="<%=contextPath%>/js/rt/proc_base.js"></script>
		<script src="<%=contextPath%>/js/rt/fujian.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_validate.js"></script>
		<script src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_edit.js"></script>
		<script src="<%=contextPath%>/js/json2.js"></script>
		<script src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
		<script src="<%=contextPath%>/js/gms_list.js"></script>
		<script src="<%=contextPath%>/js/dialog_open1.js"></script>
		<script> 
	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				if(this.checked == true){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	
	function pageInit(){
		var querySql= 	"SELECT t. dev_acc_id,\n" +
						"       t. dev_name,\n" + 
						"       t. dev_model,\n" + 
						"       (SELECT c.dev_name\n" + 
						"          FROM gms_device_collectinfo c, gms_device_collectinfo c1\n" + 
						"         WHERE c1.device_id = t.device_id\n" + 
						"           AND c.device_id = c1.node_parent_id) AS type_name,\n" + 
						"       t. device_id,\n" + 
						"       t. dev_unit,\n" + 
						"       (SELECT c.org_abbreviation\n" + 
						"          FROM comm_org_information c\n" + 
						"         WHERE c.org_id = t. owning_org_id) AS owning_org_name,\n" + 
						"       t.owning_org_id,\n" + 
						"       (SELECT c.org_abbreviation\n" + 
						"          FROM comm_org_information c\n" + 
						"         WHERE c.org_id = t. owning_sub_id) AS owning_sub_name,\n" + 
						"       t. owning_sub_id,\n" + 
						"       (SELECT c.org_abbreviation\n" + 
						"          FROM comm_org_information c\n" + 
						"         WHERE c.org_id = t. usage_org_id) AS usage_org_name,\n" + 
						"       t. usage_org_id,\n" + 
						"       (SELECT c.org_abbreviation\n" + 
						"          FROM comm_org_information c\n" + 
						"         WHERE c.org_id = t. usage_sub_id) AS usage_sub_name,\n" + 
						"       t. usage_sub_id,\n" + 
						"       t. dev_position,\n" + 
						"       t. total_num,\n" + 
						"       t. unuse_num,\n" + 
						"       t. use_num,\n" + 
						"       t. bsflag,\n" + 
						"       t. creator,\n" + 
						"       t. create_date,\n" + 
						"       t. modifier,\n" + 
						"       t. modifi_date,\n" + 
						"       t. planning_in_time,\n" + 
						"       t. planning_out_time,\n" + 
						"       t. actual_in_time,\n" + 
						"       t. actual_out_time,\n" + 
						"       t. fk_dev_acc_id,\n" + 
						"       (SELECT p.project_name\n" + 
						"          FROM gp_task_project p\n" + 
						"         WHERE p.project_info_no = t.project_info_id) AS project_info_name,\n" + 
						"       t.project_info_id,\n" + 
						"       (SELECT c.org_abbreviation\n" + 
						"          FROM comm_org_information c\n" + 
						"         WHERE c.org_id = t. out_org_id) AS out_org_name,\n" + 
						"       t. out_org_id,\n" + 
						"       (SELECT c.org_abbreviation\n" + 
						"          FROM comm_org_information c\n" + 
						"         WHERE c.org_id = t. out_org_id) AS in_org_name,\n" + 
						"       t. in_org_id,\n" + 
						"       t. is_leaving,\n" + 
						"       t. fk_device_appmix_id,\n" + 
						"       t. search_id,\n" + 
						"       t. dev_team\n" + 
						"  FROM gms_device_coll_account_dui t where t.dev_acc_id = '<%=devaccid%>'";	
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(queryRet.datas && queryRet.datas.length > 0){
			var datas = queryRet.datas[0];
			for(var i in datas){
				$('#'+i).val(datas[i]);
			}
		}
		
		
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById(str+"_id").value = orgId[1];
	}
	/**
	 * 提交
	 */
	function submitInfo(){
		var str = $("#form1").serialize();
		cruConfig.contextPath='<%=contextPath%>';
		jcdpCallService("DevCommInfoSrv","saveCollectDevAccDui",str);
		var ctt = parent.frames['list'].frames;
		ctt.window.refreshData();
		newClose();
	}
</script>
	</body>
</html>

