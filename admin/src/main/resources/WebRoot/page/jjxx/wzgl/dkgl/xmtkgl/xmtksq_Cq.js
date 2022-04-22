var SJXM_ID = "";

var wzzclxStore = DebtEleStoreDB("DEBT_WZZCLX");
var wbStore =  DebtEleStore(json_debt_wb);
//建设项目基础数据
Ext.define('accountModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'AG_ID', mapping: 'AG_ID'},
        {name: 'id', mapping: 'ZJZH_ID'},
        {name: 'name', mapping: 'ZH_NAME'},
        {name: 'ZH_TYPE'},
        {name: 'ZH_BANK'},
        {name: 'ACCOUNT'}
    ]
});
//建设项目基础数据
Ext.define('sjxmModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id', mapping: 'DXM_ID'},
        {name: 'name', mapping: 'DXM_NAME'}
    ]
});
Ext.define('rateModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'code', mapping: 'WB_CODE'},
        {name: 'roe', mapping: 'ROE'}
    ]
});
Ext.define('treeModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'text'},
        {name: 'code'},
        {name: 'id'},
        {name: 'leaf'}
    ]
});
var rateStore = getRateStore();
/**
 * 页面初始化
 */
$(function () {
    initContent();
});
//可提款限额数据集
function getKtAmtStore(filterParam) {
    var kt_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['XM_ID', 'SET_YEAR', 'AMT'],
        proxy: {
            type: 'ajax',
            url: '/getKtAmtData.action',
            extraParams: filterParam,
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });
    return kt_store;
}
var kt_amt_store;
//转贷单位下拉框
var store_zddw = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: '/wzgl_reflct.action?method=getZddwTreeStore',
        extraParams: {
            AD_CODE: AD_CODE
        },
        reader: {
            type: 'json'
        }
    },
    root: 'nodelist',
    model: 'treeModel',
    autoLoad: true
});
//转贷地区下拉框
var grid_tree_store = Ext.create('Ext.data.Store', {//下拉框store
    fields: ['CODE', 'TEXT'],
    proxy: {
        type: 'ajax',
        url: '/wzgl_reflct.action?method=getAdDataByCode_cq',
        extraParams: {
            AD_CODE: AD_CODE
        },
        reader: {
            type: 'json',
            root: 'data'
        }
    },
    autoLoad: true
});
//转贷项目下拉框
var xm_tree_store = Ext.create('Ext.data.Store', {//下拉框store
    fields: ['ID', 'NAME','ADCODE', 'AGID', 'AGCODE', 'AGNAME', 'ZWLB','BUILD_STATUS'],
    proxy: {
        type: 'ajax',
        url: '/getXmInfo.action',
        extraParams: {},
        reader: {
            type: 'json',
            root: 'data'
        }
    },
    autoLoad: false
});
//获取币种汇率
function getRateStore(){
    var rateStore = Ext.create('Ext.data.Store', {
        model: 'rateModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getRateData.action",
            reader: {
                type: 'json'
            }
        },
        autoLoad: true
    });
    return rateStore;
}

/**
 * 获取该单位银行账户信息
 */
var bankStore = getBankInfoStore();

function getBankInfoStore() {
    var bankDataStore = Ext.create('Ext.data.Store', {
        model: 'accountModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getBankDataInfo.action",
            reader: {
                type: 'json'
            },
            extraParams: {
                AG_ID: AG_ID
            }
        },
        autoLoad: true
    });
    return bankDataStore;
}

