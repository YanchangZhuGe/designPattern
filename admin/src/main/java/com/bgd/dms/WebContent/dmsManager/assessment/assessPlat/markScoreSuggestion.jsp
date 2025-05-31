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
/* String remark = resultMsg.getValue("remark");//备注
String spare1 = resultMsg.getValue("spare1");//备注1
String spare2 = resultMsg.getValue("spare2");//备注2 */

%>
<!DOCTYPE html> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<style type="text/css">
<!--
    body{font-size:12pt;line-height:50%}
    
-->
</style>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/assess.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>考核模板(<%=MODEL_NAME %>)</title>

<script defer  type="text/javascript">
function replaceAllBlank(str,blankFlag){
	var result = "";
	if(str.indexOf(blankFlag)!=-1){
		result = str.replace(" ","");
		result = replaceAllBlank(result," ");
	}
	return result;
}
/**
 * tagValue:要素扣分
 
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
	 alert("countDetailScore");
	 var SINGLE_DEDUCT_ID = "SINGLE_DEDUCT_" + assessid;
	
		var SINGLE_DEDUCTValue = document.getElementById(SINGLE_DEDUCT_ID).value;;
		
	var ITEM_FACT_SCORE_ID = "ITEM_FACT_SCORE_" + assessid;
	var ITEM_FACT_SCORE_VALUE = document.getElementById(ITEM_FACT_SCORE_ID).value;
	
	if(ITEM_FACT_SCORE_VALUE==null||ITEM_FACT_SCORE_VALUE==0||ITEM_FACT_SCORE_VALUE==""){
		
		ITEM_FACT_SCORE_VALUE = score_Standard - SINGLE_DEDUCTValue;
		
	}
	
	var detailTag = "detail_" + assessid;
	var detailValues = document.getElementsByName(detailTag);
	
	var result = ITEM_FACT_SCORE_VALUE/score_Standard*s_score_group;
	var ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + assessid;
	document.getElementById(ELEMENT_SCORE_ID).value = result;
	var ELEMENT_SCORE_VALUE = document.getElementById(ELEMENT_SCORE_ID).value;
}

/**
 * ITEM_FACT_SCORE_VALUE:要素实 际得分
   score_Standard:要素总分
   tagValue:要素扣分
   COMPRE_SCORE: 要素综合得分
   ITEM_FACT_SCORE_VALUE = score_Standard - tagValue
   ITEM_COMPRE_SCORE = ITEM_FACT_SCORE_VALUE/score_Standard*1000
   
   S_STANDARD_SCORE_group 标准分
   group_detail_CheckScore_Value 得分 即检查得分
   
   group_detail_CheckScore_Value=ITEM_FACT_SCORE_VALUE/score_Standard*S_STANDARD_SCORE_group
 */
