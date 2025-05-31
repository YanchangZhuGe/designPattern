<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	
	String id = request.getParameter("id");
	if(id==null){
		id="";
	}
	
	String action = request.getParameter("action");
	if(action==null){
		action="";
	}

	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title></title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form  name="CheckForm" id="CheckForm" method="post" action="" enctype="multipart/form-data" >
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
    
    
    
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
        	<input name="rid" id="rid" type="hidden"  value="<%=id%>" />
          	
          <td class="inquire_item4" >项目名称:</td>
          <td  class="inquire_form4" >
         
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
           <%-- 	--%>
          </td>
          
          <td class="inquire_item4" >施工地区:</td>
          <td  class="inquire_form4" >
          <%-- --%>
          	<input name="construction_area" id="construction_area" class="input_width" type="text"  value="" readonly/>
          	
          </td>
        
        </tr>
        <tr>
          <td class="inquire_item4" >勘探方法:</td>
          <td  class="inquire_form4"  >
          <textarea name="method_code" id="method_code" rows="3" cols="40" readonly></textarea>
          <%-- 
          	<input name="method_code" id="method_code" class="input_width" type="text"  value="" readonly/>
          	--%>
          </td>
          <td class="inquire_item4" >施工队伍:</td>
          <td class="inquire_form4" >
          <%-- 	--%>
          	<input name="work_team" id="work_team" class="input_width" type="text"  value="" readonly/>
          
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >队经理:</td>
          <td  class="inquire_form4" >
          	<input name="team_manager" id="team_manager" class="input_width" type="text"  value="" readonly/>
          	
          </td>
          <td class="inquire_item4" >申请日期:</td>
          <td  class="inquire_form4" >
          <%-- --%>
          	<input name="create_date" id="create_date" class="input_width" type="text"  value="" readonly/>
          	
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请人:</td>
          <td  class="inquire_form4" >
          <%-- --%>
          	<input name="creator" id="creator" class="input_width" type="text"  value="" />
          	
          </td>
          <%-- 
          <td class="inquire_item4" >审批状态:</td>
          <td class="inquire_form4" >
          
          	<input name="status" id="status" class="input_width" type="text"  value="" readonly/>
          	--%>
          </td>
        </tr>
        
	    			 
        
        <tr>
          <td class="inquire_item4" >主要技术资料清单:</td>
          <td class="inquire_form4" >
          	<input name="technical_data" id="technical_data" class="input_width" type="file"  />
          	<div id="file1">
          	
          	</div>
          </td>
          <td class="inquire_item4" >动迁计划:</td>
          <td class="inquire_form4" >
          	<input name="relocation_plan" id="relocation_plan" class="input_width" type="file"  />
          	<div id="file2">
          	
          	</div>
          </td>
        </tr>
      </table>
     
	  
      
    </div>
    <%if(!"view".equals(action)){ %>
    
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="tave()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    <%} %>
  </div>
</div>
</form>
</body>
<script type="text/javascript">



var relocationId ="<%=id%>"; //动迁记录 id
function refreshData(){
	var retObj = null;
	if(relocationId!=null&&relocationId!=''){
		//存在记录  读取
		retObj = jcdpCallService("WtRelocationSrv", "getAddPageData", "id="+relocationId);
	}else{
		//新增
		retObj = jcdpCallService("WtRelocationSrv", "getAddPageData", "");
	}

	
	
	if(retObj!=null&&retObj.relocationMap!=null){

		document.getElementById("project_name").innerText =retObj.relocationMap.project_name;
		document.getElementById("construction_area").innerText =retObj.relocationMap.construction_area;


		
		// 根据项目id 取勘探方法名称document.getElementById("method_code").innerText =retObj.relocationMap.method_code;
		//var retObj1 = jcdpCallService("WtProjectSrv", "getProjectExploration", "projectInfoNo=<%=projectInfoNo%>");
		//if(null!=retObj1.explorationMap){
		//	document.getElementById("method_code").innerText =retObj1.explorationMap.exploration_method_name;
		//}
		document.getElementById("method_code").innerText =retObj.relocationMap.method_code;

		//根据项目id  取施工队document.getElementById("work_team").innerText =retObj.relocationMap.work_team;
		//var retObj2 = jcdpCallService("WtProjectSrv", "getProjectOrgNames", "projectInfoNo=<%=projectInfoNo%>");
		//if(null!=retObj2.orgNameMap){
		//	//中文
		//	document.getElementById("work_team").innerText = retObj2.orgNameMap.org_name;
		//}
		document.getElementById("work_team").innerText =retObj.relocationMap.work_team;
		
		
		document.getElementById("team_manager").innerText =retObj.relocationMap.team_manager;
		document.getElementById("create_date").innerText =retObj.relocationMap.create_date;
		document.getElementById("creator").innerText =retObj.relocationMap.creator;
		debugger;
		
		if(retObj.relocationMap.technical_data!=null&&retObj.relocationMap.technical_data!=''){
			document.getElementById("file1").innerHTML ="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj.relocationMap.technical_data+"&emflag=0>"+retObj.relocationMap.technical_data_filename+"</a>";

		}
		if(retObj.relocationMap.relocation_plan!=null&&retObj.relocationMap.relocation_plan!=''){
			document.getElementById("file2").innerHTML ="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj.relocationMap.relocation_plan+"&emflag=0>"+retObj.relocationMap.relocation_plan_filename+"</a>";
		}
		

		//document.getElementById("status").innerText =retObj.relocationMap.proc_status_name;
		

		

		
		//relocationId = retObj.relocationMap.id;//记录ID
		//relocationStatus = retObj.relocationMap.status;//审核状态

		//setTab0();
		
		<%--
		
		//tr.insertCell().innerHTML =retObj.relocationMap.vsp_team_no;
		//tr.insertCell().innerHTML =retObj.relocationMap.creator;


		--%>
		
		//rsMap.put("technical_data", fileUcmId);//主要技术资料清单
		//rsMap.put("relocation_plan", fileUcmId);//动迁计划
		
	}

}
	
	function tave(){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/wt/relocation/toSaveRelocation.srq";
		form.submit();		
	}

	var action = "<%=action%>";
	if(action=="view"){
		
		$(":input").each(function(){
			$(this).attr("disabled",true); 
		})
	}

</script>
</html>

