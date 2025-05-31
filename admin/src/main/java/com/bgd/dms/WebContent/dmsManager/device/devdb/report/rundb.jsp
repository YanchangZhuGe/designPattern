<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@ include file="/common/rptHeader.jsp"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>

<%
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgId();
	String projectInfoNo = user.getProjectInfoNo();
	String isSear=request.getParameter("isSear");
	boolean flag=false;
	if(null==isSear||"".equals(isSear)){
		flag=true;
	}
	String startDate = request.getParameter("startDate");
	String SDate="";
	if((startDate == null ||startDate.equals("") )&&flag){
		startDate = new SimpleDateFormat("yyyy-MM").format(new Date())
		+ "-01";
		SDate=startDate;

	}else if ((startDate == null ||startDate.equals("") )&&!flag){
		String startDate_sql="select to_char(min(db_date),'yyyy-mm-dd') as  min_date from dms_device_cldb_apply";
		IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
		Map  map=pureJdbcDao.queryRecordBySQL(startDate_sql);
		Object s=map.get("min_date");
		if(s==null){
	        startDate = new SimpleDateFormat("yyyy-MM").format(new Date())
			+ "-01";
	        SDate="";
		}else{
         	startDate=s.toString();
            SDate="";
		}
		
	  	
	}else if ((startDate != null &&!startDate.equals("") )&&!flag){
	      SDate=startDate;
	}
		

	String EDate="";
	String endDate = request.getParameter("endDate");
	if ((endDate == null ||endDate.equals("") )&&flag){
		endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		EDate=endDate;

	}else if ((endDate == null ||endDate.equals("") )&&!flag){
		String endDate_sql="select to_char(max(db_date),'yyyy-mm-dd') as  max_date from dms_device_cldb_apply";
		IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
		Map  map=pureJdbcDao.queryRecordBySQL(endDate_sql);
		Object s=map.get("max_date");
		if(s==null){
	           endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	           EDate="";
		}else{
	           endDate=s.toString();
	           EDate="";
		}
		
		
	}else if ((endDate != null &&!endDate.equals("") )&&!flag){
		EDate=endDate;
	}
	String org_name=request.getParameter("org_name");
	if(null==org_name||"".equals(org_name)){
		org_name="";
	}else if(null!=org_name||!"".equals(org_name)){
		org_name=java.net.URLDecoder.decode(org_name, "utf-8");
	}
	String orgId = request.getParameter("orgId");
	if (orgId == null||"".equals(orgId)){
	String sql="SELECT wmsys.wm_concat( distinct ORG_ID )   as  ORG_ID"+
			   " FROM (SELECT DB_FROM_ORG AS ORG_ID"+
			   "  FROM DMS_DEVICE_CLDB_APPLY"+
			   "   WHERE BSFLAG = '0'"+
			   "   UNION ALL"+
			   "   SELECT DB_INTO_ORG AS ORG_ID"+
			   "    FROM DMS_DEVICE_CLDB_APPLY"+
			   "   WHERE BSFLAG = '0') B";
	IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	Map  map=pureJdbcDao.queryRecordBySQL(sql);
	orgId=map.get("org_id").toString()+","+" "+",";
	}
	StringBuffer str = new StringBuffer();
	str.append("startDate=").append(startDate).append(";endDate=")
	.append(endDate).append(";org_id=").append(orgId);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<title>调拨情况统计</title>
	</head>

	<body style="overflow-x: scroll; overflow-y: scroll;" >
		<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					id="FilterLayer">
					<tr>
						<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						<td background="<%=contextPath%>/images/list_15.png">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="ali_cdn_name">单位：</td>
									<td class="ali_cdn_input">
										<input type="text" id="org_name"name="org_name" class="input_width" style="width:100px" readonly="readonly"  value="<%=org_name%>"/>
										<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: pointer;" onclick="toChoseOrg()" /> 
										<input type="hidden" id="org_id" name="org_id" value="<%=orgId%>" /></td>
									<td class="ali_cdn_name">调拨日期：</td>
									<td>
										<input id="startDate" name="startDate" type="text" class="easyui-datebox tongyong_box_title_input" editable="false"/>
										至
										<input id="endDate" name="end_date" type="text" class="easyui-datebox tongyong_box_title_input" editable="false" validType="gtStartDate['#startDate']" />
									</td>
									<td>&nbsp;</td>
									<td class="ali_query">
										<span class="cx">
											<a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a>
										</span>
									</td>
									<td class="ali_query">
										<span class="qc">
											<a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a>
										</span>
									</td>
								</tr>
							</table>
						</td>
						<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="chartContainer2" style="height: 400px;" align="left">
			<report:html 
				name="report1" 
				reportFileName="/cldb.raq"
				params="<%=str.toString()%>" 
				needSaveAsExcel="yes"
				needPrint="yes" 
				needScroll="yes" 
				scrollWidth="110%"
				scrollHeight="100%" 
				saveAsName="调拨单统计表" 
				excelPageStyle="0" />
		</div>
	</body>
	<script type="text/javascript">
		//键盘上只有删除键，和左右键好用
		function noEdit(event){
			if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
				return true;
			}else{
				return false;
			}
		}
		// 简单查询
		function simpleSearch(){
			if(!$('#endDate').datebox("isValid")){
				return;
			}
			var startDate= $("#startDate").datebox("getValue");
			var endDate= $("#endDate").datebox("getValue");
			var org_name = $("#org_name").val();
			var org_id = $("#org_id").val();
		    org_name = encodeURI(org_name);
			org_name = encodeURI(org_name); 
	        if(null==startDate){
				startDate="";
			}
	        if(null==endDate){
		        endDate="";
	        }
	        if(null==org_id){
	        	org_id="";
	        }
			window.location="<%=contextPath%>/dmsManager/device/devdb/report/rundb.jsp?startDate="+ startDate + "&endDate=" + endDate + "&orgId=" + org_id+"&isSear=isSear&org_name="+org_name;
		}
	
		function convertDate(date) {
			var year = date.getFullYear();
			var month = date.getMonth() + 1;
			var m;
			if (month < 10) {
				m = '0' + month;
			} else {
				m = month;
			}
			var day = date.getDate();
			var d;
			if (day < 10) {
				d = '0' + day;
			} else {
				d = day;
			}
			var s = year + '-' + m + '-' + d;
			return s;
		}
		function clearQueryText() {
			$("#startDate").datebox("setValue","");
			$("#endDate").datebox("setValue","");
			$("#org_name").val("");
			$("#org_id").val("");
		}
		function toChoseOrg(){
			var obj=new Object();
			var returnValue= window.showModalDialog('<%=contextPath%>/dmsManager/device/devdb/selectOrgHR.jsp',obj,'dialogWidth=512px;dialogHigth=400px');
			var orgArr=returnValue.split("~");
			$("#org_name").val(orgArr[0].split(":")[1]);
			$("#org_id").val(orgArr[1].split(":")[1]);
		}
	</script>
</html>