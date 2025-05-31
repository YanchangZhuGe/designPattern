<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo() == null ? "" : user.getProjectInfoNo();
    String subOrgId = user.getSubOrgIDofAffordOrg();
    String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String projectCommon = user.getProjectCommon();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>单项目-设备台账查询-设备台账查询(批量)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">采集设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{device_id}' id='rdo_entity_id_{device_id}'/>" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_odd" exp="{type_name}">地震仪器类型</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">在队数量</td>
					<td class="bt_info_odd" exp="{use_num}">离队数量</td>
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
			     <li id="tag3_6" ><a href="#" onclick="getContentTab(this,6)">入库明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">出库单号</a></li>
				<li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">返还单号</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				<li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			
		
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">采集设备名称</td>
						    <td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备型号</td>
						    <td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备类型</td>
						    <td class="inquire_form6"><input id="type_name" name="type_name" class="input_width" type="text" /></td>
						 </tr>
						  <tr>
						    <td class="inquire_item6">总数量</td>
						    <td class="inquire_form6"><input id="total_num" name="total_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">在队数量</td>
						    <td class="inquire_form6"><input id="unuse_num" name="unuse_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">离队数量</td>
						    <td class="inquire_form6"><input id="use_num" name="use_num" class="input_width" type="text" /></td>
						  </tr>
						   <tr>
						  	<td class="inquire_item6">转入单位</td>
						    <td class="inquire_form6"><input id="in_org_id" name="in_org_id" class="input_width" type="text" /></td>
						    <td class="inquire_item6">计量单位</td>
						    <td class="inquire_form6"><input id="dev_unit" name="dev_unit" class="input_width" type="text" /></td>
						  </tr>
			        </table>
				</div>
			
				<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none;">
						<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
				    		<td class="bt_info_even">序号</td>
						    <td class="bt_info_odd">采集设备名称</td>
						    <td class="bt_info_even">采集设备型号</td>
						    <td class="bt_info_odd">采集设备类型</td>
						    <td class="bt_info_even">转入单位</td>
						    <td class="bt_info_odd">转出单位</td>
						    <td class="bt_info_even">是否离场</td>
						    <td class="bt_info_odd">总数量</td>
						    <td class="bt_info_even">在队数量</td>
						    <td class="bt_info_odd">离队数量</td>
						    <td class="bt_info_even">实际进场时间</td>
						    <td class="bt_info_odd">实际离场时间</td>
						 </tr>
						 <tbody id="assign_body"></tbody>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="outMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
				    		<td class="bt_info_even">序号</td>
						    <td class="bt_info_odd">出库单号</td>
						 </tr>
						 <tbody id="assign_body"></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
					<table id="inMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
				    		<td class="bt_info_even">序号</td>
						    <td class="bt_info_odd">返还单号</td>
						 </tr>
						 <tbody id="assign_body"></tbody>
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
<script>
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
function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid+"&sonFlag="+sonFlag);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid+"&sonFlag="+sonFlag);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
$(document).ready(lashen);
</script>
 
