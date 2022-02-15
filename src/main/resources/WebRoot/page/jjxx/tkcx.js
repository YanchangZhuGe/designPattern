/**
 * js：置换债券申报
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
$.extend(hbfx_json_common[wf_id][node_type], {
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
                    if (AG_CODE == null || AG_CODE == '') {
                        Ext.Msg.alert('提示', '请选择单位！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/detail.png',
                handler: function (btn) {
                    dooperation();
                }
            },
            {
            	  xtype: 'button',
            	  id:'xiugai',
                  text: '修改',
                  icon: '/image/sysbutton/edit.png',
                  hidden:true,
                  handler: function (btn) {
                      // 检验是否选中数据
                      // 获取选中数据
                  	OPERATE = 'UPDATE';
                      var records = DSYGrid.getGrid('contentGrid').getSelection();
                      if (records.length != 1) {
                          Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                          return;
                      }
                      button_name = btn.text;
                      //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                      ZW_ID = records[0].get('ZW_ID');
                  	  ZW_CODE = records[0].get('ZW_CODE');
                  	  ZW_NAME = records[0].get('ZW_NAME');
                      init_edit_jjxx(btn);
                  }
            }
        ],
        '002': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AG_CODE == null || AG_CODE == '') {
                        Ext.Msg.alert('提示', '请选择单位！');
                        return;
                    } else {
                    	getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '打印',
                icon: '/image/sysbutton/print.png'
            }
        ],
        '004': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AG_CODE == null || AG_CODE == '') {
                        Ext.Msg.alert('提示', '请选择单位！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                	OPERATE = 'UPDATE';
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                    ZW_ID = records[0].get('ZW_ID');
                	ZW_CODE = records[0].get('ZW_CODE');
                	ZW_NAME = records[0].get('ZW_NAME');
                    init_edit_jjxx(btn);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            button_name = btn.text;
                            var ids = new Array();
                            for (var i in records) {
                                ids.push(records[i].get("JJXX_ID"));
                            }
                            //发送ajax请求，删除数据
                            $.post("/delJjxx.action", {
                                ids: ids
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: button_name + "成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                } else {
                                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                }
                                //刷新表格
                                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                            }, "json");
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '打印',
                icon: '/image/sysbutton/print.png'
            }
        ]
    }
});

//新增时举借信息id，用于保存附件
var new_jjxx_id='';

/*
 * 操作记录
 */
function dooperation(){
	var records= DSYGrid.getGrid('contentGrid').getSelection();
	if(records.length==0){
		Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
	}else if(records.length>1){
		Ext.MessageBox.alert('提示', '不能同时对多比数据进行操作');
	}else{
		var jjxx_id=records[0].get('JJXX_ID');
		fuc_getWorkFlowLog(jjxx_id);
	}
}

/**
 * 查询按钮实现
 */
function getHbfxDataList() {
	var store = DSYGrid.getGrid('contentGrid').getStore();
    var xm_name = Ext.ComponentQuery.query("textfield#XM_NAME")[0].getValue();
    var zqlx = Ext.ComponentQuery.query("treecombobox#zqlx")[0].getValue();
    //WF_STATUS=Ext.ComponentQuery.query("combobox#contentGrid_status")[0].getValue();
    
    store.getProxy().extraParams = {
    	wf_id:wf_id,
    	node_code:node_code,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        ZQFL_ID: zqlx,
        xm_name:xm_name,
        WF_STATUS:WF_STATUS,
        zwlb_id:zwlb_id
    };
    store.loadPage(1);
}

/**
 * 查询债务信息
 */
function getzwxxList(){
	var store = DSYGrid.getGrid('zwxxListgird').getStore();
	var zw_name = DSYGrid.getGrid('zwxxListgird').down('textfield#zw_name').getValue();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        zw_name: zw_name,
        zwlb_id:zwlb_id
    };
    store.loadPage(1);
}

//创建选择到期债务(有计划)弹出窗口
var window_dqzw_yjh = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_dqzw_yjh();
        }
        this.window.show();
    }
};
//创建选择到期债务(无计划)弹出窗口
var window_dqzw_wjh = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_dqzw_wjh();
        }
        this.window.show();
    }
};
//创建新增偿还资金申请单弹出窗口
var window_debt_add_apply = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_debt_add_apply();
        }
        this.window.show();
    }
};

/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40
        },
//        {dataIndex: "PAT_DATE", width: 250, type: "string", text: "申请日期"},
//        {dataIndex: "AG_NAME", width: 250, type: "string", text: "单位名称"},
//        {dataIndex: "PAT_AMT_RMB", width: 250, type: "float", text: "申请金额"},
//        {dataIndex: "REMARK", width: 250, type: "string", text: "备注"}
        {
	        "dataIndex" : "JJXX_ID", "type" : "string", "text" : "举借ID", "fontSize" : "15px", "hidden" : true 
	    },
		{
	        "dataIndex" : "ZW_ID", "type" : "string", "text" : "债务ID", "fontSize" : "15px", "hidden" : true 
	    },
	    {
	        "dataIndex" : "ZW_CODE", "type" : "string", "text" : "债务编码", "fontSize" : "15px", "hidden" : true 
	    },
	    {
	        "dataIndex" : "JJXX_CODE", "type" : "string", "text" : "申请单号", "fontSize" : "15px", "width" : 200 
	    },
	    {
	        "dataIndex" : "AG_NAME", "type" : "string", "text" : "债务单位", "fontSize" : "15px", "width" : 200 
	    },
	    {
	        "dataIndex" : "ZW_NAME", "width" : 200, "type" : "string", "text" : "债务名称" 
	    },
	    {
	        "dataIndex" : "XM_NAME", "width" : 200, "type" : "string", "text" : "建设项目" 
	    },
	    {
	        "dataIndex" : "JZ_DATE", "width" : 150, "type" : "string", "text" : "记账日期" 
	    },
	    {
	        "dataIndex" : "FETCH_DATE", "width" : 150, "type" : "string", "text" : "提款日期" 
	    },
	    {
	        "dataIndex" : "FETCH_AMT", "width" : 150, "type" : "float", "text" : "提款金额(原币)" 
	    },
	    {
	        "dataIndex" : "XY_AMT", "width" : 150, "type" : "float", "text" : "协议金额(原币)" 
	    },
	    {
	        "dataIndex" : "SIGN_DATE", "width" : 150, "type" : "string", "text" : "签订日期" 
	    },
	    {
	        "dataIndex" : "ZJYT_NAME", "width" : 300, "type" : "string", "text" : "债务资金用途" 
	    },
	    {
	        "dataIndex" : "ZQLX_NAME", "width" : 100, "type" : "string", "text" : "债权类型" 
	    },
	    {
	        "dataIndex" : "ZQR_NAME", "width" : 100, "type" : "string", "text" : "债权人" 
	    },
	    {
	        "dataIndex" : "ZQR_FULLNAME", "width" : 150, "type" : "string", "text" : "债权人全称" 
	    },
	    {
	    	"dataIndex" : "TZBS", "width" : 150, "type" : "string", "text" : "调整标识",
	    	 renderer: function (value) {
                 var store = DebtEleStore(json_debt_tzbs);
                 var record = store.findRecord('code', value, 0, false, true, true);
                 return record != null ? record.get('name') : value;
             }
	    },
	    {
	        "dataIndex" : "REMARK", "width" : 150, "type" : "string", "text" : "备注" 
	    }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        rowNumber: true,
        border: false,
        height: '50%',
        flex: 1,
        tbarHeight: 50,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            zwlb_id:zwlb_id
        },
        dataUrl: 'getJjxxList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners : {
        	'rowdblclick':function(){
                 	OPERATE = 'UPDATE';
                    var records = DSYGrid.getGrid('contentGrid').getSelection();

                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                    new_jjxx_id=records[0].get('JJXX_ID');
                    ZW_ID = records[0].get('ZW_ID');
                	ZW_CODE = records[0].get('ZW_CODE');
                	ZW_NAME = records[0].get('ZW_NAME');
            		var bb=Ext.ComponentQuery.query("button#xiugai")[0];
                    button_name = bb.text;
                    init_edit_jjxx(bb);
                    Ext.getCmp('save').setDisabled(true);
        	}
        }  	
    });
}

