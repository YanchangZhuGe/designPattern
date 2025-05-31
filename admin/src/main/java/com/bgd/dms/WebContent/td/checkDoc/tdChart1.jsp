<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	
	Calendar cal = new GregorianCalendar();
	cal.setTime(new Date());
	int daynum = cal.getActualMaximum(Calendar.DAY_OF_MONTH); 
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

		</table>
		</td>
	</tr>
</table>




</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
var daynum = parseInt('<%=daynum%>');

function getStr(){
	var str = "";
	var s_org_id = document.getElementById("s_org_id").value; 
	var is_main_project = document.getElementById("is_main_project").value; 
	var project_status = document.getElementById("project_status").value;
	
	if(s_org_id != ''){
		str +="s_org_id="+s_org_id;
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
	
	deleteTableTr2("equipmentTableInfo");

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

