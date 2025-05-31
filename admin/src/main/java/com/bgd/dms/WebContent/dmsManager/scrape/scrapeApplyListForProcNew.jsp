<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
    
  	String scrape_apply_id = request.getParameter("scrape_apply_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<title>报废申请表</title>
<style type="text/css">
#new_table_box_content {
width:auto;
height:620px;
border:1px #999 solid;
background:#cdddef;
padding:15px;
}
#new_table_box_bg {
width:auto;
height:487px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
.mytextarea {
	FONT-SIZE: 12px;
	COLOR: #333333;
	FONT-FAMILY:"微软雅黑";
	background:#FFF;
	line-height: 20px;
	border:1px solid #a4b2c0;
	height: 30px;
	width: 91.5%;
	margin-bottom:1px;
	margin-top:1px;
	word-break:break-all;
}
.textarea_no_color {
	FONT-SIZE: 12px;
	COLOR: #333333;
	FONT-FAMILY:"微软雅黑";
	background:#efefef;
	line-height: 20px;
	border:1px solid #a4b2c0;
	height: 20px;
	width: 99%;
	margin-bottom:1px;
	margin-top:1px;
	word-break:break-all;
}
.inquire_form2 {
	text-align:left;
	width:35%;
	padding:0 5px;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
        <input name="scrape_asset_id" id="scrape_asset_id" type="hidden" />
        <input name="expert_members" id="expert_members"  class="input_width" type="hidden" />
        <input name="scrape_damage_id" id="scrape_damage_id" type="hidden" />
        <input name="colnumdamage" id="colnumdamage" class="input_width" type="hidden" value="" readonly/>
      	<input name="parmeterdamage" id="parmeterdamage" type="hidden" value=""/>
      	<input name="expert_ids" id="expert_ids"  class="input_width" type="hidden" />
      	<input name="employee_names" id="employee_names"  class="input_width" type="hidden" />
      	<input name="employee_ids" id="employee_ids"  class="input_width" type="hidden" />
        <tr>
          <td class="inquire_item6">报废申请单名称:</td>
          <td class="inquire_form6" colspan="2">
          	<input name="scrape_apply_name" id="scrape_apply_name" class="input_width" type="text" value="" />
          </td>
          <td class="inquire_item6">申请单位名称:</td>
          <td class="inquire_form6" colspan="2">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item6">报废申请单号:</td>
          <td class="inquire_form6">
          	<input name="scrape_apply_no" id="scrape_apply_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item6">申请时间:</td>
          <td class="inquire_form6">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
          <td class="inquire_item6">申请人:</td>
          <td class="inquire_form6">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
      <!-- add by zzb -->
      <fieldSet style="margin-left:2px"><legend>固定资产设备报废明细</legend>
      	  <input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      	  <input name="parmeter" id="parmeter" type="hidden" value=""/>
	  	 <%--  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<td class="ali_cdn_name" ><a href="javascript:downloadModel('scrape_model','固定资产设备报废明细')">报废模板</a></td>
			    	<auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd(1)'" title="导入设备"></auth:ListButton>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRowsasset(2)'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRowsasset(2)'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div> --%>
		  <div style="overflow:auto">
		  	  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tableAsset">
				<input name="flag_asset" id="flag_asset" type="hidden"/>
				</table>
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >AMIS资产编码</td>
					<td class="bt_info_even">ERP设备编码</td>
					<td class="bt_info_odd">报废原因</td>
					<td class="bt_info_even">备注</td>
					<!-- <td class="bt_info_odd">审批意见</td>
					<td class="bt_info_even">审批备注</td> -->
				</tr>
				</table>
			   <div style="height:80px;overflow:auto;">
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
          <td class="inquire_form4" colspan="1">
            <textarea id="asset_now_desc" name="asset_now_desc"  class="mytextarea" ></textarea>			  
          </td>
          <td class="inquire_item4">报废原因:</td>
          <td class="inquire_form4" colspan="1">
       <textarea id="scrape_reason" name="scrape_reason"  class="mytextarea" ></textarea>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">技术鉴定意见:</td>
          <td class="inquire_form4" colspan="1">
          <textarea id="expert_desc" name="expert_desc"  class="mytextarea" ></textarea>
          </td>
          <td class="inquire_item4">鉴定日期:</td>
          <td class="inquire_form4" >&nbsp;
          	<input id="appraisal_date" name="appraisal_date" class="input_width" type="text"  value="<%=nowTime%>" />
          
          	<img src="/DMS/images/calendar.gif" id="tributton1" width="16" height="16" style='cursor: hand;'
					onmouseover="calDateSelector(appraisal_date,tributton1);" />
          </td>
        </tr>
      </table>    
      </fieldSet>
       <div style="overflow:auto">
      	
	  </div>
	  <fieldset><legend>鉴定小组成员</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body">
			</tbody>
	  	</table>
	  </fieldset>
	  <fieldSet style="margin-left:2px"><legend>盘亏、毁损设备报废明细</legend>
	  	  <%-- <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<td class="ali_cdn_name" ><a href="javascript:downloadModel('scrape_modeldamage','损毁盘亏设备报废明细')">报废模板</a></td>
			    	<auth:ListButton functionId="" css="dr" event="onclick='excelDataAddDamage(1)'" title="导入设备"></auth:ListButton>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRowsdamages(2)'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRowsdamages(2)'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div> --%>
		  <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirecheckeddamage'name='hirecheckeddamage'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >AMIS资产编码</td> 
					<td class="bt_info_even">ERP设备编码</td>
					<td class="bt_info_odd">报废原因</td>
					<td class="bt_info_even">备注</td>
				</tr>
				</table>
				<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tableDamage">
				<input name="flag_damage" id="flag_damage" type="hidden"/>
				</table>
			   <div style="height:80px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable1" name="processtable1" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
       <fieldSet style="display:none;margin:2px:padding:2px;"><legend>盘亏、毁损报废申请单</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      <tr>
      	<td class="inquire_form2">
      		<table>
		      	<tr>
		            <td class="inquire_item4">专业化服务设备:</td>
		          	<td class="inquire_item4" align="left"> 是 
					 <input type="radio" name="specialized_unit_flag" value="0" id="specialized_unit_flag1" />
					</td>
				 	<td class="inquire_item4"> 否
					 <input type="radio" name="specialized_unit_flag" value="1" id="specialized_unit_flag2" />  		
					</td>
				</tr>
				<tr>
				   <td class="inquire_item4" >其他单位设备:</td>
		           <td class="inquire_item4" align="left"> 是 
					 <input type="radio" name="else_unit_flag" value="0" id="else_unit_flag1" />
				   </td>
				   <td class="inquire_item4"> 否
					 <input type="radio" name="else_unit_flag" value="1" id="else_unit_flag2" />  		
				   </td>	
				 </tr>
				 <tr>		    
		          	<td class="inquire_item4">损失原因:</td>
		         	<td class="inquire_form4" colspan="2" >
		              <textarea id="loss_reason" name="loss_reason"  class="textarea" ></textarea>
		          	</td>
		          </tr>
		       </table>
          </td>
        <td class="inquire_form2"><table>
         <tr id="proof_file_tr">
            <td class="inquire_item8">证明材料:</td>
			    <td class="inquire_item4" colspan="2">
	<input type="file" name="proof_file_" id="proof_file_" value="" class="input_width" onchange='getFileInfo(this,"proof_file")'  />
			    	<input type="hidden" id="proof_file" name="proof_file" value=""/>
			    	</td>
        </tr>
          <tr  id="payment_proof_file_tr"> 
          	 <td class="inquire_item8">赔付证明:</td>
			    <td class="inquire_item4" colspan="2">
	<input type="file" name="payment_proof_file_" id="payment_proof_file_" value="" class="input_width" onchange='getFileInfo(this,"payment_proof_file")' />
			    	<input type="hidden" id="payment_proof_file" name="payment_proof_file" value=""/>
			    	</td>
        </tr>
        <tr id="dev_photo_file_tr">
              	 <td class="inquire_item8">毁损设备照片:</td>
			    <td class="inquire_item4" colspan="2">
	<input type="file" name="dev_photo_file_" id="dev_photo_file_" value="" class="input_width"  onchange='getFileInfo(this,"dev_photo_file")'/>
			    	<input type="hidden" id="dev_photo_file" name="dev_photo_file" value=""/>
			    	</td>
        </tr>
			<tr id="person_handling_file_tr">
				     <td class="inquire_item8">责任人处理:</td>
			    <td class="inquire_item4" colspan="2">
	<input type="file" name="person_handling_file_" id="person_handling_file_" value="" class="input_width"  onchange='getFileInfo(this,"person_handling_file")' />
			    	<input type="hidden" id="person_handling_file" name="person_handling_file" value=""/>
			    	</td>
			</tr>
			</table></td>
			</tr>
		</table>
      </fieldSet>
      <fieldSet style="margin:2px:padding:2px;"><legend>其他说明</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">其他说明:</td>
          <td class="inquire_form4" colspan="3">
           <textarea id="bak" name="bak"  class="textarea" ></textarea>
          </td>
        </tr>
        <tr>
         <table style="margin-left:40px;">
			<tr >
				<td>&nbsp;</td>
				<td colspan="1" ><span style="font-size:12px;">添加附件</span></td>
				<td class='ali_btn' colspan="2" rowspan="3"><span class='zj'><a href='javascript:void(0);' onclick='insertTrOther("file_table6")'  title='添加'></a></span></td>
			</tr>
		</table>
			<table id="file_table6" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
        </tr>
      </table>    
      </fieldSet>
      <!-- add by zzb -->
    </div>
    <div id="oper_div">
     	<!-- <span class="tj_btn"><a href="#" onclick="saveInfo()"></a></span> -->
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
//add by zzb
var flag_asset = 0;//固定资产附件标示
var flag_damage = 0;//毁损附件标示
var flag_asset_time=0;
var flag_damage_time=0;
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfoasset']").attr('checked',checkvalue);
	});
	$("#hirecheckeddamage").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfodamage']").attr('checked',checkvalue);
	});
});
function addRowsasset(status){
	//flag_asset 0 默认值、1附件导入2手动添加
	if(flag_asset!=1){
		flag_asset = status;
		addRows();
	}else{
		alert("您已经选择导入设备，不能同时选择添加设备！！");
		return ;
	}
};
function addRows(){
	tr_id = $("#processtable0>tr:last").attr("id");
	if(tr_id != undefined){
		tr_id = parseInt(tr_id.substr(2,1),10);
	}
	if(tr_id == undefined){
		tr_id = 0;
	}else{
		tr_id = tr_id+1;
	}
	$("#colnum").val(tr_id);
	//动态新增表格
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml += "<input name='detdev_ci_code_asset"+tr_id+"' id='detdev_ci_code_asset"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<td><input type='checkbox' name='idinfoasset' id='"+tr_id+"' checked/></td>";
	innerhtml += "<td width='27%'><input name='dev_name_asset"+tr_id+"' id='dev_name_asset"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePageasset("+tr_id+")' />";
	innerhtml += "</td>"
	innerhtml += "<td width='17%'><input name='asset_coding_asset"+tr_id+"' id='asset_coding_asset"+tr_id+"' value='' size='16'  type='text' readonly /></td>";
	innerhtml += "<td width='17%'><input name='dev_coding_asset"+tr_id+"' id='dev_coding_asset"+tr_id+"' value='' size='16' type='text' readonly/>";
	innerhtml += "<td width='17%'><select name='scrape_type_asset"+tr_id+"' id='scrape_type_asset"+tr_id+"'><option  value='0'>正常报废</option><option value='1'>技术淘汰</option></select></td>";
	innerhtml += "<td width='9%'><input name='bak_asset"+tr_id+"' id='bak_asset"+tr_id+"' value='' size='9'  type='text' /></td>";
	/* innerhtml += "<td width='17%'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0'>同意</option><option value='1'>不同意</option></select></td>";
	innerhtml += "<td width='9%'><input name='sp_bak_asset"+tr_id+"' id='sp_bak_asset"+tr_id+"' value='' size='9'  type='text' /></td>"; */
	innerhtml += "</tr>";
	$("#processtable0").append(innerhtml);
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
};
function delRowsasset(status){
	//flag_asset 0 默认值、1附件导入2手动添加
	if(flag_asset!=1){
		flag_asset = status;
		delRows();
	}else{
		alert("您已经选择导入设备，不能同时选择删除设备！！");
		return ;
	}
}
function delRows(){
$("input[name='idinfoasset']").each(function(i){
	if(this.checked == true){
		if(i==0){
			flag_asset = i;
		}
		$('#tr'+this.id,"#processtable0").remove();
	}
});
$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
$("#processtable0>tr:odd>td:even").addClass("odd_even");
$("#processtable0>tr:even>td:odd").addClass("even_odd");
$("#processtable0>tr:even>td:even").addClass("even_even");
};
function showDevCodePageasset(index){
var obj = new Object();
var pageselectedstr = null;
var checkstr = 0;
$("input[name^='detdev_ci_code_asset'][type='hidden']").each(function(i){
	if(this.value!=null&&this.value!=''){
		if(checkstr == 0){
			pageselectedstr = "'"+this.value;
		}else{
			pageselectedstr += "','"+this.value;
		}
		checkstr++;
	}
});
if(pageselectedstr!=null){
	pageselectedstr = pageselectedstr + "'";
}
obj.pageselectedstr = pageselectedstr;
var returnval = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectAllAccountForMix.jsp",obj,"dialogWidth=950px;dialogHeight=480px");
//返回信息是  类别id + ERP设备编码 + 设备名称 + AMIS资产编码
if(returnval!=undefined){
	var returnvals = returnval.split("~",-1);
	$("#dev_name_asset"+index).val(returnvals[2]);
	$("#asset_coding_asset"+index).val(returnvals[3]);
	$("#detdev_ci_code_asset"+index).val(returnvals[0]);
	$("#dev_coding_asset"+index).val(returnvals[1]);
}
}
function showDevCodePagedamage(index){
	var obj = new Object();
	var pageselectedstr = null;
	var checkstr = 0;
	$("input[name^='detdev_ci_code_damage'][type='hidden']").each(function(i){
		if(this.value!=null&&this.value!=''){
			if(checkstr == 0){
				pageselectedstr = "'"+this.value;
			}else{
				pageselectedstr += "','"+this.value;
			}
			checkstr++;
		}
	});
	if(pageselectedstr!=null){
		pageselectedstr = pageselectedstr + "'";
	}
	obj.pageselectedstr = pageselectedstr;
	var returnval = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectAllAccountForMix.jsp",obj,"dialogWidth=950px;dialogHeight=480px");
	//返回信息是  类别id + ERP设备编码 + 设备名称 + AMIS资产编码
	if(returnval!=undefined){
		var returnvals = returnval.split("~",-1);
		$("#dev_name_damage"+index).val(returnvals[2]);
		$("#asset_coding_damage"+index).val(returnvals[3]);
		$("#detdev_ci_code_damage"+index).val(returnvals[0]);
		$("#dev_coding_damage"+index).val(returnvals[1]);
	}
	}
