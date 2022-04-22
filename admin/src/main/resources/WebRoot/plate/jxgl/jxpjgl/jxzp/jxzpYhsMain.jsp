<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>绩效自评一户式</title>
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
    </style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/page/debt/jxgl/jxpjgl/jxzp/jxzptbPanel.js"></script>
<script type="text/javascript">
    var XM_ID = "${fns:getParamValue('XM_ID')}";// 项目ID
    var ZP_ID = "${fns:getParamValue('ZP_ID')}";// 自评ID
    var BUTTON_TEXT = '';// 控制是否可编辑
    /*年度过滤条件*/
    var json_debt_year = [
        {"id": "2020", "code": "2020", "name": "2020年"},
        {"id": "2021", "code": "2021", "name": "2021年"},
        {"id": "2022", "code": "2022", "name": "2022年"},
        {"id": "2023", "code": "2023", "name": "2023年"},
        {"id": "2024", "code": "2024", "name": "2024年"},
        {"id": "2025", "code": "2025", "name": "2025年"},
        {"id": "2026", "code": "2026", "name": "2026年"},
        {"id": "2027", "code": "2027", "name": "2027年"},
        {"id": "2028", "code": "2028", "name": "2028年"},
        {"id": "2029", "code": "2029", "name": "2029年"},
        {"id": "2030", "code": "2030", "name": "2030年"}
    ];
    /*评分等级*/
    var json_debt_pfdj = [
        {"id": "1", "code": "1", "name": "优"},
        {"id": "2", "code": "2", "name": "良"},
        {"id": "3", "code": "3", "name": "中"},
        {"id": "4", "code": "4", "name": "差"}
    ];
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
    });

    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'hbox',
                align: 'middle',
                pack: 'center'
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            items: [initWindow_xmjxzptb_contentForm()]
        });
        loadInfo(ZP_ID);
    }

    /**
     * 初始化布局
     * @returns {Ext.form.Panel}
     */
    function initWindow_xmjxzptb_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '97%',
            height: '100%',
            layout: 'anchor',
            border: false,
            defaults: {
                anchor: '100%',
                margin: '0 0 2 0'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'toolbar',
                    anchor: '100%',
                    width: '90%',
                    layout: 'hbox',
                    border: false,
                    items: []
                },
                initWindow_xmjxzptb_contentForm_tab()
            ]
        });
    }

    /**
     * Panel布局
     * @returns {Ext.form.Panel}
     */
    function initWindow_xmjxzptb_contentForm_tab() {
        var zqxxtbPanel = Ext.create('Ext.form.Panel', {
            anchor: '100% -17',
            border: false,
            title: '项目绩效自评',
            itemId: 'jxzpYhsPanel',
            autoScroll: true,
            items: initWindow_jxzp_panel(XM_ID, BUTTON_TEXT, ZP_ID)
        });
        return zqxxtbPanel;
    }
</script>
</body>
</html>
