<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String nums = request.getParameter("nums");
	String paramS = request.getParameter("paramS");
	String org_sub = request.getParameter("org_sub");
	
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
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" style="height:175px">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{projectInfoNo},{projectType}' id='rdo_entity_id_{project_info_no}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{projectName}">项目名称</td>
			      <td class="bt_info_even" exp="{orgName}">施工队伍</td>
			      <td class="bt_info_odd" exp="{manageOrgName}">甲方单位</td>
			      <td class="bt_info_even" exp="{marketClassifyName}">市场范围</td>

			      <%
			      if(paramS.equals("0110000019000000001")){
			      %> 
			     	 <td class="bt_info_odd" exp="{n1}">合同化人数</td>
			      <%}else if(paramS.equals("0110000019000000002")){ %>
	
			      <td class="bt_info_even" exp="{n2}">市场化人数</td>
			      <%
			      }
			      %> 
			      
			      
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">图表</a></li>
			  </ul>
			</div>

			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<div id="div1" style="width:100%; height:290px; overflow:scroll">
					<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>		
					  	<td class="ali_cdn_name">班组</td>
					    <td class="ali_cdn_input"> <input type='hidden' id="ptype_value" name="ptype_value" value="5000100004000000001"/><select class="select_width" id="s_team" name="s_team"   onchange="changeTeam()"></td>	
					   <!--  <td class="ali_cdn_name">用工性质</td>
					    <td class="ali_cdn_input">
					    <select class="select_width" id="s_employee_gz" name="s_employee_gz" >
					    <option value="">请选择</option><option value="0110000019000000001">合同化员工</option><option value="0110000019000000002">市场化用工</option>
					    </select>
					    </td>	 -->
					    <td>&nbsp;</td>
