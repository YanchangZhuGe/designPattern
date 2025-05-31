<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page import="java.util.Set"%>
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
UserToken user = OMSMVCUtil.getUserToken(request);
ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);//基础对象
PageModel detailPage = AssessTools.getPage(resultMsg, "200");//初始化page对象
List<MsgElement> datas = resultMsg.getMsgElements("datas");//考核要素数据集
/**
获取考核结果集合条数
**/
int size = 0;
if(datas!=null){
	size = datas.size();
}
String modelID = resultMsg.getValue("ASSESS_MODEL_ID");//模板id
String ASSESS_ORG_ID = resultMsg.getValue("ASSESS_ORG_ID");//被审核单位
String ASSESS_ORG_NAME = resultMsg.getValue("ASSESS_ORG_NAME");//被审核单位名称
String ASSESS_USER_ID = resultMsg.getValue("ASSESS_USER_ID");//审核人员ID
String ASSESS_USER_NAME = resultMsg.getValue("ASSESS_USER_NAME");//审核人员姓名
String ASSESS_START_DATE = resultMsg.getValue("ASSESS_START_DATE");//审核开始时间
String ASSESS_END_DATE = resultMsg.getValue("ASSESS_END_DATE");//审核结束时间
String CREATE_ORG_ID = resultMsg.getValue("CREATE_ORG_ID");//创建人单位
String CREATOR = resultMsg.getValue("CREATOR");//创建人
String CREATE_DATE = resultMsg.getValue("CREATE_DATE");//创建日期
String MODEL_NAME = resultMsg.getValue("MODEL_NAME");//模板名称
String MODEL_TYPE= resultMsg.getValue("MODEL_TYPE");//模板类型
String MODEL_TITLE= resultMsg.getValue("MODEL_TITLE");//模板title名称
String scoreID= resultMsg.getValue("scoreID");//评分id

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>考核模板（<%=MODEL_NAME%>）
</title>
<script type="text/javascript">
/**
 * assessid 元素id
 detailid 子元素id
 score 子元素所占分数
 result:检查等分
 ITEM_FACT_SCORE_VALUE: 要素实 际得分
 score_Standard:要素总分
 s_score_groups:标准分
 result=ITEM_FACT_SCORE_VALUE/score_Standard*s_score_group
 */
function countDetailScore(assessid,detailid,score_Standard,s_score_group){
	var ITEM_FACT_SCORE_ID = "ITEM_FACT_SCORE_" + assessid;
	var ITEM_FACT_SCORE_VALUE = document.getElementById(ITEM_FACT_SCORE_ID).value;
	var detailTag = "detail_" + assessid;
	var detailValues = document.getElementsByName(detailTag);
	
	var result = ITEM_FACT_SCORE_VALUE/score_Standard*s_score_group;
	var ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + assessid;
	document.getElementById(ELEMENT_SCORE_ID).value = result;
	var ELEMENT_SCORE_VALUE = document.getElementById(ELEMENT_SCORE_ID).value;
	
	//alert("s_score_groups=" + s_score_groups);
}

/**
 * ITEM_FACT_SCORE_VALUE:要素实 际得分
   score_Standard:要素总分
   tagValue:要素扣分
   COMPRE_SCORE: 要素综合得分
   ITEM_FACT_SCORE_VALUE = score_Standard - tagValue
   ITEM_COMPRE_SCORE = ITEM_FACT_SCORE_VALUE/score_Standard*1000
 */
function countScore(tag,assessID,score_Standard){
	var tagID = tag + assessID;
	var tagValue = "";
	tagValue = document.getElementById(tagID).value;
	var ITEM_FACT_SCORE_ID = "ITEM_FACT_SCORE_" + assessID;
	var ITEM_FACT_SCORE_VALUE = score_Standard-tagValue;
	document.getElementById(ITEM_FACT_SCORE_ID).value=ITEM_FACT_SCORE_VALUE; 

	var ITEM_COMPRE_SCORE_ID = "ITEM_COMPRE_SCORE_" + assessID;
	var ITEM_COMPRE_SCORE_VALUE =ITEM_FACT_SCORE_VALUE/score_Standard*1000;
	document.getElementById(ITEM_COMPRE_SCORE_ID).value = ITEM_COMPRE_SCORE_VALUE;
	
   }
