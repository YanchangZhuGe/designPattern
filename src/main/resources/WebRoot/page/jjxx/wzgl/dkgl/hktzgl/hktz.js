Ext.define('endDateModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'name', mapping: 'HKJH_DATE'}
    ]
});

/**
 * 获取各协议还款计划日期集合
 */
function getEndDateStore(filterParam) {
    var EndDateStore = Ext.create('Ext.data.Store', {
        model: 'endDateModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getEndDate.action",
            reader: {
                type: 'json'
            },
            extraParams: filterParam
        },
        autoLoad: true
    });
    return EndDateStore;
}


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
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        height: '100%',
        renderTo: 'contentPanel',
        border: false,
        tbar:  [
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
                    button_name = btn.name;
                    button_text = btn.text;
                    window_select.show();
                }
            },
            {
                xtype: 'button',
                text: '还本预测',
                name: 'forecast',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    window_select_yc.show();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    flag = false;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    }
                    modify(records, btn);
                }
            },
            {
                xtype: 'button',
                name: 'btn_del',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm === 'yes') {
                            doworkupdate(records, btn);
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时导出多条记录！');
                        return;
                    }else{
                        var FKTZ_IDS = records[0].get("FKTZ_ID");
                        DSYGrid.exportExcelClick('contentGrid_detail', {
                            exportExcel: true,
                            url: 'getFktzDetailGrid_excel.action',
                            param: {
                                FKTZ_IDS: FKTZ_IDS
                            }
                        });
                    }
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
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "WZXY_ID",
            type: "string",
            width: 100,
            text: "主单id",
            hidden: true
        },
        {
            dataIndex: "WZXY_CODE",
            type: "string",
            width: 130,
            text: "外债编码"
        },
        {
            dataIndex: "WZXY_NAME",
            type: "string",
            width: 300,
            text: "外债名称"
        },
        {
            dataIndex: "WZXY_AMT",
            width: 150,
            type: "float",
            text: "协议金额（原币）",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "DXM_NAME",
            width: 300,
            type: "string",
            text: "大项目"
        },
        {
            dataIndex: "START_DATE",
            width: 100,
            type: "string",
            text: "期间开始日期"
        },
        {
            dataIndex: "END_DATE",
            width: 100,
            type: "string",
            text: "期间结束日期"
        },
        {
            dataIndex: "PAY_BJ_AMT",
            width: 200,
            type: "float",
            text: "支付金额(本金)(原币)",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_BJ_RMB",
            width: 200,
            type: "float",
            text: "支付金额(本金)(人民币)",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_LX_AMT",
            width: 200,
            type: "float",
            text: "支付金额(利息)(原币)",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_LX_RMB",
            width: 200,
            type: "float",
            text: "支付金额(利息)(人民币)",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_CNF",
            width: 200,
            type: "float",
            text: "承诺费(原币)",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_CNF_RMB",
            width: 200,
            type: "float",
            text: "承诺费(人民币)",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "FKTZ_HL_RATE",
            type: "float",
            text: "汇率",
            width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        dataUrl: 'getFktzMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '100%',
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "XM_SEARCH",
                width: 300,
                labelWidth: 80,
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            reloadGrid();
                        }
                    }
                }
            },
            {
                xtype: 'fieldcontainer',
                fieldLabel: '付款日期',
                layout: 'hbox',
                labelWidth: 78,
                items: [
                    {
                        xtype: 'datefield',
                        name: 'START_DATE',
                        width: 110,
                        editable: false,
                        allowBlank: false,
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var END_DATE = self.up('grid').down("datefield[name='END_DATE']").getValue();
                                if (END_DATE == null || END_DATE == "" || newValue == null || newValue == "") {
                                    return;
                                }
                                END_DATE = format(END_DATE, 'yyyy-MM-dd');
                                newValue = format(newValue, 'yyyy-MM-dd');
                                if (newValue > END_DATE) {
                                    Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                    self.up('grid').down("datefield[name='START_DATE']").setValue("");
                                    return;
                                }
                            }
                        }
                    },
                    {
                        xtype: 'label',
                        text: '至',
                        margin: '3 6 3 6'
                    },
                    {
                        xtype: 'datefield',
                        name: 'END_DATE',
                        width: 110,
                        editable: false,
                        allowBlank: false,
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var START_DATE = self.up('grid').down("datefield[name='START_DATE']").getValue();
                                if (START_DATE == null || START_DATE == "" || newValue == null || newValue == "") {
                                    return;
                                }
                                START_DATE = format(START_DATE, 'yyyy-MM-dd');
                                newValue = format(newValue, 'yyyy-MM-dd');
                                if (newValue < START_DATE) {
                                    Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                    self.up('grid').down("datefield[name='END_DATE']").setValue("");
                                    return;
                                }
                            }
                        }
                    }
                ]
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
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化主界面明细表格
 */
