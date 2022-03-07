$.extend(lxcs_json_common, {
    defautItems: '001',//默认状态
    items_content: function () {
        return [
            initContentTree(),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ];
    },
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '测算',
                name: 'INPUT',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } 
                    
                    zwidsArray = new Array();
                    for(var i = 0; i < records.length ; i++){

                    	zwidsArray[i] = records[i].get("ZW_ID");
                    }
                    window_lxcs.show();
                }
            },
            {
                xtype: 'button',
                text: '全部测算',
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    zwidsArray = new Array();
                    var store = DSYGrid.getGrid('contentGrid').getStore();
                    var i = 0;
                    store.each(function (record) {

                    	zwidsArray[i] = record.get("ZW_ID");
                    	i++;
                    });
                    window_lxcs.show();

                }
            },
            {
                xtype: 'button',
                text: '测算修改',
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                        return;
                    } else {
                        ZW_ID = records[0].get("ZW_ID");
                    }
                    window_lxcs_list_update.show();
                    loadInfo();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});
/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
    var zqlx = Ext.ComponentQuery.query('treecombobox#zqlx')[0].getValue();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        ZWLB_ID:zwlb_id,
        mhcx: mhcx,
        ZQFL_ID: zqlx
    };
    //刷新表格内容
    store.loadPage(1);
}
var window_lxcs = {
	    window: null,
	    config: {
	        closeAction: 'destroy'
	    },
	    show: function () {
	        if (!this.window || this.config.closeAction == 'destroy') {

	                this.window = initWindow_lxcs();
	        }
	        this.window.show();
	        
	        
	    }
	};
