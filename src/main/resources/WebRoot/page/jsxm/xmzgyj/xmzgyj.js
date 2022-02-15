var zgyjStore = DebtEleStoreTable("DEBT_V_PROJECT_ZGXX_YJLY"); //整改意见来源store
var xmlxStore = DebtEleTreeStoreDB('DEBT_ZWXMLX'); //项目类型store
var adConditionStore = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: 'getRegTreeDataNoCache.action',
        extraParams: {
            CHILD: v_child
        },
        reader: {
            type: 'json'
        }
    },
    root: 'nodelist',
    model: 'treeModel',
    autoLoad: true
});
/**
 * 工具栏json
 */
var xmzg_json_common = {
    lr: {
        button_items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '整改意见录入',
                    name: 'INSERT',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        var window = initChooseXmxxWindow(btn);
                        loadChooseXmxxGrid();
                        window.show();
                        btn.setDisabled(false);
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'UPDATE',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        getXmzgInfo(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'REMOVE',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        deleteXmzgInfo(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '下发',
                    name: 'send',
                    icon: '/image/sysbutton/send.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ],
            '002': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销下发',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ]
        },
        status_store: DebtEleStore([
            {id: "001", code: "001", name: "未下发"},
            {id: "002", code: "002", name: "已下发"}
        ])
    },
    qr: {
        button_items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '整改意见确认',
                    name: 'down',
                    icon: '/image/sysbutton/submit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        getXmzgInfo(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '下发',
                    name: 'send',
                    icon: '/image/sysbutton/send.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ],
            '002': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销确认',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ]
        },
        status_store: DebtEleStore(json_debt_zt11)
    },
    fk: {
        button_items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '整改结果反馈',
                    name: 'down',
                    icon: '/image/sysbutton/submit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        getXmzgInfo(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '发送',
                    name: 'send',
                    icon: '/image/sysbutton/send.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ],
            '002': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销反馈',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ],
            '004': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '整改结果反馈',
                    name: 'down',
                    icon: '/image/sysbutton/submit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        getXmzgInfo(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '发送',
                    name: 'send',
                    icon: '/image/sysbutton/send.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ]
        },
        status_store: DebtEleStore([
            {id: "001", code: "001", name: "未反馈"},
            {id: "002", code: "002", name: "已反馈"},
            {id: "004", code: "004", name: "被退回"}
        ])
    },
    sh: {
        button_items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '审核',
                    name: 'down',
                    icon: '/image/sysbutton/submit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'up',
                    icon: '/image/sysbutton/back.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ],
            '002': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销审核',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ],
            '004': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '审核',
                    name: 'down',
                    icon: '/image/sysbutton/submit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'up',
                    icon: '/image/sysbutton/back.png',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed()
            ]
        },
        status_store: ADCODE.length == 2 ? DebtEleStore(json_debt_zt2_3) : DebtEleStore(json_debt_zt2_2)
    }
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
    initContent();
});

/**
 * 初始化主页面panel
 */
function initContent() {
    return Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true, //是否有分割线
            collapsible: false //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: xmzg_json_common[node_type].button_items[wf_status]
            }
        ],
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child //区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }), //左侧树
            initContentRightPanel()
        ]
    });
}

