<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>单项目-设备返还-设备返还(仪器附属)</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">返还申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_backapp_no" name="s_device_backapp_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">返还单名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_backapp_name" name="s_backapp_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddBackPlanPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyBackPlanPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelMixPlanPage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitDevApp()'" title="提交"></auth:ListButton>
			    <%-- <auth:ListButton functionId="" css="jl" event="onclick='toModifyDetail()'" title="编辑明细"></auth:ListButton> --%>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_backapp_id}' name='device_backapp_id'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' id='selectedbox_{device_backapp_id}' name='selectedbox' value='{device_backapp_id}' stateinfo='{state}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{device_backapp_no}">返还申请单号</td>
					<td class="bt_info_even" exp="{backapp_name}">返还申请单名称</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{backdevtypedesc}">返还设备类别</td>
					<td class="bt_info_odd" exp="{back_org_name}">返还单位</td>
					<td class="bt_info_even" exp="{back_employee_name}">申请人</td>
					<td class="bt_info_odd" exp="{backdate}">申请时间</td>
					<td class="bt_info_even" exp="{state_desc}">状态</td>
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">项目名称：</td>
				      <td   class="inquire_form6" ><input id="project_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单号：</td>
				      <td  class="inquire_form6" ><input id="device_backapp_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单名称</td>
				      <td  class="inquire_form6"><input id="backapp_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>  
				     </tr>
				    <tr>
				     <td  class="inquire_item6">返还设备类别：</td>
				     <td  class="inquire_form6"><input id="backdevtype" class="input_width" type="text"  value="" disabled/>&nbsp;</td> 
				     <td  class="inquire_item6">设备转出单位：</td>
				     <td  class="inquire_form6"><input id="out_org_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td> 
				     <td  class="inquire_item6">返还单位：</td>
				     <td  class="inquire_form6"><input id="back_org_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">申请人：</td>
				     <td  class="inquire_form6"><input id="back_employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="backdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">状态：</td>
				     <td  class="inquire_form6"><input id="state" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
				        	<td class="bt_info_odd" width="15%">设备编号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">自编号</td>
							<td class="bt_info_odd" width="11%">实物标识号牌照号</td>
							<td class="bt_info_even" width="9%">牌照号</td>
							<td class="bt_info_odd" width="13%">计划离场时间</td>
							<td class="bt_info_even" width="13%">实际离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
			</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
			</div>
		 </div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		if(index == 1){
			//动态查询明细
			var currentid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select backdet.device_backdet_id,backdet.device_backapp_id,backdet.dev_acc_id, ";
				str += "backdet.dev_coding,backdet.self_num,backdet.dev_sign, ";
				str += "backdet.license_num,backdet.actual_in_time,backdet.planning_out_time, ";
				str += "account.dev_name,account.dev_model ";
				str += "from gms_device_backapp_detail backdet ";
				str += "left join gms_device_account_dui account on backdet.dev_acc_id = account.dev_acc_id ";
				str += "where backdet.device_backapp_id='"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_coding+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].self_num+"</td><td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].planning_out_time+"</td><td>"+datas[i].actual_in_time+"</td>";
			innerHTML += "</tr>";
			
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	
    function refreshData(v_device_backapp_no, v_backapp_name){
		var str = "select pro.project_name,backapp.device_backapp_id,backapp.backapp_name,";
			str += "backapp.device_backapp_no,backapp.project_info_id,backapp.back_org_id,";
			str += "backapp.back_employee_id,backapp.backdate,backapp.create_date,backapp.modifi_date,";
			str += "case backapp.backdevtype when 'S14059999' then '仪器附属' when 'S1405' then '仪器附属' else '未知类型' end as backdevtypedesc,";
			str += "backapp.state,case backapp.state when '0' then '未提交' when '9' then '已提交' else '未知状态' end as state_desc,";
			str += "org.org_abbreviation as back_org_name,emp.employee_name as back_employee_name,outorg.org_abbreviation as out_org_name  ";
			str += "from gms_device_backapp backapp ";
			str += "left join comm_org_information org on backapp.back_org_id = org.org_id ";
			str += "left join comm_org_information outorg on backapp.backmix_org_id = outorg.org_id  ";
			str += "left join comm_human_employee emp on backapp.back_employee_id = emp.employee_id ";
			str += "left join gp_task_project pro on backapp.project_info_id = pro.project_info_no ";
			str += "where backapp.bsflag = '0' and backapp.project_info_id = '"+projectInfoNos+"' and backapp.backdevtype = 'S14059999' ";
		if(v_device_backapp_no!=undefined && v_device_backapp_no!=''){
			str += "and backapp.device_backapp_no like '%"+v_device_backapp_no+"%' ";
		}
		if(v_backapp_name!=undefined && v_backapp_name!=''){
			str += "and backapp.backapp_name like '%"+v_backapp_name+"%' ";
		}
		str += "order by backapp.state nulls first,backapp.backdate desc  ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function initCheckbox(){
		$("input[type='checkbox'][name='selectedbox'][stateinfo='9']").each(function(i){
			this.disabled = true;
		});
	}

	function searchDevData(){
		var v_device_backapp_no = document.getElementById("s_device_backapp_no").value;
		var v_backapp_name = document.getElementById("s_backapp_name").value;
		refreshData(v_device_backapp_no, v_backapp_name);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_device_backapp_no").value="";
		document.getElementById("s_backapp_name").value="";
    }
	
	function loadDataDetail(devicebackappid){
    	var retObj;
		if(devicebackappid!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevBackPlanInfo", "devicebackappid="+devicebackappid);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevBackPlanInfo", "devicebackappid="+ids);
		}
		
		//取消其他选中的 
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceBackappMap.device_backapp_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj.deviceBackappMap.device_backapp_id+"']").attr("checked",'checked');
		//给数据回填
		$("#project_name","#projectMap").val(retObj.deviceBackappMap.project_name);
		$("#device_backapp_no","#projectMap").val(retObj.deviceBackappMap.device_backapp_no);
		$("#backapp_name","#projectMap").val(retObj.deviceBackappMap.backapp_name);
		$("#backdevtype","#projectMap").val(retObj.deviceBackappMap.backdevtypedesc);
		$("#out_org_name","#projectMap").val(retObj.deviceBackappMap.out_org_name);
		
		$("#back_org_name","#projectMap").val(retObj.deviceBackappMap.back_org_name);
		$("#back_employee_name","#projectMap").val(retObj.deviceBackappMap.back_employee_name);
		$("#backdate","#projectMap").val(retObj.deviceBackappMap.backdate);
		$("#state","#projectMap").val(retObj.deviceBackappMap.state_desc);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	
	function toAddBackPlanPage(){
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/insbackdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>','950:680');
	}
	function toModifyBackPlanPage(){
		var devicebackappid ;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				devicebackappid = this.value;
				
			}
		});
		selectedid =  "'"+devicebackappid+"'";
		if(devicebackappid==undefined){
			alert("请选择需要修改的返还单记录!");
			return;
		}
		//判断状态
		var querySql = "select devapp.device_backapp_id,devapp.state as proc_status ";
		querySql += "from gms_device_backapp devapp where devapp.bsflag='0' and devapp.device_backapp_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].proc_status == '9' ){
				stateflag = true;
				alertinfo = "您选择的单据状态为'已提交',不能修改!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/insbackdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid='+devicebackappid,'950:680');
	}
	function toDelMixPlanPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态
		var querySql = "select devapp.device_backapp_id,devapp.state as proc_status ";
		querySql += "from gms_device_backapp devapp where devapp.bsflag='0' and devapp.device_backapp_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var stateflag = false;
		var alertinfo ;
		if(basedatas[0].proc_status == '9' ){
			stateflag = true;
			alertinfo = "您选择的记录已提交,不能删除!";
			alert(alertinfo);
			return;
		}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_backapp set bsflag='1' where device_backapp_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	function toSumbitDevApp(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//如果没有加明细，就不能提交
		var recquerySql = "select count(1) as reccount ";
		recquerySql += "from gms_device_backapp_detail bad where bad.device_backapp_id in ("+selectedid+")";
		var recqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+recquerySql);
		var recbasedatas = recqueryRet.datas;
		var recstateflag = false;
		var reccount;
		if(!recbasedatas || recbasedatas.length>0){
			if(parseInt(recbasedatas[0].reccount)==0){
				recstateflag = true;
				reccount = recbasedatas[0].reccount;
			}
		}
		if(recstateflag){
			alert("您选择的记录中没有添加明细记录!");
			return;
		}
		//判断状态
		var querySql = "select devapp.device_backapp_id,devapp.state as proc_status ";
		querySql += "from gms_device_backapp devapp where devapp.bsflag='0' and devapp.device_backapp_id in ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].proc_status == '9' ){
				stateflag = true;
				alertinfo = "您选择的单据状态为'已提交',不能重复提交!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		var sql = "update gms_device_backapp set state='9' where device_backapp_id in ("+selectedid+")";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		//给申请时添加的实际离场时间，更新到队级台账中
		var detsql = "update gms_device_account_dui dui set actual_out_time=(select actual_in_time from gms_device_backapp_detail t where device_backapp_id in ("+selectedid+") and t.dev_acc_id=dui.dev_acc_id) ";
		detsql += "where exists(select 1 from gms_device_backapp_detail det where det.dev_acc_id=dui.dev_acc_id and det.device_backapp_id in ("+selectedid+"))";
		var params = "deleteSql="+detsql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		refreshData();
		//popWindow('<%=contextPath%>/rm/dm/devback/backplan_submit.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid='+selectedid);
	}
	
	function toModifyDetail(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
		if(id==undefined){
			alert("请选择需要修改的返还单记录!");
			return;
		}
		//判断状态
		var querySql = "select devapp.device_backapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
		querySql += "from gms_device_backapp devapp left join common_busi_wf_middle wfmiddle on devapp.device_backapp_id=wfmiddle.business_id ";
		querySql += "where devapp.bsflag='0' and devapp.device_backapp_id ='"+id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var stateflag = false;
		var alertinfo ;
		if(basedatas !=undefined && basedatas.length>=1){
			if(basedatas[0].proc_status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'待审批'的单据!";
			}else if(basedatas[0].state == '3' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'审批通过'的单据!";
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		window.location.href = '<%=contextPath%>/rm/dm/devback/backPlanDetailList.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid='+id;
	}
	
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
</script>
</html>