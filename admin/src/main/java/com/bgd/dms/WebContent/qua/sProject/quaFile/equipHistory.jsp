<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.text.*"%>

<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null || project_info_no.trim().equals("")){
		project_info_no = "";
	}
	String projectName = user.getProjectName();
	if(projectName==null || projectName.trim().equals("")){
		projectName = "";
	}
	Date sysdate=new Date();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String nowDate = df.format(sysdate);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script charset="UTF-8" type="text/javascript" src="<%=contextPath%>/qua/sProject/quaFile/quaFile.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
</script>
<title>列表页面</title>
</head>
<body><!-- style="background:#fff" onload="page_init()" -->
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						 	<auth:ListButton functionId="F_QUA_FILE_004" css="xg" event="onclick='edit()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_FILE_004" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{history_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="<a href='#' onclick=changeTab2('{history_id}')><font color='blue'>{report_date}</font></a>">填报日期</td>
			  <td class="bt_info_even" exp="{org_name}">填报单位名称</td>
			  <td class="bt_info_odd" exp="{report_title}">填报标题</td>
			  <td class="bt_info_even" exp="{report_code}">填报编号</td>
			  <td class="bt_info_odd" exp="{report_maker}">填写人</td>
			  <td class="bt_info_even" exp="<a href='#' onclick=reportShow('{history_id}')><font color='blue'>报表({report_date})</font></a>" >报表</td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
        <!-- <li><a href="#" onclick="getTab(this,2)" >备注</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <!--<auth:ListButton functionId="F_QUA_FILE_004" css="tj" event="onclick='historySubmit()'" title="JCDP_btn_submit"></auth:ListButton>-->
			  </tr>
			</table>
			<form action="" id="form0" name="form0" method="post" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    		<input type="hidden" name="history_id" id="history_id" value="" />
		    		<input type="hidden" name="project_info_no" id="project_info_no" value="<%=project_info_no%>"/>
					<tr>
					    <td class="inquire_item6">项目名称:</td>
					    <td class="inquire_form6" ><input type="text" name="projectName" id="projectName" value="<%=projectName %>" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item6">填报标题:</td>
					   	<td class="inquire_form6"><input type="text" name="report_title" id="report_title" value="" class="input_width" /></td>
					   	<td class="inquire_item6">填报单位名称:</td>
					   	<td class="inquire_form6"><input name="org_id" id="org_id" type="hidden" class="input_width" value="" />
				    		<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
							<!--<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" />-->
							</td>
				  	</tr>
				  	<tr> 	
				  		<td class="inquire_item6">填报日期:</td>
					    <td class="inquire_form6" ><input type="text" name="report_date" id="report_date" value="<%=nowDate %>" class="input_width" readonly="readonly"/>
					  
					   		 <!--<img width="16" height="16" id="cal_button6" style="cursor: hand;" 
	    					onmouseover="calDateSelector(report_date,cal_button6);" 
	    					src="<%=contextPath %>/images/calendar.gif" />-->
	    					
	    					</td>
				  		<td class="inquire_item6">填报编号:</td>
					    <td class="inquire_form6" ><input type="text" name="report_code" id="report_code" value="" class="input_width" /></td>
					  	<td class="inquire_item6">检查人:</td>
					    <td class="inquire_form6" ><input type="text" name="report_maker" id="report_maker" value="" class="input_width"/></td>  
				  </tr>
				</table>
			</form> 
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getHistorytList"; 
	var project_info_no = '<%=project_info_no%>';
	function refreshData(){
		var project = '<%=project_info_no%>';
		if(project ==null || project=='null' || project ==''){
			alert("请选择项目");
			return;
		}
		setTabBoxHeight();
		queryData(1);
	}
	refreshData();
	/* 详细信息 */
	function loadDataDetail(history_id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
		var retObj = jcdpCallService("QualityItemsSrv","getHistoryDetail", "history_id=" + history_id);
		if(retObj.returnCode =='0'){
			var map = retObj.historyDetail;
			if(map !=null){
				document.getElementById("history_id").value = history_id;
				document.getElementById("report_title").value = map.report_title;
				document.getElementById("org_id").value = map.org_id;
				document.getElementById("org_name").value = map.org_name;
				document.getElementById("report_date").value = map.report_date;
				document.getElementById("report_code").value = map.report_code;
				document.getElementById("report_maker").value = map.report_maker;
			}
		}
		
	}
	function edit(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var sql = '';
		if(window.confirm("你确定要修改?")){
			for (var i = objLen-1 ;i > 0 ; i--){
		    	if ( obj [i].checked == true) { 
		    		var history_id=obj[i].value;
	        		if(history_id != ''){
	        			window.location=cruConfig.contextPath+"/qua/sProject/quaFile/equipment.jsp?history_id="+history_id;
	        			window.parent.frames("fourthMenuFrame").getTab(window.parent.frames("fourthMenuFrame").document.getElementsByTagName("a")[1]);
	        		}
		        }
			}
    	}
	}
	
	
	function toDel(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var sql = '';
		if(window.confirm("您确定要删除?")){
			for (var i = objLen-1 ;i > 0 ; i--){
		    	if ( obj [i].checked == true) { 
		    		var history_id=obj[i].value;
	        		if(history_id != ''){
	        			sql = sql + "update bgp_qua_equipment_history t set t.bsflag='1' where t.history_id='"+history_id+"';";
	        		}
		        }
			}
			if(sql!=null && sql!=''){
				var retObj = jcdpCallService("QualitySrv","saveQualityBySql", "sql="+sql);
				if(retObj!=null && retObj.returnCode=='0'){
					alert("删除成功!");
					refreshData();
				}
			}
    	}
	}
	function reportShow(history_id){
		popWindow('<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=qua_equipment&noLogin=admin&tokenId=admin&KeyId='+history_id,'1280:720');
	}
	function frameSize(){
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

</body>
</html>
