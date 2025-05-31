<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String healthInfoId=request.getParameter("healthInfoId");
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
	
	String ifHeath = request.getParameter("ifHeath");
	if(ifHeath == null || "".equals(ifHeath) || ifHeath == "null" || "null".equals(ifHeath)){
		ifHeath = "1";
	}
	String reportId=OPCommonUtil.getNewAccidentIdByPrj(healthInfoId);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
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

<script language="javaScript">
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
	function openProcess(){
		var obj=new Object();
		window.showModalDialog("<%=contextPath%>/pm/chart/deviationChartFrame.jsp?projectInfoNo=<%=healthInfoId%>",obj,"dialogWidth=800px;dialogHeight=600px")	;
	}
	function openPM(){
		var reportId='<%=reportId%>';
		var obj=new Object();
		window.showModalDialog("<%=contextPath %>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=qua_accident&noLogin=admin&tokenId=admin&KeyId="+reportId,obj,"dialogWidth=640px;dialogHeight=520px")	;
}
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3" >
	<div id="new_table_box">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div align="right">
					<span style="color: red">当前数据汇总时间为<%=OPCommonUtil.getProjectEndDate(healthInfoId)%></span>
				</div>
				<div id="tag-container_3">
					<ul id="tags" class="tags">
						<li class="selectTag" id="tag3_0"><a id="0" href="#" onclick="getTab3(0)">生产</a>
						</li>
						<li id="tag3_1"><a id="0" href="#" onclick="getTab3(1)">质量</a>
						</li>
						<li id="tag3_2"><a id="0" href="#" onclick="getTab3(2)">HSE</a>
						</li>
						<%if(ifHeath == "0" || "0".equals(ifHeath)){ %>
						<li id="tag3_3"><a id="0" href="#" onclick="getTab3(3)">报表</a>
						</li>
						<%} %>
					</ul>
				</div>
				<div id="tab_box" class="tab_box">
					<div id="tab_box_content0" class="tab_box_content">
						<table id="mytable" width="100%" >
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
								<a style="color: black" onclick="openChart()" >
								<%=map.get("str1") == null ? "" : map.get("str1")%>&nbsp;
								</a>
								</td>
							</tr>
							<tr>
								<td><p align="center">钻井</p></td>
								<td  id="str2">
								<a style="color: black" onclick="openChart()" >
								<%=map.get("str2") == null ? "" : map.get("str2")%>&nbsp;
								</a>
								</td>
							</tr>
							<tr>
								<td>采集</td>
								<td  id="str3">
								<a style="color: black" onclick="openChart()" >
								<%=map.get("str3") == null ? "" : map.get("str3")%>&nbsp;
								</a>
								</td>
							</tr>
							<!--
							<tr>
								<td colspan="2"><p align="center">生产效率</p>
								</td>
								<td><p align="center"><%=map.get("content4") == null ? "" : map.get("content4")%></p></td>
								<td  id="str4"><p align="center"><%=map.get("str4") == null ? "" : map.get("str4")%>&nbsp;</p></td>
							</tr>
							-->
							<tr>
								<td colspan="2"><p align="center">里程碑时间节点</p>
								</td>
								<td><p align="center"><%=map.get("content5") == null ? "" : map.get("content5")%>&nbsp;
									</p>
								</td>
								<td  id="str5"><p align="center">
								<a style="color: black" onclick="openProcess()" >
								<%=map.get("str5") == null ? "" : map.get("str5")%>&nbsp;
								</p>
									</p>
								</td>
							</tr>
							<!--
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
							-->
						</table>
					</div>
					<div id="tab_box_content1" class="tab_box_content"  style="display:none;">
						<table width="100%" border="4" style="border: thick;" cellspacing="1" cellpadding="1">
							<tr background="blue" class="bt_info">
								<th   width="10%"><p align="center">标题</p>
								</th>
								<th   width="10%"><p align="center">指标名称</p>
								</th>
								<th   width="20%"><p align="center">标准</p>
								</th>
								<th   width="60%"><p align="center">内容</p>
								</th>
							</tr>
							<tr>
								<td rowspan="3"><p align="center">合同要求指标</p></td>
								<td><p align="center">合格率</p></td>
								<td><p align="center"><%=map.get("content16") == null ? "" : map.get("content16")%>%</p></td>
								<td  id="str16"><%=map.get("str16") == null ? "" : (String)map.get("str16")%>&nbsp;</td>
							</tr>
						
							<tr>
								<td><p align="center">空炮率</p></td>
								<td><p align="center"><%=map.get("content18") == null ? "" : map.get("content18")%>%</p></td>
								<td  id="str18"><%=map.get("str18") == null ? "" : (String)map.get("str18")%>&nbsp;</td>
							</tr>
							<tr>
								<td><p align="center">废炮率</p></td>
								<td><p align="center"><%=map.get("content19") == null ? "" : map.get("content19")%>%</p></td>
								<td  id="str19"><%=map.get("str19") == null ? "" : (String)map.get("str19")%>&nbsp;</td>
							</tr>
							<tr>
								<td  colspan="2"><p align="center">质量事故分级</p></td>
								<td><p align="center"><%=map.get("content20") == null ? "" : map.get("content20")%></p></td>
								<td id="str20">
								<a style="color: black" onclick="openPM()" >
								<p align="center"><%=map.get("str20") == null ? "" : map.get("str20")%>&nbsp;</p>
								</a>
								</td>
							</tr>
						</table>
					</div>
					<div id="tab_box_content2" class="tab_box_content"  style="display:none;">
						<table width="100%" border="4" style="border: thick;" cellspacing="1" cellpadding="1">
							<tr background="blue" class="bt_info">
								<th   width="10%"><p align="center">标题</p>
								</th>
								<th   width="10%"><p align="center">指标名称</p>
								</th>
								<th   width="40%"><p align="center">标准</p>
								</th>
								<th   width="40%"><p align="center">内容</p>
								</th>
							</tr>
							<tr>
								<td rowspan="4"><p align="center">控制性指标</p>
								</td>
								<td><p align="center">隐患整改率</p>
								</td>
								<td><p align="center"><%=map.get("content21") == null ? "" : map.get("content21")%></p>
								</td>
								<td  id="str21"><p align="center"><%=map.get("str21") == null ? "" : String.valueOf(Double.parseDouble((String)map.get("str21")))+"%"%>&nbsp;
									</p>
								</td>
							</tr>
							<tr>
								<td><p align="center">工业生产重伤人数</p>
								</td>
								<td><p align="center"><%=map.get("content22") == null ? "" : map.get("content22")%></p>
								</td>
								<td id="str22"><p align="center"><%=map.get("str22") == null ? "" : map.get("str22")%>&nbsp;
									</p>
								</td>
							</tr>
							<tr>
								<td><p align="center">轻微环境污染和生态破坏起数</p>
								<td><p align="center"><%=map.get("content23") == null ? "" : map.get("content23")%></p>
								</td>
								<td id="str23"><p align="center"><%=map.get("str23") == null ? "" : map.get("str23")%>&nbsp;
									</p>
								</td>
							</tr>
							<tr>
								<td><p align="center">百万工时损工伤亡发生率（LTIF）</p></td>
								<td><p align="center"><%=map.get("content24") == null ? "" : map.get("content24")%></p></td>
								<td id="str24"><p align="center"><%=map.get("str24") == null ? "" : map.get("str24")%>&nbsp;
									</p>
								</td>
							</tr>

							<tr>
								<td rowspan="4"><p align="center">杜绝性指标（发生即为红色）</p>
								</td>
								<td><p align="center">杜绝一般A级及以上工业生产事故、火灾事故、环境污染或生态破坏事故</p>
								</td>
								<td><p align="center"><%=map.get("content25") == null ? "" : map.get("content25")%></p>
								</td>
								<td id="str25"><p align="center"><%=map.get("str25") == null ? "" : map.get("str25")%>&nbsp;
									</p>
								</td>
							</tr>
							<tr>
								<td><p align="center">有效遏制一般A级交通事故</p>
								</td>
								<td><p align="center"><%=map.get("content26") == null ? "" : map.get("content26")%></p>
								</td>
								<td id="str26"><p align="center"><%=map.get("str26") == null ? "" : map.get("str26")%>&nbsp;
									</p>
								</td>
							</tr>
							<tr>
								<td><p align="center">杜绝民爆物品丢失事故（含丢失后找回）</p>
								</td>
								<td><p align="center"><%=map.get("content27") == null ? "" : map.get("content27")%></p>
								</td>
								<td id="str27"><p align="center"><%=map.get("str27") == null ? "" : map.get("str27")%>&nbsp;
									</p>
								</td>
							</tr>
							<tr>
								<td><p align="center">杜绝在公司年度HSE体系审核定级中被评定为C级</p>
								</td>
								<td><p align="center"><%=map.get("content28") == null ? "" : map.get("content28")%></p>
								</td>
								<td id="str28"><p align="center"><%=map.get("str28") == null ? "" : map.get("str28")%>&nbsp;
									</p>
								</td>
							</tr>
						</table>
					</div>
					<%if(ifHeath == "0" || "0".equals(ifHeath)){ %>
					<div id="tab_box_content3" class="tab_box_content"  style="display:none;height: 350px">
						<iframe src="<%=contextPath %>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pDStat&noLogin=admin&tokenId=admin&projectInfoNo=<%=healthInfoId %>" width="100%" height="100%" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
					</div>
					<%} %>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

