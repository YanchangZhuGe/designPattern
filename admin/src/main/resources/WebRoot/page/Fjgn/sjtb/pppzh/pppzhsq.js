/**
 * js：还本付息资金申请
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
var dw_name = "";
var selectId;
var chbj_code = "";
$.extend(ppp_json_common[wf_id][node_type], {
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
                        getPPPZhDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '新增',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.text;
                    isModify = '0';
                    IS_WF = "1";
                    isHuanBen = '0';
                    selectId = new Array();
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    window_dqzw_pppzh_zw.show();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据

                    button_name = btn.text;
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    /*AD_CODE = records[0].get("AD_CODE");
                     AD_NAME = records[0].get("AD_NAME");
                     AG_CODE = records[0].get("AG_CODE");
                     AG_NAME = records[0].get("AG_NAME");
                     AG_ID =  records[0].get("AG_ID");*/
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    //发送ajax请求，查询主表和明细表数据
                    $.post("/getPPPZhChbjGridById.action", {
                        id: records[0].get('CHBJ_ID')
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        if (zjly_id == '04') {
                            TITLE = '债务核销申请单修改';
                        } else {
                            TITLE = 'PPP转化申请单修改';
                        }
                        isModify = '1';
                        IS_WF = "1";
                        window_debt_add_pppzh.show({
                            gridId: records[0].get('CHBJ_ID')
                        });
                        DSYGrid.getGrid('debt_add_pppzh_grid').insertData(null, data.data);
                        Ext.ComponentQuery.query('form[itemId="window_debt_add_pppzh_form"]')[0].getForm().setValues(data);
                    }, "json");

                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    Ext.Msg.alert('提示', '您确定要删除么？');
                    button_name = btn.text;
                    delPPPZhDataSelectedList(btn);
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
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
                        getPPPZhDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销送审',
                name: 'cancel',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_name = btn.text;
                    cancleCheck(btn);
                   /* Ext.MessageBox.show({
                        title: '提示',
                        msg: "是否撤销选择的记录？",
                        width: 200,
                        buttons: Ext.MessageBox.YESNO,
                        fn: function (btn) {
                            button_name = btn.text;
                            if (btn == "yes") {
                                
                            }
                        }
                    });*/
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
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
                        getPPPZhDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    button_name = btn.text;
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    /*AD_CODE = records[0].get("AD_CODE");
                     AD_NAME = records[0].get("AD_NAME");
                     AG_CODE = records[0].get("AG_CODE");
                     AG_NAME = records[0].get("AG_NAME");
                     AG_ID =  records[0].get("AG_ID");*/
                    //发送ajax请求，查询主表和明细表数据
                    $.post("/getPPPZhChbjGridById.action", {
                        id: records[0].get('CHBJ_ID')
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        if (zjly_id == '04') {
                            TITLE = '债务核销申请单修改';
                        } else {
                            TITLE = 'PPP转化申请单修改';
                        }
                        isModify = '1';
                        IS_WF = "1";
                        window_debt_add_pppzh.show({
                            gridId: records[0].get('CHBJ_ID')
                        });
                        DSYGrid.getGrid('debt_add_pppzh_grid').insertData(null, data.data);
                        Ext.ComponentQuery.query('form[itemId="window_debt_add_pppzh_form"]')[0].getForm().setValues(data);
                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    Ext.Msg.alert('提示', '您确定要删除么？');
                    button_name = btn.text;
                    delPPPZhDataSelectedList(btn);
                }
            },
            {
                xtype: 'button',
                text: '送审',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
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
                        getPPPZhDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});
