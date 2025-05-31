<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dispose_apply_id=request.getParameter("dispose_apply_id");
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
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    <fieldSet style="margin:2px:padding:2px;"><legend>报废处置申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="dispose_apply_id" id="dispose_apply_id" type="hidden" value="<%=dispose_apply_id%>" />
      		<input name="disfiles" id="disfiles" type="hidden" value=""/>
        <tr>
          <td class="inquire_item4">报废处置申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="app_name" id="app_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废处置申请单号:</td>
          <td class="inquire_form4">
          	<input name="app_no" id="app_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
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
        <fieldSet style="margin-left:2px"><legend>设备报废处置明细</legend>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
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
					<td class="bt_info_even">原值</td>
					<td class="bt_info_even">报废日期</td>
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
       <fieldSet style="margin:2px:padding:2px;"><legend>其他说明</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">备注:</td>
          <td class="inquire_form4" colspan="3">
            <textarea id="bak" name="bak"  class="textarea" ></textarea>			  
          </td>
        </tr>
            <tr>
          	<table style="margin-left:40px;">
			<tr >
				<td>&nbsp;</td>
				
			</tr>
		</table>
			<table id="file_table6" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
        </tr>
      </table>    
      </fieldSet>
	</div>
    </div>	
    </div>
    		
  </div>
</div>
</form>
 	
</body>
<script type="text/javascript">
function refreshData(){
	var baseData;
	if('<%=dispose_apply_id%>'!='null'){
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeInfo", "dispose_apply_id="+$("#dispose_apply_id").val());
		$("#app_no").val(baseData.deviceMap.app_no);
		$("#app_name").val(baseData.deviceMap.app_name);
		$("#apply_date").val(baseData.deviceMap.apply_date);
		$("#bak").val(baseData.deviceMap.bak);
		$("#disfiles").val(baseData.deviceMap.disfiles);
		if(baseData.datas!=null)
		{
		var datas = baseData.datas;
		for (var i = 0; i< datas.length; i++) {
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_type+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td>";
			innerHTML += "<td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].producting_date+"</td>";
			innerHTML += "<td>"+datas[i].org_name+"</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>1</td>";
			innerHTML += "<td>"+datas[i].asset_value+"</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>"+datas[i].net_value+"</td>";
			if(datas[i].scrape_type=="0"){
				innerHTML += "<td>正常报废</td>";
			}else if(datas[i].scrape_type=="1"){
				innerHTML += "<td>技术淘汰</td>";
			}else if(datas[i].scrape_type=="2"){
				innerHTML += "<td>毁损</td>";
			}else if(datas[i].scrape_type=="3"){
				innerHTML += "<td>盘亏</td>";
			}
			innerHTML += "<td>/</td>";
			innerHTML += "</tr>";
			$("#processtable0").append(innerHTML);
			}
	
		$("#colnum").val(baseData.datas.length);
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
		}
		if(baseData.fdata!=null)
		{
		$("#file_table6").empty();
		for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
			insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id);
		}
		}
		
	}
}
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
			var dispose_apply_id=document.getElementById("dispose_apply_id").value;
			 baseData = jcdpCallService("ScrapeSrv", "checkDisposeInfo", "disposeApplyId="+dispose_apply_id);
		}else{
			oprstate = "notPass";
		}
		document.getElementById("form1").action = "<%=contextPath%>/bpm/common/toDoProcessInfo.srq";
		document.getElementById("form1").submit();
		window.setTimeout(function(){window.close();},2000);
	}
	
	//插入文件
	function insertFile(name,type,id){
		
			$("#file_table6").append(
						"<tr>"+
						"<td class='inquire_form5'>附件:</td>"+
		      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
						"</tr>"
				);
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