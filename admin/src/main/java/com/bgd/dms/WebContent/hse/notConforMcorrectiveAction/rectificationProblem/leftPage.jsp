<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());
 
 
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title> </title>
</head>
<body style="background:#fff"  onload="refreshData();">
	<div id="list_table"  > 
	<div id="table_box"   >
	  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>  
	    <td class="bt_info_even" exp="<input type='checkbox' name='pk_id' id='chx_entity_id_{questions_no}' value='{questions_no}'  />" >
	      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
	      <td class="bt_info_odd" autoOrder="1">序号</td> 
	      <td class="bt_info_even" exp="{org_name}">单位</td> 
	      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
	      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
	      <td class="bt_info_odd" exp="{check_date}">检查日期</td> 
	      <td class="bt_info_even" exp="{rectification_period}">整改期限</td> 
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
	    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" />
       </td>
	  </tr>
	</table>
	</div>
	<div class="lashen" id="line" style="display:none" ></div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
	<tr> 
	  <td background="<%=contextPath%>/images/list_15.png" >
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr align="right"> 
		  <td  >
		  <span  class="tj_btn"><a href="#" onclick="add(); "></a></span>  
		  </td>
		</tr>
		</table>
	</td> 
	</tr>
	</table>	 
</div> 
</body>
<script type="text/javascript">
function frameSize(){
 	if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.81);
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
   
}
frameSize(); 
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
var checked = false;
function check(){
	var chk = document.getElementsByName("pk_id");
	for(var i = 0; i < chk.length; i++){ 
		if(!checked){ 
			chk[i].checked = true; 
		}
		else{
			chk[i].checked = false;
		}
	} 
	if(checked){
		checked = false;
	}
	else{
		checked = true;
	}
}
</script>

<script type="text/javascript"> 
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function refreshData(arrObj){  
		cruConfig.cdtType = 'form';
		var querySql = "  select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'     where tr.bsflag = '0'   ";
		 for(var key in arrObj) { 
				//alert(arrObj[key].label+arrObj[key].value);
				if(arrObj[key].value!=undefined && arrObj[key].value!='')
					if(arrObj[key].label =="check_date"){
						querySql += " and to_char(tr."+arrObj[key].label+",'yyyy-MM-dd')='"+arrObj[key].value+"' ";
					} else {
						querySql += " and tr."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";		
					} 
			   }
 
		 cruConfig.queryStr=querySql;
		queryData(1);
	}
	
	
	   function add(){ 
		   var certificate = document.getElementsByName("pk_id");
			var certificate_no = "";
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ",";
		
				}
			} 
       self.parent.frames["rightframe"].location="<%=contextPath %>/hse/notConforMcorrectiveAction/rectificationProblem/rightPage.jsp?questions_no="+certificate_no;

		}

</script> 
</html>