<%-- 					    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>  
					    <auth:ListButton functionId="" css="tj" event="onclick='changeTeam()'" title="JCDP_btn_submit"></auth:ListButton>  --%>
					  </tr>
					</table>
					</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					  </tr>
					</table>
					</div>				
					<div id="chartContainer2">
					</div>
			</div>
			<div id="div2" style="display:none;width:100%; height:290px;overflow:scroll" >
					<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>		

					    <td>&nbsp;</td>
					    <auth:ListButton functionId="" css="fh" event="onclick='listReturn()'" title="JCDP_btn_return"></auth:ListButton> 
					  </tr>
					</table>
					</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					  </tr>
					</table>
					</div>
				<table id="humanDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" >
		    	<tr class="bt_info">
		    	    <td>序号</td>
		    	    <td>姓名</td>
		            <td>班组</td>
		            <td>岗位</td>		
		            <td>进入项目时间</td>	
		            <td>离开项目时间</td>	
		        </tr>            
	           </table>
	           </div>
			</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
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
	cruConfig.queryService = "HumanChartServiceSrv";
	cruConfig.queryOp = "queryMonthProject";
	var nums = "<%=nums%>";
	function refreshData(arrObj){
			
		cruConfig.submitStr = "nums=<%=nums%>&employeeGz=<%=paramS%>&org_sub=<%=org_sub%>";	
		cruConfig.currentPageUrl = "/rm/em/humanChart/orgProjectList.jsp";
		queryData(1);
		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
        var s_team = document.getElementsByName("s_team")[0].value;
        getApplyTeam(ids.split(",")[1]); 
        //var s_employee_gz = document.getElementsByName("s_employee_gz")[0].value;
//    	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId2", "100%", "250", "0", "0" );  
//    	myChart2.setXMLUrl("<%=contextPath%>/rm/em/getChart23.srq?projectInfoNo="+ids.split(",")[0]+"&nums="+nums+"&employeeGz=<%=paramS%>");   
//    	myChart2.render("chartContainer2"); 
    	selectTeam(ids.split(",")[0],nums);
		document.getElementById("div1").style.display="block"; 
		document.getElementById("div2").style.display="none";
    }
    
    function getApplyTeam(p_type){ 
    	var selectObj = document.getElementById("s_team"); 
    	if (p_type ==''){
    		 p_type= document.getElementsByName("ptype_value")[0].value; 
    	}
     
    	document.getElementById("s_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType="+p_type);	
    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
     
 
    }
    function selectTeam(ids,nums){
    	ids = getSelectedValue();
        var chartReference = FusionCharts("myChartId2");     
        var s_team = document.getElementsByName("s_team")[0].value;
        //var s_employee_gz = document.getElementsByName("s_employee_gz")[0].value;
    	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId2", "100%", "250", "0", "0" );  
    	myChart2.setXMLUrl("<%=contextPath%>/rm/em/getAddChart23.srq?projectInfoNo="+ids.split(",")[0]+"&nums="+nums+"&employeeGz=<%=paramS%>");   
    	myChart2.render("chartContainer2"); 
    }
    
    function selectPost(ids){
    	var Params=ids.split("_")[0];
    	var ParamsA=ids.split("_")[1];
    	var ParamsB=ids.split("_")[2];
    	ids = getSelectedValue();
        var chartReference = FusionCharts("myChartId2");     
        var s_team = document.getElementsByName("s_team")[0].value;
       // var s_employee_gz = document.getElementsByName("s_employee_gz")[0].value;
    	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId2", "100%", "250", "0", "0" );  
    	myChart2.setXMLUrl("<%=contextPath%>/rm/em/getChart23.srq?projectInfoNo="+Params+"&nums="+ParamsA+"&team="+ParamsB+"&employeeGz=<%=paramS%>");   
    	myChart2.render("chartContainer2"); 
    }
    

    function changeTeam(){
    	ids = getSelectedValue();
        var chartReference = FusionCharts("myChartId2");     
        var s_team = document.getElementsByName("s_team")[0].value;
      //  var s_employee_gz = document.getElementsByName("s_employee_gz")[0].value;
 
       // if(s_team==''){
        	chartReference.setXMLUrl("<%=contextPath%>/rm/em/getAddChart23.srq?projectInfoNo="+ids.split(",")[0]+"&nums="+nums+"&employeeGz=<%=paramS%>&team="+s_team);   
        	chartReference.render("chartContainer2"); 
      //  }else{
       // chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart18.srq?projectInfoNo="+ids.split(",")[0]+"&team="+s_team+"&employeeGz=<%=paramS%>");
      //  chartReference.render("chartContainer2"); 
      //  }
      
    }
	function clearQueryText(){
	         document.getElementsByName("s_team")[0].value="";
	        // document.getElementsByName("s_employee_gz")[0].value="";
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
	
	function getHumanList(post){
		
		ids = getSelectedValue();
	   // var s_employee_gz = document.getElementsByName("s_employee_gz")[0].value;

		var querySql = "select rownum ,p.* from ( select p.EMPLOYEE_ID, p.EMPLOYEE_NAME,p.employee_gz, d1.coding_name team_name,d2.coding_name work_post_name,p.ACTUAL_START_DATE,p.ACTUAL_END_DATE   from view_human_project_relation p  left join comm_coding_sort_detail d1 on p.TEAM = d1.coding_code_id and d1.bsflag='0'  left join comm_coding_sort_detail d2 on p.WORK_POST = d2.coding_code_id and d2.bsflag='0'  where p.project_info_no = '"+ids.split(",")[0]+"' and p.WORK_POST ='"+post+"' and p.EMPLOYEE_GZ='<%=paramS%>'  ) p ";
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		deleteTableTr("humanDetailList");
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("humanDetailList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var employee_id = datas[i].employee_id;
				var employee_gz = datas[i].employee_gz;
				
				var td = tr.insertCell(1);
				td.innerHTML = "<a href=javascript:commHumanView('"+employee_id+"-"+employee_gz+"')>"+datas[i].employee_name+"</a>";
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].team_name;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].work_post_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].actual_start_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].actual_end_date;

			}
		}
		document.getElementById("div1").style.display="none";
		document.getElementById("div2").style.display="block";  
	}
	
	function listReturn(){
		document.getElementById("div1").style.display="block"; 
		document.getElementById("div2").style.display="none";

	}
	
	 function commHumanView(ids){

		 popWindow('<%=contextPath%>/rm/em/humanChart/commHumanView.jsp?ids='+ids.split(",")[0],'800:700');
	 }
</script>
</html>