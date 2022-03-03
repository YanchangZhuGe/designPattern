var cxt_id = '';

/**
 * 初始化条件面板
 */
function jbxxTab() {
    var fontSize = '';
    var labelWidth = 0;
    var iWidth = window.screen.width;//获取当前屏幕的分辨率
    if (iWidth == 1366) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else if (iWidth == 1400 || iWidth == 1440) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else if (iWidth == 1600 || iWidth == 1680) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    }
    /**
     * 定义表单元素及信息
     */
    var content = [{
        xtype: 'container',
        title: '债务信息',
        layout: 'anchor',
        width: "100%",
        margin: '0 2 0 2',
        defaults: {
            border: false,
            anchor: '100%',
            padding: '0 10 0 0'
        },
        items: [{//第一部分：第一行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1,
                padding: '7 0 2 0',
                labelAlign: 'right',
                labelWidth: labelWidth,
                labelStyle: fontSize,
                allowBlank: true,
                editable: false
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '<font color="red">*</font>债券编码',
                    name: "ZQ_CODE",
                    //labelStyle : fontSize,
                    allowBlank: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<font color="red">*</font>债券名称',
                    name: "ZQ_NAME",
                    allowBlank: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债券简称',
                    name: "ZQ_JC"
                }]
        }, {//第一部分：第二行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable: false
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '<font color="red">*</font>发文名称',
                    name: "ZQ_FWMC",
                    allowBlank: false
                },
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<font color="red">*</font>债券类型',
                    readOnly:true,
                    allowBlank: false
                },
                {
                    xtype: "treecombobox",
                    name: "ZQPZ_ID",
                    value: '111',
                    store: DebtEleTreeStoreJSON(json_debt_zqpz),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券品种',
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    allowBlank: false,
                    selectModel: 'leaf'
                }]
        }, {//第一部分：第三行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable: false
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '文号',
                    name: "ZQ_WH"
                },
                {
                    xtype: "combobox",
                    name: "ZQTGR_ID",
                    store: DebtEleStoreDB('DEBT_ZQTGR'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券托管人',
                    readOnly:true,
                },
                {
                    xtype: "combobox",
                    name: "ZJLY_ID",
                    store: DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:" and (code like '0101%' or code like '0102%') "}),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<font color="red">*</font>偿债资金来源',
                    readOnly:true,
                }]
        }, {//第一部分：第四行
            xtype: 'container',
            layout: 'column',
            defaults: {
                //flex: 1, labelWidth: labelWidth,
            	width:294,
                padding: '2 0 2 0',
                labelAlign: 'right',
                labelWidth: labelWidth,
                labelStyle: fontSize,
                allowBlank: true,
                editable: false
            },
            items: [
                {
                    xtype: "treecombobox",
                    name: "SRKM_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZWSRKM',{condition:" and (code like '105%') "}),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<font color="red">*</font>债务收入科目',
                    //width:294,
                    readOnly:true,
                }]
        }, {// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第二部分：第一行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{
                xtype: "numberfield",
                name: "PLAN_FX_AMT",
                fieldLabel: '<font color="red">*</font>计划发行额（亿）',
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }, {
                xtype: "numberfield",
                name: "FX_AMT",
                fieldLabel: '<font color="red">*</font>实际发行额（亿）',
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }, {
                xtype: "numberfield",
                name: "XZ_AMT",
                fieldLabel: '其中新增债券（亿）',
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }]
        }, {//第二部分：第二行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{
                xtype: "numberfield",
                name: "ZH_AMT",
                fieldLabel: '置换债券（亿）',
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
                {
                    xtype: "treecombobox",
                    name: "ZQ_PC_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQPC'),
                    fieldLabel: '<font color="red">*</font>债券批次',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    readOnly:true,
                    allowBlank: false,
                    selectModel: 'leaf'
                }, {
                    xtype: "datefield",
                    name: "ZQ_GGR",
                    fieldLabel: '公告日',
                    allowBlank: false,
                    readOnly:true,
                    format: 'Y-m-d',
                    readOnly:true,
                    blankText: '请选择开始日期',
                    emptyText: '请选择开始日期',
                    value: today
                }]
        }, {//第二部分：第三行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{
                xtype: "datefield",
                name: "ZB_DATE",
                fieldLabel: '招标时间',
                allowBlank: false,
                format: 'Y-m-d',
                readOnly:true,
                blankText: '请选择开始日期',
                emptyText: '请选择开始日期',
                value: today
            },
                {
                    xtype: "textfield",
                    fieldLabel: '招标时间',
                    name: "ZB_DATE",
                    editable: true
                },{
                    xtype: "combobox",
                    name: "FXFS_ID",
                    store: DebtEleStore(json_debt_fxfs),
                    displayField: "name",
                    valueField: "id",
                    value: '001',
                    fieldLabel: '<font color="red">*</font>发行方式',
                    flex:1,
                    allowBlank: false,
                    readOnly:true,
                    listeners: {
                        'select': function () {
                        }
                    }
               }]
        }, {// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第三部分：第一行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{
                xtype: "combobox",
                name: "ZQQX_ID",
                store: DebtEleStoreDB("DEBT_ZQQX"),
                displayField: "name",
                valueField: "id",
                fieldLabel: '<font color="red">*</font>期限',
                allowBlank: false,
                readOnly:true,
            }, {
                xtype: "datefield",
                name: "FX_START_DATE",
                fieldLabel: '发行期',
                allowBlank: false,
                format: 'Y-m-d',
                readOnly:true,
                blankText: '请选择开始日期',
                readOnly:true,
                value: today,
                listeners: {
                    'select': function () {
                    }
                }
            }, {
                xtype: "datefield",
                name: "FX_END_DATE",
                fieldLabel: '至',
                allowBlank: false,
                format: 'Y-m-d',
                readOnly:true,
                blankText: '请选择开始日期',
                value: today,
                listeners: {
                    'select': function () {
                    }
                }
            }]
        }, {// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第四部分：第一行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{//第四部分：
                xtype: "datefield",
                name: "QX_DATE",
                fieldLabel: '<font color="red">*</font>起息日',
                allowBlank: false,
                format: 'Y-m-d',
                readOnly:true,
                blankText: '请选择开始日期',
                allowBlank: false,
                value: today,
                listeners: {
                    'select': function () {
                    }
                }
            }, {
                xtype: "datefield",
                name: "DQDF_DATE",
                fieldLabel: '兑付日',
                format: 'Y-m-d',
                readOnly:true,
                blankText: '请选择开始日期',
                value: today,
                listeners: {
                    'select': function () {
                    }
                }
            }, {
                xtype: "combobox",
                name: "FXZQ_ID",
                store: DebtEleStore(json_debt_fxzq),
                displayField: "name",
                valueField: "id",
                fieldLabel: '<font color="red">*</font>付息方式',
                allowBlank: false,
                readOnly:true,
                listeners: {
                    'select': function () {
                    }
                }
            }]
        }, {//第四部分：第二行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [
                {
                    xtype: "numberfield",
                    name: "PM_RATE",
                    fieldLabel: '<font color="red">*</font>票面利率（%）',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "numberfield",
                    name: "LX_SUM_AMT",
                    fieldLabel: '利息总额',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },{
                    xtype: "numberfield",
                    name: "TQHK_DAYS",
                    fieldLabel: '提前还款天数',
                    flex:1,
                    emptyText: '0',
                    decimalPrecision: 0,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }]
        },{// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第六部分：第一行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{
                xtype: "combobox",
                name: "SXFYJ_ID",
                store: DebtEleStore(json_debt_sxfyj),
                displayField: "name",
                valueField: "id",
                value: '001',
                fieldLabel: '<font color="red">*</font>手续费支付方式',
                allowBlank: false,
                readOnly:true,
                listeners: {
                    'select': function () {
                    }
                }
            },
                {
                    xtype: "numberfield",
                    name: "FXSXF_RATE",
                    fieldLabel: '<font color="red">*</font>发行手续费费率（‰）',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "numberfield",
                    name: "TGSXF_RATE",
                    fieldLabel: '<font color="red">*</font>登记托管费率（‰）',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }]
        }, {//第六部分：第二行
            xtype: 'container',
            layout: 'hbox',
            defaults: {
                flex: 1, labelWidth: labelWidth,
                padding: '2 0 5 0',
                labelAlign: 'right', labelStyle: fontSize,
                allowBlank: true,
                editable:false
            },
            items: [{
                xtype: "numberfield",
                name: "DFSXF_RATE",
                fieldLabel: '<font color="red">*</font>兑付手续费率（‰）',
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
                {
                    xtype: "numberfield",
                    name: "FXSXF_AMT",
                    fieldLabel: '发行手续费（元）',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "numberfield",
                    name: "TGSXF_AMT",
                    fieldLabel: '登记托管费（元）',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }]
        }
            //结束
        ]
    }];

    var editorPanel = Ext.create('Ext.form.Panel', {
        itemId: 'jbxxForm',
        layout: 'fit',
        border: false,
        autoScroll: true,
        items: content
    });

    /**
     * 若为新增状态，则直接进行页面元素的初始化
     * 若为更新状态，则先进行数据的加载，加载完成后再进行页面元素的初始化
     */
   
    if (button_name == 'EDIT') {
        loadFxgl(editorPanel);
    } else {
        //initWidget(editorPanel);
    }

    return editorPanel;
};


