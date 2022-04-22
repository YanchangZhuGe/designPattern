Ext.define('ZQModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id', mapping: 'ZQ_ID'},
        {name: 'name', mapping: 'ZQ_NAME'}
    ]
});
var wf_id = getQueryParam("wf_id");//当前流程id
var node_code = getQueryParam("node_code");//当前节点id
var node_type = getQueryParam("node_type");//当前节点标识
var ZC_TYPE = getQueryParam("ZC_TYPE");//支出类型：0新增债券类型 1置换债券类型
ZC_TYPE = 0;
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮的name，标识按钮状态
var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}
var km_year = nowDate.substr(0, 4);
var km_condition = km_year <= 2017 ? " <= '2017' " : " = '" + km_year + "' ";
var store_GNFL = DebtEleTreeStoreDB('EXPFUNC', {condition: "and year " + km_condition});
var store_JJFL = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});
var zqNameStore = getZqNameStore();
/**
 * 获取系统参数:
 * 选择债券后，根据系统参数判断是否需要按照发行计划控制，
 * 如果控制，则查询所选债券的发行批次对应是否有发行计划，如果有，则后面的选择项目对话框中的项目应该是该批次发行计划中包含的项目明细；
 * 如果不控制或没有发行计划，则可选非首轮项目申报中已经由省级审批通过的所有项目
 */
var DEBT_CONN_ZQXM = 1;//默认控制
$.post("getParamValueAll.action", function (data) {
    DEBT_CONN_ZQXM = parseInt(data[0].DEBT_CONN_ZQXM_XZ);
},"json");
/*年度*/
var debt_year_store = [
    // {id: "2010", code: "2010", name: "2010年"},
    // {id: "2011", code: "2011", name: "2011年"},
    // {id: "2012", code: "2012", name: "2012年"},
    // {id: "2013", code: "2013", name: "2013年"},
    // {id: "2014", code: "2014", name: "2014年"},
    // {id: "2015", code: "2015", name: "2015年"},
    {id: "2016", code: "2016", name: "2016年"},
    {id: "2017", code: "2017", name: "2017年"},
    {id: "2018", code: "2018", name: "2018年"},
    {id: "2019", code: "2019", name: "2019年"},
    {id: "2020", code: "2020", name: "2020年"},
    {id: "2021", code: "2021", name: "2021年"},
    {id: "2022", code: "2022", name: "2022年"},
    {id: "2023", code: "2023", name: "2023年"},
    {id: "2024", code: "2024", name: "2024年"},
    {id: "2025", code: "2025", name: "2025年"}
    // {id: "2026", code: "2026", name: "2026年"},
    // {id: "2027", code: "2027", name: "2027年"},
    // {id: "2028", code: "2028", name: "2028年"},
    // {id: "2029", code: "2029", name: "2029年"},
    // {id: "2030", code: "2030", name: "2030年"},
];


/**
 * 获取债券名称
 */
function getZqNameStore() {
    var zqNameDataStore = Ext.create('Ext.data.Store', {
        model: 'ZQModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getZqNameData.action",
            reader: {
                type: 'json'
            },
            extraParams: {
                ZC_TYPE: ZC_TYPE
            }
        },
        autoLoad: true
    });
    return zqNameDataStore;
}

/**
 * 通用配置json
 */
var json_common = {
    zclr: {//新增债券支出录入
        items: {
            '001': [
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
                    text: '录入',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        //store_JJFL = DebtEleTreeStoreDB('EXPECO');
                        button_name = btn.text;
                        button_status = btn.name;
                        var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                        AD_CODE = treeArray[0].getSelection()[0].get('code');
                        AD_NAME = treeArray[0].getSelection()[0].get('text');
                        if (treeArray[1].getSelection()[0] != undefined) {
                            AG_CODE = treeArray[1].getSelection()[0].get('code');
                            AG_ID = treeArray[1].getSelection()[0].get('id');
                            AG_NAME = treeArray[1].getSelection()[0].get('text');
                        }
                        //弹出项目选择框
                        var window_zhmx = initWindow_select_xzzq()
                        window_zhmx.show();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                            btn.setDisabled(false);
                            return;
                        }
                        //修改全局变量的值
                        //store_JJFL = DebtEleTreeStoreDB('EXPECO');
                        button_name = btn.text;
                        button_status = btn.name;
                        initZcxxData_update({
                            ZCD_ID: records[0].get("ZCD_ID"),
                            editable: true
                        });
                        btn.setDisabled(false);
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        }
                        for (var i in records) {
                            var record = records[i];
                            if (!record.data.ZCD_ID || record.data.ZCD_ID == '') {
                                Ext.MessageBox.alert('提示', '删除数据必须具有支出单ID');
                                return false;
                            }
                        }
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                button_name = btn.text;
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("ZCD_ID"));
                                }
                                //发送ajax请求，删除数据
                                $.post("/deleteKkdfGrid.action", {
                                    ids: ids,
                                    wf_id: wf_id,
                                    node_code: node_code,
                                    WF_STATUS: WF_STATUS,
                                    button_name: button_name
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
                        });
                    }
                },
                {
                    xtype: 'button',
                    text: '送审',
                    name: 'down',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
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
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                            btn.setDisabled(false);
                            return;
                        }
                        //修改全局变量的值
                        //store_JJFL = DebtEleTreeStoreDB('EXPECO');
                        button_name = btn.text;
                        button_status = btn.name;
                        initZcxxData_update({
                            ZCD_ID: records[0].get("ZCD_ID"),
                            editable: true
                        });
                        btn.setDisabled(false);
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        }
                        for (var i in records) {
                            var record = records[i];
                            if (!record.data.ZCD_ID || record.data.ZCD_ID == '') {
                                Ext.MessageBox.alert('提示', '删除数据必须具有支出单ID');
                                return false;
                            }
                        }
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                button_name = btn.text;
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("ZCD_ID"));
                                }
                                //发送ajax请求，删除数据
                                $.post("/deleteKkdfGrid.action", {
                                    ids: ids,
                                    wf_id: wf_id,
                                    node_code: node_code,
                                    WF_STATUS: WF_STATUS,
                                    button_name: button_name
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
                        });
                    }
                },
                {
                    xtype: 'button',
                    text: '送审',
                    name: 'down',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_zt0),
            ZC_TYPE: DebtEleStore(json_debt_zqzclx)
        }
    },
    zcsh: {//新增债券支出审核
        items: {
            '001': [
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
                    text: '审核',
                    name: 'down',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
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
                        button_name = btn.text;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销审核',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
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
                    handler: function () {
                        oprationRecord();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
            // 20210713 guoyf 审核岗去除被退回、曾经办、状态
            /*'008': [
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
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]*/
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_sh),
            ZC_TYPE: DebtEleStore(json_debt_zqzclx)
        }
    }
};

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
        var id = records[0].get("ZCD_ID");
        fuc_getWorkFlowLog(id);
    }
}

