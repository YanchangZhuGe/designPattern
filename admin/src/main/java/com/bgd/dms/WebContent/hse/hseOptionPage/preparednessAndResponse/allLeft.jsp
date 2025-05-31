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
<script type="text/javascript" src="/gms3/hse/js/hseCommon.js"></script>

<title>物资信息  </title>
</head> 
<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table"  > 
			<div id="table_box"   >
			  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>  
			    <td class="bt_info_even" exp="<input type='checkbox' name='pk_id' id='chx_entity_id_{emergency_no}' value='{emergency_no}'  />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{supplies_categorys_s}">物资类别</td>
			      <td class="bt_info_odd" exp="{supplies_name}">物资名称</td> 
			      <td class="bt_info_even" exp="{acquisition_time}">购置时间</td> 
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
	var orgSubId="<%=orgSubId%>";
	function refreshData(arrObj){
		cruConfig.cdtType = 'form';
		var querySqlAdd = getMultipleSql2("tr.");
		
		var querySql = 
			    "  select * from (   select  tr.unit_measurement, ion.org_abbreviation as org_name,  tr.second_org,tr.org_sub_id,        oi1.org_abbreviation as second_org_name, tr.emergency_no,       tr.supplies_name, tr.supplies_category,  decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_categorys_s,acquisition_time, tr.bsflag   from BGP_EMERGENCY_STANDBOOK tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id  where tr.bsflag='0'   " +  querySqlAdd+ 
				" union " +
				" select    g.wz_prickie as unit_measurement,oi1.org_abbreviation as org_name,  w.org_subjection_id as second_org ,w.org_id as org_sub_id,  oi2.org_abbreviation as second_org_name,ein.information_no  as emergency_no,       g.wz_name as supplies_name,  ein.supplies_category,    decode(ein.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category_s,       ein.acquisition_time,        ein.bsflag  from gms_mat_infomation g  inner join gms_mat_teammat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.teammat_info_id  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0' where g.coding_code_id like '45%'   and w.is_recyclemat = '1'     and  w.ORG_SUBJECTION_ID like'%"+orgSubId+"%'     " +
				" union " +
				"  select        g.wz_prickie as unit_measurement,oi1.org_abbreviation as org_name,         w.org_subjection_id as second_org,         w.org_id as org_sub_id,         oi2.org_abbreviation as second_org_name,         w.teammat_info_id as emergency_no,         g.wz_name as supplies_name,         '' as supplies_category,         '' as supplies_category_s,         to_char('', 'yyyy-MM-dd') as acquisition_time,         '0' as bsflag    from gms_mat_infomation g   inner join gms_mat_teammat_info w      on g.wz_id = w.wz_id     and w.bsflag = '0'    left join comm_org_subjection os1      on w.org_id = os1.org_subjection_id     and os1.bsflag = '0'    left join comm_org_information oi1      on oi1.org_id = os1.org_id     and oi1.bsflag = '0'    left join BGP_EMERGENCY_INFORMATION ein      on ein.teammat_info_id = w.teammat_info_id    left join comm_org_subjection os2      on w.org_subjection_id = os2.org_subjection_id     and os2.bsflag = '0'    left join comm_org_information oi2      on oi2.org_id = os2.org_id     and oi2.bsflag = '0'   where g.coding_code_id like '45%'     and w.is_recyclemat = '1'       and  w.ORG_SUBJECTION_ID like'%"+orgSubId+"%'  and ein.information_no is null " +
				"  )  ok  where ok.bsflag='0'   ";
		
		for(var key in arrObj) { 
			//alert(arrObj[key].label+arrObj[key].value);
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
				if(arrObj[key].label =="acquisition_time"){
					querySql += " and to_char(ok."+arrObj[key].label+",'yyyy-MM-dd')='"+arrObj[key].value+"' ";
				}else if (arrObj[key].label =="supplies_category"){
					querySql += " and ok."+arrObj[key].label+" = '"+arrObj[key].value+"' ";					
				}else {
					querySql += " and ok."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";		
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
		//	self.parent.frames["rightframe"].add();
			var paramS=document.getElementsByName("paramS")[0].value;
			if(paramS ==""){
				alert('请先选择录入信息！');return;
			}
         self.parent.frames["rightframe"].location="<%=contextPath %>/hse/hseOptionPage/preparednessAndResponse/allRight.jsp?pk_id="+certificate_no+"&paramS="+paramS;

		}

	   function deleteTableTr(tableID){
	   	var tb = document.getElementById(tableID);
	        var rowNum=tb.rows.length;

	        for (i=1;i<rowNum;i++)
	        {
	            tb.deleteRow(i);
	            rowNum=rowNum-1;
	            i=i-1;
	        }
	   }	
</script>

</html>

