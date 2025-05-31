<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 
<%
	String contextPath = request.getContextPath();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String orgSubIdFirst =(user==null)?"":user.getOrgSubjectionId();	
	
     String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'    start with t.org_sub_id = '"+orgSubIdFirst+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	
	System.out.println("sql ="+sql);	
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String orgSubId = "";
	String father_organ_flag = "";
	String organ_flag = "";
	if(list.size()>1){
	 	Map map = (Map)list.get(0);
	 	Map mapOrg = (Map)list.get(1);
	 	father_id = (String)map.get("orgSubId");
	 	orgSubId = (String)mapOrg.get("orgSubId");
	 	father_organ_flag = (String)map.get("organFlag");
	 	organ_flag = (String)mapOrg.get("organFlag");
	 	if(father_organ_flag.equals("0")||user.getOrgSubjectionId().equals("C105")){
	 		father_id = "C105";
	 		organ_flag = "0";
	 	}
	}
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>单位HSE月报</title>
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

.myButton {
	BORDER: #deddde 1px solid;
	font-size: 12px;
	background:#2C83C1;
	CURSOR:  hand;
	COLOR: #FFFFFF;
	padding-top: 2px;
	padding-left: 2px;
	padding-right: 2px;
	height:22px;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">月份日期</td>
			    <td class="ali_cdn_input">
			    <input id="ifBuild" name="ifBuild" class="input_width"  style="width:120px" type="text" readonly="readonly"/>&nbsp;
			 	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="calMonthSelector(ifBuild,tributton0);"/>&nbsp;
			    </td>
 				<td class="ali_query">
				   <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_MONTH_MUL" css="sptg" event="onclick='toPass()'" title="审批通过"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_MONTH_MUL" css="spbtg" event="onclick='toNoPass()'" title="审批不通过"></auth:ListButton>
			    
			    <!-- 		    <% if(JcdpMVCUtil.hasPermission("F_HSE_MONTH_MUL", request)){ %>
			    <td align="right" style="width: 40px;"><input type="button" name="button2" value="审批通过"  class="myButton"  onclick="toPass()"/></td>
			    <td align="right" style="width: 40px;padding-left: 5px;"><input type="button" name="button2" value="审批不通过"  class="myButton"  onclick="toNoPass()"/></td>
			     <%} %> 
			     -->  
			    </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr> 
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{recore_id}'  value='{recore_id},{org_sub_id},{month_no},{subflag},{org_name}' onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{month_no}">月份日期</td>
			      <td class="bt_info_even" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{subflag}">状态</td>
			      <td class="bt_info_even" exp="{employee_name}">填写人</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	//setTabBoxHeight();
 	if(lashened==0){
		$("#table_box").css("height",$(window).height()*0.62);
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);

}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
var checked = false;
function check(){
	var chk = document.getElementsByName("chx_entity_id");
	for(var i = 0; i < chk.length; i++){ 
		if(!checked){ 
			chk[i].checked = true; 
		}
		else{
			chk[i].checked = false;
		}
	} 
	if(checked){
		checked = false;
	}
	else{
		checked = true;
	}
}

</script>