/**
 * 页面初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    //initContent();
    if (!wf_id || node_code == 1) {
        initContent();
        return false;
    }
    $.post("getWfNodeName.action?wf_id=" + wf_id + "&node_code=" + node_code, function (data) {
        data = Ext.util.JSON.encode(data);
        var nodeType = data[0].NODE_TYPE;
        var json_zt = json_debt_sh;
        //根据节点名称初始化状态下拉框store
        // 20210713 guoyf 审核岗去除被退回、曾经办、状态
        /*if (nodeType == "END") {
            json_zt = json_debt_zt2_4;
        } else {
            json_zt = json_debt_zt2;
        }*/
        initContent();
        //根据节点名称修改状态下拉框store
        var combobox_status = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]');
        if (typeof combobox_status != 'undefined' && combobox_status != null && combobox_status.length > 0 && json_zt != null) {
            combobox_status[0].setStore(DebtEleStore(json_zt));
        }
    });
});

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
                items: Ext.Array.union(json_common[node_type].items[WF_STATUS], json_common[node_type].items['common'])
            }
        ],
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                },
                items_tree: json_common[node_type].items_content_tree
            }),
            initContentRightPanel()
        ]
    });
}

/**
 * 初始化右侧panel，放置表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        dockedItems: json_common[node_type].items_content_rightPanel_dockedItems ? json_common[node_type].items_content_rightPanel_dockedItems : null,
        items: [
            initContentGrid()
        ]
    });
}

/**
 * 初始化主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "支出单ID", dataIndex: "ZCD_ID", type: "string", hidden: true},
        {text: "支出单编码", dataIndex: "ZCD_CODE", type: "string", width: 230},
        {text: "所属区划", dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_NAME", type: "string"},
        {text: "所属单位", dataIndex: "AG_ID", type: "string", hidden: true},
        {text: "所属单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
        {text: "所属单位", dataIndex: "AG_NAME", type: "string", width: 250},
        {text: "支出总额(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", width: 160},
        {text: "指标文号", dataIndex: "ZBWH", type: "string", width: 160},
        {text: "录入人", dataIndex: "ZCD_LR_USER_NAME", type: "string", width: 200},
        {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string", hidden: true},
        {text: "备注", dataIndex: "ZCD_REMARK", type: "string",width: 200}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            ZC_TYPE: ZC_TYPE,
            SJLY: 0
        },
        dataUrl: '/getKkdfMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: json_common[node_type].store['WF_STATUS'],
                width: 110,
                labelWidth: 30,
                editable: false, //禁用编辑
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(Ext.Array.union(json_common[node_type].items[WF_STATUS], json_common[node_type].items['common']));
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            },
            {
                fieldLabel: '债券名称',
                name: 'ZQ_NAME',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: zqNameStore,
                width: 250,
                labelWidth: 60,
                labelAlign: 'left',
                hidden: true
            }
        ],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                //store_JJFL = DebtEleTreeStoreDB('EXPECO');
                initZcxxData_update({
                    ZCD_ID: record.get("ZCD_ID"),
                    editable: false
                });
            }
        }
    });
}




/**
 * 初始化新增债券发行计划选择弹出窗口
 */
function initWindow_select_xzzq(param) {
    return Ext.create('Ext.window.Window', {
        title: '库款垫付项目选择', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_select_xzzq', // 窗口标识
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_select_xzzq_grid(param)],
        buttons: [
            {
                id: 'downSelectBtn',
                text: '确认',
                ZCD_YEAR: (param && param.ZCD_YEAR) ? param.ZCD_YEAR : nowDate.substring(0, 4),
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    //校验所有插入的发行计划都是同一单位
                    var ag_id = null;
                    var ids = [];
                    var is_show = records[0].data.IS_SHOW;
                    for (var i in records) {
                        ids[i] = records[i].data.XM_ID;
                        if (!records[i].get('AG_ID') || records[i].get('AG_ID') == '') {
                            Ext.MessageBox.alert('提示', '所选数据必须都具有单位！');
                            return false;
                        }
                        if (!ag_id) {
                            ag_id = records[i].get('AG_ID');
                        } else if (ag_id != records[i].get('AG_ID')) {
                            Ext.MessageBox.alert('提示', '所选数据必须是同一单位！');
                            return false;
                        }

                    }

                    initZcxxData_confirm(btn, ids, is_show);
                    Ext.getCmp('downSelectBtn').disable();
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
 * 初始化新增债券发行计划选择弹出框表格
 */
function initWindow_select_xzzq_grid(param) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "单位名称", dataIndex: "AG_NAME", type: "string", width: 220},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 300,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        /*{text: "已下达金额(计划发行额)(元)", dataIndex: "REPLY_AMOUNT", type: "float", width: 200, hidden: DEBT_CONN_ZQXM == 0},
         {text: "已支出金额(元)", dataIndex: "PAY_AMT_SUM", type: "float", width: 150, hidden: DEBT_CONN_ZQXM == 0},
         {text: "项目可支出金额(元 )", dataIndex: "PAY_AMT_MAX_ZQ", width: 200, type: "float", hidden: DEBT_CONN_ZQXM == 0},*/
        {text: "立项年度", dataIndex: "LX_YEAR", type: "string"},
        {text: "建设性质", dataIndex: "JSXZ_NAME", type: "string"},
        {text: "项目类型", dataIndex: "XMLX_NAME", type: "string", width: 180},
        {text: "项目性质", dataIndex: "XMXZ_NAME", type: "string", width: 180},
        {text: "立项审批级次", dataIndex: "SPJC_NAME", type: "string"},
        {text: "计划开工日期", dataIndex: "START_DATE_PLAN", type: "string"},
        {text: "计划竣工日期", dataIndex: "END_DATE_PLAN", type: "string"},
        {text: "实际开工日期", dataIndex: "START_DATE_ACTUAL", type: "string"},
        {text: "实际竣工日期", dataIndex: "END_DATE_ACTUAL", type: "string"},
        {text: "建设状态", dataIndex: "JSZT_NAME", type: "string"},
        {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 220},
        {text: "管理(使用)单位", dataIndex: "USE_UNIT_ID", type: "string", width: 220},
        {text: "计划申报年度", dataIndex: "BILL_YEAR", type: "string"},
        {text: "备注", dataIndex: "REMARK", type: "string", width: 220},
        {text: "是否严格控制支出金额", dataIndex: "IS_SHOW", type: "string", hidden: true}

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'window_select_xzzq_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: true,
        width: '100%',
        flex: 1,
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: (param && param.ag_id) ? param.ag_id : AG_ID,
            ZCD_YEAR: (param && param.ZCD_YEAR) ? param.ZCD_YEAR : nowDate.substring(0, 4),
            ZQ_ID: (param && param.ZQ_ID) ? param.ZQ_ID : '',
            lxyear: '2020'
        },
        dataUrl: '/getKkdfXmInfo.action'
    });
    //将form添加到表格中
    var searchTool = initWindow_xzzq_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}