/**
 * 初始化主页面表格panel
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        region: 'center',
        height: '100%',
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 5,
        border: false,
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 60, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        itemId: 'CONTENT_STATUS',
                        name: 'CONTENT_STATUS',
                        store: xmzg_json_common[node_type].status_store,
                        width: 110,
                        editable: false,
                        labelWidth: 30,
                        labelAlign: 'right',
                        allowBlank: false,
                        displayField: "name",
                        valueField: "code",
                        value: wf_status,
                        listeners: {
                            change: function (self, newValue) {
                                wf_status = newValue;
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                toolbar.removeAll();
                                toolbar.add(xmzg_json_common[node_type].button_items[wf_status]);
                                // 动态显隐表头列
                                if (node_type == 'qr' && newValue == "001") {
                                    setColumnHide(false, ['OP_CONTENT']);
                                }
                                if (node_type == 'qr' && newValue == "002") {
                                    setColumnHide(true, ['OP_CONTENT']);
                                }
                                // 刷新主界面表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '项目类型',
                        displayField: 'name',
                        valueField: 'id',
                        name: 'XMLX_ID',
                        store: xmlxStore,
                        editable: false,
                        allowBlank: true,
                        width: 300,
                        labelAlign: 'right',
                        listeners: {
                            select: function (self, newValue, oldValue) {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'combobox',
                        fieldLabel: '整改意见来源',
                        itemId: 'YJLY_ID',
                        name: 'YJLY_ID',
                        store: zgyjStore,
                        editable: false,
                        labelWidth: 90,
                        width: 280,
                        labelAlign: 'right',
                        allowBlank: true,
                        displayField: "name",
                        valueField: "id",
                        listeners: {
                            select: function (self, newValue) {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "MHCX",
                        name: "MHCX",
                        columnWidth: .99,
                        emptyText: '输入项目名称/项目编码',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: function (self, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    reloadGrid();
                                }
                            }
                        }
                    }
                ]
            }
        ],
        items: [
            initContentGrid(),
            initContentLogGrid()
        ]
    });
}

/**
 * 初始化主页面整改信息表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45
        },
        {
            dataIndex: "XM_NAME", type: "string", text: "项目名称", width: 250,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {dataIndex: "YJLY_NAME", type: "string", text: "整改意见来源", width: 150},
        {dataIndex: "ZG_CONTENT", type: "string", text: "整改意见", width: 200, hidden: true},
        {dataIndex: "OP_CONTENT", type: "string", text: "确认意见", width: 200, hidden: true},
        {dataIndex: "FK_CONTENT", type: "string", text: "反馈结果", width: 200, hidden: true},
        {dataIndex: "AD_NAME", type: "string", text: "区划名称", width: 120},
        {dataIndex: "AG_NAME", type: "string", text: "单位名称", width: 200},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度", width: 80},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 150},
        {dataIndex: "JSZT_NAME", type: "string", text: "建设状态", width: 100},
        {
            dataIndex: "XMZGS_AMT", type: "float", text: "项目总概算（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/xmzg/getXmzgList.action',
        autoLoad: false,
        checkBox: true,
        flex: 1,
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        },
        listeners: {
            itemclick: function (self, record, index, eOpts) {
                loadLogGrid(record);
            },
            afterrender: function () {
                // 动态显隐表头列
                if (node_type == 'lr') {
                    setColumnHide(false, ['ZG_CONTENT']);
                }
                if (node_type == 'qr') {
                    setColumnHide(false, ['OP_CONTENT']);
                }
                if (node_type == 'fk') {
                    setColumnHide(false, ['FK_CONTENT']);
                }
                if (node_type == 'sh') {
                    setColumnHide(false, ['ZG_CONTENT', 'FK_CONTENT']);
                }
            }
        }
    });
}

/**
 * 初始化主页面整改日志信息表格
 */
function initContentLogGrid() {
    var headerJson = [
        {text: "操作级次", dataIndex: "OP_LEVEL", type: "string", width: 100},
        {text: "操作类型", dataIndex: "OP_TYPE", type: "string", width: 150},
        {
            text: "操作意见", dataIndex: "OP_CONTENT", width: 350, type: "string",
            renderer: function (data, cell, record) {
                var opType = record.get('OP_TYPE');
                var opContent = record.get('OP_CONTENT');
                if (opType == '整改意见撤销下发' || opType == '整改意见撤销确认' || opType == '整改结果撤销反馈' || opType == '整改结果撤销审核') {
                    return '';
                }
                return '<a href="javascript:void(0);" style="color:#3329ff;" onclick="getOneLogInfo(\''
                    + record.get('GUID') + '\',\'' + opType + '\',\'' + opContent + '\')">'
                    + opContent + '</a>';
            }
        },
        {text: "相关附件", dataIndex: "FILE_NAME", width: 350, type: "string"},
        {text: "操作人", dataIndex: "OP_USER", width: 200, type: "string"},
        {text: "操作时间", dataIndex: "OP_TIME", width: 150, type: "string"}
    ];
    var logGrid = DSYGrid.createGrid({
        itemId: 'contentLogGrid',
        title: '操作记录',
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        checkBox: false,
        pageConfig: {
            enablePage: false
        }
    });
    return logGrid;
}

/**
 * 加载整改日志表格
 */
