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
 
		var contractor_name = document.getElementById("contractor_name").value;  
		var if_contractor_list = document.getElementById("if_contractor_list").value; 
		var acceptance_conclusion = document.getElementById("acceptance_conclusion").value; 
		var hse_points = document.getElementById("hse_points").value; 
		
		var training_start_time = document.getElementById("training_start_time").value;  
		var training_start_time2 = document.getElementById("training_start_time2").value;   
		
		var training_end_time = document.getElementById("training_end_time").value;  
		var training_end_time2 = document.getElementById("training_end_time2").value; 
		
		var check_time = document.getElementById("check_time").value;  
		var check_time2 = document.getElementById("check_time2").value; 
		
		var examination_time = document.getElementById("examination_time").value;  
		var examination_time2 = document.getElementById("examination_time2").value; 
 
		var isProject = "<%=isProject%>";
		var sql = ""; 
		if(isProject=="1"){
			sql = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			sql = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = " select tr.check_time,tr.check_content,tr.check_people,nvl(tr.number_problems,'0') number_problems,  tr.org_sub_id, tr.cinspection_no,tr.contractor_name,tr.if_contractor_list,tr.certificates,tr.hse_organization,tr.personnel,tr.equipment,tr.labor_articles,tr.acceptance_conclusion, nvl(to_char(tr.training_start_time,'yyyy-MM-dd'),'--') || ' 至 '|| nvl(to_char(tr.training_end_time,'yyyy-MM-DD'),'--') as training_time,tr.school,tr.training_content,tr.participation,tr.summary,tr.examination_time,tr.assessment_unit,tr.assessment_people,tr.hse_contract_situation,tr.hse_points,tr.problems_and_deficiency ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CONTRACTOR_INSPECTION tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'   left join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0'   "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_sub_id = '"+org_sub_id+"'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		if(contractor_name!=''&&contractor_name!=null){
			sql = sql+" and tr.contractor_name  like  '%"+contractor_name+"%'";
		}
		
		if(if_contractor_list!=''&&if_contractor_list!=null){
			sql = sql+" and tr.if_contractor_list = '"+if_contractor_list+"'";
		}
		if(acceptance_conclusion!=''&&acceptance_conclusion!=null){
			sql = sql+" and tr.acceptance_conclusion = '"+acceptance_conclusion+"'";
		}	
		if(hse_points!=''&&hse_points!=null){
			sql = sql+" and tr.hse_points >= '"+hse_points+"'";
		}
		
		
		if(training_start_time!=''&&training_start_time!=null){
			sql = sql+" and tr.training_start_time >= to_date('"+training_start_time+"','yyyy-MM-dd')";
		}
		if(training_start_time2!=''&&training_start_time2!=null){
			sql = sql+" and tr.training_start_time <= to_date('"+training_start_time2+"','yyyy-MM-dd')";
		}
		if(training_end_time!=''&&training_end_time!=null){
			sql = sql+" and tr.training_end_time >= to_date('"+training_end_time+"','yyyy-MM-dd')";
		}
		if(training_end_time2!=''&&training_end_time2!=null){
			sql = sql+" and tr.training_end_time <= to_date('"+training_end_time2+"','yyyy-MM-dd')";
		}
		if(check_time!=''&&check_time!=null){
			sql = sql+" and tr.check_time >= to_date('"+check_time+"','yyyy-MM-dd')";
		}
		if(check_time2!=''&&check_time2!=null){
			sql = sql+" and tr.check_time <= to_date('"+check_time2+"','yyyy-MM-dd')";
		}
		if(examination_time!=''&&examination_time!=null){
			sql = sql+" and tr.examination_time >= to_date('"+examination_time+"','yyyy-MM-dd')";
		}
		if(examination_time2!=''&&examination_time2!=null){
			sql = sql+" and tr.examination_time <= to_date('"+examination_time2+"','yyyy-MM-dd')";
		}
		
		sql = sql+" order by tr.modifi_date desc";
 
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
	
	function selectTeam1(){		
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById("project_id").value = teamInfo.fkValue;
	        document.getElementById("project_name").value = teamInfo.value;
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
        <td class="inquire_item6">承包商名称：</td>
	    <td class="inquire_form6">
	    <input type="text" id="contractor_name" name="contractor_name" class="input_width"  onblur="onblurS()"  />    					    
	    </td>	
	    <td class="inquire_item6"> 是否承包商名录</td>
	    <td class="inquire_form6" > 
	    <select id="if_contractor_list" name="if_contractor_list" class="select_width">
	       <option value="" >请选择</option>
	       <option value="是" >是</option>
	       <option value="否" >否</option>
		</select>					
	    </td>
	    <td class="inquire_item6">验收结论：</td>
	    <td class="inquire_form6">
	    <select id="acceptance_conclusion" name="acceptance_conclusion" class="select_width">
	       <option value="" >请选择</option> 
	       <option value="1" >一次通过</option>
	       <option value="2" >二次通过</option>
	       <option value="3" >三次通过</option>
	       <option value="4" >未通过</option>
		</select>  	  		
	    </td>
	    
        </tr>     
        <tr>
        <td class="inquire_item6">HSE综合得分：</td>
	    <td class="inquire_form6">
	    <input type="text" id="hse_points" name="hse_points" class="input_width"   />    		
	    </td>
          <td class="inquire_item6">培训开始时间：</td>
		  <td class="inquire_form6"><input type="text" id="training_start_time" name="training_start_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(training_start_time,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="training_start_time2" name="training_start_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(training_start_time2,tributton2);" />&nbsp;</td>
        </tr>
        
        <tr> 
          <td class="inquire_item6">培训结束时间：</td>
		  <td class="inquire_form6"><input type="text" id="training_end_time" name="training_end_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(training_end_time,tributton3);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="training_end_time2" name="training_end_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(training_end_time2,tributton4);" />&nbsp;</td>
        </tr>
        <tr> 
        <td class="inquire_item6">检查时间：</td>
		  <td class="inquire_form6"><input type="text" id="check_time" name="check_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_time,tributton5);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="check_time2" name="check_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_time2,tributton6);" />&nbsp;</td>
      </tr>
      <tr> 
      <td class="inquire_item6">考核时间：</td>
		  <td class="inquire_form6"><input type="text" id="examination_time" name="examination_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton7" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(examination_time,tributton7);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="examination_time2" name="examination_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton8" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(examination_time2,tributton8);" />&nbsp;</td>
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

