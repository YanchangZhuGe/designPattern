//工具栏按钮
var toolbarItems = [
    {
        xtype: 'button',
        text: '查询',
        name: 'search',
        icon: '/image/sysbutton/search.png',
        handler: function () {
            reloadGrid();
        }
    },
    {
        xtype: 'button',
        text: '填报',
        name: 'add',
        id: 'addBtn',
        icon: '/image/sysbutton/add.png',
        handler: function () {
            ysszSave();
        }
    },
    {
        xtype: 'button',
        text: '修改',
        name: 'edit',
        icon: '/image/sysbutton/edit.png',
        handler: function () {
            ysszEdit();
        }
    },
    {
        xtype: 'button',
        text: '删除',
        name: 'delete',
        icon: '/image/sysbutton/delete.png',
        handler: function () {
            ysszRemove();
        }
    }

];

/**
 * 页面初始化
 * @author zyd 2021/11/30
 */
$(document).ready(function () {
    initContent();
});

/**
 * 初始化主界面
 * @return void
 */
function initContent() {
    // 创建主面板
    Ext.create('Ext.panel.Panel', {
        renderTo: Ext.getBody(),
        layout: 'border',
        defaults: {
            split: true,// 是否有分割线
            collapsible: false// 是否可以折叠
        },
        width: '100%',
        height: '100%',
        border: 'true',
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: toolbarItems // 操作按钮
            }
        ],
        items: [
            initCzszTable()

        ]
    });
}

/**
 * 政府性基金预算收支详情表格-初始化方法
 * @return Ext.form.Panel
 */
function initCzszTable() {
    var headerJson = [
        {xtype: 'rownumberer', width: 50},
        {dataIndex: "AD_CODE", type: "string", text: "地区编码", align: "left", width: 80, hidden: true},
        {dataIndex: "AD_NAME", type: "string", text: "地区", align: "left", width: 80},
        {dataIndex: "SET_YEAR", type: "string", text: "年度", align: "left", width: 80},
        {
            dataIndex: "SR", type: "float", text: "收入(亿元)",
            columns: [
                {
                    dataIndex: "JJSR_AMT", type: "string", text: "政府性基金收入", align: "center", width: 200,
                    columns: [
                        {
                            dataIndex: "TDSR_AMT",
                            type: "string",
                            text: "国有土地使用权出让收入",
                            align: "center",
                            width: 180,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        },
                        {
                            dataIndex: "TXFSR_AMT", type: "string", text: "车辆通行费收入", align: "center", width: 130,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        },
                        {
                            dataIndex: "SSSR_AMT", type: "string", text: "城市基础设施配套费收入", align: "center", width: 180,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        },
                        {
                            dataIndex: "FJSR_AMT", type: "string", text: "城市公用事业附加收入", align: "center", width: 180,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        }]
                }, {
                    dataIndex: "BZSR_AMT", type: "string", text: "上级补助收入", align: "center", width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.########');
                    },
                },
                {
                    dataIndex: "ZQSR_AMT", type: "string", text: "地方政府专项债券收入", align: "center", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.########');
                    },
                }
            ]
        },
        {
            dataIndex: "ZC", type: "float", text: "支出(亿元)",
            columns: [
                {
                    dataIndex: "JJZC_AMT", type: "string", text: "政府性基金支出", align: "center", width: 200,
                    columns: [
                        {
                            dataIndex: "TDZC_AMT",
                            type: "string",
                            text: "国有土地使用权出让支出",
                            align: "center",
                            width: 180,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        },
                        {
                            dataIndex: "TXFZC_AMT", type: "string", text: "车辆通行费支出", align: "center", width: 130,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        },
                        {
                            dataIndex: "SSZC_AMT", type: "string", text: "城市基础设施配套费支出", align: "center", width: 180,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        },
                        {
                            dataIndex: "FJZC_AMT", type: "string", text: "城市公用事业附加相关支出", align: "center", width: 180,
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.########');
                            },
                        }]
                }, {
                    dataIndex: "XJZC_AMT", type: "string", text: "补助下级支出", align: "center", width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.########');
                    },
                },
                {
                    dataIndex: "ZQZC_AMT", type: "string", text: "地方政府专项债券还本支出", align: "center", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.########');
                    },
                }
            ]
        },
    ];
    var detailTable = DSYGrid.createGrid({
        itemId: 'ysszGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        params: {
            optYear: SET_YEAR,
        },
        rowNumber: true,
        border: false,
        autoLoad: true,
        height: '100%',
        width: '100%',
        checkBox: true,
        flex: 1,
        dataUrl: '/jjyssz/getGrid.action',
        tbar: [
            {
                xtype: "combobox",
                fieldLabel: "年度",
                name: "SET_YEAR",
                id: "SET_YEAR",
                editable: false,
                displayField: 'name',
                labelAlign: "left",
                width: 200,
                labelWidth: 65,
                valueField: 'code',
                allowBlank: true,//允许为空
                value: SET_YEAR,
                enableKeyEvents: true,
                store: DebtEleStore(getYearList({start: -5, end: 5})),
                listeners: {
                    keypress: function (self, e) {
                        //Enter点击事件
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            //刷新表格
                            reloadGrid();
                        }
                    },
                    change: function (self, newValue) {
                        // 根据年度变化，刷新表格
                        SET_YEAR = newValue;
                        reloadGrid();
                    }
                }
            }

        ],
        pageConfig: {
            pageNum: true,// 设置显示每页条数
            pageSize: 100
        }
    });
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {//布局
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        items: [
            detailTable
        ]
    });
}

