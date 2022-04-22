/**
 * 通用配置json
 */
var mlname = '';
var mlgl_json_common = {
    '100901': {
        "mlxz": {//名录新增
            jsFileUrl: 'mlxz.js'
        },
        "mlsh": {//名录审核
            jsFileUrl: 'mlsh.js'
        }
    }
};
var json = [
    {id: "1", code: "1", name: "有"},
    {id: "0", code: "0", name: "无"}
];
var json1 = [
    {id: "1", code: "1", name: "是"},
    {id: "0", code: "0", name: "否"}
];
var button_name = '';//当前操作按钮名称
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}
if (node_type == 'mlxz') {
    document.title = '名录新增';
} else {
    document.title = '名录新增审核';
}
//是否显示股权结构
if (showGqjg == null || showGqjg == '' || showGqjg.toLowerCase() == 'null') {
    showGqjg = 0; // 默认不显示
}
//是否显示附件
if (showFj == null || showFj == '' || showFj.toLowerCase() == 'null') {
    showFj = 0; // 默认不显示
}
var ml_id = null;
var editFj  = false;
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

    $.getScript(mlgl_json_common[wf_id][node_type].jsFileUrl, function () {
        initContent();
        if (mlgl_json_common[wf_id][node_type].callBack) {
            mlgl_json_common[wf_id][node_type].callBack();
        }
        UI_Draw("ui_draw", {'grid':['contentGrid']}, null);
    });
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
        border: true,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: mlgl_json_common[wf_id][node_type].items[mlgl_json_common[wf_id][node_type].defautItems]
            }
        ],
        items: mlgl_json_common[wf_id][node_type].items_content()
    });
}

/**
 * 初始化右侧panel放置表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        region: 'center',
        height: '100%',
        flex: 5,
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        //bodyStyle: 'border-width:0 1px 1px 0;',//设置panel边框有无，去掉上方边框
        items: [
            initContentGrid()
        ]
    });
}

/**
 * 树点击节点时触发，刷新content表格
 */
function reloadGrid() {
    if (AD_CODE == null || AD_CODE == '') {
        Ext.Msg.alert('提示', '请选择区划！');
        return;
    }
    var store = DSYGrid.getGrid('contentGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams['AD_CODE'] = AD_CODE;
    store.getProxy().extraParams['AG_CODE'] = AG_CODE;
    store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;
    store.getProxy().extraParams['wf_id'] = wf_id;
    store.getProxy().extraParams['node_code'] = node_code;
    //刷新
    store.loadPage(1);
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 获取选中汇总数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("ML_ID"));
    }
    if (btn.name == 'cancel' || (btn.name == 'down' && btn.text == '送审')) {
        Ext.MessageBox.confirm('提示', '确定' + btn.text + '选中记录？', function (button) {
            if (button == 'yes') {
                doWorkFlow_ajax(ids, btn, '');
            }
        });
    }
    if ((btn.name == 'down' && btn.text == '审核') || btn.name == 'back') {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + '意见',
            value: btn.name == 'back' ? '' : '同意',
            animateTarget: btn,
            fn: function (buttonId, text, opt) {
                if (buttonId === 'ok') {
                    doWorkFlow_ajax(ids, btn, text);
                }
            }
        });
    }
}
/**
 * 工作流发送ajax修改请求
 */
function doWorkFlow_ajax(ids, btn, text) {
    ///发送ajax请求，修改节点信息
    Ext.Ajax.request({
        url: '/rzpt/mlgl/doWorkFlowActionMlxz.action',
        params: {
            workflow_direction: btn.name,
            wf_id: wf_id,
            node_code: node_code,
            button_name: btn.text,
            audit_info: text,
            ids: ids
        },
        success: function (data) {
            var respText = Ext.util.JSON.decode(data.responseText);
            if (respText.success) {
                //保存日志
                saveLog(btn.text + '名录信息', 'BUTTON', '用户' + userCode + btn.text + '成功');
                Ext.toast({
                    html: btn.text + "成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                reloadGrid();
            } else {
                btn.setDisabled(false);
                Ext.MessageBox.alert('提示', btn.text + '失败！' + respText.message);
            }

        }
    });

}
//查询工作流信息
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        var ML_ID = records[0].get("ML_ID");

        fuc_getWorkFlowLog(ML_ID);
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
var window_mlxz_view = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function () {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_mlxz_view();
        }
        this.window.show();
    }
};
function initWindow_mlxz_view() {
    var buttons = [
        {
            text: '关闭',
            handler: function (btn) {
                btn.up('window').close();
            }
        }
    ];
    return Ext.create('Ext.window.Window', {
        title: '名录信息', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        name: 'window_mlxz', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
        //items: initWindow_mlxz_contentViewForm(),
        items: initWindow_mlxz_contentForm_view(),
        buttons: buttons
    });
}

