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
	String projectFatherNo=request.getParameter("projectFatherNo");
	String optionType=request.getParameter("optionType");
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

  <title>查询已维护项目</title> 
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
			   
			   	<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				<td>&nbsp;</td>
				<auth:ListButton functionId="" css="tj" event="onclick='JcdpButton0OnClick()'" title="提交"></auth:ListButton>		    
			    <auth:ListButton functionId="" css="fh" event="onclick='fanhui()'" title="退回"></auth:ListButton>	
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{ws_detail_no},{project_name},{project_type},{optioning_type}' id='rdo_entity_id_{ws_detail_no}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
  				 <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{manage_org_name}">甲方单位</td>	
			      <td class="bt_info_odd" exp="{well_no}">井号</td>
			      <td class="bt_info_even" exp="{business_type_name}">项目业务类型</td>		
			      <td class="bt_info_odd" exp="{start_time}">项目开始时间</td>
			      <td class="bt_info_even" exp="{end_time}">项目结束时间</td>		
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
    var optionType="<%=optionType%>";
	// 简单查询
	function simpleSearch(){
		var s_project_name = document.getElementById("s_project_name").value;
 
	
		var str = " 1=1 ";
		
		if(s_project_name!=''){
			str = str + "and project_name like '%"+s_project_name+"%' ";
		}
		 
		
		cruConfig.cdtStr = str;
		
		refreshData();
	}
	
	function refreshData(){ 
 
	   cruConfig.queryStr = " select t.* from ( select  'jz' optioning_type,ccsd.coding_name as manage_org_name,decode(pdt.project_type,'5000100004000000008','井中地震')project_type_name,decode(pdt.project_country,'1','国内','2','国外')project_country_name,decode(pdt.is_main_project,'1','集团重点','2','地区（局）重点','3','正常')is_main_name,decode(pdt.project_business_type,'1','处理','2','解释','3','处理,解释') business_type_name, pdt.ws_detail_no ,pdt.ws_project_no,pdt.project_name,pdt.project_id,pdt.project_year,pdt.project_type,pdt.market_classify,pdt.well_no,pdt.option_type,pdt.start_time,pdt.end_time,pdt.is_main_project,pdt.project_country,pdt.manage_org,pdt.prctr,pdt.prctr_name,pdt.project_business_type  from  GP_WS_PROJECT_DETAIL pdt  left join comm_coding_sort_detail ccsd on pdt.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0'   where pdt.bsflag='0' and pdt.option_type='<%=optionType%>' and pdt.ws_project_no='<%=projectFatherNo%>' order by pdt.modifi_date desc ) t  where  t.ws_detail_no not in (select project_info_no from GP_WS_VSP_COMMITMENTS   where    bsflag='0' ) ";
  		cruConfig.currentPageUrl = "/rm/em/humanCostPlan/searchProjectList.jsp";
		queryData(1);	

		
	}

	
	
	function fanhui(){
		window.location = '<%=contextPath%>/td/vspExplain/vdzCommitments/optionProjectList.jsp?types=<%=types%>';
 
	}

	function clearQueryText(){
		 document.getElementById("s_project_name").value="";
	 
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