<script type="text/javascript"> 
	cruConfig.contextPath =  "<%=contextPath%>";	
	// 复杂查询
	function refreshData(){		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select   i.org_abbreviation as org_name , u.employee_name,tr.recore_id,tr.org_sub_id,tr.month_no,tr.month_start_date,tr.month_end_date,decode(tr.subflag, '0', '未提交', '1', '已提交','3','审批通过','4','审批不通过') subflag  from   BGP_HSE_MONTH_RECORD tr  left  join comm_org_subjection s    on tr.org_sub_id = s.org_subjection_id   and s.bsflag = '0' left join comm_org_information i    on s.org_id = i.org_id   and i.bsflag = '0'    left    join  comm_human_employee u   on tr.creator = u.EMPLOYEE_ID   and u.bsflag = '0'   where tr.bsflag='0' ";	 
		cruConfig.queryStr = cruConfig.queryStr+"  order by tr.month_no desc,tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hseMonthlyReport/unitMonthlyReportList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hseMonthlyReport/unitMonthlyReportList.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	function calMonthSelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    false,
			step	       :	1
	    });
	}

	// 简单查询
	function simpleSearch(){
			var ifBuild = document.getElementById("ifBuild").value;
				if(ifBuild!=''&&ifBuild!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = " select   i.org_abbreviation as org_name , u.employee_name,tr.recore_id,tr.org_sub_id,tr.month_no,tr.month_start_date,tr.month_end_date,decode(tr.subflag, '0', '未提交', '1', '已提交','3','审批通过','4','审批不通过') subflag  from   BGP_HSE_MONTH_RECORD tr   left  join comm_org_subjection s    on tr.org_sub_id = s.org_subjection_id   and s.bsflag = '0'  left  join comm_org_information i    on s.org_id = i.org_id   and i.bsflag = '0'      left  join  comm_human_employee u   on tr.creator = u.EMPLOYEE_ID   and u.bsflag = '0'   where tr.bsflag='0'  and tr.month_no='"+ifBuild+"' ";	 
					cruConfig.queryStr = cruConfig.queryStr+"  order by tr.month_no desc,tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/hseMonthlyReport/unitMonthlyReportList.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("ifBuild").value = "";
	}
	function loadDataDetail(ids){ 
//		var obj = event.srcElement;
//		if(obj.tagName.toLowerCase() =='td'){
//			obj.parentNode.cells[0].firstChild.checked = 'checked';
//		}

	}
	 
	
	function dbclickRow(ids){
		 var temp = ids.split(','); 
			var record_id = temp[0];
			var org_sub_id = temp[1];
			var month_no = temp[2];
			var subflag= temp[3];
			var org_name= temp[4];

			window.location='<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/monthlyMenu.jsp?record_id='+record_id+'&org_sub_id='+org_sub_id+'&month_no='+month_no+'&org_name='+org_name+'&subflag='+subflag+'&action=edit';
	}

	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");	
	
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
	
	function toAdd(){
		window.location='<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/selectDate.jsp?projectInfoNo=<%=projectInfoNo%>&action=add';
	}
	 

	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var temp = ids.split(','); 
		var record_id = temp[0];
		var org_sub_id = temp[1];
		var month_no = temp[2];
		var subflag= temp[3];
		var org_name= temp[4];
if(org_sub_id =="<%=orgSubId%>"){

		window.location='<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/monthlyMenu.jsp?projectInfoNo=<%=projectInfoNo%>&record_id='+record_id+'&org_sub_id='+org_sub_id+'&month_no='+month_no+'&org_name='+org_name+'&subflag='+subflag+'&action=edit';
}else{
		              alert("只能对本单位记录进行操作!");
		    	return;
	}

	} 
	
	 function toSubmit(){
		 
		  ids = getSelIds('chx_entity_id');
		    if(ids==''){
		    	alert("请先选中一条记录!");
		     	return;
		    }	
		    var temp = ids.split(','); 
			var record_id = temp[0];
			var org_sub_id = temp[1];
			var subflag= temp[3];
			if(org_sub_id =="<%=orgSubId%>"){
			if(subflag == '已提交'){
				alert('本条月报记录已提交！'); return;
			}else{
				var subflags='1';
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
   				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_MONTH_RECORD&JCDP_TABLE_ID='+record_id +'&subflag='+subflags;
   			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
				alert('提交成功');
				refreshData();
			}
		  }else{
		              alert("只能对本单位记录进行操作!");
		    	return;
		}
		 
	 }
	 
	 function toPass(){
		   ids = getSelIds('chx_entity_id');
		    if(ids==''){
		    	alert("请先选中一条记录!");
		     	return;
		    }
		    var temp = ids.split(',');
			var record_id = temp[0];
			var subflag = temp[3];
			var org_sub_id = temp[1];
			if(org_sub_id =="<%=orgSubId%>"){
			if(subflag == '审批通过'){
				alert('本条月报记录已审批通过！'); return;
			}else{
				var subflags='3';
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
   				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_MONTH_RECORD&JCDP_TABLE_ID='+record_id +'&subflag='+subflags;
   			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
				refreshData();
			} 
		 	  }else{
		              alert("只能对本单位记录进行操作!");
		    	return;
			}
		}
		
	 function toNoPass(){
		 
		  ids = getSelIds('chx_entity_id');
		    if(ids==''){
		    	alert("请先选中一条记录!");
		     	return;
		    }
		    var temp = ids.split(',');
			var record_id = temp[0];
			var subflag = temp[3];
			var org_sub_id = temp[1];
			if(org_sub_id =="<%=orgSubId%>"){
			if(subflag == '审批不通过'){
				alert('本条月报记录已审批不通过！'); return;
			}else{
				var subflags='4';
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
 				var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_MONTH_RECORD&JCDP_TABLE_ID='+record_id +'&subflag='+subflags;
 			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
				refreshData();
			}  
			  }else{
		              alert("只能对本单位记录进行操作!");
		    	return;
			}
		  
	 }
	 
	 
	function toDelete(){ 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var temp = ids.split(','); 
		var record_id = temp[0];
		var subflag= temp[3];
		var org_sub_id = temp[1];
		if(org_sub_id =="<%=orgSubId%>"){
		if(subflag == '已提交'){
			alert('本条月报记录已提交,不能删除！'); return;
		}else{		
		 
			deleteEntities("update BGP_HSE_MONTH_RECORD   e set e.bsflag='1' where e.recore_id='"+record_id+"'");

		}
		  }else{
		              alert("只能对本单位记录进行操作!");
		    	return;
		}
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/hse_search.jsp");
	}
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("chx_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
	 
 
</script>

</html>

