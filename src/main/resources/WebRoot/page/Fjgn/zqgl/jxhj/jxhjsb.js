$.extend(json_common, {
    items: {
        '001': [
            {
                text: '查询',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '上报',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow_jxhj();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("BILL_DTL_ID"));
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
            {
                text: '查询',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '撤销上报',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow_jxhj();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("BILL_DTL_ID"));
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '004': [
            {
                text: '查询',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '上报',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow_jxhj();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("BILL_DTL_ID"));
                }
            }

        ]
    },
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    },
    items_content_rightPanel_items: function () {
        return [
            initContentGrid(),
            initContentDetilGrid_SB()
        ]
    }
});
var batch_no_store2 = DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND1 like '03%' OR EXTEND1 IS NULL) "});

function doWorkFlow_jxhj() {
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length < 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择至少一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else if (sm.length >= 1) {
        var bills = new Array();
        for (var i = 0; i < sm.length; i++) {
            var temp = new Object();
            temp['BILL_ID'] = sm[i].get("BILL_ID");
            bills.push(temp);
        }
        Ext.MessageBox.show({
            title: "提示",
            msg: "是否" + button_name + "?",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            //animateTarget: btn,
            fn: function (buttonId) {
                if (buttonId === "ok") {
                    Ext.Ajax.request({
                        method: 'POST',
                        url: "/doupdateworkflowsb.action",
                        params: {
                            AD_CODE: USER_AD_CODE,
                            USERCODE: USER_AD_CODE,
                            WF_ID: wf_id,
                            NODE_CODE: node_code,
                            BUTTON_NAME: button_name,
                            bills: Ext.util.JSON.encode(bills),
                            USER_CODE: USER_CODE
                        },
                        async: false,
                        success: function (response, options) {
                            var result = Ext.util.JSON.decode(response.responseText);
                            if (result.success) {
                                toast_util(button_name, true);
                                reloadMain();
                            } else {
                                Ext.MessageBox.alert(button_name + "失败", "" + result.message);
                            }
                        },
                        failure: function (response, options) {

                        }
                    });
                }
            }
        });
    }
}

var HEADERJSON2 = [
    {
        xtype: 'rownumberer', summaryType: 'count', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {text: "再融资债券主单id", dataIndex: "BILL_ID", width: 200, type: "string", hidden: true},
    {text: "申报批次_id", dataIndex: "BATCH_NO", width: 200, type: "string", hidden: true},
    {text: "申报批次", dataIndex: "BATCH_NO_NAME", width: 300, type: "string"},
    {text: "申报地区", dataIndex: "AD_NAME", width: 150, type: "string"},
    {text: "申请类型_id", dataIndex: "BOND_TYPE_ID", width: 200, type: "string", hidden: true},
    {text: "申请类型", dataIndex: "BOND_TYPE_ID_NAME", width: 150, type: "string"},

    {
        text: "申请总金额(万元)", dataIndex: "APPLY_AMT", width: 200, type: "float", summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "新增债券申请金额(万元)", dataIndex: "APPLY_XZ_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "置换债券申请金额(万元)", dataIndex: "APPLY_ZH_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {text: "申报日期", dataIndex: "APPLY_DATE", width: 100, type: "string"},
    {text: "经办人", dataIndex: "APPLY_INPUTOR", width: 150, type: "string"},
    {text: "备注", dataIndex: "REMARK", width: 1, type: "string"}
];

function initContentGrid() {
    var headerJson = HEADERJSON2;
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '50%',
        flex: 1,
        dataUrl: '/JxhjMainGrid.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        params: {
            NODE_CODE: node_code,
            AD_CODE: USER_AD_CODE,
            WF_STATUS: WF_STATUS,
            USERCODE: USER_AD_CODE,
            WF_ID: wf_id
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt2),
                width: 110,
                labelWidth: 30,
                editable: false,
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                allowBlank: false,
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(json_common.items[WF_STATUS]);
                        reloadMain()
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '申报批次',
                displayField: 'name',
                valueField: 'id',
                name: 'BATCH_NO',
                store: batch_no_store2,
                editable: false,
                width: 400,
                labelWidth: 70,
                labelAlign: 'right',
                selectModel: 'leaf',
                listeners: {
                    select: function (combo, record, index) {
                        reloadMain();
                    }
                }
            }
        ],
        features: [{
            ftype: 'summary'
        }],
        listeners: {
            itemclick: function (self, record) {
                var mx_grid_2 = DSYGrid.getGrid("contentGrid_detail");
                mx_grid_2.getStore().getProxy().extraParams = {
                    BILL_ID: record.get("BILL_ID")
                };
                mx_grid_2.getStore().loadPage(1);
            }
        }
    });
}

