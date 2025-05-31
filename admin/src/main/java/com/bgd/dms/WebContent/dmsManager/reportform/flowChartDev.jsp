<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@ include file="/common/rptHeader.jsp" %>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
 	
	 Calendar c1 = Calendar.getInstance();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	 
	String str="";
	String start_date =request.getParameter("start_date");
	String end_date =request.getParameter("end_date"); 
	String sub_id=request.getParameter("sub_id"); 
	String sub_id1=user.getSubOrgIDofAffordOrg();
	if(sub_id==null||sub_id.equals("")){
	sub_id=user.getSubOrgIDofAffordOrg();
	}
	if(start_date==null||start_date.equals("")){
	 Calendar cal = Calendar.getInstance();
     cal.setTime(new Date());
     cal.add(Calendar.MONTH, -1);
	start_date=new SimpleDateFormat("yyyy-MM").format( cal.getTime())
				+ "-01";
	} 
	if( end_date==null||end_date.equals("")){
	end_date=new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	} 
	str=str+"sub_id="+sub_id+"%";
	str=str+";startdate="+start_date;
	str=str+";enddate="+end_date;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
 	<%@include file="/common/include/quotesresource.jsp"%>
	<title>设备需求计划</title>
</head>
<body style="background:white" onload="setDate()">
	  <div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		      		<td class="ali_cdn_name">所属单位：</td>
		      		<td class="ali_cdn_input">
		      		<select id='s_org_id_wutan'  >
								<%
									if("C105".equals(sub_id1)){
								%>
									<option value="">--请选择--</option>
								<%
									}
									if("C105".equals(sub_id1)){
										for(int i=0;i<DevUtil.orgNameList.size();i++){
											String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
								%>
											<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
								<%
										}
									}else{
										for(int i=0;i<DevUtil.orgNameList.size();i++){
											if(DevUtil.orgNameList.get(i).indexOf(sub_id1)>=0){
												String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
								%>
									<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
								<%
											}
										}
									}
								%>
								</select>
		      		</td>
					<td class="ali_cdn_name">开始时间：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input name="start_date" id="start_date"   class="input_width easyui-datebox" type="text"  style="width:268px" editable="false" required/>
			 	    </td> 
			 	    <td class="ali_cdn_name">结束时间：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input name="end_date" id="end_date" class="input_width easyui-datebox" type="text"  style="width:268px" editable="false" required/>
			 	    </td> 
					<td class="ali_query">
					   <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
					</td>
	
				    <td>&nbsp;</td>
				</tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
     </div>  
	<div id="table_box">	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="rtab_info">
	  <tr>
	    <td align="left">     
	       
	      <a href="#" onClick="report1_saveAsExcel();return false;"><%=excelImage%></a>
	     
	    </td>
	  </tr>
	</table>
		<table align="center"  id="90" >
			<tr align="center" >
		    	<td align="center" >
			  		<report:html name="report1"
	        			reportFileName="/flowChart/demanFlowChartdev.raq"
	        			params="<%=str%>"
		   				needScroll="yes"
		   				scrollWidth="100%"
		   				scrollHeight="100%"	
		   				saveAsName="设备需求计划" 
		   				  />
				</td>
	 		</tr>
		</table>
	</div>
</body>
<script type="text/javascript">
 		function simpleSearch(){
		var start_date=$('#start_date').datebox('getValue');
		var end_date=$('#end_date').datebox('getValue');
		var sub_id=$('#s_org_id_wutan').val();
		if(!start_date){
			alert('请选择开始时间');
			return;
		}
		if(!end_date){
			alert('请选择结束时间');
			return;
		}
		if(end_date<start_date){
			alert("开始时间不能大于结束时间!");
			return;
		}
		window.location="<%=contextPath%>/dmsManager/reportform/flowChartDev.jsp?start_date="+start_date+"&end_date="+end_date+"&sub_id="+sub_id+"&flag="+new Date();
	}
	function clearQueryText(){
		$('#start_date').datebox('setValue','');
		$('#end_date').datebox('setValue','');
	}
	//默认查询当年
	function setDate(){
		$('#start_date').datebox('setValue','<%=start_date%>');
		$('#end_date').datebox('setValue','<%=end_date%>');
	}
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		 
	});
	//需求计划明细
	function showXQ(val){
	 popWindow('<%=contextPath%>/dmsManager/reportform/applyList.jsp?apply_id='+val,"880:400",'需求计划详细信息');
	}
	//采购计划明细
	function showCG(val){
	 popWindow('<%=contextPath%>/dmsManager/reportform/purcList.jsp?purc_id='+val,"880:400",'采购计划详细信息');
	}
</script>
</html>