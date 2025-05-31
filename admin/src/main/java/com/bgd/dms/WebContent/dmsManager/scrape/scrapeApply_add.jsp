<%@ page contentType="text/html;charset=UTF-8"%>
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
  	String proStatus = request.getParameter("proStatus");//审批状态
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>报废申请表</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
      	<input name="scrape_asset_id" id="scrape_asset_id" type="hidden"/>
      	<input name="scrape_damage_id" id="scrape_damage_id" type="hidden"/>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="0" readonly/>
      	<input name="parmeter" id="parmeter" type="hidden" value="1"/>
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
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" title="<%=user.getOrgName()%>" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>设备报废导入</legend>
			<table>
				<tr>
					<td class="ali_cdn_name"><a
						href="javascript:downloadModel('scrape_model','资产设备报废导入模板')">下载模板</a></td>
					<auth:ListButton functionId="" css="dr"
						event="onclick='excelDataAdd(1)'" title="导入设备"></auth:ListButton>
				</tr>
			</table>
			<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tablePublic">
				<input name="flag_public" id="flag_public" type="hidden"/>
			</table>
	  </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="xyb_btn"><a id="submitButton" href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
var flag_public = 0;//固定资产附件标示
	function saveInfo(){
		$("#scrape_apply_no").val("");
		if($("#scrape_apply_name").val()=="")
			{
			alert("报废申请单名称不能为空!");
			return;
			}
		if($("#apply_date").val()=="")
		{
			alert("申请日期不能为空!");
			return;
		}
		if(($("#excel_content_public").val()==undefined||$("#excel_content_public").val()=='')&&flag_public==0&&'<%=scrape_apply_id%>'=='null'){
			alert('请选择设备明细信息！');
			return;
		}else{
			$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	            if (data) {
	            	$.messager.progress({title:'请稍后',msg:'处理中....'});
	    			$("#submitButton").attr({"disabled":"disabled"});
	    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeListNew.srq";
	    			document.getElementById("form1").submit();
	            }
	        });
		}
	}
	function refreshData(){
		var baseData;
		if('<%=scrape_apply_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
			$("#scrape_apply_no").val(baseData.deviceappMap.scrape_apply_no);
			$("#scrape_apply_name").val(baseData.deviceappMap.scrape_apply_name);
			$("#apply_date").val(baseData.deviceappMap.apply_date);
			if(baseData.listDamage!=null){
				$("#scrape_damage_id").val(baseData.listDamage[0].scrape_damage_id);
			}
			if(baseData.listAsset!=null){
				$("#scrape_asset_id").val(baseData.listAsset[0].scrape_asset_id);
			}
			$("#scrape_apply_name").val(baseData.deviceappMap.scrape_apply_name);
			$("#scrape_apply_name").val(baseData.deviceappMap.scrape_apply_name);
			if(baseData.fdataPublic!=null){
				//有附件不显示设备详情而是显示附件
				for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
					insertFilePublic(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_type,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
			var proStatus= '<%=proStatus%>'
			if(proStatus=='1'||proStatus=='3'){
				$("#scrape_apply_name").attr("readonly","readonly");
				$("#proStatus").val(proStatus);
			}
		}
	}
	/**设备报废处置明细模板方法**/
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/dmsManager/common/download.jsp?path=/dmsManager/scrape/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	/**导入设备报废处置明细方法**/
	function excelDataAdd(status){
		insertTrPublic('file_tablePublic');
	}
	//新增插入文件
	function insertTrPublic(obj){
		var tmp="public";
			$("#"+obj+"").append(
				"<tr id='file_tr_public'>"+
					"<td class='inquire_item5'>设备附件：</td>"+
		  			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublic(name,type,id){
		$("#file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublic(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除文件
	function deleteFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_tablePublic").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoPublic(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='excel_name_"+tmp+"' id='excel_name_"+tmp+"' class='input_width' /><input type='hidden' id='doc_type_"+tmp+"' name='doc_type_"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
		}
	}
	function getFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#excel_name_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteInputPublic(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
		
	}
</script>
</html>

