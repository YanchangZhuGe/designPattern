/**
 * js：提款申请
 */
/**
 * 默认数据：工具栏
 */
$.extend(jjxx_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ];
    },
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '提款申请',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    //校验是否选中区划叶子节点
                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                    var tree_selected = tree_area.getSelection();
                    if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                        Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                        return false;
                    }
                    OPERATE = 'INSERT';
                    $.post("/getGuid.action", {}, function (data) {
                        if (data.success) {
                            new_jjxx_id = data.guid;
                            button_name = btn.text;
                            window_clzw.btn = btn;
                            window_clzw.show();
                        }
                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    OPERATE = 'UPDATE';
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                    //提款申请流程
                    new_jjxx_id = records[0].get("JJXX_ID");
                    ZW_ID = records[0].get('ZW_ID');
                    ZW_CODE = records[0].get('ZW_CODE');
                    ZW_NAME = records[0].get('ZW_NAME');
                    AG_ID = records[0].get("AG_ID");
                    AG_CODE = records[0].get("AG_CODE");
                    AG_NAME = records[0].get("AG_NAME");
                    q_zwlb_id = records[0].get('Q_ZWLB_ID');
                    old_fetch_amt = records[0].get('FETCH_AMT_RMB');
                    init_edit_jjxx(btn);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            button_name = btn.text;
                            var ids = [];
                            for (var i in records) {
                                ids.push(records[i].get("JJXX_ID"));
                            }
                            var ZW_ID = records[0].get('ZW_ID');
                            //发送ajax请求，删除数据
                            $.post("/delJjxx.action", {
                                ids: ids,
                                ZW_ID: ZW_ID
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
                                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                            }, "json");
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'send',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    dooperation();
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
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    dooperation();
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
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    OPERATE = 'UPDATE';
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                    ZW_ID = records[0].get('ZW_ID');
                    ZW_CODE = records[0].get('ZW_CODE');
                    ZW_NAME = records[0].get('ZW_NAME');
                    q_zwlb_id = records[0].get('Q_ZWLB_ID');
                    init_edit_jjxx(btn);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            button_name = btn.text;
                            var ids = [];
                            for (var i in records) {
                                ids.push(records[i].get("JJXX_ID"));
                            }
                            var ZW_ID = records[0].get("ZW_ID");
                            //发送ajax请求，删除数据
                            $.post("/delJjxx.action", {
                                ids: ids,
                                zw_id: ZW_ID
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
                                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                            }, "json");
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'send',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    dooperation();
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
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});
//新增时举借信息id，用于保存附件
var new_jjxx_id = '';
//资金来源计数器，判断用户点击资金来源控件的次数
var zjlyCount = 0;
//提款日期计数器，判断用户点击提款日期控件的次数
var fetchCount = 0;
var autocalc = false;
/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var xm_name = Ext.ComponentQuery.query("textfield#XM_NAME")[0].getValue();
    var zqlx = Ext.ComponentQuery.query("treecombobox#zqlx")[0].getValue();
    //WF_STATUS=Ext.ComponentQuery.query("combobox#contentGrid_status")[0].getValue();

    store.getProxy().extraParams = {
        wf_id: wf_id,
        node_code: node_code,
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        AG_ID: AG_ID,
        ZQFL_ID: zqlx,
        xm_name: xm_name,
        WF_STATUS: WF_STATUS,
        zwlb_id: zwlb_id
    };
    store.loadPage(1);
}
/**
 * 查询债务信息
 */
function getzwxxList() {
    var store = DSYGrid.getGrid('zwxxListgird').getStore();
    var zw_name = DSYGrid.getGrid('zwxxListgird').down('textfield#zw_name').getValue();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        zw_name: zw_name,
        zwlb_id: zwlb_id
    };
    store.loadPage(1);
}
/**
 * 创建选择到期债务(有计划)弹出窗口
 * @type {{window: null, show: window_dqzw_yjh.show}}
 */
var window_dqzw_yjh = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_dqzw_yjh();
        }
        this.window.show();
    }
};
/**
 * 创建新增偿还资金申请单弹出窗口
 * @type {{window: null, show: window_debt_add_apply.show}}
 */
