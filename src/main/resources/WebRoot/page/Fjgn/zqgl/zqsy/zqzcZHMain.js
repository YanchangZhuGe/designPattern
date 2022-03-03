/**
 * Created by Lenovo on 2017/3/24.
 */
Ext.define('ZQModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',mapping:'ZQ_ID'},
        {name: 'name',mapping:'ZQ_NAME'}
    ]
});
var wf_id = getQueryParam("wf_id");//当前流程id
var node_code = getQueryParam("node_code");//当前节点id
var node_type = getQueryParam("node_type");//当前节点标识
var ZC_TYPE = getQueryParam("ZC_TYPE");//支出类型：0新增债券类型 1置换债券类型
ZC_TYPE = 1;
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮的name，标识按钮状态
var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}
//全局变量
var FXPC_ID = '';
var zqNameStore=getZqNameStore();

/**
 * 获取系统参数:
 * 选择债券后，根据系统参数判断是否需要按照发行计划控制，
 * 如果控制，则查询所选债券的发行批次对应是否有发行计划，如果有，则后面的选择债务对话框中的债务应该是该批次发行计划中包含的发行计划明细+库款垫付；
 * 如果不控制或没有发行计划，则可选非首轮项目申报中已经由省级审批通过的所有发行计划+库款垫付
 */
var DEBT_CONN_ZQXM = 1;//默认控制
$.post("getParamValueAll.action", function (data) {
    DEBT_CONN_ZQXM = parseInt(data[0].DEBT_CONN_ZQXM_ZH);
},"json");
/**
 * 获取债券名称
 */