function initWindow_lxcs() {

	
    return Ext.create('Ext.window.Window', {
        title: '利息测算', // 窗口标题
        width: 300, // 窗口宽度
        height:130, // 窗口高度
        layout: 'fit',
        itemId: 'window_zqxxtb', // 窗口标识
        maximizable: true,//最大化按钮
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
        items: initWindow_lxcs_contentForm(),
        buttons: [
	            {
	                text: '确定',
	                handler: function (btn) {
	                    //保存表单数据
	                    var form = btn.up('window').down('form');
	                    submitInfo(form);
	                    //btn.up('window').close();
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
function initWindow_lxcs_contentForm() {
    try {
        var editPanel = Ext.create('Ext.form.Panel', {
            width: '100%',
            name: 'endDateForm',
            height: '100%',
            layout: 'anchor',
            defaults: {
                margin: '2 5 2 5'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        //columnWidth: .3,
                        width: 270,
                        labelWidth: 100//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "datefield",
                            name: "END_DATE",
                            fieldLabel: '截止日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            value: today
                        }]
                }]
        });

        return editPanel;
    }
    catch (err) {
        // 当出现异常时，打印控制台异常
        
    }
}
function submitInfo() {

    var form = Ext.ComponentQuery.query('form[name="endDateForm"]')[0];
    var end_date = form.getForm().findField('END_DATE').getValue();
    
    if (form.isValid()) {
        form.submit({
            url: 'getlxcsGrid.action',
            params: {
            	zwids:Ext.util.JSON.encode(zwidsArray),
            	END_DATE: end_date
            },
            waitTitle: '请等待',
            waitMsg: '正在测算中...',
            success: function (form, action) {
            	window_lxcs_list.show();
            	window_lxcs_list.window.down('grid').getStore().removeAll();
            	window_lxcs_list.window.down('grid').insertData(null, action.result.list);
            	window_lxcs.window.close();
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: action.result.message,
                    width: 200,
                    fn: function (btn) {
                    	window_lxcs.window.close();
                        reloadGrid();
                    }
                });
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}
//创建窗体
var window_lxcs_list = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_lxcs_list();
        }
        this.window.show();
    }
};

/**
 * 初始化利息测算结果信息弹出窗口
 */
function initWindow_lxcs_list() {
    return Ext.create('Ext.window.Window', {
        title: '利息测算结果', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        maximizable: true,//最大化按钮
        layout:'fit',
        itemId: 'window_lxcs_list', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_lxcs_list_grid()],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    //获取表格选中数据
                	var lxcsStore = window_lxcs_list.window.down('grid').getStore();
                    var lxcsArray = [];
                    for (var i = 0; i < lxcsStore.getCount(); i++) {
                        var array = {};
                        var record = lxcsStore.getAt(i);
                        array.ZW_ID = record.get("ZW_ID");
                        array.ZW_CODE = record.get("ZW_CODE");
                        array.ZW_NAME = record.get("ZW_NAME");
                        array.AD_CODE = record.get("AD_CODE");
                        array.AG_ID = record.get("AGID");
                        array.AG_CODE = record.get("AGCODE");
                        array.AG_NAME = record.get("AGNAME");
                        array.YFRQ = record.get("YFRQ");
                        array.YFLX_AMT = record.get("YFLX_AMT");
                        lxcsArray.push(array);
                    }
                    
                    $.post("/SaveLxcsResult.action", {
                    	zwids:Ext.util.JSON.encode(zwidsArray),
                    	cslist:Ext.util.JSON.encode(lxcsArray)
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示',  '保存失败！' + data.message);
                            return;
                        }   
                        Ext.MessageBox.alert('提示',  '保存成功！');
                        window_lxcs_list.window.close();
                   
                    }, "json");
                    
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
            	window_lxcs_list.window = null;
            }
        }
    });
}
/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_lxcs_list_grid() {
    var headerJson = [
        {"dataIndex": "ZW_ID", "type": "string", "text": "债务ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AGID", "type": "string", "text": "单位ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AGCODE", "type": "string", "text": "单位编码", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "区划编码", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AGNAME", "type": "string", "text": "债务单位", "fontSize": "15px", "width": 250},
        {
            "dataIndex": "ZW_CODE",
            "type": "string",
            "width": 150,
            "text": "债务编码",
            "hidden":true
        },
        {"dataIndex": "ZW_NAME", "width": 250, "type": "string", "text": "债务名称"},
        {"dataIndex": "SIGN_DATE", "width": 100, "type": "string", "text": "签订日期", "hidden": true},
        {"dataIndex": "BALANCE", "width": 150, "type": "float", "align": 'right', "text": "测算债务余额", "hidden": true},
        {"dataIndex": "YFRQ", "width": 150, "type": "string", "text": "结息日期"},
        {dataIndex: "YFLX_AMT", width: 150, type: "float", tdCls: 'grid-cell',align: 'right',  text: "应付利息金额", 
        	editor:{
		     	   xtype:'numberfield',
		    	   hideTrigger: true
        			}
        },
        {"dataIndex": "JJ_AMT", "width": 150, "type": "float", "align": 'right', "text": "举借总金额", "hidden": true},
        {"dataIndex": "JH_AMT", "width": 150, "type": "float", "align": 'right', "text": "还款计划总金额", "hidden": true},
        {"dataIndex": "LAST_SETTLE_DATE", "width": 150, "type": "string", "text": "上次结息日期"},
        {"dataIndex": "AVG_RATE", "width": 100, "type": "float", "align": 'right', "text": "平均利率", "hidden": true}
    ];  
    var simplyGrid = new DSYGridV2(); 
    var grid = simplyGrid.create({
        itemId: 'grid_lxcs_list',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        plugins: [
	                {
	                    ptype: 'cellediting',
	                    clicksToEdit: 1,
	                    pluginId: 'debt_add_apply_grid_plugin_cell',
	                    clicksToMoveEditor: 1

	                }
	            ],
        pageConfig: {
        	enablePage: false
        },
        data: [],
        autoLoad:false,
        checkBox: true,
        rowNumber: true,
        border: false,
        width:990,
        listeners:{
            'cellclick':function(grid, td , cellIndex , record ,tr ,rowIndex ,e ,eOpts ){
            		
            		var zw_id = record.get("ZW_ID");
            		var arr = [];
            		arr.push(record);
            		for(var i = rowIndex-1 ; i >= 0 ; i--){
            			var tempRecord = grid.getStore().getAt(i);
            			if(zw_id != tempRecord.get("ZW_ID")){
            				break;
            			}
            			arr.push(tempRecord);
            			
            		}
            		for(var j = rowIndex + 1 ; j < grid.getStore().getCount(); j++){
            			var tempRecord = grid.getStore().getAt(j);
            			if(zw_id != tempRecord.get("ZW_ID")){
            				break;
            			}
            			arr.push(tempRecord);
            			
            		}
            		grid.getSelectionModel().select(arr);
            }
        }

    });
 

    return grid;
}

//创建窗体
var window_lxcs_list_update = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_lxcs_list_update();
        }
        this.window.show();
    }
};

/**
 * 初始化利息测算结果信息弹出窗口
 */