function countScore(tag,assessID,score_Standard){
	var FixedLength = 2;
	var tagID = tag + assessID;
	var tagValue = "";
	var tagID_div = tag + assessID + "_div";
	tagValue = document.getElementById(tagID).value;
	//alert("tagValue="+tagValue + "score_Standard="+score_Standard);
	
	if(isNaN(tagValue)==true||parseFloat(tagValue)>parseFloat(score_Standard)||parseFloat(tagValue)<0){
		alert("请您输入数字，且单项扣分不能大于要素总分、不能为负数。");
		return false;
		document.getElementById(tagID).focus();
	}
	document.getElementById(tagID_div).value = tagValue;
	var ITEM_FACT_SCORE_ID = "ITEM_FACT_SCORE_" + assessID;
	var ITEM_FACT_SCORE_ID_div = "ITEM_FACT_SCORE_" + assessID + "_div";
	var ITEM_FACT_SCORE_VALUE = score_Standard-tagValue;
	ITEM_FACT_SCORE_VALUE = ITEM_FACT_SCORE_VALUE.toFixed(FixedLength);
	document.getElementById(ITEM_FACT_SCORE_ID).value=ITEM_FACT_SCORE_VALUE; 
	
	document.getElementById(ITEM_FACT_SCORE_ID_div).innerHTML = ITEM_FACT_SCORE_VALUE;
	//alert(document.getElementById(ITEM_FACT_SCORE_ID_div).innerText);
	
	var ITEM_COMPRE_SCORE_ID = "ITEM_COMPRE_SCORE_" + assessID;
	var ITEM_COMPRE_SCORE_ID_div = "ITEM_COMPRE_SCORE_" + assessID + "_div";
	var ITEM_COMPRE_SCORE_VALUE =ITEM_FACT_SCORE_VALUE/score_Standard*1000;
	ITEM_COMPRE_SCORE_VALUE = ITEM_COMPRE_SCORE_VALUE.toFixed(FixedLength);
	document.getElementById(ITEM_COMPRE_SCORE_ID).value = ITEM_COMPRE_SCORE_VALUE;
	document.getElementById(ITEM_COMPRE_SCORE_ID_div).innerHTML = ITEM_COMPRE_SCORE_VALUE;
	
	var S_STANDARD_SCORE_group_ID = "S_STANDARD_SCORE_group_" + assessID;
	var S_STANDARD_SCORE_group_VALUE =document.getElementById(S_STANDARD_SCORE_group_ID).value;
	
	var group_detail_ids = document.getElementsByName("group_detail_id");
	var group_detail_idArray;
	var group_detail_assessID;
	var group_deital_id;
	var group_detailTag = "";
	var group_detailValues;
	var group_detail_CheckScore_Tag = "";
	var group_detail_CheckScore_Tag_div = "";
	var group_detail_CheckScore_Value;
	
	var group_standerd_detailTag = "";
	var group_standerd_detailValue;
	//alert("group_detail_ids.length="+group_detail_ids.length);
	for (var i = 0; i< group_detail_ids.length; i++) {
		if(group_detail_ids!=null&&group_detail_ids!=""&&group_detail_ids.length>0){
			group_detail_idArray = group_detail_ids[i].value.split("#");
			group_detail_assessID = group_detail_idArray[0];
			group_deital_id = group_detail_idArray[1];
			if(group_detail_assessID==assessID){
				
				group_standerd_detailTag = "STANDARD" + group_detail_assessID + "#" + group_deital_id;
				group_standerd_detailValue = document.getElementById(group_standerd_detailTag).value;
				
				group_detail_CheckScore_Tag = "detail_" + group_detail_assessID + "#" + group_deital_id;
				group_detail_CheckScore_Tag_div = "detail_" + group_detail_assessID + "#" + group_deital_id + "_div";
				
				group_detail_CheckScore_Value=ITEM_FACT_SCORE_VALUE/score_Standard*group_standerd_detailValue;
				group_detail_CheckScore_Value = group_detail_CheckScore_Value.toFixed(FixedLength);
				//alert("document.getElementById(group_detail_CheckScore_Tag)="+document.getElementById(group_detail_CheckScore_Tag).value);
				document.getElementById(group_detail_CheckScore_Tag).value=group_detail_CheckScore_Value;
				document.getElementById(group_detail_CheckScore_Tag_div).innerHTML=group_detail_CheckScore_Value;
			}
			
		}
	}
	/* 
	var ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + assessID;
	var ELEMENT_SCORE_VALUE =ITEM_FACT_SCORE_VALUE/score_Standard*S_STANDARD_SCORE_group_VALUE;
	document.getElementById(ELEMENT_SCORE_ID).value = ELEMENT_SCORE_VALUE; */
	
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
	var flag = document.form1.flag.value;
	
	var ele_scoreIDS = document.getElementsByName("ele_scoreID");
	var SCORE_DETAIL_IDS = document.getElementsByName("SCORE_DETAIL_ID");
	
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
	var assessorgIDS = document.getElementsByName("assessorgID");
	var assessorgNameS = document.getElementsByName("assessorgName");
	var isMarkS = document.getElementsByName("isMark");
	
	
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
	var assessorgID = "";
	var assessorgName = "";
	var ele_scoreID = "";
	var SCORE_DETAIL_ID = "";
	var isMark=false;
	
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
	var assessorgIDJson = "";
	var assessorgNameJson = "";
	var ele_scoreIDJson = "";
	var assess_idJson = "";
	var SCORE_DETAIL_IDJson = "";
	var isMarkJson = "";
	
	
	var assessItemJson = ""
	var SINGLE_DEDUCTJson = "";
	var group_detailJson = "";
	var assessList = "";
	var group_detailList = "";
	var jsonDatas = "";
	var modelID = "";
	var group_detail_idArray;
	var group_detail_assessID;
	var group_deital_id;
	var assess_id="";
	var singel_deduct="";
	var defaultValue = "\"\"";
	var itemSize = 0;
	if(ele_scoreIDS.length>0){
		itemSize = ele_scoreIDS.length;
	}else{
		itemSize = assess_ids.length;
	}
	
	for (var i = 0; i< assess_ids.length; i++) {
		ele_scoreID = getTextValue(ele_scoreID,ele_scoreIDS,i,defaultValue);
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
		
		assessorgID = getTextValue(assessorgID,assessorgIDS,i,defaultValue);
		assessorgName = getTextValue(assessorgName,assessorgNameS,i,defaultValue);
		//isMark = getTextValue(isMark,isMarkS,i,defaultValue);
		//isMark = isMarkS[i].checked;
		if(isMarkS[i].checked){
			isMark="1";
		}else{
			isMark="0";
		}
		if(i==0){
			assessList = assessList + "{\"assess\":[";
		}
		
		
		assess_idJson = "\"assess_id\":\"" + assess_id + "\",";	
		ele_scoreIDJson = "\"ele_scoreID\":\"" + ele_scoreID + "\",";	
		SINGLE_DEDUCTJson = "\"singel_deduct\":\"" + singel_deduct + "\",";
		FACT_DESCJson = "\"FACT_DESC\":\"" + replaceAllBlank(FACT_DESC," ").replace("\r","").replace("\n","") + "\",";
		DEDUCT_ACORE_DESCJson = "\"DEDUCT_ACORE_DESC\":" + DEDUCT_ACORE_DESC + ",";
		ITEM_FACT_SCOREJson = "\"ITEM_FACT_SCORE\":\"" + ITEM_FACT_SCORE + "\",";
		ITEM_COMPRE_SCOREJson = "\"ITEM_COMPRE_SCORE\":\"" + ITEM_COMPRE_SCORE + "\",";
		ITEM_SUM_SCOREJson = "\"ITEM_SUM_SCORE\":" + ITEM_SUM_SCORE + ",";
		ITEM_SCOREJson = "\"ITEM_SCORE\":" + ITEM_SCORE + ",";
		DEDUCT_ITEM_SCOREJson = "\"DEDUCT_ITEM_SCORE\":" + DEDUCT_ITEM_SCORE + ",";
		ELEMENT_SCOREJson = "\"ELEMENT_SCORE\":\"" + ELEMENT_SCORE + "\",";
		CHECK_SUM_SCOREJson = "\"CHECK_SUM_SCORE\":" + CHECK_SUM_SCORE + ",";
		ELEMENT_DETAIL_IDJson = "\"ELEMENT_DETAIL_ID\":" + ELEMENT_DETAIL_ID + ",";
		S_STANDARD_SCORE_groupJson = "\"S_STANDARD_SCORE_group\":\"" + S_STANDARD_SCORE_group + "\",";
		S_STANDARD_SCOREJson = "\"S_STANDARD_SCORE\":\"" + S_STANDARD_SCORE + "\",";
		assessorgIDJson = "\"assessorgID\":\"" + assessorgID + "\",";
		assessorgNameJson = "\"assessorgName\":\"" + assessorgName + "\",";
		REMARKJson = "\"REMARK\":\"" + REMARK.replace("\r","").replace("\n","") + "\",";
		
		isMarkJson = "\"isMark\":\"" + isMark + "\"";
		
		assessItemJson = "{"+assess_idJson;
		assessItemJson = assessItemJson + ele_scoreIDJson;
		assessItemJson = assessItemJson + SINGLE_DEDUCTJson + FACT_DESCJson;
		assessItemJson = assessItemJson + DEDUCT_ACORE_DESCJson + ITEM_FACT_SCOREJson;
		assessItemJson = assessItemJson + ITEM_COMPRE_SCOREJson + ITEM_SUM_SCOREJson;
		assessItemJson = assessItemJson + ITEM_SCOREJson + DEDUCT_ITEM_SCOREJson;
		assessItemJson = assessItemJson + ELEMENT_SCOREJson + CHECK_SUM_SCOREJson;
		assessItemJson = assessItemJson + ELEMENT_DETAIL_IDJson + CHECK_SCOREJson;
		assessItemJson = assessItemJson + S_STANDARD_SCORE_groupJson + S_STANDARD_SCOREJson;
		assessItemJson = assessItemJson + assessorgIDJson + assessorgNameJson;
		assessItemJson = assessItemJson + REMARKJson + isMarkJson;
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
		SCORE_DETAIL_ID = getTextValue(SCORE_DETAIL_ID,SCORE_DETAIL_IDS,i,defaultValue);
		group_detail_score = getTextValue(group_detail_score,group_detail_scores,i,defaultValue);
		group_detailJson = "{\"group_detail_assessID\":\"" + group_detail_assessID + "\",";
		group_detailJson = group_detailJson + "\"ELEMENT_DETAIL_ID\":\"" + group_deital_id + "\",";
		group_detailJson = group_detailJson + "\"group_detail_score\":\"" + group_detail_score + "\","
		group_detailJson = group_detailJson + "\"SCORE_DETAIL_ID\":\"" + SCORE_DETAIL_ID + "\","
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
	document.form1.action="<%=contextPath%>/assess/addMarkScoreSuggestion.srq";

		document.form1.submit();
	}
</script>
</head>

<body style="background: #fff" >

	<form action=""
		method="post" name="form1" onsubmit="toSubmit()">
		<input type="hidden" name="assessList" /> <input type="hidden"
			name="group_detailList" /> 
			<input type="hidden" name="flag"
			value="<%=flag%>" />
			<input type="hidden" name="CREATE_ORG_ID"
			value="<%=orgId%>" />
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
			<div style="visibility: hidden;">
		<input type="hidden" id="MODEL_TITLE" name="MODEL_TITLE" value="<%=MODEL_TITLE==null?"": MODEL_TITLE %>">
		<input type="hidden" id="MODEL_TYPE" name="MODEL_TYPE" value="<%=MODEL_TYPE==null?"": MODEL_TYPE %>">
		<input type="hidden" id="modelID" name="modelID"  value="<%=modelID==null?"": modelID %>">
		<input type="hidden" id="scoreID" name="scoreID"  value="<%=scoreID==null?"": scoreID %>">
		</div>
<!-- <table border="1" cellspacing="2" cellpadding="1"
					 id="suggestion">
					<tr>
					<td>总体意见</td>
					<td>
					<textarea rows="10" cols="70" name="suggestion"></textarea>
					</td>
					</tr>
					</table> -->
		<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align = "center">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						<td class="ali_cdn_name"><font color=red>*</font>选择模板：</td>
				  		<td class="ali_cdn_input" width="20%">
							<input id="MODEL_NAME" value="<%=MODEL_NAME==null?"": MODEL_NAME %>" name="MODEL_NAME" type="text" readonly="readonly"/>
							
						</td>
						<td class=ali_btn>
				    		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" id="org_button" style="cursor: hand;" 
		    					onclick="selectModelInfo()" />
		    			</td>
						<td class="ali_cdn_name" style="width:95px"><font color=red>*</font>被审核单位：</td>
						<td class="ali_cdn_input" width="20%">
							<input name="assess_name" id="assess_name" type="text"  value="<%=ASSESS_ORG_NAME==null?"": ASSESS_ORG_NAME %>" readonly/>
					        <input name="assess_org_id" id="assess_org_id" type="hidden" value="<%=ASSESS_ORG_ID==null?"": ASSESS_ORG_ID %>"/>
				        </td>
				        <td class=ali_btn>
				    		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" id="show-btn" style="cursor: hand;" 
		    					onclick="showOrgTreePage('assess')" />
		    			</td>
				        <td class="ali_cdn_name"><font color=red>*</font>&nbsp;审核人:</td>
						<td class="ali_cdn_input" width="20%">
							<input name="employee_id" id="employee_id" type="hidden" value="<%=user.getEmpId()%>" />
							<input name="employee_name" id="employee_name" type="text" value="<%=user.getUserName()%>" />
						</td>
					    <td class="ali_cdn_name" ><font color=red>*</font>审核时间：</td>
				 	    <td class="ali_cdn_input">
				 	    	<input type="text" id="startDate" name="startDate" value="<%=ASSESS_START_DATE==null?"": ASSESS_START_DATE %>" class="input_width" readonly="readonly"/>
				 	    </td>
				 	    <td class=ali_btn>
				    		<img src="<%=contextPath%>/images/calendar.gif" width="16" height="16" id="tributton1" style="cursor: hand;" 
		    					onmouseover="calDateSelector(startDate,tributton1);" />
		    			</td>			 	    	
				 	    <td class="ali_cdn_name" style="width:10px;">至</td>
				 	    <td class="ali_cdn_input" >
				 	    	<input type="text" id="endDate" name="endDate" value="<%=ASSESS_END_DATE==null?"": ASSESS_END_DATE %>" class="input_width" readonly="readonly"/>
				 	    </td>
						<td class=ali_btn>
							<img src="<%=contextPath%>/images/calendar.gif" width="16" height="16" id="tributton2" style="cursor: hand;" 
		    					onmouseover="calDateSelector(endDate,tributton2);" />
		    			</td>
						<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
						<auth:ListButton functionId="" css="fh" event="onclick='javascript:window.history.back();'" title="JCDP_btn_back"></auth:ListButton>
					  	</tr>
					</table>
				</td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
			</div>

			<div id="table_box_0" >
			<% 
if("toMarkScoreSuggestion".equals(methodID)){
	
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
			<table border="1" cellspacing="2" cellpadding="1"
					 id="suggestion" width="100%" class="tab_info">
					<tr>
					<td>总体意见</td>
					<td align="left">
					<textarea rows="10" cols="70" name="REMARK_plat"><%=REMARK_plat==null?"":REMARK_plat %></textarea>
					</td>
					</tr>
					</table>
				</div>
			<table align = "center" width = "100%">
		<tr>
		<td id="model_title_" align="center" style="font-size: 20px;line-height: 2;background-color: #cccccc">
		<%=MODEL_TITLE==null?"":MODEL_TITLE%>
		
		</td>
		</tr>
		
		</table>
		<div id="table_box_div" style="height:230px;overflow-x:auto;overflow-y:auto;word-wrap:break-word;word-break:normal;" >
				<table border="1" cellspacing="2" cellpadding="1"
					class="tab_info" id="queryRetTable">
					<tr bgcolor="#aaaaaa" align="center" style="font-weight: 300;">
						<!-- <td width="50px">选择</td> -->
						
						<td width="80px">要素</td>
						
						<td width="200px">审核内容</td>
						<td width="200px">审核部门</td>
						<td width="50px">整改意见</td>
						<td width="80px">事实描述（记录）</td>
						<td width="400px">评分标准</td>
						<td width="10px">标准分数</td>
						<td width="10px">单项扣分</td>
						<td width="10px">要素实际得分</td>
						<td width="10px">要素综合得分</td>
						<td width="300px">集团公司检查项目</td>
						<td width="300px">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						检查内容&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td width="50px">标准分</td>
						<td width="50px">检查得分</td>
						<!-- <td width="10px">得分</td> -->
						
						
						
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
																		
																		if("sug".equals(flag)){
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
																		
																		//List group_TotalScoreList = detailServ.getTotalScoreList("1");
																		//int group_TotalScoreListSize = group_TotalScoreList.size();
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
						<%-- <td width="50px"><input type="hidden" name="assess_id"
							value="<%=assess_id%>"></td>--%>
						<td width="80px"> 
						<!-- //要素 --><input type="hidden" name="assess_id"
							value="<%=assess_id==null?"":assess_id %>">
							<input type="hidden" name="ele_scoreID" id = "ele_scoreID"
							value="<%=eleSCORE_ID==null?"":eleSCORE_ID %>">
						<%=assess_name%>
						</td>
						
						<td width="400px" >
						<font class="content_info">
						<!-- 审核内容 -->
						<%
										//multiStr =  AssessTools.formatLongContentBySeparator(assess_content,"2、", 12);
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
						<%=ASSESS_ORG_NAME==null?"":ASSESS_ORG_NAME %>
						<%
						String assessorgID = "assessorg_" + assess_id;
						String assessorgName = "assessname_" + assess_id;
						%>
						
						<input name="assessorgID" id="<%=assessorgID %>" type='hidden' value='<%=ASSESS_ORG_ID==null?"":ASSESS_ORG_ID %>' />
					   	<input name="assessorgName" id="<%=assessorgName %>" type='hidden' value='<%=ASSESS_ORG_NAME==null?"":ASSESS_ORG_NAME %>' size="12" />
					   	</div>
						</td>
						<td width="50px">
						<!-- 整改意见-->
						<div style="visibility: <%=visibility%>">
						
						<textarea rows="5" cols="5" name="REMARK"><%=REMARK==null?"":REMARK.replaceAll(" ", "").replace("\r", "").replaceAll("\n", "").replaceAll("<br>", "") %></textarea>
						</div>
						</td>
						<td width="100px" align="center">
						<!-- 事实描述（记录） -->
						<div style="visibility: <%=visibility%>"><%
						String FACT_DESC_ID = "FACT_DESC_" + assess_id;
						%>
<textarea rows="5" cols="8" name="FACT_DESC" id="<%=FACT_DESC_ID%>"><%=FACT_DESC==null?"":FACT_DESC %></textarea>
						</div>
						</td>
						<td width="200" style="word-break: break-all">
						<!-- 评分标准 -->
						<div>
							<table align="center"   cellspacing="1" >
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
																multiCHECKStr = multiCHECKStr.replace("<br><br>", "<br>").replace("；  ", "； <br>");
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
						<td width="10px">
						<!-- 标准分数 -->
						<div style="visibility: <%=visibility%>">
						 <input type="hidden"  style="background-color: #cccccc" name="S_STANDARD_SCORE" value="<%=s_score_Standard%>" size="3">
							<%=s_score_Standard%>
						</div>
						</td>
						<td width="10px">
						<!-- 单项扣分 -->
						<%
						String SINGLE_DEDUCT_ID = "SINGLE_DEDUCT_" + assess_id;
						String SINGLE_DEDUCT_ID_div = "SINGLE_DEDUCT_" + assess_id + "_div";
						%>
						<div style="visibility: <%=visibility%>">
						 <input type="text" value="<%=ITEM_DEDUCT_SCORE==null||"".equals(ITEM_DEDUCT_SCORE)?0:ITEM_DEDUCT_SCORE %>"  name="SINGLE_DEDUCT" id = "<%=SINGLE_DEDUCT_ID%>" size="3" onblur="countScore('SINGLE_DEDUCT_','<%=assess_id%>','<%=s_score_Standard%>')">
						 <div id = "<%=SINGLE_DEDUCT_ID_div%>"></div>
						</div>
						<!-- 单项扣分 -->
						</td>
						<td width="50px">
						<!-- 要素实际得分-->
						<%
						String ITEM_FACT_SCORE_ID = "ITEM_FACT_SCORE_" + assess_id;
						String ITEM_FACT_SCORE_ID_div = "ITEM_FACT_SCORE_" + assess_id + "_div";
						%>
						<div style="visibility: <%=visibility%>">
						<input type="hidden" value="<%=ITEM_FACT_SCORE==null?(s_score_Standard-Integer.parseInt(ITEM_DEDUCT_SCORE)):ITEM_FACT_SCORE %>" name="ITEM_FACT_SCORE" id="<%=ITEM_FACT_SCORE_ID %>" size="3" readonly="readonly" style="background-color: #cccccc">
						<div id = "<%=ITEM_FACT_SCORE_ID_div%>">
						<%=ITEM_FACT_SCORE==null?(s_score_Standard-Integer.parseInt(ITEM_DEDUCT_SCORE)):ITEM_FACT_SCORE %>
						</div>
						</div>
						<!-- 要素实际得分-->
						</td>
						<td width="10px">
						<!--要素综合得分-->
						<%
						String ITEM_COMPRE_SCORE_ID = "ITEM_COMPRE_SCORE_" + assess_id;
						String ITEM_COMPRE_SCORE_ID_div = "ITEM_COMPRE_SCORE_" + assess_id + "_div";
						%>
						<div style="visibility: <%=visibility%>">
						<input type="hidden" value="<%=ITEM_COMPRE_SCORE==null?"":ITEM_COMPRE_SCORE %>" name="ITEM_COMPRE_SCORE" id="<%=ITEM_COMPRE_SCORE_ID %>" readonly="readonly" style="background-color: #cccccc" size="3">
						<div id = "<%=ITEM_COMPRE_SCORE_ID_div%>">
						<%=ITEM_COMPRE_SCORE==null?"":ITEM_COMPRE_SCORE %>
						</div>
						</div>
						<!--要素综合得分-->
						</td>
						<td width="900" style="word-break: break-all" colspan="4">
						<!--集团公司检查项目 检查内容  标准分 -->
						<div>
							<%
								//循环集团评分子表 
													    		if(groupDetailList_Size>0){
							%>
							<table align="center"  style="width:100%; height:100%"  border="1">
								<%
									
								for(int j = 0;j<groupDetailList_Size;j++){
									Map dm = (Map)groupDetailList.get(j);
									//System.out.println("dm="+dm);
									//out.print("dm="+dm);
									boolean isSame = false;
									if("add".equals(flag)){
										isSame = dm.get("ELEMENT_ID".toLowerCase()).equals(assess_id);
									}
									if("up".equals(flag)){
										isSame = dm.get("element_score_id".toLowerCase()).equals(eleSCORE_ID);
									} 
									
									if(isSame){
										visibility_group = "visibility";
										String STANDARD_SCORE_group = AssessTools.valueOf(dm.get("STANDARD_SCORE".toLowerCase()), "");
							    		//double s_score_group_detail = Double.parseDouble(AssessTools.valueOf(dm.get("s_score"), "0"));
							    		String DETAIL_ID = AssessTools.valueOf(dm.get("DETAIL_ID".toLowerCase()), "");
							    		String CHECK_ITEM = AssessTools.valueOf(dm.get("CHECK_ITEM".toLowerCase()), "");
							    		String CHECK_CONTENT = AssessTools.valueOf(dm.get("CHECK_CONTENT".toLowerCase()), "");						    		
							    		
							    		String SCORE_DETAIL_ID = AssessTools.valueOf(dm.get("SCORE_DETAIL_ID".toLowerCase()), "");						    		
							    		String CHECK_SCORE = AssessTools.valueOf(dm.get("CHECK_SCORE".toLowerCase()), "");						    		
								%>
								<tr>
									<td width="200" style="word-break: break-all">
									<!-- 集团公司检查项目 -->
									<%=AssessTools.newLines(CHECK_ITEM, 8) %>
									</td>
									<td width="300px" style="word-break: break-all">
									<!-- 检查内容 -->
									<font class="content_info">
									<%
									CHECK_CONTENT.replace("；", "；<br>");
									CHECK_CONTENT = CHECK_CONTENT.replace("<br>", "");
									
										String CHECK_CONTENTStr = AssessTools.newLines(CHECK_CONTENT, 10);
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("2、<br>、", "2、").replace("3、<br>", "3、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("4、<br>", "4、").replace("5、<br>", "5、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("2<br>、", "2、").replace("3<br>、", "3、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("4<br>、", "4、").replace("5<br>、", "5、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("； 2", "<br>； 2").replace("； 3", "<br>； 3");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("； 4", "<br>； 4").replace("； 5", "<br>； 5");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("2、", "<br>2、").replace("3、", "<br>3、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("4、", "<br>4、").replace("5、", "<br>5、");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace(" ", "").replace("<br>\n<br>", "<br>");
									CHECK_CONTENTStr = CHECK_CONTENTStr.replace("<br><br>", "<br>").replace("；  ", "； <br>"); 
									
										out.print(CHECK_CONTENTStr);
										%>
										</font>
									</td>
									<td width="50" style="word-break: break-all">
									<!-- 标准分 -->
									<%=AssessTools.newLines(STANDARD_SCORE_group,4) %>
									<!-- 检查得分 -->
									<%
									String STANDARD_SCORE_group_id = "STANDARD" + assess_id + "#" + DETAIL_ID;
									%>
									<input type="hidden" id="<%=STANDARD_SCORE_group_id %>" name="STANDARD_SCORE_group_id" value="<%=STANDARD_SCORE_group%>"> 
									</td>
									<td width="50">
									<!-- 检查得分 -->
									<%
									String detailNodeID = assess_id + "#" + DETAIL_ID;
									if(CHECK_SCORE==null||"".equals(CHECK_SCORE)||"0".equals(ITEM_DEDUCT_SCORE)){
										CHECK_SCORE = STANDARD_SCORE_group;
									}
									%>
									<input type="hidden" name="group_detail_id" value="<%=detailNodeID%>"> 
									<input type="hidden" name="SCORE_DETAIL_ID" id="SCORE_DETAIL_ID" value="<%=SCORE_DETAIL_ID%>"> 
										<%
										String detailTag_ID = "detail_" + assess_id + "#" + DETAIL_ID;
										String detailTag_ID_div = "detail_" + assess_id + "#" + DETAIL_ID + "_div";
										%>
										<%-- <input
										type="text" value="<%=CHECK_SCORE==null?"":CHECK_SCORE %>" name="group_detail_score" value="" size="3" id = "<%=detailTag_ID %>"
										onblur="countDetailScore('<%=assess_id %>','<%=DETAIL_ID %>','<%=s_score_Standard%>','<%=s_score_group%>')"
										> --%>
										<input
										type="hidden" value="<%=CHECK_SCORE %>" name="group_detail_score"  size="3" id = "<%=detailTag_ID %>"
										>
										<div id = "<%=detailTag_ID_div%>">
										
										<%=CHECK_SCORE  %>
										</div>
										<%-- <input type="hidden" name="<%=detailTag_ID %>" value="<%=s_score_group_detail %>"> --%>
									</td>
								</tr>
								<%
									}
								}
								%>
							</table> <%
 	}

 %>
 &nbsp; &nbsp; &nbsp; &nbsp;
 </div>
<!--集团公司检查项目 检查内容  标准分 -->
<%
						String S_STANDARD_SCORE_group_ID = "S_STANDARD_SCORE_group_" + assess_id;
						%>
						 <input type="hidden" name="S_STANDARD_SCORE_group" id="<%=S_STANDARD_SCORE_group_ID%>" value="<%=s_score_group%>">
						<%
						String ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + assess_id;
						%>
						
						<input type="hidden" value="<%=ELEMENT_SCORE==null?"":ELEMENT_SCORE %>"  name="ELEMENT_SCORE" id="<%=ELEMENT_SCORE_ID %>" size="3" readonly="readonly">
						
						</td>
						<%-- <td width="50px">
						<!-- 得分 即检查得分-->
						<%
						String ELEMENT_SCORE_ID = "ELEMENT_SCORE_" + assess_id;
						%>
						<div style="visibility: <%=visibility_group%>">
						<input type="text" value="<%=ELEMENT_SCORE==null?"":ELEMENT_SCORE %>"  style="background-color: #cccccc" name="ELEMENT_SCORE" id="<%=ELEMENT_SCORE_ID %>" size="3" readonly="readonly">
						
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
		
	</form>

</body>
<script type="text/javascript">
//选择模板
function selectModelInfo(){
	
	var modeltype = '';
	var result = window.showModalDialog('<%=contextPath%>/dmsManager/assessment/assessPlat/selectModelList.jsp','','dialogWidth=950px;dialogHeight=480px');
	if(result!=undefined){
    	var checkStr = result.split("~");	
	        document.getElementById("modelID").value = checkStr[0];
	        document.getElementById("MODEL_NAME").value = checkStr[1];
	        //document.getElementByName("model_id").value = checkStr[0];
	       // document.getElementByName("model_name").value = checkStr[1];
	        //document.getElementByName("MODEL_TITLE").value = checkStr[3];
	        document.getElementById("model_title_").innerHTML = checkStr[3];
	        document.getElementById("MODEL_TITLE").value  = checkStr[3];
	        document.getElementById("MODEL_TYPE").value  = checkStr[2];
	        modeltype = checkStr[2];
	        
	        var url = "<%=contextPath%>/assess/findElementList.srq";
	        document.form1.method = "post";
	        document.form1.action = url;
	        document.form1.submit();
    }else{
	    return;
	}
	
}
/**
 * 选择组织机构树
 */
function showOrgTreePage(str){

	var returnValue=window.showModalDialog("<%=contextPath%>/dmsManager/assessment/assessPlat/selectAssessPlatOrg.jsp?codingSortId=0110000001","test","");
	var strs= new Array(); //定义一数组
	if(!returnValue){
		return;
	}
	$("input[id^='assessname_']").val("");
	$("input[id^='assessorg_']").val("");
	strs=returnValue.split("~"); //字符分割
	var names = strs[0].split(":");
	document.getElementById(str+"_name").value = names[1];
	
	var orgId = strs[1].split(":");
	document.getElementById(str+"_org_id").value = names[1];
	document.getElementById("assess_name").value = names[1];
	document.getElementById("assess_org_id").value = orgId[1];
	//var orgSubId = strs[2].split(":");
	//document.getElementById(str+"_org_id").value = orgSubId[1];
}
/**
 * 选择审核单位
 */
function showAssessOrgTree(index){
	var assessOrgId = document.getElementById("assess_org_id").value;
	if(assessOrgId == ''){
		alert("请首先选择“被审核单位”！");
		return;
	}
	//$("tr[id^='assessname_']").val("");
	var returnValue=window.showModalDialog("<%=contextPath%>/dmsManager/assessment/assessPlat/selectAssessPlatOrg.jsp?orgId="+assessOrgId,"test","");
	var strs= new Array(); //定义一数组
	if(!returnValue){
		return;
	}
	strs=returnValue.split("~"); //字符分割
	
	var names = strs[0].split(":");
	$("#assessname_"+index).val(names[1]);
	
	var orgId = strs[1].split(":");
	$("#assessorg_"+index).val(orgId[1]);
}
</script>
<script defer type="text/javascript">
	createNewTitleTable("queryRetTable","newTitleTable");
	resizeNewTitleTable("queryRetTable","newTitleTable")
	cruConfig.contextPath='<%=contextPath%>';
	var assesstype = '<%=MODEL_NAME%>';

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