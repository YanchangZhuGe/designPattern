<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String projectCommon = user.getProjectCommon();
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

  <title>单项目-设备接收-设备接收(装备调配单台)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_device_app_name" name="s_device_app_name" type="text" /></td>
			    <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
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
			    <auth:ListButton functionId="" css="jh" event="onclick='toDetailPage()'" title="JCDP_btn_submit"></auth:ListButton>
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
			     <tr id='device_outinfo_id_{device_outinfo_id}' name='device_outinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_outinfo_id}~{mix_type_id}' id='selectedbox_{device_outinfo_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_odd" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_even" exp="{in_org_name}">转入单位</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{employee_name}">开据人</td>
					<td class="bt_info_even" exp="{out_date}">出库时间</td>
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
				<td class="inquire_form6"><input id="dev_project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调拨单号</td>
				<td class="inquire_form6"><input id="dev_mixinfo_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">转入单位</td>
				<td class="inquire_form6"><input id="dev_in_org" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6"><input id="dev_out_org" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">开据人</td>
				<td class="inquire_form6"><input id="dev_print_emp" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">出库时间</td>
				<td class="inquire_form6"><input id="dev_create_date" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">处理状态</td>
				<td class="inquire_form6"><input id="dev_state" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="5%">序号</td>
				    		<!--<td class="bt_info_even" width="15%">项目名称</td>
 				        <td class="bt_info_odd" width="15%">设备编号</td> -->
							<td class="bt_info_odd" width="11%">设备名称</td>
							<td class="bt_info_even" width="11%">规格型号</td>
							<td class="bt_info_odd" width="10%">自编号</td>
							<td class="bt_info_even" width="9%">牌照号</td>
							<td class="bt_info_odd" width="11%">实物标识号</td>
							<td class="bt_info_even" width="13%">实际进场时间</td>
							<td class="bt_info_odd" width="13%">计划离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
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
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
				currentid = currentid.split("~")[0];
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var prosql = "select amd.actual_in_time,amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date,pro.project_name, ";
				prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model ";
				prosql += "from gms_device_equ_outdetail amd ";
				prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
				prosql += "left join gms_device_equ_outsub amm on amd.device_oif_subid=amm.device_oif_subid ";
				prosql += "left join gms_device_equ_outform eof on eof.device_outinfo_id=amm.device_outinfo_id ";
				prosql += "left join gp_task_project pro on pro.project_info_no=eof.project_info_no ";
				prosql += "where eof.device_outinfo_id='"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].actual_in_time+"</td><td>"+datas[i].dev_plan_end_date+"</td>";
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
	var projectType="<%=projectType%>";
	var projectCommon="<%=projectCommon%>";
	var ret;
	var retFatherNo;
	var sonFlag = null;//是否为子项目标志

	$().ready(function(){

		//井中地震获取子项目的父项目编号 
		if(projectInfoNos!=null && projectType == "5000100004000000008"){
			ret = jcdpCallService("DevCommInfoSrv", "getFatherNoInfo", "projectInfoNo="+projectInfoNos);
			retFatherNo = ret.deviceappMap.project_father_no;
		}

		//井中地震子项目屏蔽新增、修改、删除、提交、编辑明细按钮
	    if(projectType == "5000100004000000008" && retFatherNo.length>=1){
	    	sonFlag = 'Y';
	    }else{
	    	sonFlag = 'N';
	    }
	});
	
	function searchDevData(){
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_device_app_name = document.getElementById("s_device_app_name").value;
		var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		refreshData(v_device_app_name, v_mixinfo_no, v_opr_state_desc);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_opr_state_desc").value="";
    	document.getElementById("s_device_app_name").value="";
		document.getElementById("s_mixinfo_no").value="";
    }
	function refreshData(v_device_app_name,v_mixinfo_no,v_opr_state_desc){
		var str = "select devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name, "
		    	 + "inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name, "
		    	 + "he.employee_name,outform.receive_state,outform.out_date, "
		    	 + "case outform.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,mif.mix_type_id "
		    	 + "from gms_device_equ_outform outform "
		    	 + "left join gms_device_mixinfo_form mif on outform.device_mixinfo_id=mif.device_mixinfo_id "
		    	 + "left join gms_device_app devapp on devapp.device_app_id=mif.device_app_id "
		         + "left join comm_org_information inorg on outform.in_org_id=inorg.org_id and inorg.bsflag = '0' "
		         + "left join comm_org_subjection sub on outform.out_org_id=sub.org_subjection_id and sub.bsflag = '0' "
		         + "left join comm_org_information outorg on sub.org_id=outorg.org_id and outorg.bsflag = '0' "
		         + "left join comm_human_employee he on outform.print_emp_id=he.employee_id ";

		  //井中地震 
			if(projectType == "5000100004000000008" && retFatherNo.length >= 1){//子项目
				str += "left join gp_task_project pro on outform.project_info_no = pro.project_info_no and pro.bsflag = '0' and pro.project_type = '5000100004000000008' "
					  + "where outform.bsflag='0' and outform.state = '9' and mif.mix_type_id != 'S14059999' and outform.project_info_no = '" +retFatherNo+"' ";
			}else if(projectType == "5000100004000000008" && retFatherNo.length <= 0){
	        	str += "left join gp_task_project pro on outform.project_info_no = pro.project_info_no and pro.bsflag = '0' and pro.project_father_no is null and pro.project_type = '5000100004000000008' "
	        		 + "where outform.bsflag='0' and outform.state = '9' and mif.mix_type_id != 'S14059999' and outform.project_info_no='"+projectInfoNos+"' ";
	         }else{
	        	str += "left join gp_task_project pro on outform.project_info_no = pro.project_info_no and pro.bsflag = '0' "
	        	     + "where outform.bsflag='0' and outform.state = '9' and mif.mix_type_id != 'S14059999' and outform.project_info_no='"+projectInfoNos+"' ";
		     }

			if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc == '1'){//处理中
				str += "and outform.opr_state = '1' ";
			}else if(v_opr_state_desc == '9'){//已处理
				str += "and outform.opr_state = '9' ";
			}else{//未处理
				str += "and ((outform.opr_state != '1' and outform.opr_state != '9') or outform.opr_state is null) ";
			}					
		}    
		if(v_device_app_name!=undefined && v_device_app_name!=''){
			str += "and devapp.device_app_name like '%"+v_device_app_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and outform.outinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		str += "and exists (select 1 from gms_device_equ_outdetail amd "
			  + "left join gms_device_equ_outsub amm on amd.device_oif_subid = amm.device_oif_subid "
			  + "where outform.device_outinfo_id = amm.device_outinfo_id) "
			  + "order by oprstate_desc,outform.out_date desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(shuaId){
    	var retObj;
    	shuaId = shuaId.split("~")[0];
    	var mainsql ="select devapp.device_app_name,outform.device_outinfo_id,outform.outinfo_no,outform.PROJECT_INFO_NO,pro.project_name, "+
		"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"+
		"he.employee_name,outform.receive_state,outform.out_date, "+
		"case outform.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc,mif.mix_type_id "+
		"from gms_device_equ_outform outform "+
		"left join gms_device_mixinfo_form mif on outform.device_mixinfo_id=mif.device_mixinfo_id "+
		"left join gms_device_app devapp on devapp.device_app_id=mif.device_app_id "+
		"left join gp_task_project pro on outform.project_info_no=pro.project_info_no "+
		"left join comm_org_information inorg on outform.in_org_id=inorg.org_id "+
		"left join comm_org_subjection sub on outform.out_org_id=sub.org_subjection_id left join comm_org_information outorg on sub.org_id=outorg.org_id "+
		"left join comm_human_employee he on outform.print_emp_id=he.employee_id "+
		"where outform.device_outinfo_id='"+shuaId+"'";
    	var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
		retObj = proqueryRet.datas;
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
	    for (i=0; i<obj.length; i++){   
	        obj[i].checked = false;        
	    } 
		//选中这一条checkbox
		$("#selectedbox_"+retObj[0].device_outinfo_id).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_outinfo_id+"']").removeAttr("checked");
		//------------------------------------------------------------------------------------
		document.getElementById("dev_project_name").value =retObj[0].project_name;
		document.getElementById("dev_mixinfo_no").value =retObj[0].outinfo_no;
		document.getElementById("dev_in_org").value =retObj[0].in_org_name;
		document.getElementById("dev_out_org").value =retObj[0].out_org_name;
		document.getElementById("dev_print_emp").value =retObj[0].employee_name;		
		document.getElementById("dev_create_date").value =retObj[0].out_date;
		document.getElementById("dev_state").value =retObj[0].oprstate_desc;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    function toDetailPage(){
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
		window.location.href='<%=contextPath%>/rm/dm/EqDevReceive/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag='+sonFlag;
    }
	function dbclickRow(shuaId){
		window.location.href='<%=contextPath%>/rm/dm/EqDevReceive/subDevReceiveList.jsp?mixId='+shuaId+'&sonFlag='+sonFlag;
	}
</script>
</html>