//PPP转化到期债务选择弹出窗口
var window_dqzw_pppzh_zw = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_window_pppzh_zw();
        }
        this.window.show();
    }
};
//创建新增PPP转化申请单弹出窗口
var window_debt_add_pppzh = {
    window: null,
    show: function (config) {
        if (!this.window) {
            this.window = initWindow_debt_add_pppzh(config);
        }
        this.window.show();
    }
};
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "AG_CODE", width: 140, type: "string", text: "单位编码"},
        {dataIndex: "AG_NAME", width: 200, type: "string", text: "单位名称"},
        {dataIndex: "CHBJ_CODE", width: 200, type: "string", text: zjly_id == '04' ? "核销申请单号" : "转化申请单号"},
        {dataIndex: "PAY_AMT_RMB", width: 180, type: "float", text: zjly_id == '04' ? "核销金额(元)" : "转化金额(元)"},
        {dataIndex: "PAY_DATE", width: 160, type: "string", text: zjly_id == '04' ? '债务核销日期' : "转化生效日期"},
        {dataIndex: "PPPXM_CODE", width: 100, type: "string", text: "PPP项目编码", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "PPPXM_NAME", width: 100, type: "string", text: "PPP项目名称", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "PPPXM_AMT", width: 150, type: "float", text: "项目总投资（万元）", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "XMGS_NAME", width: 150, type: "string", text: "项目公司名称", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "REMARK", width: 480, type: "string", text: zjly_id == '04' ? "核销原因" : "备注"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
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
                        toolbar.add(ppp_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        if (AD_CODE == null || AD_CODE == '') {
                            return;
                        }
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                name: 'contentGrid_search',
                width: 300,
                labelWidth: 60,
                labelAlign: 'right',
                emptyText: '请输入单位名称/单位编码...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            getPPPZhDataList();
                        }
                    }
                }
            }
        ],
        params: {
            zjly_id: zjly_id,
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        autoLoad: false,
        dataUrl: '/getPPPZhDataList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                //发送ajax请求，查询主表和明细表数据
                $.post("/getPPPZhChbjGridById.action", {
                    id: record.get('CHBJ_ID')
                }, function (data) {
                    if (!data.success) {
                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                        return;
                    }
                    if (zjly_id == '04') {
                        TITLE = '债务核销申请单查看';
                    } else {
                        TITLE = 'PPP转化申请单查看';
                    }
                    window_debt_view_pppzh.show({
                        gridId: record.get('CHBJ_ID'),
                        disabled: true
                    });
                    var store = window_debt_view_pppzh.window.down('form#window_debt_view_pppzh_form').down('grid#debt_view_apply_grid').getStore();
                    store.insert(0, data.data);
                    window_debt_view_pppzh.window.down('form#window_debt_view_pppzh_form').getForm().setValues(data);
                }, "json");
            }
        }
    });
    return grid;
}
/**
 * 初始化PPP转化到期债务选择弹出窗口
 */
function initWindow_window_pppzh_zw() {
    return Ext.create('Ext.window.Window', {
        title: '选择债务', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_dqzw_pppzh', // 窗口标识
        maximizable: true,//最大化按钮
        layout: 'fit',
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_dqzw_pppzh_zw_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据再进行操作');
                        return;
                    }
                    //发送ajax请求，查询主表和明细表数据
                    $.post("/getPPPZHHkjhByZWId.action", {
                        id: records[0].get('ZW_ID'),
                        zjly_id: zjly_id
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //关闭当前窗口，打开偿还资金录入窗口
                        if (zjly_id == '04') {
                            TITLE = '债务核销';
                        } else {
                            TITLE = 'PPP转化录入';
                        }
                        window_debt_add_pppzh.show({
                            gridId: data.CHBJ_ID
                        });
                        btn.up('window').close();
                        DSYGrid.getGrid('debt_add_pppzh_grid').insertData(null, data.data);
                        Ext.ComponentQuery.query('form[itemId="window_debt_add_pppzh_form"]')[0].getForm().setValues(data);

                    }, "json");
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
                window_dqzw_pppzh_zw.window = null;
            }
        }
    });
}
/**
 * 初始化到期债务(有计划)弹出框表格
 */
function initWindow_dqzw_pppzh_zw_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "AG_NAME", type: "string", text: "债务单位", width: 150},
        {
            dataIndex: "ZW_NAME", type: "string", text: "债务名称", width: 150,
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
            dataIndex: "XM_NAME", type: "string", text: "建设项目", width: 150,
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
        {dataIndex: "DUE_AMT", type: "float", text: "债务余额(元)", type: "float", editor: 'numberfield', width: 150},
        {dataIndex: "ZWLB_NAME", type: "string", text: "债务类别", width: 150},
        {dataIndex: "ZQLX_NAME", type: "string", text: "债权类型", width: 150},
        {dataIndex: "ZQR_NAME", type: "string", text: "债权人", width: 150},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人全称", width: 230},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期", format: 'Y-m-d', width: 100},
        {dataIndex: "ZW_XY_NO", type: "string", text: "协议号", width: 150},
        {dataIndex: "XY_AMT", type: "float", text: "协议金额(元)", type: "float", editor: 'numberfield', width: 150},
        {dataIndex: "HL_RATE", type: "string", text: "汇率", width: 100, hidden: zwlb_id == 'wb' ? false : true},
        {dataIndex: "CUR_NAME", type: "string", text: "币种", width: 100, hidden: zwlb_id == 'wb' ? false : true},
        {
            dataIndex: "XY_AMT_RMB",
            type: "float",
            text: "协议金额(人民币)",
            hidden: zwlb_id == 'wb' ? false : true,
            type: "float",
            editor: 'numberfield',
            width: 150
        },
        {dataIndex: "ZWQX_ID", type: "string", text: "债务期限(月)", width: 150, hidden: true},
        {dataIndex: "ZJYT_NAME", type: "string", text: "资金用途", width: 150, hidden: true}
    ];

    var simplyGrid = new DSYGridV2();
    var grid = simplyGrid.create({
        itemId: 'grid_dqzw_pppzh_zw',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        autoScroll: true,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            AG_NAME: AG_NAME,
            zwlb_id: zwlb_id,
            selectId: selectId
        },
        dataUrl: 'getPPPZHZWDataList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
//	        },
//	        features: [{
//	            ftype: 'summary'
//	        }],
    });

    //将form添加到表格中
    var searchTool = initWindow_dqzw_pppzh_zw_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}
