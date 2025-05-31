<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project = request.getParameter("project");
	if(project==null||project.equals("")){
		project = resultMsg.getValue("project");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="name" name="name" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="dr" event="onclick='toUploadFile()'"  title="导入" ></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_strain_id}' id='rdo_entity_id_{hse_strain_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}" isExport='Hide'>单位</td>
			      <td class="bt_info_even" exp="{third_org_name}" isExport='Hide'>基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}" isExport='Hide'>下属单位</td>
			      <td class="bt_info_even" exp="{employee_name}" isExport='Hide'>姓名</td>
			      <td class="bt_info_odd" exp="{coding_name}" isExport='Hide'>应急职责</td>
			      <td class="bt_info_even" exp="{expert_flag}" isExport='Hide'>应急专家</td>
			      
			      <td class="bt_info_odd" exp="{second_org_name}" isShow='Hide' isExport='Show'>单位</td>
			      <td class="bt_info_odd" exp="{third_org_name}" isShow='Hide' isExport='Show'>基层单位</td>
			      <td class="bt_info_odd" exp="{employee_name}" isShow='Hide' isExport='Show'>姓名</td> 
			      <td class="bt_info_odd" exp="{sex_type}" isShow='Hide' isExport='Show'>性别</td>
			      <td class="bt_info_odd" exp="{code_id}" isShow='Hide' isExport='Show'>身份证号</td> 
			      <td class="bt_info_odd" exp="{coding_name}" isShow='Hide' isExport='Show'>应急职责</td> 
			      <td class="bt_info_odd" exp="{expert_flag}" isShow='Hide' isExport='Show'>是否应急专家</td>
			      
			      <td class="bt_info_odd" exp="{expert_level}" isShow='Hide' isExport='Show'>专家级别</td>  
			      <td class="bt_info_odd" exp="{expert_field}" isShow='Hide' isExport='Show'>擅长领域</td>  
			      <td class="bt_info_odd" exp="{test_type}" isShow='Hide' isExport='Show'>应急事件类别</td> 
			      <td class="bt_info_odd" exp="{first_phone}" isShow='Hide' isExport='Show'>首选联系电话</td> 
			      <td class="bt_info_odd" exp="{second_phone}" isShow='Hide' isExport='Show'>次选联系电话</td> 

			      
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">应急信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<input type="hidden" id="hse_strain_id" name="hse_strain_id"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						  <td class="inquire_item6">单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="second_org" name="second_org" class="input_width" readonly="readonly"/>
					      	</td>
					     	<td class="inquire_item6">基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="third_org" name="third_org" class="input_width" readonly="readonly"/>
					      	</td>
					      	<td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="fourth_org" name="fourth_org" class="input_width" readonly="readonly"/>
					      	</td>
					  </tr>
					  <tr>
					    	<td class="inquire_item6">姓名：</td>
				      		<td class="inquire_form6">
						      	<input type="text" id="employeeName" name="employeeName" class="input_width"  value="" readonly="readonly"/>
				      		</td>
						    <td class="inquire_item6">性别：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="sex" name="sex" class="input_width" readonly="readonly"/>
							</td>
							<td class="inquire_item6">身份证号：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="codeId" name="codeId" class="input_width" readonly="readonly"/>
							</td>
					  </tr>	
					  <tr>
							<td class="inquire_item6">学历：</td>
						    <td class="inquire_form6">
						    	<input type="text" id="education_level" name="education_level" class="input_width" readonly="readonly"/>
							</td>
						  	<td class="inquire_item6">职称：</td>
						    <td class="inquire_form6">
								<input type="text" id="techTitle" name="techTitle" class="input_width" readonly="readonly"/>
						    </td>
						    <td class="inquire_item6">用工方式</td>
						    <td class="inquire_form6">
						    	<input type="text" id="human_scotter" name="human_scotter" class="input_width" readonly="readonly"/>
							</td>
					  </tr>
					  <tr>
						  	<td class="inquire_item6">是否在岗：</td>
						    <td class="inquire_form6">
								<input type="text" id="personStatus" name="personStatus" class="input_width" readonly="readonly"/>
							</td>
						    <td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
						   	<td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<form name="form1" id="form1"  method="post" action="">
					<input type="hidden" name="remark_id" id="remark_id" value=""/>
					<input type="hidden" name="project" id="project" value="<%=project%>"/>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
			                  <td>&nbsp;</td>
			                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdate()" title="保存"><a href="#"></a></span></td>
			                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
					    	<td class="inquire_item6"><font color="red">*</font>选择人员：</td>
					      	<td class="inquire_form6">
								<input type="hidden" id="employee_id" name="employee_id" class="input_width"  value=""/>
						      	<input type="text" id="employee_name" name="employee_name" class="input_width"  value=""/>
						      	<input type="button" style="width:20px" value="..." onclick="showHuman()"/>
					      	</td>
						   	<td class="inquire_item6"><font color="red">*</font>是否在岗：</td>
						   	<td class="inquire_form6">
						   		<select id="person_status" name="person_status" class="select_width">
						       <option value="" >请选择</option>
						       <option value="是" >是</option>
						       <option value="否" >否</option>
							</select>	
						   	</td>
					     	<td class="inquire_item6"><font color="red">*</font>应急事件类别：</td>
					      	<td class="inquire_form6">
					      		<input type="hidden" id="strain_type" name="strain_type" value="" class="input_width"/>
					      		<input type="text" id="strain_name" name="strain_name" value="" class="input_width"/>
					      		<input type="button" style="width:20px" value="..." onclick="showStrainType()"/>
				      		</td>
					  	</tr>
					  	<tr>
					     	<td class="inquire_item6"><font color="red">*</font>应急职责：</td>
					      	<td class="inquire_form6">
					      		<select id="strain_duty" name="strain_duty" class="select_width">
						          <option value="" >请选择</option>
						          <%
						          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000034' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
						          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
						          	for(int i=0;i<list.size();i++){
						          		Map map = (Map)list.get(i);
						          		String coding_id = (String)map.get("codingCodeId");
						          		String coding_name = (String)map.get("codingName");
						          %>
						          <option value="<%=coding_id %>" ><%=coding_name %></option>
						          <%} %>
							    </select>
					      	</td>
						  	<td class="inquire_item6"><font color="red">*</font>首选联系电话：</td>
						    <td class="inquire_form6">
								<input type="text" id="first_phone" name="first_phone" class="input_width"></input>
							</td>
						  	<td class="inquire_item6"> 次选联系电话：</td>
						    <td class="inquire_form6">
								<input type="text" id="second_phone" name="second_phone" class="input_width"></input>
							</td>
					  	</tr>
					  	<tr>
					     	<td class="inquire_item6"><font color="red">*</font>应急专家：</td>
					      	<td class="inquire_form6">
					      		<select id="expert_flag" name="expert_flag" class="select_width" onclick="ifExpert()">
						          <option value="" >请选择</option>
						          <option value="1" >是</option>
						          <option value="2" >否</option>
							    </select>
					      	</td>
						 	<td class="inquire_item6"><font id="if_expert1" color="red" style="display: none;">*</font>专家级别：</td>
						   	<td class="inquire_form6">
								<select id="expert_level" name="expert_level" class="select_width" >
						          <option value="" >请选择</option>
						          <option value="1" >集团公司</option>
						          <option value="2" >公司</option>
						          <option value="3" >二级单位</option>
							    </select>
							</td>
							<td class="inquire_item6"><font id="if_expert2" color="red" style="display: none;">*</font>擅长领域：</td>
						    <td class="inquire_form6">
								<select id="expert_field" name="expert_field" class="select_width">
						          <option value="" >请选择</option>
						          <%
						          	String sql22 = "select * from comm_coding_sort_detail where coding_sort_id='5110000035' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
						          	List list22 = BeanFactory.getQueryJdbcDAO().queryRecords(sql22);
						          	for(int i=0;i<list22.size();i++){
						          		Map map22 = (Map)list22.get(i);
						          		String coding_id22 = (String)map22.get("codingCodeId");
						          		String coding_name22 = (String)map22.get("codingName");
						          %>
						          <option value="<%=coding_id22 %>" ><%=coding_name22 %></option>
						          <%} %>
							    </select>
							</td>
					 	</tr>
					  	<tr>
					     	<td class="inquire_item6"><font id="if_expert3" color="red" style="display: none;">*</font>擅长职责：</td>
					      	<td class="inquire_form6">
					      		<select id="expert_duty" name="expert_duty" class="select_width">
						          <option value="" >请选择</option>
						          <%
						          	String sql33 = "select * from comm_coding_sort_detail where coding_sort_id='5110000036' and superior_code_id='0' and bsflag='0' order by coding_show_id asc";
						          	List list33 = BeanFactory.getQueryJdbcDAO().queryRecords(sql33);
						          	for(int i=0;i<list33.size();i++){
						          		Map map33 = (Map)list33.get(i);
						          		String coding_id33 = (String)map33.get("codingCodeId");
						          		String coding_name33 = (String)map33.get("codingName");
						          %>
						          <option value="<%=coding_id33 %>" ><%=coding_name33 %></option>
						          <%} %>
							    </select>
					      	</td>
						 	<td class="inquire_item6"></td>
						   	<td class="inquire_form6"></td>
							<td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
					  	</tr>
					  	<tr>
						  	<td class="inquire_item6">补充说明</td>
						    <td class="inquire_form6" colspan="5"><textarea id="memo" name="memo" class="textarea" ></textarea></td>
					  	</tr>
					</table>
					</form>
				</div>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}
	
	// 复杂查询
	function refreshData(){
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select * from (select hs.hse_strain_id,hs.project_info_no,hs.bsflag,hs.modifi_date,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id,decode(hs.expert_flag,'1','是','2','否') expert_flag,sd.coding_name, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,      decode(hs.expert_level,'1','集团公司','2','公司','3','二级单位') expert_level,   decode(hs.strain_type,'1、2、3、4','自然灾害，事故灾难，公共卫生，社会安全','1、2','自然灾害，事故灾难','1、3','自然灾害，公共卫生','1、4','自然灾害，社会安全','2、3','事故灾难，公共卫生','2、4','事故灾难，社会安全','3、4','公共卫生,社会安全','1','自然灾害','2','事故灾难','3','公共卫生','4','社会安全') test_type,    ed.coding_name expert_field,hs.first_phone,hs.second_phone,oi1.org_abbreviation second_org_name, oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_strain hs left join comm_human_employee ee on ee.employee_id=hs.employee_id and ee.bsflag='0' left join bgp_comm_human_labor la on la.labor_id=hs.employee_id and la.bsflag='0'  left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0'  left join comm_coding_sort_detail sd on hs.strain_duty=sd.coding_code_id and sd.bsflag='0'   left join comm_coding_sort_detail ed  on hs.expert_field = ed.coding_code_id  and ed.bsflag = '0' left join comm_org_subjection os1 on hs.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hs.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hs.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0' where hs.bsflag='0') where bsflag='0' "+querySqlAdd+" order by modifi_date desc";
		cruConfig.currentPageUrl = "hse/humanResource/hseStrainPerson/strain_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "hse/humanResource/hseStrainPerson/strain_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
    
  	function toUploadFile(){
  		popWindow("<%=contextPath%>/hse/humanResource/hseStrainPerson/humanImportFile.jsp?project=<%=project%>");
  	}
  	
	// 简单查询
	function simpleSearch(){
		var name = document.getElementById("name").value;
		var project = "<%=project%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(project=="1"){
			querySqlAdd = getMultipleSql3("",org_subjection_id);
		}else if(project=="2"){
			querySqlAdd = "and project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		if(name!=''&&name!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select * from (select hs.hse_strain_id,hs.project_info_no,hs.bsflag,hs.modifi_date,case when ee.employee_id is null then la.owning_subjection_org_id else os.org_subjection_id end org_subjection_id,decode(hs.expert_flag,'1','是','2','否') expert_flag,sd.coding_name, case when ee.employee_id is null then la.employee_name else ee.employee_name end employee_name,case when ee.employee_id is null then la.employee_id_code_no else ee.employee_id_code_no end code_id,case when ee.employee_id is null then decode(la.employee_gender,'0','女','1','男') else decode(ee.EMPLOYEE_GENDER, '0', '女', '1', '男') end sex_type,      decode(hs.expert_level,'1','集团公司','2','公司','3','二级单位') expert_level,   decode(hs.strain_type,'1、2、3、4','自然灾害，事故灾难，公共卫生，社会安全','1、2','自然灾害，事故灾难','1、3','自然灾害，公共卫生','1、4','自然灾害，社会安全','2、3','事故灾难，公共卫生','2、4','事故灾难，社会安全','3、4','公共卫生,社会安全','1','自然灾害','2','事故灾难','3','公共卫生','4','社会安全') test_type,    ed.coding_name expert_field,hs.first_phone,hs.second_phone,oi1.org_abbreviation second_org_name, oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_strain hs left join comm_human_employee ee on ee.employee_id=hs.employee_id and ee.bsflag='0' left join bgp_comm_human_labor la on la.labor_id=hs.employee_id and la.bsflag='0'  left join comm_coding_sort_detail sd2 on la.employee_education_level=sd2.coding_code_id and sd2.bsflag='0'  left join comm_coding_sort_detail sd on hs.strain_duty=sd.coding_code_id and sd.bsflag='0'   left join comm_coding_sort_detail ed  on hs.expert_field = ed.coding_code_id  and ed.bsflag = '0' left join comm_org_subjection os1 on hs.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on hs.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id = oi2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on hs.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id = oi3.org_id and oi3.bsflag = '0' left join comm_org_subjection os on os.org_id=ee.org_id and os.bsflag='0' where hs.bsflag='0') where bsflag='0' "+querySqlAdd+" and employee_name like '%"+name+"%' order by modifi_date desc";
			cruConfig.currentPageUrl = "hse/humanResource/hseStrainPerson/strain_list.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("name").value = "";
	}
	
	function showHuman(){
	    var project = "<%=project%>";
	    var result = "";
	    if(project=="1"){
	    	result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanMultiple.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
	    }else if(project=="2"){
	    	result=showModalDialog('<%=contextPath%>/hse/hseCommon/selectHumanSingle.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
	    }
	    if(result!=null && result!=""){
	    	var checkStr=result.split(",");
	    	for(var i=0;i<checkStr.length-1;i++){
	    		var testTemp = checkStr[i].split("-");
	    		document.getElementById("employee_id").value = testTemp[0];
	    	    document.getElementById("employee_name").value = testTemp[1];
	       	}	
	   }
	  }
	
	function ifExpert(){
		var expertFlag = document.getElementById("expert_flag").value;
		if(expertFlag=="1"){
			document.getElementById("if_expert1").style.display = "";
			document.getElementById("if_expert2").style.display = "";
			document.getElementById("if_expert3").style.display = "";
		}else{
			document.getElementById("if_expert1").style.display = "none";
			document.getElementById("if_expert2").style.display = "none";
			document.getElementById("if_expert3").style.display = "none";
		}
	}
	
	function showStrainType(){
		var selected = window.showModalDialog("<%=contextPath%>/hse/humanResource/hseStrainPerson/selectStrainType.jsp","","dialogWidth=545px;dialogHeight=280px");

		var strain_name = "";
		var name = ""
		var temp = selected.split("、");
		for(var i=0;i<temp.length;i++){
			var id = temp[i];
			if(id=="1"){
				name = "自然灾害";		
			}
			if(id=="2"){
				name = "事故灾难";		
			}
			if(id=="3"){
				name = "公共卫生";		
			}
			if(id=="4"){
				name = "社会安全";		
			}
			if(strain_name!="") strain_name += "、";
			strain_name += name;
		}
		document.getElementById("strain_type").value = selected;
		document.getElementById("strain_name").value = strain_name;
		
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "queryStrain", "hse_strain_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryStrain", "hse_strain_id="+ids);
		}
		document.getElementById("hse_strain_id").value =retObj.map.hseStrainId;
		document.getElementById("second_org").value =retObj.map.secondOrgName;
		document.getElementById("third_org").value =retObj.map.thirdOrgName;
		document.getElementById("fourth_org").value =retObj.map.fourthOrgName;
		document.getElementById("employeeName").value =retObj.map.employeeName;
		document.getElementById("sex").value = retObj.map.sexType;
		document.getElementById("codeId").value = retObj.map.codeId;
		document.getElementById("education_level").value = retObj.map.codingName;
		document.getElementById("techTitle").value = retObj.map.title;
		document.getElementById("human_scotter").value = retObj.map.humanScotter;
		document.getElementById("personStatus").value = retObj.map.personStatus;
		
		
		document.getElementById("employee_id").value = retObj.map.employeeId;
		document.getElementById("employee_name").value = retObj.map.employeeName;
		document.getElementById("person_status").value = retObj.map.personStatus;
		
		var selected = retObj.map.strainType;
		var strain_name = "";
		var name = ""
		var temp = selected.split("、");
		for(var i=0;i<temp.length;i++){
			var id = temp[i];
			if(id=="1"){
				name = "自然灾害";		
			}
			if(id=="2"){
				name = "事故灾难";		
			}
			if(id=="3"){
				name = "公共卫生";		
			}
			if(id=="4"){
				name = "社会安全";		
			}
			if(strain_name!="") strain_name += "、";
			strain_name += name;
		}
		document.getElementById("strain_type").value = selected;
		document.getElementById("strain_name").value = strain_name;
		
		document.getElementById("strain_duty").value = retObj.map.strainDuty;
		document.getElementById("first_phone").value = retObj.map.firstPhone;
		document.getElementById("second_phone").value = retObj.map.secondPhone;
		document.getElementById("expert_flag").value = retObj.map.expertFlag;
		document.getElementById("expert_level").value = retObj.map.expertLevel;
		document.getElementById("expert_field").value = retObj.map.expertField;
		document.getElementById("expert_duty").value = retObj.map.expertDuty;
		document.getElementById("memo").value = retObj.map.notes;
		document.getElementById("remark_id").value = retObj.map.remarkId;

	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/humanResource/hseStrainPerson/addStrain.jsp?project=<%=project%>");
		
	}
	
	function toUpdate(){ 
		if(checkText()){
			return;
		}
		var hse_strain_id = document.getElementById("hse_strain_id").value;
		var form = document.getElementById("form1");
		form.action="<%=contextPath%>/hse/resource/saveStrain.srq?project=<%=project%>&&hse_strain_id="+hse_strain_id;
		form.submit();
	} 
	
	function checkText(){
		var employee_id = document.getElementById("employee_id").value;
		var person_status = document.getElementById("person_status").value;
		
		var strain_type = document.getElementById("strain_type").value;
		var strain_duty = document.getElementById("strain_duty").value;
		var first_phone = document.getElementById("first_phone").value;
		var second_phone = document.getElementById("second_phone").value;
		var expert_flag = document.getElementById("expert_flag").value;
		var expert_level = document.getElementById("expert_level").value;
		var expert_field = document.getElementById("expert_field").value;
		var expert_duty = document.getElementById("expert_duty").value;
		if(employee_id==""){
			alert("人员姓名不能为空，请选择！");
			return true;
		}
		if(person_status==""){
			alert("是否在岗不能为空，请填写！");
			return true;
		}
		if(strain_type==""){
			alert("应急事件类别不能为空，请选择！");
			return true;
		}
		if(strain_duty==""){
			alert("应急职责不能为空，请选择！");
			return true;
		}
		if(first_phone==""){
			alert("首选联系电话不能为空，请填写！");
			return true;
		}
 
		if(expert_flag==""){
			alert("应急专家不能为空，请选择！");
			return true;
		}
		if(expert_flag=="1"){
			if(expert_level==""){
				alert("专家级别不能为空，请选择！");
				return true;
			}
			if(expert_field==""){
				alert("擅长领域不能为空，请选择！");
				return true;
			}
			if(expert_duty==""){
				alert("擅长职责不能为空，请填写！");
				return true;
			}
		}
		return false;
	}


	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteStrain", "hse_strain_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/humanResource/hseStrainPerson/strain_search.jsp?project=<%=project%>");
	}
	
	
</script>

</html>