var window_debt_add_apply = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_debt_add_apply();
        }
        this.window.show();
    }
};
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', summaryType: 'count', width: 45},
        {dataIndex: "JJXX_ID", type: "string", text: "举借ID", hidden: true},
        {dataIndex: "AG_CODE", type: "string", text: "单位编码", hidden: true},
        {dataIndex: "AG_NAME", type: "string", text: "单位名称", hidden: true},
        {dataIndex: "ZW_ID", type: "string", text: "债务ID", hidden: true},
        {dataIndex: "ZW_CODE", type: "string", text: "债务编码", hidden: true},
        {dataIndex: "Q_ZWLB_ID", type: "string", text: "债务类别id", hidden: true},
        {dataIndex: "JJXX_CODE", type: "string", text: "申请单号", width: 200},
        {dataIndex: "AG_NAME", type: "string", text: "债务单位", width: 250},
        {
            dataIndex: "ZW_NAME", width: 250, type: "string", text: "债务名称",
            renderer: function (data, cell, record) {
               /* var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "FETCH_DATE", type: "string", text: "提款日期"},
        {dataIndex: "FETCH_AMT", width: 150, type: "float", text: "提款金额(原币)"},
        {
            dataIndex: "HL_RATE", type: "float", text: "汇率", hidden: zwlb_id == 'wb' ? false : true,
            editor: {xtype: 'numberFieldFormat', decimalPrecision: 6, hideTrigger: true}
        },
        {dataIndex: "FETCH_AMT_RMB", type: "float", text: "提款金额(人民币)", width: 150, hidden: zwlb_id == 'wb' ? false : true},
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "建设项目",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            dataIndex: "ZJLY_ID", type: "string", text: "偿还资金来源ID", width: 120, align: 'left', hidden: true
        },
        {dataIndex: "ZJLY_NAME", type: "string", text: "偿还资金来源", width: 250, align: 'left'},
        {dataIndex: "TKPZ_NO", type: "string", text: '提款凭证号', width: 120},
        {dataIndex: "JZ_DATE", type: "string", text: "记账日期"},
        {dataIndex: "JZ_NO", type: "string", text: '会计凭证号', width: 120},
        {dataIndex: "XY_AMT", width: 150, type: "float", text: "协议金额(原币)", hidden: true},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期", hidden: true},
        {dataIndex: "ZJYT_NAME", width: 250, type: "string", text: "债务资金用途", hidden: true},
        {dataIndex: "ZQLX_NAME", width: 150, type: "string", text: "债权类型", hidden: true},
        {dataIndex: "ZQR_NAME", width: 150, type: "string", text: "债权人", hidden: true},
        {dataIndex: "ZQR_FULLNAME", width: 320, type: "string", text: "债权人全称", hidden: true},
        {
            dataIndex: "TZBS", width: 150, type: "string", text: "调整标识", hidden: true,
            renderer: function (value) {
                var store = DebtEleStore(json_debt_tzbs);
                var record = store.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {dataIndex: "REMARK", width: 250, type: "string", text: "备注"}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        //rowNumber: true,
        border: false,
        height: '50%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt1),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                editable: false,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(jjxx_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        self.up('grid').getStore().getProxy().extraParams["wf_id"] = wf_id;
                        self.up('grid').getStore().getProxy().extraParams["node_code"] = node_code;
                        self.up('grid').getStore().loadPage(1);
                    }
                }
            }
        ],
        tbarHeight: 50,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            AG_CODE: AG_CODE,
            AD_CODE: AD_CODE,
            node_code: node_code,
            zwlb_id: zwlb_id
        },
        dataUrl: 'getJjxxList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                OPERATE = 'UPDATE';
                //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                ZW_ID = record.get('ZW_ID');
                ZW_CODE = record.get('ZW_CODE');
                ZW_NAME = record.get('ZW_NAME');
                var btn = Ext.create("Ext.Button", {
                    text: "修改"
                });
                init_edit_jjxx(btn, record);
            }
        }
    });
}
/**
 * 创建存量债务弹出窗口
 * @type {{window: null, btn: null, config: {closeAction: string}, show: window_clzw.show}}
 */
var window_clzw = {
    window: null,
    btn: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config, btn) {
        $.extend(this.config, config);
        if (!this.window || this.config.closeAction == 'destroy') {
            this.window = initWindow_clzw(this.config, this.btn);
        }
        this.window.show();
    }
};
/**
 * 初始化存量债务弹出窗口
 */
function initWindow_clzw(config, btn) {
    var btn_name = btn.text;
    if (btn_name == '提款申请') {
        OPERATE = 'INSERT';
    } else if (btn_name == '修改') {
        OPERATE = 'UPDATE';
    }

    return Ext.create('Ext.window.Window', {
        title: '债务信息', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_clzw', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: config.closeAction,
        items: [initWindow_clzw_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    init_edit_jjxx(btn);
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
 * 初始化到期债务(有计划)弹出窗口
 */
function initWindow_dqzw_yjh() {
    return Ext.create('Ext.window.Window', {
        title: '到期债务(有计划)', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_dqzw_yjh', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_dqzw_yjh_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    //关闭当前窗口，打开偿还资金录入窗口
                    window_debt_add_apply.show();
                    btn.up('window').close();
                    //偿还资金录入窗口表格增加行
                    for (var record_seq in records) {
                        //如果申报主表明细中已存在该数据，不插入
                        var record_data = records[record_seq].getData();
                        window_debt_add_apply.window.down('grid').insertData(null, record_data);
                    }

                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_dqzw_yjh.window = null;
            }
        }
    });
}
/**
 * 初始化存量债务弹出框表格
 */
function initWindow_clzw_grid() {
    var headerJson = [
        {dataIndex: "ZW_ID", type: "string", text: "债务ID", hidden: true},
        {dataIndex: "Q_ZWLB_ID", type: "string", text: "债务类别ID", hidden: true},
        {dataIndex: "AG_NAME", type: "string", text: "债务单位", width: 200},
        {
            dataIndex: "ZW_NAME", width: 150, type: "string", text: "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            dataIndex: "XM_NAME", type: "string", text: "建设项目", width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "SYTK_AMT", width: 150, type: "float", text: zwlb_id == 'wb' ? "剩余提款额度(原币)" : "剩余提款额度"},
        {dataIndex: "FETCH_AMT", width: 150, type: "float", text: zwlb_id == 'wb' ? "已提款金额(原币)" : "已提款金额"},
        {dataIndex: "XY_AMT", width: 150, type: "float", text: zwlb_id == 'wb' ? "协议金额(原币)" : "协议金额"},
        {dataIndex: "FM_NAME", type: "string", text: zwlb_id == 'wb' ? "原币币种" : "币种", hidden: zwlb_id != 'wb'},
        {dataIndex: "ZWLB_NAME", type: "string", text: "债务类别"},
        {dataIndex: "ZQLX_NAME", type: "string", text: "债权类型"},
        {dataIndex: "ZQR_NAME", type: "string", text: "债权人"},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人全称"},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期"},
        {dataIndex: "ZW_XY_NO", type: "string", text: "协议号"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zwxxListgird',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        rowNumber: true,
        border: false,
        height: '100%',
        flex: 1,
        dataUrl: 'getzwxxList.action',
        params: {
            AG_CODE: AG_CODE
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        selModel: {
            mode: "SINGLE"     //是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        }
    });
    //将form添加到表格中
    var searchTool = initWindow_clzw_grid_searchTool();
    grid.addDocked(searchTool, 0);
    $.extend(grid.getStore().getProxy().extraParams, grid.down('form').getValues());
    DSYGrid.getGrid('zwxxListgird').getStore().getProxy().extraParams["AG_ID"] = AG_ID;
    DSYGrid.getGrid('zwxxListgird').getStore().getProxy().extraParams["zwlb_id"] = zwlb_id;
    grid.getStore().loadPage(1);
    return grid;
}
/**
 * 初始化存量债务弹出框搜索区域
 */
function initWindow_clzw_grid_searchTool() {
    //初始化查询控件
    var items = [];
    items.push(
        {
            xtype: "textfield",
            fieldLabel: '债务单位',
            itemId: "ag_name",
            value: AG_NAME,
            width: 300,
            labelWidth: 60,
            labelAlign: 'right',
            editable: false,
            readOnly: true
        },
        {
            xtype: "textfield",
            itemId: "zw_name",
            fieldLabel: '债务名称',
            width: 300,
            labelWidth: 60,
            labelAlign: 'right',
            enableKeyEvents: true,
            // listeners: {}
            listeners: {
                'keydown': function (self, e, eOpts) {
                    var key = e.getKey();
                    if (key == Ext.EventObject.ENTER) {
                        var form = self.up('form');
                        search_form.callback(form);
                        getzwxxList();
                    }
                }
            }
        }
    );
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid');
    var search_form = searchTool.create({
        items: items,
        border: true,
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        defaults: {
            labelWidth: 60,
            width: 200
        },
        // 查询按钮回调函数
        callback: function (self) {
            var store = self.up('grid').getStore();
            // 清空参数中已有的查询项
            for (var search_form_i in self.getValues()) {
                delete store.getProxy().extraParams[search_form_i];
            }
            // 向grid中追加参数
            $.extend(true, store.getProxy().extraParams, self.getValues());
            // 刷新表格
            store.loadPage(1);
        }
    });
    //重新加载按钮
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 140,
        dock: 'right',
        layout: {
            type: 'hbox',
            align: 'center',
            pack: 'start'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    if (form.isValid()) {
                        search_form.callback(form);
                        getzwxxList();
                    } else {
                        Ext.Msg.alert("提示", "查询区域未通过验证！");
                    }
                }
            },
            '->', {
                xtype: 'button',
                text: '重置',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    form.reset();
                }
            }
        ]
    });
    return search_form;
}
/**
 * 创建并弹出举借信息窗口
 * @param btn
 * @param record
 */
