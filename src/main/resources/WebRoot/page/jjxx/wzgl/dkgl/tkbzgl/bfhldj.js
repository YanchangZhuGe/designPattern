
var hldj_json_common = {
    items:{
        '001' :[
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            }, {
                xtype: 'button',
                text: '汇率登记',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return false;
                    }
                    initWindow_hzbf();
                    var sum1 = 0;
                    // var sum2 = 0;
                    for(var k=0;k<records.length;k++){
                        if(records[k].get("SQFM_ID")!="CNY"){
                            records[k].data.BF_HL = 1;
                            records[k].data.ZH_AMT = records[k].get("BF_AMT");
                            records[k].data.isReadonly = 1;
                        }
                        sum1 += records[k].get("ZH_AMT");
                        // sum2 += records[k].get("BF_AMT");
                    }
                    sum1 = Ext.util.Format.number(sum1, '0,000.00');
                    // sum2 = Ext.util.Format.number(sum2, '0,000.00');
                    Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].setValue(sum1);
                    // Ext.ComponentQuery.query('displayfield#je_sum')[0].setValue(sum2);
                    var store = DSYGrid.getGrid('hzbfcontentGrid').getStore();
                    store.setRecords(records);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
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
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销登记',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否撤销登记！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            commitHldj(records,btn);
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
                    operationRecord();
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
function operationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("BIZ_ID"));
    }
}
/*刷新界面*/
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    //刷新
    BFPC = Ext.ComponentQuery.query('combobox[name="hldj_bfpc"]')[0].getValue();
    DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams['BFPC'] = BFPC;
    store.loadPage(1);
};
// var json_debt_zt2 = [
//     {id: "001", code: "001", name: "未登记"},
//     {id: "002", code: "002", name: "已登记"},
// ];

// var bfpc=[
//     {id: "1", code: "01", text: "第1批"},
//     {id: "2", code: "02", text: "第2批"},
//     {id: "3", code: "03", text: "第3批"},
//     {id: "4", code: "04", text: "第4批"},
//     {id: "5", code: "05", text: "第5批"}
// ];
/**
 * 初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
});
/**
 * 初始化页面区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        height: '100%',
        renderTo: 'contentPanel',
        border:false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: hldj_json_common.items[WF_STATUS]
            }
        ],
        items:initContentRightPanel()
    });
}
/**
 * 初始化右侧Panel放置一个表格
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
        items:initContentGrid()
    });
}
/**
 * 初始化主表格
 */
