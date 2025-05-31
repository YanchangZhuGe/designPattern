<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String ids = request.getParameter("ids");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

  <title>JCDP_em_human_employee</title> 
 </head> 
 
 <body style="background:#fff" onload="getComm()">
 
		<div id="tab_box_content0" class="tab_box_content">
				<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>		

					    <td>&nbsp;</td>
					    <auth:ListButton functionId="" css="gb" event="onclick='newClose()'" title="JCDP_btn_return"></auth:ListButton> 
					  </tr>
					</table>
					</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					  </tr>
					</table>
				</div>
		
				<table id="employeeMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
			    <tr>
			      <td class="inquire_item8">人员编号：</td>
			      <td class="inquire_form8" ><input id="employee_cd1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">姓名：</td>
			      <td class="inquire_form8" ><input id="employee_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">性别：</td>
			      <td class="inquire_form8" ><input id="employee_gender1"  class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">年龄：</td>
			      <td class="inquire_form8" ><input id="age1" class="input_width" type="text" readonly/></td>
			      <td rowspan="5">
			      		<img id="human_image1" src="<%=contextPath%>/humanPhoto/zhaopian.JPG"
							style="width: 85px; height: 120px" /></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">出生年月：</td>
			      <td class="inquire_form8" ><input id="employee_birth_date1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">民族：</td>
			      <td class="inquire_form8" ><input id="employee_nation_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">国籍：</td>
			      <td class="inquire_form8" ><input id="nationality_name1" class="input_width" type="text" readonly/> </td>
			      <td class="inquire_item8">文化程度：</td>
			      <td class="inquire_form8" ><input id="employee_education_level_name1" class="input_width" type="text" readonly/> </td>
			    </tr>
			    <tr>
			      <td class="inquire_item8">组织机构：</td>
			      <td class="inquire_form8" ><input id="org_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">岗位：</td>
			      <td class="inquire_form8" ><input id="post1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">岗位类别：</td>
			      <td class="inquire_form8" ><input id="post_sort_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">职位级别：</td>
			      <td class="inquire_form8" ><input id="post_level_name1" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">用工来源：</td>
			      <td class="inquire_form8" ><input id="workerfrom_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">员工类型：</td>
			      <td class="inquire_form8" ><input id="employee_gz_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">参加工作时间：</td>
			      <td class="inquire_form8" ><input id="work_date1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">进入中石油时间：</td>
			      <td class="inquire_form8" ><input id="work_cnpc_date1" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>			     
			      <td class="inquire_item8">设置班组：</td>
			      <td class="inquire_form8" ><input id="set_team_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">设置岗位：</td>
			      <td class="inquire_form8" ><input id="set_post_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">用工分布：</td>
			      <td class="inquire_form8" ><input id="spare7" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item8">邮箱：</td>
			      <td class="inquire_form8" ><input id="mail_address1" class="input_width" type="text" readonly/></td>
			      </tr>     
			     <tr> 			     			      
			      <td class="inquire_item8">外语语种：</td>
			      <td class="inquire_form8" ><input id="language_sort_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">外语级别：</td>
			      <td class="inquire_form8" ><input id="language_level_name1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">固定电话：</td>
			      <td class="inquire_form8" ><input id="phone_num1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">手机：</td>
			      <td class="inquire_form8" ><input id="employee_mobile_phone1" class="input_width" type="text" readonly/></td>
			    </tr>
			    <tr> 
			      <td class="inquire_item8">家庭住址：</td>
			      <td class="inquire_form8" ><input id="home_address1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">常用邮箱：</td>
			      <td class="inquire_form8" ><input id="e_mail1" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">QQ号码：</td>
			      <td class="inquire_form8"><input id="qq1"  class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">&nbsp;</td>
			      <td class="inquire_form8">&nbsp;</td>
			    </tr>
			</table>
			<table id="laborMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="display:none;">	
				<tr>
			     <td class="inquire_item8">姓名：</td>
			     <td class="inquire_form8"><input id="employee_name2" class="input_width" type="text" value=""/> &nbsp; <input id="labor_id" class="input_width" type="hidden" value=""/></td>
			     <td class="inquire_item8">性别：</td>
			     <td class="inquire_form8"><input id="employee_gender_name2" class="input_width" type="text"  value=""/> &nbsp;</td>
			     <td class="inquire_item8">健康信息：</td>
				 <td class="inquire_form8"><input id="employee_health_info2" class="input_width" type="text"  value=""/> &nbsp;</td>
				 <td class="inquire_item8">出生年月：</td>
				 <td class="inquire_form8"><input id="employee_birth_date2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr>
				 <td class="inquire_item8">民族：</td>
				 <td class="inquire_form8"><input id="employee_nation_name2" class="input_width" type="text"  value=""/> &nbsp;</td>  
				 <td class="inquire_item8">是否骨干：</td>
				 <td class="inquire_form8"><input id="elite_if_name2" class="input_width" type="text"  value=""/> &nbsp;</td>
				 <td class="inquire_item8">身份证号：</td>
				 <td class="inquire_form8"><input id="employee_id_code_no2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td class="inquire_item8">文化程度：</td>
				 <td class="inquire_form8"><input id="employee_education_level_name2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr> 
				 <td class="inquire_item8">家庭住址：</td>
				 <td class="inquire_form8"><input id="employee_address2" class="input_width" type="text"  value=""/> &nbsp;</td>
				 <td class="inquire_item8">班组：</td>
				 <td class="inquire_form8"><input id="apply_teams2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td class="inquire_item8">岗位：</td>
				 <td class="inquire_form8"><input id="posts2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td class="inquire_item8">联系电话：</td>
				 <td class="inquire_form8"><input id="phone_num2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr>
				<td class="inquire_item8">用工来源：</td>
				<td class="inquire_form8"><input id="workerfrom_name2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td class="inquire_item8">技术职称：</td>
				<td class="inquire_form8"><input id="technical_title_name2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td class="inquire_item8">手机号码：</td>
				<td class="inquire_form8"><input id="mobile_number2" class="input_width" type="text"  value=""/> &nbsp;</td>
				<td class="inquire_item8">组织机构：</td>
				<td class="inquire_form8"><input id="org_name2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>		 
				<tr>
				<td class="inquire_item8">用工性质：</td>
				<td class="inquire_form8"><input id="if_engineer_name2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td class="inquire_item8">项目状态：</td>
				<td class="inquire_form8"><input id="if_project_name2" class="input_width" type="text"  value=""/> &nbsp;</td>
				<td class="inquire_item8">邮编：</td>
				<td class="inquire_form8"><input id="postal_code2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td class="inquire_item8">劳动合同：</td>
				<td class="inquire_form8"><input id="cont_num2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr>
				<td class="inquire_item8">技能：</td>
				<td class="inquire_form8"><input id="specialty2" class="input_width" type="text"  value=""/> &nbsp;</td>
				<td class="inquire_item8">用工分布：</td>
				<td class="inquire_form8"><input id="labor_distribution2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td class="inquire_item8">国籍：</td>
				<td class="inquire_form8"><input id="nationality_name2" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
		     </table>				
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";


 
	function getComm(ids){
		
		var ids = "<%=ids%>";
 
		var retObj = jcdpCallService("HumanLaborMessageSrv", "getCommInfo", "id="+ids.split("-")[0]+"&employeeGz="+ids.split("-")[1]);
		
		 if("0110000019000000001,0110000019000000002".indexOf(ids.split("-")[1]) != -1){
			document.getElementById("employeeMap").style.display="block"; 
			document.getElementById("laborMap").style.display="none"; 
			var employee_cd = retObj.employeeMap.employee_cd;
			document.getElementById("employee_cd1").value = employee_cd;
			document.getElementById("employee_name1").value = retObj.employeeMap.employee_name;
			document.getElementById("employee_gender1").value = retObj.employeeMap.employee_gender;
			document.getElementById("age1").value = retObj.employeeMap.age;
			document.getElementById("employee_birth_date1").value = retObj.employeeMap.employee_birth_date;
			document.getElementById("employee_nation_name1").value = retObj.employeeMap.employee_nation_name;
			document.getElementById("nationality_name1").value = retObj.employeeMap.nationality_name;
			document.getElementById("employee_education_level_name1").value = retObj.employeeMap.employee_education_level_name;
			document.getElementById("post1").value = retObj.employeeMap.post;
			document.getElementById("post_sort_name1").value = retObj.employeeMap.post_sort_name;
			document.getElementById("post_level_name1").value = retObj.employeeMap.post_level_name;
			document.getElementById("workerfrom_name1").value = retObj.employeeMap.workerfrom_name;
			document.getElementById("language_sort_name1").value = retObj.employeeMap.language_sort_name;
			document.getElementById("language_level_name1").value = retObj.employeeMap.language_level_name;
			document.getElementById("work_date1").value = retObj.employeeMap.work_date;
			document.getElementById("work_cnpc_date1").value = retObj.employeeMap.work_cnpc_date;
			document.getElementById("org_name1").value = retObj.employeeMap.org_name;
			document.getElementById("mail_address1").value = retObj.employeeMap.mail_address;
			document.getElementById("phone_num1").value = retObj.employeeMap.phone_num;
			document.getElementById("employee_mobile_phone1").value = retObj.employeeMap.employee_mobile_phone;
			document.getElementById("set_team_name1").value = retObj.employeeMap.set_team_name;
			document.getElementById("set_post_name1").value = retObj.employeeMap.set_post_name;
			document.getElementById("spare7").value = retObj.employeeMap.spare7;
			document.getElementById("home_address1").value = retObj.employeeMap.home_address;
			document.getElementById("qq1").value = retObj.employeeMap.qq;
			document.getElementById("e_mail1").value = retObj.employeeMap.e_mail;
			document.getElementById("human_image1").src = "http://10.88.2.241:8080/hr_photo/"+employee_cd.substr(0,5)+"/"+employee_cd+".JPG";
			
		 }else{
			document.getElementById("employeeMap").style.display="none";
			document.getElementById("laborMap").style.display="block";  
			document.getElementById("employee_name2").value =retObj.employeeMap.employee_name;
			document.getElementById("employee_gender_name2").value = retObj.employeeMap.employee_gender_name;
			document.getElementById("employee_birth_date2").value = retObj.employeeMap.employee_birth_date;
			document.getElementById("employee_nation_name2").value = retObj.employeeMap.employee_nation_name;
			document.getElementById("employee_id_code_no2").value = retObj.employeeMap.employee_id_code_no;
			document.getElementById("employee_education_level_name2").value = retObj.employeeMap.employee_education_level_name;
			document.getElementById("employee_address2").value = retObj.employeeMap.employee_address;
			document.getElementById("phone_num2").value = retObj.employeeMap.phone_num;
			document.getElementById("employee_health_info2").value = retObj.employeeMap.employee_health_info;
			document.getElementById("elite_if_name2").value = retObj.employeeMap.elite_if_name;
			document.getElementById("apply_teams2").value = retObj.employeeMap.apply_teams;
			document.getElementById("posts2").value = retObj.employeeMap.posts;
			document.getElementById("workerfrom_name2").value = retObj.employeeMap.workerfrom_name;
			document.getElementById("technical_title_name2").value = retObj.employeeMap.technical_title_name;
			document.getElementById("mobile_number2").value = retObj.employeeMap.mobile_number;
			document.getElementById("if_project_name2").value = retObj.employeeMap.if_project_name;
			document.getElementById("org_name2").value = retObj.employeeMap.org_name;
			document.getElementById("if_engineer_name2").value = retObj.employeeMap.if_engineer_name;
			document.getElementById("postal_code2").value = retObj.employeeMap.postal_code;
			document.getElementById("cont_num2").value = retObj.employeeMap.cont_num;
			document.getElementById("specialty2").value = retObj.employeeMap.specialty;
			document.getElementById("labor_id2").value = retObj.employeeMap.labor_id;
			document.getElementById("labor_distribution2").value = retObj.employeeMap.labor_distribution;
			document.getElementById("nationality_name2").value = retObj.employeeMap.nationality_name;
		 }
		
	} 

	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

</script>
</html>