//创建存量债务弹出窗口
var window_clzw = {
    window: null,
    btn:null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config,btn) {
        $.extend(this.config, config);
        if (!this.window || this.config.closeAction == 'destroy') {
            this.window = initWindow_clzw(this.config,this.btn);
        }
        this.window.show();
    }
};

/**
 * 初始化存量债务弹出窗口
 */
function initWindow_clzw(config,btn) {
	var btn_name=btn.text
	if (btn_name=='提款申请'){
		OPERATE = 'INSERT';
	}else if (btn_name=='修改'){
		OPERATE = 'UPDATE';
	}
	
    return Ext.create('Ext.window.Window', {
        title: '债务信息', // 窗口标题
        width: document.body.clientWidth*0.9, // 窗口宽度
        height: document.body.clientHeight*0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_clzw', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: config.closeAction,
        items: [initWindow_clzw_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                	init_edit_jjxx(btn);
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
 * 初始化到期债务(有计划)弹出窗口
 */
function initWindow_dqzw_yjh() {
    return Ext.create('Ext.window.Window', {
        title: '到期债务(有计划)', // 窗口标题
        width: document.body.clientWidth*0.9, // 窗口宽度
        height: document.body.clientHeight*0.9, // 窗口高度
        itemId: 'window_dqzw_yjh', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_dqzw_yjh_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    //关闭当前窗口，打开偿还资金录入窗口
                    window_debt_add_apply.show();
                    btn.up('window').close();
                    
                    var sbGridStore=window_debt_add_apply.window.down('grid').getStore(); 
                    //偿还资金录入窗口表格增加行 
                    for (var record_seq in records) {
                        // 创建行model实例 
                    	// alert(7777777);
                        //var row = Ext.create('row_edit_demo', records[record_seq].getData());
                       // alert(888888888);
                      //  window_debt_add_apply.window.down('grid').getStore().insert(0, row);
                    	//如果申报主表明细中已存在该数据，不插入 
                    	 var record_data = records[record_seq].getData();
                        sbGridStore.insert(record_seq, record_data); 
                    }
                   
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_dqzw_yjh.window = null;
            }
        }
    });
}

/**
 * 初始化存量债务弹出框表格
 */
function initWindow_clzw_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {"dataIndex": "ZW_ID", "type": "string", "text": "债务ID", "hidden": true},
        {"dataIndex": "AG_NAME", "type": "string", "text": "债务单位", "width": 200},
        {"dataIndex": "XM_NAME", "type": "string", "text": "建设项目", "width": 200},
        {"dataIndex": "SIGN_DATE", "width": 100, "type": "string", "text": "签订日期"},
        {"dataIndex": "ZW_XY_NO", "width": 100, "type": "string", "text": "协议号"},
        {"dataIndex": "ZW_NAME", "width": 150, "type": "string", "text": "债务名称"},
        {"dataIndex": "ZQR_NAME", "width": 100, "type": "string", "text": "债权人"},
        {"dataIndex": "XY_AMT", "width": 100, "type": "float", "text": "协议金额", "align": "right"},
        {"dataIndex": "FETCH_AMT", "width": 100, "type": "float", "text": "已申请金额", "align": "right"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zwxxListgird',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: false,
        checkBox: true,
        selModel: {
            mode: "SINGLE"
        },
        height: '100%',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        params: {
            AG_CODE: AG_CODE
        },
        border: false,
        dataUrl: '/getzwxxList.action'
    });
    //将form添加到表格中
    var searchTool = initWindow_clzw_grid_searchTool();
    grid.addDocked(searchTool, 0);
    $.extend(grid.getStore().getProxy().extraParams, grid.down('form').getValues());
    grid.getStore().getProxy().extraParams["AG_ID"] = AG_ID;
    grid.getStore().getProxy().extraParams["zwlb_id"] = zwlb_id;
    grid.getStore().loadPage(1);
    return grid;
}
/*function initWindow_clzw_grid() {
    var headerJson =
        {
            "header" : [
                {
                    "dataIndex" : "ZW_ID", "type" : "string", "text" : "债务ID", "fontSize" : "15px", "hidden" : true
                },
                {
                    "dataIndex" : "AG_NAME", "type" : "string", "text" : "债务单位", "fontSize" : "15px", "width" : 200
                },
                {
                    "dataIndex" : "XM_NAME", "type" : "string", "text" : "建设项目", "fontSize" : "15px", "width" : 200
                },
                {
                    "dataIndex" : "SIGN_DATE", "width" : 100, "type" : "string", "text" : "签订日期"
                },
                {
                    "dataIndex" : "ZW_XY_NO", "width" : 100, "type" : "string", "text" : "协议号"
                },
                {
                    "dataIndex" : "ZW_NAME", "width" : 150, "type" : "string", "text" : "债务名称"
                },
                {
                    "dataIndex" : "ZQR_NAME", "width" : 100, "type" : "string", "text" : "债权人"
                },
                {
                    "dataIndex" : "XY_AMT", "width" : 100, "type" : "float", "text" : "协议金额", "align" : "right"
                },
                {
                    "dataIndex" : "FETCH_AMT", "width" : 100, "type" : "float", "text" : "已申请金额", "align" : "right"
                }
            ]
        };
    var simplyGrid = new DSYGrid();
    simplyGrid.setItemId('zwxxListgird');
    simplyGrid.setHeaderJson(headerJson);
    simplyGrid.setColumnAutoWidth(false);
    simplyGrid.setAutoLoad(false);
    simplyGrid.setCheckBox(true);//显示复选框
    simplyGrid.setSelModel({
        mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
    });
    simplyGrid.setRowNumber(true);//显示行号
    simplyGrid.setHeight("100%");//设置高度后，当行数超出高度时出现滚动条
    simplyGrid.setPageConfig({
        pageNum: true//设置显示每页条数
    });
    simplyGrid.setParams({
        AG_CODE: AG_CODE
    });
    simplyGrid.setBorder(false);//不显示边界
    simplyGrid.setDataUrl('getzwxxList.action');
    var grid = simplyGrid.create();
    //将form添加到表格中
    var searchTool = initWindow_clzw_grid_searchTool();
    grid.addDocked(searchTool, 0);
    $.extend(grid.getStore().getProxy().extraParams, grid.down('form').getValues());
    DSYGrid.getGrid('zwxxListgird').getStore().getProxy().extraParams["AG_ID"] = AG_ID;
    DSYGrid.getGrid('zwxxListgird').getStore().getProxy().extraParams["zwlb_id"] = zwlb_id;
    grid.getStore().loadPage(1);
    return grid;
}*/
/**
 * 初始化存量债务弹出框搜索区域
 */
