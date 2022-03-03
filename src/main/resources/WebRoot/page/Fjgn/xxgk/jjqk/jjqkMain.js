/**
 * 页面初始化
 *
 */
var yy = new Date().getUTCFullYear();
var SET_YEAR=yy;
var YEAR_store = Ext.create("Ext.data.Store", {
    fields: ["Name", "Value"],
    data: [
        {Name: "2023年", Value: 2023},
        {Name: "2022年", Value: 2022},
        {Name: "2021年", Value: 2021},
        {Name: "2020年", Value: 2020},
        {Name: "2019年", Value: 2019},
        {Name: "2018年", Value: 2018},
        {Name: "2017年", Value: 2017},
        {Name: "2016年", Value: 2016}
    ]
});
var window_title='';
$(document).ready(function () {
    //显示提示
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    //动态加载js
    $.ajaxSetup({
        cache: true
    });
    initContent();
});
/**
 *初始化主页面
 * panel
 *
 */
function initContent() {
    return Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true, //是否有分割线
            collapsible: false //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),//控件要渲染的节点 渲染到页面
        border: false,
        dockedItems: [//工具条
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '填报',
                        name: 'INSERT',
                        icon: '/image/sysbutton/add.png',

                        handler: function (btn) {
                            btn.setDisabled(true);//设置按钮不可以点击
                            initjjqkWindow(btn).show();//展示新增窗口
                            btn.setDisabled(false);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            btn.setDisabled(true);
                            updateJjqkInfo(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            btn.setDisabled(true);
                            deleteJjqkInfo(btn);
                        }
                    },
                    '->',//将下面的按钮放到最右面
                    initButton_OftenUsed()
                ]
            }
        ],
        items: [
            initContentRightPanel()//初始化条件及表格
        ]
    });
}
/**
 * 初始化主页面筛选条件和表格panel
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
        items: initContentGrid()//初始化表格
    });
}

/**
 * 初始化主页面表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45
        },
        {dataIndex: "AD_CODE", type: "string", text: "区划", width: 80, hidden:true},
        {dataIndex: "AD_NAME", type: "string", text: "地区", width: 80},
        {dataIndex: "SET_YEAR", type: "string", text: "年度", width: 80},

        {
            text: "本地区国内生产总值（亿元）", dataIndex: "SC_SUM", type: "float",
            columns: [
                {dataIndex: "SCZZ_AMT", type: "float", text: "合计", width: 170,renderer:function(value){
                    return Ext.util.Format.number(value,'0,000.00');
                }},
                {dataIndex: "FIR_IND", type: "float", text: "第一产业",width: 140,renderer:function(value){
                    return Ext.util.Format.number(value, '0,000.00');
                }},
                {dataIndex: "SEC_IND", type: "float", text: "第二产业",width: 140,renderer:function(value){
                    return Ext.util.Format.number(value,'0,000.00');
                }},
                {dataIndex: "THI_IND", type: "float", text: "第三产业", width: 140,renderer:function(value){
                    return Ext.util.Format.number(value,'0,000.00');
                }}
            ]
        },
        {
            text: "产业结构（%）", dataIndex: "CYJG", type: "float",
            columns: [
                {dataIndex: "FIR_BL", type: "float", text: "第一产业比例", INPUTMASK:'999,999,999,999.99',width: 140},
                {dataIndex: "SEC_BL", type: "float", text: "第二产业比例",INPUTMASK:'999,999,999,999.99', width: 140},
                {dataIndex: "THI_BL", type: "float", text: "第三产业比例",INPUTMASK:'999,999,999,999.99', width: 140}
            ]
        },
        {dataIndex: "ZCTZ_AMT", type: "float", text: "固定资产投资（亿元）",INPUTMASK:'999,999,999,999,999.99', width: 170},
        {dataIndex: "JCK_AMT", type: "float", text: "进出口总额（亿元）",INPUTMASK:'999,999,999,999,999.99',width: 160},
        {dataIndex: "XFP_AMT", type: "float", text: "社会消费品零售总额（亿元）",INPUTMASK:'999,999,999,999,999.99', width: 210},
        {dataIndex: "CZZP_AMT", type: "float", text: "城镇（常住）居民人均可支配收入（元）",INPUTMASK:'999,999,999,999,999.99', width: 290},
        {dataIndex: "NCSR_AMT", type: "float", text: "农村（常住）居民人均纯收入（元）", width: 290,/*INPUTMASK:'999,999,999,999.99', labelAlign: 'left',*/
            renderer:function(value){
                return Ext.util.Format.number(value,'0,000.00####');
            }}
];
    /**
     * 表格上方工具栏
     */
    var gridTbar = [
        {
            xtype: "combobox",
            name: "YEARS",
            value:yy,
            id: "YEARS",
            fieldLabel: '年度',
            allowBlank: true,//允许为空
            labelWidth: 50,//标签宽度
            width: 156,
            labelAlign: 'right',//标签对齐方式
            checked: true,
            store: YEAR_store,
            editable: false,
            displayField: 'Name',
            valueField: 'Value',
            hiddenName:'Value',
            enableKeyEvents: true,
            listeners: {
                keypress: function (self, e) {
                    //Enter点击事件
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        //刷新表格
                        reloadGrid();
                    }
                },
                change: function (self, newValue, oldValue) {
                    SET_YEAR = newValue;
                    reloadGrid();
                }
            }
        }];
    var grid= DSYGrid.createGrid({
        itemId: 'JjqkGrid',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getJjqkInfo.action',
        params: {
             SET_YEAR: SET_YEAR
         },
        tbar: gridTbar,//查询条件
        autoLoad: true,
        checkBox: true,
        flex: 1,
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        }
    });
    return grid;
}
/**
 * 填报窗口（修改也用这个）
 * @param b_btn
 */
