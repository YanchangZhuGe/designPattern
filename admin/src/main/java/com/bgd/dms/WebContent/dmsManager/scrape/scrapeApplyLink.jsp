<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String scrape_apply_id = request.getParameter("scrape_apply_id");
	if(scrape_apply_id==null||scrape_apply_id.equals("")){
		scrape_apply_id = "";
	}
	String scrape_detailed_id = request.getParameter("scrape_detailed_id");
	if(scrape_detailed_id==null||scrape_apply_id.equals("")){
		scrape_detailed_id = "";
	}
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
	width:50%;
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
       <fieldSet style="margin:2px:padding:2px;"><legend>报废申请单</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
      	<input name="scrape_detailed_id" id="scrape_detailed_id" type="hidden" value="<%=scrape_detailed_id%>"/>
      	<input type='hidden' name='idinfos' id='idinfos'/>
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
          <td class="inquire_item4">鉴定小组组长:</td>
          <td class="inquire_form4" >
           <input type="hidden" id="expert_id" name="expert_id" value=""/>
            <input type="hidden" id="expert_leader_id" name="expert_leader_id" value=""/>
			<input type="text"  unselectable="on"   readonly="readonly" value="" maxlength="32" id="expert_leader" name="expert_leader" class='input_width'></input>
			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson(1)"/>
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
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='radio'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function refreshData(){
	var baseData;
	if('<%=scrape_apply_id%>'!='null'){
		baseData = jcdpCallService("ScrapeSrvNew", "getScrapeAssetInfoNew", "scrape_apply_id="+$("#scrape_apply_id").val()+"&scrape_detailed_id="+$("#scrape_detailed_id").val());
		$("#scrape_apply_no").val(baseData.deviceAssetMap.scrape_apply_no);
		$("#scrape_asset_id").val(baseData.deviceAssetMap.scrape_asset_id);
		$("#scrape_apply_name").val(baseData.deviceAssetMap.scrape_apply_name);
		$("#apply_date").val(baseData.deviceAssetMap.apply_date);
		$("#asset_now_desc").val(baseData.deviceEmpMap.asset_now_desc);
		$("#scrape_reason").val(baseData.deviceEmpMap.scrape_reason);
		$("#expert_desc").val(baseData.deviceAssetMap.expert_desc);
		$("#expert_leader").val(baseData.deviceEmpMap.employee_name);
		$("#expert_leader_id").val(baseData.deviceEmpMap.employee_id);
		$("#expert_id").val(baseData.deviceEmpMap.id);
		/* 
		employee_id=8F1E43C3F389D074E0430A150812D074, employee_name=张涛
		expert_leader
		expert_leader_id 
		expert_id
		*/
		if(baseData.deviceAssetMap.appraisal_date!=""){
			$("#appraisal_date").val(baseData.deviceAssetMap.appraisal_date);
		}
		if(baseData.fdatafj!=null)
		{
			$("#processtablefj").empty();
			for (var tr_id = 1; tr_id<=baseData.fdatafj.length; tr_id++) {
				insertFilefj(baseData.fdatafj[tr_id-1].file_name,baseData.fdatafj[tr_id-1].file_type,baseData.fdatafj[tr_id-1].file_id,tr_id);
			}
		}
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
   		document.getElementById("expert_leader_id").value=teamInfo.fkValue;
   		document.getElementById("expert_leader").value=teamInfo.value;
    }
}
function addRowsdamage(){
	tr_id = $("#processtablefj>tr:last").attr("id");
	if(tr_id != undefined){
		tr_id = parseInt(tr_id.substr(2,1),10);
	}
	if(tr_id == undefined){
		tr_id = 1;
	}else{
		tr_id = tr_id+1;
	}
	$("#colnumdmage").val(tr_id);
	//动态新增表格
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml += "<td style='text-align:center;'><input type='hidden' name='idinfo' id='idinfo_"+tr_id+"'/></td>";
	innerhtml += "<td style='text-align:center;'><input type='file' name='doc_content__"+tr_id+"' id='doc_content__"+tr_id+"' onchange='getFileInfofj(this)' class='my_input_width'/></td>";
	innerhtml += "<td><span class='sc'><a href='javascript:void(0);' onclick='deleteInputfj(this)'  title='删除'></a></span></td>";
	innerhtml += "<input type='hidden' readonly='readonly' name='doc_name__"+tr_id+"' id='doc_name__"+tr_id+"' class='input_width' /><input type='hidden' id='doc_type__"+tr_id+"' name='doc_type__"+tr_id+"'>";
	innerhtml += "</tr>";
	$("#processtablefj").append(innerhtml);
	
	$("#processtablefj>tr:odd>td:odd").addClass("odd_odd");
	$("#processtablefj>tr:odd>td:even").addClass("odd_even");
	$("#processtablefj>tr:even>td:odd").addClass("even_odd");
	$("#processtablefj>tr:even>td:even").addClass("even_even");
};
function getFileInfofj(item){
	var docPath = $(item).val();
	var order = $(item).attr("id").split("__")[1];
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#doc_name__"+order).val(docTitle);//文件name
	
}
//删除行
function deleteInputfj(item){
	$(item).parent().parent().parent().remove();
}
//初始化插入文件
function insertFilefj(name,type,id,tr_id){
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml +="<td style='text-align:center;'><input type='hidden' name='idinfo' id='idinfo_"+tr_id+"' value='"+id+"'/></td>";
	innerhtml +="<td style='text-align:center;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"' class='my_input_width'>"+name+"</a></td>";
	innerhtml +="<td  style='text-align:center;'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilefj(this,\""+id+"\") title='删除'></a></span></td>";
	innerhtml +="<input type='hidden' readonly='readonly' name='doc_name__"+tr_id+"' id='doc_name__"+tr_id+"' value="+name+"/>";
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
function saveInfo(){
	tr_id = $("#processtablefj>tr:last").attr("seq");
	var dev_filename="";
	if(tr_id != undefined){
		dev_filename = document.getElementById("doc_name__"+tr_id).value;
	}
	if(dev_filename =""){
		alert("请上传附件！");
		return;
	}
	var idinfos="";
	for(var i=1;i<=tr_id;i++){
		if($("#idinfo_"+i).val()!=""){
			if(i==tr_id){
				idinfos +=$("#idinfo_"+i).val();
			}else{
				idinfos +=$("#idinfo_"+i).val()+",";
			}
		}
	}
	$("#idinfos").val(idinfos);//文件name
		Ext.MessageBox.wait('请等待','处理中');
		Ext.Ajax.request({
			url : "<%=contextPath%>/dmsManager/scrape/devLinkEmpAndFileNew.srq",
			method : 'Post',
			isUpload : true,  
			form : "form1",
			success : function(resp){
				var myData = eval("("+resp.responseText+")");
				var nodes = myData.nodes;
				alert(myData.returnMsg);
				Ext.MessageBox.hide();
				window.close();
				//刷新附件列表
				
			},
			failure : function(resp){// 失败
				var myData = eval("("+resp.responseText+")");
				alert(myData.returnMsg);
				window.close();
			}
		});
	}
function newClose(){
	  window.close();
}
</script>
</html>

