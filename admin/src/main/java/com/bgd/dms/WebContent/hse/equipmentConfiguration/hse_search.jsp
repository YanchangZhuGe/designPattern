<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org").value;
		var second_org = document.getElementById("third_org").value;
		var third_org = document.getElementById("fourth_org").value; 
		var f_name = document.getElementById("f_name").value;  
		var v_day = document.getElementById("v_day").value;   
		var c_day = document.getElementById("c_day").value;   
		var a_time = document.getElementById("a_time").value;  
		var a_time2 = document.getElementById("a_time2").value;   
 
		var isProject = "<%=isProject%>";
		var sql = ""; 
		if(isProject=="1"){
			sql = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			sql = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select * from (select cn.equipment_no as pk_id,cn.facilities_name as f_name, nvl(cn.acquisition_time, cn.plan_acquisition_time) as a_time,cn.valid_time as v_time,(trunc(nvl(cn.valid_time, cn.plan_acquisition_time) - sysdate, 0)) v_day,"
				+"(trunc(nvl(cn.check_date, cn.plan_acquisition_time) - sysdate, 0)) c_day,case when (trunc(nvl(cn.valid_time, cn.plan_acquisition_time) - sysdate,0)) >= 30 then '' when (trunc(nvl(cn.valid_time, cn.plan_acquisition_time) - sysdate,0)) <= 0 then 'red' when (trunc(nvl(cn.check_date, cn.plan_acquisition_time) - sysdate,0)) >= 30 then '' when (trunc(nvl(cn.check_date, cn.plan_acquisition_time) - sysdate, 0)) < 0 then 'red' else 'orange' end color,"
   				+"cn.check_date as c_date,decode(cn.spare1, '2', '是') as if_type,cn.spare1,cn.bsflag,cn.org_sub_id,cn.second_org,cn.third_org,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,cn.project_no "
					+" from BGP_EQUIPMENT_CONFIGURATION cn left join comm_org_subjection os1 on cn.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'"
					+"  left join comm_org_subjection os2 on cn.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join  comm_org_subjection os3 on cn.org_sub_id = os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0'"
					+" where cn.bsflag = '0' union all	select tr.unplanned_no as pk_id,tr.facilities_name2 as f_name,tr.acquisition_time2 as a_time,tr.valid_time2 as v_time,(trunc(nvl(tr.valid_time2, sysdate) - sysdate, 0)) v_day,(trunc(nvl(tr.check_date2, sysdate) - sysdate, 0)) c_day,"
					+" case when (trunc(nvl(tr.valid_time2, sysdate) - sysdate, 0)) >= 30 then '' when (trunc(nvl(tr.valid_time2, sysdate) - sysdate, 0)) <= 0 then 'red' when (trunc(nvl(tr.check_date2, sysdate) - sysdate, 0)) >= 30 then '' when (trunc(nvl(tr.check_date2, sysdate) - sysdate, 0)) <= 0 then 'red' else 'orange' end color,"
					+" tr.check_date2 as c_date,decode(tr.spare1, '1', '否') as if_type,tr.spare1,tr.bsflag2,tr.org_sub_id,tr.second_org,tr.third_org,oi3.org_abbreviation as org_name,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,tr.project_no "
					+" from BGP_EQUIPMENT_UNPLANNED tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'"
					+" left join comm_org_subjection os3 on tr.org_sub_id=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag='0' where tr.bsflag2 = '0') tr where tr.bsflag='0' "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_sub_id = '"+org_sub_id+"'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		if(f_name!=''&&f_name!=null){
			sql = sql+" and tr.f_name  like '%"+f_name+"%'";
		}
		
		if(v_day!=''&&v_day!=null){
			sql = sql+" and tr.v_day >= '"+v_day+"'";
		}
		
		if(c_day!=''&&c_day!=null){
			sql = sql+" and tr.c_day >= '"+c_day+"'";
		}
 
 
		if(a_time!=''&&a_time!=null){
			sql = sql+" and tr.a_time >= to_date('"+a_time+"','yyyy-MM-dd')";
		}
		if(a_time2!=''&&a_time2!=null){
			sql = sql+" and tr.a_time <= to_date('"+a_time2+"','yyyy-MM-dd')";
		}
 
 
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
        <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
	    <td class="inquire_form6">
	    <input type="text" id="f_name" name="f_name" class="input_width"   />    					    
	    </td>	
        <td class="inquire_item6"><font color="red">*</font>临近有效期时间：</td>
	    <td class="inquire_form6">
	    <input type="text" id="v_day" name="v_day" class="input_width"   />    					    
	    </td>
        <td class="inquire_item6"><font color="red">*</font>临近校验日期时间：</td>
	    <td class="inquire_form6">
	    <input type="text" id="c_day" name="c_day" class="input_width"   />    					    
	    </td>
	    
        </tr>     
        <tr>
          <td class="inquire_item6">购置时间：</td>
		  <td class="inquire_form6"><input type="text" id="a_time" name="a_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(a_time,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="a_time2" name="a_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(a_time2,tributton2);" />&nbsp;</td>
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

