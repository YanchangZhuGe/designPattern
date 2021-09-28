/**
 * js：新增债券项目排序
 * Created by yb on 2016/8/11.
 */
var BATCH_NO = null;//申报批次
var opstatus = '0';//申报批次
/**
 * 默认数据：工具栏
 */
$.extend(zqxm_json_common, {
    items: {
        '001': [
            {
                text: '查询', name: 'query', xtype: 'button', icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadPxGridByParams();
                }
            },
            {
                text: '保存', name: 'save', xtype: 'button', icon: '/image/sysbutton/save.png',
                handler: function () {
                    saveSerialNumber();
                }
            },
            {
                text: '撤销排序', name: 'cancel', xtype: 'button', icon: '/image/sysbutton/cancel.png', hidden: true,
                handler: function () {
                    cancelSerialNumber();
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    var table_name = 'WpxGrid';
                    if (opstatus == '1') {
                        table_name = 'YpxGrid';
                    }
                    var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                    var sbbatch_no = toolbar.down('treecombobox[name="SBBATCH_NO"]').getValue();
                    DSYGrid.exportExcelClick(table_name, {
                        exportExcel: true,
                        url: 'zqjhpxDetailDataExport.action',
                        param: {
                            IS_FXJH: is_fxjh,
                            OPSTATUS: opstatus,
                            SBBATCH_NO: sbbatch_no,
                            AD_CODE: AD_CODE,
                            AG_CODE: AG_CODE
                        }
                    });
                }
            },
            {
                xtype: 'treecombobox',
                name: 'SBBATCH_NO',
                fieldLabel: '申报批次',
                displayField: 'name',
                valueField: 'id',
                store: DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND1 like '01%' OR EXTEND1 IS NULL) and EXTEND2 =" + is_fxjh}),
                listeners: {
                    'change': function (self, newValue) {
                        //刷新当前表格
                        reloadPxGridByParams();
                    }
                }
            },
            {
                xtype: "combobox",
                name: 'LXND_SEARCH',
                itemId: "LXND_SEARCH",   //项目立项年度
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2000' and code <= '2020' "}),
                fieldLabel: '申报年度',
                displayField: 'name',
                valueField: 'id',
                hidden: true,
                // value:  new Date().getFullYear(),
                editable: false,
                allowBlank: false,
                listeners: {
                    select: function (btn) {
                        //刷新当前表格
                        reloadPxGridByParams();
                    }
                }
            },

            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    items_content_rightPanel_items: function () {
        return [
            initContentTabPanel()
        ]
    },
    reloadGrid: function (param) {
        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
        var LXND_SEARCH = toolbar.down('combobox[name="LXND_SEARCH"]').getValue();
        var sbbatch_no = toolbar.down('treecombobox[name="SBBATCH_NO"]').getValue();
        //刷新未排序表格
        var wpxGrid = DSYGrid.getGrid('WpxGrid');
        var wpxStore = wpxGrid.getStore();
        wpxStore.getProxy().extraParams["AD_CODE"] = AD_CODE;
        wpxStore.getProxy().extraParams["AG_CODE"] = AG_CODE;
        wpxStore.getProxy().extraParams["bond_type_id"] = bond_type_id;
        wpxStore.getProxy().extraParams["LXND_SEARCH"] = LXND_SEARCH;
        wpxStore.getProxy().extraParams["SBBATCH_NO"] = sbbatch_no;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                wpxStore.getProxy().extraParams[name] = param[name];
            }
        }
        wpxStore.load();

        //刷新已排序表格
        var ypxGrid = DSYGrid.getGrid('YpxGrid');
        var ypxStore = ypxGrid.getStore();
        ypxStore.getProxy().extraParams["AD_CODE"] = AD_CODE;
        ypxStore.getProxy().extraParams["AG_CODE"] = AG_CODE;
        ypxStore.getProxy().extraParams["bond_type_id"] = bond_type_id;
        ypxStore.getProxy().extraParams["LXND_SEARCH"] = LXND_SEARCH;
        ypxStore.getProxy().extraParams["SBBATCH_NO"] = sbbatch_no;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                ypxStore.getProxy().extraParams[name] = param[name];
            }
        }
        ypxStore.load();
    }
});

