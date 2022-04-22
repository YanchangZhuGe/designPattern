var wf_status = '001';
var zbwjxd_json_common = {
    '001': [
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
            text: '新增',
            name: 'INSERT',
            icon: '/image/sysbutton/add.png',
            handler: function (btn) {
                btn.setDisabled(true);
                initChooseZqxxWindow(btn).show();
                btn.setDisabled(false);
                loadChooseZqxxGrid();
            }
        },
        {
            xtype: 'button',
            text: '修改',
            name: 'UPDATE',
            icon: '/image/sysbutton/edit.png',
            handler: function (btn) {
                btn.setDisabled(true);
                getZbwjxdInfo(btn);
            }
        },
        {
            xtype: 'button',
            text: '删除',
            icon: '/image/sysbutton/delete.png',
            handler: function (btn) {
                btn.setDisabled(true);
                deleteZbwjxdInfo(btn);
            }
        },
        {
            xtype: 'button',
            text: '下达',
            name: 'DOWN',
            icon: '/image/sysbutton/submit.png',
            handler: function (btn) {
                btn.setDisabled(true);
                doZbwjxd(btn);
            }
        }
    ],
    '002': [
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
            text: '撤销下达',
            name: 'CANCEL',
            icon: '/image/sysbutton/cancel.png',
            handler: function (btn) {
                btn.setDisabled(true);
                doZbwjxd(btn);
            }
        }
    ]
};
/**
 * 区划下拉框
 */
var adConditionStore = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: 'getRegTreeDataNoCache.action',
        extraParams: {
            CHILD: '0'
        },
        reader: {
            type: 'json'
        }
    },
    root: 'nodelist',
    model: 'treeModel',
    autoLoad: true
});

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
    initContent();
    reloadGrid();
});

/**
 * 初始化主页面panel
 */
function initContent() {
    return Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true, //是否有分割线
            collapsible: false //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),//把js页面嵌入到jsp的body里面
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: zbwjxd_json_common[wf_status]
            }
        ],
        items: initContentRightPanel()
    });
}

/**
 * 初始化主页面表格panel
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
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 70, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        itemId: 'CONTENT_STATUS',
                        name: 'CONTENT_STATUS',
                        store: DebtEleStore(json_debt_zt7),
                        width: 110,
                        editable: false,
                        labelWidth: 30,
                        labelAlign: 'right',
                        allowBlank: false,
                        displayField: "name",
                        valueField: "code",
                        value: wf_status,
                        listeners: {
                            change: function (self, newValue) {
                                wf_status = newValue;
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                toolbar.removeAll();
                                toolbar.add(zbwjxd_json_common[wf_status]);
                                // 刷新主界面表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "MHCX",
                        name: "MHCX",
                        columnWidth: .33,
                        labelWidth: 60,
                        emptyText: '请输入债券代码/债券名称/债券简称',
                        enableKeyEvents: true,
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
            initContentGrid(),
            initContent_tabPanel()
        ]
    });
}

/**
 * 主页面tabPanel
 */
function initContent_tabPanel() {
    return Ext.create('Ext.tab.Panel', {
        itemId: "contentTabPanel",
        flex: 1,
        border: true,
        scrollable: true,
        region: 'south',
        activeTab: 0,
        items: [
            {
                title: '下达项目信息',
                layout: 'fit',
                items: initContentXmxxGrid()
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                items: initContentFileGrid()
            }
        ]
    });
}

/**
 * 主页面附件表格
 */
function initContentFileGrid() {
    var fileGrid = UploadPanel.createGrid({
        busiType: 'ETZBWJXD', //业务类型
        busiId: '', //业务ID
        busiProperty: '', //业务规则
        editable: false, //是否可以修改附件内容
        border: false,
        flex: 1,
        gridConfig: {
            border: false,
            minHeight: 170,
            itemId: 'content_file_grid'
        }
    });
    //附件加载完成后计算总文件数，并写到页签上
    fileGrid.getStore().on('load', function (self, records, successful) {
        var sum = 0;
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if (records[i].data.STATUS == '已上传') {
                    sum++;
                }
            }
        }
        $(fileGrid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
    });
    return fileGrid;
}

