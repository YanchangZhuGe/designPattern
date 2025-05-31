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
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			    
			   <input id="week_date" name="week_date" type="hidden"  value="<%=week_date %>"/>
			 
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
      <fieldSet style="margin-left:2px"><legend><%=orgName %>信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input type="hidden" id="work_hour_id" name="work_hour_id" value=""></input>
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
        <tr>
          <td class="inquire_item4">本周百万工时总数：</td>
          <td class="inquire_form4">
          	<input name="work_hour" id="work_hour" class="input_width" type="text" value="" />
          </td>
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
	debugger;
	if(subflag=="1"||subflag=="3"){
		document.getElementById("bc").style.display="none";
	}
//	if(action=="add"){
//		document.getElementById("bc").style.display="";
//	}
	toEdit();

	function toAdd(){
		var work_hour_id = document.getElementById("work_hour_id").value;
		var hse_common_id = document.getElementById("hse_common_id").value;
		var work_hour = document.getElementById("work_hour").value;
		var week_date = document.getElementById("week_date").value;
		var re = /^[0-9]+\.?[0-9]*$/;   ////判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/ 
		if (!re.test(work_hour))
		   {
		       alert("请输入数字！");
		       return ;
		    }
		var isProject = "<%=isProject%>";
		var jcdp_tables="[['bgp_hse_common'],['bgp_hse_work_hour','hse_common_id=bgp_hse_common']]"
		             +"&bgp_hse_common={'hse_common_id':'"+hse_common_id+"','week_start_date':'"+week_date+"','week_end_date':'<%=week_end_date%>','org_id':'<%=org_id%>','subflag':'0',"
		           	 +"'bsflag':'0','modifi_date':'<%=now%>',updator_id:'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           	 if(action!="edit"){
		           		jcdp_tables = jcdp_tables+",'create_date':'<%=now%>','creator_id':'"+encodeURI(encodeURI('<%=userName%>'))+"'";
		           		if(isProject=="2"){
			           	 	jcdp_tables = jcdp_tables+",'project_info_no':'<%=user.getProjectInfoNo()%>'";
			           	 }
		           	 }
		           	jcdp_tables = jcdp_tables+"}";
		           	jcdp_tables = jcdp_tables+"&bgp_hse_work_hour={'work_hour_id':'"+work_hour_id+"','hse_work_hour':'"+work_hour+"'}";
		
		var path = "<%=contextPath%>/rad/addOrUpdateMulTableData.srq";
		submitStr = "jcdp_tables="+jcdp_tables;
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		afterSave(retObject);
	}

		//提示保存结果
		function afterSave(retObject,successHint,failHint){
			if(successHint==undefined) successHint = '保存成功';
			if(failHint==undefined) failHint = '保存失败';
			if (retObject.returnCode != "0"){
				alert(failHint);
			}else{
				alert(successHint);
				toEdit();
			}
		}
	
	function toEdit(){
		var checkSql="select c.hse_common_id id,h.* from bgp_hse_common c left join bgp_hse_work_hour h on c.hse_common_id=h.hse_common_id where to_char(c.week_start_date,'yyyy-MM-dd')='<%=week_date %>' and c.bsflag='0' and c.org_id='<%=org_id%>'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""||datas[0].work_hour_id==null||datas[0].work_hour_id==""){
			if(datas!=null&&datas!=""){
				document.getElementById("hse_common_id").value=datas[0].id;
			}
			action="add";
			if(organ_flag=="0"){
				var checkSql3="select sum(hse_work_hour) hse_work_hour from bgp_hse_common c left join bgp_hse_org ho  on c.org_id = ho.org_sub_id  left join bgp_hse_work_hour h on c.hse_common_id = h.hse_common_id where to_char(c.week_start_date, 'yyyy-MM-dd') = '<%=week_date %>' and c.bsflag = '0' and c.subflag='1' and ho.father_org_sub_id = '<%=org_id%>'";
			    var queryRet3 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql3);
				var datas3 = queryRet3.datas;
				if(datas3!=null||datas3!=""){
					document.getElementById("work_hour").value=datas3[0].hse_work_hour ? datas3[0].hse_work_hour : "0";
				}
			}else{
				var checkSql2="select nvl((select a.workhour from bgp_hse_workhour_all a where to_char(a.create_date, 'yyyy-MM-dd') = '<%=week_end_date%>' and a.subjection_id = '<%=org_id%>' and rownum = 1),0) - nvl((select a.workhour from bgp_hse_workhour_all a where to_char(a.create_date+1,'yyyy-MM-dd') = '<%=week_date%>' and a.subjection_id = '<%=org_id%>' and rownum = 1),0) hse_work_hour from bgp_hse_workhour_all t where subjection_id = '<%=org_id%>' and rownum=1";
			    var queryRet2 = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql2);
				var datas2 = queryRet2.datas;
				if(datas2!=null||datas2!=""){
					document.getElementById("work_hour").value=datas2[0].hse_work_hour;
				}
			}
			
		}else{
			document.getElementById("hse_common_id").value=datas[0].id;
			document.getElementById("work_hour_id").value=datas[0].work_hour_id;
			document.getElementById("work_hour").value=datas[0].hse_work_hour;
			action = "edit";
		}
	} 

	function toBack(){
		window.parent.parent.location='<%=contextPath%>/hse/weekReport/week_list.jsp?isProject=<%=isProject%>';
	}
	
	
</script>
</html>

