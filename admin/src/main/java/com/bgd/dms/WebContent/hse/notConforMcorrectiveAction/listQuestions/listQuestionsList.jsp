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
 
<title>问题清单</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">检查日期</td>
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
			    <auth:ListButton functionId="" css="bb" event="onclick='toTj()'" title="图表"></auth:ListButton>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{questions_no}' value='{questions_no}'  onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{check_date}">检查日期</td>
			      <td class="bt_info_even" exp="{rectification_period}">整改期限</td>

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
					      	<input type="hidden" id="questions_no" name="questions_no"  value=""  />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					      	
					   	      	
					    <td class="inquire_item6"><font color="red">*</font>检查人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_people" name="check_people" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>检查日期：</td>
					    <td class="inquire_form6"><input type="text" id="check_date" name="check_date" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);" />&nbsp;</td>
			 		    <td class="inquire_item6"><font color="red">*</font>被检查部门负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="check_person" name="check_person" class="input_width"   />    		
					    </td>
					  </tr>					  
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改期限：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="rectification_period" name="rectification_period" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_period,tributton2);" />&nbsp;</td>
					  </tr>	
					</table><fieldset>
					<legend>
					问题描述项：
					</legend>
					<div id="tab_box_contentT" class=""  > 
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="60" id="buttonDis1" >
		                  <span class='zj'><a href='#' onclick='addLine2()'  title='新增'></a></span>&nbsp;&nbsp;
		                  <span class="bc"  onclick="toUpdate3()"  title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
		              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo1">
			          	<tr > 		 
				            <td  class="bt_info_odd"><font color=red>问题描述</font></td>
				            <td class="bt_info_even"><font color=red>体系要素号</font></td>		
				            <td  class="bt_info_odd">问题类别</td>			            
				            <td class="bt_info_even">问题性质</td>	
			          		<input type="hidden" id="equipmentSize1" name="equipmentSize1"   value="0" />
			          		<input type="hidden" id="hidDetailId1" name="hidDetailId1" value=""/>
			          		<input type="hidden" id="deleteRowFlag1" name="deleteRowFlag1" value="" />	          
			          		<input type="hidden" id="lineNum1" value="0"/>
			          		<TD class="bt_info_odd" width="5%">操作</TD>
			          	</tr> 
					          
			          </table>	 
			      
				</div>			
			    </fieldset>
				
			    <fieldset>
				<legend>
				整改要求：
				</legend>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" > 
					  <tr>
									   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:100%;" id="rectification_requirements" name="rectification_requirements"   class="textarea" ></textarea></td>
					
			 
					  </tr>	
					 
					</table>
				  </fieldset>
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
		            <td  class="bt_info_odd">问题描述</td>
		            <td class="bt_info_even">体系要素号</td>		
		            <td  class="bt_info_odd">问题类别</td>			            
		            <td class="bt_info_even">问题性质</td>		
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
		cruConfig.queryStr = "  select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'  where tr.bsflag = '0'  "+querySqlAdd+" order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/listQuestions/listQuestionsList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/listQuestions/listQuestionsList.jsp";
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
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/selectCharts.jsp");
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
				cruConfig.queryStr = " select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0' where tr.bsflag = '0'  "+querySqlAdd+" and  to_char(tr.check_date,'yyyy-MM-dd')='"+changeDate+"' order by tr.modifi_date desc";
				cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/listQuestions/listQuestionsList.jsp";
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
//		
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;					
			querySql = "  select  tr.project_no, tr.questions_no, tr.org_sub_id,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'   where tr.bsflag = '0' and tr.questions_no='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 			   
		             document.getElementsByName("questions_no")[0].value=datas[0].questions_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;		  
		    		 	    		 
		    		document.getElementsByName("check_people")[0].value=datas[0].check_people;	
		    		document.getElementsByName("check_date")[0].value=datas[0].check_date;		
		    		document.getElementsByName("check_person")[0].value=datas[0].check_person;					
		    		document.getElementsByName("rectification_requirements")[0].value=datas[0].rectification_requirements;		
		            document.getElementsByName("rectification_period")[0].value=datas[0].rectification_period;					
		      	    document.getElementsByName("project_no")[0].value=datas[0].project_no;		  
				    	  
		    
				}					
			
		    	}		
			
			
			
			var querySql1="";
			var queryRet1=null;
			var datas1 =null;
			 deleteTableTr("hseTableInfo3"); 
				   querySql1 = "  select tr.qdetail_no,  case when length(tr.problem_des)<=15 then tr.problem_des else concat(substr(tr.problem_des,0,15),'...') end problem_des,    tr.questions_no, dl.coding_name ,     tr.problem_category,  tr.system_elements,   tr.nature,    tr.creator,  tr.create_date,  tr.bsflag    from BGP_LIST_QUESTIONS_DETAIL tr  left join comm_coding_sort_detail dl on tr.system_elements=dl.coding_code_id  where tr.bsflag = '0'   and tr.questions_no = '"+shuaId+"' ";
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
								td2.innerHTML = '<input type="radio" name="chx_entity_ids" value="'+datas1[i].qdetail_no+','+datas1[i].questions_no+'" >';
								
								var td2 = tr2.insertCell(1);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].problem_des;
								
					         	var td2 = tr2.insertCell(2);
								td2.className=classCss+"odd";
								td2.innerHTML =datas1[i].coding_name;
								
								var td2 = tr2.insertCell(3);
								td2.className=classCss+"even";
								td2.innerHTML =datas1[i].problem_category;						
																
					         	var td2 = tr2.insertCell(4);
								td2.className=classCss+"odd";
								td2.innerHTML =datas1[i].nature; 
							 
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
									var qdetail_no = ids.split(',')[0]; 
									var questions_no = ids.split(',')[1]; 
									popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/addQuestionDetail.jsp?questions_no="+questions_no+"&qdetail_no="+qdetail_no);
									
								}
					       				      
							}
							
						}
				    }	
			 
		 
					
					 deleteTableTr("hseTableInfo1");
					   document.getElementById("lineNum1").value="0"; 
							   querySql1 = "select qdetail_no,questions_no,problem_des,problem_category,system_elements,nature,creator,create_date,updator,modifi_date,bsflag   from BGP_LIST_QUESTIONS_DETAIL  where  bsflag='0' and questions_no='" + shuaId + "'  order by  modifi_date";
							   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
								if(queryRet1.returnCode=='0'){
								  datas1 = queryRet1.datas;	 
									if(datas1 != null && datas1 != ''){	  
										for(var i = 0; i<datas1.length; i++){										 
								       addLine2(datas1[i].qdetail_no,datas1[i].questions_no,datas1[i].problem_des,datas1[i].system_elements,datas1[i].problem_category,datas1[i].nature,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
								    		      
										}
										
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
	
	var problem_categoryP="";
	var natureP="";
	var system_elementsP="";
	function addLine2(qdetail_nos,questions_nos,problem_dess,system_elementss,problem_categorys,natures,creators,create_dates,updators,modifi_dates,bsflags){
		
		var qdetail_no = "";
		var questions_no = "";
		var problem_des = ""; 
		var system_elements = "";
		var problem_category = ""; 
		var nature = "";
	 
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";
		
		if(qdetail_nos != null && qdetail_nos != ""){
			qdetail_no=qdetail_nos;
		}
		if(questions_nos != null && questions_nos != ""){
			questions_no=questions_nos;
		}
		if(problem_dess != null && problem_dess != ""){
			problem_des=problem_dess;
		}
		
		if(system_elementss != null && system_elementss != ""){
			system_elements=system_elementss;
		}
		if(problem_categorys != null && problem_categorys != ""){
			problem_category=problem_categorys;
		}
		if(natures != null && natures != ""){
			nature=natures;
		}
		 
		if(creators != null && creators != ""){
			creator=creators;
		}
		
		if(create_dates != null && create_dates != ""){
			create_date=create_dates;
		}
		if(updators != null && updators != ""){
			updator=updators;
		}
		if(modifi_dates != null && modifi_dates != ""){
			modifi_date=modifi_dates;
		}
		if(bsflags != null && bsflags != ""){
			bsflag=bsflags;
		}
		
		var rowNum = document.getElementById("lineNum1").value;	
		var tr = document.getElementById("hseTableInfo1").insertRow();
		
		tr.align="center";		
 
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
 
		tr.id = "row_" + rowNum + "_";  
		tr.insertCell().innerHTML = '<input type="hidden"  name="qdetail_no' + '_' + rowNum + '" value="'+qdetail_no+'"/>'+ '<textarea name="problem_des' + '_' + rowNum + '"  id="problem_des' + '_' + rowNum + '"    style="height:34px; width:440px;" class="textarea" >'+problem_des+'</textarea> '+'<input type="hidden"  name="questions_no' + '_' + rowNum + '" value="'+questions_no+'"/>'+	'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+	'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+	'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		
		
		if(system_elements == ""){  
			 tr.insertCell().innerHTML='<select  style="width:100px;"    name="system_elements' + '_' + rowNum + '" id="system_elements' + '_' + rowNum + '"   >'+
			 '<option value="">请选择</option><option value="5110000047000000001" >5.1</option><option value="5110000047000000002">5.2</option><option value="5110000047000000003">5.3.1</option><option value="5110000047000000004">5.3.2</option><option value="5110000047000000005">5.3.3</option>'+
			 '<option value="5110000047000000006">5.3.4</option><option value="5110000047000000007" >5.4.1</option><option value="5110000047000000008">5.4.2</option><option value="5110000047000000009">5.4.3</option><option value="5110000047000000010">5.4.4</option><option value="5110000047000000011">5.4.5</option>'+
			 '<option value="5110000047000000012">5.4.6</option><option value="5110000047000000013" >5.4.7</option><option value="5110000047000000014">5.5.1</option><option value="5110000047000000015">5.5.2</option><option value="5110000047000000016">5.5.3</option><option value="5110000047000000017">5.5.4</option>'+
			 '<option value="5110000047000000018">5.5.5</option><option value="5110000047000000019" >5.5.6</option><option value="5110000047000000020">5.5.7</option><option value="5110000047000000021">5.5.8</option><option value="5110000047000000022">5.6.1</option><option value="5110000047000000023">5.6.2</option>'+
			 '<option value="5110000047000000024">5.6.3</option><option value="5110000047000000025" >5.6.4</option><option value="5110000047000000026">5.6.5</option><option value="5110000047000000027">5.6.6</option><option value="5110000047000000028">5.7</option></select>';
		 
		}else{
			getElementsList(system_elements);
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="system_elements' + '_' + rowNum + '" id="system_elements' + '_' + rowNum + '"  > '+system_elementsP+'</select>';
		}
		
		if(problem_category == ""){
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="problem_category' + '_' + rowNum + '" id="problem_category' + '_' + rowNum + '"  ><option value="">请选择</option><option value="违章指挥" >违章指挥</option><option value="违章操作">违章操作</option><option value="违反劳动纪律">违反劳动纪律</option><option value="监护失误">监护失误</option><option value="管理缺陷">管理缺陷</option></select>';
		}else{
			problemCategory(problem_category);
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="problem_category' + '_' + rowNum + '" id="problem_category' + '_' + rowNum + '"  > '+problem_categoryP+'</select>';
		}
		if(nature == ""){
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="nature' + '_' + rowNum + '" id="nature' + '_' + rowNum + '"  ><option value="">请选择</option><option value="特大" >特大</option><option value="重大">重大</option><option value="较大">较大</option><option value="一般">一般</option></select>';
		}else{
			natureF(nature);
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="nature' + '_' + rowNum + '" id="nature' + '_' + rowNum + '"  > '+natureP+'</select>';
		}
		
  
		var td = tr.insertCell();
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order1" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum1").value = parseInt(rowNum) + 1;	
	 
	}
	
	function getElementsList(selectValue){
		system_elementsP = '<option value="">请选择</option>';
		  var allTeamList=jcdpCallService("HseOperationSrv","queryElements","");	
	 	if(allTeamList != null){
		for(var m = 0; m < allTeamList.detailInfo.length; m++){
			var templateMap = allTeamList.detailInfo[m];
			if(templateMap.value==selectValue){
				system_elementsP+='<option value='+templateMap.value+' selected="selected" >'+templateMap.label+'</option>';	
			} 
			system_elementsP+='<option value='+templateMap.value+'>'+templateMap.label+'</option>';	
		}	
    	}
		
	}

 
 
	function problemCategory(selectValue){
		problem_categoryP='<option value="">请选择</option>'; 
			if(selectValue=='违章指挥'){
				problem_categoryP+='<option value="违章指挥" selected="selected" >违章指挥</option>';	
				problem_categoryP+='<option value="违章操作" >违章操作</option>';
				problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
				problem_categoryP+='<option value="监护失误" >监护失误</option>';
				problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>'; 
			}else if(selectValue=='违章操作'){
				problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
				problem_categoryP+='<option value="违章操作" selected="selected" >违章操作</option>';
				problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
				problem_categoryP+='<option value="监护失误" >监护失误</option>';
				problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>';
				
			}else if(selectValue=='违反劳动纪律'){
				problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
				problem_categoryP+='<option value="违章操作" selected="selected" >违章操作</option>';
				problem_categoryP+='<option value="违反劳动纪律"  selected="selected"  >违反劳动纪律</option>';
				problem_categoryP+='<option value="监护失误" >监护失误</option>';
				problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>';
			}else if(selectValue=='监护失误'){
				problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
				problem_categoryP+='<option value="违章操作" selected="selected" >违章操作</option>';
				problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
				problem_categoryP+='<option value="监护失误"  selected="selected"  >监护失误</option>';
				problem_categoryP+='<option value="管理缺陷" >管理缺陷</option>';
			}else if(selectValue=='管理缺陷'){
				problem_categoryP+='<option value="违章指挥"  >违章指挥</option>';	
				problem_categoryP+='<option value="违章操作" >违章操作</option>';
				problem_categoryP+='<option value="违反劳动纪律" >违反劳动纪律</option>';
				problem_categoryP+='<option value="监护失误" >监护失误</option>';
				problem_categoryP+='<option value="管理缺陷"  selected="selected"  >管理缺陷</option>';
			}
		
	}
	
	
	function natureF(selectValue){
		natureP='<option value="">请选择</option>';
		if(selectValue=='特大'){
			natureP+='<option value="特大" selected="selected" >特大</option>';	
			natureP+='<option value="重大" >重大</option>';
			natureP+='<option value="较大" >较大</option>';
			natureP+='<option value="一般" >一般</option>';
		}else if(selectValue=='重大'){
			natureP+='<option value="特大"  >特大</option>';	
			natureP+='<option value="重大" selected="selected" >重大</option>';
			natureP+='<option value="较大" >较大</option>';
			natureP+='<option value="一般" >一般</option>';
		}else if(selectValue=='较大'){
			natureP+='<option value="特大" >特大</option>';	
			natureP+='<option value="重大" >重大</option>';
			natureP+='<option value="较大"  selected="selected" >较大</option>';
			natureP+='<option value="一般" >一般</option>';
		}else if(selectValue=='一般'){
			natureP+='<option value="特大" >特大</option>';	
			natureP+='<option value="重大" >重大</option>';
			natureP+='<option value="较大" >较大</option>';
			natureP+='<option value="一般" selected="selected" >一般</option>';
		}
		
		
	}
	
	function toUpdate3(){	
		var rowNum = document.getElementById("lineNum1").value;			
		var rowParams = new Array();
		var questions_nos = document.getElementsByName("questions_no")[0].value;		
		 if(questions_nos !=null && questions_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};		  
			var qdetail_no =document.getElementsByName("qdetail_no_"+i)[0].value; 
			var questions_no =document.getElementsByName("questions_no_"+i)[0].value;
			
			var problem_des = document.getElementsByName("problem_des_"+i)[0].value;
			var system_elements = document.getElementsByName("system_elements_"+i)[0].value;
			var problem_category =document.getElementsByName("problem_category_"+i)[0].value;
			var nature = document.getElementsByName("nature_"+i)[0].value; 
			
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
			if(qdetail_no !=null && qdetail_no !=''){ 
				rowParam['problem_des'] =encodeURI(encodeURI(problem_des)); 	
				rowParam['system_elements'] = encodeURI(encodeURI(system_elements));
				rowParam['problem_category'] = encodeURI(encodeURI(problem_category)); 
				rowParam['nature'] =encodeURI(encodeURI(nature)); 				
			    rowParam['questions_no'] = questions_no; 
			    rowParam['qdetail_no'] = qdetail_no;		    
			    
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['problem_des'] =encodeURI(encodeURI(problem_des)); 	
				rowParam['system_elements'] = encodeURI(encodeURI(system_elements));
				rowParam['problem_category'] = encodeURI(encodeURI(problem_category)); 
				rowParam['nature'] =encodeURI(encodeURI(nature)); 
				
			    rowParam['questions_no'] = questions_nos;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 

		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_LIST_QUESTIONS_DETAIL",rows);	
			top.frames('list').loadDataDetail(questions_nos);
	 
	  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
	  }				
		
	}

	
	
	
	function toAddDetail(){
		   var ids=document.getElementsByName("questions_no")[0].value;
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    } 
			popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/addQuestionDetail.jsp?questions_no="+ids);
			
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
				var qdetail_no = ids.split(',')[0]; 
				var questions_no = ids.split(',')[1]; 
        		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
        		var submitStr='JCDP_TABLE_NAME=BGP_LIST_QUESTIONS_DETAIL&JCDP_TABLE_ID='+qdetail_no+'&bsflag=1';
        		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));
        		loadDataDetail(questions_no);	
        		alert('删除成功');
        		 
            }else{
                alert("请先选中一条子记录信息!");
            	
            }
        }


	}
	function toAdd(){
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/addQuestions.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/addQuestions.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&questions_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/addQuestions.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&questions_no="+ids);
	  	
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
		deleteEntities("update BGP_LIST_QUESTIONS e set e.bsflag='1' where e.questions_no  in ("+id+")");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/listQuestions/hse_search.jsp?isProject=<%=isProject%>");
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
				
				var check_people = document.getElementsByName("check_people")[0].value;
				var check_date = document.getElementsByName("check_date")[0].value;		
				var check_person = document.getElementsByName("check_person")[0].value;			
				var rectification_requirements = document.getElementsByName("rectification_requirements")[0].value;		
				var rectification_period = document.getElementsByName("rectification_period")[0].value;	
				
				
		 		if(org_sub_id==""){
		 			document.getElementById("org_sub_id").value = "";
		 		}
		 		if(second_org==""){
		 			document.getElementById("second_org").value="";
		 		}
		 		if(third_org==""){
		 			document.getElementById("third_org").value="";
		 		}
		 		if(check_people==""){
		 			alert("检查人不能为空，请填写！");
		 			return true;
		 		}
		 		if(check_date==""){
		 			alert("检查日期不能为空，请选择！");
		 			return true;
		 		}
		 		if(check_person==""){
		 			alert("被检查部门负责人不能为空，请填写！");
		 			return true;
		 		}

				if(rectification_requirements==""){
		 			alert("整改要求不能为空，请填写！");
		 			return true;
		 		}
				if(rectification_period==""){
		 			alert("整改期限不能为空，请填写！");
		 			return true;
		 		}
		  
		 		return false;
		 	}
	 
			
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var questions_no = document.getElementsByName("questions_no")[0].value;						 
		  if(questions_no !=null && questions_no !=''){		
				if(checkJudge()){
					return;
				} 	 
				var questions_no = document.getElementsByName("questions_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;		
				var check_people = document.getElementsByName("check_people")[0].value;
				var check_date = document.getElementsByName("check_date")[0].value;		
				var check_person = document.getElementsByName("check_person")[0].value;				
				var rectification_requirements = document.getElementsByName("rectification_requirements")[0].value;		
				var rectification_period = document.getElementsByName("rectification_period")[0].value;			
				var project_no = document.getElementsByName("project_no")[0].value;						 
				
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			 
				rowParam['check_people'] = encodeURI(encodeURI(check_people));
				rowParam['check_date'] = encodeURI(encodeURI(check_date));
				rowParam['check_person'] = encodeURI(encodeURI(check_person));	 		
				rowParam['rectification_requirements'] = encodeURI(encodeURI(rectification_requirements));
				rowParam['rectification_period'] = encodeURI(encodeURI(rectification_period));
 
			    rowParam['questions_no'] = questions_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_LIST_QUESTIONS",rows);	
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

