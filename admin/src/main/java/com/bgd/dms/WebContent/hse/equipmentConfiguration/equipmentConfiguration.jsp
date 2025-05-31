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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
	
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
 
<title>设备设施配置 </title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">是否计划内</td>
			    <td class="ali_cdn_input">
			    <select id="ifState" name="ifState" class="select_width">
			       <option value="" >请选择</option>
			       <option value="2" >是</option>
			       <option value="1" >否</option>		
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{pk_id}' value='{pk_id},{spare1}' onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1" >序号</td> 
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{org_name}</font>">单位</td> 
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{second_org_name}</font>">基层单位</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{third_org_name}</font>">下属单位</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{if_type}</font>">是否计划内</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{f_name}</font>">设备设施名称</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold'>{a_time}</font>">购置时间</td>
			      <td class="bt_info_even" exp="<font color='{color}' style='font-weight:bold'>{v_day}</font>">临近有效期时间</td>
			      <td class="bt_info_odd" exp="<font color='{color}' style='font-weight:bold' >{c_day}</font>">临近校验日期时间</td>
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
			 <div id="type1" style="display:none;">
			<div id="tag-container_3">
			  <ul id="tags" class="tags">   			  
			    <li class="selectTag" id="tag3"><a href="#" >实施情况</a></li>
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 			
				<div id="tab_box_content" class="tab_box_content" style="display:block;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
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
				    	  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					       	<input type="hidden" id="spare1" name="spare1" value="1" />
					      	<input type="hidden" id="unplanned_no" name="unplanned_no"   />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					  </tr>	
					 
						<tr>								 
						   <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
						    <td class="inquire_form6"><input type="text" id="facilities_name2" name="facilities_name2" class="input_width"     />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>数量：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="quantity2" name="quantity2" class="input_width"  onblur="calculateCost()"    />    		
						    </td>					   	      	
						    <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
						    <td class="inquire_form6">
						    <input type="text" id="measurement_unit2" name="measurement_unit2" class="input_width"   />    					    
						    </td>					    
						</tr>			 
					  <tr>	
						  <td class="inquire_item6"><font color="red">*</font>型号：</td>
						    <td class="inquire_form6"><input type="text" id="model_num2" name="model_num2" class="input_width"    />
						    </td>
				 		    <td class="inquire_item6"><font color="red">*</font>编号：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="numbers2" name="numbers2" class="input_width"   />    		
						    </td>					   	      	
						    <td class="inquire_item6"><font color="red">*</font>单价（元） ：</td>
						    <td class="inquire_form6">
						    <input type="text" id="price2" name="price2" class="input_width"   onblur="calculateCost()"  />    					    
						    </td>			
					  </tr>
					  <tr>	
					   <td class="inquire_item6"><font color="red">*</font>合计（元） ：</td>
					    <td class="inquire_form6"><input type="text" id="aggregate_sum2" name="aggregate_sum2" class="input_width"   readonly="readonly" />
					    </td>
			 		    <td class="inquire_item6"><font color="red">*</font>购置负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="acquisition2" name="acquisition2" class="input_width"   />    		
					    </td>					   	      	
					    <td class="inquire_item6"><font color="red">*</font>购置时间 ：</td>
					    <td class="inquire_form6">
					    <input type="text" id="acquisition_time2" name="acquisition_time2" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time2,tributton1);" />&nbsp;</td>		
				     </tr>		
					  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>设备状态：</td>
					    <td class="inquire_form6">
					    <select id="equipment_state2" name="equipment_state2" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >在用</option>
					       <option value="2" >停用</option>		
					       <option value="3" >备用</option>
						</select>
					    					 
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>投入使用日期 ：</td>
					    <td class="inquire_form6">
					    <input type="text" id="put_use_date2" name="put_use_date2" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(put_use_date2,tributton2);" />&nbsp;</td>				   	      	
					    <td class="inquire_item6"><font color="red">*</font>有效时间截止到：</td>
					    <td class="inquire_form6">
					    <input type="text" id="valid_time2" name="valid_time2" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_time2,tributton3);" />&nbsp;</td>		
				     </tr>
				     <tr>	
				        <td class="inquire_item6"><font color="red">*</font>校验日期：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_date2" name="check_date2" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date2,tributton4);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>使用部门、班组或地点：</td>
					    <td class="inquire_form6"><input type="text" id="use_department2" name="use_department2" class="input_width"   />
					    </td>
			 		    <td class="inquire_item6"><font color="red">*</font>使用负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="the_use2" name="the_use2" class="input_width"   />    		
					    </td>				   	      	
					  </tr>		
					</table> <br>
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>备注：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:830px;" id="remark2" name="remark2"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>						  
					</table> 
				   </div>
			 		 
				</form>
			</div>			
	  </div>
	 
	 
	 <div id="type2" style="display:block;">
		<div id="tag-container_3">
		  <ul id="tags" class="tags">   			  
		    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">配置计划</a></li>
		    <li  id="tag3_1"><a href="#" onclick="getTab3(1)">实施情况</a></li>
		   </ul>
		</div>
		
		<div id="tab_box" class="tab_box">
		<form name="form" id="form"  method="post" action="">

			<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="right" height="30">
              <td>&nbsp;</td>
              <td width="30"><span class="bc"><a href="#" onclick="toUpdate1()" title="保存"></a></span></td>
              <td width="5"></td>
            </tr>
     	 </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
			  <tr>						   
				  <td class="inquire_item6">单位：</td>
		    	  <td class="inquire_form6">
		    	  <input type="hidden" id="1org_sub_id" name="1org_sub_id" class="input_width" />
			      	<input type="text" id="1org_sub_id2" name="1org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdits(event)"/>
		        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
		        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
		        	<%} %>
		        	</td>					  
				  <td class="inquire_item6">基层单位：</td>
		    	  <td class="inquire_form6">
		    	  <input type="hidden" id="1second_org" name="1second_org" class="input_width" />
		    	  <input type="text" id="1second_org2" name="1second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdits(event)"/>
		        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
		        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2s()"/>
		        	<%} %>
		        	</td>	    	  
			  </tr>					  
				<tr>								 
				  <td class="inquire_item6">下属单位：</td>
			      	<td class="inquire_form6">
		 	      	<input type="hidden" id="1bsflag" name="1bsflag" value="0" />
			      	<input type="hidden" id="1create_date" name="1create_date" value="" />
			      	<input type="hidden" id="1creator" name="1creator" value="" />
			      	<input type="hidden" id="1equipment_no" name="1equipment_no"   />
			    	<input type="hidden" id="1project_no" name="1project_no" value="" />
			    	<input type="hidden" id="1spare1" name="1spare1" value="2" />
			      	<input type="hidden" id="1third_org" name="1third_org" class="input_width" />
			      	<input type="text" id="1third_org2" name="1third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdits(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3s()"/>
			      	<%}%>
			      	</td> 
			     
			    <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
			    <td class="inquire_form6">
			    <input type="text" id="1facilities_name" name="1facilities_name" class="input_width"   />    					    
			    </td>					    
				</tr>		
				
				  <tr>	
				    <td class="inquire_item6"><font color="red">*</font>数量：</td>
				    <td class="inquire_form6"><input type="text" id="1quantity" name="1quantity" class="input_width" onblur="calculateCost1()"  />
				    </td>
		 		    <td class="inquire_item6"><font color="red">*</font>计量单位：</td>
				    <td class="inquire_form6"> 
				    <input type="text" id="1measurement_unit" name="1measurement_unit" class="input_width"   />    		
				    </td>
				  </tr>		
				  <tr>	
				    <td class="inquire_item6"><font color="red">*</font>单价（元）：</td>
				    <td class="inquire_form6"><input type="text" id="1price" name="1price" class="input_width"  onblur="calculateCost1()"   />
				    </td>
		 		    <td class="inquire_item6"><font color="red">*</font>合计（元）：</td>
				    <td class="inquire_form6"> 
				    <input type="text" id="1aggregate_sum" name="1aggregate_sum" class="input_width"   readonly="readonly" />    		
				    </td>
				  </tr>		
				
				
			  <tr>	
			  <td class="inquire_item6"><font color="red">*</font>购置负责人：</td>
			    <td class="inquire_form6"> 
			    <input type="text" id="1acquisition" name="1acquisition" class="input_width"   />    		
			    </td>
			    <td class="inquire_item6"><font color="red">*</font>计划购置时间：</td>
			    <td class="inquire_form6"><input type="text" id="splan_acquisition_time" name="splan_acquisition_time" class="input_width"   readonly="readonly"/>
			    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(splan_acquisition_time,tributton6);" />&nbsp;</td>
	 		    
			  </tr>					  
			  <tr>
			    <td class="inquire_item6"><font color="red">*</font>计划编制日期：</td> 					   
			    <td class="inquire_form6"  align="center" > 
			    <input type="text" id="splan_date" name="splan_date" class="input_width"    readonly="readonly"/>
			    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton7" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(splan_date,tributton7);" />&nbsp;</td>
			  </tr>	
			</table> 		  
						  
			   </div>
			   <div id="tab_box_content1" class="tab_box_content">
			   <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr align="right" height="30">
                 <td>&nbsp;</td>
                 <td width="30"><span class="bc"><a href="#" onclick="toUpdate1()" title="保存"></a></span></td>
                 <td width="5"></td>
               </tr>
        	 </table>
        	          
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
				 
					<tr>								 
					   <td class="inquire_item6">设备设施名称：</td>
					    <td class="inquire_form6"><input type="text" id="1facilities_name2" name="1facilities_name2" class="input_width"     />
					    </td>
			 		    <td class="inquire_item6">数量：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="1quantity2" name="1quantity2" class="input_width"   onblur="calculateCost2()"  />    		
					    </td>					   	      	
					    <td class="inquire_item6">计量单位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="1measurement_unit2" name="1measurement_unit2" class="input_width"   />    					    
					    </td>					    
					</tr>			 
				  <tr>	
					  <td class="inquire_item6">型号：</td>
					    <td class="inquire_form6"><input type="text" id="1model_num2" name="1model_num2" class="input_width"    />
					    </td>
			 		    <td class="inquire_item6">编号：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="1numbers2" name="1numbers2" class="input_width"   />    		
					    </td>					   	      	
					    <td class="inquire_item6">单价（元） ：</td>
					    <td class="inquire_form6">
					    <input type="text" id="1price2" name="1price2" class="input_width"   onblur="calculateCost2()"  />    					    
					    </td>			
				  </tr>		
				  <tr>	
				   <td class="inquire_item6">合计（元） ：</td>
				    <td class="inquire_form6"><input type="text" id="1aggregate_sum2" name="1aggregate_sum2" class="input_width"  readonly="readonly"   />
				    </td>
		 		    <td class="inquire_item6">购置负责人：</td>
				    <td class="inquire_form6"> 
				    <input type="text" id="1acquisition2" name="1acquisition2" class="input_width"   />    		
				    </td>					   	      	
				    <td class="inquire_item6">购置时间 ：</td>
				    <td class="inquire_form6">
				    <input type="text" id="sacquisition_time2" name="sacquisition_time2" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton8" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sacquisition_time2,tributton8);" />&nbsp;</td>		
			     </tr>		
				  <tr>	
				  <td class="inquire_item6">设备状态：</td>
				    <td class="inquire_form6">
				    <select id="1equipment_state2" name="1equipment_state2" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >在用</option>
				       <option value="2" >停用</option>		
				       <option value="3" >备用</option>
					</select>
				    					 
				    </td>
				    <td class="inquire_item6">投入使用日期 ：</td>
				    <td class="inquire_form6">
				    <input type="text" id="sput_use_date2" name="sput_use_date2" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton9" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sput_use_date2,tributton9);" />&nbsp;</td>				   	      	
				    <td class="inquire_item6">有效时间截止到：</td>
				    <td class="inquire_form6">
				    <input type="text" id="svalid_time2" name="svalid_time2" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton10" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(svalid_time2,tributton10);" />&nbsp;</td>		
			     </tr>
			     <tr>	
			        <td class="inquire_item6">校验日期：</td>
				    <td class="inquire_form6">
				    <input type="text" id="scheck_date2" name="scheck_date2" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton11" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(scheck_date2,tributton11);" />&nbsp;</td>
				    <td class="inquire_item6">使用部门、班组或地点：</td>
				    <td class="inquire_form6"><input type="text" id="1use_department2" name="1use_department2" class="input_width"   />
				    </td>
		 		    <td class="inquire_item6">使用负责人：</td>
				    <td class="inquire_form6"> 
				    <input type="text" id="1the_use2" name="1the_use2" class="input_width"   />    		
				    </td>				   	      	
				  </tr>		
				</table> <br>
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>
				    <td class="inquire_item6">备注：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:750px;" id="1remark2" name="1remark2"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td>  <td class="inquire_item6"> </td> 	 				 
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
	
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2();
		}else if(isProject=="2"){
			querySqlAdd = "and project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select * from (select cn.equipment_no as pk_id,cn.facilities_name as f_name, nvl(cn.acquisition_time, cn.plan_acquisition_time) as a_time,cn.valid_time as v_time,(trunc(nvl(cn.valid_time, cn.plan_acquisition_time) - sysdate, 0)) v_day,"
		       				+"(trunc(nvl(cn.check_date, cn.plan_acquisition_time) - sysdate, 0)) c_day,case when (trunc(nvl(cn.valid_time, cn.plan_acquisition_time) - sysdate,0)) >= 30 then '' when (trunc(nvl(cn.valid_time, cn.plan_acquisition_time) - sysdate,0)) <= 0 then 'red' when (trunc(nvl(cn.check_date, cn.plan_acquisition_time) - sysdate,0)) >= 30 then '' when (trunc(nvl(cn.check_date, cn.plan_acquisition_time) - sysdate, 0)) < 0 then 'red' else 'orange' end color,"
		       				+"cn.check_date as c_date,decode(cn.spare1, '2', '是') as if_type,cn.spare1,cn.bsflag,cn.org_sub_id,cn.second_org,cn.third_org,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,cn.project_no "
		  					+" from BGP_EQUIPMENT_CONFIGURATION cn left join comm_org_subjection os1 on cn.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'"
		  					+"  left join comm_org_subjection os2 on cn.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join  comm_org_subjection os3 on cn.org_sub_id = os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0'"
		  					+" where cn.bsflag = '0' union all	select tr.unplanned_no as pk_id,tr.facilities_name2 as f_name,tr.acquisition_time2 as a_time,tr.valid_time2 as v_time,(trunc(nvl(tr.valid_time2, sysdate) - sysdate, 0)) v_day,(trunc(nvl(tr.check_date2, sysdate) - sysdate, 0)) c_day,"
		  					+" case when (trunc(nvl(tr.valid_time2, sysdate) - sysdate, 0)) >= 30 then '' when (trunc(nvl(tr.valid_time2, sysdate) - sysdate, 0)) <= 0 then 'red' when (trunc(nvl(tr.check_date2, sysdate) - sysdate, 0)) >= 30 then '' when (trunc(nvl(tr.check_date2, sysdate) - sysdate, 0)) <= 0 then 'red' else 'orange' end color,"
		  					+" tr.check_date2 as c_date,decode(tr.spare1, '1', '否') as if_type,tr.spare1,tr.bsflag2,tr.org_sub_id,tr.second_org,tr.third_org,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,tr.project_no "
		  					+" from BGP_EQUIPMENT_UNPLANNED tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'"
		  					+" left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag='0' where tr.bsflag2 = '0') where  bsflag='0' "+querySqlAdd;
		cruConfig.currentPageUrl = "/hse/equipmentConfiguration/equipmentConfiguration.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl =  "/hse/equipmentConfiguration/equipmentConfiguration.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	function calculateCost(){
		var trainTotal=0;
 
		var quantity2 = document.getElementById("quantity2").value;
		var price2 = document.getElementById("price2").value;
	  
		if(checkNaN("quantity2") &&  checkNaN("price2")){
			trainTotal = parseFloat(quantity2)*parseFloat(price2);
	 
		 	}
		
		document.getElementById("aggregate_sum2").value=substrin(trainTotal);
	}
	
	function calculateCost1(){
		var trainTotal=0; 
		var quantity = document.getElementById("1quantity").value;
		var price = document.getElementById("1price").value;
	  
		if(checkNaN("1price")  && checkNaN("1quantity")){
			trainTotal = parseFloat(quantity)*parseFloat(price);	 
		 	}		
		document.getElementById("1aggregate_sum").value=substrin(trainTotal);
	}
	
	function calculateCost2(){
		var trainTotal=0; 		       
		var quantity = document.getElementById("1quantity2").value;
		var price = document.getElementById("1price2").value;
	  
		if(checkNaN("1quantity2")  && checkNaN("1price2")){
			trainTotal = parseFloat(quantity)*parseFloat(price);	 
		 	}		
		document.getElementById("1aggregate_sum2").value=substrin(trainTotal);
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
	// 简单查询
	function simpleSearch(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2();
		}else if(isProject=="2"){
			querySqlAdd = "and project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var ifState = document.getElementById("ifState").value;
		if(ifState!=''&& ifState!=null){
			cruConfig.cdtType = 'form';
			if(ifState =='2'){
				cruConfig.queryStr = "select cn.equipment_no as pk_id,cn.facilities_name as f_name,nvl(cn.acquisition_time,cn.plan_acquisition_time) as a_time,cn.valid_time as v_time , (trunc(nvl(cn.valid_time,cn.plan_acquisition_time)-sysdate,0)) v_day , (trunc(nvl(cn.check_date,cn.plan_acquisition_time)-sysdate,0)) c_day ,  case when  (trunc(nvl(cn.valid_time,cn.plan_acquisition_time)-sysdate,0))  >=30 then''     when  (trunc(nvl(cn.valid_time,cn.plan_acquisition_time)-sysdate,0)) <=0 then'red'         when  (trunc(nvl(cn.check_date,cn.plan_acquisition_time)-sysdate,0))  >=30 then''            when (trunc(nvl(cn.check_date,cn.plan_acquisition_time)-sysdate,0))  <0 then'red'  else  'orange'  end color,cn.check_date  as c_date,decode(cn.spare1,'2','是') as if_type,cn.spare1,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name  from BGP_EQUIPMENT_CONFIGURATION cn   left  join comm_org_subjection os1     on cn.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0' left  join comm_org_subjection os2     on cn.third_org = os2.org_subjection_id    and os2.bsflag = '0' left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id = cn.org_sub_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0'  where cn.bsflag = '0'  and cn.spare1='2' "+querySqlAdd+" order by cn.MODIFI_DATE desc ";
				cruConfig.currentPageUrl = "/hse/equipmentConfiguration/equipmentConfiguration.jsp";
				queryData(1);
			}
		 	if(ifState =='1'){
				cruConfig.queryStr = "select tr.unplanned_no as pk_id,tr.facilities_name2 as f_name,tr.acquisition_time2 as a_time,tr.valid_time2 as v_time, (trunc(nvl(tr.valid_time2,sysdate)-sysdate,0)) v_day  , (trunc(nvl(tr.check_date2,sysdate)-sysdate,0)) c_day ,  case when (trunc(nvl(tr.valid_time2,sysdate)-sysdate,0))>=30 then''      when (trunc(nvl(tr.valid_time2,sysdate)-sysdate,0))<=0 then'red'      when  (trunc(nvl(tr.check_date2,sysdate)-sysdate,0))>=30 then''        when (trunc(nvl(tr.check_date2,sysdate)-sysdate,0)) <=0 then'red'           else  'orange'  end color, tr.check_date2 as c_date, decode(tr.spare1,'1','否') as if_type,tr.spare1,oi3.org_abbreviation as org_name ,oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name  from BGP_EQUIPMENT_UNPLANNED tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id = os3.org_id where tr.bsflag2 = '0' and tr.spare1='1' "+querySqlAdd+" order by tr.MODIFI_DATE2 desc ";
				cruConfig.currentPageUrl = "/hse/equipmentConfiguration/equipmentConfiguration.jsp";
				queryData(1);
			}
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("ifState").value = "";
	}

	function loadDataDetail(ids){
     	 var tempa = ids.split(',');		
	    ids =  tempa[0];
	    var ifType=tempa[1];
	    if(ifType == '1'){
	 		 document.getElementById("type1").style.display="block";
	 		 document.getElementById("type2").style.display="none";
	 		var querySql = "";
			var queryRet = null;
			var  datas =null;		
			
			querySql = "  select tr.project_no, tr.unplanned_no, tr.facilities_name2,tr.quantity2,tr.measurement_unit2,tr.model_num2,tr.numbers2,tr.price2,tr.aggregate_sum2,tr.acquisition2,tr.acquisition_time2,tr.equipment_state2,tr.put_use_date2,tr.valid_time2,check_date2,use_department2,tr.the_use2,tr.remark2 ,tr.second_org,tr.third_org,oi3.org_abbreviation org_name,tr.creator2,tr.create_date2,tr.bsflag2,tr.org_sub_id, tr.spare1, oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EQUIPMENT_UNPLANNED tr     left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id = os3.org_id    where tr.bsflag2 = '0' and tr.unplanned_no='"+ids+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){			
		  
		             document.getElementsByName("unplanned_no")[0].value=datas[0].unplanned_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag2;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date2;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator2;		  
		    		 document.getElementsByName("spare1")[0].value=datas[0].spare1;			    			
	    		    document.getElementsByName("facilities_name2")[0].value=datas[0].facilities_name2;
	    		    document.getElementsByName("quantity2")[0].value=datas[0].quantity2;		
	    			document.getElementsByName("measurement_unit2")[0].value=datas[0].measurement_unit2;			
	    		    document.getElementsByName("model_num2")[0].value=datas[0].model_num2;		
	    			document.getElementsByName("numbers2")[0].value=datas[0].numbers2;		
	    			document.getElementsByName("price2")[0].value=datas[0].price2;			
	    		    document.getElementsByName("aggregate_sum2")[0].value=datas[0].aggregate_sum2;
	    			document.getElementsByName("acquisition2")[0].value=datas[0].acquisition2;		
	    			document.getElementsByName("acquisition_time2")[0].value=datas[0].acquisition_time2;			
	    			document.getElementsByName("equipment_state2")[0].value=datas[0].equipment_state2;		
	    			document.getElementsByName("put_use_date2")[0].value=datas[0].put_use_date2;		
	    			document.getElementsByName("valid_time2")[0].value=datas[0].valid_time2;	
	    	 		document.getElementsByName("check_date2")[0].value=datas[0].check_date2;			
	    			document.getElementsByName("use_department2")[0].value=datas[0].use_department2;			
	    			document.getElementsByName("the_use2")[0].value=datas[0].the_use2;			
	    			document.getElementsByName("remark2")[0].value=datas[0].remark2;			
	    			  document.getElementsByName("project_no")[0].value=datas[0].project_no;	
				}					
			
		    	}					    	
	 		 
	    }
	    if(ifType == '2'){
	 		 document.getElementById("type1").style.display="none";
	 		 document.getElementById("type2").style.display="block";
	 		var querySql = "";
			var queryRet = null;
			var  datas =null;		
			
			querySql = "select cn.project_no, cn.org_sub_id,cn.equipment_no,cn.facilities_name,cn.quantity,cn.measurement_unit,cn.price,cn.aggregate_sum,cn.acquisition,cn.plan_acquisition_time,cn.plan_date ,   nvl(cn.facilities_name1,cn.facilities_name) facilities_name1,      nvl(cn.quantity1,cn.quantity) quantity1,      nvl(cn.measurement_unit1,cn.measurement_unit) measurement_unit1,     cn.model_num,   cn.numbers,    nvl(cn.price1,cn.price) price1, nvl(cn.aggregate_sum1,cn.aggregate_sum) aggregate_sum1,     nvl(cn.acquisition1,cn.acquisition) acquisition1,      nvl(cn.acquisition_time,cn.plan_acquisition_time)acquisition_time,cn.equipment_state,cn.put_use_date,cn.valid_time, cn.check_date,cn.use_department,cn.the_use,cn.remark,cn.second_org,cn.third_org,oi3.org_abbreviation org_name,cn.creator,cn.create_date,cn.bsflag,cn.spare1,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EQUIPMENT_CONFIGURATION cn    left  join comm_org_subjection os1     on cn.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0' left  join comm_org_subjection os2     on cn.third_org = os2.org_subjection_id    and os2.bsflag = '0' left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id = cn.org_sub_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0'     where cn.bsflag = '0' and  cn.equipment_no='"+ids+"'"; 				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
		             document.getElementsByName("1equipment_no")[0].value=datas[0].equipment_no; 
		    		 document.getElementsByName("1org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("1org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("1bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("1second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("1second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("1third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("1third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("1create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("1creator")[0].value=datas[0].creator;		  
		    		 document.getElementsByName("1spare1")[0].value=datas[0].spare1;		 
		    		 
		    		 document.getElementsByName("1facilities_name")[0].value=datas[0].facilities_name;
		    		 document.getElementsByName("1quantity")[0].value=datas[0].quantity;		
		    		 document.getElementsByName("1measurement_unit")[0].value=datas[0].measurement_unit;			
		    		 document.getElementsByName("1price")[0].value=datas[0].price;		
		    		 document.getElementsByName("1aggregate_sum")[0].value=datas[0].aggregate_sum;		
		    		 document.getElementsByName("1acquisition")[0].value=datas[0].acquisition;	
		    	 	 document.getElementsByName("splan_acquisition_time")[0].value=datas[0].plan_acquisition_time;		
		    		 document.getElementsByName("splan_date")[0].value=datas[0].plan_date;		
		    		 
		    		    document.getElementsByName("1facilities_name2")[0].value=datas[0].facilities_name1;
		    		    document.getElementsByName("1quantity2")[0].value=datas[0].quantity1;		
		    			document.getElementsByName("1measurement_unit2")[0].value=datas[0].measurement_unit1;			
		    		    document.getElementsByName("1model_num2")[0].value=datas[0].model_num;		
		    			document.getElementsByName("1numbers2")[0].value=datas[0].numbers;		
		    			document.getElementsByName("1price2")[0].value=datas[0].price1;			
		    		    document.getElementsByName("1aggregate_sum2")[0].value=datas[0].aggregate_sum1;
		    			document.getElementsByName("1acquisition2")[0].value=datas[0].acquisition1;		
		    			document.getElementsByName("sacquisition_time2")[0].value=datas[0].acquisition_time;			
		    			document.getElementsByName("1equipment_state2")[0].value=datas[0].equipment_state;		
		    			document.getElementsByName("sput_use_date2")[0].value=datas[0].put_use_date;		
		    			document.getElementsByName("svalid_time2")[0].value=datas[0].valid_time;	
		    	 		document.getElementsByName("scheck_date2")[0].value=datas[0].check_date;			
		    			document.getElementsByName("1use_department2")[0].value=datas[0].use_department;			
		    			document.getElementsByName("1the_use2")[0].value=datas[0].the_use;			
		    			document.getElementsByName("1remark2")[0].value=datas[0].remark;
		    			document.getElementsByName("1project_no")[0].value=datas[0].project_no;	
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
		popWindow("<%=contextPath%>/hse/equipmentConfiguration/choosePage.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>",'1024:800');
		
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
	  
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    
	    if(ifType == '1'){ 	popWindow("<%=contextPath%>/hse/equipmentConfiguration/addUnplanned.jsp?projectInfoNo=<%=projectInfoNo%>&unplanned_no="+ids,'1024:800'); }
	    if(ifType == '2'){ 	popWindow("<%=contextPath%>/hse/equipmentConfiguration/addWithinThePlan.jsp?projectInfoNo=<%=projectInfoNo%>&equipment_no="+ids); }
	  
	  	
	} 
	function dbclickRow(ids){
		 var tempa = ids.split(',');		
		    ids =  tempa[0];
		    var ifType=tempa[1];
		  
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    } 
		    
		    if(ifType == '1'){ 	popWindow("<%=contextPath%>/hse/equipmentConfiguration/addUnplanned.jsp?projectInfoNo=<%=projectInfoNo%>&unplanned_no="+ids,'1024:800'); }
		    if(ifType == '2'){ 	popWindow("<%=contextPath%>/hse/equipmentConfiguration/addWithinThePlan.jsp?projectInfoNo=<%=projectInfoNo%>&equipment_no="+ids); }
		  
	}
	 
	function toDelete(){ 		
		ids = getSelIds('chx_entity_id');
	  	
   	    var tempa = ids.split(',');		
	    ids =  tempa[0];
	    var ifType=tempa[1];
	  
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    
	    var idA="";
	    var idB="";
		for(var i=0;i<tempa.length;i++){
			
			idA = idA + "'" + tempa[i] + "'";
		}
	    
	    
	    var tempIds = ids.split(",");
		var id = "";
		for(var i=0;i<tempIds.length;i++){
			id = id + "'" + tempIds[i] + "'";
			if(i != tempIds.length -1){
				id = id + ",";
			
			}
		}
 
		//deleteEntities("update BGP_HSE_CHECK  e set e.bsflag='1' where e.check_no in ("+id+")");
	 
		
	    
	    if(ifType == '1'){ 
	    	   deleteEntities("update BGP_EQUIPMENT_UNPLANNED e set e.bsflag2='1' where e.UNPLANNED_NO='"+ids+"'");
	    }
	    if(ifType == '2'){ 
	    	  deleteEntities("update BGP_EQUIPMENT_CONFIGURATION e set e.bsflag='1' where e.EQUIPMENT_NO='"+ids+"'");
	    }
 
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/equipmentConfiguration/hse_search.jsp?isProject=<%=isProject%>");
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
				
				var facilities_name2 = document.getElementsByName("facilities_name2")[0].value;
				var quantity2 = document.getElementsByName("quantity2")[0].value;		
				var measurement_unit2 = document.getElementsByName("measurement_unit2")[0].value;			
				var model_num2 = document.getElementsByName("model_num2")[0].value;		
				var numbers2 = document.getElementsByName("numbers2")[0].value;		
				var price2 = document.getElementsByName("price2")[0].value;			
				var aggregate_sum2 = document.getElementsByName("aggregate_sum2")[0].value;
				var acquisition2 = document.getElementsByName("acquisition2")[0].value;		
				var acquisition_time2 = document.getElementsByName("acquisition_time2")[0].value;			
				var equipment_state2 = document.getElementsByName("equipment_state2")[0].value;		
				var put_use_date2 = document.getElementsByName("put_use_date2")[0].value;		
				var valid_time2 = document.getElementsByName("valid_time2")[0].value;	
		 		var check_date2 = document.getElementsByName("check_date2")[0].value;			
				var use_department2 = document.getElementsByName("use_department2")[0].value;			
				var the_use2 = document.getElementsByName("the_use2")[0].value;			
				var remark2 = document.getElementsByName("remark2")[0].value;	
				
				
		 		if(org_sub_id==""){
		 			document.getElementById("org_sub_id").value = "";
		 		}
		 		if(second_org==""){
		 			document.getElementById("second_org").value="";
		 		}
		 		if(third_org==""){
		 			document.getElementById("third_org").value="";
		 		}
		 		if(facilities_name2==""){
		 			alert("设备设施名称不能为空，请填写！");
		 			return true;
		 		}
		 		if(quantity2==""){
		 			alert("数量不能为空，请选择！");
		 			return true;
		 		}
		 		if(measurement_unit2==""){
		 			alert("计量单位不能为空，请填写！");
		 			return true;
		 		}
		 
				if(model_num2==""){
		 			alert("型号不能为空，请填写！");
		 			return true;
		 		}
				if(numbers2==""){
		 			alert("编号不能为空，请填写！");
		 			return true;
		 		}
				if(price2==""){
		 			alert("单价（元）不能为空，请填写！");
		 			return true;
		 		}
				if(aggregate_sum2==""){
		 			alert("合计（元）不能为空，请填写！");
		 			return true;
		 		}
				
		 		
				if(acquisition2==""){
		 			alert("购置负责人不能为空，请填写！");
		 			return true;
		 		}
				if(acquisition_time2==""){
		 			alert("购置时间不能为空，请填写！");
		 			return true;
		 		}
				if(equipment_state2==""){
		 			alert("设备状态不能为空，请填写！");
		 			return true;
		 		}
				if(put_use_date2==""){
		 			alert("投入使用日期不能为空，请填写！");
		 			return true;
		 		}
				if(valid_time2==""){
		 			alert("有效时间截止到不能为空，请填写！");
		 			return true;
		 		}
				if(check_date2==""){
		 			alert("校验日期不能为空，请填写！");
		 			return true;
		 		}
				if(use_department2==""){
		 			alert("使用部门、班组或地点不能为空，请填写！");
		 			return true;
		 		}
				if(the_use2==""){
		 			alert("使用负责人不能为空，请填写！");
		 			return true;
		 		}
				if(remark2==""){
		 			alert("备注不能为空，请填写！");
		 			return true;
		 		}
				
				
		 		return false;
		 	}
		 				
			
			
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var unplanned_no = document.getElementsByName("unplanned_no")[0].value;						 
		  if(unplanned_no !=null && unplanned_no !=''){		
				if(checkJudge()){
					return;
				} 
				var unplanned_no = document.getElementsByName("unplanned_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
				var spare1 = document.getElementsByName("spare1")[0].value;		
				
				var facilities_name2 = document.getElementsByName("facilities_name2")[0].value;
				var quantity2 = document.getElementsByName("quantity2")[0].value;		
				var measurement_unit2 = document.getElementsByName("measurement_unit2")[0].value;			
				var model_num2 = document.getElementsByName("model_num2")[0].value;		
				var numbers2 = document.getElementsByName("numbers2")[0].value;		
				var price2 = document.getElementsByName("price2")[0].value;			
				var aggregate_sum2 = document.getElementsByName("aggregate_sum2")[0].value;
				var acquisition2 = document.getElementsByName("acquisition2")[0].value;		
				var acquisition_time2 = document.getElementsByName("acquisition_time2")[0].value;			
				var equipment_state2 = document.getElementsByName("equipment_state2")[0].value;		
				var put_use_date2 = document.getElementsByName("put_use_date2")[0].value;		
				var valid_time2 = document.getElementsByName("valid_time2")[0].value;	
		 		var check_date2 = document.getElementsByName("check_date2")[0].value;			
				var use_department2 = document.getElementsByName("use_department2")[0].value;			
				var the_use2 = document.getElementsByName("the_use2")[0].value;			
				var remark2 = document.getElementsByName("remark2")[0].value;			
				var project_no = document.getElementsByName("project_no")[0].value;						 
	
	    		if(equipment_state2 =="1"){
	    			if(put_use_date2 =="") {alert("设备状态为在用状态,投入使用日期必填");	return;}
	    			if(use_department2 =="") {alert("设备状态为在用状态,使用部门、班组或地点必填");	return;}
	    			if(the_use2 =="") {alert("设备状态为在用状态,使用负责人必填");	return;}
	    		}
	    		if(valid_time2 ==""  && check_date2==""){alert("有效时间截止日期 或 校验日期 必须填一个！");return;	}
			 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			 
				
				rowParam['facilities_name2'] = encodeURI(encodeURI(facilities_name2));
				rowParam['quantity2'] = quantity2;
				rowParam['measurement_unit2'] = encodeURI(encodeURI(measurement_unit2));
				rowParam['model_num2'] = encodeURI(encodeURI(model_num2));		 		
				rowParam['numbers2'] = encodeURI(encodeURI(numbers2));
				rowParam['price2'] = price2;
				rowParam['aggregate_sum2'] = aggregate_sum2;
				rowParam['acquisition2'] = encodeURI(encodeURI(acquisition2));
				rowParam['acquisition_time2'] = encodeURI(encodeURI(acquisition_time2));
				rowParam['equipment_state2'] = encodeURI(encodeURI(equipment_state2));		 		
				rowParam['put_use_date2'] = encodeURI(encodeURI(put_use_date2));
				rowParam['valid_time2'] = encodeURI(encodeURI(valid_time2));		
				rowParam['check_date2'] = encodeURI(encodeURI(check_date2));
				rowParam['use_department2'] = encodeURI(encodeURI(use_department2));
				rowParam['the_use2'] = encodeURI(encodeURI(the_use2));
				rowParam['remark2'] = encodeURI(encodeURI(remark2));
				
			    rowParam['unplanned_no'] = unplanned_no;
				rowParam['creator2'] = encodeURI(encodeURI(creator));
				rowParam['create_date2'] =create_date;
				rowParam['updator2'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date2'] = '<%=curDate%>';		
				rowParam['bsflag2'] = bsflag;
				rowParam['spare1'] = spare1;
		 
		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_EQUIPMENT_UNPLANNED",rows);	
				 refreshData();	
   
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
 
	
	function checkJudge1(){
 		var org_sub_id = document.getElementsByName("1org_sub_id2")[0].value;
		var second_org = document.getElementsByName("1second_org2")[0].value;			
		var third_org = document.getElementsByName("1third_org2")[0].value;			
		
		var facilities_name2 = document.getElementsByName("1facilities_name")[0].value;
		var quantity2 = document.getElementsByName("1quantity")[0].value;		
		var measurement_unit2 = document.getElementsByName("1measurement_unit")[0].value;			
		var price2 = document.getElementsByName("1price")[0].value;		
		var aggregate_sum2 = document.getElementsByName("1aggregate_sum")[0].value;		
		var acquisition2 = document.getElementsByName("1acquisition")[0].value;	
 		var plan_acquisition_time = document.getElementsByName("splan_acquisition_time")[0].value;		
		var splan_date = document.getElementsByName("splan_date")[0].value;		
		 
 		if(org_sub_id==""){
 			document.getElementById("1org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("1second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("1third_org").value="";
 		}
 		if(facilities_name2==""){
 			alert("设备设施名称不能为空，请填写！");
 			return true;
 		}
 		if(quantity2==""){
 			alert("数量不能为空，请选择！");
 			return true;
 		}
 		if(measurement_unit2==""){
 			alert("计量单位不能为空，请填写！");
 			return true;
 		}
 
		 
		if(price2==""){
 			alert("单价（元）不能为空，请填写！");
 			return true;
 		}
		if(aggregate_sum2==""){
 			alert("合计（元）不能为空，请填写！");
 			return true;
 		}
		 
		if(acquisition2==""){
 			alert("购置负责人不能为空，请填写！");
 			return true;
 		}
		if(plan_acquisition_time==""){
 			alert("计划购置时间不能为空，请填写！");
 			return true;
 		}
		if(splan_date==""){
 			alert("计划编制日期不能为空，请填写！");
 			return true;
 		}
 
		 
 		return false;
 	}
 			
	
	
	function toUpdate1(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var equipment_no = document.getElementsByName("1equipment_no")[0].value;						 
		  if(equipment_no !=null && equipment_no !=''){		
				if(checkJudge1()){
					return;
				} 
				var equipment_no = document.getElementsByName("1equipment_no")[0].value;
				var create_date = document.getElementsByName("1create_date")[0].value;
				var creator = document.getElementsByName("1creator")[0].value;		
				var org_sub_id = document.getElementsByName("1org_sub_id")[0].value;
				var bsflag = document.getElementsByName("1bsflag")[0].value;
				var second_org = document.getElementsByName("1second_org")[0].value;			
				var third_org = document.getElementsByName("1third_org")[0].value;			
				var spare1 = document.getElementsByName("1spare1")[0].value;	
				
				var facilities_name = document.getElementsByName("1facilities_name")[0].value;
				var quantity = document.getElementsByName("1quantity")[0].value;		
				var measurement_unit = document.getElementsByName("1measurement_unit")[0].value;			
				var price = document.getElementsByName("1price")[0].value;		
				var aggregate_sum = document.getElementsByName("1aggregate_sum")[0].value;		
				var acquisition = document.getElementsByName("1acquisition")[0].value;	
		 		var plan_acquisition_time = document.getElementsByName("splan_acquisition_time")[0].value;		
				var plan_date = document.getElementsByName("splan_date")[0].value;		
				var project_no = document.getElementsByName("1project_no")[0].value;		
				
				var facilities_name1= document.getElementsByName("1facilities_name2")[0].value;
				var quantity1 = document.getElementsByName("1quantity2")[0].value;	
				var  measurement_unit1= document.getElementsByName("1measurement_unit2")[0].value;			
				var  model_num= document.getElementsByName("1model_num2")[0].value;	
				var  numbers= document.getElementsByName("1numbers2")[0].value;	
				var  price1= document.getElementsByName("1price2")[0].value;	
				var  aggregate_sum1= document.getElementsByName("1aggregate_sum2")[0].value;
				var acquisition1 = document.getElementsByName("1acquisition2")[0].value;
				var  acquisition_time= document.getElementsByName("sacquisition_time2")[0].value;		
				var  equipment_state= document.getElementsByName("1equipment_state2")[0].value;		
				var  put_use_date= document.getElementsByName("sput_use_date2")[0].value;	
				var valid_time = document.getElementsByName("svalid_time2")[0].value;	
				var check_date = document.getElementsByName("scheck_date2")[0].value;		
				var use_department = document.getElementsByName("1use_department2")[0].value;			
				var the_use = document.getElementsByName("1the_use2")[0].value;		
				var remark = document.getElementsByName("1remark2")[0].value;		
				
				if(equipment_state =="1"){
	    			if(put_use_date =="") {alert("设备状态为在用状态,投入使用日期必填");	return;}
	    			if(use_department =="") {alert("设备状态为在用状态,使用部门、班组或地点必填");	return;}
	    			if(the_use =="") {alert("设备状态为在用状态,使用负责人必填");	return;}
	    		}
				if(valid_time ==""  && check_date==""){alert("有效时间截止日期 或 校验日期 必须填一个！");return;	}
		
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				
				rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
				rowParam['quantity'] = quantity;
				rowParam['measurement_unit'] = encodeURI(encodeURI(measurement_unit));
				rowParam['price'] = price;		 		
				rowParam['aggregate_sum'] = aggregate_sum;
				rowParam['acquisition'] = encodeURI(encodeURI(acquisition));
				rowParam['plan_acquisition_time'] = encodeURI(encodeURI(plan_acquisition_time));		 		
				rowParam['plan_date'] = encodeURI(encodeURI(plan_date));
				
				rowParam['facilities_name1'] = encodeURI(encodeURI(facilities_name1));
				rowParam['quantity1'] = quantity1;
				rowParam['measurement_unit1'] = encodeURI(encodeURI(measurement_unit1));			 
				rowParam['model_num'] = encodeURI(encodeURI(model_num));
				rowParam['numbers'] = encodeURI(encodeURI(numbers));		 		
				rowParam['price1'] = price1;
				rowParam['aggregate_sum1'] = aggregate_sum1;
				rowParam['acquisition1'] = encodeURI(encodeURI(acquisition1));
				rowParam['acquisition_time'] = encodeURI(encodeURI(acquisition_time));
				rowParam['equipment_state'] = encodeURI(encodeURI(equipment_state));		 		
				rowParam['put_use_date'] = encodeURI(encodeURI(put_use_date));
				rowParam['valid_time'] = encodeURI(encodeURI(valid_time));		
				rowParam['check_date'] = encodeURI(encodeURI(check_date));
				rowParam['use_department'] = encodeURI(encodeURI(use_department));
				rowParam['the_use'] = encodeURI(encodeURI(the_use));
				rowParam['remark'] = encodeURI(encodeURI(remark));     	  
				
 
			    rowParam['equipment_no'] = equipment_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
				rowParam['spare1'] = spare1;
 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_EQUIPMENT_CONFIGURATION",rows);	
				 refreshData();	
 	  
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
	 
	//键盘上只有删除键，和左右键好用
	 function noEdits(event){
	 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
	 		return true;
	 	}else{
	 		return false;
	 	}
	 }
	 
	 function selectOrgs(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
		    if(teamInfo.fkValue!=""){
		    	document.getElementById("1org_sub_id").value = teamInfo.fkValue;
		        document.getElementById("1org_sub_id2").value = teamInfo.value;
		    }
		}

		function selectOrg2s(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var second = document.getElementById("1org_sub_id").value;
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
				    	 document.getElementById("1second_org").value = teamInfo.fkValue; 
				        document.getElementById("1second_org2").value = teamInfo.value;
					}
		   
		}

		function selectOrg3s(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var third = document.getElementById("1second_org").value;
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
				    	 document.getElementById("1third_org").value = teamInfo.fkValue;
				        document.getElementById("1third_org2").value = teamInfo.value;
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

