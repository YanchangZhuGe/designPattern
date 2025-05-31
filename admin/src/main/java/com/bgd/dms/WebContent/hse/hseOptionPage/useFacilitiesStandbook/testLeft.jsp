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
	String usefacilities_no=request.getParameter("usefacilities_no");
	String addTypes=request.getParameter("addTypes");
	String userOrgId = user.getSubOrgIDofAffordOrg();
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
<title>设备设施使用管理有效性  </title>
</head> 
<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table"  > 
			<div id="table_box"   >
			  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>  
			    <td class="bt_info_even" exp="<input type='checkbox' name='pk_id' id='chx_entity_id_{pk_id}' value='{pk_id}'  />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{facilities_name}">设备设施名称</td>
			      <td class="bt_info_odd" exp="{specifications}">规格型号</td> 
			      <td class="bt_info_even" exp="{release_date}">出厂日期</td> 
			      <td class="bt_info_odd" exp="{equipment_one}">设备设施类别一</td>
			      <td class="bt_info_even" exp="{equipment_two}">设备设施类别二</td> 
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
			$("#table_box").css("height",$(window).height()*0.79);
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
	var usefacilities_no='<%=usefacilities_no%>';
	var addTypes='<%=addTypes%>';
	var userOrgId='<%=userOrgId%>';
	cruConfig.cdtType = 'form';
	
	function refreshData(arrObj){
		
		cruConfig.cdtType = 'form';
		var  querySqlAdd =""; //getMultipleSql2("tr.");
		
		var querySql =  "  select *  from ( select t.dev_acc_id as pk_id,     t.owning_org_id as org_sub_id,  '' second_org,  '' third_org,    t.bsflag,  t.using_stat as use_situation,     t.tech_stat as technical_conditions,  et.equipment_one as e_one,   et.equipment_two as e_two, (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name ,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao,(select coding_name  from comm_coding_sort_detail c  where et.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where et.equipment_two = c.coding_code_id) as equipment_two ,'1'spare1,et.eq_id  from GMS_DEVICE_ACCOUNT t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id  where t.bsflag = '0'  and t.dev_type like 'S08%' and substr(t.dev_type,2,4)!='0809' and substr(t.dev_type,2,4)!='0808'    and (t.owning_sub_id like '<%=userOrgId%>%' OR   t.USAGE_SUB_ID like '<%=userOrgId%>%')  and  t.dev_acc_id not in (  select dil.facilities_no  from BGP_USEFACILITIES_DETAIL dil left join  BGP_USEFACILITIES_STAND  ion on ion.usefacilities_no=dil.usefacilities_no and dil.bsflag='0' where ion.bsflag='0' )  "
			+" union "+
			"  select  tr.facilities_no as pk_id,         tr.org_sub_id,tr.second_org,tr.third_org,  tr.bsflag,     tr.use_situation,     tr.technical_conditions,    tr.equipment_one as e_one,    tr.equipment_two as e_two,    oi1.org_abbreviation as second_org_name, ion.org_abbreviation as org_name, tr.facilities_name,tr.specifications,  (select coding_name  from comm_coding_sort_detail c  where tr.use_situation = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where tr.technical_conditions = c.coding_code_id) as tech_stat_desc,   tr.release_date,tr.paizhaohao,(select coding_name  from comm_coding_sort_detail c  where tr.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where tr.equipment_two = c.coding_code_id) as equipment_two ,tr.spare1 ,tr.creator as eq_id  from BGP_FACILITIES_STANDBOOK tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'  "+querySqlAdd+"   and  tr.facilities_no not in (  select dil.facilities_no  from BGP_USEFACILITIES_DETAIL dil left join  BGP_USEFACILITIES_STAND  ion on ion.usefacilities_no=dil.usefacilities_no and dil.bsflag='0' where ion.bsflag='0' )  order by spare1 desc  ) tr where tr.bsflag = '0'  ";
 
		 for(var key in arrObj) { 
				//alert(arrObj[key].label+arrObj[key].value);
				if(arrObj[key].value!=undefined && arrObj[key].value!='')
					if(arrObj[key].label =="release_date"){
						querySql += "and to_char(tr."+arrObj[key].label+",'yyyy-MM-dd')='"+arrObj[key].value+"' ";
					} else {
						querySql += "and tr."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";		
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
        self.parent.frames["rightframe"].location="<%=contextPath %>/hse/hseOptionPage/useFacilitiesStandbook/rightPage.jsp?addTypes=<%=addTypes%>&pk_id="+certificate_no+"&usefacilities_no="+usefacilities_no;

		}

</script>

</html>

