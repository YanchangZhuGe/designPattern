<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user=OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String projectName=user.getProjectName();
	List<Map> list=OPCommonUtil.getProjectHealthInfo(projectInfoNo);
	Map mapColor=OPCommonUtil.getProjectHealthColor(projectInfoNo);
	Map map=new HashMap();
	int i=0;
	for(Map temp : list){
		i++;
		map.put("str"+i, temp.get("heath_content"));
		map.put("content"+i, temp.get("heath_standard"));
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
	<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

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
	function refreshData() {
		newClose();
	}
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3" >
	
	<div id="new_table_box">
		<table id="mytable" style="background-color: transparent">
			<tr style="background-color: transparent">
				<td style="background-color: transparent;" >
				<p align="center" style="color: blue">项目名称：<%=projectName%>&nbsp;&nbsp;&nbsp;&nbsp;
				生产：<img src="<%=contextPath%>/pm/projectHealthInfo/<%=mapColor.get("pm_info")%>.gif" alt=""  width="14px" height="14px"/>
				质量：<img src="<%=contextPath%>/pm/projectHealthInfo/<%=mapColor.get("qm_info")%>.gif" alt=""  width="14px" height="14px"/>
				HSE：<img src="<%=contextPath%>/pm/projectHealthInfo/<%=mapColor.get("hse_info")%>.gif" alt=""  width="14px" height="14px"/>
				</p>
				</td>
			</tr>
		</table>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">生产</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">质量</a></li>
				<li id="tag3_2"><a href="#" onclick="getTab3(2)">HSE</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<table id="mytable" width="100%">
					<tr>
						<th width="5%"><p align="center">标题</p></th>
						<th colspan="2" width="20%"><p align="center">指标名称</p></th>
						<th width="50%"><p align="center">标准</p>
						</th>
						<th width="30%"><p align="center">内容</p>
						</th>
					</tr>
					<tr>
						<td rowspan="5"><p align="center">进度</p></td>
						<td rowspan="3"><p align="center">计划偏离度</p></td>
						<td><p align="center">测量</p>
						</td>
						<td rowspan="3"><p align="center"><%=map.get("content1") == null ? "" : map.get("content1")%>&nbsp;
							</p>
						</td>
						<td><%=map.get("str1") == null ? "" : map.get("str1")%>&nbsp;</td>
					</tr>
					<tr>
						<td><p align="center">钻井</p>
						</td>
						<td><%=map.get("str2") == null ? "" : map.get("str2")%>&nbsp;</td>
					</tr>
					<tr>
						<td>采集</td>
						<td><%=map.get("str3") == null ? "" : map.get("str3")%>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">生产效率</p></td>
						<td><p align="center"><%=map.get("content4") == null ? "" : map.get("content4")%></p>
						</td>
						<td><p align="center"><%=map.get("str4") == null ? "" : map.get("str4")%>%&nbsp;
							</p>
						</td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">里程碑时间结点</p></td>
						<td><p align="center"><%=map.get("content5") == null ? "" : map.get("content5")%>&nbsp;
							</p></td>
						<td><p align="center"><%=map.get("str5") == null ? "" : map.get("str5")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td rowspan="2"><p align="center">人员</p></td>
						<td colspan="2"><p align="center"><%=map.get("content6") == null ? "" : map.get("content6")%></p></td>
						<td><p align="center"><%=map.get("content6") == null ? "" : map.get("content6")%>&nbsp;
							</p></td>
						<td><p align="center"><%=map.get("str6") == null ? "" : map.get("str6")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">操作技能</p></td>
						<td><p align="center"><%=map.get("content7") == null ? "" : map.get("content7")%>&nbsp;
							</p></td>
						<td><p align="center"><%=map.get("str7") == null ? "" : map.get("str7")%>%&nbsp;
							</p></td>
					</tr>
					<tr>
						<td rowspan="3"><p align="center">设备</p></td>
						<td colspan="2"><p align="center">设备完好率</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><p align="center"><%=map.get("str8") == null ? "" : Double.parseDouble((String)map.get("str8"))%>%&nbsp;
							</p></td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">利用率</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><p align="center"><%=map.get("str9") == null ? "" : Double.parseDouble((String)map.get("str9"))%>%&nbsp;
							</p></td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">设备事故发生起数</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><p align="center"><%=map.get("str10") == null ? "" : map.get("str10")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td rowspan="4"><p align="center">关键物资</p></td>
						<td colspan="2"><p align="center">84、85#</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><p align="center"><%=map.get("str11") == null ? "" : map.get("str11")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">燃油</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><%=map.get("str12") == null ? "" : map.get("str12")%>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">炮线 </p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><%=map.get("str13") == null ? "" : map.get("str13")%>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><p align="center">物资质量</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td><p align="center"><%=map.get("str14") == null ? "" : map.get("str14")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td><p align="center">生产组织</p></td>
						<td><p align="center">&nbsp;</p></td>
						<td colspan="3"><p align="center"><%=map.get("str15")==null?"":map.get("str15")%>&nbsp;
							</p></td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="100%" border="4" style="border: thick;" cellspacing="1" cellpadding="1">
					<tr background="blue" class="bt_info">
						<th width="10%"><p align="center">标题</p></th>
						<th width="10%"><p align="center">指标名称</p></th>
						<th width="20%"><p align="center">标准</p></th>
						<th width="60%"><p align="center">内容</p></th>
					</tr>
					<tr>
						<td rowspan="6"><p align="center">合同要求指标</p>
						</td>
						<td><p align="center">合格率</p>
						</td>
						<td><p align="center"><%=map.get("content16") == null ? "" : map.get("content16")%>%
							</p>
						</td>
						<td><%=map.get("str16") == null ? "" : Double.parseDouble((String)map.get("str16"))%>%&nbsp;</td>
					</tr>
					<tr>
						<td><p align="center">一级品率</p>
						</td>
						<td><p align="center"><%=map.get("content17") == null ? "" : map.get("content17")%>%
							</p>
						</td>
						<td><%=map.get("str17") == null ? "" : Double.parseDouble((String)map.get("str17"))%>%&nbsp;</td>
					</tr>
					<tr>
						<td><p align="center">空炮率</p>
						</td>
						<td><p align="center"><%=map.get("content18") == null ? "" : map.get("content18")%>%
							</p>
						</td>
						<td><%=map.get("str18") == null ? "" : Double.parseDouble((String)map.get("str18"))%>%&nbsp;</td>
					</tr>
					<tr>
						<td><p align="center">废炮率</p>
						</td>
						<td><p align="center"><%=map.get("content19") == null ? "" : map.get("content19")%>%
							</p>
						</td>
						<td><%=map.get("str19") == null ? "" : Double.parseDouble((String)map.get("str19"))%>%&nbsp;</td>
					</tr>
					<tr>
						<td><p align="center">质量事故分级</p>
						</td>
						<td colspan="2"><p align="center"><%=map.get("str20") == null ? "" : map.get("str20")%>&nbsp;
							</p>
						</td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table width="100%" border="4" style="border: thick;" cellspacing="1" cellpadding="1">
					<tr background="blue" class="bt_info">
						<th width="10%"><p align="center">标题</p></th>
						<th width="10%"><p align="center">指标名称</p></th>
						<th width="40%"><p align="center">标准</p></th>
						<th width="40%"><p align="center">内容</p></th>
					</tr>
					<tr>
						<td rowspan="4"><p align="center">控制性指标</p></td>
						<td><p align="center">隐患整改率</p></td>
						<td><p align="center"><%=map.get("content21") == null ? "" : map.get("content21")%></p></td>
						<td><p align="center"><%=map.get("str21") == null ? "" : String.valueOf(Double.parseDouble((String)map.get("str21")))+"%"%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td><p align="center">工业生产重伤人数</p></td>
						<td><p align="center"><%=map.get("content22") == null ? "" : map.get("content22")%></p></td>
						<td><p align="center"><%=map.get("str22") == null ? "" : map.get("str22")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td><p align="center">轻微环境污染和生态破坏起数</p>
							<td><p align="center"><%=map.get("content23") == null ? "" : map.get("content23")%></p></td>
							<td><p align="center"><%=map.get("str23") == null ? "" : map.get("str23")%>&nbsp;
								</p></td>
					</tr>
					<tr>
						<td><p align="center">百万工时损工伤亡发生率（LTIF）</p>
						</td>
						<td><p align="center"><%=map.get("content24") == null ? "" : map.get("content24")%></p>
						</td>
						<td><p align="center"><%=map.get("str24") == null ? "" : map.get("str24")%>&nbsp;
							</p></td>
					</tr>

					<tr>
						<td rowspan="4"><p align="center">杜绝性指标（发生即为红色）</p></td>
						<td><p align="center">杜绝一般A级及以上工业生产事故、火灾事故、环境污染或生态破坏事故</p></td>
						<td><p align="center"><%=map.get("content25") == null ? "" : map.get("content25")%></p></td>
						<td><p align="center"><%=map.get("str25") == null ? "" : map.get("str25")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td><p align="center">有效遏制一般A级交通事故</p></td>
						<td><p align="center"><%=map.get("content26") == null ? "" : map.get("content26")%></p></td>
						<td><p align="center"><%=map.get("str26") == null ? "" : map.get("str26")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td><p align="center">杜绝民爆物品丢失事故（含丢失后找回）</p></td>
						<td><p align="center"><%=map.get("content27") == null ? "" : map.get("content27")%></p></td>
						<td><p align="center"><%=map.get("str27") == null ? "" : map.get("str27")%>&nbsp;
							</p></td>
					</tr>
					<tr>
						<td><p align="center">杜绝在公司年度HSE体系审核定级中被评定为C级</p></td>
						<td><p align="center"><%=map.get("content28") == null ? "" : map.get("content28")%></p></td>
						<td><p align="center"><%=map.get("str28") == null ? "" : map.get("str28")%>&nbsp;
							</p></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	$(document).ready(readyForSetHeight);

frameSize();
</script>

</html>

