<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String shuaId = request.getParameter("shuaId");
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>返还明细添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<input   name="shuaId" id="shuaId" class="input_width" type="hidden" value="<%=shuaId%>" readonly/>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">返还申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input   name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
        </td>
          <td class="inquire_item4">返还申请单号:</td>
          <td class="inquire_form4">
          	<input readonly  name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4">
          	<input   name="backapp_name" id="backapp_name" class="input_width" style="width:92%" type="text" readonly />
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input   name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
       <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input   name="back_org_name" id="back_org_name" class="input_width" type="text" value="" readonly/>
          </td>
          <td class = "inquire_item4" id="check1">接收单位：</td>
             <td class="inquire_form4">
          <select name ="checkOrg" id="checkOrg" class="selected_width">
          		<option value="C6000000000041">测量服务中心</option>
          		<option value="C6000000000042">仪器服务中心</option>
          		<option value="C6000000005551">塔里木作业部</option>
          		<option value="C6000000005538">北疆作业部</option>
          		<option value="C6000000005555">吐哈作业部</option>
          		<option value="C6000000005543">敦煌作业部</option>
          		<option value="C6000000005534">长庆作业部</option>
          		<option value="C6000000007537">辽河作业部</option>
          		<option value="C6000000005547">华北作业部</option>
          		<option value="C6000000005560">新区作业部</option>
          		<option value="C6000000005532">测量服务中心大港作业分部</option>
          	</select>
          </td>
        </tr>
        
     </table>
     </fieldset>
     </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">

	function submitInfo(){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveStockinMain.srq";
			document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		var devicebackappid = '<%=shuaId%>';
		var querySql = "select t.device_coll_mixinfo_id,t.project_info_id,gp.project_name,t.device_mixapp_no,";
    	querySql += "collback.device_backapp_no,collback.backapp_name,i.org_abbreviation as back_org_name,";
    	querySql += "org.org_abbreviation as receive_org_name,mixorg.org_abbreviation as mix_org_name,emp.employee_name,";
    	querySql += "collback.backdate,case t.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
    	querySql += "from gms_device_coll_backinfo_form t left join gp_task_project gp on t.project_info_id=gp.project_info_no and gp.bsflag='0' ";
    	querySql += "left join (gms_device_collbackapp collback left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag='0' ";
    	querySql += "left join comm_human_employee emp on collback.back_employee_id = emp.employee_id) on t.device_backapp_id = collback.device_backapp_id ";
    	querySql += "and collback.bsflag='0' left join comm_org_information org on t.receive_org_id= org.org_id ";
    	querySql += "and org.bsflag='0' left join comm_org_information mixorg on t.backmix_org_id =mixorg.org_id and mixorg.bsflag='0'  where t.device_coll_mixinfo_id='"+devicebackappid+"'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(proqueryRet!=null && proqueryRet.returnCode =='0'){
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#device_backapp_no").val(retObj[0].device_backapp_no);
			$("#backapp_name").val(retObj[0].backapp_name);
			$("#back_org_name").val(retObj[0].back_org_name);
			$("#backdate").val(retObj[0].backdate);
			showCheckOrg(retObj[0].project_info_id);
		}
	}
	function showCheckOrg(projectInfoNo){
		var retObj = jcdpCallService("DevProSrv","findProjectOrgSubIdByProNo","projectInfoNo="+projectInfoNo);
		var checkOrgId = retObj.checkOrgId;
		$("#checkOrg").val(checkOrgId);
}
</script>
</html>

