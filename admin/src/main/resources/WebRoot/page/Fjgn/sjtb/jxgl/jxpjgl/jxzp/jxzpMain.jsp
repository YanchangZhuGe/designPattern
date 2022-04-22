<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>绩效自评</title>
    <style type="text/css">
        .x-grid-back-green {
            background: #24ff66;
        }
        .x-grid-back-blue {
            background: #2dc7ff;
        }
        .x-grid-back-yellow {
            background: #fff96b;
        }
        .x-grid-back-red {
            background: #ff4330;
        }
        .x-grid-back-gray {
            background-color: #FFFFFF !important;
        }
        .layui-table-cell {
            height: 23.3px !important;
            line-height: 23.3px !important;
        }

        .tdpd {
            color: #9F9F9F;
            position: absolute;
            width: 100%;
            height: 23.3px;
            line-height: 23.3px;
            padding-left: 10px
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/page/debt/jxgl/jxpjgl/jxzp/jxzpMain.js"></script>
<script type="text/javascript" src="/page/debt/jxgl/jxpjgl/jxzp/jxzptbPanel.js"></script>
<script type="text/javascript">
    var wf_id  = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code  = "${fns:getParamValue('node_code')}";// 当前节点编码
    var node_type  = "${fns:getParamValue('node_type')}";// 当前节点类型
    var WF_STATUS  = "${fns:getParamValue('WF_STATUS')}";// 工作流状态
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';// 帆软报表是否集成部署
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var BMA = "${fns:getParamValue('BMA')}";// 是否部门审核岗1：是，0：否
    if (isNull(BMA)) {
        BMA = '0';
    }
</script>
</body>
</html>