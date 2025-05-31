<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2">
				<div class="tongyong_box">
					<div class="tongyong_box_title">
						<span class="kb"><a href="#"></a></span><a href="#">物资周转情况</a>
					</div>
					<div class="tongyong_box_content_left">
						<div>
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

