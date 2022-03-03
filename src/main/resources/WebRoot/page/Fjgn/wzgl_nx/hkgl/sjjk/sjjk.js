/**
 * 存储选择主单后的明细列表
 * @type {Ext.data.Store}
 */
var store_sjjk = Ext.create('Ext.data.Store', {
    fields: ["FKTZ_DTL_ID", "FKTZ_ID", "WZXY_ID", "AG_NAME", "PAY_BJ_AMT", "BJ_MY_AMT", "PAY_BJ_RMB", "PAY_LX_AMT", "LX_MY_AMT", "PAY_LX_RMB", "PAY_CNF", "CNF_MY_AMT", "PAY_CNF_RMB", "ZDF_YB_AMT", "ZDF_MY_AMT", "ZDF_RMB_AMT", "DBF_YB_AMT", "DBF_MY_AMT", "DBF_RMB_AMT"],
    remoteSort: true,// 后端进行排序
    proxy: {
        type: 'ajax',
        url: "/wzgl_nx/hkgl/getSjjkByFktzId.action",
        method: "POST",
        extraParams: {},
        reader: {
            type: "json",
            root: "list",
            totalProperty: "totalcount"
        },
        actionMethods: {
            read: 'POST' // Store设置请求的方法，与Ajax请求有区别
        },
        timeout: 600000,
        simpleSortMode: true
    },
    autoLoad: false
});

/**
 * 创建协议信息
 */
var window_select = {
    window: null,
    show: function (params) {
        this.window = initWin_xy(params);
        this.window.show();
    }
};

/**
 * 刷新表格
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    //模糊查询
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    //传参
    store.getProxy().extraParams = {
        mhcx: mhcx,
    };
    store.loadPage(1);
    //明细表格数据删除
    DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
}

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
        tbar: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '录入',
                name: 'input',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    window_select.show({
                        button_name: btn.name,
                        button_text: btn.text,
                    });
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作!');
                        return false;
                    }
                    //刷新下拉框
                    store_sjjk.getProxy().extraParams.FKTZ_ID = record.get('FKTZ_ID');
                    store_sjjk.reload();

                    btn.setDisabled(true);
                    $.ajax({
                            type: "POST",
                            url: "/wzgl_nx/hkgl/getSjjkmx.action",
                            data: {
                                HKD_ID: record.get('HKD_ID'),
                            },
                            dataType: 'json'
                        }
                    )
                        .done(function (result) {
                            btn.setDisabled(false);
                            if (!result.success) {
                                Ext.MessageBox.alert('提示', '数据查询失败！' + (!result.message ? '' : result.message));
                                return false;
                            }
                            //弹出实际缴款编辑窗口
                            initWin_sjjk_edit({
                                sjjkForm: record.getData(),
                                sjjkList: result.list
                            }).show();
                        })
                        .fail(function (result) {
                            Ext.MessageBox.alert('提示', '数据查询失败！' + (!result.message ? '' : result.message));
                            btn.setDisabled(false);
                        });
                }
            },
            {
                xtype: 'button',
                name: 'btn_del',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条数据记录！');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            var arr = [];
                            Ext.Array.forEach(records, function (record) {
                                arr.push(record.get("HKD_ID"))
                            });
                            $.post("/wzgl_nx/hkgl/delSjjkInfo.action", {
                                ids: arr
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: "删除成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                } else {
                                    Ext.MessageBox.alert('提示', '删除失败！' + data.message);
                                }
                                //刷新表格
                                reloadGrid();
                            }, "json");
                        }
                    });
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        items: [
            initContentGrid(),
            initContentDetilGrid()
        ]
    });
    reloadGrid();
}

/**
 * 初始化主界面主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {dataIndex: "FKTZ_ID", type: "string", width: 130, text: "主单id", hidden: true},
        {dataIndex: "WZXY_ID", type: "string", width: 130, text: "外债协议id", hidden: true},
        {dataIndex: "HKD_ID", type: "string", width: 130, text: "虚拟缴款主单id", hidden: true},
        {dataIndex: "LX_RATE", text: "贷款利率", type: "string", hidden: true},
        {dataIndex: "ZD_RATE", text: "转贷费率", type: "string", hidden: true},
        {dataIndex: "DB_RATE", text: "担保费率", type: "string", hidden: true},
        {dataIndex: "YBMYHL_RATE", text: "原币/美元汇率", type: "string", hidden: true},
        {dataIndex: "RMBMYHL_RATE", text: "人民币/美元汇率", type: "string", hidden: true},
        {dataIndex: "HL_RATE", text: "原币/人民币汇率", type: "string", hidden: true},
        {dataIndex: "XY_AG_NAME", type: "string", width: 130, text: "项目地区"},
        {dataIndex: "WZXY_CODE", type: "string", width: 300, text: "外债编码"},
        {
            dataIndex: "WZXY_NAME", width: 150, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "WZXY_ID";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('WZXY_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {dataIndex: "HK_CODE", width: 100, type: "string", text: "还款次数"},
        {
            header: '还款区间',
            colspan: 2,
            align: 'center',
            columns: [{
                dataIndex: "START_DATE", type: "string", text: "起始时间", width: 180
            }, {
                dataIndex: "END_DATE", type: "string", text: "终止时间", width: 180
            }]
        },
        {
            header: '累计提款金额', columns: [{
                dataIndex: "BF_YB_AMT",
                type: "float",
                text: "累计提款本位币(万元)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    hideTrigger: true,
                    emptyText: '0.00',
                    minValue: 0
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            },
                {
                    dataIndex: "BF_MY_AMT",
                    type: "float",
                    text: "累计提款美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        emptyText: '0.00',
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BF_AMT",
                    type: "float",
                    text: "累计提款人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        emptyText: '0.00',
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还本金', columns: [
                {
                    dataIndex: "PAY_BJ_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还利息', columns: [
                {
                    dataIndex: "PAY_LX_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还承诺费', columns: [
                {
                    dataIndex: "PAY_CNF",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "PAY_CNF_RMB",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还转贷费', columns: [
                {
                    dataIndex: "ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期应还担保费', columns: [
                {
                    dataIndex: "DBF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        minValue: 0
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        dataUrl: '/wzgl_nx/hkgl/getSjjkMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '100%',
        tbarHeight: 50,
        tbar: [{
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: "XM_SEARCH",
            width: 350,
            labelWidth: 80,
            emptyText: '请输入外债编码 / 项目名称......',
            enableKeyEvents: true,
            //ENTER键刷新表格
            listeners: {
                'keydown': function (self, e, eOpts) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        reloadGrid();
                    }
                }
            }
        }],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['HKD_ID'] = record.get('HKD_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化主界面子表格
 */
