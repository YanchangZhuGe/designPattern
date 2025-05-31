<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();//getOrgSubjectionId();
	String orgName = user.getOrgName();
	String str_sql="    and   t.project_type ='5000100004000000008' ";
	if(orgSubjectionId.startsWith("C105005001")){
		str_sql=" and t.project_type ='5000100004000000008'    ";
	}
	String types=request.getParameter("types");
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
				   <auth:ListButton functionId="" css="dk" event="onclick='toSon()'" title="查看子项目"></auth:ListButton>	    
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{ws_project_no}-{option_type}' id='rdo_entity_id_{ws_project_no}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{project_year}">项目年度</td>
			      <td class="bt_info_odd" exp="{project_type_name}">项目类型</td>
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
	var types = "<%=types%>";	
	
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
		if(types =="vsp"){
			cruConfig.queryStr = " select s1.coding_name project_type_name,s2.coding_name market_classify_name ,pt.ws_project_no,pt.project_name,pt.project_id,pt.project_year,pt.project_type,pt.market_classify,pt.option_type,pt.bsflag  from GP_WS_PROJECT  pt   left join comm_coding_sort_detail s1   on pt.project_type = s1.coding_code_id   and s1.bsflag = '0'    left join comm_coding_sort_detail s2    on pt.market_classify = s2.coding_code_id   and s2.bsflag = '0'   where pt.bsflag='0' and pt.option_type='vsp'  order by pt.modifi_date desc  ";
		}else{
			cruConfig.queryStr = " select s1.coding_name project_type_name,s2.coding_name market_classify_name ,pt.ws_project_no,pt.project_name,pt.project_id,pt.project_year,pt.project_type,pt.market_classify,pt.option_type,pt.bsflag  from GP_WS_PROJECT  pt   left join comm_coding_sort_detail s1   on pt.project_type = s1.coding_code_id   and s1.bsflag = '0'    left join comm_coding_sort_detail s2    on pt.market_classify = s2.coding_code_id   and s2.bsflag = '0'   where pt.bsflag='0' and pt.option_type='vdz'  order by pt.modifi_date desc  ";
		}
		 
		cruConfig.currentPageUrl = "/td/vspExplain/vdzCommitments/optionProjectList.jsp";
		queryData(1);	

		
	}

	function toSon(){ 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		} 
		window.location = '<%=contextPath%>/td/vspExplain/vdzCommitments/optionProjectListZ.jsp?projectFatherNo='+ids.split("-")[0]+'&types=<%=types%>&optionType='+ids.split("-")[1];
		 
	}
 

	function clearQueryText(){
		 document.getElementById("s_project_name").value="";
		  document.getElementById("s_project_year").value="";
		
	}

	 

</script>

</html>