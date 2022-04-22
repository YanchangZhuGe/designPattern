/**
 * js：年度计划新增债券
 * Created by djl on 2016/7/6.
 */
var cxjgStore = null;
var sfdmStore = null;
var fxyfStore = null;
/**
 * 创建建设项目/存量债务弹出窗口
 * @type {{window: null, config: {closeAction: string}, show: window_jsxm.show}}
 */
var window_jsxm = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config) {
        $.extend(this.config, config);
        if (!this.window || this.config.closeAction == 'destroy') {
            this.window = initWindow_jsxm(this.config);
        }
        this.window.show();
    }
};
var fxamtOldMap = new Map();
/**
 * 创建年度计划填报弹出窗口
 * @type {{window: null, show: window_ndjhtb.show}}
 */
var window_ndjhtb = {
    window: null,
    show: function () { 
        if (!this.window) {
            this.window = initWindow_ndjhtb();
        }
        this.window.show();
    }
};
/**
 * 默认数据：工具栏
 */
$.extend(json_common, {
    100236: {//年度计划
        1: {//录入
            items: {
                common: [
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ],
                '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            }
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '录入',
                        name: 'btn_insert',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            //获取左侧选择树，初始化全局变量
                            var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                            var selected_ad = treeArray[0].getSelection()[0];
                            if (!selected_ad || !selected_ad.isLeaf()) {
                                Ext.Msg.alert('提示', '请选择一个底级区划再进行操作！');
                                return;
                            }
                            if(type == '01'){
                                var selected_ag = treeArray[1].getSelection()[0];
                                if (!selected_ag || !selected_ag.isLeaf()) {
                                    Ext.Msg.alert('提示', '请选择一个底级单位再进行操作！');
                                    return;
                                }
                                
                                AG_CODE = treeArray[1].getSelection()[0].get('code');
                                AG_NAME = treeArray[1].getSelection()[0].get('text');
                            }

                            cxjgStore = DebtEleStoreDB('DEBT_CXJG');
                            chzjlyStore = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and code like  '01%' and code like '0102%' "});
                            sfdmStore = DebtEleStore(json_debt_sf);
                            fxyfStore = DebtEleStore(json_debt_yf_nd);
                            AD_CODE = treeArray[0].getSelection()[0].get('code');
                            AD_NAME = treeArray[0].getSelection()[0].get('text');
                            button_name = btn.text;
                            window_ndjhtb.show();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                        	 // chzjlyStore = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and code like  '01%' and code like '0102%' "});
                            var records = DSYGrid.getGrid('contentGrid').getSelection(); 
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                return;
                            }
                            cxjgStore = DebtEleStoreDB('DEBT_CXJG');
                            sfdmStore = DebtEleStore(json_debt_sf);
                            fxyfStore = DebtEleStore(json_debt_yf_nd);
                            //修改全局变量的值
                            button_name = btn.text;
                            //发送ajax请求，获取修改数据
                            $.post('/getNdjhById.action', {
                                id: records[0].get('ID'),
                                type: type
//                                wf_id: wf_id,
//                                node_code: node_code,
//                                WF_STATUS: WF_STATUS,
//                                button_name: button_name
                            }, function (data) {

                                if (data.success) {
                                    window_ndjhtb.show();
                                    var grid = window_ndjhtb.window.down('grid');
                                    var form = window_ndjhtb.window.down('form#window_ndjhtb_form');
                                    form.getForm().setValues(data.map);
                                    var detailsList = data['detailsList'];
                                    for(var i = 0; i < detailsList.length ; i++){
                                    	detailsList[i].FX_AMT_ZW_RMB = detailsList[i].FX_AMT_ZW_RMB - detailsList[i].FX_AMT;
                                        var totalamt = fxamtOldMap.get(detailsList[i].ZW_CODE) + detailsList[i].FX_AMT;
                                        fxamtOldMap.put(detailsList[i].ZW_CODE, totalamt);
                                    }
                                    grid.insertData(null, detailsList);
                                    //grid.getStore().loadData(data.detailsList);
                                    //grid.removeDocked(grid.down('toolbar'));
                                } else {
                                    Ext.MessageBox.alert('提示', '查询修改数据失败！' + data.message);
                                }
                            }, 'json');
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        name: 'btn_delete',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm == 'yes') {
                                    button_name = btn.text;
                                    var ids = [];
                                    for (var i in records) {
                                        ids.push(records[i].get('ID'));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post('/deleteNdjh.action', {
                                        ids: ids,
                                        wf_id: wf_id,
                                        node_code: node_code,
                                        WF_STATUS: WF_STATUS,
                                        button_name: button_name
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({
                                                html: button_name + '成功！',
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                        } else {
                                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        }
                                        //刷新表格
                                        reloadGrid();
                                    }, 'json');
                                }
                            });
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
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
                    }
                ],
                '002': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
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
                    {
                        xtype: 'button',
                        text: '撤销送审',
                        name: 'cancel',
                        icon: '/image/sysbutton/cancel.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
                        }
                    }
                ],
                '004': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length < 1) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '只能选择一条数据进行修改');
                                return;
                            }
                            cxjgStore = DebtEleStoreDB('DEBT_CXJG');
                            chzjlyStore = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and code like  '01%' and code like '0102%' "});
                            sfdmStore = DebtEleStore(json_debt_sf);
                            fxyfStore = DebtEleStore(json_debt_yf_nd);
                            //修改全局变量的值
                            button_name = btn.text;
