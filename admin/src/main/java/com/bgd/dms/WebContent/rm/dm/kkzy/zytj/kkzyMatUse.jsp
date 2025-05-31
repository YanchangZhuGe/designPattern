<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.List"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@include file="/common/rptHeader.jsp"%>
<%@taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	//震源编号  消耗日期   项目名称  消耗类别  累计工作小时  物资名称
	//String contextPath = request.getContextPath();
	String startDate = new SimpleDateFormat("yyyy").format(new Date())+ "-01-01";
	String endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	
	String bywx_date_begin=request.getParameter("bywx_date_begin");
	if(null==bywx_date_begin||"".equals(bywx_date_begin)){
		 bywx_date_begin=startDate;
	}
	
	String bywx_date_end=request.getParameter("bywx_date_end");
	if(null==bywx_date_end||"".equals(bywx_date_end)){
		 bywx_date_end=endDate;
	}
	IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	String project_info_id = request.getParameter("project_info_id");
	
	if(null==project_info_id||"".equals(project_info_id)){
		String sql = "select wmsys.wm_concat(project_info_no) as ids  from gp_task_project p   "
				   	+ " where project_info_no in ( select wx.project_info_id from gms_device_zy_bywx  wx where wx.bsflag='0' and wx.bywx_date >= to_date('"
					+ bywx_date_begin
					+ "', 'yyyy-mm-dd')"
					+ "and wx.bywx_date <= to_date('"
					+ bywx_date_end
					+ "', 'yyyy-mm-dd')) and p.bsflag='0'";
		Map map = pureJdbcDao.queryRecordBySQL(sql);
		String ids = map.get("ids").toString();
		
		project_info_id = ids+",0";
	}
	String work_hours_begin=request.getParameter("work_hours_begin");
	if(null==work_hours_begin||"".equals(work_hours_begin)){
		work_hours_begin="0";
		request.setAttribute("work_hours_begin", "0");
	}
	String work_hours_begin_show=work_hours_begin;
	String work_hours_end=request.getParameter("work_hours_end");
	if(null==work_hours_end||"".equals(work_hours_end)){
		work_hours_end="999999999";
		request.setAttribute("work_hours_end", "");
	}else if("999999999".equals(work_hours_end)){
		work_hours_end="999999999";
		request.setAttribute("work_hours_end", "");
	}
	String work_hours_end_show=work_hours_end.equals("999999999")==true?"":work_hours_end;
	String self_num=request.getParameter("self_num");
	if(null==self_num||"".equals(self_num)){
		String sql1="select self_num from gms_device_account t where t.dev_type like 'S06230101%' and t.bsflag='0' and t.self_num is not null and (t.ifcountry='国内' or t.ifcountry is null )";
		List<Map>  list=pureJdbcDao.queryRecords(sql1);
		
		for(int i = 0; i < list.size(); i++) {
		    Map s = list.get(i);
		    self_num += s.get("self_num").toString()+ ",";
		}
		self_num = self_num.substring(0, self_num.lastIndexOf(","));
	}else{
		if(self_num.indexOf(",")>0){
			self_num=self_num+self_num;
			self_num = self_num.substring(0, self_num.lastIndexOf(","));
		}else{
			String sql1="select self_num   from gms_device_account t where   t.dev_type  like 'S06230101%' and t.bsflag='0' and t.self_num like '%"+self_num+"%' ";
			List<Map>  list=pureJdbcDao.queryRecords(sql1);
			self_num="";
			for(int i = 0; i < list.size(); i++) {
				Map s = list.get(i);
				self_num += s.get("self_num").toString()+ ",";
			}
		}
	}
	String xhtype=request.getParameter("xhtype");
	
	if("".equals(xhtype)||null==xhtype){
		 xhtype = "0";
	}
	String oldxhtype=xhtype;
	if(xhtype.equals("0")){
	   xhtype = "1,2";
	}else if(xhtype.equals("1")){
	   xhtype = "1";
	}else if(xhtype.equals("2")){
       xhtype = "2";
	}
	
	String openType=request.getParameter("openType");
	if(openType==null||"".equals(openType)){
		openType="0";
	}
	String wz_name=request.getParameter("wz_name");
	if(wz_name==null||"".equals(wz_name)){
		wz_name="";
	}else{
		wz_name=java.net.URLDecoder.decode(wz_name, "utf-8");
	}
	self_num=self_num.replaceAll("null", "");
	String byjb=request.getParameter("byjb");
	if(null==byjb||"".equals(byjb)){
		byjb="B,C,D,无";
	}else  if(null!=byjb&&!"".equals(byjb)){
		byjb=byjb+byjb;
		byjb=byjb.substring(0,byjb.lastIndexOf(","));
	}
	
	String wz_id=request.getParameter("wz_id");
	String showWzName="";
	if(null==wz_id||"".equals(wz_id)){
		showWzName="yes";
		IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
		String sql="select r.wz_id from gms_device_zy_bywx t,gms_device_zy_wxbymat w,gms_mat_recyclemat_info r where t.usemat_id=w.usemat_id and t.bsflag='0' and w.wz_id=r.wz_id and r.wz_type='3' and r.bsflag='0'";
		List<Map> list=jdbcDao.queryRecords(sql);
		Set<String> wzIdSet=new HashSet<String>();
		if(list==null){
			list=new ArrayList<Map>();
		}
		wz_id="";
		for(Map  map:list){
			wzIdSet.add(map.get("wz_id").toString());
		}
		Iterator<String> iter=	wzIdSet.iterator();
		while(iter.hasNext()){
			wz_id+=iter.next()+",";
		}
	}else if(null!=wz_id&&!"".equals(wz_id)){
		showWzName="no";
		String[] strs=wz_id.split(",");
		if(strs!=null&&strs.length<=2){
			wz_id=wz_id+wz_id;
		}
		wz_id=wz_id.substring(0,wz_id.lastIndexOf(","));
	}
	String showSelfNum=request.getParameter("showSelfNum");
	if(null==showSelfNum||"".equals(showSelfNum)){
		showSelfNum="";
	}
	
	String selfSeleHtml=request.getParameter("selfSeleHtml");
	if(null==selfSeleHtml||"".equals(selfSeleHtml)){
		selfSeleHtml="";
	}
	String projectHtml=request.getParameter("projectHtml");
	if(null==projectHtml||"".equals(projectHtml)){
		projectHtml="";
	}else{
		projectHtml=java.net.URLDecoder.decode(projectHtml, "utf-8");
	}
	String wzHtml=request.getParameter("wzHtml");
	if(null==wzHtml||"".equals(wzHtml)){
		wzHtml="";
	}else{
		wzHtml=java.net.URLDecoder.decode(wzHtml, "utf-8");
	}
	String flag=request.getParameter("flag");
	if("".equals(flag)||null==flag){
		flag="1";
	}
	StringBuffer str = new StringBuffer();
	str.append("self_num=").append(self_num).append(";project_info_id=")
	.append(project_info_id).append(";bywx_date_begin=")
	.append(bywx_date_begin).append(";bywx_date_end=").append(bywx_date_end)
	.append(";work_hours_begin=").append(work_hours_begin)
	.append(";work_hours_end=").append(work_hours_end).append(";wz_name=")
	.append(wz_name).append(";xhtype=").append(xhtype).append(";byjb=").append(byjb)
	.append(";wz_id=").append(wz_id).append(";flag=").append(flag);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style=" overflow-x: none;overflow-y: none; ">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
