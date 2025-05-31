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
				     	<td class="inquire_item6"><font color="red">*</font>是否危化品驾驶员：</td>
				      	<td class="inquire_form6">
				      		<select id="danger_driver" name="danger_driver" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >是</option>
					          <option value="2" >否</option>
						    </select>
				      	</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>是否特殊车辆驾驶员：</td>
				      	<td class="inquire_form6">
				      		<select id="special_driver" name="special_driver" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >是</option>
					          <option value="2" >否</option>
						    </select>
				      	</td>
					  <td class="inquire_item6"><font color="red">*</font>准驾车型代号：</td>
					    <td class="inquire_form6">
							<input type="text" id="type_num" name="type_num" class="input_width"></input>
						</td>
					    <td class="inquire_item6"><font color="red">*</font>驾驶证初领日期：</td>
					   	<td class="inquire_form6"><input type="text" id="driver_date" name="driver_date" class="input_width"  readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(driver_date,tributton1);" />&nbsp;
					    </td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>驾驶证档案编号：</td>
				      	<td class="inquire_form6">
				      		<input type="text" id="doc_num" name="doc_num" class="input_width"></input>
				      	</td>
					 	<td class="inquire_item6"><font color="red">*</font>内部准驾证类型：</td>
					   	<td class="inquire_form6">
							<select id="driver_type" name="driver_type" class="select_width" onclick="ifDriverType()">
					          <option value="" >请选择</option>
					          <option value="1" >甲</option>
					          <option value="2" >乙</option>
					          <option value="3" >丙</option>
						    </select>
						</td>
						<td class="inquire_item6"><font id="ifDriverType" color="red" style="display: none;">*</font>人员职务：</td>
					    <td class="inquire_form6">
							<select id="duty" name="duty" class="select_width">
					          <option value="" >请选择</option>
					          <option value="1" >处级</option>
					          <option value="2" >科级</option>
					          <option value="3" >其他</option>
						    </select>
						</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>内部准驾车型：</td>
				      	<td class="inquire_form6">
				      		<select id="inner_type" name="inner_type" class="select_width">
					          <option value="" >请选择</option>
					          <%
					          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000033' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
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
					 	<td class="inquire_item6"><font color="red">*</font>准驾证编号：</td>
					   	<td class="inquire_form6">
							<input type="text" id="driving_num" name="driving_num" class="input_width"></input>
						</td>
						<td class="inquire_item6"><font color="red">*</font>发证单位：</td>
					    <td class="inquire_form6">
							<input type="text" id="driving_org" name="driving_org" class="input_width"></input>
						</td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6"><font color="red">*</font>签发人：</td>
				      	<td class="inquire_form6">
				      		<input type="text" id="signer" name="signer" class="input_width"></input>
				      	</td>
					 	<td class="inquire_item6"><font color="red">*</font>签发日期：</td>
					   	<td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width"  readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton2);" />&nbsp;
					    </td>
						<td class="inquire_item6"><font color="red">*</font>有效期：</td>
					    <td class="inquire_form6"><input type="text" id="useful_life" name="useful_life" class="input_width"  readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(useful_life,tributton3);" />&nbsp;
					    </td>
					  </tr>
					  <tr>
				     	<td class="inquire_item6">二级单位联系人：</td>
				      	<td class="inquire_form6">
				      		<input type="text" id="second_person" name="second_person" class="input_width"></input>
				      	</td>
					 	<td class="inquire_item6">联系人电话：</td>
					   	<td class="inquire_form6">
							<input type="text" id="phone" name="phone" class="input_width"></input>
						</td>
						<td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">备注</td>
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
	form.action="<%=contextPath%>/hse/resource/addDriverk.srq";
	form.submit();
}

function ifDriverType(){
	var driverType = document.getElementById("driver_type").value;
	if(driverType=="2"){
		document.getElementById("ifDriverType").style.display = "";
	}else{
		document.getElementById("ifDriverType").style.display = "none";
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
	var employee_id = document.getElementById("employee_id").value;
	var person_status = document.getElementById("person_status").value;
	
	var danger_driver = document.getElementById("danger_driver").value;
	var special_driver = document.getElementById("special_driver").value;
	var type_num = document.getElementById("type_num").value;
	var driver_date = document.getElementById("driver_date").value;
	var doc_num = document.getElementById("doc_num").value;
	var driver_type = document.getElementById("driver_type").value;
	var duty = document.getElementById("duty").value;
	var inner_type = document.getElementById("inner_type").value;
	var driving_num = document.getElementById("driving_num").value;
	var driving_org = document.getElementById("driving_org").value;
	var signer = document.getElementById("signer").value;
	var sign_date = document.getElementById("sign_date").value;
	var useful_life = document.getElementById("useful_life").value;
	if(employee_id==""){
		alert("人员姓名不能为空，请选择！");
		return true;
	}
	if(person_status==""){
		alert("是否在岗不能为空，请填写！");
		return true;
	}
	if(danger_driver==""){
		alert("是否危化品驾驶员不能为空，请选择！");
		return true;
	}
	if(special_driver==""){
		alert("是否特殊车辆驾驶员不能为空，请选择！");
		return true;
	}
	if(type_num==""){
		alert("准驾车型代号不能为空，请选择！");
		return true;
	}
	if(driver_date==""){
		alert("驾驶证初领日期不能为空，请填写！");
		return true;
	}
	if(doc_num==""){
		alert("驾驶证档案编号不能为空，请填写！");
		return true;
	}
	if(driver_type==""){
		alert("内部准驾证类型不能为空，请选择！");
		return true;
	}
	if(driver_type=="2"){
		if(duty==""){
			alert("人员职务不能为空，请填写！");
			return true;
		}
	}
	if(inner_type==""){
		alert("内部准驾车型不能为空，请选择！");
		return true;
	}
	if(driving_num==""){
		alert("准驾证编号不能为空，请填写！");
		return true;
	}
	if(driving_org==""){
		alert("发证单位不能为空，请填写！");
		return true;
	}
	if(signer==""){
		alert("签发人不能为空，请填写！");
		return true;
	}
	if(sign_date==""){
		alert("签发日期不能为空，请填写！");
		return true;
	}
	if(useful_life==""){
		alert("有效期不能为空，请填写！");
		return true;
	}
	return false;
}


</script>
</html>