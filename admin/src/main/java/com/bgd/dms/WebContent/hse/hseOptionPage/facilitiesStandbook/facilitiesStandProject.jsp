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
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
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
 
<title>设备设施台账</title>
</head>

<body style="background:#fff"  onload="refreshData();pageInit();getEquipmentOne();getEquipmentOne1();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备设施名称</td>
			    <td class="inquire_form6"><input id="changeName" name="changeName" type="text" />			   
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>   
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{pk_id}' value='{pk_id},{spare1},{eq_id}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{facilities_name}">设备设施名称</td>
			      <td class="bt_info_odd" exp="{specifications}">规格型号</td>
			      <td class="bt_info_even" exp="{tech_stat_desc}">技术状况</td>
			      <td class="bt_info_odd" exp="{using_stat_desc}">使用状况</td>
			      <td class="bt_info_even" exp="{release_date}">出厂日期</td>
			      <td class="bt_info_odd" exp="{paizhaohao}">牌照号</td>
			      <td class="bt_info_even" exp="{equipment_one}">设备设施类别一</td>
			      <td class="bt_info_odd" exp="{equipment_two}">设备设施类别二</td>

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
			<div class="lashen" id="line"></div>
			
			<div id="type2" style="display:block;">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">   			  
			    <li class="selectTag" id="tag3"><a href="#" >基本信息</a></li>
			   </ul>
			</div> 
			<div id="tab_boxs" class="tab_box">
			<form name="form" id="form1"  method="post" action=""> 
				<div id="tab_box_content" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate1()"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
		              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
						  <tr>						   
							  <td class="inquire_item6">单位：</td>
					        	<td class="inquire_form6">
					        	<input type="hidden" id="dev_acc_id" name="dev_acc_id" value="" />
						       	<input type="hidden" id="eq_id" name="eq_id" value="" /> 
						    	<input type="hidden" id="cc" name="cc" value="" />
						       	<input type="hidden" id="dd" name="dd" value="" />  
					        	<input type="text" id="org_sub_ids" name="org_sub_ids" class="input_width"  readonly="readonly" style="color:gray" />	 
					        	</td>
					          	<td class="inquire_item6">基层单位：</td>
					        	<td class="inquire_form6">
					        	 <input type="text" id="second_orgs" name="second_orgs" class="input_width"   readonly="readonly" style="color:gray" /> 
					        	</td>    	  
						  </tr>					  
						  <tr>	 
							    <td class="inquire_item6">设备设施名称：</td>
							    <td class="inquire_form6">
							    <input type="text" id="shebeiname" name="shebeiname" class="input_width"   readonly="readonly" style="color:gray"  />   
							    </td>
							    <td class="inquire_item6">牌照号：</td>
							    <td class="inquire_form6"> 
							    <input type="text" id="paihao" name="paihao" class="input_width"   readonly="readonly" style="color:gray" />    		
							    </td>
							</tr>						
						  <tr>	
						    <td class="inquire_item6">规格型号：</td>
						    <td class="inquire_form6">
						    <input type="text" id="guigexing" name="guigexing" class="input_width"    readonly="readonly" style="color:gray" /></td>					 
						    <td class="inquire_item6">使用状况：</td> 					   
						    <td class="inquire_form6"  align="center" >  
							<input type="text" id="shiyong" name="shiyong" class="input_width"   readonly="readonly" style="color:gray"  />
						    </td>  
						   </tr>	
						   <tr> 
							    <td class="inquire_item6">技术状况：</td>
							    <td class="inquire_form6">   
								<input type="text" id="jishu" name="jishu" class="input_width"   readonly="readonly" style="color:gray"  />
							    </td>
							    <td class="inquire_item6">出厂日期：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="riqi" name="riqi" class="input_width"    readonly="readonly" style="color:gray" /> 
							    </td>
							  </tr>	
						   <tr> 
							   
							    <td class="inquire_item6"><font color="red">*</font>设备设施类别一：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <select id="equipment_ones" name="equipment_ones" class="select_width" onchange="getEquipmentTwo1()" ></select> 	
							    </td> 
							    <td class="inquire_item6"><font color="red">*</font>设备设施类别二：</td>
							    <td class="inquire_form6"> 
							    <select id="equipment_twos" name="equipment_twos" class="select_width" >
								</select> 			
							    </td>
						  </tr>	 
					     </table>
			    	</div> 
				</form> 
			</div>
		  </div>
 		 
		    <div id="type1" style="display:none;">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">   			  
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
		              <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
						  <tr>						   
							  <td class="inquire_item6">单位：</td>
					        	<td class="inquire_form6">
					        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
						      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
					        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					        	<%} %>
					        	</td>
					          	<td class="inquire_item6">基层单位：</td>
					        	<td class="inquire_form6">
					        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
						    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
					        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					        	<%} %>
					        	</td>    	  
						  </tr>					  
						  <tr>								 
							  <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
						      	<td class="inquire_form6">
						    	<input type="hidden" id="aa" name="aa" value="" />
						       	<input type="hidden" id="bb" name="bb" value="" />
					 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
						    	<input type="hidden" id="project_no" name="project_no" value="" />
						      	<input type="hidden" id="create_date" name="create_date" value="" />
						      	<input type="hidden" id="creator" name="creator" value="" />
						      	<input type="hidden" id="facilities_no" name="facilities_no"   />
						     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
						      	<input type="hidden" id="third_org2" name="third_org2" class="input_width"  /> 
						  
							    <input type="text" id="facilities_name" name="facilities_name" class="input_width"   />    	
							    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTreePage()"  />
							    </td>	
							    
							    <td class="inquire_item6">牌照号：</td>
							    <td class="inquire_form6"> 
							    <input type="text" id="paizhaohao" name="paizhaohao" class="input_width"   />    		
							    </td>
							    
							</tr>						
						  <tr>	
						    <td class="inquire_item6">规格型号：</td>
						    <td class="inquire_form6"><input type="text" id="specifications" name="specifications" class="input_width"    /></td>					 
						    <td class="inquire_item6">使用状况：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="use_situation" name="use_situation" class="select_width" onchange="selectUse()"> 
							</select> 	
						    </td>  
						   </tr>	
						   <tr> 
							    <td class="inquire_item6">技术状况：</td>
							    <td class="inquire_form6">  
							    <select id="technical_conditions" name="technical_conditions" class="select_width">
								</select> 		
							    </td>
							    <td class="inquire_item6">出厂日期：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="release_date" name="release_date" class="input_width"    readonly="readonly"/>
							    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(release_date,tributton1);" />&nbsp;</td>
							  </tr>	
						   <tr> 
							
							    <td class="inquire_item6"><font color="red">*</font>设备设施类别一：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <select id="equipment_one" name="equipment_one" class="select_width" onchange="getEquipmentTwo()"></select> 	
							    </td>
							 </tr>	
							 <tr> 
							    <td class="inquire_item6"><font color="red">*</font>设备设施类别二：</td>
							    <td class="inquire_form6"> 
							    <select id="equipment_two" name="equipment_two" class="select_width">
								</select> 			
							    </td>
							  </tr>	 
					     </table>
			    	</div> 
				</form> 
			</div>
		  </div>
 </div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript"> 
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var userOrgId='<%=userOrgId%>';
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		var sqlSelect="";
		if(userOrgId=='C105'){
			sqlSelect="  (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name  ";
		}else{
			
			sqlSelect=" (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name , ( select  cit.org_abbreviation   from comm_org_subjection c  left join comm_org_information cit  on c.org_id=cit.org_id and cit.bsflag='0'  where c.org_subjection_id='<%=userOrgId%>' and c.bsflag='0' ) as org_name ";
		}
		
		cruConfig.queryStr = "  select t.dev_acc_id as pk_id,"+sqlSelect+" ,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao,(select coding_name  from comm_coding_sort_detail c  where et.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where et.equipment_two = c.coding_code_id) as equipment_two ,'1'spare1,et.eq_id  from GMS_DEVICE_ACCOUNT_DUI t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id       where t.bsflag = '0'  and t.dev_type like 'S08%' and substr(t.dev_type,2,4)!='0809' and substr(t.dev_type,2,4)!='0808'       and t.project_info_id = '<%=projectInfoNo%>' "
			+" union "+
			"  select  tr.facilities_no as pk_id, oi1.org_abbreviation as second_org_name,ion.org_abbreviation as org_name, tr.facilities_name,tr.specifications,  (select coding_name  from comm_coding_sort_detail c  where tr.use_situation = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where tr.technical_conditions = c.coding_code_id) as tech_stat_desc,   tr.release_date,tr.paizhaohao,(select coding_name  from comm_coding_sort_detail c  where tr.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where tr.equipment_two = c.coding_code_id) as equipment_two ,tr.spare1 ,tr.creator as eq_id  from BGP_FACILITIES_STANDBOOK tr   left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'    left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0'       and tr.project_no = '<%=projectInfoNo%>'  order by spare1 desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/facilitiesStandbook/facilitiesStandProject.jsp";
		queryData(1);
		
		
		  var querySql1="";
	         var queryRet1=null;
	         var datas1 =null;
	         querySql1 = " select t.dev_acc_id,t.owning_org_name as org_name, (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name ,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao,(select coding_name  from comm_coding_sort_detail c  where et.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where et.equipment_two = c.coding_code_id) as equipment_two ,'1'spare1,et.eq_id  from GMS_DEVICE_ACCOUNT_DUI t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id       where t.bsflag = '0'       and et.eq_id is null  and t.dev_type like 'S08%' and substr(t.dev_type,2,4)!='0809' and substr(t.dev_type,2,4)!='0808' " ;;
	         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=600&querySql='+encodeURI(encodeURI(querySql1)));
	        
		       	if(queryRet1.returnCode=='0'){
		       	  datas1 = queryRet1.datas;	 
		       		if(datas1 != null && datas1 != ''){	  
		    			var appearances="";
	    				var identifications="";
	    				var m_performances=""; 
	    
	    				for(var i = 0; i<datas1.length; i++){	 
		       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
		       				var submitStr = 'JCDP_TABLE_NAME=GMS_DEVICE_ACCOUNT_EQUIPMENT&JCDP_TABLE_ID=&dev_acc_id='+datas1[i].dev_acc_id +'&equipment_one=5110000039000000003';
		       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
 
		       			}
		
		       		}
		       		
		       	}
		 
	}
 
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/facilitiesStandbook/facilitiesStandProject.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var changeName = document.getElementById("changeName").value;
				if(changeName!=''&& changeName!=null){
					cruConfig.cdtType = 'form';
					var sqlSelect="";
					if(userOrgId=='C105'){
						sqlSelect="   (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name    ";
					}else{
						
						sqlSelect=" (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name , ( select  cit.org_abbreviation   from comm_org_subjection c  left join comm_org_information cit  on c.org_id=cit.org_id and cit.bsflag='0'  where c.org_subjection_id='<%=userOrgId%>' and c.bsflag='0' ) as org_name ";
					}
					
					
					cruConfig.queryStr = "  select t.dev_acc_id as pk_id,"+sqlSelect+" ,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao,(select coding_name  from comm_coding_sort_detail c  where et.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where et.equipment_two = c.coding_code_id) as equipment_two ,'1'spare1,et.eq_id  from GMS_DEVICE_ACCOUNT_DUI t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id  where t.bsflag = '0'  and t.dev_type like 'S08%' and substr(t.dev_type,2,4)!='0809' and substr(t.dev_type,2,4)!='0808'  and t.project_info_id = '<%=projectInfoNo%>'   and t.dev_name like'"+changeName+"%' "
						+" union "+
						"  select  tr.facilities_no as pk_id,  oi1.org_abbreviation as second_org_name,ion.org_abbreviation org_name,tr.facilities_name,tr.specifications,  (select coding_name  from comm_coding_sort_detail c  where tr.use_situation = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where tr.technical_conditions = c.coding_code_id) as tech_stat_desc,   tr.release_date,tr.paizhaohao,(select coding_name  from comm_coding_sort_detail c  where tr.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where tr.equipment_two = c.coding_code_id) as equipment_two ,tr.spare1 ,tr.creator as eq_id  from BGP_FACILITIES_STANDBOOK tr    left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'    left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'   and tr.project_no = '<%=projectInfoNo%>'  and tr.facilities_name  like  '"+changeName+"%'";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/facilitiesStandbook/facilitiesStandbook.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
	function getEquipmentOne(){
		var selectObj = document.getElementById("equipment_one"); 
		document.getElementById("equipment_one").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryEquipmentOne=jcdpCallService("HseOperationSrv","queryeQuipmentOne","");	
	 
		for(var i=0;i<queryEquipmentOne.detailInfo.length;i++){
			var templateMap = queryEquipmentOne.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("equipment_two");
		document.getElementById("equipment_two").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	function getEquipmentTwo(){
	    var EquipmentOne = "equipmentOne="+document.getElementById("equipment_one").value;   
		var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);	

		var selectObj = document.getElementById("equipment_two");
		document.getElementById("equipment_two").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(EquipmentTwo.detailInfo!=null){
			for(var i=0;i<EquipmentTwo.detailInfo.length;i++){
				var templateMap = EquipmentTwo.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}
	function getEquipmentOne1(){
		var selectObj = document.getElementById("equipment_ones"); 
		document.getElementById("equipment_ones").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryEquipmentOne=jcdpCallService("HseOperationSrv","queryeQuipmentOne","");	
	 
		for(var i=0;i<queryEquipmentOne.detailInfo.length;i++){
			var templateMap = queryEquipmentOne.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("equipment_twos");
		document.getElementById("equipment_twos").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	function getEquipmentTwo1(){
	    var EquipmentOne = "equipmentOne="+document.getElementById("equipment_ones").value;   
		var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);	

		var selectObj = document.getElementById("equipment_twos");
		document.getElementById("equipment_twos").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(EquipmentTwo.detailInfo!=null){
			for(var i=0;i<EquipmentTwo.detailInfo.length;i++){
				var templateMap = EquipmentTwo.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}

	 function pageInit(){ 
			//通过查询结果动态填充使用情况select;
			var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000007' and bsflag='0'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			usingdatas = queryRet.datas; 
			if(usingdatas != null){
				for (var i = 0; i< queryRet.datas.length; i++) {
					document.getElementById("use_situation").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
				}
			}
			//技术状况默认完好
			document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
		}
	 
	   /**
		 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
		 */
		function selectUse(){
			document.getElementById("technical_conditions").options.length=0;
			if(document.getElementById("use_situation").value=='0110000007000000001' || document.getElementById("use_situation").value=='0110000007000000002')
			{
				document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
			}
			else{
				document.getElementById("technical_conditions").options.add(new Option("待报废","0110000006000000005"));
				document.getElementById("technical_conditions").options.add(new Option("待修","0110000006000000006"));
				document.getElementById("technical_conditions").options.add(new Option("在修","0110000006000000007"));
				document.getElementById("technical_conditions").options.add(new Option("验收","0110000006000000013"));
			}
		}
		
		/**
		 * 选择设备树
		**/
		function showDevTreePage1(){
			//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
			var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp","test","");
			var strs= new Array(); //定义一数组
			strs=returnValue.split("~"); //字符分割
			var names = strs[0].split(":");
			var name = names[1].split("(")[0];
			var model = names[1].split("(")[1].split(")")[0];
			//alert(returnValue);
			document.getElementById("facilities_name").value = name;
			document.getElementById("specifications").value = model; 
		}
	 	/**
		 * 选择设备树
		**/
		function showDevTreePage(){
			//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
			var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTreeForSubNode.jsp","test","");
			var strs= new Array(); //定义一数组
			strs=returnValue.split("~"); //字符分割
			var names = strs[0].split(":");
			var name = names[1].split("(")[0];
			var model = names[1].split("(")[1].split(")")[0];
			//alert(returnValue);
			document.getElementById("facilities_name").value = name;
			document.getElementById("specifications").value = model; 
		}
		
	 function loadDataDetail(ids){
		    var tempa = ids.split(',');		
	 	    ids =  tempa[0];
	 	    var ifType=tempa[1];
	  
	 	   if(ifType == '1'){
		 		 document.getElementById("type2").style.display="block";
		 		document.getElementById("type1").style.display="none";
				var querySql = "";
				var queryRet = null;
				var  datas =null;	 
				
				var sqlSelect="";
				if(userOrgId=='C105'){
					sqlSelect="   (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name   ";
				}else{
					
					sqlSelect=" (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name , ( select  cit.org_abbreviation   from comm_org_subjection c  left join comm_org_information cit  on c.org_id=cit.org_id and cit.bsflag='0'  where c.org_subjection_id='<%=userOrgId%>' and c.bsflag='0' ) as org_name ";
				}
				
				
				querySql = "   select t.dev_acc_id,  et.equipment_one,  et.equipment_two, et.eq_id,"+sqlSelect+",t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao  from GMS_DEVICE_ACCOUNT_DUI t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id  where t.bsflag = '0'   and t.dev_acc_id='"+ ids +"'";				 	 
				queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				if(queryRet.returnCode=='0'){
					datas = queryRet.datas;
					if(datas != null){	  
						 document.getElementsByName("dev_acc_id")[0].value=datas[0].dev_acc_id; 
			    		 document.getElementsByName("eq_id")[0].value=datas[0].eq_id;
			    		 document.getElementsByName("org_sub_ids")[0].value=datas[0].org_name;  
			    		 document.getElementsByName("second_orgs")[0].value=datas[0].second_org_name;	 
		    		     document.getElementsByName("equipment_ones")[0].value=datas[0].equipment_one;		
		    		     document.getElementsByName("cc")[0].value=datas[0].equipment_one;	    		    
		    			 document.getElementsByName("equipment_twos")[0].value=datas[0].equipment_two;	
		    			 document.getElementsByName("dd")[0].value=datas[0].equipment_two;	 
		    			 document.getElementsByName("shebeiname")[0].value=datas[0].facilities_name;
		    			 document.getElementsByName("guigexing")[0].value=datas[0].specifications;		
		    		 	 document.getElementsByName("jishu")[0].value=datas[0].tech_stat_desc;	 
		    			 document.getElementsByName("shiyong")[0].value=datas[0].using_stat_desc;	 
		    			 document.getElementsByName("riqi")[0].value=datas[0].release_date;
		    			 document.getElementsByName("paihao")[0].value=datas[0].paizhaohao;		
			    		      
					  }					
				
			    	}
 
				exitSelect1();
				
			}
			   
	 	if(ifType == '2'){
	 		 document.getElementById("type1").style.display="block";
	 		 document.getElementById("type2").style.display="none";
			var querySql = "";
			var queryRet = null;
			var  datas =null;	 
			querySql = "   select   tr.project_no,tr.org_sub_id,tr.facilities_no,tr.facilities_name,tr.specifications,tr.technical_conditions,tr.use_situation,tr.release_date,tr.paizhaohao,tr.equipment_one,tr.equipment_two ,tr.second_org,tr.third_org,ion.org_abbreviation  org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_FACILITIES_STANDBOOK tr    left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'    left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id       where tr.bsflag = '0' and tr.facilities_no='"+ ids +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("facilities_no")[0].value=datas[0].facilities_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
		    	 	
		    		     document.getElementsByName("equipment_one")[0].value=datas[0].equipment_one;		
		    		     document.getElementsByName("aa")[0].value=datas[0].equipment_one;	    		    
		    			 document.getElementsByName("equipment_two")[0].value=datas[0].equipment_two;	
		    			 document.getElementsByName("bb")[0].value=datas[0].equipment_two;	 
		    			 document.getElementsByName("facilities_name")[0].value=datas[0].facilities_name;
		    			 document.getElementsByName("specifications")[0].value=datas[0].specifications;		
		    		 	 document.getElementsByName("technical_conditions")[0].value=datas[0].technical_conditions;	 
		    			 document.getElementsByName("use_situation")[0].value=datas[0].use_situation;	 
		    			 document.getElementsByName("release_date")[0].value=datas[0].release_date;
		    			 document.getElementsByName("paizhaohao")[0].value=datas[0].paizhaohao;		
		    			  document.getElementsByName("project_no")[0].value=datas[0].project_no;		  
		    			     
		    
				}					
			
		    	}
			selectUse();
			exitSelect();
			
		}
		
		 
	}
	
 
	   
	//處理選中的值selected
	 function exitSelect(){
		 
			var selectObj = document.getElementById("equipment_one");  
			var aa = document.getElementById("aa").value; 
			var bb = document.getElementById("bb").value;  
		    for(var i = 0; i<selectObj.length; i++){ 
		        if(selectObj.options[i].value == aa){ 
		        	selectObj.options[i].selected = 'selected';     
		        } 
		       }  
		    var EquipmentOne = "equipmentOne="+ document.getElementById("aa").value;
		    var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);		 
			var selectObj2 = document.getElementById("equipment_two");
			document.getElementById("equipment_two").innerHTML="";
			selectObj2.add(new Option('请选择',""),0);

			if(EquipmentTwo.detailInfo!=null){
				for(var t=0;t<EquipmentTwo.detailInfo.length;t++){
					var templateMap = EquipmentTwo.detailInfo[t];
					selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
				}
			}
		    for(var j = 0; j<selectObj2.length; j++){ 
		        if(selectObj2.options[j].value == bb){ 
		        	selectObj2.options[j].selected = 'selected';     
		        } 
		       }  
		     
	 }
	//處理選中的值selected
	 function exitSelect1(){ 
			var selectObj = document.getElementById("equipment_ones");  
			var aa = document.getElementById("cc").value; 
			var bb = document.getElementById("dd").value;  
			if(aa ==""){
				
			}else{
		    for(var i = 0; i<selectObj.length; i++){ 
		        if(selectObj.options[i].value == aa){ 
		        	selectObj.options[i].selected = 'selected';     
		        } 
		       }  
		    var EquipmentOne = "equipmentOne="+ document.getElementById("cc").value;
		    var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);		 
			var selectObj2 = document.getElementById("equipment_twos");
			document.getElementById("equipment_twos").innerHTML="";
			selectObj2.add(new Option('请选择',""),0);

			if(EquipmentTwo.detailInfo!=null){
				for(var t=0;t<EquipmentTwo.detailInfo.length;t++){
					var templateMap = EquipmentTwo.detailInfo[t];
					selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
				}
			}
		    for(var j = 0; j<selectObj2.length; j++){ 
		        if(selectObj2.options[j].value == bb){ 
		        	selectObj2.options[j].selected = 'selected';     
		        } 
		       }  
			}
	 }
	 
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
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
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/facilitiesStandbook/addFacilitiesStandbook.jsp?projectInfoNo=<%=projectInfoNo%>"); 
	}
 
	function selectTeam1(){ 
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById("project_id").value = teamInfo.fkValue;
	        document.getElementById("project_name").value = teamInfo.value;
	    }
	}
 
	function toEdit(){   
	  	ids = getSelIds('chx_entity_id'); 
   	    var tempa = ids.split(',');		
	    ids =  tempa[0];
	    var ifType=tempa[1];
	    var eq_id=tempa[2];
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	 
	    if(ifType == '1'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/facilitiesStandbook/addFacilitiesProject.jsp?eq_id="+eq_id+"&dev_acc_id="+ids); }
	    if(ifType == '2'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/facilitiesStandbook/addFacilitiesStandbook.jsp?projectInfoNo=<%=projectInfoNo%>&facilities_no="+ids); }
	  
	} 
	
	function dbclickRow(ids){
		  var tempa = ids.split(',');		
		    ids =  tempa[0];
		    var ifType=tempa[1];
		    var eq_id=tempa[2];
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    } 
		 
		    if(ifType == '1'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/facilitiesStandbook/addFacilitiesProject.jsp?eq_id="+eq_id+"&dev_acc_id="+ids); }
		    if(ifType == '2'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/facilitiesStandbook/addFacilitiesStandbook.jsp?projectInfoNo=<%=projectInfoNo%>&facilities_no="+ids); }
		  
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id'); 
   	    var tempa = ids.split(',');		
	    ids =  tempa[0];
	    var ifType=tempa[1];
	  
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    
	    if(ifType == '1'){alert('此信息不可删除！'); return;}
	    if(ifType == '2'){		deleteEntities("update BGP_FACILITIES_STANDBOOK e set e.bsflag='1' where e.facilities_no='"+ids+"'");}

	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/facilitiesStandbook/hse_searchP.jsp");
	}
 
	 
	//键盘上只有删除键，和左右键好用
	 function noEdit(event){
	 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
	 		return true;
	 	}else{
	 		return false;
	 	}
	 }
	 
	 
	 function selectOrg(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
		    if(teamInfo.fkValue!=""){
		    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
		        document.getElementById("org_sub_id2").value = teamInfo.value;
		    }
		}

		function selectOrg2(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var second = document.getElementById("org_sub_id").value;
			var org_id="";
				var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
			   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas==null||datas==""){
				}else{
					org_id = datas[0].org_id; 
			    }
				    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
				    if(teamInfo.fkValue!=""){
				    	 document.getElementById("second_org").value = teamInfo.fkValue; 
				        document.getElementById("second_org2").value = teamInfo.value;
					}
		   
		}

		function selectOrg3(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var third = document.getElementById("second_org").value;
			var org_id="";
				var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
			   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas==null||datas==""){
				}else{
					org_id = datas[0].org_id; 
			    }
				    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
				    if(teamInfo.fkValue!=""){
				    	 document.getElementById("third_org").value = teamInfo.fkValue;
				        document.getElementById("third_org2").value = teamInfo.value;
					}
		}

		function checkJudge(){
	 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
			var second_org = document.getElementsByName("second_org2")[0].value;			
			var third_org = document.getElementsByName("third_org2")[0].value;			
			
			var facilities_name = document.getElementsByName("facilities_name")[0].value;
			var equipment_one = document.getElementsByName("equipment_one")[0].value;		
			var equipment_two = document.getElementsByName("equipment_two")[0].value;
			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(facilities_name==""){
	 			alert("设备设施名称不能为空，请填写！");
	 			return true;
	 		}
	 		if(equipment_one==""){
	 			alert("设备设施类别一不能为空，请选择！");
	 			return true;
	 		}
	 		if(equipment_two==""){
	 			alert("设备设施类别二不能为空，请填写！");
	 			return true;
	 		}
	  
	 		
	 		return false;
	 	}
	 	
		
	function toUpdate(){ 
		var rowParams = new Array(); 
		var rowParam = {};			 
		var facilities_no = document.getElementsByName("facilities_no")[0].value;						 
		  if(facilities_no !=null && facilities_no !=''){		
				if(checkJudge()){
					return;
				}
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
				
				var facilities_name = document.getElementsByName("facilities_name")[0].value;
				var specifications = document.getElementsByName("specifications")[0].value;		
				var technical_conditions = document.getElementsByName("technical_conditions")[0].value;			
				var equipment_one = document.getElementsByName("equipment_one")[0].value;		
				var equipment_two = document.getElementsByName("equipment_two")[0].value;		
				var use_situation = document.getElementsByName("use_situation")[0].value;	 
				var release_date = document.getElementsByName("release_date")[0].value;
				var paizhaohao = document.getElementsByName("paizhaohao")[0].value;		
				var project_no = document.getElementsByName("project_no")[0].value;						 
				
				 if(project_no !=null && project_no !=''){
						rowParam['project_no'] =project_no;	
					}else{
						rowParam['project_no'] ='<%=projectInfoNo%>';
					}
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				
				rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
				rowParam['specifications'] = encodeURI(encodeURI(specifications));
				rowParam['technical_conditions'] = encodeURI(encodeURI(technical_conditions));
				rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));		 		
				rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two));
				rowParam['use_situation'] = encodeURI(encodeURI(use_situation)); 
				rowParam['release_date'] = encodeURI(encodeURI(release_date)); 
				rowParam['paizhaohao'] = encodeURI(encodeURI(paizhaohao));
		  
			    rowParam['facilities_no'] = facilities_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_FACILITIES_STANDBOOK",rows);	
			    refreshData();	
	   
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
 
	function checkJudge1(){
		 
		var equipment_one = document.getElementsByName("equipment_ones")[0].value;		
		var equipment_two = document.getElementsByName("equipment_twos")[0].value;	
  
 		if(equipment_one==""){
 			alert("设备设施类别一不能为空，请选择！");
 			return true;
 		}
 		if(equipment_two==""){
 			alert("设备设施类别二不能为空，请填写！");
 			return true;
 		}
   
 		return false;
 	}
	
	function toUpdate1(){ 
		var rowParams = new Array(); 
		var rowParam = {};			 
		var eq_id = document.getElementsByName("eq_id")[0].value;	 
		var dev_acc_id = document.getElementsByName("dev_acc_id")[0].value;		
		if(checkJudge1()){
			return;
		}
		  if(dev_acc_id !=null && dev_acc_id !=''){		 
			  if(eq_id !=null && eq_id !=''){	
				var dev_acc_id = document.getElementsByName("dev_acc_id")[0].value; 
				var equipment_one = document.getElementsByName("equipment_ones")[0].value;		
				var equipment_two = document.getElementsByName("equipment_twos")[0].value;	 
			 
				rowParam['dev_acc_id'] = encodeURI(encodeURI(dev_acc_id));
				rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));		 		
				rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two)); 
			    rowParam['eq_id'] = eq_id; 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("GMS_DEVICE_ACCOUNT_EQUIPMENT",rows);	
			  }else{
				  	var dev_acc_id = document.getElementsByName("dev_acc_id")[0].value; 
					var equipment_one = document.getElementsByName("equipment_ones")[0].value;		
					var equipment_two = document.getElementsByName("equipment_twos")[0].value;	 
				 
					rowParam['dev_acc_id'] = encodeURI(encodeURI(dev_acc_id));
					rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));		 		
					rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two)); 
				    rowParam['eq_id'] = eq_id; 
					rowParams[rowParams.length] = rowParam; 
					var rows=JSON.stringify(rowParams);	 
					saveFunc("GMS_DEVICE_ACCOUNT_EQUIPMENT",rows);	
				  
			  }
			    refreshData();	
	   
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
 
	 
	function getNum(selectValue){

		applypost_str='<option value="">请选择</option>';
		 
			//选择当前班组
			if(selectValue=='1'){
				applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
			}else{
				applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
			}
	 

	}
 
	 function deleteLine(lineId){		
			var rowNum = lineId.split('_')[1];
			var line = document.getElementById(lineId);		

			var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
			if(bsflag!=""){
				line.style.display = 'none';
				document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
			}else{
				line.parentNode.removeChild(line);
			}	
		}

</script>

</html>

