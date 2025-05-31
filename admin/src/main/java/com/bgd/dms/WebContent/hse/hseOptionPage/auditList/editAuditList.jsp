<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<% 
 	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubIds = request.getParameter("orgSubId");	 
	if (orgSubIds == null || orgSubIds.equals("")){
		orgSubIds = user.getOrgSubjectionId();
	}
    ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String auditlist_id="";
	if(request.getParameter("auditlist_id") != null){
		auditlist_id=request.getParameter("auditlist_id");	
		
	}
    String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<title>审核定级评分</title>
 <link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
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
<style type="text/css">
#new_table_box {
	width:1280px;
	height:640px;
}
#new_table_box_content {
	width:1260px;
	height:668px;
	border:1px #999 solid;
	background:#fff;
	padding:10px;
}
#new_table_box_bg {
	width:1240px;
	height:580px;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
</style>
</head>
<body  >
 
<div id="new_table_box">
	<div id="new_table_box_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 0px;">
			<tr>
				 <td class="inquire_item6"><font color="red">*</font>单位：</td>
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
			    	<input type="hidden" id="project_no" name="project_no" value="" />
			      	<input type="hidden" id="auditlist_id" name="auditlist_id"   />
			       	<input type="hidden" id="third_org" name="third_org" class="input_width" />
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			      	<%}%>
			      	</td>
			      	
		    </tr>
		</table>
    	<div id="new_table_box_bg">
		<div id="tab_box" class="tab_box">
					<table id="table1" width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
						<tr>
							<td colspan="8" align="center"><font size="5"><strong >物探队通用HSE管理审核清单</strong></font></td>
						</tr>
	
						<tr>
							<td width="8%" align="center"><strong >审核级别：</strong></td>
							<td width="16%" align="center">
						   <select id="audit_level" name="audit_level" class="select_width">
					       <option value="" >请选择</option> 
					       <option value="1" >公司</option>
					       <option value="2" >二级单位</option>
					       <option value="3" >基层单位</option>  
						</select>    </td>
							<td width="9%" align="center"><strong >审核人员：</strong></td>
						  <td width="16%" align="center"> <input type="text" id="audit_personnel" name="audit_personnel" value="" class="input_width"/></td>
						    <td width="10%" align="center"><strong >审核时间：</strong ></td>
						  <td width="21%" align="center"> <input type="text" id="audit_time" name="audit_time" value="" class="input_width"/>
						   &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(audit_time,tributton1);" /> 
						  </td>
			  				<td width="6%" align="center" ><strong >等级：</strong></td>
						  <td width="14%" align="center"><input type="text" id="auditlist_level" name="auditlist_level" value="自动评级"  style="color:gray;" readonly="readonly"   class="input_width"/></td>
						</tr> 
					</table>
					<table id="analysis"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 0px;" >
						<tr>
							<td width="15%"  align="center"><strong >要 素</strong></td>
							<td width="31%" align="center"><strong >审核内容</strong></td>
							<td width="13%"  align="center"><strong >标准分数</strong></td>
							<td colspan="3" align="center"><strong>要素总分</strong></td>
							<td width="12%" align="center"><strong>单项得分</strong></td>
							<td width="10%"  align="center"><strong>要素实际得分</strong></td>
							<td width="10%"   align="center"><strong>要素综合得分</strong></td> 
						</tr>
					 	<tr>
					 	  <td width="15%" rowspan="6"  align="center">
						  <input type="hidden" id="bsflag0" name="bsflag0" value="0" />
							<input type="hidden" id="create_date0" name="create_date0" value="" />
							<input type="hidden" id="creator0" name="creator0" value="" />
							<input type="hidden" id="one_no0" name="one_no0"   />
						  <input type="text" id="elements0"  style="width:180px;"   name="elements0" value="5.1领导和承诺"  readonly="readonly" class="input_width"/></td>
					 	  <td align="center">
						  	<input type="hidden" id="two_no00" name="two_no00"   />
							 <input type="hidden" id="one_no00" name="one_no00"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content00" name="audit_content00"   class="textarea">1.1 基层单位正职联系实际编制HSE培训课件进行理念宣贯（包括方针、政策、承诺、原则、禁令、目标等），做到全员培训；
1.2 管理理念目视化(分会议室、食堂、院区确定张贴的内容)；
1.3 员工对宣贯的认可，及对方针、原则、禁令的掌握（随机抽查不少于5人）；
上一级单位主要领导亲自宣贯HSE管理理念，包括方针、政策、承诺、原则、禁令、目标等。（不计入基层得分） </textarea></td>
					 	  <td  align="center"><input type="text" id="standard_scor00"   onblur="biaoZhun('0');allNumber();chuNumber()" style="width:120px;"  name="standard_scor00" value="15" class="input_width"/></td>
					 	  <td colspan="3" rowspan="6" align="center"><input type="text"    readonly="readonly" id="factor_score0" style="width:120px;"  name="factor_score0" value="85" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score00"  onblur="danxiang('0');allNumber()"  name="individual_score00"  style="width:120px;"  value="15" class="input_width"/></td>
					 	  <td width="10%" rowspan="6"  align="center"><input type="text" id="actual_score0"    readonly="readonly"  name="actual_score0" style="width:120px;"   value="85" class="input_width"/></td>
					 	  <td width="10%" rowspan="6"   align="center"><input type="text" id="comprehensive_score0"  readonly="readonly"  name="comprehensive_score0" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  <tr> 
								 <td align="center">
						  	 <input type="hidden" id="two_no01" name="two_no01"   />
							 <input type="hidden" id="one_no01" name="one_no01"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content01" name="audit_content01"   class="textarea">1.4 成立HSE管理小组（组长由队经理担任，副组长由指导员、HSE 副经理或主管HSE工作的副经理担任，成员应包括其他队领导、HSE 管理员、地球							  
1.5 正职定期（不低于每月1次）组织召开HSE管理小组会议并对HSE工作形势进行分析，会议决定得到落实，存在问题得到整改。
要求：专题会议、专门的会议记录；
内容：安全经验分享、事故事件分析、隐患识别与风险控制分析、上次会议安排的回顾、培训工作落实、下步工作安排。  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor01"  onblur="biaoZhun('0');allNumber();chuNumber()" name="standard_scor01" value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score01"  onblur="danxiang('0');allNumber();chuNumber()" name="individual_score01" value="15" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  	 		<tr> 
								 <td align="center">
						  	 <input type="hidden" id="two_no02" name="two_no02"   />
							 <input type="hidden" id="one_no02" name="one_no02"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content02" name="audit_content02"   class="textarea">1.6  地震队正职应参加本队组织的全部HSE检查或审核。
1.7 正职应亲自参与的内容：领导和承诺、作业许可、合规性评价；安全联系点及相关业务；	
1.8 跟踪验证问题整改情况；  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor02"  onblur="biaoZhun('0');allNumber();chuNumber()"  name="standard_scor02" value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score02"  onblur="danxiang('0');allNumber();chuNumber()"  name="individual_score02" value="10" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  	 	<tr> 
								 <td align="center">
						  	 <input type="hidden" id="two_no03" name="two_no03"   />
							 <input type="hidden" id="one_no03" name="one_no03"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content03" name="audit_content03"   class="textarea">1.9 地震队领导每月至少应到联系点进行一次到位检查，按检查表逐项检查，并留有记录；
1.10 领导联系点应实施目视化管理； </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor03" name="standard_scor03"  onblur="biaoZhun('0');allNumber();chuNumber()"  value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score03" name="individual_score03"  onblur="danxiang('0');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  	 	<tr> 
								 <td align="center">
						  	 <input type="hidden" id="two_no04" name="two_no04"   />
							 <input type="hidden" id="one_no04" name="one_no04"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content04" name="audit_content04"   class="textarea">1.11 班组长及以上管理人员按照直线管理的模式制定并实施个人安全行动计划；（内容：组织会议、培训、参加事故事件调查、跟踪验证问题整改
1.12 通过层级沟通的方式制定和实施，并按规定定期沟通，完成情况有记载。	  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor04" name="standard_scor04"  onblur="biaoZhun('0');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score04" name="individual_score04"  onblur="danxiang('0');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  <tr> 
								 <td width="31%" align="center">
						  	 <input type="hidden" id="two_no05" name="two_no05"   />
							 <input type="hidden" id="one_no05" name="one_no05"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content05" name="audit_content05"   class="textarea">1.13 单位安全观察与沟通（包含班组长及以上人员），频次为每周；
1.14 班组长及以上人员按计划开展行为安全观察和沟通活动；（有计划的活动应是小组行为，不是个体行为，1-3人）；
1.15 每月进行数据统计分析；
1.16 正职组织建议措施的整改落实。 
1.17 安技措费用投入计划及落实情况。  </textarea></td>
					 	  <td width="13%"  align="center"> <input type="text" id="standard_scor05" name="standard_scor05"  onblur="biaoZhun('0');allNumber();chuNumber()"  value="25" style="width:120px;"  class="input_width"/>	</td>
					 	  <td align="center"> <input type="text" id="individual_score05" name="individual_score05" value="25"  onblur="danxiang('0');allNumber();chuNumber()" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					

					  <tr>
					 	  <td width="15%"  align="center">
						  	 <input type="hidden" id="bsflag1" name="bsflag1" value="0" />
							<input type="hidden" id="create_date1" name="create_date1" value="" />
							<input type="hidden" id="creator1" name="creator1" value="" />
							<input type="hidden" id="one_no1" name="one_no1"   />
					    <input type="text" id="elements1"   style="width:180px;"   readonly="readonly"  name="elements1" value="5.2HSE方针" class="input_width"/>							  </td>
					 	  <td align="center">
						   <input type="hidden" id="two_no10" name="two_no10"   />
							 <input type="hidden" id="one_no10" name="one_no10"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content10" name="audit_content10"   class="textarea">2.1 领导知晓方针的基本内容，能举例说明1-2个应用的例子；
2.2 员工知晓方针的基本内容，了解HSE方针和本岗位工作的关系。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor10"   onblur="biaoZhun('1');allNumber();chuNumber()" style="width:120px;"  name="standard_scor10" value="15" class="input_width"/></td>
					 	  <td colspan="3"   align="center"><input type="text" id="factor_score1" style="width:120px;"   readonly="readonly"  name="factor_score1" value="15" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score10" name="individual_score10"  onblur="danxiang('1');allNumber();chuNumber()"  style="width:120px;"  value="15" class="input_width"/></td>
					 	  <td   align="center"><input type="text" id="actual_score1" name="actual_score1" style="width:120px;"   readonly="readonly"   value="15" class="input_width"/></td>
					 	  <td    align="center"><input type="text" id="comprehensive_score1" name="comprehensive_score1"    readonly="readonly" style="width:120px;"  value="15" class="input_width"/></td>
			 	      </tr>
					  
					  <tr>
					 	  <td width="15%" rowspan="2"  align="center">
						  	 <input type="hidden" id="bsflag2" name="bsflag2" value="0" />
							<input type="hidden" id="create_date2" name="create_date2" value="" />
							<input type="hidden" id="creator2" name="creator2" value="" />
							<input type="hidden" id="one_no2" name="one_no2"   />
					    <input type="text" id="elements2"   style="width:180px;"   readonly="readonly"   name="elements2" value="5.3.1对危害因素辨识、 风险评价和风险控制的策划" class="input_width"/>							  </td>
					 	  <td align="center">
						  		 <input type="hidden" id="two_no20" name="two_no20"   />
							 <input type="hidden" id="one_no20" name="one_no20"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content20" name="audit_content20"   class="textarea">3.1 队经理根据踏勘情况，集中组织相关人员进行项目总体风险评价（用风险矩阵法或LEC）；
