<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
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
				     	<td class="inquire_item6"><font color="red">*</font>应急事件类别：</td>
				      	<td class="inquire_form6">
				      		<input type="hidden" id="strain_type" name="strain_type" value="" class="input_width"/>
				      		<input type="text" id="strain_name" name="strain_name" value="" class="input_width"/>
				      		<input type="button" style="width:20px" value="..." onclick="showStrainType()"/>
				      	</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>应急职责：</td>
				      	<td class="inquire_form6">
				      		<select id="strain_duty" name="strain_duty" class="select_width">
					          <option value="" >请选择</option>
					          <%
					          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000034' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
					          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					          	for(int i=0;i<list.size();i++){
					          		Map map = (Map)list.get(i);
					          		String coding_id = (String)map.get("codingCodeId");
					          		String coding_name = (String)map.get("codingName");
					          %>
					          <option value="<%=coding_id %>" ><%=coding_name %></option>
					          <%} %>
						    </select>
				      	</td>
					  	<td class="inquire_item6"><font color="red">*</font>首选联系电话：</td>
					    <td class="inquire_form6">
							<input type="text" id="first_phone" name="first_phone" class="input_width"></input>
						</td>
					  	<td class="inquire_item6">次选联系电话：</td>
					    <td class="inquire_form6">
							<input type="text" id="second_phone" name="second_phone" class="input_width"></input>
						</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>应急专家：</td>
				      	<td class="inquire_form6">
				      		<select id="expert_flag" name="expert_flag" class="select_width" onclick="ifExpert()">
					          <option value="" >请选择</option>
					          <option value="1" >是</option>
					          <option value="2" >否</option>
						    </select>
				      	</td>
					 	<td class="inquire_item6"><font id="if_expert1" color="red" style="display: none;">*</font>专家级别：</td>
					   	<td class="inquire_form6">
							<select id="expert_level" name="expert_level" class="select_width" >
					          <option value="" >请选择</option>
					          <option value="1" >集团公司</option>
					          <option value="2" >公司</option>
					          <option value="3" >二级单位</option>
						    </select>
						</td>
						<td class="inquire_item6"><font id="if_expert2" color="red" style="display: none;">*</font>擅长领域：</td>
					    <td class="inquire_form6">
							<select id="expert_field" name="expert_field" class="select_width">
					          <option value="" >请选择</option>
					          <%
					          	String sql22 = "select * from comm_coding_sort_detail where coding_sort_id='5110000035' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
					          	List list22 = BeanFactory.getQueryJdbcDAO().queryRecords(sql22);
					          	for(int i=0;i<list22.size();i++){
					          		Map map22 = (Map)list22.get(i);
					          		String coding_id22 = (String)map22.get("codingCodeId");
					          		String coding_name22 = (String)map22.get("codingName");
					          %>
					          <option value="<%=coding_id22 %>" ><%=coding_name22 %></option>
					          <%} %>
						    </select>
						</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font id="if_expert3" color="red" style="display: none;">*</font>擅长职责：</td>
				      	<td class="inquire_form6">
				      		<select id="expert_duty" name="expert_duty" class="select_width">
					          <option value="" >请选择</option>
					          <%
					          	String sql33 = "select * from comm_coding_sort_detail where coding_sort_id='5110000036' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
					          	List list33 = BeanFactory.getQueryJdbcDAO().queryRecords(sql33);
					          	for(int i=0;i<list33.size();i++){
					          		Map map33 = (Map)list33.get(i);
					          		String coding_id33 = (String)map33.get("codingCodeId");
					          		String coding_name33 = (String)map33.get("codingName");
					          %>
					          <option value="<%=coding_id33 %>" ><%=coding_name33 %></option>
					          <%} %>
						    </select>
				      	</td>
					 	<td class="inquire_item6"></td>
					   	<td class="inquire_form6"></td>
						<td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">补充说明</td>
					    <td class="inquire_form6" colspan="5"><textarea id="memo" name="memo" class="textarea" ></textarea></td>
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
	form.action="<%=contextPath%>/hse/resource/addStrain.srq";
	form.submit();
}

function ifExpert(){
	var expertFlag = document.getElementById("expert_flag").value;
	if(expertFlag=="1"){
		document.getElementById("if_expert1").style.display = "";
		document.getElementById("if_expert2").style.display = "";
		document.getElementById("if_expert3").style.display = "";
	}else{
		document.getElementById("if_expert1").style.display = "none";
		document.getElementById("if_expert2").style.display = "none";
		document.getElementById("if_expert3").style.display = "none";
	}
}

function showStrainType(){
	var selected = window.showModalDialog("<%=contextPath%>/hse/humanResource/hseStrainPerson/selectStrainType.jsp","","dialogWidth=545px;dialogHeight=280px");

	var strain_name = "";
	var name = ""
	var temp = selected.split("、");
	for(var i=0;i<temp.length;i++){
		var id = temp[i];
		  

		if(id=="1"){
			name = "自然灾害";		
		}
		if(id=="2"){
			name = "事故灾难";		
		}
		if(id=="3"){
			name = "公共卫生";		
		}
		if(id=="4"){
			name = "社会安全";		
		}
	 
		if(strain_name!="") strain_name += "、";
		strain_name += name;
	}
	document.getElementById("strain_type").value = selected;
	document.getElementById("strain_name").value = strain_name;
	
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
	
	debugger;
	var strain_type = document.getElementById("strain_type").value;
	var strain_duty = document.getElementById("strain_duty").value;
	var first_phone = document.getElementById("first_phone").value;
	var second_phone = document.getElementById("second_phone").value;
	var expert_flag = document.getElementById("expert_flag").value;
	var expert_level = document.getElementById("expert_level").value;
	var expert_field = document.getElementById("expert_field").value;
	var expert_duty = document.getElementById("expert_duty").value;
	if(employee_id==""){
		alert("人员姓名不能为空，请选择！");
		return true;
	}
	if(person_status==""){
		alert("是否在岗不能为空，请填写！");
		return true;
	}
	if(strain_type==""){
		alert("应急事件类别不能为空，请选择！");
		return true;
	}
	if(strain_duty==""){
		alert("应急职责不能为空，请选择！");
		return true;
	}
	if(first_phone==""){
		alert("首选联系电话不能为空，请填写！");
		return true;
	}
 
	if(expert_flag==""){
		alert("应急专家不能为空，请选择！");
		return true;
	}
	if(expert_flag=="1"){
		if(expert_level==""){
			alert("专家级别不能为空，请选择！");
			return true;
		}
		if(expert_field==""){
			alert("擅长领域不能为空，请选择！");
			return true;
		}
		if(expert_duty==""){
			alert("擅长职责不能为空，请填写！");
			return true;
		}
	}
	return false;
}


</script>
</html>