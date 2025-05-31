<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg msg = OMSMVCUtil.getResponseMsg(request);
	String scrape_apply_id = msg.getValue("scrape_apply_id");
    java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
	String bussId = request.getParameter("bussId");
	if(bussId==null||bussId.equals("")){
		bussId = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">    
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">    
<META HTTP-EQUIV="Expires" CONTENT="0">  
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
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
<title>报废申请固定资产报废录入</title>
<style type="text/css">


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
.my_input_width {
	width:70%;
	height:20px;
	line-height:20px;
	float:left;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
      	<input name="scrape_asset_id" id="scrape_asset_id" type="hidden" />
      	<input name="scrape_detailed_id" id="scrape_detailed_id" type="hidden" />
      	<input name="file_id" id="file_id" type="hidden" />
      	<input name="expert_ids" id="expert_ids"  class="input_width" type="hidden" />
      	<input name="employee_names" id="employee_names"  class="input_width" type="hidden" />
      	<input name="employee_ids" id="employee_ids"  class="input_width" type="hidden" />
        <tr>
          <td class="inquire_item4">报废申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="scrape_apply_name" id="scrape_apply_name" class="input_width" type="text" value="" />
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
      </table>    
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>添加附件</legend>
      	  <input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      	  <input name="parmeter" id="parmeter" type="hidden" value=""/>
	  	  <div>
	  	  	<table width="97.9%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRowsdamage()'" title="添加附件"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tableAsset">
				<input name="flag_asset" id="flag_asset" type="hidden"/>
				</table>
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd">&nbsp;</td>
					<td class="bt_info_even">附件</td>
					<td class="bt_info_odd">操作</td>
				</tr>
				</table>
			   <div style="height:80px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtablefj" name="processtablefj" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>正常报废</legend>
	      <div border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" style="height:300px">
			 <iframe id="devMenuZcbf" width="99%" cellSpacing=5 cellPadding=0 width=570 style="height:300px" border=0 src="<%=contextPath %>/dmsManager/scrape/devMenu.jsp?bussId=<%=bussId%>&scrapeType=0&scrape_apply_id=<%=scrape_apply_id %>"></iframe>
		  </div>
      </fieldSet>
       <fieldSet style="margin-left:2px"><legend>技术淘汰</legend>
	      <div border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" style="height:300px">
			 <iframe id="devMenuJstt" width="99%" cellSpacing=5 cellPadding=0 width=570 style="height:300px" border=0 src="<%=contextPath %>/dmsManager/scrape/devMenu.jsp?bussId=<%=bussId%>&scrapeType=1&scrape_apply_id=<%=scrape_apply_id %>"></iframe>
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
          	<input id="appraisal_date" name="appraisal_date" class="input_width" type="text"  value="<%=nowTime%>" readonly/>
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
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>鉴定小组成员</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body" id="OPERATOR_body">
			</tbody>
	  	</table>
	  </fieldset>
	</div>
    </div>
    <div id="oper_div">
     	<span class="xyb_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='radio'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function showDevCodePage(index){
	var obj = new Object();
	var pageselectedstr = null;
	var checkstr = 0;
	$("input[name^='detdev_ci_code'][type='hidden']").each(function(i){
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
	//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号
	if(returnval!=undefined){
		var returnvals = returnval.split("~",-1);
		$("#dev_name"+index).val(returnvals[2]);
		$("#dev_model"+index).val(returnvals[3]);
		$("#detdev_ci_code"+index).val(returnvals[0]);
		$("#dev_type"+index).val(returnvals[1]);
	}
}
function copyexpert()
{
	$("#employeeName1").val($("#expert_leader").val());
}

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
		/* $("#expert_leader").val(baseData.deviceAssetMap.expert_leader);
		$("#expert_leader_id").val(baseData.deviceAssetMap.expert_leader_id);
		$("#employeeName1").val(baseData.deviceAssetMap.expert_leader);
		$("#employeeId1").val(baseData.deviceAssetMap.expert_leader_id); */
		if(baseData.deviceAssetMap.appraisal_date!=""){
			$("#appraisal_date").val(baseData.deviceAssetMap.appraisal_date);
		}
		if(baseData.deviceEmpMap!=null){
			$("#expert_ids").val(baseData.deviceEmpMap.expert_ids);//专家表id
			$("#employee_names").val(baseData.deviceEmpMap.employee_names);//专家名称
			//$("#employee_names").val(baseData.deviceAssetMap.expert_members);//专家名称
			$("#employee_ids").val(baseData.deviceEmpMap.employee_ids);//专家id
		}
		if(baseData.fdatafj!=null)
		{
			$("#processtablefj").empty();
			for (var tr_id = 1; tr_id<=baseData.fdatafj.length; tr_id++) {
				insertFilefj(baseData.fdatafj[tr_id-1].file_name,baseData.fdatafj[tr_id-1].file_type,baseData.fdatafj[tr_id-1].file_id,tr_id);
			}
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
		innerhtml += 	"<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='selectPerson(this)'/>";
		innerhtml += "</td>";
		innerhtml +="<td><span class='sc'><a href='#' onclick='removrowselectemp(this)'  title='删除'></a></span></td>";
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
		innerhtml += 	"<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='selectPerson(this)'/>";
		innerhtml += "</td>";
		innerhtml +="<td><span class='sc'><a href='#' onclick='removrow(this)'  title='删除'></a></span></td>";
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
//插入文件
function insertFilefj(name,type,id,tr_id){
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml +="<td style='text-align:center;'><input type='radio' name='idinfo' id='idinfo_"+tr_id+"' onclick='getLinkDev(this)' value='"+id+"'/></td>";
	innerhtml +="<td style='text-align:center;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"' class='my_input_width'>"+name+"</a></td>";
	innerhtml +="<td  style='text-align:center;'><span class='tj'><a href='javascript:void(0);' onclick='linkDev(this,\""+tr_id+"\",\""+id+"\")'  title='建立关联'></a></span>&nbsp;";
	innerhtml +="<span class='sc'><a href='javascript:void(0);' onclick=deleteFilefj(this,\""+id+"\") title='删除'></a></span></td>";
	innerhtml +="<input type='hidden' readonly='readonly' name='doc_name__"+id+"' id='doc_name__"+id+"' value="+name+"/>";
	innerhtml +="</tr>";
	$("#processtablefj").append(innerhtml);
	
	$("#processtablefj>tr:odd>td:odd").addClass("odd_odd");
	$("#processtablefj>tr:odd>td:even").addClass("odd_even");
	$("#processtablefj>tr:even>td:odd").addClass("even_odd");
	$("#processtablefj>tr:even>td:even").addClass("even_even");
}
function deleteFilefj(item,id){
	if(confirm('确定要删除吗?')){  
		$(item).parent().parent().parent().empty();
		var tmp=new Date().getTime();
		$("#processtablefj").append("");
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
	}
}
function addRowsdamage(){
	tr_id = $("#processtablefj>tr:last").attr("id");
	if(tr_id != undefined){
		tr_id = parseInt(tr_id.substr(2,1),10);
	}
	if(tr_id == undefined){
		tr_id = 0;
	}else{
		tr_id = tr_id+1;
	}
	$("#colnumdmage").val(tr_id);
	var tmp=new Date().getTime();
	//动态新增表格
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml += "<td style='text-align:center;'><input type='radio' name='idinfo' id='idinfo_"+tr_id+"'/></td>";
	innerhtml += "<td style='text-align:center;'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfofj(this)' class='my_input_width'/></td>";
	innerhtml += "<td style='text-align:center;'><span class='tj'><a href='javascript:void(0);' onclick='linkDev(this,"+tr_id+","+tmp+")'  title='建立关联'></a></span>";
	innerhtml += "<span class='sc'><a href='javascript:void(0);' onclick='deleteInputfj(this)'  title='删除'></a></span></td>";
	innerhtml += "<input type='hidden' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'>";
	innerhtml += "</tr>";
	$("#processtablefj").append(innerhtml);
	
	$("#processtablefj>tr:odd>td:odd").addClass("odd_odd");
	$("#processtablefj>tr:odd>td:even").addClass("odd_even");
	$("#processtablefj>tr:even>td:odd").addClass("even_odd");
	$("#processtablefj>tr:even>td:even").addClass("even_even");
};

////////////////////
function getLinkDev(item){
	chooseOne(item);
	//选中的话执行关联操作查询fileId
	//正常报废链接
	var zcbfUrl = window.frames["devMenuZcbf"].location.href.split("&fileId")[0];
	//技术淘汰链接
	var jsttUrl = window.frames["devMenuJstt"].location.href.split("&fileId")[0];
	if(item.checked){
		fileId = item.value;
		window.frames["devMenuZcbf"].location.href=zcbfUrl+"&fileId="+fileId;
		window.frames["devMenuJstt"].location.href=jsttUrl+"&fileId="+fileId;
	}
}
function linkDev(item,tr_id,tmp){
	var ids = "";
	
	var idsZcbf = "";
	idsZcbf += window.frames["devMenuZcbf"].frames["devList"].getSelectedNow();//正常报废
	idsZcbf += window.frames["devMenuZcbf"].frames["devList"].idsPlus;
	
	var idsJstt = "";
	idsJstt += window.frames["devMenuJstt"].frames["devList"].getSelectedNow();//正常报废
	idsJstt += window.frames["devMenuJstt"].frames["devList"].idsPlus;
	
	if(idsZcbf==""){
		if(idsJstt==""){
			alert("您尚未选中要关联的设备");
		}else{
			ids+=idsJstt;
		}
	}else{
		ids+=idsZcbf;
		if(idsJstt!=""){
			ids+=idsJstt;
		}
	}
	$("#scrape_detailed_id").val(ids);
	$("#file_id").val(tmp);//文件
	var dev_filename = document.getElementById("doc_name__"+tmp).value;
	if(dev_filename !=""){
		Ext.MessageBox.wait('请等待','处理中');
		Ext.Ajax.request({
			url : "<%=contextPath%>/dmsManager/scrape/saveLinkdync.srq",
			method : 'Post',
			isUpload : true,  
			form : "form1",
			success : function(resp){
				var myData = eval("("+resp.responseText+")");
				var nodes = myData.nodes;
				alert(myData.returnMsg);
				Ext.MessageBox.hide();
				//刷新附件列表
				
			},
			failure : function(resp){// 失败
				var myData = eval("("+resp.responseText+")");
				alert(myData.returnMsg);
			}
		}); 
	}else{
		alert("请上传附件！");
		return;
	}
	var ininfo = $("#idinfo_"+tr_id).val();//获取当前行附件的id值
	//方法提交
}
//删除行
function deleteInputfj(item){
	$(item).parent().parent().parent().remove();
}
function getFileInfofj(item){
	var docPath = $(item).val();
	var order = $(item).attr("id").split("__")[1];
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#doc_name__"+order).val(docTitle);//文件name
	
}
function chooseOne(cb){
    var obj = document.getElementsByName("idinfo");  
    for (i=0; i<obj.length; i++){
        if (obj[i]!=cb) obj[i].checked = false;
        else obj[i].checked = true;
    }
}
//选择申请人
function selectPerson(num){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/dmsManager/scrape/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	if(num==1){
    		document.getElementById("expert_leader_id").value=teamInfo.fkValue;
    		document.getElementById("expert_leader").value=teamInfo.value;
	        document.getElementById("employeeId1").value = teamInfo.fkValue;
	        document.getElementById("employeeName1").value = teamInfo.value;
    	}else{
    		var nums = $(num).parent().parent()[0].seq;
    		document.getElementById("employeeId"+nums).value = teamInfo.fkValue;
 	        document.getElementById("employeeName"+nums).value = teamInfo.value;
    	}
    }
}
function saveInfo(){
	var tr_id = $("#OPERATOR_body>tr:last").attr("id");
	var wrong="";
	for(var num=0;num<optnum;num++)
	{
		if($("#employeeName"+num+"").val()== undefined){
			
		}else if($("#employeeName"+num+"").val()== "")
			{
				wrong=num;
			}
	}
	if(wrong!="")
	{
		alert("鉴定成员"+wrong+"不能为空!");
		return;
	}
	var employee_names="" ;
	var employee_ids ="";
	for(var num=0;num<=optnum;num++)
	{
		if($("#employeeName"+num+"").val()!= undefined){//排除被删除的节点
			employee_names=employee_names+$("#employeeName"+num+"").val()+",";
			employee_ids = employee_ids+$("#employeeId"+num+"").val()+",";
		}
	}
	if(employee_names.split(",").length>1)
	employee_names = employee_names.substring(0, employee_names.length-1);
	$("#employee_names").val(employee_names);
	$("#expert_members").val(employee_names);
	if(employee_ids.split(",").length>1)
	employee_ids = employee_ids.substring(0, employee_ids.length-1);
	$("#employee_ids").val(employee_ids);
	//保留的行信息
	var count = 0;
	var result= 0;
	var line_infos;
	var idinfos ;
	var text1="";
	document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeAssetInfo.srq";
	document.getElementById("form1").submit();
}
</script>
</html>

