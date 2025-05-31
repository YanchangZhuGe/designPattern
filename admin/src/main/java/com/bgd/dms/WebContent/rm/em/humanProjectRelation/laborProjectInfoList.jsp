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
<%@ taglib uri="code" prefix="code"%>
 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgS_id=user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
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
<title>临时工项目经历</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="file_name" class="input_width" name="file_name" type="text" /></td>
			    <td class="ali_cdn_name">身份证号</td>
			    <td class="ali_cdn_input"><input id="spare21" class="input_width" name="spare21" type="text" /></td>
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>
			    <td width="50%" ></td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{labor_id}' id='rdo_entity_id_{labor_id}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_id_code_no}">身份证号</td>			   
			      <td class="bt_info_even" exp="{employee_name}">姓名</td>
			      <td class="bt_info_odd" exp="{apply_team_name}">班组</td>
			      <td class="bt_info_even" exp="{post_name}">岗位</td>
			      <td class="bt_info_odd" exp="{plan_start_date}">预计进入项目时间</td>
			      <td class="bt_info_even" exp="{plan_end_date}">预计离开项目时间</td>
			      <td class="bt_info_odd" exp="{plan_days}">预计项目天数</td>
			      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_odd" exp="{actual_end_date}">实际离开项目时间</td>
			    </tr>
			  </table>
			  </div>
			<div id="fenye_box"   style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">人员信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div id="inq_tool_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr align="right">
						<td width="95%">&nbsp;</td>
					    
					  </tr>
					</table>
					</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					  </tr>
					</table>
					</div>
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">姓名：</td>
				      <td   class="inquire_form6" ><input id="employee_name" class="input_width" type="text" value=""/> &nbsp; <input id="labor_id" class="input_width" type="hidden" value=""/></td>
				      <td  class="inquire_item6">&nbsp;性别：</td>
				      <td  class="inquire_form6"  ><input id="employee_gender_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">健康信息：</td>
					  <td  class="inquire_form6"><input id="employee_health_info" class="input_width" type="text"  value=""/> &nbsp;</td>
				      </tr>
				     <tr >
				     <td  class="inquire_item6">出生年月：</td>
				     <td  class="inquire_form6"><input id="employee_birth_date" class="input_width" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;民族：</td>
				     <td  class="inquire_form6"><input id="employee_nation_name" class="input_width" type="text"  value=""/> &nbsp;</td>  
				     <td  class="inquire_item6">&nbsp;是否骨干：</td>
					  <td  class="inquire_form6"><input id="elite_if_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				     </tr>
				    <tr> 
				    <td  class="inquire_item6">身份证号：</td>
				    <td  class="inquire_form6"><input id="employee_id_code_no" class="input_width" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">&nbsp;文化程度：</td>
				    <td  class="inquire_form6"><input id="employee_education_level_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">家庭住址：</td>
					<td  class="inquire_form6"><input id="employee_address" class="input_width" type="text"  value=""/> &nbsp;</td>
				    </tr>
			 
				 <tr >
				 <td  class="inquire_item6">班组：</td>
				 <td  class="inquire_form6"><input id="apply_teams" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td  class="inquire_item6">&nbsp;岗位：</td>
				 <td  class="inquire_form6"><input id="posts" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td  class="inquire_item6">&nbsp;联系电话：</td>
				   <td  class="inquire_form6"><input id="phone_num" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr>
				<td  class="inquire_item6">用工来源：</td>
				<td  class="inquire_form6"><input id="workerfrom_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;技术职称：</td>
				<td  class="inquire_form6"><input id="technical_title_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">手机号码：</td>
				<td  class="inquire_form6"><input id="mobile_number" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
		 
				<tr >
				<td  class="inquire_item6">组织机构：</td>
				<td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;用工性质：</td>
				<td  class="inquire_form6"><input id="if_engineer_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;项目状态：</td>
				<td  class="inquire_form6"><input id="if_project_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
				<tr>
				<td  class="inquire_item6">邮编：</td>
				<td  class="inquire_form6"><input id="postal_code" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;劳动合同：</td>
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
				<tr>
				<td  class="inquire_item6">岗位类型：</td>
				<td  class="inquire_form6"><input id="position_type" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">岗位国别：</td>
				<td  class="inquire_form6"><input id="position_nationality" class="input_width" type="text"  value=""/> &nbsp;</td> 
		
				</tr>
				
				  </table>
				</div>
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
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
var orgS_id='<%=orgS_id%>';
//cruConfig.queryStr = "";
//cruConfig.queryService = "ucmSrv";
//cruConfig.queryOp = "getDocsInFolder";
//cruConfig.queryRetTable_id = "";
 