3.2 针对重点作业风险应进行工作安全分析（有记录），制定切实可行的控制措施；
3.3 制定项目HSE作业计划书（工作任务分工合理）；并对员工进行相关内容的培训。
3.4 根据工区变化情况，各级属地主管随机组织开展危害因素（隐患）辨识、风险评价、隐患原因分析、制定和实施控制措施；
3.5 地震队在开展HSE检查（每月）和审核时应对危害因素（隐患）辨识、风险评价与控制的实施情况与效果进行评审。危害因素（隐患）信息及时录 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor20"  onblur="biaoZhun('2');allNumber();chuNumber()"  style="width:120px;"  name="standard_scor20" value="25" class="input_width"/></td>
					 	  <td colspan="3" rowspan="2" align="center"><input type="text" id="factor_score2" style="width:120px;" readonly="readonly"   name="factor_score2" value="40" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score20"  onblur="danxiang('2');allNumber();chuNumber()"  name="individual_score20"  style="width:120px;"  value="25" class="input_width"/></td>
					 	  <td width="10%" rowspan="2"  align="center"><input type="text" id="actual_score2" name="actual_score2" style="width:120px;"  readonly="readonly"   value="40" class="input_width"/></td>
				 	    <td width="10%" rowspan="2"   align="center"><input type="text" id="comprehensive_score2" readonly="readonly"   name="comprehensive_score2" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 <tr>
					 	  <td align="center">
						   <input type="hidden" id="two_no21" name="two_no21"   />
							 <input type="hidden" id="one_no21" name="one_no21"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content21" name="audit_content21"   class="textarea">3.6 实施全员隐患识别报告激励制度（有台账、有奖励记录、有整改记录），实施月度分析。	  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor21"  onblur="biaoZhun('2');allNumber();chuNumber()" name="standard_scor21" value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input name="individual_score21" type="text"   onblur="danxiang('2');allNumber();chuNumber()" class="input_width" id="individual_score21" style="width:120px;" value="15"/></td>
				 	  </tr>
					  
					   <tr>
					 	  <td width="15%" rowspan="2"  align="center">
						    	 <input type="hidden" id="bsflag3" name="bsflag3" value="0" />
							<input type="hidden" id="create_date3" name="create_date3" value="" />
							<input type="hidden" id="creator3" name="creator3" value="" />
							<input type="hidden" id="one_no3" name="one_no3"   />
					     <input type="text" id="elements3"   style="width:180px;"   readonly="readonly"  name="elements3" value="5.3.2法律法规和其他要求" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no30" name="two_no30"   />
							 <input type="hidden" id="one_no30" name="one_no30"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content30" name="audit_content30"   class="textarea">3.7 地震队应根据工区情况、辨识的危害因素等情况收集适用的HSE相关法律、法规和其他要求（包括当地政府发布的相关法规，上级发布的适用的制
3.8 在相关法律法规文本标注适用条款；
3.9 开工前进行有效性评审，文本适用、有效。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor30"  onblur="biaoZhun('3');allNumber();chuNumber()" style="width:120px;"  name="standard_scor30" value="10" class="input_width"/></td>
					 	  <td colspan="3" rowspan="2" align="center"><input type="text" id="factor_score3" style="width:120px;" readonly="readonly"   name="factor_score3" value="20" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score30"  onblur="danxiang('3');allNumber();chuNumber()" name="individual_score30"  style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%" rowspan="2"  align="center"><input type="text" id="actual_score3" name="actual_score3" readonly="readonly"  style="width:120px;"   value="20" class="input_width"/></td>
				 	     <td width="10%" rowspan="2"   align="center"><input type="text" id="comprehensive_score3"  readonly="readonly"  name="comprehensive_score3" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no31" name="two_no31"   />
							 <input type="hidden" id="one_no31" name="one_no31"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content31" name="audit_content31"   class="textarea">3.10 适用的法律、法规和其他要求传达到相关岗位；
3.11 制定的控制措施、规章制度、操作程序等文件符合法律、法规和其他要求。   </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor31"  onblur="biaoZhun('3');allNumber();chuNumber()" name="standard_scor31" value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score31"  onblur="danxiang('3');allNumber();chuNumber()"  name="individual_score31" value="10" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  
					   <tr>
					 	  <td width="15%" rowspan="3"  align="center">
						  							    	 <input type="hidden" id="bsflag4" name="bsflag4" value="0" />
							<input type="hidden" id="create_date4" name="create_date4" value="" />
							<input type="hidden" id="creator4" name="creator4" value="" />
							<input type="hidden" id="one_no4" name="one_no4"   />
					     <input type="text" id="elements4"   style="width:180px;"   readonly="readonly"  name="elements4" value="5.3.3目标和指标" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no40" name="two_no40"   />
							 <input type="hidden" id="one_no40" name="one_no40"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content40" name="audit_content40"   class="textarea">3.12 制定符合基层单位实际的HSE目标和控制指标；
3.13 目标和指标设置满足上级要求。  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor40"  style="width:120px;"  onblur="biaoZhun('4');allNumber();chuNumber()"   name="standard_scor40" value="5" class="input_width"/></td>
					 	  <td colspan="3" rowspan="3" align="center"><input type="text" id="factor_score4" style="width:120px;" readonly="readonly"    name="factor_score4" value="40" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score40" name="individual_score40"  onblur="danxiang('4');allNumber();chuNumber()"   style="width:120px;"  value="5" class="input_width"/></td>
					 	  <td width="10%" rowspan="3"  align="center"><input type="text" id="actual_score4" name="actual_score4" readonly="readonly"   style="width:120px;"   value="40" class="input_width"/></td>
				 	     <td width="10%" rowspan="3"   align="center"><input type="text" id="comprehensive_score4" readonly="readonly"  name="comprehensive_score4" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no41" name="two_no41"   />
							 <input type="hidden" id="one_no41" name="one_no41"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content41" name="audit_content41"   class="textarea">3.14 将基层单位HSE目标进行分解（目标分解要有针对性，符合班组实际),层层签订HSE责任书，签到班组；
3.15 员工了解本班组目标和指标。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor41" name="standard_scor41"  onblur="biaoZhun('4');allNumber();chuNumber()"  value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score41" name="individual_score41"  onblur="danxiang('4');allNumber();chuNumber()"  value="15" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  	 <tr>
					 	  <td align="center">
						   <input type="hidden" id="two_no42" name="two_no42"   />
							 <input type="hidden" id="one_no42" name="one_no42"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content42" name="audit_content42"   class="textarea">3.16 基层单位HSE目标、指标的完成，员工HSE绩效考核的目标制定及考核做到层级沟通，兑现有记录。  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor42" name="standard_scor42"  onblur="biaoZhun('4');allNumber();chuNumber()"   value="20" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score42" name="individual_score42"  onblur="danxiang('4');allNumber();chuNumber()"  value="20" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  
					  
					    <tr>
					 	  <td width="15%"  align="center">
						  	  <input type="hidden" id="bsflag5" name="bsflag5" value="0" />
							<input type="hidden" id="create_date5" name="create_date5" value="" />
							<input type="hidden" id="creator5" name="creator5" value="" />
							<input type="hidden" id="one_no5" name="one_no5"   />
						  <input type="text" id="elements5"   style="width:180px;"   readonly="readonly"   name="elements5" value="5.3.4管理方案" class="input_width"/>							  </td>
					 	  <td align="center">
						  		 <input type="hidden" id="two_no50" name="two_no50"   />
							 <input type="hidden" id="one_no50" name="one_no50"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content50" name="audit_content50"   class="textarea">3.17 管理方案明确责任人、完成时间、工作方法及措施、所需资源等内容；
3.18 管理方案传达到相关人员；
3.19 对完成情况要验证。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor50"  style="width:120px;"  onblur="biaoZhun('5');allNumber();chuNumber()"   name="standard_scor50" value="30" class="input_width"/></td>
					 	  <td colspan="3"   align="center"><input type="text" id="factor_score5" style="width:120px;"  name="factor_score5" readonly="readonly"   value="30" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score50" name="individual_score50"  onblur="danxiang('5');allNumber();chuNumber()"   style="width:120px;"  value="30" class="input_width"/></td>
					 	  <td   align="center"><input type="text" id="actual_score5" name="actual_score5" style="width:120px;"  readonly="readonly"   value="30" class="input_width"/></td>
					 	  <td    align="center"><input type="text" id="comprehensive_score5" name="comprehensive_score5" readonly="readonly"  style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  
					    <tr>
					 	  <td width="15%"  align="center">
						  	 <input type="hidden" id="bsflag6" name="bsflag6" value="0" />
							<input type="hidden" id="create_date6" name="create_date6" value="" />
							<input type="hidden" id="creator6" name="creator6" value="" />
							<input type="hidden" id="one_no6" name="one_no6"   />
						  <input type="text" id="elements6"   style="width:180px;"   readonly="readonly"   name="elements6" value="5.4.1组织结构和职责" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no60" name="two_no60"   />
							 <input type="hidden" id="one_no60" name="one_no60"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content60" name="audit_content60"   class="textarea">4.1 设置HSE专兼职管理人员；			
4.2 制定直线管理结构图（车间、队站级）；	
4.3 划分属地，属地无遗漏，并明晰属地职责；
4.4 岗位人员清楚自身职责。	  </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor60"  style="width:120px;"  onblur="biaoZhun('6');allNumber();chuNumber()"   name="standard_scor60" value="30" class="input_width"/></td>
					 	  <td colspan="3"   align="center"><input type="text" id="factor_score6" style="width:120px;" readonly="readonly"   name="factor_score6" value="30" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score60" name="individual_score60"   onblur="danxiang('6');allNumber();chuNumber()"  style="width:120px;"  value="30" class="input_width"/></td>
					 	  <td   align="center"><input type="text" id="actual_score6" name="actual_score6" style="width:120px;"  readonly="readonly"   value="30" class="input_width"/></td>
					 	  <td    align="center"><input type="text" id="comprehensive_score6" name="comprehensive_score6" style="width:120px;" readonly="readonly"   value="1000" class="input_width"/></td>
			 	      </tr>
					    <tr>
					 	  <td width="15%"  align="center"> 	 <input type="hidden" id="bsflag7" name="bsflag7" value="0" />
							<input type="hidden" id="create_date7" name="create_date7" value="" />
							<input type="hidden" id="creator7" name="creator7" value="" />
							<input type="hidden" id="one_no7" name="one_no7"   />
						  <input type="text" id="elements7"   style="width:180px;"   readonly="readonly"   name="elements7" value="5.4.2管理者代表" class="input_width"/>							  </td>
					 	  <td align="center">
						    <input type="hidden" id="two_no70" name="two_no70"   />
							 <input type="hidden" id="one_no70" name="one_no70"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content70" name="audit_content70"   class="textarea">4.5 物探队不设置管理者代表</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor70"  style="width:120px;"  onblur="biaoZhun('7');allNumber();chuNumber()"   name="standard_scor70" value="5" class="input_width"/></td>
					 	  <td colspan="3"   align="center"><input type="text" id="factor_score7" style="width:120px;"  name="factor_score7" readonly="readonly"  value="5" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score70" name="individual_score70"  onblur="danxiang('7');allNumber();chuNumber()"   style="width:120px;"  value="5" class="input_width"/></td>
					 	  <td   align="center"><input type="text" id="actual_score7" name="actual_score7" style="width:120px;"  readonly="readonly"   value="5" class="input_width"/></td>
					 	  <td    align="center"><input type="text" id="comprehensive_score7" name="comprehensive_score7" readonly="readonly"  style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  
					   <tr>
					 	  <td width="15%" rowspan="3"  align="center"> 	 <input type="hidden" id="bsflag8" name="bsflag8" value="0" />
							<input type="hidden" id="create_date8" name="create_date8" value="" />
							<input type="hidden" id="creator8" name="creator8" value="" />
							<input type="hidden" id="one_no8" name="one_no8"   />
					     <input type="text" id="elements8"   style="width:180px;"   readonly="readonly"   name="elements8" value="5.4.3资  源" class="input_width"/>							  </td>
				 	     <td align="center">
						  		 <input type="hidden" id="two_no80" name="two_no80"   />
							 <input type="hidden" id="one_no80" name="one_no80"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content80" name="audit_content80"   class="textarea">4.6 野外施工单位与驻地及施工地点医疗单位（县级以上）签订紧急医疗救助协议；乡（镇）级医院留有地址及有效的联系方式，并了解其医疗处置能力；与驻地医院（县级以上）签订医疗垃圾处理协议；
