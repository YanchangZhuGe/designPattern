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
String inspection_no=request.getParameter("inspection_no");
String isProject =request.getParameter("isProject"); 
String addTypes=request.getParameter("addTypes");
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
<script type="text/javascript" src="/gms3/hse/js/hseCommon.js"></script>
<title>应急物资台账添加</title>
</head>
<body  onload="refreshData();" > 
		<div id="list_table"  > 
		<div id="table_box"   >
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
		    <tr>  
		    <td class="bt_info_even" exp="<input type='checkbox' name='pk_id' id='chx_entity_id_{emergency_no}' value='{emergency_no}'  />" >
		      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
		      <td class="bt_info_odd" autoOrder="1">序号</td> 
		      <td class="bt_info_even" exp="{org_name}">单位</td> 
		      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
		      <td class="bt_info_even" exp="{supplies_category_ame}">物资类别</td>
		      <td class="bt_info_odd" exp="{supplies_name}">物资名称</td> 
		      <td class="bt_info_even" exp="{acquisition_time}">购置时间</td> 
		      <td class="bt_info_odd" exp="{acceptance_time}">验收时间</td> 
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
cruConfig.contextPath='<%=contextPath %>';
var inspection_no='<%=inspection_no%>';
var isProject='<%=isProject%>';
var addTypes='<%=addTypes%>';
cruConfig.cdtType = 'form';

function refreshData(arrObj){
	cruConfig.cdtType = 'form';
	var querySql="";
	if(isProject=="1"){
		var  querySqlAdd = "";
	//	var  querySqlAdd = getMultipleSql2("ions."); 
		 querySql =   	"  select * from ( select tr.information_no as emergency_no,  w.org_subjection_id as second_org ,decode(w.org_id,'',w.org_subjection_id) org_sub_id, tr.bsflag,    dil.mdetail_no,tr.supplies_category, decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category_ame,   ions.materials_no,       mn.wz_name as supplies_name,       tr.acquisition_time,       ions.acceptance_time,      decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION tr    on dil.emergency_no = tr.information_no   and tr.bsflag = '0'  left join gms_mat_recyclemat_info w    on tr.teammat_info_id = w.RECYCLEMAT_INFO   and w.bsflag = '0'  left join gms_mat_infomation mn    on w.wz_id = mn.wz_id   and mn.bsflag = '0'  left join comm_org_subjection os1    on w.org_subjection_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection ose    on w.org_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  where   ions.bsflag = '0'  "+querySqlAdd+"    and tr.information_no not in       (select dil.emergency_no          from BGP_INSPECTION_DETAIL dil          left join BGP_MATERIAL_INSPECTION ion            on ion.inspection_no = dil.inspection_no           and dil.bsflag = '0'         where ion.bsflag = '0') " +
			" union " +
	   		" select tr.emergency_no,  tr.second_org,tr.org_sub_id,    tr.bsflag ,   dil.mdetail_no, tr.supplies_category,     decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category_ame,      ions.materials_no,     tr.supplies_name,       tr.acquisition_time,       ions.acceptance_time,       decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  join BGP_EMERGENCY_STANDBOOK tr    on dil.emergency_no = tr.emergency_no   and tr.bsflag = '0'  join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id where     ions.bsflag = '0'    "+querySqlAdd+"     and tr.emergency_no not in       (select dil.emergency_no          from BGP_INSPECTION_DETAIL dil          left join BGP_MATERIAL_INSPECTION ion            on ion.inspection_no = dil.inspection_no           and dil.bsflag = '0'         where ion.bsflag = '0')    )  ok  where ok.bsflag='0' " ;
	}else if(isProject=="2"){
	  querySql =   	"  select * from ( select tr.information_no as emergency_no,  w.org_subjection_id as second_org ,decode(w.org_id,'',w.org_subjection_id) org_sub_id, tr.bsflag,    dil.mdetail_no,tr.supplies_category, decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category_ame,   ions.materials_no,       mn.wz_name as supplies_name,       tr.acquisition_time,       ions.acceptance_time,      decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION tr    on dil.emergency_no = tr.information_no   and tr.bsflag = '0'  left join gms_mat_teammat_info w    on tr.teammat_info_id = w.teammat_info_id   and w.bsflag = '0'  left join gms_mat_infomation mn    on w.wz_id = mn.wz_id   and mn.bsflag = '0'  left join comm_org_subjection os1    on w.org_subjection_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection ose    on w.org_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  where   ions.bsflag = '0'  and ions.project_no='<%=user.getProjectInfoNo()%>'   and tr.information_no not in       (select dil.emergency_no          from BGP_INSPECTION_DETAIL dil          left join BGP_MATERIAL_INSPECTION ion            on ion.inspection_no = dil.inspection_no           and dil.bsflag = '0'         where ion.bsflag = '0' ) " +
		" union " +
   		" select tr.emergency_no,  tr.second_org,tr.org_sub_id,    tr.bsflag ,   dil.mdetail_no, tr.supplies_category,     decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category_ame,      ions.materials_no,     tr.supplies_name,       tr.acquisition_time,       ions.acceptance_time,       decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'   join BGP_EMERGENCY_STANDBOOK tr    on dil.emergency_no = tr.emergency_no   and tr.bsflag = '0'  join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id where     ions.bsflag = '0'    and ions.project_no='<%=user.getProjectInfoNo()%>'   and tr.emergency_no not in       (select dil.emergency_no          from BGP_INSPECTION_DETAIL dil          left join BGP_MATERIAL_INSPECTION ion            on ion.inspection_no = dil.inspection_no           and dil.bsflag = '0'         where ion.bsflag = '0')    )  ok  where ok.bsflag='0' " ;
	}
	for(var key in arrObj) { 
		//alert(arrObj[key].label+arrObj[key].value);
		if(arrObj[key].value!=undefined && arrObj[key].value!='')
			if(arrObj[key].label =="acquisition_time"){
				querySql += "and to_char(ok."+arrObj[key].label+",'yyyy-MM-dd')='"+arrObj[key].value+"' ";
			}else if (arrObj[key].label =="supplies_category"){
				querySql += "and ok."+arrObj[key].label+"= '"+arrObj[key].value+"' ";					
			}else {
				querySql += "and ok."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";		
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
        self.parent.frames["rightframe"].location="<%=contextPath %>/hse/hseOptionPage/preparednessAndResponse/IrightPage.jsp?addTypes=<%=addTypes%>&emergency_no="+certificate_no+"&isProject=<%=isProject%>&inspection_no="+inspection_no;

		}

	   function sucess(){

			var deviceCount = document.getElementById("lineNum").value;
			alert(deviceCount);
			var isCheck=true;
			for(var i=0;i<deviceCount;i++){
				if(document.getElementById("questions_no_"+i).checked == true){
					isCheck=false;
				}
			}
			if(isCheck){
				alert("请选择一条记录");
				return false;
			}else{
		 
				newClose();
				return true;
			}
			
		 
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
 
</body>
</html>