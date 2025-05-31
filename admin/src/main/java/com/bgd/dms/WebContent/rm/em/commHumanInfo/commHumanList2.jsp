<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String laborCategory = request.getParameter("laborCategory");
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String folderId = "";
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
	}
	String orgSubId = request.getParameter("orgSubId");
	System.out.println(orgSubId);
	
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getOrgSubjectionId();
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
	
	String employeeId = request.getParameter("employeeId");
	String projectInfoNo = request.getParameter("projectInfoNo");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>人员信息</title>
</head>

<body style="background:#fff"  onload="loadDataDetail()">
      	<div id="list_table">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_8"><a href="#" onclick="getTab3(8)">国际部专属信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">项目经历</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">培训经历</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">资格证书</a></li>
			    <li id="tag3_9" ><a href="#" onclick="getTab3(9)">作业信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">黑名单</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">附件</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">备注</a></li>
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">姓名：</td>
				      <td   class="inquire_form6"><input id="employee_name" class="input_width" type="text" value=""/> &nbsp; <input id="labor_id" class="input_width" type="hidden" value=""/></td>
				      <td  class="inquire_item6">&nbsp;性别：</td>
				      <td  class="inquire_form6"><input id="employee_gender_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">健康信息：</td>
					  <td  class="inquire_form6"><input id="employee_health_info" class="input_width" type="text"  value=""/> &nbsp;</td>
				      </tr>
				     <tr >
				     <td  class="inquire_item6">出生年月：</td>
				     <td  class="inquire_form6"><input id="employee_birth_date" class="input_width" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">民族：</td>
				     <td  class="inquire_form6"><input id="employee_nation_name" class="input_width" type="text"  value=""/> &nbsp;</td>  
				     <td  class="inquire_item6">是否骨干：</td>
					  <td  class="inquire_form6"><input id="elite_if_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				     </tr>
				    <tr> 
				    <td  class="inquire_item6">身份证号：</td>
				    <td  class="inquire_form6"><input id="employee_id_code_no" class="input_width" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">文化程度：</td>
				    <td  class="inquire_form6"><input id="employee_education_level_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">家庭住址：</td>
					<td  class="inquire_form6"><input id="employee_address" class="input_width" type="text"  value=""/> &nbsp;</td>
				    </tr>
			 
				 <tr >
				 <td  class="inquire_item6">班组：</td>
				 <td  class="inquire_form6"><input id="apply_teams" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td  class="inquire_item6">岗位：</td>
				 <td  class="inquire_form6"><input id="posts" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td  class="inquire_item6">联系电话：</td>
				   <td  class="inquire_form6"><input id="phone_num" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr>
				<td  class="inquire_item6">用工来源：</td>
				<td  class="inquire_form6"><input id="workerfrom_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">技术职称：</td>
				<td  class="inquire_form6"><input id="technical_title_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">手机号码：</td>
				<td  class="inquire_form6"><input id="mobile_number" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
		 
				<tr >
				<td  class="inquire_item6">组织机构：</td>
				<td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">用工性质：</td>
				<td  class="inquire_form6"><input id="if_engineer_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">项目状态：</td>
				<td  class="inquire_form6"><input id="if_project_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
				<tr>
				<td  class="inquire_item6">邮编：</td>
				<td  class="inquire_form6"><input id="postal_code" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">劳动合同：</td>
				<td  class="inquire_form6"><input id="cont_num" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">技能：</td>
				<td  class="inquire_form6"  ><input id="specialty" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
				<tr>
				<td  class="inquire_item6">用工分布：</td>
				<td  class="inquire_form6"><input id="labor_distribution" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">国籍：</td>
				<td  class="inquire_form6"><input id="nationality_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">户籍类型：</td>
				<td  class="inquire_form6"><input id="household_type"  class="input_width" type="text" readonly />&nbsp;</td> 
				
				</tr>
				  </table>
				</div>
				
				<div id="tab_box_content8" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
				      <td class="inquire_item6">机构类别：</td>
				      <td class="inquire_form6" ><input id="institutions_type" class="input_width" type="text" readonly/></td>
				      <td class="inquire_item6">基层单位：</td>
				      <td class="inquire_form6" ><input id="grass_root_unit" class="input_width" type="text" readonly/></td> 
				      <td class="inquire_item6">出国(或国内上班)时间：</td>
				      <td class="inquire_form6" ><input id="go_abroad_time" class="input_width" type="text" readonly/></td>
			    </tr>
			    
			    <tr>				   
			      <td class="inquire_item6">回国时间：</td>
			      <td class="inquire_form6" ><input id="home_time" class="input_width" type="text" readonly/></td> 			     
			      <td class="inquire_item6">目前状态：</td>
			      <td class="inquire_form6" ><input id="present_state" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 现岗位起始日期：</td>
			      <td class="inquire_form6" ><input id="now_start_date" class="input_width" type="text" readonly/></td> 
		       </tr>
			    <tr>
			      <td class="inquire_item6">执行日期：</td>
			      <td class="inquire_form6" ><input id="implementation_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 户口所在地：</td>
			      <td class="inquire_form6" ><input id="account_place" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item6">起薪日期：</td>
			      <td class="inquire_form6" ><input id="start_salary_date" class="input_width" type="text" readonly/></td>
		       </tr>
			    <tr> 
			      <td class="inquire_item6">技术职称资格时间：</td>
			      <td class="inquire_form6" ><input id="technical_time" class="input_width" type="text" readonly/></td>  
			      <td class="inquire_item6">岗位序列：</td>
			      <td class="inquire_form6" ><input id="post_sequence" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 岗位对应考试标准：</td>
			      <td class="inquire_form6" ><input id="post_exam" class="input_width" type="text" readonly/></td> 
		       </tr> 
			    <tr>
			      <td class="inquire_item6">托福总分：</td>
			      <td class="inquire_form6" ><input id="toefl_score" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 托福听力：</td>
			      <td class="inquire_form6" ><input id="tofel_listening" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item6">是否合格：</td>
			      <td class="inquire_form6" ><input id="if_qualified" class="input_width" type="text" readonly/></td>
		       </tr>
			    <tr> 
			      <td class="inquire_item6"> 900句成绩：</td>
			      <td class="inquire_form6" ><input id="nine_result" class="input_width" type="text" readonly/></td>  
			      <td class="inquire_item6">是否合格：</td>
			      <td class="inquire_form6" ><input id="if_qualifieds" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 托业成绩：</td>
			      <td class="inquire_form6" ><input id="holds_result" class="input_width" type="text" readonly/></td> 
		       </tr> 
			</table>
			</div>				
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">项目名称</td>
			            <td class="bt_info_odd">班组</td>
			            <td class="bt_info_even">岗位</td>
			            <td class="bt_info_odd">劳动合同编号</td>
			            <td class="bt_info_even">进入项目时间</td>
			            <td class="bt_info_odd"> 离开项目时间</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table id="peixunMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
		    	<tr>
		    	    <td  class="bt_info_odd">序号</td>
		            <td class="bt_info_even">起止时间</td>
		            <td class="bt_info_odd">培训项目名称</td>		
		            <td class="bt_info_even">证书编号</td>
		            <td class="bt_info_odd">签发机构</td>			
		            <td class="bt_info_even">签发日期</td>          
		            <td class="bt_info_odd">发证地点</td>
		        </tr>
		        </table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<table id="zigeMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
		    	<tr>
		    	  <td  class="bt_info_odd">序号</td>
		            <td class="bt_info_even">证书类别</td>
		            <td class="bt_info_odd">证书编号</td>		
		            <td class="bt_info_even">培训机构</td>
		            <td class="bt_info_odd">签发单位</td>			
		            <td class="bt_info_even">签发日期</td>          
		            <td class="bt_info_odd">有效期</td>
		        </tr>
		        </table>
				</div>
				<div id="tab_box_content9" class="tab_box_content" style="display:none;">
				<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
		    	<tr class="bt_info">
		    	    <td>序号</td>
		    	    <td>作业名称</td>
		            <td>计划开始时间</td>
		            <td>计划结束时间</td>		
		            <td>原定工期</td>	
		        </tr>            
	            </table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td class="ali3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td class="ali1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td class="ali3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td class="ali1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td>&nbsp;</td>
				    <td colspan='7'>
			 
				        <auth:ListButton functionId="" css="zj" event="onclick='toAddBlack()'" title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="" css="xg" event="onclick='toEditBlack()'" title="JCDP_btn_edit"></auth:ListButton>
					    <auth:ListButton functionId="" css="sc" event="onclick='toDeleteBlack()'" title="JCDP_btn_delete"></auth:ListButton>
				    </td>
				  </tr>
				</table>
				</td>
				    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				  </tr>
				</table>
					<table  id="blackListMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					 
					  <tr>
					    <td class="bt_info_odd">选择</td>
			    	    <td class="bt_info_even">序号</td>
			            <td  class="bt_info_odd">项目名称</td>
			            <td class="bt_info_even">列入黑名单日期</td>		
			            <td  class="bt_info_odd">列入黑名单原因</td>
					  </tr>
					</table>
				</div>
				
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content7" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
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

	var ids = '<%=employeeId%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	function loadDataDetail(){
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    
	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+ids;
	
	    var retObj = jcdpCallService("HumanLaborMessageSrv", "getLaborInfo", "laborId="+ids);
	    
		document.getElementById("employee_name").value =retObj.employeeMap.employee_name;
		document.getElementById("employee_gender_name").value = retObj.employeeMap.employee_gender_name;
		document.getElementById("employee_birth_date").value = retObj.employeeMap.employee_birth_date;
		document.getElementById("employee_nation_name").value = retObj.employeeMap.employee_nation_name;
		document.getElementById("employee_id_code_no").value = retObj.employeeMap.employee_id_code_no;
		document.getElementById("employee_education_level_name").value = retObj.employeeMap.employee_education_level_name;
		document.getElementById("employee_address").value = retObj.employeeMap.employee_address;
		document.getElementById("phone_num").value = retObj.employeeMap.phone_num;
		document.getElementById("employee_health_info").value = retObj.employeeMap.employee_health_info;
		document.getElementById("elite_if_name").value = retObj.employeeMap.elite_if_name;
		document.getElementById("apply_teams").value = retObj.employeeMap.apply_teams;
		document.getElementById("posts").value = retObj.employeeMap.posts;
		document.getElementById("workerfrom_name").value = retObj.employeeMap.workerfrom_name;
		document.getElementById("technical_title_name").value = retObj.employeeMap.technical_title_name;
		document.getElementById("mobile_number").value = retObj.employeeMap.mobile_number;
		document.getElementById("if_project_name").value = retObj.employeeMap.if_project_name;
		document.getElementById("org_name").value = retObj.employeeMap.org_name;
		document.getElementById("if_engineer_name").value = retObj.employeeMap.if_engineer_name;
		document.getElementById("postal_code").value = retObj.employeeMap.postal_code;
		document.getElementById("cont_num").value = retObj.employeeMap.cont_num;
		document.getElementById("specialty").value = retObj.employeeMap.specialty;
		document.getElementById("labor_id").value = retObj.employeeMap.labor_id;
		document.getElementById("labor_distribution").value = retObj.employeeMap.labor_distribution;
		document.getElementById("nationality_name").value = retObj.employeeMap.nationality_name;
		document.getElementById("household_type").value = retObj.employeeMap.household_type;
		
		document.getElementById("institutions_type").value = retObj.employeeMap.institutions_type;
		document.getElementById("grass_root_unit").value = retObj.employeeMap.grass_root_unit;
		document.getElementById("go_abroad_time").value = retObj.employeeMap.go_abroad_time;
		document.getElementById("home_time").value = retObj.employeeMap.home_time;
		document.getElementById("present_state").value = retObj.employeeMap.present_state_name;
		document.getElementById("now_start_date").value = retObj.employeeMap.now_start_date;
		document.getElementById("implementation_date").value = retObj.employeeMap.implementation_date;
		document.getElementById("account_place").value = retObj.employeeMap.account_place;
		document.getElementById("start_salary_date").value = retObj.employeeMap.start_salary_date;
		document.getElementById("technical_time").value = retObj.employeeMap.technical_time;
		document.getElementById("post_sequence").value = retObj.employeeMap.post_sequence;
		document.getElementById("post_exam").value = retObj.employeeMap.post_exam;
		document.getElementById("toefl_score").value = retObj.employeeMap.toefl_score;
		document.getElementById("tofel_listening").value = retObj.employeeMap.tofel_listening;
		document.getElementById("if_qualified").value = retObj.employeeMap.if_qualified;
		document.getElementById("nine_result").value = retObj.employeeMap.nine_result;
		document.getElementById("if_qualifieds").value = retObj.employeeMap.if_qualifieds;
		document.getElementById("holds_result").value = retObj.employeeMap.holds_result;
		
		
		deleteTableTr("projectMap");	   //项目信息  
		if(retObj.projectMap != null){
			
			for(var i=0;i<retObj.projectMap.length;i++){
				var project = retObj.projectMap[i];					
				var tr = document.getElementById("projectMap").insertRow();		
              	if(i % 2 == 1){  
              		classCss = "even_";
				}else{ 
					classCss = "odd_";
				}
              	var td = tr.insertCell(0);
				td.className=classCss+"odd";
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.className=classCss+"even";
				td.innerHTML = project.project_name;
				
				var td = tr.insertCell(2);
				td.className=classCss+"odd";
				td.innerHTML = project.apply_team_name;

				var td = tr.insertCell(3);
				td.className=classCss+"even";
				td.innerHTML = project.post_name;
				
				var td = tr.insertCell(4);
				td.className=classCss+"odd";
				td.innerHTML = project.cont_num;
								
				var td = tr.insertCell(5);
				td.className=classCss+"even";
				td.innerHTML =project.start_date;
				
				var td = tr.insertCell(6);
				td.className=classCss+"odd";
				td.innerHTML = project.end_date;
				
 			
			}
		}
		
		deleteTableTr("blackListMap");    //黑名单信息
		if(retObj.blackListMap != null){
			
			for(var i=0;i<retObj.blackListMap.length;i++){
				var blackList = retObj.blackListMap[i];					
				var tr2 = document.getElementById("blackListMap").insertRow();	
	         	if(i % 2 == 1){  
              		classCss = "even_";
				}else{ 
					classCss = "odd_";
				}
	         	var td2 = tr2.insertCell(0);
				td2.className=classCss+"odd";
				td2.innerHTML = '<input type="radio" name="chx_entity_id" value="'+blackList.list_id+'">';
				
				var td2 = tr2.insertCell(1);
				td2.className=classCss+"even";
				td2.innerHTML = i+1;
				
	         	var td2 = tr2.insertCell(2);
				td2.className=classCss+"odd";
				td2.innerHTML =blackList.project_name;
				
				var td2 = tr2.insertCell(3);
				td2.className=classCss+"even";
				td2.innerHTML = blackList.list_date;
				
	         	var td2 = tr2.insertCell(4);
				td2.className=classCss+"odd";
				td2.innerHTML =blackList.list_reason;
				
			 	
			}
		}
		 
		
		var querySql = querySql = "select rownum,p.* from (select a.name,a.planned_duration,a.planned_start_date,a.planned_finish_date from bgp_comm_human_receive_labor t left join bgp_p6_activity a on t.task_id=a.object_id and a.bsflag='0' where t.bsflag='0' and t.project_info_no ='"+projectInfoNos+"' and t.labor_id='"+ids+"') p ";							   
	    var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);		
	    var datas = queryRet.datas;
	    deleteTableTr("planDetailList");
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
			
				var tr = document.getElementById("planDetailList").insertRow();		
				
	          	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
					
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].planned_start_date;
	
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].planned_finish_date;

				var td = tr.insertCell(4);
				td.innerHTML = datas[i].planned_duration;
			}
		}
	}
	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	 function toUploadFile(){
		   var orgId='<%=orgId%>';
		   var subId='<%=orgSubjectionId%>';
			popWindow('<%=contextPath%>/rm/em/humanLabor/humanImportFile.jsp?laborCategory=<%=laborCategory%>&orgId='+orgId+'&subId='+subId);
	 }
	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdds(){
		popWindow('<%=contextPath%>/doc/singleproject/upload_file.jsp?id='+folderid);
		//popWindow('<%=contextPath%>/doc/singleproject/close_page.jsp');
	}
	  function init_down(){
			 
		  	var ids = getSelIds("chx_entity_id");
		  	if(ids==""){
		  		 ids = getObj("chx_entity_id").value;
		  	}		
			self.parent.frames["mainFrame"].location="<%=contextPath %>/rm/em/getLaborInfo.srq?laborId="+ids; 	  	
		}
	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			window.location="<%=contextPath%>/doc/delDocInFolder.srq?docId="+ids+"&folderid=<%=folderId%>"; 
			return true;
		}else{
			return false;
		}    

	}
	
	 

 
	  function toAdd(){ 
		  popWindow("<%=contextPath%>/rm/em/humanLabor/laborModify.upmd?laborCategory=<%=laborCategory%>&pagerAction=edit2Add");
	  }  
	  
	  function toEdit(){  
		  ids = getSelectedValue();
	  	  if(ids==''){  
	  		  alert("请选择一条信息!");  
	  		  return;  
	  	  }  
	      selId = ids.split(',')[0]; 
	      editUrl = "<%=contextPath%>/rm/em/humanLabor/laborModify.upmd?laborCategory=<%=laborCategory%>&id={id}";  
	      editUrl = editUrl.replace('{id}',selId); 
 
	      editUrl += '&pagerAction=edit2Edit';
	      popWindow(editUrl); 
	  } 
	  
	 
		function toDelete(){
	 		
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("HumanLaborMessageSrv", "deleteUpdate", "laborId="+ids);
				queryData(cruConfig.currentPage);
			}
		}
		
		function toAddBlack(){
			var namet=document.getElementById("employee_name").value;
			var userName="userName="+namet+"";
			var userGex=document.getElementById("employee_id_code_no").value;
			var  laborId=document.getElementById("labor_id").value;
		    if(laborId==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
			popWindow("<%=contextPath%>/rm/em/humanLabor/blackLabor.jsp?"+userName+"&userGex="+userGex+"&laborId="+laborId);  
			//window.open ('<%=contextPath%>/rm/em/humanLabor/laborBlistModify.jsp?pagerAction=edit2Add&action=add&'+userName+'&userGex='+userGex+'&laborId='+laborId, 'newwindow', 'height=450, width=600, top=150,left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	  	
		}
		function toEditBlack(){
			var namet=document.getElementById("employee_name").value;
			var userName="&userName="+namet;
		 
			var userGex=document.getElementById("employee_id_code_no").value;
			var  laborId=document.getElementById("labor_id").value;
			var obj=document.getElementsByName("chx_entity_id");
 
		    var ids='';
			for (i=0;i<obj.length;i++){  //遍历Radio  
				if(obj[i].checked){
					    ids=obj[i].value;	
					 
				}  
			}
	 
			if (ids==''){ 
				alert('请选中一条记录！');
			}else{ 
				 popWindow("<%=contextPath%>/rm/em/humanLabor/blackLabor.jsp?id="+ids+userName+"&laborId="+laborId+"&userGex="+userGex);
			     queryData(cruConfig.currentPage);
			}	 
 
			
		}
		
       function toDeleteBlack(){
	 		
    		var obj=document.getElementsByName("chx_entity_id");
    		 
   		    var ids='';
   			for (i=0;i<obj.length;i++){  //遍历Radio  
   				if(obj[i].checked){
   					    ids=obj[i].value;	
   					 
   				}  
   			}
   	 
   			if (ids==''){
   				
   				alert('请选中一条记录！');
   			}else{
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("HumanLaborMessageSrv", "deleteUpdateBlack", "listId="+ids);
				var shuaId=document.getElementById("labor_id").value;
				loadDataDetail(shuaId);
			}
   			}	
		}
		
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
       
</script>

</html>

