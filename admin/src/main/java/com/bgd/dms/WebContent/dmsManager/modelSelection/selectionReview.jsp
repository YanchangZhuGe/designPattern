<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String contextPath = request.getContextPath();
	String opi_id = request.getParameter("opi_id");
	/* UserToken user = OMSMVCUtil.getUserToken(request); */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@include file="/common/include/quotesresource.jsp"%>
<title>选型申请</title>
<script type= "text/javascript">
var applyState = new Array(
          [ '0', '首次申请'],
          [ '1', '置期复查'],
          [ '2', '增项']
          );
</script>

<style>

td {
    white-space:nowrap;overflow:hidden;text-overflow: ellipsis;
}
</style>
</head>

<body style="background:#fff" onload="refreshData(),loadDataDetail(<%=opi_id%>);">
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		          <td class="ali_cdn_name">&nbsp;申请单位:</td>
		          <td class="ali_cdn_input">
		          	<input name="apply_unit" id="apply_unit" class="input_width" type="text" />
		          </td>
		          <td class="ali_cdn_name">&nbsp;产品名称:</td>
					<td class="ali_cdn_input">
						<input name="opi_name" id="opi_name" class="input_width" type="text" value=""/>
					</td>
					 <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
				    </td>
				    
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="cz" event="onclick='toReview()'" title="评审"></auth:ListButton>
			 </tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
     </div>
     <div id="table_box">
			  <table style="width:98.5%;table-layout: fixed;" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">	
			     <tr >
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{opi_id}' id='selectedbox_{opi_id}'/>" >选择</td>
					<td class="bt_info_even" width="4%"  autoOrder="1" >序号</td> 
					<td class="bt_info_odd"  width="10%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{opi_name}">产品名称</td>
					<td class="bt_info_even"  width="16%" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{production}">生产单位</td>
					<td class="bt_info_odd" width="16%"  style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{apply_unit}">申请单位</td>
					<td class="bt_info_even" width="16%"  style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{apply_state}" func= "getOpValue,applyState">申请状态</td>
					<td class="bt_info_odd" width="16%"  style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{apply_date}">申请时间</td>
					<td class="bt_info_even" width="16%"  style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" exp="{review_state}">评审状态</td>
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
      <div class="lashen" id="line"></div>
      <div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">产品基本信息</a></li>
			    <li id="tag3_0" ><a href="#" onclick="getContentTab(this,1)">企业基本信息</a></li>
			    <li id="tag3_0" ><a href="#" onclick="getContentTab(this,2)">评审信息</a></li>
			  </ul>
	  </div>
	  <div id="tab_box" class="tab_box">
		<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
		<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
			<tr style="text-align: left">
			  <td class="inquire_item6">&nbsp;产品名称型号：</td>
			  <td class="inquire_form6"><input name ="opi_name" id="opi_name" class="input_width" type="text" value="" disabled="disabled"/></td>
			  <td class="inquire_item6">&nbsp;商标：</td>
			  <td class="inquire_form6"><input name="brand" id="brand" class="input_width" type="text" value="" disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;生产单位：</td>
			  <td class="inquire_form6"><input name="production" id="production" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  <td class="inquire_item6">&nbsp;上年产量：</td>
			  <td class="inquire_form6"><input name="last_year_yield" id="last_year_yield" class="input_width" type="text" value=""  disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td style="height: 40px;" class="inquire_item6">&nbsp;产品简介：</td>
			  <td colspan="3" class="inquire_form6"><textarea id="product_info" name="product_info"  class="textarea" style="height:40px" disabled="disabled";></textarea></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;技术参数：</td>
			 <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_skill_tablePublic">
				<input name="skill_parameter_report" id="skill_parameter_report" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		 <tr>
			  <td class="inquire_item6">&nbsp;测试使用报告：</td>
			  <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_test_tablePublic">
				<input name="test_using_report" id="test_using_report" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;应用证明：</td>
			  <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="userProve_file_tablePublic">
				<input name="user_prove" id="user_prove" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
	   		  <td class="inquire_item6">&nbsp;生产单位资质：</td>
	   		   <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="production_file_tablePublic">
				<input name="production_unit_aptitude" id="production_unit_aptitude" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;其他附件：</td>
			   <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="other_file_tablePublic">
				<input name="other" id="other" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;申请状态：</td>
			  <td colspan="4" class="inquire_form4">
      			<input type="radio" id="apply_state" name="apply_state" value="0" checked="checked"/><label >&nbsp;首次申请&nbsp;&nbsp;&nbsp;&nbsp;</label>
      			<input type="radio" id="apply_state" name="apply_state" value="1"/><label >&nbsp;至期复查&nbsp;&nbsp;&nbsp;&nbsp;</label>
      			<input type="radio" id="apply_state" name="apply_state" value="2"/><label >&nbsp;增项</label>
     			 </td>
		  </tr>
		   <tr>
			  <td class="inquire_item6">&nbsp;申请单位：</td>
			  <td colspan="3" class="inquire_form6"><input name="apply_unit" id="apply_unit" class="input_width" type="text" value=""  disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;申请单位理由：</td>
			  <td colspan="3" class="inquire_form6"><input name="apply_unit_reason" id="apply_unit_reason" class="input_width" type="text" value=""  disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;领导姓名：</td>
			  <td class="inquire_form6"><input name="principal" id="principal" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  <td class="inquire_item6">&nbsp;批准时间：</td>
			  <td class="inquire_form6"><input name="approve_date" id="approve_date" class="input_width" type="text" value="" disabled="disabled" /></td>
		  </tr>
		   <tr>
	   		<td class="inquire_item6">&nbsp;附件(评审证明)：</td>
	   		<td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="reviewConfirms_file_tablePublic">
				<input name="review_confirms" id="review_confirms" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		</table>
	   </div>
	   <div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
	     <table id="companyMap" name="companyMap" width="100%" border="0" cellspacing="0" cellpadding="0">
	     <tr><td>&nbsp;</td></tr>
	   		  <tr style="text-align: left">
				  <td width="8%" align="right">&nbsp;产品名称型号：</td>
				  <td class="inquire_form6"><input name ="enterprise_name" id="enterprise_name" class="input_width" type="text" value=""  style="height: 30px" disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;法定代表人：</td>
				  <td class="inquire_form6"><input name="legal_person" id="legal_person" class="input_width" type="text" value="" style=" height: 30px" disabled="disabled"/></td>
			  </tr>
			 <tr><td>&nbsp;</td></tr>
			  <tr>
				  <td width="8%" align="right">&nbsp;通讯地址：</td>
				  <td class="inquire_form6"><input name="company_address" id="company_address" class="input_width" type="text" value="" style="height: 30px"  disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;邮编：</td>
				  <td class="inquire_form6"><input name="postalcode" id="postalcode" class="input_width" type="text" value="" style="height: 30px"  disabled="disabled"/></td>
			  </tr>
			   <tr><td>&nbsp;</td></tr>
			  	<tr>
				  <td width="8%" align="right">&nbsp;企业类型：</td>
				  <td class="inquire_form6"><input name ="company_type" id="company_type" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;注册资本：</td>
				  <td class="inquire_form6"><input name="registered_capital" id="registered_capital" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
			  </tr>
			   <tr><td>&nbsp;</td></tr>
			  <tr>
				  <td width="8%" align="right">&nbsp;生产能力：</td>
				  <td class="inquire_form6"><input name="production_capactity" id="production_capactity" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;职工总数：</td>
				  <td class="inquire_form6"><input name="work_force" id="work_force" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
			  </tr>
			   <tr><td>&nbsp;</td></tr>
			  	<tr>
				  <td width="8%" align="right">&nbsp;上年总产值：</td>
				  <td class="inquire_form6"><input name ="lastyear_total_value" id="lastyear_total_value" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;固定资产：</td>
				  <td class="inquire_form6"><input name="fixed_assets" id="fixed_assets" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
			  </tr>
			   <tr><td>&nbsp;</td></tr>
			  <tr>
				  <td width="8%" align="right">&nbsp;联系人：</td>
				  <td class="inquire_form6"><input name="linkman" id="linkman" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;联系电话：</td>
				  <td class="inquire_form6"><input name="linkman_phone" id="linkman_phone" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
			  </tr>
			   <tr><td>&nbsp;</td></tr>
			  	<tr>
				  <td width="8%" align="right">&nbsp;手机：</td>
				  <td class="inquire_form6"><input name ="cellphone" id="cellphone" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
				  <td width="8%" align="right">&nbsp;管理体系认证标准、时间：</td>
				  <td class="inquire_form6"><input name="sgs_date" id="sgs_date" class="input_width" type="text" value="" style="height: 30px" disabled="disabled"/></td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				 <td width="13%" align="right">&nbsp;企业简介：</td>
				 <td colspan="2" width="87%"><textarea id="enterprise_info" name="enterprise_info"  class="textarea" style="height:40px;" overflow-x:hidded; disabled="disabled"></textarea></td>
			 </tr>
	   </table>
	   <h5 align="center" style="font-size: 18px">主要人员情况</h5>
	   <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr class="bt_info">
					<td class="bt_info_even" width="12.5%">序号</td>
					<td class="bt_info_odd" width="12.5%">姓名</td>
					<td class="bt_info_even" width="12.5%">性别</td>
					<td class="bt_info_odd" width="12.5%">年龄</td>
					<td class="bt_info_even" width="12.5%">职务职称</td>
					<td class="bt_info_odd" width="12.5%">学历</td>
					<td class="bt_info_even" width="12.5%">所学专业</td>
					<td class="bt_info_odd" width="12.5%">固定/聘用</td>
				</tr>
				<tbody id="peopleMap" name="peopleMap" ></tbody>
		</table>
		<h5 align="center" style="font-size: 18px">主要生产设备</h5>
		<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
				<tr class="bt_info">
					<td class="bt_info_even" width="20%">序号</td>
					<td class="bt_info_odd" width="20%">设备名称</td>
					<td class="bt_info_even" width="20%">规格型号</td>
					<td class="bt_info_odd" width="20%">生产厂家</td>
					<td class="bt_info_even" width="20%">运行状况</td>
				</tr>
				<tbody id="deviceMap" name="deviceMap" ></tbody>
		</table>
	   </div>
	   <div id="tab_box_content2" name="tab_box_content2" idinfo="" class="tab_box_content" style="display:none;" >
	    <h5 align="center" style="font-size: 15px">专家组意见</h5>
	   <table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
		<tr>
          <td width="8%;" align="right">&nbsp;意见：</td>
	      <td colspan="2" class="inquire_form4"><textarea id="panel_idea" name="panel_idea"  class="textarea " style="width:50%;height:40px" disabled="disabled"></textarea></td>
        </tr>
        <tr>
			<td align="right">&nbsp;负责人：</td>
			<td class="inquire_form4">
				<input name="panel_principal" id="panel_principal" class="input_width easyui-validatebox" type="text" value="" style="width: 258px" title="负责人" disabled="disabled"/>
			</td>
		</tr>
		<tr>
          <td align="right">评审日期：</td>
          <td class="inquire_form4">
				<input type="text" name="panel_review_date" id="panel_review_date" title="评审日期"  value="<%=appDate %>" class="input_width easyui-datebox" style="width:258px" required disabled="disabled"/>
		  </td>
        </tr>
      </table>
      <fieldset style="margin-left:2px">
      <h5 align="center" style="font-size: 15px">设备物资处意见</h5>
		 <table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
	 	<tr>
          <td width="8%;" align="right">&nbsp;意见：</td>
	      <td colspan="2" class="inquire_form4"><textarea id="equipment_idea" name="equipment_idea"  class="textarea" style="width:50%;height:40px" disabled="disabled"></textarea></td>
        </tr>
        <tr>
			<td align="right">&nbsp;负责人：</td>
			<td class="inquire_form4">
				<input name="equipment_principal" id="equipment_principal" class="input_width easyui-validatebox" type="text" value="" style="width: 258px" title="负责人" disabled="disabled"/>
			</td>
		</tr>
		<tr>
          <td align="right" >评审日期：</td>
          <td class="inquire_form4">
				<input type="text" name="equipment_review_date" id="equipment_review_date" title="评审日期"  value="<%=appDate %>" class="input_width easyui-datebox" style="width:258px" required disabled="disabled"/>
		  </td>
        </tr>
        <tr>
          <td align="right">评审结果：</td>
          <td class="inquire_form4">
          <input name="review_result" id="review_result" class="input_width easyui-validatebox" type="text" value="" style="width: 258px" title="评审结果" disabled="disabled"/>
		  </td>
        </tr>
        <tr>
	      <td align="right">&nbsp;附件(评审证明)：</td>		
	      <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="review_tablePublic">
				<input name="review_confirms_ps" id="review_confirms_ps" type="hidden" disabled="disabled"/>
			 </table>
		   </td>
	     </tr>	
		</table>
       <tbody id="reviewMap" name="reviewMap" id="point" onclick="show()"></tbody>
       <tbody  id="ycxMap" name="ycxMap" style="width:97.9%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height"></tbody>
	</table>
 </div>  
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "queryRetTable";
	cruConfig.queryService = "ModelApply";
	cruConfig.queryOp = "queryReviewList";
	
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
	var selectedTagIndex = 0;
	function getContentTab(obj,index) {
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		if(index == 1){
			var basedatas;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
		    	$.messager.alert("提示","请先选中一条记录!","warning");
	     		return;
		    }
			var retObj;
		   retObj = jcdpCallService("EquipmentSelectionApply", "getCompanyProduct", "opi_id="+ids);
		   
		 	// 给数据回填
		 	// 企业基本信息	
		 	var data = retObj.str;
			$("#enterprise_name","#companyMap").val(data.enterprise_name);
			$("#legal_person","#companyMap").val(data.legal_person);
			$("#company_address","#companyMap").val(data.company_address);
			$("#postalcode","#companyMap").val(data.postalcode);
			$("#company_type","#companyMap").val(data.company_type);
			$("#registered_capital","#companyMap").val(data.registered_capital);
			$("#production_capactity","#companyMap").val(data.production_capactity);
			$("#work_force","#companyMap").val(data.work_force);
			$("#lastyear_total_value","#companyMap").val(data.lastyear_total_value);
			$("#fixed_assets","#companyMap").val(data.fixed_assets);
			$("#linkman","#companyMap").val(data.linkman);
			$("#linkman_phone","#companyMap").val(data.linkman_phone);
			$("#cellphone","#companyMap").val(data.cellphone);
			$("#sgs_date","#companyMap").val(data.sgs_date);
			$("#enterprise_info","#companyMap").val(data.enterprise_info);
			var company_id =data.company_id; 
			var basedata = jcdpCallService("EquipmentSelectionApply", "getCompanyProEqu", "company_id="+company_id);
								 
			basedatas = basedata.deviceappMap;
			basedatass = basedata.strMap;
		   if(basedatas!=undefined && basedatas.length>=1){
					//先清空
				var filtermapid = "#peopleMap";
				$(filtermapid).empty();
				appendDataToPeopleTab(filtermapid,basedatas);
				
			}else{
				var filtermapid = "#peopleMap";
				$(filtermapid).empty();
				$(filterobj).attr("idinfo",ids);
				$(filterobj).attr("idinfo",ids);
			}
		   if(basedatass!=undefined && basedatass.length>=1){
			//设置当前标签页显示的主键
			var filtermapid = "#deviceMap";
			$(filtermapid).empty();
			appendDataToDeviceTab(filtermapid,basedatass);
			$(filterobj).attr("idinfo",ids);
			
		}else{
			var filtermapid = "#deviceMap";
			$(filtermapid).empty();
			$(filterobj).attr("idinfo",ids);
			$(filterobj).attr("idinfo",ids);
		 }
		}
		if(index == 2){
			//先清空
			var filtermapid = "#reviewMap";
			$(filtermapid).empty();
			var basedatas;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
		    	$.messager.alert("提示","请先选中一条记录!","warning");
	     		return;
		    }
		   var retObj;
			retObj = jcdpCallService("EquipmentSelectionApply", "getReviewInfo", "opi_id="+ids);
			$("#panel_idea").val(retObj.deviceappMap.panel_idea);
			$("#panel_principal").val(retObj.deviceappMap.panel_principal);
			$("#panel_review_date").datebox("setValue", retObj.deviceappMap.panel_review_date);
			$("#equipment_idea").val(retObj.deviceappMap.equipment_idea);
			$("#equipment_principal").val(retObj.deviceappMap.equipment_principal);
			$("#equipment_review_date").datebox("setValue", retObj.deviceappMap.equipment_review_date);
			var review_result = retObj.deviceappMap.review_result;
			if(review_result =='0'){
				$("#review_result").val('评审通过');
			}
			if(review_result =='1'){
				$("#review_result").val('评审未通过');
			}
			if(retObj.fdataPublic!=null){ 
				for (var tr_id = 1; tr_id<=retObj.fdataPublic.length; tr_id++) {
					if(retObj.fdataPublic[tr_id-1].file_type =="review_content"){
						var filtermapid = "#review_tablePublic";
						$(filtermapid).empty();
						insertFilePublicTestPS(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
						review_confirms_ps=1;
					}
				}
		}else{
			var filtermapid = "#reviewMap";
			$(filtermapid).empty();
			$(filterobj).attr("idinfo",ids);
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	/** 主要人员信息 */
	function appendDataToPeopleTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			if(datas[i].sex ==0){
				 datas[i].sex = '男' 
			}
			if(datas[i].sex ==1){
				 datas[i].sex = '女' 
			}
			if(datas[i].education ==0){
				 datas[i].education = '初中' 
			}
			if(datas[i].education ==1){
				 datas[i].education = '高中' 
			}
			if(datas[i].education ==2){
				 datas[i].education = '专科' 
			}
			if(datas[i].education ==3){
				 datas[i].education = '本科' 
			}
			if(datas[i].education ==4){
				 datas[i].education = '硕士' 
			}
			if(datas[i].education ==5){
				 datas[i].education = '本科' 
			}
			if(datas[i].job_type ==0){
				 datas[i].job_type = '固定' 
			}
			if(datas[i].job_type ==1){
				 datas[i].job_type = '聘用' 
			}
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].name+"</td><td>"+datas[i].sex+"</td>";
			innerHTML += "<td>"+datas[i].age+"</td>";
			innerHTML += "<td>"+datas[i].job_title+"</td><td>"+datas[i].education+"</td><td>"+datas[i].major+"</td>";
			innerHTML += "<td>"+datas[i].job_type+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	/** 主要设备信息信息 */
	function appendDataToDeviceTab(filterobj,datas){
	for(var i=0;i<datas.length;i++){
		var innerHTML = "<tr>";
		innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].device_name+"</td>";
		innerHTML += "<td>"+datas[i].model+"</td>";
		innerHTML += "<td>"+datas[i].vender+"</td>";
		innerHTML += "<td>"+datas[i].running_state+"</td>";
		innerHTML += "</tr>";
		$(filterobj).append(innerHTML);
	}
	$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
	$(filterobj+">tr:odd>td:even").addClass("odd_even");
	$(filterobj+">tr:even>td:odd").addClass("even_odd");
	$(filterobj+">tr:even>td:even").addClass("even_even");
}
		
	/* 产品基本信息*/
	function loadDataDetail(opi_id){  
    	var retObj;
		if(opi_id != null){
		retObj = jcdpCallService("EquipmentSelectionApply", "getProductInfo", "opi_id="+opi_id);
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.opi_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.opi_id+"']").removeAttr("checked");
		//给数据回填
		$("#opi_name","#scrapeMap").val(retObj.deviceappMap.opi_name);
		$("#brand","#scrapeMap").val(retObj.deviceappMap.brand);
		$("#production","#scrapeMap").val(retObj.deviceappMap.production);
		$("#last_year_yield","#scrapeMap").val(retObj.deviceappMap.last_year_yield);
		$("#product_info","#scrapeMap").val(retObj.deviceappMap.product_info);
		if(retObj.deviceappMap.apply_state=="1") {
			document.all.apply_state[1].checked = true;   
		}
		if(retObj.deviceappMap.apply_state=="0") {
			document.all.apply_state[0].checked = true;   
		}
		if(retObj.deviceappMap.apply_state=="2") {
			document.all.apply_state[2].checked = true;   
		}
		$("#apply_unit","#scrapeMap").val(retObj.deviceappMap.apply_unit);
		$("#apply_unit_reason","#scrapeMap").val(retObj.deviceappMap.apply_unit_reason);
		$("#principal","#scrapeMap").val(retObj.deviceappMap.principal);
		$("#approve_date","#scrapeMap").val(retObj.deviceappMap.approve_date);
		if(retObj.fdataPublic!=null){
			// 有附件不显示设备详情而是显示附件
			for (var tr_id = 1; tr_id<=retObj.fdataPublic.length; tr_id++) {
				if(retObj.fdataPublic[tr_id-1].file_type =="skill_parameter"){
					var filtermapid = "#file_skill_tablePublic";
					$(filtermapid).empty();
					insertFilePublicSkill(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="test_content"){
					var filtermapid = "#file_test_tablePublic";
					$(filtermapid).empty();
					insertFilePublicTest(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="user_prove_content"){
					var filtermapid = "#userProve_file_tablePublic";
					$(filtermapid).empty();
					insertFilePublicUser(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="production_file_content"){
					var filtermapid = "#production_file_tablePublic";
					$(filtermapid).empty();
					insertFilePublicProduction(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="other_file_content"){
					var filtermapid = "#other_file_tablePublic";
					$(filtermapid).empty();
					insertFilePublicOther(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="review_confirms_file_content"){
					var filtermapid = "#reviewConfirms_file_tablePublic";
					$(filtermapid).empty();
					insertFilePublicReview(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
			}
		  }
		}
    }
	 
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的测试使用报告文件文件
	function insertFilePublicTest(name,id){
		$("#file_test_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicUser(name,id){
		$("#userProve_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicProduction(name,id){
		$("#production_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicOther(name,id){
		$("#other_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicReview(name,id){
		$("#reviewConfirms_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的评审信息报告文件文件
	function insertFilePublicTestPS(name,id){
		$("#review_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	
	// 查询
	function searchDevData(){
		var apply_unit = document.getElementById("apply_unit").value;
		var opi_name = document.getElementById("opi_name").value;
		refreshData(apply_unit,opi_name);
	}
    function refreshData(apply_unit, opi_name){ 
      	var temp = "";
		if(typeof apply_unit!="undefined" && apply_unit!=""){
			temp += "&apply_unit="+apply_unit;
		}
		if(typeof opi_name!="undefined" && opi_name!=""){
			temp += "&opi_name="+opi_name;
		}
		cruConfig.submitStr = temp;	
		queryData(1);

	}
	// 清空
	function clearQueryText(){
		document.getElementById("apply_unit").value = "";
		document.getElementById("opi_name").value = "";
		refreshData("","");
		refreshData()
	}

	// 评审
	function toReview(){  
		var ids = getSelIds('selectedbox');
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一条记录!","warning");
     		return;
	    }
		baseData = jcdpCallService("EquipmentSelectionApply", "getReviewtUnit", "opi_id="+ids);
		if(baseData.deviceappMap.review_state=='评审未通过'){
			$.messager.alert("提示","您选择的记录中存在状态为'评审未通过'的单据,不能重复评审!","warning");
			return;
		}
		if(baseData.deviceappMap.review_state=='评审通过'){
			$.messager.alert("提示","您选择的记录中存在状态为'审批通过'的单据,不能重复评审!","warning");
			return;
		}
			refreshData();
			
		popWindowAuto('<%=contextPath%>/dmsManager/modelSelection/review.jsp?opi_id='+ids,'1080:680','');
	}
	
	$(document).ready(lashen);
</script>
</html>

