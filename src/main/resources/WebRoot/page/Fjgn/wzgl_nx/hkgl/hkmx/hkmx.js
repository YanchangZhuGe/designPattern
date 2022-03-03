var button_name = '';

/**
 * 工作流节点
 */
var wzzd_json_common = {
    101081: {
        1: {//转贷录入岗
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
                        text: '录入',
                        name: 'input',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            initWin_xy().show();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                            if (record === null || record === '') {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
                            initWindow_input({hkmx_data: record.getData(), btn: btn}).show();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm === 'yes') {
                                    button_name = btn.text;
                                    var ids = [];
                                    for (var i = 0; i < records.length; i++) {
                                        var record = records[i];
                                        ids.push(record.get('FKTZ_ID'));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post("/wzgl_nx/hkgl/deleteHkMXInfo.action?", {
                                        ids: ids
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({html: button_name + "成功！"});
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
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
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
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销送审',
                        name: 'cancel',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
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
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                            if (record === null || record === '') {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
                            initWindow_input({hkmx_data: record.getData(), btn: btn}).show();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        name: 'btn_delete',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm === 'yes') {
                                    button_name = btn.text;
                                    var ids = [];
                                    for (var i = 0; i < records.length; i++) {
                                        var record = records[i];
                                        ids.push(record.get('FKTZ_ID'));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post("/wzgl_nx/hkgl/deleteHkMXInfo.action?", {
                                        ids: ids
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({html: button_name + "成功！"});
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
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
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
                WF_STATUS: DebtEleStore(json_debt_zt1_1)
            }
        },
        2: {
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
                        text: '审核',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
                            doWorkFlow(btn);

                        }
                    },
                    {
                        xtype: 'button',
                        text: '退回',
                        name: 'up',
                        icon: '/image/sysbutton/back.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
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
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reloadGrid();

                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销审核',
                        name: 'cancel',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else {
                                doWorkFlow(btn);
                            }
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
                items: wzzd_json_common[wf_id][node_code].items[WF_STATUS],
            }
        ],
        items: [
            initContentGrid(),
            initContentMxGrid()
        ]
    });
    reloadGrid();
}

/**
 * 初始化主界面主表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "FKTZ_ID", type: "string", text: "主单id", hidden: true},
        {dataIndex: "YBMYHL_RATE", type: "string", text: "原币/美元汇率", hidden: true},
        {dataIndex: "RMBMYHL_RATE", type: "string", text: "人民币/美元汇率", hidden: true},
        {dataIndex: "HL_RATE", type: "string", text: "原币/人民币", hidden: true},
        {dataIndex: "ZH_ID", type: "string", text: "收款人ID", hidden: true},
        {dataIndex: "ZH_NAME", type: "string", text: "户名", hidden: true},
        {dataIndex: "ACCOUNT", type: "string", text: "账号", hidden: true},
        {dataIndex: "ZH_BANK", type: "string", text: "开户行", hidden: true},
        {dataIndex: "AD_CODE", type: "string", text: "项目地区", hidden: true},
        {dataIndex: "WZXY_ID", type: "string", text: "外债协议ID", hidden: true},
        {dataIndex: "DB_RATE", type: "float", text: "担保费率", hidden: true},
        {dataIndex: "ZD_RATE", type: "float", text: "转贷费率", hidden: true},
        {dataIndex: "LX_RATE", type: "float", text: "贷款利率", hidden: true},
        {dataIndex: "XY_AG_NAME", type: "string", text: "项目地区", width: 150},
        {dataIndex: "WZXY_CODE", type: "string", text: "外债编码", width: 150},
        {
            dataIndex: "WZXY_NAME", width: 300, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = [];
                    paramNames[0] = "WZXY_ID";
                    var paramValues = [];
                    paramValues[0] = encodeURIComponent(record.get('WZXY_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {dataIndex: "HK_CODE", type: "string", text: "还款次数"},
        {
            header: '还款区间', columns: [
                {dataIndex: "START_DATE", type: "string", text: "起始时间", width: 180},
                {dataIndex: "END_DATE", type: "string", text: "终止时间", width: 180}]
        },
        {
            header: '累计提款金额', columns: [
                {
                    dataIndex: "LJTK_BWB",
                    type: "float",
                    text: "累计提款本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LJTK_MY",
                    type: "float",
                    text: "累计提款美元(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LJTK_RMB",
                    type: "float",
                    text: "累计提款人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还本金', columns: [
                {
                    dataIndex: "PAY_BJ_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还利息', columns: [
                {
                    dataIndex: "PAY_LX_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还承诺费', columns: [
                {
                    dataIndex: "PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_CNF_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还转贷费', columns: [
                {
                    dataIndex: "ZDF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还担保费', columns: [
                {
                    dataIndex: "DBF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            dataIndex: "HD_AMT", type: "float", text: "人民币汇兑(万元)", width: 180, summaryType: 'sum', editor: {
                xtype: "numberFieldFormat",
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false,
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        flex: 1,
        dataUrl: '/wzgl_nx/hkgl/getHkMxMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        features: [{
            ftype: 'summary'
        }],
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: wzzd_json_common[wf_id][node_code].store['WF_STATUS'],
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
                        toolbar.add(wzzd_json_common[wf_id][node_code].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "mhcx",
                width: 250,
                labelWidth: 100,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            var grid = DSYGrid.getGrid('contentGrid');
                            var store = grid.getStore();
                            var mhcx = Ext.ComponentQuery.query('textfield#mhcx')[0].getValue();
                            store.getProxy().extraParams.mhcx = mhcx;
                            //刷新
                            store.loadPage(1);
                        }
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
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['FKTZ_ID'] = record.get('FKTZ_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['END_DATE'] = record.get('END_DATE');
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['WZXY_ID'] = record.get('WZXY_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化主界面子表格
 */
function initContentMxGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AG_NAME", type: "string", width: 200, text: "项目县区/单位"},
        {
            header: '本期应还本金', columns: [
                {
                    dataIndex: "PAY_BJ_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还利息', columns: [
                {
                    dataIndex: "PAY_LX_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还承诺费', columns: [
                {
                    dataIndex: "PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_CNF_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还转贷费', columns: [
                {
                    dataIndex: "ZDF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还担保费', columns: [
                {
                    dataIndex: "DBF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            dataIndex: "HD_AMT", type: "float", text: "汇兑人民币(万元)", width: 180, summaryType: 'sum', editor: {
                xtype: "numberFieldFormat",
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false,
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            header: '累计应还本金', columns: [
                {
                    dataIndex: "YH_PAY_BJ_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_PAY_BJ_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还利息', columns: [
                {
                    dataIndex: "YH_PAY_LX_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_PAY_LX_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还承诺费', columns: [
                {
                    dataIndex: "YH_PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_CNF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还转贷费', columns: [
                {
                    dataIndex: "YH_ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还担保费', columns: [
                {
                    dataIndex: "YH_DBF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_DBF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还本金', columns: [
                {
                    dataIndex: "CH_BJ_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_BJ_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还利息', columns: [
                {
                    dataIndex: "CH_LX_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_LX_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还承诺费', columns: [
                {
                    dataIndex: "CH_CNF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_CNF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还转贷费', columns: [
                {
                    dataIndex: "CH_ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还担保费', columns: [
                {
                    dataIndex: "CH_DBF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_DBF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            dataIndex: "HD_AMT", type: "float", text: "汇兑人民币(万元)", width: 180, summaryType: 'sum', editor: {
                xtype: "numberFieldFormat",
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false,
            },
            summaryRenderer: function (value, metadata, record) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value, metadata, record) {
                var HD = Decimal.subBatch(record.data.CH_BJ_RMB_AMT, record.data.YH_PAY_BJ_AMT);
                return Ext.util.Format.number(HD, '0,000.######');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
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
        features: [{
            ftype: 'summary'
        }],
        dataUrl: '/wzgl_nx/hkgl/getHkmxChildInfo.action'
    });
    return grid;
}

/**
 * 初始化项目/协议选择弹出窗口
 */
function initWin_xy() {
    return Ext.create('Ext.window.Window', {
        title: '项目/协议选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWin_xy_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var record = DSYGrid.getGrid('win_xy_grid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                        return false;
                    }
                    btn.setDisabled(true);
                    $.ajax({
                            type: "POST",
                            url: "/wzgl_nx/hkgl/getHkmxMaxHkCode.action",
                            data: {
                                WZXY_ID: record.data.WZXY_ID
                            },
                            dataType: 'json'
                        }
                    )
                        .done(function (result) {
                            if (!result.success) {
                                Ext.MessageBox.alert('提示', '获取失败！' + (!result.message ? '' : result.message));
                                return false;
                            }
                            btn.up('window').close();
                            record.data.HK_CODE = Decimal.addBatch(result.HKCODE, 1);
                            var config = $.extend(true, {hkmx_data: record.data});
                            initWindow_input(config).show();
                        })
                        .fail(function (result) {
                            Ext.MessageBox.alert('提示', '获取提款次数失败！' + (!result.message ? '' : result.message));
                            btn.setDisabled(false);
                        });
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
 * 初始化选择协议列表
 */
function initWin_xy_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "项目地区", dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: "项目地区", dataIndex: "XY_AG_NAME", type: "string", width: 150},
        {text: "外债编码", dataIndex: "WZXY_CODE", type: "string", width: 150},
        {
            text: "项目名称",
            dataIndex: "WZXY_NAME",
            type: "string",
            width: 300,
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = ["WZXY_ID"];
                    var paramValues = [encodeURIComponent(record.get('WZXY_ID'))];
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {text: "项目类别", dataIndex: "XMLB_NAME", type: "string", width: 180},
        {text: "债权国", dataIndex: "ZQR_NAME", type: "string", width: 180},
        {text: "执行单位", dataIndex: "ZXDW", type: "string", width: 150},
        {text: "债务单位", dataIndex: "ZWDW", type: "string", width: 150},
        {
            text: "贷款利率", dataIndex: "LX_RATE", type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {text: "偿还方式", dataIndex: "CHFS_NAME", type: "string"},
        {text: "执行情况", dataIndex: "ZXQK_NAME", type: "string"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'win_xy_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: "/wzgl_nx/xygl/getXmInfoGrid.action",
        checkBox: true,   //显示复选框
        border: false,
        selModel: {
            mode: "SINGLE"     //是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        flex: 1,
        height: '100%',
        width: '100%',
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "mhcx_xy",
                width: 250,
                labelWidth: 100,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            var grid = DSYGrid.getGrid('win_xy_grid');
                            var store = grid.getStore();
                            var mhcx = Ext.ComponentQuery.query('textfield#mhcx_xy')[0].getValue();
                            store.getProxy().extraParams.mhcx = mhcx;
                            //刷新
                            store.loadPage(1);
                        }
                    }
                }
            }
        ]
    });
    return grid;
}

/**
 * 获取左右表格 拆分数据
 * @param form_data
 * @returns {*}
 */
function getLeftRightGridData(form_data) {
    //获取 录入右侧表格 数据
    var rightStore = DSYGrid.getGrid('hkmx_right_grid').getStore();
    //获取 录入左侧表格 数据
    var leftStore = DSYGrid.getGrid('hkmx_left_grid').getStore();
    var ljtkhj = {
        BWB: 0,
        MY: 0,
        RMB: 0,
    }
    for (var i = 0; i < leftStore.getCount(); i++) {
        var record = leftStore.getAt(i);
        ljtkhj.BWB += record.get('LJTK_BWB');
        ljtkhj.MY += record.get('LJTK_MY');
        ljtkhj.RMB += record.get('LJTK_RMB');
    }

    var data = [];
    var record_bj = rightStore.getAt(0);
    var record_lx = rightStore.getAt(1);
    var record_cn = rightStore.getAt(2);
    var record_zd = rightStore.getAt(3);
    var record_db = rightStore.getAt(4);
    var record_hd = rightStore.getAt(5);
    for (var i = 0; i < leftStore.getCount(); i++) {
        var record = leftStore.getAt(i);
        var temp = {};
        temp['HK_CODE'] = form_data.HK_CODE;
        temp['START_DATE'] = form_data.START_DATE;
        temp['END_DATE'] = form_data.END_DATE;
        temp['FKTZ_ID'] = form_data.FKTZ_ID;
        temp['WZXY_ID'] = form_data.WZXY_ID;
        temp['AG_NAME'] = record.data.AG_NAME;
        temp['LJTK_BWB'] = record.data.LJTK_BWB;
        temp['LJTK_MY'] = record.data.LJTK_MY;
        temp['LJTK_RMB'] = record.data.LJTK_RMB;
        // 本期应还本金
        temp['PAY_BJ_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_BWB'), ljtkhj['BWB']), record_bj.get("BWB"));
        temp['BJ_MY_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_MY'), ljtkhj['MY']), record_bj.get("MY"));
        temp['PAY_BJ_RMB'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_RMB'), ljtkhj['RMB']), record_bj.get("RMB"));
        // 本期应收利息
        temp['PAY_LX_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_BWB'), ljtkhj['BWB']), record_lx.get("BWB"));
        temp['LX_MY_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_MY'), ljtkhj['MY']), record_lx.get("MY"));
        temp['PAY_LX_RMB'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_RMB'), ljtkhj['RMB']), record_lx.get("RMB"));
        // 本期应收承诺费
        temp['PAY_CNF'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_BWB'), ljtkhj['BWB']), record_cn.get("BWB"));
        temp['CNF_MY_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_MY'), ljtkhj['MY']), record_cn.get("MY"));
        temp['PAY_CNF_RMB'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_RMB'), ljtkhj['RMB']), record_cn.get("RMB"));
        // 本期应收转贷费
        temp['ZDF_YB_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_BWB'), ljtkhj['BWB']), record_zd.get("BWB"));
        temp['ZDF_MY_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_MY'), ljtkhj['MY']), record_zd.get("MY"));
        temp['ZDF_RMB_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_RMB'), ljtkhj['RMB']), record_zd.get("RMB"));
        // 本期应收担保费
        temp['DBF_YB_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_BWB'), ljtkhj['BWB']), record_db.get("BWB"));
        temp['DBF_MY_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_MY'), ljtkhj['MY']), record_db.get("MY"));
        temp['DBF_RMB_AMT'] = Decimal.mulBatch(Decimal.divBatch(record.get('LJTK_RMB'), ljtkhj['RMB']), record_db.get("RMB"));
        // 汇兑
        temp['HD_AMT'] = record_hd.get("RMB");
        data.push(temp);
    }
    return data;
}