/**
 * 初始化到期债务(有计划)弹出框搜索区域
 */
function initWindow_dqzw_pppzh_zw_grid_searchTool() {
    //初始化查询控件
    var items = [];
    items.push(
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'PPPZH_MHCH',
            itemId: 'yjh_contentGrid_search',
            columnWidth: .7,
            labelWidth: 80,
            labelAlign: 'right',
            emptyText: '请输入债务单位/债务名称',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    var key = e.getKey();
                    if (key == Ext.EventObject.ENTER) {
                        //reloadGrid();
                        getZWHBDataList();
                    }
                }
            }
        }
    );
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid');
    return searchTool.create({
        items: items,
        dock: 'top',
        defaults: {
            labelWidth: 0,
            labelAlign: 'right',
            columnWidth: null,
            margin: '5 5 5 5'
        },//查询，重置按钮靠右显示
        // 查询按钮回调函数
        callback: function (self) {
            getZWHBDataList();
        }
    });
}
/**
 * 获取债务还本信息查询按钮实现
 */
function getZWHBDataList() {
    var store = DSYGrid.getGrid('grid_dqzw_pppzh_zw').getStore();
    var search_form = DSYGrid.getGrid('grid_dqzw_pppzh_zw').down('form');
    // 清空参数中已有的查询项
    for (var search_form_i in search_form.getValues()) {
        delete store.getProxy().extraParams[search_form_i];
    }
    // 向grid中追加参数
    $.extend(true, store.getProxy().extraParams, search_form.getValues());
    // 给导出按钮追加查询参数
    //  $.extend(true, DSYGrid.getBtnExport('grid').param, search_form.getValues());
    // 刷新表格
    store.loadPage(1);
}
/**
 * ppp转化申请单弹出窗口
 */
function initWindow_debt_add_pppzh(config) {
    config = $.extend({}, {
        disabled: false,
        gridId: ''
    }, config);
    return Ext.create('Ext.window.Window', {
        title: TITLE, // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        maximizable: true,//最大化按钮
        layout: 'fit',
        itemId: 'window_debt_add_pppzh', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [
            {
                xtype: 'tabpanel',
                items: [
                    {
                        title: '单据',
                        layout: 'fit',
                        items: [initWindow_debt_add_pppzh_contentForm()]
                    },
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'window_save_zcxx_file_panel',
                                items: [initWindow_save_zcxx_tab_upload(config)]
                            }
                        ]
                    }
                ]
            }
        ],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    //保存表单数据s
                    var form = btn.up('window').down('form');
                    var grid = form.down('grid#debt_add_pppzh_grid');
                    grid.getPlugin('debt_add_pppzh_grid_plugin_cell').completeEdit();
                    if (window.flag_validateedit && !window.flag_validateedit.isHidden()) {
                        return false;//如果校验未通过
                    }
                    submitInfo(btn, form);
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
                window_debt_add_pppzh.window = null;
            }
        }
    });
}
/**
 * 初始化偿债资金申请单表单
 */
