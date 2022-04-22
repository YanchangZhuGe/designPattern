/**
 * js：合同变更审核
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
$.extend(htbg_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            initContentTree({
            	areaConfig: {
			        params: {
			            CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
			        }
		    	}
            	}),//初始化左侧树
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
                    text: '审核',
                    name: 'down',
                    icon: '/image/sysbutton/submit.png',
                    handler: function (btn) {
                    	opinionWindow.open('NEXT',"审核意见");
                    }
                },
    			{
    				xtype : 'button',
    				text : '退回',
    				name : 'btn_back',
    				icon : '/image/sysbutton/back.png',
    				handler : function() {
    					//弹出对话框填写意见
    					opinionWindow.open('BACK',"退回意见");
    				}
    			},
                {
                    xtype: 'button',
                    text: '操作记录',
                    name:'log',
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
                    text: '撤销',
                    name:'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                    	var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                            return;
                        } else {
                        	Ext.MessageBox.show({
                        		title: "提示",
                                msg: "是否撤销选择的记录？",
                                width: 200,
                                buttons: Ext.MessageBox.OKCANCEL,
                                fn: function (btn, text) {
                                	audit_info = text;
                                    if (btn == "ok") {
                                    	back("CANCEL");
                                    }
                                }
                            });
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name:'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function (btn) {
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
                        text: '审核',
                        name: 'down',
                        icon: '/image/sysbutton/submit.png',
                        handler: function (btn) {
                        	opinionWindow.open('NEXT',"审核意见");
                        }
                    },
        			{
        				xtype : 'button',
        				text : '退回',
        				name : 'btn_back',
        				icon : '/image/sysbutton/back.png',
        				handler : function() {
        					//弹出对话框填写意见
        					opinionWindow.open('BACK',"退回意见");
        				}
        			},
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name:'log',
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
                        text: '操作记录',
                        name:'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                        	dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
    }
});
//操作记录
function dooperation(){
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        BG_ID = records[0].get("BG_ID");

        fuc_getWorkFlowLog(BG_ID);
    }
}
/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#htbg_contentGrid_search')[0].getValue();
    var zqlx = Ext.ComponentQuery.query('treecombobox#htbg_zqlx')[0].getValue();
    var zwlb = Ext.ComponentQuery.query('treecombobox#htbg_zwlb')[0].getValue();
    var CHANGE_TYPE = Ext.ComponentQuery.query('combobox#CHANGE_TYPE_SEARCH')[0].getValue();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        mhcx: mhcx,
        zqlx: zqlx,
        zwlb :zwlb,
        wf_status: WF_STATUS,
        wf_id: wf_id,
        CHANGE_TYPE : CHANGE_TYPE,
        node_code: node_code
    };
    //刷新表格内容
    store.loadPage(1);
}
/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action,title) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn, text) {
            	audit_info = text;
                if (btn == "ok") {
                	if(action == 'NEXT'){
               			next();
               		} else if(action == 'BACK') {
               			back("BACK");
               		}
                }
            },
            //animateTarget: btn_target
        });
    },
    close: function () {
        if (this.window) {
            this.window.close();
        }
    }
};
/**
 * 合同变更信息审核
 */