/**
 * 拼接 添加的表头数据
 * @returns {boolean|*}
 */
function insertHkmxFromData() {
    var form = Ext.ComponentQuery.query('form#hkmx_edit_form');
    if (!form || form.length <= 0) {
        Ext.MessageBox.alert('提示', '获取表头数据失败');
        return false;
    }
    form = form[0];
    var form_data = form.getForm().getValues();
    var rightStore = DSYGrid.getGrid('hkmx_right_grid').getStore();
    var leftStore = DSYGrid.getGrid('hkmx_left_grid').getStore();
    var ljtkhj = {
        BWB: 0,
        MY: 0,
        RMB: 0,
    }
    for (var i = 0; i < leftStore.getCount(); i++) {
        var record = leftStore.getAt(i);
        ljtkhj.BWB += record.get('LJTK_BWB');
        ljtkhj.MY += record.get('LJTK_MY');
        ljtkhj.RMB += record.get('LJTK_RMB');
    }

    //本金
    form_data.BJ_MY_AMT = rightStore.getAt(0).get("MY");
    form_data.PAY_BJ_AMT = rightStore.getAt(0).get("BWB");
    form_data.PAY_BJ_RMB = rightStore.getAt(0).get("RMB");
    //利息
    form_data.LX_MY_AMT = rightStore.getAt(1).get("MY");
    form_data.PAY_LX_AMT = rightStore.getAt(1).get("BWB");
    form_data.PAY_LX_RMB = rightStore.getAt(1).get("RMB");
    //承诺费
    form_data.CNF_MY_AMT = rightStore.getAt(2).get("MY");
    form_data.PAY_CNF = rightStore.getAt(2).get("BWB");
    form_data.PAY_CNF_RMB = rightStore.getAt(2).get("RMB");
    //转贷费
    form_data.ZDF_MY_AMT = rightStore.getAt(3).get("MY");
    form_data.ZDF_YB_AMT = rightStore.getAt(3).get("BWB");
    form_data.ZDF_RMB_AMT = rightStore.getAt(3).get("RMB");
    //担保费
    form_data.DBF_MY_AMT = rightStore.getAt(4).get("MY");
    form_data.DBF_YB_AMT = rightStore.getAt(4).get("BWB");
    form_data.DBF_RMB_AMT = rightStore.getAt(4).get("RMB");
    //汇兑
    form_data.HD_AMT = rightStore.getAt(5).get("RMB");

    return form_data;
}

