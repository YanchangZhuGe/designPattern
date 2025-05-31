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
<body class="bgColor_f3f3f3" onload="">
<form name="form1" id="form1" method="post" action="">
<div id="list_table" style="height: 380px;overflow: auto;">
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
      <fieldSet style="margin-left:2px"><legend>本单位信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
      	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value=""></input>
        	<tr>
				<td  class="bt_info_odd">单位</td>
				<td class="bt_info_even">未整改隐患</td>
				<td class="bt_info_odd">特大</td>		
				<td class="bt_info_even">重大</td>
				<td class="bt_info_odd">较大</td>
				<td class="bt_info_even">一般</td>
				<td class="bt_info_odd">合计</td>
			</tr>
			<tr >
				<td class="even_odd"><%=orgName %></td>
				<td class="even_even"><input type="text" id="no_modify_dan" name="no_modify_dan" size="7" value="0"></input></td>
				<td class="even_odd"><input type="text" id="first_big_dan" name="first_big_dan"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_even"><input type="text" id="second_big_dan" name="second_big_dan"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_odd"><input type="text" id="third_big_dan" name="third_big_dan" size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_even"><input type="text" id="usual_dan" name="usual_dan"  size="7" value="0" onchange="totalDan()"></input></td>
				<td class="even_odd"><input type="text" id="total_dan" name="total_dan" value="0" size="7"></input></td>
			</tr>
      </table>
      </fieldSet>
  </div>
</form>
</body>
<script type="text/javascript">
var action="<%=action %>";
var org_id="<%=org_id %>";
var subflag="<%=subflag %>";
var organ_flag="<%=organ_flag %>";
if(subflag=="1"||subflag=="3"){
	document.getElementById("bc").style.display="none";
}
//if(action=="add"){
//	document.getElementById("bc").style.display="";
//}
toEdit();

function totalDan(){
	var first_big_dan = document.getElementById("first_big_dan").value;
	var second_big_dan = document.getElementById("second_big_dan").value;
	var third_big_dan = document.getElementById("third_big_dan").value;
	var usual_dan = document.getElementById("usual_dan").value;
	first_big_dan = Number(first_big_dan);
	second_big_dan = Number(second_big_dan);
	third_big_dan = Number(third_big_dan);
	usual_dan = Number(usual_dan);
	document.getElementById("total_dan").value=first_big_dan+second_big_dan+third_big_dan+usual_dan;
}