function getTab3(index) {  
  var selectedTag0 = document.getElementById("tag3_0");
  var selectedTabBox0 = document.getElementById("tab_box_content0");
  var selectedTag1 = document.getElementById("tag3_1");
  var selectedTabBox1 = document.getElementById("tab_box_content1");
  var selectedTag2 = document.getElementById("tag3_2");
  var selectedTabBox2 = document.getElementById("tab_box_content2");
  var selectedTag3 = document.getElementById("tag3_3");
  var selectedTabBox3 = document.getElementById("tab_box_content3");
  
  if (index == '1'){
    selectedTag1.className ="selectTag";
    selectedTabBox1.style.display="block";
    selectedTag0.className ="";
    selectedTabBox0.style.display="none";
    selectedTag2.className ="";
    selectedTabBox2.style.display="none";
    selectedTag3.className ="";
    selectedTabBox3.style.display="none";
    
  }
   if (index == '0'){
    selectedTag0.className ="selectTag";
    selectedTabBox0.style.display="block";
    selectedTag1.className ="";
    selectedTabBox1.style.display="none";
    selectedTag2.className ="";
    selectedTabBox2.style.display="none";
    selectedTag3.className ="";
    selectedTabBox3.style.display="none";
    
  }
   if (index == '2'){
    selectedTag2.className ="selectTag";
    selectedTabBox2.style.display="block";
    selectedTag1.className ="";
    selectedTabBox1.style.display="none";
    selectedTag0.className ="";
    selectedTabBox0.style.display="none";
    selectedTag3.className ="";
    selectedTabBox3.style.display="none";
    
  }
   if (index == '3'){
	    selectedTag3.className ="selectTag";
	    selectedTabBox3.style.display="block";
	    selectedTag1.className ="";
	    selectedTabBox1.style.display="none";
	    selectedTag0.className ="";
	    selectedTabBox0.style.display="none";
	    selectedTag2.className ="";
	    selectedTabBox2.style.display="none";
	    
	  }
   
}

