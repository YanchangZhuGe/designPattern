var gclb_store= DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc');//20210331_zhuanrx_湖北十大工程工程类别专用
Ext.define('ZQModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id', mapping: 'ZQ_ID'},
        {name: 'name', mapping: 'ZQ_NAME'}
    ]
});
var json_debt_ztlc = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "004", code: "004", name: "被退回"},
    {id: "008", code: "008", name: "曾经办"}
];
var wf_id = getQueryParam("wf_id");//当前流程id
var node_code = getQueryParam("node_code");//当前节点id
var node_type = getQueryParam("node_type");//当前节点标识
var ZC_TYPE = getQueryParam("ZC_TYPE");//支出类型：0新增债券类型 1置换债券类型
var BF_LEVEL=0;
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
                    text: '查询.0',
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        if(typeof window_GD_zfls != 'undefined'){
                            window_GD_zfls.show("接受流水数据");
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: sysHasZbwj == '1'? '支出到单位': "新增",
                    name: 'btn_insert',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        //store_JJFL = DebtEleTreeStoreDB('EXPECO');
                        button_name = btn.text;
                        button_status = btn.name;
                        BF_LEVEL = 0;
                        var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                        AD_CODE = treeArray[0].getSelection()[0].get('code');
                        AD_NAME = treeArray[0].getSelection()[0].get('text');
                        if (treeArray[1].getSelection()[0] != undefined) {
                            AG_CODE = treeArray[1].getSelection()[0].get('code');
                            AG_ID = treeArray[1].getSelection()[0].get('id');
                            AG_NAME = treeArray[1].getSelection()[0].get('text');
                        }
                        //弹出债券选择框
                        initWindow_select_zdmx(btn).show();
                    }
                },
                {
                    xtype: 'button',
                    text: '支出到部门',
                    name: 'btn_bm',
                    icon: '/image/sysbutton/add.png',
                    hidden: sysHasZbwj != '1',
                    handler: function (btn) {
                        //store_JJFL = DebtEleTreeStoreDB('EXPECO');
                        button_name = btn.text;
                        button_status = btn.name;
                        BF_LEVEL = 1;
                        var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                        AD_CODE = treeArray[0].getSelection()[0].get('code');
                        AD_NAME = treeArray[0].getSelection()[0].get('text');
                        if (treeArray[1].getSelection()[0] != undefined) {
                            AG_CODE = treeArray[1].getSelection()[0].get('code');
                            AG_ID = treeArray[1].getSelection()[0].get('id');
                            AG_NAME = treeArray[1].getSelection()[0].get('text');
                        }
                        //弹出债券选择框
                        initWindow_select_zdmx(btn).show();
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
                        BF_LEVEL = records[0].get("BF_LEVEL");
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
                                $.post("/deleteFxdfZqsyZqzcGrid.action", {
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
                        BF_LEVEL = records[0].get("BF_LEVEL");
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
                                $.post("/deleteFxdfZqsyZqzcGrid.action", {
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
                   // hidden:node_code=='3',
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
            /*'004': [
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
                    // hidden:node_code=='3',
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
        var nodeType = data[0].NODE_TYPE;
        var json_zt = json_debt_sh;
        initContent();
        //根据节点名称修改状态下拉框store
        var combobox_status = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]');
        if (typeof combobox_status != 'undefined' && combobox_status != null && combobox_status.length > 0 && json_zt != null) {
            combobox_status[0].setStore(DebtEleStore(json_zt));
        }
    },"json");
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
                        CHILD: node_code!='3'?1:0//区划树参数，1只显示本级，其它显示全部，默认显示全部
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
        {text: "支出单ID", dataIndex: "ZCD_ID", type: "string", hidden: true},
        {text: "支出单编码", dataIndex: "ZCD_CODE", type: "string", width: 200},
        {text: "支出类型", dataIndex: "ZC_TYPE", type: "string", hidden: true},
        {text: "关联债券ID", dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_NAME", type: "string"},
        {text: "所属单位", dataIndex: "AG_ID", type: "string", hidden: true},
        {text: "所属单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
        {text: "所属单位", dataIndex: "AG_NAME", type: "string", width: 300},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 400,
            renderer: function (data, cell, record) {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = AD_CODE.replace(/00$/, "");
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "支出总额(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", width: 160},
        {text:"专项债用作资本金总额(元)", dataIndex:"TOTAL_ZX_ZBJ_AMT",type:"float",width:200},
        {text:"其中:新增赤字(元)", dataIndex:"TOTAL_XZCZAP_AMT",type:"float",width:200},
        {text: "录入人", dataIndex: "ZCD_LR_USER_NAME", type: "string", width: 200},
        {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string", hidden: true},
        {text: "文件文号", dataIndex: "WJ_NO", type: "string", width: 200, hidden: true},
        {text: "签发人", dataIndex: "QFR_NAME", type: "string", width: 160, hidden: true},
        {text: '签发日期',dataIndex: "QF_DATE", type: "string", width: 200, hidden: true},
        {text: "备注", dataIndex: "ZCD_REMARK", type: "string", width: 200},
        {text: "BF_LEVEL", dataIndex: "BF_LEVEL", type: "string",hidden: true}
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
            BF_LEVEL: BF_LEVEL,
            SJLY: 0
        },
        dataUrl: '/getFxdfZqzcMainGrid.action',
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
                xtype: "treecombobox",
                name: "ZQLB_ID",
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                displayField: "name",
                valueField: "id",
                fieldLabel: '债券类型',
                editable: false, //禁用编辑
                labelWidth: 60,
                width: 200,
                labelAlign: 'left',
                listeners: {
                    change: function (self, newValue) {
                        if (!!self.up('window')) {
                            self.up('grid').getStore().getProxy().extraParams[self.getName()]=newValue;
                            reloadGrid();
                        }
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
                width: 400,
                labelWidth: 60,
                labelAlign: 'left'
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
 * 初始化债券：转贷明细选择弹出窗口
 */
function initWindow_select_zdmx(b_btn) {
    return Ext.create('Ext.window.Window', {
        title: '转贷债券选择', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_zdmx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_select_zdmx_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                    //记录选择的数据
                    var data_zdmx = records[0].getData();
                    data_zdmx.ZCD_YEAR = data_zdmx.DF_START_DATE.substr(0, 4);
                    //弹出新增债券填报页面
                    var window_zhmx = initWindow_select_xzzq({
                        ZCD_YEAR: data_zdmx.ZCD_YEAR, ZQ_ID: data_zdmx.ZQ_ID, BUTTON_NAME: b_btn.name
                    });
                    window_zhmx.show();
                    //向下一window传递选择的转贷债券数据
                    window_zhmx.data_zdmx = data_zdmx;
                    btn.up('window').close();
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
 * 初始化债券：转贷明细选择弹出框表格
 */
function initWindow_select_zdmx_grid() {
    var headerJson = [
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 400,
            renderer: function (data, cell, record) {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "可拨付金额合计", dataIndex: "SY_AMT", width: 150, type: "float", hidden: true},
        {text: "可拨付金额(元)", dataIndex: "SY_XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "可拨付金额(元)", dataIndex: "SY_ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "合计", dataIndex: "PLAN_AMT", width: 150, type: "float", hidden: true},
        {text: "债券总额(元)", dataIndex: "PLAN_XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "债券总额(元)", dataIndex: "PLAN_ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "合计", dataIndex: "ZD_AMT", width: 150, type: "float", hidden: true},
        {text: "已转贷金额(元)", dataIndex: "XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "已转贷金额(元)", dataIndex: "ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "合计", dataIndex: "PAY_AMT_DFJH", width: 150, type: "float", hidden: true},
        {text: "已拨付金额(元)", dataIndex: "PAY_XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "已拨付金额(元)", dataIndex: "PAY_ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 200},
        {text: "债券简称", dataIndex: "ZQ_JC", width: 200, type: "string"},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 200},
        {text: "兑付起始日", dataIndex: "DF_START_DATE", type: "string", width: 100},
        {text: "债券类别", dataIndex: "ZQLB_ID", type: "string", hidden: true, width: 200},
        {text: "是否存在批次计划", dataIndex: "XZ_CONN_PCJH", type: "string", hidden: true, width: 200}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'window_select_zdmx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        height: '100%',
        flex: 1,
        params: {
            ZC_TYPE: ZC_TYPE,
            BF_LEVEL: BF_LEVEL,
            FX_YEAR: nowDate.substr(0, 4)
        },
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/getFxdfZqsyZdmxGrid.action',
        tbar: [
            {
                fieldLabel: '债券发行年度',
                xtype: "combobox",
                name: "FX_YEAR",
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                displayField: "name",
                valueField: "id",
                value: nowDate.substr(0, 4),
                editable: false, // 禁用编辑
                labelWidth: 80,
                width: 250,
                listeners: {
                    change: function (self, newValue) {
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['FX_YEAR'] = newValue;
                        store.loadPage(1);
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '债券类型',
                displayField: 'name',
                valueField: 'id',
                name: 'BOND_TYPE_ID',
                store: DebtEleTreeStoreDB('DEBT_ZQLB',{condition: " AND CODE <> '020204'"}),//20201203 排除中小银行新增专项债券
                editable: false,
                width: 320,
                labelWidth: 70,
                labelAlign: 'right',
                listeners: {
                    'change': function (self, e) {
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['BOND_TYPE_ID'] = self.getValue();
                        store.loadPage(1);

                    }
                }
            },
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                name: 'contentGrid_search',
                itemId: 'contentGrid_search',
                width: 320,
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入债券名称/债券编码...',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['contentGrid_search'] = self.getValue();
                            store.loadPage(1);
                        }
                    }
                }
            },
            '->',
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    store.getProxy().extraParams['contentGrid_search'] = btn.up('grid').down('[name=contentGrid_search]').getValue();
                    store.getProxy().extraParams['BOND_TYPE_ID'] = btn.up('grid').down('[name=BOND_TYPE_ID]').getValue();
                    store.getProxy().extraParams['FX_YEAR'] = btn.up('grid').down('[name=FX_YEAR]').getValue();
                    // 刷新表格
                    store.load();
                }
            }
        ]
    });
    return grid;
}

/**
 * 初始化新增债券发行计划选择弹出窗口
 */
function initWindow_select_xzzq(param) {
    return Ext.create('Ext.window.Window', {
        title: '新增债券项目选择', // 窗口标题
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
                ZCD_YEAR: param.ZCD_YEAR,
                ZQ_ID: param.ZQ_ID,
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
                    var kkdfids = [];
                    var is_show = records[0].data.IS_SHOW;
                    for (var i in records) {
                        ids[i] = records[i].data.XM_ID;
                        kkdfids [i]  = records[i].data.KKDF_ID;
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
                    initZcxxData_confirm(btn, ids, is_show, param.BUTTON_NAME, kkdfids);
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
        {text: "单位名称", dataIndex: "AG_NAME", type: "string", width: 300},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 400,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                paramValues[1]=AD_CODE.replace(/00$/, "");
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "立项年度", dataIndex: "LX_YEAR", type: "string"},
        {text: "项目类型", dataIndex: "XMLX_NAME", type: "string", width: 200},
        {text: "开工日期", dataIndex: "START_DATE_PLAN", type: "string"},
        {text: "竣工日期", dataIndex: "END_DATE_PLAN", type: "string"},
        {text: "建设状态", dataIndex: "JSZT_NAME", type: "string"},
        {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 220},
        {
            dataIndex: "YS_AMT", width: 150, type: "float", text: "预算金额（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SYKBF_AMT", width: 200, type: "float", text: "剩余可拨付金额（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {text: "备注", dataIndex: "REMARK", type: "string", width: 220},
        {text: "是否严格控制财政拨付金额", dataIndex: "IS_SHOW", type: "string", hidden: true}

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
            enablePage: false
        },
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: (param && param.ag_id) ? param.ag_id : AG_ID,
            ZCD_YEAR: (param && param.ZCD_YEAR) ? param.ZCD_YEAR : nowDate.substring(0, 4),
            ZQ_ID: (param && param.ZQ_ID) ? param.ZQ_ID : '',
            is_kkdf: 0
        },
        dataUrl: '/getFxdfZqsyXzzqGrid.action'
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
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: 'contentGrid_search',
            labelAlign: 'right',
            enableKeyEvents: true,
            emptyText: '请输入项目编码/项目名称...',
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
        },
        {
            xtype: 'radiogroup',
            itemId: 'is_kkdfs',
            items: [
                {boxLabel: '非库款垫付', name: 'is_kkdf', inputValue: '0', checked: true, width: 85},
                {boxLabel: '仅库款垫付', name: 'is_kkdf', inputValue: '1', width: 85}
            ],
            listeners: {
                change: function (self, newValue, oldValue) {
                    var form = self.up('form');
                    if (form.isValid()) {
                        callBackReload(form);
                    } else {
                        Ext.Msg.alert("提示", "查询区域未通过验证！");
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
        var is_kkdf = Ext.ComponentQuery.query('radiogroup#is_kkdfs')[0].getValue().is_kkdf;

        var grid = DSYGrid.getGrid('window_select_xzzq_grid');
        grid.getStore().getProxy().extraParams['XMLX_SEARCH'] = xmlx;
        grid.getStore().getProxy().extraParams['mhcx'] = mhcx;
        grid.getStore().getProxy().extraParams['is_kkdf'] = is_kkdf;
        grid.getStore().load();
    }

    return search_form;
}


/**
 * 初始化债券支出保存弹出窗口
 */
function initWindow_save_zcxx(config) {
    var window_config = {
        title: '债券支出', // 窗口标题
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
                    var ZQ_ID = btn.up('window').down('form').down('[name=ZQ_ID]').getValue();
                    initWindow_select_xzzq({ag_id: ag_id, ZCD_YEAR: ZCD_YEAR, ZQ_ID: ZQ_ID}).show();

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
                    if (!isNull(store)) {
                        for (var i = 0; i < store.data.items.length ; i++) {
                            if (store.getAt(i).data.WBF_AMT_CS < 0) {
                                Ext.MessageBox.alert('提示', '已无未拨付金额，不可继续支出！');
                                return;
                            }
                        }
                    }

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
                    //根据锁定期间校验支出时间,天津个性定制需求
                    if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
                        var dateArr = [];
                        var form = btn.up('window').down('form');
                        var AG_CODE = form.down('textfield[name="AG_CODE"]').getValue();
                        var AD_CODE = form.down('textfield[name="AD_CODE"]').getValue();
                        grid.getStore().each(function(record){
                            var param = {};
                            param.AD_CODE = AD_CODE;
                            param.AG_CODE = AG_CODE;
                            param.ZC_DATE = record.data.PAY_DATE;
                            dateArr.push(param);
                        });
                        for (var i=0;i<dateArr.length;i++)
                        {
                            if(!peCheck(dateArr[i])){
                                return false;
                            }
                        }
                    }
                    btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                    //发送ajax请求，保存表格数据
                    $.post('/saveFxdfZqsyZqzcGrid.action', {
                        wf_id: wf_id,
                        node_code: node_code,
                        WF_STATUS: WF_STATUS,
                        node_type: node_type,
                        button_name: button_name,
                        button_status: button_status,
                        ZC_TYPE: ZC_TYPE,
                        BF_LEVEL: BF_LEVEL,
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
            {fieldLabel: '债券', name: 'ZQ_ID', hidden: true},
            {fieldLabel: '债券名称', name: 'ZQ_NAME', xtype: 'displayfield', columnWidth: .66, readOnly: true},
            {fieldLabel: '支出类型', name: 'ZC_TYPE_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券类型', name: 'ZQLB_ID', hidden: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '期限', name: 'ZQQX_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {
                fieldLabel: "新增债券金额",
                name: "PAY_XZ_AMT_TOTAL",
                xtype: 'numberFieldFormat',
                readOnly: true,
                fieldCls: 'form-unedit-number'
            },
            {fieldLabel: "初始已拨付金额", name: "PAY_XZ_AMT_YZC_CS", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "本单初始拨付金额", name: "PAY_XZ_AMT_YZC_BDCS", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "本单已拨付金额", name: "PAY_XZ_AMT_YZC_BD", hidden: true, xtype: 'numberFieldFormat'},
            {
                fieldLabel: "未拨付金额",
                name: "PAY_XZ_AMT_WZC",
                xtype: 'numberFieldFormat',
                readOnly: true,
                fieldCls: 'form-unedit-number'
            },
            {fieldLabel: "支出进度(%)", name: "ZC_PROGRESS", readOnly: true, fieldCls: 'form-unedit'},
            {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
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
            {fieldLabel: "备注", name: "ZCD_REMARK", columnWidth: .66, readOnly: !config.editable},
        ]
    });
    return form;
}


/**
 * 初始化债券支出保存弹出窗口表格
 */
function initWindow_save_zcxx_grid(config) {
    var headerJson = [
        {text: "库款垫付", dataIndex: "KKDF_ID", type: "string", hidden: true},
        {text: "项目ID", dataIndex: "XM_ID", type: "string", hidden: true},
        {fieldLabel: "BF_LEVEL", name: "BF_LEVEL", readOnly: true, hidden :true, fieldCls: 'form-unedit'}, // 0:拨付至单位；1：拨付至部门
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 300, tdCls: 'grid-cell-unedit',
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
            text: "ZBWJXD_ID", dataIndex: "ZBWJXD_ID", type: "string", width: 200, tdCls: 'grid-cell', allowblank: true, hidden:true
        },
        {
            text: "指标文号", dataIndex: "ZBWJ_CODE", type: "string", width: 200, tdCls: 'grid-cell', allowblank: true, hidden: sysHasZbwj != '1',
        },
        {
            text: '指标文件下达额度(元)', dataIndex: 'ZBWJXD_AMT', type: 'float', tdCls: 'grid-cell-unedit', width: 200, hidden: sysHasZbwj != '1',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: '剩余可下达金额(元)', dataIndex: 'SYYZC_AMT', type: 'float', tdCls: 'grid-cell-unedit', width: 160, hidden: sysHasZbwj != '1',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text:  "财政预算金额(元)",
            dataIndex: "YS_AMT",
            width: 160,
            type: "float",
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "财政未拨付金额(元)",
            dataIndex: "WBF_AMT_CS",
            width: 160,
            type: "float",
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "支出日期", dataIndex: "PAY_DATE", type: "string", tdCls: 'grid-cell',
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d',
                maxValue: nowDate ,//日期截止到今天
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
            text: "财政拨付金额(元)", dataIndex: "BCZC_AMT", type: "float", width: 160, tdCls: 'grid-cell', //PAY_AMT
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        },
        {
            text: "专项债用作资本金(元)", dataIndex: "ZX_ZBJ_AMT", type: "float", width: 180,
            renderer:function(value,meta){
                var zcForm = Ext.ComponentQuery.query('#window_save_zcxx_form')[0];
                var ZQLB_NAME = zcForm.getForm().findField('ZQLB_NAME').getValue();
                var ZQLB_ID = zcForm.getForm().findField('ZQLB_ID').getValue();
                if(config.is_show==1 && ZQLB_ID!='01'){
                    meta.tdCls = 'grid-cell';
                    meta.column.editor = {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0};
                }else {
                    meta.tdCls = 'grid-cell-unedit';
                }
                return Ext.util.Format.number(value, '0,000.00##');
            }
        },
        {
            text: "其中:新增赤字(元)", dataIndex: "XZCZAP_AMT", type: "float", width: 180,
            renderer:function(value,meta){
                var zcForm = Ext.ComponentQuery.query('#window_save_zcxx_form')[0];
                var ZQLB_NAME = zcForm.getForm().findField('ZQLB_NAME').getValue();
                var ZQLB_ID = zcForm.getForm().findField('ZQLB_ID').getValue();
                if(config.is_show==1 && ZQLB_ID=='01'){
                    meta.tdCls = 'grid-cell';
                    meta.column.editor = {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0};
                }else {
                    meta.tdCls = 'grid-cell-unedit';
                }
                return Ext.util.Format.number(value, '0,000.00##');
            }
        },
        {
            text: "功能分类", dataIndex: "GNFL_ID", type: "string", tdCls: 'grid-cell', width: 250,
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
            text: "经济分类", dataIndex: "JJFL_ID", type: "string", tdCls: 'grid-cell', width: 250,
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
        {
            text: "工程类别", dataIndex: "GCLB_ID", type: "string",width: 250, tdCls: 'grid-cell',
            hidden: sysAdcode=='42'?false:true, allowblank:sysAdcode=='42'?false:true,
            editor: {
                xtype: 'treecombobox',
                displayField: 'text',
                valueField: 'id',
                editable:false,
                store: gclb_store,
                rootVisible: false,
                lines: false,
                allowblank: sysAdcode=='42'?false:true,
                selectModel: 'leaf'//20210331_zhuanrx_湖北十大工程工程类别专用

            },
            renderer: function (value) {
                var record = gclb_store.findNode('id', value, true, true, true);
                return record != null ? record.get('text') : "";
            }
        },
        {text: "项目类型", dataIndex: "XMLX_NAME", type: 'string', tdCls: 'grid-cell-unedit', width: 200},
        {
            text: '项目总概算(元)', dataIndex: 'XMZGS_AMT', type: 'float', tdCls: 'grid-cell-unedit', width: 160,
            renderer: function (value) {
                return Ext.util.Format.number(value ,'0,000.######');
            }
        },
        {text: "文件文号", dataIndex: "WJ_NO", type: 'string',tdCls: 'grid-cell',width: 180,
            editor: {xtype:"textfield"},hidden: true
        },
        {text: "签发人", dataIndex: "QFR_NAME", type: 'string',tdCls: 'grid-cell',width: 180,
            editor: {xtype:"textfield"},hidden: true
        },
        {
            text: "签发日期", dataIndex: "QF_DATE", type: "string", tdCls: 'grid-cell',
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d'
            },hidden: true
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
        checkBox: false,
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
                    edit: function (editor, context) {
                            //发送ajax请求，查询主表和明细表数据
                            $.post("/checkZqZcxx.action", {
                                ZQ_ID:  Ext.ComponentQuery.query('#window_save_zcxx_form')[0].getForm().findField('ZQ_ID').getValue(),
                            }, function (data) {
                                if (data.success) {
                                    if (context.field == 'BCZC_AMT' ) {
                                        var WBF_AMT_CS = context.record.get("WBF_AMT_CS");
                                        if(parseFloat(WBF_AMT_CS).toFixed(2) -parseFloat(context.value).toFixed(2)<0) {
                                            Ext.MessageBox.alert('提示', '财政拨付金额不能大于未拨付金额!');
                                            context.record.set(context.field, 0.00);
                                        }
                                    }
                                }
                            }, "json");
                        if (context.field == 'PAY_DATE' || context.field == 'QF_DATE') {
                            context.record.set(context.field, Ext.util.Format.date(context.value, 'Y-m-d'));
                        }
                    }
                }
            }
        ],
        listeners: {
            cellclick: function (a,b,c,d,e,f,g,h,i,j ) {
                if(c==5){
                    initWindow_zbw(f).show();
                }
            },
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

function openZbwWin(XM_ID, rowIndex) {
    window_zbw_info.show(XM_ID, rowIndex);
    // loadZbwInfo(XM_ID,rowIndex);
}

//创建债券信息填报弹出窗口
var window_zbw_info = {
    window: null,
    show: function (XM_ID, rowIndex) {
        this.window = initWindow_zbw(XM_ID, rowIndex);
        this.window.show();
    }
};

/**
 * 初始化债券信息填报弹出窗口
 */
function initWindow_zbw(rowIndex) {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_fzr', // 窗口标识
        name: 'window_fzr',
        title: "", // 窗口标题
        width: document.body.clientWidth * 0.5, //自适应窗口宽度
        height: document.body.clientHeight * 0.5, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_zbw_contentForm(rowIndex),
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    // 回填数据
                    {
                        var zbw_contentGrid = DSYGrid.getGrid('zbw_contentGrid').getCurrentRecord();
                        var window_save_zcxx_grid = DSYGrid.getGrid('window_save_zcxx_grid').getStore();
                        if (!!zbw_contentGrid && !!window_save_zcxx_grid) {
                            var ZBWJXD_ID = zbw_contentGrid.get("ZBWJXD_ID");
                            var ZBWJ_CODE = zbw_contentGrid.get("ZBWJ_CODE");
                            var ZBWJXD_AMT = zbw_contentGrid.get("ZBWJXD_AMT");
                            var SYYZC_AMT = zbw_contentGrid.get("SYYZC_AMT");
                            var rowData = window_save_zcxx_grid.getAt(rowIndex);
                            if (!!rowData) {
                                rowData.set("ZBWJXD_ID", ZBWJXD_ID);
                                rowData.set("ZBWJ_CODE", ZBWJ_CODE);
                                rowData.set("ZBWJXD_AMT", ZBWJXD_AMT);
                                rowData.set("SYYZC_AMT", SYYZC_AMT);
                                btn.up('window').close();
                            } else {
                                msg.alert("指标文号数据错误!");
                                btn.up('window').close();
                            }
                        }
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
    });
}

/**
 * 初始化报表单
 */
function initWindow_zbw_contentForm(rowIndex) {
    //项目ID
    var zcxxStore = DSYGrid.getGrid('window_save_zcxx_grid').getStore();
    var record = zcxxStore.getAt(rowIndex);
    var xmId = record.get('XM_ID');
    //支出单ID
    var zcxxForm = Ext.ComponentQuery.query('form#window_save_zcxx_form')[0];
    var zcdId = zcxxForm.getForm().findField('ZCD_ID').getValue();
    //债券ID
    var zqId = zcxxForm.getForm().findField('ZQ_ID').getValue();
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            dataIndex: "ZBWJXD_ID",
            width: 150,
            type: "string",
            text: "唯一ZBWJXD_ID",
            hidden: true
        },
        {
            dataIndex: "ZBWJ_CODE",
            width: 150,
            type: "string",
            text: "指标文号"
        },
        {
            dataIndex: "ZBWJXD_DATE",
            width: 150,
            type: "string",
            text: "指标文下达日期"
        },
        {
            text: '指标文件下达额度（元）', dataIndex: 'ZBWJXD_AMT', type: 'float', width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: '已拨付金额（元）', dataIndex: 'YZC_AMT', type: 'float', width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: '剩余可支出额度（元）', dataIndex: 'SYYZC_AMT', type: 'float', width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        }
    ];

    var config = {
        itemId: 'zbw_contentGrid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: false,
        selModel: {
            mode: "SINGLE" // 设置为单选
        },
        border: false,
        autoLoad: true,
        height: '100%',
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/getIsZBWJById.action',
        params: {
            ZQ_ID: zqId,
            XM_ID: xmId,
            ZCD_ID: zcdId
        },
        listeners: {
            itemdblclick: function (self, record) {

            }
        }
    };
    var contentGrid = DSYGrid.createGrid(config);
    //计算已支出和剩余可支出
    //已支出 = 指标文支出的全部金额（不算本支出单的支出金额）+ 本支出单的支出金额（不算选中数据支出金额）
    //剩余可支出 = 支出金额 - 已支出金额
    contentGrid.getStore().on('load', function (self, records, successful) {
        if (records) {
            for (var i = 0; i < records.length; i++) {
                var zbwjxdId = records[i].get("ZBWJXD_ID");
                var yzcAmt = records[i].get('YZC_AMT');
                zcxxStore.each(function (record, index) {
                    if (zbwjxdId == record.get("ZBWJXD_ID") && index != rowIndex) {
                        yzcAmt = accAddPro(yzcAmt, record.get("BCZC_AMT"));
                    }
                });
                records[i].set('YZC_AMT', yzcAmt);
                records[i].set('SYYZC_AMT', accSubPro(records[i].get('ZBWJXD_AMT'), yzcAmt));
                //如果剩余可支出金额为0，则从表格中移除
                if (records[i].get('SYYZC_AMT') <= 0) {
                    contentGrid.getStore().remove(records[i]);
                }
            }
        }
    });
    return contentGrid;
}

// 回填数据
function loadZbwInfo(XM_ID, rowIndex) {
    var zbwForm = Ext.ComponentQuery.query('form[name="zbwForm"]')[0];
    // 加载表单
    zbwForm.load({
        url: '/getIsZBWJById.action',
        params: {
            XM_ID: XM_ID,
        },
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            zbwForm.getForm().setValues(action.result.data.fzrForm);
        },
        failure: function (form, action) {
            // alert('加载失败');
            // Ext.ComponentQuery.query('window[name="window_fzr"]')[0].close();
        }
    });

}
/**
 * 初始化债券填报表单中页签panel的附件页签
 */
function initWindow_save_zcxx_tab_upload(config) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET205',//业务类型
        busiId: config.gridId,//业务ID
        busiProperty: 'C01',//业务规则
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
    //var tzjhNd = new Map();
    for (var i = 0; i < grid.getStore().getCount(); i++) {
        var record = grid.getStore().getAt(i);
        if (sysHasZbwj == '1') {
            if (!record.get('ZBWJ_CODE') || record.get('ZBWJ_CODE') == null || record.get('ZBWJ_CODE') == '') {
                return '指标文号为空！';
            }
            if (!record.get('BCZC_AMT') || record.get('BCZC_AMT') == null || record.get('BCZC_AMT') <= 0) {
                return '财政拨付金额必须大于0！';
            }
            if (!record.get('BCZC_AMT') ||  record.get('BCZC_AMT') > record.get('SYYZC_AMT') ) {
                return '财政拨付金额不能大于剩余可下达金额！';
            }

            if (!record.get('SYYZC_AMT') || record.get('SYYZC_AMT') <= 0  ) {
                return '剩余可拨付金额必须大于0！';
            }
            if (record.get('ZBWJXD_AMT') < record.get('PAY_XZ_AMT_TOTAL')) {
                return '指标文下达额度不能大于新增债券金额！';
            }
        }
       /* if (parseFloat(record.get('BCZC_AMT')).toFixed(2) - parseFloat(record.get('WBF_AMT_CS')).toFixed(2)>0) {
            return '财政拨付金额不能大于未拨付金额！';
        }*/
        //发送ajax请求，查询是否存在数据
        $.post("/checkZqZcxx.action", {
            ZQ_ID:  Ext.ComponentQuery.query('#window_save_zcxx_form')[0].getForm().findField('ZQ_ID').getValue(),
        }, function (data) {
            if (data.success) {
                 if (parseFloat(record.get('BCZC_AMT')).toFixed(2) - parseFloat(record.get('WBF_AMT_CS')).toFixed(2)>0) {
               return '财政拨付金额不能大于未拨付金额！';
           }
            }
        }, "json");
        if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null || record.get('PAY_DATE') == '') {
            return '支出日期为空！';
        }
        if (record.get('BCZC_AMT') < record.get('ZX_ZBJ_AMT')) {
            return '专项债用作资本金不能大于财政拨付金额！';
        }
        if (record.get('BCZC_AMT') < record.get('XZCZAP_AMT')) {
            return '其中:新增赤字金额不能大于财政拨付金额！';
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
    var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].getValue();
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
    store.getProxy().extraParams["ZQLB_ID"] = ZQLB_ID;
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
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    var ids = [];
    var idsArray = [];
    for (var i in records) {
        var m = {};
        m.ZCD_ID = records[i].get("ZCD_ID");
        m.BF_LEVEL = records[i].get("BF_LEVEL");
        idsArray.push(m);

        ids.push(records[i].get("ZCD_ID"));

    }
    //根据锁定期间校验支出时间,天津个性定制需求
    if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
        if(btn.name =='down' || (node_code > 1 && btn.name == 'cancel') ) {
            var dateArr = [];
            records.forEach(function (record) {
                var param = {};
                param.AD_CODE = record.data.AD_CODE;
                param.AG_CODE = record.data.AG_CODE;
                param.ZCD_ID = record.data.ZCD_ID;
                dateArr.push(param);
            });
            for (var i = 0; i < dateArr.length; i++) {
                if (!peCheck(dateArr[i])) {
                    return false;
                }
            }
        }
    }
    btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/updateFxdfZqsyZqzcNode.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    idsArray: encode64(Ext.util.JSON.encode(idsArray)),
                    ids: ids,
                    ZC_TYPE: ZC_TYPE,
                    BF_LEVEL:BF_LEVEL,
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
                    $.post("/updateFxdfZqsyZqzcNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        idsArray: encode64(Ext.util.JSON.encode(idsArray)),
                        ids: ids,
                        ZC_TYPE: ZC_TYPE,
                        BF_LEVEL:BF_LEVEL,
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
 * 新增债券工作流变更
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    var ids = [];
    var idsArray = [];
    for (var i in records) {
        var m = {};
        m.ZCD_ID = records[i].get("ZCD_ID");
        m.BF_LEVEL = records[i].get("BF_LEVEL");
        idsArray.push(m);

        ids.push(records[i].get("ZCD_ID"));

    }
    //根据锁定期间校验支出时间,天津个性定制需求
    if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
        if(btn.name =='down' || (node_code > 1 && btn.name == 'cancel') ) {
            var dateArr = [];
            records.forEach(function (record) {
                var param = {};
                param.AD_CODE = record.data.AD_CODE;
                param.AG_CODE = record.data.AG_CODE;
                param.ZCD_ID = record.data.ZCD_ID;
                dateArr.push(param);
            });
            for (var i = 0; i < dateArr.length; i++) {
                if (!peCheck(dateArr[i])) {
                    return false;
                }
            }
        }
    }
    btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/updateFxdfZqsyZqzcNodes.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    idsArray: encode64(Ext.util.JSON.encode(idsArray)),
                    ids: ids,
                    ZC_TYPE: ZC_TYPE,
                    BF_LEVEL:BF_LEVEL,
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
                    $.post("/updateFxdfZqsyZqzcNodes.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        idsArray: encode64(Ext.util.JSON.encode(idsArray)),
                        ids: ids,
                        ZC_TYPE: ZC_TYPE,
                        BF_LEVEL:BF_LEVEL,
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
    $.post("/getFxdfZqsyZqzcGridById.action", {
        ZCD_ID: config.ZCD_ID,
        ZC_TYPE: ZC_TYPE
    }, function (data) {
        if (data.success) {
            var zq_id=data.data_zq.ZQ_ID;
            var xm_id=data.data_zcmx[0].XM_ID;

            gclb_store=DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc',{condition: " and xm_id = '"+xm_id+"' AND ZQ_ID = '"+zq_id+"' "});
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
            data_zdmx = initZcxx_data_zdmx(data_zdmx, data_zcd);
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
function initZcxxData_confirm(btn, ids, is_show, buttonName, kkdfids) {
    var is_kkdf = Ext.ComponentQuery.query('radiogroup#is_kkdfs')[0].getValue().is_kkdf;

    Ext.getCmp('downSelectBtn').disable();
    //选择完发行计划，计算发行计划关联的项目的预算金额、已拨付金额
    //预算金额=关联的项目关联的发行计划申请金额合计，已拨付金额：关联的项目的所有支出的金额合计
    $.ajaxSettings.async = false;
    $.post('/getFxdfZqsyXzzqGrid_select.action', {
        ids: ids,
        ZCD_YEAR: btn.ZCD_YEAR,
        ZQ_ID: btn.ZQ_ID,
        BUTTON_NAME: buttonName,
        is_kkdf: is_kkdf,
        kkdfids: kkdfids
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '获取项目相关信息失败！' + data.message);
            Ext.getCmp('downSelectBtn').enable();
            return;
        }
        var  xm_id=data.data[0].XM_ID;
        var  ZQ_ID=data.data[0].ZQ_ID;
        gclb_store=DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc',{condition: " and xm_id = '"+xm_id+"' AND ZQ_ID = '"+ZQ_ID+"' "});

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
            var data_zdmx = btn.up('window').data_zdmx;
            if (data_zdmx) {
                data_zdmx = initZcxx_data_zdmx(data_zdmx, {
                    ZCD_ID: ZCD_ID,
                    ZCD_CODE: data.ZCD_CODE,
                    AG_ID: data_zcmx[0].AG_ID,
                    AG_CODE: data_zcmx[0].AG_CODE,
                    AG_NAME: data_zcmx[0].AG_NAME,
                    ZCD_LR_USER: USERCODE,
                    ZCD_LR_USER_NAME: USERNAME,
                    APPLY_DATE: nowDate,
                    PAY_AMT_TOTAL: 0
                });
                window_zc.down('form').getForm().setValues(data_zdmx);
            }
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
    $.ajaxSettings.async = true;
}

/**
 * 初始化转贷明细信息
 * @param data_zdmx
 * @param data_zcd
 * @param config
 * @return {*}
 */
function initZcxx_data_zdmx(data_zdmx, data_zcd) {
    data_zdmx.PAY_XZ_AMT_TOTAL = data_zdmx.PAY_XZ_AMT + data_zdmx.SY_XZ_AMT; //可支出总额PAY_XZ_AMT_TOTAL(已支出总额度+剩余可用额度)
    data_zdmx.PAY_XZ_AMT_YZC_CS = data_zdmx.PAY_XZ_AMT; //初始已支出金额PAY_XZ_AMT_YZC_CS(已支出总额度)
    data_zdmx.PAY_XZ_AMT_WZC = data_zdmx.PAY_XZ_AMT_TOTAL - data_zdmx.PAY_XZ_AMT_YZC_CS;     //未支出金额PAY_XZ_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
    data_zdmx.ZC_PROGRESS = (data_zdmx.PAY_XZ_AMT_TOTAL - data_zdmx.PAY_XZ_AMT_WZC) / data_zdmx.PAY_XZ_AMT_TOTAL * 100;
    data_zdmx.ZC_PROGRESS = Ext.util.Format.number(data_zdmx.ZC_PROGRESS, '0.00');
    data_zdmx.ZC_TYPE_NAME = '新增债券支出';
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
    var success = false;
    for (var i = 0; i < data_zcmx.length; i++) {
        data_zcmx[i].PAY_DATE = nowDate;
        if (is_show == 0) {
            continue;
        }
        // var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
        if (!XMhave(i)) {
            //新增项目
            window_zc.XM_LIST[data_zcmx[i].XM_ID] = {};
            // xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
            data_zcmx[i].BF_LEVEL = BF_LEVEL;// 取值为该笔债券该个项目的专项债用作资本金金额
        } else {
            Ext.MessageBox.alert('提示', '当前选择的项目中存在已进入债券支出单中，请重新选择！');
            success = true;
            return;
        }
    }
    //将数据插入到填报表格中
    if (!success) {
        window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
    }
}

function XMhave(i) {
    var have = false;
    var selgrid = DSYGrid.getGrid('window_select_xzzq_grid');
    var havegrid = DSYGrid.getGrid('window_save_zcxx_grid');
    if (selgrid == null || selgrid == undefined || havegrid == null || havegrid == undefined) {
        return true;
    }
    var sel = selgrid.getSelection();
    for (var j = 0; j < havegrid.getStore().getCount(); j++) {
        // 不能选择相同项目
        if (sel[i].data["XM_ID"] == havegrid.getStore().getAt(j).data["XM_ID"] ) {
            return true;
        }
    }
    return have;
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

    //循环明细记录，计算对应项目的本单初始支出金额、本单支出金额、未拨付金额
    for (var i = 0; i < data_zcmx.length; i++) {
        var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
        if (!xm) {
            //新增项目
            window_zc.XM_LIST[data_zcmx[i].XM_ID] = {};
            xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
        }
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