function checkIsNumber(cb){
	var content=$.trim($(cb).val());
	if(content!=undefined&&(null!=content)&&(""!=content)){
		if (!(/(^[1-9]\d*$)/.test(content))){
			alert("请输入正整数");
		}
	}	
}
</script>
<title>维修费用占比分析</title>
<style type="text/css">
.select {
	margin: 0, 0, 0, 0;
	border: 1px #52a5c4 solid;
	width: 100px;
	height: 20px;
	color: #333333;
	position: relative;
	FONT-FAMILY: "微软雅黑";
	font-size: 9pt;
}
option {
	width: auto;
}

.input {
	margin: 0, 0, 0, 0;
	border: 1px #52a5c4 solid;
	width: 85px;
	height: 18px;
	color: #333333;
	position: relative;
	FONT-FAMILY: "微软雅黑";
	font-size: 9pt;
}

.tongyong_box_title {
	width: 100%;
	height: auto;
	text-align: left;
	text-indent: 12px;
	font-weight: bold;
	font-size: 14px;
	color: #0f6ab2;
	line-height: 22px;
}
#inq_tool_box {
	height: 62px;
}
</style>
<script type="text/javascript">
function exportDataDoc(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr="";
    submitStr = "exportFlag="+exportFlag;
		var retObj = syncRequest("post", path, submitStr);
		var filename = retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname = retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location = cruConfig.contextPath
				+ "/rm/dm/common/download_temp.jsp?filename=" + filename
				+ "&showname=" + showname;
}
function showDatas(){
	var ovalue=$("#openType").val();
	if(ovalue=='0'){
		$("#chartContainer2").hide();
		$("#chartContainer1").show();
		$("#chartContainer3").show();
		$("#msg").show();
		$("#zymsg").show();
		simpleSearch();	
	}else{
		$("#chartContainer1").hide();
		$("#chartContainer3").hide();
		$("#msg").hide();
		$("#zymsg").hide();
		$("#chartContainer2").show();
		simpleSearch();
	}
}
</script>
</head>
	<body  style="overflow-x: none;overflow-y: none;" onload="getFusionChart()">
	<div id="list_table" style="background:#cdddef; overflow-x: none;overflow-y: none;">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="FilterLayer">
				<tr>
					<td width="7%" align="right">自编号:</td>
					<td width="15%">
						<table>
							<tr>
								<td><div id="selectTag" style="display: none;">
										<select id="self_num" style="width: 100px">
										</select>
									</div>
									<div id="textTag">
										<input type="text" name="self_num"   value="<%=showSelfNum %>"/>
									</div></td>
								<td><img src="<%=contextPath%>/images/magnifier.gif"
									width="16" height="16" style="cursor: hand;"
									onclick="toChoseSelfNum()" /> <input type="hidden"
									id="returnSelfs" /></td>
							</tr>
						</table>
					</td>
					<td width="7%" align="right">时间:</td>
					<td width="27%" align="left" colspan=2><input
						id="bywx_date_begin" name="bywx_date_begin" style="width: 100px"
						type="text" readonly value="<%=bywx_date_begin%>" /> <img
						src='<%=contextPath%>/images/calendar.gif'
						id='tributton_start_date' width='16' height='16'
						style='cursor: hand;'
						onmouseover='calDateSelector(bywx_date_begin,tributton_start_date);' />
						至 <input id="bywx_date_end" name="bywx_date_end"
						value="<%=bywx_date_end%>" style="width: 100px" type="text"
						readonly /> <img src='<%=contextPath%>/images/calendar.gif'
						id='tributton_end_date' width='16' height='16'
						style='cursor: hand;'
						onmouseover='calDateSelector(bywx_date_end,tributton_end_date);' />
					</td>
					<td width="11%" align="right">项目名称:</td>
					<td align="left" width="18%"><select id="project_name"
						name="project_name" style="width: 150px">
							<option value=""></option>
					</select> <input type="hidden" id="project_info_id" /> <img
						src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
						style="cursor: hand;" onclick="toChoseProject()" /></td>
					<td width="7%">统计范围:</td>
					<td colspan=2><select id="xhtype">
							<option value="0">全部</option>
							<option value="1">现场</option>
							<option value="2">非现场</option>
					</select></td>
				</tr>
				<tr>
					<td width="7%">累计工作小时:</td>
					<td align="left" colspan=2><input id="work_hours_begin"
						name="work_hours_begin" style="width: 100px" type="text"
						onblur="checkIsNumber(this)" value='<%=work_hours_begin_show%>' />
						至 <input id="work_hours_end" name="work_hours_end"
						style="width: 100px" type="text" onblur="checkIsNumber(this)"
						value='<%=work_hours_end_show%>' /></td>
					<td align="left">更换备件名称: <input id="wz_name"
						style="width: 100px" type="text" value="<%=wz_name%>" /> <select
						style="display: none; width: 100px" name='wz_name' id='wzname'></select>
						<img src="<%=contextPath%>/images/magnifier.gif" width="16"
						height="16" style="cursor: hand;" onclick="selectWz()" /> <input
						type="hidden" id="wz_id" /><input type="hidden"  id="flag"  name ="flag"  value='<%=flag %>'/>
					</td>
					<td align="right">保养级别:</td>
					<td align="left"><input type="checkbox" name="byjb" value="B"
						id="B" />B <input type="checkbox" name="byjb" value="C" id="C" />C
						<input type="checkbox" name="byjb" value="D" id="D" />D</td>
					<td align="right">展现形式:</td>
					<td align="left"><select id="openType" onchange="showDatas()">
							<option value="0">图形</option>
							<option value="1">报表</option>
					</select></td>
					<td class="ali_query"><span class="cx"><a href="#"
							onclick="simpleSearch()" title="JCDP_btn_query"></a> </span></td>
					<td class="ali_query"><span class="qc"><a href="#"
							onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="list_content" style=" overflow-x: none;overflow-y: none; ">
		<table id="div_table" width="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
			<td width="47%">
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<!-- <span>震源消耗统计分析&nbsp;&nbsp;</span> -->
							<div class="tongyong_box_content_left" id="chartContainer3"
								style="height: 400px;"></div>
						</div>
					</div>
				</td>
				<td width="53%">
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<!-- <span>震源消耗统计分析&nbsp;&nbsp;</span> -->
							<div class="tongyong_box_content_left" id="chartContainer1"
								style="height: 400px;"></div>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="tongyong_box_title" id='zymsg'>
						<table id="lineTable2" border="1" width="100%">
						</table>
					</div>
				</td>
				<td>
					<div class="tongyong_box_title" id='msg'>
						<table id="lineTable" border="1" width="100%">
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="chartContainer2" style="height:100%;width: 100%;">
		<table  style="background: #cdddef " width="100%" border="0" cellspacing="0" cellpadding="0" class="rtab_info">
		  <tr>
			  <td align="right">记录总数:</td><td align="center"> <div  id="total"></div></td>
			  <td align="right">查询总数:</td><td align="center"> <div  id="search"></div></td>
			  <td align="right">     
			      <a href="#" onClick="report1_saveAsExcel();return false;"><%=excelImage%></a>
			  </td>
		  </tr>
		</table>	
		<report:html name="report1" reportFileName="/zywzxh.raq"  
		    width="-1" 
			height="-1"
			excelPageStyle="0"
			scrollWidth="1090"
			scrollHeight="270"
			params="<%=str.toString()%>"  needSaveAsExcel="yes" 
			needScroll="yes" 
			saveAsName="可控震源维修保养统计表" />		  
	</div>
