<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>下级项目审核</title>
    <style type="text/css">
        .grid-cell-font {
            color: blue;
        }

        .label-color {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/Map.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script type="text/javascript">
    var nowDate = '${fns:getDbDateDay()}';
    var userName = '${sessionScope.USERNAME}';
    var USER_AD_CODE = '${sessionScope.ADCODE}';
    var node_type = "${fns:getParamValue('node_type')}";//当前节点名称
    var button_name = '';//当前操作按钮名称text
    var button_status = '';//当前操作按钮的name，标识按钮状态
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }

    //是否加载全部区划
    var v_child = '0';
    //上报审核状态，0未审核，1已审核
    var store_shyj = DebtEleStore([
        {code: '0', name: '不通过'},
        {code: '1', name: '通过'}
    ]);
    /**
     * 通用配置json，用于存储全局配置，
     */
    var zcxjsh_json_common = {
        zcxjxmsh: 'zcxjsh.js'//下级审核
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        //动态加载js
        $.ajaxSetup({
            cache: true
        });
        //ajax加载js文件
        $.getScript(zcxjsh_json_common[node_type], function () {
                initContent();
        });
    });

    /**
     * 初始化右侧panel
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'contentGrid',
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
           //dockedItems: zcxjsh_json_common.items_content_rightPanel_dockedItems ? zcxjsh_json_common.items_content_rightPanel_dockedItems : null,
            items: zcxjsh_json_common.items_content_rightPanel_items ? zcxjsh_json_common.items_content_rightPanel_items() : null
        });
    }


</script>
</body>
</html>