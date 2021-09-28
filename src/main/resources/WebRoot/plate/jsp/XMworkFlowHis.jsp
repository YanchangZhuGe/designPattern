<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title></title>
    <script src="/js/bootstrap.js"></script>
    <script src="XMWorkFlowHis.js" type="text/javascript"></script>
    <script type="text/javascript">
        // var ywsjid = getQueryParam("YWSJID");//项目
        // var flow_branch = getQueryParam("FLOW_BRANCH");//项目
        // var BILL_YEAR = getQueryParam("BILL_YEAR");//项目
        //20210430 fzd 安全性修改
        var ywsjid = "${fns:getParamValue('YWSJID')}";
        var flow_branch = "${fns:getParamValue('FLOW_BRANCH')}";
        var BILL_YEAR = "${fns:getParamValue('BILL_YEAR')}";

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