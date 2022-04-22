<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="UTF-8" import="com.bgd.platform.util.service.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>地方还款账户推送</title>
    <script src="/js/commonUtil.js"></script>
    <script src="dfhkzhts.js"></script>
    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0px auto;

        }

        span.required {
            color: red;
            font-size: 100%;
        }

    </style>
</head>
<body style="margin: 0px">
<%
    /*获取登录用户*/
    String userName = (String) request.getSession().getAttribute("USERNAME");
    String nowDate = SpringContextUtil.getDbDateDay();
%>
<div id="unitManage" style="width: 100%;height:100%;margin: 0px auto;">
</div>
<script type="text/javascript">
    var userName = '<%=userName%>';
    var nowDate = '<%=nowDate%>';
</script>
</body>
</html>