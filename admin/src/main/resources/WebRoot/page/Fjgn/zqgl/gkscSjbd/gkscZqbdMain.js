/**
 * 页面初始化
 */
$(document).ready(function () {
    initContent();
});

/**
 * 初始化主面板
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        width: '100%',
        height: '100%',
        renderTo: Ext.getBody(), // 渲染到body
        layout: {
            type: 'vbox',//竖直布局 item 有一个 flex属性
            align: 'stretch' //拉伸使其充满整个父容器
        },
        dockedItems: [  // 功能操作状态按钮
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: [
                    {
                        text: '查询',
                        name: 'search',
                        xtype: 'button',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            reloadGrid();
                        }
                    },
                    {
                        text: '录入',
                        name: 'add',
                        xtype: 'button',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.name;
                            button_text = btn.text;
                            gkscZqxx_selWindow(btn); // 调用公开市场债券信息展示框
                        }
                    },
                    {
                        text: '修改',
                        name: 'update',
                        xtype: 'button',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('zqbd_contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                button_name = btn.name;
                                button_text = btn.text;
                                gkscZqxx_addWindow(btn);
                                var gkscZqxx_addForm = Ext.ComponentQuery.query('form[itemId="gkscZqxx_addWindow_formPanel"]')[0];
                                var gkscZqxx_addFormRecords = records[0].getData();
                                gkscZqxx_addForm.getForm().setValues(gkscZqxx_addFormRecords);
                                zqbd_bill_id = records[0].getData().ZQBD_BILL_ID;
                                DSYGrid.getGrid('gkscZqxx_addWindow_grid').getStore().getProxy().extraParams['ZQBD_BILL_ID'] = records[0].getData().ZQBD_BILL_ID;
                                DSYGrid.getGrid('gkscZqxx_addWindow_grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        text: '删除',
                        name: 'del',
                        xtype: 'button',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            button_name = btn.name;
                            button_text = btn.text;
                            delGkscBdInfo(btn);
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            }
        ],
        items: [
            initContentGrid(),
            initContentDtlGrid()
        ]
    });
}

/**
 * 初始化panel主表格
 */
function initContentGrid() {
    var content_HeaderJson = [
        {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
        {
            type: "string",
            text: "债券ID",
            dataIndex: "ZQ_ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "ZQ_CODE",
            type: "string",
            text: "债券编码",
            width: 100
        },
        {
            dataIndex: "ZQ_NAME",
            type: "string",
            text: "债券名称",
            width: 300
        },
        {
            dataIndex: "FX_AMT", type: "float", text: "发行金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "新增金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZH_AMT", type: "float", text: "置换金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "HB_AMT", type: "float", text: "再融资金额（万元）", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZQLB_NAME",
            type: "string",
            text: "债券类型",
            width: 150
        },
        {
            dataIndex: "ZQQX_NAME",
            type: "string",
            text: "债券期限",
            width: 100
        },
        {
            dataIndex: "FX_START_DATE",
            type: "string",
            text: "发行日期",
            width: 100
        },
        {
            dataIndex: "QX_DATE",
            type: "string",
            text: "起息日期",
            width: 100
        }
    ];
    var grid = DSYGrid.createGrid({
        flex: 1,
        itemId: 'zqbd_contentGrid',
        autoLoad: true, // 自动加载
        rowNumber: true,  //显示行号
        border: false, // 不显示边框
        checkBox: true, // 显示复选框
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "MHCX",
                labelWidth: 80,
                width: 300,
                emptyText: '请输入债券名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            reloadGrid();
                        }
                    }
                }
            }
        ],
        headerConfig: {
            headerJson: content_HeaderJson,  // 构建列头信息
            columnAutoWidth: false // 不自动调整列宽
        },
        dataUrl: 'getGkscBdxxMainInfo.action',
        params: {},
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        listeners: {
            itemclick: function (self, record) {
                DSYGrid.getGrid('zqbd_contentDtlGrid').getStore().getProxy().extraParams['ZQBD_BILL_ID'] = record.get('ZQBD_BILL_ID');
                DSYGrid.getGrid('zqbd_contentDtlGrid').getStore().loadPage(1);
            }
        }
    });
    return grid;
}

