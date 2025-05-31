<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	//"8a9588b63618fc0d01361a93e0bf0018";
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
  <title>调剂计划申请</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">单位名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_org_name" name="s_org_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
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
			     <tr id='device_app_id_{device_mixapp_id}' name='device_mixapp_id'  idinfo='{device_mixapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_mixapp_id}'state = '{state}' id='selectedbox_{device_mixapp_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{device_app_name}">调配申请单名称</td>
					<td class="bt_info_even" exp="{device_mixapp_no}">调剂申请单号</td>
					<td class="bt_info_odd" exp="{device_mixapp_name}">调剂申请单名称</td>
					<td class="bt_info_even" exp="{org_abbreviation}">申请单位名称</td>
					<td class="bt_info_odd" exp="{mix_org_abbreviation}">调剂单位名称</td>
					<td class="bt_info_even" exp="{employee_name}">经办人</td>
					<td class="bt_info_odd" exp="{appdate}">申请时间</td>
					<td class="bt_info_even" exp="{s_state}">状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">项目名称：</td>
				      <td  class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">配置申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_allapp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;配置申请单号：</td>
				      <td  class="inquire_form6"  ><input id="device_allapp_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">调剂申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_app_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;调剂申请单号：</td>
				      <td  class="inquire_form6"  ><input id="device_app_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">申请单位名称：</td>
				      <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     </tr>
				    <tr >
				     <td  class="inquire_item6">&nbsp;申请人：</td>
				     <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="appdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">项目名称</td>
							<td class="bt_info_even">班组</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">规格型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">申请数量</td>
							<td class="bt_info_odd">申请人</td>
							<td class="bt_info_even">用途</td>
							<td class="bt_info_odd">计划开始时间</td>
							<td class="bt_info_even">计划结束时间</td>		
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
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
			}
		});
		if(index == 1){
			//动态查询明细
			
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
				str += "p6.name as jobname,pro.project_name,";
				str += "appdet.dev_name as dev_ci_name,";
				str += "appdet.dev_type as dev_ci_model, ";
				str += "appdet.apply_num,appdet.teamid,appdet.team, ";
				str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
				str += "appdet.plan_start_date,appdet.plan_end_date  ";
				str += "from gms_device_dismixapp_detail appdet ";
				str += "left join gms_device_dismixapp devapp on appdet.device_mixapp_id = devapp.device_mixapp_id ";
				str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
				str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
				str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
				str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
				str += "left join gms_device_codeinfo ci on appdet.dev_ci_code = ci.dev_ci_code ";
				str += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
				str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
				str += "where appdet.device_mixapp_id = '"+currentid+"' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].project_name+"</td><td>"+datas[i].teamname+"</td>";
			innerHTML += "<td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td><td>"+datas[i].unitname+"</td>";
			innerHTML += "<td>"+datas[i].apply_num+"</td><td>"+datas[i].employee_name+"</td><td>"+datas[i].purpose+"</td>";
			innerHTML += "<td>"+datas[i].plan_start_date+"</td><td>"+datas[i].plan_end_date+"</td>";
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
	var projectInfoNos = '<%=projectInfoNo%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	
    function refreshData(v_project_name,v_org_name){
		var str = "select mixorg.org_abbreviation as mix_org_abbreviation,t.device_mixapp_id,gp.project_name,app.device_app_no,app.device_app_name,t.device_mixapp_no,"
			+"t.device_mixapp_name,org.org_abbreviation,emp.employee_name, case t.state when '9'then '已提交'else'未提交'end as s_state,t.state ,t.appdate from gms_device_dismixapp t left "
			+"join gms_device_app app on t.device_app_id = app.device_app_id and app.bsflag='0' left join gp_task_project gp "
			+"on t.project_info_no=gp.project_info_no left join comm_org_information org on t.app_org_id = org.org_id "
			+"left join comm_org_subjection suborg on suborg.org_subjection_id=t.mix_org_id left join comm_org_information mixorg on mixorg.org_id=suborg.org_id "
			+"left join comm_human_employee emp on t.employee_id = emp.employee_id where t.project_info_no='"+projectInfoNos+"' and t.bsflag='0' ";
		/* 补充查询条件
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and ci.dev_ci_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and ci.dev_ci_model like '"+v_dev_ci_model+"%' ";
		}
		*/
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(device_app_id){
    	var retObj;
		if(device_app_id!=null){
			 retObj = jcdpCallService("DispensingDevSrv", "getDisAppBaseInfo", "deviceappid="+device_app_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DispensingDevSrv", "getDisAppBaseInfo", "deviceappid="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_mixapp_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_mixapp_id+"']").removeAttr("checked");
		//给数据回填
		$("#project_name","#projectMap").val(retObj.deviceappMap.project_name);
		$("#device_allapp_name","#projectMap").val(retObj.deviceappMap.device_app_name);
		$("#device_allapp_no","#projectMap").val(retObj.deviceappMap.device_app_no);
		$("#device_app_name","#projectMap").val(retObj.deviceappMap.device_mixapp_name);
		$("#device_app_no","#projectMap").val(retObj.deviceappMap.device_mixapp_no);
		$("#org_name","#projectMap").val(retObj.deviceappMap.org_abbreviation);
		$("#employee_name","#projectMap").val(retObj.deviceappMap.employee_name);
		$("#appdate","#projectMap").val(retObj.deviceappMap.appdate);
		var device_app_no = retObj.deviceappMap.device_app_no;
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    
	function toAdd(){
		
		window.location.href='<%=contextPath%>/rm/dm/devdis/disDevDetail.jsp?projectInfoNo=<%=projectInfoNo%>';
	}
	function toModify(){
		var length = 0;
		var selectedid = "";
		var state ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				state = this.state;
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}else if(length != 1 ){
			alert("请选择一条记录!");
			return;
		}
		//判断状态
		if(state==9){
			alert("数据已提交！");
			return;
			}
		var deviceappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				deviceappid = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devdis/disMixModifyApply.jsp?projectInfoNo=<%=projectInfoNo%>&deviceappid='+deviceappid,"900:680");
	}
	
	function toDelete(){
		var length = 0;
		var selectedid = "";
		var state ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				state = this.state;
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
		if(state==9){
			alert("数据已提交！");
			return;
			}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_dismixapp set bsflag='1' where device_mixapp_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	function toSubmit(){
		var length = 0;
		var selectedid = "";
		var state ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				state = this.state;
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
		if(state==9){
			alert("数据已提交！");
			return;
			}
		if(confirm("是否执行提交操作?")){
			var sql = "update gms_device_dismixapp set state='9' where device_mixapp_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
		}
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var v_project_name = document.getElementById("s_project_name").value;
			var v_org_name = document.getElementById("s_org_name").value;
			refreshData(v_project_name, v_org_name);
		}
	}
	
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		refreshData(v_project_name, v_org_name);
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

</script>
</html>