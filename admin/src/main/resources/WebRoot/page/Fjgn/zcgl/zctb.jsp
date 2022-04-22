<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <title>资产统计</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <!--基础数据集-->
    <script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
</head>
<body>
<script>
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    var zcgl_json_common = {
        'zctb':{
            jsFileUrl: 'zctj_zctb.js'
        },
        'zhuangtai' : [
            {"id":"0","code":"001","name":"未上报"},
            {"id":"1","code":"002","name":"已上报"},
            {"id":"4","code":"004","name":"被退回"}
        ]
    };
    var IS_INPUT_WXCZC_REASON;//是否录入未形成资产原因
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        $.post("/getParamValueAll.action", function (data) {
            var REASON = data[0].IS_INPUT_WXCZC_REASON;
            if (REASON == 0) {
                IS_INPUT_WXCZC_REASON = false;
            } else if(REASON == 1) {
                IS_INPUT_WXCZC_REASON = true;
            }
        },"json");
        Ext.form.Field.prototype.msgTarget = 'side';
        //动态加载js
        $.ajaxSetup({
            cache: true
        });
        $.getScript(zcgl_json_common['zctb'].jsFileUrl, function () {
            initContent();
            if (zcgl_json_common['zctb'].callBack) {
                zcgl_json_common['zctb'].callBack();
            }
        });
    });
    function initContent() {
        Ext.create('Ext.panel.Panel',{
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zcgl_json_common['zctb'].items[zcgl_json_common['zctb'].defautItems]
                }
            ],
            items: zcgl_json_common['zctb'].items_content()
        });
    }


</script>
</body>
</html>