function initContentGrid() {
    //表格标题
    var HeaderJson_hzbf=[
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        // {
        //     dataIndex:"SQ_DATE",
        //     type:"string",
        //     text:"申请日期",
        //
        // },
        // {
        //     dataIndex:"XM_NAME",
        //     type:"string",
        //     text:"项目名称",
        //
        // },
        // {
        //     dataIndex:"SQ_UNIT",
        //     type:"string",
        //     text:"申请单位",
        //
        // },
        // {
        //     dataIndex:"CURRENCY",
        //     type:"string",
        //     text:"支付币种",
        //
        // },
        // {
        //     dataIndex:"TYPE",
        //     type:"string",
        //     text:"支付类别",
        //
        // },
        // {
        //     dataIndex:"SQ_MONEY",
        //     type:"float",
        //     text:"申请金额",
        //
        // },
        // {
        //     dataIndex:"PZ_MONEY",
        //     type:"float",
        //     text:"批准金额",
        //
        // },
        // {
        //     dataIndex:"NUMBER",
        //     type:"string",
        //     text:"申请书编号",
        //
        // },
        // {
        //     dataIndex:"PERSON",
        //     type:"string",
        //     text:"收款人",
        //
        // },
        // {
        //     dataIndex:"BANK",
        //     type:"string",
        //     text:"开户银行",
        //
        // },
        // {
        //     dataIndex:"COUNT",
        //     type:"string",
        //     text:"账号",
        //
        // },
        // {
        //     dataIndex:"MARK",
        //     type:"string",
        //     text:"备注",
        //
        // }
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
            text: "拨付批次",
            dataIndex: "BFPC_NAME",
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
            dataIndex: "XM_ID",
            type: "string",
            text: "项目id",
            width: 200,
            hidden:true
            // editor: 'textfield'
        },
        {
            dataIndex: "SJXM_NAME",
            type: "string",
            text: "项目名称",
            width: 200,
            renderer: function (data, cell, record) {
                if(record.get('DATA_TYPE')==2){
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }else{
                    return data;
                }
            }
            // editor: 'textfield'
        },
        {
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "申请金额(万元)",
            width: 180,
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: 0,
            //     allowBlank: false
            // },
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
            // summaryType: 'sum',
            // summaryRenderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // }
        },
        {
            dataIndex: "BF_AMT",
            type: "float",
            text: "批准金额(万元)",
            width: 180,
            // editor:'textfield',
            // editable:'true',//不可编辑
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: 0,
            //     allowBlank: false
            // },
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
            // summaryType: 'sum',
            // summaryRenderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // }
        },
        {
            dataIndex: "SQFM_NAME",
            type: "string",
            text: "申请支付币种",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "BF_HL",
            type: "float",
            text: "汇率",
            width: 150,
            renderer: function (value) {
                if(WF_STATUS=="001"){
                    value = 0;
                }
                return Ext.util.Format.number(value, '0,000.######');
            }
            // editor: {
            //     xtype: "numberfield",
            //     decimalPrecision:6,
            //     hideTrigger: true,
            //     mouseWheelEnabled: false,
            //     minValue: 0,
            //     allowBlank: false
            // }
        },
        {
            dataIndex: "ZH_AMT",
            type: "float",
            text: "折合原币(万元)",
            width: 180,
            editable: false,//禁用编辑
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: 0,
            //     allowBlank: false
            // },
            align: 'right',
            renderer: function (value) {
                if(WF_STATUS=="001"){
                    value = 0;
                }
                return Ext.util.Format.number(value/10000, '0,000.######');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                if(WF_STATUS=="001"){
                    value = 0;
                }
                return Ext.util.Format.number(value/10000, '0,000.######');
            }
        },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            width: 110,
            renderer: function (value) {
                if(WF_STATUS=="001"){
                    value = null;
                }
                return value;
            }
            // editor: {
            //     xtype: "datefield",
            //     allowBlank: false,
            //     format: 'Y-m-d',
            // },
            // renderer: function (value) {
            //     if(value != null && value != undefined && value !=''){
            //         return format(value, 'yyyy-MM-dd');
            //     }
            // }
        },
        {
            text: "申请日期",
            dataIndex: "SQ_DATE",
            type: "string",
            width: 110
            // editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            dataIndex: "SQFM_ID",
            type: "string",
            text: "申请支付币种id",
            width: 150,
            hidden:true
            // editor: 'textfield'
        },
        {
            dataIndex: "XY_FM_ID",
            type: "string",
            text: "协议币种",
            width: 150,
            hidden:true
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
        itemId: 'contentGrid',
        flex: 1,
        autoLoad: true,
        border:false,
        checkBox: true,
        height: '100%',
        tbar:[{
            xtype: "combobox",
            name: "WF_STATUS",
            store: DebtEleStore(json_debt_djzt2),
            displayField: "name",
            valueField: "id",
            value: WF_STATUS,
            fieldLabel: '状态',
            editable: false, //禁用编辑
            width: 150,
            labelWidth: 30,
            allowBlank: false,
            labelAlign: 'right',
            listeners: {
                change: function (self, newValue,btn) {
                    WF_STATUS = newValue;
                    var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                    toolbar.removeAll();
                    toolbar.add(hldj_json_common.items[WF_STATUS]);
                    var isHldj = 0;
                    if(WF_STATUS=="002"){
                        isHldj=1;
                    }
                    self.up('grid').getStore().getProxy().extraParams["IS_HLDJ"] = isHldj;
                    reloadGrid();
                }
            }
        },
            {
                xtype: 'combobox',
                name:"hldj_bfpc",
                fieldLabel: '拨付批次',
                labelWidth:60,
                width: 250,
                // allowBlank: false,
                displayField: 'text',
                valueField: 'id',
                store: DebtEleTreeStoreDB("DEBT_BFPC")
            }
        ],
        features: [{
            ftype: 'summary'
        }],
        params: {
            IS_HLDJ: 0,
            BFPC:BFPC
        },
        dataUrl:"getbfhldjDataGrid.action",
        // data:[{"SQ_DATE":"2017-12-17",
        //     "XM_NAME":"北京饭店",
        //     "SQ_UNIT":"大数元",
        //     "CURRENCY":"人民币",
        //     "TYPE":"刷卡",
        //     "RATE":"1",
        //     "BF_DATE":"2017-09-09",
        //     "ORIGINAL":"123456",
        //     "SQ_MONEY":"100000",
        //     "PZ_MONEY":"30000000",
        //     "NUMBER":"123321123",
        //     "PERSON":"bigger",
        //     "BANK":"招商银行",
        //     "COUNT":"bigger",
        //     "MARK":"备注",
        // },{"SQ_DATE":"2017-12-17",
        //     "XM_NAME":"北京饭店",
        //     "SQ_UNIT":"大数元",
        //     "CURRENCY":"人民币",
        //     "TYPE":"刷卡",
        //     "RATE":"1",
        //     "BF_DATE":"2017-09-09",
        //     "ORIGINAL":"123456",
        //     "SQ_MONEY":"100000",
        //     "PZ_MONEY":"30000000",
        //     "NUMBER":"123321123",
        //     "PERSON":"bigger",
        //     "BANK":"招商银行",
        //     "COUNT":"bigger",
        //     "MARK":"备注",
        // }],
        headerConfig: {
            headerJson: HeaderJson_hzbf,
            columnAutoWidth: false
        },
        pageConfig: {
            pageNum: true//设置显示每页条数}
        }

    })
}