/**
 * 初始化新增债券计划选择弹出框搜索区域
 */
function initWindow_xzzq_grid_searchTool() {
    //初始化查询控件
    var items = [];
    items.push(
        {
            xtype: 'treecombobox',
            fieldLabel: '项目类型',
            itemId: 'XMLX_SEARCH',
            displayField: 'name',
            valueField: 'code',
            rootVisible: true,
            lines: false,
            selectModel: 'all',
            store: DebtEleTreeStoreDB("DEBT_ZWXMLX")
        },
        {
            xtype: 'combobox',
            fieldLabel: '立项年度',
            itemId: 'SEA_LX_YEAR',
            displayField: 'name',
            valueField: 'code',
            rootVisible: true,
            width: 120,
            labelWidth: 50,
            lines: false,
            value: '2020',
            selectModel: 'all',
            store: DebtEleStore(debt_year_store)
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: 'contentGrid_search',
            //width: 380,
            labelAlign: 'right',
            enableKeyEvents: true,
            emptyText: '请输入项目编码/项目名称/项目管理(使用)单位...',
            listeners: {
                keypress: function (self, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var form = self.up('form');
                        if (form.isValid()) {
                            callBackReload();
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
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
            width: 200,
            margin: '5 5 5 5',
            labelAlign: 'right'
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
        padding: '0 10 0 0',
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    if (form.isValid()) {
                        callBackReload();
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

    function callBackReload() {
        var xmlx = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
        var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
        var lxyear = Ext.ComponentQuery.query('combobox#SEA_LX_YEAR')[0].getValue();
        var grid = DSYGrid.getGrid('window_select_xzzq_grid');
        grid.getStore().getProxy().extraParams['XMLX_SEARCH'] = xmlx;
        grid.getStore().getProxy().extraParams['mhcx'] = mhcx;
        grid.getStore().getProxy().extraParams['lxyear'] = lxyear;
        grid.getStore().load();
    }

    return search_form;
}

/**
 * 初始化债券支出保存弹出窗口
 */
function initWindow_save_zcxx(config) {
    var window_config = {
        title: '库款垫付支出', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        itemId: 'window_save_zcxx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        maximizable: true,
        frame: true,
        constrain: true,
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
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
                            initWindow_save_zcxx_form(config),
                            initWindow_save_zcxx_grid(config)
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
                                itemId: 'window_save_zcxx_file_panel',
                                items: [initWindow_save_zcxx_tab_upload(config)]
                            }
                        ]
                    }
                ],
                listeners: {
                    beforetabchange: function (tabPanel, newCard, oldCard) {
                        tabPanel.up('window').down('button[name=addZC]').setHidden(newCard.name == 'FILE');
                        tabPanel.up('window').down('button[name=deleteZC]').setHidden(newCard.name == 'FILE');
                    }
                }
            }
        ],
        buttons: [
            {
                text: '增加', name: 'addZC', xtype: 'button', width: 80,
                handler: function (btn) {
                    var ag_id = btn.up('window').down('form').down('[name=AG_ID]').getValue();
                    var ZCD_YEAR = btn.up('window').down('form').down('[name=ZCD_YEAR]').getValue();
                    // var ZQ_ID = btn.up('window').down('form').down('[name=ZQ_ID]').getValue();
                    initWindow_select_xzzq({ag_id: ag_id, ZCD_YEAR: ZCD_YEAR}).show();

                }
            },
            {
                text: '删除', name: 'deleteZC', xtype: 'button', width: 80, disabled: true,
                handler: function (btn) {
                    var grid = btn.up('window').down('grid#window_save_zcxx_grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    grid.getPlugin('window_save_zcxx_grid_plugin_cell').cancelEdit();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    } else {
                        //当表格无数据时，清空单位信息
                        btn.up('window').down('form').down('[name=AG_ID]').setValue('');
                        btn.up('window').down('form').down('[name=AG_CODE]').setValue('');
                        btn.up('window').down('form').down('[name=AG_NAME]').setValue('');
                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    // 检验是否有数据
                    // 获取数据
                    var grid = btn.up('window').down('#window_save_zcxx_grid');
                    var celledit = grid.getPlugin('window_save_zcxx_grid_plugin_cell');
                    //完成编辑
                    celledit.completeEdit();
                    if (window.flag_validateedit && !window.flag_validateedit.isHidden()) {
                        return false;//如果校验未通过
                    }
                    var store = grid.getStore();
                    if (store.getCount() < 1) {
                        Ext.MessageBox.alert('提示', '请新增明细数据！');
                        return;
                    }
                    var grid_error_message = checkEditorGrid(grid);
                    if (grid_error_message) {
                        Ext.Msg.alert('提示', grid_error_message);
                        return false;
                    }
                    var recordArray = [];
                    store.each(function (record) {
                        var record_data = record.getData();
                        recordArray.push(record_data);
                    });
                    var data_ZCD = btn.up('window').down('form').getForm().getFieldValues();
                    data_ZCD.ZQ_NAME = '';
                    btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                    //发送ajax请求，保存表格数据
                    $.post('/saveXmkkdf.action', {
                        wf_id: wf_id,
                        node_code: node_code,
                        WF_STATUS: WF_STATUS,
                        node_type: node_type,
                        button_name: button_name,
                        button_status: button_status,
                        ZC_TYPE: ZC_TYPE,
                        data_ZCD: Ext.util.JSON.encode(data_ZCD),
                        dataList: Ext.util.JSON.encode(recordArray)
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            btn.setDisabled(false);
                        } else {
                            //提示保存成功
                            Ext.toast({
                                html: '<div style="text-align: center;">保存成功!</div>',
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //重新加载表格数据
                            DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                            btn.up('window').close();
                        }
                        var condition_str = nowDate.substr(0, 4) <= 2017 ? " <= '2017' " : " = '" + nowDate.substr(0, 4) + "' ";
                        km_year = nowDate.substr(0, 4);
                        store_GNFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                        store_JJFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                        store_GNFL.load();
                        store_JJFL.load();
                    }, "json");
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    var condition_str = nowDate.substr(0, 4) <= 2017 ? " <= '2017' " : " = '" + nowDate.substr(0, 4) + "' ";
                    km_year = nowDate.substr(0, 4);
                    store_GNFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                    store_JJFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                    store_GNFL.load();
                    store_JJFL.load();
                    btn.up('window').close();
                }
            }
        ]
    };
    if (!config.editable) {
        delete window_config.buttons;
        delete window_config.items[0].listeners;
    }
    return Ext.create('Ext.window.Window', window_config);
}

/**
 * 初始化支出保存弹出框表单
 */
function initWindow_save_zcxx_form(config) {
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'window_save_zcxx_form',
        width: '100%',
        layout: 'column',
        border: false,
        defaults: {
            columnWidth: .33,
            margin: '2 5 2 5',
            labelWidth: 85
        },
        margin: '0 0 5 0',
        defaultType: 'textfield',
        items: [
            //可支出总额PAY_XZ_AMT_TOTAL(已支出总额度+剩余可用额度)
            //初始已支出金额PAY_XZ_AMT_YZC_CS(已支出总额度)
            //本单初始支出PAY_XZ_AMT_YZC_BDCS(若是新增：0，若是修改：本单支出总额)
            //本单已支出金额PAY_XZ_AMT_YZC_BD(=本单初始支出，修改支出金额后改变)
            //未支出金额PAY_XZ_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
            {fieldLabel: '地区', name: 'AD_CODE', hidden: true},
            {fieldLabel: '地区', name: 'AD_NAME', readOnly: true, fieldCls: 'form-unedit'},
            // {fieldLabel: '债券', name: 'ZQ_ID', hidden: true},
            // {fieldLabel: '债券名称', name: 'ZQ_NAME', xtype: 'displayfield', columnWidth: .66, readOnly: true},
            // {fieldLabel: '支出类型', name: 'ZC_TYPE_NAME', readOnly: true, fieldCls: 'form-unedit'},
            // {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
            // {fieldLabel: '期限', name: 'ZQQX_NAME', readOnly: true, fieldCls: 'form-unedit'},
            // {
            //     fieldLabel: "新增债券金额",
            //     name: "PAY_XZ_AMT_TOTAL",
            //     xtype: 'numberFieldFormat',
            //     readOnly: true,
            //     fieldCls: 'form-unedit-number'
            // },
            // {fieldLabel: "初始已支出金额", name: "PAY_XZ_AMT_YZC_CS", hidden: true, xtype: 'numberFieldFormat'},
            // {fieldLabel: "本单初始支出金额", name: "PAY_XZ_AMT_YZC_BDCS", hidden: true, xtype: 'numberFieldFormat'},
            // {fieldLabel: "本单已支出金额", name: "PAY_XZ_AMT_YZC_BD", hidden: true, xtype: 'numberFieldFormat'},
            // {
            //     fieldLabel: "未支出金额",
            //     name: "PAY_XZ_AMT_WZC",
            //     xtype: 'numberFieldFormat',
            //     readOnly: true,
            //     fieldCls: 'form-unedit-number'
            // },
            // {fieldLabel: "支出进度(%)", name: "ZC_PROGRESS", readOnly: true, fieldCls: 'form-unedit'},
            // {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
            {fieldLabel: "单据ID", name: "ZCD_ID", hidden: true},
            {fieldLabel: "单据编号", name: "ZCD_CODE", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '支出年度', name: 'ZCD_YEAR', hidden: true},
            {fieldLabel: "支出日期", name: "APPLY_DATE", hidden: true},
            {fieldLabel: "使用单位", name: "AG_ID", hidden: true},
            {fieldLabel: "使用单位", name: "AG_CODE", hidden: true},
            {fieldLabel: "使用单位", name: "AG_NAME", readOnly: true, fieldCls: 'form-unedit'},
            {
                fieldLabel: "支出总额(元)",
                name: "PAY_AMT_TOTAL",
                xtype: 'numberFieldFormat',
                readOnly: true,
                fieldCls: 'form-unedit-number'
            },
            {fieldLabel: "录入人", name: "ZCD_LR_USER", hidden: true},
            {fieldLabel: "录入人", name: "ZCD_LR_USER_NAME", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '指标文号', name: 'ZBWH',readOnly: !config.editable,fieldCls: !config.editable?'form-unedit': '' },
            {fieldLabel: "备注", name: "ZCD_REMARK", columnWidth: .66, readOnly: !config.editable,fieldCls: !config.editable?'form-unedit': ''},
        ]
    });
    return form;
}

