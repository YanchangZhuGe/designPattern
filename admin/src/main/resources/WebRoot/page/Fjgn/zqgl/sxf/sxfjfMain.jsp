<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>市县手续费缴付主界面</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    //全局变量
    var NODE_NAME = '';//节点名称
  /*  var wf_id = getQueryParam("wf_id");//当前流程id
    var node_type = getQueryParam("node_type");//工作流节点类型
    var node_code = getQueryParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_type ="${fns:getParamValue('node_type')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';//当前操作按钮名称
  /*  var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
   /* var IS_DW = getQueryParam("is_dw");//是否为单位角色
    if (IS_DW == null || IS_DW == '' || IS_DW.toLowerCase() == 'null') {
        IS_DW = '0';
    }*/
    var IS_DW ="${fns:getParamValue('is_dw')}";
    if (isNull(IS_DW)) {
        IS_DW = '0';
    }
    var sh_status = [
        {"id":"001","code":"001","name":"未审核"},
        {"id":"002","code":"002","name":"已审核"},
        {"id":"004","code":"004","name":"被退回"}
    ];
    /*获取登录用户*/
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    /**
     *地区下拉框(当前用户区划下级：包含省管县)
     */
    var grid_tree_store = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getRegTreeDataByCode.action',
            extraParams: {
                AD_CODE: AD_CODE
            },
            reader: {
                type: 'json'
            }
        },
        root: 'nodelist',
        autoLoad: true
    });
    /**
     * 通用配置json
     */
    var sxfjf_json_common = {
        100242: {//手续费缴付工作流
            'typing': {//录入
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '录入',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                //发送ajax请求，获取新增主表id
                                $.post("/getId.action", function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，设置主键id
                                    var window_input = initWindow_input({
                                        busiId: data.data,
                                        editable: true
                                    });
                                    window_input.show();
                                    window_input.down('form').down('[name=BILL_ID]').setValue(data.data);
                                }, "json");
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
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请仅选择一条记录再进行操作');
                                    return;
                                }
                                //修改全局变量的值
                                button_name = btn.text;
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getSxfjfById.action", {
                                    BILL_ID: records[0].get('BILL_ID'),
                                    IS_DW: IS_DW
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                    var window_input = initWindow_input({
                                        busiId: data.data.BILL_ID,
                                        editable: true
                                    });
                                    window_input.show();
                                    window_input.down('form').getForm().setValues(data.data);
                                    window_input.down('form').down('grid#dfsq_grid').insertData(null, data.list);
                                }, "json");
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
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("BILL_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/deleteSxfjf.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            IS_DW: IS_DW
                                        }, function (data) {
                                            if (data.success) {
                                                Ext.toast({
                                                    html: button_name + "成功！",
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
                                        }, "json");
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
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
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
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
                                    return;
                                }
                                //修改全局变量的值
                                button_name = btn.text;
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getSxfjfById.action", {
                                    BILL_ID: records[0].get('BILL_ID'),
                                    IS_DW: IS_DW
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                    var window_input = initWindow_input({
                                        busiId: data.data.BILL_ID,
                                        editable: true
                                    });
                                    window_input.show();
                                    window_input.down('form').getForm().setValues(data.data);
                                    window_input.down('form').down('grid#dfsq_grid').insertData(null, data.list);
                                }, "json");
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
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("BILL_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/deleteSxfjf.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            IS_DW: IS_DW
                                        }, function (data) {
                                            if (data.success) {
                                                Ext.toast({
                                                    html: button_name + "成功！",
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
                                        }, "json");
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
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt0)
                }
            },
            'reviewed': {//审核
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                        xtype: 'button',
                        text: '撤销审核',
                        name: 'cancel',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            for (var i in records) {
                                if (records[i].get("IS_CONFIRM") == 1) {
                                    Ext.MessageBox.alert('提示', "待撤销记录已被上级确认，无法撤销审核！");
                                    return false;
                                }
                            }
                            doWorkFlow(btn);
                        }
                    },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [//被退回
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(sh_status)
                }
            },
            'jfqr': {//手续费确认
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '确认',
                            name: 'down',
                            icon: '/image/sysbutton/confirm.png',
                            handler: function (btn) {
                                updateConfirm(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'back',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                updateConfirm(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_query',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销确认',
                            name: 'up',
                            icon: '/image/sysbutton/cancel.png',
                            handler: function (btn) {
                                updateConfirm(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt3)
                }
            }
        }
    };

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        if (node_type != 'jfqr') {
            //获取节点按钮名称
            $.post("getWfNodeName.action?wf_id=" + wf_id + "&node_code=" + node_code, function (data) {
                var NODE_NAME = null;
                var json_zt = null;
                if (typeof data != 'undefined' && data != null && data.length > 0 && typeof data[0]['NODE_NAME'] != 'undefined') {
                    NODE_NAME = data[0]['NODE_NAME'];
                }
                //根据节点名称初始化状态下拉框store
                if (NODE_NAME == "录入") {
                    json_zt = json_debt_zt0;
                    NODE_NAME = '送审';
                } else if (NODE_NAME == "审核") {
                    json_zt = sh_status;
                } else if (NODE_NAME == "复核") {
                    json_zt = json_debt_zt3_2;
                }
                //根据节点名称修改状态下拉框store
                var combobox_status = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]');
                if (typeof combobox_status != 'undefined' && combobox_status != null && combobox_status.length > 0 && json_zt != null) {
                    combobox_status[0].setStore(DebtEleStore(json_zt));
                }
                //修改全局变量中按钮文本
                var wfstatus = ['001', '002'];
                for (var i in wfstatus) {
                    var btns = sxfjf_json_common[wf_id][node_type].items[wfstatus[i]];
                    for (var j in btns) {
                        if (btns[j].name == 'down') {
                            btns[j].text = NODE_NAME;
                        }
                        if (btns[j].name == 'cancel') {
                            btns[j].text = '撤销' + NODE_NAME;
                        }
                    }
                }
                //根据节点名称修改审核按钮文本
                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar');
                if (toolbar && toolbar != null && toolbar.length == 1) {
                    var downButton = toolbar[0].down('button[name="down"]');
                    var cancelButton = toolbar[0].down('button[name="cancel"]');
                    if (typeof downButton != 'undefined' && downButton != null) {
                        downButton.setText(NODE_NAME);
                    }
                    if (typeof cancelButton != 'undefined' && cancelButton != null) {
                        cancelButton.setText('撤销' + NODE_NAME);
                    }
                }
            },"json");
        }
        initContent();
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'hbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: sxfjf_json_common[wf_id][node_type].items[WF_STATUS]
                }
            ],
            items: [
                initContentRightPanel()
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
            {text: "手续费缴付单ID", dataIndex: "BILL_ID", type: "string", hidden: true},
            {text: "区划名称", dataIndex: "AD_NAME", type: "string", width: 130},
            {text: "申请日期", dataIndex: "BILL_DATE", type: "string", width: 130},
            {
                text: "发行手续费缴付金额(元)",
                dataIndex: "SUM_FXF_AMT",
                type: "float",
                width: 200, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "托管手续费缴付金额(元)",
                dataIndex: "SUM_TGF_AMT",
                type: "float",
                width: 200, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "备注", dataIndex: "REMARK", type: "string", width: 130},
            {text: "上级已确认", dataIndex: "IS_CONFIRM", type: "string", width: 130, hidden: true}
        ];
        var tbar = [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: sxfjf_json_common[wf_id][node_type].store['WF_STATUS'],
                width: 110,
                labelWidth: 30,
                editable: false,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(sxfjf_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            }
        ];
        if (node_type == 'jfqr') {
            tbar = [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: sxfjf_json_common[wf_id][node_type].store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    editable: false,
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "code",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(sxfjf_json_common[wf_id][node_type].items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "S_AD_CODE",
                    store: grid_tree_store,
                    displayField: 'text',
                    valueField: 'code',
                    fieldLabel: '区划',
                    editable: false, //禁用编辑
                    labelWidth: 40,
                    width: 210,
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
                    xtype: "datefield",
                    fieldLabel: '缴付日期',
                    format: 'Y-m-d',
                    name: 'sdate',
                    width: 163,
                    labelWidth: 58,
                    labelAlign: 'right',
                    editable: false,
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = Ext.util.Format.date(newValue,'Y-m-d');
                            //self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "datefield",
                    fieldLabel: '至',
                    format: 'Y-m-d',
                    name: 'edate',
                    width: 125,
                    labelWidth: 20,
                    labelAlign: 'right',
                    editable: false,
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = Ext.util.Format.date(newValue,'Y-m-d');
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            ];
        }
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code,
                node_type: node_type,
                IS_DW: IS_DW
                //AD_CODE: AD_CODE
            },
            dataUrl: 'getSxfjfMainGridData.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: tbar,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['BILL_ID'] = record.get('BILL_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['IS_DW'] = IS_DW;
                    DSYGrid.getGrid('contentGrid_detail').getStore().load();
                },
                itemdblclick: function (self, record) {
                    showWin_view(record.get('BILL_ID'));
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
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "ZQ_ID", type: "string", text: "债券id", width: 150, hidden: true},
            {text: "单位", dataIndex: "AG_NAME", type: "string", width: 150},
            {
                dataIndex: "FEE_AMT", width: 150, type: "float", text: "手续费总额(元)", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "FXF_AMT", width: 200, type: "float", text: "发行手续费缴付金额(元)", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "TGF_AMT", width: 200, type: "float", text: "托管手续费缴付金额(元)", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "PAY_DATE", width: 150, type: "string", text: "支付日期"},
            {dataIndex: "JZ_DATE", width: 150, type: "string", text: "记账日期"},
            {dataIndex: "ZQ_CODE", type: "string", text: "债券编码", width: 150},
            {
                dataIndex: "ZQ_NAME", width: 150, type: "string", text: "债券名称",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {dataIndex: "ZQ_JC", width: 150, type: "string", text: "债券简称"},
            {dataIndex: "ZQQX_NAME", width: 150, type: "string", text: "债券期限"},
            {dataIndex: "ZQLB_NAME", width: 150, type: "string", text: "债券类型"},
            {dataIndex: "PM_RATE", width: 150, type: "float", text: "票面利率", hidden: true},
            {dataIndex: "DFSXF_RATE", width: 150, type: "float", text: "兑付手续费率(‰)", hidden: true},
            {
                dataIndex: "FX_AMT", width: 150, type: "float", text: "实际发行额(元)", hidden: true, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "FX_START_DATE", width: 150, type: "string", text: "发行日", hidden: true},
            {dataIndex: "ZB_DATE", width: 150, type: "string", text: "招标日期", hidden: true},
            {dataIndex: "DQDF_DATE", width: 150, type: "string", text: "到期兑付日", hidden: true}, //到期兑付日
            {dataIndex: "QX_DATE", width: 150, type: "string", text: "起息日", hidden: true},
            {dataIndex: "DQDF_DATE", width: 150, type: "string", text: "计划兑付日"},//计划表
            {dataIndex: "FXZQ_NAME", width: 150, type: "string", text: "付息周期", hidden: true},
            {dataIndex: "DF_TYPE", width: 150, type: "string", text: "兑付类型编码", hidden: true}
        ];
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
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
            }],
            dataUrl: 'getSxfjfDtlGridData.action'
        };
        var grid = DSYGrid.createGrid(config);
        return grid;
    }
    /**
     * 初始化下级缴付手续费表格
     */
    function initWindow_select_grid_detail() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "AD_NAME",
                type: "string",
                text: "地区名称",
                width: 150,
                summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "PAY_DATE",
                width: 110,
                type: "string",
                text: "支付日期"
            },
            {
                dataIndex: "FEE_AMT",
                width: 150,
                type: "float",
                text: "缴付手续费总额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "FXF_AMT",
                width: 180,
                type: "float",
                text: "缴付发行手续费(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "TGF_AMT",
                width: 180,
                type: "float",
                text: "缴付托管手续费(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "FXSXF_AMT",
                width: 180,
                type: "float",
                text: "应付发行手续费(元)"
            },
            {
                dataIndex: "TGSXF_AMT",
                width: 180,
                type: "float",
                text: "应付托管手续费(元)"
            },
            {
                dataIndex: "REMARK",
                width: 150,
                type: "string",
                text: "备注"
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'grid_select_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            tbar: ['下级地区还款信息'],
            height: '50%',
            width: '100%',
            flex: 1,
            autoLoad: false,
            border: false,
            pageConfig: {
                enablePage: false
            },
            dataUrl: 'getXjJfsxfGridData.action',
            features: [{
                ftype: 'summary'
            }]
        });
    }
    /**
     * 初始化兑付计划选择弹出窗口
     */
    function initWindow_select(params) {
        if (AD_CODE.length == 4 && !(AD_CODE.lastIndexOf("00") == 2)) {
            var WinItem = [initWindow_select_grid(params), initWindow_select_grid_detail()]
        } else {
            var WinItem = [initWindow_select_grid(params)];
        }
        return Ext.create('Ext.window.Window', {
            title: '选择应付手续费', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.9, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: WinItem,
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length < 1) {
                            Ext.MessageBox.alert('提示', '请至少选择一条记录后进行操作');
                            return;
                        }
                        var window_input = Ext.ComponentQuery.query('window#window_input')[0];
                        var sqGridStore = window_input.down('grid#dfsq_grid').getStore();
                        for (var i in records) {
                            var record_data = records[i].getData();
                            record_data.FXF_AMT = record_data.SY_FXF_AMT;
                            record_data.TGF_AMT = record_data.SY_TGF_AMT;
                            var record = sqGridStore.findRecord('PLAN_ID', records[i].get('PLAN_ID'), 0, false, true, true);
                            if (record == null) {
                                window_input.down('grid#dfsq_grid').insertData(null, record_data);
                            }
                        }
                        inputDfsqForm(sqGridStore);//向手续费缴付主单填写内容
                        //弹出填报页面，并写入债券信息
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
     * 初始化兑付计划选择
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "区划编码", dataIndex: "AD_CODE", type: "string", width: 180, hidden: true},
            {text: "区划", dataIndex: "AD_NAME", type: "string", width: 150,hidden: IS_DW =='0'},
            {text: "单位ID", dataIndex: "AG_ID", type: "string", width: 180, hidden: true},
            {text: "单位", dataIndex: "AG_NAME", type: "string", width: 180,hidden: IS_DW =='0'},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "债券编码", dataIndex: "ZQ_CODE", width: 200, type: "string"},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", width: 250, type: "string",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券发行时间", dataIndex: "FX_START_DATE", width: 120, type: "string"},
            {text: "承担金额", dataIndex: "CD_AMT", width: 150, type: "float"},
            {text: "剩余应还发行手续费", dataIndex: "SY_FXF_AMT", width: 150, type: "float"},
            {text: "剩余应还托管手续费", dataIndex: "SY_TGF_AMT", width: 150, type: "float"},
            {text: "发行手续费", dataIndex: "FXSXF_AMT", width: 150, type: "float"},
            {text: "托管手续费", dataIndex: "TGSXF_AMT", width: 150, type: "float"},
            {text: "债券类型", dataIndex: "ZQLB_NAME", width: 150, type: "string"},
            {text: "债券期限", dataIndex: "ZQQX_NAME", width: 150, type: "string"},
            {text: "偿还日期", dataIndex: "PLAN_PAY_DATE", type: "string"}
        ];
        return DSYGrid.createGrid({
            itemId: 'grid_select',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            height: '50%',
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            tbar: [
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 200,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                        }
                    }
                }, {
                    xtype: "combobox",
                    name: "FX_YEAR",
                    store: DebtEleStore(getYearListWithAll()),
                    displayField: "name",
                    valueField: "code",
                    fieldLabel: '到期年月',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 180
                },
                {
                    xtype: "combobox",
                    name: "FX_MO",
                    store: DebtEleStore(json_debt_yf_qb),
                    displayField: "name",
                    valueField: "code",
                    editable: false, //禁用编辑
                    width: 85
                }, {
                    xtype: "textfield",
                    name: "mhcx",
                    labelAlign: 'right',
                    fieldLabel: '模糊查询',
                    labelWidth: 60,
                    width: 300,
                    emptyText: '请输入债券名称/债券编码...',
                    editable: true,
                    enableKeyEvents: true,
                    listeners: {
                        'keydown': function (self, e, eOpts) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                selectGridLoad(self);
                            }
                        }
                    }
                }, {
                    xtype: 'button',
                    style: {marginRight: '20px'},
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        selectGridLoad(btn);
                    }
                }
            ],
            params: {
                AD_CODE: AD_CODE.replace(/00$/, ""),
                IS_DW: IS_DW
            },
            listeners: {
                itemclick: function (self, record) {
                    if (AD_CODE.length == 4 && !(AD_CODE.lastIndexOf("00") == 2)) {
                        //刷新明细表
                        var store = DSYGrid.getGrid('grid_select_detail').getStore();
                        store.getProxy().extraParams = {
                            ZQ_ID: record.get('ZQ_ID'),
                            AD_CODE: AD_CODE
                        };
                        store.load();
                    }
                }
            },
            dataUrl: 'getDfjhSxfGridData.action'
        });
    }
    /**
     * 选择界面查询按钮事件
     */
    function selectGridLoad(btn) {
        var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
        var FX_YEAR = Ext.ComponentQuery.query('combobox[name="FX_YEAR"]')[0].value;
        var FX_MO = Ext.ComponentQuery.query('combobox[name="FX_MO"]')[0].value;
        //刷新表格数据
        var store = btn.up('window').down('grid').getStore();
        store.getProxy().extraParams['mhcx'] = mhcx;
        store.getProxy().extraParams['FX_YEAR'] = FX_YEAR;
        store.getProxy().extraParams['FX_MO'] = FX_MO;
        store.loadPage(1);
    }
    /**
     * 初始化手续费缴付弹出窗口
     */
    function initWindow_input(config) {
        return Ext.create('Ext.window.Window', {
            title: '手续费缴付', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.9, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                {
                    xtype: 'tabpanel',
                    height: '100%',
                    actionTab: 1,
                    border: false,
                    items: [
                        {
                            title: '手续费缴付',
                            layout: 'fit',
                            items: initWindow_input_contentForm()
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            layout: 'fit',
                            scrollable: true,
                            items: initWindow_input_xmfj(config)
                        }
                    ]
                }
            ],
            buttons: [
                {
                    xtype: 'button',
                    text: '新增',
                    width: 80,
                    handler: function (btn) {
                        //弹出到期债务窗口
                        initWindow_select().show();
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    itemId: 'delete_editGrid',
                    width: 80,
                    disabled: true,
                    style: {marginRight: '20px'},
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        grid.getPlugin('dfsq_grid_plugin_cell').cancelEdit();
                        store.remove(sm.getSelection());
                        inputDfsqForm(store);//向手续费缴付主单填写内容
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '保存',
                    itemId: 'save_editGrid',
                    disabled:false,
                    handler: function (btn) {
                        btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                        var form = btn.up('window').down('form');
                        //获取单据明细数组
                        var recordArray = [];
                        if (form.down('grid').getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '请填写手续费缴付明细记录！');
                            btn.setDisabled(false);
                            return false;
                        }
                        var message_error = null;
                        form.down('grid').getStore().each(function (record) {
                            if (record.get('FXF_AMT') > record.get('SY_FXF_AMT') || record.get('TGF_AMT') > record.get('SY_TGF_AMT')) {
                                message_error = '录入金额超过最大缴付金额！';
                                return false;
                            }
                            if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null) {
                                message_error = '支付日期不能为空！';
                                return false;
                            }
                            record.data.PAY_DATE = dsyDateFormat(record.get('PAY_DATE'));
                            record.data.JZ_DATE = dsyDateFormat(record.get('JZ_DATE'));
                            recordArray.push(record.getData());
                        });
                        if (message_error != null && message_error != '') {
                            Ext.Msg.alert('提示', message_error);
                            btn.setDisabled(false);
                            return false;
                        }
                        var parameters = {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            AD_CODE: AD_CODE.replace(/00$/, ""),
                            IS_DW: IS_DW,
                            detailList: Ext.util.JSON.encode(recordArray)
                        };
                        if (form.isValid()) {
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveSxfjfGrid.action',
                                params: parameters,
                                success: function (form, action) {
                                    btn.setDisabled(false);
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
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
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
            ]
        });
    }
    /**
     * 初始化手续费缴付表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            defaults: {
                //anchor: '100% -100',
                margin: '5 5 5 5'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    width: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .33,
                        readOnly: true,
                        labelWidth: 160//控件默认标签宽度
                    },
                    items: [
                        {fieldLabel: '主单ID', name: "BILL_ID", hidden: true},
                        {
                            fieldLabel: '申请日期',
                            name: "BILL_DATE",
                            xtype: "datefield",
                            value: today,
                            emptyText: '请填写申请日期',
                            format: 'Y-m-d',
                            readOnly: false
                        },
                        {
                            fieldLabel: '手续费总金额(元)',
                            name: "TOTAL_SXF_AMT",
                            xtype: "numberFieldFormat",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '发行手续费缴付金额(元)',
                            name: "SUM_FXF_AMT",
                            xtype: "numberFieldFormat",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '托管手续费缴付金额(元)',
                            name: "SUM_TGF_AMT",
                            xtype: "numberFieldFormat",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {fieldLabel: '备注', name: "REMARK", columnWidth: .99, readOnly: false, editable: true}
                    ]
                },
                {
                    xtype: 'fieldset',
                    flex: 1,
                    title: '手续费缴付明细',
                    width: '100%',
                    collapsible: true,
                    layout: 'fit',
                    items: [initWindow_input_contentForm_grid()]
                }
            ]
        });
    }
    /**
     * 手续费缴付明细表格
     */
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "手续费缴付计划ID", dataIndex: "PLAN_ID", type: "string", hidden: true},
            {text: "区划编码", dataIndex: "AD_CODE", type: "string", width: 180, hidden: true},
            {text: "区划", dataIndex: "AD_NAME", type: "string", width: 150,hidden: IS_DW =='0'},
            {text: "单位ID", dataIndex: "AG_ID", type: "string", width: 180, hidden: true},
            {text: "单位", dataIndex: "AG_NAME", type: "string", width: 180,hidden: IS_DW =='0'},
            {
                text: "手续费总额(元)", dataIndex: "FEE_AMT", width: 180, type: "float", tdCls: 'grid-cell-unedit',
                renderer: function (value, cellmeta, record) {
                    value = record.get('FXF_AMT') + record.get('TGF_AMT');
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "发行手续费金额(元)", dataIndex: "FXF_AMT", width: 180, type: "float", headerMark: 'star',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true}
            },
            {
                text: "托管手续费金额(元)", dataIndex: "TGF_AMT", width: 180, type: "float", headerMark: 'star',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true}
            },
            {text: "剩余应还发行手续费(元)", dataIndex: "SY_FXF_AMT", width: 180, type: "float"},
            {text: "剩余应还托管手续费(元)", dataIndex: "SY_TGF_AMT", width: 180, type: "float"},
            {
                text: "支付日期", dataIndex: "PAY_DATE", width: 150, type: "string", headerMark: 'star',
                editor: {xtype: 'datefield', format: 'Y-m-d'},
                renderer: function (value, metaData, record) {
                    var newValue = dsyDateFormat(value);
                    record.data.PAY_DATE = newValue;
                    return newValue;
                }
            },
            {
                text: "记账日期", dataIndex: "JZ_DATE", width: 150, type: "string",
                editor: {xtype: 'datefield', format: 'Y-m-d'},
                renderer: function (value, metaData, record) {
                    var newValue = dsyDateFormat(value);
                    record.data.JZ_DATE = newValue;
                    return newValue;
                }
            },
            {text: "会计凭证号", dataIndex: "KJPZ_NO", width: 150, type: "string", editor: 'textfield'},
            {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", width: 250, type: "string",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string"},
            {text: "债券类型", dataIndex: "ZQQX_NAME", width: 150, type: "string"},
            {text: "债券期限", dataIndex: "ZQLB_NAME", width: 150, type: "string"},
            {text: "偿还日期", dataIndex: "PLAN_PAY_DATE", width: 150, type: "string"},
            {text: "发行日", dataIndex: "QX_DATE", width: 150, type: "string", hidden: true}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'dfsq_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            data: [],
            border: true,
            height: '100%',
            width: '100%',
            tbar: [],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'dfsq_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        validateedit: function (editor, context) {
                        },
                        edit: function (editor, e) {
                            if (e.field == 'FXF_AMT') {
                                if (e.value > e.record.get('SY_FXF_AMT')) {
                                    Ext.MessageBox.alert('提示', '输入金额超过剩余应偿还金额：' + e.record.get('SY_FXF_AMT') + '元！');
                                    e.record.set('FXF_AMT', e.record.get('SY_FXF_AMT'));
                                }
                            }
                            if (e.field == 'TGF_AMT') {
                                if (e.value > e.record.get('SY_TGF_AMT')) {
                                    Ext.MessageBox.alert('提示', '输入金额超过剩余应偿还金额：' + e.record.get('SY_TGF_AMT') + '元！');
                                    e.record.set('TGF_AMT', e.record.get('SY_TGF_AMT'));
                                }
                            }
                            inputDfsqForm(e.grid.getStore());
                        }
                    }
                }
            ],
            pageConfig: {
                enablePage: false
            },
            listeners: {}
        });
        grid.on('selectionchange', function (view, records) {
            grid.up('window').down('#delete_editGrid').setDisabled(!records.length);
        });
        return grid;
    }
    /**
     * 初始化填报弹出窗口中的项目附件标签页
     */
    function initWindow_input_xmfj(config) {
        var grid = UploadPanel.createGrid({
            busiType: 'ETXXX',//业务类型
            busiId: config.busiId,//业务ID
            editable: config.editable,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_input_xmfj_grid'
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
     * 显示手续费缴付查看窗口
     */
    function showWin_view(BILL_ID) {
        //发送ajax请求，查询主表和明细表数据
        $.post("/getSxfjfById.action", {
            BILL_ID: BILL_ID,
            IS_DW: IS_DW
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                return;
            }
            //弹出弹出框，并将主表和明细表数据插入到弹出框form中
            var win_view = initWin_view({
                busiId: data.data.BILL_ID,
                editable: false
            });
            data.data.TOTAL_SXF_AMT = Number(data.data.SUM_FXF_AMT) + Number(data.data.SUM_TGF_AMT);
            win_view.show();
            win_view.down('form').getForm().setValues(data.data);
            win_view.down('form').down('grid#dfsq_grid').insertData(null, data.list);
        }, "json");
    }
    /**
     * 初始化手续费缴付查看弹出窗口
     */
    function initWin_view(config) {
        return Ext.create('Ext.window.Window', {
            title: '手续费缴付', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.9, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                {
                    xtype: 'tabpanel',
                    height: '100%',
                    actionTab: 1,
                    border: false,
                    items: [
                        {
                            title: '手续费缴付',
                            layout: 'fit',
                            items: initWin_view_contentForm()
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            layout: 'fit',
                            scrollable: true,
                            items: initWindow_input_xmfj(config)
                        }
                    ]
                }
            ]
        });
    }
    /**
     * 初始化手续费缴付查看表单
     */
    function initWin_view_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            defaults: {
                //anchor: '100% -100',
                margin: '5 5 5 5'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    width: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .33,
                        readOnly: true,
                        labelWidth: 160//控件默认标签宽度
                    },
                    items: [
                        {fieldLabel: '主单ID', name: "BILL_ID", hidden: true},
                        {
                            fieldLabel: '申请日期',
                            name: "BILL_DATE",
                            xtype: "datefield",
                            value: today,
                            emptyText: '请填写申请日期',
                            format: 'Y-m-d',
                            readOnly: false
                        },
                        {
                            fieldLabel: '手续费总金额(元)',
                            name: "TOTAL_SXF_AMT",
                            xtype: "numberFieldFormat",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '发行手续费缴付金额(元)',
                            name: "SUM_FXF_AMT",
                            xtype: "numberFieldFormat",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '托管手续费缴付金额(元)',
                            name: "SUM_TGF_AMT",
                            xtype: "numberFieldFormat",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {fieldLabel: '备注', name: "REMARK", columnWidth: .99, readOnly: false, editable: true}
                    ]
                },
                {
                    xtype: 'fieldset',
                    flex: 1,
                    title: '手续费缴付明细',
                    width: '100%',
                    collapsible: true,
                    layout: 'fit',
                    items: [initWin_view_contentForm_grid()]
                }
            ],
            listeners: {
                beforeRender: function () {
                    SetItemReadOnly(this.items);
                }
            }
        });
    }
    /**
     * 初始化手续费缴付查看明细表格
     */
    function initWin_view_contentForm_grid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", width: 150, hidden: true},
            {text: "手续费缴付计划ID", dataIndex: "PLAN_ID", type: "string", width: 150, hidden: true},
            {text: "区划", dataIndex: "AD_NAME", type: "string", width: 150, hidden: IS_DW == '0'},
            {text: "单位", dataIndex: "AG_NAME", type: "string", width: 150, hidden: IS_DW == '0'},
            {
                text: "手续费总额(元)", dataIndex: "FEE_AMT", width: 150, type: "float",
                renderer: function (value, cellmeta, record) {
                    value = record.get('FXF_AMT') + record.get('TGF_AMT');
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "发行手续费金额(元)", dataIndex: "FXF_AMT", width: 170, type: "float"},
            {text: "托管手续费金额(元)", dataIndex: "TGF_AMT", width: 170, type: "float"},
            {text: "剩余应还发行手续费(元)", dataIndex: "SY_FXF_AMT", width: 190, type: "float"},
            {text: "剩余应还托管手续费(元)", dataIndex: "SY_TGF_AMT", width: 190, type: "float"},
            {
                text: "支付日期", dataIndex: "PAY_DATE", width: 150, type: "string",
                renderer: function (value, metaData, record) {
                    var newValue = dsyDateFormat(value);
                    record.data.PAY_DATE = newValue;
                    return newValue;
                }
            },
            {
                text: "记账日期", dataIndex: "JZ_DATE", width: 150, type: "string",
                renderer: function (value, metaData, record) {
                    var newValue = dsyDateFormat(value);
                    record.data.JZ_DATE = newValue;
                    return newValue;
                }
            },
            {text: "会计凭证号", dataIndex: "KJPZ_NO", width: 150, type: "string"},
            {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", width: 250, type: "string",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {dataIndex: "ZQ_JC", width: 150, type: "string", text: "债券简称"},
            {dataIndex: "ZQQX_NAME", width: 150, type: "string", text: "债券类型"},
            {dataIndex: "ZQLB_NAME", width: 150, type: "string", text: "债券期限"},
            {dataIndex: "PLAN_PAY_DATE", width: 150, type: "string", text: "偿还日期"},
            {dataIndex: "QX_DATE", width: 150, type: "string", text: "发行日", hidden: true}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'dfsq_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            data: [],
            border: true,
            height: '100%',
            width: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     * 更新手续费缴付主单表单值
     */
    function inputDfsqForm(store, type_name) {
        var input_fxf_amt = 0; //发行手续费
        var input_tgf_amt = 0; //托管手续费
        store.each(function (record) {
            input_fxf_amt += record.get('FXF_AMT');
            input_tgf_amt += record.get('TGF_AMT');
        });
        var input_apply_amt = input_fxf_amt + input_tgf_amt;//发行手续费+托管手续费
        var window_input = Ext.ComponentQuery.query('window#window_input')[0];
        window_input.down('form').down('numberFieldFormat[name="TOTAL_SXF_AMT"]').setValue(input_apply_amt);
        window_input.down('form').down('numberFieldFormat[name="SUM_FXF_AMT"]').setValue(input_fxf_amt);
        window_input.down('form').down('numberFieldFormat[name="SUM_TGF_AMT"]').setValue(input_tgf_amt);
    }
    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("BILL_ID"));
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + "意见",
            animateTarget: btn,
            value: btn.name == 'up' ? null : '同意',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateSxfjfNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        IS_DW: IS_DW,
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            reloadGrid();
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }

                    }, "json");
                }
            }
        });
    }
    /**
     *更新确认标志
     */
    function updateConfirm(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("BILL_ID"));
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + "意见",
            animateTarget: btn,
            value: btn.name == 'down' ? '确认' : '',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateSxfjfConfirm.action", {
                        button_name: button_name,
                        ids: ids,
                        audit_info: text,
                        wf_id: wf_id,
                        IS_DW: IS_DW,
                        node_code: node_code
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().load();
                            DSYGrid.getGrid("contentGrid_detail").getStore().removeAll();
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }

                    }, "json");
                }
            }
        });
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
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.getProxy().extraParams['AD_CODE'] = AD_CODE;
        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        store.getProxy().extraParams["AD_CODE"] = AD_CODE.replace(/00$/, "");
        store.getProxy().extraParams["IS_DW"] = IS_DW;
        //刷新
        store.loadPage(1);
        //刷新下方表格,置为空
        if (DSYGrid.getGrid('contentGrid_detail')) {
            var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
            //如果传递参数不为空，就刷新明细表格
            if (typeof param_detail != 'undefined' && param_detail != null) {
                for (var name in param_detail) {
                    store_details.getProxy().extraParams[name] = param_detail[name];
                }
                store_details.getProxy().extraParams["IS_DW"] = IS_DW;
                store_details.loadPage(1);
            } else {
                store_details.removeAll();
            }
        }
    }
    /**
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("BILL_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
</script>
</body>
</html>