function next() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
        //判断操作按钮
        if (node_type == 'typing') {
            button_name = '送审';
            msg_success = '送审成功！';
            msg_failure = '送审失败！';
        } else if (node_type == 'reviewed') {
            button_name = '审核';
            msg_success = '审核成功！';
            msg_failure = '审核失败！';
        } 
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("BG_ID");
            array.NODE_NEXT_ID = record.get("NODE_NEXT_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'nextBgInfo.action',
            params: {
                wf_id: wf_id,
                node_code: node_code,
                IS_END: IS_END,
                button_name: button_name,
                audit_info: audit_info,
                bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
            },
            async: false,
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_success,
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function(resp, opt) {
				var result=Ext.util.JSON.decode(resp.responseText); 
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_failure+ result.message,
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
}
/**
 * 债务合同信息退回
 */
function back(btnName) {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
        var msg_name = "";
        if(btnName == 'BACK'){
        	msg_name = '退回';
        }
        else if(btnName == 'CANCEL'){
        	msg_name = '撤销';
        	audit_info = '';
        }
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel()
            .getSelection();
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("BG_ID");
            array.NODE_NEXT_ID = record.get("NODE_NEXT_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'backBgInfo.action',
            params: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: btnName,
                audit_info: audit_info,
                IS_END:IS_END,
                bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
            },
            async: false,
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_name + '成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_name + '失败',
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
}



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
        {
            "dataIndex": "ZW_ID",
            "type": "string",
            "text": "债务ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "债务单位",
            "fontSize": "15px",
            "width": 250,
        }, {
            "dataIndex": "AG_CODE",
            "type": "string",
            "text": "单位编码",
            "fontSize": "15px",
            "width": 250,
            "hidden": true
        }, {
            "dataIndex": "ZW_CODE",
            "type": "string",
            "width": 250,
            "text": "债务编码",
            "hrefType": "combo",
            "hidden": true
        }, {
            "dataIndex": "ZW_NAME",
            "width": 250,
            "type": "string",
            "text": "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl =  '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        }, {
            "dataIndex": "CHANGE_TYPE",
            "width": 150,
            "type": "string",
            "text": "变更类型"
        }, {
            "dataIndex": "ZQFL_ID",
            "width": 150,
            "type": "string",
            "text": "债权类型"
        }, {
            "dataIndex": "ZWLB_ID",
            "width": 150,
            "type": "string",
            "text": "债务类别"
        }, {
            "dataIndex": "XY_AMT",
            "width": 150,
            "type": "float",
            "align": 'right',
            "text": "协议金额（原币）"
        }, {
            "dataIndex": "ZQR_FULLNAME",
            "width": 300,
            "type": "string",
            "text": "债权人全称"
        }, {
            "dataIndex": "CHANGE_DATE",
            "width": 100,
            "type": "string",
            "text": "变更日期"
        }, {
            "dataIndex": "CHANGE_REASON",
            "width": 150,
            "type": "string",
            "text": "变更原因"
        }, {
            "dataIndex": "CHANGE_IMPORT",
            "width": 150,
            "type": "string",
            "text": "变更要点"
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
        height: '80%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt2),
                width: 110,
                allowBlank: false,
                editable:false,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(htbg_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["wf_status"] = WF_STATUS;
                        self.up('grid').getStore().getProxy().extraParams["wf_id"] = wf_id;
                        self.up('grid').getStore().getProxy().extraParams["node_code"] = node_code;
                        if (AD_CODE == null || AD_CODE == '') {
                            Ext.Msg.alert('提示', '请选择区划！');
                            return;
                        }
                        self.up('grid').getStore().loadPage(1);
                    }
                }
            }
        ],
        tbarHeight: 50,
        params: {
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        dataUrl: 'getHtbgList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
        	itemdblclick: function (self, record) {
                BG_ID = record.get("BG_ID");
                ZW_ID = record.get("ZW_ID");

	            initWin_htbglrWindow();
	            
	            loadBgInfo();

            }
        }
    });
}

/**
 * 创建合同变更录入弹出窗口
 */
function initWin_htbglrWindow() {
    var iTitle = "合同变更";
    var iWidth = window.screen.availWidth * 3 / 4;
    //var iWidth = 1000;
    var buttons = [
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ];

    var iHeight = 550;//窗口高度
    var htbglrWindow = new Ext.Window({
        title: iTitle,
        name: 'htbglrWin',
        width: iWidth,
        height: iHeight,
        frame: true,
        constrain: true,
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: false,//大小不可改变
        plain: true,
        layout: 'fit',
        items: [initWin_htbglrTabPanel()],
        buttons: buttons,
        closeAction: 'destroy'
    });
    htbglrWindow.show();
}
/**
 * 初始化合同变更录入弹出窗口内容
 */
function initWin_htbglrTabPanel() {
    var htbglrTabPanel = Ext.create('Ext.tab.Panel', {
        name: 'EditorPanel',
        layout: 'fit',
        border: false,
        padding: '2 2 2 2',
        defaults: {
            layout: 'fit',
            border: false
        },
        items: [
            {
                title: '变更历史',
                items: initWindow_debt_htbglr_contentForm()
            },
            {
                title: '基本信息',
                items: initWin_htbglrTabPanel_Jbxx()
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
               // layout: 'fit',
                items: initWin_ZwqxTabPanel_Jbxx_Fj()
            }
        ]
    });

    return htbglrTabPanel;
}

