/**
 * js：提款审核
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
$.extend(jjxx_json_common[wf_id][node_type], {
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
                icon: '/image/sysbutton/songsheng.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
			{
				xtype : 'button',
				text : '退回',
				name : 'back',
				icon : '/image/sysbutton/back.png',
				handler : function(btn) {
					//弹出对话框填写意见
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
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
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
//            ,
//            {
//                xtype: 'button',
//                text: '撤销审核',
//                icon: '/image/sysbutton/search.png',
//                handler: function (btn) {
//                	doWorkFlow(btn);
//                }
//            }
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
                    	doWorkFlow(btn);
                    }
                },
    			{
    				xtype : 'button',
    				text : '退回',
    				name : 'back',
    				icon : '/image/sysbutton/back.png',
    				handler : function(btn) {
    					//弹出对话框填写意见
    					doWorkFlow(btn);
    				}
    			},
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
    }
});
/**
 * 操作记录
 */
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        var JJXX_ID = records[0].get("JJXX_ID");

        fuc_getWorkFlowLog(JJXX_ID);
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
        is_end: is_end,
        wf_id: wf_id,
        node_code: node_code,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        ZQFL_ID: zqlx,
        xm_name: xm_name,
        WF_STATUS: WF_STATUS,
        zwlb_id: zwlb_id
    };
    store.loadPage(1);
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
//        {dataIndex: "PAT_DATE", width: 250, type: "string", text: "申请日期"},
//        {dataIndex: "AG_NAME", width: 250, type: "string", text: "单位名称"},
//        {dataIndex: "PAT_AMT_RMB", width: 250, type: "float", text: "申请金额"},
//        {dataIndex: "REMARK", width: 250, type: "string", text: "备注"}
        {
            "dataIndex": "JJXX_ID", "type": "string", "text": "举借ID", "fontSize": "15px", "hidden": true
        },
        {
            "dataIndex": "ZW_ID", "type": "string", "text": "债务ID", "fontSize": "15px", "hidden": true
        },
        {
            "dataIndex": "ZW_CODE", "type": "string", "text": "债务编码", "fontSize": "15px", "hidden": true
        },
        {
            "dataIndex": "JJXX_CODE", "type": "string", "text": "申请单号", "fontSize": "15px", "width": 200
        },
        {
            "dataIndex": "AG_NAME", "type": "string", "text": "债务单位", "fontSize": "15px", "width": 250
        },
        {
            "dataIndex": "ZW_NAME", "width": 250, "type": "string", "text": "债务名称",
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
        },
        {
            "dataIndex": "FETCH_DATE", "width": 100, "type": "string", "text": "提款日期"
        },
        {
            "dataIndex": "FETCH_AMT", "width": 150, "type": "float", "text": "提款金额(原币)"
        },
        {
            "dataIndex": "HL_RATE", type: "string", text: "汇率",hidden:zwlb_id == 'wb' ? false:true,
                    editor: {
                        xtype: 'numberfield',
                        decimalPrecision: 6,
                        hideTrigger: true
                    }, width: 100,align: 'right'
         },
        {"dataIndex": "FETCH_AMT_RMB", type: "float", text: "提款金额(人民币)", width: 150,hidden:zwlb_id == 'wb' ? false:true},
        {
            "dataIndex": "XM_NAME", "width": 250, "type": "string", "text": "建设项目",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID='+record.get('XM_ID');
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
        {
            dataIndex: "ZJLY_ID", type: "string", text: "偿还资金来源ID", width: 120, align: 'left',hidden:true
          
        }, 
        {
            dataIndex: "ZJLY_NAME", type: "string", text: "偿还资金来源", width: 250, align: 'left'
          
        },{
        	dataIndex: "TKPZ_NO",
        	type: "string",
        	text: '提款凭证号',
        	width: 120, 
        	align: 'left'
           /* editor: {
                xtype: 'treecombobox', 
                itemId: 'tkpzno',  
                store: DebtEleStore(json_debt_zwlb),
                selectModel: 'leaf',
                displayField: "name",
                valueField: "id" 
           }*/
        },
        {
            "dataIndex": "JZ_DATE", "width": 100, "type": "string", "text": "记账日期"
        },
        {
            dataIndex: "JZ_NO",
            type: "string", 
            text: '会计凭证号',
            width: 120, 
        	align: 'left'
        },
        {
            "dataIndex": "XY_AMT", "width": 150, "type": "float", "text": "协议金额(原币)",hidden:true
        },
        {
            "dataIndex": "SIGN_DATE", "width": 100, "type": "string", "text": "签订日期",hidden:true
        },
        {
            "dataIndex": "ZJYT_NAME", "width": 250, "type": "string", "text": "债务资金用途",hidden:true
        },
        {
            "dataIndex": "ZQLX_NAME", "width": 150, "type": "string", "text": "债权类型",hidden:true
        },
        {
            "dataIndex": "ZQR_NAME", "width": 150, "type": "string", "text": "债权人",hidden:true
        },
        {
            "dataIndex": "ZQR_FULLNAME", "width": 320, "type": "string", "text": "债权人全称",hidden:true
        },
        {
            "dataIndex": "TZBS", "width": 150, "type": "string", "text": "调整标识",hidden:true,
            renderer: function (value) {
                var store = DebtEleStore(json_debt_tzbs);
                var record = store.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            "dataIndex": "REMARK", "width": 250, "type": "string", "text": "备注"
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        //rowNumber: true,
        border: false,
        height: '50%',
        autoLoad: false,
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt2_2),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                editable: false,
                allowBlank: false,
                listeners: {
                    'change': function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(jjxx_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        self.up('grid').getStore().getProxy().extraParams["wf_id"] = wf_id;
                        self.up('grid').getStore().getProxy().extraParams["node_code"] = node_code;
                        self.up('grid').getStore().loadPage(1);

                    }
                }
            }
        ],
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            zwlb_id: zwlb_id
        },
        dataUrl: 'getJjxxListForSJSH.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                OPERATE = 'UPDATE';
                //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                AG_NAME = record.get('AG_NAME');
                ZW_ID = record.get('ZW_ID');
                ZW_CODE = record.get('ZW_CODE');
                ZW_NAME = record.get('ZW_NAME');
                var bb = Ext.create("Ext.Button", {
                    text: "修改",
                    id: "xiugai"
                });
                init_edit_jjxx(bb);
            }
        }
    });
}
/**
 * 举借信息弹出框
 * @param btn
 */
