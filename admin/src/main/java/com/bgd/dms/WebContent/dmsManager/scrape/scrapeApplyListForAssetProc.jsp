<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String scrape_apply_id=request.getParameter("scrape_apply_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>固定资产报废设备审批</title> 
 </head> 
 <body style="background:#cdddef;overflow:auto" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<input name="expert_members" id="expert_members"  class="input_width" type="hidden" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
        <tr>
          <td class="inquire_item4">报废申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="scrape_apply_name" id="scrape_apply_name" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废申请单号:</td>
          <td class="inquire_form4">
          	<input name="scrape_apply_no" id="scrape_apply_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="" readonly/> 
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
      
         <fieldSet style="margin-left:2px"><legend>固定资产设备报废明细</legend>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even">设备编号</td>
					<td class="bt_info_even">报废原因</td>
					<td class="bt_info_even">备注</td>
				</tr>
				</table>
			   <div style="height:190px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
       <fieldSet style="margin:2px:padding:2px;"><legend>固定资产报废申请单</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">资产现状描述:</td>
          <td class="inquire_form4" colspan="3">
            <textarea id="asset_now_desc" name="asset_now_desc"  class="textarea" ></textarea>			  
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废原因:</td>
          <td class="inquire_form4" colspan="3">
       <textarea id="scrape_reason" name="scrape_reason"  class="textarea" ></textarea>
          </td>
        </tr>
           <tr>
          <td class="inquire_item4">技术鉴定意见:</td>
          <td class="inquire_form4" colspan="3">
          <textarea id="expert_desc" name="expert_desc"  class="textarea" ></textarea>
          </td>
        </tr>
           <tr>
          <td class="inquire_item4">鉴定小组组长:</td>
          <td class="inquire_form4" >
          	<input id="expert_leader" name="expert_leader" class="input_width" type="text" onkeyup='copyexpert()'/>
          </td>
              <td class="inquire_item4">鉴定日期:</td>
          <td class="inquire_form4" >&nbsp;
          	<input name="appraisal_date" class="input_width" type="text"  value="" />
          
          	<img src="/DMS/images/calendar.gif" id="tributton1" width="16" height="16" style='cursor: hand;'
					onmouseover="calDateSelector(appraisal_date,tributton1);" />
          </td>
        </tr>
      </table>    
      </fieldSet>
       <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td>&nbsp;</td>
		    	<td class='ali_btn'><span class='zj'><a href='#' onclick='addrow()'  title='增加'></a></span></td>
		    	<td class='ali_btn'><span class='sc'><a href='#' onclick='removrow()'  title='删除'></a></span></td>
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>鉴定小组成员</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body">
		  		<tr>
			  		<td class="inquire_item6">鉴定人员</td>
					<td class="inquire_form6">
						<input name="expert_members1" id="expert_members1"  class="input_width" type="text" readonly />
					</td>
				</tr>
			</tbody>
	  	</table>
	  </fieldset>
	   
      
    </div>

  </div>
</div>
</form>
 	
</body>
<script type="text/javascript">
	function refreshData(){
		var baseData;
		if('<%=scrape_apply_id%>'!='null'){
			baseData = jcdpCallService("ScrapeSrv", "getScrapeAssetInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
			$("#scrape_apply_no").val(baseData.deviceAssetMap.scrape_apply_no);
			$("#scrape_asset_id").val(baseData.deviceAssetMap.scrape_asset_id);
			$("#scrape_apply_name").val(baseData.deviceAssetMap.scrape_apply_name);
			$("#apply_date").val(baseData.deviceAssetMap.apply_date);
			$("#asset_now_desc").val(baseData.deviceAssetMap.asset_now_desc);
			$("#scrape_reason").val(baseData.deviceAssetMap.scrape_reason);
			$("#expert_desc").val(baseData.deviceAssetMap.expert_desc);
			$("#expert_leader").val(baseData.deviceAssetMap.expert_leader);
			$("#expert_members1").val(baseData.deviceAssetMap.expert_leader);
			$("#appraisal_date").val(baseData.deviceAssetMap.appraisal_date);
			$("#expert_members").val(baseData.deviceAssetMap.expert_members);
			if(baseData.datas!=null)
			{
			for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+baseData.datas[tr_id].foreign_dev_id+"' size='16'  type='hidden' />";
				innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
				innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
				innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
				innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
				innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td width='27%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='20' type='text' readonly />";
				innerhtml += "</td>"
				innerhtml += "<td width='17%'><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='20'  type='text' readonly /></td>";
				innerhtml += "<td width='17%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+baseData.datas[tr_id].dev_type+"' size='25' type='text' readonly/>";
				if(baseData.datas[tr_id].scrape_type==0)
					{
					innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option  value='0' selected >正常报废</option><option value='1'>技术淘汰</option></select></td>";
					}
				if(baseData.datas[tr_id].scrape_type==1)
				{
				innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option  value='0'  >正常报废</option><option value='1' selected>技术淘汰</option></select></td>";
				}
				
				innerhtml += "<td width='9%'><input name='bak"+tr_id+"' id='bak"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[tr_id].bak1+"' /></td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
				}
		
			$("#colnum").val(baseData.datas.length);
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
			}
			var str=$("#expert_members").val();
			var strs= new Array(); //定义一数组 
			strs=str.split(","); //字符分割 
			optnum=strs.length;
			for (i=2;i<strs.length+1 ;i++ ) 
			{ 
				var newTr=OPERATOR_body.insertRow();
				var newTd=newTr.insertCell();
				newTd.className="inquire_item6";
				newTd.innerHTML="鉴定人员"+i;
				var newTd=newTr.insertCell();
				newTd.className="inquire_form6";
				newTd.innerHTML="<input name=expert_members"+i+" id=expert_members"+i+"  class=input_width type=text value="+strs[i-1]+" />";
			} 
		}
	}
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		var scrape_apply_id=document.getElementById("scrape_apply_id").value;
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/checkScrapeApplyInfo.srq?scrapeApplyId="+scrape_apply_id+"&oprstate="+oprstate;
		alert(document.getElementById("form1").action);
		document.getElementById("form1").submit();
		window.setTimeout(function(){window.close();},2000);
	}
	
</script>
<script type="text/javascript">
	
	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
	}
	$(document).ready(lashen);
</script>
</html>