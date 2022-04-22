/**
 * 页面初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    $.post("getParamValueAll.action", function (data) {
        SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX;
        DFF_CH_MODE = data[0].DFF_CH_MODE == undefined ? '0' : data[0].DFF_CH_MODE;//判断是否是undefined
        IS_CONFIRMHK_BY_AUDIT = data[0].IS_CONFIRMHK_BY_AUDIT;
        IS_CONFIRM_BYGK = data[0].IS_CONFIRM_BYGK;
        initContent();
    },"json");
    //如果是从到期提醒进来，自动弹出录入界面
    if (df_plan_id != null && df_plan_id != "") {
        $.post("/getId.action", function (dataId) {
            if (!dataId.success) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + dataId.message);
                return;
            }
            //发送ajax请求，查询主表和明细表数据
            $.post("/getZdhkDfdataByDfPlanId_WS.action", {
                df_plan_id: df_plan_id
            }, function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    return;
                }
                button_name = '录入';
                var dddata = data.data;
                var window_input = initWin_input();
                window_input.show();
                //dddata.ZJLY_ID = '';
                //window_input.window.down('form').getForm().setValues(dddata);
                dddata.HK_DATE = Ext.util.Format.date(new Date(), 'Y-m-d');
                dddata.FLAG_EDIT = 'INSERT';
                dddata.HK_ID = dataId.data[0];
                dddata.HK_HK_AMT = dddata.SYYH_AMT;
                dddata.HK_DFF_AMT = dddata.SYDFF_AMT;
                var grid = window_input.down('#win_input_tab_mxgrid');
                window_input.down('#win_input_tab_mxgrid').insertData(null, dddata);
            }, "json");
        }, "json");
    }
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
        renderTo: Ext.getBody(),
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: zqzjdf_json_common[wf_id][node_code].items[WF_STATUS]//根据当前状态切换显示按钮
            }
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
    var headerjson_hkd = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "单号", dataIndex: "GKZJSJ_NO", width: 150, type: "string"},
        {text: "上缴日期", dataIndex: "SJ_DATE", width: 100, type: "string"},
        {
            text: "到期总金额(元)", dataIndex: "TOTAL_PAY_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "上缴总金额(元)", dataIndex: "TOTAL_SJ_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerjson_hkd,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            DQ_YEAR: '',
            DQ_MO: ''
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getDqYsjGkZqzjMain_WS.action',
        checkBox: true,
        border: false,
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: zqzjdf_json_common[wf_id][node_code].store['WF_STATUS'],
                //store: DebtEleStore(json_debt_zt3),
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
                        toolbar.add(zqzjdf_json_common[wf_id][node_code].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            }
            /*{
             xtype: "combobox",
             name: "DQ_YEAR",
             store: DebtEleStore(json_debt_year),
             displayField: "name",
             valueField: "id",
             //value: new Date().getFullYear(),
             fieldLabel: '还款年月',
             editable: false, //禁用编辑
             labelWidth: 70,
             width: 180,
             listeners: {
             change: function (self, newValue) {
             //刷新当前表格
             self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
             reloadGrid();
             }
             }
             },
             {
             xtype: "combobox",
             name: "DQ_MO",
             store: DebtEleStore(json_debt_yf_nd),
             displayField: "name",
             valueField: "id",
             //value: lpad(1+new Date().getUTCMonth(),2),
             editable: false, //禁用编辑
             width: 85,
             listeners: {
             change: function (self, newValue) {
             //刷新当前表格
             self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
             reloadGrid();
             }
             }
             },
             {
             xtype: "combobox",
             name: "ZQLB_CODE",
             store: DebtEleStore(json_debt_zqlx),
             displayField: "name",
             valueField: "id",
             fieldLabel: '债券类型',
             editable: false, //禁用编辑
             labelWidth: 70,
             width: 180,
             labelAlign: 'right',
             listeners: {
             change: function (self, newValue) {
             //刷新当前表格
             self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
             reloadGrid();
             }
             }
             }*/
        ],
        listeners: {
            itemdblclick: function (self, record) {
                // IS_VIEW = true;
                // //发送ajax请求，查询主表和明细表数据
                // $.post("/getZdhkxxGridData_WS.action", {
                //     GKSJ_ID: record.get('GKSJ_ID')
                // }, function (data) {
                //     if (!data.success) {
                //         Ext.MessageBox.alert('提示', '加载失败！' + data.message);
                //         return;
                //     }
                //     //弹出填报页面，并写入债券信息以及明细信息
                //     var window_input = initWin_input();
                //     window_input.show();
                //     window_input.down('form').getForm().setValues(data.list[0]);
                //
                //     window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                // }, "json");
            },
            itemclick: function (self, record) {
                DSYGrid.getGrid('contentDetilGrid').getStore().getProxy().extraParams['GKSJ_ID'] = record.get('GKSJ_ID');
                DSYGrid.getGrid('contentDetilGrid').getStore().loadPage(1);
            }

        }
    });
}

