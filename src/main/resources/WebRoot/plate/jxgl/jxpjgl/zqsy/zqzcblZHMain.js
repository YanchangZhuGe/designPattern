var wf_id = getQueryParam("wf_id");//当前流程id
var node_code = getQueryParam("node_code");//当前节点id
var node_type = 'zcblzh';//当前节点标识
var ZC_TYPE = 1;//支出类型：0新增债券类型 1置换债券类型
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮的name，标识按钮状态
var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '000';
}
json_debt_zt0.unshift({"id": "000", "code": "000", "name": "未补录"});
//全局变量
/**
 * 通用配置json
 */
var json_common = {
    zcblzh: {//发行兑付-债券使用-置换债券支出补录
        items: {
            '000': [
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
                    text: '补录',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        // 检验是否有数据
                        // 获取数据
                        var records = DSYGrid.getGrid('contentGrid_GKZF').getSelection();
                        if (records.length < 1) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        var recordArray = [];
                        for (var i = 0; i < records.length; i++) {
                            recordArray.push(records[i].getData());
                        }
                        //校验是否是相同单位的项目
                        var ag_id = null;
                        var year = null;
                        var zq_id = null;
                        for (var i = 0; i < recordArray.length; i++) {
                            var obj = recordArray[i];
                            if (!ag_id) {
                                ag_id = obj.AG_ID;
                            } else if (ag_id != obj.AG_ID) {
                                Ext.toast({html: '明细数据单位不一致！'});
                                return false;
                            }
                            if (!year) {
                                year = obj.PAY_DATE.substr(0, 4);
                            } else if (year != obj.PAY_DATE.substr(0, 4)) {
                                Ext.toast({html: '明细数据年度不一致！'});
                                return false;
                            }
                            if (!zq_id) {
                            	zq_id = obj.ZQ_ID;
                            } else if (zq_id != obj.ZQ_ID) {
                                Ext.toast({html: '明细数据支出债券不一致！'});
                                return false;
                            }
                        }
                        //弹出债券选择框
                        initWindow_select_zdmx({
                            ZCD_YEAR: year,
                            ZQ_ID: zq_id
                        }).show();
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
                        var grid = DSYGrid.getGrid('contentGrid_GKZF');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        Ext.Msg.confirm('提示','请确实是否删除?',function(fn){
                        	if(fn=='yes'){
                        	   store.remove(sm.getSelection());
                        	}
                        });
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
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
                    hidden: true,
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
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
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        initZcxxData_update({
                            editable: true,
                            ZCD_ID: records[0].get('ZCD_ID')
                        })
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
                                        Ext.toast({html: button_name + "成功！"});
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
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        initZcxxData_update({
                            editable: true,
                            ZCD_ID: records[0].get('ZCD_ID')
                        })
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
                                        Ext.toast({html: button_name + "成功！"});
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
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
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
    initContent();
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
                items: json_common[node_type].items[WF_STATUS]
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
        items: [
            initContentGrid(),
            initContentGrid_GKZF()
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
        {text: "支出类型", dataIndex: "ZC_TYPE", type: "string", hidden: true},
        {text: "关联债券ID", dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: "所属区划", dataIndex: "AD_NAME", type: "string"},
        {text: "所属单位", dataIndex: "AG_ID", type: "string", hidden: true},
        {text: "所属单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
        {text: "所属单位", dataIndex: "AG_NAME", type: "string", width: 200},
        {text: "支出总额(元)", dataIndex: "TOTAL_PAY_ORI_AMT_RMB", type: "float", width: 160},
        {text: "录入人", dataIndex: "ZCD_LR_USER_NAME", type: "string", width: 200},
        {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string"},
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
            SJLY: 1
        },
        dataUrl: '/getFxdfZqzcMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        hidden: true,
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt0),
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
                        toolbar.add(json_common[node_type].items[WF_STATUS]);
                        //隐藏显示/国库支付表格，刷新当前表格
                        DSYGrid.getGrid('contentGrid').setHidden(WF_STATUS == '000');
                        DSYGrid.getGrid('contentGrid_GKZF').setHidden(WF_STATUS != '000');
                        DSYGrid.getGrid('contentGrid').down('[name=WF_STATUS]').setValue(WF_STATUS);
                        DSYGrid.getGrid('contentGrid_GKZF').down('[name=WF_STATUS]').setValue(WF_STATUS);
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        DSYGrid.getGrid('contentGrid_GKZF').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            }
        ],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                initZcxxData_update({
                    editable: false,
                    ZCD_ID: record.get("ZCD_ID")
                })
            }
        }
    });
}
/**
 * 初始化主表格
 */
