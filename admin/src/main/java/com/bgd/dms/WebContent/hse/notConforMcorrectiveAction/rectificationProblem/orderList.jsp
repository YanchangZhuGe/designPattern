<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String isProject = request.getParameter("isProject");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>  
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
  <title>问题清单</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">检查日期</td>
			    <td class="ali_cdn_input">
			    <input id="changeDate" name="changeDate" type="text" />
			    
			    <input  id="pproblem_category" name="pproblem_category" type="hidden" />
			    <input  id="psystem_elements" name="psystem_elements" type="hidden" />
			    <input  id="qdetail_no" name="qdetail_no" type="hidden" />
			    <input  id="pnature" name="pnature" type="hidden" />
			    <input  id="a_problem" name="a_problem" type="hidden" /> 
			    </td>
				<td class="ali_query">
				 <img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(changeDate,tributton0);" />
		        </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td> 
			    
			    <auth:ListButton functionId="" css="tj" event="onclick='toEdit()'" title="JCDP_btn_submit"></auth:ListButton>
	 
			    </td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>    
			      <td class="bt_info_even" 	 exp="<input type='radio' name='chx_entity_id'  id='chx_entity_id{questions_no}' value='{questions_no}'\>">选择</td>
					<td class="bt_info_odd" 	 autoOrder="1">序号</td>
				    <td class="bt_info_even" exp="{org_name}">单位</td> 
				      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
				      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
				      <td class="bt_info_odd" exp="{check_date}">检查日期</td>
				      <td class="bt_info_even" exp="{rectification_period}">整改期限</td>
				      
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
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
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
	
 
	function toAdd(){
		 
		popWindow('<%=contextPath%>/hse/notConforMcorrective/edit.srq?func=1','1024:800');
	
	}
	
	function changeTest(){
 
	 var  obj1=document.getElementById("qdetail_no").value;
	 var  obj2=document.getElementById("psystem_elements").value;
	 var  obj3=document.getElementById("pproblem_category").value;
	 var  obj4=document.getElementById("pnature").value;
	 var  obj5=document.getElementById("a_problem").value;
	 
	 window.opener.document.getElementById("qdetail_no").value = obj1;
	 window.opener.document.getElementById("psystem_elements").value = obj2;
	 window.opener.document.getElementById("pproblem_category").value = obj3;
	 window.opener.document.getElementById("pnature").value = obj4;
	 window.opener.document.getElementById("a_problem").value = obj5;
	 
	 window.close();
		
		
	}
	
	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var train_plan_no =  tempa[0];    
 
	    window.open("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/addQuestions.jsp?questions_no="+train_plan_no+"&update=true&func=1",'twoPage','height=500,width=950px,left=150px,top=100px,menubar=no,status=no,toolbar=no'); 

	    //editUrl = "/rm/em/toHumanPrepareEdit.srq?id="+requirement_no+"&update=true"+"&prepareNo="+prepare_no+"&func=1";
	    	//window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	       var train_plan_no =  tempa[0];    
		var sql = "update BGP_NOACCORDWITH_ORDER set bsflag='1' where order_no ='"+train_plan_no+"'"; 
		deleteEntities(sql);
		alert('删除成功！');
	}
	
	 
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
 
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'  where tr.bsflag = '0'  "+querySqlAdd+" order by tr.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/rectificationProblem/orderList.jsp";
		queryData(1);
	}
	 
	
	// 简单查询
	function simpleSearch(){
			var changeDate = document.getElementById("changeDate").value;
				if(changeDate!=''&& changeDate!=null){
					var isProject = "<%=isProject%>";
					var querySqlAdd = "";
					if(isProject=="1"){
						querySqlAdd = getMultipleSql2("tr.");
					}else if(isProject=="2"){
						querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
					}
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "  select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0' where tr.bsflag = '0'  "+querySqlAdd+" and  to_char(tr.check_date,'yyyy-MM-dd')='"+changeDate+"' order by tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/rectificationProblem/orderList.jsp";
					queryData(1);
				}else{
					alert('请输入查询内容！');
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("changeDate").value = "";
	}

 
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

    function loadDataDetail(ids){
    	 var tempa = ids.split(','); 	    
 	    var trainPlanId =  tempa[0];    
	 
	 
		
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
	
</script>
</html>