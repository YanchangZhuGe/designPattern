<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
 
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String healthInfoId=request.getParameter("healthInfoId");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	List<Map> list=OPCommonUtil.getProjectHealthInfo(healthInfoId);
    List xmList=OPCommonUtil.getEmName(project_info_no);
    int xMLeng=xmList.size()+3;
    int xmP=xmList.size()+1;
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
	//查询质量信息
	List quaList=OPCommonUtil.getwtquality(project_info_no);
	Map mapAcc = OPCommonUtil.getAccident(project_info_no);
	List<Map<String,String>> hse = OPCommonUtil.getHse(project_info_no);
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
								<th  width="30%"><p align="center">指标值</p></th>
								<th  width="50%"><p align="center">考核标准</p></th>
							</tr>
							<tr>
								<td rowspan="<%=xMLeng %>"><p align="center">进度</p>
								</td>
								<td rowspan="<%=xmP%>"><p align="center">计划偏离度</p>
								</td>
							</tr>
							<%
							 for(int j=0;j<xmList.size();j++){
								 Map strXm=(Map)xmList.get(j);
							%>
							<tr>
								<td><p align="center"><%=strXm.get("codingName") %></p></td>
								<td><p align="center"><a style="color: black" onclick="openChart()" ><%=strXm.get("num") %></a></p></td>
								<td><p align="center"><%=strXm.get("remark") %></p></td>
							</tr>
				 			<%}%>
						</table>
					</div>
					<div id="tab_box_content1" class="tab_box_content"  style="display:none;">
						<table width="100%" border="4" style="border: thick;" cellspacing="1" cellpadding="1">
							<tr background="blue" class="bt_info">
								<th   width="10%"><p align="center">勘探方法</p>
								</th>
								<th   width="10%"><p align="center">指标名称</p>
								</th>
								<th   width="20%"><p align="center">实际值</p>
								</th>
								<th   width="60%"><p align="center">考核值</p>								
								</th>
							</tr>
							<%
							for(int j=0;j<quaList.size();j++){
								 Map map_=(Map)quaList.get(j);
							%>
							<tr>
								<td rowspan="4"><p align="center"><%=map_.get("codingName").toString() %></p></td>
								<td><p align="center">一级品率</p></td>
								<td><p align="center"><%=map_.get("rat1").toString()+"%" %></p></td>
								<td><p align="center"><%=map_.get("firstlevelRadio").toString()+"%" %></p></td>
							</tr>
							<tr>
								<td><p align="center">合格品率</p></td>
								<td><p align="center"><%=map_.get("rat2").toString()+"%" %></p></td>
								<td><p align="center"><%=map_.get("qualifiedRadio").toString()+"%" %></p></td>
							</tr>
							<tr>
								<td><p align="center">废品率</p></td>
								<td><p align="center"><%=map_.get("rat3").toString()+"%" %></p></td>
								<td><p align="center"><%=map_.get("wasterRadio").toString()+"%" %></p></td>
							</tr>
							<tr>
								<td><p align="center">空点率</p></td>
								<td><p align="center"><%=map_.get("rat4").toString()+"%" %></p></td>
								<td><p align="center"><%=map_.get("missRadio").toString()+"%" %></p></td>
							</tr>
							<%}%>
							
							<tr>
								<td  colspan="2"><p align="center">质量事故分级</p></td>
								<td id="str20">
								<a style="color: black" onclick="openPM()" >
								<p align="center"><%=mapAcc.get("heathContent").toString()%>&nbsp;</p>
								</a>
								</td>
								<td><p align="center">发生一般质量事故、较大质量事故、重大质量事故或特大质量事故时亮红灯</p></td>
							</tr>
							
						</table>
					</div>
					<div id="tab_box_content2" class="tab_box_content"  style="display:none;">
						<table width="100%" border="4" style="border: thick;" cellspacing="1" cellpadding="1">
							<tr background="blue" class="bt_info">
								<th   width="10%"><p align="center">标题</p>
								</th>
								<th   width="40%"><p align="center">指标名称</p>
								</th>
								<th   width="10%"><p align="center">内容</p>
								</th>
								<th   width="40%"><p align="center">标准</p>
								</th>
							</tr>
							<tr>
								<td rowspan="4"><p align="center">控制性指标</p></td>
								<td><p align="center">隐患整改率</p></td>
								<td><p align="center"><%=hse.get(0).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(0).get("heathStandard")%></p></td>
							</tr>
							<tr>
								<td><p align="center">工业生产重伤人数</p></td>
								<td><p align="center"><%=hse.get(1).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(1).get("heathStandard")%></p></td>
							</tr>
							<tr>
								<td><p align="center">轻微环境污染和生态破坏起数</p>
								<td><p align="center"><%=hse.get(2).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(2).get("heathStandard")%></p></td>
							</tr>
							<tr>
								<td><p align="center">百万工时损工伤亡发生率（LTIF）</p></td>
								<td><p align="center"><%=hse.get(3).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(3).get("heathStandard")%></p></td>
							</tr>

							<tr>
								<td rowspan="4"><p align="center">杜绝性指标（发生即为红色）</p></td>
								<td><p align="center">杜绝一般A级及以上工业生产事故、火灾事故、环境污染或生态破坏事故</p></td>
								<td><p align="center"><%=hse.get(4).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(4).get("heathStandard")%></p></td>
							</tr>
							<tr>
								<td><p align="center">有效遏制一般A级交通事故</p></td>
								<td><p align="center"><%=hse.get(5).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(5).get("heathStandard")%></p></td>
							</tr>
							<tr>
								<td><p align="center">杜绝民爆物品丢失事故（含丢失后找回）</p></td>
								<td><p align="center"><%=hse.get(6).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(6).get("heathStandard")%></p></td>
							</tr>
							<tr>
								<td><p align="center">杜绝在公司年度HSE体系审核定级中被评定为C级</p></td>
								<td><p align="center"><%=hse.get(7).get("heathContent")%></p></td>
								<td><p align="center"><%=hse.get(7).get("heathStandard")%></p></td>
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


