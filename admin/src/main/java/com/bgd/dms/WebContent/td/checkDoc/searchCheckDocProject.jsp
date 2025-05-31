<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat oSdf = new SimpleDateFormat ("yyyy-MM-dd"); 
    
	String docType = request.getParameter("docType");
	if(docType==null || "".equals(docType)){
		docType = resultMsg.getValue("docType");
	}
	
	Calendar cal = new GregorianCalendar();
	cal.setTime(new Date());
	int daynum = cal.getActualMaximum(Calendar.DAY_OF_MONTH); 
	
	String projectInfoNo = "";
	String projectName = "";
	String docDate = oSdf.format(new Date());
		
	if( resultMsg!=null ){
		if(resultMsg.getValue("daynum") != null ){
			daynum = Integer.parseInt(resultMsg.getValue("daynum"));
		}
		if(resultMsg.getValue("projectInfoNo") != null ){
			projectInfoNo = resultMsg.getValue("projectInfoNo");
		}
		if(resultMsg.getValue("projectName") != null ){
			projectName = resultMsg.getValue("projectName");
		}
		if(resultMsg.getValue("docDate") != null ){
			docDate = resultMsg.getValue("docDate");
		}
	}
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css">
body,table, td {font-size:12px;font-weight:normal;}
/* 重点：固定行头样式*/  
.scrollRowThead{BACKGROUND-COLOR: #AEC2E6;position: relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:0;}  
/* 重点：固定表头样式*/  
.scrollColThead {position: relative;top: expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:2;}  
/* 行列交叉的地方*/  
.scrollCR{ z-index:3;}
/*div 外框*/  
.scrollDiv {height:360;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
/* 行头居中*/  
.scrollColThead td,.scrollColThead th{ text-align: center ;}  
/* 行头列头背景*/  
.scrollRowThead,.scrollColThead td,.scrollColThead th{background-color:#94B6E6;background-repeat:repeat;}  
/* 表格的线*/  
.scrolltable{border-bottom:1px solid #CCCCCC; border-right:1px solid #8EC2E6;}  
/* 单元格的线等*/  
.scrolltable td,.scrollTable th{border-left: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; padding: 1px;}
.scrollTable thead th{background-color:#94B6E6;position:relative;}
.td_head {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:20px;
	line-height: 20px;
	background:#CCCCCC;
}
</style>
<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['BGP_COMM_HUMAN_COST_PLAN']
);
var defaultTableName = 'BGP_COMM_HUMAN_COST_PLAN';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}

 //选择项目
   function selectTeam(){

       var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
       if(result!=""){
       	var checkStr = result.split("-");	
	        document.getElementById("projectInfoNo").value = checkStr[0];
	        document.getElementById("projectName").value = checkStr[1];
       }
   }




function simpleSearch(){

	var projectInfoNo = document.getElementById("projectInfoNo").value;	
	
	if(projectInfoNo==''){
		alert("请选择项目");
		return;
	}
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/toSearchCheckDocProject.srq";
	form.submit();
		
}

function deleteTableTr(tableID){
	var tb = document.getElementById(tableID);
     var rowNum=tb.rows.length;
     for (i=1;i<rowNum;i++)
     {
         tb.deleteRow(i);
         rowNum=rowNum-1;
         i=i-1;
     }
}
</script>
</head>
<body onload="page_init();" style="overflow-y:auto">
<form id="CheckForm" action="" method="post" >
<div>
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali_cdn_name" width="20%">项目名称：</td>
    <td  width="20%">
     <input name="docType" id="docType" class="input_width" value="<%=docType%>" type="hidden" readonly="readonly"/>
     <input name="projectInfoNo" id="projectInfoNo" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>
     <input name="projectName" id="projectName" class="input_width" value="<%=projectName%>" type="text" readonly="readonly"/>   
     <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>     
    </td>
    <td  width="20%">
     <input name="docDate" id="docDate" class="input_width" value="<%=docDate%>" type="text" readonly="readonly"/>
     <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(docDate,tributton1);" />
    </td>
 	<td class="ali_query" width="20%">
   		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
  	</td>
	<td>&nbsp;</td>
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>
 
<div id="scrollDiv" class="scrollDiv" >
 	<table id="equipmentTableInfo" width="1300" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
 	 <thead>
 	 <tr class="scrollColThead td_head">
 	 <td width="30" class="scrollCR scrollRowThead">序号</td>
 	 <td width="400" class="scrollCR scrollRowThead">项目</td>
     <%for(int i=1;i<=daynum;i++){%>
     	<td width="30"><%=i%></td>
     <%} %>
     </tr>
     <% if(resultMsg != null){
		List<MsgElement> list = resultMsg.getMsgElements("newlist");
		if(list != null){
			for(int i=0;i<list.size();i++){				
				MsgElement msg = (MsgElement)list.get(i);
				Map map = msg.toMap();
				%>
				   <tr align="center">				   
				   	<td align="left" width="30" class="scrollRowThead"><%=i+1%></td>
				   	<td align="left" width="400" class="scrollRowThead"><%=map.get("project_name")%></td>
				   	<%for(int j=1;j<=daynum;j++){%>
				   	<td> 
				     <%if("1".equals(map.get("date"+j))){ %> 
				   	  <img id="human_image" src="<%=contextPath%>/images/point_green.png" style="width: 15px; height: 15px" />
				   	 <%}else if("2".equals(map.get("date"+j)) || "0".equals(map.get("date"+j))){ %>
				   	 <img id="human_image" src="<%=contextPath%>/images/point_red.png" style="width: 15px; height: 15px" />
				   	 <%} %>
				   	</td>
				    <%} %>
				   </tr>				   				   				   
				<%
			}			
		}		
	}%>
	</table>	
</div> 

</div>
</form>
</body>
</html>
