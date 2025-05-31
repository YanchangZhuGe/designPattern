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
      	<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
        	<tr>
				<td  class="bt_info_odd">删除</td>
				<td  class="bt_info_even">单位</td>
				<%if(!organ_flag.equals("0")){ %>
				<td class="bt_info_odd">基层单位</td>
				<%} %>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_odd"<%}else{ %> class="bt_info_even"<%} %>>违章行为描述</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_even"<%}else{ %> class="bt_info_odd"<%} %>>违章类型</td>		
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_odd"<%}else{ %> class="bt_info_even"<%} %>>违章级别</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_even"<%}else{ %> class="bt_info_odd"<%} %>>纠正措施</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_odd"<%}else{ %> class="bt_info_even"<%} %>>处罚措施</td>
				<td <%if(organ_flag.equals("0")){ %>class="bt_info_even"<%}else{ %> class="bt_info_odd"<%} %>>备注</td>
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
var organ_flag = "<%=organ_flag %>";
var subflag="<%=subflag %>";

var hse_rule_ids = "";
if(subflag=="1"||subflag=="3"){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}
//if(action=="add"){
//	document.getElementById("bc").style.display="";
//	document.getElementById("zj").style.display="";
//}
toEdit();

function toAddLine(hse_rule_ids ,rule_describes,rule_types,rule_levels ,rule_steps,chufa_steps,rule_notes,orders){
	var hse_rule_id="";
	var rule_describe = "";
	var rule_type="";
	var rule_level = "";
	var rule_step = "";
	var chufa_step = "";
	var rule_note = "";
	var order = "";
	var orgName2='<%=orgName2%>';
	var orgName='<%=orgName%>';
	
	if(hse_rule_ids != null && hse_rule_ids != ""){
		hse_rule_id=hse_rule_ids;
	}
	if(rule_describes != null && rule_describes != ""){
		rule_describe=rule_describes;
	}
	if(rule_types != null && rule_types != ""){
		rule_type=rule_types;
	}
	if(rule_levels != null && rule_levels != ""){
		rule_level=rule_levels;
	}
	if(rule_steps != null && rule_steps != ""){
		rule_step=rule_steps;
	}
	if(chufa_steps != null && chufa_steps != ""){
		chufa_step=chufa_steps;
	}
	if(rule_notes != null && rule_notes != ""){
		rule_note=rule_notes;
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
	td.innerHTML = "<input type='hidden' id='hse_rule_id"+rowNum+"' value='"+hse_rule_id+"' /><input type='hidden' name='order' value='" + rowNum + "'/><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteLine(\""+lineId+"\")'/>";
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
	    td.innerHTML = "<textarea id='rule_describe"+rowNum+"'>"+rule_describe+"</textarea>";
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
	    td.innerHTML = "<select id='rule_type"+rowNum+"' value=''><option value=''>请选择</option><option value='5110000032000000040'>违章指挥</option><option value='5110000032000000041'>违章操作</option><option value='5110000032000000042'>违反劳动纪律</option></select>";
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
    }else{
    	td = newTR.insertCell(3);
 	    td.innerHTML = "<textarea id='rule_describe"+rowNum+"'>"+rule_describe+"</textarea>";
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(4);
	    td.innerHTML = "<select id='rule_level"+rowNum+"' value=''><option value=''>请选择</option><option value='0'>特大</option><option value='1'>重大</option></select>";
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
    }else{
    	td = newTR.insertCell(4);
 	    td.innerHTML = "<select id='rule_type"+rowNum+"' value=''><option value=''>请选择</option><option value='5110000032000000040'>违章指挥</option><option value='5110000032000000041'>违章操作</option><option value='5110000032000000042'>违反劳动纪律</option></select>";
 	    td.className =tdClass+'_odd'
 	    if(autoOrder%2==0){
 			td.style.background = "#f6f6f6";
 		}else{
 			td.style.background = "#e3e3e3";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(5);
	    td.innerHTML = "<textarea id='rule_step"+rowNum+"'>"+rule_step+"</textarea>";
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
    }else{
    	td = newTR.insertCell(5);
 	    td.innerHTML = "<select id='rule_level"+rowNum+"' value=''><option value=''>请选择</option><option value='0'>特大</option><option value='1'>重大</option></select>";
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(6);
	    td.innerHTML = "<textarea id='chufa_step"+rowNum+"'>"+chufa_step+"</textarea>";
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
    }else{
    	td = newTR.insertCell(6);
 	    td.innerHTML = "<textarea id='rule_step"+rowNum+"'>"+rule_step+"</textarea>";
 	    td.className =tdClass+'_odd'
 	    if(autoOrder%2==0){
 			td.style.background = "#f6f6f6";
 		}else{
 			td.style.background = "#e3e3e3";
 		}
    }
    
    if(organ_flag=="0"){
	    td = newTR.insertCell(7);
	    td.innerHTML = "<textarea id='rule_note"+rowNum+"'>"+rule_note+"</textarea>";
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
    }else{
    	td = newTR.insertCell(7);
 	    td.innerHTML = "<textarea id='chufa_step"+rowNum+"'>"+chufa_step+"</textarea>";
 	    td.className =tdClass+'_even'
 	    if(autoOrder%2==0){
 			td.style.background = "#FFFFFF";
 		}else{
 			td.style.background = "#ebebeb";
 		}
    }
    
    if(organ_flag!="0"){
	    td = newTR.insertCell(8);
	    td.innerHTML = "<textarea id='rule_note"+rowNum+"'>"+rule_note+"</textarea>";
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
    }
    
	document.getElementById("rule_type"+rowNum).value=rule_type;
	document.getElementById("rule_level"+rowNum).value=rule_level;
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
	//取删除行的主键ID
	var hse_rule_id = document.getElementById("hse_rule_id"+rowNum).value;
	var rowNum2 = document.getElementById("lineNum").value;
	var line = document.getElementById(lineId);		
	line.parentNode.removeChild(line);
	
	if(hse_rule_ids!="") hse_rule_ids += ",";
	hse_rule_ids += hse_rule_id; 
}


function toAdd(){
	debugger;
	var rowNum = document.getElementById("lineNum").value;	
	var orders = document.getElementsByName("order");	
	for (var i="0";i<orders.length;i++){
		var order = orders[i].value;
		var hse_common_id = document.getElementById("hse_common_id").value;
		var hse_rule_id = document.getElementById("hse_rule_id"+order).value;
		var rule_describe = document.getElementById("rule_describe"+order).value;
		var rule_type = document.getElementById("rule_type"+order).value;
		var rule_level = document.getElementById("rule_level"+order).value;
		var rule_step = document.getElementById("rule_step"+order).value;
		var chufa_step = document.getElementById("chufa_step"+order).value;
		var rule_note = document.getElementById("rule_note"+order).value;
		
		var isProject = "<%=isProject%>";
		var jcdp_tables="[['bgp_hse_common'],['bgp_hse_rule_detail','hse_common_id=bgp_hse_common']]"
		             +"&bgp_hse_common={'hse_common_id':'"+hse_common_id+"','week_start_date':'<%=week_date%>','week_end_date':'<%=week_end_date%>','org_id':'<%=org_id%>','subflag':'0',"
		           	 +"'bsflag':'0','modifi_date':'<%=now%>',updator_id:'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 if(action!="edit"){
		           	 	jcdp_tables = jcdp_tables+",'create_date':'<%=now%>','creator_id':'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 	if(isProject=="2"){
			           	 	jcdp_tables = jcdp_tables+",'project_info_no':'<%=user.getProjectInfoNo()%>'";
			           	 }
		           	 }
		           	 jcdp_tables = jcdp_tables +"}";
		           	jcdp_tables = jcdp_tables +"&bgp_hse_rule_detail={'hse_rule_id':'"+hse_rule_id+"','rule_describe':'"+encodeURI(encodeURI(rule_describe))+"','rule_type':'"+encodeURI(encodeURI(rule_type))+"','rule_level':'"+encodeURI(encodeURI(rule_level))+"','rule_step':'"+encodeURI(encodeURI(rule_step))+"','chufa_step':'"+encodeURI(encodeURI(chufa_step))+"','rule_note':'"+encodeURI(encodeURI(rule_note))+"','rule_order':'"+order+"'}";
		
		var path = "<%=contextPath%>/rad/addOrUpdateMulTableData.srq";
		submitStr = "jcdp_tables="+jcdp_tables;
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		
		var checkSql="select c.hse_common_id id,r.* from bgp_hse_common c left join bgp_hse_rule_detail r  on c.hse_common_id=r.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id %>' order by r.rule_order asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			document.getElementById("hse_common_id").value=datas[i].id;
			document.getElementById("hse_rule_id"+order).value=datas[i].hse_rule_id;
		}
	}
	
	var retObj = jcdpCallService("HseSrv", "deleteDetail", "ids="+hse_rule_ids+"&table=bgp_hse_rule_detail&key=hse_rule_id");
	
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
		var checkSql="select c.hse_common_id id,c.org_id,r.* from bgp_hse_common c left join bgp_hse_rule_detail r  on c.hse_common_id=r.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>' order by r.rule_order asc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""||datas[0].hse_rule_id==null||datas[0].hse_rule_id==""){
			if(datas!=null&&datas!=""){
				document.getElementById("hse_common_id").value=datas[0].id;
			}
			action="add";
			if(organ_flag=="0"){
				var checkSql3="select c.hse_common_id id,d.* from bgp_hse_org ho join bgp_hse_common c on ho.org_sub_id=c.org_id and c.bsflag='0' left join bgp_hse_rule_detail d on c.hse_common_id=d.hse_common_id  where to_char(c.week_start_date, 'yyyy-MM-dd') = '<%=week_date %>' and ho.father_org_sub_id = '<%=org_id%>'";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3!=null||datas3!=""){
					for (var i = 0; i<datas3.length; i++) {		
						toAddLine(
								"",
								datas3[i].rule_describe ? datas3[i].rule_describe : "",
								datas3[i].rule_type ? datas3[i].rule_type : "",
								datas3[i].rule_level ? datas3[i].rule_level : "",
								datas3[i].rule_step ? datas3[i].rule_step : "",
								datas3[i].chufa_step ? datas3[i].chufa_step : "",
								datas3[i].rule_note ? datas3[i].rule_note : "",
								datas3[i].rule_order ? datas3[i].rule_order : ""
							);
					}
				}
			}else{
				var checkSql2="select t.lllegal_description,t.hazard_class,t.illegal_level,t.process_mode, decode(t.administrative_process,'1','警告','2','记过','3','记大过','4','降级','5','降职','6','撤职','7','留用察看','8','开除') a_process,t.fine_amount,t.corrective_measures from bgp_illegal_management t where t.bsflag='0' and t.second_org='<%=org_id%>' and t.illegal_level in ('0','1') and t.create_date>=to_date('<%=week_date %>', 'yyyy-MM-dd') and t.create_date<=to_date('<%=week_end_date %>', 'yyyy-MM-dd')";
			    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
				var datas2 = queryRet2.datas;
				if(datas2!=null||datas2!=""){
					for (var i = 0; i<datas2.length; i++) {	
						var chufa = "";
						var a_process = datas2[i].a_process ? datas2[i].a_process : "";
						var fine_amount = datas2[i].fine_amount ? datas2[i].fine_amount : "";
						if(a_process!=""){
							chufa = chufa + a_process;
						}
						if(a_process!=""&&fine_amount!=""){
							chufa = chufa + "，";
						}
						if(fine_amount!=""){
							chufa = chufa +"罚款"+fine_amount+"元";
						}
						toAddLine(
								"",
								datas2[i].lllegal_description ? datas2[i].lllegal_description : "",
								datas2[i].hazard_class ? datas2[i].hazard_class : "",
								datas2[i].illegal_level ? datas2[i].illegal_level : "",
								datas2[i].corrective_measures ? datas2[i].corrective_measures : "",
								chufa,
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
						datas[i].hse_rule_id ? datas[i].hse_rule_id : "",
						datas[i].rule_describe ? datas[i].rule_describe : "",
						datas[i].rule_type ? datas[i].rule_type : "",
						datas[i].rule_level ? datas[i].rule_level : "",
						datas[i].rule_step ? datas[i].rule_step : "",
						datas[i].chufa_step ? datas[i].chufa_step : "",
						datas[i].rule_note ? datas[i].rule_note : "",
						datas[i].rule_order ? datas[i].rule_order : ""
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

