<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String projectInfoNo = request.getParameter("projectInfoNo");
    if(projectInfoNo == null || "".equals(projectInfoNo)){
    	projectInfoNo = user.getProjectInfoNo();
    }
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>';


function addLine(apply_team_names,post_names,people_numbers){
	
	var apply_team_name = "";
	var post_name = "";
	var people_number = "";

	if(apply_team_names != null && apply_team_names != ""){
		apply_team_name=apply_team_names;
	}
	if(post_names != null && post_names != ""){
		post_name=post_names;
	}
	if(people_numbers != null && people_numbers != ""){
		people_number=people_numbers;
	}

	
	var rowNum = document.getElementById("equipmentSize").value;	
	var tr = document.getElementById("lineTable").insertRow();
	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}	


	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = (parseInt(rowNum) + 1);
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = apply_team_name;
	
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = post_name;
		
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = people_number;
			
	document.getElementById("equipmentSize").value = (parseInt(rowNum) + 1);

}

function page_init(){
	
	var projectInfoNo = "<%=projectInfoNo%>";	
	if(projectInfoNo!='null'){
		var querySql = "select t.*,rownum from ( select p.apply_team_name, p.apply_team,sum(nvl(p.people_number, 0)) people_number from (select d.apply_team, s1.coding_name apply_team_name, d.people_number from bgp_comm_human_plan_detail d left join comm_coding_sort_detail s1  on d.apply_team = s1.coding_code_id and s1.bsflag = '0' left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id  and s2.bsflag = '0' where d.project_info_no = '"+projectInfoNo+"' and d.spare1 is null   and d.bsflag = '0') p  group by p.apply_team_name, p.apply_team order by p.apply_team ) t ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		var querySql1 = "select p.apply_team_name, p.post_name,p.apply_team, p.post,sum(nvl(p.people_number,0)) people_number from ( select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,d.people_number from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' where d.project_info_no='"+projectInfoNo+"'  and d.spare1 is null  and d.bsflag='0' ) p group by p.apply_team_name,p.post_name ,p.apply_team, p.post  ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		var querySql2 = "select '合同化（' || n1 || '）人;' || '市场化（' || n2 || '）人; 临时工（' || n3 || '）人;劳务用工（' || n4 || '）人;再就业（' || n5 || '）人;'  str from ( select sum(decode(t.employee_gz,'0110000019000000001',t.gz_num,0)) n1,  sum(decode(t.employee_gz,'0110000019000000002',t.gz_num,0)) n2, sum(decode(t.employee_gz,'0110000059000000005',t.gz_num,0)) n3,  sum(decode(t.employee_gz,'0110000059000000003',t.gz_num,0)) n4,  sum(decode(t.employee_gz,'0110000059000000001',t.gz_num,0)) n5  from ( select c.project_info_no, t.gz_num,t.employee_gz, d.coding_name employee_gz_name   from bgp_comm_human_cost_plan_deta t   left join comm_coding_sort_detail d   on t.employee_gz = d.coding_code_id   left join bgp_comm_human_plan_cost c   on t.plan_id = c.plan_id    and c.bsflag = '0'  where c.project_info_no='"+projectInfoNo+"'  and c.cost_state='1'  ) t ) ";
		var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql2);
		var datas2 = queryRet2.datas;
		
		for (var i = 0;  i< queryRet.datas.length; i++) {	
			
			var tr = document.getElementById("lineTable").insertRow();
			
			if(i % 2 == 1){  
		  		classCss = "even_";
			}else{ 
				classCss = "odd_";
			}	

			var td = tr.insertCell(0);
			td.className=classCss+"odd";
			td.innerHTML = parseInt(datas[i].rownum);
			
			var td = tr.insertCell(1);
			td.className=classCss+"even";
			td.innerHTML = datas[i].apply_team_name;
			
			var td = tr.insertCell(2);
			td.className=classCss+"odd";
			td.innerHTML = datas[i].people_number;
			
			var apply_team = datas[i].apply_team;

			var td3="";
			var td4="";
			
			for(var j = 0; j < queryRet1.datas.length; j++){
				td3+="<table>";
				td4+="<table>";
				if(datas1[j].apply_team == apply_team){
					td3 += "<tr><td>";
					td3 += datas1[j].post_name;
					td3 += "</td></tr>";
					
					td4 += "<tr><td>";
					td4 += datas1[j].people_number;
					td4 += "</td></tr>";
					
				}
				td3+="</table>";
				td4+="</table>";
			}
						
			var td = tr.insertCell(3);
			td.className=classCss+"even";
			td.innerHTML = td3;
							
			var td = tr.insertCell(4);
			td.className=classCss+"odd";
			td.innerHTML = td4;


		}	
		
		
		if(datas2 != null){
			var str = document.getElementById("str");
			str.innerHTML = datas2[0].str;
		}
	}

}
</script>  
</head>
<body onload="page_init()" style="overflow-y:auto" >
<form id="CheckForm" action="" method="post" target="list" >
    
	<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
	<input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>"/>	
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="5%">序号</td>
    	    <td class="bt_info_even" width="20%">班组</td>
    	    <td class="bt_info_even" width="10%">人数</td>
    	    <td class="bt_info_odd" width="20%">岗位</td>
            <td class="bt_info_even"  width="10%">人数</td>
        </tr>  
    </table>	

		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" style="margin-top:2px;height:80px;">
			<tr>
				<td align="right">
				其中：<span id="str"></span>
				</td>
			</tr>
		</table>
	</div>
</form>
</body>
</html>
