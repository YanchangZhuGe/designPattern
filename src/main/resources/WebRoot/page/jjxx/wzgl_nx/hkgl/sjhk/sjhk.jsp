<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>还款上级填报</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script>
        var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
        var node_code = "${fns:getParamValue('node_code')}";//当前节点id
        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
    </script>
    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0 auto;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;"></div>
<script type="text/javascript" src="sjhk.js"></script>
</body>
</html>