4.7 野外施工单位与驻地及施工地点气象主管部门（县级以上）签订气象信息协议；
4.8 与有关部门签订废油、废液的回收处置协议。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor80"  style="width:120px;"  onblur="biaoZhun('8');allNumber();chuNumber()"  name="standard_scor80" value="10" class="input_width"/></td>
					 	  <td colspan="3" rowspan="3" align="center"><input type="text" id="factor_score8" style="width:120px;" readonly="readonly"    name="factor_score8" value="40" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score80" name="individual_score80"  onblur="danxiang('8');allNumber();chuNumber()"   style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%" rowspan="3"  align="center"><input type="text" id="actual_score8" name="actual_score8" readonly="readonly"   style="width:120px;"   value="40" class="input_width"/></td>
				 	     <td width="10%" rowspan="3"   align="center"><input type="text" id="comprehensive_score8" readonly="readonly"   name="comprehensive_score8" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  	  		 <input type="hidden" id="two_no81" name="two_no81"   />
							 <input type="hidden" id="one_no81" name="one_no81"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content81" name="audit_content81"   class="textarea">4.9 根据生产需要进行资源配置，查计划、查清单、查实物（载人卡车及载人车辆、民爆储运设施、救护应急车、及应急物资等）；	
4.10 特殊施工区域配置急救、登山、救生等特殊专项技能人员及相关设备。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor81" name="standard_scor81"  onblur="biaoZhun('8');allNumber();chuNumber()"  value="20" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score81" name="individual_score81"   onblur="danxiang('8');allNumber();chuNumber()"  value="20" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no82" name="two_no82"   />
							 <input type="hidden" id="one_no82" name="one_no82"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content82" name="audit_content82"   class="textarea">4.11 特种作业人员、医护人员取得地方政府主管部门颁发的从业许可证件（查台账）；餐饮从业人员进行了健康体检，取得了疾控中心签发的健康证（查台账）。	
4.12 基层单位负责收集、传递作业区域的各类预警、预报信息。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor82" name="standard_scor82"  onblur="biaoZhun('8');allNumber();chuNumber()"  value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score82" name="individual_score82"  onblur="danxiang('8');allNumber();chuNumber()"  value="10" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  
					    <tr>
					 	  <td width="15%" rowspan="3"  align="center">  <input type="hidden" id="bsflag9" name="bsflag9" value="0" />
							<input type="hidden" id="create_date9" name="create_date9" value="" />
							<input type="hidden" id="creator9" name="creator9" value="" />
							<input type="hidden" id="one_no9" name="one_no9"   />
						  <input type="text" id="elements9"   style="width:180px;"   readonly="readonly"   name="elements9" value="5.4.4能力、培训和意识" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  	 <input type="hidden" id="two_no90" name="two_no90"   />
							 <input type="hidden" id="one_no90" name="one_no90"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content90" name="audit_content90"   class="textarea">4.13 根据培训矩阵，结合实际制定培训计划；
4.14 培训课件符合要求；
4.15 开工前的集中培训（查计划、查档案、与员工访谈）；	
4.16 施工过程中培训（访谈、查记录）；
4.17 班前会（符合班前会记录卡模板内容）。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor90"  style="width:120px;"  onblur="biaoZhun('9');allNumber();chuNumber()"   name="standard_scor90" value="28" class="input_width"/></td>
					 	  <td colspan="3" rowspan="3" align="center"><input type="text" id="factor_score9" style="width:120px;" readonly="readonly"   name="factor_score9" value="55" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score90" name="individual_score90"  onblur="danxiang('9');allNumber();chuNumber()"   style="width:120px;"  value="28" class="input_width"/></td>
					 	  <td width="10%" rowspan="3"  align="center"><input type="text" id="actual_score9" name="actual_score9" readonly="readonly"  style="width:120px;"   value="55" class="input_width"/></td>
					 	  <td width="10%" rowspan="3"   align="center"><input name="comprehensive_score9" type="text" readonly="readonly"  class="input_width" id="comprehensive_score9" style="width:120px;"  value="1000"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  		  	  	 <input type="hidden" id="two_no91" name="two_no91"   />
							 <input type="hidden" id="one_no91" name="one_no91"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content91" name="audit_content91"   class="textarea">4.18 依据属地管理、分级评价的原则实施员工能力评价。基层单位负责评价班组长、关键岗位（涉爆作业人员、特种作业人员、特种设备操作人员、载人卡/客车司机等）和专业技术人员。基层单位副职和班组长负责评价属地内员工；			
4.19 查看关键要害岗位的试题答卷，符合一票否决的相关要求；
4.20 员工能力评价结果与证实性资料（如资质证件、体检报告等）相符合。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor91" name="standard_scor91"  onblur="biaoZhun('9');allNumber();chuNumber()"  value="12" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score91" name="individual_score91"  onblur="danxiang('9');allNumber();chuNumber()"   value="12" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  	 <tr>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no92" name="two_no92"   />
							 <input type="hidden" id="one_no92" name="one_no92"   />
						  <textarea  style="width:350px;height:100px;" id="audit_content92" name="audit_content92"   class="textarea">4.21 员工掌握岗位风险及相关风险、控制措施等HSE知识和技能；
4.22 现场验证作业和操作程序的符合性。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor92" name="standard_scor92"  onblur="biaoZhun('9');allNumber();chuNumber()"  value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score92" name="individual_score92"  onblur="danxiang('9');allNumber();chuNumber()"   value="15" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  
					   <tr>
					 	  <td width="15%" rowspan="2"  align="center">
						    <input type="hidden" id="bsflag10" name="bsflag10" value="0" />
							<input type="hidden" id="create_date10" name="create_date10" value="" />
							<input type="hidden" id="creator10" name="creator10" value="" />
							<input type="hidden" id="one_no10" name="one_no10"   />
					     <input type="text" id="elements10"   style="width:180px;"   readonly="readonly"   name="elements10" value="5.4.5协商和沟通" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no100" name="two_no100"   />
							 <input type="hidden" id="one_no100" name="one_no100"   />
						  
						  <textarea  style="width:350px;height:100px;" id="audit_content100" name="audit_content100"   class="textarea">4.23 利用HSE管理小组会议、公告栏、班组活动、班前会、分委会等方式建立沟通渠道；	
4.24 内部信息（自上而下、自下而上、横向之间）的沟通渠道畅通，能够得到及时有效地沟通。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor100"  style="width:120px;"  onblur="biaoZhun('10');allNumber();chuNumber()"   name="standard_scor100" value="10" class="input_width"/></td>
					 	  <td colspan="3" rowspan="2" align="center"><input type="text" id="factor_score10" style="width:120px;" readonly="readonly"   name="factor_score10" value="15" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score100" name="individual_score100"  onblur="danxiang('10');allNumber();chuNumber()"   style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%" rowspan="2"  align="center"><input name="actual_score10" type="text" class="input_width" readonly="readonly"   id="actual_score10" style="width:120px;" value="15" /></td>
				 	     <td width="10%" rowspan="2"   align="center"><input type="text" id="comprehensive_score10" readonly="readonly"  name="comprehensive_score10" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no101" name="two_no101"   />
							 <input type="hidden" id="one_no101" name="one_no101"   />
						  
						  <textarea  style="width:350px;height:100px;" id="audit_content101" name="audit_content101"   class="textarea">4.25 建立单位以外（施工所在地政府、社区及相关方的要求、诉求，以走访、座谈等形式获取）信息的接收渠道，并统计、答复或传递。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor101" name="standard_scor101"  onblur="biaoZhun('10');allNumber();chuNumber()"   value="5" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score101" name="individual_score101"  onblur="danxiang('10');allNumber();chuNumber()"  value="5" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
<tr>
					 	  <td width="15%"   align="center">
						    <input type="hidden" id="bsflag11" name="bsflag11" value="0" />
							<input type="hidden" id="create_date11" name="create_date11" value="" />
							<input type="hidden" id="creator11" name="creator11" value="" />
							<input type="hidden" id="one_no11" name="one_no11"   />
	    <input type="text" id="elements11"   style="width:180px;"   readonly="readonly"  name="elements11" value="5.4.6文件" class="input_width"/>							  </td>
					 	  <td align="center">
						   <input type="hidden" id="two_no110" name="two_no110"   />
							 <input type="hidden" id="one_no110" name="one_no110"   /> 
							   <textarea  style="width:350px;height:100px;" id="audit_content110" name="audit_content110"   class="textarea">4.26 现场使用的标准、制度、操作规程等文件内容符合生产实际。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor110"  style="width:120px;"  onblur="biaoZhun('11');allNumber();chuNumber()"   name="standard_scor110" value="5" class="input_width"/></td>
					 	  <td colspan="3"  align="center"><input type="text" id="factor_score11" style="width:120px;"  name="factor_score11" readonly="readonly"   value="5" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score110" name="individual_score110"  onblur="danxiang('11');allNumber();chuNumber()"  style="width:120px;"  value="5" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="actual_score11" name="actual_score11" style="width:120px;" readonly="readonly"    value="5" class="input_width"/></td>
	    <td width="10%"    align="center"><input type="text" id="comprehensive_score11" name="comprehensive_score11" style="width:120px;" readonly="readonly"   value="1000" class="input_width"/></td>
		 	      </tr>
					   <tr>
					 	  <td width="15%"   align="center">
						  	  <input type="hidden" id="bsflag12" name="bsflag12" value="0" />
							<input type="hidden" id="create_date12" name="create_date12" value="" />
							<input type="hidden" id="creator12" name="creator12" value="" />
							<input type="hidden" id="one_no12" name="one_no12"   />
					     <input type="text" id="elements12"  style="width:180px;"   readonly="readonly"  name="elements12" value="5.4.7文件控制" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no120" name="two_no120"   />
							 <input type="hidden" id="one_no120" name="one_no120"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content120" name="audit_content120"   class="textarea">4.27 根据文件持有人不同确定是否对文件进行控制管理（HSE相关制度、作业计划书、应急处置预案、作业程序、接收的受控文件等）；
