<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String loginId = request.getParameter("loginid");
	String userPwd = request.getParameter("userpwd");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
  <title>修改密码</title> 
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box_content" style="height: 500px;">
    <div id="new_table_box_bg" style="height: 450px;">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		 <tr>
			<td class="inquire_item4">新密码:</td>
			<td class="inquire_form4">
				<input id="password" name="password" class="input_width easyui-validatebox" type="password" data-options="validType:['length','checkPwd']" required/>
				<input name="loginid" id="loginid" type="hidden" value="<%=loginId%>"/>
				<input name="userpwd" id="userpwd" type="hidden" value="<%=userPwd%>"/>
			</td>
		 </tr>
		 <tr>
			<td class="inquire_item4">确认密码:</td>
			<td class="inquire_form4"><input id="repassword" name="repassword" class="input_width easyui-validatebox" type="password" data-options="validType:['length','equalTo','checkPwd']" required/></td>				
		 </tr>
      </table>
      <div>
	      <h4>密码修改说明：</h4>
	      <p>1、此密码修改的为非统一认证密码。</p>
		  <p>2、格式要求：必须同时包含：大写字母(<font color="#FF0000">A-Z</font>)、小写字母(<font color="#FF0000">a-z</font>)、数字(<font color="#FF0000">0-9</font>)、特殊字符(<font color="#FF0000">$@#!*?</font>)，长度要求<font color="#FF0000">12</font>位及以上。</p>
	  </div>
    </div>
    <div id="oper_div" style="padding-top:6px;">
		 <a href="####" id="submitButton" class="easyui-linkbutton" onclick="submitInfo()"><i class="fa fa-floppy-o fa-lg"></i> 提交 </a>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		 <a href="####" class="easyui-linkbutton" onclick='newClose()'><i class="fa fa-times fa-lg"></i> 关 闭 </a>
    </div>
  </div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	//为必填项添加红星
	$("#form1").renderRequiredLabel();
	//第一次进入页面移除验证提示
	$('.validatebox-text').removeClass('validatebox-invalid');
	
	$.extend($.fn.validatebox.defaults.rules, {  
		length: {
            validator: function (value) {
                if ($.trim(value).length >= 12) {
                    return true;
                } else {
                    return false;
                }
            },
            message: '密码长度必须12位及以上'
        },
	    equalTo: {
	        validator:function(value){
	        	if($.trim($("#password").val()) == $.trim(value)){
	        		 return true;
	        	}else{
	        		return false;
	        	}
	        },
	        message:'两次输入密码不匹配'
	    },
	    checkPwd: {
	        validator:function(value){
	        	return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@#!*?])[A-Za-z\d$@#!*?]{12,}/.test($.trim(value));
	        },
	        message:'密码中必须同时包含：大写字母、小写字母、数字、特殊字符，长度要求12及位以上'
	    }
	});
});

	//提交
	function submitInfo(){
		if(formVilidate($("#form1"))){
			var loginid = $.trim($("#loginid").val());
			var userpwd = $.trim($("#userpwd").val());			
			//判断状态		
			var retObj = jcdpCallService("DevCommWtcSrv", "checkHomeUserPassWord", "loginid="+loginid+"&userpwd="+userpwd);
			if(typeof retObj.datas!="undefined"){
				var opFlag = retObj.datas;
				if("1" == opFlag){
					$.messager.alert("提示","旧密码不匹配!","warning");
					return;			
				}
				if("3" == opFlag){
					$.messager.alert("提示","操作失败!","error");
					return;
				}
			}
			$.messager.confirm("操作提示", "您确定修改密码吗？", function (data) {
				if (data) {
					$.messager.progress({title:'请稍后',msg:'数据保存中....'});
		    		$("#submitButton").attr({"disabled":"disabled"});
					document.getElementById("form1").action="<%=contextPath%>/rm/dm/changePassword/updateHomePassWord.srq";
					document.getElementById("form1").submit();
				}
			});
		}
	}
	//关闭
	function newClose(){
		top.closeDialog(window);
	}
</script>
</html>
