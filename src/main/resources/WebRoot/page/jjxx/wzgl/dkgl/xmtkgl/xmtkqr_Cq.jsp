<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 2018/12/18
  Time: 9:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>债务确认(土建设备)</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
</head>
<script type="text/javascript">
    var button_name = '';//当前操作按钮名称
    var BIZ_DATA_ID;//外债协议关联id
    var BIZ_XMTK_ID;//项目提款申请主单id
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
</script>
<script type="text/javascript" src="xmtkqr_Cq.js"></script>
</body>
</html>
