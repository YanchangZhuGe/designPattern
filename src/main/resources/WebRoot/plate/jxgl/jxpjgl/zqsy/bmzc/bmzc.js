var wf_status = '001'; //当前状态
var zqlb_store = DebtEleTreeStoreDB('DEBT_ZQLB'); //债券类别store
/**
 * 通用配置json
 */
var bmzc_json_common = {
    '1': {
        jsFileUrl: 'bmzcLr.js'
    },
    '2': {
        jsFileUrl: 'bmzcSh.js'
    }
};
/**
 * 页面初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    //动态加载js
    $.ajaxSetup({
        cache: true
    });
    $.getScript(bmzc_json_common[node_code].jsFileUrl).complete(function () {
        initContent();
        reloadGrid();
    });
});

/**
 * 初始化主页面panel
 */
function initContent() {
    return Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true, //是否有分割线
            collapsible: false //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: bmzc_json_common.button_items[wf_status]
            }
        ],
        items: initContentRightPanel()
    });
}

/**
 * 初始化主页面表格panel
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        region: 'center',
        height: '100%',
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 5,
        border: false,
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 70, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        itemId: 'CONTENT_STATUS',
                        name: 'CONTENT_STATUS',
                        store: bmzc_json_common.status_store,
                        width: 110,
                        editable: false,
                        labelWidth: 30,
                        labelAlign: 'right',
                        allowBlank: false,
                        displayField: "name",
                        valueField: "code",
                        value: wf_status,
                        listeners: {
                            change: function (self, newValue) {
                                wf_status = newValue;
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                toolbar.removeAll();
                                toolbar.add(bmzc_json_common.button_items[wf_status]);
                                // 刷新主界面表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '债券类型',
                        displayField: 'name',
                        valueField: 'id',
                        name: 'ZQLB_ID',
                        store: zqlb_store,
                        editable: false,
                        labelWidth: 60,
                        width: 270,
                        labelAlign: 'right',
                        listeners: {
                            select: function (self, newValue) {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "MHCX",
                        name: "MHCX",
                        columnWidth: .99,
                        labelWidth: 60,
                        emptyText: '请输入债券名称/债券简称/债券编码',
                        enableKeyEvents: true,
                        listeners: {
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    reloadGrid();
                                }
                            }
                        }
                    }
                ]
            }
        ],
        items: initContentGrid()
    });
}

/**
 * 初始化主页面表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ZCD_ID", type: "string", text: "支出单ID", width: 120, hidden: true},
        {dataIndex: "ZCD_CODE", type: "string", text: "支出单编码", width: 200},
        {dataIndex: "ZQ_NAME", type: "string", text: "债券名称", width: 250},
        {
            dataIndex: "PAY_AMT", type: "float", text: "支出总额（元）", width: 150, summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "ZX_ZBJ_AMT", type: "float", text: "专项债用作资本金总额（元）", width: 150, summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "XZCZAP_AMT", type: "float", text: "其中:新增赤字（元）", width: 150, summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {dataIndex: "ZQ_JC", type: "string", text: "债券简称", width: 150},
        {dataIndex: "ZQ_CODE", type: "string", text: "债券编码", width: 200},
        {dataIndex: "ZQLB_NAME", type: "string", text: "债券类型", width: 150},
        {dataIndex: "ZCD_LR_USER", type: "string", text: "录入人", width: 150},
        {dataIndex: "ZCD_REMARK", type: "string", text: "备注", width: 200}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/zqgl/bmzc/getBmzcList.action',
        autoLoad: false,
        checkBox: true,
        flex: 2,
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        },
        listeners: {
            afterrender: function (grid) {
                var columns = grid.columns;
                for (var i = 0; i < columns.length; i++) {
                    columns[i].getEl().dom.children[0].children[0].children[0].children[0].style.whiteSpace = "normal";
                }
            }
        }
    });
}

/**
 * 工作流：送审、撤销送审、审核、撤销审核、退回
 */
function doWorkFlow(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    // 审核、退回需要填写意见
    if (btn.name == 'down' || btn.name == 'up') {
        opinionWindow.open(btn.text + "意见", btn);
    } else {
        Ext.MessageBox.show({
            title: "提示",
            msg: "确认" + btn.text + "选中记录？",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (buttonId) {
                if (buttonId === 'ok') {
                    doWorkFlowPost(btn, '');
                } else {
                    btn.setDisabled(false);
                }
            }
        });
    }

}

/**
 * post方式提交工作流
 */
function doWorkFlowPost(btn, auditInfo) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    var zcdIds = new Array();
    for (var i in records) {
        zcdIds.push(records[i].get("ZCD_ID"));
    }
    $.post("/zqgl/bmzc/doWorkFlow.action", {
        ZCD_IDS: zcdIds,
        BUTTON_NAME: btn.name,
        BUTTON_TEXT: btn.text,
        WF_ID: wf_id,
        NODE_CODE: node_code,
        AUDIT_INFO: auditInfo
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: btn.text + "成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        btn.setDisabled(false);
    }, "json");
}

/**
 * 刷新主表格
 */
function reloadGrid() {
    var zqlbId = Ext.ComponentQuery.query("treecombobox[name='ZQLB_ID']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('contentGrid').getStore();
    store.getProxy().extraParams = {
        ZQLB_ID: zqlbId,
        MHCX: mhcx,
        WF_ID: wf_id,
        NODE_CODE: node_code,
        WF_STATUS: wf_status
    };
    store.loadPage(1);
}

/**
 * 操作记录
 */
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录');
        return;
    } else {
        var zcdId = records[0].get("ZCD_ID");
        fuc_getWorkFlowLog(zcdId);
    }
}