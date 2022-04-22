/**
 * js：下级项目审核js
 * Created by yb on 2017/6/12.
 */


/**
 *
 * Grid表头
 * */

var hidden = false;
var AD_CODES;
var HEADERJSON_HZ = [
    {
        xtype: 'rownumberer', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {dataIndex: "HZD_ID", width: 150, type: "string", text: "汇总单ID", hidden: true},
    {dataIndex: "AD_CODE", width: 140, type: "string", text: "地区编码", hidden: true},
    {dataIndex: "NAME", width: 140, type: "string", text: "地区"},
    {dataIndex: 'DW_NUMS', width: 100, type: 'string', text: '项目单位数'},
    {dataIndex: 'XM_NUMS', width: 100, type: 'string', text: '项目数量'},
    {dataIndex: 'SBQJ_NAME', width: 150, type: 'string', text: '上报期间'},
    {
        header: '项目总投资额(万元)', colspan: 4, align: 'center', columns: [
        {
            dataIndex: "XMTZ_AMT", width: 160, type: "float", text: "合计", summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: "XMTZ_YB_AMT", width: 160, type: "float", text: "其中一般债务", summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'XMTZ_ZX_AMT', width: 160, type: 'float', text: '专项债务', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'QT_AMT', width: 160, type: 'float', text: '其他财政资金', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'QITA_AMT', width: 160, type: 'float', text: '其他资金', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        }
    ]
    },
    {
        header: '资产价值(万元)', colspan: 2, align: 'center', columns: [
        {
            dataIndex: 'ZJYZ_AMT', width: 150, type: 'float', text: '原值', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'ZCJZ_AMT', width: 150, type: 'float', text: '净值', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'YGJZ_AMT', width: 150, type: 'float', text: '预估价值', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        }
    ]
    },
    {
        header: '资产运营收益(万元)', colspan: 2, align: 'center', columns: [
        {
            dataIndex: 'LJSY_AMT', width: 150, type: 'float', text: '累计收益', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'SNLJSY_AMT', width: 150, type: 'float', text: '本期收益', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'PJSY_AMT', width: 200, type: 'float', text: '每年平均经营性现金流收入', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        },
        {
            dataIndex: 'PJBT_AMT', width: 250, type: 'float', text: '年度平均政府安排财政补贴资金', summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }
        }
    ]
    },
    {
        dataIndex: "CZSR_AMT", width: 180, type: "float", text: "本期资产处置收入(万元)", summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00####');
        }
    },
    {
        dataIndex: 'DYDB_AMT', width: 240, type: 'float', text: '抵押质押及担保金额(万元)', summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00####');
        }
    }
];
var HEADERJSON_WEI = [
    {xtype: 'rownumberer', width: 40},
    {dataIndex: 'AD_CODE', text: '地区编码', width: 200, align: 'center'},
    {dataIndex: 'NAME', text: '地区名称', width: 200, align: 'center'}
];
//json_zt = json_debt_zt2_3;//状态栏显示类型 001: 未审核  002：已审核
//下拉框状态
json_zt = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "003", code: "003", name: "未上报"}
];
//var store_zqlx = DebtEleStore(json_debt_zqlx);
/**
 * 默认数据：工具栏
 */