function loadLogGrid(record) {
    $.post("/xmzg/getLogInfo.action", {
        GUID: record.get('GUID')
    }, function (data) {
        if (data.success) {
            var logList = data.log;
            var fileList = data.file;
            if (!logList) {
                return;
            }
            for (var i = 0; i < logList.length; i++) {
                logList[i].FILE_NAME = getLogFile(logList[i].GUID, fileList);
            }
            var logGrid = DSYGrid.getGrid('contentLogGrid');
            logGrid.getStore().removeAll();
            logGrid.insertData(null, logList);
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
    }, "json");
}

/**
 * 选择项目信息window
 */
function initChooseXmxxWindow(b_btn) {
    return Ext.create('Ext.window.Window', {
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        title: '请选择项目信息',
        itemId: 'chooseXmxxWindow',
        layout: 'fit',
        modal: true,
        maximizable: true,
        closeAction: 'destroy',
        items: initChooseXmxxGrid(),
        buttons: [
            {
                xtype: 'button',
                text: '确定',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var record = DSYGrid.getGrid('chooseXmxxGrid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条记录');
                        btn.setDisabled(false);
                        return;
                    }
                    var guid = GUID.createGUID();
                    var opId = GUID.createGUID();
                    var window = initXmzgWindow(b_btn, opId, true);
                    Ext.ComponentQuery.query('form#xmzgForm')[0].getForm().setValues($.extend({
                        GUID: guid, OP_ID: opId
                    }, record.getData()));
                    renderFormByNodeType();
                    window.show();
                    btn.up('window').close();
                }
            },
            {
                xtype: 'button',
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 70, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: "treecombobox",
                        store: adConditionStore,
                        valueField: "code",
                        displayField: 'text',
                        name: 'CHOOSE_AD_CODE',
                        fieldLabel: '区划',
                        rootVisible: false,
                        columnWidth: .15,
                        labelWidth: 30,
                        labelAlign: 'right',
                        editable: false,
                        selectModel: 'all',
                        listeners: {
                            change: function () {
                                var agCondition = Ext.ComponentQuery.query('treecombobox#agCondition')[0];
                                var agStore = agCondition.getStore();
                                agStore.getProxy().extraParams = {
                                    AD_CODE: this.getValue()
                                };
                                agStore.load();
                                loadChooseXmxxGrid();
                            },
                            'afterrender': function (self) {
                                var adTreeStore = this.getStore();
                                if (adTreeStore.getCount() == 1) {
                                    var record = adTreeStore.getRoot().getChildAt(0);
                                    this.setValue(record.get('code'));
                                    this.setReadOnly(true);
                                    this.setFieldStyle('background:#E6E6E6');
                                }
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        store: Ext.create('Ext.data.TreeStore', {
                            proxy: {
                                type: 'ajax',
                                method: 'POST',
                                url: 'getUnitTreeData.action',
                                reader: {
                                    type: 'json'
                                }
                            },
                            root: {
                                expanded: true,
                                text: "全部",
                                children: [
                                    {text: "单位", code: "单位", leaf: true}
                                ]
                            },
                            model: 'treeModel'
                        }),
                        valueField: "code",
                        displayField: 'text',
                        fieldLabel: '单位',
                        itemId: 'agCondition',
                        name: 'CHOOSE_AG_CODE',
                        emptyText: '请先选择区划',
                        columnWidth: .20,
                        labelWidth: 30,
                        editable: false,
                        labelAlign: 'right',
                        selectModel: 'all',
                        listeners: {
                            change: function (t, newValue) {
                                loadChooseXmxxGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: 'CHOOSE_MHCX',
                        name: 'CHOOSE_MHCX',
                        labelWidth: 60,
                        columnWidth: .30,
                        emptyText: '输入项目名称/项目编码',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: function (self, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    loadChooseXmxxGrid();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        handler: function () {
                            loadChooseXmxxGrid();
                        }
                    }
                ]
            }
        ]
    });
}

/**
 * 选择项目信息表格
 */
function initChooseXmxxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "AD_NAME", type: "string", text: "地区", width: 150},
        {dataIndex: "AG_NAME", type: "string", text: "单位名称", width: 250},
        {dataIndex: "XM_ID", type: "string", text: "项目ID", width: 150, hidden: true},
        {
            dataIndex: "XM_NAME", type: "string", text: "项目名称", width: 300,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 200},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度", width: 120},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 200},
        {dataIndex: "JSZT_NAME", type: "string", text: "建设状态", width: 120},
        {
            text: '项目总概算（万元）', dataIndex: 'XMZGS_AMT', type: 'float', width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'chooseXmxxGrid',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"
        },
        dataUrl: '/xmzg/getXmxxList.action',
        autoLoad: false,
        checkBox: false,
        flex: 1,
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        }
    });
}

