<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.cfg.*"%>
<%
   ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
    String urlFlex = cfgHd.getSingleNodeValue("//bgp/url"); 
    
	String contextPath = request.getContextPath();

    String remoteHost = request.getRemoteHost(); 
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	
	String action = request.getParameter("action");
	if("".equals(action) || action == null){
		action = "edit";
	}
	
	String isSingle = request.getParameter("isSingle");
	if("".equals(isSingle) || isSingle == null){
		isSingle = "";
	}
	
	String isClickNode = request.getParameter("clickNode");
	if("".equals(isClickNode) || isClickNode == null){
		isClickNode = "1";
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType=request.getParameter("projectType")==null?"":request.getParameter("projectType");
	if(projectType==null||"".equals(projectType)||"null".equals(projectType)){
		if(orgSubjectionId.startsWith("C105005001")){
			projectType = "";//综合物化探查询过滤 不过滤项目类型
		}else{
			projectType = user.getProjectType();
		}
		
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

<title>项目信息</title>
</head>

<body style="background:#fff" >
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名</td>
			    <td class="ali_cdn_input">
				    <input id="projectName" name="projectName" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="tj" event="onclick='saveBake()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd"  exp="<input type='radio' name='rdo_entity_id' value='{project_info_no}~{project_name}' id='rdo_entity_id_{project_info_no}'  ondbclick='chooseOne(this);'/{selectflag}>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
			      <td class="bt_info_odd"  exp="{org_name}">施工队伍</td>
			      <td class="bt_info_even"  exp="{manage_org_name}">甲方单位</td>
			      <td class="bt_info_odd" exp="{start_date}">采集开始时间</td>
			      <td class="bt_info_even"  exp="{end_date}">采集结束时间</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
		  </div>
</body>
<script type="text/javascript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
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
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var orgId="<%=orgId%>";
	var isClickNode = "<%=isClickNode%>";
	var projectName="";
	var projectId="";
	var projectType="<%=projectType%>";
	var projectYear="";
	var isMainProject="";
	var projectStatus="";
	var orgName="";
	cruConfig.queryService="ProjectSrvOld";
	cruConfig.queryOp = "queryProject";
	projectType = "5000100004000000001,5000100004000000002";
	
	// 复杂查询
	function refreshData(q_projectName, q_projectYear,q_projectType, q_isMainProject, q_projectStatus, q_orgName, q_orgSubjectionId){
		if(isClickNode == "1"){
			cruConfig.submitStr = "projectType="+q_projectType+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&projectYear="+q_projectYear+"&isMainProject="+q_isMainProject+"&projectStatus="+q_projectStatus+"&orgName="+q_orgName+"&isSingle=<%=isSingle %>";
		}else{
			cruConfig.submitStr = "funcCode=F_COMM_005"+"&projectType="+q_projectType+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&projectYear="+q_projectYear+"&isMainProject="+q_isMainProject+"&projectStatus="+q_projectStatus+"&orgName="+q_orgName+"&isSingle=<%=isSingle %>";
		}
		queryData(1);
		var retObj = jcdpCallService("ProjectSrvOld", "queryProject", cruConfig.submitStr);
		var message = retObj.message;
	}

	refreshData("", "",projectType, "", "", "", "<%=orgSubjectionId%>");
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "",projectType, "","", "", orgSubjectionId);
	}
	
	function clearQueryText(){
		document.getElementById("projectName").value = "";
		
	}
	
	  //选择一条记录
	  function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else 
	             {obj[i].checked = true;  
	              checkvalue = obj[i].value;
	             } 
	        }   
	    } 
    function saveBake(){
   	 ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			
			else{
				var projectMsg="";
				$("input[type='radio'][name='rdo_entity_id']").each(function(i){
					if($(this).attr("checked")){
						projectMsg+=$(this).val()+",";
					}
					
				});
					window.returnValue = projectMsg;
			     	window.close();
			}
        }
	
</script>

</html>