function initWindow_clzw_grid_searchTool() {
        //初始化查询控件
        var items = [];
        items.push(
            {
		        xtype: "textfield",
		        fieldLabel: '债务单位',
		        itemId: "ag_name",
		        value:AG_NAME,
		        width: 200,
		        labelWidth: 60,
		        labelAlign: 'right',
		        editable:false,
		        readOnly:true
		    },
		    {
		        xtype: "textfield",
		        itemId: "zw_name",
		        fieldLabel: '债务名称',
		        labelWidth: 60,
		        labelAlign: 'right',
		        listeners: {
		
				}
		    }
        );
        //设置查询form
        var searchTool = new DSYSearchTool();
        searchTool.setSearchToolId('searchTool_grid');
        var search_form = searchTool.create({
            items: items,
            border: true,
            bodyStyle: 'border-width:0 0 0 0;',
            dock: 'top',
            defaults: {
                labelWidth: 60,
                width: 200
            },
            // 查询按钮回调函数
            callback: function (self) {
                var store = self.up('grid').getStore();
                // 清空参数中已有的查询项
                for (var search_form_i in self.getValues()) {
                    delete store.getProxy().extraParams[search_form_i];
                }
                // 向grid中追加参数
                $.extend(true, store.getProxy().extraParams, self.getValues());
                // 刷新表格
                store.loadPage(1);
            }
        });
        //重新加载按钮
         search_form.remove(search_form.down('toolbar'));
        search_form.addDocked({
            xtype: 'toolbar',
            border: false,
            width: 140,
            dock: 'right',
            layout: {
                type: 'hbox',
                align: 'center',
                pack : 'start'
            },
            items: [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var form = btn.up('form');
                        if (form.isValid()) {
                            search_form.callback(form);
                            getzwxxList();
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
                    }
                },
                '->',{
                    xtype: 'button',
                    text: '重置',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        var form = btn.up('form');
                        form.reset();
                    }
                }
            ]
        });
        return search_form;
}

function init_edit_jjxx(btn){
	var btn_name=btn.text
	if (btn_name=='确认'){
                //获取表格选中数据
                var records = btn.up('window').down('grid').getSelection();
                if (records.length <= 0) {
                    Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
                    return;
                }
                btn.up('window').close();
            ZW_ID = records[0].get('ZW_ID');
            ZW_CODE = records[0].get('ZW_CODE');
            ZW_NAME = records[0].get('ZW_NAME');
	}else if (btn_name=='修改'){
			var records = DSYGrid.getGrid('contentGrid').getSelection();
			 if (records.length <= 0 || records.length > 1) {
                    Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
                    return;
             }
	}
            var dialog_job = Ext.create('Ext.window.Window', {
                title: "增加提款申请单-"+AG_NAME,
                itemId: 'jjxxadd',
                width: document.body.clientWidth*0.9, // 窗口宽度
                height: document.body.clientHeight*0.9, // 窗口高度
                frame: true,
                constrain: true,
                buttonAlign: "left",
                // 按钮显示的位置
                modal: true,
                resizable: false,
                plain: true,
                closeAction: 'destroy',
                items: [initEditor(btn),initTabPanel()],
                buttons:['->',
				{
    	            xtype: 'button',
    	            text: '保存送审',
    	            scale:'medium',
    	            name: 'btn_insert',
    	            hidden:true,
    	            handler: function (btn) {
    	            	var form = btn.up('form#jjxxaddform');
    	            	submitInfo(form);
    	            }
    	        },
                {
                    xtype: 'button',
                    id:'save',
                    text: '保存',
                    scale:'medium',
                    name: 'btn_update',
                    handler: function (btn) {
                    	var form = btn.up('window').down('form');
    	            	submitInfo(form,btn);
    	            }
                },
                {
                    xtype: 'button',
                    text: '关闭',
                    scale:'medium',
                    name: 'btn_delete',
                    //icon:'../../../image/button/field_drop24_h.png', 
                    handler: function (btn) {
                    		Ext.ComponentQuery.query('window#jjxxadd')[0].close();
                    }
                }
				]
            });
            dialog_job.show();
}

