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
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');		
		var unit_subflag = document.getElementById("unit_subflag").value; 
		var employee_name = document.getElementById("employee_name").value;   
		var month_no = document.getElementById("month_no").value; 
 
		var sql = "";  
		var sql = " select *　from (select   row_number() over(partition by tr.month_no order by tr.month_no ,spare1 ) num , i.org_abbreviation as org_name ,tr.spare2, u.employee_name,tr.recore_id,tr.org_sub_id,tr.spare1,tr.month_no,tr.month_start_date,tr.month_end_date,decode(tr.unit_subflag, '0', '未提交', '1', '已提交','2','审批通过','5','审批不通过') unit_subflag ,tr.unit_subflag as subflag  from   BGP_HSE_MONTH_RECORD tr  left join comm_org_subjection s    on tr.org_sub_id = s.org_subjection_id   and s.bsflag = '0'  left join comm_org_information i    on s.org_id = i.org_id   and i.bsflag = '0'     left    join  comm_human_employee u   on tr.creator = u.EMPLOYEE_ID   and u.bsflag = '0'   where tr.bsflag='0' and tr.subflag='3' ) tr  where tr.num = 1    "+sql;
 
		if(unit_subflag!=''&&unit_subflag!=null){
			sql = sql+" and tr.unit_subflag = '"+unit_subflag+"'";
		}
		if(employee_name!=''&&employee_name!=null){
			sql = sql+" and tr.spare2 like '%"+employee_name+"%'";
		}
		if(month_no!=''&&month_no!=null){
			sql = sql+" and tr.month_no = '"+month_no+"'";
		}
 
     	top.frames('list').frames[1].refreshData2(sql);	
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
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
 
	function calMonthSelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    false,
			step	       :	1
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
	        <td class="inquire_item6">状态：</td>
	      	<td class="inquire_form6">
	      	<select id="unit_subflag" name="unit_subflag" class="select_width">
		       <option value="" >请选择</option>
		       <option value="已提交" >已提交</option>
		       <option value="未提交" >未提交</option>
			</select>
	      	</td>
	        <td class="inquire_item6">填写人：</td>					 
		    <td class="inquire_form6">
		    <input type="text" id="employee_name" name="employee_name" class="input_width"   />
		    </td>
		    <td class="ali_cdn_name">月份日期</td>
		    <td class="ali_cdn_input">
		    <input id="month_no" name="month_no" class="input_width"  style="width:120px" type="text" readonly="readonly"/>&nbsp;
		 	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="calMonthSelector(month_no,tributton0);"/>&nbsp;
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

