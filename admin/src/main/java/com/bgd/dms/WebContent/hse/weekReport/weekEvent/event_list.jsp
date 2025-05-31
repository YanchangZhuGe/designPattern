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
	String sql = "select * from comm_org_subjection s join comm_org_information i on s.org_id = i.org_id and i.bsflag='0'  where s.bsflag='0' and s.org_subjection_id = '"+org_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	
	String orgName="";
	if(map!=null){
		orgName = (String)map.get("orgAbbreviation");
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
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="" >
<form name="form1" id="form1" method="post" action="">
<div id="list_table" style="height: auto;width:auto;">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td>&nbsp;周报时间：&nbsp;<%=week_date %>&nbsp;至&nbsp;<%=week_end_date %></td>
			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	</div>
      <fieldSet style="margin-left:2px;height: auto;width: auto;"><legend>本单位信息</legend>
		<div id="week_box" style="overflow: auto;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="tab_line_height">
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
      	<input type="hidden" id="hse_event_id" name="hse_event_id" value=""></input>
        	<tr>
				<td class="bt_info_odd">单位</td>
				<td class="bt_info_even">死亡事故</td>
				<td class="bt_info_odd">重伤事故</td>		
				<td class="bt_info_even">轻伤事故</td>
				<td class="bt_info_odd">工作受限</td>
				<td class="bt_info_even">医疗处置</td>
				<td class="bt_info_odd">急救事件</td>
				<td class="bt_info_even">未遂事件</td>
				<td class="bt_info_odd">财产损失事故</td>
				<td class="bt_info_even">合计</td>
			</tr>
			<tr>
				<td class="even_odd"><%=orgName %></td>
				<td class="even_even"><input type="text" id="die_event" name="die_event" size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_odd"><input type="text" id="harm_event" name="harm_event" size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_even"><input type="text" id="injure_event" name="injure_event" size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_odd"><input type="text" id="work_event" name="work_event"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_even"><input type="text" id="medic_event" name="medic_event"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_odd"><input type="text" id="aid_event" name="aid_event" size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_even"><input type="text" id="not_event" name="not_event"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_odd"><input type="text" id="money_event" name="money_event"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_even"><input type="text" id="total_event" name="total_event"  value="0" size="7"></input></td>
			</tr>
      </table>
      </div>
      </fieldSet>
  </div>
</form>
</body>
<script type="text/javascript">

$("#week_box").css("height",$(window).height()-65);

var action="<%=action %>";
var org_id="<%=org_id %>";
var organ_flag = "<%=organ_flag%>";
var subflag="<%=subflag %>";
if(subflag=="1"||subflag=="3"){
	document.getElementById("bc").style.display="none";
}
//if(action=="add"){
//	document.getElementById("bc").style.display="";
//}
toEdit();

function totalDan(){
	var die_event = document.getElementById("die_event").value;
	var harm_event = document.getElementById("harm_event").value;
	var injure_event = document.getElementById("injure_event").value;
	var work_event = document.getElementById("work_event").value;
	var medic_event = document.getElementById("medic_event").value;
	var aid_event = document.getElementById("aid_event").value;
	var not_event = document.getElementById("not_event").value;
	var money_event = document.getElementById("money_event").value;
	
	die_event = Number(die_event);
	harm_event = Number(harm_event);
	injure_event = Number(injure_event);
	work_event = Number(work_event);
	medic_event = Number(medic_event);
	aid_event = Number(aid_event);
	not_event = Number(not_event);
	money_event = Number(money_event);
	
	document.getElementById("total_event").value=die_event+harm_event+injure_event+work_event+medic_event+aid_event+not_event+money_event;
}

function toAdd(){
	var hse_common_id = document.getElementById("hse_common_id").value;
	var hse_event_id = document.getElementById("hse_event_id").value;
	var die_event = document.getElementById("die_event").value;
	var harm_event = document.getElementById("harm_event").value;
	var injure_event = document.getElementById("injure_event").value;
	var work_event = document.getElementById("work_event").value;
	var medic_event = document.getElementById("medic_event").value;
	var aid_event = document.getElementById("aid_event").value;
	var not_event = document.getElementById("not_event").value;
	var money_event = document.getElementById("money_event").value;
	var total_event = document.getElementById("total_event").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/ 
	
	if (!re.test(die_event)||!re.test(harm_event)||!re.test(injure_event)||!re.test(work_event)||!re.test(medic_event)||!re.test(aid_event)||!re.test(not_event)||!re.test(money_event)||!re.test(total_event))
	   {
	       alert("请输入数字！");
	       return ;
	    }
	var isProject = "<%=isProject%>";
	var jcdp_tables="[['bgp_hse_common'],['bgp_hse_week_event','hse_common_id=bgp_hse_common']]"
	             +"&bgp_hse_common={'hse_common_id':'"+hse_common_id+"','week_start_date':'<%=week_date%>','week_end_date':'<%=week_end_date%>','org_id':'<%=org_id%>','subflag':'0',"
	           	 +"'bsflag':'0','modifi_date':'<%=now%>',updator_id:'"+encodeURI(encodeURI('<%=userName%>'))+"'";
	           	 if(action!="edit"){
	           	 	jcdp_tables = jcdp_tables+",'create_date':'<%=now%>','creator_id':'"+encodeURI(encodeURI('<%=userName%>'))+"'";
	           	 	if(isProject=="2"){
		           	 	jcdp_tables = jcdp_tables+",'project_info_no':'<%=user.getProjectInfoNo()%>'";
		           	 }
	           	 }
	           	 jcdp_tables = jcdp_tables +"}";
	           	jcdp_tables = jcdp_tables +"&bgp_hse_week_event={'hse_event_id':'"+hse_event_id+"','die_event':"+die_event+",'harm_event':"+harm_event+",'injure_event':"+injure_event+",'work_event':"+work_event+",'medic_event':"+medic_event+",'aid_event':"+aid_event+",'not_event':"+not_event+",'money_event':"+money_event+",'total_event':"+total_event+"}";
	
	var path = "<%=contextPath%>/rad/addOrUpdateMulTableData.srq";
	submitStr = "jcdp_tables="+jcdp_tables;
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);
	afterSave(retObject);
}

	//提示提交结果
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
			toEdit();
		}
	}
	
	function toEdit(){
		var checkSql="select c.hse_common_id id,e.* from bgp_hse_common c left join bgp_hse_week_event e  on c.hse_common_id=e.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""||datas[0].hse_event_id==null||datas[0].hse_event_id==""){
			if(datas!=null&&datas!=""){
				document.getElementById("hse_common_id").value=datas[0].id;
			}
			action="add";	
			if(organ_flag=="0"){
				var checkSql3="select sum(e.die_event) die_event,sum(e.harm_event) harm_event,sum(e.injure_event) injure_event,sum(e.work_event) work_event,sum(e.medic_event) medic_event,sum(e.aid_event) aid_event,sum(e.not_event) not_event,sum(e.money_event) money_event from bgp_hse_common c join bgp_hse_org ho on c.org_id = ho.org_sub_id left join bgp_hse_week_event e on c.hse_common_id = e.hse_common_id where to_char(c.week_start_date, 'yyyy-MM-dd') = '<%=week_date %>' and c.bsflag = '0' and c.subflag = '1' and ho.father_org_sub_id = '<%=org_id%>'";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3!=null&&datas3!=""){
					document.getElementById("die_event").value=datas3[0].die_event;
					document.getElementById("harm_event").value=datas3[0].harm_event;
					document.getElementById("injure_event").value=datas3[0].injure_event;
					document.getElementById("work_event").value=datas3[0].work_event;
					document.getElementById("medic_event").value=datas3[0].medic_event;
					document.getElementById("aid_event").value=datas3[0].aid_event;
					document.getElementById("not_event").value=datas3[0].not_event;
					document.getElementById("money_event").value=datas3[0].money_event;
					totalDan();
				}
			}else{
				//死亡事故、重伤事故、轻伤事故数量
				var checkSql4="select sum(t.number_die) number_die,sum(t.number_harm) number_harm,sum(t.number_injure) number_injure from bgp_hse_accident_news t where t.bsflag='0' and t.third_org='<%=org_id%>' and t.accident_date>=to_date('<%=week_date %>', 'yyyy-MM-dd') and t.accident_date<=to_date('<%=week_end_date %>', 'yyyy-MM-dd')";
			    var queryRet4 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql4);
				var datas4 = queryRet4.datas;
				if(datas4!=null&&datas4!=""){
					document.getElementById("die_event").value=datas4[0].number_die ? datas4[0].number_die : "0";
					document.getElementById("harm_event").value=datas4[0].number_harm ? datas4[0].number_harm : "0";
					document.getElementById("injure_event").value=datas4[0].number_injure ? datas4[0].number_injure : "0";
				}
				//工作受限、医疗处置、急救事件、未遂事件、财产损失事故
				var checkSql2="select sum(nvl(t.number_owner,0)+nvl(t.number_out,0)+nvl(t.number_stock,0)+nvl(t.number_group,0)) event_num,t.event_property from bgp_hse_event t where t.bsflag='0' and t.third_org='<%=org_id%>' and t.event_date>=to_date('<%=week_date %>','yyyy-MM-dd') and t.event_date<=to_date('<%=week_end_date %>','yyyy-MM-dd') group by t.event_property";
			    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
				var datas2 = queryRet2.datas;
				if(datas2!=null&&datas2!=""){
					for(var i=0;i<datas2.length;i++){
						if(datas2[i].event_property=="1"){
							document.getElementById("work_event").value=datas2[i].event_num ? datas2[i].event_num : "0";
						}
						if(datas2[i].event_property=="2"){
							document.getElementById("medic_event").value=datas2[i].event_num ? datas2[i].event_num : "0";
						}
						if(datas2[i].event_property=="3"){
							document.getElementById("aid_event").value=datas2[i].event_num ? datas2[i].event_num : "0";
						}
						if(datas2[i].event_property=="4"){
							document.getElementById("money_event").value=datas2[i].event_num ? datas2[i].event_num : "0";
						}
						if(datas2[i].event_property=="5"){
							document.getElementById("not_event").value=datas2[i].event_num ? datas2[i].event_num : "0";
						}
					}
				}
				totalDan();
			}
		}else{
			document.getElementById("hse_common_id").value=datas[0].id;
			document.getElementById("hse_event_id").value=datas[0].hse_event_id;
			document.getElementById("die_event").value=datas[0].die_event;
			document.getElementById("harm_event").value=datas[0].harm_event;
			document.getElementById("injure_event").value=datas[0].injure_event;
			document.getElementById("work_event").value=datas[0].work_event;
			document.getElementById("medic_event").value=datas[0].medic_event;
			document.getElementById("aid_event").value=datas[0].aid_event;
			document.getElementById("not_event").value=datas[0].not_event;
			document.getElementById("money_event").value=datas[0].money_event;
			document.getElementById("total_event").value=datas[0].total_event;
			action = "edit";
		}
	} 
	
	function toBack(){
		window.parent.parent.location='<%=contextPath%>/hse/weekReport/week_list.jsp?isProject=<%=isProject%>';
	}
</script>
</html>

