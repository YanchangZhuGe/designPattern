<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>单位资产主界面</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var USER_AG_ID = '${sessionScope.AGID}';
    var USER_AG_CODE = '${sessionScope.AGCODE}';
    var USER_AG_NAME = '${sessionScope.AGNAME}';
    var USER_AD_CODE = '${sessionScope.ADCODE}';
    var USER_AD_NAME = '${sessionScope.ADNAME}';
    if (!USER_AG_ID || USER_AG_ID == 'null') {
        USER_AG_ID = null;
    }
    if (!USER_AG_CODE || USER_AG_CODE == 'null') {
        USER_AG_CODE = null;
    }
    if (!USER_AG_NAME || USER_AG_NAME == 'null') {
        USER_AG_NAME = null;
    }
    var nowDate = '${fns:getDbDateDay()}';
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    var node_type = "${fns:getParamValue('node_type')}";//当前节点id
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
</script>
<script type="text/javascript" src="dwzcsh.js"></script>
</body>
</html>