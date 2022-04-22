var xmlxStore = DebtEleTreeStoreDB('DEBT_ZWXMLX'); //项目类型store
var jsztStore = DebtEleTreeStoreDB("DEBT_XMJSZT"); //建设状态store
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
                items: [
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
                        text: '新增',
                        name: 'INSERT',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            btn.setDisabled(true);
                            initChooseXmxxWindow(btn).show();
                            btn.setDisabled(false);
                            loadChooseXmxxGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            btn.setDisabled(true);
                            updateXmdyInfo(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            btn.setDisabled(true);
                            deleteXmdyInfo(btn);
                        }
                    },
                    '->',
                    initButton_OftenUsed()
                ]
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
                        xtype: 'treecombobox',
                        fieldLabel: '项目类型',
                        displayField: 'name',
                        valueField: 'id',
                        name: 'XMLX_ID',
                        store: xmlxStore,
                        editable: false,
                        allowBlank: true,
                        width: 300,
                        labelAlign: 'right'
                    },
                    {
                        xtype: "treecombobox",
                        name: "JSZT_ID",
                        fieldLabel: '建设状态',
                        store: jsztStore,
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: true,
                        rootVisible: false,
                        lines: false,
                        width: 220,
                        selectModel: 'leaf',
                        editable: false
                    },
                    {
                        xtype: "datefield",
                        name: "START_DATE",
                        fieldLabel: '调研时间起',
                        allowBlank: false,
                        format: 'Y-m-d',
                        labelWidth: 70,
                        width: 180,
                        readOnly: false,
                        allowBlank: true,
                        editable: true
                    },
                    {
                        xtype: "datefield",
                        name: "END_DATE",
                        fieldLabel: '调研时间止',
                        labelWidth: 70,
                        allowBlank: false,
                        format: 'Y-m-d',
                        width: 180,
                        readOnly: false,
                        allowBlank: true,
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "MHCX",
                        name: "MHCX",
                        columnWidth: .99,
                        emptyText: '输入项目名称/项目编码/参加人员'
                    }
                ]
            }
        ],
        items: initContentGrid()
    });
}

/**
 * 初始化主页面表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45
        },
        {dataIndex: "AD_NAME", type: "string", text: "地区", width: 120},
        {dataIndex: "AG_NAME", type: "string", text: "单位名称", width: 200},
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
        {dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 200},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 150},
        {dataIndex: "JSZT_NAME", type: "string", text: "建设状态", width: 120},
        {
            dataIndex: "FX_AMT", type: "float", text: "发行金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {dataIndex: "START_DATE", type: "string", text: "调研时间起", width: 120},
        {dataIndex: "END_DATE", type: "string", text: "调研时间止", width: 120},
        {dataIndex: "CJ_USER", type: "string", text: "参加人员", width: 150},
        {dataIndex: "LR_USER", type: "string", text: "信息录入人员", width: 150},
        {dataIndex: "LR_TIME", type: "string", text: "信息录入时间", width: 150}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/xmgl/xmdy/getXmdyList.action',
        autoLoad: false,
        checkBox: true,
        flex: 1,
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        }
    });
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
                    loadZqxmInfo(record, b_btn, btn);
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
                    labelWidth: 60, //控件默认标签宽度
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
                        width: 200,
                        labelWidth: 30,
                        labelAlign: 'right',
                        editable: false,
                        selectModel: 'all',
                        listeners: {
                            change: function () {
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
                        xtype: "combobox",
                        name: "CHOOSE_YEAR",
                        store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债券发行年度',
                        editable: false,
                        labelWidth: 85,
                        width: 240,
                        labelAlign: 'right',
                        listeners: {
                            change: function () {
                                loadChooseXmxxGrid();
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '项目类型',
                        displayField: 'name',
                        valueField: 'id',
                        name: 'CHOOSE_XMLX_ID',
                        store: xmlxStore,
                        editable: false,
                        allowBlank: true,
                        width: 300,
                        labelAlign: 'right',
                        listeners: {
                            change: function () {
                                loadChooseXmxxGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: 'CHOOSE_MHCX',
                        name: 'CHOOSE_MHCX',
                        columnWidth: .50,
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
        {dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 300},
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
        dataUrl: '/xmgl/xmdy/getXmxxList.action',
        autoLoad: false,
        checkBox: false,
        flex: 1,
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 300 // 每页显示数据数
        },
        listeners: {
            'beforeRender': function () {
                //设置每页条数下拉框
                var xmxxWindow = Ext.ComponentQuery.query('window#chooseXmxxWindow')[0];
                var pagingCombobox = xmxxWindow.down('combobox[blankText="每页显示记录数不允许为空"]');
                if (pagingCombobox) {
                    pagingCombobox.setStore([10, 20, 50, 100, 300, 500]);
                }
            }
        }
    });
}

/**
 * 加载选择项目信息表格
 */
