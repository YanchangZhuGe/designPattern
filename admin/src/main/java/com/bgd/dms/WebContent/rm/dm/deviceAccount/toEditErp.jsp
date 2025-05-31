<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String devaccid = request.getParameter("id");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>  
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备接收明细</title>
</head>
<body class="bgColor_f3f3f3" onload="pageInit()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
     <fieldset><legend>基本信息</legend>
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;设备名称</td>
				<td class="inquire_form6">
					<input id="dev_name" name="dev_name" class="input_width" type="text"  readonly/>
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" readonly /></td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;设备编码</td>
				<td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text"  readonly/></td>
				<td class="inquire_form6"><input id="devaccid" name="devaccid" class="input_width" type="hidden" /></td>
				
			  </tr>
				<tr>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;资产状况</td>
				<td class="inquire_form6">
					<select id="account_stat_name" name="account_stat_name" class="select_width" type="text" disabled=disabled >
					</select>
					<input id="account_stat" name="account_stat" class="input_width" type="hidden" />
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;实物标识号</td>
				<td class="inquire_form6"><input id="dev_sign" name="dev_sign" class="input_width" type="text"  readonly/></td>
				<td class="inquire_item6">资产编号</td>
				<td class="inquire_form6"><input id="asset_coding" name="asset_coding" class="input_width" type="text"  readonly/></td>
				
			  </tr>
				<tr>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="self_num" name="self_num" class="input_width" type="text" readonly /></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="license_num" name="license_num" class="input_width" type="text" readonly /></td>
				<td class="inquire_item6">发动机号</td>
				<td class="inquire_form6"><input id="engine_num" name="engine_num" class="input_width" type="text" readonly/></td>
				
			  </tr>
			  <tr>
				<td class="inquire_item6">底盘号</td>
				<td class="inquire_form6"><input id="chassis_num" name="chassis_num" class="input_width" type="text"  readonly/></td>
				<td class="inquire_item6">所属单位</td>
				<td class="inquire_form6">
					<input id="owning_org_name" name="owning_org_name" class="input_width" type="text" />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
				</td>
					<td class="inquire_item6">所在单位</td>
				<td class="inquire_form6">
					<input id="usage_org_name" name="usage_org_name" class="input_width" type="text" />
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePages()"  />
					<input id="usage_org_id" name="usage_org_id" class="" type="hidden" />
				</td>
			  </tr>
			  <tr>
			  <td class="inquire_item6">使用情况</td>
				<td class="inquire_form6"><select id="using_stat" name="using_stat" class="input_width" type="text" onchange="selectChange()" /></td>
				
			  	<td class="inquire_item6">技术状况</td>
				<td class="inquire_form6"><select type="text" name="tech_stat" id="tech_stat" value="" readonly="readonly" class="input_width"/>
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;合同编号</td>
				<td class="inquire_form6"><input id="cont_num" name="cont_num" class="input_width" type="text" readonly /></td>
			  </tr>
		
      </table>
      </fieldset>
      <fieldset><legend>备注</legend>
	      <table id="table2" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='remark' name='remark' rows="5" cols="74" readonly></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
       <fieldset><legend>备注1</legend>
	      <table id="table2" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare1' name='spare1' rows="5" cols="74" readonly></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
      <fieldset><legend>备注2</legend>
       <table id="table3" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare2' name='spare2' rows="5" cols="74" readonly></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
      <fieldset><legend>备注3</legend>
       <table id="table4" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare3' name='spare3' rows="5" cols="74" readonly></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
      <!-- <fieldset><legend>备注4</legend>
       <table id="table5" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare4' name='spare4' rows="5" cols="74"></textarea>
		      	</td>
	      	</tr>
	      </table>
      </fieldset> -->
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
function checkType()
{
	if($("#account_stat_name").val()!="")
		{
		$("#account_stat_name").click(function ()
				{
				alert("资产状况不能修改!");
					return;
				});
		}
}

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
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	
	function pageInit(){
		//通过查询结果动态填充资产状态select;
		var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000013' and bsflag='0'";
		querySql += " and coding_code_id in ('0110000013000000006','0110000013000000001','0110000013000000003') order by coding_code desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		datas = queryRet.datas;
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				document.getElementById("account_stat_name").options.add(new Option(datas[i].coding_name,datas[i].coding_code_id)); 
			}
		}
		//通过查询结果动态填充使用情况select;
		var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000007' and bsflag='0' and coding_code_id!='0110000007000000001'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		usingdatas = queryRet.datas;
		
		if(usingdatas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				document.getElementById("using_stat").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
			}
		}
		
		//
		var querySql="select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT t where t.dev_acc_id='"+'<%=devaccid%>'+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		datas = queryRet.datas;
		document.getElementById("devaccid").value=datas[0].dev_acc_id;
		document.getElementById("dev_name").value=datas[0].dev_name;
		document.getElementById("dev_model").value=datas[0].dev_model;
		document.getElementById("dev_type").value=datas[0].dev_type;
		document.getElementById("account_stat").value=datas[0].account_stat;//此处是编码
		document.getElementById("account_stat_name").value=datas[0].account_stat;//此处是编码
		document.getElementById("dev_sign").value=datas[0].dev_sign;
		document.getElementById("asset_coding").value=datas[0].asset_coding;
		document.getElementById("self_num").value=datas[0].self_num;
		document.getElementById("license_num").value=datas[0].license_num;
		document.getElementById("engine_num").value=datas[0].engine_num;
		document.getElementById("chassis_num").value=datas[0].chassis_num;
		document.getElementById("owning_org_name").value=datas[0].owning_org_name_desc;
		document.getElementById("owning_org_id").value=datas[0].owning_org_id;
		document.getElementById("using_stat").value=datas[0].using_stat;
		document.getElementById("cont_num").value=datas[0].cont_num;

		document.getElementById("remark").value=datas[0].remark;
		document.getElementById("spare1").value=datas[0].spare1;
		document.getElementById("spare2").value=datas[0].spare2;
		document.getElementById("spare3").value=datas[0].spare3;
		selectChange();//关联技术状况
		document.getElementById("tech_stat").value=datas[0].tech_stat;//此处是编码

		//技术状况默认完好
		//document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
	}
	/**
	 * 选择设备树
	**/
	function showDevTreePage(){
		//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var name = names[1].split("(")[0];
		var model = names[1].split("(")[1].split(")")[0];
		//alert(returnValue);
		document.getElementById("dev_name").value = name;
		document.getElementById("dev_model").value = model;
		
		var codes = strs[1].split(":");
		var code = codes[1];
		document.getElementById("dev_type").value = code;
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("owning_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = orgId[1];
	}
	/**
	 * 提交
	 */
	function submitInfo(){

		if(document.getElementById("dev_name").value==""){
			alert("请输入设备名称");
			return;
		}
		if(document.getElementById("dev_model").value==""){
			alert("请输入设备型号");
			return;
		}
		if(document.getElementById("dev_type").value==""){
			alert("请输入设备编码");
			return;
		}
		if(document.getElementById("owning_org_name").value==""){
			alert("请输入所属单位");
			return;
		}
		
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitAccount.srq?modify=Y";
		document.getElementById("form1").submit();
		
	}
	/**
	 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
	 */
	function selectChange(){
		document.getElementById("tech_stat").options.length=0;
		if(document.getElementById("using_stat").value=='0110000007000000001' || document.getElementById("using_stat").value=='0110000007000000002')
		{
			document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
		}
		else{
			document.getElementById("tech_stat").options.add(new Option("待报废","0110000006000000005"));
			document.getElementById("tech_stat").options.add(new Option("待修","0110000006000000006"));
			document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
			document.getElementById("tech_stat").options.add(new Option("验收","0110000006000000013"));
		}
	}
	/**
	 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
	 */
	function selectChange(){
		document.getElementById("tech_stat").options.length=0;
		if(document.getElementById("using_stat").value=='0110000007000000001' || document.getElementById("using_stat").value=='0110000007000000002')
		{
			document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
		}
		else{
			document.getElementById("tech_stat").options.add(new Option("待报废","0110000006000000005"));
			document.getElementById("tech_stat").options.add(new Option("待修","0110000006000000006"));
			document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
			document.getElementById("tech_stat").options.add(new Option("验收","0110000006000000013"));
		}
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePages(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("usage_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("usage_org_id").value = orgId[1];
	}
</script>
</html>

