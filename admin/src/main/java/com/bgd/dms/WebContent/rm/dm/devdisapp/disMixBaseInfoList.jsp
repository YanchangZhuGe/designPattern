<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoId = user.getProjectInfoNo();
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
  <title>自有设备调剂单列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">调剂计划单号</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_no" name="s_appinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">调剂申请单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDetailPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyDetailPage()'" title="编辑"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mixapp_id_{device_mixapp_id}' name='device_mixapp_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{device_mixapp_id}~{device_app_id}' id='selectedbox_{device_mixapp_id}~{device_app_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_no}">调剂计划单号</td>
					<td class="bt_info_even" exp="{device_app_name}">调剂计划单名称</td>
					<td class="bt_info_odd" exp="{mix_state_desc}">调剂状态</td>
					<td class="bt_info_even" exp="{device_mixapp_no}">调剂申请单号</td>
					<td class="bt_info_odd" exp="{device_mixapp_name}">申请单名称</td>
					<td class="bt_info_even" exp="{app_org_name}">调剂申请单位</td>
					<td class="bt_info_odd" exp="{mix_org_name}">调剂单位</td>
					<td class="bt_info_even" exp="{employee_name}">调剂申请人</td>
					<td class="bt_info_odd" exp="{mixappdate}">调剂申请时间</td>
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
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">项目名称</td>
				<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调剂计划单号</td>
				<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调剂计划单名称</td>
				<td class="inquire_form6"><input id="device_app_name" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">调剂状态</td>
				<td class="inquire_form6"><input id="mix_state_desc" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调剂申请单号</td>
				<td class="inquire_form6"><input id="device_mixapp_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调剂申请单位</td>
				<td class="inquire_form6"><input id="app_org_name" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">调剂单位</td>
				<td class="inquire_form6"><input id="mix_org_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调剂申请人</td>
				<td class="inquire_form6"><input id="employee_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调剂申请时间</td>
				<td class="inquire_form6"><input id="mixappdate" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">申请数量</td>
							<td class="bt_info_odd" width="13%">计划进场时间</td>
							<td class="bt_info_even" width="10%">计划离场时间</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					
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
				if(currentid==undefined){
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo","");
				}else{
					var info = currentid.split("~" , -1);
					if(info[0]!=''){
						//先进行查询
						var prosql = "select amd.apply_num,amd.plan_start_date,amd.plan_end_date,";
						prosql += "case when amd.isdevicecode='N' then ci.dev_ci_name else ct.dev_ct_name end as dev_ci_name,";
						prosql += "case when amd.isdevicecode='N' then ci.dev_ci_model else '' end as dev_ci_model  ";
						prosql += "from gms_device_dismixapp_detail amd ";
						
						prosql += "left join gms_device_dismixapp amm on amm.device_mixapp_id=amd.device_mixapp_id ";
						prosql += "left join gms_device_codeinfo ci on amd.dev_ci_code=ci.dev_ci_code ";
						prosql += "left join gms_device_codetype ct on amd.dev_ci_code = ct.dev_ct_code ";
						prosql += "where amm.device_mixapp_id='"+info[0]+"'";
						var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
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
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
			innerHTML += "<td>"+datas[i].apply_num+"</td><td>"+datas[i].plan_start_date+"</td>";
			innerHTML += "<td>"+datas[i].plan_end_date+"</td>";
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

	function searchDevData(){
		var v_appinfo_no = document.getElementById("s_appinfo_no").value;
		var v_mixapp_no = document.getElementById("s_mixinfo_no").value;
		refreshData(v_appinfo_no, v_mixapp_no);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_appinfo_no").value="";
		document.getElementById("s_mixinfo_no").value="";
    }
	
	function refreshData(v_appinfo_no,v_mixapp_no){
		var str = "select devplan.device_app_id,devplan.device_app_no,devplan.device_app_name,to_char(devplan.appdate,'yyyy-mm-dd') as planappdate,"
		+"mif.device_mixapp_id,mif.device_mixapp_no,mif.device_mixapp_name,tp.project_name,apporg.org_abbreviation as app_org_name,"
		+"mixorg.org_abbreviation as mix_org_name,he.employee_name,to_char(mif.appdate,'yyyy-mm-dd') as mixappdate,"
		+"case mif.state when '0' then '未提交' when '9' then '已提交' else '待申请' end as mix_state_desc,mif.state "
		+"from gms_device_disapp devplan "
		+"left join common_busi_wf_middle wfmiddle on devplan.device_app_id=wfmiddle.business_id and wfmiddle.bsflag='0' "
		+"left join gp_task_project tp on devplan.project_info_no=tp.project_info_no " 
		+"left join gms_device_dismixapp mif on mif.device_app_id=devplan.device_app_id and mif.bsflag='0' " 
		+"left join comm_human_employee he on mif.employee_id=he.employee_id "
		+"left join comm_org_information apporg on mif.app_org_id=apporg.org_id "
		+"left join comm_org_information mixorg on mif.mix_org_id=mixorg.org_id "
		
		+"where wfmiddle.proc_status='3' and devplan.mix_type_id='<%=DevConstants.MIXTYPE_COMMON%>' and (mif.bsflag is null or mif.bsflag='0')and devplan.project_info_no='<%=projectInfoId%>' ";
		if(v_appinfo_no!=undefined && v_appinfo_no!=''){
			str += "and devplan.device_app_no like '%"+v_appinfo_no+"%' ";
		}
		if(v_mixapp_no!=undefined && v_mixapp_no!=''){
			str += "and mif.device_mixapp_no like '%"+v_mixapp_no+"%' ";
		}
		str += "order by mif.appdate desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function toAddDetailPage(){
		var shuaId ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[1]!=''){
			popWindow('<%=contextPath%>/rm/dm/devdisapp/disMixappFormNew.jsp?devappid='+info[1],'950:680');
		}
	}
	function toModifyDetailPage(){
		var shuaId ;
		var mixstate ;
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
		if(mixstate=='9'){
			alert("本调剂单已提交，不能修改!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/devdisapp/disMixappFormModify.jsp?disMixId='+info[0]+'&devappid='+info[1],'950:680');
		}else{
			alert("您尚未开据本调剂单对应的出库单，请查看!");
			return;
		}
	}
	function dbclickRow(shuaId){
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			var mixstate ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					mixstate = this.mixstate;
				}
			});
			if(mixstate=='9'){
				alert("本调配单已提交，不能修改!");
				return;
			}
			popWindow('<%=contextPath%>/rm/dm/devdisapp/disMixappFormModify.jsp?disMixId='+info[0]+'&devappid='+info[1],'950:680');
		}else{
			popWindow('<%=contextPath%>/rm/dm/devdisapp/disMixappFormNew.jsp?devappid='+info[1],'950:680');
		}
	}
	function toDelRecord(){
		//判断状态如果是已提交，那么不能删除,或者没建新纪录，不能删除
		var length = 0;
		var idinfo;
		var delflag = false;
		var addflag = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				var curvalue = this.value;
				var mixstate = this.mixstate;
				var curvalues = curvalue.split("~",-1);
				if(mixstate==''||mixstate=='9'){
					delflag = true;
				}else{
					if(addflag==0){
						idinfo = curvalues[0];
					}else{
						idinfo += "~"+curvalues[0];
					}
					addflag ++;
				}
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择删除的记录！");
			return;
		}
		if(delflag){
			alert("您只能选择状态为'未提交'的记录删除!");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var idinfos = idinfo.replace(/[~]/g,"','");
			idinfos = "'"+idinfos+"'";
			alert(idinfos)
			var sql = "update gms_device_dismixapp set bsflag='1' where device_mixapp_id in ("+idinfos+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
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
		var info = ids.split("~",-1);
		
		if(info[0]!=''){
			//根据ids去查找
			
			var str = "select devplan.device_app_id,devplan.device_app_no,devplan.device_app_name,to_char(devplan.appdate,'yyyy-mm-dd') as planappdate,"
			+"mif.device_mixapp_id,mif.device_mixapp_no,tp.project_name,apporg.org_abbreviation as app_org_name,"
			+"mixorg.org_abbreviation as mix_org_name,he.employee_name,to_char(mif.appdate,'yyyy-mm-dd') as mixappdate,"
			+"case mif.state when '0' then '未提交' when '9' then '已提交' else '待申请' end as mix_state_desc,mif.state "
			+"from gms_device_disapp devplan "
			+"left join common_busi_wf_middle wfmiddle on devplan.device_app_id=wfmiddle.business_id "
			+"left join gp_task_project tp on devplan.project_info_no=tp.project_info_no " 
			+"left join gms_device_dismixapp mif on mif.device_app_id=devplan.device_app_id " 
			+"left join comm_human_employee he on mif.employee_id=he.employee_id "
			+"left join comm_org_information apporg on mif.app_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on mif.mix_org_id=mixorg.org_id "
			+"where wfmiddle.proc_status='3' and mif.device_mixapp_id='"+info[0]+"'";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消选中框--------------------------------------------------------------------------
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_mixapp_id+"~"+retObj[0].device_app_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_mixapp_id+"~"+retObj[0].device_app_id+"']").attr("checked",'true');
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_app_no);
			$("#device_app_name").val(retObj[0].device_app_name);
			$("#mix_state_desc").val(retObj[0].mix_state_desc);
			$("#device_mixapp_no").val(retObj[0].device_mixapp_no);
			$("#app_org_name").val(retObj[0].app_org_name);
			$("#mix_org_name").val(retObj[0].mix_org_name);
			$("#employee_name").val(retObj[0].employee_name);
			$("#mixappdate").val(retObj[0].mixappdate);
		}else{
			//根据ids去查找 申请单
			var str = "select devplan.device_app_id,devplan.device_app_no,devplan.device_app_name,"
			+"to_char(devplan.appdate,'yyyy-mm-dd') as planappdate,tp.project_name,"
			+"case mif.state when '0' then '未提交' when '9' then '已提交' else '待申请' end as mix_state_desc "
			+"from gms_device_disapp devplan "
			+"left join common_busi_wf_middle wfmiddle on devplan.device_app_id=wfmiddle.business_id "
			+"left join gms_device_dismixapp mif on mif.device_app_id=devplan.device_app_id " 
			+"left join gp_task_project tp on devplan.project_info_no=tp.project_info_no " 
			+"where wfmiddle.proc_status='3' and devplan.device_app_id='"+info[1]+"'";
			
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_~"+retObj[0].device_app_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_~"+retObj[0].device_app_id+"']").attr("checked",'true');
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_app_no);
			$("#device_app_name").val(retObj[0].device_app_name);
			$("#mix_state_desc").val(retObj[0].mix_state_desc);
			$("#device_mixapp_no").val("");
			$("#app_org_name").val("");
			$("#mix_org_name").val("");
			$("#employee_name").val("");
			$("#mixappdate").val("");
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>