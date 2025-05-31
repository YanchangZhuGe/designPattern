<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
  <title>调配明细列表页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">调配申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_app_no" name="s_device_app_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="jl" event="onclick='toMixDetailPage()'" title="查看明细"></auth:ListButton>
			    <auth:ListButton functionId="" css="lw" event="onclick='toPrintTPD()'" title="开据调配单"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mix_id_{device_mix_id}' name='device_mix_id'>
			        <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_mix_id}' checkinfo='{in_org_id}~{out_org_id}' detailinfo='{is_add_detail}~{is_print_form}' id='selectedbox_{device_mix_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_no}">申请单号</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_even" exp="{assign_num}">分配数量</td>
					<td class="bt_info_odd" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_odd" exp="{in_org_name}">转入单位</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{is_add_detail_desc}">是否添加设备明细</td>
					<td class="bt_info_even" exp="{is_print_form_desc}">是否开据调配单</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devdetailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">申请单号</td>
				      <td  class="inquire_form6"><input id="device_app_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;班组：</td>
				      <td  class="inquire_form6"  ><input id="team" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">设备名称：</td>
				     <td  class="inquire_form6"><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;规格型号：</td>
				     <td  class="inquire_form6"><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">分配数量：</td>
				     <td  class="inquire_form6"><input id="assign_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">单位：</td>
				     <td  class="inquire_form6"><input id="unitname" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;计划开始时间：</td>
				     <td  class="inquire_form6"><input id="plan_start_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;计划结束时间：</td>
				     <td  class="inquire_form6"><input id="plan_end_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    		<td class="bt_info_odd" width="15%">序号</td>
				        	<td class="bt_info_even" width="15%">设备编号</td>
							<td class="bt_info_odd" width="11%">设备名称</td>
							<td class="bt_info_even" width="11%">规格型号</td>
							<td class="bt_info_odd" width="10%">自编号</td>
							<td class="bt_info_even" width="9%">牌照号</td>
							<td class="bt_info_odd" width="11%">实物标识号</td>
							<td class="bt_info_even" width="13%">计划进场时间</td>
							<td class="bt_info_odd" width="13%">计划离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>         
			        </table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<table id="approveList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>模板名称</td>
				            <td>序号</td>
				            <td>审批情况</td>		
				            <td>审批意见</td>
				            <td>审批人</td>			
				            <td>审批时间</td> 
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					
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
				var prosql = "select amd.device_appmix_id, amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date, ";
				prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model ";
				prosql += "from gms_device_appmix_detail amd ";
				prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
				prosql += "where amd.device_mix_id='"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
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
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].asset_coding+"</td><td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].dev_plan_start_date+"</td><td>"+datas[i].dev_plan_end_date+"</td>";
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
		var v_device_app_no = document.getElementById("s_device_app_no").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_device_app_no, v_project_name);
	}
	
	function refreshData(v_device_app_no,v_project_name){
		var str = "select amm.device_mix_id,amm.in_org_id,amm.out_org_id,amm.assign_num,";
		str += "amm.is_add_detail,case amm.is_add_detail when 'Y' then '是' else '否' end as is_add_detail_desc,";
		str += "amm.is_print_form,case amm.is_print_form when 'Y' then '是' else '否' end as is_print_form_desc,";
		str += "ad.team,ad.dev_ci_code,ad.unitinfo,ad.plan_start_date,ad.plan_end_date,ci.dev_ci_name,ci.dev_ci_model,";
		str += "devapp.project_info_no,devapp.device_app_no,pro.project_name,sd.coding_name as unitname,";
		str += "in_org.org_abbreviation as in_org_name, out_org.org_abbreviation as out_org_name ";
		str += "from gms_device_appmix_main amm ";
		str += "left join gms_device_app_detail ad on amm.device_app_detid = ad.device_app_detid ";
		str += "left join gms_device_app devapp on ad.device_app_id = devapp.device_app_id ";
		str += "left join gp_task_project pro on pro.project_info_no = devapp.project_info_no ";
		str += "left join comm_coding_sort_detail sd on sd.coding_code_id = ad.unitinfo ";
		str += "left join gms_device_codeinfo ci on ad.dev_ci_code = ci.dev_ci_code ";
		str += "left join comm_org_information in_org on amm.in_org_id=in_org.org_id ";
		str += "left join comm_org_information out_org on amm.in_org_id=out_org.org_id ";
		//TODO设置查询条件
		/*
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and project.v_project_name like '"+v_dev_ci_model+"%' ";
		}
		*/
		str += "order by modifi_date desc,out_org_id,is_add_detail,is_print_form  ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	 function loadDataDetail(device_mix_id){
    	var retObj;
		if(device_mix_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevMixMainInfo", "devicemixid="+device_mix_id);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevMixMainInfo", "devicemixid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.devicedetailMap.device_mix_id).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devicedetailMap.device_mix_id+"']").removeAttr("checked");
		
		//数据回填
		$("#project_name","#devdetailMap").val(retObj.devicedetailMap.project_name);
		$("#device_app_no","#devdetailMap").val(retObj.devicedetailMap.device_app_no);
		$("#team","#devdetailMap").val(retObj.devicedetailMap.team);
		$("#purpose","#devdetailMap").val(retObj.devicedetailMap.purpose);
		$("#unitname","#devdetailMap").val(retObj.devicedetailMap.unitname);
		$("#dev_ci_name","#devdetailMap").val(retObj.devicedetailMap.dev_ci_name);
		$("#dev_ci_model","#devdetailMap").val(retObj.devicedetailMap.dev_ci_model);
		$("#plan_start_date","#devdetailMap").val(retObj.devicedetailMap.plan_start_date);
		$("#plan_end_date","#devdetailMap").val(retObj.devicedetailMap.plan_end_date);
		
		$("#assign_num","#devdetailMap").val(retObj.devicedetailMap.assign_num);
		$("#apply_user","#devdetailMap").val(retObj.devicedetailMap.employee_name);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }
    
    function toMixDetailPage(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
    	popWindow('<%=contextPath%>/rm/dm/devmixdetail/planMixDetail.jsp?device_mix_id='+id,"900:680");
    }
    function dbclickRow(shuaId){
    	popWindow('<%=contextPath%>/rm/dm/devmixdetail/planMixDetail.jsp?device_mix_id='+shuaId,"900:680");
	}
    function toPrintTPD(){
    	var selectids = "";
    	var checkinfo;
    	var detailinfo;
    	var validflag = true;
    	var detailflag = true;
    	var length = 0;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			length = length+1;
    		}
    	});
    	if(length>=2){
    		var count = 0;
	    	$("input[type='checkbox'][name='selectedbox']").each(function(i){
	    		if(this.checked){
		    		if(count==0){
		    			detailinfo = this.detailinfo;
		    			if(detailinfo!='Y~N'&&detailflag==true){
		    				detailflag = false;
		    			}
		    			checkinfo = this.checkinfo ;
		    			selectids = "('"+this.value;
		    		}else{
		    			selectids += "','"+this.value;
		    			if(checkinfo!=this.checkinfo&&validflag==true){
		    				validflag = false;
		    			}
		    			detailinfo = this.detailinfo;
		    			if(detailinfo!='Y~N'&&detailflag==true){
		    				detailflag = false;
		    			}
		    		}
		    		count = count+1;
	    		}
	    	});
	    	selectids += "')";
	    	if(validflag==false){
	    		alert("添加到调配单的机构信息不唯一，请重新选择!");
	    		return;
	    	}
	    	alert(detailflag)
	    	if(detailflag==false){
	    		alert("未添加设备明细或已生成调配单，请查看!");
	    		return;
	    	}
    	}else{
    		selectids = "('";
    		var checkval ;
    		$("input[type='checkbox'][name='selectedbox']").each(function(){
    			if(this.checked){
    				checkval = this.value;
    				detailinfo = this.detailinfo;
    			}
    		});
    		selectids += checkval+"')";
    		if(detailinfo!='Y~N'){
				alert("未添加设备明细或已生成调配单，请查看!");
	    		return;
			}
    	}
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devmixdetail/mixDetailQuickNew.jsp?devicemixids='+selectids,"900:680");
	} 
</script>
</html>