/**
 * 页面初始化
 */
$(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    //动态加载js
    $.ajaxSetup({
        cache: true
    });
    //ajax加载js文件
    $.getScript(zqxm_json_common[node_type], function () {
        //如果工作流不存在或者工作流节点是填报节点，就初始化
        if (!wf_id || node_code == 1) {
            initContent();
            return false;
        }
        //ajax获取节点名称
        $.post("getWfNodeName.action", {
            wf_id: wf_id,
            node_code: node_code,
            flow_branch: (sys_right_model == '1'
                && (
                    (HAVE_SFJG == '1' && is_fxjh == '3')
                    || (HAVE_SFJG == '2' && is_fxjh == '1')
                    || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1'))
                    || is_fxjh == '0'
                    || is_fxjh == '5'
                    || HAVE_SFJG == '0'
                )
                && node_type != 'xmtzsh')
                ? 'BRANCH' : ''
        }, function (data) {
            data = eval(data);
            var nodeType = data[0].NODE_TYPE;
            //根据节点名称初始化状态下拉框store
            if (node_type == 'jhsh' || node_type == 'jhfh' || node_type == 'xmtzsh') {
                if (nodeType == "END" && is_zjfp == 0) {
                    json_zt = json_debt_zt2_4;
                } else {
                    if (is_zjfp == 1) {
                        json_zt = json_debt_zjfp1;
                    } else if (is_zjfp == 2) {
                        json_zt = json_debt_zjfp2;
                    } else {
                        json_zt = json_debt_zt2;
                    }
                }
            }
            initContent();
            //根据节点名称修改状态下拉框store
            var combobox_status = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]');
            if (typeof combobox_status != 'undefined' && combobox_status != null && combobox_status.length > 0 && json_zt != null) {
                combobox_status[0].setStore(DebtEleStore(json_zt));
            }
        });
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
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: zqxm_json_common.items[WF_STATUS]
            }
        ],
        items: zqxm_json_common.items_content ? zqxm_json_common.items_content() :
            [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    },
                    param: zqxm_json_common.items_content_tree_config,
                    items_tree: zqxm_json_common.items_content_tree
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧表格
            ]
    });
}

/**
 * 初始化右侧panel
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
        dockedItems: zqxm_json_common.items_content_rightPanel_dockedItems ? zqxm_json_common.items_content_rightPanel_dockedItems : null,
        items: zqxm_json_common.items_content_rightPanel_items ? zqxm_json_common.items_content_rightPanel_items() : [initContentGrid()]
    });
}


/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = HEADERJSON;

    var config = {
        itemId: 'contentGrid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        checkBox: true,
        selModel: {
            selType: (is_fxjh == '1') || node_type == 'jhhz' || node_type == 'jhtb' || node_type == 'jhsh' || node_type == 'xmtzsh' ? 'checkboxmodel' : 'cellmodel',
            mode: (is_fxjh == '1') || node_type == 'jhhz' || node_type == 'jhtb' || node_type == 'jhsh' || node_type == 'xmtzsh' ? "SIMPLE" : "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        border: false,
        autoLoad: false,
        height: '100%',
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/xzzqJhsb/getZqxmXzzqContentGrid_NoPageYHS.action',
        params: {
            node_type: node_type,
            is_fxjh: is_fxjh,//是否是发行计划
            bond_type_id: bond_type_id,//债券类型，01为一般债券，02为专项债券
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            is_zxzq: is_zxzq
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_zt),
                width: 110,
                labelWidth: 30,
                editable: false,
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
                        toolbar.add(zqxm_json_common.items[WF_STATUS]);
                        //刷新当前表格
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                    }
                },
            }
        ],
        listeners: {
            itemdblclick: function (self, record) {

            },
            validateedit: function (editor, e) {
                var value = e.record.get('APPLY_AMOUNT_TOTAL');
                if (e.field == 'APPLY_AMOUNT1' && is_zjfp == 0) {
                    var ov = e.value - e.originalValue;
                    e.record.set('APPLY_AMOUNT_TOTAL', ov + value);
                }
            }
        }
    };
    if (zqxm_json_common.item_content_grid_config) {
        config = $.extend(false, config, zqxm_json_common.item_content_grid_config);
    }
    if (node_type == "jhxjshNew") {
        delete config.tbar;
    }
    var contentGrid = DSYGrid.createGrid(config);
    return contentGrid;
}

/**
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid(param, param_detail) {
    if (zqxm_json_common.reloadGrid) {
        zqxm_json_common.reloadGrid(param);
    } else {
        var grid = DSYGrid.getGrid('contentGrid');
        if (grid) {
            var store = grid.getStore();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["bond_type_id"] = bond_type_id;
            if (typeof param != 'undefined' && param != null) {
                for (var i in param) {
                    store.getProxy().extraParams[i] = param[i];
                }
            }
            store.loadPage(1);
            //刷新
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid_detail')) {
                var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
                //如果传递参数不为空，就刷新明细表格
                if (typeof param_detail != 'undefined' && param_detail != null) {
                    for (var i in param_detail) {
                        store_details.getProxy().extraParams[i] = param_detail[i];
                    }
                    store_details.loadPage(1);
                } else {
                    store_details.removeAll();
                }
            }
        }
    }
}

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
        if (node_type == 'xmtz' || node_type == 'xmtzsh') {
            fuc_getWorkFlowLog(records[0].get("XMTZ_ID"), '')
        } else {
            fuc_getWorkFlowLog(records[0].get("ID"), sys_right_model == '1' ? 'BRANCH' : '');

            fuc_getWorkFlowLog(records[0].get("ID"), sys_right_model == '1'
            && (
                (HAVE_SFJG == '1' && is_fxjh == '3')
                || (HAVE_SFJG == '2' && is_fxjh == '1')
                || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))
                || is_fxjh == '0'
                || is_fxjh == '5'
                || HAVE_SFJG == '0'
            )
                ? 'BRANCH' : '');
        }
    }
}

/**
 * SYS_XZZQJH_XE_CHECK （限额是否强控制）
 * tsy
 * 限额强控制
 */