function initContentDetilGrid(callback) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "FKTZ_DTL_ID",
            type: "string",
            width: 100,
            text: "明细id",
            hidden: true
        },
        {
            dataIndex: "XM_ID",
            type: "string",
            width: 100,
            text: "项目id",
            hidden: true
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            width: 300,
            text: "项目",
            renderer: function (data, cell, record) {
                if (record.get('XM_ID') != null && record.get('XM_ID') != '') {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = "IS_RZXM";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {
            dataIndex: "ZWDW",
            type: "string",
            width: 200,
            text: "债务单位"
        },
        {
            dataIndex: "JSDW",
            type: "string",
            text: "建设单位",
            width: 200,
            editable: true
        },
        {
            dataIndex: "HKDW",
            type: "string",
            text: "还款单位",
            editable: true,
            width: 200
        },
        {
            dataIndex: "WZXY_AMT",
            type: "float",
            text: "转贷金额（原币）",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "ZWYE_AMT",
            type: "float",
            text: "截止到期日债务余额",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            header: '支付本金', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_BJ_AMT",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_BJ_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            header: '支付利息', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_LX_AMT",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_LX_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            header: '支付承诺费', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_CNF",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_CNF_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            dataIndex: "PAY_ORI_SUM",
            type: "float",
            text: "原币合计",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_RMB_SUM",
            type: "float",
            text: "折合人民币",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var simplyGrid = new DSYGridV2();
    var config = {
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
        dataUrl: 'getFktzDetailGrid.action'
    };
    var grid = simplyGrid.create(config);
    if (callback) {
        callback(grid);
    }
    return grid;
}

/**
 * 创建外债信息选择弹出窗口
 */
var window_select = {
    window: null,
    show: function (params) {
        this.window = fktz_type == 'sj' ? initWindow_select(params) : initQxWindow_select(params);
        this.window.show();
    }
};
/**
 * 创建外债信息弹出窗口
 */
var window_select_yc = {
    window: null,
    show: function () {
        this.window = initWindow_select_yc();
        this.window.show();
    }
};

/**
 *
 * 初始化外债选择弹出窗口
 */
function initWindow_select_yc() {
    return Ext.create('Ext.window.Window', {
        border: false,
        title: '外债还款通知预测', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_yc', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        // items: [initWindow_select_grid_yc()],
        items: {
            xtype: 'tabpanel',
            items: [
                {
                    title: '协议信息',
                    scrollable: true,
                    layout: 'fit',
                    opstatus: 0,
                    items: [initEditor_cq_xyxx_yc()]
                },
                {
                    title: '还款预测',
                    scrollable: true,
                    layout: 'fit',
                    opstatus: 1,
                    items: [initEditor_cq_yc()]
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                    if (newCard.opstatus == 0) {
                        Ext.getCmp('createBtn').setHidden(true);
                        Ext.getCmp('DCBtn').setHidden(true);
                    }else if (newCard.opstatus == 1) {
                        Ext.getCmp('createBtn').setHidden(false);
                        Ext.getCmp('DCBtn').setHidden(false);
                    }
                }
            }
        },
        buttons: [
            {
                text: '生成',
                hidden:true,
                id: 'createBtn',
                name:'createBtn',
                handler: function (self) {
                    // 获取协议数据
                    var grid_store = DSYGrid.getGrid('grid_select2_yc').getSelection();
                    if (grid_store.length ==0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条协议信息！');
                        return;
                    }
                    var store_data=new Array();
                    for(var i=0;i<grid_store.length;i++){
                        store_data.push(grid_store[i].data);
                    }
                    var store = DSYGrid.getGrid('fktz_grid2_cq_yc').getStore();
                    store.getProxy().extraParams = {
                        XYXX_DATA:Ext.util.JSON.encode(store_data)
                    };
                    store.loadPage(1);
                }
            },
            {
                text: '导出',
                hidden:true,
                id: 'DCBtn',
                name:'DCBtn',
                handler: function (btn) {
                    //获取协议数据
                    var hbycGrid=Ext.ComponentQuery.query('grid[itemId="fktz_grid2_cq_yc"]')[0];
                    var store_data=new Array();
                    var grid_store=hbycGrid.getStore();
                    for(var i=0;i<grid_store.getCount();i++){
                        var record=grid_store.getAt(i);
                        var data  =record.data;
                        store_data.push(data);
                    }
                    if(store_data.length<1){
                        Ext.MessageBox.alert('提示', '请先生成付款预测信息！');
                        return;
                    }
                    DSYGrid.exportExcelClick('fktz_grid2_cq_yc', {
                        exportExcel: true,
                        url: 'getFktzDataYcDc.action',
                        param: {
                            FKTZ_MX: Ext.util.JSON.encode(store_data)
                        }
                    });
                }
            },
            {
                text: '关闭',
                hidden:false,
                id: 'closeBtn',
                name:'closeBtn',
                handler: function (btn) {
                    btn.up('window').destroy();
                }
            }
        ]
    });
}
/**
 * 初始化外债选择弹出框表格
 */
function initWindow_select_grid_yc(params) {
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {
            "dataIndex": "FKTZ_DTL_ID",
            "type": "string",
            "text": "付款通知明细id",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "WZXY_ID",
            "type": "string",
            "text": "外债协议id",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "SJXM_ID",
            "type": "string",
            "text": "上级项目id",
            "fontSize": "15px",
            "width": 120,
            hidden: true
        },
        {
            "dataIndex": "AD_NAME",
            "type": "string",
            "text": "地区名称",
            "fontSize": "15px",
            "width": 120
        },
        {
            "dataIndex": "WZXY_NAME",
            "type": "string",
            "text": "外债名称",
            "fontSize": "15px",
            "width": 300
        },

        {
            "dataIndex": "DXM_NAME",
            "type": "string",
            "text": "项目名称",
            "fontSize": "15px",
            "width": 300
        },
        // {
        //     text: '债务类型',
        //     dataIndex: 'XMFL',
        //     type: "string",
        //     renderer: function (value) {
        //         var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
        //         return result != null ? result.get('name') : value;
        //     }
        // },

        {
            "dataIndex": "WZXY_AMT",
            "type": "float",
            "text": "协议金额（原币）",
            "fontSize": "15px",
            "width": 150,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "ZF_BJ",
            "type": "float",
            "text": "支付本金（原币）",
            "fontSize": "15px",
            tdCls: 'grid-cell',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            "width": 150,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "ZF_LX",
            "type": "float",
            "text": "支付利息（原币）",
            "fontSize": "15px",
            tdCls: 'grid-cell',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            "width": 150,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "ZF_CNF",
            "type": "float",
            "text": "承诺费（原币）",
            "fontSize": "15px",
            tdCls: 'grid-cell',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            "width": 150,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        // {
        //     "dataIndex": "WZXY_AMT_RMB",
        //     "type": "float",
        //     "text": "协议金额（人民币）",
        //     "fontSize": "15px",
        //     "width": 180,
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     }
        // },

        {
            "dataIndex": "WB_NAME",
            "type": "string",
            "text": "币种",
            "fontSize": "15px",
            "width": 130
        },
        {
            "dataIndex": "HL_RATE",
            "width": 130,
            "type": "string",
            "text": "汇率"
        },
        {
            "dataIndex": "ZQFL_NAME",
            "width": 130,
            "type": "string",
            "text": "债权类型"
        },
        // {
        //     "dataIndex": "ZWLX_NAME",
        //     "width": 130,
        //     "type": "string",
        //     "text": "债务类型"
        // },
        {
            "dataIndex": "ZQR_NAME",
            "width": 130,
            "type": "string",
            "text": "债权人"
        },
        {
            "dataIndex": "ZQR_FULLNAME",
            "width": 130,
            "type": "string",
            "text": "债权人全称"
        },
        {
            "dataIndex": "ZJYT_NAME",
            "type": "string",
            "width": 150,
            "text": "资金用途"
        },
        {
            "dataIndex": "WZQX_ID",
            "width": 130,
            "type": "string",
            "text": "期限（月）"
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'grid_select2_yc',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        // selModel: {
        //     mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        // },
        checkBox: true,
        border: false,
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'wzzd_grid_plugin_cell2',
                clicksToMoveEditor: 1
            }
        ],
        params: {
            fktz_type: fktz_type,
            mhcx: null
        },
        tbar: [
            {
                xtype: "textfield",
                name: "mhcx",
                id: "mhcx",
                fieldLabel: '模糊查询',
                allowBlank: true,  // requires a non-empty value
                labelWidth: 70,
                width: 260,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['mhcx'] = self.getValue();
                            // 刷新表格
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                    btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                    btn.up('grid').getStore().loadPage(1);
                }
            }
        ],
        tbarHeight: 50,
        dataUrl: 'getWzInfo.action'
    });
}

/**
 * 初始化外债选择弹出窗口
 */
