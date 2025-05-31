<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("devappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getOrgSubjectionId();
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
<title>按量设备调配单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=devappid%>" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >申请时间:</td>
          <td class="inquire_form4" >
          	<input name="app_date" id="app_date" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >转入单位:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="" />
          </td>
          <td class="inquire_item4" >转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" 
          	     style="cursor:hand;" onclick="showOrgTreePage('out_org')" />
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldSet>
	  <fieldSet style="margin-left:2px"><legend>调配明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%">选择</td>
					<td class="bt_info_even" width="9%">班组</td>
					<td class="bt_info_odd" width="14%">设备名称</td>
					<td class="bt_info_even" width="14%">规格型号</td>
					<td class="bt_info_odd" width="9%">计量单位</td>
					<td class="bt_info_even" width="9%">申请数量</td>
					<td class="bt_info_odd" width="9%">已调配数量</td>
					<td class="bt_info_even" width="9%">总数量</td>
					<td class="bt_info_odd" width="9%">闲置数量</td>
					<td class="bt_info_even" width="9%">调配数量</td>
					<td class="bt_info_odd" width="14%">备注</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
		      </table>
		      <div style="height:90px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	 	<tbody id="processtable" name="processtable">
			    	</tbody>
				</table>
			  </div>
	       </div>
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>附属设备</legend>
		  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td width="5%"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
	          <td width="5%"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
	          <td width="90%"></td>
	        </tr>
	      </table>
		  <div id="tab_box" class="tab_box" style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_odd" width="4%"><input type="checkbox" name="alldetinfo" id="alldetinfo" checked="true"/></td>
						<td class="bt_info_even" width="12%">班组</td>
						<td class="bt_info_odd" width="12%">设备名称</td>
						<td class="bt_info_even" width="12%">规格型号</td>
						<td class="bt_info_odd" width="10%">计量单位</td>
						<td class="bt_info_even" width="10%">调配数量</td>
						<td class="bt_info_odd" width="10%">备注</td>
					</tr>
				</table>
				<div style="height:90px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	 	<tbody id="addeddetailtable" name="addeddetailtable">
			    	</tbody>
					</table>
				</div>
			</div>
       </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span>
     	<span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	(function($){
		$.fn.disableLineInput = function(){
			$("input[type='text']",$(this)).attr("disabled","disabled");
		};
		$.fn.enableLineInput = function(){
			$("input[type='text']",$(this)).removeAttr("disabled");
		};
	})(jQuery)
	$().ready(function(){
		$("#alldetinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='addedseq']").attr('checked',checkvalue);
		});
	});
	function submitInfo(state){
		//给信息保存到数据库中，重写入库操作
		if($("#out_org_name").val()==''){
			alert("请选择转出单位!");
			return;
		}
		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
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
		if(count == 0){
			alert('请选择调配单明细信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		var outlineinfos = "";
		var wrongcount = 0;
		var bigcount = 0;
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#mixnum"+selectedlines[index]).val();
			var unuseinfo = $("#unusenum"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(wrongcount == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}else if(parseInt(valueinfo,10)>parseInt(unuseinfo,10)){
				if(bigcount == 0){
					outlineinfos += (parseInt(selectedlines[index])+1);
				}else{
					outlineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的调配数量!");
			return;
		}
		//添加的明细信息必须有名称和数量
		var addedwrongflag = false;
		$("input[type='text'][name^='addeddevicename']").each(function(){
			var devicenameinfo  = this.value;
			var index = this.idindex ;
			var assignnuminfo = document.getElementById("addedassignnum"+index);
			if(devicenameinfo==""||assignnuminfo==""){
				addedwrongflag = true;
			}
		})
		if(addedwrongflag){
			alert("调配明细信息的名称和数量不为空,请完善补充调配明细信息!");
			return;
		}
		if(outlineinfos!=""){
			var showinfo = "第"+outlineinfos+"行明细的调配数量大于闲置数量，是否继续?";
			if(!confirm(showinfo)){
				return;
			}
		}
		//补充明细的seq信息
		var addedcount=0;
		var addedline_info;
		$("input[type='checkbox'][name='addedseq']").each(function(){
			if(this.checked == true){
				if(addedcount == 0){
					addedline_info = this.id;
				}else{
					addedline_info += "~"+this.id;
				}
				addedcount++;
				}
		});
		//如果数量大于闲置数量，那么给出相关提示
		var detailcount = $("input[type='hidden'][name^='deviceid']","#detailtable").size();
		//给调配单号设置成空
		$("#mixinfo_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveEQBatchMixFormDetailInfo.srq?state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&detailcount="+detailcount+"&addedcount="+addedcount+"&addedline_info="+addedline_info;
		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
		}else if(state==0){
			document.getElementById("form1").submit();
		}
	}
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
		var orgidvalue = orgId[1];
		document.getElementById(str+"_id").value = orgidvalue;
		fillAppDetailNouseNum(orgidvalue);
	}
	function fillAppDetailNouseNum(orgidvalue){
		//给所有的unusenum设置为空
		$("input[type='text'][name^='unusenum']","#processtable").val("");
		
		var mainsql = "select count(ct.device_id) total_num,ct.device_id,sum(nvl2(b.usage_org_id,0,1)) unuse_num ";
		mainsql += " from gms_device_account_b b ";
		mainsql += " join GMS_DEVICE_CODEINFO cltype on cltype.dev_ci_code=b.dev_type ";
		mainsql += " join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code ";
		mainsql += " join GMS_DEVICE_COLLECTINFO ct on ct.device_id=mp.device_id ";
		mainsql += " where b.owning_org_id = '"+orgidvalue+"' and b.bsflag='0' and ct.device_id in( ";
		mainsql += " select sub.device_id from gms_device_app_colldetsub sub ";
		mainsql += " join gms_device_app_colldetail detail ";
		mainsql += " on sub.device_app_detid=detail.device_app_detid and detail.device_app_id='<%=devappid%>') ";
		mainsql += " group by ct.device_id ";
		
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
		retObj = proqueryRet.datas;
		if(retObj!=undefined && retObj.length>0){
			var maxline =  $("#processtable>tr").size();
			for(var index=0;index<retObj.length&&index<maxline;index++){
				var j = 0;
				var currentvalue = retObj[index].device_id;
				for(;j<maxline;j++){
					var lineidvalue = $("#deviceid"+j).val();
					if(lineidvalue != currentvalue){
						//$("#tr"+j,"#processtable").disableLineInput();
						$("input:checkbox[name^='detinfo'][id="+j+"]").attr("disabled","disabled");
						$("input:checkbox[name^='detinfo'][id="+j+"]").removeAttr("checked");
					}else{
						//$("#tr"+j,"#processtable").enableLineInput();
						$("input:checkbox[name^='detinfo'][id="+j+"]").removeAttr("disabled");
						$("input:checkbox[name^='detinfo'][id="+j+"]").attr("checked","checked");
						$("#totalnum"+j,"#processtable").val(retObj[index].total_num);
						$("#unusenum"+j,"#processtable").val(retObj[index].unuse_num);
					}
				}
			}
		}else{
			var maxline = $("#processtable>tr").size();
			for(var j = 0;j<maxline;j++){
				//$("#tr"+j,"#processtable").disableLineInput();
				$("input:checkbox[name^='detinfo']").attr("disabled","disabled");
				$("input:checkbox[name^='detinfo']").removeAttr("checked");
			}
		}
		//给为空的都屏蔽了
		$("#processtable>tr").each(function(i){
			var tmpval = $("#unusenum"+i).val();
			if(tmpval!= '' && tmpval != null){
				if(parseInt(tmpval)>0){
				$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("disabled");
				$("input:checkbox[name^='detinfo'][id="+i+"]").attr("checked","checked");
				$(this).enableLineInput();
				}
				else{
					$("input:checkbox[name^='detinfo'][id="+i+"]").attr("disabled","disabled");
					$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("checked");
					$(this).disableLineInput();
					}
			}else{
				$("input:checkbox[name^='detinfo'][id="+i+"]").attr("disabled","disabled");
				$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("checked");
				$(this).disableLineInput();
			}
		});
	}
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		//获得第一行的team信息
		var teamname = $("input[name^='teamname'][type='text']")[0].value;
		var team = $("input[name^='team'][type='hidden']")[0].value;
		addedseqinfo++;
		var innerhtml = "<tr id='traddedseq"+addedseqinfo+"' name='traddedseq"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+addedseqinfo+"'/></td>";
		innerhtml += "<td width='12%'><input name='addedteamname"+addedseqinfo+"' id='addedteamname"+addedseqinfo+"' value='"+teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
		innerhtml += "<input name='addedteam"+addedseqinfo+"' id='addedteam"+addedseqinfo+"' value='"+team+"' type='hidden' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedunit"+addedseqinfo+"' id='addedunit"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='8' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedassignnum"+addedseqinfo+"' id='addedassignnum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)'/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function toDelAddedDetailInfos(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id;
				$("#traddedseq"+index).remove();
			}
		});
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function refreshData(){
		var retObj;
		var devObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var mainsql = "select devapp.device_app_no,devapp.project_info_no,devapp.app_org_id as in_org_id,";
			mainsql += "devapp.appdate,tp.project_name,inorg.org_abbreviation as in_org_name ";
			mainsql += "from gms_device_collapp devapp ";
			mainsql += "left join gp_task_project tp on devapp.project_info_no=tp.project_info_no ";
			mainsql += "left join comm_org_information inorg on devapp.app_org_id=inorg.org_id ";
			mainsql += "where devapp.device_app_id='<%=devappid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#appinfo_no").val(retObj[0].device_app_no);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
			}
			//回填明细信息
			var prosql = "select cms.device_app_detid,cms.device_detsubid,cms.device_id,cms.device_name,cms.device_model,cms.device_num as applynum,";
				prosql += "nvl(temp.mixednum,0) mixednum,cms.unit_id,unitsd.coding_name as unit_name,";
				prosql += "cd.team,teamsd.coding_name as team_name ";
				prosql += "from gms_device_app_colldetsub cms ";
				prosql += "left join (select device_detsubid,sum(mix_num) as mixednum from gms_device_coll_mixsub mixsub,gms_device_collmix_form collform ";
				prosql += "where collform.device_mixinfo_id=mixsub.device_mixinfo_id and collform.bsflag='0' ";
				prosql += "group by device_detsubid) temp on temp.device_detsubid=cms.device_detsubid ";
				prosql += "left join gms_device_app_colldetail cd on cms.device_app_detid = cd.device_app_detid ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id ";
				prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=cd.team ";
				prosql += "where  cd.device_app_id='<%=devappid%>' and cd.bsflag='0'";
				prosql += "order by cms.device_id ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			//回填附属设备信息
			var devsql = "select * from gms_device_coll_mixsubadd mix left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+retObj[0].device_app_detid+"'";
			var devqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devsql);
			devObj = devqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_detsubid+"' /></td>";
				innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' style='line-height:15px' value='"+retObj[index].team_name+"' size='8' type='text' readonly/>";
				innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"' size='12' type='text' readonly/>";
				innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"' size='12' type='text' readonly/></td>";
				innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='8' type='text' readonly/>";
				innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' type='hidden' /></td>";
				
				innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' style='line-height:15px' value='"+retObj[index].applynum+"' size='8' type='text' /></td>";
				innerhtml += "<td><input name='mixednum"+index+"' id='mixednum"+index+"' value='"+retObj[index].mixednum+"' size='8'  type='text' readonly/></td>";
				innerhtml += "<td><input name='totalnum"+index+"' id='totalnum"+index+"' value='' size='6' type='text' readonly/></td>";
				innerhtml += "<td><input name='unusenum"+index+"' id='unusenum"+index+"' value='' size='7' type='text' readonly/></td>";
				
				innerhtml += "<td><input name='mixnum"+index+"' id='mixnum"+index+"' value='' size='7' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
				
				innerhtml += "<td><input name='devremark"+index+"' id='devremark"+index+"' value='' size='10' type='text' /></td>";
				
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
		if(devObj!=undefined){
			for(var index=0;index<devObj.length;index++){
				var innerhtml = "<tr id='traddedseq"+index+"' name='traddedseq"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+index+"'/></td>";
				innerhtml += "<td width='12%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+devObj[index].coding_name+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
				innerhtml += "<input name='addedteam"+index+"' id='addedteam"+index+"' value='"+devObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicename"+index+"' id='addeddevicename"+index+"' idindex='"+index+"' value='"+devObj[index].device_name+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicetype"+index+"' id='addeddevicetype"+index+"' value='"+devObj[index].device_model+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedunit"+index+"' id='addedunit"+index+"' value='"+devObj[index].unit_name+"' style='line-height:18px;width:98%' size='8' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedassignnum"+index+"' id='addedassignnum"+index+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)' value='"+devObj[index].mix_num+"'/></td>";
				innerhtml += "<td width='10%'><input name='addedremark"+index+"' id='addedremark"+index+"' value='"+devObj[index].devremark+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "</tr>";
				$("#addeddetailtable").append(innerhtml);
				addedseqinfo++;
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixednum = parseInt($("#mixednum"+index).val(),10)
		var totalnumVal = parseInt($("#totalnum"+index).val(),10);
		var applynum = parseInt($("#applynum"+index).val(),10);
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("调配数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if($("#unusenum"+index).val() == ''){
				alert("没有对应台账信息或者闲置数量为空!");
				obj.value = "";
				return;
			}
			if(parseInt(objValue,10)>totalnumVal){
				alert("调配数量必须小于等于总数量!");
				obj.value = "";
				return false;
			}else if(parseInt(objValue,10)>applynum){
				alert("调配数量必须小于等于申请数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+mixednum)>applynum){
				alert("调配数量必须小于等于未调配数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

