<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String subid = user.getOrgSubjectionId();
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String orgType="";
	if(orgsubid.startsWith("C105008")){
		orgType="Y";
	}else{
		orgType="N";
	}	
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>自有设备调配单列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text" /></td>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_name" name="s_appinfo_name" type="text" /></td>
			    <td class="ali_cdn_name">调配申请单号</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_no" name="s_appinfo_no" type="text" /></td>
			    <!-- <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td> -->
			    <td class="ali_cdn_name">申请处理状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_opr_state_desc" name="s_opr_state_desc" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">未处理</option>
						<option value="1">处理中</option>
						<option value="9">已处理</option>
			    	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jd" event="onclick='exportDataDoc()'" title="查询申请明细"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{device_app_id}' id='selectedbox_{device_app_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_name}">调配申请单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{app_org_name}">申请单位名称</td>
					<td class="bt_info_even" exp="{appdate}">申请时间</td>
					<td class="bt_info_odd" exp="{opr_state_desc}">申请处理状态</td>
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
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">单据调配状态</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">审批信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">备注</a></li>
			    <li id="tag3_6"><a href="#" onclick="getContentTab(this,6)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						<td class="inquire_item6">项目名称</td>
						<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配申请单号</td>
						<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">申请时间</td>
						<td class="inquire_form6"><input id="appdate" name="" class="input_width" type="text" /></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">设备编号</td>
							<td class="bt_info_odd" width="13%">自编号</td>
							<td class="bt_info_even" width="10%">实物标识号</td>
							<td class="bt_info_odd" width="13%">牌照号</td>
							<td class="bt_info_even" width="10%">所属单位</td>
							<td class="bt_info_odd" width="10%">操作手</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd">序号</td>
							<td class="bt_info_even">分中心名称</td>
							<td class="bt_info_odd">调配状态</td>
				        </tr>
				        <tbody id="tpList" name="tpList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					
				</div>
			    <div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none">
					
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
			var currentid;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}			
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				if(currentid==undefined){
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo","");
				}else{
					var info = currentid.split("~" , -1);
					if(info[0]!=''){
						//先进行查询
						var prosql = "select e.employee_name,ci.dev_ci_name,ci.dev_ci_model, ";
						prosql += "amd.asset_coding,amd.self_num,amd.dev_sign,amd.license_num,org.org_abbreviation ";
						prosql += "from gms_device_appmix_detail amd ";
						prosql += "left join gms_device_appmix_main amm on amm.device_mix_subid=amd.device_mix_subid ";
						prosql += "left join gms_device_app_detail det on amm.device_app_detid=det.device_app_detid "
						prosql += "left join gms_device_codeinfo ci on amd.dev_ci_code=ci.dev_ci_code ";
						prosql += "left join gms_device_account account on account.dev_acc_id=amd.dev_acc_id  ";
						prosql += "left join comm_org_information org on account.owning_org_id=org.org_id ";
						prosql += "left join comm_human_employee e on amd.operator_id=e.employee_id ";
						prosql += "where det.device_app_id='"+info[0]+"'";
						var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
						basedatas = queryRet.datas;
						if(basedatas!=undefined && basedatas.length>=1){
							//先清空
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							appendDataToDetailTab(filtermapid,basedatas);
							//设置当前标签页显示的主键
							$(filterobj).attr("idinfo",currentid);
						}else{
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							$(filterobj).attr("idinfo",currentid);
						}
					}else{
						var filtermapid = "#detailList";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",currentid);
					}
				}
			}
		}
		else if(index == 2){
				//动态查询明细
				var currentid;
				$("input[type='checkbox'][name='selectedbox']").each(function(){
					if(this.checked){
						currentid = this.value;
					}			
				});
				var idinfo = $(filterobj).attr("idinfo");
				if(currentid != undefined && idinfo == currentid){
					//已经有值，且完成钻取，那么不再钻取
				}else{
					if(currentid==undefined){
						var filtermapid = "#tpList";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo","");
					}else{
						var info = currentid.split("~" , -1);
							//先进行查询
							var devAppId = "";
								devAppId = currentid;
							var prosql = "select info.org_abbreviation,case when al.mix_total=0 then '未处理' when al.app_total > al.mix_total then '处理中' when al.app_total = al.mix_total then '已处理' end as state from (select appdet.dev_out_org_id,nvl(sum(appdet.apply_num),0) as app_total,nvl(sum(tmp.mixed_num),0) as mix_total  from gms_device_app_detail appdet  left join (select device_app_detid, sum(assign_num) as mixed_num from gms_device_appmix_main amm  where amm.bsflag = '0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid where appdet.device_app_id='"+devAppId+"' group by appdet.dev_out_org_id) al left join comm_org_information info on al.dev_out_org_id = info.org_id";
							var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
							basedatas = queryRet.datas;
							if(basedatas!=undefined && basedatas.length>=1){
								//先清空
								var filtermapid = "#tpList";
								$(filtermapid).empty();
								appendDataToDetailTab(filtermapid,basedatas);
								//设置当前标签页显示的主键
								$(filterobj).attr("idinfo",currentid);
							}else{
								var filtermapid = "#tpList";
								$(filtermapid).empty();
								$(filterobj).attr("idinfo",currentid);
							}
					}
				}
			}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		if(basedatas[0].dev_ci_name != null){
			for(var i=0;i<basedatas.length;i++){
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
				innerHTML += "<td>"+datas[i].asset_coding+"</td><td>"+datas[i].self_num+"</td>";
				innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td><td>"+datas[i].org_abbreviation+"</td>";
				innerHTML += "<td>"+datas[i].employee_name+"</td></tr>";
				
				$(filterobj).append(innerHTML);
			}
		}
		else{
			for(var i=0;i<basedatas.length;i++){
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].org_abbreviation+"</td><td>"+datas[i].state+"</td>";
				innerHTML += "</tr>";
				
				$(filterobj).append(innerHTML);
			}
			}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	function exportDataDoc(){
		//获得当前行的状态，如果不是已提交，那么不能打印
		var shuaId;
		var mixstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
				mixstate = this.mixstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devmixForm/devAppInfoList.jsp?devAppId='+shuaId,'1050:680');
	}

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	var orgType = "<%=orgType%>";
	
	function searchDevData(){
		var v_appinfo_no = document.getElementById("s_appinfo_no").value;
		//var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_appinfo_name = document.getElementById("s_appinfo_name").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_appinfo_no, v_opr_state_desc, v_appinfo_name, v_project_name);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_appinfo_no").value="";
    	document.getElementById("s_appinfo_name").value="";
		//document.getElementById("s_mixinfo_no").value="";
		document.getElementById("s_opr_state_desc").value="";
		document.getElementById("s_project_name").value="";
    }
	//var orgType = "<%=orgType%>";
	//function refreshData(v_appinfo_no,v_mixinfo_no, v_appinfo_name, v_project_name){
	function refreshData(v_appinfo_no,v_opr_state_desc, v_appinfo_name, v_project_name){
		var str="";
		if(orgType=="Y"){
			str += "select distinct devapp.device_app_name,devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
				+"tp.project_name,devapp.project_info_no,devapp.opr_state,"
				+"case devapp.opr_state when '1' then '处理中' when '9' then'已处理' else '未处理' end as opr_state_desc "
				+"from gms_device_app devapp left join gms_device_app_detail det on devapp.device_app_id=det.device_app_id left join comm_org_subjection detsub on det.dev_out_org_id=detsub.org_id "
				//+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
				+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
				+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
				+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
				//加机构权限
				+"left join comm_org_subjection orgsub on devapp.mix_org_id=orgsub.org_id and orgsub.bsflag='0' "
				+"where devapp.bsflag='0' and devapp.mix_type_id='<%=DevConstants.MIXTYPE_COMMON%>' ";
				//加机构权限
				str += "and detsub.org_subjection_id like '<%=orgsubid%>%' ";
				if(v_appinfo_no!=undefined && v_appinfo_no!=''){
					str += "and devapp.device_app_no like '%"+v_appinfo_no+"%' ";
				}
				if(v_appinfo_name!=undefined && v_appinfo_name!=''){
					str += "and devapp.device_app_name like '%"+v_appinfo_name+"%' ";
				}
				//if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
				//	str += "and mif.mixinfo_no like '%"+v_mixinfo_no+"%' ";
				//}
				if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
					if(v_opr_state_desc == '0')
					{
						str += "and ((devapp.opr_state <> '1' and devapp.opr_state <> '9') or devapp.opr_state is null) ";
					}else{
						str += "and devapp.opr_state like '%"+v_opr_state_desc+"%' ";
					}					
				}
				if(v_project_name!=undefined && v_project_name!=''){
					str += "and tp.project_name like '%"+v_project_name+"%' ";
				}
				str += "order by devapp.opr_state nulls first,appdate desc,devapp.project_info_no ";
			}else{
				str += "select devapp.device_app_name,devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
				+"mif.device_mixinfo_id,mif.mixinfo_no,tp.project_name,mixorg.org_abbreviation as mix_org_name,"
				+"outorg.org_abbreviation as out_org_name,he.employee_name,to_char(mif.modifi_date,'yyyy-mm-dd') as mix_date,"
				+"case devapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as opr_state_desc, "
				+"case mif.state when '0' then '调配中' when '9' then '已调配' else '待调配' end as mix_state_desc,mif.state "
				+"from gms_device_app devapp "
				+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
				+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
				+"left join gms_device_mixinfo_form mif on mif.device_app_id=devapp.device_app_id " 
				+"left join comm_human_employee he on mif.print_emp_id=he.employee_id "
				+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
				+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
				+"left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on mif.out_org_id = sub.org_subjection_id "
				//加机构权限
				+"left join comm_org_subjection orgsub on devapp.mix_org_id=orgsub.org_id and orgsub.bsflag='0' "
				+"where wfmiddle.proc_status='3' and devapp.bsflag='0' and devapp.mix_type_id='<%=DevConstants.MIXTYPE_COMMON%>' and (mif.bsflag is null or mif.bsflag='0') ";
				//加机构权限
				str += "and orgsub.org_subjection_id like '<%=orgsubid%>%' ";
				if(v_appinfo_no!=undefined && v_appinfo_no!=''){
					str += "and devapp.device_app_no like '%"+v_appinfo_no+"%' ";
				}
				if(v_appinfo_name!=undefined && v_appinfo_name!=''){
					str += "and devapp.device_app_name like '%"+v_appinfo_name+"%' ";
				}
				//if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
				//	str += "and mif.mixinfo_no like '%"+v_mixinfo_no+"%' ";
				//}
				if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
					if(v_opr_state_desc == '0')
					{
						str += "and ((devapp.opr_state <> '1' and devapp.opr_state <> '9') or devapp.opr_state is null) ";
					}else{
						str += "and devapp.opr_state like '%"+v_opr_state_desc+"%' ";
					}					
				}
				if(v_project_name!=undefined && v_project_name!=''){
					str += "and tp.project_name like '%"+v_project_name+"%' ";
				}
				str += "order by mif.state nulls first,mif.modifi_date desc,devapp.modifi_date desc,devapp.project_info_no ";
			}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function dbclickRow(shuaId){
			popWindow('<%=contextPath%>/rm/dm/devmixForm/devAppInfoList.jsp?devAppId='+shuaId,'1050:680');
	}
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }
    }   
    function loadDataDetail(shuaId){
    	var retObj;
    	var ids;
		if(shuaId!=null){
			ids = shuaId;
		}else{
			ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}
			var str = "select distinct * from(select devapp.device_app_name,devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
				+"tp.project_name,"
				+"case devapp.opr_state when '1' then '处理中' when '9' then'已处理' else '未处理' end as opr_state_desc "
				+"from gms_device_app devapp left join gms_device_app_detail det on devapp.device_app_id=det.device_app_id left join comm_org_subjection detsub on det.dev_out_org_id=detsub.org_id "
				+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
				+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
				+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
				+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
				//加机构权限
				+"left join comm_org_subjection orgsub on devapp.mix_org_id=orgsub.org_id and orgsub.bsflag='0' "
				+"where devapp.device_app_id='"+shuaId+"') ";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消选中框--------------------------------------------------------------------------
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_app_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_app_id+"']").attr("checked",'true');
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_app_no);
			$("#appdate").val(retObj[0].appdate);
    	getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>