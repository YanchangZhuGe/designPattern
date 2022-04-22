<%--
  Created by IntelliJ IDEA.
  User: dahuang
  Date: 2017/10/31
  Time: 下午7:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <script type="text/javascript" src="/js/debt/ele_data.js"></script>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="tksqdz.js"></script>
    <title>提款申请到账</title>
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
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
    </script>
    <div id="contentPanel" style="width: 100%;height: 100%;"></div>
</body>
</html>
