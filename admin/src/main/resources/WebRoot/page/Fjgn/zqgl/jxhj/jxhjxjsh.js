$.extend(json_common, {
    items: {
        '001': [
            {
                text: '查询',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow_jxhj();
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow_jxhj();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("BILL_DTL_ID"));
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
            {
                text: '查询',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow_jxhj();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("BILL_DTL_ID"));
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    },
    items_content_rightPanel_items: function () {
        return [
            initContentGrid(),
            initContentDetilGrid()
        ]
    }
});

function doWorkFlow_jxhj() {
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length < 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择至少一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else if (sm.length >= 1) {
        var bills = new Array();
        for (var i = 0; i < sm.length; i++) {
            var temp = new Object();
            temp['BILL_ID'] = sm[i].get("BILL_ID");
            bills.push(temp);
        }
        Ext.MessageBox.show({
            title: "提示",
            msg: "是否" + button_name + "?",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (buttonId) {
                if (buttonId === "ok") {
                    Ext.Ajax.request({
                        method: 'POST',
                        url: "/doupdateworkflowxjsh.action",
                        params: {
                            AD_CODE: USER_AD_CODE,
                            USERCODE: USER_AD_CODE,
                            WF_ID: wf_id,
                            NODE_CODE: node_code,
                            BUTTON_NAME: button_name,
                            bills: Ext.util.JSON.encode(bills),
                            USER_CODE: USER_CODE
                        },
                        async: false,
                        success: function (response, options) {
                            var respText = Ext.util.JSON.decode(response.responseText);
                            if (respText.success) {
                                toast_util(button_name, true);
                                reloadMain();
                            } else {
                                toast_util(button_name, false, respText);
                            }
                        },
                        failure: function (response, options) {
                        }
                    });
                }
            }
        });
    }
}


var batch_no_store2 = DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND1 like '03%' OR EXTEND1 IS NULL) "});

var HEADERJSON2 = [
    {
        xtype: 'rownumberer', summaryType: 'count', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {text: "再融资债券主单id", dataIndex: "BILL_ID", width: 200, type: "string", hidden: true},
    {text: "申报批次_id", dataIndex: "BATCH_NO", width: 200, type: "string", hidden: true},
    {text: "申报批次", dataIndex: "BATCH_NO_NAME", width: 300, type: "string"},
    {text: "地区code", dataIndex: "AD_CODE", width: 150, type: 'string', hidden: true},
    {text: "申报地区", dataIndex: "AD_NAME", width: 150, type: "string"},
    {text: "申请类型_id", dataIndex: "BOND_TYPE_ID", width: 200, type: "string", hidden: true},
    {text: "申请类型", dataIndex: "BOND_TYPE_ID_NAME", width: 150, type: "string"},

    {
        text: "申请总金额(万元)", dataIndex: "APPLY_AMT", width: 150, type: "float", summaryType: 'sum',
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 2
        },
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "新增债券申请金额(万元)", dataIndex: "APPLY_XZ_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 2
        },
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "置换债券申请金额(万元)", dataIndex: "APPLY_ZH_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 2
        },
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {text: "申报日期", dataIndex: "APPLY_DATE", width: 100, type: "string"},
    {text: "经办人", dataIndex: "APPLY_INPUTOR", width: 150, type: "string"},
    {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}
];