//                            var ids = [];
//                            for (var i in records) {
//                                ids.push(records[i].get('ID'));
//                            }
                            //发送ajax请求，获取修改数据
                            $.post('/getNdjhById.action', {
                                id: records[0].get('ID'),
                                type: type
//                                wf_id: wf_id,
//                                node_code: node_code,
//                                WF_STATUS: WF_STATUS,
//                                button_name: button_name
                            }, function (data) {
                                if (data.success) {
                                    window_ndjhtb.show();
                                    var grid = window_ndjhtb.window.down('grid');
                                    var form = window_ndjhtb.window.down('form#window_ndjhtb_form');
                                    form.getForm().setValues(data.map);
                                    var detailsList = data['detailsList'];
                                    for(var i = 0; i < detailsList.length ; i++){
                                    	detailsList[i].FX_AMT_ZW_RMB = detailsList[i].FX_AMT_ZW_RMB - detailsList[i].FX_AMT;
                                    }
                                    grid.insertData(null, data['detailsList']);
                                    //grid.getStore().loadData(data.detailsList);
                                    //grid.removeDocked(grid.down('toolbar'));
                                } else {
                                    Ext.MessageBox.alert('提示', '查询修改数据失败！' + data.message);
                                }
                            }, 'json');
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        name: 'btn_delete',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm == 'yes') {
                                    button_name = btn.text;
                                    var ids = [];
                                    for (var i in records) {
                                        ids.push(records[i].get('ID'));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post('/deleteNdjh.action', {
                                        ids: ids,
                                        wf_id: wf_id,
                                        node_code: node_code,
                                        WF_STATUS: WF_STATUS,
                                        button_name: button_name
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({
                                                html: button_name + '成功！',
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                        } else {
                                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        }
                                        //刷新表格
                                        reloadGrid();
                                    }, 'json');
                                }
                            });
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
                        }
                    }
                ],
                '008': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            operationRecord();
                        }
                    }
                ]
            },
            items_content_rightPanel_dockedItems: [
                {
                    xtype: 'toolbar',
                    layout: 'column',
                    defaults: {
                        margin: '5 5 5 5',
                        //columnWidth: .3,
                        width: 210,
                        labelWidth: 80//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '债券类型',
                            displayField: 'name',
                            valueField: 'code',
                            editable: false,
                            store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                            value: zqlb,
                            readOnly: true
                        },
                        {
                            xtype: 'combobox',
                            fieldLabel: '发行方式',
                            displayField: 'name',
                            valueField: 'code',
                            editable: false,
                            store: DebtEleStore(json_debt_fxfs),
                            value: fxfs,
                            readOnly: true
                        }
                    ]
                }
            ]
        },
        2: {//审核
            items: {
                common: [
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ],
                '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '审核',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '退回',
                        name: 'up',
                        icon: '/image/sysbutton/back.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
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
                    }
                ],
                '002': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
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
                    {
                        xtype: 'button',
                        text: '撤销审核',
                        name: 'cancel',
                        icon: '/image/sysbutton/cancel.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
                        }
                    }
                ],
                '004': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '审核',
                        name: 'down',
                        icon: '/image/sysbutton/submit.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '退回',
                        name: 'up',
                        icon: '/image/sysbutton/back.png',
                        handler: function () {
                            button_name = btn.text;
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            operationRecord();
                        }
                    }
                ],
                '008': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return false;
                            }
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            operationRecord();
                        }
                    }
                ]
            }
        }
    }
});
/**
 * 初始化建设项目/存量债务弹出窗口
 */
