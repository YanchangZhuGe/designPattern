<%--
  Created by IntelliJ IDEA.
  User: lijiahe
  Date: 2017/11/27
  Time: 10:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>发行计划</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
</head>
<body>
<script type="text/javascript">
    var fxfs=1;    //发行方式，默认为
    var userCode = '${sessionScope.USERCODE}';
    var userAG= '${sessionScope.AGCODE}';
    var userAD = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var nowDate = '${fns:getDbDateDay()}';
    var nowYear=nowDate.substr(0,4); // 当前年度
   /* var wf_id = getQueryParam("wf_id");//工作流ID
    var node_code = getQueryParam("node_code");//当前结点
    var node_type = getQueryParam("node_type");//当前状态
    var is_gzl=getQueryParam("is_gzl");//获取当前功能是否走工作流 true走，其他不走，黑龙江个性*/
    var wf_id ="${fns:getParamValue('wf_id')}";//工作流ID
    var node_code ="${fns:getParamValue('node_code')}";//当前结点
    var node_type ="${fns:getParamValue('node_type')}";//当前状态
    var is_gzl ="${fns:getParamValue('is_gzl')}";//获取当前功能是否走工作流 true走，其他不走，黑龙江个性
    var IS_BZB = '${fns:getSysParam("IS_BZB")}';// 系统参数：是否标准版