function submitInfo(form,btn) {
	
	var XY_AMT= form.getForm().findField('XY_AMT');
	var IS_FETCH_AMT= form.getForm().findField('IS_FETCH_AMT');
	var FETCH_AMT= form.getForm().findField('FETCH_AMT');
	var ZJLY_ID= form.getForm().findField("ZJLY_ID");
	var FETCH_DATE=form.getForm().findField('FETCH_DATE');
//	alert(ZJLY_ID.getValue());
	if (parseFloat(FETCH_AMT.getValue())==0)
	{
		Ext.Msg.alert('提示', '提款金额必须大于0！');
		return;
	}
	if (IS_FETCH_AMT.getValue()+ FETCH_AMT.getValue()>XY_AMT.getValue())
	{
		Ext.Msg.alert('提示', '提款金额加已申请金额，不能大于协议金额！');
		return;
	}
	
	var url = '';
	if (OPERATE=='INSERT'){
		url = 'insertjjxx.action?AD_CODE='+AD_CODE+'&AG_ID='+AG_ID+'&AG_NAME='+AG_NAME+'&AG_CODE='+AG_CODE+'&ZW_ID='+ZW_ID+'&ZW_CODE='+ZW_CODE+'&ZW_NAME='+ZW_NAME+'&wf_id='+wf_id+'&node_code='+node_code+'&button_name='+btn.text;
	} else {
		var JJXX_ID= form.getForm().findField('JJXX_ID');
		url = 'updatejjxx?AD_CODE='+AD_CODE+'&AG_ID='+AG_ID+'&AG_NAME='+AG_NAME+'&AG_CODE='+AG_CODE+'&ZW_ID='+ZW_ID+'&ZW_CODE='+ZW_CODE+'&ZW_NAME='+ZW_NAME+'&wf_id='+wf_id+'&node_code='+node_code+'&button_name='+btn.text+'&JJXX_ID='+JJXX_ID.getValue() ;
	}
	//获取提款申请主信息
	var paramsHash = {};
	
	//封装还款计划信息
	var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
	var yflxStore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
	
	for(var i=0;i<hkjhStore.getCount();i++)
	{
		//alert(hkjhStore.getAt(i).get('HKJH_DATE'));
		if(hkjhStore.getAt(i).get('HKJH_DATE')<FETCH_DATE.getValue())
		{
			Ext.Msg.alert('提示', '计划还款日期不能早于举借提款日期!');
			return;
		}
	}
	
	var count=0;
	var sum_RMB = 0;
	hkjhStore.each(function(record){
            var datas = record.data;
            var index = "[hkjh"+count+"]";

		if (datas['HKJH_AMT']==null || datas['HKJH_AMT']==0){
			Ext.Msg.alert('提示', '计划偿还金额(原币)必须大于0！');
			return;
		}
		
		sum_RMB += datas['HKJH_AMT'];
		for(hashKey in datas)
			{
                var newHashKey = hashKey+index;               
                paramsHash[newHashKey] = datas[hashKey];  
            }
		count++;
        });     
	paramsHash['hkjhcount']=count;
	if(FETCH_AMT.getValue() != sum_RMB ){
		Ext.Msg.alert('提示', '计划偿还金额(原币)必须等于提款金额(原币)！');
		return;
	}
	
	for(var i=0;i<yflxStore.getCount();i++)
	{
		//alert(hkjhStore.getAt(i).get('HKJH_DATE'));
		if(yflxStore.getAt(i).get('YFRQ')<FETCH_DATE.getValue())
		{
			Ext.Msg.alert('提示', '计划还款日期不能早于举借提款日期!');
			return;
		}
	}
	
	//封装应付利息信息
	count=0;
	
	var yflxStore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
	yflxStore.each(function(record){
            var datas = record.data;
            var index = "[yflx"+count+"]";
		if (datas['YFLX_AMT']==null || datas['YFLX_AMT']==0){
			Ext.Msg.alert('提示', '应偿还金额必须大于0！');
			return;
		}
            for(hashKey in datas)
            {
                var newHashKey = hashKey+index;               
                paramsHash[newHashKey] = datas[hashKey];          
            }
		count++;
        });  
	paramsHash['yflxcount']=count;
    var formValues = form.getValues();
    for (var attr in formValues) {
        paramsHash[attr] = formValues[attr];
    }
    if (form.isValid()) {
    	form.submit({
    		url: url,
    		params : {detailForm: Ext.util.JSON.encode([paramsHash])},
    	    waitTitle:'请等待',
    	    waitMsg:'正在加载中...',
        	success: function(form, action,btn) {
            	Ext.MessageBox.show({
    				title: '提示',
    				msg: '提交成功',
    				width: 200,
    				buttons: Ext.MessageBox.OK,
    				fn: function (btn) {
    					DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
						Ext.ComponentQuery.query('window#jjxxadd')[0].close();
    				}
				});
            },
            failure: function(form, action,btn) {
            	Ext.MessageBox.show({
    				title: '提示',
    				msg: '提交失败',
    				width: 200,
    				fn: function (btn) {
    					Ext.ComponentQuery.query('window#jjxxadd')[0].close();
    				}
				});
            }
    	});
    } else {
   		Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}

/**
 * 初始化举借录入页签panel的附件页签
 */
function initWin_ZwqxTabPanel_Zhzq_Fj() {
    var grid = UploadPanel.createGrid({
        busiType: 'ET102',
        busiId: new_jjxx_id,
        editable: false
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
        if (grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    
    if(btn.text=='送审'){
    	if(records.length>1){
    		Ext.MessageBox.alert('提示', '送审只能选择一条数据进行操作');
    		return;
    	}
    }
    
    var ids = new Array();
    for (var i in records) {
        ids.push(records[i].get("JJXX_ID"));
    }
    button_name = btn.text;
    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text,
        animateTarget: btn,
        fn: function (buttonId, text, opt) {
            if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/updateJJxxNode.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: text,
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                    //刷新表格
                    DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                }, "json");
            }
        }
    });    
}