/**
 * 初始化明细表
 * */
function initContentDetilGrid(callback) {
    var headerjson_zbmxb = [
        {xtype: 'rownumberer', width: 45},
        {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string",hidden:true},
        {text: "上缴国库ID", dataIndex: "GKSJDTL_ID", type: "string", width: 150,hidden:true},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 100},
        {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 100},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 300,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + userAdCode;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(userAdCode);
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "还款类型ID", dataIndex: "PLAN_TYPE", type: "string", width: 80,hidden:true},
        {text: "还款类型", dataIndex: "PLAN_TYPE_NAME", type: "string", width: 80},
        {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 100},
        {
            text: "到期金额(元)", dataIndex: "DQ_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "上缴金额(元)", dataIndex: "SJ_AMT", width: 180, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {
                name: "SJ_AMT",
                xtype: "numberFieldFormat",
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            }
        },
        {
            text: "上缴兑付费金额(元)", dataIndex: "SJ_DFF_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余上缴金额(元)", dataIndex: "SYSJ_AMT", width: 180, type: "float",hidden:true,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余上缴兑付费金额(元)", dataIndex: "SYSJ_DFF_AMT", width: 180, type: "float",hidden:true,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "下级已偿还金额(元)", dataIndex: "XJCH_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "下级已偿还兑付费金额(元)", dataIndex: "XJCH_DFF_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "提前还款天数", dataIndex: "TQHK_DAYS", type: "number"},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 150},
        {text: "债券批次", dataIndex: "FXPC_NAME", type: "string", width: 150},
        {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 80}
    ];
    var config = {
        itemId: 'contentDetilGrid',
        headerConfig: {
            headerJson: headerjson_zbmxb,
            columnAutoWidth: false
        },
        flex: 1,
        dataUrl: '/getDqYsjGkZqzjDtl_WS.action',
        // checkBox: true,
        border: false,
        autoLoad: false,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);
    return grid;
}

function clearmxgrid() {
    var mxgrid = DSYGrid.getGrid('contentDetilGrid').getStore();
    mxgrid.removeAll();
}

/**
 * 创建转贷还款计划弹出窗口
 */