/**
 * 初始化债券支出保存弹出窗口表格
 */
function initWindow_save_zcxx_grid(config) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 250, tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "项目ID", dataIndex: "XM_ID", type: "string", hidden: true},
        {
            text: "预算金额(元)",
            dataIndex: "YS_AMT",
            width: 160,
            hidden: config.is_show == 0,
            type: "float",
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "未拨付金额(元)",
            dataIndex: "WBF_AMT_CS",
            width: 160,
            hidden: config.is_show == 0,
            type: "float",
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "支出日期", dataIndex: "PAY_DATE", type: "string", tdCls: 'grid-cell',
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d',
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
                            store_GNFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                            store_JJFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
                            store_GNFL.load({
                                callback: function () {
                                    store_JJFL.load({
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
            text: "本次支出金额(元)", dataIndex: "PAY_AMT", type: "float", width: 160, tdCls: 'grid-cell',
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        },
        // {
        //     text: "专项债用作资本金(元)", dataIndex: "ZX_ZBJ_AMT", type: "float", width: 180,
        //     renderer:function(value,meta){
        //         var zcForm = Ext.ComponentQuery.query('#window_save_zcxx_form')[0];
        //         var ZQLB_NAME = zcForm.getForm().findField('ZQLB_NAME').getValue();
        //         if(config.is_show==1 && ZQLB_NAME.indexOf('专项')!=-1){
        //             meta.tdCls = 'grid-cell';
        //             meta.column.editor = {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0};
        //         }else {
        //             meta.tdCls = 'grid-cell-unedit';
        //         }
        //         return Ext.util.Format.number(value, '0,000.00##');
        //     }
        // },
        {
            text: "功能分类", dataIndex: "GNFL_ID", type: "string", tdCls: 'grid-cell', width: 200,
            editor: {
                xtype: 'treecombobox',
                valueField: 'id',
                displayField: 'name',
                editable: false, //禁用编辑
                selectModel: 'leaf',
                rootVisible: false,
                lines: false,
                store: store_GNFL,
                minPicekerWidth: 300
            },
            renderer: function (value) {
                var record = store_GNFL.findNode('id', value, true, true, true);
                return record != null ? record.get('name') : "";
            }
        },
        {
            text: "经济分类", dataIndex: "JJFL_ID", type: "string", tdCls: 'grid-cell', width: 200,
            editor: {
                xtype: 'treecombobox',
                valueField: 'id',
                displayField: 'name',
                editable: false, //禁用编辑
                selectModel: 'leaf',
                rootVisible: false,
                lines: false,
                store: store_JJFL,
                minPicekerWidth: 300
            },
            renderer: function (value) {
                var record = store_JJFL.findNode('id', value, true, true, true);
                return record != null ? record.get('name') : "";
            }
        },
        {text: "项目类型", dataIndex: "XMLX_NAME", type: 'string', tdCls: 'grid-cell-unedit', width: 180,hidden: true},
        {
            text: '项目总概算(万元)', dataIndex: 'XMZGS_AMT', type: 'float', tdCls: 'grid-cell-unedit', width: 160,hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.######');
            }
        },
        {text: "业务处室ID", dataIndex: "MB_ID", type: "string", hidden: true}
    ];
    var grid_config = {
        itemId: 'window_save_zcxx_grid',
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
                pluginId: 'window_save_zcxx_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    /*edit: function (editor, context) {
                     if (context.field == 'PAY_AMT') {
                     var PAY_AMT_TOTAL = 0;
                     var grid = DSYGrid.getGrid("window_save_zcxx_grid");
                     var form = grid.up('tabpanel').down('form');
                     PAY_AMT_TOTAL = grid.getStore().sum('PAY_AMT');
                     PAY_XZ_AMT_WZC=
                     form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
                     form.down('[name=PAY_XZ_AMT_WZC]').setValue(PAY_AMT_TOTAL);
                     }
                     },*/
                    validateedit: function (editor, context) {
                        //债券金额验证
                        // if (context.field == 'PAY_AMT') {
                        //     window.flag_validateedit = null;
                        //     var pay_amt = context.value;
                        //     if (context.value <= 0) {
                        //         window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额必须大于01！');
                        //         return false;
                        //     }
                        //     var grid = DSYGrid.getGrid("window_save_zcxx_grid");
                        //     var records = grid.getStore().getData();
                        //     var form = grid.up('tabpanel').down('form');
                        //     var xm_id = context.record.data.XM_ID;
                        //     /*修改表格中支出金额：
                        //      循环表格
                        //      校验：获取支出单总额，未支出金额(可支出总额-初始已支出总额度-本单已支出总额+本单初始支出)>=0
                        //      获取项目本单已支出金额，未拨付金额(预算-初始已支出-本单已支出+本单初始支出)>=0
                        //      支出单：支出单总额修改
                        //      新增债券：未支出额度修改
                        //      XMLSIT：修改对应项目的本单已支出金额、未拨付金额*/
                        //     var PAY_AMT_TOTAL = 0;//支出单总额
                        //     var YZC_AMT_BD = 0;//对应项目的本单支出总额
                        //     for (var i = 0; i < records.length; i++) {
                        //         if (records.items[i].internalId == context.record.internalId) {
                        //             PAY_AMT_TOTAL += context.value;
                        //         } else {
                        //             PAY_AMT_TOTAL += records.items[i].data.PAY_AMT;
                        //         }
                        //         if (config.is_show == 1) {
                        //             if (records.items[i].data.XM_ID == xm_id) {
                        //                 if (records.items[i].internalId == context.record.internalId) {
                        //                     YZC_AMT_BD += context.value;
                        //                 } else {
                        //                     YZC_AMT_BD += records.items[i].data.PAY_AMT;
                        //                 }
                        //             }
                        //         }
                        //     }
                        //     //值*100/100解决小数精度问题
                        //     var PAY_XZ_AMT_WZC = form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() * 100 - form.down('[name=PAY_XZ_AMT_YZC_CS]').getValue() * 100 - PAY_AMT_TOTAL * 100 + form.down('[name=PAY_XZ_AMT_YZC_BDCS]').getValue() * 100;
                        //     PAY_XZ_AMT_WZC = PAY_XZ_AMT_WZC / 100;
                        //     if (PAY_XZ_AMT_WZC < 0 && Math.abs(PAY_XZ_AMT_WZC) > 0.01) {
                        //         window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额超出债券最大可支出金额！');
                        //         return false;
                        //     }
                        //     //如果系统参数为2(只关联项目),不校验
                        //     if (config.is_show == 1) {
                        //         var xm_info = grid.up('window').XM_LIST[xm_id];
                        //         var WBF_AMT = xm_info.YS_AMT - xm_info.YZC_AMT_CS - YZC_AMT_BD + xm_info.YZC_AMT_BDCS;
                        //         if (WBF_AMT < 0) {
                        //             window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额超出项目最大可支出金额！');
                        //             return false;
                        //         }
                        //         xm_info.YZC_AMT_BD = YZC_AMT_BD;
                        //         xm_info.WBF_AMT = WBF_AMT;
                        //         grid.getStore().each(function (record) {
                        //             if (record.data.XM_ID == xm_id) {
                        //                 record.set('WBF_AMT', WBF_AMT);
                        //             }
                        //         });
                        //     }
                        //     //校验通过，修改对应数据
                        //     form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
                        //     form.down('[name=PAY_XZ_AMT_YZC_BD]').setValue(PAY_AMT_TOTAL);
                        //     form.down('[name=PAY_XZ_AMT_WZC]').setValue(PAY_XZ_AMT_WZC);
                        //     var ZC_PROGRESS = (form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() - PAY_XZ_AMT_WZC ) / form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() * 100;
                        //     ZC_PROGRESS = Ext.util.Format.number(ZC_PROGRESS, '0.00');
                        //     form.down('[name=ZC_PROGRESS]').setValue(ZC_PROGRESS);
                        //     return true;
                        // }
                    },
                    edit: function (editor, context) {
                        if (context.field == 'PAY_AMT') {
                            var grid = DSYGrid.getGrid("window_save_zcxx_grid");
                            var self = grid.getStore();
                            var plan_amt_xzyb_sum = 0.00;
                            self.each(function (record) {
                                plan_amt_xzyb_sum += record.get('PAY_AMT');
                            });
                            Ext.ComponentQuery.query('numberFieldFormat[name="PAY_AMT_TOTAL"]')[0].setValue(plan_amt_xzyb_sum);
                        }
                        if (context.field == 'PAY_DATE') {
                            context.record.set(context.field, Ext.util.Format.date(context.value, 'Y-m-d'));
                        }
                    }
                }
            }
        ],
        listeners: {
            selectionchange: function (self, records) {
                Ext.ComponentQuery.query('window#window_save_zcxx')[0].down('button[name=deleteZC]').setDisabled(!records.length);
            }
        }
    };
    if (!config.editable) {
        delete grid_config.plugins;
        delete grid_config.listeners;
    }
    return DSYGrid.createGrid(grid_config);
}

