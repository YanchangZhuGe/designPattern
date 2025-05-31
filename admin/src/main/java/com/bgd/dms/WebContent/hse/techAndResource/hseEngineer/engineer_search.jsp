<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
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
		var ctt = top.frames('list').frames[1];
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var name = document.getElementById("name").value;  
		var certificate_num = document.getElementById("certificate_num").value;  
		var licence_num = document.getElementById("licence_num").value;  
		var comm_date = document.getElementById("comm_date").value;
		
		var re = /^\-?[0-9]+?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/
		
		var isProject = "<%=isProject%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(isProject=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select * from (select tr.hse_tech_id,tr.certificate_name,tr.certificate_num,tr.licence_num,tr.assessor_type,tr.org_level,tr.project_info_no,tr.bsflag,tr.modifi_date,decode(tr.plate_property,'1','野外一线','2','固定场所','3','科研单位','4','培训接待','5','矿区') plate_property,decode(tr.org_level,'1','公司集团','2','公司','3','二级单位','4','三级单位') org_lev,decode(tr.assessor_type,'1','实习审核员','2','审核员','3','高级审核员') assessor,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name, case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id, case when ee.employee_id is null then decode(la.employee_gender, '0', '女', '1', '男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type, tr.plate_property property,tr.comm_date,tr.certificate_org,tr.the_end_date - to_date(to_char(sysdate, 'yyyy-MM-dd'), 'yyyy-MM-dd') days,tr.the_end_date, case when months_between(tr.the_end_date, sysdate) <= 0 then 'red' when months_between(tr.the_end_date, sysdate) > 2 then '' else 'orange' end color, oi1.org_abbreviation second_org_name, oi2.org_abbreviation third_org_name, oi3.org_abbreviation fourth_org_name,tr.second_org,tr.third_org,tr.fourth_org from bgp_hse_tech_resource tr left join comm_human_employee ee on tr.employee_id = ee.employee_id and ee.bsflag = '0' left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on os1.org_id = oi1.org_id  and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left join comm_org_information oi2  on os2.org_id = oi2.org_id  and oi2.bsflag = '0'  left join comm_org_subjection os3  on tr.fourth_org = os3.org_subjection_id  and os3.bsflag = '0'  left join comm_org_information oi3  on os3.org_id = oi3.org_id  and oi3.bsflag = '0'  left join comm_org_subjection os  on os.org_id = ee.org_id  and os.bsflag = '0'  left join bgp_comm_human_labor la  on la.labor_id = tr.employee_id  and la.bsflag = '0' left join comm_coding_sort_detail sd2  on la.employee_education_level = sd2.coding_code_id  and sd2.bsflag = '0'  where tr.bsflag = '0' and tr.model_type = '4') where bsflag='0'" +querySqlAdd;
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
		if(certificate_num!=''&&certificate_num!=null){
			sql = sql+" and certificate_num like '%"+certificate_num+"%'";
		}
		if(licence_num!=''&&licence_num!=null){
			sql = sql+" and licence_num like '%"+licence_num+"%'";
		}
		if(comm_date!=''&&comm_date!=null){
			sql = sql+" and comm_date = to_date('"+comm_date+"','yyyy-MM-dd')";
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
         	<td class="inquire_item6"><font color="red">*</font>执业资格证书编号：</td>
		    <td class="inquire_form6">
				<input type="text" id="certificate_num" name="certificate_num" class="input_width"></input>
			</td>
         	<td class="inquire_item6">执业证号：</td>
		    <td class="inquire_form6">
				<input type="text" id="licence_num" name="licence_num" class="input_width"></input>
			</td>
        </tr>
        <tr>
      		<td class="inquire_item6"><font color="red">*</font>初次注册时间：</td>
		   	<td class="inquire_form6"><input type="text" id="comm_date" name="comm_date" class="input_width"  readonly="readonly"/>
		    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(comm_date,tributton1);" />&nbsp;
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

