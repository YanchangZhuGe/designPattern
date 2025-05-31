<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="java.util.*"%>
<%
	String contextPath=request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String healthInfoId=request.getParameter("healthInfoId");
	if(healthInfoId == null || "".equals(healthInfoId)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		healthInfoId = user.getProjectInfoNo();
	}
	List<Map> list=OPCommonUtil.getProjectHealthInfo(healthInfoId);
	Map map=new HashMap();
	int i=0;
	for(Map temp : list){
		i++;
		map.put("str"+i, temp.get("heath_content"));
		map.put("content"+i, temp.get("heath_standard"));
		map.put("color"+i,temp.get("heath_color"));
	}
	String flag=request.getParameter("flag");
	Date date=new Date();
	String dt=1900+date.getYear()+"/"+(int)(date.getMonth()+1)+"/"+(int)(date.getDate()-1);
%>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<style type="text/css">
body {
	font: normal 11px auto "Trebuchet MS", Verdana, Arial, Helvetica,
		sans-serif;
	color: #4f6b72;
	background: #E6EAE9;
}

a {
	color: #c75f3e;
}

#mytable {
	width: 100%;
	padding: 0;
	margin: 0;
}

caption {
	padding: 0 0 5px 0;
	width: 100%;
	font: italic 12px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
	text-align: right;
}	

th {
	font: bold 12px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
	color: black;
	border-right: 1px solid #C1DAD7;
	border-bottom: 1px solid #C1DAD7;
	border-top: 1px solid #C1DAD7;
	letter-spacing: 2px;
	text-transform: uppercase;
	text-align: left;
	padding: 6px 6px 6px 12px;
	background: #5B99DE;
}

td {
	border-right: 1px solid #C1DAD7;
	border-bottom: 1px solid #C1DAD7;
	background: #fff;
	font-size: 12px;
	text-align:center;
	padding: 6px 6px 6px 12px;
	color: black;
}
</style> 

<script type="text/javascript">

var flag="<%=flag%>";
$(function(){
	<%for(int j=1;j<=28;j++){
		
	%>
		$("#str<%=j%>").css("background","<%=map.get("color"+j)==null||"".equals(map.get("color"+j))?"#fff":map.get("color"+j)%>");	
	<%
	}
	%>
	getTab3(flag);
})
var selectedTagIndex=0;
function getTab3(index) {  
	selectedTagIndex = index;
	$("li[id='"+"tag3_"+selectedTagIndex+"']").addClass("selectTag");
	$("li[id!='"+"tag3_"+selectedTagIndex+"']").removeClass();
	$("div[id='"+"tab_box_content"+selectedTagIndex+"']").css("display","block");
	$("div[id!='"+"tab_box_content"+selectedTagIndex+"'][class='tab_box_content']").css("display","none");
}

function openChart(){
	var obj=new Object();
	window.showModalDialog("<%=contextPath%>/pm/chart/deviationChartFrame.jsp?projectInfoNo=<%=healthInfoId%>",obj,"dialogWidth=800px;dialogHeight=600px")	;
}

</script>  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<title>无标题文档</title>
</head>
<body >
<table id="mytable" width="100%"  >
	<tr>
		<th width="5%"><p align="center" >标题</p>
		</th>
		<th  colspan="2"  width="20%"><p align="center">指标名称</p>
		</th>
		<th  width="50%"><p align="center">标准</p></th>
		<th  width="30%"><p align="center">内容</p></th>
	</tr>
	<tr>
		<td rowspan="5"><p align="center">进度</p>
		</td>
		<td rowspan="3"><p align="center">计划偏离度</p>
		</td>
		<td><p align="center">测量</p></td>
		<td rowspan="3"><p align="center"><%=map.get("content1") == null ? "" : map.get("content1")%>&nbsp;</p></td>
		<td id="str1">
		<a style="color: black;cursor: pointer;" onclick="openChart()" >
		<%=map.get("str1") == null ? "" : map.get("str1")%>&nbsp;
		</a>
		</td>
	</tr>
	<tr>
		<td><p align="center">钻井</p></td>
		<td  id="str2">
		<a style="color: black;cursor: pointer;" onclick="openChart()" >
		<%=map.get("str2") == null ? "" : map.get("str2")%>&nbsp;
		</a>
		</td>
	</tr>
	<tr>
		<td>采集</td>
		<td  id="str3">
		<a style="color: black;cursor: pointer;" onclick="openChart()" >
		<%=map.get("str3") == null ? "" : map.get("str3")%>&nbsp;
		</a>
		</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">生产效率</p>
		</td>
		<td><p align="center"><%=map.get("content4") == null ? "" : map.get("content4")%></p></td>
		<td  id="str4"><p align="center"><%=map.get("str4") == null ? "" : map.get("str4")%>&nbsp;</p></td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">里程碑时间节点</p>
		</td>
		<td><p align="center"><%=map.get("content5") == null ? "" : map.get("content5")%>&nbsp;
			</p>
		</td>
		<td  id="str5"><p align="center"><%=map.get("str5") == null ? "" : map.get("str5")%>&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td rowspan="2"><p align="center">人员</p>
		</td>
		<td colspan="2"><p align="center"><%=map.get("content6") == null ? "" : map.get("content6")%></p>
		</td>
		<td><p align="center"><%=map.get("content6") == null ? "" : map.get("content6")%>&nbsp;</p>
		</td>
		<td  id="str6"><p align="center"><%=map.get("str6") == null ? "" : map.get("str6")%>&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">操作技能</p>
		</td>
		<td><p align="center"><%=map.get("content7") == null ? "" : map.get("content7")%>&nbsp;
			</p>
		</td>
		<td  id="str7"><p align="center"><%=map.get("str7") == null ? "" : map.get("str7")%>&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td rowspan="3"><p align="center">设备</p>
		</td>
		<td colspan="2"><p align="center">设备完好率</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str8"><p align="center"><%=map.get("str8") == null ? "" : Double.parseDouble((String)map.get("str8"))%>%&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">利用率</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str9"><p align="center"><%=map.get("str9") == null ? "" : Double.parseDouble((String)map.get("str9"))%>%&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">设备事故发生起数</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str10"><p align="center"><%=map.get("str10") == null ? "" : map.get("str10")%>&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td rowspan="4"><p align="center">关键物资</p>
		</td>
		<td colspan="2"><p align="center">84、85#</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str11"><p align="center"><%=map.get("str11") == null ? "" : map.get("str11")%>&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">燃油</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str12"><%=map.get("str12") == null ? "" : map.get("str12")%>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">炮线 </p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str13"><%=map.get("str13") == null ? "" : map.get("str13")%>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2"><p align="center">物资质量</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td  id="str14"><p align="center"><%=map.get("str14") == null ? "" : map.get("str14")%>&nbsp;
			</p>
		</td>
	</tr>
	<tr>
		<td><p align="center">生产组织</p>
		</td>
		<td><p align="center">&nbsp;
			</p>
		</td>
		<td colspan="3"  id="str5"><p align="center"><%=map.get("str15")==null?"":map.get("str15")%>&nbsp;
			</p>
		</td>
	</tr>
</table>
</body>
</html>