$.extend(zcxjsh_json_common, {
    items: {
        '001': [
            {
                text: '查询',
                xtype: 'button',
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
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    doWorkFlow(btn);
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
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '汇总表',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();

                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_HZ.cpt&hzd_id=' + ids + '&HZD_TYPE=1';
                    if (records.length <= 0) {
                        Ext.Msg.alert('提示', '请至少选择一条数据进行操作');
                        return;
                    }
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);


                }
            },
            {
                xtype: 'button',
                text: '明细表',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_MX.cpt&hzd_id=' + ids + '&HZD_TYPE=1';
                    if (records.length <= 0) {
                        Ext.Msg.alert('提示', '请至少选择一条数据进行操作');
                        return;
                    }
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
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
            {
                xtype: 'button',
                text: '未形成资产项目',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    AD_CODES = [];
                    Ext.each(records, function (record) {
                        AD_CODES.push(record.get("AD_CODE"));
                    });
                    chooseProjectWindow.show();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
                    existingProjectStore.loadPage(1);
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
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                itemId: 'cancel',
                name: 'cancel_sh',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    Ext.Msg.confirm('提示', '请确认是否撤销审核?', function (btn2) {
                        if (btn2 == 'yes') {
                            doWorkFlow(btn);
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '汇总表',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_HZ.cpt&hzd_id=' + ids + '&HZD_TYPE=1';
                    if (records.length <= 0) {
                        Ext.Msg.alert('提示', '请至少选择一条数据进行操作');
                        return;
                    }
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
                }
            },
            {
                xtype: 'button',
                text: '明细表',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();

                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_MX.cpt&hzd_id=' + ids + '&HZD_TYPE=1';
                    if (records.length <= 0) {
                        Ext.Msg.alert('提示', '请至少选择一条数据进行操作');
                        return;
                    }
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
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
            {
                xtype: 'button',
                text: '未形成资产项目',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    AD_CODES = [];
                    Ext.each(records, function (record) {
                        AD_CODES.push(record.get("AD_CODE"));
                    });
                    chooseProjectWindow.show();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
                    existingProjectStore.loadPage(1);
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '003': [
            {
                xtype: 'button', text: '查询', icon: '/image/sysbutton/search.png', handler: function () {
                    reloadGrid();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]

    },
    //初始化左侧树
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    },
    //渲染Grid到页面上去。
    items_content_rightPanel_items: function () {
        return [
            initContentHZGrid(),
            initContentWeiGrid()
        ]
    },
    reloadGrid: function (param_hz, param_content) {
        var store = DSYGrid.getGrid('contentHZGrid').getStore();
        var store1 = DSYGrid.getGrid('contentWeiGrid').getStore();
        //增加查询参数
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store1.getProxy().extraParams["AD_CODE"] = AD_CODE;
        // store.getProxy().extraParams["SBBATCH_NO_NAME"] = SBBATCH_NO_NAME;
        if (typeof param_hz != 'undefined' && param_hz != null) {
            for (var name in param_hz) {
                store.getProxy().extraParams[name] = param_hz[name];
                store1.getProxy().extraParams[name] = param_hz[name];
            }
        }
        //刷新
        store.loadPage(1);
        store1.loadPage(1);
    }
});
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
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 获取选中汇总数据
    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("HZD_ID"));
    }
    //撤销
    button_name = btn.text;
    if (button_status == 'down' || button_status == 'up') {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + '意见',
            value: button_status == 'up' ? '' : '同意',
            animateTarget: btn,
            fn: function (buttonId, text, opt) {
                if (buttonId === 'ok') {
                    doWorkFlow_ajax(ids, btn, text);
                }
            }
        });
    }
    if (button_status == 'cancel_sh' || button_status == 'cancel_th') {
        doWorkFlow_ajax(ids, btn, '');
    }
}
/**
 * 工作流发送ajax修改请求
 */
function doWorkFlow_ajax(ids, btn, text) {
    ///发送ajax请求，修改节点信息
    $.post("/updateXjsh.action", {
        workflow_direction: btn.name,
        button_name: button_name,
        button_status: button_status,
        audit_info: text,
        ids: ids
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功!",
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


/**
 * 初始化右侧主表格:
 */
function initContentHZGrid() {
    var headerJson = HEADERJSON_HZ;
    return DSYGrid.createGrid({
        itemId: 'contentHZGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        hidden: hidden,
        height: '50%',
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getZcglxjxmHZ.action',
        pageConfig: {
            pageNum: true
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_zt),
                width: 130,
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
                        if (newValue == '003') {
                            //alert("dfd");
                            hidden = true;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            var grid = DSYGrid.getGrid('contentHZGrid');
                            var grid1 = DSYGrid.getGrid('contentWeiGrid');
                            grid1.down("combobox").setValue("003");
                            grid.hide();
                            grid1.show();
                        } else {

                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(zcxjsh_json_common.items[WF_STATUS]);
                            //刷新当前表格
                            DSYGrid.getGrid('contentHZGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                            DSYGrid.getGrid('contentHZGrid').getStore().loadPage(1);
                        }
                    }
                }
            }

        ],
    });
}

/**
 * 未上报的Grid
 */
