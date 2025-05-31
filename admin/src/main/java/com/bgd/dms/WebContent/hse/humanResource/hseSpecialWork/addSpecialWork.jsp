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
<input type="hidden" id="project" name="project" value="<%=project%>"/>
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
				     	<td class="inquire_item6"><font color="red">*</font>从事工种：</td>
				      	<td class="inquire_form6">
				      	<select id="work_type" name="work_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="电工作业" >电工作业</option>
					       <option value="焊接与热切割作业" >焊接与热切割作业</option>
					       <option value="制冷与空调作业" >制冷与空调作业</option>
					       <option value="涉爆作业" >涉爆作业</option>
					       <option value="危险化学品作业" >危险化学品作业</option>
					       <option value="电梯作业" >电梯作业</option>
					       <option value="锅炉作业" >锅炉作业</option>
					       <option value="压力容器作业" >压力容器作业</option>
					       <option value="压力管道作业" >压力管道作业</option>
					       <option value="气瓶作业" >气瓶作业</option>
					       <option value="起重机械作业" >起重机械作业</option>						       
					       <option value="场(厂)内专用机动车辆作业" >场(厂)内专用机动车辆作业</option>
					       <option value="安全附件维修作业" >安全附件维修作业</option>
					       <option value="其他特种作业" >其他特种作业</option>						       
						</select>
						
				      	</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>证件名称：</td>
				      	<td class="inquire_form6">
				      		<input type="text" id="certificate_name" name="certificate_name" class="input_width"></input>
				      	</td>
					  <td class="inquire_item6"><font color="red">*</font>发证单位：</td>
					    <td class="inquire_form6">
							<input type="text" id="certificate_org" name="certificate_org" class="input_width"></input>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>审验日期截止到：</td>
					   	<td class="inquire_form6"><input type="text" id="check_date" name="check_date" class="input_width"  readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton4);" />&nbsp;
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
	form.action="<%=contextPath%>/hse/resource/addSpecialWork.srq";
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
	var work_type = document.getElementById("work_type").value;
	var certificate_name = document.getElementById("certificate_name").value;
	var certificate_org = document.getElementById("certificate_org").value;
	var check_date = document.getElementById("check_date").value;
	if(employee_id==""){
		alert("人员姓名不能为空，请选择！");
		return true;
	}
	if(person_status==""){
		alert("时候在岗不能为空，请填写！");
		return true;
	}
	if(work_type==""){
		alert("从事工种不能为空，请填写！");
		return true;
	}
	if(certificate_name==""){
		alert("证件名称不能为空，请填写！");
		return true;
	}
	if(certificate_org==""){
		alert("发证机关不能为空，请选择！");
		return true;
	}
	if(check_date==""){
		alert("审验截止日期不能为空，请填写！");
		return true;
	}
	return false;
}


</script>
</html>