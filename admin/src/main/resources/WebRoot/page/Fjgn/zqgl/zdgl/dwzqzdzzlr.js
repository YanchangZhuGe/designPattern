//创建转贷信息选择弹出窗口
var window_zzlrselect = {
    window: null,
    show: function (params) {
        this.window = initWindow_zzlrselect(params);
        this.window.show();
    }
};
//创建转贷信息填报弹出窗口
var window_zzlrinput = {
    window: null,
    zq_code: null,
    HZ_ID:'',
    show: function () {
        this.window = initWindow_zzlrinput();
        this.window.show();
    }
};
var zdMap = new Map();
/**
 * 初始化第一个弹窗主债券选择弹出窗口
 */
function initWindow_zzlrselect(params) {
    return Ext.create('Ext.window.Window', {
        title: '主债券选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_zzlrselect_grid(params)],//, initWindow_select_grid_dtl()
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
                    var record = records[0].getData();
                    DF_START_DATE_TEMP=record.DF_START_DATE;
                    DF_END_DATE_TEMP=record.DF_END_DATE;
                    //弹出填报页面，并写入债券信息
                    var xzGUID =  GUID.createGUID();
                    window_zzlrinput.zq_code = record.ZQ_CODE;
                    window_zzlrinput.HZ_ID=xzGUID;
                    window_zzlrinput.show();
                    //var zq_name = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.ZQ_ID + '&AD_CODE=' + record.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + record.ZQ_NAME + '</a>';
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.ZQ_ID);
                    paramValues[1] = encodeURIComponent(record.AD_CODE.replace(/00$/, ""));
                    var zq_name = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + record.ZQ_NAME + '</a>';
                    record.ZQ_NAME = zq_name;
                    //初始化一个空行
                    // window_zzlrinput.window.down('grid#zqzd_grid2').insertData(null, {IS_QEHBFX: 1});
                    //对form赋值
                    window_zzlrinput.window.down('form').getForm().setValues(record);
                    if (IS_BZB == '1' && records[0].get('KZD_XZ') > 0) {
                        $.post("getDwZzlrFqdfXzzqZdje.action", {
                                ZQ_ID : encodeURIComponent(record.ZQ_ID),
                                ADID : encodeURIComponent(record.AD_CODE)
                            }, function(result) {
                                result = $.parseJSON(result);
                                if (result.success) {
                                    // 插入值
                                    zdMap.clear();
                                    for (var index in result.dataList) {
                                        console.log("index == >>" + index);
                                        window_zzlrinput.window.down('grid#zqzd_grid2').insertData(0, result.dataList[index]);
                                        // zdMap.put(result.dataList[index].AG_CODE,result.dataList[index]);
                                    }
                                } else {
                                    window_zzlrinput.window.down('grid#zqzd_grid2').insertData(null, {IS_QEHBFX: 1});
                                }
                            }
                        );
                    }

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
 * 初始化债券选择弹出框表格
 */
function initWindow_zzlrselect_grid(params) {
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {
            "dataIndex": "ZQ_ID",
            "type": "string",
            "text": "债券ID",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "ZQ_CODE",
            "type": "string",
            "text": "债券编码",
            "fontSize": "15px",
            "width": 120
        },
        {
            "dataIndex": "ZQ_NAME",
            "type": "string",
            "width": 300,
            "text": "债券名称",
            "hrefType": "combo",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE);
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            "dataIndex": "ZQQX_NAME",
            "width": 100,
            "type": "string",
            "text": "债券期限"
        },
        {
            "dataIndex": "ZQLB_NAME",
            "type": "string",
            "text": "债券类型",
            "fontSize": "15px",
            "width": 100
        },
        {
            "dataIndex": "ZQLB_ID",
            "type": "string",
            "text": "债券类型",
            "fontSize": "15px",
            "width": 100,
            "hidden": true
        },
        {
            "dataIndex": "DF_START_DATE",
            "type": "string",
            "text": "起息日",
            "fontSize": "15px",
            "width": 100,
            "hidden": true
        },
        {
            "dataIndex": "TQHK_DAYS",
            "type": "string",
            "text": "提前还款天数",
            "fontSize": "15px",
            "width": 100,
            "hidden": true
        },
        {
            "dataIndex": "ZNJ_RATE",
            "type": "string",
            "text": "滞纳金率",
            "fontSize": "15px",
            "width": 100,
            "hidden": true
        },
        {
            "dataIndex": "ZQJE", "text": "可转贷金额（元）",
            columns: [
                {
                    "dataIndex": "KZD_XZ",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "新增债券金额"
                },
                {
                    "dataIndex": "KZD_ZH",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "置换债券金额"
                },
                {
                    "dataIndex": "KZD_ZRZ",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "再融资债券金额"
                }
            ]
        },
        {
            "dataIndex": "YZD", "text": "债券金额（元）",
            columns: [
                {
                    "dataIndex": "ZXZ_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "新增债券金额"
                },
                {
                    "dataIndex": "ZZH_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "置换债券金额"
                },
                {
                    "dataIndex": "ZZRZ_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "再融资债券金额"
                }
            ]
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'grid_select',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        //checkBox: true,
        border: false,
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                xtype: "combobox",
                name: "SET_YEAR",
                store: DebtEleStore(json_debt_year),
                displayField: "name",
                valueField: "id",
                value: new Date().getFullYear(),
                fieldLabel: '债券发行年度',
                editable: false, //禁用编辑
                labelWidth: 100,
                width: 220,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                        self.up('grid').getStore().loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var keyValue = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].value;
                    btn.up('grid').getStore().getProxy().extraParams["SET_YEAR"] = keyValue;
                    btn.up('grid').getStore().loadPage(1);

                }
            }
        ],
        tbarHeight: 50,
        params: {
            SET_YEAR: new Date().getFullYear()
        },
        /*listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                var store = DSYGrid.getGrid('grid_select_dtl').getStore();
                store.getProxy().extraParams['ZQ_ID'] = record.get('ZQ_ID');
                store.load();
            }
        },*/
        dataUrl: 'getdwZzlrZqxxGridData.action'
    });
}
/**
 * 初始化债券转贷弹出窗口
 */
