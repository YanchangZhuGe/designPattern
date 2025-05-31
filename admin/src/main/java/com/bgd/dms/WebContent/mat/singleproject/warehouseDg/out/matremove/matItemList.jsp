<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td>&nbsp;</td>
			  <auth:ListButton functionId="" css="hz" event="onclick='toChange()'" title="转出"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{out_info_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{out_progect_name}">转出项目</td>
					<td class="bt_info_even" exp="{in_progect_name}">转入项目</td>
					<td class="bt_info_odd" exp="{operator}">操作人</td>
					<td class="bt_info_even" exp="{total_money}">金额</td>
					<td class="bt_info_odd" exp="{out_date}">转出时间</td>
					<td class="bt_info_even" exp="{proc_statue}">转出时间</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			    <li id='tag3_4' style="display:none"><a href="#" onclick="getTab3(4)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  id="planDetail"border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
			    		<td class="bt_info_odd">序号</td>
			    		<td  class="bt_info_even">物资分类码</td>
			    	  	<td  class="bt_info_odd">物资编码</td>
			            <td  class="bt_info_even">物资说明</td>
			            <td class="bt_info_odd">单位</td>
			            <td class="bt_info_even">转出数量</td>
			            <td  class="bt_info_odd">物资单价</td>
			            <td class="bt_info_even">金额</td>
			        </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" >
				<wf:startProcessInfo   title=""/>
			</div>
		</div>
</div>
</body>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	var rootId = "8ad889f13759d014013759d3de520003";
	cruConfig.contextPath =  "<%=contextPath%>";
	var userId = '<%=userId%>';
	var org_id = "<%=user.getOrgId() %>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql ="select t.out_info_id,p.project_name as out_progect_name,gp.project_name as in_progect_name,t.out_date,t.operator,t.total_money,decode(m.proc_status, '1', '待审批', '3', '审批通过', '4', '审批不通过', '未提交') proc_statue from GMS_MAT_OUT_INFO t  inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no inner join gp_task_project gp on t.input_org = gp.project_info_no left join common_busi_wf_middle m on t.out_info_id = m.business_id and m.bsflag = '0' where t.project_info_no='<%=projectInfoNo%>' and t.out_type='4' and t.bsflag='0'";
		if(org_id!=null&&(org_id=="C6000000000039"||org_id=="C6000000000040"||org_id=="C6000000005275"||org_id=="C6000000005277"||org_id=="C6000000005278"||org_id=="C6000000005279"||org_id=="C6000000005280")){
			sql += " and ot.wz_type='11' and t.org_id = '"+org_id+"'";
		  }else{
			  sql += " and ot.wz_type = '22'";
		}
		sql += " order by t.out_date desc,t.modifi_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/out/matremove/matItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
	
		var retObj;
		if(shuaId!= undefined){
			 taskShow(shuaId);
			 $("#tag3_4").show();
			 processNecessaryInfo={
						businessTableName:"GMS_MAT_OUT_INFO",	
						businessType:"5110000004100001083",
						businessId: shuaId,
						businessInfo:"<%=user.getProjectName()%>-转出计划申请",
						applicantDate: '<%=appDate%>'
					};
					
					processAppendInfo = {
							out_info_id:shuaId
					};
					loadProcessHistoryInfo();
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     taskShow(ids);
		}
	
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;  
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  

       //汇总信息
    	 function taskShow(value){
    			for(var j =1;j <document.getElementById("planDetail")!=null && j < document.getElementById("planDetail").rows.length ;){
    				document.getElementById("planDetail").deleteRow(j);
    			}
    			var retObj = jcdpCallService("MatItemSrv", "getRemoveMatList", "ids="+value);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var wzName = taskList[i].wzName;
    				var wzId = taskList[i].wzId;
    				var codingCodeId = taskList[i].codingCodeId; 
    				var wzPrickie = taskList[i].wzPrickie;
    				var wzPrice = taskList[i].outPrice;
    				var demandNum = taskList[i].outNum;
    				var demandMoney = taskList[i].totalMoney;
    				var autoOrder = document.getElementById("planDetail").rows.length;
    				var newTR = document.getElementById("planDetail").insertRow(autoOrder);
    				var tdClass = 'even';
    				if(autoOrder%2==0){
    					tdClass = 'odd';
    				}
    		        var td = newTR.insertCell(0);
    	
    		        td = newTR.insertCell(0);
    		        td.innerHTML = autoOrder;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(1);
    				
    		        td.innerHTML = codingCodeId;
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
    		        
    		        td = newTR.insertCell(2);

    		        td.innerHTML = wzId;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    				td = newTR.insertCell(3);
    				
    		        td.innerHTML = wzName;
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
    		        td = newTR.insertCell(4);

    		        td.innerHTML = wzPrickie;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		      td = newTR.insertCell(5);

  		        td.innerHTML = demandNum;
  		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
    		     
  		      td = newTR.insertCell(6);

		        td.innerHTML = wzPrice;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		      td = newTR.insertCell(7);

		        td.innerHTML = demandMoney;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
  		     
    		        newTR.onclick = function(){
    		        	// 取消之前高亮的行
    		       		for(var i=1;i<document.getElementById("planDetail").rows.length;i++){
    		    			var oldTr = document.getElementById("planDetail").rows[i];
    		    			var cells = oldTr.cells;
    		    			for(var j=0;j<cells.length;j++){
    		    				cells[j].style.background="#96baf6";
    		    				// 设置列样式
    		    				if(i%2==0){
    		    					if(j%2==1) cells[j].style.background = "#FFFFFF";
    		    					else cells[j].style.background = "#f6f6f6";
    		    				}else{
    		    					if(j%2==1) cells[j].style.background = "#ebebeb";
    		    					else cells[j].style.background = "#e3e3e3";
    		    				}
    		    			}
    		       		}
    					// 设置新行高亮
    					var cells = this.cells;
    					for(var i=0;i<cells.length;i++){
    						cells[i].style.background="#ffc580";
    					}
    				}
    			}
    			
    		}
 		function toChange(){
 			popWindow("<%=contextPath%>/mat/singleproject/warehouseDg/out/matremove/matRemoveEdit.jsp",'1024:768');
//			popWindow("<%=contextPath%>/mat/singleproject/warehouse/out/matremove/matRemoveEdit.jsp",'1024:768');
 	 		}
</script>

</html>

