<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>项目调研信息登记</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var now_date = '${fns:getDbDateDay()}';
    var v_child = "${fns:getParamValue('v_child')}";
    if (isNull(v_child)) {
        v_child = '0';
    }
</script>
<script type="text/javascript" src="xmdy.js"></script>
</body>
</html>