function initWindow_mlxz_contentForm_view() {
    var panel = Ext.create('Ext.form.Panel', {
        name: 'mlxzForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        defaults: {
            margin: '2 5 2 5'
        },
        defaultType: 'textfield',
        //items:[mlxx_fj()]
        items:[initWindow_mlxz_contentForm_tab_view()]
    });
    return panel;
}

function initWindow_mlxz_contentForm_tab_view(){
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
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                hidden:showFj==1?false:true,
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
function createMlxx_view() {
    var panel = Ext.create('Ext.form.Panel', {
        name: 'viewForm',
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
                    columnWidth: .5,
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
                        xtype: "combobox",
                        name: "ZGDWLX_ID",
                        store: DebtEleStoreDB('DEBT_ZWDWLX'),
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
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "textfield",
                        fieldLabel: '位置GIS',
                        name: "GIS",
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "numberFieldFormat",
                        fieldLabel: '员工/在校学生数量',
                        name: "YG_NUM",
                        hideTrigger: true,
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    }, {
                        xtype: "combobox",
                        name: "IS_MLW",
                        store: DebtEleStore(json1),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit',
                        fieldLabel: '是否名录内'
                    }, {
                        xtype: "radiogroup",
                        labelWidth: 300,
                        vertical: true,
                        fieldLabel: '是否为2013年6月底审计结果确定的融资平台',
                        items: [{
                            boxLabel: '是',
                            inputValue: '1',
                            readOnly: true,
                            name: 'IS_SJQR'
                        }, {
                            boxLabel: '否',
                            inputValue: '0',
                            readOnly: true,
                            name: 'IS_SJQR',
                            checked: true
                        }]
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
            headerMark: 'star',
            width: 120,
            editor: {xtype: 'textfield', allowBlank: false}
        },
        {
            dataIndex: "RJCZ_AMT",
            type: "float",
            text: "认缴出资额",
            headerMark: 'star',
            width: 120,
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
            headerMark: 'star',
            width: 120,
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
            headerMark: 'star',
            allowBlank: false,
            align: 'center',
            width: 120,
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
        dataUrl: '/rzpt/mlgl/getGqjg.action',
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
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'gdzcCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if (!editFj) {
                            return false;
                        }
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                        /*if (context.field == 'RJCZ_AMT') {
                            shftz_hj_amt = DSYGrid.getGrid('gqjgGrid').getStore().sum('RJCZ_AMT');
                            var zcsxForm = Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0].getForm().getValues();
                            var XYTZ_AMT = zcsxForm['XYTZ_AMT'];
                            Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0].getForm().findField('ZFZC_AMT').setValue(XYTZ_AMT - shftz_hj_amt);
                        }*/
                    }
                }
            }
        ],
        tbar: [
            {
                xtype: 'button',
                text: '添加',
                width: 60,
                handler: function (btn) {
                    btn.up('grid').insertData(null, {});

                }
            },
            {
                xtype: 'button',
                itemId: 'shtzqkDelBtn',
                text: '删除',
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);

    //将增加删除按钮添加到表格中
    /*grid.addDocked({
        xtype: 'toolbar',
        layout: 'column',
        items:
    }, 0);*/
    grid.on('selectionchange', function (view, records) {
        grid.down('#shtzqkDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 附件上传
 */
/*function mlxx_fj() {
    if(button_name=='INPUT' || button_name=='UPDATE'){
        editFj =true;
    }
    return UploadPanel.createGrid({
        busiType: 'ET402',
        busiId: ml_id,
        editable: editFj,
        busiProperty: '%',//业务规则，默认为‘%’
        gridConfig: {
            anchor: '100% -170',
            //height:'100%',
        }
    });
}*/

function mlxx_fj() {
    var grid = UploadPanel.createGrid({
        busiType: 'ET402',//业务类型
        busiId: ml_id,//业务ID
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
/**
 * 初始化合同录入弹出窗口
 */
function initWindow_mlxz() {
    var buttons = [
        {
            text: '保存',
            name: 'save',
            handler: function (btn) {
                btn.setDisabled(true);
                //var form = btn.up('window').down('form');
                var gqjgData = [];
                DSYGrid.getGrid("gqjgGrid").getStore().each(function (record) {
                    gqjgData.push(record.getData());
                });
                var gqjgGrid = DSYGrid.getGrid("gqjgGrid");
                var gqjgResult = CheckItemEmpty(gqjgGrid.items,'gqjgGridCheck');
                var form = Ext.ComponentQuery.query('form[name="mlxxForm"]')[0];
                var result = CheckItemEmpty(form.items,'mlxzFormCheck');
                var ZGDWLX_ID = form.getForm().getValues().ZGDWLX_ID;
                if(result!='' || gqjgResult!=''){
                    Ext.MessageBox.alert('提示',result+"<br/>"+gqjgResult);
                    btn.setDisabled(false);
                }else if(ZGDWLX_ID==3 || ZGDWLX_ID==5){
                    if(gqjgData==''&&showGqjg == 1){
                        Ext.MessageBox.alert('提示',"请录入股权结构！");
                    }else{
                        var formValues = form.getForm().getValues();
                        Ext.Ajax.request({
                            url: '/rzpt/mlgl/addOrUpdateMlxx.action',
                            params: {
                                button_name: button_name,
                                formData: Ext.util.JSON.encode(formValues),
                                gqjgData: Ext.util.JSON.encode(gqjgData),
                                wf_id: wf_id,
                                node_code: node_code,
                                wf_status: WF_STATUS
                            },
                            success: function (data) {
                                var msg = '';
                                if (button_name == 'INPURT') {
                                    msg = '新增';
                                } else if (button_name == 'UPDATE') {
                                    msg = '修改';
                                }
                                var respText = Ext.util.JSON.decode(data.responseText);
                                if (respText.success) {
                                    //保存日志
                                    saveLog(msg+'名录信息','BUTTON','用户'+userCode+ msg+'成功');
                                    Ext.toast({
                                        html: msg + "成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    btn.up('window').close();
                                    reloadGrid();
                                } else {
                                    btn.setDisabled(false);
                                    Ext.MessageBox.alert('提示', msg + '失败!' + respText.message);
                                }

                            }
                        });
                    }
                    btn.setDisabled(false);
                }else{
                    var formValues = form.getForm().getValues();
                    Ext.Ajax.request({
                        url: '/rzpt/mlgl/addOrUpdateMlxx.action',
                        params: {
                            button_name: button_name,
                            formData: Ext.util.JSON.encode(formValues),
                            gqjgData: Ext.util.JSON.encode(gqjgData),
                            wf_id: wf_id,
                            node_code: node_code,
                            wf_status: WF_STATUS
                        },
                        success: function (data) {
                            var msg = '';
                            if (button_name == 'INPURT') {
                                msg = '新增';
                            } else if (button_name == 'UPDATE') {
                                msg = '修改';
                            }
                            var respText = Ext.util.JSON.decode(data.responseText);
                            if (respText.success) {
                                //保存日志
                                saveLog(msg+'名录信息','BUTTON','用户'+userCode+ msg+'成功');
                                Ext.toast({
                                    html: msg + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.up('window').close();
                                reloadGrid();
                            } else {
                                btn.setDisabled(false);
                                Ext.MessageBox.alert('提示', msg + '失败!' + respText.message);
                            }

                        }
                    });
                }
            }
        },
        {
            text: '关闭',
            handler: function (btn) {
                btn.up('window').close();
            }
        }
    ];
    return Ext.create('Ext.window.Window', {
        title: title, // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        name: 'window_mlxz', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
        items: initWindow_mlxz_contentForm(),
        buttons: buttons
    });
}

function initWindow_mlxz_contentForm() {
    var panel = Ext.create('Ext.form.Panel', {
        name: 'mlxzForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        defaults: {
            margin: '2 5 2 5'
        },
        defaultType: 'textfield',
        //items:[mlxx_fj()]
        items:[initWindow_mlxz_contentForm_tab()]
    });
    return panel;
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
                items: createMlxx()
            },
            {
                title: '股权结构',
                layout: 'fit',
                hidden:showGqjg == 1?false:true,
                items: createGqjg()
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
function createMlxx() {
    var panel = Ext.create('Ext.form.Panel', {
        itemId: 'mlxxForm',
        name: 'mlxxForm',
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
                        fieldLabel: '<span class="required">✶</span>单位名称',
                        name: "AG_NAME",
                        value: AG_NAME,
                        readOnly: true,
                        editable: false,
                        fieldCls: 'form-unedit'
                    },
                    {
                        xtype: "textfield",
                        hidden: true,
                        name: "AG_CODE",
                        value: AG_CODE
                    },
                    {
                        xtype: "textfield",
                        hidden: true,
                        name: "ML_ID"
                    },
                    {
                        xtype: "textfield",
                        hidden: true,
                        name: "AG_ID",
                        value: AG_ID
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>所属行政区划',
                        name: "AD_NAME",
                        allowBlank: false,
                        value: AD_NAME,
                        fieldCls: 'form-unedit',
                        editable: false
                    },
                    {
                        xtype: "textfield",
                        hidden: true,
                        name: "AD_CODE",
                        value: AD_CODE
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
                        fieldLabel: '<span class="required">✶</span>主管单位',
                        itemid:'ZGDW',
                        name: "ZGDW",
                        editable: true,
                        allowBlank: false,
                        fieldCls: 'form-edit'
                    },

                    {
                        xtype: "treecombobox",
                        name: "ZGDWLX_ID",
                        store: DebtEleTreeStoreDB('DEBT_ZWDWLX',{condition:" AND STATUS = '1' "}),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        rootVisible: false,
                        editable: false,
                        selectModel: 'leaf',
                        readOnly: canSelectDwlx?false:true,
                        fieldLabel: '<span class="required">✶</span>单位类型'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '组织机构代码',
                        name: "ZZJG_CODE",
                        emptyText: '请输入...',
                        // regex: /[^_IOZSVa-z\W]{9}/,///[A-Z0-9]{8}[A-Z0-9]{1}/,
                        regexText:'全国组织机构代码由八位数字（或大写拉丁字母）本体代码和一位数字（或大写拉丁字母）校验码组成，请修正后再提交（大写拉丁字母不使用I、O、Z、S、V）',
                        // maxLength: 9,
                        /*maxLengthText:'全国组织机构代码由八位数字（或大写拉丁字母）本体代码和一位数字（或大写拉丁字母）校验码组成，请修正后再提交（不使用I、O、Z、S、V）',*/
                        allowBlank : true,
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>统一社会信用代码',
                        name: "TYSHXY_CODE",
                        allowBlank : false,
                        fieldCls: 'form-unedit',
                        readOnly : true
                    },
                    {
                        xtype: "combobox",
                        name: "IS_GYXZBXM",
                        store: DebtEleStore(json_debt_yw),
                        displayField: "name",
                        valueField: "id",
                        value : '1',
                        allowBlank: false,
                        editable: false,
                        fieldLabel: '<span class="required">✶</span>有无公益性资本项目'
                    },
                    {
                        xtype: "combobox",
                        name: "RZPTLX_ID",
                        store: DebtEleStoreDB('DEBT_RZPTLX'),
                        displayField: "name",
                        valueField: "id",
                        value :'01',
                        allowBlank: false,
                        editable: false,
                        hidden: true,
                        disabled: true,
                        fieldLabel: '<span class="required">✶</span>融资平台分类'
                    },
                    /* {
                         xtype: "combobox",
                         name: "GQLX_ID",
                         store: DebtEleStoreDB('DEBT_GQLX'),
                         displayField: "name",
                         valueField: "id",
                         allowBlank: false,
                         editable: false,
                         fieldLabel: '<span class="required">✶</span>股权类型'
                     },
                     {
                         xtype: "combobox",
                         name: "HYLY_ID",
                         store: DebtEleStoreDB('DEBT_HYLY'),
                         displayField: "name",
                         valueField: "id",
                         allowBlank: false,
                         editable: false,
                         fieldLabel: '<span class="required">✶</span>行业领域'
                     },*/
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>法人代表姓名',
                        name: "FRDB_NAME",
                        emptyText: '请输入...',
                        validator : vd,
                        allowBlank: false,
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>法人代表联系电话',
                        name: "FRDB_TEL",
                        regex:/^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/,
                        regexText : '请输入合法的联系电话',
                        emptyText: '号码格式为:010-00000000或13711111111',
                        allowBlank: false,
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '财务负责人姓名',
                        validator : vd,
                        name: "CWFZR_NAME",
                        emptyText: '请输入...',
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '财务负责人联系电话',
                        name: "CWFZR_TEL",
                        regex:/^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/ ,
                        regexText : '请输入合法的联系电话',
                        emptyText: '号码格式为:010-00000000或13711111111',
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '平台地址',
                        name: "ADDRESS",
                        emptyText: '请输入...',
                        allowBlank: true,
                        editable: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '位置GIS',
                        name: "GIS",
                        emptyText: '请输入...',
                        editable: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '员工/在校学生数量',
                        name: "YG_NUM",
                        minText : '请输入正确的员工数',
                        regex: /^\d+$/,
                        hideTrigger: true,
                        emptyText: '请输入...',
                        regexText : '请输入合法员工/在校学生数量',
                        allowBlank: true,
                        editable: true
                    },
                    {
                        xtype: "combobox",
                        name: "IS_MLW",
                        store: DebtEleStore(json1),
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        value : '1',
                        editable: false,
                        hidden: true,
                        disabled: true,
                        fieldLabel: '<span class="required">✶</span>是否名录内'
                    },
                    {
                        xtype: "combobox",
                        name: "IS_SJQR",
                        store: DebtEleStore(json1),
                        displayField: "name",
                        valueField: "id",
                        labelWidth: 300,
                        allowBlank: false,
                        editable: false,
                        hidden: true,
                        disabled: true,
                        fieldLabel: '<span class="required">✶</span>是否为2013年6月底审计结果确定的融资平台'
                    },
                    {
                        xtype: 'radiogroup',
                        name:'QLZBPT',
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
                            name: 'IS_QLZBPT',
                            readOnly: true,
                            checked: true
                        }]
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        width: '100%',
                        anchor: '100%',
                        margin: '2 0 2 0',
                        columnWidth: 1,
                        border: true
                    },
                    {
                        xtype: 'checkboxgroup',
                        fieldLabel: '认定情况',
                        hidden:true,
                        name: "RDQK",
                        columns: 3,
                        vertical: true,
                        items: [
                            {
                                xtype: "checkboxfield",
                                boxLabel  : '审计认定',
                                name      : 'IS_SJQR',
                                inputValue: '1',
                                uncheckedValue : '0'
                            }, {
                                xtype: "checkboxfield",
                                boxLabel  : '银监认定',
                                name      : 'IS_YJRD',
                                inputValue: '1',
                                uncheckedValue : '0'
                            }, {
                                xtype: "checkboxfield",
                                boxLabel  : '政府认定',
                                name      : 'IS_MLW',
                                inputValue: '1',
                                uncheckedValue : '0'
                            }
                        ]
                    },
                    {
                        xtype: "combobox",
                        name: "PTZGLX_ID",
                        store: DebtEleStoreTable('DSY_V_ELE_PTZXFA'),
                        displayField: "name",
                        valueField: "id",
                        hidden:true,
                        fieldLabel: '平台整改类型',
                        editable: false
                    }/*,
                    {
                        xtype: 'radiogroup',
                        fieldLabel: '是否为指定的公益性项目建设单位',
                        vertical: true,
                        labelWidth: 300,
                        items: [{
                            boxLabel: '是',
                            inputValue: '1',
                            name: 'IS_GYXXMDW'
                        }, {
                            boxLabel: '否',
                            inputValue: '0',
                            name: 'IS_GYXXMDW',
                            checked: true
                        }]
                    }*/
                ]
            }
        ]
    });
    return panel;
}