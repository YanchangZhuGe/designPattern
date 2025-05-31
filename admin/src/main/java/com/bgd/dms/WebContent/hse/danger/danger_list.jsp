<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			<input type="hidden" id="hse_danger_id" name="hse_danger_id"></input>
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">隐患名称</td>
			    <td class="ali_cdn_input"><input id="dangerName" name="dangerName" type="text" /></td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_danger_id}' id='rdo_entity_id_{hse_danger_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{danger_name}">隐患名称</td>
			      <td class="bt_info_odd" exp="{danger_level}">隐患级别</td>
			      <td class="bt_info_even" exp="{danger_date}">上报日期</td>
			      <td class="bt_info_odd" exp="{danger_place}">作业场所</td>
			      <td class="bt_info_even" exp="{modify_type}">整改状态</td>
			      <td class="bt_info_odd" exp="{reward_type}">奖励状态</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">隐患信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">整改信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">奖励信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<form name="form0" id="form0"  method="post" action="<%=contextPath%>/hse/editDangerInfo.srq">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toEdit0()"></a></span></td>
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
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
					      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>隐患名称：</td>
					    <td class="inquire_form6"><input type="text" id="danger_name" name="danger_name" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>隐患级别：</td>
					    <td class="inquire_form6">
					    	<select id="danger_level" name="danger_level"  class="select_width">
					          <option value="" >请选择</option>
					          <option value="一般" >一般</option>
					          <option value="较大" >较大</option>
					          <option value="重大" >重大</option>
					          <option value="特大" >特大</option>
						    </select>
						</td>
					   <td class="inquire_item6"><font color="red">*</font>隐患类型：</td>
					    <td class="inquire_form6"><input type="text" id="danger_type" name="danger_type" class="input_width" /></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>上报日期：</td>
					    <td class="inquire_form6"><input type="text" id="danger_date" name="danger_date" class="input_width" readonly="readonly"/>
					    <div id="danger_cal" style="display: none">&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(danger_date,tributton1);" />&nbsp;</div></td>
					    <td class="inquire_item6"><font color="red">*</font>危害因素大类：</td>
					    <td class="inquire_form6"><input type="text" id="danger_big" name="danger_big" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>危害因素中类：</td>
					    <td class="inquire_form6"><input type="text" id="danger_midd" name="danger_midd" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>作业场所：</td>
					    <td class="inquire_form6"><input type="text" id="danger_place" name="danger_place" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">危害影响：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="danger_effect" name="danger_effect" class="textarea"  ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">隐患描述：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="danger_des" name="danger_des" class="textarea" ></textarea></td>
					  </tr>					    
					</table>
					</form>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<form name="form1" id="form1"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toEdit1()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改状态：</td>
					    <td class="inquire_form6">
							<select id="modify_type" name="modify_type"  class="select_width" >
					          <option value="" >请选择</option>
					          <option value="已整改" >已整改</option>
					          <option value="未整改" >未整改</option>
						    </select>
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>整改日期：</td>
					    <td class="inquire_form6"><input type="text" id="modify_time" name="modify_time" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(modify_time,tributton2);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>整改负责人：</td>
					    <td class="inquire_form6"><input type="text" id="modify_person" name="modify_person" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改验证人：</td>
					    <td class="inquire_form6"><input type="text" id="modify_check" name="modify_check" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改措施：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="modify_step" name="modify_step"  class="textarea"  ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改计划：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="modify_project" name="modify_project" class="textarea"  ></textarea></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>未整改原因：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="modify_no_reason" name="modify_no_reason"  class="textarea" ></textarea></td>
					  </tr>					    
					</table>
					</form>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<form name="form2" id="form2"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis3"   ><span class="bc"  onclick="toEdit2()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>奖励状态：</td>
					    <td class="inquire_form6">
					    	<select id="reward_type" name="reward_type" class="select_width"  >
					          <option value="" >请选择</option>
					          <option value="已奖励" >已奖励</option>
					          <option value="未奖励" >未奖励</option>
						    </select>
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>奖励日期：</td>
					    <td class="inquire_form6"><input type="text" id="reward_date" name="reward_date" class="input_width" readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(reward_date,tributton3);" />&nbsp;</td>
					    <td class="inquire_item6"><font color="red">*</font>奖励金额：</td>
					    <td class="inquire_form6"><input type="text" id="reward_money" name="reward_money" class="input_width" /></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">奖励级别：</td>
					    <td class="inquire_form6"><input type="text" id="reward_level" name="reward_level" class="input_width" /></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_item6"></td>
					  </tr>				    
					</table>
					</form>
				</div>
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
		cruConfig.queryStr = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_danger t left join comm_org_subjection os1 on t.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on t.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on t.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0' where t.bsflag='0' order by t.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/danger/danger_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/danger/danger_list.jsp";
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
			var dangerName = document.getElementById("dangerName").value;
				if(dangerName!=''&&dangerName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_danger t left join comm_org_subjection os1 on t.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on t.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on t.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0' where t.bsflag='0' and t.danger_name like '%"+dangerName+"%' order by t.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/danger/danger_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("dangerName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "viewDanger", "hse_danger_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "viewDanger", "hse_danger_id="+ids);
		}
		debugger;
		document.getElementById("hse_danger_id").value =retObj.map.hseDangerId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("fourth_org").value =retObj.map.fourthOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org2").value =retObj.map.fourthOrgName;
		document.getElementById("danger_name").value =retObj.map.dangerName;
		document.getElementById("danger_type").value = retObj.map.dangerType;
		document.getElementById("danger_level").value = retObj.map.dangerLevel;
		document.getElementById("danger_big").value = retObj.map.dangerBig;
		document.getElementById("danger_midd").value = retObj.map.dangerMidd;
		document.getElementById("danger_place").value = retObj.map.dangerPlace;
		document.getElementById("danger_date").value = retObj.map.dangerDate;
		document.getElementById("danger_effect").value = retObj.map.dangerEffect;
		document.getElementById("danger_des").value = retObj.map.dangerDes;
		document.getElementById("modify_type").value = retObj.map.modifyType;
		document.getElementById("modify_person").value = retObj.map.modifyPerson;
		document.getElementById("modify_check").value = retObj.map.modifyCheck;
		document.getElementById("modify_step").value = retObj.map.modifyStep;
		document.getElementById("modify_time").value = retObj.map.modifyTime;
		document.getElementById("modify_project").value = retObj.map.modifyProject;
		document.getElementById("modify_no_reason").value = retObj.map.modifyNoReason;
		document.getElementById("reward_type").value = retObj.map.rewardType;
		document.getElementById("reward_level").value = retObj.map.rewardLevel;
		document.getElementById("reward_money").value = retObj.map.rewardMoney;
		document.getElementById("reward_date").value = retObj.map.rewardDate;
		
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/danger/addDanger.jsp");
		
	}
