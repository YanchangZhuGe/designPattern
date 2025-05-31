<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
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

  <title>多项目-设备维修-井中设备维修</title>
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text" /></td>
			    <td class="ali_cdn_name">送修单名称</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_name" name="s_appinfo_name" type="text" /></td>
			    <!-- <td class="ali_cdn_name">调配申请单号</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_no" name="s_appinfo_no" type="text" /></td> 
			    <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>-->
			    <td class="ali_cdn_name">处理状态</td>
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
			    <auth:ListButton functionId="" css="jh" event="onclick='toAddDetailPage()'" title="维修明细"></auth:ListButton>
			    <!--<auth:ListButton functionId="" css="xg" event="onclick='toModifyDetailPage()'" title="编辑"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>-->
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
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{device_backapp_id}' id='selectedbox_{device_backapp_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="<a onclick=viewProject('{project_info_id}')>{project_name}</a>">项目名称</td>
					<td class="bt_info_odd" exp="{project_name}" isShow='Hide' >项目名称</td>
					<td class="bt_info_odd" exp="{backapp_name}">送修单名称</td>
					<td class="bt_info_even" exp="{device_backapp_no}">送修单号</td>
					<td class="bt_info_odd" exp="{app_org_name}">送修单位名称</td>
					<td class="bt_info_even" exp="{appdate}">送修时间</td>
					<td class="bt_info_odd" exp="{opr_state_desc}">处理状态</td>
					<!-- <td class="bt_info_even" exp="<a onclick=viewMixedStore('{device_backapp_id}','{opr_state}')>查看</a>">送修单查看</td>
					<td class="bt_info_odd" exp="{mix_org_name}">调配单位</td>
					<td class="bt_info_even" exp="{mix_state_desc}">调配状态</td>
					<td class="bt_info_odd" exp="{backmixinfo_no}">调配单号</td>
					<td class="bt_info_even" exp="{out_org_name}">接收单位</td>
					<td class="bt_info_odd" exp="{employee_name}">调配人</td>
					<td class="bt_info_even" exp="{mix_date}">调配时间</td> -->
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
			    <!-- <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批信息</a></li> -->
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <!-- <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li> -->
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">项目名称</td>
				<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">送修单名称</td>
				<td class="inquire_form6"><input id="backapp_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">送修单号</td>
				<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">送修单位名称</td>
				<td class="inquire_form6"><input id="app_org_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">送修时间</td>
				<td class="inquire_form6"><input id="appdate" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">处理状态</td>
				<td class="inquire_form6"><input id="opr_state_desc" name="" class="input_width" type="text" /><input id="out_org_id" name="" class="input_width" type="hidden" /></td>
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
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					
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
		//动态查询明细
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value
			}
		});
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		if(index == 1){
			var own_org_id = $("#out_org_id").val();			
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取				
			}else{				
				if(currentid==undefined){
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo","");
				}else{
					if(currentid!=''){
						var prosql = "select ci.dev_ci_name,ci.dev_ci_model,ci.dev_ci_code,detail.device_backdet_id,detail.dev_acc_id,detail.dev_position,";
						prosql +="detail.dev_coding,detail.self_num,detail.dev_sign,detail.license_num,detail.actual_in_time,detail.planning_out_time ";
						prosql +="from gms_device_backapp_detail detail ";
						prosql +="join gms_device_account_dui dui on detail.dev_acc_id = dui.dev_acc_id ";
						prosql +="join gms_device_codeinfo ci on dui.dev_type = ci.dev_ci_code ";
						prosql +="where detail.device_backapp_id = '"+currentid+"' ";
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
		}else if(index == 3){
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td><td>"+datas[i].self_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
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
		if(mixstate!='9'){
			alert("本调配单状态不是'已调配'，不能打印!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			//调用打印方法
			var path = cruConfig.contextPath+"/rm/dm/common/DmDocToExcel.srq";
			var submitStr = "baseTableName=gms_device_backinfo_form&baseid="+info[0]+"&subTableName=gms_device_backapp_detail";
			var retObj = syncRequest("post", path, submitStr);
			var filename=retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
			var showname=retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
			window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
			//window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+retObj.showName;
		}else{
			alert("您尚未开据本申请单对应的调配单，请查看!");
			return;
		}
	}
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_appinfo_name = document.getElementById("s_appinfo_name").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_opr_state_desc, v_appinfo_name, v_project_name);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_opr_state_desc").value="";
    	document.getElementById("s_appinfo_name").value="";
		document.getElementById("s_project_name").value="";
    }
	
	function refreshData(v_opr_state_desc, v_appinfo_name, v_project_name){
		var str = "select devapp.project_info_id,tp.project_name,devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
			+"devapp.backapp_name,devapp.opr_state,case devapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as opr_state_desc "
			+"from gms_device_backapp devapp "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			//加机构权限
			+"left join comm_org_subjection orgsub on devapp.backmix_org_id=orgsub.org_id and orgsub.bsflag='0' "
			+"where devapp.state='9' and devapp.backapptype = '2' and devapp.bsflag='0' and devapp.backdevtype='<%=DevConstants.MIXTYPE_COMMON%>' ";
			//加机构权限
			str += "and orgsub.org_subjection_id like '<%=orgsubid%>%' ";

		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc == '1'){//处理中
				str += "and devapp.opr_state = '1' ";
			}else if(v_opr_state_desc == '9'){//已处理
				str += "and devapp.opr_state = '9' ";
			}else{//未处理
				str += "and ((devapp.opr_state != '1' and devapp.opr_state != '9') or devapp.opr_state is null) ";
			}					
		}
		if(v_appinfo_name!=undefined && v_appinfo_name!=''){
			str += "and devapp.backapp_name like '%"+v_appinfo_name+"%' ";
		}
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and tp.project_name like '%"+v_project_name+"%' ";
		}
		str += "order by devapp.opr_state nulls first,devapp.modifi_date desc,devapp.project_info_id ";
		
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
		window.location.href='<%=contextPath%>/rm/dm/devRepair/devWellsRepairDet.jsp?id='+shuaId;
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
			alert("本调配单已提交，不能修改!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/devbackmix2/backMixInfoFormModify.jsp?mixInfoId='+info[0]+'&devappid='+info[1],'1000:680');
		}else{
			alert("您尚未开据本调配单对应的出库单，请查看!");
			return;
		}
	}
	function dbclickRow(shuaId){
		window.location.href='<%=contextPath%>/rm/dm/devRepair/devWellsRepairDet.jsp?id='+shuaId;
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
			alert("您只能选择状态为'调配中'的记录删除!");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var idinfos = idinfo.replace(/[~]/g,"','");
			idinfos = "'"+idinfos+"'";
			var sql = "update gms_device_backinfo_form set bsflag='1' where device_mixinfo_id in ("+idinfos+")";
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
		//var info = ids.split("~",-1);
			//根据ids去查找 申请单
		var str = "select tp.project_name,devapp.backapp_name,devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
			+"case devapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as opr_state_desc from gms_device_backapp devapp "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
			+"where devapp.state='9' and devapp.device_backapp_id='"+ids+"'";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_backapp_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_backapp_id+"']").attr("checked",'true');
			//选中这一条checkbox
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_backapp_no);
			$("#backapp_name").val(retObj[0].backapp_name);
			$("#app_org_name").val(retObj[0].app_org_name);
			$("#appdate").val(retObj[0].appdate);
			$("#opr_state_desc").val(retObj[0].opr_state_desc);

		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    function viewProject(projectNo){
		if(projectNo != ''){
			popWindow('<%=contextPath%>/rm/dm/project/viewProject.jsp?projectInfoNo='+projectNo,'1080:680');						
		}		
	}
    function viewMixedStore(id,state){
		if(state !='1' && state !='9'){
			alert("该单据尚未调配,暂不能查看调配单信息!");
		}else{		
			if(id != ''){				
				popWindow('<%=contextPath%>/rm/dm/devbackmix2/backMixedInfoList.jsp?devBackAppId='+id,'1050:680');									
			}			
		}			
	}
</script>
</html>