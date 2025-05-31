<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project = request.getParameter("project");
    
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
<input type="hidden" id="hse_professional_id" name="hse_professional_id" value=""/>
<input type="hidden" id="project" name="project" value="<%=project %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					 <tr>
				    	<td class="inquire_item6"><font color="red">*</font>选择人员：</td>
				      	<td class="inquire_form6">
							<input type="hidden" id="employee_id" name="employee_id" class="input_width"  value=""/>
					      	<input type="text" id="employee_name" name="employee_name" class="input_width"  value=""/>
					      	<input type="button" style="width:20px" value="..." onclick="showHuman()"/>
				      	</td>
					   	<td class="inquire_item6"><font color="red">*</font>是否在岗：</td>
					   	<td class="inquire_form6">
					   		<select id="person_status" name="person_status" class="select_width">
						       <option value="" >请选择</option>
						       <option value="是" >是</option>
						       <option value="否" >否</option>
							</select>
					   	</td>
				     	<td class="inquire_item6"><font color="red">*</font>专职或兼职：</td>
				      	<td class="inquire_form6">
				      		<select id="work_property" name="work_property" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >专职</option>
					          <option value="2" >兼职</option>
						    </select>
				      	</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>板块属性：</td>
				      	<td class="inquire_form6">
				      		<select id="plate_property" name="plate_property" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >野外一线</option>
					          <option value="2" >固定场所</option>
					          <option value="3" >科研单位</option>
					          <option value="4" >培训接待</option>
					          <option value="5" >矿区</option>
						    </select>
				      	</td>
					  <td class="inquire_item6"><font color="red">*</font>是否取得注安资格：</td>
					    <td class="inquire_form6">
						<select id="safeflag" name="safeflag" class="select_width" >
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>从事本岗开始时间：</td>
					   	<td class="inquire_form6"><input type="text" id="start_date" name="start_date" class="input_width"  readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_date,tributton4);" />&nbsp;
					    </td>
					  </tr>
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";

function showHuman(){
    var project = "<%=project%>";
    var result = "";
    if(project=="1"){
    	result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanMultiple.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
    }else if(project=="2"){
    	result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanSingle.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
    }
    if(result!=null && result!=""){
    	var checkStr=result.split(",");
    	for(var i=0;i<checkStr.length-1;i++){
    		var testTemp = checkStr[i].split("-");
    		document.getElementById("employee_id").value = testTemp[0];
    	    document.getElementById("employee_name").value = testTemp[1];
       	}	
   }
  }

function submitButton(){
	if(checkText()){
		return;
	}
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/hse/resource/addProfessional.srq";
	form.submit();
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
	var employee_id = document.getElementById("employee_id").value;
	var person_status = document.getElementById("person_status").value;
	var work_property = document.getElementById("work_property").value;
	var plate_property = document.getElementById("plate_property").value;
	var safeflag=document.getElementById("safeflag").value;
	var start_date=document.getElementById("start_date").value;

	if(employee_id==""){
		alert("人员姓名不能为空，请选择！");
		return true;
	}
	if(person_status==""){
		alert("是否在岗不能为空，请填写！");
		return true;
	}
	if(work_property==""){
		alert("专职或兼职不能为空，请填写！");
		return true;
	}
	if(plate_property==""){
		alert("板块属性不能为空，请填写！");
		return true;
	}
	if(safeflag==""){
		alert("是否取得注安资格不能为空，请选择！");
		return true;
	}
	if(start_date==""){
		alert("从事本岗开始时间不能为空，请填写！");
		return true;
	}
	return false;
}

</script>
</html>