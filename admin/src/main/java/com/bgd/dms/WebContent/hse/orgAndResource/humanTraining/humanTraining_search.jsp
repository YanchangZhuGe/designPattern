<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">

	function submit(){
		var ctt = top.frames('list');
		var isProject="<%=isProject%>";
		 var sqlA="";
			if(isProject==2){
				sqlA="  and pn.project_info_no='<%=projectInfoNo%>' ";
			}
			
		var project_name = document.getElementById("project_name").value;
		var org_abbreviation = document.getElementById("org_abbreviation").value;
		var train_cycle = document.getElementById("train_cycle").value;  

		var sql = "select dl.train_detail_no,pn.train_object,train_address,p.project_name,i.org_abbreviation,pn.train_cycle,dl.train_content  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'left join gp_task_project p on pn.project_info_no = p.project_info_no and p.bsflag = '0' left join comm_org_information i on pn.spare1 = i.org_id and i.bsflag = '0'  where dl.bsflag='0' and (dl.classification = '2' or　dl.classification = '4')";
		if(project_name!=''&&project_name!=null){
			sql = sql+" and p.project_name like '%"+project_name+"%'";
		}
		if(org_abbreviation!=''&&org_abbreviation!=null){
			sql = sql+" and i.org_abbreviation like '%"+org_abbreviation+"%'";
		}
		if(train_cycle!=''&&train_cycle!=null){
			sql = sql+" and pn.train_cycle like '%"+train_cycle+"%'";
		}
		sql = sql+sqlA+" order by dl.create_date desc";
		
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
	    if(second==""||second==null){
	    	alert("请先选择二级单位！");
	    }else{
		    var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				var org_id = datas[0].org_id; 
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
			    }
			}
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
	        <td class="inquire_item6">项目名称：</td>
	      	<td class="inquire_form6">
	      	<input type="text" id="project_name" name="project_name" class="input_width" /></td>
	     	<td class="inquire_item6">施工队伍：</td>
	      	<td class="inquire_form6">
	      	<input type="text" id="org_abbreviation" name="org_abbreviation" class="input_width" /></td>
          <td class="inquire_item6">培训时间:</td>
          <td class="inquire_form6"><input type="text" id="train_cycle" name="train_cycle" value=""></input></td>
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

