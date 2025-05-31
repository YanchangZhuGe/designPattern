<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	String wx_ids=request.getParameter("selectWzId");//唯一关联
	if(null==wx_ids){
		wx_ids="";
	}
	String dev_acc_id = request.getParameter("dev_acc_id");//设备编码
	if(null == dev_acc_id){
		dev_acc_id = "";
	}
	String maintenance_level=request.getParameter("maintenance_level");//保养级别
	if(null==maintenance_level){
		maintenance_level="";
	}
	String projectInfoNo=user.getProjectInfoNo();
	//保存结果 1 保存成功
		ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
		String info = null;
		if(respMsg!=null&&respMsg.getValue("info") != null){
			info = respMsg.getValue("info");
		}
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title></title>
<style type="text/css">
#new_table_box_bg_new {
width:auto;
height:400px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
#new_table_box {
width:auto;
height:670px;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="load()">
<form name="form1" id="form1" method="post" action="">
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<div id="new_table_box" style="width: 100%">
		<div id="new_table_box_content" style="width: 100%;height:470px;">
			<div id="new_table_box_bg_new" style="width: 95%">
				<fieldset>
					<legend>保养项目</legend>
					<div style="height: 350px; overflow: auto">
						<table width="120%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  	<tbody id="OPERATOR_body"></tbody>
						</table>
					</div>
				</fieldset>
			</div>
			<div id="oper_div">
				<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
		</div>
	</div>
 </form>
</body>
<script type="text/javascript">
	function frameSize() {
		setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
/**页面加载的时候调用,先查询项目**/
function load(){
	var wx_ids='<%=wx_ids%>';
	var maintenance_level='<%=maintenance_level%>';
	var dev_acc_id = '<%=dev_acc_id%>'
	//先查询详情表，详情表中没有数据再查询项目定义表
	var baseDataDetail = jcdpCallService("DevInsSrv", "getByItemDetail", "wx_ids="+wx_ids+"&by_level="+maintenance_level);
	if(baseDataDetail.byItemList!=undefined){
		$("#OPERATOR_body").html("");
		var innerhtml="";
		for (var i = 0; i < baseDataDetail.byItemList.length; i++) {
			//动态新增表格
			innerhtml +="<tr id = tr>";
			innerhtml +="<td>"+baseDataDetail.byItemList[i].itemcode+"</td>";
			innerhtml += "<td><span>"+baseDataDetail.byItemList[i].itemname +"</span>";
			innerhtml += "<input type='checkbox' id='byxm"+i+"' value='"+baseDataDetail.byItemList[i].itemid+"'  "+baseDataDetail.byItemList[i].selectflag+"  name='byxm'/></td>";
			innerhtml += "<td>备注：<input type='text' id='ycbz"+i+"' value='"+baseDataDetail.byItemList[i].ycbz+"' name='ycbz' /></td>";
			innerhtml +='</tr>';
		}
		$("#OPERATOR_body").append(innerhtml);
	}else {//查询基础数据表
		var baseData = jcdpCallService("DevZcjByItemSrv", "getByItemMuti", "wx_ids="+wx_ids+"&by_level="+maintenance_level+"&dev_acc_id="+dev_acc_id);
		if(baseData.byItemList!=undefined){
			$("#OPERATOR_body").html("");
			var innerhtml="";
			for (var i = 0; i < baseData.byItemList.length; i++) {
				//动态新增表格
				innerhtml +="<tr id = tr>";
				innerhtml +="<td>"+baseData.byItemList[i].itemcode+"</td>";
				innerhtml += "<td><span>"+baseData.byItemList[i].itemname +"</span>";
				innerhtml += "<input type='checkbox' id='byxm"+i+"' value='"+baseData.byItemList[i].itemid+"' name='byxm' /></td>";
				innerhtml += "<td>备注：<input type='text' id='ycbz"+i+"' value='' name='ycbz'/></td>";
				innerhtml +='</tr>';
			}
			$("#OPERATOR_body").append(innerhtml);
		}
	}
}
function submitInfo(){
	//保留的行信息
	var wx_ids='<%=wx_ids%>';
	var maintenance_level='<%=maintenance_level%>';
	var count = 0;
	var line_infos ="";
	var select_infos ="";
	var ycbz = "";
	var ycbzs = "";
	var nullflag= false;
	$("input[type='checkbox'][name='byxm']").each(function(){
		//id 、value、checked三个字段
		//if(this.checked){
			ycbz = document.getElementById("ycbz"+count).value;
			/* if((!this.checked)&&ycbz==""){
				if(confirm("不保养项目未填写备注，是否继续提交?")){
				}else{
					document.getElementById("ycbz"+count).style.border = "1px solid red";
					document.getElementById("ycbz"+count).focus();
					nullflag = true;
					return;
				}
			} */
			if(count == 0){
				line_infos = this.value;
				select_infos = this.checked?'checked':'';
				ycbzs=ycbz;
			}else{
				line_infos += "~"+this.value;
				select_infos += this.checked?'~checked':'~';
				ycbzs += "~"+ycbz;
			}
			count++;
		//}
	});
	if(nullflag){
		return;
	}
	if(count == 0){
		alert('请录入设备保养维修信息！');
		return;
	}
	var submitStr = "line_infos="+line_infos+"&select_infos="+select_infos+"&wx_ids="+wx_ids+"&by_level="+maintenance_level+"&ycbzs="+ycbzs;
	var retObject = jcdpCallService("DevInsSrv","saveByItemDetail",submitStr);
	window.returnValue = "true";
	alert('保存成功');
	newClose();
}
function newClose(){
	  window.close();
}
</script>
</html>