function init_edit_jjxx(btn) {
    var dialog_job = Ext.create('Ext.window.Window', {
        title: "举借信息-" + AG_NAME,
        itemId: 'jjxxadd',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.95,
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'anchor',
        items: [initEditor(btn), initTabPanel()]
    });
    dialog_job.show();
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
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("JJXX_ID"));
    }
    var zwids = [];
    var jjxxInfoArray = [];
    for (var i in records) {
        zwids.push(records[i].get("ZW_ID"));
        var array = {};
        array.fetch_date = records[i].get("FETCH_DATE");
        array.ad_code = records[i].get("AD_CODE");
        array.zw_id = records[i].get("ZW_ID");
        array.ID = records[i].get("JJXX_ID");
        jjxxInfoArray.push(array);
    }
    button_name = btn.text;
    button_id = btn.name;
    if (btn.text == '撤销') {
        if (records.length > 1) {
            Ext.MessageBox.alert('提示', '撤销只能选择一条数据进行操作');
            return;
        }
        else {
            Ext.MessageBox.show({
                title: '撤回',
                msg: '确定要撤回吗？',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function (btn, text, opt) {
                    if (btn === 'yes') {
                        $.post("/updateJJxxNodeForSJSH.action", {
                            workflow_direction: button_id,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            is_end: is_end,
                            ids: ids,
                            zwids: zwids,
                            jjxxInfoArray: Ext.util.JSON.encode(jjxxInfoArray)
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
            return;
        }
    }
    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text+'意见',
        value :btn.text == '审核'?'同意': '',
        animateTarget: btn,
        fn: function (buttonId, text, opt) {
            if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/updateJJxxNodeForSJSH.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: text,
                    is_end: is_end,
                    ids: ids,
                    zwids: zwids,
                    jjxxInfoArray: Ext.util.JSON.encode(jjxxInfoArray)
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
/**
 * 举借初始化，初始化弹出框上部提款信息表单
 * @return {Ext.form.Panel}
 */
function initEditor() {
    var condition = 'and 1=1';
    //债务清洗赋值
    if (wf_id != null && wf_id != '100117') {
        q_zwlb_id = zwqx_zwlb_id;
    }
    if (q_zwlb_id == '0101') {//0101一般债务，偿还资金来源0101下的
        condition = "and code like '0101%'";
    } else if (q_zwlb_id == '0102') {//0102专项债务，偿还资金来源0102下的
        condition = "and code like '0102%'";
    } else if (q_zwlb_id.substring(0, 2) == '02') {//02或有债务，偿还资金来源02下的
        condition = "and code like '02%'";
    }
    var editorPanel = Ext.create('Ext.form.Panel', {
        layout: 'anchor',
        border: false,
        split: true,
        anchor: '100%',
        itemId: 'jjxxaddform',
        items: [
            {
                xtype: 'fieldset',
                title: '提款信息',
                layout: 'column',
                anchor: "100%",
                margin: '0 2 2 2',
                defaults: {
                    columnWidth: .33,
                    margin: '5 5 5 5',
                    labelAlign: 'left',
                    labelWidth: 140,
                    allowBlank: true
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '举借id',
                        name: "JJXX_ID",
                        editable: false,
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债务名称',
                        name: "ZW_AG_NAME",
                        editable: false
                    },
                    {
                        xtype: "textfield",
                        name: "SIGN_DATE",
                        fieldLabel: '签订日期',
                        editable: false
                    },
                    {
                        xtype: "textfield",
                        name: "JZ_NO",
                        fieldLabel: '记账凭证号',
                        allowBlank: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "XY_AMT",
                        fieldLabel: '协议金额(原币)',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: false
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "IS_FETCH_AMT",
                        fieldLabel: '已申请金额(原币)',
                        emptyText: '0.00',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: false
                    },
                    {
                        xtype: "datefield",
                        name: "JZ_DATE",
                        fieldLabel: '<span class="required">✶</span>记账日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择记账日期',
                        emptyText: '请选择记账日期',
                        value: today
                    },
                    {
                        xtype: "datefield",
                        name: "FETCH_DATE",
                        fieldLabel: '<span class="required">✶</span>提款日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择提款日期',
                        emptyText: '请选择提款日期',
                        value: today,
                        listeners: {
                            'change': function (self, newValue, oldValue, eOpts) {
//       	                		var fetch =editorPanel.getForm().findField("FETCH_DATE");
//       	                		if(node_code==1){
//           	                		var fetch_date=Ext.util.Format.date(fetch.getValue(),'Y-m-d');
//           	                		if(fetch_date>='2015-01-01'){
//           	                			this.up('form').getForm().findField('TZBS_ID').enable();
//           	                		}else{
//           	                			this.up('form').getForm().findField('TZBS_ID').disable();
//           	                		}
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        name: "TKPZ_NO",
                        //store: DebtEleStore(json_debt_zwlb),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>提款凭证号',
                        allowBlank: false,
                        listeners: {
                            'select': function () {
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "TZBS_ID",
                        store: DebtEleStore(json_debt_tzbs),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>调整标识',
                        allowBlank: false,
                        editable: false //禁用编辑
                    },
                    {
                        xtype: "textfield",
                        name: "FM_ID",
                        fieldLabel: "币种",
                        editable: false,
                        hidden: true
                    },
                    {
                        xtype: "numberfield",
                        name: "HL_RATE",
                        fieldLabel: '<span class="required">✶</span>汇率',
                        value: 1.000000,
                        allowBlank: false,
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        listeners: {
                            change: function (value) {
                                //计算提款人民币金额
                                value.up('container').down("numberfield[name='FETCH_AMT_RMB']").setValue(value.getValue() * value.up('container').down("numberfield[name='FETCH_AMT']").getValue());
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "FETCH_AMT",
                        fieldLabel: '<span class="required">✶</span>提款金额（原币）',
                        emptyText: '0.00',
                        allowDecimals: true,
                        allowBlank: false,
                        value: 0,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        listeners: {
                            change: function (value) {
                                //计算提款人民币金额
                                value.up('container').down("numberfield[name='FETCH_AMT_RMB']").setValue(value.getValue() * value.up('container').down("numberfield[name='HL_RATE']").getValue());
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "FETCH_AMT_RMB",
                        fieldLabel: '提款金额（人民币）',
                        emptyText: '0.00',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        editable: false
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZJLY_ID",
                        store: DebtEleTreeStoreDB('DEBT_CHZJLY'),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>偿还资金来源',
                        selectModel: 'leaf',
                        allowBlank: false,
                        listeners: {
                            'focus': function (event, eOpts) {
                                if (wf_id != null && wf_id != '100117') {
                                    var zjly_id = editorPanel.getForm().findField("ZJLY_ID");
                                    var zjly = zjly_id.getRawValue();
                                    if (zjlyCount == 0) {
                                        if (zjly == null || zjly == '') {
                                            zjly_id.setDisabled(false);
                                        } else {
                                            zjly_id.setDisabled(true);
                                        }
                                    }
                                    zjlyCount++;
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '债务备注',
                        xtype: "textfield",
                        name: "zw_remark",
                        columnWidth: .66,
                        allowBlank: true,
                        editable: false
                    },
                    {
                        fieldLabel: '提款备注',
                        xtype: "textfield",
                        name: "REMARK",
                        columnWidth: .99,
                        allowBlank: true
                    }
                ]
            }
        ],
        listeners: {
            'beforeRender': function () {
                SetItemReadOnly(this.items);
            }
        }
    });
    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
    var JJXX_ID = record.get('JJXX_ID');
    //债务清洗赋值
    if (wf_id != null && wf_id != '100117') {
        var records = DSYGrid.getGrid('jjxxGrid').getSelection();
        JJXX_ID = records[0].get('JJXX_ID');
    }
    $.post("/queryjjxxByid.action", {
        JJXX_ID: JJXX_ID,
        ZWXX_ID: ZW_ID,
        AG_ID: AG_ID
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
            return;
        }
        editorPanel.getForm().setValues(data.data);
        Ext.ComponentQuery.query('grid#hkjhgrid')[0].insertData(null, data.hkjhList);
        Ext.ComponentQuery.query('grid#yflxgrid')[0].insertData(null, data.yflxList);
        // initWidget(editorPanel);
    }, "json");
    return editorPanel;
}
/**
 * 初始化弹出框下部页签panel
 * @return {*}
 */
function initTabPanel() {
    var tabPanel = Ext.createWidget('tabpanel', {
        itemId: "tabPanel",
        activeTab: 0,
        anchor: '100% -225',
        items: [
            {title: '还本计划', items: inithkjh()},
            {title: '付息计划', items: inityflx()}
        ]
    });
    return tabPanel;
}
/**
 * 还款计划初始化
 */
function inithkjh() {
    var headerJson = [
        {
            "dataIndex": "HKJH_ID",
            "type": "string",
            "text": "还款计划ID",
            "hidden": true
        },
        {
            "dataIndex": "ISEDIT",
            "type": "string",
            "text": "是否操作标志",
            "hidden": true
        },
        {
            "text": "计划偿还日期", "dataIndex": "HKJH_DATE", "type": "string",
            editor: {xtype: 'datefield', allowBlank: false, format: 'Y-m-d'}
        },
        {
            "dataIndex": "HKJH_AMT",
            "type": "float",
            "text": "计划偿还金额(原币)",
            editor: {
                xtype: 'numberfield'
            }
        },
        {
            "dataIndex": "REMARK",
            "type": "string",
            "text": "备注",
            editor: {
                xtype: 'textfield'
            }
        }
    ];
    var hkjh_Fields = [
        {
            name: 'HKJH_ID',
            type: 'string',
            useNull: true,
            active: true,
            hidden: true
        },
        {
            name: 'ISEDIT',
            type: 'string',
            useNull: true,
            active: true,
            hidden: true
        },
        {
            name: 'HKJH_DATE',
            type: 'string',
            useNull: false,
            format: 'Y-m-d',
            active: true
        },
        {
            name: 'HKJH_AMT',
            type: 'float',
            useNull: false,
            active: true
        },
        {
            name: 'REMARK',
            type: 'string',
            useNull: true,
            active: true
        }
    ];
    if (wf_id != null && wf_id != '100117') {
        //加入header
        var zqhhkrq = {
            "dataIndex": "ZQ_HKJH_DATE",
            "type": "string",
            "text": "展期后还款日期"
        };

        var zqrq = {
            "dataIndex": "ZQ_DATE",
            "type": "string",
            "text": "展期日期"
        };

        var zqhth = {
            "dataIndex": "ZQ_HTH",
            "type": "string",
            "text": "展期合同号"
        };

        headerJson.push(zqhhkrq);
        headerJson.push(zqrq);
        headerJson.push(zqhth);

        //加入模型
        var zqhkrq_field = {
            name: 'ZQ_HKJH_DATE',
            type: 'string',
            useNull: true,
            active: true
        };

        var zqrq_field = {
            name: 'ZQ_DATE',
            type: 'string',
            useNull: true,
            active: true
        }

        var zqhth_field = {
            name: 'ZQ_HTH',
            type: 'string',
            useNull: true,
            active: true
        }

        hkjh_Fields.push(zqhkrq_field);
        hkjh_Fields.push(zqrq_field);
        hkjh_Fields.push(zqhth_field);
    }
    var grid = DSYGrid.createGrid({
        itemId: 'hkjhgrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true
        },
        checkBox: true,
        rowNumber: true,
        border: true,
        height: 180,
        flex: 1,
        data: [],
        pageConfig: {
            enablePage: false//设置显示每页条数
        }
    });
    // 定义编辑行model
    Ext.define('hkjh_demo', {
        extend: 'Ext.data.Model',
        fields: hkjh_Fields
    });
    // 将增加删除按钮添加到表格中
    grid.addDocked({
        xtype: 'toolbar',
        layout: 'hbox',
        items: ['->', {
            xtype: 'button',
            text: '增加',
            disabled: true,
            width: 80,
            handler: function (btn) {
                // rowEditing.cancelEdit();
                // 创建行model实例
                var row = Ext.create('hkjh_demo', {
                    HKJH_ID: '',
                    HKJH_DATE: Ext.Date
                        .clearTime(new Date()),
                    HKJH_AMT: 0,
                    REMARK: ''
                });
                btn.up('grid').insertData(null, row);
                // rowEditing.startEdit(0, 0);
            }
        }, {
            xtype: 'button',
            text: '删除',
            disabled: true,
            itemId: 'delete_editGrid',
            width: 80,
            handler: function (btn) {
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
/**
 * 应付利息初始化
 */
function inityflx() {
    try {
        var headerJson = [
            {"dataIndex": "YFLX_ID", "type": "string", "text": "应付利息ID", "hidden": true},
            {"dataIndex": "SOURCE", "type": "string", "text": "利息来源", "hidden": true},
            {
                "text": "计划偿还日期", "dataIndex": "YFRQ", "type": "string",
                editor: {xtype: 'datefield', allowBlank: false, format: 'Y-m-d'}
            },
            {"dataIndex": "YFLX_AMT", "type": "float", "text": "应偿还金额(原币)", editor: {xtype: 'numberfield'}},
            {"dataIndex": "REMARK", "type": "string", "text": "备注", editor: {xtype: 'textfield'}}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'yflxgrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: true
            },
            checkBox: true,
            rowNumber: true,
            border: true,
            height: 180,
            flex: 1,
            data: [],
            pageConfig: {
                enablePage: false//设置显示每页条数
            }
        });

        //定义编辑行model
        Ext.define('yflx_demo', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'YFLX_ID', type: 'string', useNull: true, active: true, hidden: true},
                {name: 'SOURCE', type: 'string', useNull: true, active: true, hidden: true},
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
                    xtype: 'button',
                    text: '增加',
                    disabled: true,
                    width: 80,
                    handler: function (btn) {
                        // 创建行model实例
                        var row = Ext.create('yflx_demo', {
                            YFLX_ID: '',
                            SOURCE: '1',
                            YFRQ: Ext.Date.clearTime(new Date()),
                            YFLX_AMT: 0,
                            REMARK: ''
                        });
                        btn.up('grid').insertData(null, row);
                        // 创建行model实例
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    disabled: true,
                    itemId: 'delete_editGrid',
                    width: 80,
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
        return grid;
    }
    catch (err) {
        // 当出现异常时，打印控制台异常
    }

}
    
