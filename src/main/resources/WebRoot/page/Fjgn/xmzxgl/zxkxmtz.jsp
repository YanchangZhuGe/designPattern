<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>执行库项目调整</title>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">

</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
<script type="text/javascript">
    var ad_code = '${sessionScope.ADCODE}';  // 获取地区名称
    if ('00' == ad_code.substring(ad_code.length - 2)) {
        ad_code = ad_code.substr(0, ad_code.length - 2);
    }
    // 获取系统参数
    var sh_hidden = ad_code == '${fns:getSysParam("ELE_AD_CODE")}' ? false : true;
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    // 获取URL参数
    var wf_id = "${fns:getParamValue('wf_id')}"; // 当前工作流流程id
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}';
    var node_code = "${fns:getParamValue('node_code')}"; // 当前工作流节点id
    var node_type = "${fns:getParamValue('node_type')}"; // 当前节点名称
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    // 自定义参数
    var button_name = ''; // 当前操作按钮名称id
    var button_text = ''; // 当前操作按钮名称text
    var xmsel_id = '';  // 选择需要调整项目的ID
    var nowDate = '';  // 当前日期
    var zxkxmtz_toolbar_json = {
        lr: { //录入
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
                        name: 'INPUT',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.name;
                            button_text = btn.text;
                            window_zxkxmtz_XmSelect(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                button_name = btn.name;
                                button_text = btn.text;
                                initWindow_xmtztb(btn);
                                var xmzxFormRecords = records[0].getData();
                                nowDate = records[0].getData().SET_YEAR;
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_xmtz_form"]')[0];
                                xmtztbForm.getForm().setValues(xmzxFormRecords);
                                DSYGrid.getGrid('item_XmtzDetil_grid').getStore().getProxy().extraParams['XMTZ_BILL_ID'] = records[0].getData().XMTZ_BILL_ID;
                                DSYGrid.getGrid('item_XmtzDetil_grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delXmtzMainGrid(btn);
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
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                button_name = btn.name;
                                button_text = btn.text;
                                initWindow_xmtztb(btn);
                                var xmzxFormRecords = records[0].getData();
                                nowDate = records[0].getData().SET_YEAR;
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_xmtz_form"]')[0];
                                xmtztbForm.getForm().setValues(xmzxFormRecords);
                                DSYGrid.getGrid('item_XmtzDetil_grid').getStore().getProxy().extraParams['XMTZ_BILL_ID'] = records[0].getData().XMTZ_BILL_ID;
                                DSYGrid.getGrid('item_XmtzDetil_grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delXmtzMainGrid(btn);
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
                    initButton_Screen()
                ],
                '008': [
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
        },
        sh: {//审核
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
                        hidden: sh_hidden,
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '退回',
                        name: 'up',
                        hidden: sh_hidden,
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
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销审核',
                        name: 'cancel',
                        hidden: true,
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
                ]
            }
        }
    };

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        initContent();
    });

    /**
     * 初始化主面板
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zxkxmtz_toolbar_json[node_type].items[WF_STATUS]
                }
            ],
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            items: [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: (node_type == 'sh' && !sh_hidden) ? 0 : 1  //区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
        });
    }

    /**
     * 初始化右侧panel
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'contentFormPanel',
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'padding:0 0 0 0',
                    defaults: {
                        margin: '1 1 2 5',
                        width: 200,
                        labelWidth: 80,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
                        {
                            xtype: 'combobox',
                            fieldLabel: '状态',
                            name: 'WF_STATUS',
                            store: node_type == 'lr' ? DebtEleStore(json_debt_zt1) : DebtEleStore(json_debt_zt2_3),
                            width: 110,
                            labelWidth: 30,
                            editable: false,
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
                                    toolbar.add(zxkxmtz_toolbar_json[node_type].items[WF_STATUS]);
                                    //刷新当前表格
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "MHCX",
                            labelWidth: 80,
                            width: 300,
                            emptyText: '请输入项目名称/债券名称...',
                            enableKeyEvents: true,
                            listeners: {
                                'keydown': function (self, e, eOpts) {
                                    var key = e.getKey();
                                    if (key == Ext.EventObject.ENTER) {
                                        reloadGrid();
                                    }
                                }
                            }
                        }
                    ]
                }
            ],
            border: false,
            items: [
                initContentGrid(),
                initContentDtlGrid()
            ]
        });
    }

    /**
     * 初始化右侧Panel主表格
     */
    function initContentGrid() {
        var contentHeaderJson = [
            {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
            {
                dataIndex: "XMTZ_BILL_ID",
                width: 80,
                type: "string",
                text: "ID",
                hidden: true
            },
            {
                dataIndex: "BILL_AD_CODE",
                type: "string",
                text: "编码",
                width: 100,
                hidden: true
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                text: "区划",
                width: 100
            },
            {
                dataIndex: "TZ_REASON",
                type: "string",
                text: "调整原因",
                width: 200
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                text: "项目单位",
                width: 250
            },
            {
                dataIndex: "XM_CODE",
                type: "string",
                text: "项目编码",
                width: 150
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                text: "项目名称",
                width: 300,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]='IS_RZXM';

                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                dataIndex: "XMLX_NAME",
                type: "string",
                text: "项目类型",
                width: 150
            },
            {
                dataIndex: "FX_AMT", width: 200, type: "float", text: "发行金额（万元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                text: "债券名称",
                width: 300,
                renderer: function (data, cell, record) {
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('FIRST_ZQ_ID');
                    paramValues[1]=record.get('AD_CODE');
                    var result= data; /*'<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>'*/
                    return result;
                }
            },
            {
                dataIndex: "ZQ_CODE",
                type: "string",
                text: "债券编码",
                width: 150
            },
            {
                dataIndex: "ZQLX_NAME",
                type: "string",
                text: "债券类型",
                width: 150
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'contentGrid',
            flex: 1,
            autoLoad: true,
            border: false,
            checkBox: true,
            headerConfig: {
                headerJson: contentHeaderJson,
                columnAutoWidth: false
            },
            dataUrl: 'getXmtzMainInfo.action',
            params: {
                AG_ID: AG_ID,
                AD_CODE: AD_CODE,
                wf_id: wf_id,
                node_code: node_code,
                node_type: node_type,
                button_name: button_name,
                WF_STATUS: WF_STATUS
            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            },
            listeners: {
                itemclick: function (self, record) {
                    DSYGrid.getGrid('contentDtlGrid').getStore().getProxy().extraParams['XMTZ_BILL_ID'] = record.get('XMTZ_BILL_ID');
                    DSYGrid.getGrid('contentDtlGrid').getStore().loadPage(1);
                }
            }
        });
        return grid;
    }

    /**
     * 初始化右侧Panel明细表格
     */
    function initContentDtlGrid() {
        var contentDtlHeaderJson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "AD_CODE",
                type: "string",
                text: "区划编码",
                width: 150,
                hidden: true
            },
            {dataIndex: "AD_NAME",
                type: "string",
                text: "区划",
                width: 150
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                text: "项目单位",
                width: 250
            },
            {
                dataIndex: "XM_CODE",
                type: "string",
                text: "项目编码",
                width: 150
            },
            {
                text: "项目名称", dataIndex: "XM_NAME", width: 300, type: "string",
                renderer: function (data, cell, record) {
                    return '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('BILL_ID') + '\')">' + data + '</a>';
                }
            },
            {
                dataIndex: "XMLX_NAME",
                type: "string",
                text: "项目类型",
                width: 150
            },
            {
                dataIndex: "TZ_AMT", width: 200, type: "float", text: "调整金额（万元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'contentDtlGrid',
            flex: 1,
            headerConfig: {
                headerJson: contentDtlHeaderJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: '/getXmtzDtlInfo.action',
            autoLoad: false,
            checkBox: true,
            border: false,
            height: '100%',
            tbarHeight: 50,
            pageConfig: {
                enablePage: false
            }
        });
    }

    /**
     *  获取已进行债券注册且终审的项目信息
     */
    function window_zxkxmtz_XmSelect(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '执行库调整项目选择', // 窗口标题
            itemId: 'item_xmSelect_windows', // 窗口标识
            layout: 'fit',
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            maximizable: true,
            buttonAlign: 'right', // 按钮显示的位置
            closeAction: 'destroy',
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            items: [init_zxkXmtz_Grid(btn)],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('item_xmSelect_grid').getSelection();
                        if (records.length < 1) {     //未选择项目
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            initWindow_xmtztb(btn);
                            var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_xmtz_form"]')[0];
                            var xmtzFormRecords = records[0].getData();
                            var xmtz_bill_id = GUID.createGUID();
                            xmtzFormRecords.XMTZ_BILL_ID = xmtz_bill_id;
                            nowDate = xmtzFormRecords.SET_YEAR;
                            xmsel_id = xmtzFormRecords.XM_ID;
                            xmtztbForm.getForm().setValues(xmtzFormRecords);
                            btn.up('window').close();
                        }
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
        window.show();
        return window;
    }

    // 可进行调整的项目信息
    function init_zxkXmtz_Grid() {
        var itemIdGrid = 'item_xmSelect_grid';
        var zxkXmtz_Grid_headerjson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "XM_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
            {dataIndex: "AD_CODE", width: 150, type: "string", text: "区划编码", hidden:true},
            {dataIndex: "AD_NAME", width: 150, type: "string", text: "区划"},
            {dataIndex: "AG_NAME", width: 250, type: "string", text: "项目单位"},
            {dataIndex: "ZQ_CODE", width: 150, type: "string", text: "债券编码"},
            {dataIndex: "ZQ_NAME", width: 300, type: "string", text: "债券名称",
               /* renderer: function (data, cell, record) {
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('FIRST_ZQ_ID');
                    paramValues[1]=record.get('AD_CODE');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }*/
            },
            {dataIndex: "ZQLX_NAME", width: 100, type: "string", text: "债券类型"},
            {dataIndex: "XM_NAME", width: 300, type: "string", text: "项目名称",
                renderer: function (data, cell, record) {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]='IS_RZXM';

                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
            {dataIndex: "XMLX_NAME", width: 150, type: "string", text: "项目类型"},
            {
                dataIndex: "FX_AMT", width: 150, type: "float", text: "发行金额（万元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'item_xmSelect_grid',
            flex: 1,
            autoLoad: true,
            border: false,
            checkBox: true,
            headerConfig: {
                headerJson: zxkXmtz_Grid_headerjson,
                columnAutoWidth: false
            },
            dataUrl: 'getZxkXmtzInfo.action',
            params: {
                AG_ID: AG_ID,
                AD_CODE: AD_CODE,
                ADCODE: AD_CODE,
            },
            tbar: [
                {
                    xtype: "textfield",
                    fieldLabel: '模糊查询',
                    itemId: "XM_SEARCH",
                    labelWidth: 80,
                    width: 300,
                    emptyText: '请输入项目名称/债券名称...',
                    enableKeyEvents: true,
                    listeners: {
                        'keydown': function (self, e, eOpts) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reloadZxtzxmGrid(itemIdGrid);
                            }
                        }
                    }
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '申报批次',
                    name: 'SB_BATCH_NO',
                    displayField: 'name',
                    valueField: 'id',
                    editable: false,
                    store: DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND2 IS NULL OR EXTEND2 = '1') "}),
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            reloadZxtzxmGrid(itemIdGrid);
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadZxtzxmGrid(itemIdGrid);
                    }
                }
            ],
            selModel: {
                mode: "SINGLE"
            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            }
        });
        return grid;
    }

    /**
     * 项目调整信息录入框
     * */
    function initWindow_xmtztb(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '执行库项目调整',
            itemId: 'item_xmtztb_window',
            layout: 'fit',
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 添加
            frame: true,
            constrain: true, // 防止超出浏览器边界
            buttonAlign: "right", // 按钮显示的位置：右下侧
            maximizable: true,//最大化按钮
            modal: true,//模态窗口
            resizable: true,//可拖动改变窗口大小
            defaults: {
                split: true,                 //是否有确认线
                collapsible: false           //是否可以折叠
            },
            closeAction: 'destroy',
            items: [initWiondow_xmtzForm()],
            buttons: [
                {
                    text: '新增',
                    id: 'addBtn',
                    name: 'addBtn',
                    handler: function (btn) {
                        window_zxkxmtz_insert(btn)
                    }
                },
                {
                    text: '删除',
                    id: 'delBtn',
                    name: 'delBtn',
                    handler: function (btn) {
                        var grid = DSYGrid.getGrid('item_XmtzDetil_grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel().getSelection();
                        if (sm.length < 1) {
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            grid.getView().refresh();
                            store.remove(sm);
                        }
                    }
                },
                {
                    text: '保存',
                    name: 'save',
                    handler: function (btn) {
                        submitZxktztb(btn);
                    }
                },
                {
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        window.show();
        return window;
    }

    function initWiondow_xmtzForm() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'item_xmtz_form',
            width: '100%',
            height: '100%',
            layout: 'vbox',
            fileUpload: true,
            padding: '2 5 0 5',
            defaults: {
                columnWidth: .33,//输入框的长度（百分比）
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
                        labelWidth: 100//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            name: "XMTZ_BILL_ID",
                            fieldLabel: '虚拟主单id',
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            name: "ZQXM_ID",
                            fieldLabel: '项目ID',
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            name: "AD_NAME",
                            fieldLabel: '区划',
                            allowBlank: false,
                            allowDecimals: true,
                            decimalPrecision: 2,
                            fieldStyle: 'background:#E6E6E6',
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "ZQ_NAME",
                            fieldLabel: '债券名称',
                            allowDecimals: true,
                            fieldStyle: 'background:#E6E6E6',
                            decimalPrecision: 2,
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "AG_NAME",
                            fieldLabel: '项目单位',
                            fieldStyle: 'background:#E6E6E6',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "XM_CODE",
                            fieldLabel: '项目编码',
                            fieldStyle: 'background:#E6E6E6',
                            allowBlank: false,
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "XM_NAME",
                            fieldLabel: '项目名称',
                            fieldStyle: 'background:#E6E6E6',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "FX_AMT",
                            fieldLabel: '发行金额（万元）',
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            readOnly: true,
                            decimalPrecision: 6,
                            emptyText: '0.000000',
                            allowDecimals: true,
                            hideTrigger: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZC_AMT",
                            fieldLabel: '已支出金额（万元）',
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            readOnly: true,
                            decimalPrecision: 6,
                            emptyText: '0.000000',
                            allowDecimals: true,
                            hideTrigger: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SYTZ_AMT",
                            fieldLabel: '可调整金额（万元）',
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            readOnly: true,
                            decimalPrecision: 6,
                            emptyText: '0.000000',
                            allowDecimals: true,
                            hideTrigger: true
                        },
                        {
                            xtype: 'textfield',
                            name: 'TZ_REASON',
                            fieldLabel: '<span class="required">✶</span>调整原因',
                            allowBlank: false,
                            columnWidth: .999,
                            maxLength:500,//限制输入字数
                            maxLengthText:"输入内容过长，最多只能输入500个汉字！"

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
                    flex: 1,
                    collapsible: false,
                    layout: 'fit',
                    items: [
                        initXmtzDetilGrid()
                    ]
                }
            ]
        });
    }

    function initXmtzDetilGrid() {
        var zxkXmtz_headerjson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "XMTZ_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
            {dataIndex: "AD_CODE", width: 150, type: "string", text: "区划编码",hidden: true},
            {dataIndex: "AD_NAME", width: 150, type: "string", text: "区划"},
            {dataIndex: "AG_NAME", width: 250, type: "string", text: "项目单位"},
            {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
            {dataIndex: "XM_NAME", width: 300, type: "string", text: "项目名称",
                renderer: function (data, cell, record) {
                    return '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('BILL_ID') + '\')">' + data + '</a>';
                }
            },
            {dataIndex: "XMLX_NAME", width: 150, type: "string", text: "项目类型"},
            {
                dataIndex: "TZ_AMT", type: "float", text: "调整金额（万元）", width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    hideTrigger: true,
                    decimalPrecision:6,
                    emptyText: '0.00',
                    allowBlank: false
                },
                renderer:function(value){
                    return Ext.util.Format.number(value,'0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'item_XmtzDetil_grid',
            flex: 1,
            headerConfig: {
                headerJson: zxkXmtz_headerjson,
                columnAutoWidth: false
            },
            autoLoad: true,
            checkBox: true,
            border: false,
            scrollable: true,
            height: '100%',
            pageConfig: {
                enablePage: false,
                pageNum: false
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: '/getXmtzDtlInfo.action',
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'wzzd_grid_plugin_cell2',
                    clicksToMoveEditor: 1
                }
            ]
        });
        return grid;
    }

    /**
     * 提交数据
     */
    function submitZxktztb(btn) {
        //获取实际收益情况表单
        var zxkXmtzWindow = Ext.ComponentQuery.query('window#item_xmtztb_window')[0];
        var zxkxmtzForm = zxkXmtzWindow.down('form');
        var zxxmtzGridStore = zxkxmtzForm.down('grid').getStore();
        if (!zxkxmtzForm.isValid()) {
            Ext.toast({
                html: "请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
        if (zxxmtzGridStore.getCount() <= 0) {
            Ext.Msg.alert('提示', "项目调整至少有一条明细");
            return false;
        }
        for(var i=0;i<zxxmtzGridStore.getCount();i++){
            var zxxmtzGrid = zxxmtzGridStore.getAt(i);
            if(zxxmtzGrid.get('TZ_AMT')<= 0){
                Ext.Msg.alert('提示', "项目调整金额必须大于0");
                return;
            }
        }
        if (zxxmtzGridStore.sum('TZ_AMT') > zxkxmtzForm.down('numberFieldFormat[name="SYTZ_AMT"]').getValue()) {
            Ext.Msg.alert('提示', "项目调整金额不能大于可调整金额");
            return false;
        }
        var zxxmtzGrid = [];
        zxxmtzGridStore.each(function (record) {
            zxxmtzGrid.push(record.getData());
        });
        btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
        $.post('/saveZxkxmInfo.action', {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            button_text: button_text,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            AG_CODE: AG_CODE,
            WF_STATUS: WF_STATUS,
            zxxmtzGrid: Ext.util.JSON.encode(zxxmtzGrid),
            zxkxmtzForm: Ext.util.JSON.encode([zxkxmtzForm.getValues()])
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                btn.up('window').close();
                // 刷新表格
                reloadGrid()
            } else {
                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                btn.setDisabled(false);
            }
            //刷新表格
        }, "json");
    }

    /**
     * 新增项目信息
     */
    function window_zxkxmtz_insert(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '项目选择', // 窗口标题
            itemId: 'item_addxm_window', // 窗口标识
            layout: 'fit',
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            maximizable: true,
            buttonAlign: 'right', // 按钮显示的位置
            closeAction: 'destroy',
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            items: [init_zxkXmtz_addGrid(btn)],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var addGrid = DSYGrid.getGrid('item_addxm_grid');
                        var sm = addGrid.getSelectionModel().getSelection();
                        if (sm.length < 1) {     //未选择项目
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            var dtlxmGrid = DSYGrid.getGrid('item_XmtzDetil_grid').getStore();
                            for (var i = 0; i < sm.length; i++) {
                                if (!XMhave(i)) {//判断已有的项目中是否已存在该id
                                    var xzzqData = sm[i];
                                    xzzqData.data.XMTZ_ID = GUID.createGUID();
                                    xzzqData.data.TZ_AMT = 0;
                                    dtlxmGrid.insertData(null, xzzqData);
                                } else {
                                    return Ext.toast({
                                        html: "已包含该项目，请选择其他项目!",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }


                            }
                            btn.up('window').close();
                        }
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
        window.show();
        return window;
    }

    /**
     * 判断项目中是否已含有选中项
     */
    function XMhave(i) {
        var have = false;
        var addGrid = DSYGrid.getGrid('item_addxm_grid');
        var dtlGrid = DSYGrid.getGrid('item_XmtzDetil_grid');
        if (addGrid == null || addGrid == undefined || dtlGrid == null || dtlGrid == undefined) {
            return true;
        }
        var addSel = addGrid.getSelection();
        for (var j = 0; j < dtlGrid.getStore().getCount(); j++) {
            if (addSel[i].data["BILL_ID"] == dtlGrid.getStore().getAt(j).data["BILL_ID"]) {
                return true;
            }
        }
        return have;
    }

    /**
     * 加载项目选择表格
     */
    function init_zxkXmtz_addGrid() {
        var itemIdGrid = 'item_addxm_grid';
        var zxkXmtz_Grid_headerjson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "BILL_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
            {dataIndex: "AD_CODE", width: 150, type: "string", text: "区划编码",hidden: true},
            {dataIndex: "AD_NAME", width: 150, type: "string", text: "区划"},
            {dataIndex: "AG_NAME", width: 250, type: "string", text: "项目单位"},
            {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
            {dataIndex: "XM_NAME", width: 300, type: "string", text: "项目名称",
                renderer: function (data, cell, record) {
                    return '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('BILL_ID') + '\')">' + data + '</a>';
                }
            },
            {dataIndex: "XMLX_NAME", width: 150, type: "string", text: "项目类型"},
            {
                dataIndex: "SQ_AMT", width: 180, type: "float", text: "申请金额（万元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {dataIndex: "SQLX_NAME", width: 150, type: "string", text: "申请类型"},
            {dataIndex: "SB_DATE", width: 100, type: "string", text: "申报日期"},
            {dataIndex: "APPLY_INPUTOR", width: 150, type: "string", text: "经办人"},
            {dataIndex: "LX_YEAR", width: 100, type: "string", text: "立项年度"},
            {dataIndex: "JSXZ_NAME", width: 100, type: "string", text: "建设性质"},
            {dataIndex: "XMXZ_NAME", width: 150, type: "string", text: "项目性质"},
            {
                dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {dataIndex: "BUILD_STATUS_NAME", width: 100, type: "string", text: "建设状态"}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'item_addxm_grid',
            flex: 1,
            height: '100%',
            border: false,
            checkBox: true,
            headerConfig: {
                headerJson: zxkXmtz_Grid_headerjson,
                columnAutoWidth: false
            },
            tbar: [
                {
                    xtype: "textfield",
                    fieldLabel: '模糊查询',
                    itemId: "XM_SEARCH",
                    labelWidth: 80,
                    width: 300,
                    emptyText: '请输入项目名称...',
                    enableKeyEvents: true,
                    listeners: {
                        'keydown': function (self, e, eOpts) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reloadTzxmGrid(itemIdGrid);
                            }
                        }
                    }
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '区划',
                    itemId: 'AD_CODE',
                    displayField: 'name',
                    valueField: 'code',
                    editable:false,
                    rootVisible: true,
                    lines: false,
                    labelWidth: 80,
                    width: 300,
                    selectModel: 'all',
                    labelAlign: 'right',
                    store: DebtEleTreeStoreDBTable("DSY_V_ELE_AD",{condition:" and code like '"+ad_code+"%' AND CODE NOT LIKE '%00'"}),
                    listeners: {
                        'keydown': function (self, e, eOpts) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reloadTzxmGrid(itemIdGrid);
                            }
                        },
                        change: function (self, newValue) {
                            reloadTzxmGrid(itemIdGrid);
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadTzxmGrid(itemIdGrid);
                    }
                }
            ],
            dataUrl: 'getXekXmInfo.action',
            params: {
                xm_id: xmsel_id,
                LX_YEAR: nowDate
            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            }
        });
        return grid;
    }

    //执行库项目选择框查询按钮实现
    function reloadZxtzxmGrid(itemIdGrid) {
        var xmSelectGrid = DSYGrid.getGrid('' + itemIdGrid + '');
        var xmSelectGridStore = xmSelectGrid.getStore();
        xmSelectGridStore.removeAll();
        var xm_search = xmSelectGrid.down('textfield[itemId="XM_SEARCH"]').getValue();
        var SB_BATCH_NO = Ext.ComponentQuery.query('treecombobox[name=SB_BATCH_NO]')[0].getValue();
        xmSelectGridStore.getProxy().extraParams = {
            xm_id: xmsel_id,
            LX_YEAR: nowDate,
            XM_SEARCH: xm_search,
            SB_BATCH_NO:SB_BATCH_NO
        };
        xmSelectGridStore.loadPage(1);
    }

    function reloadTzxmGrid(itemIdGrid) {
        var xmSelectGrid = DSYGrid.getGrid('' + itemIdGrid + '');
        var xmSelectGridStore = xmSelectGrid.getStore();
        xmSelectGridStore.removeAll();
        var xm_search = xmSelectGrid.down('textfield[itemId="XM_SEARCH"]').getValue();
        var AD_CODE = xmSelectGrid.down('treecombobox[itemId="AD_CODE"]').getValue();
        xmSelectGridStore.getProxy().extraParams = {
            xm_id: xmsel_id,
            LX_YEAR: nowDate,
            XM_SEARCH: xm_search,
            QH: AD_CODE
        };
        xmSelectGridStore.loadPage(1);
    }

    /**
     * 删除主表格信息
     */
    function delXmtzMainGrid(btn) {
        // 检验是否选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                var ids = new Array();
                var btn_text = btn.text;
                for (var k = 0; k < records.length; k++) {
                    var xmtz_bill_id = records[k].get("XMTZ_BILL_ID");
                    ids.push(xmtz_bill_id);
                }

                $.post("delXmtzSbInfo.action", {
                    ids: Ext.util.JSON.encode(ids)
                }, function (data_response) {
                    data_response = $.parseJSON(data_response);
                    if (data_response.success) {
                        Ext.toast({
                            html: btn_text + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        reloadGrid();
                    } else {
                        Ext.toast({
                            html: btn_text + "失败！" + data_response.message,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                });
            }
        });
    }

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("XMTZ_BILL_ID"));
        }
        button_name = btn.name;
        button_text = btn.text;
        if (btn.text == '送审' || btn.text == '撤销送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("doXmtzSbWorkFlow.action", {
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
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            if(btn.text == '审核'){
                $.post('/checkXmtz.action', {
                    button_text: button_text,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids:ids,
                    WF_STATUS: WF_STATUS
                }, function (data) {
                    for(var i = 0;i < data.list.length;i++){
                        if(data.list[i].SYTZ_AMT < data.mxList[i].TZ_AMT){
                            Ext.MessageBox.alert('提示','项目调整金额不能大于可调整金额！');
                            return ;
                        }
                    }
                }, "json");
            }
            Ext.Msg.confirm('提示', '请确认是否' + button_text + '?', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //弹出意见填写对话框
                    initWindow_opinion({
                        title: btn.text + '意见',
                        value: btn.text == '审核' ? '同意' : '',
                        animateTarget: btn,
                        fn: function (buttonId, text) {
                            if (buttonId === 'ok') {
                                //发送ajax请求，修改节点信息
                                $.post("doXmtzSbWorkFlow.action", {
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
                                    reloadGrid();
                                }, "json");
                            }
                        }
                    });
                }
            })
        }
    };

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
     *  刷新主面板
     */
    function reloadGrid() {
        var gridStore = DSYGrid.getGrid('contentGrid').getStore();
        gridStore.removeAll();
        var xm_search = Ext.ComponentQuery.query('textfield[itemId="MHCX"]')[0].getValue();
        gridStore.getProxy().extraParams = {
            AG_ID: AG_ID,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            wf_id: wf_id,
            node_code: node_code,
            node_type: node_type,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            xm_search: xm_search
        };
        //刷新
        gridStore.loadPage(1);
        //刷新明细表
        DSYGrid.getGrid('contentDtlGrid').getStore().removeAll();
    }

    /**
     * 操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var contentGrid_ID = records[0].get("XMTZ_BILL_ID");
            fuc_getWorkFlowLog(contentGrid_ID);
        }
    }

</script>
</body>
</html>
