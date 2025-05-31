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
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
<title>培训和演练 </title>
</head> 
<body style="background:#cdddef"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">演练类别</td>
			    <td class="inquire_form6"> 
			    <select id="changeName" name="changeName" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >实战演练</option>
			       <option value="2" >桌面演练</option>  
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{pk_id}' value='{pk_id},{spare1}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{s_time}">培训开始时间</td>
			      <td class="bt_info_even" exp="{d_time}">演练时间</td>
			      <td class="bt_info_odd" exp="{p_category}">演练类别</td>
			      <td class="bt_info_even" exp="{e_plan}">演练预案</td> 
			      <td class="bt_info_even" exp="{if_type}">选择方式</td> 
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
			    <li class="selectTag" id="tag3"><a href="#" onclick="getTab1(0)" >应急培训</a></li>
			    <li  id="tag3s"><a href="#" onclick="getTab1(1)">附件</a></li>
			   </ul>
			</div> 
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action=""> 
				<div id="tab_box_content" class="tab_box_content" style="display:block;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="addSelect();toUpdate()"></a></span></td>
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
					      	<input type="hidden" id="participants_ranges" name="participants_ranges" value="" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="training_no" name="training_no"   />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					       	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					     </td> 
					     <td class="inquire_item6"><font color="red">*</font>参加人员数量：</td>
						    <td class="inquire_form6"><input type="text" id="number_participants" name="number_participants" class="input_width"   onkeypress="return on_key_press_int(this)"  />
						    </td>
						  </tr>	 
						<tr>								 
						   <td class="inquire_item6">参加人员范围：</td>
						    <td class="inquire_form6"  colspan="3">
						    <input type="checkbox"    id="participants_range1"   name="participants_range"  onclick="setDisAttr(this);"  value="全体员工" />全体员工
						    <input type="checkbox"    id="participants_range2"   name="participants_range"   onclick="setDisAttr1(this);"  value="应急人员" />应急人员
						    <input type="checkbox"    id="participants_range3"   name="participants_range"  onclick="setDisAttr2(this);"  value="直线管理人员" />直线管理人员
						    <input type="checkbox"    id="participants_range4"   name="participants_range"  onclick="setDisAttr3(this);"  value="HSE管理人员" />HSE管理人员
						    <input type="checkbox"    id="participants_range5"   name="participants_range"  onclick="setDisAttr4(this);"  value="新上岗转岗人员" />新上岗转岗人员
						    <input type="checkbox"    id="participants_range6"   name="participants_range"  onclick="setDisAttr5(this);"  value="外来人员" />外来人员
						    </td>				 		   	    
						</tr>			 
					  <tr>	 
				 		    <td class="inquire_item6"><font color="red">*</font>学时：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="school" name="school" class="input_width"  onkeypress="return on_key_press_int(this)" />    个		
						    </td>					   	      	
						    <td class="inquire_item6"><font color="red">*</font>培训开始时间 ：</td>
						    <td class="inquire_form6">
						    <input type="text" id="training_start_time" name="training_start_time" class="input_width"      />    					    
						    </td>			
					  </tr>		
					  <tr>	
					   <td class="inquire_item6">主办部门 ：</td>
					    <td class="inquire_form6"><input type="text" id="host_department" name="host_department" class="input_width"   />
					    </td>
			 		    <td class="inquire_item6">培训小结：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="training_summary" name="training_summary" class="input_width"   />    		
					    </td>
				     </tr>							  
					</table> <br>
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>培训内容：</td> 					   
					    <td class="inquire_form6" colspan="4" align="center" ><textarea  style="width:730px;height:60px;" id="training_content" name="training_content"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>						  
					</table>					
				   </div>
				   
					<div id="tab_box_contents" class="tab_box_content" style="display:none;">
				   <iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>
				   </div>
				</form>
			</div>			
	  </div>
	  
	  <div id="type2" style="display:none;">
		<div id="tag-container_3">
		  <ul id="tags" class="tags">   			  
		    <li class="selectTag" id="tag32"><a href="#" onclick="getTab2(0)" >应急演练</a></li>
		    <li  id="tag3s2"><a href="#" onclick="getTab2(1)">附件</a></li>
		   </ul>
		</div> 
		<div id="tab_box" class="tab_box">
		<form name="form" id="form1"  method="post" action=""> 
			<div id="tab_box_content2" class="tab_box_content" style="display:block;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr align="right" height="30">
                <td>&nbsp;</td>
                <td width="30"><span class="bc"><a href="#" onclick="addSelect1();toUpdate1()"></a></span></td>
                <td width="5"></td>
              </tr>
       	 </table>
         	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >				
				  <tr>						   
				  <td class="inquire_item6">单位：</td>
		       	<td class="inquire_form6">
		       	<input type="hidden" id="o1rg_sub_id" name="o1rg_sub_id" class="input_width" />					     
			      	<input type="text" id="o1rg_sub_id2" name="o1rg_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		       	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
		       	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
		       	<%} %>
		       	</td>
		         	<td class="inquire_item6">基层单位：</td>
		       	<td class="inquire_form6">
		       	 <input type="hidden" id="s1econd_org" name="s1econd_org" class="input_width" />
			    	  <input type="text" id="s1econd_org2" name="s1econd_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		       	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
		       	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2s()"/>
		       	<%} %>
		       	</td>  
				  </tr>	 
				  <tr>
				  <td class="inquire_item6">下属单位：</td>
			      	<td class="inquire_form6">
			      	<input type="hidden" id="p1articipants_ranges" name="p1articipants_ranges" value="" />
			     	<input type="hidden" id="c1reate_date" name="c1reate_date" value="" />
			      	<input type="hidden" id="c1reator" name="c1reator" value="" />
			      	<input type="hidden" id="b1sflag" name="b1sflag" value="0" />
			      	<input type="hidden" id="d1rill_no" name="d1rill_no"   />
			    	<input type="hidden" id="p1roject_no" name="p1roject_no" value="" />
			       	<input type="hidden" id="t1hird_org" name="t1hird_org" class="input_width" />
			      	<input type="text" id="t1hird_org2" name="t1hird_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3s()"/>
			      	<%}%>
			     </td> 
			     <td class="inquire_item6"><font color="red">*</font>演练时间：</td>
				    <td class="inquire_form6"><input type="text" id="d1rilling_time" name="d1rilling_time" class="input_width"    />
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(d1rilling_time,tributton1);" />&nbsp;
				    </td>
				  </tr>
					<tr>								 
					   <td class="inquire_item6"><font color="red">*</font>应急预案：</td>
					    <td class="inquire_form6" colspan="3" >
					    <input type="text"    id="e1mergency_plan"  style="width:760px;" name="e1mergency_plan" value="" /> 
					    </td>
			 		   	    
					</tr>	
					<tr>								 
					   <td class="inquire_item6">参加人员范围：</td>
					    <td class="inquire_form6" colspan="3" >
					    <input type="checkbox"    id="p1articipants_range1"   name="p1articipants_range"  onclick="setDisAttr(this);"  value="全体员工" />全体员工
					    <input type="checkbox"    id="p1articipants_range2"   name="p1articipants_range"  onclick="setDisAttr1(this);"  value="应急人员" />应急人员
					    <input type="checkbox"    id="p1articipants_range3"   name="p1articipants_range"  onclick="setDisAttr2(this);"  value="直线管理人员" />直线管理人员
					    <input type="checkbox"    id="p1articipants_range4"   name="p1articipants_range"  onclick="setDisAttr3(this);"  value="HSE管理人员" />HSE管理人员
					    <input type="checkbox"    id="p1articipants_range5"   name="p1articipants_range"  onclick="setDisAttr4(this);"  value="新上岗转岗人员" />新上岗转岗人员
					    <input type="checkbox"    id="p1articipants_range6"   name="p1articipants_range"  onclick="setDisAttr5(this);"  value="外来人员" />外来人员
					    </td>
			 		   	    
					</tr>			 
				    <tr>	 
			 		    <td class="inquire_item6"><font color="red">*</font>演练类别：</td>
					    <td class="inquire_form6"> 
					    <select id="p1ractice_category" name="p1ractice_category" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >实战演练</option>
					       <option value="2" >桌面演练</option>  
						</select> 
					    </td>					   	      	
					    <td class="inquire_item6"><font color="red">*</font>参加人员数量 ：</td>
					    <td class="inquire_form6">
					    <input type="text" id="n1umber_participants" name="n1umber_participants" class="input_width"  onkeypress="return on_key_press_int(this)"   />    					    
					    </td>			
				  </tr>		
				  <tr>	
				   <td class="inquire_item6"><font color="red">*</font>主办部门 ：</td>
				    <td class="inquire_form6"><input type="text" id="h1ost_department" name="h1ost_department" class="input_width"    />
				    </td> 
			     </tr>	 
				</table>  
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>演练过程记录：</td> 					   
				    <td class="inquire_form6" colspan="4" align="center" ><textarea  style="width:770px;height:60px;" id="d1rilling_process_record" name="d1rilling_process_record"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>效果评价：</td> 					   
				    <td class="inquire_form6" colspan="4" align="center" ><textarea  style="width:770px;height:60px;" id="e1ffect_evaluation" name="e1ffect_evaluation"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>问题整改：</td> 					   
				    <td class="inquire_form6" colspan="4" align="center" ><textarea  style="width:770px;height:60px;" id="p1roblem_corrected" name="p1roblem_corrected"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				</table>
			   </div>
				<div id="tab_box_contents2" class="tab_box_content" style="display:none;">
			   <iframe width="100%" height="100%" name="attachement1" id="attachement1" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
			   </div>
			</form>
		</div>			
