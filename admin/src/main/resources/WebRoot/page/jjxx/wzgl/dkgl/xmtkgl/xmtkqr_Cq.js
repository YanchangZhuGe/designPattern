//基础数据集
var wbStore = DebtEleStore(json_debt_wb);
var BIZ_DATA_ID = null;

/**
 * 页面初始化
 */
$(function () {
    initContent();
});

var json_common = {
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
                text: '确认',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();

                    BIZ_DATA_ID = records[0].get("XMTK_ID");
                    SJXM_ID = record.SJXM_ID;

                    init_edit_tksq(btn).show();
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
                    form.setValues(record);//将记录中的数据写进form表中
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
                text: '撤销确认',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.name;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '是否确认撤销！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            var record = records[0].getData();
                            BIZ_DATA_ID = records[0].get("XMTK_ID");
                            btn.setDisabled(true);
                            $.post('updateConfirmStatus_Cq.action', {
                                button_name: button_name,
                                XMTK_ID: BIZ_DATA_ID
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: '撤销成功！',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    btn.setDisabled(false);
                                    // 刷新表格
                                    reloadGrid()
                                } else {
                                    Ext.MessageBox.alert('提示', '撤销失败！' + data.message);
                                    btn.setDisabled(false);
                                    // 刷新表格
                                    reloadGrid()
                                }

                            }, 'JSON');
                        }
                    });
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
};

