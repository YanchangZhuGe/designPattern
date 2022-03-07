var v_child = '1';// 控制树展示方式
var button_name = '';// 按钮名称
var button_text = '';// 按钮text
var audit_info = '';// 意见
var zdjxpj_id = '';// 重点绩效评价主键ID
var xm_id = '';// 项目ID
var newYear = '';// 评价年度
var nowDate = Ext.Date.format(new Date(), 'Y-m-d');// 获取系统当前时间
var year = new Date().getUTCFullYear();//当前年份
var dsqxHaveDoneQr;// 地市是否需要确认参数
var IS_ALREADY_ZP = '0';// 判断是否已进行过自评
// 年度过滤条件
var json_debt_year = [
    {"id": "2020", "code": "2020", "name": "2020年"},
    {"id": "2021", "code": "2021", "name": "2021年"},
    {"id": "2022", "code": "2022", "name": "2022年"},
    {"id": "2023", "code": "2023", "name": "2023年"},
    {"id": "2024", "code": "2024", "name": "2024年"},
    {"id": "2025", "code": "2025", "name": "2025年"},
    {"id": "2026", "code": "2026", "name": "2026年"},
    {"id": "2027", "code": "2027", "name": "2027年"},
    {"id": "2028", "code": "2028", "name": "2028年"},
    {"id": "2029", "code": "2029", "name": "2029年"},
    {"id": "2030", "code": "2030", "name": "2030年"}
];
// 评分等级
var json_debt_pfdj = [
    {"id": "1", "code": "1", "name": "优"},
    {"id": "2", "code": "2", "name": "良"},
    {"id": "3", "code": "3", "name": "中"},
    {"id": "4", "code": "4", "name": "差"}
];
// 是否已经进行自评:0 已进行自评 or 1未进行自评
var json_debt_is_alerady_zp = [
    {"id": "0", "code": "0", "name": "已自评"},
    {"id": "1", "code": "1", "name": "未自评"},
];

// 状态：已确认/未确认
var json_debt_zt_qr = [
    {"id": "001", "code": "001", "name": "未确认"},
    {"id": "002", "code": "002", "name": "已确认"},
    {"id": "008", "code": "008", "name": "曾经办"}
];

/**
 * 通用配置json
 */
var zdjxpj_json_common = {
    // 地市重点项目绩效评价流程
    100925: {
        "zdjxpjlr": {jsFileUrl: 'zdjxpjlr.js'},
        "zdjxpjsh": {jsFileUrl: 'zdjxpjsh.js'},
        "zdjxpjqr": {jsFileUrl: 'zdjxpjqr.js'}
    },
    // 省级重点项目绩效评价流程
    100926: {
        "zdjxpjlr": {jsFileUrl: 'zdjxpjlr.js'},
        "zdjxpjsh": {jsFileUrl: 'zdjxpjsh.js'},
        "zdjxpjqr": {jsFileUrl: 'zdjxpjqr.js'}
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
    $.getScript(zdjxpj_json_common[wf_id][node_type].jsFileUrl, function () {
        initContent();
        if (zdjxpj_json_common[wf_id][node_type].callBack) {
            zdjxpj_json_common[wf_id][node_type].callBack();
        }
    });
});

