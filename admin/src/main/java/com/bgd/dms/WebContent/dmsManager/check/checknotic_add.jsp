<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String flag=request.getParameter("flag");
	String ck_dmsid=request.getParameter("ck_dmsid");
	if(null==ck_dmsid){
		ck_dmsid="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>添加验证通知</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:98%">
    <div id="new_table_box_bg" style="width:95%">
    <input type="hidden" id="ck_dmsid" class="main" name="ck_dmsid" />
      <fieldset style="margin:2px;padding:2px;"><legend>基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
          <td class="inquire_item4" ><font color=red>*</font>&nbsp;需求计划单号</td>
          <td class="inquire_form4" >
          	<input name="apply_num" id="apply_num" class="input_width main" type="text" value=""  readonly/>
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevAccountPage()"  />
          </td>
          <td class="inquire_item4" ><font color=red>*</font>&nbsp;预计到货时间时间:</td>
			<td class="inquire_form4">
				<input type="text" name="yar_date" id="yar_date" value="<%=appDate%>" class="input_width easyui-datebox main" style="width:188px" editable="false" required/>
			</td>
        </tr>
        <tr>
			<td class="inquire_item4"><font color=red>*</font>&nbsp;合同号:</td>
			<td class="inquire_form4"><input name="pact_num" id="pact_num" class="input_width easyui-validatebox main" type="text" value="" maxlength="50" required/></td>
			<td class="inquire_item4"><font color=red>*</font>&nbsp;供货商:</td>
			<td class="inquire_form4"><input name="ck_company" id="ck_company" class="input_width easyui-validatebox main" data-options="validType:'length[0,50]'" maxlength="50" type="text" value="" required/></td>
			</td>
		</tr>
		<tr>
		  <td class="inquire_item4"><font color=red>*</font>&nbsp;调入单位:</td>
          <td class="inquire_form4">
          	<input name="fold_org_name" id="fold_org_name" class="input_width main" type="text" value="<%=user.getOrgName() %>" readonly/>
         		<input name="fold_org_id" id="fold_org_id" value="<%=user.getOrgId() %>" type="hidden" class="main"/>
          		<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()" />
          </td>
          <td class="inquire_item4"><font color=red>*</font>&nbsp;现使用单位:</td>
          <td class="inquire_form4">
          	<input name="using_org_name" id="using_org_name" class="input_width main" type="text" value="" readonly/>
          	<input name="using_org_id" id="using_org_id" value="" type="hidden" class="main"/>
          		<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage2()" />
          </td>
        </tr>
        <tr>
		  <td class="inquire_item4">&nbsp;存档资料:</td>
		  <auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd(1)'"></auth:ListButton>
		</tr>
		<tr>
	   	  <td colspan="3">
		 	<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="ck_post">
				<input name="ck_post_" id="ck_post_" type="hidden" />
		 	</table>
	   	  </td>
		</tr>
      </table>
      </fieldset>
      <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="####" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
      </div>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var contextpath= "<%=contextPath%>";
	//通知表ID
	var ck_dmsid= "<%=ck_dmsid%>";
	//增加修改标志
	var flag="<%=flag%>";
	//页面初始化信息
	$(function(){
		loadDate();
	});
	//加载数据					
	function loadDate(){
		debugger;
		var baseData; 
		var retObj ;
		baseData = jcdpCallService("CheckDevNotice", "getCheckConfInfo", "ck_dmsid=<%=ck_dmsid%>");
		if(typeof baseData.fdataPublic!="undefined"){ 
			// 有附件显示附件
			for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
				if(baseData.fdataPublic[tr_id-1].file_type =="ck_post"){
					insertFilePublic(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
		}
		if("update"==flag){
			retObj = jcdpCallService("CheckDevNotice", "getCheckConfInfo","ck_dmsid=<%=ck_dmsid%>");
			if(typeof retObj.data!="undefined"){
				var _ddata = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(_ddata[temp] != undefined ? _ddata[temp]:"");
				});
			}
			$("#yar_date").datebox("setValue", retObj.data.yar_date);
		}
	}

	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	})
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
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
		var outorgname = $("#fold_org_id").val();//调入单位
		document.getElementById("fold_org_name").value = names[1];
		document.getElementById("fold_org_id").value = id[1];
	}
	
	//选择调配单位机构树
	function showOrgTreePage2(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR2.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var id = strs[1].split(":");
		var outorgname = $("#using_org_id").val();//现使用单位
		document.getElementById("using_org_name").value = names[1];
		document.getElementById("using_org_id").value = id[1];
	}
	
	//获取当前时间
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
	
	
	//提交保存
	function submitInfo(){
		//保留的行信息
		debugger;
		var apply_num = $.trim($("#apply_num").val());
		var pact_num = $.trim($("#pact_num").val());
		var yar_date = document.getElementsByName("yar_date")[0].value;
		var fold_org_name = $.trim($("#fold_org_id").val());
		var using_org_name = $.trim($("#using_org_id").val());
		var ck_company = $.trim($("#ck_company").val());
		var myDate = getNowFormatDate();
		if(apply_num.length<=0){
			$.messager.alert("提示","需求计划单号不能为空!","waring");
			return;
		}
		if(pact_num.length<=0){
			$.messager.alert("提示","合同号不能为空!","waring");
			return;
		}
		if(yar_date.length<=0){
			$.messager.alert("提示","合同号不能为空!","waring");
			return;
		}
		if(CompareDate(myDate,yar_date)==true){
			$.messager.alert("提示","预计到达时间不能提前于当前时间!","waring");
			return;
		}
		if(ck_company.length<=0){
			$.messager.alert("提示","供货商不能为空!","waring");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/check/saveOrUpdateCheckConfInfo.srq?flag="+flag;
    			document.getElementById("form1").submit();
            }
        });
	}
	
	//时间对比方法
	function CompareDate(d1,d2){
	  return ((new Date(d1.replace(/-/g,"/"))) > (new Date(d2.replace(/-/g,"/"))));
	}

	//日期判断
	function disInput(index){
		//重新渲染加入的日期框
		$.parser.parse($("#tr"+index));
		//第一次进入移除验证
		$('.validatebox-text').removeClass('validatebox-invalid');
	}
	
	//显示需求表并获取数据
	function showDevAccountPage(){
		var obj = new Object();
		var dialogurl = "<%=contextPath%>/dmsManager/check/need_num.jsp";
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=350px");
		if(vReturnValue!=undefined){
			var content= vReturnValue.split('~');
			document.getElementById("apply_num").value=content[0];
		}
	}
	
	//新增附件
	function excelDataAdd(status){
			insertTrPublic('ck_post');
	}
	
	//新增插入文件
	var orders = 0;
	function insertTrPublic(obj){
		var tmp="public";
		$("#"+obj+"").append(
			"<tr id='ck_post'>"+
				"<td class='inquire_item5' style='width:80px;text-align:right'>附件：</td>"+
		  		"<td class='inquire_form5'><input type='file' name='ck_post__"+tmp+orders+"' id=ck_post__"+tmp+orders+"' onchange='getFileInfoPublic(this)'  style='width:200px;text-align:left' class='input_width'/></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);
		orders++;
	}
	
	//显示已插入的文件
	function insertFilePublic(name,id){
		$("#ck_post").append(
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
	
	// 获取文件信息
	function getFileInfoPublics(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#ck_post_"+order).val(docTitle);//文件name
	}
	
	//删除行
	function deleteInputPublic(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();	
	}
</script>
</html>