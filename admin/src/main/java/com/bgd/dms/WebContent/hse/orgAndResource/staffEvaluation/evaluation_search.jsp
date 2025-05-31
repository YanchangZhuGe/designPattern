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
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');
		
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var appraiser = document.getElementById("appraiser").value;  
		var evaluation_type = document.getElementById("evaluation_type").value;  
		var staff_name = document.getElementById("staff_name").value;  
		var competent_deal = document.getElementById("competent_deal").value;  
		var evaluation_date = document.getElementById("evaluation_date").value;  
		var evaluation_date2 = document.getElementById("evaluation_date2").value;  
		
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql();
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select distinct t.hse_evaluation_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,"+
		" inf2.org_abbreviation third_name ,t.fourth_org ,inf3.org_abbreviation fourth_name ," +
		" decode(t.evaluation_type ,'1','岗前','2','岗中','') evaluation_type ,t.appraiser , "+
		" to_char(t.evaluation_date,'yyyy-MM-dd')evaluation_date ,months_between(sysdate ,t.evaluation_date) mon"+
		" from bgp_hse_evaluation t"+
		" left join bgp_hse_evaluation_staff s on t.hse_evaluation_id = s.hse_evaluation_id and s.bsflag='0'"+
		" left join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id and sub1.bsflag='0'"+
		" left join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag='0'"+
		" left join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag='0'" +
		" left join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag='0'"+
		" left join comm_org_subjection sub3 on t.fourth_org = sub3.org_subjection_id and sub3.bsflag='0'"+
		" left join comm_org_information inf3 on sub3.org_id = inf3.org_id and inf3.bsflag='0'"+
		" where t.bsflag ='0'"+querySqlAdd;
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and t.fourth_org = '"+fourth_org+"'";
		}
		if(evaluation_type!=''&&evaluation_type!=null){
			sql = sql+" and t.evaluation_type = '"+evaluation_type+"'";
		}
		if(appraiser!=''&&appraiser!=null){
			sql = sql+" and t.appraiser like '%"+appraiser+"%'";
		}
		if(evaluation_date!=''&&evaluation_date!=null){
			sql = sql+" and t.evaluation_date >= to_date('"+evaluation_date+"','yyyy-MM-dd')";
		}
		if(evaluation_date2!=''&&evaluation_date2!=null){
			sql = sql+" and t.evaluation_date <= to_date('"+evaluation_date2+"','yyyy-MM-dd')";
		}
		if(staff_name!=''&&staff_name!=null){
			sql = sql+" and s.staff_name like '%"+staff_name+"%'";
		}
		if(competent_deal!=''&&competent_deal!=null){
			sql = sql+" and s.competent_deal = '"+competent_deal+"'";
		}
		//sql = sql+" order by t.modifi_date desc";
		
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
          <td class="inquire_item6">评价类别:</td>
          <td class="inquire_form6">
          <select id="evaluation_type" name="evaluation_type" class="select_width">
			<option value="" >请选择</option>
			<option value="1" >岗前</option>
			<option value="2" >岗中</option>
		  </select>
          </td>
          <td class="inquire_item6">评价人：</td>
      	  <td class="inquire_form6"><input type="text" id="appraiser" name="appraiser" class="input_width" /></td>
          <td class="inquire_item6">被评价人:</td>
          <td class="inquire_form6"><input id="staff_name" name="staff_name" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item6">不胜任情况的处置:</td>
          <td class="inquire_form6">
			<select id="competent_deal" name="competent_deal" class="select_width">
		        <option value="" >请选择</option>
				<option value="1" >再培训</option>
				<option value="2" >调岗</option>
				<option value="3" >离岗</option>
			</select>
          </td>
          <td class="inquire_item6">评价日期：</td>
		  <td class="inquire_form6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(evaluation_date,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="evaluation_date2" name="evaluation_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(evaluation_date2,tributton2);" />&nbsp;</td>
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

