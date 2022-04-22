var WZXY_ID = "";
var ZWFG_ID = "";
var wbStore =  DebtEleStore(json_debt_wb);
//投资报表明细ID 批量删除是存放id
Ext.define('rateModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'code', mapping: 'WB_CODE'},
        {name: 'roe', mapping: 'ROE'}
    ]
});

var rateStore = getRateStore();

/**
 * 页面初始化
 */
$(document).ready(function () {
    initContent();
});

//获取币种汇率
function getRateStore(){
    var rateStore = Ext.create('Ext.data.Store', {
        model: 'rateModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getRateData.action",
            reader: {
                type: 'json'
            }
        },
        autoLoad: true
    });
    return rateStore;
}
//可提款限额数据集
function getKtAmtStore(filterParam) {
    var kt_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['XM_ID', 'SET_YEAR', 'AMT'],
        proxy: {
            type: 'ajax',
            url: '/getKtAmtData.action',
            extraParams: filterParam,
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });
    return kt_store;
}

var kt_amt_store;

/**
 * 初始化页面主要内容区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有确认线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        items: [
            initContentRightPanel()//初始化右侧2个表格
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
        itemId: 'initContentGrid',
        tbar: [
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '债务确认',
                name: 'apply',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.name;
                    OPERATE = 'APPLY';
                    window_xmtksq.show(null, btn);
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    //修改全局变量的值
                    button_name = btn.name;
                    title = "贷款协议修改";
                    wzxy_id = records[0].get("WZXY_ID");
                    ZWFG_ID = records[0].get("ZWFG_ID");
                    kt_amt_store = getKtAmtStore({ZWFG_ID:records[0].get("ZWFG_ID")});
                    init_edit_tksq(btn).show();
                    var xmtkRecord = records[0].getData();
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', xmtkRecord.XMFL, 0, false, true, true);
                    if(result!=null && result!=""){
                        xmtkRecord.XMFL = result.get('name');
                    }else{
                        xmtkRecord.XMFL = null;
                    }
                    xmtkRecord.WFG_AMT = xmtkRecord.WFG_AMT + xmtkRecord.FG_AMT;
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
                    form.setValues(xmtkRecord);//将记录中的数据写进form表中
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'del',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    kt_amt_store = getKtAmtStore({});
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            doworkupdate(records, btn);
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时导出多条记录！');
                        return;
                    }else{
                        var ZWFG_IDS = records[0].get("ZWFG_ID");
                        DSYGrid.exportExcelClick('contentGrid_detail', {
                            exportExcel: true,
                            url: 'getZwfgDetailGridExcel_Cq.action',
                            param: {
                                ZWFG_IDS: ZWFG_IDS
                            }
                        });
                    }
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        items: [
            initContentGrid(),
            initContentDetilGrid()
        ]
    });
}

/**
 * 初始化主表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "ZWFG_ID",
            type: "string",
            text: "债务确认ID",
            fontSize: "15px",
            hidden: true
        },
        {
            dataIndex: "WZXY_ID",
            type: "string",
            text: "外债协议ID",
            fontSize: "15px",
            hidden: true
        },
        {
            type: "string",
            text: '外债名称',
            dataIndex: "WZXY_NAME",
            width: 300
        },
        {
            type: "string",
            text: '大项目',
            dataIndex: "SJXM_NAME",
            width: 300
        },
        {
            text: '建设状态',
            type: "string",
            dataIndex: "JSZT",
            width: 100
        },
        {
            type: "string",
            text: '协议号',
            dataIndex: "WZXY_NO",
            width: 100
        },
        {
            text: "协议日期",
            type: "string",
            dataIndex: "SIGN_DATE",
            width: 100,
            editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            type: "string",
            text: '币种',
            dataIndex: "FM_ID",
            hidden: true,
            width: 100
        },
        {
            text: "汇率",
            type: "float",
            dataIndex: "HL_RATE",
            width: 100,
            format: '0,000.000000',
            hidden: true,
            editable: false,//禁用编辑
            renderer: function (value, cell) {
                value = Ext.util.Format.number(value,'0,000.000000');
                return value;
            }
        },
        {
            text: "确认日期",
            dataIndex: "FG_DATE",
            type: "string",
            width: 100,
            editor: {xtype: 'datefield', format: 'Y-m-d'}
        },
        {
            type: "float",
            text: '未确认金额',
            dataIndex: "WFG_AMT",
            width: 150,
            hidden: false,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "确认总金额",
            dataIndex: "FG_AMT",
            type: "float",
            width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {
            text: "备注",
            dataIndex: "REMARK",
            type: "string",
            width: 300
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        autoLoad: true,
        dataUrl: "getZwfgData_Cq.action",
        checkBox: true,
        border: false,
        height: '50%',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar:[
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "XM_SEARCH",
                width: 350,    //762
                labelWidth: 80,
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            reloadGrid();
                        }
                    }
                }
            },
            {
                xtype: "combobox",
                name: "BUILD_STATUS_ID",
                itemId: "BUILD_STATUS_ID",   //项目立项年度
                store: DebtEleTreeStoreDB("DEBT_XMJSZT",{condition: "AND CODE IN ('01','03')"}),
                fieldLabel: '建设状态',
                displayField: 'name',
                valueField: 'id',
                labelWidth: 80,
                // rootVisible: true,
                // lines: false,
                // selectModel: 'leaf',
                // typeAhead:false,//不可编辑
                // editable:false,
                listeners: {
                    change: function (btn) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            }
        ],
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZWFG_ID'] = record.get('ZWFG_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
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
            xtype: 'rownumberer',
            width: 40,
            summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "债务确认明细单ID",
            dataIndex: "ZWFGMX_ID",
            type: "string",
            width: 100,
            editor: 'textfield',
            hidden: true
        },
        {
            text: '地区',
            type: "string",
            dataIndex: 'AD_NAME',
            width: 150
        },
        {
            text: "单位名称",
            type: "string",
            dataIndex: "AG_NAME",
            width: 200
        },
        {
            dataIndex: "JSDW",
            type: "string",
            text: "建设单位",
            width: 200,
            editable: true
        },
        {
            dataIndex: "HKDW",
            type: "string",
            text: "还款单位",
            editable: true,
            width: 200
        },
        {
            text: '项目',
            dataIndex: 'XM_NAME',
            width: 300,
            type: "string",
            renderer: function (data, cell, record) {
                if(record.get('XM_ID')!=null && record.get('XM_ID')!=''){
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
        },
        {
            text: "贷款性质",
            type: "string",
            dataIndex: "DKXZ",
            width: 100
        },
        {
            dataIndex: "ZD_AMT",
            type: "float",
            text: "转贷金额(原币)",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {
            dataIndex: "ZWYE_AMT",
            type: "float",
            text: "债务余额(原币)",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "FG_AMT",
            type: "float",
            text: "本次确认金额(原币)",
            width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        // {
        //     text: "币种",
        //     type: "string",
        //     dataIndex: "FM_NAME",
        //     width: 100
        // },
        {
            text: "汇率",
            type: "float",
            dataIndex: "FG_HL",
            width: 100,
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
        },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            editable: true,
            width: 100,
            renderer: function (value) {
                if (value != null && value != undefined && value != '') {
                    return format(value, 'yyyy-MM-dd');
                }
            }
        },
        {
            dataIndex: "FG_RMB",
            type: "float",
            text: "本次确认金额(人民币)",
            width: 180,
            editable: true,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: true,
        dataUrl: 'getZwfgDetailGrid_Cq.action',
        params: {
            ZWFG_ID: ZWFG_ID
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
 * 创建债务确认弹出窗口
 */