/**
 * 刷新界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    var BUILD_STATUS_ID = Ext.ComponentQuery.query('combobox#BUILD_STATUS_ID')[0].getValue();
    var xmtk_start_date = Ext.ComponentQuery.query('datefield#XMTK_START_DATE')[0].getValue();
    var xmtk_end_date = Ext.ComponentQuery.query('datefield#XMTK_END_DATE')[0].getValue();
    if ((xmtk_start_date !=  null && xmtk_start_date != "" && xmtk_start_date != undefined ) && (xmtk_end_date ==  null || xmtk_end_date == "" || xmtk_end_date == undefined)) {
        Ext.Msg.alert('提示', "请选择提款结束日期");
        return false;
    }
    if ((xmtk_end_date !=  null && xmtk_end_date != "" && xmtk_end_date != undefined ) && (xmtk_start_date ==  null || xmtk_start_date == "" || xmtk_start_date == undefined)) {
        Ext.Msg.alert('提示', "请选择提款开始日期");
        return false;
    }
    var store = grid.getStore();
    store.removeAll();
    store.getProxy().extraParams = {
        mhcx: mhcx,
        BUILD_STATUS_ID:BUILD_STATUS_ID,
        XMTK_START_DATE: Ext.util.Format.date(xmtk_start_date, 'Y-m-d'),
        XMTK_END_DATE: Ext.util.Format.date(xmtk_end_date, 'Y-m-d')
    };
    //刷新
    store.loadPage(1);
    //刷新明细表
    DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();

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
        tbar: [
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '申请录入',
                name: 'apply',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.name;
                    OPERATE = 'APPLY';
                    window_xmtksq.show(null, btn);
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    //修改全局变量的值
                    button_name = btn.name;
                    title = "贷款协议修改";
                    BIZ_DATA_ID = records[0].get("XMTK_ID");
                    kt_amt_store = getKtAmtStore({XMTK_ID:records[0].get("XMTK_ID")});
                    SJXM_ID = records[0].get("SJXM_ID");

                    init_edit_tksq(btn).show();
                    var xmtkRecord = records[0].getData();
                    xmtkRecord.KT_AMT = xmtkRecord.KT_AMT + xmtkRecord.SQBF_AMT;
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
                    form.setValues(xmtkRecord);//将记录中的数据写进form表中
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'del',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    kt_amt_store = getKtAmtStore({});
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
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
                        var XMTK_IDS = records[0].get("XMTK_ID");
                        DSYGrid.exportExcelClick('contentGrid_detail', {
                            exportExcel: true,
                            url: 'getXmtkDetailGridExcel_Cq.action',
                            param: {
                                XMTK_IDS: XMTK_IDS
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
            hidden: true,
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
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        dataUrl: "getXmtkData_Cq.action",
        checkBox: true,
        border: false,
        height: '50%',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                layout: {
                    type: 'column'
                },
                border: true,
                defaults: {
                    margin: '2 2 2 2',
                    labelAlign: 'right'//控件默认标签对齐方式
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "XM_SEARCH",
                        emptyText: '请输入外债名称...',
                        enableKeyEvents: true,
                        width: 350,
                        labelWidth: 80,
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
                        itemId: "BUILD_STATUS_ID",
                        store: DebtEleTreeStoreDB("DEBT_XMJSZT",{condition: "AND CODE IN ('01','03')"}),
                        fieldLabel: '建设状态',
                        displayField: 'name',
                        valueField: 'id',
                        width: 200,
                        labelWidth: 80,
                        listeners: {
                            change: function (btn)
                            {   //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "datefield",
                        name: "XMTK_START_DATE",
                        itemId: "XMTK_START_DATE",
                        fieldLabel: '提款开始日期',
                        allowBlank: true,
                        format: 'Y-m-d',
                        width: 220,
                        labelWidth: 100
                    },
                    {
                        xtype: "datefield",
                        name: "XMTK_END_DATE",
                        itemId: "XMTK_END_DATE",
                        fieldLabel: '提款结束日期',
                        allowBlank: true,
                        format: 'Y-m-d',
                        width: 220,
                        labelWidth: 100
                    }
                ]
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
                if(record.get('XM_ID')!=null && record.get('XM_ID')!=''){
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }else{
                    return data;
                }
            }
        },
        {
            dataIndex: "AD_CODE",
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
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
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
        // {
        //     dataIndex: "ZHYB_AMT",
        //     type: "float",
        //     text: "拨付折合原币金额",
        //     width: 150,
        //     summaryType: 'sum',
        //     editable: true,
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     },
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     }
        // },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            editable: true,
            width: 100,
            hidden:true,
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
            width: 150,
            renderer: function (value) {
                var store = bankStore;
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
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
        dataUrl: 'getXmtkDetailGrid_Cq.action',
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
        // features: [{
        //     ftype: 'summary'
        // }],
    };
    var grid = simplyGrid.create(config);
    if (callback) {
        callback(grid);
    }
    return grid;
}

/**
 * 创建提款申请弹出窗口
 */
var window_xmtksq = {
    window: null,
    btn: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config, btn) {
        $.extend(this.config, config);
        if (!this.window || this.config.closeAction == 'destroy') {
            this.window = initWindow_xmtksq(this.config, btn);
        }
        this.window.show();
    }
};

/**
 * 初始化外债选择弹出窗口
 */
