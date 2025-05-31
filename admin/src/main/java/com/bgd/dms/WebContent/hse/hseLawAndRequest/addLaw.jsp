<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
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
	
	String action = request.getParameter("action");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_law_id" name="hse_law_id" value=""></input>
<input type="hidden" id="org_sub_id" name="org_sub_id" value="<%=org_sub_id%>"></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr align="right" height="20">
		    	<td>&nbsp;</td>
		        <td width="30" id="buttonDis3"><span class="dr"><a href="#" onclick="toUpload()" title="导入"></a></span></td>
		        <td width="5"></td>
		    </tr>
		</table>
    
		<table id="queryTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
		<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
		 <tr align="center">
	    	    <td class="bt_info_odd">序号</td>
	            <td class="bt_info_even">法律、法规和其他要求名称</td>
	            <td class="bt_info_odd">文件号或编号</td>		
	            <td class="bt_info_even">实施日期</td>
	        </tr>
		</table>
	</div>
	<div id="oper_div">
	<%if(action==null||!action.equals("view")){ %>
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
	<%} %>
		<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
	</div>
</div>
</div> 
</form>
</body>

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

function submitButton(){
	
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
	form.action="<%=contextPath%>/hse/hseLawAndRequest/addLawAndRequest.srq?temp="+temp;
	form.submit();
	$("#new_table_box_bg").mask("请等待...");
}

function closeButton(){
	$("#new_table_box_bg").unmask();
	newClose();
}


function toUpload(){
	var obj=window.showModalDialog('<%=contextPath%>/hse/hseLawAndRequest/importFile.jsp',"","dialogHeight:500px;dialogWidth:600px");
	if(obj!="" && obj!=undefined ){		
		for(var j =1;j <document.getElementById("queryTable")!=null && j < document.getElementById("queryTable").rows.length ;){
			document.getElementById("queryTable").deleteRow(j);
		}
		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){
			var check = checkStr[i].split("@");  
			debugger;
			toAddLine(check[0],check[1],check[2],check[3]);
		}
		
	}
}


//保留小数后几位   四舍五入
function toDecimal(x) {   
    var f = parseFloat(x);   
    if (isNaN(f)) {   
        return;   
    }   
    f = Math.round(x*1000)/1000;   
    return f;   
}


function toAddLine(order_num,law,file_code,start_date){
	
	var order_num2 ="";
	var law2 = "";
	var file_code2 = "";
	var start_date2 = "0";
	
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
	td.innerHTML = "<input type='hidden' name='order' value='" + rowNum + "'/><input type='hidden' id='order_num"+rowNum+"' name='order_num"+rowNum+"' value='"+order_num2+"'>"+order_num2;
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	var td = newTR.insertCell(1);
	td.innerHTML = "<input type='hidden' id='law"+rowNum+"' name='law"+rowNum+"' value='"+law2+"'>"+law2;
	td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	
	td = newTR.insertCell(2);
	td.innerHTML = "<input type='hidden' id='file_code"+rowNum+"' name='file_code"+rowNum+"' value='"+file_code2+"'>"+file_code2;
	td.className = tdClass+'_odd';
	   if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
	td = newTR.insertCell(3);
	td.innerHTML = "<input type='hidden' id='start_date"+rowNum+"' name='start_date"+rowNum+"' value='"+start_date2+"'>"+start_date2;
	td.className =tdClass+'_even'
    if(autoOrder%2==0){
		td.style.background = "#FFFFFF";
	}else{
		td.style.background = "#ebebeb";
	}
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
}
toEdit();
function toEdit(){
	var checkSql="select la.org_sub_id,la.hse_law_id,de.order_num,de.law_name,de.file_code,de.start_date from bgp_hse_law la left join bgp_hse_law_detail de on la.hse_law_id=de.hse_law_id where la.bsflag='0' and la.org_sub_id='<%=org_sub_id%>' order by to_number(de.order_num) asc";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	if(datas==null||datas==""){
		
	}else{
		debugger;
		document.getElementById("hse_law_id").value = datas[0].hse_law_id;
		document.getElementById("org_sub_id").value = datas[0].org_sub_id;
		
		for(var i=0;i<datas.length;i++){
			toAddLine(
					datas[i].order_num ? datas[i].order_num : "",
					datas[i].law_name ? datas[i].law_name : "",
					datas[i].file_code ? datas[i].file_code : "",
					datas[i].start_date ? datas[i].start_date : ""
					);
		}
	}
}


</script>
</html>