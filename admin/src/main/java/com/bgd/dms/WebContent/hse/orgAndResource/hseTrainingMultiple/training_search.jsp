<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String lead_type = request.getParameter("lead_type");

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
	var lead_type="<%=lead_type%>";
	function submit(){
		var ctt = top.frames('list');
		
		var second_org2 = document.getElementById("second_org2").value;
		var third_org2 = document.getElementById("third_org2").value;
		var train_object = document.getElementById("train_object").value;
		var train_address = document.getElementById("train_address").value;
		var project_name= document.getElementById("project_name").value;
		var train_time = document.getElementById("train_time").value;
		
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		var sql = "";
		if(retObj.flag!="false"){
			var len = retObj.list.length;
			if(len>0){
				if(retObj.list[0].organFlag!="0"){
					sql = " and t.second_org = '" + retObj.list[0].orgSubId +"'";
					if(len>1){
						if(retObj.list[1].organFlag!="0"){
							sql = " and t.third_org = '" + retObj.list[1].orgSubId +"'";
						}
					}
				}
			}
		}
		debugger;
		var sql = "select * from ((select tp.hse_plan_id,decode(tp.lead_type,'1','是','0','否') lead_type,tp.train_object,tp.train_address,oi.org_abbreviation second_org_name,oi1.org_abbreviation third_org_name,tp.project_name,tp.train_time,tp.second_org,tp.third_org,tp.bsflag,tp.modifi_date,1 flag,'' disasss from bgp_hse_train_plan tp left join comm_org_subjection os on tp.second_org=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' left join comm_org_subjection os1 on tp.third_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' where tp.bsflag='0') union all (select pn.train_plan_no,'否' lead_type,pn.train_object,train_address,oi1.org_abbreviation second_org_name,i.org_abbreviation,p.project_name,pn.train_cycle,os1.org_subjection_id second_org,os.org_subjection_id third_org,dl.bsflag,dl.modifi_date,2 flag,'disabled' disasss  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'left join gp_task_project p on pn.project_info_no = p.project_info_no and p.bsflag = '0' left join comm_org_information i on pn.spare1 = i.org_id and i.bsflag = '0' left join comm_org_subjection os on os.org_id = i.org_id and os.bsflag='0' left join comm_org_subjection os1 on os.father_org_id=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0'  where dl.bsflag='0' and dl.classification='2' )) t where t.bsflag='0' "+sql;
		if(second_org2!=''&&second_org2!=null){
			sql = sql+" and t.second_org_name like '%"+second_org2+"%'";
		}
		if(third_org2!=''&&third_org2!=null){
			sql = sql+" and t.third_org_name like '%"+third_org2+"%'";
		}
		if(train_object!=''&&train_object!=null){
			sql = sql+" and t.train_object like '%"+train_object+"%'";
		}
		if(train_address!=''&&train_address!=null){
			sql = sql+" and t.train_address like '%"+train_address+"%'";
		}
		if(project_name!=''&&project_name!=null){
			sql = sql+" and t.project_name like '%"+project_name+"%'";
		} 
		if(lead_type!='null'&& lead_type!=null){
			sql = sql+" and t.lead_type like '%是%'";
		}
		
		
		if(train_time!=''&&train_time!=null){
			sql = sql+" and t.train_timelike '%"+train_time+"%'";
		}
		sql = sql+" order by t.modifi_date desc";
		 
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
	     	<td class="inquire_item6">单位：</td>
	      	<td class="inquire_form6">
	      	<input type="text" id="second_org2" name="second_org2" class="input_width"  />
	      	</td>
	     	<td class="inquire_item6">基层单位：</td>
	      	<td class="inquire_form6">
	      	<input type="text" id="third_org2" name="third_org2" class="input_width" />
	      	</td>
	     </tr>
		 <tr>
	    	<td class="inquire_item6"><font color="red">*</font>培训对象：</td>
	      	<td class="inquire_form6"><input type="text" id="train_object" name="train_object" class="input_width"  value=""/></td>
	     	<td class="inquire_item6"><font color="red">*</font>培训地点：</td>
	      	<td class="inquire_form6"><input type="text" id="train_address" name="train_address" class="input_width"   value=""/></td>
	     </tr>
	     <tr>
	     	<td class="inquire_item6"><font color="red">*</font>项目名称：</td>
	      	<td class="inquire_form6"><input type="text" id="project_name" name="project_name" class="input_width" value=""/></td>
	    	<td class="inquire_item6"><font color="red">*</font>培训时间：</td>
	      	<td class="inquire_form6"><input type="text" id="train_time" name="train_time" class="input_width" value=""></input></td>
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