/**
 * 初始化页面主要内容区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                 //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: 'contentPanel',
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'zdjxpj_contentPanel_toolbar',
                items: zdjxpj_json_common[wf_id][node_type].items[WF_STATUS]
            }
        ],
        items: zdjxpj_json_common[wf_id][node_type].items_content()
    });
}

/**
 * 初始化右侧panel，放置1个表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        width: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                layout: {
                    type: 'column'
                },
                defaults: {
                    margin: '5 5 5 5',
                    columnWidth: .20,
                    labelWidth: 100,
                    labelAlign: 'left'// 控件默认标签对齐方式
                },
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '评价年度',
                        itemId: 'JX_YEAR',
                        displayField: 'name',
                        valueField: 'code',
                        store: DebtEleStore(getYearList({start: -5, end: 5})),
                        editable: false,
                        labelAlign: 'left',
                        value: year,
                        labelWidth: 60,
                        columnWidth: .17,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'combobox',
                        fieldLabel: '综合评分等级',
                        itemId: 'LEVEL_NO',
                        displayField: 'name',
                        valueField: 'code',
                        store: DebtEleStore(json_debt_pfdj),
                        editable: false,
                        labelWidth: 90,
                        columnWidth: .19,
                        allowBlank: true,
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '项目类型',
                        itemId: 'XMLX_SEARCH',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: true,
                        lines: false,
                        selectModel: 'all',
                        store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"}),
                        labelWidth: 60,
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "XM_SEARCH",
                        emptyText: '请输入单位名称/项目名称/项目编码',
                        enableKeyEvents: true,
                        labelWidth: 60,
                        columnWidth: .30,
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
        items: zdjxpj_json_common[wf_id][node_type].items_content_rightPanel_items ? zdjxpj_json_common[wf_id][node_type].items_content_rightPanel_items() : [
            initContentGrid()
        ]
    });
}

/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            "dataIndex": "PRO_ID",
            "type": "string",
            "text": "项目ID",
            "fontSize": "15px",
            "hidden": true
        },
        {
            "dataIndex": "AGENCY_NAME",
            "type": "string",
            "text": "单位名称",
            "fontSize": "15px",
            "width": 230
        },
        {
            "dataIndex": "ZP_ID",
            "type": "string",
            "width": 250,
            "text": "绩效评价编码",
            "hidden": true
        },
        {
            "dataIndex": "PRO_NAME",
            "width": 250,
            "type": "string",
            "text": "项目名称",
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('PRO_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            "dataIndex": "PRO_CODE",
            "width": 150,
            "type": "string",
            "text": "项目编码"
        },
        {
            "dataIndex": "PJ_YEAR",
            "width": 150,
            "type": "string",
            "text": "评价年度"
        },
        {
            "dataIndex": "PJ_VALUE",
            "width": 150,
            "type": "string",
            "text": "得分",
            renderer: function (data, cell, record) {
                var url = '/page/debt/jxgl/jxpjgl/zdjxpj/zdjxpjYhsMain.jsp?YHS=YHS';
                var paramNames = new Array();
                paramNames[0] = "PJ_ID";
                paramNames[1] = "MOF_TYPE";
                paramNames[2] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('PJ_ID');
                paramValues[1] = MOF_TYPE;
                paramValues[2] = record.get('PRO_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            "dataIndex": "LEVEL_NO",
            "width": 150,
            "type": "string",
            "text": "综合评分等级",
            renderer: function (value, metaData, record) {
                if (value == '1') {
                    metaData.css = 'x-grid-back-green';
                    return '优';
                } else if (value == '2') {
                    metaData.css = 'x-grid-back-blue';
                    return '良';
                } else if (value == '3') {
                    metaData.css = 'x-grid-back-yellow';
                    return '中';
                } else if (value == '4') {
                    metaData.css = 'x-grid-back-red';
                    return '差';
                }
            }
        }/*,
        {
            "dataIndex": "NDZTMB",
            "width": 200,
            "type": "string",
            "text": "绩效目标实际完成情况"
        }*/
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'zdjxpj_contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '80%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: node_code == '1' ? DebtEleStore(json_debt_zt1) : node_code == '2' ? DebtEleStore(json_debt_zt2_4) : node_code == '4' ? DebtEleStore(json_debt_zt11) : DebtEleStore(json_debt_zt_qr),
                width: 110,
                allowBlank: false,
                editable: false,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#zdjxpj_contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(zdjxpj_json_common[wf_id][node_type].items[WF_STATUS]);
                        if (is_need_ds_qr == 'dsqx') {
                            if (WF_STATUS == '002') {
                                dsqxHaveDoneQr = '002';
                            } else {
                                dsqxHaveDoneQr = '';
                            }
                        }
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            }
        ],
        params: {
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            MOF_TYPE: MOF_TYPE,
            NODE_CODE: node_code,
            AG_CODE: AG_CODE,
            TREE_AD_CODE: AD_CODE,
            is_need_ds_qr: is_need_ds_qr,
            dsqxHaveDoneQr: dsqxHaveDoneQr,
            BMA: BMA
        },
        dataUrl: '/zdjxpj/getZdjxpjList.action',
        // dataUrl: is_need_ds_qr == 'dsqx' ? '/zdjxpj/getZdjxpjDsqxQrList.action' : '/zdjxpj/getZdjxpjList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
}

