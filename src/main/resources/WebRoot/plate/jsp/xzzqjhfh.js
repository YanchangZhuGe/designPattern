/**
 * 默认数据：工具栏
 */
var JG_TYPE = '2';
var ad_code = getQueryParam("adcode");
var is_sj = ad_code.length == 2 ? 1 : 0;//判断是否为省级用户
WF_STATUS = is_sj == 1 && is_fxjh == '5' ? '005' : '001';
var json_debt_zt = is_sj == '1' ? [
    {"id": "005", "code": "005", "name": "未推送"},
    {"id": "006", "code": "006", "name": "已推送"},
    {"id": "002", "code": "002", "name": "已审核"}
] : [
    {"id": "001", "code": "001", "name": "未审核"},
    {"id": "002", "code": "002", "name": "已审核"}
];
$.extend(zqxm_json_common, {
    items: is_zjfp == 0 ? {
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
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '淘汰',
                name: 'out',
                icon: '/image/sysbutton/weedout.png',
                hidden: true,
                handler: function (btn) {
                    doOut(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '文档自动评审',
                icon: '/image/sysbutton/audit.png',
                hidden: true,
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    } else {
                        var ids = [];
                        var xm_ids = [];
                        for (var i in records) {
                            ids.push(records[i].get("ID"));
                            xm_ids.push(records[i].get("XM_ID"));
                        }
                        button_name = btn.text;
                        button_status = btn.name;

                        $.post("/checkFilePsyjResult.action", {
                            workflow_direction: btn.name,
                            is_fxjh: is_fxjh,
                            ids: ids,
                            xm_ids: xm_ids
                        }, function (data) {
                            if (data.success) {
                                Ext.create('Ext.window.Window', {
                                    itemId: 'window_psjg', // 窗口标识
                                    name: 'psjgWin',
                                    title: "评审建议框", // 窗口标题
                                    width: document.body.clientWidth * 0.9, //自适应窗口宽度
                                    height: document.body.clientHeight * 0.95, //自适应窗口高度
                                    layout: 'fit',
                                    maximizable: true,
                                    buttonAlign: 'right', // 按钮显示的位置
                                    modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                                    closeAction: 'destroy',
                                    items: [initWindow_psjg_contentGrid()],
                                    buttons: [
                                        {
                                            text: '取消',
                                            handler: function (btn) {
                                                btn.up('window').close();
                                            }
                                        }
                                    ]
                                }).show();
                                DSYGrid.getGrid('itemid_psjg_grid').insertData(null, data.list);
                            } else {
                                Ext.MessageBox.alert('提示', data.message);
                            }
                        }, "json");

                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
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
                text: '撤销',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up_zjzs',
                hidden: ((is_fxjh == '1' || is_fxjh == '3') && is_zxzqxt == '1' && is_zxzq == '1' && USER_AD_CODE.replace("00", "").length == 2) ? false : true,
                disabled: is_zjzswtg == '2' ? false : true,
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
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
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '淘汰',
                name: 'out',
                icon: '/image/sysbutton/weedout.png',
                hidden: true,
                handler: function (btn) {
                    doOut(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
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
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },

            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '005': [
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
                text: '推送',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (!records || records.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    } else {
                        initWindow_csshWindow().show();
                    }
                }
            },
            {
                xtype: 'button',
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '006': [
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
                text: '撤销推送',
                itemId: 'down',
                name: 'cancel',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                    //删除推送信息
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/weedout.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    } : (is_zjfp == 1 ? {
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
                text: '分配',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
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
                text: '撤销',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
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
                text: '分配',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    } : {
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
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/preview.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
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
                text: '撤销',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }),
    items_content_rightPanel_items: function () {
        //专项债券系统不控制限额或者菜单为限额资金初审时，不显示限额页签
        if (SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
            return [
                {
                    xtype: 'panel',
                    layout: 'vbox',
                    width: '100%',
                    height: '100%',
                    flex: 1,
                    items: [
                        initContentXeGrid(),
                        initContentGrid()
                    ]
                }
            ]
        }
        // is_fxjh == '3' 或 (is_fxjh == '5' 且 省级用户)
        if (is_fxjh == '3' || (is_fxjh == '5' && USER_AD_CODE.length == 2)) {
            return [
                initContentGrid(),
                initfjPanel()
            ];
        }
        return [
            {
                xtype: 'panel',
                layout: 'vbox',
                width: '100%',
                height: '100%',
                flex: 1,
                items: [
                    initContentGrid()
                ]
            }
        ]
    },
    item_content_grid_config: {
        border: true,
        // anchor: '100% -75',
        flex: 1,
        width: '100%',
        dataUrl: '/getXzzqContentGrid.action',
        params: {
            is_fxjh: is_fxjh,
            bond_type_id: bond_type_id,
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            IS_ZXZQXT: is_zxzqxt,
            IS_ZXZQ: is_zxzq,
            menucode: menucode,
            node_type: node_type,
            IS_ZJZSWTG: is_zjzswtg,
            is_zjfp: is_zjfp,
            HAVE_SFJG: HAVE_SFJG
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: is_fxjh != 5 ? DebtEleStore(json_zt) : DebtEleStore(json_debt_zt),
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
                        toolbar.add(zqxm_json_common.items[WF_STATUS]);
                        Button_show();
                        //刷新当前表格
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["IS_ZJZSWTG"] = is_zjzswtg;
                        reloadGrid();
                        //2021071309 zhuangrx 储备和初审有附件上传框，其余流程没有以免报错
                        if (is_fxjh == '3' || is_fxjh == '5') {
                            DSYGrid.getGrid('fjckGrid').getStore().removeAll(); // 清除附件框缓存
                        }
                    }
                }
            },
            {
                fieldLabel: '债券类型',
                name: 'BOND_TYPE_ID',
                xtype: 'treecombobox',
                //store: is_zxzqxt == 1 ? (is_zxzq=='1'?DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE LIKE '02%'"}):DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE NOT LIKE '02%'"})):DebtEleTreeStoreDB('DEBT_ZQLB'),
                store: DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND GUID != '0201' "}),
                displayField: 'name',
                valueField: 'id',
                labelWidth: 60,
                width: 180,
                hidden: is_fxjh == 5 ? true : false,
                value: bond_type_id,
                editable: false,
                listeners: {
                    'change': function (self, newValue) {
                        bond_type_id = newValue;
                        reloadGrid();
                    }
                }
            }, {
                xtype: 'fieldset',
                layout: 'column',
                name: 'zjzswtg',
                defaultType: 'textfield',
                hidden: true,
                border: false,
                padding: '0 0 0 0',
                defaults: {
                    labelWidth: 150,
                    margin: '0 1 2 20'
                },
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '专家终审状态',
                        name: 'IS_ZJZSWTG',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                        allowBlank: true,
                        selectModel: "leaf",
                        labelAlign: 'right',//控件默认标签对齐方式
                        store: store_tgzt,
                        listeners: {
                            'change': function (self, newValue) {
                                is_zjzswtg = newValue;
                                Button_show();
                                DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["IS_ZJZSWTG"] = is_zjzswtg;
                                reloadGrid();
                            }
                        }
                    }
                ]
            },
            {
                text: '保存',
                name: 'save',
                xtype: 'button',
                icon: '/image/sysbutton/save.png',
                hidden: is_zjfp != 1,
                handler: function (btn) {
                    var records = btn.up('grid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.show({
                            title: "提示",
                            msg: "是否保存选中数据的分配金额？",
                            buttons: Ext.MessageBox.OKCANCEL,
                            fn: function (btn, text) {
                                if (btn == "ok") {
                                    var bill_ids = [];
                                    var fp_amts = [];
                                    for (var i in records) {
                                        bill_ids.push(records[i].get("ID"));
                                        fp_amts.push(records[i].get("APPLY_AMOUNT1"));
                                    }
                                    ///发送ajax请求，修改分配金额
                                    $.post("/updateFpAmt.action", {
                                        bill_ids: Ext.util.JSON.encode(bill_ids),
                                        fp_amts: Ext.util.JSON.encode(fp_amts)
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({
                                                html: "保存成功！" + (data.message ? data.message : ''),
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                            for (var i in records) {
                                                // 创建行model实例
                                                records[i].set('IS_SAVE', '1');
                                            }
                                        } else {
                                            Ext.MessageBox.alert('提示', '保存失败！' + data.message);
                                        }
                                    }, "json");
                                }
                            }
                        })
                    }
                }
            },
            {
                text: '取消',
                name: 'cancel',
                xtype: 'button',
                hidden: is_zjfp != 1,
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var records = btn.up('grid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.show({
                            title: "提示",
                            msg: "是否取消修改选中数据的分配金额？",
                            buttons: Ext.MessageBox.OKCANCEL,
                            fn: function (btns, text) {
                                if (btns == "ok") {
                                    var store = btn.up('grid').getSelectionModel().getStore();
                                    store.rejectChanges();
                                    store.load();
                                }
                            }
                        })
                    }
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
                        if (context.field == 'APPLY_AMOUNT1' && !(is_zjfp == 1 && (WF_STATUS == '001' || WF_STATUS == '004'))) {
                            return false;
                        }
                        if (context.field == 'FP_AMT') {
                            return false;
                        }
                    },
                    'edit': function (editor, context) {
                        if (context.field == 'APPLY_AMOUNT1') {
                            if (context.value <= 0) {
                                Ext.Msg.alert('提示', '分配金额必须大于0！');
                                return false;
                            }
                            context.record.set("IS_SAVE", '0');
                        }
                    }
                }
            }
        ],
        listeners: {
            select: function (self, record, index, eOpts) {

            },
            itemclick: function (self, record) {
                // 项目列表点击事件

                initWindow_xmfj(record.get("XM_ID"));
                DSYGrid.getGrid('fjckGrid').getStore().getProxy().extraParams['busi_id'] = record.get("XM_ID");
                DSYGrid.getGrid('fjckGrid').getStore().removeAll();
                DSYGrid.getGrid('fjckGrid').getStore().load();
            }
        }
    },
    // TODO 加载
    reloadGrid: function () {
        var grid = DSYGrid.getGrid('contentGrid');
        if (grid) {
            var store = grid.getStore();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["bond_type_id"] = bond_type_id;
            if (SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
                //刷新限额表格,置为空
                var store_details = DSYGrid.getGrid('contentXEGrid').getStore();
                //如果传递参数不为空，就刷新明细表格
                store_details.getProxy().extraParams["AD_CODE"] = AD_CODE;
                store_details.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
                store_details.load();
                store.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
            } else {
                store.getProxy().extraParams["SET_YEAR"] = null;
            }
            store.load();
        }
        Button_show();
    }

});