</body>
<script type="text/javascript">

$(document).ready(function(){
	var h=$("#list_table").height();
	var h1=$(window).height();
	//$("#chartContainer2").height(h1-h);
	$("#report1_contentdiv").height(270);	
	$("#wz_name").bind('blur',function(){
		var wz_name=$(this).val();
		if(null!=wz_name&&wz_name!=''){
			$("#flag").val(2);
		}		
	});
});
		function getList(flag){	
			var byjb="";
			 $("input[type='checkbox'][name='byjb']").each(function(i){
				 if($(this).attr("checked")=='checked'){
					 byjb+=$(this).val()+",";
				 }
			 });
			var returnSelfs=$("#returnSelfs").val();
			var self_num="";
			if(""==returnSelfs){
				$("#textTag").show();
				$("#selectTag").hide();
				self_num=$("input[name='self_num'][type='text']").val();
			}else{
				$("#textTag").hide();
				$("#selectTag").show();
				self_num=returnSelfs;
			}
			var  wz_id=$("#wz_id").val();
			var bywx_date_begin=$("#bywx_date_begin").val();
			var bywx_date_end=$("#bywx_date_end").val();
			var project_info_id=$("#project_info_id").val();
			var wz_name=$("#wz_name").val();
				wz_name = encodeURI(wz_name);
				wz_name = encodeURI(wz_name); 
			var work_hours_begin= $("#work_hours_begin").val();
			var work_hours_end= $("#work_hours_end").val();
			var submitStr="self_num="
				+ self_num + "&bywx_date_begin=" + bywx_date_begin
				+ "&bywx_date_end=" + bywx_date_end + "&project_info_id="
				+ project_info_id + "&wz_name=" + wz_name
				+ "&work_hours_begin=" + work_hours_begin
				+ "&work_hours_end=" + work_hours_end+"&byjb="+byjb+"&wz_id="+wz_id;
			var retObj = jcdpCallService("DevInsSrv","getKkzyTJ",submitStr);
			var t = document.getElementById('lineTable');
			$("#lineTable").html("");
			if(retObj.list != null){	
				for(var i=0;i<retObj.list.length;i++){
					var tr = t.insertRow(i);
					var td = tr.insertCell(0);
					td.width='30%';
					td.innerHTML = '<font >备件消耗总金额(元)</font>';
				    td = tr.insertCell(1);
					td.innerHTML = '<font >'+retObj.list[i].price+'</font>';
				}    
			}
		}

		//获取图表
		function getFusionChart(){
			
			var openType=<%=openType%>;
			var xhtype=<%=oldxhtype%>;			 
			$("#xhtype").val(xhtype);
			$("#openType").val(openType);
			if(openType=='0'){
				$("#chartContainer1").show();
				$("#chartContainer3").show();
				$("#msg").show();
				$("#zymsg").show();
				$("#chartContainer2").hide();
				getRepairCostProFusionChart();
				getZyDevFusionChart();
				getList('0');
			}else{
				var retObj = jcdpCallService("DevInsSrv","getKkzyTotal","");
				$("#total").html(retObj.data.total);
				var length=0;
				var a=$("#report1  tr:eq(2)").find("td:eq(1)").html();
				if(a==null||a==""){
					length="0";
				}else{
				    length=$("#report1  tr").length-3;
				}

				$("#search").html(length);
				var showSelfNum='<%=showSelfNum%>';
				var selfSeleHtml='<%=selfSeleHtml%>';
				var self_num='<%=self_num%>';
				if(""==showSelfNum&&""==selfSeleHtml){
					$("#selectTag").hide();
					$("#textTag").show();
				}else if(""!=showSelfNum){
					$("#selectTag").hide();
					$("#textTag").show();
					$("input[type='text'][name='self_num']").val(showSelfNum);
					$("#returnSelfs").val("");
				}else if(""==showSelfNum&&""!=selfSeleHtml){
					$("#textTag").hide();
					$("#selectTag").show();
					$("#self_num").html("");
					$("#self_num").append(selfSeleHtml);
					$("#returnSelfs").val(self_num);
				}
				var project_info_id ='<%=project_info_id%>';
				var projectHtml='<%=projectHtml%>';
				$("#project_name").html("");
				$("#project_name").append(projectHtml);
				$("#project_info_id").val(project_info_id);
				var wz_name='<%=wz_name%>';
				var wz_id='<%=wz_id%>';
				var wzHtml='<%=wzHtml%>';
				var showWzName='<%=showWzName%>';
				
				if(""==wz_name&&""==wz_id){
					$("#wz_name").show();
					$("#wzname").hide();
				}else  if(""!=wz_name){
					$("#wz_name").show();
					$("#wzname").hide();
					$("#wzname").html("");
					$("#wz_id").val("");
					$("#wz_name").val(wz_name);
				}else if(""==wz_name&&""!=wz_id&&"no"==showWzName){
					$("#wz_name").hide();
					$("#wzname").show();
					$("#wzname").append(wzHtml);
					$("#wz_id").val(wz_id);
				}else if(""==wz_name&&""!=wz_id&&"yes"==showWzName){
					$("#wz_name").show();
					$("#wzname").hide();
				}
				var byjb='<%=byjb%>';
				if(byjb.indexOf('无',0)>0){
					$("#B").removeAttr("checked");
					$("#C").removeAttr("checked");
					$("#D").removeAttr("checked");
				}else{
					if(""!==byjb){
						var  jb=byjb.split(",");
						for(var i=0;i<jb.length;i++){
							var value=jb[i];
							$("#"+value).attr("checked","checked");
						}
					}
				}

				$("#chartContainer2").show();
				$("#chartContainer1").hide();
				$("#chartContainer3").hide();
				$("#msg").hide();
				$("#msg").hide();
			}			
		}
		//震源物资消耗统计
		function getRepairCostProFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "97%", "400", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/zytj/zytj.srq");
			chart1.render("chartContainer1");
		}
		
		//震源物资消耗统计
		function getZyDevFusionChart(){
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "97%", "400", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/zytj/zyDevTj.srq");
			chart1.render("chartContainer3");
			var retObj = jcdpCallService("DevInsSrv","getKkzyDevTJ","");
			var t = document.getElementById('lineTable2');
			$("#lineTable2").html("");
			if(retObj.total != null){	
			    var data=retObj.total;				
				var tr = t.insertRow(0);
				var td = tr.insertCell(0);
					td.width='30%';
					td.innerHTML = '<font >国内震源总数量</font>';
				    td = tr.insertCell(1);				        
					td.innerHTML = '<font >'+data.num+'</font>';    
			}
		}
		//各个项目震源总数
		function popProjectZyList(){
			popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/popProjectZyList.jsp','800:600');
		}
		
		function popFxcZyList(){
			popWindow('<%=contextPath %>/rm/dm/kkzy/zytj/popFxcDevArchiveBaseInfoList.jsp','1200:800');
		}
		//查询
		function simpleSearch(){
			var returnSelfs=$("#returnSelfs").val();
			var self_num="";
			if(""==returnSelfs){
				$("#textTag").show();
				$("#selectTag").hide();
				self_num=$("input[name='self_num'][type='text']").val();
			}else{
				$("#textTag").hide();
				$("#selectTag").show();
				self_num=returnSelfs;
			}
			var  wz_id=$("#wz_id").val();
			var bywx_date_begin=$("#bywx_date_begin").val();
			var bywx_date_end=$("#bywx_date_end").val();
			var project_info_id=$("#project_info_id").val();
			var wz_name=$("#wz_name").val();
			wz_name = encodeURI(wz_name);
			wz_name = encodeURI(wz_name); 
			var work_hours_begin= $("#work_hours_begin").val();
			var work_hours_end= $("#work_hours_end").val();
			var openType= $("#openType").val();
			var byjb="";
			 $("input[type='checkbox'][name='byjb']").each(function(i){
				 if($(this).attr("checked")=='checked'){
					 byjb+=$(this).val()+",";
				 }
			 });
			if(openType=='0'){				
				$("#chartContainer1").show();
				$("#chartContainer3").show();
				$("#msg").show();
				$("#zymsg").show();
				$("#chartContainer2").hide();
		
				var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "97%", "400", "0", "0" );    
				chart1.setXMLUrl("<%=contextPath%>/rm/dm/zytj/zytj.srq?self_num="
							+ self_num + "&bywx_date_begin=" + bywx_date_begin
							+ "&bywx_date_end=" + bywx_date_end + "&project_info_id="
							+ project_info_id + "&wz_name=" + wz_name
							+ "&work_hours_begin=" + work_hours_begin
							+ "&work_hours_end=" + work_hours_end+"&byjb="+byjb+"&wz_id="+wz_id);
				chart1.render("chartContainer1");
				getList('1');
				getZyDevFusionChart();
			}else if(openType=='1'){
				$("#chartContainer2").show();
				$("#msg").hide();
				$("#zymsg").hide();
				$("#chartContainer1").hide();
				$("#chartContainer3").hide();
				var xhtype=$("#xhtype").val();
				var showSelfNum="";
				var selfSeleHtml="";
				if(""==returnSelfs){
					if(""!=self_num){
						showSelfNum=self_num;
					   baseData = jcdpCallService("DevInsSrv", "getLikeSelfNum", "self_num="+self_num);
					   self_num="";
					   if(baseData.datas!=null){
						    var datas = baseData.datas;
							for(var i=0;i<datas.length;i++){
								self_num+=datas[i].self_num+",";
							}						   
						}					
				  	}
				}else{
					selfSeleHtml=$("#self_num").html();				
				}
				var projectHtml="";
				if(""!=project_info_id||undefined!=project_info_id){
					
					projectHtml=$("#project_name").html();
					
					var text=$("#project_name  option:selected").val();
					if(text==""){
						var  pids = jcdpCallService("DevInsSrv", "getProjectInfoIdList", "bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end);
						project_info_id=pids.data;						
					}
					projectHtml = encodeURI(projectHtml);
					projectHtml = encodeURI(projectHtml); 
				}else{
					var pids = jcdpCallService("DevInsSrv", "getProjectInfoIdList", "bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end);
					project_info_id=pids.data;
				}
				var wzHtml=$("#wzname").html();
				if(""!=wzHtml||undefined!=wzHtml){
					wzHtml = encodeURI(wzHtml);
					wzHtml = encodeURI(wzHtml); 
				}
			   var flag=$("#flag").val();
				window.location="<%=contextPath%>/rm/dm/kkzy/zytj/kkzyMatUse.jsp?project_info_id="+project_info_id+"&self_num="+self_num+"&bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end+"&work_hours_begin="+work_hours_begin+"&work_hours_end="+work_hours_end+"&wz_name="+wz_name+"&openType="+openType+"&xhtype="+xhtype+"&byjb="+byjb+"&wz_id="+wz_id+"&showSelfNum="+showSelfNum+"&selfSeleHtml="+selfSeleHtml+"&projectHtml="+projectHtml+"&wzHtml="+wzHtml+"&flag="+flag;
			}			
	}
	//弹出项目设备维修费用列表
	function popProjRepaCostList(args) {
		popWindow('<%=contextPath%>/rm/dm/kkzy/zytj/project.jsp?args='+args,'800:600');
	}

	function clearQueryText(){
		$("#textTag").show();
		$("#selectTag").hide();
		$("input[name='self_num'][type='text']").val("");
		$("#self_num").html("");
		$("#returnSelfs").val("");
		$("#bywx_date_begin").val("");
		$("#bywx_date_end").val("");
		$("#project_name").val("");
		$("#project_info_id").val("");
		$("#wz_name").val("");
		$("#wz_name").show();
		$("#wzname").html("");
		$("#wzname").hide();
		$("#wz_id").val("");
		$("#project_name").empty();
		$("#flag").val(1);
		
		document.getElementById("work_hours_begin").value = '';
		document.getElementById("work_hours_end").value = '';
	}
	function toChoseSelfNum(){
		var obj = new Object();
		var innerHtml="";
		var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectZySelfNum.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
		if(vReturnValue!=undefined){
			$("#returnSelfs").val(vReturnValue);
			$("#self_num").html("");
			var self_nums=vReturnValue.split(",");
			for(var i=0;i<self_nums.length-1;i++){
				innerHtml+="<option  value='"+self_nums[i]+"'>"+self_nums[i]+"</option>";
			}
			$("#textTag").hide();
			$("#selectTag").show();
			$("#self_num").append(innerHtml);
		}
	}
	function selectWz(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/zytj/selectMatList.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
		$("#wzname").empty();
		vReturnValue=vReturnValue.substring(0,vReturnValue.lastIndexOf("~"));
		if(vReturnValue!=''){
			$("#flag").val(2);
		}
		var wz=vReturnValue.split("~");
		var wzHtml="";
		var wz_ids="";
		for(var i=0;i<wz.length;i++){
			var  wz_id =wz[i].split(",")[0];
			var  wz_name =wz[i].split(",")[1];
			wzHtml+="<option   value='"+wz_id+"'>"+wz_name+"</option>";
			wz_ids+=wz_id+",";
		}
		$("#wz_name").hide();
		$("#wzname").show();	
		$("#wzname").append(wzHtml);
		$("#wz_id").val(wz_ids);
	}
	function toChoseProject(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectProject.jsp', obj,
				'dialogWidth=1024px;dialogHigth=400px');
			
		if(vReturnValue != undefined){
			var innerHtml = "";
			var project_info_ids = "";
			$("#project_name").html("");
			var selectedProjects = vReturnValue.split(",");
			for ( var i = 0; i < selectedProjects.length - 1; i++) {
				var ids = selectedProjects[i].split("-");
				var id = ids[0];
				var project_name = ids[5];
				innerHtml += "<option  value='"+id+"'>" + project_name
						+ "</option>";
				project_info_ids += id + ",";
			}
			$("#project_name").append(innerHtml);
			$("#project_info_id").val(project_info_ids);
		}
	}
</script>
</html>