function initContentWeiGrid() {
    var headerJson = HEADERJSON_WEI;
    return DSYGrid.createGrid({
        itemId: 'contentWeiGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        hidden: !hidden,
        autoLoad: false,
        height: '50%',
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS
        },
        dataUrl: 'getZcglxjxmHZ.action',
        pageConfig: {
            pageNum: true
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_zt),
                width: 130,
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
                        if (newValue != '003') {
                            var grid = DSYGrid.getGrid('contentHZGrid');
                            var grid1 = DSYGrid.getGrid('contentWeiGrid');
                            grid1.hide();
                            if (WF_STATUS == '001') {
                                grid.down("combobox").setValue("001");
                            } else if (WF_STATUS == '002') {
                                grid.down("combobox").setValue("002");
                            }
                            grid.show();
                        }
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(zcxjsh_json_common.items[WF_STATUS]);
                        //刷新当前表格
                        DSYGrid.getGrid('contentWeiGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        DSYGrid.getGrid('contentWeiGrid').getStore().loadPage(1);
                    }
                }
            }

        ],
    });
}

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
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: zcxjsh_json_common.items[WF_STATUS]
            }
        ],
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                },
                param: zcxjsh_json_common.items_content_tree_config,
                items_tree: zcxjsh_json_common.items_content_tree
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧表格
        ]
    });
}
//创建已有项目选择窗口
var chooseProjectWindow = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initChooseProjectWindow();
        }
        this.window.show();
    }
};
function initChooseProjectWindow() {
    return Ext.create('Ext.window.Window', {
        height: document.body.clientHeight * 0.9,
        width: document.body.clientWidth * 0.9,
        title: '未形成资产项目',
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'fit',
        items: [existingProjectGrid()],
        buttons: [
        ],
        listeners: {
            close: function () {
                chooseProjectWindow.window = null;
            }
        }
    });
}
//创建已有项目表格
function existingProjectGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区", "width": 100},
        {"dataIndex": "AG_NAME", "type": "string", "text": "项目单位", "width": 200},
        {
            "dataIndex": "XM_NAME", "width": 330, "type": "string", "text": "项目名称",
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
        {"text": "管理(使用)单位", "dataIndex": "USE_UNIT", "type": "string", "width": 200},
        {"text": "项目类型", "dataIndex": "XMLX_NAME", "type": "string", "width": 150,},
        {"text": "项目性质ID", "dataIndex": "XMXZ_ID", "type": "string", hidden: true},
        {"text": "项目性质", "dataIndex": "XMXZ_NAME", "type": "string", width: 170},
        {
            "dataIndex": "BUILD_STATUS_ID", "type": "string", hidden: true
        }, {
            "dataIndex": "BUILD_STATUS_NAME", "width": 150, "type": "string", "text": "建设状态"
        },
        {"dataIndex": "END_DATE_ACTUAL", "width": 150, "type": "string", "text": "竣工时间"},
        {
            "header": "项目总投资金额(万元)", 'colspan': 2, 'align': 'center',
            'columns': [
                {"type": "float", "text": "合计", "dataIndex": "XMTZ_AMT", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {"dataIndex": "XMTZ_YB_AMT", "width": 150, "type": "float", "text": "其中一般债务",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
        },
        {"text": "未形成资产原因", "dataIndex": "WXCZC_REASON", "type": "string", "width": 150}

    ];
    return DSYGrid.createGrid({
        itemId: 'existingProjectGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        features: [{
            ftype: 'summary'
        }],
        autoLoad: false,
        params: {
            AD_CODE: '',
            AG_ID: '',
            mhcx_xm: '',
            xmlx_id: ''
        },
        //顶部工具条
        tbar: [
            {
                xtype: "treecombobox",
                name: "xmlx_id",
                id: 'xmlx_id',
                fieldLabel: '项目类型',
                displayField: 'name',
                valueField: 'code',
                selectModel: 'all',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                labelWidth: 70,
                width: 220,
                labelAlign: 'right',
                editable: false,
                allowBlank: true,
                triggers:{
                    clear: {
                        cls: Ext.baseCSSPrefix + 'form-clear-trigger',
                        handler: function(self) {
                            self.setValue('');
                        }
                    }
                }
            },
            {
                xtype: "textfield",
                name: "mhcx_xm",
                id: 'mhcx_xm',
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 240,
                labelAlign: 'right',
                emptyText: '请输入单位名称/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                            var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                            var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                            existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
                            existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                            existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                            existingProjectStore.loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                    var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
                    existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                    existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                    existingProjectStore.loadPage(1);
                }
            }
        ],
        dataUrl: 'getExistingProjectGrid.action',
        pageConfig: {
            enablePage: true,//设置分页为false
           // pageNum: true
        }
    });
}

/**
 * 树点击节点时触发.刷新表格
 */
function reloadGrid(param, param_detail) {
    if (zcxjsh_json_common.reloadGrid) {
        zcxjsh_json_common.reloadGrid(param);
    } else {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //增加查询参数
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.getProxy().extraParams["AG_CODE"] = AG_CODE;
        store.getProxy().extraParams["bond_type_id"] = bond_type_id;
        if (typeof param != 'undefined' && param != null) {
            for (var i in param) {
                store.getProxy().extraParams[i] = param[i];
            }
        }
        store.loadPage(1);
    }
}

/**
 * 操作记录
 */
function operationRecord() {
    var records = DSYGrid.getGrid('contentHZGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var fhdw_id = records[0].get("HZD_ID");
        fuc_getWorkFlowLog(fhdw_id);
    }
}


