<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request); 
	String projectInfoNo = user.getProjectInfoNo();
	
	String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
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
  <title>岗位变更</title> 
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
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{employee_id}-{employee_gz}' id='rdo_entity_id_{employee_id}'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_name}">姓名</td>
			      <td class="bt_info_even" exp="{team_name}">班组</td>
			      <td class="bt_info_odd" exp="{work_post_name}">岗位</td>			 
			      <td class="bt_info_even" exp="{employee_gz_name}">用工性质</td>			 
 			      <td class="bt_info_odd" exp="{actual_start_date}">进入项目时间</td>
			 
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
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">岗位明细</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li> 
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
			     <td class="inquire_form8"><input id="employee_name2" class="input_width" type="text" value=""/> &nbsp;<input id="labor_id2" class="input_width" type="hidden" value=""/> <input id="labor_id" class="input_width" type="hidden" value=""/></td>
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
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">					
					<table id="planDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	<td>序号</td>
			    	    <td>班组</td>
			    	    <td>岗位</td>
			            <td>进入时间</td>
			            <td>离开时间</td>		
			            <td>人员评价</td>	
				        </tr>            
			        </table>
				</div>				
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
	cruConfig.cdtType = 'form';
//	cruConfig.queryService = "HumanRequiredSrv";
//	cruConfig.queryOp = "queryHumanAcceptAndReturn";
		
	function refreshData(){
	 
     	cruConfig.queryStr = "select t.* from (select distinct t.EMPLOYEE_ID,t.EMPLOYEE_NAME,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id  and d1.bsflag='0' and d1.coding_mnemonic_id='<%=projectType%>'   left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id  and d2.bsflag='0' and d2.coding_mnemonic_id='<%=projectType%>' left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '<%=projectInfoNo%>' and t.actual_start_date is not null  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME ) t where 1=1 ";
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanPositionChange/humanPositionChangeList.jsp";
		queryData(1); 
	}

	function toEdit(){
		
		ids = getSelectedValue();
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanPositionChange/humanPositionChangeEdit.jsp?employeeId='+ids.split("-")[0]+'&projectInfoNo=<%=projectInfoNo%>','800:600');
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
   
    	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];  	    
  	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
  	    getComm(ids);
		var querySql = "select t.EMPLOYEE_ID,t.EMPLOYEE_NAME,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id  and d1.bsflag='0' and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.bsflag='0' and d2.coding_mnemonic_id='<%=projectType%>' left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '<%=projectInfoNo%>' and t.employee_id='"+ids.split("-")[0]+"'  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);		
		var datas = queryRet.datas;
		
		var querySql1 = "SELECT d3.coding_name team_name,d4.coding_name work_post_name ,pc.actual_start_date,pc.actual_end_date,pc.evaluation,d1.coding_name evaluation_name   FROM  bgp_human_position_change pc   left join comm_coding_sort_detail d1 on pc.evaluation = d1.coding_code_id left join comm_coding_sort_detail d3    on pc.team = d3.coding_code_id  and d3.bsflag='0' and d3.coding_mnemonic_id='<%=projectType%>'     left join comm_coding_sort_detail d4    on pc.work_post = d4.coding_code_id  and d4.bsflag='0' and d4.coding_mnemonic_id='<%=projectType%>'  where pc.bsflag='0' and pc.project_info_no='<%=projectInfoNo%>' and pc.employee_id='"+ids.split("-")[0]+"' order by pc.actual_start_date ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);		
		var datas1 = queryRet1.datas;

		deleteTableTr("planDetailList");
		
		if(datas != null && queryRet.datas.length>0){
			var tr = document.getElementById("planDetailList").insertRow();		
			tr.className = "odd";

			var td = tr.insertCell(0);
			td.innerHTML = "1";
			
			var td = tr.insertCell(1);
			td.innerHTML = datas[0].team_name;
			
			var td = tr.insertCell(2);
			td.innerHTML = datas[0].work_post_name;
			
			var td = tr.insertCell(3);
			td.innerHTML = datas[0].actual_start_date;

			var td = tr.insertCell(4);
			td.innerHTML = datas[0].actual_end_date;

			var td = tr.insertCell(5);
			td.innerHTML = "";
		}
		
		if(datas1 != null){
			for (var i = 0; i< queryRet1.datas.length; i++) {
			
				var tr = document.getElementById("planDetailList").insertRow();		
				
	          	if((i+1) % 2 == 1){  
	          		tr.className = "even";
				}else{ 
					tr.className = "odd";
				}
	
				var td = tr.insertCell(0);
				td.innerHTML = (i+2);
				
				var td = tr.insertCell(1);
				td.innerHTML = datas1[i].team_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas1[i].work_post_name;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas1[i].actual_start_date;
	
				var td = tr.insertCell(4);
				td.innerHTML = datas1[i].actual_end_date;

				var td = tr.insertCell(5);
				td.innerHTML = datas1[i].evaluation_name;
			}
		}
  		
		
		
    }
    
	function getComm(ids){
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