function loadDataDetail(shuaId){  
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;	    
 
		if(shuaId!=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;		
			querySql = "select * from  (select distinct l.*, d3.coding_name posts, d4.coding_name apply_teams from ( select rownum, l.bsflag,l.labor_id, l.employee_name, d11.coding_name position_name,decode(l.position_type,'0110000021000000003','技能操作类','0110000021000000002','专业技术类','0110000021000000001','管理类','')position_type,decode(l.labor_category, '0', '临时季节性用工', '1', '再就业人员', '2', '劳务派遣人员', '3', '其他用工', l.labor_category) labor_category, nvl(t1.post ,l.post ) post, nvl(t1.apply_team,l.apply_team ) apply_team, l.employee_nation, d1.coding_name employee_nation_name, l.employee_gender, l.owning_org_id, l.owning_subjection_org_id, decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name, decode(nvl(l.if_project, 0), '0', '不在项目', '1', '在项目', l.if_project) if_project_name, l.if_project, l.if_engineer, d5.coding_name if_engineer_name, l.cont_num, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, d2.coding_name employee_education_level_name, l.employee_address, l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom,  case when lt.nu  is null then '否' else '是' end fsflag, case when lt.nu is null then '' else 'red' end bgcolor, nvl(t.years, 0) years,l.create_date  , cft.coding_code as dalei,cft.coding_code_id as xiaolei ,decode(l.labor_distribution,  '0',  '一线员工',  '1',  '境外一线',  '2',  '二线员工',  '4',  '三线员工', '3',  '境外二三线',  l.labor_distribution) labor_distribution,    i.org_name,  l.postal_code,  l.mobile_number,  decode(nvl(l.elite_if, 0), '0', '否', '1', '是', l.elite_if) elite_if_name,    decode(l.household_type, '0', '农业', '1', '非农业') household_type,  d6.coding_name workerfrom_name,  l.technical_title,  d7.coding_name technical_title_name,  d8.coding_name nationality_name,   decode(l.institutions_type, '0', '境外项目', '1', '总部机关') institutions_type,  l.grass_root_unit,  l.go_abroad_time,  l.home_time,  nvl(d10.coding_name, l.present_state) present_state_name,  l.now_start_date,  l.implementation_date,  l.account_place,  l.start_salary_date,  l.technical_time,  l.post_sequence,  l.post_exam,  l.toefl_score,  l.tofel_listening,  decode(l.if_qualified, '0', '是', '1', '否') if_qualified,  l.nine_result,   decode(l.if_qualifieds, '0', '是', '1', '否') if_qualifieds,  l.holds_result  from bgp_comm_human_labor l left join (select lt.labor_id, count(1) nu   from bgp_comm_human_labor_list lt left join  bgp_comm_human_labor l on   l.labor_id = lt.labor_id     where lt.bsflag = '0' and l.bsflag='0'   group by lt.labor_id) lt on l.labor_id = lt.labor_id  left join (select d2.* from (select d1.* from (select d.apply_team, d.post, l1.labor_id, row_number() over(partition by d.labor_deploy_id order by d.start_date desc) numa from bgp_comm_human_deploy_detail d left join bgp_comm_human_labor_deploy l1 on d.labor_deploy_id = l1.labor_deploy_id where d.bsflag = '0') d1 where d1.numa = 1) d2) t1  on l.labor_id = t1.labor_id  left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id left join comm_coding_sort_detail d5 on l.if_engineer = d5.coding_code_id left join comm_org_subjection cn on l.owning_org_id = cn.org_id and cn.bsflag='0'      left join comm_org_information i    on l.owning_org_id = i.org_id   left join comm_coding_sort_detail d6    on l.workerfrom = d6.coding_code_id  left join comm_coding_sort_detail d7    on l.technical_title = d7.coding_code_id  left join comm_coding_sort_detail d8    on l.nationality = d8.coding_code_id  left join comm_coding_sort_detail d10    on l.present_state = d10.coding_code_id   left join comm_coding_sort_detail d11  on l.position_nationality = d11.coding_code_id   left join (select count(distinct to_char(t.start_date, 'yyyy')) years, t.labor_id from bgp_comm_human_labor_deploy t group by t.labor_id) t on l.labor_id = t.labor_id   left join  bgp_comm_human_certificate cft  on cft.employee_id= l.labor_id  and cft.bsflag='0'     where l.bsflag = '0'  and l.labor_id = '"+ shuaId +"'  ) l  left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id ) t where t.bsflag='0' ";
			//querySql = "       select rownum,  l.labor_id, decode(l.labor_distribution,'0','一线员工','1','境外一线','2','二线员工','4','三线员工','3','境外二三线', l.labor_distribution) labor_distribution,   decode(l.labor_category, '0', '临时季节性用工', '1', '再就业人员', '2', '劳务派遣人员', '3', '其他用工', l.labor_category) labor_category,    l.employee_name,       l.post,       l.apply_team,       d3.coding_name posts,       d4.coding_name apply_teams,       l.employee_nation,    l.position_nationality, d11.coding_name position_name,decode(l.position_type,'0110000021000000003','技能操作类','0110000021000000002','专业技术类','0110000021000000001','管理类','')position_type,    d1.coding_name employee_nation_name,       l.employee_gender,       l.owning_org_id,       l.owning_subjection_org_id,       i.org_name,      decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name,    decode(l.if_project,  '0',   '不在项目',  '1', '在项目',  l.if_project) if_project_name,       l.if_project,   l.if_engineer,   d5.coding_name if_engineer_name,    l.cont_num,   l.employee_birth_date,   l.employee_id_code_no,   l.employee_education_level,  d2.coding_name employee_education_level_name,       l.employee_address,   l.phone_num,  l.postal_code,  l.employee_health_info,   l.mobile_number, l.specialty,   decode(nvl(l.elite_if, 0), '0', '否', '1', '是', l.elite_if) elite_if_name,l.workerfrom,decode(l.household_type,'0','农业','1','非农业') household_type,        d6.coding_name workerfrom_name,     l.technical_title,    d7.coding_name technical_title_name,   d8.coding_name nationality_name, nvl(t.years, 0) years ,       decode(l.institutions_type,'0','境外项目','1','总部机关') institutions_type,l.grass_root_unit,l.go_abroad_time,l.home_time,nvl(d10.coding_name,l.present_state) present_state_name,l.now_start_date,l.implementation_date,       l.account_place,l.start_salary_date,l.technical_time,l.post_sequence,l.post_exam,l.toefl_score,l.tofel_listening,decode(l.if_qualified,'0','是','1','否') if_qualified,l.nine_result,l.elite_if,       decode(l.if_qualifieds,'0','是','1','否') if_qualifieds,l.holds_result          from bgp_comm_human_labor l      left join comm_coding_sort_detail d1    on l.employee_nation = d1.coding_code_id     left join comm_coding_sort_detail d2    on l.employee_education_level = d2.coding_code_id       left join comm_coding_sort_detail d3    on l.post = d3.coding_code_id       left join comm_coding_sort_detail d4    on l.apply_team = d4.coding_code_id       left join comm_coding_sort_detail d5    on l.if_engineer = d5.coding_code_id      left join comm_coding_sort_detail d6    on l.workerfrom = d6.coding_code_id      left join comm_coding_sort_detail d7    on l.technical_title = d7.coding_code_id       left join comm_coding_sort_detail d8    on l.nationality = d8.coding_code_id       left join comm_coding_sort_detail d10  on l.present_state = d10.coding_code_id       left join comm_coding_sort_detail d11  on l.position_nationality = d11.coding_code_id       left join comm_org_information i    on l.owning_org_id = i.org_id       left join (select count(distinct to_char(t.start_date, 'yyyy')) years,    t.labor_id     from bgp_comm_human_labor_deploy t    group by t.labor_id) t      on l.labor_id = t.labor_id   where l.bsflag = '0'  and l.labor_id = '"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null && datas!=""){				 
					
					
					document.getElementById("employee_name").value =datas[0].employee_name;
					document.getElementById("employee_gender_name").value = datas[0].employee_gender_name;
					document.getElementById("employee_birth_date").value = datas[0].employee_birth_date;
					document.getElementById("employee_nation_name").value = datas[0].employee_nation_name;
					document.getElementById("employee_id_code_no").value = datas[0].employee_id_code_no;
					document.getElementById("employee_education_level_name").value = datas[0].employee_education_level_name;
					document.getElementById("employee_address").value = datas[0].employee_address;
					document.getElementById("phone_num").value = datas[0].phone_num;
					document.getElementById("employee_health_info").value = datas[0].employee_health_info;
					document.getElementById("elite_if_name").value = datas[0].elite_if_name;
					document.getElementById("apply_teams").value = datas[0].apply_teams;
					document.getElementById("posts").value = datas[0].posts;
					document.getElementById("workerfrom_name").value = datas[0].workerfrom_name;
					document.getElementById("technical_title_name").value = datas[0].technical_title_name;
					document.getElementById("mobile_number").value = datas[0].mobile_number;
					document.getElementById("if_project_name").value = datas[0].if_project_name;
					document.getElementById("org_name").value = datas[0].org_name;
					document.getElementById("if_engineer_name").value = datas[0].if_engineer_name;
					document.getElementById("postal_code").value = datas[0].postal_code;
					document.getElementById("cont_num").value = datas[0].cont_num;
					document.getElementById("specialty").value = datas[0].specialty;
					document.getElementById("labor_id").value = datas[0].labor_id;
					document.getElementById("labor_distribution").value = datas[0].labor_distribution;
					document.getElementById("nationality_name").value = datas[0].nationality_name;
					document.getElementById("household_type").value = datas[0].household_type; 
					document.getElementById("position_type").value = datas[0].position_type;
					document.getElementById("position_nationality").value = datas[0].position_name;
					
				 
					document.getElementById("institutions_type").value = datas[0].institutions_type;
					document.getElementById("grass_root_unit").value = datas[0].grass_root_unit;
					document.getElementById("go_abroad_time").value = datas[0].go_abroad_time;
					document.getElementById("home_time").value = datas[0].home_time;
					document.getElementById("present_state").value = datas[0].present_state_name;
					document.getElementById("now_start_date").value = datas[0].now_start_date;
					document.getElementById("implementation_date").value = datas[0].implementation_date;
					document.getElementById("account_place").value = datas[0].account_place;
					document.getElementById("start_salary_date").value = datas[0].start_salary_date;
					document.getElementById("technical_time").value = datas[0].technical_time;
					document.getElementById("post_sequence").value = datas[0].post_sequence;
					document.getElementById("post_exam").value = datas[0].post_exam;
					document.getElementById("toefl_score").value = datas[0].toefl_score;
					document.getElementById("tofel_listening").value = datas[0].tofel_listening;
					document.getElementById("if_qualified").value = datas[0].if_qualified;
					document.getElementById("nine_result").value = datas[0].nine_result;
					document.getElementById("if_qualifieds").value = datas[0].if_qualifieds;
					document.getElementById("holds_result").value = datas[0].holds_result;
				}					
			
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


function simpleSearch(){ 
	var file_name = document.getElementById("file_name").value; 
	var  spare21=document.getElementById("spare21").value; 
	if(file_name =='' && spare21 ==''){ 
		refreshData();
	}else{
		
    if(spare21 !='' && file_name !=''){
    	cruConfig.cdtType = 'form';
		cruConfig.queryStr = " select rownum,   hl.labor_id, hl.employee_name,hl.employee_id_code_no,  hl.cont_num, pt.project_name,       pt.project_info_no,       d1.coding_name apply_team_name,       d2.coding_name post_name,   to_char(td.start_date,'yyyy-mm-dd')plan_start_date,    to_date(to_char(td.spare4, 'yyyy-MM-dd'), 'yyyy-MM-dd') plan_end_date  ,   td.actual_start_date   ,      to_char(td.end_date,'yyyy-mm-dd') actual_end_date ,   round(case   when nvl(td.end_date, sysdate) - td.start_date >= 0 then    nvl(td.end_date, sysdate) - td.start_date +1    else      0   end) plan_days ,    round(case  when nvl(td.spare4, sysdate) - td.start_date > 0 then  nvl(td.spare4, sysdate) - td.start_date - (-1)  else  0  end) days   from    bgp_comm_human_labor_deploy td     left join gp_task_project pt    on td.project_info_no = pt.project_info_no    left join bgp_comm_human_deploy_detail dl    on dl.labor_deploy_id = td.labor_deploy_id    left join comm_coding_sort_detail d1    on dl.apply_team = d1.coding_code_id    left join comm_coding_sort_detail d2    on dl.post = d2.coding_code_id    left join bgp_comm_human_labor hl on hl.labor_id=td.labor_id and hl.bsflag='0'   where td.bsflag = '0'  and  pt.project_info_no like '<%=projectInfoNo%>%'    and hl.employee_id_code_no like'%"+spare21+"%' and hl.employee_name like'%"+file_name+"%'  order by rownum  ";
		cruConfig.currentPageUrl = "/em/humanProjectRelation/laborProjectInfoList.jsp";
		queryData(1);
			return ;
    	
    }else if(file_name!=''&& file_name!=null){ 
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = " select rownum,   hl.labor_id, hl.employee_name,hl.employee_id_code_no,  hl.cont_num, pt.project_name,       pt.project_info_no,       d1.coding_name apply_team_name,       d2.coding_name post_name,   to_char(td.start_date,'yyyy-mm-dd')plan_start_date,    to_date(to_char(td.spare4, 'yyyy-MM-dd'), 'yyyy-MM-dd') plan_end_date  ,   td.actual_start_date   ,      to_char(td.end_date,'yyyy-mm-dd') actual_end_date ,   round(case   when nvl(td.end_date, sysdate) - td.start_date >= 0 then    nvl(td.end_date, sysdate) - td.start_date +1    else      0   end) plan_days ,    round(case  when nvl(td.spare4, sysdate) - td.start_date > 0 then  nvl(td.spare4, sysdate) - td.start_date - (-1)  else  0  end) days   from    bgp_comm_human_labor_deploy td     left join gp_task_project pt    on td.project_info_no = pt.project_info_no    left join bgp_comm_human_deploy_detail dl    on dl.labor_deploy_id = td.labor_deploy_id    left join comm_coding_sort_detail d1    on dl.apply_team = d1.coding_code_id    left join comm_coding_sort_detail d2    on dl.post = d2.coding_code_id    left join bgp_comm_human_labor hl on hl.labor_id=td.labor_id and hl.bsflag='0'   where td.bsflag = '0'  and  pt.project_info_no like '<%=projectInfoNo%>%'     and hl.employee_name like'%"+file_name+"%'  order by rownum  ";
		cruConfig.currentPageUrl = "/em/humanProjectRelation/laborProjectInfoList.jsp";
		queryData(1);
			return ;
	 }else  if(spare21!=''&& spare21!=null){ 
	    	 cruConfig.cdtType = 'form';
			cruConfig.queryStr = " select rownum,   hl.labor_id, hl.employee_name,hl.employee_id_code_no,  hl.cont_num, pt.project_name,       pt.project_info_no,       d1.coding_name apply_team_name,       d2.coding_name post_name,   to_char(td.start_date,'yyyy-mm-dd')plan_start_date,    to_date(to_char(td.spare4, 'yyyy-MM-dd'), 'yyyy-MM-dd') plan_end_date  ,   td.actual_start_date   ,      to_char(td.end_date,'yyyy-mm-dd') actual_end_date ,   round(case   when nvl(td.end_date, sysdate) - td.start_date >= 0 then    nvl(td.end_date, sysdate) - td.start_date +1    else      0   end) plan_days ,    round(case  when nvl(td.spare4, sysdate) - td.start_date > 0 then  nvl(td.spare4, sysdate) - td.start_date - (-1)  else  0  end) days   from    bgp_comm_human_labor_deploy td     left join gp_task_project pt    on td.project_info_no = pt.project_info_no    left join bgp_comm_human_deploy_detail dl    on dl.labor_deploy_id = td.labor_deploy_id    left join comm_coding_sort_detail d1    on dl.apply_team = d1.coding_code_id    left join comm_coding_sort_detail d2    on dl.post = d2.coding_code_id    left join bgp_comm_human_labor hl on hl.labor_id=td.labor_id and hl.bsflag='0'   where td.bsflag = '0'  and  pt.project_info_no like '<%=projectInfoNo%>%'    and hl.employee_id_code_no like'%"+spare21+"%'  order by rownum  ";
			cruConfig.currentPageUrl = "/em/humanProjectRelation/laborProjectInfoList.jsp";
			queryData(1);
			return ;
	 } 
	
	}
 
}
function clearQueryText(){
		  document.getElementById("file_name").value=''; 
	      document.getElementById("spare21").value='';
}
 
function refreshData(){
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = " select rownum,   hl.labor_id, hl.employee_name,hl.employee_id_code_no,  hl.cont_num, pt.project_name,       pt.project_info_no,       d1.coding_name apply_team_name,       d2.coding_name post_name,   to_char(td.start_date,'yyyy-mm-dd')plan_start_date,    to_date(to_char(td.spare4, 'yyyy-MM-dd'), 'yyyy-MM-dd') plan_end_date  ,   td.actual_start_date   ,      to_char(td.end_date,'yyyy-mm-dd') actual_end_date ,   round(case   when nvl(td.end_date, sysdate) - td.start_date >= 0 then    nvl(td.end_date, sysdate) - td.start_date +1    else      0   end) plan_days ,    round(case  when nvl(td.spare4, sysdate) - td.start_date > 0 then  nvl(td.spare4, sysdate) - td.start_date - (-1)  else  0  end) days   from    bgp_comm_human_labor_deploy td     left join gp_task_project pt    on td.project_info_no = pt.project_info_no    left join bgp_comm_human_deploy_detail dl    on dl.labor_deploy_id = td.labor_deploy_id    left join comm_coding_sort_detail d1    on dl.apply_team = d1.coding_code_id    left join comm_coding_sort_detail d2    on dl.post = d2.coding_code_id    left join bgp_comm_human_labor hl on hl.labor_id=td.labor_id and hl.bsflag='0'   where td.bsflag = '0'  and  pt.project_info_no like '<%=projectInfoNo%>%'  order by rownum  ";
 
	cruConfig.currentPageUrl = "/em/humanProjectRelation/laborProjectInfoList.jsp";
	queryData(1);
}
 
 
	function viewProcInfo(){
		var editUrl="/BPM/viewProcinst.jsp?procinstId="+procinstId;
		window.showModalDialog("<%=contextPath%>"+editUrl," ","dialogWidth:1024px;   dialogHeight:768px");
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

