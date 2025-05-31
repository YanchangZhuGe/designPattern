<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
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
		var certificate_flag = document.getElementById("certificate_flag").value;  
		var certificate_date = document.getElementById("certificate_date").value;  
		var certificate_num = document.getElementById("certificate_num").value;  
		var certificate_org = document.getElementById("certificate_org").value;  
		
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select * from (select hw.hse_water_id,hw.project_info_no,hw.employee_id,hw.certificate_flag certificate_flag2,decode(hw.certificate_flag,'1','是','2','否') certificate_flag,hw.certificate_date,hw.certificate_num,hw.certificate_org,hw.modifi_date,hw.bsflag,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,hw.second_org,hw.third_org,hw.fourth_org  from bgp_hse_water hw left join comm_human_employee ee on hw.employee_id=ee.employee_id and ee.bsflag='0'  left join comm_org_subjection os1 on hw.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hw.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hw.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0'  left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0'  left join bgp_comm_human_labor la on la.labor_id=hw.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' where hw.bsflag='0') where bsflag='0' "+querySqlAdd;
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
		if(certificate_flag!=''&&certificate_flag!=null){
			sql = sql+" and certificate_flag2 = '"+certificate_flag+"'";
		}
		if(certificate_date!=''&&certificate_date!=null){
			sql = sql+" and certificate_date = to_date('"+certificate_date+"','yyyy-MM-dd')";
		}
		if(certificate_num!=''&&certificate_num!=null){
			sql = sql+" and certificate_num like '%"+certificate_num+"%'";
		}
		if(certificate_org!=''&&certificate_org!=null){
			sql = sql+" and certificate_org like '%"+certificate_org+"%'";
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
	          <td class="inquire_item6">是否取得《海船船员专业培训合格证》：</td>
			  <td class="inquire_form6">
				<select id="certificate_flag" name="certificate_flag" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >是</option>
					<option value="2" >否</option>
				</select>
			  </td>
	          <td class="inquire_item6">发证日期：</td>
			  <td class="inquire_form6"><input type="text" id="certificate_date" name="certificate_date" class="input_width"  readonly="readonly"/>
				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(certificate_date,tributton4);" />&nbsp;
			  </td>
        </tr>
        <tr>
	        <td class="inquire_item6">签发单位：</td>
			<td class="inquire_form6">
				<input type="text" id="certificate_org" name="certificate_org" class="input_width"></input>
			</td>
			<td class="inquire_item6">合格证号：</td>
			<td class="inquire_form6">
				<input type="text" id="certificate_num" name="certificate_num" class="input_width"></input>
			</td>
          	<td class="inquire_item6"></td>
      	  	<td class="inquire_form6"></td>
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

