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

  <title>收工验收</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text"/></td>
			    <td class="ali_cdn_name">返还申请单号</td>
			    <td class="ali_cdn_input"><input id="s_device_backapp_no" name="s_device_backapp_no" type="text"/></td>
			    <td class="ali_cdn_name">返还单位名称</td>
			    <td class="ali_cdn_input"><input id="s_back_org_name" name="s_back_org_name" type="text"/></td>
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
			    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title=""></auth:ListButton>
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
			     <tr id='device_backapp_id_{device_backapp_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' reorgid='{receive_org_id}' opertype='{opr_state}' backtypemixid='{backdevtype}~{device_mixinfo_id}' value='{device_backapp_id}' id='selectedbox_{device_backapp_id}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd"  exp="{device_backapp_no}">返还申请单号</td>
					<td class="bt_info_even"  exp="{backapp_name}">返还申请单名称</td>
					<td class="bt_info_odd" exp="{back_org_name}">返还单位名称</td>
					<td class="bt_info_even" exp="{back_username}">返还申请人</td>
					<td class="bt_info_even" exp="{reorg_name}">验收单位</td>
					<td class="bt_info_odd" exp="{backappdate}">返还申请时间</td>
					<td class="bt_info_even" exp="{oprstate_desc}">处理状态</td>
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
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">项目名称：</td>
				      <td   class="inquire_form6"><input id="project_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单号：</td>
				      <td  class="inquire_form6"><input id="device_backapp_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单名称</td>
				     <td  class="inquire_form6"><input id="backapp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">返还单位名称：</td>
				     <td  class="inquire_form6"><input id="back_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">返还申请人：</td>
				     <td  class="inquire_form6"><input id="back_username" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间</td>
				     <td  class="inquire_form6"><input id="backappdate" class="input_width" type="text"  value="" disabled/>&nbsp;</td>  
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" idinfo="" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			          <tr>	
			        	<td class="bt_info_odd" width="5%">序号</td>
			        	<td class="bt_info_even" width="10%">设备编号</td>
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
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none"></div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none"></div>
		 </div>
