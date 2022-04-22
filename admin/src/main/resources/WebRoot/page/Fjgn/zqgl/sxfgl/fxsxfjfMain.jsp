<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>

<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>发行手续费缴付主界面</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        .grid-cell {
            background-color: #ffe850;
        }

        .grid-cell-unedit {
            background-color: #E6E6E6;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>

</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    /*获取登录用户*/
    var WF_STATUS = '001';//当前状态
/*
    var FEE_TYPE = getQueryParam("fee_type");
*/
    var FEE_TYPE ="${fns:getParamValue('fee_type')}";

    //全局变量
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var userAD = '${sessionScope.USERCODE}';
    /**
     * 页面初始化
     */
    $(document).ready(function () {
   
        initContent();
        initButton();
    });
    function initContent() {
        /**
         * 初始化顶部功能按钮
         */
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
                    items: [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '增加',
                            name: 'btn_add',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                window_fxsxfjf.show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_modify',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
			                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
			                    if(record == null || record == '' || record == 'undefined'){
			                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
			                        return;
			                    }
		                    	var bill_id = record.get('PAY_BILL_ID');
		                    	fuc_modifySxf(bill_id);
		                    	
		                    	var form = Ext.ComponentQuery.query('form[name="sxfjfModifyForm"]')[0];
                        		form.getForm().setValues(record.data);
                        		
                        		var mainStore = DSYGrid.getGrid('contentGrid_detail').getStore();
                        		DSYGrid.getGrid('modifyGrid').setStore(mainStore);
                                
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
			                    //获取表格被选中行
			                		   deleteInfo();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '缴款',
                            name: 'btn_pay',
                            icon: '/image/sysbutton/submit.png',
                            handler: function (btn) {
                            		fuc_jk();   
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }

            ],
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    /**
     * 主界面初始化
     */
    function initContentGrid() {
        /**
         * 债券注册信息列表工具栏
         */
        var screenBar = [
            {
                xtype: "combobox",
                name: "WF_STATUS",
                store: DebtEleStore(json_debt_zt9),
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                fieldLabel: '状态',
                editable: false, //禁用编辑
                width: 150,
                labelWidth: 30,
                allowBlank: false,
                labelAlign: 'right',
                listeners: {
                    'select': function (combo, record, index) {
                        WF_STATUS = record.get('id');
                        initButton();
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        reloadGrid();
                    }
                }
            },
            {
			xtype : "combobox",
			name : "ZQ_PC_ID",
			store : DebtEleStoreDB("DEBT_ZQPC"),
			displayField : "name",
			valueField : "id",
			fieldLabel : '发行批次',
			editable : false, //禁用编辑
			labelWidth : 60,
			width : 200,
			 hidden:true,
			labelAlign : 'right',
			listeners : {
					change : function(self, newValue) {
						//刷新当前表格
						reloadGrid();
					}
				}
			}
        ];

        /**
         * 发行手续费信息列表表头
         */
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {
                "dataIndex": "PAY_BILL_ID",
                "type": "string",
                "text": "缴付单据ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "PAY_BILL_CODE",
                "type": "string",
                "text": "缴付单据编码",
                "fontSize": "15px",
                "width": 150,
                hidden:true
            },
            {
                "dataIndex": "ZQ_PC_NAME",
                "type": "string",
                "width": 150,
                 hidden:true,
                "text": "发行批次"
            },
            {
                "dataIndex": "PAY_DATE",
                "width": 150,
                "type": "string",
                "text": "支付日期"
            },
            {
                "dataIndex": "PAY_AMT",
                "width": 150,
                "type": "float",
                "text": "手续费金额"
            },
            {
                "dataIndex": "ZQ_BOND_AMT",
                "width": 200,
                "type": "float",
                "text": "债券总额"
            },
            {
                "dataIndex": "REMARK",
                "width": 150,
                "type": "string",
                "text": "备注"
            }

        ];

        /**
         * 发行手续费信息列表表格
         */
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid',
            border: false,
            flex: 1,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getFxsxfMainGridDataForJF.action',
            autoLoad: true,
            params: {
                WF_STATUS: WF_STATUS,
                AD_CODE: AD_CODE,
                FEE_TYPE:FEE_TYPE
            },
            height: '100%',
            checkBox: true,
            pageConfig: {
                pageNum: true// 每页显示数据数
            },
            tbar: screenBar,
            tbarHeight: 50,
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['PAY_BILL_ID'] = record.get('PAY_BILL_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        };
        var grid = simplyGrid.create(config);
        return grid;

    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {
                "dataIndex": "PAY_DTL_ID",
                "type": "string",
                "text": "债券手续费缴付明细ID",
                "fontSize": "15px",
                "width": 210,
                "hidden": true
            },
            {
                "dataIndex": "CXJG_NAME",
                "type": "string",
                "text": "承销商",
                "fontSize": "15px",
                "width": 210
            },
            {
                "dataIndex": "CX_AMT",
                "type": "float",
                "text": "承销金额",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                "hidden": true
            },
            {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券编码",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "text": "债券名称",
                "fontSize": "15px",
                "width": 150,
	            renderer: function (data, cell, record) {
	                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
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
            {
                "dataIndex": "ZQQX_NAME",
                "width": 100,
                "type": "string",
                "text": "债券期限"
            },
            {
                "dataIndex": "FEE_RATE",
                "width": 130,
                "type": "float",
                "align": 'right',
                "text": "手续费率（‰）"
            },
            {
                "dataIndex": "PLAN_PAY_DATE",
                "width": 120,
                "type": "string",
                "text": "手续费应付日期"
            },
            {
                "dataIndex": "PAY_DTL_AMT",
                "width": 150,
                "type": "float",
                "text": "手续费金额"
            },
            {
                "dataIndex": "FEE_TYPE",
                "width": 150,
                "type": "string",
                "text": "手续费类型",
                "hidden":true
            },
            {
                "dataIndex": "PAY_DATE",
                "width": 150,
                "type": "string",
                "text": "支付日期"
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
            dataUrl: 'getFxsxfDtlGridDataForJF.action'
        };

        var grid = simplyGrid.create(config);

        return grid;
    }
    /**
     * 初始化按钮
     */
    function initButton() {
        var combobox_WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0];
        var btn_add = Ext.ComponentQuery.query('button[name="btn_add"]')[0];
        var btn_modify = Ext.ComponentQuery.query('button[name="btn_modify"]')[0];
        var btn_delete = Ext.ComponentQuery.query('button[name="btn_delete"]')[0];
        var btn_pay = Ext.ComponentQuery.query('button[name="btn_pay"]')[0];
        //根据当前结点状态，控制状态下拉框绑定的json以及按钮的显示与隐藏
        if (combobox_WF_STATUS.value == '001') {
            btn_add.show();
            btn_modify.show();
            btn_delete.show();
            btn_pay.show();

        } else if (combobox_WF_STATUS.value == '002') {
            btn_add.hide();
            btn_modify.hide();
            btn_delete.hide();
            btn_pay.hide();
        }
        //fuc_getSxfGrid();
    }
    //创建债券信息填报弹出窗口
    var window_fxsxfjf = {
        window: null,
        config: {
            closeAction: 'destroy'
        },
        show: function () {
            if (!this.window || this.config.closeAction == 'destroy') {

                this.window = initWindow_fxsxfjf();
            }
            this.window.show();


        }
    };
    function initWindow_fxsxfjf() {
        var iWidth = document.body.clientWidth * 0.95;
        var iHeight = document.body.clientHeight * 0.9;//窗口高度
        var addWindow = new Ext.Window({
            title: FEE_TYPE == 0 ? "发行手续费选择":"登记手续费选择",
            itemId: 'addWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            maximizable: true,//最大化按钮
            //autoScroll: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            layout: 'fit',
            items: [
                initWindow_add_grid()
            ],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '确定',
                    itemId: 'save_editGrid',
                    name: 'SAVE',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid_add').getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        }
                        var zqids = new Array();
                        var data = {};
                        data.SUM_FX_AMT = 0;
                        data.SUM_SXF_AMT = 0;
                       data.ZQ_PC_ID = Ext.ComponentQuery.query('combobox[name="BATCH_NO"]')[0].getValue();
                        
                        Ext.each(records, function (record) {
                            data.SUM_FX_AMT = data.SUM_FX_AMT + record.get("FX_AMT");
                            zqids.push(record.get("ZQ_ID"));
                        });
                        fuc_sxfCreate(zqids);
                        var store = DSYGrid.getGrid('createGrid').getStore();
                        store.load({
                				callback: function(){
							        var form = Ext.ComponentQuery.query('form[name="sxfjfForm"]')[0];
                                    var pay_date = form.getValues().PAY_DATE;
                					store.each(function (record) {
										data.SUM_SXF_AMT = data.SUM_SXF_AMT + record.get("PAY_DTL_AMT");
										record.set("PAY_DATE",pay_date);
							        });
                        			form.getForm().setValues(data);
                				}
                		});
                		btn.up('window').close();
 

                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        return addWindow;
    }
    function initWindow_add_grid() {
        return Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            border: false,
            items: [
                initContentGrid_add(),
                initContentDetilGrid_add()
            ]
        });
    }
    function initContentGrid_add() {
        /**
         * 发行手续费信息列表表头
         */
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "text": "债券ID",
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
                "width": 250,
                "text": "债券名称",
	            renderer: function (data, cell, record) {
	                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
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
            {
                "dataIndex": "ZQ_PC_NAME",
                "width": 150,
                "type": "string",
                "text": "发行批次"
            },
            {
                "dataIndex": "ZQQX_NAME",
                "width": 150,
                "type": "string",
                "text": "债券期限"
            },
            {
                "dataIndex": "ZQLB_NAME",
                "width": 150,
                "type": "string",
                "text": "债券类型"
            },
            {
                "dataIndex": "FX_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "债券总额"
            }
        ];
        /**
         * 发行手续费信息列表表格
         */
        var config = {
            itemId: 'contentGrid_add',
            border: false,
            flex: 1,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getFxsxfLrMainGridDataForJF.action',
            autoLoad: true,
            params: {
                FEE_TYPE: FEE_TYPE,
                AD_CODE: AD_CODE
            },
            height: '100%',
            checkBox: true,
            pageConfig: {
                enablePage: false
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail_add').getStore().getProxy().extraParams['ZQ_ID'] = record.get('ZQ_ID');
                    DSYGrid.getGrid('contentGrid_detail_add').getStore().loadPage(1);
                }
            }
        };
        var grid = DSYGrid.createGrid(config);
        var searchTool = initContentGrid_add_searchTool();
        grid.addDocked(searchTool, 0);
        return grid;
    }
    /**
     * 初始化到期债务(有计划)弹出框搜索区域
     */
    function initContentGrid_add_searchTool() {
        //初始化查询控件
        var items = [];
        items.push(
            {
                xtype: "combobox",
                name: "BATCH_NO",
                fieldLabel: '发行批次',
                store: DebtEleStoreDB('DEBT_ZQPC'),
                displayField: 'name',
                valueField: 'id',
                lines: false,
                width: 250,
                labelWidth:100,
                //allowBlank: false,
                editable: false,
                listeners: {
                    'change': function (self, newValue) {
                        DSYGrid.getGrid('contentGrid_add').getStore().getProxy().extraParams['BATCH_NO'] = newValue;
                        DSYGrid.getGrid('contentGrid_add').getStore().loadPage(1);
                        DSYGrid.getGrid('contentGrid_detail_add').getStore().removeAll();
                    },
                    'afterrender': function (self) {
                        self.store.load({
                            callback: function () {
                                //self.setValue(self.store.getAt(0).get('id'));
                            }
                        });
                    }
                }
            },
			{
			    xtype: "textfield",
			    fieldLabel: '模糊查询',
			    itemId: 'mhcx',
			    width: 300,
			    labelWidth: 60,
			    labelAlign: 'right',
			    emptyText: '请输入债券名称/债券编码...',
			    enableKeyEvents: true,
                listeners: {
                    'change': function (self, newValue) {
                        DSYGrid.getGrid('contentGrid_add').getStore().getProxy().extraParams['mhcx'] = newValue;
                    },
                    'keydown': function (self, e, eOpts) {
                          var key = e.getKey(); 
                          if (key == Ext.EventObject.ENTER) {
                           		DSYGrid.getGrid('contentGrid_add').getStore().loadPage(1);
                          }
                      }
                }
			}
        );
        //设置查询form
        var searchTool = new DSYSearchTool();
        searchTool.setSearchToolId('searchTool_grid');
        return searchTool.create({
            items: items,
            dock: 'top',
            defaults: {
                labelWidth: 0,
                labelAlign: 'left',
                margin: '5 5 5 5',
                width: 850
            },
            // 查询按钮回调函数
            callback: function (self) {
                var store = self.up('grid').getStore();
                // 清空参数中已有的查询项
                for (var search_form_i in self.getValues()) {
                    delete store.getProxy().extraParams[search_form_i];
                }
                var formValue = self.getValues();
                // 向grid中追加参数
                $.extend(true, store.getProxy().extraParams, formValue);
                // 刷新表格
                store.loadPage(1);
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid_add() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {
                "dataIndex": "CXJG_NAME",
                "type": "string",
                "text": "承销商",
                "fontSize": "15px",
                "width": 210
            },
            {
                "dataIndex": "CX_AMT",
                "type": "float",
                "text": "承销金额",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "FEE_RATE",
                "width": 130,
                "type": "float",
                "align": 'right',
                "text": "手续费率（‰）"
            },
            {
                "dataIndex": "SXF_TYPE",
                "width": 150,
                "type": "string",
                "text": "手续费类型"
            },
            {
                "dataIndex": "PLAN_PAY_AMT",
                "width": 150,
                "type": "float",
                "text": "手续费金额"
            }
        ];

        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail_add',
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
            dataUrl: 'getFxsxfDtlGridDataForSC.action',
            params: {
                FEE_TYPE: FEE_TYPE,//手续费类型
                AD_CODE: AD_CODE
            },
        };

        var grid = simplyGrid.create(config);

        return grid;
    }
    /**
     * 发行手续费缴付页面
     */
    function fuc_sxfCreate(zqids) {
        var iWidth = document.body.clientWidth * 0.95;
        var iHeight = document.body.clientHeight * 0.9;//窗口高度

        var addWindow = new Ext.Window({
            title: FEE_TYPE == 0 ? "发行手续费缴付":"登记手续费缴付",
            itemId: 'addWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            maximizable: true,//最大化按钮
            //autoScroll: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            layout: 'fit',
            items: [initWindow_jf_grid(zqids)],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    itemId: 'save_editGrid',
                    name: 'SAVE',
                    handler: function (btn) {
                        submitInfo(zqids);
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        addWindow.show();
    }
    /**
     * 手续费缴付信息列表表头
     */
    var headerJson_jf = [
        {xtype: 'rownumberer', width: 40},
        {
            "dataIndex": "PAY_DTL_ID",
            "type": "string",
            "text": "债券手续费缴付明细ID",
            "fontSize": "15px",
            "width": 210,
            "hidden": true
        },
        {
            "dataIndex": "CXJG_NAME",
            "type": "string",
            "text": "承销商",
            "fontSize": "15px",
            "width": 210
        },
        {
            "dataIndex": "CX_AMT",
            "type": "float",
            "text": "承销金额（元）",
            "fontSize": "15px",
            "width": 150
        },
        {
            "dataIndex": "FEE_RATE",
            "width": 130,
            "type": "float",
            "align": 'right',
            "text": "手续费率（‰）"
        },
        {
            "dataIndex": "FEE_TYPE",
            "width": 150,
            "type": "string",
            "text": "手续费类型",
            "hidden": true
        },
        {
            "dataIndex": "PAY_DTL_AMT",
            "width": 150,
            "type": "float",
            "text": "手续费金额（元）"
        },
        {
            "dataIndex": "PAY_DATE",
            "type": "string",
            "text": "支付日期",
            "editor": 'datefield',
            renderer: function (value, metaData, record) {
                var newdate = dsyDateFormat(value);
                record.data.PAY_DATE = newdate;
                return newdate;
            }
        },
        {
            "dataIndex": "ZQ_ID",
            "type": "string",
            "text": "债券ID",
            "fontSize": "15px",
            "width": 150,
            "hidden": true
        },
        {
            "dataIndex": "ZQ_CODE",
            "type": "string",
            "text": "债券编码",
            "fontSize": "15px",
            "width": 150,
            "hidden": true
        },
        {
            "dataIndex": "ZQ_NAME",
            "type": "string",
            "text": "债券名称",
            "fontSize": "15px",
            "width": 150,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
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
        }
    ];

    function initWindow_jf_grid(zqids) {

 
        /**
         * 手续费生成信息列表表格
         */
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'createGrid',
            border: true,
            headerConfig: {
                headerJson: headerJson_jf,
                columnAutoWidth: false
            },
            dataUrl: 'getFxsxfjfGridDataForJF.action',
            autoLoad: false,
            params: {
                zqids: zqids,
                AD_CODE: AD_CODE,
                FEE_TYPE: FEE_TYPE
            },
            height: '100%',
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'createGrid_plugin',
                    clicksToMoveEditor: 1
                }
            ],
            pageConfig: {
                enablePage: false
            }
        };
        var grid = simplyGrid.create(config);

        return Ext.create('Ext.form.Panel', {
            name: 'sxfjfForm',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            border: false,
            padding: '0 10 0 10',
            defaultType: 'textfield',
            items: [
                //{ xtype: 'hiddenfield', name: 'userPageMenu.id' },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .33,
                        width: 210,
                        labelWidth: 130//控件默认标签宽度
                    },
                    items: [{
                            xtype: "combobox",
			                name: "ZQ_PC_ID",
			                fieldLabel: '发行批次',
			                store: DebtEleStoreDB('DEBT_ZQPC'),
			                displayField: 'name',
			                valueField: 'id',
			                lines: false,
			               hidden:true,
			               // allowBlank: false,
			                editable: false,
			                readOnly:true
                    	},
                        {
                            xtype: "numberFieldFormat",
                            name: "SUM_FX_AMT",
                            fieldLabel: '债券总额（元）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SUM_SXF_AMT",
                            fieldLabel: '手续费金额（元）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly: true
                        },
                        {
                            xtype: "datefield",
                            name: "PAY_DATE",
                            fieldLabel: '<span class="required">✶</span>支付日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            value: today,
                            listeners: {
                                change: function (self, newValue) {
                                    var store = DSYGrid.getGrid("createGrid").getStore();
                                    var items = store.getData().items;
                                    if (items.length > 0) {
                                        for (var i = 0; i< items.length; i++) {
                                            store.getAt(i).set('PAY_DATE',dsyDateFormat(newValue));
                                        }
                                    }
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '备注',
                            name: "REMARK",
                            columnWidth: .66
                        }

                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '',
                    anchor: '100% -100',
                    layout: 'fit',
                    collapsible: false,
                    items: [
                        grid
                    ]
                }
            ]
        });

    }
    
   /**
     * 提交发行手续费缴付数据
     * @param form
     */

     function submitInfo(zqids) {
         var form = Ext.ComponentQuery.query('form[name="sxfjfForm"]')[0];
         var grid = form.down('grid');
         var recordArray = [];
         for ( var i = 0; i < grid.getStore().getCount(); i++) {
             recordArray.push(grid.getStore().getAt(i).getData());
         }
         if (form.isValid()) {
             form.submit({
                 url: "saveFxsxfjf.action",
                 params: {
					 zqids:zqids,
                     recordArray:Ext.util.JSON.encode(recordArray),
                     AD_CODE: AD_CODE,
                     FEE_TYPE:FEE_TYPE
                 },
                 waitTitle: '请等待',
                 waitMsg: '正在保存中...',
                 success: function (form, action) {
                     Ext.MessageBox.show({
                         title: '提示',
                         msg: '保存成功',
                         width: 200,
                         buttons: Ext.MessageBox.OK,
                         fn: function (btn) {
                         	 Ext.ComponentQuery.query('window[itemId="addWin"]')[0].close();
                             reloadGrid();
                         }
                     });
                 },
                 failure: function (form, action) {
                     Ext.MessageBox.show({
                         title: '提示',
                         msg: '保存失败!' + action.result.message,
                         width: 200,
                         fn: function (btn) {
                             Ext.ComponentQuery.query('window[itemId="addWin"]')[0].close();
                             reloadGrid();
                         }
                     });
                 }
             });
         } else {
             Ext.Msg.alert('提示', '请将必填项补充完整！');
         }
     }
     
     function fuc_modifySxf(bill_id){
     	var iWidth = document.body.clientWidth * 0.95;
        var iHeight = document.body.clientHeight * 0.9;//窗口高度

        var modifyWindow = new Ext.Window({
            title: FEE_TYPE == 0 ? "发行手续费缴付":"登记手续费缴付",
            itemId: 'modifyWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            maximizable: true,//最大化按钮
            //autoScroll: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            layout: 'fit',
            items: [initWindow_jf_modify_grid()],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    itemId: 'save_editGrid',
                    name: 'SAVE',
                    handler: function (btn) {
                        updateInfo(bill_id);
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        modifyWindow.show();
     }
     
    function initWindow_jf_modify_grid() {
        /**
         * 手续费生成信息列表表格
         */
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'modifyGrid',
            border: true,
            headerConfig: {
                headerJson: headerJson_jf,
                columnAutoWidth: false
            },
            data:[],
            autoLoad: false,
            height: '100%',
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'modifyGrid_plugin',
                    clicksToMoveEditor: 1
                }
            ],
            pageConfig: {
                enablePage: false
            }
        };
        var grid = simplyGrid.create(config);

        return Ext.create('Ext.form.Panel', {
            name: 'sxfjfModifyForm',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            border: false,
            padding: '0 10 0 10',
            defaultType: 'textfield',
            items: [
                //{ xtype: 'hiddenfield', name: 'userPageMenu.id' },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .33,
                        width: 210,
                        labelWidth: 130//控件默认标签宽度
                    },
                    items: [{
                            xtype: "combobox",
			                name: "ZQ_PC_ID",
			                fieldLabel: '发行批次',
			                store: DebtEleStoreDB('DEBT_ZQPC'),
			                displayField: 'name',
			                valueField: 'id',
			                 hidden:true,
			                lines: false,
			                //allowBlank: false,
			                editable: false,
			                readOnly:true 
                    	},
                        {
                            xtype: "numberFieldFormat",
                            name: "ZQ_BOND_AMT",
                            fieldLabel: '债券总额（元）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "PAY_AMT",
                            fieldLabel: '手续费金额（元）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly: true
                        },
                        {
                            xtype: "datefield",
                            name: "PAY_DATE",
                            fieldLabel: '<span class="required">✶</span>支付日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            value: today,
                            listeners: {
                                change: function (self, newValue) {
                                    var store = DSYGrid.getGrid("modifyGrid").getStore();
                                    var items = store.getData().items;
                                    if (items.length > 0) {
                                        for (var i = 0; i< items.length; i++) {
                                            store.getAt(i).set('PAY_DATE',dsyDateFormat(newValue));
                                        }
                                    }
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '备注',
                            name: "REMARK",
                            columnWidth: .66
                        }

                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '',
                    anchor: '100% -100',
                    layout: 'fit',
                    collapsible: false,
                    items: [
                        grid
                    ]
                }
            ]
        });

    }
    
    /**
 * 删除发行手续费缴付信息
 */
function deleteInfo() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
    	Ext.Msg.confirm('提示','请确认是否删除?',function(btn){
    		if(btn=='yes'){
    			var billInfo = [];
    	        Ext.each(records, function (record) {
    	            var array = {};
    	            array.PAY_BILL_ID = record.get("PAY_BILL_ID");
    	            billInfo.push(array);
    	        });
    	        //向后台传递变更数据信息
    	        Ext.Ajax.request({
    	            method: 'POST',
    	            url: "deleteFxsxfjf.action",
    	            params: {
    	                billInfo: Ext.util.JSON.encode(billInfo)
    	            },
    	            async: false,
    	            success: function (form, action) {
    	                Ext.MessageBox.show({
    	                    title: '提示',
    	                    msg: '删除成功',
    	                    width: 200,
    	                    buttons: Ext.MessageBox.OK,
    	                    fn: function () {
    	                        reloadGrid();
    	                    }
    	                });
    	            },
    	            failure: function (form, action) {
    	                Ext.MessageBox.show({
    	                    title: '提示',
    	                    msg: '删除失败',
    	                    width: 200,
    	                    fn: function () {
    	                        reloadGrid();
    	                    }
    	                });
    	            }
    	        });
    		}
    	});
        
    }
}
    
   /**
     * 提交发行手续费缴付数据
     * @param form
     */

     function updateInfo(bill_id) {
         var form = Ext.ComponentQuery.query('form[name="sxfjfModifyForm"]')[0];
         var grid = form.down('grid');
         var recordArray = [];
         for ( var i = 0; i < grid.getStore().getCount(); i++) {
             recordArray.push(grid.getStore().getAt(i).getData());
         }
         if (form.isValid()) {
             form.submit({
                 url: "updateFxsxfjf.action",
                 params: {
                     recordArray:Ext.util.JSON.encode(recordArray),
					 bill_id:bill_id
                 },
                 waitTitle: '请等待',
                 waitMsg: '正在保存中...',
                 success: function (form, action) {
                     Ext.MessageBox.show({
                         title: '提示',
                         msg: '保存成功',
                         width: 200,
                         buttons: Ext.MessageBox.OK,
                         fn: function (btn) {

                        	 Ext.ComponentQuery.query('window[itemId="modifyWin"]')[0].close();

                             reloadGrid();
                         }
                     });
                 },
                 failure: function (form, action) {
                     Ext.MessageBox.show({
                         title: '提示',
                         msg: '保存失败!' + action.result.message,
                         width: 200,
                         fn: function (btn) {
                             Ext.ComponentQuery.query('window[itemId="modifyWin"]')[0].close();
                             reloadGrid();
                         }
                     });
                 }
             });
         } else {
             Ext.Msg.alert('提示', '请将必填项补充完整！');
         }
     }
/**
 * 缴款
 */
function fuc_jk() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
    	Ext.Msg.confirm('提示','请确认是否缴款?',function(btn){
    		if(btn=='yes'){
    			var billInfo = [];
    	        Ext.each(records, function (record) {
    	            var array = {};
    	            array.PAY_BILL_ID = record.get("PAY_BILL_ID");
    	            billInfo.push(array);
    	        });
    	        //向后台传递变更数据信息
    	        Ext.Ajax.request({
    	            method: 'POST',
    	            url: "fxsxfJk.action",
    	            params: {
    	                billInfo: Ext.util.JSON.encode(billInfo)
    	            },
    	            async: false,
    	            success: function (form, action) {
    	                Ext.MessageBox.show({
    	                    title: '提示',
    	                    msg: '缴款成功',
    	                    width: 200,
    	                    buttons: Ext.MessageBox.OK,
    	                    fn: function () {
    	                        reloadGrid();
    	                    }
    	                });
    	            },
    	            failure: function (form, action) {
    	                Ext.MessageBox.show({
    	                    title: '提示',
    	                    msg: '缴款失败',
    	                    width: 200,
    	                    fn: function () {
    	                        reloadGrid();
    	                    }
    	                });
    	            }
    	        });
    		}
    	});
        
    }
}
     
     
    function reloadGrid(param) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
		var ZQ_PC_ID = Ext.ComponentQuery.query('combobox[name="ZQ_PC_ID"]')[0].value;
        store.getProxy().extraParams['ZQ_PC_ID'] = ZQ_PC_ID;
        store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;
        //刷新
        store.loadPage(1);
        DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
    }
     
</script>
</body>
</html>