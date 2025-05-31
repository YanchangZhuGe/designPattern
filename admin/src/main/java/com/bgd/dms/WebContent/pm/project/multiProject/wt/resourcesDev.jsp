<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	String	projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	
	String idinfo = request.getParameter("idinfo")==null?"":request.getParameter("idinfo");
	//String taskObjectId = request.getParameter("taskObjectId")==null?"":request.getParameter("taskObjectId");
	//String taskName = request.getParameter("taskName")==null?"":java.net.URLDecoder.decode(request.getParameter("taskName"),"utf-8");
	
	//点击节点的类型 1 root 2 wbs 3 叶子节点
	String teamtype="1";
	//action=="view" 审批页面
	String action = request.getParameter("action")==null?"":request.getParameter("action");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>设备配置</title> 
<script language="javaScript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.7);
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

$(document).ready(lashen);
</script>
</head> 
 
<body style="background:#fff" onload="refreshData();">
	<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			    <td>&nbsp;</td>
			    <%if(!"view".equals(action)){%>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddPage()'" title="添加"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <%}%>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
			</table>
			</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_allapp_detid}~{seqinfo}' id='selectedbox_{device_allapp_detid}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_odd" exp="{unitname}">单位</td>
					<td class="bt_info_even" exp="{apply_num}">需求数量</td>
					<td class="bt_info_odd" exp="{purpose}">备注</td> 
					<!--<td class="bt_info_odd" exp="{state_desc}">审批状态</td>
					<td class="bt_info_even" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_odd" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_even" exp="{managetype}" isExport='Hide'>设备管理类别</td>
					<td class="bt_info_even" exp="{oper_state}">处理状态</td>-->
			     </tr> 
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到 
				      <label>
				        <input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
			</table>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo ="<%=projectInfoNo%>";
	var idinfo="<%=idinfo%>"; //计划的id
	
	function refreshData(){
		str = "select devappid.* from ("
			str += "select alldet.device_allapp_detid,devapp.device_allapp_id,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
			str += "alldet.dev_ci_code,";
			str += "( case alldet.teamtype when 1 then  (select bpp.project_name  from bgp_p6_project bpp where bpp.object_id= alldet.teamid) when 2 then (select bpp.name  from bgp_p6_project_wbs bpp where bpp.object_id= alldet.teamid) when 3 then (select bpp.name  from bgp_p6_activity bpp where bpp.object_id= alldet.teamid) else '' end) as jobname,";
			str += "pro.project_name,";
			str += "alldet.dev_name as dev_ci_name,";
			str += "alldet.dev_type as dev_ci_model, ";
			str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
			str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
			str += "alldet.plan_start_date,alldet.plan_end_date,'单台管理' as managetype,case when alldet.oper_state='pass' then '已处理' else'未处理' end as oper_state,'0' as seqinfo  ";
			str += "from gms_device_allapp_detail alldet ";
			str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
			str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
			str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
			str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
			str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
			str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
			str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				if(""==idinfo){
					str += "where devapp.project_info_no = '"+projectInfoNo+"' and devapp.bsflag = '0' ";
				}else{
					str += "where devapp.device_allapp_id = '"+idinfo+"' and alldet.bsflag='0' ";
				}
			//str += "and alldet.resourceflag='0' and alldet.device_addapp_id is null ";	
			str += "and alldet.device_addapp_id is null ";
			str += "union "
			str += "select alldet.device_allapp_detid,devapp.device_allapp_id,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
			str += "'' as dev_ci_code,p6.name as jobname,pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
			str += "alldet.apply_num,alldet.approve_num,alldet.teamid,alldet.team, ";
			str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
			str += "alldet.plan_start_date,alldet.plan_end_date,'批量管理' as managetype,case when alldet.oper_state='pass' then '已处理' else'未处理' end as oper_state,'1' as seqinfo  ";
			str += "from gms_device_allapp_colldetail alldet ";
			str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
			str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
			str += "left join comm_coding_sort_detail devtype on alldet.dev_codetype = devtype.coding_code_id ";
			str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
			str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
			str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
			str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
			if(""==idinfo){
				str += "where devapp.project_info_no = '"+projectInfoNo+"' and devapp.bsflag = '0' ";
			}else{
				str += "where devapp.device_allapp_id = '"+idinfo+"' and alldet.bsflag='0' ";
			}
			str += "and alldet.device_addapp_id is null ";
			//str += "and alldet.resourceflag='0' and alldet.device_addapp_id is null ";
			str += ")devappid  order by seqinfo,team";
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
	}


	function toAddPage(){
		popWindow("<%=contextPath%>/pm/project/multiProject/wt/dev_add.jsp?teamtype=<%=teamtype%>&resourceFlag=0&projectInfoNo="+projectInfoNo+"&deviceallappid="+idinfo,"900:680");
	}

    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }  

    function toDelRecord(){
		var length = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("一共选择了"+length+"条记录，是否执行删除？")){
			var selectedid = "";
			var checkindex = 0;
			$("input[type='checkbox'][name='selectedbox']").each(function(i){
				if(this.checked == true){
					if(checkindex!=0){
						selectedid += ",";
					}
					selectedid += "'"+this.value.split("~",-1)[0]+"'";
					checkindex ++;
				}
			});
			var sql="";
			var getsql = "select * from gms_device_allapp_detail t where t.device_allapp_detid in ("+selectedid+")";
			var retDatas = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+getsql);
			if(retDatas.datas != ""){
				sql = "update gms_device_allapp_detail set bsflag='1' where device_allapp_detid in ("+selectedid+")";
			}
			else{
				sql = "update gms_device_allapp_colldetail set bsflag='1' where device_allapp_detid in ("+selectedid+")";
				}
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}

    //打开修改界面
	function toModifyPage(){
		var length = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				length = length+1;
			}
		});
		if(length!=1){
			alert("请选择一条记录！");
			return;
		}
		var selectedid = null;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				selectedid = this.value;
			}
		});
		popWindow("<%=contextPath%>/pm/project/multiProject/wt/dev_modify.jsp?projectType=<%=projectType%>&teamtype=<%=teamtype%>&deviceallappid="+idinfo+"&resourceFlag=0&deviceallappdetid="+selectedid,"900:680");
	}
</script>
</body>
</html>