function initWindow_hzbf() {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_hzbf', // 窗口标识
        title: '汇率登记', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientWidth * 0.45, //自适应窗口高度
        layout: 'hbox',
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        autoLoad: false,
        border:false,
        items: [initContentTCGrid()],
        tbar: [
            {
                xtype: 'displayfield',
                editable: false,
                name: 'rmb_je_sum',
                itemId: 'rmb_je_sum',
                value: 0,
                // fieldLabel: '人民币金额合计',
                fieldLabel: '折合原币合计',
                labelAlign: 'left',//控件默认标签对齐方式
                labelWidth: 90,
                allowDecimals: true,
                decimalPrecision: 2,
                keyNavEnabled: true,
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true
            }
            // {
            //     xtype: 'displayfield',
            //     editable: false,
            //     name: 'je_sum',
            //     itemId: 'je_sum',
            //     value: 0,
            //     // fieldLabel: '合计金额（折合人民币）',
            //     fieldLabel: '批准金额合计',
            //     labelAlign: 'left',//控件默认标签对齐方式
            //     labelWidth: 90
            // }
        ],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    // var records = DSYGrid.getGrid('hzbfcontentGrid').getSelection();
                    // if (records.length <= 0) {
                    //     Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                    //     return false;
                    // }
                    commitHldj("",btn);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    var gridStore=Ext.ComponentQuery.query('grid[itemId="hzbfcontentGrid"]')[0];
                    var grid_store=gridStore.getStore();
                    for(var i=0;i<grid_store.getCount();i++) {
                        var record = grid_store.getAt(i);
                        record.data.BF_HL = 0;
                        record.data.ZH_AMT = 0;
                        record.data.BF_DATE = null;
                    }
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}
function commitHldj(records,btn) {
    var btn_text=btn.text;
    var param = {};
    var list=new Array();
    if(btn_text=='撤销登记'){
        for(var k=0;k<records.length;k++){
            var array = {};
            array.DATA_TYPE=records[k].get("DATA_TYPE");
            array.BIZ_ID=records[k].get("BIZ_ID");
            list.push(array);
        }
        param.hldjDataArray=Ext.util.JSON.encode(list);
        param.btn_text = btn_text;
    }else{
        btn_text = '登记';
        //获取grid
        var gridStore=Ext.ComponentQuery.query('grid[itemId="hzbfcontentGrid"]')[0];
        var store_data=new Array();
        var grid_store=gridStore.getStore();
        for(var i=0;i<grid_store.getCount();i++){
            var array = {};
            var record=grid_store.getAt(i);
            var BF_HL = record.get("BF_HL");
            var BF_DATE = record.get("BF_DATE");
            if(!(BF_HL != null && BF_HL!=undefined && BF_HL!="")){
                Ext.Msg.alert('提示', '拨付汇率不能为空！');
                return false;
            }
            if(!(BF_DATE != null && BF_DATE!=undefined && BF_DATE!="")){
                Ext.Msg.alert('提示', '拨付日期不能为空！');
                return false;
            }
            array.BIZ_ID=record.get("BIZ_ID");
            array.DATA_TYPE=record.get("DATA_TYPE");
            array.BF_DATE=(record.get("BF_DATE")==null||record.get("BF_DATE")=="")? "": format(record.get("BF_DATE"), 'yyyy-MM-dd');
            array.BF_HL=record.get("BF_HL");
            array.ZH_AMT=record.get("ZH_AMT");
            list.push(array);
        }
        // for(var k=0;k<records.length;k++){
        //     var array = {};
        //     array.BIZ_ID=records[k].get("BIZ_ID");
        //     array.DATA_TYPE=records[k].get("DATA_TYPE");
        //     array.BF_DATE=(records[k].get("BF_DATE")==null||records[k].get("BF_DATE")=="")? "": format(records[k].get("BF_DATE"), 'yyyy-MM-dd'),
        //     array.BF_HL=records[k].get("BF_HL");
        //     list.push(array);
        // }
        param.hldjDataArray=Ext.util.JSON.encode(list);
        param.btn_text = btn_text;
        btn.up('window').close();
    }
    doWorkForHldj(param,btn_text);
}
function doWorkForHldj(param,btn_text) {
    $.post("doWorkForHldj.action",param, function (data_response) {
        data_response = $.parseJSON(data_response);
        if (data_response.success) {
            Ext.toast({
                html:  btn_text+"成功！" ,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
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
function initContentTCGrid() {
    //表格标题
    var HeaderJson_hzbf=[
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        // {
        //     dataIndex:"SQ_DATE",
        //     type:"string",
        //     text:"申请日期",
        //
        // },
        // {
        //     dataIndex:"XM_NAME",
        //     type:"string",
        //     text:"项目名称",
        //
        // },
        // {
        //     dataIndex:"SQ_UNIT",
        //     type:"string",
        //     text:"申请单位",
        //
        // },
        // {
        //     dataIndex:"CURRENCY",
        //     type:"string",
        //     text:"支付币种",
        //
        // },
        // {
        //     dataIndex:"TYPE",
        //     type:"string",
        //     text:"支付类别",
        //
        // },
        // {
        //     dataIndex:"SQ_MONEY",
        //     type:"float",
        //     text:"申请金额",
        //
        // },
        // {
        //     dataIndex:"PZ_MONEY",
        //     type:"float",
        //     text:"批准金额",
        //
        // },
        // {
        //     dataIndex:"BF_DATE",
        //     type:"string",
        //     text:"拨付日期",
        //     editor:'textfield'
        // },
        // {
        //     dataIndex:"ORIGINAL",
        //     type:"float",
        //     text:"折合原币",
        //     editor:'textfield'
        // },
        // {
        //     dataIndex:"RATE",
        //     type:"float",
        //     text:"汇率",
        //     editor:'textfield'
        // },
        // {
        //     dataIndex:"NUMBER",
        //     type:"string",
        //     text:"申请书编号",
        //
        // },
        // {
        //     dataIndex:"PERSON",
        //     type:"string",
        //     text:"收款人",
        //
        // },
        // {
        //     dataIndex:"BANK",
        //     type:"string",
        //     text:"开户银行",
        //
        // },
        // {
        //     dataIndex:"COUNT",
        //     type:"string",
        //     text:"账号",
        //
        // },
        // {
        //     dataIndex:"MARK",
        //     type:"string",
        //     text:"备注",
        //
        // }
        {
            text: "数据类型",
            dataIndex: "DATA_TYPE",
            type: "int",
            width: 110,
            hidden:true
        },
        {
            text: "控制标识",
            dataIndex: "isReadonly",
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
            text: "拨付批次",
            dataIndex: "BFPC_NAME",
            type: "string",
            width: 110
            // editor: 'textfield'
        },
        {
            dataIndex: "SQFM_NAME",
            type: "string",
            text: "申请支付币种",
            width: 150
            // editor: 'textfield'
        },
        {
            dataIndex: "BF_HL",
            type: "float",
            text: "汇率",
            width: 150,
            format :'0,000.000000',
            editor: {
                xtype: "numberfield",
                decimalPrecision:7,
                regex: /^\d+(\.[0-9]{1,6})?$/,
                hideTrigger: true,
                mouseWheelEnabled: false,
                minValue: 0,
                allowBlank: false
            },
            renderer: function (value, cell) {
                value = Ext.util.Format.number(value,'0,000.000000');
                return value;
            }
            // renderer: function (value) {
            //     if(value == 1){
            //         debugger;
            //     }
            // }
        },

        {
            dataIndex: "ZH_AMT",
            type: "float",
            text: "折合原币(元)",
            width: 180,
            editable: false,//禁用编辑
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            align: 'right',
            // renderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // },
            summaryType: 'sum'

            // summaryRenderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // }
        },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            width: 110,
            editor: {
                xtype: "datefield",
                allowBlank: false,
                format: 'Y-m-d',
            },
            renderer: function (value) {
                if(value != null && value != undefined && value !=''){
                    return format(value, 'yyyy-MM-dd');
                }
            }
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
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "申请金额(元)",
            width: 180,
            align: 'right',
            // renderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // },
            summaryType: 'sum'
            // summaryRenderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // }
        },
        {
            dataIndex: "BF_AMT",
            type: "float",
            text: "批准金额(元)",
            width: 180,
            // editor:'textfield',
            align: 'right',
            // renderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // },
            summaryType: 'sum'
            // summaryRenderer: function (value) {
            //     return Ext.util.Format.number(value/10000, '0,000.######');
            // }
        },

        {
            text: "申请日期",
            dataIndex: "SQ_DATE",
            type: "string",
            width: 110
            // editor: {xtype: 'datefield', format: 'Y-m-d'}
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
    ];
    return DSYGrid.createGrid({
        itemId: 'hzbfcontentGrid',
        headerConfig: {
            headerJson: HeaderJson_hzbf,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: false,
        border:false,
        height: '100%',
        // checkBox: true,
        pageConfig: {
            enablePage: false
        },
        plugins: {
            ptype: 'cellediting',
            clicksToEdit: 1,
            clicksToMoveEditor: 1
        },
        listeners: {
            // selectionchange: function (view, records) {
            //     var sum1 = 0;
            //     var sum2 = 0;
            //     for (var i in records) {
            //         sum1 += records[i].get("SQTK_AMT");
            //         sum2 += records[i].get("BF_AMT");
            //     }
            //     sum1 = Ext.util.Format.number(sum1, '0,000.00');
            //     sum2 = Ext.util.Format.number(sum2, '0,000.00');
            //     Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].setValue(sum1);
            //     Ext.ComponentQuery.query('displayfield#je_sum')[0].setValue(sum2);
            // },
            beforeedit: function (editor, context, eOpts) {
                var BF_HL = context.record.get('BF_HL');
                var isReadonly = context.record.get('isReadonly');
                if (context.field == 'BF_HL'){
                    if(context.value==1 && isReadonly==1){
                        return false;
                    }
                }
                if (context.field == 'ZH_AMT'){
                    if(BF_HL==1 && isReadonly==1){
                        return false;
                    }
                }
            },
            edit:function (editor,context) {
                if (context.field == 'BF_HL') {
                    var BF_AMT = context.record.get("BF_AMT");
                    var oleZh = context.record.get("ZH_AMT");
                    if (BF_AMT != null && BF_AMT != undefined && BF_AMT >= 0 && context.value != null && context.value != undefined && context.value>=0) {
                        var newZh;
                        if(context.value==0){
                            newZh=0;
                        }else{
                            newZh = parseFloat(BF_AMT / context.value).toFixed(2);
                        }
                        context.record.set("ZH_AMT",newZh );
                        var oldSum = Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].getValue();
                        oldSum=oldSum.replace(/,/gi,'');
                        var newSum = parseFloat(oldSum)-parseFloat(oleZh)+parseFloat(newZh);
                        Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].setValue(Ext.util.Format.number(Math.round(newSum * 100) / 100, '0,000.######'));
                    }
                }
                if (context.field == 'ZH_AMT') {
                    var oldValue = context.originalValue;
                    var newValue = context.value;
                    var oldSum = Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].getValue();
                    oldSum=oldSum.replace(/,/gi,'');
                    var newSum = parseFloat(oldSum)-parseFloat(oldValue)+parseFloat(newValue);
                    Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].setValue(Ext.util.Format.number(Math.round(newSum * 100) / 100, '0,000.######'));
                    // var BF_AMT = context.record.get("BF_AMT");
                    // if (BF_AMT != null && BF_AMT != undefined && BF_AMT >= 0 && context.value != null && context.value != undefined && context.value>0) {
                    //     context.record.set("ZH_AMT", parseFloat(BF_AMT / context.value).toFixed(2));
                    // }
                }
                // listeners: {
                //     'change': function (self, newValue, oldValue) {
                //         debugger;
                //         var oldSum = Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].getValue();
                //         Ext.ComponentQuery.query('displayfield#rmb_je_sum')[0].setValue(oldSum-oldValue+newValue);
                //     }
                // }

            }
        }
    })
}
