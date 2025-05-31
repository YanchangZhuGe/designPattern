<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_no=user.getProjectInfoNo(); 
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();//getOrgSubjectionId();
	String orgName = user.getOrgName();
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

 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
      		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">项目年度</td>
			    <td class="ali_cdn_input"><input id="s_project_year" name="s_project_year" class="input_width" type="text"/></td>
			   
			   	<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				<td>&nbsp;</td>
				<auth:ListButton functionId="" css="tj" event="onclick='JcdpButton0OnClick()'" title="JCDP_btn_filter"></auth:ListButton>		    
			  </tr>
			</table>									 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			
			
			<div id="table_box" style="height:100%;display:block">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">			    
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{project_name}-{project_type}' id='rdo_entity_id_{project_info_no}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{project_year}">项目年度</td>
			      <td class="bt_info_odd" exp="{project_typename}">项目类型</td>
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
		  </div>

</body>

 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";

	cruConfig.cdtType = 'form';
 
	var org_id = "<%=orgSubjectionId%>";	

	// 简单查询
	function simpleSearch(){
		var s_project_name = document.getElementById("s_project_name").value;
		var s_project_year = document.getElementById("s_project_year").value;
	
		var str = " 1=1 ";
		
		if(s_project_name!=''){
			str = str + "and project_name like '%"+s_project_name+"%' ";
		}
		if(s_project_year!=''){
			str = str + "and project_year like '%"+s_project_year+"%' ";
		}
		
		cruConfig.cdtStr = str;
		
		refreshData();
	}
	
	function refreshData(){
		cruConfig.queryStr = "select distinct pd.org_id,t.project_type,t.project_info_no,t.project_name,t.project_year,c.coding_name as project_typename from gp_task_project t,comm_coding_sort_detail c,gp_task_project_dynamic pd where t.bsflag = '0' and pd.bsflag = '0' and pd.org_subjection_id like '<%=orgSubjectionId%>%' and t.project_type = c.coding_code_id and pd.project_info_no = t.project_info_no and pd.exploration_method = t.exploration_method and pd.bsflag = '0' and pd.org_id like '<%=user.getTeamOrgId()%>%'  and t.project_type like '%5000100004000000008%'  and t.project_father_no  is null order by t.project_year desc, project_type";
		//cruConfig.queryStr = "select distinct pd.org_id, t.project_info_no,t.project_name,t.project_year,c.coding_name as project_type from gp_task_project t,comm_coding_sort_detail c,gp_task_project_dynamic pd ,comm_coding_sort_detail ccsd ,comm_coding_sort_detail ccsd1, comm_org_information oi,comm_org_subjection s where t.bsflag='0' and pd.bsflag='0'    and pd.org_subjection_id like '"+org_id+"%'  and pd.org_id = oi.org_id and pd.org_id=s.org_id  and t.project_type=c.coding_code_id and t.manage_org = ccsd.coding_code_id and t.market_classify =ccsd1.coding_code_id and pd.project_info_no=t.project_info_no  and pd.exploration_method = t.exploration_method  and pd.bsflag = '0'  and ccsd.bsflag = '0' and ccsd1.bsflag = '0' and s.bsflag='0' and t.project_name like '%%' and t.project_type like '%%'  and t.is_main_project like '%%' and t.project_status like '%%' and oi.org_name like '%%' order by t.project_year desc,project_type";
		cruConfig.currentPageUrl = "/rm/em/humanCostPlan/searchProjectList.jsp";
		queryData(1);	

		
	}

	
	
	function loadDataDetail(ids){

		
	}

	function clearQueryText(){
		 document.getElementById("s_project_name").value="";
		  document.getElementById("s_project_year").value="";
		
	}

	function JcdpButton0OnClick(){
		
		ids = getSelectedValue();

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		

		window.returnValue = ids;
		window.close();  
	}


</script>

</html>