function initWindow_select(params) {
    return Ext.create('Ext.window.Window', {
        title: '外债选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_select_grid(params)],
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
                    window_input.wz_code = "";
                    var record = records[0].getData();

                    // 检查项目是否存在支付类别为（土建和设备）的未确认的提款
                    $.post('checkNoConfirmInfo_Cq.action', {
                        WZXY_ID:record.WZXY_ID
                    }, function (data) {
                        if (data.success) {
                            //如果查询有为确认的提款，提醒
                            Ext.Msg.confirm('提示', record.WZXY_NAME+'协议中存在未确认的提款信息,请确认是否继续！', function (btn_confirm) {
                                if (btn_confirm == 'yes') {
                                    var url = '/page/debt/wzgl/dkgl/xmtkgl/xmtkqr_Cq.jsp';
                                    window.open(url);
                                    btn.up('window').close();
                                }
                            });

                        }else{
                            EndDateStore = getEndDateStore({"WZXY_ID": record.WZXY_ID});
                            window_input.show();
                            window_input.window.down('form').getForm().setValues(record);
                            btn.up('window').close();

                        }

                    }, 'JSON');
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
 * 初始化外债选择弹出框表格
 */
function initWindow_select_grid(params) {
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {
            "dataIndex": "FKTZ_DTL_ID",
            "type": "string",
            "text": "付款通知明细id",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "WZXY_ID",
            "type": "string",
            "text": "外债协议id",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "SJXM_ID",
            "type": "string",
            "text": "上级项目id",
            "fontSize": "15px",
            "width": 120,
            hidden: true
        },
        {
            "dataIndex": "AD_NAME",
            "type": "string",
            "text": "地区名称",
            "fontSize": "15px",
            "width": 120
        },
        {
            "dataIndex": "WZXY_NAME",
            "type": "string",
            "text": "外债名称",
            "fontSize": "15px",
            "width": 300
        },

        {
            "dataIndex": "DXM_NAME",
            "type": "string",
            "text": "大项目",
            "fontSize": "15px",
            "width": 300
        },
        // {
        //     text: '债务类型',
        //     dataIndex: 'XMFL',
        //     type: "string",
        //     renderer: function (value) {
        //         var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
        //         return result != null ? result.get('name') : value;
        //     }
        // },
        {
            "dataIndex": "WZXY_AMT",
            "type": "float",
            "text": "协议金额（原币）",
            "fontSize": "15px",
            "width": 150,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "WZXY_AMT_RMB",
            "type": "float",
            "text": "协议金额（人民币）",
            "fontSize": "15px",
            "width": 180,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "ZJYT_NAME",
            "type": "string",
            "width": 100,
            "text": "资金用途"
        },
        {
            "dataIndex": "WZQX_ID",
            "width": 100,
            "type": "string",
            "text": "期限（月）"
        },
        {
            "dataIndex": "HL_RATE",
            "width": 100,
            "type": "string",
            "text": "汇率"
        },
        {
            "dataIndex": "ZQFL_NAME",
            "width": 100,
            "type": "string",
            "text": "债权类型"
        },
        // {
        //     "dataIndex": "ZWLX_NAME",
        //     "width": 130,
        //     "type": "string",
        //     "text": "债务类型"
        // },
        {
            "dataIndex": "ZQR_NAME",
            "width": 150,
            "type": "string",
            "text": "债权人"
        },
        {
            "dataIndex": "ZQR_FULLNAME",
            "width": 150,
            "type": "string",
            "text": "债权人全称"
        },
        {
            "dataIndex": "WB_NAME",
            "type": "string",
            "text": "币种",
            "fontSize": "15px",
            "width": 100
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'grid_select2',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        params: {
            fktz_type: fktz_type,
            mhcx: null
        },
        tbar: [
            {
                xtype: "textfield",
                name: "mhcx",
                id: "mhcx",
                fieldLabel: '模糊查询',
                allowBlank: true,  // requires a non-empty value
                labelWidth: 70,
                width: 260,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['mhcx'] = self.getValue();
                            // 刷新表格
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                    btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                    btn.up('grid').getStore().loadPage(1);
                }
            }
        ],
        tbarHeight: 50,
        dataUrl: 'getWzInfo.action'
    });
}

/**
 * 初始化外债选择弹出窗口
 */
function initQxWindow_select(params) {
    return Ext.create('Ext.window.Window', {
        title: '付款明细选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'windowQx_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initQxWindow_select_grid(params)],
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
                    window_input.wz_code = "";
                    var record = records[0].getData();
                    window_input.show();
                    window_input.window.down('form').getForm().setValues(record);
                    btn.up('window').close();
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
 * 初始化外债选择弹出框表格
 */
function initQxWindow_select_grid(params) {
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {
            "dataIndex": "FKTZ_DTL_ID",
            "type": "string",
            "text": "付款通知明细id",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "WZXY_ID",
            "type": "string",
            "text": "外债协议id",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "SJXM_ID",
            "type": "string",
            "text": "上级项目id",
            "fontSize": "15px",
            "width": 120,
            hidden: true
        },
        {
            "dataIndex": "WZXY_NAME",
            "type": "string",
            "text": "外债名称",
            "fontSize": "15px",
            "width": 300
        },
        {
            dataIndex: "DXM_NAME",
            type: "string",
            width: 300,
            text: "子项目名称"
        },
        // {
        //     text: '债务类型',
        //     dataIndex: 'XMFL',
        //     type: "string",
        //     renderer: function (value) {
        //         var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
        //         return result != null ? result.get('name') : value;
        //     }
        // },
        {
            dataIndex: "AD_NAME",
            type: "string",
            width: 200,
            text: "债务单位"
        },
        {
            dataIndex: "ZXDW_NAME",
            type: "string",
            width: 200,
            text: "项目执行单位"
        },
        {
            dataIndex: "START_DATE",
            type: "string",
            width: 100,
            text: "开始日期"
        },
        {
            dataIndex: "END_DATE",
            type: "string",
            width: 100,
            text: "结束日期"
        },
        {
            dataIndex: "WZXY_AMT",
            type: "float",
            text: "协议金额（原币）",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "ZWYE_AMT",
            type: "float",
            text: "截止到期日债务余额",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            header: '支付本金', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_BJ_AMT",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_BJ_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            header: '支付利息', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_LX_AMT",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_LX_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            dataIndex: "PAY_CNF",
            type: "float",
            text: "承诺费",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_ORI_SUM",
            type: "float",
            text: "原币合计",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_RMB_SUM",
            type: "float",
            text: "折合人民币",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "FKTZ_HL_RATE",
            type: "float",
            text: "汇率",
            width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'grid_select2',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        params: {
            fktz_type: fktz_type,
            mhcx: null
        },
        tbar: [
            {
                xtype: "textfield",
                name: "mhcx",
                id: "mhcx",
                fieldLabel: '模糊查询',
                allowBlank: true,  // requires a non-empty value
                labelWidth: 70,
                width: 260,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['mhcx'] = self.getValue();
                            // 刷新表格
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                    btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                    btn.up('grid').getStore().loadPage(1);
                }
            }
        ],
        tbarHeight: 50,
        dataUrl: 'getWzInfo.action'
    });
}
//创建付款信息填报弹出窗口
var window_input_cq_yc = {
    window: null,
    wz_code: null,
    show: function () {
        this.window = initWindow_input_cq_yc();
        this.window.show();
    }
};
//创建付款信息填报弹出窗口
var window_input = {
    window: null,
    wz_code: null,
    show: function () {
        this.window = initWindow_input();
        this.window.show();
    }
};
/**
 * 初始化付款弹出窗口
 */
function initWindow_input() {
    return Ext.create('Ext.window.Window', {
        title: '付款通知单', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input2', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initEditor(),
        buttons: [
            {
                xtype: 'button',
                text: '生成',
                width: 60,
                handler: function (self) {
                    var form = self.up('window').down('form');
                    if (form.isValid()) {
                        var formData = form.getForm().getValues();
//                            if(formData.SQBF_AMT<=0){
//                                Ext.MessageBox.alert('提示', '请输入申请提款金额！');
//                                return;
//                            }
                        flag = true;
                        DSYGrid.getGrid('fktz_grid2').getStore().removeAll();
                        DSYGrid.getGrid('fktz_grid2').getStore().getProxy().extraParams['fktzParam'] = Ext.util.JSON.encode(formData);
                        DSYGrid.getGrid('fktz_grid2').getStore().loadPage(1);

                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    var form = btn.up('window').down('form');
                    if (!form.isValid()) {
                        return;
                    }
                    var form_data = form.getValues();
                    //获取grid
                    var gridStore = Ext.ComponentQuery.query('grid[itemId="fktz_grid2"]')[0];
                    var store_data = new Array();
                    var grid_store = gridStore.getStore();
                    for (var i = 0; i < grid_store.getCount(); i++) {
                        var record = grid_store.getAt(i);
                        var var$PAY_BJ_AMT = record.get("PAY_BJ_AMT");
                        var var$ZWYE_AMT = record.get("ZWYE_AMT");
                        if (var$ZWYE_AMT < var$PAY_BJ_AMT) {
                            Ext.toast({
                                html: "支付本金高于债务余额，请核实信息！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        var data = record.data;
                        store_data.push(data);
                    }
                    if (store_data.length < 1) {
                        Ext.MessageBox.alert('提示', '请生成付款通知明细！');
                        return;
                    }
                    var sum$PAY_BJ_AMT = grid_store.sum("PAY_BJ_AMT");
                    var sum$PAY_BJ_RMB = grid_store.sum("PAY_BJ_RMB");
                    var sum$PAY_LX_AMT = grid_store.sum("PAY_LX_AMT");
                    var sum$PAY_LX_RMB = grid_store.sum("PAY_LX_RMB");
                    var sum$PAY_CNF = grid_store.sum("PAY_CNF");
                    var sum$PAY_CNF_RMB = grid_store.sum("PAY_CNF_RMB");
                    var PAY_BJ_AMT_SUM = form_data.PAY_BJ_AMT;
                    var PAY_LX_AMT_SUM = form_data.PAY_LX_AMT;
                    var PAY_BJ_RMB_SUM = form_data.PAY_BJ_RMB;
                    var PAY_LX_RMB_SUM = form_data.PAY_LX_RMB;
                    var PAY_CNF_SUM = form_data.PAY_CNF;
                    var PAY_CNF_RMB_SUM = form_data.PAY_CNF_RMB;
                    if (Math.abs((PAY_BJ_AMT_SUM - sum$PAY_BJ_AMT)) > 0.01) {
                        Ext.MessageBox.alert('提示', '明细原币支付本金总和不等于总原币支付本金！');
                        return;
                    }
                    if (Math.abs((PAY_LX_AMT_SUM - sum$PAY_LX_AMT)) > 0.01) {
                        Ext.MessageBox.alert('提示', '明细原币支付利息总和不等于总原币支付利息！');
                        return;
                    }
                    if (Math.abs((PAY_BJ_RMB_SUM - sum$PAY_BJ_RMB)) > 0.01) {
                        Ext.MessageBox.alert('提示', '明细人民币支付本金总和不等于总人民币支付本金！');
                        return;
                    }
                    if (Math.abs((PAY_LX_RMB_SUM - sum$PAY_LX_RMB)) > 0.01) {
                        Ext.MessageBox.alert('提示', '明细人民币支付利息总和不等于总人民币支付利息！');
                        return;
                    }
                    if (Math.abs((PAY_CNF_SUM - sum$PAY_CNF)) > 0.01) {
                        Ext.MessageBox.alert('提示', '明细原币承诺费总和不等于总原币承诺费！');
                        return;
                    }
                    if (Math.abs((PAY_CNF_RMB_SUM - sum$PAY_CNF_RMB)) > 0.01) {
                        Ext.MessageBox.alert('提示', '明细人民币承诺费总和不等于总人民币承诺费！');
                        return;
                    }
                    btn.setDisabled(true);
                    Ext.Ajax.request({
                        method: 'POST',
                        url: "/saveFktz.action",
                        params: {
                            button_name: button_name,
                            button_text: button_text,
                            formList: Ext.util.JSON.encode(form_data),
                            detailList: Ext.util.JSON.encode(store_data)
                        },
                        async: false,
                        success: function (response) {
                            var result = Ext.util.JSON.decode(response.responseText);
                            if (result.success) {
                                Ext.toast({
                                    html: "保存成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.up('window').close();
                                reloadGrid();
                            } else {
                                Ext.toast({
                                    html: "保存失败！" + result.message,
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.setDisabled(false);
                                return false;
                            }
                        }
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

function initEditor() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'fktz_edit_form',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 130//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '外债协议ID',
                        disabled: false,
                        name: "WZXY_ID",
                        editable: false,//禁用编辑
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '上级项目id',
                        disabled: false,
                        name: "SJXM_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '付款通知主单id',
                        disabled: false,
                        name: "FKTZ_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '付款通知明细id',
                        disabled: false,
                        name: "FKTZ_DTL_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债名称',
                        disabled: false,
                        name: "WZXY_NAME",
                        editable: false,
                        readOnly: true,
                        labelWidth: 78,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '大项目',
                        disabled: false,
                        name: "DXM_NAME",
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '协议金额（原币）',
                        name: "WZXY_AMT",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: true,
                        allowBlank: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 130//控件默认标签宽度
                },
                items: [
                    {
                        xtype: 'fieldcontainer',
                        fieldLabel: '付款日期',
                        layout: 'hbox',
                        labelWidth: 78,
                        items: [
                            {
                                xtype: 'datefield',
                                name: 'START_DATE',
                                width: document.body.clientWidth * 0.095,
                                editable: false,
                                allowBlank: false,
                                format: 'Y-m-d',
                                readOnly: fktz_type == 'sj' ? false : true,
                                fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6',
                                listeners: {
                                    'change': function (self, newValue, oldValue) {
                                        if (fktz_type != 'sj') {
                                            return;
                                        }
                                        var form = self.up('form').getForm();
                                        var END_DATE = form.findField('END_DATE').value;
                                        if (END_DATE == null || END_DATE == "" || newValue == null || newValue == "") {
                                            return;
                                        }
                                        newValue = format(newValue, 'yyyy-MM-dd');
                                        if (newValue > END_DATE) {
                                            Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                            form.findField("START_DATE").setValue("");
                                            return;
                                        }
                                    }
                                }
                            },
                            {
                                xtype: 'label',
                                text: '至',
                                margin: '3 6 3 6'
                            },
                            {
                                xtype: 'datefield',
                                name: 'END_DATE',
                                width: document.body.clientWidth * 0.095,
                                editable: false,
                                allowBlank: false,
                                format: 'Y-m-d',
                                readOnly: fktz_type == 'sj' ? false : true,
                                fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6',
                                // xtype: 'combobox',
                                // name: 'END_DATE',
                                // displayField: 'name',
                                // valueField: 'name',
                                // store: EndDateStore,
                                listeners: {
                                    'change': function (self, newValue, oldValue) {
                                        if (fktz_type != 'sj') {
                                            return;
                                        }
                                        var form = self.up('form').getForm();
                                        var START_DATE = form.findField('START_DATE').value;
                                        if (START_DATE == null || START_DATE == "" || newValue == null || newValue == "") {
                                            return;
                                        }
                                        START_DATE = format(START_DATE, 'yyyy-MM-dd');
                                        newValue = format(newValue, 'yyyy-MM-dd');
                                        if (newValue < START_DATE) {
                                            Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                            form.findField("END_DATE").setValue("");
                                            return;
                                        }
                                    }
                                }
                            }
                        ]
                    }, {
                        xtype: "numberFieldFormat",
                        fieldLabel: '支付本金(原币)',
                        name: "PAY_BJ_AMT",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: true,
                        minValue: 0,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if (fktz_type != 'sj') {
                                    return;
                                }
                                var form = self.up('form').getForm();
                                var WZXY_AMT = form.findField('WZXY_AMT').value;
                                if (WZXY_AMT == null || WZXY_AMT == "") {
                                    return;
                                }
                                if (newValue > WZXY_AMT) {
                                    Ext.MessageBox.alert('提示', '支付本金不能大于协议金额！');
                                    form.findField("PAY_BJ_AMT").setValue("");
                                    return;
                                }
                                var PAY_BJ_RMB = form.findField('PAY_BJ_RMB').value;
                                if (newValue != null && newValue != "" && newValue > 0 && PAY_BJ_RMB != null && PAY_BJ_RMB != "" && PAY_BJ_RMB > 0) {
                                    var hl = Math.floor(PAY_BJ_RMB / newValue * 1000000) / 1000000;
                                    form.findField("FKTZ_HL_RATE").setValue(hl);
                                } else {
                                    form.findField("FKTZ_HL_RATE").setValue("");
                                }
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '支付本金(人民币)',
                        name: "PAY_BJ_RMB",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: true,
                        minValue: 0,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if (fktz_type != 'sj') {
                                    return;
                                }
                                var form = self.up('form').getForm();
                                var PAY_BJ_AMT = form.findField('PAY_BJ_AMT').value;
                                if (newValue != null && newValue != "" && newValue > 0 && PAY_BJ_AMT != null && PAY_BJ_AMT != "" && PAY_BJ_AMT > 0) {
                                    var hl = Math.floor(newValue / PAY_BJ_AMT * 1000000) / 1000000;
                                    form.findField("FKTZ_HL_RATE").setValue(hl);
                                } else {
                                    form.findField("FKTZ_HL_RATE").setValue("");
                                }
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '汇率',
                        name: "FKTZ_HL_RATE",
                        decimalPrecision: 7,
                        emptyText: '0.00',
                        regex: /^\d+(\.[0-9]{1,6})?$/,
                        hideTrigger: true,
                        mouseWheelEnabled: false,
                        minValue: 0,
                        labelWidth: 78,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6'
                    },

                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '支付利息(原币)',
                        name: "PAY_LX_AMT",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        minValue: 0,
                        mouseWheelEnabled: true,
                        editable: true,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if (fktz_type != 'sj') {
                                    return;
                                }
                                var form = self.up('form').getForm();
                                var FKTZ_HL_RATE = form.findField('FKTZ_HL_RATE').value;
                                if (newValue != null && newValue != "" && newValue > 0 && FKTZ_HL_RATE != null && FKTZ_HL_RATE != "" && FKTZ_HL_RATE > 0) {
                                    var PAY_LX_RMB = Math.floor(newValue * FKTZ_HL_RATE * 100) / 100;
                                    form.findField("PAY_LX_RMB").setValue(PAY_LX_RMB);
                                } else {
                                    form.findField("PAY_LX_RMB").setValue("");
                                }
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '支付利息(人民币)',
                        name: "PAY_LX_RMB",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: true,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '承诺费(原币)',
                        name: "PAY_CNF",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        minValue: 0,
                        labelWidth: 78,
                        mouseWheelEnabled: true,
                        editable: true,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if (fktz_type != 'sj') {
                                    return;
                                }
                                var form = self.up('form').getForm();
                                var FKTZ_HL_RATE = form.findField('FKTZ_HL_RATE').value;
                                if (newValue != null && newValue != "" && newValue > 0 && FKTZ_HL_RATE != null && FKTZ_HL_RATE != "" && FKTZ_HL_RATE > 0) {
                                    var PAY_CNF_RMB = Math.floor(newValue * FKTZ_HL_RATE * 100) / 100;
                                    form.findField("PAY_CNF_RMB").setValue(PAY_CNF_RMB);
                                } else {
                                    form.findField("PAY_CNF_RMB").setValue("");
                                }
                            }
                        }

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '承诺费(人民币)',
                        name: "PAY_CNF_RMB",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        minValue: 0,
                        mouseWheelEnabled: true,
                        editable: true,
                        allowBlank: false,
                        readOnly: fktz_type == 'sj' ? false : true,
                        fieldStyle: fktz_type == 'sj' ? null : 'background:#E6E6E6'
                    }

                ]
            },
            initWindow_input_contentForm_grid()
        ]
    });
}
function initEditor_cq_xyxx_yc() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'fktz_edit_form_cq_yc',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            initWindow_select_grid_yc()
        ]
    });
}
function initEditor_cq_yc() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'fktz_edit_form_cq_yc',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            initWindow_input_contentForm_grid_cq_yc()
        ]
    });
}
/**
 * 初始化付款通知表单中通知单明细信息表格
 */
