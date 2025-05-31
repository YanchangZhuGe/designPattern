<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
		String contextPath = request.getContextPath();

		UserToken user = OMSMVCUtil.getUserToken(request);
		String projectType = user.getProjectType();//项目类型
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>无标题文档</title>
</head>

<body  onload="refreshData()" class="odd_odd">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
			<input type='hidden' name = 'submite_number' id = 'submite_number' value='<gms:msg msgTag="matInfo" key="submite_number"/>'/>
				<div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						   <tr>
						  	<td class="inquire_item4"><font color="red">*</font>计划编号</td>
						   	<td class="inquire_form4"><input name="plannum" id="plannum" type="text" class="input_width" value="<gms:msg msgTag="matInfo" key="submite_id"/>"/>
						   	</td>
						  	<td class="inquire_item4"><font color="red">*</font>选择班组 </td>
						   	<td class="inquire_form4">
						   		<select id="s_apply_team" name="s_apply_team"  class="select_width">
						   		</select>
						   	</td>
						  </tr>
						  
						  <tr> 	
						  	<td class="inquire_item4"><font color="red">*</font>计划用途：</td>
						   	<td class="inquire_form4">
						   		<select id="plan_type" name="plan_type" class="select_width"></select>
						   	</td>
						  <!-- 					  
							<td class="inquire_item4">是否自采购：</td>
						   	<td class="inquire_form4">
						   		<select id="if_purchase" name="if_purchase" class="select_width">
						   		<option value='0'>是</option>
							  	<option value='1' selected='selected'>否</option>
						   		</select>
						   	</td>
						 
						  	<td class="inquire_item4">倍数：</td>
						   	<td class="inquire_form4"><input name="times" id="times" type="text" class="input_width" value=""/>
						   	<button type="button" onclick='getTimes()' class="button_width">提交</button>
						   	</td>
						  </tr>
						  <tr>
 -->						<td class="inquire_item4">金额:</td>
						   	<td class="inquire_form4"><input name="total_money" id="total_money" type="text" class="input_width" value="<gms:msg msgTag="matInfo" key="total_money"/>" readonly="readonly"/>
						   	</td>
						   	</tr>
						   	<!-- 
						   	<tr>
						   	<td class="inquire_item4">计划用途：</td>
						   	<td class="inquire_form4">
						   		<select id="plan_type" name="plan_type" class="select_width">
						   		</select>
						   	</td>
						  </tr>
						   -->
					</table>
					</div>  
				<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    
			     <td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    </td>
			    <td><auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton></td>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="list_table">
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{coding_code_id}">分类编码</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
			       <td class="bt_info_odd" exp="<input name='wz_price_{wz_id}'  type='text' value='{wz_price}'/>">参考单价</td>
			       <td class="bt_info_even" exp="{stock_num}" >库存</td>  
			      <td class="bt_info_even" exp="<input name='demand_num_{wz_id}'  type='text' value='{demand_num}'/>" >需求数量</td>
			      <td class="bt_info_odd" exp="<input name='demand_money_{wz_id}'  type='text' value='{demand_money}' readonly/>" >金额</td>
			      <td class="bt_info_even" exp="<input name='demand_date_{wz_id}' id='demand_date_{wz_id}' type='text' value='{demand_date}'/><img src='<%=contextPath%>/images/calendar.gif'id='tributton_{wz_id}' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(demand_date_{wz_id},tributton_{wz_id});'/>" >需求日期 </td>
			      <td class="bt_info_odd" exp="<input name='note_{wz_id}'  type='text' value='{note}' />" >备注</td>
			    </tr>
			  </table>
			  </div>
			<table id="fenye_box_table">
			</table>
			</div>
			</div>
<div id="oper_div">
<span class="bc_btn"><a href="#"onclick="save()"></a></span> 
<span class="gb_btn"><a href="#"onclick="newClose()"></a></span>
</div>
</div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>		  
</body>
<script type="text/javascript">
$("#t_d").hide();
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
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

	var projectType = "<%=projectType%>";//项目类型
