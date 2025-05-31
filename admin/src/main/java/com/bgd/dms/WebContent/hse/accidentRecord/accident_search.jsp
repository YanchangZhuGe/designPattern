<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
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
<script language="javaScript">

	cruConfig.contextPath = "<%=contextPath%>";

	function submit(){
		var ctt = top.frames['list'];
		
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var accident_name = document.getElementById("accident_name").value;  
		var accident_level = document.getElementById("accident_level").value;  
		var accident_type = document.getElementById("accident_type").value;  
		var event_type = document.getElementById("event_type").value;  
		var accident_date = document.getElementById("accident_date").value;  
		var accident_date2 = document.getElementById("accident_date2").value;  
		
		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from ((select n.hse_accident_id, second_org,third_org,fourth_org,accident_name,accident_date,decode(accident_type,'1','工业生产安全事故','2','火灾事故','3','交通事故') as accident_type,decode(r.accident_level,'1','一般','2','较大','3','重大','4','特大') as accident_level,n.modifi_date,1 flag,n.project_info_no,n.bsflag from bgp_hse_accident_news n left join bgp_hse_accident_record r on n.hse_accident_id = r.hse_accident_id and r.bsflag = '0' where n.bsflag = '0') union all (select hse_event_id,second_org,third_org,fourth_org,event_name,event_date,decode(event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,null,modifi_date,2 flag,project_info_no,bsflag from bgp_hse_event e where e.bsflag='0')) t left  join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' where t.bsflag='0' "+sql;
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and t.fourth_org = '"+fourth_org+"'";
		}
		if(accident_name!=''&&accident_name!=null){
			sql = sql+" and t.accident_name like '%"+accident_name+"%'";
		}
		if(accident_level!=''&&accident_level!=null){
			sql = sql+" and t.accident_level = '"+accident_level+"'";
		}
		if(accident_type!=''&&accident_type!=null){
			sql = sql+" and t.accident_type = '"+accident_type+"'";
		}
		if(event_type!=''&&event_type!=null){
			sql = sql+" and t.accident_type = '"+event_type+"'";
		}
		if(accident_date!=''&&accident_date!=null){
			sql = sql+" and t.accident_date >= to_date('"+accident_date+"','yyyy-MM-dd')";
		}
		if(accident_date2!=''&&accident_date2!=null){
			sql = sql+" and t.accident_date <= to_date('"+accident_date2+"','yyyy-MM-dd')";
		}
		sql = sql+" order by t.modifi_date desc";
		
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
          <td class="inquire_item6">事故事件名称：</td>
      	  <td class="inquire_form6"><input type="text" id="accident_name" name="accident_name" class="input_width" /></td>
          <td class="inquire_item6">事故等级:</td>
          <td class="inquire_form6">
          	<select id="accident_level" name="accident_level" class="select_width">
				<option value="" >请选择</option>
				<option value="一般" >一般</option>
				<option value="较大" >较大</option>
				<option value="重大" >重大</option>
				<option value="特大" >特大</option>
			</select>
          </td>
          <td class="inquire_item6">事故类型:</td>
          <td class="inquire_form6">
          <select id="accident_type" name="accident_type" class="select_width">
			<option value="" >请选择</option>
			<option value="工业生产安全事故" >工业生产安全事故</option>
			<option value="火灾事故" >火灾事故</option>
			<option value="交通事故" >交通事故</option>
		  </select>
          </td>
        </tr>
        <tr>
          <td class="inquire_item6">事件类型:</td>
          <td class="inquire_form6">
	          <select id="event_type" name="event_type" class="select_width">
				<option value="" >请选择</option>
				<option value="工业生产安全事件" >工业生产安全事件</option>
				<option value="火灾事件" >火灾事件</option>
				<option value="道路交通事件" >道路交通事件</option>
				<option value="其他事件" >其他事件</option>
			</select>
          </td>
          <td class="inquire_item6">事故事件日期：</td>
		  <td class="inquire_form6"><input type="text" id="accident_date" name="accident_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_date,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="accident_date2" name="accident_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_date2,tributton2);" />&nbsp;</td>
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