function initContentGrid() {
    var headerJson = HEADERJSON2;
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '50%',
        flex: 1,
        dataUrl: '/JxhjMainGrid.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        params: {
            NODE_CODE: node_code,
            AD_CODE: USER_AD_CODE,
            WF_STATUS: WF_STATUS,
            USERCODE: USER_AD_CODE,
            WF_ID: wf_id
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt2_3),
                width: 110,
                labelWidth: 30,
                editable: false,
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                allowBlank: false,
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(json_common.items[WF_STATUS]);
                        reloadMain();
                        if (newValue == '002') {
                            var save_button = Ext.ComponentQuery.query('button[itemId="save_button"]')[0];
                            if (save_button != null && save_button != undefined) {
                                save_button.setDisabled(true);
                            }
                            var cancel_button = Ext.ComponentQuery.query('button[itemId="cancel_button"]')[0];
                            if (cancel_button != null && cancel_button != undefined) {
                                cancel_button.setDisabled(true);
                            }
                        } else if (newValue == '001') {
                            var save_button = Ext.ComponentQuery.query('button[itemId="save_button"]')[0];
                            if (save_button != null && save_button != undefined) {
                                save_button.setDisabled(false);
                            }
                            var cancel_button = Ext.ComponentQuery.query('button[itemId="cancel_button"]')[0];
                            if (cancel_button != null && cancel_button != undefined) {
                                cancel_button.setDisabled(false);
                            }
                        }

                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '申报批次',
                displayField: 'name',
                valueField: 'id',
                name: 'BATCH_NO',
                store: batch_no_store2,
                editable: false,
                width: 400,
                labelWidth: 70,
                labelAlign: 'right',
                selectModel: 'leaf',
                listeners: {
                    select: function (combo, record, index) {
                        reloadMain();
                    }
                }
            }
        ],
        features: [{
            ftype: 'summary'
        }],
        listeners: {
            itemclick: function (self, record) {
                var mx_grid2 = DSYGrid.getGrid("contentGrid_detail");
                mx_grid2.getStore().getProxy().extraParams = {
                    BILL_ID: record.get("BILL_ID"),
                    IS_XJ_FIND: '1',
                    AD_CODE_BILL: record.get("AD_CODE")
                };
                mx_grid2.getStore().loadPage(1);
            }
        }
    });
}

var HEADERJSON_mx = [
    {
        xtype: 'rownumberer', summaryType: 'count', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {
        text: "审核状态", dataIndex: "SBZT", type: "string", width: 120, tdCls: 'grid-cell',
        renderer: function (value, metadata, record) {
            if (value == null || value == '') {
                record.data.SBZT = 1;
                value = 1;
            }
            var rec = store_shyj.findRecord('code', value, 0, false, true, true);
            return rec.get('name');
        },
        editor: {
            xtype: 'combobox',
            displayField: 'name',
            valueField: 'code',
            editable: false,
            store: store_shyj
        }
    },
    {text: "审核意见", dataIndex: "SBYJ", width: 200, type: "string", editor: 'textfield', tdCls: 'grid-cell'},
    {text: "明细id", dataIndex: "BILL_DTL_ID", width: 200, type: "string", hidden: true},
    {text: "再融资债券单编码", dataIndex: "BILL_NO", width: 200, type: "string", hidden: true},
    {
        text: "债券/债务名称", dataIndex: "ZQ_NAME", type: "string", width: 400, tdCls: 'grid-cell-unedit', hidden: false,
        renderer: function (data, cell, record) {
            if (record.get('DATA_TYPE') == 'ZW') {
                var url = '/page/debt/common/zwyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "zw_id";
                paramNames[1] = "zwlb_id";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            } else {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = AD_CODE;
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        }
    },
    {
        text: "申请金额(万元)",
        dataIndex: "APPLY_AMT",
        width: 150,
        type: "float",
        summaryType: 'sum',
        tdCls: 'grid-cell-unedit',
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 6
        },
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
    },
    {
        text: "新增债券申请金额(万元)",
        dataIndex: "APPLY_XZ_AMT",
        width: 200,
        type: "float",
        summaryType: 'sum',
        tdCls: 'grid-cell',
        hidden: true,
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 6
        },
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
    },
    {
        text: "置换债券申请金额(万元)",
        dataIndex: "APPLY_ZH_AMT",
        width: 200,
        type: "float",
        summaryType: 'sum',
        tdCls: 'grid-cell',
        hidden: true,
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 6
        },
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        }
    },
    {text: "到期日期", dataIndex: "DF_END_DATE", width: 100, type: "string", tdCls: 'grid-cell-unedit'},
    {
        text: "到期金额(万元)",
        dataIndex: "PLAN_AMT",
        width: 150,
        type: "float",
        tdCls: 'grid-cell-unedit',
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 6
        },
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        }
    },
    {
        text: "新增债券到期金额(万元)",
        dataIndex: "PLAN_XZ_AMT",
        width: 200,
        type: "float",
        summaryType: 'sum',
        tdCls: 'grid-cell-unedit',
        hidden: true,
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 6
        },
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        }
    },
    {
        text: "置换债券到期金额(万元)",
        dataIndex: "PLAN_ZH_AMT",
        width: 180,
        type: "float",
        summaryType: 'sum',
        tdCls: 'grid-cell-unedit',
        hidden: true,
        editor: {
            xtype: 'numberFieldFormat',
            hideTrigger: true,
            allowDecimals: true,
            decimalPrecision: 6
        },
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        }
    },
    {text: "已申报总金额", dataIndex: "SUM_AMT", width: 150, type: "float", hidden: true},
    {text: "已申报新增金额", dataIndex: "SUM_XZ_AMT", width: 150, type: "float", hidden: true},
    {text: "已申报置换金额", dataIndex: "SUM_ZH_AMT", width: 150, type: "float", hidden: true},
    {text: "已申报总金额check", dataIndex: "SUM_AMT_CHECK", width: 150, type: "float", hidden: true},
    {text: "已申报新增金额check", dataIndex: "SUM_XZ_AMT_CHECK", width: 150, type: "float", hidden: true},
    {text: "已申报置换金额check", dataIndex: "SUM_ZH_AMT_CHECK", width: 150, type: "float", hidden: true},
    {text: "剩余总金额", dataIndex: "SY_SUM_AMT", width: 150, type: "float", hidden: true},
    {text: "剩余总金额", dataIndex: "SY_SUM_ZH_AMT", width: 150, type: "float", hidden: true},
    {text: "剩余新增金额", dataIndex: "SY_SUM_XZ_AMT", width: 150, type: "float", hidden: true},
    {text: "上级审核意见", dataIndex: "SBYJ", width: 200, type: "string", tdCls: 'grid-cell-unedit'},
    {text: "备注", dataIndex: "REMARK", width: 200, type: "string", tdCls: 'grid-cell-unedit'},
    {text: "ZW_ID", dataIndex: "ZW_ID", width: 100, type: "string", hidden: true},
    {text: "ZWLB_ID", dataIndex: "ZWLB_ID", width: 100, type: "string", hidden: true},
    {text: "DATA_TYPE", dataIndex: "DATA_TYPE", width: 100, type: "string", hidden: true}
]

