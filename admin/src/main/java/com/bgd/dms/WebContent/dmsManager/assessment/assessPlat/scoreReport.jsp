<%@page import="com.bgp.dms.assess.IServ.impl.Plat_scoreSrv"%>
<%@page import="com.bgp.dms.assess.IServ.IPlat_scoreSrv"%>
<%@page import="com.cnpc.jcdp.dao.PageModel"%>
<%@page import="com.bgp.dms.assess.IServ.IElementDetailServ"%>
<%@page import="com.bgp.dms.assess.IServ.impl.ElementDetailServ"%>
<%@page import="com.bgp.dms.assess.util.AssessTools"%>
<%@page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.List"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
String contextPath = request.getContextPath();
//首页显示标识，此值为0则隐藏返回按钮
String indexFlag = request.getParameter("indexFlag")==null?"":request.getParameter("indexFlag");
UserToken user = OMSMVCUtil.getUserToken(request);
String orgId = user.getCodeAffordOrgID();
String orgSubId = user.getSubOrgIDofAffordOrg();
ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);//基础对象
String methodID = AssessTools.valueOf(resultMsg.getValue("methodID"), "");
String tipMsg = AssessTools.valueOf(resultMsg.getValue("markMsg"), "");
PageModel detailPage = AssessTools.getPage(resultMsg, "20");//初始化page对象
List<MsgElement> datas = resultMsg.getMsgElements("datas");//考核要素数据集
/**
获取考核数据集合条数
**/
int size = 0;
if(datas!=null){
	size = datas.size();
}
String modelID = resultMsg.getValue("modelID");//模板id
modelID = AssessTools.valueOf(modelID, resultMsg.getValue("modelid".toLowerCase()));
String MODEL_NAME = resultMsg.getValue("MODEL_NAME");//模板名称
MODEL_NAME = AssessTools.valueOf(MODEL_NAME, resultMsg.getValue("MODEL_NAME".toLowerCase()));
String MODEL_TYPE= resultMsg.getValue("MODEL_TYPE");//模板类型
MODEL_TYPE = AssessTools.valueOf(MODEL_TYPE, resultMsg.getValue("MODEL_TYPE".toLowerCase()));
String MODEL_TITLE= resultMsg.getValue("MODEL_TITLE");//模板title名称
MODEL_TITLE = AssessTools.valueOf(MODEL_TITLE, resultMsg.getValue("MODEL_TITLE".toLowerCase()));

String REMARK_plat = resultMsg.getValue("REMARK");//备注
REMARK_plat = AssessTools.valueOf(REMARK_plat, resultMsg.getValue("REMARK".toLowerCase()));
String SPARE1= resultMsg.getValue("SPARE1");//预留字段1
SPARE1 = AssessTools.valueOf(SPARE1, resultMsg.getValue("SPARE1".toLowerCase()));
String SPARE2= resultMsg.getValue("SPARE2");//预留字段2
SPARE2 = AssessTools.valueOf(SPARE2, resultMsg.getValue("SPARE2".toLowerCase()));

String ASSESS_ORG_ID = resultMsg.getValue("ASSESS_ORG_ID");//被审核单位id
ASSESS_ORG_ID = AssessTools.valueOf(ASSESS_ORG_ID, resultMsg.getValue("ASSESS_ORG_ID".toLowerCase()));
String ASSESS_ORG_NAME = resultMsg.getValue("ASSESS_ORG_NAME");//被审核单位名称
ASSESS_ORG_NAME = AssessTools.valueOf(ASSESS_ORG_NAME, resultMsg.getValue("ASSESS_ORG_NAME".toLowerCase()));
String ASSESS_USER_ID = resultMsg.getValue("ASSESS_USER_ID");//审核人员ID
ASSESS_USER_ID = AssessTools.valueOf(ASSESS_USER_ID, resultMsg.getValue("ASSESS_USER_ID".toLowerCase()));
String ASSESS_USER_NAME = resultMsg.getValue("ASSESS_USER_NAME");//审核人员姓名
ASSESS_USER_NAME = AssessTools.valueOf(ASSESS_USER_NAME, resultMsg.getValue("ASSESS_USER_NAME".toLowerCase()));
String ASSESS_START_DATE = resultMsg.getValue("ASSESS_START_DATE");//审核开始时间
ASSESS_START_DATE = AssessTools.valueOf(ASSESS_START_DATE, resultMsg.getValue("ASSESS_START_DATE".toLowerCase()));

