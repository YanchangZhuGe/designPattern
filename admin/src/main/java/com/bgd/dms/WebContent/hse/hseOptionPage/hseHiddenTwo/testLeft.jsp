<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
 
<title>隐患信息  </title>
</head> 
<body style="background:#cdddef"  onload="refreshData();">
      	<div id="list_table"  > 
			<div id="table_box"   >
			  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>  
			    <td class="bt_info_even" exp="<input type='checkbox' name='pk_id' id='chx_entity_id_{hidden_no}' value='{hidden_no}'  />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{hidden_name}">隐患描述</td> 
			      <td class="bt_info_even" exp="{report_date}">上报日期</td> 
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
					<input type="hidden" id="paramS" name="paramS"  value=""   />
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
		var paramS=document.getElementsByName("paramS")[0].value;
		  if(paramS !=null && paramS!=''){
		  var querySql= "  select case when length(tr.hidden_description)<= 25 then tr.hidden_description else concat(substr(tr.hidden_description,0,25),'...') end  hse_hidden_description, hdl.reward_state, decode(hdl.risk_levels,'1','低风险','2','中风险','3','高风险') risk_levels,decode(hdl.rectification_state,'1','已整改','2','未整改','3','正在整改')rectification_state,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date, tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr    left join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'      left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left join comm_org_information ion    on ion.org_id = ose.org_id   left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no=tr.hidden_no and hdl.bsflag='0'  where tr.bsflag = '0'  ";
				if(paramS=="1,"){
					querySql+=" and hdl.risk_levels is null ";
				}
				if(paramS=="2,"){
					querySql+=" and hdl.rectification_state is null  ";
					}
				if(paramS=="3,"){
					querySql+=" and hdl.reward_state is null  ";
					}
				if(paramS=="1,2,3,"){
					querySql+=" and hdl.reward_state is null  and  hdl.reward_state  is null   and hdl.risk_levels is null  ";
					}
				if(paramS=="1,2,"){
					querySql+=" and  hdl.risk_levels is null  and hdl.rectification_state is null    ";
					}
				if(paramS=="1,3,"){
					querySql+=" and  hdl.risk_levels is null  and hdl.reward_state is null  ";
					}
				if(paramS=="2,3,"){
					querySql+=" and hdl.rectification_state is null   and hdl.reward_state is null  ";
					}
 
		   for(var key in arrObj) { 
				//alert(arrObj[key].label+arrObj[key].value);
				if(arrObj[key].value!=undefined && arrObj[key].value!='')
					if(arrObj[key].label =="report_date"){
						querySql += "and to_char(tr."+arrObj[key].label+",'yyyy-MM-dd')='"+arrObj[key].value+"' ";
					} else {
						querySql += "and tr."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";		
					} 
			   }
		  
		 querySql = querySql+" order by tr.modifi_date desc";		  
		 cruConfig.queryStr=querySql;
		  queryData(1);
		  }
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
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
		//	self.parent.frames["rightframe"].add();
			var paramS=document.getElementsByName("paramS")[0].value;
			if(paramS ==""){
				alert('请先选择录入类别！');return;
			}
         self.parent.frames["rightframe"].location="<%=contextPath %>/hse/hseOptionPage/hseHiddenTwo/rightPage.jsp?pk_id="+certificate_no+"&paramS="+paramS;

		}

</script>

</html>

