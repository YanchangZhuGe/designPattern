<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo(); 
 	String sql = " select father_org_id  from comm_org_subjection where  org_subjection_id='"+orgId +"'  and bsflag='0' ";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = orgId ;
	if(orgId !="C105007"){
	if(list.size()>0){
	 	Map map = (Map)list.get(0); 
	 	father_id = (String)map.get("fatherOrgId");	  
	}
	}
	Calendar cal = new GregorianCalendar();
	cal.setTime(new Date());
	int daynum = cal.getActualMaximum(Calendar.DAY_OF_MONTH); 
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
 
 
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>

<%
if("C105007".equals(father_id)){

%>
<body style="background: #fff; " onload="getChartAduitList();" >
<div id="tag-container_3" >
<ul id="tags" class="tags">

<li class="selectTag" id="tag3_0" name="tag3_0"> <a href="#" onclick="getTab()">信息动态</a></li>

<%
}else  if(orgId.startsWith("C105005001") || "C105".equals(orgId) ){
	 
%>
<body style="background: #fff; " onload="getTab1();getChartAduitList();" >
<div id="tag-container_3" >
<ul id="tags" class="tags">
<li class="selectTag" id="tag3_0" name="tag3_0"><a href="#" onclick="getTab()">信息动态</a></li> 
<li id="tag3_1" name="tag3_1"><a href="#" onclick="getTab1()">井中(父项目)</a></li>
<li id="tag3_2" name="tag3_2"><a href="#" onclick="getTab2()">井中(子项目)</a></li>

<%
}else{
%>
<body style="background: #fff; " onload="getChartAduitList();" >
<div id="tag-container_3" >
<ul id="tags" class="tags">

<li class="selectTag" id="tag3_0" name="tag3_0"><a href="#" onclick="getTab()">信息动态</a></li>

<%
} 
%>
</ul>
</div>
<div id="tab_box" class="tab_box"  >
<div id="tab_box_content0" class="tab_box_content" style="background:#fff;height:500px;overflow-x:hidden; overflow-y: scroll; "  > 


<div id="list_content" >
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali_cdn_name">所属单位</td>
    <td width="20%">
        <input name="s_org_id" id="s_org_id" class="input_width" value="" type="hidden" readonly="readonly"/> 
        <input name="s_org_name" id="s_org_name" class="input_width" value="" type="text" readonly="readonly"/> 
        <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/> 
    </td>
    <td class="ali_cdn_name">项目重要程度:</td>
    <td class="ali_cdn_input">
    	<code:codeSelect cssClass="select_width"   name='is_main_project' option="isMainProject"   selectedValue="0300100008000000002"  addAll="true" />
    </td> 
    <td class="ali_cdn_name">项目状态:</td>
    <td class="ali_cdn_input">
    	<code:codeSelect cssClass="select_width"   name='project_status' option="projectStatus"  selectedValue=""  addAll="true" />
    </td>  
    <td>&nbsp;</td>	 
    <td class="ali_query">
   		<span class="cx"><a href="#" onclick="getChartAduitList()" title="JCDP_btn_query"></a></span>
  		</td>
    <td class="ali_query">
	    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
	</td>
		
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="98%">	
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">设计总结审批状态</a><span class="gd"><a
							href="#"></a></span></div>
						 <div class="tongyong_box_content_left"  id="chartContainer1">			 
			
			 				<table id="equipmentTableInfo"  cellpadding="0" cellspacing="0" class="tab_info" width="100%">
							  <thead>
								<tr class="bt_info"> 
								    <td class="tableHeader" width="10%" rowspan="2">项目名称</td>
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
				</table>
				</td>
			</tr>
			<tr style="height:30px;"></tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
								    <td class="tableHeader" >项目名称</td>
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
							  	<%--
								<tr class="bt_info"> 								
									<td class="tableHeader" width="300">项目</td>
									<td class="tableHeader" width="90">检查类型</td>
									     <%for(int i=1;i<=daynum;i++){%>
     										<td class="tableHeader" width="30"><%=i%></td>
     								     <%} %>
								</tr>
								 --%>
							 </thead>
							</table>
							</div>
						</div>							
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
  
</div>


</div> 	 	 
 <div id="tab_box_content1" class="tab_box_content" style="display:none;background:#fff;height:600px;overflow-x:hidden;overflow-y:hidden;" > 
	<iframe width="100%" height="100%" name="selectLabor" id="selectLabor" frameborder="0" src="<%=contextPath%>/td/checkDoc/tdChartOrgJz.jsp?reportId=js_father_report.raq" marginheight="0" marginwidth="0" >
	</iframe>	
 </div>   
 <div id="tab_box_content2" class="tab_box_content" style="display:none;background:#fff;height:600px;overflow-x:hidden;overflow-y:hidden;" > 
	<iframe width="100%" height="100%" name="selectLabors" id="selectLabors" frameborder="0" src="<%=contextPath%>/td/checkDoc/tdChartOrgJz.jsp?reportId=js_jzi_report.raq" marginheight="0" marginwidth="0" >
	</iframe>	
 </div>  
</div>

</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
var daynum = parseInt('<%=daynum%>');
 ;
