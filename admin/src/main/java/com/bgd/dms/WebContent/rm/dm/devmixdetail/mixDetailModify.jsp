<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String device_mixinfo_id = request.getParameter("device_mixinfo_id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgid = user.getCodeAffordOrgID();
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
<title>修改调配单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:99%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend>调配单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">项目名称</td>
          <td class="inquire_form4">
          	<select name="project_info_no" id="project_info_no" class="select_width"></select>
          	<input name="device_mixinfo_id" id="device_mixinfo_id" class="input_width" type="hidden" value="<%=device_mixinfo_id%>"/>
          </td>
          <td class="inquire_item4">转入单位:</td>
          <td class="inquire_form4">
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">调配申请单号:</td>
          <td class="inquire_form4">
          	<select name="device_app_id" id="device_app_id" class="select_width"></select>
          </td>
          <td class="inquire_item4">转出单位</td>
          <td class="inquire_form4">
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text" readonly/>
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">调拨单号:</td>
          <td class="inquire_form4"><input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text" value="提交后自动生成..." readonly/></td>
          <td class="inquire_item4">开据人</td>
          <td class="inquire_form4">
          	<input name="print_emp_name" id="print_emp_name" class="input_width" type="text" value="<%=userName%>" readonly/>
          	<input name="print_emp_id" id="print_emp_id" class="input_width" type="hidden" value="<%=empId%>" readonly/>
          </td>
        </tr>
      </table>
      </fieldSet>
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
	  <div id="tag-container_3">
		  <ul id="tags" class="tags">
		    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">调配明细信息</a></li>
		    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">设备明细信息</a></li>
		  </ul>
	  </div>
	  <div id="tab_box" class="tab_box">
		<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" >
			  <table width="99%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<th class="bt_info_odd" width="11%">设备编码</td>
					<th class="bt_info_even" width="11%">设备名称</td>
					<th class="bt_info_odd" width="11%">规格型号</td>
					<th class="bt_info_even" width="11%">自编号</td>
					<th class="bt_info_odd" width="11%">实物标识号</td>
					<th class="bt_info_even" width="11%">牌照号</td>
					<th class="bt_info_odd" width="8%">数量</td>
					<th class="bt_info_even" width="13%">计划进场时间</td>
					<th class="bt_info_odd" width="13%">计划离场时间</td>
				</tr>
			   <tbody id="detailtable" name="detailtable">
			   </tbody>
		      </table>
		 </div>
		 <div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
		  <table width="99%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	       <tr>
				<td class="bt_info_odd" width="4%">选择</td>
				<td class="bt_info_even" width="5%">序号</td>
				<td class="bt_info_odd" width="10%">设备名称</td>
				<td class="bt_info_even" width="10%">规格型号</td>
				<td class="bt_info_odd" width="8%">调配数量</td>
				<td class="bt_info_even" width="10%">调配人</td>
				<td class="bt_info_odd" width="10%">调配时间</td>
			</tr>
		   <tbody id="processtable" name="processtable">
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
				alert("请选择项目信息!");
				return;
			}
			var out_org_id = $("#out_org_id").val();
			if(out_org_id==''){
				alert("请选择转出单位信息!");
				return;
			}
			var paramobj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devmixdetail/selectMDM.jsp?out_org_id="+out_org_id+"&projectinfono="+project_info_no,paramobj,"dialogWidth=305px;dialogHeight=420px");
			var seq = $("tr","#processtable").size();
			if(vReturnValue!=undefined){
				var returnvalues = vReturnValue.split('~');
				var innerhtml = "<tr id='tr"+returnvalues[0]+"' name='tr'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+returnvalues[0]+"'/></td>";
				innerhtml += "<td>"+(seq+1)+"<input type='hidden' id='mdmid'"+seq+" name='mdmid' value='"+returnvalues[0]+"'></td>";
				innerhtml += "<td>"+returnvalues[2]+"</td>";
				innerhtml += "<td>"+returnvalues[3]+"</td>";
				innerhtml += "<td>"+returnvalues[4]+"</td>";
				innerhtml += "<td>"+returnvalues[1]+"</td>";
				innerhtml += "<td>"+returnvalues[5]+"</td>";
				innerhtml += "</tr>";
			
				$("#processtable").append(innerhtml);
				//异步查询设备明细信息，回填到设备明细中
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
			if(returnvalues[0]!=null){
				var devdetSql = "select amm.device_mix_id,amd.asset_coding,ad.dev_ci_code,ci.dev_ci_name,ci.dev_ci_model,amd.self_num,amd.dev_sign,";
				devdetSql += "amd.license_num,amd.dev_plan_start_date,amd.dev_plan_end_date ";
				devdetSql += "from gms_device_appmix_detail amd ";
				devdetSql += "left join gms_device_appmix_main amm on amd.device_mix_id = amm.device_mix_id ";
				devdetSql += "left join gms_device_app_detail ad on amm.device_app_detid = ad.device_app_detid ";
				devdetSql += "left join gms_device_codeinfo ci on ci.dev_ci_code = ad.dev_ci_code ";
				devdetSql += "left join gms_device_app app on ad.device_app_id = app.device_app_id ";
				devdetSql += "left join gms_device_mixinfo_detail mid on mid.device_mix_id = amm.device_mix_id ";
				devdetSql += "where amm.state = '9' and amm.device_mix_id = '"+returnvalues[0]+"' ";
				devdetSql += "order by amd.asset_coding";
				var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				var retObj = proqueryRet.datas;
				for(var index=0;index<retObj.length;index++){
					var innerhtml = "<tr id='tr"+retObj[index].dev_coding+"' name='tr' midinfo='"+retObj[index].device_mix_id+"'>";
					innerhtml += "<td>"+retObj[index].asset_coding+"</td>";
					innerhtml += "<td>"+retObj[index].dev_ci_name+"</td>";
					innerhtml += "<td>"+retObj[index].dev_ci_model+"</td>";
					innerhtml += "<td>"+retObj[index].self_num+"</td>";
					innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
					innerhtml += "<td>"+retObj[index].license_num+"</td>";
					innerhtml += "<td>1</td>";
					innerhtml += "<td>"+retObj[index].dev_plan_start_date+"</td>";
					innerhtml += "<td>"+retObj[index].dev_plan_end_date+"</td>";
					innerhtml += "</tr>";
					$("#detailtable").append(innerhtml);
				}
				$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
				$("#detailtable>tr:odd>td:even").addClass("odd_even");
				$("#detailtable>tr:even>td:odd").addClass("even_odd");
				$("#detailtable>tr:even>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){
					var id=this.id;
					$("#tr"+id).remove();
					$("tr[name='tr'][midinfo='"+id+"']","#detailtable").each(function(){
						$(this).remove();
					});
				}
			});
			$("#processtable>tbody>tr>td:odd").addClass("odd_odd");
			$("#processtable>tbody>tr>td:even").addClass("odd_even");
			$("#processtable>tbody>tr>td:odd").addClass("even_odd");
			$("#processtable>tbody>tr>td:even").addClass("even_even");
			$("#detailtable>tbody>tr>td:odd").addClass("odd_odd");
			$("#detailtable>tbody>tr>td:even").addClass("odd_even");
			$("#detailtable>tbody>tr>td:odd").addClass("even_odd");
			$("#detailtable>tbody>tr>td:even").addClass("even_even");
		});
	});
	function saveInfo(){
		var mdmids = $("input[name='mdmid']").size();
		if(mdmids==0){
			alert("请添加调配明细信息!");
			return;
		}else{
			mdmids = "";
			$("input[name='mdmid']").each(function(i){
				if(i==0){
					mdmids = "('"+this.value;
				}else{
					mdmids += "','"+this.value;
				}
			});
			mdmids += "')";
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMDFInfo.srq?state=0&mdmids="+mdmids;
		document.getElementById("form1").submit();
	}
	
	function submitInfo(){
		var mdmids = $("input[name='mdmid']").size();
		if(mdmids==0){
			alert("请添加调配明细信息!");
			return;
		}else{
			mdmids = "";
			$("input[name='mdmid']").each(function(i){
				if(i==0){
					mdmids = "('"+this.value;
				}else{
					mdmids += "','"+this.value;
				}
			});
			mdmids += "')";
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMDFInfo.srq?state=9&mdmids="+mdmids;
		document.getElementById("form1").submit();
	}
	
	function showDevPage(trid){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp",obj,"dialogWidth=305px;dialogHeight=420px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var devicename = returnvalues[0].substr(returnvalues[0].indexOf(':')+1,(returnvalues[0].indexOf('(')-returnvalues[0].indexOf(':')-1));
			var devicetype = returnvalues[0].substr(returnvalues[0].indexOf('(')+1,(returnvalues[0].indexOf(')')-returnvalues[0].indexOf('(')-1));
			var deviceCode = returnvalues[1].substr(returnvalues[1].indexOf(':')+1,(returnvalues[1].length-returnvalues[1].indexOf(':')));
			$("input[name='devicename"+trid+"']","#processtable").val(devicename);
			$("input[name='devicetype"+trid+"']","#processtable").val(devicetype);
			$("input[name='signtype"+trid+"']","#processtable").val(deviceCode);
		}
	}
</script>
<script type="text/javascript"> 
	$().ready(function(){
		$("#project_info_no").change(function(){
			var inorg = $("option[selected='selected']","#project_info_no").attr("inorg");
			var inorginfos = inorg.split("~");
			$("#in_org_id").val(inorginfos[0]);
			$("#in_org_name").val(inorginfos[1]);
			var project_info_no = $("option[selected='selected']","#project_info_no").val();
			resetMixappSelect(project_info_no);		
		});
		/*
		$("#device_app_id").change(function(){
			var device_app_id = $("option[selected='selected']","#device_app_id").val();
			resetOutOrg(device_app_id);
		});
		*/
	});
	function showOutOrgPage(){
		var deviceappid = $("#device_app_id").val();
		if(deviceappid==""){
			alert("请选择调配单信息!");
			return;
		}
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devmixdetail/selectOutOrgId.jsp?devappid="+deviceappid,obj,"dialogWidth=305px;dialogHeight=420px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("#out_org_id").val(returnvalues[0]);
			$("#out_org_name").val(returnvalues[1]);
		}
	}
	function resetOutOrg(device_app_id){
		var prosql = "select distinct amm.out_org_id,org.org_name as out_org_name ";
			prosql += "from gms_device_appmix_main amm ";
			prosql += "join gms_device_app_detail ad on amm.device_app_detid=ad.device_app_detid ";
			prosql += "join comm_org_information org on org.org_id=amm.out_org_id ";
			prosql += "where amm.is_add_detail='Y' ";
			//prosql += "and amm.is_print_form='N' ";
			prosql += "and ad.device_app_id='"+device_app_id+"' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		if(retObj.length>=1){
			var innerHtml = "";
			for(var index=0;index<retObj.length;index++){
				innerHtml += "<option value='"+retObj[index].out_org_id+"'>"+retObj[index].out_org_name+"</option>";
			}
			$("#out_org_id").append(innerHtml);
		}else{
			var innerHtml = "<option value=''>请选择转出单位</option>";
			$("#out_org_id").append(innerHtml);
		}
	}
	function resetMixappSelect(project_info_no){
		var prosql = "select distinct devapp.device_app_id,devapp.device_app_no  ";
			prosql += "from gms_device_app devapp ";
			prosql += "where devapp.bsflag='0' and devapp.project_info_no='"+project_info_no+"' ";
			prosql += "and exists(select 1 from gms_device_appmix_main amm ";
			prosql += "join gms_device_app_detail ad on amm.device_app_detid=ad.device_app_detid where amm.is_add_detail='Y' ";
			//prosql += "and amm.is_print_form='N' ";
			prosql += "and ad.device_app_id=devapp.device_app_id) ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		if(retObj.length>=1){
			var innerHtml = "<option value=''>请选择申请单</option>";
			for(var index=0;index<retObj.length;index++){
				innerHtml += "<option value='"+retObj[index].device_app_id+"'>"+retObj[index].device_app_no+"</option>";
			}
			$("#device_app_id").append(innerHtml);
		}else{
			var innerHtml = "<option value=''>请选择申请单</option>";
			$("#device_app_id").append(innerHtml);
		}
	}
	function refreshData(){
		var infosql = "select device_mixinfo_id,mixinfo_no,device_app_id,project_info_no,in_org_id,inorg.org_name as in_org_name,out_org_id,print_emp_id,org.org_name as out_org_name ";
		infosql += "from gms_device_mixinfo_form mif left join comm_org_information org on org.org_id=mif.out_org_id ";
		infosql += "left join comm_org_information inorg on inorg.org_id=mif.out_org_id ";
		infosql += "where mif.device_mixinfo_id='<%=device_mixinfo_id%>'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+infosql);
		var infoObj = proqueryRet.datas;
			
		var proSql = "select distinct amm.project_info_no,amm.in_org_id,pro.project_name,org.org_name as in_org_name ";
			proSql += "from gms_device_appmix_main amm ";
			proSql += "left join gp_task_project pro on amm.project_info_no=pro.project_info_no ";
			proSql += "left join comm_org_information org on org.org_id=amm.in_org_id ";
			proSql += "where amm.bsflag='0' and amm.org_id='<%=orgid%>' ";
			proSql += "and amm.is_add_detail='Y' and amm.org_id='<%=orgid%>' ";
			//proSql += "where amm.is_print_form='N' ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		var retObj = proqueryRet.datas;
		if(retObj.length>=1){
			var innerHtml = "<option value=''>请选择项目</option>";
			for(var index=0;index<retObj.length;index++){
				innerHtml += "<option value='"+retObj[index].project_info_no+"' inorg='"+retObj[index].in_org_id+"~"+retObj[index].in_org_name+"'>"+retObj[index].project_name+"</option>";
			}
			$("#project_info_no").append(innerHtml);
		}else{
			var innerHtml = "<option value=''>请选择项目</option>";
			$("#project_info_no").append(innerHtml);
		}
		$("#project_info_no").val(infoObj[0].project_info_no);
		//补充对调配单号的显示
		$("#mixinfo_no").val(infoObj[0].mixinfo_no);
		$("#in_org_name").val(infoObj[0].in_org_name);
		$("#in_org_id").val(infoObj[0].in_org_id);
		resetMixappSelect(infoObj[0].project_info_no);
		$("#device_app_id").val(infoObj[0].device_app_id);
		
		$("#out_org_name").val(infoObj[0].out_org_name);
		$("#out_org_id").val(infoObj[0].out_org_id);
		
		var listsql = "select amm.device_mix_id,emp.employee_name as assign_emp_name,ci.dev_ci_name,";
		listsql += "ci.dev_ci_model,assign_num,to_char(amm.modifi_date,'yyyy-mm-dd') as assign_date ";
		listsql += "from gms_device_appmix_main amm ";
		listsql += "left join gms_device_mixinfo_detail md on md.device_mix_id=amm.device_mix_id ";
		listsql += "left join gms_device_mixinfo_form mif on mif.device_mixinfo_id = md.device_mixinfo_id ";
		listsql += "left join comm_org_information org on org.org_id=mif.out_org_id ";
		listsql += "left join comm_human_employee emp on amm.assign_emp_id=emp.employee_id ";
		listsql += "left join gms_device_app_detail ad on amm.device_app_detid=ad.device_app_detid ";
		listsql += "left join gms_device_codeinfo ci on ad.dev_ci_code=ci.dev_ci_code ";
		listsql += "where mif.device_mixinfo_id='<%=device_mixinfo_id%>'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+listsql);
		var listObj = proqueryRet.datas;
		for(var listindex=0;listindex<listObj.length;listindex++){
			var innerhtml = "<tr id='tr"+listObj[listindex].device_mix_id+"' name='tr'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+listObj[listindex].device_mix_id+"'/></td>";
			innerhtml += "<td>"+(listindex+1)+"<input type='hidden' id='mdmid'"+listindex+" name='mdmid' value='"+listObj[listindex].device_mix_id+"'></td>";
			innerhtml += "<td>"+listObj[listindex].dev_ci_name+"</td>";
			innerhtml += "<td>"+listObj[listindex].dev_ci_model+"</td>";
			innerhtml += "<td>"+listObj[listindex].assign_num+"</td>";
			innerhtml += "<td>"+listObj[listindex].assign_emp_name+"</td>";
			innerhtml += "<td>"+listObj[listindex].assign_date+"</td>";
			innerhtml += "</tr>";
		
			$("#processtable").append(innerhtml);
			//异步查询设备明细信息，回填到设备明细中
			if(listObj[listindex].device_mix_id!=null){
			var devdetSql = " select amm.device_mix_id, amd.asset_coding, ad.dev_ci_code, ci.dev_ci_name, ci.dev_ci_model,";
				devdetSql += " amd.self_num, amd.dev_sign, amd.license_num, amd.dev_plan_start_date, amd.dev_plan_end_date ";
				devdetSql += " from gms_device_appmix_detail amd left join gms_device_appmix_main amm on amd.device_mix_id = amm.device_mix_id ";
				devdetSql += " left join gms_device_app_detail ad on amm.device_app_detid = ad.device_app_detid ";
				devdetSql += " left join gms_device_codeinfo ci on ci.dev_ci_code = ad.dev_ci_code ";
				devdetSql += " left join gms_device_app app on ad.device_app_id = app.device_app_id ";
				devdetSql += " where amm.state = '9' and amm.device_mix_id = '"+listObj[listindex].device_mix_id+"'  ";
				devdetSql += " and exists(select 1 from gms_device_mixinfo_detail md join  ";
				devdetSql += " gms_device_mixinfo_form mif on mif.device_mixinfo_id =  md.device_mixinfo_id  where md.device_mix_id=amm.device_mix_id  ";
				devdetSql += " and mif.device_mixinfo_id = '<%=device_mixinfo_id%>') ";
				devdetSql += " order by amd.asset_coding ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
			var retObj = proqueryRet.datas;
			for(var index=0;index<retObj.length;index++){
				var innerhtml = "<tr id='tr"+retObj[index].dev_coding+"' name='tr' midinfo='"+retObj[index].device_mix_id+"'>";
				innerhtml += "<td>"+retObj[index].asset_coding+"</td>";
				innerhtml += "<td>"+retObj[index].dev_ci_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_ci_model+"</td>";
				innerhtml += "<td>"+retObj[index].self_num+"</td>";
				innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
				innerhtml += "<td>"+retObj[index].license_num+"</td>";
				innerhtml += "<td>1</td>";
				innerhtml += "<td>"+retObj[index].dev_plan_start_date+"</td>";
				innerhtml += "<td>"+retObj[index].dev_plan_end_date+"</td>";
				innerhtml += "</tr>";
				$("#detailtable").append(innerhtml);
			}
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
		$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#detailtable>tr:odd>td:even").addClass("odd_even");
		$("#detailtable>tr:even>td:odd").addClass("even_odd");
		$("#detailtable>tr:even>td:even").addClass("even_even");
		
		$("#project_info_no").attr("disabled","disabled");
		$("#device_app_id").attr("disabled","disabled");
		
	}
}
</script>
</html>
