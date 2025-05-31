<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	//震源编号
	//self_num='+self_num+"&coding_code_id="
	//+coding_code_id+"&project_info_id="+project_info_id+"&start_date="+start_date+"&end_date="+start_end
	String self_num = request.getParameter("self_num");
	String project_info_id = request.getParameter("project_info_id");
	String start_date=request.getParameter("start_date");
	String end_date=request.getParameter("end_date");
	String coding_code_id=request.getParameter("coding_code_id");
	IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
    String sql="select t.project_name from gp_task_project  t where t.project_info_no='"+project_info_id+"'";
    Map map=pureJdbcDao.queryRecordBySQL(sql);
    String project_name=map.get("project_name").toString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="99%">
							<div class="tongyong_box">
								<div class="tongyong_box_title"><span class="kb"><a
								href="#"></a></span><a href="#">单项目备件消耗明细(<%=project_name %>)</a>
								<span class="gd"><a href="#"></a></span>
								<span class="dc" style="float:right;margin-top:-4px;">
									<a href="#" onclick="exportDataDoc('dxmbjxhmx')" title="导出excel"></a>
								</span>
								</div>
								<div class="tongyong_box_content_left" id="chartContainer1" style="height: 250px;">
		
								</div>
							</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function getFusionChart(){
		var retObj = jcdpCallServiceCache("EarthquakeTeamStatistics","getZySingleWzM","project_info_id=<%=project_info_id%>&self_num=<%=self_num%>&start_date=<%=start_date%>&end_date=<%=end_date%>&coding_code_id=<%=coding_code_id%>");
		var dataXml = retObj.dataXML;
		var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" ); 
		myChart1.setXMLData(dataXml);
		myChart1.render("chartContainer1");
	}
	
	function exportDataDoc(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr = "project_info_id=<%=project_info_id%>&self_num=<%=self_num%>&start_date=<%=start_date%>&end_date=<%=end_date%>&coding_code_id=<%=coding_code_id%>&exportFlag="+exportFlag;
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
	
function popWxbyHistoryBjCForm(cb){
		var str=cb.split("~");
		var self_num=str[0];
		var project_info_id=str[1];
		var coding_code_id=str[2];
		var wz_id=str[3];
		popWindow('<%=contextPath %>/rm/dm/kkzy/popWxbyHistoryBjCForm.jsp?self_num='+self_num+"&coding_code_id="+coding_code_id+"&project_info_id="+project_info_id+"&wz_id="+wz_id,'800:600');
	}
	
	
	function popZySingleWzM(cb){
		//project_info_id+"~"+self_num+"~"+start_date+"~"+end_date+"~"+equipmentCode);
		var str=cb.split("~");
		var project_info_id=str[0];
		var self_num=str[1];
		var start_date=str[2];
		var end_date=str[3];
		var coding_code_id=str[4];
		popWindow('<%=contextPath %>/rm/dm/kkzy/popZySingleWzM.jsp?self_num='+self_num+"&coding_code_id="+coding_code_id+"&project_info_id="+project_info_id+"&start_date="+start_date+"&end_date="+start_end,'800:600');
	}
</script>
</html>