/**
 * 初始化还款录入弹出窗口
 */
function initWindow_input(config) {
    return Ext.create('Ext.window.Window', {
        title: '还款录入', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        maximizable: true,
        itemId: 'window_input_hklr', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        resizable: true,//可拖动改变窗口大小
        layout: 'vbox',
        defaults: {
            width: '100%'
        },
        items: [
            initWin_input_form(config),
            initWin_input_panel(config)
        ],
        buttons: [
            {
                text: '下一步',
                handler: function (btn) {
                    var form = btn.up('window').down('form');
                    if (!form.isValid()) {
                        return;
                    }
                    var form_data = form.getValues();
                    //如果没有 FKTZ_ID则是修改 明细数据 已存在
                    var leftStore = DSYGrid.getGrid('hkmx_left_grid').getStore();
                    if (leftStore.getCount() <= 0) {
                        Ext.toast({
                            html: '当前还款区间无累计提款金额！',
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                    var cfData = getLeftRightGridData(form_data);
                    btn.setDisabled(true);
                    $.ajax({
                            type: "POST",
                            url: "/wzgl_nx/hkgl/getHkmxIsExistedInfo.action?",
                            data: {
                                WZXY_ID: form_data.WZXY_ID,
                                END_DATE: form_data.END_DATE,
                                FKTZ_ID: form_data.FKTZ_ID
                            },
                            dataType: 'json'
                        }
                    )
                        .done(function (result) {
                            btn.setDisabled(false);
                            if (!result.success) {
                                Ext.MessageBox.alert('提示', '获取失败！' + (!result.message ? '' : result.message));
                                return false;
                            }
                            var tempArray = [];
                            //判断是否是需改数据
                            var flag_edit = false;
                            for (let i = 0; i < result.list.length; i++) {
                                var data = result.list[i];
                                if (!!data.FKTZ_DTL_ID) {
                                    flag_edit = true;
                                }
                            }
                            if (flag_edit) {
                                //修改数据，不拆分，拼接累计已还应还
                                for (let i = 0; i < result.list.length; i++) {
                                    var data = result.list[i];
                                    for (let j = 0; j < leftStore.getCount(); j++) {
                                        var record = leftStore.getAt(j);
                                        if (!!data.FKTZ_DTL_ID && data.AG_NAME == record.data.AG_NAME) {
                                            data['HK_CODE'] = form_data.HK_CODE;
                                            data['START_DATE'] = form_data.START_DATE;
                                            data['END_DATE'] = form_data.END_DATE;
                                            data['LJTK_BWB'] = record.data.LJTK_BWB;
                                            data['LJTK_MY'] = record.data.LJTK_MY;
                                            data['LJTK_RMB'] = record.data.LJTK_RMB;
                                            tempArray.push(data);
                                        }
                                    }
                                }
                            } else {
                                //新增数据，拼接拆分数据，拼接累计已还应还
                                for (let i = 0; i < result.list.length; i++) {
                                    var data = result.list[i];
                                    for (let j = 0; j < leftStore.getCount(); j++) {
                                        var record = leftStore.getAt(j);
                                        if (data.AG_NAME === record.data.AG_NAME) {
                                            var temp = $.extend(data, cfData[j]);
                                            tempArray.push(temp);
                                        }
                                    }
                                }
                            }
                            var config = $.extend(true, {hkmx_data: tempArray});
                            if (!config.hkmx_data || config.hkmx_data.length <= 0) {
                                Ext.toast({
                                    html: '无法计算还款明细数据！',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            }
                            initWin_hkcf(config).show();
                        }).fail(function (result) {
                        Ext.MessageBox.alert('提示', '获取提款次数失败！' + (!result.message ? '' : result.message));
                        btn.setDisabled(false);
                    });
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').destroy();
                }
            }
        ]
    });
}

/**
 * 初始化还款录入表头
 * @returns {Ext.form.Panel}
 */
function initWin_input_form(config) {
    var store_zjzh = Ext.create('Ext.data.Store', {
        fields: ['ZJZH_ID', 'ZH_TYPE', 'ZH_NAME', 'ACCOUNT', 'ZH_BANK'],
        proxy: {
            type: 'ajax',
            url: "/wzgl_nx/jcsjgl/getZjzhList.action",
            method: "POST",
            params: {},
            reader: {
                type: 'json',
                rootProperty: 'data'
            }
        },
        autoLoad: true
    });
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'hkmx_edit_form',
        width: '100%',
        height: 170,
        layout: 'column',
        checkBox: true,   //显示复选框
        defaultType: 'textfield',
        defaults: {
            margin: '2 5 4 5',
            columnWidth: .33,
            labelWidth: 180//控件默认标签宽度
        },
        border: false,
        items: [
            {
                fieldLabel: '<span class="required">✶</span>还款次数',
                xtype: "numberFieldFormat",
                name: "HK_CODE",
                allowBlank: false,
                hideTrigger: true,
            },
            {fieldLabel: "主单id", name: "FKTZ_ID", hidden: true},
            {fieldLabel: '外债协议ID', name: "WZXY_ID", hidden: true},
            {fieldLabel: '项目名称', name: "XY_AG_NAME", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '外债编码', name: "WZXY_CODE", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '贷款利率（%）', name: "LX_RATE", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '担保费率（%）', name: "DB_RATE", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '转贷费率（%）:', name: "ZD_RATE", editable: false, fieldCls: 'form-unedit'},
            {
                xtype: "numberFieldFormat",
                fieldLabel: '原币/美元汇率',
                name: "YBMYHL_RATE",
                allowBlank: false,
                hideTrigger: true
            },
            {
                xtype: "numberFieldFormat",
                fieldLabel: '人民币/美元汇率',
                name: "RMBMYHL_RATE",
                allowBlank: false,
                hideTrigger: true
            },
            {
                xtype: "numberFieldFormat",
                fieldLabel: '原币/人民币汇率',
                name: "HL_RATE",
                allowBlank: false,
                hideTrigger: true
            },
            {
                fieldLabel: '<span class="required">✶</span>户名',
                name: "ZH_NAME",
                xtype: 'combobox',
                displayField: 'ZH_NAME',
                valueField: 'ZJZH_ID',
                allowBlank: false,
                store: store_zjzh,
                listeners: {
                    'change': function (self, newValue, oldValue) {
                        //账户下拉框选择数据后
                        var record = store_zjzh.findRecord('ZJZH_ID', newValue);
                        if (record != null) {
                            self.up('form').down("[name='ZH_NAME']").setValue(record.get('ZH_NAME'));
                            self.up('form').down("[name='ACCOUNT']").setValue(record.get('ACCOUNT'))
                            self.up('form').down("[name='ZH_BANK']").setValue(record.get('ZH_BANK'))
                            self.up('form').down("[name='ZJZH_ID']").setValue(record.get('ZJZH_ID'))
                        }
                    }
                }
            },
            {fieldLabel: '<span class="required">✶</span>账号', allowBlank: false, name: "ACCOUNT"},
            {fieldLabel: '<span class="required">✶</span>开户行', allowBlank: false, name: "ZH_BANK"},
            {fieldLabel: "编号", name: "ZJZH_ID", hidden: true},
            {
                xtype: 'fieldcontainer',
                fieldLabel: '<span class="required">✶</span>还款区间',
                layout: 'hbox',
                columnWidth: .66,
                items: [
                    {
                        xtype: 'datefield',
                        name: 'START_DATE',
                        flex: 1,
                        editable: false,
                        allowBlank: false,
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var END_DATE = self.up('form').down("datefield[name='END_DATE']").getValue();
                                if (END_DATE == null || END_DATE == "" || newValue == null || newValue == "") {
                                    return;
                                }
                                END_DATE = format(END_DATE, 'yyyy-MM-dd');
                                newValue = format(newValue, 'yyyy-MM-dd');
                                if (newValue > END_DATE) {
                                    Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                    self.up('form').getForm().findField('START_DATE').setValue("");
                                    return;
                                } else {
                                    self.up('form').getForm().findField('START_DATE').setValue(newValue);
                                }
                            }
                        }
                    },
                    {xtype: 'label', text: '至', margin: '3 6 3 6', width: 20},
                    {
                        xtype: 'datefield',
                        name: 'END_DATE',
                        flex: 1,
                        editable: false,
                        allowBlank: false,
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var START_DATE = self.up('form').down("datefield[name='START_DATE']").getValue();
                                //ext 赋值时 时序问题导致 拿不到 WZXY_ID 添加延迟
                                setTimeout(function () {
                                    var WZXY_ID = self.up('form').down("[name='WZXY_ID']").getValue();
                                    if (newValue == null || newValue == "") {
                                        return;
                                    }
                                    START_DATE = format(START_DATE, 'yyyy-MM-dd');
                                    newValue = format(newValue, 'yyyy-MM-dd');
                                    if (newValue < START_DATE) {
                                        Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                        self.up('form').getForm().findField('END_DATE').setValue("");
                                        return;
                                    }
                                    getLjtkMoneyByDate(newValue, WZXY_ID);// 这里就是处理的事件
                                }, 500);

                            }
                        }
                    }
                ]
            }
        ]
    });
    //显示选择的项目数据
    if (!!config.hkmx_data) {
        form.getForm().setValues(config.hkmx_data);
    }
    return form;
}

