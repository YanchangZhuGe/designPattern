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
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
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
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
 
<title>应急物资台账</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">标识</td>
			    <td class="ali_cdn_input">
			    <select id="ifBuild" name="ifBuild" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >符合</option>
			       <option value="2" >不符合</option>
				</select>
		       </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			       <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="fz" event="onclick='toCopyAdd()'" title="复制并添加"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			      <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="dr" event="onclick='toImportPage()'" title="导入"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="pljs" event="onclick='openAdd()'" title="批量录入"></auth:ListButton>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{emergency_no}' value='{if_show},{emergency_no}' onclick='chooseOne(this);loadDataDetail();' />" >
			       选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{org_name}</font>">单位</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{second_org_name}</font>">基层单位</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{supplies_name}</font>">物资名称</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{v_day}</font>">临近有效期时间</td> 
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{c_day}</font>">临近校验日期时间</td> 
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{appearance}</font>">外观</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{identification_s}</font>">标识</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{performance_s}</font>">性能</td> 
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{testing_time}</font>">检查时间</td> 
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{corrective_completiontime}</font>">整改完成时间</td> 
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
						    	 <td class="inquire_item6">下属单位：</td>
						      	<td class="inquire_form6"> 
						      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
						      	<input type="hidden" id="create_date" name="create_date" value="" />
						      	<input type="hidden" id="creator" name="creator" value="" />
						      	<input type="hidden" id="emergency_no" name="emergency_no"   />
						    	<input type="hidden" id="project_no" name="project_no" value="" />
						       	<input type="hidden" id="third_org" name="third_org" class="input_width" />
						      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
						      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
						      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
						      	<%}%>
						      	</td> 
		     			      	 <td class="inquire_item6"><font color="red">*</font>物资名称：</td>
								    <td class="inquire_form6">
								    <input type="text" id="supplies_name" name="supplies_name" class="input_width" />
								    </td>
						  </tr>					  
							<tr>
							 <td class="inquire_item6"><font color="red">*</font>物资类别：</td>
							    <td class="inquire_form6">
							    <select id="supplies_category" name="supplies_category" class="select_width">
							       <option value="" >请选择</option>
							       <option value="1" >人身防护</option>
							       <option value="2" >医疗急救</option>
							       <option value="3" >消防救援</option>
							       <option value="4" >防洪防汛</option>
							       <option value="5" >应急照明</option>
							       <option value="6" >交通运输</option>
							       <option value="7" >通讯联络</option>
							       <option value="8" >检测监测</option>
							       <option value="9" >工程抢险</option>
							       <option value="10" >剪切破拆</option>
							       <option value="11" >电力抢修</option>
							       <option value="12" >其他</option>
								</select> 
							    </td> 
							    <td class="inquire_item6">型号/规格：</td>					 
							    <td class="inquire_form6"> 
							    <input type="text" id="model_num" name="model_num" class="input_width"  />
		 					    </td>	
						  </tr>
							
						  <tr>	 
						   <td class="inquire_item6"><font color="red">*</font>	数量：</td>
						    <td class="inquire_form6"><input type="text" id="quantity" name="quantity"    class="input_width"/></td>
						   <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
						    <td class="inquire_form6"><input type="text" id="unit_measurement" name="unit_measurement"    class="input_width"/></td>
						  </tr>	
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>购置时间：</td>
						    <td class="inquire_form6">
						    <input type="text" id="acquisition_time" name="acquisition_time" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time,tributton1);" />&nbsp; 
						    </td>
						    <td class="inquire_item6">有效期截止至：</td>
						    <td class="inquire_form6">
						    <input type="text" id="valid_until" name="valid_until" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until,tributton2);" />&nbsp; 
						    </td>		
						  </tr>					  
						 
						  <tr>
						    <td class="inquire_item6">校验期截止至：</td>
						    <td class="inquire_form6">
						    <input type="text" id="check_period_until" name="check_period_until" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_period_until,tributton3);" />&nbsp; 
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>存放位置：</td>
						    <td class="inquire_form6">
						    <input type="text" id="storage_location" name="storage_location"    class="input_width"/>
						    </td>		
						  </tr>			
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>保管人：</td>
						    <td class="inquire_form6">
						    <input type="text" id="the_depository" name="the_depository" class="input_width" />
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
                <td width="30"><span class="bc"><a href="#" onclick="toUpdate1()"></a></span></td>
                <td width="5"></td>
              </tr>
       	 </table>
       	   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
			    <tr>			 				   
				    <td class="inquire_item6">单位：</td>
		        	<td class="inquire_form6">				     
			      	<input type="text" id="org_sub_id3" name="org_sub_id3" class="input_width"      readonly="readonly" style="color:gray"   />	
		        	</td>
		          	<td class="inquire_item6">基层单位：</td>
		        	<td class="inquire_form6">
			    	  <input type="text" id="second_org3" name="second_org3" class="input_width"    readonly="readonly" style="color:gray"     />	
		        	</td>
			     </tr>	
				  <tr>							   
			      	 <td class="inquire_item6">物资名称：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="bsflag3" name="bsflag3" value="0" />
				      	<input type="hidden" id="create_date3" name="create_date3" value="" />
				      	<input type="hidden" id="creator3" name="creator3" value="" />
				      	<input type="hidden" id="emergency_no3" name="emergency_no3"   />				      	
				    	<input type="hidden" id="teammat_info_id" name="teammat_info_id"   /> 	
				      	<input type="hidden" id="information_no" name="information_no"   /> 	
				    	<input type="hidden" id="project_no3" name="project_no3" value="" />
					    <input type="text" id="supplies_name3" name="supplies_name3" class="input_width"   readonly="readonly" style="color:gray" />
					   </td>
					   <td class="inquire_item6">	数量：</td>
					    <td class="inquire_form6"><input type="text" id="quantity3" name="quantity3"    class="input_width"   readonly="readonly" style="color:gray"  /></td>
					   
				  </tr>					  
					<tr>
					   <td class="inquire_item6">计量单位：</td>
				        <td class="inquire_form6"><input type="text" id="unit_measurement3" name="unit_measurement3"    readonly="readonly" style="color:gray"    class="input_width"/></td>
				    
					    <td class="inquire_item6"><font color="red">*</font>保管人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="the_depository3" name="the_depository3" class="input_width" />
					    </td> 
				  </tr>
					
				  <tr>	 
				  <td class="inquire_item6"><font color="red">*</font>物资类别：</td>
				    <td class="inquire_form6">
				    <select id="supplies_category3" name="supplies_category3" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >人身防护</option>
				       <option value="2" >医疗急救</option>
				       <option value="3" >消防救援</option>
				       <option value="4" >防洪防汛</option>
				       <option value="5" >应急照明</option>
				       <option value="6" >交通运输</option>
				       <option value="7" >通讯联络</option>
				       <option value="8" >检测监测</option>
				       <option value="9" >工程抢险</option>
				       <option value="10" >剪切破拆</option>
				       <option value="11" >电力抢修</option>
				       <option value="12" >其他</option>
					</select> 
				    </td> 
				    <td class="inquire_item6">型号/规格：</td>					 
				    <td class="inquire_form6"> 
				    <input type="text" id="model_num3" name="model_num3" class="input_width"  />
				    </td>	
				    
				  </tr>	
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>购置时间：</td>
				    <td class="inquire_form6">
				    <input type="text" id="acquisition_time3" name="acquisition_time3" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time3,tributton5);" />&nbsp;</td>
				    </td>
				    <td class="inquire_item6">有效期截止至：</td>
				    <td class="inquire_form6">
				    <input type="text" id="valid_until3" name="valid_until3" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until3,tributton4);" />&nbsp;</td>
				    </td>		
				  </tr>					  
				 
				  <tr>
				    <td class="inquire_item6">校验期截止至：</td>
				    <td class="inquire_form6">
				    <input type="text" id="check_period_until3" name="check_period_until3" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_period_until3,tributton6);" />&nbsp;</td>
				    </td>
				    <td class="inquire_item6"><font color="red">*</font>存放位置：</td>
				    <td class="inquire_form6">
				    <input type="text" id="storage_location3" name="storage_location3"    class="input_width"/>
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
var checked = false;
function check(){
	var chk = document.getElementsByName("chx_entity_id");
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
	var isProject = "<%=isProject%>";
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		var querySqlAdd = getMultipleSql2("tr.");
		cruConfig.queryStr = "    select t.*  from (   select  tr.CREATE_DATE,  '1' if_show, tr.emergency_no,       tr.supplies_name,       tr.unit_measurement,       tr.quantity,       decode(tr.appearance, '1', '完好', '2', '不完好') appearance,   tr.identification,    decode(tr.identification, '1', '符合', '2', '不符合') identification_s,       decode(tr.performance_s, '1', '有效', '2', '失效') performance_s,       tr.testing_time,       tr.corrective_completiontime,       tr.supplies_category,       tr.model_num,       tr.acquisition_time,       (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) v_day,       (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) c_day,       case         when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) >= 30 then       ''       when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) <= 0 then       'red'       when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       tr.storage_location,       tr.the_depository,    tr.bsflag,       ion.org_abbreviation as org_name,       oi1.org_abbreviation as second_org_name  from BGP_EMERGENCY_STANDBOOK tr  left join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0'   "+querySqlAdd+ 
				" union " +
				" select   g.CREATE_DATE, '2' if_show, w.RECYCLEMAT_INFO      as emergency_no,   g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance, ein.identification,    decode(ein.identification, '1', '符合', '2', '不符合') identification_s,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,       ein.bsflag,       ai.org_abbreviation as org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_recyclemat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.RECYCLEMAT_INFO  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'    left join comm_org_information ai   on w.org_id = ai.org_id   and ai.bsflag = '0'  where g.coding_code_id like '45%'  and  w.ORG_SUBJECTION_ID like'%"+orgSubId+"%'  ) t  order by   t.CREATE_DATE  desc    ";
		
		cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/suppliesStandingBook.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){ 
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/suppliesStandingBook.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	 function toImportPage(){ 
		    popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/importFileMain.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
	 }
	 
	 
	   function openAdd(){
		   window.open("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/allHomeFrame.jsp?optionP=1&isProject=<%=isProject%>",'homeMain','height=600px,width=1024px,left=100px,top=50px,menubar=no,status=no,toolbar=no ', '');
		   refreshData();
		}

	// 简单查询
	function simpleSearch(){
			var ifBuild = document.getElementById("ifBuild").value;
				if(ifBuild!=''&&ifBuild!=null){
					cruConfig.cdtType = 'form';
					var querySqlAdd = getMultipleSql2("tr.");
					cruConfig.queryStr =  "   select *  from ( select tr.CREATE_DATE, '1' if_show, tr.emergency_no,       tr.supplies_name,       tr.unit_measurement,       tr.quantity,       decode(tr.appearance, '1', '完好', '2', '不完好') appearance,   tr.identification,    decode(tr.identification, '1', '符合', '2', '不符合') identification_s,       decode(tr.performance_s, '1', '有效', '2', '失效') performance_s,       tr.testing_time,       tr.corrective_completiontime,       tr.supplies_category,       tr.model_num,       tr.acquisition_time,       (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) v_day,       (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) c_day,       case         when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) >= 30 then       ''       when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) <= 0 then       'red'       when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       tr.storage_location,       tr.the_depository,    tr.bsflag,       ion.org_abbreviation as org_name,       oi1.org_abbreviation as second_org_name  from BGP_EMERGENCY_STANDBOOK tr  left join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0' left  join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0'  "+querySqlAdd+ 
						" union " +
						" select  g.CREATE_DATE, '2' if_show, w.RECYCLEMAT_INFO      as emergency_no,   g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance, ein.identification,    decode(ein.identification, '1', '符合', '2', '不符合') identification_s,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,       ein.bsflag,      ai.org_abbreviation  as org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_recyclemat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.RECYCLEMAT_INFO  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'   left join comm_org_information ai   on w.org_id = ai.org_id   and ai.bsflag = '0'   where g.coding_code_id like '45%'  and  w.ORG_SUBJECTION_ID like'%"+orgSubId+"%'      ) ok  where ok.identification ='"+ifBuild+"'    order by   ok.CREATE_DATE  desc  ";
				 
					cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/suppliesStandingBook.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("ifBuild").value = "";
	}

	function loadDataDetail(shuaIds){
 
		var shuaId=shuaIds.split(',')[1];
		var ifShow=shuaIds.split(',')[0];

		if(shuaId !=null){ 
			if(ifShow =='1'){	
		 		 document.getElementById("type2").style.display="block";
			     document.getElementById("type1").style.display="none";
				var querySql = "";
				var queryRet = null;
				var  datas =null;					
				querySql = "   select tr.project_no, tr.org_sub_id,tr.emergency_no,tr.supplies_name,tr.supplies_category,tr.model_num,tr.quantity,tr.unit_measurement,tr.acquisition_time,  tr.valid_until,tr.check_period_until,  tr.storage_location,tr.the_depository  ,  tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_EMERGENCY_STANDBOOK tr   left  join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left   join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0'  and tr.emergency_no='"+shuaId+"'";				 	 
				queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				if(queryRet.returnCode=='0'){
					datas = queryRet.datas;
					if(datas != null){	
			             document.getElementsByName("emergency_no")[0].value=datas[0].emergency_no; 
			    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
			      		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
			    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
			    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
			    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
			    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
			    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;		    		 		 
			    		 document.getElementsByName("create_date")[0].value=datas[0].create_date;
			    		 document.getElementsByName("creator")[0].value=datas[0].creator;
			    		 
			    		document.getElementsByName("supplies_name")[0].value=datas[0].supplies_name;
			    		document.getElementsByName("supplies_category")[0].value=datas[0].supplies_category;		
			    		document.getElementsByName("model_num")[0].value=datas[0].model_num;			
			    		document.getElementsByName("quantity")[0].value=datas[0].quantity;			
			    		document.getElementsByName("unit_measurement")[0].value=datas[0].unit_measurement;
			    		document.getElementsByName("acquisition_time")[0].value=datas[0].acquisition_time;
			    		document.getElementsByName("valid_until")[0].value=datas[0].valid_until;			
			    		document.getElementsByName("check_period_until")[0].value=datas[0].check_period_until;			
			    		document.getElementsByName("storage_location")[0].value=datas[0].storage_location;
			    		document.getElementsByName("the_depository")[0].value=datas[0].the_depository;
			    		 document.getElementsByName("project_no")[0].value=datas[0].project_no;		
					}					
				
			    	}			
			}else if (ifShow =='2'){
		 		 document.getElementById("type1").style.display="block";
		 		 document.getElementById("type2").style.display="none";
		 		var querySql = "";
				var queryRet = null;
				var  datas =null;					
				querySql = " select      ein.project_no, ein.valid_until,ein.check_period_until,   ein.information_no, w.RECYCLEMAT_INFO     as emergency_no,  w.RECYCLEMAT_INFO  ,  g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance,     decode(ein.identification, '1', '符合', '2', '不符合') identification,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,       ein.bsflag,      ai.org_abbreviation  as org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_recyclemat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.RECYCLEMAT_INFO  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'   left join comm_org_information ai   on w.org_id = ai.org_id   and ai.bsflag = '0'  where g.coding_code_id like '45%'     and w.RECYCLEMAT_INFO='"+shuaId+"'";				 	 
				queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				if(queryRet.returnCode=='0'){
					datas = queryRet.datas;
					if(datas != null){	
						   document.getElementsByName("emergency_no3")[0].value=datas[0].emergency_no; 
					     document.getElementsByName("teammat_info_id")[0].value=datas[0].recyclemat_info; 
			             document.getElementsByName("information_no")[0].value=datas[0].information_no; 		 
			      		 document.getElementsByName("org_sub_id3")[0].value=datas[0].org_name;
			    		 document.getElementsByName("bsflag3")[0].value=datas[0].bsflag; 	
			    		 document.getElementsByName("second_org3")[0].value=datas[0].second_org_name;
			    		 document.getElementsByName("supplies_name3")[0].value=datas[0].supplies_name;
			    		document.getElementsByName("supplies_category3")[0].value=datas[0].supplies_category;		
			    		document.getElementsByName("model_num3")[0].value=datas[0].model_num;			
			    		document.getElementsByName("quantity3")[0].value=datas[0].quantity;			
			    		document.getElementsByName("unit_measurement3")[0].value=datas[0].unit_measurement;
			    		document.getElementsByName("acquisition_time3")[0].value=datas[0].acquisition_time;
			    		document.getElementsByName("valid_until3")[0].value=datas[0].valid_until;			
			    		document.getElementsByName("check_period_until3")[0].value=datas[0].check_period_until;			
			    		document.getElementsByName("storage_location3")[0].value=datas[0].storage_location;
			    		document.getElementsByName("the_depository3")[0].value=datas[0].the_depository;
			  		   document.getElementsByName("project_no3")[0].value=datas[0].project_no;	
					}					
				
			    	}			
				
			}
			
			
		
		}
		
	}  
	function calculateCost(){
		var trainTotal=0; 		       
		var inventory = document.getElementById("inventory").value;
		var consumption = document.getElementById("consumption").value;
	  
		if(checkNaN("inventory")  && checkNaN("consumption")){
			trainTotal = parseFloat(inventory)*parseFloat(consumption);	 
		 	}		
		document.getElementById("accumulated_comsumption").value=substrin(trainTotal);
	}
	
	function substrin(str)
	{ 
		str = Math.round(str * 10000) / 10000;
		return(str); 
	 }

	function checkNaN(numids){

		 var str = document.getElementById(numids).value;
	 
		 if(str!=""){		 
			if(isNaN(str)){
				alert("请输入数字");
				document.getElementById(numids).value="";
				return false;
			}else{
				return true;
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addSuppliesStandingBook.jsp?projectInfoNo=<%=projectInfoNo%>");
		
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
	function dbclickRow(ids){
 	    var tempa = ids.split(',');		
	    ids =  tempa[1];
	    var ifType=tempa[0];
	    
	    if(ifType == '1'){
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addSuppliesStandingBook.jsp?projectInfoNo=<%=projectInfoNo%>&emergency_no="+ids);
	    }
	    if(ifType == '2'){
			popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addSuppliesStandingTwo.jsp?projectInfoNo=<%=projectInfoNo%>&isProject=<%=isProject%>&emergency_no="+ids);
		    }
	 }
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	 
   	    var tempa = ids.split(',');		
	    ids =  tempa[1];
	    var ifType=tempa[0];
	    
	    if(ifType == '1'){	
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addSuppliesStandingBook.jsp?projectInfoNo=<%=projectInfoNo%>&emergency_no="+ids);
	    }
	    if(ifType == '2'){
			popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addSuppliesStandingTwo.jsp?projectInfoNo=<%=projectInfoNo%>&isProject=<%=isProject%>&emergency_no="+ids);
		  }
	} 
	
	 
	function toCopyAdd(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    
	    var tempa = ids.split(',');		
	    ids =  tempa[1];
	    
	    
		var querySql = "";
		var queryRet = null;
		var  datas =null;	 
	    querySql = " select   EMERGENCY_NO ,  ORG_SUB_ID ,  SECOND_ORG ,  THIRD_ORG  ,  SUPPLIES_NAME  ,  SUPPLIES_CATEGORY  ,  MODEL_NUM   ,  QUANTITY   ,  UNIT_MEASUREMENT  ,  ACQUISITION_TIME   ,  VALID_UNTIL  ,  CHECK_PERIOD_UNTIL   ,  STORAGE_LOCATION ,  THE_DEPOSITORY   ,  CREATOR  ,  CREATE_DATE   ,  UPDATOR    ,  MODIFI_DATE ,  BSFLAG ,  NOTES  ,  SPARE1 ,  SPARE2  ,  SPARE3  ,  SPARE4   ,  SPARE5  ,  APPEARANCE ,  IDENTIFICATION  ,  PERFORMANCE_S  ,  TESTING_TIME  ,  CORRECTIVE_COMPLETIONTIME,  PROJECT_NO   from   BGP_EMERGENCY_STANDBOOK  where EMERGENCY_NO='"+ ids +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null && datas != ""){			
			 
				var rowParams = new Array(); 
				var rowParam = {};			
	 
				
				rowParam['org_sub_id'] =datas[0].org_sub_id;
				rowParam['second_org'] = datas[0].second_org;
				rowParam['third_org'] = datas[0].third_org; 
				
				rowParam['supplies_name'] = encodeURI(encodeURI(datas[0].supplies_name));
				rowParam['supplies_category'] = encodeURI(encodeURI(datas[0].supplies_category)); 
				rowParam['model_num'] =encodeURI(encodeURI(datas[0].model_num)); 
				rowParam['quantity'] =datas[0].quantity; 	 
				rowParam['unit_measurement'] = encodeURI(encodeURI(datas[0].unit_measurement));
				rowParam['acquisition_time'] = encodeURI(encodeURI(datas[0].acquisition_time)); 
				rowParam['valid_until'] =encodeURI(encodeURI(datas[0].valid_until));	 
				rowParam['check_period_until'] = encodeURI(encodeURI(datas[0].check_period_until));
				rowParam['storage_location'] = encodeURI(encodeURI(datas[0].storage_location)); 
				rowParam['the_depository'] =encodeURI(encodeURI(datas[0].the_depository));	
				
			 
				
				rowParam['project_no'] =datas[0].project_no;
			    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] ='0';
			 

				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_EMERGENCY_STANDBOOK",rows);	 
				 refreshData();	
				
			}else{
				alert("请选择(单条)数据进行复制");
			}
			
		}
	}
	
	
	function toDeletess(){
 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var tempIds = ids.split(",");
		var id = "";
		for(var i=0;i<tempIds.length;i++){
			id = id + "'" + tempIds[i] + "'";
			if(i != tempIds.length -1){
				id = id + ",";
			
			}
		}
 
		deleteEntities("update BGP_EMERGENCY_STANDBOOK e set e.bsflag='1' where e.emergency_no in ("+id+")");
	 
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id'); 
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
   	    var tempa = ids.split(',');		
	      ids =  tempa[1];
	    var ifType=tempa[0];
	  
	
	    
	    if(ifType == '2'){alert('此信息不可删除！'); return;}
	    if(ifType == '1'){	deleteEntities("update BGP_EMERGENCY_STANDBOOK e set e.bsflag='1' where e.emergency_no ='"+ids+"' ");}
 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/hse_search1.jsp?isProject=<%=isProject%>");
	}
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("chx_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
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
			
			var supplies_name = document.getElementsByName("supplies_name")[0].value;
			var supplies_category = document.getElementsByName("supplies_category")[0].value;			
			var quantity = document.getElementsByName("quantity")[0].value;			
			var unit_measurement = document.getElementsByName("unit_measurement")[0].value;
			var acquisition_time = document.getElementsByName("acquisition_time")[0].value; 	
			var storage_location = document.getElementsByName("storage_location")[0].value;
			var the_depository = document.getElementsByName("the_depository")[0].value;
			
			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(supplies_name==""){
	 			alert("物资名称不能为空，请填写！");
	 			return true;
	 		}
	 		if(supplies_category==""){
	 			alert("物资类别不能为空，请选择！");
	 			return true;
	 		}
	 		if(quantity==""){
	 			alert("数量不能为空，请填写！");
	 			return true;
	 		}
	 
			if(unit_measurement==""){
	 			alert("计量单位不能为空，请填写！");
	 			return true;
	 		}
			if(acquisition_time==""){
	 			alert("购置时间不能为空，请填写！");
	 			return true;
	 		}
			if(storage_location==""){
	 			alert("存放位置不能为空，请填写！");
	 			return true;
	 		}
			if(the_depository==""){
	 			alert("保管人不能为空，请填写！");
	 			return true;
	 		}
			
	 		
	 		return false;
	 	}
	 	
	 	
		
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var emergency_no = document.getElementsByName("emergency_no")[0].value;						 
		  if(emergency_no !=null && emergency_no !=''){
				if(checkJudge()){
					return;
				}
				
			  var emergency_no = document.getElementsByName("emergency_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;
				var supplies_name = document.getElementsByName("supplies_name")[0].value;
				var supplies_category = document.getElementsByName("supplies_category")[0].value;		
				var model_num = document.getElementsByName("model_num")[0].value;			
				var quantity = document.getElementsByName("quantity")[0].value;			
				var unit_measurement = document.getElementsByName("unit_measurement")[0].value;
				var acquisition_time = document.getElementsByName("acquisition_time")[0].value;
				var valid_until = document.getElementsByName("valid_until")[0].value;			
				var check_period_until = document.getElementsByName("check_period_until")[0].value;			
				var storage_location = document.getElementsByName("storage_location")[0].value;
				var the_depository = document.getElementsByName("the_depository")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;						 
				
				if(check_period_until ==""){
					if(valid_until ==""){
						alert('有效期截日期不能为空！');return;
					}
				}	 
				if(valid_until ==""){
					if(check_period_until ==""){
						alert('校验期截日期不能为空！');return;
					}
				}
				
				 if(project_no !=null && project_no !=''){
						rowParam['project_no'] =project_no;	
					}else{
						rowParam['project_no'] ='<%=projectInfoNo%>';
					}
				rowParam['org_sub_id'] =org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org; 
				
				rowParam['supplies_name'] = encodeURI(encodeURI(supplies_name));
				rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category)); 
				rowParam['model_num'] =encodeURI(encodeURI(model_num)); 
				rowParam['quantity'] =quantity; 	 
				rowParam['unit_measurement'] = encodeURI(encodeURI(unit_measurement));
				rowParam['acquisition_time'] = encodeURI(encodeURI(acquisition_time)); 
				rowParam['valid_until'] =encodeURI(encodeURI(valid_until));	 
				rowParam['check_period_until'] = encodeURI(encodeURI(check_period_until));
				rowParam['storage_location'] = encodeURI(encodeURI(storage_location)); 
				rowParam['the_depository'] =encodeURI(encodeURI(the_depository));	
			  
				    rowParam['emergency_no'] = emergency_no;
				//	rowParam['creator'] = encodeURI(encodeURI(creator));
				//	rowParam['create_date'] =create_date;
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
		 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_EMERGENCY_STANDBOOK",rows);	
				refreshData();	
    
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
   
	function checkJudge1(){  
		var supplies_category = document.getElementsByName("supplies_category3")[0].value;		 	  
		var acquisition_time = document.getElementsByName("acquisition_time3")[0].value; 	
		var storage_location = document.getElementsByName("storage_location3")[0].value;
		var the_depository = document.getElementsByName("the_depository3")[0].value;
  
 		if(supplies_category==""){
 			alert("物资类别不能为空，请选择！");
 			return true;
 		} 
  
		if(acquisition_time==""){
 			alert("购置时间不能为空，请填写！");
 			return true;
 		}
		if(storage_location==""){
 			alert("存放位置不能为空，请填写！");
 			return true;
 		}
		if(the_depository==""){
 			alert("保管人不能为空，请填写！");
 			return true;
 		}
		 
 		return false;
 	}
 	
	function toUpdate1(){		
		var rowParams = new Array(); 
		var rowParam = {};		
	 
		  var emergency_no = document.getElementsByName("emergency_no3")[0].value;						 
		  if(emergency_no !=null && emergency_no !=''){
				if(checkJudge1()){
					return;
				}
				
			  var teammat_info_id = document.getElementsByName("teammat_info_id")[0].value;
			  var information_no = document.getElementsByName("information_no")[0].value;
 
				var supplies_category = document.getElementsByName("supplies_category3")[0].value;		
				var model_num = document.getElementsByName("model_num3")[0].value;			  
				var acquisition_time = document.getElementsByName("acquisition_time3")[0].value;
				var valid_until = document.getElementsByName("valid_until3")[0].value;			
				var check_period_until = document.getElementsByName("check_period_until3")[0].value;			
				var storage_location = document.getElementsByName("storage_location3")[0].value;
				var the_depository = document.getElementsByName("the_depository3")[0].value;
			    var project_no = document.getElementsByName("project_no3")[0].value;	
			    
				if(check_period_until ==""){
					if(valid_until ==""){
						alert('有效期截日期不能为空！');return;
					}
				}	 
				if(valid_until ==""){
					if(check_period_until ==""){
						alert('校验期截日期不能为空！');return;
					}
				}
				
				 if(project_no !=null && project_no !=''){
						rowParam['project_no'] =project_no;	
					}else{
						rowParam['project_no'] ='<%=projectInfoNo%>';
					}
				rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category)); 
				rowParam['model_num'] =encodeURI(encodeURI(model_num));  
				rowParam['acquisition_time'] = encodeURI(encodeURI(acquisition_time)); 
				rowParam['valid_until'] =encodeURI(encodeURI(valid_until));	 
				rowParam['check_period_until'] = encodeURI(encodeURI(check_period_until));
				rowParam['storage_location'] = encodeURI(encodeURI(storage_location)); 
				rowParam['the_depository'] =encodeURI(encodeURI(the_depository));	
			  
				    rowParam['teammat_info_id'] = teammat_info_id;
				    rowParam['information_no'] = information_no;
					rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] ='<%=curDate%>';
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = '0';
		 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_EMERGENCY_INFORMATION",rows);	
				refreshData();	
 
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
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