function getStr(){
	var str = "";
	var s_org_id = document.getElementById("s_org_id").value; 
	var is_main_project = document.getElementById("is_main_project").value; 
	var project_status = document.getElementById("project_status").value;
	
	if(s_org_id != ''){
		str +="s_org_id="+s_org_id;
	}else{
		str +="s_org_id=<%=orgId%>";
	}
	if(is_main_project != '' ){
		if(str == ''){
			str +="is_main_project="+is_main_project;
		}else{
			str +="&is_main_project="+is_main_project;
		}
	}
	if(project_status != '' ){
		if(str == ''){
			str +="project_status="+project_status;
		}else{
			str +="&project_status="+project_status;
		}
	}
	return str;
}

function getChartAduitList(){
	
	var str = getStr();

	var obj = jcdpCallServiceCache("TdDocServiceSrv","queryChartAduitList",str);	
	var chartList = jcdpCallServiceCache("TdDocServiceSrv","queryChartOrgNumsList",str);	
	
	deleteTableTr2("equipmentTableInfo");
	deleteTableTr("listTableInfo");

	if(obj.detailInfo!=null){
		for(var i=0;i<obj.detailInfo.length;i++){
			var templateMap = obj.detailInfo[i];
	          var tr = document.getElementById("equipmentTableInfo").insertRow();    
	          
	        	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

	                  
	          var td = tr.insertCell(0);
	          td.innerHTML = templateMap.projectName;  
	          
	          var pid = templateMap.projectInfoNo;
	          
	          for(var j=1;j<=14;j++){
	        	  
		          var td = tr.insertCell(j);
		          var str = "templateMap.n"+j;
		          var nn = eval(str);
		          
		          
		          if(nn != '0'){
		        	  
		        	    var isDone = "";
		    	        if(j % 2 == 1){  
		    	        	 isDone = "0";
		    			}else{ 
		    				 isDone = "1";
		    			}
		    	      
		        	    var businessType = "";
		        		if(j == 1 || j == 2 ){
		        			businessType = "5110000004100000059";
		        		}else if(j == 3 || j == 4 ){
		        			businessType = "5110000004100000051";
		        		}else if(j == 5 || j == 6 ){
		        			businessType = "5110000004100000052";
		        		}else if(j == 7 || j == 8 ){
		        			businessType = "5110000004100000053";
		        		}else if(j == 9 || j == 10 ){
		        			businessType = "5110000004100000054";
		        		}else if(j == 11 || j == 12 ){
		        			businessType = "5110000004100000063";
		        		}else if(j == 13 || j == 14 ){
		        			businessType = "5110000004100000064";
		        		}
		        		
		        	  td.innerHTML = "<a href=<%=contextPath%>/bpm/common/toGetSelfProcessList.srq?businessType="+businessType+"&projectInfoNo="+pid+"&isDone="+isDone+">"+nn+"</a>";	 
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

          var td = tr.insertCell(0);
          td.style.cssText="word-break:break-all; word-wrap:break-word;";  
          td.innerHTML = templateMap.project_name;  
          
          var pid = templateMap.project_info_no;
          
          
          for(var j=1;j<=12;j++){
	          var td = tr.insertCell(j);
	          var str = "templateMap.n"+j;
	          var nn = eval(str);
	          
	          if(nn != '0'){
		          if(j<=6){
		        	  var codingCodeId = "";
		        		if(j == 1){
		        			codingCodeId = "0110000061000000050";
		        		}else if(j == 2){
		        			codingCodeId = "0110000061000000070";
		        		}else if(j == 3){
		        			codingCodeId = "0110000061000000075";
		        		}else if(j == 4){
		        			codingCodeId = "0110000061000000071";
		        		}else if(j == 5){
		        			codingCodeId = "0110000061000000073";
		        		}else if(j == 6){
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

function getTab() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1];
	var selectedTag2=document.getElementsByTagName("li")[2];
	
	if(selectedTag!=null){
		selectedTag.className ="selectTag";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="";
	}
	if(selectedTag2!=null){
		selectedTag2.className ="";
	}
	
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="NONE";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="BLOCK";
	var selectedTabBox1 = document.getElementById("tab_box_content2")
	selectedTabBox1.style.display="NONE";
}

function getTab1() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1];
	var selectedTag2=document.getElementsByTagName("li")[2];
	
	if(selectedTag!=null){
		selectedTag.className ="";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="selectTag";
	}
	if(selectedTag2!=null){
		selectedTag2.className ="";
	}
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="BLOCK";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="NONE";
	var selectedTabBox1 = document.getElementById("tab_box_content2")
	selectedTabBox1.style.display="NONE";
}

function getTab2() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1];
	var selectedTag2=document.getElementsByTagName("li")[2];
	
	if(selectedTag2!=null){
		selectedTag2.className ="selectTag";
	}
	if(selectedTag!=null){
		selectedTag.className ="";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="";
	}
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="NONE";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="NONE";
	var selectedTabBox1 = document.getElementById("tab_box_content2")
	selectedTabBox1.style.display="BLOCK";
}

//选择单位
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("s_org_id").value = teamInfo.fkValue;
        document.getElementById("s_org_name").value = teamInfo.value;
    }
}

function clearQueryText(){ 
	 document.getElementById("s_org_id").value=''; 
	 document.getElementById("is_main_project").value=''; 
	 document.getElementById("project_status").value=''; 
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

function deleteTableTr2(tableID){
	var tb = document.getElementById(tableID);
     var rowNum=tb.rows.length;
     for (i=2;i<rowNum;i++)
     {
         tb.deleteRow(i);
         rowNum=rowNum-1;
         i=i-1;
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