function initWindow_jsxm(config) {
    var title = '建设项目';
    var window_grid = initWindow_jsxm_grid;
    if (type == '02') {
        title = '存量债务';
        window_grid = initWindow_clzw_grid;
    }
    return Ext.create('Ext.window.Window', {
        title: title, // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_jsxm', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: config.closeAction,
        items: [window_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }

                    var sbGrid = window_ndjhtb.window.down('grid');
                    //将选择的记录增加到填报窗口表格中
                    for (var record_seq in records) {
                        // 创建行model实例
                        var record_data = records[record_seq].getData();
                        sbGrid.insertData(null, record_data);
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
 * 初始化建设项目弹出框表格
 */
function initWindow_jsxm_grid() {
    var headerJson = [
        {dataIndex: 'XM_ID', type: 'string', text: '项目ID', "hidden": true},
        {dataIndex: 'AG_NAME', type: 'string', text: '项目单位', width: 200},
        {dataIndex: 'XM_CODE', type: 'string', text: '项目编码', width: 310},
        {dataIndex: 'XM_NAME', type: 'string', text: '项目名称', width: 200},
        {dataIndex: 'USE_UNIT_ID', type: 'string', text: '项目管理（使用）单位', width: 200},
        {dataIndex: 'XMLX', type: 'string', text: '项目类型', width: 100},
        {dataIndex: 'JSXZ', type: 'string', text: '建设性质', width: 100},
        {dataIndex: 'XMXZ', type: 'string', text: '项目性质', width: 200}
    ];
    //设置查询form
    var search_form = DSYSearchTool.createTool({
        itemId: 'window_select_jsxm_grid_searchTool',
        items: [
            {
                xtype: 'combobox',
                fieldLabel: '项目性质',
                name: 'xmxz',
                store: DebtEleStore(json_debt_zwzjyt),
                displayField: 'name',
                valueField: 'id'
            },
            {
                xtype: 'combobox',
                fieldLabel: '项目类型',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
               // store: DebtEleStore(json_debt_zwxmlx),
                name: 'xmlx',
                displayField: 'name',
                valueField: 'id'
            },
            {
                xtype: 'combobox',
                fieldLabel: '建设性质',
                name: 'jsxz',
                store: DebtEleStore(json_debt_jsxz),
                displayField: 'name',
                valueField: 'id'
            },
            {
                xtype: 'textfield',
                fieldLabel: '项目名称',
                name: 'xm_name',
                emptyText: '项目名称'
            }
        ],
        border: true,
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        defaults: {
            labelWidth: 60,
            labelAlign: 'right',
            margin: '5 5 5 5',
            width: 250
        },
        // 查询按钮回调函数
        callback: function (self) {
            var formValue = self.getValues();
            var store = self.up('grid').getStore();
            // 清空参数中已有的查询项
            for (var search_form_i in formValue) {
                delete store.getProxy().extraParams[search_form_i];
            }
            // 向grid中追加参数
            $.extend(true, store.getProxy().extraParams, formValue);
            // 刷新表格
            store.loadPage(1);
        }
    });
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 100,
        dock: 'right',
        layout: {
            type: 'vbox',
            align: 'center'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    if (form.isValid()) {
                        search_form.callback(form);
                    } else {
                        Ext.Msg.alert('提示', '查询区域未通过验证！');
                    }
                }
            }, {
                xtype: 'button',
                text: '重置',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    form.reset();
                }
            }
        ]
    });
    return DSYGrid.createGrid({
        itemId: 'grid_jsxm',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        dockedItems: [search_form],
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE
        },
        dataUrl: 'getProjectInfo.action'
    });
}
/**
 * 初始化存量债务弹出框表格
 */
function initWindow_clzw_grid() {
    var headerJson = [
        {dataIndex: 'DTL_ID', type: 'string', text: '年度计划明细ID', 'hidden': true},
        {dataIndex: 'ZW_CODE', type: 'string', text: '债务编码', width: 300},
        {dataIndex: 'ZW_NAME', type: 'string', text: '债务名称', width: 350},
        {dataIndex: 'XM_NAME', type: 'string', text: '项目名称', width: 260},
        {dataIndex: 'SIGN_DATE', type: 'string', text: '签订日期', width: 100},
        {dataIndex: 'ZW_XY_NO', type: 'string', text: '协议号', width: 100},
        {dataIndex: 'LX_RATE', type: 'float', text: '利率(%)', width: 100},
        {dataIndex: 'ZWQX_ID', type: 'string', text: '期限(月)', align: 'right', width: 100},
        {dataIndex: 'ZWYE', type: 'float', text: '债务余额(原币)(万元)', width: 200},
        {dataIndex: 'ZWYE_RMB', type: 'float', text: '债务余额(人民币)(万元)', width: 180},
        {dataIndex: 'YQJE', type: 'float', text: '逾期金额(原币)', width: 150, hidden: true},
        {dataIndex: 'YQJE_RMB', type: 'float', text: '逾期金额(人民币)(万元)', width: 180},
        {dataIndex: 'WLJE', type: 'float', text: '未来应偿还金额(原币)', width: 220, hidden: true},
        {dataIndex: 'WLJE_RMB', type: 'float', text: '未来应偿还金额(人民币)(万元)', width: 220},
        {dataIndex: 'DQJE', type: 'float', text: '计划年度到期金额(原币)', width: 150, hidden: true},
        {dataIndex: 'DQJE_RMB', type: 'float', text: '计划年度到期金额(人民币)(万元)', width: 250},
        {dataIndex: 'FX_AMT_ZW_RMB', type: 'float', text: '已申请金额(人民币)(万元)', width: 200},
        {dataIndex: 'ZQFL_ID', type: 'string', text: '债权类型', width: 200},
        {dataIndex: 'ZQR_ID', type: 'string', text: '债权人', width: 200},
        {dataIndex: 'ZQR_FULLNAME', type: 'string', text: '债权人全称', width: 200},
        {dataIndex: 'ZJYT_ID', type: 'string', text: '债务用途', width: 200},
        {dataIndex: 'FM_ID', type: 'string', text: '币种', width: 100},
        {dataIndex: 'HL_RATE', type: 'float', text: '汇率(%)', width: 100}
    ];
    //设置查询form
    var search_form = DSYSearchTool.createTool({
        itemId: 'window_select_clzw_grid_searchTool',
        items: [
            {
                fieldLabel: '债务区划',
                xtype: 'textfield',
                name: 'AD_NAME',
                value: AD_NAME,
                labelWidth: 60,
                width: 250,
                disabled: true
            },
            {fieldLabel: '债务名称/债务编码', xtype: 'textfield', name: 'ZW_NAME',  emptyText: '债务名称/债务编码',labelWidth: 130, width: 320},
            {
                xtype: 'textfield',
                fieldLabel: '项目名称',
                name: 'xm_name',
                emptyText: '项目名称'
            }
        ],
        border: true,
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        defaults: {
            labelWidth: 60,
            labelAlign: 'right',
            margin: '5 5 5 5',
            width: 250
        },
        // 查询按钮回调函数
        callback: function (self) {
            var formValue = self.getValues();
            var store = self.up('grid').getStore();
            // 清空参数中已有的查询项
            for (var search_form_i in formValue) {
                delete store.getProxy().extraParams[search_form_i];
            }
            // 向grid中追加参数
            $.extend(true, store.getProxy().extraParams, formValue);
            // 刷新表格
            store.loadPage(1);
        }
    });
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 100,
        dock: 'right',
        layout: {
            type: 'vbox',
            align: 'center'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    if (form.isValid()) {
                        search_form.callback(form);
                    } else {
                        Ext.Msg.alert('提示', '查询区域未通过验证！');
                    }
                }
            }, {
                xtype: 'button',
                text: '重置',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    form.reset();
                }
            }
        ]
    });
    return DSYGrid.createGrid({
        itemId: 'grid_clzw',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        dockedItems: [search_form],
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            zqlb: zqlb,
            fxfs: fxfs,
            fxyear: fxyear
        },
        dataUrl: 'getClzwInfo.action'
    });
}
/**
 * 初始化年度计划填报弹出窗口
 */
