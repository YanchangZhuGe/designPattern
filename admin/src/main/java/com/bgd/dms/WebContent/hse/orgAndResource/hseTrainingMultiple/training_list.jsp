<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = "1";
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#cdddef"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="projectName" name="projectName" type="text"/></td>
			     <td class="ali_cdn_name">数据来源</td>
			    <td class="ali_cdn_input"><select id="flag_s"  name="flag_s" class="select_width">
			    	<option value="" selected>请选择</option>
					<option value="1">自有</option>
					<option value="2">人力</option>
			    </select>
			    <input type='hidden' id="checkall" name="checkall" value="0"/>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_plan_id},{flag},{train_detail_no}' {disasss}  id='rdo_entity_id_{hse_plan_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{train_object}">培训对象</td>
			      <td class="bt_info_even" exp="{train_address}">培训地点</td>
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{train_time}">培训时间</td>
			      <td class="bt_info_odd" exp="{train_content}">培训内容</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">单据明细</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_plan_id" name="hse_plan_id" value=""></input>
			<input type="hidden" id="flag" name="flag" value=""></input>
			<input type="hidden" id="hse_detail_id" name="hse_detail_id" value=""></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis3"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					 <tr>
				     	<td class="inquire_item6">单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
				      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				      	<%} %>
				      	</td>
				     	<td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				      	<%} %>
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item6"><font color="red">*</font>培训对象：</td>
				      	<td class="inquire_form6"><input type="text" id="train_object" name="train_object" class="input_width"  value=""/></td>
				     	<td class="inquire_item6"><font color="red">*</font>培训地点：</td>
				      	<td class="inquire_form6"><input type="text" id="train_address" name="train_address" class="input_width"   value=""/></td>
				     </tr>
				     <tr>
				     	<td class="inquire_item6">项目名称：</td>
				      	<td class="inquire_form6"><input type="text" id="project_name" name="project_name" class="input_width" value=""/></td>
				    	<td class="inquire_item6"><font color="red">*</font>培训时间：</td>
				      	<td class="inquire_form6"><input type="text" id="train_time" name="train_time" class="input_width" value=""></input></td>
				     </tr>
				     <tr>
				    	<td class="inquire_item6"><font color="red">*</font>培训目的：</td>
				      	<td class="inquire_form6" colspan="3"><textarea id="train_purpose" name="train_purpose" class="textarea" style="height: 40px;"></textarea></td>
				      </tr>
				      <tr>	
				     	<td class="inquire_item6"><font color="red">*</font>培训内容：</td>
				      	<td class="inquire_form6" colspan="3">
				      		<textarea  id="train_content" name="train_content" class="textarea" style="height: 40px;" rows="" cols=""></textarea>
				      	</td>
				     </tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					 <tr class="bt_info" align="center">
				    	    <td>人数</td>
				            <td>学时</td>
				            <td>授课费</td>		
				            <td>交通费</td>
				            <td>材料费</td>
				            <td>场地费</td>
				            <td>食宿费</td>
				            <td>其它费用</td>
				            <td>费用合计</td>
				        </tr>
				        <tr class="odd" align="center">
				        	<td ><input type="text" id="train_num" name="train_num" class="input_width" onchange=""/></input></td>
				        	<td ><input type="text" id="train_class" name="train_class" class="input_width"  onchange=""/></td>
				        	<td ><input type="text" id="train_cost" name="train_cost" class="input_width"  onchange=""/></td>
				        	<td ><input type="text" id="train_transport" name="train_transport" class="input_width" onchange=""/></input></td>
				        	<td ><input type="text" id="train_material" name="train_material" class="input_width"  onchange=""/></td>
				        	<td ><input type="text" id="train_places" name="train_places" class="input_width"  onchange=""/></td>
				        	<td ><input type="text" id="train_accommodation" name="train_accommodation" class="input_width" onchange=""/></input></td>
				        	<td ><input type="text" id="train_other" name="train_other" class="input_width"  onchange=""/></td>
				        	<td ><input type="text" id="train_total" name="train_total" class="input_width"  onchange=""/></td>
				        </tr>
					
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="zj"  onclick="toAddLine()" title="新增"><a href="#"></a></span></td>
		                  <td width="30" id="buttonDis2" ><span class="bc"  onclick="toUpdateRecord()" title="保存"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table id="queryTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
					<input type="hidden" id="orderNum" name="orderNum" value="1"></input>
					  <tr>
				    	    <td class="bt_info_odd"></td>
				    	    <td class="bt_info_even">序号</td>
				            <td class="bt_info_odd">姓名</td>
				            <td class="bt_info_even">培训时间</td>		
				            <td class="bt_info_odd">用功类别</td>
				            <td class="bt_info_even">考核结果</td>
				            <td class="bt_info_odd">备注</td>
				        </tr>
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0"  marginwidth="0" scrolling="auto">
					</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
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
</script>

