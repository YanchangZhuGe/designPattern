var km_year = now_date.substr(0, 4); //当前年份
var km_condition = km_year <= 2017 ? " <= '2017' " : " = '" + km_year + "' ";
var gnfl_store = DebtEleTreeStoreDB('EXPFUNC', {condition: "and year " + km_condition}); //功能分类store
var jjfl_store = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition}); //经济分类store
/**
 * 主页面工具栏
 */
$.extend(bmzc_json_common, {
    button_items: {
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
                name: 'INSERT',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    initChooseZqxxWindow(btn).show();
                    btn.setDisabled(false);
                    loadChooseZqxxGrid();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    updateBmzcInfo(btn);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    deleteBmzcInfo(btn);
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'send',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed()
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
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed()
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
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    updateBmzcInfo(btn);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    deleteBmzcInfo(btn);
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'send',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed()
        ],
        '008': [
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
                text: '操作记录',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed()
        ]
    },
    status_store: DebtEleStore(json_debt_zt1)
});

/**
 * 加载支出单编码
 */
function loadZcdCode(record, b_btn, btn) {
    $.post("/zqgl/bmzc/getZcdCode.action", function (data) {
        if (data.success) {
            var zcdId = GUID.createGUID();
            var zcdCode = data.ZCD_CODE;
            initBmzcWindow(b_btn, zcdId).show();
            var zqxxForm = Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0].getForm();
            zqxxForm.setValues($.extend({
                AD_NAME: AD_NAME,
                ZCD_ID: zcdId,
                ZCD_CODE: zcdCode,
                ZC_TYPE: 0,
                ZCLX_NAME: '新增债券支出',
                ZCD_LR_USER: USER_NAME
            }, record.getData()));
            btn.up('window').close();
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, "json");
}

/**
 * 选择债券信息window
 */
function initChooseZqxxWindow(b_btn) {
    return Ext.create('Ext.window.Window', {
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        title: '请选择债券信息',
        itemId: 'chooseZqxxWindow',
        layout: 'fit',
        modal: true,
        maximizable: true,
        closeAction: 'destroy',
        items: [initChooseZqxxGrid()],
        buttons: [
            {
                xtype: 'button',
                text: '确定',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var record = DSYGrid.getGrid('chooseZqxxGrid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条记录');
                        btn.setDisabled(false);
                        return;
                    }
                    loadZcdCode(record, b_btn, btn);
                }
            },
            {
                xtype: 'button',
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 70, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '债券类别',
                        displayField: 'name',
                        valueField: 'id',
                        name: 'CHOOSE_ZQLX_ID',
                        store: zqlb_store,
                        editable: false,
                        labelWidth: 70,
                        width: 300,
                        labelAlign: 'right',
                        listeners: {
                            select: function (self, newValue) {
                                loadChooseZqxxGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: 'CHOOSE_MHCX',
                        name: 'CHOOSE_MHCX',
                        labelWidth: 60,
                        columnWidth: .40,
                        emptyText: '输入债券名称/债券简称/债券编码',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: function (self, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    loadChooseZqxxGrid();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        handler: function () {
                            loadChooseZqxxGrid();
                        }
                    }
                ]
            }
        ]
    });
}

/**
 * 选择债券信息表格
 */
function initChooseZqxxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "ZQ_NAME", type: "string", text: "债券名称", width: 200},
        {
            dataIndex: "SJZC_AMT", type: "float", text: "上级支出金额（元）", width: 165,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "YZC_AMT", type: "float", text: "已支出金额（元）", width: 165,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "KZC_AMT", type: "float", text: "剩余可支出金额（元）", width: 165,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "TOTAL_AMT", type: "float", text: "债券总额（元）", width: 165,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "已转贷金额（元）", width: 165,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {dataIndex: "ZQLB_NAME", type: "string", text: "债券类型", width: 150},
        {dataIndex: "ZQ_JC", type: "string", text: "债券简称", width: 150},
        {dataIndex: "ZQ_CODE", type: "string", text: "债券编码", width: 150}
    ];
    return DSYGrid.createGrid({
        itemId: 'chooseZqxxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"
        },
        dataUrl: '/zqgl/bmzc/getZqxxList.action',
        autoLoad: false,
        checkBox: false,
        border: false,
        height: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 * 选择项目信息window
 */
function initChooseXmxxWindow() {
    return Ext.create('Ext.window.Window', {
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        title: '请选择债券项目信息',
        itemId: 'chooseXmxxWindow',
        layout: 'fit',
        modal: true,
        maximizable: true,
        closeAction: 'destroy',
        items: initChooseXmxxGrid(),
        buttons: [
            {
                xtype: 'button',
                text: '确定',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var records = DSYGrid.getGrid('chooseXmxxGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录');
                        btn.setDisabled(false);
                        return;
                    }
                    var xmxxData = [];
                    for (var i in records) {
                        xmxxData.push($.extend({
                            PAY_DATE: now_date,
                            PAY_AMT: records[i].get('KZC_AMT'),
                            ZX_ZBJ_AMT: records[i].get('KZC_ZX_ZBJ_AMT'),
                            XZCZAP_AMT: records[i].get('KZC_XZCZAP_AMT')
                        }, records[i].getData()));
                    }
                    var xmxxGrid = DSYGrid.getGrid('bmzcWindow_xmxx_grid');
                    xmxxGrid.insertData(null, xmxxData);
                    //计算支出总额
                    var sumPayAmt = xmxxGrid.getStore().sum('PAY_AMT');
                    Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0].getForm().findField('ZC_TOTAL_AMT').setValue(sumPayAmt);
                    btn.up('window').close();
                }
            },
            {
                xtype: 'button',
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 70, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '项目类型',
                        displayField: 'name',
                        valueField: 'id',
                        name: 'CHOOSE_XMLX_ID',
                        store: DebtEleTreeStoreDB('DEBT_ZWXMLX'),
                        editable: false,
                        labelWidth: 70,
                        width: 350,
                        labelAlign: 'right',
                        listeners: {
                            select: function (self, newValue) {
                                loadChooseXmxxGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: 'CHOOSE_MHCX',
                        name: 'CHOOSE_MHCX',
                        labelWidth: 60,
                        columnWidth: .40,
                        emptyText: '输入项目名称/项目编码/项目（管理）使用单位',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: function (self, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    loadChooseXmxxGrid();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        handler: function () {
                            loadChooseXmxxGrid();
                        }
                    }
                ]
            }
        ]
    });
}

/**
 * 选择项目信息表格
 */
function initChooseXmxxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "AD_CODE", type: "string", text: "区划编码", width: 150, hidden: true},
        {dataIndex: "AG_CODE", type: "string", text: "单位编码", width: 150, hidden: true},
        {dataIndex: "AG_ID", type: "string", text: "单位ID", width: 150, hidden: true},
        {dataIndex: "AG_NAME", type: "string", text: "单位名称", width: 200},
        {
            dataIndex: "XM_NAME", type: "string", text: "项目名称", width: 200,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            text: "上级支出金额(元)", dataIndex: "SJZC_AMT", type: "float", width: 150,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "已支出金额(元)", dataIndex: "YZC_AMT", type: "float", width: 150,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "剩余可支出金额(元)", dataIndex: "KZC_AMT", type: "float", width: 150,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {dataIndex: "ZBWJ_CODE", type: "string", text: "指标文号", width: 150},
        {dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 150},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度", width: 90},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 150},
        {dataIndex: "START_DATE_ACTUAL", type: "string", text: "开工日期", width: 100},
        {dataIndex: "END_DATE_ACTUAL", type: "string", text: "竣工日期", width: 100},
        {dataIndex: "JSZT_NAME", type: "string", text: "建设状态", width: 90},
        {dataIndex: "USE_UNIT_ID", type: "string", text: "管理（使用）单位", width: 150},
        {
            text: '项目总概算(元)', dataIndex: 'XMZGS_AMT', type: 'float', width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {dataIndex: "REMARK", type: "string", text: "备注", width: 150}
    ];
    return DSYGrid.createGrid({
        itemId: 'chooseXmxxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/zqgl/bmzc/getXmxxList.action',
        autoLoad: false,
        checkBox: true,
        border: false,
        height: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 * 部门支出window
 */
function initBmzcWindow(b_btn, zcdId) {
    return Ext.create('Ext.window.Window', {
        title: '债券支出',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        layout: 'fit',
        itemId: 'bmzcWindow',
        buttonAlign: 'right',
        maximizable: true,
        frame: true,
        constrain: true,
        modal: true,
        closeAction: 'destroy',
        items: [
            {
                xtype: 'tabpanel',
                flex: 1,
                items: [
                    {
                        title: '单据',
                        name: 'ZCD',
                        layout: 'vbox',
                        items: [
                            {
                                xtype: 'container',
                                width: '100%',
                                layout: 'anchor',
                                margin: "5 0 0 0",
                                items: [
                                    {
                                        xtype: 'label',
                                        text: '单位:元',
                                        width: 70,
                                        cls: "label-color",
                                        style: {'float': 'right', 'color': 'red'}
                                    }
                                ]
                            },
                            initBmzcWindow_zqxx_form(),
                            initBmzcWindow_xmxx_grid()
                        ]
                    },
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        name: 'FILE',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'bmzcWindow_file_panel',
                                items: [initBmzcWindow_file_grid(zcdId)]
                            }
                        ]
                    }
                ],
                listeners: {
                    beforetabchange: function (tabPanel, newCard, oldCard) {
                        tabPanel.up('window').down('button[name="ADD"]').setHidden(newCard.name == 'FILE');
                        tabPanel.up('window').down('button[name="REMOVE"]').setHidden(newCard.name == 'FILE');
                    }
                }
            }
        ],
        buttons: [
            {
                text: '增加', name: 'ADD', xtype: 'button', width: 80,
                handler: function (btn) {
                    btn.setDisabled(true);
                    initChooseXmxxWindow().show();
                    loadChooseXmxxGrid();
                    btn.setDisabled(false);
                }
            },
            {
                text: '删除', name: 'REMOVE', xtype: 'button', width: 80, disabled: true,
                handler: function (btn) {
                    var grid = btn.up('window').down('grid#bmzcWindow_xmxx_grid');
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
                handler: function (btn) {
                    btn.setDisabled(true);
                    saveBmzcInfo(b_btn, btn);
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
 * 部门支出窗口中上面form表单
 */
function initBmzcWindow_zqxx_form() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'bmzcWindow_zqxx_form',
        width: '100%',
        layout: 'column',
        border: false,
        defaults: {
            columnWidth: .33,
            margin: '2 5 2 5',
            labelWidth: 100
        },
        margin: '0 0 5 0',
        defaultType: 'textfield',
        items: [
            {fieldLabel: '地区', name: 'AD_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券ID', name: 'ZQ_ID', readOnly: true, fieldCls: 'form-unedit', hidden: true},
            {fieldLabel: '债券名称', name: 'ZQ_NAME', xtype: 'displayfield', columnWidth: .66, readOnly: true},
            {fieldLabel: '支出类型ID', name: 'ZC_TYPE', readOnly: true, fieldCls: 'form-unedit', hidden: true},
            {fieldLabel: '支出类型', name: 'ZCLX_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券类型ID', name: 'ZQLB_ID', readOnly: true, fieldCls: 'form-unedit', hidden: true},
            {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '期限', name: 'ZQQX_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {
                xtype: "numberFieldFormat",
                name: "TOTAL_AMT",
                fieldLabel: '债券总额',
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: true,
                readOnly: true,
                fieldCls: 'form-unedit-number',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                name: "SJZC_AMT",
                fieldLabel: '上级支出金额',
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: true,
                readOnly: true,
                fieldCls: 'form-unedit-number',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                name: "KZC_AMT",
                fieldLabel: '剩余可支出金额',
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: true,
                readOnly: true,
                fieldCls: 'form-unedit-number',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
            {fieldLabel: "单据ID", name: "ZCD_ID", hidden: true},
            {fieldLabel: "单据编号", name: "ZCD_CODE", readOnly: true, fieldCls: 'form-unedit'},
            {
                xtype: "numberFieldFormat",
                name: "ZC_TOTAL_AMT",
                fieldLabel: '支出总额',
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true,
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: true,
                readOnly: true,
                fieldCls: 'form-unedit-number',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {fieldLabel: "录入人", name: "ZCD_LR_USER", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: "备注", name: "ZCD_REMARK", columnWidth: .99}
        ]
    });
}

/**
 * 部门支出窗口中下面项目信息表格
 */
function initBmzcWindow_xmxx_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "区划编码", dataIndex: "AD_CODE", type: 'string', tdCls: 'grid-cell-unedit', width: 180, hidden: true},
        {text: "单位编码", dataIndex: "AG_CODE", type: 'string', tdCls: 'grid-cell-unedit', width: 180, hidden: true},
        {text: "单位ID", dataIndex: "AG_ID", type: 'string', tdCls: 'grid-cell-unedit', width: 180, hidden: true},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 250, tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            text: "上级支出金额（元）", dataIndex: "SJZC_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "剩余可支出金额（元）", dataIndex: "KZC_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "支出日期", dataIndex: "PAY_DATE", type: "string", tdCls: 'grid-cell', headerMark: 'star',
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d',
                maxValue: now_date,
                listeners: {
                    change: function (self, newValue, oldValue) {
                        var newYear = dsyDateFormat(newValue).substr(0, 4);
                        var oldYear = dsyDateFormat(oldValue).substr(0, 4);
                        if (newYear != oldYear && newYear != km_year) {
                            Ext.MessageBox.wait('正在获取新年度功能分类、经济分类数据..', '请等待..');
                            DSYGrid.getGrid('window_save_zcxx_grid').getStore().each(function (record) {
                                record.set('GNFL_ID', '');
                                record.set('JJFL_ID', '');
                                return;
                            });
                            km_year = newYear;
                            var condition_str = km_year <= 2017 ? " <= '2017' " : " = '" + km_year + "' ";
                            gnfl_store.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                            jjfl_store.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                            gnfl_store.load({
                                callback: function () {
                                    jjfl_store.load({
                                        callback: function () {
                                            Ext.MessageBox.hide();
                                        }
                                    });
                                }
                            });
                        }
                    }
                }
            }
        },
        {
            text: "本次支出金额（元）", dataIndex: "PAY_AMT", type: "float", width: 150, tdCls: 'grid-cell', headerMark: 'star',
            editor: {
                xtype: 'numberfield',
                mouseWheelEnabled: false,
                hideTrigger: true,
                minValue: 0,
                maxValue: 9999999999,
                decimalPrecision: 2
            },
            renderer: function (value, metaData, record) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "剩余可支出专项债用作资本金总额（元）",
            dataIndex: "KZC_ZX_ZBJ_AMT",
            type: "float",
            tdCls: 'grid-cell-unedit',
            width: 150,
            hidden: true,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "专项债用作资本金总额（元）", dataIndex: "ZX_ZBJ_AMT", type: "float", width: 150,
            renderer: function (value, meta, record) {
                var zcForm = Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0];
                var zqlbId = zcForm.getForm().findField('ZQLB_ID').getValue();
                if (record.get('IS_EXIST_ZQXM') == 1 && zqlbId != '01') {
                    meta.tdCls = 'grid-cell';
                    meta.column.editor = {
                        xtype: 'numberfield',
                        mouseWheelEnabled: false,
                        hideTrigger: true,
                        minValue: 0,
                        maxValue: 9999999999,
                        decimalPrecision: 2
                    };
                } else {
                    meta.tdCls = 'grid-cell-unedit';
                }
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "剩余可支出其中:新增赤字（元）",
            dataIndex: "KZC_XZCZAP_AMT",
            type: "float",
            tdCls: 'grid-cell-unedit',
            width: 150,
            hidden: true,
            renderer: function (value, meta) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "其中:新增赤字（元）", dataIndex: "XZCZAP_AMT", type: "float", width: 150,
            renderer: function (value, meta, record) {
                var zqxxForm = Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0];
                var zqlbId = zqxxForm.getForm().findField('ZQLB_ID').getValue();
                if (record.get('IS_EXIST_ZQXM') == 1 && zqlbId == '01') {
                    meta.tdCls = 'grid-cell';
                    meta.column.editor = {
                        xtype: 'numberfield',
                        mouseWheelEnabled: false,
                        hideTrigger: true,
                        minValue: 0,
                        maxValue: 9999999999,
                        decimalPrecision: 2
                    };
                } else {
                    meta.tdCls = 'grid-cell-unedit';
                }
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "功能分类", dataIndex: "GNFL_ID", type: "string", tdCls: 'grid-cell', width: 200, headerMark: 'star',
            editor: {
                xtype: 'treecombobox',
                valueField: 'id',
                displayField: 'name',
                editable: false,
                selectModel: 'leaf',
                rootVisible: false,
                lines: false,
                store: gnfl_store,
                minPicekerWidth: 300
            },
            renderer: function (value) {
                var record = gnfl_store.findNode('id', value, true, true, true);
                return record != null ? record.get('name') : "";
            }
        },
        {
            text: "经济分类", dataIndex: "JJFL_ID", type: "string", tdCls: 'grid-cell', width: 200, headerMark: 'star',
            editor: {
                xtype: 'treecombobox',
                valueField: 'id',
                displayField: 'name',
                editable: false,
                selectModel: 'leaf',
                rootVisible: false,
                lines: false,
                store: jjfl_store,
                minPicekerWidth: 300
            },
            renderer: function (value) {
                var record = jjfl_store.findNode('id', value, true, true, true);
                return record != null ? record.get('name') : "";
            }
        },
        {text: "项目ID", dataIndex: "XMLX_ID", type: 'string', tdCls: 'grid-cell-unedit', width: 180, hidden: true},
        {text: "项目类型", dataIndex: "XMLX_NAME", type: 'string', tdCls: 'grid-cell-unedit', width: 150},
        {
            text: '项目总概算(元)', dataIndex: 'XMZGS_AMT', type: 'float', tdCls: 'grid-cell-unedit', width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {text: "部门支出ID", dataIndex: "BM_ZC_ID", type: 'string', tdCls: 'grid-cell-unedit', width: 180, hidden: false}
    ];
    return DSYGrid.createGrid({
        itemId: 'bmzcWindow_xmxx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        autoLoad: false,
        checkBox: true,
        border: false,
        height: '100%',
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'bmzcWindow_xmxx_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    validateedit: function (editor, context) {

                    },
                    edit: function (editor, context) {
                        if (context.field == 'PAY_DATE') {
                            context.record.set(context.field, Ext.util.Format.date(context.value, 'Y-m-d'));
                        }
                    },
                    beforeedit: function (editor, context) {

                    },
                    afteredit: function (editor, context) {
                        if (context.field == 'PAY_AMT') {
                            var sumPayAmt = DSYGrid.getGrid("bmzcWindow_xmxx_grid").getStore().sum('PAY_AMT');
                            var zqxxForm = Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0].getForm();
                            zqxxForm.findField('ZC_TOTAL_AMT').setValue(sumPayAmt);
                        }
                    }
                }
            }
        ],
        listeners: {
            afterrender: function (grid) {
                var columns = grid.columns;
                for (var i = 0; i < columns.length; i++) {
                    columns[i].getEl().dom.children[0].children[0].children[0].children[0].style.whiteSpace = "normal";
                }
            },
            selectionchange: function (self, records) {
                Ext.ComponentQuery.query('window#bmzcWindow')[0].down('button[name="REMOVE"]').setDisabled(!records.length);
            }
        }
    });
}