function initWindow_ndjhtb() {
    var title = '新增';
    if (button_name == "修改") {
        title = button_name;
    }

    return Ext.create('Ext.window.Window', {
        title: '年度计划' + title, // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        maximizable: true,
        itemId: 'window_ndjhtb', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [
            initWindow_ndjhtb_contentForm(),
            initWindow_ndjhtb_grid()
        ],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {

                    btn.up('window').down('grid').plugins[0].completeEdit();

                    var form = btn.up('window').down('form#window_ndjhtb_form');
                    //获取单据明细数组
                    var recordArray = []; 
                    if (form.up('window').down('grid#ndjhtb_grid').getStore().getCount() <= 0) {
                        Ext.Msg.alert('提示', '请新增表格中的明细记录！');
                        return false;
                    }

                    var xynd = form.getForm().findField('XYND');
                    if (xynd == null || xynd.getValue() == '' || xynd.getValue() == null) {
                        Ext.Msg.alert('提示', '计划发行年度不能为空！');
                        return false;
                    }

                    var apply_date = form.getForm().findField('APPLY_DATE');
                    if (apply_date == null || apply_date.getValue() == '' || apply_date.getValue() == null) {
                        Ext.Msg.alert('提示', '申报年度不能为空！');
                        return false;
                    }
                    //判断相同债务，或者相同项目发行月份不能相同
                    var fxmonthMap = new Map();
                    var fxamtMap = new Map();
                    var errormsg=null;
                    form.up('window').down('grid#ndjhtb_grid').getStore().each(function (record) {
                        if (type == "01") {//一般项目
                            var xm_code = record.get('XM_CODE');
                            var fx_month = record.get('FX_MONTH');
                            if (fxmonthMap.containsKey(xm_code)) {
                                var month = fxmonthMap.get(xm_code);
                                if (fx_month == month) {
                                    var record = fxyfStore.findRecord('code', fx_month, 0, true, true, true);
                                    errormsg = '项目编码' + xm_code + '发行月份' + record.get('name') + '重复！';
                                    return;
                                }
                            } else {
                                fxmonthMap.put(xm_code, fx_month);
                            }
                        } else if (type == "02") {//置换，债务
                            var zw_code = record.get('ZW_CODE');
                            var fx_month = record.get('FX_MONTH');
                            if (fxmonthMap.containsKey(zw_code)) {
                                var amt = record.get('FX_AMT');
                                var totalamt = fxamtMap.get(zw_code) + amt;
                                fxamtMap.put(zw_code, totalamt);
                                var month = fxmonthMap.get(zw_code);
                                if (fx_month == month) {
                                    var record = fxyfStore.findRecord('code', fx_month, 0, true, true, true);
                                    errormsg = '债务编码' + zw_code + '发行月份' + record.get('name') + '重复!';
                                    return;
                                }
                            } else { 
                                fxamtMap.put(zw_code, record.get('FX_AMT'));
                                fxmonthMap.put(zw_code, fx_month);
                            }
                        }
                    });
                    if (null != errormsg && '' != errormsg) {
                        Ext.Msg.alert('提示', errormsg);
                        return false;
                    }
                    var message_error = null;
                    form.up('window').down('grid#ndjhtb_grid').getStore().each(function (record) {
 
                        if (!record.get('FX_MONTH') || record.get('FX_MONTH') == null || record.get("FX_MONTH") == '') {
                            message_error = '计划发行月份不能为空'; 
                            return;
                        }

                        if (zqlb == "02") {
                            if (!record.get('CHZJLY_ID') || record.get('CHZJLY_ID') == null || record.get("CHZJLY_ID") == '') {
                                message_error = '偿还资金来源不能为空';
                                return;
                            }
                        }
                        //公开发行置换专项债券判断类别
                        if (type == "02" && fxfs == "01" && zqlb == "02") {
                            if (!record.get('XMLB_ID') || record.get('XMLB_ID') == null || record.get("XMLB_ID") == '') {
                                message_error = '项目类别不能为空';
                                return;
                            }
                        }
                        //置换一般专项债券添加三个金额判断
                        if(type == "02" ){
                        	var yqje_old = parseFloat(Math.abs(record.get('YQJE_RMB'))).toFixed(2);
                        	var yqje_input =  parseFloat(record.get('FX_YQ_AMT')).toFixed(2); 
                        	if(yqje_old - yqje_input < 0 ){ 
                        		 message_error = '债务编码' + record.get('ZW_CODE') + ',录入逾期金额 ' + yqje_input + ' (万元),不能超过债务逾期金额 ' + yqje_old + ' (万元)'; 
                        		 return;
                        	}
                        	var dqje_old = parseFloat(Math.abs(record.get('DQJE_RMB'))).toFixed(2);
                        	var dqje_input =  parseFloat(record.get('FX_DQ_AMT')).toFixed(2); 
                        	if(dqje_old - dqje_input < 0 ){ 
                       		     message_error = '债务编码' + record.get('ZW_CODE') + ',录入到期金额 ' + dqje_input + ' (万元),不能超过债务到期金额 ' + dqje_old + ' (万元)'; 
                       		     return;
                       	   }
                        	
                         	var tqje_old = parseFloat(Math.abs(record.get('WLJE_RMB'))).toFixed(2);
                        	var tqje_input =  parseFloat(record.get('FX_TQ_AMT')).toFixed(2); 
                        	if(tqje_old - tqje_input < 0 ){ 
                       		 message_error = '债务编码' + record.get('ZW_CODE') + ',录入未来应偿还金额 ' + tqje_input + ' (万元),不能超过债务未来应偿还金额 ' + tqje_old + ' (万元)'; 
                       		 return;
                       	   }
                        }
                        if (parseFloat(record.get('FX_AMT')) < 0) {
                            message_error = '金额(万元)必须大于或等于 0'; 
                            return;
                        }
                        var a1 = fxamtMap.get(record.get('ZW_CODE'));//当前列表此笔债务录入的申请金额
                        var a2 = parseFloat(record.get('ZWYE_RMB')).toFixed(2);//债务余额
                        var a3 = parseFloat(record.get('FX_AMT_ZW_RMB')).toFixed(2); //数据库中此笔债务已申请金额
                        var a4 = fxamtOldMap.get(record.get('ZW_CODE'));//修改时原列表已申请数据

                        if ((a2 - a3 + a4) - a1 < 0) {
                            message_error = '债务编码' + record.get('ZW_CODE') + ',总申请金额(万元) ' + a1 + ' 不能超过债务余额(扣除已申请金额)' + parseFloat((a2 - a3)).toFixed(2) + '(万元)'; 
                            return;
                        }
                        // record.set(('FX_AMT'),record.get('FX_AMT')*10000);
                        recordArray.push(record.getData());
                    });
                    if (message_error != null && message_error != '') { 
                        Ext.Msg.alert('提示', message_error);
                        return false;
                    }
                    var parameters = {
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        AD_CODE: AD_CODE,
                        AD_NAME: AD_NAME,
                        AG_CODE: AG_CODE,
                        AG_ID: AG_ID,
                        AG_NAME: AG_NAME,
                        fxfs: fxfs,
                        zqlb: zqlb,
                        apply_date: apply_date.getValue(),
                        apply_year: xynd.getValue(),
                        type: type,
                        detailList: Ext.util.JSON.encode(recordArray)
                    };
                    if (button_name == '修改') {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        parameters.ID = records[0].get('ID');
                    }

                    if (form.isValid()) {
                        //保存表单数据及明细数据
                        form.submit({
                            //设置表单提交的url
                            url: 'saveNdjhGrid.action',
                            params: parameters,
                            success: function () {
                                //关闭弹出框 
                                btn.up('window').close();
                                //提示保存成功
                                Ext.toast({
                                    html: '<span style="text-align: center">保存成功!</span>',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                reloadGrid();
                            },
                            failure: function (form, action) { 
                                var result = Ext.util.JSON.decode(action.response.responseText); 
                                Ext.Msg.alert('提示', result.msg + '保存失败,无返回响应');
                            }
                        });
                    }
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_ndjhtb.window = null;
            }
        }
    });
}
/**
 * 初始化年度计划填报表单
 */
function initWindow_ndjhtb_contentForm() {
    return Ext.create('Ext.form.Panel', {
        flex: 110,
        region: 'center',
        scrollable: true,
        itemId: 'window_ndjhtb_form',
        layout: 'fit',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldset',
                title: '申报信息',
                layout: 'column',
                margin: '0 5 5 5',
                defaults: {
                    margin: '5 5 5 5',
                    columnWidth: .3,
                    width: 210,
                    labelWidth: 90//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: '债券类型',
                        name: 'ZQLB',
                        xtype: 'treecombobox',
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        editable: false,
                        readOnly: true,
                        displayField: 'name',
                        valueField: 'code',
                        value: zqlb
                    },
                    {
                        fieldLabel: '发行方式',
                        name: 'FXFS',
                        xtype: 'combobox',
                        store: DebtEleStore(json_debt_fxfs),
                        editable: false,
                        readOnly: true,
                        displayField: 'name',
                        valueField: 'code',
                        value: fxfs
                    },
                    {
                        fieldLabel: '计划发行年度',
                        name: 'XYND',
                        xtype: 'combobox',
                        value: fxyear,
                        store: DebtEleStore(json_debt_year),
                        editable: false,
                        displayField: 'name',
                        valueField: 'code',
                        listeners: {
                            'render': function (cmb, eOpts) {
                                cmb.getStore().filterBy(function (record) {
                                    return record.get('code') >= new Date().getFullYear() + 1;
                                });
                                fxyear = cmb.getValue();
                            }
                        }

                    },
                    {
                        fieldLabel: '申报日期',
                        xtype: 'datefield',
                        name: 'APPLY_DATE',
                        value: new Date(),
                        format: 'Y-m-d'
                    }
                ]
            }
        ]
    });
}
/**
 * 初始化年度计划填报表单中的基本信息表格
 */
