<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userName = user.getUserName();
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[backTypeIDs.length-1];
	String[] backTypeNames = rb.getString("BackTypeName").split("~", -1);
	String[] backTypeUserNames = rb.getString("BackTypeUserName").split("~", -1);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend>返还单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" style="color:#B0B0B0;" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden" value="<%=projectInfoNo%>"/>
          	<input name="backapptype" id="backapptype" type="hidden" value="1" />
          </td>
          <td class="inquire_item4">返还申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="backappname" id="backappname" class="input_width" style="width:92%" type="text" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" value="<%=user.getOrgId()%>" type="hidden" />
          </td>
          <td class="inquire_item4">接收单位:</td>
          <td class="inquire_form4">
          	<input name="receive_org_name" id="receive_org_name" class="input_width" type="text" readonly/>
          	<input name="receive_org_id" id="receive_org_id" class="input_width" type="hidden" />
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
          </td>
        <tr>
        </tr>
        <tr>
          
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        </tr>
      </table>
      </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function saveInfo(){
		var backappname = $("#backappname").val();
		if(backappname == ""){
			alert("请输入返还单名称!");
			return;
		}
		var receive_org_name = $("#receive_org_name").val();
		if(receive_org_name == ""){
			alert("请输入接收单位!");
			return;
		}
		//将申报单的名字置为空
		$("#device_backapp_no").val("");
		
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveBackCollectAppInfo.srq?state=0&device_backapp_id="+'<%=devicebackappid%>';
		document.getElementById("form1").submit();
	}
	
	
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/collectDevBack/selectOrgHR.jsp?codingSortId=0110000001","test","");
		
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("receive_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("receive_org_id").value = orgId[1];
	}
	function refreshData(){
		var retObj;
		var devicebackappid = '<%=devicebackappid%>';
		if(devicebackappid!=null){
			//查询明细信息
			var querySql="select colback.project_info_id, colback.device_backapp_id,colback.DEVICE_BACKAPP_NO,colback.BACKAPP_NAME,pro.project_name,"
			+"org.org_abbreviation as back_org_name,recvorg.org_abbreviation as receive_org_name,recvorg.org_id as receive_org_id,"
			+"emp.employee_name as back_employee_name,colback.backdate, to_char(sysdate,'yyyy-mm-dd') as curdate,"
			+"case colback.state when '0' then '未提交' when '9' then '已提交' end as state_desc "
			+"from GMS_DEVICE_COLLBACKAPP colback "
			+"left join gp_task_project pro on colback.project_info_id = pro.project_info_no "
			+"left join comm_org_information org on colback.back_org_id = org.org_id "
			+"left join comm_org_information recvorg on colback.receive_org_id = recvorg.org_id "
			+"left join comm_human_employee emp on colback.back_employee_id = emp.employee_id ";
			querySql += "where colback.device_backapp_id= '"+devicebackappid+"' ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#project_info_no").val(retObj[0].project_info_id);
			$("#backappname").val(retObj[0].backapp_name);
			$("#receive_org_name").val(retObj[0].receive_org_name);
			$("#receive_org_id").val(retObj[0].receive_org_id);
			
			$("#backdate").val(retObj[0].curdate);
			
		}
	}
</script>
</html>

