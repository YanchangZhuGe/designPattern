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
 
<title>运行控制（民爆物品管理）</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">是否建库</td>
			    <td class="ali_cdn_input">
			    <select id="ifBuild" name="ifBuild" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >是</option>
			       <option value="2" >否</option>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{explosives_no}' value='{explosives_no}'  onclick=doCheck(this)  />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{if_build}">是否建库</td> 
			      <td class="bt_info_even" exp="{if_library}">是否撤库</td> 
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工地运输设备信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">工作流程和指南</a></li>
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
							      	<input type="hidden" id="explosives_no" name="explosives_no"   />
							     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
							      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
							      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
							      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
							      	<%}%>
							      	</td>
						      	
		     			      	 <td class="inquire_item6"><font color="red">*</font>是否建库：</td>
								    <td class="inquire_form6">
								    <select id="if_build" name="if_build" class="select_width">
								       <option value="" >请选择</option>
								       <option value="1" >是</option>
								       <option value="2" >否</option>
									</select>
								    </td>
						  </tr>					  
							<tr>
							 <td class="inquire_item6"><font color="red">*</font>是否撤库：</td>
							    <td class="inquire_form6">
							    <select id="if_library" name="if_library" class="select_width">
							       <option value="" >请选择</option>
							       <option value="1" >是</option>
							       <option value="2" >否</option>
								</select>
							    </td>					
					 
						  <td class="inquire_item6"><font color="red">*</font>炸药最大库存量：</td>					 
						    <td class="inquire_form6"> 
						    <input type="text" id="inventory" name="inventory" class="input_width"  onblur="checkNaN('inventory')" />(kg)
	 					    </td>	
							</tr>
							
						  <tr>	 
						   <td class="inquire_item6"><font color="red">*</font>雷管最大库存量：</td>
						    <td class="inquire_form6"><input type="text" id="consumption" name="consumption" onblur="checkNaN('consumption')"   class="input_width"/>(发)</td>
						   <td class="inquire_item6"><font color="red">*</font>是否建立监控系统：</td>
						    <td class="inquire_form6">
						    <select id="spare1" name="spare1" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >是</option>
						       <option value="2" >否</option>
							</select> 
						    </td>
						  </tr>	 
						  
						  
						</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="60" id="buttonDis1" >
		                <span class='zj'><a href='#' onclick='addLine1()'  title='新增'></a></span>		 		                
		                <span class="bc"  onclick="toUpdate1()" title="保存"><a href="#"></a></span> 
		                  </td>
		                  <td width="5"></td>
		                </tr>
		              </table>
		              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo">
		          	<tr > 		    
		          	    <TD  class="bt_info_even"  width="20%"><font color=red>驾驶员姓名</font></TD>
		          		<TD  class="bt_info_odd" width="30%" ><font color=red>车辆牌照号</font></TD>
		          		<TD  class="bt_info_even" width="30%" ><font color=red>额定荷载</font></TD>
		          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
		          		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
		          		<input type="hidden" id="lineNum" value="0"/>
		          		<TD class="bt_info_odd" width="5%">操作</TD>
		          	</tr>
		          		 
		          </table>	 

		              
				</div>
				
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
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
		cruConfig.queryStr = "select tr.explosives_no,decode(tr.if_build,'1','是','2','否') if_build,decode(tr.if_library,'1','是','2','否') if_library,tr.inventory,tr.consumption,tr.spare1,tr.equipment_total ,  tr.second_org,tr.third_org,oi3.org_abbreviation org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_EXPLOSIVES_MANAGEMENT tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id = os3.org_id and oi3.bsflag='0'  where tr.bsflag = '0' "+querySqlAdd+" order by tr.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/explosivesManagement/explosivesManagement.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl =  "/hse/hseOptionPage/explosivesManagement/explosivesManagement.jsp";
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
		var ifBuild = document.getElementById("ifBuild").value;
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		if(ifBuild!=''&&ifBuild!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select tr.explosives_no,decode(tr.if_build,'1','是','2','否') if_build,decode(tr.if_library,'1','是','2','否') if_library,tr.inventory,tr.consumption,tr.spare1,tr.equipment_total ,  tr.second_org,tr.third_org,oi3.org_abbreviation org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_EXPLOSIVES_MANAGEMENT tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id = os3.org_id and oi3.bsflag='0'  where tr.bsflag = '0' "+querySqlAdd+" and tr.if_build='"+ ifBuild +"' order by tr.modifi_date desc ";
			cruConfig.currentPageUrl = "/hse/hseOptionPage/explosivesManagement/explosivesManagement.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("projectNames").value = "";
	}

	function loadDataDetail(shuaId){
//		var obj = event.srcElement;
//		if(obj.tagName.toLowerCase() =='td'){
//			obj.parentNode.cells[0].firstChild.checked = 'checked';
//		}
		if(shuaId !=null){
		    document.getElementById("attachement").src = "<%=contextPath%>/hse/docCommon/hseCommDocList.jsp?relation_id="+shuaId;
		    
			var querySql = "";
			var queryRet = null;
			var  datas =null;					
			querySql = " select  tr.project_no, tr.org_sub_id,tr.explosives_no,tr.if_build,tr.if_library,tr.inventory,tr.consumption,tr.spare1,tr.equipment_total ,  tr.second_org,tr.third_org,oi3.org_abbreviation org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_EXPLOSIVES_MANAGEMENT tr   left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3  on oi3.org_id = os3.org_id and oi3.bsflag='0'   where tr.bsflag = '0' and tr.explosives_no='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){	
		             document.getElementsByName("explosives_no")[0].value=datas[0].explosives_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		      		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;		    		 		 
		    		 document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;		    		 
		    		 document.getElementsByName("if_build")[0].value=datas[0].if_build;
		    		 document.getElementsByName("if_library")[0].value=datas[0].if_library;		
		    		 document.getElementsByName("inventory")[0].value=datas[0].inventory;			
		    		 document.getElementsByName("consumption")[0].value=datas[0].consumption;			 
		    		 document.getElementsByName("spare1")[0].value=datas[0].spare1;
		    		  document.getElementsByName("project_no")[0].value=datas[0].project_no;		  
		  		    
				}					
			
		    	}		
			
			var querySql1="";
			var queryRet1=null;
			var datas1 =null;
			 deleteTableTr("hseTableInfo");
			 document.getElementById("lineNum").value="0";	
				   querySql1 = " select  dl.edetail_no,dl.explosives_no,dl.driver_name,dl.vehicle_paizhao,dl.rated_load, dl.creator,dl.create_date,dl.updator,dl.modifi_date,dl.bsflag  from BGP_EXPLOSIVES_DETAIL dl  where dl.bsflag='0' and dl.explosives_no='" + shuaId + "'  order by  dl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
	
						if(datas1 != null && datas1 != ''){		 
							for(var i = 0; i<datas1.length; i++){	 	
					       addLine1(datas1[i].edetail_no,datas1[i].explosives_no,datas1[i].driver_name,datas1[i].vehicle_paizhao,datas1[i].rated_load,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
							}
						}
				    }	

			  
		}
		
	}  
	function calculateCost(){
		var trainTotal=0; 		       
		var inventory = document.getElementById("inventory").value;
		var consumption = document.getElementById("consumption").value;
	  
		if(checkNaN("inventory")  && checkNaN("consumption")){
			trainTotal = parseFloat(inventory)*parseFloat(consumption);	 
		 	}		
		document.getElementById("spare1").value=substrin(trainTotal);
	}
	
	function substrin(str)
	{ 
		str = Math.round(str * 10000) / 10000;
		return(str); 
	 }

	function checkNaN(numids){

		 var str = document.getElementById(numids).value;
	 
		 if(str!=""){		 
			if(isNaN(str)){
				alert("请输入数字");
				document.getElementById(numids).value="";
				return false;
			}else{
				return true;
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/explosivesManagement/addExplosives.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/explosivesManagement/addExplosives.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&explosives_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/explosivesManagement/addExplosives.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&explosives_no="+ids);
	  	
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
 
		deleteEntities("update BGP_EXPLOSIVES_MANAGEMENT e set e.bsflag='1' where e.explosives_no in ("+id+")");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/explosivesManagement/hse_search.jsp?isProject=<%=isProject%>");
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
			
			var if_build = document.getElementsByName("if_build")[0].value;
			var if_library = document.getElementsByName("if_library")[0].value;		
			var inventory = document.getElementsByName("inventory")[0].value;			
			var consumption = document.getElementsByName("consumption")[0].value;			
			var spare1 = document.getElementsByName("spare1")[0].value;
 
			
			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(if_build==""){
	 			alert("是否建库不能为空，请填写！");
	 			return true;
	 		}
	 		if(if_library==""){
	 			alert("是否撤库不能为空，请选择！");
	 			return true;
	 		}
	 		if(inventory==""){
	 			alert("炸药最大库存量不能为空，请填写！");
	 			return true;
	 		}
	 
			if(consumption==""){
	 			alert("雷管最大库存量不能为空，请填写！");
	 			return true;
	 		}
			if(spare1==""){
	 			alert("是否建立监控系统不能为空，请填写！");
	 			return true;
	 		}
			
	 		
	 		return false;
	 	}
	 	
	 	
		
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var explosives_no = document.getElementsByName("explosives_no")[0].value;						 
		  if(explosives_no !=null && explosives_no !=''){
				if(checkJudge()){
					return;
				}
			    var explosives_no = document.getElementsByName("explosives_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;		
				
				var if_build = document.getElementsByName("if_build")[0].value;
				var if_library = document.getElementsByName("if_library")[0].value;		
				var inventory = document.getElementsByName("inventory")[0].value;			
				var consumption = document.getElementsByName("consumption")[0].value;			
				var spare1 = document.getElementsByName("spare1")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;						 
				
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org; 
				rowParam['if_build'] = encodeURI(encodeURI(if_build));
				rowParam['if_library'] = encodeURI(encodeURI(if_library)); 
				rowParam['inventory'] =inventory; 
				rowParam['consumption'] =consumption; 	
				rowParam['spare1'] =spare1; 

			    rowParam['explosives_no'] = explosives_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_EXPLOSIVES_MANAGEMENT",rows);	
			    refreshData();	 
   
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
  function toUpdate1(){	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();
		var explosives_nos = document.getElementsByName("explosives_no")[0].value;	
					
		 if(explosives_nos !=null && explosives_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			
 
			var edetail_no =document.getElementsByName("edetail_no_"+i)[0].value; 
			var explosives_no =document.getElementsByName("explosives_no_"+i)[0].value;
			var driver_name = document.getElementsByName("driver_name_"+i)[0].value;
			var vehicle_paizhao = document.getElementsByName("vehicle_paizhao_"+i)[0].value;
			var rated_load =document.getElementsByName("rated_load_"+i)[0].value;
 
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
			if(edetail_no !=null && edetail_no !=''){			
 				rowParam['driver_name'] = encodeURI(encodeURI(driver_name));
				rowParam['vehicle_paizhao'] = encodeURI(encodeURI(vehicle_paizhao));
				rowParam['rated_load'] = encodeURI(encodeURI(rated_load));
			 
			    rowParam['edetail_no'] = edetail_no;
			    rowParam['explosives_no'] = explosives_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['driver_name'] = encodeURI(encodeURI(driver_name));
				rowParam['vehicle_paizhao'] = encodeURI(encodeURI(vehicle_paizhao));
				rowParam['rated_load'] = encodeURI(encodeURI(rated_load));
			 		
			    rowParam['explosives_no'] = explosives_nos;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_EXPLOSIVES_DETAIL",rows);	
		    refreshData();
 
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}

 	function addLine1(edetail_nos,explosives_nos,driver_names,vehicle_paizhaos,rated_loads,creators,create_dates,updators,modifi_dates,bsflags){
		
		var edetail_no = "";
		var explosives_no = "";
		var driver_name = "";
		var vehicle_paizhao = "";
		var rated_load = "";
		
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";
		
		
		if(edetail_nos != null && edetail_nos != ""){
			edetail_no=edetail_nos;
		}
		if(explosives_nos != null && explosives_nos != ""){
			explosives_no=explosives_nos;
		}
		if(driver_names != null && driver_names != ""){
			driver_name=driver_names;
		}
		
		if(vehicle_paizhaos != null && vehicle_paizhaos != ""){
			vehicle_paizhao=vehicle_paizhaos;
		}
		if(rated_loads != null && rated_loads != ""){
			rated_load=rated_loads;
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
		tr.insertCell().innerHTML = '<input type="hidden"  name="edetail_no' + '_' + rowNum + '" value="'+edetail_no+'"/>'+'<input type="text" style="width:260px;" class="input_width" name="driver_name' + '_' + rowNum + '" value="'+driver_name+'" />'+'<input type="hidden"  name="explosives_no' + '_' + rowNum + '" value="'+explosives_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="text" style="width:360px;" class="input_width" name="vehicle_paizhao' + '_' + rowNum + '" value="'+vehicle_paizhao+'" />';
		tr.insertCell().innerHTML = '<input type="text" style="width:350px;" class="input_width" name="rated_load' + '_' + rowNum + '" value="'+rated_load+'" />';		
 
		var td = tr.insertCell(); 
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;			 
		
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

