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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
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
 
<title>项目三同时</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="projectNames" name="projectNames" type="text" /></td>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{project_three_id}' value='{project_three_id}'  onclick=doCheck(this)  />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{plan_date}">计划开工时间</td>
			      <td class="bt_info_odd" exp="{hse_conclusion}">HSE审验结论</td>
 
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">特种设备</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">特种作业人员</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">HSE审验</a></li>
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
					  <td class="inquire_item6"> 基层单位：</td>
			    	  <td class="inquire_form6">
			    	  <input type="hidden" id="second_org" name="second_org" class="input_width" />
			    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			        	<%} %>
			        	</td>
			    	  
			    	  <td class="inquire_item6"> 下属单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
				      	<input type="hidden" id="org_sub_id2" name="org_sub_id2" class="input_width" />
				    	<input type="hidden" id="project_no" name="project_no" value="" />
				      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="project_three_id" name="project_three_id" value="" />
				      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td> 
				      	
				      	 <td class="inquire_item6"><font color="red">*</font>计划开工时间：</td>
						    <td class="inquire_form6"><input type="text" id="plan_date" name="plan_date" class="input_width"   readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_date,tributton1);" />&nbsp;</td>
				  </tr>					  
					<tr>
				 
			        <td class="inquire_item6"><font color="red">*</font>项目名称：</td>					 
				    <td class="inquire_form6"><input type="hidden" id="project_id" name="projcet_id" class="input_width" />
				    <input type="text" id="project_name" name="project_name" class="input_width"   />
				  	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam1()"/>
				    </td>	
					   <td class="inquire_item6"><font color="red">*</font>负责人：</td>
					    <td class="inquire_form6"><input type="text" id="principal" name="principal"    class="input_width"/></td>
					    
				    <td class="inquire_item6"><font color="red">*</font>申报HSE审验级别：</td>
				    <td class="inquire_form6">
				    <select id="hse_level" name="hse_level" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >公司</option>
				       <option value="2" >单位</option>
				       <option value="3" >基层单位</option>
					</select>
				    </td>
				    
					</tr>
					
				  
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>项目计划投入金额（万元）：</td>
				    <td class="inquire_form6">
				    <input type="text" id="project_plan_money" name="project_plan_money" class="input_width" />
				    </td>
				    <td class="inquire_item6"><font color="red">*</font>项目实施单位名称：</td>
				    <td class="inquire_form6">
				    <input type="text" id="implement_name" name="implement_name" class="input_width" />
					</td>
					  <td class="inquire_item6"><font color="red">*</font>项目实施单位经营范围：</td>
					    <td class="inquire_form6"><input type="text" id="business_scope" name="business_scope" class="input_width" /></td>					 
					  
				  </tr>					  
		 
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="80" id="buttonDis1" >
		                <span class='zj' ><a href='#' onclick='addLine1()'  title='新增'></a></span>	
		                <span class='dr' ><a href='#' onclick='toUploadFile()'  title='导入'></a></span>
		                <span class="bc"  onclick="toUpdate1()" title="保存"><a href="#"></a></span> 
		                  </td>
		                  <td width="5"></td>
		                </tr>
		              </table>
		              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo">
		          	<tr > 		    
		          		<TD  class="bt_info_odd" width="15%" ><font color=red>名称</font></TD>
		          		<TD  class="bt_info_even" width="15%" >型号</TD>
		          		<TD  class="bt_info_odd"  width="10%"><font color=red>数量</font></TD>
		          		<TD class="bt_info_even"  width="15%"><font color=red>审验情况</font></TD>
		          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
		          		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
		          		<input type="hidden" id="lineNum" value="0"/>
		          		<TD class="bt_info_odd" width="5%">操作</TD>
		          	</tr>
		          		 
		          </table>	 

		              
				</div>
				
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="80" id="buttonDis1" >
	                  <span class='zj'><a href='#' onclick='addLine2()'  title='新增'></a></span>
	                  <span class='dr'><a href='#' onclick='toUploadFile2()'  title='导入'></a></span>
	                  <span class="bc"  onclick="toUpdate3()"  title="保存"><a href="#"></a></span>
	                  </td>
	                  <td width="5"></td>
	                </tr>
	              </table>
	              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo1">
		          	<tr > 		 
		          	    <TD  class="bt_info_even"  width="10%"><font color=red>姓名</font></TD>
		          		<TD  class="bt_info_odd" width="10%" ><font color=red>性别</font></TD>
		          		<TD  class="bt_info_even" width="10%" ><font color=red>身份证号码</font></TD>
		          		<TD  class="bt_info_odd"  width="10%"><font color=red>年龄</font></TD>
		          		<TD class="bt_info_even"  width="15%"><font color=red>从事工种</font></TD>
		        		<TD class="bt_info_odd"  width="15%"><font color=red>特种作业证件名称</font></TD>
		           		<TD class="bt_info_even"  width="15%"><font color=red>证件有效期至</font></TD>
		          		<input type="hidden" id="equipmentSize1" name="equipmentSize1"   value="0" />
		          		<input type="hidden" id="hidDetailId1" name="hidDetailId1" value=""/>
		          		<input type="hidden" id="deleteRowFlag1" name="deleteRowFlag1" value="" />	          
		          		<input type="hidden" id="lineNum1" value="0"/>
		          		<TD class="bt_info_odd" width="5%">操作</TD>
		          	</tr>
		          		 
		          </table>	 
			</div>			
			
				
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis3" >		     
		                  <span class="bc"  onclick="toUpdate4()"  title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo2">			
						 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>HSE审验结论</td>
					    <td class="inquire_form6" >
					    
				      	<input type="hidden" id="pthree_approval_no" name="pthree_approval_no" value="" />
				      	<input type="hidden" id="project_three_id3" name="project_three_id3"   value="" />
					    <select id="hse_conclusion" name="hse_conclusion" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >通过</option>
					       <option value="2" >未通过</option>
						</select>					    
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>审验负责人：</td>
					    <td class="inquire_form6"  >
					    <input type="text" id="hse_person" name="hse_person" class="input_width"  value="自动获取用户" readonly="readonly"/></td>
					    <td class="inquire_item6"><font color="red">*</font>审验时间：</td>
					    <td class="inquire_form6"  >
					    <input type="text" id="hse_date" name="hse_date" class="input_width"  value="自动获取时间" readonly="readonly"/></td>					    
					  </tr>					
 
					  <tr>
					    <td class="inquire_item6"> HSE审验内容</td>
					    <td class="inquire_form6" colspan="5"><textarea id="hse_content" name="hse_content"   class="textarea" ></textarea></td>
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
		cruConfig.queryStr = "select p.project_name,tr.project_three_id,tr.plan_date,tr.principal,tr.project_plan_money,tr.implement_name,tr.business_scope,tr.hse_level,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name,  oi2.org_abbreviation as third_org_name,decode(hse_conclusion, '1',  '通过',  '2',  '未通过') hse_conclusion  from   BGP_HSE_PROJCT_THREE  tr  left join  BGP_HSE_PROJCT_APPROVAL  al  on tr.PROJECT_THREE_ID=al.PROJECT_THREE_ID  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id=os3.org_id  and oi3.bsflag='0' left join gp_task_project p on p.project_info_no=tr.PROJCET_ID and p.bsflag='0' where tr.bsflag='0' "+querySqlAdd+" order by tr.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/constructionProjectThree/projectThreeList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl ="/hse/constructionProjectThree/projectThreeList.jsp";
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
			var projectNames = document.getElementById("projectNames").value;
			var isProject = "<%=isProject%>";
			var querySqlAdd = "";
			if(isProject=="1"){
				querySqlAdd = getMultipleSql2("tr.");
			}else if(isProject=="2"){
				querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
			}
			
			if(projectNames!=''&&projectNames!=null){
				cruConfig.cdtType = 'form';
				cruConfig.queryStr = "select p.project_name,tr.project_three_id,tr.plan_date,tr.principal,tr.project_plan_money,tr.implement_name,tr.business_scope,tr.hse_level,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name,  oi2.org_abbreviation as third_org_name,decode(hse_conclusion, '1',  '通过',  '2',  '未通过') hse_conclusion  from   BGP_HSE_PROJCT_THREE  tr  left join  BGP_HSE_PROJCT_APPROVAL  al  on tr.PROJECT_THREE_ID=al.PROJECT_THREE_ID  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id=os3.org_id  and oi3.bsflag='0' left join gp_task_project p on p.project_info_no=tr.PROJCET_ID and p.bsflag='0' where tr.bsflag='0' "+querySqlAdd+"  and p.project_name like'%"+projectNames+"%' order by tr.modifi_date desc ";
				cruConfig.currentPageUrl = "/hse/constructionProjectThree/projectThreeList.jsp";
				queryData(1);
			}else{
				refreshData();
			}
	}
	
	function clearQueryText(){
		document.getElementById("projectNames").value = "";
	}

	function loadDataDetail(shuaId){ 
 
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;		
			
			querySql = " select  al.hse_conclusion, tr.project_no,tr.creator,tr.create_date,tr.implement_name,tr.business_scope,tr.hse_level,tr.project_three_id,tr.org_sub_id,tr.bsflag,tr.second_org,tr.third_org, tr.projcet_id,tr.plan_date,principal,tr.project_plan_money,p.project_name,oi3.org_name,oi1.org_abbreviation as second_org_name,  oi2.org_abbreviation as third_org_name,decode(al.hse_conclusion, '1',  '通过',  '2',  '未通过') hse_conclusionName   from   BGP_HSE_PROJCT_THREE  tr  left join  BGP_HSE_PROJCT_APPROVAL  al  on tr.PROJECT_THREE_ID=al.PROJECT_THREE_ID  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id=os3.org_id  and oi3.bsflag='0' left join gp_task_project p on p.project_info_no=tr.PROJCET_ID and p.bsflag='0'   where   tr.bsflag='0' and tr.project_three_id='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){			 			   
		              document.getElementsByName("project_three_id")[0].value=datas[0].project_three_id; 
		    		  document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		      		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		  document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		  document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		  document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	      document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	      document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		    		  document.getElementsByName("project_id")[0].value=datas[0].projcet_id;
		     		  document.getElementsByName("project_name")[0].value=datas[0].project_name;
		    		  document.getElementsByName("plan_date")[0].value=datas[0].plan_date;		
		    		  document.getElementsByName("principal")[0].value=datas[0].principal;			
		    		  document.getElementsByName("project_plan_money")[0].value=datas[0].project_plan_money;			
		    		  document.getElementsByName("implement_name")[0].value=datas[0].implement_name;
		    	      document.getElementsByName("business_scope")[0].value=datas[0].business_scope;
		    		  document.getElementsByName("hse_level")[0].value=datas[0].hse_level;	    		 
		    		  document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		  document.getElementsByName("creator")[0].value=datas[0].creator;
		    		  document.getElementsByName("project_no")[0].value=datas[0].project_no;	
				}					
			
		    	}		
			var querySql1="";
			var queryRet1=null;
			var datas1 =null;
			 deleteTableTr("hseTableInfo");
			 document.getElementById("lineNum").value="0";	
				   querySql1 = " select dl.pthree_detail_no,dl.project_three_id,dl.detail_name,dl.detail_model,dl.detail_quantity,dl.approval_conditions,dl.creator,dl.create_date,dl.updator,dl.modifi_date,dl.bsflag  from BGP_HSE_PROJCT_DETAIL dl  where dl.bsflag='0' and dl.project_three_id='" + shuaId + "'  order by  dl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
	
						if(datas1 != null && datas1 != ''){							 
						  						 
							for(var i = 0; i<datas1.length; i++){	 	
					       addLine1(datas1[i].pthree_detail_no,datas1[i].project_three_id,datas1[i].detail_name,datas1[i].detail_model,datas1[i].detail_quantity,datas1[i].approval_conditions,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
							}
							
						}
				    }	

			   deleteTableTr("hseTableInfo1");
			   document.getElementById("lineNum1").value="0";
					   querySql1 = "select pthree_human_no,project_three_id,special_name,special_sex,special_code,special_age,work_type,certificate_name,certificate_date,creator,create_date,updator,modifi_date,bsflag   from BGP_HSE_PROJCT_HUMAN where  bsflag='0' and project_three_id='" + shuaId + "'  order by  modifi_date";
					   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
						if(queryRet1.returnCode=='0'){
						  datas1 = queryRet1.datas;	
						
							if(datas1 != null && datas1 != ''){		
							 
								for(var i = 0; i<datas1.length; i++){										 
						       addLine2(datas1[i].pthree_human_no,datas1[i].project_three_id,datas1[i].special_name,datas1[i].special_sex,datas1[i].special_code,datas1[i].special_age,datas1[i].work_type,datas1[i].certificate_name,datas1[i].certificate_date,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
						       				      
								}
								
							}
					    }	
 						
				   querySql = "   select  al.pthree_approval_no,al.project_three_id,al.hse_content,al.hse_conclusion,al.hse_person,al.hse_date,al.create_date,al.creator  from   BGP_HSE_PROJCT_APPROVAL al  where al.PROJECT_THREE_ID='" + shuaId + "'";
		 		   queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
					if(queryRet.returnCode=='0'){
						datas = queryRet.datas;				 
						if(datas.length >0){
							 document.getElementsByName("project_three_id3")[0].value=datas[0].project_three_id; 
				    		 document.getElementsByName("pthree_approval_no")[0].value=datas[0].pthree_approval_no;
				    		 document.getElementsByName("hse_content")[0].value=datas[0].hse_content;
				    		 document.getElementsByName("hse_conclusion")[0].value=datas[0].hse_conclusion;			
				    		 document.getElementsByName("hse_person")[0].value=datas[0].hse_person;		
				    	     document.getElementsByName("hse_date")[0].value=datas[0].hse_date;		
							
						}else{		
					 
						 document.getElementsByName("project_three_id3")[0].value=""; 
			    		 document.getElementsByName("pthree_approval_no")[0].value="";
			    		 document.getElementsByName("hse_content")[0].value="";
			    		 document.getElementsByName("hse_conclusion")[0].value="";			
			    		 document.getElementsByName("hse_person")[0].value="自动获取用户";		
			    	     document.getElementsByName("hse_date")[0].value="自动获取时间";		
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
		popWindow("<%=contextPath%>/hse/constructionProjectThree/addprojectThree.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
		popWindow("<%=contextPath%>/hse/constructionProjectThree/addprojectThree.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&project_three_id="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/constructionProjectThree/addprojectThree.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&project_three_id="+ids);
	  	
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
				deleteEntities("update BGP_HSE_PROJCT_THREE e set e.bsflag='1' where e.project_three_id  in("+id+")");
			 
		 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/constructionProjectThree/hse_search.jsp?isProject=<%=isProject%>");
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
				
				var project_name = document.getElementsByName("project_name")[0].value;
				var plan_date = document.getElementsByName("plan_date")[0].value;		
				var principal = document.getElementsByName("principal")[0].value;			
				var project_plan_money = document.getElementsByName("project_plan_money")[0].value;			
				var implement_name = document.getElementsByName("implement_name")[0].value;
				var business_scope = document.getElementsByName("business_scope")[0].value;
				var hse_level = document.getElementsByName("hse_level")[0].value;
				
				
		 		if(org_sub_id==""){
		 			document.getElementById("org_sub_id").value = "";
		 		}
		 		if(second_org==""){
		 			document.getElementById("second_org").value="";
		 		}
		 		if(third_org==""){
		 			document.getElementById("third_org").value="";
		 		}
		 		if(project_name==""){
		 			alert("项目名称不能为空，请填写！");
		 			return true;
		 		}
		 		if(plan_date==""){
		 			alert("计划开工时间不能为空，请选择！");
		 			return true;
		 		}
		 		if(principal==""){
		 			alert("负责人不能为空，请填写！");
		 			return true;
		 		}
		 
				if(project_plan_money==""){
		 			alert("项目 计划投入金额不能为空，请填写！");
		 			return true;
		 		}
				if(implement_name==""){
		 			alert("项目实施单位名称不能为空，请填写！");
		 			return true;
		 		}
				if(business_scope==""){
		 			alert("项目实施单位经营范围不能为空，请填写！");
		 			return true;
		 		}
				if(hse_level==""){
		 			alert("申报HSE审验级别不能为空，请填写！");
		 			return true;
		 		}
				
		 		
		 		return false;
		 	}
		 	
		 	
			
	function toUpdate(){ 
		var rowParams = new Array(); 
		var rowParam = {};				
		var project_three_id = document.getElementsByName("project_three_id")[0].value;						 
		  if(project_three_id !=null && project_three_id !=''){
				if(checkJudge()){
					return;
				}
				
			  var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;
				
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
				var project_id = document.getElementsByName("project_id")[0].value;
				var plan_date = document.getElementsByName("plan_date")[0].value;		
				var principal = document.getElementsByName("principal")[0].value;			
				var project_plan_money = document.getElementsByName("project_plan_money")[0].value;			
				var implement_name = document.getElementsByName("implement_name")[0].value;
				var business_scope = document.getElementsByName("business_scope")[0].value;
				var hse_level = document.getElementsByName("hse_level")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;						 
	 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;
				rowParam['projcet_id'] = project_id;
				rowParam['plan_date'] = plan_date;
				rowParam['principal'] = encodeURI(encodeURI(principal));
				rowParam['project_plan_money'] = project_plan_money;
				rowParam['implement_name'] = encodeURI(encodeURI(implement_name));
				rowParam['business_scope'] = encodeURI(encodeURI(business_scope));
				rowParam['hse_level'] =hse_level; 		
			
			    rowParam['project_three_id'] = project_three_id;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
		  
				rowParams[rowParams.length] = rowParam; 

				var rows=JSON.stringify(rowParams);
			 
				saveFunc("BGP_HSE_PROJCT_THREE",rows);	
			    refreshData();
				  
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
function toUpdate1(){	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();
		var project_three_ids = document.getElementsByName("project_three_id")[0].value;	
					
		 if(project_three_ids !=null && project_three_ids !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			
			var pthree_detail_no =document.getElementsByName("pthree_detail_no_"+i)[0].value; 
			var project_three_id =document.getElementsByName("project_three_id_"+i)[0].value;
			var detail_name = document.getElementsByName("detail_name_"+i)[0].value;
			var detail_model = document.getElementsByName("detail_model_"+i)[0].value;
			var detail_quantity =document.getElementsByName("detail_quantity_"+i)[0].value;
			var approval_conditions = document.getElementsByName("approval_conditions_"+i)[0].value;	
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
			if(pthree_detail_no !=null && pthree_detail_no !=''){			
 				rowParam['detail_name'] = encodeURI(encodeURI(detail_name));
				rowParam['detail_model'] = encodeURI(encodeURI(detail_model));
				rowParam['detail_quantity'] = detail_quantity;
				rowParam['approval_conditions'] =approval_conditions; 				
			    rowParam['project_three_id'] = project_three_id;
			    rowParam['pthree_detail_no'] = pthree_detail_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['detail_name'] = encodeURI(encodeURI(detail_name));
				rowParam['detail_model'] = encodeURI(encodeURI(detail_model));
				rowParam['detail_quantity'] = detail_quantity;
				rowParam['approval_conditions'] =approval_conditions; 				
			    rowParam['project_three_id'] = project_three_ids;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_HSE_PROJCT_DETAIL",rows);	
		    refreshData();
  		
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}

function toUpdate3(){	
	var rowNum = document.getElementById("lineNum1").value;			
	var rowParams = new Array();
	var project_three_ids = document.getElementsByName("project_three_id")[0].value;		
	 if(project_three_ids !=null && project_three_ids !=''){
	for(var i=0;i<rowNum;i++){
		var rowParam = {};		
		var pthree_human_no =document.getElementsByName("pthree_human_no_"+i)[0].value; 
		var project_three_id =document.getElementsByName("project_three_id_"+i)[0].value;
		
		var special_name = document.getElementsByName("special_name_"+i)[0].value;
		var special_sex = document.getElementsByName("special_sex_"+i)[0].value;
		var special_code =document.getElementsByName("special_code_"+i)[0].value;
		var special_age = document.getElementsByName("special_age_"+i)[0].value;
		var work_type = document.getElementsByName("work_type_"+i)[0].value;
		var certificate_name =document.getElementsByName("certificate_name_"+i)[0].value;
		var certificate_date = document.getElementsByName("certificate_date_"+i)[0].value;
		
		var creator = document.getElementsByName("creator_"+i)[0].value;
		var create_date = document.getElementsByName("create_date_"+i)[0].value;
		var updator = document.getElementsByName("updator_"+i)[0].value;
		var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
		var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
		if(pthree_human_no !=null && pthree_human_no !=''){
			rowParam['special_name'] = encodeURI(encodeURI(special_name));
			rowParam['special_sex'] = encodeURI(encodeURI(special_sex));
			rowParam['special_code'] = encodeURI(encodeURI(special_code)); 
			rowParam['special_age'] =encodeURI(encodeURI(special_age)); 	
			rowParam['work_type'] = encodeURI(encodeURI(work_type));
			rowParam['certificate_name'] = encodeURI(encodeURI(certificate_name)); 
			rowParam['certificate_date'] =encodeURI(encodeURI(certificate_date)); 				
		    rowParam['project_three_id'] = project_three_id;
		    rowParam['pthree_human_no'] = pthree_human_no;		    
		    
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;	
			
		}else{
			rowParam['special_name'] = encodeURI(encodeURI(special_name));
			rowParam['special_sex'] = encodeURI(encodeURI(special_sex));
			rowParam['special_code'] = encodeURI(encodeURI(special_code)); 
			rowParam['special_age'] =encodeURI(encodeURI(special_age)); 	
			rowParam['work_type'] = encodeURI(encodeURI(work_type));
			rowParam['certificate_name'] = encodeURI(encodeURI(certificate_name)); 
			rowParam['certificate_date'] =encodeURI(encodeURI(certificate_date)); 		
			
		    rowParam['project_three_id'] = project_three_ids;
			rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';	
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;		 
		}
			rowParams[rowParams.length] = rowParam; 

	}
		var rows=JSON.stringify(rowParams);			 
		saveFunc("BGP_HSE_PROJCT_HUMAN",rows);	
	    refreshData();
 
  }else{			  
		  alert("请先选中一条记录!");
	     	return;		
  }				
	
}


function toUpdate4(){
	
	var rowParams = new Array(); 
	var rowParam = {};			

	var project_three_id = document.getElementsByName("project_three_id")[0].value;		
			 
	  if(project_three_id !=null && project_three_id !=''){
		  
			var project_three_id3 = document.getElementsByName("project_three_id3")[0].value;
			var pthree_approval_no = document.getElementsByName("pthree_approval_no")[0].value;
			var hse_content = document.getElementsByName("hse_content")[0].value;			
			var hse_conclusion = document.getElementsByName("hse_conclusion")[0].value;			
			var hse_person = document.getElementsByName("hse_person")[0].value;
			var hse_date = document.getElementsByName("hse_date")[0].value;		
			 
		 if(pthree_approval_no !=null && pthree_approval_no !=''){
			 
			    rowParam['hse_date'] = hse_date;
				rowParam['hse_content'] = encodeURI(encodeURI(hse_content));
				rowParam['hse_conclusion'] = hse_conclusion;
				rowParam['hse_person'] = encodeURI(encodeURI(hse_person));	 
				rowParam['pthree_approval_no'] =pthree_approval_no; 				
			    rowParam['project_three_id'] = project_three_id3;
			    rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] ='<%=curDate%>';
		 }else{
			    rowParam['hse_date'] = '<%=curDate%>';
				rowParam['hse_content'] = encodeURI(encodeURI(hse_content));
				rowParam['hse_conclusion'] = hse_conclusion;
				rowParam['hse_person'] = encodeURI(encodeURI('<%=userName%>'));	  				
			    rowParam['project_three_id'] = project_three_id;
			    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';
		 }		
					
			rowParam['bsflag'] = '0';		 
	  
			rowParams[rowParams.length] = rowParam; 
			var rows=JSON.stringify(rowParams);		 
			saveFunc("BGP_HSE_PROJCT_APPROVAL",rows);	
		    refreshData();
  
	  }else{			  
		  alert("请先选中一条记录!");
	     	return;		
	  }
	  
	
	
}
var num_str="";
	function addLine1(pthree_detail_nos,project_three_ids,detail_names,detail_models,detail_quantitys,approval_conditionss,creators,create_dates,updators,modifi_dates,bsflags){
		
		var pthree_detail_no = "";
		var project_three_id = "";
		var detail_name = "";
		var detail_model = "";
		var detail_quantity = "";
		var approval_conditions = "";	
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";
		
		
		if(pthree_detail_nos != null && pthree_detail_nos != ""){
			pthree_detail_no=pthree_detail_nos;
		}
		if(project_three_ids != null && project_three_ids != ""){
			project_three_id=project_three_ids;
		}
		if(detail_names != null && detail_names != ""){
			detail_name=detail_names;
		}
		
		if(detail_models != null && detail_models != ""){
			detail_model=detail_models;
		}
		if(detail_quantitys != null && detail_quantitys != ""){
			detail_quantity=detail_quantitys;
		}
		if(approval_conditionss != null && approval_conditionss != ""){
			approval_conditions=approval_conditionss;
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
		 
		var rowNum = document.getElementById("lineNum").value;	
		
		var tr = document.getElementById("hseTableInfo").insertRow();
		
		tr.align="center";		
 
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
		tr.id = "row_" + rowNum + "_";  
		tr.insertCell().innerHTML = '<input type="hidden"  name="pthree_detail_no' + '_' + rowNum + '" value="'+pthree_detail_no+'"/>'+'<input type="text" style="width:260px;" class="input_width" name="detail_name' + '_' + rowNum + '" value="'+detail_name+'" />'+'<input type="hidden"  name="project_three_id' + '_' + rowNum + '" value="'+project_three_id+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="text" style="width:260px;" class="input_width" name="detail_model' + '_' + rowNum + '" value="'+detail_model+'" />';
		tr.insertCell().innerHTML = '<input type="text" style="width:170px;" class="input_width" name="detail_quantity' + '_' + rowNum + '" value="'+detail_quantity+'" />';		
	 	if(approval_conditions == ""){
	 		tr.insertCell().innerHTML = '<select  style="width:250px;"  name="approval_conditions' + '_' + rowNum + '" id="approval_conditions' + '_' + rowNum + '"  ><option value="">请选择</option><option value="1" >是</option><option value="2">否</option></select>';
	 	}else{
	 		  getNum(approval_conditions);
	 			tr.insertCell().innerHTML = '<select  style="width:250px;"  name="approval_conditions' + '_' + rowNum + '" id="approval_conditions' + '_' + rowNum + '"  > '+num_str+'</select>';
	 	}
		var td = tr.insertCell(); 
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;			 
		
	}

	function getNum(selectValue){
		num_str='<option value="">请选择</option>';
		 
			//选择当前班组
			if(selectValue=='1'){
				num_str+='<option value="1" selected="selected" >是</option>';	
				num_str+='<option value="2" >否</option>';
			}else{
				num_str+='<option value="2" selected="selected"  >否</option>';
				num_str+='<option value="1"  >是</option>';	
			}
	 
	}
	
	var sex_str="";
	function addLine2(pthree_human_nos,project_three_ids,special_names,special_sexs,special_codes,special_ages,work_types,certificate_names,certificate_dates,creators,create_dates,updators,modifi_dates,bsflags){
		
		var pthree_human_no = "";
		var project_three_id = "";
		var special_name = "";
		var special_sex = "";
		var special_code = "";
		var special_age = "";
		var work_type = "";
		var certificate_name = "";
		var certificate_date = ""; 
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";
		
		if(pthree_human_nos != null && pthree_human_nos != ""){
			pthree_human_no=pthree_human_nos;
		}
		if(project_three_ids != null && project_three_ids != ""){
			project_three_id=project_three_ids;
		}
		if(special_names != null && special_names != ""){
			special_name=special_names;
		}
		
		if(special_sexs != null && special_sexs != ""){
			special_sex=special_sexs;
		}
		if(special_codes != null && special_codes != ""){
			special_code=special_codes;
		}
		if(special_ages != null && special_ages != ""){
			special_age=special_ages;
		}
		
		if(work_types != null && work_types != ""){
			work_type=work_types;
		}
		if(certificate_names != null && certificate_names != ""){
			certificate_name=certificate_names;
		}
		if(certificate_dates != null && certificate_dates != ""){
			certificate_date=certificate_dates;
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
		tr.insertCell().innerHTML = '<input type="hidden"  name="pthree_human_no' + '_' + rowNum + '" value="'+pthree_human_no+'"/>'+'<input type="text" class="input_width" name="special_name' + '_' + rowNum + '" value="'+special_name+'" />'+'<input type="hidden"  name="project_three_id' + '_' + rowNum + '" value="'+project_three_id+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';;
		if(special_sex == ""){
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="special_sex' + '_' + rowNum + '" id="special_sex' + '_' + rowNum + '"  ><option value="">请选择</option><option value="1" >男</option><option value="0">女</option></select>';
		}else{
			getSex(special_sex);
			tr.insertCell().innerHTML = '<select  style="width:100px;"  name="special_sex' + '_' + rowNum + '" id="special_sex' + '_' + rowNum + '"  > '+sex_str+'</select>';
		}
		tr.insertCell().innerHTML = '<input type="text" class="input_width" name="special_code' + '_' + rowNum + '" value="'+special_code+'" />';
		tr.insertCell().innerHTML = '<input type="text" class="input_width" name="special_age' + '_' + rowNum + '" value="'+special_age+'" />';		
		tr.insertCell().innerHTML = '<input type="text" class="input_width" name="work_type' + '_' + rowNum + '" value="'+work_type+'" />';
		tr.insertCell().innerHTML = '<input type="text" class="input_width" name="certificate_name' + '_' + rowNum + '" value="'+certificate_name+'" />';
		tr.insertCell().innerHTML = '<input type="text" class="input_width" name="certificate_date' + '_' + rowNum + '" value="'+certificate_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1' + rowNum + '" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(certificate_date_' + rowNum + ',tributton1' + rowNum + ');" />';
		
		var td = tr.insertCell();
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order1" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum1").value = parseInt(rowNum) + 1;			 		
	}
	function getSex(selectValue){
		 sex_str='<option value="">请选择</option>';
		 
			//选择当前班组
			if(selectValue=='1'){
				sex_str+='<option value="1" selected="selected" >男</option>';	
				sex_str+='<option value="0" >女</option>';
			}else{
				sex_str+='<option value="0" selected="selected"  >女</option>';
				sex_str+='<option value="1"  >男</option>';	
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

	 function toUploadFile(){
		 var project_three_ids = document.getElementsByName("project_three_id")[0].value;	
		 if(project_three_ids ==null || project_three_ids ==''){
			 alert("请先选中一条记录!");
		     return;		
		 }else{
			popWindow("<%=contextPath%>/hse/constructionProjectThree/importFile.jsp?project=<%=isProject%>&&project_three_ids="+project_three_ids);
		 }
	}
	 
	 function toUploadFile2(){
		 var project_three_ids = document.getElementsByName("project_three_id")[0].value;	
		 if(project_three_ids ==null || project_three_ids ==''){
			 alert("请先选中一条记录!");
		     return;		
		 }else{
			popWindow("<%=contextPath%>/hse/constructionProjectThree/importFile2.jsp?project=<%=isProject%>&&project_three_ids="+project_three_ids);
		 }
	}
</script>

</html>

