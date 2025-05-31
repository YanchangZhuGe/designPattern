<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName=user.getUserName();
	String orgName=user.getOrgName();
	String assistType=request.getParameter("assistType");
	if(assistType==null) assistType="1";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>辅助单位费用管理</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
					    <td>&nbsp;</td>
			    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton css="ck" event="onclick='toViewMoney()'" title="JCDP_btn_view"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr>
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{assist_info_id}' id='rdo_entity_id_{assist_info_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{record_org_name}">单位名称</td>
			      <td class="bt_info_even" exp="{year}">年份</td>
			      <td class="bt_info_even" exp="{month}">月份</td>
			      <td class="bt_info_even" exp="{employee_name}">创建人</td>
			      <td class="bt_info_odd" exp="{create_date}">创建时间</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li id="tag3_0"><a href="#" onclick="getTab3(0)">文档</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">分类码</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box" style="overflow:hidden;">
				    <div id="tab_box_content0" class="tab_box_content" style="display: none">
				    <iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				    </iframe>
				    </div>
				    <div id="tab_box_content1" class="tab_box_content" style="display: none">
				    	<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
						</iframe>
				    </div>
				    <div id="tab_box_content2" class="tab_box_content" style="display: none">
				    	<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				    </div>
			</div>
</body>

<script type="text/javascript">


	$(document).ready(readyForSetHeight);

	frameSize();
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var assistType = '<%=assistType%>';
	
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			refreshData();
		}
	}
	function refreshData(){
		cruConfig.queryStr = "SELECT t.*,TO_CHAR(t.RECORD_TIME, 'yyyy') AS YEAR,TO_CHAR(t.RECORD_TIME, 'MM')   AS MONTH"+
			" FROM bgp_op_cost_assist_info t where t.bsflag='0' and t.assist_type='"+assistType+"' order by t.record_time desc";
		cruConfig.currentPageUrl = "/op/costAssistManager/costAssistManagerList.jsp";
		queryData(1);
	}
	function toView(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costAssistManager/costAssistManagerEdit.upmd?pagerAction=edit2View&id='+ids);
	}
	function toAdd(){
		popWindow('<%=contextPath%>/op/costAssistManager/costAssistManagerEdit.upmd?pagerAction=edit2Add&userName=<%=userName%>&orgName=<%=orgName%>&assistType='+assistType);
	}

	
	function toEdit() {
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costAssistManager/costAssistManagerEdit.upmd?pagerAction=edit2Edit&userName=<%=userName%>&orgName=<%=orgName%>&assistType='+assistType+'&id='+ids);
	}
	function toDelete(){

		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update bgp_op_cost_assist_info t set t.bsflag='1' where t.assist_info_id ='"+ids+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		refreshData();
	}

	
	function loadDataDetail(ids){
		
		
		//载入文档信息
		document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
		//载入备注信息
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		//载入分类吗信息
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+ids
	}
	
	
	function toViewMoneyInfo(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costMangerVersion/costMangerVersionMoney.jsp?projectInfoNo='+projectInfoNo+'&costProjectSchemaId='+ids);
	}
	
	function toViewMoney(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costAssistManager/costAssistMoneyManager.jsp?assistInfoId='+ids+'&assistType='+assistType);
	}
	
    //chooseOne()函式，參數為觸發該函式的元素本身
    function chooseOne(cb){
        //先取得同name的chekcBox的集合物件
        var obj = document.getElementsByName("rdo_entity_id");
        for (i=0; i<obj.length; i++){
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選
            if (obj[i]!=cb) obj[i].checked = false;
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選
            //else  obj[i].checked = cb.checked;
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行
            else obj[i].checked = true;
        }
    }
    
    function toSerach(){
    	var obj=new Object();
    	window.showModalDialog("<%=contextPath%>/op/costProjectManager/costProjectManagerChoose.jsp",obj,"dialogWidth=800px;dialogHeight=600px");
    	document.getElementById("projectInfoNo").value=obj.value;
    	changeProjectInfoNo();
    }
</script>
</html>