var window_xmtksq = {
    window: null,
    btn: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config, btn) {
        $.extend(this.config, config);
        if (!this.window || this.config.closeAction == 'destroy') {
            this.window = initWindow_xmtksq(this.config, btn);
        }
        this.window.show();
    }
};


/**
 * 初始化债务确认弹出窗口
 */
function initWindow_xmtksq(params) {
    return Ext.create('Ext.window.Window', {
        title: '外债选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_clzw', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_xmtksq_grid(params)],
        buttons: [
            {
                text: '确认',
                //获取表格选中数据
                handler: function (btn) {
                    kt_amt_store = getKtAmtStore({});
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();
                    WZXY_ID = records[0].get("WZXY_ID");

                    // 检查项目是否存在支付类别为（土建和设备）的未确认的提款
                    $.post('checkNoConfirmInfo_Cq.action', {
                        WZXY_ID:WZXY_ID
                    }, function (data) {
                        if (data.success) {
                            //如果查询有为确认的提款，提醒
                            Ext.Msg.confirm('提示', records[0].get("SJXM_NAME")+'项目中存在未确认的提款信息,请确认是否继续！', function (btn_confirm) {
                                if (btn_confirm == 'yes') {
                                    var url = '/page/debt/wzgl/dkgl/xmtkgl/xmtkqr_Cq.jsp';
                                    window.open(url);
                                    btn.up('window').close();
                                }
                            });

                        }else{
                            btn.up('window').close();
                            //如果有咨询其他类型提款还没有确认原币，则先确认原币
                            $.post('checkNoConfirmFGInfo_Cq.action', {
                                WZXY_ID:WZXY_ID
                            }, function (data) {
                                if (data.success) {
                                    init_edit_tksq_fg(btn,record).show();
                                    var form = Ext.ComponentQuery.query('form#tksq_edit_form_fg')[0].getForm();//找到该form
                                    form.setValues(record);//将记录中的数据写进form表中
                                }else{
                                    initZwqrInfo(btn,record);
                                }

                            }, 'JSON');
                        }
                    }, 'JSON');
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
 * 创建并弹出新增提款信息窗口
 */
function init_edit_tksq_fg(btton, record) {
    return Ext.create('Ext.window.Window', {
        title: '债务确认',
        itemId: 'jjxxadd',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 添加
        frame: true,
        constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'fit',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        closeAction: 'destroy',
        items: [initEditor_fg()],
        buttons: [
            {
                text: '保存并分割',
                name: 'btn_fg',
                id: 'fg',
                handler: function (btn) {
                    saveZwqrFGInfo(btn,record);
                }
            },
            {
                text: '关闭',
                name: 'btn_fg_gb',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}
/**
 * 保存项目提款确认
 */
function saveZwqrFGInfo(btn,record) {
    var wzzdStore = DSYGrid.getGrid('wzzd_grid_fg').getStore();
    var store_data = new Array();
    for (var j = 0; j < wzzdStore.getCount(); j++) {
        var wzzdrecord = wzzdStore.getAt(j);
        var var$bf_hl = wzzdrecord.get("QR_HL");
        var var$bf_date = wzzdrecord.get("BF_DATE");
        var var$zhyb_amt = wzzdrecord.get("ZHYB_AMT");

        if (!(var$bf_hl != null && var$bf_hl != undefined && var$bf_hl != "")) {
            Ext.Msg.alert('提示', "明细中确认汇率不能为空！");
            return;
        }
        if (!(var$zhyb_amt != null && var$zhyb_amt != undefined && var$zhyb_amt != "" && var$zhyb_amt!=0)) {
            Ext.Msg.alert('提示', "明细中拨付折合原币不能为空！");
            return;
        }
        if (!(var$bf_date != null && var$bf_date != undefined && var$bf_date != "")) {
            Ext.Msg.alert('提示', "明细中确认日期不能为空！");
            return;
        }
        wzzdrecord.data.BF_DATE = (wzzdrecord.get("BF_DATE") == null || wzzdrecord.get("BF_DATE") == "") ? "" : format(wzzdrecord.get("BF_DATE"), 'yyyy-MM-dd');
        store_data.push(wzzdrecord.data)
    }
    var form = btn.up('window').down('form');
    var formData = form.getForm().getFieldValues();
    if (formData.KT_AMT+0.01 < formData.SQBF_AMT) {
        Ext.MessageBox.alert('提示', '提款总金额不能大于可提款金额！');
        return;
    }
    btn.setDisabled(true);
    $.post('updateConfirmStatusFG_Cq.action', {
        WZZD_GRID: Ext.util.JSON.encode(store_data),
        WZXY_ID:WZXY_ID
    }, function (data) {
        if (data.success) {
            var wfgAmt = data.wfgAmt;
            initZwqrInfo(btn,record,wfgAmt);
            btn.up('window').close();
        } else {
            Ext.MessageBox.alert('提示', '确认失败！' + data.message);
            btn.setDisabled(false);
        }
    }, 'JSON');
}
/**
 * 初始化债券转贷表单
 */
function initEditor_fg() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'tksq_edit_form_fg',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 120//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '外债协议ID',
                        disabled: false,
                        name: "DATA_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目提款主单ID',
                        disabled: false,
                        name: "XMTK_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债名称',
                        name: "WZXY_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '大项目',
                        name: "SJXM_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权类型',
                        name: "ZQFL_ID",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权人',
                        name: "ZQR_ID",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权人全称',
                        name: "ZQR_FULLNAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '币种',
                        name: "FM_ID",
                        editable: false,//禁用编
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '汇率',
                        name: "HL_RATE",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '协议金额（原币）',
                        name: "WZXY_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '协议金额人民币',
                        name: "WZXY_AMT_RMB",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 120//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '已提款金额（原币）',
                        name: "YT_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '可提款金额（原币）',
                        name: "KT_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '提款总金额（原币）',
                        name: "SQBF_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            initWindow_input1_contentForm_grid_fg()
        ]
    });
}

/**
 * 初始化债券转贷表单中转贷明细信息表格
 */
function initWindow_input1_contentForm_grid_fg() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "提款ID",
            dataIndex: "XMTK_ID",
            type: "string",
            width: 100,
            editable: true,
            hidden: true
        },
        {
            text: "提款登记单ID",
            dataIndex: "TKDJMX_ID",
            type: "string",
            width: 100,
            editable: true,
            hidden: true
        },
        {
            dataIndex: "XM_ID",
            type: "string",
            text: "项目ID",
            width: 300,
            editable: false,
            hidden: true,
            renderer: function (data, cell, record) {
                if (record.get('XM_ID') != null && record.get('XM_ID') != '') {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = "IS_RZXM";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            text: "项目",
            width: 300,
            editable: false,
            renderer: function (data, cell, record) {
                if (record.get('XM_ID') != null && record.get('XM_ID') != '') {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = "IS_RZXM";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {
            dataIndex: "AD_CODE",
            type: "string",
            text: "地区CODE",
            editable: true,
            width: 150,
            hidden: true
        },
        {
            dataIndex: "AD_NAME",
            type: "string",
            text: "地区",
            editable: true,
            width: 150
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            text: "单位",
            width: 200,
            editable: true
        },
        {
            dataIndex: "AG_CODE",
            type: "string",
            text: "单位",
            editable: true,
            hidden: true,
            width: 200
        },
        {
            dataIndex: "AG_ID",
            type: "string",
            text: "单位id",
            editable: true,
            hidden: true
        },
        {
            dataIndex: "JSDW",
            type: "string",
            text: "建设单位",
            width: 200,
            editable: true
        },
        {
            dataIndex: "HKDW",
            type: "string",
            text: "还款单位",
            editable: true,
            width: 200
        },
        {
            text: "贷款性质",
            type: "string",
            dataIndex: "DKXZ",
            width: 100
        },
        {
            dataIndex: "ZCLX_NAME",
            type: "string",
            text: "支付类别",
            width: 100,
            editable: true
        },
        {
            dataIndex: "SQS_NO",
            type: "string",
            text: "申请书编号",
            width: 150,
            editable: true
        },
        {
            dataIndex: "SQTK_AMT",
            type: "float",
            text: "拨付金额",
            width: 150,
            editable: true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        // {
        //     dataIndex: "BF_AMT",
        //     type: "float",
        //     text: "拨付金额(人民币)",
        //     width: 150,
        //     editable: true,
        //     summaryType: 'sum',
        //     summaryRenderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     },
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00');
        //     }
        // },
        {
            text: "币种",
            type: "string",
            dataIndex: "FM_ID",
            width: 100
        },
        {
            text: "币种ID",
            type: "string",
            dataIndex: "FMID",
            width: 100,
            hidden: true
        },
        {
            dataIndex: "QR_HL",
            type: "float",
            text: "确认汇率",
            width: 100,
            tdCls: 'grid-cell',
            editor: {
                xtype: "numberfield",
                decimalPrecision: 7,
                regex: /^\d+(\.[0-9]{1,6})?$/,
                hideTrigger: true,
                mouseWheelEnabled: false,
                minValue: 0,
                allowBlank: false
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            dataIndex: "BF_HL",
            type: "float",
            text: "拨付汇率",
            width: 100,
            tdCls: 'grid-cell',
            hidden: true,
            editor: {
                xtype: "numberfield",
                decimalPrecision: 7,
                regex: /^\d+(\.[0-9]{1,6})?$/,
                hideTrigger: true,
                mouseWheelEnabled: false,
                minValue: 0,
                allowBlank: false
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "拨付折合原币金额",
            dataIndex: "ZHYB_AMT",
            type: "float",
            width: 180,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            tdCls: 'grid-cell',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            text: "确认日期",
            dataIndex: "BF_DATE",
            type: "string",
            width: 100,
            tdCls: 'grid-cell',
            editor: {
                xtype: "datefield",
                allowBlank: false,
                format: 'Y-m-d',
                value: new Date()
            },
            renderer: function (value) {
                if (value != null && value != undefined && value != '') {
                    return format(value, 'yyyy-MM-dd');
                }
            }
        },
        {
            dataIndex: "ZH_NAME",
            type: "string",
            text: "账户名称",
            editable: true,
            width: 150
        },
        {
            dataIndex: "ZH_TYPE",
            type: "string",
            text: "账户类型",
            editable: true,
            hidden: true,
            width: 100
        },
        {
            dataIndex: "ACCOUNT",
            type: "string",
            text: "账号",
            editable: true,
            width: 150
        },
        {
            dataIndex: "ZH_BANK",
            type: "string",
            text: "开户银行",
            editable: true,
            width: 150
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            editable: true,
            width: 300
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'wzzd_grid_fg',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: true,
        dataUrl: 'getZwqrDetailInfoFG_Cq.action',
        params: {
            WZXY_ID: WZXY_ID
        },
        features: [{
            ftype: 'summary'
        }],
        checkBox: true,   //显示复选框
        border: false,
        flex: 1,
        height: '100%',
        width: '100%',
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'wzzd_grid_plugin_cell2',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            beforeedit: function (editor, context) {
                if (context.field != 'BF_DATE' && context.field != 'QR_HL' && context.field != 'ZHYB_AMT') {
                    return false;
                }
            },
            edit: function (editor, context) {
                //拨付汇率改变时计算折合原币
                if (context.field == 'QR_HL' && context.originalValue != context.value) {
                    if(context.record.get('QR_HL') != '0.000000' && context.record.get('QR_HL') != null && context.record.get('QR_HL') != undefined ){
                        context.record.set('ZHYB_AMT',Math.floor((context.record.get('SQTK_AMT') / context.value) * 100) / 100 );

                    }else{
                        context.record.set('ZHYB_AMT', "");
                    }
                    var self = grid.getStore();
                    var input_bf_amp = 0.00;
                    self.each(function (record) {
                        input_bf_amp += record.get('ZHYB_AMT');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                }
                // 拨付折合原币计算
                if (context.field == 'ZHYB_AMT' && context.originalValue != context.value) {
                    var self = grid.getStore();
                    var input_bf_amp = 0.00;
                    self.each(function (record) {
                        input_bf_amp += record.get('ZHYB_AMT');
                    });
                    Ext.ComponentQuery.query('numberFieldFormat[name="SQBF_AMT"]')[0].setValue(input_bf_amp);
                }
            }
        }
    });
    return grid;
}
/**
 * 初始化债务确认(咨询，其他)主单信息
 */
function  initZwqrInfo(btn,record,wfgAmt){
    ZWFG_ID = GUID.createGUID();
    init_edit_tksq(btn).show();

    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
    var result = DebtEleStore(json_debt_xmfl).findRecord('id', record.XMFL, 0, false, true, true);
    if(result!=null && result!="" ){
        record.XMFL = result.get('name');
    }else{
        record.XMFL=null;
    }
    if(wfgAmt!='' && wfgAmt!=null){
        record.WFG_AMT = wfgAmt;
        record.FG_AMT = wfgAmt;
    }

    Ext.ComponentQuery.query('textfield[name="ZWFG_ID"]')[0].setValue(ZWFG_ID);
    form.setValues(record);//将记录中的数据写进form表中
}

/**
 * 初始化外债选择弹出框表格
 */
function initWindow_xmtksq_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 40
        },
        {
            dataIndex: "WZXY_ID",
            type: "string",
            text: "主键ID",
            fontSize: "15px",
            hidden: true
        },
        {
            type: "string",
            text: '地区',
            dataIndex: "AD_NAME",
            width: 150
        },
        {
            dataIndex: "WZXY_CODE",
            type: "string",
            width: 150,
            text: "外债编码",
            hidden: true
        },
        {
            type: "string",
            text: '外债名称',
            dataIndex: "WZXY_NAME",
            width: 300
        },
        {
            type: "string",
            text: '大项目',
            dataIndex: "SJXM_NAME",
            width: 300
        },
        {
            text: '建设状态',
            type: "string",
            dataIndex: "JSZT",
            width: 100
        },
        {
            text: '协议金额(原币)',
            dataIndex: "WZXY_AMT",
            width: 200,
            type: "float",
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            type: "string",
            text: '币种',
            dataIndex: "FM_ID",
            width: 100
        },
        {
            type: "float",
            text: '汇率',
            dataIndex: "HL_RATE",
            width: 100,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000##');
            }
        },
        {
            type: "string",
            text: '协议金额(人民币)',
            dataIndex: "WZXY_AMT_RMB",
            width: 200,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        // {
        //     type: "string",
        //     text: '未确认金额(原币)',
        //     dataIndex: "WFG_AMT",
        //     width: 200,
        //     align: 'right',
        //     renderer: function (value) {
        //         return Ext.util.Format.number(value, '0,000.00####');
        //     }
        // },
        {
            type: "string",
            text: '确认总金额',
            dataIndex: "FG_AMT",
            width: 200,
            hidden: true,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            type: "string",
            text: '债权类型',
            align: 'center',
            dataIndex: "ZQFL_ID",
            width: 100
        },
        {
            type: "string",
            text: '签订日期',
            dataIndex: "SIGN_DATE",
            width: 100
        },
        {
            type: "string",
            text: '债权人',
            dataIndex: "ZQR_ID",
            width: 150
        },
        {
            type: "string",
            text: '债权人全称',
            dataIndex: "ZQR_FULLNAME",
            width: 150
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'wzSelectionGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        checkBox: true,
        border: false,
        autoLoad: true,
        height: '100%',
        tbarHeight: 50,
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        params: {
            ad_code: ad_code
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        tbar: [
            {
                xtype: "textfield",
                name: "mhcx",
                id: "mhcx",
                fieldLabel: '模糊查询',
                allowBlank: true,  // requires a non-empty value
                labelWidth: 70,
                width: 260,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['mhcx'] = self.getValue();
                            // 刷新表格
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                    btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                    btn.up('grid').getStore().loadPage(1);

                }
            }
        ],
        dataUrl: 'getWzxyZwfgSelect_Cq.action'
    });
}

/**
 * 创建并弹出债务确认信息窗口
 */
function init_edit_tksq(btn, record) {
    return Ext.create('Ext.window.Window', {
        title: '债务分割',
        itemId: 'jjxxadd',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 添加
        frame: true,
        constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'fit',
        defaults: {
            split: true,                  //是否有确认线
            collapsible: false           //是否可以折叠
        },
        closeAction: 'destroy',
        items: [initEditor()],
        buttons: [
            {
                text: '保存',
                name: 'btn_update',
                id: 'save',
                handler: function (btn) {
                    saveXmtkInfo(btn);
                }
            },
            {
                //xtype: 'button',
                text: '取消',
                name: 'btn_delete',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

/**
 * 初始化债务确认主单表格
 */
function initEditor() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'tksq_edit_form',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 150//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '债务确认ID',
                        disabled: false,
                        name: "ZWFG_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债协议ID',
                        disabled: false,
                        name: "WZXY_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '地区',
                        name: "AD_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债名称',
                        name: "WZXY_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '大项目',
                        name: "SJXM_NAME",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '协议号',
                        name: "WZXY_NO",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '协议日期',
                        name: "SIGN_DATE",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    },
                    // {
                    //     xtype: "textfield",
                    //     fieldLabel: '债务类型',
                    //     name: "XMFL",
                    //     editable: false,//禁用编辑
                    //     fieldStyle: 'background:#E6E6E6'
                    // },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '未确认金额（原币）',
                        name: "WFG_AMT",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true

                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '币种',
                        name: "FM_ID",
                        editable: false,//禁用编
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '汇率',
                        name: "HL_RATE",
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'
                    }
                ]
            },
            {//确认线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 150//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "datefield",
                        fieldLabel: '<span class="required">✶</span>确认日期',
                        name: "FG_DATE",
                        editable: true,
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择确认日期',
                        emptyText: '请选择确认日期',
                        value: new Date(),
                        listeners: {
                            'change': function (self, newValue, oldValue, eOpts) {
                                // var grid = DSYGrid.getGrid('wzzd_grid');
                                // var store = grid.getStore();
                                // for (var j = 0; j < store.getCount(); j++) {
                                //     var wzzdrecord = store.getAt(j);
                                //     if(wzzdrecord.get('XM_ID') != null && wzzdrecord.get('XM_ID') != undefined && newValue != null && newValue != undefined ){
                                //         //获取提款限额
                                //         var records = kt_amt_store.data.filterBy('XM_ID', wzzdrecord.get('XM_ID'));
                                //         var record = records.filterBy('SET_YEAR',format(newValue, 'yyyy'));
                                //         if(record.items.length==0){
                                //             wzzdrecord.set('KT_RMB',0);
                                //         }else{
                                //             wzzdrecord.set('KT_RMB', record.items[0].get("AMT"));
                                //         }
                                //     }else{
                                //         wzzdrecord.set('KT_RMB',0);
                                //     }
                                // }
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>确认总金额',
                        name: "FG_AMT",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        allowBlank: false,
                        editable: false,//禁用编
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '备注',
                        name: "REMARK",
                        editable: true,
                        columnWidth: .99,
                        allowBlank: true
                    }
                ]
            },
            {//确认线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            initWindow_input1_contentForm_grid()
        ]
    });
}

/**
 * 初始化债务确认明细单表格
 */
function initWindow_input1_contentForm_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 40,
            summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "债务确认明细单ID",
            dataIndex: "ZWFGMX_ID",
            type: "string",
            width: 100,
            editor: 'textfield',
            hidden: true
        },
        {
            text: '债务ID',
            dataIndex: 'ZW_ID',
            type: "string",
            hidden:true
        },
        {
            text: '地区',
            dataIndex: 'AD_NAME',
            type: "string",
            width: 150,
            tdCls: 'grid-cell-unedit'
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            text: "单位名称",
            width: 200,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: '项目',
            dataIndex: 'XM_NAME',
            type: "string",
            width: 300,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: '项目ID',
            dataIndex: 'XM_ID',
            type: "string",
            width: 300,
            hidden:true,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: '项目建设状态',
            dataIndex: 'BUILD_STATUS',
            type: "string",
            hidden:true,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: '项目贷款性质',
            dataIndex: 'ZWLB',
            type: "string",
            hidden:true,
            tdCls: 'grid-cell-unedit'
        },
        {
            dataIndex: "ZWLB_NAME",
            type: "string",
            width: 100,
            text: "项目贷款性质",
            tdCls: 'grid-cell-unedit'
        },

        {
            dataIndex: "ZD_AMT",
            type: "float",
            text: "转贷金额(原币)",
            width: 180,
            tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZWYE_AMT",
            type: "float",
            text: "债务余额(原币)",
            width: 180,
            tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "FG_AMT",
            type: "float",
            text: "本次确认金额(原币)",
            width: 180,
            summaryType: 'sum',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            text: "币种",
            dataIndex: "FM_ID",
            type: "string",
            width: 150,
            hidden:true,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                allowBlank: false,
                store: wbStore
            },
            renderer: function (value) {
                var record = wbStore.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "汇率",
            type: "float",
            dataIndex: "FG_HL",
            width: 100,
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
        },
        {
            text: "拨付日期",
            dataIndex: "BF_DATE",
            type: "string",
            width: 100,
            editor: {
                xtype: "datefield",
                allowBlank: false,
                format: 'Y-m-d'
            },
            renderer: function (value) {
                if (value != null && value != undefined && value != '') {
                    return format(value, 'yyyy-MM-dd');
                }
            }
        },
        {
            dataIndex: "KT_RMB",
            type: "float",
            text: "可确认金额(人民币)",
            width: 180,
            editable: true,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "FG_RMB",
            type: "float",
            text: "本次确认金额(人民币)",
            width: 180,
            summaryType: 'sum',
            editable: true,
            tdCls: 'grid-cell-unedit',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        height: '100%',
        width: '100%',
        itemId: 'wzzd_grid',
        flex: 1,
        checkBox: true,   //显示复选框
        border: false,
        autoLoad: true,
        features: [{
            ftype: 'summary'
        }],
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        params: {
            WZXY_ID: WZXY_ID,
            ZWFG_ID:ZWFG_ID,
            button_name:button_name
        },
        dataUrl: 'getZwfgGridData_Cq.action',
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'wzzd_grid_plugin_cell2',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            edit: function (editor, context) {
                //根据币种显示汇率
                if (context.field == 'FM_ID' && context.originalValue != context.value) {
                    var result = rateStore.findRecord('code', context.value, 0, false, true, true);
                    if (result != null) {
                        context.record.set('FG_HL', result.get("roe"));
                        context.record.set('FG_RMB',Math.floor((context.record.get('FG_AMT') * context.record.get('FG_HL')) * 100) / 100 );
                    }
                }
                //拨付折合原币计算
                if (context.field == 'FG_AMT' && context.originalValue != context.value) {
                    context.record.set('FG_RMB',Math.floor((context.value * context.record.get('FG_HL')) * 100) / 100 );
                    var self = grid.getStore();
                    var input_bf_amp = 0.00;
                    self.each(function (record) {
                        input_bf_amp += record.get('FG_AMT');
                    });
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();
                    var formData = form.getValues();
                    var WFG_AMT = formData.WFG_AMT;
                    if(input_bf_amp>WFG_AMT){
                        Ext.MessageBox.alert('提示', '确认总金额不能大于未确认金额！');
                        context.record.set('FG_AMT',0);
                        return false;
                    }else{
                        Ext.ComponentQuery.query('numberFieldFormat[name="FG_AMT"]')[0].setValue(Math.floor((input_bf_amp) * 100) / 100);
                    }
                }
                if (context.field == 'BF_DATE' && context.originalValue != context.value) {
                    if(context.record.get('XM_ID') != null && context.record.get('XM_ID') != undefined && context.record.get('XM_ID') != "" ){
                        //获取提款限额
                        var records = kt_amt_store.data.filterBy('XM_ID', context.record.get('XM_ID'));
                        var record = records.filterBy('SET_YEAR',format(context.record.get('BF_DATE'), 'yyyy'));
                        if(record.items.length==0){
                            context.record.set('KT_RMB', 0);
                        }else{
                            context.record.set('KT_RMB', record.items[0].get("AMT"));
                        }
                    }
                }
                if (context.field == 'FG_HL' && context.originalValue != context.value) {
                    context.record.set('FG_RMB',Math.floor((context.record.get('FG_AMT') * context.value) * 100) / 100 );
                }
            }
        }
    });
    if(button_name=='apply'){
        grid.getStore().on('load', function () {
            var self = grid.getStore();
            if(self.getCount()!=0){
                //计算转贷总金额
                var sum_zd=0;
                for(var i=0;i<self.getCount();i++) {
                    var record = self.getAt(i);
                    sum_zd = sum_zd+record.get("ZD_AMT");
                }
                //获取债务确认总金额
                var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();
                var formData = form.getValues();
                var FG_AMT_SUM = formData.FG_AMT;
                var FG_SUM=0;
                for(var j=0;j<self.getCount();j++) {
                    var record = self.getAt(j);
                    if(j==self.getCount()-1){
                        //防止丢失精度
                        var FG_AMT = (FG_AMT_SUM*100-FG_SUM*100)/100;
                        record.set("FG_AMT",FG_AMT);
                        FG_SUM=FG_SUM+FG_AMT;
                    }else{
                        var FG_AMT = Math.floor((record.get("ZD_AMT")/sum_zd*FG_AMT_SUM) * 100) / 100;
                        record.set("FG_AMT",FG_AMT);
                        FG_SUM=FG_SUM+FG_AMT;
                    }
                }
            }
        });
    }
    return grid;
}

/**
 * 保存债务确认信息
 */
function saveXmtkInfo(self) {
    var wzzdStore = DSYGrid.getGrid('wzzd_grid').getStore();
    var form = self.up('window').down('form');
    var formData = form.getForm().getFieldValues();
    if(formData.FG_AMT==0||formData.FG_AMT==null||formData.FG_AMT==""){
        Ext.Msg.alert('提示', "确认总金额不能为空或者0！");
        return;
    }
    if (form.isValid()) {
        var map =new Map();
        // var set_year = format(formData.FG_DATE, 'yyyy');
        for (var m = 0; m < wzzdStore.getCount(); m++) {
            var wzzdrecord = wzzdStore.getAt(m);
            var set_year = format(wzzdrecord.get("BF_DATE"), 'yyyy');
            var var$xm_id = wzzdrecord.get("XM_ID");
            var var$bf_amt = wzzdrecord.get("FG_RMB");
            var var$fm_id = wzzdrecord.get("FM_ID");
            var var$zwlb = wzzdrecord.get("ZWLB");
            var var$BUILD_STATUS = wzzdrecord.get("BUILD_STATUS");
            // if (!(var$fm_id != null && var$fm_id != undefined && var$fm_id != "" && var$fm_id != 0)) {
            //     Ext.Msg.alert('提示', "明细中币种不能为空！");
            //     return;
            // }
            if(var$zwlb !=null && var$zwlb != undefined && var$zwlb != "" && var$zwlb=='0101' && var$BUILD_STATUS=='01'){
                if(map.has(var$xm_id+set_year)){
                    var ole_rmb = map.get(var$xm_id+set_year);
                    map.set(var$xm_id+set_year,var$bf_amt+ole_rmb);
                }else{
                    map.set(var$xm_id+set_year,var$bf_amt);
                }
            }
        }
        var store_data = new Array();
        for (var j = 0; j < wzzdStore.getCount(); j++) {
            var wzzdrecord = wzzdStore.getAt(j);
            var var$fg_hl = wzzdrecord.get("FG_HL");
            var var$xm_id = wzzdrecord.get("XM_ID");
            var set_year = format(wzzdrecord.get("BF_DATE"), 'yyyy');
            var var$zwlb = wzzdrecord.get("ZWLB");
            var var$BUILD_STATUS = wzzdrecord.get("BUILD_STATUS");
            if (!(var$fg_hl != null && var$fg_hl != undefined && var$fg_hl != "" && var$fg_hl != 0)) {
                Ext.Msg.alert('提示', "明细中汇率不能为0！");
                return;
            }
            if(var$zwlb !=null && var$zwlb != undefined && var$zwlb != "" && var$zwlb=='0101' && var$BUILD_STATUS=='01'){
                //获取提款限额
                var tkxe ;
                var records = kt_amt_store.data.filterBy('XM_ID', wzzdrecord.get("XM_ID"));
                var record = records.filterBy('SET_YEAR',set_year);
                if(record.items.length==0){
                    tkxe=0;
                }else{
                    tkxe= record.items[0].get("AMT");
                }
                var tk = map.get(var$xm_id+set_year);
                if(tk>(tkxe+0.0001)){
                    Ext.Msg.alert('提示', "项目"+wzzdrecord.get("XM_NAME")+"的确认金额人民币高于当年确认限额！请检查数据。");
                    return;
                }
            }
            wzzdrecord.data.BF_DATE = (wzzdrecord.get("BF_DATE") == null || wzzdrecord.get("BF_DATE") == "") ? "" : format(wzzdrecord.get("BF_DATE"), 'yyyy-MM-dd');
            store_data.push(wzzdrecord.data)
        }
        self.setDisabled(true);
        $.post('saveZwfgInfo_Cq.action', {
            button_name: button_name,
            ZWFG_ID: formData.ZWFG_ID,
            WZXY_ID: formData.WZXY_ID,
            FG_AMT: formData.FG_AMT,
            REMARK: formData.REMARK,
            FG_DATE: format(formData.FG_DATE, 'yyyy-MM-dd'),
            WZZD_GRID: Ext.util.JSON.encode(store_data)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                self.up('window').close();
                // 刷新表格
                reloadGrid()
            } else {
                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                self.setDisabled(false);
            }

        }, 'JSON');
    }
}

/**
 * 删除
 */
function doworkupdate(records, btn) {
    var ids = new Array();
    var btn_name = btn.name;
    var btn_text = btn.text;
    for (var k = 0; k < records.length; k++) {
        var zwfg_id = records[k].get("ZWFG_ID");
        ids.push(zwfg_id);
    }

    $.post("zwfgDowork_Cq.action", {
        ids: Ext.util.JSON.encode(ids),
        btn_name: btn_name,
        btn_text: btn_text
    }, function (data_response) {
        data_response = $.parseJSON(data_response);
        if (data_response.success) {
            Ext.toast({
                html: btn_text + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.toast({
                html: btn_text + "失败！" + data_response.message,
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
 * 刷新界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    var BUILD_STATUS_ID = Ext.ComponentQuery.query('combobox#BUILD_STATUS_ID')[0].getValue();
    store.getProxy().extraParams = {
        mhcx: mhcx,
        BUILD_STATUS_ID:BUILD_STATUS_ID
    };
    //刷新
    store.loadPage(1);
    //刷新明细表
    DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();

}