/**
 * 初始化债券填报表单中页签panel的附件页签
 */
function initWindow_save_zcxx_tab_upload(config) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET210',//业务类型
        busiId: config.gridId,//业务ID
        busiProperty: '%',//业务规则
        editable: config.editable,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_save_zcxx_tab_upload_grid'
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
 * 支出信息保存校验
 */
function checkEditorGrid(grid) {
    var mb_id = null;
    for (var i = 0; i < grid.getStore().getCount(); i++) {
        var record = grid.getStore().getAt(i);
        if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null || record.get('PAY_DATE') == '') {
            return '支出日期为空！';
        }
        if (!record.get('PAY_AMT') || record.get('PAY_AMT') == null || record.get('PAY_AMT') <= 0) {
            return '支出金额必须大于0！';
        }
        if (!record.get('GNFL_ID') || record.get('GNFL_ID') == null || record.get('GNFL_ID') == '') {
            return '功能分类为空！';
        }
        if (!record.get('JJFL_ID') || record.get('JJFL_ID') == null || record.get('JJFL_ID') == '') {
            return '经济分类为空！';
        }
        if (typeof(SYS_RIGHT_MODEL) != 'undefined' && SYS_RIGHT_MODEL != null && SYS_RIGHT_MODEL == 1) {
            if (i == 0) {
                mb_id = record.get("MB_ID");
            } else {
                if (mb_id != record.get("MB_ID")) {
                    return '所选数据必须是同一业务处室!';
                }
            }
        }
    }
    return null;
}