function xeqkz(tsy) {
    if (SYS_XZZQJH_XE_CHECK === '2') {//强控制
        Ext.MessageBox.alert('提示', tsy);
        return false;
    } else if (SYS_XZZQJH_XE_CHECK === '1') {//提示性控制
        Ext.MessageBox.confirm('提示', tsy, function (btn_yn) {
            if (btn_yn === 'yes') {
                return true;
            } else {
                return false;
            }
        });
    } else {
        return true;
    }
}

/**
 * 刷新投资计划Form信息
 */
function initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("tzjhGrid").getStore();
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZGS_AMT"]')[0].setValue(xmsyStore.sum('ZTZ_PLAN_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="LJWCTZ_AMT"]')[0].setValue(xmsyStore.sum('ZTZ_ACTUAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="YRZZJ"]')[0].setValue(xmsyStore.sum('RZZJ_ACTUAL_AMT') + xmsyStore.sum('XY_AMT_RMB'));
    Ext.ComponentQuery.query('numberFieldFormat[name="ZQRZ"]')[0].setValue(xmsyStore.sum('RZZJ_XJ'));
    Ext.ComponentQuery.query('numberFieldFormat[name="SCHRZ_AMT"]')[0].setValue(xmsyStore.sum('SCRZ_PLAN_AMT'));
}

/**
 * 刷新收支平衡Form信息
 */
function initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("xmsyGrid").getStore();
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZTR_AMT"]')[0].setValue(xmsyStore.sum('TOTAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZCB_AMT"]')[0].setValue(xmsyStore.sum('YSCB_HJ_AMT'));
}