/**
 * 部门支出附件表格
 */
function initBmzcWindow_file_grid(busiId) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET205', //业务类型
        busiId: busiId, //业务ID
        busiProperty: 'C01', //业务规则
        editable: true, //是否可以修改附件内容
        gridConfig: {
            itemId: 'bmzcWindow_file_grid'
        }
    });
    // 附件加载完成后计算总文件数，并写到页签上
    grid.getStore().on('load', function (self, records) {
        var sum = 0;
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if (records[i].data.STATUS == '已上传') {
                    sum++;
                }
            }
        }
        if (grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 加载选择债券信息表格中的数据
 */
function loadChooseZqxxGrid() {
    var zqlxId = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_ZQLX_ID']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='CHOOSE_MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('chooseZqxxGrid').getStore();
    store.getProxy().extraParams = {
        ZQLX_ID: zqlxId,
        MHCX: mhcx
    };
    store.loadPage(1);
}

/**
 * 加载选择项目信息表格中的数据
 */
function loadChooseXmxxGrid() {
    var zqxxForm = Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0].getForm();
    var zqId = zqxxForm.findField('ZQ_ID').getValue();
    var zcdId = zqxxForm.findField('ZCD_ID').getValue();
    var xmlxId = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_XMLX_ID']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='CHOOSE_MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('chooseXmxxGrid').getStore();
    var xmIds = [];
    DSYGrid.getGrid('bmzcWindow_xmxx_grid').getStore().each(function (record) {
        xmIds.push(record.get('XM_ID'));
    });
    store.getProxy().extraParams = {
        ZQ_ID: zqId,
        ZCD_ID: zcdId,
        XMLX_ID: xmlxId,
        XM_IDS: xmIds,
        MHCX: mhcx
    };
    store.loadPage(1);
}