function initWindow_input_contentForm_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "WZXY_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "协议id"
        },
        {
            dataIndex: "SJXM_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "上级项目id"
        },
        {
            dataIndex: "XM_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "项目id"
        },
        {
            dataIndex: "AD_CODE",
            type: "string",
            width: 200,
            hidden: true,
            text: "区划编码"
        },
        {
            dataIndex: "AG_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "单位id"
        },
        {
            dataIndex: "AG_CODE",
            type: "string",
            width: 200,
            hidden: true,
            text: "单位code"
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            width: 200,
            hidden: true,
            text: "单位名称"
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            width: 200,
            text: "子项目名称"
        },
        {
            dataIndex: "ZWDW",
            type: "string",
            width: 200,
            text: "债务单位"
        },
        // {
        //     dataIndex: "JSDW",
        //     type: "string",
        //     text: "建设单位",
        //     width: 200,
        //     editable: true
        // },
        // {
        //     dataIndex: "HKDW",
        //     type: "string",
        //     text: "还款单位",
        //     editable: true,
        //     width: 200
        // },
        {
            dataIndex: "WZXY_AMT",
            type: "float",
            text: "转贷金额（原币）",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "ZWYE_AMT",
            type: "float",
            text: "截止到期日债务余额",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },

        {
            header: '支付本金', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_BJ_AMT",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_BJ_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            header: '支付利息', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_LX_AMT",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                editable: false,//禁用编辑
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_LX_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },

        {
            header: '支付承诺费', colspan: 2, align: 'center', columns: [
            {
                dataIndex: "PAY_CNF",
                type: "float",
                text: "支付金额(原币)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_CNF_RMB",
                type: "float",
                text: "支付金额(人民币)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }]
        },
        {
            dataIndex: "PAY_ORI_SUM",
            type: "float",
            text: "原币合计",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_RMB_SUM",
            type: "float",
            text: "折合人民币",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'fktz_grid2',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: false,
        params: {
            fktz_type: fktz_type,
            button_name: button_name
        },
        dataUrl: 'getFktzMx.action',
        border: true,
        flex: 1,
        height: '100%',
        width: '100%',
        viewConfig: {
            stripeRows: false
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'fktz_grid_plugin_cell2',
                clicksToMoveEditor: 1
            }
        ],
        pageConfig: {
            enablePage: false
        },
        listeners: {
            edit: function (editor, context) {
                //支付本金
                if (context.field == 'PAY_BJ_AMT') {
                    var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
                    var formData = form.getValues();
                    var HL_RATE = formData.FKTZ_HL_RATE;
                    if (HL_RATE != null && HL_RATE != undefined && HL_RATE >= 0 && context.value >= 0) {
                        context.record.set("PAY_BJ_RMB", HL_RATE * context.value);
                        var PAY_BJ_RMB = context.record.get("PAY_BJ_RMB");
                        var PAY_LX_AMT = context.record.get("PAY_LX_AMT");
                        var PAY_LX_RMB = context.record.get("PAY_LX_RMB");
                        var PAY_CNF = context.record.get("PAY_CNF");
                        var PAY_CNF_RMB = context.record.get("PAY_CNF_RMB");
                        if (PAY_LX_AMT != null && PAY_LX_AMT != undefined && PAY_LX_AMT >= 0 && PAY_CNF != null && PAY_CNF != undefined && PAY_CNF >= 0) {
                            context.record.set("PAY_ORI_SUM", context.value + PAY_LX_AMT + PAY_CNF);
                        }
                        if (PAY_BJ_RMB != null && PAY_BJ_RMB != undefined && PAY_BJ_RMB >= 0 && PAY_LX_RMB != null && PAY_LX_RMB != undefined && PAY_LX_RMB >= 0 && PAY_CNF_RMB != null && PAY_CNF_RMB != undefined && PAY_CNF_RMB >= 0 ) {
                            context.record.set("PAY_RMB_SUM", PAY_BJ_RMB + PAY_LX_RMB + PAY_CNF_RMB);
                        }
                    }
                }
                if (context.field == 'PAY_BJ_RMB') {
                    if (context.value >= 0) {
                        var PAY_BJ_AMT = context.record.get("PAY_BJ_AMT");
                        var PAY_LX_AMT = context.record.get("PAY_LX_AMT");
                        var PAY_LX_RMB = context.record.get("PAY_LX_RMB");
                        var PAY_CNF = context.record.get("PAY_CNF");
                        var PAY_CNF_RMB = context.record.get("PAY_CNF_RMB");
                        if (PAY_BJ_AMT != null && PAY_BJ_AMT != undefined && PAY_BJ_AMT >= 0 && PAY_LX_AMT != null && PAY_LX_AMT != undefined && PAY_LX_AMT >= 0 && PAY_CNF != null && PAY_CNF != undefined && PAY_CNF >= 0) {
                            context.record.set("PAY_ORI_SUM", PAY_BJ_AMT + PAY_LX_AMT + PAY_CNF);
                        }
                        if (PAY_LX_RMB != null && PAY_LX_RMB != undefined && PAY_LX_RMB >= 0 && PAY_CNF_RMB != null && PAY_CNF_RMB != undefined && PAY_CNF_RMB >= 0) {
                            context.record.set("PAY_RMB_SUM", context.value + PAY_LX_RMB + PAY_CNF_RMB);
                        }
                    }
                }
                //支付利息
                if (context.field == 'PAY_LX_AMT') {
                    var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
                    var formData = form.getValues();
                    var HL_RATE = formData.FKTZ_HL_RATE;
                    if (HL_RATE != null && HL_RATE != undefined && HL_RATE >= 0 && context.value >= 0) {
                        context.record.set("PAY_LX_RMB", HL_RATE * context.value);
                        var PAY_LX_RMB = context.record.get("PAY_LX_RMB");
                        var PAY_BJ_AMT = context.record.get("PAY_BJ_AMT");
                        var PAY_BJ_RMB = context.record.get("PAY_BJ_RMB");
                        var PAY_CNF = context.record.get("PAY_CNF");
                        var PAY_CNF_RMB = context.record.get("PAY_CNF_RMB");
                        if (PAY_BJ_AMT != null && PAY_BJ_AMT != undefined && PAY_BJ_AMT >= 0 && PAY_CNF != null && PAY_CNF != undefined && PAY_CNF >= 0) {
                            context.record.set("PAY_ORI_SUM", context.value + PAY_BJ_AMT+PAY_CNF);
                        }
                        if (PAY_BJ_RMB != null && PAY_BJ_RMB != undefined && PAY_BJ_RMB >= 0 && PAY_LX_RMB != null && PAY_LX_RMB != undefined && PAY_LX_RMB >= 0 && PAY_CNF_RMB != null && PAY_CNF_RMB != undefined && PAY_CNF_RMB >= 0) {
                            context.record.set("PAY_RMB_SUM", PAY_LX_RMB + PAY_BJ_RMB + PAY_CNF_RMB);
                        }
                    }
                }
                if (context.field == 'PAY_LX_RMB') {
                    if (context.value >= 0) {
                        var PAY_LX_AMT = context.record.get("PAY_LX_AMT");
                        var PAY_BJ_AMT = context.record.get("PAY_BJ_AMT");
                        var PAY_BJ_RMB = context.record.get("PAY_BJ_RMB");
                        var PAY_CNF = context.record.get("PAY_CNF");
                        var PAY_CNF_RMB = context.record.get("PAY_CNF_RMB");
                        if (PAY_BJ_AMT != null && PAY_BJ_AMT != undefined && PAY_BJ_AMT >= 0 && PAY_LX_AMT != null && PAY_LX_AMT != undefined && PAY_LX_AMT >= 0 && PAY_CNF != null && PAY_CNF != undefined && PAY_CNF >= 0) {
                            context.record.set("PAY_ORI_SUM", PAY_LX_AMT + PAY_BJ_AMT+PAY_CNF);
                        }
                        if (PAY_BJ_RMB != null && PAY_BJ_RMB != undefined && PAY_BJ_RMB >= 0 && PAY_CNF_RMB != null && PAY_CNF_RMB != undefined && PAY_CNF_RMB >= 0) {
                            context.record.set("PAY_RMB_SUM", context.value + PAY_BJ_RMB +PAY_CNF_RMB);
                        }
                    }
                }
                //承诺费
                if (context.field == 'PAY_CNF') {
                    var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
                    var formData = form.getValues();
                    var HL_RATE = formData.FKTZ_HL_RATE;
                    if (HL_RATE != null && HL_RATE != undefined && HL_RATE >= 0 && context.value >= 0) {
                        context.record.set("PAY_CNF_RMB", HL_RATE * context.value);
                        var PAY_CNF_RMB = context.record.get("PAY_CNF_RMB");
                        var PAY_BJ_AMT = context.record.get("PAY_BJ_AMT");
                        var PAY_BJ_RMB = context.record.get("PAY_BJ_RMB");
                        var PAY_LX_AMT = context.record.get("PAY_LX_AMT");
                        var PAY_LX_RMB = context.record.get("PAY_LX_RMB");
                        if (PAY_BJ_AMT != null && PAY_BJ_AMT != undefined && PAY_BJ_AMT >= 0 && PAY_LX_AMT != null && PAY_LX_AMT != undefined && PAY_LX_AMT >= 0) {
                            context.record.set("PAY_ORI_SUM", context.value + PAY_BJ_AMT + PAY_LX_AMT);
                        }
                        if (PAY_BJ_RMB != null && PAY_BJ_RMB != undefined && PAY_BJ_RMB >= 0 && PAY_LX_RMB != null && PAY_LX_RMB != undefined && PAY_LX_RMB >= 0 && PAY_CNF_RMB != null && PAY_CNF_RMB != undefined && PAY_CNF_RMB >= 0) {
                            context.record.set("PAY_RMB_SUM", PAY_CNF_RMB + PAY_BJ_RMB + PAY_LX_RMB);
                        }
                    }
                }
                if (context.field == 'PAY_CNF_RMB') {
                    if (context.value >= 0) {
                        var PAY_CNF = context.record.get("PAY_CNF");
                        var PAY_BJ_AMT = context.record.get("PAY_BJ_AMT");
                        var PAY_BJ_RMB = context.record.get("PAY_BJ_RMB");
                        var PAY_LX_AMT = context.record.get("PAY_LX_AMT");
                        var PAY_LX_RMB = context.record.get("PAY_LX_RMB");
                        if (PAY_BJ_AMT != null && PAY_BJ_AMT != undefined && PAY_BJ_AMT >= 0 && PAY_LX_AMT != null && PAY_LX_AMT != undefined && PAY_LX_AMT >= 0 && PAY_CNF != null && PAY_CNF != undefined && PAY_CNF >= 0) {
                            context.record.set("PAY_ORI_SUM", PAY_CNF + PAY_BJ_AMT + PAY_LX_AMT);
                        }
                        if (PAY_BJ_RMB != null && PAY_BJ_RMB != undefined && PAY_BJ_RMB >= 0 && PAY_LX_RMB != null && PAY_LX_RMB != undefined && PAY_LX_RMB >= 0) {
                            context.record.set("PAY_RMB_SUM", context.value + PAY_BJ_RMB + PAY_LX_RMB);
                        }
                    }
                }
            }
        }

    });
    grid.getStore().on('load', function () {
        if (!flag) {
            return;
        }
        var self = grid.getStore();
        var WZXY_AMT_SUM = self.sum("WZXY_AMT");
        var WZYE_SUM = self.sum("ZWYE_AMT");
        var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
        var formData = form.getValues();
        var endDate = Ext.util.Format.date(formData.END_DATE, 'Y-m-d');
        var PAY_BJ_AMT_SUM = formData.PAY_BJ_AMT;
        var PAY_LX_AMT_SUM = formData.PAY_LX_AMT;
        var PAY_BJ_RMB_SUM = formData.PAY_BJ_RMB;
        var PAY_LX_RMB_SUM = formData.PAY_LX_RMB;
        var PAY_CNF_SUM = formData.PAY_CNF;
        var PAY_CNF_RMB_SUM = formData.PAY_CNF_RMB;
        var HL_RATE = formData.FKTZ_HL_RATE;
        //舍余平衡
        var sum$PAY_BJ_AMT = 0;
        var sum$PAY_BJ_RMB = 0;
        var sum$PAY_LX_AMT = 0;
        var sum$PAY_LX_RMB = 0;
        var sum$PAY_ORI_SUM = 0;
        var sum$PAY_RMB_SUM = 0;
        var sum$PAY_CNF = 0;
        var sum$PAY_CNF_RMB = 0;
        for (var i = 0; i < self.getCount(); i++) {
            var record = self.getAt(i);
            var jsqx = record.get("JSQX");
            //建设日期在结束日期之内：按照余额比例拆分支付本金和利息
            if (jsqx <= endDate) {
                if (record.get("ZWYE_AMT") == null || record.get("ZWYE_AMT") == '' || record.get("ZWYE_AMT") == 0) {
                    record.set("PAY_BJ_AMT", 0);
                    record.set("PAY_BJ_RMB", 0);
                    record.set("PAY_LX_AMT", 0);
                    record.set("PAY_LX_RMB", 0);
                    record.set("PAY_ORI_SUM", 0);
                    record.set("PAY_RMB_SUM", 0);
                    record.set("PAY_CNF", 0);
                    record.set("PAY_CNF_RMB", 0);
                } else {
                    //舍余平衡
                    if (i == self.getCount() - 1) {
                        var PAY_BJ_AMT = PAY_BJ_AMT_SUM - sum$PAY_BJ_AMT;
                        var PAY_LX_AMT = PAY_LX_AMT_SUM - sum$PAY_LX_AMT;
                        var PAY_BJ_RMB = PAY_BJ_RMB_SUM - sum$PAY_BJ_RMB;
                        var PAY_LX_RMB = PAY_LX_RMB_SUM - sum$PAY_LX_RMB;
                        var PAY_CNF = PAY_CNF_SUM - sum$PAY_CNF;
                        var PAY_CNF_RMB = PAY_CNF_RMB_SUM - sum$PAY_CNF_RMB;
                        record.set("PAY_BJ_AMT", PAY_BJ_AMT);
                        record.set("PAY_BJ_RMB", PAY_BJ_RMB);
                        record.set("PAY_LX_AMT", PAY_LX_AMT);
                        record.set("PAY_LX_RMB", PAY_LX_RMB);
                        record.set("PAY_CNF", PAY_CNF);
                        record.set("PAY_CNF_RMB", PAY_CNF_RMB);
                        record.set("PAY_ORI_SUM", PAY_BJ_AMT + PAY_LX_AMT+PAY_CNF);
                        record.set("PAY_RMB_SUM", PAY_BJ_RMB + PAY_LX_RMB+PAY_CNF_RMB);
                    } else {
                        var PAY_BJ_AMT = Math.floor((record.get("ZWYE_AMT")* PAY_BJ_AMT_SUM / WZYE_SUM ) * 100) / 100;
                        var PAY_LX_AMT = Math.floor((record.get("ZWYE_AMT")* PAY_LX_AMT_SUM / WZYE_SUM ) * 100) / 100;
                        var PAY_BJ_RMB = Math.floor((record.get("ZWYE_AMT")* PAY_BJ_RMB_SUM / WZYE_SUM ) * 100) / 100;
                        var PAY_LX_RMB = Math.floor((record.get("ZWYE_AMT")* PAY_LX_RMB_SUM / WZYE_SUM ) * 100) / 100;
                        var PAY_CNF = Math.floor((record.get("ZWYE_AMT")* PAY_CNF_SUM / WZYE_SUM ) * 100) / 100;
                        var PAY_CNF_RMB = Math.floor((record.get("ZWYE_AMT")* PAY_CNF_RMB_SUM / WZYE_SUM ) * 100) / 100;
                        record.set("PAY_BJ_AMT", PAY_BJ_AMT);
                        record.set("PAY_BJ_RMB", PAY_BJ_RMB);
                        record.set("PAY_LX_AMT", PAY_LX_AMT);
                        record.set("PAY_LX_RMB", PAY_LX_RMB);
                        record.set("PAY_CNF", PAY_CNF);
                        record.set("PAY_CNF_RMB", PAY_CNF_RMB);
                        record.set("PAY_ORI_SUM", PAY_BJ_AMT + PAY_LX_AMT+PAY_CNF);
                        record.set("PAY_RMB_SUM", PAY_BJ_RMB + PAY_LX_RMB+PAY_CNF_RMB);
                    }
                }
            }
            //建设日期在结束日期之外：按照协议金额比例拆分支付本金和利息
            else {
                if (record.get("WZXY_AMT") == null || record.get("WZXY_AMT") == '' || record.get("WZXY_AMT") == 0) {
                    record.set("PAY_BJ_AMT", 0);
                    record.set("PAY_BJ_RMB", 0);
                    record.set("PAY_LX_AMT", 0);
                    record.set("PAY_LX_RMB", 0);
                    record.set("PAY_ORI_SUM", 0);
                    record.set("PAY_RMB_SUM", 0);
                    record.set("PAY_CNF", 0);
                    record.set("PAY_CNF_RMB", 0);
                } else {
                    //舍余平衡
                    if (i == self.getCount() - 1) {
                        var PAY_BJ_AMT = PAY_BJ_AMT_SUM - sum$PAY_BJ_AMT;
                        var PAY_LX_AMT = PAY_LX_AMT_SUM - sum$PAY_LX_AMT;
                        var PAY_BJ_RMB = PAY_BJ_RMB_SUM - sum$PAY_BJ_RMB;
                        var PAY_LX_RMB = PAY_LX_RMB_SUM - sum$PAY_LX_RMB;
                        var PAY_CNF = PAY_CNF_SUM - sum$PAY_CNF;
                        var PAY_CNF_RMB = PAY_CNF_RMB_SUM - sum$PAY_CNF_RMB;
                        record.set("PAY_BJ_AMT", PAY_BJ_AMT);
                        record.set("PAY_BJ_RMB", PAY_BJ_RMB);
                        record.set("PAY_LX_AMT", PAY_LX_AMT);
                        record.set("PAY_LX_RMB", PAY_LX_RMB);
                        record.set("PAY_CNF", PAY_CNF);
                        record.set("PAY_CNF_RMB", PAY_CNF_RMB);
                        record.set("PAY_ORI_SUM", PAY_BJ_AMT + PAY_LX_AMT+PAY_CNF);
                        record.set("PAY_RMB_SUM", PAY_LX_RMB + PAY_LX_RMB+PAY_CNF_RMB);
                    } else {
                        var PAY_BJ_AMT = Math.floor((record.get("WZXY_AMT")* PAY_BJ_AMT_SUM / WZXY_AMT_SUM ) * 100) / 100;
                        var PAY_LX_AMT = Math.floor((record.get("WZXY_AMT")* PAY_LX_AMT_SUM / WZXY_AMT_SUM ) * 100) / 100;
                        var PAY_BJ_RMB = Math.floor((record.get("WZXY_AMT")* PAY_BJ_RMB_SUM / WZXY_AMT_SUM ) * 100) / 100;
                        var PAY_LX_RMB = Math.floor((record.get("WZXY_AMT")* PAY_LX_RMB_SUM / WZXY_AMT_SUM ) * 100) / 100;
                        var PAY_CNF = Math.floor((record.get("WZXY_AMT") * PAY_CNF_SUM/ WZXY_AMT_SUM ) * 100) / 100;
                        var PAY_CNF_RMB = Math.floor((record.get("WZXY_AMT")* PAY_CNF_RMB_SUM / WZXY_AMT_SUM ) * 100) / 100;
                        record.set("PAY_BJ_AMT", PAY_BJ_AMT);
                        record.set("PAY_BJ_RMB", PAY_BJ_RMB);
                        record.set("PAY_LX_AMT", PAY_LX_AMT);
                        record.set("PAY_LX_RMB", PAY_LX_RMB);
                        record.set("PAY_CNF", PAY_CNF);
                        record.set("PAY_CNF_RMB", PAY_CNF_RMB);
                        record.set("PAY_ORI_SUM", PAY_BJ_AMT + PAY_LX_AMT+PAY_CNF);
                        record.set("PAY_RMB_SUM", PAY_BJ_RMB + PAY_LX_RMB+PAY_CNF_RMB);
                    }
                }
            }
            sum$PAY_BJ_AMT = sum$PAY_BJ_AMT + record.get("PAY_BJ_AMT");
            sum$PAY_BJ_RMB = sum$PAY_BJ_RMB + record.get("PAY_BJ_RMB");
            sum$PAY_LX_AMT = sum$PAY_LX_AMT + record.get("PAY_LX_AMT");
            sum$PAY_LX_RMB = sum$PAY_LX_RMB + record.get("PAY_LX_RMB");
            sum$PAY_ORI_SUM = sum$PAY_ORI_SUM + record.get("PAY_ORI_SUM");
            sum$PAY_RMB_SUM = sum$PAY_RMB_SUM + record.get("PAY_RMB_SUM");
            sum$PAY_CNF = sum$PAY_CNF + record.get("PAY_CNF");
            sum$PAY_CNF_RMB = sum$PAY_CNF_RMB + record.get("PAY_CNF_RMB");
        }
        flag = false;
    });
    return grid;
}
function initWindow_input_contentForm_grid_cq_yc() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "WZXY_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "协议id"
        },

        {
            dataIndex: "SJXM_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "上级项目id"
        },
        {
            dataIndex: "XM_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "项目id"
        },
        {
            dataIndex: "AD_CODE",
            type: "string",
            width: 200,
            hidden: true,
            text: "区划编码"
        },
        {
            dataIndex: "AG_ID",
            type: "string",
            width: 200,
            hidden: true,
            text: "单位id"
        },
        {
            dataIndex: "AG_CODE",
            type: "string",
            width: 200,
            hidden: true,
            text: "单位code"
        },
        {
            dataIndex: "WZXY_NAME",
            type: "string",
            width: 250,
            text: "外债名称"
        },

        {
            dataIndex: "DXM_NAME",
            type: "string",
            width: 250,
            text: "大项目名称"
        },
        {
            dataIndex: "DKLB",
            type: "string",
            width: 150,
            text: "贷款类别"
        },
        {
            dataIndex: "JSQX",
            type: "string",
            width: 100,
            text: "建设日期"
        },
        {
            dataIndex: "JSZT",
            type: "string",
            width: 100,
            text: "建设状态"
        },
        {
            dataIndex: "AD_NAME",
            type: "string",
            width: 100,
            text: "地区名称"
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            width: 150,
            text: "单位名称"
        },
        {
            dataIndex: "JSDW",
            type: "string",
            width: 150,
            text: "建设单位"
        },
        {
            dataIndex: "HKDW",
            type: "string",
            width: 150,
            text: "还款单位"
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            width: 250,
            text: "项目名称"
        },
        {
            dataIndex: "DKXZ",
            type: "string",
            width: 80,
            text: "贷款性质"
        },

        {
            dataIndex: "WZXY_AMT",
            type: "float",
            text: "转贷金额",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "ZWYE_AMT",
            type: "float",
            text: "债务余额",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_BJ_AMT",
            type: "float",
            text: "支付本金",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_LX_AMT",
            type: "float",
            text: "支付利息",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },

        {
            dataIndex: "PAY_CNF",
            type: "float",
            text: "承诺费",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'fktz_grid2_cq_yc',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: false,
        dataUrl: 'getHbfxYcData.action',
        border: true,
        flex: 1,
        height: '100%',
        width: '100%',
        viewConfig: {
            stripeRows: false
        },
        // features: [{
        //     ftype: 'summary'
        // }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'fktz_grid_plugin_cell2',
                clicksToMoveEditor: 1
            }
        ],
        pageConfig: {
            enablePage: false
        }
    });
    grid.getStore().on('load', function () {
        var xyxxGridStore = DSYGrid.getGrid('grid_select2_yc').getSelection();
        // var xyxxGridStore=Ext.ComponentQuery.query('grid[itemId="grid_select2_yc"]')[0].getStore();
        var self = grid.getStore();
        var endDate = Ext.util.Format.date(new Date(), 'Y-m-d');
        for (var i = 0; i < self.getCount(); i++) {
            var record = self.getAt(i);
            var wzxy_id  = record.get("WZXY_ID");
            var PAY_BJ_AMT_SUM = 0;
            var PAY_LX_AMT_SUM = 0;
            var PAY_CNF_SUM = 0;
            for(var q=0;q<xyxxGridStore.length;q++){
                var xyxxRecord=xyxxGridStore[q];
                if(wzxy_id==xyxxRecord.data.WZXY_ID){
                    PAY_BJ_AMT_SUM = xyxxRecord.data.ZF_BJ;
                    PAY_LX_AMT_SUM =xyxxRecord.data.ZF_LX;
                    PAY_CNF_SUM = xyxxRecord.data.ZF_CNF;
                }
            }
            var jsqx = record.get("JSQX");
            //建设日期在结束日期之内：按照余额比例拆分支付本金和利息
            if (jsqx <= endDate) {
                if (record.get("ZWYE_AMT") == null || record.get("ZWYE_AMT") == '' || record.get("ZWYE_AMT") == 0) {
                    record.set("PAY_BJ_AMT", 0);
                    record.set("PAY_LX_AMT", 0);
                    record.set("PAY_CNF", 0);
                } else {
                    var PAY_BJ_AMT = Math.floor((record.get("ZWYE_AMT")* PAY_BJ_AMT_SUM / record.get("ZWYE_AMT_SUM") ) * 100) / 100;
                    var PAY_LX_AMT = Math.floor((record.get("ZWYE_AMT")* PAY_LX_AMT_SUM /  record.get("ZWYE_AMT_SUM") ) * 100) / 100;
                    var PAY_CNF = Math.floor((record.get("ZWYE_AMT")* PAY_CNF_SUM /  record.get("ZWYE_AMT_SUM") ) * 100) / 100;
                    record.set("PAY_BJ_AMT", PAY_BJ_AMT);
                    record.set("PAY_LX_AMT", PAY_LX_AMT);
                    record.set("PAY_CNF", PAY_CNF);
                }
            }
            //建设日期在结束日期之外：按照协议金额比例拆分支付本金和利息
            else {
                if (record.get("WZXY_AMT") == null || record.get("WZXY_AMT") == '' || record.get("WZXY_AMT") == 0) {
                    record.set("PAY_BJ_AMT", 0);
                    record.set("PAY_LX_AMT", 0);
                    record.set("PAY_CNF", 0);
                } else {
                    var PAY_BJ_AMT = Math.floor((record.get("WZXY_AMT")* PAY_BJ_AMT_SUM / record.get("WZXY_AMT_SUM") ) * 100) / 100;
                    var PAY_LX_AMT = Math.floor((record.get("WZXY_AMT") * PAY_LX_AMT_SUM / record.get("WZXY_AMT_SUM")) * 100) / 100;
                    var PAY_CNF = Math.floor((record.get("WZXY_AMT")* PAY_CNF_SUM / record.get("WZXY_AMT_SUM") ) * 100) / 100;
                    record.set("PAY_BJ_AMT", PAY_BJ_AMT);
                    record.set("PAY_LX_AMT", PAY_LX_AMT);
                    record.set("PAY_CNF", PAY_CNF);
                }
            }
        }
    });
    return grid;
}
function modify(records, btn) {
    var record = records[0].getData();
    EndDateStore = getEndDateStore({"WZXY_ID": record.WZXY_ID});
    window_input.show();
    window_input.window.down('form').getForm().setValues(record);

    //获取明细grid
    DSYGrid.getGrid('fktz_grid2').getStore().removeAll();
    DSYGrid.getGrid('fktz_grid2').getStore().getProxy().extraParams['FKTZ_ID'] = record.FKTZ_ID;
    DSYGrid.getGrid('fktz_grid2').getStore().loadPage(1);
}

