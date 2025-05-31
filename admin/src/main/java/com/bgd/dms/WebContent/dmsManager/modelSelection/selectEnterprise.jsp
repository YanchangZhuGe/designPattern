<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	String deviceappid = request.getParameter("deviceappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String addUpFlag = request.getParameter("addupflag");
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String company_id = request.getParameter("company_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>

<title>企业基本信息</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData(),loadDataDetail(<%=company_id%>);">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data" >
<div id="new_table_box_bg">  
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
			 </tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
      </div>
		<div id="table_box">
			<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='company_id_{company_id}' name='company_id'  idinfo='{company_id}'>
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{company_id}' id='selectedbox_{company_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1" >序号</td> 
					<td class="bt_info_odd" exp="{enterprise_name}">企业名称</td>
					<td class="bt_info_even" exp="{company_type}">企业类型</td>
					<td class="bt_info_odd" exp="{legal_person}">法定代表人</td>
					<td class="bt_info_even" exp="{registered_capital}">注册资本</td>
					<td class="bt_info_odd" exp="{work_force}">员工总数</td>
					<td class="bt_info_even" exp="{production_capactity}">生产能力</td>
					<td class="bt_info_odd" exp="{company_address}">通讯地址</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">企业基本信息</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
		  <div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
			<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
				<tr style="text-align: left">
				  <td class="inquire_item6">&nbsp;企业名称</td>
				  <td class="inquire_form6"><input name ="enterprise_name" id="enterprise_name" class="input_width" type="text" value="" disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;法定代表人</td>
				  <td class="inquire_form6"><input name="legal_person" id="legal_person" class="input_width" type="text" value="" disabled="disabled"/></td>
			 	  <td class="inquire_item6">&nbsp;通讯地址</td>
				  <td class="inquire_form6"><input name="company_address" id="company_address" class="input_width" type="text" value="" disabled="disabled"/></td>
			  </tr>
			  <tr>
				  <td class="inquire_item6">&nbsp;邮编</td>
				  <td class="inquire_form6"><input name="postalcode" id="postalcode" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;企业类型</td>
				  <td class="inquire_form6"><input name="company_type" id="company_type" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;注册资本</td>
				  <td class="inquire_form6"><input name="registered_capital" id="registered_capital" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  </tr>
			  <tr>
				  <td class="inquire_item6">&nbsp;生产能力</td>
				  <td class="inquire_form6"><input name="production_capactity" id="production_capactity" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;职工总数</td>
				  <td class="inquire_form6"><input name="work_force" id="work_force" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;上年总产值</td>
				  <td class="inquire_form6"><input name="lastyear_total_value" id="lastyear_total_value" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  </tr>
			  <tr>
				  <td class="inquire_item6">&nbsp;固定资产</td>
				  <td class="inquire_form6"><input name="fixed_assets" id="fixed_assets" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;联系人</td>
				  <td class="inquire_form6"><input name="linkman" id="linkman" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6">&nbsp;联系电话</td>
				  <td class="inquire_form6"><input name="linkman_phone" id="linkman_phone" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  </tr>
			  <tr>
				  <td class="inquire_item6">&nbsp;手机</td>
				  <td class="inquire_form6"><input name="cellphone" id="cellphone" class="input_width" type="text" value=""  disabled="disabled"/></td>
				  <td class="inquire_item6" align="center">&nbsp;体系管理认证标准、时间</td>
				  <td class="inquire_form6"><input name="sgs_date" id="sgs_date" class="input_width" type="text" value="" disabled="disabled" /></td>
			  </tr>
			   <tr>
		   		<td class="inquire_item6">&nbsp;企业简介：</td>
		   		<td colspan="2" class="inquire_form6"><textarea id="enterprise_info" name="enterprise_info"  class="textarea" style="width:100%;height:40px" disabled="disabled"></textarea></td>
			  </tr>
		</table>
	   </div>
	 </div>
	</div>
	  <div id="oper_div" style="text-align: center;">
	     	<span class="tj_btn"><a href="#" onclick="saveInfo()"></a></span>
	        <span class="gb_btn"><a href="#" onclick="window.close()"></a></span>
   		</div>	
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "queryRetTable";
	cruConfig.queryService = "ModelApply";
	cruConfig.queryOp = "queryEquipmentInfoList";

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
		var ids = getSelIds('selectedbox');
	 	var retObj;  
		   retObj = jcdpCallService("EquipmentSelectionApply", "getEquipmentInfo", "company_id="+ids);
		   basedatas = retObj.datas;
		$(filtermapid).empty();
		$(filternotobj).hide();
		$(filterobj).show();
	} 
	
	  function loadDataDetail(company_id){   
	    	var retObj;
			if(company_id!=null){
				 retObj = jcdpCallService("EquipmentSelectionApply", "getEquipmentInfo", "company_id="+company_id);
			//选中这一条checkbox
			$("#selectedbox_"+retObj.deviceappMap.company_id).attr("checked","checked");
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.company_id+"']").removeAttr("checked");
			//给数据回填
			$("#enterprise_name","#scrapeMap").val(retObj.deviceappMap.enterprise_name);
			$("#legal_person","#scrapeMap").val(retObj.deviceappMap.legal_person);
			$("#company_address","#scrapeMap").val(retObj.deviceappMap.company_address);
			$("#postalcode","#scrapeMap").val(retObj.deviceappMap.postalcode);
			$("#company_type","#scrapeMap").val(retObj.deviceappMap.company_type);
			$("#registered_capital","#scrapeMap").val(retObj.deviceappMap.registered_capital);
			$("#production_capactity","#scrapeMap").val(retObj.deviceappMap.production_capactity);
			$("#work_force","#scrapeMap").val(retObj.deviceappMap.work_force);
			$("#lastyear_total_value","#scrapeMap").val(retObj.deviceappMap.lastyear_total_value);
			$("#fixed_assets","#scrapeMap").val(retObj.deviceappMap.fixed_assets);
			$("#linkman","#scrapeMap").val(retObj.deviceappMap.linkman);
			$("#linkman_phone","#scrapeMap").val(retObj.deviceappMap.linkman_phone);
			$("#cellphone","#scrapeMap").val(retObj.deviceappMap.cellphone);
			$("#sgs_date","#scrapeMap").val(retObj.deviceappMap.sgs_date);
			$("#enterprise_info","#scrapeMap").val(retObj.deviceappMap.enterprise_info);
			}
	    }
	
	  function chooseOne(cb){   
	        var obj = document.getElementsByName("selectedbox");  
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
	
	// 添加厂家
	function toAdd(){
		popWindow("<%=contextPath%>/dmsManager/modelSelection/enterpriseInformationAdd.jsp");
	}
	
	function refreshData(){		
		var temp = ""; 
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	
	/*提交回来数据*/
	function saveInfo(){
		var baseData;
		var ids = getSelIds('selectedbox');
		var enterprise_name = getSelIds('enterprise_name');
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一条记录!","warning");
     		return;
	    }
	    var selectedids = "";
		var retObj;  
		retObj = jcdpCallService("EquipmentSelectionApply", "getEquipmentInfo", "company_id="+ids);
	    selectedids += ids;
		selectedids +="~"+retObj.deviceappMap.enterprise_name;
		window.returnValue = selectedids;
		window.close();
	}
	
	
	$(document).ready(lashen); 
</script>
</html>

