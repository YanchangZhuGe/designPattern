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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
 
<title>不符合项关闭</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">整改完成日期</td>
			    <td class="ali_cdn_input" ><input id="changeDate" name="changeDate" type="text"  style="width: 80%;"/>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{close_no}' value='{close_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{completion_date}">整改完成日期</td>

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
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
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
						  <td class="inquire_item6"> 单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>						  
						  <td class="inquire_item6"> 基层单位：</td>
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
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="close_no" name="close_no"   />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 

					    <td class="inquire_item6"><font color="red">*</font>整改负责人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="rectification" name="rectification" class="input_width"   />    					    
					    </td>					    
						</tr>						
						 <tr>	
						    <td class="inquire_item6"><font color="red">*</font>整改完成日期：</td>
						    <td class="inquire_form6"><input type="text" id="completion_date" name="completion_date" class="input_width"   readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(completion_date,tributton1);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>不符合条款号：</td>
						    <td class="inquire_form6">
						    <input type="text" id="nonumber" name="nonumber" class="input_width"  readonly="readonly"  />    	
						    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectContent()"/>
						    </td>	
						  </tr>					  
						  <tr>	
						    <td class="inquire_item6"><font color="red">*</font>验证情况：</td>
						    <td class="inquire_form6"> 
						    <input  id="detilNo" name="detilNo" type="hidden" />
						    <select id="validating" name="validating" class="select_width"  >
						       <option value="" >请选择</option>
						       <option value="1" >合格</option>
						       <option value="2" >不合格</option>
							</select> 
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>验证日期：</td>
						    <td class="inquire_form6"><input type="text" id="validating_date" name="validating_date" class="input_width"   readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(validating_date,tributton2);" />&nbsp;</td>
						  </tr>	
					</table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>不符合项内容：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px; height:50px"    readonly="readonly" id="close_content" name="close_content"   class="textarea" ></textarea>
					    
					    </td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>原因分析：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px;height:50px" id="cause_analysis" name="cause_analysis"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>纠正预防措施：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px;height:50px" id="preventive_measures" name="preventive_measures"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改结果综述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px;height:50px" id="rectification_results" name="rectification_results"   class="textarea" ></textarea></td>
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
		cruConfig.queryStr = "   select tr.close_no,tr.close_content,tr.cause_analysis,tr.preventive_measures,tr.completion_date,tr.rectification,tr.rectification_results ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_NOTCONFORM_CLOSE   tr  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0'  left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left  join comm_org_information ion on ion.org_id = ose.org_id  where tr.bsflag = '0' "+querySqlAdd+" order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotConformClose/NotConformClose.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotConformClose/NotConformClose.jsp";
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
					querySqlAdd = getMultipleSql("tr.");
				}else if(isProject=="2"){
					querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
				}
				cruConfig.cdtType = 'form';
				cruConfig.queryStr = " select tr.close_no,tr.close_content,tr.cause_analysis,tr.preventive_measures,tr.completion_date,tr.rectification,tr.rectification_results ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_NOTCONFORM_CLOSE   tr  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0'  left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion on ion.org_id = ose.org_id  where tr.bsflag = '0' "+querySqlAdd+"   and  to_char(tr.completion_date,'yyyy-MM-dd')='"+changeDate+"' order by tr.modifi_date desc";
				cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotConformClose/NotConformClose.jsp";
				queryData(1);
			}else{
				refreshData();
			}
	}
	
	function clearQueryText(){
		document.getElementById("changeDate").value = "";
	}
	
	function selectParam(selectParam){
		var selectparam=selectParam.options[selectParam.selectedIndex].text ;
		var detilNo=document.getElementById("detilNo").value;
	 if(detilNo!='' && detilNo!=null){
		if(selectparam =="合格"){			
			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_ORDER_DETAIL&JCDP_TABLE_ID='+detilNo+'&spare1=已关闭'
			+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		 
		}else if(selectparam =="不合格"){
			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_ORDER_DETAIL&JCDP_TABLE_ID='+detilNo+'&spare1=未关闭'
			+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息	
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
			
			querySql = " select   tr.spare2,  tr.nonumber,tr.validating_date,tr.validating, tr.project_no, tr.close_no,tr.close_content,tr.cause_analysis,tr.preventive_measures,tr.completion_date,tr.rectification,tr.rectification_results ,tr.org_sub_id,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_NOTCONFORM_CLOSE   tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0'  left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left  join comm_org_information ion on ion.org_id = ose.org_id     where tr.bsflag = '0' and tr.close_no='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){	
					 document.getElementsByName("nonumber")[0].value=datas[0].nonumber; 
			    	 document.getElementsByName("validating_date")[0].value=datas[0].validating_date;
			    	 document.getElementsByName("validating")[0].value=datas[0].validating;	    		
		             document.getElementsByName("close_no")[0].value=datas[0].close_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;				    		 
		    	     document.getElementsByName("close_content")[0].value=datas[0].close_content;
		    		 document.getElementsByName("cause_analysis")[0].value=datas[0].cause_analysis;		
		    		 document.getElementsByName("preventive_measures")[0].value=datas[0].preventive_measures;			
		    		 document.getElementsByName("completion_date")[0].value=datas[0].completion_date;		
		    		 document.getElementsByName("rectification")[0].value=datas[0].rectification;		
		    		 document.getElementsByName("rectification_results")[0].value=datas[0].rectification_results;					
		    		  document.getElementsByName("project_no")[0].value=datas[0].project_no;	  		    
		    		  document.getElementsByName("detilNo")[0].value=datas[0].spare2;	
				}					
			
		    	}		
			
		 
		}
		
	}
	function selectContent(){
		window.open('<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/orderList.jsp','pagename','height=400,width=550px,left=350px,top=160px,menubar=no,status=no,toolbar=no');
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
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/addNotConformClose.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
	 	popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/addNotConformClose.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&close_no="+ids); 
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/addNotConformClose.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&close_no="+ids);
	  	
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
		
		deleteEntities("update BGP_NOTCONFORM_CLOSE e set e.bsflag='1' where e.close_no in ("+id+")" );
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/hse_search.jsp?isProject=<%=isProject%>");
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
				var validating_date = document.getElementsByName("validating_date")[0].value;		
				var validating = document.getElementsByName("validating")[0].value;			
				var nonumber = document.getElementsByName("nonumber")[0].value;		
				var close_content = document.getElementsByName("close_content")[0].value;
				var cause_analysis = document.getElementsByName("cause_analysis")[0].value;		
				var preventive_measures = document.getElementsByName("preventive_measures")[0].value;			
				var completion_date = document.getElementsByName("completion_date")[0].value;		
				var rectification = document.getElementsByName("rectification")[0].value;		
				var rectification_results = document.getElementsByName("rectification_results")[0].value;					
				
		 		if(org_sub_id==""){
		 			document.getElementById("org_sub_id").value = "";
		 		}
		 		if(second_org==""){
		 			document.getElementById("second_org").value="";
		 		}
		 		if(third_org==""){
		 			document.getElementById("third_org").value="";
		 		}
		 		if(validating_date==""){
		 			alert("验证日期不能为空，请填写！");
		 			return true;
		 		}
		 		if(validating==""){
		 			alert("验证情况不能为空，请选择！");
		 			return true;
		 		}
		 		if(nonumber==""){
		 			alert("不符合条款号不能为空，请填写！");
		 			return true;
		 		}
		 
				if(close_content==""){
		 			alert("不符合项内容不能为空，请填写！");
		 			return true;
		 		}
				if(cause_analysis==""){
		 			alert("原因分析不能为空，请填写！");
		 			return true;
		 		}
				if(preventive_measures==""){
		 			alert("纠正预防措施不能为空，请填写！");
		 			return true;
		 		}
				if(completion_date==""){
		 			alert("整改完成日期不能为空，请填写！");
		 			return true;
		 		}
				if(rectification==""){
		 			alert("整改负责人不能为空，请填写！");
		 			return true;
		 		}
				if(rectification_results==""){
		 			alert("整改结果综述不能为空，请填写！");
		 			return true;
		 		}
		 		
		 		return false;
		 	}
		 	
			
			
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};		 
		var close_no = document.getElementsByName("close_no")[0].value;		 
		  if(close_no !=null && close_no !=''){		
				if(checkJudge()){
					return;
				}	 		
				var close_no = document.getElementsByName("close_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
				var validating_date = document.getElementsByName("validating_date")[0].value;		
				var validating = document.getElementsByName("validating")[0].value;			
				var nonumber = document.getElementsByName("nonumber")[0].value;		
				var close_content = document.getElementsByName("close_content")[0].value;
				var cause_analysis = document.getElementsByName("cause_analysis")[0].value;		
				var preventive_measures = document.getElementsByName("preventive_measures")[0].value;			
				var completion_date = document.getElementsByName("completion_date")[0].value;		
				var rectification = document.getElementsByName("rectification")[0].value;		
				var rectification_results = document.getElementsByName("rectification_results")[0].value;			
				var project_no = document.getElementsByName("project_no")[0].value;		
				var detilNo=document.getElementById("detilNo").value;
		       
		       if(detilNo!='' && detilNo!=null){
		   		if(validating =="1"){			
		   			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		   			var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_ORDER_DETAIL&JCDP_TABLE_ID='+detilNo+'&spare1=已关闭'
		   			+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		   		   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		 
		   		}else if(validating =="2"){
		   			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		   			var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_ORDER_DETAIL&JCDP_TABLE_ID='+detilNo+'&spare1=未关闭'
		   			+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		   		   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息	
		   		}
		      }
		       
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			 
				rowParam['close_content'] = encodeURI(encodeURI(close_content));
				rowParam['cause_analysis'] = encodeURI(encodeURI(cause_analysis));
				rowParam['preventive_measures'] = encodeURI(encodeURI(preventive_measures));
				rowParam['completion_date'] = encodeURI(encodeURI(completion_date));		 		
				rowParam['rectification'] = encodeURI(encodeURI(rectification));
				rowParam['rectification_results'] = encodeURI(encodeURI(rectification_results));
				rowParam['validating_date'] = encodeURI(encodeURI(validating_date));
				rowParam['validating'] = encodeURI(encodeURI(validating));
				rowParam['nonumber'] = encodeURI(encodeURI(nonumber));  
				rowParam['spare2'] = encodeURI(encodeURI(detilNo));  
				
				    rowParam['close_no'] = close_no;
					rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['create_date'] =create_date;
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_NOTCONFORM_CLOSE",rows);	
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

