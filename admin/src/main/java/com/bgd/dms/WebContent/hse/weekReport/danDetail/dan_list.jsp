<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getOrgSubjectionId();
	String userName = user.getUserId();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	String subflag = request.getParameter("subflag");
	String action = request.getParameter("action");
	String organ_flag = request.getParameter("organ_flag");
	Date now = new Date();
	String sql = "select ho.org_sub_id, ho.father_org_sub_id,i.org_abbreviation  org_name,i2.org_abbreviation org_name2 from bgp_hse_org ho join  comm_org_subjection s on ho.org_sub_id=s.org_subjection_id and s.bsflag='0' join comm_org_information i on s.org_id = i.org_id and i.bsflag = '0' join comm_org_subjection s2 on s2.org_subjection_id = ho.father_org_sub_id and s2.bsflag = '0' join comm_org_information i2 on i2.org_id = s2.org_id and i2.bsflag = '0' where ho.org_sub_id = '"+org_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	
	String orgName="";
	String orgName2="";
	if(map!=null){
		orgName = (String)map.get("orgName");
		orgName2 = (String)map.get("orgName2");
	}
	String isProject = request.getParameter("isProject");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="">
<form name="form1" id="form1" method="post" action="">
<div id="list_table" style="height: auto;width:auto;overflow: hidden;">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td>&nbsp;周报时间：&nbsp;<%=week_date %>&nbsp;至&nbsp;<%=week_end_date %></td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" id="zj" css="zj" event="onclick='toAddLine()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	</div>
      <fieldSet style="margin-left:2px"><legend>本单位信息</legend>
      <div id="week_box" style="overflow: auto;">
      <table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
      	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value=""></input>
      	<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
        	<tr>
				<td class="bt_info_odd">删除</td>
				<td class="bt_info_even">单位</td>
				<%if(!organ_flag.equals("0")){ %>
				<td class="bt_info_odd">基层单位</td>
				<%} %>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_odd"<%}else{ %> class="bt_info_even"<%} %>>危害因素描述</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_even"<%}else{ %> class="bt_info_odd"<%} %>>因素状态</td>		
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_odd"<%}else{ %> class="bt_info_even"<%} %>>因素级别</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_even"<%}else{ %> class="bt_info_odd"<%} %>>风险削减措施</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_odd"<%}else{ %> class="bt_info_even"<%} %>>备注</td>
			</tr>
      </table>
      </div>
      </fieldSet>
  </div>
</form>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
$("#week_box").css("height",$(window).height()-65);

$(function(){
	$(window).resize(function(){
		$("#week_box").css("height",$(window).height()-65);
	});
})	

var action="<%=action %>";
var org_id="<%=org_id %>";
var subflag="<%=subflag %>";
var organ_flag = "<%=organ_flag%>"
var hse_dan_ids = "";
if(subflag=="1"||subflag=="3"){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}
//if(action=="add"){
//	document.getElementById("bc").style.display="";
//	document.getElementById("zj").style.display="";
//}

toEdit();