/**
 * 修改操作 项目明细查询
 */
function getZbwjxdInfo(btn) {

    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
        btn.setDisabled(false);
        return;
    }
    $.post("/zbwjxd/getZbwjxdInfo.action", {
        BILL_ID: records[0].get('BILL_ID'),
        ZQ_ID: records[0].get('ZQ_ID')
    }, function (data) {
        if (data.success) {
            var zbxxWindow = initZbxxWindow(btn, data.zbxx.BILL_ID);
            Ext.ComponentQuery.query('form#zbxxWindow_zqxx_form')[0].getForm().setValues(data.zbxx);
            DSYGrid.getGrid('zbxxWindow_xmxx_grid').insertData(null, data.xmxx);
            zbxxWindow.show();
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        btn.setDisabled(false);
    }, "json");

}

/**
 * 删除操作
 */
function deleteZbwjxdInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length < 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            var billIds = [];
            for (var i in records) {
                billIds.push(records[i].get('BILL_ID'));
            }
            $.post("/zbwjxd/deleteZbwjxdInfo.action", {
                BILL_IDS: billIds
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
 * 初始化右侧panel，放置2个表格
 */
function initPanel() {
    var that = this;
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',//上下布局
            align: 'stretch',
            flex: 1
        },

        border: false,
        items: [
            initContentGrid(),//债券上方表格，
            initContentXmxxGrid()//项目下方表格，

        ]
    });
}

/**
 * 初始化债券查询表格   上方表格
 */
function initContentGrid() {
    var headerJson = [
        {dataIndex: "ZQ_CODE", type: "string", text: "债券代码", width: 150},
        {
            dataIndex: "ZQ_NAME", type: "string", text: "债券名称", width: 300,
            renderer: function (data, cell, record) {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = AD_CODE.replace(/00$/, "");
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            dataIndex: "PLAN_FX_AMT", type: "float", text: "计划发行金额(元)", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "FX_AMT", type: "float", text: "实际发行金额(元)", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            dataIndex: "ZBWJXD_AMT", type: "float", text: "下达金额(元)", width: 180,
            hidden: AD_CODE.length == 2 ? true : false,//地方财政展示单位不展示 部端不展示
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {dataIndex: "ZBWJ_CODE", type: "string", text: "指标文号", width: 200},
        {dataIndex: "ZBWJXD_DATE", type: "string", text: "下达日期", width: 150},
        {dataIndex: "ZQLB_NAME", type: "string", text: "债券类型", width: 180},
        {dataIndex: "ZQ_JC", type: "string", text: "债券简称", width: 150},
        {dataIndex: "SET_YEAR", type: "string", text: "年度", width: 120},
        {dataIndex: "FX_START_DATE", type: "string", text: "发行时间", width: 120}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',//表格id值
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        checkBox: true,
        border: false,
        autoLoad: false,
        dataUrl: '/zbwjxd/getZbwjxdList.action',
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        },
        listeners: {
            itemclick: function (self, record, index, eOpts) {
                //加载项目信息表格
                getXmxxGrid(record);
                //加载附件表格
                var fileStore = DSYGrid.getGrid('content_file_grid').getStore();
                fileStore.getProxy().extraParams["busi_id"] = record.get('BILL_ID');
                fileStore.reload();
            }
        }
    });
}

/**
 * 下初始化项目主表格   下方表格
 */
