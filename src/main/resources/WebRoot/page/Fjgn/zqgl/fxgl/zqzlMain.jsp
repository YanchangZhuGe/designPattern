<!-- 债券总览功能界面 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>债券情况总览</title>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;"></div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script src="/page/plat/olap/js/olaputil.js" type="text/javascript"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");  // 获取用户名称
    var USERCODE = '${sessionScope.USERCODE}';  // 获取用户编码
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}';//获取省级区划
    var ZQ_ID = '';
    var ZQ_NAME = '';
    var unit = 1;
    var q_title = null;
    var hideType =true; //发行场所列显示或不显示：
    if(sysAdcode == '42'){
        //湖北个性化展示：展示发行场所列
        hideType=false;
    }
    //创建转贷信息选择弹出窗口
    var window_show_information = {
        window: null,
        show: function (params) {
            this.window = initWindow_show_information(params);
            this.window.show();
        }
    };
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
                    items: [{
                        xtype: 'button',
                        text: '查看',
                        hidden: true,
                        name: 'show_information',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                return;
                            }
                            ZQ_ID = records[0].get('ZQ_ID');
                            ZQ_NAME = records[0].get('ZQ_NAME');
                            load_information();
                        }
                    },
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
                                DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams['mhcx'] = mhcx;
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '导出',
                            name: 'up',
                            icon: '/image/sysbutton/export.png',
                            handler: function (btn) {
                                /* var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
                                 var year = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].value;
                                 var ZQLB_ID = Ext.ComponentQuery.query('combobox[name="ZQLB_ID"]')[0].value;
                                 var FXFS_NAME = Ext.ComponentQuery.query('combobox[name="FXFS_NAME"]')[0].value;
                                 var ZQQX_NAME = Ext.ComponentQuery.query('combobox[name="ZQQX_NAME"]')[0].value;
                                 var ZQLB_NAME = Ext.ComponentQuery.query('combobox[name="ZQLB_NAME"]')[0].value;
                                 DSYGrid.exportExcelClick('contentGrid', {
                                 exportExcel: true,
                                 url: 'exportExcel_zqzl.action',
                                 param: {
                                 SET_YEAR: year,
                                 ZQLB_ID: ZQLB_ID,
                                 mhcx: mhcx,
                                 FXFS_NAME: FXFS_NAME,
                                 ZQQX_NAME: ZQQX_NAME,
                                 ZQLB_NAME: ZQLB_NAME
                                 }
                                 });
                                 */
                                DSYGrid.exportExcelClick('contentGrid', {
                                    exportExcel: true,
                                    url: 'exportExcel_zqzl.action',
                                    param: {
                                        q_title: q_title
                                    }
                                });
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()]
                }
            ],
            items: [initContentGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 45, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "债券ID", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "债券编码", dataIndex: "ZQ_BMCODE", type: "string", width: 130},
            {text: "债券代码", dataIndex: "ZQ_CODE", type: "string", width: 130},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 250,
                renderer: function (data, cell, record) {//debugger;
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
            {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 130},
            {text: "发行日期", dataIndex: "FX_START_DATE", type: "string"},
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string"},
            {
                text: "债券金额", dataIndex: "PLAN_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "债券兑付日期", dataIndex: "DF_END_DATE", type: "string"},
            {text: "起息日", dataIndex: "QX_DATE", type: "string"},
            {text: "票面利率(%)", dataIndex: "PM_RATE", type: "string"},
            {text: "发行场所", dataIndex: "ZQTGR_NAME", width: 220, type: "string",hidden:hideType},

            {text: "发行方式", dataIndex: "FXFS_NAME", type: "string"},

            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string"},
            {
                text: "其中:新增债券", dataIndex: "PLAN_XZ_AMT", type: "float", width: 180, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            //{text: "付息频率", dataIndex: "FXZQ_ID", type: "string"},
            {text: "付息频率", dataIndex: "FXZQ_NAME", type: "string", width: 180},//20210813 chenfei 修改付息频率显示（为付息方式）
            {
                text: "其中:置换债券", dataIndex: "PLAN_ZH_AMT", type: "float", width: 180, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },{
                text: "其中:再融资债券", dataIndex: "PLAN_HB_AMT", type: "float", width: 180, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "转贷下级金额", dataIndex: "ZD_XJ_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "转贷本级金额", dataIndex: "SY_BJ_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "剩余转贷/可支出金额", dataIndex: "SY_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "已支出金额", dataIndex: "PAY_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "已偿还本金", dataIndex: "HKBJ_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "已偿还利息", dataIndex: "HKLX_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "发行手续费费率%", dataIndex: "FXSXF_RATE", width: 180, type: "float",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                }
            },
            {
                text: "登记托管费费率%", dataIndex: "TGSXF_RATE", width: 180, type: "float",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                }
            },
            {
                text: "兑付费费率%", dataIndex: "DFSXF_RATE", width: 180, type: "float",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000');
                }
            },
            {
                text: "发行手续费", dataIndex: "FXSXF_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "登记托管费", dataIndex: "TGSXF_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "年度", dataIndex: "SET_YEAR", type: "string"},
            {text: "备注", dataIndex: "REMARK", width: 180, type: "string"}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                SET_YEAR: new Date().getFullYear()
            },
            dataUrl: 'getZqzlZqxxGridData.action',
            checkBox: false,
            border: false,
            autoLoad: false,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            //height : '100%',
            features: [{
                ftype: 'summary'
            }],
            dockedItems: [
                {
                    xtype: 'form',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'border-width:0 0 0 0',
                    defaults: {
                        margin: '3 5 3 5',
                        width: 250,
                        //columnWidth: .20,
                        labelWidth: 100,//控件默认标签宽度
                        labelAlign: 'right'//控件默认标签对齐方式
                    },
                    items: [
                        {
                            xtype: "multicombobox",
                            name: "SET_YEAR",
                            store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                            displayField: "name",
                            valueField: "id",
                            value: new Date().getFullYear(),
                            fieldLabel: '年度',
                            editable: false, //禁用编辑
                            labelWidth: 40,
                            width: 180,
                            labelAlign: 'right'
//                            ,
//                            listeners: {
//                                change: function (self, newValue) {
//                                    //刷新当前表格
//                                    self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
//                                    reloadGrid();
//                                }
//                            }
                        },
                        {
                            xtype: 'combobox',
                            fieldLabel: '发行方式',
                            name: 'FXFS_ID',
                            displayField: 'name',
                            editable: false,
                            valueField: 'id',
                            width: 180,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            store: DebtEleStore(json_debt_fxfs),
                            listeners: {
                                change: function (self, newValue) {
                                    //刷新当前表格
                                    self.up('grid').getStore()
                                        .getProxy().extraParams[self
                                        .getName()] = newValue;
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
                                    self.up('grid').getStore()
                                        .getProxy().extraParams[self
                                        .getName()] = newValue;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            fieldLabel: '债券期限',
                            name: "ZQQX_ID",
                            store: DebtEleStoreDB("DEBT_ZQQX"),
                            displayField: "name",
                            valueField: "id",
                            rootVisible: false,
                            lines: false,
                            minPicekerWidth: '100%',
                            //labelWidth: 60,
                            labelAlign: 'right',
                            selectModel: 'all',
                            listeners: {
                                change: function (self, newValue) {
                                    //刷新当前表格
                                    self.up('grid').getStore()
                                        .getProxy().extraParams[self
                                        .getName()] = newValue;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: 'combobox',
                            fieldLabel: "债券类别",
                            name: "PLAN",
                            store: DebtEleStore(json_debt_xzorzh),
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: true,
                            lines: false,
                            editable: false, //禁用编辑
                            selectModel: 'leaf',
                            labelAlign: 'right',
                            value: 0,
                            listeners: {
                                change: function (self, newValue) {
                                    //刷新当前表格
                                    self.up('grid').getStore()
                                        .getProxy().extraParams[self
                                        .getName()] = newValue;
                                    reloadGrid();
                                }
                            }
                        },
                        /*{
                            xtype: "datefield",
                            fieldLabel: '开始时间',
                            format: 'Y-m-d',
                            name: 'sdate',
                            width: 180,
                            labelWidth: 60,
                            labelAlign: 'right'
                        },
                        {
                            xtype: "datefield",
                            fieldLabel: '结束时间',
                            format: 'Y-m-d',
                            name: 'edate',
                            width: 180,
                            labelWidth: 60,
                            labelAlign: 'right'
                        },*/
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: 'contentGrid_search',
                            width: 460,
                            labelWidth: 60,
                            labelAlign: 'right',
                            emptyText: '请输入债券名称/债券编码...',
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
            tbar: [
                {xtype: "label", text: "金额单位:", width: 65},
                {
                    xtype: 'form',
                    padding: '0 0 0 0',
                    width: 70,
                    layout: 'fit',
                    border: false,
                    items: [{
                        xtype: "combobox",
                        name: "unitSelect",
                        margin: '0 0 0 0',
                        store: unitStore,
                        queryMode: 'local',
                        editable: false,
                        allowBlank: false,
                        value: unit,
                        displayField: 'name',
                        valueField: 'abbr',
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                self.up('grid').getStore()
                                    .getProxy().extraParams[self
                                    .getName()] = newValue;
                                reloadGrid();
                            }
                        }
                    }]
                }
            ],
            listeners: {
                /*itemdblclick: function (self, record) {
                    ZQ_ID = record.get('ZQ_ID');
                    window.open('/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + ZQ_ID + '&AD_CODE=' + AD_CODE);
                    //load_information();
                }*/
            }
        });
    }
    /**
     * 初始化债券总览弹出窗口
     */
    function initWindow_show_information() {
        return Ext.create('Ext.window.Window', {
            itemId: 'window_zqxxtb', // 窗口标识
            name: 'xzzqWin',
            title: '债券总览', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            maximizable: true,//最大化按钮
            layout: 'fit',
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
            items: initWindow_show_informationForm_tab(),
            buttons: [{
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }]
        });
    }
    /**
     * 弹出窗口中的tabpanel
     */
    function initWindow_show_informationForm_tab() {
        var tab_hasShow = {};
        var information_tab_panel = Ext.create('Ext.tab.Panel', {
            height: '100%',
            width: '100%',
            border: false,
            items: [
                {
                    title: '基本情况',
                    scrollable: true,
                    items: initWindow_show_informationForm_tab_jbqk()
                },
                {
                    title: '本级支出',
                    layout: 'hbox',
                    items: initWindow_zqxxtb_contentForm_tab_bjzc()
                },
                {
                    title: '转贷支出',
                    layout: 'hbox',//布局为fit后， scrollable不能用
                    items: initWindow_zqxxtb_contentForm_tab_zdzc()
                },
                {
                    title: '下级还款信息',
                    layout: 'hbox',
                    items: initWindow_zqxxtb_contentForm_tab_zdshbx()
                },
                {
                    title: '应付本息',
                    layout: 'fit',
                    items: initWindow_zqxxtb_contentForm_tab_yfbx()
                },
                {
                    title: '实际还本',
                    layout: 'fit',
                    items: initWindow_zqxxtb_contentForm_tab_sjhb()
                },
                {
                    title: '实际付息',
                    layout: 'fit',
                    items: initWindow_zqxxtb_contentForm_tab_sjfx()
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                    switch (newCard.title) {
                        case '本级支出' :
                            if (typeof tab_hasShow['bjzc'] == 'undefined' || tab_hasShow['bjzc'] == null || !tab_hasShow['bjzc']) {
                                tab_hasShow['bjzc'] = true;
                                DSYGrid.getGrid('bjzcGrid').getStore().loadPage(1);
                            }
                            break;
                        case '转贷支出' :
                            if (typeof tab_hasShow['zdzc'] == 'undefined' || tab_hasShow['zdzc'] == null || !tab_hasShow['zdzc']) {
                                tab_hasShow['zdzc'] = true;
                                //发送请求获取当前地区的转贷收入 及 向下转贷支出
                                $.post("/getZqzlZdxxGrid.action", {
                                    ZQ_ID: ZQ_ID
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    var grid = DSYGrid.getGrid('zdzcGrid');
                                    if (AD_CODE.length == 2) {
                                        grid.addDocked({
                                            xtype: 'toolbar',
                                            layout: 'column',
                                            items: [
                                                {xtype: 'label', text: '债券名称:', width: 70},
                                                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5},
                                                {xtype: 'label', text: '债券金额(元):', width: 100},
                                                {
                                                    xtype: 'label',
                                                    text: Ext.util.Format.number(data.dataList[0].PLAN_AMT, '0,000.00'),
                                                    width: 200,
                                                    flex: 5
                                                }

                                            ]
                                        }, 0);
                                    } else if (AD_CODE.length == 4) {
                                        grid.addDocked({
                                            xtype: 'toolbar',
                                            layout: 'column',
                                            items: [
                                                {xtype: 'label', text: '债券名称:', width: 70},
                                                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5},
                                                {xtype: 'label', text: '  转贷收入(元):', width: 100},
                                                {
                                                    xtype: 'label',
                                                    text: Ext.util.Format.number(data.dataList[0].ZD_AMT, '0,000.00'),
                                                    width: 200,
                                                    flex: 5
                                                }
                                            ]
                                        }, 0);
                                    }
                                    grid.insertData(null, data.list);
                                }, "json");
                            }
                            break;
                        case '下级还款信息' :
                            if (typeof tab_hasShow['zdshbx'] == 'undefined' || tab_hasShow['zdshbx'] == null || !tab_hasShow['zdshbx']) {
                                tab_hasShow['zdshbx'] = true;
                                //发送请求获取当前地区的转贷收入 及 向下转贷支出
                                $.post("/getZqzlZdshbxGrid.action", {
                                    ZQ_ID: ZQ_ID
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    var grid = DSYGrid.getGrid('zdshbxGrid');
                                    grid.addDocked({
                                        xtype: 'toolbar',
                                        layout: 'column',
                                        items: [
                                            {xtype: 'label', text: '债券名称:', width: 70},
                                            {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5},
                                            {xtype: 'label', text: '  转贷总金额(元):', width: 120},
                                            {xtype: 'label', text: Ext.util.Format.number(data.dataList[0].ZD_AMT, '0,000.00'), width: 200, flex: 5}

                                        ]
                                    }, 0);
                                    grid.insertData(null, data.list);
                                }, "json");
                            }
                            break;
                        case '应付本息' :
                            if (typeof tab_hasShow['yfbx'] == 'undefined' || tab_hasShow['yfbx'] == null || !tab_hasShow['yfbx']) {
                                tab_hasShow['yfbx'] = true;
                                DSYGrid.getGrid('yfbxGrid').getStore().loadPage(1);
                            }
                            break;
                        case '实际还本' :
                            if (typeof tab_hasShow['sjhb'] == 'undefined' || tab_hasShow['sjhb'] == null || !tab_hasShow['sjhb']) {
                                tab_hasShow['sjhb'] = true;
                                DSYGrid.getGrid('sjhbGrid').getStore().loadPage(1);
                            }
                            break;
                        case '实际付息' :
                            if (typeof tab_hasShow['sjfx'] == 'undefined' || tab_hasShow['sjfx'] == null || !tab_hasShow['sjfx']) {
                                tab_hasShow['sjfx'] = true;
                                DSYGrid.getGrid('sjfxGrid').getStore().loadPage(1);
                            }
                            break;
                    }
                }
            }
        });
        if ((AD_CODE.length != 2 && AD_CODE.length != 4 ) || AD_CODE.endWith('00')) { //叶子节点地区
            information_tab_panel.tabBar.items.items[2].hide();
            information_tab_panel.tabBar.items.items[3].hide();
        }
        return information_tab_panel;
    }
    /**
     *基本情况页签
     */
    function initWindow_show_informationForm_tab_jbqk() {
        return Ext.create('Ext.form.Panel', {
            name: 'jbqkForm',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            border: false,
            defaults: {
                margin: '0 0 0 0',
                padding: '0 0 0 0',
                anchor: '100%'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'fieldcontainer',
                    border: false,
                    layout: 'anchor',
                    defaults: {
                        anchor: '100%',
                        margin: '0 0 0 0'
                    },
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            layout: 'column',
                            defaultType: 'textfield',
                            fieldDefaults: {
                                labelWidth: 120,
                                columnWidth: .33,
                                margin: '6 1 5 20',
                                fieldStyle: 'background:#E6E6E6',
                                readOnly: true
                            },
                            items: [
                                {
                                    fieldLabel: '债券编码',
                                    name: 'ZQ_CODE',
                                },
                                {
                                    fieldLabel: '债券名称',
                                    name: 'ZQ_NAME'
                                },
                                {
                                    fieldLabel: '债券简称',
                                    name: 'ZQ_JC'
                                },
                                {
                                    fieldLabel: '债券类型',
                                    name: 'ZQLB_NAME'
                                },
                                {
                                    fieldLabel: '债券品种',
                                    name: 'ZQPZ_NAME'
                                },
                                {
                                    fieldLabel: '发行方式',
                                    name: 'FXFS_NAME'
                                },
                                {
                                    fieldLabel: '债券托管人',
                                    name: 'ZQTGR_NAME'
                                },
                                {
                                    fieldLabel: '偿还资金来源',
                                    name: 'ZJLY_NAME'
                                },
                                {
                                    fieldLabel: '发行日期',
                                    name: 'FX_START_DATE'
                                },
                                {
                                    fieldLabel: '债券金额(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_AMT'
                                },
                                {
                                    fieldLabel: '其中新增债券(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_XZ_AMT'
                                },
                                {
                                    fieldLabel: '其中置换债券(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_ZH_AMT'
                                },
                                {
                                    fieldLabel: '债券期限',
                                    name: 'ZQQX_NAME'
                                },
                                {
                                    fieldLabel: '票面利率(%)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    name: 'PM_RATE'
                                },
                                {
                                    fieldLabel: '起息日',
                                    name: 'QX_DATE'
                                },
                                {
                                    fieldLabel: '到期兑付日',
                                    name: 'DQDF_DATE'
                                },
                                {
                                    fieldLabel: '计息方式',
                                    name: 'JXFS_NAME'
                                },
                                {
                                    fieldLabel: '付息周期',
                                    name: 'FXZQ_NAME'
                                },
                                {
                                    fieldLabel: '承担利息(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'LX_SUM_AMT'
                                },
                                {
                                    fieldLabel: '债务收入科目',
                                    name: 'SRKM_NAME'
                                },
                                {
                                    fieldLabel: '发行手续费率(‰)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    decimalPrecision: 4,
                                    name: 'FXSXF_RATE'
                                },
                                {
                                    fieldLabel: '登记托管费率(‰)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    name: 'TGSXF_RATE'
                                },
                                {
                                    fieldLabel: '兑付手续费率(‰)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    decimalPrecision: 4,
                                    name: 'DFSXF_RATE'
                                },
                                {
                                    fieldLabel: '发行手续费(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FXSXF_AMT'
                                },
                                {
                                    fieldLabel: '登记托管费(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'TGSXF_AMT'
                                },
                                {
                                    fieldLabel: '备注',
                                    xtype: 'textarea',
                                    labelWidth: 120,
                                    columnWidth: .99,
                                    name: 'REMARK'
                                }
                            ]
                        }
                    ]
                }
            ]
        });
    }
    /**
     *本级支出
     */
    function initWindow_zqxxtb_contentForm_tab_bjzc() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "PAY_DATE", width: 100, type: "string", text: "支付日期",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {
                dataIndex: "PAY_AMT", width: 125, type: "float", text: "支出金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "ZC_TYPE_NAME", width: 100, type: "string", text: "支出类型"},
            {
                dataIndex: "XM_NAME", width: 200, type: "string", text: "项目",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=record.get('XM_ID');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {dataIndex: "ZJYT_NAME", width: 200, type: "string", text: "资金用途"},
            {dataIndex: "GNFL_NAME", width: 200, type: "string", text: "支出功能分类"},
            {dataIndex: "JJFL_NAME", width: 200, type: "string", text: "支出经济分类"},
            {dataIndex: "REMARK", width: 300, type: "string", text: "备注"}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'bjzcGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getZqzlBjzcGrid.action',
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',//djl
            tbar: [
                {xtype: 'label', text: '债券名称:', width: 70},
                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}
            ],
            autoLoad: false,
            params: {
                ZQ_ID: ZQ_ID
            },
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     *转贷支出
     */
    function initWindow_zqxxtb_contentForm_tab_zdzc() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "AD_NAME", width: 100, type: "string", text: "转贷地区",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {
                dataIndex: "ZD_AMT", width: 150, type: "float", text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_XZ_AMT", width: 180, type: "float", text: "其中新增债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_ZH_AMT", width: 180, type: "float", text: "其中置换债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "REMARK", width: 180, type: "string", text: "备注"}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'zdzcGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            data: [],
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',//djl
            autoLoad: false,
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     *转贷收回本息
     */
    function initWindow_zqxxtb_contentForm_tab_zdshbx() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "AD_NAME", width: 100, type: "string", text: "还款地区",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {
                dataIndex: "HKBJ_AMT", width: 150, type: "float", text: "偿还本金金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HKLX_AMT", width: 150, type: "float", text: "偿还利息金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "DFF_AMT", width: 150, type: "float", text: "兑付费(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'zdshbxGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            data: [],
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            autoLoad: false,
            margin: '0 3 5 0',//djl
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     *应付本息
     */
    function initWindow_zqxxtb_contentForm_tab_yfbx() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "DF_END_DATE", width: 100, type: "string", text: "应付日期",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {
                dataIndex: "YFBJ", type: "string", text: "应付本金(元)",
                columns: [
                    {
                        dataIndex: "YFBJXJ", width: 150, type: "float", text: "小计",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {
                        dataIndex: "BJ_PLANBJ_AMT", width: 150, type: "float", text: "本级",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {
                        dataIndex: "XJ_PLANBJ_AMT", width: 150, type: "float", text: "下级",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    }
                ]
            },
            {
                dataIndex: "YFLX", type: "string", text: "应付利息(元)",
                columns: [
                    {
                        dataIndex: "YFLXXJ", width: 150, type: "float", text: "小计",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {
                        dataIndex: "BJ_PLANLX_AMT", width: 150, type: "float", text: "本级",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {
                        dataIndex: "XJ_PLANLX_AMT", width: 150, type: "float", text: "下级",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    }
                ]
            },
            {
                dataIndex: "YFDFF", type: "string", text: "应付手续费(元)",
                columns: [
                    {
                        dataIndex: "YFDFFXJ", width: 150, type: "float", text: "小计",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {
                        dataIndex: "BJ_DFF_AMT", width: 150, type: "float", text: "本级",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {
                        dataIndex: "XJ_DFF_AMT", width: 150, type: "float", text: "下级",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    }
                ]
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'yfbxGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getZqzlYfbxGrid.action',
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',//djl
            tbar: [
                {xtype: 'label', text: '债券名称:', width: 70},
                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}
            ],
            autoLoad: false,
            params: {
                ZQ_ID: ZQ_ID
            },
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     *实际还本
     */
    function initWindow_zqxxtb_contentForm_tab_sjhb() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "HK_DATE", width: 100, type: "string", text: "偿还日期",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {dataIndex: "ZJLY_NAME", width: 150, type: "string", text: "偿还资金来源"},
            {
                dataIndex: "HK_AMT", width: 150, type: "float", text: "偿还金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "DFF_AMT", width: 150, type: "float", text: "支付手续费(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'sjhbGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getZqzlSjhbfxGrid.action',
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',//djl
            tbar: [
                {xtype: 'label', text: '债券名称:', width: 70},
                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}
            ],
            autoLoad: false,
            params: {
                ZQ_ID: ZQ_ID,
                HK_TYPE: 0
            },
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     *实际付息
     */
    function initWindow_zqxxtb_contentForm_tab_sjfx() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "HK_DATE", width: 100, type: "string", text: "偿还日期",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {dataIndex: "ZJLY_NAME", width: 150, type: "string", text: "偿还资金来源"},
            {
                dataIndex: "HK_AMT", width: 150, type: "float", text: "偿还金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "DFF_AMT", width: 150, type: "float", text: "支付手续费(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'sjfxGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getZqzlSjhbfxGrid.action',
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',//djl
            tbar: [
                {xtype: 'label', text: '债券名称:', width: 70},
                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}
            ],
            autoLoad: false,
            params: {
                ZQ_ID: ZQ_ID,
                HK_TYPE: 1
            },
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     *加载页签数据
     */
    function load_information() {
        $.post("/getZqzlZqxxByZqId.action", {
            ZQ_ID: ZQ_ID
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                return;
            }
            //弹出弹出框，并将主表和明细表数据插入到弹出框form中
            window_show_information.show();
            data.data.TGSXF_RATE = data.data.TGSXF_RATE * 10;
            data.data.DFSXF_RATE = data.data.DFSXF_RATE * 10;
            data.data.FXSXF_RATE = data.data.FXSXF_RATE * 10;
            Ext.ComponentQuery.query('form[name="jbqkForm"]')[0].getForm().setValues(data.data);
        }, "json");
    }
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //var mhcx = Ext.ComponentQuery.query('textfield[itemId="contentGrid_search"]')[0].value;
        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        var form = Ext.ComponentQuery.query('form#condition')[0];
        if (unit != 0) {
            unit = Ext.ComponentQuery.query('combobox[name="unitSelect"]')[0].getValue();
            store.getProxy().extraParams["unit"] = unit;
        }
        var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
        var year = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].value;
        var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].value;
        //var sdate = Ext.ComponentQuery.query('datefield[name="sdate"]')[0].getValue();
        //var edate = Ext.ComponentQuery.query('datefield[name="edate"]')[0].getValue();
        store.getProxy().extraParams['mhcx'] = mhcx;
        store.getProxy().extraParams['SET_YEAR'] = year;
        store.getProxy().extraParams['ZQLB_ID'] = ZQLB_ID;
        //store.getProxy().extraParams['sdate'] = Ext.util.Format.date(sdate, 'Y-m-d');
        //store.getProxy().extraParams['edate'] = Ext.util.Format.date(edate, 'Y-m-d');
        //刷新
        store.loadPage(1);
    }
</script>
</body>
</html>