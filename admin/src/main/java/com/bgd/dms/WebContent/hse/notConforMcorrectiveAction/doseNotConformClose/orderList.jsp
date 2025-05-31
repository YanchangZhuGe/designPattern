<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = "8ad891d338a1d0550138a1fc0f770002";
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>不符合通知单</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">审核单位</td>
			    <td class="ali_cdn_input"><input id="orgName1" name="orgName1" type="text"    />
			    <input  id="paramsName" name="paramsName" type="hidden" />
			    <input  id="paramsNum" name="paramsNum" type="hidden" />
			    <input  id="detilNo" name="detilNo" type="hidden" />
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td> 
			    
			    <auth:ListButton functionId="" css="tj" event="onclick='toEdit()'" title="JCDP_btn_submit"></auth:ListButton>
	 
			    </td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>    
			      <td class="bt_info_odd" 	 exp="<input type='radio' name='chx_entity_id'  id='chx_entity_id{order_no}' value='{order_no}'\>">选择</td>
					<td class="bt_info_even" 	 autoOrder="1">序号</td>
					<td class="bt_info_odd" 	 exp="{org_name}" >被检查/审核单位</td>
					<td class="bt_info_even" 	 exp="{audit_date}">检查/审核日期</td>
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
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
 
	function toAdd(){
		 
		popWindow('<%=contextPath%>/hse/notConforMcorrective/edit.srq?func=1','1024:800');
	
	}
	
	function changeTest(){
	 var  obj=document.getElementById("paramsName").value;
	 var  objNum=document.getElementById("paramsNum").value;
	 var  objNo=document.getElementById("detilNo").value;
	 window.opener.document.getElementById("close_content").value = obj;
	 window.opener.document.getElementById("nonumber").value = objNum;
	 window.opener.document.getElementById("detilNo").value = objNo;
	 
	 window.close();
		
		
	}
	
	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var train_plan_no =  tempa[0];    
 
	    window.open("<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/operationInsert.jsp?id="+train_plan_no+"&update=true&func=1",'twoPage','height=500,width=950px,left=150px,top=100px,menubar=no,status=no,toolbar=no'); 

	    //editUrl = "/rm/em/toHumanPrepareEdit.srq?id="+requirement_no+"&update=true"+"&prepareNo="+prepare_no+"&func=1";
	    	//window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	       var train_plan_no =  tempa[0];    
		var sql = "update BGP_NOACCORDWITH_ORDER set bsflag='1' where order_no ='"+train_plan_no+"'"; 
		deleteEntities(sql);
		alert('删除成功！');
	}
	
	 
	function refreshData(){
		cruConfig.queryStr = "select  ion.org_name,t.order_no,t.audit_unit,t.audit_date   from  BGP_NOACCORDWITH_ORDER t  join comm_org_subjection os1     on t.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id  where t.bsflag='0' order by t.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotComplyNotice/orderList.jsp";
		queryData(1);
	}
	 
	
	// 简单查询
	function simpleSearch(){
			var changeName = document.getElementById("orgName1").value;
				if(changeName!=''&& changeName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = " select  ion.org_name,t.order_no,t.audit_unit,t.audit_date   from  BGP_NOACCORDWITH_ORDER t  join comm_org_subjection os1     on t.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id  where t.bsflag='0'  and ion.org_name like'%"+changeName+"%' order by t.modifi_date desc ";
					cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/doseNotComplyNotice/orderList.jsp";
					queryData(1);
				}else{
					alert('请输入查询内容！');
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("orgName1").value = "";
	}

 
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

    function loadDataDetail(ids){
    	 var tempa = ids.split(','); 	    
 	    var trainPlanId =  tempa[0];    
	 
	 
		
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
</html>