function initWindow_select() {
    var items = [initWindow_select_grid()];
    if (userAdCode.length == 4 && !(userAdCode.lastIndexOf("00") == 2)) {
        items = [initWindow_select_grid(), initWindow_select_grid_detail()]
    }
    return Ext.create('Ext.window.Window', {
        title: '到期债券', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: items,
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    // 获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作！');
                        return false;
                    }

                    //获取还款明细信息以及债券信息
                    var data_mx = [];
                    var data_zq = records[0].getData();
                    for (var i = 0; i < records.length; i++) {
                        var obj = records[i].getData();
                        // obj.SJ_DATE = Ext.util.Format.date(new Date(), 'Y-m-d');
                        data_mx.push(obj);
                    }
                    //发送ajax请求，获取新增主表id
                    $.post("/getId.action", {size: records.length + 1}, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //给每条明细增加ID，后面附件使用
                        for (var i = 0; i < data_mx.length; i++) { //设置默认值
                            var obj = data_mx[i];
                            obj.GKSJDTL_ID = data.data[i + 1];
                            obj.SJ_AMT = obj.SYSJ_AMT;
                            obj.SJ_DFF_AMT = obj.SYSJ_DFF_AMT;
                        }
                        //弹出填报页面，并写入债券信息以及明细信息
                        var window_input = Ext.ComponentQuery.query('window#window_input')[0];
                        if (!window_input) {
                            window_input = initWin_input();
                            window_input.show();
                            $.post("/getGksjNO_WS.action", function (result) {
                                if (!result.success) {
                                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                    return;
                                }
                                data_zq.GKZJSJ_NO = result.list[0].HK_NO;
                                window_input.down('form').getForm().setValues(data_zq);
                            }, "json");
                        }

                        //获取已录入债券ID列表
                        var grid = window_input.down('#win_input_tab_mxgrid');
                        var store = grid.getStore();
                        var list_dfjh = {};
                        for (var j = 0; j < store.getCount(); j++) {
                            var record = store.getAt(j);
                            list_dfjh[record.get('DF_PLAN_ID')] = true;
                        }
                        var data_mxs = [];
                        //循环插入数据，如果已存在该兑付计划，不录入
                        for (var i = 0; i < data_mx.length; i++) {
                            var obj = data_mx[i];
                            if (!(DFF_CH_MODE == 0)) {
                                obj.HK_DFF_AMT = '0.00'//给获取到的数据中的兑付费赋值为0.00
                            }
                            obj.FLAG_EDIT = 'INSERT';
                            if (list_dfjh[obj.DF_PLAN_ID]) {
                                continue;
                            }
                            data_mxs.push(obj);
                        }
                        window_input.down('#win_input_tab_mxgrid').insertData(null, data_mxs);
                        //刷新填报弹出中转贷明细表获取转贷计划
                        btn.up('window').close();
                    }, "json");
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
 * 初始化转贷兑付计划弹出框表格
 */
function initWindow_select_grid() {
    var GKSJ_ID = null;
    if (button_name == '修改') {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        GKSJ_ID = records[0].get('GKSJ_ID');
    }
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string",hidden:true},
        {text: "上缴国库ID", dataIndex: "GKSJDTL_ID", type: "string", width: 150,hidden:true},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
        {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 150},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 300,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + userAdCode;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(userAdCode);
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 100},
        {text: "还款类型ID", dataIndex: "PLAN_TYPE", type: "string", width: 150,hidden:true},
        {text: "还款类型", dataIndex: "PLAN_TYPE_NAME", type: "string", width: 100},
        {
            text: "到期金额(元)", dataIndex: "DQ_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "到期兑付费金额(元)", dataIndex: "DQ_DFF_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余上缴金额(元)", dataIndex: "SYSJ_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余上缴兑付费金额(元)", dataIndex: "SYSJ_DFF_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "下级已偿还金额(元)", dataIndex: "XJCH_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "下级已偿还兑付费金额(元)", dataIndex: "XJCH_DFF_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "提前还款天数", dataIndex: "TQHK_DAYS", type: "number"},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 150},
        {text: "债券批次", dataIndex: "FXPC_NAME", type: "string", width: 150},
        {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 80}
    ];
    return DSYGrid.createGrid({
        itemId: 'grid_select',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        width: '100%',
        flex: 1,
        dataUrl: 'getDqYsjGkZqInfo_Ws.action',  //转贷还款计划 视图：DEBT_V_ZQGL_ZDHKJH
        pageConfig: {
            enablePage: false
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                layout: 'column',
                defaults: {
                    margin: '0 8 5 0'
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "HKJH_YEAR",
                        store: DebtEleStore(json_debt_year),
                        displayField: "name",
                        valueField: "id",
                        value: new Date().getFullYear(),
                        fieldLabel: '到期年月',
                        editable: false, //禁用编辑
                        labelWidth: 70,
                        width: 175
                    },
                    '-',
                    {
                        xtype: "combobox",
                        name: "HKJH_MO",
                        store: DebtEleStore(json_debt_yf_nd),
                        displayField: "name",
                        valueField: "id",
                        value: lpad(1 + new Date().getUTCMonth(), 2),
                        editable: false, //禁用编辑
                        width: 85
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLB_ID",
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债券类别',
                        editable: false, //禁用编辑
                        labelWidth: 60,
                        width: 175,
                        labelAlign: 'left',
                        listeners: {
                            change: function (self, newValue) {
                                if (!!self.up('window')) {
                                    self.up('window').down('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                                    self.up('window').down('grid').getStore().loadPage(1);
                                }
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQ_PC_ID",
                        store: DebtEleStoreDB('DEBT_ZQPC'),
                        fieldLabel: '债券批次',
                        displayField: 'name',
                        valueField: "id",
                        editable: false, //禁用编辑
                        labelWidth: 60,
                        width: 185,
                        labelAlign: 'left',
                        listeners: {
                            change: function (self, newValue) {
                                self.up('window').down('grid').getStore().getProxy().extraParams['ZQ_PC_ID'] = self.getValue();
                                self.up('window').down('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        name: "zqmc",
                        fieldLabel: '模糊查询',
                        labelWidth: 60,
                        width: 250,
                        emptyText: '请输入债券名称/债券编码...',
                        editable: true,
                        enableKeyEvents: true,
                        listeners: {
                            'keydown': function (self, e) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    var win = self.up('window');
                                    var ZQMC = win.down('textfield[name="zqmc"]').getValue();
                                    var DQ_YEAR = win.down('combobox[name="HKJH_YEAR"]').value;
                                    var DQ_MO = win.down('combobox[name="HKJH_MO"]').value;
                                    var ZQLB_ID = win.down('treecombobox[name="ZQLB_ID"]').value;
                                    var ZQ_PC_ID = win.down('combobox[name="ZQ_PC_ID"]').value;

                                    //刷新表格数据lur
                                    var store = self.up('window').down('grid').getStore();
                                    store.getProxy().extraParams = {
                                        DQ_YEAR: DQ_YEAR,
                                        DQ_MO: DQ_MO,
                                        ZQMC: ZQMC,
                                        ZQLB_ID: ZQLB_ID,
                                        ZQ_PC_ID: ZQ_PC_ID,
                                        GKSJ_ID:GKSJ_ID
                                    };
                                    store.loadPage(1);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        style: {marginRight: '20px'},
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            var win = btn.up('window');
                            var ZQMC = win.down('textfield[name="zqmc"]').getValue();
                            var DQ_YEAR = win.down('combobox[name="HKJH_YEAR"]').value;
                            var DQ_MO = win.down('combobox[name="HKJH_MO"]').value;
                            var ZQLB_ID = win.down('treecombobox[name="ZQLB_ID"]').value;
                            var ZQ_PC_ID = win.down('combobox[name="ZQ_PC_ID"]').value;
                            //刷新表格数据lur
                            var store = btn.up('window').down('grid').getStore();
                            store.getProxy().extraParams = {
                                DQ_YEAR: DQ_YEAR,
                                DQ_MO: DQ_MO,
                                ZQMC: ZQMC,
                                ZQLB_ID: ZQLB_ID,
                                ZQ_PC_ID: ZQ_PC_ID,
                                GKSJ_ID:GKSJ_ID
                            };
                            store.loadPage(1);

                        }
                    }
                ],
                dock: 'top'
            }],
        params: {
            DQ_YEAR: new Date().getFullYear(),
            DQ_MO: lpad(1 + new Date().getUTCMonth(), 2),
            GKSJ_ID:GKSJ_ID
        },
        listeners: {
            itemclick: function (self, record) {
                if (userAdCode.length == 4 && !(userAdCode.lastIndexOf("00") == 2)) {
                    //刷新明细表
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['AD_CODE'] = record.get('AD_CODE');
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['PLAN_TYPE'] = record.get('PLAN_TYPE');
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['DF_END_DATE'] = record.get('DF_END_DATE');
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['ZQ_ID'] = record.get('ZQ_ID');
                    DSYGrid.getGrid('grid_select_detail').getStore().loadPage(1);
                }
            }
        }
    });
}

/**
 * 初始化下级还款表格
 */
function initWindow_select_grid_detail() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            dataIndex: "AD_NAME", type: "string", text: "地区名称", width: 200, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "还款类型", dataIndex: "HK_TYPE_NAME", type: "string", width: 80},
        {text: "还款日期", dataIndex: "HK_DATE", type: "string", width: 100},
        {
            text: "应还款金额(元)", dataIndex: "DQ_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "应还兑付费(元)", dataIndex: "PLAN_DFF_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "还款金额(元)", dataIndex: "HK_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "兑付费金额(元)", dataIndex: "DFF_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "还款总金额(元)", dataIndex: "TOTAL_PAY_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}
    ];
    return DSYGrid.createGrid({
        itemId: 'grid_select_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        tbar: ['下级地区还款信息'],
        height: '50%',
        width: '100%',
        flex: 1,
        autoLoad: false,
        border: false,
        pageConfig: {
            enablePage: false
        },
        dataUrl: 'getZdHkXjzdGridData_WS.action',
        features: [{
            ftype: 'summary'
        }]
    });
}

/**
 * 初始化债券转贷弹出窗口
 */
function initWin_input() {
    records_delete = [];

    var config = {
        title: '缴付申请', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_input', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWin_input_form(), initWin_input_tab()],
        buttons: [
            {
                xtype: 'button',
                text: '新增',
                width: 80,
                handler: function (btn) {
                    //弹出到期债务窗口
                    initWindow_select().show();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'delete_editGrid',
                width: 80,
                disabled: true,
                style: {marginRight: '20px'},
                handler: function (btn) {
                    var grid = btn.up('window').down('grid#win_input_tab_mxgrid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    var records = sm.getSelection();
                    grid.getPlugin('cellEdit').cancelEdit();
                    for (var i = 0; i < records.length; i++) {
                        var obj = records[i];
                        if (obj.get('FLAG_EDIT') == 'UPDATE') {
                            records_delete.push(obj.getData())
                        }
                    }
                    store.remove(records);
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    var form = btn.up('window').down('form');
                    var grid = btn.up('window').down('grid#win_input_tab_mxgrid');
                    // 校验
                    if (grid.getStore().getCount() <= 0) {
                        Ext.Msg.alert('提示', '明细数据不能为空！');
                        return false;
                    }
                    if (!form.down('[name=SJ_DATE]').getValue()) {
                        Ext.Msg.alert('提示', '还款日期不能为空！');
                        return false;
                    }
                    if (!form.down('[name=GKZJSJ_NO]').getValue()) {
                        Ext.Msg.alert('提示', '还款单号不能为空！');
                        return false;
                    }
                    // 参数数据
                    var gridData = [];//所有明细数据
                    var records_add = [];//新增行
                    var records_update = [];//修改行
                    for (var i = 0; i < grid.getStore().getCount(); i++) {
                        var record = grid.getStore().getAt(i);
                        // record.data.TOTAL_PAY_AMT = record.data.HK_HK_AMT + record.data.HK_DFF_AMT;
                        gridData.push(record.data);
                        if (record.get('FLAG_EDIT') == 'INSERT') {
                            records_add.push(record.data);
                        }
                        if (record.get('FLAG_EDIT') == 'UPDATE') {
                            records_update.push(record.data);
                        }
                        if (record.get("SJ_AMT") == 0 ) {//还款金额为0，兑付费金额不为0时可以保存
                            Ext.Msg.alert('提示', '上缴金额不能为0！');
                            return false;
                        }
                        if (record.get("SJ_AMT") > record.get("SYSJ_AMT")) {
                            Ext.Msg.alert('提示', '上缴金额不能大于剩余上缴金额');
                            return false;
                        }
                    }
                    var parameters = {
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name, //这里要先生成主键id传回后台
                        detailList: Ext.util.JSON.encode(gridData),
                        listAdd: Ext.util.JSON.encode(records_add),
                        listUpdate: Ext.util.JSON.encode(records_update),
                        listDelete: Ext.util.JSON.encode(records_delete)
                    };
                    if (button_name == '修改') {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        parameters.GKSJ_ID = records[0].get('GKSJ_ID');
                    }
                    if (form.isValid()) {
                        btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                        //保存表单数据及明细数据
                        form.submit({
                            //设置表单提交的url
                            url: 'saveDqYsjGkZqzjInfo_Ws.action',
                            params: parameters,
                            success: function (form, action) {
                                //关闭弹出框
                                btn.up("window").close();
                                //提示保存成功
                                Ext.toast({html: '<div style="text-align: center;">保存成功!</div>'});
                                reloadGrid();
                            },
                            failure: function (form, action) {
                                var result = Ext.util.JSON.decode(action.response.responseText);
                                Ext.Msg.alert('提示', "保存失败！" + result && result.message ? result.message : '无返回响应');
                                btn.setDisabled(false);
                            }
                        });
                    } else {
                        Ext.Msg.alert('提示', '请完善必填项！');
                        return false;
                    }
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    };
    if (IS_VIEW) {
        delete config.buttons;
    }
    return Ext.create('Ext.window.Window', config);
}

/**
 * 初始化债券转贷表单
 */
function initWin_input_form() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        layout: 'column',
        defaults: {
            columnWidth: .33,
            margin: '5 5 5 5',
            readOnly: true,
            fieldCls: 'form-unedit',
            labelWidth: 135//控件默认标签宽度
        },
        defaultType: 'textfield',
        items: [
            {
                fieldLabel: '到期总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '本次上缴总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_BCSJ_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '剩余可上缴金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_SYSJ_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '下级已偿还金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_XJCH_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '<span class="required">✶</span>上缴日期',
                name: "SJ_DATE",
                xtype: "datefield",
                allowBlank: false,
                readOnly: false,
                format: 'Y-m-d',
                fieldCls: null,
                blankText: '请选择还款日期',
                value: new Date(),
                listeners: {
                    change: function (self, newValue, oldValue) {

                    }
                }
            },
            {
                fieldLabel: "<span class=\"required\">✶</span>单号",
                name: "GKZJSJ_NO", width: 150,
                readOnly: false,
                maxLength: 20,//限制输入字数
                maxLengthText: "输入内容过长！",
                editable: false,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '备注',
                name: "REMARK",
                columnWidth: .99,
                readOnly: false,
                fieldCls: null,
                listeners: {
                    change: function (self, newValue, oldValue) {
                        //下方表格中所有还款日期设置为该日期
                        var store = self.up('window').down('grid#win_input_tab_mxgrid').getStore();
                        store.each(function (record) {
                            record.set('REMARK', newValue);
                        });
                    }
                }
            }
        ],
        listeners: {
            'beforeRender': function () {
                if (IS_VIEW) {
                    SetItemReadOnly(this.items);
                }
            }
        }
    });
}

/**
 * 初始化转贷还款弹出框：下部页签panel
 */
function initWin_input_tab() {
    return Ext.create('Ext.tab.Panel', {
        width: '100%',
        flex: 1,
        items: [
            {
                title: '明细情况',
                layout: 'fit',
                scrollable: true,
                items: initWin_input_tab_mxgrid()
            },
            {
                title: '明细附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        items: initWin_input_tab_upload(HkId)
                    }
                ],
                listeners: {
                    beforeactivate: function (self) {
                        // 检验明细是否有数据
                        var grid = self.up('tabpanel').down('grid#win_input_tab_mxgrid');
                        if (grid.getStore().getCount() <= 0) {
                            Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                            return false;
                        }
                        // 获取选中数据
                        var record = grid.getCurrentRecord();
                        //如果当前无选中行，默认选中第一条数据
                        if (!record) {
                            $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                            record = grid.getStore().getAt(0);
                            Ext.toast({
                                html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        }
                        var panel = self.down('panel');
                        panel.removeAll(true);
                        panel.add(initWin_input_tab_upload(record.get('GKSJDTL_ID')));
                    }
                }
            }
        ]
    });
}

/**
 * 初始化主表格
 */
function initWin_input_tab_mxgrid() {
    var headerjson_hkdmx = [
        {xtype: 'rownumberer', width: 45},
        {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string",hidden:true},
        {text: "上缴国库ID", dataIndex: "GKSJDTL_ID", type: "string", width: 150,hidden:true},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 100},
        {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 100},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 300,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + userAdCode;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(userAdCode);
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "还款类型ID", dataIndex: "PLAN_TYPE", type: "string", width: 80,hidden:true},
        {text: "还款类型", dataIndex: "PLAN_TYPE_NAME", type: "string", width: 80},
        {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 100},
        {
            text: "到期金额(元)", dataIndex: "DQ_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "上缴金额(元)", dataIndex: "SJ_AMT", width: 180, type: "float", summaryType: 'sum', headerMark: 'star',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {
                name: "SJ_AMT",
                xtype: "numberFieldFormat",
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            }
        },
        {
            text: "上缴兑付费金额(元)", dataIndex: "SJ_DFF_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余上缴金额(元)", dataIndex: "SYSJ_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余上缴兑付费金额(元)", dataIndex: "SYSJ_DFF_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "下级已偿还金额(元)", dataIndex: "XJCH_AMT", width: 180, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "下级已偿还兑付费金额(元)", dataIndex: "XJCH_DFF_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "提前还款天数", dataIndex: "TQHK_DAYS", type: "number"},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 150},
        {text: "债券批次", dataIndex: "FXPC_NAME", type: "string", width: 150},
        {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 80}
    ];
    if (!(DFF_CH_MODE == 0)) {
        Ext.Array.forEach(headerjson_hkdmx, function (header) {
            if (header.dataIndex == 'HK_DFF_AMT') {
                delete header.headerMark;//删除星号
                //delete header.editor;//不可编辑
                //header.tdCls = 'grid-cell-unedit';//置为不可编辑状态
            }
        });
    }
    var config = {
        itemId: 'win_input_tab_mxgrid',
        headerConfig: {
            headerJson: headerjson_hkdmx,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            DQ_YEAR: '',
            DQ_MO: ''
        },
        data: [],
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {

                    },
                    'validateedit': function (editor, context) {

                    },
                    'edit': function (editor, context) {
                        if (context.field == 'SJ_AMT') {
                            if (DFF_CH_MODE == 0) {
                                //计算兑付费金额
                                var dfsxf_rate = context.record.get('DFSXF_RATE');
                                var dff_amt = context.value * dfsxf_rate / 100;
                            }
                            //更新数据后格式化
                            dff_amt = Ext.util.Format.number(dff_amt, '0,000.00');
                            if (context.record.get('SYSJ_DFF_AMT') > 0) {
                                context.record.set('SJ_DFF_AMT', dff_amt);
                            }

                        }
                    }
                }
            }
        ],
        listeners: {
            selectionchange: function (self, records) {
                if (grid.up('window').down('[name=delete_editGrid]')) {
                    grid.up('window').down('[name=delete_editGrid]').setDisabled(!records.length);
                }
            },
            edit: function (editor, context) {
                if (context.field == 'SJ_AMT') { // 校验：申请还款资金不能大于剩余应还金额资金
                    if (context.value > context.record.get("SYSJ_AMT")) {
                        Ext.MessageBox.alert('提示', '上缴金额不能大于剩余上缴金额！');
                        context.record.set('SJ_AMT', context.record.get("SYSJ_AMT"));
                    }
                }
            }
        }
    };
    if (IS_VIEW) {
        delete config.plugins;
    }
    var grid = DSYGrid.createGrid(config);
    grid.getStore().on('endupdate', function () {
        //计算录入窗口form当年申请金额
        var self = grid.getStore();
        var TOTAL_PAY_AMT = 0;
        var TOTAL_SJ_AMT = 0;
        var TOTAL_SYSJ_AMT = 0;
        var TOTAL_XJCH_AMT = 0;
        self.each(function (record) {
            TOTAL_PAY_AMT += record.get('DQ_AMT');
            TOTAL_SJ_AMT += record.get('SJ_AMT');
            TOTAL_SYSJ_AMT += record.get('SYSJ_AMT');
            TOTAL_XJCH_AMT += record.get('XJCH_AMT');
        });
        grid.up('window').down('form').down('[name=TOTAL_PAY_AMT]').setValue(TOTAL_PAY_AMT);
        grid.up('window').down('form').down('[name=TOTAL_BCSJ_AMT]').setValue(TOTAL_SJ_AMT);
        grid.up('window').down('form').down('[name=TOTAL_SYSJ_AMT]').setValue(TOTAL_SYSJ_AMT);
        grid.up('window').down('form').down('[name=TOTAL_XJCH_AMT]').setValue(TOTAL_XJCH_AMT);
    });
    return grid;
}

