<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
 


<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgS_id=user.getSubOrgIDofAffordOrg();
	String orgName = user.getOrgName();	
	String rowid = request.getParameter("rowid");
	String laborCategory = request.getParameter("laborCategory");
	String projectInfoNo = user.getProjectInfoNo();
	
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
	
			
			orgSubIdA = (String)mapA.get("orgSubId");
			orgSubIdB = (String)mapOrgB.get("orgSubId");
			
			
			organ_flagA = (String)mapA.get("organFlag");
			organ_flagB = (String)mapOrgB.get("organFlag");
		
		 	if(list.size()>2){
		 		Map mapOrgC = (Map)list.get(2);
		 		orgSubIdC = (String)mapOrgC.get("orgSubId");
		 		organ_flagC = (String)mapOrgC.get("organFlag");
		 	}
		
		 	
			if(organ_flagC.equals("1")){
				orgS_id = orgSubIdB;
			}
			if(organ_flagC.equals("")){
				if(organ_flagB.equals("1")){
					orgS_id = orgSubIdB;
				}
			}
			if(organ_flagB.equals("")){
				if(organ_flagA.equals("1")){
					orgS_id = orgSubIdA;
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

  <title>JCDP_em_human_employee</title> 
  <style type="text/css">
  .select_height{width:150px;}
  SELECT {
  	margin-bottom:0;
      margin-top:0;
  	border:1px #52a5c4 solid;
  	color: #333333;
  	FONT-FAMILY: "微软雅黑";font-size:9pt;
      width:150px;
  }
  }
  </style>
  
 </head> 

 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
      		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td class="ali_cdn_name">单位</td>
		 	    <td class="ali_cdn_input">
		 	    <code:codeSelect name='s_org_id1' option="orgCommOps" addAll="true"  cssClass="select_height"    selectedValue=""  />
		 	    </td>
				<td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="s_employee_name" name="s_employee_name" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">身份证号</td>
			    <td class="ali_cdn_input"><input id="s_employee_id_code_no" name="s_employee_id_code_no" class="input_width" type="text"/></td>	
			   	<td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				
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
			      <td class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{labor_id}-{employee_name}-{employee_id_code_no}-{posts}-{technical_title_name}-{cont_num}' id='rdo_entity_id_{labor_id}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_name}">姓名</td>
			      <td class="bt_info_even" exp="{employee_id_code_no}">身份证号</td>
			      <td class="bt_info_odd" exp="{employee_gender_name}">性别</td>
			      <td class="bt_info_even" exp="{employee_nation_name}">民族</td>
			      <td class="bt_info_odd" exp="{employee_education_level_name}">文化程度</td>
			      <td class="bt_info_even" exp="{phone_num}">联系电话</td>
			      <td class="bt_info_odd" exp="{posts}">岗位</td>
			      <td class="bt_info_even" exp="{technical_title_name}">技术职称</td>
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
 
	var rowid = "<%=rowid%>";
	var org_id = "<%=orgSubjectionId%>";	
 

	// 简单查询
	function simpleSearch(){
		var s_employee_name = document.getElementById("s_employee_name").value;
		var s_employee_id_code_no = document.getElementById("s_employee_id_code_no").value;
	
		var str = " 1=1 ";
		
		if(s_employee_name!=''){
			
			str += " and employee_name like '%"+s_employee_name+"%'";
		}

		if(s_employee_id_code_no!=''){
			
			str += " and employee_id_code_no like '%"+s_employee_id_code_no+"%'";
		}
		
		cruConfig.cdtStr = str;
		
		refreshData();
	}
	var orgS_id ='<%=orgS_id%>';
	function refreshData(){
		var s_org_id = document.getElementsByName("s_org_id1")[0].value;
		if(s_org_id !="" ){orgS_id = s_org_id;}else{orgS_id="<%=orgS_id%>";}
		
		cruConfig.queryStr = "  select wt.not_jieshou,ww.*  from (select  l.labor_id,l.employee_name, l.employee_gender, decode( l.employee_gender,'0','女','1','男','') employee_gender_name, l.employee_nation, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, l.employee_address,l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom ,d3.coding_name posts,  d2.coding_name technical_title_name, d4.coding_name employee_education_level_name, d5.coding_name employee_nation_name ,nvl(l.cont_num,'') cont_num  from bgp_comm_human_labor l  left join comm_coding_sort_detail d3    on l.post = d3.coding_code_id  left join comm_coding_sort_detail d2    on l.technical_title = d2.coding_code_id    left join comm_coding_sort_detail d4 on l.employee_education_level = d4.coding_code_id   left join comm_coding_sort_detail d5 on l.employee_nation = d5.coding_code_id left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0'  where l.bsflag='0' and lt.list_id is null  and l.owning_subjection_org_id like '"+orgS_id+"%'  and l.if_engineer='<%=laborCategory%>'   order by lt.create_date desc )ww left join  (select     t.labor_id ,t.labor_id as not_jieshou     from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2    on t.labor_deploy_id = d2.labor_deploy_id   and d2.bsflag = '0'   left join bgp_comm_human_labor l    on t.labor_id = l.labor_id   where t.bsflag = '0'      and t.end_date is null   and l.if_engineer = '<%=laborCategory%>'  ) wt  on ww.labor_id=wt.labor_id  where wt.not_jieshou  is null  ";
		cruConfig.currentPageUrl = "/rm/em/singleHuman/laborAccept/searchLaborList.jsp";		
		queryData(1);
		
	}

	
	function loadDataDetail(ids){

		
	}
   function clearQueryText(){
	    document.getElementById("s_employee_name").value="";
	    document.getElementById("s_employee_id_code_no").value="";
		 document.getElementsByName("s_org_id1")[0].value="";
   }

	function JcdpButton0OnClick(){
		
		ids = getSelIds('rdo_entity_id');

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		

		top.dialogCallback('getMessage',[rowid,ids]);
		newClose();  
	}


</script>

</html>