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
 
<title>HSE检查管理</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">检查名称</td>
			    <td class="ali_cdn_input"><input id="materialName" name="materialName" type="text" /></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{check_no}' value='{check_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{check_unit_org}">被检查单位</td>			      
			      <td class="bt_info_odd" exp="{check_roots_org}">被检查基层单位</td>
			      <td class="bt_info_even" exp="{check_typename}">检查类别</td>
			      <td class="bt_info_odd" exp="{leadership_ledname}">领导带队</td>
			      <td class="bt_info_even" exp="{check_name}">检查名称</td> 
			      <td class="bt_info_odd" exp="{check_start_time}">检查开始时间</td>
			      <td class="bt_info_even" exp="{check_end_time}">检查结束时间</td>
			      <td class="bt_info_odd" exp="{number_problems}">问题数量</td> 

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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">问题整改</a></li>		
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">整改验证</a></li>	
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
	             	 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					    
					    <tr>	
					    <td class="inquire_item6"> 检查名称：</td>
					    <td class="inquire_form6"><input type="text" id="check_name" name="check_name" class="input_width" readonly="readonly" style="color:gray"  value="自动生成"/></td>
						  <td class="inquire_item6">检查单位：</td>
				        	<td class="inquire_form6">
				        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>
				       	<td class="inquire_item6">检查基层单位：</td>
				        	<td class="inquire_form6">
				        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
					    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	<%} %>
				        	</td>				 
				    	  
					  </tr>			      
				   	
					  <tr>	
					  <td class="inquire_item6"> 被检查单位：</td>
				      	<td class="inquire_form6">				     
				      	<input type="text" id="check_unit_org" name="check_unit_org" class="input_width"    readonly="readonly"/>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
				      	</td>
					    <td class="inquire_item6"><font color="red">*</font>被检查基层单位：</td>
				      	<td class="inquire_form6">				     
				      	<input type="text" id="check_roots_org" name="check_roots_org" class="input_width"    readonly="readonly"/>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs2()"/>
				      	</td>
				        <td class="inquire_item6"><font color="red">*</font>被检查部门/部位：</td>					 
					    <td class="inquire_form6"> 
					    <input type="text" id="check_parts" name="check_parts" class="input_width"   />     </td>	 	  
			    	  
			    	  </tr>		  
				   		   			  
					  	<tr>
				        <td class="inquire_item6"><font color="red">*</font>检查类别：</td>					 
					    <td class="inquire_form6"> 
					    <select id="check_type" name="check_type" class="select_width" onchange="selectParam(this)">
					       <option value="" >请选择</option>
					       <option value="1" >日常检查</option>
					       <option value="2" >专项检查</option>
					       <option value="3" >联系点到位</option>
						</select>   </td>							
					    <td class="inquire_item6"><font color="red">*</font>是否承包商队伍检查：</td>
					    <td class="inquire_form6">
					    <select id="if_contractor_team" name="if_contractor_team" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="2" >否</option>	
						</select>  					    
					    </td>		
					    <td class="inquire_item6"><div id="divS" style="display:none;">联系人：</div></td>
					    <td class="inquire_form6"><div id="divSe" style="display:none;"><input type="text" id="contact" name="contact"    class="input_width"/> </div></td>
						</tr>						
				 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>领导带队：</td>
					    <td class="inquire_form6"> 
					    <select id="leadership_led" name="leadership_led" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="2" >否</option>					      
						</select>
					    </td>					   
					    <td class="inquire_item6">带队领导：</td>
					    <td class="inquire_form6">
					    <input type="text" id="led_leadership" name="led_leadership" class="input_width" />
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>检查成员：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_members" name="check_members" class="input_width" />
						</td>
					  </tr>					  
					  <tr>				
		 			    <td class="inquire_item6"><font color="red">*</font>检查开始时间：</td>
					    <td class="inquire_form6"><input type="text" id="check_start_time" name="check_start_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_start_time,tributton1);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>检查结束时间：</td>
					    <td class="inquire_form6"><input type="text" id="check_end_time" name="check_end_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_end_time,tributton2);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>检查级别：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				    	<input type="hidden" id="project_no" name="project_no" value="" />
				      	<input type="hidden" id="check_no" name="check_no"   />
				      	 <select id="check_level" name="check_level" class="select_width" onchange="selectName(this)">
					       <option value="" >请选择</option>
					       <option value="1" >公司</option>
					       <option value="2" >二级单位</option>	
					       <option value="3" >基层单位</option>
						</select>
				      	</td>
					    		
					  </tr>					
					  <tr>				
					 		 
					    <td class="inquire_item6"> 问题数量：</td>
					    <td class="inquire_form6"><input type="text" id="number_problems" name="number_problems" class="input_width" readonly="readonly" /></td>
					  </tr>						  
					  
					</table>
					  
				</div>
		
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="70" id="buttonDis3" >		     
		                  <span class="zj"  onclick="toAddDetail()"><a href="#"></a></span>
		                  <span class="sc"  onclick="toExitDetail()"><a href="#"></a></span>		                  
		                  </td>
		                  <td width="5"></td>
		                </tr>
		              </table>
		              <table  id="hseTableInfo3" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">						 
					  <tr>
			    	    <td class="bt_info_even">选择</td>			  
			            <td  class="bt_info_odd">存在单位</td>
			            <td class="bt_info_even">存在基层单位</td>		
			            <td  class="bt_info_odd">存在部门/部位</td>			            
			            <td class="bt_info_even">原因分析</td>		
			            <td  class="bt_info_odd">整改要求</td>
			            <td class="bt_info_even">整改完成情况</td>		
			            <td  class="bt_info_odd">整改完成时间</td>
					  </tr>
					</table>
 
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30" id="buttonDis3" >		     
	                  <span class="bc" onclick="toUpdate()"><a href="#"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	              </table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo2">			
					 
				  <tr>  
				    <td class="inquire_item6"> 整改验证人：</td>
				    <td class="inquire_form6" >	 <input type="text" id="verifier" name="verifier" class="input_width" /></td>		
				    <td class="inquire_item6"> 整改验证时间：</td>
				    <td class="inquire_form6"><input type="text" id="verifier_time" name="verifier_time" class="input_width"   readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(verifier_time,tributton3);" />&nbsp;</td>
				 </tr>	
				 <tr>
				    <td class="inquire_item6"> 整改验证意见：</td>			 
				    <td class="inquire_form6" colspan="5"><textarea id="verifier_opinion" name="verifier_opinion"   class="textarea" ></textarea></td>
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
			retObj = jcdpCallService("HseSrv", "queryOrg", "");
			if(retObj.flag!="false"){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag!="0"){
						querySqlAdd = " and tr.org_sub_id = '" + retObj.list[0].orgSubId +"'";
						if(len>1){
							if(retObj.list[1].organFlag!="0"){
								querySqlAdd = " and tr.second_org = '" + retObj.list[1].orgSubId +"'";
							}
						}
					}
				}
			}
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = " select tr.check_no,case when length(tr.check_unit_org)<= 6 then tr.check_unit_org else concat(substr(tr.check_unit_org,0,6),'...') end check_unit_org, decode(tr.check_type,'1','日常检查','2','专项检查','3','联系点到位','','其他') check_typename, decode(tr.leadership_led,'1','是','2','否') leadership_ledname , case when length(tr.check_roots_org)<= 6 then tr.check_roots_org else concat(substr(tr.check_roots_org,0,6),'...') end check_roots_org,tr.check_parts,tr.check_type,tr.if_contractor_team,tr.contact,tr.leadership_led, tr.led_leadership,tr.check_members,tr.check_start_time,tr.check_end_time,tr.check_name,tr.number_problems,tr.verifier,tr.verifier_time,tr.verifier_opinion,  tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name   from BGP_HSE_CHECK tr  left join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'     left join comm_org_information ion  on ion.org_id = os1.org_id  where tr.bsflag = '0' and tr.leadership_led='1' "+querySqlAdd+" order by  tr.modifi_date desc "; 
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hseCheck/hseCheckList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
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
				retObj = jcdpCallService("HseSrv", "queryOrg", "");
				if(retObj.flag!="false"){
					var len = retObj.list.length;
					if(len>0){
						if(retObj.list[0].organFlag!="0"){
							querySqlAdd = " and tr.org_sub_id = '" + retObj.list[0].orgSubId +"'";
							if(len>1){
								if(retObj.list[1].organFlag!="0"){
									querySqlAdd = " and tr.second_org = '" + retObj.list[1].orgSubId +"'";
								}
							}
						}
					}
				}
			}else if(isProject=="2"){
				querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
			}
			
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = " select tr.check_no,case when length(tr.check_unit_org)<= 6 then tr.check_unit_org else concat(substr(tr.check_unit_org,0,6),'...') end check_unit_org, decode(tr.check_type,'1','日常检查','2','专项检查','3','联系点到位','','其他') check_typename, decode(tr.leadership_led,'1','是','2','否') leadership_ledname , case when length(tr.check_roots_org)<= 6 then tr.check_roots_org else concat(substr(tr.check_roots_org,0,6),'...') end check_roots_org,tr.check_parts,tr.check_type,tr.if_contractor_team,tr.contact,tr.leadership_led, tr.led_leadership,tr.check_members,tr.check_start_time,tr.check_end_time,tr.check_name,tr.number_problems,tr.verifier,tr.verifier_time,tr.verifier_opinion,  tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name   from BGP_HSE_CHECK tr  left join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'     left join comm_org_information ion  on ion.org_id = os1.org_id  where tr.bsflag = '0' and tr.leadership_led='1' "+querySqlAdd+" and tr.check_name like '%"+materialName+"%' order by  tr.modifi_date desc "; 
			cruConfig.currentPageUrl = "/hse/hseOptionPage/hseCheck/hseCheckList.jsp";
			queryData(1);
	}
	
	function clearQueryText(){
		document.getElementById("materialName").value = "";
	}

	function loadDataDetail(shuaId){
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;	
			
			querySql = "  select  tr.project_no,tr.check_level,tr.org_sub_id, cl.sumnum,tr.check_no,tr.check_unit_org,tr.check_roots_org, tr.check_parts,tr.check_type,tr.if_contractor_team,tr.contact,tr.leadership_led, tr.led_leadership,tr.check_members,tr.check_start_time,tr.check_end_time,tr.check_name,tr.number_problems,tr.verifier,tr.verifier_time,tr.verifier_opinion,  tr.second_org,tr.third_org,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as org_name  from BGP_HSE_CHECK tr   left join ( select   count(check_detail_no) sumnum ,check_no  from   BGP_HSE_CHECK_DETAIL where check_no='"+ shuaId +"' and bsflag='0' group by check_no) cl  on  cl.check_no=tr.check_no  left  join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'   left join comm_org_subjection os2 on tr.org_sub_id = os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0'  where tr.bsflag = '0' and tr.check_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 		   
		             document.getElementsByName("check_no")[0].value=datas[0].check_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		       		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		      		 document.getElementsByName("check_level")[0].value=datas[0].check_level;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	    	
		    		 
		    		 document.getElementsByName("check_unit_org")[0].value=datas[0].check_unit_org;
		    		 document.getElementsByName("check_roots_org")[0].value=datas[0].check_roots_org;		
		    		 document.getElementsByName("check_parts")[0].value=datas[0].check_parts;			
		    		 document.getElementsByName("check_type")[0].value=datas[0].check_type;			
		    		 document.getElementsByName("if_contractor_team")[0].value=datas[0].if_contractor_team;
		    		 document.getElementsByName("contact")[0].value=datas[0].contact;
		    	     document.getElementsByName("leadership_led")[0].value=datas[0].leadership_led;		
		    	     document.getElementsByName("led_leadership")[0].value=datas[0].led_leadership;
		    		 document.getElementsByName("check_members")[0].value=datas[0].check_members;		
		    		 document.getElementsByName("check_start_time")[0].value=datas[0].check_start_time;			
		    		 document.getElementsByName("check_end_time")[0].value=datas[0].check_end_time;			
		    		 document.getElementsByName("check_name")[0].value=datas[0].check_name;
		    		 document.getElementsByName("number_problems")[0].value=datas[0].sumnum;
 
		      		 document.getElementsByName("verifier")[0].value=datas[0].verifier;			
		    		 document.getElementsByName("verifier_time")[0].value=datas[0].verifier_time;
		    		 document.getElementsByName("verifier_opinion")[0].value=datas[0].verifier_opinion;
		    		  document.getElementsByName("project_no")[0].value=datas[0].project_no;	
		    		  
		    			if(datas[0].check_type =="3"){			
		    				 document.getElementById('divS').style.display='block'; 
		    				 document.getElementById('divSe').style.display='block'; 
		    			}else{
		    				 document.getElementById('divS').style.display='none'; 
		    				 document.getElementById('divSe').style.display='none'; 
		    			}
				}					
			
		    	}		
			
			var querySql1="";
			var queryRet1=null;
			var datas1 =null;
			 deleteTableTr("hseTableInfo3"); 
				   querySql1 = "  select cn.check_detail_no,cn.check_no, case when length(cn.exist_unit)<= 6 then cn.exist_unit else concat(substr(cn.exist_unit,0,6),'...') end exist_unit,   case when length(cn.roots_unit)<= 6 then cn.roots_unit else concat(substr(cn.roots_unit,0,6),'...') end roots_unit,   case when length(cn.exist_parts)<= 6 then cn.exist_parts else concat(substr(cn.exist_parts,0,6),'...') end exist_parts,   case when length(cn.gause_analysis)<= 6 then cn.gause_analysis else concat(substr(cn.gause_analysis,0,6),'...') end gause_analysis,   case when length(cn.requirements)<= 6 then cn.requirements else concat(substr(cn.requirements,0,6),'...') end requirements,  case when length(cn.completion)<= 6 then cn.completion else concat(substr(cn.completion,0,6),'...') end completion,cn.completion_time from BGP_HSE_CHECK_DETAIL cn  left join BGP_HSE_CHECK tr on cn.check_no=tr.check_no and tr.bsflag='0'  where cn.bsflag='0' and cn.check_no='"+shuaId+"' ";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;		
						if(datas1 != null && datas1 != ''){	
							var selectedRow = 0;
				           for(var i = 0; i<datas1.length; i++){
				        	   var tbObj = document.getElementById("hseTableInfo3");
				        		var tr2 = document.getElementById("hseTableInfo3").insertRow();	
					         	if(i % 2 == 1){  
				              		classCss = "even_";
								}else{ 
									classCss = "odd_";
								}
					         	var td2 = tr2.insertCell(0);
								td2.className=classCss+"odd";
								td2.innerHTML = '<input type="radio" name="chx_entity_ids" value="'+datas1[i].check_detail_no+','+datas1[i].check_no+'" >';
								
								var td2 = tr2.insertCell(1);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].exist_unit;
								
					         	var td2 = tr2.insertCell(2);
								td2.className=classCss+"odd";
								td2.innerHTML =datas1[i].roots_unit;
								
								var td2 = tr2.insertCell(3);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].exist_parts;						
																
					         	var td2 = tr2.insertCell(4);
								td2.className=classCss+"odd";
								td2.innerHTML =datas1[i].gause_analysis;
								
								var td2 = tr2.insertCell(5);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].requirements;
								
					         	var td2 = tr2.insertCell(6);
								td2.className=classCss+"odd";
								td2.innerHTML =datas1[i].completion;
								
								var td2 = tr2.insertCell(7);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].completion_time;
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
									popWindow("<%=contextPath%>/hse/hseOptionPage/hseCheck/addDetail.jsp?check_no="+checkNo+"&check_detail_no="+checkDetailNo);
									
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
	    window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
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
	  window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	  if(teamInfo.fkValue!=""){
	     document.getElementById("check_roots_org").value = teamInfo.value;
	    
	 }
	}

	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseCheck/addhseCheck.jsp?projectInfoNo=<%=projectInfoNo%>");
		
	}
	function selectName(selectName){	
		var selectname=selectName.options[selectName.selectedIndex].text ;
		var  startDate=document.getElementsByName("check_start_time")[0].value;		
		var  checkType=document.getElementsByName("check_type")[0].value;		
		if(startDate!=""){
			var datePSe = startDate.split('-')[0];
			var datePSr = startDate.split('-')[1];
			var datePSt = startDate.split('-')[2];
			var datePSer=datePSe+datePSr+datePSt;
		}
	    if(checkType=="1"){checkType="日常检查"}
	    if(checkType=="2"){checkType="专项检查"}
	    if(checkType=="3"){checkType="联系点到位"}
		 document.getElementsByName("check_name")[0].value=selectname+datePSer+checkType;

	}
	function selectParam(selectParam){
		var selectparam=selectParam.options[selectParam.selectedIndex].text ;
		if(selectparam =="联系点到位"){			
			 document.getElementById('divS').style.display='block'; 
			 document.getElementById('divSe').style.display='block'; 
		}else{
			 document.getElementById('divS').style.display='none'; 
			 document.getElementById('divSe').style.display='none'; 
			
		}
		
	}
	function toAddDetail(){
	   var ids=document.getElementsByName("check_no")[0].value;
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseCheck/addDetail.jsp?check_no="+ids);
		
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
        		var submitStr='JCDP_TABLE_NAME=BGP_HSE_CHECK_DETAIL&JCDP_TABLE_ID='+checkDetailNo+'&bsflag=1';
        		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));
        		loadDataDetail(checkNo);	
        		alert('删除成功');
        		 
            }else{
                alert("请先选中一条子记录信息!");
            	
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseCheck/addhseCheck.jsp?projectInfoNo=<%=projectInfoNo%>&check_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/hseCheck/addhseCheck.jsp?projectInfoNo=<%=projectInfoNo%>&check_no="+ids);
	  	
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
 
		deleteEntities("update BGP_HSE_CHECK  e set e.bsflag='1' where e.check_no in ("+id+")");
	 
	}
	function toSearch(){
		popWindow("<%=contextPath%>/hse/leaderAndPromise/hseCheck/hse_search.jsp?isProject=<%=isProject%>&paramS=1");
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


	 	 
	 	
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var check_no = document.getElementsByName("check_no")[0].value;						 
		  if(check_no !=null && check_no !=''){			
				var check_no = document.getElementsByName("check_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var check_level = document.getElementsByName("check_level")[0].value;	
				
				var check_unit_org = document.getElementsByName("check_unit_org")[0].value;
				var check_roots_org = document.getElementsByName("check_roots_org")[0].value;		
				var check_parts = document.getElementsByName("check_parts")[0].value;			
				var check_type = document.getElementsByName("check_type")[0].value;			
				var if_contractor_team = document.getElementsByName("if_contractor_team")[0].value;
				var contact = document.getElementsByName("contact")[0].value;
				var leadership_led = document.getElementsByName("leadership_led")[0].value;		
				var led_leadership = document.getElementsByName("led_leadership")[0].value;
				var check_members = document.getElementsByName("check_members")[0].value;		
				var check_start_time = document.getElementsByName("check_start_time")[0].value;			
				var check_end_time = document.getElementsByName("check_end_time")[0].value;			
				var check_name = document.getElementsByName("check_name")[0].value;
				var number_problems = document.getElementsByName("number_problems")[0].value;
				 var verifier=document.getElementsByName("verifier")[0].value;			
	    		 var verifier_time=document.getElementsByName("verifier_time")[0].value;
	    		 var verifier_opinion=document.getElementsByName("verifier_opinion")[0].value;
	    		 var project_no = document.getElementsByName("project_no")[0].value;		
	    			if(check_type =="3"){
	    				if(contact =="") {alert("检查类别为联系点到位，联系人必填！");	return;}		 
	    			}
	    			if(leadership_led =="1"){
	    				if(led_leadership =="") {alert("领导带队为是，带队领导必填！");	return;}		 
	    			}
	    				 
					
					 if(project_no !=null && project_no !=''){
							rowParam['project_no'] =project_no;	
						}else{
							rowParam['project_no'] ='<%=projectInfoNo%>';
						}
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['check_level'] = check_level;			 
				
				rowParam['check_unit_org'] = encodeURI(encodeURI(check_unit_org));
				rowParam['check_roots_org'] = encodeURI(encodeURI(check_roots_org));
				rowParam['check_parts'] = encodeURI(encodeURI(check_parts));
				rowParam['check_type'] = encodeURI(encodeURI(check_type));		 
				rowParam['if_contractor_team'] = encodeURI(encodeURI(if_contractor_team));
				rowParam['contact'] = encodeURI(encodeURI(contact));
				rowParam['leadership_led'] = encodeURI(encodeURI(leadership_led));
				rowParam['led_leadership'] = encodeURI(encodeURI(led_leadership));		 
				rowParam['check_members'] = encodeURI(encodeURI(check_members));
				rowParam['check_start_time'] = encodeURI(encodeURI(check_start_time));
				rowParam['check_end_time'] = encodeURI(encodeURI(check_end_time));
				rowParam['check_name'] = encodeURI(encodeURI(check_name));
				rowParam['number_problems'] =number_problems;
				rowParam['verifier'] = encodeURI(encodeURI(verifier));
				rowParam['verifier_time'] = encodeURI(encodeURI(verifier_time));
				rowParam['verifier_opinion'] = encodeURI(encodeURI(verifier_opinion));
				
			    rowParam['check_no'] = check_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
							 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_HSE_CHECK",rows);	
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