function initContentXmxxGrid() {
    var headerJson = [
        {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
        {text: "项目单位", dataIndex: "AG_NAME", type: "string", hidden: true, width: 200},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 240,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            text: AD_CODE.length == 2 ? "申请金额（元）" : "下达金额（元）",
            dataIndex: "KXD_AMT",
            width: 180,
            type: "float",
            type: 'float',
            hidden: AD_CODE.length == 2 ? false : true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "本次下达额度(元)", dataIndex: "ZBWJXD_AMT", width: 180, type: "float", type: 'float',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {text: "项目编码", dataIndex: "XM_CODE", width: 240, type: "string"},
        {text: "项目类型", dataIndex: "XMLX_NAME", width: 150, type: "string"}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentXmxxGrid',
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/zbwjxd/getZbwjxdXmxx.action',
        autoLoad: false,
        data: [],
        checkBox: false,
        pageConfig: {
            enablePage: false
        },
        isLocalStorage: false
    });
}

/**
 * 加载项目信息表格
 */
function getXmxxGrid(record) {
    $.post("/zbwjxd/getZbwjxdXmxx.action", {
        BILL_ID: record.get('BILL_ID'),
        ZQ_ID: record.get('ZQ_ID')
    }, function (data) {
        if (data.success) {
            var xmxxGrid = DSYGrid.getGrid('contentXmxxGrid');
            xmxxGrid.getStore().removeAll();
            xmxxGrid.insertData(null, data.xmxxData);
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
    }, "json");
}

/**
 * 下拉树方法 状态查询
 */
function DebtEleStore(debtEle, params) {
    var namecode = '0';
    if (typeof params != 'undefined' && params != null) {
        namecode = params.namecode;
    }
    var debtStore = Ext.create('Ext.data.Store', {
        fields: ['id', 'code', 'name'],
        sorters: [{
            property: 'id',
            direction: 'asc'
        }],
        data: namecode == '1' ? DebtJSONNameWithCode(debtEle) : debtEle
    });
    return debtStore;
}

/**
 * 新增 选择债券弹窗
 */
function initChooseZqxxWindow(b_btn) {
    return Ext.create('Ext.window.Window', {
        title: '债券选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_zdmx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initChooseZqxxGrid(),
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var record = btn.up('window').down('grid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条记录');
                        btn.setDisabled(false);
                        return;
                    }
                    //弹出指标下达界面
                    var billId = GUID.createGUID();
                    initZbxxWindow(b_btn, billId).show();
                    var zqxxForm = Ext.ComponentQuery.query('form#zbxxWindow_zqxx_form')[0].getForm();
                    zqxxForm.setValues($.extend({BILL_ID: billId}, record.getData()));
                    //2.关闭债券弹窗
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
 * 初始化债券：新增选择弹出框表格
 */
function initChooseZqxxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "债券代码", dataIndex: "ZQ_CODE", type: "string", width: 150},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 300,
            renderer: function (data, cell, record) {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";

                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = AD_CODE.replace(/00$/, "");

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            text: "计划发行金额（元）", dataIndex: "PLAN_FX_AMT", width: 180, type: "float",
            renderer: function (value, cell, record, rowIndex, colIndex, store, view) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "实际发行金额（元）", dataIndex: "FX_AMT", width: 180, type: "float",
            renderer: function (value, cell, record, rowIndex, colIndex, store, view) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "上级下达金额（元）", dataIndex: "ZBWJXD_AMT", width: 180, type: "float",
            hidden: AD_CODE.length == 2 ? true : false,//地方财政展示单位不展示 部端不展示
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string"},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 150},
        {text: "年度", dataIndex: "SET_YEAR", width: 120, type: "string"},
        {text: "发行时间", dataIndex: "FX_START_DATE", width: 120, type: "string"}

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'chooseZqxxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"
        },
        checkBox: false,
        border: false,
        flex: 1,
        pageConfig: {
            enablePage: true,   //设置是否分页
            pageNum: true       //设置显示每页条数
        },
        dataUrl: '/zbwjxd/getZqxxList.action',
        autoLoad: false,
        tbar: [
            {
                fieldLabel: '债券发行年度',
                xtype: "combobox",
                name: "CHOOSE_SET_YEAR",
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                displayField: "name",
                valueField: "id",
                editable: false,
                labelWidth: 80,
                width: 220,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['SET_YEAR'] = newValue;
                        // 刷新表格
                        store.loadPage(1);
                    }
                }
            },
            {
                xtype: "textfield",
                name: "CHOOSE_MHCX",
                id: "CHOOSE_MHCX",
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 300,
                labelAlign: 'right',
                emptyText: '请输入债券名称/债券编码',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            loadChooseZqxxGrid();
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    loadChooseZqxxGrid();
                }
            }
        ]
    });
    return grid;
}

