<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
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
		var work_property = document.getElementById("work_property").value;  
		var plate_property = document.getElementById("plate_property").value;  
		var safeflag = document.getElementById("safeflag").value;  
		var years = document.getElementById("years").value;  
		var days = document.getElementById("days").value;  
		var newYears = Number(years);
		var newDays = Number(days);
		
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var re = /^\-?[0-9]+?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
		if(years!=""){
			if(!re.test(years)){
		    	alert("从事本岗年限请输入数字且为整数！");
		       	return true;
		    }
		}
		if(days!=""){
			if(!re.test(days)){
				alert("临近有效期日期请输入数字且为整数！");
			   	return true;
			}
		}
		
		var sql = "select * from (select * from (select hp.hse_professional_id,hp.project_info_no,hp.bsflag,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id,decode(hp.work_property, '1', '专职', '2', '兼职') work_property,decode(hp.plate_property,'1','野外一线','2','固定场所','3','科研单位','4','培训接待','5','矿区') plate_property,hp.start_date,trunc(months_between(sysdate, hp.start_date) / 12) years,cc.certificate_date,row_number() over(partition by hp.hse_professional_id order by cc.certificate_date asc) asd,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,hp.person_status, case when ee.employee_id is null then sd2.coding_name else sd.coding_name end coding_name,          cd.coding_name title,cc.days,cc.color,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_name,hp.modifi_date ,hp.work_property work_pro,hp.plate_property plate_pro,hp.second_org,hp.third_org,hp.fourth_org  from bgp_hse_professional hp left join comm_human_employee ee on hp.employee_id = ee.employee_id and ee.bsflag = '0'   left join comm_coding_sort_detail sd    on ee.employee_education_level = sd.coding_code_id   and sd.bsflag = '0'       left join bgp_comm_human_technic ht        on ht.employee_id = ee.employee_id       and ht.bsflag = '0'       left join comm_coding_sort_detail cd      on ht.expert_sort = cd.coding_code_id    and cd.bsflag = '0' left join bgp_comm_human_labor la on la.labor_id=hp.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0' left join comm_org_subjection os1 on hp.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0'                   left join comm_org_subjection os2 on hp.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hp.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0' left join (select pc.hse_certificate_id,pc.certificate_date,pc.hse_professional_id,pc.certificate_date -to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd') days, case when months_between(pc.certificate_date,to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) <= 0 then 'red' when months_between(pc.certificate_date, to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) > 2 then '' else 'orange' end color from bgp_hse_professional_cert pc where pc.certificate_date is not null order by pc.certificate_date asc) cc on cc.hse_professional_id = hp.hse_professional_id where hp.bsflag = '0' order by hp.modifi_date desc) where bsflag='0' "+querySqlAdd+") where asd = 1";
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
		if(work_property!=''&&work_property!=null){
			sql = sql+" and work_pro = '"+work_property+"'";
		}
		if(plate_property!=''&&plate_property!=null){
			sql = sql+" and plate_pro = '"+plate_property+"'";
		}
		if(safeflag!=''&&safeflag!=null){
			sql = sql+" and safeflag = '"+safeflag+"'";
		}
		if(years!=''&&years!=null){
			sql = sql+" and years = '"+newYears+"'";
		}
		if(days!=''&&days!=null){
			if(newDays>=0){
				sql = sql+" and days<="+newDays+" and days>=0";
			}else{
				sql = sql+" and days>="+newDays+" and days<=0";
			}
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
	          <td class="inquire_item6">专职或兼职:</td>
	          <td class="inquire_form6">
	          	<select id="work_property" name="work_property" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >专职</option>
					<option value="2" >兼职</option>
				</select>
	          </td>
	          <td class="inquire_item6">板块属性:</td>
	          <td class="inquire_form6">
	          		<select id="plate_property" name="plate_property" class="select_width">
						<option value="" >请选择</option>
					    <option value="1" >野外一线</option>
					    <option value="2" >固定场所</option>
					    <option value="3" >科研单位</option>
					    <option value="4" >培训接待</option>
					    <option value="5" >矿区</option>
					</select>
	          </td>
        </tr>
        <tr>
          <td class="inquire_item6">是否取得注安资格:</td>
          <td class="inquire_form6">
          		<select id="safeflag" name="safeflag" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >是</option>
					<option value="0" >否</option>
				</select>
	      </td>
          <td class="inquire_item6">从事本岗年限:</td>
          <td class="inquire_form6">
	          	<input type="text" id="years" name="years" class="input_width"></input>
	      </td>
          <td class="inquire_item6">临近有效期日期：</td>
      	  <td class="inquire_form6">
      	  	<input type="text" id="days" name="days" class="input_width" />
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

