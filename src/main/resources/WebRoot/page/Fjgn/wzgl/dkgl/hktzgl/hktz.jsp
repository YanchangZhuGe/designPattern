<%--
  Created by IntelliJ IDEA.
  User: wangjingcheng
  Date: 2018/10/30
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>还款通知</title>
    <style type="text/css">
        .x-grid-back-green {
            background: #00ff00;
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    /**
     * 通用函数：获取url中的参数
     */
    /* function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    } */
    var fktz_type= "${fns:getParamValue('fktz_type')}"; //当前付款类型
    if(fktz_type==null||fktz_type==undefined||fktz_type==""){
        fktz_type="sj";
    }
    var button_name = '';//当前操作按钮名称
    var button_text = '';
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var userCode= '${sessionScope.USERCODE}';
    var flag = true;
    var EndDateStore;

</script>
<script type="text/javascript" src="hktz.js"></script>
</body>
</html>