/**
 * 加载选择债券信息表格
 */
function loadChooseZqxxGrid() {
    var setYear = Ext.ComponentQuery.query("combobox[name='CHOOSE_SET_YEAR']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='CHOOSE_MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('chooseZqxxGrid').getStore();
    store.getProxy().extraParams = {
        SET_YEAR: setYear,
        MHCX: mhcx
    };
    store.loadPage(1);
}

/**
 * 新增 请选择项目信息弹窗
 */
function initChooseXmxxWindow() {
    return Ext.create('Ext.window.Window', {
        title: '请选择项目信息', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_zdmx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initChooseXmxxGrid(),
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
                        return;
                    }
                    var xmxxData = [];
                    for (var i in records) { //把ZBWJXD_AMT值赋值到records[i].getData()中
                        xmxxData.push($.extend({
                            ZBWJXD_AMT: records[i].get('SY_KXD_AMT')
                        }, records[i].getData()));
                    }
                    DSYGrid.getGrid('zbxxWindow_xmxx_grid').insertData(null, xmxxData);
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
 * 新增 请选择项目表格 弹窗
 */
function initChooseXmxxGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 240,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "指标文号", dataIndex: "ZBWJ_CODE", type: "string", width: 200, hidden: AD_CODE.length == 2},
        {text: "下达日期", dataIndex: "ZBWJXD_DATE", type: "string", width: 100, hidden: AD_CODE.length == 2},
        {
            text: AD_CODE.length == 2 ? "发行金额（元）" : "上级下达金额（元）", dataIndex: "KXD_AMT", width: 180, type: "float",
            renderer: function (value, cell, record, rowIndex, colIndex, store, view) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "剩余可下达金额（元）", dataIndex: "SY_KXD_AMT", width: 180, type: "float",
            renderer: function (value, cell, record, rowIndex, colIndex, store, view) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 150},
        {text: "项目编码", dataIndex: "XM_CODE", width: 240, type: "string"},
        {text: "项目类型", dataIndex: "XMLX_NAME", width: 150, type: "string"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'chooseXmxxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/zbwjxd/getXmxxList.action',
        autoLoad: false,
        tbar: [
            {
                xtype: "treecombobox",
                store: adConditionStore,
                valueField: "code",
                displayField: 'text',
                name: 'CHOOSE_AD_CODE',
                fieldLabel: '区划',
                columnWidth: .15,
                labelWidth: 30,
                labelAlign: 'right',
                editable: false,
                selectModel: 'all',
                rootVisible: false,
                allowBlank: true,
                listeners: {
                    select: function (t, newValue) {
                        loadChooseXmxxGrid();
                    },
                    'afterrender': function (self) {
                        var adTreeStore = this.getStore();
                        if (adTreeStore.getCount() == 1) {
                            var record = adTreeStore.getRoot().getChildAt(0);
                            this.setValue(record.get('code'));
                        }
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '项目类型',
                itemId: 'CHOOSE_XMLX_ID',
                name: 'CHOOSE_XMLX_ID',
                displayField: 'name',
                valueField: 'code',
                rootVisible: true,
                lines: false,
                columnWidth: .15,
                labelWidth: 60,
                selectModel: 'all',
                allowBlank: true,  //文本框x号
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                listeners: {
                    select: function (self, newValue) {
                        loadChooseXmxxGrid();
                    }
                }
            },
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                name: 'CHOOSE_MHCX',
                itemId: 'CHOOSE_MHCX',
                width: 320,
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入项目名称/项目编码',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            loadChooseXmxxGrid();
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    loadChooseXmxxGrid();
                }
            }
        ]
    });
    return grid;
}