/**
 * 加载选择项目信息表格
 */
function loadChooseXmxxGrid() {
    var adCode = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_AD_CODE']")[0].getValue();
    var agCode = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_AG_CODE']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='CHOOSE_MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('chooseXmxxGrid').getStore();
    store.getProxy().extraParams = {
        AD_CODE: adCode,
        AG_CODE: agCode,
        MHCX: mhcx
    };
    store.loadPage(1);
}

/**
 * 初始化项目整改弹出框
 */
function initXmzgWindow(b_btn, opId, editable) {
    return new Ext.Window({
        title: b_btn.text,
        width: document.body.clientWidth * 0.85,
        height: document.body.clientHeight * 0.85,
        layout: 'fit',
        itemId: 'xmzgWindow',
        buttonAlign: 'center',
        maximizable: true,
        frame: true,
        constrain: true,
        scrollable: true,
        modal: true,
        closeAction: 'destroy',
        items: initXmzgWindow_panel(opId, editable),
        buttons: [
            {
                text: '保存',
                name: 'save',
                handler: function (btn) {
                    btn.setDisabled(true);
                    saveXmzgInfo(b_btn, btn);
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
 * 初始化项目整改弹出框中panel
 */
function initXmzgWindow_panel(opId, editable) {
    return Ext.create('Ext.panel.Panel', {
        name: 'xmzgWindowPanel',
        layout: 'vbox',
        defaults: {
            margin: '10 10 10 10'
        },
        border: false,
        autoScroll: true,
        items: [
            initXmzgWindow_form_panel(),
            initXmzgWindow_fj_panel(opId, editable)
        ]
    });
}

/**
 * 初始化项目整改弹出框中表单项
 */
function initXmzgWindow_form_panel() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        layout: 'column',
        border: false,
        defaultType: 'textfield',
        itemId: 'xmzgForm',
        name: 'xmzgForm',
        defaults: {
            margin: '10 10 10 10',
            columnWidth: .5,
            labelWidth: 125//控件默认标签宽度
        },
        items: [
            {
                xtype: "textfield",
                fieldLabel: '整改ID',
                name: "GUID",
                hidden: true
            },
            {
                xtype: "textfield",
                fieldLabel: '操作ID',
                name: "OP_ID",
                hidden: true
            },
            {
                xtype: "textfield",
                fieldLabel: '区划编码',
                name: "AD_CODE",
                hidden: true
            },
            {
                fieldLabel: '区划名称',
                xtype: "textfield",
                name: "AD_NAME",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                xtype: "textfield",
                fieldLabel: '单位ID',
                name: "AG_ID",
                hidden: true
            },
            {
                xtype: "textfield",
                fieldLabel: '单位编码',
                name: "AG_CODE",
                hidden: true
            },
            {
                fieldLabel: '单位名称',
                xtype: "textfield",
                name: "AG_NAME",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                xtype: "textfield",
                fieldLabel: '项目ID',
                name: "XM_ID",
                hidden: true
            },
            {
                fieldLabel: '项目编码',
                xtype: "textfield",
                name: "XM_CODE",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                fieldLabel: '项目名称',
                xtype: "textfield",
                name: "XM_NAME",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                xtype: 'combobox',
                fieldLabel: '<span class="required">✶</span>整改意见来源',
                name: 'YJLY_ID',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                allowBlank: false,
                store: zgyjStore
            },
            {
                xtype: "textarea",
                fieldLabel: '<span class="required">✶</span>整改意见',
                name: "ZG_CONTENT",
                columnWidth: .99,
                multiline: true,
                allowBlank: false,
                emptyText: '请填写整改意见（500字符以内）',
                maxLength: 500
            },
            {
                xtype: "textarea",
                fieldLabel: '<span class="required">✶</span>确认意见',
                name: "OP_CONTENT",
                columnWidth: .99,
                multiline: true,
                allowBlank: false,
                emptyText: '请填写确认意见（500字符以内）',
                maxLength: 500
            },
            {
                xtype: "textarea",
                fieldLabel: '<span class="required">✶</span>反馈结果',
                name: "FK_CONTENT",
                columnWidth: .99,
                multiline: true,
                allowBlank: false,
                emptyText: '请填写反馈结果（500字符以内）',
                maxLength: 500
            }
        ]
    });
}

/**
 * 初始化项目整改弹出框中附件表格
 */
function initXmzgWindow_fj_panel(busiId, editable) {
    return UploadPanel.createGrid({
        busiType: 'ETXMZG',
        busiId: busiId,
        editable: editable,
        busiProperty: '%',
        gridConfig: {
            width: '100%',
            minHeight: 157,
            flex: 1,
            itemId: 'xmzgWindow_fj'
        }
    });
}

/**
 * 保存项目整改信息
 */
function saveXmzgInfo(b_btn, btn) {
    var xmzgForm = Ext.ComponentQuery.query('form#xmzgForm')[0];
    var result = CheckItemEmpty(xmzgForm.items, 'verifi');
    if (result != '') {
        Ext.MessageBox.alert('提示', result);
        btn.setDisabled(false);
        return;
    }
    $.post('/xmzg/saveXmzgInfo.action', {
        BUTTON_NAME: b_btn.name,
        BUTTON_TEXT: b_btn.text,
        NODE_TYPE: node_type,
        XMZG_DATA: Ext.util.JSON.encode(xmzgForm.getForm().getValues())
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: btn.text + "成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, "json");
}

/**
 * 保存校验
 */
function verifi() {
    var array = new Array();
    var xmzgForm = Ext.ComponentQuery.query('form#xmzgForm')[0].getForm();
    //内容长度校验
    var itemNames = ['ZG_CONTENT', 'OP_CONTENT', 'FK_CONTENT'];
    for (var i in itemNames) {
        var content = xmzgForm.findField(itemNames[i]).getValue();
        if (getStringLength(content) > 500) {
            array.push(xmzgForm.findField(itemNames[i]).getFieldLabel() + '不能超过500个字符！');
        }
    }
    return array.join('<br>');
}

/**
 * 获取项目整改信息
 */
function getXmzgInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
        btn.setDisabled(false);
        return;
    }
    var guid = records[0].get('GUID');
    $.post("/xmzg/getXmzgInfo.action", {
        GUID: guid
    }, function (data) {
        if (data.success) {
            var opId = data.xmzgInfo.OP_ID;
            if (!opId) {
                opId = GUID.createGUID();
                data.xmzgInfo.OP_ID = opId;
            }
            var window = initXmzgWindow(btn, opId, true);
            Ext.ComponentQuery.query('form#xmzgForm')[0].getForm().setValues(data.xmzgInfo);
            renderFormByNodeType()
            window.show();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        btn.setDisabled(false);
    }, "json");
}

/**
 * 删除项目整改信息
 */
function deleteXmzgInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length < 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            var guids = [];
            for (var i in records) {
                guids.push(records[i].get('GUID'));
            }
            $.post("/xmzg/deleteXmzgInfo.action", {
                GUIDS: guids,
                BUTTON_NAME: btn.name,
                NODE_TYPE: node_type
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: btn.text + "成功",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    reloadGrid();
                } else {
                    Ext.MessageBox.alert('提示', data.message);
                }
                btn.setDisabled(false);
            }, "json");
        } else {
            btn.setDisabled(false);
        }
    });
}

