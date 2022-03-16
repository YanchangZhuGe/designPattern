document.title = '名录信息';


if (showGqjg == null || showGqjg == '' || showGqjg.toLowerCase() == 'null') {
    showGqjg = 0; // 默认不显示
}
//是否显示附件
if (showFj == null || showFj == '' || showFj.toLowerCase() == 'null') {
    showFj = 0; // 默认不显示
}

var json = [
    {id: "1", code: "1", name: "有"},
    {id: "0", code: "0", name: "无"}
];
var json1 = [
    {id: "1", code: "1", name: "是"},
    {id: "0", code: "0", name: "否"}
];
editFj=false;

/**
 * 页面初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
    var obj = new Object();
    var array1 = new Array();
    var array2 = new Array();
    array1.push("viewForm");
    array2.push({"id":"mlxxTab","first":1});
    obj["form"] = array1;
    obj["tab"] = array2;
    UI_Draw("ui_draw", obj, null);
});

/**
 * 初始化页面主要内容区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: {
            type: 'hbox',
            align: 'middle',
            pack: 'center'
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        items: [initWindow_mlxx_contentForm()]
    });
    loadMlxx();
}

function initWindow_mlxx_contentForm() {
    return Ext.create('Ext.form.Panel', {
        width: '90%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            anchor: '100%',
            margin: '0 0 2 0'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                anchor: '100%',
                layout: 'hbox',
                items: [
                    //{xtype: 'label', text: '单位名称:', width: 70},
                    {xtype: 'label', width: 200, flex: 5},
                    {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color", style: 'color:red',hidden:true}
                ]
            },
            initWindow_mlxz_contentForm_tab()
        ]
    });
}

function initWindow_mlxz_contentForm_tab(){
    var zcxxTab = Ext.create('Ext.tab.Panel', {
        anchor: '100% -17',
        activeTab: 0,
        itemId: 'mlxxTab',
        border: false,
        items: [
            {
                title: '名录信息',
                scrollable: true,
                items: createMlxx_view()
            },
            {
                title: '股权结构',
                layout: 'fit',
                hidden:showGqjg == 1?false:true,
                items: createGqjg()
            },
            {
                title: '名录退出',
                scrollable: true,
                hidden : true,
                items: mlxx_zx_view()
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                hidden:showFj == 1?false:true,
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        itemId: 'window_save_htxx_file_panel',
                        items: [mlxx_fj()]
                    }
                ]
            }
        ],
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                var grid = oldCard.down('grid');
                if (grid != null) {
                    for (var i = 0; i < grid.getPlugins().length; i++) {
                        if (grid.getPlugins()[i].ptype == 'cellediting' || grid.getPlugins()[i].ptype == 'rowediting') {
                            grid.getPlugins()[i].completeEdit();
                        }
                    }
                }
            }
        }
    });
    return zcxxTab;
}

/**
 * 名录新增
 * @returns {Ext.form.Panel}
 */
