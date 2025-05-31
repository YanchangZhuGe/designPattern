<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common/rptHeader.jsp" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%
			String path = request.getContextPath();
			ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
			UserToken user = OMSMVCUtil.getUserToken(request);
			String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
			String orgId=user.getSubOrgIDofAffordOrg();
			String weekDate = request.getParameter("weekDate");
			String weekNum = request.getParameter("weekNum");
			Calendar cal=Calendar.getInstance();
			cal.setTime(new Date());
			int week = cal.get(Calendar.DAY_OF_WEEK);
			if(week==6){
				cal.setTime(new Date());
			}
			else if(week<7&&week>1){
				cal.add(Calendar.DAY_OF_YEAR,-8-week);
			}else if(week==1){
				cal.add(Calendar.DAY_OF_YEAR,-9);
			}else{
				cal.add(Calendar.DAY_OF_YEAR,-8);
			}
			if(weekDate == null || "".equals(weekDate)){
				weekDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			}
			String subflag=resultMsg.getValue("subflag");
			String reportSubflag="1";// 报表默认只显示审批通过的
			
			if(JcdpMVCUtil.hasPermission("F_PM_WR_021", request)){//如果有审批权限,可以显示其它状态的数据
				if(subflag==null){// 没有数据
					reportSubflag="1";
				}else if(subflag.equals("0")){ // 如果报表没有提交
					reportSubflag="1";// 按照审批通过去查询，结果应该为空,不允许查看
				}else{
					reportSubflag=subflag;
				}
			}
			String params = "weekDate="+weekDate+";orgId="+orgId+";subFlag="+reportSubflag+";weekNum="+weekNum;
			//System.out.println(params);
			String recordId = resultMsg.getValue("recordId");
			if(weekNum==null)
				weekNum = "1";
			String fopUrl = path+"/fop/printFop.srq?fileType=xml&weekDate="+weekDate+"&orgId="+orgId+"&subFlag="+reportSubflag+"&weekNum="+weekNum;
			String rtfUrl = path+"/fop/convertFop.srq?fileType=rtf&weekDate="+weekDate+"&orgId="+orgId+"&subFlag="+reportSubflag+"&weekNum="+weekNum;
%>
<html>
	<head>
		<base href="<%=basePath%>">
		<title>公司主业生产经营（周）信息简报</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
	</head>
<body style="overflow-x:no;overflow-y:no;background:#fff;height: 70%;">
<form id="form1" action="<%=contextPath%>/pm/wr/getCompanyProductionInfoBySubflag.srq" method="post" class="formstyle">
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3"><font color="red">*</font>查询时间：</td>
			    <td class="ali1">
			    <input name="weekDate" id="weekDate" type="text" value="<%=weekDate%>" class="input_width" readonly/>
			    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="fridaySelector(weekDate,tributton1);"/>
			    </td>
			    <%
		    	if(JcdpMVCUtil.hasPermission("F_PM_WR_021", request)){//如果有审批权限,显示数据状态
		    	%>
			    <td class="ali3">数据状态：</td>
			    <td class="ali1" id="subflagStr">
				<%
				if(subflag==null || subflag.equals("0")){out.print("未提交");}else if (subflag.equals("2")){out.print("待审批");}else if(subflag.equals("1")){out.print("审批通过");}else{out.print("审批不通过");}
				%>
				</td>
				<%}else{ %>
		     	<td class="ali3">&nbsp;</td>
			    <td class="ali1">&nbsp;</td>
		     	<%} %>
		     	<td><span class="ck"><a href="#" onclick="tjSubmit()" ></a></span></td>
		     	<%if(JcdpMVCUtil.hasPermission("F_PM_WR_021", request) ){ //如果有审批权限
	    			if("2".equals(subflag)){// 待审批时，添加审批按钮
	    		%>
	    		<td><span class="jl"><a href="#" onclick="showAuditArea()" ></a></span></td>	
	    		<%	
	    			}
				}
	    		%>
	    		<td><span class="xz"><a href="<%=rtfUrl %>" onClick=""></a></span></td>
		     	<td><span class="fh"><a href="#" onclick="cancel()" ></a></span></td>
			  </tr>
			</table>
		</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
