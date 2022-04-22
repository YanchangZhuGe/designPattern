<%--
  Created by IntelliJ IDEA.
  User: wangjingcheng
  Date: 2018/7/31
  Time: 9:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>项目协议总览</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <%--<style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }

        span.displayfield{
            font-weight:bolder;
            font-size:16px;
        }
    </style>--%>
</head>
<body>

    <script type="text/javascript">
        var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
        var DXM_ID='';
        var DATA_ID='';
        var ZDMX_ID='';

        /**
         * Extjs的入口
         */
        Ext.onReady(function(){
            initContent();
        });

        /**
         * 初始化主页面
         */
        function initContent() {
            Ext.create('Ext.panel.Panel', {
                width: '100%',
                height: '100%',
                renderTo: Ext.getBody(),
                layout: {
                    type: 'hbox',//竖直布局 item 有一个 flex属性
                    align: 'stretch' //拉伸使其充满整个父容器
                },
                tbar:[
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
                        text: '查看',
                        name: 'btn_check',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            var s =DXM_ID;
                            if (DXM_ID.length < 11) {
                                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                return;
                            }else{
                                button_name = btn.text;
                                window_select.show();
                                loadInfo();
                            }
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ],

                items: [
                    initContentTree(),
                    initContentRightPanel()
                ]
            });
        }

        function initContentTree(){
            Ext.define('treeModel', {
                extend: 'Ext.data.Model',
                fields: [
                    {name: 'text'},
                    {name: 'code'},
                    {name: 'id'},
                    {name: 'leaf'}
                ]
            });
            //创建左侧panel
            return Ext.create('Ext.panel.Panel', {
                region: 'west',
                layout: 'vbox',
                height: '100%',
                itemId: 'treePanel_left',
                flex: 1,
                border: true,
                items: initContentTree_dxm()
            });
        }

        /**
         * 初始化左侧树：区划
         */
        function initContentTree_dxm() {
            //加载左侧上方树数据
            var regStore = Ext.create('Ext.data.TreeStore', {
                proxy: {
                    type: 'ajax',
                    method: 'POST',
                    url: 'getDxmTree.action',
                    extraParams: {
                        AD_CODE:AD_CODE
                    },
                    reader: {
                        type: 'json'
                    }
                },
                root: 'nodelist',
                model: 'treeModel',
                autoLoad: true
            });
            var area_config = {
                itemId: 'tree_dxm',
                store: regStore,
                width: '100%',
                border: true,
                rootVisible: false,
                listeners: {
                    afterrender: function (self) {
                        //选中第一条数据
                        if (self.getSelection() == null || self.getSelection().length <= 0) {
                            //选中第一条数据
                            var record = self.getStore().getRoot().getChildAt(0);
                            if (record) {
                                self.getSelectionModel().select(record);
                                itemclick(self, record);
                            }
                        }
                    },
                    itemclick: itemclick
                }
            };

            //创建左侧panel
            var area_panel = Ext.create('Ext.tree.Panel', area_config);
            regStore.addListener('load', function (self) {
                var treeNodeCount = self.getCount();
                area_panel.setFlex(1);
                //选中第一条数据
                if (area_panel.getSelection() == null || area_panel.getSelection().length <= 0) {
                    var record = self.getRoot().getChildAt(0);
                    if (record) {
                        area_panel.getSelectionModel().select(record);
                        itemclick(area_panel, record);
                    }
                }
            });
            return area_panel;

            function itemclick(self, record) {
                DXM_ID = record.get('id');
                reloadGrid();
            }
        }

        //初始化右侧主界面
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
                    initGrid()
                ]
            });
        }

        /**
         * 初始化项目协议总览主面板
         */
        function initGrid() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {
                    dataIndex: "XM_ID",
                    width: 180,
                    type: "string",
                    text: "项目id",
                    hidden:true
                },
                {
                    text: "项目名称",
                    dataIndex: "XM_NAME",
                    type: "string",
                    width: 300,
                    //项目穿透
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
                    text: "所属区划",
                    dataIndex: "AD_NAME",
                    type: "string",
                    width: 200
                },
                {
                    text: "单位名称",
                    dataIndex: "AG_NAME",
                    type: "string",
                    width: 180
                },
                {
                    text: "建设单位",
                    dataIndex: "JSDW",
                    type: "string",
                    width: 200,
                    editable: true
                },
                {
                    text: "还款单位",
                    dataIndex: "HKDW",
                    type: "string",
                    width: 200,
                    editable: true
                },
                {
                    text: "贷款性质",
                    dataIndex: "DKXZ",
                    type: "string",
                    width: 100
                },
                {
                    text: '币种',
                    dataIndex: "FM_ID",
                    type: "string",
                    width: 100
                },
                {
                    text: "转贷金额(原币)",
                    dataIndex: "ZDJE",
                    type: "float",
                    width: 150,
                    editor: {
                        xtype: "numberFieldFormat",
                        emptyText: '0.00',
                        hideTrigger: true,
                        mouseWheelEnabled: true,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        minValue: 0,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value, cellmeta, record) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }

                },
                {
                    text: "提款金额（原币）",
                    dataIndex: "TKJE",
                    type: "float",
                    width: 150,
                    summaryType: 'sum',
                    editable: true,
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "偿还金额（原币）",
                    dataIndex: "HKJE",
                    type: "float",
                    width: 150,
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    text: "债务余额(原币)",
                    dataIndex: "ZWYE",
                    type: "float",
                    width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
//                {
//                    dataIndex: "WZXY_NAME",
//                    width: 250,
//                    type: "string",
//                    text: "外债名称"
//                },
//                {
//                    dataIndex: "XM_CODE",
//                    width: 180,
//                    type: "string",
//                    text: "项目编码"
//                },

//                {
//                    dataIndex: "LX_YEAR",
//                    width: 100,
//                    type: "string",
//                    text: "立项年度"
//                },

//                {
//                    dataIndex: "XMXZ_NAME",
//                    width: 250,
//                    type: "string",
//                    text: "项目性质"
//                },
//                {
//                    dataIndex: "XMLX_NAME",
//                    width: 150,
//                    type: "string",
//                    text: "项目类型"
//                },
//                {
//                    dataIndex: "XMZGS_AMT",
//                    width: 150,
//                    type: "string",
//                    text: "总概算金额（万元）"
//                },
//                {
//                    text: '债务类型',
//                    dataIndex: 'XMFL',
//                    type: "string",
//                    renderer: function (value) {
//                        var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
//                        return result != null ? result.get('name') : value;
//                    }
//                },
//                {
//                    dataIndex: "JSQX",
//                    width: 150,
//                    type: "string",
//                    text: "建设期限"
//                }
            ];
            return DSYGrid.createGrid({
                itemId: 'contentGrid_xmjsjdqkjs',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                checkBox: false,
                rowNumber: true,
                border: true,
                autoLoad: false,
                height: "100%",
                dataUrl:'getXmxxByDxmId.action',
                flex:1,
                tbar: [
                    {
                        fieldLabel: '模糊查询',
                        name: 'mhcx',
                        xtype: "textfield",
                        width: 300,
                        labelWidth: 60,
                        labelAlign: 'right',
                        emptyText: '项目名称...',
                        enableKeyEvents: true,
                        listeners:{
                            specialkey:function(field,e){
                                if(e.getKey()==Ext.EventObject.ENTER){
                                    reloadGrid();
                                }
                            }
                        }
                    }
                ],
                pageConfig: {
                    pageNum: true//设置显示每页条数
                }
            });
        }

        /**
         * 查看项目总览信息Windows框
         */
        var window_select = {
            window: null,
            show: function () {
                this.window = initwindow_select();
                this.window.show();
            }
        };

        /**
         * 初始化项目协议信息Windows框主表单
         */
        function initwindow_select() {
            return Ext.create('Ext.window.Window', {
                title: '大项目总览', // 窗口标题
                width: document.body.clientWidth * 0.9, // 窗口宽度
                height: document.body.clientHeight * 0.95, // 窗口高度
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                maximizable: true,
                itemId: 'window_input2', // 窗口标识
                buttonAlign: 'right', // 按钮显示的位置
                modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
                items: [
                    initWindow_input_contentForm(),
                    {
                        xtype: 'tabpanel',
                        border: false,
                        flex:13,
                        itemId: 'winPanel_tabPanel',
                        items: [
                            {
                                title: '贷款协议信息',
                                layout: 'fit',
                                scrollable: true,
                                name: 'detail',
                                items: initWindow_dkxyxx_contentForms()
                            },{
                                title: '转贷信息',
                                layout: 'fit',
                                scrollable: true,
                                name: 'detail',
                                items: initWindow_zdxx_contentForms()
                            },{
                                title: '提款信息',
                                layout: 'fit',
                                scrollable: true,
                                name: 'detail',
                                items: initWindow_tkxx_contentGrids()
                            },{
                                title: '还款计划',
                                layout: 'fit',
                                scrollable: true,
                                name: 'detail',
                                items: initWindow_hkjh_contentGrids()
                            },{
                                title: '还款信息',
                                layout: 'fit',
                                scrollable: true,
                                name: 'detail',
                                items: initWindow_hkxx_contentGrids()
                            }
                        ]
                    }

                ],
                buttons: [
                    {
                        text: '取消',
                        handler: function (btn) {
                            btn.up('window').destroy();
                        }
                    }
                ]
            });
        }

        /**
         * 初始化项目协议总览主表单信息
         */
        function initWindow_input_contentForm() {
            return Ext.create('Ext.form.Panel', {
                width: '100%',
                name:'content_form',
                itemId:'content_form',
                layout: 'column',
                border: false,
                flex: 1,
                defaults: {
                    padding: '2 2 2 10',
                    labelWidth: 100
                },
                defaultType: 'textfield',
                items: [
                    {
                        xtype: 'displayfield',
                        name: 'DXM_NAME',
                        columnWidth: .40,
                        labelWidth:80,
                        fieldLabel: '<span class="displayfield">大项目</span>',
                        value: '',
                        width: 80
                    },
                    {
                        xtype: 'displayfield',
                        name: 'AD_NAME',
                        columnWidth: .25,
                        labelWidth:80,
                        fieldLabel: '<span class="displayfield">所属区划</span>',
                        value: '',
                        width: 80
                    },
                    {
                        xtype: 'displayfield',
                        name: '',
                        columnWidth: .25,
                        labelWidth:80,
                        fieldLabel: '',
                        value: '',
                        width: 80
                    },
                    {
                        xtype: 'displayfield',
                        name: 'jedw',
                        columnWidth: .10,
                        labelWidth:50,
                        value: '<span style="text-align: right;display:block; class="displayfield">单位:元</span>',
                        width: 80
                    },
                    {
                        xtype: 'textfield',
                        name: 'U_DXM_ID',
                        labelWidth:80,
                        fieldLabel: '上级项目',
                        value: '',
                        width: 80,
                        hidden:true
                    }
                ]
            });
        }

        /**
         * 初始化贷款协议信息主表
         */
        function initWindow_dkxyxx_contentForms() {
            var config = {
                editable: false,
                busiId: ''
            };
            return Ext.create('Ext.form.Panel', {
                width: '100%',
                height: '100%',
                name:'dkxyxx_contentForm',
                itemId:'dkxyxx_contentForm',
                layout: 'vbox',
                fileUpload: true,
                border: false,
                defaults: {
                    width: '100%'
                },
                defaultType: 'textfield',
                items: [
                    initWindow_dkxyxx_Forms(),
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        scrollable: true,
                        name: 'dkxxFJ',
                        xtype: 'fieldset',
                        layout: 'fit',
                        flex: 1.5,
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'winPanel_tabPanel',
                                border:false,
                                items: initWindow_wzzdlr_contentForm_tab_upload(config)
                            }
                        ]
                    }
                ]
            });
        }

        /**
         * 初始化贷款协议信息
         */
        function initWindow_dkxyxx_Forms() {
            return Ext.create('Ext.form.Panel', {
                width: '100%',
                height: '100%',
                name:'dkxyxx_form',
                itemId:'dkxyxx_form',
                layout: 'column',
                flex: 1,
                fileUpload: true,
                border: false,
                defaults: {
                    padding: '2 2 2 10',
                    columnWidth: .33,
                    readOnly: true,
                    labelWidth: 130//控件默认标签宽度
                },
                defaultType: 'textfield',
                items: [
                    {
                        fieldLabel: '主键Id',
                        xtype: "textfield",
                        name: "DATA_ID",
                        hidden:true
                    },
                    {
                        fieldLabel: '外债Id',
                        xtype: "textfield",
                        name: "WZXY_ID",
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债名称',
                        disabled: false,
                        name: "WZXY_NAME",
                        fieldStyle: 'background:#E6E6E6'
                    },
//                    {
//                        xtype: "textfield",
//                        fieldLabel: '贷款性质',
//                        disabled: false,
//                        name: "ZWLB",
//                        fieldStyle: 'background:#E6E6E6'
//                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '签订日期',
                        disabled: false,
                        name: "SIGN_DATE",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '外债期限',
                        disabled: false,
                        name: "WZQX_ID",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权类型',
                        disabled: false,
                        name: "ZQFL_ID",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权人',
                        disabled: false,
                        name: "ZQR_ID",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债权人全称',
                        disabled: false,
                        name: "ZQR_FULLNAME",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '协议号',
                        disabled: false,
                        name: "WZXY_NO",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "WZXY_AMT",
                        fieldLabel: '协议金额（原币）',
                        emptyText: '0.000000',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        minValue: 0,
                        maxValue: 9999999999,
                        disabled: false,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})

                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "WZXY_AMT_RMB",
                        type:'float',
                        fieldLabel: "协议金额（人民币）",
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        disabled: false,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})

                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '原币币种',
                        disabled: false,
                        name: "FM_ID",
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberfield",
                        name: "HL_RATE",
                        fieldLabel: '汇率',
                        value: 1.000000,
                        readOnly: true,
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        disabled: false,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    }
                ]
            });
        }

        /**
         * 初始化转贷信息
         */
        function initWindow_zdxx_contentForms() {
//            var config = {
//                editable: false,
//                busiId: ''
//            };
            return Ext.create('Ext.form.Panel', {
                width: '100%',
                height: '100%',
                itemId:'dkxy_form',
                layout: 'vbox',
                fileUpload: true,
                border: false,
                defaults: {
                    width: '100%'
                },
                defaultType: 'textfield',
                items: [
                    initWindow_zdxx_tkmx_contentGrids(),
//                    {
//                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
//                        scrollable: true,
//                        flex: 1,
//                        name: 'attachment',
//                        xtype: 'fieldset',
//                        items: [
//                            {
//                                xtype: 'panel',
//                                layout: 'fit',
//                                itemId: 'winPanel_tabPanel',
//                                border:false,
//                                items: initWindow_wzzdlr_contentForm_tab_upload(config)
//                            }
//                        ]
//                    }
                ]
            });
        }

        /**
         * 初始化还款计划表
         */
        function initWindow_hkjh_contentGrids() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                //{dataIndex: "ID", type: "string", text: "ID", width: 150, editor: 'textfield'},
                //dataIndex: "CH_PERCENT", type: "string", text: "还款单位", width: 150, editor: 'textfield'},
                {dataIndex: "HKJH_DATE", type: "string", text: "应还款日期", width: 150},
                {dataIndex: "HKJH_AMT", type: "float", text: "应还款金额", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "CH_PERCENT", type: "float", text: "偿还份额（%）", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }}
            ];

            var grid = DSYGrid.createGrid({
                name:'dxmzl_hkjh_grid',
                itemId: 'dxmzl_hkjh_grid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                autoLoad: false,
                dataUrl: [],
                selModel: {
                    mode: "SINGLE"
                },
                checkBox: true,
                border: false,
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
                        pluginId: 'wzzd_grid_plugin_cell2',
                        clicksToMoveEditor: 1
                    }
                ],
                pageConfig: {
                    enablePage: false
                }
            });
            return grid;
        }

        /**
         * 初始化还款信息
         */
        function initWindow_hkxx_contentGrids() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {dataIndex: "AD_CODE", type: "string", text: "还款地区", width: 150,hidden:true},
                {dataIndex: "AD_NAME", type: "string", text: "还款单位", width: 150},
                {dataIndex: "END_DATE", type: "string", text: "还款日期", width: 150},
                {dataIndex: "PAY_AMT", type: "float", text: "还款金额(原币)", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "PAY_BJ_AMT", type: "float", text: "还款本金(原币)", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "PAY_LX_AMT", type: "float", text: "还款利息(原币)", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "PAY_RMB", type: "float", text: "还款金额(人民币)", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "PAY_BJ_RMB", type: "float", text: "还款本金(人民币)", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "PAY_LX_RMB", type: "float", text: "还款利息(人民币)", width: 150,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "HL_RATE", type: "string", text: "汇率", width: 150,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.000000');
                    }

                }
            ];

            var grid = DSYGrid.createGrid({
                name:'dxmzl_hkxx_grid',
                itemId: 'dxmzl_hkxx_grid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                autoLoad: false,
                dataUrl: [],
                selModel: {
                    mode: "SINGLE"
                },
                checkBox: true,
                border: false,
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
                        pluginId: 'wzzd_grid_plugin_cell2',
                        clicksToMoveEditor: 1
                    }
                ],
                pageConfig: {
                    enablePage: false
                }
            });

            return grid;
        }

        /**
         * 初始化转贷信息
         */
        function initWindow_zdxx_tkmx_contentGrids() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {dataIndex: "ZDMX_ID", type: "string", text: "转贷明细ID", width: 150,hidden:true },
                {dataIndex: "WZXY_NAME", type: "string", text: "协议名称", width: 150},
                {dataIndex: "AD_NAME", type: "string", text: "转贷地区", width: 150 },
                {dataIndex: "AG_NAME", type: "string", text: "转贷单位", width: 150 },
                {
                    dataIndex: "JSDW",
                    type: "string",
                    text: "建设单位",
                    width: 150,
                    editable: true
                },
                {
                    dataIndex: "HKDW",
                    type: "string",
                    text: "还款单位",
                    editable: true,
                    width: 150
                },
                {dataIndex: "ZD_DATE", type: "string", text: "转贷日期", width: 150},
                {dataIndex: "ZD_AMT", type: "float", text: "转贷金额（原币）", width: 150,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "ZDHL", type: "string", text: "汇率", width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }

                },
                {dataIndex: "ZD_AMT_RMB", type: "float", text: "转贷金额（人民币）", width: 180,summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {dataIndex: "ZDXM_NAME", type: "string", text: "转贷项目名称", width: 150},
                {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150}
            ];

            var grid = DSYGrid.createGrid({
                itemId: 'dxmzl_zdxx_grid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                autoLoad: false,
                dataUrl: [],
                selModel: {
                    mode: "SINGLE"
                },
                checkBox: false,
                border: false,
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
                        pluginId: 'wzzd_grid_plugin_cell2',
                        clicksToMoveEditor: 1
                    }
                ],
                pageConfig: {
                    enablePage: false
                },
                listeners: {
                    'rowclick':function(self){
                        var records = DSYGrid.getGrid('dxmzl_zdxx_grid').getSelection();
                        var ZDMX_ID=records[0].get('ZDMX_ID');
//                        var filePanel = Ext.ComponentQuery.query('#dkxy_form')[0].down('#winPanel_tabPanel');
//                        if(filePanel){
//                            filePanel.removeAll();
//                            filePanel.add(initWindow_wzzdlr_contentForm_tab_upload({
//                                editable: false,
//                                busiId: ZDMX_ID
//                            }));
//                        }
                    }
                }
            });

            return grid;
        }

        /**
         * 初始化提款信息
         */
        function initWindow_tkxx_contentGrids() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {dataIndex: "WZXY_NAME", type: "string", text: "协议名称", width: 150},
                {dataIndex: "AD_NAME", type: "string", text: "提款地区", width: 150},
                {dataIndex: "AG_NAME", type: "string", text: "提款单位", width: 150},
                {dataIndex: "XM_NAME", type: "string", text: "子项目名称", width: 150,hidden:true},

                {
                    dataIndex: "ZCLX_NAME",
                    type: "string",
                    text: "支付类别",
                    width: 150,
                    editable: true
                },
                {
                    dataIndex: "SQS_NO",
                    type: "string",
                    text: "申请书编号",
                    width: 200,
                    editable: true
                },
                {
                    dataIndex: "BF_AMT",
                    type: "float",
                    text: "拨付金额(人民币)",
                    width: 180,
                    editable: true,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value, cellmeta, record) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    dataIndex: "BF_HL",
                    type: "float",
                    text: "拨付汇率",
                    width: 150,
                    editable: true,
                    renderer: function (value, cellmeta, record) {
                        return Ext.util.Format.number(value, '0,000.000000');
                    }
                },
                {
                    dataIndex: "ZHYB_AMT",
                    type: "float",
                    text: "拨付折合原币金额",
                    width: 180,
                    editable: true,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    },
                    renderer: function (value, cellmeta, record) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "拨付日期",
                    dataIndex: "BF_DATE",
                    type: "string",
                    editable: true,
                    width: 110
                },
                {
                    dataIndex: "ZH_NAME",
                    type: "string",
                    text: "账户名称",
                    editable: true,
                    width: 200
                },
                {
                    dataIndex: "ZH_TYPE",
                    type: "string",
                    text: "账户类型",
                    editable: true,
                    hidden: true,
                    width: 150
                },
                {
                    dataIndex: "ACCOUNT",
                    type: "string",
                    text: "账号",
                    editable: true,
                    width: 150
                },
                {
                    dataIndex: "ZH_BANK",
                    type: "string",
                    text: "开户银行",
                    editable: true,
                    width: 150
                },
                {
                    dataIndex: "REMARK",
                    type: "string",
                    text: "备注",
                    editable: true,
                    width: 150
                }
            ];

            var grid = DSYGrid.createGrid({
                name:'',
                itemId: 'dxmzl_tkxx_grid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                autoLoad: false,
                dataUrl: [],
                selModel: {
                    mode: "SINGLE"
                },
                checkBox: true,
                border: false,
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
                        pluginId: 'wzzd_grid_plugin_cell2',
                        clicksToMoveEditor: 1
                    }
                ],
                pageConfig: {
                    enablePage: false
                }
            });
            return grid;
        }

        /**
         * 附件
         */
        function initWindow_wzzdlr_contentForm_tab_upload(config) {
            var busiId=config.busiId;
            var grid = UploadPanel.createGrid({
                busiType: '',//业务类型
                busiId: busiId,//业务ID
                editable: config.editable,//是否可以修改附件内容
                gridConfig: {
                    itemId: 'dxmzl_FJ'
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
         * 树点击节点时触发，刷新content主表格
         */
        function reloadGrid(param) {
            var store = DSYGrid.getGrid('contentGrid_xmjsjdqkjs').getStore();
            var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
            //初始化表格Store参数
            store.getProxy().extraParams = {
                DXM_ID: DXM_ID,
                mhcx: mhcx
            };
            //刷新表格内容
            store.loadPage(1);
        }

        /**
         * 刷新附件表格
         */
        function reloadFJ() {

            var data_id =  Ext.ComponentQuery.query('textfield[name="DATA_ID"]')[0].getValue();
            var config = {
                editable: false,
                busiId: data_id
            };
            var filePanel = Ext.ComponentQuery.query('#dkxyxx_contentForm')[0].down('#winPanel_tabPanel');
            if(filePanel){
                filePanel.removeAll();
                filePanel.add(initWindow_wzzdlr_contentForm_tab_upload(config));
            }
        }

        /**
         * 加载弹出框页面数据
         * @param form
         */
        function loadInfo() {
            //header
            $.ajax({
                type: "post",
                url: "/getTitleInfo.action",
                dataType: 'JSON',
                data:{
                    DXM_ID: DXM_ID
                },
                success:function(data){
                    if( data.success ){
                        if( data.list.length != 0 ){
                            var DXM_NAME = data.list[0].DXM_NAME;
                            var AD_NAME = data.list[0].AD_NAME;
                            var ZXDW_NAME = data.list[0].ZXDW_NAME;
                            var U_DXM_ID = data.list[0].U_DXM_ID;
                            document.title = '项目总览-'+DXM_NAME;
                            Ext.ComponentQuery.query('displayfield[name="AD_NAME"]')[0].setValue('<span class="displayfield">'+AD_NAME+'</span>');
                            Ext.ComponentQuery.query('displayfield[name="DXM_NAME"]')[0].setValue('<span class="displayfield">'+DXM_NAME+'</span>');
//                            Ext.ComponentQuery.query('displayfield[name="ZXDW_NAME"]')[0].setValue('<span class="displayfield">'+ZXDW_NAME+'</span>');
                            Ext.ComponentQuery.query('textfield[name="U_DXM_ID"]')[0].setValue(U_DXM_ID);
                        }
                    }

                }
            });

            //贷款协议信息
            $.ajax({
                type: "post",
                url: "/getZlDkxyInfo.action",
                dataType: 'JSON',
                data:{
                    DXM_ID: DXM_ID
                },
                success:function(data){
                    if( data.success ){
                        if(data.list.length != 0 ){
                            var dkxyxxForm = Ext.ComponentQuery.query('form[name="dkxyxx_form"]')[0];
                            dkxyxxForm.getForm().setValues(data.list[0]);
                            reloadFJ();
                        }
                    }
                }
            });

            //转贷信息
            $.ajax({
                type: "post",
                url: "/getZlZdxxInfo.action",
                dataType: 'JSON',
                data:{
                    DXM_ID: DXM_ID
                },
                success:function(data){
                    if( data.success ){
                        if(data.list.length != 0 ){
                            var zdxxGrid = DSYGrid.getGrid('dxmzl_zdxx_grid');
                            zdxxGrid.getStore().removeAll();
                            zdxxGrid.insertData(null,data.list);
                        }
                    }
                }
            });

            //提款信息
            $.ajax({
                type: "post",
                url: "/getZlTkxxInfo.action",
                dataType: 'JSON',
                data:{
                    DXM_ID: DXM_ID
                },
                success:function(data){
                    if( data.success ){
                        if(data.list.length != 0 ){
                            var tkxxGrid = DSYGrid.getGrid('dxmzl_tkxx_grid');
                            tkxxGrid.getStore().removeAll();
                            tkxxGrid.insertData(null,data.list);
                        }
                    }
                }
            });

            //还款计划
            $.ajax({
                type: "post",
                url: "/getZlHkjhInfo.action",
                dataType: 'JSON',
                data:{
                    DXM_ID: DXM_ID
                },
                success:function(data){
                    if( data.success ){
                        if(data.list.length != 0 ){
                            var hkjhGrid = DSYGrid.getGrid('dxmzl_hkjh_grid');
                            hkjhGrid.getStore().removeAll();
                            hkjhGrid.insertData(null,data.list);
                        }
                    }
                }
            });


            //还款计划
            $.ajax({
                type: "post",
                url: "/getZlHkxxInfo.action",
                dataType: 'JSON',
                data:{
                    DXM_ID: DXM_ID
                },
                success:function(data){
                    if( data.success ){
                        if(data.list.length != 0 ){
                            var hkxxGrid = DSYGrid.getGrid('dxmzl_hkxx_grid');
                            hkxxGrid.getStore().removeAll();
                            hkxxGrid.insertData(null,data.list);
                        }
                    }
                }
            });

        }
    </script>

</body>
</html>
