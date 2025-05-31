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
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
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
			      	<td class="inquire_item6">下属单位：</td>
			      	<td class="inquire_form6">
			      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
			      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			      	<%}%>
			      	</td>
			    </tr>
			    <tr>
		      		<td class="inquire_item6"><font color="red">*</font>录入年份：</td>
		      		<td class="inquire_form6"><select id="duty_year" name="duty_year" class="select_width">
		      					<option value="" >请选择</option>
					    <% for(int i = year ; i>=2002 ; i--){%>
						       <option value="<%=i %>" ><%=i %></option>
						<% }%>
							</select></td>
		      		<td class="inquire_item6"><font color="red">*</font>作业性质：</td>
     		       <td class="inquire_form6"><select id="task" name="task" class="select_width">
			 		       <option value="" >请选择</option>
					       <option value="1" >野外一线</option>
					       <option value="2" >固定场所</option>
					       <option value="3" >科研单位</option>
					       <option value="4" >培训接待</option>
					       <option value="5" >矿区</option>
						</select>
		      		</td>
		      		<td class="inquire_item6"><font color="red">*</font>板块属性：</td>
		      		<td class="inquire_form6"><select id="duty_module" name="duty_module" class="select_width">		 
					       <option value="" >请选择</option>
					       <option value="1" >机关管理</option>
					       <option value="2" >二线</option>
					       <option value="3" >野外一线</option>
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
<script language="javaScript">
	function submit(){
		var ctt = top.frames('list');		
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var duty_year=document.getElementById("duty_year").value;
		var task=document.getElementById("task").value;
		var duty_module=document.getElementById("duty_module").value;
		 
		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql =  "  and t.project_info_no='<%=user.getProjectInfoNo()%>' ";
		}
  
		var sql = "select t.duty_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,"+
		" inf2.org_abbreviation third_name  ,t.fourth_org ,inf3.org_abbreviation fourth_name ," +
		" t.duty_year ,decode(t.task ,'1','野外一线','2','固定场所','3','科研单位','4','培训接待','5','矿区','') task ,"+
		" decode(t.duty_module,'1','机关管理','2','二线','3','野外一线','') duty_module ,t.master_num ,t.employee_num"+
		" from bgp_hse_duty_book t"+
		" left join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id and sub1.bsflag='0'"+
		"  left join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag='0'"+
		"  left join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag='0'" +
		"  left join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag='0'"+
		"  left join comm_org_subjection sub3 on t.fourth_org = sub3.org_subjection_id and sub3.bsflag='0'"+
		"  left join comm_org_information inf3 on sub3.org_id = inf3.org_id and inf3.bsflag='0'"+
		" where t.bsflag ='0' " +sql ;
 
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and t.fourth_org = '"+fourth_org+"'";
		}
		if(duty_year!=''&&duty_year!=null){
			sql = sql+" and t.duty_year = '"+duty_year+"'";
		}
		if(task!=''&&task!=null){
			sql = sql+" and t.task = '"+task+"'";
		}
		if(duty_module!=''&&duty_module!=null){
			sql = sql+" and t.duty_module = '"+duty_module+"'";
		}
		sql = sql+" order by t.duty_year desc";
		
		ctt.frames[1].refreshData2(sql);
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

