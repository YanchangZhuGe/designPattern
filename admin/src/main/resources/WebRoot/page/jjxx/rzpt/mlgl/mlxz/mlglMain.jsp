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
    <title>名录管理</title>
    <link rel="SHORTCUT ICON" href="/bgd.ico">
    <!--引用自定义js-->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
</head>
<body>
<%
    //String userCode = (String) request.getSession().getAttribute("USERCODE");//获取登录用户
%>
<script>
    //获取用户信息
    var userCode = '${sessionScope.USERCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id
    var node_type = "${fns:getParamValue('node_type')}";
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    var showGqjg =  "${fns:getParamValue('showGqjg')}";
    var showFj = "${fns:getParamValue('showFj')}";
</script>
<script src="mlglMain.js"></script>
<script type="text/javascript" src="/json_file/mlxz.json"></script>
</body>
</html>