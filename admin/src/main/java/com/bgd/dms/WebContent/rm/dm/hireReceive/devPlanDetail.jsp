<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userId = user.getSubOrgIDofAffordOrg();
String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
</head>

<body onload = "refreshData()" style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toAdd()'" title="填报"></auth:ListButton>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{device_allapp_detid}' onclick='loadDataDetail();chooseOne(this)'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{device_allapp_name}">配置计划名称</td>
			      <td class="bt_info_even" exp="{teamname}">班组</td>
			       <td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
			      <td class="bt_info_odd" exp="{dev_ci_model}">规格型号</td>
			      <td class="bt_info_even" exp="{unit_name}">单位</td>
			      <td class="bt_info_odd" exp="{require_num}">计划需求数量</td>
			       <td class="bt_info_even" exp="{mix_num}">已申请量</td>
			      <td class="bt_info_odd" exp="{note}">申请人</td>
			       <td class="bt_info_even" exp="{plan_start_date}">计划开始时间</td>
			      <td class="bt_info_odd" exp="{plan_end_date}">计划结束时间</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
</body>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

</script>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var userId = '<%=userId%>';
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	function refreshData(){
		var prosql = "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
		prosql += "case when aad.isdevicecode='N' then ci.dev_ci_name else ct.dev_ct_name end as dev_ci_name,";
		prosql += "case when aad.isdevicecode='N' then ci.dev_ci_model else '' end as dev_ci_model, ";
		prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
		prosql += "aad.approve_num as require_num,(case when appdet.apply_num is null then 0 else appdet.apply_num end)-(-(case when aa.hir_num is null then 0 else aa.hir_num end)) as mix_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
		prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
		prosql += "pro.project_name ";
		prosql += "from gms_device_allapp_detail aad ";
		prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
		prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
		prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
		prosql += "left join gms_device_hireapp dha on allapp.device_allapp_id=dha.device_allapp_id ";
		prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
		prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
		prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
		prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no left join GMS_DEVICE_APP_DETAIL appdet on aad.device_allapp_detid = appdet.device_allapp_detid left join (select hirdet.device_app_detid, count(*) as hir_num from GMS_DEVICE_HIREFILL_DETAIL hirdet group by hirdet.device_app_detid)aa on aad.device_allapp_detid = aa.device_app_detid ";
		prosql += " where aad.project_info_no = '<%=projectInfoNo%>' and aad.bsflag='0' ";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = prosql;
		cruConfig.currentPageUrl = "/rm/dm/hireReceive/devPlanDetail.jsp";
		queryData(1);
	}
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			
			var retObj = jcdpCallService("MatItemSrv", "deleteMatTem", "matId="+ids);
			queryData(cruConfig.currentPage);
		}  
	}

	  function toAdd(){ 
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
			  popWindow('<%=contextPath%>/rm/dm/hireReceive/hiredetail_fill.jsp?deviceappdetid='+ids,'1024:800');
		    }
	 }  

	  function toEdit(){ 
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
			  popWindow('<%=contextPath%>/mat/singleproject/mattemplate/getMatTem.srq?deviceappdetid='+ids,'1024:800');
		    }
			
	 }  

       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ="select decode(t.loacked_if,'0','是','1','否') loacked_if,t.tamplate_id,t.tamplate_name,t.create_date,c.coding_name,u.user_name, nvl(c.coding_name,(d.dev_ci_name||d.dev_ci_model))as tname from gms_mat_demand_tamplate t left join gms_device_codeinfo d on t.device_id = d.dev_ci_code left join comm_coding_sort_detail c on t.coding_code_id = c.coding_code_id and c.bsflag='0' inner join p_auth_user u on t.creator_id = u.user_id and u.bsflag='0' where";
			var tamplate_name = document.getElementById("s_tamplate_name").value;
			var create_date = document.getElementById("s_create_date").value;
			if(tamplate_name !='' && tamplate_name != null || create_date !='' && create_date != null){
				if(tamplate_name !=''){
				sql+=" t.tamplate_name like'%"+tamplate_name+"%'and t.bsflag='0'";
				}
				if(create_date !=''){
				sql +=" t.create_date like to_date('"+create_date+"','yyyy-mm-dd') ";
					}
			}
			else{
				alert('请输入查询内容！');
				}
			
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/mattemplate/matTemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_tamplate_name").value = "";
   		document.getElementById("s_create_date").value = "";
   	} 
</script>

</html>