function initWindow_debt_add_pppzh_contentForm() {
    var itemmingxi = [];
    if (isModify == 0) {
        itemmingxi = [
            {fieldLabel: '申请单ID', name: 'CHBJ_ID', xtype: 'textfield', hidden: true},
            {fieldLabel: '申请单位', name: 'AG_NAME', xtype: 'textfield', readOnly: true, align: 'left'},
            {fieldLabel: '申请单位代码', name: 'AG_CODE', xtype: 'hiddenfield', align: 'left'},
            {
                fieldLabel: zjly_id == '04' ? '<span class="required">✶</span>债务核销日期' : '<span class="required">✶</span>转化生效日期', align: 'left',
                xtype: 'datefield',
                name: 'PAY_DATE',
                format: 'Y-m-d',
                value: today
            },
            {
                fieldLabel: zjly_id == '04' ? "债务核销金额" : '债务转化金额', xtype: "numberFieldFormat", hideTrigger: true, align: 'left',
                name: 'PAY_AMT_RMB', readOnly: true /*, disabled: true*/
            },
            {
                xtype: "textfield",
                fieldLabel: '<span class="required">✶</span>转为PPP项目编码',
                name: 'PPPXM_CODE',
                width: 650,
                hidden: zjly_id == '04' ? true : false,
                align: 'left'
            },
            {
                fieldLabel: '<span class="required">✶</span>转为PPP项目名称',
                xtype: "textfield",
                name: 'PPPXM_NAME',
                width: 650,
                hidden: zjly_id == '04' ? true : false,
                align: 'left'
            },
            {
                fieldLabel: '<span class="required">✶</span>项目总投资（万元）',
                decimalPrecision: 4,
                xtype: "numberFieldFormat",
                hideTrigger: true,
                name: 'PPPXM_AMT',
                width: 650,
                hidden: zjly_id == '04' ? true : false,
                maxValue:9999999999,
                align: 'left'
            },
            {
                fieldLabel: '<span class="required">✶</span>项目公司机构代码',
                xtype: "textfield",
                name: 'XMGS_CODE',
                width: 650,
                hidden: zjly_id == '04' ? true : false,
                align: 'left'
            },
            {
                fieldLabel: '<span class="required">✶</span>项目公司名称',
                xtype: "textfield",
                name: 'XMGS_NAME',
                width: 650,
                hidden: zjly_id == '04' ? true : false,
                align: 'left'
            },
            {
                fieldLabel: zjly_id == '04' ? '<span class="required">✶</span>核销原因' : '备注',
                xtype: "textfield",
                name: 'REMARK',
                columnWidth: .99
            }
        ]
    } else {
        itemmingxi = [
            {fieldLabel: '申请单ID', name: 'CHBJ_ID', xtype: 'textfield', hidden: true},
            {fieldLabel: '申请单号', name: 'CHBJ_CODE', readOnly: true, xtype: 'textfield', width: 270},
            {fieldLabel: '申请单位', name: 'AG_NAME', xtype: 'textfield', readOnly: true},
            {fieldLabel: '申请单位代码', name: 'AG_CODE', xtype: 'hiddenfield'},
            {
                fieldLabel: zjly_id == '04' ? '<span class="required">✶</span>债务核销日期' : '<span class="required">✶</span>转化生效日期',
                xtype: 'datefield',
                name: 'PAY_DATE',
                format: 'Y-m-d',
                value: today
            },
            {
                fieldLabel: zjly_id == '04' ? "债务核销金额" : '债务转化金额', xtype: "numberFieldFormat", hideTrigger: true,
                name: 'PAY_AMT_RMB', readOnly: true /*disabled: true*/
            },
            {
                xtype: "textfield",
                fieldLabel: '<span class="required">✶</span>转为PPP项目编码',
                name: 'PPPXM_CODE',
                width: 650,
                hidden: zjly_id == '04' ? true : false
            },
            {
                fieldLabel: '<span class="required">✶</span>转为PPP项目名称',
                xtype: "textfield",
                name: 'PPPXM_NAME',
                width: 650,
                hidden: zjly_id == '04' ? true : false
            },
            {
                fieldLabel: '<span class="required">✶</span>项目总投资（万元）',
                decimalPrecision: 4,
                xtype: "numberFieldFormat",
                hideTrigger: true,
                name: 'PPPXM_AMT',
                width: 650,
                maxValue:9999999999,
                hidden: zjly_id == '04' ? true : false
            },
            {
                fieldLabel: '<span class="required">✶</span>项目公司机构代码',
                xtype: "textfield",
                name: 'XMGS_CODE',
                width: 650,
                hidden: zjly_id == '04' ? true : false
            },
            {
                fieldLabel: '<span class="required">✶</span>项目公司名称',
                xtype: "textfield",
                name: 'XMGS_NAME',
                width: 650,
                hidden: zjly_id == '04' ? true : false
            },
            {
                fieldLabel: zjly_id == '04' ? '<span class="required">✶</span>核销原因' : '备注',
                xtype: "textfield",
                name: 'REMARK',
                columnWidth: .99
            }
        ]
    }
    return Ext.create('Ext.form.Panel', {
        //title: '详情表单',
        width: '100%',
        height: '100%',
        itemId: 'window_debt_add_pppzh_form',
        layout: 'vbox',
        defaultType: 'textfield',
        items: [
            //{ xtype: 'hiddenfield', name: 'userPageMenu.id' },
            {
                xtype: 'container',
                layout: 'column',
                width: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 210,
                    labelWidth: zjly_id == '04' ? 100 : 135//控件默认标签宽度
                },
                items: itemmingxi
            },
            {
                xtype: 'fieldset',
                width: '100%',
                title: '单据明细',
                layout: 'fit',
                flex: 1,
                margin: '2 5 0 5',
                collapsible: false,
                items: [
                    initWindow_debt_add_pppzh_contentForm_grid()
                ]
            }
        ]
    });

}
/**
 * 初始化偿债资金申请单表单中的表格
 */
