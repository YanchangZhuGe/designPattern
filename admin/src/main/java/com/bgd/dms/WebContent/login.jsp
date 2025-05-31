<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="ep" prefix="ep"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil,com.cnpc.sais.ibp.auth2.util.UserUtil" %>
<%@page import="com.bgp.dms.util.RSAUtils"%>
<%
	String contextPath = request.getContextPath();
	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<link href="<%=contextPath %>/styles/gms4/style20131025.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jdialog/jdialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jsencrypt.min.js"></script>
<title>设备寿命周期管理平台-登录</title>
</head>
<body class="login_bg">
<div id="login">
<div class="login_part">
<form name="form1" id="form1" class="fl" method="post" action="" >
<div class="login_1">
	<ul>
		<li><input name="loginId" id="author" class="easyui-validatebox" type="text" required/></li>
		<li><input name="userPwd" id="website" class="easyui-validatebox" type="password" required/></li>
		<font size="2" color="red"><ep:msg msgTag="ReturnCodeMsg" key="retMsg"/></font> 
	</ul>	
</div>
<div class="login_2">
	<div class="login_2_1"><a id="submitButton" href="####" onclick="submitInfo()"><img src="<%=contextPath %>/images/gms4/login_05.png"/></a></div>
	<div class="login_2_2"><a href="####" onclick="clearQueryText()"><img src="<%=contextPath %>/images/gms4/login_08.png"/></a></div>
</div>
<div class="login_3"></div>
<div class="login_4"></div>
</form>
</div>
</div>
</body>
<script type="text/javascript">
$().ready(function(){
	//第一次进入页面移除验证提示
	$('.validatebox-text').removeClass('validatebox-invalid');
	
	$(document).keyup(function(event){		 
		if(event.keyCode ==13){
			submitInfo();
		}
	}); 
});

//重置清空
function clearQueryText(){
	document.getElementById("author").value ="";
	document.getElementById("website").value ="";
}

//提交
function submitInfo(){
	if(formVilidate($("#form1"))){
		var publicKey ='<%=RSAUtils.PUBLIC_KEY%>';//获得session中的公钥
		//RAS 加密
		var encrypt = new JSEncrypt();
		encrypt.setPublicKey(publicKey);//公钥
		
		var loginid = $.trim($("#author").val());
		loginid=encrypt.encrypt(loginid);//加密
		var userpwd = $.trim($("#website").val());
		userpwd=encrypt.encrypt(userpwd);//加密
	 	//判断状态		
		var retObj = jcdpCallService("DevCommWtcSrv", "checkHomeUserPassWord", "loginid="+loginid+"&userpwd="+userpwd);
		if(typeof retObj.datas!="undefined"){
			var opFlag = retObj.datas;
			if("3" == opFlag){
				$.messager.alert("提示","操作失败!","error");
				//return;
			}			
			if("5" == opFlag){
				$.messager.alert("提示","用户不存在!","warning");
				//return;
			}
			if("1" == opFlag || "2" == opFlag){
				$("#submitButton").attr({"disabled":"disabled"});
				document.getElementById("form1").action="<%=contextPath%>/hr_login.srq";
				document.getElementById("form1").submit();
			}else if("4" == opFlag){
				$.messager.confirm("操作提示", "您的用户密码不符合规范，请修改密码后重新登录？", function (data) {
					if (data) {
						window.top.$.JDialog.open('<%=contextPath%>/common/changeHomePassword.jsp?loginid='+loginid+'&userpwd='+userpwd,{title:'修改密码',height:'480',width:'780'}); 
					}
				});
			}
		}
	}
}	
</script>
</html>
