<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>项目整改意见</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var ADCODE = '${sessionScope.ADCODE}';
    var node_type = '${fns:getParamValue("node_type")}';
    var wf_status = "${fns:getParamValue('wf_status')}";
    if (isNull(wf_status)) {
        wf_status = '001';
    }
    var v_child = "${fns:getParamValue('v_child')}";
    if (isNull(v_child)) {
        v_child = '0';
    }
</script>
<script type="text/javascript" src="xmzgyj.js"></script>
</body>
</html>