function initWindow_ndjhtb_grid() {
    var headerJson = [];
    if (type == "01") {//一般
        headerJson = [{
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
            {dataIndex: 'DTL_ID', type: 'string', text: '明细ID', "hidden": true},
            {dataIndex: 'XM_ID', type: 'string', text: '项目ID', "hidden": true},
            {dataIndex: 'AG_NAME', type: 'string', text: '项目单位', width: 200},
            {dataIndex: 'XM_CODE', type: 'string', text: '项目编码', width: 310},
            {dataIndex: 'XM_NAME', type: 'string', text: '项目名称', width: 200,
	            renderer: function (data, cell, record) {
	                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID='+record.get('XM_ID');
	                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
	            }},
            {dataIndex: 'USE_UNIT_ID', type: 'string', text: '项目管理（使用）单位', width: 200},
            {dataIndex: 'XMLX', type: 'string', text: '项目类型', width: 100},
            {dataIndex: 'JSXZ', type: 'string', text: '建设性质', width: 100},
            {dataIndex: 'XMXZ', type: 'string', text: '项目性质', width: 200},
//         if(zqlb=="02"){
//        	 headerJson.push({dataIndex: 'CHJZLY_ID', type: 'string', text: '偿还资金来源'});
//         }
            {
                dataIndex: 'CXJG', type: 'string', text: '承销银行', tdCls: 'grid-cell',
                "hidden": true,
                editor: {
                    xtype: 'combobox',
                    store: cxjgStore,
                    displayField: 'name',
                    valueField: 'code',
                    editable: false
                },
                renderer: function (value) {
                    var record1 = cxjgStore.findRecord('code', value, 0, true, true, true);
                    return record1 != null ? record1.get('name') : value;
                }
            },
            {
                dataIndex: 'IS_AGENCY', type: 'string', text: '是否代买', tdCls: 'grid-cell',
                "hidden": true,
                editor: {
                    xtype: 'combobox',
                    store: sfdmStore,
                    displayField: 'name',
                    valueField: 'code'
                },
                renderer: function (value) {
                    var record = sfdmStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: 'AGEN_BANK', type: 'string', text: '被代买银行', tdCls: 'grid-cell',
                "hidden": true,
                editor: {
                    xtype: 'combobox',
                    store: cxjgStore,
                    displayField: "name",
                    valueField: "code"
                },
                renderer: function (value) {
                    var record = cxjgStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: 'FX_MONTH', type: 'string', text: '计划发行月份', tdCls: 'grid-cell',
                width: 120,
                editor: {
                    xtype: 'combobox',
                    store: fxyfStore,
                    displayField: 'name',
                    valueField: 'code',
                    editable: false
                },
                renderer: function (value) {
                    var record = fxyfStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            }  
        ];
    } else {//置换
        headerJson = [{
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
            //{dataIndex: 'ZW_CODE', type: 'string', text: '债务编码',width:300},
            {dataIndex: 'ZW_NAME', type: 'string', text: '债务名称', width: 350,
            renderer: function (data, cell, record) {
                /*var hrefUrl =  '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }},
            {dataIndex: 'XM_NAME', type: 'string', text: '项目名称', width: 260,
	            renderer: function (data, cell, record) {
	                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID='+record.get('XM_ID');
	                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=record.get('XM_ID');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
	            }},
            {dataIndex: 'SIGN_DATE', type: 'string', text: '签订日期', width: 100},
            {dataIndex: 'ZW_XY_NO', type: 'string', text: '协议号', width: 100},
            {dataIndex: 'LX_RATE', type: 'float', text: '利率(%)', width: 100},
            {dataIndex: 'ZWQX_ID', type: 'string', text: '期限(月)', align: 'right', width: 100},
            {dataIndex: 'ZQFL_ID', type: 'string', text: '债权类型', width: 200},
            {dataIndex: 'ZQR_ID', type: 'string', text: '债权人', width: 200},
            {dataIndex: 'ZQR_FULLNAME', type: 'string', text: '债权人全称', width: 200},
            {dataIndex: 'ZJYT_ID', type: 'string', text: '债务用途', width: 200},
            {dataIndex: 'FM_ID', type: 'string', text: '币种', width: 100},
            {dataIndex: 'HL_RATE', type: 'float', text: '汇率(%)', width: 100},
            {
                dataIndex: 'CXJG', type: 'string', text: '承销银行', tdCls: 'grid-cell',
                "hidden": true,
                editor: {
                    xtype: 'combobox',
                    store: cxjgStore,
                    displayField: "name",
                    valueField: "code",
                    editable: false
                },
                renderer: function (value) {
                    var record = cxjgStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: 'IS_AGENCY', type: 'string', text: '是否代买', tdCls: 'grid-cell',
                "hidden": true,
                editor: {
                    xtype: 'combobox',
                    store: sfdmStore,
                    displayField: "name",
                    valueField: "code"
                },
                renderer: function (value) {
                    var record = sfdmStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: 'AGEN_BANK', type: 'string', text: '被代买银行', tdCls: 'grid-cell',
                "hidden": true,
                editor: {
                    xtype: 'combobox',
                    store: cxjgStore,
                    displayField: "name",
                    valueField: "code"
                },
                renderer: function (value) {
                    var record = cxjgStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {dataIndex: 'ZWYE', type: 'float', text: '债务余额(原币)(万元)', width: 220},
            {dataIndex: 'ZWYE_RMB', type: 'float', text: '债务余额(人民币)(万元)', width: 210},
            {dataIndex: 'YQJE', type: 'float', text: '逾期金额(原币)', width: 160, hidden: true},
            {dataIndex: 'YQJE_RMB', type: 'float', text: '逾期金额(人民币)(万元)', width: 210},
            {dataIndex: 'DQJE', type: 'float', text: '计划年度到期金额(原币)', width: 150, hidden: true},
            {dataIndex: 'DQJE_RMB', type: 'float', text: '计划年度到期金额(人民币)(万元)', width: 250},
            {dataIndex: 'WLJE', type: 'float', text: '未来应偿还金额(原币)', width: 220, hidden: true},
            {dataIndex: 'WLJE_RMB', type: 'float', text: '未来应偿还金额(人民币)(万元)', width: 220}, 
            {dataIndex: 'FX_AMT_ZW_RMB', type: 'float', text: '已申请金额(人民币)(万元)', width: 200},
            {
                dataIndex: 'FX_MONTH', type: 'string', text: '计划发行月份', tdCls: 'grid-cell', width: 120,
                editor: {
                    xtype: 'combobox',
                    store: fxyfStore,
                    displayField: 'name',
                    valueField: 'code'
                },
                renderer: function (value) {
                    var record = fxyfStore.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            }
        ];
    } 
    //如果债券类型为专项债券，在置换表头数组下标16位置删除0个元素，插入1个xxx元素
    if (zqlb == "02") {
        headerJson.push({
            dataIndex: 'CHZJLY_ID', type: 'string', text: '偿还资金来源', width: 280, tdCls: 'grid-cell',
            editor: {
                xtype: 'treecombobox',
                store: chzjlyStore,
                displayField: "name",
                valueField: "code",
                editable: false,
                rootVisible: false,
                lines: false,
                maxPicekerWidth: '100%',
                selectModel: 'leaf'
            },
            renderer: function (value) { 
                var record = chzjlyStore.findNode('code', value, true, true, true);
                return record != null ? record.get('name') : value;
            }
        });
    }
    //如果为定向发行增加上浮百分比列
    if (fxfs == '02') {
        headerJson.push({
            dataIndex: 'CXJG', type: 'string', text: '承销银行', readOlny: true
        });

        headerJson.push({
            dataIndex: 'BFB', type: 'float', text: '上浮百分比',
            // hidden:true,
            editor: {
                xtype: 'numberfield',
                mouseWheelEnabled: false,
                hideTrigger: true,
                allowBlank: false
            }
        });
    }
    if(type == "02" && fxfs == "01" && zqlb == "02"){  //公开置换专项
    	 headerJson.push( 
	    	              { dataIndex: 'XMLB_ID', type: 'string', text: '项目类别', width: 200, tdCls: 'grid-cell', 
	    		        	 editor: {
	    		        		 xtype: 'combobox',
	    		        		 displayField: "name",
	    		        		 valueField: "id",
	    		        		 store:DebtEleStore(json_zqgl_fxdf_xmlb)
	    		    	     } ,
	    		            renderer: function (value) { 
	    		            	var store = DebtEleStore(json_zqgl_fxdf_xmlb);
	    		                var record = store.findRecord('id', value,0, true, true, true);
	    		                return record != null ? record.get('name') : value;
	    		            } 
                      });
    }
    if(type == "02" ){ //公开置换一般专项 
    	 headerJson.push(  
		            {
		                dataIndex: 'FX_YQ_AMT', type: 'float', text: '逾期金额(万元)', tdCls: 'grid-cell', width: 150,
		                editor: {
		                    xtype: 'numberfield',
		                    mouseWheelEnabled: false,
		                    hideTrigger: true
		                },

		                summaryType: 'sum',
		                summaryRenderer: function (value) {
		                	if(value == '' || value == null)
		                		value = 0.0;
		                    return Ext.util.Format.number(value, '0,000.00');
		                }
		            },
		            {
		                dataIndex: 'FX_DQ_AMT', type: 'float', text: '当期金额(万元)', tdCls: 'grid-cell', width: 150,
		                editor: {
		                    xtype: 'numberfield',
		                    mouseWheelEnabled: false,
		                    hideTrigger: true
		                },
		                summaryType: 'sum',
		                summaryRenderer: function (value) {
		                	if(value == '' || value == null)
		                		value = 0.0;
		                    return Ext.util.Format.number(value, '0,000.00');
		                }
		            },
		            {
		                dataIndex: 'FX_TQ_AMT', type: 'float', text: '未来应偿还金额(万元)', tdCls: 'grid-cell', width: 200,
		                editor: {
		                    xtype: 'numberfield',
		                    mouseWheelEnabled: false,
		                    hideTrigger: true
		                },
		                summaryType: 'sum',
		                summaryRenderer: function (value) {
		                	if(value == '' || value == null)
		                		value = 0.0;
		                    return Ext.util.Format.number(value, '0,000.00');
		                }
		            }, 
		            {
			            dataIndex: 'FX_AMT', type: 'float', text: '总金额(万元)',  width: 150, 
			            editor: {
			                xtype: 'numberfield',
			                mouseWheelEnabled: false,
			                hideTrigger: true,
			                editable: false,
			                allowBlank: false 
			            },
			            renderer: function (value, cellmeta, record) {
			                value = record.get('FX_YQ_AMT') + record.get('FX_DQ_AMT') + record.get('FX_TQ_AMT');
			                record.data.FX_AMT=value;
			                return Ext.util.Format.number(value, '0,000.00');
			            } 
			        },
			        {
			            dataIndex: 'REMARK', type: 'string', text: '备注', tdCls: 'grid-cell',
			            editor: {
			                xtype: 'textfield'
			            }
			        });
    	
    }else{
    	   headerJson.push(
    		    	 
    		        {
    		            dataIndex: 'FX_AMT', type: 'float', text: '总金额(万元)',  width: 150,tdCls: 'grid-cell',
    		            editor: {
    		                xtype: 'numberfield',
    		                mouseWheelEnabled: false,
    		                hideTrigger: true,
    		                allowBlank: false 
    		            },
    		            renderer: function (value, cellmeta, record) { 
    		                return Ext.util.Format.number(value, '0,000.00');
    		            } 
    		        },
    		        {
    		            dataIndex: 'REMARK', type: 'string', text: '备注', tdCls: 'grid-cell',
    		            editor: {
    		                xtype: 'textfield'
    		            }
    		        }
    		    ); 
    } 
  
    var grid = DSYGrid.createGrid({
        itemId: 'ndjhtb_grid',
        height: '100%',
        /*flex: 300,
         region: 'south',*/
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
                pluginId: 'ndjhtb_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    'edit': function (editor, e) {
                        //e.record.commit();
                    }
                }
            }
        ],
        data: [],
        tbar: [
            '->',
            {
                xtype: 'button',
                text: '新增',
                width: 80,
                handler: function (btn) {
                    //弹出到期债务窗口或者建设项目窗口
                    btn.up('grid').plugins[0].completeEdit();
                    window_jsxm.show();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'delete_editGrid',
                width: 80,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    grid.getPlugin('ndjhtb_grid_plugin_cell').cancelEdit();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }
        ],
        listeners: {
            validateedit: function (editor, context) {
                //  return checkEditorGrid(editor, context);
            },
            selectionchange: function (view, records) {
                grid.down('#delete_editGrid').setDisabled(!records.length);
            }
        }
    });
    return Ext.create('Ext.form.Panel', {
        flex: 300,
        region: 'south',
        layout: 'fit',
        items: [
            {
                xtype: 'fieldset',
                title: '明细信息',
                layout: 'fit',
                margin: '0 5 5 5',
                items: [
                    grid
                ]
            }
        ]
    });
}
/**
 * validateedit 表格编辑插件校验
 */
function checkEditorGrid(editor, context) {
    //校验当年申请金额
    if (context.field == 'FX_AMT') {
        //新插入的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前到期金额-已申请金额（汇总）
        //已经存在的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前数据库中计算得到的：到期金额-已申请金额（汇总）+当年申请金额
        //故：当年申请金额<=当年申请金额最大值APPLY_AMOUNT_MAX
        if (context.value > context.record.get('APPLY_AMOUNT_MAX')) {
            Ext.Msg.alert('提示', '当前申请金额不能超过剩余申请金额');
            return false;
        }
    }
}