<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>罚息录入审核</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    var userCode = '${sessionScope.USERCODE}';
    var AD_CODE = '${sessionScope.ADCODE}';
  /*  var wf_id = getQueryParam("wf_id");//当前流程id
    var node_code = getQueryParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var node_name = "";//当前节点名称
    var button_name = '';//当前操作按钮名称
/*
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    //var v_child = '1';
   /* if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var json_zt;//状态json
    if (node_code == '1') {
        node_name = 'lr'
        btn_title = '送审';
        json_zt = json_debt_zt0;
    } else if (node_code == '2') {
        node_name = 'sh'
        btn_title = '审核';
        json_zt = json_debt_zt2_2;
    }
    var records_delete = [];//记录明细删除行数据
    var IS_EDIT;//弹出编辑框是否可编辑
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
                initContentTree({
                    items_tree: function () {
                        return [
                            initContentTree_area()
                        ]
                    }
                }),
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
                text: '查询', xtype: 'button', name: 'search', icon: '/image/sysbutton/search.png',
                handler: function() {
                    reloadGrid();
                }
            },
            insert: {
                text: '新增', xtype: 'button', name: 'search', icon: '/image/sysbutton/add.png',
                handler: function(btn) {
                    button_name = btn.text;
                    IS_EDIT = true;
                    initWindow_select_fxjn().show();
                }
            },
            update: {
                text: '修改', xtype: 'button', name: 'search', icon: '/image/sysbutton/edit.png',
                handler: function(btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    IS_EDIT = true;
                    //发送ajax请求，根据id查询罚息缴纳主表明细表数据
                    $.post("/selectFxjnDataById.action", {
                        FXJN_ID: records[0].get('FXJN_ID')
                    }, function (data) {
                        if (data.success) {
                            //定义form主单的id
                            window_edit_fxjn.fxjnGridId = data.data.FXJN_ID;
                            //弹出弹出框，并将主表和明细表数据插入到弹出框form和grid中
                            window_edit_fxjn.show();
                            window_edit_fxjn.window.down('form#window_save_fxjn_form').getForm().setValues(data.data);
                            for (var i = 0; i < data.list.length; i++) {
                                var obj = data.list[i];
                                obj.FLAG_EDIT = 'UPDATE';//设置操作标识为修改
                            }
                            DSYGrid.getGrid('window_save_fxjn_grid').insertData(null, data.list);
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                    }, "json");
                }
            },
            del: {
                text: '删除', xtype: 'button', name: 'search', icon: '/image/sysbutton/delete.png',
                handler: function(btn) {
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
                                ids.push(records[i].get("FXJN_ID"));
                            }
                            //发送ajax请求，删除数据
                            $.post("/deleteFxjnDataById.action", {
                                ids: ids
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: button_name + "成功！" + (data.message ? data.message : ''),
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
            down: {
                text: btn_title, xtype: 'button', name: 'down', icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            back: {
                text: '退回', xtype: 'button', name: 'back', icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            cancel: {
                text: '撤销' + btn_title, name: 'cancel', xtype: 'button', icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            log: {
                text: '操作记录', name: 'log', xtype: 'button', icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            }
        };
        items_toolbar = {
            lr: {//录入
                items: {
                    '001': [//未送审
                        items_toolbar_btns.search,
                        items_toolbar_btns.insert,
                        items_toolbar_btns.update,
                        items_toolbar_btns.del,
                        items_toolbar_btns.down,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已送审
                        items_toolbar_btns.search,
                        items_toolbar_btns.cancel,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [//被退回
                        items_toolbar_btns.search,
                        items_toolbar_btns.update,
                        items_toolbar_btns.del,
                        items_toolbar_btns.down,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [//已曾经办
                        items_toolbar_btns.search,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            },
            sh: {//审核
                items: {
                    '001': [//未审核
                        items_toolbar_btns.search,
                        items_toolbar_btns.down,
                        items_toolbar_btns.back,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已审核
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
                        items_toolbar_btns.back,
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
        var config = {
            editable: false,
            busiId: ''
        };
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
                initContentGrid(),
                {
                    xtype: 'tabpanel',
                    border: false,
                    flex: 1,
                    itemId: 'winPanel_MainPanel',
                    items: [
                        {
                            title: '明细',
                            layout: 'fit',
                            name: 'detail',
                            items: [initContentDetailGrid()]
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            name: 'attachment',
                            layout: 'fit',
                            scrollable: true,
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    items: initWindow_fxjn_attachment(config)
                                }
                            ],
                            listeners: {
                                beforeactivate: function (self) {
                                    // 检验明细是否有数据
                                    var grid = self.up('tabpanel').down('grid#contentDetailGrid');
                                    if (grid.getStore().getCount() <= 0) {
                                        Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                                        return false;
                                    }
                                    // 获取选中数据
                                    var record = grid.getCurrentRecord();
                                    //如果当前无选中行，默认选中第一条数据
                                    if (!record) {
                                        $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                        record = grid.getStore().getAt(0);
                                        Ext.toast({
                                            html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                    }
                                    var panel = self.down('panel');
                                    panel.removeAll(true);
                                    panel.add(initWindow_fxjn_attachment({
                                        editable: false,
                                        busiId: record.get('FXJN_DTL_ID')
                                    }));
                                }
                            }
                        }
                    ]
                }
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
            {text: "罚息缴款ID", dataIndex: "FXJN_ID", type: "string", hidden:true},
            {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
            {text: "缴纳日期", dataIndex: "FXJN_DATE", type: "string", width: 100},
            {text: "缴纳罚息金额(元)", dataIndex: "SUM_FXJN_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "免除罚息金额(元)", dataIndex: "SUM_FXMC_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "经办人", dataIndex: "APPLY_INPUTOR", type: "string", width: 200},
            {text: "备注", dataIndex: "REMARK", type: "string", width: 200},
            {text: "是否确认", dataIndex: "IS_CONFIRM", type: "string", width: 200, hidden: true}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            flex: 1,
            autoLoad: true,
            params: {
                AD_CODE: AD_CODE,
                wf_id: wf_id,
                WF_STATUS: WF_STATUS,
                node_code: node_code,
                userCode: userCode
            },
            dataUrl: '/getFxjnMainList.action',
            checkBox: true,
            border: false,
            height: '50%',
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
                            reloadGrid();
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentDetailGrid').getStore().getProxy().extraParams['FXJN_ID'] = record.get('FXJN_ID');
                    DSYGrid.getGrid('contentDetailGrid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                    DSYGrid.getGrid('contentDetailGrid').getStore().loadPage(1);
                },
                itemdblclick: function (self, record){
                    IS_EDIT = false;
                    //发送ajax请求，根据id查询罚息缴纳主表明细表数据
                    $.post("/selectFxjnDataById.action", {
                        FXJN_ID: record.get('FXJN_ID')
                    }, function (data) {
                        if (data.success) {
                            //定义form主单的id
                            window_edit_fxjn.fxjnGridId = data.data.FXJN_ID;
                            //弹出弹出框，并将主表和明细表数据插入到弹出框form和grid中
                            window_edit_fxjn.show();
                            window_edit_fxjn.window.down('form#window_save_fxjn_form').getForm().setValues(data.data);
                            for (var i = 0; i < data.list.length; i++) {
                                var obj = data.list[i];
                                obj.FLAG_EDIT = 'UPDATE';//设置操作标识为修改
                            }
                            DSYGrid.getGrid('window_save_fxjn_grid').insertData(null, data.list);
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                    }, "json");
                }
            }
        });
    }

    /**
     * 初始化明细表格
     */
    function initContentDetailGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string", hidden: true},
            {text: "明细ID", dataIndex: "FXJN_DTL_ID", type: "string", width: 150, hidden: true},
            {text: "还款单ID", dataIndex: "HKD_ID", type: "string", width: 150,hidden: true},
            {text: "债券ID", dataIndex: "ZQ_ID", type: "string", width: 150,hidden: true},
            {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE.replace(/00$/, "");
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 100},
            {text: "应付罚息(元)", dataIndex: "YFFX_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "缴纳罚息金额(元)", dataIndex: "FXJN_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "免除金额(元)", dataIndex: "FXMC_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 150},
            {text: "逾期本金(元)", dataIndex: "YQBJ_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "逾期利息(元)", dataIndex: "YQLX_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "实际还款日期", dataIndex: "PAY_DATE", type: "string", width: 150},
            {text: "逾期天数", dataIndex: "YQ_DAYS", type: "string", width: 150},
            {text: "罚息率(‰)", dataIndex: "ZNJ_RATE", type: "float", width: 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value*10, '0,000.00####');
                }
            },
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 150},
            {text: "债券利率%", dataIndex: "PM_RATE", type: "float", width: 150}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentDetailGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            flex: 1,
            autoLoad: false,
            params: {
                AD_CODE: AD_CODE
            },
            dataUrl: '/getFxjnDetailList.action',
            checkBox: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            listeners: {
            }
        });
    }

    /**
     * 新增录入：初始化罚息缴纳选择弹出窗口
     */
    function initWindow_select_fxjn() {
        return Ext.create('Ext.window.Window', {
            title: '罚息缴纳选择', // 窗口标题
            width: document.body.clientWidth * 0.95, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_select_fxjn', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_fxjn_grid()],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window#window_select_fxjn').down('grid#window_select_fxjn_grid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        }
                        //获取还款明细信息
                        var data_mx = [];
                        data_main = records[0].getData();
                        for (var i = 0; i < records.length; i++) {
                            var obj = records[i].getData();
                            data_mx.push(obj);
                        }
                        $.post("/getId.action", {size: records.length + 1}, function (data) {
                            //如填报页面不存在，弹出填报页面
                            if (Ext.ComponentQuery.query('window#window_edit_fxjn').length == 0) {
                                window_edit_fxjn.show();
                                window_edit_fxjn.window.down('form').getForm().setValues(data_main);
                            }
                            //循环插入数据，如果已存在该兑付计划，不录入
                            var sbGridStore = window_edit_fxjn.window.down('grid').getStore();
                            for (var i = 0; i < data_mx.length; i++) {
                                var obj = data_mx[i];
                                //给每条明细增加ID，后面附件使用
                                obj.FXJN_DTL_ID = data.data[i + 1];
                                obj.FLAG_EDIT = 'INSERT';//设置操作标识为插入
                                obj.FXJN_AMT = obj.YFFX_AMT;//设置默认值
                                var record_zqid = sbGridStore.findRecord('ZQ_ID', obj.ZQ_ID, 0, false, true, true);
                                var record_hkd_id = sbGridStore.findRecord('HKD_ID', obj.HKD_ID, 0, false, true, true);
                                var record_df_end_date = sbGridStore.findRecord('DF_END_DATE', obj.DF_END_DATE, 0, false, true, true);
                                var record_pay_date = sbGridStore.findRecord('PAY_DATE', obj.PAY_DATE, 0, false, true, true);
                                //根据条件判断去重
                                if (record_zqid != null && record_hkd_id != null && record_df_end_date != null && record_pay_date != null) {
                                    continue;
                                }
                                DSYGrid.getGrid('window_save_fxjn_grid').insertData(null, obj);
                            }
                            btn.up('window').close();
                        }, "json");
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
     * 新增录入：初始化罚息缴纳选择弹出表格
     */
    function initWindow_select_fxjn_grid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
            {text: "还款单ID", dataIndex: "HKD_ID", type: "string", width: 150,hidden: true},
            {text: "债券ID", dataIndex: "ZQ_ID", type: "string", width: 150,hidden: true},
            {text: "债券代码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE.replace(/00$/, "");
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 100},
            {text: "应付罚息(元)", dataIndex: "YFFX_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 100, align: "center"},
            {text: "逾期本金(元)", dataIndex: "YQBJ_AMT", type: "float", width: 200,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "逾期利息(元)", dataIndex: "YQLX_AMT", type: "float", width: 200,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "实际还款日期", dataIndex: "PAY_DATE", type: "string", width: 150},
            {text: "逾期天数", dataIndex: "YQ_DAYS", type: "string", width: 150},
            {text: "罚息率(‰)", dataIndex: "ZNJ_RATE", type: "string", width: 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value*10, '0,000.00####');
                }
            },
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 150},
            {text: "债券利率%", dataIndex: "PM_RATE", type: "string", width: 150}
        ];
        return DSYGrid.createGrid({
            itemId: 'window_select_fxjn_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            checkBox: true,
            border: false,
            height: '100%',
            flex: 1,
            params: {
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE
            },
            pageConfig: {
                enablePage: false
            },
            dataUrl: '/getFxjnSelectList.action',
            tbar: [
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类别',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 220,
                    labelAlign: 'left',
                    listeners: {
                        change: function (self, newValue) {
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    fieldLabel: '模糊查询',
                    xtype: "textfield",
                    name: 'contentGrid_search',
                    itemId: 'contentGrid_search',
                    width: 320,
                    labelWidth: 60,
                    labelAlign: 'right',
                    enableKeyEvents: true,
                    emptyText: '请输入债券名称/债券编码...',
                    listeners: {
                        keypress: function (self, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                var store = self.up('grid').getStore();
                                store.getProxy().extraParams['contentGrid_search'] = self.getValue();
                                // 刷新表格
                                store.loadPage(1);
                            }
                        }
                    }
                },
                '->',
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var store = btn.up('grid').getStore();
                        store.getProxy().extraParams['contentGrid_search'] = btn.up('grid').down('[name=contentGrid_search]').getValue();
                        store.getProxy().extraParams['ZQLB_ID'] = btn.up('grid').down('[name=ZQLB_ID]').getValue();
                        // 刷新表格
                        store.load();
                    }
                }
            ]
        });
    }

    //创建罚息缴纳编辑弹出窗口
    var window_edit_fxjn = {
        window: null,
        show: function () {
            if (!this.window) {
                this.window = initWindow_edit_fxjn();
            }
            this.window.show();
        }
    };

    /**
     * 初始化罚息缴纳编辑弹出窗口
     */
    function initWindow_edit_fxjn() {
        records_delete = [];
        var config = {
            editable: false,
            busiId: ''
        };
        return Ext.create('Ext.window.Window', {
            title: '罚息缴纳编辑', // 窗口标题
            width: document.body.clientWidth * 0.95, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            maximizable: true,
            itemId: 'window_edit_fxjn', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_save_fxjn_form(),//罚息缴纳编辑保存表单
                {
                    xtype: 'tabpanel',
                    border: false,
                    flex: 1,
                    itemId: 'winPanel_tabPanel',
                    items: [
                        {
                            title: '明细',
                            layout: 'fit',
                            name: 'detail',
                            items: [initWindow_save_fxjn_grid()]//罚息缴纳编辑保存表格
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            name: 'attachment',
                            layout: 'fit',
                            scrollable: true,
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    items: initWindow_fxjn_attachment(config)
                                }
                            ],
                            listeners: {
                                beforeactivate: function (self) {
                                    // 检验明细是否有数据
                                    var grid = self.up('tabpanel').down('grid#window_save_fxjn_grid');
                                    if (grid.getStore().getCount() <= 0) {
                                        Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                                        return false;
                                    }
                                    // 获取选中数据
                                    var record = grid.getCurrentRecord();
                                    //如果当前无选中行，默认选中第一条数据
                                    if (!record) {
                                        $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                        record = grid.getStore().getAt(0);
                                        Ext.toast({
                                            html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                    }
                                    var panel = self.down('panel');
                                    panel.removeAll(true);
                                    panel.add(initWindow_fxjn_attachment({
                                        editable: IS_EDIT,
                                        busiId: record.get('FXJN_DTL_ID')
                                    }));
                                }
                            }
                        }
                    ]
                }

            ],
            buttons: [
                {
                    xtype: 'button',
                    text: '增加',
                    width: 60,
                    hidden: !IS_EDIT,
                    handler: function () {
                        initWindow_select_fxjn().show();
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'DelBtn',
                    text: '删行',
                    width: 60,
                    hidden: !IS_EDIT,
                    disabled: true,
                    handler: function (btn) {
                        var grid = btn.up('window').down('tabpanel').down('grid#window_save_fxjn_grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        var records = sm.getSelection();
                        grid.getPlugin('fxjn_grid_plugin_cell').cancelEdit();
                        for (var i = 0; i < records.length; i++) {
                            var obj = records[i];
                            if (obj.get('FLAG_EDIT') == 'UPDATE') {//修改明细时如果删除行，记录删除行数据
                                records_delete.push(obj.getData())
                            }
                        }
                        store.remove(records);
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '保存',
                    hidden: !IS_EDIT,
                    handler: function (btn) {

                        //获取grid
                        var grid = btn.up('window').down('tabpanel').down('#window_save_fxjn_grid');
                        var celledit = grid.getPlugin('fxjn_grid_plugin_cell');
                        //完成编辑
                        celledit.completeEdit();
                        //先校验后保存
                        if (window.flag_fxjn_validateedit && !window.flag_fxjn_validateedit.isHidden()) {
                            return false;//如果校验未通过
                        }
                        var form = btn.up('window').down('form');
                        var gridData = [];//所有明细数据
                        var records_add = [];//新增行
                        var records_update = [];//修改行
                        for (var i = 0; i < grid.getStore().getCount(); i++) {
                            var record = grid.getStore().getAt(i);
                            gridData.push(record.data);
                            if (record.get('FLAG_EDIT') == 'INSERT') {
                                records_add.push(record.data);
                            }
                            if (record.get('FLAG_EDIT') == 'UPDATE') {
                                records_update.push(record.data);
                            }
                        }
                        if (grid.getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '请填写罚息缴纳记录！');
                            return false;
                        }
                        var parameters = {
                            userCode: userCode,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            detailList: Ext.util.JSON.encode(gridData),
                            listAdd: Ext.util.JSON.encode(records_add),
                            listUpdate: Ext.util.JSON.encode(records_update),
                            listDelete: Ext.util.JSON.encode(records_delete)
                        };
                        if (button_name == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.FXJN_ID = records[0].get('FXJN_ID');
                        }
                        if (form.isValid()) {
                            btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveFxjnInfo.action',
                                params: parameters,
                                success: function (form, action) {
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
                        } else {
                            Ext.Msg.alert('提示', '请检查必填项！');
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ],
            listeners: {
                close: function () {
                    window_edit_fxjn.window = null;
                }
            }
        });
    }

    /**
     * 罚息缴纳编辑保存表单
     */
    function initWindow_save_fxjn_form() {
        return Ext.create('Ext.form.Panel',{
            itemId: 'window_save_fxjn_form',
            width: '100%',
            layout: 'column',
            border: false,
            defaults: {
                columnWidth: .33,
                margin: '2 5 2 5',
                labelWidth: 130
            },
            margin: '0 0 5 0',
            defaultType: 'textfield',
            items: [
                {fieldLabel: '地区', name: 'AD_NAME', xtype: 'textfield', readOnly: true, fieldCls: 'form-unedit'},
                {fieldLabel: '区划编码', name: 'AD_CODE', xtype: 'textfield', readOnly: true, fieldCls: 'form-unedit', hidden: true},
                {fieldLabel: '上级转贷区划', name: 'U_AD_CODE', xtype: 'textfield', readOnly: true, fieldCls: 'form-unedit', hidden: true},
                {fieldLabel: '缴纳日期', name: 'FXJN_DATE', xtype: 'datefield', value: new Date(),editable: false, allowBlank: false, format: 'Y-m-d',fieldCls: IS_EDIT?'form-edit':'form-unedit',readOnly: !IS_EDIT},
                {fieldLabel: '经办人', name: 'APPLY_INPUTOR', value: top.userName, fieldCls: 'form-unedit', readOnly: true},
                {fieldLabel: "缴纳罚息金额(元)", name: "SUM_FXJN_AMT", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "免除罚息金额(元)", name: "SUM_FXMC_AMT", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "备注", name: "REMARK", xtype: 'textfield', fieldCls: IS_EDIT?'form-edit':'form-unedit',columnWidth: .66,readOnly: !IS_EDIT}
            ]
        });
    }

    /**
     * 罚息缴纳编辑保存表格
     */
    function initWindow_save_fxjn_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string", hidden: true},
            {text: "明细ID", dataIndex: "FXJN_DTL_ID", type: "string", width: 150, hidden: true},
            {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150, hidden: true},
            {text: "还款单ID", dataIndex: "HKD_ID", type: "string", width: 150,hidden: true},
            {text: "债券ID", dataIndex: "ZQ_ID", type: "string", width: 100, tdCls: 'grid-cell-unedit', hidden:true},
            {text: "债券代码", dataIndex: "ZQ_CODE", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350, tdCls: 'grid-cell-unedit',
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE.replace(/00$/, "");
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 100, tdCls: 'grid-cell-unedit'},
            {text: "应付罚息(元)", dataIndex: "YFFX_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit',
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "缴纳罚息金额(元)", dataIndex: "FXJN_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit',

                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "免除金额(元)", dataIndex: "FXMC_AMT", type: "float", width: 180, tdCls: IS_EDIT?'grid-cell':'grid-cell-unedit',
                editor: {hideTrigger: true, xtype: 'numberFieldFormat', allowBlank: false, decimalPrecision: 2, minValue: 0},
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }

            },
            {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 100, tdCls: 'grid-cell-unedit'},
            {text: "逾期本金(元)", dataIndex: "YQBJ_AMT", type: "float", width: 200, tdCls: 'grid-cell-unedit',
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "逾期利息(元)", dataIndex: "YQLX_AMT", type: "float", width: 200, tdCls: 'grid-cell-unedit',
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "实际还款日期", dataIndex: "PAY_DATE", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
            {text: "逾期天数", dataIndex: "YQ_DAYS", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
            {text: "罚息率(‰)", dataIndex: "ZNJ_RATE", type: "string", width: 150, tdCls: 'grid-cell-unedit',
                renderer: function (value) {
                    return Ext.util.Format.number(value*10, '0,000.00####');
                }
            },
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
            {text: "债券利率%", dataIndex: "PM_RATE", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
            {text: "提前还款天数", dataIndex: "TQHK_DAYS", type: "string", width: 150, tdCls: 'grid-cell-unedit', hidden: true}
        ];
        var config = {
            itemId: 'window_save_fxjn_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SINGLE"
            },
            checkBox: true,
            border: false,
            height: '100%',
            flex: 1,
            features: [{
                ftype: 'summary'
            }],
            pageConfig: {
                enablePage: false
            },
            data:[],
            tbar: [
            ],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'fxjn_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        validateedit: function (editor, context) {
                            window.flag_fxjn_validateedit = null;
                            if(context.field=="FXMC_AMT") {
                                if ((context.record.get("YFFX_AMT") - context.value) < 0) {//缴纳罚息金额=应付罚息金额-免除金额>=0
                                    Ext.MessageBox.alert('提示','缴纳罚息金额应不小于0!');
                                    return false;
                                }
                            }
                        },
                        edit: function (editor, context) {
                            if(context.field=="FXMC_AMT") {
                                var fxjn_amt =  context.record.get("YFFX_AMT") - context.value;//缴纳罚息金额=应付罚息金额-免除金额
                                context.record.set("FXJN_AMT",fxjn_amt);
                            }
                        }
                    }
                }],
            listeners: {
                selectionChange: function (view, records) {
                    grid.up('window').down('#DelBtn').setDisabled(!records.length);
                }
            }
        };
        if (!IS_EDIT) {
            delete config.plugins;
        }
        var grid = DSYGrid.createGrid(config);
        grid.getStore().on('endupdate', function () {
            //计算并录入form罚息缴纳金额、罚息免除金额
            var self = grid.getStore();
            var sum_fxjn_amt = 0;
            var sum_fxmc_amt = 0;
            self.each(function (record) {
                sum_fxjn_amt += record.get('FXJN_AMT');
                sum_fxmc_amt += record.get('FXMC_AMT');
            });
            grid.up('tabpanel').up('window').down('form#window_save_fxjn_form').down('[name="SUM_FXJN_AMT"]').setValue(sum_fxjn_amt);
            grid.up('tabpanel').up('window').down('form#window_save_fxjn_form').down('[name="SUM_FXMC_AMT"]').setValue(sum_fxmc_amt);
        });
        return grid;
    }

    /**
     * 罚息缴纳附件页签
     */
    function initWindow_fxjn_attachment(config) {
        var grid = UploadPanel.createGrid({
            busiType: 'ET248',//业务类型
            busiId: config.busiId,//业务ID
            editable: config.editable,//是否可以修改附件内容
            gridConfig: {
                itemId: config.editable?'window_fxjn_attachment_grid_edit':'window_fxjn_attachment_grid_view'
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else if ($('span.file_sum')) {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;

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
            if (btn.text == '撤销审核' && records[i].get("IS_CONFIRM") == '1') {
                Ext.MessageBox.alert('提示', '已确认数据不能撤销审核！');
                return;
            }
            ids.push(records[i].get("FXJN_ID"));
        }
        button_name = btn.text;
        if (button_name == '审核' || button_name == '退回') {
            var op_value = '';
            if (button_name == "审核") {   //判断按钮名称 获取对应意见内容
                op_value = '同意';
            } else if (button_name == '退回') {
                op_value = '';
            }
            //弹出意见填写对话框
            initWindow_opinion({
                value: op_value,
                title: btn.text + "意见",
                animateTarget: btn,
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/doWorkFlowFxjn.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！" + (data.message ? data.message : ''),
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
                            }
                            //刷新表格
                            reloadGrid();
                        }, "json");
                    }
                }
            });
        } else {
            Ext.Msg.confirm('提示', '请确认是否' + button_name + '?', function (btn_confirm) {
                if (btn_confirm == 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/doWorkFlowFxjn.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！" + (data.message ? data.message : ''),
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
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
            fuc_getWorkFlowLog(records[0].get("FXJN_ID"));
        }
    }

    /**
     * 刷新页面
     */
    function reloadGrid() {
        var store = DSYGrid.getGrid("contentGrid").getStore();
        var dtlStore = DSYGrid.getGrid("contentDetailGrid").getStore();
        var attachStore = DSYGrid.getGrid("window_fxjn_attachment_grid_view").getStore();
        //初始化表格Store参数
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            WF_STATUS: WF_STATUS,
            AD_CODE: AD_CODE
        };
        //刷新表格内容
        store.loadPage(1);
        dtlStore.removeAll();
        attachStore.removeAll();
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
</script>
</body>
</html>