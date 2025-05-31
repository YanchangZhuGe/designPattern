<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
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
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td align="left"><font color="blue" size="4">HSE方针：以人为本，预防为主，全员责任，持续改进</font></td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
		<!--     <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
		 -->		    
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_advertise_id}' id='rdo_entity_id_{hse_advertise_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{advertise_person}">宣贯人姓名</td>
			      <td class="bt_info_odd" exp="{duty}">宣贯人职务</td>
			      <td class="bt_info_even" exp="{content}">宣贯内容</td>
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
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_advertise_id" name="hse_advertise_id"></input>
			<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						  <td class="inquire_item6">单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
					      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	<%} %>
					      	</td>
					     	<td class="inquire_item6">基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	<%} %>
					      	</td>
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
					      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">是否方针：</td>
					    <td class="inquire_form6">
					    	<select id="if_plicy" name="if_plicy" class="select_width">
					    		<option value="">请选择</option>
					    		<option value="0">是</option>
					    		<option value="1">否</option>
					    	</select>
						</td>
					   <td class="inquire_item6"><font color="red">*</font>宣贯人职务：</td>
					    <td class="inquire_form6">
							<select id="duty" name="duty" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >处长</option>
					          <option value="2" >副处长</option>
					          <option value="3" >队经理</option>
					          <option value="4" >队副经理</option>
					          <option value="5" >其他正职</option>
					          <option value="6" >其他副职</option>
						    </select>
					    </td>
					    <td class="inquire_item6">宣贯人姓名：</td>
					    <td class="inquire_form6"><input type="text" id="advertise_person" name="advertise_person" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">宣贯日期：</td>
					    <td class="inquire_form6">
					    	<input type="text" id="advertise_date" name="advertise_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(advertise_date,tributton2);" />&nbsp;
						</td>
					   <td class="inquire_item6"></td>
					   <td class="inquire_form6"></td>
					   <td class="inquire_item6"></td>
					   <td class="inquire_form6"></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>宣贯内容：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="content" name="content" class="textarea"></textarea></td>
					  </tr>
					</table>
				</div>
				</form>
				</div>
			</div>
</body>
<script type="text/javascript">
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
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql();
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.hse_advertise_id,t.second_org,t.third_org,case when length(t.content)>10 then concat(substr(t.content, 1, 10), '...') else t.content end content,t.rate,decode(t.duty,'1','处长','2','副处长','3','队经理','4','队副经理','5','其他正职','6','其他副职') as duty,t.advertise_person,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date,t.modifi_date from bgp_hse_advertise t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag = '0' and t.if_plicy='0' "+querySqlAdd+" order by modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hsePolicy/policy_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hsePolicy/policy_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	function clearQueryText(){
		document.getElementById("eventName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "queryAdvertise", "hse_advertise_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryAdvertise", "hse_advertise_id="+ids);
		}
		document.getElementById("hse_advertise_id").value =retObj.map.hseAdvertiseId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("fourth_org").value =retObj.map.fourthOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.map.fourthOrgName;
		document.getElementById("duty").value = retObj.map.duty;
		document.getElementById("advertise_person").value = retObj.map.advertisePerson;
		document.getElementById("advertise_date").value = retObj.map.advertiseDate;
		document.getElementById("content").value = retObj.map.content;
		
		document.getElementById("if_plicy").value = retObj.map.ifPlicy;
		
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/hsePolicy/addPolicy.jsp?isProject=<%=isProject%>");
		
	}
	
	function toEdit(){  
		var hse_advertise_id = document.getElementById("hse_advertise_id").value;
	  	if(hse_advertise_id==''||hse_advertise_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/hsePolicy/queryPolicy.srq?isProject=<%=isProject%>&hse_advertise_id="+hse_advertise_id);
	} 
	
	
	function toUpdate(){  
		var form = document.getElementById("form");
		if(checkText()){
			return;
		}
		form.action="<%=contextPath%>/hse/hsePolicy/savePolicy.srq";
		form.submit();
	} 
	
	
	function checkText(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var content=document.getElementById("content").value;
		var duty=document.getElementById("duty").value;
		var times=document.getElementById("times").value;
		var re = /^[1-9]+[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		if(duty==""){
			alert("宣贯人职务不能为空，请选择！");
			return true;
		}
		if(content==""){
			alert("宣贯内容不能为空，请填写！");
			return true;
		}
		if(content.length>2000){
			alert("字数不能超过2000！");
			return true;
		}
		if(times!=""){
			if(!re.test(times)){
		       alert("宣贯次数请输入数字且为整数！");
		       return true;
			}
		}
		return false;
	}

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteAdvertise", "hse_advertise_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hsePolicy/policy_search.jsp?isProject=<%=isProject%>");
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
</script>

</html>

