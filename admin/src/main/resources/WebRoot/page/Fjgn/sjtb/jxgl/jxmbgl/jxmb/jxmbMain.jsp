<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>年度绩效目标填报</title>
    <style type="text/css">
        /* 绩效目标表格可编辑色*/
        .x-grid-back-white {
            background-color: #FFFFFF !important;
        }

        /* 绩效目标表格不可编辑色*/
        .x-grid-back-gray {
            background-color: #F2F2F2 !important;
        }

        /* 绩效目标表格行高*/
        .layui-table-cell {
            height: 23.3px !important;
            line-height: 23.3px !important;
        }

        .zb-select-btn {
            cursor: pointer;
        }

        .layui-table-cell {
            overflow: visible !important;
        }

        .layui-table-body {
            overflow: visible !important;
        }

        /*.layui-table-view {
            overflow: visible !important;
        }*/
        .layui-table-box {
            overflow: visible !important;
        }

        .dldw-select-btn {
            background: url('/image/common/selectSign.png') no-repeat;
            background-size: 14px 14px;
            background-position: 80px center;
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
<script type="text/javascript" src="/page/debt/jxgl/jxmbgl/jxmb/jxmbMain.js"></script>
<script type="text/javascript" src="/page/debt/jxgl/jxmbgl/xzzqjxmb.js"></script>
<script type="text/javascript">
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";// 当前节点编码
    var node_type = "${fns:getParamValue('node_type')}";// 当前节点类型
    var is_end = "${fns:getParamValue('is_end')}";// 流程是否结束
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";// 工作流状态
    var USER_AD_CODE = '${sessionScope.ADCODE}';  //获取地区code
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var BMA = "${fns:getParamValue('BMA')}";// 是否是主管部门
</script>
</body>
</html>