/*
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
       if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";//当前状态
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var monthStore = DebtEleStore(json_debt_yf);// 计划月份
    var jgxxStore_fxpz=DebtEleStore(json_debt_xzorzh);
    var jgxxStore_cxt = DebtEleStoreTable('DEBT_V_ZQGL_CXT');
    var jgxxStore_zqqx = DebtEleStoreDB("DEBT_ZQQX");
    var jgxxStore_fxpl= DebtEleStoreDB("DEBT_FXZQ");
    var jgxxStore_fxr=DebtEleStoreTable('debt_v_zqgl_fxjh_fxr');
    fxfs==0?DebtEleStoreDB('DEBT_CXFS'):DebtEleStoreDB('DEBT_ZBFS');
    var deleteIds = [];//Grid删除的行的主键ID数组
    $(document).ready(function () {
        if (typeof (Ext) == "undefined" || Ext == null) {
            //动态加载js
            $.ajaxSetup({
                cache: true
            });
            $.getScript('../../third/ext5.1/ext-all.js', function () {
                initMain();
            });
        } else {
            initContent();
        }
    });
    
    /*招标系统*/
	var json_debt_zbxt = [
		{"id":"01","code":"01","name":"财政部政府债券发行系统"},
		{"id":"02","code":"02","name":"财政部深圳证券交易所政府债券发行系统"},
		{"id":"03","code":"03","name":"财政部上海证券交易所政府债券发行系统"}
	]; 
    
    var Input_fxjh_windows = {
        window: null,
        config: {
            closeAction: 'destroy'
        },
        show: function () {
            if (!this.window || this.config.closeAction == 'destroy') {

                this.window = Input_fxjh_windows_fxxx();
            }
            this.window.show();
        }
    };
    //封装按钮状态
    var fxjhMain_toolbar_json = {
        lr: { //录入
            items: {
                '000':  [
                    {
                        xtype: 'button',
                        text: '查询',
                        name: 'btn_check',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reload_mainGrid();
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
                    initButton_Screen()],
                '001':  [
                    {
                        xtype: 'button',
                        text: '查询',
                        name: 'btn_check',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reload_mainGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '新增',
                        name: 'btn_insert',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            is_fix=false;
                            Input_fxjh_windows.show();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '已有发行计划',
                        name: 'sendPlan',
                        hidden: IS_BZB == '0' ? true : false,
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            initWindow_ydjh();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            is_fix=true;
                            var grid = DSYGrid.getGrid('grid');
                            var sm = grid.getSelectionModel().getSelection();
                            if (sm.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                                return;
                            }
                            var pc_id=sm[0].get('FXJH_ID');
                            var fxjh_id=sm[0].get('FXJH_ID');
                            fixfxjh(pc_id,fxjh_id);
                            reload_mainGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        name: 'btn_delete',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            //fxpc_data=new Array();
                            //fxpc_data_map=new Object();
                            var grid = DSYGrid.getGrid('grid');
                            // var store = grid.getStore();
                            var sm = grid.getSelectionModel().getSelection();
                            if (sm.length < 1) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                                return;
                            }

                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                //判断提示的选择，为no不删除，为yes删除数据
                                if (btn_confirm == 'yes') {
                                    var ZFX_ID=new Array();
                                    var FXJH_ID=new Array();
                                    for(var i=0;i<sm.length;i++){
                                        var ZFX_ID_temp=sm[i].get('FXJH_ID');
                                        var FXJH_ID_temp=sm[i].get('FXJH_ID');
                                        ZFX_ID.push(ZFX_ID_temp);
                                        FXJH_ID.push(FXJH_ID_temp);
                                    }
                                    deletefxjh(ZFX_ID,FXJH_ID);
                                    reload_mainGrid();
                                }
                            });
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        hidden:is_gzl=='true'?false:true,
                        handler: function (btn) {
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        hidden:is_gzl=='true'?false:true,
                        handler: function (btn) {
                            dooperation();
                        }
                    },
                    {
                        fieldLabel: '模糊查询',
                        xtype: 'textfield',
                        dock: 'top',
                        name:'mhcx',
                        labelWidth: 70,
                        width: 350,
                        labelAlign: 'right',
                        emptyText: '请输入批次名称...',
                        enableKeyEvents: true,
                        hidden:is_gzl=='true'?true:false,
                        listeners: {
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    reload_mainGrid();
                                }
                            }
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()],
                '002':  [
                    {
                        xtype: 'button',
                        text: '查询',
                        name: 'btn_check',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reload_mainGrid();
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
                    initButton_Screen()],
                '004':  [
                    {
                        xtype: 'button',
                        text: '查询',
                        name: 'btn_check',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reload_mainGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            is_fix=true;
                            var grid = DSYGrid.getGrid('grid');
                            var sm = grid.getSelectionModel().getSelection();
                            if (sm.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                                return;
                            }
                            var pc_id=sm[0].get('FXJH_ID');
                            var fxjh_id=sm[0].get('FXJH_ID');
                            fixfxjh(pc_id,fxjh_id);
                            reload_mainGrid();
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
                        handler: function (btn) {
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()],
                '008':  [
                    {
                        xtype: 'button',
                        text: '查询',
                        name: 'btn_check',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reload_mainGrid();
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
                    initButton_Screen()]
            }
        },
        sh: {//审核
            items: {
                '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            reload_mainGrid();
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
                        handler: function (btn) {
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
                        handler: function () {
                            reload_mainGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销审核',
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
            '004': [//被退回
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reload_mainGrid();
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
            '008': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reload_mainGrid();
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
            }
        }
    };
    var fxpc_id;
    var ZFX_ID;
    //初始化主页面
    function initContent() {
        var grid_main=DSYGrid.createGrid({
            itemId: 'grid',
            border: false,
            flex: 1,
            headerConfig: {
                headerJson: [
                    {
                        xtype: 'rownumberer', width: 40, summaryType: 'count',
                        summaryRenderer: function () {
                            return '合计';
                        }
                    },
                    {
                        "dataIndex": "FXJH_ID",
                        "type": "string",
                        "text": '主单id',
                        "fontSize": "15px",
                        "width": 150,
                        hidden: true
                    },
                    {
                        "dataIndex": "FXPC_ID",
                        "type": "string",
                        "text": "批次id",
                        "fontSize": "15px",
                        "width": 150,
                        hidden: true
                    },
                    {
                        "dataIndex": "FXPC_NAME",
                        "type": "string",
                        "text": "批次",
                        "fontSize": "15px",
                        "width": 150
                    },
                    {
                        "dataIndex": "FXFS_NAME",
                        "width": 150,
                        "type": "string",
                        "text": "发行方式"
                    },
                    {
                        "dataIndex": "ZQLX_NAME",
                        "width": 150,
                        "type": "string",
                        "text": "债券类型"
                    },
                    {
                        dataIndex: "JHFX_DATE", type: "string", text: "发行日期",
                        width: 150,
                        editor: {
                            xtype: 'datefield',
                            format: 'Ymd'
                        }
                    },
                    {
                        "dataIndex": "JHFX_AMT_TOTAL",
                        "width": 150,
                        "type": "number",
                        "align": 'right',
                        "text": "计划发行总额(万元)",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10000, '0,000.00####');
                        },
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },

                    {
                        "dataIndex": "JXFS_NAME",
                        "width": 150,
                        "type": "string",
                        "text": "计息方式"
                    },
                    {
                        "dataIndex": "CXT_NAME",
                        "width": 150,
                        "type": "string",
                        "text": "承销团"
                    },
                    {
                        "dataIndex": "FX_PZWH",
                        "width": 150,
                        "type": "string",
                        "text": "批准文号"
                    },
                    {
                        dataIndex: "FENX_START_DATE", type: "string", text: "起分销日",
                        width: 150,
                        editor: {
                            xtype: 'datefield',
                            format: 'Ymd'
                        }
                    },
                    {
                        dataIndex: "FENX_END_DATE", type: "string", text: "止分销日",
                        width: 150,
                        editor: {
                            xtype: 'datefield',
                            format: 'Ymd'
                        }
                    },
                    {
                        dataIndex: "GG_DATE", type: "string", text: "公告日",
                        width: 150,
                        editor: {
                            xtype: 'datefield',
                            format: 'Ymd'
                        }
                    },
                    {
                        dataIndex: "JK_DATE", type: "string", text: "缴款日",
                        width: 150,
                        editor: {
                            xtype: 'datefield',
                            format: 'Ymd'
                        }
                    }
                ],
                columnAutoWidth: false
            },
            dataUrl: 'GetFxjhGrid.action',
            autoLoad: true,
            params: {
//                    wf_id: wf_id,
//                    node_code: node_code,
//                    userCode: userCode,
                AD_CODE: userAD,
                SET_YEAR: Ext.Date.format(new Date(), 'Y'),
                wf_id:wf_id,
                node_code:node_code,
                node_type:node_type,
                userCode:userCode,
                WF_STATUS:WF_STATUS,
                IS_GZL:is_gzl
            },
            tbar: [
                {
                    //状态
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: node_type == 'lr' ? DebtEleStore(json_debt_zt1_1) : node_code=='3'?DebtEleStore(json_debt_zt2_3):DebtEleStore(json_debt_zt2),
                    width: 110,
                    labelWidth: 30,
                    editable: false,
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    hidden:is_gzl=='true'?false:true,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(fxjhMain_toolbar_json[node_type].items[WF_STATUS]);
                            //刷新当前表格
                            DSYGrid.getGrid('grid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                            reload_mainGrid();
                        }
                    }
                },
                {
                    fieldLabel: '模糊查询',
                    xtype: 'textfield',
                    dock: 'top',
                    name:'mhcx',
                    labelWidth: 70,
                    width: 350,
                    labelAlign: 'right',
                    emptyText: '请输入批次名称...',
                    enableKeyEvents: true,
                    hidden:is_gzl=='true'?false:true,
                    listeners: {
                        'keydown': function (self, e, eOpts) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reload_mainGrid();
                            }
                        }
                    }
                }
            ],
            height: '100%',
            checkBox: true,
            pageConfig: {
                pageNum: true// 每页显示数据数
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('grid2').getStore().getProxy().extraParams['FXJH_ID'] = record.get('FXJH_ID');
                    DSYGrid.getGrid('grid2').getStore().loadPage(1);
                },
				itemdblclick: function (self, record) {
	               			is_fix=true;
                            var pc_id=record.get('FXJH_ID');
                            var fxjh_id=record.get('FXJH_ID');
                            fixfxjh(pc_id,fxjh_id);
                            
 							var f=Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0]
 							f.getForm().getFields().each(function(field) {
							//设置只读
							field.setReadOnly(true);  
						});
						Ext.ComponentQuery.query('button[itemId="addColumn"]')[0].hide();
						Ext.ComponentQuery.query('button[itemId="delColumn"]')[0].hide();
						Ext.ComponentQuery.query('button[itemId="save"]')[0].hide();
            }
            },
            features: [{
                ftype: 'summary'
            }],
            autoLoad: true

        });
        var grid_mx=DSYGrid.createGrid({
            itemId: 'grid2',
            border: false,
            flex: 1,
            headerConfig: {
                headerJson: [
                    {
                        xtype: 'rownumberer', width: 40, summaryType: 'count',
                        dataIndex:'xuni_id',
                        summaryRenderer: function () {
                            return '合计';
                        }
                    },
                    {
                        "dataIndex": "FXJH_ID",
                        "type": "string",
                        "text": "发行计划明细D",
                        "fontSize": "15px",
                        "width": 150,
                        hidden: true
                    },
                    {
                        "dataIndex": "FXJH_DTL_ID",
                        "type": "string",
                        "text": "发行计划iD",
                        "fontSize": "15px",
                        "width": 150,
                        hidden: true
                    },
                    {
                        "dataIndex": "ZQ_CODE",
                        "type": "string",
                        "text": "债券代码",
                        "fontSize": "15px",
                        "width": 150
                    },
                    {
                        "dataIndex": "ZQ_NAME",
                        "type": "string",
                        "text": "债券名称",
                        "fontSize": "15px",
                        "width": 150
                    },
                    {text: "债券简称", dataIndex: "ZQJC_NAME", width: 150, type: "string"},
                    {
                        "dataIndex": "ZQQX_ID",
                        "width": 100,
                        "type": "string",
                        "text": "债券期限",
                        renderer: function (value) {
                            var record = jgxxStore_zqqx.findRecord('code', value, false, true, true);
                            return record.get('name');
                        }
                    },
                    {
                        "dataIndex": "FXPZ",
                        "type": "string",
                        "text": "发行品种",
                        "fontSize": "15px",
                        "width": 150
                    },
                    {
                        "dataIndex": "FXF_RATE",
                        "width": 150,
                        "type": "number",
                        "align": 'right',
                        "text": is_gzl==true?"发行费率(‰)":"发行承揽费率(‰)",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10, '0,000.0000####');
                        },
                    },
                    {
                        "dataIndex": "JHFX_AMT",
                        "width": 150,
                        "type": "number",
                        "align": 'right',
                        "text": "计划发行总额(万元)",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10000, '0,000.00####');
                        },
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "起息日", dataIndex: "QX_DATE", type: "string","width": 150
                    },
                    {
                        "dataIndex": "DF_DATE",
                        "width": 150,
                        "type": "string",
                        "text": "兑付日"
                    },
                    {text: "付息频率", dataIndex: "FXPL_ID", type: "string",
                        renderer: function (value) {
                            var record = jgxxStore_fxpl.findRecord('id', value, false, true, true);
                            return record.get('name');
                        }},
                    {
                        "dataIndex": "QCZGSG_AMT",
                        "width": 170,
                        "type": "number",
                        "align": 'right',
                        "text": "全场最高申购量(万元)",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10000, '0,000.00####');
                        },
                    },
                    {
                        "dataIndex": "DBZGSG_AMT",
                        "width": 170,
                        "type": "number",
                        "align": 'right',
                        "text": "单笔最高申购量(亿元)",
                        decimalPrecision:1,
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/100000000, '0,000.00####');
                        },
                    },
                    {
                        "dataIndex": "DBZDSG_AMT",
                        "width": 170,
                        "type": "number",
                        "align": 'right',
                        "text": "单笔最低申购量(万元)",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10000, '0,000.00####');
                        },
                    }
                ],
                columnAutoWidth: false
            },
            dataUrl: 'GetFxjhMX.action',
            autoLoad: false,
            params: {
//                    wf_id: wf_id,
//                    node_code: node_code,
//                    userCode: userCode,
                AD_CODE: userAD,
                SET_YEAR: Ext.Date.format(new Date(), 'Y'),
                WF_STATUS:WF_STATUS
            },
            pageConfig: {
                pageNum: false, //设置显示每页条数
                enablePage: false
            },
            height: '100%',
            checkBox: false,
            listeners: {
            },
            features: [{
                ftype: 'summary'
            }]
        });
        return Ext.create('Ext.panel.Panel', {
            renderTo: 'main_content',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            width: '100%',
            border: false,
            items:[
                grid_main,
                grid_mx
            ],
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: is_gzl=='true'? fxjhMain_toolbar_json[node_type].items[WF_STATUS]:fxjhMain_toolbar_json['lr'].items['001']
                }
            ]
        });

    }
    function deletefxjh(ZFX_ID,FXJH_ID) {
        Ext.Ajax.request({
            type : "post",
            url : "deletefxjh.action",
            async : false,
            params:{
                ZFX_ID:Ext.util.JSON.encode(ZFX_ID),
                FXJH_ID:Ext.util.JSON.encode(FXJH_ID)
            },
            success : function(data){
                var data = Ext.util.JSON.decode(data.responseText);
                Ext.toast({
                    html: data.message?data.message:"删除成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
            },
            failure: function(form1, action) {
                Ext.toast({
                    html: "删除失败！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
            }
        });
    }



    // 已有发行计划
    function initWindow_ydjh() {
        var ydjh_window= Ext.create('Ext.window.Window', {
            title: '月度发行计划选择', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_ydjh', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
            items: [initWindow_ydjh_grid()],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid');
                        var ydjh_record = grid.getSelectionModel().getSelection();
                        if (ydjh_record.length < 1) {     //是否选择了有效的债券
                            Ext.MessageBox.alert('提示', '请至少选择一条数据后再进行操作');
                            return;
                        }
                        if(ydjh_record.length > 1){
                            var PCJH_ID = [];
                            var ZQLB_ID = [];
                            for(var i=0;i<ydjh_record.length;i++){
                                var record =ydjh_record[i].data;
                                var pcjh_id = record.PCJH_ID;
                                var zqlb_id = record.ZQLB_ID;
                                PCJH_ID.push(pcjh_id);
                                ZQLB_ID.push(zqlb_id);
                            }
                            for(var i=0;i<ydjh_record.length-1;i++){
                                if(PCJH_ID[i] != PCJH_ID[i+1]){
                                    Ext.Msg.alert('提示', '所选数据存在不同批次，请重新选择！');
                                    return false;
                                }
                                if(ZQLB_ID[i] != ZQLB_ID[i+1]){
                                    Ext.Msg.alert('提示', '所选数据存在不同债券类型，请重新选择！');
                                    return false;
                                }
                            }
                        }
                        var ids = [];
                        for (var i in ydjh_record) {
                            ids.push(ydjh_record[i].data.YDJH_ID);
                        }
                        is_fix=false;
                        Input_fxjh_windows.show();
                        var form = Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0];
                        var cxt_grid = DSYGrid.getGrid('init_cxt_grid');
                        loadYdjh(ids,form,cxt_grid);
                        btn.up('window').close();
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
        ydjh_window.show();
        ReloadYdjhChoose();
    }

    // 月度计划Grid
    function initWindow_ydjh_grid() {
        //申请填报的主单
        var toolbar_choose_ydjh = [
            {
                xtype: 'combobox',
                fieldLabel: '计划年度',
                labelWidth: 60,
                width: 200,
                name: 'debt_year',
                value: nowYear,
                enableKeyEvents: true,
                displayField: 'name',
                valueField: 'code',
                store: DebtEleStore(json_debt_year),
                listeners: {
                    'select': function (self, record) {
                    }
                }
            },
            {
                xtype: 'combobox',
                fieldLabel: '计划月份',
                labelWidth: 60,
                width: 200,
                name: 'debt_month',
                displayField: 'name',
                valueField: 'id',
                store: monthStore

            },
            {
                xtype: 'treecombobox',
                fieldLabel: '债券类型',
                name: 'zqlb_id',
                displayField: 'name',
                valueField: 'code',
                editable: false,
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                readOnly: false
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    ReloadYdjhChoose()
                }
            }
        ];
        var headerjson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count'
            },
            {dataIndex: 'YDJH_ID', text: "月度计划ID", type: "string", hidden: true},
            {dataIndex: 'YEAR', text: "计划年度", type: "string", hidden: true},
            {dataIndex: 'YDJH_YEAR', text: "计划年度", type: "string", width: 100},
            {dataIndex: 'YDJH_MONTH', text: "计划月份", type: "string", width: 100},
            {dataIndex: 'JHFX_DATE', text: "计划发行时间", type: "string", width: 180},
            {dataIndex: 'PCJH_ID', text: "发行批次ID", type: "string", width: 180,hidden:true},
            {dataIndex: 'ZQPC_NAME', text: "发行批次", type: "string", width: 180},
            {dataIndex: 'ZQ_NAME', text: "债券名称", type: "string", width: 200},
            {dataIndex: 'ZQLB_ID', text: "债券类型ID", type: "string", width: 100,hidden:true},
            {dataIndex: 'ZQLB_NAME', text: "债券类型", type: "string", width: 100},
            {dataIndex: 'PLAN_XZ_AMT', text: "新增债券金额（亿元）", type: "float", width: 180,align:'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            },
            {
                dataIndex: 'PLAN_ZRZ_AMT', text: "再融资债券金额（亿元）", type: "float", width: 180, align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'ydjhChooseGrid',
            headerConfig: {
                headerJson: headerjson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SIMPLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '50%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params: {
                AD_CODE: AD_CODE
            },
            dataUrl: 'getExistYdjh.action',
            tbar:toolbar_choose_ydjh ,
            listeners: {
                itemclick: function (self, record) {
                }
            }
        });
    }

    // 已有月度计划查询方法
    function ReloadYdjhChoose(param) {
        var grid = DSYGrid.getGrid('ydjhChooseGrid');
        var store = grid.getStore();
        var jh_year = Ext.ComponentQuery.query('combobox[name="debt_year"]')[0].value;
        var jh_month = Ext.ComponentQuery.query('combobox[name="debt_month"]')[0].value;
        var zqlb_id = Ext.ComponentQuery.query('treecombobox[name="zqlb_id"]')[0].value;

        //增加查询参数
        store.getProxy().extraParams['jh_year'] = jh_year;
        store.getProxy().extraParams['jh_month'] = jh_month;
        store.getProxy().extraParams['zqlb_id'] = zqlb_id;

        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
    }

    /**
     * 加载页面数据
     * @param form
     */
    function loadYdjh(ids,form,cxt_grid) {
        form.load({
            url: 'loadYdjhInfo.action',
            waitTitle: '请等待',
            waitMsg: '正在加载中...',
            params: {ids:Ext.util.JSON.encode(ids)},
            success: function (form_success, action) {
                var jhfx_amt_total = 0;
                for(var i = 0;i < action.result.data.list.length;i++){
                    jhfx_amt_total += action.result.data.list[i].JHFX_AMT_TOTAL;
                }
                action.result.data.list[0].JHFX_AMT_TOTAL = jhfx_amt_total;;
                form.getForm().setValues(action.result.data.list[0]);
                cxt_grid.insertData(null,action.result.data.list);
                form.getForm().setValues(action.result.data.list[0]);
                cxt_grid.insertData(null,action.result.data.list);
            },
            failure: function (form_failure, action) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + action.result.message);
                return;
            }
        });
    }

    function reload_mainGrid() {
        var mhcx=Ext.ComponentQuery.query('textfield[name="mhcx"]')[1].getValue();
        var WF_STATUS=Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].getValue();//状态值
        var store=DSYGrid.getGrid("grid").getStore();
        var store2=DSYGrid.getGrid("grid2").getStore();
        if(mhcx!=null&&mhcx!=""&&mhcx!=undefined){
            store2.getProxy().extraParams['FXJH_ID'] = '';
            store.getProxy().extraParams['mhcx']=mhcx;
        }else{
            store2.getProxy().extraParams['FXJH_ID'] = '';
            store.getProxy().extraParams['mhcx']="";
        }
        store.getProxy().extraParams['WF_STATUS']=WF_STATUS;
        store.loadPage(1);
        store2.loadPage(1);
    }

    function reset_field_data(is_update){
        var form_input=Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0];
        var CXFS_ID = form_input.getForm().findField("CXFS_ID");
        var PSFS_ID = form_input.getForm().findField("PSFS_ID");
        var TZR_COUNT = form_input.getForm().findField("TZR_NUMS");
        var grid_input=Ext.ComponentQuery.query('grid[itemId="init_cxt_grid"]')[0];
        if (form_input.getForm().findField("FXFS_ID").getValue() == '01') {
            fxfs = 1;
            CXFS_ID.store.proxy.url = DebtEleStoreDB('DEBT_ZBFS').proxy.url;
            PSFS_ID.store.proxy.url = DebtEleStoreDB('DEBT_ZHBFS').proxy.url;
            CXFS_ID.store.loadPage(1);
            PSFS_ID.store.loadPage(1);
            if (CXFS_ID.config.allowBlank) {
                CXFS_ID.setFieldLabel("招标方式");
            } else {
                CXFS_ID.setFieldLabel('<span class="required">✶</span>' + '招标方式')
                if(is_update=='1'){
                    CXFS_ID.clearValue();
                    CXFS_ID.setValue("02");

                }
            }

            if (PSFS_ID.config.allowBlank) {
                PSFS_ID.setFieldLabel("中标方式");
            } else {
                PSFS_ID.setFieldLabel('<span class="required">✶</span>' + '中标方式')
                if(is_update=='1'){
                    PSFS_ID.clearValue();
                    PSFS_ID.setValue("02");
                }
            }
            if (TZR_COUNT.config.allowBlank) {
                TZR_COUNT.setFieldLabel("投标人总数");
            } else {
                TZR_COUNT.setFieldLabel('<span class="required">✶</span>' + '投标人总数')
            }
            if(grid_input.columns.length>0){
                grid_input.columns[12].setText("全场最高投标量（万元）");
                grid_input.columns[13].setText("单笔最高投标量（亿元）");
                grid_input.columns[14].setText("单笔最低投标量（万元）");
            }
        } else {
            fxfs = 0;
            CXFS_ID.store.proxy.url = DebtEleStoreDB('DEBT_CXFS').proxy.url;
            PSFS_ID.store.proxy.url = DebtEleStoreDB('DEBT_PSFS').proxy.url;
            CXFS_ID.store.loadPage(1);
            PSFS_ID.store.loadPage(1);
            if (CXFS_ID.config.allowBlank) {
                CXFS_ID.setFieldLabel("承销方式");
            } else {
                CXFS_ID.setFieldLabel('<span class="required">✶</span>' + '承销方式')
                if(is_update=='1') {
                    CXFS_ID.clearValue();
                    CXFS_ID.setValue("02");
                }
            }
            if (PSFS_ID.config.allowBlank) {
                PSFS_ID.setFieldLabel("配售方式");
            } else {
                PSFS_ID.setFieldLabel('<span class="required">✶</span>' + '配售方式')
                if(is_update=='1') {
                    PSFS_ID.clearValue();
                    PSFS_ID.setValue("02");
                }
            }
            if (TZR_COUNT.config.allowBlank) {
                TZR_COUNT.setFieldLabel("投资人总数");
            } else {
                TZR_COUNT.setFieldLabel('<span class="required">✶</span>' + '投资人总数')
            }
            if(grid_input.columns.length>0){
                grid_input.columns[12].setText("全场最高申购量（万元）");
                grid_input.columns[13].setText("单笔最高申购量（亿元）");
                grid_input.columns[14].setText("单笔最低申购量（万元）");
            }
        }
        var fxr_code=form_input.getForm().findField("FXR_CODE").getValue();

    }


    var jgxxStore_fxr=DebtEleStoreTable('debt_v_zqgl_fxjh_fxr');

    function setGrid_form(){
        var form_input=Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0];
        var form_dtl=form_input.getForm();
        if(!is_fix){
           // form_dtl.findField("JHFX_DATE").setValue(format_date('d',0));
            form_dtl.findField("FXFS_ID").setValue('01');
            form_dtl.findField("ZQLX_ID").setValue('01');
            form_dtl.findField("JXFS_ID").setValue("01");
            form_dtl.findField("CXFS_ID").setValue("02");
            form_dtl.findField("PSFS_ID").setValue("02");
            form_dtl.findField("FXMZ_AMT").setValue(100);
            
            form_dtl.findField("SSLTAP").setValue("按要求上市流通");
            form_dtl.findField("DJTGAP").setValue("按要求完成登记托管");

            if(jgxxStore_cxt.getAt(0)!==null&&jgxxStore_cxt.getAt(0)!=""&&jgxxStore_cxt.getAt(0)!=undefined){
                form_dtl.findField("CXT_ID").setValue(jgxxStore_cxt.getAt(0).get("code"));
            }
            if(jgxxStore_fxr.getAt(0)!==null&&jgxxStore_fxr.getAt(0)!=""&&jgxxStore_fxr.getAt(0)!=undefined){
                form_dtl.findField("FXR_CODE").setValue(jgxxStore_fxr.getAt(0).get("code"));
            }
            form_dtl.findField("ZQ_FXTIME").setValue("9:00-9:40");
            form_dtl.findField("FENX_START_DATE").setValue(format_date('d',6));
            form_dtl.findField("FENX_END_DATE").setValue(format_date('d',11));
            form_dtl.findField("GG_DATE").setValue(format_date('d',0));

            if(fxfs==0){//承销  +2
                form_dtl.findField("JK_DATE").setValue(format_date('d',9));
            }else if(fxfs==1){  //公开 +1
                form_dtl.findField("JK_DATE").setValue(format_date('d',8));
            }
        }
        form_dtl.findField("FXFS_ID").on(
            { select:{fn:function() {
                        reset_field_data('1');
                    },scope: this, single: false}
            }
        );
        form_dtl.findField("CXFS_ID").on(
            {select:{fn:function(combox,record) {
                        var store;
                        if(fxfs==1){
                            store=form_dtl.findField("PSFS_ID").getStore();
                        }else if(fxfs==0){
                            store=form_dtl.findField("PSFS_ID").getStore();
                        }
                        store.load({
                            callback:function () {
                                store.commitChanges();
                                form_dtl.findField("PSFS_ID").clearValue();
                            }
                        })
                    }
                },scope: this, single: false }
        );
        form_dtl.findField("PSFS_ID").getStore().autoLoad=false;
        var sss_temp=form_dtl.findField("PSFS_ID").getStore().load();
        sss_temp.filterBy(function(record) {
            var CXFS_ID= form_dtl.findField("CXFS_ID").getValue();
            if(CXFS_ID=='01') {
                if(record.get('code')=='02'||record.get('code')=='03'){
                    return false;
                }else{
                    return true;
                }
            }else if(CXFS_ID=='02'){
                if(record.get('code')=='01'){
                    return false;
                }else {
                    return true;

                }
            }else if(CXFS_ID=='03'){
                if(record.get('code')=='01'){
                    return false;
                }else {
                    return true;
                }
            }else if(CXFS_ID=='04'){
                if(record.get('code')=='01'||record.get('code')=='03'){
                    return false;
                }else{
                    return true;
                }
            }
        });
        form_dtl.findField("JHFX_DATE").on(
            { select:{fn:function(combox,record) {
                        form_dtl.findField("FENX_START_DATE").setValue(format_date('d',-1,record));
                        form_dtl.findField("FENX_END_DATE").setValue(format_date('d',4,record));
                        form_dtl.findField("GG_DATE").setValue(format_date('d',-7,record));
                        var jk_date_temp=new Date();
                        if(fxfs==0){   //承销  +2
                            jk_date_temp=format_date('d',2,record);
                        }else if(fxfs==1){  //公开 +1
                            jk_date_temp=format_date('d',1,record);
                        }
                        form_dtl.findField("JK_DATE").setValue(jk_date_temp);
                        var grid_data = DSYGrid.getGrid('init_cxt_grid').getStore();
                        for(var i=0;i<grid_data.getCount();i++){
                            grid_data.getAt(i).set("QX_DATE",jk_date_temp);
                            var record2=grid_data.getAt(i).get("ZQQX_ID");
                            var bb=record2.replace(/\b(0+)/gi,"").substring(0,record2.length-1);
                            if(bb!=null&&bb!=""&&bb!=undefined){
                            }else{
                                bb='0';
                            }
                            grid_data.getAt(i).set("DF_DATE",format_date('y',parseInt(bb),grid_data.getAt(i).get("QX_DATE")));
                        }
                    },scope: this, single: false}
            }
        );
        var grid = DSYGrid.getGrid('init_cxt_grid');
        grid.on('edit',function (editor, context) {
          //  context.record.set('FXF_RATE',1);
            if (context.field == 'ZQQX_ID') {
                var record = jgxxStore_zqqx.findRecord('code', context.value, false, true, true);
                if(record!=null) {
                    context.record.set('ZQQX_ID', record.get('name'));//record.get('name')
                    var bb = record.get('name').replace(/\b(0+)/gi, "").substring(0, record.get('name').length - 1);
                    if (bb != null && bb != "" && bb != undefined) {
                    } else {
                        bb = '0';
                    }
                }
                var qx_date=context.record.get("QX_DATE");
                context.record.set('DF_DATE', format_date('y',parseInt(bb),qx_date));
              /*  if(context.value=='001'){ //
                    context.record.set('FXPL_ID', "1年一次");
                    context.record.set('FXF_RATE',0.5);
                }else if(context.value=='002'){
                    context.record.set('FXPL_ID', "1年一次");
                    context.record.set('FXF_RATE',0.5);
                }else if(context.value=='003'){
                    context.record.set('FXPL_ID', "1年一次");
                    context.record.set('FXF_RATE',0.5);
                }else if(context.value=='005'){
                    context.record.set('FXPL_ID', "1年一次");
                    context.record.set('FXF_RATE',1);
                }else if(context.value=='007'){
                    context.record.set('FXPL_ID', "1年一次");
                    context.record.set('FXF_RATE',1);
                }else if(context.value=='010'){
                    context.record.set('FXPL_ID', "半年一次");
                    context.record.set('FXF_RATE',1);
                }*/
                //根据债券期限给付息频率加默认值：当债券期限小于10年时，付息频率一年一次，大于等于10年至30，付息频率半年一次
                if(parseInt(sub(context.value))>0&&parseInt(sub(context.value))<10){
                    context.record.set('FXPL_ID', 12);
                    context.record.set('FXF_RATE',1);
                }else if(parseInt(sub(context.value))>=10&&parseInt(sub(context.value))<=30){
                    context.record.set('FXPL_ID',12);
                    context.record.set('FXF_RATE',1);
                }
            }
            if (context.field == 'ZDJWD') {
                context.record.set('ZGJWD', parseInt(context.value)*1.25);
            }
            if (context.field == 'FXPL_ID') {
                var record = jgxxStore_fxpl.findRecord('code', context.value, false, true, true);
                if(record!=null){
                    context.record.set('FXPL_ID', record.get('name'));
                }
            }
            if (context.field =='JHFX_AMT'){ //
                setjhfx_amt();
                if(isNotANumber(context.value)&&context.value>=0){
                    var DBZGSG_AMT=0;
                    if(fxfs==1){
                        DBZGSG_AMT=context.value*0.35;
                    }else if(fxfs==0){
                        DBZGSG_AMT=context.value*0.35;
                    }
                    DBZGSG_AMT=Ext.util.Format.round(DBZGSG_AMT, 1);
                    context.record.set('DBZGSG_AMT', DBZGSG_AMT.toFixed(1).toString()*10000);
                    Ext.util.Format.number(DBZGSG_AMT , '0,000.0');

                    context.record.set('QX_DATE', format_date2(context.value,'yyyy-MM-dd'));
                }
                
            }
            if (context.field =='QX_DATE'){
                var record=context.record.get("ZQQX_ID");
                var bb=record.replace(/\b(0+)/gi,"").substring(0,record.length-1);
                if(bb!=null&&bb!=""&&bb!=undefined){
                }else{
                    bb='0';
                }
                context.record.set('QX_DATE', format_date2(context.value,'yyyy-MM-dd'));
                context.record.set('DF_DATE', format_date('y',parseInt(bb),context.value));
            }
            if (context.field =='DF_DATE'){ //
                context.record.set('DF_DATE', format_date2(context.value,'yyyy-MM-dd'));
            }
            if (context.field == 'JKQX_DATE'){
                context.record.set('JKQX_DATE', format_date2(context.value, 'yyyy-MM-dd'));
            }
            if (context.field == 'LXDF_DATE'){
                context.record.set('LXDF_DATE', format_date2(context.value, 'yyyy-MM-dd'));
            }
        });
        var sss=DSYGrid.getGrid('init_cxt_grid').columns;
        if(sss!=null&&sss!=""&&sss!=undefined){
            sss[5].renderer=function (value) {
                var record = jgxxStore_zqqx.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            };
            sss[6].renderer=  function (value) {
                var record = jgxxStore_fxpz.findRecord('id', value, false, true, true);
                return record != null ? record.get('name') : value;
            };
            sss[7].renderer=  function (value) {
                return Ext.util.Format.number(value, '0,000.0000####');
            };
            sss[8].renderer=  function (value) {
                return Ext.util.Format.number(value, '0,000.000000##');
            };
            sss[11].renderer=function (value) {
                var record = jgxxStore_fxpl.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            };
            sss[13].renderer=  function (value) {
                return Ext.util.Format.number(value, '0,000.0');
            };
        }

    }
    function fomatFloat(num,n){
        var f = parseFloat(num);
        if(isNaN(f)){
            return false;
        }
        f = Math.round(num*Math.pow(10, n))/Math.pow(10, n); // n 幂
        var s = f.toString();
        var rs = s.indexOf('.');
        //判定如果是整数，增加小数点再补0
        if(rs < 0){
            rs = s.length;
            s += '.';
        }
        while(s.length <= rs + n){
            s += '0';
        }
        return s;
    }
    //截取债券期限字符串
