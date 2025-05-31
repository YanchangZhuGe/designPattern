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
 
<title>隐患管理</title>
</head>

<body style="background:#cdddef"  onload="refreshData();getHazardBig();getRiskLevels();getControlEffect();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">隐患描述</td>
			    <td class="ali_cdn_input"><input id="changeName" name="changeName" type="text" /></td>		   
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td> 	</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='toUploadFile()'" title="导入" ></auth:ListButton>
			    <auth:ListButton functionId="" css="bb" event="onclick='toTj()'" title="图表"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="pljs" event="onclick='openAdd()'" title="批量录入"></auth:ListButton>
				<auth:ListButton functionId="" css="xz" event="onclick='toExportExcel()'" title="导出信息"></auth:ListButton>
				
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{hidden_no}' value='{hidden_no}'   onclick=doCheck(this)  />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{hse_hidden_description}">隐患描述</td>
			      <td class="bt_info_even" exp="{report_date}">上报日期</td>
			      <td class="bt_info_odd" exp="{risk_levels}">风险等级</td>
			      <td class="bt_info_even" exp="{rectification_state}">整改状态</td>
			      <td class="bt_info_odd" exp="{reward_state}">奖励状态</td>

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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">隐患信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">评价信息</a></li>		
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">整改信息</a></li>	
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">奖励信息</a></li>		
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action=""> 
				<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"/>
				<div id="tab_box_content0" class="tab_box_content">
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
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6"> 下属单位：</td>
					      	<td class="inquire_form6">
					    	<input type="hidden" id="aa" name="aa" value="" />
					       	<input type="hidden" id="bb" name="bb" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="hidden_no" name="hidden_no"   />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					    	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					    <td class="inquire_item6"><font color="red">*</font>作业场所/岗位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="operation_post" name="operation_post" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					   			 
			 		    <td class="inquire_item6"> 识别方式：</td>
					    <td class="inquire_form6">  
					    <select id="identification_method" name="identification_method" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集中识别</option>
					       <option value="2" >随机识别</option>
					       <option value="3" >专项识别</option>
					       <option value="4" >来访者识别</option>
					       <option value="5" >安全观察与沟通</option>
					       <option value="6" >工作安全分析</option>
					       <option value="7" >工艺安全分析</option>
					       <option value="8" >其它</option>
						</select> 		
					    </td>
					     <td class="inquire_item6"> </td>
					    <td class="inquire_form6"><input type="hidden" id="hidden_name" name="hidden_name" class="input_width"    /></td>		
					  </tr>		
				 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>隐患危害类型（大类）：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="hazard_big" name="hazard_big" class="select_width" onchange="getHazardCenter()"></select> 	
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>隐患危害类型（小类）：</td>
					    <td class="inquire_form6"> 
					    <select id="hazard_center" name="hazard_center" class="select_width">
						</select> 			
					    </td>
					    </tr>	
					    
					    <tr>
					    <td class="inquire_item6"><font color="red">*</font> 隐患级别：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="hidden_level" name="hidden_level" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >特大</option>
					       <option value="2" >重大</option> 
					       <option value="3" >较大</option>
					       <option value="4" >一般</option> 
						</select> 	
						 <td class="inquire_item6"><font color="red">*</font>隐患类别：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="hidden_type_s" name="hidden_type_s" class="select_width">
						       <option value="" >请选择</option>
						       <option value="民爆物品" >民爆物品</option>
						       <option value="交通伤害" >交通伤害</option> 
						       <option value="机械伤害" >机械伤害</option>
						       <option value="火灾" >火灾</option> 
						       <option value="触电" >触电</option> 
						       <option value="起重伤害" >起重伤害</option> 
						       <option value="水上作业" >水上作业</option> 
						       <option value="淹溺" >淹溺</option> 
						       <option value="灼烫" >灼烫</option> 
						       <option value="高处坠落" >高处坠落</option> 
						       <option value="坍塌" >坍塌</option> 
						       <option value="锅炉压力容器" >锅炉压力容器</option> 
						       <option value="环境" >环境</option> 						       
						       <option value="职业健康" >职业健康</option> 
						       <option value="职业禁忌症" >职业禁忌症</option> 
						       <option value="疫情" >疫情</option> 
						       <option value="中毒和窒息" >中毒和窒息</option> 
						       <option value="其他" >其他</option> 
							</select> 	
							 
						    </tr>	
						    <tr>
						    <td class="inquire_item6"> 是否新增：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="whether_new" name="whether_new" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >是</option>
						       <option value="2" >否</option> 
							</select> 	
						    </td> 
						    <td class="inquire_item6">识别人员类别：</td>
						    <td class="inquire_form6"> 
						    <select id="rpeople_type" name="rpeople_type" class="select_width">
						       <option value="" >请选择</option>
						       <option value="机关管理人员" >机关管理人员</option>
						       <option value="直线管理者" >直线管理者</option> 
						       <option value="HSE专业人员（管理和监督）" >HSE专业人员（管理和监督）</option>
						       <option value="操作岗位员工（合同化）" >操作岗位员工（合同化）</option> 
						       <option value="操作岗位员工（市场化）" >操作岗位员工（市场化）</option> 
						       <option value="季节性临时用工" >季节性临时用工</option> 
						       <option value="承包商员工" >承包商员工</option> 
							</select> 	
						    </td>
						    </tr>	
						    
						    <tr>
						    <td class="inquire_item6"> 识别人：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="recognition_people" name="recognition_people" class="input_width"   />    		
						    </td>

							    <td class="inquire_item6"> <font color="red">*</font>隐患存在原因：</td>
							    <td class="inquire_form6"> 
							    <select id="hidden_yuanyin" name="hidden_yuanyin" class="select_width">
							       <option value="" >请选择</option>
							       <option value="制度或操作程序缺陷" >制度或操作程序缺陷</option>
							       <option value="制度或操作程序未落实" >制度或操作程序未落实</option> 
							       <option value="未培训或培训效果不良" >未培训或培训效果不良</option>
							       <option value="设计缺陷" >设计缺陷</option> 
							       <option value="其他" >其他</option> 
								</select> 			
							    </td>
								  </tr>	
								  
								  <tr>
							    <td class="inquire_item6"><font color="red">*</font>上报日期：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="report_date" name="report_date" class="input_width"    readonly="readonly"/>
							   <div style="display:block;"> &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton1);" />&nbsp;</div></td>
							  
							  </tr>						    
					     </table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>隐患描述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="hidden_description" name="hidden_description"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>						  
					</table>
				</div>	 
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate1('1')" title="保存"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	         	 </table>
	         	 <table width="100%" border="0" cellspacing="0" id="table1" cellpadding="0" class="tab_line_height" >					
	         	 <tr>	
				    <td class="inquire_item6"><font color="red">*</font>评价日期：</td>
				    <td class="inquire_form6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width"   readonly="readonly"  /></td>	 
				    <td class="inquire_item6"> 评价级别：</td> 					   
				    <td class="inquire_form6"  align="center" > 
			      	<input type="hidden" id="mdetail_no" name="mdetail_no" value="" />
				    <select id="evaluation_level" name="evaluation_level" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >公司</option>
				       <option value="2" >二级单位</option> 
				       <option value="3" >基层单位</option> 
				       <option value="4" >基层单位下属单位</option>  
					</select> 	
				    </td>
				    </tr>	
					  <tr>	
					    <td class="inquire_item6"> 评价人员：</td>
					    <td class="inquire_form6"><input type="text" id="evaluation_personnel" name="evaluation_personnel" class="input_width"    /></td>	 
					    <td class="inquire_item6"> 主要评价方法：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="main_methods" name="main_methods" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >矩阵法</option>
					       <option value="2" >LEC</option> 
					       <option value="3" >HAZOP</option>
					       <option value="4" >专家评估法</option> 
					       <option value="5" >安全检查表法</option>
					       <option value="6" >默认为矩阵法</option> 
						</select>  
					    </td>
					    </tr>	
					    <tr>	
					    <td class="inquire_item6"><font color="red">*</font>评价状态：</td>
					    <td class="inquire_form6"><input type="text" id="evaluation_state" name="evaluation_state" class="input_width"    value="未评价" readonly="readonly"       /></td>	 
					    <td class="inquire_item6"><font color="red">*</font>风险等级：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					        <select id="risk_levels" name="risk_levels" class="select_width"  ></select> 	
					  
					    </td>
					    </tr>	
					     <tr>	
					    <td class="inquire_item6"> <font color="red">*</font>危害后果：</td>
					    <td class="inquire_form6"><input type="text" id="harmful_consequences" name="harmful_consequences" class="input_width"    /></td>	 
					    <td class="inquire_item6"> </td> 					   
					    <td class="inquire_form6"  align="center" >  
					    </td>
					    </tr>	
					    
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate1('2')" title="保存"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	         	 </table>
				    <table width="100%" border="0" cellspacing="0" id="table2" cellpadding="0" class="tab_line_height" >		
				    <tr>	
					  <td class="inquire_item6"><font color="red">*</font>整改状态：</td>
					    <td class="inquire_form6">
					    <select id="rectification_state" name="rectification_state" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >已整改</option>
					       <option value="2" >未整改</option> 
					       <option value="3" >正在整改</option>  
						</select> 
					    </td>	 	 
					    <td class="inquire_item6">整改措施类型：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="rectification_measures_type" name="rectification_measures_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >消除</option>
					       <option value="2" >工程/设计</option> 
					       <option value="3" >行政/程序</option> 
					       <option value="4" >劳保</option>   
						</select> 	
					    </td>   

					    </tr>	
						  <tr>	
						    <td class="inquire_item6"> <font color="red">*</font>整改或监控措施：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_measures" name="rectification_measures" class="input_width"    /></td>	 
						    <td class="inquire_item6"><font color="red">*</font>控制后风险等级：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="control_effect" name="control_effect" class="select_width">
						      
							</select>  
						    </td>
						    </tr>	
						      <tr>	
						    <td class="inquire_item6"> 整改负责人：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_head" name="rectification_head" class="input_width"    /></td>	 
						    <td class="inquire_item6">验收人：</td> 					   
						    <td class="inquire_form6"  align="center" > 
					            <input type="text" id="rectification_people" name="rectification_people" class="input_width"    /></td>	
						    </tr>
						    
						    <tr>	
						    <td class="inquire_item6"><font color="red">*</font>整改完成时间：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_date" name="rectification_date" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_date,tributton2);" />&nbsp;</td>
						  </tr>	 
				   </table>
				   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"> 未整改原因：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="rectification_reason" name="rectification_reason"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>		
					  <tr>  
					    <td class="inquire_item6">整改计划：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="action_plan" name="action_plan"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					</table>	
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate1('3')" title="保存"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	         	 </table>
	         	 
				    <table width="100%" border="0" cellspacing="0" id="table3" cellpadding="0" class="tab_line_height" >	
				    <tr>  
					  <td class="inquire_item6"> 奖励级别：</td>
					    <td class="inquire_form6">
					    <select id="reward_level" name="reward_level" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >公司</option>
					       <option value="2" >二级单位</option> 
					       <option value="3" >基层单位</option>  
					       <option value="4" >基层单位下属单位</option>  
						</select> 
					    </td>	 	 
					    <td class="inquire_item6"> 奖励金额(元)：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="reward_amount" name="reward_amount" class="input_width"    />
					    </td>   

					    </tr>	
						  <tr>	
						    <td class="inquire_item6"> 兑现日期：</td>
						    <td class="inquire_form6">
						    <input type="text" id="cash_date" name="cash_date" class="input_width"  onchange="getNull(this.value)"  readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(cash_date,tributton3);" />&nbsp;</td>	 
						    <td class="inquire_item6"> 奖励状态：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <input type="text" id="reward_state" name="reward_state" class="input_width" value="未奖励"   readonly="readonly" />
						    </td>
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
var projectInfoNo="<%=projectInfoNo%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
    document.getElementsByName("evaluation_date")[0].value='<%=curDate%>';	
 
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
		cruConfig.queryStr = "";
		var str=" select   case when length(tr.hidden_description)<= 35 then tr.hidden_description else concat(substr(tr.hidden_description,0,35),'...') end  hse_hidden_description, hdl.reward_state, cdl.coding_name  risk_levels,decode(hdl.rectification_state,'1','已整改','2','未整改','3','正在整改')rectification_state,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date, tr.hidden_description  ,tr.org_sub_id,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr    left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'      left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id   left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no=tr.hidden_no and hdl.bsflag='0'  left join comm_coding_sort_detail cdl on  cdl.coding_code_id=hdl.risk_levels  and cdl.bsflag='0'   where tr.bsflag = '0' "+querySqlAdd+" order by tr.modifi_date desc ,hdl.rectification_state  desc ";				 
		cruConfig.queryStr = str;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hseHiddenTwo/hseHidden.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hseHiddenTwo/hseHidden.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	function toTj(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/selectCharts.jsp","900:700");
	}
	
	
	// 简单查询
	function simpleSearch(){
		var changeName = document.getElementById("changeName").value;
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		if(changeName!=''&& changeName!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "  select  case when length(tr.hidden_description)<= 35 then tr.hidden_description else concat(substr(tr.hidden_description,0,35),'...') end  hse_hidden_description,hdl.reward_state, cdl.coding_name  risk_levels,decode(hdl.rectification_state,'1','已整改','2','未整改','3','正在整改')rectification_state,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date, tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr        left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no=tr.hidden_no and hdl.bsflag='0' left join comm_coding_sort_detail cdl on  cdl.coding_code_id=hdl.risk_levels  and cdl.bsflag='0'   where tr.bsflag = '0'  "+querySqlAdd+"  and tr.hidden_description like '%"+changeName+"%'  order by tr.modifi_date desc , hdl.rectification_state  desc";
			cruConfig.currentPageUrl = "/hse/hseOptionPage/hseHiddenTwo/hseHidden.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	function getNull(valueS){ 		
	 
			if(valueS != null && valueS != ''  ){			
				  document.getElementsByName('reward_state')[0].value="已奖励";
			}
	 
	}
	
	function toExportExcel(){ 
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/xiazaiFile.jsp?project=<%=isProject%>","700:450");
	}
	
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
	function getHazardBig(){
		var selectObj = document.getElementById("hazard_big"); 
		document.getElementById("hazard_big").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryHazardBig=jcdpCallService("HseOperationSrv","queryHazardBig","");	
	 
		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
			var templateMap = queryHazardBig.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}
	function getRiskLevels(){
		var selectObj = document.getElementById("risk_levels"); 
		document.getElementById("risk_levels").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryHazardBig=jcdpCallService("HseOperationSrv","queryRiskLevels","");	
	 
		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
			var templateMap = queryHazardBig.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		 
	}
	
	function getControlEffect(){
		var selectObj = document.getElementById("control_effect"); 
		document.getElementById("control_effect").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryHazardBig=jcdpCallService("HseOperationSrv","queryRiskLevels","");	
	 
		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
			var templateMap = queryHazardBig.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		 
	}
	
	
	
	
	
	function getHazardCenter(){
	    var hazardBig = "hazardBig="+document.getElementById("hazard_big").value;   
		var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);	

		var selectObj = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(HazardCenter.detailInfo!=null){
			for(var i=0;i<HazardCenter.detailInfo.length;i++){
				var templateMap = HazardCenter.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}

	function loadDataDetail(shuaId){
//		var obj = event.srcElement;
//		if(obj.tagName.toLowerCase() =='td'){
//			obj.parentNode.cells[0].firstChild.checked = 'checked';
//		}
 
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;	  
			querySql = "   select   tr.rpeople_type,tr.hidden_yuanyin,tr.hidden_type_s, tr.project_no,tr.org_sub_id,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.hidden_level,  tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr   left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0' and tr.hidden_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("hidden_no")[0].value=datas[0].hidden_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
		    		 document.getElementsByName("hazard_big")[0].value=datas[0].hazard_big;		
		  		     document.getElementsByName("aa")[0].value=datas[0].hazard_big;	    
		    		 document.getElementsByName("hazard_center")[0].value=datas[0].hazard_center;	  		    
	    			 document.getElementsByName("bb")[0].value=datas[0].hazard_center;	
	    		    document.getElementsByName("operation_post")[0].value=datas[0].operation_post;
	    			document.getElementsByName("hidden_name")[0].value=datas[0].hidden_name;		
	    			document.getElementsByName("identification_method")[0].value=datas[0].identification_method;			
	    			 document.getElementsByName("rpeople_type")[0].value=datas[0].rpeople_type;	
	    			 document.getElementsByName("hidden_yuanyin")[0].value=datas[0].hidden_yuanyin;	
	    			 document.getElementsByName("hidden_type_s")[0].value=datas[0].hidden_type_s;	
	    			 
	    		    document.getElementsByName("whether_new")[0].value=datas[0].whether_new;				    	 		
	    			document.getElementsByName("recognition_people")[0].value=datas[0].recognition_people;
	    			document.getElementsByName("report_date")[0].value=datas[0].report_date;		
	    		    document.getElementsByName("hidden_level")[0].value=datas[0].hidden_level;		
	    		 	document.getElementsByName("project_no")[0].value=datas[0].project_no;			
	    		    document.getElementsByName("hidden_description")[0].value=datas[0].hidden_description;	 
		         	}					
			
		    	}		exitSelect();	
		 
			var querySql1 = "   select    tr.rectification_head,tr.rectification_people,tr.mdetail_no,tr.reward_state,tr.evaluation_date,tr.evaluation_level,tr.evaluation_personnel,tr.main_methods,tr.harmful_consequences,tr.risk_levels,tr.evaluation_state,tr.rectification_state,tr. rectification_measures,tr.rectification_measures_type,tr.rectification_date,tr.control_effect,tr.rectification_reason,tr.action_plan,tr.reward_level,tr.reward_amount,tr.cash_date 	 from  BGP_HIDDEN_INFORMATION_DETAIL  tr   where  tr.bsflag = '0' and tr.hidden_no='"+ shuaId +"'";				 	 
			var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql1)));
			if(queryRet1.returnCode=='0'){
				var datas1 = queryRet1.datas;
				if(datas1 != null && datas1 != ''){	 
					    document.getElementsByName("mdetail_no")[0].value=datas1[0].mdetail_no; 					 
					    document.getElementsByName("evaluation_date")[0].value=datas1[0].evaluation_date;	
		    		    document.getElementsByName("evaluation_level")[0].value=datas1[0].evaluation_level;
		    			document.getElementsByName("evaluation_personnel")[0].value=datas1[0].evaluation_personnel;		
		    			document.getElementsByName("main_methods")[0].value=datas1[0].main_methods;				    			
		    		    document.getElementsByName("risk_levels")[0].value=datas1[0].risk_levels;		
		    			document.getElementsByName("evaluation_state")[0].value=datas1[0].evaluation_state;	
		    			 document.getElementsByName("harmful_consequences")[0].value=datas1[0].harmful_consequences;	
		    			
		    			 document.getElementsByName("rectification_state")[0].value=datas1[0].rectification_state;	 
		    		     document.getElementsByName("rectification_measures")[0].value=datas1[0].rectification_measures;	    		    
		    			 document.getElementsByName("rectification_measures_type")[0].value=datas1[0].rectification_measures_type;	
		    		    document.getElementsByName("rectification_date")[0].value=datas1[0].rectification_date;
		    			document.getElementsByName("control_effect")[0].value=datas1[0].control_effect;		
		    			document.getElementsByName("rectification_reason")[0].value=datas1[0].rectification_reason;	
		    			document.getElementsByName("rectification_head")[0].value=datas1[0].rectification_head;
		    			document.getElementsByName("rectification_people")[0].value=datas1[0].rectification_people;
		    			
		    		    document.getElementsByName("action_plan")[0].value=datas1[0].action_plan;	 
		    		    document.getElementsByName("reward_state")[0].value=datas1[0].reward_state;
			    		 document.getElementsByName("reward_level")[0].value=datas1[0].reward_level;	 
		    		     document.getElementsByName("reward_amount")[0].value=datas1[0].reward_amount;	    		    
		    			 document.getElementsByName("cash_date")[0].value=datas1[0].cash_date;	
					 
		         	}else{	  
	         		    document.getElementsByName("mdetail_no")[0].value="";					 
					    document.getElementsByName("evaluation_date")[0].value='<%=curDate%>';	
		    		    document.getElementsByName("evaluation_level")[0].value="";
		    			document.getElementsByName("evaluation_personnel")[0].value="";		
		    			document.getElementsByName("main_methods")[0].value="";				    			
		    		    document.getElementsByName("risk_levels")[0].value="";		
		    			document.getElementsByName("evaluation_state")[0].value="未评价";
		    		    document.getElementsByName("harmful_consequences")[0].value="";	
		    			
		    			 document.getElementsByName("rectification_state")[0].value="";	 
		    		     document.getElementsByName("rectification_measures")[0].value="";	    		    
		    			 document.getElementsByName("rectification_measures_type")[0].value="";	
		    		    document.getElementsByName("rectification_date")[0].value="";
		    			document.getElementsByName("control_effect")[0].value="";		
		    			document.getElementsByName("rectification_head")[0].value="";		
		    			document.getElementsByName("rectification_people")[0].value="";		
		    			
		    			document.getElementsByName("rectification_reason")[0].value="";				    			
		    		    document.getElementsByName("action_plan")[0].value="";	 
		    		    document.getElementsByName("reward_state")[0].value="未奖励";
			    		 document.getElementsByName("reward_level")[0].value="";	 
		    		     document.getElementsByName("reward_amount")[0].value="";	    		    
		    			 document.getElementsByName("cash_date")[0].value="";	
	         		
	             	}	
			}
			
		} 
	 
		
	}
	
	function  valueNull(){
		 document.getElementsByName("hidden_no")[0].value="";
		 document.getElementsByName("org_sub_id")[0].value="";
		 document.getElementsByName("org_sub_id2")[0].value="";
		 document.getElementsByName("bsflag")[0].value="";
		 document.getElementsByName("second_org")[0].value="";		
		 document.getElementsByName("second_org2")[0].value="";	
	     document.getElementsByName("third_org")[0].value="";
	     document.getElementsByName("third_org2")[0].value="";
		     document.getElementsByName("create_date")[0].value="";
		 document.getElementsByName("creator")[0].value="";
		 document.getElementsByName("hazard_big")[0].value="";
		     document.getElementsByName("aa")[0].value="";
		 document.getElementsByName("hazard_center")[0].value="";    
		 document.getElementsByName("bb")[0].value="";
	    document.getElementsByName("operation_post")[0].value="";
		document.getElementsByName("hidden_name")[0].value="";
		document.getElementsByName("identification_method")[0].value="";	
		 document.getElementsByName("rpeople_type")[0].value="";
		 document.getElementsByName("hidden_yuanyin")[0].value="";
		 document.getElementsByName("hidden_type_s")[0].value="";
 
	    document.getElementsByName("whether_new")[0].value="";			    	 		
		document.getElementsByName("recognition_people")[0].value="";
		document.getElementsByName("report_date")[0].value="";	
	    document.getElementsByName("hidden_level")[0].value="";
	 	document.getElementsByName("project_no")[0].value="";	
	    document.getElementsByName("hidden_description")[0].value="";
	    
		  document.getElementsByName("mdetail_no")[0].value="";					 
		    document.getElementsByName("evaluation_date")[0].value="";
		    document.getElementsByName("evaluation_level")[0].value="";
			document.getElementsByName("evaluation_personnel")[0].value="";		
			document.getElementsByName("main_methods")[0].value="";				    			
		    document.getElementsByName("risk_levels")[0].value="";		
			document.getElementsByName("evaluation_state")[0].value="";
		    document.getElementsByName("harmful_consequences")[0].value="";	
			
			 document.getElementsByName("rectification_state")[0].value="";	 
		     document.getElementsByName("rectification_measures")[0].value="";	    		    
			 document.getElementsByName("rectification_measures_type")[0].value="";	
		    document.getElementsByName("rectification_date")[0].value="";
			document.getElementsByName("control_effect")[0].value="";		
			document.getElementsByName("rectification_head")[0].value="";		
			document.getElementsByName("rectification_people")[0].value="";		
			
			document.getElementsByName("rectification_reason")[0].value="";				    			
		    document.getElementsByName("action_plan")[0].value="";	 
		    document.getElementsByName("reward_state")[0].value="";
  		 document.getElementsByName("reward_level")[0].value="";	 
		     document.getElementsByName("reward_amount")[0].value="";	    		    
			 document.getElementsByName("cash_date")[0].value="";	
	}
	
	function openFile1(){
		var assessment_no = document.getElementsByName("assessment_no")[0].value;		
    	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/riskLevels.jsp?assessment_no="+assessment_no);
		  
	}  		 	  
	    
		function openFile2(){
			var corrective_no = document.getElementsByName("corrective_no")[0].value;		
	    	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/rectificationState.jsp?corrective_no="+corrective_no);
			  
		} 	
	   function openFile3(){
			var reward_no = document.getElementsByName("reward_no")[0].value;		
	    	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/rewardState.jsp?reward_no="+reward_no);
			  
		} 
	
	   function openAdd(){
		   window.open("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/homeFrame.jsp?optionP=1",'homeMain','height=600px,width=1024px,left=100px,top=50px,menubar=no,status=no,toolbar=no ', '');
			
		}

	    function toUploadFile(){
			popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/humanImportFile.jsp?project=<%=isProject%>");
	     }
	    
	//處理選中的值selected
	 function exitSelect(){		 
			var selectObj = document.getElementById("hazard_big");  
			var aa = document.getElementById("aa").value; 
			var bb = document.getElementById("bb").value;  
		    for(var i = 0; i<selectObj.length; i++){ 
		        if(selectObj.options[i].value == aa){ 
		        	selectObj.options[i].selected = 'selected';     
		        } 
		       }  
		    var hazardBig = "hazardBig="+ document.getElementById("aa").value;
		    var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);		 
			var selectObj2 = document.getElementById("hazard_center");
			document.getElementById("hazard_center").innerHTML="";
			selectObj2.add(new Option('请选择',""),0);

			if(HazardCenter.detailInfo!=null){
				for(var t=0;t<HazardCenter.detailInfo.length;t++){
					var templateMap = HazardCenter.detailInfo[t];
					selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
				}
			}     
		    for(var j = 0; j<selectObj2.length; j++){ 
		        if(selectObj2.options[j].value == bb){ 
		    
		        	selectObj2.options[j].selected = 'selected';     
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/addHseHidden.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
	 	popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/addHseHidden.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&hidden_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/addHseHidden.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&hidden_no="+ids);
	  	
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
		deleteEntities("update BGP_HSE_HIDDEN_INFORMATION e set e.bsflag='1' where e.hidden_no in ("+id+")");
		 valueNull();
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/hse_search.jsp?isProject=<%=isProject%>");
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
			
			var operation_post = document.getElementsByName("operation_post")[0].value;
			var hidden_name = document.getElementsByName("hidden_name")[0].value;		
			var identification_method = document.getElementsByName("identification_method")[0].value;			
			var hazard_big = document.getElementsByName("hazard_big")[0].value;		
			var hazard_center = document.getElementsByName("hazard_center")[0].value;		
			var whether_new = document.getElementsByName("whether_new")[0].value;			 		
			var recognition_people = document.getElementsByName("recognition_people")[0].value;
			var report_date = document.getElementsByName("report_date")[0].value;		
			var hidden_level = document.getElementsByName("hidden_level")[0].value;					 
			var hidden_description = document.getElementsByName("hidden_description")[0].value;		
			
			var rpeople_type = document.getElementsByName("rpeople_type")[0].value;	
			var hidden_yuanyin = document.getElementsByName("hidden_yuanyin")[0].value;	
			var hidden_type_s = document.getElementsByName("hidden_type_s")[0].value;

			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 
 
	 		if(operation_post==""){
	 			alert("作业场所/岗位不能为空，请填写！");
	 			return true;
	 		}
	 		
	 
	 		if(hidden_level==""){
	 			alert("隐患级别不能为空，请填写！");
	 			return true;
	 		}
	 		if(hidden_type_s==""){
	 			alert("隐患类别不能为空，请填写！");
	 			return true;
	 		}
	 		
	 		if(hidden_yuanyin==""){
	 			alert("隐患存在原因不能为空，请填写！");
	 			return true;
	 		}
	 		
	 		
			if(hazard_big==""){
	 			alert("隐患危害类型大类不能为空，请填写！");
	 			return true;
	 		}
			if(hazard_center==""){
	 			alert("隐患危害类型小类不能为空，请填写！");
	 			return true;
	 		}
			 
			if(report_date==""){
	 			alert("上报日期不能为空，请填写！");
	 			return true;
	 		}
	 
			if(hidden_description==""){
	 			alert("隐患描述不能为空，请填写！");
	 			return true;
	 		}
	 		
	 		return false;
	 	}
	 	
		
		
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};		
		var hidden_no = document.getElementsByName("hidden_no")[0].value;						 
		  if(hidden_no !=null && hidden_no !=''){		
				if(checkJudge()){
					return;
				}
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
				
				var operation_post = document.getElementsByName("operation_post")[0].value;
				var hidden_name = document.getElementsByName("hidden_name")[0].value;		
				var identification_method = document.getElementsByName("identification_method")[0].value;			
				var hazard_big = document.getElementsByName("hazard_big")[0].value;		
				var hazard_center = document.getElementsByName("hazard_center")[0].value;		
				var whether_new = document.getElementsByName("whether_new")[0].value;			
		 		
				var recognition_people = document.getElementsByName("recognition_people")[0].value;
				var report_date = document.getElementsByName("report_date")[0].value;		
				var hidden_level = document.getElementsByName("hidden_level")[0].value;					 
				var hidden_description = document.getElementsByName("hidden_description")[0].value;			
				var project_no = document.getElementsByName("project_no")[0].value;						 
				
				var rpeople_type = document.getElementsByName("rpeople_type")[0].value;	
				var hidden_yuanyin = document.getElementsByName("hidden_yuanyin")[0].value;	
				var hidden_type_s = document.getElementsByName("hidden_type_s")[0].value;	
				 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				
				rowParam['operation_post'] = encodeURI(encodeURI(operation_post));
				rowParam['hidden_name'] = encodeURI(encodeURI(hidden_name));
				rowParam['identification_method'] = encodeURI(encodeURI(identification_method));
				rowParam['hazard_big'] = encodeURI(encodeURI(hazard_big));		 		
				rowParam['hazard_center'] = encodeURI(encodeURI(hazard_center));
				rowParam['whether_new'] = encodeURI(encodeURI(whether_new));						
				rowParam['recognition_people'] = encodeURI(encodeURI(recognition_people));
				rowParam['report_date'] = report_date;
				rowParam['hidden_level'] = encodeURI(encodeURI(hidden_level));
				rowParam['hidden_description'] = encodeURI(encodeURI(hidden_description));
					
				rowParam['rpeople_type'] = encodeURI(encodeURI(rpeople_type));
				rowParam['hidden_yuanyin'] = encodeURI(encodeURI(hidden_yuanyin));
				rowParam['hidden_type_s'] = encodeURI(encodeURI(hidden_type_s));
				
			    rowParam['hidden_no'] = hidden_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_HSE_HIDDEN_INFORMATION",rows);	
			    refreshData();	
			    valueNull();
				  
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
	
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '保存成功';
		if(failHint==undefined) failHint = '保存失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
			//window.opener.refreshData();
			//window.close();
		}
	}
 

	function checkJudge1(){
		var evaluation_date = document.getElementsByName("evaluation_date")[0].value;						 
	    var evaluation_level=document.getElementsByName("evaluation_level")[0].value;
		var evaluation_personnel=document.getElementsByName("evaluation_personnel")[0].value;		
		var main_methods=document.getElementsByName("main_methods")[0].value;				    			
	    var risk_levels=document.getElementsByName("risk_levels")[0].value;		
		var evaluation_state=document.getElementsByName("evaluation_state")[0].value;	
		var harmful_consequences=document.getElementsByName("harmful_consequences")[0].value;	
		
  
		if(risk_levels==""){
 			alert("风险级别不能为空，请填写！");
 			return true;
 		}
 
		if(harmful_consequences==""){
 			alert("危害后果不能为空，请填写！");
 			return true;
 		}
 
 		return false;
 	}
 	

	function checkJudge2(){
		 var rectification_state=document.getElementsByName("rectification_state")[0].value;	 
		 var rectification_measures=document.getElementsByName("rectification_measures")[0].value;	    		    
		 var rectification_measures_type=document.getElementsByName("rectification_measures_type")[0].value;	
		 var rectification_date=document.getElementsByName("rectification_date")[0].value;
		 var control_effect=document.getElementsByName("control_effect")[0].value;		
		 var rectification_reason=document.getElementsByName("rectification_reason")[0].value;				    			
		 var action_plan=document.getElementsByName("action_plan")[0].value;		
		
		 
 		if(rectification_state==""){
 			alert("整改状态不能为空，请填写！");
 			return true;
 		}
 
 		if(rectification_measures==""){
 			alert("整改或监控措施不能为空，请填写！");
 			return true;
 		}
 
 
		if(control_effect==""){
 			alert("控制效果不能为空，请填写！");
 			return true;
 		}
 
 		return false;
 	}
	
	function checkJudge3(){
		var reward_level= document.getElementsByName("reward_level")[0].value;
		var reward_amount= document.getElementsByName("reward_amount")[0].value;		    
		var cash_date= document.getElementsByName("cash_date")[0].value;	
		var reward_state= document.getElementsByName("reward_state")[0].value;		
		
		 
		if(reward_level==""){
			alert("奖励级别不能为空，请填写！");
			return true;
		}
		if(reward_amount==""){
			alert("奖励金额(元)不能为空，请选择！");
			return true;
		}
		if(cash_date==""){
			alert("兑现日期不能为空，请填写！");
			return true;
		}

		if(reward_state==""){
			alert("奖励状态不能为空，请填写！");
			return true;
		}
		 
		
		return false;
	}
	function toUpdate1(nullParam){		
		var rowParams = new Array(); 
		var rowParam = {};		
		var hidden_no = document.getElementsByName("hidden_no")[0].value;						 
		  if(hidden_no !=null && hidden_no !=''){		
			
			  if(nullParam =='1'){
					if(checkJudge1()){
						return;
					} 
			  }
			  
			  if(nullParam =='2'){
					if(checkJudge2()){
						return;
					} 
			  }
	 
			   
				var mdetail_no = document.getElementsByName("mdetail_no")[0].value;
				var evaluation_date = document.getElementsByName("evaluation_date")[0].value;						 
	    	    var evaluation_level=document.getElementsByName("evaluation_level")[0].value;
	    		var evaluation_personnel=document.getElementsByName("evaluation_personnel")[0].value;		
	    		var main_methods=document.getElementsByName("main_methods")[0].value;				    			
	    	    var risk_levels=document.getElementsByName("risk_levels")[0].value;		
	    		var evaluation_state=document.getElementsByName("evaluation_state")[0].value;	
	    	    var harmful_consequences=document.getElementsByName("harmful_consequences")[0].value;		
	    		
				 var rectification_state=document.getElementsByName("rectification_state")[0].value;	 
				 var rectification_measures=document.getElementsByName("rectification_measures")[0].value;	    		    
				 var rectification_measures_type=document.getElementsByName("rectification_measures_type")[0].value;	
				 var rectification_date=document.getElementsByName("rectification_date")[0].value;
				 var control_effect=document.getElementsByName("control_effect")[0].value;		
				 
				 var rectification_head=document.getElementsByName("rectification_head")[0].value;			 			    			
				 var rectification_people=document.getElementsByName("rectification_people")[0].value;		
				 
				 var rectification_reason=document.getElementsByName("rectification_reason")[0].value;				    			
				 var action_plan=document.getElementsByName("action_plan")[0].value;		
				 
				 if(rectification_state =="2"){
					 if(rectification_reason ==""){
						 alert("整改状态选择未整改时,未整改原因必填!");
						 return;
					 }
					 if(action_plan ==""){
						 alert("整改状态选择未整改时,整改计划必填!");
						 return;
					 }
				 }
					var reward_level= document.getElementsByName("reward_level")[0].value;
					var reward_amount= document.getElementsByName("reward_amount")[0].value;		    
					var cash_date= document.getElementsByName("cash_date")[0].value;	
					var reward_state= document.getElementsByName("reward_state")[0].value;
					
    				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
    				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_HIDDEN_INFORMATION&JCDP_TABLE_ID='+hidden_no +'&subflag=1';
    			    syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
				//	alert(mdetail_no);alert(hidden_no);
	    	     	rowParam['mdetail_no'] =  mdetail_no;	    			
	    	     	rowParam['hidden_no'] =  hidden_no;
					rowParam['evaluation_date'] =  '<%=curDate%>';
					rowParam['evaluation_level'] = encodeURI(encodeURI(evaluation_level));
					rowParam['evaluation_personnel'] = encodeURI(encodeURI(evaluation_personnel));
					rowParam['main_methods'] = encodeURI(encodeURI(main_methods));
					rowParam['risk_levels'] = encodeURI(encodeURI(risk_levels));
					rowParam['evaluation_state'] = encodeURI(encodeURI("已评价"));			
					rowParam['harmful_consequences'] = encodeURI(encodeURI(harmful_consequences));
					
					rowParam['rectification_state'] =  rectification_state;
					rowParam['rectification_measures'] = encodeURI(encodeURI(rectification_measures));
					rowParam['rectification_measures_type'] = encodeURI(encodeURI(rectification_measures_type));
					rowParam['rectification_date'] = encodeURI(encodeURI(rectification_date));
					rowParam['control_effect'] = encodeURI(encodeURI(control_effect));
					rowParam['rectification_head'] = encodeURI(encodeURI(rectification_head));
					rowParam['rectification_people'] = encodeURI(encodeURI(rectification_people));
					rowParam['rectification_reason'] = encodeURI(encodeURI(rectification_reason));
					rowParam['action_plan'] = encodeURI(encodeURI(action_plan));
					
					
					rowParam['reward_level'] = encodeURI(encodeURI(reward_level));
					rowParam['reward_amount'] =reward_amount;
					rowParam['cash_date'] = encodeURI(encodeURI(cash_date));
					rowParam['reward_state'] = encodeURI(encodeURI(reward_state));
	 
				if(mdetail_no !=null && mdetail_no !=''){
					rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] ='<%=curDate%>';		
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';	
					rowParam['bsflag'] = '0';
				}else{				 
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = '0';
				}
				
				
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_HIDDEN_INFORMATION_DETAIL",rows);	
			    refreshData();	
			    valueNull();
				  
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