/**
 * 初始化合同变更信息表单
 */
function initWindow_debt_htbglr_contentForm() {
    try {
        return Ext.create('Ext.form.Panel', {
            //title: '详情表单',
            width: '100%',
            height: '100%',
            itemId:'window_debt_htbglr_contentForm',
            name : 'bgxxForm',
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
                        columnWidth: .99,
                        
                        labelWidth: 100//控件默认标签宽度
                    },
                    items: [
                            {
                                xtype: 'container',
                                layout: 'column',
                                defaultType: 'textfield',
                                defaults: {
                                    margin: '5 5 5 5',
                                    columnWidth: .5,
                                    
                                    labelWidth: 100//控件默认标签宽度
                                },
                            	items:[{
                            			fieldLabel: '变更类型', 
                            			name: 'CHANGE_TYPE',
                            			xtype:'combobox',
                            			store: DebtEleStore(json_debt_bglx),
                            			displayField: "name",
                            			valueField: "id",
                            			value: change_type
                            			},
                                       {
	                                    fieldLabel: '变更日期',
	                                    xtype: 'datefield',
	                                    name: 'CHANGE_DATE',
	                                    format: 'Y-m-d'
                                       }
                            		]
                            }
                        ,{
                            xtype: 'container',
                            layout: 'column',
                            defaultType: 'textfield',
                            defaults: {
                                margin: '5 5 5 5',
                                columnWidth: 1,
                                
                                labelWidth: 100//控件默认标签宽度
                            },
                        	items:[
                        	       {fieldLabel: '变更原因',  xtype: "textarea", name: 'CHANGE_REASON'},
                        	       {fieldLabel: '变更要点', xtype: "textarea", name: 'CHANGE_IMPORT'}
                        	      ]
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    anchor: '100%',
                    title: '变更历史',
                    layout: 'fit',
                    padding: '10 5 3 10',
                    height: 200,
                    collapsible: false,
                    items: [
                        initWindow_debt_htbglr_contentForm_grid()
                    ]
                }
            ],
            listeners:{
            	'beforeRender': function(){
                    if(node_type == "reviewed"|| WF_STATUS == "008"){
                    	
                    	SetItemReadOnly(this.items);
                    	
                    }
            	}
            }
        });
    }
    catch (err) {
        // 当出现异常时，打印控制台异常
      
    }
}
/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_debt_htbglr_contentForm_grid() {
    var headerJson = [
	    {xtype: 'rownumberer',width: 40},
        {"dataIndex": "CHANGE_TYPE", "width": 150, "type": "string", "text": "变更类型"},
        {"dataIndex": "CHANGE_DATE", "width": 100, "type": "string", "text": "变更日期"},
        {"dataIndex": "CHANGE_USER", "width": 150, "type": "string", "text": "变更人"},
        {"dataIndex": "CHANGE_IMPORT", "width": 250, "type": "string", "text": "变更要点"},
        {"dataIndex": "CHANGE_REASON", "width": 250, "type": "string", "text": "变更原因"},
        {"dataIndex": "CHANGE_STATUS", "width": 150, "type": "string", "text": "状态"}
    ];  
    var simplyGrid = new DSYGridV2(); 
    var grid = simplyGrid.create({
        itemId: 'grid_htbg_bgls',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: false,
        border: false,
        height: '90%',
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            ZW_ID: ZW_ID
        },
        dataUrl: 'getBglsInfo.action',
        pageConfig: {
        	enablePage: false
        }
    });
 

    return grid;
}
function initWin_htbglrTabPanel_Jbxx() {
    var jbxxPanel =  Ext.create('Ext.form.Panel', {
        name: 'jbxxPanel',
        layout: 'anchor',
        items: [
            initWin_ZwqxTabPanel_Jbxx_form()
        ]
    });
    
     return jbxxPanel;
}

function loadBgInfo() {
    var form = Ext.ComponentQuery.query('form[name="jbxxForm"]')[0];
    var bgxxform = Ext.ComponentQuery.query('form[name="bgxxForm"]')[0];
    form.load({
        url: 'loadBgInfo.action?BG_ID=' + BG_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            form.getForm().setValues(action.result.data[0]);
            bgxxform.getForm().setValues(action.result.data[0]);
        	loadDqlx(action.result.data[0].SIGN_DATE);

        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}


