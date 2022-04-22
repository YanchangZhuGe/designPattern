<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>项目提款申请</title>
</head>
<body>
<!--基础数据集-->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var userCode = '${sessionScope.USERCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点code
    var ad_code = '${sessionScope.ADCODE}';//当前节点code
    var node_name = "lr";//当前节点名称
    var button_name = '';//当前操作按钮名称
    var BIZ_DATA_ID;//外债协议关联id
    var BIZ_XMTK_ID;//项目提款申请主单id
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        if (items_toolbar[node_name].items[WF_STATUS].callBack) {
            items_toolbar[node_name].items[WF_STATUS].callBack();
        }
    });
    /*刷新界面*/
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.removeAll();
        //刷新
        store.loadPage(1);
        //刷新明细表
        DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();

    };
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
                initContentRightPanel()//初始化右侧2个表格
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
                    reloadGrid();
                }
            },
            apply:{
                xtype: 'button',
                text: '申请录入',
                name: 'apply',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.text;
                    OPERATE = 'APPLY';
                    window_xmtksq.show(null,btn);
                }
            },
            update: {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    //修改全局变量的值
                    button_name = btn.text;
                    title = "贷款协议修改";
                    BIZ_DATA_ID = records[0].get("DATA_ID");

                    init_edit_tksq(btn).show();
                    var xmtkRecord = records[0].getData();
                    xmtkRecord.KT_AMT = xmtkRecord.KT_AMT + xmtkRecord.SQBF_AMT;
                    var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
                    form.setValues(xmtkRecord);//将记录中的数据写进form表中
                }
            },
            delete: {
                xtype: 'button',
                text: '删除',
                name: 'delete',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            doworkupdate(records, btn);
                        }
                    });
                }
            },
            send:{
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    }else{
                        Ext.Msg.confirm('提示', '请确认是否送审！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                doworkupdate(records,btn);
                            }
                        });
                    }
                }
            },
            log: {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    operationRecord();
                }
            },
            cancel:{
                xtype: 'button',
                text: '撤销',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    }else{
                        Ext.Msg.confirm('提示', '请确认是否撤销！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                doworkupdate(records,btn);
                            }
                        });
                    }
                }
            }
        };
        items_toolbar = {
            lr: {//录入
                items: {
                    '001': [//未上报
                        items_toolbar_btns.search,
                        items_toolbar_btns.apply,
                        items_toolbar_btns.update,
                        items_toolbar_btns.delete,
                        items_toolbar_btns.send,
                        items_toolbar_btns.log,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已上报
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
                        items_toolbar_btns.delete,
                        items_toolbar_btns.send,
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
    function doworkupdate(records,btn) {
        var ids=new Array();
        var btn_name=btn.name;
        var btn_text=btn.text;
        for(var k=0;k<records.length;k++){
            var zd_id=records[k].get("XMTK_ID");
            ids.push(zd_id);
        }

        $.post("xmtkDowork.action",{
            ids: Ext.util.JSON.encode(ids),
            btn_name:btn_name,
            btn_text:btn_text,
            node_code:node_code,
            wf_id:wf_id,
            audit_info:"",
            userCode:userCode
        }, function (data_response) {
            data_response = $.parseJSON(data_response);
            if (data_response.success) {
                Ext.toast({
                    html: btn_text+"成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                reloadGrid();
            } else {
                Ext.toast({
                    html: btn_text+"失败！" + data_response.message,
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                return false;
            }
        });


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
            {
                dataIndex: "XMTK_ID",
                type: "string",
                text: "项目提款主单ID",
                fontSize: "15px",
                hidden: true
            },
            {
                dataIndex: "DATA_ID",
                type: "string",
                text: "协议ID",
                fontSize: "15px",
                hidden: true
            },
            {
                type: "string",
                text: '项目名称',
                dataIndex: "SJXM_NAME",
                hidden: true,
                width: 150
            },
            {
                type: "string",
                text: '币种',
                dataIndex: "FM_ID",
                hidden: true,
                width: 150
            },
            {
                type: "float",
                text: '汇率',
                dataIndex: "HL_RATE",
                align: 'right',
                hidden: true,
                width: 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            },
            {
                type: "string",
                text: '已提款金额（原币）',
                dataIndex: "YT_AMT",
                width: 150,
                hidden: true,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "float",
                text: '可提款金额（原币）',
                dataIndex: "KT_AMT",
                width: 150,
                hidden: true,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "string",
                text: '债权类型',
                dataIndex: "ZQFL_ID",
                hidden: true,
                width: 150
            },
            {
                type: "string",
                text: '债权人',
                dataIndex: "ZQR_ID",
                hidden: true,
                width: 150
            },
            {
                type: "string",
                text: '债权人全称',
                dataIndex: "ZQR_FULLNAME",
                hidden: true,
                width: 150
            },

            {
                type: "string",
                text: '外债名称',
                dataIndex: "WZXY_NAME",
                width: 150
            },
            {
                type: "float",
                text: '协议金额(原币万元)',
                dataIndex: "WZXY_AMT",
                width: 200,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "float",
                text: '协议金额(人民币万元)',
                dataIndex: "WZXY_AMT_RMB",
                width: 200,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                text: "申请提款金额(原币万元)",
                dataIndex: "SQBF_AMT",
                type: "float",
                width: 180,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                text: "申请提款日期",
                dataIndex: "SQBF_DATE",
                type: "string",
                width: 110,
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                text: "用途",
                dataIndex: "ZJYT",
                type: "string",
                width: 500
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: true,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code
            },
            dataUrl:"getXmtkData.action",
            checkBox: true,
            border: false,
            height: '50%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt1),
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
                            self.up('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                            self.up('grid').getStore().getProxy().extraParams["wf_id"] = wf_id;
                            self.up('grid').getStore().getProxy().extraParams["node_code"] = node_code;
                            reloadGrid();
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['XMTK_ID'] = record.get('XMTK_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
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
            {
                text: "数据id",
                dataIndex: "BIZ_ID",
                type: "string",
                width: 110,
                editor: 'textfield',
                hidden:true
            },
            {
                text: "数据类型",
                dataIndex: "DATA_TYPE",
                type: "string",
                width: 110,
                editor: 'textfield',
                hidden:true
            },
            {
                text: "地区",
                dataIndex: "AD_NAME",
                type: "string",
                width: 110,
                editor: 'textfield'
            },
            {
                text: "单位",
                dataIndex: "AG_NAME",
                type: "string",
                width: 110,
                editor: 'textfield'
            },

            {
                dataIndex: "SJXM_NAME",
                type: "string",
                text: "项目名称",
                width: 250,
                editor: 'textfield'
            },
            {
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },
            {
                dataIndex: "SQTK_AMT",
                type: "float",
                text: "申请金额(万元)",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                dataIndex: "BF_AMT",
                type: "float",
                text: "批准金额(万元)",
                width: 180,
                editable:'false',//不可编辑
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                text: "拨付日期",
                dataIndex: "BF_DATE",
                type: "string",
                width: 110,
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                dataIndex: "ZH_AMT",
                type: "float",
                text: "折合原币(万元)",
                width: 180,
                editable: false,//禁用编辑
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                dataIndex: "BF_HL",
                type: "float",
                text: "汇率",
                width: 150,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.000000',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000##');
                },
            },
            {
                text: "申请日期",
                dataIndex: "SQ_DATE",
                type: "string",
                width: 110,
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                dataIndex: "SQFM_ID",
                type: "string",
                text: "申请支付币种",
                width: 110,
                editor: 'textfield'
            },
            {
                dataIndex: "ZH_NAME",
                type: "string",
                text: "收款人",
                width: 150,
                editor: 'textfield'
            },
            {
                dataIndex: "ZH_BANK",
                type: "string",
                text: "开户银行",
                width: 150,
                editor: 'textfield'
            },
            {
                dataIndex: "ACCOUNT",
                type: "string",
                text: "账号",
                width: 150,
                editor: 'textfield'
            }
        ];
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: true,
            dataUrl: 'getXmtkDetailGrid.action',
            params: {
                XMTK_ID: BIZ_XMTK_ID
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
            }]
        };
        var grid = simplyGrid.create(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }

    /**
     * 创建提款申请弹出窗口
     */
    var window_xmtksq = {
        window: null,
        btn: null,
        config: {
            closeAction: 'destroy'
        },
        show: function (config, btn) {
            $.extend(this.config, config);
            if (!this.window || this.config.closeAction == 'destroy') {
                this.window = initWindow_xmtksq(this.config, btn);
            }
            this.window.show();
        }
    };
    /**
     * 初始化外债选择弹出窗口
     */
    function initWindow_xmtksq(params) {
        return Ext.create('Ext.window.Window', {
            title: '外债选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_clzw', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_xmtksq_grid(params)],
            buttons:[
                {
                    text: '确认',
                    //获取表格选中数据
                    handler: function (btn) {
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                            return;
                        }
                        var record = records[0].getData();
                        BIZ_DATA_ID = records[0].get("DATA_ID");
                        btn.up('window').close();
                        init_edit_tksq(btn).show();
                        DSYGrid.getGrid('wzzd_grid').getStore().loadPage(1);
                        //获取grid
                        var gridStore=Ext.ComponentQuery.query('grid[itemId="wzzd_grid"]')[0];
                        var store_data=new Array();
                        var grid_store=gridStore.getStore();
                        grid_store.on('load',function(){
                            var sum_bf_amt = 0;
                            for(var i=0;i<grid_store.getCount();i++){
                                var record_detail=grid_store.getAt(i);
                                sum_bf_amt += record_detail.get("ZH_AMT");
//                                sum_bf_amt += record_detail.get("SQTK_AMT");
                            }
                            var KT_AMT = records[0].get("KT_AMT");
                            if(KT_AMT >= sum_bf_amt){
                                record.SQBF_AMT = sum_bf_amt;
                            }else{
                                record.SQBF_AMT = KT_AMT;
                            }
                            var form = Ext.ComponentQuery.query('form#tksq_edit_form')[0].getForm();//找到该form
                            form.setValues(record);//将记录中的数据写进form表中
                        });
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
     * 初始化外债选择弹出框表格
     */
    function initWindow_xmtksq_grid() {
        var headerJson = [
//            {
//                xtype: 'rownumberer', width: 40, summaryType: 'count',
//                summaryRenderer: function () {
//                    return '合计';
//                }
//            },
            {
                xtype: 'rownumberer',
                width:40
            },
            {
                dataIndex: "DATA_ID",
                type: "string",
                text: "主键ID",
                fontSize: "15px",
                hidden: true
            },
            {
                type: "string",
                text: '地区',
                dataIndex: "AD_NAME",
                width: 150
            },
            {
                dataIndex: "WZXY_CODE",
                type: "string",
                width: 130,
                text: "外债编码",
                hidden: true
            },
            {
                type: "string",
                text: '外债名称',
                dataIndex: "WZXY_NAME",
                width: 150
            },
            {
                type: "string",
                text: '项目名称',
                dataIndex: "SJXM_NAME",
                width: 150
            },
            {
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },
            {
                text: '协议金额(原币万元)',
                dataIndex: "WZXY_AMT",
                width: 200,
                type:"float",
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "string",
                text: '币种',
                dataIndex: "FM_ID",
                width: 150
            },
            {
                type: "float",
                text: '汇率',
                dataIndex: "HL_RATE",
                width: 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000##');
                }
            },
            {
                type: "string",
                text: '协议金额(人民币万元)',
                dataIndex: "WZXY_AMT_RMB",
                width: 200,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "string",
                text: '已提款金额(原币万元)',
                dataIndex: "YT_AMT",
                width: 200,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "string",
                text: '可提款金额(原币万元)',
                dataIndex: "KT_AMT",
                width: 200,
                align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                type: "string",
                text: '债权类型',
                dataIndex: "ZQFL_ID",
                width: 150
            },
            {
                type: "string",
                text: '债权人',
                dataIndex: "ZQR_ID",
                width: 150
            },
            {
                type: "string",
                text: '债权人全称',
                dataIndex: "ZQR_FULLNAME",
                width: 150
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'wzSelectionGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                ad_code:ad_code,
                WF_STATUS: "002"
            },
            checkBox: true,
            border: false,
            autoLoad: true,
            height: '100%',
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            tbar: [
                {
                    xtype: "textfield",
                    name: "mhcx",
                    id: "mhcx",
                    fieldLabel: '模糊查询',
                    allowBlank: true,  // requires a non-empty value
                    labelWidth: 70,
                    width: 260,
                    labelAlign: 'right',
                    emptyText: '请输入外债名称...',
                    enableKeyEvents: true,
                    listeners: {
                        keypress: function (self, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                var store = self.up('grid').getStore();
                                store.getProxy().extraParams['mhcx'] = self.getValue();
                                // 刷新表格
                                self.up('grid').getStore().loadPage(1);
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                        btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                        btn.up('grid').getStore().loadPage(1);

                    }
                }
            ],
//            features: [{
//                ftype: 'summary'
//            }],
            dataUrl: 'getWzxySelect.action',
            listeners: {
                itemclick: function (self, record) {
                }
            }
        });
    }


    /**
     * 创建并弹出新增提款信息窗口
     */
    function init_edit_tksq(btn, record) {
        return Ext.create('Ext.window.Window', {
            title: '项目提款申请',
            itemId: 'jjxxadd',
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.9, // 窗口高度
            frame: true,
            constrain: true,//防止超出浏览器边界
            buttonAlign: "right",// 按钮显示的位置：右下侧
            maximizable: true,//最大化按钮
            modal: true,//模态窗口
            resizable: true,//可拖动改变窗口大小
            layout: 'fit',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            closeAction: 'destroy',
            items: [initEditor()],
            buttons: [
                {
                    //xtype: 'button',
                    text: '保存',
                    name: 'btn_update',
                    id: 'save',
                    handler: function (btn) {
                        saveXmtkInfo(btn);
                    }
                },
                {
                    //xtype: 'button',
                    text: '关闭',
                    name: 'btn_delete',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }

    /**
     * 保存项目提款申请
     */
    function saveXmtkInfo(self) {
        var form = self.up('window').down('form');
        if (form.isValid()) {
            var formData = form.getForm().getFieldValues();
            if(formData.SQBF_AMT<=0){
                Ext.MessageBox.alert('提示', '请输入申请提款金额！');
                return;
            }
            var records = DSYGrid.getGrid('wzzd_grid').getStore().data.items;
            var wztkIdInfoArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.BIZ_ID = record.get("BIZ_ID");
                array.DATA_TYPE = record.get("DATA_TYPE");
                wztkIdInfoArray.push(array);
            });
            self.setDisabled(true);
            $.post('saveXmtkInfo.action', {
                node_code: node_code,
                wf_id: wf_id,
                button_name:button_name,
                XMTK_ID:formData.XMTK_ID,
                SQBF_DATE:format(formData.SQBF_DATE, 'yyyy-MM-dd'),
                SQBF_AMT:formData.SQBF_AMT,
                WZXY_ID:formData.DATA_ID,
                ZJYT:formData.ZJYT,
                wztkIdInfoArray: Ext.util.JSON.encode(wztkIdInfoArray)
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: '保存成功！',
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    self.up('window').close();
                    // 刷新表格
                    reloadGrid()
                } else {
                    Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                    self.setDisabled(false);
                }

            }, 'JSON');
        }
    }
    /**
     * 初始化债券转贷表单
     */
    function initEditor() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'tksq_edit_form',
            width: '100%',
            height: '100%',
            layout: 'vbox',
            fileUpload: true,
            padding: '2 5 0 5',
            defaults: {
                columnWidth:.33,//输入框的长度（百分比）
                labelAlign: "right",
                width: '100%'
            },
            border: false,
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 4 5',
                        columnWidth: .33,
                        //width: 280,
                        labelWidth: 150//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            fieldLabel: '外债协议ID',
                            disabled: false,
                            name: "DATA_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '项目提款主单ID',
                            disabled: false,
                            name: "XMTK_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '外债名称',
                            name: "WZXY_NAME",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '项目名称',
                            name: "SJXM_NAME",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债权类型',
                            name: "ZQFL_ID",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债权人',
                            name: "ZQR_ID",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债权人全称',
                            name: "ZQR_FULLNAME",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '币种',
                            name: "FM_ID",
                            editable: false,//禁用编
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '汇率',
                            name: "HL_RATE",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '协议金额（原币）',
                            name: "WZXY_AMT",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true

                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '协议金额人民币',
                            name: "WZXY_AMT_RMB",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true

                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    margin: '5 0 5 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 4 5',
                        columnWidth: .33,
                        //width: 280,
                        labelWidth: 150//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '已提款金额（原币）',
                            name: "YT_AMT",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true

                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '可提款金额（原币）',
                            name: "KT_AMT",
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true

                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '<span class="required">✶</span>申请提款金额（原币）',
                            name: "SQBF_AMT",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
//                            minValue:0.01,
                            allowBlank: false,
                            listeners:{
                                'change': function (self, newValue, oldValue) {
                                    var form = this.up('form').getForm();
                                    var KT_AMT = form.findField('KT_AMT').value;
                                    if(newValue>KT_AMT){
                                        Ext.toast({
                                            html: '申请提款金额不能大于可提款金额！',
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        form.findField("SQBF_AMT").setValue('');
                                    }
                                }
                            }
                        },
                        {
                            xtype: "datefield",
                            fieldLabel: '<span class="required">✶</span>申请提款日期',
                            name: "SQBF_DATE",
                            editable: true,
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择申请提款日期',
                            emptyText: '请选择申请提款日期',
                            value: new Date()
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '用途',
                            name: "ZJYT",
                            editable: true,
                            columnWidth: .99,
                            allowBlank: true
                        }
                    ]
                },
                initWindow_input1_contentForm_grid()
            ]
        });
    }

    /**
     * 初始化债券转贷表单中转贷明细信息表格
     */
    function initWindow_input1_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                text: "数据id",
                dataIndex: "BIZ_ID",
                type: "string",
                width: 110,
                editor: 'textfield',
                hidden:true
            },
            {
                text: "数据类型",
                dataIndex: "DATA_TYPE",
                type: "string",
                width: 110,
                editor: 'textfield',
                hidden:true
            },
            {
                text: "地区",
                dataIndex: "AD_NAME",
                type: "string",
                width: 110,
                editor: 'textfield'
            },
            {
                text: "单位",
                dataIndex: "AG_NAME",
                type: "string",
                width: 110,
                editor: 'textfield'
            },

            {
                dataIndex: "SJXM_NAME",
                type: "string",
                text: "项目名称",
                width: 250,
                editor: 'textfield'
            },
            {
                dataIndex: "SQTK_AMT",
                type: "float",
                text: "申请金额(万元)",
                width: 180,
//                summaryType: 'sum',
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
//                summaryRenderer: function (value) {
//                    return Ext.util.Format.number(value, '0,000.######');
//                }
            },
            {
                dataIndex: "BF_AMT",
                type: "float",
                text: "批准金额(万元)",
                width: 180,
//                summaryType: 'sum',
                editable:'false',//不可编辑
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
//                summaryRenderer: function (value) {
//                    return Ext.util.Format.number(value, '0,000.######');
//                }
            },
            {
                text: "拨付日期",
                dataIndex: "BF_DATE",
                type: "string",
                width: 110,
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                dataIndex: "ZH_AMT",
                type: "float",
                text: "折合原币(万元)",
                width: 180,
                summaryType: 'sum',
                editable: false,//禁用编辑
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.######');
                }
            },
            {
                dataIndex: "BF_HL",
                type: "float",
                text: "汇率",
                width: 150,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false
                }
            },
            {
                text: "申请日期",
                dataIndex: "SQ_DATE",
                type: "string",
                width: 110,
                editor: {xtype: 'datefield', format: 'Y-m-d'}
            },
            {
                dataIndex: "SQFM_ID",
                type: "string",
                text: "申请支付币种",
                width: 110,
                editor: 'textfield'
            },
            {
                dataIndex: "ZH_NAME",
                type: "string",
                text: "收款人",
                width: 150,
                editor: 'textfield'
            },
            {
                dataIndex: "ZH_BANK",
                type: "string",
                text: "开户银行",
                width: 150,
                editor: 'textfield'
            },
            {
                dataIndex: "ACCOUNT",
                type: "string",
                text: "账号",
                width: 150,
                editor: 'textfield'
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'wzzd_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: true,
            dataUrl: 'getTkhzGridData.action',
            params: {
                DATA_ID: BIZ_DATA_ID
            },
            features: [{
                ftype: 'summary'
            }],
            border: false,
            flex: 1,
            height: '100%',
            width: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
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
            fuc_getWorkFlowLog(records[0].get("XMTK_ID"));
        }
    }
</script>
</body>
</html>