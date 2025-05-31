<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String repairInfo = request.getParameter("repair_info");
	String msFlag = request.getParameter("msflag");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>设备维修明细</title>
<style type="text/css">
	
.panel .inquire_item{
	text-align:right;
}
.inquire_form{
	width:150px;
}

.tab_line_height td{
 	border-color: #1C86EE;
 	border-style: dotted;
    border-width: 1px;
    margin: 0;
    padding: 0;
}
.tab_line_height{
 border-color: #1C86EE;
 border-style: dotted;
  border-width: 2px;
  margin: 0;
  padding: 0;
}
.panel .panel-body{
	font-size: 14px;
}
input,textarea{
	font-size: 14px;
}
</style>
</head>
<body>
   <input type="hidden" id="repair_info" value="<%=repairInfo %>"/>
   <input type="hidden" id="ms_flag" value="<%=msFlag %>"/>
   <div data-options="fit:true" class="easyui-panel" style="padding:10px;">
	<table id="detail" width="600" height="100" style="overflow:hidden;"  class="tab_line_height">
		<tr>
			<td class="inquire_item">设备名称：</td>
		    <td class="inquire_form" colspan="3"><input type="text" id="dev_name" class="input_width only_read basedet"/></td>
		    <td class="inquire_item">规格型号：</td>
		    <td class="inquire_form" colspan="3"><input type="text" id="dev_model" class="input_width only_read basedet"/></td>
			<td class="inquire_item">自编号：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="self_num" class="input_width only_read basedet"/></td>
		</tr>
		<tr>
		 	<td class="inquire_item">牌照号：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="license_num" class="input_width only_read basedet"/></td>
			<td class="inquire_item">实物标识号：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="dev_sign" class="input_width only_read basedet"/></td>
	    	<td class="inquire_item">ERP编号：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="dev_coding" class="input_width only_read basedet"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item">所属单位：</td>
	    	<td class="inquire_form" colspan="5"><input type="text" id="org_name" class="input_width only_read basedet"/></td>
	    	<td class="inquire_item">创建人：</td>
	    	<td class="inquire_form" colspan="5"><input type="text" id="employee_name" class="input_width only_read basedet"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item">修理类别：</td>
	   		<td class="inquire_form" colspan="3"><input type="text" id="repairtype" class="input_width only_read basedet"/></td>
		    <td class="inquire_item">修理级别：</td>
		    <td class="inquire_form" colspan="3"><input type="text" id="repairlevel" class="input_width only_read basedet"/></td>
		    <td class="inquire_item">修理项目：</td>
			<td class="inquire_form" colspan="3"><input type="text" id="repairitem" class="input_width only_read basedet"/></td>
	    </tr>	
	    <tr>
		    <td class="inquire_item">送修日期：</td>
		    <td class="inquire_form" colspan="3"><input type="text" id="repair_start_date"  class="input_width only_read basedet" /></td>
		    <td class="inquire_item">验收日期：</td>
		    <td class="inquire_form" colspan="3"><input type="text" id="repair_end_date" class="input_width only_read basedet" /></td>
		    <td class="inquire_item">工时费：</td>
	   		<td class="inquire_form" colspan="3"><input type="text" id="human_cost" class="input_width only_read basedet" /></td>	   
	    </tr>
	    <tr>	  		
	   		<td class="inquire_item">材料费：</td>
	   		<td class="inquire_form" colspan="3"><input type="text" id="material_cost" class="input_width only_read basedet" /></td>
	   		<td class="inquire_item">承修人：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="repairer"  class="input_width only_read basedet" /></td>
	    	<td class="inquire_item">验收人：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="accepter"  class="input_width only_read basedet" /></td>	
	    </tr>
	    <tr>
	    	<td class="inquire_item">单据状态：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="record_status_desc" class="input_width only_read basedet"/></td>
	    	<td class="inquire_item">数据来源：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="data_from_name" class="input_width only_read basedet"/></td>
	    	<td class="inquire_item">工单号：</td>
	    	<td class="inquire_form" colspan="3"><input type="text" id="aufnr" class="input_width only_read basedet"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item">项目描述：</td>
	    	<td class="inquire_form" colspan="10"><input type="text" id="project_name" class="input_width only_read basedet"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item">维修单位：</td>
	    	<td class="inquire_form" colspan="10"><input type="text" id="repair_postion" class="input_width only_read basedet"/></td>
	    </tr>
	    <tr> 
		   <td class="inquire_item">修理详情：</td>
		   <td class="inquire_form" colspan="10"><textarea style="height:160px;width:93%;" id="repair_detail" class="input_width only_read basedet"></textarea></td>
		</tr>	
	 </table>
</div>              
</body>
<script type="text/javascript">

$(function(){
	//设置样式
	$(".only_read").attr("readonly","true");
	$(".only_read").css("border","0").css("color","blue").css("background-color","transparent");
	
	$("#detail tr").each(function(index){
		if(index%2==0){
			$(this).addClass("datagrid-row-alt");
		}		
	});
	devRepairDetailInfo($("#repair_info").val(),$("#ms_flag").val());
});

//设备维修明细信息
function devRepairDetailInfo(repairinfo,msflag){
	if(repairinfo==""){
		 $(".basedet").each(function(){
			$("#"+this.id).val("");
		});
		return;
	 }
	 $.messager.progress({title:'请稍后',msg:'数据加载中....'}); 
	 $.ajax({
	        type: "POST",
	        url: '${pageContext.request.contextPath}/rm/dm/ajaxRetMapBySrvAndMethod.srq?JCDP_SRV_NAME=DevRepairSrv&JCDP_OP_NAME=getDevRepairMainInfo',
	        data:{"repairinfo":repairinfo,"msflag":msflag},
	        dataType:"json",
	        error: function(request) {
	        	$.messager.progress('close');
	        	$.messager.alert('提示','查询数据出错...','error');
	        },
	        success: function(ret) {
	        	$.messager.progress('close');
	        	var data = "";
	        	if(ret!=""){
	        		data = ret[0];
	        	}        		
	        	if(typeof data !="undefined" && data !=""){
	        		$(".basedet").each(function(){
	        			var temp = this.id;
	        			$("#"+this.id).val( typeof data[temp] != "undefined" ? data[temp]:"");
	        		});
	        	}else{
	        		$(".basedet").each(function(){
	        			$("#"+this.id).val("");
	        		});
	        	}
	       }
	 });
}
</script>
</html>
