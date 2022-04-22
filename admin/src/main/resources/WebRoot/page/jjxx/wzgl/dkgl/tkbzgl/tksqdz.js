/**
 * 页面初始化
 */
$(function () {
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
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        height: '100%',
        renderTo: 'contentPanel',
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: tksq_json_common.items[WF_STATUS]
            }
        ],
        items: [
            initContentGrid()
        ]
    });
}
/**
 * 初始化主表格
 */
function initContentGrid() {
    var HeaderJson_hzbf=[
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "SQ_DATE",
            type: "string",
            width: 130,
            text:"申请日期",

        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            width: 130,
            text:"项目名称",

        },
        {
            dataIndex: "SQ_DW",
            type: "string",
            width: 130,
            text:"申请单位",

        },
        {
            dataIndex: "ZF_NO",
            type: "string",
            width: 130,
            text:"支付币种",

        },
        {
            dataIndex: "ZF_LB",
            type: "string",
            width: 130,
            text:"支付类别",

        },
        {
            dataIndex: "SQ_AMT",
            type: "float",
            width: 130,
            text:"申请金额",

        },
        {
            dataIndex: "PZ_AMT",
            type: "float",
            width: 130,
            text:"批准金额"
        },
        {
            dataIndex: "PZ_AMT",
            type: "string",
            width: 130,
            text:"申请书编号",

        },
        {
            dataIndex: "SKR",
            type: "string",
            width: 130,
            text:"收款人",

        },
        {
            dataIndex: "KHH",
            type: "string",
            width: 130,
            text:"开户银行",

        },
        {
            dataIndex: "ZH_NO",
            type: "string",
            width: 130,
            text:"账号",

        },
        {
            dataIndex: "REMARK",
            type: "string",
            width: 130,
            text:"备注",

        }
    ]
    return DSYGrid.createGrid({
        itemId: 'tksqcontentGrid',
        headerConfig: {
            headerJson: HeaderJson_hzbf,
            columnAutoWidth: false
        },
        flex: 1,
        checkBox: true,
        params: {
            WF_STATUS: WF_STATUS,
            SET_YEAR: ''
        },
        border: false,
        autoLoad: false,
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: tksq_json_common.store['WF_STATUS'],
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                editable: false, //禁用编辑
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(tksq_json_common.items[WF_STATUS]);
                        reloadGrid();
                    }
                },
            }
        ],
        tbarHeight: 50,
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }],
        data:[
            {"SQ_DATE":"1","XM_NAME":"1","SQ_DW":"单位1","ZF_NO":"1","ZF_LB":"设备","SQ_AMT":"12","PZ_AMT":"120","SKR":"ww","KHH":"北京银行","ZH_NO":"123","REMARK":"1"}
        ],
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                //DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
                //DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}
/**
 * 通用配置json
 */
var tksq_json_common = {
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
                text: '确认',
                name: 'down',
                icon: '/image/sysbutton/confirm.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('tksqcontentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    Ext.toast({
                        html:  "确认成功！" ,
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });

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
                text: '撤销确认',
                name: 'up',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('tksqcontentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    Ext.toast({
                        html:  "撤销成功！" ,
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });


                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    store: {
        WF_STATUS: DebtEleStore(json_debt_zt11)
    }
};
/**
 * 刷新content主表格
 */
function reloadGrid() {
    var store = DSYGrid.getGrid('tksqcontentGrid').getStore();
    //增加查询参数
    store.loadPage(1);
}