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
				<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width='16' height='16' style="cursor: pointer;" onmouseover="calDateSelector(inspectioin_time,tributton2);"/>
			</td>
		</tr>
	</table>
	<table width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top: 2px;">
		<tr>
			<td class="bt_info_odd">&nbsp;&nbsp;&nbsp;</td>
			<td class="bt_info_even">发动机部分</td>
			<td class="bt_info_odd">振动器及液压部分</td>
			<td class="bt_info_even">驱动部分</td>
			<td class="bt_info_odd">相关工作</td>
		</tr>
		<tr>
			<td style="border-bottom: black solid 1px;" align="center">启动前</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;" align="left" valign="top">
			<%
				String sql = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000005' and dl.bsflag = '0' ";
				List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
				for (int i = 0; i < list.size(); i++) {
					Map map = (Map) list.get(i);
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
					String sqlA = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000008' and dl.bsflag = '0' ";
					List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA);
					for (int a = 0; a < listA.size(); a++) {
						Map mapA = (Map) listA.get(a);
						String codingName = (String) mapA.get("codingName");
						String codingCodeId = (String) mapA.get("codingCodeId");
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
					String sqlB = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000011' and dl.bsflag = '0' ";
					List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB);
					for (int b = 0; b < listB.size(); b++) {
						Map mapB = (Map) listB.get(b);
						String codingName = (String) mapB.get("codingName");
						String codingCodeId = (String) mapB.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span> <br/> 
				<%
					}
				%>
			</td>
			<td style="border-bottom: black solid 1px; padding-left: 10px;"
				align="left" valign="top">
				<%
					String sqlC = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000014' and dl.bsflag = '0' ";
					List listC = BeanFactory.getQueryJdbcDAO().queryRecords(sqlC);
					for (int c = 0; c < listC.size(); c++) {
						Map mapC = (Map) listC.get(c);
						String codingName = (String) mapC.get("codingName");
						String codingCodeId = (String) mapC.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()"/> 
				<span id="szyk<%=codingCodeId%>"><%=codingName%></span><br/> 
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
					String sqlD = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000006' and dl.bsflag = '0' ";
					List listD = BeanFactory.getQueryJdbcDAO().queryRecords(sqlD);
					for (int d = 0; d < listD.size(); d++) {
						Map mapD = (Map) listD.get(d);
						String codingName = (String) mapD.get("codingName");
						String codingCodeId = (String) mapD.get("codingCodeId");
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
					String sqlE = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000009' and dl.bsflag = '0' ";
					List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE);
					for (int e = 0; e < listE.size(); e++) {
						Map mapE = (Map) listE.get(e);
						String codingName = (String) mapE.get("codingName");
						String codingCodeId = (String) mapE.get("codingCodeId");
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
					String sqlF = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000012' and dl.bsflag = '0' ";
					List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF);
					for (int f = 0; f < listF.size(); f++) {
						Map mapF = (Map) listF.get(f);
						String codingName = (String) mapF.get("codingName");
						String codingCodeId = (String) mapF.get("codingCodeId");
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
					String sqlG = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000015' and dl.bsflag = '0' ";
					List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG);
					for (int g = 0; g < listG.size(); g++) {
						Map mapG = (Map) listG.get(g);
						String codingName = (String) mapG.get("codingName");
						String codingCodeId = (String) mapG.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
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
					String sqlH = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000007' and dl.bsflag = '0' ";
					List listH = BeanFactory.getQueryJdbcDAO().queryRecords(sqlH);
					for (int h = 0; h < listH.size(); h++) {
						Map mapH = (Map) listH.get(h);
						String codingName = (String) mapH.get("codingName");
						String codingCodeId = (String) mapH.get("codingCodeId");
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
					String sqlJ = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000010' and dl.bsflag = '0' ";
					List listJ = BeanFactory.getQueryJdbcDAO().queryRecords(sqlJ);
					for (int j = 0; j < listJ.size(); j++) {
						Map mapJ = (Map) listJ.get(j);
						String codingName = (String) mapJ.get("codingName");
						String codingCodeId = (String) mapJ.get("codingCodeId");
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
					String sqlK = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000013' and dl.bsflag = '0' ";
					List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK);
					for (int k = 0; k < listK.size(); k++) {
						Map mapK = (Map) listK.get(k);
						String codingName = (String) mapK.get("codingName");
						String codingCodeId = (String) mapK.get("codingCodeId");
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
					String sqlL = " select dl.superior_code_id,dl.coding_sort_id,dl.coding_code_id,dl.coding_name from comm_coding_sort_detail dl where dl.coding_sort_id = '5110000158' and dl.superior_code_id = '5110000158000000016' and dl.bsflag = '0' ";
					List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL);
					for (int l = 0; l < listL.size(); l++) {
						Map mapL = (Map) listL.get(l);
						String codingName = (String) mapL.get("codingName");
						String codingCodeId = (String) mapL.get("codingCodeId");
				%> 
				<input type="checkbox" id="zyk<%=codingCodeId%>" name="zyk" value="<%=codingCodeId%>" checked="checked" onclick="loadMCContent()" /> 
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
			<td class="inquire_item6">工作小时(小时)：</td>
			<td class="inquire_form6">
				<input type="text" name="work_hour" id="work_hour" class="input_width"/>
			</td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
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
</fieldset>
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
				<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width='16' height='16' style="cursor: pointer;" onmouseover="calDateSelector(modification_time,tributton1);"/>
			</td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
		</tr>
	</table>
</fieldset>