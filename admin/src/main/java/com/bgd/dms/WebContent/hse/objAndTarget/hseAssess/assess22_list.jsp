<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);
	
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2002; i--) {
		listYear.add(i);
	}
	
	String  project = request.getParameter("project");
	if(project==null||project.equals("")){
		project = resultMsg.getValue("project");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_assess_id}' id='rdo_entity_id_{hse_assess_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">二级单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{assess_cycle}">考核期</td>
			      <td class="bt_info_odd" exp="{user_name}">考核人</td>
			      <td class="bt_info_even" exp="{employee_name}">被考核人</td>
			      <td class="bt_info_odd" exp="{assess_status}">审批状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">审批信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_assess_id" name="hse_assess_id"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                </tr>
	             	 </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						  <tr>
				     	<td class="inquire_item6">单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
				      	<input type="text" id="second_org2" name="second_org2" class="input_width" readonly="readonly"/>
				      	</td>
				     	<td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width" readonly="readonly"/>
				      	</td>
				      	<td class="inquire_item6">下属单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
				      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width" readonly="readonly"/>
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item6">考核期：</td>
				      	<td class="inquire_form6">
					      	<select id="year" name="year" class="select_width" disabled="disabled">
						       	<option value="" >请选择</option>
								<%for(int j=0;j<listYear.size();j++){%>
								<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
								<% } %>
							</select>年
				      	</td>
				     	<td class="inquire_item6">季度：</td>
				      	<td class="inquire_form6">
				      		<select id="quarter" name="quarter" class="select_width" onclick="selectQuarter()" disabled="disabled">
					          <option value="" >请选择</option>
					          <option value="1" >第一季度</option>
					          <option value="4" >第二季度</option>
					          <option value="7" >第三季度</option>
					          <option value="10">第四季度</option>
						    </select>
				      	</td>
				    	<td class="inquire_item6">月份：</td>
				      	<td class="inquire_form6">
					      	<select id="month" name="month" class="select_width" onclick="selectMonth()" disabled="disabled">
						       	<option value="" >请选择</option>
								<%for(int j=1;j<13;j++){%>
								<option value="<%=j %>"><%=j %></option>
								<% } %>
							</select>
				      	</td>
				     </tr>
				     <tr>
				     	<td class="inquire_item6"><font color="red">*</font>被考核人：</td>
				      	<td class="inquire_form6">
							<input type="hidden" id="assess_person_id" name="assess_person_id" class="input_width"  value=""/>
					      	<input type="text" id="assess_name" name="assess_name" class="input_width"  value="" readonly="readonly"/>
				      	</td>
					    <td class="inquire_item6"><font color="red">*</font>考核日期：</td>
					    <td class="inquire_form6"><input type="text" id="assess_date" name="assess_date" class="input_width" value="" readonly="readonly"/>
					    </td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="assessInfoTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
						  	<td class="bt_info_even">考核人</td>
							<td class="bt_info_odd">签字时间</td>
							<td class="bt_info_even">被考核人</td>
							<td class="bt_info_odd">签字时间</td>
							<td class="bt_info_even">上级主管</td>
							<td class="bt_info_odd">签字时间</td>
							<td class="bt_info_even">审批状态</td>
						</tr>
					</table>
				</div>
				</form>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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
	
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select ha.hse_assess_id,case when ha.type=1 then ha.year||'年'||decode(ha.quarter_month,'1','第一季度','4','第二季度','7','第三季度','10','第四季度') when ha.type=2 then ha.year||'年'||ha.quarter_month||'月'  else ha.year || '年'  end assess_cycle,ha.assess_name,ee.employee_name,au.user_name,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_assess ha left join comm_org_subjection os1 on ha.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ha.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on ha.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' left join p_auth_user au2 on ee.employee_id=au2.emp_id and au2.bsflag='0' where ha.bsflag='0' and au2.user_id='<%=user.getUserId()%>'  and ha.assess_status <> '0'  order by ha.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/assess22_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/assess22_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var eventName = document.getElementById("eventName").value;
				if(eventName!=''&&eventName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select ha.hse_assess_id,case when ha.type=1 then ha.year||'年'||decode(ha.quarter_month,'1','第一季度','4','第二季度','7','第三季度','10','第四季度') when ha.type=2 then ha.year||'年'||ha.quarter_month||'月' end assess_cycle,ha.assess_name,ee.employee_name,au.user_name,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_assess ha left join comm_org_subjection os1 on ha.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ha.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on ha.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' left join p_auth_user au2 on ee.employee_id=au2.emp_id and au2.bsflag='0' where ha.bsflag='0' and au2.user_id='<%=user.getUserId()%>'  and ha.assess_status <> '0'  order by ha.modifi_date desc ";
					cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/assess22_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function showHuman(){
		var project = "<%=project%>";
		var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		if(project=="1"){
	    	window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select=employeeId',teamInfo);
	    }else if(project=="2"){
	    	window.showModalDialog('<%=contextPath%>/hse/humanResource/humanOfProject_tree.jsp',teamInfo);
	    }
		document.getElementById("assess_person_id").value = teamInfo.fkValue;
		document.getElementById("assess_name").value = teamInfo.value;
	}
	
	function clearQueryText(){
		document.getElementById("eventName").value = "";
	}
	
	 function selectQuarter(){
		 var month = document.getElementById("month").value;
		 if(month!=""){
			 alert("季度和月份只能选择其一");
		 }
	 }
	 
	 function selectMonth(){
		 var quarter = document.getElementById("quarter").value;
		 if(quarter!=""){
			 alert("季度和月份只能选择其一");
		 }
	 }
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "queryAssess", "hse_assess_id="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryAssess", "hse_assess_id="+ids);
		}
		document.getElementById("hse_assess_id").value =retObj.map.hseAssessId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("fourth_org").value =retObj.map.fourthOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.map.fourthOrgName;
		
		document.getElementById("year").value =retObj.map.year;
		if(retObj.map.type=="1"){
			document.getElementById("quarter").value = retObj.map.quarterMonth;
			document.getElementById("month").value = "";
		}else if(retObj.map.type=="2"){
			document.getElementById("month").value = retObj.map.quarterMonth;
			document.getElementById("quarter").value = "";
		}
		document.getElementById("assess_person_id").value = retObj.map.assessName;
		document.getElementById("assess_name").value = retObj.map.employeeName;
		document.getElementById("assess_date").value = retObj.map.assessDate;
		showDatas(retObj.map.hseAssessId);
	}
	
	function showDatas(hse_assess_id){
		
		for(var j =1;j <document.getElementById("assessInfoTable")!=null && j < document.getElementById("assessInfoTable").rows.length ;){
			document.getElementById("assessInfoTable").deleteRow(j);
		}
		
		var checkSql="select ha.hse_assess_id,ha.leader_sign,au.user_name,ha.leader_date,ee.employee_name,assess_sign,sign_date,superior_sign,superior_date,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status from bgp_hse_assess ha left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ha.modifi_date desc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas!=null&&datas!=""){
			var hse_assess_id = datas[0].hse_assess_id;
			var leader_sign = datas[0].user_name;
			var leader_date = datas[0].leader_date;
			var employee_name = datas[0].employee_name;
			var sign_date = datas[0].sign_date;
			var superior_sign = datas[0].superior_sign;
			var superior_date = datas[0].superior_date;
			var assess_status = datas[0].assess_status;
			var autoOrder = document.getElementById("assessInfoTable").rows.length;
			var newTR = document.getElementById("assessInfoTable").insertRow(autoOrder);
			var tdClass = 'even';
			if(autoOrder%2==0){
				tdClass = 'odd';
			}
		    var td = newTR.insertCell(0);
		
		    td.innerHTML = leader_sign;
		    td.className = tdClass+'_odd';
		    if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
		    
		    td = newTR.insertCell(1);
		    td.innerHTML = leader_date;
		    td.className =tdClass+'_even'
		    if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
		    
		    td = newTR.insertCell(2);
		    td.innerHTML = employee_name;
		    td.className = tdClass+'_odd';
		    if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
		    
		    td = newTR.insertCell(3);
		    td.innerHTML = sign_date;
		    td.className =tdClass+'_even'
		    if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
		    
			td = newTR.insertCell(4);
		    td.innerHTML = superior_sign;
		    td.className =tdClass+'_odd'
		    if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
		    
			td = newTR.insertCell(5);
			td.innerHTML = superior_date;
		    td.className = tdClass+'_even';
		    if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
		    
		    td = newTR.insertCell(6);
		    td.innerHTML = assess_status;
		    td.className =tdClass+'_odd'
		    if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
		}
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function dbclickRow(shuaId){
		var retObj;
		if(shuaId!=null){
			popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addAssess22.jsp?hse_assess_id="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
			popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addAssess22.jsp?hse_assess_id="+ids);
		}
	}
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addAssess.jsp?action=add");
		
	}
	
	function toEdit(){  
		var hse_assess_id = document.getElementById("hse_assess_id").value;
	  	if(hse_assess_id==''||hse_assess_id==null){  
	  		alert("请先选择一条记录!");  
	  		return;  
	  	}  
	  	var checkSql="select ha.hse_assess_id,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status from bgp_hse_assess ha where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ha.modifi_date desc ";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas!=null&&datas!=""){
			var assessType = datas[0].assess_status;		
			if(assessType=="未提交"){
			  	popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addAssess.jsp?action=edit&&hse_assess_id="+hse_assess_id);
			}else{
				alert("该记录"+assessType+"，不能修改！");
			}
		}
	} 
	
	function toSubmit(){
	    var hse_assess_id = document.getElementById("hse_assess_id").value;
	  	if(hse_assess_id==''||hse_assess_id==null){  
	  		alert("请先选择一条记录!");  
	  		return;  
	  	}  
	  	
	  	var checkSql="select ha.hse_assess_id,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status from bgp_hse_assess ha where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ha.modifi_date desc ";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas!=null&&datas!=""){
			var assessType = datas[0].assess_status;		
			if(assessType=="未提交"){
				var sql = "update bgp_hse_assess set assess_status='1' where  bsflag='0' and hse_assess_id='"+hse_assess_id+"'";
				if (!window.confirm("确认要提交吗?")) {
					return;
				}
				var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
				var params = "sql="+sql;
				params += "&ids="+hse_assess_id;
				var retObject = syncRequest('Post',path,params);
				if(retObject.returnCode!=0) alert(retObject.returnMsg);
				else queryData(cruConfig.currentPage);
				
			}else{
				alert("该记录"+assessType+"，不能提交！");
			}
		}
	}
	

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var temp = ids.split(',');
	    for(var i=0;i<temp.length;i++){
		    var checkSql="select ha.hse_assess_id,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status from bgp_hse_assess ha where ha.bsflag='0' and ha.hse_assess_id='"+temp[i]+"' order by ha.modifi_date desc ";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				var assessType = datas[0].assess_status;		
				if(assessType=="未提交"){
					
				}else{
					alert("该记录"+assessType+"，不能删除！");
					return;
				}
			}
	    }
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteAssess", "hse_assess_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/event/event_search.jsp");
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}
	
	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
	
</script>

</html>

