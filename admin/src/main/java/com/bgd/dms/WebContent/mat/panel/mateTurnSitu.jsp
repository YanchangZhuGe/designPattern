<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	user.getSubOrgIDofAffordOrg();
	user.getCodeAffordOrgID();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto">
	<div id="list_content">
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<span class="kb"><a href="#"></a></span><a href="#">物资周转情况</a>
						</div>
						<div class="tongyong_box_content_left">
							<div id="chartContainer5">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
									<tr>
										<td class="bt_info_odd" exp="<font size='5'><strong>{kczzcs_zb}</strong></font>">库存物资周转指标</td>
										<td class="bt_info_even" exp="<font size='5'><strong>{kczzcs_sj}</strong></font>">累计库存物资周转次数</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
	var showNewTitle = false;
	cruConfig.contextPath = '<%=contextPath%>';
	refresh();
	function refresh(){
		cruConfig.pageSize = cruConfig.pageSizeMax;
	    cruConfig.queryStr = "select a.kczzcs_zb,round(a.kczzcs_sj,2)kczzcs_sj from (select * from DM_DSS.F_DP_MATERIEL_KCZZCS@DSSDB.REGRESS.RDBMS.DEV.US.ORACLE.COM t order by t.data_dt desc) a where rownum=1";  
	    queryData(1);
	}
	function renderNaviTable(){
		}
	function createNewTitleTable(){
		return;
	}
    function resizeNewTitleTable(){
		
	}
</script>  
</body>

</html>

