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
    
  	String scrape_collect_id = request.getParameter("scrape_collect_id");
  	 
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
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<title>报废汇总表</title>
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
      <fieldSet style="margin:2px:padding:2px;"><legend>报废汇总基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_collect_id" id="scrape_collect_id" type="hidden" value="<%=scrape_collect_id%>" />
      	<input name="flag" id="flag" type="hidden" value="" />
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden"/>
        <input name="expert_members" id="expert_members"  class="input_width" type="hidden" />
        <input name="scrape_damage_id" id="scrape_damage_id" type="hidden" />
        <input name="colnumdamage" id="colnumdamage" class="input_width" type="hidden" value="" readonly/>
      	<input name="parmeterdamage" id="parmeterdamage" type="hidden" value=""/>
      	<input name="devCount" id="devCount" type="hidden" value=""/>
        <tr>
          <td class="inquire_item6">报废汇总单名称:<font color="red">*</font></td>
          <td class="inquire_form6" colspan="2">
          	<input name="scrape_collect_name" id="scrape_collect_name" class="input_width" type="text" value="" />
          </td>
          <td class="inquire_item6">汇总单位名称:</td>
          <td class="inquire_form6" colspan="2">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item6">报废汇总单号:</td>
          <td class="inquire_form6">
          	<input name="scrape_apply_no" id="scrape_apply_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item6">汇总时间:</td>
          <td class="inquire_form6">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
          <td class="inquire_item6">汇总人:</td>
          <td class="inquire_form6">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
      <!-- add by zzb -->
      <fieldSet style="margin-left:2px"><legend>报废汇总详细信息</legend>
      	  <input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      	  <input name="parmeter" id="parmeter" type="hidden" value=""/>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
				    <td class="ali_cdn_name">设备名称：</td>
			 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
			 	    <td class="ali_cdn_name">设备型号：</td>
			 	    <td class="ali_cdn_input"><input class="input_width" id="s_dev_model" name="s_dev_model" type="text" /></td>
			 	    <!--<td class="ali_cdn_name">设备年限：</td>
			 	    <td class="ali_cdn_input"><input class="input_width" id="s_times" name="s_times" type="text" /></td>-->
			 	    <td class="ali_cdn_name">国家/项目名称：</td>
			 	    <td class="ali_cdn_input"><input class="input_width" id="s_project_name" name="s_project_name" type="text" /></td>
			 	    <td class="ali_cdn_name">报废类别</td>
				    <td class="ali_cdn_input" style="width: 130px;">
				    	<select id="s_scrape_type" name="s_scrape_type">
				    		<option value="">--请选择--</option>
				    		<option value="0">正常报废</option>
				    		<option value="1">技术淘汰</option>
				    		<option value="2">毁损</option>
				    		<option value="3">盘亏</option>
				    	</select>
				    </td>
				    <td class="ali_cdn_name">责任单位：</td>
		 	    	<td class="ali_cdn_input"><input class="input_width" id="s_duty_unit" name="s_duty_unit" type="text" /></td>
					<td class="ali_cdn_name">设备所属单位：</td>
		 	    	<td class="ali_cdn_input"><input class="input_width" id="s_org_name" name="s_org_name" type="text" /></td>
					<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
				    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
				    <td></td>
				    <td></td>
				    <td></td>
	  	  			<td>&nbsp;</td>
	  	  			<auth:ListButton functionId="" css="bc" event="onclick='toSaveDevInfo()'" title="保存当前数据"></auth:ListButton>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='toAddDevInfo()'" title="添加申请单"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='toDeleteDevInfo()'" title="删除申请单"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
		  	  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tableCollect">
				<input name="flag_collect" id="flag_collect" type="hidden"/>
				</table>
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">项目名称/国家</td>
					<td class="bt_info_odd">责任单位</td>
					<td class="bt_info_even">设备所属单位</td>
					<td class="bt_info_odd" >报废类型</td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >设备型号</td>
					<td class="bt_info_even">数量</td>
					<!--<td class="bt_info_odd" >年限</td>-->
					<td class="bt_info_even">原值</td>
					<td class="bt_info_odd" >净值</td>
					<td class="bt_info_even">相关资料</td>
					<td class="bt_info_odd" >是否通过</td>
					<td class="bt_info_even">意见</td>
				</tr>
				</table>
			   <div style="height:150px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
      <fieldSet style="margin:2px:padding:2px;"><legend>鉴定信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td style="width: 10%" >专家名单:</td>
          <td style="width: 40%">
           <textarea id="experts" name="experts"  class="textarea" ></textarea>
          </td>
           <td style="width: 10%">专家意见<font color="red">(为空时批复时不可见)</>:</td>
          <td style="width: 40%">
           <textarea id="bak" name="bak"  class="textarea" ></textarea>
          </td>
        </tr>
        <tr> <td>&nbsp;</td>
         <table>
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
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function Map() {
  this.obj = {};
  this.count = 0;
}
Map.prototype.put = function (key, value) {
  var oldValue = this.obj[key];
  if (oldValue == undefined) {
    this.count++;
  }
  this.obj[key] = value;
}
Map.prototype.get = function (key) {
	if(this.obj[key]){
	return this.obj[key];
	}else{
	return 0;
	} 
}
Map.prototype.remove = function (key) {
  var oldValue = this.obj[key];
  if (oldValue != undefined) {
    this.count--;
    delete this.obj[key];
  }
}
Map.prototype.size = function () {
  return this.count;
}
	