function getZqNameStore(){
    var zqNameDataStore = Ext.create('Ext.data.Store', {
        model: 'ZQModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getZqNameData.action",
            reader: {
                type: 'json'
            },
            extraParams:{
                ZC_TYPE:ZC_TYPE
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
    zclr: {//发行兑付-债券使用-置换债券支出录入
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
                        //弹出债券选择框
                        initWindow_select_zdmx().show();
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
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            btn.setDisabled(false);
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        initZcxxData_update({
                            editable: true,
                            ZCD_ID: records[0].get('ZCD_ID'),
                            ZC_TYPES: records[0].get("ZC_TYPE")
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
                            return false;
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
                                    WF_STATUS: WF_STATUS,
                                    AD_CODE:AD_CODE
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
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            btn.setDisabled(false);
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        initZcxxData_update({
                            editable: true,
                            ZCD_ID: records[0].get('ZCD_ID'),
                            ZC_TYPES: records[0].get("ZC_TYPE")
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
                            return false;
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
                    name: 'search'
                    ,
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
    zcsh: {//发行兑付-债券使用-置换债券支出审核
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
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
            // 20210713 guoyf 审核岗去除被退回、曾经办、状态
            /*'008': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search'
                    ,
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
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
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
        // 20210713 guoyf 审核岗去除被退回、曾经办、状态
        //根据节点名称初始化状态下拉框store
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
        {text: "支出单编码", dataIndex: "ZCD_CODE", type: "string", width: 200},
        {text: "支出类型", dataIndex: "ZC_TYPE", type: "string", hidden: false},
        {text: "关联债券ID", dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_NAME", type: "string"},
        {text: "所属单位", dataIndex: "AG_ID", type: "string", hidden: true},
        {text: "所属单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
        {text: "所属单位", dataIndex: "AG_NAME", type: "string", width: 200},
        {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 200,
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
            }},
        /*{text: "支出总额(人民币)(元)", dataIndex: "TOTAL_PAY_ORI_AMT_RMB", type: "float", width: 190},*/
        {text: "支出总额(人民币)(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", width: 190},
        {text: "录入人", dataIndex: "ZCD_LR_USER_NAME", type: "string", width: 200},
        {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string",hidden: true},
        {text: "备注", dataIndex: "ZCD_REMARK", type: "string"}
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
                fieldLabel: '债券名称',
                name: 'ZQ_NAME',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: zqNameStore,
                width: 250,
                labelWidth: 60,
                labelAlign: 'left'
            }
        ],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                initZcxxData_update({
                    editable: false,
                    ZCD_ID: record.get("ZCD_ID"),
                    ZC_TYPES: record.get("ZC_TYPE")
                })
            }
        }
    });
}
/**
 * 初始化债券：转贷明细选择弹出窗口
 */
function initWindow_select_zdmx() {
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
                    //如果系统参数控制关联，并且转贷债券对应的发行批次下有新增债券发行计划，获取发行批次ID，
                    //否则发行批次置空，即查询所有已完成流程的新增债券发行计划
                    if (DEBT_CONN_ZQXM == 1 && parseInt(data_zdmx['ZH_CONN_PCJH']) >= 1) {
                        FXPC_ID = data_zdmx['ZQ_PC_ID'];
                    } else {
                        FXPC_ID = '';
                    }
                    data_zdmx.ZCD_YEAR = data_zdmx.DF_START_DATE.substr(0, 4);
                    data_zdmx.ZQLB_ID = data_zdmx.ZQLB_ID.substr(0,2);
                    //弹出新增债券填报页面
                    var window_zhmx = initWindow_select_zhmx({ZCD_YEAR: data_zdmx.ZCD_YEAR,ZQLB_ID:data_zdmx.ZQLB_ID,DATATYPE:data_zdmx.DATATYPE});
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
        {xtype: 'rownumberer', width: 45},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "可支出金额合计", dataIndex: "SY_AMT", width: 150, type: "float", hidden: true},
        {text: "可支出金额(元)", dataIndex: "SY_XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "可支出金额(元)", dataIndex: "SY_ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "合计", dataIndex: "PLAN_AMT", width: 150, type: "float", hidden: true},
        {text: "债券总额(元)", dataIndex: "PLAN_XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "债券总额(元)", dataIndex: "PLAN_ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "合计", dataIndex: "ZD_AMT", width: 150, type: "float", hidden: true},
        {text: "已转贷金额(元)", dataIndex: "XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "已转贷金额(元)", dataIndex: "ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "合计", dataIndex: "PAY_AMT_DFJH", width: 150, type: "float", hidden: true},
        {text: "已支出金额(元)", dataIndex: "PAY_XZ_AMT", width: 150, type: "float", hidden: !(ZC_TYPE == 0)},
        {text: "已支出金额(元)", dataIndex: "PAY_ZH_AMT", width: 150, type: "float", hidden: (ZC_TYPE == 0)},
        {text: "债券类型编码", dataIndex: "ZQLB_ID", type: "string", width: 130,hidden: true},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 130},
        {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string"},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 200},
        {text: "兑付起始日", dataIndex: "DF_START_DATE", type: "string", width: 100},
        {text: "债券类别", dataIndex: "ZQLB_ID", type: "string", hidden: true, width: 200},
        {text: "当前数据类型",dataIndex:"DATATYPE",type:"string",width:100,hidden:true},
        {text: "是否存在批次计划", dataIndex: "ZH_CONN_PCJH", type: "string", hidden: true, width: 200}
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
            ZC_TYPE: ZC_TYPE
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
                editable: false, //禁用编辑
                labelWidth: 100,
                width: 250,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['FX_YEAR'] = newValue;
                        // 刷新表格
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
                            // 刷新表格
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
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出窗口
 */
function initWindow_select_zhmx(param) {
    return Ext.create('Ext.window.Window', {
        title: '置换债券债务约定还本选择', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_select_zhmx', // 窗口标识
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [
            initWindow_select_zhmx_grid(param)
        ],
        buttons: [
            {
                text: '确认',
                ZCD_YEAR: param.ZCD_YEAR,
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请至少选择一条数据后再进行操作');
                        return;
                    }
                    //校验所有插入的发行计划都是同一单位
                    var DATATYPE=param.DATATYPE;
                    var ag_id = null;
                    var ids = [];
                    for (var i in records) {
                    	if (DEBT_CONN_ZQXM == 2) {
                            ids[i] = records[i].data.HKJH_ID;
                        }else {
                    	    if(param.DATATYPE=='1'){
                                ids[i] = records[i].data.HKJH_ID;
                            }else{
                                ids[i] = records[i].data.ZHMX_ID;
                            }
                        }
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
                    var iskkdf = btn.up('window').down('#is_kkdfs').getValue().is_kkdf;
                    iskkdf = (iskkdf && iskkdf == '1');//将iskkdf转换为true/false
                    if (!iskkdf) {
                        var hkjhIdInfo = [];
                        for (var i = 0; i < records.length; i++) {
                            var record_data = records[i].getData();
                            hkjhIdInfo.push(record_data['HKJH_ID']);
                        }
                        //判断所选的还款计划是否存在库款垫付
                        //是：提示是否优先置换库款垫付
                        $.post('/checkKKDFByHkjh.action', {
                            hkjhIdInfo: hkjhIdInfo
                        }, function (data) {
                            if (data.success) {
                                Ext.Msg.confirm('确认', data.message + '？', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        select_zhmx(btn, ids, iskkdf, records,DATATYPE);
                                    }
                                });
                            } else {
                                select_zhmx(btn, ids, iskkdf, records,DATATYPE);
                            }
                        }, "json");
                    } else {
                        select_zhmx(btn, ids, iskkdf, records,DATATYPE);
                    }
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
 * 置换债券债务约定还本(债务还款计划)选择
 */
function select_zhmx(btn, ids, iskkdf, records,DATATYPE) {
    $.post('/getFxdfZqsyZhzqGrid_select.action', {ids: ids, ZCD_YEAR: btn.ZCD_YEAR, is_kkdf: iskkdf,FXPC_ID: FXPC_ID,DATATYPE:DATATYPE}, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '获取债务相关信息失败！' + data.message);
            return;
        }
        //如果保存window不存在，则show保存window
        var window_zc = Ext.ComponentQuery.query('window#window_save_zcxx')[0];
        //如果是库款垫付,支出明细直接就是选择的记录，非库款垫付则需要查询
        var data_zcmx = data.data;
        if (iskkdf) {
            data_zcmx = [];
            for (var i in records) {
                data_zcmx[i] = records[i].data;
            }
        }
        if (!window_zc) {
            var ZCD_ID = data.ZCD_ID;
            window_zc = initWindow_save_zcxx({
                editable: true,
                gridId: ZCD_ID
            });
            window_zc.show();
            var data_zdmx = btn.up('window').data_zdmx;
            if (data_zdmx) {
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
                //可支出总额PAY_ZH_AMT_TOTAL(已支出总额度+剩余可用额度)
                //初始已支出金额PAY_ZH_AMT_YZC_CS(已支出总额度)
                //本单初始支出PAY_ZH_AMT_YZC_BDCS(若是新增：0，若是修改：本单支出总额)
                //本单已支出金额PAY_ZH_AMT_YZC_BD(=本单初始支出，修改支出金额后改变)
                //未支出金额PAY_ZH_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
                data_zdmx.PAY_ZH_AMT_TOTAL = data_zdmx.PAY_ZH_AMT + data_zdmx.SY_ZH_AMT;
                data_zdmx.PAY_ZH_AMT_YZC_CS = data_zdmx.PAY_ZH_AMT;
                data_zdmx.PAY_ZH_AMT_YZC_BDCS = 0;
                data_zdmx.PAY_ZH_AMT_YZC_BD = data_zdmx.PAY_ZH_AMT_YZC_BDCS;
                data_zdmx.PAY_ZH_AMT_WZC = accAdd(accSub(accSub(data_zdmx.PAY_ZH_AMT_TOTAL,data_zdmx.PAY_ZH_AMT_YZC_CS),data_zdmx.PAY_ZH_AMT_YZC_BD),data_zdmx.PAY_ZH_AMT_YZC_BDCS);
                //data_zdmx.PAY_ZH_AMT_WZC = (data_zdmx.PAY_ZH_AMT_TOTAL*100 - data_zdmx.PAY_ZH_AMT_YZC_CS*100 - data_zdmx.PAY_ZH_AMT_YZC_BD*100 + data_zdmx.PAY_ZH_AMT_YZC_BDCS*100)/100;
                data_zdmx.ZC_PROGRESS = accMul(accDiv(accSub(data_zdmx.PAY_ZH_AMT_TOTAL,data_zdmx.PAY_ZH_AMT_WZC),data_zdmx.PAY_ZH_AMT_TOTAL),100);

                //data_zdmx.ZC_PROGRESS = (data_zdmx.PAY_ZH_AMT_TOTAL - data_zdmx.PAY_ZH_AMT_WZC) / data_zdmx.PAY_ZH_AMT_TOTAL * 100;
                data_zdmx.ZC_PROGRESS = Ext.util.Format.number(data_zdmx.ZC_PROGRESS, '0.00');
                data_zdmx.ZC_TYPE_NAME = '置换债券支出';
               // data_zdmx.ZQ_NAME = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + data_zdmx.ZQ_ID + '&AD_CODE=' + data_zdmx.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + data_zdmx.ZQ_NAME + '</a>'
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(data_zdmx.ZQ_ID);
                paramValues[1]=encodeURIComponent(data_zdmx.AD_CODE.replace(/00$/, ""));
                data_zdmx.ZQ_NAME='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+ data_zdmx.ZQ_NAME+'</a>';
                //支出单相关信息
                data_zdmx.ZCD_ID = ZCD_ID;
                data_zdmx.ZCD_CODE = data.ZCD_CODE;
                data_zdmx.AG_ID = data_zcmx[0].AG_ID;
                data_zdmx.AG_CODE = data_zcmx[0].AG_CODE;
                data_zdmx.AG_NAME = data_zcmx[0].AG_NAME;
                data_zdmx.ZCD_LR_USER = USERCODE;
                data_zdmx.ZCD_LR_USER_NAME = USERNAME;
                data_zdmx.APPLY_DATE = nowDate;
                data_zdmx.PAY_AMT_TOTAL = 0;
                window_zc.down('form').getForm().setValues(data_zdmx);
            }
            window_zc.HKJH_LIST = {};
        }
        //判断是否有AG_ID，如果没有从明细中取出AG_ID（删除所有明细再新增选择明细时走这里）
        var ag_id = window_zc.down('form').down('[name=AG_ID]').getValue();
        if (!ag_id || !(ag_id.trim())) {
            window_zc.down('form').down('[name=AG_ID]').setValue(data_zcmx[0].AG_ID);
            window_zc.down('form').down('[name=AG_CODE]').setValue(data_zcmx[0].AG_CODE);
            window_zc.down('form').down('[name=AG_NAME]').setValue(data_zcmx[0].AG_NAME);
        }
        window_zc.HKJH_LIST = window_zc.HKJH_LIST ? window_zc.HKJH_LIST : {};//存储项目的相关金额：预算金额(项目总金额)、已支出金额、未拨付金额(未支出金额)、
        //数据循环初始化
        //循环表格     hkjhLIST：新增项目：预算金额、初始已支出金额 、本单初始支出(0)、本单已支出金额 (=本单初始支出) 、未拨付金额(预算-初始已支出-本单已支出+本单初始支出)；
        //                     已有项目：修改record未拨付金额为对应的金额；如果项目初始已支出金额变更，重新计算未拨付金额并重置所有相关行
        for (var i = 0; i < data_zcmx.length; i++) {
            data_zcmx[i].HL_RATE = parseFloat(data_zcmx[i].ROE_NOW);
            data_zcmx[i].PAY_ORI_AMT = 0;
            data_zcmx[i].PAY_AMT = data_zcmx[i].HL_RATE * data_zcmx[i].PAY_ORI_AMT;
            data_zcmx[i].PAY_DATE = nowDate;
            data_zcmx[i].CHJH_ID = data_zcmx[i].HKJH_ID;
            //如果是库款垫付，支出金额为到期金额，并且不计入还款计划list统计
            if (data_zcmx[i].IS_KKDF == '1') {
                data_zcmx[i].PAY_ORI_AMT = data_zcmx[i].DUE_AMT - data_zcmx[i].PAY_AMT_YZC;
                data_zcmx[i].PAY_AMT = data_zcmx[i].PAY_ORI_AMT * data_zcmx[i].ROE_NOW;
                //continue;
            }
            var hkjh = window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID];
            if (!hkjh) {
                //新增还款计划
                window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID] = {};
                hkjh = window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID];
                //如果系统参数为2，不比较，直接取到期金额-在途已支出金额
                //可支出金额(到期金额-在途已支出金额 )与(发行计划申请金额-计划已支出金额) 中小的
                if (DEBT_CONN_ZQXM == 2) {
                    //不关联计划时取原币
                    hkjh.KZC_AMT = accSub(data_zcmx[i].DUE_AMT,data_zcmx[i].PAY_AMT_YZC);
                    //hkjh.KZC_AMT = (data_zcmx[i].DUE_AMT_RMB * 10000 - data_zcmx[i].PAY_AMT_YZC_RMB * 10000) / 10000;
                } else {
                    if ((data_zcmx[i].DUE_AMT_RMB - data_zcmx[i].PAY_AMT_YZC_RMB) < (data_zcmx[i].APPLY_AMOUNT - data_zcmx[i].PAY_AMT_SUM)) {
                        hkjh.KZC_AMT= accSub(data_zcmx[i].DUE_AMT_RMB,data_zcmx[i].PAY_AMT_YZC_RMB);
                        //hkjh.KZC_AMT = (data_zcmx[i].DUE_AMT_RMB * 10000 - data_zcmx[i].PAY_AMT_YZC_RMB * 10000) / 10000;
                    } else {
                        hkjh.KZC_AMT = accSub(data_zcmx[i].APPLY_AMOUNT,data_zcmx[i].PAY_AMT_SUM);
                        //hkjh.KZC_AMT = (data_zcmx[i].APPLY_AMOUNT * 10000 - data_zcmx[i].PAY_AMT_SUM * 10000) / 10000;
                    }
                }
                hkjh.YZC_AMT_BDCS = 0;
                hkjh.YZC_AMT_BD = hkjh.YZC_AMT_BDCS;
                hkjh.WBF_AMT = accAdd(accSub(hkjh.KZC_AMT,hkjh.YZC_AMT_BD),hkjh.YZC_AMT_BDCS);
                //var testWBF_AMT = (hkjh.KZC_AMT*100 - hkjh.YZC_AMT_BD*100 + hkjh.YZC_AMT_BDCS*100)/100;
                data_zcmx[i].WBF_AMT = hkjh.WBF_AMT;
            } else {
                //已有项目
                //TODO 如果项目初始已支出金额变更，重新计算未拨付金额并重置所有相关行
                /*if (data_zcmx[i].PAY_AMT_SUM != hkjh.YZC_AMT_CS) {
                 hkjh.YZC_AMT_CS = data_zcmx[i].PAY_AMT_SUM;
                 hkjh.WBF_AMT = hkjh.KZC_AMT - hkjh.YZC_AMT_CS - hkjh.YZC_AMT_BD + hkjh.YZC_AMT_BDCS;
                 window_zc.down('grid#window_save_zcxx_grid').getStore().each(function (record) {
                 if (record.get('HKJH_ID') == hkjh.HKJH_ID) {
                 record.set('WBF_AMT', hkjh.WBF_AMT);
                 }
                 });
                 }*/
                data_zcmx[i].WBF_AMT = hkjh.WBF_AMT;
            }
        }
        var list_zcmx = {};
        if(DEBT_CONN_ZQXM == 2) {
        	for (var j = 0; j < window_zc.down('grid#window_save_zcxx_grid').getStore().getCount(); j++) {
        		var record = window_zc.down('grid#window_save_zcxx_grid').getStore().getAt(j);
        		list_zcmx[record.get('HKJH_ID')] = true;
        	}
        	//循环插入数据，如果已存在该兑付计划，不录入
        	for (var i = 0; i < data_zcmx.length; i++) {
        		var obj = data_zcmx[i];
        		if (list_zcmx[obj.HKJH_ID]) {
        			continue;
        		}//将数据插入到填报表格中
        		window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx[i]);
        	}
        }else {

            if(DATATYPE!=null&&DATATYPE!=undefined&&DATATYPE=='1'){
                for (var j = 0; j < window_zc.down('grid#window_save_zcxx_grid').getStore().getCount(); j++) {
                    var record = window_zc.down('grid#window_save_zcxx_grid').getStore().getAt(j);
                    list_zcmx[record.get('HKJH_ID')] = true;
                }
                //循环插入数据，如果已存在该兑付计划，不录入
                for (var i = 0; i < data_zcmx.length; i++) {
                    var obj = data_zcmx[i];
                    if (list_zcmx[obj.HKJH_ID]) {
                        continue;
                    }//将数据插入到填报表格中
                    window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx[i]);
                }
            }else{
                for (var j = 0; j < window_zc.down('grid#window_save_zcxx_grid').getStore().getCount(); j++) {
                    var record = window_zc.down('grid#window_save_zcxx_grid').getStore().getAt(j);
                    list_zcmx[record.get('ZHMX_ID')] = true;
                }
                //循环插入数据，如果已存在该兑付计划，不录入
                for (var i = 0; i < data_zcmx.length; i++) {
                    var obj = data_zcmx[i];
                    if (list_zcmx[obj.ZHMX_ID]) {
                        continue;
                    }//将数据插入到填报表格中
                    window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx[i]);
                }
            }
        }
        
        //重新计算支出单总支出金额与债券相关金额
        var form = window_zc.down('form');
        var PAY_AMT_TOTAL = window_zc.down('grid#window_save_zcxx_grid').getStore().sum('PAY_AMT');
        var PAY_ZH_AMT_WZC = form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() - form.down('[name=PAY_ZH_AMT_YZC_CS]').getValue() - PAY_AMT_TOTAL + form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue();
        if (PAY_ZH_AMT_WZC < 0 && Math.abs(PAY_ZH_AMT_WZC) > 0.01) {
            Ext.MessageBox.alert('提示', '置换金额超出债券最大可支出金额！');
            return false;
        }
        form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
        form.down('[name=PAY_ZH_AMT_YZC_BD]').setValue(PAY_AMT_TOTAL);
        form.down('[name=PAY_ZH_AMT_WZC]').setValue(PAY_ZH_AMT_WZC);
        var ZC_PROGRESS = accMul(accDiv(accSub(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue(),PAY_ZH_AMT_WZC),form.down('[name=PAY_ZH_AMT_TOTAL]').getValue()),100);
        //var ZC_PROGRESS = (form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() - PAY_ZH_AMT_WZC ) / form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() * 100;
        ZC_PROGRESS = Ext.util.Format.number(ZC_PROGRESS, '0.00');
        form.down('[name=ZC_PROGRESS]').setValue(ZC_PROGRESS);
        btn.up('window').close();
    }, 'json');
}
/**
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出框表格
 */
