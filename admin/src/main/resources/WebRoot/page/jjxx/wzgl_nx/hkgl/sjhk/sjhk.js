var button_name = '';

/**
 * 工作流节点
 */
var wzzd_json_common = {
    101080: {
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
                            window_select.show();
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
                            modify(record, btn);
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
                                        ids.push(record.get('HK_ID'));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post("/wzgl_nx/hkgl/deleteHkInfo.action?", {
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
                            var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                            if (record === null || record === '') {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            }
                            modify(records, btn);
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
                                        ids.push(record.get('HK_ID'));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post("/wzgl_nx/hkgl/deleteHkInfo.action?", {
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
 * 创建外债信息选择弹出窗口
 */
var window_select = {
    window: null,
    show: function (params) {
        this.window = initWin_xy(params);
        this.window.show();
    }
};

/**
 * 创建付款信息填报弹出窗口
 * @type {{wz_code: null, show: window_input.show, window: null}}
 */
var window_input = {
    window: null,
    wz_code: null,
    show: function () {
        this.window = initWin_hksq();
        this.window.show();
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
            initContentGrid()
        ]
    });
}

/**
 * 初始化主界面主表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "外债协议id", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "币种", dataIndex: "NAME", type: "string", hidden: true},
        {text: "主单id", dataIndex: "HK_ID", type: "string", hidden: true},
        {dataIndex: "XY_AG_NAME", type: "string", width: 150, text: "项目地区"},
        {dataIndex: "WZXY_CODE", type: "string", width: 150, text: "外债编码"},
        {
            dataIndex: "WZXY_NAME",
            width: 300,
            type: "string",
            text: "项目名称",
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
        {dataIndex: "HK_CODE", type: "string", width: 100, text: "还款次数"},
        {dataIndex: "HK_DATE", type: "string", width: 100, text: "还款时间"},
        {
            header: '还款区间', columns: [
                {dataIndex: "HKQJ_S_DATE", type: "string", text: "起始时间", width: 100},
                {dataIndex: "HKQJ_E_DATE", type: "string", text: "终止时间", width: 100}
            ]
        },
        {
            header: '应还合计', columns: [
                {
                    dataIndex: "YHYB", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value, metadata, record) {
                        record.data.YHYB = Decimal.addBatch(record.data.YH_BJ_YB_AMT, record.data.YH_LX_YB_AMT, record.data.YH_CNF_YB_AMT, record.data.YH_ZDF_YB_AMT, record.data.YH_DBF_YB_AMT);
                        return Ext.util.Format.number(record.data.YHYB, '0,000.######');
                    }
                },
                {
                    dataIndex: "YHMY", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value, metadata, record) {
                        record.data.YHMY = Decimal.addBatch(record.data.YH_BJ_MY_AMT, record.data.YH_LX_MY_AMT, record.data.YH_CNF_MY_AMT, record.data.YH_ZDF_MY_AMT, record.data.YH_DBF_MY_AMT);
                        return Ext.util.Format.number(record.data.YHMY, '0,000.######');
                    }
                },
                {
                    dataIndex: "YHRMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value, metadata, record) {
                        record.data.YHRMB = Decimal.addBatch(record.data.YH_BJ_RMB_AMT, record.data.YH_LX_RMB_AMT, record.data.YH_CNF_RMB_AMT, record.data.YH_ZDF_RMB_AMT, record.data.YH_DBF_RMB_AMT);
                        return Ext.util.Format.number(record.data.YHRMB, '0,000.######');
                    }
                }
            ]
        },
        {
            header: '应还本金', columns: [
                {
                    dataIndex: "YH_BJ_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "YH_BJ_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            header: '应还利息', columns: [
                {
                    dataIndex: "YH_LX_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "YH_LX_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '应还承诺费', columns: [
                {
                    dataIndex: "YH_CNF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "YH_CNF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '应还转贷费', columns: [
                {
                    dataIndex: "YH_ZDF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "YH_ZDF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '应还担保费', columns: [
                {
                    dataIndex: "YH_DBF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "YH_DBF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '实还合计', columns: [
                {
                    dataIndex: "SJYB", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value, metadata, record) {
                        record.data.SJYB = Decimal.addBatch(record.data.BJ_YB_AMT, record.data.LX_YB_AMT, record.data.CNF_YB_AMT, record.data.ZDF_YB_AMT, record.data.DBF_YB_AMT);
                        return Ext.util.Format.number(record.data.SJYB, '0,000.######');
                    }
                },
                {
                    dataIndex: "SJMY", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value, metadata, record) {
                        record.data.SJMY = Decimal.addBatch(record.data.BJ_MY_AMT, record.data.LX_MY_AMT, record.data.CNF_MY_AMT, record.data.ZDF_MY_AMT, record.data.DBF_MY_AMT);
                        return Ext.util.Format.number(record.data.SJMY, '0,000.######');
                    }
                },
                {
                    dataIndex: "SJRMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value, metadata, record) {
                        record.data.SJRMB = Decimal.addBatch(record.data.BJ_RMB_AMT, record.data.LX_RMB_AMT, record.data.CNF_RMB_AMT, record.data.ZDF_RMB_AMT, record.data.DBF_RMB_AMT);
                        return Ext.util.Format.number(record.data.SJRMB, '0,000.######');
                    }
                }]
        },
        {
            header: '实还本金', columns: [
                {
                    dataIndex: "BJ_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '实还利息', columns: [
                {
                    dataIndex: "LX_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '实还承诺费', columns: [
                {
                    dataIndex: "CNF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '实还转贷费', columns: [
                {
                    dataIndex: "ZDF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '实还担保费', columns: [
                {
                    dataIndex: "DBF_YB_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT", type: "float", text: "美元(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            dataIndex: "HD", type: "float", text: "人民币汇兑(万元)", width: 180, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value, metadata, record) {
                var YHRMB = Decimal.addBatch(record.data.YH_BJ_RMB_AMT, record.data.YH_LX_RMB_AMT, record.data.YH_CNF_RMB_AMT, record.data.YH_ZDF_RMB_AMT, record.data.YH_DBF_RMB_AMT);
                var SJRMB = Decimal.addBatch(record.data.BJ_RMB_AMT, record.data.LX_RMB_AMT, record.data.CNF_RMB_AMT, record.data.ZDF_RMB_AMT, record.data.DBF_RMB_AMT);
                record.data.HD = Decimal.subBatch(SJRMB, YHRMB);
                return Ext.util.Format.number(record.data.HD, '0,000.######');
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
        dataUrl: '/wzgl_nx/hkgl/getHksjtbMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        features: [{
            ftype: 'summary'
        }],
        height: '100%',
        width: '100%',
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
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
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
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();
                    $.ajax({
                            type: "POST",
                            url: "/wzgl_nx/hkgl/getMaxHkCode.action",
                            data: {
                                WZXY_ID: record.WZXY_ID
                            },
                            dataType: 'json'
                        }
                    )
                        .done(function (result) {
                            if (!result.success) {
                                Ext.MessageBox.alert('提示', '获取失败！' + (!result.message ? '' : result.message));
                                return false;
                            }
                            record.HK_CODE = Decimal.addBatch(result.HKCODE, 1);
                            window_input.show();
                            window_input.window.down('form').getForm().setValues(record);
                            btn.up('window').close();
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
 * 初始化还款申请录入窗口
 */
function initWin_hksq() {
    return Ext.create('Ext.window.Window', {
        title: '还款申请录入', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input2', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_hksq_form()],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    saveData(btn);
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
 * 上级还款信息录入
 */
function initWindow_hksq_form() {
    var editForm = Ext.create('Ext.form.Panel', {
        itemId: 'sjhk_form',
        width: '100%',
        height: '100%',
        layout: 'column',
        border: false,
        defaultType: 'textfield',
        autoScroll: true,
        defaults: {
            margin: '2 5 2 5',
            columnWidth: .33,
            labelWidth: 125//控件默认标签宽度
        },
        items: [
            {
                fieldLabel: '<span class="required">✶</span>还款次数',
                xtype: "numberFieldFormat",
                name: "HK_CODE",
                allowBlank: false,
                hideTrigger: true
            },
            {fieldLabel: '项目名称', name: "WZXY_NAME", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '外债编码', name: "WZXY_CODE", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '协议币种', name: "NAME", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '外债协议ID', name: "WZXY_ID", hidden: true},
            {
                fieldLabel: '<span class="required">✶</span>还款时间',
                xtype: 'datefield',
                name: 'HK_DATE',
                editable: false,
                allowBlank: false,
                format: 'Y-m-d'
            },
            {
                xtype: 'fieldcontainer', fieldLabel: '<span class="required">✶</span>还款区间', layout: 'hbox', labelWidth: 125,
                items: [
                    {
                        xtype: 'datefield',
                        name: 'HKQJ_S_DATE',
                        editable: false,
                        allowBlank: false,
                        format: 'Y-m-d',
                        flex: 1,
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var HKQJ_E_DATE = self.up('form').down("datefield[name='HKQJ_E_DATE']").getValue();
                                if (HKQJ_E_DATE == null || HKQJ_E_DATE == "" || newValue == null || newValue == "") {
                                    return;
                                }
                                HKQJ_E_DATE = format(HKQJ_E_DATE, 'yyyy-MM-dd');
                                newValue = format(newValue, 'yyyy-MM-dd');
                                if (newValue > HKQJ_E_DATE) {
                                    Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                    self.up('form').getForm().findField('HKQJ_S_DATE').setValue("");
                                    return;
                                }
                            }
                        }
                    },
                    {xtype: 'label', text: '至', margin: '3 6 3 6', width: 20},
                    {
                        xtype: 'datefield',
                        name: 'HKQJ_E_DATE',
                        flex: 1,
                        editable: false,
                        allowBlank: false,
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var WZXY_ID = self.up('form').down("[name='WZXY_ID']").getValue();
                                var HK_ID = self.up('form').down("[name='HK_ID']").getValue();
                                if (newValue == null || newValue == "") {
                                    return;
                                }
                                newValue = format(newValue, 'yyyy-MM-dd');
                                getSjhkByDate(newValue, WZXY_ID, HK_ID);
                            }
                        }
                    }
                ]
            },
            {fieldLabel: '序号', name: "HK_ID", hidden: true},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                title: '应还合计',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: "YHYB"},
                    {fieldLabel: '美元(万元)', name: "YHMY"},
                    {fieldLabel: '人民币(万元)', name: "YHRMB"}
                ]
            },
            {
                title: '应还本金',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    hideTrigger: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'YH_BJ_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'YH_BJ_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'YH_BJ_RMB_AMT'}
                ]
            },
            {
                title: '应还利息',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'YH_LX_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'YH_LX_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'YH_LX_RMB_AMT'}
                ]
            },
            {
                title: '应还承诺费',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'YH_CNF_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'YH_CNF_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'YH_CNF_RMB_AMT'}
                ]
            },
            {
                title: '应还转贷费',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'YH_ZDF_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'YH_ZDF_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'YH_ZDF_RMB_AMT'}
                ]
            },
            {
                title: '应还担保费',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'YH_DBF_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'YH_DBF_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'YH_DBF_RMB_AMT'}
                ]
            },
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                title: '实还合计',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    fieldCls: 'form-unedit-number',
                    editable: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'SJYB'},
                    {fieldLabel: '美元(万元)', name: 'SJMY'},
                    {fieldLabel: '人民币(万元)', name: 'SJRMB'}
                ]
            },
            {
                title: '<span class="required">✶</span>实还本金',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0,
                    listeners: {
                        change: function (self, newValue) {
                            calSum();
                        }
                    }
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'BJ_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'BJ_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'BJ_RMB_AMT'}
                ]
            },
            {
                title: '<span class="required">✶</span>实还利息',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0,
                    listeners: {
                        change: function (self, newValue) {
                            calSum();
                        }
                    }
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'LX_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'LX_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'LX_RMB_AMT'}
                ]
            },
            {
                title: '<span class="required">✶</span>实还承诺费',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0,
                    listeners: {
                        change: function (self, newValue) {
                            calSum();
                        }
                    }
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'CNF_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'CNF_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'CNF_RMB_AMT'}
                ]
            },
            {
                title: '<span class="required">✶</span>实还转贷费',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0,
                    listeners: {
                        change: function (self, newValue) {
                            calSum();
                        }
                    }
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'ZDF_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'ZDF_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'ZDF_RMB_AMT'}
                ]
            },
            {
                title: '<span class="required">✶</span>实还担保费',
                xtype: "fieldset",
                columnWidth: 1,
                layout: 'column',
                defaultType: 'numberFieldFormat',
                allowBlank: false,
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    hideTrigger: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    value: 0,
                    listeners: {
                        change: function (self, newValue) {
                            calSum();
                        }
                    }
                },
                items: [
                    {fieldLabel: '本位币(万元)', name: 'DBF_YB_AMT'},
                    {fieldLabel: '美元(万元)', name: 'DBF_MY_AMT'},
                    {fieldLabel: '人民币(万元)', name: 'DBF_RMB_AMT'}
                ]
            },
            {fieldLabel: '汇兑(人民币(万元))', xtype: "textfield", name: "HD", editable: false, fieldCls: 'form-unedit'}
        ]
    });
    return editForm;
}

