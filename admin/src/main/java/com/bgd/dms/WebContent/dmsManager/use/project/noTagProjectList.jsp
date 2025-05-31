<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();

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
		isClickNode = "";
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType=request.getParameter("projectType")==null?"":request.getParameter("projectType");
	if(projectType==null||"".equals(projectType)||"null".equals(projectType)){
		projectType = user.getProjectType();
	}
%>
<html>
<head>
<script type="text/javascript">
var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],
		['5000100001000000002','正在运行'],
		['5000100001000000003','项目结束'],
		['5000100001000000004','项目暂停'],
		['5000100001000000005','施工结束']
		);
var projectType1 = new Array(
		 ['5000100004000000001','陆地项目'],
		 ['5000100004000000008','井中项目'],
		 ['5000100004000000002','浅海项目'],
		 ['5000100004000000003','非地震项目'],
		 ['5000100004000000005','地震项目'],
		 ['5000100004000000006','深海项目'],
		 ['5000100004000000009','综合物化探'],
		 ['5000100004000000007','陆地和浅海项目'],
		 ['5000100004000000010','滩浅海过渡带']
		 );

</script>
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

<title>无标题文档</title>
</head>

<body style="background:#fff">
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
			    <td class="ali_cdn_name">项目状态</td>
			    <td class="ali_cdn_input">
			    	<select id="projectStatus" name="projectStatus" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="5000100001000000001">项目启动</option>
						<option value="5000100001000000002">正在运行</option>
						<option value="5000100001000000003">项目结束</option>
						<option value="5000100001000000004">项目暂停</option>
						<option value="5000100001000000005">施工结束</option>
			    	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dk" event="onclick='toSubProjects()'" title="子项目列表"></auth:ListButton>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
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
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{project_type}-{project_year}-{org_subjection_id}-{org_id}-{project_name}' id='rdo_entity_id_{project_info_no}' onclick='chooseOne(this)'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
			      <td class="bt_info_odd"  exp="{project_status}"  func="getOpValue,projectStatus1">项目状态</td>
			      <td class="bt_info_even" exp="{project_type}"  func="getOpValue,projectType1">项目类型</td>
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
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
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
	var orgId="<%=orgId %>";
	var isClickNode = "<%=isClickNode%>";
	var projectName="";
	var projectId="";
	var projectType="<%=projectType%>";
	var projectYear="";
	var isMainProject="";
	var projectStatus="";
	var orgName="";
	cruConfig.queryService="ProjectSrv";
	cruConfig.queryOp = "queryProject";

	if("5000100004000000001"==projectType){
		projectType = "5000100004000000001,5000100004000000002,5000100004000000010";
	}
	if("5000100004000000002"==projectType){
		projectType = "5000100004000000001,5000100004000000002,5000100004000000010";
	}
	if("5000100004000000010"==projectType){
		projectType = "5000100004000000001,5000100004000000002,5000100004000000010";
	}
	
	// 复杂查询
	function refreshData(q_projectName, q_projectYear,q_projectType, q_isMainProject, q_projectStatus, q_orgName, q_orgSubjectionId){
		
		if(isClickNode == "1"){
			cruConfig.submitStr = "projectType="+q_projectType+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&projectYear="+q_projectYear+"&isMainProject="+q_isMainProject+"&projectStatus="+q_projectStatus+"&orgName="+q_orgName+"&isSingle=<%=isSingle %>";
		}else{
			cruConfig.submitStr = "funcCode=F_COMM_005"+"&projectType="+q_projectType+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&projectYear="+q_projectYear+"&isMainProject="+q_isMainProject+"&projectStatus="+q_projectStatus+"&orgName="+q_orgName+"&isSingle=<%=isSingle %>";
		}
		queryData(1);
		var retObj = jcdpCallService("ProjectSrv", "queryProject", cruConfig.submitStr);
		var message = retObj.message;
		if(message=='noproject'){//如果没有项目 直接弹框提示立项
			window.open("<%=contextPath%>/pm/project/multiProject/selectProjectType.jsp","_self")
		}
	}

	refreshData("", "",projectType, "", "", "", "<%=orgSubjectionId%>");
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		var q_projectStatus = document.getElementById("projectStatus").value;
		refreshData(q_projectName, "",projectType, "",q_projectStatus, "", orgSubjectionId);
	}
	
	function clearQueryText(){
		document.getElementById("projectName").value = "";
		document.getElementById("projectStatus").value = "";
	}

	function toSearch(){
		//popWindow('<%=contextPath%>/pm/project/multiProject/project_search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function toSubProjects(){
		//{project_info_no}-{project_type}-{project_year}-{org_subjection_id}-{org_id}
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中至少一条记录!");
	     	return;
	    }
	    var project_info_no = ids.split("-")[0];
	    var project_type = ids.split("-")[1];
	    var project_year = ids.split("-")[2];
	    var org_subjection_id = ids.split("-")[3];
	    var org_id = ids.split("-")[4];
	    var projectName = encodeURI(encodeURI(ids.split("-")[5]));
	    location.href="<%=contextPath %>/pm/project/multiProject/noTagSubProjectsList.jsp?action=<%=action%>&projectName="+projectName+"&projectType="+project_type+"&projectFatherNo="+project_info_no+"&orgSubjectionId="+org_subjection_id+"&projectYear="+project_year+"&orgId="+org_id;
	}
	
	function dbclickRow(ids){
		alert("111111");
		var projectInfoNo = ids.split("-")[0];
		<%if(action.equals("view")){ %>
		location.href="<%=contextPath %>/pm/project/selectProject.srq?projectInfoNo="+projectInfoNo;
		var name = document.getElementById("projectName"+projectInfoNo).value;
		var longName = name;
		//alert(name.length);
		if (name.length > 16){
			name = name.substring(0,16)+"...";
		}
		parent.window.opener.setProject(longName, name);//.document.getElementById('projectName').innerHTML='<a href="#"  onclick="selectProject();" title="'+longName+'">'+name+'</a>';
 		//parent.window.opener.top.location.reload();
		var objs = parent.window.opener.top.frames['topFrame'].document.getElementById("tags").children;
 		for(var i =0;i<objs.length;i++){
 			var a = objs[i].children[0];
 			if(a.innerText=='经营管理'){
 				a.style.display = 'block';
 			}
 		}
 /* 	 var menuId = parent.window.opener.top.frames['topFrame'].getMenuId();

 	 if(menuId !="gms_menu"){
 	 	parent.window.opener.top.frames['navFrame'].loadData(menuId);
 	  } */

		parent.window.close();
		<%} else {%>
		popWindow('<%=contextPath%>/pm/project/multiProject/viewProject.jsp?projectInfoNo='+projectInfoNo);
		<%} %>
	}
	
	
	
	
	//chooseOne()函式，參數為觸發該函式的元素本身
    function chooseOne(cb){
        //先取得同name的chekcBox的集合物件
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選
            if (obj[i]!=cb) obj[i].checked = false;
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選
            //else  obj[i].checked = cb.checked;
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行
            else obj[i].checked = true;
        }
    }
</script>

</html>

