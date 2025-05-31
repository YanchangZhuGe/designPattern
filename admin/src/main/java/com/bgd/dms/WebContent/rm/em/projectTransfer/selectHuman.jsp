<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%>  
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
  
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String projectInfoNo =  request.getParameter("projectInfoNo");	 
	 
	String projectType=(user==null)?"":user.getProjectType();
	  if(projectType !=null ){
			if(projectType.equals("5000100004000000008")){
				projectType="5000100004000000001";
			}
			if(projectType.equals("5000100004000000010")){
				projectType="5000100004000000001";
			} 
			if(projectType.equals("5000100004000000002")){
				projectType="5000100004000000001";
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

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
 
 
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
			    <td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" onchange="getPost()"></select>
			     
				<input type='hidden' id="checkall" name="checkall" value="0"/>
				<input type='hidden' id="szButton" name="szButton" value=""/> 
		    
			    </td>
			    <td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><select class="select_width"  id="s_post" name="s_post" ></select></td>
			    
			    <td class="ali_cdn_name">用工性质</td>
			    <td class="ali_cdn_input">
				    <select id="xzV"  name="xzV" style="width:100px;">
					<option value="" >请选择</option>
					<option value="1">正式工</option>
					<option value="0">临时工</option>
					</select>
			    </td>
			    
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="toSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSave()'" title="提交"></auth:ListButton>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{pk_ids}-{xz_type}-{employee_id}-{employee_cd}-{employee_name}-{team_name}-{work_post_name}-{employee_gz_name}-{zy_type}' id='rdo_entity_id' />" >
					<input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{employee_gz_name}">用工性质</td>
			      <td class="bt_info_odd" exp="{employee_cd}">员工编号</td>
			      <td class="bt_info_even" exp="{employee_name}">员工姓名</td>
			      <td class="bt_info_odd" exp="{team_name}">班组</td>
			      <td class="bt_info_even" exp="{work_post_name}">岗位</td>
			   
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
	var projectInfoNo="<%=projectInfoNo%>";
 
	function refreshData(){	 
		var headChx = document.getElementById("headChxBox");	
		head_chx_box_changed(headChx);
 
		cruConfig.queryStr = "select t.*  from (select distinct t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   t.ACTUAL_START_DATE,  t.ACTUAL_END_DATE,  t.plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name , t.zy_type  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id    left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id    left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where t.project_info_no = '<%=projectInfoNo%>' and t.zy_type  is null  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id is null  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME) t  where 1 = 1 ";
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanJobChange/addJobChange.jsp";
		queryData(1); 
		 
	}
 
	function toSearch(){ 
		var xzV = document.getElementById("xzV").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;
		
		var str = "  1=1 ";
		if(xzV!=''){
			str += " and xz_type = '"+xzV+"' ";
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
		document.getElementById("xzV").value="";
		document.getElementById("s_apply_team").value="";
    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);
	}
 
	function toSave(){
		
		ids = getSelIds('rdo_entity_id');

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		   
//alert([rowid,ids]); 
		top.dialogCallback('getMessage',[ids]);
		newClose();  
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
    

	function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("rdo_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
		  }
		  
		}
		if(headChx.checked){
			document.getElementById("checkall").value="1";
		}else{
			document.getElementById("checkall").value="0";
		}
	}
	

</script>
</html>