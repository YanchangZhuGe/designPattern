<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
	
	String orgId = user.getOrgId();
	
	String projectType="5000100004000000008";
	
	String projectInfoNo = user.getProjectInfoNo();
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
	//保存结果
	String message = null;
	if (respMsg != null && respMsg.getValue("message") != null) {
		message = respMsg.getValue("message");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/prototype.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
</head>
<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				    <td background="<%=contextPath%>/images/list_15.png">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">
						  	<tr>
						  	<td rowspan="6">&nbsp</td>
						   	<auth:ListButton functionId="" css="dk" event="onclick='toSon()'" title="子项目管理"></auth:ListButton>
						  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新建年度项目"></auth:ListButton>
						    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
						    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
						  	</tr>
						</table>
					</td>
				    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				  </tr>
				</table>
			</div>
			<div id="table_box">
			  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{project_name}' id='rdo_entity_id_{project_info_no}' onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
			      <td class="bt_info_even" exp="{project_target_money}">指标金额(万元)</td>
			      <td class="bt_info_odd" exp="{project_year}">年度</td>
			      <td class="bt_info_even" exp="{team_name}">施工队伍</td>
			      <td class="bt_info_odd" exp="{project_country}" func="getOpValue,projectCountry_view">国内/国外</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">审批流程</a></li>
			    <!-- <li id="tag3_5"><a href="#" onclick="getTab3(5)">队伍信息</a></li>
			    <li id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li> -->
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<form name="projectForm" id="projectForm"  method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6" id="item0_0">
					    <input type="hidden" id="project_info_no" name="project_info_no" /><input type="text" id="project_name" name="project_name" class="input_width" />
					    <input type="hidden" id="project_father_no" name="project_father_no" value="" class="input_width" />
					    </td>
					    <td class="inquire_item6">项目编号：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="project_id" name="project_id" class="input_width_no_color"  disabled="disabled" readOnly="readonly"/></td>
					    <td class="inquire_item6">项目类型：</td>
					    <td class="inquire_form6" id="item0_2">
					    	<code:codeSelect cssClass="select_width"  name='project_type' option="projectType"  selectedValue=""  addAll="true" />
					    </td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"><span class="red_star">*</span>指标金额：</td>
					    <td class="inquire_item6"><input id="project_target_money" name="project_target_money" value="" type="text" class="input_width" /><span>万元</span><input type="button" value="修改" onclick="changemoney()"/></td>
					    <td class="inquire_item6">市场范围：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
							<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /></td>
					    </td>
					    <td class="inquire_item6">年度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<select id="project_year" name="project_year" class="select_width">
						    <%
						    Date date = new Date();
						    int years = date.getYear()+ 1900 - 10;
						    int year = date.getYear()+1900;
						    for(int i=0; i<20; i++){
						    %>
						    <option value="<%=years %>" > <%=years %> </option>
						    <%
						    years++;
						    }
						     %>
						    </select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form6" id="item0_19">
							<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width" />
						</td>
					    <td class="inquire_item6">国内/国外：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<select class="select_width" name="project_country" id="project_country">
								<option value='1'>国内</option>
								<option value='2'>国外</option>
							</select>
					    </td>
					    
					  </tr>
					</table>
				</div>
				</form>
				
				<form id="QualificationForm" name="QualificationForm" action="" method="post" enctype="multipart/form-data">
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td><input id="qualification_no"  name="qualification_no" type="hidden" />
		                  <input type="hidden" id="oldZZ1" name="oldZZ1" value=""/>
		                  <input type="hidden" id="oldZZ2" name="oldZZ2" value=""/></td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateQualification()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	              	</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					  	<td class="inquire_item4"><span class="red_star">*</span>所属单位：</td>
					    <td class="inquire_form4"><input type="text" id="unit" name="unit" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item4"><span class="red_star">*</span>队号：</td>
					    <td class="inquire_form4"><input type="text" id="team_no" name="team_no" class="input_width" disabled="disabled"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item4">施工经验：</td>
					    <td class="inquire_form4" colspan="3" ><input type="textarea" id="experience" name="experience" cols="100" rows="5" class="textarea"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item4">资质：</td>
					    <td class="inquire_form4" colspan="2"><input type="file" name="zz1" id="zz1" class="input_width"/>
					    <div  id="td_zz1"></div></td>
					    <td class="inquire_form4">&nbsp;</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item4">资质核查：</td>
					    <td class="inquire_form4" colspan="2"><input type="file" name="zz2" id="zz2" class="input_width"/>
					    <div  id="td_zz2"></div></td>
					    <td class="inquire_item4">&nbsp;</td>
					  </tr>
					</table>
				</div>
				</form>
				<div id="tab_box_content9" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
				</div>
				<div id="tab_box_content10" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
				</div>
			</div>
		  </div>

</body>
<script type="text/javascript">

var projectCountry_view = new Array(['1','国内'],['2','国外']);

function frameSize(){
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "WsProjectSrv";
	cruConfig.queryOp = "queryProjects";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var orgId="<%=orgId %>";
	var message="<%=message%>";
	var projectType="<%=projectType%>"
	var businessType="5110000004100001003";
	var projectInfoNo = "<%=projectInfoNo%>"
	if (message != null&&"null"!=message) {
		alert("修改成功");
	}
	refreshData();

	function refreshData(){
		cruConfig.submitStr = "projectType="+projectType+"&orgSubjectionId="+orgSubjectionId+"&projectInfoNo="+projectInfoNo;
		queryData(1);
	}
	
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	function loadDataDetail(ids){
		if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		ids=ids.split("-")[0];
		clearLoadData();
		var projectYear = document.getElementById("project_year").value;
		var retObj = jcdpCallService("WsProjectSrv", "getProjectDetail", "projectInfoNo="+ids+"&orgSubjectionId="+orgSubjectionId+"&projectYear="+projectYear);
		
		processNecessaryInfo={
    		businessTableName:"gp_task_project",    //置入流程管控的业务表的主表表明
    		businessType:businessType,              //业务类型 即为之前设置的业务大类
    		businessId:ids,        				    //业务主表主键值
    		businessInfo:retObj.map.project_name+'井中项目立项审批',//用于待审批界面展示业务信息
    		applicantDate:'<%=appDate%>'            //流程发起时间
		};
		
		processAppendInfo={
   			projectInfoNo:ids,
   			action:'view',
   			projectName:retObj.map.project_name
	    };
		
		loadProcessHistoryInfo();
		
		document.getElementById("project_info_no").value=retObj.map.project_info_no;
		document.getElementById("project_father_no").value=retObj.map.project_father_no;
		document.getElementById("project_name").value=retObj.map.project_name;
		document.getElementById("project_id").value=retObj.map.project_id;
		//项目类型
		var sel = document.getElementById("project_type").options;
		var value = retObj.map.project_type;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_type').options[i].selected=true;
		    }
		}
		
		//项目状态
		/* sel = document.getElementById("project_status").options;
		value = retObj.map.project_status;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_status').options[i].selected=true;
		    }
		} */
		
		//国内 国外
		sel = document.getElementById("project_country").options;
		value = retObj.map.project_country;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_country').options[i].selected=true;
		    }
		}
		
		document.getElementById("market_classify").value= retObj.map.market_classify;
		document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
		document.getElementById("project_year").value= retObj.map.project_year;
		document.getElementById("org_id").value= retObj.dynamicMap.org_id;
		document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		document.getElementById("project_target_money").value= retObj.map.project_target_money;
		
		
		var qualification_no = retObj.dynamicMap.qualification_no;
		//document.getElementById("unit").value = retObj.teamMap.orgAbbreviation;
		//document.getElementById("team_no").value = retObj.dynamicMap.org_name;
		//队伍信息
		<%-- if(qualification_no != null && qualification_no != ""){
			var qualObj = jcdpCallService("WsProjectSrv", "getQualification","&qualificationNo="+qualification_no);
			document.getElementById("qualification_no").value = qualification_no;
			
			document.getElementById("experience").value = qualObj.qualMap.experience;
			
			if(qualObj.qualMap.ucm_id1!= null &&qualObj.qualMap.ucm_id1!= ""){
				document.getElementById("oldZZ1").value = qualObj.qualMap.ucm_id1;
				var vhtml1 = $("#td_zz1").html();
				
				if(vhtml1==null||vhtml1==""){
					$("#td_zz1").append("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+qualObj.qualMap.ucm_id1+"&emflag=0>"+qualObj.qualMap.file_name1+"</a>");
				}
				
			}
			if(qualObj.qualMap.ucm_id2 != null && qualObj.qualMap.ucm_id2 != ""){
				document.getElementById("oldZZ2").value = qualObj.qualMap.ucm_id2;
				var vhtml2 = $("#td_zz2").html();
				if(vhtml2==null||vhtml2==""){
					$("#td_zz2").append("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+qualObj.qualMap.ucm_id2+"&emflag=0>"+qualObj.qualMap.file_name2+"</a>")
				}
			}
		} --%>
		
		// 备注
		//document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	}
	
	//修改项目信息
	function toUpdateProject(){
		
		var project_info_no = document.getElementById("project_info_no").value;
		var submitStr='businessTableName=gp_task_project&businessType='+businessType+'&businessId='+project_info_no;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		if(procStatus=='3'||procStatus=='1'){
			alert("该项目已提交审批流程，无法修改");
			return ;
		}
		
		var str = "project_info_no="+document.getElementById("project_info_no").value;
		str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
		str += "&project_id="+document.getElementById("project_id").value;
		str += "&project_type="+document.getElementById("project_type").value;
		str += "&project_year="+document.getElementById("project_year").value;
		str += "&market_classify="+document.getElementById("market_classify").value;
		str += "&project_country="+document.getElementById("project_country").value;
		str += "&org_id="+document.getElementById("org_id").value;
		str += "&project_target_money="+document.getElementById("project_target_money").value;
		var obj = jcdpCallService("WsProjectSrv", "addProject", str);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		refreshData();
	}
	
	function toUpdateQualification(){
		var proj_no=document.getElementById("project_info_no").value;
		if(""==proj_no){
			alert("请先选择一条项目信息再保存");
			return;
		}
		if (!isTextPropertyNotNull("unit", "所属单位")) return false;	
		if (!isTextPropertyNotNull("team_no", "队号")) return false;	
		if (!isLimitB20("unit","所属单位")) return false;
		if (!isLimitB20("team_no","队号")) return false;
		if (!isLimitB20("experience","施工经验")) return false;

		var form = document.forms["QualificationForm"];
		form.action="<%=contextPath%>/pm/project/ws/saveQualification3.srq?project_info_no="+proj_no+"&action=edit&orgSubjectionId="+orgSubjectionId+"&orgId="+orgId+"&projectType="+projectType;
		form.submit();
	}
	
	
	function toDelete(){
		var project_info_no = document.getElementById("project_info_no").value;
		var submitStr='businessTableName=gp_task_project&businessType='+businessType+'&businessId='+project_info_no;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		/* if(procStatus=='3'||procStatus=='1'){
			alert("该项目已提交审批流程，无法删除");
			return ;
		} */
		
		
	    ids = getSelIds('rdo_entity_id');
	    var s=ids.split(",");
	    var str="";
	    for(var i=0;i<s.length;i++){
		    str+=s[i].split("-")[0];
		    if(i!=(s.length)-1) str+=",";
	    }
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){
			var retObj = jcdpCallService("WsProjectSrv", "deleteProject", "projectInfoNos="+str);
			refreshData();
		}
	}
	
	
	function selectMarketClassify(){
		var teamInfo = {
			fkValue:"",
			value:""
		};
		window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100500006',teamInfo);
		if(teamInfo.fkValue!=""){
			document.getElementById('market_classify').value = teamInfo.fkValue;
			document.getElementById('market_classify_name').value = teamInfo.value;
		}
	}
	
	function changemoney(){
		var str = "project_info_no="+document.getElementById("project_info_no").value;
		str += "&project_target_money="+document.getElementById("project_target_money").value;
		var obj = jcdpCallService("WsProjectSrv", "addProject", str);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		refreshData();
	}
	
	<%-- function selectTeam(){
		var teamInfo = {
			fkValue:"",
			value:""
		};
		window.showModalDialog('<%=contextPath%>/common/selectTeam.jsp',teamInfo);
		if(teamInfo.fkValue!=""){
			document.getElementById('org_id').value = teamInfo.fkValue;
			document.getElementById('org_name').value = teamInfo.value;
		}
	} --%>
	
	function clearLoadData(){
		document.getElementById("projectForm").reset();
		document.getElementById("QualificationForm").reset();
	}
	
	function toSubmit(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if (!window.confirm("确认要提交吗?")) {
			return;
		}		
		submitProcessInfo();
		refreshData();
	}
	
	
	function toSon(){
		var org_id_v = document.getElementById("org_id").value;
		var projectYear_v = document.getElementById("project_year").value;
		var project_info_no = document.getElementById("project_info_no").value;
		var submitStr='businessTableName=gp_task_project&businessType='+businessType+'&businessId='+project_info_no;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		if(procStatus!='3'){
			alert("项目未审批通过,请先进行年度项目审批!");
			return ;
		}
		
		ids = getSelIds('rdo_entity_id');
		if(""!=ids){
	    	if(ids.indexOf(",")==-1){
		    	var projectFatherName=encodeURI(encodeURI(ids.split("-")[1]));
	    		popWindow('<%=contextPath%>/pm/project/singleProject/ws/subProjectList.jsp?projectFatherName='+projectFatherName+'&projectFatherNo='+ids.split("-")[0]+'&orgSubjectionId='+orgSubjectionId+'&projectType='+projectType+'&orgId='+org_id_v+'&projectYear='+projectYear_v,'1300:720');
	    	}else{
	    		alert("只能选择一条项目信息！")
		    }
	 	}else{
			alert("请选择一条项目信息！");
		}
	}
	
 	function chooseOne(cb){
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){
            if (obj[i]!=cb){
            	obj[i].checked = false;
            }else {
            	obj[i].checked = true;
            }
        }
    }
	
 	function toAdd(){
		popWindow('<%=contextPath%>/pm/project/singleProject/ws/insertProject.jsp?projectType=5000100004000000008','750:700');
	}
 	
    $("#project_type").attr("disabled","disabled");
</script>

</html>