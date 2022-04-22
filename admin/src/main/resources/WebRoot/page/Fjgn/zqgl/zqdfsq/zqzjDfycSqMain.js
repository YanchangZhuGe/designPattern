/**
 * 页面初始化
 */
$(document).ready(function () {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    $.post("getParamValueAll.action", function (data) {
        SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX;
        DFF_CH_MODE = data[0].DFF_CH_MODE == undefined ? '0' : data[0].DFF_CH_MODE;//判断是否是undefined
        IS_CONFIRMHK_BY_AUDIT = data[0].IS_CONFIRMHK_BY_AUDIT;
        IS_CONFIRM_BYGK = data[0].IS_CONFIRM_BYGK;
        initContent();
    },"json");
});

/**
 * 初始化页面主要内容区域
 */
function initContent() {
	if(userAdCode.length!=2){
		Ext.create('Ext.panel.Panel', {
	    	layout: 'border',
	    	defaults: {
	            split: true,                  //是否有分割线
	            collapsible: false           //是否可以折叠
	        },
	        /*layout: {
	            type: 'vbox',
	            align: 'stretch',
	            flex: 1
	        },*/
	        height: '100%',
	        renderTo: Ext.getBody(),
	        border: false,
	        dockedItems: [
	            {
	                xtype: 'toolbar',
	                dock: 'top',
	                itemId: 'contentPanel_toolbar',
	                items:zxkxmtz_toolbar_json[node_type].items[WF_STATUS]
	            }
	        ],
	        
	       //区划树参数，0是本级，1是单位，2是区划，3是什么都没有
	            items:[{
	                    region: 'west',
	                    layout: 'fit',
	                    height: '100%',
	                    itemId: 'treePanel_left',
	                    flex: 1,
	                    border: true,
	                    items: [initContentTree_area()]
	                }, 
	                Ext.create('Ext.form.Panel', {
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
	                        initContentRightPanel()
	                    ]
	                })
	                ]
	    });
	}else{
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
		                items: zqzjdf_json_common[wf_id][node_code].items[WF_STATUS]//根据当前状态切换显示按钮
		            }
		        ],
		        items: [
		            initContentRightPanel()
		        ]
		    });
	}
}

/**
 * 初始化panel
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
        border: false,
        items: [
            initContentGrid()
        ]
    });
}

/**
 * 初始化Panel主表格
 */
function initContentGrid() {
    var contentHeaderJson  = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "HK_YC_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "HKD_ID", width: 150, type: "string", text: "申请单唯一ID", hidden: true},
        {dataIndex: "REVISE_TYPE", width: 150, type: "string", text: "推送类型ID", hidden: true},
        {dataIndex: "CEHK_TYPE", width: 150, type: "string", text: "超额还款类型ID", hidden: true},
        {dataIndex: "REVISE_TYPE_NAME", width: 150, type: "string", text: "推送类型"},
        {dataIndex: "CEHK_TYPE_NAME", width: 150, type: "string", text: "超额还款类型"},
        {dataIndex: "AD_NAME", width: 100, type: "string", text: "区划名称"},
        {dataIndex: "HK_NO", width: 150, type: "string", text: "还款单号"},
        {dataIndex: "HK_DATE", width: 150, type: "string", text: "还款日期"},
        {
            dataIndex: "HK_AMT", width: 150, type: "float", text: "还款金额（元）",
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
        itemId: 'contentGrid',
        flex: 1,
        autoLoad: true,
        border: false,
        checkBox: true,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: node_type == 'lr' ? DebtEleStore(json_debt_hkyc) : DebtEleStore(json_debt_zt2_3),
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
            }
        ],
        headerConfig: {
            headerJson: contentHeaderJson,
            columnAutoWidth: false
        },
        dataUrl: 'getYcxzMainInfo.action',
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
        }
    });
    return grid;
}
/*============================== 《异常数据选择窗口》 =============================================================== */
/**
 *  异常数据展示弹出窗口
 */
