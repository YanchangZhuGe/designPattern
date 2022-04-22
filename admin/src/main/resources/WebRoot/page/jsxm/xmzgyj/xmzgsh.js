var json_debt_zt14 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "004", code: "004", name: "被退回"}
];
var json_debt_zt14_sheng = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"}
];
$.extend(xmzg_json_common[node_type], {
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
                    } else {
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    } else {
                        //弹出对话框填写意见
                        opinionWindow.open(btn, "审核意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        btn.setDisabled(false);
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    } else {
                        //弹出对话框填写意见
                        opinionWindow.open(btn, "退回意见");
                    }
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
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        btn.setDisabled(false);
                        return;
                    } else {
                        Ext.MessageBox.show({
                            title: "提示",
                            msg: "是否撤销选择的记录？",
                            width: 200,
                            buttons: Ext.MessageBox.OKCANCEL,
                            fn: function (b_btn, text) {
                                audit_info = text;
                                if (b_btn == "ok") {
                                    shWork(btn);
                                }else{
                                    btn.setDisabled(false);
                                }
                            }
                        });
                    }
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
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    } else {
                        //弹出对话框填写意见
                        opinionWindow.open(btn, "审核意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    } else {
                        //弹出对话框填写意见
                        opinionWindow.open(btn, "退回意见");
                    }
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});

/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (b_btn, title) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            value: b_btn.name == 'down' ? '同意' : '不同意',
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn, text) {
                audit_info = text;
                if (btn == "ok") {
                    if (isNull(audit_info)) {
                        if(title=="审核意见"){
                            Ext.Msg.alert('提示', '请录入审核意见！');
                        }else{
                            Ext.Msg.alert('提示', '请录入退回意见！');
                        }
                        b_btn.setDisabled(false);
                    } else {
                        shWork(b_btn);
                    }
                }else{
                    b_btn.setDisabled(false);
                }
            }
        });
    },
    close: function (b_btn) {
        if (this.window) {
            this.window.close();
        }
    }
};
/**
 * 项目整改审核撤销退回工作流
 */
function shWork(btn) {
    var btnName = btn.name;
    var msg_name = "";
    if (btnName == 'down') {
        msg_name = '审核';
    }else if (btnName == 'up') {
        msg_name = '退回';
    }else if (btnName == 'cancel') {
        msg_name = '撤销';
        audit_info = '';
    }
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    var basicInfoArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("ZGXX_ID");
        array.AD = record.get("AD_CODE");
        basicInfoArray.push(array);
    });
    //发送ajax请求，修改节点信息
    $.post("/xmzg/doWorkFlowActionSh.action", {
        audit_info: audit_info,
        userCode: userCode,
        workflow_direction: btnName,
        basicInfoArray: Ext.util.JSON.encode(basicInfoArray),
        AD_CODE:AD_CODE,
        AG_CODE:AG_CODE
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: msg_name + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.setDisabled(false);
            //操作日志
            saveLog('项目整改'+msg_name,'BUTTON','项目整改'+ msg_name +'成功','0');
        } else {
            btn.setDisabled(false);
            Ext.MessageBox.alert('提示', msg_name + '失败！' + data.message);
        }
        //刷新表格
        reloadGrid();
    }, "json");
}

/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    /**
     * 主表格表头
     */
    var headerJson = [
        {"dataIndex": "ZW_ID", "type": "string", "text": "债务ID", "hidden": true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "区划编码", "hidden": true},
        {"dataIndex": "AD_NAME", "type": "string", "text": "区划名称", "width": 180},
        {"dataIndex": "AG_ID", "type": "string", "text": "单位ID",  "hidden": true},
        {"dataIndex": "AG_CODE", "type": "string", "text": "单位编码", "hidden": true},
        {"dataIndex": "AG_NAME", "type": "string", "text": "单位名称", "width": 180},
        {
            "dataIndex": "XM_CODE",
            "type": "string",
            "width": 250,
            "text": "项目编码",
            "hrefType": "combo",
            "hidden": true
        },
        {
            "dataIndex": "XM_NAME",
            "type": "string",
            "text": "项目名称",
            "fontSize": "15px",
            "width": 250,
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
        {"dataIndex": "OP_CONTENT", "type": "string", "text": "整改意见", "width": 200},
        {"dataIndex": "HOLD1", "type": "string", "text": "整改意见来源", "width": 200,
            renderer: function (value) {
                var store = DebtEleStore(json_debt_zgyjly);
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {"dataIndex": "LX_YEAR", "type": "string", "text": "立项年度", "width": 200},
        {"dataIndex": "XMLX_NAME", "type": "string", "text": "项目类型", "width": 200},
        {"dataIndex": "JSZT_NAME", "type": "string", "text": "建设状态", "width": 200},
        {"dataIndex": "XMZGS_AMT", "width": 200, "type": "float", "align": 'right', "text": "项目总概算金额(万元)",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'contentGrid',
        border: false,
        flex: 1,
        layout: 'fit',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        params: {
            WF_STATUS: WF_STATUS,
            AG_CODE: AG_CODE,
            AD_CODE: AD_CODE
        },
        dataUrl: '/xmzg/getXmzgGrid.action',
        checkBox: true,
        pageConfig: {
            pageNum: true,//设置显示每页条数
            pageSize: 20// 每页显示数据数
        },
        listeners:{
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['id'] = record.get('ZGXX_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZGXX_ID'] = record.get('ZGXX_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(ADCODE.length == 2 ?json_debt_zt14_sheng : json_debt_zt14 ),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                editable:false,
                allowBlank:false,
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(xmzg_json_common[node_type].items[WF_STATUS]);
                        //刷新当前表格
                        if (AD_CODE == null || AD_CODE == '') {
                            return;
                        }
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '项目类型',
                name: 'XMLX_ID',
                displayField: 'name',
                valueField: 'id',
                width: 250,
                labelWidth: 60,
                lines: false,
                editable: false, // 禁用编辑
                allowBlank: true, //允许为空
                store: DebtEleTreeStoreDBTable("DSY_V_ELE_JXZBK_ZWXMLX"),
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'combobox',
                fieldLabel: '意见来源',
                name: 'HOLD1',
                displayField: 'name',
                valueField: 'id',
                width: 250,
                labelWidth: 60,
                lines: false,
                editable: false, // 禁用编辑
                store: DebtEleStore(json_debt_zgyjly),
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                name: 'mhcx',
                itemId: 'mhcx',
                width: 300,
                labelWidth: 60,
                emptyText: '请输入项目编码/项目名称......',
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
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}