String ASSESS_END_DATE = resultMsg.getValue("ASSESS_END_DATE");//审核结束时间
ASSESS_END_DATE = AssessTools.valueOf(ASSESS_END_DATE, resultMsg.getValue("ASSESS_END_DATE".toLowerCase()));

String CREATE_ORG_ID = resultMsg.getValue("CREATE_ORG_ID");//创建人单位
CREATE_ORG_ID = AssessTools.valueOf(CREATE_ORG_ID, resultMsg.getValue("CREATE_ORG_ID".toLowerCase()));

String CREATOR = resultMsg.getValue("CREATOR");//创建人
CREATOR = AssessTools.valueOf(CREATOR, resultMsg.getValue("CREATOR".toLowerCase()));

String scoreID= resultMsg.getValue("scoreID");//评分id
scoreID = AssessTools.valueOf(scoreID, resultMsg.getValue("scoreID".toLowerCase()));
String flag= resultMsg.getValue("flag");//操作标志
String excelName = "";
if("createMarkScoreList".equals(methodID)){
	excelName = MODEL_TITLE + "_问题清单";
}else{
	excelName = MODEL_TITLE;
}
/* String remark = resultMsg.getValue("remark");//备注
String spare1 = resultMsg.getValue("spare1");//备注1
String spare2 = resultMsg.getValue("spare2");//备注2 */

%>
<!DOCTYPE html> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/assess.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>考核模板(<%=MODEL_NAME %>)</title>

<script type="text/javascript">
var indexFlag = '<%=indexFlag %>';

$().ready(function(){
	//首页显示隐藏返回按钮
    if(indexFlag == "0"){
    	$(".fh").hide();
    }
});

function replaceAllBlank(str,blankFlag){
	var result = "";
	if(str.indexOf(blankFlag)!=-1){
		result = str.replace(" ","");
		result = replaceAllBlank(result," ");
	}
	return result;
}
//将div导出到excel中
function exportToExcel(divid){
var curTbl = document.getElementById(divid);
var oXL;
try{
        oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel 
}catch(e){
        alert("无法启动Excel!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用");
        return false;
}
var oWB = oXL.Workbooks.Add(); //获取workbook对象
var oSheet = oWB.ActiveSheet;//激活当前sheet 
var sel = document.body.createTextRange();
sel.moveToElementText(curTbl); //把表格中的内容移到TextRange中
sel.select(); //全选TextRange中内容 
sel.execCommand("Copy");//复制TextRange中内容 
oSheet.Paste();//粘贴到活动的EXCEL中
oXL.Visible = true; //设置excel可见属性

var fname = oXL.Application.GetSaveAsFilename("<%=excelName==null?"":excelName%>.xls", "Excel Spreadsheets (*.xls), *.xls");
oWB.SaveAs(fname);
oWB.Close();
oXL.Quit();
}
</script>
</head>

<body style="background: #fff" >
	<form action="<%=contextPath%>/assess/createScoreReport.srq"
		method="post" name="form1" onsubmit="toSubmit()">
		
<div id="table_box_0" >
		<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align = "center">
			<tr>
				
				<td background="<%=contextPath%>/images/list_15.png" colspan="15">
					<table width="100%" border="0" cellspacing="0" cellpadding="0"  background="<%=contextPath%>/images/list_15.png">
						<tr>
						<td class="ali_cdn_name"  colspan="2"  width="20%">
							模板类型:
						</td>
				  		<td class="ali_cdn_input" width="100">
							<%=MODEL_NAME==null?"": MODEL_NAME %>
						</td>
						
						<td   width="200" colspan="2" align="right">被审核单位：</td>
						<td  colspan="2" class="ali_cdn_input" width="20%">
							<%=ASSESS_ORG_NAME==null?"": ASSESS_ORG_NAME %>
				        </td>
				        
				        <td  width="200"  colspan="2"  class="ali_cdn_name" align="right">&nbsp;审核人:</td>
						<td class="ali_cdn_input" width="10%"  colspan="2" align="left">
							<%=user.getUserName()%>
						</td>
					    <td  colspan="2"  width="200" class="ali_cdn_name" align="right">审核时间：</td>
				 	    <td class="ali_cdn_input"  width="20%" colspan="2">
				 	    	<%=ASSESS_START_DATE==null?"": ASSESS_START_DATE %>
				 	    </td>
				 	    			 	    	
				 	    <td  class="ali_cdn_name" style="width:10px;">至</td>
				 	    <td class="ali_cdn_input"   width="20%"  colspan="2">
				 	    	<%=ASSESS_END_DATE==null?"": ASSESS_END_DATE %>
				 	    </td>
						
						<auth:ListButton functionId="" css="dc"
										event="onclick='exportToExcel(\"table_box_0\")'" title="导出excel"></auth:ListButton>
					  	<auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="JCDP_btn_back"></auth:ListButton>
					  	</tr>
					</table>
				</td>
				
				</tr>
			</table>
			</div>
			<% 
