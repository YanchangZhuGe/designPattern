/**
 * js：预算编制调整审核
 * Created by djl on 2019/6/20.
 */
/**
 * 默认数据：工具栏
 */
$.extend(ysbztz_json_common[wf_id][node_type], {
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
                text: '项目看板',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作!');
                        return;
                    }
                    BILL_ID = records[0].get("BILL_ID");
                    XM_ID = records[0].get("XM_ID");
                    button_name = 'VIEW';
                    is_status = '1';
                    bg_type = records[0].get("BG_TYPE_ID");
                    initWin_ysbztzlrWindow();
                    loadInfo();
                    setSzysReadOnly(true);
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
                        button_name = btn.text;
                        opinionWindow.open('NEXT', "审核意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'btn_back',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        button_name = btn.text;
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', "退回意见");
                    }
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
                text: '项目看板',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作!');
                        return;
                    }
                    BILL_ID = records[0].get("BILL_ID");
                    XM_ID = records[0].get("XM_ID");
                    button_name = 'VIEW';
                    is_status = '1';
                    bg_type = records[0].get("BG_TYPE_ID");
                    initWin_ysbztzlrWindow();
                    loadInfo();
                    setSzysReadOnly(true);
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
                text: '项目看板',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作!');
                        return;
                    }
                    BILL_ID = records[0].get("BILL_ID");
                    XM_ID = records[0].get("XM_ID");
                    bg_type = records[0].get("BG_TYPE_ID");
                    button_name = 'VIEW';
                    is_status = '1';
                    initWin_ysbztzlrWindow();
                    loadInfo();
                    setJbxxReadOnly(true);
                    setSzysReadOnly(true);
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
                        button_name = btn.text;
                        opinionWindow.open('NEXT', "审核意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'btn_back',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        button_name = btn.text;
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', "退回意见");
                    }
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
                text: '项目看板',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作!');
                        return;
                    }
                    BILL_ID = records[0].get("BILL_ID");
                    XM_ID = records[0].get("XM_ID");
                    button_name = 'VIEW';
                    is_status = '1';
                    bg_type = records[0].get("BG_TYPE_ID");
                    initWin_ysbztzlrWindow();
                    loadInfo();
                    setJbxxReadOnly(true);
                    setSzysReadOnly(true);
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
        ]
    }
});
/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action, title) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn, text) {
                audit_info = text;
                if (btn == "ok") {
                    if (action == 'NEXT') {
                        next();
                    } else if (action == 'BACK') {
                        back("BACK");
                    }
                }
            }
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
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            "dataIndex": "BILL_ID",
            "type": "string",
            "text": "单据ID",
            "fontSize": "15px",
            "hidden": true
        },
        {
            "dataIndex": "XM_ID",
            "type": "string",
            "text": "项目ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "项目单位",
            "fontSize": "15px",
            "width": 250,
        }, {
            "dataIndex": "XM_CODE",
            "type": "string",
            "width": 250,
            "text": "项目编码",
            "hidden": true
        }, {
            "dataIndex": "XM_NAME",
            "width": 250,
            "type": "string",
            "text": "项目名称",
            "renderer": function (data, cell, record) {
                /* var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('XM_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            "dataIndex": "BG_TYPE",
            "width": 150,
            "type": "string",
            "text": "调整类型"
        },
        {
            "dataIndex": "BG_TYPE_ID",
            "width": 150,
            "type": "string",
            "hidden": true,
            "text": "调整类型"
        },
        {
            "dataIndex": "BG_DATE",
            "width": 150,
            "type": "string",
            "text": "调整日期"
        }, {
            "dataIndex": "BG_REASON",
            "width": 150,
            "type": "string",
            "text": "调整原因"
        }, {
            "dataIndex": "BG_IMPORT",
            "width": 150,
            "type": "string",
            "text": "调整要点"
        }, {
            "dataIndex": "CREATE_USER",
            "width": 100,
            "type": "string",
            "text": "调整人"
        }, {
            "dataIndex": "LX_YEAR",
            "width": 100,
            "type": "string",
            "text": "立项年度"
        }, {
            "dataIndex": "JSXZ_NAME",
            "width": 150,
            "type": "string",
            "text": "建设性质"
        }, {
            "dataIndex": "XMXZ_NAME",
            "width": 150,
            "type": "string",
            "text": "项目性质"
        }, {
            "dataIndex": "XMLX_NAME",
            "type": "string",
            "text": "项目类型",
            "width": 130
        }, {
            "dataIndex": "BUILD_STATUS_NAME",
            "type": "string",
            "text": "建设状态",
            "width": 130
        }, {
            "dataIndex": "XMZGS_AMT",
            "type": "float",
            "text": "项目总概算金额",
            "width": 150
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '80%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt2_3),
                width: 110,
                allowBlank: false,
                editable: false,
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
                        toolbar.add(ysbztz_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        getHbfxDataList();
                    }
                }
            }
        ],
        params: {
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE
        },
        dataUrl: 'getYsbztzList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                BILL_ID = record.get("BILL_ID");
                XM_ID = record.get("XM_ID");
                bg_type = record.get("BG_TYPE_ID");
                button_name = 'VIEW';
                is_status = '1';
                initWin_ysbztzlrWindow();
                loadInfo();
                setSzysReadOnly(true);
            }
        }
    });
}