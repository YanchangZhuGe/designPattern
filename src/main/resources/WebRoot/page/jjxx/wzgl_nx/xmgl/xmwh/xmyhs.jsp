<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>项目一户式预览</title>
    <script type="text/javascript">
        var wzxy_id="${fns:getParamValue('WZXY_ID')}";
    </script>
    <script src="/js/commonUtil.js"></script>
    <script src="xmyhs.js"></script>
    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0px auto;
        }

        span.required {
            color: #ff0000;
            font-size: 100%;
        }

        span.displayfield {
            font-weight: bolder;
            font-size: 16px;
        }
    </style>
</head>
<body style="margin: 0px">
</body>
</html>