if("createMarkScoreList".equals(methodID)){
	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align = "center">
	<tr>
		<td  align="center"  colspan="15">
		<font style="font-size: 20px;line-height: 5;color: #ff0000">
		<%=tipMsg==null?"":tipMsg%>
		
		</font>
		
		</td>
		</tr>
	</table>
	<%
}
			if(size>0){
			%>
			<table align = "center" id="model_title_table">
		<tr>
		<td id="model_title_" align="center" style="font-size: 20px" colspan="15">
		<%=MODEL_TITLE==null?"":MODEL_TITLE%>
		
		</td>
		</tr>
		
		</table>
		<div id="table_box_div" style="overflow-x:auto;overflow-y:auto;word-wrap:break-word;word-break:normal;" >
				<table width="98%" border="1" cellspacing="2" cellpadding="1"
					class="tab_info" id="queryRetTable">
					<tr bgcolor="#aaaaaa">
						<!-- <td width="50px">选择</td> -->
						<td width="80px">要素</td>
						<%
						if("view".equals(flag)==false){
							%>
							<td width="50px">是否问题</td>
							<%
						}
						%>
						
						
						<td width="200px">审核内容</td>
						<td width="200px">审核部门</td>
						<td width="80px">事实描述（记录）</td>
						<td width="400px">评分标准</td>
						<td width="10px">标准分数</td>
						<td width="10px">单项扣分</td>
						<td width="10px">要素实际得分</td>
						<td width="10px">要素综合得分</td>
						<td width="300px">集团公司检查项目</td>
						<td width="300px">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						检查内容&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td width="50px">标准分</td>
						<td width="50px">检查得分</td>
						<!-- <td width="10px">得分</td> -->
						<!-- <td width="50px">备注</td> -->
						
					</tr>
					<%
					IPlat_scoreSrv scoreSrv = new Plat_scoreSrv();
					IElementDetailServ detailServ = new ElementDetailServ();
					
					List groupDetailList = null;
					List standardDetailList = null;
					List standard_TotalScoreList = null;
					int groupDetailList_Size = 0;
					int standardDetailList_Size = 0;
					int standard_TotalScoreListSize = 0;
					
					if("view".equals(flag)){
						
						groupDetailList = scoreSrv.findAllDetailScoreListByPlatScoreID("1",scoreID);
						
						standardDetailList = detailServ.findAllDetailsByModelID("0",modelID);
						//out.println("standardDetailList=" + standardDetailList);
						standard_TotalScoreList = detailServ.getTotalDetailsScoresByModelID("0",modelID);
					}
					
					if(groupDetailList!=null){
						groupDetailList_Size = groupDetailList.size();
					}
					if(standardDetailList!=null){
						standardDetailList_Size = standardDetailList.size();
						//out.println("standardDetailList_Size=" + standardDetailList_Size);
					}
					
					if(standard_TotalScoreList!=null){
						standard_TotalScoreListSize = standard_TotalScoreList.size();
					}
					int s_score_Standard = 0;//标准分数
				    int s_score_group = 0;//标准分(集团)
									    for(int i = 0;i<size;i++){
									    	MsgElement e = datas.get(i);
									    	Map m = e.toMap();
									    	String assess_id = AssessTools.valueOf(m.get("assess_id"), "");
									    	String assess_name = AssessTools.valueOf(m.get("assess_name"), "");
									    	String assess_content = AssessTools.valueOf(m.get("assess_content"), "");
									    	//List detailList_standard = detailServ.findElementDetailByEleID(assess_id, "", detailPage,"0");
									    	
											//int standardSize = detailList_standard.size();
											
											String eleSCORE_ID = AssessTools.valueOf(m.get("SCORE_ID".toLowerCase()), "");
											
									    	String FACT_DESC = AssessTools.valueOf(m.get("FACT_DESC".toLowerCase()), "");
									    	String e_ASSESS_ORG_ID = AssessTools.valueOf(m.get("ASSESS_ORG_ID".toLowerCase()), "");
									    	String e_ASSESS_ORG_NAME = AssessTools.valueOf(m.get("ASSESS_ORG_NAME".toLowerCase()), "");
									    	String DEDUCT_ACORE_DESC = AssessTools.valueOf(m.get("DEDUCT_ACORE_DESC".toLowerCase()), "");
									    	String ITEM_DEDUCT_SCORE = AssessTools.valueOf(m.get("ITEM_DEDUCT_SCORE".toLowerCase()), "");
									    	String ITEM_FACT_SCORE = AssessTools.valueOf(m.get("ITEM_FACT_SCORE".toLowerCase()), "");
									    	String ITEM_COMPRE_SCORE = AssessTools.valueOf(m.get("ITEM_COMPRE_SCORE".toLowerCase()), "");
									    	String ITEM_SUM_SCORE = AssessTools.valueOf(m.get("ITEM_SUM_SCORE".toLowerCase()), "");
									    	String ITEM_SCORE = AssessTools.valueOf(m.get("ITEM_SCORE".toLowerCase()), "");
									    	String DEDUCT_ITEM_SCORE = AssessTools.valueOf(m.get("DEDUCT_ITEM_SCORE".toLowerCase()), "");
									    	String ELEMENT_SCORE = AssessTools.valueOf(m.get("ELEMENT_SCORE".toLowerCase()), "");
									    	String CHECK_SUM_SCORE = AssessTools.valueOf(m.get("CHECK_SUM_SCORE".toLowerCase()), "");
									    	String e_CREATE_ORG_ID = AssessTools.valueOf(m.get("CREATE_ORG_ID".toLowerCase()), "");
									    	String e_CREATOR = AssessTools.valueOf(m.get("CREATOR".toLowerCase()), "");
									    	String e_CREATE_DATE = AssessTools.valueOf(m.get("CREATE_DATE".toLowerCase()), "");
									    	String MODIFIER = AssessTools.valueOf(m.get("MODIFIER".toLowerCase()), "");
									    	String MODIFY_DATE = AssessTools.valueOf(m.get("MODIFY_DATE".toLowerCase()), "");
									    	String ASSESS_NAME = AssessTools.valueOf(m.get("ASSESS_NAME".toLowerCase()), "");
									    	String ASSESS_STAND_SCORE = AssessTools.valueOf(m.get("ASSESS_STAND_SCORE".toLowerCase()), "");
									    	String ASSESS_SCORE = AssessTools.valueOf(m.get("ASSESS_SCORE".toLowerCase()), "");	
									    	String ASSESS_CONTENT = AssessTools.valueOf(m.get("ASSESS_CONTENT".toLowerCase()), "");	
									    	String ELEMENT_ID = AssessTools.valueOf(m.get("ELEMENT_ID".toLowerCase()), "");	
									    	String REMARK = AssessTools.valueOf(m.get("REMARK".toLowerCase()), "");	
									    	String isMark = AssessTools.valueOf(m.get("isMark".toLowerCase()), "");	
									    	
									    	for(int k=0;k<standard_TotalScoreListSize;k++){
									    		Map tMap = (Map)standard_TotalScoreList.get(k);
									    		if(tMap.get("ELEMENT_ID".toLowerCase()).toString().equals(assess_id)){
									    			s_score_Standard = Integer.parseInt(AssessTools.valueOf(tMap.get("STANDARD_SCORE".toLowerCase()), "0"));
									    		}
									    	}
									    	
											boolean isInput = false;
											String visibility = "";
											if(assess_content!=null){
												if(!assess_content.replace(" ", "").equals("")){
													isInput = true;
												}
											}
											if(isInput){
												visibility = "visibility";
											}else{
												visibility = "hidden";
											}
											boolean isInput_group = false;
											String visibility_group = "hidden";
											
											String tr_color = "";
											if(i%2==0){
												tr_color = "#cccccc";
											}else{
												tr_color = "#778899";
											}
											String checked = "";
											if("1".equals(isMark)){
												tr_color = "#dc143c";
												checked = "checked";
											}
					%>
					<tr bgcolor="<%=tr_color%>">
						<td>
						<%=assess_name%>
						</td>
						<%
						if("view".equals(flag)==false){
							%>
							<td width="50px"  align="center">
						<div style="visibility: <%=visibility%>">
						<%
						String tip = "否";
						if("checked".equals(checked)){
							tip = "是";
						}
						out.print(tip);
						%>
						
						</div>
						</td>
							<%
						}
						%>
						
						<td width="400px">
						<!-- 审核内容 -->
						<font class="content_info">
						<%
						assess_content = assess_content.replace("；", "；<br>");	
						assess_content = assess_content.replace("。", "；<br>");
						
						String multiStr = AssessTools.newLinesBySeparator(assess_content,"<br>", 12);
										assess_content = assess_content.replace("<br>", "");
										 multiStr = multiStr.replace("2、<p>、", "2、").replace("3、<p>", "3、");
										multiStr = multiStr.replace("4、<p>", "4、").replace("5、<p>", "5、");
										multiStr = multiStr.replace("2<p>、", "2、").replace("3<p>、", "3、");
										multiStr = multiStr.replace("4<p>、", "4、").replace("5<p>、", "5、");
										multiStr = multiStr.replace("； 2", "<p>； 2").replace("； 3", "<p>； 3");
										multiStr = multiStr.replace("； 4", "<p>； 4").replace("； 5", "<p>； 5");
										multiStr = multiStr.replace("2、", "<p>2、").replace("3、", "<p>3、");
										multiStr = multiStr.replace("4、", "<p>4、").replace("5、", "<p>5、");
										multiStr = multiStr.replace(" ", "").replace("<br>\n<br>", "<p>");
										multiStr = multiStr.replace("<p><p>", "<p>").replace("；  ", "； <p>"); 
										multiStr = multiStr.replace("7", "<p>7").replace("6", "<p>6"); 
										multiStr = multiStr.replace("7</p><p>", "7").replace("6</p><p>", "6"); 
										out.print(multiStr);
						%>
						</font>
						</td>
						<td width="200px">
						<!-- 审核部门 -->
						<div style="visibility: <%=visibility%>">
						<%=e_ASSESS_ORG_NAME==null?"":e_ASSESS_ORG_NAME %>
					   	</div>
						</td>
						<td width="100px">
						<!-- 事实描述（记录） -->
						<div style="visibility: <%=visibility%>">
						
						<%=FACT_DESC==null?"":FACT_DESC %>
						</div>
						</td>
						<td width="200" style="word-break: break-all">
						<!-- 评分标准 -->
						<div>
							<table >
							<%
								//评分标准
								for(int j = 0;j<standardDetailList_Size;j++){
									Map detailMap = (Map)standardDetailList.get(j);
									if(detailMap.get("ELEMENT_ID".toLowerCase()).equals(assess_id)){
									String DETAIL_ID = AssessTools.valueOf(detailMap.get("DETAIL_ID".toLowerCase()), "");
									String CHECK_CONTENT = AssessTools.valueOf(detailMap.get("CHECK_CONTENT".toLowerCase()), "");
									String STANDARD_SCORE = AssessTools.valueOf(detailMap.get("STANDARD_SCORE".toLowerCase()), "");
									
									%>
									<tr>
									<td width="200" style="word-break: break-all">
									<!-- 评分标准 -->
									<font class="content_info">
									<%
										String CHECK_CONTENTline = CHECK_CONTENT.replace("<br>", "");
																String multiCHECKStr = AssessTools.newLines(CHECK_CONTENTline, 12);
																multiCHECKStr = multiCHECKStr.replace("2、<br>、", "2、").replace("3、<br>", "3、");
																multiCHECKStr = multiCHECKStr.replace("4、<br>", "4、").replace("5、<br>", "5、");
																multiCHECKStr = multiCHECKStr.replace("2<br>、", "2、").replace("3<br>、", "3、");
																multiCHECKStr = multiCHECKStr.replace("4<br>、", "4、").replace("5<br>、", "5、");
																multiCHECKStr = multiCHECKStr.replace("； 2", "<br>； 2").replace("； 3", "<br>； 3");
																multiCHECKStr = multiCHECKStr.replace("； 4", "<br>； 4").replace("； 5", "<br>； 5");
																multiCHECKStr = multiCHECKStr.replace("2、", "<br>2、").replace("3、", "<br>3、");
																multiCHECKStr = multiCHECKStr.replace("4、", "<br>4、").replace("5、", "<br>5、");
																multiCHECKStr = multiCHECKStr.replace(" ", "").replace("<br>\n<br>", "<br>");
																multiCHECKStr = multiCHECKStr.replace("<br>", "").replace("3</p><p>", "</p>3");
																out.print(multiCHECKStr);
									%>
									</font>
									</td>
									</tr>
									<%
								}
								}
							%>
							</table>
							&nbsp;&nbsp;&nbsp;&nbsp;
							</div>
							<!-- 评分标准 -->
						</td>
						<td width="10px" align="center">
						<!-- 标准分数 -->
						<div style="visibility: <%=visibility%>">
						<%=s_score_Standard%>
						</div>
						</td>
						<td width="10px" align="center">
						<!-- 单项扣分 -->
						<%
						String SINGLE_DEDUCT_ID = "SINGLE_DEDUCT_" + assess_id;
						%>
						<div style="visibility: <%=visibility%>">
						<%=ITEM_DEDUCT_SCORE==null||"".equals(ITEM_DEDUCT_SCORE)?0:ITEM_DEDUCT_SCORE %>
						</div>
						<!-- 单项扣分 -->
						</td>
						<td width="50px" align="center">
						<!-- 要素实际得分-->
						
						<div style="visibility: <%=visibility%>">
						<%=ITEM_FACT_SCORE==null?(s_score_Standard-Integer.parseInt(ITEM_DEDUCT_SCORE)):ITEM_FACT_SCORE %>
						</div>
						<!-- 要素实际得分-->
						</td>
						<td width="10px" align="center">
						<!--要素综合得分-->
						
						<div style="visibility: <%=visibility%>">
						<%=ITEM_COMPRE_SCORE==null?"":ITEM_COMPRE_SCORE %>
						</div>
						<!--要素综合得分-->
						</td>
						<td width="450" style="background-color: <%=tr_color %>" colspan="4">
						<!--集团公司检查项目 检查内容  标准分 -->
						<div>
							<%
								//循环集团评分子表 
													    		if(groupDetailList_Size>0){
													    			
							%>
							<table style="background-color: <%=tr_color%>" border="1" width="100%">
								<%
								boolean isSame = false;	
								for(int j = 0;j<groupDetailList_Size;j++){
									Map dm = (Map)groupDetailList.get(j);
									//System.out.println("dm="+dm);
									//out.print("dm="+dm);
									
									
									if("view".equals(flag)){
										isSame = dm.get("element_score_id".toLowerCase()).equals(eleSCORE_ID);
									} 
									
									if(isSame){
										String STANDARD_SCORE_group = AssessTools.valueOf(dm.get("STANDARD_SCORE".toLowerCase()), "");
							    		double s_score_group_detail = Double.parseDouble(AssessTools.valueOf(dm.get("s_score"), "0"));
							    		String DETAIL_ID = AssessTools.valueOf(dm.get("DETAIL_ID".toLowerCase()), "");
							    		String CHECK_ITEM = AssessTools.valueOf(dm.get("CHECK_ITEM".toLowerCase()), "");
							    		String CHECK_CONTENT = AssessTools.valueOf(dm.get("CHECK_CONTENT".toLowerCase()), "");						    		
							    		
							    		String SCORE_DETAIL_ID = AssessTools.valueOf(dm.get("SCORE_DETAIL_ID".toLowerCase()), "");						    		
							    		String CHECK_SCORE = AssessTools.valueOf(dm.get("CHECK_SCORE".toLowerCase()), "");	
							    		String detailNodeID = assess_id + "#" + DETAIL_ID;
										if(CHECK_SCORE==null||"".equals(CHECK_SCORE)||"0".equals(ITEM_DEDUCT_SCORE)){
											CHECK_SCORE = STANDARD_SCORE_group;
										}
								%>
								<tr>
									<td width="150" >
									<!-- 集团公司检查项目 -->
									<%=CHECK_ITEM%>
									</td>
									<td width="200" >
									<!-- 检查内容 -->
									<%
									CHECK_CONTENT.replace("；", "；<br>");
									CHECK_CONTENT = CHECK_CONTENT.replace("<br>", "");
									
										String CHECK_CONTENTStr = AssessTools.newLines(CHECK_CONTENT, 12);
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("2、<br>、", "2、").replace("3、<br>", "3、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("4、<br>", "4、").replace("5、<br>", "5、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("2<br>、", "2、").replace("3<br>、", "3、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("4<br>、", "4、").replace("5<br>、", "5、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("； 2", "<br>； 2").replace("； 3", "<br>； 3");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("； 4", "<br>； 4").replace("； 5", "<br>； 5");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("2、", "<br>2、").replace("3、", "<br>3、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("4、", "<br>4、").replace("5、", "<br>5、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace(" ", "").replace("<br>\n<br>", "<br>");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("<br><br>", "").replace("；  ", "；"); 
										out.print(CHECK_CONTENTStr);
										%>
									</td>
									<td width="50"  align="center">
									<!-- 标准分 --><%=STANDARD_SCORE_group%>
									</td>
									<td width="50"  align="center">
									<!-- 检查得分 -->
									
									<input type="hidden" name="group_detail_id" value="<%=detailNodeID%>"> 
									<input type="hidden" name="SCORE_DETAIL_ID" id="SCORE_DETAIL_ID" value="<%=SCORE_DETAIL_ID%>"> 
										<%
										String detailTag_ID = "detail_" + assess_id;
										%>
										
										<%=CHECK_SCORE==null?"":CHECK_SCORE %>
									</td>
								</tr>
								<%
									}
									
									
								}
								
								%>
								
							</table> &nbsp;&nbsp;&nbsp;&nbsp;<%
 	}

								%>
								</div>
<!--集团公司检查项目 检查内容  标准分 -->
<%
						String S_STANDARD_SCORE_group_ID = "S_STANDARD_SCORE_group_" + assess_id;
						%>
						</td>
						<%-- <td width="50px">
						<!-- 得分-->
						<%
						String ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + assess_id;
						%>
						<div style="visibility: <%=visibility_group%>">
						<%=ELEMENT_SCORE==null?"":ELEMENT_SCORE %>
						</div>
						</td> --%>
						<%-- <td width="50px">
						<!-- 备注-->
						<div style="visibility: <%=visibility%>">
						<%=REMARK==null?"":REMARK %>
						</div>
						</td> --%>
						
					</tr>
					<%
						}
					%>

				</table>
				<%
			}
				%>
				</div>
			</div>
		
	</form>

</body>
<script defer type="text/javascript">
	createNewTitleTable("queryRetTable","newTitleTable");
	resizeNewTitleTable("queryRetTable","newTitleTable")
	cruConfig.contextPath='<%=contextPath%>';
	var assesstype = '<%=MODEL_NAME%>';

	//设置表格高度
	function frameSize(){
		$("#table_box_div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#model_title_table").height()-8);
	}
	//页面初始化信息
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	}); 
	
	function toBack(){
		window.location.href='<%=contextPath%>/dmsManager/assessment/assessPlat/assessScoreList.jsp';
	}
	
	/**
	from:源table
	to:目的table
	**/
    function createNewTitleTable(from,to){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById(to);
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById(from);
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = to;
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable);//
		newTitleTable.style.top=y+"px";
			
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd_fix";
			}else{
				tr.cells[i].className="bt_info_even_fix";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}		
		document.getElementById("table_box_div").onscroll = resetNewTitleTablePos;		
	}
    function resizeNewTitleTable(from,to){
    	var queryRetTable = document.getElementById(from);
    	var newTitleTable = document.getElementById(to);
    	if(queryRetTable==null || newTitleTable==null) return;
    	newTitleTable.style.width = queryRetTable.clientWidth+"px";

    	var titleRow = queryRetTable.rows[0];
    	var newTitleRow = newTitleTable.rows[0];
    	for(var i=0;i<newTitleRow.cells.length;i++){
    		newTitleRow.cells[i].style.width=titleRow.cells[i].clientWidth+"px";
    	}
    }
    </script>
</html>