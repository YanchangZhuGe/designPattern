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
    
  	String scrape_report_id = request.getParameter("scrape_report_id");
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
<title>报废批复表</title>
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
      <fieldSet style="margin:2px:padding:2px;"><legend>报废批复基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_report_id" id="scrape_report_id" type="hidden" value="<%=scrape_report_id%>" />
      	<input name="scrape_collect_id" id="scrape_collect_id" type="hidden"/>
        <input name="expert_members" id="expert_members"  class="input_width" type="hidden" />
        <input name="scrape_damage_id" id="scrape_damage_id" type="hidden" />
        <input name="colnumdamage" id="colnumdamage" class="input_width" type="hidden" value="" readonly/>
      	<input name="parmeterdamage" id="parmeterdamage" type="hidden" value=""/>
      	<input name="devCount" id="devCount" type="hidden" value=""/>
        <tr>
          <td class="inquire_item6">报废批复单名称:<font color="red">*</font></td>
          <td class="inquire_form6" colspan="2">
          	<input name="scrape_report_name" id="scrape_report_name" class="input_width" type="text" value="" />
          </td>
          <td class="inquire_item6">批复单位名称:</td>
          <td class="inquire_form6" colspan="2">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item6">报废批复单号:</td>
          <td class="inquire_form6">
          	<input name="scrape_apply_no" id="scrape_apply_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item6">批复时间:</td>
          <td class="inquire_form6">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
          <td class="inquire_item6">批复人:</td>
          <td class="inquire_form6">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
      <!-- add by zzb -->
      <fieldSet style="margin-left:2px"><legend>报废批复详细信息</legend>
      	  <input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      	  <input name="parmeter" id="parmeter" type="hidden" value=""/>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
		  	  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tableReport">
				<input name="flag_report" id="flag_report" type="hidden"/>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="xz" event="onclick='exportDevData()'" title="导出设备"></auth:ListButton>
							    </tr>
							</table>
				</table>
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<!-- <td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >设备型号</td> -->
					<td class="bt_info_odd" >设备所属单位</td>
					<td class="bt_info_even" >数量</td>
					<!-- <td class="bt_info_odd">年限</td> -->
					<td class="bt_info_odd">原值</td>
					<td class="bt_info_odd">累计折旧</td>
					<td class="bt_info_even">减值准备</td>
					<td class="bt_info_even">净值</td>
					<!-- <td class="bt_info_odd">相关资料</td> -->
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
      <!-- <fieldSet style="margin:2px:padding:2px;"><legend>鉴定信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <tr>
          <td colspan="1" >专家名单:</td>
          <td colspan="2">
           <textarea id="experts" name="experts"  class="textarea" ></textarea>
          </td>
           <td colspan="1" >专家意见:</td>
          <td colspan="2">
           <textarea id="bak" name="bak"  class="textarea" ></textarea>
          </td>
        </tr>
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
      </fieldSet> -->
      <!-- add by zzb -->
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
//add by zzb
cruConfig.contextPath='<%=contextPath%>';
var flag_report = 0;//固定资产附件标示 flag_report 0 默认值、1附件导入2手动添加
var flag_damage = 0;//毁损附件标示
var flag_file = 0;//附件标示
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinforeport']").attr('checked',checkvalue);
	});
	$("#hirecheckeddamage").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfodamage']").attr('checked',checkvalue);
	});
});
function addRowsreport(status){
	//flag_report 0 默认值、1附件导入2手动添加
	if(flag_report!=1){
		flag_report = status;
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
	innerhtml += "<input name='detdev_ci_code_report"+tr_id+"' id='detdev_ci_code_report"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='report_coding"+tr_id+"' id='report_coding"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='report_value"+tr_id+"' id='report_value"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<td><input type='checkbox' name='idinforeport' id='"+tr_id+"' checked/></td>";
	innerhtml += "<td width='27%'><input name='dev_name_report"+tr_id+"' id='dev_name_report"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagereport("+tr_id+")' />";
	innerhtml += "</td>";
	innerhtml += "<td width='17%'><input name='report_coding_report"+tr_id+"' id='report_coding_report"+tr_id+"' value='' size='16'  type='text' readonly /></td>";
	innerhtml += "<td width='17%'><input name='dev_coding_report"+tr_id+"' id='dev_coding_report"+tr_id+"' value='' size='16' type='text' readonly/>";
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
function showDevCodePagereport(index){
var obj = new Object();
var pageselectedstr = null;
var checkstr = 0;
$("input[name^='detdev_ci_code_report'][type='hidden']").each(function(i){
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
	$("#dev_name_report"+index).val(returnvals[2]);
	$("#report_coding_report"+index).val(returnvals[3]);
	$("#detdev_ci_code_report"+index).val(returnvals[0]);
	$("#dev_coding_report"+index).val(returnvals[1]);
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
	function saveInfo(){
		$("#scrape_report_no").val("");
		if($("#scrape_report_name").val()==""){
			alert("报废批复单名称不能为空!");
			return;
		}
		if($("#apply_date").val()==""){
			alert("批复日期不能为空!");
			return;
		}
		var count = $("#devCount").val();
		for(var i = 0;i<count;i++){
			if($("#sp_pass_flag"+i).val()==1&&$("#sp_bak1"+i).val()==""){
				alert("审批不通过的请注明意见！！");
				return;
			}
			
		}
		/* if(flag_file!=1||flag_report!=1){
			alert("未添加批复单或未导入批复单审批报废设备信息!");
			return;
		} */
		//zjb start
		Ext.MessageBox.wait('正在操作','请稍后...');
		Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/addScrapeallReport.srq",
					method : 'Post',
					isUpload : true,  
					async :  true,
					form : "form1",
					success : function(resp){
						 Ext.MessageBox.hide();
					},
					callback :function(){
						 Ext.MessageBox.hide();
					},
					failure : function(resp){// 失败
						 Ext.MessageBox.hide();
						/* Ext.MessageBox.confirm('提示','保存失败！'); */
					}
				});
		//zjb end
		//折损部分结束
	}
	function refreshData(){
		var baseData;
		//修改的时候的操作
		if('<%=scrape_report_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeReportAllInfo", "scrape_report_id="+$("#scrape_report_id").val());
			 $("#scrape_report_no").val(baseData.deviceappMap.scrape_report_no);
			$("#scrape_report_name").val(baseData.deviceappMap.scrape_report_name);
			$("#apply_date").val(baseData.deviceappMap.report_date);
			//批复附件
			if(baseData.fdataReport!=null){
				for (var tr_id = 1; tr_id<=baseData.fdataReport.length; tr_id++) {
					insertFileReport(baseData.fdataReport[tr_id-1].file_name,baseData.fdataReport[tr_id-1].file_type,baseData.fdataReport[tr_id-1].file_id);
				}
			}
			//批复申请表datasApply
			if(baseData.datas!=null){
				devCount = baseData.datas.length;
				$("#devCount").val(devCount);
			for (var i = 0; i< baseData.datas.length; i++) {
				tr_id = $("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				innerhtml += "<input name='scrape_apply_id"+tr_id+"' id='scrape_apply_id"+tr_id+"'  type='hidden' value='"+baseData.datas[i].scrape_apply_id+"'/>";
				innerhtml += "<input name='org_name"+tr_id+"' id='org_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].org_name+"'/>";
				/* innerhtml += "<input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_name+"'/>";
				innerhtml += "<input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_type+"'/>";
				innerhtml += "<input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_model+"'/>";
				innerhtml += "<input name='times"+tr_id+"' id='times"+tr_id+"'  type='hidden' value='"+baseData.datas[i].times+"'/>"; */
				innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"'  type='hidden' value='"+baseData.datas[i].asset_value+"'/>";
				innerhtml += "<td width='4.3%'><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				/* innerhtml += "<td width='15%'>"+baseData.datas[i].dev_name+"</td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].dev_model+"</td>"; */
				innerhtml += "<td width='15%'>"+baseData.datas[i].org_name+"</td>";
				innerhtml += "<td width='6.4%'><a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"条</a></td>";
				/* innerhtml += "<td width='17.4%'>"+baseData.datas[i].dev_name+",共(<a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"</a>)条</td>"; */
				/* innerhtml += "<td>"+baseData.datas[i].dev_type+"</td>"; */
				/* innerhtml += "<td width='10%'>"+baseData.datas[i].times+"</td>"; */
				innerhtml += "<td width='8%'>"+baseData.datas[i].asset_value+"</td>";
				innerhtml += "<td width='8%'></td>";
				innerhtml += "<td width='8%'></td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].net_value+"</td>";
				/* var fileCount = jcdpCallService("ScrapeSrvNew", "getScrapeFileListCollectCount", "org_name="+baseData.datas[i].org_name+"&dev_name="+baseData.datas[i].dev_name+"&dev_type="+baseData.datas[i].dev_type+"&times="+baseData.datas[i].times);
				innerhtml += "<td width='12%'><a href='#' onclick='fujian("+tr_id+")'>资料("+fileCount.num+")条</a></td>";
				 */innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
			}
		
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
			}
			
			//other
			/* $("#bak").val(baseData.deviceappMap.bak);
			$("#experts").val(baseData.deviceappMap.experts); */	
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
		//flag_report 0 默认值、1附件导入2手动添加
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
	function insertFileReport(name,type,id){
		$("#file_tableReport").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5'><span class='sc'><a href='javascript:void(0);' onclick=deleteFileReport(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除文件
	function deleteFileReport(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_tableReport").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoReport(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='excel_name_"+tmp+"' id='excel_name_"+tmp+"' class='input_width' /><input type='hidden' id='doc_type_"+tmp+"' name='doc_type_"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputReport(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_report = 1;
		}
	}
	function getFileInfoReport(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#excel_name_"+order).val(docTitle);//文件name
		flag_file = 1;
	}
	//删除行
	function deleteInputReport(item){
		flag_report = 0;
		$(item).parent().parent().parent().remove();
		checkInfoList();
		
	}

	<%-- function refreshDataDync(nodes){
		for (var tr_id = 0; tr_id< nodes.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code_report"+tr_id+"' id='detdev_ci_code_report"+tr_id+"' value='"+nodes[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinforeport' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='27%'><input name='dev_name_report"+tr_id+"' id='dev_name_report"+tr_id+"' style='line-height:15px' value='"+nodes[tr_id].dev_name+"' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePagereport("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td width='17%'><input name='report_coding_report"+tr_id+"' id='report_coding_report"+tr_id+"' value='"+nodes[tr_id].report_coding+"' size='16'  type='text' readonly /></td>";
			innerhtml += "<td width='17%'><input name='dev_coding_report"+tr_id+"' id='dev_coding_report"+tr_id+"' value='"+nodes[tr_id].dev_coding+"' size='16' type='text' readonly/>";
			if(nodes[tr_id].scrape_type==0){
				innerhtml += "<td width='17%'><select name='scrape_type_report"+tr_id+"' id='scrape_type_report"+tr_id+"'><option  value='0' selected >正常报废</option><option value='1'>技术淘汰</option></select></td>";
			}
			if(nodes[tr_id].scrape_type==1){
				innerhtml += "<td width='17%'><select name='scrape_type_report"+tr_id+"' id='scrape_type_report"+tr_id+"'><option  value='0'  >正常报废</option><option value='1' selected>技术淘汰</option></select></td>";
			}
			innerhtml += "<td width='9%'><input name='bak_report"+tr_id+"' id='bak_report"+tr_id+"'  size='9'  type='text' value='"+nodes[tr_id].bak+"' /></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	} --%>
	function toAddDevInfo(){
		var selected = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeCollectLists.jsp","","dialogWidth=1240px;dialogHeight=480px");
		debugger;
		document.getElementById("scrape_collect_id").value = selected;
		if (selected != null && selected != "") {
			addLine();
		};
	}
	var devCount=0;
	function addLine() {
		var scrape_collect_id = document.getElementById("scrape_collect_id").value;
		var baseData;
		//baseData = jcdpCallService("ScrapeSrv", "getDmsScrapeApplyInfo", "ids="+ scrape_collect_id);
		//修改方法不去查询单条的设备的信息，而是将信息分类批复显示“报废单位、报废类别、原值（和）、净值（和）、投产时间（1年内，3年内，五年内，八年内）、是否通过、意见”等内容
		baseData = jcdpCallService("ScrapeSrv", "getScrapeCollectReport", "ids="+ scrape_collect_id);
		if (baseData.datas != null) {
			flag_report = 1;//批复单已经获取到
			devCount = baseData.datas.length;
			$("#devCount").val(devCount);
			for ( var i = 0; i < baseData.datas.length; i++) {
				tr_id = $("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				//alldev.org_name,alldev.dev_name,alldev.dev_type,alldev.times,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value
				innerhtml += "<input name='org_name"+tr_id+"' id='org_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].org_name+"'/>";
				innerhtml += "<input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_name+"'/>";
				innerhtml += "<input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_type+"'/>";
				innerhtml += "<input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'  type='hidden' value='"+baseData.datas[i].dev_model+"'/>";
				innerhtml += "<input name='times"+tr_id+"' id='times"+tr_id+"'  type='hidden' value='"+baseData.datas[i].times+"'/>";
				innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"'  type='hidden' value='"+baseData.datas[i].asset_value+"'/>";
				innerhtml += "<td width='4.3%'><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].dev_name+"</td>";
				innerhtml += "<td width='15%'>"+baseData.datas[i].dev_model+"</td>";
				innerhtml += "<td width='6.4%'><a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"条</a></td>";
				/* innerhtml += "<td width='17.4%'>"+baseData.datas[i].dev_name+",共(<a href='#' onclick='subgo("+tr_id+")'>"+baseData.datas[i].counts+"</a>)条</td>"; */
				/* innerhtml += "<td>"+baseData.datas[i].dev_type+"</td>"; */
				innerhtml += "<td width='10%'>"+baseData.datas[i].times+"</td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].asset_value+"</td>";
				innerhtml += "<td width='8%'>"+baseData.datas[i].net_value+"</td>";
				var fileCount = jcdpCallService("ScrapeSrvNew", "getScrapeFileListCollectCount", "org_name="+baseData.datas[i].org_name+"&dev_name="+baseData.datas[i].dev_name+"&dev_type="+baseData.datas[i].dev_type+"&times="+baseData.datas[i].times);
				innerhtml += "<td width='12%'><a href='#' onclick='fujian("+tr_id+")'>资料("+fileCount.num+")条</a></td>";
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
		var scrape_collect_id ="'"+$("#scrape_collect_id").val()+"'";
		var scrape_apply_id = $("#scrape_apply_id"+i).val();
		var org_name=$("#org_name"+i).val();
		org_name = encodeURI(encodeURI(org_name));
		var dev_name=null;
		var dev_type=null;
		var dev_model=null;
		var times=null;
		var sp_pass_flag=$("#sp_pass_flag"+i).val();
		var sp_bak1=null;
		var obj = new Object();
		var pageselectedstr = null;
		obj.pageselectedstr = pageselectedstr;
	 	window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeListCollect.jsp?org_name="+org_name+"&dev_name="+dev_name+"&dev_model="+dev_model+"&dev_type="+dev_type+"&times="+times+"&scrape_apply_id="+scrape_apply_id,obj,"dialogWidth=1240px;dialogHeight=480px");
	};
	function fujian(i){
		var scrape_collect_id ="'"+$("#scrape_collect_id").val()+"'";
		var scrape_apply_id = $("#scrape_apply_id").val();
		var org_name=$("#org_name"+i).val();
		var dev_name=$("#dev_name"+i).val();
		var dev_type=$("#dev_type"+i).val();
		var times=$("#times"+i).val();
		var sp_pass_flag=$("#sp_pass_flag"+i).val();
		var sp_bak1=$("#sp_bak1"+i).val();
		var obj = new Object();
		var pageselectedstr = null;
		obj.pageselectedstr = pageselectedstr;
	 	window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeFileListCollect.jsp?org_name="+org_name+"&dev_name="+dev_name+"&dev_type="+dev_type+"&times="+times,obj,"dialogWidth=1240px;dialogHeight=480px");
	}
	//上报数据导出
    function exportDevData(){
    	var scrape_report_id="";
    	scrape_report_id="'"+$("#scrape_report_id").val()+"'";
    	if(scrape_report_id=="''"){
    		alert("暂时无上报数据");
    		return;
    	}
    	var exportFlag = 'bfsbcx';
    	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
    	var submitStr="scrape_report_id="+scrape_report_id+"&exportFlag="+exportFlag;
    	var retObj = syncRequest("post", path, submitStr);
    	var filename=retObj.excelName;
    	filename = encodeURI(filename);
    	filename = encodeURI(filename);
    	var showname=retObj.showName;
    	showname = encodeURI(showname);
    	showname = encodeURI(showname);
    	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
    }
</script>
</html>