//数据加载完，计算 计划总结
function calculateRzzjAmount(grid) {
    var store = grid.getStore();
    //自动计算年度总计划投资
    store.each(function (context) {
        //自动计算年度总总投资计划到位
        var SJBZ_PLAN_AMT = context.data.SJBZ_PLAN_AMT;
        var CZYS_PLAN_AMT = context.data.CZYS_PLAN_AMT;
        var RZZJ_PLAN_AMT = context.data.RZZJ_PLAN_AMT;
        var DWZC_PLAN_AMT = context.data.DWZC_PLAN_AMT;
        var QT_PLAN_AMT = context.data.QT_PLAN_AMT;
        var SCRZ_PLAN_AMT = context.data.SCRZ_PLAN_AMT;
        var ZTZ_PLAN_AMT = new Object(SJBZ_PLAN_AMT + CZYS_PLAN_AMT + RZZJ_PLAN_AMT + DWZC_PLAN_AMT + QT_PLAN_AMT + SCRZ_PLAN_AMT);
        context.set('ZTZ_PLAN_AMT', ZTZ_PLAN_AMT);
        //自动计算年度总总投资实际到位
        var SJBZ_ACTUAL_AMT = context.data.SJBZ_ACTUAL_AMT;
        var CZYS_ACTUAL_AMT = context.data.CZYS_ACTUAL_AMT;
        var RZZJ_ACTUAL_AMT = context.data.RZZJ_ACTUAL_AMT;
        var DWZC_ACTUAL_AMT = context.data.DWZC_ACTUAL_AMT;
        var QT_ACTUAL_AMT = context.data.QT_ACTUAL_AMT;
        var XY_AMT_RMB = context.data.XY_AMT_RMB;
        var ZTZ_ACTUAL_AMT = new Object(SJBZ_ACTUAL_AMT + CZYS_ACTUAL_AMT + RZZJ_ACTUAL_AMT + DWZC_ACTUAL_AMT + QT_ACTUAL_AMT + XY_AMT_RMB);
        context.set('ZTZ_ACTUAL_AMT', ZTZ_ACTUAL_AMT);
    });
    initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();  //计算一遍  投资计划总结
}

/**
 * 收益平衡测算 Windows窗口
 */
function initwindow_xmcsInfo_select(config) {
    return Ext.create('Ext.window.Window', {
        title: '收益平衡测算', // 窗口标题
        itemId: 'window_input2', // 窗口标识
        layout: { // 12 种布局
            type: 'vbox',
            align: 'stretch'
        },
        maximizable: true,  // window 窗口最大化
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy', // hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        items: [
            initWindow_xmsyphcsInfo_contentForm(),
            {
                xtype: 'fieldset',
                title: '分年度预计收入情况',
                layout: 'fit',
                flex: 5.6,
                margin: '0 5 5 5',
                collapsible: false, //panel属性collapsible 的能控制收缩/展开按钮的出现位置
                items: [
                    initWindow_fndyjsrqkInfo_contentGrid(config)
                ]
            }
        ],
        buttons: [
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').destroy();
                }
            }
        ]
    });
}

/**
 * 初始化 收益平衡测算 弹出窗口中的 from表单信息
 */
function initWindow_xmsyphcsInfo_contentForm() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'content_form',
        name: 'xmsyForm',
        layout: 'column',
        border: false,
        flex: 1,
        margin: '5 5 4 5',
        defaults: {
            padding: '5 5 0 5',
            columnWidth: .33,
            labelWidth: 125,
        },
        defaultType: 'textfield',
        width: '100%',
        height: '100%',
        items: [
            {
                xtype: 'textfield',
                fieldLabel: '项目名称',
                name: 'XM_NAME',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                xtype: 'textfield',
                fieldLabel: '项目单位',
                name: 'AG_NAME',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                xtype: 'textfield',
                fieldLabel: '立项年度',
                name: 'LX_YEAR',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                xtype: "textfield",
                name: "XMXZ_NAME",
                fieldLabel: '项目性质',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                xtype: "textfield",
                fieldLabel: '项目类型',
                name: 'XMLX_NAME',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                xtype: 'numberFieldFormat',
                fieldLabel: '当年申请金额(万元)',
                decimalPrecision: 6,
                name: 'APPLY_AMOUNT1',
                type: "float",
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            }
        ]
    });
}

/**
 * 初始化 收益平衡测算 弹出窗口中的 分年度预计收入情况 页签信息
 */