function initWindow_select_zhmx_grid(param) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            text: "区划", dataIndex: "AD_NAME", type: "string", width: 150/*,
            renderer: function (value, metaData, record) {
                if (value < dsyDateFormat(new Date()))
                    metaData.css = 'x-grid-back-green';
                return value;
            }*/
        },
        {text: "单位", dataIndex: "AG_NAME", type: "string", width: 250},
        {text: "计划偿还日期", dataIndex: "HKJH_DATE", type: "string", width: 120},
        {text: "还款计划ID", dataIndex: "HKJH_ID", type: "string", hidden: true},
        {text: "到期金额(原币)(元)", dataIndex: "DUE_AMT", type: "float", width: 160},//非库款垫付：到期金额为还款计划金额-偿还本金
        {text: "到期金额(人民币)(元)", dataIndex: "DUE_AMT_RMB", type: "float", width: 160, hidden: true},//非库款垫付：到期金额为还款计划金额-偿还本金
        {text: "偿还本金金额(原币)(元)", dataIndex: "CHBJ_AMT", type: "float", width: 200, hidden: true},
        {text: "偿还本金金额(人民币)(元)", dataIndex: "CHBJ_AMT_RMB", type: "float", width: 200, hidden: true},
        {text: "在途已支出金额(原币)(元)", dataIndex: "PAY_AMT_YZC", type: "float", width: 200},
        {text: "在途已支出金额(人民币)(元)", dataIndex: "PAY_AMT_YZC_RMB", type: "float", width: 200, hidden: true},
        {text: "发行计划申请金额(人民币)(元)", dataIndex: "APPLY_AMOUNT", type: "float", width: 220},
        {text: "利率", dataIndex: "LX_RATE", type: "float"},
        {
            text: "债务名称", dataIndex: "ZW_NAME", type: "string", width: 250,
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
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 250,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "签订日期", dataIndex: "SIGN_DATE", type: "string"},
        {text: "债务编码", dataIndex: "ZW_CODE", type: "string", width: 200},
        {text: "协议号", dataIndex: "ZW_XY_NO", type: "string", width: 200},
        {text: "项目ID", dataIndex: "XM_ID", type: "string", hidden: true, width: 150},
        {text: "债务ID", dataIndex: "ZW_ID", type: "string", width: 100, hidden: true},
        {text: "协议金额(人民币)", dataIndex: "XY_AMT_RMB", type: "float", width: 180},
        {text: "协议金额(原币)", dataIndex: "XY_AMT", type: "float", width: 150},
        {text: "已偿还本金(原币)(元)", dataIndex: "CHBJ_AMT", type: "float", width: 210},
        {text: "债务余额(元)", dataIndex: "ZW_YE", type: "float", width: 160},
        {text: "币种", dataIndex: "CUR_NAME", type: "string"},
        {text: "汇率", dataIndex: "HL_RATE", type: "float"},
        {text: "债权类型", dataIndex: "ZQFL_NAME", type: "string", width: 150},
        {text: "债权人", dataIndex: "ZQR_NAME", type: "string", width: 150},
        {text: "债权人全称", dataIndex: "ZQR_FULLNAME", type: "string", width: 200},
        {text: "债务类别", dataIndex: "ZWLB_ID", type: "string", hidden: true, width: 200},
        {text: "资金用途", dataIndex: "ZJYT_NAME", type: "string", width: 200},
        {text: "项目分类", dataIndex: "XMLX_NAME", type: "string", width: 200},
        {text:"DATATYPE",dataIndex:"DATATYPE",type:"string",width:200,hidden:true}
    ];
    var search_form = initWindow_xzzq_grid_searchTool(param);
    if(AG_ID=='root'){
        AG_ID='';
    }
    return DSYGrid.createGrid({
        itemId: 'window_select_zhmx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: true,
        height: '100%',
        flex: 1,
        dockedItems: [search_form],
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: (param && param.ag_id) ? param.ag_id : AG_ID,
            ZCD_YEAR: (param && param.ZCD_YEAR) ? param.ZCD_YEAR : nowDate.substring(0, 4),
            FXPC_ID: FXPC_ID,
            DATATYPE:param.DATATYPE,
            is_kkdf: 0,
            ZWLB_CODE:'01'+param.ZQLB_ID
        },
        dataUrl: '/getFxdfZqsyHkjhGrid.action'
    });
}
/**
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出框搜索区域
 */