/**
 * 初始化右侧操作区域
 */
function initContentTabPanel() {
    var tabPanel = Ext.create('Ext.tab.Panel', {
        name: 'PxTabPanel',
        layout: 'fit',
        flex: 1,
        border: false,
        defaults: {
            layout: 'fit',
            border: false
        },
        items: [
            {title: '未排序', opstatus: 0, items: initWpxGrid()},
            {title: '已排序', opstatus: 1, items: initYpxGrid()}
        ],
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                if (toolbar) {
                    opstatus = newCard.opstatus;
                    toolbar.down('button[name=save]').setHidden(newCard.opstatus != 0);
                    toolbar.down('button[name=cancel]').setHidden(newCard.opstatus != 1);
                }
            }
        }
    });
    return tabPanel;
}

/**
 * 初始化未排序表格
 */
function initWpxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "ID", width: 100, type: "string", text: "申请单据ID", hidden: true},
        {dataIndex: "JHGL_END", width: 100, type: "string", text: "申请单据ID"},
        {
            text: "排序号", dataIndex: "SORT_NO", width: 100, type: "int",
            renderer: function (value) {
                if (value == '0') {
                    value = ''
                }
                return value;
            }
        },
        {dataIndex: "AG_NAME", width: 250, type: "string", text: "申报单位"},
        {dataIndex: "XM_ID", width: 200, type: "string", text: "项目ID", hidden: true},
        {
            text: "项目名称", dataIndex: "XM_NAME", width: 250, type: "string",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                 return '<a href="' + hrefUrl + '" target="_blank">' + data + '</a>';*/
                return '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('ID') + '\')">' + data + '</a>';
            }
        },
        {dataIndex: "XM_CODE", width: 200, type: "string", text: "项目编码"},
        {dataIndex: "BILL_YEAR", width: 100, type: "string", text: "年度"},
        {dataIndex: "BOND_TYPE_NAME", width: 100, type: "string", text: "申请类型"},
        {dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额", hidden: true},
        {dataIndex: "APPLY_AMOUNT1", width: 160, type: "float", text: "申请金额(元)"},
        {dataIndex: "RETURN_CAPITAL", width: 160, type: "float", text: "其中用于偿还本金", hidden: true},
        {dataIndex: "BILL_NO", width: 150, type: "string", text: "申报单号"},
        {dataIndex: "APPLY_DATE", width: 100, type: "string", text: "申报日期"},
        {dataIndex: "APPLY_INPUTOR", width: 100, type: "string", text: "经办人"},
        {dataIndex: "LX_YEAR", width: 100, type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", width: 100, type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", width: 160, type: "string", text: "项目类型"},
        {dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算"},
        {dataIndex: "ZWYE", width: 160, type: "float", text: "债务余额"},
        {dataIndex: "START_DATE_PLAN", width: 120, type: "string", text: "计划开工日期"},
        {dataIndex: "END_DATE_PLAN", width: 120, type: "string", text: "计划竣工日期"},
        {dataIndex: "START_DATE_ACTUAL", width: 120, type: "string", text: "实际开工日期"},
        {dataIndex: "END_DATE_ACTUAL", width: 120, type: "string", text: "实际竣工日期"},
        {dataIndex: "BUILD_STATUS_NAME", width: 100, type: "string", text: "建设状态"},
        {dataIndex: "FILTER_STATUS_NAME", width: 100, type: "string", text: "项目状态"},
        {dataIndex: "FIRST_BILL", width: 100, type: "string", text: "是否第一单标志", hidden: true}
    ];
    var config = {
        itemId: 'WpxGrid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        sortableColumns: false, //去除列头排序
        height: '100%',
        pageConfig: {
            enablePage: false
        },
        dataUrl: 'getWpxGrid.action',
        params: {
            BATCH_NO: BATCH_NO,
            bond_type_id: bond_type_id,
            IS_FXJH: is_fxjh
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                    }
                }
            }
        ],
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'right',
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [
                    {
                        text: '置顶',
                        handler: function () {
                            var grid = DSYGrid.getGrid('WpxGrid');
                            var store = grid.getStore();
                            var records = grid.getSelectionModel().getSelection();
                            for (var i in records) {
                                var record = records[i];
                                var index = store.indexOf(record);
                                if (index > 0) {
                                    store.removeAt(index);
                                    grid.insertData(0, record);
                                    grid.getSelectionModel().selectRange(0, 0);
                                }
                            }
                        }
                    },
                    {
                        text: '置底',
                        handler: function () {
                            var grid = DSYGrid.getGrid('WpxGrid');
                            var store = grid.getStore();
                            var records = grid.getSelectionModel().getSelection();
                            for (var i in records) {
                                var record = records[i];
                                var index = store.indexOf(record);
                                if (index < store.getCount() - 1) {
                                    store.removeAt(index);
                                    grid.insertData(store.getCount(), record);
                                    grid.getSelectionModel().selectRange(store.getCount() - 1, store.getCount() - 1);
                                }
                            }
                        }
                    },
                    {
                        text: '上移',
                        handler: function () {
                            var grid = DSYGrid.getGrid('WpxGrid');
                            var store = grid.getStore();
                            var records = grid.getSelectionModel().getSelection();
                            for (var i in records) {
                                var record = records[i];
                                var index = store.indexOf(record);
                                if (index > 0) {
                                    store.removeAt(index);
                                    grid.insertData(index - 1, record);
                                    grid.getSelectionModel().selectRange(index - 1, index - 1);
                                }
                            }
                        }
                    },
                    {
                        text: '下移',
                        handler: function () {
                            var grid = DSYGrid.getGrid('WpxGrid');
                            var store = grid.getStore();
                            var records = grid.getSelectionModel().getSelection();
                            for (var i in records) {
                                var record = records[i];
                                var index = store.indexOf(record);
                                if (index < store.getCount() - 1) {
                                    store.removeAt(index);
                                    grid.insertData(index + 1, record);
                                    grid.getSelectionModel().selectRange(index + 1, index + 1);
                                }
                            }
                        }
                    },
                    {
                        text: '清空序号',
                        handler: function () {
                            dropSerialNumber();
                        }
                    },
                    {
                        text: '自动编号',
                        handler: function () {
                            createSerialNumber();
                        }
                    },
                    {
                        text: '插队至',
                        handler: function () {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('WpxGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录!');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '每次只能对一条记录进行操作!');
                                return;
                            } else {
                                var jjxxWindow = new Ext.Window({
                                    title: '输入框',
                                    width: 300,
                                    height: 130,
                                    frame: true,
                                    constrain: true,
                                    layout: 'fit',
                                    buttonAlign: "center", // 按钮显示的位置
                                    modal: true,
                                    resizable: false,//大小不可改变
                                    plain: true,
                                    items: [
                                        {
                                            xtype: 'panel',
                                            border: false,
                                            layout: {
                                                type: 'vbox',
                                                align: 'middle'
                                            },
                                            defaults: {
                                                padding: 10,
                                                width: '90%'
                                            },
                                            items: [
                                                {
                                                    fieldLabel: '插队至', xtype: 'numberFieldFormat', name: 'jumpNumber',
                                                    labelWidth: 50, allowDecimals: false, hideTrigger: true
                                                }
                                            ]
                                        }
                                    ],
                                    buttons: [
                                        {
                                            text: '确定',
                                            handler: function (btn) {
                                                var jumpNum = Ext.ComponentQuery.query('numberFieldFormat[name="jumpNumber"]')[0].value;
                                                jumpSerialNumber(jumpNum);
                                                btn.up('window').close();
                                            }
                                        },
                                        {
                                            text: '关闭',
                                            handler: function (btn) {
                                                btn.up('window').close();
                                            }
                                        }
                                    ],
                                    closeAction: 'destroy'
                                });
                                jjxxWindow.show();
                            }
                        }
                    }
                ]
            }
        ]
    };
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 初始化已排序表格
 */
function initYpxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "ID", width: 100, type: "string", text: "申请单据ID", hidden: true},
        {dataIndex: "JHGL_END", width: 100, type: "string", text: "申请单据ID"},
        {dataIndex: "SORT_NO", width: 100, type: "int", text: "排序号"},
        {dataIndex: "AG_NAME", width: 250, type: "string", text: "申报单位"},
        {dataIndex: "XM_ID", width: 200, type: "string", text: "项目ID", hidden: true},
        {dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称"},
        {dataIndex: "XM_CODE", width: 200, type: "string", text: "项目编码"},
        {dataIndex: "BILL_YEAR", width: 100, type: "string", text: "年度"},
        {dataIndex: "BOND_TYPE_NAME", width: 100, type: "string", text: "申请类型"},
        {dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额", hidden: true},
        {dataIndex: "APPLY_AMOUNT1", width: 160, type: "float", text: "申请金额(元)"},
        {dataIndex: "RETURN_CAPITAL", width: 160, type: "float", text: "其中用于偿还本金", hidden: true},
        {dataIndex: "BILL_NO", width: 150, type: "string", text: "申报单号"},
        {dataIndex: "APPLY_DATE", width: 100, type: "string", text: "申报日期"},
        {dataIndex: "APPLY_INPUTOR", width: 100, type: "string", text: "经办人"},
        {dataIndex: "LX_YEAR", width: 100, type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", width: 100, type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", width: 160, type: "string", text: "项目类型"},
        {dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算"},
        {dataIndex: "ZWYE", width: 160, type: "float", text: "债务余额"},
        {dataIndex: "START_DATE_PLAN", width: 120, type: "string", text: "计划开工日期"},
        {dataIndex: "END_DATE_PLAN", width: 120, type: "string", text: "计划竣工日期"},
        {dataIndex: "START_DATE_ACTUAL", width: 120, type: "string", text: "实际开工日期"},
        {dataIndex: "END_DATE_ACTUAL", width: 120, type: "string", text: "实际竣工日期"},
        {dataIndex: "BUILD_STATUS_NAME", width: 100, type: "string", text: "建设状态"},
        {dataIndex: "FILTER_STATUS_NAME", width: 100, type: "string", text: "项目状态"},
        {dataIndex: "FIRST_BILL", width: 100, type: "string", text: "是否第一单标志", hidden: true}
    ];
    var config = {
        itemId: 'YpxGrid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        sortableColumns: false, //去除列头排序
        height: '100%',
        pageConfig: {
            enablePage: false
        },
        dataUrl: 'getYpxGrid.action',
        params: {
            bond_type_id: bond_type_id,
            IS_FXJH: is_fxjh
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                    }
                }
            }
        ]
    };
    return DSYGrid.createGrid(config);
}

