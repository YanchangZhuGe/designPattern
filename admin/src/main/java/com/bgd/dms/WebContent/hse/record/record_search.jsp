<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
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
		var accident_name = document.getElementById("accident_name").value;  
		var accident_type = document.getElementById("accident_type").value;  
		var accident_date = document.getElementById("accident_date").value;  
		var accident_date2 = document.getElementById("accident_date2").value;  
		var case_date = document.getElementById("case_date").value;  
		var case_date2 = document.getElementById("case_date2").value;  
		var case_flag = document.getElementById("case_flag").value;  
		var out_flag = document.getElementById("out_flag").value;  
		var number_die = document.getElementById("number_die").value;  

		var isProject = "<%=isProject%>";
		var sql = "";
		if(isProject=="1"){
			sql = getMultipleSql();
		}else if(isProject=="2"){
			sql = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select t.hse_accident_id,t.second_org,t.third_org,t.accident_name,t.accident_date,t.accident_place,t.accident_type,r.accident_level,sd.coding_name type_name,sd2.coding_name level_name,decode(r.modifi_date ,null ,to_date('2008-08-08','yyyy-MM-dd'),r.modifi_date) as modifi_time,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name,t.create_date from bgp_hse_accident_news t left join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on t.fourth_org = os3.org_subjection_id and os3.bsflag = '0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag = '0' left join bgp_hse_accident_record r on t.hse_accident_id=r.hse_accident_id and r.bsflag='0' left join comm_coding_sort_detail sd on sd.coding_code_id=t.accident_type and sd.bsflag='0' left join comm_coding_sort_detail sd2 on sd2.coding_code_id=r.accident_level and sd2.bsflag='0' where t.bsflag = '0' "+sql;
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
		if(accident_type!=''&&accident_type!=null){
			sql = sql+" and t.accident_type = '"+accident_type+"'";
		}
		if(accident_date!=''&&accident_date!=null){
			sql = sql+" and t.accident_date >= to_date('"+accident_date+"','yyyy-MM-dd')";
		}
		if(accident_date2!=''&&accident_date2!=null){
			sql = sql+" and t.accident_date <= to_date('"+accident_date2+"','yyyy-MM-dd')";
		}
		if(case_date!=''&&case_date!=null){
			sql = sql+" and r.case_date >= to_date('"+case_date+"','yyyy-MM-dd')";
		}
		if(case_date2!=''&&case_date2!=null){
			sql = sql+" and r.case_date <= to_date('"+case_date2+"','yyyy-MM-dd')";
		}
		if(case_flag!=''&&case_flag!=null){
			sql = sql+" and r.case_flag = '"+case_flag+"'";
		}
		if(out_flag!=''&&out_flag!=null){
			sql = sql+" and t.out_flag = '"+out_flag+"'";
		}
		if(number_die!=''&&number_die!=null){
			sql = sql+" and hse_accident_id in (select hse_accident_id from (select n.hse_accident_id, sum(nvl(number_die,0)) as sum_die from bgp_hse_accident_number n where n.bsflag = '0' group by n.hse_accident_id) where sum_die='"+number_die+"')";
		}
		sql = sql+" order by modifi_time desc,t.modifi_date desc";
		
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
          <td class="inquire_item6">事故名称：</td>
      	  <td class="inquire_form6"><input type="text" id="accident_name" name="accident_name" class="input_width" /></td>
          <td class="inquire_item6">事故类型:</td>
          <td class="inquire_form6">
          <select id="accident_type" name="accident_type" class="select_width">
			<option value="" >请选择</option>
			<%
	          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000042' and superior_code_id='0' and bsflag='0' order by coding_show_id desc";
	          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	          	for(int i=0;i<list.size();i++){
	          		Map map22 = (Map)list.get(i);
	          		String coding_id = (String)map22.get("codingCodeId");
	          		String coding_name = (String)map22.get("codingName");
	      	%>
	       	<option value="<%=coding_id %>" ><%=coding_name %></option>
	       	<%} %>
		  </select>
          </td>
          <td class="inquire_item6">是否为承包商:</td>
          <td class="inquire_form6">
			<select id="out_flag" name="out_flag" class="select_width">
		        <option value="" >请选择</option>
				<option value="1" >是</option>
				<option value="0" >否</option>
			</select>
          </td>
        </tr>
        <tr>
          <td class="inquire_item6">死亡人数：</td>
      	  <td class="inquire_form6"><input type="text" id="number_die" name="number_die" class="input_width" /></td>
          <td class="inquire_item6">事故日期：</td>
		  <td class="inquire_form6"><input type="text" id="accident_date" name="accident_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_date,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="accident_date2" name="accident_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(accident_date2,tributton2);" />&nbsp;</td>
        </tr>
        <tr>
          <td class="inquire_item6">是否结案:</td>
          <td class="inquire_form6">
          	<select id="case_flag" name="case_flag" class="select_width">
		        <option value="" >请选择</option>
				<option value="1" >是</option>
				<option value="0" >否</option>
			</select>
          </td>
          <td class="inquire_item6">结案日期：</td>
		  <td class="inquire_form6"><input type="text" id="case_date" name="case_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(case_date,tributton3);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="case_date2" name="case_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(case_date2,tributton4);" />&nbsp;</td>
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

