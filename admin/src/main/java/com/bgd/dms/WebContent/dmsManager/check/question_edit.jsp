<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
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
	String question_id=request.getParameter("question_id");
	if(null==question_id){
		question_id="";
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
<title>问题修改</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:98%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin:2px;padding:2px;"><legend>基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      <tr>
      	<input type="hidden" id="question_id" name="question_id" value="<%=question_id %>"/>
    	<input type="hidden" id="ck_id" name="ck_id" value="<%=ck_id %>"/>
		<td class="inquire_item6">问题描述：</td>
		<td class="inquire_form6" >
		<input name="question_instruction" id="question_instruction" class="input_width easyui-validatebox main" style="width:200px" type="text" readonly="readonly"/>
		</td>
		<td class="inquire_item6">预计解决时间：</td>
		<td class="inquire_form6" >
		<input type="text" name="y_date" id="y_date" class="input_width easyui-datebox main" style="width:200px" editable="false" readonly="readonly"  required/>
	  	</td>
	  </tr>
	  <tr>
	  	<td class="inquire_item6">问题状态：</td>
		<td class="inquire_form6" >
		<select name="question_info" id="question_info" style="width:200px" class="input_width easyui-validatebox">
  			<option value ="已解决" selected="selected">已解决</option>
 			<option value ="未解决">未解决</option>
		</select>
		</td>
		<td class="inquire_item6">实际解决时间：</td>
		<td class="inquire_form6" >
		<input type="text" name="s_date" id="s_date" value="<%=appDate%>" class="input_width easyui-datebox" style="width:200px" editable="false" required/>
		</td>
	  </tr>
	  <tr>
		<td class="inquire_item6">解决单位：</td>
		<td class="inquire_form6" >
		<input name="question_serctor" id="question_serctor" style="width:200px" class="input_width main" type="text" value="" maxlength="50"/>
		</td>
	  </tr>
	  <tr>
		<td class="inquire_item6">解决办法：</td>
        <td class="inquire_form4" colspan="3">
        	<textarea id="question_function" name="question_function" style="overflow-x:scroll" maxlength="200" class="easyui-validatebox textarea main" data-options="validType:'length[0,200]'" ></textarea>			  
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
	//配置表ID
	//增加修改标志
	var flag="update";
	var question_id = "<%=question_id%>";
	var ck_id = "<%=ck_id%>";
	//页面初始化信息
	$(function(){
		var retObj ;
		if("update"==flag){
			//隐藏选择日期按钮
			retObj = jcdpCallService("CheckDevQuestion", "getCheckConfInfo","question_id=<%=question_id%>");
			if(typeof retObj.data!="undefined"){
				var _ddata = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(_ddata[temp] != undefined ? _ddata[temp]:"");
				});
				$("#y_date").datebox("setValue", retObj.data.y_date);
				$("#s_date").datebox("setValue", retObj.data.s_date);
			}
		}
	});
	
	//日期判断
	function disInput(index){
		//重新渲染加入的日期框
		$.parser.parse($("#tr"+index));
		//第一次进入移除验证
		$('.validatebox-text').removeClass('validatebox-invalid');
	}
	
	//选择调配单位机构树
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var outorgname = $("#question_serctor").val();
		if( outorgname != names[1] ){
			$("#question_serctor").empty();
		}
		document.getElementById("question_serctor").value = names[1];	
	}
	
	//提交保存
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var question_id = $.trim($("#question_id").val());
		var ck_id =  $.trim($("#ck_id").val());
		var question_instruction = $.trim($("#question_instruction").val());
		var question_serctor = $.trim($("#question_serctor").val());
		var y_date = $.trim($("#y_date").val());
		var question_info = $.trim($("#question_info").val());
		var s_date = $.trim($("#s_date").val());
		var question_function = $.trim($("#question_function").val());
		if(question_instruction.length<=0){
			$.messager.alert("提示","问题描述不能为空!","warning");
			return;
		}
		if(y_date.length<=0){
			$.messager.alert("提示","预计解决时间不能为空!","warning");
			return;
		}
		if(s_date.length<=0){
			$.messager.alert("提示","实际解决时间不能为空!","warning");
			return;
		}
		if(s_date.length>0){
			if(question_info=="未解决"){
				$.messager.alert("提示","问题状态未更改!","warning");
				return;
			}
			if(question_serctor.length<=0){
				$.messager.alert("提示","解决单位不能为空!","warning");
				return;
			}
			if(question_function.length<=0){
				$.messager.alert("提示","解决办法不能为空!","warning");
				return;
			}
		}
		if(question_info.length<=0){
			$.messager.alert("提示","问题状态不能为空!","warning");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/check/saveOrUpdateCheckQuestionInfo.srq?flag=update";
    			document.getElementById("form1").submit();
            }
        });
	}
</script>
</html>