<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>部门支出</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var AD_NAME = '${sessionScope.ADNAME}';
    var USER_NAME = '${sessionScope.USERNAME}';
    var wf_id = "${fns:getParamValue('wf_id')}"; //当前流程id
    var node_code = "${fns:getParamValue('node_code')}"; //当前节点id
    var now_date = '${fns:getDbDateDay()}';
</script>
<script type="text/javascript" src="bmzc.js"></script>
</body>
</html>