//	function toAdd1(){
//		var hse_danger_id = document.getElementById("hse_danger_id").value;
//		popWindow("<%=contextPath%>/hse/danger/addDangerModify.jsp?hse_danger_id="+hse_danger_id);
		
//	}
//	function toAdd2(){
//		var hse_danger_id = document.getElementById("hse_danger_id").value;
//		popWindow("<%=contextPath%>/hse/danger/addDangerReward.jsp?hse_danger_id="+hse_danger_id);
//		
//	}
	
	function toEdit(){  
		debugger;
		var hse_danger_id = document.getElementById("hse_danger_id").value;
	  	if(hse_danger_id==''||hse_danger_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/viewDanger.srq?hse_danger_id="+hse_danger_id);
	} 
	
	function toEdit0(){  
		if(checkText0()){
			return;
		};
		var hse_danger_id = document.getElementById("hse_danger_id").value;
		var form0 = document.getElementById("form0");
		form0.action="<%=contextPath%>/hse/editDangerInfo.srq?hse_danger_id="+hse_danger_id;
		form0.submit();
	} 
	function toEdit1(){  
		if(checkText1()){
			return;
		};
		var hse_danger_id = document.getElementById("hse_danger_id").value;
		var form1 = document.getElementById("form1");
		form1.action="<%=contextPath%>/hse/editDangerModify.srq?hse_danger_id="+hse_danger_id;
		form1.submit();
	} 
	function toEdit2(){  
		if(checkText2()){
			return;
		};
		var hse_danger_id = document.getElementById("hse_danger_id").value;
		var form2 = document.getElementById("form2");
		form2.action="<%=contextPath%>/hse/editDangerReward.srq?hse_danger_id="+hse_danger_id;
		form2.submit();
	} 
	

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteDanger", "hse_danger_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/danger/danger_search.jsp");
	}
	
	function checkText0(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var danger_name=document.getElementById("danger_name").value;
		var danger_level=document.getElementById("danger_level").value;
		var danger_date=document.getElementById("danger_date").value;
		var danger_type=document.getElementById("danger_type").value;
		var danger_place=document.getElementById("danger_place").value;
		var danger_big = document.getElementById("danger_big").value;
		var danger_midd = document.getElementById("danger_midd").value;
		
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		if(danger_name==""){
			alert("隐患名称不能为空，请填写！");
			return true;
		}
		if(danger_level==""){
			alert("隐患级别不能为空，请选择！");
			return true;
		}
		if(danger_date==""){
			alert("上报日期不能为空，请填写！");
			return true;
		}
		if(danger_type==""){
			alert("隐患类型不能为空，请填写！");
			return true;
		}
		if(danger_place==""){
			alert("作业场所不能为空，请填写！");
			return true;
		}
		if(danger_big==""){
			alert("危害因素大类不能为空，请填写！");
			return true;
		}
		if(danger_midd==""){
			alert("危害因素中类不能为空，请填写！");
			return true;
		}
		return false;
	}
	
	function checkText1(){
		var modify_time=document.getElementById("modify_time").value;
		var modify_type=document.getElementById("modify_type").value;
		var modify_person=document.getElementById("modify_person").value;
		var modify_check=document.getElementById("modify_check").value;
		var modify_step=document.getElementById("modify_step").value;
		var modify_project=document.getElementById("modify_project").value;
		var modify_no_reason=document.getElementById("modify_no_reason").value;
		if(modify_time==""){
			alert("整改日期不能为空，请填写！");
			return true;
		}
		if(modify_type==""){
			alert("整改状态不能为空，请选择！");
			return true;
		}
		if(modify_person==""){
			alert("整改负责人不能为空，请填写！");
			return true;
		}
		if(modify_check==""){
			alert("整改验证人不能为空，请填写！");
			return true;
		}
		if(modify_step==""){
			alert("整改措施不能为空，请填写！");
			return true;
		}
		if(modify_project==""){
			alert("整改计划不能为空，请填写！");
			return true;
		}
		if(modify_no_reason==""){
			alert("未整改原因不能为空，请填写！");
			return true;
		}
		return false;
	}
	
	
	function checkText2(){
		debugger;
		var reward_type=document.getElementById("reward_type").value;
		var reward_date=document.getElementById("reward_date").value;
		var reward_money=document.getElementById("reward_money").value;
		if(reward_date==""){
			alert("奖励日期不能为空，请填写！");
			return true;
		}
		if(reward_type==""){
			alert("奖励状态不能为空，请填写！");
			return true;
		}
		if(reward_money==""){
			alert("奖励金额不能为空，请填写！");
			return true;
		}
		return false;
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