function initContentGrid_GKZF() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "国库支付ID", dataIndex: "GKZF_ID", type: "string", hidden: true, mapping: 'SYSID'},
        {text: "单位ID", dataIndex: "AG_ID", type: "string", hidden: true},
        {text: "单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
        {text: "单位", dataIndex: "AG_NAME", type: "string", width: 200},
        {text: "支出日期", dataIndex: "PAY_DATE", type: "string", mapping: 'PAYTIME'},
        {text: "本次支出金额(元)", dataIndex: "PAY_AMT", type: "float", width: 160, mapping: 'PAYAMT'},
        {text: "功能分类", dataIndex: "GNFL_NAME", type: "string", width: 200},
        {text: "功能分类", dataIndex: "GNFL_ID", type: "string", hidden: true},
        {text: "经济分类", dataIndex: "JJFL_NAME", type: "string", width: 200},
        {text: "经济分类", dataIndex: "JJFL_ID", type: "string", hidden: true},
        {text: "支出债券名称", dataIndex: "ZQ_NAME", type: "string",  width: 180},
        {text: "收款人账户名称", dataIndex: "GATHERINGBANKACCTNAME", type: 'string', width: 180},
        {text: "支付摘要", dataIndex: "ZFZY", type: 'string', width: 180},
        {text: "支出用途", dataIndex: "PAYREMARK", type: 'string', width: 180},
        {text: "指标文号", dataIndex: "ZBWH", type: 'string', width: 180}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid_GKZF',
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
            ZQLB: 1,
            SJLY: 1
        },
        dataUrl: 'getFxdfZqzcGkzfGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '100%',
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt0),
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
                        toolbar.add(json_common[node_type].items[WF_STATUS]);
                        //隐藏显示/国库支付表格，刷新当前表格
                        DSYGrid.getGrid('contentGrid').setHidden(WF_STATUS == '000');
                        DSYGrid.getGrid('contentGrid_GKZF').setHidden(WF_STATUS != '000');
                        DSYGrid.getGrid('contentGrid').down('[name=WF_STATUS]').setValue(WF_STATUS);
                        DSYGrid.getGrid('contentGrid_GKZF').down('[name=WF_STATUS]').setValue(WF_STATUS);
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        DSYGrid.getGrid('contentGrid_GKZF').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            }
        ],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'contentGrid_GKZF_plugin_cell',
                clicksToMoveEditor: 1
            }
        ]
    });
}
/**
 * 初始化债券：转贷明细选择弹出窗口
 */
