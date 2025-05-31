<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String parentMenuId = request.getParameter("parentMenuId");
	System.out.println(parentMenuId);
%>
<html>
<head>
<title>新增页面</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/styles/style.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script> 

<script language="javaScript">

function submitFunc(){
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/mat/buss/saveMatBuss.srq";
	form.submit();
	
	setTimeout(function(){parent.treeFrame.location.href = "menu_tree.jsp";}, 1000);
//	parent.treeFrame.location.href = "menu_tree.jsp";
	document.getElementById("submitButton").disabled = true;
}

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.lineRange = "1";
	cru_init();
}

function selectOrg(){
    var teamInfo = {
        orgId:"",
        orgSubjectionId:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/mat/common/setMatOrg/selectOrgHR.jsp',teamInfo);
    if(teamInfo.orgSubjectionId!=""){
    	document.getElementById("org_subjection_id").value = teamInfo.orgSubjectionId;
        document.getElementById("org_id").value = teamInfo.orgId;
        document.getElementById("org_name").value = teamInfo.value;
    }
}

</script>
</head>

<body  class="bgColor_f3f3f3" onLoad="page_init()">
 <div id="new_table_box"> 
   <div id="new_table_box_content"> 
    <div id="new_table_box_bg"> 
     <form name="form"  method="post" target="hidden_frame"> 
     	<input type="hidden" id="fatherMatMenuId" name="fatherMatMenuId" value="<%=parentMenuId %>" />
      <span id="hiddenFields" style="display:none"></span>
      <table id="rtCRUTable" class="tab_line_height" cellpadding="0" cellspacing="0">  
      	<tr>
      		<td class="inquire_item6" style="width: 20%">名称:</td>
      		<td class="inquire_form6" style="width: 80%"><input type="text" id="menu_name" name="menu_name" style="width: 60%"></input></td>
      	</tr>
      	<tr>
      		<td class="inquire_item6" style="width: 20%">从属单位:</td>
      		<td class="inquire_form6" style="width: 80%">
      		<input type="hidden" id="org_subjection_id" name="org_subjection_id"></input>
      		<input type="hidden" id="org_id" name="org_id"></input>
      		<input type="text" id="org_name" name="org_name"></input>
      		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
      		</td>
      	</tr>
      	<tr>
      		<td class="inquire_item6" style="width: 20%">是否叶子节点:</td>
      		<td class="inquire_form6" style="width: 80%">
      			<select id="is_leaf" name="is_leaf" class="" style="width: 25%;">
					<option value="1">是</option>
					<option value="0">否</option>
				</select>
      		</td>
      	</tr>
      	<tr>
      		<td class="inquire_item6" style="width: 20%">序号:</td>
      		<td class="inquire_form6" style="width: 80%"><input type="text" id="order_num" name="order_num"></input></td>
      	</tr>
      	<tr>
      		<td class="inquire_item6" style="width: 20%">备注:</td>
      		<td class="inquire_form6" style="width: 80%"><textarea class="textarea" id="memo" name="memo"></textarea></td>
      	</tr>
      </table> 
     </form> 
     <iframe name="hidden_frame" width="1" height="1" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe> 
    </div> 
    <div class="ctrlBtn" id="cruButton">
     <input type="button" id="submitButton" class="btn btn_submit" onclick="submitFunc()" />
    </div> 
   </div> 
  </div> 

</body>
</html>