/**
 * 根据截至时间获取累计提款金额
 * @param newValue
 * @param WZXY_ID
 */
function getLjtkMoneyByDate(newValue, WZXY_ID) {
    $.ajax({
            type: "POST",
            url: "/wzgl_nx/hkgl/getLjtkMoneyByDate.action",
            data: {
                HKQJ_E_DATE: newValue,
                WZXY_ID: WZXY_ID
            },
            dataType: 'json'
        }
    )
        .done(function (result) {
            if (!result.success) {
                Ext.MessageBox.alert('提示', '获取失败！' + (!result.message ? '' : result.message));
                return false;
            }
            //获取 grid并赋值
            var grid = DSYGrid.getGrid('hkmx_left_grid');
            grid.getStore().removeAll();
            var data = result.list;
            if (!data || data.length <= 0) {
                Ext.toast({
                    html: '当前截止时间无累计提款金额！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                return false;
            }
            //这里record与index无用
            var record = grid.getCurrentRecord();
            var index = null;
            if (!!record) {
                index = record.recordIndex;
            }
            for (let i = 0; i < data.length; i++) {
                grid.insertData(index, data[i]);
            }
        }).fail(function (result) {
        Ext.MessageBox.alert('提示', '获取提款次数失败！' + (!result.message ? '' : result.message));
    });
}

/**
 * 初始化还款录入表体
 * @returns {Ext.form.Panel}
 */
function initWin_input_panel(config) {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        flex: 1,
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false,           //是否可以折叠
            height: '100%',
            flex: 1
        },
        border: false,
        items: [
            initWin_input_panel_leftgrid(config),
            initWin_input_panel_rightgrid(config)
        ]
    });

}