/**
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var grid = DSYGrid.getGrid('contentGrid');
    var ZQ_ID = Ext.ComponentQuery.query('combobox[name="ZQ_NAME"]')[0].getValue();
    var store = grid.getStore();
    store.getProxy().extraParams['ZQ_ID'] = ZQ_ID;
    //增加查询参数
    if (AD_CODE == '' || AD_CODE == null) {
        AD_CODE = USER_AD_CODE;
    }
    if (AG_CODE == '' || AG_CODE == null) {
        AG_CODE = USER_AG_CODE;
    }
    store.getProxy().extraParams["AD_CODE"] = AD_CODE;
    store.getProxy().extraParams["AG_CODE"] = AG_CODE;
    if (typeof param != 'undefined' && param != null) {
        for (var name in param) {
            store.getProxy().extraParams[name] = param[name];
        }
    }
    //刷新
    store.loadPage(1);
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("ZCD_ID"));
    }
    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/updateKkdfNode.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids: ids,
                    ZC_TYPE: ZC_TYPE,
                    is_end_cancel: button_name == '撤销审核'
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
        });
    } else {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            value: btn.name == 'up' ? null : '同意',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateKkdfNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids,
                        ZC_TYPE: ZC_TYPE,
                        is_end_cancel: button_name == '撤销审核'
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
        });
    }
    btn.setDisabled(false);
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
 * 初始化支出数据
 */
function initZcxxData_update(config) {
    //发送ajax请求，获取修改数据
    $.post("/getKkdfGridById.action", {
        ZCD_ID: config.ZCD_ID,
        ZC_TYPE: ZC_TYPE
    }, function (data) {
        if (data.success) {
            var is_show = data.is_show;
            /*修改插入数据：
             初始化     债券：可支出总额(已支出总额度+剩余可用额度)，初始已支出金额(已支出总额度)，本单初始支出，新增已支出金额(=本单初始支出)，未支出金额(可支出总额-已支出总额度-新增已支出总额+本单初始支出)
             获取支出单支出总额
             循环表格     XMLIST：预算金额、初始已支出金额 、本单初始支出、新增已支出金额(=本单初始支出 )、未拨付金额(预算-初始已支出-新增已支出+本单初始支出)*/
            var window_zc = initWindow_save_zcxx({
                editable: config.editable,
                gridId: config.ZCD_ID,
                is_show: is_show
            });
            window_zc.show();
            var data_zcd = data.data_zcd;
            var data_zcmx = data.data_zcmx;
            var data_zq = data.data_zq;
            var data_zdmx = $.extend({}, data_zq, data_zcd);
            data_zdmx = initZcxx_data_zdmx(data_zdmx, data_zcd, {
                PAY_XZ_AMT_YZC_BDCS: data_zcd.TOTAL_PAY_AMT
            });
            window_zc.down('form').getForm().setValues(data_zdmx);
            window_zc.XM_LIST = {};
            //循环明细记录，计算对应项目的本单初始支出金额、本单支出金额、未拨付金额
            initZcxx_data_zcmx_UPDATE(data_zcmx, window_zc, is_show);
        } else {
            Ext.MessageBox.alert('提示', '查询修改数据失败！' + data.message);
        }
    }, "json");
}

/**
 * 初始化支出数据
 */
function initZcxxData_confirm(btn, ids, is_show) {
    //选择完发行计划，计算发行计划关联的项目的预算金额、已拨付金额
    //预算金额=关联的项目关联的发行计划申请金额合计，已拨付金额：关联的项目的所有支出的金额合计
    $.post('/getKkdf_XM.action', {ids: ids, ZCD_YEAR: btn.ZCD_YEAR}, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '获取项目相关信息失败！' + data.message);
            return;
        }
        //如果保存window不存在，则show保存window
        var window_zc = Ext.ComponentQuery.query('window#window_save_zcxx')[0];
        var data_zcmx = data.data;
        if (!window_zc) {
            var ZCD_ID = data.ZCD_ID;
            window_zc = initWindow_save_zcxx({
                editable: true,
                gridId: ZCD_ID,
                is_show: is_show
            });
            window_zc.show();
            // var data_zdmx = btn.up('window').data_zdmx;
            // if (data_zdmx) {
                /*
                 债券记录中的金额列
                 PLAN_AMT, --兑付计划金额
                 PLAN_XZ_AMT, --其中新增债券金额
                 PLAN_ZH_AMT, --其中置换债券金额
                 DFF_AMT, --兑付费金额
                 ZD_AMT, --已转贷金额
                 XZ_AMT, --已转贷其中新增金额
                 ZH_AMT, --已转贷其中置换金额
                 PAY_AMT PAY_AMT_DFJH,--支出金额
                 PAY_XZ_AMT,--新增债券支出金额
                 PAY_ZH_AMT,--置换债券支出金额
                 SY_AMT, --剩余可转贷金额
                 SY_XZ_AMT, --剩余可转贷新增金额
                 SY_ZH_AMT, --剩余可转贷置换金额
                 */
                var data_zdmx = {
                    ZCD_ID: ZCD_ID,
                    ZCD_CODE: data.ZCD_CODE,
                    AG_ID: data_zcmx[0].AG_ID,
                    AD_NAME: data_zcmx[0].AD_NAME,
                    AG_CODE: data_zcmx[0].AG_CODE,
                    AG_NAME: data_zcmx[0].AG_NAME,
                    ZCD_LR_USER: USERCODE,
                    ZCD_LR_USER_NAME: USERNAME,
                    APPLY_DATE: nowDate,
                    PAY_AMT_TOTAL: 0
                };
                window_zc.down('form').getForm().setValues(data_zdmx);
            // }
            window_zc.XM_LIST = {};
        }
        //判断是否有AG_ID，如果没有从明细中取出AG_ID（删除所有明细再新增选择明细时走这里）
        var ag_id = window_zc.down('form').down('[name=AG_ID]').getValue();
        if (!ag_id || !(ag_id.trim())) {
            window_zc.down('form').down('[name=AG_ID]').setValue(data_zcmx[0].AG_ID);
            window_zc.down('form').down('[name=AG_CODE]').setValue(data_zcmx[0].AG_CODE);
            window_zc.down('form').down('[name=AG_NAME]').setValue(data_zcmx[0].AG_NAME);
        }
        window_zc.XM_LIST = window_zc.XM_LIST ? window_zc.XM_LIST : {};//存储项目的相关金额：预算金额(项目总金额)、已支出金额、未拨付金额(未支出金额)、
        //循环初始化支出明细数据
        initZcxx_data_zcmx_ADD(data_zcmx, window_zc, is_show);
        btn.up('window').close();
    }, 'json');
}