<script type="text/javascript">


cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
	
}
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		var sql = "";
		if(retObj.flag!="false"){
			var len = retObj.list.length;
			if(len>0){
				if(retObj.list[0].organFlag!="0"){
					sql = " and t.second_org = '" + retObj.list[0].orgSubId +"'";
					if(len>1){
						if(retObj.list[1].organFlag!="0"){
							sql = " and t.third_org = '" + retObj.list[1].orgSubId +"'";
						}
					}
				}
			}
		}
		cruConfig.queryStr = "select * from ((select '0' train_detail_no,tp.train_content,tp.hse_plan_id,tp.train_object,tp.train_address,oi.org_abbreviation second_org_name,oi1.org_abbreviation third_org_name,tp.project_name,tp.train_time,tp.second_org,tp.third_org,tp.bsflag,tp.modifi_date,1 flag,'' disasss from bgp_hse_train_plan tp left join comm_org_subjection os on tp.second_org=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' left join comm_org_subjection os1 on tp.third_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' where tp.bsflag='0') union all (select dl.train_detail_no,dl.train_content, pn.train_plan_no,pn.train_object,train_address,oi1.org_abbreviation second_org_name,i.org_abbreviation,p.project_name,pn.train_cycle,os1.org_subjection_id second_org,os.org_subjection_id third_org,dl.bsflag,dl.modifi_date,2 flag,'disabled' disasss  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'left join gp_task_project p on pn.project_info_no = p.project_info_no and p.bsflag = '0' left join comm_org_information i on pn.spare1 = i.org_id and i.bsflag = '0' left join comm_org_subjection os on os.org_id = i.org_id and os.bsflag='0' left join comm_org_subjection os1 on os.father_org_id=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0'  where dl.bsflag='0' and (dl.classification = '2' or　dl.classification = '4') )) t where t.bsflag='0' "+sql+" order by t.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var projectName = document.getElementById("projectName").value;
			var flag_s = document.getElementById("flag_s").value;
			
			cruConfig.cdtType = 'form';
			retObj = jcdpCallService("HseSrv", "queryOrg", "");
			var sql = "";
			if(retObj.flag!="false"){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag!="0"){
						sql = " and t.second_org = '" + retObj.list[0].orgSubId +"'";
						if(len>1){
							if(retObj.list[1].organFlag!="0"){
								sql = " and t.third_org = '" + retObj.list[1].orgSubId +"'";
							}
						}
					}
				}
			}
			
			var str_sql=""; 
			if(flag_s!=''&&flag_s!=null){
				str_sql =" and t.flag="+ flag_s; 
			}
			if(projectName!=''&&projectName!=null){
				str_sql =str_sql+ "and t.project_name like '%"+projectName+"%' "; 
			}
			if(str_sql!=''&&str_sql!=null){
				cruConfig.cdtType = 'form';
				cruConfig.queryStr = "select * from ((select '0' train_detail_no,tp.train_content,tp.hse_plan_id,tp.train_object,tp.train_address,oi.org_abbreviation second_org_name,oi1.org_abbreviation third_org_name,tp.project_name,tp.train_time,tp.second_org,tp.third_org,tp.bsflag,tp.modifi_date,1 flag, '' disasss  from bgp_hse_train_plan tp left join comm_org_subjection os on tp.second_org=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' left join comm_org_subjection os1 on tp.third_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' where tp.bsflag='0') union all (select dl.train_detail_no,dl.train_content,pn.train_plan_no,pn.train_object,train_address,oi1.org_abbreviation second_org_name,i.org_abbreviation,p.project_name,pn.train_cycle,os1.org_subjection_id second_org,os.org_subjection_id third_org,dl.bsflag,dl.modifi_date,2 flag, 'disabled' disasss  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'left join gp_task_project p on pn.project_info_no = p.project_info_no and p.bsflag = '0' left join comm_org_information i on pn.spare1 = i.org_id and i.bsflag = '0' left join comm_org_subjection os on os.org_id = i.org_id and os.bsflag='0' left join comm_org_subjection os1 on os.father_org_id=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0'  where dl.bsflag='0' and (dl.classification = '2' or　dl.classification = '4') )) t where t.bsflag='0' "+sql+str_sql+"  order by t.modifi_date desc";
				cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
				queryData(1);
			}else{
				refreshData();
			}
	}
	
	function clearQueryText(){
		document.getElementById("projectName").value = "";
		document.getElementById("flag_s").value="";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		var flag = "";
		debugger;
		if(shuaId!=null){
				var temp = shuaId.split(',');
				var id = temp[0];
				flag = temp[1];
				detail_id = temp[2];
				document.getElementById("flag").value = flag;
			 retObj = jcdpCallService("HseSrv", "viewHseTraining", "hse_plan_id="+id+"&detail_id="+detail_id);
			 document.getElementById("attachement").src = "<%=contextPath%>/hse/docCommon/hseCommDocList.jsp?relation_id="+id;
			 document.getElementById("remark").src = "/gms3/common/remark/relatedOperation.srq?foreignKeyId="+id;
 
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var temp = ids.split(',');
			var id = temp[0];
			flag = temp[1];
			detail_id = temp[2];
			document.getElementById("flag").value = flag;
		    retObj = jcdpCallService("HseSrv", "viewHseTraining", "hse_plan_id="+id+"&detail_id="+detail_id);
		    document.getElementById("attachement").src = "<%=contextPath%>/hse/docCommon/hseCommDocList.jsp?relation_id="+id;
			 document.getElementById("remark").src = "/gms3/common/remark/relatedOperation.srq?foreignKeyId="+id;
		}

		if(flag=="2"){
			document.getElementById("buttonDis3").style.display = "none";
			document.getElementById("buttonDis2").style.display = "none";
			document.getElementById("buttonDis1").style.display = "none";
 
			document.getElementById("second_org").value = retObj.mapOld.secondOrg;
			document.getElementById("second_org2").value = retObj.mapOld.secondOrgName;
			document.getElementById("third_org").value = retObj.mapOld.thirdOrg;
			document.getElementById("third_org2").value = retObj.mapOld.orgAbbreviation;
			document.getElementById("train_object").value = retObj.mapOld.trainObject;
			document.getElementById("train_address").value = retObj.mapOld.trainAddress;
			document.getElementById("project_name").value = retObj.mapOld.projectName;
			document.getElementById("train_time").value = retObj.mapOld.trainCycle;
			document.getElementById("train_purpose").value = retObj.mapOld.trainPurpose;
			document.getElementById("train_content").value = retObj.mapOld.trainContent;
			
			document.getElementById("train_num").value = retObj.mapOld.trainNumber;
			document.getElementById("train_class").value = retObj.mapOld.trainClass;
			document.getElementById("train_cost").value = retObj.mapOld.trainCost;
			document.getElementById("train_transport").value = retObj.mapOld.trainTransportation;
			document.getElementById("train_material").value = retObj.mapOld.trainMaterials;
			document.getElementById("train_places").value = retObj.mapOld.trainPlaces;
			document.getElementById("train_accommodation").value = retObj.mapOld.trainAccommodation;
			document.getElementById("train_other").value = retObj.mapOld.trainOther;
			document.getElementById("train_total").value = retObj.mapOld.trainTotal;
		}else{
			document.getElementById("buttonDis3").style.display = "";
			document.getElementById("buttonDis2").style.display = "";
			document.getElementById("buttonDis1").style.display = "";
			
			document.getElementById("hse_plan_id").value = retObj.mapNew.hsePlanId;
			document.getElementById("hse_detail_id").value = retObj.mapNew.hseDetailId;
			
			document.getElementById("second_org").value = retObj.mapNew.secondOrg;
			document.getElementById("second_org2").value = retObj.mapNew.secondOrgName;
			document.getElementById("third_org").value = retObj.mapNew.thirdOrg;
			document.getElementById("third_org2").value = retObj.mapNew.thirdOrgName;
			document.getElementById("train_object").value = retObj.mapNew.trainObject;
			document.getElementById("train_address").value = retObj.mapNew.trainAddress;
			document.getElementById("project_name").value = retObj.mapNew.projectName;
			document.getElementById("train_time").value = retObj.mapNew.trainTime;
			document.getElementById("train_purpose").value = retObj.mapNew.trainPurpose;
			document.getElementById("train_content").value = retObj.mapNew.trainContent;
			
			document.getElementById("train_num").value = retObj.mapNew.trainNum;
			document.getElementById("train_class").value = retObj.mapNew.trainClass;
			document.getElementById("train_cost").value = retObj.mapNew.trainCost;
			document.getElementById("train_transport").value = retObj.mapNew.trainTransport;
			document.getElementById("train_material").value = retObj.mapNew.trainMaterial;
			document.getElementById("train_places").value = retObj.mapNew.trainPlaces;
			document.getElementById("train_accommodation").value = retObj.mapNew.trainAccommodation;
			document.getElementById("train_other").value = retObj.mapNew.trainOther;
			document.getElementById("train_total").value = retObj.mapNew.trainTotal;
		}
	 
		debugger;
		for(var j =1;j <document.getElementById("queryTable")!=null && j < document.getElementById("queryTable").rows.length ;){
			document.getElementById("queryTable").deleteRow(j);
		}
		document.getElementById("lineNum").value = 0;	
		document.getElementById("orderNum").value = 1;
		if(retObj.list!=null&&retObj.list!=""){
			var list = retObj.list;
			for(var i=0;i<list.length;i++){
				toAddLine(
						list[i].employeeId ? list[i].employeeId : "",
						list[i].employeeName ? list[i].employeeName : "",
						list[i].trainDate ? list[i].trainDate : "",
						list[i].employeeType ? list[i].employeeType : "",
						list[i].trainResult ? list[i].trainResult : "",
						list[i].notes ? list[i].notes : ""
						);
			}
		}
		
		
		
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function outMust(){
		if(document.getElementById("out_flag").value=="1"){
			document.getElementById("out_must1").style.display="";
			document.getElementById("out_must2").style.display="";
			document.getElementById("out_name").disabled="";
			document.getElementById("out_type").disabled="";
		}else{
			document.getElementById("out_must1").style.display="none";
			document.getElementById("out_must2").style.display="none";
			document.getElementById("out_name").disabled="disabled";
			document.getElementById("out_type").disabled="disabled";
		}
	}
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/orgAndResource/hseTrainingMultiple/addTraining.jsp","1000:675");
		
	}
	
	function toEdit(){  
		debugger;
		var hse_plan_id = document.getElementById("hse_plan_id").value;
		var flag = document.getElementById("flag").value;
	  	if(flag!=null&&flag!="1"){
	  		alert("此条信息不能被修改!");  
	  		return;  
	  	}
	  	if(hse_plan_id==''||hse_plan_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}
	  	popWindow("<%=contextPath%>/hse/orgAndResource/hseTrainingMultiple/addTraining.jsp?hse_plan_id="+hse_plan_id+"&flag="+flag,"1000:675");
	  	
	} 
	
	function toUpdate(){  
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/hseTraining/addHseTraining2.srq";
		form.submit();
	} 
	
	function toUpdateRecord(){
		
		var hse_plan_id = document.getElementById("hse_plan_id").value;
		if(hse_plan_id==null||hse_plan_id==""){
			alert("请选中一条记录！");
			return;
		}
		debugger;
		var temp = "";
		var orders = document.getElementsByName("order");	
		for (var i=0;i<orders.length;i++){
			var order = orders[i].value;
			if(temp!=""){
				temp = temp+",";
			}
				temp = temp+order;
		}
		
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/hseTraining/addHseTrainingRecord.srq?temp="+temp;
		form.submit();
	}
	

	function toAddLine(employee_id,human_name,train_date,employee_type,train_result,notes){
		
		var employee_id2 ="";
		var human_name2 = "";
		var train_date2 = "";
		var employee_type2 = "0";
		var train_result2 = "0";
		var notes2 = "";
		
		if(employee_id!=null&&employee_id!=""){
			employee_id2 = employee_id;
		}
		if(human_name!=null&&human_name!=""){
			human_name2 = human_name;
		}
		if(train_date!=null&&train_date!=""){
			train_date2 = train_date;
		}
		if(employee_type!=null&&employee_type!=""){
			employee_type2 = employee_type;
		}
		if(train_result!=null&&train_result!=""){
			train_result2 = train_result;
		}
		if(notes!=null&&notes!=""){
			notes2 = notes;
		}
		
		debugger;
		var rowNum = document.getElementById("lineNum").value;	
		var orderNum = document.getElementById("orderNum").value;	
		
		var table=document.getElementById("queryTable");
		
		var lineId = "row_" + rowNum;
		var autoOrder = document.getElementById("queryTable").rows.length;
		var newTR = document.getElementById("queryTable").insertRow(autoOrder);
		newTR.id = lineId;
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
		
		
		var td = newTR.insertCell(0);
		td.innerHTML = "<input type='hidden' name='order' value='" + rowNum + "'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		var td = newTR.insertCell(1);
		td.innerHTML = orderNum;
		td.id = "orderNumber"+rowNum;
		td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		
		td = newTR.insertCell(2);
		td.innerHTML = "<input type='hidden' id='employee_id"+rowNum+"' name='employee_id"+rowNum+"'  value='"+employee_id2+"'/><input type='text' id='human_name"+rowNum+"' name='human_name"+rowNum+"' value='"+human_name2+"' readonly/>";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		td = newTR.insertCell(3);
		td.innerHTML = "<input type='text' id='train_date"+rowNum+"' name='train_date"+rowNum+"' value='"+train_date2+"' readonly/>&nbsp;<img src='<%=contextPath%>/images/calendar.gif' id='tributton"+rowNum+"' width='16' height='16' style='cursor: hand;' onmouseover='timeSelector(train_date"+rowNum+",tributton"+rowNum+");' />";
		td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		
		td = newTR.insertCell(4);
		td.innerHTML = "<select id='employee_type"+rowNum+"' name='employee_type"+rowNum+"'><option value='0'>再就业人员</option><option value='1'>合同化员工</option><option value='2'>市场化用工</option><option value='3'>劳务用工</option><option value='4'>临时季节性</option></select>&nbsp;&nbsp;<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor: hand;' onclick='selectLabor(\""+rowNum+"\")' />";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		td = newTR.insertCell(5);
		td.innerHTML = "<select id='train_result"+rowNum+"' name='train_result"+rowNum+"'><option value='0'>合格</option><option value='1'>不合格</option></select>";
		td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		
		td = newTR.insertCell(6);
		td.innerHTML = "<textarea id='notes"+rowNum+"' name='notes"+rowNum+"'>"+notes2+"</textarea>";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		 
		document.getElementById("employee_type"+rowNum).value = employee_type2;
		document.getElementById("train_result"+rowNum).value = train_result2;
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;
		document.getElementById("orderNum").value = parseInt(orderNum) + 1;
	}
	
	function deleteLine(lineId){		
		var rowNum = lineId.split('_')[1];
		//取删除行的主键ID
		var line = document.getElementById(lineId);		
		line.parentNode.removeChild(line);
		changeOrder();
	}
	
	function changeOrder(){
		debugger;
		var orders = document.getElementsByName("order");	
		for (var i=0;i<orders.length;i++){
			var order = orders[i].value;
			document.getElementById("orderNumber"+order).innerHTML = i+1;
		}
		document.getElementById("orderNum").value = orders.length + 1;
	}
	
	
	 function selectLabor(rowNum){
		 
		var numAll = document.getElementById("employee_type"+rowNum).value;
		 var laborType="";
		 if(numAll =="0"){
			 laborType="0110000059000000001";
		 }
		 if(numAll =="3"){
			 laborType="0110000059000000003";
		 }
		 if(numAll =="4"){
			 laborType="0110000059000000005";
		 }
		 if(numAll =="1"){
			 laborType="0110000019000000001";
		 }
		 if(numAll =="2"){
			 laborType="0110000019000000002";
		 }
		 
		 if(numAll=="1"||numAll=="2"){
			 var result=showModalDialog('<%=contextPath%>/rm/em/singleHuman/humanTrainingRecord/humanListLink.jsp?laborType='+laborType,'','dialogWidth:500px;dialogHeight:500px;status:yes');
		 }else{
		    var result = showModalDialog('<%=contextPath%>/rm/em/singleHuman/humanTrainingRecord/laborListLink.jsp?laborType='+laborType,'','dialogWidth:500px;dialogHeight:500px;status:yes'); 
		 }
		 
		if(result!="" && result!=undefined ){
			 	var testTemp = result.split("-");  
				document.getElementById("employee_id"+rowNum).value=testTemp[0]; 
				document.getElementById("human_name"+rowNum).value=testTemp[1];
	
	    }
	 }
	
	function checkText0(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var accident_name=document.getElementById("accident_name").value;
		var accident_type=document.getElementById("accident_type").value;
		var accident_date=document.getElementById("accident_date").value;
		var accident_place=document.getElementById("accident_place").value;
		var workplace_flag = document.getElementById("workplace_flag").value;
		var accident_money = document.getElementById("accident_money").value;
		var out_flag = document.getElementById("out_flag").value;
		var out_name = document.getElementById("out_name").value;
		var out_type = document.getElementById("out_type").value;
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		if(accident_name==""){
			alert("事故名称不能为空，请填写！");
			return true;
		}
		if(accident_type==""){
			alert("事故类型不能为空，请选择！");
			return true;
		}
		if(accident_date==""){
			alert("事故日期不能为空，请填写！");
			return true;
		}
		if(accident_place==""){
			alert("事故地点不能为空，请填写！");
			return true;
		}
		if(workplace_flag==""){
			alert("是否属于工作场所不能为空，请选择！");
			return true;
		}
		if(out_flag==""){
			alert("是否为承包商不能为空，请选择！");
			return true;
		}
		if(out_flag=="1"){
			if(out_name==""){
				alert("承包商名称不能为空，请填写！");
				return true;
			}
			if(out_type==""){
				alert("承包商类型不能为空，请选择！");
				return true;
			}
		}
		if(accident_money==""){
			alert("初步估计经济损失不能为空，请填写！");
			return true;
		}
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    if (!re.test(accident_money))
	   {
	       alert("初步估计经济损失请输入数字！");
	       return true;
	    }
		return false;
	}


	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	  
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteHseTraining", "ids="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/orgAndResource/hseTrainingMultiple/training_search.jsp");
	}
	
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
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
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}
	
	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
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
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
	
</script>

</html>