function createMlxx_view() {
    var panel = Ext.create('Ext.form.Panel', {
        name: 'viewForm',
        itemId: 'viewForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        defaults: {
            margin: '2 5 2 5'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .5,
                    labelWidth: 150//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '单位名称',
                        name: "AG_NAME",
                        value: AG_NAME,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '所属行政区划',
                        name: "AD_NAME",
                        value: AD_NAME,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                width: '100%',
                anchor: '100%',
                margin: '2 0 2 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .49,
                    //width: 315,
                    labelWidth: 150//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '主管单位',
                        name: "ZGDW",
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZGDWLX_ID",
                        store: DebtEleTreeStoreDB('DEBT_ZWDWLX'),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        fieldLabel: '单位类型',
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '组织机构代码',
                        name: "ZZJG_CODE",
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '统一社会信用代码',
                        name: "TYSHXY_CODE",
                        readOnly: true,
                        allowBlank: false,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "combobox",
                        name: "IS_GYXZBXM",
                        store: DebtEleStore(json),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        hidden:true,
                        fieldCls: 'form-unedit',
                        fieldLabel: '有无公益性资本项目'
                    }, {
                        xtype: "combobox",
                        name: "RZPTLX_ID",
                        store: DebtEleStoreDB('DEBT_RZPTLX'),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        fieldLabel: '融资平台分类',
                        hidden: true,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, /*{
                     xtype: "combobox",
                     name: "GQLX_ID",
                     store: DebtEleStoreDB('DEBT_GQLX'),
                     displayField: "name",
                     valueField: "id",
                     allowBlank: false,
                     readOnly: true,
                     editable: false,
                     fieldCls: 'form-unedit',
                     fieldLabel: '股权类型'
                     }, {
                     xtype: "combobox",
                     name: "HYLY_ID",
                     store: DebtEleStoreDB('DEBT_HYLY'),
                     displayField: "name",
                     valueField: "id",
                     allowBlank: false,
                     readOnly: true,
                     editable: false,
                     fieldCls: 'form-unedit',
                     fieldLabel: '行业领域'
                     },*/ {
                        xtype: "textfield",
                        fieldLabel: '法人代表姓名',
                        name: "FRDB_NAME",
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '法人代表联系电话',
                        name: "FRDB_TEL",
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '财务负责人姓名',
                        name: "CWFZR_NAME",
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '财务负责人联系电话',
                        name: "CWFZR_TEL",
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '平台地址',
                        name: "ADDRESS",
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        hidden:true,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '位置GIS',
                        name: "GIS",
                        readOnly: true,
                        editable: false,
                        hidden:true,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "numberFieldFormat",
                        fieldLabel: '员工/在校学生数量',
                        name: "YG_NUM",
                        hideTrigger: true,
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        hidden:true,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "combobox",
                        name: "IS_MLW",
                        store: DebtEleStore(json1),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        readOnly: true,
                        hidden: true,
                        disabled: true,
                        editable: false,
                        fieldCls: 'form-unedit',
                        fieldLabel: '是否名录内'
                    }, {
                        xtype: "combobox",
                        name: "IS_SJQR",
                        store: DebtEleStore(json1),
                        displayField: "name",
                        valueField: "id",
                        labelWidth: 300,
                        allowBlank: false,
                        fieldCls: 'form-unedit',
                        readOnly: true,
                        hidden: true,
                        disabled: true,
                        editable: false,
                        fieldLabel: '是否为2013年6月底审计结果确定的融资平台'
                    }, {
                        xtype: 'radiogroup',
                        fieldLabel: '是否为2014年底清理甄别确定的融资平台公司',
                        vertical: true,
                        labelWidth: 300,
                        items: [{
                            boxLabel: '是',
                            inputValue: '1',
                            readOnly: true,
                            name: 'IS_QLZBPT'
                        }, {
                            boxLabel: '否',
                            inputValue: '0',
                            readOnly: true,
                            name: 'IS_QLZBPT',
                            checked: true
                        }]
                    }, {//分割线
                        xtype: 'menuseparator',
                        width: '100%',
                        anchor: '100%',
                        margin: '2 0 2 0',
                        columnWidth: 1,
                        border: true,
                        hidden:true
                    }, {
                        xtype: 'checkboxgroup',
                        fieldLabel: '认定情况',
                        name: "RDQK",
                        hidden:true,
                        columns: 3,
                        vertical: true,
                        items: [
                            {
                                xtype: "checkboxfield",
                                boxLabel  : '审计认定',
                                name      : 'IS_SJQR',
                                inputValue: '1',
                                readOnly: true,
                                uncheckedValue : '0'
                            }, {
                                xtype: "checkboxfield",
                                boxLabel  : '银监认定',
                                name      : 'IS_YJRD',
                                inputValue: '1',
                                readOnly: true,
                                uncheckedValue : '0'
                            }, {
                                xtype: "checkboxfield",
                                boxLabel  : '政府认定',
                                name      : 'IS_MLW',
                                inputValue: '1',
                                readOnly: true,
                                uncheckedValue : '0'
                            }
                        ]
                    }, {
                        xtype: "combobox",
                        name: "PTZGLX_ID",
                        store: DebtEleStoreTable('DSY_V_ELE_PTZXFA'),
                        displayField: "name",
                        valueField: "id",
                        fieldCls: 'form-unedit',
                        hidden:true,
                        readOnly: true,
                        fieldLabel: '平台整改类型',
                        editable: false
                    }
                ]
            }
        ]
    });
    return panel;
}

/**
 * 股权结构表单
 */
