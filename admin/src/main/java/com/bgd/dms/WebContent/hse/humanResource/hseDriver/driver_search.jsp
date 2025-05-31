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
		var danger_driver = document.getElementById("danger_driver").value;
		var special_driver = document.getElementById("special_driver").value;
		var type_num = document.getElementById("type_num").value;
		var driver_date = document.getElementById("driver_date").value;
		var doc_num = document.getElementById("doc_num").value;
		var driver_type = document.getElementById("driver_type").value;
		var inner_type = document.getElementById("inner_type").value;
		var driving_num = document.getElementById("driving_num").value;
		var driving_org = document.getElementById("driving_org").value;
		var signer = document.getElementById("signer").value;
		var sign_date = document.getElementById("sign_date").value;
		var days = document.getElementById("days").value;  
		var newDays = Number(days);
		
		var re = /^\-?[0-9]+?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/
		
		var name = document.getElementById("name").value;
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select * from (select hd.hse_driver_id,hd.project_info_no,hd.bsflag,hd.modifi_date,hd.doc_num,hd.driver_type,hd.inner_type,hd.driving_org,hd.signer,hd.sign_date,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id,hd.employee_id,case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,hd.person_status, case when ee.employee_id is null then sd2.coding_name else sds.coding_name end coding_name_xl ,     cd.coding_name title,   hd.driver_date,hd.useful_life,decode(hd.special_driver,'1','是','2','否') special_driver,decode(hd.danger_driver,'1','是','2','否') danger_driver,hd.driving_num,hd.type_num,sd.coding_name,hd.useful_life-to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd') days,case when months_between(hd.useful_life,sysdate)<=0 then 'red'  when months_between(hd.useful_life,sysdate)>2 then '' else 'orange' end color,oi1.org_abbreviation second_org_name, oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name,hd.second_org,hd.third_org,hd.fourth_org from bgp_hse_driver hd left join comm_human_employee ee on hd.employee_id=ee.employee_id and ee.bsflag='0'    left join comm_coding_sort_detail sds    on ee.employee_education_level = sds.coding_code_id   and sds.bsflag = '0'       left join bgp_comm_human_technic ht        on ht.employee_id = ee.employee_id       and ht.bsflag = '0'       left join comm_coding_sort_detail cd      on ht.expert_sort = cd.coding_code_id    and cd.bsflag = '0' left join bgp_comm_human_labor la on la.labor_id=hd.employee_id and la.bsflag='0' left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0'  left join comm_coding_sort_detail sd on hd.inner_type=sd.coding_code_id and sd.bsflag='0' left join comm_org_subjection os1 on hd.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hd.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hd.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0'  left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0' where hd.bsflag='0') where bsflag='0' "+querySqlAdd ;
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
		if(danger_driver!=''&&danger_driver!=null){
			sql = sql+" and danger_driver = '"+danger_driver+"'";
		}
		if(special_driver!=''&&special_driver!=null){
			sql = sql+" and special_driver = '"+special_driver+"'";
		}
		if(type_num!=''&&type_num!=null){
			sql = sql+" and type_num like '%"+type_num+"%'";
		}
		if(driver_date!=''&&driver_date!=null){
			sql = sql+" and driver_date = to_date('"+driver_date+"','yyyy-MM-dd')";
		}
		if(doc_num!=''&&doc_num!=null){
			sql = sql+" and doc_num like '%"+doc_num+"%'";
		}
		if(driver_type!=''&&driver_type!=null){
			sql = sql+" and driver_type = '"+driver_type+"'";
		}
		if(inner_type!=''&&inner_type!=null){
			sql = sql+" and inner_type = '"+inner_type+"'";
		}
		if(driving_num!=''&&driving_num!=null){
			sql = sql+" and driving_num like '%"+driving_num+"%'";
		}
		if(driving_org!=''&&driving_org!=null){
			sql = sql+" and driving_org like '%"+driving_org+"%'";
		}
		if(signer!=''&&signer!=null){
			sql = sql+" and signer like '%"+signer+"%'";
		}
		if(sign_date!=''&&sign_date!=null){
			sql = sql+" and sign_date = to_date('"+sign_date+"','yyyy-MM-dd')";
		}
		if(days!=''&&days!=null){
			if(!re.test(days)){
			       alert("临近有效期日期请输入数字且为整数！");
			       return true;
			    }
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
	         <td class="inquire_item6">是否危化品驾驶员：</td>
			<td class="inquire_form6">
				<select id="danger_driver" name="danger_driver" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >是</option>
					<option value="2" >否</option>
				</select>
			</td>
			<td class="inquire_item6">是否特殊车辆驾驶员：</td>
			<td class="inquire_form6">
				<select id="special_driver" name="special_driver" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >是</option>
					<option value="2" >否</option>
				</select>
			</td>
        </tr>
        <tr>
			<td class="inquire_item6">准驾车型代号：</td>
			<td class="inquire_form6">
				<input type="text" id="type_num" name="type_num" class="input_width"></input>
			</td>
			<td class="inquire_item6">驾驶证初领日期：</td>
			<td class="inquire_form6"><input type="text" id="driver_date" name="driver_date" class="input_width"  readonly="readonly"/>
				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(driver_date,tributton1);" />&nbsp;
			</td>
			<td class="inquire_item6">驾驶证档案编号：</td>
			<td class="inquire_form6">
				<input type="text" id="doc_num" name="doc_num" class="input_width"></input>
			</td>
		</tr>
		<tr>
			<td class="inquire_item6">内部准驾证类型：</td>
			<td class="inquire_form6">
				<select id="driver_type" name="driver_type" class="select_width">
					<option value="" >请选择</option>
					<option value="1" >甲</option>
					<option value="2" >乙</option>
					<option value="3" >丙</option>
				</select>
			</td>
			<td class="inquire_item6">内部准驾车型：</td>
			<td class="inquire_form6">
				<select id="inner_type" name="inner_type" class="select_width">
					<option value="" >请选择</option>
					 <%
					 String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000033' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
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
			<td class="inquire_item6">准驾证编号：</td>
			<td class="inquire_form6">
				<input type="text" id="driving_num" name="driving_num" class="input_width"></input>
			</td>
		</tr>
		<tr>
			<td class="inquire_item6">发证单位：</td>
			<td class="inquire_form6">
				<input type="text" id="driving_org" name="driving_org" class="input_width"></input>
			</td>
			<td class="inquire_item6">签发人：</td>
			<td class="inquire_form6">
				<input type="text" id="signer" name="signer" class="input_width"></input>
			</td>
			<td class="inquire_item6">签发日期：</td>
			<td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width"  readonly="readonly"/>
				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton2);" />&nbsp;
			</td>
		</tr>
		<tr>
			<td class="inquire_item6">临近有效期时间：</td>
			<td class="inquire_form6">
				<input type="text" id="days" name="days" class="input_width" value=""/>
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

