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
	String opi_id =request.getParameter("opi_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>选型评审</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail('<%=opi_id%>');">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
 
	<div id="new_table_box" style="width: 98%">
 	<div id="new_table_box_content" style="width: 98%">
 	<div id="new_table_box_bg" style="width: 95%">
 	<div id="list_table">
 	<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">产品基本信息</a></li>
			    <li id="tag3_0" ><a href="#" onclick="getContentTab(this,1)">评审</a></li>
			  </ul>
 	</div>
	
    <div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
		<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
			<tr style="text-align: left">
			  <td class="inquire_item6">&nbsp;产品名称型号：</td>
			  <td class="inquire_form6"><input name ="opi_name" id="opi_name" class="input_width" type="text" value="" disabled="disabled"/></td>
			  <td class="inquire_item6">&nbsp;商标：</td>
			  <td class="inquire_form6"><input name="brand" id="brand" class="input_width" type="text" value="" disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;生产单位：</td>
			  <td class="inquire_form6"><input name="production" id="production" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  <td class="inquire_item6">&nbsp;上年产量：</td>
			  <td class="inquire_form6"><input name="last_year_yield" id="last_year_yield" class="input_width" type="text" value=""  disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td style="height: 40px;" class="inquire_item6">&nbsp;产品简介：</td>
			  <td colspan="3" class="inquire_form6"><textarea id="product_info" name="product_info"  class="textarea" style="height:40px" disabled="disabled";></textarea></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;技术参数：</td>
			 <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_skill_tablePublic">
				<input name="skill_parameter_report" id="skill_parameter_report" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		 <tr>
			  <td class="inquire_item6">&nbsp;测试使用报告：</td>
			  <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_test_tablePublic">
				<input name="test_using_report" id="test_using_report" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;应用证明：</td>
			  <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="userProve_file_tablePublic">
				<input name="user_prove" id="user_prove" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
	   		  <td class="inquire_item6">&nbsp;生产单位资质：</td>
	   		   <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="production_file_tablePublic">
				<input name="production_unit_aptitude" id="production_unit_aptitude" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;其他附件：</td>
			   <td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="other_file_tablePublic">
				<input name="other" id="other" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;申请状态：</td>
			  <td colspan="4" class="inquire_form4">
      			<input type="radio" id="apply_state" name="apply_state" value="0" checked="checked"/><label >&nbsp;首次申请&nbsp;&nbsp;&nbsp;&nbsp;</label>
      			<input type="radio" id="apply_state" name="apply_state" value="1"/><label >&nbsp;至期复查&nbsp;&nbsp;&nbsp;&nbsp;</label>
      			<input type="radio" id="apply_state" name="apply_state" value="2"/><label >&nbsp;增项</label>
     			 </td>
		  </tr>
		   <tr>
			  <td class="inquire_item6">&nbsp;申请单位：</td>
			  <td colspan="3" class="inquire_form6"><input name="apply_unit" id="apply_unit" class="input_width" type="text" value=""  disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;申请单位理由：</td>
			  <td colspan="3" class="inquire_form6"><input name="apply_unit_reason" id="apply_unit_reason" class="input_width" type="text" value=""  disabled="disabled"/></td>
		  </tr>
		  <tr>
			  <td class="inquire_item6">&nbsp;领导姓名：</td>
			  <td class="inquire_form6"><input name="principal" id="principal" class="input_width" type="text" value=""  disabled="disabled"/></td>
			  <td class="inquire_item6">&nbsp;批准时间：</td>
			  <td class="inquire_form6"><input name="approve_date" id="approve_date" class="input_width" type="text" value="" disabled="disabled" /></td>
		  </tr>
		   <tr>
	   		<td class="inquire_item6">&nbsp;附件(评审证明)：</td>
	   		<td colspan="2">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="reviewConfirms_file_tablePublic">
				<input name="review_confirms" id="review_confirms" type="hidden"/>
			 </table>
		   </td>
		  </tr>
		</table>
	   </div>
    
    
     <div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
	    <h5 align="center" style="font-size: 15px">专家组意见</h5>
      <table style="width:98%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
       <input name="opi_id" id="opi_id" type="hidden" value="<%=opi_id%>" />
	 	<tr>
          <td width="11%;" align="right"><font color="red">*</font>&nbsp;意见：</td>
	      <td colspan="2" class="inquire_form4"><textarea id="panel_idea" name="panel_idea"  class="input_width easyui-textarea easyui-validatebox main" style="width:60%;height:40px" data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
        </tr>
        <tr>
			<td align="right"><font color="red">*</font>&nbsp;负责人：</td>
			<td class="inquire_form4">
				<input name="panel_principal" id="panel_principal" class="input_width easyui-validatebox" type="text" value="" style="width: 258px" title="负责人" data-options="validType:'length[0,50]'" maxlength="50" required/>
			</td>
		</tr>
		<tr>
          <td align="right"><font color="red">*</font>评审日期：</td>
          <td class="inquire_form4">
				<input type="text" name="panel_review_date" id="panel_review_date" title="评审日期"  value="<%=appDate %>" class="input_width easyui-datebox main" style="width:258px" required />
		  </td>
        </tr>
      </table>
      <h5 align="center" style="font-size: 15px">设备物资处意见</h5>
		<table style="width:98%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
	 	<tr>
          <td width="8%;" align="right"><font color="red">*</font>&nbsp;意见：</td>
	      <td colspan="2" class="inquire_form4"><textarea id="equipment_idea" name="equipment_idea"  class="input_width easyui-textarea easyui-validatebox main" style="width:60%;height:40px" data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
        </tr>
        <tr>
			<td align="right"><font color="red">*</font>&nbsp;负责人：</td>
			<td class="inquire_form4">
				<input name="equipment_principal" id="equipment_principal" class="input_width easyui-validatebox main" type="text" value="" style="width: 258px" title="负责人" data-options="validType:'length[0,50]'" maxlength="50" required/>
			</td>
		</tr>
		<tr>
          <td align="right" ><font color="red">*</font>&nbsp;评审日期：</td>
          <td class="inquire_form4">
				<input type="text" name="equipment_review_date" id="equipment_review_date" title="评审日期"  value="<%=appDate %>" class="input_width easyui-datebox" style="width:258px" required />
		  </td>
        </tr>
        <tr>
          <td align="right"><font color="red">*</font>&nbsp;评审结果：</td>
          <td><select  class="input_width easyui-combobox easyui-validatebox main" name="review_result" id="review_result" style="width: 60px" editable="false" required>
			 <option value ="0">通过</option>
			 <option value ="1">未通过</option>
			</select>
		</td>
        </tr>
        <tr>
	      <td align="right">&nbsp;附件(评审证明)：</td>					
	      	<auth:ListButton functionId="" css="dr" event="onclick='reviewConfirmsFileDataAdd(1)'" title="导入附件"></auth:ListButton>
	     </tr>	
	      <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="review_tablePublic">
				<input name="review_confirms" id="review_confirms" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		</table>
		<div id="oper_div">
	     	<span class="bc_btn"><a href="####" id="submitButton" onclick="saveInfo()"></a></span>
	        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
    	</div>
	   </div>
    </div>
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
	var review_confirms =0;
	
	$().ready(function(){
		//禁止日期框手动输入
		$("#panel_review_date").datebox({
			editable: false
        });
		$("#equipment_review_date").datebox({
			editable: false
        });
		$("#review_result").validatebox({
			editable: false
		});
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	});
	
	function checkLength(obj,maxlength){
    if(obj.value.length > maxlength){
        obj.value = obj.value.substring(0,maxlength);
    }
}
	var selectedTagIndex = 0;
	function getContentTab(obj,index) {
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		if(index == 1){
			var ids ='<%=opi_id%>';
			retObj = jcdpCallService("EquipmentSelectionApply", "getReviewInfo", "opi_id="+ids);
			$("#panel_idea").val(retObj.deviceappMap.panel_idea);
			$("#panel_principal").val(retObj.deviceappMap.panel_principal);
			if(retObj.deviceappMap.panel_review_date !=""){
				$("#panel_review_date").datebox("setValue", retObj.deviceappMap.panel_review_date);
			}
			$("#equipment_idea").val(retObj.deviceappMap.equipment_idea);
			$("#equipment_principal").val(retObj.deviceappMap.equipment_principal);
			if(retObj.deviceappMap.equipment_review_date !=""){
				$("#equipment_review_date").datebox("setValue", retObj.deviceappMap.equipment_review_date);
			}
			$("#review_result").val(retObj.deviceappMap.review_result);
			if(retObj.fdataPublic!=null){ 
				for (var tr_id = 1; tr_id<=retObj.fdataPublic.length; tr_id++) {
					if(retObj.fdataPublic[tr_id-1].file_type =="review_content"){
						insertFilePublicTest(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
						review_confirms=1;
					}
				}
			 }
		  }
		$(filternotobj).hide();
		$(filterobj).show();
		}
	
	
	// 评审信息多附件添加
	function reviewConfirmsFileDataAdd(status){
		insertTrPublic_test('review_tablePublic');
	}
	
	// 新增插入评审信息报告文件
	function insertTrPublic_test(obj){
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
	function insertFilePublicTest(name,id){
		$("#review_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除评审信息文件
	function deleteTeFilePublicOPI(item,id){
		var tmp= new Date().getTime();
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				review_confirms = 1;
		}	
	}
	
	function getTestFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#review_confirms_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteTestInputPublic(item){
		review_confirms = 0;
		$(item).parent().parent().parent().remove();
	 }	
	//提交保存
	function saveInfo(){debugger;
		var panel_idea = $.trim($("#panel_idea").val());
		if(panel_idea.length<=0){
			$.messager.alert("提示","专家组意见不能为空!");
			return;
		}	 
		var panel_principal = $.trim($("#panel_principal").val());
		if(panel_principal.length<=0){
		$.messager.alert("提示","专家组负责人不能为空!");
			return;
		}
		var panel_review_date = $.trim($("#panel_review_date").val());
		if(panel_review_date.length<=0){
		$.messager.alert("提示","专家组评审日期不能为空!");
			return;
		}
		var equipment_idea = $.trim($("#equipment_idea").val());
		if(equipment_idea.length<=0){
		$.messager.alert("提示","设备物资处意见不能为空!");
			return;
		}
		var equipment_principal = $.trim($("#equipment_principal").val());
		if(equipment_principal.length<=0){
		$.messager.alert("提示","设备物资处负责人不能为空!");
			return;
		}
		var equipment_review_date = $.trim($("#equipment_review_date").val());
		if(equipment_review_date.length<=0){
		$.messager.alert("提示","设备物资处评审日期不能为空!");
			return;
		}
		var review_result = $.trim($("#review_result").combobox('getValue'));
		if(review_result.length<=0){
		$.messager.alert("提示","设备物资处评审结果不能为空!");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/saveReview.srq";
    			document.getElementById("form1").submit();
            }
        });	
	}
	 
    /* 产品基本信息*/
	function loadDataDetail(opi_id){  
    	var retObj;
		if(opi_id != null){
		retObj = jcdpCallService("EquipmentSelectionApply", "getProductInfo", "opi_id="+opi_id);
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.opi_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.opi_id+"']").removeAttr("checked");
		//给数据回填
		$("#opi_name","#scrapeMap").val(retObj.deviceappMap.opi_name);
		$("#brand","#scrapeMap").val(retObj.deviceappMap.brand);
		$("#production","#scrapeMap").val(retObj.deviceappMap.production);
		$("#last_year_yield","#scrapeMap").val(retObj.deviceappMap.last_year_yield);
		$("#product_info","#scrapeMap").val(retObj.deviceappMap.product_info);
		if(retObj.deviceappMap.apply_state=="1") {
			document.all.apply_state[1].checked = true;   
		}
		if(retObj.deviceappMap.apply_state=="0") {
			document.all.apply_state[0].checked = true;   
		}
		if(retObj.deviceappMap.apply_state=="2") {
			document.all.apply_state[2].checked = true;   
		}
		$("#apply_unit","#scrapeMap").val(retObj.deviceappMap.apply_unit);
		$("#apply_unit_reason","#scrapeMap").val(retObj.deviceappMap.apply_unit_reason);
		$("#principal","#scrapeMap").val(retObj.deviceappMap.principal);
		$("#approve_date","#scrapeMap").val(retObj.deviceappMap.approve_date);
		if(retObj.fdataPublic!=null){
			// 有附件不显示设备详情而是显示附件
			for (var tr_id = 1; tr_id<=retObj.fdataPublic.length; tr_id++) {
				if(retObj.fdataPublic[tr_id-1].file_type =="skill_parameter"){
					insertFilePublicSkill(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="test_content"){
					insertFilePublicTest(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="user_prove_content"){
					insertFilePublicUser(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="production_file_content"){
					insertFilePublicProduction(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="other_file_content"){
					insertFilePublicOther(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
				if(retObj.fdataPublic[tr_id-1].file_type =="review_confirms_file_content"){
					insertFilePublicReview(retObj.fdataPublic[tr_id-1].file_name,retObj.fdataPublic[tr_id-1].file_id);
				}
			}
		  }
		}
    }
	 
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
					"<tr>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的测试使用报告文件文件
	function insertFilePublicTest(name,id){
		$("#file_test_tablePublic").append(
					"<tr>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicUser(name,id){
		$("#userProve_file_tablePublic").append(
					"<tr>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicProduction(name,id){
		$("#production_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicOther(name,id){
		$("#other_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicReview(name,id){
		$("#reviewConfirms_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	
</script>
</html>

