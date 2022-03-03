<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%
SpringContextUtil.checkUserUrlCode(request, response);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
<meta charset="UTF-8">
<title>单位管理</title>
<script src="/js/bootstrap.js"></script>

<script type="text/javascript" src="/js/plat/initLeftTree.js"></script>
<style type="text/css">
 html,body{
 width: 100%;height:100%;margin: 0px auto;
  
 }
 
 span.required {
            color: red;
            font-size: 100%;
        }

</style>

</head>
<body style="margin: 0px">
<%
    /*获取登录用户*//*
    String userCode = (String) request.getSession().getAttribute("USERCODE");
		*//*获取登录用户区划*//*
    String ADNAME = (String) request.getSession().getAttribute("ADNAME");
    String ADCODE = (String) request.getSession().getAttribute("ADCODE");*/
%>

<div id="unitManage" style="width: 100%;height:100%;margin: 0px auto;">
</div>
<script type="text/javascript">
    var USER_AD_CODE = '${sessionScope.USERCODE}';  //获取用户编码
    var ADNAME = '${sessionScope.ADNAME}';
    var ADCODE = '${sessionScope.ADCODE}';
</script>
<script src="unitTransfer.js" type="text/javascript"></script>
</body>
</html>