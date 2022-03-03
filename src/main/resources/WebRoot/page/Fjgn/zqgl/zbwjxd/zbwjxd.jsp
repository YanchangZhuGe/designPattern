<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>指标文件下达</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var AG_CODE = '${sessionScope.AGCODE}';
    var now_date = '${fns:getDbDateDay()}';
</script>
<script type="text/javascript" src="zbwjxd.js"></script>
</body>
</html>
