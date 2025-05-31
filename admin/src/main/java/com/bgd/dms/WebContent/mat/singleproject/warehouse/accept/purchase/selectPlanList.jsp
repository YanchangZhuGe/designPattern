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
			    <td class="ali_cdn_name">计划单号</td>
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
			        <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{submite_number}' onclick='loadDataDetail();'/>" >选择</td>
			        <td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{submite_id}">计划单号</td>
					<td class="bt_info_even" exp="{coding_name}">班组</td>
					<td class="bt_info_odd" exp="{create_date}">需求日期</td>
					<td class="bt_info_even" exp="{user_name}">创建人</td>
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
	function refreshData(){
		var sql ='';
		sql +="select aa.create_date,aa.submite_number, aa.submite_id,aa.user_name,aa.org_name,aa.coding_name,aa.if_submit from (select t.create_date, t.submite_number,t.submite_id,u.user_name,o.org_abbreviation as org_name,d.coding_name,decode(t.if_submit, '0', '未提交', '1', '已提交') if_submit,case when pd.demand_num is null then 0 else pd.demand_num end demand_num,case when pd.use_num is null then 0 else pd.use_num end use_num from gms_mat_demand_plan_bz t inner join gms_mat_demand_plan_detail pd on t.submite_number=pd.submite_number inner join common_busi_wf_middle wm on wm.business_id = t.submite_number and wm.proc_status = '3' inner join comm_org_information o on t.org_id = o.org_id and o.bsflag = '0' inner join p_auth_user u on t.creator_id = u.user_id left join comm_coding_sort_detail d on t.s_apply_team = d.coding_code_id and d.bsflag = '0'where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.if_purchase = '0')aa where aa.demand_num != aa.use_num group by aa.create_date,aa.submite_number, aa.submite_id,aa.user_name,aa.org_name,aa.coding_name,aa.if_submit order by aa.create_date desc";
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
			sql+="select * from (select aa.create_date,aa.submite_number, aa.submite_id,aa.user_name,aa.org_name,aa.coding_name,aa.if_submit from (select t.create_date, t.submite_number,t.submite_id,u.user_name,o.org_abbreviation as org_name,d.coding_name,decode(t.if_submit, '0', '未提交', '1', '已提交') if_submit,case when pd.demand_num is null then 0 else pd.demand_num end demand_num,case when pd.use_num is null then 0 else pd.use_num end use_num from gms_mat_demand_plan_bz t inner join gms_mat_demand_plan_detail pd on t.submite_number=pd.submite_number inner join common_busi_wf_middle wm on wm.business_id = t.submite_number and wm.proc_status = '3' inner join comm_org_information o on t.org_id = o.org_id and o.bsflag = '0' inner join p_auth_user u on t.creator_id = u.user_id left join comm_coding_sort_detail d on t.s_apply_team = d.coding_code_id and d.bsflag = '0'where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.if_purchase = '0')aa where aa.demand_num != aa.use_num group by aa.create_date,aa.submite_number, aa.submite_id,aa.user_name,aa.org_name,aa.coding_name,aa.if_submit order by aa.create_date desc) where submite_id like '%"+tamplate_name+"%'"
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
									name+=cells[2].innerHTML;
								}
						}
        		}
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
		    	window.returnValue ="id:"+ids+",name:"+name;
		     	window.close();
			}
         }
</script>

</html>

