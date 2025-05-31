<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);
	
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n+1; i >= 2002; i--) {
		listYear.add(i);
	}
 
	String project = request.getParameter("project");
	if(project==null||project.equals("")){
		project = resultMsg.getValue("project");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');
		debugger;
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var year = document.getElementById("year").value;  
		var quarter = document.getElementById("quarter").value;  
		var month = document.getElementById("month").value;
 
 
		var isProject = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql3("ha.",org_subjection_id);
		}else if(isProject=="2"){
			querySqlAdd = "and ha.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select ha.hse_assess_id,ha.leader_sign,case when ha.type=1 then ha.year||'年'||decode(ha.quarter_month,'1','第一季度','4','第二季度','7','第三季度','10','第四季度') when ha.type=2 then ha.year||'年'||ha.quarter_month||'月' end assess_cycle,ha.assess_name,ee.employee_name,au.user_name,decode(ha.assess_status,'0','未提交','1','已提交','2','员工确认','3','审批通过','4','审批未通过') assess_status,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from bgp_hse_assess ha left join comm_org_subjection os1 on ha.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ha.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on ha.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' left join comm_human_employee ee on ha.assess_name=ee.employee_id and ee.bsflag='0' left join p_auth_user au on ha.creator_id=au.user_id and au.bsflag='0' where ha.bsflag='0'  "+querySqlAdd;
		if(second_org!=''&&second_org!=null){
			sql = sql+" and ha.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and ha.third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and ha.fourth_org = '"+fourth_org+"'";
		}
		if(year!=''&&year!=null){
			sql = sql+" and ha.year = '"+year+"'";
		}
		if(quarter!=''&&quarter!=null){
			sql = sql+" and ha.quarter_month = '"+quarter+"' and ha.type='1' ";
		}
		if(month!=''&&month!=null){
			sql = sql+" and ha.quarter_month =  '"+month+"' and ha.type='2'";
		}
	  
		sql = sql+"  order by ha.modifi_date desc";
		
		ctt.refreshData2(sql);
		newClose();
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}

	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}

	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
	
	 function selectQuarter(){
		 var month = document.getElementById("month").value;
		 if(month!=""){
			 alert("季度和月份只能选择其一");
		 }
	 }
	 
	 function selectMonth(){
		 var quarter = document.getElementById("quarter").value;
		 if(quarter!=""){
			 alert("季度和月份只能选择其一");
		 }
	 }
	 
	 
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
	        <td class="inquire_item6">单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	     	<td class="inquire_item6">基层单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
	      	<input type="text" id="third_org2" name="third_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	      	</td>
	     	<td class="inquire_item6">下属单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
	      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
	      	</td>
        </tr>
	        <tr>
	    	<td class="inquire_item6">考核期：</td>
	      	<td class="inquire_form6">
		      	<select id="year" name="year" class="select_width">
			       	<option value="" >请选择</option>
					<%for(int j=0;j<listYear.size();j++){%>
					<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
					<% } %>
				</select>年
	      	</td>
	     	<td class="inquire_item6">季度：</td>
	      	<td class="inquire_form6">
	      		<select id="quarter" name="quarter" class="select_width" onclick="selectQuarter()">
		          <option value="" >请选择</option>
		          <option value="1" >第一季度</option>
		          <option value="4" >第二季度</option>
		          <option value="7" >第三季度</option>
		          <option value="10">第四季度</option>
			    </select>
	      	</td>
	    	<td class="inquire_item6">月份：</td>
	      	<td class="inquire_form6">
		      	<select id="month" name="month" class="select_width" onclick="selectMonth()">
			       	<option value="" >请选择</option>
					<%for(int j=1;j<13;j++){%>
					<option value="<%=j %>"><%=j %></option>
					<% } %>
				</select>
	      	</td>
	     </tr>
        
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>