</div>

<div id="type3" style="display:block;">
	<div id="tag-container_3">
	  <ul id="tags" class="tags">   			  
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">应急培训</a></li>
	    <li  id="tag3_1"><a href="#" onclick="getTab3(1)">应急演练</a></li>
	    <li  id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
	   </ul>
	</div>
	
	<div id="tab_box" class="tab_box">
	<form name="form" id="form2"  method="post" action=""> 
		<div id="tab_box_content0" class="tab_box_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr align="right" height="30">
         <td>&nbsp;</td>
         <td width="30"><span class="bc"><a href="#" onclick="addSelect2();toUpdate2()"></a></span></td>
         <td width="5"></td>
       </tr>
	 </table>
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
			  <tr>						   
			  <td class="inquire_item6">单位：</td>
		   	<td class="inquire_form6">
		   	<input type="hidden" id="o2rg_sub_id" name="o2rg_sub_id" class="input_width" />					     
		     	<input type="text" id="o2rg_sub_id2" name="o2rg_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		   	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
		   	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="s2electOrgs()"/>
		   	<%} %>
		   	</td>
		     	<td class="inquire_item6">基层单位：</td>
		   	<td class="inquire_form6">
		   	 <input type="hidden" id="s2econd_org" name="s2econd_org" class="input_width" />
		   	  <input type="text" id="s2econd_org2" name="s2econd_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		   	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
		   	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="s2electOrg2s()"/>
		   	<%} %>
		   	</td> 
			    <td class="inquire_item6">下属单位：</td>
			      	<td class="inquire_form6">
			      	<input type="hidden" id="p2articipants_ranges" name="p2articipants_ranges" value="" />
			    	<input type="hidden" id="c2reate_date" name="c2reate_date" value="" />
			      	<input type="hidden" id="c2reator" name="c2reator" value="" />
			      	<input type="hidden" id="b2sflag" name="b2sflag" value="0" />
			    	<input type="hidden" id="p2roject_no" name="p2roject_no" value="" />
			      	<input type="hidden" id="train_drill_no" name="train_drill_no"   />
			       	<input type="hidden" id="t2hird_org" name="t2hird_org" class="input_width" />
			      	<input type="text" id="t2hird_org2" name="t2hird_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="s2electOrg3s()"/>
			      	<%}%>
			     </td> 
			  </tr>	 
			  
				<tr>								 
				   <td class="inquire_item6">参加人员范围：</td>
				    <td class="inquire_form6"  colspan="5" >
				    <input type="checkbox"    id="p2articipants_range1"   name="p2articipants_range"  onclick="setDisAttr(this);"  value="全体员工" />全体员工
				    <input type="checkbox"    id="p2articipants_range2"   name="p2articipants_range"  onclick="setDisAttr1(this);"  value="应急人员" />应急人员
				    <input type="checkbox"    id="p2articipants_range3"   name="p2articipants_range"  onclick="setDisAttr2(this);"  value="直线管理人员" />直线管理人员
				    <input type="checkbox"    id="p2articipants_range4"   name="p2articipants_range"  onclick="setDisAttr3(this);"  value="HSE管理人员" />HSE管理人员
				    <input type="checkbox"    id="p2articipants_range5"   name="p2articipants_range"  onclick="setDisAttr4(this);"  value="新上岗转岗人员" />新上岗转岗人员
				    <input type="checkbox"    id="p2articipants_range6"   name="p2articipants_range"  onclick="setDisAttr5(this);"  value="外来人员" />外来人员
				    </td>
				   	    
				</tr>			 
			  <tr>	
				  <td class="inquire_item6"><font color="red">*</font>参加人员数量：</td>
				    <td class="inquire_form6"><input type="text" id="n2umber_participants" name="n2umber_participants" class="input_width"  onkeypress="return on_key_press_int(this)"  />
				    </td>
				    <td class="inquire_item6"><font color="red">*</font>学时：</td>
				    <td class="inquire_form6"> 
				    <input type="text" id="s2chool" name="s2chool" class="input_width"   onkeypress="return on_key_press_int(this)" />    	个	
				    </td>					   	      	
				    <td class="inquire_item6"><font color="red">*</font>培训开始时间 ：</td>
				    <td class="inquire_form6">
				    <input type="text" id="t2raining_start_time" name="t2raining_start_time" class="input_width"     />    					    
				    </td>			
			  </tr>		
			  <tr>	
			   <td class="inquire_item6">主办部门 ：</td>
			    <td class="inquire_form6"><input type="text" id="h2ost_department" name="h2ost_department" class="input_width"   />
			    </td>
			    <td class="inquire_item6">培训小结：</td>
			    <td class="inquire_form6"> 
			    <input type="text" id="t2raining_summary" name="t2raining_summary" class="input_width"   />    		
			    </td>		 
		    </tr>		 
			</table> 
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
			  <tr>
			    <td class="inquire_item6"><font color="red">*</font>培训内容：</td> 					   
			    <td class="inquire_form6" colspan="9" align="center" ><textarea  style="width:820px;height:50px;" id="t2raining_content" name="t2raining_content"   class="textarea" ></textarea></td>
			    <td class="inquire_item6"> </td> 				 
			  </tr>						  
			</table> 
		   </div>
		   <div id="tab_box_content1" class="tab_box_content">
		   <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr align="right" height="30">
            <td>&nbsp;</td>
            <td width="30"><span class="bc"><a href="#" onclick="toUpdate2()"></a></span></td>
            <td width="5"></td>
          </tr>
     	 </table> 
		     	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					<tr>								 
					   <td class="inquire_item6"><font color="red">*</font>应急预案：</td>
					    <td class="inquire_form6" colspan="3" >
					    <input type="text"    id="e2mergency_plan"  style="width:720px;" name="e2mergency_plan" value="" /> 
					    </td> 
					</tr>	 
				  <tr>	
					  <td class="inquire_item6"><font color="red">*</font>演练时间：</td>
					    <td class="inquire_form6"><input type="text" id="d2rilling_time"  name="d2rilling_time" class="input_width"  />
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(d2rilling_time,tributton2);" />&nbsp;
					    </td>
			 		    <td class="inquire_item6"><font color="red">*</font>演练类别：</td>
					    <td class="inquire_form6"> 
					    <select id="p2ractice_category" name="p2ractice_category" style="width:210px;" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >实战演练</option>
					       <option value="2" >桌面演练</option>  
						</select> 
					    </td>					   	      	
					   	
				  </tr>		 
				</table>  
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>演练过程记录：</td> 					   
				    <td class="inquire_form6" colspan="5" align="left" ><textarea  style="width:750px;height:50px;" id="d2rilling_process_record" name="d2rilling_process_record"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>效果评价：</td> 					   
				    <td class="inquire_form6" colspan="5" align="left" ><textarea  style="width:750px;height:50px;" id="e2ffect_evaluation" name="e2ffect_evaluation"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>
				    <td class="inquire_item6">问题整改：</td> 					   
				    <td class="inquire_form6" colspan="5" align="left" ><textarea  style="width:750px;height:50px;" id="p2roblem_corrected" name="p2roblem_corrected"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				</table> 
			</div>
			   <div id="tab_box_content2" class="tab_box_content">
			   <iframe width="100%" height="100%" name="attachement2" id="attachement2" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
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
	 
	function getTab1(index) {  
	  var selectedTag0 = document.getElementById("tag3");
	  var selectedTabBox0 = document.getElementById("tab_box_content");
	  var selectedTag1 = document.getElementById("tag3s");
	  var selectedTabBox1 = document.getElementById("tab_box_contents");
	 
	  if (index == '1'){
	    selectedTag1.className ="selectTag";
	    selectedTabBox1.style.display="block";
	    selectedTag0.className ="";
	    selectedTabBox0.style.display="none";
 
	  }
	   if (index == '0'){
	    selectedTag0.className ="selectTag";
	    selectedTabBox0.style.display="block";
	    selectedTag1.className ="";
	    selectedTabBox1.style.display="none";
	  
	  }
 
	}
	
	function getTab2(index) {  
		  var selectedTag0 = document.getElementById("tag32");
		  var selectedTabBox0 = document.getElementById("tab_box_content2");
		  var selectedTag1 = document.getElementById("tag3s2");
		  var selectedTabBox1 = document.getElementById("tab_box_contents2");
		 
		  if (index == '1'){
		    selectedTag1.className ="selectTag";
		    selectedTabBox1.style.display="block";
		    selectedTag0.className ="";
		    selectedTabBox0.style.display="none";
	 
		  }
		   if (index == '0'){
		    selectedTag0.className ="selectTag";
		    selectedTabBox0.style.display="block";
		    selectedTag1.className ="";
		    selectedTabBox1.style.display="none";
		  
		  }
	 
		}
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("");
		}else if(isProject=="2"){
			querySqlAdd = "and project_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form'; 
		cruConfig.queryStr = " select * from (select  cn.training_no as pk_id,cn.training_start_time as s_time,to_date('','')d_time,'' p_category,'' e_plan,ion.org_abbreviation as org_name,decode(cn.spare1,'1','培训') as if_type,cn.spare1,  oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name,cn.org_sub_id,cn.second_org,cn.third_org,cn.project_no ,cn.modifi_date,cn.bsflag from BGP_EMERGENCY_TRAINING cn    left  join comm_org_subjection os1     on cn.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left join comm_org_subjection os2     on cn.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on cn.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id    where cn.bsflag = '0' " +
		"  union " +
		"  select tr.drill_no as pk_id,'' s_time,tr.drilling_time as d_time,decode(tr.practice_category,'1','实战演练','2','桌面演练')as p_category,tr.emergency_plan as e_plan,  ion.org_abbreviation as org_name, decode(tr.spare1,'2','演练') as if_type,tr.spare1, oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name,tr.org_sub_id,tr.second_org,tr.third_org,tr.project_no,tr.modifi_date,tr.bsflag from BGP_EMERGENCY_DRILL tr    left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0' " +
		"  union " +
		"  select tw.train_drill_no as pk_id,tw.training_start_time as  s_time,tw.drilling_time as d_time,decode(tw.practice_category,'1','实战演练','2','桌面演练') as p_category,tw.emergency_plan as e_plan,  ion.org_abbreviation as org_name, decode(tw.spare1,'3','培训和演练') as if_type,tw.spare1, oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name,tw.org_sub_id,tw.second_org,tw.third_org,tw.project_no,tw.modifi_date,tw.bsflag  from BGP_TRAINING_DRILL tw    left  join comm_org_subjection os1     on tw.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tw.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tw.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id    where tw.bsflag = '0') where bsflag='0' "+querySqlAdd+" order by modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/trainingAndDrills.jsp";
		queryData(1);
 
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl ="/hse/hseOptionPage/preparednessAndResponse/trainingAndDrills.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	function on_key_press_int(obj)
	{
		var keycode = event.keyCode;
		if(keycode > 57 || keycode < 46 || keycode==47)
		{
			return false;
		}else{
			return true;
		}
	}
	// 简单查询
	function simpleSearch(){
			var changeName = document.getElementById("changeName").value;
				if(changeName!=''&& changeName!=null){
					var isProject = "<%=isProject%>";
					var querySqlAdd = "";
					if(isProject=="1"){
						querySqlAdd = getMultipleSql2("");
					}else if(isProject=="2"){
						querySqlAdd = "and project_no='<%=user.getProjectInfoNo()%>'";
					}
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select * from (select tr.drill_no as pk_id,'' s_time,tr.drilling_time as d_time,decode(tr.practice_category,'1','实战演练','2','桌面演练')as p_category,tr.emergency_plan as e_plan,  ion.org_abbreviation as org_name, decode(tr.spare1,'2','演练') as if_type,tr.spare1, oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name,tr.org_sub_id,tr.second_org,tr.third_org,tr.project_no ,tr.modifi_date,tr.bsflag  from BGP_EMERGENCY_DRILL tr   left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'     left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'  and tr.practice_category='"+ changeName+"'" +
					"  union " +
					"  select tw.train_drill_no as pk_id,tw.training_start_time as  s_time,tw.drilling_time as d_time,decode(tw.practice_category,'1','实战演练','2','桌面演练') as p_category,tw.emergency_plan as e_plan,  ion.org_abbreviation as org_name, decode(tw.spare1,'3','培训和演练') as if_type,tw.spare1, oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name,tw.org_sub_id,tw.second_org,tw.third_org,tw.project_no ,tw.modifi_date,tw.bsflag  from BGP_TRAINING_DRILL tw   left  join comm_org_subjection os1     on tw.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tw.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tw.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left   join comm_org_information ion    on ion.org_id = ose.org_id   where tw.bsflag = '0' and tw.practice_category='"+ changeName +"' ) where bsflag='0' "+querySqlAdd+" order by modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/trainingAndDrills.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
	 
	function loadDataDetail(ids){
    	 var tempa = ids.split(',');		
 	    ids =  tempa[0];
 	    var ifType=tempa[1];
 	    if(ifType == '1'){
 		    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
 	 		 document.getElementById("type1").style.display="block";
 	 		 document.getElementById("type2").style.display="none";
	 		 document.getElementById("type3").style.display="none";
	 		var querySql = "";
			var queryRet = null;
			var  datas =null;					
			querySql = " select  tr.project_no, tr.org_sub_id, tr.training_no,tr.training_content,tr.participants_range,tr.number_participants,tr.school,tr.training_start_time,tr.host_department, tr.training_summary,tr.training_attendance ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EMERGENCY_TRAINING tr   left    join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'  and tr.training_no='"+ ids +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 		   
		             document.getElementsByName("training_no")[0].value=datas[0].training_no; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;	     
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	  
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	 
		   		    document.getElementsByName("project_no")[0].value=datas[0].project_no;	
		    		 document.getElementsByName("participants_ranges")[0].value=datas[0].participants_range; 
		    		 var listValues=datas[0].participants_range; 
		    		 var check_unit_orgs = listValues.split(';'); 
		    		 var certificate = document.getElementsByName("participants_range");			 		
					    for(var i=0;i<check_unit_orgs.length;i++)					        {
					    	var check_unit_org = listValues.split(';')[i]; 	
			  		    	for(var j=0;j<certificate.length;j++){
			  				if(certificate[j].value==check_unit_org){				  					
			  					certificate[j].checked=true;
			  					if(check_unit_org =="全体员工"){
			  						certificate[0].disabled   =  false;
			  						certificate[1].disabled   =  true;
			  						certificate[2].disabled   =  true;
			  						certificate[3].disabled   =  true;
			  						certificate[4].disabled   =  true;
			  						certificate[5].disabled   =  true; 
			  					}else{
			  						certificate[0].disabled   =  true;
			  						certificate[1].disabled   =  false;
			  						certificate[2].disabled   =  false;
			  						certificate[3].disabled   =  false;
			  						certificate[4].disabled   =  false;
			  						certificate[5].disabled   =  false; 
			  						
			  					}
			  				}
		  				 
			  		    	}
		  		       	}      
		    		  document.getElementsByName("training_content")[0].value=datas[0].training_content;
		    		  document.getElementsByName("number_participants")[0].value=datas[0].number_participants;			
		    		  document.getElementsByName("school")[0].value=datas[0].school;			
		    		  document.getElementsByName("training_start_time")[0].value=datas[0].training_start_time;
		    		  document.getElementsByName("host_department")[0].value=datas[0].host_department;
		    		  document.getElementsByName("training_summary")[0].value=datas[0].training_summary;	
		    			 
				}					
			
		    	}		
			
 	    }
 	    
 	    
 	   if(ifType == '2'){
		    document.getElementById("attachement1").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
	 		 document.getElementById("type1").style.display="none";
	 		 document.getElementById("type2").style.display="block";
	 		 document.getElementById("type3").style.display="none";
	 		var querySql = "";
			var queryRet = null;
			var  datas =null;		 
			querySql = " select  tr.project_no,tr.org_sub_id,  tr.drill_no,tr.emergency_plan,tr.drilling_time,tr.practice_category,tr.participants_range,tr.number_participants,tr.host_department,tr.drilling_process_record,  tr.effect_evaluation,tr.problem_corrected,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_EMERGENCY_DRILL tr   left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0'  and tr.drill_no='"+ ids +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 		   
		             document.getElementsByName("d1rill_no")[0].value=datas[0].drill_no; 
		    		 document.getElementsByName("b1sflag")[0].value=datas[0].bsflag;	     
		  		     document.getElementsByName("c1reate_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("c1reator")[0].value=datas[0].creator;	  
		    		 document.getElementsByName("o1rg_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("o1rg_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("s1econd_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("s1econd_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("t1hird_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("t1hird_org2")[0].value=datas[0].third_org_name;	  
		    		 document.getElementsByName("p1articipants_ranges")[0].value=datas[0].participants_range; 
		   		  document.getElementsByName("p1roject_no")[0].value=datas[0].project_no;	
		    		 var listValues=datas[0].participants_range; 
		    		 var check_unit_orgs = listValues.split(';'); 
		    		 var certificate = document.getElementsByName("p1articipants_range");			 		
					    for(var i=0;i<check_unit_orgs.length;i++)					        {
					    	var check_unit_org = listValues.split(';')[i]; 	
			  		    	for(var j=0;j<certificate.length;j++){
			  				if(certificate[j].value==check_unit_org){				  					
			  					certificate[j].checked=true;
			  					if(check_unit_org =="全体员工"){
			  						certificate[0].disabled   =  false;
			  						certificate[1].disabled   =  true;
			  						certificate[2].disabled   =  true;
			  						certificate[3].disabled   =  true;
			  						certificate[4].disabled   =  true;
			  						certificate[5].disabled   =  true; 
			  					}else{
			  						certificate[0].disabled   =  true;
			  						certificate[1].disabled   =  false;
			  						certificate[2].disabled   =  false;
			  						certificate[3].disabled   =  false;
			  						certificate[4].disabled   =  false;
			  						certificate[5].disabled   =  false; 
			  						
			  					}
			  				}
		  				 
			  		    	}
		  		       	}
			  	 				     
					 document.getElementsByName("e1mergency_plan")[0].value=datas[0].emergency_plan;
					 document.getElementsByName("d1rilling_time")[0].value=datas[0].drilling_time;		
					 document.getElementsByName("p1ractice_category")[0].value=datas[0].practice_category;	
					 document.getElementsByName("n1umber_participants")[0].value=datas[0].number_participants;		
					 document.getElementsByName("h1ost_department")[0].value=datas[0].host_department;	
				 	 document.getElementsByName("d1rilling_process_record")[0].value=datas[0].drilling_process_record;		
					 document.getElementsByName("e1ffect_evaluation")[0].value=datas[0].effect_evaluation;		
					 document.getElementsByName("p1roblem_corrected")[0].value=datas[0].problem_corrected;
		    			 
				}					
			
		    	}	 
	 		 
 	      }
 	    
 	   if(ifType == '3'){
		    document.getElementById("attachement2").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
	 		 document.getElementById("type1").style.display="none";
	 		 document.getElementById("type2").style.display="none";
	 		 document.getElementById("type3").style.display="block";
	 		 
	 		var querySql = "";
			var queryRet = null;
			var  datas =null;		 
			querySql = " select  tr.project_no,tr.org_sub_id,  tr.train_drill_no,tr.training_content,tr.participants_range,tr.number_participants,tr.school,tr.training_start_time   ,tr.host_department,tr.training_summary,tr.training_attendance ,tr.emergency_plan,tr.drilling_time,tr.practice_category,tr.drilling_process_record,tr.effect_evaluation,  tr.problem_corrected,tr.drill_attendance ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_TRAINING_DRILL tr   left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left join comm_org_information ion    on ion.org_id = ose.org_id      where tr.bsflag = '0'  and tr.train_drill_no='"+ ids +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 		   
		             document.getElementsByName("train_drill_no")[0].value=datas[0].train_drill_no; 
		    		 document.getElementsByName("b2sflag")[0].value=datas[0].bsflag;	     
		  		     document.getElementsByName("c2reate_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("c2reator")[0].value=datas[0].creator;	  
		    		 document.getElementsByName("o2rg_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("o2rg_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("s2econd_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("s2econd_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("t2hird_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("t2hird_org2")[0].value=datas[0].third_org_name;	
		   		     document.getElementsByName("p2roject_no")[0].value=datas[0].project_no;	
		    		 document.getElementsByName("p2articipants_ranges")[0].value=datas[0].participants_range; 
		    		 
		    		 var listValues=datas[0].participants_range; 
		    		 var check_unit_orgs = listValues.split(';'); 
		    		 var certificate = document.getElementsByName("p2articipants_range");			 		
					    for(var i=0;i<check_unit_orgs.length;i++)					        {
					    	var check_unit_org = listValues.split(';')[i]; 	
			  		    	for(var j=0;j<certificate.length;j++){
			  				if(certificate[j].value==check_unit_org){				  					
			  					certificate[j].checked=true;
			  					if(check_unit_org =="全体员工"){
			  						certificate[0].disabled   =  false;
			  						certificate[1].disabled   =  true;
			  						certificate[2].disabled   =  true;
			  						certificate[3].disabled   =  true;
			  						certificate[4].disabled   =  true;
			  						certificate[5].disabled   =  true; 
			  					}else{
			  						certificate[0].disabled   =  true;
			  						certificate[1].disabled   =  false;
			  						certificate[2].disabled   =  false;
			  						certificate[3].disabled   =  false;
			  						certificate[4].disabled   =  false;
			  						certificate[5].disabled   =  false; 
			  						
			  					}
			  				}
		  				 
			  		    	}
		  		       	}
					      document.getElementsByName("t2raining_content")[0].value=datas[0].training_content;
			    		  document.getElementsByName("n2umber_participants")[0].value=datas[0].number_participants;			
			    		  document.getElementsByName("s2chool")[0].value=datas[0].school;			
			    		  document.getElementsByName("t2raining_start_time")[0].value=datas[0].training_start_time;
			    		  document.getElementsByName("h2ost_department")[0].value=datas[0].host_department;
			    		  document.getElementsByName("t2raining_summary")[0].value=datas[0].training_summary;	 
						 document.getElementsByName("e2mergency_plan")[0].value=datas[0].emergency_plan;
						 document.getElementsByName("d2rilling_time")[0].value=datas[0].drilling_time;		
						 document.getElementsByName("p2ractice_category")[0].value=datas[0].practice_category;	 
					 	 document.getElementsByName("d2rilling_process_record")[0].value=datas[0].drilling_process_record;		
						 document.getElementsByName("e2ffect_evaluation")[0].value=datas[0].effect_evaluation;		
						 document.getElementsByName("p2roblem_corrected")[0].value=datas[0].problem_corrected;
		    			 
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
 
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePages.jsp?projectInfoNo=<%=projectInfoNo%>&isProject=<%=isProject%>",'1024:800');
		
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
		    ids =  tempa[0];
		    var ifType=tempa[1];
		 
		    if(ifType == '1'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePage1s.jsp?projectInfoNo=<%=projectInfoNo%>&training_no="+ids); }
		    if(ifType == '2'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePage2s.jsp?projectInfoNo=<%=projectInfoNo%>&drill_no="+ids,'1024:800'); }
		    if(ifType == '3'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePage3s.jsp?projectInfoNo=<%=projectInfoNo%>&train_drill_no="+ids,'1024:800'); }
	}
	function toEdit(){   
	  	ids = getSelIds('chx_entity_id'); 
   	    var tempa = ids.split(',');		
	    ids =  tempa[0];
	    var ifType=tempa[1];
	  
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    
	    if(ifType == '1'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePage1s.jsp?projectInfoNo=<%=projectInfoNo%>&training_no="+ids); }
	    if(ifType == '2'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePage2s.jsp?projectInfoNo=<%=projectInfoNo%>&drill_no="+ids,'1024:800'); }
	    if(ifType == '3'){ 	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/choosePage3s.jsp?projectInfoNo=<%=projectInfoNo%>&train_drill_no="+ids,'1024:800'); }
	    
	} 
	
	 
	function toDelete(){ 
		var ids = getSelIds('chx_entity_id'); 
   	    var tempa = ids.split(',');		
	    ids =  tempa[0];
	    var ifType=tempa[1]; 

	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    if(ifType == '1'){ 
	    	   deleteEntities("update BGP_EMERGENCY_TRAINING e set e.bsflag='1' where e.TRAINING_NO='"+ids+"'");
	    }
	    if(ifType == '2'){ 
	    	  deleteEntities("update BGP_EMERGENCY_DRILL e set e.bsflag='1' where e.DRILL_NO='"+ids+"'");
	    }
	    if(ifType == '3'){ 
	    	  deleteEntities("update BGP_TRAINING_DRILL e set e.bsflag='1' where e.TRAIN_DRILL_NO='"+ids+"'");
	    }
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/hse_searchT.jsp?isProject=<%=isProject%>");
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

	 
	 function selectOrgs(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
		    if(teamInfo.fkValue!=""){
		    	document.getElementById("o1rg_sub_id").value = teamInfo.fkValue;
		        document.getElementById("o1rg_sub_id2").value = teamInfo.value;
		    }
		}

		function selectOrg2s(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var second = document.getElementById("o1rg_sub_id").value;
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
				    	 document.getElementById("s1econd_org").value = teamInfo.fkValue; 
				        document.getElementById("s1econd_org2").value = teamInfo.value;
					}
		   
		}

		function selectOrg3s(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var third = document.getElementById("s1econd_org").value;
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
				    	 document.getElementById("t1hird_org").value = teamInfo.fkValue;
				        document.getElementById("t1hird_org2").value = teamInfo.value;
					}
		}


		function s2electOrgs(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
		    if(teamInfo.fkValue!=""){
		    	document.getElementById("o2rg_sub_id").value = teamInfo.fkValue;
		        document.getElementById("o2rg_sub_id2").value = teamInfo.value;
		    }
		}

		function s2electOrg2s(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var second = document.getElementById("o2rg_sub_id").value;
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
				    	 document.getElementById("s2econd_org").value = teamInfo.fkValue; 
				        document.getElementById("s2econd_org2").value = teamInfo.value;
					}
		   
		}

		function s2electOrg3s(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var third = document.getElementById("s2econd_org").value;
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
				    	 document.getElementById("t2hird_org").value = teamInfo.fkValue;
				        document.getElementById("t2hird_org2").value = teamInfo.value;
					}
		}

		
		function addSelect(){ 
			   var certificate = document.getElementsByName("participants_range"); 
				var certificate_no = ""; 
				for(var i=0;i<certificate.length;i++){
					if(certificate[i].checked==true){
						certificate_no = certificate_no + certificate[i].value + ";";	
					}
				} 
				document.getElementsByName("participants_ranges")[0].value=certificate_no; 
			}

		function addSelect1(){ 
			   var certificate = document.getElementsByName("p1articipants_range");
				var certificate_no = "";
				for(var i=0;i<certificate.length;i++){
					if(certificate[i].checked==true){
						certificate_no = certificate_no + certificate[i].value + ";";	
					}
				} 
				document.getElementsByName("p1articipants_ranges")[0].value=certificate_no; 
			}

		function addSelect2(){ 
			   var certificate = document.getElementsByName("p2articipants_range");
				var certificate_no = "";
				for(var i=0;i<certificate.length;i++){
					if(certificate[i].checked==true){
						certificate_no = certificate_no + certificate[i].value + ";";	
					}
				} 
				document.getElementsByName("p2articipants_ranges")[0].value=certificate_no; 
			}

		function checkJudge(){
	 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
			var second_org = document.getElementsByName("second_org2")[0].value;			
			var third_org = document.getElementsByName("third_org2")[0].value;			
			 
			var training_content = document.getElementsByName("training_content")[0].value;					
			var number_participants = document.getElementsByName("number_participants")[0].value;			
			var school = document.getElementsByName("school")[0].value;		
			var training_start_time = document.getElementsByName("training_start_time")[0].value;		
  
			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(training_content==""){
	 			alert("培训内容不能为空，请填写！");
	 			return true;
	 		}
	 		if(number_participants==""){
	 			alert("参加人员数量不能为空，请选择！");
	 			return true;
	 		}
	 		if(school==""){
	 			alert("学时不能为空，请填写！");
	 			return true;
	 		}
	 
			if(training_start_time==""){
	 			alert("培训开始时间不能为空，请填写！");
	 			return true;
	 		}
			 
	 		
	 		return false;
	 	}
		
		
		function toUpdate(){		
			var rowParams = new Array(); 
			var rowParam = {};	
			var training_no = document.getElementsByName("training_no")[0].value;	 
			  if(training_no !=null && training_no !=''){	 
					if(checkJudge()){
						return;
					}
					
			 		var training_no = document.getElementsByName("training_no")[0].value; 
					var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
					var bsflag = document.getElementsByName("bsflag")[0].value;
					var second_org = document.getElementsByName("second_org")[0].value;			
					var third_org = document.getElementsByName("third_org")[0].value;			
					var create_date = document.getElementsByName("create_date")[0].value;
						var creator = document.getElementsByName("creator")[0].value;		
						
					var participants_range = document.getElementsByName("participants_ranges")[0].value;
					var training_content = document.getElementsByName("training_content")[0].value;		
					var number_participants = document.getElementsByName("number_participants")[0].value;			
					var school = document.getElementsByName("school")[0].value;		
					var training_start_time = document.getElementsByName("training_start_time")[0].value;		
					var host_department = document.getElementsByName("host_department")[0].value;			
					var training_summary = document.getElementsByName("training_summary")[0].value;
					var project_no = document.getElementsByName("project_no")[0].value;						 
					
					 if(project_no !=null && project_no !=''){
							rowParam['project_no'] =project_no;	
						}else{
							rowParam['project_no'] ='<%=projectInfoNo%>';
						}
					rowParam['org_sub_id'] = org_sub_id;
					rowParam['second_org'] = second_org;
					rowParam['third_org'] = third_org;			 		
					rowParam['training_no'] = encodeURI(encodeURI(training_no));
					rowParam['participants_range'] = encodeURI(encodeURI(participants_range));
					rowParam['training_content'] = encodeURI(encodeURI(training_content));
					rowParam['number_participants'] = number_participants;		 		
					rowParam['school'] = school;
					rowParam['training_start_time'] = encodeURI(encodeURI(training_start_time));		
					rowParam['host_department'] = encodeURI(encodeURI(host_department));
					rowParam['training_summary'] = encodeURI(encodeURI(training_summary));
			 
					
				    rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] =create_date;
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;  
					rowParam['spare1'] = '1';  
					rowParams[rowParams.length] = rowParam; 
					var rows=JSON.stringify(rowParams);	 
					saveFunc("BGP_EMERGENCY_TRAINING",rows);	
					 refreshData();	 
				
			  }else{			  
				  alert("请先选中一条记录!");
			     	return;		
			  }
			  			
		}
	 
		function checkJudge1(){
	 		var org_sub_id = document.getElementsByName("o1rg_sub_id2")[0].value;
			var second_org = document.getElementsByName("s1econd_org2")[0].value;			
			var third_org = document.getElementsByName("t1hird_org2")[0].value;			
			 
			var emergency_plan = document.getElementsByName("e1mergency_plan")[0].value;
			var drilling_time = document.getElementsByName("d1rilling_time")[0].value;		
			var practice_category = document.getElementsByName("p1ractice_category")[0].value;				
			var number_participants = document.getElementsByName("n1umber_participants")[0].value;		
			var host_department = document.getElementsByName("h1ost_department")[0].value;	
	 		var drilling_process_record = document.getElementsByName("d1rilling_process_record")[0].value;		
			var effect_evaluation = document.getElementsByName("e1ffect_evaluation")[0].value;		
		  
			
	 		if(org_sub_id==""){
	 			document.getElementById("o1rg_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("s1econd_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("t1hird_org").value="";
	 		}
	 		if(emergency_plan==""){
	 			alert("应急预案不能为空，请填写！");
	 			return true;
	 		}
	 		if(drilling_time==""){
	 			alert("演练时间不能为空，请选择！");
	 			return true;
	 		}
	 		if(practice_category==""){
	 			alert("演练类别不能为空，请填写！");
	 			return true;
	 		}
	 
			if(number_participants==""){
	 			alert("参加人员数量不能为空，请填写！");
	 			return true;
	 		}
			

			if(host_department==""){
	 			alert("主办部门不能为空，请填写！");
	 			return true;
	 		}
			 

			if(drilling_process_record==""){
	 			alert("演练过程记录不能为空，请填写！");
	 			return true;
	 		}
			  
			if(effect_evaluation==""){
	 			alert("效果评价不能为空，请填写！");
	 			return true;
	 		}
			 
  
	 		return false;
	 	}
		
		
		function toUpdate1(){		
			var rowParams = new Array(); 
			var rowParam = {};	
			var d1rill_no = document.getElementsByName("d1rill_no")[0].value;	 
			  if(d1rill_no !=null && d1rill_no !=''){	
				  
					if(checkJudge1()){
						return;
					}
					 
				    var drill_no = document.getElementsByName("d1rill_no")[0].value; 
					var org_sub_id = document.getElementsByName("o1rg_sub_id")[0].value;
					var bsflag = document.getElementsByName("b1sflag")[0].value;
					var second_org = document.getElementsByName("s1econd_org")[0].value;			
					var third_org = document.getElementsByName("t1hird_org")[0].value;			
					var create_date = document.getElementsByName("c1reate_date")[0].value;
					var creator = document.getElementsByName("c1reator")[0].value;		
					
					var emergency_plan = document.getElementsByName("e1mergency_plan")[0].value;
					var drilling_time = document.getElementsByName("d1rilling_time")[0].value;		
					var practice_category = document.getElementsByName("p1ractice_category")[0].value;			
					var participants_range = document.getElementsByName("p1articipants_ranges")[0].value;		
					var number_participants = document.getElementsByName("n1umber_participants")[0].value;		
					var host_department = document.getElementsByName("h1ost_department")[0].value;	
			 		var drilling_process_record = document.getElementsByName("d1rilling_process_record")[0].value;		
					var effect_evaluation = document.getElementsByName("e1ffect_evaluation")[0].value;		
					var problem_corrected = document.getElementsByName("p1roblem_corrected")[0].value;
					var project_no = document.getElementsByName("p1roject_no")[0].value;						 
					
					 if(project_no !=null && project_no !=''){
							rowParam['project_no'] =project_no;	
						}else{
							rowParam['project_no'] ='<%=projectInfoNo%>';
						}
					rowParam['org_sub_id'] =org_sub_id;
					rowParam['second_org'] = second_org;
					rowParam['third_org'] = third_org;		
					
					rowParam['drill_no'] = encodeURI(encodeURI(drill_no));
					rowParam['emergency_plan'] = encodeURI(encodeURI(emergency_plan));
					rowParam['drilling_time'] = encodeURI(encodeURI(drilling_time));
					rowParam['practice_category'] = encodeURI(encodeURI(practice_category));
					rowParam['participants_range'] = encodeURI(encodeURI(participants_range));
					rowParam['number_participants'] = number_participants;		 		
					rowParam['host_department'] = encodeURI(encodeURI(host_department));
					rowParam['drilling_process_record'] = encodeURI(encodeURI(drilling_process_record));
					rowParam['effect_evaluation'] = encodeURI(encodeURI(effect_evaluation));		 		
					rowParam['problem_corrected'] = encodeURI(encodeURI(problem_corrected));
					
				    rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] =create_date;
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
					rowParam['spare1'] = '2';   
					
					rowParams[rowParams.length] = rowParam; 
					var rows=JSON.stringify(rowParams);	 
					saveFunc("BGP_EMERGENCY_DRILL",rows);	
					 refreshData();	
  
			  }else{			  
				  alert("请先选中一条记录!");
			     	return;		
			  }
			  			
		}
	 
		 
		function checkJudge2(){
	 		var org_sub_id = document.getElementsByName("o2rg_sub_id2")[0].value;
			var second_org = document.getElementsByName("s2econd_org2")[0].value;			
			var third_org = document.getElementsByName("t2hird_org2")[0].value;			
			 
			var emergency_plan = document.getElementsByName("e2mergency_plan")[0].value;
			var drilling_time = document.getElementsByName("d2rilling_time")[0].value;		
			var practice_category = document.getElementsByName("p2ractice_category")[0].value;				
			var number_participants = document.getElementsByName("n2umber_participants")[0].value;		
			var host_department = document.getElementsByName("h2ost_department")[0].value;	
	 		var drilling_process_record = document.getElementsByName("d2rilling_process_record")[0].value;		
			var effect_evaluation = document.getElementsByName("e2ffect_evaluation")[0].value;		
		   
			var training_content = document.getElementsByName("t2raining_content")[0].value;					
			var number_participants = document.getElementsByName("n2umber_participants")[0].value;			
			var school = document.getElementsByName("s2chool")[0].value;		
			var training_start_time = document.getElementsByName("t2raining_start_time")[0].value;		
  
		 
	 		if(org_sub_id==""){
	 			document.getElementById("o2rg_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("s2econd_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("t2hird_org").value="";
	 		}
			
	 		if(training_content==""){
	 			alert("培训内容不能为空，请填写！");
	 			return true;
	 		}
	 		if(number_participants==""){
	 			alert("参加人员数量不能为空，请选择！");
	 			return true;
	 		}
	 		if(school==""){
	 			alert("学时不能为空，请填写！");
	 			return true;
	 		}
	 
			if(training_start_time==""){
	 			alert("培训开始时间不能为空，请填写！");
	 			return true;
	 		}
			 
	 
	 		if(emergency_plan==""){
	 			alert("应急预案不能为空，请填写！");
	 			return true;
	 		}
	 		if(drilling_time==""){
	 			alert("演练时间不能为空，请选择！");
	 			return true;
	 		}
	 		if(practice_category==""){
	 			alert("演练类别不能为空，请填写！");
	 			return true;
	 		}
	 
			if(number_participants==""){
	 			alert("参加人员数量不能为空，请填写！");
	 			return true;
	 		}
			

			if(host_department==""){
	 			alert("主办部门不能为空，请填写！");
	 			return true;
	 		}
			 

			if(drilling_process_record==""){
	 			alert("演练过程记录不能为空，请填写！");
	 			return true;
	 		}
			  
			if(effect_evaluation==""){
	 			alert("效果评价不能为空，请填写！");
	 			return true;
	 		}
			 
  
	 		return false;
	 	}
		
		
		 
		function toUpdate2(){		
			var rowParams = new Array(); 
			var rowParam = {};	
			var train_drill_no = document.getElementsByName("train_drill_no")[0].value;	 
			  if(train_drill_no !=null && train_drill_no !=''){	 
				  
					if(checkJudge2()){
						return;
					}
					
			 		var train_drill_no = document.getElementsByName("train_drill_no")[0].value; 
					var org_sub_id = document.getElementsByName("o2rg_sub_id")[0].value;
					var bsflag = document.getElementsByName("b2sflag")[0].value;
					var second_org = document.getElementsByName("s2econd_org")[0].value;			
					var third_org = document.getElementsByName("t2hird_org")[0].value;			
					var create_date = document.getElementsByName("c2reate_date")[0].value;
					var creator = document.getElementsByName("c2reator")[0].value;		
					
					var participants_range = document.getElementsByName("p2articipants_ranges")[0].value;
					var training_content = document.getElementsByName("t2raining_content")[0].value;		
					var number_participants = document.getElementsByName("n2umber_participants")[0].value;			
					var school = document.getElementsByName("s2chool")[0].value;		
					var training_start_time = document.getElementsByName("t2raining_start_time")[0].value;		
					var host_department = document.getElementsByName("h2ost_department")[0].value;			
					var training_summary = document.getElementsByName("t2raining_summary")[0].value;
					
					var emergency_plan = document.getElementsByName("e2mergency_plan")[0].value;
					var drilling_time = document.getElementsByName("d2rilling_time")[0].value;		
					var practice_category = document.getElementsByName("p2ractice_category")[0].value;	
			 		var drilling_process_record = document.getElementsByName("d2rilling_process_record")[0].value;		
					var effect_evaluation = document.getElementsByName("e2ffect_evaluation")[0].value;		
					var problem_corrected = document.getElementsByName("p2roblem_corrected")[0].value; 
					var project_no = document.getElementsByName("p2roject_no")[0].value;						 
					
					 if(project_no !=null && project_no !=''){
							rowParam['project_no'] =project_no;	
						}else{
							rowParam['project_no'] ='<%=projectInfoNo%>';
						}
					rowParam['org_sub_id'] = org_sub_id;
					rowParam['second_org'] = second_org;
					rowParam['third_org'] = third_org;			 	
					
					rowParam['train_drill_no'] = encodeURI(encodeURI(train_drill_no));
					rowParam['participants_range'] = encodeURI(encodeURI(participants_range));
					rowParam['training_content'] = encodeURI(encodeURI(training_content));
					rowParam['number_participants'] = number_participants;		 		
					rowParam['school'] = school;
					rowParam['training_start_time'] = encodeURI(encodeURI(training_start_time));		
					rowParam['host_department'] = encodeURI(encodeURI(host_department));
					rowParam['training_summary'] = encodeURI(encodeURI(training_summary)); 
					rowParam['emergency_plan'] = encodeURI(encodeURI(emergency_plan));
					rowParam['drilling_time'] = encodeURI(encodeURI(drilling_time));
					rowParam['practice_category'] = encodeURI(encodeURI(practice_category)); 
					rowParam['drilling_process_record'] = encodeURI(encodeURI(drilling_process_record));
					rowParam['effect_evaluation'] = encodeURI(encodeURI(effect_evaluation));		 		
					rowParam['problem_corrected'] = encodeURI(encodeURI(problem_corrected));
			 	 
				    rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] =create_date;
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;  
					rowParam['spare1'] = '3';  
					rowParams[rowParams.length] = rowParam; 
					var rows=JSON.stringify(rowParams);	 
					saveFunc("BGP_TRAINING_DRILL",rows);	
					 refreshData();	
	  
			  }else{			  
				  alert("请先选中一条记录!");
			     	return;		
			  }
			  			
		}
		 
		function  setDisAttr(chkObj){  
			  var   chks=document.getElementsByName(chkObj.name);     
				if(chks[0].checked ==true){
					  chks[0].disabled   =  false;
					  chks[1].disabled   =  true;
					  chks[2].disabled   =  true;
					  chks[3].disabled   =  true;
					  chks[4].disabled   =  true;
					  chks[5].disabled   =  true;
				}
				if(chks[0].checked ==false){ 
					  chks[0].disabled   =  false;
					  chks[1].disabled   =  false;
					  chks[2].disabled   =  false;
					  chks[3].disabled   =  false;
					  chks[4].disabled   =  false;
					  chks[5].disabled   =  false; 
				}
					   
		  } 

		function   setDisAttr1(chkObj){  
			  var   chks=document.getElementsByName(chkObj.name);     
				if(chks[1].checked ==true){
					  chks[0].disabled   =  true;
					  chks[1].disabled   =  false;
					  chks[2].disabled   =  false;
					  chks[3].disabled   =  false;
					  chks[4].disabled   =  false;
					  chks[5].disabled   =  false;
				}
				if(chks[1].checked ==false){ 
					if(chks[2].checked ==false && chks[3].checked ==false && chks[4].checked ==false && chks[5].checked ==false ){ 
						  chks[0].disabled   =  false;
					}else{
						
						 chks[0].disabled   =  true;
					}
					 
				}
					   
		}
		function   setDisAttr2(chkObj){  
			  var   chks=document.getElementsByName(chkObj.name);     
				if(chks[2].checked ==true){
					  chks[0].disabled   =  true;
					  chks[1].disabled   =  false;
					  chks[2].disabled   =  false;
					  chks[3].disabled   =  false;
					  chks[4].disabled   =  false;
					  chks[5].disabled   =  false;
				}
				if(chks[2].checked ==false){ 
					if(chks[1].checked ==false && chks[3].checked ==false  && chks[4].checked ==false && chks[5].checked ==false ){ 
						  chks[0].disabled   =  false;
					}else{
						
						 chks[0].disabled   =  true;
					} 
				} 
		}

		function   setDisAttr3(chkObj){  
			  var   chks=document.getElementsByName(chkObj.name);     
				if(chks[3].checked ==true){
					  chks[0].disabled   =  true;
					  chks[1].disabled   =  false;
					  chks[2].disabled   =  false;
					  chks[3].disabled   =  false;
					  chks[4].disabled   =  false;
					  chks[5].disabled   =  false;
				}
				if(chks[3].checked ==false){ 
					if(chks[1].checked ==false && chks[2].checked ==false  && chks[4].checked ==false && chks[5].checked ==false ){ 
						  chks[0].disabled   =  false;
					}else{ 
						 chks[0].disabled   =  true;
					}
					 
				}
					   
		}
		function   setDisAttr4(chkObj){  
			  var   chks=document.getElementsByName(chkObj.name);     
				if(chks[4].checked ==true){
					  chks[0].disabled   =  true;
					  chks[1].disabled   =  false;
					  chks[2].disabled   =  false;
					  chks[3].disabled   =  false;
					  chks[4].disabled   =  false;
					  chks[5].disabled   =  false;
				}
				if(chks[4].checked ==false){ 
					if(chks[1].checked ==false && chks[2].checked ==false  && chks[3].checked ==false && chks[5].checked ==false ){ 
						  chks[0].disabled   =  false;
					}else{ 
						 chks[0].disabled   =  true;
					}
					 
				}
					   
		}
		function   setDisAttr5(chkObj){  
			  var   chks=document.getElementsByName(chkObj.name);     
				if(chks[5].checked ==true){
					  chks[0].disabled   =  true;
					  chks[1].disabled   =  false;
					  chks[2].disabled   =  false;
					  chks[3].disabled   =  false;
					  chks[4].disabled   =  false;
					  chks[5].disabled   =  false;
				}
				if(chks[5].checked ==false){ 
					if(chks[1].checked ==false && chks[2].checked ==false  && chks[3].checked ==false && chks[4].checked ==false ){ 
						  chks[0].disabled   =  false;
					}else{ 
						 chks[0].disabled   =  true;
					}
					 
				}
					   
		}

	
		
		
</script>

</html>

