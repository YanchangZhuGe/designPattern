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
 
<title>违章管理</title>
</head>

<body style="background:#fff"  onload="refreshData();getHazardCenter()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">违章人员姓名</td>
			    <td class="ali_cdn_input"><input id="changeName" name="changeName" type="text" />			   
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{illegal_no}' value='{illegal_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{coding_name}">隐患危害类型</td>
			      <td class="bt_info_odd" exp="{staff_name}">违章人员姓名</td>
			      <td class="bt_info_even" exp="{illeagl_personnel_level}">违章人员级别</td>
			      <td class="bt_info_odd" exp="{illegal_lname}">违章级别</td>
			      <td class="bt_info_even" exp="{process_mode}">处理方式</td>
			      <td class="bt_info_odd" exp="{a_process}">行政处理</td>
			      <td class="bt_info_even" exp="{fine_amount}">罚款金额（元）</td>

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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">违章信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">违章处置</a></li>		
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
					    	<input type="hidden" id="aa" name="aa" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="illegal_no" name="illegal_no"   />
					     	<input type="hidden" id="project_no" name="project_no" value="" />
					     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					     
					    <td class="inquire_item6">作业场所/岗位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="sites_post" name="sites_post" class="input_width"   />    					    
					    </td>					    
						</tr>	
						 <tr>	
						    <td class="inquire_item6"><font color="red">*</font>隐患危害类型：</td>
						    <td class="inquire_form6"> <select id="hazard_center" name="hazard_center" class="select_width"></td>					 
				 		 
						  </tr>		
					  <tr>	
					   				
			 		    <td class="inquire_item6"><font color="red">*</font>违章人员姓名：</td>
					    <td class="inquire_form6">  
					    <input type="text" id="staff_name" name="staff_name" class="input_width" readonly="readonly"  />
					    <input type="hidden"   name="employe_id" id="employe_id" value=""/>
						<div id="div1rowNum" style="display:block"> <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson()"/></div>
						<input type="hidden"  name="labor_id" id="labor_id"  value="" />
						<div id="div0rowNum" style="display:none"><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor()" /></div>
					    </td>
					    <td class="inquire_item6">用工类别：</td>
					    <td class="inquire_form6">					   
					    <input type="text" id="labor_class" name="labor_class" class="input_width" readonly="readonly"  />
					    </td>	
					  </tr>		
				 
					  <tr>
					    <td class="inquire_item6">违章人员身份证号：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="illeagl_code" name="illeagl_code" class="input_width" readonly="readonly"  />
					    </td>
					    <td class="inquire_item6">违章人员岗位：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="illegal_post" name="illegal_post" class="input_width" readonly="readonly"  />		
					    </td>
					    </tr>	
			
						  <tr>
						  <td class="inquire_item6">违章人员级别：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="illeagl_personnel_level" name="illeagl_personnel_level" class="input_width" readonly="readonly"  />
							</select> 			
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>违章级别：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="illegal_level" name="illegal_level" class="select_width">
						       <option value="" >请选择</option>
						       <option value="0" >特大</option> 
						       <option value="1" >重大</option>
						       <option value="2" >较大</option> 
						       <option value="3" >一般</option> 
						   
							</select> 	
						    </td> 
						   
						    </tr>	
							  <tr>
							  <td class="inquire_item6"><font color="red">*</font>发现方式：</td>
							    <td class="inquire_form6"> 
							    <select id="found_way" name="found_way" class="select_width">
							       <option value="" >请选择</option>
							       <option value="1" >安全检查</option>
							       <option value="2" >员工举报</option> 
							       <option value="3" >其他</option> 
								</select> 		
							    </td>
							    <td class="inquire_item6">违章时间：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="violation_time" name="violation_time" class="input_width"    readonly="readonly"/>
							    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(violation_time,tributton1);" />&nbsp;</td>
						  
							    </tr>	
								  
					     </table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  
					  <tr>
					    <td class="inquire_item6">违章事实描述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="lllegal_description" name="lllegal_description"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  <tr>
					    <td class="inquire_item6">纠正措施：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="corrective_measures" name="corrective_measures"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					</table>					  
				</div> 
					<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis3" >		     
		                  <span class="bc" onclick="toUpdate('2')" title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo2">			
					 <tr>  
					    <td class="inquire_item6"><font color="red">*</font>处理级别：</td>
					    <td class="inquire_form6" >	
					    <select id="process_level" name="process_level" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >公司</option>
					       <option value="2" >二级单位</option> 
					       <option value="3" >基层单位</option>   
					       <option value="4" >基层单位下属单位</option> 
						</select> 
					    </td>		
					    <td class="inquire_item6"><font color="red">*</font>处理方式：</td>
					    <td class="inquire_form6"><select id="process_mode" name="process_mode" onchange="selectChang()" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >行政处理</option>
					       <option value="2" >经济处罚</option> 
					       <option value="3" >行政处理+经济处罚</option> 
						</select> 
					    </td>	
					 </tr>	
					  <tr>  		 
					    <td class="inquire_item6"><font color="red">*</font>处理时间：</td>
					    <td class="inquire_form6"><input type="text" id="process_time" name="process_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(process_time,tributton3);" />&nbsp;</td>

					    <td class="inquire_item6">	 <div id="blocks" name="blocks" style="display:block;" ><font color="red">*</font>行政处理：</div></td>
					    <td class="inquire_form6" >	
					    <div id="block1" name="block1" style="display:block;" >
					    <select id="administrative_process" name="administrative_process" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >警告</option>
					       <option value="2" >记过</option> 
					       <option value="3" >记大过</option> 
					       <option value="4" >降级</option>
					       <option value="5" >降职</option> 
					       <option value="6" >撤职</option> 
					       <option value="7" >留用察看</option>
					       <option value="8" >开除</option> 
						</select> 
						   </div>
					    </td>
					    
					    </tr>	
					 <tr> 
					    <td class="inquire_item6">处理状态：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="process_state" name="process_state" class="input_width" style="color: gray;"   readonly="readonly"  />	
					    </td>
					       
						   <td class="inquire_item6"><div id="block2" name="block2" style="display:block;" >罚款金额(元)：</div></td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <div id="block2s" name="block2s" style="display:block;" >
						    <input type="text" id="fine_amount" name="fine_amount" class="input_width"  />
						    </div>
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
		cruConfig.queryStr="";
		var str= " select decode(tr.process_mode,'1','行政处理','2','经济处罚','3','行政处理+经济处罚') process_mode,cdl.coding_name, decode(tr.administrative_process,'1','警告','2','记过','3','记大过','4','降级','5','降职','6','撤职','7','留用察看','8','开除')a_process,decode(tr.illegal_level,'0','特大','1','重大','2','较大','3','一般')illegal_lname, tr.org_sub_id,tr.illegal_no,tr.sites_post,tr.hazard_class,tr.staff_name,tr.illegal_post,tr.illeagl_code,tr.illeagl_personnel_level,tr.lllegal_description,tr.illegal_level,tr.found_way  ,tr.process_level,tr.process_time,tr.administrative_process,tr.fine_amount,tr.process_state ,tr.violation_time,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.bsflag,  oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name  from BGP_ILLEGAL_MANAGEMENT tr left  join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id left join comm_coding_sort_detail cdl on cdl.coding_code_id=tr.hazard_class and cdl.bsflag='0'   where tr.bsflag = '0' "+querySqlAdd+" order by tr.modifi_date desc ";  
		cruConfig.queryStr = str;	
		cruConfig.currentPageUrl = "/hse/hseOptionPage/illegalManagement/illegalManagement.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/illegalManagement/illegalManagement.jsp";
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
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		if(changeName!=''&& changeName!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select decode(tr.process_mode,'1','行政处理','2','经济处罚','3','行政处理+经济处罚') process_mode,cdl.coding_name, decode(tr.administrative_process,'1','警告','2','记过','3','记大过','4','降级','5','降职','6','撤职','7','留用察看','8','开除')a_process,decode(tr.illegal_level,'0','特大','1','重大','2','较大','3','一般')illegal_lname, tr.org_sub_id,tr.illegal_no,tr.sites_post,tr.hazard_class,tr.staff_name,tr.illegal_post,tr.illeagl_code,tr.illeagl_personnel_level,tr.lllegal_description,tr.illegal_level,tr.found_way  ,tr.process_level,tr.process_time,tr.administrative_process,tr.fine_amount,tr.process_state ,tr.violation_time,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.bsflag,  oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name  from BGP_ILLEGAL_MANAGEMENT tr left  join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id left join comm_coding_sort_detail cdl on cdl.coding_code_id=tr.hazard_class and cdl.bsflag='0'   where tr.bsflag = '0' "+querySqlAdd+" and tr.staff_name like '%"+ changeName +"%' order by tr.modifi_date desc";
			cruConfig.currentPageUrl = "/hse/hseOptionPage/illegalManagement/illegalManagement.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
	function getHazardCenter(){
	    var hazardBig = "hazardBig="+"5110000032000000003";   
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
			querySql = " select   tr.project_no,tr.corrective_measures,tr.employe_id,tr.labor_class,tr.labor_id,tr.org_sub_id,tr.illegal_no,tr.sites_post,tr.hazard_class,tr.staff_name,tr.illegal_post,tr.illeagl_code,tr.illeagl_personnel_level,tr.lllegal_description,tr.illegal_level,tr.found_way  ,tr.violation_time,tr.process_level,tr.process_mode,tr.process_time,tr.administrative_process,tr.fine_amount,tr.process_state ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_ILLEGAL_MANAGEMENT tr   left  join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id      where tr.bsflag = '0' and tr.illegal_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("illegal_no")[0].value=datas[0].illegal_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
		    		 document.getElementsByName("aa")[0].value=datas[0].hazard_class;   
		    		 
					    document.getElementsByName("employe_id")[0].value=datas[0].employe_id;
						document.getElementsByName("labor_class")[0].value=datas[0].labor_class;		
						document.getElementsByName("labor_id")[0].value=datas[0].labor_id;	
		    			document.getElementsByName("sites_post")[0].value=datas[0].sites_post;
		    			document.getElementsByName("hazard_center")[0].value=datas[0].hazard_class;		
		    			document.getElementsByName("staff_name")[0].value=datas[0].staff_name;			
		    			document.getElementsByName("illegal_post")[0].value=datas[0].illegal_post;		
		    		    document.getElementsByName("illeagl_code")[0].value=datas[0].illeagl_code;		
		    			document.getElementsByName("illeagl_personnel_level")[0].value=datas[0].illeagl_personnel_level;	
		    			document.getElementsByName("lllegal_description")[0].value=datas[0].lllegal_description;
		    		    document.getElementsByName("illegal_level")[0].value=datas[0].illegal_level;		
		    			document.getElementsByName("found_way")[0].value=datas[0].found_way;		
		    			document.getElementsByName("violation_time")[0].value=datas[0].violation_time;			  				
					    document.getElementsByName("process_level")[0].value=datas[0].process_level;		
		    			document.getElementsByName("process_mode")[0].value=datas[0].process_mode;	
		    			document.getElementsByName("process_time")[0].value=datas[0].process_time;
		    		    document.getElementsByName("administrative_process")[0].value=datas[0].administrative_process;		
		    			document.getElementsByName("fine_amount")[0].value=datas[0].fine_amount;		
		    			document.getElementsByName("process_state")[0].value=datas[0].process_state;	
		    			 document.getElementsByName("project_no")[0].value=datas[0].project_no;	
		      			 document.getElementsByName("corrective_measures")[0].value=datas[0].corrective_measures;	
		    		
		      			 if(datas[0].process_state ==""){
		    				document.getElementsByName("process_state")[0].value="自动生成";		    				
		    			}
 
		    			if(datas[0].process_mode =="1"){
		    				document.getElementById("block2").style.display="none";
							document.getElementById("block2s").style.display="none";		        	
				        	document.getElementById("block1").style.display="block";
							document.getElementById("blocks").style.display="block";
				
		    			}
		    			if(datas[0].process_mode =="2"){
		    				document.getElementById("block1").style.display="none";
		    				document.getElementById("blocks").style.display="none";
		    				document.getElementById("block2").style.display="block";
		    				document.getElementById("block2s").style.display="block";
		    			}
		    			if(datas[0].process_mode ==""){
		    				document.getElementById("block2").style.display="block";
		    				document.getElementById("block2s").style.display="block";
		    				document.getElementById("block1").style.display="block";
		    				document.getElementById("blocks").style.display="block";
		    			}
		    			if(datas[0].process_mode =="3"){
		    				document.getElementById("block2").style.display="block";
		    				document.getElementById("block2s").style.display="block";
		    				document.getElementById("block1").style.display="block";
		    				document.getElementById("blocks").style.display="block";
		    			}
				}					
			
		    	}		
		}
		exitSelect();
	}
	
	function selectChang(){
		var selectObj = document.getElementById("process_mode");  	 
	    for(var i = 0; i<selectObj.length; i++){ 
	      	if(selectObj.options[i].selected==true){
		        if(selectObj.options[i].value == "1"){ 
		        	document.getElementById("block2").style.display="none";
					document.getElementById("block2s").style.display="none";		        	
		        	document.getElementById("block1").style.display="block";
					document.getElementById("blocks").style.display="block";
					document.getElementsByName("fine_amount")[0].value="";
		        }  
		        if (selectObj.options[i].value == "2"){
					document.getElementsByName("administrative_process")[0].value="";
		        	document.getElementById("block1").style.display="none";
					document.getElementById("blocks").style.display="none";
					document.getElementById("block2").style.display="block";
					document.getElementById("block2s").style.display="block";
		        }
		        if(selectObj.options[i].value == "3"){
    				document.getElementById("block2").style.display="block";
    				document.getElementById("block2s").style.display="block";
    				document.getElementById("block1").style.display="block";
    				document.getElementById("blocks").style.display="block";
    				document.getElementsByName("fine_amount")[0].value="";
    				document.getElementsByName("administrative_process")[0].value="";
    			}
    			if(selectObj.options[i].value == ""){
    				document.getElementById("block2").style.display="block";
    				document.getElementById("block2s").style.display="block";
    				document.getElementById("block1").style.display="block";
    				document.getElementById("blocks").style.display="block";
    				document.getElementsByName("fine_amount")[0].value="";
    				document.getElementsByName("administrative_process")[0].value="";
    			}
	      	}
	       }  
		
	}
	
	function selectChange(){
		var selectObj = document.getElementById("labor_class");  
	    for(var i = 0; i<selectObj.length; i++){ 
	      	if(selectObj.options[i].selected==true){
				if(selectObj.options[i].value == "1"){ 
		        	document.getElementById("div0rowNum").style.display="none";	        	
		        	document.getElementById("div1rowNum").style.display="block";
		        }   
		        if (selectObj.options[i].value == "2"){		        	
		        	document.getElementById("div1rowNum").style.display="none"; 
					document.getElementById("div0rowNum").style.display="block";
		        }
		        if (selectObj.options[i].value == ""){		        	
		        	document.getElementById("div1rowNum").style.display="none"; 
					document.getElementById("div0rowNum").style.display="none";
		        }
	      	}
	       }  
		
        
	}
 
	
	//正式工
	 function selectPerson(){
			var isProject = "<%=isProject%>";
			if(isProject=="1"){
				var result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanMultiple.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
			}else if(isProject=="2"){
				var result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanSingle.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
			}
		    
		    if(result!="" && result!=undefined){
		    	var checkStr=result.split(",");
		    	for(var i=0;i<checkStr.length-1;i++){
		    		var testTemp = checkStr[i].split("-");
		    		if(testTemp[6]=="正式工"){
			    		document.getElementById("employe_id").value=testTemp[0];
		    		}else{
		    			document.getElementById("labor_id").value=testTemp[0];		
		    		}
		    		document.getElementById("staff_name").value=testTemp[1];
		    		document.getElementById("illeagl_code").value=testTemp[3];				       
		    		document.getElementById("illegal_post").value=testTemp[4];
		    		document.getElementById("illeagl_personnel_level").value=testTemp[5];		    	
		    		document.getElementById("labor_class").value=testTemp[6];
		       	}	
		   }
		 }
		//临时工页面
	 function selectLabor(){
		    var result = showModalDialog('<%=contextPath%>/rm/em/singleHuman/laborAccept/commLaborList.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes'); 
			if(result!="" && result!=undefined ){
				 	var testTemp = result.split("-");
					document.getElementById("staff_name").value=testTemp[1];
					document.getElementById("labor_id").value=testTemp[0];					
					document.getElementById("illeagl_code").value=testTemp[2];				       
		    		document.getElementById("illegal_post").value=testTemp[3];
		    		document.getElementById("illeagl_personnel_level").value=testTemp[4];
		
		    }
	 }


	//處理選中的值selected
	 function exitSelect(){
		 
			var selectObj = document.getElementById("hazard_center");  
			var aa = document.getElementById("aa").value; 
		    for(var i = 0; i<selectObj.length; i++){ 
		        if(selectObj.options[i].value == aa){ 
		        	selectObj.options[i].selected = 'selected';     
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/illegalManagement/addIllegalManagement.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/illegalManagement/addIllegalManagement.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&illegal_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/illegalManagement/addIllegalManagement.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&illegal_no="+ids);
	  	
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
		deleteEntities("update BGP_ILLEGAL_MANAGEMENT e set e.bsflag='1' where e.illegal_no  in ("+id+")");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/illegalManagement/hse_search.jsp?isProject=<%=isProject%>");
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
		 
			var hazard_center = document.getElementsByName("hazard_center")[0].value;
			var staff_name = document.getElementsByName("staff_name")[0].value;		
			var illegal_level = document.getElementsByName("illegal_level")[0].value;			
			var found_way = document.getElementsByName("found_way")[0].value;			
  
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(hazard_center==""){
	 			alert("危害因素中类不能为空，请填写！");
	 			return true;
	 		}
	 		if(staff_name==""){
	 			alert("违章人员姓名不能为空，请选择！");
	 			return true;
	 		}
	 		if(illegal_level==""){
	 			alert("违章级别不能为空，请填写！");
	 			return true;
	 		}
	 
			if(found_way==""){
	 			alert("发现方式不能为空，请填写！");
	 			return true;
	 		} 
	 		return false;
	 	}
	 	
		function checkJudge1(){ 
 
			var process_level = document.getElementsByName("process_level")[0].value;
			var process_mode = document.getElementsByName("process_mode")[0].value;		
			var process_time = document.getElementsByName("process_time")[0].value;			
		  
	 		if(process_level==""){
	 			alert("处理级别不能为空，请填写！");
	 			return true;
	 		}
	 		if(process_mode==""){
	 			alert("处理方式不能为空，请选择！");
	 			return true;
	 		}
	 		if(process_time==""){
	 			alert("处理时间不能为空，请填写！");
	 			return true;
	 		}
	   
	 		return false;
	 	}

	function toUpdate(nullParam){		
		var rowParams = new Array(); 
		var rowParam = {};	
		var illegal_no = document.getElementsByName("illegal_no")[0].value;					 
		  if(illegal_no !=null && illegal_no !=''){		
			  
			  if(nullParam =='1'){
				if(checkJudge()){
					return;
				}
			  }
			  if(nullParam =='2'){
					if(checkJudge1()){
						return;
					}
				  }
			  
 				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
		 
				var employe_id = document.getElementsByName("employe_id")[0].value;
				var labor_class = document.getElementsByName("labor_class")[0].value;		
				var labor_id = document.getElementsByName("labor_id")[0].value;			
				
				var sites_post = document.getElementsByName("sites_post")[0].value;
				var hazard_class = document.getElementsByName("hazard_center")[0].value;		
				var staff_name = document.getElementsByName("staff_name")[0].value;			
				var illegal_post = document.getElementsByName("illegal_post")[0].value;		
				var illeagl_code = document.getElementsByName("illeagl_code")[0].value;		
				var illeagl_personnel_level = document.getElementsByName("illeagl_personnel_level")[0].value;	
				var lllegal_description = document.getElementsByName("lllegal_description")[0].value;
				var illegal_level = document.getElementsByName("illegal_level")[0].value;		
				var found_way = document.getElementsByName("found_way")[0].value;		
				var violation_time = document.getElementsByName("violation_time")[0].value;		

				var process_level = document.getElementsByName("process_level")[0].value;		
				var process_mode = document.getElementsByName("process_mode")[0].value;	
				var process_time = document.getElementsByName("process_time")[0].value;
				var administrative_process = document.getElementsByName("administrative_process")[0].value;		
				var fine_amount = document.getElementsByName("fine_amount")[0].value;		
				var process_state = document.getElementsByName("process_state")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;		
				var corrective_measures = document.getElementsByName("corrective_measures")[0].value;
				 
				 if(process_mode !=""){					
							 process_state="已处理"; 				 									 
				 }else{
					 process_state="未处理"; 						 
				 }
					
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				rowParam['corrective_measures'] = encodeURI(encodeURI(corrective_measures));
				rowParam['sites_post'] = encodeURI(encodeURI(sites_post));
				rowParam['hazard_class'] = encodeURI(encodeURI(hazard_class));
				rowParam['staff_name'] = encodeURI(encodeURI(staff_name));
				rowParam['illegal_post'] = encodeURI(encodeURI(illegal_post));		 		
				rowParam['illeagl_code'] = encodeURI(encodeURI(illeagl_code));
				rowParam['illeagl_personnel_level'] = encodeURI(encodeURI(illeagl_personnel_level));				
				rowParam['lllegal_description'] = encodeURI(encodeURI(lllegal_description));
				rowParam['illegal_level'] = encodeURI(encodeURI(illegal_level));
				rowParam['found_way'] = encodeURI(encodeURI(found_way));
				rowParam['violation_time'] = encodeURI(encodeURI(violation_time));	
				rowParam['employe_id'] = encodeURI(encodeURI(employe_id));
				rowParam['labor_class'] = encodeURI(encodeURI(labor_class));
				rowParam['labor_id'] = encodeURI(encodeURI(labor_id));		
 
				rowParam['process_level'] = encodeURI(encodeURI(process_level));
				rowParam['process_mode'] = encodeURI(encodeURI(process_mode));				
				rowParam['process_time'] = encodeURI(encodeURI(process_time));
				rowParam['administrative_process'] = encodeURI(encodeURI(administrative_process));
				rowParam['fine_amount'] = fine_amount;
				rowParam['process_state'] = encodeURI(encodeURI(process_state));	
				
				    rowParam['illegal_no'] = illegal_no;
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
			 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_ILLEGAL_MANAGEMENT",rows);	
			    refreshData();	 
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

