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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
 
<title>承包商（供应商）监督检查</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">承包商名称</td>
			    <td class="ali_cdn_input"><input id="materialName" name="materialName" type="text" /></td>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{cinspection_no}' value='{cinspection_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>			      
			      <td class="bt_info_odd" exp="{contractor_name}">承包商名称</td>
			      <td class="bt_info_even" exp="{training_time}">培训时间</td>
			      <td class="bt_info_odd" exp="{check_time}">检查时间</td>
			      <td class="bt_info_even" exp="{number_problems}">问题数量</td>
			      <td class="bt_info_odd" exp="{examination_time}">考核时间</td>
			      <td class="bt_info_even" exp="{hse_points}">HSE综合得分</td> 
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">  
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">验收</a></li>		
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">培训</a></li>	
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">检查</a></li>	
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">考核</a></li>	
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate('1')" title="保存"></a></span></td>
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
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="cinspection_no" name="cinspection_no"   />
					     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
						    <td class="inquire_item6"><font color="red">*</font>承包商名称：</td>
						    <td class="inquire_form6">
						    <input type="text" id="contractor_name" name="contractor_name" class="input_width"    />    					    
						    </td>					    
						</tr>	 
					    <tr>	
						    <td class="inquire_item6">是否在公司合格承包商名录：</td>
						    <td class="inquire_form6">
						    <input type="text" id="if_contractor_list" name="if_contractor_list" class="input_width"  readonly="readonly" />    		
						    </td>		  
						 </tr>		
					  </table> 
				</div> 
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate('2')" title="保存"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	         	   </table>
	          	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr> 
					    <td class="inquire_item6">证件、文件：</td>
					    <td class="inquire_form6">
					    <input type="text" id="certificates" name="certificates" class="input_width"    />    					    
					    </td>	 
					    <td class="inquire_item6">HSE管理组织：</td>
					    <td class="inquire_form6">
					    <input type="text" id="hse_organization" name="hse_organization" class="input_width"    />    		
					    </td>		  
					  </tr>		
					  <tr>	 
					    <td class="inquire_item6">人员：</td>
					    <td class="inquire_form6">
					    <input type="text" id="personnel" name="personnel" class="input_width"   />    					    
					    </td>	 
					    <td class="inquire_item6">设备：</td>
					    <td class="inquire_form6">
					    <input type="text" id="equipment" name="equipment" class="input_width"  />    		
					    </td>		  
					  </tr>		
					  <tr>	 
					    <td class="inquire_item6">劳动防护用品：</td>
					    <td class="inquire_form6">
					    <input type="text" id="labor_articles" name="labor_articles" class="input_width"     />    					    
					    </td>	 
					    <td class="inquire_item6">体检：</td> 
					    <td class="inquire_form6">
					    <input type="text" id="physical_examination" name="physical_examination" class="input_width"     />  		
					    </td>		  
					  </tr>	
					  <tr>	 
					    <td class="inquire_item6">保险：</td>
					    <td class="inquire_form6">
					    <input type="text" id="insurance_s" name="insurance_s" class="input_width"     />    					    
					    </td>	 
					    <td class="inquire_item6">设备：</td>
					    <td class="inquire_form6">
					    <input type="text" id="equipment_s" name="equipment_s" class="input_width"     />    		
					    </td>		  
					  </tr>	
					  <tr>	 
					    <td class="inquire_item6">市场准入证：</td>
					    <td class="inquire_form6">
					    <input type="text" id="sta_market" name="sta_market" class="input_width"     />    					    
					    </td>	 
					    <td class="inquire_item6"><font color="red">*</font>验收结论：</td>
					    <td class="inquire_form6">
					    <select id="acceptance_conclusion" name="acceptance_conclusion" class="select_width">
					       <option value="" >请选择</option> 
					       <option value="1" >一次通过</option>
					       <option value="2" >二次通过</option>
					       <option value="3" >三次通过</option>
					       <option value="4" >未通过</option>
						</select>  	  		
					    </td>		  
					  </tr>	
				  </table> 
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate('3')" title="保存"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	         	   </table>
	            	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>  
					    <td class="inquire_item6"><font color="red">*</font>培训开始时间：</td>
					    <td class="inquire_form6">
					    <input type="text" id="training_start_time" name="training_start_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(training_start_time,tributton1);" />&nbsp;
					    </td>	 
					    <td class="inquire_item6"><font color="red">*</font>培训结束时间：</td>
					    <td class="inquire_form6">
					    <input type="text" id="training_end_time" name="training_end_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(training_end_time,tributton2);" />&nbsp;</td>	  
					  </tr>		
					  <tr>	 
					    <td class="inquire_item6"><font color="red">*</font>学时：</td>
					    <td class="inquire_form6">
					    <input type="text" id="school" name="school" class="input_width"     />    					    
					    </td>	 
					    <td class="inquire_item6"><font color="red">*</font>参加人数：</td>
					    <td class="inquire_form6">
					    <input type="text" id="participation" name="participation" class="input_width"    />    		
					    </td>		  
					  </tr>		 
				  </table> 
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo6"> 
				 <tr>
				    <td class="inquire_item6"><font color="red">*</font>培训内容：</td>			 
				    <td class="inquire_form6" colspan="4"><textarea id="training_content" name="training_content"  style="width:720px;height:60px;"  class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 		
				    </tr>	
				 <tr>
				    <td class="inquire_item6">小结：</td>			 
				    <td class="inquire_form6" colspan="4"><textarea id="summary" name="summary"  style="width:720px;height:60px;"  class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 		
				    </tr>	
				</table>
			 </div> 
			 
			 <div id="tab_box_content3" class="tab_box_content" style="display:none;">
					 <table width="100%" border="0" cellspacing="0" cellpadding="0">
		             <tr align="right" height="30">
		               <td>&nbsp;</td>
		               <td width="100" id="buttonDis3" >	
		               <span class="bc"><a href="#" onclick="toUpdate('4')" title="保存"></a></span>
		               <span class="zj"  onclick="toAddDetail()" title="增加"><a href="#"></a></span>
		               <span class="sc"  onclick="toExitDetail()" title="删除"><a href="#"></a></span>		                  
		               </td>
		               <td width="5"></td>
		             </tr>
		           </table>
		           <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr> 
					    <td class="inquire_item6"><font color="red">*</font>检查时间：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_time" name="check_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_time,tributton3);" />&nbsp;
					    </td>	 
					    <td class="inquire_item6"><font color="red">*</font>检查内容：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_content" name="check_content" class="input_width"    />    
					    </td>	  
					  </tr>		
					  <tr>	 
					    <td class="inquire_item6">检查人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_people" name="check_people" class="input_width"    />    					    
					    </td>	 
					    <td class="inquire_item6">问题数量：</td>
					    <td class="inquire_form6">
					    <input type="text" id="number_problems" name="number_problems" class="input_width"  readonly="readonly" />    		
					    </td>		  
					  </tr>		 
				  </table> 
		           <table  id="hseTableInfo5" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">						 
					  <tr> 
			    	    <td class="bt_info_even">选择</td>			  
			            <td  class="bt_info_odd">问题描述</td>
			            <td class="bt_info_even">整改完成情况</td>		
			            <td  class="bt_info_odd">整改完成时间</td>	 
					  </tr>
					</table>
			 </div>
			 <div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	         	   </table>
	            	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>  
					    <td class="inquire_item6">考核时间：</td>
					    <td class="inquire_form6">
					    <input type="text" id="examination_time" name="examination_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(examination_time,tributton4);" />&nbsp;
					    </td>	 
					    <td class="inquire_item6">考核单位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="assessment_unit" name="assessment_unit" class="input_width"   />
					     </td>	  
					  </tr>		
					  <tr>	 
					    <td class="inquire_item6">考核人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="assessment_people" name="assessment_people" class="input_width"     />    					    
					    </td>	 
					    <td class="inquire_item6">HSE综合得分（百分制）：</td>
					    <td class="inquire_form6">
					    <input type="text" id="hse_points" name="hse_points" class="input_width"   />    		
					    </td>		  
					  </tr>		 
				  </table> 
				 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo7"> 
				 <tr>
				    <td class="inquire_item6">HSE合同执行情况：</td>			 
				    <td class="inquire_form6" colspan="4"><textarea id="hse_contract_situation" name="hse_contract_situation"  style="width:720px;height:60px;"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 
				    </tr>	
				 <tr>
				    <td class="inquire_item6">存在的问题及不足：</td>			 
				    <td class="inquire_form6" colspan="4"><textarea id="problems_and_deficiency" name="problems_and_deficiency"  style="width:720px;height:60px;"    class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 
				    </tr>	
				</table> 
			 </div>
			 
				</form>
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
	
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = " select tr.check_time,tr.check_content,tr.check_people,nvl(tr.number_problems,'0') number_problems,  tr.org_sub_id, tr.cinspection_no,tr.contractor_name,tr.if_contractor_list,tr.certificates,tr.hse_organization,tr.personnel,tr.equipment,tr.labor_articles,tr.acceptance_conclusion, nvl(to_char(tr.training_start_time,'yyyy-MM-dd'),'--') || ' 至 '|| nvl(to_char(tr.training_end_time,'yyyy-MM-DD'),'--') as training_time,tr.school,tr.training_content,tr.participation,tr.summary,tr.examination_time,tr.assessment_unit,tr.assessment_people,tr.hse_contract_situation,tr.hse_points,tr.problems_and_deficiency ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CONTRACTOR_INSPECTION tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left  join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0' "+querySqlAdd+" order by  tr.modifi_date desc "; 
		cruConfig.currentPageUrl = "/hse/hseOptionPage/contractorInspection/contractorInspectionList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/contractorInspection/contractorInspectionList.jsp";
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
		var materialName = document.getElementById("materialName").value;
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		if(materialName!=''&& materialName!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = " select tr.check_time,tr.check_content,tr.check_people,nvl(tr.number_problems,'0') number_problems,  tr.org_sub_id, tr.cinspection_no,tr.contractor_name,tr.if_contractor_list,tr.certificates,tr.hse_organization,tr.personnel,tr.equipment,tr.labor_articles,tr.acceptance_conclusion, nvl(to_char(tr.training_start_time,'yyyy-MM-dd'),'--') || ' 至 '|| nvl(to_char(tr.training_end_time,'yyyy-MM-DD'),'--') as training_time,tr.school,tr.training_content,tr.participation,tr.summary,tr.examination_time,tr.assessment_unit,tr.assessment_people,tr.hse_contract_situation,tr.hse_points,tr.problems_and_deficiency ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CONTRACTOR_INSPECTION tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'   left join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0' "+querySqlAdd+" and tr.contractor_name like '"+ materialName +"%' order by  tr.modifi_date desc "; 
			cruConfig.currentPageUrl = "/hse/hseOptionPage/contractorInspection/contractorInspectionList.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("materialName").value = "";
	}

	function loadDataDetail(shuaId){
//		var obj = event.srcElement;
//		if(obj.tagName.toLowerCase() =='td'){
//			obj.parentNode.cells[0].firstChild.checked = 'checked';
//		}
//		
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;	 
			querySql = "  select  tr.physical_examination,tr.insurance_s,tr.equipment_s,tr.sta_market, tr.project_no,  tr.check_time,tr.check_content,tr.check_people,nvl(tr.number_problems,'0')number_problems,  tr.org_sub_id, tr.cinspection_no,tr.contractor_name,tr.if_contractor_list,tr.certificates,tr.hse_organization,tr.personnel,tr.equipment,tr.labor_articles,tr.acceptance_conclusion,tr.training_start_time,tr.training_end_time,tr.school,tr.training_content,tr.participation,tr.summary,tr.examination_time,tr.assessment_unit,tr.assessment_people,tr.hse_contract_situation,tr.hse_points,tr.problems_and_deficiency ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CONTRACTOR_INSPECTION tr      left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'   left join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'   and tr.cinspection_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
 
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 		   
		             document.getElementsByName("cinspection_no")[0].value=datas[0].cinspection_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		       		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	    	
	 
		    		 document.getElementsByName("check_time")[0].value=datas[0].check_time;
		    		 document.getElementsByName("check_content")[0].value=datas[0].check_content;		
		    		 document.getElementsByName("check_people")[0].value=datas[0].check_people;			
		    		 document.getElementsByName("number_problems")[0].value=datas[0].number_problems;			
		    		 document.getElementsByName("contractor_name")[0].value=datas[0].contractor_name;
		    		 document.getElementsByName("if_contractor_list")[0].value=datas[0].if_contractor_list;
		    	     document.getElementsByName("certificates")[0].value=datas[0].certificates;		
		    	     document.getElementsByName("hse_organization")[0].value=datas[0].hse_organization;
		    		 document.getElementsByName("personnel")[0].value=datas[0].personnel;		
		    		 document.getElementsByName("equipment")[0].value=datas[0].equipment;			
		    		 document.getElementsByName("labor_articles")[0].value=datas[0].labor_articles;			
		    		 document.getElementsByName("acceptance_conclusion")[0].value=datas[0].acceptance_conclusion;
		    		 document.getElementsByName("training_start_time")[0].value=datas[0].training_start_time; 
		      		 document.getElementsByName("training_end_time")[0].value=datas[0].training_end_time;			
		    		 document.getElementsByName("school")[0].value=datas[0].school;
		    		 document.getElementsByName("training_content")[0].value=datas[0].training_content; 
		    		 document.getElementsByName("participation")[0].value=datas[0].participation;			
		    		 document.getElementsByName("summary")[0].value=datas[0].summary;
		    		 document.getElementsByName("examination_time")[0].value=datas[0].examination_time;
		    	     document.getElementsByName("assessment_unit")[0].value=datas[0].assessment_unit;		
		    	     document.getElementsByName("assessment_people")[0].value=datas[0].assessment_people;
		    		 document.getElementsByName("hse_contract_situation")[0].value=datas[0].hse_contract_situation;		
		    		 document.getElementsByName("hse_points")[0].value=datas[0].hse_points;			
		    		 document.getElementsByName("problems_and_deficiency")[0].value=datas[0].problems_and_deficiency;			
		    		 document.getElementsByName("project_no")[0].value=datas[0].project_no;	
		    		  
		    		  document.getElementsByName("physical_examination")[0].value=datas[0].physical_examination;
		    		  document.getElementsByName("insurance_s")[0].value=datas[0].insurance_s;
		    		  document.getElementsByName("equipment_s")[0].value=datas[0].equipment_s;
		    		  document.getElementsByName("sta_market")[0].value=datas[0].sta_market;
		    	 
				}					
			
		    	}		
			
			var querySql1="";
			var queryRet1=null;
			var datas1 =null;
			 deleteTableTr("hseTableInfo5"); 
				   querySql1 = "  select cn.cicheck_no,cn.cinspection_no, case when length(cn.problem_description)<= 9 then cn.problem_description else concat(substr(cn.problem_description,0,9),'...') end problem_description,   case when length(cn.r_completion)<= 9 then cn.r_completion else concat(substr(cn.r_completion,0,9),'...') end r_completion, cn.r_completion_time  from BGP_CINSPECTION_CHECK cn  left join BGP_CONTRACTOR_INSPECTION tr on cn.cinspection_no=tr.cinspection_no and tr.bsflag='0' where cn.bsflag='0' and cn.cinspection_no='"+shuaId+"' ";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;		
						if(datas1 != null && datas1 != ''){	
							var selectedRow = 0;
				           for(var i = 0; i<datas1.length; i++){
				        	   var tbObj = document.getElementById("hseTableInfo5");
				        		var tr2 = document.getElementById("hseTableInfo5").insertRow();	
					         	if(i % 2 == 1){  
				              		classCss = "even_";
								}else{ 
									classCss = "odd_";
								}
					         	var td2 = tr2.insertCell(0);
								td2.className=classCss+"odd";
								td2.innerHTML = '<input type="radio" name="chx_entity_ids" value="'+datas1[i].cicheck_no+','+datas1[i].cinspection_no+'" >';
								
								var td2 = tr2.insertCell(1);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].problem_description;
								
					         	var td2 = tr2.insertCell(2);
								td2.className=classCss+"odd";
								td2.innerHTML =datas1[i].r_completion;
								
								var td2 = tr2.insertCell(3);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].r_completion_time;						
																
					          
								tr2.onclick = function(){
									// 取消之前高亮的行
									if(selectedRow>0){
										var oldTr = tbObj.rows[selectedRow];
										var cells = oldTr.cells;
										for(var j=0;j<cells.length;j++){
											cells[j].style.background="#96baf6";
											// 设置列样式
											if(selectedRow%2==0){
												if(j%2==1) cells[j].style.background = "#FFFFFF";
												else cells[j].style.background = "#f6f6f6";
											}else{
												if(j%2==1) cells[j].style.background = "#ebebeb";
												else cells[j].style.background = "#e3e3e3";
											}
										}
									}
									var obj = event.srcElement;
									if(obj.tagName.toLowerCase() == 'td'){
										var tr = obj.parentNode;
										selectedRow = tr.rowIndex;
									}else if(obj.tagName.toLowerCase() == 'input'){
										var tr = obj.parentNode.parentNode;
										selectedRow = tr.rowIndex;
									}
									// 设置新行高亮
									var cells = this.cells;
									for(var i=0;i<cells.length;i++){
										cells[i].style.background="#ffc580";
									}
								}
								tr2.ondblclick = function(){
									var cells = this.cells;
									var ids = cells[0].firstChild.value;
									dbclickRow(cells[0].childNodes[0].value);
									var checkDetailNo = ids.split(',')[0]; 
									var checkNo = ids.split(',')[1]; 
									popWindow("<%=contextPath%>/hse/hseOptionPage/contractorInspection/addContractorCheck.jsp?cinspection_no="+checkNo+"&cicheck_no="+checkDetailNo);
									
								}
					       				      
							}
							
						}
				    }	
			
			 
		}
		
	}

	function showTip( s) 
	{ 
	var  length   =   100   ; 
	if(null==s   ||   s.length()==0) 
	return   " "; 

	if(s.length()> length) 
	return   s.substring(0,   100)+ "... "; 
	else 
	return   s   ; 
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
	
	function selectOrgs(){
		  var teamInfo = {
			        fkValue:"",
			        value:""
			    };
	    var check_unit_org = document.getElementById("check_unit_org").value;
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	    if(teamInfo.fkValue!=""){
	       document.getElementById("check_unit_org").value = teamInfo.value;
	      
	   }
	}

	function selectOrgs2(){
		  var teamInfo = {
			        fkValue:"",
			        value:""
			    };
	  var check_unit_org = document.getElementById("check_roots_org").value;
	  window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	  if(teamInfo.fkValue!=""){
	     document.getElementById("check_roots_org").value = teamInfo.value;
	    
	 }
	}

	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/contractorInspection/addContractor.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
	}
 
	function toAddDetail(){
	   var ids=document.getElementsByName("cinspection_no")[0].value;
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		popWindow("<%=contextPath%>/hse/hseOptionPage/contractorInspection/addContractorCheck.jsp?cinspection_no="+ids);
		
	}
	
	
	function toExitDetail(){
  
        var radios=document.getElementsByName("chx_entity_ids");
        if(radios.length=='0'){
  	         alert("请先选中一条主记录!");
  	   	     return;
  	        	
          }
 
        for(var i=0;i<radios.length;i++)
        {
            if(radios[i].checked==true)
            {
                var ids=radios[i].value; 
        		var checkDetailNo = ids.split(',')[0]; 
				var checkNo = ids.split(',')[1]; 
        		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
        		var submitStr='JCDP_TABLE_NAME=BGP_CINSPECTION_CHECK&JCDP_TABLE_ID='+checkDetailNo+'&bsflag=1';
        		syncRequest('Post',path,encodeURI(encodeURI(submitStr))); 
	     		   var querySql1="";
	     	       var queryRet1=null;
	     	       var datas1 =null; 
	     	       querySql1 = "  select count(*) num_sum ,cn.cinspection_no  from BGP_CINSPECTION_CHECK  cn  where cn.bsflag='0' and cn.cinspection_no='"+checkNo+"' group by   cn.cinspection_no ";
	     	       queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	     	      
	     		 	if(queryRet1.returnCode=='0'){
	     		 	  datas1 = queryRet1.datas;	 
		     		 		if(datas1 != null && datas1 != ''){	 
		     		 			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq'; 
		     		 				var submitStr = 'JCDP_TABLE_NAME=BGP_CONTRACTOR_INSPECTION&JCDP_TABLE_ID='+checkNo+'&number_problems='+datas1[0].num_sum  
		     		 				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		     		 			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   
		     		 		}else{
		     		 			var numSum='0';
		    		 			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq'; 
		 		 				var submitStr = 'JCDP_TABLE_NAME=BGP_CONTRACTOR_INSPECTION&JCDP_TABLE_ID='+checkNo+'&number_problems='+numSum  
		 		 				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		 		 			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   
		     		 			
		     		 		}
	     		
	     		 	 }  
     	  		
       		 refreshData();
       		loadDataDetail(checkNo);	
    		alert('删除成功');

            }else{
                alert("请先选中一条子记录信息!");   return;
            	
            }
        }


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
		popWindow("<%=contextPath%>/hse/hseOptionPage/contractorInspection/addContractor.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&cinspection_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/contractorInspection/addContractor.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&cinspection_no="+ids);
	  	
	} 
	
	 
	function toDelete(){
 		
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
 
		deleteEntities("update BGP_CONTRACTOR_INSPECTION  e set e.bsflag='1' where e.cinspection_no in ("+id+")");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/contractorInspection/hse_search.jsp?isProject=<%=isProject%>");
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

	 	function queryOrg(){
	 		retObj = jcdpCallService("HseSrv", "queryOrg", "");
	 		if(retObj.flag=="true"){
	 			var len = retObj.list.length;
	 			if(len>0){
	 				document.getElementById("org_sub_id").value=retObj.list[0].orgSubId;
	 				document.getElementById("org_sub_id2").value=retObj.list[0].orgAbbreviation;
	 			}
	 			if(len>1){
	 				document.getElementById("second_org").value=retObj.list[1].orgSubId;
	 				document.getElementById("second_org2").value=retObj.list[1].orgAbbreviation;
	 			}
	 			if(len>2){
	 				document.getElementById("third_org").value=retObj.list[2].orgSubId;
	 				document.getElementById("third_org2").value=retObj.list[2].orgAbbreviation;
	 			}
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
			
			 var contractor_name=document.getElementsByName("contractor_name")[0].value;
			 
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(contractor_name==""){
	 			alert("承包商名称不能为空，请填写！");
	 			return true;
	 		}
	 		   
	 		return false;
	 	}
	 	function checkJudge1(){ 
			 var acceptance_conclusion=document.getElementsByName("acceptance_conclusion")[0].value;
		  
	 		if(acceptance_conclusion==""){
	 			alert("验收结论不能为空，请填写！");
	 			return true;
	 		}
	 		   
	 		return false;
	 	}
	 	 
	 	function checkJudge2(){ 
			 var training_start_time=document.getElementsByName("training_start_time")[0].value;
			 var training_end_time=document.getElementsByName("training_end_time")[0].value;		
			 var school=document.getElementsByName("school")[0].value;
			 var training_content=document.getElementsByName("training_content")[0].value;
			 var participation=document.getElementsByName("participation")[0].value;		
		  
	 		if(training_start_time==""){
	 			alert("培训开始时间不能为空，请填写！");
	 			return true;
	 		}
	 		if(training_end_time==""){
	 			alert("培训结束时间不能为空，请填写！");
	 			return true;
	 		}
	 		if(school==""){
	 			alert("学时不能为空，请填写！");
	 			return true;
	 		}
	 		if(training_content==""){
	 			alert("培训内容不能为空，请填写！");
	 			return true;
	 		}
	 		if(participation==""){
	 			alert("参加人数不能为空，请填写！");
	 			return true;
	 		}
	 		
	 		return false;
	 	}
	 	
	 	function checkJudge3(){ 
			 var check_time=document.getElementsByName("check_time")[0].value;
			 var check_content=document.getElementsByName("check_content")[0].value;
		 	
	 		if(check_time==""){
	 			alert("检查时间不能为空，请填写！");
	 			return true;
	 		}
			if(check_content==""){
	 			alert("检查内容不能为空，请填写！");
	 			return true;
	 		}
	 		return false;
	 	}

	function toUpdate(ifParam){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var cinspection_no = document.getElementsByName("cinspection_no")[0].value;						 
		  if(cinspection_no !=null && cinspection_no !=''){	

			  if(ifParam =='1'){  
				if(checkJudge()){
					return;
				}
			  }
			  if(ifParam =='2'){ 
					if(checkJudge1()){
						return;
					}
			  }
			  if(ifParam =='3'){
					if(checkJudge2()){
						return;
					}
				  }
			  if(ifParam =='4'){
					if(checkJudge3()){
						return;
					}
				  }
			  
				var cinspection_no = document.getElementsByName("cinspection_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;	
 
				 var check_time=document.getElementsByName("check_time")[0].value;
				 var check_content=document.getElementsByName("check_content")[0].value;
				 var check_people=document.getElementsByName("check_people")[0].value;		
				 var number_problems=document.getElementsByName("number_problems")[0].value;		
				 var contractor_name=document.getElementsByName("contractor_name")[0].value;
				 var if_contractor_list=document.getElementsByName("if_contractor_list")[0].value;
				 var certificates=document.getElementsByName("certificates")[0].value;	
				 var hse_organization=document.getElementsByName("hse_organization")[0].value;
				 var personnel=document.getElementsByName("personnel")[0].value;	
				 var equipment=document.getElementsByName("equipment")[0].value;		
				 var labor_articles=document.getElementsByName("labor_articles")[0].value;		
				 var acceptance_conclusion=document.getElementsByName("acceptance_conclusion")[0].value;
				 var training_start_time=document.getElementsByName("training_start_time")[0].value;
				 var training_end_time=document.getElementsByName("training_end_time")[0].value;		
				 var school=document.getElementsByName("school")[0].value;
				 var training_content=document.getElementsByName("training_content")[0].value;
				 var participation=document.getElementsByName("participation")[0].value;		
				 var summary=document.getElementsByName("summary")[0].value;
				 var examination_time=document.getElementsByName("examination_time")[0].value;
				 var assessment_unit=document.getElementsByName("assessment_unit")[0].value;
				 var assessment_people=document.getElementsByName("assessment_people")[0].value;
				 var hse_contract_situation=document.getElementsByName("hse_contract_situation")[0].value;
				 var hse_points=document.getElementsByName("hse_points")[0].value;		
				 var problems_and_deficiency=document.getElementsByName("problems_and_deficiency")[0].value;			
				 var project_no = document.getElementsByName("project_no")[0].value;	
				 
				 var physical_examination = document.getElementsByName("physical_examination")[0].value;	
				 var insurance_s = document.getElementsByName("insurance_s")[0].value;	
				 var equipment_s = document.getElementsByName("equipment_s")[0].value;	
				 var sta_market = document.getElementsByName("sta_market")[0].value;	
				  
					
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			 
				
				rowParam['physical_examination'] = encodeURI(encodeURI(physical_examination));
				rowParam['insurance_s'] = encodeURI(encodeURI(insurance_s));
				rowParam['equipment_s'] = encodeURI(encodeURI(equipment_s));
				rowParam['sta_market'] = encodeURI(encodeURI(sta_market));
				
				rowParam['check_time'] = encodeURI(encodeURI(check_time));
				rowParam['check_content'] = encodeURI(encodeURI(check_content));
				rowParam['check_people'] = encodeURI(encodeURI(check_people));
				rowParam['number_problems'] = number_problems;		 
				rowParam['contractor_name'] = encodeURI(encodeURI(contractor_name));
				rowParam['if_contractor_list'] = encodeURI(encodeURI(if_contractor_list));
				rowParam['certificates'] = encodeURI(encodeURI(certificates));
				rowParam['hse_organization'] = encodeURI(encodeURI(hse_organization));		 
				rowParam['personnel'] = encodeURI(encodeURI(personnel));
				rowParam['equipment'] = encodeURI(encodeURI(equipment));
				rowParam['labor_articles'] = encodeURI(encodeURI(labor_articles));
				rowParam['acceptance_conclusion'] = encodeURI(encodeURI(acceptance_conclusion));
				rowParam['training_start_time'] =training_start_time;
				rowParam['training_end_time'] = encodeURI(encodeURI(training_end_time));
				rowParam['school'] = school;
				rowParam['training_content'] = encodeURI(encodeURI(training_content)); 
				rowParam['participation'] = participation;		 
				rowParam['summary'] = encodeURI(encodeURI(summary));
				rowParam['examination_time'] = encodeURI(encodeURI(examination_time));
				rowParam['assessment_people'] = encodeURI(encodeURI(assessment_people));
				rowParam['assessment_unit'] = encodeURI(encodeURI(assessment_unit)); 
				rowParam['hse_contract_situation'] = encodeURI(encodeURI(hse_contract_situation));
				rowParam['hse_points'] = hse_points;
				rowParam['problems_and_deficiency'] = encodeURI(encodeURI(problems_and_deficiency));
				
			    rowParam['cinspection_no'] = cinspection_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
							 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_CONTRACTOR_INSPECTION",rows);	
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