function toAdd(){
	var hse_common_id = document.getElementById("hse_common_id").value;
	var hse_danger_id = document.getElementById("hse_danger_id").value;
	var no_modify_dan = document.getElementById("no_modify_dan").value;
	var first_big_dan = document.getElementById("first_big_dan").value;
	var second_big_dan = document.getElementById("second_big_dan").value;
	var third_big_dan = document.getElementById("third_big_dan").value;
	var usual_dan = document.getElementById("usual_dan").value;
	var total_dan = document.getElementById("total_dan").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/ 
	if (!re.test(no_modify_dan)||!re.test(first_big_dan)||!re.test(second_big_dan)||!re.test(third_big_dan)||!re.test(usual_dan)||!re.test(total_dan))
	   {
	       alert("请输入数字！");
	       return ;
	    }
	
	var isProject = "<%=isProject%>";
	var jcdp_tables="[['bgp_hse_common'],['bgp_hse_week_dan','hse_common_id=bgp_hse_common']]"
	             +"&bgp_hse_common={'hse_common_id':'"+hse_common_id+"','week_start_date':'<%=week_date%>','week_end_date':'<%=week_end_date%>','org_id':'<%=org_id%>','subflag':'0',"
	           	 +"'bsflag':'0','modifi_date':'<%=now%>',updator_id:'"+encodeURI(encodeURI('<%=userName%>'))+"'";
	           	 if(action!="edit"){
	           	 	jcdp_tables = jcdp_tables+",'create_date':'<%=now%>','creator_id':'"+encodeURI(encodeURI('<%=userName%>'))+"'";
	           		if(isProject=="2"){
		           	 	jcdp_tables = jcdp_tables+",'project_info_no':'<%=user.getProjectInfoNo()%>'";
		           	 }
	           	 }
	           	 jcdp_tables = jcdp_tables +"}";
	           	jcdp_tables = jcdp_tables +"&bgp_hse_week_dan={'hse_danger_id':'"+hse_danger_id+"','no_modify_dan':"+no_modify_dan+",'first_big_dan':"+first_big_dan+",'second_big_dan':"+second_big_dan+",'third_big_dan':"+third_big_dan+",'usual_dan':"+usual_dan+",'total_dan':"+total_dan+"}";
	
	var path = "<%=contextPath%>/rad/addOrUpdateMulTableData.srq";
	submitStr = "jcdp_tables="+jcdp_tables;
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);
	afterSave(retObject);
}

	//提示提交结果
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '保存成功';
		if(failHint==undefined) failHint = '保存失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
			toEdit();
		}
	}
	
	function toEdit(){
		var checkSql="select c.hse_common_id id,d.* from bgp_hse_common c left join bgp_hse_week_dan d  on c.hse_common_id=d.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""||datas[0].hse_danger_id==null||datas[0].hse_danger_id==""){
			if(datas!=null&&datas!=""){
				document.getElementById("hse_common_id").value=datas[0].id;
			}
			action="add";	
			if(organ_flag=="0"){
				var checkSql3="select sum(d.no_modify_dan) no_modify_dan,sum(d.first_big_dan) first_big_dan,sum(d.second_big_dan) second_big_dan,sum(d.third_big_dan) third_big_dan,sum(d.usual_dan) usual_dan from bgp_hse_common c join bgp_hse_org ho on c.org_id = ho.org_sub_id left join bgp_hse_week_dan d on c.hse_common_id = d.hse_common_id where to_char(c.week_start_date, 'yyyy-MM-dd') = '<%=week_date %>' and c.bsflag = '0' and c.subflag='1' and ho.father_org_sub_id = '<%=org_id%>'";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3!=null&&datas3!=""){
					document.getElementById("no_modify_dan").value=datas3[0].no_modify_dan ? datas3[0].no_modify_dan : "0";
					document.getElementById("first_big_dan").value=datas3[0].first_big_dan ? datas3[0].first_big_dan : "0";
					document.getElementById("second_big_dan").value=datas3[0].second_big_dan ? datas3[0].second_big_dan : "0";
					document.getElementById("third_big_dan").value=datas3[0].third_big_dan ? datas3[0].third_big_dan : "0";
					document.getElementById("usual_dan").value=datas3[0].usual_dan ? datas3[0].usual_dan : "0";
					totalDan();
				}
			}else{
				//未整改数量
				var checkSql4="select count(d.mdetail_no) no_modify_dan  from bgp_hse_hidden_information t left join bgp_hidden_information_detail d on t.hidden_no=d.hidden_no and d.bsflag='0' where t.bsflag='0' and t.report_date>=to_date('<%=week_date %>','yyyy-mm-dd') and t.report_date<=to_date('<%=week_end_date %>','yyyy-MM-dd') and d.rectification_state='2' and t.second_org='<%=org_id%>'";
			    var queryRet4 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql4);
				var datas4 = queryRet4.datas;
				if(datas4!=null&&datas4!=""){
					document.getElementById("no_modify_dan").value=datas4[0].no_modify_dan;
				}
				//隐患级别 特大，重大，较大，一般数量
				var checkSql2="select count(t.hidden_no) hidden_num,t.hidden_level from bgp_hse_hidden_information t where t.bsflag='0' and t.report_date>=to_date('<%=week_date %>','yyyy-mm-dd') and t.report_date<=to_date('<%=week_end_date %>','yyyy-MM-dd') and t.second_org='<%=org_id%>'  group by t.hidden_level order by t.hidden_level asc";
			    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
				var datas2 = queryRet2.datas;
				if(datas2!=null&&datas2!=""){
					for(var i=0;i<datas2.length;i++){
						if(datas2[i].hidden_level=="1"){
							document.getElementById("first_big_dan").value=datas2[i].hidden_num;
						}
						if(datas2[i].hidden_level=="2"){
							document.getElementById("second_big_dan").value=datas2[i].hidden_num;
						}
						if(datas2[i].hidden_level=="3"){
							document.getElementById("third_big_dan").value=datas2[i].hidden_num;
						}
						if(datas2[i].hidden_level=="4"){
							document.getElementById("usual_dan").value=datas2[i].hidden_num;
						}
					}
					 totalDan();
				}
			}
		}else{
			document.getElementById("hse_common_id").value=datas[0].id;
			document.getElementById("hse_danger_id").value=datas[0].hse_danger_id;
			document.getElementById("no_modify_dan").value=datas[0].no_modify_dan;
			document.getElementById("first_big_dan").value=datas[0].first_big_dan;
			document.getElementById("second_big_dan").value=datas[0].second_big_dan;
			document.getElementById("third_big_dan").value=datas[0].third_big_dan;
			document.getElementById("usual_dan").value=datas[0].usual_dan;
			document.getElementById("total_dan").value=datas[0].total_dan;
			action = "edit";
		}
	} 
	
	function toBack(){
		window.parent.parent.location='<%=contextPath%>/hse/weekReport/week_list.jsp?isProject=<%=isProject%>';
	}
</script>
</html>

