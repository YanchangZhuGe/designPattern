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
	SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
 
<title>问题项整改验证</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
	      	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">整改日期</td>
			    <td class="inquire_form6"><input id="changeDate" name="changeDate" type="text" />
			    <img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(changeDate,tributton0);" />&nbsp;
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{problem_no}' value='{problem_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{rectification_date}">整改完成日期</td>
			      <td class="bt_info_even" exp="{if_corrective}">是否整改</td>
			      <td class="bt_info_odd" exp="{if_qualified}">整改是否合格</td>
			      <td class="bt_info_even" exp="{verify_date}">验证日期</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">整改信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">验证情况</a></li>				 
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="right" height="30">
                  <td>&nbsp;</td>
                  <td width="30" id="buttonDis3" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
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
			      	<input type="hidden" id="problem_no" name="problem_no"   />
			      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			      	<%}%>
			      	</td> 
			 	    <td class="inquire_item6"><font color="red">*</font>是否整改：</td>					 
				    <td class="inquire_form6"> 
				    <select id="if_corrective" name="if_corrective" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >是</option>
				       <option value="2" >否</option> 
					</select></td>						    				    
					</tr>										 		
				    <tr>					  
					<td class="inquire_item6"><font color="red">*</font>整改完成日期：</td>
				    <td class="inquire_form6"><input type="text" id="rectification_date" name="rectification_date" class="input_width"   readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_date,tributton1);" />&nbsp;</td>
				   <td class="inquire_item6"><font color="red">*</font>整改负责人：</td>
				    <td class="inquire_form6"><input type="text" id="rectification_in" name="rectification_in"    class="input_width"/></td>
				    </tr>		 		

				    <tr>					  
					<td class="inquire_item6"><font color="red">*</font>体系要素号：</td>
				    <td class="inquire_form6"><input type="text" id="psystem_elements" name="psystem_elements" class="input_width"   readonly="readonly"/>
				    <input type="hidden" id="qdetail_no" name="qdetail_no" class="input_width"   />
				    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectContent()"/>
				    </td>
				   <td class="inquire_item6">问题类别：</td>
				    <td class="inquire_form6"><input type="text" id="pproblem_category" name="pproblem_category"    class="input_width" readonly="readonly" /></td>
				    </tr>	
				    <tr>					  
					<td class="inquire_item6">问题性质：</td>
				    <td class="inquire_form6"><input type="text" id="pnature" name="pnature" class="input_width"   readonly="readonly"/>
				    </td>
				   
				    </tr>	
			</table>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
			  <tr>
			    <td class="inquire_item6"><font color="red">*</font>问题项：</td> 					   
			    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px;height:50px;" id="a_problem" name="a_problem"   class="textarea" ></textarea>
			   
			    </td>
			    <td class="inquire_item6"> </td> 				 
			  </tr>	
			  <tr>
			    <td class="inquire_item6"><font color="red">*</font>整改结果综述：</td> 					   
			    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px;height:50px;" id="rectification_results" name="rectification_results"   class="textarea" ></textarea></td>
			    <td class="inquire_item6"> </td> 				 
			  </tr>	
				</table>												
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">		 								
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="right" height="30">
                  <td>&nbsp;</td>
                  <td width="30" id="buttonDis3" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
                  <td width="5"></td>
                </tr>
              </table>
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
			  <tr>		 		  	   
			      <td class="inquire_item6">验证日期：</td>
		    	  <td class="inquire_form6">
		    	  <input type="text" id="verify_date" name="verify_date" class="input_width"   readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(verify_date,tributton2);" />&nbsp;</td>
				  <td class="inquire_item6">验证人：</td>
		    	  <td class="inquire_form6">
		    	  <input type="text" id="verifier" name="verifier"    class="input_width"/></td>		    	
			    </tr>					  
				<tr>
				    <td class="inquire_item6">整改是否合格：</td>					 
				    <td class="inquire_form6"> 
				    <select id="if_qualified" name="if_qualified" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >是</option>
				       <option value="2" >否</option> 
					</select></td>	
			        <td class="inquire_item6">风险消减情况：</td>					 
				    <td class="inquire_form6"> 
				    <select id="risk_situation" name="risk_situation" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >消减</option>
				       <option value="2" >消除</option> 
					</select></td>						    				    
					</tr>									 		
				   	 
					</table>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
			    <tr>
			    <td class="inquire_item6">验证情况综述：</td> 					   
			    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:730px;height:50px;" id="validation_reviews" name="validation_reviews"   class="textarea" ></textarea>
			    </td>
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
		cruConfig.queryStr = " select   tr.problem_no,tr.a_problem,decode(tr.if_corrective,'1','是','2','否') if_corrective,tr.rectification_date,tr.rectification_in,tr.rectification_results,tr.verify_date,tr.verifier,decode(tr.if_qualified,'1','是','2','否') if_qualified,tr.risk_situation,tr.validation_reviews,tr.second_org,tr.third_org,ion.org_abbreviation org_name,tr.org_sub_id, tr.creator,tr.create_date,tr.bsflag,oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_RECTIFICATION_PROBLEM tr  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'   where tr.bsflag = '0' "+querySqlAdd+"  order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/rectificationProblem/rectificationProblemList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/rectificationProblem/rectificationProblemList.jsp";
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
		var changeDate = document.getElementById("changeDate").value;
			if(changeDate!=''&& changeDate!=null){
				var isProject = "<%=isProject%>";
				var querySqlAdd = "";
				if(isProject=="1"){
					querySqlAdd = getMultipleSql2("tr.");
				}else if(isProject=="2"){
					querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
				}
				cruConfig.cdtType = 'form';
				cruConfig.queryStr = " select   tr.problem_no,tr.a_problem,decode(tr.if_corrective,'1','是','2','否') if_corrective,tr.rectification_date,tr.rectification_in,tr.rectification_results,tr.verify_date,tr.verifier,decode(tr.if_qualified,'1','是','2','否') if_qualified,tr.risk_situation,tr.validation_reviews,tr.second_org,tr.third_org,ion.org_abbreviation org_name,tr.org_sub_id, tr.creator,tr.create_date,tr.bsflag,oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_RECTIFICATION_PROBLEM tr   left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'   where tr.bsflag = '0' "+querySqlAdd+" and to_char(tr.rectification_date,'yyyy-MM-dd')='"+changeDate+"' order by tr.modifi_date desc";
				cruConfig.currentPageUrl = "/hse/changeManagement/changeManagementList.jsp";
				queryData(1);
			}else{
				refreshData();
			}
	}
	
	function clearQueryText(){
		document.getElementById("changeDate").value = "";
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
			
			querySql = "  select  tr.project_no,tr.qdetail_no,tr.psystem_elements,tr.pproblem_category,tr.pnature,tr.problem_no,tr.a_problem,tr.if_corrective,tr.rectification_date,tr.rectification_in,tr.rectification_results,tr.verify_date,tr.verifier,tr.if_qualified,tr.risk_situation,tr.validation_reviews,tr.second_org,tr.third_org,ion.org_abbreviation org_name,tr.org_sub_id, tr.creator,tr.create_date,tr.bsflag,oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_RECTIFICATION_PROBLEM tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'   where tr.bsflag = '0' and tr.problem_no='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){			 
			         document.getElementsByName("problem_no")[0].value=datas[0].problem_no; 
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
		  		    
		    		 document.getElementsByName("a_problem")[0].value=datas[0].a_problem;
		    		 document.getElementsByName("if_corrective")[0].value=datas[0].if_corrective;		
		    		 document.getElementsByName("rectification_date")[0].value=datas[0].rectification_date;			
		    		 document.getElementsByName("rectification_in")[0].value=datas[0].rectification_in;			
		    	     document.getElementsByName("rectification_results")[0].value=datas[0].rectification_results;
		    		 document.getElementsByName("verify_date")[0].value=datas[0].verify_date;
		    		 document.getElementsByName("verifier")[0].value=datas[0].verifier;		
		    		 document.getElementsByName("if_qualified")[0].value=datas[0].if_qualified;			
		    		 document.getElementsByName("risk_situation")[0].value=datas[0].risk_situation;			
		    	     document.getElementsByName("validation_reviews")[0].value=datas[0].validation_reviews;

		    	     document.getElementsByName("qdetail_no")[0].value=datas[0].qdetail_no;
		    	     document.getElementsByName("psystem_elements")[0].value=datas[0].psystem_elements;
		    	     document.getElementsByName("pproblem_category")[0].value=datas[0].pproblem_category;
		    	     document.getElementsByName("pnature")[0].value=datas[0].pnature;
	
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
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/addRectificationProblem.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
	 	popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/addRectificationProblem.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&problem_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/addRectificationProblem.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&problem_no="+ids);
	  	
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
		deleteEntities("update BGP_RECTIFICATION_PROBLEM e set e.bsflag='1' where e.problem_no in ("+id+")");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/hse_search.jsp?isProject=<%=isProject%>");
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
 
				var a_problem = document.getElementsByName("a_problem")[0].value;
				var if_corrective = document.getElementsByName("if_corrective")[0].value;		
				var rectification_date = document.getElementsByName("rectification_date")[0].value;			
				var rectification_in = document.getElementsByName("rectification_in")[0].value;			
				var rectification_results = document.getElementsByName("rectification_results")[0].value;
				var psystem_elements = document.getElementsByName("psystem_elements")[0].value;
				
		 		if(org_sub_id==""){
		 			document.getElementById("org_sub_id").value = "";
		 		}
		 		if(second_org==""){
		 			document.getElementById("second_org").value="";
		 		}
		 		if(third_org==""){
		 			document.getElementById("third_org").value="";
		 		}
		 		if(a_problem==""){
		 			alert("问题项不能为空，请填写！");
		 			return true;
		 		}
		 		if(if_corrective==""){
		 			alert("是否整改不能为空，请选择！");
		 			return true;
		 		}
		 		if(rectification_date==""){
		 			alert("整改完成日期不能为空，请填写！");
		 			return true;
		 		}
		 
				if(rectification_in==""){
		 			alert("整改负责人不能为空，请填写！");
		 			return true;
		 		}
				if(rectification_results==""){
		 			alert("整改结果综述不能为空，请填写！");
		 			return true;
		 		}
				if(psystem_elements==""){
		 			alert("体系要素号不能为空，请填写！");
		 			return true;
		 		}
			 
		 		
		 		return false;
		 	}
		 
	 
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var problem_no = document.getElementsByName("problem_no")[0].value;						 
		  if(problem_no !=null && problem_no !=''){				  
				if(checkJudge()){
					return;
				}
				
				var problem_no = document.getElementsByName("problem_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;					
				var a_problem = document.getElementsByName("a_problem")[0].value;
				var if_corrective = document.getElementsByName("if_corrective")[0].value;		
				var rectification_date = document.getElementsByName("rectification_date")[0].value;			
				var rectification_in = document.getElementsByName("rectification_in")[0].value;			
				var rectification_results = document.getElementsByName("rectification_results")[0].value;   
				var verify_date = document.getElementsByName("verify_date")[0].value;
				var verifier = document.getElementsByName("verifier")[0].value;		
				var if_qualified = document.getElementsByName("if_qualified")[0].value;			
				var risk_situation = document.getElementsByName("risk_situation")[0].value;			
				var validation_reviews = document.getElementsByName("validation_reviews")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;						 
				 
				var qdetail_no = document.getElementsByName("qdetail_no")[0].value;
				var psystem_elements = document.getElementsByName("psystem_elements")[0].value;
				var pproblem_category = document.getElementsByName("pproblem_category")[0].value;
				var pnature = document.getElementsByName("pnature")[0].value;
		
				rowParam['org_sub_id'] = org_sub_id; // '<%=orgSubId%>';
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;						
				rowParam['a_problem'] = encodeURI(encodeURI(a_problem));
				rowParam['if_corrective'] = encodeURI(encodeURI(if_corrective));
				rowParam['rectification_date'] = encodeURI(encodeURI(rectification_date));
				rowParam['rectification_in'] = encodeURI(encodeURI(rectification_in));		 
				rowParam['rectification_results'] = encodeURI(encodeURI(rectification_results));
				rowParam['verify_date'] = encodeURI(encodeURI(verify_date));
				rowParam['verifier'] = encodeURI(encodeURI(verifier));
				rowParam['if_qualified'] = encodeURI(encodeURI(if_qualified));
				rowParam['risk_situation'] = encodeURI(encodeURI(risk_situation));		 
				rowParam['validation_reviews'] = encodeURI(encodeURI(validation_reviews));	
				
				rowParam['qdetail_no'] = encodeURI(encodeURI(qdetail_no));	
				rowParam['psystem_elements'] = encodeURI(encodeURI(psystem_elements));	
				rowParam['pproblem_category'] = encodeURI(encodeURI(pproblem_category));	
				rowParam['pnature'] = encodeURI(encodeURI(pnature));	
	
				 if(project_no !=null && project_no !=''){
						rowParam['project_no'] =project_no;	
					}else{
						rowParam['project_no'] ='<%=projectInfoNo%>';
					}
				 
				    rowParam['problem_no'] = problem_no;
					rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['create_date'] =create_date;
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
					
			 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_RECTIFICATION_PROBLEM",rows);	
				refreshData();	
 
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
 
	function  selectContent(){ 
		//  window.open("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/homeFrame.jsp",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
		  window.open('<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/orderList.jsp?isProject=<%=isProject%>','pagename','height=400,width=650px,left=350px,top=160px,menubar=no,status=no,toolbar=no');
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