//举借初始化
function initEditor(btn){
    	var content = [{
                xtype: 'fieldset',
                title: '提款信息',
                layout: 'anchor',
                width:"100%",
                margin: '0 2 0 2',
                //collapsible: true,
                defaults: {
                	anchor:'100%',
                	border : false,
                	margin: '0 10 0 0'
               	},
               	listeners:{
                    'collapse':function(){
                    }
    	    	},
    	    	items: [{//第一行
    	    		xtype:'container',
    	    		layout: {
    	    	        type: 'column'
    	    	    },
                    defaults: {
                        columnWidth: .33,
                    	margin: '2 0 2 0',
                    	labelAlign: 'right',
                    	labelWidth: 140,
                    	allowBlank: true
                    },
    	    		items:[
    	    		{
       	                xtype: "textfield", 
       	                fieldLabel:'举借id', 
       	                name: "JJXX_ID", 
       	                editable:false,
       	                hidden:true
                    },{
       	                xtype: "textfield", 
       	                fieldLabel:'债务名称', 
       	                name: "ZW_AG_NAME", 
       	                editable:false
                    },
                    {
                        xtype: "textfield",
    	                name:"SIGN_DATE",
    	                fieldLabel: '签订日期',
    	                editable:false
                    }
                    ]
    	    	},{//第二行
    	    		xtype:'container',
    	    		layout: {
    	    	        type: 'column'
    	    	    },
                    defaults: {
                        flex:1,
                        columnWidth: .33,
                    	margin: '2 0 2 0',
                    	labelAlign: 'right',
                    	labelWidth: 140,
                    	allowBlank: true
                    },
    	    		items:[
    	    		{
           	            xtype: "numberfield", 
       	                name: "XY_AMT",
       	                fieldLabel:'协议金额(原币)', 
       	                emptyText: '0.00',
       	                allowDecimals: true,
       	                decimalPrecision: 6,
       	                hideTrigger: true,  
    					keyNavEnabled: true,  
     					mouseWheelEnabled: true,
     					plugins:Ext.create('Ext.ux.FieldStylePlugin',{}),
     					editable:false
                    },{
                    	xtype: "numberfield", 
       	                name: "IS_FETCH_AMT",
       	                fieldLabel:'已申请金额(原币)', 
       	                emptyText: '0.00',
       	                allowDecimals: true,
       	                decimalPrecision: 2,
       	                hideTrigger: true,  
    					keyNavEnabled: true,  
     					mouseWheelEnabled: true,
     					plugins:Ext.create('Ext.ux.FieldStylePlugin',{}),
     					editable:false
                    	
                    },{
       	                xtype: "textfield", 
       	                name: "zw_remark",
       	                fieldLabel:'债务备注', 
       	                allowBlank:true,
       	                editable:false
                    }
                    ]
    	    	},
    	    	
    	    	{//第三行
    	    		xtype:'container',
    	    		layout: {
    	    	        type: 'column'
    	    	    },
                    defaults: {
                        flex:1,
                        columnWidth: .33,
                    	margin: '2 0 2 0',
                    	labelAlign: 'right',
                    	labelWidth: 140,
                    	allowBlank: true
                    },
    	    		items:[ {
                    	xtype: "datefield",
    	                name:"FETCH_DATE",
    	                fieldLabel: '<font color="red">✶</font>提款日期',
    	                allowBlank: false,
    	                format:'Y-m-d',  
    	                blankText: '请选择提款日期',
    	                emptyText: '请选择提款日期',
    	                value : today,
           				listeners:{
           	                'select': function(){
           	                 }
           	            }
                    },{
                        xtype: "textfield", 
           				name: "TKPZ_NO",
           				//store: DebtEleStore(json_debt_zwlb),
           				displayField: "name",
           				valueField: "id", 
           				fieldLabel: '<font color="red">✶</font>提款凭证号', 
           				allowBlank: false,
           				listeners:{
           	                'select': function(){
           	                 }
           	            }
                    },{
                        xtype: "combobox",
                        name: "TZBS_ID",
                        store: DebtEleStore(json_debt_tzbs),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<font color="red">✶</font>调整标识',
                        allowBlank: false,
                        editable: false //禁用编辑             	
                    },{
       	                xtype: "textfield", 
           				name: "FM_ID",
           				fieldLabel: "币种", 
           				editable:false,
           				hidden: true
           				}]
    	    	},{//第四行
    	    		xtype:'container',
    	    		layout: {
    	    	        type: 'column'
    	    	    },
                    defaults: {
                        flex:1,
                        columnWidth: .33,
                    	margin: '2 0 2 0',
                    	labelAlign: 'right',
                    	labelWidth: 140,
                    	allowBlank: true
                    },
    	    		items:[{
                        xtype: "numberfield", 
       	                name: "HL_RATE",
       	                fieldLabel:'<font color="red">✶</font>汇率', 
       	                value:1.000000,
       	                allowBlank: false,
       	                allowDecimals: true,
       	                decimalPrecision: 6,
       	                hideTrigger: true,  
    					keyNavEnabled: true,  
     					mouseWheelEnabled: true,
     					plugins:Ext.create('Ext.ux.FieldStylePlugin',{}),
     					listeners: {
				            change: function(value) {
				            	//计算提款人民币金额
				            	value.up('container').down("numberfield[name='FETCH_AMT_RMB']").setValue(value.getValue()*value.up('container').down("numberfield[name='FETCH_AMT']").getValue());
				            }
				        }
                    },{
                    	xtype: "numberfield", 
       	                name: "FETCH_AMT",
       	                fieldLabel:'<font color="red">✶</font>提款金额（原币）', 
       	                emptyText: '0.00',
       	                allowDecimals: true,
       	                allowBlank: false,
       	                value:0,
       	                decimalPrecision: 6,
       	                hideTrigger: true,  
    					keyNavEnabled: true,  
     					mouseWheelEnabled: true,
     					plugins:Ext.create('Ext.ux.FieldStylePlugin',{}),
     					emptyText: '请输入提款原币' ,
     					listeners: {
				            change: function(value) {
				            	//计算提款人民币金额
				            	value.up('container').down("numberfield[name='FETCH_AMT_RMB']").setValue(value.getValue()*value.up('container').down("numberfield[name='HL_RATE']").getValue());
				            }
				        }
                    },{
       	                xtype: "numberfield", 
       	                name: "FETCH_AMT_RMB",
       	                fieldLabel:'提款金额（人民币）', 
       	                emptyText: '0.00',
       	                value:0,
       	                allowDecimals: true,
       	                decimalPrecision: 6,
       	                hideTrigger: true,  
    					keyNavEnabled: true,  
     					mouseWheelEnabled: true,
     					editable:false,
     					plugins:Ext.create('Ext.ux.FieldStylePlugin',{})
                    }]
    	    	},{//第六行
    	    		xtype:'container',
    	    		layout: {
    	    	        type: 'column'
    	    	    },
                    defaults: {
                        flex:1,
                        columnWidth: .33,
                    	margin: '2 0 2 0',
                    	labelAlign: 'right',
                    	labelWidth: 140,
                    	allowBlank: true
                    },
    	    		items:[
    	    		{
       	                xtype: "treecombobox", 
           				name: "ZJLY_ID",
           				store: DebtEleTreeStoreDB('DEBT_CHZJLY'),
           				displayField: "name",
           				valueField: "id", 
           				fieldLabel: '<font color="red">✶</font>偿还资金来源', 
           				editable:false,
           				selectModel: 'leaf',
           				allowBlank: false,
           				listeners:{
           	                'select': function(){
           	                 }
           	            }
                    },{
                    	xtype: "datefield",
    	                name:"JZ_DATE",
    	                fieldLabel: '<font color="red">✶</font>记账日期',
    	                allowBlank: false,
    	                format:'Y-m-d',  
    	                blankText: '请选择记账日期',
    	                emptyText: '请选择记账日期',
    	                value : today
                    }
                    ]
    	    	},
    	    		{//第七行
    	    		xtype:'container',
    	    		layout: {
    	    	        type: 'column'
    	    	    },
    	    	    defaults: {
                        flex:1,
                        columnWidth: .33,
                    	margin: '2 0 2 0',
                    	labelAlign: 'right',
                    	labelWidth: 140,
                    	allowBlank: true
    	    	    },
    	    		items:[
    	    		 {
       	                xtype: "textfield", 
       	                name: "REMARK",
       	                fieldLabel:'提款备注', 
       	                allowBlank:true
                    },{
       	                xtype: "textfield", 
       	                name: "JZ_NO",
       	                fieldLabel:'记账凭证号', 
       	                allowBlank:true
                    }]
    	    	}
    	    	//结束
                ]}
        	];
    	
    	var editorPanel = Ext.create('Ext.form.Panel', {
		    title: '',
		    layout: 'fit',
		    border:false,
		    split: true ,  
		    height: '100%',
		    itemId:'jjxxaddform',
		    items: content,
            listeners:{
            	'beforeRender': function(){
                    	this.setDisabled(true);
                }
            }
		});
		var btb_name = btn.text;
		if(btb_name == '确认') {
			 $.post("/getzwByid.action", {
                        ZW_ID: ZW_ID,
                        AG_ID:AG_ID
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        editorPanel.getForm().setValues(data.data);
                        initWidget(editorPanel);
                    }, "json");
    	
		} else if(btb_name == '修改') {
			var records = DSYGrid.getGrid('contentGrid').getSelection();
             var  JJXX_ID = records[0].get('JJXX_ID');
			 $.post("/queryjjxxByid.action", {
                        JJXX_ID: JJXX_ID,
                        AG_ID:AG_ID
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        editorPanel.getForm().setValues(data.data);
                        var hkjhstore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
                        hkjhstore.insert(0, data.hkjhList);
                        var yflxstore = Ext.ComponentQuery.query('grid#yflxgrid')[0].getStore();
                        yflxstore.insert(0, data.yflxList);
                        initWidget(editorPanel);
                    }, "json");
		}
		initWidget(editorPanel);
    	return editorPanel;
    }

    //初始化债务信息
    function initWidget(form){
    	var fm_id= form.getForm().findField('FM_ID');
    	var HL_RATE = form.getForm().findField('HL_RATE');
//    	alert('fm_id:'+fm_id.getValue());
    	if (fm_id.getValue() != null && fm_id.getValue()=='CNY')
    	{
    		HL_RATE.setEditable(false);
    	}
    	
    }    

    function initTabPanel(){
    	
        var tabPanel = Ext.createWidget('tabpanel', {
            itemId : "tabPanel",
            activeTab: 0,
            width: "100%",
            height: "100%",
            items: [{
              title: '还本计划',
              tabConfig:{height:5},
              //html: "这是还本的页签。"
              items: inithkjh()
            },{
              title: '付息计划',
              items: inityflx()
            },{
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                items: [
                    {
                        xtype: 'fieldset',
                        columnWidth: 1,
                        title: '附件',
                        anchor: '100% -275',
                        collapsible: true,
                        layout: 'fit',
                        items: [initWin_ZwqxTabPanel_Zhzq_Fj()]
                    }
                ]
            }]
        });
        return tabPanel;
    }

    //还款计划初始化
    function inithkjh() {
		var cellEditing = Ext.create('Ext.grid.plugin.CellEditing', {
					clicksToEdit : 1,
					clicksToMoveEditor : 1,
					listeners : {
						'edit' : function(editor, e) {
							// e.record.commit();
						}
					}
				});
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {"text": "还款计划ID", "dataIndex": "HKJH_ID", "type": "string", "hidden": true},
            {
                "text": "计划偿还日期", "dataIndex": "HKJH_DATE", "type": "string",
                editor: {xtype: 'datefield', allowBlank: false, format: 'Y-m-d'}
            },
            {"text": "计划偿还金额(原币)", "dataIndex": "HKJH_AMT", "type": "float", editor: 'numberFieldFormat'},
            {"text": "备注", "dataIndex": "REMARK", "type": "string", editor: 'textfield'}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'hkjhgrid',
            checkBox: true,
            border: true,
            height:180,
            tbarConfig: {
                height: 400
            },
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            pageConfig: {
                enablePage: false
            },
            plugins: [cellEditing],
            data: []
        });
		/*var simplyGrid = new DSYGrid();
		simplyGrid.setItemId('hkjhgrid');
		simplyGrid.setHeaderJson(headerJson);
		simplyGrid.setPlugins([cellEditing]);
		simplyGrid.setCheckBox(true);// 显示复选框
		simplyGrid.setRowNumber(true);// 显示行号
		simplyGrid.setHeight(180);// 设置高度后，当行数超出高度时出现滚动条
		simplyGrid.setTbarHeight(400);
		simplyGrid.setPageConfig({
					enablePage : false
				});
		simplyGrid.setBorder(true);// 不显示边界
		simplyGrid.setData([]);
		var grid = simplyGrid.create();*/
		grid.setDisabled(true);
		// 定义编辑行model
		Ext.define('hkjh_demo', {
					extend : 'Ext.data.Model',
					fields : [{
								name : 'HKJH_ID',
								type : 'string',
								useNull : true,
								active : true,
								hidden:true
							}, {
								name : 'HKJH_DATE',
								type : 'string',
								useNull : false,
								active : true
							}, {
								name : 'HKJH_AMT',
								type : 'float',
								useNull : false,
								active : true
				        },{
								name : 'REMARK',
								type : 'string',
								useNull : true,
								active : true
							}]
				});
		// 将增加删除按钮添加到表格中
		grid.addDocked({
					xtype : 'toolbar',
					layout : 'hbox',
					items : ['->', {
						xtype : 'button',
						text : '增加',
						width : 80,
						handler : function(btn) {
							// rowEditing.cancelEdit();
							// 创建行model实例
							var row = Ext.create('hkjh_demo', {
										HKJH_ID : '',
										HKJH_DATE : Ext.Date
												.clearTime(new Date()),
										HKJH_AMT : 0,
										REMARK : ''
									});
							btn.up('grid').getStore().insert(0, row);
							// rowEditing.startEdit(0, 0);
						}
					}, {
						xtype : 'button',
						text : '删除',
						itemId : 'delete_editGrid',
						width : 80,
						disabled : true,
						handler : function(btn) {
							var grid = btn.up('grid');
							var store = grid.getStore();
							var sm = grid.getSelectionModel();
							// rowEditing.cancelEdit();
							store.remove(sm.getSelection());
							if (store.getCount() > 0) {
								sm.select(0);
							}
						}
					}]
				}, 0);
		// 设置panel边框有无，去掉上方边框
		grid.setBodyStyle('border-width:1px 1px 0 1px;');
		grid.on('selectionchange', function(view, records) {
					grid.down('#delete_editGrid').setDisabled(!records.length);
				});
				