/**
 * 保存部门支出信息
 */
function saveBmzcInfo(b_btn, btn) {
    var zqxxForm = Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0].getForm();
    var xmxxStore = DSYGrid.getGrid('bmzcWindow_xmxx_grid').getStore();
    if (xmxxStore.getCount() == 0) {
        Ext.MessageBox.alert('提示', '请录入支出项目信息');
        btn.setDisabled(false);
        return;
    }
    var isEmptyPayDate = false;
    var isEmptyPayAmt = false;
    var isEmptyGmflId = false;
    var isEmptyJjflId = false;
    var checkPayAmt = false;
    var checkZxzbjAmt = false;
    var checkXzczAmt = false;
    var checkPayAndZxzbjAmt = false;
    var checkPayAndXzczAmt = false;
    var checkXmxx = false;
    var result = '';
    var xmxxData = [];
    var xmIds = [];
    xmxxStore.each(function (record) {
        // 检验支出日期列必填
        if (!isEmptyPayDate && !record.get('PAY_DATE')) {
            result += "请填写列表中【支出日期】列<br/>";
            isEmptyPayDate = true;
        }
        // 检验本次支出金额列必填
        var payAmt = record.get('PAY_AMT');
        if (!isEmptyPayAmt && !payAmt) {
            result += "请填写列表中【本次支出金额（元）】列<br/>";
            isEmptyPayAmt = true;
        }
        // 检验本次支出金额不能大于剩余可支出金额
        var kzcAmt = record.get('KZC_AMT');
        if (!checkPayAmt && accSubPro(payAmt, kzcAmt) > 0) {
            result += "本次支出金额" + payAmt + "元不能大于剩余可支出金额" + kzcAmt + "元<br/>";
            checkPayAmt = true;
        }
        // 检验功能分类列必填
        if (!isEmptyGmflId && !record.get('GNFL_ID')) {
            result += "请填写列表中【功能分类】列<br/>";
            isEmptyGmflId = true;
        }
        // 检验经济分类列必填
        if (!isEmptyJjflId && !record.get('JJFL_ID')) {
            result += "请填写列表中【经济分类】列<br/>";
            isEmptyJjflId = true;
        }
        //专项债用作资本金不能大于可支出专项债用作资本金
        var zxzbjAmt = record.get('ZX_ZBJ_AMT');
        var kzcZxzbjAmt = record.get('KZC_ZX_ZBJ_AMT');
        if (!checkZxzbjAmt && zxzbjAmt > kzcZxzbjAmt) {
            result += "专项债用作资本金" + zxzbjAmt + "元不能大于可支出专项债用作资本金" + kzcZxzbjAmt + "元<br/>";
            checkZxzbjAmt = true;
        }
        //新增赤字不能大于可支出新增赤字
        var xzczAmt = record.get('XZCZAP_AMT');
        var kzcXzczAmt = record.get('KZC_XZCZAP_AMT');
        if (!checkXzczAmt && xzczAmt > kzcXzczAmt) {
            result += "新增赤字" + xzczAmt + "元不能大于可支出新增赤字" + kzcXzczAmt + "元<br/>";
            checkXzczAmt = true;
        }
        //专项债用作资本金不能大于本次支出金额
        if (!checkPayAndZxzbjAmt && zxzbjAmt > payAmt) {
            result += "专项债用作资本金" + zxzbjAmt + "元不能大于本次支出金额" + payAmt + "元<br/>";
            checkPayAndZxzbjAmt = true;
        }
        //新增赤字不能大于本次支出金额
        if (!checkPayAndXzczAmt && xzczAmt > payAmt) {
            result += "新增赤字" + xzczAmt + "元不能大于本次支出金额" + payAmt + "元<br/>";
            checkPayAndXzczAmt = true;
        }
        //校验同一个支出单内项目不能多次进行支出
        var xmId = record.get('XM_ID');
        if (!checkXmxx && xmIds.indexOf(xmId) >= 0) {
            result += "同一个支出单内项目不能多次进行支出<br/>";
            checkXmxx = true;
        }
        xmIds.push(xmId);
        xmxxData.push(record.getData());
    });
    if (result != '') {
        Ext.MessageBox.alert('提示', result);
        btn.setDisabled(false);
        return;
    }
    $.post('/zqgl/bmzc/saveBmzcInfo.action', {
        BUTTON_NAME: b_btn.name,
        BUTTON_TEXT: b_btn.text,
        WF_ID: wf_id,
        NODE_CODE: node_code,
        ZQXX_DATA: Ext.util.JSON.encode(zqxxForm.getValues()),
        XMXX_DATA: Ext.util.JSON.encode(xmxxData)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: btn.text + "成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, "json");
}

/**
 * 删除部门支出信息
 */
function deleteBmzcInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length < 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            var zcdIds = [];
            for (var i in records) {
                zcdIds.push(records[i].get('ZCD_ID'));
            }
            $.post("/zqgl/bmzc/deleteBmzcInfo.action", {
                ZCD_IDS: zcdIds
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: btn.text + "成功",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    reloadGrid();
                } else {
                    Ext.MessageBox.alert('提示', data.message);
                }
                btn.setDisabled(false);
            }, "json");
        } else {
            btn.setDisabled(false);
        }
    });
}

