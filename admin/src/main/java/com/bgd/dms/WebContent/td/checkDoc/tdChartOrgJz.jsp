<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="java.util.*"%>  
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
	Calendar cal = new GregorianCalendar();
	cal.setTime(new Date());
	int daynum = cal.getActualMaximum(Calendar.DAY_OF_MONTH); 
	int year = cal.get(Calendar.YEAR);
	
	String reportFileName = request.getParameter("reportId").toString();
	if(reportFileName==null){
		reportFileName="js_father_report.raq";
	}
	String title = reportFileName; 
	
	 
	String year_s = request.getParameter("year_s");
	String org_sb_id = request.getParameter("org_sb_id");
	if(year_s==null){
		year_s=year+"";
	}
	if(org_sb_id==null){
		org_sb_id=orgSubjectionId;
	}
	
	String rptParams = request.getParameter("rptParams");
	if(rptParams==null ){
		  rptParams ="year_s="+year_s+";org_sb_id="+org_sb_id;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<body style="background: #fff; overflow-y: hidden" onload="" >
 
<div id="list_content" >
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
<%--    <% 
		 if(!reportFileName.equals("js_jzi_report.raq")){
	 %> --%>
    <td class="ali_cdn_name">所属单位</td>
    <td width="20%">
        <input name="s_org_id" id="s_org_id" class="input_width" value="" type="hidden" readonly="readonly"/> 
        <input name="s_org_name" id="s_org_name" class="input_width" value="" type="text" readonly="readonly"/> 
        <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/> 
    </td>
<%--        <%
		  } 
  	 %>  --%>
    <td class="ali_cdn_name">年份:</td>
    <td class="ali_cdn_input">
    	 <select  id="year_s" name="year_s" >
			     <option value="" selected  >--请选择--</option>
			 	 <option value="2010" >2010</option>
			 	 	 <option value="2011" >2011</option>
			 	 	 	 <option value="2012" >2012</option>
			 	 	 	 	 <option value="2013" >2013</option>
			 	 	 	 	 	 <option value="2014" >2014</option>
			 	 	 	 	 	 	 <option value="2015" >2015</option>
			 	 	 	 	 	 	 	 <option value="2016" >2016</option>
			 	 	 	 	 	 	 	 	 <option value="2017" >2017</option>
			 	 	 	 	 	 	 	 	 	 <option value="2018" >2018</option>
			 	 	 	 	 	 	 	 	 	 	 <option value="2019" >2019</option>
			 	 	 	 	 	 	 	 	 	 	 	 <option value="2020" >2020</option>
			 	 	 	 	 	 	 	 	 	 	 	  <option value="2021" >2021</option>
			 	 	 	 	 	 	 	 	 	 	 	   <option value="2022" >2022</option>
			 	 	 	 	 	 	 	 	 	 	 	    <option value="2023" >2023</option>
			 	 	 	 	 	 	 	 	 	 	 	     <option value="2024" >2024</option>
			 	 	 	 	 	 	 	 	 	 	 	      <option value="2025" >2025</option>
			 	 	 	 	 	 	 	 	 	 	 	       <option value="2026" >2026</option>
			 	 	 	 	 	 	 	 	 	 	 	        <option value="2027" >2027</option>
			 	 	 	 	 	 	 	 	 	 	 	         <option value="2028" >2028</option>
			 	 	 	 	 	 	 	 	 	 	 	          <option value="2029" >2029</option>
			 	 	 	 	 	 	 	 	 	 	 	          <option value="2030" >2030</option>
  
			 	 </select>
    </td>  
    <td>&nbsp;</td>	 
    <td class="ali_query">
   		<span class="cx"><a href="#" onclick="getReport()" title="JCDP_btn_query"></a></span>
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
 
  
  <div id="table_box"  style="height:810px;" >
<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
	<tr>
		<td>
			<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes" excelPageStyle="1"-->
			<report:html name="report1"
			reportFileName="<%=reportFileName %>"
			params="<%=rptParams%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="<%=title%>" excelPageStyle="0"/>
		</td>
	</tr>
</table>
</div>


</div>
 

</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
var daynum = parseInt('<%=daynum%>');
 


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
var  reportFileName ="<%=reportFileName%>";

function clearQueryText(){ 
	//if(reportFileName!="js_jzi_report.raq"){
		 document.getElementById("s_org_id").value=''; 
		 document.getElementById("s_org_name").value=''; 
	//}
	 document.getElementById("year_s").value=''; 
}

function getReport(){
	var year_s = document.getElementById("year_s").value;
	var s_org_id="";
 
	//if(reportFileName!="js_jzi_report.raq"){
	    s_org_id = document.getElementById("s_org_id").value; 
	//}

	   var myDate = new Date();
	    myDate.getYear();        
 
		if(year_s =='' ){ 
			year_s=myDate.getYear();
		}
		if(s_org_id =='' ){ 
			s_org_id='C105';
		}
		if(reportFileName=="js_jzi_report.raq"){
			 window.location.href='<%=contextPath%>/td/checkDoc/tdChartOrgJz.jsp?reportId=js_jzi_report.raq&year_s='+year_s+'&org_sb_id='+s_org_id;
		}else{
			 window.location.href='<%=contextPath%>/td/checkDoc/tdChartOrgJz.jsp?reportId=js_father_report.raq&year_s='+year_s+'&org_sb_id='+s_org_id;
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

