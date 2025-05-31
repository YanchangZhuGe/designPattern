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
	String projectInfoNo = user.getProjectInfoNo();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
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
			    <td class="ali_cdn_name">计划名称</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_tamplate_name" name="s_tamplate_name" type="text" /></td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='saveBake()'" title="JCDP_btn_clear"></auth:ListButton>
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
				<td class="bt_info_odd"exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{teammat_out_id}' onclick='loadDataDetail();'/>">选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{procure_no}">计划单号</td>
				<td class="bt_info_even" exp="{device_use_name}">计划名称</td>
				<td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
				<td class="bt_info_even" exp="{status}">状态</td>
				<td class="bt_info_odd" exp="{user_name}">创建人</td>
				<td class="bt_info_even" exp="{create_date}">创建时间</td>
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
	cruConfig.contextPath =  "<%=contextPath%>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
    var deviceCode = getQueryString("deviceCode");
	function refreshData(){
		var sql ='';
		sql +="select o.teammat_out_id,o.procure_no,o.device_use_name,decode(o.status,'1','已提交') status,c.dev_ci_name,o.create_date,u.user_name,r.notes from gms_mat_teammat_out o join gms_device_codeinfo c on o.device_id = c.dev_ci_code  join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0' left join bgp_comm_remark r on o.teammat_out_id =r.foreign_key_id and r.bsflag='0'  where o.bsflag='0'and o.project_info_no='<%=projectInfoNo%>'and o.status='1' and o.device_id='"+deviceCode+"' order by o.modifi_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/select/template/selectPlanList.jsp";
		queryData(1);
	}
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ='';
			var tamplate_name = document.getElementById("s_tamplate_name").value;
			sql+="select  t.tamplate_id,t.tamplate_name,t.create_date,c.coding_name,u.user_name from gms_mat_demand_tamplate t inner join comm_coding_sort_detail c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' inner join p_auth_user u on t.creator_id = u.user_id and u.bsflag='0' and t.tamplate_name like'%"+tamplate_name+"%'"
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/mattemplate/matTemList.jsp";
			queryData(1);
			
	}
     function saveBake(){
    	 ids = getSelIds('rdo_entity_id');
    	 var name="";
    	 var tab = document.getElementById("queryRetTable");
    	 var rows = tab.rows;
    		for(var i=0;i<rows.length;i++){
					var cells = rows[i].cells;
					for(var j=0;j<cells.length;j++){
							if(cells[j].firstChild.checked==true){
									name+=cells[3].innerHTML;
								}
						}
        		}
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				retObj = jcdpCallService("MatItemSrv", "getdevAccId", "teammat_out_id="+ids);
				var dev_acc_id = retObj.matInfo.dev_acc_id;
		    	window.returnValue ="id:"+ids+",name:"+name+",dev_acc_id:"+dev_acc_id;
		     	window.close();
			}
         }
</script>

</html>