function initWindow_select_zdmx(param) {
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
        items: [initWindow_select_zdmx_grid(param)],
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
                    // 获取选择的国库支付数据
                    var records = DSYGrid.getGrid('contentGrid_GKZF').getSelection();
                    var PAY_AMT_TOTAL_GKZF = 0;
                    for (var i = 0; i < records.length; i++) {
                        PAY_AMT_TOTAL_GKZF += parseFloat(records[i].get('PAY_AMT'));
                    }
                    if (data_zdmx.SY_ZH_AMT < PAY_AMT_TOTAL_GKZF) {
                        Ext.MessageBox.alert('提示', '所选债券金额小于所选国库支付数据总支出金额！');
                        return false;
                    }
                    //发送ajax请求获取支出单id，国库支付信息
                    $.post('/getFxdfZqzcGkzfGrid_select.action', {
                        data_ZQ: Ext.util.JSON.encode(data_zdmx),
                        ZCD_YEAR: data_zdmx.ZCD_YEAR,
                        ZQLB: 1
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '获取支出相关信息失败！' + data.message);
                            return;
                        }
                        // 获取数据
                        var records = DSYGrid.getGrid('contentGrid_GKZF').getSelection();
                        if (records.length < 1) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        var recordArray = [];
                        for (var i = 0; i < records.length; i++) {
                            recordArray.push(records[i].getData());
                        }
                        var data_zcmx = recordArray;
                        var ZCD_ID = data.ZCD_ID;
                        //弹出债券支出填报页面
                        var window_zc = initWindow_save_zcxx({
                            editable: true,
                            gridId: ZCD_ID
                        });
                        window_zc.show();
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
                        //初始化债券与主单信息
                        data_zdmx = initZcxx_data_zdmx(data_zdmx, {
                            ZCD_ID: ZCD_ID,
                            ZCD_CODE: data.ZCD_CODE,
                            //AG_ID: AG_ID,
                            //AG_CODE: AG_CODE,
                            //AG_NAME: AG_NAME,
                            AG_ID: data_zcmx[0].AG_ID,
                            AG_CODE: data_zcmx[0].AG_CODE,
                            AG_NAME: data_zcmx[0].AG_NAME,
                            ZCD_LR_USER: USERCODE,
                            ZCD_LR_USER_NAME: USERNAME,
                            APPLY_DATE: nowDate,
                            PAY_AMT_TOTAL: 0,
                            PAY_ZH_AMT_YZC_BDCS:0
                        });
                        //将债券与主单数据插入到填报表单中
                        window_zc.down('form').getForm().setValues(data_zdmx);
                        for (var i = 0; i < data_zcmx.length; i++) {
                            data_zcmx[i].GKZF_ID = data_zcmx[i].SYSID;
                            data_zcmx[i].PAY_DATE = data_zcmx[i].PAYTIME;
                            data_zcmx[i].PAY_AMT = data_zcmx[i].PAYAMT;
                        }
                        //将数据插入到填报表格中
                        window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
                        //计算支出总金额/支出进度
                        updateWindow_save_zcxx_form(window_zc);
                        btn.up('window').close();
                    }, 'json');
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
function initWindow_select_zdmx_grid(param) {
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
                paramValues[1]=AD_CODE.replace(/00$/, "");
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
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 130},
        {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string"},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 200},
        {text: "兑付起始日", dataIndex: "DF_START_DATE", type: "string", width: 100},
        {text: "债券类别", dataIndex: "ZQLB_ID", type: "string", hidden: true, width: 200},
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
            ZC_TYPE: ZC_TYPE,
            ZQ_ID: param.ZQ_ID
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
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
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
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();
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
                                        select_zhmx(btn, ids, iskkdf, records);
                                    }
                                });
                            } else {
                                select_zhmx(btn, record, iskkdf);
                            }
                        }, 'json');
                    } else {
                        select_zhmx(btn, record, iskkdf);
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
function select_zhmx(btn, record, is_kkdf) {
    var window_zc = Ext.ComponentQuery.query('window#window_save_zcxx')[0];
    //判断是否有AG_ID，如果没有从明细中取出AG_ID（删除所有明细再新增选择明细时走这里）
    var ag_id = window_zc.down('form').down('[name=AG_ID]').getValue();
    if (!ag_id || !(ag_id.trim())) {
        window_zc.down('form').down('[name=AG_ID]').setValue(record.AG_ID);
        window_zc.down('form').down('[name=AG_CODE]').setValue(record.AG_CODE);
        window_zc.down('form').down('[name=AG_NAME]').setValue(record.AG_NAME);
    }
    //将项目id，名称放入
    var currentRecord = window_zc.down('grid#window_save_zcxx_grid').getCurrentRecord();
    currentRecord.set('IS_KKDF', is_kkdf ? '1' : '0');
    currentRecord.set('HKJH_ID', record.HKJH_ID);
    currentRecord.set('CHJH_ID', record.HKJH_ID);
    currentRecord.set('YDCH_ID', record.HKJH_ID);
    currentRecord.set('ZW_ID', record.ZW_ID);
    currentRecord.set('ZW_NAME', record.ZW_NAME);
    // currentRecord.set('HL_RATE', record.HL_RATE);
    currentRecord.set('HL_RATE', record.ROE_NOW);
    currentRecord.set('PAY_ORI_AMT', currentRecord.data.PAY_AMT / currentRecord.data.HL_RATE);
    currentRecord.set('DUE_AMT', record.DUE_AMT);
    currentRecord.set('XM_ID', record.XM_ID);
    currentRecord.set('XM_NAME', record.XM_NAME);
    currentRecord.set('ZW_XY_NO', record.ZW_XY_NO);
    currentRecord.set('ZWLB_NAME', record.ZWLB_NAME);
    currentRecord.set('HKJH_DATE', record.HKJH_DATE);
    currentRecord.set('ZQFL_NAME', record.ZQFL_NAME);
    currentRecord.set('ZQR_NAME', record.ZQR_NAME);
    currentRecord.set('ZQR_FULLNAME', record.ZQR_FULLNAME);
    currentRecord.set('ZW_YE', record.ZW_YE);
    currentRecord.set('CUR_NAME', record.CUR_NAME);
    currentRecord.set('FM_ID', record.FM_ID);
    currentRecord.set('SET_YEAR', record.SET_YEAR);
    btn.up('window').close();
}
/**
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出框表格
 */
function initWindow_select_zhmx_grid(param) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            text: "区划", dataIndex: "AD_NAME", type: "string", width: 150,
            renderer: function (value, metaData, record) {
                if (value < dsyDateFormat(new Date()))
                    metaData.css = 'x-grid-back-green';
                return value;
            }
        },
        {text: "单位", dataIndex: "AG_NAME", type: "string", width: 250},
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
        {text: "计划偿还日期", dataIndex: "HKJH_DATE", type: "string", width: 120},
        {text: "还款计划ID", dataIndex: "HKJH_ID", type: "string", hidden: true},
        {text: "到期金额(原币)(元)", dataIndex: "DUE_AMT", type: "float", width: 160},//非库款垫付：到期金额为还款计划金额-偿还本金
        {text: "到期金额(人民币)(元)", dataIndex: "DUE_AMT_RMB", type: "float", width: 160, hidden: true},//非库款垫付：到期金额为还款计划金额-偿还本金
        {text: "偿还本金金额(原币)(元)", dataIndex: "CHBJ_AMT", type: "float", width: 200, hidden: true},
        {text: "偿还本金金额(人民币)(元)", dataIndex: "CHBJ_AMT_RMB", type: "float", width: 200, hidden: true},
        {text: "在途已支出金额(原币)(元)", dataIndex: "PAY_AMT_YZC", type: "float", width: 200},
        {text: "在途已支出金额(人民币)(元)", dataIndex: "PAY_AMT_YZC_RMB", type: "float", width: 200, hidden: true},
        {text: "发行计划申请金额(人民币)(元)", dataIndex: "APPLY_AMOUNT", type: "float", width: 220},
        {text: "债务编码", dataIndex: "ZW_CODE", type: "string", width: 200},
        {text: "利率", dataIndex: "LX_RATE", type: "float"},
        {text: "签订日期", dataIndex: "SIGN_DATE", type: "string"},
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
        {text: "项目分类", dataIndex: "XMLX_NAME", type: "string", width: 200}
    ];
    var search_form = initWindow_zhzq_grid_searchTool();
    return DSYGrid.createGrid({
        itemId: 'window_select_zhmx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        border: true,
        height: '100%',
        flex: 1,
        dockedItems: [search_form],
        params: {
            AD_CODE: AD_CODE,
            AG_ID: (param && param.ag_id) ? param.ag_id : AG_ID,
            ZCD_YEAR: (param && param.ZCD_YEAR) ? param.ZCD_YEAR : nowDate.substring(0, 4),
            is_kkdf: 0
        },
        dataUrl: '/getFxdfZqsyHkjhGrid.action'
    });
}
/**
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出框搜索区域
 */