/**
 * 绩效评价送审/审核
 */
function next(btn) {
    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    //判断操作按钮
    if (node_type == 'zdjxpjlr') {
        button_name = '送审';
    } else if (node_type == 'zdjxpjsh') {
        button_name = '审核';
    } else if (node_type == 'zdjxpjqr') {
        button_name = '确认';
    }
    var jxzpArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("PJ_ID");
        array.PRO_ID = record.get("PRO_ID");
        array.MOF_DIV_CODE = record.get("MOF_DIV_CODE");
        jxzpArray.push(array);
    });
    //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    btn.setDisabled(true);
    //向后台传递变更数据信息
    $.post('/zdjxpj/nextZdjxpjInfo.action', {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        audit_info: audit_info,
        MOF_TYPE: MOF_TYPE,
        // is_need_ds_qr: is_need_ds_qr,
        jxzpArray: Ext.util.JSON.encode(jxzpArray)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
            reloadGrid();
        }
        btn.setDisabled(false);
    }, 'json');
}

/**
 * 绩效自评退回/撤销
 * @param btnName 按钮名称
 * @returns {boolean}
 */
function back(btnName) {
    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
    var jxzpArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("PJ_ID");
        array.PRO_ID = record.get("PRO_ID");
        jxzpArray.push(array);
    });
    //向后台传递变更数据信息
    $.post('/zdjxpj/backZdjxpjInfo.action', {
        wf_id: wf_id,
        node_code: node_code,
        button_name: btnName,
        button_text: button_text,
        audit_info: audit_info,
        MOF_TYPE: MOF_TYPE,
        jxzpArray: Ext.util.JSON.encode(jxzpArray)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            DSYGrid.getGrid("zdjxpj_contentGrid").getStore().loadPage(1);
        } else {
            Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
            DSYGrid.getGrid("zdjxpj_contentGrid").getStore().loadPage(1);
        }
    }, 'json');
}

/**
 * 操作记录
 */
function dooperation() {
    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        var PJ_ID = records[0].get("PJ_ID");
        fuc_getWorkFlowLog(PJ_ID);
    }
}

/**
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid(param) {
    if (zdjxpj_json_common[wf_id][node_type].reloadGrid) {
        zdjxpj_json_common[wf_id][node_type].reloadGrid(param);
    } else {
        var store = DSYGrid.getGrid('zdjxpj_contentGrid').getStore();
        var JX_YEAR = Ext.ComponentQuery.query('combobox#JX_YEAR')[0].getValue();// 绩效评价年度
        var LEVEL_NO = Ext.ComponentQuery.query('combobox#LEVEL_NO')[0].getValue();// 评价等级
        var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();// 项目类型ID
        var MHCX = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();// 模糊查询
        //增加查询参数
        var extraParams = {
            AG_CODE: AG_CODE,
            TREE_AD_CODE: AD_CODE,
            MHCX: MHCX,
            JX_YEAR: JX_YEAR,
            LEVEL_NO: LEVEL_NO,
            XMLX_ID: XMLX_ID,
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            MOF_TYPE: MOF_TYPE,
            NODE_CODE: node_code,
            is_need_ds_qr: is_need_ds_qr,
            dsqxHaveDoneQr: dsqxHaveDoneQr,
            BMA: BMA
        };
        extraParams = $.extend(true, [], extraParams, param);
        store.getProxy().extraParams = extraParams;
        //刷新
        store.loadPage(1);
    }
}