/**
 * js：新增债券项目上报
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏300502
 */
$.extend(zqxm_json_common, {
    items: {
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
                text: '上报',
                icon: '/image/sysbutton/report.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records;
                    if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {//限额库上报
                        records = DSYGrid.getGrid('contentGrid').getSelection();
                    } else {
                        records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    }
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    for (var i in records) {
                        if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {//限额库上报
                            ids.push(records[i].get("ID"));//取明细id
                        } else {//需求库上报
                            ids.push(records[i].get("HZ_ID"));
                        }
                    }
                    //发送ajax请求，修改上报级次，如果父级为自治区，就修改明细表状态为上报
                    $.post("/updateZqxmXzzqHzGrid_Sb.action", {
                        IS_FXJH: is_fxjh,
                        HZ_IDS: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！" + (data.message ? data.message : ''),
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
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'up',
                hidden: is_zxzqxt == '1' && is_zxzq == '1' ? false : true,
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    DSYGrid.exportExcelClick('contentGrid', {
                        exportExcel: true,
                        url: 'exportExcel_jhsb.action',
                        param: {
                            q_title: AD_CODE
                        }
                    });
                }
            },
            {
                xtype: 'button',//TODO 暂未实现退回
                text: '退回',
                hidden: true,
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get("HZ_ID"));
                    }
                    //发送ajax请求，修改上报级次，如果父级为自治区，就修改明细表状态为上报
                    $.post("/updateZqxmXzzqHzGrid_th.action", {
                        HZ_IDS: ids
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
            },
            {
                xtype: 'button',
                text: '汇总表',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    getHZB("b1");
                }
            },
            {
                xtype: 'button',
                text: '汇总表2',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    getHZB("b2");
                    /*var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    var hz_ids = '';
                    var fxpc_name = records[0].get('FXPC_NAME');
                    for (var i in records) {
                        if (records[i].get('FXPC_NAME') != fxpc_name) {
                            Ext.MessageBox.alert('提示', '请选择同一批次号的数据！');
                            return;
                        }
                        if (hz_ids != null && hz_ids != '') {
                            hz_ids = hz_ids + ',';
                        }
                        hz_ids = hz_ids + '' + records[i].get("HZ_ID") + '';
                    }
                    var AD_LEVEL=records[0].get('AD_LEVEL');
                    var batch_no=records[0].get('BATCH_NO');
                    var nd = records[0].get('FXPC_YEAR');
                    var hrefUrl = reportUrl + '/WebReport/ReportServer?reportlet=czb_dz%2F04_xegl%2FDEBT_XM_XZZQXM_HZ.cpt&HZ_IDS=' + hz_ids+'&Batch_No='+batch_no+'&ND='+nd+'&AD_CODE='+AD_CODE+'&AD_LEVEL='+AD_LEVEL;
                    var a = (window.open(hrefUrl));*/
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("ID"), sys_right_model == '1' ? 'BRANCH' : '');
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
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销上报',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records;
                    if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {//限额库上报
                        records = DSYGrid.getGrid('contentGrid').getSelection();
                    } else {
                        records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    }
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    for (var i in records) {
                        if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {//限额库
                            ids.push(records[i].get("ID"));//取明细id
                        } else {
                            ids.push(records[i].get("HZ_ID"));
                        }
                    }
                    //发送ajax请求，校验期间是否被锁定
                    /*$.post("/checkZqxmXzzqHzGrid_cxsb.action", {
                        HZ_IDS: ids,
                        IS_FXJH: is_fxjh
                    }, function (data) {
                        if (data.success) {*/
                    //发送ajax请求，修改上报级次，如果父级为自治区，就修改明细表状态为上报
                    $.post("/updateZqxmXzzqHzGrid_cxsb.action", {
                        HZ_IDS: ids,
                        IS_FXJH: is_fxjh
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: data.message,
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
                    /* } else {
                         Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                     }
                 }, "json");*/
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'up',
                hidden: is_zxzqxt == '1' && is_zxzq == '1' ? false : true,
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    DSYGrid.exportExcelClick('contentGrid', {
                        exportExcel: true,
                        url: 'exportExcel_jhsb.action',
                        param: {
                            q_title: AD_CODE
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '汇总表',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    getHZB("b1");
                }
            },
            {
                xtype: 'button',
                text: '汇总表2',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    getHZB("b2");
                    /*var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    var hz_ids = '';
                    var fxpc_name = records[0].get('FXPC_NAME');
                    for (var i in records) {
                        if (records[i].get('FXPC_NAME') != fxpc_name) {
                            Ext.MessageBox.alert('提示', '请选择同一批次号的数据！');
                            return;
                        }
                        if (hz_ids != null && hz_ids != '') {
                            hz_ids = hz_ids + ',';
                        }
                        hz_ids = hz_ids + '' + records[i].get("HZ_ID") + '';
                    }
                    var nd = records[0].get('FXPC_YEAR');
                    var AD_LEVEL=records[0].get('AD_LEVEL');
                    var batch_no=records[0].get('BATCH_NO');
                    var hrefUrl = reportUrl + '/WebReport/ReportServer?reportlet=czb_dz%2F04_xegl%2FDEBT_XM_XZZQXM_HZ.cpt&HZ_IDS=' + hz_ids+'&Batch_No='+batch_no+'&ND='+nd+'&AD_CODE='+AD_CODE+'&AD_LEVEL='+AD_LEVEL;
                    var a = (window.open(hrefUrl));*/
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("ID"), sys_right_model == '1' ? 'BRANCH' : '');
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
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '上报',
                icon: '/image/sysbutton/report.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records;
                    if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {//限额库上报
                        records = DSYGrid.getGrid('contentGrid').getSelection();
                    } else {
                        records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    }
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    for (var i in records) {
                        if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {//限额库
                            ids.push(records[i].get("ID"));//取明细id
                        } else {
                            ids.push(records[i].get("HZ_ID"));
                        }
                    }
                    //发送ajax请求，修改上报级次，如果父级为自治区，就修改明细表状态为上报
                    $.post("/updateZqxmXzzqHzGrid_Sb.action", {
                        IS_FXJH: is_fxjh,
                        HZ_IDS: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！" + (data.message ? data.message : ''),
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
            },
            {
                xtype: 'button',//TODO 暂未实现退回
                text: '退回',
                hidden: true,
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get("HZ_ID"));
                    }
                    //发送ajax请求，修改上报级次，如果父级为自治区，就修改明细表状态为上报
                    $.post("/updateZqxmXzzqHzGrid_th.action", {
                        HZ_IDS: ids
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
            },
            {
                xtype: 'button',
                text: '汇总表',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    getHZB("b1");
                }
            },
            {
                xtype: 'button',
                text: '汇总表2',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    getHZB("b2");
                    /*var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    var hz_ids = '';
                    var fxpc_name = records[0].get('FXPC_NAME');
                    for (var i in records) {
                        if (records[i].get('FXPC_NAME') != fxpc_name) {
                            Ext.MessageBox.alert('提示', '请选择同一批次号的数据！');
                            return;
                        }
                        if (hz_ids != null && hz_ids != '') {
                            hz_ids = hz_ids + ',';
                        }
                        hz_ids = hz_ids + '' + records[i].get("HZ_ID") + '';
                    }
                    var nd = records[0].get('FXPC_YEAR');
                    var AD_LEVEL=records[0].get('AD_LEVEL');
                    var batch_no=records[0].get('BATCH_NO');
                    var hrefUrl = reportUrl + '/WebReport/ReportServer?reportlet=czb_dz%2F04_xegl%2FDEBT_XM_XZZQXM_HZ.cpt&HZ_IDS=' + hz_ids+'&Batch_No='+batch_no+'&ND='+nd+'&AD_CODE='+AD_CODE+'&AD_LEVEL='+AD_LEVEL;
                    var a = (window.open(hrefUrl));*/
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("ID"), sys_right_model == '1' ? 'BRANCH' : '');
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    },
    items_content_rightPanel_dockedItems: [
        {
            xtype: 'toolbar',
            dock: 'top',
            layout: {
                type: 'column'
            },
            defaults: {
                margin: '5 5 5 5',
                width: 250,
                labelWidth: 100,//控件默认标签宽度
                labelAlign: 'left'//控件默认标签对齐方式
            },
            items: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt5_2),
                    width: 150,
                    labelWidth: 30,
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "code",
                    allowBlank: false,
                    editable: false,
                    value: WF_STATUS,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(zqxm_json_common.items[WF_STATUS]);
                            //刷新当前表格
                            reloadGrid({
                                WF_STATUS: WF_STATUS
                            });
                        }
                    }
                },
                {
                    xtype: 'combobox',
                    fieldLabel: '申报年度',
                    name: 'BILL_YEAR',
                    labelWidth: 70,
                    width: 180,
                    editable: false,
                    value: '',
                    labelAlign: 'right',
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                    listeners: {
                        change: function (self, newValue) {
                            reloadGrid({
                                BILL_YEAR: newValue
                            });
                        }
                    }
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '申报批次',
                    displayField: 'name',
                    valueField: 'id',
                    name: 'BATCH_NO',
                    store: DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND2 IS NULL OR EXTEND2 = '" + ((is_fxjh == '1' || is_fxjh == '3' || is_fxjh == '4') ? "1" : "0") + "')"}),
                    editable: false,
                    labelWidth: 70,
                    hidden: is_fxjh == '3' ? true : false,
                    labelAlign: 'right',
                    listeners: {
                        'change': function (self, newValue) {
                            if (is_fxjh == '1' || is_fxjh == '3' || is_fxjh == '4') {
                                reloadGrid({
                                    SBBATCH_NO: newValue
                                });
                            } else {
                                reloadGrid({
                                    BATCH_NO: newValue
                                });
                            }
                        }
                    }
                }
            ]
        }
    ],
    items_content_rightPanel_items: function () {
        if (is_fxjh == 5 || is_fxjh == 3 || is_fxjh == 4) {
            return [
                initContentGrid()
            ]
        } else {
            return [
                initContentHZGrid(),
                initContentGrid()
            ]
        }

    },
    item_content_grid_config: {
        tbar: null,
        dataUrl: 'getZqxmXzzqContentGrid_NoPage.action',
        autoLoad: false,
        checkBox: false,
        pageConfig: {
            enablePage: false
        }
    },
    reloadGrid: function (param_hz) {
        if (is_fxjh == '5' || is_fxjh == '3' || is_fxjh == '4') {
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid')) {
                var store_details = DSYGrid.getGrid('contentGrid').getStore();
                store_details.getProxy().extraParams["AD_CODE"] = AD_CODE;
                if (typeof param_hz != 'undefined' && param_hz != null) {
                    for (var name in param_hz) {
                        store_details.getProxy().extraParams[name] = param_hz[name];
                    }
                }
                store_details.loadPage(1);
            }
        } else {
            var store = DSYGrid.getGrid('contentHZGrid').getStore();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            if (typeof param_hz != 'undefined' && param_hz != null) {
                for (var name in param_hz) {
                    store.getProxy().extraParams[name] = param_hz[name];
                }
            }
            //刷新
            store.loadPage(1);
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid')) {
                var store_details = DSYGrid.getGrid('contentGrid').getStore();
                store_details.removeAll();
            }
        }
    }
});

/**
 * 初始化右侧主表格:汇总单表
 */
function initContentHZGrid() {
    var headerJson = HEADERJSON_HZ;
    return DSYGrid.createGrid({
        itemId: 'contentHZGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '50%',
        flex: 1,
        params: {
            is_fxjh: is_fxjh,
            WF_STATUS: WF_STATUS,
            IS_ZXZQXT: is_zxzqxt,
            IS_ZXZQ: is_zxzq
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getZqxmXzzqHzGrid.action',
        pageConfig: {
            pageNum: true
        },
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
            }
        }
    });
}