4.28 实施文件控制管理，包括审批、标识、发放、控制、评审、变更、作废、销毁等环节，建立受控文件清单，保留发放、销毁等记录；	
4.29 现场使用的文件现行有效。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor120"  style="width:120px;"  onblur="biaoZhun('12');allNumber();chuNumber()"  name="standard_scor120" value="10" class="input_width"/></td>
					 	  <td colspan="3"  align="center"><input type="text" id="factor_score12" style="width:120px;"   name="factor_score12" readonly="readonly"   value="10" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score120" name="individual_score120"  onblur="danxiang('12');allNumber();chuNumber()"   style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="actual_score12" name="actual_score12" style="width:120px;" readonly="readonly"    value="10" class="input_width"/></td>
				 	     <td width="10%"    align="center"><input type="text" id="comprehensive_score12" name="comprehensive_score12" readonly="readonly"   style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  
					     <tr>
					 	  <td width="15%" rowspan="2"  align="center">
						    <input type="hidden" id="bsflag13" name="bsflag13" value="0" />
							<input type="hidden" id="create_date13" name="create_date13" value="" />
							<input type="hidden" id="creator13" name="creator13" value="" />
							<input type="hidden" id="one_no13" name="one_no13"   />
						  <input type="text" id="elements13"   style="width:180px;"   readonly="readonly"  name="elements13" value="5.5.1设施完整性" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no130" name="two_no130"   />
							 <input type="hidden" id="one_no130" name="one_no130"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content130" name="audit_content130"   class="textarea">5.1 掌握设备、设施数量、性能、安全风险状况和应对措施等信息，关键设施设备安全分析结果应用情况。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor130"  style="width:120px;"  onblur="biaoZhun('13');allNumber();chuNumber()"   name="standard_scor130" value="20" class="input_width"/></td>
					 	  <td colspan="3" rowspan="2" align="center"><input type="text" id="factor_score13" style="width:120px;" readonly="readonly"   name="factor_score13" value="45" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score130" name="individual_score130"  onblur="danxiang('13');allNumber();chuNumber()"   style="width:120px;"  value="20" class="input_width"/></td>
					 	  <td width="10%" rowspan="2"  align="center"><input type="text" id="actual_score13" name="actual_score13" readonly="readonly"  style="width:120px;"   value="45" class="input_width"/></td>
					 	  <td width="10%" rowspan="2"   align="center"><input type="text" id="comprehensive_score13" readonly="readonly"  name="comprehensive_score13" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  	  	  <input type="hidden" id="two_no131" name="two_no131"   />
							 <input type="hidden" id="one_no131" name="one_no131"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content131" name="audit_content131"   class="textarea">5.2 对投入使用的设备设施要进行验收；	
5.3 设备设施及安全附件完好、有效（包括外租设备）；	
5.4 设备操作与维护规程或操作说明齐全有效；
5.5 使用过程中按设备运行计划进行检查、维护保养；	
5.6 设备管理目视化。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor131" name="standard_scor131"   onblur="biaoZhun('13');allNumber();chuNumber()"  value="25" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score131" name="individual_score131"  onblur="danxiang('13');allNumber();chuNumber()"  value="25" style="width:120px;"  class="input_width"/></td>
				 	  </tr>
					  
					  <tr>
					 	  <td width="15%" rowspan="5"  align="center">
					      <input type="hidden" id="bsflag14" name="bsflag14" value="0" />
							<input type="hidden" id="create_date14" name="create_date14" value="" />
							<input type="hidden" id="creator14" name="creator14" value="" />
							<input type="hidden" id="one_no14" name="one_no14"   />
					    <input type="text" id="elements14"   style="width:180px;"   readonly="readonly"   name="elements14" value="5.5.2承包方和供应方" class="input_width"/>							  </td>
					 	  <td align="center">
						    <input type="hidden" id="two_no140" name="two_no140"   />
							 <input type="hidden" id="one_no140" name="one_no140"   /> 
						  
						  <textarea  style="width:350px;height:100px;" id="audit_content140" name="audit_content140"   class="textarea">5.7 从合格承包商名录中选择承包商；	
5.8 基层单位主要领导参与承包商的选择；
5.9 对承包商进行开工前的验收(包括HSE资质、人员素质、设备、HSE业绩、管理方面)；
5.10 签订HSE协议，并明确相关的HSE责任。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor140"  style="width:120px;"  onblur="biaoZhun('14');allNumber();chuNumber()"   name="standard_scor140" value="20" class="input_width"/></td>
					 	  <td colspan="3" rowspan="5" align="center"><input type="text" id="factor_score14" style="width:120px;"  readonly="readonly"  name="factor_score14" value="70" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score140" name="individual_score140"  onblur="danxiang('14');allNumber();chuNumber()"   style="width:120px;"  value="20" class="input_width"/></td>
					 	  <td width="10%" rowspan="5"  align="center"><input type="text" id="actual_score14" name="actual_score14" readonly="readonly"  style="width:120px;"   value="70" class="input_width"/></td>
				 	    <td width="10%" rowspan="5"   align="center"><input type="text" id="comprehensive_score14" readonly="readonly"  name="comprehensive_score14" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no141" name="two_no141"   />
							 <input type="hidden" id="one_no141" name="one_no141"   /> 
						  
						  <textarea  style="width:350px;height:100px;" id="audit_content141" name="audit_content141"   class="textarea">5.11 施工过程中，对承包方HSE管理工作进行监督检查。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor141" name="standard_scor141"  onblur="biaoZhun('14');allNumber();chuNumber()"  value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score141" name="individual_score141"  onblur="danxiang('14');allNumber();chuNumber()"  value="15" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
					  			 	 <tr>
					 	  <td align="center">
						  	  	 <input type="hidden" id="two_no142" name="two_no142"   />
							 <input type="hidden" id="one_no142" name="one_no142"   /> 
						  
						  <textarea  style="width:350px;height:100px;" id="audit_content142" name="audit_content142"   class="textarea">5.12 承包商与基层单位执行统一的HSE规范和标准；	
5.13 明确承包商的属地主管。	 </textarea></td>
					 	  <td  align="center"> <input name="standard_scor142" type="text"  class="input_width"  onblur="biaoZhun('14');allNumber();chuNumber()"  id="standard_scor142" style="width:120px;" value="15"/></td>
					 	  <td align="center"> <input name="individual_score142" type="text"  class="input_width"  onblur="danxiang('14');allNumber();chuNumber()"  id="individual_score142" style="width:120px;" value="15"/></td>
				 	    </tr>
							 <tr>
					 	  <td align="center">
						  	  	 <input type="hidden" id="two_no143" name="two_no143"   />
							 <input type="hidden" id="one_no143" name="one_no143"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content143" name="audit_content143"   class="textarea">5.14 基层单位对承包商进行考核、评价。	 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor143" name="standard_scor143"  onblur="biaoZhun('14');allNumber();chuNumber()"   value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score143" name="individual_score143"   onblur="danxiang('14');allNumber();chuNumber()"  value="15" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
									 	 <tr>
					 	  <td align="center">
						    	  	 <input type="hidden" id="two_no144" name="two_no144"   />
							 <input type="hidden" id="one_no144" name="one_no144"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content144" name="audit_content144"   class="textarea">5.15 对入库的生产物资进行验收。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor144" name="standard_scor144"  onblur="biaoZhun('14');allNumber();chuNumber()"  value="5" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score144" name="individual_score144"  onblur="danxiang('14');allNumber();chuNumber()"  value="5" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						
					   <tr>
					 	  <td width="15%"   align="center">
				           <input type="hidden" id="bsflag15" name="bsflag15" value="0" />
							<input type="hidden" id="create_date15" name="create_date15" value="" />
							<input type="hidden" id="creator15" name="creator15" value="" />
							<input type="hidden" id="one_no15" name="one_no15"   />
					     <input type="text" id="elements15"   style="width:180px;"   readonly="readonly"   name="elements15" value="5.5.3顾客和产品" class="input_width"/>							  </td>
					 	  <td align="center">
						  	   <input type="hidden" id="two_no150" name="two_no150"   />
							 <input type="hidden" id="one_no150" name="one_no150"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content150" name="audit_content150"   class="textarea">5.16 收集甲方提出的HSE要求，并分析、处理;		
5.17 对于服务可能带来的风险及防范措施进行告知。</textarea></td>
					 	  <td  align="center"> <input  name="standard_scor150" type="text" class="input_width"  onblur="biaoZhun('15');allNumber();chuNumber()"  id="standard_scor150"  style="width:120px;" value="10"/></td>
					 	  <td colspan="3"  align="center"><input type="text" id="factor_score15" style="width:120px;" readonly="readonly"   name="factor_score15" value="10" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score150" name="individual_score150"  onblur="danxiang('15');allNumber();chuNumber()"   style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="actual_score15" name="actual_score15" readonly="readonly"  style="width:120px;"   value="10" class="input_width"/></td>
				 	     <td width="10%"    align="center"><input type="text" id="comprehensive_score15" readonly="readonly"  name="comprehensive_score15" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  
					   <tr>
					 	  <td width="15%"   align="center">
						  					           <input type="hidden" id="bsflag16" name="bsflag16" value="0" />
							<input type="hidden" id="create_date16" name="create_date16" value="" />
							<input type="hidden" id="creator16" name="creator16" value="" />
							<input type="hidden" id="one_no16" name="one_no16"   />
					     <input type="text" id="elements16"   style="width:180px;"   readonly="readonly"   name="elements16" value="5.5.4社区和公共关系" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no160" name="two_no160"   />
							 <input type="hidden" id="one_no160" name="one_no160"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content160" name="audit_content160"   class="textarea">5.18 了解作业区域的社会环境，知晓风土人情，尊重风俗习惯，遵守当地相关政策；	
5.19 收集社区活动对作业可能造成的影响；
5.20 通过沟通，改善与社区的公共关系，取得社区的支持；
5.21 向社区告知作业可能对社区产生的影响和应对方法。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor160"  style="width:120px;"   onblur="biaoZhun('16');allNumber();chuNumber()"  name="standard_scor160" value="10" class="input_width"/></td>
					 	  <td colspan="3"  align="center"><input type="text" id="factor_score16" style="width:120px;" readonly="readonly"   name="factor_score16" value="10" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score160" name="individual_score160"   onblur="danxiang('16');allNumber();chuNumber()"   style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="actual_score16" name="actual_score16" readonly="readonly"  style="width:120px;"   value="10" class="input_width"/></td>
				 	     <td width="10%"    align="center"><input type="text" id="comprehensive_score16" readonly="readonly"   name="comprehensive_score16" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  
					   <tr>
					 	  <td width="15%" rowspan="3"  align="center">
						           <input type="hidden" id="bsflag17" name="bsflag17" value="0" />
							<input type="hidden" id="create_date17" name="create_date17" value="" />
							<input type="hidden" id="creator17" name="creator17" value="" />
							<input type="hidden" id="one_no17" name="one_no17"   />
					     <input type="text" id="elements17"  style="width:180px;"   readonly="readonly"  name="elements17" value="5.5.5作业许可" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no170" name="two_no170"   />
							 <input type="hidden" id="one_no170" name="one_no170"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content170" name="audit_content170"   class="textarea">5.22 常规作业中的危险（高危）作业实施许可管理（小票），主要包括夜间作业、长途搬迁、车辆牵引、民爆物品销毁、高处作业、吊装作业、临时用电、动火作业等，具体执行相关制度。 </textarea></td>
					 	  <td  align="center"> <input  name="standard_scor170" type="text" class="input_width"  onblur="biaoZhun('17');allNumber();chuNumber()"  id="standard_scor170"  style="width:120px;" value="5"/></td>
					 	  <td colspan="3" rowspan="3" align="center"><input type="text" id="factor_score17" style="width:120px;" readonly="readonly"   name="factor_score17" value="50" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score170" name="individual_score170"  onblur="danxiang('17');allNumber();chuNumber()"   style="width:120px;"  value="5" class="input_width"/></td>
					 	  <td width="10%" rowspan="3"  align="center"><input type="text" id="actual_score17" name="actual_score17" readonly="readonly"  style="width:120px;"   value="50" class="input_width"/></td>
				 	     <td width="10%" rowspan="3"   align="center"><input type="text" id="comprehensive_score17" readonly="readonly"  name="comprehensive_score17" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						    <input type="hidden" id="two_no171" name="two_no171"   />
							 <input type="hidden" id="one_no171" name="one_no171"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content171" name="audit_content171"   class="textarea">5.23 非常规作业实施许可管理（大票），非常规作业中如涵盖危险作业，还应开具相应的专项作业票（小票）。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor171" name="standard_scor171"   onblur="biaoZhun('17');allNumber();chuNumber()"  value="5" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score171" name="individual_score171"  onblur="danxiang('17');allNumber();chuNumber()"  value="5" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
					  			 	 <tr>
					 	  <td align="center">
						  	    <input type="hidden" id="two_no172" name="two_no172"   />
							 <input type="hidden" id="one_no172" name="one_no172"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content172" name="audit_content172"   class="textarea">5.24 运用工作安全分析的方法制定作业方案和风险控制措施，方案和措施应切合实际，具体明确，符合相关规定；
