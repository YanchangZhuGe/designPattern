<%@ page contentType="text/html;charset=utf-8"%>
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
	String proStatus = msg.getValue("proStatus");
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
<title>报废申请盘亏毁损录入</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
  		<input name="scrape_damage_id" id="scrape_damage_id" type="hidden" />
  		<input name="scrape_detailed_id" id="scrape_detailed_id" type="hidden" />
     	<input name="file_id" id="file_id" type="hidden" />
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      	<input name="parmeter" id="parmeter" type="hidden" value=""/>
      	<input name="proStatus" id="proStatus" type="hidden"/>
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
   			<td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          
          </td>
        </tr>
      </table>    
      </fieldSet>
       <fieldSet style="margin-left:2px"><legend><font color="red">第二步：盘亏及毁损设备详细信息</font></legend>
	      <div border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" style="height:300px">
			 <iframe id="devMenuZcbf" width="99%" cellSpacing=5 cellPadding=0 width=570 style="height:300px" border=0 src="<%=contextPath %>/dmsManager/scrape/devListNew.jsp?scrapeType=23&bussId=<%=bussId%>&scrape_apply_id=<%=scrape_apply_id %>"></iframe>
		  </div>
      </fieldSet>
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
	function saveInfo(){
		var  baseData = jcdpCallService("ScrapeSrvNew", "getScrapeFileInfo", "scrape_apply_id="+$("#scrape_apply_id").val()+"&scrape_type=23");
		if(baseData.msg!='false'){
		alert("没有关联附件设备："+baseData.msg);
		return;
		}
		//if(!confirm("您确认所有设备都已鉴定及关联附件?")){
		//	return;
		//}
		//保留的行信息
		var count = 0;
		var result= 0;
		var line_infos;
		var idinfos ;
		var text="";
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeDamageInfo.srq";
		document.getElementById("form1").submit();
	}
	function refreshData(){
		if('<%=scrape_apply_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeDamageInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
			 var proStatus= '<%=proStatus%>';
				if(proStatus=='1'||proStatus=='3'){
					$("#scrape_apply_name").attr("readonly","readonly");
					$("#proStatus").val(proStatus);
					$("#oper_div>span:first>a").attr("onclick","");
				}
			 	$("#scrape_apply_no").val(baseData.deviceAssetMap.scrape_apply_no);
				$("#scrape_asset_id").val(baseData.deviceAssetMap.scrape_asset_id);
				$("#scrape_apply_name").val(baseData.deviceAssetMap.scrape_apply_name);
				$("#apply_date").val(baseData.deviceAssetMap.apply_date);
				$("#scrape_damage_id").val(baseData.deviceAssetMap.scrape_damage_id);
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
					innerhtml += "<td width='27%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
					innerhtml += "</td>"
					innerhtml += "<td width='17%'><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='16'  type='text' readonly /></td>";
					innerhtml += "<td width='17%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+baseData.datas[tr_id].dev_type+"' size='16' type='text' readonly/>";
					if(baseData.datas[tr_id].scrape_type==2)
						{
						innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option  value='2' selected >毁损</option><option value='3'>盘亏</option></select></td>";
						}
					if(baseData.datas[tr_id].scrape_type==3)
					{
					innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option  value='2'  >毁损</option><option value='3' selected>盘亏</option></select></td>";
					}
					
					innerhtml += "<td width='9%'><input name='bak"+tr_id+"' id='bak"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[tr_id].bak1+"' /></td>";
					innerhtml += "</tr>";
					$("#processtable0").append(innerhtml);
					}
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
		}
	}
	}
	
	function addRows(value){
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
		innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
		innerhtml += "<td width='27%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
		innerhtml += "</td>"
		innerhtml += "<td width='17%'><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='' size='16'  type='text' readonly /></td>";
		innerhtml += "<td width='17%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='' size='16' type='text' readonly/>";
		innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option value='2' >毁损</option><option value='3'>盘亏</option></select></td>";
		innerhtml += "<td width='9%'><input name='bak"+tr_id+"' id='bak"+tr_id+"' value='' size='9'  type='text' /></td>";
		innerhtml += "</tr>";
		$("#processtable0").append(innerhtml);
		
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
};
function delRows(){
	$("input[name='idinfo']").each(function(){
		if(this.checked == true){
			$('#tr'+this.id,"#processtable0").remove();
		}
	});
	
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
};
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
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});

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
	idsZcbf += window.frames["devMenuZcbf"].frames["devList"].getSelectedNow();//盘亏
	idsZcbf += window.frames["devMenuZcbf"].frames["devList"].idsPlus;
	
	var idsJstt = "";
	idsJstt += window.frames["devMenuJstt"].frames["devList"].getSelectedNow();//毁损
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
			ids+=","+idsJstt;
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
</script>
</html>

