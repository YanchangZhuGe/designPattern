<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>绩效目标一户式</title>
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
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/page/debt/jxgl/jxmbgl/xzzqjxmb.js"></script>
<script type="text/javascript">
    var XM_ID = "${fns:getParamValue('XM_ID')}";// 项目ID
    var MB_ID = "${fns:getParamValue('MB_ID')}";// 目标ID
    var is_fxjh;
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
            items: initWindow_xmjxmbtb_contentForm()
        });
    }

    /**
     * 初始化布局
     * @returns {Ext.form.Panel}
     */
    function initWindow_xmjxmbtb_contentForm() {
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
                initWindow_xmjxmbtb_contentForm_tab()
            ]
        });
    }

    /**
     * Panel布局
     * @returns {Ext.form.Panel}
     */
    function initWindow_xmjxmbtb_contentForm_tab() {
        var zqxxtbPanel = Ext.create('Ext.form.Panel', {
            anchor: '100% -17',
            border: false,
            title: '年度绩效目标填报信息',
            itemId: 'jxmbYhsPanel',
            autoScroll: true,
            items: initWindow_contentForm_tab_jxmb_yhs(XM_ID, MB_ID)
        });
        return zqxxtbPanel;
    }
</script>
</body>
</html>