function sub(value) {
    if(value.substring(0, 2)=='00'){
        var s=value.substring(3,2);
        value=s;
    }else{
        value=value.substring(3,1);
    }
    return value;
}
    function Input_fxjh_window() {
        var ui= initPanel_UI(null,'DEBTZQGLPA002','init_cxt_form','init_cxt_grid');
        var item1 = ui.items.items[0];
        var item2 = ui.items.items[1];
        if(item1.itemId == 'init_cxt_form') {
            item1.flex = 1.5;
            item2.flex = 1.0;
        }
        if(item1.itemId == 'init_cxt_grid') {
            item1.flex = 1.0;
            item2.flex = 1.5;
        }
        var cxtxx = Ext.create('Ext.panel.Panel', {
            width: '100%',
            height: '100%',
            itemId: 'cxtForm',
            border: false,
            layout:'fit',
            padding: '2 2 2 2',
            items: ui,
        });
        setGrid_form();
        return cxtxx;
    }
    function load_some_data_single(pc_id,fxjh_id) {
        $.ajax({
            type : "post",
            url : "getFxjhSingle.action?FXJH_ID="+pc_id+"&FXJH_ID="+fxjh_id,
            dataType: "json",
            async : false,
            success : function(data){
                var datas=data;
                datas=datas[0];
                var form_input=Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0];
                datas.list[0].JHFX_AMT_TOTAL= datas.list[0].JHFX_AMT_TOTAL/100000000;
//                    if(datas.list[0].FXFS!=null&&datas.list[0].FXFS!=''&&datas.list[0].FXFS!=undefined) {
//                         if(datas.list[0].FXFS=='01'){
//                         }else{
//                         }
//                    }
                form_input.getForm().setValues(datas.list[0]);
                reset_field_data('0');
                var grid_data = DSYGrid.getGrid('init_cxt_grid');
                for(var i=0;i<datas.grid.length;i++){
                    var record2 = jgxxStore_zqqx.findRecord('code', datas.grid[i].ZQQX_ID, false, true, true);
                    if(record2!=null){
                        datas.grid[i].ZQQX_ID=record2.get('name');
                    }
                    var record3 = jgxxStore_fxpl.findRecord('code', datas.grid[i].FXPL_ID, false, true, true);
                    if(record3!=null){
                        datas.grid[i].FXPL_ID=record3.get('name');
                    }
                    datas.grid[i].QCZGSG_AMT=datas.grid[i].QCZGSG_AMT/10000;
                    datas.grid[i].DBZGSG_AMT=datas.grid[i].DBZGSG_AMT/100000000;
                    datas.grid[i].DBZDSG_AMT=datas.grid[i].DBZDSG_AMT/10000;
                    datas.grid[i].JHFX_AMT=datas.grid[i].JHFX_AMT/100000000;
                    datas.grid[i].FXF_RATE=datas.grid[i].FXF_RATE/10;
                    grid_data.getStore().addSorted(datas.grid[i]);
                }
            }
        });


    }
    var is_fix=false;

    function fixfxjh(pc_id,fxjh_id) {
        Input_fxjh_windows.show();
        load_some_data_single(pc_id,fxjh_id);
    }

    function setjhfx_amt() {
        var form = Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0].getForm();
        var jhfx_amt=form.findField("JHFX_AMT_TOTAL");
        var jgxxStore = DSYGrid.getGrid('init_cxt_grid').getStore();
        //调用前端方法生成与后台一样策略的32位UUID方法并赋值给FXJH_DTL_ID
        for(i=0;i<jgxxStore.data.items.length;i++){
            if(!jgxxStore.data.items[i].data.FXJH_DTL_ID){
                jgxxStore.data.items[i].data.FXJH_DTL_ID = createUuid(32);
            }
        }
        var jhfx_value=0;
        for (var i = 0; i < jgxxStore.getCount(); i++) {
            var record = jgxxStore.getAt(i);
            var jhfx_amt_temp=record.get("JHFX_AMT");
            if(jhfx_amt_temp==null||jhfx_amt_temp==''||jhfx_amt_temp<0||jhfx_amt_temp==undefined){
                jhfx_amt_temp=0;
            }
            jhfx_value+=jhfx_amt_temp;
        }
        jhfx_amt.setValue(jhfx_value);
        for (var i = 0; i < jgxxStore.getCount(); i++) {
           jgxxStore.getAt(i).set("QCZGSG_AMT",jhfx_value*10000);
        }
    }

    function isNotANumber(inputData) {
        //isNaN(inputData)不能判断空串或一个空格
        //如果是一个空串或是一个空格，而isNaN是做为数字0进行处理的，而parseInt与parseFloat是返回一个错误消息，这个isNaN检查不严密而导致的。
        if (parseFloat(inputData).toString() == "NaN") {
            //alert("请输入数字……");注掉，放到调用时，由调用者弹出提示。
            //是数字：返回true；不是数字：返回false
            return false;
        } else {
            return true;
        }
    }
    function Input_fxjh_windows_fxxx() {
        return Ext.create('Ext.window.Window', {
            title: '债券承销发行', // 窗口标题
            width: document.body.clientWidth * 0.90, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            itemId: 'window_fxjh', // 窗口标识
            maximizable: true,//最大化按钮
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
            items: Input_fxjh_window(),
            buttons: [
                {
                    text: '增行',
					itemId:'addColumn',
                    handler: function (btn) {
                        var form_input=Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0];
                        var form_dtl=form_input.getForm();
                        var fxdate=form_dtl.findField("JHFX_DATE");
                        var zqbm;

                        var zqqx_var;
                        var grid = DSYGrid.getGrid('init_cxt_grid');
                        var store=grid.getStore();
                        var last_record=store.getAt(store.getCount()-1);
                        var form = Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0].getForm();
                        var fx_date=form.findField("JHFX_DATE").getValue();
                        if(fx_date!=null&&fx_date!=""&&fx_date!=undefined){
                            fx_date= format_date2(new Date(Date.parse(new Date(fx_date)+24*60*60*1000)),'yyyy-MM-dd');
                        }else{
                            fx_date=format_date2(new Date(),'yyyy-MM-dd');
                        }
                        if(last_record!=null&&last_record!=""&&last_record!=undefined){
                            zqbm=last_record.data.ZQ_CODE;
                            if(zqbm!=null&&zqbm!=""&&zqbm!=undefined){
                                var zqbm_temp=zqbm.charAt(zqbm.length - 1);
                                if(isNotANumber(zqbm_temp)){
                                    zqbm_temp=(parseInt(zqbm_temp)+1).toString();
                                }else{
                                    zqbm_temp=zqbm_temp.charCodeAt()+1;
                                    zqbm_temp=String.fromCharCode(zqbm_temp);
                                }
                                zqbm_temp=zqbm_temp;
                                zqbm=zqbm.substring(0,zqbm.length-1)+zqbm_temp;
                            }
                            zqqx_var= last_record.data.ZQQX_ID;
                            if(zqqx_var!=null&&zqqx_var!=""&&zqqx_var!=undefined){
                                var var1=jgxxStore_zqqx.findRecord('name', zqqx_var, false, true, true);
                                var var1_num=jgxxStore_zqqx.indexOf(var1);
                                if(var1_num>=jgxxStore_zqqx.getCount()-1){
                                    var1_num=0;
                                }else{
                                    var1_num=var1_num+1;
                                }
                                var var2 = jgxxStore_zqqx.getAt(var1_num);
                                zqqx_var=var2.get('name');
                            }
                            // last_record.data
                            var bb=zqqx_var.replace(/\b(0+)/gi,"").substring(0,zqqx_var.length-1);
                            if(bb!=null&&bb!=""&&bb!=undefined){
                            }else{
                                bb='0';
                            }
                            if(fxdate!=null&&fxdate!=""&&fxdate!=undefined){
                                var qx_date;    // 起息日
                                var max_zgtbl=0;   //全场最高投标量
                                var max_db_zgtbl=0;   //单笔最高投标量
                                var max_db_zdsgl=0;    //单笔最低申购量
                                var FXF_RATE_temp=1;
                                if(zqqx_var=='3年'){
                                    FXF_RATE_temp=1;
                                }else if(zqqx_var=='5年'||zqqx_var=='7年'||zqqx_var=='10年'){
                                    FXF_RATE_temp=1;
                                }
                                var fxpl_temp=last_record.data.FXPL_ID;
                                if(zqqx_var=="3年"||zqqx_var=="5年"||zqqx_var=="7年"){
                                    fxpl_temp='1年一次';
                                }else if(zqqx_var=="10年"){
                                    fxpl_temp='半年一次';
                                }
                                if(fxfs==0){//承销
                                    qx_date=format_date('d',2,fxdate.getValue());
                                    max_zgtbl=last_record.data.JHFX_AMT*10000;
                                    max_db_zgtbl=last_record.data.JHFX_AMT*0.35;
                                    max_db_zdsgl=1;
                                }else if(fxfs==1){  //公开
                                    qx_date=format_date('d',1,fxdate.getValue());
                                    max_zgtbl=last_record.data.JHFX_AMT*10000;
                                    max_db_zgtbl=last_record.data.JHFX_AMT*0.35;
                                    max_db_zdsgl=1000;
                                }
                                store.insertData(null,{ZQ_NAME:last_record.data.ZQ_NAME,ZQQX_ID:zqqx_var,
                                    DF_DATE:format_date('y',parseInt(bb),last_record.data.QX_DATE),
                                    ZQJC_NAME:last_record.data.ZQJC_NAME,QX_DATE:qx_date,ZQ_CODE:zqbm,
                                    JHFX_AMT:last_record.data.JHFX_AMT,QCZGSG_AMT:max_zgtbl,DBZGSG_AMT:max_db_zgtbl,
                                    DBZDSG_AMT:max_db_zdsgl,FXPL_ID:fxpl_temp,FXF_RATE:FXF_RATE_temp,
                                    JKQX_DATE:format_date('y',parseInt(bb),last_record.data.JKQX_DATE),FXF_RATE:1});
                            }else{
                                var qx_date;
                                var qx_date;    // 起息日
                                var max_zgtbl=0;   //全场最高投标量
                                var max_db_zgtbl=0;   //单笔最高投标量
                                var max_db_zdsgl=0;    //单笔最低申购量
                                var FXF_RATE_temp=1;
                                if(zqqx_var=='003'){
                                    FXF_RATE_temp=1;
                                }else if(zqqx_var=='005'||zqqx_var=='007'||zqqx_var=='010'){
                                    FXF_RATE_temp=1;
                                }

                                var fxpl_temp=last_record.data.FXPL_ID;
                                if(zqqx_var=="3年"||zqqx_var=="5年"||zqqx_var=="7年"){
                                    fxpl_temp='1年一次';
                                }else if(zqqx_var=="10年"){
                                    fxpl_temp='半年一次';
                                }

                                if(fxfs==0){//承销
                                    qx_date=format_date('d',9);
                                    max_zgtbl=last_record.data.JHFX_AMT*10000;
                                    max_db_zgtbl=last_record.data.JHFX_AMT*10000*0.35;
                                    max_db_zdsgl=1;
                                }else if(fxfs==1){  //公开
                                    qx_date=format_date('d',8);
                                    max_zgtbl=last_record.data.JHFX_AMT*10000;
                                    max_db_zgtbl=last_record.data.JHFX_AMT*10000*0.35;
                                    max_db_zdsgl=1000;
                                }
                                store.insertData(null,{ZQ_NAME:last_record.data.ZQ_NAME,ZQQX_ID:zqqx_var, DF_DATE:format_date('y',parseInt(bb),last_record.data.QX_DATE),ZQJC_NAME:last_record.data.ZQJC_NAME,QX_DATE:qx_date,ZQ_CODE:zqbm,JHFX_AMT:last_record.data.JHFX_AMT,QCZGSG_AMT:max_zgtbl,DBZGSG_AMT:max_db_zgtbl,DBZDSG_AMT:max_db_zdsgl,FXPL_ID:fxpl_temp,FXF_RATE:FXF_RATE_temp,JKQX_DATE:format_date('y',parseInt(bb),last_record.data.JKQX_DATE),FXF_RATE:1});
                            }
                        }else{
                            if(fxdate!=null&&fxdate!=""&&fxdate!=undefined){
                                var qx_date;
                                var max_db_zdsgl=0;
                                if(fxfs==0){//承销
                                    qx_date=format_date('d',2,fxdate.getValue());
                                    max_db_zdsgl=1;
                                }else if(fxfs==1){  //公开
                                    qx_date=format_date('d',1,fxdate.getValue());
                                    max_db_zdsgl=1000;
                                }
                                store.insertData(null,{QX_DATE:qx_date,DBZDSG_AMT:max_db_zdsgl,FXPL_ID:'1年一次' ,FXF_RATE:1});
                            }else{
                                var qx_date;
                                var max_db_zdsgl=0;
                                if(fxfs==0){//承销
                                    qx_date=format_date('d',9);
                                    max_db_zdsgl=1;
                                }else if(fxfs==1){  //公开
                                    qx_date=format_date('d',8);
                                    max_db_zdsgl=1000;
                                }
                                store.insertData(null,{QX_DATE:qx_date,DBZDSG_AMT:max_db_zdsgl,FXPL_ID:'1年一次',FXF_RATE:1 });
                            }
                        }
                        setjhfx_amt();
                    }
                },
                {
                    text: '删行',
					itemId:'delColumn',
                    handler: function (btn) {

                        var grid = DSYGrid.getGrid('init_cxt_grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        var smSelect = sm.getSelection();
                        //将grid表格删除的行的主键ID插入到数组当中
                        Ext.each(smSelect, function (item) {//放入要删除的id
                            deleteIds.push(item.data.FXJH_DTL_ID);
                        })
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            // sm.select(0);
                        }
                        setjhfx_amt();
                    }
                },
                {
                    text: '保存',
					itemId:'save',
                    handler: function (btn) {
                        //获取form表单信息
                        var form=Ext.ComponentQuery.query('form[itemId="init_cxt_form"]')[0];
                        var jgxxStore = DSYGrid.getGrid('init_cxt_grid').getStore();


                        if (jgxxStore.getCount() <= 0) {
                            Ext.Msg.alert('提示', "请添加发行计划信息！");
                            return;
                        }
                        if(!form.getForm().isValid()){
                            Ext.toast({
                                html: "表单校验未通过，请检查！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                      var  button_name = btn.text;
                        var JHFX_DATE=form.getForm().findField("JHFX_DATE").getValue(); //发现日期

                        var FENX_START_DATE=form.getForm().findField("FENX_START_DATE").getValue(); //起分销日

                        var FENX_END_DATE=form.getForm().findField("FENX_END_DATE").getValue(); //止分销日

                        var JK_DATE=form.getForm().findField("JK_DATE").getValue();  //缴款日

                        if(FENX_END_DATE<JHFX_DATE){
                            Ext.toast({
                                html: "止分销日不能小于发行日期！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if(JK_DATE<JHFX_DATE){
                            Ext.toast({
                                html: "缴款日不能小于发行日期！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if(FENX_START_DATE>FENX_END_DATE){
                            Ext.toast({
                                html: "起分销日不能大于止分销日！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }


                        //修改
                        var jgxxArray = new Array();
                        for (var i = 0; i < jgxxStore.getCount(); i++) {
                            var record = jgxxStore.getAt(i);
                            var record_now=record.data;
                            if (!record_now.ZQ_NAME || record_now.ZQ_NAME == null||record_now.ZQ_NAME == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '债券名称不能为空，请输入债券名称',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (record_now.FXF_RATE<0 || record_now.FXF_RATE == null||record_now.FXF_RATE == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '发行费率不能为空，请输入发行费率',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.ZQ_CODE || record_now.ZQ_CODE == null||record_now.ZQ_CODE == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '债券代码不能为空，请输入债券代码',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.FXPZ ||record_now.FXPZ == null||record_now.FXPZ == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '发行品种不能为空!',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.JHFX_AMT || record_now.JHFX_AMT == null||record_now.JHFX_AMT == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '计划发行金额不能为空，请输入计划发行金额',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.ZQQX_ID || record_now.ZQQX_ID == null||record_now.ZQQX_ID == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '债券期限不能为空，请输入有效数值',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.FXPL_ID ||record_now.FXPL_ID == null||record_now.FXPL_ID == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '付息频率不能为空，请输入有效数值',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.QX_DATE||record_now.QX_DATE == null||record_now.QX_DATE == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '起息日不能为空，请输入有效数值',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if (!record_now.DF_DATE || record_now.DF_DATE == null||record_now.DF_DATE == undefined) {
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '兑付日不能为空，请输入有效数值',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if(record_now.QX_DATE>record_now.DF_DATE){
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '起息日不能大于兑付日',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            if(record_now.QX_DATE<format_date2(JHFX_DATE,'yyyy-MM-dd')){
                                Ext.MessageBox.show({
                                    title: '提示',
                                    msg: '起息日不能小于发行日期',
                                    width: 200,
                                    buttons: Ext.MessageBox.YES,
                                    fn: function (btn) {
                                    }
                                });
                                return;
                            }
                            var record2 = jgxxStore_zqqx.findRecord('name', record.get('ZQQX_ID'), false, true, true);
                            if(record2!=null&&record2!=""&&record2!=undefined){
                                record_now.ZQQX_ID= record2.get('code');
                            }
                            record2 = jgxxStore_fxpl.findRecord('name', record.get('FXPL_ID'), false, true, true);
                            if(record2!=null&&record2!=""&&record2!=undefined) {
                                record_now.FXPL_ID = record2.get('code');
                            }
                            jgxxArray.push(record_now);
                        }
                        submitFxjh(form, jgxxArray,button_name);
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

    //弹出批次填写页面
    function initWindow_fxpc() {
        var contentform=Ext.create('Ext.form.Panel', {
            width: '100%',
            // height: 388,
            itemId: 'cxtForm_2',
            autoScroll: true,
            //  layout: 'vbox',
            border: false,
            // padding: '2 2 2 2',
            items: [
                {
                    xtype: 'textfield',
                    name: 'ZBPC',
                    width: '30%',
                    labelWidth: 50,//控件默认标签宽度
                    margin:'10,2,5,2',
                    //fieldCls: 'form-unedit',
                    emptyText: '自定义的批次',
                    fieldLabel: '批次'
                }
            ]
        });

        var contentgrid=DSYGrid.createGrid({
            itemId: 'grid_fxjh',
            border: false,
            autoScroll: true,
            width:'100%',
//              height:'100%',
            headerConfig: {
                headerJson: [
                    {
                        xtype: 'rownumberer', width: 40, summaryType: 'count',
                        summaryRenderer: function () {
                            return '合计';
                        }
                    },
                    {
                        "dataIndex": "FXJH_ID",
                        "type": "string",
                        "text": "发行计划D",
                        "fontSize": "15px",
                        "width": 150,
                        hidden: true
                    },
                    {
                        "dataIndex": "ZQ_NAME",
                        "type": "string",
                        "text": "债券名称",
                        "fontSize": "15px",
                        "width": 150
                    },
                    {text: "债券简称", dataIndex: "ZQJC_NAME", width: 250, type: "string"},
                    {
                        "dataIndex": "ZQ_CODE",
                        "type": "string",
                        "text": "债券代码",
                        "fontSize": "15px",
                        "width": 150
                    },
                    {text: "计息方式", dataIndex: "JXFS_ID", type: "string"},
                    {text: "起息日", dataIndex: "QX_DATE", type: "string"},
                    {
                        "dataIndex": "DF_DATE",
                        "width": 150,
                        "type": "string",
                        "text": "兑付日"
                    },
                    {
                        "dataIndex": "JHFX_AMT",
                        "width": 150,
                        "type": "number",
                        "align": 'right',
                        "text": "计划发行总额(万元)",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10000, '0,000.00####');
                        },
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {
                        "dataIndex": "PZ_AMT",
                        "width": 150,
                        "type": "number",
                        "align": 'right',
                        "text": "批准额度",
                        renderer: function (value) {       //万元
                            return Ext.util.Format.number(value/10000, '0,000.00####');
                        },
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {
                        "dataIndex": "ZQQX_ID",
                        "width": 150,
                        "type": "string",
                        "text": "债券期限"
                    },
                    {
                        "dataIndex": "FX_PRICE",
                        "width": 150,
                        "type": "string",
                        "text": "发行价格"
                    },
                    {
                        "dataIndex": "LV_REMARK",
                        "width": 150,
                        "type": "string",
                        "align": 'left',
                        "text": "基准利率说明"
                    }
                ],
                columnAutoWidth: false
            },
            dataUrl: [],
            autoLoad: false,
            checkBox: true,
            pageConfig: {
                pageNum: false// 每页显示数据数
            },
            features: [{
                ftype: 'summary'
            }]
        });

        return Ext.create('Ext.panel.Panel', {
            layout: 'vbox',
            width: '100%',
            //  height:'100%',
            autoScroll: true,
            border: false,
            items: [
                contentform,
                contentgrid
            ]

        });
    }

    //        function initWindow_fxpc_contentForm() {
    //            var form=
    //            return form;
    //        }

    function submitFxjh(form,jgxxArray,button_name) {
        var jgxxStore = DSYGrid.getGrid('init_cxt_grid').getStore();
        var jgxxJson = Ext.util.JSON.encode(jgxxArray);
        //将值为null的数据类型转化为"null",json能识别的类型
        jgxxJson = jgxxJson.replaceAll(":null,",":\"\",");
        form.submit({
            method: 'POST',
            url: 'SaveCxtFxjh.action',
            params: {
                ad_code: userAD,
                ag_code: userAG,
                //  FXPC_ID:fxpc_id,
                ZFX_ID:ZFX_ID,
                is_fix:is_fix?'1':'0',
                jgxxArray: jgxxJson,
                DELETEIDS:Ext.util.JSON.encode(deleteIds),
                wf_id:wf_id,
                node_code:node_code,
                button_name:button_name,
                IS_GZL:is_gzl
            },
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                Ext.toast({html: "保存成功！"});
                if(Ext.ComponentQuery.query('window[itemId="window_fxjh"]')[0]!=undefined){
                	Ext.ComponentQuery.query('window[itemId="window_fxjh"]')[0].close();
                }else{
                	Ext.ComponentQuery.query('window[itemId="window_ydjh"]')[0].close();
                }
                reload_mainGrid();
                deleteIds = [];
            },
            failure: function (form, action) {
                var result = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('提示', "保存失败！" + (result.message ? result.message : '无返回响应'));
            }
        });
    }


    function format_date(dorm,num,date) {
        var timestamp;
        if(date!=null&&date!=''&&date!=undefined){
            timestamp=new Date(date).getTime();
        }else{
            timestamp=new Date().getTime();
        }
        if(dorm=='d'&&num!=null&&num!=0&&num!=undefined){
            if(num>0){
                timestamp=timestamp+num*24*60*60*1000;
            }else{
                timestamp=timestamp-Math.abs(num)*24*60*60*1000;
            }
            return  format_date2(new Date(timestamp),'yyyy-MM-dd');
        }
        if(dorm=='y'&&num!=null&&num!=0&&num!=undefined){
            return  format_date2(new Date(timestamp),'yyyy-MM-dd','y',num);
        }
        return  format_date2(new Date(timestamp),'yyyy-MM-dd');
    }



    function format_date2(date_value,fmt,flag,nums,date2) { //author:
        if(date_value==null||date_value==''||typeof date_value == 'undefined'){
            return;
        }
        var o = {
            "M+": date_value.getMonth() + 1, //月份
            "d+": date_value.getDate(), //日
            "h+": date_value.getHours(), //小时
            "m+": date_value.getMinutes(), //分
            "s+": date_value.getSeconds(), //秒
            "q+": Math.floor((date_value.getMonth() + 3) / 3), //季度
            "S": date_value.getMilliseconds() //毫秒
        };
        if(nums!=null&&nums!=0&&nums!=undefined){
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date_value.getFullYear()+parseInt(nums)+ "").substr(4 - RegExp.$1.length));
        }else {
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date_value.getFullYear()+ "").substr(4 - RegExp.$1.length));
        }
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        var records = DSYGrid.getGrid('grid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("FXJH_ID"));//主单id
        button_name = btn.name;
        button_text = btn.text;
        if (btn.text == '送审' || btn.text == '撤销送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("dofxjhWorkFlow.action", {
                        button_text: button_text,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_text + "成功！" + (data.message ? data.message : ''),
                                closable: false, align: 't', slideInDuration: 400, minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.show({
                                title: '提示',
                                msg: button_text + '失败！' + (data.message ? data.message : ''),
                                minWidth: 300,
                                buttons: Ext.Msg.OK,
                                fn: function (btn) {
                                }
                            });
                        }
                        //刷新表格
                        reload_mainGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + '意见',
                value: btn.text == '审核' ? '同意' : '',
                animateTarget: btn,
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("dofxjhWorkFlow.action", {
                            button_text: button_text,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_text + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            } else {
                                Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                            }
                            //刷新表格
                            reload_mainGrid();
                        }, "json");
                    }
                }
            });
        }
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
     * 操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('grid').getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var contentGrid_ID = records[0].get("FXJH_ID");
            fuc_getWorkFlowLog(contentGrid_ID);
        }
    }

    /**
     * 利用前台生成与后台生成类似的UUID码的方法
     */
    function createUuid(len, radix) {
        var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        var uuid = [], i;
        radix = radix || chars.length;

        if (len) {
            for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
        } else {
            var r;
            uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
            uuid[14] = '4';

            // 随机填写数据
            for (i = 0; i < 36; i++) {
                if (!uuid[i]) {
                    r = 0 | Math.random()*16;
                    uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
                }
            }
        }
        return uuid.join('');
    }


</script>

<div id="main_content" style="width: 100%; height: 100%;"></div>


</body>
</html>