/**
 * 根据截至时间来获取 应还金额
 * @param HKQJ_E_DATE
 * @param WZXY_ID
 */
function getSjhkByDate(HKQJ_E_DATE, WZXY_ID, HK_ID) {
    $.ajax({
            type: "POST",
            url: "/wzgl_nx/hkgl/getHksjtbByDateInfo.action",
            data: {
                HKQJ_E_DATE: HKQJ_E_DATE,
                WZXY_ID: WZXY_ID,
                HK_ID: HK_ID
            },
            dataType: 'json'
        }
    )
        .done(function (result) {
            if (!result.success) {
                Ext.MessageBox.alert('提示', '获取失败！' + (!result.message ? '' : result.message));
                return false;
            }
            result.data['YHYB'] = Decimal.addBatch(result.data.YH_BJ_YB_AMT, result.data.YH_LX_YB_AMT, result.data.YH_CNF_YB_AMT, result.data.YH_ZDF_YB_AMT, result.data.YH_DBF_YB_AMT);
            result.data['YHMY'] = Decimal.addBatch(result.data.YH_BJ_MY_AMT, result.data.YH_LX_MY_AMT, result.data.YH_CNF_MY_AMT, result.data.YH_ZDF_MY_AMT, result.data.YH_DBF_MY_AMT);
            result.data['YHRMB'] = Decimal.addBatch(result.data.YH_BJ_RMB_AMT, result.data.YH_LX_RMB_AMT, result.data.YH_CNF_RMB_AMT, result.data.YH_ZDF_RMB_AMT, result.data.YH_DBF_RMB_AMT);

            window_input.window.down('form').getForm().setValues(result.data);
        });
}