<script>
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var subOrgId = '<%=subOrgId%>';
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
		var v_dev_name = document.getElementById("s_dev_name").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    }
	//点击树节点查询
	function refreshData(arrObj){
		var str = "select t.dev_name,t.dev_model,t.device_id, "
				+ "sum(t.total_num) as total_num, sum(t.unuse_num) as unuse_num,sum(t.use_num) as use_num, "
				+ "(select p1.dev_name from gms_device_collectinfo p, gms_device_collectinfo p1 where p.device_id = t.device_id " 
				+ "and p1.device_id = p.node_parent_id) as type_name from gms_device_coll_account_dui t ";

		//井中地震 
		if(projectType == "5000100004000000008" && retFatherNo.length >= 1){//子项目			
			str += "where nvl(t.bsflag,0) !='N' and t.project_info_id='" +retFatherNo+"' ";
		}else{
			str += "where nvl(t.bsflag,0) !='N' and t.project_info_id='"+projectInfoNos+"' ";
		}
						
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				switch(arrObj[key].label){
					case "type_name":
						str += " and exists (select 1  from gms_device_collectinfo c where c.device_id = '"+arrobj[key].value+"' and c.device_id = t.device_id) ";
						break;
					case "actual_out_time":
					case "actual_in_time":
					case "planning_out_time":
					case "planning_in_time":
						str += " and (concat("+arrObj[key].label+",'') like '%"+arrObj[key].value+"%' or concat("+arrObj[key].label+",'') like '%"+getDateForOracle(arrObj[key].value)+"%')";
						break;
					default :
						str += " and concat("+arrObj[key].label+",'') like '%"+arrObj[key].value+"%'";				
				}
			}
		}
		str += " group by t.dev_name, t.dev_model, t.device_id  order by t.dev_model  ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
    function loadDataDetail(shuaId){
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
    	
    	if(shuaId!=null){
			var querySql = "select * from ( select (select coding_name from comm_coding_sort_detail c where t.dev_unit=c.coding_code_id) as unit_name,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.in_org_id=org.org_id) as in_org_name_desc,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.out_org_id=org.org_id) as out_org_name_desc,";
		    querySql += "(select project_name from gp_task_project gp where gp.project_info_no=t.project_info_id) as pro_name,";
		    querySql += "t.*,case t.is_leaving when '0' then '未离场' when '1' then '已离场' else '' end as leaving_desc ,";
		    querySql += "(select p1.dev_name from gms_device_collectinfo p, gms_device_collectinfo p1 where p.device_id = t.device_id and p1.device_id = p.node_parent_id) as type_name ";
		    querySql += "from gms_device_coll_account_dui t ";
		    querySql += "where t.device_id= '"+shuaId+"' ) where rownum=1";
			var queryRet = syncRequest('Post','/gms4'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql = "select * from ( select (select coding_name from comm_coding_sort_detail c where t.dev_unit=c.coding_code_id) as unit_name,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.in_org_id=org.org_id) as in_org_name_desc,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.out_org_id=org.org_id) as out_org_name_desc,";
		    querySql += "(select project_name from gp_task_project gp where gp.project_info_no=t.project_info_id) as pro_name,";
		    querySql += "t.*,case t.is_leaving when '0' then '未离场' when '1' then '已离场' else '' end as leaving_desc ";
		    querySql += "(select p1.dev_name from gms_device_collectinfo p, gms_device_collectinfo p1 where p.device_id = t.device_id and p1.device_id = p.node_parent_id) as type_name ";
		    querySql += "from gms_device_coll_account_dui t where device_id= '"+ids+"' ) where rownum=1 "  ;
			var queryRet = syncRequest('Post','/gms4'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		}
		if(retObj!=undefined && retObj.length>0){
			document.getElementById("dev_name").value =retObj[0].dev_name;
			document.getElementById("dev_model").value =retObj[0].dev_model;
			//document.getElementById("type_name").value =retObj[0].self_num;
			document.getElementById("in_org_id").value =retObj[0].in_org_name_desc;			
			document.getElementById("total_num").value =retObj[0].total_num;
			document.getElementById("unuse_num").value =retObj[0].unuse_num;
			document.getElementById("use_num").value =retObj[0].use_num;
			document.getElementById("dev_unit").value =retObj[0].unit_name;			
			document.getElementById("type_name").value =retObj[0].type_name;			
		}
    	
		if(shuaId!=null){
			var querySql = "select (select coding_name from comm_coding_sort_detail c where t.dev_unit=c.coding_code_id) as unit_name,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.in_org_id=org.org_id) as in_org_name_desc,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.out_org_id=org.org_id) as out_org_name_desc,";
		    querySql += "(select project_name from gp_task_project gp where gp.project_info_no=t.project_info_id) as pro_name,";
		    querySql += "t.*,case t.is_leaving when '0' then '未离场' when '1' then '已离场' else '' end as leaving_desc ,";
		    querySql += "(select p1.dev_name from gms_device_collectinfo p, gms_device_collectinfo p1 where p.device_id = t.device_id and p1.device_id = p.node_parent_id) as type_name ";
		    querySql += "from gms_device_coll_account_dui t ";
		    querySql += "where t.device_id= '"+shuaId+"' and t.project_info_id='"+projectInfoNos+"' order by t.actual_out_time ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql = "select (select coding_name from comm_coding_sort_detail c where t.dev_unit=c.coding_code_id) as unit_name,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.in_org_id=org.org_id) as in_org_name_desc,";
		    querySql += "(select org_abbreviation from comm_org_information org where t.out_org_id=org.org_id) as out_org_name_desc,";
		    querySql += "(select project_name from gp_task_project gp where gp.project_info_no=t.project_info_id) as pro_name,";
		    querySql += "t.*,case t.is_leaving when '0' then '未离场' when '1' then '已离场' else '' end as leaving_desc ";
		    querySql += "(select p1.dev_name from gms_device_collectinfo p, gms_device_collectinfo p1 where p.device_id = t.device_id and p1.device_id = p.node_parent_id) as type_name ";
		    querySql += "from gms_device_coll_account_dui t where device_id= '"+ids+"' and t.project_info_id='"+projectInfoNos+"' order by t.actual_out_time "  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		}
		if(retObj!=undefined && retObj.length>0){
			
			var size = $("#assign_body", "#tab_box_content6").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content6").children("tr").remove();
			}
			var by_body1 = $("#assign_body", "#tab_box_content6")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var newTr = by_body1.insertRow();
					
					var newTd = newTr.insertCell();
					newTd.innerText = i+1;
					var newTd1 = newTr.insertCell();
					newTd1.innerText = retObj[i].dev_name;
					var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].dev_model;
					var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].type_name;
					var newTd4 = newTr.insertCell();
					newTd4.innerText = retObj[i].in_org_name_desc;
					var newTd5 = newTr.insertCell();
					newTd5.innerText = retObj[i].out_org_name_desc;
					var newTd6 = newTr.insertCell();
					newTd6.innerText = retObj[i].leaving_desc;
					var newTd7 = newTr.insertCell();
					newTd7.innerText = retObj[i].total_num;
					var newTd8 = newTr.insertCell();
					newTd8.innerText = retObj[i].unuse_num;
					var newTd9 = newTr.insertCell();
					newTd9.innerText = retObj[i].use_num;
					var newTd10 = newTr.insertCell();
					newTd10.innerText = retObj[i].actual_in_time;
					var newTd11 = newTr.insertCell();
					newTd11.innerText = retObj[i].actual_out_time;
					
				}
			}
			$("#assign_body>tr:odd>td:odd",'#tab_box_content6').addClass("odd_odd");
			$("#assign_body>tr:odd>td:even",'#tab_box_content6').addClass("odd_even");
			$("#assign_body>tr:even>td:odd",'#tab_box_content6').addClass("even_odd");
			$("#assign_body>tr:even>td:even",'#tab_box_content6').addClass("even_even");
			
		}
		//出库单号
		var querySql="select outform.outinfo_no "+
			"from gms_device_coll_account_dui t "+
			"left join gms_device_coll_outsub outsub on outsub.device_id=t.device_id "+
			"left join gms_device_coll_outform outform on outform.device_outinfo_id=outsub.device_outinfo_id "+
			"where t.device_id='"+shuaId+"' and outform.bsflag='0' and outform.device_mixinfo_id is not null "+
			"and outform.project_info_no=t.project_info_id ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content1").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var newTr = by_body1.insertRow();
				
				var newTd = newTr.insertCell();
				newTd.innerText = i+1;
				var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].outinfo_no;
				
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
		
		//返还单号
		var querySql="select backform.device_backapp_no "+
		"from gms_device_coll_account_dui t "+
		"left join gms_device_collbackapp_detail backsub on backsub.dev_acc_id=t.dev_acc_id "+
		"left join gms_device_collbackapp backform on backform.device_backapp_id=backsub.device_backapp_id "+
		"where t.device_id= '"+shuaId+"' and backform.bsflag='0' and backform.device_backapp_no is not null and backform.project_info_id=t.project_info_id";
		
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content2").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content2").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content2")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var newTr = by_body1.insertRow();
				
				var newTd = newTr.insertCell();
				newTd.innerText = i+1;
				var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].device_backapp_no;
				
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content2').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content2').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content2').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content2').addClass("even_even");
			
	 }
	        
	 function newSearch(){
	    popWindow('<%=contextPath%>/rm/dm/collectdevice-xd/devquery.jsp');
	 }
	 function getDateForOracle(date){
	    var strs = date.split("-");
	    return strs[2]+"-"+parseInt(strs[1],10)+"月 -"+strs[0].substr(strs[0].length-2);
	 }   	
</script>
</html>