/**
 * 初始化转贷明细信息
 * @param data_zdmx
 * @param data_zcd
 * @param config
 * @return {*}
 */
function initZcxx_data_zdmx(data_zdmx, data_zcd, config) {
    //可支出总额PAY_XZ_AMT_TOTAL(已支出总额度+剩余可用额度)
    //初始已支出金额PAY_XZ_AMT_YZC_CS(已支出总额度)
    //本单初始支出PAY_XZ_AMT_YZC_BDCS(若是新增：0，若是修改：本单支出总额)
    //本单已支出金额PAY_XZ_AMT_YZC_BD(=本单初始支出，修改支出金额后改变)
    //未支出金额PAY_XZ_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
    data_zdmx.PAY_XZ_AMT_TOTAL = data_zdmx.PAY_XZ_AMT + data_zdmx.SY_XZ_AMT;
    data_zdmx.PAY_XZ_AMT_YZC_CS = data_zdmx.PAY_XZ_AMT;
    data_zdmx.PAY_XZ_AMT_YZC_BDCS = config.PAY_XZ_AMT_YZC_BDCS;//新增：0，修改：支出单支出总额
    data_zdmx.PAY_XZ_AMT_YZC_BD = data_zdmx.PAY_XZ_AMT_YZC_BDCS;
    data_zdmx.PAY_XZ_AMT_WZC = data_zdmx.PAY_XZ_AMT_TOTAL - data_zdmx.PAY_XZ_AMT_YZC_CS - data_zdmx.PAY_XZ_AMT_YZC_BD + data_zdmx.PAY_XZ_AMT_YZC_BDCS;
    data_zdmx.ZC_PROGRESS = (data_zdmx.PAY_XZ_AMT_TOTAL - data_zdmx.PAY_XZ_AMT_WZC) / data_zdmx.PAY_XZ_AMT_TOTAL * 100;
    data_zdmx.ZC_PROGRESS = Ext.util.Format.number(data_zdmx.ZC_PROGRESS, '0.00');
    data_zdmx.ZC_TYPE_NAME = '新增债券支出';
    //data_zdmx.ZQ_NAME = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + data_zdmx.ZQ_ID + '&AD_CODE=' + data_zdmx.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + data_zdmx.ZQ_NAME + '</a>';
    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
    var paramNames = new Array();
    paramNames[0] = "ZQ_ID";
    paramNames[1] = "AD_CODE";
    var paramValues = new Array();
    paramValues[0] = encodeURIComponent(data_zdmx.ZQ_ID);
    paramValues[1] = encodeURIComponent(data_zdmx.AD_CODE.replace(/00$/, ""));
    data_zdmx.ZQ_NAME = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data_zdmx.ZQ_NAME + '</a>';
    //支出单相关信息
    data_zdmx.ZCD_ID = data_zcd.ZCD_ID;
    data_zdmx.ZCD_CODE = data_zcd.ZCD_CODE;
    data_zdmx.AG_ID = data_zcd.AG_ID;
    data_zdmx.AG_CODE = data_zcd.AG_CODE;
    data_zdmx.AG_NAME = data_zcd.AG_NAME;
    data_zdmx.ZCD_LR_USER = data_zcd.ZCD_LR_USER;
    data_zdmx.ZCD_LR_USER_NAME = data_zcd.ZCD_LR_USER_NAME;
    data_zdmx.APPLY_DATE = data_zcd.APPLY_DATE;
    data_zdmx.PAY_AMT_TOTAL = data_zcd.TOTAL_PAY_AMT;
    return data_zdmx;
}

/**
 * 循环初始化支出明细数据：新增
 * @param data_zcmx
 * @param window_zc
 */