//		grid.getStore().on('endupdate', function () {
//            /*var records = store.getUpdatedRecords();// 获取修改的行的数据，无法获取幻影数据
//             var phantoms=store.getNewRecords( ) ;//获得幻影行
//             records=records.concat(phantoms);//将幻影数据与真实数据合并*/
//            //计算录入窗口form当年申请金额
//            var self = grid.getStore();
//            var sum_RMB = 0;
//            self.each(function (record) {
//                sum_RMB += record.get('HKJH_AMT');
//            });
//           
//            grid.up('window').down('form').down('numberfield[name="FETCH_AMT"]').setValue(sum_RMB);
//        });

		return grid;
}

//应付利息初始化
function inityflx(){
            var cellEditing = Ext.create('Ext.grid.plugin.CellEditing', {
					clicksToEdit : 1,
					clicksToMoveEditor : 1,
					listeners : {
						'edit' : function(editor, e) {
							// e.record.commit();
						}
					}
				});
            var headerJson = [
                {xtype: 'rownumberer', width: 35},
                {"dataIndex": "YFLX_ID", "type": "string", "text": "应付利息ID", "hidden": true},
                {
                    text: "计划偿还日期", dataIndex: "YFRQ", type: "string",
                    editor: {xtype: 'datefield', allowBlank: false, format: 'Y-m-d'}
                },
                {"text": "应偿还金额(原币)", "dataIndex": "YFLX_AMT", "type": "float", editor: 'numberFieldFormat'},
                {"text": "备注", "dataIndex": "REMARK", "type": "string", editor: 'textfield'}
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'yflxgrid',
                checkBox: true,
                border: true,
                height:"100%",
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                pageConfig: {
                    enablePage: false
                },
                plugins: [cellEditing],
                data: []
            });
            /*var simplyGrid = new DSYGrid();
            simplyGrid.setItemId('yflxgrid');
            simplyGrid.setHeaderJson(headerJson);
            simplyGrid.setPlugins([cellEditing]);
            simplyGrid.setCheckBox(true);//显示复选框
            simplyGrid.setRowNumber(true);//显示行号
            simplyGrid.setHeight("100%");//设置高度后，当行数超出高度时出现滚动条
            simplyGrid.setPageConfig({
                enablePage: false
            });
            simplyGrid.setBorder(true);//不显示边界
            simplyGrid.setData([]);
            var grid = simplyGrid.create();*/
            grid.setDisabled(true);
            //定义编辑行model
            Ext.define('yflx_demo', {
                extend: 'Ext.data.Model',
                fields: [
                    {name: 'YFLX_ID', type: 'string', useNull: true, active: true,hidden:true},
                    {name: 'YFRQ', type: 'string', useNull: false, active: true},
                    {name: 'YFLX_AMT', type: 'float', useNull: false, active: true},
                    {name: 'REMARK', type: 'string', useNull: true, active: true}
                ]
            });
            //将增加删除按钮添加到表格中
            grid.addDocked({
                xtype: 'toolbar',
                layout: 'hbox',
                items: [
                    '->',
                    {
                    	xtype:'button',
                        text: '自动计算',
                        width: 80,
                        handler: function (btn) {
                        	var hkjhStore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
                        	if(hkjhStore.data.length==0){
                        		Ext.MessageBox.alert('提示', '还本计划至少要有一条数据才能计算');
                        		return;
                        	}
                        	var maxDate;
                        	hkjhStore.each(function(record){
                        		var datas = record.data;
                        		if(maxDate==undefined){
                        			maxDate=datas['HKJH_DATE'];
                        		}else{
                        			if(maxDate<datas['HKJH_DATE']){
                        				maxDate=datas['HKJH_DATE'];
                        			}
                        		}
                        	});
                        	
                        	$.post("/autoCalc.action", {
                                ZW_ID:ZW_ID,
                                MAX_DATE:maxDate
                            }, function (data) {
                                if (data.success) {
                                    editorPanel.getForm().setValues(data.data);
                                    var hkjhstore = Ext.ComponentQuery.query('grid#hkjhgrid')[0].getStore();
                                    hkjhstore.insert(0, data.hkjhList);
                                    initWidget(editorPanel);
                                } else {
                                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                    return;
                                }
                            }, "json");
                        }
                    },
                    {
                        xtype: 'button',
                        text: '增加',
                        width: 80,
                        handler: function (btn) {
                            // 创建行model实例
                            var row = Ext.create('yflx_demo', {
                                        YFLX_ID: '',
                                        YFRQ: Ext.Date.clearTime(new Date()),
                                        YFLX_AMT: 0,
                                        REMARK: ''
                                    }
                            );
                            btn.up('grid').getStore().insert(0, row);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        itemId: 'delete_editGrid',
                        width: 80,
                        disabled: true,
                        handler: function (btn) {
                            var grid = btn.up('grid');
                            var store = grid.getStore();
                            var sm = grid.getSelectionModel();
                            store.remove(sm.getSelection());
                            if (store.getCount() > 0) {
                                sm.select(0);
                            }
                        }
                    }
                ]
            }, 0);
            //设置panel边框有无，去掉上方边框
            grid.setBodyStyle('border-width:1px 1px 0 1px;');
            grid.on('selectionchange', function (view, records) {
                grid.down('#delete_editGrid').setDisabled(!records.length);
            });
            return grid;
    }
    
