<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <%
        /*String IS_RZPT = (String) (SpringContextUtil.getSysParamMap()).get("IS_RZPT");
        String dir = "";
        if("1".equals(IS_RZPT)){
            dir = "/rzpt";
        }else{
            dir = "/qkj";
        }*/
    %>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>加载中..</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }

        span.displayfield {
            font-weight: bolder;
            font-size: 16px;
        }
        tr.x-grid-back-green .x-grid-td{
            background:#00ff00;
        }
    </style>
</head>
<body>
<link rel="SHORTCUT ICON" href="/bgd.ico">
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script>
    var MLXX_ID = '${fns:getParamValue("MLXX_ID")}';
    var AG_ID = '${fns:getParamValue("AG_ID")}';
    var AG_CODE = '${fns:getParamValue("AG_CODE")}';
    var ADCODE = '${fns:getParamValue("AD_CODE")}';
    var showGqjg =  '${fns:getParamValue("showGqjg")}';
    var showFj = '${fns:getParamValue("showFj")}';
    //获取用户信息
    var AD_CODE = '${sessionScope.ADCODE}';
</script>

<script src="mlYhsMain.js"></script>
<script src="/js/debt/UI_Draw_Lite.js"></script>
<%--<script type="text/javascript" src="/json_file/rzpt/mlYhs.json"></script>--%>
</body>
</html>