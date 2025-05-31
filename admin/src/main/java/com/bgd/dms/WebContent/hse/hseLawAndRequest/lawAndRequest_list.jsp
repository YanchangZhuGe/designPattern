<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String org_subjection_id = user.getOrgSubjectionId();
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	
	String org_sub_id = "C105";
	int len = list.size();
	if(len>0){
		if(((String)((Map)list.get(0)).get("organFlag"))!=null&&!((String)((Map)list.get(0)).get("organFlag")).equals("0")){
			org_sub_id = (String)((Map)list.get(0)).get("orgSubId");
			if(len>1){
				System.out.println((String)((Map)list.get(1)).get("organFlag"));
				if(((String)((Map)list.get(1)).get("organFlag"))!=null&&!((String)((Map)list.get(1)).get("organFlag")).equals("0")){
					org_sub_id = (String)((Map)list.get(1)).get("orgSubId");
					if(len>2){
						System.out.println((String)((Map)list.get(2)).get("organFlag"));
						if(((String)((Map)list.get(2)).get("organFlag"))!=null&&!((String)((Map)list.get(2)).get("organFlag")).equals("0")){
							org_sub_id = (String)((Map)list.get(2)).get("orgSubId");
						}
					}
				}
			}
		}
	}
	
	
	String if_sql = "select * from bgp_hse_law where bsflag='0' and org_sub_id='"+org_sub_id+"'";
	Map if_map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(if_sql);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">单位名称</td>
			    <td class="ali_cdn_input"><input id="orgName" name="orgName" type="text" /></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <%if(if_map==null){ %>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <%} %>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <%if(org_sub_id.equals("C105")){ %>
			    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="下载模板"></auth:ListButton>
			    <%} %>
			    
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_law_id},{org_sub_id}' id='rdo_entity_id_{hse_law_id}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{modifi_date}">修改日期</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">新增</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_accident_id" name="hse_accident_id"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="zj"><a href="#" onclick="toAddLineSelf()" title="新增"></a></span></td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
					<table  id="queryTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<input type="hidden" id="org_sub_id" name="org_sub_id" value=""></input>
						<input type="hidden" id="hse_law_id" name="hse_law_id" value=""></input>
						<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
						<input type="hidden" id="orderNum" name="orderNum" value="1"></input>
						 <tr align="center">
					    	    <td class="bt_info_odd">序号</td>
					            <td class="bt_info_even">法律、法规和其他要求名称</td>
					            <td class="bt_info_odd">文件号或编号</td>		
					            <td class="bt_info_even">实施日期</td>
					            <td class="bt_info_odd">删除</td>
					        </tr>
					</table>
				</div>
				</form>
			</div>
			 </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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


cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select la.*,oi.org_abbreviation,oi.org_name from bgp_hse_law la left join comm_org_subjection os on la.org_sub_id=os.org_subjection_id and os.bsflag='0'  left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where la.bsflag='0'  and (os.org_subjection_id='<%=org_sub_id%>' or os.father_org_id='<%=org_sub_id%>') order by os.org_subjection_id asc";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
		var orgName = document.getElementById("orgName").value
		if(orgName!=''&&orgName!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select la.*,oi.org_abbreviation,oi.org_name from bgp_hse_law la left join comm_org_subjection os on la.org_sub_id=os.org_subjection_id and os.bsflag='0'  left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where la.bsflag='0'  and (os.org_subjection_id='<%=org_sub_id%>' or os.father_org_id='<%=org_sub_id%>') and oi.org_name like '%"+orgName+"%' order by os.org_subjection_id asc";
			cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("orgName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		debugger;
		if(shuaId!=null){
			var temp = shuaId.split(",");
			var org_sub_id = document.getElementById("org_sub_id").value = temp[1];
		 	var hse_law_id = document.getElementById("hse_law_id").value = temp[0];
			
			for(var j =1;j <document.getElementById("queryTable")!=null && j < document.getElementById("queryTable").rows.length ;){
				document.getElementById("queryTable").deleteRow(j);
			}
			
		 	var checkSql4="select de.order_num,de.law_name,de.file_code,de.start_date,de.if_ok from bgp_hse_law_detail de where de.hse_law_id='"+hse_law_id+"' and de.if_ok='2' order by to_number(de.order_num) asc";
		    var queryRet4 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=300&querySql='+checkSql4);
			var datas4 = queryRet4.datas;
			debugger;
			if(datas4==null||datas4==""){
			}else{
				for(var i=0;i<datas4.length;i++){
					toAddLineSelf(
							datas4[i].order_num ? datas4[i].order_num : "",
							datas4[i].law_name ? datas4[i].law_name : "",
							datas4[i].file_code ? datas4[i].file_code : "",
							datas4[i].start_date ? datas4[i].start_date : ""
							);
				}
			}
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		   var temp = ids.split(",");
		   var org_sub_id = document.getElementById("org_sub_id").value = temp[1];
		   var hse_law_id = document.getElementById("hse_law_id").value = temp[0];
			
			for(var j =1;j <document.getElementById("queryTable")!=null && j < document.getElementById("queryTable").rows.length ;){
				document.getElementById("queryTable").deleteRow(j);
			}
			
		   	var checkSql4="select de.order_num,de.law_name,de.file_code,de.start_date,de.if_ok from bgp_hse_law_detail de where de.hse_law_id='"+hse_law_id+"' and de.if_ok='2' order by to_number(de.order_num) asc";
		    var queryRet4 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'pageSize=300&querySql='+checkSql4);
			var datas4 = queryRet4.datas;
			debugger;
			if(datas4==null||datas4==""){
			}else{
				for(var i=0;i<datas4.length;i++){
					toAddLineSelf(
							datas4[i].order_num ? datas4[i].order_num : "",
							datas4[i].law_name ? datas4[i].law_name : "",
							datas4[i].file_code ? datas4[i].file_code : "",
							datas4[i].start_date ? datas4[i].start_date : ""
							);
				}
			}
		}
	}
	
	function dbclickRow(shuaId){
		var retObj;
		if(shuaId!=null){
			var temp = shuaId.split(",");
			if(temp[1]=="C105"){
				popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLaw.jsp?action=view","1000:675");
			}else{
				popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLawOrg.jsp?action=view&org_sub_id="+temp[1],"1000:675");
			}
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var temp = ids.split(",");
		    if(temp[1]=="C105"){
				popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLaw.jsp?action=view","1000:675");
			}else{
				popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLawOrg.jsp?acrion=view&org_sub_id="+temp[1],"1000:675");
			}
		}
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	function toAdd(){
		var org_sub_id = "<%=org_sub_id%>";
		if(org_sub_id=="C105"){
			popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLaw.jsp","1000:675");
		}else{
			popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLawOrg.jsp?org_sub_id="+org_sub_id,"1000:675");
		}
		
	}
	
	
	function toUpdate(){
		var hse_law_id = document.getElementById("hse_law_id").value;
	  	if(hse_law_id==''||hse_law_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	
	  	var temp = "";
		var orders = document.getElementsByName("order");	
		for (var i=0;i<orders.length;i++){
			var order = orders[i].value;
			if(temp!=""){
				temp = temp+",";
			}
				temp = temp+order;
		}
		
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/hseLawAndRequest/addLawAndRequestOrgSelf.srq?temp="+temp;
		form.submit();
		$("#tab_box").mask("请等待...");
	}
	
	function toDownload(){
		window.location = "<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/hse/hseLawAndRequest/hseLaw.xlsx&filename=适用法律、法规和其他要求清单模板.xlsx";
	}
	
	function toEdit(){  
		debugger;
		var org_sub_id = document.getElementById("org_sub_id").value;
	  	if(org_sub_id==''||org_sub_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	if(org_sub_id=="<%=org_sub_id%>"){
	  		if(org_sub_id=="C105"){
				popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLaw.jsp","1000:675");
			}else{
				popWindow("<%=contextPath%>/hse/hseLawAndRequest/addLawOrg.jsp?org_sub_id="+org_sub_id,"1000:675");
			}
	  	}else{
	  		alert("只能对本单位进行修改");
	  		return;
	  	}
	} 
	
	
	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var temp = ids.split(",");
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteLaw", "org_sub_id="+temp[1]);
			queryData(cruConfig.currentPage);
		}
	}
	
	
	function toAddLineSelf(order_num,law,file_code,start_date){
		
		var order_num2 ="";
		var law2 = "";
		var file_code2 = "";
		var start_date2 = "";
		
		if(order_num!=null&&order_num!=""){
			order_num2 = order_num;
		}
		if(law!=null&&law!=""){
			law2 = law;
		}
		if(file_code!=null&&file_code!=""){
			file_code2 = file_code;
		}
		if(start_date!=null&&start_date!=""){
			start_date2 = start_date;
		}
		
		
		var rowNum = document.getElementById("lineNum").value;
		var orderNum = document.getElementById("orderNum").value;	
		
		var table=document.getElementById("queryTable");
		
		var lineId = "row_" + rowNum;
		var autoOrder = document.getElementById("queryTable").rows.length;
		var newTR = document.getElementById("queryTable").insertRow(autoOrder);
		newTR.id = lineId;
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
		
		
		var td = newTR.insertCell(0);
		td.innerHTML = "<input type='hidden' name='order' value='" + rowNum + "'/><input type='hidden' id='order_num"+rowNum+"' name='order_num"+rowNum+"' value='"+orderNum+"'>"+orderNum;
		td.id = "orderNumber"+rowNum;
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		var td = newTR.insertCell(1);
		td.innerHTML = "<input type='text' id='law"+rowNum+"' name='law"+rowNum+"' value='"+law2+"' size='50'>";
		td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		
		td = newTR.insertCell(2);
		td.innerHTML = "<input type='text' id='file_code"+rowNum+"' name='file_code"+rowNum+"' value='"+file_code2+"' size='30'>";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		td = newTR.insertCell(3);
		td.innerHTML = "<input type='text' id='start_date"+rowNum+"' name='start_date"+rowNum+"' value='"+start_date2+"' size='30'>";
		td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		td = newTR.insertCell(4);
		td.innerHTML = "<input type='hidden' id='if_ok"+rowNum+"' name='if_ok"+rowNum+"' value='2' /> <img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;
		document.getElementById("orderNum").value = parseInt(orderNum) + 1;
	}


	function deleteLine(lineId){		
		var rowNum = lineId.split('_')[1];
		//取删除行的主键ID
		var line = document.getElementById(lineId);		
		line.parentNode.removeChild(line);
		changeOrder();
	}

	function changeOrder(){
		debugger;
		var orders = document.getElementsByName("order");	
		for (var i=0;i<orders.length;i++){
			var order = orders[i].value;
			document.getElementById("orderNumber"+order).innerHTML = "<input type='hidden' name='order' value='" + order + "'/><input type='hidden' id='order_num"+order+"' name='order_num"+order+"' value='"+(i+1)+"'>"+(i+1);
		}
		document.getElementById("orderNum").value = orders.length + 1;
	}

</script>

</html>