function initWindow_zhzq_grid_searchTool() {
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
            width: 500,
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
                        tabPanel.up('window').down('button[name=deleteZC]').setHidden(newCard.name == 'FILE');
                    }
                }
            }
        ],
        buttons: [
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
                    //计算支出总金额/支出进度
                    updateWindow_save_zcxx_form(btn.up('window'));
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    // 检验是否有数据
                    // 获取数据
                    var form = btn.up('window').down('form');
                    if (!form.isValid()) {
                        Ext.MessageBox.alert('提示', '请检查表单校验项！');
                        return false;
                    }
                    var grid = btn.up('window').down('#window_save_zcxx_grid');
                    var celledit = grid.getPlugin('window_save_zcxx_grid_plugin_cell');
                    //完成编辑
                    celledit.completeEdit();
                    var store = grid.getStore();
                    var recordArray = [];
                    var checkXmId = true;
                    store.each(function (record) {
                        var record_data = record.getData();
                        if (!record_data.YDCH_ID) {
                        	checkXmId = false;
                            return false;
                        }
                        recordArray.push(record_data);
                    });
                    if (!checkXmId) {
                        Ext.toast({html: '请选择项目！'});
                        return false;
                    }
                    //校验
                    if (!checkSaveGrid(btn.up('window'))) {
                        return false;
                    }
                    var data_ZCD = btn.up('window').down('form').getForm().getFieldValues();
                    btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                    //发送ajax请求，保存表格数据
                    $.post('/saveFxdfZqsyZqzcGrid.action', {
                        wf_id: wf_id,
                        node_code: node_code,
                        WF_STATUS: WF_STATUS,
                        SJLY: 1,
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
                            // 提示保存成功
                            Ext.toast({html: "保存成功!"});
                            //重新加载表格数据
                            reloadGrid();
                            btn.up('window').close();
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
            {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '期限', name: 'ZQQX_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: "置换债券金额", name: "PAY_ZH_AMT_TOTAL", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
            {fieldLabel: "初始已支出金额", name: "PAY_ZH_AMT_YZC_CS", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "本单初始支出金额", name: "PAY_ZH_AMT_YZC_BDCS", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "本单已支出金额", name: "PAY_ZH_AMT_YZC_BD", hidden: true, xtype: 'numberFieldFormat'},
            {fieldLabel: "未支出金额", name: "PAY_ZH_AMT_WZC", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
            {fieldLabel: "支出进度(%)", name: "ZC_PROGRESS", readOnly: true, fieldCls: 'form-unedit'},
            {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
            {fieldLabel: "单据ID", name: "ZCD_ID", hidden: true},
            {fieldLabel: "单据编号", name: "ZCD_CODE", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '支出年度', name: 'ZCD_YEAR', hidden: true},
            {fieldLabel: "支出日期", name: "APPLY_DATE", hidden: true},
            {fieldLabel: "使用单位", name: "AG_ID", hidden: true},
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
        {text: "国库支付ID", dataIndex: "GKZF_ID", type: "string", hidden: true},
        {text: "债务约定还本(债务还款计划)ID", dataIndex: "YDCH_ID", type: "string", width: 150, hidden: true},
        {text: "债务ID", dataIndex: "ZW_ID", type: "string", hidden: true},
        {
            text: "存量债务还本", dataIndex: "ZW_NAME", type: "string", width: 300, headerMark: 'star',
            editor: {
                xtype: "combobox",
                editable: false,
                listeners: {
                    expand: function (field) {
                        var form = field.up('window').down('form#window_save_zcxx_form');
                        var ag_id = form.down('[name=AG_ID]').getValue();
                        var zcd_year = form.down('[name=ZCD_YEAR]').getValue();
                        initWindow_select_zhmx({ag_id: ag_id, ZCD_YEAR: zcd_year}).show();
                    }
                }
            },
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
        {text: "支出日期", dataIndex: "PAY_DATE", type: "string", tdCls: 'grid-cell-unedit'},
        {text: "置换原币金额(元)", dataIndex: "PAY_ORI_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150},
        {
            text: "汇率", dataIndex: "HL_RATE", type: "string", tdCls: 'grid-cell', hidden: true,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, decimalPrecision: 6, minValue: 0}
        },
        {text: "置换人民币金额(元)", dataIndex: "PAY_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150},
        {text: "到期金额(原币)(元)", dataIndex: "DUE_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150},
        {text: "项目ID", dataIndex: "XM_ID", type: "string", hidden: true}, {
            text: "收款人账户名称",
            dataIndex: "GATHERINGBANKACCTNAME",
            type: 'string',
            tdCls: 'grid-cell-unedit',
            width: 180
        },
        {text: "支付摘要", dataIndex: "ZFZY", type: 'string', tdCls: 'grid-cell-unedit', width: 180},
        {text: "支出用途", dataIndex: "PAYREMARK", type: 'string', tdCls: 'grid-cell-unedit', width: 180},
        {text: "指标文号", dataIndex: "ZBWH", type: 'string', tdCls: 'grid-cell-unedit', width: 180},
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
                clicksToMoveEditor: 1
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
    var grid = DSYGrid.createGrid(grid_config);
    return grid;
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
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var grid = DSYGrid.getGrid('contentGrid');
    if (WF_STATUS == '000') {
        grid = DSYGrid.getGrid('contentGrid_GKZF');
    }
    var store = grid.getStore();
    //增加查询参数
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
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
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
 * 初始化转贷明细信息
 * @param data_zdmx
 * @param data_zcd
 * @return {*}
 */
function initZcxx_data_zdmx(data_zdmx, data_zcd) {
    //债券相关信息
    data_zdmx.PAY_ZH_AMT_TOTAL = data_zdmx.PAY_ZH_AMT + data_zdmx.SY_ZH_AMT;
    data_zdmx.PAY_ZH_AMT_YZC = data_zdmx.PAY_ZH_AMT;
    data_zdmx.PAY_ZH_AMT_WZC = data_zdmx.SY_ZH_AMT;
    data_zdmx.ZC_PROGRESS = data_zdmx.PAY_ZH_AMT_YZC / data_zdmx.PAY_ZH_AMT_TOTAL * 100;
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
    data_zdmx.PAY_AMT_TOTAL = data_zcd.PAY_AMT_TOTAL;
    data_zdmx.PAY_ZH_AMT_YZC_BDCS = data_zcd.PAY_ZH_AMT_YZC_BDCS;
    return data_zdmx;
}
/**
 * 修改/查询时弹出弹出框，查询支出数据
 * @param config 属性：editable(是否可编辑): true/false；ZCD_ID(支出单id)
 */
function initZcxxData_update(config) {
    //发送ajax请求，获取修改数据
    $.post("/getFxdfZqsyZqzcBlGridById.action", {
        ZCD_ID: config.ZCD_ID,
        ZC_TYPE: ZC_TYPE
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
            var PAY_ZH_AMT_YZC_BDCS = 0;
            for (var i = 0; i < data_zcmx.length; i++) {
                PAY_ZH_AMT_YZC_BDCS += data_zcmx[i].PAY_AMT;
            }
            data_zcd.PAY_ZH_AMT_YZC_BDCS = PAY_ZH_AMT_YZC_BDCS;
            var data_zdmx = $.extend({}, data_zq, data_zcd);
            /*修改插入数据：
             初始化     债券：可支出总额(已支出总额度+剩余可用额度)，初始已支出金额(已支出总额度)，本单初始支出，新增已支出金额(=本单初始支出)，未支出金额(可支出总额-已支出总额度-新增已支出总额+本单初始支出)
             循环表格   获取支出单支出总额(人民币总和)
             HKJHLIST：可支出金额(到期金额-在途已支出金额与发行计划申请金额中小的)、本单初始支出、新增已支出金额(=本单初始支出 )、未拨付金额(可支出金额 -新增已支出+本单初始支出)
             */
            //初始化债券与主单信息
            data_zdmx = initZcxx_data_zdmx(data_zdmx, data_zcd);
            window_zc.down('form').getForm().setValues(data_zdmx);
            //将数据插入到填报表格中
            window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
            //计算支出总金额/支出进度
            updateWindow_save_zcxx_form(window_zc);
        } else {
            Ext.MessageBox.alert('提示', '查询修改数据失败！' + data.message);
        }
    }, "json");
}
/**
 * 计算表单支出总金额与支出进度
 * @param win 保存弹出框
 */
function updateWindow_save_zcxx_form(win) {
    var form = win.down('form#window_save_zcxx_form');
    var grid = win.down('grid#window_save_zcxx_grid');
    var pay_amt_total = grid.getStore().sum('PAY_AMT');
    form.down('[name=PAY_AMT_TOTAL]').setValue(pay_amt_total);
    var PAY_ZH_AMT_TOTAL = form.down('[name=PAY_ZH_AMT_TOTAL]').getValue();
    var PAY_ZH_AMT_YZC_BDCS = form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue();
    var PAY_ZH_AMT_WZC = form.down('[name=PAY_ZH_AMT_WZC]').getValue();
    var ZC_PROGRESS = (PAY_ZH_AMT_TOTAL - PAY_ZH_AMT_WZC - PAY_ZH_AMT_YZC_BDCS + pay_amt_total) / PAY_ZH_AMT_TOTAL * 100;
    ZC_PROGRESS = Ext.util.Format.number(ZC_PROGRESS, '0.00');
    form.down('[name=ZC_PROGRESS]').setValue(ZC_PROGRESS);
}
/**
 * 校验保存数据
 * @param win
 * @return {boolean}
 */
function checkSaveGrid(win) {
    //校验支出金额是否超出债券剩余金额
    var form = win.down('form#window_save_zcxx_form');
    var grid = win.down('grid#window_save_zcxx_grid');
    var pay_amt_total = grid.getStore().sum('PAY_AMT');
    var PAY_ZH_AMT_WZC = form.down('[name=PAY_ZH_AMT_WZC]').getValue();
    var PAY_ZH_AMT_YZC_BDCS = form.down('[name=PAY_ZH_AMT_YZC_BDCS]').getValue();
    if (PAY_ZH_AMT_WZC + PAY_ZH_AMT_YZC_BDCS < pay_amt_total) {
        Ext.MessageBox.alert('提示', '支出总金额超出债券未支出金额！');
        return false;
    }
    return true;
}