/**
 * 加载选择项目信息表格
 */
function loadChooseXmxxGrid() {
    var zqxxForm = Ext.ComponentQuery.query('form#zbxxWindow_zqxx_form')[0];
    var zqId = zqxxForm.getForm().findField('ZQ_ID').getValue();
    var billId = zqxxForm.getForm().findField('BILL_ID').getValue();
    var adCode = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_AD_CODE']")[0].getValue();
    var xmlxId = Ext.ComponentQuery.query("treecombobox[name='CHOOSE_XMLX_ID']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='CHOOSE_MHCX']")[0].getValue().trim();
    var xmIds = [];
    var sjBillDtlIds = [];
    DSYGrid.getGrid('zbxxWindow_xmxx_grid').getStore().each(function (record) { //获取项目明细表中项目id值，如果有的就不显示
        xmIds.push(record.get('XM_ID'));
        sjBillDtlIds.push(record.get('SJ_BILLDTL_ID'));
    });

    var store = DSYGrid.getGrid('chooseXmxxGrid').getStore();
    store.getProxy().extraParams = {
        ZQ_ID: zqId,
        BILL_ID: billId,
        XM_IDS: xmIds,
        SJ_BILLDTL_IDS: sjBillDtlIds,
        AD_CODE: adCode,
        XMLX_ID: xmlxId,
        MHCX: mhcx
    };
    store.loadPage(1);
}

/**
 * 新增 指标文件下达弹窗
 */
function initZbxxWindow(b_btn, billId) {
    return Ext.create('Ext.window.Window', {
        title: '指标文件下达', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'zbxxWindow', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initZbxxWindow_panel(billId),
        buttons: [
            {
                text: '添加',
                name: 'add',
                handler: function (btn) {
                    //打开项目页面，选项目
                    initChooseXmxxWindow().show();
                    loadChooseXmxxGrid();
                }
            },
            {
                text: '删除',
                name: 'remove',
                handler: function (btn) {
                    var grid = btn.up('window').down('grid#zbxxWindow_xmxx_grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) { //删除后的选中行数大于0，则选中第一行
                        sm.select(0);
                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    saveZbxx(b_btn, btn);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    })
}

/**
 * 初始化指标录入窗口中panel
 */
function initZbxxWindow_panel(billId) {
    return Ext.create('Ext.panel.Panel', {
        height: '100%',
        flex: 1,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        scrollable: true,
        items: [
            initZbxxWindow_zqxx_form(),
            initZbxxWindow_tabPanel(billId)
        ]
    });
}

/**
 * 初始化指标录入窗口中债券信息表单
 */
function initZbxxWindow_zqxx_form() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'zbxxWindow_zqxx_form',
        width: '100%',
        layout: 'column',
        height: 150,
        border: false,
        defaults: {
            columnWidth: .33,
            margin: '5 5 5 5',
            labelWidth: 130
        },
        margin: '10 0 10 0',
        defaultType: 'textfield',
        items: [
            {
                fieldLabel: '指标文件下达ID',
                name: 'BILL_ID',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                hidden: true
            },
            {
                fieldLabel: '债券ID',
                name: 'ZQ_ID',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                hidden: true
            },
            {
                fieldLabel: '债券代码',
                name: 'ZQ_CODE',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'

            },
            {
                fieldLabel: ' 债券类型',
                name: 'ZQLB_ID',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '债券名称',
                name: 'ZQ_NAME',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '债券简称',
                name: 'ZQ_JC',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '年度',
                name: 'SET_YEAR',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '发行时间',
                name: 'FX_START_DATE',
                xtype: 'textfield',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '计划发行金额（元）',
                name: 'PLAN_FX_AMT',
                xtype: 'numberFieldFormat',
                emptyText: '0.00',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                fieldLabel: '实际发行金额（元）',
                name: 'FX_AMT',
                xtype: 'numberFieldFormat',
                emptyText: '0.00',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                fieldLabel: '<span class="required">✶</span>下达日期',
                name: 'ZBWJXD_DATE',
                xtype: 'datefield',
                format: 'Y-m-d',
                allowBlank: false,
                editable: false,
                maxValue: now_date,
                renderer: function (value) {
                    return dsyDateFormat(value);
                }
            },
            {
                fieldLabel: '<span class="required">✶</span>指标文号',
                name: 'ZBWJ_CODE',
                xtype: 'textfield',
                allowBlank: false
            }
        ]
    });
}

/**
 * 初始化指标录入窗口中tabPanel
 */
function initZbxxWindow_tabPanel(billId) {
    return Ext.create('Ext.tab.Panel', {
        itemId: "zbxxWindowTabPanel",
        flex: 1,
        border: true,
        scrollable: true,
        region: 'south',
        activeTab: 0,
        items: [
            {
                title: '项目明细',
                layout: 'fit',
                items: initZbxxWindow_xmxx_grid()
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                items: initZbxxWindow_file_grid(billId)
            }
        ],
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                tabPanel.getActiveTab();
                if (tabPanel.getActiveTab().title == '项目明细') {
                    Ext.ComponentQuery.query('button[name="add"]')[0].show();
                    Ext.ComponentQuery.query('button[name="remove"]')[0].show();
                } else {
                    Ext.ComponentQuery.query('button[name="add"]')[0].hide();
                    Ext.ComponentQuery.query('button[name="remove"]')[0].hide();
                }
            }
        }
    });
}

