/**
 * 初始化
 */
$(document).ready(function () {
    initContent();
});
/**
 * 债券类别
 */
var json_debt_ndzqlb = [
    {"id": "01", "code": "01", "name": "新增债券"},
    {"id": "03", "code": "03", "name": "再融资债券"}
];
var button_name = '';
var zqlbStroe = DebtEleTreeStoreDB('DEBT_ZQLB');
var zjlxStore = DebtEleStore(json_debt_ndzqlb);
var monthStore = DebtEleStore(json_debt_yf);

/**
 * 初始化主界面
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        width: '100%',
        height: '100%',
        renderTo: Ext.getBody(),
        layout: {
            type: 'vbox',//竖直布局 item 有一个 flex属性
            align: 'stretch' //拉伸使其充满整个父容器
        },
        tbar: [
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
                    window_ndfxjh.show(btn);
                    var NDJH_ZD_ID = GUID.createGUID();
                    Ext.ComponentQuery.query('textfield[name="NDJH_ZD_ID"]')[0].setValue(NDJH_ZD_ID);

                }
            },
            {
                text: '修改',
                name: 'update',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    window_ndfxjh.show(btn);
                    var xzndfxjhRecord = records[0].getData();
                    DSYGrid.getGrid('xzndjhDetail_grid').getStore().getProxy().extraParams['NDJH_ZD_ID'] = records[0].get('NDJH_ZD_ID');
                    DSYGrid.getGrid('xzndjhDetail_grid').getStore().loadPage(1);

                    var form = Ext.ComponentQuery.query('form#ndfxjh_edit_form')[0].getForm();//找到该form
                    form.setValues(xzndfxjhRecord);//将记录中的数据写进form表中
                }
            },
            {
                text: '删除',
                name: 'del',
                xtype: 'button',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            var ids = new Array();
                            var btn_name = btn.name;
                            var btn_text = btn.text;
                            for (var k = 0; k < records.length; k++) {
                                var ndjh_zd_id = records[k].get("NDJH_ZD_ID");
                                ids.push(ndjh_zd_id);
                            }
                            $.post("delNdfxjhInfo.action", {
                                ids: Ext.util.JSON.encode(ids),
                                btn_name: btn_name,
                                btn_text: btn_text
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
                                    totalSum();
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
    var grid = DSYGrid.getGrid("contentGrid");
    var toolbar = grid.down("toolbar");
    toolbar.add(Ext.create("Ext.form.Label", { text: '单位：亿元'}));
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
            text: "虚拟主单ID",
            dataIndex: "NDJH_ZD_ID",
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {
            text: '年度',
            dataIndex: "NDJH_YEAR",
            type: "string",
            width: 100
        },
        {
            text: '计划发行额',
            dataIndex: "PLAN_AMT_TOTAL_SUM",
            type: "float",
            width: 160,
            align: 'right',
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: '新增一般债券',
            dataIndex: "PLAN_AMT_XZYB_SUM",
            type: "float",
            width: 160,
            align: 'right',
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: '新增专项债券',
            dataIndex: "PLAN_AMT_XZZX_SUM",
            type: "float",
            width: 160,
            align: 'right',
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "置换一般债券",
            dataIndex: "PLAN_AMT_ZHYB_SUM",
            type: "float",
            width: 160,
            // hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: '置换专项债券',
            dataIndex: "PLAN_AMT_ZHZX_SUM",
            type: "float",
            width: 160,
            align: 'right',
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "再融资一般债券",
            dataIndex: "PLAN_AMT_ZRZYB_SUM",
            type: "float",
            width: 160,
            // hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: '再融资专项债券',
            dataIndex: "PLAN_AMT_ZRZZX_SUM",
            type: "float",
            width: 160,
            align: 'right',
            // hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "新增债券",
            dataIndex: "PLAN_AMT_XZ_SUM",
            type: "float",
            width: 160,
            hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "再融资债券",
            dataIndex: "PLAN_AMT_ZRZ_SUM",
            type: "float",
            width: 160,
            hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        }
    ];
    return DSYGrid.createGrid({
        height: '50%',
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        dataUrl: 'getContentGridInfo.action',
        checkBox: true,
        border: false,
        autoLoad: true,
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },

        tbar: [
            {
                xtype: "combobox",
                itemId: "NDJH_YEAR",   //项目立项年度
                store: DebtEleStoreDB('DEBT_YEAR'),
                fieldLabel: '年度',
                displayField: 'code',
                valueField: 'id',
                value: new Date().getFullYear(),
                width: 150,
                labelWidth: 30,
                editable: false,
                listeners: {
                    change: function (btn) {
                        //刷新当前表格
                        reloadGrid();

                    }
                }
            },
            '->',
        ],
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['NDJH_ZD_ID'] = record.get('NDJH_ZD_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}

/**
 *  初始化明细表格
 */
function initContentDetilGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "年度计划ID",
            dataIndex: "NDJH_ID",
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {
            text: '月份',
            type: "string",
            dataIndex: "NDJH_MONTH",
            width: 100,
            renderer: function (value) {
                var record = monthStore.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "计划发行额",
            dataIndex: "PLAN_AMT_TOTAL",
            type: "float",
            width: 160,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "新增债券",
            dataIndex: "XZ_PLAN_AMT_TOTAL",
            type: "float",
            width: 160,
            hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "新增一般债券",
            dataIndex: "SUM_AMT_XZYB",
            type: "float",
            width: 160,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "新增专项债券",
            dataIndex: "SUM_AMT_XZZX",
            type: "float",
            width: 160,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "再融资债券",
            dataIndex: "ZRZ_PLAN_AMT_TOTAL",
            type: "float",
            width: 160,
            hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "置换一般债券",
            dataIndex: "SUM_AMT_ZHYB",
            type: "float",
            width: 160,
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "置换专项债券",
            dataIndex: "SUM_AMT_ZHZX",
            type: "float",
            width: 160,
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "再融资一般债券",
            dataIndex: "SUM_AMT_ZRZYB",
            type: "float",
            width: 160,
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "再融资专项债券",
            dataIndex: "SUM_AMT_ZRZZX",
            type: "float",
            width: 160,
            hidden: false,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getContentDetailGridInfo.action',
        flex: 1,
        border: false,
        autoLoad: true,
        height: '50%',
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    });
}

/**
 * 刷新界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    var NDJH_YEAR = Ext.ComponentQuery.query('combobox#NDJH_YEAR')[0].getValue();
    store.getProxy().extraParams = {
        NDJH_YEAR: NDJH_YEAR
    };
    //刷新
    store.loadPage(1);
    //刷新明细表
    DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();

}


/**
 * 创建年度发行计划弹出窗口
 */
var window_ndfxjh = {
    window: null,
    btn: null,
    show: function (btn) {
        this.window = initwindow_select(btn);
        this.window.show();
    }
};

/**
 * 初始化年度发行计划Windows框
 */