/**
 * 初始化页面主要内容区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        items: [
            initContentRightPanel()//初始化右侧2个表格
        ]
    });
}

/**
 * 初始化右侧panel，放置表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        itemId: 'initContentGrid',
        dockedItems: [{
            xtype: 'toolbar',
            dock: 'top',
            itemId: 'contentPanel_toolbar',
            items: json_common.items[WF_STATUS]
        }],
        items: [
            initContentGrid(),
            initContentDetilGrid()
        ]
    });
}

/**
 * 初始化主表格
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
            dataIndex: "XMTK_ID",
            type: "string",
            text: "项目提款主单ID",
            fontSize: "15px",
            hidden: true
        },
        {
            dataIndex: "DATA_ID",
            type: "string",
            text: "协议ID",
            fontSize: "15px",
            hidden: true
        },
        {
            type: "string",
            text: '币种',
            dataIndex: "FM_ID",
            hidden: true,
            width: 100
        },
        {
            type: "float",
            text: '汇率',
            dataIndex: "HL_RATE",
            align: 'right',
            hidden: true,
            width: 100,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            type: "string",
            text: '已提款金额（原币）',
            dataIndex: "YT_AMT",
            width: 150,
            hidden: true,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            type: "float",
            text: '可提款金额（原币）',
            dataIndex: "KT_AMT",
            width: 150,
            hidden: true,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            type: "string",
            text: '债权类型',
            dataIndex: "ZQFL_ID",
            hidden: true,
            width: 150
        },
        {
            type: "string",
            text: '债权人',
            dataIndex: "ZQR_ID",
            hidden: true,
            width: 150
        },
        {
            type: "string",
            text: '债权人全称',
            dataIndex: "ZQR_FULLNAME",
            hidden: true,
            width: 150
        },
        {
            type: "string",
            text: '外债名称',
            dataIndex: "WZXY_NAME",
            width: 300
        },
        {
            type: "string",
            text: '大项目',
            dataIndex: "SJXM_NAME",
            width: 300
        },
        {
            type: "string",
            text: '建设状态',
            dataIndex: "JSZT",
            width: 100
        },
        {
            type: "float",
            text: '协议金额(原币)',
            dataIndex: "WZXY_AMT",
            width: 150,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            type: "float",
            text: '协议金额(人民币)',
            dataIndex: "WZXY_AMT_RMB",
            width: 150,
            align: 'right',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "提款总金额(原币)",
            dataIndex: "SQBF_AMT",
            type: "float",
            width: 200,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "提款日期",
            dataIndex: "SQBF_DATE",
            type: "string",
            width: 100,
            editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            text: "申请批次",
            dataIndex: "SQPC",
            type: "string",
            width: 100
        },
        {
            text: "用途",
            dataIndex: "ZJYT",
            type: "string",
            width: 300
        },
        {
            text: "确认说明",
            dataIndex: "CONFIRM_REMARK",
            type: "string",
            width: 300
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: true,
        params: {
            WF_STATUS: WF_STATUS
        },
        dataUrl: "getZwqrInfo_Cq.action",
        border: false,
        height: '50%',
        checkBox: true,
        selModel: {
            mode: "SINGLE"     //是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt11),
                width: 130,
                labelWidth: 40,
                labelAlign: 'right',
                editable: false,
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(json_common.items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "XM_SEARCH",
                width: 250,
                labelWidth: 100,
                labelAlign: 'right',
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
                xtype: "combobox",
                name: "BUILD_STATUS_ID",
                itemId: "BUILD_STATUS_ID",   //项目立项年度
                store: DebtEleTreeStoreDB("DEBT_XMJSZT", {condition: "AND CODE IN ('01','03')"}),
                fieldLabel: '建设状态',
                displayField: 'name',
                valueField: 'id',
                labelWidth: 80,
                width: 200,
                labelAlign: 'right',
                listeners: {
                    change: function (btn) {
                        reloadGrid();
                    }
                }
            }
        ],
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['XMTK_ID'] = record.get('XMTK_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化明细表格
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
            text: "提款登记单ID",
            dataIndex: "TKDJMX_ID",
            type: "string",
            width: 100,
            editable: true,
            hidden: true
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            text: "项目",
            width: 300,
            editable: false,
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
            dataIndex: "AD_NAME",
            type: "string",
            text: "地区",
            editable: true,
            width: 150
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            text: "单位",
            width: 200,
            editable: true
        },
        {
            dataIndex: "AG_CODE",
            type: "string",
            text: "单位",
            editable: true,
            hidden: true,
            width: 200
        },
        {
            dataIndex: "AG_ID",
            type: "string",
            text: "单位id",
            editable: true,
            hidden: true
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
            text: "贷款性质",
            type: "string",
            dataIndex: "DKXZ",
            width: 100
        },
        {
            dataIndex: "ZCLX_NAME",
            type: "string",
            text: "支付类别",
            width: 100,
            editable: true
        },
        {
            dataIndex: "SQS_NO",
            type: "string",
            text: "申请书编号",
            width: 150,
            editable: true
        },
        {
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "拨付金额",
            width: 150,
            editable: true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        // {
        //     dataIndex: "BF_AMT",
        //     type: "float",
        //     text: "拨付金额(人民币)",
        //     width: 150,
        //     editable: true,
        //     summaryType: 'sum',
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     },
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     }
        // },
        {
            text: "币种",
            type: "string",
            dataIndex: "FM_ID",
            width: 100
        },
        {
            dataIndex: "QR_HL",
            type: "float",
            text: "确认汇率",
            width: 100,
            editable: true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        // {
        //     dataIndex: "BF_HL",
        //     type: "float",
        //     text: "拨付汇率",
        //     width: 100,
        //     editable: true,
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.000000');
        //     }
        // },
        {
            dataIndex: "ZHYB_AMT",
            type: "float",
            text: "拨付折合原币金额",
            width: 150,
            summaryType: 'sum',
            editable: true,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            editable: true,
            width: 100,
            hidden: false,
            renderer: function (value) {
                if (value != null && value != undefined && value != '') {
                    return format(value, 'yyyy-MM-dd');
                }
            }
        },
        {
            dataIndex: "ZH_NAME",
            type: "string",
            text: "账户名称",
            editable: true,
            width: 150
        },
        {
            dataIndex: "ZH_TYPE",
            type: "string",
            text: "账户类型",
            editable: true,
            hidden: true,
            width: 100
        },
        {
            dataIndex: "ACCOUNT",
            type: "string",
            text: "账号",
            editable: true,
            width: 150
        },
        {
            dataIndex: "ZH_BANK",
            type: "string",
            text: "开户银行",
            editable: true,
            width: 150
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            editable: true,
            width: 300
        }
    ];
    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: true,
        dataUrl: 'getZwqrDetailInfo_Cq.action',
        params: {
            XMTK_ID: BIZ_XMTK_ID
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
    };
    var grid = simplyGrid.create(config);
    if (callback) {
        callback(grid);
    }
    return grid;
}

/**
 * 创建并弹出新增提款信息窗口
 */
