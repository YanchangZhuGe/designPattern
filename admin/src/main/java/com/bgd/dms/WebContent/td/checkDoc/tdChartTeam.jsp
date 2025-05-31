<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	
	String projectType=user.getProjectType();
	if("5000100004000000008".equals(projectType)){//井中
		response.sendRedirect(contextPath+"/td/checkDoc/tdChartTeamJz.jsp");
	}
	
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
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getChartAduitList()" >
<div id="list_content" align="center">
<table width="70%" border="0" cellspacing="0" cellpadding="0">		
<tr style="height:30px;">
<MARQUEE scrollamount="4"><span id="td0" style="width:300px;height:30px;color:red;font-size:16px" ></span></MARQUEE>
</tr>	
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >	
<tr>
	<td>
   <div class="tongyong_box">
	<div class="tongyong_box_title"><span class="kb"><a
		href="#"></a></span><a href="#">设计总结审批状态</a><span class="gd"><a
		href="#"></a></span></div>
	 <div class="tongyong_box_content_left"  id="chartContainer1">	
	<table id="equipmentTableInfo"  cellpadding="0" cellspacing="0" class="tab_info" width="100%">
		  <thead>
			<tr class="bt_info"> 
				<td class="tableHeader" width="10%" colspan="2">技术设计</td>
				<td class="tableHeader" width="10%" colspan="2">施工设计</td>
				<td class="tableHeader" width="10%" colspan="2">试验设计</td>
				<td class="tableHeader" width="10%" colspan="2">变观方案</td>
				<td class="tableHeader" width="10%" colspan="2">技术支持申请 </td>
				<td class="tableHeader" width="10%" colspan="2">试验总结 </td>
				<td class="tableHeader" width="10%" colspan="2">施工总结 </td>
			</tr>
			<tr class="bt_info"> 
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
				<td class="tableHeader" width="5%">待审批</td>
				<td class="tableHeader" width="5%">已审批</td>
			</tr>
		</thead>
		</table>
		</div>
	</div>
	</td>
</tr>
<tr style="height:30px;">
</tr>
<tr>
	<td width="98%">	
	<div class="tongyong_box">
	<div class="tongyong_box_title"><span class="kb"><a
		href="#"></a></span><a href="#">项目技术文档上传统计</a><span class="gd"><a
		href="#"></a></span></div>
		 <div class="tongyong_box_content_left"  id="chartContainer1">	
		<table id="listTableInfo"  cellpadding="0" cellspacing="0"  class="tab_info" width="100%"  >
		  <thead>
		  	<tr class="bt_info"> 				
				<td class="tableHeader" >工区踏勘</td>
				<td class="tableHeader" >工区卫星<br/>图片</td>
				<td class="tableHeader" >部&nbsp;署&nbsp;图</td>
				<td class="tableHeader" >备&nbsp;忘&nbsp;录</td>
				<td class="tableHeader" >表层调查<br/>数据库</td>
				<td class="tableHeader" >技术总结 </td>
				<td class="tableHeader" >测量<br/>基础资料<br/>检查结果 </td>
				<td class="tableHeader" >仪器<br/>基础资料<br/>检查结果 </td>
				<td class="tableHeader" >震源<br/>基础资料<br/>检查 结果</td>
				<td class="tableHeader" >QC<br/>基础资料<br/>检查 结果</td>
				<td class="tableHeader" >表层调查<br/>基础资料<br/>检查结果</td>
			   <td class="tableHeader" >气枪<br/>基础资料<br/>检查结果</td>
			</tr>
		 </thead>
		</table>
		</div>
	</div>		
	</td>
</tr>
</table>
</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";

