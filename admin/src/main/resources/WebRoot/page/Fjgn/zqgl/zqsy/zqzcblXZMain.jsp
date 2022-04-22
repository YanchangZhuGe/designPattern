<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>新增债券支出补录主界面</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    /*获取登录用户*/
    var USERCODE = '${sessionScope.USERCODE}';
    var USERNAME = '${sessionScope.USERNAME}';
    var USER_AG_ID = '${sessionScope.AGID}';
    var USER_AG_CODE = '${sessionScope.AGCODE}';
    var USER_AG_NAME = '${sessionScope.AGNAME}';
    var USER_AD_CODE = '${sessionScope.ADCODE}';
    var USER_AD_NAME = '${sessionScope.ADNAME}';
    var nowDate = '${fns:getDbDateDay()}';
/*
    var GxdzUrlParam = getQueryParam("GxdzUrlParam");// 个性定制参数
*/
    var GxdzUrlParam ="${fns:getParamValue('GxdzUrlParam')}";
    if (!GxdzUrlParam || GxdzUrlParam == 'null') {
        GxdzUrlParam = null;
    }
    if (!USER_AG_ID || USER_AG_ID == 'null') {
        USER_AG_ID = null;
    }
    if (!USER_AG_CODE || USER_AG_CODE == 'null') {
        USER_AG_CODE = null;
    }
    if (!USER_AG_NAME || USER_AG_NAME == 'null') {
        USER_AG_NAME = null;
    }
</script>
<script type="text/javascript" src="zqzcblXZMain.js"></script>
</body>
</html>