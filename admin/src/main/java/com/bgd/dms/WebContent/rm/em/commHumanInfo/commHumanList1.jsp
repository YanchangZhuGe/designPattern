<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	

	String employeeId = request.getParameter("employeeId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	
	

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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <title>JCDP_em_human_employee</title> 
 </head> 
 
 <body style="background:#fff" onload="loadDataDetail()">
      	<div id="list_table">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">人员基本信息</a></li>
			    <li id="tag3_8"><a href="#" onclick="getTab3(8)">国际部专属信息</a></li>
			    <li id="tag3_9"><a href="#" onclick="getTab3(9)">借聘信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作履历</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">项目经历</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">培训信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">教育经历</a></li>
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">资格证书</a></li>
			    <li id="tag3_11"><a href="#" onclick="getTab3(11)">作业信息</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">附件</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">备注</a></li>
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item8">人员编号：</td>
			      <td class="inquire_form8" ><input id="employee_cd" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">姓名：</td>
			      <td class="inquire_form8" ><input id="employee_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">性别：</td>
			      <td class="inquire_form8" ><input id="employee_gender"  class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">年龄：</td>
			      <td class="inquire_form8" ><input id="age" class="input_width" type="text" readonly/></td>
			      <td rowspan="5">
			      		<img id="human_image" src="<%=contextPath%>/humanPhoto/zhaopian.JPG"
							style="width: 85px; height: 120px" /></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">出生年月：</td>
			      <td class="inquire_form8" ><input id="employee_birth_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">民族：</td>
			      <td class="inquire_form8" ><input id="employee_nation_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">国籍：</td>
			      <td class="inquire_form8" ><input id="nationality_name" class="input_width" type="text" readonly/> </td>
			      <td class="inquire_item8">文化程度：</td>
			      <td class="inquire_form8" ><input id="employee_education_level_name" class="input_width" type="text" readonly/> </td>
			    </tr>
			    <tr>
			      <td class="inquire_item8">组织机构：</td>
			      <td class="inquire_form8" ><input id="org_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">岗位：</td>
			      <td class="inquire_form8" ><input id="post" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">岗位类别：</td>
			      <td class="inquire_form8" ><input id="post_sort_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">职位级别：</td>
			      <td class="inquire_form8" ><input id="post_level_name" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">用工来源：</td>
			      <td class="inquire_form8" ><input id="workerfrom_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">员工类型：</td>
			      <td class="inquire_form8" ><input id="employee_gz_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">参加工作时间：</td>
			      <td class="inquire_form8" ><input id="work_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">进入中石油时间：</td>
			      <td class="inquire_form8" ><input id="work_cnpc_date" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>			     
			      <td class="inquire_item8">设置班组：</td>
			      <td class="inquire_form8" ><input id="set_team_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">设置岗位：</td>
			      <td class="inquire_form8" ><input id="set_post_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">用工分布：</td>
			      <td class="inquire_form8" ><input id="spare7" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item8">邮箱：</td>
			      <td class="inquire_form8" ><input id="mail_address" class="input_width" type="text" readonly/></td>
			      </tr>     
			     <tr> 			     			      
			      <td class="inquire_item8">外语语种：</td>
			      <td class="inquire_form8" ><input id="language_sort_name"class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">外语级别：</td>
			      <td class="inquire_form8" ><input id="language_level_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">固定电话：</td>
			      <td class="inquire_form8" ><input id="phone_num" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">手机：</td>
			      <td class="inquire_form8" ><input id="employee_mobile_phone" class="input_width" type="text" readonly/></td>
			    </tr>
			    <tr> 
			      <td class="inquire_item8">家庭住址：</td>
			      <td class="inquire_form8" ><input id="home_address" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">常用邮箱：</td>
			      <td class="inquire_form8" ><input id="e_mail" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">QQ号码：</td>
			      <td class="inquire_form8"><input id="qq"  class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">户籍类型：</td>
			      <td class="inquire_form8"><input id="household_type"  class="input_width" type="text" readonly/></td>
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
				
				<div id="tab_box_content9" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				     <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					 <td background="<%=contextPath%>/images/list_15.png">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">			  
						  <tr>			    
						    <td>&nbsp;</td>			   
						    <auth:ListButton functionId="" css="tj" event="onclick='toAddPin()'" title="JCDP_btn_submit"></auth:ListButton>		 
						  </tr>			  
					   </table>
					</td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				 </tr>
				</table><br>

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
				      <td class="inquire_item6">是否借聘：</td>
				      <td class="inquire_form6" >
					      <select id="pin_whether" name="pin_whether" onchange="selectChang()" class="select_width">
					       <option value="" >请选择</option>
					       <option value="0" >是</option>
					       <option value="1" >否</option> 
						  </select> 
				      </td>
				      
				      <td class="inquire_item6"><div id="divState" name="divState" style="display:block;" >借聘单位：</div></td>
				      <td class="inquire_form6" ><div id="divStates" name="divStates" style="display:block;" >
				      <input id="pin_unit" name="pin_unit" class="input_width" type="hidden"  />
				      <input id="pin_unit_name" name="pin_unit_name" class="input_width" type="text" readonly />
			          <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				      </div>
				      </td> 
			    </tr>
				</table>
				</div>
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="recordMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr  class="bt_info">
			    	    <td>序号</td>
			            <td>开始时间</td>
			            <td>结束时间</td>		
			            <td>工作单位</td>
			            <td>岗位</td>			
			            <td>行政级别</td>           
			            <td>技术职称</td>
			            <td>技能级别</td>
			        </tr>
			        </table>		
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr  class="bt_info">
			    	    <td>序号</td>
			            <td>项目名称</td>
			            <td>类型</td>		
			            <td>项目开始日期</td>
			            <td>项目结束日期</td>			
			            <td>进入项目日期</td>           
			            <td>离开项目日期</td>
			            <td>班组</td>
			            <td>岗位</td>
			            <td>人员评价</td>
			        </tr>            
			        </table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table id="trainMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr  class="bt_info">
				    	    <td>序号</td>
				            <td>开始时间</td>
				            <td>结束时间</td>		
				            <td>培训班名称</td>
				            <td>培训内容</td>			
				            <td>培训级别</td>          
				            <td>培训渠道</td>
				            <td>培训分类</td>
				            <td>培训形式</td>
				            <td>培训结果</td>
				            <td>培训地点</td>
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<table id="educationMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr  class="bt_info">
				    	    <td>序号</td>
				            <td>开始时间</td>
				            <td>结束时间</td>		
				            <td>毕业院校</td>
				            <td>所学专业</td>			
				            <td>学历</td> 
				        </tr>            
			        </table>
				</div>	
				<div id="tab_box_content10" class="tab_box_content" style="display:none;">
					<table id="certificateMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">	
				    		<td>序号</td>
				            <td>资格证编号</td>
				            <td>培训机构</td>			
				            <td>签发单位</td>          
				            <td>签发日期</td>
				            <td>有效期</td>
				            <td>附件</td>
				        </tr>            
			        </table>
				</div>			
				<div id="tab_box_content11" class="tab_box_content" style="display:none;">
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

	cruConfig.cdtType = 'form';

	var ids = '<%=employeeId%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	function loadDataDetail(){
		
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+ids;
	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    
	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+ids;
				
		var retObj = jcdpCallService("HumanCommInfoSrv", "getCommInfo", "employeeId="+ids);
		var employee_cd = retObj.employeeMap.employee_cd;
		document.getElementById("employee_cd").value = employee_cd;
		document.getElementById("employee_name").value = retObj.employeeMap.employee_name;
		document.getElementById("employee_gender").value = retObj.employeeMap.employee_gender;
		document.getElementById("age").value = retObj.employeeMap.age;
		document.getElementById("employee_birth_date").value = retObj.employeeMap.employee_birth_date;
		document.getElementById("employee_nation_name").value = retObj.employeeMap.employee_nation_name;
		document.getElementById("nationality_name").value = retObj.employeeMap.nationality_name;
		document.getElementById("employee_education_level_name").value = retObj.employeeMap.employee_education_level_name;
		document.getElementById("post").value = retObj.employeeMap.post;
		document.getElementById("post_sort_name").value = retObj.employeeMap.post_sort_name;
		document.getElementById("post_level_name").value = retObj.employeeMap.post_level_name;
		document.getElementById("workerfrom_name").value = retObj.employeeMap.workerfrom_name;
		document.getElementById("employee_gz_name").value = retObj.employeeMap.employee_gz_name;
		document.getElementById("language_sort_name").value = retObj.employeeMap.language_sort_name;
		document.getElementById("language_level_name").value = retObj.employeeMap.language_level_name;
		document.getElementById("work_date").value = retObj.employeeMap.work_date;
		document.getElementById("work_cnpc_date").value = retObj.employeeMap.work_cnpc_date;
		document.getElementById("org_name").value = retObj.employeeMap.org_name;
		document.getElementById("mail_address").value = retObj.employeeMap.mail_address;
		document.getElementById("phone_num").value = retObj.employeeMap.phone_num;
		document.getElementById("employee_mobile_phone").value = retObj.employeeMap.employee_mobile_phone;
		document.getElementById("set_team_name").value = retObj.employeeMap.set_team_name;
		document.getElementById("set_post_name").value = retObj.employeeMap.set_post_name;
		document.getElementById("spare7").value = retObj.employeeMap.spare7;
		document.getElementById("home_address").value = retObj.employeeMap.home_address;
		document.getElementById("qq").value = retObj.employeeMap.qq;
		document.getElementById("e_mail").value = retObj.employeeMap.e_mail;
		document.getElementById("household_type").value = retObj.employeeMap.household_type;		
		document.getElementById("human_image").src = "http://10.88.2.241:8080/hr_photo/"+employee_cd.substr(0,5)+"/"+employee_cd+".JPG";
		 
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
		
	    document.getElementById("pin_whether").value=retObj.employeeMap.pin_whether;
		if(retObj.employeeMap.pin_whether == "1"){       	
        	document.getElementById("divState").style.display="none";
        	document.getElementById("divStates").style.display="none";
        }else if(retObj.employeeMap.pin_whether == "0"){       	
        	document.getElementById("divState").style.display="block";
        	document.getElementById("divStates").style.display="block";
        }else if(retObj.employeeMap.pin_whether == ""){       	
        	document.getElementById("divState").style.display="block";
        	document.getElementById("divStates").style.display="block";
        }
		
	    document.getElementById("pin_unit").value=retObj.employeeMap.pin_unit;
	    document.getElementById("pin_unit_name").value=retObj.employeeMap.pin_unit_name;
	    
		//删除列表中所有的行
		deleteTableTr("recordMap");
		deleteTableTr("projectMap");
		deleteTableTr("trainMap");
		deleteTableTr("educationMap");
		deleteTableTr("certificateMap");
     
     
		if(retObj.recordMap != null){			
			for(var i=0;i<retObj.recordMap.length;i++){
				var record = retObj.recordMap[i];					
				var tr = document.getElementById("recordMap").insertRow();	
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = record.start_date;
				
				var td = tr.insertCell(2);
				td.innerHTML = record.end_date;

				var td = tr.insertCell(3);
				td.innerHTML = record.company;
				
				var td = tr.insertCell(4);
				td.innerHTML = record.post;
				
				var td = tr.insertCell(5);
				td.innerHTML = record.administration;
				
				var td = tr.insertCell(6);
				td.innerHTML = record.technology;
				
				var td = tr.insertCell(7);
				td.innerHTML = record.skillname;

			}
		}
		
		if(retObj.projectMap != null){			
			for(var i=0;i<retObj.projectMap.length;i++){
				var project = retObj.projectMap[i];					
				var tr = document.getElementById("projectMap").insertRow();	
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = project.project_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = project.project_type_name;

				var td = tr.insertCell(3);
				td.innerHTML = project.plan_start_date;
				
				var td = tr.insertCell(4);
				td.innerHTML = project.plan_end_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = project.actual_start_date;
				
				var td = tr.insertCell(6);
				td.innerHTML =  project.actual_end_date;
				
				var td = tr.insertCell(7);
				td.innerHTML = project.teamname;

				var td = tr.insertCell(8);
				td.innerHTML = project.postname;
				
				var td = tr.insertCell(9);
				td.innerHTML = project.project_evaluate_name;	
						
			}
		}
		
		if(retObj.trainMap != null){			
			for(var i=0;i<retObj.trainMap.length;i++){
				var train = retObj.trainMap[i];					
				var tr = document.getElementById("trainMap").insertRow();	
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = train.start_date;
				
				var td = tr.insertCell(2);
				td.innerHTML = train.end_date;

				var td = tr.insertCell(3);
				td.innerHTML = train.class_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = train.train_content;
				
				var td = tr.insertCell(5);
				td.innerHTML = train.train_level;
				
				var td = tr.insertCell(6);
				td.innerHTML = train.train_channel;
				
				var td = tr.insertCell(7);
				td.innerHTML = train.train_sort;

				var td = tr.insertCell(8);
				td.innerHTML = train.train_form;
				
				var td = tr.insertCell(9);
				td.innerHTML = train.train_result;	
				
				var td = tr.insertCell(10);
				td.innerHTML = train.train_place;	
		
			}
		}

		if(retObj.educationMap != null){			
			for(var i=0;i<retObj.educationMap.length;i++){
				var education = retObj.educationMap[i];					
				var tr = document.getElementById("educationMap").insertRow();
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = education.start_date;
				
				var td = tr.insertCell(2);
				td.innerHTML = education.finish_date;

				var td = tr.insertCell(3);
				td.innerHTML = education.school_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = education.profess;
				
				var td = tr.insertCell(5);
				td.innerHTML = education.education;
				
			}
		}
		
		if(retObj.certificateMap != null){			
			for(var i=0;i<retObj.certificateMap.length;i++){
				var certificate = retObj.certificateMap[i];					
				var tr = document.getElementById("certificateMap").insertRow();
				
		    	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = certificate.certificate_num;
				
				var td = tr.insertCell(2);
				td.innerHTML = certificate.training_institutions;
				
				var td = tr.insertCell(3);
				td.innerHTML = certificate.issuing_agency;
				
				var td = tr.insertCell(4);
				td.innerHTML = certificate.issuing_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = certificate.validity;
				
				var td = tr.insertCell(6);
				var document_id = certificate.document_id;
				if(document_id !=''){
					td.innerHTML = "<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+document_id+"&emflag=0>下载</a>";
				}else{
					td.innerHTML = "";
				}
				
			}
		}
		
		var querySql = "select rownum,p.* from (select a.name,a.planned_duration,a.planned_start_date,a.planned_finish_date from bgp_comm_human_receive_process t left join bgp_p6_activity a on t.task_id=a.object_id and a.bsflag='0' where t.bsflag='0' and t.project_info_no ='"+projectInfoNos+"' and t.employee_id='"+ids+"') p ";							   
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
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	
	function selectChang(){
		var selectObj = document.getElementById("pin_whether");     
	    for(var i = 0; i<selectObj.length; i++){  
	      	if(selectObj.options[i].selected==true){
				if(selectObj.options[i].value == "1"){       	
		        	document.getElementById("divState").style.display="none";
		        	document.getElementById("divStates").style.display="none";
		    		document.getElementById("pin_unit").value="";		  
		    		document.getElementById("pin_unit_name").value="";	
		        }   
		        if (selectObj.options[i].value == "0"){		        	
		        	document.getElementById("divState").style.display="block"; 
		        	document.getElementById("divStates").style.display="block"; 
		        }
		       
	      	}
	       }  
		
        
	}
 
	function toAddPin(){ 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var pin_whether=document.getElementById("pin_whether").value;
		var pin_unit=document.getElementById("pin_unit").value;
		if (pin_whether == '') {
			alert("请选择是否借聘!");
			return;
		}
	     var querySql1="";
         var queryRet1=null;
         var datas1 =null; 
         querySql1 = "select hr.employee_hr_id   from  comm_human_employee er left join comm_human_employee_hr hr  on er.employee_id=hr.employee_id   where er.bsflag='0' and er.employee_id='"+ ids +"'";
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
         	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  	       			
				   var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
					var submitStr = 'JCDP_TABLE_NAME=COMM_HUMAN_EMPLOYEE_HR&JCDP_TABLE_ID='+datas1[0].employee_hr_id +'&pin_whether='+pin_whether
					+'&updator=<%=userName%>&modifi_date=<%=curDate%>&pin_unit='+pin_unit;
				   syncRequest('Post',path,encodeURI(encodeURI(submitStr))); 
		
     	    	   }
	       		
	        }
 		   loadDataDetail(ids);
		   alert("保存成功!");
	}
	function selectOrg2(){ 
			    var teamInfo = {
				        fkValue:"",
				        value:""
				    };
				    window.showModalDialog('<%=contextPath%>/rm/em/commHumanInfo/selectOrgSubPin.jsp',teamInfo);
				    if(teamInfo.fkValue!=""){
				    	 document.getElementById("pin_unit").value = teamInfo.fkValue; 
					        document.getElementById("pin_unit_name").value = teamInfo.value;
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
	


</script>
</html>