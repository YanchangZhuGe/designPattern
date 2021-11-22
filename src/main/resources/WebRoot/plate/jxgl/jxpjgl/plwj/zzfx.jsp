<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld"%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>披露文件上传</title>

    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/js/debt/xmInfo.js"></script>
    <script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
    <script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
    <script >
        var userName = '${sessionScope.USERNAME}';  //获取用户名称
        var userCode = '${sessionScope.USERCODE}';  //获取用户编码
        var AD_CODE='${sessionScope.ADCODE}'.replace(/00$/, "");
        var nowDate = '${sessionScope.nowDate}';
        var userName = '${sessionScope.USERNAME}';
        var userCode = '${sessionScope.USERCODE}';
        var nowDate = '${fns:getDbDateDay()}';  //当前日期
        var AD_CODE='${sessionScope.ADCODE}'.replace(/00$/, "");
        var HAVE_SFJG = '${fns:getSysParam("HAVE_SFJG")}';//是否含有第三方机构评价
        var sys_right_model = '${fns:getSysParam("SYS_RIGHT_MODEL")}';//是否含有第三方机构评价
        var is_zj = '${fns:getSysParam("IS_ZJ")}';//是否含有第三方机构评价

        //url参数 区分专项数据  1：专项；2 一般  0 合并
        //var is_zxzq = getQueryParam("is_zxzq");
        //var is_fxjh = getQueryParam("is_fxjh");
        var IS_XMBCXX = '${fns:getSysParam("IS_XMBCXX")}';  //获取系统参数 项目补充信息是否显示
        var IS_FZJCK = '${fns:getSysParam("IS_FZJCK")}';
        var ELE_AD_CODE = '${sessionscope.ELE_AD_CODE}';// 系统参数：省级区划编码
        //var GxdzUrlParam = getQueryParam("GxdzUrlParam");// url参数：省级区划编码

        //20210429 fzd 安全性修改
        //url参数 区分专项数据  1：专项；2 一般  0 合并
        var is_zxzq =  "${fns:getParamValue('is_zxzq')}";
        var is_fxjh =  "${fns:getParamValue('is_fxjh')}";
        var GxdzUrlParam =  "${fns:getParamValue('GxdzUrlParam')}";// url参数：省级区划编码

        if(typeof GxdzUrlParam == 'undefined' || null==GxdzUrlParam){
            GxdzUrlParam = '00';
        }
        if(typeof is_zxzq == 'undefined' || null==is_zxzq){
            is_zxzq = '0';
        }
    </script>
    <script src="zzfx.js"></script>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;"></div>
</body>
</html>