/**
 * 初始化到期债务(有计划)弹出框表格
 */
function initWindow_dqzw_yjh_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AG_NAME", type: "string", text: "债务单位"},
        {dataIndex: "AG_CODE", type: "string", text: "债务单位编码",hidden:true},
        {dataIndex: "ZW_NAME", type: "string", text: "债务名称"},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期", format: 'Y-m-d'},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人"},
        {dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额"},
        {dataIndex: "CH_TYPE", type: "string", text: "类型"},
        {dataIndex: "HKJH_DATE", type: "string", text: "债务到期日"},
        {dataIndex: "APPLY_AMT", type: "float", text: "到期金额"},
        {dataIndex: "CUR_NAME", type: "string", text: "币种"},
        {dataIndex: "HL_RATE", type: "string", text: "汇率"}

    ];
    var simplyGrid = new DSYGridV2();
    var grid = simplyGrid.create({
        itemId: 'grid_dqzw_yjh',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        rowNumber: true,
        border: false,
        height: '50%',
        tbar: [],
        tbarHeight: 50,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        dataUrl: 'getDqzwYjh.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }]
    });
    //将form添加到表格中
    var searchTool = initWindow_dqzw_yjh_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}

/**
 * 初始化到期债务(有计划)弹出框搜索区域
 */
function initWindow_dqzw_yjh_grid_searchTool() {
        //初始化查询控件
        var items = [];
        items.push(
            {
                xtype: 'numberfield',
                name: 'expire_date',
                value: 30,
                width: 30,
                margin: '5 0 5 5',
                hideTrigger: true
            },
            {xtype: 'displayfield', value: '天内到期', width: 60, margin: '5 5 5 0'},
            {
                fieldLabel: '债务单位',
                xtype: 'textfield',
                name: 'AG_NAME',
                value: AG_NAME,
                labelWidth: 60,
                width: 210,
                disabled: true
            },
            {fieldLabel: '债务名称', xtype: 'textfield', name: 'ZW_NAME', labelWidth: 60, width: 210},
            {xtype: 'checkbox', name: 'flag_expire_date', width: 15, margin: '5 0 5 5'},
            {xtype: 'displayfield', value: '仅显示逾期', width: 80, margin: '5 5 5 0'}
        );
        //设置查询form
        var searchTool = new DSYSearchTool();
        searchTool.setSearchToolId('searchTool_grid');
        return searchTool.create({
            items: items,
            dock: 'top',
            // 查询按钮回调函数
            callback: function (self) {
                var store = self.up('grid').getStore();
                // 清空参数中已有的查询项
                for (var search_form_i in self.getValues()) {
                    delete store.getProxy().extraParams[search_form_i];
                }
                // 向grid中追加参数
                $.extend(true, store.getProxy().extraParams, self.getValues());
                // 刷新表格
                store.loadPage(1);
            }
        });
}



/**
 * 初始化到期债务(无计划)弹出窗口
 */
function initWindow_dqzw_wjh() {
    return Ext.create('Ext.window.Window', {
        title: '到期债务(无计划)', // 窗口标题
        width: document.body.clientWidth*0.9, // 窗口宽度
        height: document.body.clientHeight*0.9, // 窗口高度
        itemId: 'window_dqzw_wjh', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_dqzw_wjh_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据 
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    //关闭当前窗口，打开偿还资金录入窗口
                    window_debt_add_apply.show();
                    btn.up('window').close();
                    //偿还资金录入窗口表格增加行
                    window_debt_add_apply.window.down('grid').getStore().insert(0, records);
                    // for (var record_seq in records) {
                    // 创建行model实例
                    // alert('222222');
                    //  var row = Ext.create('row_edit_demo', records[record_seq].getData());

                    //  window_debt_add_apply.window.down('grid').getStore().insert(0, row);
                    //}
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    window_debt_add_apply.show();
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
    	           window_dqzw_wjh.window = null;
            }
        }
    });
}

/**
 * 初始化到期债务(无计划)弹出框表格
 */