5.25 审批前，审批人到现场验证各项措施落实。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor172" name="standard_scor172"  onblur="biaoZhun('17');allNumber();chuNumber()"  value="40" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score172" name="individual_score172" onblur="danxiang('17');allNumber();chuNumber()"   value="40" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						
						
						 <tr>
					 	  <td width="15%" rowspan="10"  align="center">
						  	 <input type="hidden" id="bsflag18" name="bsflag18" value="0" />
							<input type="hidden" id="create_date18" name="create_date18" value="" />
							<input type="hidden" id="creator18" name="creator18" value="" />
							<input type="hidden" id="one_no18" name="one_no18"   />
						  <input type="text" id="elements18"   style="width:180px;"   readonly="readonly"   name="elements18" value="5.5.6运行控制" class="input_width"/>							  	  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no180" name="two_no180"   />
							 <input type="hidden" id="one_no180" name="one_no180"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content180" name="audit_content180"   class="textarea">5.26 目视化：抽查现场人员、设备、工具、区域的目视化。 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor180"  style="width:120px;"  onblur="biaoZhun('18');allNumber();chuNumber()"   name="standard_scor180" value="10" class="input_width"/></td>
					 	  <td colspan="3" rowspan="10" align="center"><input type="text" id="factor_score18" style="width:120px;" readonly="readonly"   name="factor_score18" value="195" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score180" name="individual_score180" onblur="danxiang('18');allNumber();chuNumber()"   style="width:120px;"  value="10" class="input_width"/></td>
					 	  <td width="10%" rowspan="10"  align="center"><input type="text" id="actual_score18" name="actual_score18" readonly="readonly"  style="width:120px;"   value="195" class="input_width"/></td>
					 	  <td width="10%" rowspan="10"   align="center"><input type="text" id="comprehensive_score18" readonly="readonly"  name="comprehensive_score18" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					 	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no181" name="two_no181"   />
							 <input type="hidden" id="one_no181" name="one_no181"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content181" name="audit_content181"   class="textarea">5.27 上锁挂签：上锁点清单、以往上锁挂签记录、抽查上锁挂签现场，与实施人员沟通（锁具使用方法、上锁挂签流程）。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor181" name="standard_scor181" onblur="biaoZhun('18');allNumber();chuNumber()"  value="20" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score181" name="individual_score181" onblur="danxiang('18');allNumber();chuNumber()"  value="20" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
					  			 	 <tr>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no182" name="two_no182"   />
							 <input type="hidden" id="one_no182" name="one_no182"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content182" name="audit_content182"   class="textarea">5.28 交通安全管理：限速规定、准驾证管理、GPS监控有效、GPS运行记录及分析、旅程管理、载人卡车管理、外租车辆管理等。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor182" name="standard_scor182" onblur="biaoZhun('18');allNumber();chuNumber()" value="30" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score182" name="individual_score182" onblur="danxiang('18');allNumber();chuNumber()"  value="30" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						    <input type="hidden" id="two_no183" name="two_no183"   />
							 <input type="hidden" id="one_no183" name="one_no183"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content183" name="audit_content183"   class="textarea">5.29 危险化学品管理（民爆物品、油品、化学药品）：验收、存储、运输、交接、使用、报废与处理等管理要求及实施；
5.30 应保留危险化学品安全说明书（MSDS），相关人员熟悉化学品性能、危害、应急措施。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor183" name="standard_scor183" onblur="biaoZhun('18');allNumber();chuNumber()" value="35" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score183" name="individual_score183" onblur="danxiang('18');allNumber();chuNumber()" value="35" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						  	    <input type="hidden" id="two_no184" name="two_no184"   />
							 <input type="hidden" id="one_no184" name="one_no184"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content184" name="audit_content184"   class="textarea">5.31 用电管理：线路布设、接地、漏电保护（总线保护、分级保护）、使用、维护、检查与检测等管理要求及实施。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor184" name="standard_scor184" onblur="biaoZhun('18');allNumber();chuNumber()" value="25" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score184" name="individual_score184" onblur="danxiang('18');allNumber();chuNumber()" value="25" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no185" name="two_no185"   />
							 <input type="hidden" id="one_no185" name="one_no185"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content185" name="audit_content185"   class="textarea">5.32 消防管理：消防设备设施配置、维护、检查、使用等管理要求及实施，灭火器检查卡应用情况。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor185" name="standard_scor185" onblur="biaoZhun('18');allNumber();chuNumber()" value="20" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score185" name="individual_score185" onblur="danxiang('18');allNumber();chuNumber()"  value="20" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						  		  	  <input type="hidden" id="two_no186" name="two_no186"   />
							 <input type="hidden" id="one_no186" name="one_no186"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content186" name="audit_content186"   class="textarea">5.33 废弃物（废油、废液、医疗垃圾、危化品包装物等）管理：收集、存放、处理管理要求及实施。	 </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor186" name="standard_scor186" onblur="biaoZhun('18');allNumber();chuNumber()" value="5" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score186" name="individual_score186" onblur="danxiang('18');allNumber();chuNumber()" value="5" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no187" name="two_no187"   />
							 <input type="hidden" id="one_no187" name="one_no187"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content187" name="audit_content187"   class="textarea">5.34 食品安全管理：采购点资质符合要求；食品采购、入库验收、储存、加工、供餐、留样符合要求；炊事人员管理，食品加工场所与器具消毒，厨房、餐厅设置等按要求实施。（做到生熟分开、成品与半成品分开；消毒与未消毒分开）	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor187" name="standard_scor187" onblur="biaoZhun('18');allNumber();chuNumber()" value="15" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score187" name="individual_score187" onblur="danxiang('18');allNumber();chuNumber()" value="15" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						     <input type="hidden" id="two_no188" name="two_no188"   />
							 <input type="hidden" id="one_no188" name="one_no188"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content188" name="audit_content188"   class="textarea">5.35 关键作业活动和任务均有作业程序或作业指南；	
5.36 本单位制修订作业程序或作业指南前，要开展工作安全分析；关键作业定期进行工作循环检查；			
5.37 员工了解相关程序和指南，并按要求进行作业；
5.38 员工正确使用劳动防护用品。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor188" name="standard_scor188" onblur="biaoZhun('18');allNumber();chuNumber()" value="25" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score188" name="individual_score188" onblur="danxiang('18');allNumber();chuNumber()" value="25" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 	 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no189" name="two_no189"   />
							 <input type="hidden" id="one_no189" name="one_no189"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content189" name="audit_content189"   class="textarea">5.39 各级属地主管要对进入现场的外来人员（承包商人员、供应方人员、来访者等）进行HSE提示。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor189" name="standard_scor189" onblur="biaoZhun('18');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score189" name="individual_score189" onblur="danxiang('18');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						
						  <tr>
					 	  <td width="15%"  align="center">
					  <input type="hidden" id="bsflag19" name="bsflag19" value="0" />
							<input type="hidden" id="create_date19" name="create_date19" value="" />
							<input type="hidden" id="creator19" name="creator19" value="" />
							<input type="hidden" id="one_no19" name="one_no19"   />
						  <input type="text" id="elements19"  style="width:180px;"   readonly="readonly"   name="elements19" value="5.5.7变更管理" class="input_width"/>							   </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no190" name="two_no190"   />
							 <input type="hidden" id="one_no190" name="one_no190"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content190" name="audit_content190"   class="textarea">5.40 施工环境、施工方法、关键岗位人员、设备以及材料、作业流程、制度标准等发生变更前进行评审，对变更影响的范围及造成的HSE风险变化进行了确认；	
5.41 变更导致风险变化时进行了危害因素辨识、风险评价，并采取了控制措施；
5.42 变更事项要对相关人员进行培训和告知；	
5.43 变更的实施按涉及的HSE体系要素要求保留相应记录。 </textarea></td>
					 	  <td  align="center"> <input  name="standard_scor190" type="text" class="input_width" onblur="biaoZhun('19');allNumber();chuNumber()" id="standard_scor190"  style="width:120px;" value="15"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score19" style="width:120px;" readonly="readonly"   name="factor_score19" value="15" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score190" name="individual_score190" onblur="danxiang('19');allNumber();chuNumber()"  style="width:120px;"  value="15" class="input_width"/></td>
					 	  <td width="10%"  align="center"><input type="text" id="actual_score19" name="actual_score19" readonly="readonly"  style="width:120px;"   value="15" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="comprehensive_score19" readonly="readonly"  name="comprehensive_score19" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					   <tr>
					 	  <td width="15%"  align="center">
						   <input type="hidden" id="bsflag20" name="bsflag20" value="0" />
							<input type="hidden" id="create_date20" name="create_date20" value="" />
							<input type="hidden" id="creator20" name="creator20" value="" />
							<input type="hidden" id="one_no20" name="one_no20"   />
					     <input type="text" id="elements20"   style="width:180px;"   readonly="readonly"  name="elements20" value="5.5.8应急准备和响应" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no200" name="two_no200"   />
							 <input type="hidden" id="one_no200" name="one_no200"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content200" name="audit_content200"   class="textarea">5.44 根据可能发生的突发事件（火灾、自然灾害、民爆物品丢失、油品泄漏、人员迷失/溺水/触电/中毒/疏散、恐怖袭击等），有针对性的制定相应的现场应急处置方案，做到“一案一卡”；			
5.45 预案编写、审批符合上级文件要求，预案内容符合实际，资源配置满足应急要求；	
5.46 制定的应急处置方案应与相关单位/部门有关预案接口清晰，职责明确；并建立相应的应急联动机制。
5.47 对员工进行应急培训；	
5.48 开展应急演练；
5.49 及时进行评价和修订。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor200"  style="width:120px;" onblur="biaoZhun('20');allNumber();chuNumber()"  name="standard_scor200" value="30" class="input_width"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score20" style="width:120px;"  readonly="readonly"   name="factor_score20" value="30" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score200" name="individual_score200"  onblur="danxiang('20');allNumber();chuNumber()" style="width:120px;"  value="30" class="input_width"/></td>
					 	  <td width="10%"  align="center"><input name="actual_score20" type="text" class="input_width" readonly="readonly"  id="actual_score20" style="width:120px;"   value="30"/></td>
				 	     <td width="10%"   align="center"><input type="text" id="comprehensive_score20" readonly="readonly"  name="comprehensive_score20" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  
					   <tr>
					 	  <td width="15%" rowspan="2"   align="center">
			  				<input type="hidden" id="bsflag21" name="bsflag21" value="0" />
							<input type="hidden" id="create_date21" name="create_date21" value="" />
							<input type="hidden" id="creator21" name="creator21" value="" />
							<input type="hidden" id="one_no21" name="one_no21"   />
					     <input type="text" id="elements21"   style="width:180px;"   readonly="readonly"   name="elements21" value="5.6.1绩效测量和监视" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no210" name="two_no210"   />
							 <input type="hidden" id="one_no210" name="one_no210"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content210" name="audit_content210"   class="textarea">6.1 每月开展一次HSE检查，班组每周开展一次HSE检查及时整改发现的问题；		
