<%--
  Created by IntelliJ IDEA.
  User: zhuangrx
  Date: 2020-12-08
  Time: 18:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title></title>
    <script src="/js/bootstrap.js"></script>
    <script src="XMZjPSYJ.js" type="text/javascript"></script>
    <script type="text/javascript">
        //var BILL_ID = getQueryParam("ID");//项目申报id
        //20210430 fzd 安全性修改
        var BILL_ID = "${fns:getParamValue('ID')}";
        var AD_CODE = '${sessionScope.ADCODE}';
        var IS_ZJ = '${fns:getSysParam("IS_ZJ")}';//是否选择专家评分

    </script>
    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0px auto;

        }

        .x-panel-header-new {
            background-image: none;
            background-color: #fff;
            height: 60px;
            line-height: 60px;
            font-size: 25px;
            padding: 0;
            margin: 0;
        }

    </style>
</head>
<body style="margin: 0px">

</body>
</html>