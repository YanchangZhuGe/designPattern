<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String week_date = request.getParameter("week_date");
	String id = request.getParameter("id");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<%@ include file="/common/pmd_add.jsp"%>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "编辑--技术支持情况";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
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
var fields = new Array(
['JCDP_TABLE_NAME',null,'Hide','TEXT',null,'BGP_WR_HOLD_INFO']
,['JCDP_TABLE_ID',null,'Hide','TEXT',null]
,['hold_id','','Hide','TEXT',,,,,,,]
,['week_date','周报开始日期','Edit','TEXT',,,,,,,]
,['week_end_date','周报结束日期','Edit','TEXT',,,,,,,]
,['complexion','技术支持情况','Edit','MEMO',,,'40:2',,,,]
,['org_id','','Hide','TEXT',,'<%=user.getCodeAffordOrgID()%>',,,,,]
,['org_subjection_id','','Hide','TEXT',,'<%=user.getSubOrgIDofAffordOrg()%>',,,,,]
,['create_user','','Hide','TEXT',,'<%=user.getUserName()%>',,,,,]
,['create_date','','Hide','D',,'CURRENT_DATE_TIME',,,,,]
,['mondify_user','','Hide','TEXT',,'<%=user.getUserName()%>',,,,,]
,['mondify_date','','Hide','D',,'CURRENT_DATE_TIME',,,,,]
,['bsflag','','Hide','TEXT',,'0',,,,,]
,['subflag','','Hide','TEXT',,'0',,,,,]
);
var uniqueFields = ':';
var fileFields = ':';

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/pm/wr/holdInfo/holdInfo.lpmd";
	//cruConfig.querySql = "select h.hold_id,h.week_date,h.org_id,h.org_subjection_id,h.complexion from BGP_WR_HOLD_INFO h where h.hold_id='<%=id%>'";
	cru_init();

	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		var querySql = "select t.* from BGP_WR_HOLD_INFO t where to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and t.org_id='" + data_org_id + "' and t.bsflag='0' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas && queryRet.datas[0]) {			
			document.getElementsByName("complexion")[0].value=queryRet.datas[0].complexion;
			document.getElementsByName("hold_id")[0].value=queryRet.datas[0].hold_id;
		}			
	}
}

function save(){
	var path = cruConfig.contextPath+cruConfig.addOrUpdateAction;
	submitStr = getSubmitStr();
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);
	afterSubmit(retObject);
}

function afterSubmit(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		alert(successHint);
		cancel();
	}
}
function cancel()
{
	//window.parent.getNextTab();
}
</script>
</head>
<body onload="page_init()" style="background:#fff">
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_page_title" >
<tr>
	<td height=1 colspan="4" align=left></td>
</tr>
<tr>
	<td width="5%"  height=28 align=left ><img src="<%=contextPath%>/images/oms_index_09.gif" width="100%" height="28" /></td>
	<td id="cruTitle" width="40%" align=left background="<%=contextPath%>/images/oms_index_11.gif" class="text11">
 </td>
	<td width="5%" align=left ><img src="<%=contextPath%>/images/oms_index_13.gif" width="100%" height="28" /></td>
	<td width="50%" align=left style="background:url(<%=contextPath%>/images/oms_index_14.gif) repeat-x;">&nbsp;</td>
</tr>
</table>	
  <form name='fileForm' encType='multipart/form-data'  method='post' target='hidden_frame'>
<table id="rtCRUTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
  <span id="hiddenFields" style="display:none"></span>
</table>
<div id="oper_div">
<%
if(!"view".equals(request.getParameter("action"))){
%>
<span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%	
}
%>
</div>
</form>  <iframe name='hidden_frame' width='1' height='1' marginwidth='0' marginheight='0' scrolling='no' frameborder='0'></iframe>
</body>
</html>