function init_edit_jjxx(btn, record) {
    var btn_name = btn.text;
    zjlyCount = 0;
    fetchCount = 0;
    if (btn_name == '确认') {
        //获取表格选中数据
        var records = btn.up('window').down('grid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
            return;
        }
        btn.up('window').close();
        ZW_ID = records[0].get('ZW_ID');
        ZW_CODE = records[0].get('ZW_CODE');
        ZW_NAME = records[0].get('ZW_NAME');
        q_zwlb_id = records[0].get('Q_ZWLB_ID');
        record = records[0];

    } else if (btn_name == '修改') {
        if (record == null) {
            var records = DSYGrid.getGrid('contentGrid').getSelection();
            if (records.length <= 0 || records.length > 1) {
                Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
                return;
            }
            record = records[0];
        }

    }
    var titleName = '举借信息-';
    if (wf_id != null && wf_id != 'null' && wf_id != '100117') {
    } else {
        titleName = '增加提款申请单-';
    }
    if (new_jjxx_id == '') {
        new_jjxx_id = record.get("JJXX_ID");
    }
    var dialog_job = Ext.create('Ext.window.Window', {
        title: titleName + AG_NAME,
        itemId: 'jjxxadd',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        frame: true,
        constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        closeAction: 'destroy',
        items: [initEditor(btn, record), initTabPanel()],
        buttons: [
            {
                xtype: 'container',
                layout: 'column',
                itemId: 'btns_hkjhgrid',
                defaults: {
                    margin: '0 10 0 0'
                },
                items: [
                    {
                        xtype: 'button',
                        text: '增加',
                        id: 'hkjhAdd',
                        width: 80,
                        handler: function (btn) {
                            //插入空行
                            var grid = Ext.ComponentQuery.query('grid#hkjhgrid')[0];
                            grid.insertData(null, {
                                HKJH_ID: '',
                                ISEDIT: 0,
                                HKJH_DATE: '',
                                HKJH_AMT: '',
                                REMARK: ''
                            });
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        itemId: 'delete_editGrid',
                        width: 80,
                        margin: '0 20 0 0',
                        disabled: true,
                        handler: function (btn) {
                            var grid = Ext.ComponentQuery.query('grid#hkjhgrid')[0];
                            var store = grid.getStore();
                            var sm = grid.getSelectionModel();
                            var rows = grid.getSelectionModel().getSelection();

                            // rowEditing.cancelEdit();
                            //工作注id是不是100117的判断
                            if (wf_id != null && wf_id != '100117') {
                                var ids = [];
                                //判断还款计划id是否为空，为空则直接删除
                                for (var i = 0; i < rows.length; i++) {
                                    if (rows[i].get('HKJH_ID') == null || rows[i].get('HKJH_ID') == '' || rows[i].get('HKJH_ID') == 'undefined') {
                                        store.remove(rows[i]);
                                        continue;
                                    }
                                    if (rows[i].get('ZQ_HKJH_DATE') != null && rows[i].get('ZQ_HKJH_DATE') != '') {
                                        Ext.MessageBox.alert('提示', "有展期后还款日期的数据不能删除!");
                                    } else {
                                        ids.push(rows[i].get('HKJH_ID'));
                                    }
                                }
                                if (ids.length > 0) {
                                    $.post("/checkHbjh.action", {
                                        hbjh_id: ids
                                    }, function (data) {
                                        if (data.count) {
                                            var json = Ext.util.JSON.encode(data.list);

                                            for (var i = 0; i < json.length; i++) {
                                                var index = store.findBy(function (record, id) {
                                                    return record.get('HKJH_ID') == json[i].id;
                                                });
                                                store.remove(store.getAt(index));
                                            }
                                        } else {
                                            Ext.MessageBox.alert('提示', '该笔约定还本存在实际还本与之关联，无法删除');
                                        }
                                        //刷新表格
                                        //DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                                    }, "json");
                                }
                            }
                            else {
                                store.remove(sm.getSelection());
                            }
                            if (store.getCount() > 0) {
                                sm.select(0);
                            }
                        }
                    }
                ]
            },
            {
                xtype: 'container',
                layout: 'column',
                itemId: 'btns_yflxgrid',
                hidden: true,
                defaults: {
                    margin: '0 10 0 0'
                },
                items: [
                 
                    {
                        xtype: 'button',
                        text: '自动计算',
                        id: 'yflxAuto',
                        width: 80,
                        hidden:true,
                        handler: function (btn) {
	                    	var jsfs=form.getForm().findField('JSFS_ID').getValue();
							if(jsfs!='99' && jsfs!=null){
								calcInterest(btn,'0');
							}else{
								Ext.Msg.alert('提示', '利率类型为其它，无法自动计算，请手工填报！');
							}
                        }
                    },
                    {
                        xtype: 'button',
                        text: '增加',
                        id: 'yflxAdd',
                        width: 80,
                        handler: function (btn) {
                            // 创建行model实例
                            Ext.ComponentQuery.query('grid#yflxgrid')[0].insertData(null, {
                                YFLX_ID: '',
                                SOURCE: '1',
                                YFRQ: Ext.Date.clearTime(new Date()),
                                YFLX_AMT: 0,
                                REMARK: ''
                            });
                        }
                        // 创建行model实例
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        itemId: 'delete_editGrid',
                        width: 80,
                        disabled: true,
                        handler: function (btn) {
                            var grid = Ext.ComponentQuery.query('grid#yflxgrid')[0];
                            var store = grid.getStore();
                            var sm = grid.getSelectionModel();
                            store.remove(sm.getSelection());
                            if (store.getCount() > 0) {
                                sm.select(0);
                            }
                        }
                    }
                ]
            },
            {
                xtype: 'button',
                text: '保存送审',
                name: 'btn_insert',
                hidden: true,
                handler: function (btn) {
                    var form = btn.up('form#jjxxaddform');
                    submitInfo(form);
                }
            },
            {
                xtype: 'button',
                text: '保存',
                name: 'btn_update',
                id: 'save',
                handler: function (btn) {
                    var hkjhgrid = btn.up('window').down('grid#hkjhgrid');
                    hkjhgrid.getPlugin('hkjhgrid_plugin_cell').completeEdit();
                    var yflxgrid = btn.up('window').down('grid#yflxgrid');
                    yflxgrid.getPlugin('yflxgrid_plugin_cell').completeEdit();
                    var form = btn.up('window').down('form');
                    submitInfo(form, btn);
                }
            },
            {
                xtype: 'button',
                text: '关闭',
                name: 'btn_delete',
                //icon:'../../../image/button/field_drop24_h.png',
                handler: function (btn) {
                    /*if (OPERATE == "INSERT") {
                        var id = [];
                        id.push(new_jjxx_id);
                        //发送ajax请求，删除数据
                        $.post("/delJjxx.action", {
                            ids: id,
                            ZW_ID: ZW_ID
                        }, function (data) {
                            if (data.success) {
                                //刷新表格
                                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                            }
                        }, "json");
                    }*/
                    Ext.ComponentQuery.query('window#jjxxadd')[0].close();
                }
            }
        ]
    });
    var form = Ext.ComponentQuery.query('form#jjxxaddform')[0];
    if (wf_id != null && wf_id != '100117') {
        form.getForm().findField('TZBS_ID').setReadOnly(true);
    } else {
        if (typeof(zwlb_id) != 'undefined' && zwlb_id != null && zwlb_id == '01') {
            form.getForm().findField('TZBS_ID').setDisabled(false);
        } else {
            if (typeof(zwlb_id) != 'undefined' && zwlb_id != null && zwlb_id == '02') {
                form.getForm().findField('TZBS_ID').setDisabled(true);
            }
        }
        if (WF_STATUS == '008' || WF_STATUS == '002') {
            Ext.ComponentQuery.query('button#save')[0].setHidden(true);
            Ext.ComponentQuery.query('button#hkjhAdd')[0].setDisabled(true);
            Ext.ComponentQuery.query('button#yflxAuto')[0].setDisabled(true);
            Ext.ComponentQuery.query('button#yflxAdd')[0].setDisabled(true);
        }
    }
    //插入空行
    if(btn_name == '确认'){
    var grid = Ext.ComponentQuery.query('grid#hkjhgrid')[0];
    grid.insertData(null, {
        HKJH_ID: '',
        ISEDIT: 0,
        HKJH_DATE: '',
        HKJH_AMT: '',
        REMARK: ''
    });}
    dialog_job.show();
}
function checkSave(form, btn, isAuto) {
    var XY_AMT = form.getForm().findField('XY_AMT');
    var IS_FETCH_AMT = form.getForm().findField('IS_FETCH_AMT');
    var FETCH_AMT = form.getForm().findField('FETCH_AMT');
    var ZJLY_ID = form.getForm().findField("ZJLY_ID");
    var FETCH_DATE = form.getForm().findField('FETCH_DATE');
    var SIGN_DATE = form.getForm().findField('SIGN_DATE');
    var TZBS = form.getForm().findField('TZBS_ID');
    var JZ_DATE = form.getForm().findField('JZ_DATE');
    var JZ_NO = form.getForm().findField('JZ_NO');

    if (parseFloat(FETCH_AMT.getValue()) == 0) {
        Ext.Msg.alert('提示', '提款金额必须大于0！');
        return false;
    }
    if (IS_FETCH_AMT.getValue() + FETCH_AMT.getValue() > XY_AMT.getValue()) {//&& OPERATE == 'INSERT'
        Ext.Msg.alert('提示', '提款金额加已申请金额，不能大于协议金额！');
        return false;
    }

    var hkrq = dsyDateFormat(FETCH_DATE.getValue());

    if (TZBS.getValue() != null && TZBS.getValue() == '') {
        Ext.Msg.alert('提示', '调整标识不可以为空！');
        return false;
    }
//
//    var jzrq = dsyDateFormat(FETCH_DATE.getValue());
//    if (jzrq < '2016-07-01') {
//        Ext.Msg.alert('提示', '记账日期不能小于2016-07-01！');
//        return false;
//    }

    if (hkrq < SIGN_DATE.getValue()) {
        Ext.Msg.alert('提示', '提款日期不能小于签订日期！');
        return false;
    }

    var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
    var yflxStore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
//	var hkjhStore = DSYGrid.getGrid('hkjhGrid').getStore();
//	var yflxStore = DSYGrid.getGrid('yflxgrid').getStore();

    if (hkjhStore.getCount() <= 0) {
        Ext.Msg.alert('提示', '还款计划至少要有一笔数据!');
        return false;
    }

    if (yflxStore.getCount() <= 0 && !isAuto) {
        Ext.Msg.alert('提示', '应付利息至少要有一笔数据!');
        return false;
    }

    var sum_rmb = 0;
    for (var i = 0; i < hkjhStore.getCount(); i++) {
        if (hkjhStore.getAt(i).get('HKJH_DATE') == null || hkjhStore.getAt(i).get('HKJH_DATE') == 'null' || hkjhStore.getAt(i).get('HKJH_DATE') == 'undefined') {
            Ext.Msg.alert('提示', '还本计划的计划偿还日期不能为空!');
            return false;
        }
        if (dsyDateFormat(hkjhStore.getAt(i).get('HKJH_DATE')) < dsyDateFormat(FETCH_DATE.getValue())) {
            Ext.Msg.alert('提示', '还本计划的计划偿还日期不能早于举借提款日期!');
            return false;
        }

        if (hkjhStore.getAt(i).get('HKJH_AMT') == null || hkjhStore.getAt(i).get('HKJH_AMT') == 0) {
            Ext.Msg.alert('提示', '计划偿还金额(原币)必须大于0！');
            return false;
        }

        if (hkjhStore.getAt(i).get("HKJH_ID") != null && hkjhStore.getAt(i).get("HKJH_ID") != '' && hkjhStore.getAt(i).get('HKJH_AMT') < hkjhStore.getAt(i).get('isEdit')) {
            Ext.Msg.alert('提示', '计划偿还金额(原币)必须大于等于对应的实际还本金额！');
            return false;
        }
        sum_rmb += hkjhStore.getAt(i).get('HKJH_AMT');
    }
    if (parseFloat(FETCH_AMT.getValue()).toFixed(2) != parseFloat(sum_rmb).toFixed(2)) {
        Ext.Msg.alert('提示', '计划偿还金额(原币)必须等于提款金额(原币)！');
        return false;
    }
    for (var i = 0; i < yflxStore.getCount(); i++) {
        if (dsyDateFormat(yflxStore.getAt(i).get('YFRQ')) < dsyDateFormat(FETCH_DATE.getValue())) {
            Ext.Msg.alert('提示', '付息计划还款日期不能早于举借提款日期!');
            return false;
        }
//		if (yflxStore.getAt(i).get('YFLX_AMT')==null || yflxStore.getAt(i).get('YFLX_AMT')==0){
//			Ext.Msg.alert('提示', '应偿还金额必须大于0！');
//			return false;
//		}
    }
    return true;
}
function checkQXSave(form, btn) {
    var FETCH_AMT = form.getForm().findField('FETCH_AMT');
    var TKPZ_NO = form.getForm().findField('TKPZ_NO');
    var FETCH_DATE = form.getForm().findField('FETCH_DATE');
    if (TKPZ_NO.getValue() == null || TKPZ_NO.getValue() == '') {
        Ext.Msg.alert('提示', '提款凭证号不能为空！');
        return false;
    }
    var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
    var yflxStore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
//	var hkjhStore = DSYGrid.getGrid('hkjhGrid').getStore();
//	var yflxStore = DSYGrid.getGrid('yflxgrid').getStore();
    if (hkjhStore.getCount() <= 0) {
        Ext.Msg.alert('提示', '还款计划至少要有一笔数据!');
        return false;
    }
    var sum_rmb = 0;
    for (var i = 0; i < hkjhStore.getCount(); i++) {
        if (dsyDateFormat(hkjhStore.getAt(i).get('HKJH_DATE')) < dsyDateFormat(FETCH_DATE.getValue())) {
            Ext.Msg.alert('提示', '还本计划的计划偿还日期不能早于举借提款日期!');
            return false;
        }

        if (hkjhStore.getAt(i).get('HKJH_AMT') == null || hkjhStore.getAt(i).get('HKJH_AMT') == 0) {
            Ext.Msg.alert('提示', '计划偿还金额(原币)必须大于0！');
            return false;
        }

        if (hkjhStore.getAt(i).get("HKJH_ID") != null && hkjhStore.getAt(i).get("HKJH_ID") != '' && hkjhStore.getAt(i).get('HKJH_AMT') < hkjhStore.getAt(i).get('isEdit')) {
            Ext.Msg.alert('提示', '计划偿还金额(原币)必须大于对应的已经偿还的本金！');
            return false;
        }
        sum_rmb = parseFloat(sum_rmb) + parseFloat(hkjhStore.getAt(i).get('HKJH_AMT'));
    }
    if (parseFloat(FETCH_AMT.getValue()).toFixed(2) != parseFloat(sum_rmb).toFixed(2)) {
        Ext.Msg.alert('提示', '计划偿还金额(原币)必须等于提款金额(原币)！');
        return false;
    }
    for (var i = 0; i < yflxStore.getCount(); i++) {
        if (dsyDateFormat(yflxStore.getAt(i).get('YFRQ')) < FETCH_DATE.getValue()) {
            Ext.Msg.alert('提示', '计划还款日期不能早于举借提款日期!');
            return false;
        }

//		if (yflxStore.getAt(i).get('YFLX_AMT')==null || yflxStore.getAt(i).get('YFLX_AMT')==0){
//			Ext.Msg.alert('提示', '应偿还金额必须大于0！');
//			return false;
//		}
    }
}
function submitInfo(form, btn) {
    var XY_AMT = form.getForm().findField('XY_AMT');
    var IS_FETCH_AMT = form.getForm().findField('IS_FETCH_AMT');
    var FETCH_AMT = form.getForm().findField('FETCH_AMT');
    var ZJLY_ID = form.getForm().findField("ZJLY_ID");
    var FETCH_DATE = form.getForm().findField('FETCH_DATE');
    var SIGN_DATE = form.getForm().findField('SIGN_DATE');
    var TZBS = form.getForm().findField('TZBS_ID');
    var JZ_DATE = form.getForm().findField('JZ_DATE');
    var JZ_NO = form.getForm().findField('JZ_NO');

    var result = false;
    if (wf_id != null && wf_id != '100117') {
        result = checkQXSave(form, btn);
    } else {
        result = checkSave(form, btn, false);
    }
    if (result == false) {
        return;
    }
    //获取提款申请主信息
    var paramsHash = {};
    var url = '';
    paramsHash['Q_ZWLB_ID'] = q_zwlb_id;
    if (OPERATE == 'INSERT') {
        paramsHash['NEW_JJXX_ID'] = new_jjxx_id;
        url = 'insertjjxx.action?AD_CODE=' + AD_CODE + '&AG_ID=' + AG_ID + '&AG_NAME=' + encodeURI(AG_NAME) + '&AG_CODE=' + AG_CODE + '&ZW_ID=' + ZW_ID + '&ZW_CODE=' + ZW_CODE + '&ZW_NAME=' + encodeURI(ZW_NAME) + '&wf_id=' + wf_id + '&node_code=' + node_code + '&button_name=' + btn.name + '&NEW_JJXX_ID=' + new_jjxx_id + "&JZ_DATE=" + dsyDateFormat(JZ_DATE.getValue()) + "&JZ_NO=" + JZ_NO.getValue() + "&ZWLB_ID=" + zwlb_id;
    } else {
        var JJXX_ID = form.getForm().findField('JJXX_ID');
        url = 'updatejjxx.action?AD_CODE=' + AD_CODE + '&AG_ID=' + AG_ID + '&AG_NAME=' + encodeURI(AG_NAME) + '&AG_CODE=' + AG_CODE + '&ZW_ID=' + ZW_ID + '&ZW_CODE=' + ZW_CODE + '&ZW_NAME=' + encodeURI(ZW_NAME) + '&wf_id=' + wf_id + '&node_code=' + node_code + '&button_name=' + btn.name + '&JJXX_ID=' + JJXX_ID.getValue() + "&JZ_DATE=" + dsyDateFormat(JZ_DATE.getValue()) + "&JZ_NO=" + JZ_NO.getValue() + "&ZWLB_ID=" + zwlb_id + "&OLD_FETCH_AMT=" + old_fetch_amt;
    }
    //封装还款计划信息
    var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
    var yflxStore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
    var count = 0;
    hkjhStore.each(function (record) {
        var datas = record.data;
        var index = "[hkjh" + count + "]";

        for (hashKey in datas) {
            var newHashKey = hashKey + index;
            if (hashKey == "HKJH_DATE") {
                paramsHash[newHashKey] = dsyDateFormat(datas[hashKey]);
            } else {
                paramsHash[newHashKey] = datas[hashKey];
            }
        }
        count++;
    });
    paramsHash['hkjhcount'] = count;
    //封装应付利息信息
    count = 0;
    // var yflxStore = DSYGrid.getGrid("yflxgrid").getStore();
    yflxStore.each(function (record) {
        var datas = record.data;
        var index = "[yflx" + count + "]";

        for (hashKey in datas) {
            var newHashKey = hashKey + index;
            if (hashKey == "YFRQ") {
                paramsHash[newHashKey] = dsyDateFormat(datas[hashKey]);
            } else {
                paramsHash[newHashKey] = datas[hashKey];
            }
        }
        count++;
    });
    paramsHash['yflxcount'] = count;
    var formValues = form.getValues();
    for (var attr in formValues) {
        paramsHash[attr] = formValues[attr];
    }
    if (form.isValid()) {
        form.submit({
            url: url,
            params: {detailForm: Ext.util.JSON.encode([paramsHash])},
            waitTitle: '请等待',
            waitMsg: '正在加载中...',
            success: function (form, action, btn) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        if (wf_id != null && wf_id != '100117') {
                            loadZwxx1();
                            Ext.ComponentQuery.query('window#jjxxadd')[0].close();
                        } else {
                            DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                            Ext.ComponentQuery.query('window#jjxxadd')[0].close();
                        }
                        return true;
                    }
                });
            },
            failure: function (form, action, btn) {
                var result = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');

            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
        return false;
    }
}
/**
 * 加载页面数据
 */
function loadZwxx1() {
    var form = Ext.ComponentQuery.query('form[name="jbxxForm"]')[0];
    form.load({
        url: 'loadZwqx.action?ZW_ID=' + ZW_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            form.getForm().setValues(action.result.data.list);
            zwqx_zwlb_id = action.result.data.list.ZWLB_ID;
            AG_ID = action.result.data.list.AG_ID;
            //加載舉借信息表格
            var jjxxStore = action.result.data.jjxxList;
            var jjxxGrid = DSYGrid.getGrid('jjxxGrid');
            jjxxGrid.getStore().removeAll();
            jjxxGrid.insertData(null, jjxxStore);
            //加載应付利息表格
            var yflxStore = action.result.data.yflxList;
            var yflxGrid = DSYGrid.getGrid('yflxGrid');
            yflxGrid.getStore().removeAll();
            yflxGrid.insertData(null, yflxStore);
            //加載還款計劃表格
            var hkjhStore = action.result.data.hkjhList;
            var hkjhGrid = DSYGrid.getGrid('hkjhGrid');
            hkjhGrid.getStore().removeAll();
            hkjhGrid.insertData(null, hkjhStore);
        },
        failure: function (form, action) {
            Ext.MessageBox.alert('加载失败');
            Ext.ComponentQuery.query('window[name="zwqxWin"]')[0].close();
        }
    });
}
/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }

