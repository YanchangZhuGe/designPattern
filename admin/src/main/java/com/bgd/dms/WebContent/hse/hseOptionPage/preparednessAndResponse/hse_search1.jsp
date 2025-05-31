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
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
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
var isProject="<%=isProject%>";
var orgSubId="<%=orgSubId%>";
	function submit(){
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org2").value;
		var second_org = document.getElementById("third_org2").value;
 
		
		var supplies_name = document.getElementById("supplies_name").value;  
		var supplies_category = document.getElementById("supplies_category").value;   
		var valid_until = document.getElementById("valid_until").value;   
		var check_period_until = document.getElementById("check_period_until").value;   
		var appearance = document.getElementById("appearance").value;   
		var identification = document.getElementById("identification").value;   
		var m_performance = document.getElementById("m_performance").value;   
		
		var acquisition_time = document.getElementById("acquisition_time").value;  
		var acquisition_time2 = document.getElementById("acquisition_time2").value;   
		
		var check_time = document.getElementById("check_time").value;  
		var check_time2 = document.getElementById("check_time2").value;   
		
		var rectification_time = document.getElementById("rectification_time").value;  
		var rectification_time2 = document.getElementById("rectification_time2").value;  
 
		
		var sql = "";  
		if(isProject=="1"){
			
			var querySqlAdd = getMultipleSql2("tr.");
			sql = "   select *  from (  select  '1' if_show, tr.bsflag,  tr.emergency_no,       tr.supplies_name,       tr.unit_measurement,       tr.quantity,       decode(tr.appearance, '1', '完好', '2', '不完好') appearance,   tr.identification,    decode(tr.identification, '1', '符合', '2', '不符合') identification_s,       decode(tr.performance_s, '1', '有效', '2', '失效') performance_s,       tr.testing_time,       tr.corrective_completiontime,       tr.supplies_category,       tr.model_num,       tr.acquisition_time,       (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) v_day,       (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) c_day,       case         when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) >= 30 then       ''       when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) <= 0 then       'red'       when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       tr.storage_location,       tr.the_depository,        ion.org_abbreviation as org_name,       oi1.org_abbreviation as second_org_name  from BGP_EMERGENCY_STANDBOOK tr  left join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0'   "+querySqlAdd+ 
					" union " +
					" select  '2' if_show,w.bsflag,   w.RECYCLEMAT_INFO      as emergency_no,   g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance, ein.identification,    decode(ein.identification, '1', '符合', '2', '不符合') identification_s,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,             ai.org_abbreviation as org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_recyclemat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.RECYCLEMAT_INFO  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'    left join comm_org_information ai   on w.org_id = ai.org_id   and ai.bsflag = '0'  where g.coding_code_id like '45%'  and  w.ORG_SUBJECTION_ID like'%"+orgSubId+"%' ) tr    where   tr.bsflag='0'";
			
		 
		}else if(isProject=="2"){
			sql = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		    sql = "  select *  from (  select  '1' if_show,  tr.project_no,   tr.appearance as i_param, tr.identification as i_params, tr.performance_s as i_parames, tr.emergency_no,tr.acquisition_time as g_time,   tr.org_sub_id,  tr.second_org,tr.third_org,   tr.supplies_name,       tr.unit_measurement,       tr.quantity,       decode(tr.appearance, '1', '完好', '2', '不完好') appearance,   tr.identification,    decode(tr.identification, '1', '符合', '2', '不符合') identification_s,       decode(tr.performance_s, '1', '有效', '2', '失效') performance_s,       tr.testing_time,       tr.corrective_completiontime,       tr.supplies_category,       tr.model_num,       tr.acquisition_time,       (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) v_day,       (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) c_day,       case         when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) >= 30 then       ''       when (trunc(nvl(tr.valid_until, sysdate) - sysdate, 0)) <= 0 then       'red'       when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(tr.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       tr.storage_location,       tr.the_depository,    tr.bsflag,       ion.org_abbreviation as org_name,       oi1.org_abbreviation as second_org_name  from BGP_EMERGENCY_STANDBOOK tr  left join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0' "+
				"  union " +
				"   select  '2' if_show,w.project_info_no as project_no,   ein.appearance as i_param,  ein.identification as i_params,    ein.performance_s as i_parames, w.teammat_info_id   as emergency_no,ein.acquisition_time as g_time,os2.org_subjection_id  as org_sub_id,os2.org_id as second_org ,os2.org_id as third_org ,   g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance, ein.identification,    decode(ein.identification, '1', '符合', '2', '不符合') identification_s,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,       w.bsflag,         ai.org_abbreviation as org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_teammat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.teammat_info_id  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_information ai   on w.org_id = ai.org_id   and ai.bsflag = '0'  where g.coding_code_id like '45%'   ) tr  " +
				"  where   tr.bsflag='0' " + sql;
		}
		

 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_name like '%"+org_sub_id+"%'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org_name like '%"+second_org+"%'";
		}
 
		
		if(supplies_name!=''&&supplies_name!=null){
			sql = sql+" and tr.supplies_name like '%"+supplies_name+"%'";
		}
		if(supplies_category!=''&&supplies_category!=null){
			sql = sql+" and tr.supplies_category = '"+supplies_category+"'";
		}	
		if(valid_until!=''&&valid_until!=null){
			sql = sql+" and tr.v_day = '"+valid_until+"'";
		}
		if(check_period_until!=''&&check_period_until!=null){
			sql = sql+" and tr.c_day >= '"+check_period_until+"'";
			
		}
	
		if(appearance!=''&&appearance!=null){
			sql = sql+" and tr.i_param = '"+appearance+"'";
		}
		if(identification!=''&&identification!=null){
			sql = sql+" and tr.i_params = '"+identification+"'";
		}
		if(m_performance!=''&&m_performance!=null){
			sql = sql+" and tr.i_parames = '"+m_performance+"'";
		}
		 
		
		if(acquisition_time!=''&&acquisition_time!=null){
			sql = sql+" and tr.g_time >= to_date('"+acquisition_time+"','yyyy-MM-dd')";
		}
		if(acquisition_time2!=''&&acquisition_time2!=null){
			sql = sql+" and tr.g_time <= to_date('"+acquisition_time2+"','yyyy-MM-dd')";
		} 
		if(check_time!=''&&check_time!=null){
			sql = sql+" and tr.testing_time >= to_date('"+check_time+"','yyyy-MM-dd')";
		}
		if(check_time2!=''&&check_time2!=null){
			sql = sql+" and tr.testing_time <= to_date('"+check_time2+"','yyyy-MM-dd')";
		} 
		
		if(rectification_time!=''&&rectification_time!=null){
			sql = sql+" and tr.corrective_completiontime >= to_date('"+rectification_time+"','yyyy-MM-dd')";
		}
		if(rectification_time2!=''&&rectification_time2!=null){
			sql = sql+" and tr.corrective_completiontime <= to_date('"+rectification_time2+"','yyyy-MM-dd')";
		} 
     	top.frames('list').frames[0].refreshData2(sql);	
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
	      
        </tr>
        <tr>
    	    <td class="inquire_item6">物资名称：</td>
		    <td class="inquire_form6">
		    <input type="text" id="supplies_name" name="supplies_name" class="input_width" />
		    </td>
		    <td class="inquire_item6">物资类别：</td>
		    <td class="inquire_form6">
		    <select id="supplies_category" name="supplies_category" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >人身防护</option>
		       <option value="2" >医疗急救</option>
		       <option value="3" >消防救援</option>
		       <option value="4" >防洪防汛</option>
		       <option value="5" >应急照明</option>
		       <option value="6" >交通运输</option>
		       <option value="7" >通讯联络</option>
		       <option value="8" >检测监测</option>
		       <option value="9" >工程抢险</option>
		       <option value="10" >剪切破拆</option>
		       <option value="11" >电力抢修</option>
		       <option value="12" >其他</option>
			</select> 
		    </td>   
		    <td class="inquire_item6">有效期截止至：</td>
		    <td class="inquire_form6">
		    <input type="text" style="width:80px;" id="valid_until" name="valid_until" class="input_width"    /> （数字）
		    </td>
		    
        </tr>  
        
        <tr>
        <td class="inquire_item6">校验期截止至：</td>
	    <td class="inquire_form6">
	    <input type="text" id="check_period_until"  style="width:80px;" name="check_period_until" class="input_width"    /> 	  （数字）  
	    </td>
	       <td class="inquire_item6">外观：</td>
		   <td class="inquire_form6">
		    <select  style="width:100px;"  name="appearance" id="appearance"  >
		    <option value="">请选择</option>
		    <option value="1" >完好</option>
		    <option value="2">不完好</option></select>
	        </td>
		       <td class="inquire_item6">标识：</td>
			   <td class="inquire_form6">
			   <select  style="width:100px;"  name="identification" id="identification"  >
			   <option value="">请选择</option><option value="1" >符合</option><option value="2">不符合</option></select>
		        </td>
	    </tr> 
	    
	    <tr>
	       <td class="inquire_item6">性能：</td>
		   <td class="inquire_form6">
		   <select  style="width:100px;"  name="m_performance" id="m_performance"  >
		   <option value="">请选择</option><option value="1" >有效</option><option value="2">失效</option></select>
	        </td>
	        
	        <td class="inquire_item6">购置时间：</td>
			  <td class="inquire_form6"><input type="text" id="acquisition_time" name="acquisition_time" class="input_width" readonly="readonly"/>
			  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time,tributton1);" />&nbsp;</td>
			  <td class="inquire_item6">至</td>
			  <td class="inquire_form6"><input type="text" id="acquisition_time2" name="acquisition_time2" class="input_width" readonly="readonly"/>
			  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time2,tributton2);" />&nbsp;
			  </td>
	       
	    </tr> 
	    
        <tr>    
		       <td class="inquire_item6">检查时间：</td>
				  <td class="inquire_form6"><input type="text" id="check_time" name="check_time" class="input_width" readonly="readonly"/>
				  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_time,tributton3);" />&nbsp;</td>
				  <td class="inquire_item6">至</td>
				  <td class="inquire_form6"><input type="text" id="check_time2" name="check_time2" class="input_width" readonly="readonly"/>
				  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_time2,tributton4);" />&nbsp;
				  </td>
				  
		  </tr>
		   <tr>    
	       <td class="inquire_item6">整改完成时间：</td>
			  <td class="inquire_form6"><input type="text" id="rectification_time" name="rectification_time" class="input_width" readonly="readonly"/>
			  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_time,tributton5);" />&nbsp;</td>
			  <td class="inquire_item6">至</td>
			  <td class="inquire_form6"><input type="text" id="rectification_time2" name="rectification_time2" class="input_width" readonly="readonly"/>
			  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_time2,tributton6);" />&nbsp;
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