//	projectType ="5000100004000000009"; //测试 
	/************ start **************/
	
	if(projectType=="5000100004000000009"){
		//综合物化探
		var s_apply_team = document.getElementById("s_apply_team");
		s_apply_team.disabled = true; 
	}
	/************ end **************/



	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "findRepPlanLeaf";
	var submiteNumber = "<gms:msg msgTag="matInfo" key="submite_number"/>";
	function refreshData(){
		cruConfig.submitStr ="value="+submiteNumber;
		queryData(1);
		//document.getElementById("if_purchase").value = "<gms:msg msgTag="matInfo" key="if_purchase"/>";
		var obj = "<gms:msg msgTag="matInfo" key="s_apply_team"/>";
		var val = "<gms:msg msgTag="matInfo" key="plan_type"/>";
	    getApplyTeam(obj);
	    getConRatio(val);
	}
	function toDelete(){
		 ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				if(confirm('确定要删除吗?')){  
					var retObj = jcdpCallService("MatItemSrv", "deletePlanList", "matId="+ids+"&submiteNumber="+submiteNumber);
					queryData(cruConfig.currentPage);
				}
				}
	}
	
       function getApplyTeam(val){
    	   var selectObj = document.getElementById("s_apply_team"); 
	    	document.getElementById("s_apply_team").innerHTML="";

//	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
	    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
	    		var templateMap = applyTeamList.detailInfo[i];
	    		if(templateMap.value == val){
					selectObj.add(new Option(templateMap.label,templateMap.value),0);
					}
	    		else{
					selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	    		}
	    	}  
	    	selectObj.add(new Option("储备","CB001"),applyTeamList.detailInfo.length+1);
	    	selectObj.add(new Option("配件","PJ001"),applyTeamList.detailInfo.length+2); 	
	    	selectObj.options[0].selected='selected';
	    }
       function toAdd(trid){
			var obj = new Object();
			var ids=getSelIds('rdo_entity_id');
			var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/singleproject/plan/repMatPlan/selectRepMatList.jsp?ids='+ids+'&submiteNumber='+submiteNumber,obj,'dialogWidth=1024px;dialogHigth=400px');
			if(vReturnValue!=undefined){
				refreshData();
				}
		}
       function save(){	
	   	   if(checkText()){
				return;
			};
   		ids = getSelIds('rdo_entity_id');
   			if (ids == '') {
   				alert("请选择一条记录!");
   				return;
   			}
   			else{
   				if(loadDataDetail()){
   					openMask();
		  		document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/plan/updateRepPlan.srq?laborId="+ids;
		  		document.getElementById("form1").submit();
   				}
   			}
   	} 
       function loadDataDetail(shuaId){
    	   var tab =document.getElementById("queryRetTable");
   		var totalMoney=0;
   		var outNum=0;
   		var wzPrice=0;
   		var totalMoney=0;
   		var row = tab.rows;
   		var flag = true;
   		var obj = event.srcElement;
   		if(obj.tagName.toLowerCase() =='td'){
   			var tr = obj.parentNode;
   			selectIndex = tr.rowIndex;
   		}else if(obj.tagName.toLowerCase() =='input'){
   			var tr = obj.parentNode.parentNode;
   			selectIndex = tr.rowIndex;
   		}debugger;
   		for(var i=1;i<row.length;i++){
   			var cell_6 = row[i].cells[6].firstChild.value;
   			var cell_8 = row[i].cells[8].firstChild.value;
   			var cell_7 = row[i].cells[7].innerHTML;
   			if(row[i].cells[0].firstChild.checked==true){
   				if(cell_6!=undefined && cell_8!=undefined){
   					
   						if(cell_6=='&nbsp;'){
   							outNum=0;
   							}
   						else{
   							outNum=cell_6;
   							}
   						if(cell_8==""){
   							wzPrice=0;
   							}
   						else{
   							wzPrice=cell_8;
   							}
   						if(Number(wzPrice)>Number(cell_7)){
   							alert("需求数量不能大于库存数量!");
   							flag = false;
   							return;
   						}
   					row[i].cells[9].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
   					totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
   				}
   			}
   		}
   		document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
   		return flag;
   	}
       var checked = false;
		 function check(){
		 		var chk = document.getElementsByName("rdo_entity_id");
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
		 function openMask(){
				$( "#dialog-modal" ).dialog({
					height: 140,
					modal: true,
					draggable: false
				});
			}
		 function getConRatio(value){
				var selectObj = document.getElementById("plan_type"); 
		    	document.getElementById("plan_type").innerHTML="";

		    	var retObj=jcdpCallService("MatItemSrv","queryConRatio","");	
		    	var taskList = retObj.matInfo;
		    	for(var i =0; taskList!=null && i < taskList.length; i++){
			    	if(taskList[i].value ==value){
			    		selectObj.add(new Option(taskList[i].lable,taskList[i].value),0);
				    	}
			    	else{
						selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
			    	}
		    	}
		    	selectObj.options[0].selected='selected';
				}
		 function getTimes(){
				var tab =document.getElementById("queryRetTable");
				var row = tab.rows;
				for(var i=1;i<row.length;i++){
					var cell_8 = row[i].cells[7].firstChild.value;
					var times = document.getElementById("times").value;
					if(cell_8!=undefined){
							if(cell_8=='&nbsp;'){
								cell_8=0;
								row[i].cells[8].firstChild.value = cell_8*times;
								}
							else{
								row[i].cells[8].firstChild.value = cell_8*times;
								}
						
				}
				}
			}
		 
		 function checkText(){

			 	/************ start **************/
				if(projectType!="5000100004000000009"){
					//综合物化探
					var s_apply_team = document.getElementById("s_apply_team").value;
					if(s_apply_team==""){
						alert("班组不能为空,请选择班组!");
						return true;
					}
				}
				/************ end **************/
				
				var plannum=document.getElementById("plannum").value;
				
				if(plannum==""){
					alert("计划编号不能为空，请填写！");
					return true;
				}
				
				return false;
			}
</script>

</html>

