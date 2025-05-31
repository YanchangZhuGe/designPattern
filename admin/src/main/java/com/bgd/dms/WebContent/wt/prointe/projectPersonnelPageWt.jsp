<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = (String)user.getOrgId();
	String org_subjection_id = (String)user.getSubOrgIDofAffordOrg();
	String user_id = (String)user.getUserId();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);

	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" >
cruConfig.contextPath =  "<%=contextPath%>";

function chooseOne(cb){   
    var obj = document.getElementsByName("rdo_entity_id");   
    for (i=0; i<obj.length; i++){   
        if (obj[i]!=cb) obj[i].checked = false;   
        else obj[i].checked = true;   
    }   
}   
function toadd(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 2){
    	alert("请只选中一条记录");
    	return;
    }
    var info = ids.split("~");
  	popWindow("<%=contextPath%>/wt/prointe/projectPersonnelEditWt.jsp?project_info_id="+info[0]+"&project_name="+encodeURI(encodeURI(info[1],'UTF-8'),'UTF-8'));         
}
function toEdit(){
    ids = getSelIds('chk_entity_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
 		return;
	}	
    if(ids.split(":").length > 4){
    	alert("请只选中一条记录");
    	return;
    }
   
    var file_id = ids.split(":")[0];
    var pro = ids.split(":")[2];
    if(pro=='待审批'||pro=='审批通过'){
		alert("已提交流程不可修改！");
    }else{
      	popWindow('<%=contextPath%>/common/commonFile/commonAddOrModifyFile.jsp?');         
    }
}


function refreshData(){
	var str="select p.PROJECT_NAME,p.PROJECT_INFO_NO,p.PROJECT_ID,p.CREATE_DATE ,emp.EMPLOYEE_NAME   "
		+"from GP_TASK_PROJECT p "
		+"left join COMMON_BUSI_WF_MIDDLE wf on wf.BUSINESS_ID=p.PROJECT_INFO_NO and wf.BSFLAG='0' "
		+"left join GP_OPS_PROINTE_PROJPERSON_WT pp on pp.PROJECT_INFO_NO=p.PROJECT_INFO_NO and pp.BSFLAG='0' and pp.POSITION='5110000143000000002'"
		+"left join COMM_HUMAN_EMPLOYEE emp on emp.EMPLOYEE_ID=pp.PERSONNEL_ID and emp.BSFLAG='0'"
		+"where p.PROJECT_TYPE='5000100004000000009' and (p.PROJECT_BUSINESS_TYPE  like '%5000100011000000002@%' or p.PROJECT_BUSINESS_TYPE  like '%5000100011000000003@%') and p.BSFLAG='0' ";
	cruConfig.queryStr = str;
	queryData(cruConfig.currentPage);
}

function loadDataDetail(ids){	
    var info = ids.split("~");
	
	$("#team_detail").attr("src","<%=contextPath%>/wt/prointe/projectPersonnelDetailWt.jsp?project_info_id="+info[0]);

	$("input[type='checkbox'][name='chk_entity_id'][id!='chk_entity_id"+info[0]+"']").removeAttr("checked");
	//选中这一条checkbox
	$("input[type='checkbox'][name='chk_entity_id'][id='chk_entity_id"+info[0]+"']").attr("checked",'true');

}


</script>
<title>列表页面</title>
</head>
<body onload="refreshData()" >

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						 	<!--<auth:ListButton functionId="" css="zj" event="onclick='toadd()'" title="JCDP_btn_add"></auth:ListButton>-->
						 	<auth:ListButton functionId="" css="xg" event="onclick='toadd()'" title="JCDP_btn_edit"></auth:ListButton>						 	
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>

<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{project_info_no}~{project_name}' id='chk_entity_id{project_info_no}' onclick='chooseOne(this)'/>" >选择</td>
			  	<td class="bt_info_even" autoOrder="1">序号</td> 
			  	<td class="bt_info_odd" exp="{project_id}">项目编号</td>
			  	<td class="bt_info_even" exp="{project_name}">项目名称</td>
			  	<td class="bt_info_even" exp="{create_date}">创建日期</td>
			  	<td class="bt_info_even" exp="{employee_name}">项目组长</td>
			  	
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,0)">成员明细信息</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow-y:auto;">
	<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" >
		<iframe width="100%" height="100%" name="list" id="team_detail" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
	</div>
	</div>
				
<script type="text/javascript">

	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);


</script>

</body>
</html>