/**
 * 修改部门支出信息
 */
function updateBmzcInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
        btn.setDisabled(false);
        return;
    }
    var zcdId = records[0].get('ZCD_ID');
    // 根据zcdId获取部门支出信息
    $.post("/zqgl/bmzc/getBmzcInfo.action", {
        ZCD_ID: zcdId
    }, function (data) {
        if (data.success) {
            var bmzcWindow = initBmzcWindow(btn, zcdId);
            var xmxxGrid = DSYGrid.getGrid('bmzcWindow_xmxx_grid');
            xmxxGrid.insertData(null, data.BMZC_XMXX);
            var zcdInfo = data.BMZC_ZCD;
            var sumPayAmt = xmxxGrid.getStore().sum('PAY_AMT');
            zcdInfo.AD_NAME = AD_NAME;
            zcdInfo.ZCLX_NAME = '新增债券支出';
            zcdInfo.KZC_AMT = accAddPro(accSubPro(zcdInfo.SJZC_AMT, zcdInfo.YZC_AMT), sumPayAmt);
            zcdInfo.ZC_TOTAL_AMT = sumPayAmt;
            Ext.ComponentQuery.query('form#bmzcWindow_zqxx_form')[0].getForm().setValues(data.BMZC_ZCD);
            bmzcWindow.show();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        btn.setDisabled(false);
    }, "json");
}