<%--
  Created by IntelliJ IDEA.
  User: wangjingcheng
  Date: 2018/11/9
  Time: 9:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="UTF-8" import="com.bgd.platform.util.service.*"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>提款限额维护</title>
    <script src="/js/commonUtil.js"></script>
    <script src="tkxeMain.js"></script>
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
<div id="unitManage" style="width: 100%;height:100%;margin: 0px auto;">
</div>
<script type="text/javascript">
    var userName = '${sessionScope.USERNAME}';
    var nowDate = '${fns:getDbDateDay()}';
</script>
</body>
</html>