function initWindow_csshWindow() {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_skxx', // 窗口标识
        name: 'jgxxWin',
        title: '初审机构选择', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.95, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        items: JGxxTab(node_code),
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    // 获取选中数据
                    /* var records = DSYGrid.getGrid('winGrid').getSelection();
                     if (records.length != 1) {
                         Ext.MessageBox.alert('提示', '只能选择一条数据');
                         return;
                     }*/
                    sendjgxxdata(btn);
                    btn.setDisabled(true);
                    btn.up('window').close();
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

function JGxxTab(node_code) {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: 388,
        itemId: 'cxtForm',
        layout: 'fit',
        scrollable: true,
        border: false,
        padding: '2 2 2 2',
        items: [init_jgxx_grid(node_code)]

    });
}

function refresh_jgxxGrid() {
    cxt_id = Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].value;
    var store = DSYGrid.getGrid('jgxxGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        CXT_ID: cxt_id
    };
    //刷新表格内容
    store.loadPage(1);
}

/**
 * 文档自动评审结果及意见展示框
 */
function initWindow_psjg_contentGrid() {
    var content_HeaderJson = [
        {
            dataIndex: "XM_NAME",
            type: "string",
            text: "项目名称",
            columnCls: 'normal',
            align: 'center',
            width: 300
        },
        {
            dataIndex: "XM_RESULT",
            type: "string",
            text: "评审结果",
            columnCls: 'normal',
            width: 600,
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                return value;
            }
        },
        {
            dataIndex: "XM_JXL",
            type: "string",
            text: "符合率",
            align: 'center',
            width: 100
        },
        {
            dataIndex: "XM_JY",
            type: "string",
            text: "评审建议",
            align: 'center',
            width: 300,
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                return value;
            }
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'itemid_psjg_grid',
        border: false,
        flex: 1,
        data: [],
        autoScroll: true,
        checkBox: false,
        headerConfig: {
            headerJson: content_HeaderJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: []

    };
    //生成表格
    var grid = DSYGrid.createGrid(config);

    return grid;
}