function toAddLine(hse_danger_ids ,dan_describes,dan_types,dan_levels ,dan_steps,dan_notes,orders){
	var hse_danger_id="";
	var dan_describe = "";
	var dan_type="";
	var dan_level = "";
	var dan_step = "";
	var dan_note = "";
	var order = "";
	var orgName2='<%=orgName2%>';
	var orgName='<%=orgName%>';
	
	if(hse_danger_ids != null && hse_danger_ids != ""){
		hse_danger_id=hse_danger_ids;
	}
	if(dan_describes != null && dan_describes != ""){
		dan_describe=dan_describes;
	}
	if(dan_types != null && dan_types != ""){
		dan_type=dan_types;
	}
	if(dan_levels != null && dan_levels != ""){
		dan_level=dan_levels;
	}
	if(dan_steps != null && dan_steps != ""){
		dan_step=dan_steps;
	}
	if(dan_notes != null && dan_notes != ""){
		dan_note=dan_notes;
	}
	if(orders != null && orders != ""){
		order=orders;
	}
	
	var rowNum = document.getElementById("lineNum").value;	
	
	var table=document.getElementById("lineTable");
	
	var lineId = "row_" + rowNum;
	var autoOrder = document.getElementById("lineTable").rows.length;
	var newTR = document.getElementById("lineTable").insertRow(autoOrder);
	newTR.id = lineId;
	var tdClass = 'even';
	if(autoOrder%2==0){
		tdClass = 'odd';
	}
	
	var td = newTR.insertCell(0);
	td.innerHTML = "<input type='hidden' id='hse_danger_id"+rowNum+"' value='"+hse_danger_id+"' /><input type='hidden' name='order' value='" + rowNum + "'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
    td.className = tdClass+'_odd';
    if(autoOrder%2==0){
		td.style.background = "#f6f6f6";
	}else{
		td.style.background = "#e3e3e3";
	}
	
    if(organ_flag=="0"){
	    td = newTR.insertCell(1);
	    td.innerHTML = orgName;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
    }else{
    	td = newTR.insertCell(1);
 	    td.innerHTML = orgName2;
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(2);
	    td.innerHTML = "<textarea id='dan_describe"+rowNum+"'>"+dan_describe+"</textarea>";
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
    }else{
    	td = newTR.insertCell(2);
 	    td.innerHTML = orgName;
 	    td.className =tdClass+'_odd'
 	    if(autoOrder%2==0){
 			td.style.background = "#f6f6f6";
 		}else{
 			td.style.background = "#e3e3e3";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(3);
	    td.innerHTML = "<select id='dan_type"+rowNum+"' value='"+dan_type+"'><option value=''>请选择</option><option value='1'>已整改</option><option value='2'>未整改</option><option value='3'>正在整改</option></select>";
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
    }else{
    	td = newTR.insertCell(3);
 	    td.innerHTML = "<textarea id='dan_describe"+rowNum+"'>"+dan_describe+"</textarea>";
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(4);
	    td.innerHTML = "<select id='dan_level"+rowNum+"' value='"+dan_level+"'><option value=''>请选择</option><option value='1'>特大</option><option value='2'>重大</option></select>";
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
    }else{
    	td = newTR.insertCell(4);
 	    td.innerHTML = "<select id='dan_type"+rowNum+"' value='"+dan_type+"'><option value=''>请选择</option><option value='1'>已整改</option><option value='2'>未整改</option><option value='3'>正在整改</option></select>";
 	    td.className =tdClass+'_odd'
 	    if(autoOrder%2==0){
 			td.style.background = "#f6f6f6";
 		}else{
 			td.style.background = "#e3e3e3";
 		}
    }
	
    if(organ_flag=="0"){
	    td = newTR.insertCell(5);
	    td.innerHTML = "<textarea id='dan_step"+rowNum+"'>"+dan_step+"</textarea>";
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
    }else{
    	td = newTR.insertCell(5);
 	    td.innerHTML = "<select id='dan_level"+rowNum+"' value='"+dan_level+"'><option value=''>请选择</option><option value='1'>特大</option><option value='2'>重大</option></select>";
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
    	
    if(organ_flag=="0"){
	    td = newTR.insertCell(6);
	    td.innerHTML = "<textarea id='dan_note"+rowNum+"'>"+dan_note+"</textarea>";
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
    }else{
    	td = newTR.insertCell(6);
 	    td.innerHTML = "<textarea id='dan_step"+rowNum+"'>"+dan_step+"</textarea>";
 	    td.className =tdClass+'_odd'
 	    if(autoOrder%2==0){
 			td.style.background = "#f6f6f6";
 		}else{
 			td.style.background = "#e3e3e3";
 		}
    }
    
    if(organ_flag!="0"){
    	td = newTR.insertCell(7);
 	    td.innerHTML = "<textarea id='dan_note"+rowNum+"'>"+dan_note+"</textarea>";
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
	
	document.getElementById("dan_type"+rowNum).value=dan_type;
	document.getElementById("dan_level"+rowNum).value=dan_level;
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;
}

function createRow(html){
    var div=document.createElement("div");
    html="<table><tbody>"+html+"</tbody></table>"
    div.innerHTML=html;
    return div.lastChild.lastChild;
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var hse_dan_id = document.getElementById("hse_danger_id"+rowNum).value;
	var rowNum2 = document.getElementById("lineNum").value;	
	var line = document.getElementById(lineId);		
	line.parentNode.removeChild(line);
	
	if(hse_dan_ids!="") hse_dan_ids += ",";
	hse_dan_ids += hse_dan_id; 
}


function toAdd(){
	var rowNum = document.getElementById("lineNum").value;	
	var orders = document.getElementsByName("order");	
	for (var i="0";i<orders.length;i++){
		var order = orders[i].value;
		var hse_common_id = document.getElementById("hse_common_id").value;
		var hse_danger_id = document.getElementById("hse_danger_id"+order).value;
		var dan_describe = document.getElementById("dan_describe"+order).value;
		var dan_type = document.getElementById("dan_type"+order).value;
		var dan_level = document.getElementById("dan_level"+order).value;
		var dan_step = document.getElementById("dan_step"+order).value;
		var dan_note = document.getElementById("dan_note"+order).value;
		var isProject = "<%=isProject%>";
		
		var jcdp_tables="[['bgp_hse_common'],['bgp_hse_dan_detail','hse_common_id=bgp_hse_common']]"
		             +"&bgp_hse_common={'hse_common_id':'"+hse_common_id+"','week_start_date':'<%=week_date%>','week_end_date':'<%=week_end_date%>','org_id':'<%=org_id%>','subflag':'0',"
		           	 +"'bsflag':'0','modifi_date':'<%=now%>',updator_id:'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 if(action!="edit"){
		           	 	jcdp_tables = jcdp_tables+",'create_date':'<%=now%>','creator_id':'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 	if(isProject=="2"){
		           	 	jcdp_tables = jcdp_tables+",'project_info_no':'<%=user.getProjectInfoNo()%>'";
		           	 	}
		           	 }
		           	 jcdp_tables = jcdp_tables +"}";
		           	jcdp_tables = jcdp_tables +"&bgp_hse_dan_detail={'hse_danger_id':'"+hse_danger_id+"','dan_describe':'"+encodeURI(encodeURI(dan_describe))+"','dan_type':'"+encodeURI(encodeURI(dan_type))+"','dan_level':'"+encodeURI(encodeURI(dan_level))+"','dan_step':'"+encodeURI(encodeURI(dan_step))+"','dan_note':'"+encodeURI(encodeURI(dan_note))+"','dan_order':'"+order+"'}";
		
		var path = "<%=contextPath%>/rad/addOrUpdateMulTableData.srq";
		submitStr = "jcdp_tables="+jcdp_tables;
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		
		var checkSql="select c.hse_common_id id,d.* from bgp_hse_common c left join bgp_hse_dan_detail d  on c.hse_common_id=d.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>' order by d.dan_order asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			document.getElementById("hse_common_id").value=datas[i].id;
			document.getElementById("hse_danger_id"+order).value=datas[i].hse_danger_id;
		}
	}
	//删除已经删除的某条明细
	var retObj = jcdpCallService("HseSrv", "deleteDetail", "ids="+hse_dan_ids+"&table=bgp_hse_dan_detail&key=hse_danger_id");

	if(orders.length==0){
		alert("保存成功");
	}else{
		afterSave(retObject);
	}
}

	//提示提交结果
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '保存成功';
		if(failHint==undefined) failHint = '保存失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
		}
	}
	
	function toEdit(){
		var checkSql="select c.hse_common_id id,d.* from bgp_hse_common c left join bgp_hse_dan_detail d  on c.hse_common_id=d.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>' order by d.dan_order asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas==null||datas==""||datas[0].hse_danger_id==null||datas[0].hse_danger_id==""){
			if(datas!=null&&datas!=""){
				document.getElementById("hse_common_id").value=datas[0].id;
			}
			action="add";
			if(organ_flag=="0"){
				var checkSql3="select c.hse_common_id id, d.* from bgp_hse_org ho join bgp_hse_common c on ho.org_sub_id=c.org_id and c.bsflag='0' left join bgp_hse_dan_detail d on c.hse_common_id = d.hse_common_id where to_char(c.week_start_date, 'yyyy-MM-dd') = '<%=week_date %>' and ho.father_org_sub_id = '<%=org_id%>'";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3!=null||datas3!=""){
					for (var i = 0; i<datas3.length; i++) {		
						toAddLine(
								"",
								datas3[i].dan_describe ? datas3[i].dan_describe : "",
								datas3[i].dan_type ? datas3[i].dan_type : "",
								datas3[i].dan_level ? datas3[i].dan_level : "",
								datas3[i].dan_step ? datas3[i].dan_step : "",
								datas3[i].dan_note ? datas3[i].dan_note : "",
								datas3[i].dan_order ? datas3[i].dan_order : ""
							);
					}
				}
			}else{
				var checkSql2="select hi.hidden_no,hi.hidden_description,hi.hidden_level,hd.rectification_state,hd.rectification_measures from bgp_hse_hidden_information hi left join bgp_hidden_information_detail hd on hi.hidden_no = hd.hidden_no and hd.bsflag='0' where hi.bsflag='0' and hi.second_org='<%=org_id%>' and hi.report_date>=to_date('<%=week_date %>','yyyy-mm-dd') and hi.report_date<=to_date('<%=week_end_date %>','yyyy-MM-dd') and hi.hidden_level in ('1','2') or hd.rectification_state='2'";
			    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
				var datas2 = queryRet2.datas;
				if(datas2!=null||datas2!=""){
					for (var i = 0; i<datas2.length; i++) {		
						toAddLine(
								"",
								datas2[i].hidden_description ? datas2[i].hidden_description : "",
								datas2[i].rectification_state ? datas2[i].rectification_state : "",
								datas2[i].hidden_level ? datas2[i].hidden_level : "",
								datas2[i].rectification_measures ? datas2[i].rectification_measures : "",
								"",
								""
							);
					}	
				}
			}	
		}else{
			document.getElementById("hse_common_id").value=datas[0].id;
			for (var i = 0; i<datas.length; i++) {		
				
				toAddLine(
						datas[i].hse_danger_id ? datas[i].hse_danger_id : "",
						datas[i].dan_describe ? datas[i].dan_describe : "",
						datas[i].dan_type ? datas[i].dan_type : "",
						datas[i].dan_level ? datas[i].dan_level : "",
						datas[i].dan_step ? datas[i].dan_step : "",
						datas[i].dan_note ? datas[i].dan_note : "",
						datas[i].dan_order ? datas[i].dan_order : ""
					);
			}		
			action = "edit";
		}
	} 
	
	function toBack(){
		window.parent.parent.location='<%=contextPath%>/hse/weekReport/week_list.jsp?isProject=<%=isProject%>';
	}
</script>
</html>