/**
 * 操作流程方法：
 * 整改意见下发、整改意见撤销下发、
 * 整改意见确认下发、整改意见撤销确认、
 * 整改结果反馈发送、整改结果撤销反馈、
 * 整改结果审核、整改结果撤销审核、整改结果退回
 */
function doWorkFlow(btn) {
    var btnName = btn.name;
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    //下发时校验是否录入下发内容
    if (btnName == 'send') {
        var checkMsg = isEmptyContent(records);
        if (checkMsg != '') {
            Ext.MessageBox.alert('提示', checkMsg);
            btn.setDisabled(false);
            return;
        }
    }
    if (btnName == 'down' || btnName == 'up') {
        opinionWindow.open(btn.text + "意见", btn);
    } else {
        Ext.MessageBox.show({
            title: "提示",
            msg: "确认" + btn.text + "选中记录？",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (buttonId) {
                if (buttonId === 'ok') {
                    doWorkFlowPost(btn, '');
                } else {
                    btn.setDisabled(false);
                }
            }
        });
    }
}

/**
 * post方式发送操作流程
 */
function doWorkFlowPost(btn, auditInfo) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    var guidOpId = {};
    for (var i in records) {
        guidOpId[records[i].get("GUID")] = isNull(records[i].get("OP_ID")) ? GUID.createGUID() : records[i].get("OP_ID")
    }
    $.post("/xmzg/doWorkFlow.action", {
        BUTTON_NAME: btn.name,
        NODE_TYPE: node_type,
        GUID_OPID: Ext.util.JSON.encode(guidOpId),
        AUDIT_INFO: auditInfo
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: btn.text + "成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        btn.setDisabled(false);
    }, "json");
}