function initwindow_select(btn) {
    return Ext.create('Ext.window.Window', {
        title: btn.text + '年度发行计划', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        tbar: [
            '->',
            {xtype: 'label', text: '单位 : 亿元', width: 80}
        ],
        buttons: [
            {
                text: '添加',
                id: 'addBtn',
                name: 'addBtn',
                handler: function () {
                    var grid = DSYGrid.getGrid('xzndjhDetail_grid');
                    var month = 0 ;
                    if( grid.getStore().getCount() > 0){
                        for ( var i = 0; i < grid.getStore().getCount(); i++) {
                            var record = grid.getStore().getAt(i);
                            month = month > parseInt(record.get('NDJH_MONTH')) ? month :  parseInt(record.get('NDJH_MONTH'));
                        }
                    }
                    // var NDJH_ID = GUID.createGUID();
                    var zqlx_id = '01';

                    var ndjh_month = month+1 > 12 ? 12 : month+1;
                    var ndfxjhStroe = DSYGrid.getGrid('xzndjhDetail_grid');
                    ndfxjhStroe.insertData(null, {
                        // NDJH_ID: NDJH_ID,
                        NDJH_MONTH: ndjh_month < 10 ? "0"+ndjh_month : ndjh_month,
                        ZQLX_ID:zqlx_id
                    });
                }
            },
            {
                text: '删除',
                id: 'delBtn',
                name: 'delBtn',
                handler: function () {
                    var grid = DSYGrid.getGrid('xzndjhDetail_grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }

                }
            },
            {
                text: '保存',
                name: 'btn_update',
                id: 'save',
                handler: function (btn) {
                    saveXmtkInfo(btn);
                }
            },
            {
                text: '取消',
                name: 'btn_delete',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        items: [
            initEditor()
        ]

    });
}


function initEditor() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'ndfxjh_edit_form',
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
                    labelWidth: 200//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: '虚拟主单ID',
                        xtype: "textfield",
                        name: "NDJH_ZD_ID",
                        disabled: false,
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        fieldLabel: '年度',
                        name: "NDJH_YEAR",   //项目立项年度
                        xtype: "combobox",
                        store: DebtEleStoreDB('DEBT_YEAR'),
                        displayField: 'code',
                        valueField: 'id',
                        allowBlank: false,
                        value: new Date().getFullYear(),
                        editable: false
                    },
                    {
                        fieldLabel: '计划发行额',
                        name: "PLAN_AMT_TOTAL_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})

                    },
                    {
                        fieldLabel: '新增一般债券',
                        name: "PLAN_AMT_XZYB_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        fieldLabel: '新增专项债券',
                        name: "PLAN_AMT_XZZX_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        fieldLabel: '置换一般债券',
                        name: "PLAN_AMT_ZHYB_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        fieldLabel: '置换专项债券',
                        name: "PLAN_AMT_ZHZX_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        fieldLabel: '再融资一般债券',
                        name: "PLAN_AMT_ZRZYB_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        fieldLabel: '再融资专项债券',
                        name: "PLAN_AMT_ZRZZX_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        fieldLabel: '再融资债券',
                        name: "PLAN_AMT_ZRZ_SUM",
                        xtype: "numberFieldFormat",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0,000.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: true
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
            text: "年度发行计划ID",
            dataIndex: "NDJH_ID",
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {
            text: '月份',
            type: "string",
            dataIndex: "NDJH_MONTH",
            width: 100,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                allowBlank: false,
                store: monthStore
            },
            renderer: function (value) {
                var record = monthStore.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "债券类别",
            dataIndex: "ZQLX_ID",
            type: "string",
            width: 150,
            hidden: true,
            // editor: {
            //     xtype: 'combobox',
            //     displayField: 'name',
            //     valueField: 'code',
            //     editable: false,
            //     allowBlank: false,
            //     store: zjlxStore
            // },
            renderer: function (value) {
                var record = zjlxStore.findRecord('code', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "债券类型",
            dataIndex: "ZQLB_ID",
            type: "string",
            width: 200,
            hidden: true,
            editor: {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                selectModel: 'leaf',
                editable: false,
                rootVisible: false,
                store: zqlbStroe
            },
            renderer: function (value) {
                var record = zqlbStroe.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "新增一般发行额",
            dataIndex: "PLAN_AMT_YB",
            type: "float",
            width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0,000.0000000000',
                hideTrigger: true,
                decimalPrecision: 10,
                mouseWheelEnabled: true,
                minValue: 0,
                maxValue: 999999.9999999999,
                allowBlank: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            }
        },
        {
            text: "新增专项发行额",
            dataIndex: "PLAN_AMT_ZX",
            type: "float",
            width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0,000.0000000000',
                hideTrigger: true,
                decimalPrecision: 10,
                mouseWheelEnabled: true,
                minValue: 0,
                maxValue: 999999.9999999999,
                allowBlank: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            }
        },
        {
            text: "置换一般发行额",
            dataIndex: "PLAN_AMT_ZHYB",
            type: "float",
            width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0,000.0000000000',
                hideTrigger: true,
                decimalPrecision: 10,
                mouseWheelEnabled: true,
                minValue: 0,
                maxValue: 999999.9999999999,
                allowBlank: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            }
        },
        {
            text: "置换专项发行额",
            dataIndex: "PLAN_AMT_ZHZX",
            type: "float",
            width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0,000.0000000000',
                hideTrigger: true,
                decimalPrecision: 10,
                mouseWheelEnabled: true,
                minValue: 0,
                maxValue: 999999.9999999999,
                allowBlank: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            }
        },
        {
            text: "再融资一般发行额",
            dataIndex: "PLAN_AMT_ZRZYB",
            type: "float",
            width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0,000.0000000000',
                hideTrigger: true,
                decimalPrecision: 10,
                mouseWheelEnabled: true,
                minValue: 0,
                maxValue: 999999.9999999999,
                allowBlank: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            }
        },
        {
            text: "再融资专项发行额",
            dataIndex: "PLAN_AMT_ZRZZX",
            type: "float",
            width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0,000.0000000000',
                hideTrigger: true,
                decimalPrecision: 10,
                mouseWheelEnabled: true,
                minValue: 0,
                maxValue: 999999.9999999999,
                allowBlank: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000000000');
            }
        },
        {
            text: "备注",
            dataIndex: "REMARK",
            type: "string",
            width: 200,
            editor: {
                type: 'textfield',
                maxLength: 499
            }

        }
    ];
    var grid = DSYGrid.createGrid({
        height: '100%',
        width: '100%',
        itemId: 'xzndjhDetail_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: true,   //显示复选框
        border: false,
        flex: 1,
        dataUrl: 'getXzndjhDetailGridInfo.action',
        features: [{
            ftype: 'summary'
        }],
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
            edit: function (editor, context) {
                // if (context.field == 'ZQLX_ID' && context.originalValue != context.value) {
                //     var self = grid.getStore();
                //     //新增债券
                //     var plan_amt_xz_sum = 0.000000;
                //     //再融资债券
                //     var plan_amt_zrz_sum = 0.000000;
                //     //计划发行额
                //     var plan_amt_total_sum = 0.000000;
                //     self.each(function (record) {
                //         if (record.get('ZQLX_ID') == 01) {
                //             plan_amt_xz_sum += record.get('PLAN_AMT_TOTAL');
                //         } else if (record.get('ZQLX_ID') == 03) {
                //             plan_amt_zrz_sum += record.get('PLAN_AMT_TOTAL');
                //         }
                //         plan_amt_total_sum += record.get('PLAN_AMT_TOTAL');
                //     });
                //     Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZ_SUM"]')[0].setValue(plan_amt_xz_sum);
                //     Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZRZ_SUM"]')[0].setValue(plan_amt_zrz_sum);
                //     Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(plan_amt_total_sum);
                // }
                // 拨付折合原币计算
                if (context.field == 'PLAN_AMT_YB' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    // 新增一般债券
                    var plan_amt_xzyb_sum = 0.000000;
                    // 新增专项债券
                    // var plan_amt_xzzx_sum = 0.000000;
                    // 计划发行额
                    var plan_amt_total_sum = 0.000000;
                    self.each(function (record) {
                        plan_amt_xzyb_sum += record.get('PLAN_AMT_YB');
                        // plan_amt_xzzx_sum += record.get('PLAN_AMT_ZX');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZYB_SUM"]')[0].setValue(plan_amt_xzyb_sum);
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZZX_SUM"]')[0].setValue(plan_amt_xzzx_sum);
                    totalSum();
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(plan_amt_xzyb_sum+total_amt);
                }
                // 拨付折合原币计算
                if (context.field == 'PLAN_AMT_ZX' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    // 新增一般债券
                    // var plan_amt_xzyb_sum = 0.000000;
                    // 新增专项债券
                    var plan_amt_xzzx_sum = 0.000000;
                    // 计划发行额
                    var plan_amt_total_sum = 0.000000;
                    self.each(function (record) {
                        // plan_amt_xzyb_sum += record.get('PLAN_AMT_YB');
                        plan_amt_xzzx_sum += record.get('PLAN_AMT_ZX');
                    });
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZYB_SUM"]')[0].setValue(plan_amt_xzyb_sum);
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZZX_SUM"]')[0].setValue(plan_amt_xzzx_sum);
                    totalSum();
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(total_amt+plan_amt_xzzx_sum);
                }
                if (context.field == 'PLAN_AMT_ZHYB' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    // 新增一般债券
                    var plan_amt_zhyb_sum = 0.000000;
                    // 新增专项债券
                    // var plan_amt_zhzx_sum = 0.000000;
                    // 计划发行额
                    var plan_amt_total_sum = 0.000000;
                    self.each(function (record) {
                        plan_amt_zhyb_sum += record.get('PLAN_AMT_ZHYB');
                        // plan_amt_zhzx_sum += record.get('PLAN_AMT_ZHYB');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZHYB_SUM"]')[0].setValue(plan_amt_zhyb_sum);
                    totalSum();
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZZX_SUM"]')[0].setValue(plan_amt_xzzx_sum);
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(plan_amt_zhyb_sum+total_amt);
                }
                // 拨付折合原币计算
                if (context.field == 'PLAN_AMT_ZHZX' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    // 新增一般债券
                    // var plan_amt_xzyb_sum = 0.000000;
                    // 新增专项债券
                    var plan_amt_zhzx_sum = 0.000000;
                    // 计划发行额
                    var plan_amt_total_sum = 0.000000;
                    self.each(function (record) {
                        // plan_amt_xzyb_sum += record.get('PLAN_AMT_ZHZX');
                        plan_amt_zhzx_sum += record.get('PLAN_AMT_ZHZX');
                    });
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZYB_SUM"]')[0].setValue(plan_amt_xzyb_sum);
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZHZX_SUM"]')[0].setValue(plan_amt_zhzx_sum);
                    totalSum();
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(plan_amt_zhzx_sum+total_amt);
                }
                if (context.field == 'PLAN_AMT_ZRZYB' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    // 新增一般债券
                    var plan_amt_zrzyb_sum = 0.000000;
                    // 新增专项债券
                    // var plan_amt_xzzx_sum = 0.000000;
                    // 计划发行额
                    var plan_amt_total_sum = 0.000000;
                    self.each(function (record) {
                        plan_amt_zrzyb_sum += record.get('PLAN_AMT_ZRZYB');
                        // plan_amt_xzzx_sum += record.get('PLAN_AMT_ZX');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZRZYB_SUM"]')[0].setValue(plan_amt_zrzyb_sum);
                    totalSum();
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZZX_SUM"]')[0].setValue(plan_amt_xzzx_sum);
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(plan_amt_zrzyb_sum+total_amt);
                }
                // 拨付折合原币计算
                if (context.field == 'PLAN_AMT_ZRZZX' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    // 新增一般债券
                    // var plan_amt_xzyb_sum = 0.000000;
                    // 新增专项债券
                    var plan_amt_zrzzx_sum = 0.000000;
                    // 计划发行额
                    var plan_amt_total_sum = 0.000000;
                    self.each(function (record) {
                        // plan_amt_xzyb_sum += record.get('PLAN_AMT_YB');
                        plan_amt_zrzzx_sum += record.get('PLAN_AMT_ZRZZX');
                    });
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZYB_SUM"]')[0].setValue(plan_amt_xzyb_sum);
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZRZZX_SUM"]')[0].setValue(plan_amt_zrzzx_sum);
                    totalSum();
                    // Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(total_amt+plan_amt_zrzzx_sum);
                }
                // //拨付折合原币计算
                // if (context.field == 'PLAN_AMT_TOTAL' && context.originalValue != context.value) {
                //     var self = grid.getStore();
                //     //新增债券
                //     var plan_amt_xz_sum = 0.000000;
                //     //再融资债券
                //     var plan_amt_zrz_sum = 0.000000;
                //     //计划发行额
                //     var plan_amt_total_sum = 0.000000;
                //     self.each(function (record) {
                //         if (record.get('ZQLX_ID') == 01) {
                //             plan_amt_xz_sum += record.get('PLAN_AMT_TOTAL');
                //         } else if (record.get('ZQLX_ID') == 03) {
                //             plan_amt_zrz_sum += record.get('PLAN_AMT_TOTAL');
                //         }
                //         plan_amt_total_sum += record.get('PLAN_AMT_TOTAL');
                //     });
                //     Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZ_SUM"]')[0].setValue(plan_amt_xz_sum);
                //     Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZRZ_SUM"]')[0].setValue(plan_amt_zrz_sum);
                //     Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(plan_amt_total_sum);
                // }
            }
        }
    });
    return grid;
}

/**
 * 保存年度发行计划信息
 */
function saveXmtkInfo(self) {
    var form = self.up('window').down('form');
    var formData = form.getForm().getFieldValues();
    var xzndjhDetailStore = DSYGrid.getGrid('xzndjhDetail_grid').getStore();
    if(xzndjhDetailStore.getCount() <= 0){
        Ext.Msg.alert('提示', "明细不能为空！");
        return;
    }
    var store_data = new Array();
    //判断 明细信息
    for (var m = 0; m < xzndjhDetailStore.getCount(); m++) {
        var xzndjhDetailrecord = xzndjhDetailStore.getAt(m);
        var var$ndjh_month = xzndjhDetailrecord.get("NDJH_MONTH");
        var var$plan_amt_yb = xzndjhDetailrecord.get("PLAN_AMT_YB");
        var var$plan_amt_zx = xzndjhDetailrecord.get("PLAN_AMT_ZX");
        var var$plan_amt_zhyb = xzndjhDetailrecord.get("PLAN_AMT_ZHYB");
        var var$plan_amt_zhzx = xzndjhDetailrecord.get("PLAN_AMT_ZHZX");
        var var$plan_amt_zrzyb = xzndjhDetailrecord.get("PLAN_AMT_ZRZYB");
        var var$plan_amt_zrzzx = xzndjhDetailrecord.get("PLAN_AMT_ZRZZX");
        var var$zqlx_id = xzndjhDetailrecord.get("ZQLX_ID");
        var var$zqlb_id = xzndjhDetailrecord.get("ZQLB_ID");

        if (!(var$ndjh_month != null && var$ndjh_month != undefined && var$ndjh_month != "" && var$ndjh_month != 0)) {
            Ext.Msg.alert('提示', "明细中月份不能为空！");
            return;
        }

        // if (!(var$zqlx_id != null && var$zqlx_id != undefined && var$zqlx_id != "" && var$zqlx_id != 0)) {
        //     Ext.Msg.alert('提示', "明细中债券类别不能为空！");
        //     return;
        // }

        // if (!(var$zqlb_id != null && var$zqlb_id != undefined && var$zqlb_id != "" && var$zqlb_id != 0)) {
        //     Ext.Msg.alert('提示', "明细中债券类型不能为空！");
        //     return;
        // }
        /*if (!(var$plan_amt_yb != null && var$plan_amt_yb != undefined && var$plan_amt_yb != "" && var$plan_amt_yb != 0) && !(var$plan_amt_zx != null && var$plan_amt_zx != undefined && var$plan_amt_zx != "" && var$plan_amt_zx != 0)
           &&!(var$plan_amt_zhyb != null && var$plan_amt_zhyb != undefined && var$plan_amt_zhyb != "" && var$plan_amt_zhyb != 0) && !(var$plan_amt_zhzx != null && var$plan_amt_zhzx != undefined && var$plan_amt_zhzx != "" && var$plan_amt_zhzx != 0)
           &&!(var$plan_amt_zrzyb != null && var$plan_amt_zrzyb != undefined && var$plan_amt_zrzyb != "" && var$plan_amt_zrzyb != 0) && !(var$plan_amt_zrzzx != null && var$plan_amt_zrzzx != undefined && var$plan_amt_zrzzx != "" && var$plan_amt_zrzzx != 0)) {
            Ext.Msg.alert('提示', "明细中的新增一般或者新增专项发行额至少录入一项");
            return;
        }*/
        var count =0;
        for (var j = 0; j < xzndjhDetailStore.getCount(); j++) {
            var ndjh_months = xzndjhDetailStore.getAt(j);
            var ndjh_month = ndjh_months.get("NDJH_MONTH");
            if(var$ndjh_month == ndjh_month ){
                count ++;
            }
        }
        if(count>1){
            Ext.Msg.alert('提示', "明细中月份不能相同！");
            return;
        }
        store_data.push(xzndjhDetailrecord.data)
    }

    self.setDisabled(true);
    $.post('saveNdfxjhInfo.action', {
        button_name: button_name,
        NDJH_YEAR: formData.NDJH_YEAR,
        NDJH_ZD_ID: formData.NDJH_ZD_ID,
        PLAN_AMT_XZYB_SUM: formData.PLAN_AMT_XZYB_SUM*100000000,
        PLAN_AMT_XZZX_SUM: formData.PLAN_AMT_XZZX_SUM*100000000,
        NDFXJH_GRID: Ext.util.JSON.encode(store_data)
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

function totalSum() {
    var xzyb_amt = Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZYB_SUM"]')[0].value;
    var xzzx_amt = Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_XZZX_SUM"]')[0].value;
    var zhyb_amt = Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZHYB_SUM"]')[0].value;
    var zhzx_amt = Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZHZX_SUM"]')[0].value;
    var zrzyb_amt = Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZRZYB_SUM"]')[0].value;
    var zrzzx_amt = Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_ZRZZX_SUM"]')[0].value;
    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_AMT_TOTAL_SUM"]')[0].setValue(xzyb_amt+xzzx_amt+zhyb_amt+
        zhzx_amt+zrzyb_amt+zrzzx_amt);

}