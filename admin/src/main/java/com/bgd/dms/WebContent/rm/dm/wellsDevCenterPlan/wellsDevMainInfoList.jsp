<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>多项目-井中设备分中心-设备申请</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_devapp_name" name="s_devapp_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_org_name" name="s_org_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">审批状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_state_desc" name="s_state_desc" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">未提交</option>
						<option value="1">待审核</option>
						<option value="3">审批通过</option>
						<option value="4">审批不通过</option>
			    	</select>
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddMainPlanPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyMainPlanPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelPlanPage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitDevApp()'" title="提交"></auth:ListButton>
			    <auth:ListButton functionId="" css="jl" event="onclick='toModifyDetail()'" title="编辑明细"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_allapp_id}' name='device_allapp_id' idinfo='{device_allapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_allapp_id}~{allapp_type}' id='selectedbox_{device_allapp_id}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{device_allapp_name}">申请单名称</td>
					<td class="bt_info_even" exp="{device_allapp_no}">申请单号</td>
					<td class="bt_info_even" exp="{org_name}">申请单位名称</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{appdate}">申请时间</td>
					<td class="bt_info_odd" exp="{approve_date}">审批时间</td>
					<td class="bt_info_even" exp="{state_desc}">审批状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">申请单名称：</td>
				      <td  class="inquire_form6"><input id="device_allapp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请单号：</td>
				      <td  class="inquire_form6"  ><input id="device_allapp_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">申请单位名称：</td>
				      <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     </tr>
				    <tr >				     
				     <td  class="inquire_item6">&nbsp;申请人：</td>
				     <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="appdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">&nbsp;审核时间：</td>
				     <td  class="inquire_form6"><input id="approvedate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">&nbsp;审批状态：</td>
				     <td  class="inquire_form6"><input id="state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table id="detailtitletable" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" style="margin-top:10px;background:#efefef;width:100%"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">申请数量</td>
							<td class="bt_info_odd">审批数量</td>
							<td class="bt_info_even">申请人</td>
							<td class="bt_info_odd">用途</td>
							<td class="bt_info_even">开始时间</td>
							<td class="bt_info_odd">结束时间</td>
				        </tr>				        
				        <tbody id="detailMap" name="detailMap" >
					   	</tbody>				   	 
					</table>
					<div style="height:70%;overflow:auto;">
				      	<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   		<tbody id="detailMap" name="detailMap" >
					   		</tbody>
				      	</table>
			        </div>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
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
			if(this.checked == true){
				currentid = this.value;
			}
		});
        var info = currentid.split("~" , -1); 
		
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select alldet.device_allapp_detid,sd.coding_name as unitname,teamsd.coding_name as teamname,";
				str += "alldet.dev_name as dev_ci_name,alldet.dev_type as dev_ci_model,";
				str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
				str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
				str += "alldet.plan_start_date,alldet.plan_end_date,'单台管理' as managetype,'0' as seqinfo ";
				str += "from gms_device_allapp_detail alldet ";
				str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
				str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
				str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
				str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
				str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
				str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where devapp.device_allapp_id = '"+info[0]+"' and alldet.bsflag='0' ";
				
				var param = new Object();
				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
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
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td><td>"+datas[i].unitname+"</td>";
			innerHTML += "<td>"+datas[i].apply_num+"</td><td>"+datas[i].approve_num+"</td><td>"+datas[i].employee_name+"</td><td>"+datas[i].purpose+"</td>";
			innerHTML += "<td>"+datas[i].plan_start_date+"</td><td>"+datas[i].plan_end_date+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	//调用此方法，可以实现上下两个table的方式实现表头固定和对齐，参考planMaininfoList.jsp的#detailtitletable和#detailMap
	function aligntitle(titletrid,filterobj){
		var titlecells = $("tr",titletrid)[0].cells;
		var contenttr = $("tr",filterobj)[0];
		if(contenttr==undefined)
			return;
		var contentcells = contenttr.cells
		for(var index=0;index<titlecells.length;index++){
			var widthinfo = contentcells[index].offsetWidth;
			if(widthinfo>0){
				titlecells[index].width = widthinfo+'px';
			}
		}
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectName = '<%=projectName%>';
	var projectType="<%=projectType%>";
	var projectCommon="<%=projectCommon%>";
	var dgFlag = 'Y';
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function clearQueryText(){
		$("#s_devapp_name").val("");
		$("#s_org_name").val("");
		$("#s_state_desc").val("");
	}
	function searchDevData(){
		var v_devapp_name = document.getElementById("s_devapp_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		var v_state_desc = document.getElementById("s_state_desc").value;
		refreshData(v_devapp_name, v_org_name, v_state_desc);
	}
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}

    function refreshData(v_devapp_name,v_org_name,v_state_desc){

		var str = "select wfmiddle.create_date as approve_date,pro.project_name,devapp.device_allapp_id,devapp.device_allapp_no,devapp.device_allapp_name,devapp.project_info_no,devapp.allapp_type,";
			str += "devapp.org_id,devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date, ";
			str += "case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc,";
			str += "org.org_abbreviation as org_name,emp.employee_name ";
			str += "from gms_device_allapp devapp  ";
	        str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id and wfmiddle.bsflag='0' ";
			str += "left join comm_org_information org on devapp.org_id = org.org_id  ";
			str += "left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
	        str += "left join gp_task_project pro on devapp.project_info_no=pro.project_info_no and pro.bsflag = '0' ";
			str += "where devapp.bsflag = '0' and devapp.allapp_type = 'S10002' ";		
			
		if(v_devapp_name!=undefined && v_devapp_name!=''){
			str += "and devapp.device_allapp_name like '%"+v_devapp_name+"%' ";
		}
		if(v_org_name!=undefined && v_org_name!=''){
			str += "and org.org_name like '%"+v_org_name+"%' ";
		}
		if(v_state_desc!=undefined && v_state_desc!=''){
			if(v_state_desc == '1'){//待审批
				str += "and wfmiddle.proc_status = '1' ";
			}else if(v_state_desc == '3'){//审批通过
				str += "and wfmiddle.proc_status = '3' ";
			}else if(v_state_desc == '4'){//审批不通过
				str += "and wfmiddle.proc_status = '4' ";
			}else{//未提交
				str += "and ((wfmiddle.proc_status != '1' and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '9') or wfmiddle.proc_status is null) ";
			}					
		}
		str += " order by wfmiddle.proc_status nulls first,devapp.appdate desc ";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(device_allapp_id){
        var info = device_allapp_id.split("~" , -1); 
        
    	var retObj;
		if(device_allapp_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAppBaseInfo", "deviceallappid="+info[0]);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    info = ids.split("~" , -1); 
		    
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAppBaseInfo", "deviceallappid="+info[0]);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_allapp_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_allapp_id+"']").removeAttr("checked");
		//给数据回填
		$("#project_name","#projectMap").val(retObj.deviceappMap.project_name);
		$("#device_allapp_name","#projectMap").val(retObj.deviceappMap.device_allapp_name);
		$("#device_allapp_no","#projectMap").val(retObj.deviceappMap.device_allapp_no);
		$("#state_desc","#projectMap").val(retObj.deviceappMap.state_desc);
		$("#org_name","#projectMap").val(retObj.deviceappMap.org_name);
		$("#employee_name","#projectMap").val(retObj.deviceappMap.employee_name);
		$("#appdate","#projectMap").val(retObj.deviceappMap.appdate);
		$("#createdate","#projectMap").val(retObj.deviceappMap.createdate);
		$("#approvedate","#projectMap").val(retObj.deviceappMap.approve_date);
		var device_allapp_name = retObj.deviceappMap.device_allapp_name;
		var device_allapp_no = retObj.deviceappMap.device_allapp_no;


		var businessType="5110000004100001092";
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
        processNecessaryInfo={        							//流程引擎关键信息
        			businessTableName:"gms_device_allapp",    			//置入流程管控的业务表的主表表明
        			businessType:businessType,    //业务类型 即为之前设置的业务大类
        			businessId:info[0],           				//业务主表主键值
        			businessInfo:"井中设备分中心审批列表信息<配置计划单名称:"+device_allapp_name+">",
        			applicantDate:submitdate       						//流程发起时间
        		};

		processAppendInfo={ 
			projectName:projectName,								//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			deviceallappid:info[0]
		};
    	loadProcessHistoryInfo();
    }
	function toAddMainPlanPage(){
		if('<%=projectInfoNo%>' == 'null'){
			alert("未选择项目信息!");
			return;
		}
		
		popWindow('<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_new.jsp?');
	}
	function toModifyMainPlanPage(){
		var length = 0;
		var deviceallappid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				deviceallappid = this.value;
				length = length+1;
			}
		});
		
		if(length == 0){
			alert("请选择记录！");
			return;
		}
	      var info = deviceallappid.split("~" , -1); 
		//判断状态如果是已提交，那么不能修改
		var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status ,devapp.allapp_type ";
			str += "from gms_device_allapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
			str += "where devapp.allapp_type = 'S10002' and devapp.bsflag = '0' ";
			str += "and devapp.device_allapp_id='"+info[0]+"' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//只要不在流程中，都可以修改
		var atype = unitRet.datas[0].allapp_type
		if(unitRet.datas[0].proc_status == '' ){
			popWindow('<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevmain_modify.jsp?deviceallappid='+info[0]);
		}else{
			alert("本单据已提交，不能修改!");
			return;
		}
	}
	function toDelPlanPage(){
		var length = 0;
		var deviceallappid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				deviceallappid = this.value;
				length = length+1;
			}
		});
			
		if(length == 0){
			alert("请选择记录！");
			return;
		}
	      var info = deviceallappid.split("~" , -1); 
			
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_allapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.allapp_type = 'S10002' ";
			str += "and devapp.device_allapp_id='"+info[0]+"' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除
		if(unitRet.datas[0].proc_status == null||unitRet.datas[0].proc_status == ''||unitRet.datas[0].proc_status == '4'){
			if(confirm("是否执行删除操作?")){
				var sql = "update gms_device_allapp set bsflag='1' where device_allapp_id = '"+info[0]+"' ";
				var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
				var params = "deleteSql="+sql;
				params += "&ids=";
				var retObject = syncRequest('Post',path,params);
				refreshData();
			}
		}else{
			alert("本单据已提交，不能删除!");
			return;
		}
	}
	function toSumbitDevApp(){
		var length = 0;
		var deviceallappid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				deviceallappid = this.value;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
	      var info = deviceallappid.split("~" , -1); 
			
		//判断状态如果是已提交
		var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status,devapp.state ";
			str += "from gms_device_allapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.allapp_type = 'S10002' ";
			str += "and devapp.device_allapp_id='"+info[0]+"' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除，和业务专家确定
		if(unitRet.datas[0].state == null || unitRet.datas[0].proc_status == '' || unitRet.datas[0].proc_status == '4'){
			//判断主记录中是否有明细
			var querySql = "select count(1) as subcount ";
			querySql += "from (select device_allapp_detid from gms_device_allapp_detail appdet where appdet.device_allapp_id ='"+info[0]+"' ) ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			if(basedatas[0].subcount==0){
				alert("您提交的记录没有添加明细,请查看!");
				return;
			}
			if (!window.confirm("确认要提交吗?")) {
				return;
			}
			retObj = jcdpCallService("DevCommInfoSrv", "createAppGetAllappSS", "device_allapp_id="+info[0]);
			submitProcessInfo();
			refreshData();
			alert('提交成功！');
		}else{
			alert("单据已提交，不能重复提交!");
			return;
		}
	}
	
	function toModifyDetail(obj){
		var idinfo = null;
		if(obj!=undefined){
			idinfo = obj.idinfo;
		}else{
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked == true){
					idinfo = this.value;
				}
			});
		}
	      var info = idinfo.split("~" , -1); 

		//window.location.href='<%=contextPath%>/rm/dm/devPlan/devplan_app_frame.jsp?projectInfoNo=<%=projectInfoNo%>&allappType='+info[1]+'&deviceallappid='+info[0]+'&dgFlag='+dgFlag;
		window.location.href='<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_main.jsp?deviceallappid='+info[0];	
	}
	
	function dbclickRow(shuaId){
	      var info = shuaId.split("~" , -1); 

		window.location.href='<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_main.jsp?deviceallappid='+info[0];
	}  

</script>
</html>