/**
 * 动态计算 合计金额
 * @returns {boolean}
 */
function calSum() {
    var form = Ext.ComponentQuery.query('form#sjhk_form');
    if (!form || form.length <= 0) {
        return false;
    }
    form = form[0];
    var form_data = form.getForm().getFieldValues();
    form_data = $.extend({}, form_data, form.getValues());
    form_data.YHYB = Decimal.addBatch(form_data.YH_BJ_YB_AMT, form_data.YH_LX_YB_AMT, form_data.YH_CNF_YB_AMT, form_data.YH_ZDF_YB_AMT, form_data.YH_DBF_YB_AMT);
    form_data.YHMY = Decimal.addBatch(form_data.YH_BJ_MY_AMT, form_data.YH_LX_MY_AMT, form_data.YH_CNF_MY_AMT, form_data.YH_ZDF_MY_AMT, form_data.YH_DBF_MY_AMT);
    form_data.YHRMB = Decimal.addBatch(form_data.YH_BJ_RMB_AMT, form_data.YH_LX_RMB_AMT, form_data.YH_CNF_RMB_AMT, form_data.YH_ZDF_RMB_AMT, form_data.YH_DBF_RMB_AMT);
    form_data.SJYB = Decimal.addBatch(form_data.BJ_YB_AMT, form_data.LX_YB_AMT, form_data.CNF_YB_AMT, form_data.ZDF_YB_AMT, form_data.DBF_YB_AMT);
    form_data.SJMY = Decimal.addBatch(form_data.BJ_MY_AMT, form_data.LX_MY_AMT, form_data.CNF_MY_AMT, form_data.ZDF_MY_AMT, form_data.DBF_MY_AMT);
    form_data.SJRMB = Decimal.addBatch(form_data.BJ_RMB_AMT, form_data.LX_RMB_AMT, form_data.CNF_RMB_AMT, form_data.ZDF_RMB_AMT, form_data.DBF_RMB_AMT);
    form_data.HD = Decimal.subBatch(form_data.SJRMB, form_data.YHRMB);
    form.down('[name=SJYB]').setValue(form_data.SJYB);
    form.down('[name=SJMY]').setValue(form_data.SJMY);
    form.down('[name=SJRMB]').setValue(form_data.SJRMB);
    form.down('[name=HD]').setValue(form_data.HD);
}