/**
 * 提交表单数据
 * @param form
 */
function submitFxgl(form) {
    var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();
    var jgxxArray = [];
    //获取机构信息
    for (var i = 0; i < jgxxStore.getCount(); i++) {
        var array = {};
        var record = jgxxStore.getAt(i);
        array.CXJG_CODE = record.get("CXJG_CODE");
        array.CXJG_NAME = record.get("CXJG_NAME");
        array.IS_LEADER = record.get("IS_LEADER");
        array.CX_SCALE = record.get("CX_SCALE");
        array.ORG_ACCOUNT = record.get("ORG_ACCOUNT");
        array.ORG_ACC_NAME = record.get("ORG_ACC_NAME");
        array.ORG_ACC_BANK = record.get("ORG_ACC_BANK");
        jgxxArray.push(array);
    }

    var url = '';
    if (button_name == 'INPUT') {
        url = 'saveFxgl.action';
    } else {
        url = 'updateFxgl.action?ZQ_ID=' + ZQ_ID;
    }

    cxt_id = Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].value;

    if (form.isValid()) {
        form.submit({
            url: url,
            params: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                userCode: userCode,
                cxt_id: cxt_id,
                jgxxArray: Ext.util.JSON.encode(jgxxArray)
            },
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("grid").getStore().loadPage(1);
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存失败',
                    width: 200,
                    fn: function (btn) {
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                });
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}

