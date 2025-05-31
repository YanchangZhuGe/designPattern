<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
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
	for (int i = n+1; i >= 2002; i--) {
		listYear.add(i);
	}
	String hse_assess_id = request.getParameter("hse_assess_id");
 	String action = request.getParameter("action");   
 	String  project = request.getParameter("project");
	if(project==null||project.equals("")){
		project = resultMsg.getValue("project");
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_assess_id" name="hse_assess_id" value=""/>
<input type="hidden" id="project" name="project" value="<%=project%>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
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
				    	<td class="inquire_item6">考核期：</td>
				      	<td class="inquire_form6">
					      	<select id="year" name="year" class="select_width">
						       	<option value="" >请选择</option>
								<%for(int j=0;j<listYear.size();j++){%>
								<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
								<% } %>
							</select>年
				      	</td>
				     	<td class="inquire_item6">季度：</td>
				      	<td class="inquire_form6">
				      		<select id="quarter" name="quarter" class="select_width" onclick="selectQuarter()">
					          <option value="" >请选择</option>
					          <option value="1" >第一季度</option>
					          <option value="4" >第二季度</option>
					          <option value="7" >第三季度</option>
					          <option value="10">第四季度</option>
						    </select>
				      	</td>
				    	<td class="inquire_item6">月份：</td>
				      	<td class="inquire_form6">
					      	<select id="month" name="month" class="select_width"  onclick="selectMonth()">
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
					      	<input type="text" id="assess_name" name="assess_name" class="input_width"  value="" readonly="readonly" />
					      	<input type="button" style="width:20px" value="..." onclick="showHuman()"/>
				      	</td>
					    <td class="inquire_item6"><font color="red">*</font>考核日期：</td>
					    <td class="inquire_form6"><input type="text" id="assess_date" name="assess_date" class="input_width" value="<%=today %>" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(assess_date,tributton2);" />&nbsp;</td>
					    <td id="model" class="inquire_item6">模板：</td>
					    <td id="model2" class="inquire_form6">
							<input type="hidden" id="hse_model_id" name="hse_model_id" class="input_width"  value=""/>
					      	<input type="text" id="model_name" name="model_name" class="input_width"  value=""/>
					      	<input type="button" style="width:20px" value="..." onclick="showModel()"/>
						</td>
					  </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="xyb_btn"><a href="#" onclick="submitButton2()"></a></span>
				<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

//var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
//var showTabBox = document.getElementById("tab_box_content0");
var hse_assess_id = "<%=hse_assess_id%>";
var action = "<%=action%>";
toEdit();

cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
	
}

function queryOrg(id){
	var org_subjection_id = "";
	if(id!=null&&id!=""){
		var checkSql="select e.employee_id,os.org_subjection_id from comm_human_employee e join comm_org_subjection os on e.org_id=os.org_id and os.bsflag='0' where e.bsflag='0' and e.employee_id='"+id+"'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;	
		if(datas!=null&&datas!=""){
			var org_subjection_id = datas[0].org_subjection_id;	
		}
	}
	retObj = jcdpCallService("HseSrv", "queryOrg", "org_subjection_id="+org_subjection_id);
	if(retObj.flag=="true"){
		var len = retObj.list.length;
		if(len>0){
			document.getElementById("second_org").value=retObj.list[0].orgSubId;
			document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
		}
		if(len>1){
			document.getElementById("third_org").value=retObj.list[1].orgSubId;
			document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
		}
		if(len>2){
			document.getElementById("fourth_org").value=retObj.list[2].orgSubId;
			document.getElementById("fourth_org2").value=retObj.list[2].orgAbbreviation;
		}
	}
}


function submitButton2(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
		
//	form.action="<%=contextPath%>/hse/assess/addAssess.srq?action="+action;
//	form.submit();
	
	var hse_assess_id = document.getElementById("hse_assess_id").value;
	var second_org = document.getElementById("second_org").value;
	var third_org = document.getElementById("third_org").value;
	var fourth_org = document.getElementById("fourth_org").value;
	var year = document.getElementById("year").value;
	var quarter = document.getElementById("quarter").value;
	var month = document.getElementById("month").value;
	var assess_person_id = document.getElementById("assess_person_id").value;
	var assess_date = document.getElementById("assess_date").value;
	var hse_model_id = document.getElementById("hse_model_id").value;
	var assess_name = document.getElementById("assess_name").value;
	window.location = "<%=contextPath%>/hse/objAndTarget/hseAssess/addAssess11.jsp?hse_assess_id="+hse_assess_id+"&second_org="+second_org+"&third_org="+third_org+"&fourth_org="+fourth_org+"&year="+year+"&quarter="+quarter+"&month="+month+"&assess_person_id="+assess_person_id+"&assess_date="+assess_date+"&hse_model_id="+hse_model_id+"&action="+action+"&project=<%=project%>&assess_name="+assess_name;
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


function closeButton(){
	newClose();
}

function showHuman(){
	debugger;
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
	queryOrg(teamInfo.fkValue);
}

function showModel(){
	var modelInfo = window.showModalDialog("<%=contextPath%>/hse/objAndTarget/hseAssess/selectModel.jsp","","dialogWidth=545px;dialogHeight=280px");
	if(modelInfo!=""&&modelInfo!=null){
		var temp = modelInfo.split(",");
		document.getElementById("hse_model_id").value = temp[0];
		document.getElementById("model_name").value = temp[1];
	}
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

function checkText(){
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	var fourth_org2=document.getElementById("fourth_org2").value;
	var year = document.getElementById("year").value;
	var assess_name = document.getElementById("assess_name").value;
	var assess_date = document.getElementById("assess_date").value;

	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	if(year==""){
		alert("年度不能为空，请选择！");
		return true;
	}
	if(assess_name==""){
		alert("被考核人不能为空，请选择！");
		return true;
	}
	if(assess_date==""){
		alert("考核时间不能为空，请填写！");
		return true;
	}
	return false;
}


	function toEdit(){
		var checkSql="select ha.*,ee.employee_name,au.user_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_assess ha left join comm_org_subjection os1 on ha.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ha.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on ha.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' where ha.bsflag='0' and ha.hse_assess_id='"+hse_assess_id+"' order by ha.modifi_date desc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas==null||datas==""){
			
		}else{
			document.getElementById("hse_assess_id").value = datas[0].hse_assess_id;
			document.getElementById("second_org").value = datas[0].second_org;
			document.getElementById("third_org").value = datas[0].third_org;
			document.getElementById("fourth_org").value = datas[0].fourth_org;
			document.getElementById("second_org2").value = datas[0].second_org_name;
			document.getElementById("third_org2").value = datas[0].third_org_name;
			document.getElementById("fourth_org2").value = datas[0].fourth_org_name;
			
			document.getElementById("year").value =	datas[0].year;
			if(datas[0].type=="1"){
				document.getElementById("quarter").value = datas[0].quarter_month;
				document.getElementById("month").value = "";
			}else if(datas[0].type=="2"){
				document.getElementById("month").value = datas[0].quarter_month;
				document.getElementById("quarter").value = "";
			}
			document.getElementById("assess_person_id").value = datas[0].assess_name;
			document.getElementById("assess_name").value = datas[0].employee_name;
			document.getElementById("assess_date").value = datas[0].assess_date;
			
			
			document.getElementById("model").style.display = "none";
			document.getElementById("model2").style.display = "none";
		}
		
	} 



</script>
</html>