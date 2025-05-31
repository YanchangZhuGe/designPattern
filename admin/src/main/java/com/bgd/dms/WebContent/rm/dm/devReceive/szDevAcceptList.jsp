<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	//String projectInfoNo = user.getProjectInfoNo();
	
	String projectInfoNo = request.getParameter("fatherNo");	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
			  <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input">
			    <input id="s_device_app_name" name="s_device_app_name" type="text" />
			     <input type='hidden' id="szButton" name="szButton" value=""/>
			    </td>
			    <td class="ali_cdn_name">调配(剂)单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="" css="jl" event="onclick='toSave()'" title="选择明细"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_mixinfo_id}~{mix_type_id}' id='selectedbox_{device_mixinfo_id}'  onclick='chooseOne(this);'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_odd" exp="{mixinfo_no}">调配(剂)单号</td>
					<td class="bt_info_even" exp="{in_org_name}">转入单位</td>
					<td class="bt_info_even" exp="{out_org_name}">转出(调剂)单位</td>
					<td class="bt_info_odd" exp="{employee_name}">开据人</td>
					<td class="bt_info_even" exp="{create_date}">调配时间</td>
					<td class="bt_info_odd" exp="{oprstate_desc}">处理状态</td>
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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

	cruConfig.contextPath =  "<%=contextPath%>";
	
	function refreshData(v_device_app_name,v_mixinfo_no){	 
		 
		var str = "select devapp.device_app_name,he.employee_name,tp.project_name,dm.*,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"
			+"case dm.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc "
			+"from gms_device_mixinfo_form dm " 
			+"left join gms_device_app devapp on dm.device_app_id=devapp.device_app_id " 
			+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
			+"left join comm_human_employee he on dm.PRINT_EMP_ID=he.employee_id "
			+"left join comm_org_information inorg on dm.in_org_id=inorg.org_id "
			+"left join (comm_org_subjection sub left join comm_org_information outorg on sub.org_id=outorg.org_id )  on dm.out_org_id = sub.org_subjection_id "
			+"where '1'='1' and dm.state='9' and dm.bsflag='0' and (dm.mixform_type='1' or dm.mixform_type='3') and dm.mix_type_id='S0000' and dm.project_info_no='<%=projectInfoNo%>'";
			if(v_device_app_name!=undefined && v_device_app_name!=''){
				str += "and devapp.device_app_name like '%"+v_device_app_name+"%' ";
			}
			if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
				str += "and dm.mixinfo_no like '%"+v_mixinfo_no+"%' ";
			}
			str +=" order by oprstate_desc "
			
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   

	    function loadDataDetail(shuaId){
	    	var retObj;
			if(shuaId!=null){
				shuaId = shuaId.split("~")[0];
				 retObj = jcdpCallService("DevCommInfoSrv", "getDevRecInfo", "devrecId="+shuaId);
			}else{
				var ids = getSelIds('rdo_entity_id');
				alert(ids)
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			    ids = ids.split("~")[0];
			     retObj = jcdpCallService("DevCommInfoSrv", "getDevRecInfo", "devrecId="+ids);
			}
			//取消选中框--------------------------------------------------------------------------
	    	var obj = document.getElementsByName("rdo_entity_id");  
		        for (i=0; i<obj.length; i++){   
		            obj[i].checked = false;   
		             
		        } 
			//选中这一条checkbox
			$("#selectedbox_"+retObj.devicerecMap.device_mixinfo_id).attr("checked",'true');
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devicerecMap.device_mixinfo_id+"']").removeAttr("checked");
			
	    }
	function searchDevData(){
		var v_device_app_name = document.getElementById("s_device_app_name").value;
		var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		refreshData(v_device_app_name, v_mixinfo_no);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_apply_team").value="";
    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);
	}
 
    
	function toSave(){ 
		var shuaId ;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			shuaId = this.value;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		window.location.href='<%=contextPath%>/rm/dm/devReceive/szDevReceiveList.jsp?mixId='+shuaId;
	}
</script>
</html>