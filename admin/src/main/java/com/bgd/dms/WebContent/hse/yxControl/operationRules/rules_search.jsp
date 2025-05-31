<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String org_subjection_id = user.getOrgSubjectionId();
	if(org_subjection_id == null){
		org_subjection_id = "";
	}
	Date date = new Date();
	int year = date.getYear()+1900;
	
	String isProject = request.getParameter("isProject");
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
			      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
			      	<%} %>
			      	</td>
			     	<td class="inquire_item6">基层单位：</td>
			      	<td class="inquire_form6">
			      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			      	<%} %>
			      	</td>
			    </tr>
			    <tr>
					<td class="inquire_item6">工作安全分析日期：</td>
				  	<td class="inquire_form6"><input type="text" id="rules_analy_date" name="rules_analy_date" class="input_width" readonly="readonly"/>
				  	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rules_analy_date,tributton1);" />&nbsp;</td>
				 	<td class="inquire_item6">至</td>
				  	<td class="inquire_form6"><input type="text" id="rules_analy_date2" name="rules_analy_date2" class="input_width" readonly="readonly"/>
				  	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rules_analy_date2,tributton2);" />&nbsp;</td>
				</tr>					
				<tr>    
				    <td class="inquire_item6">工作循环检查日期：</td>
				  	<td class="inquire_form6"><input type="text" id="rules_check_date" name="rules_check_date" class="input_width" readonly="readonly"/>
				  	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rules_check_date,tributton3);" />&nbsp;</td>
				 	<td class="inquire_item6">至</td>
				  	<td class="inquire_form6"><input type="text" id="rules_check_date2" name="rules_check_date2" class="input_width" readonly="readonly"/>
				  	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rules_check_date2,tributton4);" />&nbsp;</td>
				</tr>
			</table>
		</div>
		<div id="oper_div">
		 	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
		    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div>
</div>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";

	function submit(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			retObj = jcdpCallService("HseSrv", "queryOrg", "");
			if(retObj.flag!="false"){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag!="0"){
						querySqlAdd = " and t.second_org = '" + retObj.list[0].orgSubId +"'";
						if(len>1){
							if(retObj.list[1].organFlag!="0"){
								querySqlAdd = " and t.third_org = '" + retObj.list[1].orgSubId +"'";
							}
						}
					}
				}
			}
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		var ctt = top.frames('list');
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var rules_analy_date=document.getElementById("rules_analy_date").value;
		var rules_analy_date2=document.getElementById("rules_analy_date2").value;
		var rules_check_date=document.getElementById("rules_check_date").value;
		var rules_check_date2=document.getElementById("rules_check_date2").value;
		var sql = "select t.rules_id ,t.second_org ,inf1.org_abbreviation second_name ,"+
		" t.third_org ,inf2.org_abbreviation third_name ,t.rules_analy_date ,t.rules_check_date " +
		" from bgp_hse_operation_rules t"+
		" join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id and sub1.bsflag='0'"+
		" join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag='0'"+
		" join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag='0'" +
		" join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag='0'"+
		" where t.bsflag ='0' ";
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(rules_analy_date!=''&&rules_analy_date!=null){
			sql = sql+" and t.rules_analy_date >= to_date('"+rules_analy_date+"','yyyy-MM-dd')";
		}
		if(rules_analy_date2!=''&&rules_analy_date2!=null){
			sql = sql+" and t.rules_analy_date <= to_date('"+rules_analy_date2+"','yyyy-MM-dd')";
		}
		if(rules_check_date!=''&&rules_check_date!=null){
			sql = sql+" and t.rules_check_date >= to_date('"+rules_check_date+"','yyyy-MM-dd')";
		}
		if(rules_check_date2!=''&&rules_check_date2!=null){
			sql = sql+" and t.rules_check_date <= to_date('"+rules_check_date2+"','yyyy-MM-dd')";
		}
		
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
	
</script>
</body>

</html>

