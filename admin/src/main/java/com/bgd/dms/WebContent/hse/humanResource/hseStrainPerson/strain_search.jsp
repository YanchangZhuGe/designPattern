<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project = request.getParameter("project");
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
		var ctt = top.frames('list').frames[1];
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var name = document.getElementById("name").value;  
		var strain_duty = document.getElementById("strain_duty").value;
		var expert_flag = document.getElementById("expert_flag").value;
		
		var re = /^\-?[0-9]+?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/
		
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select * from (select hs.hse_strain_id,hs.project_info_no,hs.bsflag,hs.modifi_date,hs.strain_duty,hs.expert_flag expert_flag2,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id,decode(hs.expert_flag,'1','是','2','否') expert_flag,sd.coding_name, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,      decode(hs.expert_level,'1','集团公司','2','公司','3','二级单位') expert_level,   decode(hs.strain_type,'1、2、3、4','自然灾害，事故灾难，公共卫生，社会安全','1、2','自然灾害，事故灾难','1、3','自然灾害，公共卫生','1、4','自然灾害，社会安全','2、3','事故灾难，公共卫生','2、4','事故灾难，社会安全','3、4','公共卫生,社会安全','1','自然灾害','2','事故灾难','3','公共卫生','4','社会安全') test_type,    ed.coding_name expert_field,hs.first_phone,hs.second_phone,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,hs.second_org,hs.third_org,hs.fourth_org from bgp_hse_strain hs left join comm_human_employee ee on ee.employee_id=hs.employee_id and ee.bsflag='0' left join bgp_comm_human_labor la on la.labor_id=hs.employee_id and la.bsflag='0'  left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0'  left join comm_coding_sort_detail sd on hs.strain_duty=sd.coding_code_id and sd.bsflag='0'   left join comm_coding_sort_detail ed on hs.expert_field = ed.coding_code_id and ed.bsflag = '0' left join comm_org_subjection os1 on hs.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hs.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hs.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0' where hs.bsflag='0') where bsflag='0' "+querySqlAdd;
		if(second_org!=''&&second_org!=null){
			sql = sql+" and second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and fourth_org = '"+fourth_org+"'";
		}
		if(name!=''&&name!=null){
			sql = sql+" and employee_name like '%"+name+"%'";
		}
		if(strain_duty!=''&&strain_duty!=null){
			sql = sql+" and strain_duty = '"+strain_duty+"'";
		}
		if(expert_flag!=''&&expert_flag!=null){
			sql = sql+" and expert_flag2 = '"+expert_flag+"'";
		}
		sql = sql+" order by modifi_date desc";
		
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
	          <td class="inquire_item6">姓名:</td>
	          <td class="inquire_form6">
	          	<input type="text" id="name" name="name" class="input_width"></input>
	          </td>
	         <td class="inquire_item6">应急职责：</td>
			<td class="inquire_form6">
				<select id="strain_duty" name="strain_duty" class="select_width">
					<option value="" >请选择</option>
					<%
					String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000034' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
					List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					for(int i=0;i<list.size();i++){
					Map map = (Map)list.get(i);
					String coding_id = (String)map.get("codingCodeId");
					String coding_name = (String)map.get("codingName");
					%>
					<option value="<%=coding_id %>" ><%=coding_name %></option>
					<%} %>
				</select>
			</td>
			<td class="inquire_item6">应急专家：</td>
			<td class="inquire_form6">
				<select id="expert_flag" name="expert_flag" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >是</option>
					<option value="2" >否</option>
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