/**
 * 保存数据
 * @param btn
 * @returns {boolean}
 */
function saveData(btn) {
    var form = btn.up('window').down('form');
    if (!form.isValid()) {
        console.log('校验失败', form);
        Ext.toast({html: "请检查表单校验未通过内容！", closable: false, align: 't', slideInDuration: 400, minWidth: 400});
        return false;
    }
    var form_data = form.getForm().getValues();
    //校验数据
    var message = '';
    if (isNull(form_data.HK_CODE)) {
        message += '还款次数必须大于0！\n';
    }
    if (isNull(form_data.HK_DATE)) {
        message += '还款时间为必填项！\n';
    }
    if (isNull(form_data.HKQJ_E_DATE)) {
        message += '还款区间结束时间为必填项！\n';
    }
    /*if (form_data.SJYB > form_data.YHYB) {
        message += '实还合计本位币不能大于应还合计本位币！\n';
    }
    if (form_data.SJMY > form_data.YHMY) {
        message += '实还合计美元不能大于应还合计美元！\n';
    }
    if (form_data.SJRMB > form_data.YHRMB) {
        message += '实还合计人民币不能大于应还合计人民币！\n';
    }*/
    if (!isNull(message)) {
        Ext.MessageBox.alert('提示', '保存失败！' + message);
        return false;
    }
    btn.setDisabled(true);
    $.ajax({
            type: "POST",
            url: "/wzgl_nx/hkgl/saveSjhk.action",
            data: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                formList: Ext.util.JSON.encode(form_data)
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
            // 刷新表格
            reloadGrid();
        })
        .fail(function (result) {
            Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
            btn.setDisabled(false);
        });
}

