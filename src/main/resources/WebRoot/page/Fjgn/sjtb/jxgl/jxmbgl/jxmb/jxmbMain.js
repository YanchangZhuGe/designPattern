var v_child = '1';// 控制树展示方式
var button_name = '';// 按钮名称
var button_status = '';// 按钮text
var audit_info = '';// 意见
var jxmb_id = '';// 绩效目标主键ID
var xm_id = '';// 项目ID
var nowDate = Ext.Date.format(new Date(), 'Y-m-d');// 获取系统当前时间
var year = new Date().getUTCFullYear();//当前年份
var mbYear = year;// 目标年度
var is_fxjh = 0;
/*年度过滤条件*/
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
/**
 * 通用配置json
 */
var jxmb_json_common = {
    100915: {
        "jxmblr": {jsFileUrl: 'jxmblr.js'},
        "jxmbsh": {jsFileUrl: 'jxmbsh.js'}
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
    $.getScript(jxmb_json_common[wf_id][node_type].jsFileUrl, function () {
        initContent();
        if (jxmb_json_common[wf_id][node_type].callBack) {
            jxmb_json_common[wf_id][node_type].callBack();
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
                itemId: 'contentPanel_toolbar',
                items: jxmb_json_common[wf_id][node_type].items[WF_STATUS]
            }
        ],
        items: jxmb_json_common[wf_id][node_type].items_content()
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
                    labelAlign: 'left'//控件默认标签对齐方式
                },
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '目标年度',
                        itemId: 'JX_YEAR',
                        displayField: 'name',
                        valueField: 'code',
                        store: DebtEleStore(getYearList({start: -5, end: 5})),
                        editable: false,
                        labelAlign: 'left',
                        value: year,
                        labelWidth: 60,
                        columnWidth: .15,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                mbYear = newValue;
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
                        rootVisible: false,
                        lines: false,
                        selectModel: 'all',
                        allowBlank: true,
                        store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"}),
                        labelWidth: 60,
                        columnWidth: .17,
                        editable: false,
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
                        // width: 280,
                        emptyText: '请输入单位名称/项目名称/项目编码',
                        enableKeyEvents: true,
                        labelWidth: 60,
                        columnWidth: .25,
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
        items: [
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
            "width": 250
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
            "dataIndex": "TB_YEAR",
            "width": 150,
            "type": "string",
            "text": "目标年度"
        },
        {
            "dataIndex": "NDZTMB",
            "width": 250,
            "type": "string",
            "text": "年度总体目标"
        },
        {
            "dataIndex": "OPERATE",// 绩效目标一户式查看
            "width": 200,
            "type": "string",
            "align": "center",
            "text": "操作",
            renderer: function (data, cell, record) {
                var url = '/page/debt/jxgl/jxmbgl/jxmb/jxmbYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                paramNames[1] = "MB_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('PRO_ID');
                paramValues[1] = record.get('MB_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'contentGrid',
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
                store: node_code == '1' ? DebtEleStore(json_debt_zt1) : node_code == '2' ? DebtEleStore(json_debt_zt2) : DebtEleStore(json_debt_zt2_3),
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
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(jxmb_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            }
        ],
        params: {
            AG_CODE: AG_CODE,
            JX_YEAR: mbYear,
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            NODE_CODE: node_code,
            BMA: BMA
        },
        dataUrl: '/jxmbtb/getJxmbList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
}
/**
 * 绩效目标送审/审核
 */
function next(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    //判断操作按钮
    /*if (node_type == 'jxmblr') {
        button_name = '送审';
    } else if (node_type == 'jxmbsh') {
        button_name = '审核';
    }*/
    var jxmbArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("MB_ID");
        array.PRO_ID = record.get("PRO_ID");
        array.AD_CODE = record.get("AD_CODE");
        jxmbArray.push(array);
    });
    //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    btn.setDisabled(true);
    //向后台传递变更数据信息
    $.post('/jxmbtb/nextJxmbInfo.action', {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        audit_info: audit_info,
        is_end: is_end,
        jxmbArray: Ext.util.JSON.encode(jxmbArray)
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
 * 绩效目标退回/撤销
 * @param btnName 按钮名称
 * @returns {boolean}
 */
function back(btnName) {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    var jxmbArray = [];
    var mb_year = records[0].get("TB_YEAR");
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("MB_ID");
        array.PRO_ID = record.get("PRO_ID");
        jxmbArray.push(array);
    });
    //向后台传递变更数据信息
    $.post('/jxmbtb/backJxmbInfo.action', {
        wf_id: wf_id,
        node_code: node_code,
        button_name: btnName,
        button_text: button_status,
        audit_info: audit_info,
        is_end: is_end,
        jxmbArray: Ext.util.JSON.encode(jxmbArray),
        mb_year: mb_year
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        } else {
            Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        }
    }, 'json');
}
/**
 * 操作记录
 */
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        var mb_id = records[0].get("MB_ID");
        fuc_getWorkFlowLog(mb_id);
    }
}

/**
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid(param) {
    if (jxmb_json_common[wf_id][node_type].reloadGrid) {
        jxmb_json_common[wf_id][node_type].reloadGrid(param);
    } else {
        var store = DSYGrid.getGrid('contentGrid').getStore();
        var JX_YEAR = Ext.ComponentQuery.query('combobox#JX_YEAR')[0].getValue();// 绩效目标年度
        var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();// 项目类型ID
        var MHCX = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();// 模糊查询
        //增加查询参数
        var extraParams = store.getProxy().extraParams = {
            AG_CODE: AG_CODE,
            MHCX: MHCX,
            JX_YEAR: JX_YEAR,
            XMLX_ID: XMLX_ID,
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            NODE_CODE: node_code,
            BMA: BMA
        };
        extraParams = $.extend(true, [], extraParams, param);
        store.getProxy().extraParams = extraParams;
        //刷新
        store.loadPage(1);
    }
}