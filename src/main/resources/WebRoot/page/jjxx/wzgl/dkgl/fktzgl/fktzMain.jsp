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
    <title>付款通知主界面</title>
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
    var fktz_type="${fns:getParamValue('fktz_type')}"; //当前付款类型
    if(fktz_type==null||fktz_type==undefined||fktz_type==""){
        fktz_type="sj";
    }
    var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id，1：录入岗；2：审核岗
    var button_name = '';//当前操作按钮名称
    var button_text = '';
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态，指未送审...
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var userCode= '${sessionScope.USERCODE}';
    var flag = true;
    var EndDateStore;
    Ext.define('endDateModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'name',mapping:'HKJH_DATE'}
        ]
    });
    /**
     * 获取各协议还款计划日期集合
     */
    function getEndDateStore(filterParam){
        var EndDateStore = Ext.create('Ext.data.Store', {
            model: 'endDateModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: "/getEndDate.action",
                reader: {
                    type: 'json'
                },
                extraParams:filterParam
            },
            autoLoad: true
        });
        return EndDateStore;
    }
    /**
     * 通用函数：获取url中的参数
     */
   /*  function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    } */
    
    var fktz_json_common = {
        100406:{
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
                            name: 'btn_del',
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
                            name: 'btn_del',
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
                            text: '审核',
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
                                            doworkupdate(records,btn,text);
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
                                            doworkupdate(records,btn,text);
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
                            text: '撤销审核',
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
                        {
                            xtype: 'button',
                            text: '导出',
                            name: 'up',
                            icon: '/image/sysbutton/export.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                } else if (records.length > 1) {
                                    Ext.MessageBox.alert('提示', '不能同时导出多条记录！');
                                    return;
                                }else{
                                    var FKTZ_IDS = records[0].get("FKTZ_ID");
                                    DSYGrid.exportExcelClick('contentGrid_detail', {
                                        exportExcel: true,
                                        url: 'getFktzDetailGrid_excel.action',
                                        param: {
                                            FKTZ_IDS: FKTZ_IDS
                                        }
                                    });
                                }
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_sh)
                }
            }
        }
    };

    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        if (fktz_json_common[wf_id][node_code].callBack) {
            fktz_json_common[wf_id][node_code].callBack();
        }
    });
    
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: fktz_json_common[wf_id][node_code].items[WF_STATUS],
                }
            ],
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
        reloadGrid();
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
                dataIndex:"WZXY_ID",
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
                dataIndex: "WZXY_AMT",
                width: 150,
                type: "float",
                text: "协议金额（原币）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "DXM_NAME",
                width: 240,
                type: "string",
                text: "项目名称"
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
                dataIndex: "START_DATE",
                width: 130,
                type: "string",
                text: "期间开始日期"
            },
            {
                dataIndex: "END_DATE",
                width: 130,
                type: "string",
                text: "期间结束日期"
            },
            {
                dataIndex: "PAY_BJ_AMT",
                width: 200,
                type: "float",
                text: "支付金额(本金)(原币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_BJ_RMB",
                width: 200,
                type: "float",
                text: "支付金额(本金)(人民币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_LX_AMT",
                width: 200,
                type: "float",
                text: "支付金额(利息)(原币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_LX_RMB",
                width: 200,
                type: "float",
                text: "支付金额(利息)(人民币)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_CNF",
                width: 200,
                type: "float",
                text: "承诺费",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "FKTZ_HL_RATE",
                type: "float",
                text: "汇率",
                width: 150,
                renderer: function (value) {
                   return Ext.util.Format.number(value, '0,000.000000');
                }
            }
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
                node_code: node_code
            },
            dataUrl: 'getFktzMainGrid.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: fktz_json_common[wf_id][node_code].store['WF_STATUS'],
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
                            toolbar.add(fktz_json_common[wf_id][node_code].items[WF_STATUS]);
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
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['FKTZ_ID'] = record.get('FKTZ_ID');
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
                dataIndex: "XM_ID",
                type: "string",
                width: 200,
                text: "项目id",
                hidden:true
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                width: 200,
                text: "子项目名称",
                renderer: function (data, cell, record) {
                    if(record.get('XM_ID')!=null && record.get('XM_ID')!=''){
                        var url='/page/debt/common/xmyhs.jsp';
                        var paramNames=new Array();
                        paramNames[0]="XM_ID";
                        paramNames[1]="IS_RZXM";
                        var paramValues=new Array();
                        paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                        paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                        var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                        return result;
                    }else{
                        return data;
                    }
                }
            },
            {
                dataIndex: "ZWDW",
                type: "string",
                width: 200,
                text: "债务单位"
            },
            {
                dataIndex: "ZXDW_NAME",
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
                    return Ext.util.Format.number(value /10000, '0,000.000000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "ZWYE_AMT",
                type: "float",
                text: "截止到期日债务余额",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
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
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
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
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.000000');
                    }
                }]
            },
            {
                dataIndex: "PAY_CNF",
                type: "float",
                text: "承诺费",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_ORI_SUM",
                type: "float",
                text: "原币合计",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_RMB_SUM",
                type: "float",
                text: "折合人民币",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.000000');
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
            dataUrl: 'getFktzDetailGrid.action'
        };
        var grid = simplyGrid.create(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }

    /**
     * 创建外债信息选择弹出窗口
     */
    var window_select = {
        window: null,
        show: function (params) {
            this.window = fktz_type=='sj'? initWindow_select(params):initQxWindow_select(params);
            this.window.show();
        }
    };

    /**
     * 初始化外债选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '外债选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_grid(params)],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                            return;
                        }
                        window_input.wz_code = "";
                        var record = records[0].getData();
                        EndDateStore = getEndDateStore({"WZXY_ID":record.WZXY_ID});
                        window_input.show();
                        window_input.window.down('form').getForm().setValues(record);
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
     * 初始化外债选择弹出框表格
     */
    function initWindow_select_grid(params) {
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
                "dataIndex": "SJXM_ID",
                "type": "string",
                "text": "上级项目id",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AD_NAME",
                "type": "string",
                "text": "地区名称",
                "fontSize": "15px",
                "width": 120
            },
            {
                "dataIndex": "WZXY_NAME",
                "type": "string",
                "text": "外债名称",
                "fontSize": "15px",
                "width": 150
            },

            {
                "dataIndex": "DXM_NAME",
                "type": "string",
                "text": "项目名称",
                "fontSize": "15px",
                "width": 120
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
                "dataIndex": "WZXY_AMT",
                "type": "float",
                "text": "协议金额（原币）",
                "fontSize": "15px",
                "width": 150,
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "WZXY_AMT_RMB",
                "type": "float",
                "text": "协议金额（人民币）",
                "fontSize": "15px",
                "width": 180,
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex":"ZJYT_NAME",
                "type":"string",
                "width":150,
                "text":"资金用途"
            },
            {
                "dataIndex": "WZQX_ID",
                "width": 130,
                "type": "string",
                "text": "期限（月）"
            },
            {
                "dataIndex": "HL_RATE",
                "width": 130,
                "type": "string",
                "text": "汇率"
            },
            {
                "dataIndex":"ZQFL_NAME",
                "width":130,
                "type":"string",
                "text":"债权类型"
            },
            {
                "dataIndex": "ZWLX_NAME",
                "width": 130,
                "type": "string",
                "text": "债务类型"
            },
            {
                "dataIndex": "ZQR_NAME",
                "width": 130,
                "type": "string",
                "text": "债权人"
            },
            {
                "dataIndex": "ZQR_FULLNAME",
                "width": 130,
                "type": "string",
                "text": "债权人全称"
            },
            {
                "dataIndex":"WB_NAME",
                "type":"string",
                "text":"币种",
                "fontSize": "15px",
                "width": 130
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'grid_select2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            checkBox: true,
            border: false,
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params:{
                fktz_type:fktz_type,
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
            dataUrl: 'getWzInfo.action'
        });
    }

    /**
     * 初始化外债选择弹出窗口
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
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                            return;
                        }
                        window_input.wz_code = "";
                        var record = records[0].getData();
                        window_input.show();
                        window_input.window.down('form').getForm().setValues(record);
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
     * 初始化外债选择弹出框表格
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
                "dataIndex": "SJXM_ID",
                "type": "string",
                "text": "上级项目id",
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
                dataIndex: "DXM_NAME",
                type: "string",
                width: 200,
                text: "子项目名称"
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
                dataIndex: "AD_NAME",
                type: "string",
                width: 200,
                text: "债务单位"
            },
            {
                dataIndex: "ZXDW_NAME",
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
                dataIndex: "ZWYE_AMT",
                type: "float",
                text: "截止到期日债务余额",
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
                dataIndex: "PAY_CNF",
                type: "float",
                text: "承诺费",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
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
                dataIndex: "FKTZ_HL_RATE",
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
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            checkBox: true,
            border: false,
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params:{
                fktz_type:fktz_type,
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
            dataUrl: 'getWzInfo.action'
        });
    }

    //创建付款信息填报弹出窗口
    var window_input = {
        window: null,
        wz_code: null,
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
    };
    /**
     * 初始化付款弹出窗口
     */
    function initWindow_input() {
        return Ext.create('Ext.window.Window', {
            title: '付款通知单', // 窗口标题
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
                    xtype: 'button',
                    text: '生成',
                    width: 60,
                    handler: function (self) {
                        var form = self.up('window').down('form');
                        if (form.isValid()) {
                            var formData = form.getForm().getValues();
//                            if(formData.SQBF_AMT<=0){
//                                Ext.MessageBox.alert('提示', '请输入申请提款金额！');
//                                return;
//                            }
                            flag = true;
                            DSYGrid.getGrid('fktz_grid2').getStore().removeAll();
                            DSYGrid.getGrid('fktz_grid2').getStore().getProxy().extraParams['fktzParam'] = Ext.util.JSON.encode(formData);
                            DSYGrid.getGrid('fktz_grid2').getStore().loadPage(1);

                        }
                    }
                },
                {
                    text: '保存',
                    handler: function (btn){
                        var form = btn.up('window').down('form');
                        if (!form.isValid()) {
                            return;
                        }
                        var form_data=form.getValues();
                        //获取grid
                        var gridStore=Ext.ComponentQuery.query('grid[itemId="fktz_grid2"]')[0];
                        var store_data=new Array();
                        var grid_store=gridStore.getStore();
                        for(var i=0;i<grid_store.getCount();i++){
                            var record=grid_store.getAt(i);
                            var var$PAY_BJ_AMT=record.get("PAY_BJ_AMT");
                            var var$ZWYE_AMT=record.get("ZWYE_AMT");
                            if(var$ZWYE_AMT<var$PAY_BJ_AMT){
                                Ext.toast({
                                    html:  "支付本金高于债务余额，请核实信息！" ,
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                            var data  =record.data;
                            store_data.push(data);
                        }
                        if(store_data.length<1){
                            Ext.MessageBox.alert('提示', '请生成付款通知明细！');
                            return;
                        }
                        var sum$PAY_BJ_AMT = grid_store.sum("PAY_BJ_AMT");
                        var sum$PAY_BJ_RMB = grid_store.sum("PAY_BJ_RMB");
                        var sum$PAY_LX_AMT = grid_store.sum("PAY_LX_AMT");
                        var sum$PAY_LX_RMB = grid_store.sum("PAY_LX_RMB");
                        var sum$PAY_CNF = grid_store.sum("PAY_CNF");
                        var PAY_BJ_AMT_SUM = form_data.PAY_BJ_AMT;
                        var PAY_LX_AMT_SUM = form_data.PAY_LX_AMT;
                        var PAY_BJ_RMB_SUM = form_data.PAY_BJ_RMB;
                        var PAY_LX_RMB_SUM = form_data.PAY_LX_RMB;
                        var PAY_CNF_SUM = form_data.PAY_CNF;
                        if(Math.abs((PAY_BJ_AMT_SUM-sum$PAY_BJ_AMT))>0.01){
                            Ext.MessageBox.alert('提示', '明细原币支付本金总和不等于总原币支付本金！');
                            return;
                        }
                        if(Math.abs((PAY_LX_AMT_SUM-sum$PAY_LX_AMT))>0.01){
                            Ext.MessageBox.alert('提示', '明细原币支付利息总和不等于总原币支付利息！');
                            return;
                        }
                        if(Math.abs((PAY_BJ_RMB_SUM-sum$PAY_BJ_RMB))>0.01){
                            Ext.MessageBox.alert('提示', '明细人民币支付本金总和不等于总人民币支付本金！');
                            return;
                        }
                        if(Math.abs((PAY_LX_RMB_SUM-sum$PAY_LX_RMB))>0.01){
                            Ext.MessageBox.alert('提示', '明细人民币支付利息总和不等于总人民币支付利息！');
                            return;
                        }
                        if(Math.abs((PAY_CNF_SUM-sum$PAY_CNF))>0.01){
                            Ext.MessageBox.alert('提示', '明细承诺费总和不等于总承诺费！');
                            return;
                        }
                        btn.setDisabled(true);
                        Ext.Ajax.request({
                            method: 'POST',
                            url: "/saveFktz.action",
                            params: {
                                wf_id:wf_id,
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
            itemId: 'fktz_edit_form',
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
                            fieldLabel: '外债协议ID',
                            disabled: false,
                            name: "WZXY_ID",
                            editable: false,//禁用编辑
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '上级项目id',
                            disabled: false,
                            name: "SJXM_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '付款通知主单id',
                            disabled: false,
                            name: "FKTZ_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '付款通知明细id',
                            disabled: false,
                            name: "FKTZ_DTL_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '外债名称',
                            disabled: false,
                            name: "WZXY_NAME",
                            editable: false,
                            readOnly: true,
                            labelWidth: 78,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '项目名称',
                            disabled: false,
                            name: "DXM_NAME",
                            editable: false,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '协议金额（原币）',
                            name: "WZXY_AMT",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
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
                        labelWidth: 130//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            fieldLabel: '付款日期',
                            layout: 'hbox',
                            labelWidth: 78,
                            items: [
                                {
                                    xtype: 'datefield',
                                    name: 'START_DATE',
                                    width: document.body.clientWidth * 0.095,
                                    editable: false,
                                    allowBlank: false,
                                    format: 'Y-m-d',
                                    readOnly:fktz_type=='sj' ? false:true,
                                    fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6',
                                    listeners:{
                                        'change': function (self, newValue, oldValue) {
                                            if(fktz_type!='sj'){
                                                return;
                                            }
                                            var form = self.up('form').getForm();
                                            var END_DATE = form.findField('END_DATE').value;
                                            if(END_DATE==null || END_DATE == ""||newValue==null || newValue == ""){
                                                return;
                                            }
                                            newValue = format(newValue, 'yyyy-MM-dd');
                                            if(newValue>END_DATE){
                                                Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                                form.findField("START_DATE").setValue("");
                                                return;
                                            }
                                        }
                                    }
                                },
                                {
                                    xtype: 'label',
                                    text: '至',
                                    margin: '3 6 3 6'
                                },
                                {
                                    xtype: 'combobox',
                                    name: 'END_DATE',
                                    width: document.body.clientWidth * 0.095,
                                    displayField: 'name',
                                    valueField: 'name',
                                    editable: false,
                                    allowBlank: false,
                                    readOnly:fktz_type=='sj' ? false:true,
                                    fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6',
                                    store:EndDateStore,
                                    listeners:{
                                        'change': function (self, newValue, oldValue) {
                                            if(fktz_type!='sj'){
                                                return;
                                            }
                                            var form = self.up('form').getForm();
                                            var START_DATE = form.findField('START_DATE').value;
                                            if(START_DATE==null || START_DATE == ""||newValue==null || newValue == ""){
                                                return;
                                            }
                                            START_DATE = format(START_DATE, 'yyyy-MM-dd');
                                            if(newValue<START_DATE){
                                                Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                                form.findField("END_DATE").setValue("");
                                                return;
                                            }
                                        }
                                    }
                                }
                            ]
                        },{
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付本金(原币)',
                            name: "PAY_BJ_AMT",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            minValue: 0,
                            allowBlank: false,
                            readOnly:fktz_type=='sj' ? false:true,
                            fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6',
                            listeners:{
                                'change': function (self, newValue, oldValue) {
                                    if(fktz_type!='sj'){
                                        return;
                                    }
                                    var form = self.up('form').getForm();
                                    var WZXY_AMT = form.findField('WZXY_AMT').value;
                                    if(WZXY_AMT==null || WZXY_AMT == ""){
                                        return;
                                    }
                                    if(newValue>WZXY_AMT){
                                        Ext.MessageBox.alert('提示', '支付本金不能大于协议金额！');
                                        form.findField("PAY_BJ_AMT").setValue("");
                                        return;
                                    }
                                    var PAY_BJ_RMB = form.findField('PAY_BJ_RMB').value;
                                    if(newValue!=null && newValue != "" && newValue>0 && PAY_BJ_RMB!=null && PAY_BJ_RMB != "" && PAY_BJ_RMB>0){
                                        var hl = Math.floor(PAY_BJ_RMB/newValue* 1000000) / 1000000;
                                        form.findField("FKTZ_HL_RATE").setValue(hl);
                                    }else {
                                        form.findField("FKTZ_HL_RATE").setValue("");
                                    }
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付本金(人民币)',
                            name: "PAY_BJ_RMB",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            minValue: 0,
                            allowBlank: false,
                            readOnly:fktz_type=='sj' ? false:true,
                            fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6',
                            listeners:{
                                'change': function (self, newValue, oldValue) {
                                    if(fktz_type!='sj'){
                                        return;
                                    }
                                    var form = self.up('form').getForm();
                                    var PAY_BJ_AMT = form.findField('PAY_BJ_AMT').value;
                                    if(newValue!=null && newValue != "" && newValue>0 && PAY_BJ_AMT!=null && PAY_BJ_AMT != "" && PAY_BJ_AMT>0){
                                        var hl = Math.floor(newValue/PAY_BJ_AMT* 1000000) / 1000000;
                                        form.findField("FKTZ_HL_RATE").setValue(hl);
                                    }else{
                                        form.findField("FKTZ_HL_RATE").setValue("");
                                    }
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '承诺费',
                            name: "PAY_CNF",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            minValue: 0,
                            labelWidth: 78,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:fktz_type=='sj' ? false:true,
                            fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6'
                        },

                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付利息(原币)',
                            name: "PAY_LX_AMT",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            minValue: 0,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:fktz_type=='sj' ? false:true,
                            fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6',
                            listeners:{
                                'change': function (self, newValue, oldValue) {
                                    if(fktz_type!='sj'){
                                        return;
                                    }
                                    var form = self.up('form').getForm();
                                    var FKTZ_HL_RATE = form.findField('FKTZ_HL_RATE').value;
                                    if(newValue!=null && newValue != "" && newValue>0 && FKTZ_HL_RATE!=null && FKTZ_HL_RATE != "" && FKTZ_HL_RATE>0){
                                        var PAY_LX_RMB = Math.floor(newValue*FKTZ_HL_RATE* 100) / 100;
                                        form.findField("PAY_LX_RMB").setValue(PAY_LX_RMB);
                                    }else{
                                        form.findField("PAY_LX_RMB").setValue("");
                                    }
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '支付利息(人民币)',
                            name: "PAY_LX_RMB",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            minValue: 0,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            editable: true,
                            allowBlank: false,
                            readOnly:fktz_type=='sj' ? false:true,
                            fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '汇率',
                            name: "FKTZ_HL_RATE",
                            decimalPrecision:7,
                            emptyText: '0.00',
                            regex: /^\d+(\.[0-9]{1,6})?$/,
                            hideTrigger: true,
                            mouseWheelEnabled: false,
                            minValue: 0,
                            labelWidth: 78,
                            allowBlank: false,
                            readOnly:fktz_type=='sj' ? false:true,
                            fieldStyle:fktz_type=='sj' ? null: 'background:#E6E6E6'
                        }

                    ]
                },
                initWindow_input_contentForm_grid()
            ]
        });
    }



    /**
     * 初始化付款通知表单中通知单明细信息表格
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
                dataIndex: "WZXY_ID",
                type: "string",
                width: 200,
                hidden:true,
                text: "协议id"
            },
            {
                dataIndex: "SJXM_ID",
                type: "string",
                width: 200,
                hidden:true,
                text: "上级项目id"
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
                dataIndex: "ZXDW_NAME",
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
                dataIndex: "ZWYE_AMT",
                type: "float",
                text: "截止到期日债务余额",
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
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        mouseWheelEnabled: true,
                        minValue: 0
                    },
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
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        mouseWheelEnabled: true,
                        minValue: 0
                    },
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
                dataIndex: "PAY_CNF",
                type: "float",
                text: "承诺费",
                width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
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
        var grid = DSYGrid.createGrid({
            itemId: 'fktz_grid2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            params: {
                fktz_type:fktz_type,
                button_name:button_name
            },
            dataUrl: 'getFktzMx.action',
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
                    pluginId: 'fktz_grid_plugin_cell2',
                    clicksToMoveEditor: 1
                }
            ],
            pageConfig: {
                enablePage: false
            },
            listeners: {
                edit:function (editor,context) {
                    if (context.field == 'PAY_BJ_AMT') {
                        var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
                        var formData = form.getValues();
                        var HL_RATE = formData.FKTZ_HL_RATE;
                        if (HL_RATE != null && HL_RATE != undefined && HL_RATE >= 0 && context.value != null && context.value != undefined && context.value >= 0) {
                            context.record.set("PAY_BJ_RMB", HL_RATE*context.value);
                            var PAY_LX_AMT = context.record.get("PAY_LX_AMT");
                            var PAY_LX_RMB = context.record.get("PAY_LX_RMB");
                            if(PAY_LX_AMT != null && PAY_LX_AMT != undefined && PAY_LX_AMT >= 0 ){
                                context.record.set("PAY_ORI_SUM", context.value+PAY_LX_AMT);
                            }
                            if(PAY_LX_RMB != null && PAY_LX_RMB != undefined && PAY_LX_RMB >= 0 ){
                                context.record.set("PAY_RMB_SUM", (HL_RATE*context.value)+PAY_LX_RMB);
                            }
                        }
                    }
                    if (context.field == 'PAY_LX_AMT') {
                        var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
                        var formData = form.getValues();
                        var HL_RATE = formData.FKTZ_HL_RATE;
                        if (HL_RATE != null && HL_RATE != undefined && HL_RATE >= 0 && context.value != null && context.value != undefined && context.value >= 0) {
                            context.record.set("PAY_LX_RMB", HL_RATE*context.value);
                            var PAY_BJ_AMT = context.record.get("PAY_BJ_AMT");
                            var PAY_BJ_RMB = context.record.get("PAY_BJ_RMB");
                            if(PAY_BJ_AMT != null && PAY_BJ_AMT != undefined && PAY_BJ_AMT >= 0 ){
                                context.record.set("PAY_ORI_SUM", context.value+PAY_BJ_AMT);
                            }
                            if(PAY_BJ_RMB != null && PAY_BJ_RMB != undefined && PAY_BJ_RMB >= 0 ){
                                context.record.set("PAY_RMB_SUM", (HL_RATE*context.value)+PAY_BJ_RMB);
                            }
                        }
                    }
                }
            }

        });
        grid.getStore().on('load', function () {
            if(!flag){
                return;
            }
            var self = grid.getStore();
            var WZXY_AMT_SUM = self.sum("WZXY_AMT");
            var WZYE_SUM = self.sum("ZWYE_AMT");
            var form = Ext.ComponentQuery.query('form#fktz_edit_form')[0].getForm();
            var formData = form.getValues();
            var endDate = Ext.util.Format.date(formData.END_DATE, 'Y-m-d');
            var PAY_BJ_AMT_SUM = formData.PAY_BJ_AMT;
            var PAY_LX_AMT_SUM = formData.PAY_LX_AMT;
            var PAY_BJ_RMB_SUM = formData.PAY_BJ_RMB;
            var PAY_LX_RMB_SUM = formData.PAY_LX_RMB;
            var PAY_CNF_SUM = formData.PAY_CNF;
            var HL_RATE = formData.FKTZ_HL_RATE;
            //舍余平衡
            var sum$PAY_BJ_AMT = 0;
            var sum$PAY_BJ_RMB = 0;
            var sum$PAY_LX_AMT = 0;
            var sum$PAY_LX_RMB = 0;
            var sum$PAY_ORI_SUM = 0;
            var sum$PAY_RMB_SUM = 0;
            var sum$PAY_CNF = 0;
            for(var i=0;i<self.getCount();i++){
                var record=self.getAt(i);
                var jsqx = record.get("JSQX");
                //建设日期在结束日期之内：按照余额比例拆分支付本金和利息
                if(jsqx <= endDate){
                    if(record.get("ZWYE_AMT")==null || record.get("ZWYE_AMT") == '' || record.get("ZWYE_AMT")==0){
                        record.set("PAY_BJ_AMT",0);
                        record.set("PAY_BJ_RMB",0);
                        record.set("PAY_LX_AMT",0);
                        record.set("PAY_LX_RMB",0);
                        record.set("PAY_ORI_SUM",0);
                        record.set("PAY_RMB_SUM",0);
                        record.set("PAY_CNF",0);
                    }else{
                        //舍余平衡
                        if(i==self.getCount()-1){
                            var PAY_BJ_AMT =PAY_BJ_AMT_SUM-sum$PAY_BJ_AMT;
                            var PAY_LX_AMT = PAY_LX_AMT_SUM-sum$PAY_LX_AMT;
                            var PAY_BJ_RMB =PAY_BJ_RMB_SUM-sum$PAY_BJ_RMB;
                            var PAY_LX_RMB = PAY_LX_RMB_SUM-sum$PAY_LX_RMB;
                            var PAY_CNF = PAY_CNF_SUM-sum$PAY_CNF;
                            record.set("PAY_BJ_AMT",PAY_BJ_AMT);
                            record.set("PAY_BJ_RMB",PAY_BJ_RMB);
                            record.set("PAY_LX_AMT",PAY_LX_AMT);
                            record.set("PAY_LX_RMB",PAY_LX_RMB);
                            record.set("PAY_CNF",PAY_CNF);
                            record.set("PAY_ORI_SUM",PAY_BJ_AMT+PAY_LX_AMT);
                            record.set("PAY_RMB_SUM",PAY_BJ_RMB+PAY_LX_RMB);
                        }else{
                            var PAY_BJ_AMT = Math.floor((record.get("ZWYE_AMT")/WZYE_SUM*PAY_BJ_AMT_SUM) * 100) / 100;
                            var PAY_LX_AMT = Math.floor((record.get("ZWYE_AMT")/WZYE_SUM*PAY_LX_AMT_SUM) * 100) / 100;
                            var PAY_BJ_RMB = Math.floor((record.get("ZWYE_AMT")/WZYE_SUM*PAY_BJ_RMB_SUM) * 100) / 100;
                            var PAY_LX_RMB = Math.floor((record.get("ZWYE_AMT")/WZYE_SUM*PAY_LX_RMB_SUM) * 100) / 100;
                            var PAY_CNF = Math.floor((record.get("ZWYE_AMT")/WZYE_SUM*PAY_CNF_SUM) * 100) / 100;
                            record.set("PAY_BJ_AMT",PAY_BJ_AMT);
                            record.set("PAY_BJ_RMB",PAY_BJ_RMB);
                            record.set("PAY_LX_AMT",PAY_LX_AMT);
                            record.set("PAY_LX_RMB",PAY_LX_RMB);
                            record.set("PAY_CNF",PAY_CNF);
                            record.set("PAY_ORI_SUM",PAY_BJ_AMT+PAY_LX_AMT);
                            record.set("PAY_RMB_SUM",PAY_BJ_RMB+PAY_LX_RMB);
                        }
                    }
                }
                //建设日期在结束日期之外：按照协议金额比例拆分支付本金和利息
                else{
                    if(record.get("WZXY_AMT")==null || record.get("WZXY_AMT") == '' || record.get("WZXY_AMT")==0){
                        record.set("PAY_BJ_AMT",0);
                        record.set("PAY_BJ_RMB",0);
                        record.set("PAY_LX_AMT",0);
                        record.set("PAY_LX_RMB",0);
                        record.set("PAY_ORI_SUM",0);
                        record.set("PAY_RMB_SUM",0);
                        record.set("PAY_CNF",0);
                    }else{
                        //舍余平衡
                        if(i==self.getCount()-1){
                            var PAY_BJ_AMT =PAY_BJ_AMT_SUM-sum$PAY_BJ_AMT;
                            var PAY_LX_AMT = PAY_LX_AMT_SUM-sum$PAY_LX_AMT;
                            var PAY_BJ_RMB =PAY_BJ_RMB_SUM-sum$PAY_BJ_RMB;
                            var PAY_LX_RMB = PAY_LX_RMB_SUM-sum$PAY_LX_RMB;
                            var PAY_CNF = PAY_CNF_SUM-sum$PAY_CNF;
                            record.set("PAY_BJ_AMT",PAY_BJ_AMT);
                            record.set("PAY_BJ_RMB",PAY_BJ_RMB);
                            record.set("PAY_LX_AMT",PAY_LX_AMT);
                            record.set("PAY_LX_RMB",PAY_LX_RMB);
                            record.set("PAY_CNF",PAY_CNF);
                            record.set("PAY_ORI_SUM",PAY_BJ_AMT+PAY_LX_AMT);
                            record.set("PAY_RMB_SUM",PAY_LX_RMB+PAY_LX_RMB);
                        }else{
                            var PAY_BJ_AMT = Math.floor((record.get("WZXY_AMT")/WZXY_AMT_SUM*PAY_BJ_AMT_SUM) * 100) / 100;
                            var PAY_LX_AMT = Math.floor((record.get("WZXY_AMT")/WZXY_AMT_SUM*PAY_LX_AMT_SUM) * 100) / 100;
                            var PAY_BJ_RMB = Math.floor((record.get("WZXY_AMT")/WZXY_AMT_SUM*PAY_BJ_RMB_SUM) * 100) / 100;
                            var PAY_LX_RMB = Math.floor((record.get("WZXY_AMT")/WZXY_AMT_SUM*PAY_LX_RMB_SUM) * 100) / 100;
                            var PAY_CNF = Math.floor((record.get("WZXY_AMT")/WZXY_AMT_SUM*PAY_CNF_SUM) * 100) / 100;
                            record.set("PAY_BJ_AMT",PAY_BJ_AMT);
                            record.set("PAY_BJ_RMB",PAY_BJ_RMB);
                            record.set("PAY_LX_AMT",PAY_LX_AMT);
                            record.set("PAY_LX_RMB",PAY_LX_RMB);
                            record.set("PAY_CNF",PAY_CNF);
                            record.set("PAY_ORI_SUM",PAY_BJ_AMT+PAY_LX_AMT);
                            record.set("PAY_RMB_SUM",PAY_BJ_RMB+PAY_LX_RMB);
                        }
                    }
                }
                sum$PAY_BJ_AMT = sum$PAY_BJ_AMT+record.get("PAY_BJ_AMT");
                sum$PAY_BJ_RMB = sum$PAY_BJ_RMB+record.get("PAY_BJ_RMB");
                sum$PAY_LX_AMT = sum$PAY_LX_AMT+record.get("PAY_LX_AMT");
                sum$PAY_LX_RMB = sum$PAY_LX_RMB+record.get("PAY_LX_RMB");
                sum$PAY_ORI_SUM = sum$PAY_ORI_SUM+record.get("PAY_ORI_SUM");
                sum$PAY_RMB_SUM = sum$PAY_RMB_SUM+record.get("PAY_RMB_SUM");
                sum$PAY_CNF = sum$PAY_CNF+record.get("PAY_CNF");
            };
            flag = false;
        });
        return grid;
    }

    function modify(records,btn){
        var record = records[0].getData();
        EndDateStore = getEndDateStore({"WZXY_ID":record.WZXY_ID});
        window_input.show();
        window_input.window.down('form').getForm().setValues(record);

        //获取明细grid
        DSYGrid.getGrid('fktz_grid2').getStore().removeAll();
        DSYGrid.getGrid('fktz_grid2').getStore().getProxy().extraParams['FKTZ_ID'] = record.FKTZ_ID;
        DSYGrid.getGrid('fktz_grid2').getStore().loadPage(1);
    }

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
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
    function doworkupdate(records,btn,text) {
        var ids=new Array();
        for(var k=0;k<records.length;k++){
            var zd_id=records[k].get("FKTZ_ID");
            ids.push(zd_id);
        }
        var sh = "" ;
        if(text != null){
            sh = text ;
        }
        $.post("fktzDowork.action",{
            ids: Ext.util.JSON.encode(ids),
            node_code:node_code,
            wf_id:wf_id,
            audit_info:sh,
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
            var XX_ID = records[0].get("FKTZ_ID");
            fuc_getWorkFlowLog(XX_ID);
        }
    }
</script>

</body>
</html>