var optnum=1;
function addrow(obj)
{

	optnum++;
//var newTr=OPERATOR_body.insertRow();
var newTr=OPERATOR_body.rows[0];
var newTd=newTr.insertCell();
newTd.innerHTML="鉴定人员"+optnum;
var newTd=newTr.insertCell();
if(obj==undefined){
	newTd.innerHTML="<input name=expert_members"+optnum+" id=expert_members"+optnum+"  class=input_width type=text />";
}else{
	newTd.innerHTML="<input name=expert_members"+optnum+" id=expert_members"+optnum+"  class=input_width type=text value='"+obj.label+"'  />";
}
}
function removrow(){
if(optnum>1){
	$("#OPERATOR_body  tr td:last").remove(); 
	$("#OPERATOR_body  tr td:last").remove(); 
	optnum--;
}
}

function copyexpert()
{
$("#expert_members1").val($("#expert_leader").val());
}
//add by zzb
	<%-- function saveInfo(){

		$("#scrape_apply_no").val("");
		if($("#scrape_apply_name").val()==""){
			alert("报废申请单名称不能为空!");
			return;
		}
		if($("#apply_date").val()==""){
			alert("申请日期不能为空!");
			return;
		}
		//固定资产部分开始
		var wrong="";
		for(var num=2;num<=optnum;num++){
			if($("#expert_members"+num+"").val()== undefined || $("#expert_members"+num+"").val()== ""){
				wrong=num;
			}
		}
		if(wrong!=""){
			alert("鉴定成员"+wrong+"不能为空!");
			return;
		}
		var text=$("#expert_members1").val();
		if(optnum>1){
			text=text+",";
		}
		for(var num=2;num<=optnum;num++){
			if(num==optnum){
				text=text+$("#expert_members"+num+"").val();
			}else{	
				text=text+$("#expert_members"+num+"").val()+",";
			}
		}
		$("#expert_members").val(text);
		$("#flag_asset").val(flag_asset);
		//保留的行信息
		if(flag_asset != 1){
			var count = 0;
			var result= 0;
			var line_infos;
			var idinfos ;
			var text1="";
			$("input[type='checkbox'][name='idinfoasset']").each(function(){
				text1=text1+","+this.id;
				if(this.checked){
					if(count == 0){
						line_infos = this.id;
						idinfos = this.value;
					}else{
						line_infos += "~"+this.id;
						idinfos += "~"+this.value;
					}
					count++;
				}
				result++;
			});
			if(count == 0){
				alert('请选择设备固定资产明细信息！');
				return;
			}
			$("#colnum").val(result-1);
			if (text1.substr(0,1)==',') text1=text1.substr(1);
			$("#parmeter").val(text1);
			var selectedlines = line_infos.split("~");
			var wronglineinfos = "";
			for(var index=0;index<selectedlines.length;index++){
				var valueinfo = $("#detdev_ci_code_asset"+selectedlines[index]).val();
				if(valueinfo == ""){
					if(index == 0){
						wronglineinfos += (parseInt(selectedlines[index])+1);
					}else{
						wronglineinfos += ","+(parseInt(selectedlines[index])+1);
					}
				}
			}
			if(wronglineinfos!=""){
				alert("请选择第"+wronglineinfos+"行设备明细信息!");
				return;
			}
		}
		//固定资产部分结束
		//折损部分开始
		//保留的行信息
		$("#flag_damage").val(flag_damage);
		//保留的行信息
		if(flag_damage != 1){
		var countdamage = 0;
		var resultdamage= 0;
		var line_infosdamage;
		var idinfosdamage ;
		var textdamage="";
		$("input[type='checkbox'][name='idinfodamage']").each(function(){
			textdamage=textdamage+","+this.id;
			if(this.checked){
				if(count == 0){
					line_infosdamage = this.id;
					idinfosdamage = this.value;
				}else{
					line_infosdamage += "~"+this.id;
					idinfosdamage += "~"+this.value;
				}
				countdamage++;
			}
			resultdamage++;
		});
		if(countdamage == 0){
			alert('请选择毁损设备明细信息！');
			return;
		}
		$("#colnumdamage").val(resultdamage-1);
		if (textdamage.substr(0,1)==',') textdamage=textdamage.substr(1);
		$("#parmeterdamage").val(textdamage);
		var selectedlinesdamage = line_infosdamage.split("~");
		var wronglineinfosdamage = "";
		for(var index=0;index<selectedlinesdamage.length;index++){
			var valueinfodamage = $("#detdev_ci_code_damage"+selectedlinesdamage[index]).val();
			if(valueinfodamage == ""){
				if(index == 0){
					wronglineinfosdamage += (parseInt(selectedlinesdamage[index])+1);
				}else{
					wronglineinfosdamage += ","+(parseInt(selectedlinesdamage[index])+1);
				}
			}
		}
		if(wronglineinfosdamage!=""){
			alert("请选择第"+wronglineinfosdamage+"行设备明细信息!");
			return;
		}
		if($('input[name="specialized_unit_flag"]:checked').val()== undefined)
			{
				alert("请选择是否为专业化服务设备!");
				return;
			}
		if($('input[name="else_unit_flag"]:checked').val()== undefined)
		{
			alert("请选择是否为其他单位设备!");
			return;
		}
		}
		//zjb start
		Ext.MessageBox.wait('正在操作','请稍后...');
		Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/addScrapeallForProc.srq",
					method : 'Post',
					isUpload : true,  
					async :  true,
					form : "form1",
					success : function(resp){
						 Ext.MessageBox.hide();
						 Ext.MessageBox.minWidth=300;
						 var respText = Ext.util.JSON.decode(resp.responseText);
						 if(respText.flag_asset=="f"){//导入固有资产失败
							 Ext.MessageBox.confirm('提示','保存失败，导入固定资产设备附件失败');
						 }else if(respText.flag_damage=="f"){
							 Ext.MessageBox.confirm('提示','保存失败，导入毁损折旧设备附件失败');
						 }else {
							 Ext.MessageBox.confirm('提示','保存成功！');
							 //Ext.MessageBox.confirm('提示','导入固有资产耗时'+respText.time_asset+'毫秒,毁损耗时：'+respText.time_damage+'毫秒。');
						 }
						
					},
					callback :function(){
					},
					failure : function(resp){// 失败
						Ext.MessageBox.confirm('提示','保存失败！');
					}
				});
		//zjb end
		//折损部分结束
		//document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeallForProc.srq";
		//document.getElementById("form1").submit();
	} --%>
	function refreshData(){
		var baseData;
		//修改的时候的操作
		if('<%=scrape_apply_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeAllInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
			$("#scrape_apply_no").val(baseData.deviceAssetMap.scrape_apply_no);
			$("#scrape_asset_id").val(baseData.deviceAssetMap.scrape_asset_id);
			$("#scrape_apply_name").val(baseData.deviceAssetMap.scrape_apply_name);
			$("#apply_date").val(baseData.deviceAssetMap.apply_date);
			$("#scrape_damage_id").val(baseData.deviceDamageMap.scrape_damage_id);
			$("#loss_reason").val(baseData.deviceDamageMap.loss_reason);
			$("#asset_now_desc").val(baseData.deviceAssetMap.asset_now_desc);
			$("#scrape_reason").val(baseData.deviceAssetMap.scrape_reason);
			$("#expert_desc").val(baseData.deviceAssetMap.expert_desc);
			/* $("#expert_leader").val(baseData.deviceAssetMap.expert_leader);
			$("#expert_members1").val(baseData.deviceAssetMap.expert_leader);
			$("#appraisal_date").val(baseData.deviceAssetMap.appraisal_date);
			$("#expert_members").val(baseData.deviceAssetMap.expert_members); */
			if(baseData.deviceEmpMap!=null){
				$("#expert_ids").val(baseData.deviceEmpMap.expert_ids);//专家表id
				$("#employee_names").val(baseData.deviceEmpMap.employee_names);//专家名称
				//$("#employee_names").val(baseData.deviceAssetMap.expert_members);//专家名称
				$("#employee_ids").val(baseData.deviceEmpMap.employee_ids);//专家id
			}
			//人员名称
			var str=$("#employee_names").val();
			var strs= new Array(); //定义一数组 
			strs=str.split(","); //字符分割 
			//人员id
			var strid=$("#employee_ids").val();
			var strids= new Array(); //定义一数组 
			strids=strid.split(","); //字符分割 
			
			//业务表id
			var tableid=$("#expert_ids").val();
			var tableids= new Array(); //定义一数组 
			tableids=tableid.split(","); //字符分割 
			optnum=strs.length;
			for (var i=0;i<strs.length ;i++ ) 
			{ 
				insertEmp(strs[i],strids[i],i,tableids[i]);
			}
			if(baseData.deviceDamageMap.specialized_unit_flag=='0')
			{
			 document.getElementById("specialized_unit_flag1").checked=true; 
			 }
			 if(baseData.deviceDamageMap.specialized_unit_flag=='1')
			{
			 document.getElementById("specialized_unit_flag2").checked=true; 
			 }
			 	if(baseData.deviceDamageMap.else_unit_flag=='0')
			{
			 document.getElementById("else_unit_flag1").checked=true; 
			 }
			 if(baseData.deviceDamageMap.else_unit_flag=='1')
				{
			 document.getElementById("else_unit_flag2").checked=true; 
				 }
			if(baseData.fdataAsset!=null){
				//有附件不显示设备详情而是显示附件
				for (var tr_id = 1; tr_id<=baseData.fdataAsset.length; tr_id++) {
					insertFileAsset(baseData.fdataAsset[tr_id-1].file_name,baseData.fdataAsset[tr_id-1].file_type,baseData.fdataAsset[tr_id-1].file_id);
					if(tr_id==1){
						flag_asset=0;//更新页面允许再次上传附件
						flag_asset_time=1;
					}else{
						flag_asset=1;//如果已经上传一次以上，不允许再次上传附件
					}
				}
			}else{
				if(baseData.datas!=null){
				for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
					var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml += "<input name='detdev_ci_code_asset"+tr_id+"' id='detdev_ci_code_asset"+tr_id+"' value='"+baseData.datas[tr_id].foreign_dev_id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<td><input type='checkbox' name='idinfoasset' id='"+tr_id+"' checked/></td>";
					innerhtml += "<td width='27%'><input name='dev_name_asset"+tr_id+"' id='dev_name_asset"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='15' type='text' readonly /><%-- <img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePageasset("+tr_id+")' /> --%>";
					innerhtml += "</td>";
					innerhtml += "<td width='17%'><input name='asset_coding_asset"+tr_id+"' id='asset_coding_asset"+tr_id+"' value='"+baseData.datas[tr_id].asset_coding+"' size='16'  type='text' readonly /></td>";
					innerhtml += "<td width='17%'><input name='dev_coding_asset"+tr_id+"' id='dev_coding_asset"+tr_id+"' value='"+baseData.datas[tr_id].dev_coding+"' size='16' type='text' readonly/>";
					if(baseData.datas[tr_id].scrape_type==0)
						{
						innerhtml += "<td width='17%'><select name='scrape_type_asset"+tr_id+"' id='scrape_type_asset"+tr_id+"'><option  value='0' selected >正常报废</option><option value='1'>技术淘汰</option></select></td>";
						}
					if(baseData.datas[tr_id].scrape_type==1)
					{
					innerhtml += "<td width='17%'><select name='scrape_type_asset"+tr_id+"' id='scrape_type_asset"+tr_id+"'><option  value='0'  >正常报废</option><option value='1' selected>技术淘汰</option></select></td>";
					}
					
					innerhtml += "<td width='9%'><input name='bak_asset"+tr_id+"' id='bak_asset"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[tr_id].bak1+"' readonly/></td>";
					/* if(baseData.datas[tr_id].scrape_type==0)
					{
					innerhtml += "<td width='17%'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0' selected >同意</option><option value='1'>不同意</option></select></td>";
					}
					if(baseData.datas[tr_id].scrape_type==1)
					{
					innerhtml += "<td width='17%'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0'  >同意</option><option value='1' selected>不同意</option></select></td>";
					}
					
					innerhtml += "<td width='9%'><input name='sp_bak_asset"+tr_id+"' id='sp_bak_asset"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[tr_id].sp_bak1+"' /></td>"; */
					innerhtml += "</tr>";
					$("#processtable0").append(innerhtml);
					}
			
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
				}
			}
			if(baseData.fdataDamage!=null){
				//有附件不显示设备详情而是显示附件
				for (var tr_id = 1; tr_id<=baseData.fdataDamage.length; tr_id++) {
					insertFileDamage(baseData.fdataDamage[tr_id-1].file_name,baseData.fdataDamage[tr_id-1].file_type,baseData.fdataDamage[tr_id-1].file_id);
					if(tr_id==1){
						flag_damage=0;//更新页面允许再次上传附件
						flag_damage_time=1;
					}else{
						flag_damage=1;//如果已经上传一次以上，不允许再次上传附件
					}
				}
			}else{
			if(baseData.datasDamage!=null){
				for (var tr_id = 0; tr_id< baseData.datasDamage.length; tr_id++) {
					var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml += "<input name='detdev_ci_code_damage"+tr_id+"' id='detdev_ci_code_damage"+tr_id+"' value='"+baseData.datasDamage[tr_id].foreign_dev_id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<td><input type='checkbox' name='idinfodamage' id='"+tr_id+"' checked/></td>";
					innerhtml += "<td width='27%'><input name='dev_name_damage"+tr_id+"' id='dev_name_damage"+tr_id+"' style='line-height:15px' value='"+baseData.datasDamage[tr_id].dev_name+"' size='15' type='text' readonly /><%-- <img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagedamage("+tr_id+")' /> --%>";
					innerhtml += "</td>";
					innerhtml += "<td width='17%'><input name='asset_coding_damage"+tr_id+"' id='asset_coding_damage"+tr_id+"' value='"+baseData.datasDamage[tr_id].asset_coding+"' size='16'  type='text' readonly /></td>";
					innerhtml += "<td width='17%'><input name='dev_coding_damage"+tr_id+"' id='dev_coding_damage"+tr_id+"' value='"+baseData.datasDamage[tr_id].dev_coding+"' size='16' type='text' readonly/>";
					if(baseData.datasDamage[tr_id].scrape_type==2)
						{
						innerhtml += "<td width='17%'><select name='scrape_type_damage"+tr_id+"' id='scrape_type_damage"+tr_id+"'><option  value='2' selected >毁损</option><option value='3'>盘亏</option></select></td>";
						}
					if(baseData.datasDamage[tr_id].scrape_type==3)
					{
					innerhtml += "<td width='17%'><select name='scrape_type_damage"+tr_id+"' id='scrape_type_damage"+tr_id+"'><option  value='2'  >毁损</option><option value='3' selected>盘亏</option></select></td>";
					}
					
					innerhtml += "<td width='9%'><input name='bak_damage"+tr_id+"' id='bak_damage"+tr_id+"'  size='9'  type='text' value='"+baseData.datasDamage[tr_id].bak1+"' /></td>";
					innerhtml += "</tr>";
					$("#processtable1").append(innerhtml);
					}
				$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable1>tr:odd>td:even").addClass("odd_even");
				$("#processtable1>tr:even>td:odd").addClass("even_odd");
				$("#processtable1>tr:even>td:even").addClass("even_even");
				}
			}
			if(baseData.fdata!=null)
			{
				for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
					
				//证明材料
				if(baseData.deviceDamageMap.proof_file==baseData.fdata[tr_id-1].file_type)
				{
				
					$("#proof_file_tr").empty();
					insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'proof_file_tr','证明材料','proof_file');
				}
				//赔付证明
				if(baseData.deviceDamageMap.payment_proof_file==baseData.fdata[tr_id-1].file_type)
				{
				
				$("#payment_proof_file_tr").empty();
					insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'payment_proof_file_tr','赔付证明','payment_proof_file');
				}
				//毁损照片
				if(baseData.deviceDamageMap.dev_photo_file==baseData.fdata[tr_id-1].file_type)
				{
					$("#dev_photo_file_tr").empty();
					insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'dev_photo_file_tr','毁损照片','dev_photo_file');
				}
				//责任人处理
				if(baseData.deviceDamageMap.person_handling_file==baseData.fdata[tr_id-1].file_type)
				{
					$("#person_handling_file_tr").empty();
					insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'person_handling_file_tr','责任人处理','person_handling_file');
				}
				}
			}
			/* var str=$("#expert_members").val();
			var strs= new Array(); //定义一数组 
			strs=str.split(","); //字符分割 
			optnum=strs.length;
			for (i=2;i<strs.length+1 ;i++ ) 
			{ 
				var newTr=OPERATOR_body.rows[0];
				var newTd=newTr.insertCell();
				newTd.className="inquire_item6";
				newTd.innerHTML="鉴定人员"+i;
				var newTd=newTr.insertCell();
				newTd.className="inquire_form6";
				newTd.innerHTML="<input name=expert_members"+i+" id=expert_members"+i+"  class=input_width type=text value="+strs[i-1]+" />";
			}  */
			//other
			 $("#bak").val(baseData.deviceApplyMap.bak);
				
				if(baseData.fdataOther!=null)
				{
					$("#file_table6").empty();
					for (var tr_id = 1; tr_id<=baseData.fdataOther.length; tr_id++) {
						insertFileOther(baseData.fdataOther[tr_id-1].file_name,baseData.fdataOther[tr_id-1].file_type,baseData.fdataOther[tr_id-1].file_id);
					}
				}
		}
	}
	function insertEmp(name,id,tr_id,tableid)
	{
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<td class='inquire_item4'>鉴定组长</td>";
			innerhtml += "<td class='inquire_form4'>";
			innerhtml += 	"<input type='hidden' id='tableId"+tr_id+"' name='tableId"+tr_id+"' value='"+tableid+"'/>";
			innerhtml += 	"<input type='hidden' id='employeeId"+tr_id+"' name='employeeId"+tr_id+"' value='"+id+"'/>";
			innerhtml += 	"<input type='text' readonly='readonly' id='employeeName"+tr_id+"' name='employeeName"+tr_id+"' value='"+name+"'></input>";
			innerhtml += "</td>";
			innerhtml +="</tr>";
			$("#OPERATOR_body").append(innerhtml);
	}
	function removrowselectemp(item){
		var tableid = $(item).parent().parent().parent()[0].childNodes[1].childNodes[0].defaultValue;
	if(confirm('确定要删除吗?')){  
		$(item).parent().parent().parent().empty();
		jcdpCallService("ScrapeSrv", "deleteEmp", "empId="+tableid);
	}
	}
	var optnum=0;
	function addrow(obj)
	{
		var tr_id = $("#OPERATOR_body>tr:last").attr("id");
		if(tr_id != undefined){
			tr_id = parseInt(tr_id.substr(2,1),10);
		}
		if(tr_id == undefined){
			tr_id = 0;
		}else{
			tr_id = tr_id+1;
		}
		optnum=tr_id;
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<td class='inquire_item4'>鉴定人员</td>";
			innerhtml += "<td class='inquire_form4'>";
			innerhtml += 	"<input type='hidden' id='employeeId"+tr_id+"' name='employeeId"+tr_id+"' value=''/>";
			innerhtml += 	"<input type='text' readonly='readonly' value=''id='employeeName"+tr_id+"' name='employeeName"+tr_id+"'></input>";
			innerhtml += "</td>";
			innerhtml += "</tr>";
			$("#OPERATOR_body").append(innerhtml);
	}
	function removrow(item){
		$(item).parent().parent().parent().empty();
		/* alert(i);
		if(optnum>1){
			$("#OPERATOR_body  tr:nth-child("+i+")").remove(); //参数从1开始
			optnum--;
		} */
	}
	function addRowsdamages(status){
		//flag_asset 0 默认值、1附件导入2手动添加
		if(flag_asset!=1){
			flag_damage = status;
			addRowsdamage();
		}else{
			alert("您已经选择导入设备，不能同时选择添加设备！！");
			return ;
		}
	};
	function addRowsdamage(){
		tr_id = $("#processtable1>tr:last").attr("id");
		if(tr_id != undefined){
			tr_id = parseInt(tr_id.substr(2,1),10);
		}
		if(tr_id == undefined){
			tr_id = 0;
		}else{
			tr_id = tr_id+1;
		}
		$("#colnumdmage").val(tr_id);
		//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
		innerhtml += "<input name='detdev_ci_code_damage"+tr_id+"' id='detdev_ci_code_damage"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<td><input type='checkbox' name='idinfodamage' id='"+tr_id+"' checked/></td>";
		innerhtml += "<td width='27%'><input name='dev_name_damage"+tr_id+"' id='dev_name_damage"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly /><%-- <img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagedamage("+tr_id+")' /> --%>";
		innerhtml += "</td>";
		innerhtml += "<td width='17%'><input name='asset_coding_damage"+tr_id+"' id='asset_coding_damage"+tr_id+"' value='' size='16'  type='text' readonly /></td>";
		innerhtml += "<td width='17%'><input name='dev_coding_damage"+tr_id+"' id='dev_coding_damage"+tr_id+"' value='' size='16' type='text' readonly/>";
		innerhtml += "<td width='17%'><select name='scrape_type_damage"+tr_id+"' id='scrape_type_damage"+tr_id+"'><option value='2' >毁损</option><option value='3'>盘亏</option></select></td>";
		innerhtml += "<td width='9%'><input name='bak_damage"+tr_id+"' id='bak_damage"+tr_id+"' value='' size='9'  type='text' /></td>";
		innerhtml += "</tr>";
		$("#processtable1").append(innerhtml);
		
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
};
function delRowsdamages(status){
	//flag_damage 0 默认值、1附件导入2手动添加
	if(flag_damage!=1){
		flag_damage = status;
		delRowsdamage();
	}else{
		alert("您已经选择导入设备，不能同时选择删除设备！！");
		return ;
	}
}
	function delRowsdamage(){
	$("input[name='idinfodamage']").each(function(i){
		if(this.checked == true){
			if(i==0){
				flag_damage = i;
			}
			$('#tr'+this.id,"#processtable1").remove();
		}
	});
	$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable1>tr:odd>td:even").addClass("odd_even");
	$("#processtable1>tr:even>td:odd").addClass("even_odd");
	$("#processtable1>tr:even>td:even").addClass("even_even");
};
//插入文件
function insertFile(name,type,id,f_tr,context,hiddenname){
	$("#"+f_tr).empty();
	$("#"+f_tr).append(
				"<td class='inquire_item6'>"+context+":</td>"+
      			"<td class='inquire_item6' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\",\""+f_tr+"\",\""+context+"\",\""+hiddenname+"\") title='删除'></a></span></td>"
		);
}
//删除文件
function deleteFile(item,id,f_tr,context,hiddenname){
	if(confirm('确定要删除吗?')){  
		$(item).parent().parent().parent().empty();
		$("#"+f_tr).append(
				"<td class='inquire_item6'>"+context+":</td>"+
      			"<td class='inquire_item6' colspan='3'><input type='file' name='"+hiddenname+"_' id='"+hiddenname+"_' value='' class='input_width' onchange='getFileInfo(this,\""+hiddenname+"\")' />"+
				"<input type='hidden' id="+hiddenname+" name="+hiddenname+" value=''/></td>"
		);
			//jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	
}

//删除行
function deleteInput(item,order){
	$(item).parent().parent().parent().remove();
}
function getFileInfo(item,textname){
	var docPath = $(item).val();
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#"+textname).val(docTitle);//文件name
}
//插入行
function insertTrOther(obj){
var tmp=new Date().getTime();
	$("#"+obj+"").append(
		"<tr class='file_tr'>"+
			"<td class='inquire_item5'>附件：</td>"+
  			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfoOther(this)' class='input_width'/></td>"+
			"<td class='inquire_item5'>附件名：</td>"+
			"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
			"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputOther(this)'  title='删除'></a></span></td>"+
		"</tr>"	
	);

}
//删除行
function deleteInputOther(item){
	$(item).parent().parent().parent().remove();
	checkInfoList();
	
}
function getFileInfoOther(item){
	var docPath = $(item).val();
	var order = $(item).attr("id").split("__")[1];
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#doc_name__"+order).val(docTitle);//文件name
	
}

	//插入文件
function insertFileOther(name,type,id){
	
		$("#file_table6").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5'><span class='sc'><a href='javascript:void(0);' onclick=deleteFileOther(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
}
//删除文件
	function deleteFileOther(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_table6").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfoOther(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputOther(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	}
	/**设备报废处置明细模板方法**/
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/dmsManager/common/download.jsp?path=/dmsManager/scrape/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	
	/**导入设备报废处置明细方法**/
	<%-- function excelDataAdddamage(){
		var nodes= window.showModalDialog('<%=contextPath%>/dmsManager/scrape/scrExcelAdd.jsp','ceshi','dialogHeight=10;dialogWidth=45;resizable=no;menuba=no;resizable=no');
		refreshDataDamageDync(nodes);
	}
	function refreshDataDamageDync(nodes){
		for (var tr_id = 0; tr_id< nodes.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code_damage"+tr_id+"' id='detdev_ci_code_damage"+tr_id+"' value='"+nodes[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfodamage' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='27%'><input name='dev_name_damage"+tr_id+"' id='dev_name_damage"+tr_id+"' style='line-height:15px' value='"+nodes[tr_id].dev_name+"' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagedamage("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td width='17%'><input name='asset_coding_damage"+tr_id+"' id='asset_coding_damage"+tr_id+"' value='"+nodes[tr_id].asset_coding+"' size='16'  type='text' readonly /></td>";
			innerhtml += "<td width='17%'><input name='dev_coding_damage"+tr_id+"' id='dev_coding_damage"+tr_id+"' value='"+nodes[tr_id].dev_coding+"' size='16' type='text' readonly/>";
			if(nodes[tr_id].scrape_type==2)
				{
				innerhtml += "<td width='17%'><select name='scrape_type_damage"+tr_id+"' id='scrape_type_damage"+tr_id+"'><option  value='2' selected >毁损</option><option value='3'>盘亏</option></select></td>";
				}
			if(nodes[tr_id].scrape_type==3)
			{
			innerhtml += "<td width='17%'><select name='scrape_type_damage"+tr_id+"' id='scrape_type_damage"+tr_id+"'><option  value='2'  >毁损</option><option value='3' selected>盘亏</option></select></td>";
			}
			
			innerhtml += "<td width='9%'><input name='bak_damage"+tr_id+"' id='bak_damage"+tr_id+"'  size='9'  type='text' value='"+nodes[tr_id].bak+"' /></td>";
			innerhtml += "</tr>";
			$("#processtable1").append(innerhtml);
			}
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
	} --%>
	/**导入设备报废处置明细方法**/
	function excelDataAdd(status){
		//flag_asset 0 默认值、1附件导入2手动添加
		if(flag_asset==0){
			flag_asset = status;
			insertTrAsset('file_tableAsset');
		}else if(flag_asset==1){
			alert("您已经选择一条导入设备！！");
			return ;
		}else{
			alert("您已经选择添加设备，不能同时选择导入设备！！");
			return ;
		}
		<%-- var nodes= window.showModalDialog('<%=contextPath%>/dmsManager/scrape/scrExcelAdd.jsp','ceshi','dialogHeight=10;dialogWidth=45;resizable=no;menuba=no;resizable=no');
		refreshDataDync(nodes); --%>
	}
	//新增插入文件
	function insertTrAsset(obj){
		var tmp="asset";
			$("#"+obj+"").append(
				"<tr id='file_tr_asset'>"+
					"<td class='inquire_item5'><font color='red'>审批更新设备附件：</font></td>"+
		  			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoAsset(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputAsset(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);

		}
	//显示已插入的文件
	function insertFileAsset(name,type,id){
		$("#file_tableAsset").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//删除文件
	function deleteFileAsset(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_tableAsset").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoAsset(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='excel_name_"+tmp+"' id='excel_name_"+tmp+"' class='input_width' /><input type='hidden' id='doc_type_"+tmp+"' name='doc_type_"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputAsset(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_asset = 1;
		}
	}
	function getFileInfoAsset(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#excel_name_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteInputAsset(item){
		flag_asset = 0;
		$(item).parent().parent().parent().remove();
		checkInfoList();
		
	}
	/**导入设备报废处置明细方法**/
	function excelDataAddDamage(status){
		//flag_asset 0 默认值、1附件导入2手动添加
		if(flag_damage==0){
			flag_damage = status;
			insertTrDamage('file_tableDamage');
		}else if(flag_damage==1){
			alert("您已经选择一条导入设备！！");
			return ;
		}else{
			alert("您已经选择添加设备，不能同时选择导入设备！！");
			return ;
		}
		<%-- var nodes= window.showModalDialog('<%=contextPath%>/dmsManager/scrape/scrExcelAdd.jsp','ceshi','dialogHeight=10;dialogWidth=45;resizable=no;menuba=no;resizable=no');
		refreshDataDync(nodes); --%>
	}
	//新增插入文件
	function insertTrDamage(obj){
		var tmp="damage";
			$("#"+obj+"").append(
				"<tr id='file_tr_damage'>"+
					"<td class='inquire_item5'><font color='red'>审批更新设备附件：</font></td>"+
		  			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoDamage(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputDamage(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);

		}
	//显示已插入的文件
	function insertFileDamage(name,type,id){
		$("#file_tableDamage").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//删除文件
	function deleteFileDamage(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_tableDamage").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoDamage(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='excel_name_"+tmp+"' id='excel_name_"+tmp+"' class='input_width' /><input type='hidden' id='doc_type_"+tmp+"' name='doc_type_"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputDamage(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_damage = 1;
		}
	}
	function getFileInfoDamage(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#excel_name_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteInputDamage(item){
		flag_damage = 0;
		$(item).parent().parent().parent().remove();
		checkInfoList();
		
	}
	<%-- function refreshDataDync(nodes){
		for (var tr_id = 0; tr_id< nodes.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code_asset"+tr_id+"' id='detdev_ci_code_asset"+tr_id+"' value='"+nodes[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfoasset' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='27%'><input name='dev_name_asset"+tr_id+"' id='dev_name_asset"+tr_id+"' style='line-height:15px' value='"+nodes[tr_id].dev_name+"' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePageasset("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td width='17%'><input name='asset_coding_asset"+tr_id+"' id='asset_coding_asset"+tr_id+"' value='"+nodes[tr_id].asset_coding+"' size='16'  type='text' readonly /></td>";
			innerhtml += "<td width='17%'><input name='dev_coding_asset"+tr_id+"' id='dev_coding_asset"+tr_id+"' value='"+nodes[tr_id].dev_coding+"' size='16' type='text' readonly/>";
			if(nodes[tr_id].scrape_type==0){
				innerhtml += "<td width='17%'><select name='scrape_type_asset"+tr_id+"' id='scrape_type_asset"+tr_id+"'><option  value='0' selected >正常报废</option><option value='1'>技术淘汰</option></select></td>";
			}
			if(nodes[tr_id].scrape_type==1){
				innerhtml += "<td width='17%'><select name='scrape_type_asset"+tr_id+"' id='scrape_type_asset"+tr_id+"'><option  value='0'  >正常报废</option><option value='1' selected>技术淘汰</option></select></td>";
			}
			innerhtml += "<td width='9%'><input name='bak_asset"+tr_id+"' id='bak_asset"+tr_id+"'  size='9'  type='text' value='"+nodes[tr_id].bak+"' /></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	} --%>
</script>
</html>