//    if (btn.text == '送审') {
//        if (records.length > 1) {
//            Ext.MessageBox.alert('提示', '送审只能选择一条数据进行操作');
//            return;
//        }
//    }

    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("JJXX_ID"));
    }
    button_name = btn.text;
    var button_id = btn.name;
    if (btn.text == '撤销') {
        Ext.MessageBox.show({
            title: '撤回',
            msg: '确定要撤回吗？',
            buttons: Ext.MessageBox.YESNO,
            icon: Ext.MessageBox.QUESTION,
            fn: function (btn, text, opt) {
                if (btn === 'yes') {
                    $.post("/cancelJjxx.action", {
                        workflow_direction: button_id,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        is_end: is_end,
                        ids: ids
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
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }, "json");
                }
            }
        });
        return;
    }
    //是否确认送审
    Ext.MessageBox.show({
        title: "提示",
        msg: "是否确认送审？",
        width: 200,
        buttons: Ext.MessageBox.OKCANCEL,
        //animateTarget: btn,
        fn: function (buttonId, text) {
            if (buttonId === 'ok') {
                var ids = [];
                for (var i in records) {
                    ids.push(records[i].get("JJXX_ID"));
                }
                var zwids = [];
                for (var i in records) {
                    zwids.push(records[i].get("ZW_ID"));
                }
                //发送ajax请求，修改节点信息
                $.post("/updateJJxxNode.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: text,
                    is_end: is_end,
                    ids: ids,
                    zwids: zwids
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
                        Ext.MessageBox.alert('提示', data.message);
                    }
                    //刷新表格
                    DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                }, "json");
            }
        }
    });
    //弹出意见填写对话框
    /* initWindow_opinion({
     title: btn.text,
     animateTarget: btn,
     fn: function (buttonId, text, opt) {
     if (buttonId === 'ok') {
     var ids = new Array();
     for (var i in records) {
     ids.push(records[i].get("JJXX_ID"));
     }
     var zwids=new Array();
     for(var i in records){
     zwids.push(records[i].get("ZW_ID"));
     }
     //发送ajax请求，修改节点信息
     $.post("/updateJJxxNode.action", {
     workflow_direction: btn.name,
     wf_id: wf_id,
     node_code: node_code,
     button_name: button_name,
     audit_info: text,
     is_end: is_end,
     ids: ids,
     zwids:zwids
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
     Ext.MessageBox.alert('提示',  data.message);
     }
     //刷新表格
     DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
     }, "json");
     }
     }
     });*/
}
/**
 * 举借初始化
 * @param btn
 * @param record
 * @returns {Ext.form.Panel}
 */