/**
 * 审核、退回填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (title, btn) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            value: btn.name == 'down' ? '同意' : null,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btnBox, text) {
                if (btnBox == "ok") {
                    doWorkFlowPost(btn, text);
                } else {
                    btn.setDisabled(false);
                }
            }
        });
    },
    close: function () {
        if (this.window) {
            this.window.close();
        }
    }
};

/**
 * 下发时校验是否录入下发内容
 */
function isEmptyContent(records) {
    var xmNames = [];
    var opContent = '';
    for (var i in records) {
        if (node_type == 'lr' && !records[i].get('ZG_CONTENT')) {
            xmNames.push(records[i].get('XM_NAME'));
            opContent = '整改意见';
        }
        if (node_type == 'qr' && !records[i].get('OP_CONTENT')) {
            xmNames.push(records[i].get('XM_NAME'));
            opContent = '确认意见';
        }
        if (node_type == 'fk' && !records[i].get('FK_CONTENT')) {
            xmNames.push(records[i].get('XM_NAME'));
            opContent = '反馈结果';
        }
    }
    if (xmNames.length > 0) {
        return '项目名称：' + xmNames.join('、') + '，请录入' + opContent + '在进行下发';
    }
    return '';
}

/**
 * 设置表格列显隐
 */
function setColumnHide(isHide, columnNames) {
    var columns = DSYGrid.getGrid('contentGrid').columns;
    for (var i = 0; i < columns.length; i++) {
        for (var index in columnNames) {
            if (columns[i].dataIndex == columnNames[index]) {
                columns[i].setHidden(isHide);
                break;
            }
        }
    }
}

/**
 * 设置表单项是否只读
 */
function setItemsReadOnly(readOnly, form, itemNames) {
    for (var i in itemNames) {
        var item = form.findField(itemNames[i]);
        item.setReadOnly(readOnly);
        var fieldLabel = item.getFieldLabel();
        if (readOnly) {
            item.setFieldStyle('background:#E6E6E6');
            if (fieldLabel.indexOf('<span class="required">✶</span>') >= 0) {
                item.setFieldLabel(fieldLabel.replaceAll('<span class="required">✶</span>', ''));
            }
        } else {
            item.setFieldStyle('background:#FFFFFF');
            if (fieldLabel.indexOf('<span class="required">✶</span>') < 0) {
                item.setFieldLabel('<span class="required">✶</span>' + fieldLabel);
            }
        }
    }
}

/**
 * 设置表单项是否只读
 */
function setItemsHide(isHide, form, itemNames) {
    for (var i in itemNames) {
        var item = form.findField(itemNames[i]);
        item.setHidden(isHide);
        item.setDisabled(isHide);
    }
}

/**
 * 动态显隐菜单信息项
 */
function renderFormByNodeType() {
    var xmzgForm = Ext.ComponentQuery.query('form#xmzgForm')[0].getForm();
    if (node_type == 'lr') {
        setItemsHide(true, xmzgForm, ['OP_CONTENT', 'FK_CONTENT']);
    }
    if (node_type == 'qr') {
        setItemsReadOnly(true, xmzgForm, ['YJLY_ID', 'ZG_CONTENT']);
        setItemsHide(true, xmzgForm, ['FK_CONTENT']);
    }
    if (node_type == 'fk') {
        setItemsReadOnly(true, xmzgForm, ['YJLY_ID', 'ZG_CONTENT']);
        setItemsHide(true, xmzgForm, ['OP_CONTENT']);
    }
}

/**
 * 获取日志对应的附件
 */