/**
 * 新增 指标文件下达 项目明细弹窗
 */
function initZbxxWindow_xmxx_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 240},
        {
            text: AD_CODE.length == 2 ? "申请金额（元）" : "上级下达金额（元）", dataIndex: "KXD_AMT", width: 180, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "剩余可下达金额（元）", dataIndex: "SY_KXD_AMT", width: 180, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {
            text: "本次下达额度（元）",
            dataIndex: "ZBWJXD_AMT",
            type: "float",
            width: 180,
            tdCls: 'grid-cell',
            headerMark: 'star',
            editor: {
                xtype: 'numberfield',
                mouseWheelEnabled: false,
                hideTrigger: true,
                minValue: 0,
                maxValue: 9999999999,
                decimalPrecision: 2
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 200},
        {text: "项目编码", dataIndex: "XM_CODE", width: 240, type: "string"},
        {text: "项目类型", dataIndex: "XMLX_NAME", width: 150, type: "string"},
        {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
        {text: "地区编码", dataIndex: "AD_CODE", type: "string", width: 200, hidden: true},
        {text: "上级SJ_BILLDTL_ID", dataIndex: "SJ_BILLDTL_ID", type: "string", width: 200, hidden: true}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zbxxWindow_xmxx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zbxxWindow_xmxx_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    edit: function (editor, context) {

                    },
                    beforeedit: function (editor, context) {

                    },
                    afteredit: function (editor, context) {

                    }
                }
            }
        ],
        data: []
    });
    return grid;
}

/**
 * 初始化指标录入窗口中附件表格
 */
function initZbxxWindow_file_grid(busiId) {
    var fileGrid = UploadPanel.createGrid({
        busiType: 'ETZBWJXD', //业务类型
        busiId: busiId, //业务ID
        busiProperty: '', //业务规则
        editable: true, //是否可以修改附件内容
        border: false,
        flex: 1,
        gridConfig: {
            border: false,
            minHeight: 170,
            itemId: 'zbxxWindow_file_grid'
        }
    });
    //附件加载完成后计算总文件数，并写到页签上
    fileGrid.getStore().on('load', function (self, records, successful) {
        var sum = 0;
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if (records[i].data.STATUS == '已上传') {
                    sum++;
                }
            }
        }
        $(fileGrid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
    });
    return fileGrid;
}

/**
 * 主界面刷新
 */
