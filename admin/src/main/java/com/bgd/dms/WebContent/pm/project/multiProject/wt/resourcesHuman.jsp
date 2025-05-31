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
	String projectName=request.getParameter("projectName")==null?"":request.getParameter("projectName");
	projectName=java.net.URLDecoder.decode(projectName,"utf-8");
	String projectType = request.getParameter("projectType")==null?"":request.getParameter("projectType");
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>人员配置</title> 
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
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>&nbsp;&nbsp;</td>
				<%if(!"view".equals(action)){%>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			     <tr>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{plan_detail_id}' id='rdo_entity_id_{plan_detail_id}'  onclick='chooseOne(this);' />" >选择</td>
			      	<td class="bt_info_odd" exp="{apply_team_name}">班组</td>
			      	<td class="bt_info_even" exp="{post_name}">岗位</td>
			      	<td class="bt_info_odd" exp="{people_number}">计划人数<span id="people_number"></span></td>
			      	<td class="bt_info_odd" exp="{notes}">备注</td>
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
	var projectName="<%=projectName%>";
	var projectType="<%=projectType%>";
	var proc_status = "";
	
	function refreshData(){
		var querySql = "select r.proc_status from bgp_comm_human_plan p left join common_busi_wf_middle r on p.plan_id=r.business_id and r.bsflag='0' where p.bsflag='0'  and p.spare1 is null  and  p.project_info_no='"+projectInfoNo+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;

		if(null!=datas&&datas.length>0){
			proc_status = datas[0].proc_status;
		}

		//计算合计人数
		var querySql1 = "select sum(nvl(d.people_number, 0)) people_number from bgp_comm_human_plan_detail d "+
			"where d.spare1 is null  and d.project_info_no='"+projectInfoNo+"' and d.bsflag='0' and d.resourceflag='0' ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql1);
		var datas1 = queryRet1.datas;
		if(null!=datas1&&datas1.length>0){
			$("#people_number").append(datas1[0].people_number==""?"":("(共"+datas1[0].people_number+"人)"));
		}
		
		cruConfig.queryStr = "select d.plan_detail_id,d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums,d.notes "+
			"from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' "+
			"left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' "+
			"where d.spare1 is null  and d.project_info_no='"+projectInfoNo+"' and d.bsflag='0' and d.resourceflag='0'";
		queryData(1);
	}

	function toAdd(){
		popWindow('<%=contextPath%>/rm/em/planning/add_planning.jsp?projectInfoNo=<%=projectInfoNo%>&projectType=<%=projectType%>&resourceFlag=0','1000:800');
	}

	function toEdit() {
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/rm/em/planning/add_planning.jsp?projectInfoNo=<%=projectInfoNo%>&projectType=<%=projectType%>&resourceFlag=0&id='+ids,'1000:800');
	}
	
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
		if (!window.confirm("确认要删除吗?")) {
			return;
		}

		var sql = "update bgp_comm_human_plan_detail t set t.bsflag='1' where t.plan_detail_id ='"+ids+"' ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();
	}

    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }  
</script>
<script type="text/javascript" src="<%=contextPath%>/common/applyTeam.js"></script>
</body>
</html>