function initEditor(btn, record) {
    var condition = 'and 1=1';
    //债务清洗赋值
    if (wf_id != null && wf_id != '100117') {
        zwlb_id = zwqx_zwlb_id;
    }
    if (record.get('Q_ZWLB_ID') == '0101') {//0101一般债务，偿还资金来源0101下的 一般债务中的一般债务
        condition = "and (code = '0101')";
    } else if (record.get('Q_ZWLB_ID') == '0102') {//02或有债务，偿还资金来源02下的
        condition = "and (code like '0102%')";
    } else if (record.get('Q_ZWLB_ID').substring(0, 2) == '02') {//02或有债务，偿还资金来源02下的
        condition = "and (code like '02%')";
    }
    var content = [
        {xtype: 'label', text: '单位 : 元', style: {'float': 'right'}},
        {
            xtype: 'fieldset',
            title: '债务信息',
            layout: 'column',
            anchor: "100%",
            margin: '0 2 0 2',
            collapsible: true,
            defaults: {
                columnWidth: .33,
                margin: '2 5 2 0',
                labelAlign: 'left',
                labelWidth: 140,
                allowBlank: true
            },
            listeners: {
                'collapse': function () {
                }
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '债务单位',
                    name: "AG_NAME",
                    editable: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债务名称',
                    name: "ZW_AG_NAME",
                    editable: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '协议号',
                    name: "ZW_XY_NO",
                    editable: false
                },
                {
                    xtype: "numberFieldFormat",
                    name: "XY_AMT",
                    fieldLabel: '协议金额(原币)',
                    emptyText: '0.00',
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: false,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    readOnly:true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    editable: false
                },
                {
                    xtype: "numberFieldFormat",
                    name: "IS_FETCH_AMT",
                    fieldLabel: '已提款金额(原币)',
                    emptyText: '0.00',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: false,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    readOnly:true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    editable: false

                },
                {
                    xtype: "numberFieldFormat",
                    name: "SYTK_AMT_AMT",
                    fieldLabel: '剩余提款额度',
                    emptyText: '0.00',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: false,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    readOnly:true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    editable: false

                },
                {
                	xtype: "textfield",
                	fieldLabel: '结息方式',
                	name: "JSFS_ID",
                	hidden: true
                }
            ]
        },
        {
            xtype: 'fieldset',
            title: '提款信息录入',
            layout: 'column',
            anchor: "100%",
            margin: '0 2 0 2',
            collapsible: true,
            defaults: {
                columnWidth: .33,
                margin: '2 5 2 0',
                labelAlign: 'left',
                labelWidth: 140,
                allowBlank: true
            },
            listeners: {
                'collapse': function () {
                }
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '举借id',
                    name: "JJXX_ID",
                    editable: false,
                    hidden: true
                },
                {
                    xtype: "datefield",
                    name: "FETCH_DATE",
                    fieldLabel: '<span class="required">✶</span>提款日期',
                    allowBlank: false,
                    format: 'Y-m-d',
                    blankText: '请选择提款日期',
                    emptyText: '请选择提款日期',
                    value: today,
                    listeners: {
                        'change': function (self, newValue, oldValue, eOpts) {
                            //	                		var fetch =editorPanel.getForm().findField("FETCH_DATE");
                            //	                		if(node_code==2){
                            //	                			var fetch_date=Ext.util.Format.date(fetch.getValue(),'Y-m-d');
                            //	                			if(fetch_date>='2015-01-01'){
                            //	                				this.up('form').getForm().findField('TZBS_ID').enable();
                            //	                			}else{
                            //	                				this.up('form').getForm().findField('TZBS_ID').disable();
                            //	                			}
                            //	                		}else{
                            //	                			this.up('form').getForm().findField('TZBS_ID').SetHidden(true);
                            //	                		}
                        }
                    }
                },
                {
                    xtype: "numberFieldFormat",
                    name: "FETCH_AMT",
                    fieldLabel: '<span class="required">✶</span>提款金额（原币）',
                    emptyText: '0.00',
                    allowDecimals: true,
                    allowBlank: false,
                    value: 0,
                    minValue: 0,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    listeners: {
                        change: function (value) {
                            //计算提款人民币金额
                            value.up('container').down("[name='FETCH_AMT_RMB']").setValue(value.getValue() * value.up('container').down("[name='HL_RATE']").getValue());

                            var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
                            var jhchje = 0;
                            for (var i = 0; i < hkjhStore.getCount(); i++) {
                                jhchje += hkjhStore.getAt(i).get("HKJH_AMT");
                            }
                            var ych_ye = Ext.ComponentQuery.query('numberFieldFormat[name="YCH_YE"]')[0];
                            var FETCH_AMT = Ext.ComponentQuery.query('numberFieldFormat[name="FETCH_AMT"]')[0];
                            ych_ye.setValue(FETCH_AMT.getValue() - jhchje);
                        }
                    }
                },
                {
                    xtype: "numberFieldFormat",
                    name: "HL_RATE",
                    fieldLabel: '<span class="required">✶</span>提款汇率',
                    value: 1.000000,
                    allowBlank: false,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    fieldStyle: 'background:#E6E6E6',
                    // plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        change: function (value) {
                            //计算提款人民币金额
                            value.up('container').down("[name='FETCH_AMT_RMB']").setValue(value.getValue() * value.up('container').down("[name='FETCH_AMT']").getValue());
                        }
                    }
                },
                {
                    xtype: "numberFieldFormat",
                    name: "FETCH_AMT_RMB",
                    fieldLabel: '提款金额（人民币）',
                    emptyText: '0.00',
                    value: 0,
                    minValue: 0,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: false,
                    keyNavEnabled: false,
                    mouseWheelEnabled: false,
                    readOnly:true,
                    editable: false,
                    fieldStyle: 'background:#E6E6E6',
                    // plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "treecombobox",
                    name: "ZJLY_ID",
                    store: DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition}),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>偿债资金来源',
                    selectModel: 'leaf',
                    allowBlank: false,
                    editable: false,
                    listeners: {
                        'focus': function (event, eOpts) {
                            if (wf_id != null && wf_id != '100117') {
                                var zjly_id = editorPanel.getForm().findField("ZJLY_ID");
                                var zjly = zjly_id.getRawValue();
                                if (zjlyCount == 0) {
                                    if (zjly == null || zjly == '') {
                                        zjly_id.setDisabled(false);
                                    } else {
                                        zjly_id.setDisabled(true);
                                    }
                                }
                                zjlyCount++;
                            }
                        }
                    }
                },
                {
                    xtype: "textfield",
                    name: "TKPZ_NO",
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>提款凭证号',
                    allowBlank: false,
                    listeners: {
                        'select': function () {
                        }
                    }
                },
                {
                    xtype: "textfield",
                    name: "JZ_NO",
                    fieldLabel: '<span class="required">✶</span>记账凭证号',
                    allowBlank: false
                },
                {
                    xtype: "datefield",
                    name: "JZ_DATE",
                    fieldLabel: '<span class="required">✶</span>记账日期',
                    allowBlank: false,
                    format: 'Y-m-d',
                    blankText: '请选择记账日期',
                    emptyText: '请选择记账日期',
                    value: today
                },
                {
                    xtype: "textfield",
                    name: "SIGN_DATE",
                    fieldLabel: '签订日期',
                    hidden: true,
                    editable: false
                },
                {
                    xtype: "combobox",
                    name: "TZBS_ID",
                    store: DebtEleStore(json_debt_tzbs),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>调整标识',
                    //allowBlank: false,
                    hidden: true,
                    editable: false //禁用编辑
                },
                {
                    xtype: "textfield",
                    name: "FM_ID",
                    fieldLabel: zwlb_id == 'wb' ? "原币币种" : "币种",
                    editable: false,
                    hidden: true
                },
                {
                    xtype: "numberFieldFormat",
                    name: "YCH_YE",
                    fieldLabel: '应偿还余额(原币)',
                    emptyText: '0.00',
                    value: 0,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hidden: true,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    editable: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "textfield",
                    name: "zw_remark",
                    fieldLabel: '债务备注',
                    columnWidth: .99,
                    hidden: true,
                    allowBlank: true,
                    readOnly: true
                },
                {
                    xtype: "textfield",
                    name: "REMARK",
                    fieldLabel: '提款备注',
                    columnWidth: .99,
                    allowBlank: true
                }
            ]
        }
    ];
    var editorPanel = Ext.create('Ext.form.Panel', {
        layout: 'anchor',
        flex: 210,

        region: 'center',
        scrollable: true,
        border: false,
        split: true,
        itemId: 'jjxxaddform',
        items: content,
        listeners: {
            'beforeRender': function () {
                if (wf_id != null && wf_id != '100117') {
                    //SetItemReadOnly(this.items);
                }
                else {
                    if (WF_STATUS == '008' || WF_STATUS == '002') {
                        SetItemReadOnly(this.items);
                    }
                }
            }
        }
    });
    var btb_name = btn.text;
    if (btb_name == '确认') {
        $.post("/getzwByid.action", {
            ZW_ID: ZW_ID,
            AG_ID: AG_ID
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                return;
            }
            editorPanel.getForm().setValues(data.data);
            initWidget(editorPanel);
        }, "json");

    } else if (btb_name == '修改') {
        //提款申请流程
        var JJXX_ID = record.get('JJXX_ID');

        $.post("/queryjjxxByid.action", {
            JJXX_ID: JJXX_ID,
            ZWXX_ID: ZW_ID,
            AG_ID: AG_ID
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                return;
            }
            editorPanel.getForm().setValues(data.data);
            //var hkjhstore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
            DSYGrid.getGrid("hkjhgrid").insertData(null, data.hkjhList);
            //var yflxstore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
            DSYGrid.getGrid("yflxgrid").insertData(null, data.yflxList);
            initWidget(editorPanel);
        }, "json");
    }
    //初始化修改界面
    initWidget(editorPanel);
    return editorPanel;
}
/**
 * 初始化债务信息
 * @param form
 */
