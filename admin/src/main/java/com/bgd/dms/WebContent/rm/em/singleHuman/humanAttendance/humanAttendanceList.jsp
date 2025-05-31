<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = user.getProjectInfoNo();
	String projectType=user.getProjectType();
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
	}
	
	String pFid= "";
	//查询是否 子项目
	String sqlButton = " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='"+projectInfoNo+"' and  t.bsflag='0' and t.project_father_no is not  null "; 
	List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlButton);
	//System.out.println("sql ="+list.size());	
	if(listF.size()>0){
	 	Map mapA = (Map)listF.get(0);
	 	  pFid= (String)mapA.get("projectFatherNo");
	 	
	}
	
	String orgS_id = (user==null)?"":user.getSubOrgIDofAffordOrg();
	
	  String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'    start with t.org_sub_id = '"+orgS_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		
		System.out.println("sql ="+sql);	
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String orgSubIdA = "";
		String orgSubIdB = "";
		String orgSubIdC = "";
		String organ_flagA = "";
		String organ_flagB = "";
		String organ_flagC = "";
		
		if(list.size()>1){
		 	Map mapA = (Map)list.get(0);
		 	Map mapOrgB= (Map)list.get(1); 
			
//		 	if(mapOrgB == null){
//		 		mapOrgB= mapA;	 
//		 	} 
		 	
			orgSubIdA = (String)mapA.get("orgSubId");
			orgSubIdB = (String)mapOrgB.get("orgSubId"); 
			organ_flagA = (String)mapA.get("organFlag");
			organ_flagB = (String)mapOrgB.get("organFlag"); 
			
			if(organ_flagB.equals("")){
				if(organ_flagA.equals("1")){
					orgS_id = orgSubIdA;
				}
			}
			if(organ_flagB.equals("1")){
				orgS_id = orgSubIdB;
			}

			if(list.size()>2){ 
				Map mapOrgC = (Map)list.get(2);
				orgSubIdC = (String)mapOrgC.get("orgSubId");
				organ_flagC = (String)mapOrgC.get("organFlag");
				
				if(organ_flagC.equals("1")){
					orgS_id = orgSubIdC;
				}

				if(organ_flagC.equals("")){
					if(organ_flagB.equals("1")){
						orgS_id = orgSubIdB;
					}
				}
			}
		 
			
		 	if(organ_flagA.equals("0")||user.getOrgSubjectionId().equals("C105")){
		 		orgS_id = "C105";
		 	}
		}
		
		
		

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
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/rm/em/singleHuman/humanAttendance/Calendar1.js"></script>
  <title>考勤信息</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">人员姓名</td>
		 	    <td class="ali_cdn_input"><input id="s_employee_name" class="input_width"  name="s_employee_name" type="text"   /></td>
			    <td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" onchange="getPost()"></select></td>
			    <td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><select class="select_width"  id="s_post" name="s_post" ></select></td>
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>
			    <td>&nbsp;</td>
			    <td> 			 
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    </td>		  
			    
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{employee_id},{employee_gz},{actual_start_date}' id='rdo_entity_id_{employee_id}'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_name}"  isExport='Hide' >姓名</td> 
			      <td class="bt_info_even" exp="{team_name}" isExport='Hide' >班组</td>
			      <td class="bt_info_odd" exp="{work_post_name}" isExport='Hide' >岗位</td>			 
			      <td class="bt_info_even" exp="{employee_gz_name}" isExport='Hide' >用工性质</td>			 
 			      <td class="bt_info_odd" exp="{actual_start_date}" isExport='Hide' >进入项目时间</td>
 			      
 			      <td class="bt_info_odd" exp="{id_code}" isShow='Hide' >身份证号</td>
			      <td class="bt_info_odd" exp="{employee_cd}"   isShow='Hide' >员工编号</td>
			      <td class="bt_info_odd" exp="{employee_name}"  isShow='Hide'  >姓名</td> 
			      
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">人员基本信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">考勤信息</a></li>

			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">		
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
				<div id="tab_box_content1" name="tab_box_content1"  class="tab_box_content" style="display:none;">					
					<div style="overflow:auto">
			      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr align="right">
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td>&nbsp;</td>
					  		<auth:ListButton functionId="" css="dr" event="onclick='toDRRY()'" title="导入"></auth:ListButton>
					    	<auth:ListButton functionId="" css="zj" event="onclick='toAddKQ()'" title="JCDP_btn_add"></auth:ListButton>
						</tr>
					  </table>
				  </div>
				<table id="kqMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					<tr >  
						<td class="bt_info_even">选择</td>
					    <td class="bt_info_odd">班组</td>
					    <td class="bt_info_even">岗位</td>
					    <td class="bt_info_odd">用工性质</td>
					    <td class="bt_info_even">考勤月份</td>
					    <td class="bt_info_odd">详情</td>
				  	</tr>
				  <tbody id="assign_body"></tbody>
				</table>
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
	var projectType="<%=projectType%>";
	
	var projectInfoNos = '<%=projectInfoNo%>';	 
	var projectInfoId = '<%=projectInfoNo%>'; 
	var orgS_id ='<%=orgS_id%>';
	var pFid="<%=pFid%>";

	//alert("<%=user.getSubOrgIDofAffordOrg()%>");
