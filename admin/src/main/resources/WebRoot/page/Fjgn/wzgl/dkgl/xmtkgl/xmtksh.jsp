<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>项目提款到账登记</title>
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
    });
    /*刷新界面*/
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.removeAll();
        //刷新
        store.loadPage(1);
        //刷新明细表
        DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['XMTK_ID'] = "";
        DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
    };
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
                    reloadGrid();
                }
            },//查询
            down:{
                xtype: 'button',
                text: '登记',
                name: 'down',
                icon: '/image/sysbutton/songsheng.png',
                handler: function (btn) {
                    doWorkFlow(btn);
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
                width: 150
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
                type: "string",
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
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt2_6),
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
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: true,
            border: false,
            height: '50%',
            dataUrl: 'getXmtkDetailGrid.action',
            params: {
                DATA_ID: BIZ_XMTK_ID
            },
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
        if(btn.name=='cancel'){
            Ext.Msg.confirm('提示', '请确认是否撤销审核！', function (btn_confirm) {
                if (btn_confirm == 'yes') {
                    doworkupdate(records,btn);
                }
            });
        }else{
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text,
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        doworkupdate(records,btn);
                    }
                }
            });
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