function initWindow_fndyjsrqkInfo_contentGrid(config) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "INCOME_YEAR", type: "string", text: "年度", width: 100, tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStore(json_debt_year),
                maxValue: "",
                minValue: ""
            }
        },
        {
            text: "到期债务",
            columns: [
                {
                    text: "总计", dataIndex: "HJ_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "到期债务本金", dataIndex: "BJ_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "到期债务利息", dataIndex: "LX_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            text: "项目收益",
            columns: [
                {
                    text: "当年收入总计", dataIndex: "TOTAL_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "项目收益(扣除运营成本)", dataIndex: "SY_AMT", type: "float", width: 200,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "政府性基金收入", dataIndex: "ZFXJJ_AMT", type: "float", width: 200,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "项目运营财政补助收入", dataIndex: "CZBZ_AMT", type: "float", width: 200,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "项目其他经营收入", dataIndex: "WNRYS_AMT", type: "float", width: 200,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "其他收入", dataIndex: "QT_AMT", type: "float", width: 200,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "项目运营成本", dataIndex: "XM_YY_AMT", type: "float", width: 200,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}, summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmsyGrid',
        border: false,
        dataUrl: '/xzzqJhsb/getXmsyphcsInfoYHS.action',
        params: {
            xm_id: config.xm_id,
            bill_id: config.bill_id
        },
        autoScroll: true,
        checkBox: true,
        tbar: [
            '->',
            {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color", labelAlign: 'right'}
        ],
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    grid.getStore().on("load", function () {
        grid.getStore().sort('INCOME_YEAR', 'ASC');
    });
    return grid;
}

/**
 *
 */
function loadXmsyphceInfo(records) {
    var json = {};
    json = records[0].getData();
    var content_form = Ext.ComponentQuery.query('form[itemId="content_form"]')[0];
    /*var apply_amount1=records[0].data.APPLY_AMOUNT1;
        json.APPLY_AMOUNT1=apply_amount1/10000;*/
    content_form.getForm().setValues(json);
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
        //value: '同意',
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

// 负责人信息
function saveFZRxx(btn, AgAd_Code, AgAd_Name) {
    // 储备库,需求库的专项债券弹出
    if (is_fxjh == '0' && is_zxzq == '1') {
        window_fzr_info.show("填写负责人信息", AgAd_Code, AgAd_Name, btn);
        loadFzrInfo(AgAd_Code);
    } else {
        // 回调工作流
        if (typeof (doWorkFlow) == 'function') {
            doWorkFlow(btn, false);
        }
    }
}
//创建债券信息填报弹出窗口
var window_fzr_info = {
    window: null,
    show: function (title, AgAd_Code, AgAd_Name, btn) {
        this.window = initWindow_fzr(title, AgAd_Code, AgAd_Name, btn);
        this.window.show();
    }
};

/**
 * 初始化债券信息填报弹出窗口
 */
function initWindow_fzr(title, AgAd_Code, AgAd_Name, btn) {
    var btn_ = btn;
    return Ext.create('Ext.window.Window', {
        itemId: 'window_fzr', // 窗口标识
        name: 'window_fzr',
        title: title, // 窗口标题
        width: 512,//document.body.clientWidth * 0.6, //自适应窗口宽度
        height: 300,//document.body.clientHeight * 0.8, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_fzr_contentForm(AgAd_Name),
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    submitFzr(btn_, btn, AgAd_Code);
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
 * 初始化报表单
 */
function initWindow_fzr_contentForm(AgAd_Name) {
    var col_width = 400;
    var head = [
        {
            fieldLabel: '<span class="required">✶</span>单位名称',
            name: 'AG_NAME',
            emptyText: '请输入...',
            allowBlank: true,
            width: col_width,
            value: AgAd_Name,
            fieldStyle: 'background:#E6E6E6',
            readOnly: true,
        },
        {
            fieldLabel: '<span class="required">✶</span>单位负责人姓名',
            name: 'FZR_NAME',
            emptyText: '请输入...',
            width: col_width,
            allowBlank: false
        },
        {
            fieldLabel: '<span class="required">✶</span>身份证号',
            name: 'FZR_ID_CARD',
            emptyText: '请输入...',
            width: col_width,
            allowBlank: false,
            regex: /^[1-9]{1}[0-9]{14}$|^[1-9]{1}[0-9]{16}([0-9]|[xX])$/,
            regexText: '请输入正确身份证号',
        },
        {
            fieldLabel: '<span class="required">✶</span>联系电话',
            name: 'FZR_TEL',
            emptyText: '请输入...',
            width: col_width,
            allowBlank: false,
            regex: /^1(?:3\d|4[4-9]|5[0-35-9]|6[67]|7[013-8]|8\d|9\d)\d{8}$/,
            regexText: '请输入正确电话号码',
        },
        {
            xtype: 'label',
            fieldLabel: 'a',
            html: "<p id='text_zre'>&emsp;本单位承诺所填写信息真实、准确，如有任何虚假瞒报等问题，</br>本人愿意承担所有责任。</p>"
        }
    ];
    if (node_type == 'jhsh') {
        head = [
            {
                fieldLabel: '<span class="required">✶</span>单位名称',
                name: 'AD_NAME',
                emptyText: '请输入...',
                width: col_width,
                value: AgAd_Name,
                fieldStyle: 'background:#E6E6E6',
                allowBlank: true,
                readOnly: true,
            },
            {
                fieldLabel: '<span class="required">✶</span>单位负责人姓名',
                name: 'SHR_NAME',
                emptyText: '请输入...',
                width: col_width,
                allowBlank: false
            },
            {
                fieldLabel: '<span class="required">✶</span>身份证号',
                name: 'SHR_ID_CARD',
                emptyText: '请输入...',
                width: col_width,
                allowBlank: false,
                regex: /^[1-9]{1}[0-9]{14}$|^[1-9]{1}[0-9]{16}([0-9]|[xX])$/,
                regexText: '请输入正确身份证号',
            },
            {
                fieldLabel: '<span class="required">✶</span>联系电话',
                name: 'SHR_TEL',
                emptyText: '请输入...',
                width: col_width,
                allowBlank: false,
                regex: /^1(?:3\d|4[4-9]|5[0-35-9]|6[67]|7[013-8]|8\d|9\d)\d{8}$/,
                regexText: '请输入正确电话号码',
            },
            {
                xtype: 'label',
                fieldLabel: 'a',
                html: "<p id='text_zre'>&emsp;本单位承诺已对主管部门和项目单位填报信息进行了认真审核，</br>本人愿意承担审核责任。</p>"
            }
        ];
    }
    return Ext.create('Ext.form.Panel', {
        name: 'fzrForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            anchor: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                layout: 'column',
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 120,
                    // columnWidth: .333,
                    margin: '3 1 3 20'
                },
                items: head
            }
        ]
    });
}

function submitFzr(btn_, btn, AgAd_Code) {
    var msg = '保存责任人信息';
    var fzrForm = Ext.ComponentQuery.query('form[name="fzrForm"]')[0];
    if (!fzrForm.isValid()) {
        Ext.toast({
            html: "请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {}
        });
        return;
    }
    //发送ajax请求，修改节点信息
    $.post("/xzzqJhsb/saveFzrInfoYHS.action", {
        agCode: AgAd_Code,
        adCode: AgAd_Code,
        node_type: node_type,
        is_fxjh: is_fxjh,
        button_name: msg,
        fzrForm: encode64('[' + Ext.util.JSON.encode(fzrForm.getValues()) + ']'),
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: msg + "成功！" + (data.message ? data.message : ''),
                closable: false, align: 't', slideInDuration: 400, minWidth: 400
            });
            btn.up('window').close();
            // 回调工作流
            if (typeof (doWorkFlow) == 'function') {
                doWorkFlow(btn_, false);
            }
        } else {
            Ext.MessageBox.show({
                title: '提示',
                msg: msg + '失败！' + (data.message ? data.message : ''),
                minWidth: 300,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
        }
        //刷新表格
        reloadGrid();
    }, "json");
}

// 回填数据
function loadFzrInfo(AgAd_Code) {
    var fzrForm = Ext.ComponentQuery.query('form[name="fzrForm"]')[0];
    // 加载表单
    fzrForm.load({
        url: '/xzzqJhsb/loadFzrInfoYHS.action',
        params: {
            agCode: AgAd_Code,
            adCode: AgAd_Code,
            node_type: node_type,
            is_fxjh: is_fxjh,
        },
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            fzrForm.getForm().setValues(action.result.data.fzrForm);
        },
        failure: function (form, action) {
            // alert('加载失败');
            // Ext.ComponentQuery.query('window[name="window_fzr"]')[0].close();
        }
    });

}