/**
 * 初始化还款录入左表体
 */
function initWin_input_panel_leftgrid(config) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            width: 200,
            text: "项目区"
        },
        {
            header: '累计提款金额', columns: [
                {
                    dataIndex: "LJTK_BWB",
                    type: "float",
                    text: "累计提款本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LJTK_MY",
                    type: "float",
                    text: "累计提款美元(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LJTK_RMB",
                    type: "float",
                    text: "累计提款人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'hkmx_left_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: !!config.hkmx_data ? config.hkmx_data : [],
        border: true,
        flex: 1,
        region: 'west',
        height: '100%',
        viewConfig: {
            stripeRows: false
        },
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        }
    });
    return grid;
}

/**
 * 初始化还款录入右表体
 */
function initWin_input_panel_rightgrid(config) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "NAME",
            type: "string",
            width: 200,
            text: "项目"
        },
        {
            header: '应还金额', columns: [
                {
                    dataIndex: "BWB",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "MY",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        }
    ];

    var data = [
        {NAME: '本期应还本金'},
        {NAME: '本期应收利息'},
        {NAME: '本期应收承诺费'},
        {NAME: '本期应收转贷费'},
        {NAME: '本期应收担保费'},
        {NAME: '汇兑'}
    ]
    if (!!config.hkmx_data.FKTZ_ID) {
        data = [
            {
                NAME: '本期应还本金',
                BWB: config.hkmx_data.PAY_BJ_AMT,
                MY: config.hkmx_data.BJ_MY_AMT,
                RMB: config.hkmx_data.PAY_BJ_RMB
            },
            {
                NAME: '本期应收利息',
                BWB: config.hkmx_data.PAY_LX_AMT,
                MY: config.hkmx_data.LX_MY_AMT,
                RMB: config.hkmx_data.PAY_LX_RMB
            },
            {
                NAME: '本期应收承诺费',
                BWB: config.hkmx_data.PAY_CNF,
                MY: config.hkmx_data.CNF_MY_AMT,
                RMB: config.hkmx_data.PAY_CNF_RMB
            },
            {
                NAME: '本期应收转贷费',
                BWB: config.hkmx_data.ZDF_YB_AMT,
                MY: config.hkmx_data.ZDF_MY_AMT,
                RMB: config.hkmx_data.ZDF_RMB_AMT
            },
            {
                NAME: '本期应收担保费',
                BWB: config.hkmx_data.DBF_YB_AMT,
                MY: config.hkmx_data.DBF_MY_AMT,
                RMB: config.hkmx_data.DBF_RMB_AMT
            },
            {NAME: '汇兑', RMB: config.hkmx_data.HD_AMT}
        ]
    }

    var grid = DSYGrid.createGrid({
        itemId: 'hkmx_right_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: data,
        region: 'center',
        border: true,
        flex: 1,
        height: '100%',
        features: [{ftype: 'summary'}],
        plugins: [
            {ptype: 'cellediting', clicksToEdit: 1, pluginId: 'cellEdit', clicksToMoveEditor: 1}
        ],
        pageConfig: {
            enablePage: false
        },
        listeners: {
            beforeedit: function (editor, context) {
                if (context.field === 'BWB' || context.field === 'MY') {
                    if (context.record.data.NAME == '汇兑') {
                        return false;
                    }
                }
                if (context.field === 'MY' || context.field === 'RMB') {
                    if (context.record.data.NAME == '本期应还本金' || context.record.data.NAME == '本期应收利息' ||
                        context.record.data.NAME == '本期应收承诺费' || context.record.data.NAME == '本期应收转贷费' ||
                        context.record.data.NAME == '本期应收担保费') {
                        return false;
                    }
                }
            },
            edit: function (editor, context) {
                //edit 事件 在表格内输入数据 根据汇率 自动计算出美元人民币
                if (context.record.data.NAME != '汇兑') {
                    var form = Ext.ComponentQuery.query('form#hkmx_edit_form');
                    if (!form || form.length <= 0) {
                        return false;
                    }
                    form = form[0];
                    var form_data = form.getForm().getFieldValues();

                    context.record.set('MY', Decimal.mulBatch(context.record.data.BWB, form_data.YBMYHL_RATE));
                    context.record.set('RMB', Decimal.mulBatch(context.record.data.BWB, form_data.RMBMYHL_RATE));
                }
            }
        }
    });
    return grid;
}