function initWidget(form) {
    var fm_id = form.getForm().findField('FM_ID');
    var HL_RATE = form.getForm().findField('HL_RATE');
    if (fm_id.getValue() != null && fm_id.getValue() == 'CNY') {
        HL_RATE.setEditable(false);
    }
    //债务清洗
    if (wf_id != null && wf_id != '100117') {
        //举借：只可以修改提款日期；提款日期必须>=2016年7月1日
        //dd,;
        form.getForm().findField('FM_ID').setEditable(false);
        form.getForm().findField('XY_AMT').setEditable(false);
        //alert(ZJLY_ID.getValue());
        //form.down('treecombobox[name="ZJLY_ID"]').setEditable(false);
        //form.getForm().findField('TKPZ_NO').setEditable(false);
        form.getForm().findField('FETCH_AMT').setEditable(false);
        form.getForm().findField('REMARK').setEditable(true);
        form.getForm().findField('TZBS_ID').setReadOnly(true);
        //form.getForm().findField('FETCH_DATE').disable();
        form.getForm().findField('FETCH_DATE').setReadOnly(true);
        form.getForm().findField('JZ_DATE').setDisabled(true);
        form.getForm().findField('TKPZ_NO').setEditable(true);
        form.getForm().findField('zw_remark').setEditable(true);
    } else {
        // form.getForm().findField('FETCH_DATE').setMinValue('2016-07-01');
    }
}
/**
 * 创建举借信息弹出框下方页签
 * @returns {*}
 */
