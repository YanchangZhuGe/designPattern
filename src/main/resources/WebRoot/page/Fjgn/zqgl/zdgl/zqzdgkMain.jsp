<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>国库审核主界面</title>
</head>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<body>
<script type="text/javascript">
    /*获取登录用户*/
    var userAdCode = '${sessionScope.USERCODE}'.replace(/00$/, "");
    var ad_code = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var WF_STATUS = "001" ;//getUrlParam("WF_STATUS");//当前状态
    var SYS_IS_QEHBFX = '';
    var IS_CREATEJH_BY_AUDIT = 0;   //自动确认
    var IS_FTDFF_CHECKED = '1';   //是否承担兑付费
    var IS_CONFIRM_BYGK = '0' ;
    var DF_START_DATE_TEMP = new Date();
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        items: {
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
                    text: '登记',
                    name: 'down',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },
                /*{
                    xtype: 'button',
                    text: '退回',
                    name: 'up',
                    icon: '/image/sysbutton/back.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },*/
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
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销登记',
                    name: 'cancel',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        for (record_seq in records) {
                            if (records[record_seq].get('IS_QR') == '1' && IS_CREATEJH_BY_AUDIT != '1') {//撤销审核时判断该主单对应明细是否被确认
                                Ext.Msg.alert('提示', '选择撤销的转贷已被确认，无法撤销！');
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
        },
        store: {
            //WF_STATUS: DebtEleStore(json_debt_sh)
            WF_STATUS:[
                ['001','未登记'],
                ['002','已登记']
            ]
        }
    }
    $(document).ready(function(){
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        $.post("getParamValueAll.action", function (data) {
            SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX;
            IS_FTDFF_CHECKED = data[0].IS_FTDFF_CHECKED;
            IS_CREATEJH_BY_AUDIT = data[0].IS_CREATEJH_BY_AUDIT;
            IS_CONFIRM_BYGK = data[0].IS_CONFIRM_BYGK ;
            initContent();
        },"json");
    }) ;
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
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zdhk_json_common.items[WF_STATUS],
                }
            ],
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
                dataIndex: "ZQ_ID",
                type: "string",
                hidden:true
            },
            {
                dataIndex: "ZD_ID",
                type: "string",
                hidden:true
            },
            {
                dataIndex: "ZQ_CODE",
                type: "string",
                text: "债券编码",
                width: 130
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                width: 250,
                text: "债券名称",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + ad_code;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1]=encodeURIComponent(ad_code);
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                dataIndex: "ZQQX_NAME",
                width: 100,
                type: "string",
                text: "债券期限"
            },
            {
                dataIndex: "ZQLB_NAME",
                type: "string",
                text: "债券类型",
                width: 130
            },
            {
                dataIndex: "FX_AMT",
                width: 150,
                type: "float",
                text: "债券金额(元)"
            },
            {
                dataIndex: "ZD_DATE",
                width: 100,
                type: "string",
                text: "转贷日期"
            },
            {
                dataIndex: "START_DATE",
                width: 100,
                type: "string",
                text: "起息日期"
            },
            {
                dataIndex: "ZJHB_DATE",
                width: 100,
                type: "string",
                text: "资金划拨日期"
            },
            {
                dataIndex: "ZD_ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT",
                width: 150,
                type: "float",
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                text: "承担本金(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT",
                width: 170,
                type: "float",
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                text: "承担利息本金金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_XZ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_HB_AMT",
                width: 150,
                type: "float",
                text: "再融资债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "TQHK_DAYS",
                width: 150,
                type: "int",
                text: "提前还款付息天数"
            },
            {
                dataIndex: "IS_QR",
                width: 150,
                type: "string",
                text: "是否被确认",
                hidden: true
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
                IS_CONFIRM_BYGK:IS_CONFIRM_BYGK,
                WF_STATUS: WF_STATUS,
                AD_CODE:ad_code,
                SET_YEAR: ''
            },
            dataUrl: 'getZdFsMainGridData.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common.store['WF_STATUS'],
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
                            toolbar.add(zdhk_json_common.items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                    displayField: "name",
                    valueField: "id",
                    value: '',
                    fieldLabel: '年度',
                    editable: false, //禁用编辑
                    labelWidth: 40,
                    width: 150,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            reloadGrid();
                        }
                    }
                },
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
                            reloadGrid();
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
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
                dataIndex: "ZD_DETAIL_NO",
                type: "string",
                text: "转贷明细编码",
                width: 150,
                hidden: true
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                width: 250,
                text: "转贷区域"
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT",
                width: 150,
                type: "float",
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                text: "承担本金(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT",
                width: 170,
                type: "float",
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                text: "承担利息本金金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XZ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HB_AMT",
                width: 150,
                type: "float",
                text: "再融资债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZDXY_NO",
                width: 150,
                type: "string",
                text: "转贷协议号"
            },
            {
                dataIndex: "REMARK",
                width: 150,
                type: "string",
                text: "备注"
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
            dataUrl: 'getZdFsDtlGridData.action'
        };
        var grid = simplyGrid.create(config);
        return grid;
    }
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        if (!(SYS_IS_QEHBFX==0)) {
            var items = Ext.ComponentQuery.query('#contentPanel_toolbar')[0].items.items;
            Ext.each(items, function (item) {
                if (item.text == '模板下载') {
                    item.hide();
                }
            });
        }
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();

        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
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
                store_details.loadPage(1);
            } else {
                store_details.removeAll();
            }
        }
    }
    //创建转贷信息选择弹出窗口
    var window_select = {
        window: null,
        show: function (params) {
            this.window = initWindow_input(params);
            this.window.show();
        }
    };
    /**
     * 初始化债券转贷弹出窗口
     */
    function initWindow_input(params) {
        return Ext.create('Ext.window.Window', {
            title: '债券转贷', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: initWindow_input_contentForm(),
            buttons: [
                {
                    text: '保存',
                    handler: function (btn) {
                        //获取grid
                        var grid = btn.up('window').down('#zqzd_grid');
                        //先校验后保存
                        if (window.flag_zzqZd_validateedit && !window.flag_zzqZd_validateedit.isHidden()) {
                            return false;//如果校验未通过
                        }
                        var form = btn.up('window').down('form') ;
                        var data = form.down('grid').getStore().getData() ;
                        var parameters = {
                            zq_code: window_select.zq_code,
                            button_name: button_name,
                            zd_id:data.items[0].data.ZD_ID,
                            userCode:userAdCode
                        };
                        if (form.isValid()) {
                            Ext.MessageBox.wait('正在保存登记信息..', '请等待..');
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveZdFsGrid.action',
                                params: parameters,
                                success: function (form, action) {
                                    Ext.MessageBox.hide();
                                    //关闭弹出框
                                    btn.up("window").close();
                                    //提示保存成功
                                    Ext.toast({
                                        html: '<div style="text-align: center;">登记成功!</div>',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    Ext.MessageBox.hide();
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
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }
    /**
     * 初始化债券转贷表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            fileUpload: true,
            padding: '2 5 0 5',
            border: false,
            defaults: {
                width: '100%'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
//                            disabled:true,
                        readOnly: true,
                        labelWidth: 140//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            fieldLabel: '债券ID',
                            disabled: false,
                            name: "ZQ_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "displayfield",
                            fieldLabel: '债券名称',
                            name: "ZQ_NAME",
                            tdCls: 'grid-cell-unedit',
                            columnWidth: 1
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_AMT",
                            fieldLabel: '剩余可转贷金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_XZ_AMT",
                            fieldLabel: '其中新增债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_ZH_AMT",
                            fieldLabel: '其中置换债券金额',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_CDBJ_AMT",
                            fieldLabel: '剩余承担本金金额',
                            plugins: {ptype: 'fieldStylePlugin'},
                            decimalPrecision: 6,
                            hideTrigger: true,
                            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_CDLX_AMT",
                            fieldLabel: '剩余承担利息本金金额',
                            plugins: {ptype: 'fieldStylePlugin'},
                            decimalPrecision: 6,
                            hideTrigger: true,
                            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "datefield",
                            name: "ZJHB_DATE",
                            fieldLabel: '<span class="required">✶</span>资金划拨日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择转贷日期',
                            value: new Date(),
                            readOnly: false
                        },
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    margin: '2 0 2 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
                        labelWidth: 140,//控件默认标签宽度
                        allowBlank: true
                    },
                    items: [
                        {
                            xtype: "datefield",
                            name: "ZD_DATE",
                            fieldLabel: '<span class="required">✶</span>转贷日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择转贷日期',
                            value: new Date(),
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "datefield",
                            name: "START_DATE",
                            fieldLabel: '<span class="required">✶</span>起息日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择起息日期',
                            value: DF_START_DATE_TEMP,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberfield",
                            name: "TQHK_DAYS_P",
                            fieldLabel: '提前还款天数(校验)',
                            hidden: true
                        },
                        {
                            xtype: "numberfield",
                            name: "TQHK_DAYS",
                            fieldLabel: '提前还款天数',
                            minValue: 0,
                            maxValue: 99,
                            allowDecimals: false,
                            hideTrigger: true,
                            allowBlank: false,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZNJ_RATE",
                            fieldLabel: '滞纳金率(万分之)',
                            emptyText: '0.000000',
                            minValue: 0,
                            allowDecimals: true,
                            allowBlank: false,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6',
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_ZD_AMT",
                            fieldLabel: '<span class="required">✶</span>转贷总金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            allowBlank: false,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6',
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_amt = me.up('form').down('numberFieldFormat[name="SY_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_AMT"]').setValue(sy_amt - cha);
                                }
                            }

                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_XZ_AMT",
                            fieldLabel: '其中新增债券金额',
                            emptyText: '0.00',
                            decimalPrecision: 6,
                            hideTrigger: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6',
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_xz_amt = me.up('form').down('numberFieldFormat[name="SY_XZ_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_XZ_AMT"]').setValue(sy_xz_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_ZH_AMT",
                            fieldLabel: '置换债券金额',
                            emptyText: '0.00',
                            decimalPrecision: 6,
                            hideTrigger: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            // disabled: true,
                            fieldStyle: 'background:#E6E6E6',
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_zh_amt = me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').setValue(sy_zh_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_HB_AMT",
                            fieldLabel: '再融资债券金额',
                            emptyText: '0.00',
                            decimalPrecision: 6,
                            hideTrigger: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            // disabled: true,
                            fieldStyle: 'background:#E6E6E6',
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_zh_amt = me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').setValue(sy_zh_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "CDBJ_AMT",
                            fieldLabel: '承担本金额金额',
                            editable: false,
                            decimalPrecision: 6,
                            hideTrigger: true/* ,
                            hidden: true */,
                            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            fieldStyle: 'background:#E6E6E6',
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_cdbj_amt = me.up('form').down('numberFieldFormat[name="SY_CDBJ_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_CDBJ_AMT"]').setValue(sy_cdbj_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "CDLX_AMT",
                            fieldLabel: '承担利息本金金额',
                            decimalPrecision: 6,
                            editable: false,
                            hideTrigger: true/* ,
                            hidden: true */,
                            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            fieldStyle: 'background:#E6E6E6',
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_cdlx_amt = me.up('form').down('numberFieldFormat[name="SY_CDLX_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_CDLX_AMT"]').setValue(sy_cdlx_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "checkbox",
                            name: "is_ftdff",
                            fieldLabel: "是否分摊兑付费:",
                            inputValue: true,
                            columnWidth: .23,
                            checked: IS_FTDFF_CHECKED == 1 ? true : false,
                            width: 138,
                            margin: '2 5 2 5',
                            labelWidth: 140,
                            boxLabelAlign: 'before'
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '转贷明细',
                    flex: 1,
                    layout: 'fit',
                    items: [initWindow_input_contentForm_grid()]
                }
            ]
        });
    }
    /**
     * 初始化债券转贷表单中转贷明细信息表格
     */
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer',
                width: 33
            },
            {dataIndex: "IS_READY", type: "string", text: "IS_READY", width: 150, hidden: true},//, hidden: true
            {dataIndex: "IS_IMPORT", type: "string", text: "IS_IMPORT", width: 150, hidden: true},//, hidden: true
            {dataIndex: "AD_NAME", type: "string", text: "转贷区域", width: 250},//, hidden: true
            {dataIndex: "AD_CODE", type: "string", text: "转贷区域", width: 200, hidden: true},
            {
                dataIndex: "IS_QEHBFX", type: "string", text: "是否全额还本付息", width: 150,
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                renderer: function (value) {
                    var record = DebtEleStore(json_debt_sf).findRecord('id', value, 0, false, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: "ZD_AMT", type: "float", text: "转贷金额(元)", width: 160,
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT", type: "float", text: "需承担本金金额", width: 160,
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT", type: "float", text: "需承担利息本金金额", width: 160,
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                readOnly:true,
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XZ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZH_AMT", type: "float", text: "置换债券金额(元)", width: 160,
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HB_AMT", type: "float", text: "再融资债券金额(元)", width: 160,
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150},
            {dataIndex: "REMARK", type: "string", text: "备注", width: 150}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'zqzd_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            dataUrl: 'getPcjhGridData.action',
            border: true,
            flex: 1,
            height: '100%',
            width: '100%',
            plugins: [],
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        if (records.length != 1) {
            Ext.MessageBox.alert('提示', '请选择一条数据后进行操作');
            return;
        }
        button_name = btn.text;
        if (button_name == '登记') {
            //修改全局变量的值
            button_name = btn.text;
            window_select.zq_code = records[0].get('ZQ_CODE');
            //发送ajax请求，查询主表和明细表数据
            $.post("/getZqxxByZdId.action", {
                ZD_ID: records[0].get('ZD_ID'),
                button_name:button_name
            }, function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    return;
                }
                DF_START_DATE_TEMP = new Date(data.data.QX_DATE) ;
                DF_END_DATE_TEMP = new Date(data.data.DQDF_DATE) ;
                //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                window_select.show();
                var form = window_select.window.down('form');
                form.down('checkbox[name="is_ftdff"]').setValue(data.data.IS_FTDFF == 1);
                form.down('checkbox[name="is_ftdff"]').setReadOnly(data.data.ONLYTHIS > 1);
                form.getForm().setValues(data.data);
                var min_value=new Date(data.data.ZD_DATE);
                form.getForm().findField('ZJHB_DATE').minValue = min_value ;
                form.getForm().findField('ZJHB_DATE').setValue(min_value) ;
                form.down('grid#zqzd_grid').insertData(0, data.list);
                reloadGrid() ;
            }, "json");
        } else {
            initWindow_opinion({
                title: btn.text,
                animateTarget: btn,
                value: '同意',
                fn: function(buttonId, text){
                    if (buttonId === 'ok') {
                        window_select.zq_code = records[0].get('ZQ_CODE');
                        //发送ajax请求，查询主表和明细表数据
                        $.post("/updateZdFsGrid.action", {
                            ZD_ID: records[0].get('ZD_ID'),
                            button_name:button_name,
                            userCode:userAdCode,
                            audit_info:text
                        }, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            }else{
                                Ext.MessageBox.alert('提示', button_name + '成功！');
                            }
                            reloadGrid() ;
                        },"json");
                    }
                }
            }) ;
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
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("ZD_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
    /**
     * 通用函数：获取url中的参数
     */
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }
</script>
</body>
</html>
