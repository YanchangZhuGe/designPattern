<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>备用金提款登记</title>
</head>
<body>
<!--基础数据集-->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var userCode = '${sessionScope.USERCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点code
    var node_name = "sh";//当前节点名称
    var button_name = '';//当前操作按钮名称
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var json_zt = [//下拉框状态
        {id: "001", code: "001", name: "未登记"},
        {id: "002", code: "002", name: "已登记"},
        {id: "004", code: "004", name: "被退回"},
        {id: "008", code: "008", name: "曾经办"}
    ];
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
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
                    items: initItems_toolbar(node_name, WF_STATUS)
                }
            ],
            items: [
                initContentRightPanel()//初始化右侧panel
            ]
        });
    }
    /**
     * 获取工具栏按钮
     */
    var items_toolbar;//工具栏按钮
    function initItems_toolbar(nodeName, wf_status) {
        //工具栏按钮集合
        var items_toolbar_btns = {
            search: {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                }
            },//查询
            down:{
                xtype: 'button',
                text: '登记',
                name: 'down',
                icon: '/image/sysbutton/songsheng.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (!records || records.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
                    } else {
                        initShwindow(btn, records[0]);
                    }
                }
            },//登记
            up:{
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },//退回
            log: {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    operationRecord();
                }
            },//操作记录
            cancel:{
                xtype: 'button',
                text: '撤销',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            }//撤销
        };
        items_toolbar = {
            sh: {//登记
                items: {
                    '001': [//未登记
                        items_toolbar_btns.search,
                        items_toolbar_btns.down,
                        items_toolbar_btns.up,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已登记
                        items_toolbar_btns.search,
                        items_toolbar_btns.cancel,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [//被退回
                        items_toolbar_btns.search,
                        items_toolbar_btns.down,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [//曾经办
                        items_toolbar_btns.search,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            }
        };
        return items_toolbar[nodeName].items[wf_status];
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
            items: [
                initContentGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', summaryType: 'count', width: 45},
            {dataIndex: "ZW_ID", type: "string", text: "债务ID", hidden: true},
            {dataIndex: "ZW_CODE", type: "string", text: "债务编码", hidden: true},
            {dataIndex: "SQD_CODE", type: "string", text: "申请单号", width: 200},
            {dataIndex: "ZW_XY_NO", type: "string", text: "协议号", width: 200},
            {dataIndex: "XY_AMT", width: 150, type: "float", text: "协议金额(原币)" },
            {dataIndex: "FETCH_AMT", type: "float", text: "提款金额(原币)",width: 150},
            {dataIndex: "FETCH_DATE", type: "string", text: "提款日期"},
            {dataIndex: "TKPZ_NO", type: "string", text: '提款凭证号', width: 120},
            {dataIndex: "JZ_DATE", type: "string", text: "记账日期"},
            {dataIndex: "JZ_NO", type: "string", text: '记账凭证号', width: 120},
            {dataIndex: "ZW_NAME",  type: "string", text: "债务名称",width: 250},
            {dataIndex: "XM_NAME", type: "string", text: "大项目名称",width: 250},
            {dataIndex: "SIGN_DATE", type: "string", text: "签订日期"},
            {dataIndex: "REMARK",  type: "string", text: "提款备注",width: 250}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: false,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code
            },
            data:[{"SQD_CODE":"123123123","ZW_XY_NO":"5555","XY_AMT":"500","ZW_NAME":"债务","XM_NAME":"大项目","FETCH_AMT":"80","FETCH_DATE":"2017-01-09","TKPZ_NO":"tk123", "JZ_DATE":"2017-10-09","JZ_NO":"5656","SIGN_DATE":"2017-06-10","REMARK":"备注"}],
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_zt),
                    width: 110,
                    labelWidth: 30,
                    editable: false, //禁用编辑
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
                            toolbar.add(initItems_toolbar(node_name, WF_STATUS));
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            store.loadPage(1);//刷新
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
            }
        });
    }

    /**
     * 登记弹出窗口
     */
    function initShwindow(btn, record) {
        Ext.create('Ext.window.Window', {
            title: '备用金提款登记', // 窗口标题
            width : document.body.clientWidth * 0.65, // 窗口宽度
            height : document.body.clientHeight * 0.65, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'jjxxadd', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            resizable: true,//可拖动改变窗口大小
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            items: initShForm(),
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    handler: function (self) {
                        Ext.toast({
                            html: "保存成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        self.up('window').close();
                    }
                }, {
                    xtype: 'button',
                    text: '取消',
                    handler: function (self) {
                        self.up('window').close();
                    }
                }
            ]
        }).show();
        var form = Ext.ComponentQuery.query('form#jjxxaddform')[0].getForm();//找到该form
        form.setValues(record.getData());//将记录中的数据写进form表中
    };

    /**
     * 登记弹出窗口中的表单
     */
    function initShForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            border: false,
            itemId: 'jjxxaddform',
            layout: 'column',
            scrollable: true,
            defaultType: 'textfield',
            defaults: {
                margin: '3 5 2 5',//上右下左
                columnWidth:.5,//输入框的长度（百分比）
                labelAlign: "left",
                labelWidth: 110
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '债务名称',
                    name: "ZW_NAME",
                    fieldStyle: 'background:#E6E6E6',//置灰
                    editable: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '大项目名称',
                    name: "XM_NAME",
                    fieldStyle: 'background:#E6E6E6',//置灰
                    editable: false
                },
                {
                    xtype: "textfield",
                    name: "SIGN_DATE",
                    fieldLabel: '签订日期',
                    fieldStyle: 'background:#E6E6E6',//置灰
                    hidden: false,
                    editable: false
                },
                {
                    xtype: "numberFieldFormat",
                    name: "XY_AMT",
                    fieldLabel: '协议金额(原币)',
                    fieldStyle: 'background:#E6E6E6',//置灰
                    emptyText: '0.00',
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    editable: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '协议号',
                    name: "ZW_XY_NO",
                    fieldStyle: 'background:#E6E6E6',//置灰
                    editable: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '占位',
                    name: "ZHANWEI",
                    fieldStyle: 'background:#E6E6E6',//置灰
                    editable: false,
                    style: "visibility:hidden"
                },
                {
                    xtype: "numberFieldFormat",
                    name: "FETCH_AMT",
                    fieldLabel: '<span class="required">✶</span>提款金额(原币)',
                    allowBlank: false,
                    editable: false,
                    allowDecimals: true,//是否允许小数
                    decimalPrecision: 6,//小数精度
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,//上下调整箭头
                    listeners: {
                        change: function (value) {
                        }
                    }
                },
                {
                    xtype: "datefield",
                    name: "FETCH_DATE",
                    fieldLabel: '<span class="required">✶</span>提款日期',
                    allowBlank: false,
                    editable: false,
                    readOnly: true,
                    format: 'Y-m-d',
                    blankText: '请选择提款日期',
                    emptyText: '请选择提款日期',
                    listeners: {
                    }
                },
                {
                    xtype: "textfield",
                    name: "TKPZ_NO",
                    displayField: "name",
                    valueField: "id",
                    editable: false,
                    fieldLabel: '<span class="required">✶</span>提款凭证号',
                    allowBlank: false,
                    listeners: {
                        'select': function () {
                        }
                    }
                },
                {
                    xtype: "textfield",
                    name: "JZ_NO",
                    fieldLabel: '<span class="required">✶</span>记账凭证号',
                    editable: false,
                    allowBlank: false
                },
                {
                    xtype: "datefield",
                    name: "JZ_DATE",
                    fieldLabel: '<span class="required">✶</span>记账日期',
                    allowBlank: false,
                    editable: false,
                    readOnly: true,
                    format: 'Y-m-d',
                    blankText: '请选择记账日期',
                    emptyText: '请选择记账日期'
                },
                {
                    fieldLabel: '<span class="required">✶</span>汇率',
                    name: 'huilv',
                    labelAlign: 'left',
                    xtype: 'numberFieldFormat',
                    editable: true,
                    displayField: 'name',
                    valueField: 'code',
                    allowDecimals: true,//是否允许小数
                    decimalPrecision: 4,//小数精度
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,//上下调整箭头
                    allowBlank: false//不允许为空
                },
                {
                    xtype: "textarea",
                    name: "REMARK",
                    fieldLabel: '提款备注',
                    columnWidth: 1,
                    editable: true,
                    allowBlank: true
                }
            ]
        });
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
        button_name = btn.text;
        button_id = btn.name;
        if (btn.text == '撤销') {
            {
                Ext.MessageBox.show({
                    title: '撤销',
                    msg: '确定要撤销吗？',
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    fn: function (btn, text, opt) {
                        if (btn === 'yes') {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }
                    }
                });
                return;
            }
        } else if (btn.text == '退回') {
            {
                Ext.MessageBox.show({
                    title: '退回',
                    msg: '确定要退回吗？',
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    fn: function (btn, text, opt) {
                        if (btn === 'yes') {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }
                    }
                });
                return;
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
            fuc_getWorkFlowLog(records[0].get("HZD_ID"));
        }
    }

</script>
</body>
</html>
