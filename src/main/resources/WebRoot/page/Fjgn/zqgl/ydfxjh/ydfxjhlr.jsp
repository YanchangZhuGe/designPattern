<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld"%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>月度发行计划</title>

    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>

</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;"></div>
<script>
    //系统参数：是否使用二维码功能
    var isCreateQRCode = '${fns:getSysParam("IS_CREATE_QRCODE")}';
    if(isCreateQRCode==null||isCreateQRCode==''){
        isCreateQRCode = '0';
    }
    var IS_ZXZQXT_FX = '${fns:getSysParam("IS_ZXZQXT_FX")}';
    //是否标准版
    var IS_BZB = '${fns:getSysParam("IS_BZB")}';
/*
    var is_zxzq = getQueryParam("is_zxzq");
*/
    var is_zxzq ="${fns:getParamValue('is_zxzq')}";
    //2020/08/25 guodg url参数来区分标准版和专项债
    if(IS_BZB == '1' && is_zxzq == '1'){
        IS_BZB = '2';
    }
    //session中区划
    var AD_CODE = '${sessionScope.ADCODE}';
    // 系统省级区划
    var eleAdCode = '${fns:getSysParam("ELE_AD_CODE")}';
    // 个性定制参数
   /* var GxdzUrlParam = getQueryParam("GxdzUrlParam");
    if(typeof GxdzUrlParam == 'undefined' || null==GxdzUrlParam){
        GxdzUrlParam = '0';
    }*/
    var GxdzUrlParam ="${fns:getParamValue('GxdzUrlParam')}";
    if (isNull(GxdzUrlParam)) {
        GxdzUrlParam = '0';
    }
    // 定义项目组数据源
    var store_xmz = [];
    $.post("getXmzStore.action", {
    }, function (data) {
        for(var i = 0; i < data.list.length; i++){
            store_xmz.push(data.list[i]);
        }
    }, "json");
</script>

<script src="ydfxjhlr.js"></script>
</body>
</html>