function initZcxx_data_zcmx_ADD(data_zcmx, window_zc, is_show) {
    //数据循环初始化
    //循环表格     XMLIST：新增项目：预算金额、初始已支出金额 、本单初始支出(0)、本单已支出金额 (=本单初始支出) 、未拨付金额(预算-初始已支出-本单已支出+本单初始支出)；
    //                     已有项目：修改record未拨付金额为对应的金额；如果项目初始已支出金额变更，重新计算未拨付金额并重置所有相关行
    for (var i = 0; i < data_zcmx.length; i++) {
        data_zcmx[i].PAY_DATE = nowDate;
        if (is_show == 0) {
            continue;
        }
        var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
        if (!xm) {
            //新增项目
            window_zc.XM_LIST[data_zcmx[i].XM_ID] = {};
            xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
            xm.YS_AMT = data_zcmx[i].YS_AMT;
            xm.YZC_AMT_CS = data_zcmx[i].PAY_SUM_AMT;
            xm.YZC_AMT_BDCS = 0;
            xm.YZC_AMT_BD = xm.YZC_AMT_BDCS;
            xm.WBF_AMT = xm.YS_AMT - xm.YZC_AMT_CS - xm.YZC_AMT_BD + xm.YZC_AMT_BDCS;
            data_zcmx[i].WBF_AMT = xm.WBF_AMT;
            xm.WBF_AMT_CS = xm.WBF_AMT;//仅作为显示用
            data_zcmx[i].WBF_AMT_CS = xm.WBF_AMT_CS;//仅作为显示用
            data_zcmx[i].PAY_AMT = data_zcmx[i].BCZC_AMT;// 取值为该笔债券该个项目的发行金额
            data_zcmx[i].ZX_ZBJ_AMT = data_zcmx[i].BCZC_ZX_ZBJ;// 取值为该笔债券该个项目的专项债用作资本金金额
        } else {
            //已有项目
            /*if (data_zcmx[i].PAY_AMT_SUM != xm.YZC_AMT_CS) {
             xm.YZC_AMT_CS = data_zcmx[i].PAY_AMT_SUM;
             xm.WBF_AMT = xm.YS_AMT - xm.YZC_AMT_CS - xm.YZC_AMT_BD + xm.YZC_AMT_BDCS;
             window_zc.down('grid#window_save_zcxx_grid').getStore().each(function (record) {
             if (record.get('XM_ID') == xm.XM_ID) {
             record.set('WBF_AMT', xm.WBF_AMT);
             }
             });
             }*/
            data_zcmx[i].YS_AMT = xm.YS_AMT;
            data_zcmx[i].WBF_AMT = xm.WBF_AMT;
            data_zcmx[i].WBF_AMT_CS = xm.WBF_AMT_CS;//仅作为显示用
        }
    }
    /*    var zc_record = window_zc.down('grid#window_save_zcxx_grid').getStore().getAt(0);
        if(zc_record != null && zc_record != undefined && zc_record != "") {
            var year = zc_record.get("PAY_DATE").substr(0,4);
            var condition_str = year <= 2017 ? " <= '2017' " : " = '"+year+"' ";
            store_GNFL.proxy.extraParams['condition'] = " and year "+ condition_str;
            store_JJFL.proxy.extraParams['condition'] = " and year "+ condition_str;
            store_GNFL.load({
                callback : function() {
                    store_JJFL.load({
                        callback : function() {
                            var fields = window_zc.down('grid#window_save_zcxx_grid').fields;
                            //将数据插入到填报表格中
                            window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
                        }
                    });
                }
            });
        } else {
        }*/
    var fields = window_zc.down('grid#window_save_zcxx_grid').fields;
    //将数据插入到填报表格中
    window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
}

/**
 * 循环初始化支出明细数据：修改
 * @param data_zcmx
 * @param window_zc
 */
function initZcxx_data_zcmx_UPDATE(data_zcmx, window_zc, is_show) {
    if (is_show == 0) {
        //将数据插入到填报表格中
        Ext.MessageBox.wait('正在获取明细支出数据...', '请等待..');
        var year = data_zcmx[0].PAY_DATE.substr(0, 4);
        km_year = year;
        var condition_str = year <= 2017 ? " <= '2017' " : " = '" + year + "' ";
        store_GNFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
        store_JJFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
        store_GNFL.load({
            callback: function () {
                store_JJFL.load({
                    callback: function () {
                        //将数据插入到填报表格中
                        window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
                        Ext.MessageBox.hide();
                    }
                });
            }
        });
        return false;
    }
    //数据循环初始化
    //循环表格     XMLIST：新增项目：预算金额、初始已支出金额 、本单初始支出(0)、本单已支出金额 (=本单初始支出) 、未拨付金额(预算-初始已支出-本单已支出+本单初始支出)；
    //                     已有项目：修改record未拨付金额为对应的金额；如果项目初始已支出金额变更，重新计算未拨付金额并重置所有相关行
    /*for (var i = 0; i < data_zcmx.length; i++) {
     data_zcmx[i].PAY_DATE = nowDate;
     var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
     if (!xm) {
     //新增项目
     window_zc.XM_LIST[data_zcmx[i].XM_ID] = {};
     xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
     xm.YS_AMT = data_zcmx[i].YS_AMT;
     xm.YZC_AMT_CS = data_zcmx[i].PAY_AMT_SUM;
     xm.YZC_AMT_BDCS = 0;
     xm.YZC_AMT_BD = xm.YZC_AMT_BDCS;
     xm.WBF_AMT = xm.YS_AMT - xm.YZC_AMT_CS - xm.YZC_AMT_BD + xm.YZC_AMT_BDCS;
     } else {
     //已有项目
     if (data_zcmx[i].PAY_AMT_SUM != xm.YZC_AMT_CS) {
     xm.YZC_AMT_CS = data_zcmx[i].PAY_AMT_SUM;
     xm.WBF_AMT = xm.YS_AMT - xm.YZC_AMT_CS - xm.YZC_AMT_BD + xm.YZC_AMT_BDCS;
     window_zc.down('grid#window_save_zcxx_grid').getStore().each(function (record) {
     if (record.get('XM_ID') == xm.XM_ID) {
     record.set('WBF_AMT', xm.WBF_AMT);
     }
     });
     }
     }
     data_zcmx[i].WBF_AMT = xm.WBF_AMT;
     }*/
    //循环明细记录，计算对应项目的本单初始支出金额、本单支出金额、未拨付金额
    for (var i = 0; i < data_zcmx.length; i++) {
        var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
        if (!xm) {
            //新增项目
            window_zc.XM_LIST[data_zcmx[i].XM_ID] = {};
            xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
            xm.YS_AMT = data_zcmx[i].YS_AMT;
            xm.YZC_AMT_CS = data_zcmx[i].PAY_SUM_AMT;
            xm.YZC_AMT_BDCS = 0;
        }
        xm.YZC_AMT_BDCS = xm.YZC_AMT_BDCS + data_zcmx[i].PAY_AMT;//累加本单初始
        xm.YZC_AMT_BD = xm.YZC_AMT_BDCS;
        xm.WBF_AMT = xm.YS_AMT - xm.YZC_AMT_CS - xm.YZC_AMT_BD + xm.YZC_AMT_BDCS;
        xm.WBF_AMT_CS = xm.WBF_AMT;//仅作为显示用
    }
    //循环明细记录，未拨付金额
    for (var i = 0; i < data_zcmx.length; i++) {
        var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
        data_zcmx[i].YS_AMT = xm.YS_AMT;
        data_zcmx[i].WBF_AMT = xm.WBF_AMT;
        data_zcmx[i].WBF_AMT_CS = xm.WBF_AMT_CS;//仅作为显示用
    }
    var year = data_zcmx[0].PAY_DATE.substr(0, 4);
    km_year = year;
    var condition_str = year <= 2017 ? " <= '2017' " : " = '" + year + "' ";
    store_GNFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
    store_JJFL.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
    store_GNFL.load({
        callback: function () {
            store_JJFL.load({
                callback: function () {
                    //将数据插入到填报表格中
                    window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
                }
            });
        }
    });
}