/**
 * 修改
 * @param records
 * @param btn
 */
function modify(record, btn) {
    //应还合计
    // record.data.YHYB = Decimal.addBatch(record.data.YH_BJ_YB_AMT, record.data.YH_LX_YB_AMT, record.data.YH_CNF_YB_AMT, record.data.YH_ZDF_YB_AMT, record.data.YH_DBF_YB_AMT);
    // record.data.YHMY = Decimal.addBatch(record.data.YH_BJ_MY_AMT, record.data.YH_LX_MY_AMT, record.data.YH_CNF_MY_AMT, record.data.YH_ZDF_MY_AMT, record.data.YH_DBF_MY_AMT);
    // record.data.YHRMB = Decimal.addBatch(record.data.YH_BJ_RMB_AMT, record.data.YH_LX_RMB_AMT, record.data.YH_CNF_RMB_AMT, record.data.YH_ZDF_RMB_AMT, record.data.YH_DBF_RMB_AMT);

    window_input.show();
    window_input.window.down('form').getForm().setValues(record.data);
    calSum();
}

/**
 * 树点击节点时触发，刷新content主表格
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
        var XX_ID = records[0].get("HK_ID");
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
        ids.push(records[i].get("HK_ID"));
    }
    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/wzgl_nx/hkgl/hkDowork.action", {
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
                    $.post("/wzgl_nx/hkgl/hkDowork.action", {
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
 * 加载初始化页面
 */
$(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
    reloadGrid();
});