function reloadGrid() {
    var mhcx = Ext.ComponentQuery.query("textfield[name='MHCX']")[0].getValue().trim();//获取搜索框中的值
    var store = DSYGrid.getGrid('contentGrid').getStore();
    store.getProxy().extraParams = {
        MHCX: mhcx,
        WF_STATUS: wf_status
    };
    store.loadPage(1);//刷新表格
    DSYGrid.getGrid('contentXmxxGrid').getStore().removeAll();//将主界面的项目信息表格清空
    //将主界面的附件信息表格清空
    var fileGrid = DSYGrid.getGrid('content_file_grid');
    fileGrid.getStore().removeAll();
    $(fileGrid.up('tabpanel').el.dom).find('span.file_sum').html('(' + 0 + ')');
}

/**
 * 保存指标信息
 */
function saveZbxx(b_btn, btn) {
    var array = new Array();
    var zbxxForm = Ext.ComponentQuery.query('form#zbxxWindow_zqxx_form')[0];
    var zbwhCode = zbxxForm.getForm().findField('ZBWJ_CODE').getValue();
    if (!zbwhCode) {
        array.push('请填写指标文号');
    }
    //校验下达日期不能为空
    var zbwjxdDate = zbxxForm.getForm().findField('ZBWJXD_DATE').getValue();
    if (!zbwjxdDate) {
        array.push('请选择下达日期');
    }
    if (Ext.util.Format.date(zbwjxdDate, 'Y-m-d') > Ext.util.Format.date(now_date, 'Y-m-d')) {
        array.push('下达日期不能大于当前日期！');
    }
    //校验指标文件下达日期不能早于债券发行日期
    var fxStartDate = zbxxForm.getForm().findField('FX_START_DATE').getValue();
    if (fxStartDate && Ext.util.Format.date(zbwjxdDate, 'Y-m-d') < Ext.util.Format.date(fxStartDate, 'Y-m-d')) {
        array.push('下达日期不能小于债券发行时间！');
    }
    var xmxxStore = DSYGrid.getGrid("zbxxWindow_xmxx_grid").getStore();
    if (xmxxStore.getCount() == 0) {
        array.push('请选择项目明细');
    }
    var xmxxData = [];
    var checkAmt = false;
    xmxxStore.each(function (record) {
        var zbwjxdAmt = record.get("ZBWJXD_AMT");
        //校验本次下达额度不能为空
        if (!zbwjxdAmt) {
            array.push('本次下达额度不能为空');
            xmxxData.push(record.getData());
            checkAmt = true;
        }
        //校验本次下达金额不能大于剩余可下达金额 accSubPro减法运算
        if (!checkAmt && accSubPro(record.get("ZBWJXD_AMT"), record.get("SY_KXD_AMT")) > 0) {
            array.push('本次下达额度不能大于剩余可下达金额');
            xmxxData.push(record.getData());
            checkAmt = true;
        }
        xmxxData.push(record.getData());
    });
    var result = array.join('<br>'); //默认分隔符是逗号 ,对数组中进行分割
    if (result != '') {
        Ext.MessageBox.alert('提示', result);
        return;
    }
    $.post("/zbwjxd/saveZbwjxdInfo.action", {
        BUTTON_NAME: b_btn.name,
        ZBXX_FORM: Ext.util.JSON.encode(zbxxForm.getValues()),
        XMXX_DATA: Ext.util.JSON.encode(xmxxData)
    }, function (data) {
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
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
    }, "json");
}

/**
 * 流程方法：下达、撤销下达
 */
function doZbwjxd(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length < 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
        btn.setDisabled(false);
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否' + btn.text, function (btn_confirm) {
        if (btn_confirm === 'yes') {
            var billIds = [];
            for (var i in records) {
                billIds.push(records[i].get('BILL_ID'));
            }
            $.post('/zbwjxd/doZbwjxdStatus.action', {
                BILL_IDS: billIds,
                BUTTON_NAME: btn.name
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