function initWindow_lxcs_list_update() {
    return Ext.create('Ext.window.Window', {
        title: '利息测算结果修改', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,//最大化按钮
        itemId: 'window_lxcs_list_update', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_lxcs_list_grid_update()],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    //获取表格选中数据
                	var lxcsStore = window_lxcs_list_update.window.down('grid').getStore();
                    var lxcsArray = [];
                    for (var i = 0; i < lxcsStore.getCount(); i++) {
                        var array = {};
                        var record = lxcsStore.getAt(i);
                        array.YFLX_ID = record.get("YFLX_ID");
                        array.YFLX_AMT = record.get("YFLX_AMT");
                        lxcsArray.push(array);
                    }
                    
                    $.post("/SaveLxcsResultForUpdate.action", {
                    	cslist:Ext.util.JSON.encode(lxcsArray)
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示',  '保存失败！' + data.message);
                            return;
                        }   
                        Ext.MessageBox.alert('提示',  '保存成功！' );
                        window_lxcs_list_update.window.close();
                   
                    }, "json");
                    
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
            	window_lxcs_list_update.window = null;
            }
        }
    });
}
/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_lxcs_list_grid_update() {
    var headerJson = [
      	{
		    xtype: 'rownumberer', width: 40, summaryType: 'count',
		    summaryRenderer: function () {
		        return '合计';
		    }
		}, 
        {"dataIndex": "YFLX_ID", "type": "string", "text": "应付利息ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "ZW_ID", "type": "string", "text": "债务ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AGID", "type": "string", "text": "单位ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AGCODE", "type": "string", "text": "单位编码", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "区划编码", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AGNAME", "type": "string", "text": "债务单位", "fontSize": "15px", "width": 150},
        {
            "dataIndex": "ZW_CODE",
            "type": "string",
            "width": 150,
            "text": "债务编码",
            "hidden":true
        },
        {"dataIndex": "ZW_NAME", "width": 250, "type": "string", "text": "债务名称"},
        {"dataIndex": "SIGN_DATE", "width": 150, "type": "string", "text": "签订日期", "hidden": true},
        {"dataIndex": "BALANCE", "width": 150, "type": "float", "align": 'right', "text": "测算债务余额", "hidden": true},
        {dataIndex: "YFLX_AMT", width: 150, type: "float", tdCls: 'grid-cell',align: 'right',  text: "应付利息金额", 
//        	editor:{
//		     	   xtype:'numberfield',
//		    	   hideTrigger: true
//        			} ,
	        summaryType: 'sum',
	        summaryRenderer: function (value) {
	            return Ext.util.Format.number(value, '0,000.00');
	        }
        },
        {"dataIndex": "JJ_AMT", "width": 150, "type": "float", "align": 'right', "text": "举借总金额", "hidden": true},
        {"dataIndex": "JH_AMT", "width": 150, "type": "float", "align": 'right', "text": "还款计划总金额", "hidden": true},
        {"dataIndex": "YFRQ", "width": 150, "type": "string", "text": "本次结息日期"},
        {"dataIndex": "IS_YDCH", "width": 150, "type": "string", "text": "是否已支付利息", "hidden": true}
    ];  
    var simplyGrid = new DSYGridV2(); 
    var grid = simplyGrid.create({
        itemId: 'grid_lxcs_list_update',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        plugins: [
	                {
	                    ptype: 'cellediting',
	                    clicksToEdit: 1,
	                    pluginId: 'debt_add_apply_grid_plugin_cell',
	                    clicksToMoveEditor: 1,
	                    listeners: {
		                	 'beforeedit': function (editor, context) { 
		                		  //偿还资金来源关联关系设置
		                	       if(context.field == 'YFLX_AMT' && context.record.get('IS_YDCH') == '1'){ 
		                	    	   return false;
		                	       } 

		                     }
		                }

	                }
	            ],
        pageConfig: {
        	enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],
        data: [],
        autoLoad:false,
        checkBox: true,
        rowNumber: true,
        border: false,
        width:990 
    }); 
    return grid;
}


function loadInfo() {
    $.post("/GetlxcsGridForUpdate.action", {
    	ZW_ID:ZW_ID
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示',  '加载失败！' + data.message);
            return;
        }     
        window_lxcs_list_update.window.down('grid').getStore().removeAll();
        window_lxcs_list_update.window.down('grid').insertData(null, data.list);
    }, "json");
}