function initWindow_debt_add_pppzh_contentForm_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        // {dataIndex: "AG_NAME", type: "string", width:135, text: "债务单位"},
        {dataIndex: "CHBJ_ID", type: "string", width: 300, text: "CHBJ_ID", hidden: true},
        {
            dataIndex: "ZW_NAME", type: "string", text: "债务名称", align: 'right', width: 150,
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
        {dataIndex: "ZQLX_NAME", type: "string", width: 130, text: "债权类型"},
        {dataIndex: "ZQR_NAME", type: "string", width: 130, text: "债权人"},
        {
            dataIndex: "DUE_AMT", type: "float", text: "到期金额(元)", width: 130, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "APPLY_AMT", type: "float", text: zjly_id == '04' ? "申请核销金额(元)" : "申请转化金额(元)", tdCls: 'grid-cell',
            editor: {
                xtype: 'numberfield',
                hideTrigger: true
            }, width: 180
        },
        {
            dataIndex: "HKJH_DATE", type: "string", text: "到期日期", width: 130, align: 'right',
            renderer: function (value) {
                return dsyDateFormat(value);
            }
        },
        {
            dataIndex: "ZW_YE", type: "float", text: "债务余额(元)", width: 120, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "ZQR_FULLNAME", type: "string", width: 130, text: "债权人名称"},
        {dataIndex: "ZW_CODE", type: "string", width: 180, text: "债务编码"},
        {dataIndex: "ZWLB_NAME", type: "string", width: 130, text: "债务类型"},
        {
            dataIndex: "XM_NAME", type: "string", text: "建设项目", width: 150, hidden: zjly_id == '04' ? true : false,
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
            dataIndex: "HKJH_DATE", type: "string", text: "到期日期", width: 120, align: 'right', hidden: zjly_id == '04' ? true : false,
            renderer: function (value) {
                return dsyDateFormat(value);
            }
        },
        {
            dataIndex: "DUE_AMT", type: "float", text: "应还款金额(元)", width: 130, summaryType: 'sum', hidden: zjly_id == '04' ? true : false,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: zjly_id == '04' ? "核销金额" : "转化金额",
            dataIndex: "APPLY_AMT",
            type: "float",
            tdCls: 'grid-cell',
            hidden: zjly_id == '04' ? true : false,
            editor: {xtype: 'numberfield', hideTrigger: true},
            width: 180
        },
        {
            dataIndex: "JZ_DATE", type: "string", text: "记账日期", editor: 'datefield', hidden: zjly_id == '04' ? true : false,
            renderer: function (value, metaData, record) {
                if (value == null || value == '') {
                    return value;
                }
                var newValue = dsyDateFormat(value);
                record.data.JZ_DATE = newValue;
                return newValue;
            }
        },
        {dataIndex: "JZ_NO", type: "string", text: "会计凭证号", editor: 'textfield', width: 100, hidden: zjly_id == '04' ? true : false},

        {
            dataIndex: "CHBJ_TYPE", type: "string", text: "还款类型", width: 80, hidden: zjly_id == '04' ? true : false,
            editor: {
                xtype: 'combobox',
                itemId: 'chtype',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                store: ChbjTypeStore
            },
            renderer: function (value) {
                var record = ChbjTypeStore.findRecord('code', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {dataIndex: "HL_RATE", type: "string", text: "汇率", editor: 'textfield', width: 100, hidden: zwlb_id == 'wb' ? false : true},
        {
            text: zjly_id == '04' ? "核销金额(人民币)" : "转化金额(人民币)",
            dataIndex: "APPLY_AMT_RMB",
            type: "float",
            width: 185,
            hidden: zwlb_id == 'wb' ? false : true
        },
        {dataIndex: "CUR_NAME", type: "string", text: "币种", hidden: zwlb_id == 'wb' ? false : true},
        {dataIndex: "ZWLB_NAME", type: "string", text: "债务类别", hidden: zjly_id == '04' ? true : false},
        {
            dataIndex: "SIGN_DATE", type: "string", text: "签订日期", hidden: zjly_id == '04' ? true : false,
            renderer: function (value, metaData, record) {
                var newValue = dsyDateFormat(value);
                record.data.SIGN_DATE = newValue;
                return newValue;
            }
        },
        {dataIndex: "ZW_XY_NO", type: "string", text: "协议号", width: 150, hidden: zjly_id == '04' ? true : false},
        {dataIndex: "XY_AMT", type: "float", text: "协议金额", type: "float", width: 150, hidden: zjly_id == '04' ? true : false},
        {dataIndex: "ZW_CODE", type: "string", text: "债务编码", hidden: true},
        {dataIndex: "CH_TYPE_NAME", type: "string", text: "类型", width: 50, hidden: true},
        {dataIndex: "FETCH_AMT", type: "float", text: "举债金额", width: 120, hidden: true},
        {
            dataIndex: "ZJLY_ID", type: "string", text: "偿还资金来源", width: 260, align: 'right', hidden: true,
            editor: {
                xtype: 'treecombobox',
                store: store_DEBT_ZJLY,
                itemId: 'zjlyid',
                //store: DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:condition}),
                selectModel: 'leaf',
                displayField: 'name',
                valueField: 'code',
                readOnly: true
            },
            renderer: function (value) {
                var record = store_DEBT_ZJLY.findNode('code', value, true, true, true);
                return record != null ? record.get('name') : value;
            }, hidden: true
        },
        {dataIndex: "CHBJ_AMT", type: "float", text: "已申请金额(原币)", width: 180, hidden: true,},
        {dataIndex: "CHBJ_AMT_RMB", type: "float", text: "已申请金额(人民币)", width: 180, hidden: true,}
    ];
    var tbar = [];
    var grid = DSYGrid.createGrid({
        itemId: 'debt_add_pppzh_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'debt_add_pppzh_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    'validateedit': function (editor, context) {
                        if (context.field == 'APPLY_AMT') {
                            window.flag_validateedit == null;
                            //新插入的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前到期金额-已申请金额（汇总）
                            //已经存在的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前数据库中计算得到的：到期金额-已申请金额（汇总）+当年申请金额
                            //故：当年申请金额<=当年申请金额最大值APPLY_AMOUNT_MAX
                            if (context.record.get('CH_TYPE') == 0 && context.value > context.record.get('DUE_AMT')) {
                                window.flag_validateedit = Ext.Msg.alert('提示', '当前申请金额不能超过到期金额' + context.record.get('DUE_AMT'));
                                return false;
                            }
                        }
                    },
                    'edit': function (editor, context) {
                        //自动计算金额
                        if (context.field == 'HL_RATE' || context.field == 'APPLY_AMT') {
                            var apply_amt = context.record.get("APPLY_AMT");
                            var rate = context.record.get("HL_RATE");
                            context.record.set('APPLY_AMT_RMB', apply_amt * rate);
                        }
                    }
                }
            }
        ],
        checkBox: false,
        rowNumber: true,
        border: true,
        tbar: tbar,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        data: [],
        pageConfig: {
            enablePage: false
        }
    });
    //加日期格式转换
    grid.getStore().on('endupdate', function () {
        var self = grid.getStore();
        //计算偿还资金录入窗口form申请金额
        var sum_PAY_AMT_RMB = 0;
        self.each(function (record) {
            sum_PAY_AMT_RMB += record.get('APPLY_AMT');
        });
        Ext.ComponentQuery.query('textfield[name="PAY_AMT_RMB"]')[0].setValue(sum_PAY_AMT_RMB)
    });
    return grid;
}
function getSelectId() {
    var store = DSYGrid.getGrid('debt_add_apply_grid').getStore();
    selectId = new Array();
    store.each(function (record) {
        if (null != record.get('YDCH_ID') && '' != record.get('YDCH_ID') && typeof(record.get('YDCH_ID')) != 'undefined') {
            selectId.push(record.get('YDCH_ID'));
        }
    });
}
/**
 * validateedit 保存逻辑
 */
