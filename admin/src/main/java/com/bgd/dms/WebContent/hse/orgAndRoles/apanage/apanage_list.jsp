<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null){
		project_info_no = "";
	}
	String org_subjection_id = user.getOrgSubjectionId();
	if(org_subjection_id == null){
		org_subjection_id = "";
	}
	String org_name = user.getOrgName();
	if(org_name ==null){
		org_name ="";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	
	
	boolean editMultiple = JcdpMVCUtil.hasPermission("F_HSE_APANAGE_001", request);
	boolean editSingle = JcdpMVCUtil.hasPermission("F_HSE_APANAGE_002", request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<body style="background:#fff"  onload="refreshData('');">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						    <td>&nbsp;</td>
						    <auth:ListButton functionId="F_HSE_APANAGE_M_001,F_HSE_APANAGE_S_001" css="sz" event="onclick='toSetting()'" title="JCDP_btn_setting"></auth:ListButton>
						    <auth:ListButton id="aaa" functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="bc" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
					  	</tr>
					</table>
				</td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
			<table id="apanage"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
				<tr>
					<td colspan="7" align="center"><font size="5"><strong >属地划分统计</strong></font></td>
				</tr>
				<tr>
					<td align="center"><strong >序号</strong></td>
					<td align="center"><strong >单位(<span ><a href='#' onclick=refreshData('<%=org_subjection_id %>')><font color="blue"><%=org_name %></font></a></span>)</strong></td>
					<td align="center"><strong >类型</strong></td>
					<td align="center"><strong >合计</strong></td>
					<td align="center"><font color="red">*</font><strong >人员</strong></td>
					<td align="center"><font color="red">*</font><strong >设备</strong></td>
					<td align="center"><font color="red">*</font><strong >危险点源</strong></td>
				</tr>
				<!-- <tr>
					<td align="center"></td>
					<td align="center"><strong >合计</strong></td>
					<td align="center"></td>
					<td align="center"><span id="num"></span></td>
					<td align="center"><span id="human"></span></td>
					<td align="center"><span id="equipment"></span></td>
					<td align="center"><span id="danger"></span></td>
				</tr> -->
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.pageSize = 1000;
var subjection_id ='';
//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
		
	}
	var rowSpan = '1';
	// 复杂查询
	function refreshData(org_subjection_id){
		var retObj = jcdpCallService("HseSrv", "queryOrg", "org_subjection_id="+org_subjection_id);
		if(retObj.returnCode =='0'){
				debugger;
			if(retObj.list!=null){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag=="0"){
						org_subjection_id = "C105";
						document.getElementById("aaa").style.display="none";
					}else{
						if(len>1){
							if(retObj.list[1].organFlag=="0"){
								org_subjection_id = retObj.list[0].orgSubId;
							}else{
								if(len>2){
									if(retObj.list[2].organFlag=="0"){
//										org_subjection_id = retObj.list[1].orgSubId;   //只到基层单位，不要下属单位了
									}
								}
							}
						}
					}
				}
				
				if(len>3){
					return;
				}
			}else{
				document.getElementById("aaa").style.display="none";
			}
		}
		subjection_id = org_subjection_id;
		if(subjection_id == null || subjection_id ==''){
			subjection_id = '<%=org_subjection_id%>';
		}else{
			var autoOrder = document.getElementById("apanage").rows.length;
			for(var i =autoOrder-1 ;i>= 2 ;i--){
				document.getElementById("apanage").deleteRow(i);
			}
		}
		cruConfig.cdtType = 'form';
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/orgAndRoles/apanage/apanage_list.jsp";
		var queryRet = jcdpCallService("HseOperationSrv", "getApanageList", "subjection_id="+subjection_id);
		if(queryRet.returnCode =='0'){
			if(queryRet.datas!=null){
				for(var i =0 ;i<queryRet.datas.length ;i++){
					var data = queryRet.datas[i];
					var id = data.apanage_id;
					var name = data.org_name;
					var flow_sum = data.flow_sum;
					if(flow_sum!=null && flow_sum!='' && flow_sum!='0' && name.indexOf('队')==-1){
						var org_id = data.org_id;
					    var org_subjection_id = data.org_subjection_id;
					    rowSpan = '2';
					    var org_name = data.org_name;
					    var apanage_id = data.apanage_id;
						var autoOrder = document.getElementById("apanage").rows.length;
						
						var newTR = document.getElementById("apanage").insertRow(autoOrder);
					    var td = newTR.insertCell(0);
					    td.innerHTML = data.rownum;
					    td.rowSpan = rowSpan;
					    td = newTR.insertCell(1);
					    td.innerHTML = "<input type='hidden' name='apanage_id' value='"+apanage_id+"' class='input_width'/>"+
						    "<input type='hidden' name='org_id' value='"+org_id+"' class='input_width'/>"+
						    "<input type='hidden' name='org_subjection_id' value='"+org_subjection_id+"' class='input_width'/>"+
						    "<span ><a href='#' onclick=refreshData('"+org_subjection_id+"')>"+org_name+"</a></span>";
						td.rowSpan = rowSpan;
						
					    td = newTR.insertCell(2);
					    td.innerHTML = "固定场所";

					    var fixed_sum = data.fixed_sum;
					    td = newTR.insertCell(3);
					    td.innerHTML = fixed_sum;
					    
					    var fixed_human = data.fixed_human;
					    td = newTR.insertCell(4);
					    td.innerHTML = "<input name='fixed_human' type='text' value='"+fixed_human+"' onkeydown='javascript:return checkIfNum(event);' disabled='disabled' class='input_width'/>";
					    
					    var fixed_equipment = data.fixed_equipment;
					    td = newTR.insertCell(5);
					    td.innerHTML = "<input name='fixed_equipment' type='text' value='"+fixed_equipment+"' onkeydown='javascript:return checkIfNum(event);' disabled='disabled' class='input_width'/>";
					    
					    var fixed_danger = data.fixed_danger;
					    td = newTR.insertCell(6);
					    td.innerHTML = "<input name='fixed_danger' type='text'  value='"+fixed_danger+"' onkeydown='javascript:return checkIfNum(event);' disabled='disabled' class='input_width'/>";
				    	
					    autoOrder = document.getElementById("apanage").rows.length;
					    newTR = document.getElementById("apanage").insertRow(autoOrder);

					    td = newTR.insertCell(0);
					    td.innerHTML = "流动场所";
					    
					    var flow_sum = data.flow_sum;
					    td = newTR.insertCell(1);
					    td.innerHTML = flow_sum;
					    
					    var flow_human = data.flow_human;
					    td = newTR.insertCell(2);
					    td.innerHTML = "<input name='flow_human' type='text' value='"+flow_human+"' onkeydown='javascript:return checkIfNum(event);' disabled='disabled' class='input_width'/>";
					    
					    var flow_equipment = data.flow_equipment;
					    td = newTR.insertCell(3);
					    td.innerHTML = "<input name='flow_equipment' type='text' value='"+flow_equipment+"' onkeydown='javascript:return checkIfNum(event);' disabled='disabled' class='input_width'/>";
					    
					    var flow_danger = data.flow_danger;
					    td = newTR.insertCell(4);
					    td.innerHTML = "<input name='flow_danger' type='text'  value='"+flow_danger+"' onkeydown='javascript:return checkIfNum(event);' disabled='disabled' class='input_width'/>";
					}else if(name.indexOf('队')!=-1){
						var org_id = data.org_id;
					    var org_subjection_id = data.org_subjection_id;
					    rowSpan = '1';
					    var org_name = data.org_name;
					    var apanage_id = data.apanage_id;
						var autoOrder = document.getElementById("apanage").rows.length;
						
						var newTR = document.getElementById("apanage").insertRow(autoOrder);
					    var td = newTR.insertCell(0);
					    td.innerHTML = data.rownum;
					    td.rowSpan = rowSpan;
					    td = newTR.insertCell(1);
					    td.innerHTML = "<input type='hidden' name='apanage_id' value='"+apanage_id+"' class='input_width'/>"+
						    "<input type='hidden' name='org_id' value='"+org_id+"' class='input_width'/>"+
						    "<input type='hidden' name='org_subjection_id' value='"+org_subjection_id+"' class='input_width'/>"+
						    "<span ><a href='#' onclick=refreshData('"+org_subjection_id+"')>"+org_name+"</a></span>";
						td.rowSpan = rowSpan;
						td = newTR.insertCell(2);
					    td.innerHTML = "流动场所";
					    
					    var flow_sum = data.flow_sum;
					    td = newTR.insertCell(3);
					    td.innerHTML = flow_sum;
					    
					    var flow_human = data.flow_human;
					    td = newTR.insertCell(4);
					    td.innerHTML = "<input name='flow_human' type='text' value='"+flow_human+"' onkeydown='javascript:return checkIfNum(event);' onkeyup='changerValue(event)' disabled='disabled' class='input_width'/>";
					    
					    var flow_equipment = data.flow_equipment;
					    td = newTR.insertCell(5);
					    td.innerHTML = "<input name='flow_equipment' type='text' value='"+flow_equipment+"' onkeydown='javascript:return checkIfNum(event);' onkeyup='changerValue(event)' disabled='disabled' class='input_width'/>";
					    
					    var flow_danger = data.flow_danger;
					    td = newTR.insertCell(6);
					    td.innerHTML = "<input name='flow_danger' type='text'  value='"+flow_danger+"' onkeydown='javascript:return checkIfNum(event);' onkeyup='changerValue(event)' disabled='disabled' class='input_width'/>";
					}else{
						var org_id = data.org_id;
					    var org_subjection_id = data.org_subjection_id;
					    rowSpan = '1';
					    var org_name = data.org_name;
					    var apanage_id = data.apanage_id;
						var autoOrder = document.getElementById("apanage").rows.length;
						
						var newTR = document.getElementById("apanage").insertRow(autoOrder);
					    var td = newTR.insertCell(0);
					    td.innerHTML = data.rownum;
					    td.rowSpan = rowSpan;
					    td = newTR.insertCell(1);
					    td.innerHTML = "<input type='hidden' name='apanage_id' value='"+apanage_id+"' class='input_width'/>"+
						    "<input type='hidden' name='org_id' value='"+org_id+"' class='input_width'/>"+
						    "<input type='hidden' name='org_subjection_id' value='"+org_subjection_id+"' class='input_width'/>"+
						    "<span ><a href='#' onclick=refreshData('"+org_subjection_id+"')>"+org_name+"</a></span>";
						td.rowSpan = rowSpan;
						td = newTR.insertCell(2);
					    td.innerHTML = "固定场所";
					    
					    var fixed_sum = data.fixed_sum;
					    td = newTR.insertCell(3);
					    td.innerHTML = fixed_sum;
					    
					    var fixed_human = data.fixed_human;
					    td = newTR.insertCell(4);
					    td.innerHTML = "<input name='fixed_human' type='text' value='"+fixed_human+"' onkeydown='javascript:return checkIfNum(event);' onkeyup='changerValue(event)' disabled='disabled' class='input_width'/>";
					    
					    var fixed_equipment = data.fixed_equipment;
					    td = newTR.insertCell(5);
					    td.innerHTML = "<input name='fixed_equipment' type='text' value='"+fixed_equipment+"' onkeydown='javascript:return checkIfNum(event);' onkeyup='changerValue(event)' disabled='disabled' class='input_width'/>";
					    
					    var fixed_danger = data.fixed_danger;
					    td = newTR.insertCell(6);
					    td.innerHTML = "<input name='fixed_danger' type='text'  value='"+fixed_danger+"' onkeydown='javascript:return checkIfNum(event);' onkeyup='changerValue(event)' disabled='disabled' class='input_width'/>";
					}  	
				}
			}
		}
		
		/* var queryRet = jcdpCallService("HseOperationSrv", "getApanageSum", "subjection_id="+subjection_id);
		if(queryRet.returnCode =='0'){
			if(queryRet.data!=null){
				var map = queryRet.data;
				var num = map.num;
				var human = map.human ;
				var equipment = map.equipment;
				var danger = map.danger;
			}
		} */
		$("#table_box").css("height",$(window).height()*0.90);
	}
	/* 输入的是否是数字 */
	function checkIfNum(event){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			return false;
		}
	}
	function changerValue(event){
		var tr = event.srcElement.parentElement.parentElement;
		var human = tr.cells[4].firstChild.value;
		var equipment = tr.cells[5].firstChild.value;
		var danger = tr.cells[6].firstChild.value;
		tr.cells[3].innerHTML = human -(-equipment)-(-danger);
	}
	function toSetting(){
		var obj = new Object();
		window.showModalDialog('<%=contextPath%>/hse/orgAndRoles/apanage/checktree.jsp',obj,'dialogWidth=518px;dialogHeight=768px');
		refreshData(subjection_id);
	}
	function toEdit(){  
		var editMultiple = "<%= editMultiple%>";
		var editSingle = "<%= editSingle%>";
		var retObj = jcdpCallService("HseSrv", "queryOrg", "org_subjection_id="+subjection_id);
		if(retObj.returnCode =='0'){
			if(editMultiple||editSingle){
				
			}else{
				if(retObj.list!=null){
					var len = retObj.list.length;
					if(len==2 || len==3){
						
					}else{
						alert("只有基层单位可以填写!");
						return ;
					}
				}else{
					alert("只有基层单位可以填写!");
					return ;
				}
			}
		}
		var inputs = document.getElementsByTagName("input");
		for(var i=0;i<inputs.length;i++){
			inputs[i].removeAttribute("disabled");
		}
	} 
	
	function toSubmit(){  
		if(checkText0()){
			return;
		}
	} 
	
	function checkText0(){
		var autoOrder = document.getElementById("apanage").rows.length;
		var substr = "";
		for(var i =2 ; i<= autoOrder-1 ;i++){
			var tr = document.getElementById("apanage").rows[i];
			debugger;
			var apanage_id = tr.cells[1].children[0].value;
			var org_id = tr.cells[1].children[1].value;
			var org_subjection_id = tr.cells[1].children[2].value;
			var org_name = tr.cells[1].children[3].firstChild.firstChild.data;
			var project_info_no = '<%=user.getProjectInfoNo()%>';
			if(project_info_no==null || project_info_no=='null'){
				project_info_no = '';
			}
			if(apanage_id!=null && apanage_id!=''){
				substr = substr + "update bgp_hse_apanage t set t.org_id ='"+org_id+"',t.org_subjection_id ='"+org_subjection_id+"' ," +
				" t.fixed_sum ='?' ,t.fixed_human ='?' ,t.fixed_equipment='?' ,t.fixed_danger='?',"+
				" t.flow_sum ='?' ,t.flow_human ='?' ,t.flow_equipment='?' ,t.flow_danger='?',"+
				" t.modifi_date = sysdate ,t.updator_id='"+'<%=user.getUserId()%>'+"' where t.apanage_id ='"+apanage_id+"';"
			}else{
				substr = substr + "insert into bgp_hse_apanage(apanage_id ,org_id ,org_subjection_id ,"+
				" fixed_sum ,fixed_human ,fixed_equipment ,fixed_danger ,"+
				" flow_sum ,flow_human ,flow_equipment ,flow_danger ,"+
				" bsflag ,create_date,creator_id ,modifi_date ,updator_id ,project_info_no) "+
				" values((select lower(sys_guid()) from dual),'"+org_id+"' ,'"+org_subjection_id+"' ,'?' ,'?' ,'?' ,'?' ," +
				" '?' ,'?' ,'?' ,'?' ,'0' ,sysdate ,'<%=user.getUserId()%>' ,sysdate,'<%=user.getUserId()%>','"+project_info_no+"');"
			}
			var text = tr.cells[2].innerHTML;
			if(text!=null && text=='固定场所'){
				var fixed_sum = tr.cells[3].innerHTML;
				if(fixed_sum==null){
					fixed_sum ='';
				}
				substr = substr.replace('?',fixed_sum);
				
				var fixed_human = tr.cells[4].firstChild.value;
//				if(fixed_human==null || fixed_human ==''){
//					alert(org_name+"单位的固定场所人员不能为空,请填写!")
//					return;
//				}
				if(fixed_human==null){
					fixed_human='';
				}
				substr = substr.replace('?',fixed_human);
				
				var fixed_equipment = tr.cells[5].firstChild.value;
//				if(fixed_equipment==null || fixed_equipment ==''){
//					alert(org_name+"单位的固定场所设备不能为空,请填写!")
//					return;
//				}
				if(fixed_equipment==null){
					fixed_equipment='';
				}
				substr = substr.replace('?',fixed_equipment);
				
				var fixed_danger = tr.cells[6].firstChild.value;
//				if(fixed_danger==null || fixed_danger ==''){
//					alert(org_name+"单位的固定场所危险点源不能为空,请填写!")
//					return;
//				}
				if(fixed_danger==null){
					fixed_danger='';
				}
				substr = substr.replace('?',fixed_danger);
				
				substr = substr.replace('?','');
				substr = substr.replace('?','');
				substr = substr.replace('?','');
				substr = substr.replace('?','');
			}else if(text!=null && text=='流动场所'){
				substr = substr.replace('?','');
				substr = substr.replace('?','');
				substr = substr.replace('?','');
				substr = substr.replace('?','');
				
				var flow_sum = tr.cells[3].innerHTML;
				if(flow_sum==null){
					flow_sum ='';
				}
				substr = substr.replace('?',flow_sum);
				
				var flow_human = tr.cells[4].firstChild.value;
//				if(flow_human==null || flow_human ==''){
//					alert(org_name+"单位的流动场所人员不能为空,请填写!")
//					return;
//				}
				if(flow_human==null){
					flow_human='';
				}
				substr = substr.replace('?',flow_human);
				
				var flow_equipment = tr.cells[5].firstChild.value;
//				if(flow_equipment==null || flow_equipment ==''){
//					alert(org_name+"单位的流动场所设备不能为空,请填写!")
//					return;
//				}
				if(flow_equipment==null){
					flow_equipment='';
				}
				substr = substr.replace('?',flow_equipment);
				
				var flow_danger = tr.cells[6].firstChild.value;
//				if(flow_danger==null || flow_danger ==''){
//					alert(org_name+"单位的流动场所危险点源不能为空,请填写!")
//					return;
//				}
				if(flow_danger==null){
					flow_danger='';
				}
				substr = substr.replace('?',flow_danger);
			}
		}
		var retObj = jcdpCallService("HseOperationSrv", "saveApanage", "sql="+substr);
		if(retObj.returnCode =='0'){
			alert("保存成功!");
			refreshData(subjection_id)
		}
		return false;
	}
	<%-- function changeRowSpan(org_subjection_id){
		var querySql ="select o.* ,inf.org_abbreviation org_name from bgp_hse_org o join comm_org_subjection sub on o.org_sub_id = sub.org_subjection_id and sub.bsflag='0'"+
		" join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag='0' where o.father_org_sub_id ='"+org_subjection_id+"' ";
    	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				for(var i=0;i<retObj.datas.length ;i++){
					var data = retObj.datas[i];
					var org_name = data.org_name;
					if(org_name!=null && org_name.indexOf('队')!=-1){
						rowSpan = '2';
						return;
					}else{
						var subjection_id = data.org_sub_id;
						changeRowSpan(subjection_id)
					}
				}
			}
		}
	} --%>
</script>
</html>