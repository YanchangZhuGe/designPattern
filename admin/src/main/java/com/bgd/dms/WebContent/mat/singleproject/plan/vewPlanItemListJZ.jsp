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
		String projectType = user.getProjectType();

		String plan_id = request.getParameter("plan_id");
		
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

<body  onload="" class="odd_odd">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
			<input type='hidden' name = 'submite_number' id = 'submite_number' value=''/>
				<div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						   <tr>
						  	<td class="inquire_item4"><font color="red">*</font>计划编号</td>
						   	<td class="inquire_form4"><input name="plannum" id="plannum" type="text" class="input_width" value=""/>
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
 							<td class="inquire_item4">金额:</td>
						   	<td class="inquire_form4"><input name="total_money" id="total_money" type="text" class="input_width" value="" readonly="readonly"/>
						   	</td>
						   	</tr>
					</table>
					</div>  
				<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    
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
			<div id="" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{coding_code_id}">分类编码</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
			       <td class="bt_info_odd" exp="<input name='wz_price_{wz_id}'  type='text' value='{wz_price}'/>">参考单价</td>
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


	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "findPlanLeaf";
	var obj = "";
	var val = "";
	
	onLoad();
	refreshData();
	loadDataDetail();
    getApplyTeam(obj);
    getConRatio(val);
	
	function refreshData(){
		cruConfig.submitStr ="value="+document.getElementById("submite_number").value;
		queryData(1);
	}
	
       function getApplyTeam(val){
    	   var selectObj = document.getElementById("s_apply_team"); 
	    	document.getElementById("s_apply_team").innerHTML="";

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
       function loadDataDetail(shuaId){
   		var tab =document.getElementById("queryRetTable");
   		var outNum=0;
   		var wzPrice=0;
   		var totalMoney=0;
   		var row = tab.rows;
   		for(var i=1;i<row.length;i++){
   			var cell_6 = row[i].cells[6].firstChild.value;
   			var cell_7 = row[i].cells[7].firstChild.value;
   			if(row[i].cells[0].firstChild.checked==true){
	   			if(cell_6!=undefined && cell_7!=undefined){
	   				
	   					if(cell_6=='&nbsp;'){
	   						outNum=0;
	   						}
	   					else{
	   						outNum=cell_6;
	   						}
	   					
	   					if(cell_7==""){
	   						wzPrice=0;
	   						}
	   					else{
	   						wzPrice=cell_7;
	   						}
	   					
	   				row[i].cells[8].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
	   				totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
	   			}
   			}
   		}
   		document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;;
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
		 function onLoad(){
			 var checkSql="select * from gms_mat_demand_plan_bz t where t.bsflag='0' and t.submite_number='<%=plan_id%>'";
			   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas==null||datas==""){
				}else{
					document.getElementById("submite_number").value = datas[0].submite_number;
					document.getElementById("plannum").value = datas[0].submite_id;
					document.getElementById("total_money").value = datas[0].total_money;
					obj = datas[0].s_apply_team;
					val = datas[0].plan_type;
					
			    }
			 
		 }
		 
</script>

</html>

