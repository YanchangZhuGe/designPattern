<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	//钻取的类别信息
	String code = request.getParameter("code");
	String orgsubId = request.getParameter("orgsubId");
	String proYear = request.getParameter("proYear");
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
								href="#"></a></span><a href="#" id="_titleinfo">现场维修费用钻取信息</a>
								<span class="gd"><a href="#"></a></span>
								<span class="dc" style="float:right;margin-top:-4px;">
									<a href="#" onclick="exportDataDoc()" title="导出excel"></a>
								</span>
								</div>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
		
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
    var exportFlag='';
    var devaccid='';
	cruConfig.contextPath =  "<%=contextPath%>";
	function getFusionChart(){
		var codenamesql = "select coding_name from comm_coding_sort_detail where coding_code_id='<%=code%>'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+codenamesql);
		var datas = queryRet.datas;
		var codingname = datas[0].coding_name;
		$("#_titleinfo").text("现场维修费用钻取信息<"+codingname+">");
		showFusionInfo();
	}
	function showFusionInfo(){
		//直接以表格的方式展现
		var retObj2 = jcdpCallService("DevCommInfoSrv","getWxDrillForPopWutan","code=<%=code%>&orgsubId=<%=orgsubId%>&drillLevel=1&proYear=<%=proYear%>");
		var dataXml2 = retObj2.dataXML;
		$("#chartContainer2").empty();
		$("#chartContainer2").append(dataXml2);
		//现场维修费用钻取信息-设备类型 
		exportFlag='xcwxfyzqxxsblx';
	}
	function drillWxDrillForSingle(obj){
		//直接以表格的方式展现
		var retObj2 = jcdpCallService("DevCommInfoSrv","getWxDrillForPopWutanSingle","code=<%=code%>&orgsubId=<%=orgsubId%>&devaccid="+obj+"&drillLevel=1");
		var dataXml2 = retObj2.dataXML;
		$("#chartContainer2").empty();
		$("#chartContainer2").append(dataXml2);
		//现场维修费用钻取信息-设备信息
		exportFlag='xcwxfyzqxxsbxx';
		devaccid=obj;
	}
	function exportDataDoc(){
		var orgsubId="<%=orgsubId%>";
		if(""==orgsubId){
			orgsubId="C105";//东方公司
		}
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		if("xcwxfyzqxxsblx"==exportFlag){
			submitStr = "code=<%=code%>&orgsubId="+orgsubId+"&proYear=<%=proYear%>&exportFlag="+exportFlag;
		}
		if("xcwxfyzqxxsbxx"==exportFlag){
			submitStr = "code=<%=code%>&orgsubId="+orgsubId+"&devaccid="+devaccid+"&proYear=<%=proYear%>&exportFlag="+exportFlag;
		}
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
</script>
</html>

