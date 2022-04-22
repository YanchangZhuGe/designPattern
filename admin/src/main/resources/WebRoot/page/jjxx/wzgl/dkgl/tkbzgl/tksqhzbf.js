/**
 * 通用json配置
 */
var hzbf_json_common = {
    items:{
        '001' :[
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid('wbfcontentGrid');
                }
            }, {
                xtype: 'button',
                text: '汇总拨付',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('wbfcontentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return false;
                    }
                    // var record = records[0].getData();
                    //弹出窗口
                    for(var k=0;k<records.length;k++){
                        var var$BF_AMT=records[k].get("BF_AMT");
                        if(var$BF_AMT==null||var$BF_AMT==undefined||var$BF_AMT==""||var$BF_AMT < 0){
                            Ext.Msg.alert('提示', '批准金额不能为空！');
                            return false;
                        }
                    }
                    initWindow_hzbf(records);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord('wbfcontentGrid');
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()],
        '002':[
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var grid_bfpc = Ext.ComponentQuery.query('combobox[name="grid_bfpc"]')[0].value;
                    DSYGrid.getGrid('bfcontentGrid').getStore().getProxy().extraParams['BFPC_ID'] = grid_bfpc;
                    reloadGrid('bfcontentGrid');
                }
            },
            {
                xtype: 'button',
                text: '撤销拨付',
                icon: '/image/sysbutton/undosum.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('bfcontentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    for(var k=0;k<records.length;k++){
                        var var$IS_HLDJ=records[k].get("IS_HLDJ");
                        if(var$IS_HLDJ==1){
                            Ext.Msg.alert('提示', '拨付汇率已登记，无法撤销！');
                            return false;
                        }
                    }
                    Ext.Msg.confirm('提示', '请确认是否撤销拨付！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            commitBf(records,btn);
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord('bfcontentGrid');
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
 * 操作记录
 */
function operationRecord(gridName) {
    var records = DSYGrid.getGrid(gridName).getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("BIZ_ID"));
    }
}
/**
 * 初始化
 */
$(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
});
/*刷新界面*/
function reloadGrid(grid_id) {
    var grid = DSYGrid.getGrid(grid_id);
    var store = grid.getStore();
    store.removeAll();
    //刷新
    store.loadPage(1);
    if(grid_id=='wbfcontentGrid'){
        //刷新明细表
        DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
    }else{
        //刷新明细表
        DSYGrid.getGrid('detail_contentGrid').getStore().removeAll();
    }
}
/**
 * 初始化页面
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
        border:false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: hzbf_json_common.items[WF_STATUS]
            }
        ],
        items:initContentGridHZ()
    });
}
/**
 *初始化主界面
 */
function initContentGridHZ() {
    return Ext.create('Ext.tab.Panel', {
        name: 'HzTabPanel',
        layout: 'fit',
        flex: 1,
        border: false,
        defaults: {
            layout: 'fit',
            border: false
        },
        items: [
            {title: '未拨付', opstatus: 0, items:[initContentRightPanel()]},
            {title: '已拨付', opstatus: 1, layout: 'vbox', items: [initContentBFGrid(),initContentGrid_detail()]}
],
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                toolbar.removeAll();
                if (newCard.opstatus == '0') {
                    WF_STATUS = '001';
                    reloadGrid('wbfcontentGrid');
                } else if (newCard.opstatus == '1') {
                    WF_STATUS = '002';
                    reloadGrid('bfcontentGrid');
                }
                toolbar.add(hzbf_json_common.items[WF_STATUS]);
            }
        }
    });
}
/**
 * 初始化明细表格
 */