function initjjqkWindow(b_btn) {

    if(b_btn.name=='INSERT'){
        window_title="经济基本情况填报窗口";
    }
    else if(b_btn.name=='UPDATE'){
        window_title="经济基本情况修改窗口";
    }
    return Ext.create('Ext.window.Window', {
        title:window_title ,       //标题
        draggable: true,//是否可以拖动
        width: document.body.clientWidth * 0.43,
        height: document.body.clientHeight * 0.83,
        layout: "fit",                        //窗口布局类型
        modal: false, //是否模式窗口，默认为false，除窗口外背景全部变为暗色，然后其他区域不能操作
        resizable: true,//尺寸可调整
        itemId: 'jjqklrWindow',
        maximizable: true,//最大化
        closeAction: 'destroy',//关闭窗口的时候，窗口销毁而不是hide 隐藏
        items: initjjqkform(),//录入/修改信息的详细组件
        buttons: [
            {
                xtype: 'button',
                text: Button_Name(b_btn),
                handler: function (btn) {
                    btn.setDisabled(true);
                    if(b_btn.name=='INSERT'){
                        saveJjqkInfo(b_btn, btn);
                    }
                    else if(b_btn.name=='UPDATE'){
                        UpdateJjqkInfo(b_btn, btn);
                    }
                    btn.setDisabled(false);
                }
            },
            {
                xtype: 'button',
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    }
/**
 * 填报信息表单
 */
function initjjqkform() {
    var form=Ext.create('Ext.form.Panel', {
        layout: 'form',
        name:'jjqkform',
        itemId: 'jjqkform',
        autoScroll:true,//自动添加滚动条
        border: false,
        split: true,
        margin: '5 5 5 10',//边距
        defaultType: 'textfield',
      //  labelAlign: 'right',
        //labelWidth:10,
        maxWidth:500,
        items: [
            {
                fieldLabel: '<span class="required">✶</span>年度',
                name: 'SET_YEAR',
                xtype: 'combobox',
                allowBlank : false,
                emptyText:yy,
                store: YEAR_store,
                editable: false,
                displayField: 'Name',
                valueField: 'Value',
                width:200,
                hiddenName:'Value'
                //readOnly: true
            },
            {
                fieldLabel: '<span class="required">✶</span>地区',
                name: 'AD_NAME',
                allowBlank : false,
                xtype: 'textfield',
                readOnly: true
            },
            {
                fieldLabel: '本地区国内生产总值（亿元）',
                name: 'SCZZ_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true ,//去掉默认的小箭头。
                fieldStyle:'background-color: #E0E0E0 ;border-color: ##E0E0E0 background-image: none;',
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                allowBlank : true,
                maxValue:999999,
                negativeText:'该项不能小于0',
                nanText: "请保证输入有效的数",
                readOnly: true
            },
            {
                fieldLabel: '<span class="required">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>第一产业（亿元）',
                xtype: 'numberFieldFormat',
                name: 'FIR_IND',
                hideTrigger: true ,//去掉默认的小箭头。
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                dataIndex: "FIR_IND",
                allowBlank : true,
                maxValue:999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if (newValue != oldValue) {
                            //自动计算本地生产总值
                            var FIR_IND=form.getForm().findField('FIR_IND').getValue();
                            var SEC_IND= form.getForm().findField('SEC_IND').getValue();
                            var THI_IND= form.getForm().findField('THI_IND').getValue();
                            newValue=FIR_IND+SEC_IND+THI_IND;
                            if(FIR_IND>=0&&SEC_IND>=0&&THI_IND>=0) {
                                form.getForm().findField('SCZZ_AMT').setValue(newValue);
                                form.getForm().findField('FIR_BL').setValue((FIR_IND * 100 / newValue).toFixed(2) + '%');
                                form.getForm().findField('SEC_BL').setValue((SEC_IND * 100 / newValue).toFixed(2) + '%');
                                var F_BL = parseFloat((FIR_IND / newValue).toFixed(4));
                                var S_BL = parseFloat((SEC_IND / newValue).toFixed(4));
                                var T_BL = parseFloat((THI_IND / newValue).toFixed(4));
                                var sums = parseFloat(F_BL + S_BL + T_BL).toFixed(4);
                                if (sums > 1) {
                                    if (!isNull(THI_IND)) {
                                        form.getForm().findField('THI_BL').setValue(((1 - F_BL - S_BL) * 100).toFixed(2) + '%');
                                    }
                                    else {
                                        form.getForm().findField('SEC_BL').setValue((1 - F_BL).toFixed(4) * 100 + '%');
                                    }
                                }
                                else {
                                    form.getForm().findField('THI_BL').setValue((THI_IND * 100 / newValue).toFixed(2) + '%');
                                }
                            }
                            if(isNull(FIR_IND)&&isNull(SEC_IND)&&isNull(THI_IND)){
                                form.getForm().findField('FIR_BL').setValue('0.00%');
                                form.getForm().findField('SEC_BL').setValue('0.00%');
                                form.getForm().findField('THI_BL').setValue('0.00%');
                            }
                        }
                    },
                }
            },
            {
                fieldLabel: '<span class="required">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>第二产业（亿元）',
                xtype: 'numberFieldFormat',
                name: 'SEC_IND',
                hideTrigger: true ,//去掉默认的小箭头。
                emptyText: '0.00',
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                allowBlank : true,
                maxValue:999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if (newValue != oldValue) {
                            //自动计算本地生产总值
                            var FIR_IND=form.getForm().findField('FIR_IND').getValue();
                            var SEC_IND= form.getForm().findField('SEC_IND').getValue();
                            var THI_IND= form.getForm().findField('THI_IND').getValue();
                            newValue=FIR_IND+SEC_IND+THI_IND;
                            if(FIR_IND>=0&&SEC_IND>=0&&THI_IND>=0) {
                                form.getForm().findField('SCZZ_AMT').setValue(newValue);
                                form.getForm().findField('FIR_BL').setValue((FIR_IND * 100 / newValue).toFixed(2) + '%');
                                form.getForm().findField('SEC_BL').setValue((SEC_IND * 100 / newValue).toFixed(2) + '%');
                                var F_BL = parseFloat((FIR_IND / newValue).toFixed(4));
                                var S_BL = parseFloat((SEC_IND / newValue).toFixed(4));
                                var T_BL = parseFloat((THI_IND / newValue).toFixed(4));
                                var sums = parseFloat(F_BL + S_BL + T_BL).toFixed(4);
                                if (sums > 1) {
                                    if (!isNull(THI_IND)) {
                                        form.getForm().findField('THI_BL').setValue(((1 - F_BL - S_BL) * 100).toFixed(2) + '%');
                                    }
                                    else {
                                        form.getForm().findField('SEC_BL').setValue((1 - F_BL).toFixed(4) * 100 + '%');
                                    }
                                }
                                else {
                                    form.getForm().findField('THI_BL').setValue((THI_IND * 100 / newValue).toFixed(2) + '%');
                                }
                            }
                            if(isNull(FIR_IND)&&isNull(SEC_IND)&&isNull(THI_IND)){
                                form.getForm().findField('FIR_BL').setValue('0.00%');
                                form.getForm().findField('SEC_BL').setValue('0.00%');
                                form.getForm().findField('THI_BL').setValue('0.00%');
                            }
                        }
                    }
                }
            },
            {
                fieldLabel: '<span class="required">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>第三产业（亿元）',
                xtype: 'numberFieldFormat',
                name: 'THI_IND',
                hideTrigger: true ,//去掉默认的小箭头。
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                emptyText: '0.00',
                allowBlank : true,
                maxValue:999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if (newValue != oldValue) {
                            //自动计算本地生产总值
                            var FIR_IND=form.getForm().findField('FIR_IND').getValue();
                            var SEC_IND= form.getForm().findField('SEC_IND').getValue();
                            var THI_IND= form.getForm().findField('THI_IND').getValue();
                            newValue=FIR_IND+SEC_IND+THI_IND;
                            if(FIR_IND>=0&&SEC_IND>=0&&THI_IND>=0) {
                                form.getForm().findField('SCZZ_AMT').setValue(newValue);
                                form.getForm().findField('FIR_BL').setValue((FIR_IND * 100 / newValue).toFixed(2) + '%');
                                form.getForm().findField('SEC_BL').setValue((SEC_IND * 100 / newValue).toFixed(2) + '%');
                                var F_BL = parseFloat((FIR_IND / newValue).toFixed(4));
                                var S_BL = parseFloat((SEC_IND / newValue).toFixed(4));
                                var T_BL = parseFloat((THI_IND / newValue).toFixed(4));
                                var sums = parseFloat(F_BL + S_BL + T_BL).toFixed(4);
                                if (sums > 1) {
                                    if (!isNull(THI_IND)) {
                                        form.getForm().findField('THI_BL').setValue(((1 - F_BL - S_BL) * 100).toFixed(2) + '%');
                                    }
                                    else {
                                        form.getForm().findField('SEC_BL').setValue((1 - F_BL).toFixed(4) * 100 + '%');
                                    }
                                }
                                else {
                                    form.getForm().findField('THI_BL').setValue((THI_IND * 100 / newValue).toFixed(2) + '%');
                                }
                            }
                            if(isNull(FIR_IND)&&isNull(SEC_IND)&&isNull(THI_IND)){
                                form.getForm().findField('FIR_BL').setValue('0.00%');
                                form.getForm().findField('SEC_BL').setValue('0.00%');
                                form.getForm().findField('THI_BL').setValue('0.00%');
                            }
                        }
                    }
                }
            },
            {
                xtype:'label',
                fieldLabel:'产业结构',
                html:'产业结构'
            },
            {
                fieldLabel: '<span class="required">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>第一产业比例（%）',
                xtype: "textfield",
                name: 'FIR_BL',
                fieldStyle:'background-color: #E0E0E0 ;border-color: ##E0E0E0 background-image: none;',
                allowBlank : true,
                readOnly: true,
                emptyText: '0.00%'
            },
            {
                fieldLabel: '<span class="required">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>第二产业比例（%）',
                xtype: "textfield",
                allowBlank : true,
                name: 'SEC_BL',
                readOnly: true,
                fieldStyle:'background-color: #E0E0E0 ;border-color: ##E0E0E0 background-image: none;',
                emptyText: '0.00%'
            },
            {
                fieldLabel: '<span class="required">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>第三产业比例（%）',
                xtype: "textfield",
                name: 'THI_BL',
                allowBlank : true,
                readOnly: true,
                fieldStyle:'background-color: #E0E0E0 ;border-color: ##E0E0E0 background-image: none;',
                emptyText: '0.00%'
            },
            {
                fieldLabel: '固定资产投资（亿元）',
                name: 'ZCTZ_AMT',
                xtype :'numberFieldFormat',
                numberFormat: true,
                hideTrigger: true ,//去掉默认的小箭头。
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                allowBlank : true,
                maxValue:99999999999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function (self, newValue, oldValue) {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        }
                        },
                emptyText: '0.00'
            },
            {
                fieldLabel: '进出口总额（亿元)',
                xtype: 'numberFieldFormat',
                name: 'JCK_AMT',
                hideTrigger: true ,//去掉默认的小箭头。
                minValue: 0,
                allowDecimals: true, //允许输入小数
                allowBlank : true,
                decimalPrecision: 2,//小数位数
                maxValue:99999999999999,
    /*            autoStripChars:true,//过滤不允许输入的字符*/
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                    }
                },
                emptyText: '0.00'
            },
            {
                fieldLabel: '社会消费品零售总额（亿元）',
                xtype: 'numberFieldFormat',
                name: 'XFP_AMT',
                hideTrigger: true ,//去掉默认的小箭头。
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                allowBlank : true,
                maxValue:99999999999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                    }
                },
                emptyText: '0.00'
            },
            {
                fieldLabel: '城镇（常住）居民人均可支配收入（元）',
                xtype: 'numberFieldFormat',
                name: 'CZZP_AMT',
                hideTrigger: true ,//去掉默认的小箭头。
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                allowBlank : true,
                maxValue:99999999999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                    }
                },
                emptyText: '0.00'
            },
            {
                fieldLabel: '农村（常住）居民人均纯收入（元）',
                xtype: 'numberFieldFormat',
                name: 'NCSR_AMT',
                hideTrigger: true ,//去掉默认的小箭头。
                minValue: 0,
                allowDecimals: true, //允许输入小数
                decimalPrecision: 2,//小数位数
                allowBlank : true,
                maxValue:99999999999999,
                negativeText:'该输入项不能小于0',
                nanText: "请输入有效的数",
                listeners: {
                    'change': function(newValue, oldValue)  {
                        if ( newValue.value < 0) {
                            Ext.toast({
                                html: "输入错误字符或者资金低于0！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                    }
                },
                emptyText: '0.00'
            }
        ]
    });
    var form = Ext.ComponentQuery.query('form#jjqkform')[0];
    form.getForm().findField('SET_YEAR').setValue(yy);
    form.getForm().findField('AD_NAME').setValue(USER_AD_NAME);
    form.getForm().findField('AD_NAME').setReadOnly(true);
    return  form;
}

