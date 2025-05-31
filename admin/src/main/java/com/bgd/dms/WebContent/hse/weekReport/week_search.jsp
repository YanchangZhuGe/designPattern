<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
	String fatherId = "";
	String sql = "select os2.father_org_id from comm_org_subjection os1 join comm_org_subjection os2 on os1.code_afford_org_id=os2.org_id where os1.bsflag='0' and os2.bsflag='0' and os1.org_subjection_id = '"+org_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		fatherId = (String)map.get("fatherOrgId");
		int length = fatherId.length();
		if(fatherId.equals("C1")){
			org_id = org_id.substring(0,4);
		}else if(fatherId.equals(org_id.substring(0,org_id.length()-6))){
			org_id = org_id.substring(0,org_id.length()-3);
		}
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
<script language="javaScript">
var org_id = '<%=org_id%>';
	function submit(){
		var ctt = top.frames('list');
		
		var second_org = document.getElementById("second_org").value;
		var startDate = document.getElementById("startDate").value;
		var user_name = document.getElementById("user_name").value;  

		
		sql = "select c.hse_common_id,c.org_id,c.week_start_date,c.week_end_date,c.creator_id,u.user_name,c.modifi_date,decode(c.subflag,'0','未提交','1','已提交') as subflag,i.org_abbreviation as org_name from bgp_hse_common c join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag = '0' join comm_org_information i on s.org_id = i.org_id and i.bsflag='0'  join p_auth_user u on c.creator_id = u.user_id and u.bsflag='0'"
			+" where c.bsflag='0'";
			if(org_id=="C105"){
				sql = sql+" and (s.father_org_id = 'C105' or s.org_subjection_id='C105')";
			}else{
				sql = sql+" and s.father_org_id = '<%=fatherId%>'";
			}
			if(second_org!=''&&second_org!=null){
				sql = sql+" and c.second_org = '"+second_org+"'";
			}
			if(startDate!=''&&startDate!=null){
				sql = sql+" and c.week_start_date = to_date('"+startDate+"','yyyy-MM-dd')";
			}
			if(user_name!=''&&user_name!=null){
				sql = sql+" and u.user_name like '%"+user_name+"%'";
			}
			sql = sql+" order by c.week_start_date desc,c.modifi_date desc";
		
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
	    	 document.getElementById("second_org").value = teamInfo.fkValue;
	    	 alert(teamInfo.fkValue);
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
	function fridaySelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m-%d",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    true,
			singleClick    :    true,
			step        : 1,
			disableFunc: function(date) {
		        if (date.getDay() != 5) {
		            return true;
		        } else {
		            return false;
		        }
		    }
		    });
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
        	<td class="ali_cdn_name">开始日期</td>
			    <td class="ali_cdn_input">
			    <input id="startDate" name="startDate" type="text" readonly="readonly"/>
			    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="fridaySelector(startDate,tributton0);"/> &nbsp;
			</td>
	        <td class="inquire_item6">单位：</td>
	      	<td class="inquire_form6">
		      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
		      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
		      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	      	<td class="inquire_item6">填写人：</td>
	      	<td class="inquire_form6">
	      		<input type="text" id="user_name" name="user_name" class="input_width" ></input>
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

