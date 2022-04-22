<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>债券资金支出主界面</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    /*获取登录用户*/
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");

    var editMode = 'query';//弹出框模式，可选值：insert/update/query
   /* var wf_id = getQueryParam("wf_id");//当前流程id
    var node_code = getQueryParam("node_code");//当前节点id
    var node_name = getQueryParam("node_name");//当前节点名称
    var ZC_TYPE = getQueryParam("zc_type");//支出类型：0新增债券类型 1置换债券类型*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var node_name ="${fns:getParamValue('node_name')}";
    var ZC_TYPE ="${fns:getParamValue('zc_type')}";
    var button_name = '';//当前操作按钮名称
   /* var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var title = '';
    if (ZC_TYPE == 1) {
        title = '置换';
    } else if (ZC_TYPE == 0) {
        title = '新增';
    }
    var json_zt;
    var btn_title = '';
    if (node_name == 'lr') {
        btn_title = '送审';
        json_zt = json_debt_zt0;
    } else if (node_name == 'sh') {
        btn_title = '审核';
        json_zt = json_debt_sh;
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
                    items: initItems_toolbar(node_name, WF_STATUS)
                }
            ],
            items: [
                initContentRightPanel()
            ]
        });
    }
    /**
     * 获取工具栏按钮
     */
    function initItems_toolbar(nodeName, wf_status) {
        //工具栏按钮集合
        var items_toolbar_btns = {
            search: {
                text: '查询', xtype: 'button', name: 'search', icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            insert: {
                text: '新增', xtype: 'button', name: 'insert', icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.text;
                    editMode = btn.name;
                    //发送ajax请求，获取新增主表id
                    $.post("/zqgl/getZjzcZCDCode.action", function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '获取ID失败！' + data.message);
                            return;
                        }
                        //弹出弹出框，设置ZC_ID
                        initWindow_save_zcxx({ZC_ID: data.ZC_ID, ZC_CODE: data.ZC_CODE}).show();
                    }, "json");
                }
            },
            update: {
                text: '修改', xtype: 'button', name: 'update', icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    editMode = btn.name;
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return false;
                    }
                    //弹出弹出框
                    initWindow_save_zcxx(records[0].data).show();
                }
            },
            delete_btn: {
                text: '删除', xtype: 'button', name: 'delete', icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            button_name = btn.text;
                            var ids = [];
                            for (var i in records) {
                                ids.push(records[i].get("ZC_ID"));
                            }
                            //发送ajax请求，删除数据
                            $.post("/zqgl/delZjzcData.action", {
                                ids: ids,
                                wf_id: wf_id,
                                node_code: node_code,
                                WF_STATUS: WF_STATUS,
                                button_name: button_name
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
                }
            },
            down: {
                text: btn_title, xtype: 'button', name: 'down', icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow(btn);
                }
            },
            up: {
                text: '退回', xtype: 'button', name: 'up', icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow(btn);
                }
            },
            cancel: {
                text: '撤销' + btn_title, name: 'cancel', xtype: 'button', icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow(btn);
                }
            },
            log: {
                text: '操作记录', name: 'log', xtype: 'button', icon: '/image/sysbutton/log.png',
                handler: function () {
                    oprationRecord();
                }
            }
        };
        var items_toolbar = {
            lr: {//录入
                items: {
                    '001': [
                        items_toolbar_btns.search,
                        items_toolbar_btns.insert,
                        items_toolbar_btns.update,
                        items_toolbar_btns.delete_btn,
                        items_toolbar_btns.down,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        items_toolbar_btns.cancel,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [
                        items_toolbar_btns.update,
                        items_toolbar_btns.delete_btn,
                        items_toolbar_btns.down,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            },
            sh: {//审核
                items: {
                    '001': [
                        items_toolbar_btns.search,
                        items_toolbar_btns.down,
                        items_toolbar_btns.up,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        items_toolbar_btns.search,
                        items_toolbar_btns.cancel,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            }
        };
        return items_toolbar[node_name].items[WF_STATUS] || [];
    }
    /**
     * 初始化右侧panel，放置表格
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            items: [
                initContentGrid(),
                initContentMxGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "地区", dataIndex: "AD_NAME", type: "string"},
            {text: "支出编号", dataIndex: "ZC_CODE", type: "string", width: 180},
            {text: "支出债券类型", dataIndex: "ZC_TYPE_NAME", type: "string"},
            {text: "申请日期", dataIndex: "APPLY_DATE", type: "string", width: 150},
            {text: "本次支出金额(元)", dataIndex: "SUM_ZC_AMT", type: "float", width: 180},
            {text: title + "债券总金额(元)", dataIndex: "PLAN_AMT_SUM", type: "float", width: 180},
            {text: title + "债券已支出金额(元)", dataIndex: "SUM_ZC_AMT_SUM", type: "float", width: 180}
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
                ZC_TYPE: ZC_TYPE,
                node_name: node_name
            },
            dataUrl: '/zqgl/getZjzcMainGrid.action',
            checkBox: true,
            border: false,
            height: '50%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_zt),
                    width: 110,
                    labelWidth: 30,
                    editable: false, //禁用编辑
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(initItems_toolbar(node_name, WF_STATUS));
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentMxGrid').getStore().getProxy().extraParams['ZC_ID'] = record.get('ZC_ID');
                    DSYGrid.getGrid('contentMxGrid').getStore().loadPage(1);
                },
                itemdblclick: function (self, record) {
                    editMode = 'query';
                    ZC_TYPE = record.get('ZC_TYPE');
                    initWindow_save_zcxx(record.data).show();
                }
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentMxGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 280, tdCls: 'grid-cell-unedit'},
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 80, tdCls: 'grid-cell-unedit'},
            {
                dataIndex: "PLAN_XZ_AMT", type: "float", text: "本级可支出金额(元)", width: 160,
                hidden: ZC_TYPE == 1 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }, {
                dataIndex: "SY_PLAN_XZ_AMT", type: "float", text: "剩余本级可支出金额(元)", width: 180,
                hidden: ZC_TYPE == 1 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PLAN_ZH_AMT", type: "float", text: "本级可支出金额(元)", width: 160,
                hidden: ZC_TYPE == 0 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }, {
                dataIndex: "SY_PLAN_ZH_AMT", type: "float", text: "剩余本级可支出金额(元)", width: 180,
                hidden: ZC_TYPE == 0 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "支出日期", dataIndex: "PAY_DATE", type: "string", width: 110, tdCls: 'grid-cell',
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                dataIndex: "ZC_AMT", type: "float", text: "支出金额(元)", width: 160, tdCls: 'grid-cell',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "USE_DEPT",
                "type": "string",
                "text": "资金使用部门",
                editor: {
                    xtype: 'textfield',
                },
                width: 200
            },
            {
                "dataIndex": "REMARK",
                "type": "string",
                "text": "备注",
                editor: {
                    xtype: 'textarea',
                    multiline: true
                },
                width: 300
            }
        ];
        var config = {
            itemId: 'contentMxGrid',
            flex: 1,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            autoLoad: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: '/zqgl/getZjzcDtlGridByZcid.action',
            params: {},
            listeners: {
                itemdblclick: function (self, record) {
                }
            }
        };
        var grid = DSYGrid.createGrid(config);
        return grid;
    }
    /**
     * 初始化债券支出保存弹出窗口
     */
    function initWindow_save_zcxx(record) {
        var config = {
            title: '债券支出' + button_name, // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'anchor',
            itemId: 'window_save_zcxx', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            maximizable: true,
            frame: true,
            constrain: true,
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_save_zcxx_form(record),
                {
                    xtype: 'tabpanel',
                    border: false,
                    anchor: '100% -172',
                    items: [
                        {
                            title: '支出详情',
                            layout: 'fit',
                            items: [initWindow_save_zcxx_grid(record)]
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            layout: 'fit',
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    border: false,
                                    itemId: 'window_save_zcxx_file_panel',
                                    items: [
                                        initWindow_save_zcxx_tab_upload({
                                            editable: (editMode == 'insert' || editMode == 'update'),
                                            gridId: record.ZC_ID
                                        })
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            buttons: [
                {
                    text: '保存',
                    handler: function (btn) {
                        // 检验是否有数据
                        // 获取数据
                        var grid = btn.up('window').down('grid');
                        var celledit = grid.getPlugin('window_save_zcxx_grid_plugin_cell');
                        //完成编辑
                        celledit.completeEdit();
                        var store = btn.up('window').down('grid').getStore();
                        if (store.getCount() < 1) {
                            Ext.MessageBox.alert('提示', '请新增数据');
                            return;
                        }
                        //录入数据进行验证与格式化
                        //TODO 录入数据进行验证与格式化
                        if (!checkEditorGrid(btn.up('window'))) {
                            Ext.MessageBox.alert('提示', grid_error_message);
                            return;
                        }
                        var records_add = store.getNewRecords();//新增行
                        var records_update = store.getUpdatedRecords();//修改行
                        var records_delete = store.getRemovedRecords();//修改行
                        for (var i = 0; i < records_add.length; i++) {
                            records_add[i] = records_add[i].data;
                        }
                        for (var i = 0; i < records_update.length; i++) {
                            records_update[i] = records_update[i].data;
                        }
                        for (var i = 0; i < records_delete.length; i++) {
                            records_delete[i] = records_delete[i].data;
                        }
                        var url = '/zqgl/saveZjzcData.action';
                        var params = {
                            wf_id: wf_id,
                            node_code: node_code,
                            WF_STATUS: WF_STATUS,
                            button_name: button_name,
                            ZC_TYPE: ZC_TYPE,
                            editMode: editMode,
                            listAdd: Ext.util.JSON.encode(records_add),
                            listUpdate: Ext.util.JSON.encode(records_update),
                            listDelete: Ext.util.JSON.encode(records_delete)
                        };
                        params = $.extend({}, params, btn.up('window').down('form').getValues());
                        //发送ajax请求，保存表格数据
                        $.post(url, params, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                return false;
                            } else {
                                //提示保存成功
                                Ext.toast({
                                    html: '<div style="text-align: center;">保存成功!</div>',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                //重新加载表格数据
                                reloadGrid();
                                btn.up('window').close();
                            }
                        }, "json");
                    }
                },
                {
                    text: '关闭',
                    handler: function (btn) {
                        data_zdmx = null;
                        btn.up('window').close();
                    }
                }
            ]
        };
        if (editMode == 'query') {
            delete config.buttons;
        }
        return Ext.create('Ext.window.Window', config);
    }
    /**
     * 初始化债券支出录入弹出窗口表单
     */
    function initWindow_save_zcxx_form(record) {
        var form_panel = Ext.create('Ext.form.Panel', {
            anchor: '100%',
            layout: 'column',
            record: record,
            itemId: 'window_save_zcxx_form',
            defaultType: 'displayfield',
            defaults: {
                columnWidth: .33,
                labelWidth: 130,
                margin: '5 5 5 5',
                labelAlign: 'right'
            },
            items: [
                {fieldLabel: title + "债券总额(元)", xtype: 'numberFieldFormat', name: "PLAN_AMT_SUM", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: title + "一般总金额(元)", xtype: 'numberFieldFormat', name: "PLAN_AMT_SUM_YB", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: title + "专项总金额(元)", xtype: 'numberFieldFormat', name: "PLAN_AMT_SUM_ZX", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "已支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_ZC_AMT_SUM", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "一般已支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_YB_ZC_AMT_SUM", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "专项已支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_ZX_ZC_AMT_SUM", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "未支出金额(元)", xtype: 'numberFieldFormat', name: "WZC_AMT", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "一般未支出金额(元)", xtype: 'numberFieldFormat', name: "WZC_YB_AMT", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "专项未支出金额(元)", xtype: 'numberFieldFormat', name: "WZC_ZX_AMT", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "本次支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_ZC_AMT", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "本次一般支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_YB_ZC_AMT", readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "本次专项支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_ZX_ZC_AMT", readOnly: true, fieldCls: 'form-unedit-number'},
                {
                    fieldLabel: "初始本次支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_ZC_AMT_INITIAL",
                    hidden: true, readOnly: true, fieldCls: 'form-unedit-number'
                },
                {
                    fieldLabel: "初始本次一般支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_YB_ZC_AMT_INITIAL",
                    hidden: true, readOnly: true, fieldCls: 'form-unedit-number'
                },
                {
                    fieldLabel: "初始本次专项支出金额(元)", xtype: 'numberFieldFormat', name: "SUM_ZX_ZC_AMT_INITIAL",
                    hidden: true, readOnly: true, fieldCls: 'form-unedit-number'
                },
                {fieldLabel: "支出ID", xtype: 'textfield', name: "ZC_ID", hidden: true},
                {
                    fieldLabel: "支出单编号", xtype: 'textfield', name: "ZC_CODE",
                    readOnly: true,
                    fieldCls: 'form-unedit'
                },
                {
                    fieldLabel: '<span class="required">✶</span>申请日期', xtype: 'datefield', name: "APPLY_DATE", format: 'Y-m-d',
                    readOnly: (editMode == 'query'), allowBlank: false, value: today,
                    fieldCls: (editMode == 'query' ? 'form-unedit' : 'x-form-field')
                }
            ]
        });
        //发送请求获取债券金额等数据
        $.post("/zqgl/getZjzcXzMainData.action", {ZC_TYPE: ZC_TYPE, AD_CODE: AD_CODE}, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询债券金额失败！' + data.message);
                return;
            }
            var form = Ext.ComponentQuery.query('form#window_save_zcxx_form')[0];
            var record_form = form.record;
            record_form = $.extend({}, record_form, data.data, data.form_data);
            record_form.WZC_AMT = record_form.PLAN_AMT_SUM - record_form.SUM_ZC_AMT_SUM;
            record_form.WZC_YB_AMT = record_form.PLAN_AMT_SUM_YB - record_form.SUM_YB_ZC_AMT_SUM;
            record_form.WZC_ZX_AMT = record_form.PLAN_AMT_SUM_ZX - record_form.SUM_ZX_ZC_AMT_SUM;
            if (record_form.SUM_ZC_AMT == null) {
                record_form.SUM_ZC_AMT = 0;
            }
            if (record_form.SUM_YB_ZC_AMT == null) {
                record_form.SUM_YB_ZC_AMT = 0;
            }
            if (record_form.SUM_ZX_ZC_AMT == null) {
                record_form.SUM_ZX_ZC_AMT = 0;
            }
            if (editMode == 'update') {
                record_form.SUM_ZC_AMT_INITIAL = record_form.SUM_ZC_AMT;
                record_form.SUM_YB_ZC_AMT_INITIAL = record_form.SUM_YB_ZC_AMT;
                record_form.SUM_ZX_ZC_AMT_INITIAL = record_form.SUM_ZX_ZC_AMT;
            }
            form.getForm().setValues(record_form);
        }, "json");
        return form_panel;
    }
    /**
     * 初始化债券支出保存弹出窗口表格
     */
    function initWindow_save_zcxx_grid(record) {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 280, tdCls: 'grid-cell-unedit'},
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 80, tdCls: 'grid-cell-unedit'},
            {
                dataIndex: "PLAN_XZ_AMT", type: "float", text: "本级可支出金额(元)", width: 160,
                hidden: ZC_TYPE == 1 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "SY_PLAN_XZ_AMT", type: "float", text: "剩余本级可支出金额(元)", width: 180,
                hidden: ZC_TYPE == 1 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PLAN_ZH_AMT", type: "float", text: "本级可支出金额(元)", width: 160,
                hidden: ZC_TYPE == 0 ? true : false,
                /* editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, */
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "SY_PLAN_ZH_AMT", type: "float", text: "剩余本级可支出金额(元)", width: 180,
                hidden: ZC_TYPE == 0 ? true : false,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "支出日期", dataIndex: "PAY_DATE", type: "string", width: 110, tdCls: 'grid-cell',
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                dataIndex: "ZC_AMT", type: "float", text: "支出金额(元)", width: 160, tdCls: 'grid-cell',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "USE_DEPT",
                "type": "string",
                "text": "资金使用部门",
                editor: {
                    xtype: 'textfield'
                },
                width: 200
            },
            {
                "dataIndex": "REMARK",
                "type": "string",
                "text": "备注",
                editor: {
                    xtype: 'textarea',
                    multiline: true
                },
                width: 300
            }
        ];
        var config = {
            itemId: 'window_save_zcxx_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: '/zqgl/getZjzcDtlGridByZcid.action',
            autoLoad: editMode != 'insert',
            checkBox: true,
            border: false,
            height: '100%',
            width: '100%',
            params: {
                ZC_ID: record.ZC_ID
            },
            tbar: [
                {
                    xtype: 'button',
                    text: '新增',
                    width: 80,
                    handler: function () {
                        initWindow_select_xzzq().show();
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    width: 80,
                    handler: function (btn) {
                        var grid = btn.up('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        if (sm == null || sm.length <= 0) {
                            return false;
                        }
                        grid.getPlugin('window_save_zcxx_grid_plugin_cell').cancelEdit();
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                        //重新计算支出金额总和 
                        var store = DSYGrid.getGrid('window_save_zcxx_grid').getStore();
                        var sum_yb = 0;
                        var sum_zx = 0;
                        store.each(function (record) {
                            if (record.data.ZQLB_ID == '01') {
                                sum_yb += parseFloat(record.get('ZC_AMT'));
                            } else if ((record.data.ZQLB_ID).indexOf('02') == 0) {
                                sum_zx += parseFloat(record.get('ZC_AMT'));
                            }
                        });
                        var form = DSYGrid.getGrid('window_save_zcxx_grid').up('window#window_save_zcxx').down('form');
                        form.down('numberFieldFormat[name=SUM_ZC_AMT]').setValue(sum_yb + sum_zx);
                        form.down('numberFieldFormat[name=SUM_YB_ZC_AMT]').setValue(sum_yb);
                        form.down('numberFieldFormat[name=SUM_ZX_ZC_AMT]').setValue(sum_zx);
                    }
                }
            ],
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'window_save_zcxx_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        edit: function (editor, context) {
                            if (context.field == 'ZC_AMT') {
                                //重新计算支出金额总和
                                var sum_yb = 0;
                                var sum_zx = 0;
                                context.store.each(function (record) {
                                    if (record.data.ZQLB_ID == '01') {
                                        sum_yb += parseFloat(record.get('ZC_AMT'));
                                    } else if ((record.data.ZQLB_ID).indexOf('02') == 0) {
                                        sum_zx += parseFloat(record.get('ZC_AMT'));
                                    }
                                });
                                var form = context.grid.up('window#window_save_zcxx').down('form');
                                form.down('numberFieldFormat[name=SUM_ZC_AMT]').setValue(sum_yb + sum_zx);
                                form.down('numberFieldFormat[name=SUM_YB_ZC_AMT]').setValue(sum_yb);
                                form.down('numberFieldFormat[name=SUM_ZX_ZC_AMT]').setValue(sum_zx);
                            }
                            //格式化日期
                            if (context.field == 'PAY_DATE') {
                                context.record.set('PAY_DATE', Ext.util.Format.date(context.value, 'Y-m-d'));
                            }
                        },
                        validateedit: function (editor, context) {
                        }
                    }
                }
            ]
        };
        if (editMode == 'query') {
            for (var i in headerJson) {
                delete headerJson[i].tdCls;
                delete headerJson[i].editor;
            }
            delete config.tbar;
            delete config.checkBox;
            delete config.plugins;
        }
        var grid = DSYGrid.createGrid(config);
        return grid;
    }
    /**
     * 初始化债券填报表单中页签panel的附件页签
     */
    function initWindow_save_zcxx_tab_upload(config) {
        var grid = UploadPanel.createGrid({
            busiType: null,//业务类型
            busiId: config.gridId,//业务ID
            busiProperty: '%',//业务规则
            editable: config.editable,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_save_zcxx_tab_upload_grid'
            }
        });
        //附件加载完成后计算总文件数，并写到页签上
        grid.getStore().on('load', function (self, records, successful) {
            var sum = 0;
            if (records != null) {
                for (var i = 0; i < records.length; i++) {
                    if (records[i].data.STATUS == '已上传') {
                        sum++;
                    }
                }
            }
            if (grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }
    /**
     * 初始化新增债券选择弹出窗口
     */
    function initWindow_select_xzzq() {
        return Ext.create('Ext.window.Window', {
            title: title + '债券选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.9, // 窗口高度
            itemId: 'window_select_xzzq', // 窗口标识
            layout: 'fit',
            maximizable: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_select_xzzq_grid()
            ],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                            return;
                        }
                        var store = DSYGrid.getGrid('window_save_zcxx_grid').getStore();
                        //循环生成插入数据，将数据插入到填报表格中
                        var record_datas = [];
                        for (var i = 0; i < records.length; i++) {
                            var record_data = records[i].getData();
                            if (ZC_TYPE == '0') {
                                record_data.ZC_AMT = record_data.SY_PLAN_XZ_AMT;
                            } else if (ZC_TYPE == '1') {
                                record_data.ZC_AMT = record_data.SY_PLAN_ZH_AMT;
                            }

                            delete record_data.id;
                            //如果申报主表明细中已存在该数据，不插入
                            /* var flag_exist = false;
                             store.each(function (record) {
                             if (record.get('ZQ_ID') == record_data.ZQ_ID) {
                             flag_exist = true;
                             return false;
                             }
                             });
                             if (!flag_exist) {
                             record_datas.push(record_data);
                             } */
                            record_datas.push(record_data);
                        }
                        if (record_datas.length > 0) {
                            DSYGrid.getGrid('window_save_zcxx_grid').insertData(null, record_datas);
                        }
                        //计算支出金额总和
                        var sum_yb = 0;
                        var sum_zx = 0;
                        store.each(function (record) {
                            if (record.data.ZQLB_ID == '01') {
                                sum_yb += parseFloat(record.get('ZC_AMT'));
                            } else if ((record.data.ZQLB_ID).indexOf('02') == 0) {
                                sum_zx += parseFloat(record.get('ZC_AMT'));
                            }
                        });
                        var form = DSYGrid.getGrid('window_save_zcxx_grid').up('window#window_save_zcxx').down('form');
                        form.down('numberFieldFormat[name=SUM_ZC_AMT]').setValue(sum_yb + sum_zx);
                        form.down('numberFieldFormat[name=SUM_YB_ZC_AMT]').setValue(sum_yb);
                        form.down('numberFieldFormat[name=SUM_ZX_ZC_AMT]').setValue(sum_zx);
                        btn.up('window').close();
                    }
                },
                {
                    text: '关闭',
                    handler: function (btn) {
                        data_zdmx = null;
                        btn.up('window').close();
                    }
                }
            ]
        });
    }
    /**
     * 初始化新增债券选择弹出框表格
     */
    function initWindow_select_xzzq_grid() {
        var hide = true;
        if (ZC_TYPE == '0') {
            hide = false;
        } else if (ZC_TYPE == '1') {
            hide = true;
        }
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 100},
            {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 280},
            {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 110},
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 80},
            {text: "发行日期", dataIndex: "FX_START_DATE", type: "string", width: 90},
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 85, align: 'right'},
            {
                text: "本级可支出金额(元)", dataIndex: "PLAN_XZ_AMT", type: "float", width: 150, hidden: hide, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "本级可支出金额(元)", dataIndex: "PLAN_ZH_AMT", type: "float", width: 150, hidden: !hide, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "已支出金额(元)", dataIndex: "PAY_XZ_AMT", type: "float", width: 150, hidden: hide, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "已支出金额(元)", dataIndex: "PAY_ZH_AMT", type: "float", width: 150, hidden: !hide, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "剩余本级可支出金额(元)", dataIndex: "SY_PLAN_XZ_AMT", type: "float", width: 180, hidden: hide, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "剩余本级可支出金额(元)", dataIndex: "SY_PLAN_ZH_AMT", type: "float", width: 180, hidden: !hide, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'grid_select_xzzq',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: true,
            height: '100%',
            anchor: '100% -35',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            params: {
                ZC_TYPE: ZC_TYPE,
                AD_CODE: AD_CODE
            },
            dataUrl: '/zqgl/getZjzcXzZqGrid.action'
        });
        //将form添加到表格中
        var searchTool = initWindow_select_xzzq_grid_searchTool();
        grid.addDocked(searchTool, 0);
        return grid;
    }
    /**
     * 初始化新增债券弹出框搜索区域
     */
    function initWindow_select_xzzq_grid_searchTool() {
        //初始化查询控件
        var items = [];
        items.push(
            {
                fieldLabel: '债券类型',
                xtype: "treecombobox",
                name: "ZQLB_ID",
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                displayField: "name",
                valueField: "id",
                editable: false, //禁用编辑
                labelWidth: 60,
                width: 200,
                labelAlign: 'right'
            },
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                itemId: 'window_select_xzzq_grid_searchTool_mhcx',
                width: 380,
                name: 'mhcx',
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入债券编码/债券名称',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var form = self.up('form');
                            if (form.isValid()) {
                                callBackReload(form);
                            } else {
                                Ext.Msg.alert("提示", "查询区域未通过验证！");
                            }
                        }
                    }
                }
            }
        );
        //设置查询form
        var searchTool = new DSYSearchTool();
        searchTool.setSearchToolId('searchTool_grid');
        var search_form = searchTool.create({
            items: items,
            border: true,
            bodyStyle: 'border-width:0 0 0 0;',
            dock: 'top',
            defaults: {
                labelWidth: 60,
                width: 200,
                margin: '5 5 5 5',
                labelAlign: 'right'
            }
        });
        //重新加载按钮
        search_form.remove(search_form.down('toolbar'));
        search_form.addDocked({
            xtype: 'toolbar',
            border: false,
            width: 140,
            dock: 'right',
            layout: {
                type: 'hbox',
                align: 'center',
                pack: 'start'
            },
            padding: '0 10 0 0',
            items: [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var form = btn.up('form');
                        if (form.isValid()) {
                            callBackReload(form);
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
                    }
                },
                '->', {
                    xtype: 'button',
                    text: '重置',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        var form = btn.up('form');
                        form.reset();
                    }
                }
            ]
        });
        function callBackReload(form) {
            var ZQLB_ID = form.down('treecombobox[name=ZQLB_ID]').getValue();
            var mhcx = form.down('textfield[name=mhcx]').getValue();
            var grid = form.up('grid');
            grid.getStore().getProxy().extraParams['ZQLB_ID'] = ZQLB_ID;
            grid.getStore().getProxy().extraParams['mhcx'] = mhcx;
            grid.getStore().load();
        }

        return search_form;
    }
    /**
     * 树点击节点时触发，刷新content主表格
     */
    function reloadGrid(param) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //增加查询参数
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.getProxy().extraParams["AG_CODE"] = AG_CODE;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
        //刷新明细表
        DSYGrid.getGrid('contentMxGrid').getStore().removeAll();
    }
    /**
     * 支出录入校验
     */
    function checkEditorGrid(window) {
        var flag = true;
        var sy_kzc = {};
        var form = window.down('form');
        var KZC = {};
        var YZC = {};
        //获取未支出金额
        var WZC_AMT = form.down('numberFieldFormat[name=WZC_AMT]').getValue();
        var WZC_YB_AMT = form.down('numberFieldFormat[name=WZC_YB_AMT]').getValue();
        var WZC_ZX_AMT = form.down('numberFieldFormat[name=WZC_ZX_AMT]').getValue();
        //如果是修改模式未支出金额应该加上修改前的支出金额
        if (editMode == 'update') {
            WZC_AMT = WZC_AMT + parseFloat(form.down('numberFieldFormat[name=SUM_ZC_AMT_INITIAL]').getValue());
            WZC_YB_AMT = WZC_YB_AMT + parseFloat(form.down('numberFieldFormat[name=SUM_YB_ZC_AMT_INITIAL]').getValue());
            WZC_ZX_AMT = WZC_ZX_AMT + parseFloat(form.down('numberFieldFormat[name=SUM_ZX_ZC_AMT_INITIAL]').getValue());
        }
        //获取本次支出金额
        var SUM_ZC_AMT = form.down('numberFieldFormat[name=SUM_ZC_AMT]').getValue();
        var SUM_YB_ZC_AMT = form.down('numberFieldFormat[name=SUM_YB_ZC_AMT]').getValue();
        var SUM_ZX_ZC_AMT = form.down('numberFieldFormat[name=SUM_ZX_ZC_AMT]').getValue();
        if (SUM_YB_ZC_AMT > WZC_YB_AMT) {
            grid_error_message = '本次一般债券支出金额高于一般未支出金额！';
            flag = false;
            return flag;
        }
        if (SUM_ZX_ZC_AMT > WZC_ZX_AMT) {
            grid_error_message = '本次专项债券支出金额高于一般未支出金额！';
            flag = false;
            return flag;
        }
        var APPLY_DATE = form.down('datefield[name=APPLY_DATE]').getValue();
        if (APPLY_DATE == null) {
            grid_error_message = '申请日期不能为空';
            flag = false;
            return flag;
        }
        var ZC_CODE = form.down('textfield[name=ZC_CODE]').getValue();
        if (ZC_CODE == null) {
            grid_error_message = '支出单编号不能为空';
            flag = false;
            return flag;
        }
        DSYGrid.getGrid('window_save_zcxx_grid').getStore().each(function (record) {
            if (!record.get('ZC_AMT')) {
                grid_error_message = '支出金额存在空值！';
                flag = false;
                return flag;
            }
            if (record.get('ZC_AMT') < 0) {
                grid_error_message = '支出金额必须大于0！';
                flag = false;
                return flag;
            }
            var str_type;
            if (ZC_TYPE == 1) {
                //录入支出金额不应该超过债券剩余金额
                if (typeof KZC[record.get('ZQ_ID')] == 'undefined') {
                    //不是重复债券，初始化剩余转贷新增总额
                    KZC[record.get('ZQ_ID')] = record.get('SY_PLAN_ZH_AMT');
                }
                if (typeof YZC[record.get('ZQ_ID')] == 'undefined') {
                    //不是重复债券，初始化支出金额
                    YZC[record.get('ZQ_ID')] = record.get('ZC_AMT');
                } else {
                    //重复债券，累加支出金额
                    YZC[record.get('ZQ_ID')] = YZC[record.get('ZQ_ID')] + record.get('ZC_AMT');
                }
                if (YZC[record.get('ZQ_ID')] > KZC[record.get('ZQ_ID')]) {
                    grid_error_message = record.get('ZQ_NAME') + ',支出金额大于剩余转贷置换总额！';
                    flag = false;
                    return flag;
                }
                /* if(record.get('ZC_AMT')>record.get('SY_PLAN_ZH_AMT')){
                 grid_error_message = record.get('ZQ_NAME')+',支出金额大于剩余转贷置换总额！';
                 flag = false;
                 return flag;
                 } */
            } else {
                //录入支出金额不应该超过债券剩余金额
                if (typeof KZC[record.get('ZQ_ID')] == 'undefined') {
                    //不是重复债券，初始化剩余转贷新增总额
                    KZC[record.get('ZQ_ID')] = record.get('SY_PLAN_XZ_AMT');
                }
                if (typeof YZC[record.get('ZQ_ID')] == 'undefined') {
                    //不是重复债券，初始化支出金额
                    YZC[record.get('ZQ_ID')] = record.get('ZC_AMT');
                } else {
                    //重复债券，累加支出金额
                    YZC[record.get('ZQ_ID')] = YZC[record.get('ZQ_ID')] + record.get('ZC_AMT');
                }
                if (YZC[record.get('ZQ_ID')] > KZC[record.get('ZQ_ID')]) {
                    grid_error_message = record.get('ZQ_NAME') + ',支出金额大于剩余转贷新增总额！';
                    flag = false;
                    return flag;
                }
                /* if(record.get('ZC_AMT')>record.get('SY_PLAN_XZ_AMT')){
                 grid_error_message = record.get('ZQ_NAME')+',支出金额大于剩余转贷新增总额！';
                 flag = false;
                 return flag;
                 } */
            }

            if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null || record.get('PAY_DATE') == '') {
                grid_error_message = '支出日期不能为空！';
                flag = false;
                return flag;
            }
        });
        return flag;
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
            ids.push(records[i].get("ZC_ID"));
        }
        button_name = btn.text;
        if (button_name == '送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/zqgl/updateZjzcNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids,
                        ZC_TYPE: ZC_TYPE
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
                        $.post("/zqgl/updateZjzcNode.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids,
                            ZC_TYPE: ZC_TYPE
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
     * 操作记录
     */
    function oprationRecord() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var zdhk_id = records[0].get("ZC_ID");
            fuc_getWorkFlowLog(zdhk_id);
        }
    }
</script>
</body>
</html>