function submitInfo(btn, form) {
    //获取单据明细数组
    var PAY_DATE = form.getForm().findField('PAY_DATE').getValue();
    var PPPXM_CODE = form.getForm().findField('PPPXM_CODE').getValue();
    var PPPXM_NAME = form.getForm().findField('PPPXM_NAME').getValue();
    var PPPXM_AMT = form.getForm().findField('PPPXM_AMT').getValue();
    var XMGS_CODE = form.getForm().findField('XMGS_CODE').getValue();
    var XMGS_NAME = form.getForm().findField('XMGS_NAME').getValue();
    var REMARK = form.getForm().findField('REMARK').getValue();
    var recordArray = [];
    if (PAY_DATE == null) {
        //message_error = '申请日期不能为空';
        Ext.Msg.alert('提示', '申请日期不能为空');
        return;
    } else {
        PAY_DATE = dsyDateFormat(PAY_DATE);
        if (!compareDate(PAY_DATE, '申请日期')) {
            return;
        }
    }
    if (zjly_id != '04') {
        if (PPPXM_CODE == null || PPPXM_CODE == "") {
            Ext.Msg.alert('提示', '转为PPP项目编码不能为空');
            return;
        }
        if (PPPXM_NAME == null || PPPXM_NAME == "") {
            Ext.Msg.alert('提示', '转为PPP项目名称不能为空');
            return;
        }
        if (PPPXM_AMT == null || PPPXM_AMT == "") {
            Ext.Msg.alert('提示', '项目总投资(万元)不能为空');
            return;
        }
        if (XMGS_CODE == null || XMGS_CODE == "") {
            Ext.Msg.alert('提示', '项目公司机构代码不能为空');
            return;
        }
        if (XMGS_NAME == null || XMGS_NAME == "") {
            Ext.Msg.alert('提示', '项目公司公司名称不能为空');
            return;
        }
    } else {
        if (REMARK == null || REMARK == "") {
            Ext.Msg.alert('提示', '核销原因不能为空');
            return;
        }
    }
    var message_error = null;
    var sysDate = new Date();
    var today = '';
    today = sysDate.getFullYear() + '-'
        + (sysDate.getMonth() < 9 ? ('0' + (sysDate.getMonth() + 1)) : (sysDate.getMonth() + 1)) + '-'
        + (sysDate.getDate() < 10 ? ('0' + (sysDate.getDate())) : (sysDate.getDate()));
    
    var totalAmt = false;//判断转化总金额是否大于0
    var sum_apply_amt = 0;//（核销/转化）金额合计值
    var zw_ye = form.down('grid').getStore().getData().items[0].data.ZW_YE;
    form.down('grid').getStore().each(function (record) {
        if (record.get('JZ_DATE') != "" && record.get('JZ_DATE') != null) {

            var JZ_DATE = dsyDateFormat(record.get('JZ_DATE'));
            var sss = dsyDateFormat(JZ_DATE);

            if (sss > today) {
                message_error = "记账日期早于当前日期！";
                return false;
            } else {
                record.set('JZ_DATE', dsyDateFormat(record.get('JZ_DATE')));
            }
        }
        if (record.get('APPLY_AMT') == null || record.get('APPLY_AMT') < 0) {
            if (zjly_id == '04') {
                message_error = '核销金额不能为空';
            } else {
                message_error = '转化金额不能为空';
            }
            return;
        }
        if(record.get('APPLY_AMT') > 0){
        	totalAmt = true;
            sum_apply_amt += record.get('APPLY_AMT');
        }
        
        if (record.get('ZJLY_ID') == null || record.get('ZJLY_ID') == "") {
            message_error = '请选择偿还资金来源';
            return;
        }
        recordArray.push(record.getData(record.get('JZ_DATE')));
    });
    if(totalAmt == false){
        if (zjly_id == '04') {
        	Ext.Msg.alert('提示', '核销总金额不能为0');
        } else {
        	Ext.Msg.alert('提示', '转化总金额不能为0或负值');
        }
        return false;
    }
    if (accSub(zw_ye,sum_apply_amt) < 0 && Math.abs(accSub(zw_ye,sum_apply_amt)) > 0.01) {
        if (zjly_id == '04') {
            Ext.Msg.alert('提示', '核销总金额不能超过债务余额');
        } else {
            Ext.Msg.alert('提示', '转化总金额不能超过债务余额');
        }
        return false;
    }
    
    if (message_error != null && message_error != '') {
        Ext.Msg.alert('提示', message_error);
        return false;
    }
    var parameters = {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        AG_NAME: AG_NAME,
        PAY_DATE: PAY_DATE,
        PPPXM_CODE: PPPXM_CODE,
        PPPXM_NAME: PPPXM_NAME,
        PPPXM_AMT: PPPXM_AMT,
        XMGS_CODE: XMGS_CODE,
        XMGS_NAME: XMGS_NAME,
        IS_WF: IS_WF,
        detailList: Ext.util.JSON.encode(recordArray)
    };
    if (button_name == '修改') {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        parameters['CHBJ_CODE'] = records[0].get('CHBJ_CODE');
        parameters['CHBJ_ID'] = records[0].get('CHBJ_ID');
    }
    if (form.isValid()) {
        //保存表单数据及明细数据
        btn.setDisabled(true);
        form.submit({
            //设置表单提交的url
            url: '/saveZwglPPPZhGrid.action',
            params: parameters,
            success: function (form, action) {
                //关闭弹出框
                btn.up("window").close();
                //提示保存成功
                Ext.toast({
                    html: "<center>保存成功!</center>",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
            },
            failure: function (form, action) {
                btn.setDisabled(false);
                var result = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
            }
        });
    }
}
/**
 * 查询按钮实现
 */
function getPPPZhDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield[name="contentGrid_search"]')[0].getValue();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        wf_status: WF_STATUS,
        wf_id: wf_id,
        node_code: node_code,
        zwlb_id: zwlb_id,
        mhcx: mhcx,
        zjly_id: zjly_id
    };
    store.loadPage(1);
}
/**
 * 删除按钮实现
 */
