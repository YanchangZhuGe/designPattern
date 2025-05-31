<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    
    String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
	}
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2002; i--) {
		listYear.add(i);
	}
	String splan_id = request.getParameter("splan_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>


<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3" onload="submit();">
<div id="new_table_box">  
      <table width="100%" border="0" cellspacing="0" cellpadding="0" >
        <tr align="left">
	        <td  >人员总数： 
	      	<label id="lname" name="lname" ></label>&nbsp; 
	      	</td> 
        </tr>
       
      </table> 
       
    	<div id="chartContainer"></div> 

        </div>
	  <div id="oper_div" style="display:none;">
	  <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	 
</div>
</body>
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
  
var querySql = "    select   sum(p.people_number) num  from Comm_Coding_Sort_Detail sd1  left join bgp_comm_human_plan_detail p    on p.apply_team = sd1.coding_code_id   and p.project_info_no ='<%=projectInfoNo%>'  and p.spare1='<%=splan_id%>'  and p.bsflag = '0' where sd1.coding_sort_id = '0110000001'   and sd1.bsflag = '0'  and sd1.coding_mnemonic_id='<%=projectType%>'    and length(sd1.coding_code) <= 2 " ;				 	 
var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
if(queryRet.returnCode=='0'){
	var datas = queryRet.datas;
	if(datas != null){				 
		document.getElementById("lname").innerText= datas[0].num; 
 
	}					

 }	

function submit(){
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "myChartId", "100%", "440", "0", "0" );  
	myChart2.setXMLUrl("<%=contextPath%>/rm/em/chart/queryBanzu.srq?project_id=<%=projectInfoNo%>&splan_id=<%=splan_id%>");   
	myChart2.render("chartContainer");	

}
function getHumanPost(team){
	//debugger;
	popWindow('<%=contextPath%>/rm/em/singleHuman/supplyHumanPlan/humanPostChart.jsp?splan_id=<%=splan_id%>&team='+team,'900:680');
	
} 
 
</script>
 
</html>

