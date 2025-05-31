<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
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
		var ctt = top.frames('list');
		
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var event_name = document.getElementById("event_name").value;  
		var event_type = document.getElementById("event_type").value;  
		var event_property = document.getElementById("event_property").value;  
		var event_place = document.getElementById("event_place").value;  
		var event_date = document.getElementById("event_date").value;  
		var event_date2 = document.getElementById("event_date2").value;  
		var write_date = document.getElementById("write_date").value;  
		var write_date2 = document.getElementById("write_date2").value;  
		var out_flag = document.getElementById("out_flag").value; 
		
		
		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			debugger;
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}

		var sql = "select t.hse_event_id,t.second_org,t.third_org,t.event_name,t.event_date,t.event_place,decode(t.event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,decode(t.event_property,'1','限工事件','2','医疗事件','3','急救箱事件','4','经济损失事件','5','未遂事件') as event_property,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date,t.modifi_date from bgp_hse_event t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0'  where t.bsflag = '0' "+sql;
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and t.fourth_org = '"+fourth_org+"'";
		}
		if(event_name!=''&&event_name!=null){
			sql = sql+" and t.event_name like '%"+event_name+"%'";
		}
		if(event_type!=''&&event_type!=null){
			sql = sql+" and t.event_type = '"+event_type+"'";
		}
		if(event_place!=''&&event_place!=null){
			sql = sql+" and t.event_place like '%"+event_place+"%'";
		}
		if(event_property!=''&&event_property!=null){
			sql = sql+" and t.event_property = '"+event_property+"'";
		}
		if(event_date!=''&&event_date!=null){
			sql = sql+" and t.event_date >= to_date('"+event_date+"','yyyy-MM-dd')";
		}
		if(event_date2!=''&&event_date2!=null){
			sql = sql+" and t.event_date <= to_date('"+event_date2+"','yyyy-MM-dd')";
		}
		if(write_date!=''&&write_date!=null){
			sql = sql+" and t.write_date >= to_date('"+write_date+"','yyyy-MM-dd')";
		}
		if(write_date2!=''&&write_date2!=null){
			sql = sql+" and t.write_date <= to_date('"+write_date2+"','yyyy-MM-dd')";
		}
		if(out_flag!=''&&out_flag!=null){
			sql = sql+" and t.out_flag = '"+out_flag+"'";
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
          <td class="inquire_item6">事件名称：</td>
      	  <td class="inquire_form6"><input type="text" id="event_name" name="event_name" class="input_width" /></td>
          <td class="inquire_item6">事件类型:</td>
          <td class="inquire_form6">
          	<select id="event_type" name="event_type" class="select_width">
				<option value="" >请选择</option>
				<option value="1" >工业生产安全事件</option>
				<option value="2" >火灾事件</option>
				<option value="3" >道路交通事件</option>
				<option value="6" >其他事件</option>
			</select>
          </td>
          <td class="inquire_item6">事件地点：</td>
      	  <td class="inquire_form6"><input type="text" id="event_place" name="event_place" class="input_width" /></td>
        </tr>
        <tr>
          <td class="inquire_item6">事件性质:</td>
          <td class="inquire_form6">
          	<select id="event_property" name="event_property" class="select_width">
				<option value="" >请选择</option>
				<option value="1" >限工事件</option>
				<option value="2" >医疗事件</option>
				<option value="3" >急救箱事件</option>
				<option value="4" >经济损失事件</option>
				<option value="5" >未遂事件</option>
			</select>
          </td>
          <td class="inquire_item6">事件日期：</td>
		  <td class="inquire_form6"><input type="text" id="event_date" name="event_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(event_date,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="event_date2" name="event_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(event_date2,tributton2);" />&nbsp;</td>
        </tr>
        <tr>
          <td class="inquire_item6">是否为承包商:</td>
          <td class="inquire_form6">
			<select id="out_flag" name="out_flag" class="select_width">
		        <option value="" >请选择</option>
				<option value="1" >是</option>
				<option value="0" >否</option>
			</select>
          </td>
          <td class="inquire_item6">填报日期：</td>
		  <td class="inquire_form6"><input type="text" id="write_date" name="write_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(write_date,tributton3);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="write_date2" name="write_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(write_date2,tributton4);" />&nbsp;</td>
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