6.2 能够提供饮用水合格证明；
6.3 开工前对员工进行体检，体检项目符合要求；
6.4 对职业危害场所进行检测，对从业人员进行职业健康体检；
6.5 对特种设备（吊车、蒸汽锅炉、压力容器等）进行日常检查与定期监测：		
6.6 对测量设备和监测设备（万用表、摇表、一氧化碳报警器、气体监测装置等）进行校对或检测。	 </textarea></td>
					 	  <td  align="center"> <input  name="standard_scor210" type="text" class="input_width" onblur="biaoZhun('21');allNumber();chuNumber()" id="standard_scor210"  style="width:120px;" value="25"/></td>
					 	  <td colspan="3" rowspan="2"  align="center"><input type="text" id="factor_score21" readonly="readonly"  style="width:120px;"  name="factor_score21" value="35" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score210" name="individual_score210" onblur="danxiang('21');allNumber();chuNumber()"  style="width:120px;"  value="25" class="input_width"/></td>
					 	  <td width="10%" rowspan="2"  align="center"><input type="text" id="actual_score21" readonly="readonly"  name="actual_score21" style="width:120px;"   value="35" class="input_width"/></td>
				 	     <td width="10%"  rowspan="2"  align="center"><input type="text" id="comprehensive_score21" readonly="readonly"   name="comprehensive_score21" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					   <tr>
					 	  <td align="center">
						     <input type="hidden" id="two_no211" name="two_no211"   />
							 <input type="hidden" id="one_no211" name="one_no211"   /> 
						  <textarea  style="width:350px;height:100px;" id="audit_content211" name="audit_content211"   class="textarea">6.7 对避雷针、接地体，设备的安全附件进行检测和日常检查。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor211" name="standard_scor211"  onblur="biaoZhun('21');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score211" name="individual_score211" onblur="danxiang('21');allNumber();chuNumber()" value="10" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						
						<tr>
					 	  <td width="15%"  align="center">
						  	  				<input type="hidden" id="bsflag22" name="bsflag22" value="0" />
							<input type="hidden" id="create_date22" name="create_date22" value="" />
							<input type="hidden" id="creator22" name="creator22" value="" />
							<input type="hidden" id="one_no22" name="one_no22"   />
						  <input type="text" id="elements22"   style="width:180px;"   readonly="readonly"   name="elements22" value="5.6.2合规性评价" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  	 <input type="hidden" id="two_no220" name="two_no220"   />
							 <input type="hidden" id="one_no220" name="one_no220"   />  
							   <textarea  style="width:350px;height:100px;" id="audit_content220" name="audit_content220"   class="textarea">6.8 按要求开展合规性评价，并形成记录；（各项作业活动符合法律法规、行业标准及相关规定） </textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor220"  style="width:120px;" onblur="biaoZhun('22');allNumber();chuNumber()"  name="standard_scor220" value="10" class="input_width"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score22" readonly="readonly"  style="width:120px;"  name="factor_score22" value="10" class="input_width"/>                              </td>
					 	  <td align="center"> <input name="individual_score220" type="text" class="input_width" onblur="danxiang('22');allNumber();chuNumber()"  id="individual_score220"  style="width:120px;"  value="10"/></td>
					 	  <td width="10%"  align="center"><input type="text" id="actual_score22" readonly="readonly"  name="actual_score22" style="width:120px;"   value="10" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="comprehensive_score22" readonly="readonly"  name="comprehensive_score22" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					  <tr>
					 	  <td width="15%"  align="center">
						  		<input type="hidden" id="bsflag23" name="bsflag23" value="0" />
							<input type="hidden" id="create_date23" name="create_date23" value="" />
							<input type="hidden" id="creator23" name="creator23" value="" />
							<input type="hidden" id="one_no23" name="one_no23"   />
					    <input type="text" id="elements23"   style="width:180px;"   readonly="readonly"  name="elements23" value="5.6.3不符合、纠正措施和预防措施" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no230" name="two_no230"   />
							 <input type="hidden" id="one_no230" name="one_no230"   />
						<textarea  style="width:350px;height:100px;" id="audit_content230" name="audit_content230"   class="textarea">6.9 对在绩效检测、体系审核、回顾与总结、现场检查、合规性评价等活动中发现的不符合进行纠正，分析原因，制定纠正措施和预防措施，并跟踪验证。 </textarea>								 </td>
					 	  <td  align="center"> <input type="text" id="standard_scor230"  style="width:120px;" onblur="biaoZhun('23');allNumber();chuNumber()"   name="standard_scor230" value="30" class="input_width"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score23" readonly="readonly"  style="width:120px;"  name="factor_score23" value="30" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score230" name="individual_score230" onblur="danxiang('23');allNumber();chuNumber()"  style="width:120px;"  value="30" class="input_width"/></td>
					 	  <td width="10%"  align="center"><input type="text" id="actual_score23" readonly="readonly"  name="actual_score23" style="width:120px;"   value="30" class="input_width"/></td>
				 	    <td width="10%"   align="center"><input type="text" id="comprehensive_score23" readonly="readonly"   name="comprehensive_score23" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
						   <tr>
					 	  <td width="15%" rowspan="3"   align="center">
						  	 <input type="hidden" id="bsflag24" name="bsflag24" value="0" />
							<input type="hidden" id="create_date24" name="create_date24" value="" />
							<input type="hidden" id="creator24" name="creator24" value="" />
							<input type="hidden" id="one_no24" name="one_no24"   />
						  <input type="text" id="elements24"   style="width:180px;"   readonly="readonly"  name="elements24" value="5.6.4事故、事件报告、调查和处理" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no240" name="two_no240"   />
							 <input type="hidden" id="one_no240" name="one_no240"   />  
					        <textarea  style="width:350px;height:100px;" id="audit_content240" name="audit_content240"   class="textarea">6.10 按规定上报事故、事件，建立档案 	
</textarea></td>
					 	  <td  align="center"> <input  name="standard_scor240" type="text" class="input_width" id="standard_scor240" onblur="biaoZhun('24');allNumber();chuNumber()"  style="width:120px;" value="10"/></td>
					 	  <td colspan="3" rowspan="3"  align="center"><input type="text" id="factor_score24" readonly="readonly"  style="width:120px;"  name="factor_score24" value="50" class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score240" name="individual_score240"  style="width:120px;" onblur="danxiang('24');allNumber();chuNumber()"  value="10" class="input_width"/></td>
					 	  <td width="10%" rowspan="3"  align="center"><input type="text" id="actual_score24"  readonly="readonly"  name="actual_score24" style="width:120px;"   value="50" class="input_width"/></td>
					 	  <td width="10%"  rowspan="3"  align="center"><input type="text" id="comprehensive_score24" readonly="readonly"  name="comprehensive_score24" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					   <tr>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no241" name="two_no241"   />
							 <input type="hidden" id="one_no241" name="one_no241"   />  
						  <textarea  style="width:350px;height:100px;" id="audit_content241" name="audit_content241"   class="textarea">6.11 人员轻微伤害事件和未遂事件的管理，包括上报、调查、制定整改措施、统计、录入HSE信息系统等。	</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor241" name="standard_scor241"  onblur="biaoZhun('24');allNumber();chuNumber()"  value="30" style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score241" name="individual_score241" onblur="danxiang('24');allNumber();chuNumber()"  value="30" style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						 <tr>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no242" name="two_no242"   />
							 <input type="hidden" id="one_no242" name="one_no242"   />  
						  <textarea  style="width:350px;height:100px;" id="audit_content242" name="audit_content242"   class="textarea">6.12 与事故、事件相关人员进行沟通，并留有记录；	
6.13 对其他单位的事故、事件情况，通过公告（食堂、会议室、公告牌）、案例分析、经验分享等形式，与员工进行沟通。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor242" name="standard_scor242" value="10" onblur="biaoZhun('24');allNumber();chuNumber()"  style="width:120px;"  class="input_width"/></td>
					 	  <td align="center"> <input type="text" id="individual_score242" name="individual_score242" value="10" onblur="danxiang('24');allNumber();chuNumber()"  style="width:120px;"  class="input_width"/></td>
				 	    </tr>
						
						 <tr>
					 	  <td width="15%"  align="center">
						   <input type="hidden" id="bsflag25" name="bsflag25" value="0" />
							<input type="hidden" id="create_date25" name="create_date25" value="" />
							<input type="hidden" id="creator25" name="creator25" value="" />
							<input type="hidden" id="one_no25" name="one_no25"   />
						  <input type="text" id="elements25"   style="width:180px;"   readonly="readonly"  name="elements25" value="5.6.5记录控制" class="input_width"/>							  </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no250" name="two_no250"   />
							 <input type="hidden" id="one_no250" name="one_no250"   />  
						  <textarea  style="width:350px;height:100px;" id="audit_content250" name="audit_content250"   class="textarea" >6.14 记录填写符合要求；
6.15 根据体系运行要求收集、分类保留相关记录；	
6.16 按照记录类别，建立HSE记录、销毁清单；
6.17 记录销毁得到批准。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor250"  style="width:120px;" onblur="biaoZhun('25');allNumber();chuNumber()"   name="standard_scor250" value="10"  class="input_width"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score25" readonly="readonly"  style="width:120px;"  name="factor_score25" value="10" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score250" name="individual_score250"  onblur="danxiang('25');allNumber();chuNumber()"  style="width:120px;"  value="10"  class="input_width"/></td>
					 	  <td width="10%"  align="center"><input type="text" id="actual_score25" readonly="readonly"  name="actual_score25" style="width:120px;"   value="10" class="input_width"/></td>
					 	  <td width="10%"   align="center"><input type="text" id="comprehensive_score25" readonly="readonly"  name="comprehensive_score25" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					   <tr>
					 	  <td width="15%"  align="center">
						  				   <input type="hidden" id="bsflag26" name="bsflag26" value="0" />
							<input type="hidden" id="create_date26" name="create_date26" value="" />
							<input type="hidden" id="creator26" name="creator26" value="" />
							<input type="hidden" id="one_no26" name="one_no26"   />
					     <input type="text" id="elements26"  style="width:180px;"   readonly="readonly"   name="elements26" value="5.6.6内部审核" class="input_width"/>							    </td>
					 	  <td align="center">
						  	 <input type="hidden" id="two_no260" name="two_no260"   />
							 <input type="hidden" id="one_no260" name="one_no260"   />  
						  <textarea  style="width:350px;height:100px;" id="audit_content260" name="audit_content260"   class="textarea">6.18 建立内部审核计划，并按计划进行审核；（项目中期一次）
6.19 审核记录清晰、规范；
6.20 向班组和员工公布审核结果；	
6.21 对不符合项进行跟踪；</textarea></td>
					 	  <td  align="center"><input type="text" id="standard_scor260"  style="width:120px;" onblur="biaoZhun('26');allNumber();chuNumber()"   name="standard_scor260" value="25" class="input_width"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score26" readonly="readonly"  style="width:120px;"  name="factor_score26" value="25" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score260" name="individual_score260" onblur="danxiang('26');allNumber();chuNumber()"   style="width:120px;"  value="25" class="input_width"/></td>
					 	  <td width="10%"  align="center"><input type="text" id="actual_score26" readonly="readonly"   name="actual_score26" style="width:120px;"   value="25" class="input_width"/></td>
				 	     <td width="10%"   align="center"><input type="text" id="comprehensive_score26" readonly="readonly"  name="comprehensive_score26" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					   <tr>
					 	  <td width="15%"  align="center">  
						     <input type="hidden" id="bsflag27" name="bsflag27" value="0" />
							<input type="hidden" id="create_date27" name="create_date27" value="" />
							<input type="hidden" id="creator27" name="creator27" value="" />
							<input type="hidden" id="one_no27" name="one_no27"   />
					     <input type="text" id="elements27"   style="width:180px;"   readonly="readonly"   name="elements27" value="5.7管理评审" class="input_width"/>							  </td>
					 	  <td align="center">
						  	  <input type="hidden" id="two_no270" name="two_no270"   />
							 <input type="hidden" id="one_no270" name="one_no270"   />  
						  <textarea  style="width:350px;height:100px;" id="audit_content270" name="audit_content270"   class="textarea">7.1 每个项目有一次回顾与总结，本项目未结束，审核上一个项目。