/**
 * 初始化右侧主表格
 */
function initContentXeGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "XE_ID", width: 100, type: "string", text: "ID", hidden: true},
        {dataIndex: "SET_YEAR", width: 80, type: "string", text: "年度"},
        {dataIndex: "AD_CODE", width: 100, type: "string", text: "区划编码", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "区划名称"},
        {
            dataIndex: "XZYB",
            width: 150,
            type: "float",
            hidden: is_zxzqxt == '1' && is_zxzq == '1' ? true : false,
            text: "新增一般债券限额(万元)",
            columns: [
                {
                    dataIndex: "XZ_YBZQ_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_YB_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_YB_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX",
            width: 150,
            type: "float",
            text: "新增专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? true : false,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_TC",
            width: 150,
            type: "float",
            text: "新增土地储备专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_TC_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_TC_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_TC_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_GL",
            width: 150,
            type: "float",
            text: "新增收费公路专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_GL_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_GL_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_GL_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_PG",
            width: 150,
            type: "float",
            text: "新增棚改专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_PG_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_PG_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_PG_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_QT",
            width: 150,
            type: "float",
            text: "新增其他专项债券限额（万元）",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_QT_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_QT_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_QT_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentXEGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        border: false,
        autoLoad: false,
        height: 150,
        width: '100%',
        dataUrl: '/getDqxeData.action',
        params: {
            SET_YEAR: '',
            BUSI_TYPE: '0',
            is_zjfp: is_zjfp
        },
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                fieldLabel: '年度',
                xtype: 'combobox',
                name: 'SET_YEAR',
                value: new Date().getUTCFullYear(),
                width: 145,
                editable: false,
                labelWidth: 30,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                displayField: 'name',
                valueField: 'code',
                allowBlank: false,
                // store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '" + (parseInt(SET_YEAR) - 1) + "'"}),
                //store: DebtEleStore(json_debt_year),
                store: DebtEleStore(getYearList({start: -5, end: 5})),
                listeners: {
                    change: function (self, newValue) {
                        SET_YEAR = newValue;
                        reloadGrid();
                    }
                }
            }
        ]
    });
}

/**
 * 淘汰
 */