function getLogFile(busiId, fileList) {
    var result = '';
    for (var i = 0; i < fileList.length; i++) {
        if (busiId == fileList[i].BUSI_ID) {
            var fileId = fileList[i].FILE_ID;
            var fileName = fileList[i].FILE_NAME;
            var fileType = fileList[i].FILE_TYPE;
            if (fileType) {
                fileType = fileType.toLowerCase();
            }
            if (fileType == "dps" || fileType == "dpt" || fileType == "odp" || fileType == "otp" || fileType == "ofd") {
                fileType = "pdf";
            } else if (fileType == "wps" || fileType == "wpt" || fileType == "odt" || fileType == "ott") {
                fileType = "docx";
            } else if (fileType == "et" || fileType == "ett" || fileType == "ods" || fileType == "ots") {
                fileType = "xlsx";
            }
            var image = '';
            if (fileType != null && fileType != "") {
                image = '<image src="/image/file/' + fileType + '.png">&nbsp';
            }
            if (fileType == "png" || fileType == "jpg" || fileType == "jpeg") {
                if (browserInfo["browser"] === "IE" && browserInfo["version"] === "8.0") {
                    image = "<image style='width:64px;height:64px;cursor:pointer;' onclick='imageClick(\"" + fileId + "\")' src='previewImage.action?file_id=" + fileId + "'/>";
                } else {
                    image = "<image style='width:64px;height:64px;cursor:pointer;' data-original='previewReadyImage.action?file_id=" + fileId +
                        "' src='previewImage.action?file_id=" + fileId + "' onload='imageAfterLoad(this, \"" + fileId + "\")' alt='" + fileName + "' title='" + fileName + "'/>";
                }
            }
            result += (image + '<a href="javascript:void(0);" style="color:#3329ff;" onclick="UploadPanel.downloadFile(\'' + fileId + '\')">' + fileName + '</a>&nbsp;&nbsp;');
        }
    }
    return result;
}

/**
 * 获取日志详细信息
 */
function getOneLogInfo(id, opType, opContent) {
    if (opType == '整改结果审核' || opType == '整改结果退回') {
        Ext.MessageBox.show({
            title: opType,
            width: 350,
            value: opContent,
            multiline: true
        });
        return;
    }
    $.post("/xmzg/getOneLogInfo.action", {
        GUID: id
    }, function (data) {
        if (data.success) {
            var logInfo = data.log;
            var opType = logInfo.OP_TYPE;
            var window = initXmzgWindow({text: opType}, id, false);
            var xmzgForm = Ext.ComponentQuery.query('form#xmzgForm')[0].getForm();
            xmzgForm.setValues(logInfo);
            if (opType == '整改意见下发') {
                //禁用、隐藏表单项
                setItemsReadOnly(true, xmzgForm, ['YJLY_ID', 'ZG_CONTENT']);
                setItemsHide(true, xmzgForm, ['OP_CONTENT', 'FK_CONTENT']);
            }
            if (opType == '整改意见确认') {
                //禁用、隐藏表单项
                setItemsReadOnly(true, xmzgForm, ['YJLY_ID', 'ZG_CONTENT', 'OP_CONTENT']);
                setItemsHide(true, xmzgForm, ['FK_CONTENT']);
            }
            if (opType == '整改结果反馈') {
                //禁用、隐藏表单项
                setItemsReadOnly(true, xmzgForm, ['YJLY_ID', 'ZG_CONTENT', 'FK_CONTENT']);
                setItemsHide(true, xmzgForm, ['OP_CONTENT']);
            }
            //隐藏保存按钮
            Ext.ComponentQuery.query('button[name="save"]')[0].setHidden(true);
            window.show();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
    }, "json");

}

/**
 * 刷新主表格
 */
function reloadGrid() {
    var xmlxId = Ext.ComponentQuery.query("treecombobox[name='XMLX_ID']")[0].getValue();
    var yjlyId = Ext.ComponentQuery.query("combobox[name='YJLY_ID']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('contentGrid').getStore();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        NODE_TYPE: node_type,
        WF_STATUS: wf_status,
        XMLX_ID: xmlxId,
        YJLY_ID: yjlyId,
        MHCX: mhcx
    };
    store.loadPage(1);
    DSYGrid.getGrid('contentLogGrid').getStore().removeAll();
}