/**
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid(param, param_detail) {
    var grid = DSYGrid.getGrid('contentGrid');
    var start_date = grid.down("datefield[name='START_DATE']").getValue();
    var end_date = grid.down("datefield[name='END_DATE']").getValue();
    var store = grid.getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    store.getProxy().extraParams = {
        mhcx: mhcx,
        START_DATE: Ext.util.Format.date(start_date, 'Y-m-d'),
        END_DATE: Ext.util.Format.date(end_date, 'Y-m-d')
    };
    //刷新
    store.loadPage(1);
    //刷新下方表格,置为空
    if (DSYGrid.getGrid('contentGrid_detail')) {
        var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
        store_details.removeAll();
    }
}

/**
 * 工作流变更
 */
function doworkupdate(records, btn, text) {
    var ids = new Array();
    for (var k = 0; k < records.length; k++) {
        var zd_id = records[k].get("FKTZ_ID");
        ids.push(zd_id);
    }
    var sh = "";
    if (text != null) {
        sh = text;
    }
    $.post("fktzDowork.action", {
        ids: Ext.util.JSON.encode(ids),
        audit_info: sh,
        button_name: button_name,
        button_text: button_text
    }, function (data_response) {
        data_response = $.parseJSON(data_response);
        if (data_response.success) {
            Ext.toast({
                html: button_text + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.toast({
                html: button_text + "失败！" + data_response.message,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
    });
}


