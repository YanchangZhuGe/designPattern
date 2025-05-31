<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getOrgSubjectionId();
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String sub_id = "";
	String father_organ_flag = "";
	String organ_flag = "";
	if(list.size()>1){
	 	Map map = (Map)list.get(0);
	 	Map mapOrg = (Map)list.get(1);
	 	father_id = (String)map.get("orgSubId");
	 	sub_id = (String)mapOrg.get("orgSubId");
	 	father_organ_flag = (String)map.get("organFlag");
	 	organ_flag = (String)mapOrg.get("organFlag");
	 	if(father_organ_flag.equals("0")||user.getOrgSubjectionId().equals("C105")){
	 		father_id = "C105";
	 		organ_flag = "0";
	 	}
	}else if(list.size()==0){
		father_id = "C105";
 		organ_flag = "0";
	}

	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2002; i--) {
		listYear.add(i);
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
<script language="javaScript">
	function submit(){
		var organ_flag = "<%=organ_flag%>";
		var ctt = top.frames('list').frames[1];
		
		var third_org = document.getElementById("third_org").value;
		var year = document.getElementById("year").value;  
		var month = document.getElementById("month").value;
		
		debugger;
		var sql = "select en.hse_environment_id,en.org_sub_id,to_char(en.create_date,'yyyy') year,to_char(en.create_date,'MM') month,en.submit_person,en.submit_date,decode(en.status,'0','未填写','1','已填写','2','已提交 ','3','审批通过','4','审批未通过') status,oi1.org_abbreviation third_org_name,oi2.org_abbreviation second_org_name from bgp_hse_environment en left join bgp_hse_org ho on en.org_sub_id=ho.org_sub_id left join comm_org_subjection os1 on os1.org_subjection_id=en.org_sub_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ho.father_org_sub_id=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0'";
		if(organ_flag=="0"){
			sql += " where ho.father_org_sub_id = '<%=father_id%>'"; 
		}else{
			sql += " where ho.org_sub_id = '<%=sub_id%>'"; 
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and oi1.org_abbreviation like '%"+third_org+"%'";
		}
		if(year!=''&&year!=null){
			sql = sql+" and to_char(en.create_date,'yyyy') = '"+year+"'";
		}
		if(month!=''&&month!=null){
			sql = sql+" and to_number(to_char(en.create_date, 'MM')) = '"+month+"'";
		}
		sql = sql+" order by en.create_date desc,en.modifi_date desc";
		
		ctt.refreshData2(sql);
		newClose();
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
	        <td class="inquire_item4">基层单位：</td>
	      	<td class="inquire_form4" colspan="3">
	      	<input type="text" id="third_org" name="third_org" class="input_width" />
	      	</td>
        </tr>
        <tr>
          <td class="inquire_item4">年度：</td>
      	  <td class="inquire_form4">
      	  		<select id="year" name="year" class="select_width">
	      	  		<option value="">请选择</option>
	      	  		<% for (int i = n; i >= 2002; i--){%>
	      	  			<option value="<%=i %>"><%=i %></option>
					<%} %>
				</select>
		  </td>
          <td class="inquire_item4">月:</td>
          <td class="inquire_form4">
				<select id="month" name="month" class="select_width">
					<option value="">请选择</option>
					<%for(int i= 1;i<13;i++){ %>
					<option value="<%=i %>"><%=i%></option>
					<%} %>
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