function getTextValue(param,paramValues,index,defaultValue){
	if(paramValues==null){
		return defaultValue;
	}
	if(paramValues!=null&&paramValues!=""&&paramValues.length>0){
		param = paramValues[index].value;
	}else{
		param=defaultValue;
	}
	return param;
}
function toSubmit(){
	var assess_ids = document.getElementsByName("assess_id");
	var SINGLE_DEDUCTS = document.getElementsByName("SINGLE_DEDUCT");//单项扣分
	var score_group_detail = document.getElementsByName("SINGLE_DEDUCT");
	var group_detail_scores = document.getElementsByName("group_detail_score");
	var group_detail_ids = document.getElementsByName("group_detail_id");
	var FACT_DESCS = document.getElementsByName("FACT_DESC");
	var DEDUCT_ACORE_DESCS = document.getElementsByName("DEDUCT_ACORE_DESC");
	var ITEM_FACT_SCORES = document.getElementsByName("ITEM_FACT_SCORE");
	var ITEM_COMPRE_SCORES = document.getElementsByName("ITEM_COMPRE_SCORE");
	var ITEM_SUM_SCORES = document.getElementsByName("ITEM_SUM_SCORE");
	var ITEM_SCORES = document.getElementsByName("ITEM_SCORE");
	var DEDUCT_ITEM_SCORES = document.getElementsByName("DEDUCT_ITEM_SCORE");
	var ELEMENT_SCORES = document.getElementsByName("ELEMENT_SCORE");
	var CHECK_SUM_SCORES = document.getElementsByName("CHECK_SUM_SCORE");
	var ELEMENT_DETAIL_IDS = document.getElementsByName("ELEMENT_DETAIL_ID");
	var CHECK_SCORES = document.getElementsByName("CHECK_SCORE");
	var REMARKS = document.getElementsByName("REMARK");
	var S_STANDARD_SCORE_groupS = document.getElementsByName("S_STANDARD_SCORE_group");
	var S_STANDARD_SCORES = document.getElementsByName("S_STANDARD_SCORE");
	
	var FACT_DESC="";
	var DEDUCT_ACORE_DESC="";
	var ITEM_FACT_SCORE="";
	var ITEM_COMPRE_SCORE="";
	var ITEM_SUM_SCORE="";
	var ITEM_SCORE="";
	var DEDUCT_ITEM_SCORE="";
	var ELEMENT_SCORE="";
	var CHECK_SUM_SCORE="";
	var ELEMENT_DETAIL_ID="";
	var group_detail_score="";
	var CHECK_SCORE="";
	var S_STANDARD_SCORE_group="";
	var S_STANDARD_SCORE="";
	var REMARK="";
	
	var FACT_DESCJson="";
	var DEDUCT_ACORE_DESCJson="";
	var ITEM_FACT_SCOREJson="";
	var ITEM_COMPRE_SCOREJson="";
	var ITEM_SUM_SCOREJson="";
	var ITEM_SCOREJson="";
	var DEDUCT_ITEM_SCOREJson="";
	var ELEMENT_SCOREJson="";
	var CHECK_SUM_SCOREJson="";
	var ELEMENT_DETAIL_IDJson="";
	var CHECK_SCOREJson="";
	var S_STANDARD_SCORE_groupJson="";
	var S_STANDARD_SCOREJson="";
	var REMARKJson="";
	
	var assessItemJson = ""
	var SINGLE_DEDUCTJson = "";
	var group_detailJson = "";
	var assessList = "";
	var group_detailList = "";
	var jsonDatas = "";
	var modelID = document.form1.modelID.value;
	var group_detail_idArray;
	var group_detail_assessID;
	var group_deital_id;
	var assess_id="";
	var singel_deduct="";
	var defaultValue = "\"\"";
	
	for (var i = 0; i< assess_ids.length; i++) {
		assess_id = getTextValue(assess_id,assess_ids,i,defaultValue);
		singel_deduct = getTextValue(singel_deduct,SINGLE_DEDUCTS,i,defaultValue);
		FACT_DESC = getTextValue(FACT_DESC,FACT_DESCS,i,defaultValue);
		DEDUCT_ACORE_DESC = getTextValue(DEDUCT_ACORE_DESC,DEDUCT_ACORE_DESCS,i,defaultValue);
		ITEM_FACT_SCORE = getTextValue(ITEM_FACT_SCORE,ITEM_FACT_SCORES,i,defaultValue);
		ITEM_COMPRE_SCORE = getTextValue(ITEM_COMPRE_SCORE,ITEM_COMPRE_SCORES,i,defaultValue);
		ITEM_SUM_SCORE = getTextValue(ITEM_SUM_SCORE,ITEM_SUM_SCORES,i,defaultValue);
		ITEM_SCORE = getTextValue(ITEM_SCORE,ITEM_SCORES,i,defaultValue);
		 DEDUCT_ITEM_SCORE = getTextValue(DEDUCT_ITEM_SCORE,DEDUCT_ITEM_SCORES,i,defaultValue);
		ELEMENT_SCORE = getTextValue(ELEMENT_SCORE,ELEMENT_SCORES,i,defaultValue);
		CHECK_SUM_SCORE = getTextValue(CHECK_SUM_SCORE,CHECK_SUM_SCORES,i,defaultValue);
		ELEMENT_DETAIL_ID = getTextValue(ELEMENT_DETAIL_ID,ELEMENT_DETAIL_IDS,i,defaultValue); 
		S_STANDARD_SCORE_group = getTextValue(S_STANDARD_SCORE_group,S_STANDARD_SCORE_groupS,i,defaultValue);
		S_STANDARD_SCORE = getTextValue(S_STANDARD_SCORE,S_STANDARD_SCORES,i,defaultValue);
		REMARK = getTextValue(REMARK,REMARKS,i,defaultValue);
		if(i==0){
			assessList = assessList + "{\"assess\":[";
		}
		assessItemJson = "{\"assess_id\":\"" + assess_id + "\",";
		SINGLE_DEDUCTJson = "\"singel_deduct\":\"" + singel_deduct + "\",";
		FACT_DESCJson = "\"FACT_DESC\":\"" + FACT_DESC + "\",";
		DEDUCT_ACORE_DESCJson = "\"DEDUCT_ACORE_DESC\":" + DEDUCT_ACORE_DESC + ",";
		ITEM_FACT_SCOREJson = "\"ITEM_FACT_SCORE\":\"" + ITEM_FACT_SCORE + "\",";
		ITEM_COMPRE_SCOREJson = "\"ITEM_COMPRE_SCORE\":\"" + ITEM_COMPRE_SCORE + "\",";
		ITEM_SUM_SCOREJson = "\"ITEM_SUM_SCORE\":" + ITEM_SUM_SCORE + ",";
		ITEM_SCOREJson = "\"ITEM_SCORE\":" + ITEM_SCORE + ",";
		DEDUCT_ITEM_SCOREJson = "\"DEDUCT_ITEM_SCORE\":" + DEDUCT_ITEM_SCORE + ",";
		ELEMENT_SCOREJson = "\"ELEMENT_SCORE\":\"" + ELEMENT_SCORE + "\",";
		CHECK_SUM_SCOREJson = "\"CHECK_SUM_SCORE\":" + CHECK_SUM_SCORE + ",";
		ELEMENT_DETAIL_IDJson = "\"ELEMENT_DETAIL_ID\":" + ELEMENT_DETAIL_ID + "";
		S_STANDARD_SCORE_groupJson = "\"S_STANDARD_SCORE_group\":\"" + S_STANDARD_SCORE_group + "\",";
		S_STANDARD_SCOREJson = "\"S_STANDARD_SCORE\":\"" + S_STANDARD_SCORE + "\",";
		REMARK = "\"REMARK\":\"" + REMARK + "\"";
		assessItemJson = assessItemJson + SINGLE_DEDUCTJson + FACT_DESCJson;
		assessItemJson = assessItemJson + DEDUCT_ACORE_DESCJson + ITEM_FACT_SCOREJson;
		assessItemJson = assessItemJson + ITEM_COMPRE_SCOREJson + ITEM_SUM_SCOREJson;
		assessItemJson = assessItemJson + ITEM_SCOREJson + DEDUCT_ITEM_SCOREJson;
		assessItemJson = assessItemJson + ELEMENT_SCOREJson + CHECK_SUM_SCOREJson;
		assessItemJson = assessItemJson + ELEMENT_DETAIL_IDJson + CHECK_SCOREJson;
		assessItemJson = assessItemJson + S_STANDARD_SCORE_groupJson + S_STANDARD_SCOREJson;
		assessItemJson = assessItemJson + REMARK;
		assessItemJson = assessItemJson + "}";
		assessList = assessList + assessItemJson;
		if(i!=assess_ids.length-1){
			assessList = assessList + ",";
		}else{
			assessList = assessList + "]}";
		}
	}
	
	for (var i = 0; i< group_detail_ids.length; i++) {
		if(i==0){
			group_detailList = group_detailList + "{\"details\":["
		}
		if(group_detail_ids!=null&&group_detail_ids!=""&&group_detail_ids.length>0){
			group_detail_idArray = group_detail_ids[i].value.split("#");
			group_detail_assessID = group_detail_idArray[0];
			group_deital_id = group_detail_idArray[1];
		}else{
			group_detail_assessID=defaultValue;
			group_deital_id=defaultValue;
		}
		CHECK_SCORE = getTextValue(CHECK_SCORE,CHECK_SCORES,i,defaultValue);
		group_detail_score = getTextValue(group_detail_score,group_detail_scores,i,defaultValue);
		group_detailJson = "{\"group_detail_assessID\":\"" + group_detail_assessID + "\",";
		group_detailJson = group_detailJson + "\"ELEMENT_DETAIL_ID\":\"" + group_deital_id + "\",";
		group_detailJson = group_detailJson + "\"group_detail_score\":\"" + group_detail_score + "\","
		group_detailJson = group_detailJson + "\"CHECK_SCORE\":\"" + group_detail_score + "\"}"
		
		group_detailList = group_detailList + group_detailJson;
		if(i!=group_detail_ids.length-1){
			group_detailList = group_detailList + ","
		}else{
			group_detailList = group_detailList + "]}"
		}
	}
	
	
	document.form1.assessList.value=assessList;
	//document.form1.assessList.value="";
	document.form1.group_detailList.value=group_detailList;
	document.form1.method = "post";
	document.form1.action="<%=contextPath%>/assess/createScoreReport.srq";

		//document.form1.submit();
}
	function toModifyAssessPage(scoreID){
		var url = "<%=contextPath%>/assess/updateScoreReportByID.srq";
		
		url = url + "?scoreID=" + scoreID;
		alert("url=" + url);
		window.location.href = url;
	}
