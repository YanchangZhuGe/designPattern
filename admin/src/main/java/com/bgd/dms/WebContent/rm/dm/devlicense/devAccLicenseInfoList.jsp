<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String licensetype = request.getParameter("licensetype")==null?"1":request.getParameter("licensetype");
	String types = request.getParameter("types")==null?"":request.getParameter("types");

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String usersubid = user.getOrgSubjectionId();
	if(usersubid.startsWith("C105007")){
		usersubid="C105007";
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
  <title>设备证照(行驶证)列表</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">有效天数</td>
			    <td class="ali_cdn_input">
			    <select class="input_width"   name="s_validdayinfo" id="s_validdayinfo">
					<option value="" selected="selected">--请选择--</option>
					<option value="30">1个月内</option>
					<option value="60">2个月内</option>
					<option value="90">3个月内</option>
			    </select></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyDetailPage()'" title="编辑"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmitRecord()'" title="提交"></auth:ListButton>
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
			     <tr >
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox'  value='{dev_acc_id}' id='selectedbox_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{asset_coding}">设备编号</td>
					<td class="bt_info_even" exp="{owning_org_name}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name}">所在单位</td>
					<td class="bt_info_even" exp="{usestat_name}">使用情况</td>
					<td class="bt_info_odd" exp="{dev_reg_date}">注册登记日期</td>
					<td class="bt_info_even" exp="{cycle_name}">审检周期</td>
					<td class="bt_info_odd" exp="{last_audit_date}">末次审检时间</td>
					<td class="bt_info_even" exp="{validate_end}">有效期限</td>
					<td class="bt_info_odd" exp="{validdayinfo}">有效天数</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">审检历史</a></li>
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
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_name" name="dev_name" class="input_width" type="text" /></td>
				<td class="inquire_item6">设备型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" /></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="license_num" name="license_num" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">设备编号</td>
				<td class="inquire_form6"><input id="asset_coding" name="asset_coding" class="input_width" type="text" /></td>
				<td class="inquire_item6">所属单位</td>
				<td class="inquire_form6"><input id="owning_org_name" name="owning_org_name" class="input_width" type="text" /></td>
				<td class="inquire_item6">所在单位</td>
				<td class="inquire_form6"><input id="usage_org_name" name="usage_org_name" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">使用情况</td>
				<td class="inquire_form6"><input id="usestat_name" name="usestat_name" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划时间1</td>
				<td class="inquire_form6"><input id="plan_audit_date_1" name="plan_audit_date_1" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划时间2</td>
				<td class="inquire_form6"><input id="plan_audit_date_2" name="plan_audit_date_2" class="input_width" type="text" /></td>
			
			  </tr>
			  <tr>
				<td class="inquire_item6">计划时间3</td>
				<td class="inquire_form6"><input id="plan_audit_date_3" name="plan_audit_date_3" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划时间4</td>
				<td class="inquire_form6"><input id="plan_audit_date_4" name="plan_audit_date_4" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_even" width="11%">规格型号</td>
							<td class="bt_info_even" width="11%">牌照号</td>
							<td class="bt_info_odd" width="11%">审检时间</td>
							<td class="bt_info_even" width="10%">有效期限</td>
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
				if(currentid==undefined){
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo","");
				}else{
					var info = currentid.split("~" , -1);
					if(info[0]!=''){
						//先进行查询
						var prosql = "select ci.dev_ci_name,ci.dev_ci_model,";
						prosql += "amd.asset_coding,amd.self_num,amd.dev_sign,amd.license_num ";
						prosql += "from gms_device_appmix_detail amd ";
						prosql += "left join gms_device_appmix_main amm on amm.device_mix_subid=amd.device_mix_subid ";
						prosql += "left join gms_device_codeinfo ci on amd.dev_ci_code=ci.dev_ci_code ";
						prosql += "where amm.device_mixinfo_id='"+info[0]+"'";
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
			innerHTML += "<td>"+datas[i].asset_coding+"</td><td>"+datas[i].self_num+"</td>";
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_validdayinfo = document.getElementById("s_validdayinfo").value;
		refreshData(v_dev_name, v_dev_model, v_validdayinfo);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_validdayinfo").value="";
    }
	var types='<%=types%>';
	function refreshData(v_dev_name,v_dev_model,v_validdayinfo){
		var str = "select * from(select dev.dev_type,dev.dev_acc_id, dev.dev_name,dev.dev_model,dev.license_num,dev.owning_org_id,owning.org_abbreviation as owning_org_name,";
		str += "dev.asset_coding,dev.usage_org_id,usage.org_abbreviation as usage_org_name,dev.using_stat,usestat.coding_name as usestat_name,";
		str += "lic.dev_license_id,lic.dev_reg_date,lic.dev_audie_cycle,cycle.coding_name as cycle_name,lic.last_audit_date,lic.validate_end,";
		str += "case when round(to_number(lic.validate_end-trunc(sysdate)))<0 then 0 ";
		str += "else round(to_number(lic.validate_end-trunc(sysdate))) end as validdayinfo ";
		str += "from gms_device_account dev ";
		str += "join comm_org_information owning on owning.org_id=dev.owning_org_id ";
		str += "left join comm_org_information usage on usage.org_id=dev.usage_org_id ";
		str += "join comm_coding_sort_detail usestat on usestat.coding_code_id=dev.using_stat ";
		if(types =='1'){
			str += "left join gms_device_license lic on lic.dev_acc_id=dev.dev_acc_id  ";
		}else{
			str += "left join gms_device_license lic on lic.dev_acc_id=dev.dev_acc_id and lic.license_type='<%=licensetype%>' ";
		}
		
		str += "left join comm_coding_sort_detail cycle on cycle.coding_code_id=lic.dev_audie_cycle ";
		
		str += "where dev.owning_sub_id like '<%=usersubid%>%' ";
		
		if(types =='1'){
			//船舶查询
			str += "and dev.dev_type like 'S0808%' ";	
		}else{
			//增加机械的范围
			str += "and dev.dev_type like 'S08%' and dev.license_num is not null ";	
		}
		
		
	
		
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and dev.dev_name like '%"+v_dev_name+"%' ";
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "and dev.dev_model like '%"+v_dev_model+"%' ";
		}
		
		str += "order by dev.dev_type) tmp ";
		if(v_validdayinfo!=undefined && v_validdayinfo!=''){
			str += " where to_number(tmp.validdayinfo)<"+v_validdayinfo;
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function toModifyDetailPage(){
		var licensetype='<%=licensetype%>';
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
			popWindow('<%=contextPath%>/rm/dm/devlicense/licenseUpdate.jsp?devaccid='+shuaId+'&licensetype='+licensetype,'880:700');
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
			popWindow('<%=contextPath%>/rm/dm/devmixForm/devMixInfoFormModify.jsp?mixInfoId='+info[0]+'&devappid='+info[1],'950:680');
		}else{
			popWindow('<%=contextPath%>/rm/dm/devmixForm/devMixInfoFormNew.jsp?devappid='+info[1],'950:680');
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
			alert("您只能选择状态为'调配中'的记录删除!");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var idinfos = idinfo.replace(/[~]/g,"','");
			idinfos = "'"+idinfos+"'";
			alert(idinfos)
			var sql = "update gms_device_mixinfo_form set bsflag='1' where device_mixinfo_id in ("+idinfos+")";
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
			//根据ids去查找
			var str = "select dev.dev_acc_id, dev.dev_name,dev.dev_model,dev.license_num,dev.owning_org_id,owning.org_abbreviation as owning_org_name,";
		str += "dev.asset_coding,dev.usage_org_id,usage.org_abbreviation as usage_org_name,dev.using_stat,usestat.coding_name as usestat_name,";
		str += "lic.dev_reg_date,lic.dev_audie_cycle,cycle.coding_name as cycle_name,lic.last_audit_date,lic.validate_end,lic.plan_audit_date_1,lic.plan_audit_date_2,lic.plan_audit_date_3,lic.plan_audit_date_4,";
		str += "case when round(to_number(lic.validate_end-trunc(sysdate)))<0 then 0 ";
		str += "else round(to_number(lic.validate_end-trunc(sysdate))) end as validdayinfo ";
		str += "from gms_device_account dev ";
		str += "join comm_org_information owning on owning.org_id=dev.owning_org_id ";
		str += "left join comm_org_information usage on usage.org_id=dev.usage_org_id ";
		str += "join comm_coding_sort_detail usestat on usestat.coding_code_id=dev.using_stat ";
		
		if(types =='1'){
			str += "left join gms_device_license lic on lic.dev_acc_id=dev.dev_acc_id  ";
		}else{
			str += "left join gms_device_license lic on lic.dev_acc_id=dev.dev_acc_id and lic.license_type='<%=licensetype%>' ";
		}
		

		str += "left join comm_coding_sort_detail cycle on cycle.coding_code_id=lic.dev_audie_cycle ";
		
		str += "where dev.dev_acc_id='"+shuaId+"'";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		//取消选中框--------------------------------------------------------------------------
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].dev_acc_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].dev_acc_id+"']").attr("checked",'true');
		//------------------------------------------------------------------------------------
		$("#dev_name").val(retObj[0].dev_name);
		$("#dev_model").val(retObj[0].dev_model);
		$("#license_num").val(retObj[0].license_num);
		$("#asset_coding").val(retObj[0].asset_coding);
		$("#owning_org_name").val(retObj[0].owning_org_name);
		$("#usage_org_name").val(retObj[0].usage_org_name);
		$("#usestat_name").val(retObj[0].usestat_name);
		
		$("#plan_audit_date_1").val(retObj[0].plan_audit_date_1);
		$("#plan_audit_date_2").val(retObj[0].plan_audit_date_2);
		$("#plan_audit_date_3").val(retObj[0].plan_audit_date_3);
		$("#plan_audit_date_4").val(retObj[0].plan_audit_date_4);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>