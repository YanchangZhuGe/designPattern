<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@ include file="/common/rptHeader.jsp"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	//震源编号  消耗日期   项目名称  消耗类别  累计工作小时  物资名称
	//String contextPath = request.getContextPath();
	String startDate = new SimpleDateFormat("yyyy").format(new Date())
	+ "-01-01";
	String endDate = new SimpleDateFormat("yyyy-MM-dd")
	.format(new Date());
	IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	String bywx_date_begin=request.getParameter("bywx_date_begin");
	if(null==bywx_date_begin||"".equals(bywx_date_begin)){
		 bywx_date_begin=startDate;
	}
	
	String bywx_date_end=request.getParameter("bywx_date_end");
	if(null==bywx_date_end||"".equals(bywx_date_end)){
		 bywx_date_end=endDate;
	}
	String self_num=request.getParameter("self_num");
	if(null==self_num||"".equals(self_num)){
		String sql1="select self_num   from gms_device_account t where   t.dev_type  like 'S06230101%' and t.bsflag='0' and t.self_num is not null ";
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
	
	for(int i = 0; i < list.size(); i++) {
		    Map s = list.get(i);
		   self_num += s.get("self_num").toString()+ ",";
	}
		}	
	}
	String showSelfNum=request.getParameter("showSelfNum");
	if("".equals(showSelfNum)||null==showSelfNum){
		showSelfNum="";
	}
	self_num=self_num.replaceAll("null", "");
	String selfSeleHtml=request.getParameter("selfSeleHtml");
	if(null==selfSeleHtml||"".equals(selfSeleHtml)){
		selfSeleHtml="";
	}
	String zcj_type=request.getParameter("zcj_type");
	String show_zcj_type=zcj_type;
	if(null==zcj_type||"".equals(zcj_type)){
		zcj_type="5110000187000000001,5110000187000000003,5110000187000000005,5110000187000000006,5110000187000000008,5110000187000000010,5110000187000000011,5110000187000000013,5110000187000000002,5110000187000000007,5110000187000000012,5110000187000000004,5110000187000000009,5110000187000000014,5110000187000000015,0";
	}else{
		zcj_type=zcj_type+","+zcj_type;
	}
	StringBuffer str = new StringBuffer();
	str.append("self_num=").append(self_num).append(";bywx_date_begin=")
	.append(bywx_date_begin).append(";bywx_date_end=").append(bywx_date_end).append(";zcj_type=").append(zcj_type);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css"
	rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/popup/AlertBox.js"></script>
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
</style>
</head>

<body style="overflow-x: scroll;overflow-y: scroll;"  onload="getFusionChart()">
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png"
					width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width='6%' align="right">时间：</td>
			 	    <td  width='25%'>
			 	    	<input
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
			 	    <td width="8%" align="right">自编号:</td>
					<td width="15%">
						<table>
							<tr>
								<td><div id="selectTag" style="display: none;">
										<select id="self_num" style="width: 100px">
										</select>
									</div>
									<div id="textTag">
										<input type="text" name="self_num"  />
									</div></td>
								<td><img src="<%=contextPath%>/images/magnifier.gif"
									width="16" height="16" style="cursor: hand;"
									onclick="toChoseSelfNum()" /> <input type="hidden"
									id="returnSelfs" /></td>
							</tr>
						</table>
					</td>
					<td width="12%" align="right">主要总成件名称:</td>
					<td align="left" width="18%"><select id="zcj_type"
						name="zcj_type" style="width: 150px">
							<option value=""></option>
					</select>
					<input   type="hidden"    id="zcjtype"  value="<%=show_zcj_type %>"/>
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
				<td width="4"><img src="<%=contextPath%>/images/list_17.png"
					width="4" height="36" /></td>
			</tr>
		</table>
	</div>
</div>

    <div  style="width: 100%;height: 466px" align="center">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="rtab_info">
	  <tr>
	    <td align="right">     
	      <a href="#" onClick="report1_saveAsWord();return false;"><%=wordImage%></a>
	      <a href="#" onClick="report1_saveAsExcel();return false;"><%=excelImage%></a>
	      <a href="#" onClick="report1_saveAsPdf();return false;"><%=pdfImage%></a>
	      <a href="#" onClick="report1_print();return false;"><%=printImage%></a>
	    </td>
	  </tr>
	</table>
		      <report:html name="report1"
			               reportFileName="/zcjghtz.raq"
						   params="<%=str.toString()%>"
					
			scrollWidth="180%" scrollHeight="100%"
			needScroll="yes"
			needPageMark="no"	   
			saveAsName="主要总成件更换台账"
			excelPageStyle="0"
			  />
			
	
	</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	function getFusionChart(){
	    var zcjHtml=getCodeList('5110000187','zcj');
	    $("#zcj_type").append(zcjHtml);
	    var zcjtype= $("#zcjtype").val();
	    if(""!=zcjtype&&undefined!=zcjtype){
	    	$("#zcj_type").val(zcjtype);
	    }
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
}
	function simpleSearch(){
		var returnSelfs=$("#returnSelfs").val();
		var zcj_type=$("#zcj_type").val();
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
		var bywx_date_begin=$("#bywx_date_begin").val();
		var bywx_date_end=$("#bywx_date_end").val();
			
			var showSelfNum="";
			var selfSeleHtml="";
			if(""==returnSelfs){
				if(""!=self_num){
					showSelfNum=self_num;
				   baseData = jcdpCallService("DevInsSrv", "getLikeSelfNum", "self_num="+self_num);
				   if(baseData.datas!=null)
					{
					   self_num="";
					    var datas = baseData.datas;
						for(var i=0;i<datas.length;i++){
							
							self_num+=datas[i].self_num+",";
						}  
					}
				
			  }
			}else{
				selfSeleHtml=$("#self_num").html();
			}
			window.location="<%=contextPath%>/rm/dm/kkzy/zytj/zcjghtz.jsp?self_num="+self_num+"&bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end+"&showSelfNum="+showSelfNum+"&selfSeleHtml="+selfSeleHtml+"&zcj_type="+zcj_type;
}
	function clearQueryText(){
		$("#textTag").show();
		$("#selectTag").hide();
		$("input[name='self_num'][type='text']").val("");
		$("#self_num").html("");
		$("#returnSelfs").val("");
		$("#bywx_date_begin").val("");
		$("#bywx_date_end").val("");
		$("#zcj_type").val("");
	}
	function toChoseSelfNum(){
		var obj = new Object();
		var innerHtml="";
		var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectZySelfNum.jsp', obj,
				'dialogWidth=1024px;dialogHigth=400px');
		if (vReturnValue != undefined) {
			$("#returnSelfs").val(vReturnValue);
			$("#self_num").html("");
			var self_nums = vReturnValue.split(",");
			for ( var i = 0; i < self_nums.length - 1; i++) {
				innerHtml += "<option  value='"+self_nums[i]+"'>"
						+ self_nums[i] + "</option>";
			}
			$("#textTag").hide();
			$("#selectTag").show();
			$("#self_num").append(innerHtml);
		}
	}
</script>
</html>