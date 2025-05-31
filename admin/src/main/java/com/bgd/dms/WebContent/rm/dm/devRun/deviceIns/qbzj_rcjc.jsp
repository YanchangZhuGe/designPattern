<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath(); 
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
%>
<fieldset>
	<legend>日常检查项目</legend>
	<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		<tr>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
			<td class="inquire_item6">检查记录时间：</td>
			<td class="inquire_form6">
				<input type="text" name="inspectioin_time" id="inspectioin_time" class="input_width" readonly="readonly" value="<%=curDate%>"/>
				<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspectioin_time,tributton2);"/>
			</td>
		</tr>
	</table>
	<table width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top: 2px;">
		<tr>
			<td class="bt_info_odd">&nbsp;&nbsp;&nbsp;</td>
			<td class="bt_info_even">发动机部分</td>
			<td class="bt_info_odd">液压系统部分</td>
			<td class="bt_info_even">井架部分</td>
			<td class="bt_info_odd">相关工作</td>
		</tr>
		<tr>
			<td style="border-bottom: black solid 1px;" align="center">启动前</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sql = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000005' and dl.bsflag = '0' order by dl.coding_code_id ";
					List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					for (int i = 0; i < list.size(); i++) {
						Map map = (Map) list.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlA = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000008' and dl.bsflag = '0' order by dl.coding_code_id ";
					List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA);
					for (int i = 0; i < listA.size(); i++) {
						Map map = (Map) listA.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlB = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000011' and dl.bsflag = '0' order by dl.coding_code_id ";
					List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB);
					for (int i = 0; i < listB.size(); i++) {
						Map map = (Map) listB.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlC = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000014' and dl.bsflag = '0' order by dl.coding_code_id ";
					List listC = BeanFactory.getQueryJdbcDAO().queryRecords(sqlC);
					for (int i = 0; i < listC.size(); i++) {
						Map map = (Map) listC.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
		</tr>
		<tr>
			<td style="border-bottom: black solid 1px;" align="center">启动后</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlE = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000006' and dl.bsflag = '0' order by dl.coding_code_id ";
					List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE);
					for (int i = 0; i < listE.size(); i++) {
						Map map = (Map) listE.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlF = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000009' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF);
					for (int i = 0; i < listF.size(); i++) {
						Map map = (Map) listF.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlG = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000012' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG);
					for (int i = 0; i < listG.size(); i++) {
						Map map = (Map) listG.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"> <%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlH = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name  from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000015' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listH = BeanFactory.getQueryJdbcDAO().queryRecords(sqlH);
					for (int i = 0; i < listH.size(); i++) {
						Map map = (Map) listH.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
		</tr>
		<tr>
			<td style="border-bottom: black solid 1px;" align="center">停机后</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlK = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000007' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK);
					for (int i = 0; i < listK.size(); i++) {
						Map map = (Map) listK.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlL = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000010' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL);
					for (int i = 0; i < listL.size(); i++) {
						Map map = (Map) listL.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlM = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000013' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listM = BeanFactory.getQueryJdbcDAO().queryRecords(sqlM);
					for (int i = 0; i < listM.size(); i++) {
						Map map = (Map) listM.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/>
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlN = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000160' and dl.superior_code_id = '5110000160000000016' and dl.bsflag = '0' order by dl.coding_code_id  ";
					List listN = BeanFactory.getQueryJdbcDAO().queryRecords(sqlN);
					for (int i = 0; i < listN.size(); i++) {
						Map map = (Map) listN.get(i);
						String codingName = (String) map.get("codingName");
						String codingCodeId = (String) map.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
				<%
						}
					%>
			</td>
		</tr>
	</table>
</fieldset>
<fieldset>
	<legend>运转记录</legend>
	<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		<tr>
			<td class="inquire_item6">钻井进尺(米)：</td>
			<td class="inquire_form6">
				<input type="text" name="drilling_num" id="drilling_num" class="input_width"/>
			</td>
			<td class="inquire_item6">工作小时(小时)：</td>
			<td class="inquire_form6">
				<input type="text" name="work_hour" id="work_hour" class="input_width"/>
			</td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
		</tr>
	</table>
</fieldset>
<fieldset>
	<legend>燃油记录</legend>
	<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		<tr>
			<td class="inquire_item6">燃油加油量(升)：</td>
			<td class="inquire_form6">
				<input type="text" name="oil_num" id="oil_num" class="input_width"/>
			</td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
		</tr>
	</table>
<fieldset>
	<legend>问题整改</legend>
	<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		<tr>
			<td class="inquire_item6">整改内容：</td>
			<td class="inquire_form6" colspan="5">
				<textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea>
		    </td>
		</tr>
		<tr>
			<td class="inquire_item6">整改结果：</td>
			<td class="inquire_form6" colspan="5">
				<textarea id="modification_result" name="modification_result" class="textarea"></textarea>
		    </td>
		</tr>
		<tr>
			<td class="inquire_item6">整改人：</td>
			<td class="inquire_form6">
				<input type="text" name="modification_people" id="modification_people" class="input_width" />
			</td>
			<td class="inquire_item6">整改时间：</td>
			<td class="inquire_form6">
				<input type="text" name="modification_time" id="modification_time" class="input_width" readonly="readonly"/>
				<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(modification_time,tributton1);"/>
			</td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
		</tr>
	</table>
</fieldset>