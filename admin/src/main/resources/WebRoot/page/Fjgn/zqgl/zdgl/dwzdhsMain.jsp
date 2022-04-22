<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>单位转贷回收</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        .grid-cell {
            background-color: #ffe850;
        }

        .grid-cell-unedit {
            background-color: #E6E6E6;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    // 获取session 数据
    var userName = '${sessionScope.USERNAME}';  // 获取用户名称
    var userCode = '${sessionScope.USERCODE}';  // 获取用户编码
    var AD_NAME = '${sessionScope.ADNAME}';  // 获取地区名称

    // 获取URL参数
 /*   var wf_id = getQueryParam("wf_id"); // 当前工作流流程id
    var node_code = getQueryParam("node_code"); // 当前工作流节点id
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    // 自定义全局变量
    var button_name = '';//当前操作按钮名称text
    var SYS_IS_QEHBFX = '';//系统参数是否支持全额承担本息
    var IS_CREATEJH_BY_AUDIT = '0';  //转贷回收 自动确认 系统开关
    var DF_END_DATE_TEMP = null;
    var DF_START_DATE_TEMP = null;
    /**
     * 通用配置json
     */
    var dwzdhs_json_common = {
        100233: { // wf_id：债券转贷及还款管理
            1: { // node_code：自治区债券转贷录入
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '录入',
                            name: 'btn_add',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                window_select.show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_upd',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                var recordStore = records[0].getData();
                                DF_END_DATE_TEMP = recordStore.DF_END_DATE ;
                                DF_START_DATE_TEMP = recordStore.DF_START_DATE;
                                recordStore.KHS_AMT = recordStore.KHS_AMT + recordStore.HS_AMT;
                                recordStore.KHS_XZ_AMT = recordStore.KHS_XZ_AMT + recordStore.HS_XZ_AMT;
                                recordStore.KHS_ZH_AMT = recordStore.KHS_ZH_AMT + recordStore.HS_ZH_AMT;
                                recordStore.KHS_ZRZ_AMT = recordStore.KHS_ZRZ_AMT + recordStore.HS_ZRZ_AMT;
                                button_name = btn.text;
                                window_input.show();
                                window_input.window.down('form').getForm().setValues(recordStore);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_del',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                delXmzxMainGrid(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_upd',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                var recordStore = records[0].getData();
                                DF_END_DATE_TEMP = recordStore.DF_END_DATE ;
                                DF_START_DATE_TEMP = recordStore.DF_START_DATE;
                                recordStore.KHS_AMT = recordStore.KHS_AMT + recordStore.HS_AMT;
                                recordStore.KHS_XZ_AMT = recordStore.KHS_XZ_AMT + recordStore.HS_XZ_AMT;
                                recordStore.KHS_ZH_AMT = recordStore.KHS_ZH_AMT + recordStore.HS_ZH_AMT;
                                recordStore.KHS_ZRZ_AMT = recordStore.KHS_ZRZ_AMT + recordStore.HS_ZRZ_AMT;
                                button_name = btn.text;
                                window_input.show();
                                window_input.window.down('form').getForm().setValues(recordStore);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_del',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                delXmzxMainGrid(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '000': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        }
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt6)
                }
            },
            2: { // node_code：自治区债券转贷审核
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销审核',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_sh)
                }
            }
        }
    };

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        // 查询系统参数
        $.post("getParamValueAll.action", function (data) {
            SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX; //系统参数是否支持全额承担本息
            IS_CREATEJH_BY_AUDIT = data[0].IS_CREATEJH_BY_AUDIT; //转贷回收 自动确认 系统开关
            initContent();
        },"json");
    });

    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: dwzdhs_json_common[wf_id][node_code].items[WF_STATUS]
                }
            ],
            items: [
                initContentGrid()
            ]
        });
    }

    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                width: 250,
                text: "债券名称",
                renderer: function (data, cell, record) {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1] = encodeURIComponent(AD_CODE);
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                dataIndex: "ZQLB_NAME",
                type: "string",
                text: "债券类型",
                width: 130
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                text: "区划名称",
                width: 130
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                text: "单位名称",
                width: 130
            },
            {
                dataIndex: "HS_DATE",
                type: "string",
                text: "回收日期",
                width: 130
            },
            {
                dataIndex: "FXJZ_DATE",
                type: "string",
                text: "到息日期",
                width: 130
            },
            {
                dataIndex: "HSJE", text: "回收金额(元)",
                columns: [
                    {
                        dataIndex: "HS_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "HS_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "HS_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    },
                    {
                        dataIndex: "HS_ZRZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中再融资债券"
                    }
                ]
            },
            {
                dataIndex: "ZQJE", text: "债券金额(元)",
                columns: [
                    {
                        dataIndex: "ZD_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "ZD_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "ZD_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    },
                    {
                        dataIndex: "ZD_ZRZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中再融资债券"
                    }
                ]
            },
            {
                dataIndex: "IS_CONFIRM",
                width: 150,
                type: "string",
                text: "是否被确认",
                hidden: true
            },
            {
                dataIndex: "REMARK",
                width: 250,
                type: "string",
                text: "备注"
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code
            },
            dataUrl: 'getDwZdhsMainGridData.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: dwzdhs_json_common[wf_id][node_code].store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    labelAlign: 'right',
                    editable: false, //禁用编辑
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(dwzdhs_json_common[wf_id][node_code].items[WF_STATUS]);
                            reloadGrid();
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            }
        });
    }

    // 录入选择弹出框
    var window_select = {
        window: null,
        show: function (params) {
            this.window = initWindow_select(params);
            this.window.show();
        }
    };
    //创建转贷回收信息填报弹出窗口
    var window_input = {
        window: null,
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
    };

    /**
     * 初始化债券选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '债券转贷信息', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'anchor',
            maximizable: true,//最大最小化
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_grid(params)],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                            return;
                        }
                        if (records[0].get('IS_ON_ROAD') == 1) {
                            Ext.MessageBox.alert('提示', '该笔转贷已存在回收记录，请完成回收后再尝试！');
                            return;
                        }
                        var record = records[0].getData();
                        DF_END_DATE_TEMP = record.DF_END_DATE;
                        DF_START_DATE_TEMP = record.DF_START_DATE;
                        window_input.show();
                        window_input.window.down('form').getForm().setValues(record);
                        btn.up('window').close();
                    }
                },
                {
                    text: '关闭',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }

    /**
     * 初始化债券选择弹出框表格
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "width": 300,
                "text": "债券id",
                hidden: true
            },
            {
                "dataIndex": "AD_CODE",
                "type": "string",
                "width": 300,
                "text": "区划编码",
                hidden: true
            },
            {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 300,
                "text": "债券名称",
                "hrefType": "combo",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1] = encodeURIComponent(AD_CODE);
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                "dataIndex": "ZQLB_NAME",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 100
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                text: "区划名称",
                width: 130
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                text: "单位名称",
                width: 130
            },
            {
                "dataIndex": "IS_ON_ROAD",
                "type": "string",
                "text": "是否存在在途数据",
                hidden: true
            },
            {
                "dataIndex": "KHSJE", "text": "剩余可回收金额(元)",
                columns:
                    [
                        {
                            "dataIndex": "KHS_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "合计"
                        },
                        {
                            "dataIndex": "KHS_XZ_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中新增债券"
                        },
                        {
                            "dataIndex": "KHS_ZH_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中置换债券"
                        },
                        {
                            "dataIndex": "KHS_ZRZ_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中再融资债券"
                        }
                    ]
            },

            {
                "dataIndex": "ZQJE", "text": "债券金额(元)",
                columns:
                    [
                        {
                            "dataIndex": "ZD_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "合计"
                        },
                        {
                            "dataIndex": "ZD_XZ_AMT",
                            "width": 120,
                            "type": "float",
                            "align": 'right',
                            "text": "其中新增债券"
                        },
                        {
                            "dataIndex": "ZD_ZH_AMT",
                            "width": 120,
                            "type": "float",
                            "align": 'right',
                            "text": "其中置换债券"
                        },
                        {
                            "dataIndex": "ZD_ZRZ_AMT",
                            "width": 120,
                            "type": "float",
                            "align": 'right',
                            "text": "其中再融资债券"
                        }
                    ]
            },
            {
                dataIndex: "BJZC", text: "本级支出金额(元)", hidden: true,
                columns: [
                    {
                        dataIndex: "BJZC_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "BJZC_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "BJZC_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    },
                    {
                        dataIndex: "BJZC_ZRZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中再融资债券"
                    }
                ]
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'grid_select',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            checkBox: true,
            border: false,
            height: '100%',
            width: '100%',
            anchor: '100% 0',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            tbar: [
                {
                    xtype: "combobox",
                    name: "QX_YEAR",
                    store: DebtEleStore(json_debt_year),
                    displayField: "name",
                    valueField: "id",
                    value: new Date().getFullYear(),
                    fieldLabel: '发行年度',
                    editable: false, //禁用编辑
                    labelWidth: 100,
                    width: 220,
                    labelAlign: 'right'
                },
                {
                    xtype: "textfield",
                    name: "ZQ_NAME",
                    fieldLabel: '债券名称',
                    allowBlank: true,
                    labelWidth: 70,
                    width: 260,
                    labelAlign: 'right',
                    editable: true,
                    enableKeyEvents: true,
                    listeners: {
                        'keydown': function (self, e) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                var win = self.up('window');
                                var ZQMC = win.down('textfield[name="ZQ_NAME"]').getValue();
                                //刷新表格数据lur
                                var store = self.up('window').down('grid').getStore();
                                store.getProxy().extraParams.ZQ_NAME = ZQMC;
                                store.loadPage(1);
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var keyValue = Ext.ComponentQuery.query('textfield[name="ZQ_NAME"]')[0].value;
                        var QX_YEAR = Ext.ComponentQuery.query('combobox[name="QX_YEAR"]')[0].value;
                        btn.up('grid').getStore().getProxy().extraParams["ZQ_NAME"] = keyValue;
                        btn.up('grid').getStore().getProxy().extraParams["QX_YEAR"] = QX_YEAR;
                        btn.up('grid').getStore().loadPage(1);
                    }
                }
            ],
            tbarHeight: 50,
            params: {
                QX_YEAR: new Date().getFullYear()
            },
            dataUrl: 'getDwZdhsZdxxGridData.action'
        });
    }

    /**
     * 初始化债券转贷回收弹出窗口
     */
    function initWindow_input() {
        return Ext.create('Ext.window.Window', {
            title: '转贷回收', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: initWindow_input_contentForm(),
            buttons: [
                {
                    text: '利息测算',
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        var HS_AMT=form.down('numberFieldFormat[name="HS_AMT"]').getValue();
                        $.post("/calculateZdhsLx.action", {
                            zdhsForm:encode64('[' + Ext.util.JSON.encode(form.getValues()) + ']'),
                        }, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                return;
                            }else{
                                var lx=data.List[0].LX;
                                form.down('numberFieldFormat[name="HS_LX"]').setValue(lx);
                            }
                        }, "json");
                    }
                },
                {
                    text: '保存',
                    handler: function (btn) {
                        submitXmjdfb(btn);
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }

    /**
     * 初始化债券转贷回收表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'anchor',
            defaults: {
                margin: '5 5 5 5'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .333,
                        readOnly: true,
                        labelWidth: 160//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            fieldLabel: '区划编码',
                            name: "AD_CODE",
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债券ID',
                            name: "ZQ_ID",
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '所属区划',
                            name: "BELONG_AD",
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '当前区划',
                            name: "AD_NAME",
                            editable: false,//禁用编辑
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '所属单位ID',
                            name: "AG_ID",
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '所属单位编码',
                            name: "AG_CODE",
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '当前单位',
                            name: "AG_NAME",
                            editable: false,//禁用编辑
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债券名称',
                            name: "ZQ_NAME",
                            editable: false,//禁用编辑
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '票面利率',
                            name: "PM_RATE",
                            editable: false,//禁用编辑
                            readOnly: true,
                            hidden: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债券类型',
                            name: "ZQLB_NAME",
                            editable: false,//禁用编辑
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_AMT",
                            fieldLabel: '债券金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_XZ_AMT",
                            fieldLabel: '其中新增债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_ZH_AMT",
                            fieldLabel: '其中置换债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_ZRZ_AMT",
                            fieldLabel: '其中再融资债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            name: "QX_DATE",
                            fieldLabel: '起息日',
                            editable: false,//禁用编辑
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '付息周期',
                            name: "FXZQ_NAME",
                            editable: false,//禁用编辑
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    anchor: '100%',
                    margin: '5 0 5 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .333,
                        labelWidth: 160,//控件默认标签宽度
                        allowBlank: true
                    },
                    items: [
                        {
                            xtype: "numberFieldFormat",
                            name: "BJZC_AMT",
                            fieldLabel: '本级支出金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            hidden: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "BJZC_XZ_AMT",
                            fieldLabel: '其中新增债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            hidden: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "BJZC_ZH_AMT",
                            fieldLabel: '其中置换债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            hidden: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "BJZC_ZRZ_AMT",
                            fieldLabel: '其中再融资债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            hidden: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KHS_AMT",
                            fieldLabel: '剩余可回收金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KHS_XZ_AMT",
                            fieldLabel: '其中新增债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            readOnly: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KHS_ZH_AMT",
                            fieldLabel: '其中置换债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            readOnly: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KHS_ZRZ_AMT",
                            fieldLabel: '其中再融资债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            readOnly: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            fieldStyle: 'background:#E6E6E6'
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    anchor: '100%',
                    margin: '5 0 5 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .333,
                        labelWidth: 160//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "numberFieldFormat",
                            name: "HS_AMT",
                            fieldLabel: '回收金额(元)',
                            emptyText: '0.00',
                            value: 0,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "HS_XZ_AMT",
                            fieldLabel: '<span class="required">✶</span>其中新增债券金额',
                            emptyText: '0.00',
                            value: 0,
                            hideTrigger: true,
                            allowBlank: false,
                            minValue: 0,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(newValue) || newValue == null) {
                                        me.setValue(0.00);
                                        newValue = 0.00;
                                    }
                                    var hs_zh_amt = me.up('form').down('numberFieldFormat[name="HS_ZH_AMT"]').getValue();
                                    var hs_zrz_amt = me.up('form').down('numberFieldFormat[name="HS_ZRZ_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="HS_AMT"]').setValue(hs_zh_amt + newValue + hs_zrz_amt);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "HS_ZH_AMT",
                            fieldLabel: '<span class="required">✶</span>其中置换债券金额',
                            emptyText: '0.00',
                            value: 0,
                            hideTrigger: true,
                            allowBlank: false,
                            minValue: 0,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(newValue)||newValue == null) {
                                        me.setValue(0.00);
                                        newValue = 0.00;
                                    }
                                    var hs_xz_amt = me.up('form').down('numberFieldFormat[name="HS_XZ_AMT"]').getValue();
                                    var hs_zrz_amt = me.up('form').down('numberFieldFormat[name="HS_ZRZ_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="HS_AMT"]').setValue(hs_xz_amt + newValue + hs_zrz_amt);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "HS_ZRZ_AMT",
                            fieldLabel: '<span class="required">✶</span>其中再融资债券金额',
                            emptyText: '0.00',
                            value: 0,
                            hideTrigger: true,
                            allowBlank: false,
                            minValue: 0,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(newValue)||newValue == null) {
                                        me.setValue(0.00);
                                        newValue = 0.00;
                                    }
                                    var hs_xz_amt = me.up('form').down('numberFieldFormat[name="HS_XZ_AMT"]').getValue();
                                    var hs_zh_amt = me.up('form').down('numberFieldFormat[name="HS_ZH_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="HS_AMT"]').setValue(hs_xz_amt + newValue + hs_zh_amt);
                                }
                            }
                        },
                        {
                            xtype: "datefield",
                            name: "FXJZ_DATE",
                            fieldLabel: '<span class="required">✶</span>付息截止日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择付息截止日期',
                            value: DF_START_DATE_TEMP,
                            maxValue: DF_END_DATE_TEMP,
                            minValue: DF_START_DATE_TEMP
                        },
                        {
                            xtype: "datefield",
                            name: "HS_DATE",
                            fieldLabel: '<span class="required">✶</span>回收日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择回收日期',
                            value: new Date()
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "HS_LX",
                            fieldLabel: '回收利息(元)',
                            emptyText: '0.0000',
                            value: 0,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle:'background:#E6E6E6'
                        }
                    ]
                },
                {
                    fieldLabel: '备注', xtype: "textfield", name: 'REMARK',
                    anchor: '100%',
                    labelWidth: 160,
                    margin: '5 10 5 10'
                }
            ]
        });
    }


    /**
     * 提交基本情况数据
     */
    function submitXmjdfb(btn) {
        var form = btn.up('window').down('form');
        if (form.down('numberFieldFormat[name="HS_XZ_AMT"]').getValue() > form.down('numberFieldFormat[name="KHS_XZ_AMT"]').getValue() ||
            form.down('numberFieldFormat[name="HS_ZH_AMT"]').getValue() > form.down('numberFieldFormat[name="KHS_ZH_AMT"]').getValue()||
            form.down('numberFieldFormat[name="HS_ZRZ_AMT"]').getValue() > form.down('numberFieldFormat[name="KHS_ZRZ_AMT"]').getValue()) {
            Ext.MessageBox.alert('提示', '回收金额超过可回收金额');
            return;
        }
        if (form.down('numberFieldFormat[name="HS_AMT"]').getValue() == 0) {
            Ext.MessageBox.alert('提示', '请填写回收金额');
            return;
        }
        var parameters = {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name
        };
        if (button_name == '修改') {
            var records = DSYGrid.getGrid('contentGrid').getSelection();
            parameters.DWZDHS_ID = records[0].get('DWZDHS_ID');
        }
        if (form.isValid()) {
            btn.setDisabled(true); //避免网络或操作造成错误数据，按钮置为不可点击
            //保存表单数据及明细数据
            form.submit({
                //设置表单提交的url
                url: 'saveDwZdhsData.action',
                params: parameters,
                success: function (form, action) {
                    Ext.toast({
                        html: '保存成功！',
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    //关闭弹出框
                    btn.up("window").close();
                    reloadGrid();
                },
                failure: function (form, action) {
                    var result = Ext.util.JSON.decode(action.response.responseText);
                    Ext.MessageBox.alert('提示', '保存失败!' + result ? result.message : '无返回响应');
                    btn.setDisabled(false);
                }
            });
        }
    }

    /**
     * 删除主表格信息
     */
    function delXmzxMainGrid(btn) {
        // 检验是否选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                var ids = new Array();
                var btn_name = btn.name;
                var btn_text = btn.text;
                for (var k = 0; k < records.length; k++) {
                    var dwzdhs_id = records[k].get("DWZDHS_ID");
                    ids.push(dwzdhs_id);
                }

                $.post("deleteDwZdhsData.action", {
                    ids: Ext.util.JSON.encode(ids),
                    btn_name: btn_name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    wf_status: WF_STATUS
                }, function (data_response) {
                    data_response = $.parseJSON(data_response);
                    if (data_response.success) {
                        Ext.toast({
                            html: btn_text + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        reloadGrid();
                    } else {
                        Ext.toast({
                            html: btn_text + "失败！" + data_response.message,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                });
            }
        });
    }

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("DWZDHS_ID"));
        }
        button_name = btn.text;
        if (button_name == '送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateDWZdhsNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text,
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/updateDWZdhsNode.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids,
                            IS_CREATEJH_BY_AUDIT: IS_CREATEJH_BY_AUDIT
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            }
                            //刷新表格
                            reloadGrid();
                        }, "json");
                    }
                }
            });
        }
    }

    /**
     * 创建填写意见对话框
     */
    function initWindow_opinion(config) {
        var default_config = {
            closeAction: 'destroy',
            title: null,
            buttons: Ext.MessageBox.OKCANCEL,
            width: 350,
            value: '同意',
            animateTarget: null,
            fn: null
        };
        $.extend(default_config, config);
        return Ext.create('Ext.window.MessageBox', {
            closeAction: default_config.closeAction
        }).show({
            multiline: true,
            value: default_config.value,
            width: default_config.width,
            title: default_config.title,
            animateTarget: default_config.animateTarget,
            buttons: default_config.buttons,
            fn: default_config.fn
        });
    }

    /**
     * 操作日志查询
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var contentGrid_ID = records[0].get("DWZDHS_ID");
            fuc_getWorkFlowLog(contentGrid_ID);
        }
    }

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            WF_STATUS: WF_STATUS
        };
        //刷新
        store.loadPage(1);
    }

</script>
</body>
</html>