/**
 * 初始化还款拆分弹出框
 */
function initWin_hkcf(config) {
    var tbar = [
        {
            xtype: 'button',
            text: '增行',
            name: 'INPUT',
            icon: '/image/sysbutton/add.png',
            width: 70,
            handler: function (btn) {
                var grid = DSYGrid.getGrid('hkcf_grid');
                var index = grid.getStore().getCount();
                grid.insertData(index, {
                    'HK_CODE': config.hkmx_data[0].HK_CODE,
                    'START_DATE': config.hkmx_data[0].START_DATE,
                    'END_DATE': config.hkmx_data[0].END_DATE
                });
            }
        },
        {
            xtype: 'button',
            text: '删行',
            name: 'DELETE',
            icon: '/image/sysbutton/delete.png',
            width: 70,
            handler: function () {
                var grid = DSYGrid.getGrid('hkcf_grid');
                var store = grid.getStore();
                var sm = grid.getSelectionModel();
                var records = sm.getSelection();
                //获取删除数据记录的ID
                if (!grid.delete_records) {
                    grid.delete_records = [];
                }
                for (var i = 0; i < records.length; i++) {
                    var id = records[i].get('FKTZ_DTL_ID');
                    if (typeof id != 'undefined' && id != null && id.length > 0) {
                        grid.delete_records.push(id);
                    }
                }
                //删除记录
                store.remove(records);
                //默认选中第一条
                if (store.getCount() > 0) {
                    sm.select(0);
                }
            }
        },
        {
            xtype: 'button',
            text: '自动生成',
            name: 'ZDSC',
            icon: '/image/sysbutton/search.png',
            width: 100,
            handler: function () {
                var form = Ext.ComponentQuery.query('form#hkmx_edit_form');
                if (!form || form.length <= 0) {
                    return false;
                }
                form = form[0];
                var form_data = form.getForm().getValues();
                var cfData = getLeftRightGridData(form_data);
                $.ajax({
                        type: "POST",
                        url: "/wzgl_nx/hkgl/getHkmxIsExistedInfo.action?",
                        data: {
                            WZXY_ID: form_data.WZXY_ID,
                            END_DATE: form_data.END_DATE,
                            FKTZ_ID: form_data.FKTZ_ID
                        },
                        dataType: 'json'
                    }
                )
                    .done(function (result) {
                        if (!result.success) {
                            Ext.MessageBox.alert('提示', '获取失败！' + (!result.message ? '' : result.message));
                            return false;
                        }
                        //获取到累计已还/应还金额 和 拆分的 主表格做合并
                        var tempArray = [];
                        for (let i = 0; i < result.list.length; i++) {
                            var data = result.list[i];
                            var temp = null;
                            // 判断 是新增还是修改 如果有值 则 把历史拆分数据清空
                            if (!!data.FKTZ_DTL_ID) {
                                data['PAY_BJ_AMT'] = null;
                                data['PAY_BJ_RMB'] = null;
                                data['BJ_MY_AMT'] = null;
                                data['PAY_LX_AMT'] = null;
                                data['PAY_LX_RMB'] = null;
                                data['LX_MY_AMT'] = null;
                                data['DBF_MY_AMT'] = null;
                                data['PAY_CNF'] = null;
                                data['PAY_CNF_RMB'] = null;
                                data['CNF_MY_AMT'] = null;
                                data['ZDF_YB_AMT'] = null;
                                data['ZDF_RMB_AMT'] = null;
                                data['ZDF_MY_AMT'] = null;
                                data['DBF_YB_AMT'] = null;
                                data['DBF_RMB_AMT'] = null;
                                data['HD_AMT'] = null;
                            }
                            temp = $.extend(data, cfData[i]);
                            temp.FKTZ_DTL_ID = null;
                            tempArray.push(temp);
                        }
                        //获取表格数据 并且赋值
                        var grid = DSYGrid.getGrid('hkcf_grid');
                        var record = grid.getCurrentRecord();
                        var store = grid.getStore();
                        //获取 要删除的 id
                        if (!grid.delete_records) {
                            grid.delete_records = [];
                        }
                        for (var i = 0; i < store.getCount(); i++) {
                            var id = store.getAt(i).get('FKTZ_DTL_ID');
                            if (typeof id != 'undefined' && id != null && id.length > 0) {
                                grid.delete_records.push(id);
                            }
                        }
                        var index = null;
                        if (!!record) {
                            index = record.recordIndex;
                        }
                        //清空历表格历史数据
                        grid.getStore().removeAll();
                        //添加新生成的数据
                        for (let i = 0; i < tempArray.length; i++) {
                            grid.insertData(index, tempArray[i]);
                        }
                    }).fail(function (result) {
                    Ext.MessageBox.alert('提示', '获取提款次数失败！' + (!result.message ? '' : result.message));
                });
            }
        }
    ];
    return Ext.create('Ext.window.Window', {
        title: '还款拆分', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'hkcf_win', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWin_hkcf_grid(config)],
        tbar: tbar,
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    var hkmxFromData = insertHkmxFromData();
                    var grid = DSYGrid.getGrid('hkcf_grid');
                    var store = grid.getStore();
                    var form_data_main = hkmxFromData;
                    var form_data_child = [];
                    var tempMainMap = {
                        'PAY_BJ_AMT': 0, 'BJ_MY_AMT': 0, 'PAY_BJ_RMB': 0,
                        'LX_MY_AMT': 0, 'PAY_LX_AMT': 0, 'PAY_LX_RMB': 0,
                        'CNF_MY_AMT': 0, 'PAY_CNF': 0, 'PAY_CNF_RMB': 0,
                        'ZDF_MY_AMT': 0, 'ZDF_YB_AMT': 0, 'ZDF_RMB_AMT': 0,
                        'DBF_MY_AMT': 0, 'DBF_YB_AMT': 0, 'DBF_RMB_AMT': 0,
                        'HD_AMT': 0
                    };
                    for (var i = 0; i < store.getCount(); i++) {
                        var record = store.getAt(i);
                        //主表格数据线拼接
                        tempMainMap.PAY_BJ_AMT += record.data.PAY_BJ_AMT;
                        tempMainMap.BJ_MY_AMT += record.data.BJ_MY_AMT;
                        tempMainMap.PAY_BJ_RMB += record.data.PAY_BJ_RMB;
                        tempMainMap.LX_MY_AMT += record.data.LX_MY_AMT;
                        tempMainMap.PAY_LX_AMT += record.data.PAY_LX_AMT;
                        tempMainMap.PAY_LX_RMB += record.data.PAY_LX_RMB;
                        tempMainMap.CNF_MY_AMT += record.data.CNF_MY_AMT;
                        tempMainMap.PAY_CNF += record.data.PAY_CNF;
                        tempMainMap.PAY_CNF_RMB += record.data.PAY_CNF_RMB;
                        tempMainMap.ZDF_MY_AMT += record.data.ZDF_MY_AMT;
                        tempMainMap.ZDF_YB_AMT += record.data.ZDF_YB_AMT;
                        tempMainMap.ZDF_RMB_AMT += record.data.ZDF_RMB_AMT;
                        tempMainMap.DBF_MY_AMT += record.data.DBF_MY_AMT;
                        tempMainMap.DBF_YB_AMT += record.data.DBF_YB_AMT;
                        tempMainMap.DBF_RMB_AMT += record.data.DBF_RMB_AMT;
                        tempMainMap.HD_AMT = form_data_main.HD_AMT;

                        //子表格数据 拼接
                        var tempMap = {};
                        tempMap['WZXY_ID'] = form_data_main.WZXY_ID;
                        tempMap['START_DATE'] = form_data_main.START_DATE;
                        tempMap['END_DATE'] = form_data_main.END_DATE;
                        tempMap['AG_NAME'] = record.data.AG_NAME;
                        tempMap['FKTZ_DTL_ID'] = record.data.FKTZ_DTL_ID;

                        tempMap['PAY_BJ_AMT'] = record.data.PAY_BJ_AMT;
                        tempMap['BJ_MY_AMT'] = record.data.BJ_MY_AMT;
                        tempMap['PAY_BJ_RMB'] = record.data.PAY_BJ_RMB;
                        tempMap['LX_MY_AMT'] = record.data.LX_MY_AMT;
                        tempMap['PAY_LX_AMT'] = record.data.PAY_LX_AMT;
                        tempMap['PAY_LX_RMB'] = record.data.PAY_LX_RMB;
                        tempMap['CNF_MY_AMT'] = record.data.CNF_MY_AMT;
                        tempMap['PAY_CNF'] = record.data.PAY_CNF;
                        tempMap['PAY_CNF_RMB'] = record.data.PAY_CNF_RMB;
                        tempMap['ZDF_MY_AMT'] = record.data.ZDF_MY_AMT;
                        tempMap['ZDF_YB_AMT'] = record.data.ZDF_YB_AMT;
                        tempMap['ZDF_RMB_AMT'] = record.data.ZDF_RMB_AMT;
                        tempMap['DBF_MY_AMT'] = record.data.DBF_MY_AMT;
                        tempMap['DBF_YB_AMT'] = record.data.DBF_YB_AMT;
                        tempMap['DBF_RMB_AMT'] = record.data.DBF_RMB_AMT;
                        tempMap['HD_AMT'] = record.data.HD_AMT;
                        form_data_child.push(tempMap);
                    }
                    form_data_main = $.extend(form_data_main, tempMainMap);
                    var records_add = [];
                    var records_update = [];
                    for (var i = 0; i < form_data_child.length; i++) {
                        var map = form_data_child[i];

                        if (!!map.FKTZ_DTL_ID) {
                            records_update.push(map);
                        } else {
                            records_add.push(map);
                        }
                    }
                    $.ajax({
                            type: "POST",
                            url: "/wzgl_nx/hkgl/saveHkmx.action?",
                            data: {
                                wf_id: wf_id,
                                node_code: node_code,
                                button_name: button_name,
                                list_add: JSON.stringify(records_add),
                                list_update: JSON.stringify(records_update),
                                list_del: grid.delete_records,
                                formList: Ext.util.JSON.encode(form_data_main)
                            },
                            dataType: 'json'
                        }
                    )
                        .done(function (result) {
                            btn.setDisabled(false);
                            if (!result.success) {
                                Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
                                return false;
                            }
                            //请求成功时处理
                            Ext.toast({
                                html: '保存成功！',
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            btn.up('window').close();
                            var window = Ext.ComponentQuery.query('window#window_input_hklr')[0];
                            window.close();
                            // 刷新表格
                            reloadGrid();
                        })
                        .fail(function (result) {
                            Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
                            btn.setDisabled(false);
                        });
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
 * 初始化还款拆分表
 */
function initWin_hkcf_grid(config) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "FKTZ_ID", type: "string", text: "主单id", hidden: true},
        {dataIndex: "FK_TASK_ID", type: "string", text: "主键id", hidden: true},
        {dataIndex: "WZXY_ID", type: "string", text: "外债协议ID", hidden: true},
        {
            dataIndex: "AG_NAME", type: "string", width: 200, text: "项目县区/单位", editor: {
                xtype: "textfield"
            }
        },
        {dataIndex: "HK_CODE", type: "int", text: "还款次数"},
        {
            header: '还款区间', columns: [
                {dataIndex: "START_DATE", type: "string", text: "起始时间", width: 180},
                {dataIndex: "END_DATE", type: "string", text: "终止时间", width: 180}]
        },
        {
            header: '累计提款金额', columns: [
                {
                    dataIndex: "LJTK_BWB",
                    type: "float",
                    text: "累计提款本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LJTK_MY",
                    type: "float",
                    text: "累计提款美元(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LJTK_RMB",
                    type: "float",
                    text: "累计提款人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还本金', columns: [
                {
                    dataIndex: "PAY_BJ_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还利息', columns: [
                {
                    dataIndex: "PAY_LX_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还承诺费', columns: [
                {
                    dataIndex: "PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_CNF_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还转贷费', columns: [
                {
                    dataIndex: "ZDF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还担保费', columns: [
                {
                    dataIndex: "DBF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum', editor: {
                        xtype: "numberFieldFormat",
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            dataIndex: "HD_AMT", type: "float", text: "汇兑人民币(万元)", width: 180, summaryType: 'sum', editor: {
                xtype: "numberFieldFormat",
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value, metadata, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            header: '累计应还本金', columns: [
                {
                    dataIndex: "YH_PAY_BJ_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_PAY_BJ_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还利息', columns: [
                {
                    dataIndex: "YH_PAY_LX_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_PAY_LX_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还承诺费', columns: [
                {
                    dataIndex: "YH_ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_CNF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还转贷费', columns: [
                {
                    dataIndex: "YH_ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计应还担保费', columns: [
                {
                    dataIndex: "YH_DBF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_DBF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还本金', columns: [
                {
                    dataIndex: "CH_BJ_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_BJ_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还利息', columns: [
                {
                    dataIndex: "CH_LX_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_LX_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还承诺费', columns: [
                {
                    dataIndex: "CH_CNF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_CNF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还转贷费', columns: [
                {
                    dataIndex: "CH_ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '累计已还担保费', columns: [
                {
                    dataIndex: "CH_DBF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CH_DBF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'hkcf_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: config.hkmx_data,
        flex: 1,
        width: '100%',
        height: '100%',
        features: [{ftype: 'summary'}],
        plugins: [
            {ptype: 'cellediting', clicksToEdit: 1, pluginId: 'cellEdit', clicksToMoveEditor: 1}
        ],
        pageConfig: {
            enablePage: false
        },
        listeners: {
            'edit': function (editor, context) {
                var hkmxData = config.hkmx_data;
                if (context.field === 'AG_NAME') {
                    var record = DSYGrid.getGrid('hkcf_grid').getCurrentRecord();
                    for (let i = 0; i < hkmxData.length; i++) {
                        if (hkmxData[i].AG_NAME == context.record.data.AG_NAME) {
                            //累计提款
                            context.record.set("LJTK_BWB", hkmxData[i].LJTK_BWB);
                            context.record.set("LJTK_MY", hkmxData[i].LJTK_MY);
                            context.record.set("LJTK_RMB", hkmxData[i].LJTK_RMB);
                            //累计应还
                            context.record.set("YH_BJ_MY_AMT", hkmxData[i].YH_BJ_MY_AMT);
                            context.record.set("YH_PAY_BJ_AMT", hkmxData[i].YH_PAY_BJ_AMT);
                            context.record.set("YH_PAY_BJ_RMB", hkmxData[i].YH_PAY_BJ_RMB);
                            context.record.set("YH_CNF_MY_AMT", hkmxData[i].YH_CNF_MY_AMT);
                            context.record.set("YH_CNF_RMB_AMT", hkmxData[i].YH_CNF_RMB_AMT);
                            context.record.set("YH_DBF_MY_AMT", hkmxData[i].YH_DBF_MY_AMT);
                            context.record.set("YH_DBF_RMB_AMT", hkmxData[i].YH_DBF_RMB_AMT);
                            context.record.set("YH_DBF_YB_AMT", hkmxData[i].YH_DBF_YB_AMT);
                            context.record.set("YH_LX_MY_AMT", hkmxData[i].YH_LX_MY_AMT);
                            context.record.set("YH_PAY_LX_AMT", hkmxData[i].YH_PAY_LX_AMT);
                            context.record.set("YH_PAY_LX_RMB", hkmxData[i].YH_PAY_LX_RMB);
                            context.record.set("YH_ZDF_MY_AMT", hkmxData[i].YH_ZDF_MY_AMT);
                            context.record.set("YH_ZDF_RMB_AMT", hkmxData[i].YH_ZDF_RMB_AMT);
                            context.record.set("YH_ZDF_YB_AMT", hkmxData[i].YH_ZDF_YB_AMT);
                            context.record.set("YH_ZDF_YB_AMT", hkmxData[i].YH_ZDF_YB_AMT);
                            context.record.set("YH_PAY_CNF", hkmxData[i].YH_PAY_CNF);
                            //累计已还
                            context.record.set("CH_BJ_MY_AMT", hkmxData[i].CH_BJ_MY_AMT);
                            context.record.set("CH_BJ_RMB_AMT", hkmxData[i].CH_BJ_RMB_AMT);
                            context.record.set("CH_BJ_YB_AMT", hkmxData[i].CH_BJ_YB_AMT);
                            context.record.set("CH_CNF_MY_AMT", hkmxData[i].CH_CNF_MY_AMT);
                            context.record.set("CH_CNF_RMB_AMT", hkmxData[i].CH_CNF_RMB_AMT);
                            context.record.set("CH_CNF_YB_AMT", hkmxData[i].CH_CNF_YB_AMT);
                            context.record.set("CH_DBF_MY_AMT", hkmxData[i].CH_DBF_MY_AMT);
                            context.record.set("CH_DBF_RMB_AMT", hkmxData[i].CH_DBF_RMB_AMT);
                            context.record.set("CH_DBF_YB_AMT", hkmxData[i].CH_DBF_YB_AMT);
                            context.record.set("CH_LX_MY_AMT", hkmxData[i].CH_LX_MY_AMT);
                            context.record.set("CH_LX_RMB_AMT", hkmxData[i].CH_LX_RMB_AMT);
                            context.record.set("CH_LX_YB_AMT", hkmxData[i].CH_LX_YB_AMT);
                            context.record.set("CH_ZDF_MY_AMT", hkmxData[i].CH_ZDF_MY_AMT);
                            context.record.set("CH_ZDF_YB_AMT", hkmxData[i].CH_ZDF_YB_AMT);
                            context.record.set("CH_ZDF_RMB_AMT", hkmxData[i].CH_ZDF_RMB_AMT);
                            return;
                        }
                    }
                }
            }
        }
    });
    return grid;
}

/**
 * 查看操作记录
 */
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        var XX_ID = records[0].get("FKTZ_ID");
        fuc_getWorkFlowLog(XX_ID);
    }
}

/**
 * 工作流意见框
 * @param config
 * @returns {*}
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
 * 变更工作流
 * @param btn
 */
function doWorkFlow(btn) {
    // 检验是否选中数据 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("FKTZ_ID"));
    }
    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/wzgl_nx/hkgl/hkMxDowork.action", {
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
                        Ext.MessageBox.alert('提示', '送审失败！' + (!data.message ? '' : data.message));
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
            value: btn.name == 'down' ? '同意' : null,
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/wzgl_nx/hkgl/hkMxDowork.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids,
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
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid(param, param_detail) {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();

    //增加查询参数
    if (typeof param != 'undefined' && param != null) {
        for (var name in param) {
            store.getProxy().extraParams[name] = param[name];
        }
    }
    //刷新
    store.loadPage(1);
    //刷新下方表格,置为空
    if (DSYGrid.getGrid('contentGrid_detail')) {
        DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();

    }
}

$(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
});