/**
 * 加载页面数据
 * @param form
 */
function loadFxgl(form) {
    form.load({
        url: 'getFxgl.action?ZQ_ID=' + ZQ_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            //initWidget(form);
        	form.getForm().setValues(action.result.data.list);
//            cxt_id = action.result.data.CXT_ID;
//            Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].setValue(cxt_id);//设置承销团下拉框信息
            //设置承销团表格
            var jgxxStore = action.result.data.cxtList;
            var grid = DSYGrid.getGrid('jgxxGrid');
            grid.insertData(null, jgxxStore);
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}


/**
 * 初始化债券信息填报弹出窗口中的投资计划标签页
 */
function cxtxxTab() {
    try {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: 430,
            autoScroll: true,
            layout: 'fit',
            border: true,
            padding: '2 2 2 2',
            items: [init_jgxx_grid()],
            tbar: [
               
            ]
        });
    }
    catch (err) {
        // 当出现异常时，打印控制台异常
    }
}
/**
 * 初始化债券信息填报弹出窗口中的投资计划标签页中的表格
 */
function init_jgxx_grid() {
    try {
        //定义申请单编辑行model
        Ext.define('row_edit_jgxx_grid', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'CXJG_CODE', type: 'string', useNull: false, active: true},
                {name: 'CXJG_NAME', type: 'string', useNull: false, active: true},
                {name: 'IS_LEADER', type: 'string', useNull: false, active: true},
                {name: 'CX_SCALE', type: 'float', useNull: false, active: true},
                {name: 'ORG_ACCOUNT', type: 'string', useNull: false, active: true},
                {name: 'ORG_ACC_NAME', type: 'string', useNull: false, active: true},
                {name: 'ORG_ACC_BANK', type: 'string', useNull: false, active: true}
            ]
        });
        var headerJson =[
                {xtype: 'rownumberer',width: 35},
                {"dataIndex": "CXJG_CODE", "type": "string", "text": "机构编码", "width": 150, editor: 'textfield'},
                {"dataIndex": "CXJG_NAME", "type": "string", "text": "机构名称", "width": 200, editor: 'textfield'},
                {"dataIndex": "IS_LEADER", "type": "string", "text": "是否为主承销机构", "width": 150, editor: 'textfield',
                    renderer: function (value) {
                        var store = DebtEleStore(json_debt_sf);
                        var record = store.findRecord('code', value, 0, false, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    "dataIndex": "CX_SCALE", "type": "float", "text": "承销比例（%）", "width": 150,
                    editor: {
                        xtype: 'numberfield',
                        hideTrigger: true
                    }
                },
                {"dataIndex": "ORG_ACCOUNT", "type": "string", "text": "收款账号", "width": 150, editor: 'textfield'},
                {"dataIndex": "ORG_ACC_NAME", "type": "string", "text": "收款账户名称", "width": 150, editor: 'textfield'},
                {"dataIndex": "ORG_ACC_BANK", "type": "string", "text": "收款账户银行", "width": 150, editor: 'textfield'}
            ];
        
        var simplyGrid=new DSYGridV2();
        var grid = simplyGrid.create({
            itemId: 'jgxxGrid',
            border: true,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: false,
            height: 400,
            data:[],
            //dataUrl: 'getJgxxGrid.action',
//            params: {
//            	CXT_ID: 'test'
//            },
            pageConfig: {
            	enablePage: false//设置显示每页条数
            }
//            plugins: [
//                      {
//                    	  ptype: 'rowediting',
//                          clicksToMoveEditor: 1,
//                          autoCancel: false,
//                          pluginId: 'rowedit',
//                          saveBtnText: '确定',
//                          cancelBtnText: '取消',
//                          errorsText: '错误',
//                          dirtyText: '你要确认或取消更改'
//                      }
//                  ]
//            listeners: {
//            	'selectionchange':function(view, records) {
//            		grid.down('#delete_editGrid').setDisabled(!records.length);		
//            	}
//            }
        });
        return grid;
    }
    catch (err) {
        // 当出现异常时，打印控制台异常
    }
}

function refresh_jgxxGrid() {
    //cxt_id = Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].value;
    //var store = DSYGrid.getGrid('jgxxGrid').getStore();
    //初始化表格Store参数
//    store.getProxy().extraParams = {
//        CXT_ID: cxt_id
//    };
    //刷新表格内容
    //store.loadPage(1);
}


