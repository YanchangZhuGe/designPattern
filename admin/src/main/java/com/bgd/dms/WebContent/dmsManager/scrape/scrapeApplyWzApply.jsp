<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String deviceappid = request.getParameter("deviceappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String addUpFlag = request.getParameter("addupflag");
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String scrape_apply_wz_id = request.getParameter("scrape_apply_wz_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
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
</style>
<title>物料报废申请</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data" >
	<div id="new_table_box">
  <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
	<div id="new_table_box_bg">
	<fieldSet style="margin:2px:padding:2px;"><legend>物料报废申请</legend>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	     <input name="scrape_apply_wz_id" id="scrape_apply_wz_id" type="hidden" value="<%=scrape_apply_wz_id%>" />
	     <input name="dev_coding" id="dev_coding" type="hidden" value="" />
	    <tr>
    		<td class="inquire_item4" width="10%"><font color="red">*</font>&nbsp;标题：</td>
    		<td class="inquire_form4" class="inquire_form4"><input name="scrape_apply_wz_title" id="scrape_apply_wz_title" class="input_width easyui-validatebox main" type="text" value="" style="width: 100%" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
    		<td class="inquire_item4" width="10%">&nbsp;原值：</td>
    		<td class="inquire_form4" ><input name="scrape_apply_wz_asset_value" id="scrape_apply_wz_asset_value" class="input_width easyui-validatebox main"  type="text" value="" style="width: 100%" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	    </tr>
	    
	      
	    
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;报废说明：</td>
      		<td  colspan="2" class="inquire_form4"><textarea id="scrape_apply_wz_content" name="scrape_apply_wz_content"  class="input_width easyui-textarea easyui-validatebox main" style="width:100%;height:40px;" overflow-x:hidded; data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
	     </tr>
	      
		 
		 <tr>
			<td class="inquire_item4" >&nbsp;附件：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;">多附件</font><auth:ListButton functionId="" css="dr" event="onclick='testUsingFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_test_tablePublic">
				<input name="test_using_report" id="test_using_report" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		   
		  
		   
		  
		  <tr>
			<td class="inquire_item4" >&nbsp;明细附件：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;"></font><auth:ListButton functionId="" css="dr" event="onclick='otherFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="other_file_tablePublic">
				<input name="other" id="other" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		  
	    </table>
		</fieldSet>
		 
	 
		</div>
		
		   <div id="oper_div" style="padding-top:6px;">
		 <a href="####" id="submitButton" class="easyui-linkbutton" onclick="saveInfo()"><i class="fa fa-floppy-o fa-lg"></i> 保 存 </a>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		 <a href="####" class="easyui-linkbutton" onclick='newClose()'><i class="fa fa-times fa-lg"></i> 关 闭 </a>
		</div>
		</div>
	</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var idinfo = '<%=deviceappid%>';
	var addupflag = '<%=addUpFlag%>';
	var addedseqinfo;
	var flag_public = 0;	
	$().ready(function(){
		//禁止日期框手动输入
		$("#approve_date").datebox({
			editable: false
        });
	});
	
	function checkLength(obj,maxlength){
    if(obj.value.length > maxlength){
        obj.value = obj.value.substring(0,maxlength);
    }
}
	 
	/**
	 * 申请单位 
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("apply_unit").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("apply_unit_code").value = orgId[1];

		var orgSubId = strs[2].split(":");
		document.getElementById("").value = orgSubId[1];
	}
	
	function refreshData(){ 
		var baseData; 
		if('<%=scrape_apply_wz_id%>'!='null'){ 
			baseData = jcdpCallService("ScrapeSrvNew", "getScrapeApplyWzInfo", "scrape_apply_wz_id="+$("#scrape_apply_wz_id").val());
			
			//var basedata = jcdpCallService("EquipmentSelectionApply", "getDevInfoWithModelChange", "change_id="+$("#scrape_apply_wz_id").val());
			//basedatas = basedata.deviceappMap;
			
			$("#scrape_apply_wz_title").val(baseData.deviceappMap.scrape_apply_title);
			$("#scrape_apply_wz_asset_value").val(baseData.deviceappMap.asset_value);
			$("#scrape_apply_wz_content").val(baseData.deviceappMap.scrape_apply_content);
		 
		 
			 
			if(baseData.fdataPublic!=null){ 
				retObj=baseData;
				// 有附件不显示设备详情而是显示附件
				for (var tr_id = 1; tr_id<=retObj.fdataPublic.length; tr_id++) {
					 if(retObj.fdataPublic[tr_id-1].file_type =="5110000215000000004"){
					
					insertFilePublicOther(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="5110000215000000001"){
					
					insertFilePublicTest(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="5110000215000000002"){
					
					insertFilePublicUser(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="5110000215000000003"){
					
					insertFilePublicProduction(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				}
			}
		}
	}
	//保存
	function saveInfo(){
		var dev_coding='';
		$("input[name^='dev_coding']").each(function(){
    	dev_coding=dev_coding+$(this).val()+",";
  		}); 
  		$("#dev_coding").val(dev_coding); 
		 
		  
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeApplyWz.srq";
    			document.getElementById("form1").submit();
            }
        });	
	}
	// skill_parameter__
	//显示已插入的技术参数文件
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	// 改造申请附件多附件添加
	function testUsingFileDataAdd(status){  
		insertTrPublic_test('file_test_tablePublic');
	}
	
	// 新增改造申请附件多附件添加
	function insertTrPublic_test(obj){  
		//var tmp="public";
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_test_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='5110000215000000001__"+tmp+"' id='5110000215000000001__"+tmp+"' onchange='getTestFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteTestInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"
			);
		}
	//显示已插入的测试使用报告文件文件
	function insertFilePublicTest(name,id){
		$("#file_test_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除附件
	function deleteTeFilePublicOPI(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
		}	
	}
	
	function getTestFileInfoPublic(item){ 
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#test_using_report_"+order).val(docTitle);//文件name
		jcdpCallService("EquipmentSelectionApply", "uploadFile", "change_id="+'<%=scrape_apply_wz_id%>');
	}
	//删除行
	function deleteTestInputPublic(item){
		test_using_report = 0;
		$(item).parent().parent().parent().remove();
	 }	
	
	
	
	
	// 评审多附件添加
	function userProveFileDataAdd(status){
		insertTrPublic_userProve('userProve_file_tablePublic');
	}
	// 新增插入评审文件
	function insertTrPublic_userProve(obj){
		//var tmp="public";
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_userProve_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='5110000215000000002__"+tmp+"' id='5110000215000000002__"+tmp+"' onchange='getUserProveFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteUserProveInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublicUser(name,id){
		$("#userProve_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deletePuFilePublic(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除应用证明文件
	function deletePuFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
		}	
	}
	function getUserProveFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#user_prove_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteUserProveInputPublic(item){
		user_prove = 0;
		$(item).parent().parent().parent().remove();
	 }
	
	
	
	// 生产单位资质多附件添加
	function productionFileDataAdd(status){
		insertTrPublic_production('production_file_tablePublic');
	}
	// 新增插入应用证明报告文件
	function insertTrPublic_production(obj){
		//var tmp="public";
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_production_file_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='5110000215000000003__"+tmp+"' id='5110000215000000003__"+tmp+"' onchange='getProductionFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteProductionFilePublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublicProduction(name,id){
		$("#production_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
	      			"<td class='inquire_form5'><span class='sc' style='width :30%'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除应用证明文件
	function deleteProdFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
		}	
	}
	function getProductionFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#user_prove_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteProductionFilePublic(item){
		production_unit_aptitude = 0;
		$(item).parent().parent().parent().remove();
	 }
	
	
	
	
	
	
	// 其他附件添加
	function otherFileDataAdd(status){
		insertTrPublic_other('other_file_tablePublic');
	}
	// 新增插入应用证明报告文件
	function insertTrPublic_other(obj){
		var tmp=new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_other_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='5110000215000000004__"+tmp+"' id='5110000215000000004__"+tmp+"' onchange='getOtherFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteOtherFilePublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublicOther(name,id){
		$("#other_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
	      			"<td class='inquire_form5'><span class='sc' style='width :30%'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除其他文件
	function deleteOtherPublic(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				other = 1;
		}	
	}
	function getOtherFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#other_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteOtherFilePublic(item){
		other = 0;
		$(item).parent().parent().parent().remove();
	 }
	
	
	// 附件(评审证明)
	function reviewConfirmsFileDataAdd(status){  
		insertTrPublic_reviewConfirms('reviewConfirms_file_tablePublic');
	}
	// 评审信息多附件添加
	function reviewConfirmsFileData(status){
		insertTrPublic_New('review_tablePublic');
	}
	 
	// 新增插入评审信息报告文件
	function insertTrPublic_New(obj){
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='review_test_public'>"+
				"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='review_content__"+tmp+"' id='review_content__"+tmp+"' onchange='getTestFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteTestInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"
			);
		}
	//显示已插入的评审信息文件文件
	function insertFilePublicNew(name,id){
		$("#review_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}	
	// 新增插入 附件(评审证明)文件
	function insertTrPublic_reviewConfirms(obj){
		var tmp=new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='reviewConfirms_file_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='review_confirms_file_content__"+tmp+"' id='review_confirms_file_content__"+tmp+"' onchange='getreviewConfirmsFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteConfirmsFilePublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
		
	
	//显示已插入的文件
	function insertFilePublicReview(name,id){
		$("#reviewConfirms_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
	      			"<td class='inquire_form5'><span class='sc' style='width :30%'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除 附件(评审证明)文件
	function deleteReviewConfirmsFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				review_confirms = 1;
		}	
	}
	function getreviewConfirmsFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#Confirms_file_content_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteConfirmsFilePublic(item){
		review_confirms = 0;
		$(item).parent().parent().parent().remove();
	 }
	//转入/转出项目
	function showProjectPage(){
		var returnValue = window.showModalDialog('<%=contextPath%>/rm/dm/devmove/selectWellsProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view',"test",'dialogWidth=800px;dialogHeight=450px');
		if(returnValue==null){
			return;
		}
		var strs = new Array(); //定义一数组
			strs = returnValue.split("@"); //字符分割
		var name = strs[0];
		var id = strs[1];
			$("#project_name").val(name);
			$("#ProjectInfoNo").val(id);
	}
	//指标项序号
	var order = new Date().getTime();
	var orderss = 0;
	var orders = 0;
	function insertTr2(old){
		orders++;
		var temps = "";
		if(old=="old"){
			temps +="<tr id='tr_"+orders+"' class='old' tempindex='"+orders+"'>";
		}else{
			temps +="<tr id='tr_"+orders+"' class='new' tempindex='"+orders+"'>";
		}																	   
		temps =temps + ("<td><input name='enterprise_equipment_id_"+order+"' id='enterprise_equipment_id_"+order+"'  value='000' type='hidden'/><input name='item_order_"+order+"' id='item_order_"+order+"' value='222' type='hidden'/>"+
		"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr2(this)'/></td>" +
		"<td>"+orders+"</td> "+
		"<td><input name='dev_coding"+orders+"' id='device_coding_"+orders+"' type='text' value='' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' onkeyup='getDevInfoByERP(this.value,orders)' required/></td>"+
		"<td><input id='dev_name_"+orders+"' type='text' value='' style='height:20px;width:80%;'   readonly  />"+
  		"<td><input id='dev_model_"+orders+"' type='text' value='' style='height:20px;width:90%;'  readonly  /></td>"+
  		"<td><input id='ASSET_VALUE_"+orders+"' type='text' value='' style='height:20px;width:90%;' readonly  /></td>"+
  		"<td><input id='NET_VALUE_"+orders+"' type='text' value='' style='height:20px;width:90%;' readonly  /></td>"+
		"</tr>");
		$("#itemTable2").append(temps);
		return order++; 
	}
	function insertTr3(obj){
		
		orders++;
	 
		var temps = "";
		 
		temps +="<tr id='tr_"+orders+"' class='new' tempindex='"+orders+"'>";
		 																	   
		temps =temps + ("<td><input name='enterprise_equipment_id_"+order+"' id='enterprise_equipment_id_"+order+"'  value='000' type='hidden'/><input name='item_order_"+order+"' id='item_order_"+order+"' value='222' type='hidden'/>"+
		"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr2(this)'/></td>" +
		"<td>"+orders+"</td> "+
		"<td><input name='dev_coding"+orders+"' id='device_coding_"+orders+"' type='text' value='"+obj.dev_coding+"' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" maxlength='50' onkeyup=\"getDevInfoByERP(this.value,'"+orders+"')\" required/></td>"+
		"<td><input id='dev_name_"+orders+"' type='text' value='"+obj.dev_name+"' style='height:20px;width:80%;'   readonly  />"+
  		"<td><input id='dev_model_"+orders+"' type='text' value='"+obj.dev_model+"' style='height:20px;width:90%;'  readonly  /></td>"+
  		"<td><input id='ASSET_VALUE_"+orders+"' type='text' value='"+obj.asset_value+"' style='height:20px;width:90%;' readonly  /></td>"+
  		"<td><input id='NET_VALUE_"+orders+"' type='text' value='"+obj.net_value+"' style='height:20px;width:90%;' readonly  /></td>"+
		"</tr>");
		$("#itemTable2").append(temps);
		return order++; 
	}
	//删除指标项行
	function deleteTr2(item2){
		//页面修改时要处理的操作
		if($(item2).parent().parent().attr("class")=="old"){
			var itemId = $(item2).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr2_"+tts+"' value='"+itemId+"'/>");
		}
		 if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentSelectionApply", "deleteUpdateEquipment", "enterprise_equipment_id="+itemId);				
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						 
					 
						 
						 
						//获取行id
						var temps = $(item2).parent().parent().attr("id");
						//删除行
						$(item2).parent().parent().remove();
						//序号重新排序
						var _index = parseInt(temps.split("_")[1]);
						for(var j=_index;j<orders;j++){
							//给隐藏域序号赋值
							$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
							//给序号赋值
							var order_td = $("#tr_"+(j+1)).children().eq(1);
							order_td.html(j);
							//给tr 属性 赋值
							$("#tr_"+(j+1)).attr("id","tr_"+j);
						}
						//索引减一
						orders=orders-1;
						queryData(cruConfig.currentPage);
					}
				}
			}
		}
		
	}
	//根据erp设备编码查询设备基本信息
	function getDevInfoByERP(erp,index){
	 
	if(erp.length==13){
	var retObj = jcdpCallService("EquipmentSelectionApply", "getDevInfoByERP", "dev_coding="+erp);
	if(typeof retObj.deviceappMap!="undefined"){
		$("#dev_name_"+index).val(retObj.deviceappMap.dev_name);
		$("#dev_model_"+index).val(retObj.deviceappMap.dev_model);
		$("#ASSET_VALUE_"+index).val(retObj.deviceappMap.asset_value);
		$("#NET_VALUE_"+index).val(retObj.deviceappMap.net_value);
	}				
	}
	}
</script>
</html>