function initWindow_xmtksq(params) {
    return Ext.create('Ext.window.Window', {
        title: '外债选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_clzw', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_xmtksq_grid(params)],
        buttons: [
            {
                text: '确认',
                //获取表格选中数据
                handler: function (btn) {
                    kt_amt_store = getKtAmtStore({});
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();
                    BIZ_DATA_ID = records[0].get("XMTK_ID");
                    SJXM_ID = record.SJXM_ID;

                    btn.up('window').close();
                    init_edit_tksq(btn).show();
                    //获取grid
                    DSYGrid.getGrid('wzzd_grid').getStore().loadPage(1);
                    var gridStore = Ext.ComponentQuery.query('grid[itemId="wzzd_grid"]')[0];
                    var store_data = new Array();
                    var grid_store = gridStore.getStore();
                    var xmtk_id = GUID.createGUID();
                    grid_store.on('load', function () {
                        var sum_bf_amt = 0;
                        for (var i = 0; i < grid_store.getCount(); i++) {
                            var record_detail = grid_store.getAt(i);
                            sum_bf_amt += record_detail.get("ZH_AMT");
                        }
                        var KT_AMT = records[0].get("KT_AMT");
                        if (KT_AMT >= sum_bf_amt) {
                            record.SQBF_AMT = sum_bf_amt;
                        } else {
                            record.SQBF_AMT = KT_AMT;
                        }
                        var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
                        Ext.ComponentQuery.query('textfield[name="XMTK_ID"]')[0].setValue(xmtk_id);
                        form.setValues(record);//将记录中的数据写进form表中
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
 * 初始化外债选择弹出框表格
 */
function initWindow_xmtksq_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 40
        },
        {
            dataIndex: "DATA_ID",
            type: "string",
            text: "主键ID",
            fontSize: "15px",
            hidden: true
        },
        {
            type: "string",
            text: '地区',
            dataIndex: "AD_NAME",
            width: 100
        },
        {
            dataIndex: "WZXY_CODE",
            type: "string",
            width: 150,
            text: "外债编码",
            hidden: true
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
            text: '建设状态',
            type: "string",
            dataIndex: "JSZT",
            width: 100
        },
        {
            text: '协议金额(原币)',
            dataIndex: "WZXY_AMT",
            width: 200,
            type: "float",
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            type: "string",
            text: '币种',
            dataIndex: "FM_ID",
            width: 100
        },
        {
            type: "float",
            text: '汇率',
            dataIndex: "HL_RATE",
            width: 100,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000##');
            }
        },
        {
            type: "string",
            text: '协议金额(人民币)',
            dataIndex: "WZXY_AMT_RMB",
            width: 150,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            type: "string",
            text: '已提款金额(原币)',
            dataIndex: "YT_AMT",
            width: 150,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            type: "string",
            text: '可提款金额(原币)',
            dataIndex: "KT_AMT",
            width: 150,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            type: "string",
            text: '债权类型',
            dataIndex: "ZQFL_ID",
            width: 100
        },
        {
            type: "string",
            text: '债权人',
            dataIndex: "ZQR_ID",
            width: 150
        },
        {
            type: "string",
            text: '债权人全称',
            dataIndex: "ZQR_FULLNAME",
            width: 150
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'wzSelectionGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            ad_code: ad_code,
            WF_STATUS: "002"
        },
        checkBox: true,
        border: false,
        autoLoad: true,
        height: '100%',
        tbarHeight: 50,
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
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
        dataUrl: 'getWzxySelect_Cq.action',
        listeners: {
            itemclick: function (self, record) {
            }
        }
    });
}

/**
 * 创建并弹出新增提款信息窗口
 */
function init_edit_tksq(btn, record) {
    return Ext.create('Ext.window.Window', {
        title: '项目提款申请',
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
                //xtype: 'button',
                text: '保存',
                name: 'btn_update',
                id: 'save',
                handler: function (btn) {
                    saveXmtkInfo(btn);
                }
            },
            {
                //xtype: 'button',
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
 * 保存项目提款申请
 */
function saveXmtkInfo(self) {
    var wzzdStore = DSYGrid.getGrid('wzzd_grid').getStore();
    var form = self.up('window').down('form');
    var formData = form.getForm().getFieldValues();

    if (form.isValid()) {
        var store_data = new Array();
        var map =new Map();
        var set_year = format(formData.SQBF_DATE, 'yyyy');
        for (var m = 0; m < wzzdStore.getCount(); m++) {
            var wzzdrecord = wzzdStore.getAt(m);
            var var$zwlb = wzzdrecord.get("ZWLB");
            var var$BUILD_STATUS = wzzdrecord.get("BUILD_STATUS");
            if(wzzdrecord.get("ZCLX_ID")!='03'&&wzzdrecord.get("ZCLX_ID")!='99' && wzzdrecord.get("FM_ID")=='CNY'){
                var var$xm_id = wzzdrecord.get("XM_ID");
                if(var$xm_id !=null && var$xm_id != undefined && var$xm_id != "" && var$zwlb=='0101' && var$BUILD_STATUS=='01'){
                    var var$bf_amt = wzzdrecord.get("SQTK_AMT");
                    if(map.has(var$xm_id+set_year)){
                        var ole_rmb = map.get(var$xm_id+set_year);
                        map.set(var$xm_id+set_year,var$bf_amt+ole_rmb);
                    }else{
                        map.set(var$xm_id+set_year,var$bf_amt);
                    }
                }
            }
        }
        for (var j = 0; j < wzzdStore.getCount(); j++) {
            var wzzdrecord = wzzdStore.getAt(j);
            var var$ad_code = wzzdrecord.get("AD_CODE");
            var var$ag_code = wzzdrecord.get("AG_CODE");
            var var$zclx_id = wzzdrecord.get("ZCLX_ID");
            var var$sqs_no = wzzdrecord.get("SQS_NO");
            var var$bf_hl = wzzdrecord.get("BF_HL");
            var var$bf_date = wzzdrecord.get("BF_DATE");
            var var$zh_name = wzzdrecord.get("ZH_NAME");
            var var$remark = wzzdrecord.get("REMARK");
            var var$xm_id = wzzdrecord.get("XM_ID");
            var var$xm_name = wzzdrecord.get("XM_NAME");
            var var$zwlb = wzzdrecord.get("ZWLB");
            var var$BUILD_STATUS = wzzdrecord.get("BUILD_STATUS");
            var var$fm_id = wzzdrecord.get("FM_ID");

            if(var$xm_id !=null && var$xm_id != undefined && var$xm_id != "" ){
                if(var$zwlb !=null && var$zwlb != undefined && var$zwlb != "" && var$zwlb=='0101' && var$BUILD_STATUS=='01'){
                    if(wzzdrecord.get("ZCLX_ID")!='03'&&wzzdrecord.get("ZCLX_ID")!='99' && wzzdrecord.get("FM_ID")=='CNY'){
                        //获取提款限额
                        var tkxe ;
                        var records = kt_amt_store.data.filterBy('XM_ID', var$xm_id);
                        var record = records.filterBy('SET_YEAR',set_year);
                        if(record.items.length==0){
                            tkxe=0;
                        }else{
                            tkxe= record.items[0].get("AMT");
                        }
                        var tk = map.get(var$xm_id+set_year);
                        if(tk>(tkxe+0.0001)){
                            Ext.Msg.alert('提示', "项目"+var$xm_name+"的提款金额人民币高于当年提款限额！请检查数据。");
                            return;
                        }
                    }
                }
            }
            if(var$xm_id !=null && var$xm_id != undefined && var$xm_id != "" ){
                if (!(var$ad_code != null && var$ad_code != undefined && var$ad_code != "")) {
                    Ext.Msg.alert('提示', "明细中转贷地区不能为空！");
                    return;
                }
                if (!(var$ag_code != null && var$ag_code != undefined && var$ag_code != "")) {
                    Ext.Msg.alert('提示', "明细中转贷单位不能为空！");
                    return;
                }
            }

            if (!(var$zclx_id != null && var$zclx_id != undefined && var$zclx_id != "" && var$zclx_id != 0)) {
                Ext.Msg.alert('提示', "明细中支付类别不能为空！");
                return;
            }
            if (!(var$sqs_no != null && var$sqs_no != undefined && var$sqs_no != "" && var$sqs_no != 0)) {
                Ext.Msg.alert('提示', "明细中申请书编号不能为空！");
                return;
            }
            if (!(var$fm_id != null && var$fm_id != undefined && var$fm_id != "" && var$fm_id != 0)) {
                Ext.Msg.alert('提示', "明细中币种不能为空！");
                return;
            }
            // if (!(var$bf_amt != null && var$bf_amt != undefined && var$bf_amt != "" && var$bf_amt != 0)) {
            //     Ext.Msg.alert('提示', "明细中批准拨付金额不能为0！");
            //     return;
            // }
            // if (!(var$bf_hl != null && var$bf_hl != undefined && var$bf_hl != "" && var$bf_hl != 0)) {
            //     Ext.Msg.alert('提示', "明细中拨付汇率不能为0！");
            //     return;
            // }
            // if (!(var$bf_date != null && var$bf_date != undefined && var$bf_date != "" && var$bf_date != 0)) {
            //     Ext.Msg.alert('提示', "明细中拨付日期不能为空！");
            //     return;
            // }
            // if (!(var$zh_name != null && var$zh_name != undefined && var$zh_name != "" && var$zh_name != 0)) {
            //     Ext.Msg.alert('提示', "明细中账户名称不能为空！");
            //     return;
            // }
            // wzzdrecord.data.ZD_AMT =  wzzdrecord.get("ZD_AMT").toFixed(2);
            wzzdrecord.data.BF_DATE = (wzzdrecord.get("BF_DATE") == null || wzzdrecord.get("BF_DATE") == "") ? "" : format(wzzdrecord.get("BF_DATE"), 'yyyy-MM-dd');
            wzzdrecord.data.XM_ID = (wzzdrecord.get("XM_ID") == null || wzzdrecord.get("XM_ID") == "") ? "" : wzzdrecord.get("XM_ID");
            store_data.push(wzzdrecord.data)

        }

        // var tkfg_amt = 0;
        // wzzdStore.each(function (record) {
        //     if(record.get("ZCLX_ID")=='03'|| record.get("ZCLX_ID")=='99'){
        //         tkfg_amt += record.get('SQTK_AMT');
        //     }
        // });
        // if (input_bf_amp > formData.SQBF_AMT) {
        //     Ext.MessageBox.alert('提示', '拨付金额原币不能多于本次提款总金额！');
        //     return;
        // }
        // if (formData.KT_AMT+0.01 < tkfg_amt) {
        //     Ext.MessageBox.alert('提示', '咨询其他总金额不能大于可提款金额！');
        //     return;
        // }
        // if (formData.SQBF_AMT <= 0) {
        //     Ext.MessageBox.alert('提示', '请输入提款总金额！');
        //     return;
        // }
        if (formData.SQPC <= 0) {
            Ext.MessageBox.alert('提示', '请输入申请批次！');
            return;
        }

        self.setDisabled(true);
        $.post('saveXmtkInfo_Cq.action', {
            button_name: button_name,
            XMTK_ID: formData.XMTK_ID,
            SQBF_DATE: format(formData.SQBF_DATE, 'yyyy-MM-dd'),
            // SQBF_AMT: formData.SQBF_AMT,
            WZXY_ID: formData.DATA_ID,
            ZJYT: formData.ZJYT,
            SQPC: formData.SQPC,
            WZZD_GRID: Ext.util.JSON.encode(store_data)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                self.up('window').close();
                // 刷新表格
                reloadGrid()
            } else {
                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                self.setDisabled(false);
            }

        }, 'JSON');
    }
}

/**
 *工作流 删除 送审
 * @param records
 * @param btn
 */
function doworkupdate(records, btn) {
    var ids = new Array();
    var btn_name = btn.name;
    var btn_text = btn.text;
    for (var k = 0; k < records.length; k++) {
        var zd_id = records[k].get("XMTK_ID");
        ids.push(zd_id);
    }

    $.post("xmtkDowork_Cq.action", {
        ids: Ext.util.JSON.encode(ids),
        btn_name: btn_name,
        btn_text: btn_text,
    }, function (data_response) {
        data_response = $.parseJSON(data_response);
        if (data_response.success) {
            Ext.toast({
                html: btn_text + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.toast({
                html: btn_text + "失败！" + data_response.message,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
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
                    //width: 280,
                    labelWidth: 150//控件默认标签宽度
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
                    labelWidth: 150//控件默认标签宽度
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
                    // {
                    //     xtype: "numberFieldFormat",
                    //     fieldLabel: '<span class="required">✶</span>提款总金额（原币）',
                    //     name: "SQBF_AMT",
                    //     emptyText: '0.00',
                    //     allowDecimals: true,
                    //     decimalPrecision: 2,
                    //     hideTrigger: true,
                    //     keyNavEnabled: true,
                    //     mouseWheelEnabled: true,
                    //     editable: true,
                    //     allowBlank: false,
                    //     listeners: {
                    //         'change': function (self, newValue, oldValue) {
                    //             var form = this.up('form').getForm();
                    //             var KT_AMT = form.findField('KT_AMT').value;
                    //             if (newValue > KT_AMT) {
                    //                 Ext.toast({
                    //                     html: '提款总金额不能大于可提款金额！',
                    //                     closable: false,
                    //                     align: 't',
                    //                     slideInDuration: 400,
                    //                     minWidth: 400
                    //                 });
                    //             }
                    //         }
                    //     }
                    // },
                    {
                        xtype: "datefield",
                        fieldLabel: '<span class="required">✶</span>提款日期',
                        name: "SQBF_DATE",
                        editable: true,
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择申请提款日期',
                        emptyText: '请选择申请提款日期',
                        value: new Date(),
                        listeners: {
                            'change': function (self, newValue, oldValue, eOpts) {
                                var grid = DSYGrid.getGrid('wzzd_grid');
                                var store = grid.getStore();
                                for (var j = 0; j < store.getCount(); j++) {
                                    var wzzdrecord = store.getAt(j);
                                    if(wzzdrecord.get('XM_ID') != null && wzzdrecord.get('XM_ID') != undefined && newValue != null && newValue != undefined ){
                                        //获取提款限额
                                        var records = kt_amt_store.data.filterBy('XM_ID', wzzdrecord.get('XM_ID'));
                                        var record = records.filterBy('SET_YEAR',format(newValue, 'yyyy'));
                                        if(record.items.length==0){
                                            wzzdrecord.set('KT_RMB',0);
                                        }else{
                                            wzzdrecord.set('KT_RMB', record.items[0].get("AMT"));
                                        }
                                    }else{
                                        wzzdrecord.set('KT_RMB',0);
                                    }
                                }
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>申请批次',
                        name: "SQPC"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '用途',
                        name: "ZJYT",
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
            xtype: 'rownumberer',
            width: 40,
            summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "提款登记单ID",
            dataIndex: "TKDJMX_ID",
            type: "string",
            editor: 'textfield',
            hidden: true
        },
        {
            text: "项目id",
            dataIndex: "XM_ID",
            type: "string",
            hidden: true
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            text: "项目",
            width: 300,
            typeAhead: false,//不可编辑
            editor: {
                xtype: 'combobox',
                displayField: 'NAME',
                valueField: 'NAME',
                allowBlank: false,
                store: xm_tree_store
            }
        },
        {
            text: "地区",
            dataIndex: "AD_CODE",
            type: "string",
            width: 150,
            tdCls: 'grid-cell-unedit',
            typeAhead: false,//不可编辑
            // editor: {//   行政区划动态获取(下拉框)
            //     xtype: 'combobox',
            //     displayField: 'TEXT',
            //     valueField: 'CODE',
            //     store: grid_tree_store
            // },
            renderer: function (value) {
                var store = grid_tree_store;
                var record = store.findRecord('CODE', value, 0, true, true, true);
                re_value = (record != null ? record.get('TEXT') : value);
                return re_value;
            }
        },
        {
            text: "单位",
            dataIndex: "AG_NAME",
            type: "string",
            width: 200,
            displayField: 'text',
            tdCls: 'grid-cell-unedit',
            // editor: {//   行政区划动态获取(下拉框)
            //     xtype: 'treecombobox',
            //     displayField: 'text',
            //     valueField: 'text',
            //     selectModel: 'leaf',
            //     value: '',
            //     rootVisible: false,
            //     store: store_zddw
            // }
        },
        {
            text: "单位id",
            dataIndex: "AG_ID",
            type: "string",
            hidden: true
        },
        {
            text: "单位CODE",
            dataIndex: "AG_CODE",
            type: "string",
            hidden: true
        },
        {
            text: "项目贷款性质",
            dataIndex: "ZWLB",
            type: "string",
            hidden: true
        },
        {
            text: "项目建设状态",
            dataIndex: "BUILD_STATUS",
            type: "string",
            hidden: true
        },
        {
            text: "项目贷款性质",
            dataIndex: "ZWLB_NAME",
            type: "string",
            width: 100,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "支付类别",
            dataIndex: "ZCLX_ID",
            type: "string",
            width: 100,
            // tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                allowBlank: false,
                store: wzzclxStore
            },
            renderer: function (value) {
                var record = wzzclxStore.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "申请书编号",
            dataIndex: "SQS_NO",
            width: 100,
            type: "string",
            editor: 'textfield'
        },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            width: 100,
            hidden:true,
            editor: {
                xtype: "datefield",
                allowBlank: false,
                format: 'Y-m-d'
            },
            renderer: function (value) {
                if (value != null && value != undefined && value != '') {
                    return format(value, 'yyyy-MM-dd');
                }
            }
        },

        {
            text: "可提款金额(人民币)",
            dataIndex: "KT_RMB",
            type: "float",
            width: 180,
            editable: true,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "拨付金额",
            dataIndex: "SQTK_AMT",
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
            // tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        // {
        //     text: "拨付金额(人民币)",
        //     dataIndex: "BF_AMT",
        //     type: "float",
        //     width: 180,
        //     editor: {
        //         xtype: "numberFieldFormat",
        //         emptyText: '0.00',
        //         hideTrigger: true,
        //         mouseWheelEnabled: true,
        //         minValue: 0,
        //         allowBlank: false
        //     },
        //     // tdCls: 'grid-cell-unedit',
        //     summaryType: 'sum',
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     },
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00####');
        //     }
        // },
        {
            text: "币种",
            dataIndex: "FM_ID",
            type: "string",
            width: 150,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                allowBlank: false,
                store: wbStore
            },
            renderer: function (value) {
                var record = wbStore.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        // {
        //     text: "拨付汇率",
        //     type: "float",
        //     dataIndex: "BF_HL",
        //     width: 100,
        //     format :'0,000.000000',
        //     editor: {
        //         xtype: "numberfield",
        //         decimalPrecision:7,
        //         regex: /^\d+(\.[0-9]{1,6})?$/,
        //         hideTrigger: true,
        //         mouseWheelEnabled: false,
        //         minValue: 0,
        //         allowBlank: false
        //     },
        //     renderer: function (value, cell) {
        //         value = Ext.util.Format.number(value,'0,000.000000');
        //         return value;
        //     }
        // },
        // {
        //     text: "拨付折合原币金额",
        //     dataIndex: "ZHYB_AMT",
        //     type: "float",
        //     width: 180,
        //     // editor: {
        //     //     xtype: "numberFieldFormat",
        //     //     emptyText: '0.00',
        //     //     hideTrigger: true,
        //     //     mouseWheelEnabled: true,
        //     //     minValue: 0,
        //     //     allowBlank: false
        //     // },
        //     tdCls: 'grid-cell-unedit',
        //     summaryType: 'sum',
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     },
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     }
        // },
        {
            text: "账户名称",
            dataIndex: "ZH_NAME",
            type: "string",
            width: 200,
            editor: 'textfield'
        },
        {
            text: "账户类型",
            dataIndex: "ZH_TYPE",
            type: "string",
            width: 150,
            hidden:true,
            editor: 'textfield'
        },
        {
            text: "账号",
            dataIndex: "ACCOUNT",
            type: "string",
            width: 150,
            editor: 'textfield'
        },
        {
            text: "开户银行",
            dataIndex: "ZH_BANK",
            type: "string",
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            width: 300,
            editor: 'textfield'
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'wzzd_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: true,
        dataUrl: 'getTkhzGridData_Cq.action',
        tbar: [
            {
                xtype: 'button',
                text: '添加',
                name: 'INPUT',
                icon: '/image/sysbutton/add.png',
                width: 70,
                handler: onAddRow
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'DELETE',
                icon: '/image/sysbutton/delete.png',
                width: 70,
                handler: onRemoveRow
            },
            '->',
            {xtype: 'label', text: '单位:元', width: 80, cls: "label-color"}
        ],
        params: {
            XMTK_ID: BIZ_DATA_ID
        },
        // features: [{
        //     ftype: 'summary'
        // }],
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
                if (context.field == 'XM_NAME') {
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();
                    var WZXY_ID = form.getValues().DATA_ID;
                    xm_tree_store.proxy.extraParams['WZXY_ID'] = WZXY_ID;
                    xm_tree_store.load({
                        callback: function () {

                        }
                    });
                }
                // if (context.field == 'XM_NAME') {
                //     var var$temp1 = context.record.get('AD_CODE');
                //     var var$temp2 = context.record.get('AG_CODE');
                //     if (var$temp1 == null || var$temp1 == "" || var$temp1 == undefined) {
                //         Ext.MessageBox.alert('提示', '请先选择转贷地区！');
                //         return false;
                //     } else if (var$temp2 == null || var$temp2 == "" || var$temp2 == undefined) {
                //         Ext.MessageBox.alert('提示', '请先选择转贷单位！');
                //         return false;
                //     } else {
                //         var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();
                //         var formData = form.getValues();
                //         var DATA_ID = formData.DATA_ID;
                //         xm_tree_store.proxy.extraParams['AG_ID'] = context.record.get('AG_ID');
                //         xm_tree_store.proxy.extraParams['WZXY_ID'] = DATA_ID;
                //         xm_tree_store.load({
                //             callback: function () {
                //
                //             }
                //         });
                //     }
                // }
                // if (context.field == 'AG_NAME') {
                //     var var$temp1 = context.record.get('AD_CODE');
                //     if (var$temp1 == null || var$temp1 == "" || var$temp1 == undefined) {
                //         Ext.MessageBox.alert('提示', '请先选择转贷地区！');
                //         return false;
                //     } else {
                //         store_zddw.proxy.extraParams['AD_CODE'] = var$temp1;
                //         store_zddw.load({
                //             callback: function () {
                //             }
                //         });
                //     }
                // }
                //账户类型
                // if (context.field == 'ZH_NAME') {
                //     var var$temp1 = context.record.get('AD_CODE');
                //     var var$temp2 = context.record.get('AG_CODE');
                //     if (var$temp1 == null || var$temp1 == "" || var$temp1 == undefined) {
                //         Ext.MessageBox.alert('提示', '请先选择转贷地区！');
                //         return false;
                //     } else if (var$temp2 == null || var$temp2 == "" || var$temp2 == undefined) {
                //         Ext.MessageBox.alert('提示', '请先选择转贷单位！');
                //         return false;
                //     } else {
                //         bankStore.proxy.extraParams['AG_ID'] = context.record.get('AG_ID');
                //         bankStore.proxy.extraParams['IS_ALL'] = context.record.get('0');
                //         bankStore.load({
                //             callback: function () {
                //
                //             }
                //         });
                //     }
                // }
            },
            validateedit: function (editor, context) {
                // if (context.field == 'AD_CODE') {
                //     var record = grid_tree_store.findRecord('TEXT', context.value, 0, false, true, true);
                //     if (record != null && record != "") {
                //         var ad_code = record.get("CODE");
                //         var AD_NAME = record.get("TEXT");
                //         context.record.set('AD_CODE', ad_code);
                //         context.record.set('AD_NAME', AD_NAME);
                //     }
                // }
                if (context.field == 'XM_NAME') {
                    var record = xm_tree_store.findRecord('NAME', context.value, 0, false, true, true);
                    if (record != null && record != "") {
                        var xm_id = record.get("ID");
                        context.record.set('XM_ID', xm_id);
                        var ZWLB = record.get("ZWLB");
                        context.record.set('ZWLB', ZWLB);
                        var BUILD_STATUS = record.get("BUILD_STATUS");
                        context.record.set('BUILD_STATUS', BUILD_STATUS);
                        if(ZWLB=='0101'){
                            context.record.set('ZWLB_NAME', "一类");
                        }else if(ZWLB=='0201'){
                            context.record.set('ZWLB_NAME', "二类");
                        }else{
                            context.record.set('ZWLB_NAME', null);
                        }
                    }
                }
                // if (context.field == 'AG_NAME') {
                //     var record = store_zddw.findRecord('text', context.value, 0, false, true, true);
                //     if (record != null && record != "") {
                //         var ag_id;
                //         var ag_code;
                //         var childnodes = record.childNodes;
                //         if(childnodes.length>0){
                //             for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
                //                 var rootnode = childnodes[i];
                //                 if ((rootnode.data.name && rootnode.data.name==context.value) || rootnode.data.text==context.value) {
                //                     ag_id= rootnode.data.id;
                //                     ag_code=rootnode.data.code;
                //                 }else{
                //                     ag_id=record.data.id;
                //                     ag_code=record.data.code;
                //                 }
                //             }
                //         }else{
                //             ag_id= record.get("id");
                //             ag_code= record.get("code");
                //         }
                //         context.record.set('AG_ID', ag_id);
                //         context.record.set('AG_CODE', ag_code);
                //     }
                // }
            },
            edit: function (editor, context) {
                //根据币种显示汇率
                if (context.field == 'FM_ID' && context.originalValue != context.value) {
                    var result = rateStore.findRecord('code', context.value, 0, false, true, true);
                    if (result != null) {
                        context.record.set('BF_HL', result.get("roe"));
                        // context.record.set('ZHYB_AMT',Math.floor((context.record.get('BF_AMT') / context.record.get('BF_HL')) * 100) / 100 );
                    }
                    // var self = grid.getStore();
                    // var input_bf_amp = 0.00;
                    // self.each(function (record) {
                    //     input_bf_amp += record.get('ZHYB_AMT');
                    // });
                    // Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                }
                if (context.field == 'XM_NAME' && context.originalValue != context.value) {
                    if(context.record.get('XM_ID') != null && context.record.get('XM_ID') != undefined && context.record.get('XM_ID') != "" ){
                        var record = xm_tree_store.findRecord('NAME', context.record.get('XM_NAME'), 0, false, true, true);
                        if (record != null && record != "") {
                            var ad_code = record.get("ADCODE");
                            var ag_id = record.get("AGID");
                            var ag_name = record.get("AGNAME");
                            var ag_code = record.get("AGCODE");
                            context.record.set('AD_CODE', ad_code);
                            context.record.set('AG_ID', ag_id);
                            context.record.set('AG_NAME', ag_name);
                            context.record.set('AG_CODE', ag_code);
                        }else{
                            context.record.set('XM_ID', null);
                            context.record.set('AD_CODE', null);
                            context.record.set('AG_ID', null);
                            context.record.set('AG_CODE', null);
                            context.record.set('AG_NAME', null);
                            context.record.set('ZWLB', null);
                            context.record.set('ZWLB_NAME', null);
                            context.record.set('BUILD_STATUS', null);
                        }
                    }
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();
                    var formData = form.getValues();
                    var SQBF_DATE = formData.SQBF_DATE;
                    if(SQBF_DATE != null && SQBF_DATE != undefined && SQBF_DATE != ""  ){
                        if(context.record.get('XM_ID') != null && context.record.get('XM_ID') != undefined && context.record.get('XM_ID') != "" ){
                            //获取提款限额
                            var records = kt_amt_store.data.filterBy('XM_ID', context.record.get('XM_ID'));
                            var record = records.filterBy('SET_YEAR',format(SQBF_DATE, 'yyyy'));
                            if(record.items.length==0){
                                context.record.set('KT_RMB', 0);
                            }else{
                                context.record.set('KT_RMB', record.items[0].get("AMT"));
                            }
                        }
                    }
                }
                //根据拨付日期计算出当年的项目剩余限额
                // if (context.field == 'BF_DATE' && context.originalValue != context.value) {
                //     if(context.record.get('XM_ID') != null && context.record.get('XM_ID') != undefined && context.record.get('XM_ID') != "" ){
                //         //获取提款限额
                //         var records = kt_amt_store.data.filterBy('XM_ID', context.record.get('XM_ID'));
                //         var record = records.filterBy('SET_YEAR',format(context.record.get('BF_DATE'), 'yyyy'));
                //         if(record.items.length==0){
                //             context.record.set('KT_RMB', 0);
                //         }else{
                //             context.record.set('KT_RMB', record.items[0].get("AMT"));
                //         }
                //     }
                // }

                //转贷地区改变时，移除转贷项目
                // if (context.field == 'AD_CODE' && context.originalValue != context.value) {
                //     context.record.set('XM_NAME', null);
                //     context.record.set('XM_ID', null);
                //     context.record.set('AG_NAME', null);
                //     context.record.set('ZH_NAME', null);
                //     context.record.set('ZH_TYPE', null);
                //     context.record.set('ACCOUNT', null);
                //     context.record.set('ZH_BANK', null);
                //     context.record.set('ZWLB', null);
                //     context.record.set('ZWLB_NAME', null);
                // }
                // if (context.field == 'AG_NAME' && context.originalValue != context.value) {
                //     context.record.set('XM_NAME', null);
                //     context.record.set('XM_ID', null);
                //     context.record.set('KT_RMB', 0);
                //     context.record.set('ZWLB', null);
                //     context.record.set('ZWLB_NAME', null);
                //     bankStore.proxy.extraParams['AG_ID'] = context.record.get('AG_ID');
                //     bankStore.proxy.extraParams['IS_ALL'] = "1";
                //     bankStore.load({
                //         callback: function () {
                //             var record = bankStore.findRecord('AG_ID', context.record.get('AG_ID'), 0, false, true, true);
                //             if (record != null && record != "") {
                //                 context.record.set('ZH_NAME', record.get("ZH_NAME"));
                //                 context.record.set('ACCOUNT', record.get("ACCOUNT"));
                //                 context.record.set('ZH_BANK', record.get("ZH_BANK"));
                //                 context.record.set('ZH_TYPE', record.get("ZH_TYPE"));
                //             }else{
                //                 context.record.set('ZH_NAME', null);
                //                 context.record.set('ZH_TYPE', null);
                //                 context.record.set('ACCOUNT', null);
                //                 context.record.set('ZH_BANK', null);
                //             }
                //         }
                //     });
                // }

                //账户类型
                // if (context.field == 'ZH_NAME') {
                //     var account_value = bankStore.findRecord('AG_ID', context.record.get('AG_ID'), false, true, true);
                //     if (account_value != null && account_value != undefined) {
                //         context.record.set('ACCOUNT', account_value.get("ACCOUNT"));
                //         context.record.set('ZH_BANK', account_value.get("ZH_BANK"));
                //         context.record.set('ZH_TYPE', account_value.get("ZH_TYPE"));
                //     }
                // }

                // 拨付折合原币计算
                // if (context.field == 'BF_AMT' && context.originalValue != context.value) {
                //     if(context.record.get('BF_HL') != '0.000000' && context.record.get('BF_HL') != null && context.record.get('BF_HL') != undefined ){
                //         context.record.set('ZHYB_AMT', Math.floor((context.value / context.record.get('BF_HL')) * 100) / 100);
                //     }else{
                //         context.record.set('ZHYB_AMT', "");
                //     }
                //     // var self = grid.getStore();
                //     // var input_bf_amp = 0.00;
                //     // self.each(function (record) {
                //     //     input_bf_amp += record.get('ZHYB_AMT');
                //     // });
                //     // Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                // }

                //拨付汇率改变时计算折合原币
                // if (context.field == 'BF_HL' && context.originalValue != context.value) {
                //     if(context.record.get('BF_HL') != '0.000000' && context.record.get('BF_HL') != null && context.record.get('BF_HL') != undefined ){
                //         context.record.set('ZHYB_AMT',Math.floor((context.record.get('BF_AMT') / context.value) * 100) / 100 );
                //
                //     }else{
                //         context.record.set('ZHYB_AMT', "");
                //     }
                //     // var self = grid.getStore();
                //     // var input_bf_amp = 0.00;
                //     // self.each(function (record) {
                //     //     input_bf_amp += record.get('ZHYB_AMT');
                //     // });
                //     // Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                // }
            }
        }
    });
    return grid;
}

/**
 * 添加一行数据
 */
function onAddRow(btn) {
    var TKDJMX_ID=GUID.createGUID();
    var wzzd_grid = DSYGrid.getGrid('wzzd_grid');
    wzzd_grid.insertData(null, {
        TKDJMX_ID: TKDJMX_ID
    });
}

/**
 * 删除选择行
 */
function onRemoveRow() {
    var wzzd_grid = DSYGrid.getGrid('wzzd_grid');
    var store = wzzd_grid.getStore();
    var input_bf_amp = 0.00;
    var sm = wzzd_grid.getSelectionModel();
    store.remove(sm.getSelection());
    if (store.getCount() > 0) {
        sm.select(0);
    }
    // store.each(function (record) {
    //     input_bf_amp += record.get('ZHYB_AMT');
    // });
    // Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
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