function initContentDetilGrid() {
    var headerJson = HEADERJSON_mx;
    return DSYGrid.createGrid({
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        checkBox: true,
        border: false,
        height: '50%',
        flex: 1,
        dataUrl: '/JxhjMainMx.action',
        params: {
            BILL_ID: '',
            node_type: node_type
        },
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        tbar: [
            {
                text: '保存',
                xtype: 'button',
                itemId: 'save_button',
                name: 'save',
                icon: '/image/sysbutton/save.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var billid = '';
                    var jh_datas = store.getModifiedRecords();
                    var data = store.getData();
                    for (var i = 0; i < data.length; i++) {
                        if (data.items[i].data.SBZT == 0 && (!data.items[i].data.SBYJ || data.items[i].data.SBYJ == '')) {
                            Ext.Msg.alert('提示', '不通过数据必须填写审核意见！');
                            return false;
                        }
                    }
                    for (var i = 0; i < jh_datas.length; i++) {
                        delete jh_datas[i].data.SB_AD_CODE
                        jh_datas[i] = jh_datas[i].data;
                        if (jh_datas[i].SB_AD_CODE == null || jh_datas[i].SB_AD_CODE == "" || jh_datas[i].SB_AD_CODE == undefined) {
                            jh_datas[i].SB_AD_CODE = "NULL";
                        }
                        billid = jh_datas[i].BILL_ID;
                    }
                    ///发送ajax请求，修改计划信息
                    $.post("/updatexiugai.action", {
                        updateData: Ext.util.JSON.encode(jh_datas),
                        USERCODE: USER_AD_CODE,
                        NODE_CODE: node_code,
                        WF_ID: wf_id
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: "保存成功！" + (data.message ? data.message : ''),
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新主表格
                            var contentStore = DSYGrid.getGrid('contentGrid').getStore();
                            // 选中之前选中行
                            contentStore.load(function (data) {
                                for (var i = 0; i < data.length; i++) {
                                    if (billid == data[i].get('BILL_ID')) {
                                        var contentGrid = DSYGrid.getGrid('contentGrid');
                                        contentGrid.getSelectionModel().select(data[i]);
                                        return false;
                                    }
                                }
                            });
                            //刷新明细表格
                            store.getProxy().extraParams['BILL_ID'] = billid;
                            store.loadPage(1);
                            //store.loadPage(1);
                        } else {
                            Ext.MessageBox.alert('提示', /*button_name + '失败！' +*/ data.message);
                        }
                    }, "json");
                }
            },
            {
                text: '取消',
                xtype: 'button',
                itemId: "cancel_button",
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var data = store.getData();
                    if (data.length <= 0) {
                        Ext.Msg.alert('提示', '请选择一条数据！');
                        return false;
                    }
                    store.rejectChanges();
                }
            }
        ],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if (WF_STATUS != '001') {
                            return false;
                        }
                        //如果审核状态是不通过，并且下级审核不通过区划不是当前用户区划，不能修改
                        if (context.field == 'SBZT' || context.field == 'SBYJ') {
                            if (context.record.get('SB_AD_CODE') && context.record.get('SB_AD_CODE') != USER_AD_CODE)
                                return false;
                        }

                        if (context.field == 'SBZT' || context.field == 'SBYJ'/*||context.field =='APPLY_XZ_AMT'||context.field =='APPLY_ZH_AMT'*/) {
                            return true;
                        } else {
                            return false;
                        }
                    },
                    'validateedit': function (editor, context) {
                        /*//APPLY_XZ_AMT APPLY_AMT APPLY_ZH_AMT
                        //SY_SUM_AMT  SY_SUM_ZH_AMT SY_SUM_XZ_AMT
                        //SUM_AMT_CHECK SUM_XZ_AMT_CHECK SUM_ZH_AMT_CHECK
                          var SUM_XZ_AMT_CHECK=context.record.get("SUM_XZ_AMT_CHECK");
                          if(SUM_XZ_AMT_CHECK==null||SUM_XZ_AMT_CHECK==undefined){
                              SUM_XZ_AMT_CHECK=0;
                          }
                          var SUM_ZH_AMT_CHECK=context.record.get("SUM_ZH_AMT_CHECK");
                          if(SUM_ZH_AMT_CHECK==null||SUM_ZH_AMT_CHECK==undefined){
                              SUM_ZH_AMT_CHECK=0;
                          }
                          var SUM_AMT_CHECK=context.record.get("SUM_AMT_CHECK");
                          if(SUM_AMT_CHECK==null||SUM_AMT_CHECK==undefined){
                              SUM_AMT_CHECK=0;
                          }
                          var APPLY_XZ_AMT=context.record.get("APPLY_XZ_AMT");
                          var APPLY_ZH_AMT=context.record.get("APPLY_ZH_AMT");

                          if(context.field=='APPLY_XZ_AMT'){
                              if(context.value !=null&&context.value !=undefined){
                                  if(context.value >SUM_XZ_AMT_CHECK){
                                      Ext.toast({
                                          html: "修改的新增债券金额不能大于剩余可用新增金额",
                                          closable: false,
                                          align: 't',
                                          slideInDuration: 400,
                                          minWidth: 400
                                      });
                                      return false;
                                  }
                              }
                          }else if(context.field=='APPLY_ZH_AMT'){
                              if(context.value!=null&&context.value!=undefined){
                                  if(context.value>SUM_ZH_AMT_CHECK){
                                      Ext.toast({
                                          html: "修改的置换金额不能大于剩余可用置换金额",
                                          closable: false,
                                          align: 't',
                                          slideInDuration: 400,
                                          minWidth: 400
                                      });
                                      return false;
                                  }
                              }
                          }*/
                    },
                    'edit': function (editor, context) {
                        /*var APPLY_XZ_AMT=context.record.get("APPLY_XZ_AMT");
                        var APPLY_ZH_AMT=context.record.get("APPLY_ZH_AMT");
                        context.record.set('APPLY_AMT',APPLY_XZ_AMT+APPLY_ZH_AMT);*/

                    }
                }
            }
        ]
    });
}

function reloadMain() {
    var main_grid = DSYGrid.getGrid("contentGrid");
    main_grid.getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
    var sbpc = Ext.ComponentQuery.query('treecombobox[name="BATCH_NO"]')[0].getValue();
    if (sbpc != null && sbpc != "" && sbpc != undefined) {
        main_grid.getStore().getProxy().extraParams['SBPC'] = sbpc;
    } else {
        main_grid.getStore().getProxy().extraParams['SBPC'] = "";

    }
    main_grid.getStore().loadPage(1);
    var mx_grid = DSYGrid.getGrid("contentGrid_detail");
    mx_grid.getStore().getProxy().extraParams['BILL_ID'] = '';
    mx_grid.getStore().loadPage(1);
}

function operationRecord() {
    var records = DSYGrid.getGrid('contentGrid_detail').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("BILL_DTL_ID"));
    }
}