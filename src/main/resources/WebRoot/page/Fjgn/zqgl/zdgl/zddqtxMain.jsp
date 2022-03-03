<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>转贷到期提醒主界面</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>

</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    /*var wf_id = getUrlParam("wf_id");//当前流程id
    var node_code = getUrlParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';//当前操作按钮名称
    /*var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    //全局变量
    //提前获取以下store，弹出框中使用，表格中使用
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        items: {
            '001': [
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
            WF_STATUS: DebtEleStore(json_debt_zt1)
        }
    };
    //创建转贷信息选择弹出窗口
    var window_select = {
        window: null,
        show: function (params) {
            this.window = initWindow_select(params);
            this.window.show();
        }
    };
    //创建转贷信息填报弹出窗口
    var window_input = {
        window: null,
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
    };
    /**
     * 通用函数：获取url中的参数
     */
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }

    /**
     * 页面初始化
     */
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
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zdhk_json_common.items[WF_STATUS]
                }
            ],
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer',width: 35},
            {
                dataIndex: "ZQ_CODE",
                type: "string",
                text: "债券编码",
                width: 130
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                width: 250,
                text: "债券名称"
            },
            {
                dataIndex: "ZQQX_NAME",
                width: 100,
                type: "string",
                text: "债券期限"
            },
            {
                dataIndex: "ZQLB_NAME",
                type: "string",
                text: "债券类型",
                width: 130
            },
            {
                dataIndex: "FX_AMT",
                width: 150,
                type: "float",
                text: "债券金额（元）"
            },
            {
                dataIndex: "ZD_DATE",
                width: 100,
                type: "string",
                text: "转贷日期"
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额（元）"
            },
            {
                dataIndex: "XZ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额"
            },
            {
                dataIndex: "ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额"
            },
            {
                dataIndex: "TQHK_DAYS",
                width: 150,
                type: "int",
                text: "提前还款付息天数"
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
                node_code: node_code,
                SET_YEAR: new Date().getFullYear()
            },
            dataUrl: 'getZdglMainGridData.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common.store['WF_STATUS'],
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
                            toolbar.add(zdhk_json_common.items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStore(getYearList()),
                    displayField: "name",
                    valueField: "id",
                    value: new Date().getFullYear(),
                    fieldLabel: '年度',
                    editable: false, //禁用编辑
                    labelWidth: 40,
                    width: 150,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 180,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid(callback) {
        var headerJson = [
            {xtype: 'rownumberer',width: 35},
            {
                dataIndex: "ZD_DETAIL_NO",
                type: "string",
                text: "转贷明细编码",
                width: 150
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                width: 250,
                text: "转贷区域"
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额（元）"
            },
            {
                dataIndex: "XZ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额"
            },
            {
                dataIndex: "ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额"
            },
            {
                dataIndex: "ZDXY_NO",
                width: 150,
                type: "string",
                text: "转贷协议号"
            },
            {
                dataIndex: "REMARK",
                width: 150,
                type: "string",
                text: "备注"
            }
        ];
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: 'getZdglDtlGridData.action'
        };
        if (zdhk_json_common.item_content_detailgrid_config) {
            config = $.extend(false, config, zdhk_json_common.item_content_detailgrid_config);
        }
        var grid = simplyGrid.create(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }
    /**
     * 初始化转贷明细选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '转贷明细选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
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
                        //弹出填报页面，并写入债券信息
                        window_input.show();
                        window_input.window.down('form').getForm().setValues(records[0].getData());
                        //刷新填报弹出中转贷明细表获取转贷计划
                        var store = window_input.window.down('form').down('grid#zqzd_grid').getStore();
                        store.getProxy().extraParams["ZQLB_CODE"] = records[0].get('ZQLB_CODE');
                        store.getProxy().extraParams["ZQ_PC_ID"] = records[0].get('ZQ_PC_ID');
                        store.getProxy().extraParams["FXFS_CODE"] = records[0].get('FXFS_CODE');
                        store.load();
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
     * 初始化转贷明细选择弹出框表格
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer',width: 35},
            {
                dataIndex: "ZD_DETAIL_NO",
                type: "string",
                text: "转贷明细编码",
                width: 150
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                width: 250,
                text: "转贷区域"
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额（元）"
            },
            {
                dataIndex: "XZ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额"
            },
            {
                dataIndex: "ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额"
            },
            {
                dataIndex: "ZDXY_NO",
                width: 150,
                type: "string",
                text: "转贷协议号"
            },
            {
                dataIndex: "REMARK",
                width: 150,
                type: "string",
                text: "备注"
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
            flex: 1,
            tbar: [
                {
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStore(json_debt_year),
                    displayField: "name",
                    valueField: "id",
                    value: new Date().getFullYear(),
                    fieldLabel: '债券发行年度',
                    editable: false, //禁用编辑
                    labelWidth: 100,
                    width: 250,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            ],
            pageConfig: {
                enablePage: false
            },
            tbarHeight: 50,
            params: {
                SET_YEAR: new Date().getFullYear()
            },
            dataUrl: 'getZqxxGridData.action'
        });
    }
    /**
     * 初始化债券转贷弹出窗口
     */
    function initWindow_input() {
        return Ext.create('Ext.window.Window', {
            title: '债券转贷', // 窗口标题
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
                    text: '保存',
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        //获取单据明细数组
                        var recordArray = [];
                        if (form.down('grid').getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '请填写转贷明细记录！');
                            return false;
                        }
                        /*var message_error = null;
                         form.down('grid').getStore().each(function (record) {
                         if (!record.get('APPLY_AMOUNT') || record.get('APPLY_AMOUNT') == null || record.get('APPLY_AMOUNT') <= 0) {
                         message_error = '当年申请金额不能为空';
                         return false;
                         }
                         if (!record.get('GBIW_ID') || record.get('GBIW_ID') == null) {
                         message_error = '发行方式不能为空';
                         return false;
                         }
                         recordArray.push(record.getData());
                         });
                         if (message_error != null && message_error != '') {
                         Ext.Msg.alert('提示', message_error);
                         return false;
                         }*/
                        var parameters = {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            detailList: Ext.util.JSON.encode(recordArray)
                        };
                        if (button_name == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.ID = records[0].get('ZD_ID');
                        }
                        if (form.isValid()) {
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveZqxmZhzqSbGrid.action',
                                params: parameters,
                                success: function (form, action) {
                                    //关闭弹出框
                                    btn.up("window").close();
                                    //提示保存成功
                                    Ext.toast({
                                        html: '<div style="text-align: center;">保存成功!</div>',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    Ext.Msg.alert('提示', "保存失败！" + action.result ? action.result.message : '无返回响应');
                                }
                            });
                        }
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
     * 初始化债券转贷表单
     */
    function initWindow_input_contentForm() {
        try {
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
                            //columnWidth: .3,
                            width: 280,
                            readOnly: true,
                            labelWidth: 120//控件默认标签宽度
                        },
                        items: [
                            {
                                xtype: "textfield",
                                fieldLabel: '债券ID',
                                disabled: false,
                                name: "ZQ_ID",
                                hidden: true,
                                editable: false//禁用编辑
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '明细ID',
                                disabled: false,
                                name: "ZD_DETAIL_ID",
                                hidden: true,
                                editable: false//禁用编辑
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '债券编码',
                                name: "ZQ_CODE",
                                editable: false//禁用编辑
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '债券名称',
                                name: "ZQ_NAME",
                                editable: false//禁用编辑
                            },
                            {
                                xtype: "combobox",
                                name: "ZQQX_ID",
                                store: DebtEleStoreDB("DEBT_ZQQX"),
                                displayField: "name",
                                valueField: "id",
                                fieldLabel: '债券期限',
                                editable: false,
                                readOnly: true

                            },
                            {
                                xtype: "numberfield",
                                name: "FX_AMT",
                                fieldLabel: '债券总额（元）',
                                emptyText: '0.00',
                                hideTrigger: true,
                                mouseWheelEnabled: true,
                                plugins: {ptype: 'fieldStylePlugin'}
                            },
                            {
                                xtype: "numberfield",
                                name: "PM_RATE",
                                fieldLabel: '票面利率（%）',
                                emptyText: '0.000000',
                                mouseWheelEnabled: true,
                                decimalPrecision: 6,
                                hideTrigger: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            },
                            {
                                xtype: "datefield",
                                name: "FX_START_DATE",
                                fieldLabel: '发行日',
                                format: 'Y-m-d',
                                readOnly: true
                            },
                            {
                                xtype: "datefield",
                                name: "QX_DATE",
                                fieldLabel: '起息日',
                                format: 'Y-m-d',
                                readOnly: true
                            },
                            {
                                xtype: "datefield",
                                name: "DQDF_DATE",
                                fieldLabel: '到期日',
                                format: 'Y-m-d',
                                readOnly: true
                            },
                            {
                                xtype: "combobox",
                                name: "FXZQ_ID",
                                store: DebtEleStore(json_debt_fxzq),
                                displayField: "name",
                                valueField: "id",
                                fieldLabel: '付息方式',
                                editable: false,
                                readOnly: true
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
                            //columnWidth: .3,
                            width: 280,
                            labelWidth: 120,//控件默认标签宽度
                            allowBlank: true
                        },
                        items: [
                            {
                                xtype: "datefield",
                                name: "INPUT_ZD_DATE",
                                fieldLabel: '<span class="required">✶</span>转贷日期',
                                allowBlank: false,
                                format: 'Y-m-d',
                                blankText: '请选择转贷日期',
                                value: new Date()
                            },
                            {
                                xtype: "numberfield",
                                name: "TQHK_DAYS",
                                fieldLabel: '提前还款天数',
                                value: '0',
                                allowDecimals: false,
                                hideTrigger: true,
                                mouseWheelEnabled: true,
                                allowBlank: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            },
                            {
                                xtype: "numberfield",
                                name: "ZNJ_RATE",
                                fieldLabel: '滞纳金率',
                                emptyText: '0.00',
                                minValue: 0,
                                mouseWheelEnabled: true,
                                decimalPrecision: 6,
                                hideTrigger: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            },
                            {
                                xtype: "numberfield",
                                name: "INPUT_ZD_AMT",
                                fieldLabel: '<span class="required">✶</span>转贷总金额（元）',
                                emptyText: '0.00',
                                hideTrigger: true,
                                mouseWheelEnabled: true,
                                allowBlank: false,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                                readOnly: true
                            },
                            {
                                xtype: "numberfield",
                                name: "INPUT_XZ_AMT",
                                fieldLabel: '其中新增债券金额',
                                emptyText: '0.00',
                                decimalPrecision: 6,
                                hideTrigger: true,
                                mouseWheelEnabled: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                                readOnly: true
                            },
                            {
                                xtype: "numberfield",
                                name: "INPUT_ZH_AMT",
                                fieldLabel: '置换债券金额',
                                emptyText: '0.00',
                                decimalPrecision: 6,
                                hideTrigger: true,
                                mouseWheelEnabled: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                                readOnly: true
                            }
                        ]
                    },
                    {
                        xtype: 'fieldset',
                        columnWidth: 1,
                        title: '转贷明细',
                        anchor: '100% -190',
                        collapsible: true,
                        layout: 'fit',
                        items: [initWindow_input_contentForm_grid()]
                    }
                ]
            });
        }
        catch (err) {
            // 当出现异常时，打印控制台异常
        }
    }
    /**
     * 初始化债券转贷表单中转贷明细信息表格
     */
    function initWindow_input_contentForm_grid() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {dataIndex: "AD_CODE", type: "string", text: "转贷区域", width: 150},
                {
                    dataIndex: "ZD_AMT", type: "float", text: "转贷金额", width: 180,
                    renderer: function (value, cellmeta, record) {
                        value = record.get('XZ_AMT') + record.get('ZH_AMT');
                        return value;
                    }
                },
                {dataIndex: "ZD_DETAIL_NO", type: "string", text: "转贷明细编码", width: 180, editor: 'textfield'},
                {
                    dataIndex: "XZ_AMT", type: "float", text: "新增债券金额", width: 180,
                    editor: {
                        xtype: "numberfield",
                        emptyText: '0.00',
                        hideTrigger: true,
                        mouseWheelEnabled: true,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    }
                },
                {
                    dataIndex: "ZH_AMT", type: "float", text: "置换债券金额", width: 180,
                    editor: {
                        xtype: "numberfield",
                        emptyText: '0.00',
                        hideTrigger: true,
                        mouseWheelEnabled: true,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    }
                },
                {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150, editor: 'textfield'},
                {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
            ];
            var simplyGrid = new DSYGridV2();
            var grid = simplyGrid.create({
                itemId: 'zqzd_grid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                autoLoad: false,
                dataUrl: 'getPcjhGridData.action',
                border: true,
                height: '100%',
                width: '100%',
                plugins: [
                    {
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        pluginId: 'zqzd_grid_plugin_cell',
                        clicksToMoveEditor: 1,
                        listeners: {
                            'edit': function (editor, e) {
                                //e.record.commit();
                            }
                        }
                    }
                ],
                pageConfig: {
                    enablePage: false
                },
                listeners: {
                    itemclick: function (self, record) {
                        //刷新明细表
                        DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
                        DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                    },
                    validateedit: function (editor, context) {
                        return checkEditorGrid(editor, context);
                    }
                }
            });
            grid.getStore().on('endupdate', function () {
                //计算录入窗口转贷总金额
                var self = grid.getStore();
                var input_zd_amt = 0;
                var input_xz_amt = 0;
                var input_zh_amt = 0;
                self.each(function (record) {
                    record.set('ZD_AMT', record.get('XZ_AMT') + record.get('ZH_AMT'));
                    input_zd_amt += record.get('ZD_AMT');
                    input_xz_amt += record.get('XZ_AMT');
                    input_zh_amt += record.get('ZH_AMT');
                });
                grid.up('window').down('form').down('numberfield[name="ZD_AMT"]').setValue(input_zd_amt);
                grid.up('window').down('form').down('numberfield[name="XZ_AMT"]').setValue(input_xz_amt);
                grid.up('window').down('form').down('numberfield[name="ZH_AMT"]').setValue(input_zh_amt);
            });
            return grid;
        }
        catch (err) {
            // 当出现异常时，打印控制台异常
        }
    }
    /**
     * validateedit 表格编辑插件校验
     */
    function checkEditorGrid(editor, context) {
        //校验当年申请金额
        /*if (context.field == 'APPLY_AMOUNT') {
         //新插入的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前到期金额-已申请金额（汇总）
         //已经存在的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前数据库中计算得到的：到期金额-已申请金额（汇总）+当年申请金额
         //故：当年申请金额<=当年申请金额最大值APPLY_AMOUNT_MAX
         if (context.value > context.record.get('APPLY_AMOUNT_MAX')) {
         Ext.Msg.alert('提示', '当前申请金额不能超过剩余申请金额');
         return false;
         }
         }*/
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
            ids.push(records[i].get("ZD_ID"));
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            value: btn.name == 'up' ? null : '同意',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateFxdfZqZdNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ZD_IDS: ids
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
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }, "json");
                }
            }
        });
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
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("ZD_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
</script>
</body>
</html>