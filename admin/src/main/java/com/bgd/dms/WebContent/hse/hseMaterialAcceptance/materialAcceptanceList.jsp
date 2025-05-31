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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
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
 
<title>HSE相关物资验收功能开发</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资名称</td>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{material_no}' value='{material_no}'  onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{material_name}">物资名称</td>
			      <td class="bt_info_even" exp="{material_type}">类别</td>
			      <td class="bt_info_odd" exp="{valid_until}">有效期截止至</td>
 
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">使用单位验收</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">上级审核</a></li>		
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
				    	  
				    	  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">					      
					      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="material_no" name="material_no"   />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					  </tr>					  
						<tr>								 
				        <td class="inquire_item6"><font color="red">*</font>使用单位/部门：</td>					 
					    <td class="inquire_form6"> 
					    <input type="text" id="use_unit" name="use_unit" class="input_width"   />     </td>	
					    <td class="inquire_item6"><font color="red">*</font>物资名称：</td>
					    <td class="inquire_form6">
					    <input type="text" id="material_name" name="material_name" class="input_width"   />    					    
					    </td>	
					    <td class="inquire_item6"><font color="red">*</font>类别：</td>
					    <td class="inquire_form6"> 
					    <select id="material_type" name="material_type" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >应急物资</option>
					       <option value="2" >急救药品</option>
					       <option value="3" >劳保用品</option>
					       <option value="4" >安全防护设施</option>
					       <option value="5" >其他</option>
						</select>
					    </td>
						</tr>						
			 
					  <tr>
					    <td class="inquire_item6"> 型号/规格：</td>
					    <td class="inquire_form6"><input type="text" id="material_model" name="material_model"    class="input_width"/></td>				 
					    <td class="inquire_item6"><font color="red">*</font>数量：</td>
					    <td class="inquire_form6">
					    <input type="text" id="material_quantity" name="material_quantity" class="input_width" />
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>外观是否完好：</td>
					    <td class="inquire_form6">
					    <select id="if_good" name="if_good" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="2" >否</option>					      
						</select>
						</td>
					  </tr>					  
					  <tr>					
					    <td class="inquire_item6"><font color="red">*</font>标识：</td>
					    <td class="inquire_form6">
					    <select id="identification" name="identification" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >符合</option>
					       <option value="2" >不符合</option>					      
						</select>
					    </td>					 
					    <td class="inquire_item6"><font color="red">*</font>有效期截止至：</td>
					    <td class="inquire_form6"><input type="text" id="valid_until" name="valid_until" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until,tributton1);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>验收人：</td>
					    <td class="inquire_form6"><input type="text" id="acceptance_people" name="acceptance_people" class="input_width" /></td>
					  </tr>					
					  <tr>							  					 
					    <td class="inquire_item6"><font color="red">*</font>验收时间：</td>
					    <td class="inquire_form6"><input type="text" id="acceptance_time" name="acceptance_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acceptance_time,tributton2);" />&nbsp;</td>
					  </tr>				  
					</table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"> 其他验收内容：</td> 	 				    
					    <td class="inquire_form6"  >
					    <input type="text" id="other_content" name="other_content" class="input_width" style="width:700px;" /></td>				 
					    <td class="inquire_item6"> </td>  
					    <td class="inquire_item6"> </td>
					    
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>验收意见：</td>
					    <td class="inquire_form6"  >
					    <input type="text" id="opinion" name="opinion" class="input_width" style="width:700px;" /></td>				 
					    <td class="inquire_item6"> </td>
					    <td class="inquire_item6"> </td>
					  </tr>	
						</table>
				</div>
		
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis3" >		     
		                  <span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo2">			
						 
					  <tr> 
					    <td class="inquire_item6"> 审核结论：</td>
					    <td class="inquire_form6" >					 
					    <select id="audit_conclusion" name="audit_conclusion" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >同意接受</option>
					       <option value="2" >不同意接收</option>
						</select>					    
					    </td>					    
					 </tr>	
					 <tr>
					    <td class="inquire_item6"> 上级审核意见：</td>			 
					    <td class="inquire_form6" colspan="5"><textarea id="superior_opinions" name="superior_opinions"   class="textarea" ></textarea></td>
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
		cruConfig.queryStr = " select   tr.material_name, tr.valid_until, tr.material_no, oi3.org_abbreviation as org_name, oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name,  decode(tr.material_type, '1', '应急物资', '2', '急救药品', '3', '劳保用品', '4', '安全防护设施','5', '其他') material_type   from BGP_HSE_MATERIAL tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id = os3.org_id  where tr.bsflag = '0' "+querySqlAdd+" order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseMaterialAcceptance/materialAcceptanceList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseMaterialAcceptance/materialAcceptanceList.jsp";
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
			querySqlAdd = "and tr.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		if(materialName!=''&& materialName!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "  select   tr.material_name, tr.valid_until, tr.material_no, oi3.org_abbreviation as org_name, oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name,  decode(tr.material_type, '1', '应急物资', '2', '急救药品', '3', '劳保用品', '4', '安全防护设施','5', '其他') material_type   from BGP_HSE_MATERIAL tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id = os3.org_id  where tr.bsflag = '0' "+querySqlAdd+" and tr.material_name like'%"+materialName+"%'  order by tr.modifi_date desc";
			cruConfig.currentPageUrl = "/hse/hseMaterialAcceptance/materialAcceptanceList.jsp";
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
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;		

			querySql = " select tr.project_no, tr.superior_opinions,tr.audit_conclusion, tr.second_org,tr.third_org,oi3.org_abbreviation org_name, tr.material_no, tr.creator,tr.create_date,tr.bsflag, tr.use_unit,tr.material_name,tr.material_type,tr.material_model,tr.material_quantity,tr.if_good,tr.identification,tr.valid_until,tr.other_content,tr.opinion,tr.acceptance_people,tr.acceptance_time,oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_MATERIAL tr   left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id  and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id  and oi2.bsflag = '0' left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id = os3.org_id   where tr.bsflag = '0' and tr.material_no='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 			   
		             document.getElementsByName("material_no")[0].value=datas[0].material_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	    	    
		    		  document.getElementsByName("use_unit")[0].value=datas[0].use_unit;
		     		  document.getElementsByName("material_name")[0].value=datas[0].material_name;
		    		  document.getElementsByName("material_type")[0].value=datas[0].material_type;		
		    		  document.getElementsByName("material_model")[0].value=datas[0].material_model;			
		    		  document.getElementsByName("material_quantity")[0].value=datas[0].material_quantity;			
		    		  document.getElementsByName("if_good")[0].value=datas[0].if_good;
		    	      document.getElementsByName("identification")[0].value=datas[0].identification; 
		    		  document.getElementsByName("valid_until")[0].value=datas[0].valid_until;	 
		    	      document.getElementsByName("other_content")[0].value=datas[0].other_content;
	    		      document.getElementsByName("opinion")[0].value=datas[0].opinion;		
	    		      document.getElementsByName("acceptance_people")[0].value=datas[0].acceptance_people;			
	    		      document.getElementsByName("acceptance_time")[0].value=datas[0].acceptance_time;			
	    		      document.getElementsByName("superior_opinions")[0].value=datas[0].superior_opinions;			
	    		      document.getElementsByName("audit_conclusion")[0].value=datas[0].audit_conclusion;	
	    		      document.getElementsByName("project_no")[0].value=datas[0].project_no;
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
		popWindow("<%=contextPath%>/hse/hseMaterialAcceptance/addMmaterialAcceptance.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
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
	 	popWindow("<%=contextPath%>/hse/hseMaterialAcceptance/addMmaterialAcceptance.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&material_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseMaterialAcceptance/addMmaterialAcceptance.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&material_no="+ids);
	  	
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
		deleteEntities("update BGP_HSE_MATERIAL e set e.bsflag='1' where e.material_no in ("+id+")");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseMaterialAcceptance/hse_search.jsp?isProject=<%=isProject%>");
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
				var use_unit = document.getElementsByName("use_unit")[0].value;
				var material_name = document.getElementsByName("material_name")[0].value;		
				var material_type = document.getElementsByName("material_type")[0].value;	 
				var material_quantity = document.getElementsByName("material_quantity")[0].value;
				var if_good = document.getElementsByName("if_good")[0].value;
				var identification = document.getElementsByName("identification")[0].value;		
				var valid_until = document.getElementsByName("valid_until")[0].value;
				var opinion = document.getElementsByName("opinion")[0].value;			
				var acceptance_people = document.getElementsByName("acceptance_people")[0].value;			
				var acceptance_time = document.getElementsByName("acceptance_time")[0].value;	 
	 
				
		 		if(org_sub_id==""){
		 			document.getElementById("org_sub_id").value = "";
		 		}
		 		if(second_org==""){
		 			document.getElementById("second_org").value="";
		 		}
		 		if(third_org==""){
		 			document.getElementById("third_org").value="";
		 		}
		 		
		 		if(use_unit==""){
		 			alert("使用单位/部门不能为空，请填写！");
		 			return true;
		 		}
		 		if(material_name==""){
		 			alert("物资名称不能为空，请选择！");
		 			return true;
		 		}
		 		if(material_type==""){
		 			alert("物资类别不能为空，请填写！");
		 			return true;
		 		}
		  
				if(material_quantity==""){
		 			alert("数量不能为空，请填写！");
		 			return true;
		 		}
				if(if_good==""){
		 			alert("外观是否完好不能为空，请填写！");
		 			return true;
		 		}
				if(identification==""){
		 			alert("标识不能为空，请填写！");
		 			return true;
		 		}
				
				if(valid_until==""){
		 			alert("有效期截止至不能为空，请填写！");
		 			return true;
		 		}
				
				if(opinion==""){
		 			alert("验收意见不能为空，请填写！");
		 			return true;
		 		}
				
				if(acceptance_people==""){
		 			alert("验收人不能为空，请填写！");
		 			return true;
		 		}
				if(acceptance_time==""){
		 			alert("验收时间不能为空，请填写！");
		 			return true;
		 		}
				
		 		return false;
		 	}
			
			
	 
	function toUpdate(){

		var rowParams = new Array(); 
		var rowParam = {};				
		var material_no = document.getElementsByName("material_no")[0].value;						 
		  if(material_no !=null && material_no !=''){		
			  
				if(checkJudge()){
					return;
				}
				
				var material_no = document.getElementsByName("material_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;					
				var use_unit = document.getElementsByName("use_unit")[0].value;
				var material_name = document.getElementsByName("material_name")[0].value;		
				var material_type = document.getElementsByName("material_type")[0].value;			
				var material_model = document.getElementsByName("material_model")[0].value;			
				var material_quantity = document.getElementsByName("material_quantity")[0].value;
				var if_good = document.getElementsByName("if_good")[0].value;
				var identification = document.getElementsByName("identification")[0].value;		
				var valid_until = document.getElementsByName("valid_until")[0].value;
				var other_content = document.getElementsByName("other_content")[0].value;		
				var opinion = document.getElementsByName("opinion")[0].value;			
				var acceptance_people = document.getElementsByName("acceptance_people")[0].value;			
				var acceptance_time = document.getElementsByName("acceptance_time")[0].value;	 
				var audit_conclusion = document.getElementsByName("audit_conclusion")[0].value;			
				var superior_opinions = document.getElementsByName("superior_opinions")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;						 
				 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			 
				rowParam['use_unit'] = encodeURI(encodeURI(use_unit));
				rowParam['material_name'] = encodeURI(encodeURI(material_name));
				rowParam['material_type'] = encodeURI(encodeURI(material_type));
				rowParam['material_model'] = encodeURI(encodeURI(material_model));		 
				rowParam['material_quantity'] = encodeURI(encodeURI(material_quantity));
				rowParam['if_good'] = encodeURI(encodeURI(if_good));
				rowParam['identification'] = encodeURI(encodeURI(identification));
				rowParam['valid_until'] = encodeURI(encodeURI(valid_until));		 
				rowParam['other_content'] = encodeURI(encodeURI(other_content));
				rowParam['opinion'] = encodeURI(encodeURI(opinion));
				rowParam['acceptance_people'] = encodeURI(encodeURI(acceptance_people));
				rowParam['acceptance_time'] = encodeURI(encodeURI(acceptance_time));		
				rowParam['audit_conclusion'] = encodeURI(encodeURI(audit_conclusion));
				rowParam['superior_opinions'] = encodeURI(encodeURI(superior_opinions));			
				
			  if(material_no !=null && material_no !=''){
				    rowParam['material_no'] = material_no;
					rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['create_date'] =create_date;
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
					
			  }else{
				    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] ='<%=curDate%>';
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
				  
			  }  				
		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_HSE_MATERIAL",rows);	
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