//将table导出到excel中
function exportToExcel(tableid){
var curTbl = document.getElementById(tableid);
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
var fname = oXL.Application.GetSaveAsFilename("将table导出到excel.xls", "Excel Spreadsheets (*.xls), *.xls");
oWB.SaveAs(fname);
oWB.Close();
oXL.Quit();
}




function method2(tableid) //读取表格中每个单元到EXCEL中 
{ 
var curTbl = document.getElementById(tableid); 
var oXL = new ActiveXObject("Excel.Application"); 
//创建AX对象excel 
var oWB = oXL.Workbooks.Add(); 
//获取workbook对象 
var oSheet = oWB.ActiveSheet; 
//激活当前sheet 
var Lenr = curTbl.rows.length; 
//取得表格行数 
for (i = 0; i < Lenr; i++) 
{ 
 var Lenc = curTbl.rows(i).cells.length; 
 //取得每行的列数 
 for (j = 0; j < Lenc; j++) 
 { 
     oSheet.Cells(i + 1, j + 1).value = curTbl.rows(i).cells(j).innerText; 
     //赋值 
 } 
} 
oXL.Visible = true; 
//设置excel可见属性 
}
</script>
</head>
<body style="background: #fff">
<form action="">

<input type="hidden" name="assessList" /> <input type="hidden"
			name="group_detailList" /> 
			<input type="hidden" name="modelID"
			value="<%=modelID%>" />
			<input type="hidden" name="MODEL_NAME"
			value="<%=MODEL_NAME%>" />
			<input type="hidden" name="MODEL_TYPE"
			value="<%=MODEL_TYPE%>" />
			<input type="hidden" name="MODEL_TITLE"
			value="<%=MODEL_TITLE%>" />
			
			<input type="hidden" name="CREATE_ORG_ID"
			value="<%=CREATE_ORG_ID%>" />
			<input type="hidden" name="ASSESS_ORG_ID"
			value="<%=ASSESS_ORG_ID%>" />
			<input type="hidden" name="ASSESS_ORG_NAME"
			value="<%=ASSESS_ORG_NAME%>" />
			<input type="hidden" name="ASSESS_USER_ID"
			value="<%=ASSESS_USER_ID%>" />
			<input type="hidden" name="ASSESS_USER_NAME"
			value="<%=ASSESS_USER_NAME%>" />
			<input type="hidden" name="ASSESS_START_DATE"
			value="<%=ASSESS_START_DATE%>" />
			<input type="hidden" name="ASSESS_END_DATE"
			value="<%=ASSESS_END_DATE%>" />
			<input type="hidden" name="CREATOR"
			value="<%=CREATOR%>" />
