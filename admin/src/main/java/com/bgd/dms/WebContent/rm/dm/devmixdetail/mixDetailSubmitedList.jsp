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
  <title>开据调拨单的界面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			   </tr>
			  <tr>
			  	<td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_mixinfo_no" name="s_mixinfo_no" type="text" class="input_width" />
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
			    <auth:ListButton functionId="" css="zj" event="onclick='toNewPage()'" title="添加"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitPage()'" title="提交"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			        <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_mixinfo_id}' id='selectedbox_{device_mixinfo_id}'  onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{mixinfo_no}">调配单号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{device_app_no}">申请单号</td>
					<td class="bt_info_even" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_odd" exp="{in_org_name}">转入单位</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{print_emp_name}">开据人</td>
					<td class="bt_info_even" exp="{submit_date}">开据日期</td>
					<td class="bt_info_odd" exp="{state_desc}">状态</td>
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
					<table id="devdetailMap" name="devdetailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">项目名称：</td>
				      <td   class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">申请单号：</td>
				      <td  class="inquire_form6"><input id="device_app_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				      <td  class="inquire_item6">&nbsp;申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_app_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     </tr>
				    <tr >
				     <td  class="inquire_item6">&nbsp;调拨单号：</td>
				     <td  class="inquire_form6"  ><input id="mixinfo_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">转入单位：</td>
				     <td  class="inquire_form6"><input id="in_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;转出单位：</td>
				     <td  class="inquire_form6"><input id="out_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				    </tr>
				    <tr>
				     <td  class="inquire_item6">开据人：</td>
				     <td  class="inquire_form6"><input id="print_emp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">开据时间：</td>
				     <td  class="inquire_form6"><input id="submit_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;状态：</td>
				     <td  class="inquire_form6"><input id="state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
				    		<td class="bt_info_even" width="15%">项目名称</td>
				        	<td class="bt_info_odd" width="15%">设备编号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">自编号</td>
							<td class="bt_info_odd" width="9%">牌照号</td>
							<td class="bt_info_even" width="11%">实物标识号</td>
							<td class="bt_info_odd" width="13%">计划进场时间</td>
							<td class="bt_info_even" width="13%">计划离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					
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
				<div id="tab_box_content4" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content5" name="tab_box_content2" class="tab_box_content" style="display:none">
					
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
				var prosql = "select amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date,pro.project_name, ";
				prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model ";
				prosql += "from gms_device_appmix_detail amd ";
				prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
				prosql += "left join gms_device_appmix_main amm on amd.device_mix_id=amm.device_mix_id ";
				prosql += "left join gms_device_mixinfo_detail mid on mid.device_mix_id=amm.device_mix_id ";
				prosql += "left join gp_task_project pro on pro.project_info_no=amm.project_info_no ";
				prosql += "where mid.device_mixinfo_id='"+currentid+"'";
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].project_name+"</td><td>"+datas[i].asset_coding+"</td><td>"+datas[i].dev_name+"</td>";
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
		var str = "select mif.device_mixinfo_id,mif.mixinfo_no,mif.project_info_no,pro.project_name,devapp.device_app_no,devapp.device_app_name,";
			str += "case mif.state when '0' then '未提交' when '9' then '已提交' else '流程处理中' end as state_desc,";
			str += "mif.in_org_id,inorg.org_abbreviation as in_org_name,mif.out_org_id,outorg.org_abbreviation as out_org_name,";
			str += "mif.print_emp_id,to_char(mif.modifi_date,'yyyy-mm-dd') as submit_date,mdmemp.employee_name as print_emp_name ";
			str += "from gms_device_mixinfo_form mif ";
			str += "left join comm_human_employee mdmemp on mif.print_emp_id = mdmemp.employee_id ";
			str += "left join gp_task_project pro on mif.project_info_no=pro.project_info_no ";
			str += "left join gms_device_app devapp on mif.device_app_id = devapp.device_app_id ";
			str += "left join comm_org_information inorg on inorg.org_id=mif.in_org_id ";
			str += "left join comm_org_information outorg on outorg.org_id=mif.out_org_id ";
			str += "where mif.bsflag='0' ";
		//TODO 补充名称的查询条件
		/*
		if(v_device_app_no!=undefined && v_device_app_no!=''){
			str += "and devapp.v_device_app_no = '"+v_device_app_no+"' ";
		}
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and project.v_project_name like '"+v_dev_ci_model+"%' ";
		}
		*/
		str += "order by mif.modifi_date desc,out_org_id ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}

	function toNewPage(){
    	popWindow('<%=contextPath%>/rm/dm/devmixdetail/mixDetailNew.jsp?');
    }
    
    function toModifyPage(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
    	popWindow('<%=contextPath%>/rm/dm/devmixdetail/mixDetailModify.jsp?device_mixinfo_id='+id);
    }
    function toDelRecord(){
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
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.state from gms_device_mixinfo_form devapp ";
		str += "where devapp.bsflag = '0' and devapp.device_mixinfo_id in ("+selectedid+")";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var stateflag = false;
		for(var index = 0;index<unitRet.datas.length;index++){
			if(unitRet.datas[index].state == '9' ){
				stateflag = true;
			}
		}
		if(stateflag){
			alert("您选择的记录中存在'已提交'状态的数据，不能删除!");
			return;
		}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_mixinfo_form set bsflag='1' where device_mixinfo_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	function toSumbitPage(){
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
		//判断状态如果是已提交，那么不能修改
		var str = "select devapp.state from gms_device_mixinfo_form devapp ";
		str += "where devapp.bsflag = '0' and devapp.device_mixinfo_id in ("+selectedid+")";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var stateflag = false;
		for(var index = 0;index<unitRet.datas.length;index++){
			if(unitRet.datas[index].state == '9' ){
				stateflag = true;
			}
		}
		if(stateflag){
			alert("您选择的记录中状态为'已提交'!");
			return;
		}
		var devicemixinfoid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				devicemixinfoid = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devmixdetail/mixDetailSubmit.jsp?devicemixinfoid='+devicemixinfoid);
	}
    
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("selectedbox");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }
    function loadDataDetail(device_mixinfo_id){
    	var retObj;
		if(device_mixinfo_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getMixFormInfo", "device_mixinfo_id="+device_mixinfo_id);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getMixFormInfo", "device_mixinfo_id="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.devicedetailMap.device_mixinfo_id).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devicedetailMap.device_mixinfo_id+"']").removeAttr("checked");
		
		//给数据回填
		$("#project_name","#devdetailMap").val(retObj.devicedetailMap.project_name);
		$("#device_app_no","#devdetailMap").val(retObj.devicedetailMap.device_app_no);
		$("#device_app_name","#devdetailMap").val(retObj.devicedetailMap.device_app_name);
		$("#mixinfo_no","#devdetailMap").val(retObj.devicedetailMap.mixinfo_no);
		$("#in_org_name","#devdetailMap").val(retObj.devicedetailMap.in_org_name);
		$("#out_org_name","#devdetailMap").val(retObj.devicedetailMap.out_org_name);
		$("#print_emp_name","#devdetailMap").val(retObj.devicedetailMap.print_emp_name);
		$("#submit_date","#devdetailMap").val(retObj.devicedetailMap.submit_date);
		$("#state_desc","#devdetailMap").val(retObj.devicedetailMap.state_desc);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>