</div>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
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
    function toStockDetailPage(obj){
    	window.location.href = "subStockin.jsp?id="+obj;
    }

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		var basedatas;
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
				var str = "select backdet.*,dui.dev_name,dui.dev_model,sd.coding_name as stat_desc ";
				str += "from gms_device_backapp_detail backdet ";
				str += "left join gms_device_account_dui dui on backdet.dev_acc_id=dui.dev_acc_id ";
				str += "left join comm_coding_sort_detail sd on dui.account_stat=sd.coding_code_id ";
				str += "where backdet.device_backapp_id='"+currentid+"' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
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
		}else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_coding+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
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
	
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
    
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
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    devicemixinfoid = ids;
		}
		//取消选中框--------------------------------------------------------------------------
	    var str = "select pro.project_name,backapp.device_backapp_id,backapp.device_backapp_no,backapp.backapp_name,";
			str += "backapp.project_info_id as project_info_no,backapp.back_org_id,backorg.org_abbreviation as back_org_name,";
			str += "case backapp.state when '0' then '未提交' when '9' then '已提交' else '异常状态' end as state_desc,";
			str += "case backapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,";
			str += "emp.employee_name as back_username,to_char(backapp.modifi_date,'yyyy-mm-dd') as backappdate ";
			str += "from gms_device_backapp backapp ";
			str += "left join comm_org_information backorg on  backapp.back_org_id = backorg.org_id  ";
			str += "left join comm_human_employee emp on backapp.updator_id = emp.employee_id ";
			str += "left join gp_task_project pro on backapp.project_info_id = pro.project_info_no ";
			str += "where backapp.device_backapp_id = '"+devicemixinfoid+"' ";
	    var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
		retObj = unitRet.datas;
		//取消选中框--------------------------------------------------------------------------
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_backapp_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_backapp_id+"']").attr("checked",'true');
		//------------------------------------------------------------------------------------
		$("#project_name").val(retObj[0].project_name);
		$("#device_backapp_no").val(retObj[0].device_backapp_no);
		$("#backapp_name").val(retObj[0].backapp_name);
		$("#back_org_name").val(retObj[0].back_org_name);
		$("#back_username").val(retObj[0].back_username);
		$("#backappdate").val(retObj[0].backappdate);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }

	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_device_backapp_no = document.getElementById("s_device_backapp_no").value;
		var v_back_org_name = document.getElementById("s_back_org_name").value;
		refreshData(v_project_name,v_opr_state_desc,v_device_backapp_no,v_back_org_name);
	}

	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_project_name").value="";
    	document.getElementById("s_opr_state_desc").value="";
		document.getElementById("s_device_backapp_no").value="";
		document.getElementById("s_back_org_name").value="";
    }
	
	function refreshData(v_project_name,v_opr_state_desc,v_device_backapp_no,v_back_org_name){
		var str = "select * from ( select '' as device_mixinfo_id,backapp.backdevtype,pro.project_name,backapp.device_backapp_id,backapp.device_backapp_no,backapp.backapp_name,";
			str += "backapp.project_info_id as project_info_no,backapp.back_org_id,backorg.org_abbreviation as back_org_name,";
			str += "backapp.opr_state,case backapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,";
			str += "emp.employee_name as back_username,to_char(backapp.modifi_date,'yyyy-mm-dd') as backappdate ,reorg.org_abbreviation as reorg_name,backapp.receive_org_id ";
			str += "from gms_device_backapp backapp ";
			str += "left join comm_org_information backorg on  backapp.back_org_id = backorg.org_id  ";
			str += "left join comm_human_employee emp on backapp.updator_id = emp.employee_id ";
			str += "left join gp_task_project pro on backapp.project_info_id = pro.project_info_no ";
			//加机构权限  如果明细中的设备有属于是自身机构的，那么就能看到 
			str += "left join comm_org_subjection orgsub on backapp.backmix_org_id=orgsub.org_id and orgsub.bsflag='0' ";
			str += " left join comm_org_information reorg on reorg.org_id = backapp.receive_org_id ";
			str += "where backapp.bsflag = '0' and backapp.state='9' and backapp.backdevtype!='<%=DevConstants.MIXTYPE_COMMON%>' and backapp.backdevtype != 'S14059999' and backapp.receive_org_id is null ";
			str += "and exists(select 1 from gms_device_backapp_detail bad join gms_device_account_dui dui on bad.dev_acc_id=dui.dev_acc_id  ";
			//回头给这个C105006 换成 orgsubid
			str += "where dui.owning_sub_id like '<%=orgsubid%>%' and bad.device_backapp_id=backapp.device_backapp_id) ";
			
			//2015.6.9新增测量设备返还直接验收
			str += "union all select '' as device_mixinfo_id,backapp.backdevtype,pro.project_name,backapp.device_backapp_id,backapp.device_backapp_no,backapp.backapp_name, ";
			str += "backapp.project_info_id as project_info_no,backapp.back_org_id,backorg.org_abbreviation as back_org_name, ";
			str += "backapp.opr_state,case backapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc, ";
			str += "emp.employee_name as back_username,to_char(backapp.modifi_date,'yyyy-mm-dd') as backappdate,reorg.org_abbreviation as reorg_name,backapp.receive_org_id ";
			str += "from gms_device_backapp backapp left join comm_org_information backorg on  backapp.back_org_id = backorg.org_id ";
			str += "left join comm_human_employee emp on backapp.updator_id = emp.employee_id left join gp_task_project pro on backapp.project_info_id = pro.project_info_no ";
			str += "left join comm_org_subjection orgsub on backapp.backmix_org_id=orgsub.org_id and orgsub.bsflag='0' ";
			str += "left join comm_org_subjection os on backapp.receive_org_id = os.org_id ";
			str += " left join comm_org_information reorg on reorg.org_id = backapp.receive_org_id ";
			str +="where backapp.bsflag = '0' and backapp.state='9' and backapp.backdevtype!='S0000' and backapp.receive_org_id is not null ";
			str +="and os.org_subjection_id like '<%=orgsubid%>%' ) where 1=1 ";
			
			//str += "union all ";
			//str += "select bif.device_mixinfo_id,'S14059999' as backdevtype,pro.project_name,gdb.device_backapp_id,gdb.device_backapp_no,gdb.backapp_name,gdb.project_info_id as project_info_no,";
			//str += "gdb.back_org_id,backorg.org_abbreviation as back_org_name, ";
			//str += "bif.opr_state,case bif.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,emp.employee_name as back_username,to_char(gdb.modifi_date, 'yyyy-mm-dd') as backappdate,reorg.org_abbreviation as reorg_name,gdb.receive_org_id ";
			//str += "from gms_device_backinfo_form bif left join gms_device_backapp gdb on bif.device_backapp_id = gdb.device_backapp_id and gdb.bsflag = '0' ";
			//str += "left join comm_human_employee emp on bif.print_emp_id = emp.employee_id left join gp_task_project pro on bif.project_info_no = pro.project_info_no ";
			//str += "left join comm_org_information backorg on gdb.back_org_id = backorg.org_id left join comm_org_subjection orgsub on bif.own_org_id = orgsub.org_id and orgsub.bsflag = '0' ";
			//str += " left join comm_org_information reorg on reorg.org_id = gdb.receive_org_id ";
			//str += "where bif.bsflag = '0' and bif.state = '9' and (gdb.backdevtype = '<%=DevConstants.MIXTYPE_YIQI%>' or gdb.backdevtype = 'S14059999') and orgsub.org_subjection_id like '<%=orgsubid%>%' ) where 1=1 ";
			
		//补充查询条件
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and project_name like '%"+v_project_name+"%' ";
		}
		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc == '1'){//处理中
				str += "and opr_state = '1' ";
			}else if(v_opr_state_desc == '9'){//已处理
				str += "and opr_state = '9' ";
			}else{//未处理
				str += "and ((opr_state != '1' and opr_state != '9') or opr_state is null) ";
			}
		}
		if(v_device_backapp_no!=undefined && v_device_backapp_no!=''){
			str += "and device_backapp_no like '%"+v_device_backapp_no+"%' ";
		}
		if(v_back_org_name!=undefined && v_back_org_name!=''){
			str += "and back_org_name like '%"+v_back_org_name+"%' ";
		}
		str += "order by opr_state nulls first,backappdate desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		
	}
	function toDetailPage(){
    	var shuaId;
    	var backTypeMixeId;
    	var reOrgId;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			shuaId = this.value;
    			backTypeMixeId = this.backtypemixid;
    			reOrgId = this.reorgid;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = backTypeMixeId.split("~",-1);
		//if(info[0] == 'S14059999'){
		//	window.location.href='<%=contextPath%>/rm/dm/devstore/subStockin.jsp?id='+info[1];
		//}else{
			window.location.href='<%=contextPath%>/rm/dm/EqDevstore/subStockin.jsp?id='+shuaId;
	//	}
    }	
	function dbclickRow(shuaId){
		var shuaId;
    	var backTypeMixeId;
    	var reOrgId;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			shuaId = this.value;
    			backTypeMixeId = this.backtypemixid;
    			reOrgId = this.reorgid;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = backTypeMixeId.split("~",-1);

		//if(info[0] == 'S14059999'){
		//	window.location.href='<%=contextPath%>/rm/dm/devstore/subStockin.jsp?id='+info[1];
		//}else{
			window.location.href='<%=contextPath%>/rm/dm/EqDevstore/subStockin.jsp?id='+shuaId+'&reorgid='+reOrgId;
		//}
	}
	
	//根据装备需求,增加修改功能
	function toModify(){
		var shuaId;
		var operType;
		var reOrgId;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			shuaId = this.value;
    			operType = this.opertype;
    			reOrgId =this.reorgid;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		if(operType==9){
			alert("该单已处理,不能修改!");
			return;
		}
		if(reOrgId == ""){
			alert("该类型设备不能修改!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/EqDevstore/backdetail_new_apply.jsp?id='+shuaId,'800:680');
	}
</script>
</html>