<div id="list_table" style="height:500px;overflow-x:auto;overflow-y:auto;word-wrap:break-word;word-break:normal;">
	<table align="center" width="98%" border="1" cellspacing="1"
		bgcolor="#ffffff">
		<tr>
			<td>模板类型</td>
			<td><%=MODEL_NAME%></td>
			<td>模板名称</td>
			<td colspan="7"><%=MODEL_TITLE%></td>
		
			<td  colspan="2">被审核单位</td>
			<td  colspan="2"><%=ASSESS_ORG_NAME%></td>
			<td>审核人</td>
			<td><%=ASSESS_USER_NAME%></td>
		</tr>
		<tr>
			<td   colspan="2">审核开始时间</td>
			<td colspan="3"><%=ASSESS_START_DATE%></td>
			<td  colspan="2">审核结束时间</td>
			<td colspan="3"><%=ASSESS_END_DATE%></td>
		
			<td>创建人单位</td>
			<td><%=CREATE_ORG_ID%></td>
			<td>创建人</td>
			<td><%=CREATOR%></td>
		</tr>
	</table>
	
	
		<table width="98%" border="1" cellspacing="2" cellpadding="1"
			class="tab_info" id="tab_info">
			<tr bgcolor="#aaaaaa">
				<!-- <td width="50px">选择</td> -->
				<td width="80px">要素</td>
				<td width="400px">审核内容</td>
				<td width="200px">审核部门</td>
				<td width="80px">事实描述（记录）</td>
				<td width="400px">评分标准</td>
				<td width="10px">标准分数</td>
				<td width="10px">单项扣分</td>
				<td width="10px">要素实际得分</td>
				<td width="10px">要素综合得分</td>
				<td width="150px">集团公司检查项目</td>
				<td width="200px">检查内容</td>
				<td width="50px">标准分</td>
				<td width="50px">检查得分</td>
				<td width="10px">得分</td>
				<td width="50px">备注</td>
			</tr>
			<%
				IPlat_scoreSrv scoreSrv = new Plat_scoreSrv();
			IElementDetailServ detailServ = new ElementDetailServ();
			int s_score_Standard = 0;//标准分数
		    int s_score_group = 0;//标准分(集团)
					for(int i = 0;i<size;i++){
							    	MsgElement e = datas.get(i);
							    	Map m = e.toMap();
							    	String SCORE_ID = AssessTools.valueOf(m.get("SCORE_ID".toLowerCase()), "");
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
							    	
							    	List STANDARD_list = detailServ.findElementDetailByEleID(ELEMENT_ID, "", detailPage,"0");
							    	List GROUP_list = scoreSrv.findElementDetailScoreByEleID(SCORE_ID, "1",detailPage);
							    	
							    	s_score_Standard = detailServ.getTotalScoreByEleID(ELEMENT_ID,"0");
							    	s_score_group = detailServ.getTotalScoreByEleID(ELEMENT_ID,"1");
							    	int standardSize = STANDARD_list.size();
									int groupSize = GROUP_list.size();
									boolean isInput = false;
									String visibility = "";
									String display = "";
									if(ASSESS_CONTENT!=null){
										if(!ASSESS_CONTENT.replace(" ", "").equals("")){
											isInput = true;
										}
									}
									if(isInput){
										visibility = "visibility";
										display = "";
									}else{
										visibility = "hidden";
										display = "none";
									}
									boolean isInput_group = false;
									String visibility_group = "hidden";
									String display_group = "none";
									if(groupSize>0){
										isInput_group=true;
										visibility_group = "visibility";
										display_group = "";
									}
									String tr_color = "";
									if(i%2==0){
										tr_color = "#cccccc";
									}else{
										tr_color = "#778899";
									}
			%>
			<tr  bgcolor="<%=tr_color%>">
				<td>
					<!-- 要素 --> <input type="hidden" name="SCORE_ID"
					value="<%=SCORE_ID%>"><%=ASSESS_NAME%>
				</td>
				<td style="word-break: break-all" width="400px">
					<!-- 审核内容 --> <%=ASSESS_CONTENT.replace("； ", "；<br> ").replace("。", "。<br>").replace("；", "； <br>").replace("<br><br>", "<br>")%>
				</td>
				<td width="200px">
				<!-- 审核部门 -->
				<%=e_ASSESS_ORG_NAME%>
				
				</td>
				<td width="100px">
					<!-- 事实描述（记录） -->
					<div style="visibility: <%=visibility%>">
						<%
							String FACT_DESC_ID = "FACT_DESC_" + SCORE_ID;
						%>
						<textarea rows="2" cols="5" name="FACT_DESC"
							id="<%=FACT_DESC_ID%>">
				<%=FACT_DESC_ID%>
				</textarea>
					</div> 
					
					<!-- 事实描述（记录） -->
				</td>
				<td width="200" style="word-break: break-all">
					<!-- 评分标准 -->
					<table align="center"
						style="width: 100%; height: 100%; border: solid 1px #999999;"
						bgcolor="#cccccc" cellspacing="1" border="1">
						<%
							//评分标准
							for(int j = 0;j<standardSize;j++){
								Map detailMap = (Map)STANDARD_list.get(j);
								Set keys = detailMap.keySet();
								
								String DETAIL_ID = AssessTools.valueOf(detailMap.get("DETAIL_ID".toLowerCase()), "");
								String CHECK_CONTENT = AssessTools.valueOf(detailMap.get("CHECK_CONTENT".toLowerCase()), "");
								String STANDARD_SCORE = AssessTools.valueOf(detailMap.get("STANDARD_SCORE".toLowerCase()), "");
						%>
						<tr>
							<td width="200" style="word-break: break-all">
								<!-- 评分标准 --> <%=CHECK_CONTENT%>
							</td>
						</tr>
						<%
							}
						%>
					</table> 
					<!-- 评分标准 -->
				</td>
				<td width="10px">
						<!-- 标准分数 -->
						<div style="visibility: <%=visibility%>">
						 <input type="text"  style="background-color: #cccccc" name="S_STANDARD_SCORE" value="<%=s_score_Standard%>" size="3">
						</div>
						
						<!-- 标准分数 -->
				</td>
				<td width="10px">
						<!-- 单项扣分 -->
						<%
						String ITEM_DEDUCT_SCORE_ID = "ITEM_DEDUCT_SCORE_" + SCORE_ID;
						%>
						<div style="visibility: <%=visibility%>">
						 <input type="text" name="ITEM_DEDUCT_SCORE" value="<%=ITEM_DEDUCT_SCORE %>" id = "<%=ITEM_DEDUCT_SCORE_ID%>" size="3" onblur="countScore('ITEM_DEDUCT_SCORE_','<%=SCORE_ID%>','<%=s_score_Standard%>')">
						</div>
						
						<!-- 单项扣分 -->
						</td>
				<td width="50px">
						<!-- 要素实际得分-->
						<%
						String ITEM_FACT_SCORE_ID = "ITEM_FACT_SCORE_" + SCORE_ID;
						%>
						<div style="visibility: <%=visibility%>">
						<input type="text" value="<%=ITEM_FACT_SCORE %>" name="ITEM_FACT_SCORE" id="<%=ITEM_FACT_SCORE_ID %>" size="3" readonly="readonly" style="background-color: #cccccc">
						</div>
						
						<!-- 要素实际得分-->
						</td>
						<td>
						<!--要素综合得分-->
						<%
						String ITEM_COMPRE_SCORE_ID = "ITEM_COMPRE_SCORE_" + SCORE_ID;
						%>
						<div style="visibility: <%=visibility%>">
						<input type="text" value="<%=ITEM_COMPRE_SCORE %>" name="ITEM_COMPRE_SCORE" id="<%=ITEM_COMPRE_SCORE_ID %>" readonly="readonly" style="background-color: #cccccc" size="3">
						</div>
						
						<!--要素综合得分-->
						</td>				
				<td width="450" style="word-break: break-all" colspan="4">
						<!--集团公司检查项目 检查内容  标准分 -->
							<%
							
								//循环集团评分子表 
													    		if(groupSize>0){
							%>
							<table align="center"  style="width:100%; height:100%"  border="1">
								<%
									for(int j = 0;j<groupSize;j++){
																    		Map dm = (Map)GROUP_list.get(j);
																    		String STANDARD_SCORE = AssessTools.valueOf(dm.get("STANDARD_SCORE".toLowerCase()), "");
																    		double s_score_group_detail = Double.parseDouble(AssessTools.valueOf(dm.get("s_score"), "0"));
																    		String DETAIL_ID = AssessTools.valueOf(dm.get("DETAIL_ID".toLowerCase()), "");
																    		String CHECK_ITEM = AssessTools.valueOf(dm.get("CHECK_ITEM".toLowerCase()), "");
																    		String CHECK_CONTENT = AssessTools.valueOf(dm.get("CHECK_CONTENT".toLowerCase()), "");
																    		String CHECK_SCORE = AssessTools.valueOf(dm.get("CHECK_SCORE".toLowerCase()), "");
																    		
								%>
								<tr>
									<td width="150" style="word-break: break-all">
									<!-- 集团公司检查项目 -->
									<%=CHECK_ITEM%>
									</td>
									<td width="200" style="word-break: break-all">
									<!-- 检查内容 -->
									<%=CHECK_CONTENT.replace("；", "；<br>")%>
									</td>
									<td width="50" style="word-break: break-all">
									<!-- 标准分 --><%=STANDARD_SCORE%>
									</td>
									<td width="50">
									<!-- 检查得分 -->
									<input type="hidden" name="group_detail_id"
										value="<%=SCORE_ID + "#" + DETAIL_ID%>"> 
										<%
										String detailTag_ID = "detail_" + SCORE_ID;
										%>
										<input
										type="text"  name="group_detail_score" value="<%=CHECK_SCORE %>" size="3" id = "<%=detailTag_ID %>"
										onblur="countDetailScore('<%=SCORE_ID %>','<%=DETAIL_ID %>','<%=s_score_Standard%>','<%=s_score_group%>')"
										>
										
										<input type="hidden" name="<%=detailTag_ID %>" value="<%=s_score_group_detail %>">
									</td>
								</tr>
								<%
									}
								%>
							</table> <%
 	}

 %>
<!--集团公司检查项目 检查内容  标准分 -->
						</td>
				<td width="50px">
						<!-- 得分-->
						<%
						String ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + SCORE_ID;
						%>
						<div style="visibility: <%=visibility_group%>">
						<input type="text" value="<%=ELEMENT_SCORE %>"  name="ELEMENT_SCORE" id="<%=ELEMENT_SCORE_ID %>" size="3" readonly="readonly">
						
						</div>
						
						</td>
						<td width="50px">
						<!-- 备注-->
						<div style="visibility: <%=visibility%>">
						<textarea rows="3" cols="5" name="REMARK">
						<%=REMARK %>
						</textarea>
						</div>
						
						</td>
			</tr>
			<%
				}
			%>

		</table>
		
	</div>
	</form>
	
</body>
</html>