function initContentDetilGrid(callback) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "单位名称",
            dataIndex: "AG_NAME",
            type: "string",
            width: 110,
            editor: 'textfield'
        },

        {
            dataIndex: "SJXM_NAME",
            type: "string",
            text: "项目名称",
            width: 250,
            editor: 'textfield',
            renderer: function (data, cell, record) {
                var url='/page/debt/common/xmyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                paramNames[1]="IS_RZXM";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            text: "付款日期",
            dataIndex: "PAY_DATE",
            type: "string",
            width: 110,
            editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            dataIndex: "WZZCLX_NAME",
            type: "string",
            text: "支付类别",
            width: 250,
            editor: 'textfield'
        },
        {
            dataIndex: "PAY_AMT",
            type: "float",
            text: "支付金额(万元)",
            width: 180,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
        },
        {
            dataIndex: "SQS_NO",
            type: "string",
            text: "申请书编号",
            width: 250,
            editor: 'textfield'
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            width: 250,
            editor: 'textfield'
        }
    ];
    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getTkbfDetailGrid.action',
        params: {
            DATA_TYPE: DATA_TYPE,
            BIZ_ID:BIZ_ID
        },
        flex: 1,
        autoLoad: false,
        border: false,
        height: '50%',
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = simplyGrid.create(config);
    if (callback) {
        callback(grid);
    }
    return grid;
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
        itemId: 'initContentGrid',
        items: [
            initContentGrid(),
            initContentDetilGrid()
        ]
    });
}

/**
 * 未拨付页面主表格
 */
