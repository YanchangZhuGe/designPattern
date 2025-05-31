<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	String fileAbbr = request.getParameter("fileAbbr");
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');
		
		var file_name = document.getElementById("file_name").value;
		var create_name = document.getElementById("create_name").value;
		var create_date = document.getElementById("create_date").value;
		var org_id = document.getElementById("org_id").value;  
		
		var sql = "select t.file_id,t.file_name,t.ucm_id,to_char(t.create_date,'yyyy-MM-dd') create_date,e.user_name from bgp_doc_gms_file t left join p_auth_user e on t.creator_id=e.user_id and e.bsflag='0'  where t.bsflag='0' and t.is_file='1' and t.project_info_no='<%=projectInfoNo%>' and t.file_abbr='<%=fileAbbr%>' ";
		if(org_id!=''&&org_id!=null){
			sql = sql+" and t.org_subjection_id like '"+org_id+"%'";
		}
		if(create_name!=''&&create_name!=null){
			sql = sql+" and e.user_name like '%"+create_name+"%'";
		}
		if(create_date!=''&&create_date!=null){
			sql = sql+" and to_char(t.create_date,'yyyy-MM-dd') = '"+create_date+"'";
		}
		if(file_name!=''&&file_name!=null){
			sql = sql+" and t.file_name like '%"+file_name+"%'";
		}
		sql = sql+" order by t.modifi_date desc";
		
		ctt.refreshData2(sql);
		newClose();
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("org_id").value = teamInfo.fkValue;
	        document.getElementById("org_id2").value = teamInfo.value;
	    }
	}
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">文档名称：</td>
      	  <td class="inquire_form4"><input type="text" id="file_name" name="file_name" class="input_width" /></td>
          <td class="inquire_item4">创建人:</td>
          <td class="inquire_form4"><input type="text" id="create_name" name="create_name" class="input_width" />
          </td>
        </tr>
        <tr>
			<td class="inquire_item4">创建时间：</td>
			<td class="inquire_form4"><input type="text" id="create_date" name="create_date" class="input_width" readonly="readonly"/>
			&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(create_date,tributton3);" />&nbsp;</td>
	        <td class="inquire_item4">单位：</td>
	      	<td class="inquire_form4">
	      	<input type="hidden" id="org_id" name="org_id" class="input_width" />
	      	<input type="text" id="org_id2" name="org_id2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
        </tr>
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>