//	cruConfig.queryService = "HumanRequiredSrv";
//	cruConfig.queryOp = "queryHumanAcceptAndReturn";
		
	function refreshData(){
	 
     	//cruConfig.queryStr = "select t.* from (select distinct t.EMPLOYEE_ID,t.EMPLOYEE_NAME,t.employee_cd,t.id_code,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'   left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'   left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '<%=projectInfoNo%>' and t.actual_start_date is not null  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME ) t where 1=1 ";
     	//cruConfig.currentPageUrl = "/rm/em/singleHuman/humanAttendance/humanAttendanceList.jsp";
		//queryData(1); 
		
		var projectInfoNo="";
		var zi_pid="";
		var pXFids="";
		var pSql="";
		//查询是否 子项目
	    var sqlButton = " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='<%=projectInfoNo%>' and  t.bsflag='0' and t.project_father_no is not  null "; 
		var queryRetNum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+sqlButton);		
		var datas = queryRetNum.datas; 
		if(datas != null && datas != ''){
			for (var i = 0; i< datas.length; i++) {
				projectInfoNo=datas[i].project_father_no; 	 
				zi_pid=datas[i].project_father_no; 
			}
			pSql=" where p.project_info_no='"+projectInfoId+"' ";
		}   
	 
			// 处理井中业务 根据父项目查出所有主施工队伍 		 
			 var sqlZdui = " SELECT  p.project_info_no    AS project_info_no, p.project_type,  p.project_name      AS project_name,  p.project_common    AS project_common,  p.project_status     AS project_status,  ccsd.coding_name     AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation    AS team_name,  dy.is_main_team   AS is_main_team,dy.org_id,dy.org_subjection_id  , p.project_year,  p.project_father_no     FROM  gp_task_project p  JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND dy.bsflag = '0'  AND p.bsflag='0'  AND p.project_father_no ='"+projectInfoNo+"'   AND p.project_type='5000100004000000008'  AND dy.is_main_team ='1'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'  "; 
				var queryZdui = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+sqlZdui);		
				var datasZdui = queryZdui.datas; 
				if(datasZdui != null && datasZdui != ''){
					for (var i = 0; i< datasZdui.length; i++) {	 
		 
						//根据主施工队伍子项目 查询 ，所有相关协作 队伍 的  父id
					  // var sqlX = "  SELECT  p.project_info_no    AS project_info_no,    p.project_name      AS project_name,  p.project_common    AS project_common,  p.project_status     AS project_status,  ccsd.coding_name     AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation    AS team_name,  dy.is_main_team   AS is_main_team  , p.project_year,  p.project_father_no     FROM  gp_task_project p  JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND dy.bsflag = '0'  AND p.bsflag='0'  AND p.project_father_no ='"+projectInfoNo+"'   AND p.project_type='5000100004000000008'  AND dy.is_main_team ='1'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'  union all  SELECT  p.project_info_no    AS project_info_no,  p.project_name||'(协作)'    AS project_name,  p.project_common     AS project_common,  p.project_status      AS project_status,  ccsd.coding_name      AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation     AS team_name,  dy.is_main_team      AS is_main_team,  p.project_year ,  p.project_father_no   FROM  gp_task_project p   JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND p.project_year='"+datasZdui[i].project_year+"'  AND dy.bsflag = '0'  AND p.bsflag='0'  AND dy.org_id = '"+datasZdui[i].org_id+"'  AND p.project_type='5000100004000000008'  AND dy.is_main_team ='0'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'   " + pSql ; 
						var sqlX = "    SELECT  p.project_info_no    AS project_info_no,  p.project_name||'(协作)'    AS project_name,  p.project_common     AS project_common,  p.project_status      AS project_status,  ccsd.coding_name      AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation     AS team_name,  dy.is_main_team      AS is_main_team,  p.project_year ,  p.project_father_no   FROM  gp_task_project p   JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND p.project_year='"+datasZdui[i].project_year+"'  AND dy.bsflag = '0'  AND p.bsflag='0'  AND dy.org_id = '"+datasZdui[i].org_id+"'  AND p.project_type='5000100004000000008'  AND dy.is_main_team ='0'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'   " + pSql ;
							var queryX = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+sqlX);		
							var datasX = queryX.datas;  
							if(datasX != null && datasX != ''){
								for (var j = 0; j< datasX.length; j++) {  
									// 协作队伍的父项目id
									pXFids = pXFids + "," + "'" + datasX[j].project_father_no+ "'";
									
								}
							
							}  
							
							 
					}
				
				}  
				
	 			//从其他项目转入的人员地震队项目互相转
				var  str  ="  select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, '' disasss, '是'   zy_sf,''employee_gender,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei,  case   when length(t.employee_cd)>10  then   ''     else  t.employee_cd     end employee_cd,   case   when length(t.employee_cd)>10  then   t.employee_cd   else   ''   end id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and  t.bproject_info_no='<%=projectInfoNo%>' and t.end_date is null and t.pk_ids !='add' ";   // and t.pk_ids is null   当时怎么加 这个条件了
				//年度自己项目转移,不加项目转移‘是’列
				str += " union all  select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, 'disabled' disasss, ''   zy_sf,''employee_gender,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei, case   when length(t.employee_cd)>10  then   ''     else  t.employee_cd     end employee_cd,   case   when length(t.employee_cd)>10  then   t.employee_cd   else   ''   end id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and t.end_date is null  and t.pk_ids='add'  ";  // and t.pk_ids='add'  当时怎么加 这个条件了
				//父项目转移的人员，在子项目看到
				if(zi_pid !=""){
					str += "  and  t.bproject_info_no='"+zi_pid+"' ";
				}else{
					str += "  and  t.bproject_info_no='<%=projectInfoNo%>' ";
				}
				//自己项目接收人员
				str += " union all   select '' pk_ids,'' ptdetail_id  , t.zy_type, 'disabled'  disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,decode(t.employee_gender,'0','女','1','男') employee_gender ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,      t.ORG_SUBJECTION_ID,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where  t.actual_start_date is not null and  t.actual_end_date is null   ";
		 
          //父项目 id 不为空 ,那么就是子项目
         if(pFid !=null && pFid !="null"){   //选择项目为 子项目
        	 
        	// str +="  and t.PROJECT_FATHER_NO = '"+projectInfoNo+"' and  t.project_info_no =  '"+pFid+"' " ; // 自己项目人员
        	 str +="   and  t.project_info_no =  '<%=projectInfoNo%>' " ; // 自己项目人员
        	   if(orgS_id!=null && orgS_id!=""){
              	 if(orgS_id=="C105006"){
              		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
              	 }
              	 
               }  
        	  
        	 	 //查询父项目人员
        	 str +=" union all select '' pk_ids,'' ptdetail_id  ,  t.zy_type,'disabled'   disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,decode(t.employee_gender,'0','女','1','男') employee_gender ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,      t.ORG_SUBJECTION_ID,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where  t.actual_start_date is not null and  t.actual_end_date is null    and  t.project_info_no    in( '"+projectInfoNo+"'"+pXFids+" ) "; 
        	
        	   if(orgS_id!=null && orgS_id!=""){
              	 if(orgS_id=="C105006"){
              		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
              	 }
              	 
               }  
     	 	 

     	 	
         }else {  //选择项目为 父项目
        	   if(orgS_id!=null && orgS_id!=""){
              	 if(orgS_id=="C105006"){
              		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
              	 }
              	 
               }  
        	 str +="   and  t.project_info_no  in( '"+projectInfoNo+"'"+pXFids+" ) ";  //查询自己项目人员
        	 
          	 
             //var str1="  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME  ";
		      str=str;
         }
         

		cruConfig.queryStr=str;
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanAttendance/humanAttendanceList.jsp";
		queryData(1); 
		
		
	}

	function toEdit(){
		
		ids = getSelectedValue();
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanPositionChange/humanPositionChangeEdit.jsp?employeeId='+ids.split(",")[0]+'&projectInfoNo=<%=projectInfoNo%>','800:600');
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function simpleSearch(){
		
		var s_employee_name = document.getElementById("s_employee_name").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;
		
		var str = " 1=1 ";
		if(s_employee_name!=''){
			str += " and employee_name like '%"+s_employee_name+"%' ";
		}
		if(s_apply_team != ''){
			str+=" and team='"+s_apply_team+"'";
		}
		if(s_post != ''){
			str+=" and work_post='"+s_post+"'";
		}
		cruConfig.cdtStr = str;
		refreshData();

	}
 
	function clearQueryText(){ 
		 document.getElementById("s_employee_name").value=""; 
		 document.getElementById("s_apply_team").value="";
	     var selectObj = document.getElementById("s_post");
	     document.getElementById("s_post").innerHTML="";
	     selectObj.add(new Option('请选择',""),0);
	     cruConfig.cdtStr = "";
	}
	
    function loadDataDetail(ids){   		
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+ids.split(",")[0]).attr("checked","checked"); 	sbkq(ids.split(",")[0],ids.split(",")[2]);
  	    getComm(ids); 
 
	
    }
    
    function toDRRY(){
	 	popWindow("<%=contextPath%>/rm/em/singleHuman/humanAttendance/humanImportFile.jsp","800:350");
    }
    
	function sbkq(shuaId,startDate){
		if (shuaId != null) {
		
			 retObj = jcdpCallService("HumanLaborMessageSrv", "getAttendanceInfoKq", "deviceId="+shuaId+"&startDate="+startDate);
			
			var size = $("#assign_body", "#tab_box_content1").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content1").children("tr").remove();
			}
			var kq_body1 = $("#assign_body", "#tab_box_content1")[0];
			if (retObj.group != undefined) {
				for(var i=0;i<retObj.group.length;i++){
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					str="device_acc_id="+retObj.employee_id+"&ye="+retObj.group[i].year+"&me="+retObj.group[i].month;
					var newTr=kq_body1.insertRow()
					newTr.lin=str;
					newTr.onclick=function(){setGl2(this, 'tab_box_content1');}
					newTr.ondblclick=function(){getdatekq(this);}
					newTr.insertCell().innerHTML="<input type=checkbox>";
					newTd=newTr.insertCell(); 
					newTd.innerText=columnsObj(3).innerText; 
					var newTd1=newTr.insertCell();
					newTd1.innerText=columnsObj(4).innerText; 
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(5).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=retObj.group[i].year+"-"+retObj.group[i].month;
					var newTd4=newTr.insertCell(); 
					newTd4.innerHTML="<a lin="+str+" onclick=getdatekq(this);><img src=<%=contextPath%>/images/calendar.gif /></a>";
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content1').addClass("even_even");
	}
	function getdatekq(obj){
    var dev_appdet_id;
	var ye;
	var me;
	var vall=obj.lin.split("&");
	for(var i=0;i<vall.length;i++){
		var temp= vall[i].split("=");
		if(temp[0]=="device_acc_id"){
			dev_appdet_id= temp[1];
		}
		if(temp[0]=="ye"){
			ye= temp[1];
		}
		if(temp[0]=="me"){
			me= temp[1];
		}
	}
    	var querySql="select to_char(a.timesheet_date,'yyyy') as Year,to_char(a.timesheet_date,'mm') as month,to_char(a.timesheet_date,'dd') as day,a.* from BGP_COMM_EMPLOYEE_KQMS a where a.bsflag='0' and a.employee_id='"+dev_appdet_id+"' and to_char(a.timesheet_date,'yyyy')='"+ye+"' and to_char(a.timesheet_date,'mm')='"+me+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		var basedatas = queryRet.datas;
		
		calendar1(basedatas,'kqcallback');
		
    }
	
    function kqcallback(obj){ 
    	var ids = getSelIds('rdo_entity_id');
	    	 var yDate=ids.split(",")[2];
	    	 var yDates=yDate.split("-")[2];
         var dDate=obj.split("-")[2];  
         
         if(dDate<yDates){
        	 alert('未进项目,不可删除!'); return ;
         } 
    
			if (confirm('确定要删除吗?')) {
			
				var retObj = jcdpCallService("HumanLaborMessageSrv", "deleteKQ", "deviceId="+ids.split(",")[0]+"&date="+obj);
					
				queryData(cruConfig.currentPage);
			} 
          
		
    }
    
    function toDeleteKQ(){
    	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	 
    }
    
    
  //打开新增界面
	function toAddKQ(){   
		var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	 	popWindow("<%=contextPath%>/rm/em/singleHuman/humanAttendance/addKq.jsp?ids="+ids.split(",")[0]);  
	}
	
	/*****************************************************************************************************************************
	   * 公共复选框选择
	   */
	  function setGl2(obj,divid){
		var tableobj = obj.parentNode;
  	$("#"+tableobj.id+">tr:odd>td:odd","#"+divid).css("background-color","#e3e3e3");
		$("#"+tableobj.id+">tr:even>td:odd","#"+divid).css("background-color","#ebebeb");
		$("#"+tableobj.id+">tr:odd>td:even","#"+divid).css("background-color","#f6f6f6");
		$("#"+tableobj.id+">tr:even>td:even","#"+divid).css("background-color","#FFFFFF");
		$("input[type='checkbox']","#"+divid).removeAttr("checked");
  	var columnsObj=obj.cells;
  	columnsObj[0].childNodes[0].checked=true;
  	for(var i=0;i<columnsObj.length;i++){
  		columnsObj[i].style.background="#ffc580";
  	}
  }
	  
	  
	function getComm(ids){
		var retObj = jcdpCallService("HumanLaborMessageSrv", "getCommInfo", "id="+ids.split(",")[0]+"&employeeGz="+ids.split(",")[1]);
		
		 if("0110000019000000001,0110000019000000002".indexOf(ids.split(",")[1]) != -1){
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
	
	function getApplyTeam(){
		var selectObj = document.getElementById("s_apply_team"); 
		document.getElementById("s_apply_team").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
	
		var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	
		for(var i=0;i<applyTeamList.detailInfo.length;i++){
			var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("s_post");
		document.getElementById("s_post").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	function getPost(){
	    var applyTeam = "applyTeam="+document.getElementById("s_apply_team").value;   
		var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	
	
		var selectObj = document.getElementById("s_post");
		document.getElementById("s_post").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(applyPost.detailInfo!=null){
			for(var i=0;i<applyPost.detailInfo.length;i++){
				var templateMap = applyPost.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}

	
</script>
</html>