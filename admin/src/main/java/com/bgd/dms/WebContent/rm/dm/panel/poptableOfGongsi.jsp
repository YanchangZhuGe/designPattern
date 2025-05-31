<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String parentCode = request.getParameter("parentCode");
	if(parentCode==null || parentCode.trim().equals("")){
		parentCode = "";
	}
	String wutanorg = request.getParameter("wutanorg");
	if(wutanorg==null || wutanorg.trim().equals("")){
		wutanorg = "";
	}
	String ifCountry = request.getParameter("ifCountry");
	if(ifCountry==null || ifCountry.trim().equals("")){
		ifCountry = "";
	}
	String analType = request.getParameter("analType");
	if(analType==null || analType.trim().equals("")){
		analType = "";
	}
	String level = request.getParameter("level");
	if(level==null || level.trim().equals("")){
		level = "";
	}
	String account_stat = request.getParameter("account_stat");
	if(account_stat==null || account_stat.trim().equals("")){
		account_stat = "";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
<style type="text/css">
	.input {
		margin:0,0,0,0;
		border:1px #52a5c4 solid;
		width:70px;
		height:18px;
		color: #333333;
		position: absolute;
		right: 10px;
		font-family: "微软雅黑";
		font-size:10pt;
	}
</style>
<title>公司级仪表盘</title>
</head>
<body style="overflow-y: no; overflow-x: hidden;" onload="getFusionChart()">
<div ><!-- style="overflow-y: auto; overflow-x: hidden;" -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="middle">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="tongyong_box" >
								<div class="tongyong_box_title">
									<span>设备基本情况统计表</span>
									<input type="button" value="返回上级" class="input" onclick="toBack()"/>
								</div>
								<div class="tongyong_box_content_left" style="height: 500px;">
									<div id="chartContainer1"></div>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</td> 
		</tr>
	</table>
</div>
<script type="text/javascript">
	var iparentCode='<%=parentCode%>';
	var iwutanorg='<%=wutanorg%>';
	var _ifCountry='<%=ifCountry%>';
	var ianalType='<%=analType%>';
	var ilevel='<%=level%>';
	var account_stat='<%=account_stat%>';
	//获取图表
	function getFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "480", "0", "0" ); 
		chart1.setXMLUrl("<%=contextPath%>/rm/dm/getMainEquiBaseChartData.srq?parentCode="+iparentCode+"&wutanorg="+iwutanorg+"&ifCountry="+_ifCountry+"&analType="+ianalType+"&level="+ilevel+"&account_stat="+account_stat);
		chart1.render("chartContainer1");
	}
	String.prototype.startWith=function(s){ 
		if(s==null||s==""||this.length==0||s.length>this.length) 
		return false; 
		if(this.substr(0,s.length)==s) 
		return true; 
		else 
		return false; 
		return true; 
	} 
	//钻取
	function popNextLevelAnal(parentCode,wutanorg,ifCountry,analType,level){
	 	debugger;
		iparentCode=parentCode;
		iwutanorg=wutanorg;
		_ifCountry=ifCountry;
		ianalType=analType;
		ilevel=level;
		if(level==5&&analType=='use'){
		popDevOrgAnal(parentCode,ifCountry,analType,wutanorg);
		} else if(level==5&&analType=='sum'){
		return;
		} else if(level==5&&('idle'==analType||'wait_repair'==analType||'repairing'==analType||'wait_scrap'==analType)&&(parentCode.indexOf('D001')!=-1||parentCode.indexOf('D005')!=-1)){
		return;
		}else{
		chartReference1 = FusionCharts("chart1"); 
		chartReference1.setXMLUrl("<%=contextPath%>/rm/dm/getMainEquiBaseChartData.srq?parentCode="+parentCode+"&wutanorg="+wutanorg+"&ifCountry="+ifCountry+"&analType="+analType+"&level="+level+"&account_stat="+account_stat);	
		}
		
	}
	//钻取 到单位显示数量
	function popDevOrgAnal(parentCode,ifCountry,analType,wutanorg,postion_id){
 
	 	if('idle'==analType||'wait_repair'==analType||'repairing'==analType){
	 	popWindow("<%=contextPath %>/rm/dm/panel/poptableOfGongsiCount.jsp?parentCode="+parentCode+"&ifCountry="+ifCountry+"&analType="+analType+"&wutanorg=<%=wutanorg%>&account_stat="+account_stat+"&postion_id="+postion_id,'1080:560','-钻取信息显示');
	 	}else{
	 	popWindow("<%=contextPath %>/rm/dm/panel/poptableOfGongsiCount.jsp?parentCode="+parentCode+"&ifCountry="+ifCountry+"&analType="+analType+"&wutanorg=<%=wutanorg%>&account_stat="+account_stat,'1080:560','-钻取信息显示');
	 	}
	}
	function toBack(){
		if(ilevel>2){
			//上级级别
			ilevel=parseInt(ilevel)-1;
			//上级编码
			iparentCode=iparentCode.substr(0,(ilevel-1)*3+1);
			popNextLevelAnal(iparentCode,iwutanorg,_ifCountry,ianalType,ilevel);
		}else{
			newClose();
		}
	}
</script>
</body>
</html>