/**
 * 初始化填报表单中的附件
 */
function initWin_input_tab_upload(HkId) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET203',//业务类型
        busiId: HkId,//业务ID
        editable: !IS_VIEW,
        gridConfig: {
            itemId: 'win_input_tab_upload_grid'
        }
    });
    //附件加载完成后计算总文件数，并写到页签上
    grid.getStore().on('load', function (self, records, successful) {
        var sum = 0;
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if (records[i].data.STATUS == '已上传') {
                    sum++;
                }
            }
        }
        if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else if ($('span.file_sum')) {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("GKSJ_ID"));
    }
    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/editDqYsjGkZqzjInfo_WS.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids: ids,
                    IS_CONFIRMHK_BY_AUDIT: IS_CONFIRMHK_BY_AUDIT,
                    IS_CONFIRM_BYGK: IS_CONFIRM_BYGK
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
    } else {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + "意见",
            animateTarget: btn,
            value: btn.name == 'up' ? null : '同意',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/editDqYsjGkZqzjInfo_WS.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids,
                        IS_CONFIRMHK_BY_AUDIT: IS_CONFIRMHK_BY_AUDIT
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
            }
        });
    }
}

/**
 * 创建填写意见对话框
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
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    //刷新
    store.loadPage(1);
    //明细表刷新
    clearmxgrid();
}

/**
 * 操作记录
 */
function oprationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var gksj_id = records[0].get("GKSJ_ID");
        fuc_getWorkFlowLog(gksj_id);
    }
}

//取当前月时 长度为1时左侧补0
function lpad(num, n) {
    return (Array(n).join(0) + num).slice(-n);
}