/**
 * 判断按钮的名字
 * @param b_btn
 */
function Button_Name(b_btn){
    if(b_btn.name=='INSERT'){
        return '保存';
    }
    else if(b_btn.name=='UPDATE'){
        return '保存';
    }
}

/**
 * 保存新增信息(点击按钮调用)
 * @param b_btn btn
 */
function saveJjqkInfo(b_btn,btn){
    var jjqkform = Ext.ComponentQuery.query('form#jjqkform')[0];
    var BooleanInfo=verifi();//校验：若同年度同地区存在不让新增，请去修改
    if(BooleanInfo){
    var Values=jjqkform.getForm().getValues();
    $.post('saveJjqkInfo.action', {
        detailForm: Ext.util.JSON.encode([Values]),
        BUTTON_NAME: b_btn.name
    }, function (data) {
        //data = eval(data);
        if (data.success) {
            Ext.toast({
                html: btn.text + "成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            reloadGrid();
        }
        else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, 'JSON');
    }

}
/**
 * 更新信息（点击按钮调用）
 * @param b_btn btn
 */
function UpdateJjqkInfo(b_btn,btn){
    var jjqkform = Ext.ComponentQuery.query('form#jjqkform')[0];
    var Values=jjqkform.getForm().getValues();
    $.post('saveJjqkInfo.action', {
        detailForm: Ext.util.JSON.encode([Values]),
        BUTTON_NAME: b_btn.name
    }, function (data) {
        //data = eval(data);
        if (data.success) {
            Ext.toast({
                html: btn.text + "成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            reloadGrid();
        }
        else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, 'JSON');

}

/**
 * 修改经济情况信息 表单数据回显
 * @param btn
 */
function updateJjqkInfo(btn){
    var records = DSYGrid.getGrid('JjqkGrid').getSelection();//获取到选中的数据
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
        btn.setDisabled(false);
        return;
    }
    var AD_NAME = records[0].get('AD_NAME');
    var SET_YEAR = records[0].get('SET_YEAR');
    var FIR_BL = records[0].get('FIR_BL');
    var SEC_BL = records[0].get('SEC_BL');
    var THI_BL = records[0].get('THI_BL');
    var jjqkWindow = initjjqkWindow(btn);
    var form = Ext.ComponentQuery.query('form#jjqkform')[0];
    form.getForm().findField('AD_NAME').setValue(AD_NAME);
    form.getForm().findField('AD_NAME').setReadOnly(true);
    form.getForm().findField('SET_YEAR').setValue(SET_YEAR);
    form.getForm().findField('SET_YEAR').setReadOnly(true);
    form.getForm().findField('SCZZ_AMT').setValue( records[0].get('SCZZ_AMT'));
    form.getForm().findField('FIR_IND').setValue( records[0].get('FIR_IND'));
    form.getForm().findField('SEC_IND').setValue( records[0].get('SEC_IND'));
    form.getForm().findField('THI_IND').setValue( records[0].get('THI_IND'));
    form.getForm().findField('FIR_BL').setValue(FIR_BL+'%');
    form.getForm().findField('SEC_BL').setValue(SEC_BL+'%');
    form.getForm().findField('THI_BL').setValue(THI_BL+'%');
    form.getForm().findField('ZCTZ_AMT').setValue( records[0].get('ZCTZ_AMT'));
    form.getForm().findField('JCK_AMT').setValue( records[0].get('JCK_AMT'));
    form.getForm().findField('XFP_AMT').setValue( records[0].get('XFP_AMT'));
    form.getForm().findField('CZZP_AMT').setValue( records[0].get('CZZP_AMT'));
    form.getForm().findField('NCSR_AMT').setValue( records[0].get('NCSR_AMT'));
    jjqkWindow.show();
    btn.setDisabled(false);
}

/**
 * 删除选中数据
 * @param btn
 */
function deleteJjqkInfo(btn) {
    var records = DSYGrid.getGrid('JjqkGrid').getSelection();
    if (records.length < 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            var ADS = [];
            var YEARS=[];
            for (var i in records) {
                ADS.push(records[i].get('AD_CODE'));
                YEARS.push(records[i].get('SET_YEAR'));
            }
            $.post("deleteJjqkInfo.action", {
                ADS: ADS,
                YEARS:YEARS
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
        } else {
            btn.setDisabled(false);
        }
    });
}

/**
 * 刷新表格  带着参数（SET_YEAR）查询
 */
function reloadGrid() {
    var store = DSYGrid.getGrid('JjqkGrid').getStore();
    var SET_YEAR = Ext.ComponentQuery.query('combobox#YEARS')[0].getValue();//筛选选项
    var extraParams = {
        SET_YEAR:SET_YEAR
    };
    extraParams = $.extend([], extraParams);//用一个或多个其他对象来扩展一个对象，返回被扩展的对象。
    store.getProxy().extraParams = extraParams;//刷新store
    //刷新
    store.loadPage(1);//刷新后加载第一页
}

/**
 * 表单校验  判断本年度本地区是否录入过
 */
function verifi() {
    var form = Ext.ComponentQuery.query('form#jjqkform')[0];
    var YEARS=form.getForm().findField('SET_YEAR').getValue(SET_YEAR);
    var BooleanInfo=false;
    $.ajaxSettings.async=false;  //插入这个代码用ajax的“同步方式”调用一般处理程序，否则来不及响应，就返回了
    $.post('verifidata.action', {
        AD: USER_AD_CODE,
        YEARS: YEARS
    }, function (data) {
        if (data.success) {
            BooleanInfo=true;
            reloadGrid();
        }
        else {
            BooleanInfo=false;
            Ext.MessageBox.alert('提示','本地区今年已经录入过了');
        }
    }, 'JSON');
    return  BooleanInfo;
}