function getChartAduitList(){
	
	var obj=jcdpCallService("TdDocServiceSrv","getDocRemindStr","");
	document.getElementById("td0").innerHTML = obj.str;
	var str = "projectInfoNo=<%=projectInfoNo%>";
	var obj = jcdpCallService("TdDocServiceSrv","queryChartAduitList",str);	
	var chartList = jcdpCallService("TdDocServiceSrv","queryChartOrgNumsList",str);	
	
	if(obj.detailInfo!=null){
		for(var i=0;i<obj.detailInfo.length;i++){
			var templateMap = obj.detailInfo[i];
	          var tr = document.getElementById("equipmentTableInfo").insertRow();    
	          
	        	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
	          
	          for(var j=0;j<14;j++){
	        	  
		          var td = tr.insertCell(j);
		          var str = "templateMap.n"+(parseInt(j)+1);
		          var nn = eval(str);
		          
		          if(nn != '0'){
		        	  
		        	    var isDone = "";
		    	        if(j % 2 == 1){  
		    	        	 isDone = "1";
		    			}else{ 
		    				 isDone = "0";
		    			}
		    	      
		        	    var businessType = "";
		        		if(j == 0 || j == 1 ){
		        			businessType = "5110000004100000059";
		        		}else if(j == 2 || j == 3 ){
		        			businessType = "5110000004100000051";
		        		}else if(j == 4 || j == 5 ){
		        			businessType = "5110000004100000052";
		        		}else if(j == 6 || j == 7 ){
		        			businessType = "5110000004100000053";
		        		}else if(j == 8 || j == 9 ){
		        			businessType = "5110000004100000054";
		        		}else if(j == 10 || j == 11 ){
		        			businessType = "5110000004100000063";
		        		}else if(j == 12 || j == 13 ){
		        			businessType = "5110000004100000064";
		        		}
		        		
		        	  td.innerHTML = "<a href=<%=contextPath%>/bpm/common/toGetSelfProcessList.srq?businessType="+businessType+"&projectInfoNo=<%=projectInfoNo%>&isDone="+isDone+">"+nn+"</a>";	 
		          }else{
		        	  td.innerHTML = nn;	  
		          }
		          
	          }

	     }
	}  
	
	if(chartList.detailInfo!=null){
		for(var i=0;i<chartList.detailInfo.length;i++){

		  var templateMap = chartList.detailInfo[i];
	      var tr = document.getElementById("listTableInfo").insertRow();    
   
	      if(i % 2 == 1){  
	         tr.className = "odd";
		  }else{ 
			 tr.className = "even";
		  }
          
          var pid = templateMap.project_info_no;
                   
          for(var j=0;j<12;j++){
        	  
	          var td = tr.insertCell(j);
	          var str = "templateMap.n"+(parseInt(j)+1);
	          var nn = eval(str);
	          
	          if(nn != '0'){
		          if(j<6){
		        	  var codingCodeId = "";
		        		if(j == 0){
		        			codingCodeId = "0110000061000000050";
		        		}else if(j == 1){
		        			codingCodeId = "0110000061000000070";
		        		}else if(j == 2){
		        			codingCodeId = "0110000061000000075";
		        		}else if(j == 3){
		        			codingCodeId = "0110000061000000052";
		        		}else if(j == 4){
		        			codingCodeId = "0110000061000000073";
		        		}else if(j == 5){
		        			codingCodeId = "0110000061000000053";
		        		}
		        	  
		        	  td.innerHTML = "<a href=<%=contextPath%>/td/doc/tdDocList.jsp?projectInfoNo="+pid+"&codingCodeId="+codingCodeId+">"+nn+"</a>";	    
		          }else{
		        	  var dn = nn.split("-");
		        	  if(parseInt(dn[1])>0){
		        		  td.innerHTML = "<a href=<%=contextPath%>/td/checkDoc/tdChartDocTeam.jsp?back=org&projectInfoNo="+pid+"><strong>"+dn[0]+"</strong></a>";
		        	  }else{
		        		  td.innerHTML = "<a href=<%=contextPath%>/td/checkDoc/tdChartDocTeam.jsp?back=org&projectInfoNo="+pid+">"+dn[0]+"</a>";
		        	  }
		          }
	          }else{
	        	  td.innerHTML = nn;	
	          }
	               
          }
	          	
	     }
	 }  
	      
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