function initWindow_zzlrinput() {
    return Ext.create('Ext.window.Window', {
        title: '债券转贷', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initWindow_zzlrinput_contentForm(),
        buttons: [
            {
                xtype: 'hidden',//button
                text: '按计划生成',
                width: 80,
                handler: function (btn) {
                    var store = btn.up('window').down('grid').getStore();
                    if (store.getCount() > 0) {
                        Ext.Msg.confirm('提示', '此操作将会清空已录入数据，确认按计划生成？', function (btn_confirm) {
                            if (btn_confirm === 'yes') {
                                store.load({
                                    callback: function () {
                                        if (store.getCount() <= 0) {
                                            Ext.Msg.alert('提示', '未找到批次转贷计划，请手动添加！');
                                        }
                                    }
                                });
                            }
                        });
                    } else {
                        store.load({
                            callback: function () {
                                if (store.getCount() <= 0) {
                                    Ext.Msg.alert('提示', '未找到批次转贷计划，请手动添加！');
                                }
                            }
                        });
                    }
                }
            },
            new Ext.form.FormPanel({
                labelWidth: 70,
                fileUpload: true,
                items: [
                    /*{
                        xtype: 'filefield',
                        buttonText: '导入',
                        name: 'upload',
                        width: 140,
                        hidden: !(SYS_IS_QEHBFX == 0),
                        padding: '0 0 0 0',
                        margin: '0 0 0 0',
                        buttonOnly: true,
                        hideLabel: true,
                        buttonConfig: {
                            width: 140,
                            icon: '/image/sysbutton/report.png'
                        },
                        listeners: {
                            change: function (fb, v) {
                                var store = Ext.ComponentQuery.query('grid#zqzd_grid')[0].getStore();
                                store.removeAll();
                                var form = this.up('form').getForm();
                                uploadZdmxExcelFile(form);
                            }
                        }
                    }*/
                ]
            }),
            {
                xtype: 'button',
                text: '分期兑付自动拆分',
                hidden : IS_BZB == '1',
                width: 130,
                handler: function (btn) {
                    var form = btn.up('window').down('form'); // from表单金额
                    var zzqzdGrid = btn.up('window').down('grid#zzqzd_grid1'); // 主债券转贷金额
                    var zqzdGrid2 = btn.up('window').down('grid#zqzd_grid2'); // 主债券转贷金额
                    var zzqzdGridStore = zzqzdGrid.getStore();
                    var zqzdGridStore = zqzdGrid2.getStore();
                    if (zqzdGridStore.length <= 0) {
                        Ext.Msg.alert('提示', '请先录入主债券转贷信息！');
                        return false;
                    }
                    $.post("/getFqdfDwZqxx.action", {
                            ZQ_BILL_ID: form.down('textfield[name="ZQ_ID"]').getValue()
                        },
                        function (data_response) {
                            data_response = $.parseJSON(data_response);
                            if (data_response.length > 0) {

                                var records = [];
                                // 该单位转贷总金额 * 分期兑付债券比例 = 该笔子债券分期转贷金额
                                for (var i = 0; i < data_response.length; i++) {
                                    var data = data_response[i];
                                    var zd_id = GUID.createGUID();
                                    zzqzdGridStore.each(function (record) {
                                        var zqzdGridMap = {};
                                        zqzdGridMap.ZD_ID = zd_id;
                                        zqzdGridMap.ZQ_ID = data.ZQ_ID;
                                        zqzdGridMap.IS_QEHBFX = SYS_IS_QEHBFX;
                                        zqzdGridMap.QYJT_ID = record.get('QYJT_ID');
                                        zqzdGridMap.QX_DATE = data.QX_DATE;
                                        zqzdGridMap.ZD_AMT = data.FDQF_BL * record.get('XZ_AMT');
                                        zqzdGridMap.XZ_AMT = data.FDQF_BL * record.get('XZ_AMT');
                                        records.push(zqzdGridMap);
                                    });
                                }
                                zqzdGridStore.removeAll();
                                zqzdGrid2.insertData(null, records);
                                zdxxTab(1);
                            }
                        });
                }
            },
            {
                xtype: 'button',
                text: '添加',
                width: 60,
                handler: function (btn) {
                    btn.up('window').down('grid').insertData(null, {IS_QEHBFX: 1});
                }
            },
            {
                xtype: 'button',
                itemId: 'tzjhDelBtn',
                text: '删除',
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('window').down('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    // btn.setDisabled(true) ;  //防止点击两次按钮保存两天数据，按钮不可点击
                    //获取grid
                    var grid = btn.up('window').down('#zqzd_grid2');
                    var celledit = grid.getPlugin('zqzd_grid2_plugin_cell');
                    //完成编辑
                    celledit.completeEdit();
                    //先校验后保存
                    if (window.flag_zzqZd_validateedit && !window.flag_zzqZd_validateedit.isHidden()) {
                        return false;//如果校验未通过
                    }
                    var form = btn.up('window').down('form');
                    if (!checkGrid(form.down('#zqzd_grid2'))) {
                        Ext.Msg.alert('提示', grid_error_message);
                        //btn.setDisabled(false);
                        return false;
                    }
                    //获取单据明细数组
                    var recordArray = [];
                    var HZ_ID=form.getForm().findField("HZ_ID").getValue();//
                    HZ_ID=HZ_ID==""?GUID.createGUID():HZ_ID;
                    var ZQ_ID=form.getForm().findField("ZQ_ID").getValue();//债券id
                    var ZD_DATE=form.getForm().findField("ZD_DATE").getValue();//转贷日期
                    var QX_DATE =form.getForm().findField('START_DATE').getValue();//起息日
                    var TQHK_DAYS=form.getForm().findField("TQHK_DAYS").getValue();//提前还款天数
                    var ZQ_CODE=form.getForm().findField("ZQ_CODE").getValue();//债券编码
                    var START_DATE=form.getForm().findField("START_DATE").getValue();//起息日期
                    //var df_plan_id=form.getForm().findField("DF_PLAN_ID").getValue();//兑付计划id
                    var zdDateFormat = Ext.Date.format(ZD_DATE,"Y-m-d");
                    var qxDateFormat = Ext.Date.format(QX_DATE,'Y-m-d');
                    if(zdDateFormat<qxDateFormat){
                        Ext.Msg.alert('提示',"债券转贷日期不能小于债券起息日！");
                        return false;
                    }

                    for(var m=0;m<form.down('#zqzd_grid2').getStore().getCount();m++){
                        var record = form.down('#zqzd_grid2').getStore().getAt(m);
                        recordArray.push(record.data);
                    }
                    var parameters = {
                        wf_id: wf_id,
                        zd_level: '0',
                        ZQ_ID:ZQ_ID,
                        ZD_DATE:ZD_DATE,
                        TQHK_DAYS:TQHK_DAYS,
                        zq_code: ZQ_CODE,
                        FHZ_ID:window_zzlrinput.HZ_ID,
                        //DF_PLAN_ID:df_plan_id,
                        node_code: node_code,
                        button_name: button_name,
                        button_text: button_text,
                        menucode:menucode,
                        detailList: Ext.util.JSON.encode(recordArray),
                    };
                    if (button_text == '修改') {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        parameters.ZD_ID = records[0].get('ZD_ID');
                    }
                    if (form.isValid()) {
                        //保存表单数据及明细数据
                        form.submit({
                            //设置表单提交的url
                            url: 'savedwZzlrZdxxGrid.action',
                            params: parameters,
                            success: function (form, action) {
                                //关闭弹出框
                                btn.up("window").close();
                                //提示保存成功
                                Ext.toast({
                                    html: '<div style="text-align: center;">保存成功!</div>',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                window_input.HZ_ID='';
                                reloadGrid();
                            },
                            failure: function (form, action) {
                                var result = Ext.util.JSON.decode(action.response.responseText);
                                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                // btn.setDisabled(false);
                            }
                        });
                    } else {
                        Ext.Msg.alert('提示', '请检查必填项！');
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
 * 初始化债券转贷表单
 */
function initWindow_zzlrinput_contentForm() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'form_zqzd_form',
        name:"form_zqzd_form",
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        border: false,
        defaults: {
            width: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 280,
//                            disabled:true,
                    readOnly: true,
                    labelWidth: 160//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: "虚拟主单",
                        name: "HZ_ID",
                        xtype: "textfield",
                        readOnly: true,
                        editable: false,
                        hidden: true
                    },
                    /*{
                        fieldLabel: "兑付id",
                        name: "DF_PLAN_ID",
                        xtype: "textfield",
                        readOnly: true,
                        editable: false,
                        hidden: true
                    },*/
                    {
                        dataIndex: "ZQ_CODE",
                        type: "string",
                        text: "债券编码",
                        hidden: true,
                        width: 130
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债券ID',
                        disabled: false,
                        name: "ZQ_ID",
                        hidden: debuggers,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "displayfield",
                        fieldLabel: '债券名称',
                        name: "ZQ_NAME",
                        tdCls: 'grid-cell-unedit'
                        //columnWidth: 0.66
                    },
                    {
                        xtype: "combobox",
                        name: "ZQLB_ID",
                        store: DebtEleStore(json_debt_zqlx2),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债券类型',
                        editable: false, //禁用编辑
                        listeners: {
                            change: function (self, newValue) {
                                // bond_type_id = newValue;
                                //reloadGrid();
                            }
                        },
                        hidden:false,
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZDJE",
                        fieldLabel: '剩余可转贷金额（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'

                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZDJEadd",
                        fieldLabel: '剩余可转贷金额增加',
                        emptyText: '0.00',
                        hidden:true,
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        listeners:{
                            'change':function(me, newValue, oldValue, eOpts){
                                /*if(button_text=="修改"){
                                    return;
                                }*/
                                var form = me.up('window').down('form');
                                var amt=newValue-oldValue;
                                var kzdje_amt=form.down('numberFieldFormat[name="KZDJE"]').getValue();
                                if(kzdje_amt!=null&&kzdje_amt!=""){
                                    kzdje_amt-=amt;
                                }
                                form.down('numberFieldFormat[name="KZDJE"]').setValue(kzdje_amt);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZD_XZ",
                        fieldLabel: '其中新增债券金额（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZD_XZadd",
                        fieldLabel: '剩余新增金额增加',
                        emptyText: '0.00',
                        hidden:true,
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        listeners:{
                            'change':function(me, newValue, oldValue, eOpts){
                                /*if(button_text=="修改"){
                                    return;
                                }*/
                                var form = me.up('window').down('form');
                                var amt=newValue-oldValue;
                                var kzdje_amt=form.down('numberFieldFormat[name="KZD_XZ"]').getValue();
                                kzdje_amt=kzdje_amt-amt;
                                form.down('numberFieldFormat[name="KZD_XZ"]').setValue(kzdje_amt);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZD_ZH",
                        fieldLabel: '其中置换债券金额（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZD_ZHadd",
                        fieldLabel: '剩余置换金额增加',
                        emptyText: '0.00',
                        hidden:true,
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        listeners:{
                            'change':function(me, newValue, oldValue, eOpts){
                                /*if(button_text=="修改"){
                                    return;
                                }*/
                                var form = me.up('window').down('form');
                                var amt=newValue-oldValue;
                                var kzdje_amt=form.down('numberFieldFormat[name="KZD_ZH"]').getValue();
                                kzdje_amt=kzdje_amt-amt;
                                form.down('numberFieldFormat[name="KZD_ZH"]').setValue(kzdje_amt);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZD_ZRZ",
                        fieldLabel: "其中再融资债券金额（元）",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },{
                        xtype: "numberFieldFormat",
                        name: "KZD_ZRZadd",
                        fieldLabel: '剩余再融资金额增加',
                        emptyText: '0.00',
                        hidden:true,
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        listeners:{
                            'change':function(me, newValue, oldValue, eOpts){
                                if(button_text=="修改"){
                                    return;
                                }
                                var form = me.up('window').down('form');
                                var amt=newValue-oldValue;
                                var kzdje_amt=form.down('numberFieldFormat[name="KZD_ZRZ"]').getValue();
                                kzdje_amt=kzdje_amt-amt;
                                form.down('numberFieldFormat[name="KZD_ZRZ"]').setValue(kzdje_amt);
                            }
                        }
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '2 0 2 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 160,//控件默认标签宽度
                    allowBlank: true
                },
                items: [
                    {
                        xtype: "datefield",
                        name: "ZD_DATE",
                        fieldLabel: '<span class="required">✶</span>转贷日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择转贷日期',
                        value: new Date()
                    },
                    {
                        xtype: "datefield",
                        name: "START_DATE",
                        fieldLabel: '<span class="required">✶</span>起息日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择起息日期',
                        editable:false,
                        value: DF_START_DATE_TEMP,
                        maxValue: DF_END_DATE_TEMP ,
                        minValue: DF_START_DATE_TEMP
                    },
                    {
                        xtype: "numberfield",
                        name: "TQHK_DAYS",
                        fieldLabel: '提前还款天数',
                        minValue: 0,
                        maxValue: 99
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZNJ_RATE",
                        fieldLabel: '滞纳金率(万分之)',
                        emptyText: '0.000000',
                        minValue: 0,
                        allowDecimals: true,
                        allowBlank: false,
                        decimalPrecision: 6,
                        hideTrigger: true/*,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})*/
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '转贷明细',
                flex: 1,
                layout: 'fit',
                items: [initzzlrContentAddGrid()]
            }
        ]
    });
}
/**
 * 初始化债券转贷表单中转贷明细信息表格
 */
function initzzlrContentAddGrid(callback) {
    return Ext.create('Ext.tab.Panel', {//下面是个tabpanel
        layout: 'fit',
        itemId: 'zqzd_mx_edit1',
        flex: 1,
        autoLoad: true,
        height: '50%',
        items: IS_BZB == '1' ? [
            {
                title: '子债券转贷信息',
                layout: 'fit',
                items: initWindow_input_contentForm_grid2()
            }
        ] : [
            {
                title: '主债券转贷信息',
                layout: 'fit',
                items: initWindow_input_contentForm_grid1()
            },
            {
                title: '子债券转贷信息',
                layout: 'fit',
                items: initWindow_input_contentForm_grid2()
            }
        ]
    });

}

/**
 * 初始化第二个弹窗第一个标签页 :    主债券转贷明细表格
 */
function initWindow_input_contentForm_grid1() {
    var headerJson1 = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "QYJT_NAME", type: "string", text: "转贷单位", width: 250, hidden: debuggers},//, hidden: true
        {
            dataIndex: "QYJT_ID", type: "string", text: "转贷单位", width: 300,editable:false,
            displayField : 'text',
            editor: {//   行政区划动态获取(下拉框)
                xtype: 'treecombobox',
                displayField : 'text',
                valueField : 'id',
                selectModel: 'leaf',
                editable:false,
                value : '',
                rootVisible : false,
                store: store_zddw
            },
            tdCls: 'grid-cell',
            renderer: function (value) {
                var store = store_zddw;
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('text') : value;
            },
            listeners: {
                'rowclick':function(self){

                }
            }
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: minValue,
                maxValue: maxValue,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zzqzd_grid1',
        headerConfig: {
            headerJson: headerJson1,
            columnAutoWidth: false
        },
        autoLoad: false,
        dataUrl: 'getPcjhGridData.action',
        border: true,
        flex: 1,
        height: '100%',
        features: [{
            ftype: 'summary'
        }],
        width: '100%',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqzd_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        pageConfig: {
            enablePage: false
        }
    });
    grid.on('selectionchange', function (view, records) {
        grid.up('window').down('#tzjhDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 初始化第二个弹窗第二个标签页:  子债券转贷明细表格
 */
function initWindow_input_contentForm_grid2() {
    var headerJson2 = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "IS_READY", type: "string", text: "IS_READY", width: 150, hidden: debuggers},//, hidden: true
        {dataIndex: "IS_IMPORT", type: "string", text: "IS_IMPORT", width: 150, hidden: debuggers},//, hidden: true
        {dataIndex: "ZD_ID", type: "string", text: "转贷ID", width: 250, hidden: debuggers},//, hidden: true
        {dataIndex: "ZQ_ID", type: "string", text: "债券ID", width: 250, hidden: debuggers},//, hidden: true
        {dataIndex: "QYJT_NAME", type: "string", text: "转贷单位", width: 250, hidden: debuggers},//, hidden: true
        {
            dataIndex: "QYJT_ID", type: "string", text: "转贷单位", width: 300,editable:false,
            displayField : 'text',
            editor: {//   行政区划动态获取(下拉框)
                xtype: 'treecombobox',
                displayField : 'text',
                valueField : 'id',
                selectModel: 'leaf',
                editable:false,
                value : '',
                rootVisible : false,
                store: store_zddw
            },
            tdCls: 'grid-cell',
            renderer: function (value) {
                var store = store_zddw;
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('text') : value;
            },
            listeners: {
                'rowclick':function(self){

                }
            }
        },
        {
            dataIndex: "IS_QEHBFX", type: "string", text: "是否全额还本付息", width: 150,
            tdCls: 'grid-cell',
            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
            renderer: function (value) {
                var record = DebtEleStore(json_debt_sf).findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            },
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                allowBlank: false,
                value: 1,
                store: DebtEleStore(json_debt_sf)
            }
        },
        {
            dataIndex: "ZD_AMT", type: "float", text: "转贷金额(元)", width: 160, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            renderer: function (value, cellmeta, record) {
                value = record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT');
                return Ext.util.Format.number(value, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }

        },
        {
            dataIndex: "CDBJ_AMT", type: "float", text: "需承担本金金额", width: 160,
            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "CDLX_AMT", type: "float", text: "需承担利息本金金额", width: 160,
            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "XZ_SYZD_AMT", type: "float", text: "新增债券剩余可转贷金额(元)", width: 230,
            hidden: true,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: minValue,
                maxValue: maxValue,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            //summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
            hidden: false,//置换再融资债券隐藏
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: minValue,
                maxValue: maxValue,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "ZH_AMT", type: "float", text: "置换债券金额(元)", width: 160,
            hidden: true,//新增债券隐藏
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: minValue,
            //     maxValue: maxValue,
            //     allowBlank: false,
            //     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            // },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "HB_AMT", type: "float", text: "再融资债券金额(元)", width: 160,
            hidden: true,//新增债券隐藏
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: minValue,
            //     maxValue: maxValue,
            //     allowBlank: false,
            //     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            // },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "HB_AMT_ORI", type: "float", text: "还本债券金额(元)(校验用)", width: 160, hidden: debuggers
        },
        {
            dataIndex: "CHDQZQ", type: "string", text: "偿还到期债券", width: 150,
            hidden: true,//新增债券隐藏
            editor: {
                xtype: 'treecombobox',
                name: 'CHDQZQ3',
                displayField: 'name',
                valueField: 'id',
                editable: true, //禁用编辑
                readOnly: false,
                store: store_DQZQ,
                rootVisible: false,
                listeners: {
                    itemmouseenter: function (self, record, item) {
                        var remark = "简称:" + record.get("ZQ_JC") + "; 类型:" + record.get("ZQLB_NAME") + "; 发行方式:" + record.get("FXFS_NAME") + "; 期限:" + record.get("ZQQX_NAME");
                        if (!remark) {
                            return
                        }
                        self.tip = Ext.create('Ext.tip.ToolTip', {
                            target: item,
                            delegate: self.itemSelector,
                            trackMouse: true,
                            renderTo: Ext.getBody(),
                            listeners: {
                                beforeshow: function updateTipBody(tip) {
                                    tip.update(remark);
                                }
                            }
                        });
                    },
                    'select': function (a, b, c, d) {
                        var record = b.data;

                    }
                }
            }
        },
        {dataIndex: "CHDQZQSYJE", type: "float", text: "到期债券剩余金额", width: 150, hidden: true},
        {dataIndex: "CHDQZQID", type: "string", text: "偿还到期债券id", width: 150, editor: 'textfield', hidden: debuggers},
        {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150, editor: 'textfield'},
        {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zqzd_grid2',
        headerConfig: {
            headerJson: headerJson2,
            columnAutoWidth: false
        },
        autoLoad: false,
        dataUrl: 'getPcjhGridData.action',
        border: true,
        flex: 1,
        height: '100%',
        features: [{
            ftype: 'summary'
        }],
        width: '100%',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqzd_grid2_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {}
            }
        ],
        pageConfig: {
            enablePage: false
        }
    });
    grid.on('selectionchange', function (view, records) {
        grid.up('window').down('#tzjhDelBtn').setDisabled(!records.length);
    });
    grid.getStore().on('endupdate', function () {
        //计算录入窗口转贷总金额
        var self = grid.getStore();
        var form = grid.up('window').down('form');
        var input_cdbj_amt = 0;
        var input_cdlx_amt = 0;
        self.each(function (record) {
            if (record.get('IS_QEHBFX') == 1) {
                record.set('CDBJ_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                record.set('CDLX_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
            }
            record.set('ZD_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
            input_cdbj_amt += record.get('CDBJ_AMT');
            input_cdlx_amt += record.get('CDLX_AMT');
        });
        // form.down('numberFieldFormat[name="CDBJ_AMT"]').setValue(input_cdbj_amt);
        // form.down('numberFieldFormat[name="CDLX_AMT"]').setValue(input_cdlx_amt);
    });
    return grid;
}

function zdxxTab(index) {
    var zdxxTab = Ext.ComponentQuery.query('panel[itemId="zqzd_mx_edit1"]')[0];
    zdxxTab.items.get(index).show();
}