//add by zzb
cruConfig.contextPath='<%=contextPath%>';
var flag_collect = 0;//固定资产附件标示 flag_collect 0 默认值、1附件导入2手动添加
var flag_damage = 0;//毁损附件标示
var flag_file = 0;//附件标示
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfocollect']").attr('checked',checkvalue);
	});
	$("#hirecheckeddamage").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfodamage']").attr('checked',checkvalue);
	});
});
function addRowscollect(status){
	//flag_collect 0 默认值、1附件导入2手动添加
	if(flag_collect!=1){
		flag_collect = status;
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
	innerhtml += "<input name='detdev_ci_code_collect"+tr_id+"' id='detdev_ci_code_collect"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='collect_coding"+tr_id+"' id='collect_coding"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='collect_value"+tr_id+"' id='collect_value"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<td><input type='checkbox' name='idinfocollect' id='"+tr_id+"' checked/></td>";
	innerhtml += "<td width='27%'><input name='dev_name_collect"+tr_id+"' id='dev_name_collect"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagecollect("+tr_id+")' />";
	innerhtml += "</td>";
	innerhtml += "<td width='17%'><input name='collect_coding_collect"+tr_id+"' id='collect_coding_collect"+tr_id+"' value='' size='16'  type='text' readonly /></td>";
	innerhtml += "<td width='17%'><input name='dev_coding_collect"+tr_id+"' id='dev_coding_collect"+tr_id+"' value='' size='16' type='text' readonly/>";
	innerhtml += "<td width='17%'><select name='scrape_type_collect"+tr_id+"' id='scrape_type_collect"+tr_id+"'><option  value='0'>正常报废</option><option value='1'>技术淘汰</option></select></td>";
	innerhtml += "<td width='9%'><input name='bak_collect"+tr_id+"' id='bak_collect"+tr_id+"' value='' size='9'  type='text' /></td>";
	innerhtml += "</tr>";
	$("#processtable0").append(innerhtml);
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
};
function toDeleteDevInfo(){
$("input[name='idinfo']").each(function() {
	if (this.checked == true) {
		$('#tr' + this.id, "#processtable0").remove();
	}
});
$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
$("#processtable0>tr:odd>td:even").addClass("odd_even");
$("#processtable0>tr:even>td:odd").addClass("even_odd");
$("#processtable0>tr:even>td:even").addClass("even_even");
};
function showDevCodePagecollect(index){
var obj = new Object();
var pageselectedstr = null;
var checkstr = 0;
$("input[name^='detdev_ci_code_collect'][type='hidden']").each(function(i){
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
var returnval = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeApplyList.jsp",obj,"dialogWidth=950px;dialogHeight=480px");
//返回信息是  类别id + ERP设备编码 + 设备名称 + AMIS资产编码
if(returnval!=undefined){
	var returnvals = returnval.split("~",-1);
	$("#dev_name_collect"+index).val(returnvals[2]);
	$("#collect_coding_collect"+index).val(returnvals[3]);
	$("#detdev_ci_code_collect"+index).val(returnvals[0]);
	$("#dev_coding_collect"+index).val(returnvals[1]);
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
//add by zzb
	function toSaveDevInfo(){
		//前台传过去汇总ID
		var scrape_collect_id=$("#scrape_collect_id").val();
		 
		if(scrape_collect_id=='null'){
			scrape_collect_id=guid();
			$("#scrape_collect_id").val(scrape_collect_id);
			$("#flag").val("add");
		}else{
			$("#flag").val("update");
		}
		var count = $("#devCount").val();
		for(var i = 0;i<count;i++){
			if($("#sp_pass_flag"+i).val()==1&&$("#sp_bak1"+i).val()==""){
				alert("审批不通过的请注明意见！！");
				return;
			}
		}
		Ext.Ajax.request({
			url : "<%=contextPath%>/dmsManager/scrape/addScrapeallCollect.srq",
			method : 'Post',
			isUpload : true,  
			async :  true,
			form : "form1",
			success : function(resp){
			$("#flag").val("update");
			alert('保存成功');
			},
			failure : function(resp){// 失败
				alert('保存失败2！');
			}
		});
	}
	function saveInfo(){
		//前台传过去汇总ID
		var scrape_collect_id=$("#scrape_collect_id").val();
		if(scrape_collect_id=='null'){
			scrape_collect_id=guid();
			$("#scrape_collect_id").val(scrape_collect_id);
			$("#flag").val("add");
		}else{
			$("#flag").val("update");
		}
		$("#scrape_collect_no").val("");
		if($("#scrape_collect_name").val()==""){
			alert("报废汇总单名称不能为空!");
			return;
		}
		if($("#apply_date").val()==""){
			alert("汇总日期不能为空!");
			return;
		}
		var count = $("#devCount").val();
		for(var i = 0;i<count;i++){
			if($("#sp_pass_flag"+i).val()==1&&$("#sp_bak1"+i).val()==""){
				alert("审批不通过的请注明意见！！");
				return;
			}
			
		}
		/* if(flag_file!=1||flag_collect!=1){
			alert("未添加申请单或未导入申请单审批报废设备信息!");
			return;
		} */
		//zjb start
		Ext.MessageBox.wait('正在操作','请稍后...');
		Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/addScrapeallCollect.srq",
					method : 'Post',
					isUpload : true,  
					async :  true,
					form : "form1",
					success : function(resp){
						 Ext.MessageBox.hide();
						 alert('保存成功');
					},
					failure : function(resp){// 失败
						 Ext.MessageBox.hide();
						 alert('保存失败！');
					}
				});
		//zjb end
		//折损部分结束
		newClose();
	}
	function refreshData(){
		var baseData;
		//修改的时候的操作
		if('<%=scrape_collect_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeCollectAllInfo", "scrape_collect_id="+$("#scrape_collect_id").val());
			 $("#scrape_collect_no").val(baseData.deviceappMap.scrape_collect_no);
			$("#scrape_collect_name").val(baseData.deviceappMap.scrape_collect_name);
			$("#apply_date").val(baseData.deviceappMap.collect_date);
			var map = new Map();
			for   (var i = 0; i< baseData.filetotallist.length; i++) {
					map.put(baseData.filetotallist[i].key,baseData.filetotallist[i].num);		
			}
			//汇总附件
			if(baseData.fdataCollect!=null){
				for (var tr_id = 1; tr_id<=baseData.fdataCollect.length; tr_id++) {
					insertFileCollect(baseData.fdataCollect[tr_id-1].file_name,baseData.fdataCollect[tr_id-1].file_type,baseData.fdataCollect[tr_id-1].file_id);
				}
			}
			//汇总申请表datasApply
			if(baseData.datas!=null){
				devCount = baseData.datas.length;
				$("#devCount").val(devCount);
				
			for (var i = 0; i< baseData.datas.length; i++) {
				debugger;
				var key =baseData.datas[i].scrape_apply_id1+"_"+baseData.datas[i].project_name+"_"+baseData.datas[i].org_name+"_"+baseData.datas[i].dev_name+"_"+baseData.datas[i].dev_type+"_"+baseData.datas[i].scrape_type;
				var value=map.get(key);
				
				tr_id = $("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				innerhtml += "<input name='duty_unit"+tr_id+"' id='duty_unit"+tr_id+"'  type='hidden' value='"+baseData.datas[i].duty_unit+"'/>";
				innerhtml += "<input name='org_name"+tr_id+"' id='org_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].org_name+"'/>";
				innerhtml += "<input name='org_id"+tr_id+"' id='org_id"+tr_id+"'  type='hidden' value='"+baseData.datas[i].org_id+"'/>";
				innerhtml += "<input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_name+"'/>";
				innerhtml += "<input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_type+"'/>";
				innerhtml += "<input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_model+"'/>";
				innerhtml += "<input name='times"+tr_id+"' id='times"+tr_id+"'  type='hidden' value='"+baseData.datas[i].times+"'/>";
				innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"'  type='hidden' value='"+baseData.datas[i].asset_value+"'/>";
				innerhtml += "<input name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'  type='hidden' value='"+baseData.datas[i].scrape_type+"'/>";
				innerhtml += "<input name='project_name"+tr_id+"' id='project_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].project_name+"'/>";
				innerhtml += "<input name='scrape_apply_id1"+tr_id+"' id='scrape_apply_id1"+tr_id+"'  type='hidden' value='"+baseData.datas[i].scrape_apply_id1+"'/>";
				innerhtml += "<td width='4.3%'><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].project_name+"</td>";
				innerhtml += "<td width='10%'>"+baseData.datas[i].duty_unit+"</td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].org_name+"</td>";
				innerhtml += "<td width='6%'>"+baseData.datas[i].scrape_types+"</td>";
				innerhtml += "<td width='10%'>"+baseData.datas[i].dev_name+"</td>";
				innerhtml += "<td width='10%'>"+baseData.datas[i].dev_model+"</td>";
				innerhtml += "<td width='6.4%'><a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"条</a></td>";
				/* innerhtml += "<td width='17.4%'>"+baseData.datas[i].dev_name+",共(<a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"</a>)条</td>"; */
				/* innerhtml += "<td>"+baseData.datas[i].dev_type+"</td>"; */
				//innerhtml += "<td width='10%'>"+baseData.datas[i].times+"</td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].asset_value+"</td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].net_value+"</td>";
				//var fileCount = jcdpCallService("ScrapeSrvNew", "getScrapeFileListCollectCount", "org_name="+baseData.datas[i].org_name+"&dev_name="+baseData.datas[i].dev_name+"&dev_type="+baseData.datas[i].dev_type+"&times="+baseData.datas[i].times);
				innerhtml += "<td width='12%'><a href='#' onclick='fujian("+tr_id+")'>资料("+value+")条</a></td>";
				if(baseData.datas[i].sp_pass_flag==0){
					innerhtml += "<td size='9'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0' selected>通过</option><option value='1'>不通过</option></select></td>";
				}else if(baseData.datas[i].sp_pass_flag==1){
					innerhtml += "<td ><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0'>通过</option><option value='1' selected>不通过</option></select></td>";
				}else{//默认值通过
					innerhtml += "<td width='17.4%'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0' selected>通过</option><option value='1'>不通过</option></select></td>";
				}
				innerhtml += "<td width='8.7%'><input name='sp_bak1"+tr_id+"' id='sp_bak1"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[i].sp_bak1+"'/></td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
			}
		
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
			}
			
			//other
			$("#bak").val(baseData.deviceappMap.bak);
			$("#experts").val(baseData.deviceappMap.experts);	
			if(baseData.fdataOther!=null)
			{
				$("#file_table6").empty();
				for (var tr_id = 1; tr_id<=baseData.fdataOther.length; tr_id++) {
					insertFileOther(baseData.fdataOther[tr_id-1].file_name,baseData.fdataOther[tr_id-1].file_type,baseData.fdataOther[tr_id-1].file_id);
				}
			}
		}
	}
	function addRowsdamages(status){
		//flag_collect 0 默认值、1附件导入2手动添加
		if(flag_damage!=1){
			flag_damage = status;
			addRowsdamage();
		}else{
			alert("您已经选择导入设备，不能同时选择添加设备！！");
			return ;
		}
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
	//显示已插入的文件
	function insertFileCollect(name,type,id){
		$("#file_tableCollect").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5'><span class='sc'><a href='javascript:void(0);' onclick=deleteFileCollect(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除文件
	function deleteFileCollect(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_tableCollect").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoCollect(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='excel_name_"+tmp+"' id='excel_name_"+tmp+"' class='input_width' /><input type='hidden' id='doc_type_"+tmp+"' name='doc_type_"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputCollect(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_collect = 1;
		}
	}
	function getFileInfoCollect(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#excel_name_"+order).val(docTitle);//文件name
		flag_file = 1;
	}
	//删除行
	function deleteInputCollect(item){
		flag_collect = 0;
		$(item).parent().parent().parent().remove();
		checkInfoList();
		
	}

	<%-- function refreshDataDync(nodes){
		for (var tr_id = 0; tr_id< nodes.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code_collect"+tr_id+"' id='detdev_ci_code_collect"+tr_id+"' value='"+nodes[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfocollect' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='27%'><input name='dev_name_collect"+tr_id+"' id='dev_name_collect"+tr_id+"' style='line-height:15px' value='"+nodes[tr_id].dev_name+"' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagecollect("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td width='17%'><input name='collect_coding_collect"+tr_id+"' id='collect_coding_collect"+tr_id+"' value='"+nodes[tr_id].collect_coding+"' size='16'  type='text' readonly /></td>";
			innerhtml += "<td width='17%'><input name='dev_coding_collect"+tr_id+"' id='dev_coding_collect"+tr_id+"' value='"+nodes[tr_id].dev_coding+"' size='16' type='text' readonly/>";
			if(nodes[tr_id].scrape_type==0){
				innerhtml += "<td width='17%'><select name='scrape_type_collect"+tr_id+"' id='scrape_type_collect"+tr_id+"'><option  value='0' selected >正常报废</option><option value='1'>技术淘汰</option></select></td>";
			}
			if(nodes[tr_id].scrape_type==1){
				innerhtml += "<td width='17%'><select name='scrape_type_collect"+tr_id+"' id='scrape_type_collect"+tr_id+"'><option  value='0'  >正常报废</option><option value='1' selected>技术淘汰</option></select></td>";
			}
			innerhtml += "<td width='9%'><input name='bak_collect"+tr_id+"' id='bak_collect"+tr_id+"'  size='9'  type='text' value='"+nodes[tr_id].bak+"' /></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	} --%>
	function toAddDevInfo(){
		var selected = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeApplyLists.jsp?type=1","","dialogWidth=1240px;dialogHeight=480px");
		document.getElementById("scrape_apply_id").value = selected;
		if (selected != null && selected != "") {
			simpleSearch();
		};
	}
	function clearQueryText(){
		 //s_wz_name s_dev_model s_times
   		document.getElementById("s_wz_name").value = "";
   		document.getElementById("s_dev_model").value = "";
   		//document.getElementById("s_times").value = "";
   		document.getElementById("s_scrape_type").value = "";
   		document.getElementById("s_duty_unit").value = "";//责任单位
		document.getElementById("s_org_name").value = "";//所属单位
		document.getElementById("s_project_name").value = "";//项目名称和国家名
   	} 
	var devCount=0;
	function simpleSearch() {
		$("#processtable0").empty();
		var s_wz_name = document.getElementById("s_wz_name").value;
	    var s_dev_model = document.getElementById("s_dev_model").value;
		//var s_times = document.getElementById("s_times").value;
		var s_scrape_type =  document.getElementById("s_scrape_type").value;
		var s_dutyUnit = document.getElementById("s_duty_unit").value;//责任单位
		var s_org_name = document.getElementById("s_org_name").value;//所属单位
		var s_project_name = document.getElementById("s_project_name").value;//项目名和国家名
 	    var message ="&wz_name="+s_wz_name+"&dev_model="+s_dev_model+"&scrape_type="+s_scrape_type+"&s_dutyUnit="+s_dutyUnit+"&s_org_name="+s_org_name+"&s_project_name="+s_project_name;
		var scrape_apply_id = document.getElementById("scrape_apply_id").value;
		var scrape_collect_id =  document.getElementById("scrape_collect_id").value;
		var baseData;
		//baseData = jcdpCallService("ScrapeSrv", "getDmsScrapeApplyInfo", "ids="+ scrape_apply_id);
		//修改方法不去查询单条的设备的信息，而是将信息分类汇总显示“报废单位、报废类别、原值（和）、净值（和）、投产时间（1年内，3年内，五年内，八年内）、是否通过、意见”等内容
		baseData = jcdpCallService("ScrapeSrv", "getScrapeApplyCollect", "ids="+scrape_apply_id+"&scrape_collect_id="+scrape_collect_id+message);
		var map = new Map();
			for   (var i = 0; i< baseData.filetotallist.length; i++) {
					map.put(baseData.filetotallist[i].key,baseData.filetotallist[i].num);		
			}
		if (baseData.datas != null) {
			flag_collect = 1;//申请单已经获取到
			devCount = baseData.datas.length;
			$("#devCount").val(devCount);
			for ( var i = 0; i < baseData.datas.length; i++) {
				debugger;
				var key =baseData.datas[i].scrape_apply_id1+"_"+baseData.datas[i].project_name+"_"+baseData.datas[i].org_name+"_"+baseData.datas[i].dev_name+"_"+baseData.datas[i].dev_type+"_"+baseData.datas[i].scrape_type;
				
				var value=map.get(key);
				tr_id = $("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				//alldev.org_name,alldev.dev_name,alldev.dev_type,alldev.times,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value
				innerhtml += "<input name='duty_unit"+tr_id+"' id='duty_unit"+tr_id+"'  type='hidden' value='"+baseData.datas[i].duty_unit+"'/>";
				innerhtml += "<input name='org_name"+tr_id+"' id='org_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].org_name+"'/>";
				innerhtml += "<input name='org_id"+tr_id+"' id='org_id"+tr_id+"'  type='hidden' value='"+baseData.datas[i].org_id+"'/>";
				innerhtml += "<input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_name+"'/>";
				innerhtml += "<input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_type+"'/>";
				innerhtml += "<input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_model+"'/>";
				//innerhtml += "<input name='times"+tr_id+"' id='times"+tr_id+"'  type='hidden' value='"+baseData.datas[i].times+"'/>";
				innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"'  type='hidden' value='"+baseData.datas[i].asset_value+"'/>";
				innerhtml += "<input name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'  type='hidden' value='"+baseData.datas[i].scrape_type+"'/>";
				innerhtml += "<input name='project_name"+tr_id+"' id='project_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].project_name+"'/>";
				innerhtml += "<input name='scrape_apply_id1"+tr_id+"' id='scrape_apply_id1"+tr_id+"'  type='hidden' value='"+baseData.datas[i].scrape_apply_id1+"'/>";
				innerhtml += "<td width='4.3%'><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].project_name+"</td>";
				innerhtml += "<td width='10%'>"+baseData.datas[i].duty_unit+"</td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].org_name+"</td>";
				innerhtml += "<td width='6%'>"+baseData.datas[i].scrape_types+"</td>";
				innerhtml += "<td width='10%'>"+baseData.datas[i].dev_name+"</td>";
				innerhtml += "<td width='10%'>"+baseData.datas[i].dev_model+"</td>";
				innerhtml += "<td width='6.4%'><a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"条</a></td>";
				/* innerhtml += "<td width='17.4%'>"+baseData.datas[i].dev_name+",共(<a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"</a>)条</td>"; */
				/* innerhtml += "<td>"+baseData.datas[i].dev_type+"</td>"; */
				//innerhtml += "<td width='10%'>"+baseData.datas[i].times+"</td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].asset_value+"</td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].net_value+"</td>";
				//var fileCount = jcdpCallService("ScrapeSrvNew", "getScrapeFileListCollectCount", "org_name="+baseData.datas[i].org_name+"&dev_name="+baseData.datas[i].dev_name+"&dev_type="+baseData.datas[i].dev_type+"&times="+baseData.datas[i].times);
				innerhtml += "<td width='12%'><a href='#' onclick='fujian("+tr_id+")'>资料("+value+")条</a></td>";
				if(baseData.datas[i].sp_pass_flag==0){
					innerhtml += "<td size='9'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0' selected>通过</option><option value='1'>不通过</option></select></td>";
				}else if(baseData.datas[i].sp_pass_flag==1){
					innerhtml += "<td ><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0'>通过</option><option value='1' selected>不通过</option></select></td>";
				}else{//默认值通过
					innerhtml += "<td width='17.4%'><select name='sp_pass_flag"+tr_id+"' id='sp_pass_flag"+tr_id+"'><option  value='0' selected>通过</option><option value='1'>不通过</option></select></td>";
				}
				innerhtml += "<td width='8.7%'><input name='sp_bak1"+tr_id+"' id='sp_bak1"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[i].sp_bak1+"'/></td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		};

	}
	function toDeleteDevInfo() {
		$("input[name='idinfo']").each(function() {
			if (this.checked == true) {
				$('#tr' + this.id, "#processtable0").remove();
			}
		});
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	function subgo(i){
		var project_name=$("#project_name"+i).val();
		var scrape_collect_id ="'"+$("#scrape_collect_id").val()+"'";
		var scrape_apply_id = $("#scrape_apply_id").val();
		var org_name=$("#org_name"+i).val();
		var org_id=$("#org_id"+i).val();
		var dev_name=$("#dev_name"+i).val();
		var dev_type=$("#dev_type"+i).val();
		var dev_model=$("#dev_model"+i).val();
		var times=$("#times"+i).val();
		var sp_pass_flag=$("#sp_pass_flag"+i).val();
		var sp_bak1=$("#sp_bak1"+i).val();
		var scrape_type = $("#scrape_type"+i).val();
		var obj = new Object();
		var pageselectedstr = null;
		obj.pageselectedstr = pageselectedstr;
		org_name = encodeURI(encodeURI(org_name));
		dev_name = encodeURI(encodeURI(dev_name));
		dev_model = encodeURI(encodeURI(dev_model));
		times = encodeURI(encodeURI(times));
		project_name = encodeURI(encodeURI(project_name));
		
	 	var returnFlag = popWindow("/DMS/dmsManager/scrape/selectScrapeListCollect.jsp?org_name="+org_name+"&org_id="+org_id+"&dev_name="+dev_name+"&dev_model="+dev_model+"&dev_type="+dev_type+"&times="+times+"&scrape_type="+scrape_type+"&project_name="+project_name,'','报废评审查看');
	 	if(returnFlag=="1"){
			window.location.reload();
		}
	};
	function fujian(i){
		var scrape_collect_id ="'"+$("#scrape_collect_id").val()+"'";
		var scrape_apply_id1 = $("#scrape_apply_id1"+i).val();
		var scrape_type=$("#scrape_type"+i).val();
		var project_name=$("#project_name"+i).val(); 
		var org_name=$("#org_name"+i).val();
		var dev_name=$("#dev_name"+i).val();
		var dev_type=$("#dev_type"+i).val();
		var times=$("#times"+i).val();
		var sp_pass_flag=$("#sp_pass_flag"+i).val();
		var sp_bak1=$("#sp_bak1"+i).val();
		var obj = new Object();
		var pageselectedstr = null;
		obj.pageselectedstr = pageselectedstr;
		org_name = encodeURI(encodeURI(org_name));
		dev_name = encodeURI(encodeURI(dev_name));
		project_name = encodeURI(encodeURI(project_name));
	 
		times = encodeURI(encodeURI(times));
	 	window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeFileListCollect.jsp?org_name="+org_name+"&dev_name="+dev_name+"&dev_type="+dev_type+"&times="+times+"&scrape_type="+scrape_type+"&project_name="+project_name+"&scrape_apply_id1="+scrape_apply_id1,"","dialogWidth=1240px;dialogHeight=480px");
	}
	function guid() {
  	return 'xxxxxxx-xxxx-4xxx-yxxx-xxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
    return v.toString(16);
  });
}
	
</script>
</html>