function initWindow_xzzq_grid_searchTool(param) {
    //初始化查询控件
    var items = [
        {
            xtype: "combobox",
            name: "HKJH_YEAR",
            store: DebtEleStore(json_debt_year),
            displayField: "name",
            valueField: "id",
            fieldLabel: '到期年月',
            editable: false, //禁用编辑
            labelWidth: 60,
            width: 180
        },
        {
            xtype: "combobox",
            name: "HKJH_MO",
            store: DebtEleStore(json_debt_yf),
            displayField: "name",
            valueField: "id",
            //value: lpad(1 + new Date().getUTCMonth(), 2),
            editable: false, //禁用编辑
            width: 85
        },
        {
            xtype: 'radiogroup',
            itemId: 'is_kkdfs',
            defaults: {
                margin: '2 0 2 0'
            },
           // disabled:param.DATATYPE=='1'?true:false,
            items: [
                {boxLabel: '非库款垫付', name: 'is_kkdf', inputValue: '0', checked: true, width: 85},
                {boxLabel: '仅库款垫付', name: 'is_kkdf', inputValue: '1', width: 85}
            ],
            listeners: {
                change: function (self, newValue, oldValue) {
                    if (newValue.is_kkdf && newValue.is_kkdf == '1') {
                        self.up('window').down('combobox[name="HKJH_YEAR"]').disable();
                        self.up('window').down('combobox[name="HKJH_MO"]').disable();
                    } else {
                        self.up('window').down('combobox[name="HKJH_YEAR"]').enable();
                        self.up('window').down('combobox[name="HKJH_MO"]').enable();
                    }
                    var form = self.up('form');
                    if (form.isValid()) {
                        callBackReload(form);
                    } else {
                        Ext.Msg.alert("提示", "查询区域未通过验证！");
                    }
                }
            }
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'contentGrid_search',
            itemId: 'contentGrid_search',
            //width: 220,
            columnWidth:.64,
            labelWidth: 60,
            labelAlign: 'right',
            enableKeyEvents: true,
            emptyText: '请输入债务名称/项目名称/债权人全称/债务编码/协议号...',
            listeners: {
                keypress: function (self, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var form = self.up('form');
                        if (form.isValid()) {
                            callBackReload(form);
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
                    }
                }
            }
        }];
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('window_select_zhmx_grid_searchTool');
    var search_form = searchTool.create({
        items: items,
        border: true,
        xtype: 'toolbar',
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        defaults: {
            labelWidth: 0,
            labelAlign: 'right',
            margin: '5 5 5 5',
            width: 250
        },
        // 查询按钮回调函数
        callback: function (self) {
            callBackReload(self);
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
            align: 'middle',
            pack: 'end'
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
                        callBackReload(form);
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
    function callBackReload(self) {
        var formValue = self.getValues();
        if (self.down('combobox[name="HKJH_YEAR"]').isDisabled()) {
            formValue.HKJH_YEAR = '';
            formValue.HKJH_MO = '';
        }
        var store = self.up('grid').getStore();
        // 清空参数中已有的查询项
        for (var search_form_i in formValue) {
            delete store.getProxy().extraParams[search_form_i];
        }
        // 向grid中追加参数
        $.extend(true, store.getProxy().extraParams, formValue);
        // 刷新表格
        store.loadPage(1);
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
                    var ZQLB_ID = btn.up('window').down('form').down('[name=ZQLB_ID]').getValue();
                    var data_type=btn.up('window').down('form').down('[name=DATATYPE]').getValue();
                    initWindow_select_zhmx({ag_id: ag_id, ZCD_YEAR: ZCD_YEAR,ZQLB_ID:ZQLB_ID,DATATYPE:data_type}).show();
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
                    var form = btn.up('window').down('form');
                    var DATATYPE=form.getForm().findField("DATATYPE").getValue();
                    if (!form.isValid()) {
                        Ext.MessageBox.alert('提示', '请检查表单校验项！');
                        return false;
                    }
                    var grid = btn.up('window').down('#window_save_zcxx_grid');
                    var celledit = grid.getPlugin('window_save_zcxx_grid_plugin_cell');
                    //完成编辑
                    celledit.completeEdit();
                    if (window.flag_validateedit && !window.flag_validateedit.isHidden()) {
                        return false;//如果校验未通过
                    }
                    var store = btn.up('window').down('#window_save_zcxx_grid').getStore();
                    if (store.getCount() < 1) {
                        Ext.MessageBox.alert('提示', '请新增数据明细！');
                        return;
                    }


                   var leng = store.getCount();
                    for(var i = 0; i<leng; i++){
                        if(store.getAt(i).data.HL_RATE >= 10000){
                            Ext.MessageBox.alert('提示', '汇率不能大于或等于10000！');
                            return false;
                        }
                    }

                    //录入数据进行验证与格式化
                    var grid_error_message = checkEditorGrid(btn.up('window').down('grid#window_save_zcxx_grid'));
                    if (grid_error_message) {
                        Ext.MessageBox.alert('提示', grid_error_message);
                        return false;
                    }
                    var recordArray = [];
                    var zw_ids = [];//（分债务）债务ID
                    var zw_names = {};//（分债务）债务名称
                    var zc_amt_bc = {};//（分债务）本次支出总计
                    var zw_ye_amt = {};//（分债务）债务余额
                    store.each(function (record) {
                        //校验支出金额与债务余额
                        if (zc_amt_bc[record.get('ZW_ID')] == undefined) {
                            zw_ids.push(record.get('ZW_ID'));
                            zw_names[record.get('ZW_ID')] = record.get('ZW_NAME');
                            zc_amt_bc[record.get('ZW_ID')] = record.get('PAY_ORI_AMT');//人民币金额
                        } else {
                            zc_amt_bc[record.get('ZW_ID')] += record.get('PAY_ORI_AMT');
                        }
                        if (zw_ye_amt[record.get('ZW_ID')] == undefined) {
                            zw_ye_amt[record.get('ZW_ID')] = record.get('ZW_YE');
                        }
                        recordArray.push(record.getData());
                    });
                    if (zw_ids.length > 0) {
                        for (var i = 0; i < zw_ids.length; i++) {
                            if (accSub(zw_ye_amt[zw_ids[i]],zc_amt_bc[zw_ids[i]]) < 0 && Math.abs(accSub(zw_ye_amt[zw_ids[i]],zc_amt_bc[zw_ids[i]])) > 0.01) {
                                Ext.Msg.alert('提示', '债务名称为： "' + zw_names[zw_ids[i]] + '" 的债务</br>本次还款金额总计超出债务余额！');
                                return false;
                            }
                        }
                    }
                    var data_ZCD = btn.up('window').down('form').getForm().getFieldValues();
                    data_ZCD.ZQ_NAME = '';
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
                        data_ZCD: Ext.util.JSON.encode(data_ZCD),
                        dataList: Ext.util.JSON.encode(recordArray),
                        DATATYPE:DATATYPE
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            btn.setDisabled(false);
                        } else {
                            // 提示保存成功
                            Ext.toast({
                                html: "<div style='text-align: center;'>保存成功!</div>",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //重新加载表格数据
                            DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                            btn.up('window').close();
                            var window_zhmx = initWindow_select_zhmx();
                            window_zhmx.hide();
                        }
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
    };
    if (!config.editable) {
        delete window_config.buttons;
        delete window_config.items[0].listeners;
    }
    return Ext.create('Ext.window.Window', window_config);
}
/**
 * 初始化债券支出保存弹出窗口表单
 */
function initWindow_save_zcxx_form(config) {
    return Ext.create('Ext.form.Panel', {
        //title: '详情表单',
        width: '100%',
        itemId: 'window_save_zcxx_form',
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
            //可支出总额PAY_ZH_AMT_TOTAL(已支出总额度+剩余可用额度)
            //初始已支出金额PAY_ZH_AMT_YZC_CS(已支出总额度)
            //本单初始支出PAY_ZH_AMT_YZC_BDCS(若是新增：0，若是修改：本单支出总额)
            //本单已支出金额PAY_ZH_AMT_YZC_BD(=本单初始支出，修改支出金额后改变)
            //未支出金额PAY_ZH_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
            {fieldLabel: '地区', name: 'AD_CODE', hidden: true},
            {fieldLabel: '地区', name: 'AD_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券', name: 'ZQ_ID', hidden: true},
            {fieldLabel: '债券名称', name: 'ZQ_NAME', columnWidth: .66, xtype: 'displayfield'},
            {fieldLabel: '支出类型', name: 'ZC_TYPE_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券类型编码', name: 'ZQLB_ID', readOnly: true, fieldCls: 'form-unedit',hidden:true},
            {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '期限', name: 'ZQQX_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: "置换债券金额", name: "PAY_ZH_AMT_TOTAL", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
            {fieldLabel: "初始已支出金额", name: "PAY_ZH_AMT_YZC_CS", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "本单初始支出金额", name: "PAY_ZH_AMT_YZC_BDCS", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "本单已支出金额", name: "PAY_ZH_AMT_YZC_BD", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "未支出金额", name: "PAY_ZH_AMT_WZC", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
            {fieldLabel: "支出进度(%)", name: "ZC_PROGRESS", readOnly: true, fieldCls: 'form-unedit',xtype : 'numberfield',decimalPrecision: 4},
            {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
            {fieldLabel: "单据ID", name: "ZCD_ID", hidden: true},
            {fieldLabel: "单据编号", name: "ZCD_CODE", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '支出年度', name: 'ZCD_YEAR', hidden: true},
            {fieldLabel: "支出日期", name: "APPLY_DATE", hidden: true},
            {fieldLabel: "使用单位", name: "AG_ID", hidden: true},
            {fieldLabel: "DATATYPE",name:"DATATYPE",hidden:true},
            {fieldLabel: "使用单位", name: "AG_CODE", hidden: true},
            {fieldLabel: "使用单位", name: "AG_NAME", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: "支出总额(元)", name: "PAY_AMT_TOTAL", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
            {fieldLabel: "录入人", name: "ZCD_LR_USER", hidden: true},
            {fieldLabel: "录入人", name: "ZCD_LR_USER_NAME", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: "备注", name: "ZCD_REMARK", columnWidth: .66, readOnly: !config.editable}
        ]
    });
}
/**
 * 初始化债券支出保存弹出窗口表格
 */
function initWindow_save_zcxx_grid(config) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "债务约定还本(债务还款计划)ID", dataIndex: "YDCH_ID", type: "string", width: 150, hidden: true},
        {text: "债务ID", dataIndex: "ZW_ID", type: "string", hidden: true},
        {text: "国库支付信息ID", dataIndex: "GKZF_ID", type: "string", hidden: true},
        {text: "置换明细ID", dataIndex: "ZHMX_ID", type: "string", hidden: true},
        {text: "支出ID", dataIndex: "ZC_ID", type: "string", hidden: true},
        {text: "偿还计划ID", dataIndex: "CHJH_ID", type: "string", hidden: true},
        {
            text: "债务名称", dataIndex: "ZW_NAME", type: "string", width: 300, tdCls: 'grid-cell-unedit',
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
            text: "支出日期", dataIndex: "PAY_DATE", type: "string", tdCls: 'grid-cell',
            editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            text: "置换原币金额(元)", dataIndex: "PAY_ORI_AMT", type: "float", tdCls: 'grid-cell', width: 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        },
        {
        	text: "置换人民币金额(元)", dataIndex: "PAY_AMT", type: "float", tdCls: 'grid-cell', width: 150,
        	editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        },
        {
        	text: "汇率", dataIndex: "HL_RATE", type: "string", tdCls: 'grid-cell',
        	editor: {xtype: 'numberFieldFormat', hideTrigger: true, decimalPrecision: 6, minValue: 0}
        },
        {text: "到期金额(原币)(元)", dataIndex: "DUE_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150},
        {text: "项目ID", dataIndex: "XM_ID", type: "string", hidden: true},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 200, tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "协议号", dataIndex: "ZW_XY_NO", type: "string", tdCls: 'grid-cell-unedit', width: 200},
        {text: "债务类型", dataIndex: "ZWLB_NAME", type: "string", tdCls: 'grid-cell-unedit', width: 150},
        {text: "到期日期", dataIndex: "HKJH_DATE", type: "string", tdCls: 'grid-cell-unedit', width: 150},
        {text: "债权类型", dataIndex: "ZQFL_NAME", type: "string", tdCls: 'grid-cell-unedit', width: 150},
        {text: "债权人", dataIndex: "ZQR_NAME", type: "string", tdCls: 'grid-cell-unedit', width: 150},
        {text: "债权人全称", dataIndex: "ZQR_FULLNAME", type: "string", tdCls: 'grid-cell-unedit', width: 200},
        {text: "债务余额(元)", dataIndex: "ZW_YE", type: "float", tdCls: 'grid-cell-unedit', width: 150},
        {text: "币种", dataIndex: "CUR_NAME", type: "string", tdCls: 'grid-cell-unedit', hidden: true},
        {text: "币种ID", dataIndex: "FM_ID", type: "string", tdCls: 'grid-cell-unedit', hidden: true},
        {text: "年度", dataIndex: "SET_YEAR", type: "string", tdCls: 'grid-cell-unedit', hidden: true}
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
                    beforeedit: function (editor, context) {

                        //支出金额：如果是库款垫付，就不允许修改
                        if (context.field == 'PAY_ORI_AMT') {
                            /*if (context.record.get('IS_KKDF') == '1') {
                                return true;
                            }*/
                        }
                        if (context.field == 'HL_RATE') {
                            if (context.record.get('FM_ID') == 'CNY') {
                                return false;
                            }
                        }
                    },
                    validateedit: function (editor, context) {
                        //债券金额验证
                    	if(context.field == 'PAY_AMT'){
                    		var PAY_AMT_TOTAL = 0;//支出单总额
                    		var grid = DSYGrid.getGrid("window_save_zcxx_grid");
                    		var form = grid.up('tabpanel').down('form');
                    		var records = grid.getStore().getData();
                    		var pay_amt_rmb = context.value ;//人民币
                    		var YZC_AMT_BD = 0;//对应项目的本单支出总额
                    		for (var i = 0; i < records.length; i++) {
                                if (records.items[i].internalId == context.record.internalId) {
                                    PAY_AMT_TOTAL += pay_amt_rmb;
                                } else {
                                    PAY_AMT_TOTAL += records.items[i].data.PAY_AMT;
                                }
                                if (records.items[i].data.HKJH_ID == hkjh_id/* && records.items[i].data.IS_KKDF == '0'*/) {
                                    if (records.items[i].internalId == context.record.internalId) {
                                        YZC_AMT_BD += pay_amt_rmb;
                                    } else {
                                        YZC_AMT_BD += records.items[i].data.PAY_AMT;
                                    }
                                }
                            }
                    		var PAY_ZH_AMT_WZC =accAdd(accSub(accSub(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue(),form.down('[name=PAY_ZH_AMT_YZC_CS]').getValue()),PAY_AMT_TOTAL),form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue());
                            if (PAY_ZH_AMT_WZC < 0 && Math.abs(PAY_ZH_AMT_WZC) > 0.01) {

                                window.flag_validateedit = Ext.MessageBox.alert('提示', '置换金额超出债券最大可支出金额！');
                                return false;
                            }
                            form.down('[name=PAY_ZH_AMT_WZC]').setValue(PAY_ZH_AMT_WZC);
                    	}
                        if (context.field == 'PAY_ORI_AMT') {
                            window.flag_validateedit = null;
                            if (context.value <= 0) {
                                window.flag_validateedit = Ext.MessageBox.alert('提示', '置换金额必须大于0！');
                                return false;
                            }
                            /*if (context.record.get('IS_KKDF') == '1') {
                                return true;
                            }*/
                            var pay_amt_rmb = context.value * context.record.get('HL_RATE');//人民币
                            var pay_ori_amt = context.value;//原币
                            var grid = DSYGrid.getGrid("window_save_zcxx_grid");
                            var records = grid.getStore().getData();
                            var form = grid.up('tabpanel').down('form');
                            var hkjh_id = context.record.data.HKJH_ID;
                            /*修改表格中支出金额：
                             循环表格
                             校验：获取支出单总额，未支出金额(可支出总额-初始已支出总额度-本单已支出总额+本单初始支出)>=0
                             获取项目本单已支出金额，未拨付金额(预算-初始已支出-本单已支出+本单初始支出)>=0
                             支出单：支出单总额修改
                             新增债券：未支出额度修改
                             hkjhLSIT：修改对应项目的本单已支出金额、未拨付金额*/
                            var PAY_AMT_TOTAL = 0;//支出单总额
                            var YZC_AMT_BD = 0;//对应项目的本单支出总额
                            for (var i = 0; i < records.length; i++) {
                                if (records.items[i].internalId == context.record.internalId) {
                                    PAY_AMT_TOTAL += pay_amt_rmb;
                                } else {
                                    PAY_AMT_TOTAL += records.items[i].data.PAY_AMT;
                                }
                                if (records.items[i].data.HKJH_ID == hkjh_id/* && records.items[i].data.IS_KKDF == '0'*/) {
                                    if (records.items[i].internalId == context.record.internalId) {
                                        if (DEBT_CONN_ZQXM == 2) {
                                            YZC_AMT_BD += pay_ori_amt;
                                        } else {
                                            YZC_AMT_BD += pay_amt_rmb;
                                        }
                                    } else {
                                        if (DEBT_CONN_ZQXM == 2) {
                                            YZC_AMT_BD += records.items[i].data.PAY_ORI_AMT;
                                        } else {
                                            YZC_AMT_BD += records.items[i].data.PAY_AMT;
                                        }
                                    }
                                }
                            }
                            //值*100/100解决小数精度问题
                            var PAY_ZH_AMT_WZC =accAdd(accSub(accSub(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue(),form.down('[name=PAY_ZH_AMT_YZC_CS]').getValue()),PAY_AMT_TOTAL),form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue());
                            //var PAY_ZH_AMT_WZC = (form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() * 100 - form.down('[name=PAY_ZH_AMT_YZC_CS]').getValue() * 100 - PAY_AMT_TOTAL * 100 + form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue() * 100);
                            //PAY_ZH_AMT_WZC = PAY_ZH_AMT_WZC / 100;
                            if (PAY_ZH_AMT_WZC < 0 && Math.abs(PAY_ZH_AMT_WZC) > 0.01) {
                                window.flag_validateedit = Ext.MessageBox.alert('提示', '置换金额超出债券最大可支出金额！');
                                return false;
                            }
                            var hkjh_info = grid.up('window').HKJH_LIST[hkjh_id];
                            var WBF_AMT = accAdd(accSub(hkjh_info.KZC_AMT,YZC_AMT_BD),hkjh_info.YZC_AMT_BDCS);
                            //var WBF_AMT = hkjh_info.KZC_AMT*10000 - YZC_AMT_BD*10000 + hkjh_info.YZC_AMT_BDCS*10000;
                               //WBF_AMT = WBF_AMT / 10000;
                            if (WBF_AMT < 0 && Math.abs(WBF_AMT) > 0.01) {
                                window.flag_validateedit = Ext.MessageBox.alert('提示', '置换金额超出应还到期金额！');
                                return false;
                            }
                            //校验通过，修改对应数据
                            form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
                            form.down('[name=PAY_ZH_AMT_YZC_BD]').setValue(PAY_AMT_TOTAL);
                            form.down('[name=PAY_ZH_AMT_WZC]').setValue(PAY_ZH_AMT_WZC);
                            var ZC_PROGRESS = accMul(accDiv(accSub(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue(),PAY_ZH_AMT_WZC),form.down('[name=PAY_ZH_AMT_TOTAL]').getValue()),100);
                            //var ZC_PROGRESS = (form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() - PAY_ZH_AMT_WZC ) / form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() * 100;
                            ZC_PROGRESS = Ext.util.Format.number(ZC_PROGRESS, '0.00');
                            form.down('[name=ZC_PROGRESS]').setValue(ZC_PROGRESS);
                            hkjh_info.YZC_AMT_BD = YZC_AMT_BD;
                            hkjh_info.WBF_AMT = WBF_AMT;
                            grid.getStore().each(function (record) {
                                if (record.data.HKJH_ID == hkjh_id) {
                                    record.set('WBF_AMT', WBF_AMT);
                                }
                            });
                        }
                    },
                    edit: function (editor, context) {
                        if (context.field == 'PAY_ORI_AMT') {
                            context.record.set('PAY_AMT', accMul(context.value , context.record.get('HL_RATE')));
                        }
                        if (context.field == 'HL_RATE') {
                        	context.record.set('PAY_AMT', accMul(context.value , context.record.get('PAY_ORI_AMT')));
                        }
                        if (context.field == 'PAY_AMT') {
                            if(context.record.get('PAY_ORI_AMT') == 0) {
                            	Ext.MessageBox.alert('提示', '原币金额不能为0！');
                            	return false;
                            }

                        	context.record.set('HL_RATE', accDiv(context.value , context.record.get('PAY_ORI_AMT')));//
                            if(context.record.data.HL_RATE >= 10000){
                                Ext.MessageBox.alert('提示', '汇率不能大于或等于10000！');
                                return false;
                            }
                        }
                        if (context.field == 'PAY_DATE' || context.field == 'APPLY_DATE' || context.field == 'JZ_DATE') {
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
        busiType: 'ET206',//业务类型
        busiId: config.gridId,//业务ID
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
 * validateedit 表格编辑插件校验
 */
function checkEditorGrid(grid) {
    for (var i = 0; i < grid.getStore().getCount(); i++) {
        var record = grid.getStore().getAt(i);
        if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null || record.get('PAY_DATE') == '') {
            return '支出日期为空！';
        }
        if (!record.get('PAY_ORI_AMT') || record.get('PAY_ORI_AMT') == null || record.get('PAY_ORI_AMT') <= 0) {
            return '支出原币金额非法，置换金额必须大于0！';
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
    if(AD_CODE==''||AD_CODE==null){
        AD_CODE=USER_AD_CODE;
    }
    if(AG_CODE==''||AG_CODE==null){
        AG_CODE=USER_AG_CODE;
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
    var opValue = '';
    if (button_name == '送审') {
        opValue = '确定送审';
    } else if (btn.name == 'up') {
        opValue = '';
    } else {
        opValue = '同意';
    }
    if (button_name == '送审') {
    	Ext.Msg.confirm('提示', '请确认是否'+button_name+'!', function (btn_confirm) {
    		if (btn_confirm === 'yes') {
    			//发送ajax请求，修改节点信息
                $.post("/updateFxdfZqsyZqzcNode.action", {
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
                    btn.setDisabled(false);
                    //刷新表格
                    reloadGrid();
                }, "json");
    		}else{
                btn.setDisabled(false);
            }
    	});
    }else {
	    //弹出意见填写对话框
	    initWindow_opinion({
	        title: btn.text,
	        animateTarget: btn,
	        value: opValue,
	        fn: function (buttonId, text) {
	            if (buttonId === 'ok') {
	                //发送ajax请求，修改节点信息
	                $.post("/updateFxdfZqsyZqzcNode.action", {
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
                        btn.setDisabled(false);
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
 * 初始化支出数据
 */
function initZcxxData_onfirm(config) {

}
function initZcxxData_update(config) {
    //发送ajax请求，获取修改数据
    $.post("/getFxdfZqsyZqzcGridById.action", {
        ZCD_ID: config.ZCD_ID,
        ZC_TYPE: ZC_TYPE,
        ZC_TYPES:config.ZC_TYPES
    }, function (data) {
        if (data.success) {
            var window_zc = initWindow_save_zcxx({
                editable: config.editable,
                gridId: config.ZCD_ID
            });
            window_zc.show();
            var data_zcd = data.data_zcd;
            var data_zcmx = data.data_zcmx;
            var data_zq = data.data_zq;
            var data_zdmx = $.extend({}, data_zq, data_zcd);
            /*修改插入数据：
             初始化     债券：可支出总额(已支出总额度+剩余可用额度)，初始已支出金额(已支出总额度)，本单初始支出，新增已支出金额(=本单初始支出)，未支出金额(可支出总额-已支出总额度-新增已支出总额+本单初始支出)
             循环表格   获取支出单支出总额(人民币总和)
             HKJHLIST：可支出金额(到期金额-在途已支出金额与发行计划申请金额中小的)、本单初始支出、新增已支出金额(=本单初始支出 )、未拨付金额(可支出金额 -新增已支出+本单初始支出)
             */
            //债券相关信息
            data_zdmx.PAY_ZH_AMT_TOTAL = data_zq.PAY_ZH_AMT + data_zq.SY_ZH_AMT;
            data_zdmx.PAY_ZH_AMT_YZC_CS = data_zq.PAY_ZH_AMT;
            data_zdmx.PAY_ZH_AMT_YZC_BDCS = data_zcd.TOTAL_PAY_ORI_AMT_RMB;
            data_zdmx.PAY_ZH_AMT_YZC_BD = data_zdmx.PAY_ZH_AMT_YZC_BDCS;
            data_zdmx.PAY_ZH_AMT_WZC = accAdd(accSub(accSub(data_zdmx.PAY_ZH_AMT_TOTAL,data_zdmx.PAY_ZH_AMT_YZC_CS),data_zdmx.PAY_ZH_AMT_YZC_BD),data_zdmx.PAY_ZH_AMT_YZC_BDCS);
            //data_zdmx.PAY_ZH_AMT_WZC = (data_zdmx.PAY_ZH_AMT_TOTAL*100 - data_zdmx.PAY_ZH_AMT_YZC_CS*100 - data_zdmx.PAY_ZH_AMT_YZC_BD*100 + data_zdmx.PAY_ZH_AMT_YZC_BDCS*100)/100;
            data_zdmx.ZC_PROGRESS = accMul(accDiv(accSub(data_zdmx.PAY_ZH_AMT_TOTAL,data_zdmx.PAY_ZH_AMT_WZC),data_zdmx.PAY_ZH_AMT_TOTAL),100);
            //data_zdmx.ZC_PROGRESS = (data_zdmx.PAY_ZH_AMT_TOTAL - data_zdmx.PAY_ZH_AMT_WZC) / data_zdmx.PAY_ZH_AMT_TOTAL * 100;
            data_zdmx.ZC_PROGRESS = Ext.util.Format.number(data_zdmx.ZC_PROGRESS, '0.00');
            data_zdmx.ZC_TYPE_NAME = '置换债券支出';
            //data_zdmx.ZQ_NAME = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + data_zdmx.ZQ_ID + '&AD_CODE=' + data_zdmx.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + data_zdmx.ZQ_NAME + '</a>'
            var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
            var paramNames=new Array();
            paramNames[0]="ZQ_ID";
            paramNames[1]="AD_CODE";
            var paramValues=new Array();
            paramValues[0]=encodeURIComponent(data_zdmx.ZQ_ID);
            paramValues[1]=encodeURIComponent(data_zdmx.AD_CODE.replace(/00$/, ""));
            data_zdmx.ZQ_NAME='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+ data_zdmx.ZQ_NAME+'</a>';
            //支出单相关信息
            data_zdmx.ZCD_ID = data_zcd.ZCD_ID;
            data_zdmx.ZCD_CODE = data_zcd.ZCD_CODE;
            data_zdmx.AG_ID = data_zcd.AG_ID;
            data_zdmx.AG_CODE = data_zcd.AG_CODE;
            data_zdmx.AG_NAME = data_zcd.AG_NAME;
            data_zdmx.ZCD_LR_USER = data_zcd.ZCD_LR_USER;
            data_zdmx.ZCD_LR_USER_NAME = data_zcd.ZCD_LR_USER_NAME;
            data_zdmx.APPLY_DATE = data_zcd.APPLY_DATE;
            data_zdmx.PAY_AMT_TOTAL = data_zcd.TOTAL_PAY_ORI_AMT_RMB;
            window_zc.down('form').getForm().setValues(data_zdmx);
            window_zc.HKJH_LIST = {};
            var DATATYPE_TEMP=data_zq.DATATYPE
            //循环明细记录，计算对应项目的本单初始支出金额、本单支出金额、未拨付金额
            for (var i = 0; i < data_zcmx.length; i++) {
                if(data_zcmx[i].ROE_NOW==null){
                    data_zcmx[i].ROE_NOW=0;
                }
                /*data_zcmx[i].HL_RATE = parseFloat(data_zcmx[i].ROE_NOW);
                data_zcmx[i].PAY_ORI_AMT = parseFloat(data_zcmx[i].PAY_ORI_AMT);
                data_zcmx[i].PAY_AMT = accMul(data_zcmx[i].HL_RATE,data_zcmx[i].PAY_ORI_AMT);*/
                data_zcmx[i].HL_RATE = parseFloat(data_zcmx[i].HL_RATE);
                data_zcmx[i].PAY_ORI_AMT = parseFloat(data_zcmx[i].PAY_ORI_AMT);
                data_zcmx[i].PAY_AMT = parseFloat(data_zcmx[i].PAY_AMT);
                //data_zcmx[i].PAY_AMT = data_zcmx[i].HL_RATE * data_zcmx[i].PAY_ORI_AMT;
                //如果是库款垫付，不计入还款计划list统计
                /*if (data_zcmx[i].IS_KKDF == '1') {
                    continue;
                }*/
                var hkjh = window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID];
                if (!hkjh) {
                    //新增项目
                    window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID] = {};
                    hkjh = window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID];
                    //如果系统参数为2，不比较，直接取到期金额-在途已支出金额
                    //可支出金额(到期金额-在途已支出金额 )与(发行计划申请金额-计划已支出金额) 中小的
                    if (DEBT_CONN_ZQXM == 2) {
                            //不关联计划时取原币
                            hkjh.KZC_AMT = accSub(data_zcmx[i].DUE_AMT,data_zcmx[i].PAY_AMT_YZC);
                            //hkjh.KZC_AMT = (data_zcmx[i].DUE_AMT_RMB * 10000 - data_zcmx[i].PAY_AMT_YZC_RMB * 10000) / 10000;
                    } else {
                        if ((data_zcmx[i].DUE_AMT_RMB - data_zcmx[i].PAY_AMT_YZC_RMB) < (data_zcmx[i].APPLY_AMOUNT - data_zcmx[i].PAY_AMT_SUM)) {
                            hkjh.KZC_AMT = accSub(data_zcmx[i].DUE_AMT_RMB,data_zcmx[i].PAY_AMT_YZC_RMB);
                            //hkjh.KZC_AMT = (data_zcmx[i].DUE_AMT_RMB * 10000 - data_zcmx[i].PAY_AMT_YZC_RMB * 10000) / 10000;
                        } else {
                            hkjh.KZC_AMT = accSub(data_zcmx[i].APPLY_AMOUNT,data_zcmx[i].PAY_AMT_SUM);
                            //hkjh.KZC_AMT = (data_zcmx[i].APPLY_AMOUNT * 10000 - data_zcmx[i].PAY_AMT_SUM * 10000) / 10000;
                        }
                    }
                    hkjh.YZC_AMT_BDCS = 0;
                }
                if (DEBT_CONN_ZQXM == 2) {
                    //不关联计划时计算原币
                    hkjh.YZC_AMT_BDCS = accAdd(hkjh.YZC_AMT_BDCS,data_zcmx[i].PAY_ORI_AMT);
                } else {
                    if(config.ZC_TYPES!=null&&config.ZC_TYPES==2){
                        hkjh.YZC_AMT_BDCS = accAdd(hkjh.YZC_AMT_BDCS,data_zcmx[i].PAY_ORI_AMT);
                    }else{
                        //关联计划时计算人民币
                        hkjh.YZC_AMT_BDCS = accAdd(hkjh.YZC_AMT_BDCS,data_zcmx[i].PAY_AMT);
                    }

                }
                //hkjh.YZC_AMT_BDCS = accAdd(hkjh.YZC_AMT_BDCS,data_zcmx[i].PAY_AMT);
                //hkjh.YZC_AMT_BDCS = (hkjh.YZC_AMT_BDCS * 10000 + data_zcmx[i].PAY_AMT * 10000) / 10000;//累加本单初始
                hkjh.YZC_AMT_BD = hkjh.YZC_AMT_BDCS;
                hkjh.WBF_AMT= accAdd(accSub(hkjh.KZC_AMT,hkjh.YZC_AMT_BD),hkjh.YZC_AMT_BDCS);
                //hkjh.WBF_AMT = (hkjh.KZC_AMT*100 - hkjh.YZC_AMT_BD*100 + hkjh.YZC_AMT_BDCS*100)/100;
            }
            //循环明细记录，未拨付金额
            for (var i = 0; i < data_zcmx.length; i++) {
                var hkjh = window_zc.HKJH_LIST[data_zcmx[i].HKJH_ID];
                if (hkjh) {
                    data_zcmx[i].WBF_AMT = hkjh.WBF_AMT;
                }
            }
            //将数据插入到填报表格中
            window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
            //重新计算支出单总支出金额与债券相关金额
            var form = window_zc.down('form');
            var PAY_AMT_TOTAL = window_zc.down('grid#window_save_zcxx_grid').getStore().sum('PAY_AMT');
            var PAY_ZH_AMT_WZC = accAdd(accSub(accSub(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue(),form.down('[name=PAY_ZH_AMT_YZC_CS]').getValue()),PAY_AMT_TOTAL),form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue());
            //var PAY_ZH_AMT_WZC = form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() - form.down('[name=PAY_ZH_AMT_YZC_CS]').getValue() - PAY_AMT_TOTAL + form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue();
            if (PAY_ZH_AMT_WZC < 0 && Math.abs(PAY_ZH_AMT_WZC) > 0.01) {
                Ext.toast({
                    html: "置换金额超出债券最大可支出金额！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                return false;
            }
            form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
            form.down('[name=DATATYPE]').setValue(DATATYPE_TEMP);
            form.down('[name=PAY_ZH_AMT_YZC_BD]').setValue(PAY_AMT_TOTAL);
            form.down('[name=PAY_ZH_AMT_WZC]').setValue(PAY_ZH_AMT_WZC);
            form.down('[name=ZC_PROGRESS]').setValue(accMul(accDiv(accSub(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue(),PAY_ZH_AMT_WZC),form.down('[name=PAY_ZH_AMT_TOTAL]').getValue()),100));
            //(form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() - PAY_ZH_AMT_WZC ) / form.down('[name=PAY_ZH_AMT_TOTAL]').getValue() * 100
        } else {
            Ext.MessageBox.alert('提示', '查询修改数据失败！' + data.message);
        }
    }, "json");
}