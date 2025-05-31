<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String collappid = request.getParameter("collappid");
	String oprstate = request.getParameter("oprstate");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">
	.FixedTitleRow
        {
            position: relative; 
            top: expression(this.offsetParent.scrollTop); 
            z-index: 1;
			background-color: #E6ECF0;
        }
</style>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>(自有设备)返还调配单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:96%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >返还调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="collbackappid" id="collbackappid" type="hidden" value="<%=collappid%>" />
          	<input name="backmix_org_id" id="backmix_org_id" type="hidden" value="" />
          	<input name="back_dev_type" id="back_dev_type" type="hidden" value="" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请单号:</td>
          <td class="inquire_form4" >
          	<input name="coll_backapp_no" id="coll_backapp_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >返还申请单名称:</td>
          <td class="inquire_form4" >
          	<input name="back_app_name" id="back_app_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请单位:</td>
          <td class="inquire_form4" >
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" type="hidden"  value="" />
          </td>
          <td class="inquire_item4" >设备接收单位:</td>
          <td class="inquire_form4" >
          	<input name="own_org_name" id="own_org_name" class="input_width" type="text"  value="" readonly/><img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage('own_org')" />
          	<input name="own_org_id" id="own_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请时间:</td>
          <td class="inquire_form4" >
          	<input name="back_date" id="back_date" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
      <!-- <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="5%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="填报返还明细"></a></span></td>
          <td width="95%"></td>
        </tr>
      </table> -->
      <fieldset style="margin-left:2px"><legend>调配台账明细</legend>
		<div id="table_box" class="tab_box" style="height:150px;overflow:auto">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="tab_line_height">
				<tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='colldevbackinfo' name='colldevbackinfo' /></td>
					<td class="bt_info_even" width="20%">设备名称</td>
					<td class="bt_info_odd" width="20%">规格型号</td>
					<td class="bt_info_even" width="20%">原出库单位</td>
					<td class="bt_info_odd" width="10%">返还数量</td>
					<td class="bt_info_even" width="10%">已调配数量</td>
					<td class="bt_info_odd" width="10%">调配数量</td>
				</tr>
				<tbody id="colldetailtable" name="colldetailtable">
			    </tbody>
			</table>
		</div>
		<table id="fenye_box_table">
		</table>
	  </fieldset>
	  <fieldset style="margin-left:2px"><legend>附属设备</legend>
		  <div id="tab_box" class="tab_box" style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='devbackinfo' name='devbackinfo' /></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<td class="bt_info_odd" width="15%">AMIS设备编号</td>
					<td class="bt_info_even" width="4%">数量</td>
					<td class="bt_info_odd" width="10%">计划离场时间</td>
					<td class="bt_info_even" width="12%">实际离场时间</td>
				</tr>
				<tbody id="addeddetailtable" name="addeddetailtable">
			    	</tbody>
				</table>
			</div>
       </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	var oprstate_tmp="<%=oprstate%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var checked = false;
	
	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}else{
			checked = true;
		}
	}
	function submitInfo(state){
		var own_org_id = $("#own_org_id").val();
		if(own_org_id==''){
			alert("请选择设备接收单位!");
			return;
		}
		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("input[type='checkbox'][name='idinfo1']").each(function(){
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
					idinfos = this.value;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+this.value;
				}
				count++;
			}
		});
		
		if(count != 0){
			var selectedlines = line_infos.split("~");
			var wronglineinfos = "";
			var wrongcount = 0;
			for(var index=0;index<selectedlines.length;index++){
				var valueinfo = $("#mixnum"+selectedlines[index]).val();
				if(valueinfo == ""){
					if(wrongcount == 0){
						wronglineinfos += (parseInt(selectedlines[index])+1);
					}else{
						wronglineinfos += ","+(parseInt(selectedlines[index])+1);
					}
				}
			}
			if(wronglineinfos!=""){
				alert("请设置第"+wronglineinfos+"行明细的调配数量!");
				return;
			}
		}
		//附属设备明细信息
		var addcount=0;
		var addline_infos;
		var addid_infos;
		$("input[type='checkbox'][name='idinfo2']").each(function(){
			if(this.checked == true){
				if(addcount == 0){
					addline_infos = this.id;
					addid_infos = this.value;
				}else{
					addline_infos += "~"+this.id;
					addid_infos += "~"+this.value;
				}
				addcount++;
			}
		});
		if(count == 0 && addcount == 0){
			alert('请选择调配单明细信息！');
			return;
		}

		if(window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").action ="<%=contextPath%>/rm/dm/toSaveBackMIXInfoNew.srq?count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
			document.getElementById("form1").submit();
		}

		if(addcount != 0){			
			//给调配单号设置成空
			$("#mixinfo_no").val("");
			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackCollInfoNew.srq?addcount="+addcount+"&addline_infos="+addline_infos+"&addid_infos="+addid_infos;				
			document.getElementById("form1").submit();
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
		
	function toMixDetailInfos(){
		
		var value = "<%=collappid%>";
		var own_org_id = $("#own_org_id").val();
		if(own_org_id==''){
			alert("请选择设备接收单位!");
			return;
		}
		$("#colldetailtable").empty();
		$("#addeddetailtable").empty();

		var collpostSql = "select d.device_backdet_id,d.dev_acc_id,d.dev_name,d.dev_model,d.back_num,nvl(sum(cbd.back_num),0) as mixnum ";
		collpostSql+="from gms_device_collbackapp_detail d left join GMS_DEVICE_COLLBACKAPP app on d.device_backapp_id=app.device_backapp_id ";
		collpostSql+="and app.bsflag='0' left join GMS_DEVICE_COLL_BACK_DETAIL cbd on d.device_backdet_id=cbd.device_backdet_id ";
		collpostSql+="where d.device_backapp_id='"+value+"' group by d.device_backdet_id,d.dev_name,d.dev_model,d.back_num,d.dev_acc_id ";
		
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+collpostSql+'&pageSize=1000');
		var collretObj = proqueryRet.datas;
		addLine(collretObj);

		var postSql = "select det.device_backdet_id,det.device_backapp_id,acc.dev_acc_id,acc.dev_name,acc.dev_model, acc.self_num,acc.dev_sign,acc.license_num,acc.asset_coding，acc.planning_out_time,acc.actual_out_time from gms_device_backapp_detail det join(";
		postSql+="select * from gms_device_backapp bapp left join (select device_backapp_no ";
		postSql+="from gms_device_collbackapp where device_backapp_id='"+value+"') temp ";
		postSql+="on bapp.device_backapp_no=temp.device_backapp_no ";
		postSql+="where bapp.device_backapp_no=temp.device_backapp_no) temp2 ";
		postSql+="on det.device_backapp_id=temp2.device_backapp_id ";
		postSql+="left join gms_device_account_dui acc ";
		postSql+="on det.dev_acc_id = acc.dev_acc_id ";
		
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+postSql+'&pageSize=1000');
		var retObj = proqueryRet.datas;
		addLine2(retObj);
	}
	function addLine(collretObj){
		var rows = document.getElementById("colldetailtable").rows.length;
		
		for(var index=rows;index<rows+collretObj.length;index++){
			var innerhtml = "<tr id='tr1"+index+"' name='tr1"+index+"' seq='"+index+"'>";
			innerhtml += "<td width='4%'><input type='checkbox' name='idinfo1' id ='"+index+"' value='"+collretObj[index-rows].device_backdet_id+"' /><input name='devcollaccid"+index+"' id='devcollaccid"+index+"' value='"+collretObj[index-rows].dev_acc_id+"' type='hidden' /></td>";
			innerhtml += "<td width='20%'><input name='dev_name"+index+"' id='dev_name"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+collretObj[index-rows].dev_name+"' readonly/></td>";
			innerhtml += "<td width='20%'><input name='dev_model"+index+"' id='dev_model"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+collretObj[index-rows].dev_model+"' readonly/></td>";
			innerhtml += "<td width='10%'><input name='dev_out"+index+"' id='dev_out"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+collretObj[index-rows].org_abbreviation+"' readonly/></td>";
			innerhtml += "<td width='10%'><input name='backnum"+index+"' id='backnum"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+collretObj[index-rows].back_num+"' readonly/></td>";
			innerhtml += "<td width='10%'><input name='mixednum"+index+"' id='mixednum"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+collretObj[index-rows].mixnum+"' readonly/></td>";
			innerhtml += "<td width='10%'><input name='mixnum"+index+"' id='mixnum"+index+"' mixnumindex = '"+index+"' style='line-height:18px;width:98%' onkeyup='checkAssignNum(this)' type='text' size='8' value=''/></td>";
			
			innerhtml += "</tr>";
			$("#colldetailtable").append(innerhtml);
		}
		$("#colldetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#colldetailtable>tr:odd>td:even").addClass("odd_even");
		$("#colldetailtable>tr:even>td:odd").addClass("even_odd");
		$("#colldetailtable>tr:even>td:even").addClass("even_even");
	}
	
	function addLine2(retObj){
		var rows = document.getElementById("addeddetailtable").rows.length;
		for(var index=rows;index<rows+retObj.length;index++){
			var innerhtml = "<tr id='tr2"+index+"' name='tr2"+index+"' addseq='"+index+"'>";
			innerhtml += "<td width='4%'><input type='checkbox' name='idinfo2' id='"+index+"' value='"+retObj[index-rows].device_backdet_id+"'/><input name='devaccid"+index+"' id='devaccid"+index+"' value='"+retObj[index-rows].dev_acc_id+"' type='hidden' /></td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].self_num+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index-rows].dev_sign+"</td>";
			innerhtml += "<td width='11%'>"+retObj[index-rows].license_num+"</td>";
			innerhtml += "<td width='15%'>"+retObj[index-rows].asset_coding+"</td>";
			innerhtml += "<td width='4%'>1</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].planning_out_time+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index-rows].actual_out_time+"</td>";
			
			innerhtml += "</tr>";
			$("#addeddetailtable").append(innerhtml);
		}
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}

	function checkAssignNum(obj){
		var index = obj.mixnumindex;
		var mixednumVal = parseInt($("#mixednum"+index).val(),10);//已调配数量
		var backnumVal = parseInt($("#backnum"+index).val(),10);//返还数量
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("出库数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(objValue,10)>backnumVal){
				alert("调配数量必须小于等于返还数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+mixednumVal)>backnumVal){
				alert("调配数量必须小于等于未调配数量!");
				obj.value = "";
				return false;
			}
		}
	}
	
	function refreshData(){
		var value = "<%=collappid%>";
		var retObj;
		var basedatas;
		if('<%=collappid%>'!=null){
			//回填基本信息
			var str = "select b.device_backapp_id,b.backapp_name,b.backdevtype,p.project_name,b.device_backapp_no,to_char(b.backdate,'yyyy-mm-dd') as appdate,i.org_abbreviation as back_org_name,b.back_org_id,b.project_info_id,coi.org_abbreviation as backmix_org_name, b.backmix_org_id from gms_device_collbackapp b left join gp_task_project p on b.project_info_id=p.project_info_no and p.bsflag='0' left join comm_org_information i on b.back_org_id=i.org_id and i.bsflag='0' left join comm_org_information coi on b.backmix_org_id=coi.org_id and coi.bsflag='0' "
			+"where b.device_backapp_id='<%=collappid%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_id);
				$("#coll_backapp_no").val(retObj[0].device_backapp_no);
				$("#back_app_name").val(retObj[0].backapp_name);
				$("#back_date").val(retObj[0].appdate);
				$("#back_org_name").val(retObj[0].back_org_name);
				$("#back_org_id").val(retObj[0].back_org_id);
				$("#backmix_org_id").val(retObj[0].backmix_org_id);
				$("#back_dev_type").val(retObj[0].backdevtype);
			}
			var collpostSql = "select d.device_backdet_id,d.dev_acc_id,d.dev_name,d.dev_model,d.back_num,nvl(sum(cbd.back_num),0) as mixnum,org.org_abbreviation ";
			collpostSql+="from gms_device_collbackapp_detail d left join GMS_DEVICE_COLLBACKAPP app on d.device_backapp_id=app.device_backapp_id ";
			collpostSql+="and app.bsflag='0' left join GMS_DEVICE_COLL_BACK_DETAIL cbd on d.device_backdet_id=cbd.device_backdet_id ";
			collpostSql+="left join gms_device_coll_account_dui acc on acc.dev_acc_id = d.dev_acc_id left join comm_org_information org on org.org_id=acc.out_org_id ";
			collpostSql+="where d.device_backapp_id='"+value+"' group by d.device_backdet_id,d.dev_name,d.dev_model,d.back_num,d.dev_acc_id,org.org_abbreviation ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+collpostSql+'&pageSize=1000');
			var collretObj = proqueryRet.datas;
			addLine(collretObj);

			var postSql = "select det.device_backdet_id,det.device_backapp_id,acc.dev_acc_id,acc.dev_name,acc.dev_model, acc.self_num,acc.dev_sign,acc.license_num,acc.asset_coding，acc.planning_out_time,acc.actual_out_time from gms_device_backapp_detail det join(";
			postSql+="select * from gms_device_backapp bapp left join (select device_backapp_no ";
			postSql+="from gms_device_collbackapp where device_backapp_id='"+value+"') temp ";
			postSql+="on bapp.device_backapp_no=temp.device_backapp_no ";
			postSql+="where bapp.device_backapp_no=temp.device_backapp_no) temp2 ";
			postSql+="on det.device_backapp_id=temp2.device_backapp_id ";
			postSql+="left join gms_device_account_dui acc ";
			postSql+="on det.dev_acc_id = acc.dev_acc_id ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+postSql+'&pageSize=1000');
			var retObj = proqueryRet.datas;
			addLine2(retObj);
		}
	}
	
	$().ready(function(){
		$("#devbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='idinfo2']").attr('checked',checkvalue);
		});
		$("#colldevbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='idinfo1']").attr('checked',checkvalue);
		});
		
		//已关闭的调配申请单屏蔽提交按钮
	    if(oprstate_tmp == '4'){
	    	$(".tj_btn").hide();      
	    }
	});
</script>
</html>

