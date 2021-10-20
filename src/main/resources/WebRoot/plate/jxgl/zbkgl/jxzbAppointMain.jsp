<%--
  User: jiafy
  Date: 2021-07-23
  Time: 下午 2:46
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>绩效指标下达</title>
    <!-- 重要：引入统一js -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/page/debt/jxgl/zbkgl/jxzbAppointMain.js"></script>
</head>
<body>
<script>
    var AD_CODE = '${sessionScope.ADCODE}';
    var TREE_IND_ID = '';//指标树选择的指标id
    var TREE_IND_CODE = '';//指标树选择的指标code
    var XDSTATUS = 0;//检索条件的下达状态,默认状态未发布
    var INDCODEORNAME = '';//检索条件的指标编码或指标名称
    var ZBLX_ID = '';//检索条件的指标类型
    var CURRENT_YEAR = new Date().getFullYear(); //当前年度
    var IND_TYPE = "${fns:getParamValue('IND_TYPE')}"; //指标类型
    var XMLX_ID_SEL = ''; // 检索条件选中的项目类型
    var XMLX_NAME_SEL = ''; // 检索条件选中的项目类型名称
</script>
</body>
</html>