function delPPPZhDataSelectedList(btn) {
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
            var ids = new Array();
            for (var i in records) {
                ids.push(records[i].get("CHBJ_ID"));
            }
            //发送ajax请求，删除数据
            $.post("/deletePPPZhSbGrid.action", {
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
    });
}
/**
 * 送审
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = new Array();
    for (var i in records) {
        ids.push(records[i].get("CHBJ_ID"));
    }
    button_name = btn.text;
    btn.name = 'send';
    button_id = btn.name;
    //是否确认送审
    Ext.MessageBox.show({
        title: "提示",
        msg: "确认送审选中记录？",
        width: 200,
        buttons: Ext.MessageBox.OKCANCEL,
        fn: function (buttonId,text) {
        	if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/doWorkFlowActionPPP.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info:'',
                    ids: ids,
                    busi_type: busi_type,
                    is_end: is_end
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
                        Ext.MessageBox.alert('提示', data.msg);
                    }
                    //刷新表格
                    DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                }, "json");
             }
          }
      });
}
function compareDate(date, typeString) {

    var sysDate = new Date();
    var today = '';
    today = sysDate.getFullYear() + '-'
        + (sysDate.getMonth() < 9 ? ('0' + (sysDate.getMonth() + 1)) : (sysDate.getMonth() + 1)) + '-'
        + (sysDate.getDate() < 10 ? ('0' + (sysDate.getDate())) : (sysDate.getDate()));

    if (date > today) {
        Ext.MessageBox.alert('提示', typeString + "应早于当前日期！");
        return false;
    }
    return true;

}
/*//撤销按钮操作
function cancelaction(btn){
Ext.MessageBox.show({
    title: '提示',
    msg: "是否撤销选择的记录？",
    width: 200,
    buttons: Ext.MessageBox.YESNO,
    fn: function (btn) {
        button_name = btn.text;
        if (btn == "yes") {
            return true;
        }else{
        	return false;
        }
    }
     
});
}*/
/**
 * 还本付息资金审核撤销送审
 */