/**
 * 政府性基金预算收支填报
 * @return void
 */
function ysszSave() {
    Ext.create('Ext.window.Window', {
        title: "政府性基金预算收支情况填报窗口",// 窗口标题
        width: document.body.clientWidth * 0.50, // 窗口宽度
        height: document.body.clientHeight * 0.65, // 窗口高度
        layout: 'fit',
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',// hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: jjsztbForm(),
        buttons: [
            {
                xtype: 'button',
                text: '保存',
                handler: function (self) {
                    var form = self.up('window').down('form');
                    var formData = form.getForm().getFieldValues();
                    if (formData['JJSR_AMT'] < (formData['TDSR_AMT'] + formData['TXFSR_AMT'] + formData['SSSR_AMT'] + formData['FJSR_AMT'])) {
                        Ext.toast({
                            html: "政府性基金收入要大于等于国有土地使用权出让收入、车辆通行费收入、城市基础设施配套费收入和城市公用事业附加收入的和！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                    if (formData['JJZC_AMT'] < (formData['TDZC_AMT'] + formData['TXFZC_AMT'] + formData['SSZC_AMT'] + formData['FJZC_AMT'])) {
                        Ext.toast({
                            html: "政府性基金支出要大于等于国有土地使用权出让支出、车辆通行费支出、城市基础设施配套费支出和城市公用事业附加相关支出的和！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                    if (form.isValid()) {
                        self.setDisabled(true);
                        formData = $.extend(formData, form.getValues());//合并
                        $.post('/jjyssz/saveYssz.action', {
                            detailForm: Ext.util.JSON.encode([formData])
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "保存成功",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                self.up('window').close();
                                // 刷新表格
                                reloadGrid();
                            } else {
                                Ext.MessageBox.alert('提示', '保存失败!<br>' + data.message);
                                self.setDisabled(false);
                            }
                        }, 'JSON');
                    }
                }
            },
            {
                xtype: 'button',
                text: '取消',
                handler: function (self) {
                    self.up('window').close();
                }
            }
        ]
    }).show();
}

/**
 * 刷新表单
 * @return void
 */
function reloadGrid() {
    var SET_YEAR = Ext.getCmp('SET_YEAR').getValue();
    var extraParams = {
        optYear: SET_YEAR
    }
    var store = DSYGrid.getGrid('ysszGrid').getStore();
    store.getProxy().extraParams = extraParams;
    store.loadPage(1);
};

/**
 * 政府性基金预算收支情况修改窗口
 * @return Ext.form.Panel
 */
function ysszEdit() {
    var record = DSYGrid.getGrid('ysszGrid').getSelectionModel().getSelection();
    if (!record || record.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
        return;
    }
    Ext.create('Ext.window.Window', {
        title: "政府性基金预算收支情况修改窗口",// 窗口标题
        width: document.body.clientWidth * 0.50, // 窗口宽度
        height: document.body.clientHeight * 0.65, // 窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',// hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: jjszxgForm(),
        buttons: [
            {
                xtype: 'button',
                text: '保存',
                handler: function (self) {
                    var form = self.up('window').down('form');
                    var formData = form.getForm().getFieldValues();
                    if (formData['JJSR_AMT'] < (formData['TDSR_AMT'] + formData['TXFSR_AMT'] + formData['SSSR_AMT'] + formData['FJSR_AMT'])) {
                        Ext.toast({
                            html: "政府性基金收入要大于等于国有土地使用权出让收入、车辆通行费收入、城市基础设施配套费收入和城市公用事业附加收入的和！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                    if (formData['JJZC_AMT'] < (formData['TDZC_AMT'] + formData['TXFZC_AMT'] + formData['SSZC_AMT'] + formData['FJZC_AMT'])) {
                        Ext.toast({
                            html: "政府性基金支出要大于等于国有土地使用权出让支出、车辆通行费支出、城市基础设施配套费支出和城市公用事业附加相关支出的和！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                    if (form.isValid()) {
                        self.setDisabled(true);
                        formData = $.extend({}, formData, form.getValues());
                        $.post('/jjyssz/editYssz.action', {
                            detailForm: Ext.util.JSON.encode([formData])
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "修改成功",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                self.up('window').close();
                                // 刷新表格
                                reloadGrid();
                            } else {
                                Ext.MessageBox.alert('提示', '修改失败!</br>' + data.message);
                                self.setDisabled(false);
                            }
                        }, 'JSON');
                    }
                }
            },
            {
                xtype: 'button',
                text: '取消',
                handler: function (self) {
                    self.up('window').close();
                }
            }
        ]
    }).show();
}

/**
 * 政府性基金预算收支删除表单
 * @return Ext.form.Panel
 */
function ysszRemove() {
    var record = DSYGrid.getGrid('ysszGrid').getSelectionModel().getSelection();
    if (!record || record.length < 1) {
        Ext.MessageBox.alert('提示', '请至少选择一条数据进行操作');
        return;
    }
    var adCodes = [];//选中adcode的数组
    var years = [];//选中setyear的数组
    for (var i = 0; i < record.length; i++) {
        adCodes.push(record[i].get('AD_CODE'))
        years.push(record[i].get('SET_YEAR'))
    }
    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            // 发送ajax请求，删除数据
            $.post('/jjyssz/removeYssz.action', {
                "adCodes": adCodes,
                "years": years
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: "删除成功",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    // 刷新表格
                    reloadGrid();
                } else {
                    Ext.MessageBox.alert('提示', '删除失败' + data.message);
                }
            }, "json");
        }
    });
}

/**
 * 政府性基金预算收支增加表单
 * @return Ext.form.Panel
 */
function jjsztbForm() {
    var form = Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'border',
        border: false,
        collapsible: false,
        frame: false,
        defaults: {
            collapsible: false,
        },
        items: [{
            region: 'north',
            border: false,
            collapsible: false,
            layout: 'column',
            height: '30px',
            width: '100%',
            defaults: {
                labelWidth: 50,
                columnWidth: .50,
                margin: '5 10 5 10',
                labelStyle: 'text-align:center'
            },
            items: [
                {
                    fieldLabel: '<span class="required">✶</span>地区',
                    xtype: 'combobox',
                    displayField: 'name',//输入框的值
                    valueField: 'id',//value值
                    allowBlank: false,//允许为空
                    editable: false,//禁用编辑
                    name: 'adAndName',
                    /**
                     * 省显示省和省本级；计划单列市显示计划单列市和市本级
                     * author:zyd
                     */
                    store: AD_CODE.length < 3 ? DebtEleTreeStoreDBTable("DSY_V_ELE_AD", {condition: " AND  LEVELNO = 2 OR (LEVELNO = 3 AND CODE LIKE '%00')"}) : DebtEleTreeStoreDBTable("DSY_V_ELE_AD", {condition: " AND CODE IN ('2102','210200','3302','330200','3502','350200','3702','370200','4403','440300') "}),
                }, {
                    fieldLabel: '<span class="required">✶</span>年度',
                    name: 'SET_YEAR',
                    xtype: 'combobox',
                    editable: false,
                    value: SET_YEAR,
                    allowBlank: false,//允许为空
                    displayField: 'name',//输入框的值
                    valueField: 'id',//value值
                    store: DebtEleStore(getYearList({start: -5, end: 5}))
                }]
        }, {
            region: 'west',
            layout: 'form',
            split: false,
            border: true,
            collapsible: false,
            height: '90%',
            width: '50%',
            defaultType: 'textfield',
            autoScroll: true,
            tbar: [{
                xtype: 'tbtext',
                text: '收入'
            }, '->', {
                xtype: 'tbtext',
                text: "单位:亿元"
            }],
            items: [{
                fieldLabel: '政府性基金收入',
                xtype: "numberFieldFormat",
                name: 'JJSR_AMT',
                id: 'JJSR_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '国有土地使用权出让收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TDSR_AMT',
                id: 'TDSR_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '车辆通行费收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TXFSR_AMT',
                id: 'TXFSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '城市基础设施配套费收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'SSSR_AMT',
                id: 'SSSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '城市公用事业附加收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'FJSR_AMT',
                id: 'FJSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '上级补助收入',
                xtype: "numberFieldFormat",
                name: 'BZSR_AMT',
                id: 'BZSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
                numberFormat: true,
            }, {
                fieldLabel: '地方政府专项债券收入',
                xtype: "numberFieldFormat",
                name: 'ZQSR_AMT',
                id: 'ZQSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
            }]
        }, {
            region: 'east',
            layout: 'form',
            split: false,
            border: true,
            collapsible: false,
            width: '50%',
            height: '80%',
            autoScroll: true,
            formDefaults: {
                labelWidth: 150,
                columnWidth: .50,
                margin: '20 10 10 10',
                labelStyle: 'text-align:center'
            },
            tbar: [{
                xtype: 'tbtext',
                text: '支出'
            }, '->', {
                xtype: 'tbtext',
                text: "单位:亿元"
            }],
            items: [{
                fieldLabel: '政府性基金支出',
                xtype: "numberFieldFormat",
                name: 'JJZC_AMT',
                id: 'JJZC_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '国有土地使用权出让支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TDZC_AMT',
                id: 'TDZC_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '车辆通行费支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TXFZC_AMT',
                id: 'TXFZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '城市基础设施配套费支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'SSZC_AMT',
                id: 'SSZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '城市公用事业附加相关支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'FJZC_AMT',
                id: 'FJZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
            }, {
                fieldLabel: '补助下级支出',
                xtype: "numberFieldFormat",
                name: 'XJZC_AMT',
                id: 'XJZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
                numberFormat: true,
            }, {
                fieldLabel: '地方政府专项债券还本支出',
                xtype: "numberFieldFormat",
                name: 'ZQZC_AMT',
                id: 'ZQZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
            }]
        }],
    })
    return form;
}

