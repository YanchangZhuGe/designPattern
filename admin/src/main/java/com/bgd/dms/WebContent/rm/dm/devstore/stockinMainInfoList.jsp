<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//用户机构对应的orgsubid信息
	String orgsubid = user.getOrgSubjectionId();
	System.out.println("orgsubid == "+orgsubid);
	String orgsuborgid = user.getSubOrgIDofAffordOrg();
	System.out.println("orgsuborgid == "+orgsuborgid);
	String zhEquSub="";
	String orgType="";
	if(orgsubid.startsWith("C105008")){//综合物化探
		orgType="Y";
		if(orgsubid.startsWith("C105008042")){//综合物化探机动设备服务中心用户显示设备物资科设备
			zhEquSub="Y";
		}
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

  <title>多项目-收工验收-收工验收(单台)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text"/></td>
			    <td class="ali_cdn_name">返还调配单号</td>
			    <td class="ali_cdn_input"><input id="s_backmixinfo_no" name="s_backmixinfo_no" type="text"/></td>
			    <td class="ali_cdn_name">返还单位名称</td>
			    <td class="ali_cdn_input"><input id="s_usage_org_name" name="s_usage_org_name" type="text"/></td>
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
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toDetailPage()'" title="验收"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
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
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' back_devtype='{backdevtype}' value='{device_mixinfo_id}' id='selectedbox_{device_mixinfo_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd"  exp="{backapp_name}">返还申请单名称</td>
					<td class="bt_info_even"  exp="{backmixinfo_no}">返还调配单号</td>
					<td class="bt_info_odd" exp="{usage_org_name}">返还单位名称</td>
					<td class="bt_info_even" exp="{own_org_name}">接收单位名称</td>
					<td class="bt_info_odd" exp="{mix_username}">调配人</td>
					<td class="bt_info_even" exp="{mixdate}">调配时间</td>
					<td class="bt_info_odd" exp="{oprstate_desc}">处理状态</td>
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
			    <!-- <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">单据调配状态</a></li> -->
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">审批信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">备注</a></li>
			    <li id="tag3_6"><a href="#" onclick="getContentTab(this,6)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">返还调配单号：</td>
				      <td   class="inquire_form6" ><input id="backmixinfo_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6"  ><input id="project_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">返还单位：</td>
				     <td  class="inquire_form6"><input id="usage_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">接收单位：</td>
				     <td  class="inquire_form6"><input id="own_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">调配人：</td>
				     <td  class="inquire_form6"><input id="mix_username" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">调配时间</td>
				     <td  class="inquire_form6"><input id="mixdate" class="input_width" type="text"  value="" disabled/>&nbsp;</td>  
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			          <tr>	
			        	<td class="bt_info_odd" width="5%">序号</td>
			        	<td class="bt_info_odd" width="8%">设备名称</td>
						<td class="bt_info_even" width="8%">规格型号</td>
						<td class="bt_info_odd" width="12%">自编号</td>
						<td class="bt_info_even" width="12%">实物标识号</td>
						<td class="bt_info_odd" width="12%">牌照号</td>
						<td class="bt_info_even" width="10%">资产状况</td>
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

var orgType = "<%=orgType%>";

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
    function toStockDetailPage(obj){
    	window.location.href = "subStockin.jsp?id="+obj;
    }

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
			var backdevtype;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
					backdevtype = this.back_devtype;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select oper.operator_name,dui.self_num,dui.dev_sign,dui.license_num,dui.dev_name,";
				str += "dui.dev_model,sd.coding_name as stat_desc from gms_device_backapp_detail backdet ";
				str += "left join gms_device_account_dui dui on backdet.dev_acc_id=dui.dev_acc_id ";
				str += "left join comm_coding_sort_detail sd on dui.account_stat=sd.coding_code_id ";
				str += "left join gms_device_equipment_operator oper on oper.device_account_id = dui.dev_acc_id ";
				if(backdevtype=='S9998'){//大港调剂设备
					str += "where backdet.device_backapp_id='"+currentid+"' and dui.owning_sub_id like '<%=orgsubid%>%' ";
				}else if(orgType == 'Y'){
					str += "where backdet.device_mixinfo_id='"+currentid+"' and dui.owning_sub_id like '<%=orgsubid%>%' ";
				}else{
					str += "where backdet.device_mixinfo_id='"+currentid+"' ";
				}		
				str = encodeURI(encodeURI(str));
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=100');
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
			}
		}else if(index == 2){
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
				var str = "select info.org_abbreviation,case when al.mix_total=0 then '未处理' when al.app_total > al.mix_total then '处理中' when al.app_total = al.mix_total then '已处理' end as state from (select appdet.dev_out_org_id,nvl(sum(appdet.apply_num),0) as app_total,nvl(sum(tmp.mixed_num),0) as mix_total  from gms_device_app_detail appdet  left join (select device_app_detid, sum(assign_num) as mixed_num from gms_device_appmix_main amm  where amm.bsflag = '0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid group by appdet.dev_out_org_id ) al left join comm_org_information info on al.dev_out_org_id = info.org_id";
				str = encodeURI(encodeURI(str));
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=100');
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#tpList";
					$(filtermapid).empty();
					appendDataToDetail(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#tpList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].self_num+"</td><td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].stat_desc+"</td>";
			innerHTML += "</tr>";
			
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function appendDataToDetail(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].org_abbreviation+"</td><td>"+datas[i].state+"</td>";
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
	var zhequsub = '<%=zhEquSub%>';
	
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else 
	             {obj[i].checked = true;  
	              checkvalue = obj[i].value;
	             } 
	        }      
    }
    function loadDataDetail(devicemixinfoid){
    	var retObj;
		if(devicemixinfoid!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getStockInfo", "devicemixinfoid="+devicemixinfoid);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getStockInfo", "devicemixinfoid="+ids);
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("selectedbox");  
	        for (i=0; i<obj.length; i++){   
	            obj[i].checked = false;   
	             
	        } 
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceBackappMap.device_mixinfo_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceBackappMap.device_mixinfo_id+"']").removeAttr("checked");
		//------------------------------------------------------------------------------------
		
		document.getElementById("backmixinfo_no").value =retObj.deviceBackappMap.backmixinfo_no;
		document.getElementById("project_name").value =retObj.deviceBackappMap.project_name;
		document.getElementById("usage_org_name").value =retObj.deviceBackappMap.usage_org_name;
		document.getElementById("own_org_name").value =retObj.deviceBackappMap.own_org_name;
		document.getElementById("mix_username").value =retObj.deviceBackappMap.mix_username;
		document.getElementById("mixdate").value =retObj.deviceBackappMap.mixdate;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }

	function searchDevData(){
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_backmixinfo_no = document.getElementById("s_backmixinfo_no").value;
		var v_usage_org_name = document.getElementById("s_usage_org_name").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_opr_state_desc,v_backmixinfo_no, v_usage_org_name, v_project_name);
	}
	//清空查询条件
  function clearQueryText(){
    	document.getElementById("s_opr_state_desc").value="";
    	document.getElementById("s_backmixinfo_no").value="";
		document.getElementById("s_usage_org_name").value="";
		document.getElementById("s_project_name").value="";
  }
	
	function refreshData(v_opr_state_desc,v_backmixinfo_no,v_usage_org_name, v_project_name){
		var str="";
		if(orgType=="Y"){
			str += "select distinct bif.opr_state,gdb.backapp_name,pro.project_name,bif.device_mixinfo_id,bif.backmixinfo_no,bif.project_info_no,";
			str += " bif.usage_org_id,bif.own_org_id,org.org_abbreviation as usage_org_name,outorg.org_abbreviation as own_org_name,";
			str += "case bif.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,";
			str += "emp.employee_name as mix_username,to_char(bif.modifi_date,'yyyy-mm-dd') as mixdate ";
			str += "from gms_device_backinfo_form bif left join gms_device_backapp_detail det on bif.device_mixinfo_id=det.device_mixinfo_id left join gms_device_account_dui dui on det.dev_acc_id=dui.dev_acc_id ";
			str += "left join comm_org_information outorg on dui.owning_org_id = outorg.org_id ";
			str	+= "left join gms_device_backapp gdb on bif.device_backapp_id=gdb.device_backapp_id and gdb.bsflag='0' ";
			str += "left join comm_org_information org on bif.org_id = org.org_id ";
			str += "left join comm_human_employee emp on bif.print_emp_id = emp.employee_id ";
			str += "left join gp_task_project pro on bif.project_info_no = pro.project_info_no ";
			//加机构权限
			str += "left join comm_org_subjection orgsub on bif.org_id=orgsub.org_id and orgsub.bsflag='0' ";
			str += "where bif.bsflag = '0' and bif.state='9' ";
			if(zhequsub == 'Y'){//综合物化探机械设备服务中心
				str += "and (dui.owning_sub_id like 'C105008042%' or dui.owning_sub_id like '%C105008013%') ";
			}else{
				str += "and dui.owning_sub_id like '<%=orgsubid%>%' ";
			}
			//补充查询条件
			if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
				if(v_opr_state_desc == '1'){//处理中
					str += "and bif.opr_state = '1' ";
				}else if(v_opr_state_desc == '9'){//已处理
					str += "and bif.opr_state = '9' ";
				}else{//未处理
					str += "and ((bif.opr_state != '1' and bif.opr_state != '9') or bif.opr_state is null) ";
				}					
			}
			if(v_backmixinfo_no!=undefined && v_backmixinfo_no!=''){
				str += "and bif.backmixinfo_no like '%"+v_backmixinfo_no+"%' ";
			}
			if(v_usage_org_name!=undefined && v_usage_org_name!=''){
				str += "and outorg.org_name like '%"+v_usage_org_name+"%' ";
			}
			if(v_project_name!=undefined && v_project_name!=''){
				str += "and pro.project_name like '%"+v_project_name+"%' ";
			}
			 str += "order by bif.opr_state nulls first,mixdate desc "
		}else{
			str += "select * from (select org.org_name,gdb.backdevtype,gdb.backapp_name,pro.project_name,bif.device_mixinfo_id,bif.backmixinfo_no,bif.project_info_no,";
			str += " bif.usage_org_id,bif.own_org_id,org.org_abbreviation as usage_org_name,outorg.org_abbreviation as own_org_name,";
			str += "case bif.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,";
			str += "emp.employee_name as mix_username,to_char(bif.modifi_date,'yyyy-mm-dd') as mixdate,orgsub.org_subjection_id,bif.opr_state ";
			str += "from gms_device_backinfo_form bif left join gms_device_backapp gdb on bif.device_backapp_id=gdb.device_backapp_id and gdb.bsflag='0'";
			str += "left join comm_org_information org on bif.usage_org_id = org.org_id ";
			str += "left join comm_org_information outorg on  bif.own_org_id = outorg.org_id  ";
			str += "left join comm_human_employee emp on bif.print_emp_id = emp.employee_id ";
			str += "left join gp_task_project pro on bif.project_info_no = pro.project_info_no ";
			//加机构权限
			str += "left join comm_org_subjection orgsub on bif.own_org_id=orgsub.org_id and orgsub.bsflag='0' ";
			str += "where bif.bsflag = '0' and bif.state='9' and gdb.backdevtype != 'S1405' and gdb.backdevtype != 'S14059999' ";
			//加入大港调剂收工验收
			str += "union all ";
			str += "select distinct orginfo.org_name,gdb.backdevtype,gdb.backapp_name,gtp.project_name,gdb.device_backapp_id as device_mixinfo_id,gdb.device_backapp_no as backmixinfo_no,gtp.project_info_no,gdb.back_org_id as usage_org_id, ";
			str += "dui.owning_org_id as own_org_id ,org.org_abbreviation as usage_org_name , orginfo.org_abbreviation as own_org_name , ";
			str += "case gdb.opr_state  when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc, ";
			str += "emp.employee_name as mix_username,to_char(gdb.modifi_date, 'yyyy-mm-dd') as mixdate,dui.owning_sub_id as org_subjection_id ,gdb.opr_state ";
			str += "from gms_device_backapp gdb left join gp_task_project gtp on gdb.project_info_id = gtp.project_info_no ";
			str += "left join gms_device_backapp_detail dbd on gdb.device_backapp_id = dbd.device_backapp_id ";
			str += "left join gms_device_account_dui dui on dbd.dev_acc_id = dui.dev_acc_id ";
			str += "left join comm_org_information org on gdb.back_org_id = org.org_id ";
			str += "left join comm_human_employee emp   on gdb.creator_id = emp.employee_id ";
			str += "left join comm_org_information orginfo on dui.owning_org_id = orginfo.org_id ";
			str += "where gdb.backdevtype='S9998' and gdb.bsflag='0') backapp where 1=1 ";
			
			str += "and backapp.org_subjection_id like '<%=orgsuborgid%>%' ";
			
			//补充查询条件
			if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
				if(v_opr_state_desc == '1'){//处理中
					str += "and backapp.opr_state = '1' ";
				}else if(v_opr_state_desc == '9'){//已处理
					str += "and backapp.opr_state = '9' ";
				}else{//未处理
					str += "and ((backapp.opr_state != '1' and backapp.opr_state != '9') or backapp.opr_state is null) ";
				}					
			}
			if(v_backmixinfo_no!=undefined && v_backmixinfo_no!=''){
				str += "and backapp.backmixinfo_no like '%"+v_backmixinfo_no+"%' ";
			}
			if(v_usage_org_name!=undefined && v_usage_org_name!=''){
				str += "and backapp.org_name like '%"+v_usage_org_name+"%' ";
			}
			if(v_project_name!=undefined && v_project_name!=''){
				str += "and backapp.project_name like '%"+v_project_name+"%' ";
			}
			str += "order by backapp.opr_state nulls first,backapp.mixdate desc "
			//alert(str);
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function toDetailPage(){
    	var shuaId;
    	var backDevType;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			shuaId = this.value;
    			backDevType = this.back_devtype;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		window.location.href='<%=contextPath%>/rm/dm/devstore/subStockin.jsp?id='+shuaId+'&backdevtype='+backDevType;
    }	
	function dbclickRow(shuaId){
    	var backDevType;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			backDevType = this.back_devtype;
    		}
    	});
		window.location.href='<%=contextPath%>/rm/dm/devstore/subStockin.jsp?id='+shuaId+'&backdevtype='+backDevType;;
	}
	
</script>
</html>