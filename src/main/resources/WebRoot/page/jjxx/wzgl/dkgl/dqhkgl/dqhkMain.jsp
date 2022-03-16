<%--
  Created by IntelliJ IDEA.
  User: zhangsa
  Date: 2018/6/28
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>到期还款主界面</title>
    <style type="text/css">
        .x-grid-back-green {
            background: #00ff00;
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id，1：录入岗；2：审核岗
    var button_name = '';//当前操作按钮名称
    var button_text = '';
    var AD_CODE='${sessionScope.ADCODE}';
    if(AD_CODE!=null&&AD_CODE!=undefined&&AD_CODE!=''){
        if(AD_CODE.length==2 || (AD_CODE.length==4 && !AD_CODE.endWith('00'))){
            AD_CODE = AD_CODE + '00';
        }
    }
    var AG_CODE='${sessionScope.AGCODE}';
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态，指未送审...
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var userCode='${sessionScope.USERCODE}';
    var flag = true;
    /**
     * 通用函数：获取url中的参数
     */
    /* function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    } */
    
    var dqhk_json_common = {
        100407:{
            1: {//付款录入岗
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '录入',
                            name: 'input',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                                var tree_selected = tree_area.getSelection();
                                if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                                    Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                                    return false;
                                }
                                button_name = btn.name;
                                button_text = btn.text;
                                window_select.show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                flag = false;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                modify(records,btn);
                            }
                        },
                        {
                            xtype: 'button',
                            name: 'btn_delete',
                            text: '删除',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        doworkupdate(records,btn);
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
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否送审！' , function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        doworkupdate(records, btn);
                                    }
                                });
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
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否撤销送审！' , function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        doworkupdate(records, btn);
                                    }
                                });
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
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                modify(records,btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        doworkupdate(records,btn);
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
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否送审！' , function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        doworkupdate(records, btn);
                                    }
                                });

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
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
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
                    ],
                    '000': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
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
                        }
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt1_1)
                }
            },
            2: {
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '确认',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
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
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
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
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();

                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销确认',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否撤销审核！', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        doworkupdate(records,btn);
                                    }
                                });
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
                    WF_STATUS: DebtEleStore(json_debt_zt11)
                }
            }
        }
    };
    
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        if (dqhk_json_common[wf_id][node_code].callBack) {
            dqhk_json_common[wf_id][node_code].callBack();
        }
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
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: dqhk_json_common[wf_id][node_code].items[WF_STATUS]
                }
            ],
            items: [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
        });
    }
    /**
     * 初始化页面主要内容区域
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
//        reloadGrid();
    }

    /**
     * 初始化主界面主表格
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
                dataIndex:"WZHKD_ID",
                type:"string",
                width:130,
                text:"主单id",
                hidden:true
            },
            {
                dataIndex: "WZXY_CODE",
                type: "string",
                width: 130,
                text: "外债编码"
            },
            {
                dataIndex: "WZXY_NAME",
                type: "string",
                width: 240,
                text: "外债名称"
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                width: 240,
                text: "单位名称"
            },
            {
                dataIndex: "HK_DATE",
                width: 130,
                type: "string",
                text: "还款日期"
            },
            {
                dataIndex: "PAY_BJ_AMT_SUM",
                width: 200,
                type: "float",
                text: "支付金额(本金)(原币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_BJ_RMB_SUM",
                width: 200,
                type: "float",
                text: "支付金额(本金)(人民币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_LX_AMT_SUM",
                width: 200,
                type: "float",
                text: "支付金额(利息)(原币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_LX_RMB_SUM",
                width: 200,
                type: "float",
                text: "支付金额(利息)(人民币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "SUM_AMT",
                width: 200,
                type: "float",
                text: "支付原币总和",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "SUM_RMB",
                width: 200,
                type: "float",
                text: "支付人民币总和",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "REMARK",
                type: "string",
                width: 240,
                text: "备注"
            }
//            {
//                dataIndex: "FKTZ_HL_RATE",
//                type: "float",
//                text: "汇率",
//                width: 150,
//                renderer: function (value) {
//                   return Ext.util.Format.number(value, '0,000.000000');
//                }
//            }
        ];
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
                userCode:userCode,
                AD_CODE:AD_CODE,
                AG_CODE:AG_CODE
            },
            dataUrl: 'getDqhkMain.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: dqhk_json_common[wf_id][node_code].store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    labelAlign: 'right',
                    editable: false, //禁用编辑
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(dqhk_json_common[wf_id][node_code].items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
//            features: [{
//                ftype: 'summary'
//            }],
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['WZHKD_ID'] = record.get('WZHKD_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化主界面明细表格
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
                dataIndex:"FKTZ_DTL_ID",
                type:"string",
                width:200,
                text: "明细id",
                hidden:true
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                width: 200,
                text: "子项目名称",
                renderer: function (data, cell, record) {
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                dataIndex: "ZWDW",
                type: "string",
                width: 200,
                text: "债务单位"
            },
            {
                dataIndex: "ZXDW",
                type: "string",
                width: 200,
                text: "项目执行单位"
            },
            {
                dataIndex: "WZXY_AMT",
                type: "float",
                text: "协议金额（原币）",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
//            {
//                dataIndex: "ZWYE_AMT",
//                type: "float",
//                text: "截止到期日债务余额",
//                width: 180,
//                summaryType: 'sum',
//                summaryRenderer: function (value) {
//                    return Ext.util.Format.number(value, '0,000.00');
//                }
//            },
            {
                header: '支付本金', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_BJ_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                header: '支付利息', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_LX_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                dataIndex: "PAY_ORI_SUM",
                type: "float",
                text: "原币合计",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_RMB_SUM",
                type: "float",
                text: "折合人民币",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
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
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: 'getDqhkMx.action'
        };
        var grid = simplyGrid.create(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }

    /**
     * 创建到期还款明细选择弹出窗口
     */
    var window_select = {
        window: null,
        show: function (params) {
            this.window = initQxWindow_select(params);
            this.window.show();
        }
    };

    /**
     * 初始化到期还款弹出窗口
     */
    function initQxWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '付款明细选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'windowQx_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initQxWindow_select_grid(params)],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length < 1) {
                            Ext.MessageBox.alert('提示', '请选择数据后再进行操作');
                            return;
                        }
                        //判断选择的外债是否为同一外债
                        var isWz = true;
                        var wzxy_id = records[0].data.WZXY_ID;
                        for(var i =0;i<records.length;i++ ){
                            if(records[i].data.WZXY_ID!=wzxy_id){
                                isWz = false;
                                break;
                            }
                        }
                        if(!isWz){
                            Ext.MessageBox.alert('提示', '请选择同一外债协议数据后再进行操作！');
                            return;
                        }
                        window_input.wz_code = "";
                        window_input.show();

                        //将明细金额相加汇总放到form表单中
                        var PAY_BJ_AMT_SUM = 0;
                        var PAY_BJ_RMB_SUM = 0;
                        var PAY_LX_AMT_SUM = 0;
                        var PAY_LX_RMB_SUM = 0;
                        var SUM_AMT = 0;
                        var SUM_RMB = 0;
                        for(var j =0;j<records.length;j++ ){
                            PAY_BJ_AMT_SUM = PAY_BJ_AMT_SUM+records[j].data.PAY_BJ_AMT;
                            PAY_BJ_RMB_SUM = PAY_BJ_RMB_SUM+records[j].data.PAY_BJ_RMB;
                            PAY_LX_AMT_SUM = PAY_LX_AMT_SUM+records[j].data.PAY_LX_AMT;
                            PAY_LX_RMB_SUM = PAY_LX_RMB_SUM+records[j].data.PAY_LX_RMB;
                            SUM_AMT = SUM_AMT+records[j].data.PAY_ORI_SUM;
                            SUM_RMB = SUM_RMB+records[j].data.PAY_RMB_SUM;
                        }
                        var sumMsg = {};
                        sumMsg.PAY_BJ_AMT_SUM = PAY_BJ_AMT_SUM;
                        sumMsg.PAY_BJ_RMB_SUM = PAY_BJ_RMB_SUM;
                        sumMsg.PAY_LX_AMT_SUM = PAY_LX_AMT_SUM;
                        sumMsg.PAY_LX_RMB_SUM = PAY_LX_RMB_SUM;
                        sumMsg.SUM_AMT = SUM_AMT;
                        sumMsg.SUM_RMB = SUM_RMB;
                        window_input.window.down('form').getForm().setValues(sumMsg);
                        var store = DSYGrid.getGrid('dqhk_grid2').getStore();
                        store.setRecords(records);
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
     * 初始化到期还款弹出框表格
     */
    function initQxWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "FKTZ_DTL_ID",
                "type": "string",
                "text": "付款通知明细id",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "WZXY_ID",
                "type": "string",
                "text": "外债协议id",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "XM_ID",
                "type": "string",
                "text": "项目id",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AD_CODE",
                "type": "string",
                "text": "区划编码",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AG_ID",
                "type": "string",
                "text": "单位id",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AG_CODE",
                "type": "string",
                "text": "单位编码",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AG_NAME",
                "type": "string",
                "text": "单位名称",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "WZXY_NAME",
                "type": "string",
                "text": "外债名称",
                "fontSize": "15px",
                "width": 150
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                width: 200,
                text: "子项目名称",
                renderer: function (data, cell, record) {
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                dataIndex: "ZWDW",
                type: "string",
                width: 200,
                text: "债务单位"
            },
            {
                dataIndex: "ZXDW",
                type: "string",
                width: 200,
                text: "项目执行单位"
            },
            {
                dataIndex: "START_DATE",
                type: "string",
                width: 150,
                text: "开始日期"
            },
            {
                dataIndex: "END_DATE",
                type: "string",
                width: 150,
                text: "结束日期"
            },
            {
                dataIndex: "WZXY_AMT",
                type: "float",
                text: "协议金额（原币）",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                header: '支付本金', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_BJ_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                header: '支付利息', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_LX_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                dataIndex: "PAY_ORI_SUM",
                type: "float",
                text: "原币合计",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_RMB_SUM",
                type: "float",
                text: "折合人民币",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HL_RATE",
                type: "float",
                text: "汇率",
                width: 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'grid_select2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
//            selModel: {
//                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
//            },
            checkBox: true,
            border: false,
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params:{
                AD_CODE:AD_CODE,
                AG_CODE:AG_CODE,
                mhcx:null
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
            tbarHeight: 50,
            dataUrl: 'getHktzInfo.action'
        });
    }

    //创建到期还款填报弹出窗口
    var window_input = {
        window: null,
        wz_code: null,
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
    };
    /**
     * 初始化到期还款弹出窗口
     */
    function initWindow_input() {
        return Ext.create('Ext.window.Window', {
            title: '到期还款通知单', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input2', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: initEditor(),
            buttons: [
                {
                    text: '保存',
                    handler: function (btn){
                        var form = btn.up('window').down('form');
                        if (!form.isValid()) {
                            return;
                        }
                        var form_data=form.getValues();
                        //获取grid
                        var gridStore=Ext.ComponentQuery.query('grid[itemId="dqhk_grid2"]')[0];
                        var store_data=new Array();
                        var grid_store=gridStore.getStore();
                        for(var i=0;i<grid_store.getCount();i++){
                            var record=grid_store.getAt(i);
                            var data  =record.data;
                            store_data.push(data);
                        }
                        btn.setDisabled(true);
                        Ext.Ajax.request({
                            method: 'POST',
                            url: "/savedqhk.action",
                            params: {
                                wf_id:wf_id,
                                AD_CODE:AD_CODE,
                                USERCODE:userCode,
                                node_code:node_code,
                                button_name:button_name,
                                button_text:button_text,
                                formList:Ext.util.JSON.encode(form_data),
                                detailList:Ext.util.JSON.encode(store_data)
                            },
                            async: false,
                            success: function (response) {
                                var result=Ext.util.JSON.decode(response.responseText);
                                if(result.success){
                                    Ext.toast({
                                        html: "保存成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    btn.up('window').close();
                                    reloadGrid();
                                }else{
                                    Ext.toast({
                                        html: "保存失败！"+result.message,
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    btn.setDisabled(false);
                                    return false;
                                }
                            }
                        });
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').destroy();
                    }
                }
            ]
        });
    }


    function initEditor() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'dqhk_edit_form',
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
                        labelWidth: 130//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            fieldLabel: '主单id',
                            name: "WZHKD_ID",
                            width: 100,
                            editable: true,
                            hidden:true
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '原币总金额',
                            name: "SUM_AMT",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付本金（原币）',
                            name: "PAY_BJ_AMT_SUM",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付利息（原币）',
                            name: "PAY_LX_AMT_SUM",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '人民币总金额',
                            name: "SUM_RMB",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付本金（人民币）',
                            name: "PAY_BJ_RMB_SUM",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付利息（人民币）',
                            name: "PAY_LX_RMB_SUM",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:true,
                            fieldStyle: 'background:#E6E6E6'
                        },

                        {
                            fieldLabel: '还款日期',
                            xtype: 'datefield',
                            name: 'HK_DATE',
                            width: 100,
                            editable: false,
                            allowBlank: false,
                            format: 'Y-m-d',
                            readOnly:false
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '备注',
                            name: "REMARK",
                            editable: true,
                            columnWidth: 0.663
                        }

                    ]
                },
                initWindow_input_contentForm_grid()
            ]
        });
    }



    /**
     * 初始化到期还款表单中明细信息表格
     */
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "FKTZ_DTL_ID",
                type: "string",
                width: 200,
                hidden:true,
                text: "付款通知明细id"
            },
            {
                dataIndex: "WZXY_ID",
                type: "string",
                width: 200,
                hidden:true,
                text: "协议id"
            },
            {
                dataIndex: "XM_ID",
                type: "string",
                width: 200,
                hidden:true,
                text: "项目id"
            },
            {
                dataIndex: "AD_CODE",
                type: "string",
                width: 200,
                hidden:true,
                text: "区划编码"
            },
            {
                dataIndex: "AG_ID",
                type: "string",
                width: 200,
                hidden:true,
                text: "单位id"
            },
            {
                dataIndex: "AG_CODE",
                type: "string",
                width: 200,
                hidden:true,
                text: "单位code"
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                width: 200,
                hidden:true,
                text: "单位名称"
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                width: 200,
                text: "子项目名称"
            },
            {
                dataIndex: "ZWDW",
                type: "string",
                width: 200,
                text: "债务单位"
            },
            {
                dataIndex: "ZXDW",
                type: "string",
                width: 200,
                text: "项目执行单位"
            },
            {
                dataIndex: "WZXY_AMT",
                type: "float",
                text: "协议金额（原币）",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                header: '支付本金', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_BJ_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                header: '支付利息', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_LX_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    editable: false,//禁用编辑
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                dataIndex: "PAY_ORI_SUM",
                type: "float",
                text: "原币合计",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PAY_RMB_SUM",
                type: "float",
                text: "折合人民币",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HL_RATE",
                type: "float",
                text: "汇率",
                width: 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'dqhk_grid2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            params: {
            },
            dataUrl: 'getDqhkMx.action',
            border: true,
            flex: 1,
            height: '100%',
            width: '100%',
            viewConfig: {
                stripeRows: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'dqhk_grid_plugin_cell2',
                    clicksToMoveEditor: 1
                }
            ],
            pageConfig: {
                enablePage: false
            }

        });
        return grid;
    }

    function modify(records,btn){
        var record = records[0].getData();
        window_input.show();
        window_input.window.down('form').getForm().setValues(record);

        //获取明细grid
        DSYGrid.getGrid('dqhk_grid2').getStore().removeAll();
        DSYGrid.getGrid('dqhk_grid2').getStore().getProxy().extraParams['WZHKD_ID'] = record.WZHKD_ID;
        DSYGrid.getGrid('dqhk_grid2').getStore().loadPage(1);
    }

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.getProxy().extraParams['AD_CODE'] = AD_CODE;
        store.getProxy().extraParams['AG_CODE'] = AG_CODE;

        //刷新
        store.loadPage(1);
        //刷新下方表格,置为空
        if (DSYGrid.getGrid('contentGrid_detail')) {
            var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
            store_details.removeAll();
        }
    }

    /**
     * 工作流变更
     */
    function doworkupdate(records,btn) {
        var ids=new Array();
        for(var k=0;k<records.length;k++){
            var zd_id=records[k].get("WZHKD_ID");
            ids.push(zd_id);
        }

        $.post("dqhkDowork.action",{
            ids: Ext.util.JSON.encode(ids),
            node_code:node_code,
            wf_id:wf_id,
            audit_info:"",
            button_name:button_name,
            button_text:button_text
        }, function (data_response) {
            data_response = $.parseJSON(data_response);
            if (data_response.success) {
                Ext.toast({
                    html: button_text+"成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                reloadGrid();
            } else {
                Ext.toast({
                    html: button_text+"失败！" + data_response.message,
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
    /*查看操作记录*/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return;
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
            return;
        } else {
            var XX_ID = records[0].get("WZHKD_ID");
            fuc_getWorkFlowLog(XX_ID);
        }
    }
</script>

</body>
</html>