</table>
<table  width="100%"  border="0" cellpadding="0" cellspacing="0" class="form_info" id="FilterLayer" >
    <tr id="tr1" style="display:none;">
    	<td class="rtCRUFdName">审批意见：</td>
    	<td colspan="3" class="rtCRUFdValue">
    		<textarea rows="4" cols="" name="info"></textarea>
    	</td>
    </tr>
    <tr class="ali4" id="tr2" style="display:none;">
    	<td colspan="4">
    		<input type="button" name="audit1" value="通过"  class="iButton2" onclick="auditData('1')"/>
    		<input type="button" name="audit2" value="不通过"  class="iButton2" onclick="auditData('3')"/>
    		<input type="button" name="audit3" value="取消"  class="iButton2" onclick="hideAuditArea()"/>
        </td>
    </tr>
</table>
</form>

<iframe  frameborder="0" width="100%" style="height:520px" align="middle"  scrolling="auto" src="<%=fopUrl %>"></iframe>

<script type="text/javascript">
	
	function tjSubmit(){
		if(document.getElementById("weekDate").value == null || document.getElementById("weekDate").value == "" ){
			alert("请输入查询时间！");
			return false;
		}else{
				var dateValue=document.getElementById("weekDate").value;
				var daysArray= new Array();   
				daysArray=dateValue.split('-');   
		        var sdate=new Date(daysArray[0],parseInt(daysArray[1]-1),daysArray[2]);   
		        if(sdate.getDay()!=5){
		        alert("查询时间只能选择周五，请重新选择");
		        return false;   
		        }

		}
		document.forms[0].submit();		
	}
	function clean(){
		document.forms[0].weekDate.value = "";
	}
	function auditData(newSubflag){
		var info = document.getElementsByName("info")[0].value;
		if(info==''){
			alert('请输入审批意见');
			document.getElementsByName("info")[0].focus();
			return;
		}
		//var sql = "insert into bgp_wr_audit_info (
		var org_id = '<%=user.getCodeAffordOrgID()%>';
		var week_date = '<%=weekDate%>';
	    // 准备审批数据
    	var sql = "update bgp_wr_record set subflag='" + newSubflag + "' where org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
    	
		sql +="update BGP_WR_WORKLOAD_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update bgp_wr_acq_project_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update bgp_wr_stress_project_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update bgp_wr_sail_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='1'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='2'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='3'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_PROJECT_DYNAMIC set subflag='" + newSubflag + "' where bsflag='0' and project_type='4'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_HOLD_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_INSTRUMENT_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_INSTRUMENT_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_FOCUS_INFO set subflag='" + newSubflag + "' where bsflag='0' and country='2'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update BGP_WR_FOCUS_INFO set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update bgp_geophone_info set subflag='" + newSubflag + "' where bsflag='0'  and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";
		
		sql +="update bgp_wr_material_info set subflag='" + newSubflag + "' where bsflag='0'  and instr(org_subjection_id,'<%=user.getSubOrgIDofAffordOrg()%>')>0 and to_char(week_date,'yyyy-MM-dd')='" + week_date + "';";

		var subflagStr = "";
		if(newSubflag=='1'){
			subflagStr="审批通过";
		}else if(newSubflag=='3'){
			subflagStr="审批不通过";
		}
		
		if (!window.confirm("确认要"+subflagStr+"吗?")) {
			return;
		}
		
		var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
		var params = "sql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert("审批失败");
		else{
			// 保存审批意见
			path = '<%=contextPath%>/rad/addOrUpdateEntity.srq';
			var submitStr = 'JCDP_TABLE_NAME=bgp_wr_audit_info&JCDP_TABLE_ID=&bsflag=0&create_user=<%=user.getUserName()%>&record_id=<%=recordId%>&subflag='+newSubflag+'&info='+info;
			submitStr=encodeURI(encodeURI(submitStr));
			var retObject = syncRequest('Post',path,submitStr);
			if (retObject.returnCode != "0") alert("审批失败");
			else{
				//window.location="<%=contextPath%>/pm/wr/getCompanyProductionInfoBySubflag.srq?weekDate="+weekDate;
				document.getElementById("subflagStr").innerHTML=subflagStr;
				document.getElementsByName("audit")[0].style.display="none";
				hideAuditArea();
			}
		}
	}
	function showAuditArea(){
		document.getElementById("tr1").style.display="";
		document.getElementById("tr2").style.display="";
	}
	function hideAuditArea(){
		document.getElementById("tr1").style.display="none";
		document.getElementById("tr2").style.display="none";
	}

	function fridaySelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m-%d",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    true,
			singleClick    :    true,
			step        : 1,
			disableFunc: function(date) {
		        if (date.getDay() != 5) {
		            return true;
		        } else {
		            return false;
		        }
		    }
		    });
	}
	function cancel(){
		window.location="<%=contextPath%>/pm/wr/reportIndex.jsp";
	}
</script>
	</body>
</html>