function initTabPanel() {
    var tabPanel = Ext.createWidget('tabpanel', {
        itemId: "tabPanel",
        flex: 200,
        border: true,
        scrollable: true,
        region: 'south',
        activeTab: 0,
        items: [
            {
                title: '还本计划',
                btnsItemId: 'btns_hkjhgrid',
                layout: 'fit',
                items: inithkjh()
            },
            {
                title: '付息计划',
                layout: 'fit',
                btnsItemId: 'btns_yflxgrid',
                items: inityflx()
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                items: [
                    initWin_ZwqxTabPanel_Zhzq_Fj()
                ]
            }
        ],
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard) {
                if (newCard.btnsItemId) {
                    Ext.ComponentQuery.query('container#' + newCard.btnsItemId)[0].show();
                }
                if (oldCard.btnsItemId) {
                    Ext.ComponentQuery.query('container#' + oldCard.btnsItemId)[0].hide();
                }
            }
        }
    });
    return tabPanel;
}
/**
 * 初始化举借录入页签panel的附件页签
 */
function initWin_ZwqxTabPanel_Zhzq_Fj() {
    var editable = false;
    if (WF_STATUS == '008' || WF_STATUS == '002') {
        editable = false;//是否可以修改附件内容
    } else {
        editable = true;//是否可以修改附件内容
    }
    var grid = UploadPanel.createGrid({
        busiType: 'ET102',//业务类型
        busiId: new_jjxx_id,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: editable,//是否可以修改附件内容，默认为ture
        gridConfig: {
            itemId: 'window_jjxxtb_contentForm_tab_upload_grid'//若无，会自动生成，建议填写，特别是出现多个附件上传时
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
        if (grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}
/**
 * 还款计划初始化
 */
function inithkjh() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "HKJH_ID", type: "string", text: "还款计划ID", hidden: true},
        {dataIndex: "ISEDIT", type: "integer", text: "是否操作标志", hidden: true},
        {
            dataIndex: "HKJH_DATE", type: "string", text: "计划偿还日期",
            renderer: function (value, metaData, record) {
                var newValue = dsyDateFormat(value);
                record.data.HKJH_DATE = newValue;
                return newValue;
            },
            editor: {xtype: 'datefield', allowBlank: false, format: 'Y-m-d'}
        },
        {
            dataIndex: "HKJH_AMT", type: "float", text: "计划偿还金额(原币)", summaryType: 'sum',
            summaryRenderer: function (value) {
                var ych_ye = Ext.ComponentQuery.query('numberFieldFormat[name="YCH_YE"]')[0];
                var FETCH_AMT = Ext.ComponentQuery.query('numberFieldFormat[name="FETCH_AMT"]')[0];
                ych_ye.setValue(FETCH_AMT.getValue() - value);
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {xtype: 'numberFieldFormat', mouseWheelEnabled: false, hideTrigger: true}
        },
        {dataIndex: "REMARK", type: "string", text: "备注", editor: 'textfield'}
    ];
    if (wf_id != null && wf_id != '100117') {
        //加入header
        headerJson = headerJson.concat([
            {dataIndex: "ZQ_HKJH_DATE", type: "string", text: "展期后还款日期"},
            {dataIndex: "ZQ_DATE", type: "string", text: "展期日期"},
            {dataIndex: "ZQ_HTH", type: "string", text: "展期合同号"}
        ]);
    }
    return DSYGrid.createGrid({
        itemId: 'hkjhgrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true
        },
        scrollable: true,
        checkBox: true,
        rowNumber: true,
        border: true,
        bodyStyle: 'border-width:1px 1px 0 1px;',// 设置panel边框有无，去掉上方边框
        flex: 1,
        data: [],
        autoLoad: false,
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                clicksToMoveEditor: 1,
                pluginId: 'hkjhgrid_plugin_cell',
                listeners: {
                    'beforeedit': function (editor, context) {
                        if (WF_STATUS == '008' || WF_STATUS == '002') {
                            return false;
                        }
//                            if (context.record.get("ISEDIT") > 0) {
//                                Ext.Msg.alert('提示', '已有对应实际还本的还款计划不允许修改！');
//                                return false;
//                            }
                    }
                }
            }
        ],
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false//设置显示每页条数
        },
        listeners: {
            'selectionchange': function (view, records) {
                if (WF_STATUS != '008' && WF_STATUS != '002') {
                    //设置删除按钮是否禁用
                    Ext.ComponentQuery.query('container#btns_hkjhgrid')[0].down('#delete_editGrid').setDisabled(!records.length);
                }
            }
        }
    });
}
/**
 * 应付利息初始化
 */
