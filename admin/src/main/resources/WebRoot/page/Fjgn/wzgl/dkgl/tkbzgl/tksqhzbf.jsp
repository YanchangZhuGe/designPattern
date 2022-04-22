<%--
  Created by IntelliJ IDEA.
  User: cuihz
  Date: 2017/10/31
  Time: 上午9:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <script type="text/javascript" src="/js/debt/ele_data.js"></script>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="tksqhzbf.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>提款申请汇总拨付</title>
</head>
<body>
    <script type="text/javascript">
        //从url获取参数
       /*  function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return unescape(r[2]);
            return null; //返回参数值
        } */
        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";
        var DATA_TYPE = 0;
        var BIZ_ID = "";
        var BFPC_NO = "";
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
    </script>
    <div id="contentPanel" style="width: 100%;height: 100%;"></div>
</body>
</html>