function initContentGrid() {
    //表格标题
    var HeaderJson_hzbf=[
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "数据类型",
            dataIndex: "DATA_TYPE",
            type: "int",
            width: 110,
            hidden:true
        },
        {
            text: "业务id",
            dataIndex: "BIZ_ID",
            type: "string",
            width: 110,
            hidden:true
        },
        {
            text: "地区",
            dataIndex: "AD_NAME",
            type: "string",
            width: 110
            // editor: 'textfield'
        },
        {
            text: "单位",
            dataIndex: "AG_NAME",
            type: "string",
            width: 110
            // editor: 'textfield'
        },
        {
            dataIndex: "WZXY_NAME",
            type: "string",
            text: "外债名称",
            width: 200
            // editor: 'textfield'
        },
        {
            dataIndex: "SJXM_NAME",
            type: "string",
            text: "项目名称",
            width: 200
            // editor: 'textfield'
        },
        {
            text: '债务类型',
            dataIndex: 'XMFL',
            type: "string",
            renderer: function (value) {
                var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                return result != null ? result.get('name') : value;
            }
        },
        {
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "申请金额(元)",
            width: 180,
            align: 'right',
            // renderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            dataIndex: "BF_AMT",
            type: "float",
            text: "批准金额(元)",
            width: 180,
            editor:{
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowDecimals: true,
                decimalPrecision: 2,
                minValue: 0,
                allowBlank: false,
            },
            tdCls: 'grid-cell',
            align: 'right',
            // renderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "申请日期",
            dataIndex: "SQ_DATE",
            type: "string",
            width: 110
            // editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            dataIndex: "SQFM_NAME",
            type: "string",
            text: "申请支付币种",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "ZH_NAME",
            type: "string",
            text: "收款人",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "ZH_BANK",
            type: "string",
            text: "开户银行",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "ACCOUNT",
            type: "string",
            text: "账号",
            width: 150
            // editor: 'textfield'
        }
    ]
    return DSYGrid.createGrid({
        itemId: 'wbfcontentGrid',
        headerConfig: {
            headerJson: HeaderJson_hzbf,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: true,
        border:false,
        height: '100%',
        checkBox: true,
        params: {
            IS_BF: 0
        },
        dataUrl:"getTkhzbfDataGrid.action",
        pageConfig: {
            pageNum: true,//设置显示每页条数}
        },
        plugins: {
            ptype: 'cellediting',
            clicksToEdit: 1,
            clicksToMoveEditor: 1,
        },
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['DATA_TYPE'] = record.get('DATA_TYPE');
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['BIZ_ID'] = record.get('BIZ_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().load();
            },
            edit:function (editor,context) {
                if (context.field == 'BF_AMT') {
                    var SQTK_AMT = context.record.get('SQTK_AMT');
                    if (context.value > SQTK_AMT) {
                        Ext.toast({
                            html:  "批准金额不能大于申请金额" ,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        context.record.set('BF_AMT', 0);
                    }
                }
            }
        }
    })
}
/**
 * 弹出汇总拨付界面
 */
function initWindow_hzbf(records) {
    Ext.create('Ext.window.Window', {
        itemId: 'window_bfpc', // 窗口标识
        title: '拨付批次', // 窗口标题
        // width: document.body.clientWidth * 0.9, //自适应窗口宽度
        // height: document.body.clientWidth * 0.45, //自适应窗口高度
        width: 300, //自适应窗口宽度
        height: 150, //自适应窗口高度
        // layout: 'hbox',
        layout: {
            type: 'hbox',
            padding: '10',
            align: 'middle'
        },
        y: document.body.clientHeight * 0.3,
        buttonAlign: 'center', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        // autoLoad: false,
        // border:false,
        // items: [initContentTCGrid()],
        items:[
            {
                    xtype: 'combobox',
                    fieldLabel: '<span class="required">✶</span>拨付批次',
                    labelWidth:80,
                    name: 'bfpc',
                    editable: false,
                    width: 250,
                    allowBlank: false,
                    //displayField:'name',
                    displayField: 'text',
                    valueField: 'id',
                    store: DebtEleTreeStoreDB("DEBT_BFPC")
                }
        ],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    commitBf(records,btn);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}

function commitBf(records,btn) {
    var btn_text=btn.text;
    var grid_id;
    var param = {};
    var list=new Array();
    if(btn_text=='撤销拨付'){
        //debugger;
        Ext.Msg.confirm('提示', '请确认是否撤销拨付！', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                grid_id = 'bfcontentGrid';
                for (var k = 0; k < records.length; k++) {
                    var array = {};
                    array.id = records[k].get("BIZ_ID");
                    array.DATA_TYPE = records[k].get("DATA_TYPE");
                    // array.BFPC_ID=records[k].get("BFPC_ID");
                    list.push(array);
                }
                param.bfDataArray = Ext.util.JSON.encode(list);
                param.btn_text = btn_text;
                doWorkForHzbf(param,btn_text,grid_id);
            }
        });
    }else{
        grid_id = 'wbfcontentGrid';
        btn_text = '拨付';
        for(var k=0;k<records.length;k++){
            var array = {};
            array.id=records[k].get("BIZ_ID");
            array.DATA_TYPE=records[k].get("DATA_TYPE");
            array.BF_AMT=records[k].get("BF_AMT");
            list.push(array);
        }
        var bfpc = Ext.ComponentQuery.query('combobox[name="bfpc"]')[0].getValue();
        param.bfDataArray=Ext.util.JSON.encode(list);
        param.bfpc=bfpc;
        param.btn_text = btn_text;
        btn.up('window').close();
        doWorkForHzbf(param,btn_text,grid_id);
    }

}

function doWorkForHzbf(param,btn_text,grid_id) {
    $.post("doWorkForHzbf.action",param, function (data_response) {
        data_response = $.parseJSON(data_response);
        if (data_response.success) {
            Ext.toast({
                html:  btn_text+"成功！" ,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid(grid_id);
        } else {
            Ext.toast({
                html:btn_text+ "失败！" + data_response.message,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
    });
}

/**
 * 拨付页面主表格
 */
function initContentBFGrid() {
    //表格标题
    var HeaderJson_BF=[
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "数据类型",
            dataIndex: "DATA_TYPE",
            type: "int",
            width: 110,
            hidden:true
        },
        {
            text: "业务id",
            dataIndex: "BIZ_ID",
            type: "string",
            width: 110,
            hidden:true
        },
        {
            text: "是否汇率登记",
            dataIndex: "IS_HLDJ",
            type: "int",
            width: 110,
            hidden:true
        },
        {
            text: "拨付批次",
            dataIndex: "BFPC_NAME",
            type: "string",
            width: 110
            // editor: 'textfield'
        },
        {
            text: "地区",
            dataIndex: "AD_NAME",
            type: "string",
            width: 110
            // editor: 'textfield'
        },
        {
            text: "单位",
            dataIndex: "AG_NAME",
            type: "string",
            width: 110
            // editor: 'textfield'
        },
        {
            dataIndex: "WZXY_NAME",
            type: "string",
            text: "外债名称",
            width: 200
            // editor: 'textfield'
        },
        {
            dataIndex: "SJXM_NAME",
            type: "string",
            text: "项目名称",
            width: 200
            // editor: 'textfield'
        },
        {
            text: '债务类型',
            dataIndex: 'XMFL',
            type: "string",
            renderer: function (value) {
                var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                return result != null ? result.get('name') : value;
            }
        },
        {
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "申请金额(万元)",
            width: 180,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
        },
        {
            dataIndex: "BF_AMT",
            type: "float",
            text: "批准金额(万元)",
            width: 180,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
        },
        {
            text: "申请日期",
            dataIndex: "SQ_DATE",
            type: "string",
            width: 110
            // editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            dataIndex: "SQFM_NAME",
            type: "string",
            text: "申请支付币种",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "ZH_NAME",
            type: "string",
            text: "收款人",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "ZH_BANK",
            type: "string",
            text: "开户银行",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "ACCOUNT",
            type: "string",
            text: "账号",
            width: 150
            // editor: 'textfield'
        }
    ]
    return DSYGrid.createGrid({
        itemId: 'bfcontentGrid',
        headerConfig: {
            headerJson: HeaderJson_BF,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: true,
        border:false,
        width: '100%',
        checkBox: true,
        pageConfig: {
            pageNum: true,//设置显示每页条数}
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '拨付批次',
                labelWidth:80,
                name: 'grid_bfpc',
                width: 250,
                allowBlank: true,
                displayField: 'text',
                valueField: 'id',
                store: DebtEleTreeStoreDB("DEBT_BFPC")
            }
        ],
        params:{
            IS_BF:1
        },
        // dataUrl:"getBfpcHz.action",
        dataUrl:"getTkhzbfDataGrid.action",
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('detail_contentGrid').getStore().getProxy().extraParams['DATA_TYPE'] = record.get('DATA_TYPE');
                DSYGrid.getGrid('detail_contentGrid').getStore().getProxy().extraParams['BIZ_ID'] = record.get('BIZ_ID');
                DSYGrid.getGrid('detail_contentGrid').getStore().load();
            }
        }
    })
}
/**
 * 拨付页面明细表格
 */
function initContentGrid_detail() {
    //表格标题
    var HeaderJson_detail = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "单位名称",
            dataIndex: "AG_NAME",
            type: "string",
            width: 110,
            editor: 'textfield'
        },

        {
            dataIndex: "SJXM_NAME",
            type: "string",
            text: "项目名称",
            width: 250,
            editor: 'textfield',
            renderer: function (data, cell, record) {
                var url='/page/debt/common/xmyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                paramNames[1]="IS_RZXM";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            text: "付款日期",
            dataIndex: "PAY_DATE",
            type: "string",
            width: 110,
            editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            dataIndex: "WZZCLX_NAME",
            type: "string",
            text: "支付类别",
            width: 250,
            editor: 'textfield'
        },
        {
            dataIndex: "PAY_AMT",
            type: "float",
            text: "支付金额(万元)",
            width: 180,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
        },
        {
            dataIndex: "SQS_NO",
            type: "string",
            text: "申请书编号",
            width: 250,
            editor: 'textfield'
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            width: 250,
            editor: 'textfield'
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'detail_contentGrid',
        headerConfig: {
            headerJson: HeaderJson_detail,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: false,
        border:false,
        width: '100%',
        checkBox: false,
        features: [{
            ftype: 'summary'
        }],
        params: {
            DATA_TYPE: DATA_TYPE,
            BIZ_ID:BIZ_ID
        },
        pageConfig: {
            enablePage: false
        },
        // params: {
        //     BFPC_NO:BFPC_NO,
        //     IS_BF: 1
        // },
        // dataUrl:"getTkhzbfDataGrid.action"
        dataUrl: 'getTkbfDetailGrid.action'
    })
}