function loadChooseXmxxGrid() {
    var adCode = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_AD_CODE']")[0].getValue();
    var year = Ext.ComponentQuery.query("combobox[name='CHOOSE_YEAR']")[0].getValue();
    var xmlxId = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_XMLX_ID']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='CHOOSE_MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('chooseXmxxGrid').getStore();
    store.getProxy().extraParams = {
        AD_CODE: adCode,
        YEAR: year,
        XMLX_ID: xmlxId,
        MHCX: mhcx
    };
    store.loadPage(1);
}

/**
 * 加载债券项目信息
 */
function loadZqxmInfo(record, b_btn, btn) {
    $.post("/xmgl/xmdy/getZqxmInfo.action", {
        XM_ID: record.get('XM_ID')
    }, function (data) {
        if (data.success) {
            var guid = GUID.createGUID();
            var dyxxWindow = initDyxxWindow(b_btn, guid);
            //债券信息表格赋值
            var zqxxGrid = DSYGrid.getGrid('dyxxWindow_zqxx_grid');
            zqxxGrid.insertData(null, data.zqxmList);
            //项目信息表单赋值
            Ext.ComponentQuery.query('form#dyxxWindow_xmxx_form')[0].getForm().setValues({
                XM_ID: record.get('XM_ID'),
                XM_NAME: record.get('XM_NAME'),
                FX_AMT: zqxxGrid.getStore().sum('FX_AMT')
            });
            //调研信息表单赋值
            Ext.ComponentQuery.query('form#dyxxWindow_dyxx_form')[0].getForm().findField('GUID').setValue(guid);
            dyxxWindow.show();
            btn.up('window').close();
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, "json");
}

/**
 * 初始化调研信息window
 */
function initDyxxWindow(b_btn, guid) {
    return Ext.create('Ext.window.Window', {
        title: '调研信息登记',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        layout: 'vbox',
        itemId: 'dyxxWindow',
        buttonAlign: 'center',
        maximizable: true,
        frame: true,
        constrain: true,
        scrollable: true,
        modal: true,
        closeAction: 'destroy',
        items: [
            {
                xtype: 'label',
                text: '项目信息：',
                cls: "label-color",
                style: {'margin': '15 0 0 10', 'font-weight': 'bold', 'font-size': '20px'}
            },
            {
                xtype: 'menuseparator',
                border: true,
                width: '100%',
                style: {'border-color': '#E6E6E6', 'margin': '2 0 0 10'}
            },
            initdyxxWindow_amt_panel(),
            initdyxxWindow_xmxx_form(),
            initdyxxWindow_zqxx_panel(),
            {
                xtype: 'label',
                text: '调研信息：',
                cls: "label-color",
                style: {'margin': '5 0 0 10', 'font-weight': 'bold', 'font-size': '20px'}
            },
            {
                xtype: 'menuseparator',
                border: true,
                width: '100%',
                style: {'border-color': '#E6E6E6', 'margin': '2 0 0 10'}
            },
            initdyxxWindow_dyxx_form(),
            {
                xtype: 'label',
                text: '附件列表：',
                cls: "label-color",
                style: {'margin': '5 0 0 10', 'font-weight': 'bold', 'font-size': '20px'}
            },
            {
                xtype: 'menuseparator',
                border: true,
                width: '100%',
                style: {'border-color': '#E6E6E6', 'margin': '2 0 0 10'}
            },
            initdyxxWindow_file_panel(guid)
        ],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    btn.setDisabled(true);
                    saveXmdyInfo(b_btn, btn);
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
 * 调研信息窗口中单位万元panel
 */
function initdyxxWindow_amt_panel() {
    return Ext.create('Ext.panel.Panel', {
        width: '100%',
        layout: 'anchor',
        border: false,
        items: [
            {
                xtype: 'label',
                text: '单位：万元',
                width: 80,
                cls: "label-color",
                style: {'float': 'right', 'color': 'red', 'margin': '2 0 0 0'}
            }
        ]
    });
}

/**
 * 调研信息窗口中项目信息表单
 */
function initdyxxWindow_xmxx_form() {
    return Ext.create('Ext.form.Panel', {
        layout: 'column',
        itemId: 'dyxxWindow_xmxx_form',
        width: '100%',
        layout: 'column',
        scrollable: false,
        border: false,
        split: true,
        margin: '0 5 0 5',
        defaults: {
            columnWidth: .33,
            margin: '2 10 5 10',
            labelAlign: 'left'
        },
        items: [
            {
                fieldLabel: '项目ID',
                name: 'XM_ID',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                hidden: true
            },
            {
                fieldLabel: '项目名称',
                name: 'XM_NAME',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                xtype: "numberFieldFormat",
                name: "FX_AMT",
                fieldLabel: '发行金额合计',
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: true,
                readOnly: true,
                fieldCls: 'form-unedit-number',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }
        ]
    });
}

/**
 * 调研信息窗口中债券信息panel
 */
function initdyxxWindow_zqxx_panel() {
    return Ext.create('Ext.panel.Panel', {
        name: 'zqxxForm',
        width: '100%',
        layout: 'fit',
        scrollable: true,
        border: false,
        split: true,
        margin: '0 0 10 0',
        items: initdyxxWindow_zqxx_grid()
    });
}

/**
 * 调研信息窗口中债券表格
 */
function initdyxxWindow_zqxx_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "发行批次ID", dataIndex: "ZQ_PC_ID", type: 'string', width: 180, hidden: true},
        {text: "发行批次", dataIndex: "ZQ_PC_NAME", type: 'string', width: 180},
        {text: "债券ID", dataIndex: "ZQ_ID", type: 'string', width: 180, hidden: true},
        {text: "债券名称", dataIndex: "ZQ_NAME", type: 'string', width: 180},
        {text: "债券代码", dataIndex: "ZQ_CODE", type: 'string', width: 180},
        {text: "发行时间", dataIndex: "FX_START_DATE", type: 'string', width: 120},
        {text: "发行结束时间", dataIndex: "FX_END_DATE", type: 'string', width: 120, hidden: true},
        {
            text: "发行金额", dataIndex: "FX_AMT", type: "float", width: 150,
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "其中新增", dataIndex: "XZ_AMT", type: "float", width: 150,
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "其中置换", dataIndex: "ZH_AMT", type: "float", width: 150,
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "其中再融资", dataIndex: "HB_AMT", type: "float", width: 150,
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'dyxxWindow_zqxx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        autoLoad: false,
        checkBox: false,
        border: false,
        height: '100%',
        width: '100%',
        minHeight: 170,
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 * 调研信息窗口中调研信息表单
 */
function initdyxxWindow_dyxx_form() {
    return Ext.create('Ext.form.Panel', {
        layout: 'column',
        itemId: 'dyxxWindow_dyxx_form',
        width: '100%',
        layout: 'column',
        scrollable: false,
        border: false,
        margin: '0 5 10 5',
        defaults: {
            columnWidth: .99,
            margin: '5 10 5 10',
            labelAlign: 'left'
        },
        items: [
            {
                fieldLabel: '调研ID',
                name: 'GUID',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                hidden: true
            },
            {
                fieldLabel: '<span class="required">✶</span>调研时间起',
                xtype: 'datefield',
                name: 'START_DATE',
                editable: false,
                allowBlank: false,
                format: 'Y-m-d',
                maxValue: now_date,
                blankText: '请选择调研时间',
                emptyText: '请选择调研时间',
                columnWidth: .33
            },
            {
                fieldLabel: '<span class="required">✶</span>调研时间止',
                xtype: 'datefield',
                name: 'END_DATE',
                editable: false,
                allowBlank: false,
                format: 'Y-m-d',
                maxValue: now_date,
                blankText: '请选择调研时间',
                emptyText: '请选择调研时间',
                columnWidth: .33
            },
            {
                fieldLabel: '<span class="required">✶</span>参加人员',
                name: 'CJ_USER',
                xtype: 'textfield',
                allowBlank: false,
                columnWidth: .33,
                validator: vd
            },
            {
                fieldLabel: '拨付情况',
                xtype: "textarea",
                name: 'BFQK',
                emptyText: '请填写拨付情况（500字以内）',
                validator: vd
            },
            {
                fieldLabel: '资金余额状态',
                xtype: "textarea",
                name: 'ZJYE',
                emptyText: '请填写资金余额状态（500字以内）',
                validator: vd
            },
            {
                fieldLabel: '存在问题',
                xtype: "textarea",
                name: 'CZWT',
                emptyText: '请填写存在问题（500字以内）',
                validator: vd
            },
            {
                fieldLabel: '问题原因',
                xtype: "textarea",
                name: 'WTYY',
                emptyText: '请填写问题原因（500字以内）',
                validator: vd
            },
            {
                fieldLabel: '解决措施',
                xtype: "textarea",
                name: 'JJCS',
                emptyText: '请填写解决措施（500字以内）',
                validator: vd
            },
            {
                fieldLabel: '整改建议',
                xtype: "textarea",
                name: 'ZGJY',
                emptyText: '请填写整改建议（500字以内）',
                validator: vd
            },
            {
                fieldLabel: '整改效果',
                xtype: "textarea",
                name: 'ZGXG',
                emptyText: '请填写整改效果（500字以内）',
                validator: vd
            }
        ]
    });
}

/**
 * 调研信息窗口中附件panel
 */
function initdyxxWindow_file_panel(guid) {
    return Ext.create('Ext.panel.Panel', {
        name: 'filePanel',
        width: '100%',
        layout: 'fit',
        scrollable: true,
        border: false,
        margin: '2 0 20 0',
        items: initdyxxWindow_file_grid(guid)
    });
}

/**
 * 调研信息窗口中附件表格
 */
function initdyxxWindow_file_grid(busiId) {
    return UploadPanel.createGrid({
        busiType: 'ETXMDY', //业务类型
        busiId: busiId, //业务ID
        busiProperty: '', //业务规则
        editable: true, //是否可以修改附件内容
        border: false,
        flex: 1,
        gridConfig: {
            border: false,
            minHeight: 170,
            itemId: 'dyxxWindow_file_grid'
        }
    });
}

/**
 * 保存项目调研信息
 */
function saveXmdyInfo(b_btn, btn) {
    var xmxxForm = Ext.ComponentQuery.query('form#dyxxWindow_xmxx_form')[0];
    var dyxxForm = Ext.ComponentQuery.query('form#dyxxWindow_dyxx_form')[0];
    var result = CheckItemEmpty(dyxxForm.items, 'verifi');
    if (result != '') {
        Ext.MessageBox.alert('提示', result);
        btn.setDisabled(false);
        return;
    }
    var zqxxData = [];
    DSYGrid.getGrid('dyxxWindow_zqxx_grid').getStore().each(function (record) {
        zqxxData.push($.extend({
            DYXX_ID: dyxxForm.getForm().findField('GUID').getValue()
        }, record.getData()));
    });
    $.post('/xmgl/xmdy/saveXmdyInfo.action', {
        BUTTON_NAME: b_btn.name,
        DYXX_DATA: Ext.util.JSON.encode($.extend({
            XM_ID: xmxxForm.getForm().findField('XM_ID').getValue(),
            FX_AMT: xmxxForm.getForm().findField('FX_AMT').getValue()
        }, dyxxForm.getForm().getValues())),
        ZQXX_DATA: Ext.util.JSON.encode(zqxxData)
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
    var dyxxForm = Ext.ComponentQuery.query('form#dyxxWindow_dyxx_form')[0].getForm();
    //时间校验
    var startDate = dyxxForm.findField('START_DATE').getValue();
    var endDate = dyxxForm.findField('END_DATE').getValue();
    if (startDate && endDate && startDate > endDate) {
        array.push('调研时间起不能大于调研时间止！');
    }
    //内容长度校验
    var checkFieldLengthArray = ['BFQK', 'ZJYE', 'CZWT', 'WTYY', 'JJCS', 'ZGJY', 'ZGXG'];
    for (var i in checkFieldLengthArray) {
        var content = dyxxForm.findField(checkFieldLengthArray[i]).getValue();
        if (getStringLength(content) > 1000) {
            array.push(dyxxForm.findField(checkFieldLengthArray[i]).getFieldLabel() + '请在500字以内！');
        }
    }
    return array.join('<br>');
}

/**
 * 修改项目调研信息
 */
function updateXmdyInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
        btn.setDisabled(false);
        return;
    }
    var guid = records[0].get('GUID');
    // 根据zcdId获取部门支出信息
    $.post("/xmgl/xmdy/getXmdyInfo.action", {
        GUID: guid
    }, function (data) {
        if (data.success) {
            var dyxxWindow = initDyxxWindow(btn, guid);
            //债券信息表格赋值
            var zqxxGrid = DSYGrid.getGrid('dyxxWindow_zqxx_grid');
            zqxxGrid.insertData(null, data.zqxm);
            //项目信息表单赋值
            Ext.ComponentQuery.query('form#dyxxWindow_xmxx_form')[0].getForm().setValues({
                XM_ID: data.dyxx.XM_ID,
                XM_NAME: data.dyxx.XM_NAME,
                FX_AMT: zqxxGrid.getStore().sum('FX_AMT')
            });
            //调研信息表单赋值
            Ext.ComponentQuery.query('form#dyxxWindow_dyxx_form')[0].getForm().setValues(data.dyxx);
            dyxxWindow.show();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        btn.setDisabled(false);
    }, "json");
}

/**
 * 删除项目调研信息
 */
function deleteXmdyInfo(btn) {
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
            $.post("/xmgl/xmdy/deleteXmdyInfo.action", {
                GUIDS: guids
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
 * 刷新主表格
 */
function reloadGrid() {
    var xmlxId = Ext.ComponentQuery.query("treecombobox[name='XMLX_ID']")[0].getValue();
    var jsztId = Ext.ComponentQuery.query("treecombobox[name='JSZT_ID']")[0].getValue();
    var startDate = Ext.ComponentQuery.query("datefield[name='START_DATE']")[0].getValue();
    var endDate = Ext.ComponentQuery.query("datefield[name='END_DATE']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('contentGrid').getStore();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        XMLX_ID: xmlxId,
        JSZT_ID: jsztId,
        START_DATE: startDate,
        END_DATE: endDate,
        MHCX: mhcx
    };
    store.loadPage(1);
}