/**
 * 新增债券主表格数据刷新
 */
function reloadPxGridByParams() {
    var param = {
        BATCH_NO: BATCH_NO,
        bond_type_id: bond_type_id
    };
    reloadGrid(param);
}

/**
 * 清空排序号
 */
function dropSerialNumber() {
    DSYGrid.getGrid('WpxGrid').getStore().each(function (record) {
        record.set('SORT_NO', '');
    });
}

/**
 * 自动生成排序号
 */
function createSerialNumber() {
    //获取已排序表格中的最大序号
    var ypxGrid = DSYGrid.getGrid('YpxGrid');
    var ypxStore = ypxGrid.getStore();
    var maxSortNo = typeof (ypxStore.max('SORT_NO', false)) == "undefined" ? 1 : parseInt(ypxStore.max('SORT_NO', false)) + 1;
    //为未排序表格添加排序号
    var wpxStore = DSYGrid.getGrid('WpxGrid').getStore();

    var list = new Array();
    for (var i = 0; i < wpxStore.getCount(); i++) {
        var record = wpxStore.getAt(i);
        if (record.get("SORT_NO") == null || record.get("SORT_NO") == '' || record.get("SORT_NO") == 0) {

        } else {
            list.push(record.get("SORT_NO"));
        }
    }
    if (wpxStore.max('SORT_NO', false) == 0) {
        for (var i = 0; i < wpxStore.getCount(); i++) {
            var record = wpxStore.getAt(i);
            if (record.get("SORT_NO") == null || record.get("SORT_NO") == '' || record.get("SORT_NO") == 0) {
                record.set('SORT_NO', maxSortNo);
            }
            maxSortNo = maxSortNo + 1;
        }
    } else {
        for (var i = 0; i < wpxStore.getCount(); i++) {
            var record = wpxStore.getAt(i);
            if (record.get("SORT_NO") == null || record.get("SORT_NO") == '' || record.get("SORT_NO") == 0) {
                if (list.indexOf(maxSortNo) != -1) {
                    maxSortNo = maxSortNo + 1;
                }
                record.set('SORT_NO', maxSortNo);
                maxSortNo = maxSortNo + 1;

            }
        }
    }
    DSYGrid.getGrid('WpxGrid').getStore().sort('SORT_NO', 'ASC');
    DSYGrid.getGrid('WpxGrid').getStore().sorters.removeAll();
}

