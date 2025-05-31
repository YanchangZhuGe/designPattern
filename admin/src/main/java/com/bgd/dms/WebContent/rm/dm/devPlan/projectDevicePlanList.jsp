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
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script> 
<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>';

function page_init(){
	
	var projectInfoNo = "<%=projectInfoNo%>";	
	if(projectInfoNo!='null'){
		var querySql = "select team_name,dev_name,dev_model,unit_name,apply_num,purpose,plan_start_date,plan_end_date,"+
			"row_number() over(partition by team order by team,dev_name) as seqnum,"+
			"count(1) over(partition by team) as  totalnum "+
			"from "+ 
			"(select alldet.team,teamsd.coding_name as team_name, "+
			"alldet.dev_name,alldet.dev_type as dev_model, "+
			"unitsd.coding_name as unit_name,alldet.apply_num,"+
			"alldet.purpose,alldet.plan_start_date,alldet.plan_end_date "+
			"from gms_device_allapp_detail alldet  "+
			"left join comm_coding_sort_detail unitsd on alldet.unitinfo=unitsd.coding_code_id "+
			"left join comm_coding_sort_detail teamsd on alldet.team=teamsd.coding_code_id  "+
			"left join gms_device_codetype ct on alldet.dev_ci_code=ct.dev_ct_code  "+
			"left join gms_device_codeinfo ci on alldet.dev_ci_code=ci.dev_ci_code  "+
			"where alldet.project_info_no ='"+projectInfoNo+"' and alldet.bsflag = '0' "+
			"union all "+
			"select colldet.team,teamsd.coding_name as team_name,colldet.dev_name_input as dev_name,typesd.coding_name  as dev_model, "+
			"unitsd.coding_name as unit_name,colldet.apply_num,"+
			"colldet.purpose,colldet.plan_start_date,colldet.plan_end_date  "+
			"from gms_device_allapp_colldetail colldet  "+
			"left join comm_coding_sort_detail unitsd on colldet.unitinfo=unitsd.coding_code_id "+
			"left join comm_coding_sort_detail teamsd on colldet.team=teamsd.coding_code_id  "+
			"left join comm_coding_sort_detail typesd on colldet.dev_codetype=typesd.coding_code_id  "+
			"where colldet.project_info_no ='"+projectInfoNo+"' and colldet.bsflag = '0' "+
			") "+
			"order by team,dev_name ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+"&pageSize=1000");
		var datas = queryRet.datas;
		var firstflag = true;
		var showseq = 1;
		var oldseq = 1;
		if(queryRet.datas&&queryRet.datas.length>0){
			for (var i = 0;  i< queryRet.datas.length; i++) {
				
				var classodd = null,classeven = null;
				if(oldseq%2==0){
					classodd = "odd_odd";
					classeven = "odd_even";	
				}else{
					classodd = "even_odd";
					classeven = "even_even";	
				}
				var seqnum = parseInt(datas[i].seqnum,10);
				var totalnum = parseInt(datas[i].totalnum,10);
				var tr = document.getElementById("lineTable").insertRow();
				if(firstflag){
					var td = tr.insertCell();
					td.className=classodd;
					td.innerHTML = showseq;
					td.rowSpan = totalnum;
					showseq ++;
					var td = tr.insertCell();
					td.className=classeven;
					td.innerHTML = datas[i].team_name;
					td.rowSpan = totalnum;
					firstflag = false;
				}
				if(seqnum == totalnum){
					oldseq = showseq;
					firstflag = true;
				}
				if(i%2==0){
					classodd = "odd_odd";
					classeven = "odd_even";	
				}else{
					classodd = "even_odd";
					classeven = "even_even";	
				}
				var td = tr.insertCell();
				td.className=classodd;
				td.innerHTML = datas[i].dev_name;

				var td = tr.insertCell();
				td.className=classodd;
				td.innerHTML = datas[i].dev_model;
				
				var td = tr.insertCell();
				td.className=classeven;
				td.innerHTML = datas[i].unit_name;
				
				var td = tr.insertCell();
				td.className=classodd;
				td.innerHTML = datas[i].apply_num;
				
				var td = tr.insertCell();
				td.className=classeven;
				td.innerHTML = datas[i].purpose;
				
				var td = tr.insertCell();
				td.className=classodd;
				td.innerHTML = datas[i].plan_start_date;
				
				var td = tr.insertCell();
				td.className=classeven;
				td.innerHTML = datas[i].plan_end_date;
			}
		}
		var querySql2 = "select dev_name,dev_code,totalapply_num,"+
				" (select unitsd.coding_name "+
					"from comm_coding_sort_detail unitsd "+
	         		"where unitsd.coding_code_id = (select unitinfo from gms_device_allapp_detail ad "+ 
	         			"where ad.dev_ci_code=tmp.dev_code and ad.project_info_no='"+projectInfoNo+"' "+
	         			"and rownum = 1)) as unit_name "+
			" from ( "+
	         	"select dev_name,dev_code,sum(apply_num) as totalapply_num "+
				"from  "+
				"(select  "+
				"case when ct.dev_ct_name is null then ci.dev_ci_name else ct.dev_ct_name end as dev_name, "+
				"case when ct.dev_ct_code is null then substr(ci.dev_ci_code,1,length(ci.dev_ci_code)) else ct.dev_ct_code end as dev_code, "+
				"alldet.apply_num,alldet.approve_num  "+
				"from gms_device_allapp_detail alldet  "+
				"left join gms_device_codetype ct on alldet.dev_ci_code=ct.dev_ct_code  "+
				"left join gms_device_codeinfo ci on alldet.dev_ci_code=ci.dev_ci_code  "+
				"where alldet.project_info_no ='"+projectInfoNo+"' "+
				") "+
				"group by dev_name,dev_code order by dev_code)tmp";
		var queryRet2 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql2+"&pageSize=1000");
		var datas2 = queryRet2.datas;
		var showstr = "";
		if(queryRet2.datas&&queryRet2.datas.length>0){
			for (var i = 0;  i< queryRet2.datas.length; i++) {
				showstr += datas2[i].dev_name+datas2[i].totalapply_num+datas2[i].unit_name+";";
			}
			$("#str").text(showstr);
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
    	    <td class="bt_info_even" width="10%">班组</td>
    	    <!-- <td class="bt_info_odd" width="15%">设备类别</td> -->
    	    <td class="bt_info_odd" width="15%">设备名称</td>
    	    <td class="bt_info_odd" width="15%">规格型号</td>
    	    <td class="bt_info_even" width="10%">计量单位</td>
    	    <td class="bt_info_odd" width="10%">申请数量</td>
            <td class="bt_info_even" width="10%">备注</td>
    	    <td class="bt_info_odd" width="15%">预计进场时间</td>
    	    <td class="bt_info_even" width="15%">预计离场时间</td>
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
