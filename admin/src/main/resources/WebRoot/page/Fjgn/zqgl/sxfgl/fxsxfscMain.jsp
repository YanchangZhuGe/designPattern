<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>发行手续费生成</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script> 
    <script src="../data/ele_data.js"></script>
    <!-- 定义控件样式 -->
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body>
<%
    String userCode = (String) request.getSession().getAttribute("USERCODE");//获取登录用户
    String userAD = (String) request.getSession().getAttribute("ADCODE");
%>
<script type="text/javascript">
    /**
     * 获取登录用户
     */
    var userCode = '${sessionScope.USERCODE}';
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var ZQ_ID = '';
    var WF_STATUS = '001';
/*
    var SXFZT = getQueryParam("SXFZT");//0：发行手续费 1：托管手续费
*/
    var SXFZT ="${fns:getParamValue('SXFZT')}";
    var viewflag = false; // 区分生成按钮以及查看按钮
    /**
     * 页面初始化
     */
    $(document).ready(function () {
         initMain();
         initButton();
    });

    /**
     * 主界面初始化
     */
    function initMain() {
        /**
         * 初始化顶部功能按钮
         */
        var tbar = Ext.create('Ext.toolbar.Toolbar', {
            border: false,
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
                    text: '生成',
                    name: 'btn_create',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
	                    if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                            return;
                        }
	                    viewflag = false;
                    	ZQ_ID = records[0].get('ZQ_ID');
                        fuc_sxfCreate();
                        var form = Ext.ComponentQuery.query('form[name="sxfscForm"]')[0];
                        form.getForm().setValues(records[0].data);
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销生成',
                    name: 'btn_cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                    	fuc_cancelSxf();
                    }
                },
                {
                    xtype: 'button',
                    text: '查看',
                    name: 'btn_view',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                    	var records = DSYGrid.getGrid('contentGrid').getSelection();
                    	if (records.length != 1) {
                    		Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                    		return;
                    	}
                    	viewflag = true;
                    	ZQ_ID = records[0].get('ZQ_ID');
                    	fuc_sxfView();
                    	var form = Ext.ComponentQuery.query('form[name="sxfscForm"]')[0];
                        form.getForm().setValues(records[0].data);
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()]
        });


        /**
         * 债券注册信息列表工具栏
         */
        var screenBar = [
            {
                xtype: "combobox",
                name: "WF_STATUS",
                store: DebtEleStore(json_debt_zt8),
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                fieldLabel: '状态',
                editable: false, //禁用编辑
                width: 120,
                labelWidth: 30,
                allowBlank: false,
                labelAlign: 'right',
                listeners: {
                    'select': function (combo, record, index) {
                    	WF_STATUS = record.get('id');
                        initButton();
                        reloadGrid();
                    }
                }
            },{
                xtype : "treecombobox",
                name : "ZQLB_ID",
                store : DebtEleTreeStoreDB('DEBT_ZQLB'),
                displayField : "name",
                valueField : "id",
                fieldLabel : '债券类型',
                editable : false, //禁用编辑
                labelWidth : 60,
                width : 200,
                labelAlign : 'right',
                listeners : {
                    change : function(self, newValue) {
                        //刷新当前表格
                        reloadGrid();
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
                emptyText: '请输入债券名称/债券代码...',
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
        ];

        /**
         * 发行手续费信息列表表头
         */
        var headerJson = [
			{xtype: 'rownumberer',width: 35},
            {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "FIRST_ZQ_ID",
                "type": "string",
                "text": "首次发行债券ID",
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
                "hrefType": "combo",
	            renderer: function (data, cell, record) {
	                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('FIRST_ZQ_ID')+'&AD_CODE='+AD_CODE;
	                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('FIRST_ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
	            }
            },
            {
                "dataIndex": "FX_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "实际发行额(元)"
            },
            {
                "dataIndex": "ZQQX_NAME",
                "width": 150,
                "type": "string",
                "text": "债券期限"
            },
            {
                "dataIndex": "QX_DATE",
                "width": 150,
                "type": "string",
                "text": "起息日",
                "align":'left'
            },
            {
                "dataIndex": "FXSXF_RATE",
                "width": 150,
                "type": "float",
                "text": "发行手续费率(‰)",
                "hidden":( SXFZT == '0') ? false : true
            },
            {
                "dataIndex": "TGSXF_RATE",
                "width": 150,
                "type": "float",
                "text": "登记托管费率(‰)",
                "hidden":( SXFZT == '0') ? true : false
            }

        ];

        /**
         * 发行手续费信息列表表格
         */
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid',
            border: false,
            flex: 4,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getFxsxfMainGridDataForSC.action',
            autoLoad: false,
            params: {
            	WF_STATUS: WF_STATUS,
            	AD_CODE : AD_CODE,
                SXF_TYPE : SXFZT
            },
            height: '100%',
            checkBox: true,
            selModel: {
                mode: "SINGLE"     //是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            pageConfig: {
                pageNum: true// 每页显示数据数
            },
            tbar: screenBar,
            tbarHeight: 50
        };
        var grid = simplyGrid.create(config);

        /**
         * 债券注册录入界面主面板初始化
         */
        var panel = Ext.create('Ext.panel.Panel', {
            renderTo: 'mainDiv',
            layout: 'hbox',
            width: '100%',
            height: '100%',
            border: false,
            items: grid,
            tbar: tbar
        });
    }

    /**
     * 初始化按钮
     */
    function initButton() {
        var combobox_WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0];
        var btn_create = Ext.ComponentQuery.query('button[name="btn_create"]')[0];
        var btn_cancel = Ext.ComponentQuery.query('button[name="btn_cancel"]')[0];
        var btn_view = Ext.ComponentQuery.query('button[name="btn_view"]')[0];
        //根据当前结点状态，控制状态下拉框绑定的json以及按钮的显示与隐藏

        if (combobox_WF_STATUS.value == '001') {
        	btn_create.show();
        	btn_cancel.hide();
        	btn_view.hide();
        }else if (combobox_WF_STATUS.value == '002') {
			btn_create.hide();
			btn_cancel.show();
			btn_view.show();
        } 
        //reloadGrid();
    }

	function fuc_cancelSxf(){
	                   
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
	    if (records.length == 0) {
	        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
	    } else {
		    Ext.MessageBox.show({
	            title: "提示",
	            message:"确定要撤销生成手续费信息吗？",
	            width: 350,
	            buttons: Ext.MessageBox.OKCANCEL,
	            fn: function (btn, text) {
	                audit_info = text;
	                if (btn == "ok") {
						var zqids = new Array();
				        Ext.each(records, function (record) {
				            zqids.push(record.get("ZQ_ID"));
				        });
					    $.post("/cancelFxsxfsc.action", {
				            zqids: zqids,
                            SXF_TYPE : SXFZT
				        }, function (data) {
				            if (data.success) {
				                Ext.toast({
				                    html: data.message,
				                    closable: false,
				                    align: 't',
				                    slideInDuration: 400,
				                    minWidth: 400
				                });
				            } else {
				                Ext.MessageBox.alert('提示', '撤销失败！' + data.message);
				            }
				            //刷新表格
				            reloadGrid();
				        }, "json");

	                }
	            }
	        });
	    
	    }
	}

    /**
     * 发行手续费生成页面
     */
    function fuc_sxfCreate() {
        var iWidth = document.body.clientWidth*0.95;
        var iHeight = document.body.clientHeight*0.9;//窗口高度
        
        var addWindow = new Ext.Window({
            title: ( SXFZT == '0') ? "发行手续费生成" : "登记托管服务费生成",
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
            items: [initWindow_add_grid(false)],
            closeAction: 'destroy',
            buttons:[
                {
                    xtype: 'button',
                    text: '保存',
                    itemId: 'save_editGrid',
                    name: 'SAVE',
                    handler: function (btn) {
                        submitInfo(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '保存并提醒',
                    itemId: 'remind_editGrid',
                    name: 'REMIND',
                    handler: function (btn) {
                        submitInfo(btn);
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
     * 发行手续费生成页面
     */
    function fuc_sxfView() {
        var iWidth = document.body.clientWidth*0.95;
        var iHeight = document.body.clientHeight*0.9;//窗口高度
        var viewWindow = new Ext.Window({
            title: ( SXFZT == '0') ? "发行手续费生成" : "登记托管服务费生成",
            itemId: 'addWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            maximizable: true,//最大化按钮
            buttonAlign: 'right', // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            layout: 'fit',
            items: [initWindow_add_grid(true)],
            closeAction: 'destroy',
            buttons:[
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
        viewWindow.show();
    }

	function initWindow_add_grid(allowBlank){
		 /**
         * 手续费生成信息列表表头
         */
        var headerJson = [
			{xtype: 'rownumberer',width: 40},
            {
                "dataIndex": "CXJG_NAME",
                "type": "string",
                "text": ( SXFZT == '0') ? "承销商" : "托管机构",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "CX_AMT",
                "type": "float",
                "text": ( SXFZT == '0') ? "承销金额（元）" : "发行金额（元）",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "FEE_RATE",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": ( SXFZT == '0') ? "服务费率（‰）" : "手续费率（‰）"
            },
            {
                "dataIndex": "SXF_TYPE",
                "width": 150,
                "type": "string",
                "text": "手续费类型",
                "value": ( SXFZT == '0') ? '发行手续费' : '托管手续费',
                "hidden":true
            },
            {
                "dataIndex": "PLAN_PAY_AMT",
                "width": 150,
                "type": "float",
                "text": "手续费金额（元）"
            }
        ];
        /**
         * 手续费生成信息列表表格
         */
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'createGrid',
            border: true,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getFxsxfDtlGridDataForSC.action',
            autoLoad: true,
            params: {
            	ZQ_ID:ZQ_ID,
            	AD_CODE : AD_CODE,
                SXF_TYPE : SXFZT
            },
            height: '100%',
            pageConfig: {
            	enablePage: false
            }
        };
        var grid = simplyGrid.create(config);
	
	    return Ext.create('Ext.form.Panel', {
	        name: 'sxfscForm',
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
                    items:[{
                        xtype: "textfield",
                        fieldLabel: '债券代码',
                        name: "ZQ_CODE",
                        readOnly:true
                    },
                        {
                            xtype: "textfield",
                            fieldLabel: '债券名称',
                            name: "ZQ_NAME",
                            readOnly:true
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债券期限',
                            name: "ZQQX_NAME",
                            readOnly:true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "FX_AMT",
                            fieldLabel: '发行金额（元）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly:true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "FXSXF_RATE",
                            fieldLabel: '发行手续费率（‰）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly:true,
                            hidden:( SXFZT == '0') ? false : true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "TGSXF_RATE",
                            fieldLabel: '登记托管费率（‰）',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            readOnly:true,
                            hidden: ( SXFZT == '0') ? true : false
                        },
                        {
                            xtype: "datefield",
                            name: "PAY_DATE",
                            fieldLabel: '<span class="required">✶</span>应支付日期',
                            allowBlank: allowBlank ? true:false,
                            format: 'Y-m-d',
                            readOnly: viewflag,
                            value: today
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
      * 提交基本信息数据
      * @param form
      */
     function submitInfo(btn) {
         var form = Ext.ComponentQuery.query('form[name="sxfscForm"]')[0];
         if (form.isValid()) {
             var PAY_DATE = form.getForm().findField('PAY_DATE').getValue();
             form.submit({
                 url: "saveFxsxfSc.action",
                 params: {
					 ZQ_ID:ZQ_ID,
					 AD_CODE:AD_CODE,
					 PAY_DATE:PAY_DATE,
                     USER_CODE:userCode,
                     SXF_TYPE : SXFZT,
                     BTN_NAME: btn.name
                 },
                 waitTitle: '请等待',
                 waitMsg: '正在保存中...',
                 success: function (form, action) {
                     Ext.MessageBox.show({
                         title: '提示',
                         msg: '生成成功',
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
                         msg: '生成失败!' + action.result.message,
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
     
     	function reloadGrid(param, param_detail) {
			var grid = DSYGrid.getGrid('contentGrid');
			var store = grid.getStore();
			//增加查询参数
			if (typeof param != 'undefined' && param != null) {
				for ( var name in param) {
					store.getProxy().extraParams[name] = param[name];
				}
			}
			 var mhcx = Ext.ComponentQuery.query('textfield#mhcx')[0].getValue();
			 var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].value;
	          store.getProxy().extraParams['mhcx'] = mhcx;
	            store.getProxy().extraParams['ZQLB_ID'] = ZQLB_ID;
	            store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;
			//刷新
			store.loadPage(1);
		}
     
</script>

<div id="mainDiv" style="width: 100%; height: 100%;"></div>
</body>
</html>