<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String back = request.getParameter("back");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getDocRemindStr()" >
<form id="CheckForm" action="" method="post" target="list" >

<div id="list_content" align="center">
<table width="80%" border="0" cellspacing="0" cellpadding="0">	
<tr>
	<td>
	<table id="equipmentTableInfo"  cellpadding="0" cellspacing="0" class="tab_info" width="100%">	
		    <tr class="bt_info" ><td class="tableHeader" width="90" colspan="7" id="td0"></td></tr>			  
			<tr class="bt_info"> 
				<td class="tableHeader" width="90">日期</td>
				<td class="tableHeader" width="90">测量基础资料检查结果</td>
				<td class="tableHeader" width="90">仪器基础资料检查结果</td>
				<td class="tableHeader" width="90">震源基础资料检查结果</td>
				<td class="tableHeader" width="90">QC基础资料检查结果</td>
				<td class="tableHeader" width="90">表层调查基础资料检查结果</td>
						<td class="tableHeader" width="90">气枪基础资料检查结果</td>
			</tr>						
	</table>
	</td>
</tr>
</table>
</div>
<div id="oper_div" style="align:right">
	<%if("org".equals(back)){ %>
    	<span class="gb_btn"><a href="#" onclick="orgReturn()"></a></span>
    <%}else{ %>
    	 <span class="gb_btn"><a href="#" onclick="teamReturn()"></a></span>
    <%} %>
</div>
</form>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
var projectInfoNo='<%=projectInfoNo%>';

function getDocRemindStr(){

	var str = "projectInfoNo=<%=projectInfoNo%>";
	var chartList = jcdpCallService("TdDocServiceSrv","queryChartTeamList",str);	
	document.getElementById("td0").innerHTML = chartList.projectName.project_name;

	if(chartList.detailInfo!=null){
		for(var i=0;i<chartList.detailInfo.length;i++){
		  var templateMap = chartList.detailInfo[i];
	      var tr = document.getElementById("equipmentTableInfo").insertRow();    
   
	      var acolor = "";
	      if(i % 2 == 1){  
	         tr.className = "odd";
	         acolor="#e7f2ff";
	         
		  }else{ 
			 tr.className = "even";
			 acolor = "#ffffff";
		  }
	      
          var td = tr.insertCell(0);
          
          var d_day = templateMap.d_day;  
          td.innerHTML = d_day;  
	      
          for(var j=1;j<=6;j++){
	          var td = tr.insertCell(j);
	          var str = "templateMap.n"+(j);
	          var nn = eval(str);
	          	          
	          if(nn=="1"){
	        	  td.innerHTML = "<a href=javascript:viewDoc('"+j+"','"+d_day+"') style=color:"+acolor+" >"+"<img id= "+"'"+"human_image"+"' src= '" + "<%=contextPath%>/images/point_green.png"+"' style='"+"width: 15px; height: 15px"+"' />"+"</a>";
	          }else if (nn=="2" || nn=="0"){
	        	  td.innerHTML = "<a href=javascript:viewDoc('"+j+"','"+d_day+"') style=color:"+acolor+" >"+"<img id= "+"'"+"human_image"+"' src= '" + "<%=contextPath%>/images/point_red.png"+"' style='"+"width: 15px; height: 15px"+"' />"+"</a>";
	          }else{
	        	  td.innerHTML = "";
	          } 
          }
        
	    }
    }
	
}


function viewDoc(num,dd){
	
	var docType = "";
	if(num == '1'){
		docType = "0110000061000000042";
	}else if(num == '2'){
		docType = "0110000061000000043";
	}else if(num == '3'){
		docType = "0110000061000000078";
	}else if(num == '4'){
		docType = "0110000061000000096";
	}else if(num == '5'){
		docType = "0110000061000000087";
	}else if(num == '6'){
		docType = "0110000061000001078";
	}

		
	popWindow('<%=contextPath%>/td/toCheckDocByDayView.srq?projectInfoNo='+projectInfoNo+'&docType='+docType+'&day='+dd,'800:600');
}

function orgReturn(){
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/checkDoc/tdChartOrg.jsp";
	form.submit();

}

function teamReturn(){
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/checkDoc/tdChartTeam.jsp";
	form.submit();

}
</script>  
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