function cancleCheck(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
    	Ext.MessageBox.show({
    	    title: '提示',
    	    msg: "是否撤销选择的记录？",
    	    width: 200,
    	    buttons: Ext.MessageBox.YESNO,
    	    fn: function (btn) {
     	        if (btn == "yes") {
    	        	var hbfxInfoArray = [];
    	            Ext.each(records, function (record) {
    	                var array = {};
    	                array.ID = record.get("CHBJ_ID");
    	                hbfxInfoArray.push(array);
    	            });
    	            var btn_name = 'cancel';

    	            //向后台传递变更数据信息
    	            Ext.Ajax.request({
    	                method: 'POST',
    	                url: 'doWorkFlowActionPPP.action',
    	                params: {
    	                    workflow_direction: btn_name,
    	                    wf_id: wf_id,
    	                    node_code: node_code,
    	                    button_name: button_name,
    	                    is_end: is_end,
    	                    hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)

    	                },
    	                async: false,
    	                success: function (form, action) {
    	                    Ext.MessageBox.show({
    	                        title: '提示',
    	                        msg: '撤销送审成功',
    	                        width: 200,
    	                        buttons: Ext.MessageBox.OK,
    	                        fn: function (btn) {
    	                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
    	                        }
    	                    });
    	                },
    	                failure: function (form, action) {
    	                    Ext.MessageBox.show({
    	                        title: '提示',
    	                        msg: '撤销送审失败',
    	                        width: 200,
    	                        fn: function (btn) {
    	                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
    	                        }
    	                    });
    	                }
    	            });
    	        }else{
    	        	return false;
    	        }
    	    }
    	     
    	});
        
    }
  
}
 
	