7.2 回顾与总结内容满足文件、标准要求，输入资料应包括各班组体系运行情况分析；
7.3 回顾与总结报告中持续改进要求得到落实（上一项目的改进措施与本项目的工作计划相结合）；	
7.4 回顾与总结报告经批准后下达到各班组；
7.5 回顾与总结报告报上一级管理部门。</textarea></td>
					 	  <td  align="center"> <input type="text" id="standard_scor270"  style="width:120px;" onblur="biaoZhun('27');allNumber();chuNumber()"  name="standard_scor270" value="25" class="input_width"/></td>
					 	  <td colspan="3" align="center"><input type="text" id="factor_score27"  readonly="readonly" style="width:120px;"  name="factor_score27" value="25" class="input_width"/>                              </td>
					 	  <td align="center"> <input type="text" id="individual_score270" name="individual_score270"  onblur="danxiang('27');allNumber();chuNumber()"  style="width:120px;"  value="25" class="input_width"/></td>
					 	  <td width="10%"  align="center"><input type="text" id="actual_score27" readonly="readonly"  name="actual_score27" style="width:120px;"   value="25" class="input_width"/></td>
				 	     <td width="10%"   align="center"><input type="text" id="comprehensive_score27" readonly="readonly"  name="comprehensive_score27" style="width:120px;"  value="1000" class="input_width"/></td>
			 	      </tr>
					   <tr>
						   
						   <tr>
						 	  <td width="15%"  align="center">合计</td>
						 	  <td align="center"> </td>
						 	  <td  align="center"> <input type="text" id="sum_standard_score"  style="width:120px;" readonly="readonly"   name="sum_standard_score" value="" class="input_width"/></td>
						 	  <td colspan="3" align="center"><input type="text" id="sum_factor_score" style="width:120px;" readonly="readonly"  name="sum_factor_score" value="" class="input_width"/>                              </td>
						 	  <td align="center"> <input type="text" id="sum_individual_score" name="sum_individual_score" readonly="readonly"  style="width:120px;"  value="" class="input_width"/></td>
						 	  <td width="10%"  align="center"><input type="text" id="sum_actual_score" name="sum_actual_score" readonly="readonly"  style="width:120px;"   value="" class="input_width"/></td>
					 	     <td width="10%"   align="center"><input type="text" id="sum_comprehensive_score" name="sum_comprehensive_score" readonly="readonly"   style="width:120px;"  value="" class="input_width"/></td>
				 	      </tr>
					</table>
		  </div>
			</div>
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
			<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
		</div>
	</div>