/**
 * 初始化Panel明细表格
 */
function initContentDtlGrid() {
    var contentDtl_HeaderJson = [
        {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
        {
            dataIndex: "ZW_ID",
            type: "string",
            text: "债务ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "ZW_XY_NO",
            type: "string",
            text: "协议号",
            width: 200
        },
        {
            dataIndex: "ZW_CODE",
            type: "string",
            text: "债务编码",
            width: 200
        },
        {
            dataIndex: "ZW_NAME",
            type: "string",
            text: "债务名称",
            width: 300
        },
        {
            dataIndex: "XY_AMT", type: "float", text: "协议金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额人民币（万元）", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SIGN_DATE",
            type: "string",
            text: "签订日期",
            width: 100
        },
        {
            dataIndex: "ZWQX_NAME",
            type: "string",
            text: "债务期限",
            width: 100
        },
        {
            dataIndex: "WB_NAME",
            type: "string",
            text: "币种",
            width: 150
        },
        {
            dataIndex: "HL_RATE",
            type: "string",
            text: "汇率",
            width: 100
        }
    ];
    return DSYGrid.createGrid({
        flex: 1,
        itemId: 'zqbd_contentDtlGrid',
        autoLoad: false, // 不自动加载
        checkBox: false, // 不显示复选框
        border: false,  // 不显示边框
        headerConfig: {
            headerJson: contentDtl_HeaderJson, // 构建列头信息
            columnAutoWidth: false // 不自动调整列宽
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getGkscBdxxDtlInfo.action',
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 *  刷新主面板
 */
function reloadGrid() {
    var gridStore = DSYGrid.getGrid('zqbd_contentGrid').getStore();
    gridStore.removeAll();
    var mhcx = Ext.ComponentQuery.query('textfield[itemId="MHCX"]')[0].getValue();
    gridStore.getProxy().extraParams = {
        MHCX: mhcx
    };
    //刷新
    gridStore.loadPage(1);
    //刷新明细表
    DSYGrid.getGrid('zqbd_contentDtlGrid').getStore().removeAll();
}

/**
 * 操作记录的函数
 **/
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var contentGrid_ID = records[0].get("XMTZ_BILL_ID");
        fuc_getWorkFlowLog(contentGrid_ID);
    }
}

/**
 * 删除主表格信息
 */
function delGkscBdInfo(btn) {

    // 检验是否选中数据
    var records = DSYGrid.getGrid('zqbd_contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            var ids = [];
            for (var i in records) {
                ids.push(records[i].get("ZQBD_BILL_ID"));
            }
            //发送ajax请求，删除数据
            $.post("/delGkscBdInfo.action", {
                ids: ids
            }, function (data) {
                if (data.success) {
                    Ext.toast({html: button_text + "成功！"});
                } else {
                    Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                }
                //刷新表格
                reloadGrid();
            }, "json");
        }
    });
}

/**
 * 初始化公开市场债券信息展示框
 * @param btn
 */
function gkscZqxx_selWindow(btn) {
    var gkscZqxx_selWindow = Ext.create('Ext.window.Window', {
        title: '公开市场债券信息', // 窗口标题
        itemId: 'gkscZqxx_selwindow', // 窗口标识
        layout: 'fit',
        width: document.body.clientWidth * 0.9, // 自适应窗口宽度
        height: document.body.clientHeight * 0.9, // 自适应窗口高度
        frame: true,
        constrain: true, // 防止超出浏览器边界
        maximizable: true, // 最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        buttonAlign: "right", // 按钮显示的位置：右下侧
        closeAction: 'destroy', //hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [gkscZqxx_selWindow_Grid(btn)],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('gkscZqxx_selWindow_Grid').getSelection(); // 获取当前选中行数据
                    if (records.length < 1) {
                        Ext.toast({
                            html: "请选择至少一条数据后再进行操作!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else {
                        gkscZqxx_addWindow(btn); // 调用并初始化公开市场债券信息比对填报框
                        var gkscZqxx_addForm = Ext.ComponentQuery.query('form[itemId="gkscZqxx_addWindow_formPanel"]')[0];
                        var gkscZqxx_addFormRecords = records[0].getData();
                        var ZQBD_BILL_ID = GUID.createGUID();
                        zqbd_bill_id = ZQBD_BILL_ID;
                        gkscZqxx_addFormRecords.ZQBD_BILL_ID = ZQBD_BILL_ID;
                        gkscZqxx_addForm.getForm().setValues(gkscZqxx_addFormRecords);
                        btn.up('window').close();
                    }
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
    return gkscZqxx_selWindow.show();
}

/**
 * 加载公开市场债券信息grid
 */
function gkscZqxx_selWindow_Grid() {
    var gkscZqxx_grid_headerjson = [
        {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
        {
            type: "string",
            text: "债券ID",
            dataIndex: "ZQ_ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "ZQ_CODE",
            type: "string",
            text: "债券编码",
            width: 100
        },
        {
            dataIndex: "ZQ_NAME",
            type: "string",
            text: "债券名称",
            width: 300
        },
        {
            dataIndex: "FX_AMT", type: "float", text: "发行金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "新增金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZH_AMT", type: "float", text: "置换金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "HB_AMT", type: "float", text: "再融资金额（万元）", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZQLB_NAME",
            type: "string",
            text: "债券类型",
            width: 150
        },
        {
            dataIndex: "ZQQX_NAME",
            type: "string",
            text: "债券期限",
            width: 100
        },
        {
            dataIndex: "FX_START_DATE",
            type: "string",
            text: "发行日期",
            width: 100
        },
        {
            dataIndex: "QX_DATE",
            type: "string",
            text: "起息日期",
            width: 100
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'gkscZqxx_selWindow_Grid',
        flex: 1,
        height: '100%',
        border: false,
        checkBox: true,
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "MHCX",
                labelWidth: 80,
                width: 300,
                emptyText: '请输入债券名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            var mhcx = self.up('grid').down('textfield[itemId="MHCX"]').getValue();
                            store.getProxy().extraParams['MHCX'] = mhcx;
                            store.load();
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var mhcx = btn.up('grid').down('textfield[itemId="MHCX"]').getValue();
                    store.getProxy().extraParams['MHCX'] = mhcx;
                    store.load();
                }
            }
        ],
        headerConfig: {
            headerJson: gkscZqxx_grid_headerjson,  // 构建列头信息
            columnAutoWidth: false // 列宽不自动调整
        },
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        selModel: {       //复选框形式，只能单选
            selType: 'rowmodel',
            mode: "MULTI"
        },
        dataUrl: 'getGkscZqxxInfo.action',
        params: {}
    });
}

/**
 * 初始化公开市场债券信息比对填报框
 */
function gkscZqxx_addWindow(btn) {
    var gkscZqxx_addWindow = Ext.create('Ext.window.Window', {
        title: '公开市场债券信息比对填报框', // 窗口标题
        itemId: 'gkscZqxx_addWindow', // 窗口标识
        layout: 'fit',
        width: document.body.clientWidth * 0.9, // 自适应窗口宽度
        height: document.body.clientHeight * 0.9, // 自适应窗口高度
        frame: true,
        constrain: true, // 防止超出浏览器边界
        maximizable: true, // 最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        buttonAlign: "right", // 按钮显示的位置：右下侧
        closeAction: 'destroy', //hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [gkscZqxx_addWindow_formPanel(btn)],
        buttons: [
            {
                text: '新增',
                id: 'addBtn',
                name: 'addBtn',
                handler: function (btn) {
                    clZqxx_selWindow(btn)
                }
            },
            {
                text: '删除',
                id: 'delBtn',
                name: 'delBtn',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('gkscZqxx_addWindow_grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel().getSelection();
                    if (sm.length < 1) {
                        Ext.toast({
                            html: "请选择至少一条数据后再进行操作!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else {
                        grid.getView().refresh();
                        store.remove(sm);
                    }
                }
            },
            {
                text: '保存',
                name: 'save',
                handler: function (btn) {
                    submitGkscZqxx(btn);
                }
            },
            {
                text: '取消',
                name: 'close',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    return gkscZqxx_addWindow.show();
}

/**
 * 提交数据
 */
function submitGkscZqxx(btn) {
    //获取实际收益情况表单
    var gkscZqxx_addWindow = btn.up('window');
    var gkscZqxx_addForm = gkscZqxx_addWindow.down('form');
    var gkscZqxx_addGridStore = gkscZqxx_addWindow.down('grid').getStore();
    if (gkscZqxx_addGridStore.getCount() <= 0) {
        Ext.Msg.alert('提示', "明细中必须录入数据！");
        return false;
    }
    var gkscZqxx_addGrid = [];
    gkscZqxx_addGridStore.each(function (record) {
        gkscZqxx_addGrid.push(record.getData());
    });
    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    $.post('/saveGkscZqxxInfo.action', {
        button_name: button_name,
        button_text: button_text,
        gkscZqxx_addGrid: Ext.util.JSON.encode(gkscZqxx_addGrid),
        gkscZqxx_addForm: Ext.util.JSON.encode([gkscZqxx_addForm.getValues()])
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            // 刷新表格
            reloadGrid()
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
        //刷新表格
    }, "json");
}

/**
 * 初始化公开市场债券信息比对填报框FromPanel
 */
function gkscZqxx_addWindow_formPanel() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        itemId: 'gkscZqxx_addWindow_formPanel',
        layout: 'vbox',
        fileUpload: true,
        border: false,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        items: [
            {
                xtype: 'container',
                flex: 1,
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 140 // 控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        name: "ZQBD_BILL_ID",
                        fieldLabel: '虚拟主单id',
                        allowBlank: false, // 不允许为空
                        editable: false, // 不允许编辑
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_ID",
                        fieldLabel: '债券ID',
                        allowBlank: false,// 不允许为空
                        editable: false, // 不允许编辑
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_NAME",
                        fieldLabel: '债券名称',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        allowBlank: false,// 不允许为空
                        editable: false // 不允许编辑
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_CODE",
                        fieldLabel: '债券编码',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        allowBlank: false,// 不允许为空
                        editable: false // 不允许编辑
                    },
                    {
                        xtype: "textfield",
                        name: "ZQQX_NAME",
                        fieldLabel: '债券期限',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        allowBlank: false,// 不允许为空
                        editable: false // 不允许编辑
                    },
                    {
                        xtype: "textfield",
                        name: "ZQLB_NAME",
                        fieldLabel: '债券类型',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        allowBlank: false,// 不允许为空
                        editable: false // 不允许编辑
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "FX_AMT",
                        fieldLabel: '发行金额（万元）',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        decimalPrecision: 6, // 设置金额保留小数位数
                        emptyText: '0.000000', // 设置输入框水印信息
                        allowDecimals: true, //设置允许录入小数
                        hideTrigger: true, // xtype为combobox一旦设hideTrigger:true不让下拉按钮隐藏
                        keyNavEnabled: true, // 设置是否允许键盘调整数值
                        mouseWheelEnabled: true, // 设置是否允许鼠标滚动调整数值
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "XZ_AMT",
                        fieldLabel: '新增金额（万元）',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        decimalPrecision: 6, // 设置金额保留小数位数
                        emptyText: '0.000000', // 设置输入框水印信息
                        allowDecimals: true, //设置允许录入小数
                        hideTrigger: true, // xtype为combobox一旦设hideTrigger:true不让下拉按钮隐藏
                        keyNavEnabled: true, // 设置是否允许键盘调整数值
                        mouseWheelEnabled: true, // 设置是否允许鼠标滚动调整数值
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZH_AMT",
                        fieldLabel: '置换金额（万元）',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        decimalPrecision: 6, // 设置金额保留小数位数
                        emptyText: '0.000000', // 设置输入框水印信息
                        allowDecimals: true, //设置允许录入小数
                        hideTrigger: true, // xtype为combobox一旦设hideTrigger:true不让下拉按钮隐藏
                        keyNavEnabled: true, // 设置是否允许键盘调整数值
                        mouseWheelEnabled: true, // 设置是否允许鼠标滚动调整数值
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "HB_AMT",
                        fieldLabel: '再融资金额（万元）',
                        fieldStyle: 'background:#E6E6E6', // 置灰，不可编辑
                        decimalPrecision: 6, // 设置金额保留小数位数
                        emptyText: '0.000000', // 设置输入框水印信息
                        allowDecimals: true, //设置允许录入小数
                        hideTrigger: true, // xtype为combobox一旦设hideTrigger:true不让下拉按钮隐藏
                        keyNavEnabled: true, // 设置是否允许键盘调整数值
                        mouseWheelEnabled: true, // 设置是否允许鼠标滚动调整数值
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    }
                ]
            },
            { //分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                flex: 3,
                collapsible: false,
                layout: 'fit',
                items: [
                    gkscZqxx_addWindow_grid()
                ]
            }
        ]
    });
}

/**
 * 初始化公开市场债券信息比对填报框grid
 */
function gkscZqxx_addWindow_grid() {
    var gkscZqxx_addWindow_grid_HeaderJson = [
        {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
        {
            dataIndex: "ZQBD_BILL_DTLID",
            type: "string",
            text: "存量债务ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "ZW_ID",
            type: "string",
            text: "债务ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "ZW_XY_NO",
            type: "string",
            text: "协议号",
            width: 200
        },
        {
            dataIndex: "ZW_CODE",
            type: "string",
            text: "债务编码",
            width: 200
        },
        {
            dataIndex: "ZW_NAME",
            type: "string",
            text: "债务名称",
            width: 300
        },
        {
            dataIndex: "XY_AMT", type: "float", text: "协议金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额人民币（万元）", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SIGN_DATE",
            type: "string",
            text: "签订日期",
            width: 100
        },
        {
            dataIndex: "ZWQX_NAME",
            type: "string",
            text: "债务期限",
            width: 100
        },
        {
            dataIndex: "WB_NAME",
            type: "string",
            text: "币种",
            width: 150
        },
        {
            dataIndex: "HL_RATE",
            type: "string",
            text: "汇率",
            width: 100
        }
    ];
    return DSYGrid.createGrid({
        flex: 1,
        itemId: 'gkscZqxx_addWindow_grid',
        autoLoad: false, // 不自动加载
        checkBox: true, // 显示复选框
        border: false,  // 不显示边框
        headerConfig: {
            headerJson: gkscZqxx_addWindow_grid_HeaderJson, // 构建列头信息
            columnAutoWidth: false // 列宽不自动调整
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getGkscBdxxDtlInfo.action',
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 * 初始化存量债务中债券类型为地方政府债券类型的债务信息弹框
 */
function clZqxx_selWindow(btn) {
    return Ext.create('Ext.window.Window', {
        title: '存量政府债务信息', // 窗口标题
        itemId: 'clZqxx_selWindow', // 窗口标识
        layout: 'fit',
        width: document.body.clientWidth * 0.9, // 自适应窗口宽度
        height: document.body.clientHeight * 0.9, // 自适应窗口高度
        frame: true,
        constrain: true, // 防止超出浏览器边界
        maximizable: true, // 最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        buttonAlign: "right", // 按钮显示的位置：右下侧
        closeAction: 'destroy', //hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [clZqxx_selWindow_Grid(btn)],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('clZqxx_selWindow_Grid').getSelection(); // 获取当前选中行数据
                    if (records.length < 1) {
                        Ext.toast({
                            html: "请选择至少一条数据后再进行操作!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else {
                        var gkscZqxx_addWindow_grid = DSYGrid.getGrid('gkscZqxx_addWindow_grid').getStore();
                        for (var i = 0; i < records.length; i++) {
                            if (!clzwHave(i, records)) {
                                var recordData = records[i];
                                recordData.data.ZQBD_BILL_DTLID = GUID.createGUID();
                                gkscZqxx_addWindow_grid.insertData(null, recordData);
                            } else {
                                return Ext.toast({
                                    html: "已存在该笔债务信息，请选择其他债务信息!",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            }
                        }
                        btn.up('window').close();
                    }
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}

/**
 * 校验填报框是存在债务信息
 */
function clzwHave(i, records) {
    var have = false;
    var gkscZqxx_addWindow_grid = DSYGrid.getGrid('gkscZqxx_addWindow_grid');// 获取填报框grid
    if (gkscZqxx_addWindow_grid == null || gkscZqxx_addWindow_grid == undefined) {
        Ext.MessageBox.alert('提示', '无法获取填报框明细单，请检查是否加载成功!');
        return false;
    }
    for (var j = 0; j < gkscZqxx_addWindow_grid.getStore().getCount(); j++) {
        if (records[i].data["ZW_ID"] == gkscZqxx_addWindow_grid.getStore().getAt(j).data["ZW_ID"]) {
            return true;
        }
    }
    return have;
}

/**
 * 初始化存量债务中债券类型为地方政府债券类型的债务信息grid
 */
function clZqxx_selWindow_Grid() {
    var clZqxx_selWindow_headerjson = [
        {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
        {
            dataIndex: "ZW_ID",
            type: "string",
            text: "债务ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "ZW_XY_NO",
            type: "string",
            text: "协议号",
            width: 200
        },
        {
            dataIndex: "ZW_CODE",
            type: "string",
            text: "债务编码",
            width: 200
        },
        {
            dataIndex: "ZW_NAME",
            type: "string",
            text: "债务名称",
            width: 300
        },
        {
            dataIndex: "XY_AMT", type: "float", text: "协议金额（万元）", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额人民币（万元）", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SIGN_DATE",
            type: "string",
            text: "签订日期",
            width: 100
        },
        {
            dataIndex: "ZWQX_NAME",
            type: "string",
            text: "债务期限",
            width: 100
        },
        {
            dataIndex: "WB_NAME",
            type: "string",
            text: "币种",
            width: 150
        },
        {
            dataIndex: "HL_RATE",
            type: "string",
            text: "汇率",
            width: 100
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'clZqxx_selWindow_Grid',
        flex: 1,
        height: '100%',
        border: false,
        checkBox: true,
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "MHCX",
                labelWidth: 80,
                width: 300,
                emptyText: '请输入债务名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            var mhcx = self.up('grid').down('textfield[itemId="MHCX"]').getValue();
                            store.getProxy().extraParams['MHCX'] = mhcx;
                            store.load();
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var mhcx = btn.up('grid').down('textfield[itemId="MHCX"]').getValue();
                    store.getProxy().extraParams['MHCX'] = mhcx;
                    store.load();
                }
            }
        ],
        headerConfig: {
            headerJson: clZqxx_selWindow_headerjson,  // 构建列头信息
            columnAutoWidth: false // 列宽不自动调整
        },
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        // selModel:{       //复选框形式，只能单选
        //     selType:'rowmodel',
        //     mode:"MULTI"
        // },
        dataUrl: 'getClZqxxInfo.action',
        params: {ZQBD_BILL_ID: zqbd_bill_id}
    });
}