function inityflx() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "YFLX_ID", type: "string", text: "应付利息ID", hidden: true},
        {dataIndex: "SOURCE", type: "string", text: "利息来源", hidden: true},
        {
            dataIndex: "YFRQ", type: "string", text: "计划偿还日期",
            renderer: function (value, metaData, record) {
                var newValue = dsyDateFormat(value);
                record.data.YFRQ = newValue;
                return newValue;
            },
            editor: {xtype: 'datefield', allowBlank: false, format: 'Y-m-d'}
        },
        {
            dataIndex: "YFLX_AMT", type: "float", text: "应偿还金额(原币)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {xtype: 'numberFieldFormat', mouseWheelEnabled: false, hideTrigger: true}
        },
        {dataIndex: "REMARK", type: "string", text: "备注", editor: {xtype: 'textfield'}}
    ];
    return DSYGrid.createGrid({
        itemId: 'yflxgrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true
        },
        checkBox: true,
        rowNumber: true,
        border: true,
        bodyStyle: 'border-width:1px 1px 0 1px;',// 设置panel边框有无，去掉上方边框
        flex: 1,
        data: [],
        tbarHeight: 400,
        plugins: [
            {
                ptype: 'cellediting',
                pluginId: 'yflxgrid_plugin_cell',
                clicksToEdit: 1,
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if (WF_STATUS == '008' || WF_STATUS == '002') {
                            return false;
                        }
                    }
                }
            }
        ],
        pageConfig: {
            enablePage: false//设置显示每页条数
        },
        listeners: {
            'selectionchange': function (view, records) {
                if (WF_STATUS != '008' && WF_STATUS != '002') {
                    //设置删除按钮是否禁用
                    Ext.ComponentQuery.query('container#btns_yflxgrid')[0].down('#delete_editGrid').setDisabled(!records.length);
                }
            }
        },
        features: [{
            ftype: 'summary'
        }]
    });
}

function calcInterest(btn,type){
    var form = btn.up('window').down('form');
    var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
    //var hkjhStore = DSYGrid.getGrid('hkjhGrid').getStore();
    var XY_AMT = form.getForm().findField('XY_AMT');
    var IS_FETCH_AMT = form.getForm().findField('IS_FETCH_AMT');
    var FETCH_AMT = form.getForm().findField('FETCH_AMT');
    var FETCH_AMT_RMB = form.getForm().findField('FETCH_AMT_RMB');
    var TKPZ_NO = form.getForm().findField('TKPZ_NO');
    var HL_RATE = form.getForm().findField('HL_RATE');
    var ZJLY_ID = form.getForm().findField("ZJLY_ID");
    var FETCH_DATE = form.getForm().findField('FETCH_DATE');
    var SIGN_DATE = form.getForm().findField('SIGN_DATE');
    var TZBS = form.getForm().findField('TZBS_ID');
    var REMARK = form.getForm().findField('REMARK');
    var JZ_DATE = form.getForm().findField('JZ_DATE');
    var JZ_NO = form.getForm().findField('JZ_NO');
    var JJXX_ID = form.getForm().findField('JJXX_ID');
    var zw_name = form.getForm().findField('ZW_AG_NAME');
    var result = false;
    if (wf_id != null && wf_id != '100117') {
        result = checkQXSave(form, btn, true);
    } else {
        result = checkSave(form, btn, true);
        if (!result) {
            return;
        }
    }
    result = form.isValid();
    if (result == false) {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
        return;
    }

    //获取提款申请主信息
    var paramsHash = {};
    paramsHash['NEW_JJXX_ID'] = new_jjxx_id;

    //封装还款计划信息
    var yflxStore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
    //var yflxStore = DSYGrid.getGrid("yflxgrid").getStore();

    var count = 0;
    hkjhStore.each(function (record) {
        var datas = record.data;
        var index = "[hkjh" + count + "]";

        for (hashKey in datas) {
            var newHashKey = hashKey + index;
            if (hashKey == "HKJH_DATE") {
                paramsHash[newHashKey] = dsyDateFormat(datas[hashKey]);
            } else {
                paramsHash[newHashKey] = datas[hashKey];
            }
        }
        count++;
    });
    paramsHash['hkjhcount'] = count;

    //封装应付利息信息
    count = 0;

    yflxStore.each(function (record) {
        var datas = record.data;
        var index = "[yflx" + count + "]";
        for (hashKey in datas) {
            var newHashKey = hashKey + index;
            if (hashKey == "YFRQ") {
                paramsHash[newHashKey] = dsyDateFormat(datas[hashKey]);
            } else {
                paramsHash[newHashKey] = datas[hashKey];
            }
        }
        count++;
    });
    paramsHash['yflxcount'] = count;
    btn.setDisabled(true);
    $.post("/autoCalc.action", {
        ZW_ID: ZW_ID,
        wf_id: wf_id,
        JJXX_ID: JJXX_ID.getValue(),
        node_code: node_code,
        new_jjxx_id: new_jjxx_id,
        ZJLY_ID: ZJLY_ID.getValue(),
        FETCH_DATE: dsyDateFormat(FETCH_DATE.getValue()),
        TKPZ_NO: TKPZ_NO.getValue(),
        FETCH_AMT: FETCH_AMT.getValue(),
        FETCH_AMT_RMB: FETCH_AMT_RMB.getValue(),
        HL_RATE: HL_RATE.getValue(),
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_NAME: encodeURI(AG_NAME),
        AG_CODE: AG_CODE,
        ZW_CODE: ZW_CODE,
        ZW_NAME: encodeURI(zw_name.getValue()),
        JZ_DATE: dsyDateFormat(JZ_DATE.getValue()),
        JZ_NO: JZ_NO.getValue(),
        TZBS: TZBS.getValue(),
        REMARK: REMARK.getValue(),
        OPERATE: OPERATE,
        LXCS_PARAM:type,
        params: paramsHash
    }, function (data) {
        if (data.success) {
            autocalc = true;
            var yflxGrid = Ext.ComponentQuery.query('grid#yflxgrid')[0];
            //var yflxGrid = DSYGrid.getGrid("yflxgrid");
            var yflxStore = yflxGrid.getStore();
            yflxStore.removeAll();
            yflxGrid.insertData(null, data.yflxList);
            var form = btn.up('window').down('form');
            form.getForm().findField('JJXX_ID').setValue(data.jjid);
            btn.setDisabled(false);
        } else {
            btn.setDisabled(false);
            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
            return;
        }
    }, "json");
}
    