function createGqjg() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "TZF_NAME",
            type: "string",
            text: "投资方全称",
            width: 150,
            editor: {xtype: 'textfield', allowBlank: false}
        },
        {
            dataIndex: "RJCZ_AMT",
            type: "float",
            text: "认缴出资额",
            width: 150,
            editor: {
                xtype: 'numberFieldFormat', minValue: 0,
                hideTrigger: true, decimalPrecision: 6
            },
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SJCZ_AMT",
            type: "float",
            text: "实缴出资额",
            width: 150,
            editor: {
                xtype: 'numberFieldFormat', minValue: 0,
                hideTrigger: true, decimalPrecision: 6
            },
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "CG_RATE",
            type: "float",
            text: "持股比例（%）",
            allowBlank: false,
            align: 'center',
            width: 150,
            editor: {
                xtype: 'numberFieldFormat', minValue: 0,
                hideTrigger: true, decimalPrecision: 6
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            width: 300,
            editor: 'textfield'
        }
    ];
    //设置表格属性
    var config = {
        itemId: 'gqjgGrid',   //股权结构
        height: 280,
        dataUrl: '',//'/rzpt/mlgl/getGqjg.action',
        autoLoad:false,
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        features: [{
            ftype: 'summary'
        }]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);

    grid.on('selectionchange', function (view, records) {
        grid.down('#shtzqkDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 名录注销
 */
function mlxx_zx_view() {
    /**
     * 主表格表头
     */
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {"dataIndex": "AG_NAME", "type": "string", "text": "平台名称", "width": 200},
        {"dataIndex": "AG_ID", "type": "string", hidden: true},
        {"dataIndex": "AG_CODE", "type": "string", hidden: true},
        {"dataIndex": "AD_NAME", "type": "string", "text": "所属行政区划", "width": 150},
        {"dataIndex": "AD_CODE", "type": "string", hidden: true},
        {"dataIndex": "ZGDW", "type": "string", "text": "主管单位", "width": 180},
        {"dataIndex": "BG_TYPE", "type": "string", "text": "变更类型","width": 160},
        {"dataIndex": "BG_TIME", "type": "string", "text": "变更时间","width": 160},
        {"dataIndex": "BG_REASON", "type": "string", "text": "变更原因","width": 160},
        {"dataIndex": "REMARK", "type": "string", "text": "备注","width": 160}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'mlzxGrid',
        border: false,
       // flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl:'',//'/rzpt/mlgl/getMlbgInfo.action',
        autoLoad: false,
        checkBox: true,
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

function mlxx_fj() {
    var grid = UploadPanel.createGrid({
        busiType: 'ET402',//业务类型
        busiId: MLXX_ID,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: editFj,//是否可以修改附件内容，默认为ture
        gridConfig: {
            itemId: 'window_mlxx_contentForm_tab_upload_grid'//若无，会自动生成，建议填写，特别是出现多个附件上传时
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

function loadZcsx() {

    var zcsxForm = Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0];
    zcsxForm.load({
        url: '/rzpt/zcsx/getAllZcsxInfo.action',
        params: {
            ZCSX_ID: ZCSX_ID
        },
        waitTitle: '请等待',
        //waitMsg: '正在加载中...',
        success: function (form_success, action) {
            var zcsxFormDate = action.result.data.zcsxForm;
            if (zcsxFormDate.IS_NOT_SYS_DW == 1) {
                zcsxFormDate.XM_ID_OUT = zcsxFormDate.XM_ID;
            } else {
                zcsxFormDate.XM_ID_IN = zcsxFormDate.XM_ID;
            }
            zcsxForm.getForm().setValues(zcsxFormDate);
            var shtzqkStore = action.result.data.shtzqkGrid;
            var shtzqkGrid = DSYGrid.getGrid('shtzqkGrid');
            shtzqkGrid.getStore().removeAll();
            shtzqkGrid.insertData(null, shtzqkStore);

            /* var syqkStore = action.result.data.syqkGrid;
             var syqkGrid = DSYGrid.getGrid('syqkGrid');
             syqkGrid.getStore().removeAll();
             syqkGrid.insertData(null, syqkStore);*/

            var nrysbStore = action.result.data.nrysbGrid;
            var nrysbGrid = DSYGrid.getGrid('nrysbGrid');
            nrysbGrid.getStore().removeAll();
            nrysbGrid.insertData(null, nrysbStore);

            var sjzcbStore = action.result.data.sjzcbGrid;
            var sjzcbGrid = DSYGrid.getGrid('sjzcbGrid');
            sjzcbGrid.getStore().removeAll();
            sjzcbGrid.insertData(null, sjzcbStore);

        },
        failure: function (form, action) {
            alert('加载失败');
            Ext.ComponentQuery.query('window[name="window_zcsxtb"]')[0].close();
        }
    });
}

function loadMlxx(){

    //基本信息
    var mlxxForm = Ext.ComponentQuery.query('form[name="viewForm"]')[0];
    $.post("/rzpt/mlgl/getMlxx.action", {
        MLXX_ID:MLXX_ID,
        AG_ID:AG_ID,
        AG_CODE:AG_CODE,
        AD_CODE:ADCODE
    }, function (data) {
        if (data.success==false) {
            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
            return;
        }
        var form_data = data[0];
        mlxxForm.getForm().setValues(data.data[0]);
        if (data.data[0].IS_SJQR == '1') {
            Ext.ComponentQuery.query('checkboxfield[name="IS_SJQR"]')[0].setValue('1');
        }
        if (data.data[0].IS_MLW == '1') {
            Ext.ComponentQuery.query('checkboxfield[name="IS_MLW"]')[0].setValue('1');
        }
    }, "json");

    //股权结构
    /*var gqjgGrid = DSYGrid.getGrid('gqjgGrid');
    gqjgGrid.getStore().getProxy().extraParams["ml_id"] = MLXX_ID;
    gqjgGrid.getStore().reload();*/

    //名录注销
    /*var mlzxGrid = DSYGrid.getGrid('mlzxGrid');
    mlzxGrid.getStore().getProxy().extraParams["ml_id"] = MLXX_ID;
    mlzxGrid.getStore().reload();*/
}

function initWin_zcsx_Fj() {
    var grid = UploadPanel.createGrid({
        busiType: 'ET401',//业务类型
        busiId: ZCSX_ID,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: false,//是否可以修改附件内容，默认为ture
        gridConfig: {
            itemId: 'window_htxxtb_contentForm_tab_upload_grid'//若无，会自动生成，建议填写，特别是出现多个附件上传时
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