function init_edit_tksq(btn, record) {
    return Ext.create('Ext.window.Window', {
        title: '债务确认',
        itemId: 'jjxxadd',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 添加
        frame: true,
        constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'fit',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        closeAction: 'destroy',
        items: [initEditor()],
        buttons: [
            {
                text: '保存',
                name: 'btn_update',
                id: 'save',
                handler: function (btn) {
                    saveZwqrInfo(btn);
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
 * 初始化债券转贷表单
 */
function initEditor() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'tksq_edit_form',
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
                    labelWidth: 120//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '外债协议ID',
                        disabled: false,
                        name: "DATA_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目提款主单ID',
                        disabled: false,
                        name: "XMTK_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债名称',
                        name: "WZXY_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '大项目',
                        name: "SJXM_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权类型',
                        name: "ZQFL_ID",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权人',
                        name: "ZQR_ID",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权人全称',
                        name: "ZQR_FULLNAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '币种',
                        name: "FM_ID",
                        editable: false,//禁用编
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '汇率',
                        name: "HL_RATE",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '协议金额（原币）',
                        name: "WZXY_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '协议金额人民币',
                        name: "WZXY_AMT_RMB",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

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
                    labelWidth: 120//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '已提款金额（原币）',
                        name: "YT_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '可提款金额（原币）',
                        name: "KT_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '提款总金额（原币）',
                        name: "SQBF_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '确认说明',
                        name: "CONFIRM_REMARK",
                        editable: true,
                        columnWidth: .99,
                        allowBlank: true
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            initWindow_input1_contentForm_grid()
        ]
    });
}

/**
 * 初始化债券转贷表单中转贷明细信息表格
 */
function initWindow_input1_contentForm_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "提款登记单ID",
            dataIndex: "TKDJMX_ID",
            type: "string",
            width: 100,
            editable: true,
            hidden: true
        },
        {
            dataIndex: "XM_ID",
            type: "string",
            text: "项目ID",
            width: 300,
            editable: false,
            hidden: true,
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
            dataIndex: "XM_NAME",
            type: "string",
            text: "项目",
            width: 300,
            editable: false,
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
            dataIndex: "AD_CODE",
            type: "string",
            text: "地区CODE",
            editable: true,
            width: 150,
            hidden: true
        },
        {
            dataIndex: "AD_NAME",
            type: "string",
            text: "地区",
            editable: true,
            width: 150
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            text: "单位",
            width: 200,
            editable: true
        },
        {
            dataIndex: "AG_CODE",
            type: "string",
            text: "单位",
            editable: true,
            hidden: true,
            width: 200
        },
        {
            dataIndex: "AG_ID",
            type: "string",
            text: "单位id",
            editable: true,
            hidden: true
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
            text: "贷款性质",
            type: "string",
            dataIndex: "DKXZ",
            width: 100
        },
        {
            dataIndex: "ZCLX_NAME",
            type: "string",
            text: "支付类别",
            width: 100,
            editable: true
        },
        {
            dataIndex: "SQS_NO",
            type: "string",
            text: "申请书编号",
            width: 150,
            editable: true
        },
        {
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "拨付金额",
            width: 150,
            editable: true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        // {
        //     dataIndex: "BF_AMT",
        //     type: "float",
        //     text: "拨付金额(人民币)",
        //     width: 150,
        //     editable: true,
        //     summaryType: 'sum',
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     },
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     }
        // },
        {
            text: "币种",
            type: "string",
            dataIndex: "FM_ID",
            width: 100
        },
        {
            text: "币种ID",
            type: "string",
            dataIndex: "FMID",
            width: 100,
            hidden: true
        },
        {
            dataIndex: "QR_HL",
            type: "float",
            text: "确认汇率",
            width: 100,
            tdCls: 'grid-cell',
            editor: {
                xtype: "numberfield",
                decimalPrecision: 7,
                regex: /^\d+(\.[0-9]{1,6})?$/,
                hideTrigger: true,
                mouseWheelEnabled: false,
                minValue: 0,
                allowBlank: false
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            dataIndex: "BF_HL",
            type: "float",
            text: "拨付汇率",
            width: 100,
            tdCls: 'grid-cell',
            hidden: true,
            editor: {
                xtype: "numberfield",
                decimalPrecision: 7,
                regex: /^\d+(\.[0-9]{1,6})?$/,
                hideTrigger: true,
                mouseWheelEnabled: false,
                minValue: 0,
                allowBlank: false
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "拨付折合原币金额",
            dataIndex: "ZHYB_AMT",
            type: "float",
            width: 180,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            tdCls: 'grid-cell',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            text: "确认日期",
            dataIndex: "BF_DATE",
            type: "string",
            width: 100,
            tdCls: 'grid-cell',
            editor: {
                xtype: "datefield",
                allowBlank: false,
                format: 'Y-m-d',
                value: new Date()
            },
            renderer: function (value) {
                if (value != null && value != undefined && value != '') {
                    return format(value, 'yyyy-MM-dd');
                }
            }
        },
        {
            dataIndex: "ZH_NAME",
            type: "string",
            text: "账户名称",
            editable: true,
            width: 150
        },
        {
            dataIndex: "ZH_TYPE",
            type: "string",
            text: "账户类型",
            editable: true,
            hidden: true,
            width: 100
        },
        {
            dataIndex: "ACCOUNT",
            type: "string",
            text: "账号",
            editable: true,
            width: 150
        },
        {
            dataIndex: "ZH_BANK",
            type: "string",
            text: "开户银行",
            editable: true,
            width: 150
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            editable: true,
            width: 300
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'wzzd_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: true,
        dataUrl: 'getZwqrDetailInfo_Cq.action',
        params: {
            XMTK_ID: BIZ_DATA_ID
        },
        features: [{
            ftype: 'summary'
        }],
        checkBox: true,   //显示复选框
        border: false,
        flex: 1,
        height: '100%',
        width: '100%',
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
        listeners: {
            beforeedit: function (editor, context) {
                if (context.field != 'BF_DATE' && context.field != 'QR_HL' && context.field != 'ZHYB_AMT') {
                    return false;
                }
            },
            edit: function (editor, context) {
                //拨付汇率改变时计算折合原币
                if (context.field == 'QR_HL' && context.originalValue != context.value) {
                    if(context.record.get('QR_HL') != '0.000000' && context.record.get('QR_HL') != null && context.record.get('QR_HL') != undefined ){
                        context.record.set('ZHYB_AMT',Math.floor((context.record.get('SQTK_AMT') / context.value) * 100) / 100 );

                    }else{
                        context.record.set('ZHYB_AMT', "");
                    }
                    var self = grid.getStore();
                    var input_bf_amp = 0.00;
                    self.each(function (record) {
                        input_bf_amp += record.get('ZHYB_AMT');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                }
                // 拨付折合原币计算
                if (context.field == 'ZHYB_AMT' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    var input_bf_amp = 0.00;
                    self.each(function (record) {
                        input_bf_amp += record.get('ZHYB_AMT');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                }
            }
        }
    });
    return grid;
}

/**
 * 操作记录
 */
function operationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("XMTK_ID"));
    }
}

/**
 * 刷新界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    var BUILD_STATUS_ID = Ext.ComponentQuery.query('combobox#BUILD_STATUS_ID')[0].getValue();
    store.getProxy().extraParams = {
        mhcx: mhcx,
        BUILD_STATUS_ID: BUILD_STATUS_ID,
        WF_STATUS: WF_STATUS
    };
    //刷新
    store.loadPage(1);
    //刷新明细表
    DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();

}

/**
 * 保存项目提款确认
 */
function saveZwqrInfo(self) {
    var wzzdStore = DSYGrid.getGrid('wzzd_grid').getStore();
    var form = self.up('window').down('form');
    var formData = form.getForm().getFieldValues();
    if (form.isValid()) {
        var store_data = new Array();
        var set_year = format(formData.SQBF_DATE, 'yyyy');
        for (var j = 0; j < wzzdStore.getCount(); j++) {
            var wzzdrecord = wzzdStore.getAt(j);
            var var$bf_hl = wzzdrecord.get("QR_HL");
            var var$bf_date = wzzdrecord.get("BF_DATE");
            var var$zhyb_amt = wzzdrecord.get("ZHYB_AMT");

            if (!(var$bf_hl != null && var$bf_hl != undefined && var$bf_hl != "")) {
                Ext.Msg.alert('提示', "明细中确认汇率不能为空！");
                return;
            }
            if (!(var$zhyb_amt != null && var$zhyb_amt != undefined && var$zhyb_amt != "" && var$zhyb_amt!=0)) {
                Ext.Msg.alert('提示', "明细中拨付折合原币不能为空！");
                return;
            }
            if (!(var$bf_date != null && var$bf_date != undefined && var$bf_date != "")) {
                Ext.Msg.alert('提示', "明细中确认日期不能为空！");
                return;
            }
            wzzdrecord.data.BF_DATE = (wzzdrecord.get("BF_DATE") == null || wzzdrecord.get("BF_DATE") == "") ? "" : format(wzzdrecord.get("BF_DATE"), 'yyyy-MM-dd');
            store_data.push(wzzdrecord.data)

        }
        var form = self.up('window').down('form');
        var formData = form.getForm().getFieldValues();
        if (formData.KT_AMT+0.01 < formData.SQBF_AMT) {
            Ext.MessageBox.alert('提示', '提款总金额不能大于可提款金额！');
            return;
        }
        self.setDisabled(true);
        $.post('updateConfirmStatus_Cq.action', {
            button_name: button_name,
            XMTK_ID: formData.XMTK_ID,
            SQBF_AMT: formData.SQBF_AMT,
            WZXY_ID: formData.DATA_ID,
            CONFIRM_REMARK: formData.CONFIRM_REMARK,
            WZZD_GRID: Ext.util.JSON.encode(store_data)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: '确认成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                self.up('window').close();
                // 刷新表格
                reloadGrid()
            } else {
                Ext.MessageBox.alert('提示', '确认失败！' + data.message);
                self.setDisabled(false);
            }

        }, 'JSON');
    }

}