var HEADERJSON_mx_SB = [
    {
        xtype: 'rownumberer', summaryType: 'count', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {text: "明细id", dataIndex: "BILL_DTL_ID", width: 200, type: "string", hidden: true},
    {text: "再融资债券单编码", dataIndex: "BILL_NO", width: 200, type: "string", hidden: true},
    {
        text: "债券/债务名称",
        dataIndex: "ZQ_NAME",
        width: 400,
        type: "string",
        hidden: false,
        renderer: function (data, cell, record) {
            if (record.get('DATA_TYPE') == 'ZW') {
                var url = '/page/debt/common/zwyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "zw_id";
                paramNames[1] = "zwlb_id";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            } else {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = AD_CODE;
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        }
    },
    {
        text: "申请金额(万元)", dataIndex: "APPLY_AMT", width: 150, type: "float", summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "新增债券申请金额(万元)", dataIndex: "APPLY_XZ_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "置换债券申请金额(万元)", dataIndex: "APPLY_ZH_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {text: "到期日期", dataIndex: "DF_END_DATE", width: 150, type: "string"},
    {
        text: "到期金额(万元)", dataIndex: "PLAN_AMT", width: 200, type: "float",
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "新增债券到期金额(万元)", dataIndex: "PLAN_XZ_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "置换债券到期金额(万元)", dataIndex: "PLAN_ZH_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {text: "上级审核意见", dataIndex: "SBYJ", width: 300, type: "string"},
    {text: "备注", dataIndex: "REMARK", width: 300, type: "string"},
    {text: "ZW_ID", dataIndex: "ZW_ID", width: 100, type: "string", hidden: true},
    {text: "ZWLB_ID", dataIndex: "ZWLB_ID", width: 100, type: "string", hidden: true},
    {text: "DATA_TYPE", dataIndex: "DATA_TYPE", width: 100, type: "string", hidden: true}
]

function initContentDetilGrid_SB() {
    var headerJson = HEADERJSON_mx_SB;
    return DSYGrid.createGrid({
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: '/JxhjMainMx.action',
        params: {
            BILL_ID: '',
            node_type: node_type
        },
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        flex: 1
    });
}

function reloadMain() {
    var main_grid = DSYGrid.getGrid("contentGrid");
    main_grid.getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
    var sbpc = Ext.ComponentQuery.query('treecombobox[name="BATCH_NO"]')[0].getValue();
    if (sbpc != null && sbpc != "" && sbpc != undefined) {
        main_grid.getStore().getProxy().extraParams['SBPC'] = sbpc;
    } else {
        main_grid.getStore().getProxy().extraParams['SBPC'] = "";

    }
    main_grid.getStore().loadPage(1);
    var mx_grid = DSYGrid.getGrid("contentGrid_detail");
    mx_grid.getStore().getProxy().extraParams['BILL_ID'] = '';
    mx_grid.getStore().loadPage(1);
}


function operationRecord() {
    var records = DSYGrid.getGrid('contentGrid_detail').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("BILL_DTL_ID"));
    }
}