function initWindow_dqzw_wjh_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AG_NAME", type: "string", text: "债务单位"},
        {dataIndex: "ZW_NAME", type: "string", text: "债务名称"},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期", format: 'Y-m-d'},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人"},
        {dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额"},
        {dataIndex: "CH_TYPE", type: "string", text: "类型"},
        {dataIndex: "HKJH_DATE", type: "string", text: "债务到期日"},
        {dataIndex: "APPLY_AMT", type: "float", text: "到期金额"},
        {dataIndex: "CUR_CODE", type: "string", text: "币种"},
        {dataIndex: "HL_RATE", type: "string", text: "汇率"}

    ];
    var simplyGrid = new DSYGridV2();
    var grid = simplyGrid.create({
        itemId: 'grid_dqzw_wjh',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        rowNumber: true,
        border: false,
        height: '50%',
        tbarHeight: 50,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        dataUrl: 'getDqzwWjh.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }]
    });
    //将form添加到表格中
    var searchTool = initWindow_dqzw_wjh_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}
/**
 * 初始化到期债务(无计划)弹出框搜索区域
 */
function initWindow_dqzw_wjh_grid_searchTool() {
        //初始化查询控件
        var items = [];
        items.push(
            {
                fieldLabel: '债务单位',
                xtype: 'textfield',
                name: 'AG_NAME',
                value: AG_NAME,
                labelWidth: 60,
                width: 210,
                disabled: true
            },
            {fieldLabel: '债务名称', xtype: 'textfield', name: 'ZW_NAME', labelWidth: 60, width: 210}
        );
        //设置查询form
        var searchTool = new DSYSearchTool();
        searchTool.setSearchToolId('searchTool_grid');
        return searchTool.create({
            items: items,
            dock: 'top',
            // 查询按钮回调函数
            callback: function (search_form) {
                var store = window_dqzw_wjh.window.down('grid').getStore();
                // 清空参数中已有的查询项
                for (var search_form_i in search_form.getValues()) {
                    delete store.getProxy().extraParams[search_form_i];
                }
                // 向grid中追加参数
                $.extend(true, store.getProxy().extraParams, search_form.getValues());
                // 给导出按钮追加查询参数
                $.extend(true, DSYGrid.getBtnExport('grid').param, search_form.getValues());
                // 刷新表格
                store.loadPage(1);
            }
        });
}
/**
 * 初始化偿债资金申请单弹出窗口
 */
function initWindow_debt_add_apply() {
    return Ext.create('Ext.window.Window', {
        title: '偿债资金申请单', // 窗口标题
        width: document.body.clientWidth*0.9, // 窗口宽度
        height: document.body.clientHeight*0.9, // 窗口高度
        layout: 'fit',
        itemId: 'window_debt_add_apply', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: initWindow_debt_add_apply_contentForm(),
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    //保存表单数据
                    var form = btn.up('window').down('form');
                    //保存单据明细
                    btn.up('window').close();
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
    	            window_debt_add_apply.window = null;
            }
        }
    });
}

/**
 * 初始化偿债资金申请单表单
 */
function initWindow_debt_add_apply_contentForm() {
        return Ext.create('Ext.form.Panel', {
            //title: '详情表单',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            defaults: {
                anchor: '100%',
                margin: '5 5 5 5'
            },
            defaultType: 'textfield',
            items: [
                //{ xtype: 'hiddenfield', name: 'userPageMenu.id' },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        //columnWidth: .3,
                        width: 210,
                        labelWidth: 60//控件默认标签宽度
                    },
                    items: [
                        {fieldLabel: '申请单位', name: 'AG_NAME', value: AG_NAME, disabled: true},
                        {fieldLabel: '申请单位代码', name: 'AG_CODE', value: AG_CODE, xtype: 'hiddenfield'},
                        {
                            fieldLabel: '申请日期',
                            xtype: 'datefield',
                            name: 'PAY_DATE',
                            format: 'Y-m-d'
                        },
                        {fieldLabel: '申请金额', name: 'PAY_AMT_RMB', disabled: true},
                        {fieldLabel: '备注', xtype: "textfield", name: 'REMARK', width: 650}
                    ]
                },
                {
                    xtype: 'fieldset',
                    anchor: '100%',
                    title: '单据明细',
                    layout: 'fit',
                    padding: '10 5 3 10',
                    height: 350,
                    collapsible: false,
                    items: [
                        initWindow_debt_add_apply_contentForm_grid()
                    ]
                }
            ]
        });
}
/**
 * 初始化偿债资金申请单表单中的表格
 */
function initWindow_debt_add_apply_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "CHBJ_TYPE", type: "string", text: "还款类型", editor: 'textfield'},
            {dataIndex: "ZJLY_ID", type: "string", text: "偿还资金来源", editor: 'textfield'},
            {dataIndex: "RATE", type: "string", text: "汇率", editor: 'textfield'},
            {dataIndex: "APPLY_AMT", type: "float", text: "申请金额(原币)", editor: 'numberfield'},
            {dataIndex: "ZQR_ID", type: "string", text: "贷款银行", editor: 'textfield'},
            {dataIndex: "ZWHT_NAME", type: "string", text: "债务合同", editor: 'textfield'},
            {dataIndex: "FETCH_AMT", type: "float", text: "举债金额", editor: 'numberfield'},
            {dataIndex: "CHBJ_AMT_RMB", type: "float", text: "已偿还金额", editor: 'numberfield'},
            {
                dataIndex: "HKJH_DATE",
                type: "string",
                text: "到期支付日期",
                editor: 'datefield',
                format: 'Y-m-d'
            },
            {dataIndex: "CUR_CODE", type: "string", text: "币种", editor: 'textfield'},
            {dataIndex: "REMARK", type: "string", text: "备注", editor: 'textfield'}
        ];
        var simplyGrid = new DSYGridV2();
        var grid = simplyGrid.create({
            itemId: 'debt_add_apply_grid',
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
                        'edit': function (editor, e) {
                            //e.record.commit();
                        }
                    }
                }
            ],
            checkBox: true,
            rowNumber: true,
            border: true,
            bodyStyle: 'border-width:1px 1px 0 1px;',
            height: '50%',
            tbar: [
                '->',
                {
                    xtype: 'button',
                    text: '有计划增加',
                    width: 80,
                    handler: function () {
                        //弹出到期债务窗口
                        window_dqzw_yjh.show();
                    }
                },
                {
                    xtype: 'button',
                    text: '无计划增加',
                    width: 80,
                    handler: function () {
                        //弹出到期债务窗口
                        window_dqzw_wjh.show();
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    itemId: 'delete_editGrid',
                    width: 80,
                    disabled: true,
                    handler: function (btn) {
                        var grid = btn.up('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        grid.getPlugin('debt_add_apply_grid_plugin_cell').cancelEdit();
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                    }
                }
            ],
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code
            },
            data: [],
            pageConfig: {
                enablePage: false
            },
            listeners: {
                selectionchange: function (view, records) {
                    grid.down('#delete_editGrid').setDisabled(!records.length);
                }
            }
        });
        grid.getStore().on('datachanged', function (self) {
            //计算偿还资金录入窗口form申请金额
            var sum_PAY_AMT_RMB = 0;
            self.each(function (record) {
                sum_PAY_AMT_RMB += record.get('APPLY_AMT');
            });
            grid.up('window').down('form').down('textfield[name="PAY_AMT_RMB"]').setValue(sum_PAY_AMT_RMB);
        });
        return grid;
}