function doOut() {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录!');
        return;
    }
    //获取新增债券表格
    var xzzqArray = [];
    DSYGrid.getGrid("contentGrid").getStore().each(function (record) {
        xzzqArray.push(record.getData());
    });
    //发送ajax请求，提交数据
    $.post('outXzzq.action', {
        wf_id: wf_id,
        node_code: node_code,
        button_name: '淘汰',
        xzzqArray: Ext.util.JSON.encode(xzzqArray)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: "淘汰成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        //刷新表格
        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
    }, "json");
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    //资金分配初审审核时需先校验是否已保存分配金额

    //if(is_zxzqxt=='1' && is_zxzq == '1' && (is_fxjh == '1'||is_fxjh=='3') && btn.name=='down' && is_zjfp==0 ){
    if (((HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) && btn.name == 'down' && is_zjfp == 0) {
        if (records.length != 1) {
            Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
            return false;
        }
    } else {
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return false;
        }
        if (is_zjfp == 1 && (WF_STATUS == '001' || WF_STATUS == '004')) {
            for (var i in records) {
                if (records[i].get("IS_SAVE") != '1') {
                    Ext.MessageBox.alert('提示', '请先保存或取消选中的第' + (Number(i) + 1) + '条数据的分配金额！');
                    return false;
                }
            }
        }
    }
    var ids = [];
    var xm_ids = [];
    var is_ends = [];
    var mb_ids = [];
    for (var i in records) {
        ids.push(records[i].get("ID"));
        xm_ids.push(records[i].get("XM_ID"));
        is_ends.push(records[i].get("IS_END"));
        mb_ids.push(records[i].get("MB_ID"));
    }
    var zqlxIds = [];//BOND_TYPE_ID
    //限额库 送审时执行
    if (((HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) && btn.name === 'down') {
        //获取债券类型
        for (var i in records) {
            zqlxIds.push(records[i].get("BOND_TYPE_ID"));
        }
        //对获取的ZQLX_ID去重 借助indexOf()方法判断此元素在该数组中首次出现的位置下标与循环的下标是否相等
        if (zqlxIds.length > 1) {
            for (var i = 0; i < zqlxIds.length; i++) {
                if (zqlxIds.indexOf(zqlxIds[i]) != i) {
                    zqlxIds.splice(i, 1);//删除数组元素后数组长度减1后面的元素前移
                    i--;//数组下标回退
                }
            }
        }
    }
    button_name = btn.text;
    //校验当前复核债券申请累加不能超出当前地区债券限额
    //根据债券类型累加债券金额
    if (btn.name === 'down' && node_type === 'jhfh' && SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
        var xeRec = DSYGrid.getGrid('contentXEGrid').getStore();
        if (zxxekz(records)) {
            //if( USER_AD_CODE == sysAdcode && is_zxzqxt =='1' && is_zxzq=='1'&& is_zjfp==0){
            if (USER_AD_CODE == sysAdcode && is_zjfp == 0) {
                btn.BOND_TYPE_ID = records[0].get('BOND_TYPE_ID');
                if (((HAVE_SFJG == '2' || HAVE_SFJG == '3') && is_fxjh == '1') && btn.BOND_TYPE_ID.substr(0, 2) == '02') {
                    if (is_zj == '1') {
                        showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
                    } else {
                        initWindow_zjSelect(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids);
                    }

                } else {
                    showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
                }
            } else {
                showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
            }
        } else {
            return false;
        }

        /*if (SYS_XZZQJH_XE_CHECK === '2') {
            var xeRec = DSYGrid.getGrid('contentXEGrid').getStore();
            if (xeRec.getCount() <= 0) {
                Ext.MessageBox.alert('提示', '限额为空！');
                return false;
            }
            var ybxe = xeRec.getAt(0).get('SY_YB_AMT')/10000;
            var zxxe = xeRec.getAt(0).get('SY_ZX_AMT')/10000;
            var yb = null;
            var zx = null;
            for (var i in records) {
                if (records[i].get("BOND_TYPE_ID") == '01') {
                    yb = yb ? yb : 0;
                    yb += records[i].get("APPLY_AMOUNT1");
                } else {
                    zx = zx ? zx : 0;
                    zx += records[i].get("APPLY_AMOUNT1");
                }
            }
            if (yb && yb > ybxe) {
                Ext.MessageBox.alert('提示', '超出一般债券剩余限额!');
                return false;
            }
            if (zx && zx > zxxe) {
                Ext.MessageBox.alert('提示', '超出专项债券剩余限额!');
                return false;
            }
            showOpinion(btn, ids, xm_ids,zqlxIds);
        } else if (SYS_XZZQJH_XE_CHECK === '1') {//提示性控制
            var xeRec = DSYGrid.getGrid('contentXEGrid').getStore();
            if (xeRec.getCount() <= 0) {
                Ext.MessageBox.confirm('提示', '限额为空！是否继续？', function (btn_yn) {
                    if (btn_yn === 'yes') {
                        showOpinion(btn, ids, xm_ids,zqlxIds);
                    }
                });
            } else {
                var ybxe = xeRec.getAt(0).get('SY_YB_AMT');
                var zxxe = xeRec.getAt(0).get('SY_ZX_AMT');
                var yb = null;
                var zx = null;
                for (var i in records) {
                    if (records[i].get("BOND_TYPE_ID") === '01') {
                        yb = yb ? yb : 0;
                        yb += records[i].get("APPLY_AMOUNT1");
                    } else {
                        zx = zx ? zx : 0;
                        zx += records[i].get("APPLY_AMOUNT1");
                    }
                }
                if (yb && yb > ybxe) {
                    Ext.MessageBox.confirm('提示', '超出一般债券剩余限额,是否继续？', function (btn_yn) {
                        if (btn_yn === 'yes') {
                            showOpinion(btn, ids, xm_ids,zqlxIds);
                        }
                    });
                    return false;
                }
                if (zx && zx > zxxe) {
                    Ext.MessageBox.confirm('提示', '超出专项债券剩余限额,是否继续？', function (btn_yn) {
                        if (btn_yn === 'yes') {
                            showOpinion(btn, ids, xm_ids,zqlxIds);
                        }
                    });
                    return false;
                }
                showOpinion(btn, ids, xm_ids,zqlxIds);
            }
        }*/
    } else {
        //if(btn.name == 'down' && node_type == 'jhfh' && USER_AD_CODE == sysAdcode && is_zxzqxt =='1' && is_zxzq=='1' && is_zjfp==0){
        if (btn.name == 'down' && node_type == 'jhfh' && USER_AD_CODE == sysAdcode && is_zjfp == 0) {
            btn.BOND_TYPE_ID = records[0].get('BOND_TYPE_ID');
            if (((HAVE_SFJG == '1' || HAVE_SFJG == '3') && is_fxjh == '3') && btn.BOND_TYPE_ID.substr(0, 2) == '02') {
                if (is_zj == '1') {
                    if (xmTyle && ywTyle) {
                        zjxzEditWindowFh.show("增加评审专家", btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
                    } else {
                        showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
                    }
                } else {
                    initWindow_zjSelect(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids);
                }

            } else {
                showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
            }
        } else {
            showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
        }
    }
}

// 选择专家弹框-本级审核
var zjxzEditWindowFh = {
    window: null,
    show: function (title, SHbtn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, pfbzarray) {
        this.window = Ext.create('Ext.window.Window', {
            title: title,
            itemId: 'pszj',
            // width: document.body.clientWidth * 0.6,
            // height: document.body.clientHeight * 0.5,
            width: 950,
            height: 550,
            layout: 'fit',
            maximizable: true,
            frame: true,
            constrain: true,
            buttonAlign: "right", // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            items: [xmjxfjpzTab()],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    name: 'btn_update',
                    id: 'save',
                    handler: function (btn) {
                        savePszjFh(btn, SHbtn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, pfbzarray)
                    }
                }, {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        this.window.show();
    }
};

// 保存
function savePszjFh(btn, SHbtn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, pfbzarray) {
    btn.setDisabled(true);

    // 获取项目信息
    // var xmgrid = DSYGrid.getGrid('contentGrid').getStore();
    var xmgrid = DSYGrid.getGrid('contentGrid').getSelection();
    var xm_store_data = new Array();
    for (var i = 0; i < xmgrid.length; i++) {
        xm_store_data.push(xmgrid[i].data.ID); // 审批单据 ID
    }

    // 获取专家信息
    var zjgrid = DSYGrid.getGrid('pszjGrid').getSelection();
    var zj_store_data = new Array();
    if (zjgrid.length == 0) {
        // 校验必录
        Ext.Msg.alert('提示', "请选择专家！");
        btn.setDisabled(false);
        return;
    }
    for (var i = 0; i < zjgrid.length; i++) {
        zj_store_data.push(zjgrid[i].data.PSZJ_ID); // 专家 PSZJ_ID
    }

    $.post('/savePSZJ.action', {
        button_name: btn.name,//增加还是编辑
        button_text: btn.text,//增加还是编辑
        XM_STORE: Ext.util.JSON.encode(xm_store_data),
        ZJ_STORE: Ext.util.JSON.encode(zj_store_data)

    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            // 打开审核弹框
            showOpinion(SHbtn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, pfbzarray);
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
    }, 'JSON');
}

/**
 * DEBT_ZXXEKZFS 专项限额控制方式：0：不分类控制；1：分类控制
 * SYS_XZZQJH_XE_CHECK（限额是否强控制）
 *限额控制*/
function zxxekz(records) {
    var xeRec = DSYGrid.getGrid('contentXEGrid').getStore();
    if (xeRec.getCount() <= 0) {
        return xeqkz('限额为空！');
    }
    var ybxe = xeRec.getAt(0).get('SY_YB_AMT') / 10000;
    var yb = null;
    if (DEBT_ZXXEKZFS == '1') {//专项限额控制方式
        var zx_tcxe = xeRec.getAt(0).get('SY_ZX_TC_AMT') / 10000;//土储剩余限额
        var zx_glxe = xeRec.getAt(0).get('SY_ZX_GL_AMT') / 10000;//公路剩余限额
        var zx_pgxe = xeRec.getAt(0).get('SY_ZX_PG_AMT') / 10000;//棚改剩余限额
        var zx_qtxe = xeRec.getAt(0).get('SY_ZX_QT_AMT') / 10000;//其他自平衡、普通专项剩余限额
        var zx_tc = null;
        var zx_gl = null;
        var zx_pg = null;
        var zx_qt = null;
        for (var i in records) {
            if (records[i].get("BOND_TYPE_ID") == '01') {
                yb = yb ? yb : 0;
                yb += records[i].get("APPLY_AMOUNT1");
            } else {
                if (records[i].get("BOND_TYPE_ID") == '020201') {//土地储备
                    zx_tc = zx_tc ? zx_tc : 0;
                    zx_tc += records[i].get("APPLY_AMOUNT1");
                } else if (records[i].get("BOND_TYPE_ID") == '020202') {//收费公路
                    zx_gl = zx_gl ? zx_gl : 0;
                    zx_gl += records[i].get("APPLY_AMOUNT1");
                } else if (records[i].get("BOND_TYPE_ID") == '020203') {//棚改
                    zx_pg = zx_pg ? zx_pg : 0;
                    zx_pg += records[i].get("APPLY_AMOUNT1");
                } else if (records[i].get("BOND_TYPE_ID") == '0201' || records[i].get("BOND_TYPE_ID") == '020299') {//其他自平衡
                    zx_qt = zx_qt ? zx_qt : 0;
                    zx_qt += records[i].get("APPLY_AMOUNT1");
                }
            }
        }
        if (zx_tc && zx_tc > zx_tcxe) {//土地储备
            return xeqkz('超出新增土地储备专项债券剩余限额!');
        } else if (zx_gl && zx_gl > zx_glxe) {//收费公路
            return xeqkz('超出新增收费公路专项债券剩余限额!');
        } else if (zx_pg && zx_pg > zx_pgxe) {//棚改
            return xeqkz('超出新增棚改专项债券剩余限额!');
        } else if (zx_qt && zx_qt > zx_qtxe) {//其他自平衡
            return xeqkz('超出其他专项债券剩余限额!');
        }
    } else {
        var zxxe = xeRec.getAt(0).get('SY_ZX_AMT') / 10000;
        var zx = null;
        for (var i in records) {
            if (records[i].get("BOND_TYPE_ID") == '01') {
                yb = yb ? yb : 0;
                yb += records[i].get("APPLY_AMOUNT1");
            } else {
                zx = zx ? zx : 0;
                zx += records[i].get("APPLY_AMOUNT1");
            }
        }
        if (zx && zx > zxxe) {
            return xeqkz('超出专项债券剩余限额!');
        }
    }
    if (yb && yb > ybxe) {
        return xeqkz('超出一般债券剩余限额!');
    }
    return true;
}

/**
 * 弹出意见填写对话框
 * @param btn
 * @param ids
 */
function showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, pfbzarray) {

    var default_comfig = {
        title: btn.text,
        animateTarget: btn,
        fn: function (buttonId, text) {
            if (text.length > 500) {
                Ext.MessageBox.alert('提示', btn.text + "失败！ 最多不超过500个字符");
                return;
            }
            if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("doXzzqWorkFlow.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    wf_status: WF_STATUS,
                    AD_CODE: AD_CODE,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: text,
                    ids: ids,
                    zqlxIds: zqlxIds,
                    xm_ids: xm_ids,
                    is_zxzqxt: is_zxzqxt,
                    is_zxzq: is_zxzq,
                    is_ends: is_ends,
                    mb_ids: mb_ids,
                    is_fxjh: is_fxjh,//
                    node_type: node_type,
                    menucode: menucode,
                    IS_ZJZSWTG: is_zjzswtg,
                    is_zjfp: is_zjfp,
                    HAVE_PFBZ: HAVE_PFBZ,
                    pszj_id: pszj_id,
                    PFBZARRAY: Ext.util.JSON.encode(pfbzarray),
                    HAVE_SFJG: HAVE_SFJG,
                    GxdzUrlParam: GxdzUrlParam,
                    WF_STATUS: WF_STATUS
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        }
    };
    //只在专项债券系统下的限额库审核时执行
    //if(is_zxzqxt=='1' && is_zxzq == '1' && (is_fxjh == '1'||is_fxjh=='3')&&btn.name == 'down'&&is_zjfp==0){
    if (((HAVE_SFJG == '1' && is_fxjh == '3' && !is_zj == '1') || (HAVE_SFJG == '2' && is_fxjh == '1' && !is_zj == '1')) && btn.name == 'down' && is_zjfp == 0) {
        //先校验是否有评分信息，有的话再显示项目评分信息
        Ext.Ajax.request({
            url: 'isExistPfbz.action',
            async: false,//同步请求
            params: {
                ZQLX_ID: zqlxIds[0],
            },
            success: function (response, opts) {
                var data = Ext.decode(response.responseText);
                if (data.success) {
                    var result = data.result;
                    if (result != undefined) {
                        if ('true' == result) {//若有项目评分信息，则显示项目评分页签
                            //发送请求获取ruleIds，显示配置的附件
                            Ext.Ajax.request({
                                method: 'POST',
                                url: 'getFjRuleIdsByZqlx.action',
                                async: false,//同步请求
                                params: {
                                    ZQLX_ID: zqlxIds[0],
                                },
                                success: function (form, action) {
                                    var data = Ext.util.JSON.decode(form.responseText);
                                    var ruleIds;
                                    if (data.success) {
                                        ruleIds = data.list;//传递一个array对象
                                    } else {
                                        ruleIds = [];
                                    }
                                    var bill_id = ids[0];
                                    var xm_id = xm_ids[0];
                                    var is_end = is_ends[0];
                                    var mb_id = mb_ids[0];
                                    initWin_xmInfo_cp(xm_id, bill_id, btn.name, zqlxIds, ruleIds, is_end, mb_id, pszj_id, pfbzarray);
                                    var zqxxYHSTab = Ext.ComponentQuery.query('panel[itemId="xmxxTab"]')[0];
                                    var tab = zqxxYHSTab.add({
                                        title: "项目评分",
                                        scrollable: true,
                                        items: [initWindow_input_contentForm_xeksh(bill_id, false, zqlxIds[0])]
                                    });
                                    zqxxYHSTab.setActiveTab(tab);
                                },
                                failure: function (form, action) {
                                    var bill_id = ids[0];
                                    var xm_id = xm_ids[0];
                                    var is_end = is_ends[0];
                                    var mb_id = mb_ids[0];
                                    initWin_xmInfo_cp(xm_id, bill_id, btn.name, zqlxIds, [], is_end, mb_id, pszj_id, pfbzarray);
                                    var zqxxYHSTab = Ext.ComponentQuery.query('panel[itemId="xmxxTab"]')[0];
                                    var tab = zqxxYHSTab.add({
                                        title: "项目评分",
                                        scrollable: true,
                                        items: [initWindow_input_contentForm_xeksh(bill_id, false, zqlxIds[0])]
                                    });
                                    zqxxYHSTab.setActiveTab(tab);
                                }
                            });
                        }
                        if ('false' == result) {//若没有，则显示正常意见框
                            initWindow_opinion(default_comfig);
                        }
                    }
                } else {
                    Ext.Msg.alert('提示', "校验失败" + data.message);
                }
            }
        });
    } else {
        initWindow_opinion(default_comfig);
    }
}

/**
 * 校验项目评分表数据，并提交工作流
 * @returns
 */
function checkAndSubmit(xm_id, bill_id, work_direction, btn, zqlxIds, is_end, mb_id, pszj_id, pfbzarray) {
    var xmpfShGrid = Ext.ComponentQuery.query('grid#xekshPf_grid')[0];
    var error_message = null;
    var xmpfShGridArray = [];
    //遍历进行校验
    xmpfShGrid.getStore().each(function (record) {
        var order_no = record.get('PFBZ_ORDER');
        var score = record.get('SCORE');
        if (null == score || '' == score || 'undefined' == score) {
            error_message = '第' + order_no + '个评分项未评分,请检查！';
            return false;
        } else {
            if ('否' == score) {
                error_message = '第' + order_no + '个评分项得分为"否",请重新审核！';
                return false;
            }
        }
        xmpfShGridArray.push(record.getData());
    });
    if (null != error_message && '' != error_message) {
        Ext.Msg.alert('提示', error_message);
        return;
    }
    //发送ajax请求，修改节点信息
    $.post("doXzzqWorkFlow.action", {
        workflow_direction: work_direction,//工作流方向
        wf_id: wf_id,
        AD_CODE: AD_CODE,
        node_code: node_code,
        button_name: button_name,
        audit_info: '同意',
        ids: [bill_id],
        xm_ids: [xm_id],
        zqlxIds: zqlxIds,
        is_ends: [is_end],
        mb_ids: [mb_id],
        is_fxjh: is_fxjh,
        node_type: node_type,
        xmpfShGrid: Ext.util.JSON.encode(xmpfShGridArray),
        is_zxzqxt: is_zxzqxt,
        is_zxzq: is_zxzq,
        menucode: menucode,
        pszj_id: pszj_id,
        HAVE_PFBZ: HAVE_PFBZ,
        PFBZARRAY: Ext.util.JSON.encode(pfbzarray),
        HAVE_SFJG: HAVE_SFJG
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            //关闭窗口
            btn.up('window').close();
        } else {
            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
        }
        //刷新表格
        reloadGrid();
    }, "json");
}

/**
 * @param xm_id
 * @param bill_id
 * @returns
 */
function initWin_xmInfo_cp(xm_id, bill_id, work_direction, zqlxIds, ruleIds, is_end, mb_id, pszj_id, pfbzarray) {

    var zwqxWindow = new Ext.Window({
        title: '项目总体情况',
        //itemId: 'xmxxWin',
        width: document.body.clientWidth * 0.95,
        height: document.body.clientHeight * 0.95,
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        closeAction: 'destroy',
        layout: 'fit',
        items: [initWin_xmInfo_contentForm(tab_items_sh, xm_id, ruleIds)],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    checkAndSubmit(xm_id, bill_id, work_direction, btn, zqlxIds, is_end, mb_id, pszj_id, pfbzarray);
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
    zwqxWindow.show();
    loadXmxxInfo(tab_items_sh, xm_id, bill_id);
}

function initWindow_zjSelect(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids) {
    var zqlx = zqlxIds[0];
    var zjSelect = Ext.create('Ext.window.Window', {
        itemId: 'window_zjxz', // 窗口标识
        name: 'zjxzWin',
        title: '评审专家选择', // 窗口标题
        width: HAVE_PFBZ == '1' ? document.body.clientWidth * 0.9 : document.body.clientWidth * 0.25, //自适应窗口宽度
        height: HAVE_PFBZ == '1' ? document.body.clientHeight * 0.9 : document.body.clientHeight * 0.25, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [
            HAVE_PFBZ == '1' ? init_zxkXmtz_Grid(btn) : {
                xtype: 'form',
                layout: 'anchor',
                defaults: {
                    anchor: '100%',
                    margin: '10 20 0 10'
                },
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '评审专家',
                        name: 'PSZJ_ID',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                        allowBlank: false,
                        flex: 1,
                        autoLoad: false,
                        selectModel: "leaf",
                        labelAlign: 'right',//控件默认标签对齐方式
                        store: ELE_AD_CODE == 42 ? DebtEleStoreTable('DEBT_V_ZQGL_PSZJ', {condition: " and status ='1'"}) : DebtEleStoreTable('DEBT_V_ZQGL_PSZJ', {condition: " and status ='1' and ZQLX_ID=" + zqlx})//湖北修改可选择专家
                    }
                ]
            }
        ],
        buttons: [
            {
                text: '确定',
                handler: function (btns) {
                    /*  var form= btns.up('window').down('form');
                      var pszj_id=form.getForm().findField("PSZJ_ID").value;
                      btns.up('window').close();
                      showOpinion(btn, ids, xm_ids,zqlxIds,is_ends,mb_ids,pszj_id);*/
                    var form = btns.up('window').down('form');
                    if (form && !form.isValid()) {
                        return false;
                    }
                    if (HAVE_PFBZ == '1') {
                        var grid = btns.up('window').down('#item_pfbz_grid').getStore();
                        var pfbzarray = [];
                        for (var m = 0; m < grid.getCount(); m++) {
                            var record = grid.getAt(m);
                            pfbzarray.push(record.data);
                        }
                        btns.up('window').close();
                        showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', pfbzarray);
                    } else {
                        var pszj_id = form.getForm().findField("PSZJ_ID").value;
                        btns.up('window').close();
                        showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, []);
                    }

                }
            },
            {
                text: '取消',
                handler: function (btns) {
                    btns.up('window').close();
                }
            }
        ]
    });
    zjSelect.show();
}

function init_jgxx_grid() {
    //申请填报的主单
    var toolbar_choose_zq = [
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                reload_jm_nh97()
            }
        }
    ];

    function reload_jm_nh97() {
        var dqzq_grid = DSYGrid.getGrid("dqzq_grid");
        var v_temp_1 = Ext.ComponentQuery.query('combobox[name="debt_year"]')[0].getValue();
        var v_temp_2 = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].getValue();
        dqzq_grid.getStore().getProxy().extraParams = {
            DQND: v_temp_1,
            ZQLB: v_temp_2
        };
        dqzq_grid.getStore().loadPage(1);
    }

    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {"dataIndex": "JG_ID", "type": "string", "text": "机构编码", "width": 150, editor: 'textfield', hidden: true},
        {"dataIndex": "JG_CODE", "type": "string", "text": "机构编码", "width": 150, editor: 'textfield'},
        {"dataIndex": "JG_NAME", "type": "string", "text": "机构名称", "width": 200, editor: 'textfield'},
        {"dataIndex": "USER_ID", "type": "string", "text": "用户id", "width": 200, editor: 'textfield', hidden: true}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'dqzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/findcxjgInfo.action',
        autoLoad: true,
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'jxhj_zq_choose_toolbar',
                items: toolbar_choose_zq
            }
        ],
        params: {
            JG_TYPE: JG_TYPE
        }

    });


    return grid;
}

function sendjgxxdata(btn) {
    // 获取选中数据
    var billrecords = DSYGrid.getGrid('contentGrid').getSelection();
    var records = DSYGrid.getGrid('dqzq_grid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    //获取机构id
    var JGIDS = [];
    for (var i in records) {
        JGIDS.push(records[i].get("JG_ID"));
    }
    //获取billid
    var BillID = [];
    for (var i in billrecords) {
        BillID.push(billrecords[i].get("ID"));
    }
    if (JGIDS == " ") {
        Ext.toast({
            html: '请选择机构再推送',
            closable: false, align: 't', slideInDuration: 400, minWidth: 400
        });
    }
    var button_name = btn.text;
    Ext.Msg.confirm('提示', '确认' + '推送' + '选中记录?', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            //发送ajax请求，修改节点信息
            $.post("sendjgxxdata.action", {
                button_name: button_name,
                JGIDS: JGIDS,
                BillID: BillID,
                userCode: userCode,
                node_type: node_type
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: "推送" + "成功！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    reloadGrid();
                } else {
                    Ext.MessageBox.alert('提示', "推送" + '失败！' + data.message);
                }
            }, "json");
        }
    });
};
