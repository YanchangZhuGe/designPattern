<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String ck_id=request.getParameter("ck_id");
	if(null==ck_id){
		ck_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>设备验收</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:98%">
    <div id="new_table_box_bg" style="width:95%">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <input type="hidden" id="ck_id" name="ck_id" value="" class="main"/>
          <input type="hidden" id="ck_cid" name="ck_cid" value="" class="main"/>
          <input type="hidden" id="pact_num" name="pact_num" value="" class="main"/>
          <td class="inquire_item4" >&nbsp;验收时间:</td>
		  <td class="inquire_form4">
			<input type="text" name="ck_date" id="ck_date" value="<%=appDate %>" class="input_width easyui-datebox main" style="width:200px" editable="false" required/>
		  </td>
          <td class="inquire_item4" >&nbsp;实际到货时间:</td>
		  <td class="inquire_form4">
			<input type="text" name="sar_date" id="sar_date" value="<%=appDate %>" class="input_width easyui-datebox main" style="width:200px" editable="false" required/>
		  </td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
		  <td class="inquire_item6" rowspan="4">&nbsp;开箱前检查:</td>
		  <td class="inquire_item6">&nbsp;件数是否相符:</td>
		  <td class="inquire_form6">
         	<input type="radio" name="num_right" value="是" id="num_right" checked="checked">是
         	<input type="radio" name="num_right" value="否" id="num_right">否
		  </td>
		  <td class="inquire_item6" rowspan="4">&nbsp;开箱检查:</td>
		  <td class="inquire_item6"> &nbsp;实物与装箱单是否相符:</td>
		  <td class="inquire_form6">
			<label>
         		<input type="radio" name="thing_right" value="0" id="thing_right" checked="checked">是
       		</label>
       		<label>
         		<input type="radio" name="thing_right" value="1" id="thing_right">否
       		</label>
		  </td>
	     </tr>
	     <tr>
		  <td class="inquire_item6">&nbsp;名称是否相符:</td>
		  <td class="inquire_form6">
			<label>
         		<input type="radio" name="name_right" value="0" id="name_right" checked="checked">是
       		</label>
       		<label>
         		<input type="radio" name="name_right" value="1" id="name_right">否
       		</label>
		  </td>
		  <td class="inquire_item6"> &nbsp;开箱后名称是否相符:</td>
		  <td class="inquire_form6">
			<label>
         		<input type="radio" name="kname_right" value="0" id="kname_right" checked="checked">是
       		</label>
       		<label>
         		<input type="radio" name="kname_right" value="1" id="kname_right">否
       		</label>
		  </td>
         </tr>
	     <tr>
		  <td class="inquire_item6"> &nbsp;外包装是否相符:</td>
		  <td class="inquire_form6">
			<label>
          		<input type="radio" name="pg_right" value="0" id="pg_right" checked="checked">是
        	</label>
        	<label>
          		<input type="radio" name="pg_right" value="1" id="pg_right">否
        	</label>
		  </td>
		  <td class="inquire_item6"> &nbsp;是否受损:</td>
		  <td class="inquire_form6">
			<label>
          		<input type="radio" name="injure_right" value="0" id="injure_right">是
        	</label>
        	<label>
          		<input type="radio" name="injure_right" value="1" id="injure_right" checked="checked">否
        	</label>
		  </td>
         </tr>
		 <tr>
		  <td class="inquire_item6"> &nbsp;外观是否缺损腐蚀:</td>
		  <td class="inquire_form6">
			<label>
          		<input type="radio" name="pg_corrode" value="0" id="pg_corrode">是
        	</label>
        	<label>
          		<input type="radio" name="pg_corrode" value="1" id="pg_corrode" checked="checked">否
        	</label>
		  </td>
		  <td class="inquire_item6"></td>
		  <td class="inquire_form6"></td>
		 </tr>
	   </table>
	   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	     <tr>
		  <td class="inquire_item4" >&nbsp;性能指标测试:</td>
		  <td class="inquire_item4" > &nbsp;设备性能指标是否合格:</td>
		  <td class="inquire_form4" >
			<label>
          		<input type="radio" name="function_right" value="0" id="function_right" checked="checked">是
        	</label>
        	<label>
          		<input type="radio" name="function_right" value="1" id="function_right">否
        	</label>
		  </td>
	     </tr>
	     <tr>
      	  <td colspan="4">&nbsp;验证:</td>
	     </tr>
	     <tr>
		  <td class="inquire_item4">&nbsp;证件是否合格:</td>
		  <td class="inquire_form4">
          	<input type="radio" name="card_right" value="0" id="card_right" checked="checked">是
          	<input type="radio" name="card_right" value="1" id="card_right">否
		  </td>
		  <td class="inquire_item4">&nbsp;资料是否齐全:</td>
		  <td class="inquire_form4">
          	<input type="radio" name="data_right" value="0" id="data_right" checked="checked">是
          	<input type="radio" name="data_right" value="1" id="data_right">否
		  </td>
		</tr>
	  </table>
	  <table width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
		<tr>
		  <td class="inquire_item4">&nbsp;设备交付验收单:</td>
			<auth:ListButton functionId="" css="dr" event="onclick='excelDataAddSkill(1)'"></auth:ListButton>
		</tr>
		<tr>
	   	  <td colspan="3">
		 	<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="ck_list">
				<input name="ck_list_" id="ck_list_" type="hidden" />
		 	</table>
	   	  </td>
	 	</tr>
		<tr>
		  <td class="inquire_item4">&nbsp;新购设备验收报告:</td>
		  <auth:ListButton functionId="" css="dr" event="onclick='excelDataAddTest(1)'"></auth:ListButton>
		</tr>
		<tr>
	   	  <td colspan="3">
		 	<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="nck_list">
				<input name="nck_list_" id="nck_list_" type="hidden" />
		 	</table>
	   	  </td>
	 	</tr>
		<tr>
		  <td class="inquire_item4">&nbsp;设备验收信息表:</td>
		  <auth:ListButton functionId="" css="dr" event="onclick='excelDataAddUser(1)'"></auth:ListButton>
		</tr>
		<tr>
	   	  <td colspan="3">
		 	<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="ck_posts">
				<input name="ck_posts_" id="ck_posts_" type="hidden" />
		 	</table>
	   	  </td>
		</tr>
		<tr>
		  <td class="inquire_item4">&nbsp;存档资料:</td>
		  <auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd(1)'"></auth:ListButton>
		</tr>
		<tr>
	   	  <td colspan="3">
		 	<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="ck_post_many">
				<input name="ck_post_many_" id="ck_post_many_" type="hidden" />
		 	</table>
	   	  </td>
	    </tr>
	  </table>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		<tr>
		  <td class="inquire_item4">&nbsp;验收单位:</td>
          <td class="inquire_form4">
          	<input name="ck_sectors" id="ck_sectors" class="input_width main" type="text" value="" size="50" readonly/>
          	<input name="ck_sector" id="ck_sector" value="" type="hidden" class="main"/>
          		<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pimter;" onclick="showOrgTreePage()" />
          </td>
          <td class="inquire_item4">&nbsp;验收单位负责人:</td>
		  <td class="inquire_form4"><input name="ck_pyperson" id="ck_pyperson" maxlength="50" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" required/></td>
        </tr> 
        <tr>
          <td class="inquire_item4">&nbsp;验收结论:</td>
          <td class="inquire_form6"><input name="ck_conclusion" id="ck_conclusion" maxlength="50" class="input_width easyui-validatebox main" type="textarea" data-options="validType:'length[0,50]'" value="" required/></td>
        </tr>
        <tr>
          <td class="inquire_item4">&nbsp;验收结果:</td>
          <td class="inquire_form6">
			<select id="ck_outcome" name="ck_outcome" class="main">
				<option value="合格">合格</option>
				<option value="不合格">不合格</option>
			</select>
          </td>
        </tr>
	  </table>
	  <fieldset style="margin:2px;padding:2px;"><legend>问题信息</legend>
      <table  style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
		 <tr>
			<td width="10%" class="ali_btn" style="position: center;">
				<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
			</td>
			<td width="10%">序号</td>
			<td width="50%">问题描述</td>
			<td width="30%">预计解决时间</td>
		 </tr>
	  </table>
      </fieldset>
      <div id="oper_div">
     	<span class="tj_btn"><a href="####" id="submitButton" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
      </div>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var tmp="public";
	var ck_id="<%=ck_id%>";
	//增加修改标志
	var flag="<%=flag%>";
	$(function(){
		loadDate();
	});
	//加载数据
	function loadDate(){
		var retObj ;
		var baseDate;
		baseData = jcdpCallService("CheckDevDo", "getCheckDofInfo", "ck_id=<%=ck_id%>");
		if(typeof baseData.fdataPublic!="undefined"){ 
			// 有附件显示附件
			for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
				if(baseData.fdataPublic[tr_id-1].file_type =="ck_list"){
					insertFilePublicSkill(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
				if(baseData.fdataPublic[tr_id-1].file_type =="nck_list"){
					insertFilePublicTest(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
				if(baseData.fdataPublic[tr_id-1].file_type =="ck_posts"){
					insertFilePublicUser(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
				if(baseData.fdataPublic[tr_id-1].file_type =="ck_post_many"){
					insertFilePublic(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
		}
		if("update"==flag){
			//隐藏选择日期按钮
			$("#cal_button").hide();
			retObj = jcdpCallService("CheckDevDo", "getCheckDofInfo","ck_id=<%=ck_id%>");
			if(typeof retObj.data!="undefined"){
				var _ddata = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(_ddata[temp] != undefined ? _ddata[temp]:"");
				});
			}
			$("#ck_date").datebox("setValue", retObj.data.ck_date);
			$("#sar_date").datebox("setValue", retObj.data.sar_date);
			//
			if(retObj.data.num_right=="0") {
				document.all.num_right[0].checked = true;   
			}
			if(retObj.data.num_right=="1") {
				document.all.num_right[1].checked = true;   
			}
			//
			if(retObj.data.pg_right=="0") {
				document.all.pg_right[0].checked = true;   
			}
			if(retObj.data.pg_right=="1") {
				document.all.pg_right[1].checked = true;   
			}
			//
			if(retObj.data.pg_corrode=="0") {
				document.all.pg_corrode[0].checked = true;   
			}
			if(retObj.data.pg_corrode=="1") {
				document.all.pg_corrode[1].checked = true;   
			}
			//
			if(retObj.data.name_right=="0") {
				document.all.name_right[0].checked = true;   
			}
			if(retObj.data.name_right=="1") {
				document.all.name_right[1].checked = true;   
			}
			//
			if(retObj.data.thing_right=="0") {
				document.all.thing_right[0].checked = true;   
			}
			if(retObj.data.thing_right=="1") {
				document.all.thing_right[1].checked = true;   
			}
			//
			if(retObj.data.kname_right=="0") {
				document.all.kname_right[0].checked = true;   
			}
			if(retObj.data.kname_right=="1") {
				document.all.kname_right[1].checked = true;   
			}
			//
			if(retObj.data.injure_right=="0") {
				document.all.injure_right[0].checked = true;   
			}
			if(retObj.data.injure_right=="1") {
				document.all.injure_right[1].checked = true;   
			}
			//
			if(retObj.data.function_right=="0") {
				document.all.function_right[0].checked = true;   
			}
			if(retObj.data.function_right=="1") {
				document.all.function_right[1].checked = true;   
			}
			//
			if(retObj.data.card_right=="0") {
				document.all.card_right[0].checked = true;   
			}
			if(retObj.data.card_right=="1") {
				document.all.card_right[1].checked = true;   
			}
			//
			if(retObj.data.data_right=="0") {
				document.all.data_right[0].checked = true;   
			}
			if(retObj.data.data_right=="1") {
				document.all.data_right[1].checked = true;   
			}
		}
		if(typeof retObj.datas!="undefined"){
			var o = 1;
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				var ts=insertTr("old");
				var data=datas[i];
				$.each(data, function(k, v){
					if(null!=v && ""!=v){
						$("#itemTable #"+k+"_"+ts).val(v);
					}
					$("#y_date_"+o).datebox("setValue", data.y_date);
					$("#question_id_"+o).val(data.question_id);
				});
				o++;
			}
		}
	}
	
	//新增附件栏
	function excelDataAddSkill(status){
		insertTrPublicSkill('ck_list');
	}
	//新增插入文件
	var orders = 0;
	function insertTrPublicSkill(obj){
		var tmp="public";
		$("#"+obj+"").append(
			"<tr id='ck_list'>"+
				"<td class='inquire_item5' style='text-align:right'>附件：</td>"+
		  		"<td class='inquire_form5'><input type='file' name='ck_list__"+tmp+orders+"' id=ck_list__"+tmp+orders+"' onchange='getFileInfoPublicSkill(this)'  style='text-align:left' class='input_width'/></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublicSkill(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);
		orders++;
	}
	//显示已插入的文件
	function insertFilePublicSkill(name,id){
		$("#ck_list").append(
			"<tr>"+
				"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublicSkill(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	//删除文件
	function deleteFilePublicSkill(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
			}
        });
	}
	
	function getFileInfoPublicsSkill(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#ck_list_"+order).val(docTitle);//文件name
	}
	
	//删除行
	function deleteInputPublicSkill(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}
		
	//第二个
	function excelDataAddTest(status){
		insertTrPublicTest('nck_list');
	}
	//新增插入文件
	var orders = 0;
	function insertTrPublicTest(obj){
		var tmp="public";
		$("#"+obj+"").append(
			"<tr id='nck_list'>"+
				"<td class='inquire_item5' style='text-align:right'>附件：</td>"+
	  			"<td class='inquire_form5'><input type='file' name='nck_list__"+tmp+orders+"' id='nck_list__"+tmp+orders+"' onchange='getFileInfoPublicTest(this)' style='text-align:left' class='input_width'/></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublicTest(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);
		orders++;
	}
	//显示已插入的文件
	function insertFilePublicTest(name,id){
		$("#nck_list").append(
			"<tr>"+
				"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublicTest(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	//删除文件
	function deleteFilePublicTest(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
			}
        });
	}
	
	function getFileInfoPublicsTest(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#nck_list_"+order).val(docTitle);//文件name
	}
	
	//删除行
	function deleteInputPublicTest(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}
	
	//第三个
			
	function excelDataAddUser(status){
		insertTrPublicUser('ck_posts');
	}
	//新增插入文件
	var orders = 0;
	function insertTrPublicUser(obj){
		var tmp="public";
			$("#"+obj+"").append(
				"<tr id='ck_posts'>"+
					"<td class='inquire_item5' style='text-align:right'>附件：</td>"+
		  			"<td class='inquire_form5'><input type='file' name='ck_posts__"+tmp+orders+"' id='ck_posts__"+tmp+orders+"' onchange='getFileInfoPublicUser(this)' style='text-align:left' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublicUser(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
			orders++;
		}
	//显示已插入的文件
	function insertFilePublicUser(name,id){
		$("#ck_posts").append(
					"<tr>"+
					"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublicUser(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除文件
	function deleteFilePublicUser(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
			}
        });
	}
	
	function getFileInfoPublicsUser(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#ck_posts_"+order).val(docTitle);//文件name
	}
	
	//删除行
	function deleteInputPublicUser(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}
	
	//第四个
	function excelDataAdd(status){
		insertTrPublic('ck_post_many');
	}
	//新增插入文件
	var orders = 0;
	function insertTrPublic(obj){
		var tmp="public";
		$("#"+obj+"").append(
			"<tr id='ck_post_many'>"+
				"<td class='inquire_item5' style='text-align:right'>附件：</td>"+
	  			"<td class='inquire_form5'><input type='file' name='ck_post_many__"+tmp+orders+"' id='ck_post_many__"+tmp+orders+"' onchange='getFileInfoPublic(this)' style='text-align:left' class='input_width'/></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);
		orders++;
	}
	//显示已插入的文件
	function insertFilePublic(name,id){
		$("#ck_post_many").append(
			"<tr>"+
				"<td class='inquire_form5' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form5' colspan='3' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='inquire_form5' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublic(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	//删除文件
	function deleteFilePublic(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
			}
        });
	}
	
	function getFileInfoPublics(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#ck_post_many_"+order).val(docTitle);//文件name
	}
	
	//删除行
	function deleteInputPublic(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
	}

	//选择调配单位机构树
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR2.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var id = strs[1].split(":");
		var outorgname = $("#ck_sector").val();
		document.getElementById("ck_sectors").value = names[1];
		document.getElementById("ck_sector").value = id[1];
	}
	//提交保存
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var ck_id = $.trim($("#ck_id").val());
		var num_right = $.trim($("#num_right").val());
		var pg_right = $.trim($("#pg_right").val());
		var ck_date = $("#ck_date").datebox('getValue');
		var sar_date = $("#sar_date").datebox('getValue');
		var pg_corrode = $.trim($("#pg_corrode").val());
		var name_right = $.trim($("#name_right").val());
		var thing_right = $.trim($("#thing_right").val());
		var kname_right = $.trim($("#kname_right").val());
		var injure_right = $.trim($("#injure_right").val());
		var function_right = $.trim($("#function_right").val());
		var card_right = $.trim($("#card_right").val());
		var data_right = $.trim($("#data_right").val());
		var ck_conclusion = $.trim($("#ck_conclusion").val());
		var ck_outcome = document.getElementsByName("ck_outcome")[0].value;
		var ck_sectors = $.trim($("#ck_sectors").val());
		var ck_pyperson = $.trim($("#ck_pyperson").val());
		var myDate = getNowFormatDate();
		if(num_right.length<=0){
			$.messager.alert("提示","请确认件数是否相符!","warning");
			return;
		}
		if(pg_right.length<=0){
			$.messager.alert("提示","请确认外包装是否相符!","warning");
			return;
		}
		if(pg_corrode.length<=0){
			$.messager.alert("提示","请确认外包装是否损坏","warning");
			return;
		}
		if(name_right.length<=0){
			$.messager.alert("提示","请确认名称是否相符!","warning");
			return;
		}
		if(thing_right.length<=0){
			$.messager.alert("提示","请确认实物与装箱单是否相符!","warning");
			return;
		}
		if(kname_right.length<=0){
			$.messager.alert("提示","请确认开箱后名称是否相符!","warning");
			return;
		}
		if(injure_right.length<=0){
			$.messager.alert("提示","请确认是否损坏!","warning");
			return;
		}
		if(function_right.length<=0){
			$.messager.alert("提示","请确认设备性能指标是否相符!","warning");
			return;
		}
		if(card_right.length<=0){
			$.messager.alert("提示","请确认证件是否合格!","warning");
			return;
		}
		if(data_right.length<=0){
			$.messager.alert("提示","请确认资料是否齐全!","warning");
			return;
		}
		if(ck_sectors.length<=0){
			$.messager.alert("提示","请填写验收单位!","warning");
			return;
		}
		if(ck_pyperson.length<=0){
			$.messager.alert("提示","请填写验收单位负责人!","warning");
			return;
		}
		if(ck_conclusion.length<=0){
			$.messager.alert("提示","请填写验收结论!","warning");
			return;
		}
		if(ck_outcome.length<=0){
			$.messager.alert("提示","请填写验收结果!","warning");
			return;
		}
		
		if(CompareDate(myDate,ck_date)==false){
		    
			$.messager.alert("提示","验收时间不能大于当前时间!","warning");
			return;
		}
		
		if(CompareDate(myDate,sar_date)==false){
			$.messager.alert("提示","实际到货时间不能大于当前时间!","warning");
			return;
		}
		if(CompareDate(sar_date,ck_date)==true && ck_date!=sar_date){
			$.messager.alert("提示","实际到货时间不能大于验收时间!","warning");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/check/saveOrUpdateCheckDoInfo.srq?flag="+flag;
    			document.getElementById("form1").submit();
            }
        });
	}
	
	//得到当前时间
	function getNowFormatDate() {
	    var date = new Date();
	    var seperator1 = "-";
	    var year = date.getFullYear();
	    var month = date.getMonth()+1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = year + seperator1 + month + seperator1 + strDate
	    return currentdate;
	}
	
	//对比时间
	function CompareDate(d1,d2){
			
		  return ((new Date(d1.replace(/-/g,"/"))) >= (new Date(d2.replace(/-/g,"/"))));
	}

	//日期判断
	function disInput(index){
		//重新渲染加入的日期框
		$.parser.parse($("#tr"+index));
		//第一次进入移除验证
		$('.validatebox-text').removeClass('validatebox-invalid');
	}

	var order = 0;
	//添加指标项行
	function insertTr(old){
		order++;
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+order+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+order+"'>";
		}
		temp =temp + ("<td><input name='question_id_"+order+"' id='question_id_"+order+"' value='000' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+order+"</td> "+
		"<td><input name='question_instruction_"+order+"' maxlength='50' id='question_instruction_"+timestamp+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,50]'\" /></td>"+
		"<td><input type='text' name='y_date_"+order+"' id='y_date_"+order+"' value='<%=appDate%>' class='input_width easyui-datebox' style='height:20px;width:98%;' editable='false' required/></td>"+
		"</tr>");
		var targetObj = $(temp);
	    $.parser.parse(targetObj);
		$("#itemTable").append(targetObj);
		return timestamp; 
	}
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form1").append("<input type='hidden' name='del_tr_"+tts+"' value='"+itemId+"'/>");
		}
		//获取行id
		var temp = $(item).parent().parent().attr("id");
		//删除行
		$(item).parent().parent().remove();
		//序号重新排序
		var _index = parseInt(temp.split("_")[1]);
		for(var j=_index;j<order;j++){
			//给隐藏域序号赋值
			$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
			//给序号赋值
			var order_td = $("#tr_"+(j+1)).children().eq(1);
			order_td.html(j);
			//给tr 属性 赋值
			$("#tr_"+(j+1)).attr("id","tr_"+j);
		}
		if(_index = order){
			 if(confirm('确定要删除吗?')){
				var retObj = jcdpCallService("CheckDevQuestion", "deleteCheckQuestionInfo", "question_id="+itemId);				
				if(typeof retObj.operationFlag!="undefined"){
					var dOperationFlag=retObj.operationFlag;
					if(''!=dOperationFlag){
						if("failed"==dOperationFlag){
							alert("删除失败！");
						}	
						if("success"==dOperationFlag){
							alert("删除成功！");
							//删除行
							$(item).parent().parent().remove();
							//索引减一
							order=order-1;
							queryData(cruConfig.currentPage);
						}
					}
				}
			}
		}
		//索引减一
		order=order-1;
	}
</script>
</html>