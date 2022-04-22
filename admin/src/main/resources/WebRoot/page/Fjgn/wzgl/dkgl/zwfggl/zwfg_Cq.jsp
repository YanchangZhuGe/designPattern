<%--
  Created by IntelliJ IDEA.
  User: wangjingcheng
  Date: 2018/10/19
  Time: 17:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>债务确认(咨询其他)</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
</head>
<body>
<!--基础数据集-->

<script type="text/javascript">
    var userCode = '${sessionScope.USERCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点code
    var ad_code = '${sessionScope.ADCODE}';//当前节点code
    var node_name = "lr";//当前节点名称
    var button_name = '';//当前操作按钮名称
    var BIZ_DATA_ID;//外债协议关联id
    var BIZ_XMTK_ID;//项目提款申请主单id
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }

</script>
<script type="text/javascript" src="zwfg_Cq.js"></script>
</body>
</html>