function window_ycsjzs(btn) {
    var window = Ext.create('Ext.window.Window', {
        title: '债券资金兑付异常数据选择', // 窗口标题
        itemId: 'item_Select_windows', // 窗口标识
        layout: 'fit',
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        closeAction: 'destroy',
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        items: [init_ychktzXmtz_Grid(btn)],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('item_ycSelect_grid').getSelection();
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
                        var xmtzFormRecords = records[0].getData();
                        HK_YC_ID = xmtzFormRecords.HK_YC_ID;
                        TOTAL_HK_AMT = xmtzFormRecords.HK_AMT;
                        if (button_name == 'INPUT_YCHK') { // 异常还款
                            initWin_input_yc(btn).show();
                            btn.up('window').close();
                        } else {
                            $.post("/getYchkdData.action", {
                                HK_NO: xmtzFormRecords.HK_NO
                            }, function (data) {
                                if (!data.success) {
                                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                    return;
                                }
                                HkId = data.list.HK_ID;
                                //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                var window_input = initWin_input_yc();
                                window_input.show();
                                window_input.down('form').getForm().setValues(data.list[0]);
                                for (var i = 0; i < data.list.length; i++) {
                                    var obj = data.list[i];
                                    obj.FLAG_EDIT = 'INSERT';
                                }
                                window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                                btn.up('window').close();
                            }, "json");
                        }
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
 * 异常还款数据展示grid
 */
function init_ychktzXmtz_Grid(btn) {
    var Grid_headerjson = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "HK_YC_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "AD_NAME", width: 250, type: "string", text: "区划名称"},
        {dataIndex: "HK_NO", width: 100, type: "string", text: "还款单号"},
        {dataIndex: "HK_DATE", width: 150, type: "string", text: "还款日期"},
        {
            dataIndex: "HK_AMT", width: 150, type: "float", text: "还款金额（元）",
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
        itemId: 'item_ycSelect_grid',
        flex: 1,
        autoLoad: true,
        border: false,
        checkBox: true,
        headerConfig: {
            headerJson: Grid_headerjson,
            columnAutoWidth: false
        },
        dataUrl: 'getYchkInfo.action',
        params: {
            button_name: button_name,
            AD_CODE:AD_CODE
        },
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
/*============================== 《无单号异常匹配修正窗口》 ========================================================== */
/**
 * 初始化兑付申请弹出窗口
 */
function initWin_input_yc() {
    records_delete = [];
    var config = {
        title: '兑付申请', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_input', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: button_name == 'INPUT_YCHK' ? [initWin_input_dfsqtab()] : [
                    initWin_input_form(),
                    initWin_input_tab()
                ] ,
        buttons: [
            {
                xtype: 'button',
                text: '新增',
                width: 80,
                hidden: button_name == 'INPUT_YCHK' ? true : false,
                handler: function (btn) {
                    //弹出到期债务窗口
                    initWindow_select().show();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'delete_editGrid',
                width: 80,
                disabled: true,
                hidden: button_name == 'INPUT_YCHK' ? true : false,
                style: {marginRight: '20px'},
                handler: function (btn) {
                    var grid = btn.up('window').down('grid#win_input_tab_mxgrid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    var records = sm.getSelection();
                    grid.getPlugin('cellEdit').cancelEdit();
                    for (var i = 0; i < records.length; i++) {
                        var obj = records[i];
                        if (obj.get('FLAG_EDIT') == 'UPDATE') {
                            records_delete.push(obj.getData())
                        }
                    }
                    store.remove(records);
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    if (button_name == 'INPUT_YCHK') {
                        // 获取申请单grid
                        var records = DSYGrid.getGrid('itemId_dfsqmx').getSelection();
                        if (records.length < 1) {     //未选择项目
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        var xmtzFormRecords = records[0].getData();
                        btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                        $.post('/saveYcsjEditInfo.action', {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_text,
                            button_text: button_name,
                            HK_YC_ID: HK_YC_ID,
                            HKD_ID: xmtzFormRecords.HKD_ID,
                            HK_NO: xmtzFormRecords.HK_NO
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
                    } else {
                        var form = btn.up('window').down('form');
                        var grid = btn.up('window').down('grid#win_input_tab_mxgrid');
                        var store = grid.getStore();
                        if (grid.getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '明细数据不能为空！');
                            return false;
                        }
                        if (!form.down('[name=HK_DATE]').getValue()) {
                            Ext.Msg.alert('提示', '还款日期不能为空！');
                            return false;
                        }
                        if (!form.down('[name=HK_NO]').getValue()) {
                            Ext.Msg.alert('提示', '还款单号不能为空！');
                            return false;
                        }
                        if (form.down('[name=TOTAL_PAY_AMT]').getValue()!= TOTAL_HK_AMT) {
                            Ext.Msg.alert('提示', '本次调整金额和实际还款金额不等！');
                            return false;
                        }
                        var gridData = [];//所有明细数据
                        var records_add = [];//新增行
                        var records_update = [];//修改行
                        for (var i = 0; i < grid.getStore().getCount(); i++) {
                            var record = grid.getStore().getAt(i);
                            gridData.push(record.data);
                            if (record.get('FLAG_EDIT') == 'INSERT') {
                                records_add.push(record.data);
                            }
                            if (record.get('FLAG_EDIT') == 'UPDATE') {
                                records_update.push(record.data);
                            }
                            if (record.get("HK_HK_AMT") == 0) {
                                Ext.Msg.alert('提示', '还款金额不能为0！');
                                return false;
                            }
                            if (!record.get("ZJLY_ID")) {
                                Ext.Msg.alert('提示', '偿还资金来源不能为空！');
                                return false;
                            }
                            //获取单据明细数组
                            if (record.get("HK_HK_AMT") > record.get("SYYH_AMT")) {
                                Ext.Msg.alert('提示', '还款金额不能大于剩余应还金额');
                                return false;
                            }
                            if (record.get("HK_DFF_AMT") > record.get("SYDFF_AMT")) {
                                Ext.Msg.alert('提示', '兑付费金额不能大于剩余兑付费金额');
                                return false;
                            }
                        }
                        var parameters = {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_text,
                            button_text: button_name,
                            HK_YC_ID: HK_YC_ID,
                            detailList: Ext.util.JSON.encode(gridData),
                            listAdd: Ext.util.JSON.encode(records_add),
                            listUpdate: Ext.util.JSON.encode(records_update),
                            listDelete: Ext.util.JSON.encode(records_delete)
                        };
                        if (button_name == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.HKD_ID = records[0].get('HKD_ID');
                        }
                        if (form.isValid()) {
                            btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveYcsjEditInfo.action',
                                params: parameters,
                                success: function (form, action) {
                                    //关闭弹出框
                                    btn.up("window").close();
                                    //提示保存成功
                                    Ext.toast({html: '<div style="text-align: center;">保存成功!</div>'});
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "保存失败！" + result && result.message ? result.message : '无返回响应');
                                    btn.setDisabled(false);
                                }
                            });
                        } else {
                            Ext.Msg.alert('提示', '请完善必填项！');
                            return false;
                        }
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
    };
    return Ext.create('Ext.window.Window', config);
}

/**
 * 初始化匹配申请单信息
 */
function initWin_input_dfsqtab() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        layout: 'fit',
        flex: 1,
        defaults: {
            columnWidth: .33,
            margin: '5 5 5 5',
            readOnly: true,
            fieldCls: 'form-unedit',
            labelWidth: 135//控件默认标签宽度
        },
        defaultType: 'textfield',
        items: [
            initWin_dfsq_mxgrid()
        ]
    });
}

/**
 * 初始化匹配申请单信息
 */
function initWin_dfsq_mxgrid() {
    var headerjson_dfsqmx = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: '还款单id', dataIndex: "HKD_ID", type: "string", hidden: true},
        {text: '区划', dataIndex: "AD_NAME", width: 150, type: "string"},
        {text: '还款单号', dataIndex: "HK_NO", width: 150, type: "string"},
        {text: '申请日期', dataIndex: "HK_DATE", width: 100, type: "string"},
        {
            text: "还款总金额(元)", dataIndex: "TOTAL_PAY_AMT", width: 180, type: "float",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "还款金额(元)", dataIndex: "HK_AMT", width: 180, type: "float",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "兑付费金额(元)",
            dataIndex: "DFF_AMT",
            width: 180,
            type: "float",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'itemId_dfsqmx',
        flex: 1,
        autoLoad: true,
        border: false,
        checkBox: true,
        headerConfig: {
            headerJson: headerjson_dfsqmx,
            columnAutoWidth: false
        },
        dataUrl: 'getDfsqdInfo.action',
        params: {
        	AD_CODE:AD_CODE
        },
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
/*============================== 《兑付超额异常匹配修正窗口》 ======================================================== */
/**
 * 初始化兑付申请单表单
 */
function initWin_input_form() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        layout: 'column',
        defaults: {
            columnWidth: .33,
            margin: '5 5 5 5',
            readOnly: true,
            fieldCls: 'form-unedit',
            labelWidth: 135//控件默认标签宽度
        },
        defaultType: 'textfield',
        items: [
            {
                fieldLabel: "申请单ID",
                name: "HKD_ID",
                hidden: true
            },
            {
                fieldLabel: '支付总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '支付本金总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_BJ_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '支付利息总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_LX_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '兑付费总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_DFF_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '支付发行服务费总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_FXF_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '支付托管服务费总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_TGF_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '支付罚息总金额(元)',
                xtype: "numberFieldFormat",
                name: "TOTAL_FX_PAY_AMT",
                hideTrigger: true,
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '<span class="required">✶</span>还款日期',
                name: "HK_DATE",
                xtype: "datefield",
                allowBlank: false,
                readOnly: false,
                format: 'Y-m-d',
                fieldCls: null,
                blankText: '请选择还款日期',
                value: new Date(),
                listeners: {
                    change: function (self, newValue, oldValue) {

                    }
                }
            },
            {
                fieldLabel: "<span class=\"required\">✶</span>还款单号",
                name: "HK_NO", width: 150,
                readOnly: false,
                maxLength: 20,//限制输入字数
                maxLengthText: "输入内容过长！",
                editable: false,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '备注',
                name: "REMARK",
                columnWidth: .99,
                readOnly: false,
                fieldCls: null,
                listeners: {
                    change: function (self, newValue, oldValue) {
                        //下方表格中所有还款日期设置为该日期
                        var store = self.up('window').down('grid#win_input_tab_mxgrid').getStore();
                        store.each(function (record) {
                            record.set('REMARK', newValue);
                        });
                    }
                }
            }
        ],
        listeners: {
            'beforeRender': function () {
                if (IS_VIEW) {
                    SetItemReadOnly(this.items);
                }
            }
        }
    });
}

/**
 * 初始化转贷还款弹出框：下部页签panel
 */
function initWin_input_tab() {
    return Ext.create('Ext.tab.Panel', {
        width: '100%',
        flex: 1,
        items: [
            {
                title: '明细情况',
                layout: 'fit',
                scrollable: true,
                items: initWin_input_tab_mxgrid()
            },
            {
                title: '明细附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        items: initWin_input_tab_upload(HkId)
                    }
                ],
                listeners: {
                    beforeactivate: function (self) {
                        // 检验明细是否有数据
                        var grid = self.up('tabpanel').down('grid#win_input_tab_mxgrid');
                        if (grid.getStore().getCount() <= 0) {
                            Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                            return false;
                        }
                        // 获取选中数据
                        var record = grid.getCurrentRecord();
                        //如果当前无选中行，默认选中第一条数据
                        if (!record) {
                            $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                            record = grid.getStore().getAt(0);
                            Ext.toast({
                                html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        }
                        var panel = self.down('panel');
                        panel.removeAll(true);
                        panel.add(initWin_input_tab_upload(record.get('HK_ID')));
                    }
                }
            }
        ]
    });
}

/**
 * 初始化主表格
 */
function initWin_input_tab_mxgrid() {
    var headerjson_hkdmx = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string", hidden: true},
        {text: '还款单id', dataIndex: "HKD_ID", type: "string", hidden: true},
        {text: '还款计划id', dataIndex: "HK_ID", type: "string", hidden: true},
        {text: '债券id', dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: '兑付计划id', dataIndex: "DF_PLAN_ID", type: "string", hidden: true},
        {text: '还款类型', dataIndex: "PLAN_TYPE", type: "string", hidden: true},
        {text: '还款类型', dataIndex: "HK_TYPE", type: "string", hidden: true},
        {text: '地区编码', dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: '债券id', dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: "还款日期", dataIndex: "HK_DATE", type: "string", hidden: true},
        {text: '备注', dataIndex: "REMARK", type: "string", hidden: true},
        {text: "还款总金额(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", hidden: true},
        {
            text: "还款金额(元)", dataIndex: "HK_HK_AMT", width: 180, type: "float", summaryType: 'sum', headerMark: 'star',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {
                name: "HK_HK_AMT",
                xtype: "numberFieldFormat",
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            }
        },
        {
            text: "兑付费金额(元)",
            dataIndex: "HK_DFF_AMT",
            width: 180,
            type: "float",
            summaryType: 'sum',
            headerMark: 'star',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {
                name: "HK_DFF_AMT",
                xtype: "numberFieldFormat",
                decimalPrecision: 2,
                hideTrigger: true,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            }
        },
        {
            text: "偿还资金来源", dataIndex: "ZJLY_ID", width: 250, type: "string", headerMark: 'star',
            renderer: function (value, cell, record) {
                var rec = store_ZJLY.findNode('code', value, true, true, true);
                return rec != null ? rec.get('name') : value;
            },
            editor: {
                xtype: 'treecombobox',
                store: store_ZJLY,
                selectModel: 'leaf',
                displayField: 'name',
                valueField: 'code',
                editable: false,
                allowBlank: false
            }
        },
        {text: '应还款日期', dataIndex: "DF_END_DATE", width: 100, type: "string", tdCls: 'grid-cell-unedit'},
        {text: '还款类型', dataIndex: "PLAN_TYPE_NAME", type: "string", tdCls: 'grid-cell-unedit'},
        {
            text: '剩余应还金额(元)',
            dataIndex: "SYYH_AMT",
            width: 180,
            summaryType: 'sum',
            type: "float",
            tdCls: 'grid-cell-unedit',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: '剩余兑付费金额(元)',
            dataIndex: "SYDFF_AMT",
            width: 180,
            summaryType: 'sum',
            type: "float",
            tdCls: 'grid-cell-unedit',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: '兑付手续费率(‰)', dataIndex: "DFSXF_RATE", width: 150, type: "float", tdCls: 'grid-cell-unedit',
            renderer: function (value, cell, reocrd) {
                return Ext.util.Format.number(value * 10, '0,000.######');
            }
        },
        {text: "逾期本金(元)", dataIndex: "YQBJ_AMT", type: "float", width: 200, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "逾期利息(元)", dataIndex: "YQLX_AMT", type: "float", width: 200, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "实际还款日期", dataIndex: "PAY_DATE", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
        {text: "逾期天数", dataIndex: "YQ_DAYS", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
        {text: "罚息率(‰)", dataIndex: "ZNJ_RATE", type: "string", width: 150, tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value*10, '0,000.00####');
            }
        },
        {text: '债券编码', dataIndex: "ZQ_CODE", type: "string", tdCls: 'grid-cell-unedit'},
        {
            text: '债券名称', dataIndex: "ZQ_NAME", type: "string", tdCls: 'grid-cell-unedit', width: 250,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + userAdCode;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(userAdCode);
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: '债券期限', dataIndex: "ZQQX_NAME", type: "string", tdCls: 'grid-cell-unedit'},
        {text: '债券类型', dataIndex: "ZQLB_NAME", type: "string", tdCls: 'grid-cell-unedit'},
        {text: '转贷金额(元)', dataIndex: "ZD_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit'},
        {
            text: '承担金额(元)',
            dataIndex: "CDBJ_AMT",
            type: "float",
            summaryType: 'sum',
            width: 180,
            tdCls: 'grid-cell-unedit',
            hidden: SYS_IS_QEHBFX == 0,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '债券到期日', dataIndex: "DQDF_DATE", type: "string", tdCls: 'grid-cell-unedit', hidden: SYS_IS_QEHBFX == 1}
    ];
    if (!(DFF_CH_MODE == 0)) {
        Ext.Array.forEach(headerjson_hkdmx, function (header) {
            if (header.dataIndex == 'HK_DFF_AMT') {
                delete header.headerMark;//删除星号
                //delete header.editor;//不可编辑
                //header.tdCls = 'grid-cell-unedit';//置为不可编辑状态
            }
        });
    }
    var config = {
        itemId: 'win_input_tab_mxgrid',
        headerConfig: {
            headerJson: headerjson_hkdmx,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            DQ_YEAR: '',
            DQ_MO: ''
        },
        data: [],
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {

                    },
                    'validateedit': function (editor, context) {

                    },
                    'edit': function (editor, context) {
                        if (context.field == 'HK_HK_AMT') {
                            if (DFF_CH_MODE == 0) {
                                //计算兑付费金额
                                var dfsxf_rate = context.record.get('DFSXF_RATE');
                                var dff_amt = context.value * dfsxf_rate / 100;
                            }
                            //更新数据后格式化
                            dff_amt = Ext.util.Format.number(dff_amt, '0,000.00');
                            if (context.record.get('SYDFF_AMT') > 0) {
                                context.record.set('HK_DFF_AMT', dff_amt);
                            }
                            context.record.set('TOTAL_PAY_AMT', context.record.get('HK_HK_AMT') + context.record.get('HK_DFF_AMT'));

                        }
                        if (context.field == 'HK_DFF_AMT') {
                            context.record.set('TOTAL_PAY_AMT', context.record.get('HK_HK_AMT') + context.record.get('HK_DFF_AMT'));
                        }

                    }
                }
            }
        ],
        listeners: {
            selectionchange: function (self, records) {
                if (grid.up('window').down('[name=delete_editGrid]')) {
                    grid.up('window').down('[name=delete_editGrid]').setDisabled(!records.length);
                }
            },
            beforeedit: function (editor, context) {
                // 校验：罚息必须全额还款，
                if ((context.field == 'HK_HK_AMT' || context.field == 'HK_DFF_AMT' ||
                        context.field == 'ZJLY_ID') && context.record.get("PLAN_TYPE") == '4') {
                    return false;
                }
                // 校验：罚息必须全额还款，
                if (!(context.record.get("PLAN_TYPE") == '0' || context.record.get("PLAN_TYPE") == '1') && context.field == 'ZJLY_ID') {
                    return false;
                }
            },
            edit: function (editor, context) {
                if (context.field == 'HK_HK_AMT') { // 校验：申请还款资金不能大于剩余应还金额资金
                    if (context.value > context.record.get("SYYH_AMT")) {
                        Ext.MessageBox.alert('提示', '还款金额不能大于剩余应还款金额！');
                        context.record.set('HK_HK_AMT', context.record.get("SYYH_AMT"));
                    }
                }
                if (context.field == 'HK_DFF_AMT') { // 校验：申请还款兑付费资金不能大于剩余应缴付剩余兑付费资金
                    if (context.value > context.record.get("SYDFF_AMT")) {
                        Ext.MessageBox.alert('提示', '兑付费金额不能大于剩余兑付费金额！');
                        context.record.set('HK_DFF_AMT', context.record.get("SYDFF_AMT"));
                    }
                }
            }
        }
    };
    if (IS_VIEW) {
        delete config.plugins;
    }
    var grid = DSYGrid.createGrid(config);
    grid.getStore().on('endupdate', function () {
        //计算录入窗口form当年申请金额
        var self = grid.getStore();
        var sum_RMB = 0;
        var sum_RMB_BJ = 0;
        var sum_RMB_LX = 0;
        var sum_RMB_FXF = 0;
        var sum_RMB_TGF = 0;
        var sum_RMB_FX = 0;
        var sum_RMB_DFF = 0;
        self.each(function (record) {
            sum_RMB += record.get('HK_HK_AMT') + record.get('HK_DFF_AMT');
            if (record.get('PLAN_TYPE') == '0') {
                sum_RMB_BJ += record.get('HK_HK_AMT');
            }
            if (record.get('PLAN_TYPE') == '1') {
                sum_RMB_LX += record.get('HK_HK_AMT');
            }
            if (record.get('PLAN_TYPE') == '2') {
                sum_RMB_FXF += record.get('HK_HK_AMT');
            }
            if (record.get('PLAN_TYPE') == '3') {
                sum_RMB_TGF += record.get('HK_HK_AMT');
            }
            if (record.get('PLAN_TYPE') == '4') {
                sum_RMB_FX += record.get('HK_HK_AMT');
            }
            sum_RMB_DFF += record.get('HK_DFF_AMT');
        });
        grid.up('window').down('form').down('[name=TOTAL_PAY_AMT]').setValue(sum_RMB);
        grid.up('window').down('form').down('[name=TOTAL_BJ_PAY_AMT]').setValue(sum_RMB_BJ);
        grid.up('window').down('form').down('[name=TOTAL_LX_PAY_AMT]').setValue(sum_RMB_LX);
        grid.up('window').down('form').down('[name=TOTAL_FXF_PAY_AMT]').setValue(sum_RMB_FXF);
        grid.up('window').down('form').down('[name=TOTAL_TGF_PAY_AMT]').setValue(sum_RMB_TGF);
        grid.up('window').down('form').down('[name=TOTAL_FX_PAY_AMT]').setValue(sum_RMB_FX);
        grid.up('window').down('form').down('[name=TOTAL_DFF_AMT]').setValue(sum_RMB_DFF);
    });
    return grid;
}

/**
 * 初始化填报表单中的附件
 */
function initWin_input_tab_upload(HkId) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET203',//业务类型
        busiId: HkId,//业务ID
        editable: true,
        gridConfig: {
            itemId: 'win_input_tab_upload_grid'
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

function initWindow_select() {
    var items = [initWindow_select_grid()];
    if (userAdCode.length == 4 && !(userAdCode.lastIndexOf("00") == 2)) {
        items = [initWindow_select_grid(), initWindow_select_grid_detail()]
    }
    return Ext.create('Ext.window.Window', {
        title: '选择转贷还款计划', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: items,
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    // 获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作！');
                        return false;
                    }
                    //获取还款明细信息以及债券信息
                    var data_mx = [];
                    var data_zq = records[0].getData();
                    for (var i = 0; i < records.length; i++) {
                        var obj = records[i].getData();
                        obj.HK_DATE = Ext.util.Format.date(new Date(), 'Y-m-d');
                        data_mx.push(obj);
                    }
                    //发送ajax请求，获取新增主表id
                    $.post("/getId.action", {size: records.length + 1}, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //给每条明细增加ID，后面附件使用
                        for (var i = 0; i < data_mx.length; i++) { //设置默认值
                            var obj = data_mx[i];
                            obj.HK_ID = data.data[i + 1];
                            obj.HK_HK_AMT = obj.SYYH_AMT;
                            obj.HK_DFF_AMT = obj.SYDFF_AMT;
                        }
                        //弹出填报页面，并写入债券信息以及明细信息
                        var window_input = Ext.ComponentQuery.query('window#window_input')[0];
                        if (!window_input) {
                            window_input = initWin_input();
                            window_input.show();
                            $.post("/getHkNO_WS.action", function (result) {
                                if (!result.success) {
                                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                    return;
                                }
                                data_zq.HK_NO = result.list[0].HK_NO;
                                window_input.down('form').getForm().setValues(data_zq);
                            }, "json");
                        }
                        //获取已录入债券ID列表
                        var grid = window_input.down('#win_input_tab_mxgrid');
                        var store = grid.getStore();
                        var list_dfjh = {};
                        for (var j = 0; j < store.getCount(); j++) {
                            var record = store.getAt(j);
                            list_dfjh[record.get('DF_PLAN_ID')] = true;
                        }
                        var data_mxs = [];
                        //循环插入数据，如果已存在该兑付计划，不录入
                        for (var i = 0; i < data_mx.length; i++) {
                            var obj = data_mx[i];
                            if (!(DFF_CH_MODE == 0)) {
                                obj.HK_DFF_AMT = '0.00'//给获取到的数据中的兑付费赋值为0.00
                            }
                            obj.FLAG_EDIT = 'INSERT';
                            if (list_dfjh[obj.DF_PLAN_ID]) {
                                continue;
                            }
                            data_mxs.push(obj);
                        }
                        window_input.down('#win_input_tab_mxgrid').insertData(null, data_mxs);
                        //刷新填报弹出中转贷明细表获取转贷计划
                        btn.up('window').close();
                    }, "json");
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

function initWindow_select_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 100},
        {text: "应还款日期", dataIndex: "DQ_DATE", type: "string", width: 100},
        {text: "还款类型", dataIndex: "PLAN_TYPE_NAME", type: "string", width: 80},
        {
            text: "剩余应还金额(元)", dataIndex: "SYYH_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余兑付费金额(元)", dataIndex: "SYDFF_AMT", width: 200, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 300,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + userAdCode;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(userAdCode);
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            text: "还款计划总额(元)", dataIndex: "CD_AMT", width: 150, type: "float",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "本级还款金额(元)", dataIndex: "BJ_YHK", width: 200, type: "float", hidden: defaultHidden},
        {text: "逾期本金(元)", dataIndex: "YQBJ_AMT", type: "float", width: 200,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "逾期利息(元)", dataIndex: "YQLX_AMT", type: "float", width: 200,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "实际还款日期", dataIndex: "PAY_DATE", type: "string", width: 150},
        {text: "逾期天数", dataIndex: "YQ_DAYS", type: "string", width: 150},
        {
            text: "罚息率(‰)", dataIndex: "ZNJ_RATE", type: "string", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value * 10, '0,000.00####');
            }
        },
        {text: "提前还款天数", dataIndex: "TQHK_DAYS", type: "number"},
        {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 150},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 150},
        {text: "债券批次", dataIndex: "ZQ_PC_NAME", type: "string", width: 150},
        {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 80}

    ];
    return DSYGrid.createGrid({
        itemId: 'grid_select',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        width: '100%',
        flex: 1,
        dataUrl: 'getZdHkjhGridData_WS.action',
        pageConfig: {
            enablePage: false
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                layout: 'column',
                defaults: {
                    margin: '0 8 5 0'
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "HKJH_YEAR",
                        store: DebtEleStore(json_debt_year),
                        displayField: "name",
                        valueField: "id",
                        value: new Date().getFullYear(),
                        fieldLabel: '到期年月',
                        editable: false, //禁用编辑
                        labelWidth: 70,
                        width: 175
                    },
                    '-',
                    {
                        xtype: "combobox",
                        name: "HKJH_MO",
                        store: DebtEleStore(json_debt_yf_nd),
                        displayField: "name",
                        valueField: "id",
                        value: lpad(1 + new Date().getUTCMonth(), 2),
                        editable: false, //禁用编辑
                        width: 85
                    },
                    {
                        xtype: "combobox",
                        name: "HK_TYPE",
                        fieldLabel: '还款类型',
                        store: DebtEleStore(hkTypeStore),
                        displayField: "name",
                        valueField: "id",
                        editable: false, //禁用编辑
                        labelWidth: 60,
                        width: 175,
                        listeners: {
                            change: function (self, newValue) {
                                self.up('window').down('grid').getStore().getProxy().extraParams['HK_TYPE'] = newValue;
                                self.up('window').down('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLB_ID",
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债券类别',
                        editable: false, //禁用编辑
                        labelWidth: 60,
                        width: 175,
                        labelAlign: 'left',
                        listeners: {
                            change: function (self, newValue) {
                                if (!!self.up('window')) {
                                    self.up('window').down('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                                    self.up('window').down('grid').getStore().loadPage(1);
                                }
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQ_PC_ID",
                        store: DebtEleStoreDB('DEBT_ZQPC'),
                        fieldLabel: '债券批次',
                        displayField: 'name',
                        valueField: "id",
                        editable: false, //禁用编辑
                        labelWidth: 60,
                        width: 185,
                        labelAlign: 'left',
                        listeners: {
                            change: function (self, newValue) {
                                self.up('window').down('grid').getStore().getProxy().extraParams['ZQ_PC_ID'] = self.getValue();
                                self.up('window').down('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "checkbox",
                        name: "select_yq",
                        labelAlign: 'right',
                        labelSeparator: '',
                        fieldLabel: '仅显示逾期',
                        labelWidth: 65,
                        hidden: true
                    },
                    {
                        boxLabel: '包含未支付兑付费计划',
                        name: 'flag_sydff_amt',
                        xtype: 'checkbox',
                        width: 160
                    },
                    {
                        xtype: "textfield",
                        name: "zqmc",
                        fieldLabel: '模糊查询',
                        labelWidth: 60,
                        width: 250,
                        emptyText: '请输入债券名称/债券编码...',
                        editable: true,
                        enableKeyEvents: true,
                        listeners: {
                            'keydown': function (self, e) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    var win = self.up('window');
                                    var ZQMC = win.down('textfield[name="zqmc"]').getValue();
                                    var DQ_YEAR = win.down('combobox[name="HKJH_YEAR"]').value;
                                    var DQ_MO = win.down('combobox[name="HKJH_MO"]').value;
                                    var ZQLB_ID = win.down('treecombobox[name="ZQLB_ID"]').value;
                                    var ZQ_PC_ID = win.down('combobox[name="ZQ_PC_ID"]').value;
                                    var SELECT_YQ = win.down('checkbox[name="select_yq"]').value;
                                    if (SELECT_YQ) {
                                        SELECT_YQ = 'Y';
                                    } else {
                                        SELECT_YQ = 'N';
                                    }
                                    var flag_sydff_amt = win.down('checkbox[name="flag_sydff_amt"]').value;
                                    //刷新表格数据lur
                                    var store = self.up('window').down('grid').getStore();
                                    store.getProxy().extraParams = {
                                        DQ_YEAR: DQ_YEAR,
                                        DQ_MO: DQ_MO,
                                        SELECT_YQ: SELECT_YQ,
                                        ZQMC: ZQMC,
                                        FLAG_SYDFF_AMT: flag_sydff_amt,
                                        ZQLB_ID: ZQLB_ID,
                                        ZQ_PC_ID: ZQ_PC_ID
                                    };
                                    //刷新表格数据lur
                                    // var store = self.up('window').down('grid').getStore()
                                    store.loadPage(1);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        style: {marginRight: '20px'},
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            var win = btn.up('window');
                            var HK_TYPE = win.down('combobox[name="HK_TYPE"]').value;
                            var ZQMC = win.down('textfield[name="zqmc"]').getValue();
                            var DQ_YEAR = win.down('combobox[name="HKJH_YEAR"]').value;
                            var DQ_MO = win.down('combobox[name="HKJH_MO"]').value;
                            var ZQLB_ID = win.down('treecombobox[name="ZQLB_ID"]').value;
                            var ZQ_PC_ID = win.down('combobox[name="ZQ_PC_ID"]').value;
                            var SELECT_YQ = win.down('checkbox[name="select_yq"]').value;
                            if (SELECT_YQ) {
                                SELECT_YQ = 'Y';
                            } else {
                                SELECT_YQ = 'N';
                            }
                            var flag_sydff_amt = win.down('checkbox[name="flag_sydff_amt"]').value;
                            //刷新表格数据lur
                            var store = btn.up('window').down('grid').getStore();
                            store.getProxy().extraParams = {
                                DQ_YEAR: DQ_YEAR,
                                DQ_MO: DQ_MO,
                                SELECT_YQ: SELECT_YQ,
                                ZQMC: ZQMC,
                                FLAG_SYDFF_AMT: flag_sydff_amt,
                                ZQLB_ID: ZQLB_ID,
                                ZQ_PC_ID: ZQ_PC_ID,
                                HK_TYPE: HK_TYPE
                            };
                            store.loadPage(1);

                        }
                    }
                ],
                dock: 'top',
            }],
        params: {
            DQ_YEAR: new Date().getFullYear(),
            DQ_MO: lpad(1 + new Date().getUTCMonth(), 2),
            SELECT_YQ: 0
        },
        listeners: {
            itemclick: function (self, record) {
                if (userAdCode.length == 4 && !(userAdCode.lastIndexOf("00") == 2)) {
                    //刷新明细表
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['AD_CODE'] = record.get('AD_CODE');
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['PLAN_TYPE'] = record.get('PLAN_TYPE');
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['DF_END_DATE'] = record.get('DF_END_DATE');
                    DSYGrid.getGrid('grid_select_detail').getStore().getProxy().extraParams['ZQ_ID'] = record.get('ZQ_ID');
                    DSYGrid.getGrid('grid_select_detail').getStore().loadPage(1);
                }
            }
        }
    });
}

function initWindow_select_grid_detail() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            dataIndex: "AD_NAME", type: "string", text: "地区名称", width: 200, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "还款类型", dataIndex: "HK_TYPE_NAME", type: "string", width: 80},
        {text: "还款日期", dataIndex: "HK_DATE", type: "string", width: 100},
        {
            text: "应还款金额(元)", dataIndex: "DQ_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "应还兑付费(元)", dataIndex: "PLAN_DFF_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "还款金额(元)", dataIndex: "HK_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "兑付费金额(元)", dataIndex: "DFF_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "还款总金额(元)", dataIndex: "TOTAL_PAY_AMT", width: 200, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}
    ];
    return DSYGrid.createGrid({
        itemId: 'grid_select_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        tbar: ['下级地区还款信息'],
        height: '50%',
        width: '100%',
        flex: 1,
        autoLoad: false,
        border: false,
        pageConfig: {
            enablePage: false
        },
        dataUrl: 'getZdHkXjzdGridData_WS.action',
        features: [{
            ftype: 'summary'
        }]
    });
}

/* ============================== 《修正流程》 ======================================================================= */
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
        ids.push(records[i].get("HK_YC_ID"));
    }
    button_name = btn.name;
    button_text = btn.text;
    if (button_text == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("/editYcxzInfo.action", {
                    workflow_direction: button_name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_text,
                    audit_info: '',
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({html: button_text + "成功！"});
                    } else {
                        Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        });
    } else {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + "意见",
            animateTarget: btn,
            value: btn.name == 'up' ? null : '同意',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/editYcxzInfo.action", {
                        workflow_direction: button_name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_text,
                        audit_info: text,
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({html: button_text + "成功！"});
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
 *  刷新主面板
 */
function reloadGrid() {
    var gridStore = DSYGrid.getGrid('contentGrid').getStore();
    gridStore.getProxy().extraParams = {
        AG_ID: AG_ID,
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        wf_id: wf_id,
        node_code: node_code,
        node_type: node_type,
        button_name: button_name,
        WF_STATUS: WF_STATUS
    };
    gridStore.removeAll();
    //刷新
    gridStore.loadPage(1);
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
        var contentGrid_ID = records[0].get("HK_YC_ID");
        fuc_getWorkFlowLog(contentGrid_ID);
    }
}

//取当前月时 长度为1时左侧补0
function lpad(num, n) {
    return (Array(n).join(0) + num).slice(-n);
}