/**
 * 插队至
 */
function jumpSerialNumber(num) {
    var wpxGrid = DSYGrid.getGrid('WpxGrid');
    var wpxRecord = wpxGrid.getSelectionModel().getSelection()[0];
    wpxRecord.set('SORT_NO', num);//将插队号赋值给选中的未排序记录

    wpxGrid.getStore().sort('SORT_NO', 'ASC');
    DSYGrid.getGrid('WpxGrid').getStore().sorters.removeAll();
    wpxGrid.getView().refresh();
}

/**
 * 保存变更结果
 * @param form
 */
function saveSerialNumber() {
    //获取未排序表格数据
    var wpxGrid = [];
    DSYGrid.getGrid("WpxGrid").getStore().each(function (record) {
        if (record.get('SORT_NO') && record.get('SORT_NO') != '') {
            wpxGrid.push(record.getData());
        }
    });
    if (wpxGrid.length <= 0) {
        Ext.toast({
            html: "无排序数据！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    }
    //发送ajax请求，提交数据
    $.post('/saveSerialNumber.action', {
        wpxGrid: Ext.util.JSON.encode(wpxGrid)
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
            Ext.MessageBox.alert('提示', data.message);
        }
        //刷新表格
        reloadPxGridByParams();
    }, "json");
}

/**
 * .撤销排序
 */
function cancelSerialNumber() {
    var records = DSYGrid.getGrid('YpxGrid').getSelection();
    if (records.length == 0) {
        Ext.toast({
            html: button_name + "无已排序数据，请至少选择一条记录！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else {
        for (record_seq in records) {
            if (records[record_seq].get('JHGL_END') == '1') {// 已通过终审的项目不支持撤销
                Ext.Msg.alert('提示', '项目已通过终审，无法撤销！');
                return false;
            }
        }
        Ext.MessageBox.show({
            title: "提示",
            msg: "是否撤销选择的记录？",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (btn, text) {
                audit_info = text;
                if (btn == "ok") {
                    var ypxArray = [];
                    Ext.each(records, function (record) {
                        ypxArray.push(record.getData());
                    });
                    $.post('/cancelSerialNumber.action', {
                        ypxArray: Ext.util.JSON.encode(ypxArray)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: "撤销排序成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', data.message);
                        }
                        //刷新表格
                        reloadPxGridByParams();
                    }, "json");
                }
            }
        });
    }
}