</div> 
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
var auditlist_id='<%=auditlist_id%>';
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

 
	function closeButton(){
		window.close();
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
	
	
	
	function biaoZhun(i){	
		
		if(i=='0'){
			biaoz('0','6');
		}
		if(i=='1'){
			biaoz('1','1');
		}
		if(i=='2'){
			biaoz('2','2');
		}
		if(i=='3'){
			biaoz('3','2');
		}
		if(i=='4'){
			biaoz('4','3');
		}
		if(i=='5'){
			biaoz('5','1');
		}
		if(i=='6'){
			biaoz('6','1');
		}
		if(i=='7'){
			biaoz('7','1');
		}
		if(i=='8'){
			biaoz('8','3');
		}
		if(i=='9'){
			biaoz('9','3');
		}
		
		if(i=='10'){
			biaoz('10','2');
		}
		if(i=='11'){
			biaoz('11','1');
		}
		
		if(i=='12'){
			biaoz('12','1');
		}
		if(i=='13'){
			biaoz('13','2');
		}
		if(i=='14'){
			biaoz('14','5');
		}
		if(i=='15'){
			biaoz('15','1');
		}
		if(i=='16'){
			biaoz('16','1');
		}
		if(i=='17'){
			biaoz('17','3');
		}
		if(i=='18'){
			biaoz('18','10');
		}
		if(i=='19'){
			biaoz('19','1');
		}
		if(i=='20'){
			biaoz('20','1');
		}
		if(i=='21'){
			biaoz('21','2');
		}
		if(i=='22'){
			biaoz('22','1');
		}
		if(i=='23'){
			biaoz('23','1');
		}
		
		if(i=='24'){
			biaoz('24','3');
		}
		if(i=='25'){
			biaoz('25','1');
		}
		if(i=='26'){
			biaoz('26','1');
		}
		if(i=='27'){
			biaoz('27','1');
		}
	  
   }
	function biaoz(oneIndex,indexNum){			
		  var biaozhunSum=0;   
	    for(var i=0;i<indexNum;i++){ 
	    	var standard_scor =document.getElementsByName("standard_scor"+oneIndex+i)[0].value;  
	 	    if(checkNaN("standard_scor"+oneIndex+i)){
	 		biaozhunSum = parseFloat(biaozhunSum)+parseFloat(standard_scor); 
	 	   }
	    }
		document.getElementById("factor_score"+oneIndex).value=substrin(biaozhunSum); 
	}
	
	
		function danxiang(i){		
			if(i=='0'){
				danx('0','6');
			}
			if(i=='1'){
				danx('1','1');
			}
			if(i=='2'){
				danx('2','2');
			}
			if(i=='3'){
				danx('3','2');
			}
			if(i=='4'){
				danx('4','3');
			}
			if(i=='5'){
				danx('5','1');
			}
			if(i=='6'){
				danx('6','1');
			}
			if(i=='7'){
				danx('7','1');
			}
			if(i=='8'){
				danx('8','3');
			}
			if(i=='9'){
				danx('9','3');
			}
			
			if(i=='10'){
				danx('10','2');
			}
			if(i=='11'){
				danx('11','1');
			}
			
			if(i=='12'){
				danx('12','1');
			}
			if(i=='13'){
				danx('13','2');
			}
			if(i=='14'){
				danx('14','5');
			}
			if(i=='15'){
				danx('15','1');
			}
			if(i=='16'){
				danx('16','1');
			}
			if(i=='17'){
				danx('17','3');
			}
			if(i=='18'){
				danx('18','10');
			}
			if(i=='19'){
				danx('19','1');
			}
			if(i=='20'){
				danx('20','1');
			}
			if(i=='21'){
				danx('21','2');
			}
			if(i=='22'){
				danx('22','1');
			}
			if(i=='23'){
				danx('23','1');
			}
			
			if(i=='24'){
				danx('24','3');
			}
			if(i=='25'){
				danx('25','1');
			}
			if(i=='26'){
				danx('26','1');
			}
			if(i=='27'){
				danx('27','1');
			}
 
	  }
		
		function danx(oneIndex,indexNum){			
		    var danxiangSum=0;   
		    for(var i=0;i<indexNum;i++){ 
				var individual_score = document.getElementsByName("individual_score"+oneIndex+i)[0].value;  
	 
				if(checkNaN("individual_score"+oneIndex+i)){
					danxiangSum = parseFloat(danxiangSum)+parseFloat(individual_score);
				}
		    }
		document.getElementById("actual_score"+oneIndex).value=substrin(danxiangSum);
		}
 
	function checkNaN(numids){
		 var str =document.getElementsByName(numids)[0].value;
		 if(str!=""){		 
			if(isNaN(str)){
				alert("请输入数字");
				document.getElementsByName(numids)[0].value="";
				return false;
			}else{
				return true;
			}
		  }

	}
	
	function substrin(str)
	{ 
		str = Math.round(str * 10000) / 10000;
		return(str); 
	 }
	
	 
	function allNumber(){	 
		var a1=0;
		var a2=0;
		var a3=0;
	 
		for(var i=0;i<28;i++){
				    var  factor_score =document.getElementsByName("factor_score"+i)[0].value;
					var  actual_score=document.getElementsByName("actual_score"+i)[0].value;		               
					var comprehensive_score=document.getElementsByName("comprehensive_score"+i)[0].value;
			a1 = parseFloat(a1)+parseFloat(factor_score);	 
			a2 = parseFloat(a2)+parseFloat(actual_score); 
			  
		}
		document.getElementById("sum_standard_score").innerText=substrin(a1);
		document.getElementById("sum_factor_score").innerText=substrin(a1);
		document.getElementById("sum_individual_score").innerText=substrin(a2);
		document.getElementById("sum_actual_score").innerText=substrin(a2);
		a3=(a2/a1)*1000;
		document.getElementById("sum_comprehensive_score").innerText=substrin(a3);
	}

 
	function  chuNumber(){	 
		var a1=0;
		var a2=0;
	    var a3=0;
		for(var i=0;i<28;i++){
				    var  factor_score =document.getElementsByName("factor_score"+i)[0].value;
					var  actual_score=document.getElementsByName("actual_score"+i)[0].value;		               
 
			a1 = parseFloat(factor_score);	
			a2 = parseFloat(actual_score); 
			if(a1 =='') a1=0;
			if(a2 =='') a2=0;
			a3=(a2/a1)*1000;
			document.getElementsByName("comprehensive_score"+i)[0].value=substrin(a3);
 
		}
	
 
	}
	
	function checkJudge(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			
		
			var audit_level = document.getElementsByName("audit_level")[0].value;
 			var audit_personnel = document.getElementsByName("audit_personnel")[0].value;
 			var audit_time = document.getElementsByName("audit_time")[0].value;			
 			var auditlist_level = document.getElementsByName("auditlist_level")[0].value;	
		
	 
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 		if(org_sub_id==""){
 			alert("单位不能为空，请填写！");
 			return true;
 		}
 		if(audit_level==""){
 			alert("审核级别不能为空，请选择！");
 			return true;
 		}
 		if(audit_personnel==""){
 			alert("审核人员不能为空，请填写！");
 			return true;
 		}
 
		if(audit_time==""){
 			alert("审核时间不能为空，请填写！");
 			return true;
 		}
		if(auditlist_level==""){
 			alert("等级不能为空，请填写！");
 			return true;
 		}
	   
 		return false;
 	}
 	

    function submitButton(){
		if(checkJudge()){
			return;
		}
		
			var create_date = document.getElementsByName("create_date")[0].value;
 			var creator = document.getElementsByName("creator")[0].value;		
 			var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
 			var bsflag = document.getElementsByName("bsflag")[0].value;
 			var second_org = document.getElementsByName("second_org")[0].value;			
 			var third_org = document.getElementsByName("third_org")[0].value;	 
 			var audit_level = document.getElementsByName("audit_level")[0].value;
 			var audit_personnel = document.getElementsByName("audit_personnel")[0].value;
 			var audit_time = document.getElementsByName("audit_time")[0].value;			
 			var auditlist_level = document.getElementsByName("auditlist_level")[0].value;	
            var auditlist_id=document.getElementsByName("auditlist_id")[0].value;	            
 			var sum_standard_score = document.getElementsByName("sum_standard_score")[0].value;	 
 			var sum_factor_score = document.getElementsByName("sum_factor_score")[0].value;
 			var sum_individual_score = document.getElementsByName("sum_individual_score")[0].value;
 			var sum_actual_score = document.getElementsByName("sum_actual_score")[0].value;			
 			var sum_comprehensive_score = document.getElementsByName("sum_comprehensive_score")[0].value;	
 			var project_no = document.getElementsByName("project_no")[0].value;		
 			
 			if(sum_comprehensive_score >= 850){
 				auditlist_level="A";  
 			}
 			if(sum_comprehensive_score >= 700 && sum_comprehensive_score <= 849 ){
 				auditlist_level="B"; 
 			}
 			if(sum_comprehensive_score > 600  &&  sum_comprehensive_score <= 699 ){
 				auditlist_level="C"; 
 			}
 			if(sum_comprehensive_score <= 600){
 				auditlist_level="D"; 
 			}
 			if(project_no !=null && project_no !='' ){
		    	var projectTest=project_no;	
			}else{
				var projectTest='<%=projectInfoNo%>';
			}
 			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_AUDITLISTS&JCDP_TABLE_ID='+auditlist_id+'&org_sub_id='+org_sub_id+'&audit_time='+audit_time+'&auditlist_level='+auditlist_level+'&sum_standard_score='+sum_standard_score+'&sum_factor_score='+sum_factor_score
			+'&second_org='+second_org+'&third_org='+third_org+'&audit_level='+audit_level+'&audit_personnel='+audit_personnel+'&sum_individual_score='+sum_individual_score+'&sum_actual_score='+sum_actual_score+'&sum_comprehensive_score='+sum_comprehensive_score
			+'&updator=<%=userName%>&modifi_date=<%=curDate%>&bsflag=0&project_no='+projectTest;
			var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
 
			for(var i=0;i<28;i++){
				var elements =document.getElementsByName("elements"+i)[0].value; 
				var factor_score =document.getElementsByName("factor_score"+i)[0].value; 
				var actual_score = document.getElementsByName("actual_score"+i)[0].value;
				var comprehensive_score = document.getElementsByName("comprehensive_score"+i)[0].value;  
				var one_no = document.getElementsByName("one_no"+i)[0].value;
				
				var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var submitStrs = 'JCDP_TABLE_NAME=BGP_AUDITLISTS_ONE&JCDP_TABLE_ID='+one_no+'&elements='+elements+'&factor_score='+factor_score+'&actual_score='+actual_score+'&comprehensive_score='+comprehensive_score+'&auditlist_id='+auditlist_id
				+'&updator=<%=userName%>&modifi_date=<%=curDate%>&bsflag=0';
				var retObjects = syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));  //保存主表信息		
 
				if(i=='0'){
					addTwo('0','6',one_no);
				}
				if(i=='1'){
					addTwo('1','1',one_no);
				}
				if(i=='2'){
					addTwo('2','2',one_no);
				}
				if(i=='3'){
					addTwo('3','2',one_no);
				}
				if(i=='4'){
					addTwo('4','3',one_no);
				}
				if(i=='5'){
					addTwo('5','1',one_no);
				}
				if(i=='6'){
					addTwo('6','1',one_no);
				}
				if(i=='7'){
					addTwo('7','1',one_no);
				}
				if(i=='8'){
					addTwo('8','3',one_no);
				}
				if(i=='9'){
					addTwo('9','3',one_no);
				}
				
				if(i=='10'){
					addTwo('10','2',one_no);
				}
				if(i=='11'){
					addTwo('11','1',one_no);
				}
				
				if(i=='12'){
					addTwo('12','1',one_no);
				}
				if(i=='13'){
					addTwo('13','2',one_no);
				}
				if(i=='14'){
					addTwo('14','5',one_no);
				}
				if(i=='15'){
					addTwo('15','1',one_no);
				}
				if(i=='16'){
					addTwo('16','1',one_no);
				}
				if(i=='17'){
					addTwo('17','3',one_no);
				}
				if(i=='18'){
					addTwo('18','10',one_no);
				}
				if(i=='19'){
					addTwo('19','1',one_no);
				}
				if(i=='20'){
					addTwo('20','1',one_no);
				}
				if(i=='21'){
					addTwo('21','2',one_no);
				}
				if(i=='22'){
					addTwo('22','1',one_no);
				}
				if(i=='23'){
					addTwo('23','1',one_no);
				}
				
				if(i=='24'){
					addTwo('24','3',one_no);
				}
				if(i=='25'){
					addTwo('25','1',one_no);
				}
				if(i=='26'){
					addTwo('26','1',one_no);
				}
				if(i=='27'){
					addTwo('27','1',one_no);
				}
				
			}
			alert('保存成功！');
			window.close();
 		
	
   }
	
    function addTwo(oneIndex,addNum,oneNo){ 
    	for(var i=0;i<addNum;i++){ 
    		var audit_content =document.getElementsByName("audit_content"+oneIndex+i)[0].value;  
    		var standard_scor =document.getElementsByName("standard_scor"+oneIndex+i)[0].value; 
    		var individual_score = document.getElementsByName("individual_score"+oneIndex+i)[0].value;  
    		var two_no = document.getElementsByName("two_no"+oneIndex+i)[0].value;  
    		
    			var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var submitStrs = 'JCDP_TABLE_NAME=BGP_AUDITLISTS_TWO&JCDP_TABLE_ID='+two_no+'&audit_content='+audit_content+'&standard_scor='+standard_scor+'&individual_score='+individual_score+'&one_no='+oneNo
				+'&creator=<%=userName%>&updator=<%=userName%>&create_date=<%=curDate%>&modifi_date=<%=curDate%>&bsflag=0';
				var retObjects = syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));  //保存主表信息		
    	}
 
    }
    
    if(auditlist_id !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = " select   tr.project_no, tr.auditlist_id,tr.audit_level,tr.audit_personnel,tr.audit_time,tr.auditlist_level ,tr.sum_standard_score, tr.sum_factor_score,tr.sum_individual_score,tr.sum_actual_score,tr.sum_comprehensive_score,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.org_sub_id,tr.bsflag,tr.second_org,tr.third_org ,oi1.org_abbreviation as second_org_name,  oi2.org_abbreviation as third_org_name  from   BGP_HSE_AUDITLISTS  tr   left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id and ion.bsflag='0'      where   tr.bsflag='0'  and tr.auditlist_id='"+auditlist_id+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 
		   
	            document.getElementsByName("auditlist_id")[0].value=datas[0].auditlist_id; 
	    		document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	    document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	    document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	    		document.getElementsByName("create_date")[0].value=datas[0].create_date;
		        document.getElementsByName("creator")[0].value=datas[0].creator;
		        document.getElementsByName("project_no")[0].value=datas[0].project_no;	
	    		  document.getElementsByName("audit_level")[0].value=datas[0].audit_level;
	     		  document.getElementsByName("audit_personnel")[0].value=datas[0].audit_personnel;
	    		  document.getElementsByName("audit_time")[0].value=datas[0].audit_time;		
	    		  document.getElementsByName("auditlist_level")[0].value=datas[0].auditlist_level;			
	    		  document.getElementsByName("sum_standard_score")[0].value=datas[0].sum_standard_score;			
	    		  document.getElementsByName("sum_factor_score")[0].value=datas[0].sum_factor_score;
	    	      document.getElementsByName("sum_individual_score")[0].value=datas[0].sum_individual_score;
	    		  document.getElementsByName("sum_actual_score")[0].value=datas[0].sum_actual_score;	    		 
	    		  document.getElementsByName("sum_comprehensive_score")[0].value=datas[0].sum_comprehensive_score;	    		 

			}					
		
	    	}		
		
 			
		querySql = "  select ad.elements,  ad.one_no ,ad.auditlist_id, ad.factor_score ,  ad.actual_score ,ad.comprehensive_score,ad.creator,ad.create_date  from  BGP_AUDITLISTS_ONE ad join  BGP_HSE_AUDITLISTS tr on tr.auditlist_id=ad.auditlist_id and tr.bsflag='0' where ad.bsflag='0'   and ad.auditlist_id='"+auditlist_id+"'   order by ad.elements ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){
 
				for(var i = 0; i<datas.length; i++){							
					document.getElementsByName("elements"+i)[0].value=datas[i].elements; 
				    document.getElementsByName("factor_score"+i)[0].value=datas[i].factor_score; 
					document.getElementsByName("actual_score"+i)[0].value=datas[i].actual_score; 
				    document.getElementsByName("comprehensive_score"+i)[0].value=datas[i].comprehensive_score; 
					document.getElementsByName("one_no"+i)[0].value=datas[i].one_no;  
					
					if(i=='0'){
						selectTwo('0','6',datas[i].one_no);
					}
					if(i=='1'){
						selectTwo('1','1',datas[i].one_no);
					}
					if(i=='2'){
						selectTwo('2','2',datas[i].one_no);
					}
					if(i=='3'){
						selectTwo('3','2',datas[i].one_no);
					}
					if(i=='4'){
						selectTwo('4','3',datas[i].one_no);
					}
					if(i=='5'){
						selectTwo('5','1',datas[i].one_no);
					}
					if(i=='6'){
						selectTwo('6','1',datas[i].one_no);
					}
					if(i=='7'){
						selectTwo('7','1',datas[i].one_no);
					}
					if(i=='8'){
						selectTwo('8','3',datas[i].one_no);
					}
					if(i=='9'){
						selectTwo('9','3',datas[i].one_no);
					}
					
					if(i=='10'){
						selectTwo('10','2',datas[i].one_no);
					}
					if(i=='11'){
						selectTwo('11','1',datas[i].one_no);
					}
					
					if(i=='12'){
						selectTwo('12','1',datas[i].one_no);
					}
					if(i=='13'){
						selectTwo('13','2',datas[i].one_no);
					}
					if(i=='14'){
						selectTwo('14','5',datas[i].one_no);
					}
					if(i=='15'){
						selectTwo('15','1',datas[i].one_no);
					}
					if(i=='16'){
						selectTwo('16','1',datas[i].one_no);
					}
					if(i=='17'){
						selectTwo('17','3',datas[i].one_no);
					}
					if(i=='18'){
						selectTwo('18','10',datas[i].one_no);
					}
					if(i=='19'){
						selectTwo('19','1',datas[i].one_no);
					}
					if(i=='20'){
						selectTwo('20','1',datas[i].one_no);
					}
					if(i=='21'){
						selectTwo('21','2',datas[i].one_no);
					}
					if(i=='22'){
						selectTwo('22','1',datas[i].one_no);
					}
					if(i=='23'){
						selectTwo('23','1',datas[i].one_no);
					}
					
					if(i=='24'){
						selectTwo('24','3',datas[i].one_no);
					}
					if(i=='25'){
						selectTwo('25','1',datas[i].one_no);
					}
					if(i=='26'){
						selectTwo('26','1',datas[i].one_no);
					}
					if(i=='27'){
						selectTwo('27','1',datas[i].one_no);
					}
					
				}
			}
		}
		 		
	}
	
    function selectTwo(oneIndex,addNum,oneNo){ 
    	var querySql = "";
		var queryRet = null;
		var  datas =null;	
    	querySql = "  select    ad.two_no,ad.one_no,ad.individual_score,ad.standard_scor ,ad.audit_content,ad.creator,ad.create_date  from  BGP_AUDITLISTS_TWO ad join  BGP_AUDITLISTS_ONE  tr on tr.one_no=ad.one_no and tr.bsflag='0' where ad.bsflag='0'    and ad.one_no='"+oneNo+"' order by ad.audit_content ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){
				
				for(var i = 0; i<datas.length; i++){							
					document.getElementsByName("audit_content"+oneIndex+i)[0].value=datas[i].audit_content; 
				    document.getElementsByName("standard_scor"+oneIndex+i)[0].value=datas[i].standard_scor; 
					document.getElementsByName("individual_score"+oneIndex+i)[0].value=datas[i].individual_score; 
				    document.getElementsByName("two_no"+oneIndex+i)[0].value=datas[i].two_no; 
					document.getElementsByName("one_no"+oneIndex+i)[0].value=datas[i].one_no;  
					
				}
			}
			
		}
    	
    	
    }
</script>
</body>
</html>