function initContentDetilGrid(callback) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "HKD_ID",
            type: "string",
            width: 130,
            text: "虚拟缴款主单id",
            hidden: true
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            width: 130,
            text: "项目县区/单位"
        },
        {
            header: '本期应还本金', columns: [
                {
                    dataIndex: "PAY_BJ_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_BJ_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_LX_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_LX_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_CNF_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
            header: '本期应还担保费', columns: [
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
            text: "还款日期", dataIndex: "HK_DATE", type: "string", width: 180,
        },
        {
            header: '本期已还本金', columns: [
                {
                    dataIndex: "YH_BJ_YB_AMT",
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
                    dataIndex: "YH_BJ_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
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
                    dataIndex: "YH_BJ_RMB_AMT",
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
            header: '本期已还利息', columns: [
                {
                    dataIndex: "YH_LX_YB_AMT",
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
                    dataIndex: "YH_LX_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
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
                    dataIndex: "YH_LX_RMB_AMT",
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
            header: '本期已还承诺费', columns: [
                {
                    dataIndex: "YH_CNF_YB_AMT",
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
                    dataIndex: "YH_CNF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
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
            header: '本期已还转贷费', columns: [
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
                    dataIndex: "YH_ZDF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
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
            header: '本期已还担保费', columns: [
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
                    dataIndex: "YH_DBF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
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
    ];
    var simplyGrid = new DSYGridV2();
    var simplyGridconfig = {
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
        dataUrl: "/wzgl_nx/hkgl/getSjjkmx.action",
    };
    var grid = simplyGrid.create(simplyGridconfig);
    if (callback) {
        callback(grid);
    }
    return grid;
}

/**
 * 初始化还款通知单弹出窗口
 */
function initWin_xy(params) {
    return Ext.create('Ext.window.Window', {
        title: '还款通知单选择', // 窗口标题
        width: document.body.clientWidth * 0.8, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
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
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作!');
                        return false;
                    }
                    btn.setDisabled(true);
                    var config = $.extend(true, {}, {
                        sjjkForm: record.data,
                    });
                    //弹出编辑窗口
                    initWin_sjjk_edit(config).show();
                    btn.up('window').close();

                    //查询明细数据
                    store_sjjk.getProxy().extraParams.FKTZ_ID = record.get('FKTZ_ID');
                    store_sjjk.reload();
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
 * 初始化还款通知单表格
 */
function initWin_xy_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "还款通知单ID", dataIndex: "FKTZ_ID", type: "string", hidden: true},
        {text: "虚拟缴款主单ID", dataIndex: "HKD_ID", type: "string", hidden: true},
        {text: "贷款利率", dataIndex: "LX_RATE", type: "string", hidden: true},
        {text: "转贷费率", dataIndex: "ZD_RATE", type: "string", hidden: true},
        {text: "担保费率", dataIndex: "DB_RATE", type: "string", hidden: true},
        {text: "原币/美元汇率", dataIndex: "YBMYHL_RATE", type: "string", hidden: true},
        {text: "人民币/美元汇率", dataIndex: "RMBMYHL_RATE", type: "string", hidden: true},
        {text: "原币/人民币汇率", dataIndex: "HL_RATE", type: "string", hidden: true},
        {text: "项目地区", dataIndex: "AD_NAME", type: "string", width: 120,},
        {text: "外债编码", dataIndex: "WZXY_CODE", type: "string", width: 150,},
        {
            text: "项目名称",
            dataIndex: "WZXY_NAME",
            type: "string",
            width: 355,
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "WZXY_ID";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('WZXY_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {text: "还款次数", dataIndex: "HK_CODE", type: "string"},
        {
            text: "还款区间",
            dataIndex: "HKQJ",
            type: "string",
            columns: [
                {
                    dataIndex: "START_DATE",
                    type: "string",
                    text: "起始时间",
                    width: 210,
                }, {
                    dataIndex: "END_DATE",
                    type: "string",
                    text: "终止时间",
                    width: 210,
                },
            ]
        }

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'win_xy_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: "/wzgl_nx/hkgl/getSjjk.action",
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
                width: 400,
                labelWidth: 100,
                labelAlign: 'right',
                emptyText: '请输入外债编码 / 项目名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            var grid = DSYGrid.getGrid('win_xy_grid');
                            var store = grid.getStore();
                            var mhcx = Ext.ComponentQuery.query('textfield#mhcx_xy')[0].getValue();
                            store.getProxy().extraParams = {
                                mhcx: mhcx
                            };
                            //刷新
                            store.loadPage(1);
                        }
                    }
                }
            }
        ],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
    });
    return grid;
}

/**
 * 初始化实际还款录入弹出窗口
 */
function initWin_sjjk_edit(config) {
    return Ext.create('Ext.window.Window', {
        title: '实际还款录入',
        itemId: 'win_sjjk_lr',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 添加
        // frame: true,
        // constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'vbox',
        defaults: {
            width: '100%'
        },
        closeAction: 'destroy',
        items: [
            initWin_sjjk_edit_form(config),
            initWin_sjjk_edit_grid(config),
        ],
        buttons: [
            {
                text: '保存',
                name: 'btn_confirm',
                handler: function (self) {
                    saveSjjkInfo(config, self);
                }
            },
            {
                text: '关闭',
                name: 'btn_delete',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

/**
 * 初始化实际还款录入中表单
 */
function initWin_sjjk_edit_form(config) {
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'sjjkdjForm',
        width: '100%',
        layout: 'column',
        fileUpload: true,
        defaultType: 'textfield',
        defaults: {
            margin: '2 5 2 5',
            columnWidth: .33,
            labelWidth: 100,
            editable: false,
            readOnly: true,
            fieldCls: 'form-unedit'
        },
        border: false,
        items: [
            {fieldLabel: '虚拟主单ID', name: "HKD_ID", hidden: true},
            {fieldLabel: '外债协议ID', name: "WZXY_ID", hidden: true},
            {fieldLabel: '付款通知ID', name: "FKTZ_ID", hidden: true},
            {fieldLabel: '还款次数', name: "HK_CODE", xtype: "numberFieldFormat", fieldCls: 'form-unedit-number', hideTrigger: true},
            {fieldLabel: '项目名称', name: "WZXY_NAME",},
            {fieldLabel: '外债编码', name: "WZXY_CODE",},
            {fieldLabel: '贷款利率（%）', name: "LX_RATE",},
            {fieldLabel: '转贷费率（%）', name: "ZD_RATE",},
            {fieldLabel: '担保费率（%）', name: "DB_RATE",},
            {
                xtype: 'fieldcontainer',
                fieldLabel: '还款区间',
                layout: 'hbox',
                columnWidth: .77,
                items: [
                    {xtype: 'textfield', name: 'START_DATE', flex: 1, editable: false, fieldCls: 'form-unedit',},
                    {xtype: 'label', text: '至', margin: '3 2 3 2', width: 20},
                    {xtype: 'textfield', name: 'END_DATE', flex: 1, editable: false, fieldCls: 'form-unedit'}
                ]
            },
            {fieldLabel: '原币/美元汇率', name: "HL_RATE",},
            {fieldLabel: '人民币/美元汇率', name: "YBMYHL_RATE",},
            {fieldLabel: '原币/人民币汇率', name: "RMBMYHL_RATE"},
        ]
    });
    if (!!config.sjjkForm) {
        var sjjkForm = config.sjjkForm;
        form.getForm().setValues(sjjkForm);
    }
    return form;
}

/**
 * 初始化实际还款录入中表格
 */
function initWin_sjjk_edit_grid(config) {
    var tbar = [
        {
            xtype: 'button',
            text: '增行',
            name: 'INPUT',
            icon: '/image/sysbutton/add.png',
            width: 70,
            handler: function (btn) {
                var form = btn.up('window').down('form');
                var formData = form.getForm().getFieldValues();
                var data = {
                    HKD_ID: formData.HKD_ID,
                    WZXY_ID: formData.WZXY_ID,
                    FKTZ_ID: formData.FKTZ_ID,
                };
                var grid = DSYGrid.getGrid('sjjkdjGrid');
                var record = grid.getCurrentRecord();
                var index = null;
                if (!!record) {
                    index = record.recordIndex;
                }
                grid.insertData(index, data);
            }
        },
        {
            xtype: 'button',
            text: '删行',
            name: 'DELETE',
            icon: '/image/sysbutton/delete.png',
            width: 70,
            handler: function () {
                var grid = DSYGrid.getGrid('sjjkdjGrid');
                var store = grid.getStore();
                var sm = grid.getSelectionModel();
                var records = sm.getSelection();
                //获取删除数据记录的ID
                if (!grid.delete_records) {
                    grid.delete_records = [];
                }
                for (var i = 0; i < records.length; i++) {
                    var id = records[i].get('HK_ID');
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
        '->',
    ];
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "主键ID", dataIndex: "HK_ID", type: "string", hidden: true},
        {text: "虚拟缴款单ID", dataIndex: "HKD_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "还款主单ID", dataIndex: "FKTZ_ID", type: "string", hidden: true},
        {text: "还款明细ID", dataIndex: "FKTZ_DTL_ID", type: "string", hidden: true},
        {
            text: "项目区", dataIndex: "AG_NAME", type: "string", cellWrap: true, width: 300,
            editor: {
                xtype: "gridcombobox",
                valueField: 'FKTZ_DTL_ID',
                displayField: 'AG_NAME',
                editable: false, //禁用编辑
                columns: [
                    {text: "还款通知明细ID", dataIndex: "FKTZ_DTL_ID", type: "string", hidden: true},
                    {text: "项目区", dataIndex: "AG_NAME", type: "string", width: 200},
                    {
                        header: '本期应还本金', columns: [
                            {
                                dataIndex: "PAY_BJ_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                                dataIndex: "PAY_BJ_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
                                dataIndex: "PAY_LX_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                                dataIndex: "PAY_LX_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
                                dataIndex: "PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                                dataIndex: "PAY_CNF_RMB",
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
                        header: '本期应还转贷费', columns: [
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
                                dataIndex: "ZDF_RMB_AMT",
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
                        header: '本期应还担保费', columns: [
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
                                dataIndex: "DBF_RMB_AMT",
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

                ],
                store: store_sjjk
            }
        },
        {
            header: '本期应还本金', columns: [
                {
                    dataIndex: "PAY_BJ_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_BJ_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_LX_AMT", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_LX_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_CNF", type: "float", text: "本位币(万元)", width: 180, summaryType: 'sum',
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
                    dataIndex: "PAY_CNF_RMB", type: "float", text: "人民币(万元)", width: 180, summaryType: 'sum',
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
            header: '本期应还担保费', columns: [
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
            text: "还款日期", dataIndex: "HK_DATE", type: "string", width: 180,
            editor: {xtype: 'datefield', format: 'Y-m-d', value: today, editable: false},
            renderer: Ext.util.Format.dateRenderer('Y-m-d')
        },
        {
            header: '本期已还本金', columns: [
                {
                    dataIndex: "YH_BJ_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_BJ_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_BJ_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期已还利息', columns: [
                {
                    dataIndex: "YH_LX_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_LX_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_LX_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期已还承诺费', columns: [
                {
                    dataIndex: "YH_CNF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_CNF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_CNF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期已还转贷费', columns: [
                {
                    dataIndex: "YH_ZDF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_ZDF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
        {
            header: '本期已还担保费', columns: [
                {
                    dataIndex: "YH_DBF_YB_AMT",
                    type: "float",
                    text: "本位币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_DBF_MY_AMT",
                    type: "float",
                    text: "美元(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "YH_DBF_RMB_AMT",
                    type: "float",
                    text: "人民币(万元)",
                    width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        hideTrigger: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return !value ? '' : Ext.util.Format.number(value, '0,000.######');
                    }
                }]
        },
    ];
    var grid = DSYGrid.createGrid({

        itemId: 'sjjkdjGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: false,
        border: false,
        height: '50%',
        defaults: {
            margin: '4 0 0 0',
        },
        tbar: tbar,
        listeners: {
            'edit': function (editor, context) {
                //日期
                if (context.field === 'HK_DATE' && !isNull(context.value)) {
                    context.record.set("HK_DATE", dsyDateFormat(context.value));
                }
                //选择项目区
                if (context.field === 'AG_NAME' && !isNull(context.value)) {
                    var record = store_sjjk.findRecord('FKTZ_DTL_ID', context.value, 0, false, true, true);
                    context.record.set("FKTZ_DTL_ID", record.get('FKTZ_DTL_ID'));
                    context.record.set("AG_NAME", record.get('AG_NAME'));

                    context.record.set("PAY_BJ_AMT", record.get('PAY_BJ_AMT'));
                    context.record.set("BJ_MY_AMT", record.get('BJ_MY_AMT'));
                    context.record.set("PAY_BJ_RMB", record.get('PAY_BJ_RMB'));

                    context.record.set("PAY_LX_AMT", record.get('PAY_LX_AMT'));
                    context.record.set("LX_MY_AMT", record.get('LX_MY_AMT'));
                    context.record.set("PAY_LX_RMB", record.get('PAY_LX_RMB'));

                    context.record.set("PAY_CNF", record.get('PAY_CNF'));
                    context.record.set("CNF_MY_AMT", record.get('CNF_MY_AMT'));
                    context.record.set("PAY_CNF_RMB", record.get('PAY_CNF_RMB'));

                    context.record.set("ZDF_YB_AMT", record.get('ZDF_YB_AMT'));
                    context.record.set("ZDF_MY_AMT", record.get('ZDF_MY_AMT'));
                    context.record.set("ZDF_RMB_AMT", record.get('ZDF_RMB_AMT'));

                    context.record.set("DBF_YB_AMT", record.get('DBF_YB_AMT'));
                    context.record.set("DBF_MY_AMT", record.get('DBF_MY_AMT'));
                    context.record.set("DBF_RMB_AMT", record.get('DBF_RMB_AMT'));
                }
            },
        },
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],
        //单元格编辑插件的事件
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1
            }],
        data: !!config.sjjkList ? config.sjjkList : [],
    });
    return grid;
}

/**
 * 保存事件
 */
function saveSjjkInfo(config, self) {
    var form = Ext.ComponentQuery.query('form#sjjkdjForm');
    if (!form || form.length <= 0) {
        Ext.MessageBox.alert('提示', '保存失败！无法获取主单数据');
        return false;
    }
    form = form[0];
    var formData = form.getForm().getFieldValues();
    formData = $.extend({}, formData, form.getValues());

    var grid = DSYGrid.getGrid('sjjkdjGrid');
    var sjjk_store = grid.getStore();

    var message = '';
    //校验数据
    for (var i = 0; i < sjjk_store.getCount(); i++) {
        var record = sjjk_store.getAt(i);
        if (isNull(record.get('AG_NAME'))) {
            message += '第' + (i + 1) + '行,项目区不能为空！\n';
        }
        if (isNull(record.get('HK_DATE'))) {
            message += '第' + (i + 1) + '行,还款日期不能为空！\n';
        }
    }
    if (!isNull(message)) {
        Ext.MessageBox.alert('提示', '保存失败！' + message);
        return false;
    }

    var records_add = [];
    var records_update = [];
    for (var i = 0; i < sjjk_store.getCount(); i++) {
        var record = sjjk_store.getAt(i);
        if (isNull(record.get('HK_ID'))) {
            records_add.push(record.data);
        } else {
            records_update.push(record.data);
        }
    }

    var url = '/wzgl_nx/hkgl/editSjjkInfo.action';
    self.setDisabled(true);
    $.post(url, {
        form_data: JSON.stringify(formData),
        list_add: JSON.stringify(records_add),
        list_update: JSON.stringify(records_update),
        list_del: grid.delete_records
    }, function (data) {
        if (data.success) {
            self.setDisabled(false);
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            self.up('window').close();
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            self.setDisabled(false);
        }
    }, 'JSON');
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