/**
 * 政府性基金预算收支修改表单
 * @return Ext.form.Panel
 */
function jjszxgForm() {
    var record = DSYGrid.getGrid('ysszGrid').getSelectionModel().getSelection();
    var form = Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        autoScroll: true,
        layout: 'border',
        border: false,
        collapsible: false,
        frame: false,
        defaults: {
            collapsible: false,
        },

        items: [{
            region: 'north',
            border: false,
            collapsible: false,
            layout: 'column',
            height: '30px',
            width: '100%',
            defaults: {
                labelWidth: 50,
                columnWidth: .50,
                margin: '5 10 5 10',
                labelStyle: 'text-align:center'
            },
            items: [
                {
                    fieldLabel: '地区编码',
                    name: 'AD_CODE',
                    id: 'AD_CODE',
                    xtype: 'textfield',
                    value: record[0].get('AD_CODE'),
                    hidden: true
                }, {
                    fieldLabel: '<span class="required">✶</span>地区',
                    name: 'adAndName',
                    xtype: 'textfield',
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    value: record[0].get('AD_NAME')
                }, {
                    fieldLabel: '<span class="required">✶</span>年度',
                    name: 'SET_YEAR',
                    xtype: 'textfield',
                    allowBlank: false,//允许为空
                    value: record[0].get('SET_YEAR'),
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                }]

        }, {
            region: 'west',
            layout: 'form',
            split: false,
            border: true,
            collapsible: false,
            height: '90%',
            width: '50%',
            defaultType: 'textfield',
            autoScroll: true,
            tbar: [{
                xtype: 'tbtext',
                text: '收入'
            }, '->', {
                xtype: 'tbtext',
                text: "单位:亿元"
            }],
            items: [{
                fieldLabel: '政府性基金收入',
                xtype: "numberFieldFormat",
                name: 'JJSR_AMT',
                id: 'JJSR_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('JJSR_AMT'),
            }, {
                fieldLabel: '国有土地使用权出让收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TDSR_AMT',
                id: 'TDSR_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('TDSR_AMT'),
            }, {
                fieldLabel: '车辆通行费收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TXFSR_AMT',
                id: 'TXFSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('TXFSR_AMT'),
            }, {
                fieldLabel: '城市基础设施配套费收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'SSSR_AMT',
                id: 'SSSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('SSSR_AMT'),
            }, {
                fieldLabel: '城市公用事业附加收入',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'FJSR_AMT',
                id: 'FJSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('FJSR_AMT'),
            }, {
                fieldLabel: '上级补助收入',
                xtype: "numberFieldFormat",
                name: 'BZSR_AMT',
                id: 'BZSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
                numberFormat: true,
                value: record[0].get('BZSR_AMT'),
            }, {
                fieldLabel: '地方政府专项债券收入',
                xtype: "numberFieldFormat",
                name: 'ZQSR_AMT',
                id: 'ZQSR_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('ZQSR_AMT'),
            }]
        }, {
            region: 'east',
            layout: 'form',
            split: false,
            border: true,
            collapsible: false,
            width: '50%',
            height: '80%',
            autoScroll: true,
            formDefaults: {
                labelWidth: 150,
                columnWidth: .50,
                margin: '20 10 10 10',
                labelStyle: 'text-align:center'
            },
            tbar: [{
                xtype: 'tbtext',
                text: '支出'
            }, '->', {
                xtype: 'tbtext',
                text: "单位:亿元"
            }],
            items: [{
                fieldLabel: '政府性基金支出',
                xtype: "numberFieldFormat",
                name: 'JJZC_AMT',
                id: 'JJZC_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('JJZC_AMT'),
            }, {
                fieldLabel: '国有土地使用权出让支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TDZC_AMT',
                id: 'TDZC_AMT',
                maxValue: 999999,
                minValue: 0,
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('TDZC_AMT'),
            }, {
                fieldLabel: '车辆通行费支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'TXFZC_AMT',
                id: 'TXFZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('TXFZC_AMT'),
            }, {
                fieldLabel: '城市基础设施配套费支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'SSZC_AMT',
                id: 'SSZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('SSZC_AMT'),
            }, {
                fieldLabel: '城市公用事业附加相关支出',
                xtype: "numberFieldFormat",
                labelStyle: 'text-indent:1em',
                name: 'FJZC_AMT',
                id: 'FJZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                numberFormat: true,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('FJZC_AMT'),
            }, {
                fieldLabel: '补助下级支出',
                xtype: "numberFieldFormat",
                name: 'XJZC_AMT',
                id: 'XJZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
                numberFormat: true,
                value: record[0].get('XJZC_AMT'),
            }, {
                fieldLabel: '地方政府专项债券还本支出',
                xtype: "numberFieldFormat",
                name: 'ZQZC_AMT',
                id: 'ZQZC_AMT',
                hideTrigger: true,
                maxValue: 999999,
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 8,
                value: record[0].get('ZQZC_AMT'),
            }]
        }],
    })
    return form;
}
