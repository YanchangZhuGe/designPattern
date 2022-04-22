/**
 * js：预算编制调整录入
 * Created by djl on 2019/6/20.
 */
/**
 * 默认数据：工具栏
 */
var is_xz = false;

$.extend(ysbztz_json_common[wf_id][node_type], {
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
                    bg_type = records[0].get("BG_TYPE_ID");
                    button_name = 'VIEW';
                    is_status = '1';
                    var ad_code = records[0].get("AD_CODE");
                    var ag_code = records[0].get("AG_CODE");
                    //获取单位的统一社会信用代码
                    $.post("/getAgtyshcode.action", {
                        AD_CODE:ad_code,
                        AG_CODE:ag_code
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //统一社会信用代码
                        USCCODE = data.data[0].TYSHXYDM;
                        initWin_ysbztzlrWindow();
                        loadInfo();
                        //设置所有信息只读
                        setJbxxReadOnly(true);
                        setSzysReadOnly(true);
                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '新增',
                name: 'INPUT',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    if (!AG_CODE || AG_CODE == '') {
                        Ext.Msg.alert('提示', "请选择单位");
                        return;
                    }
                    //获取左侧树及单位
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_ID = treeArray[1].getSelection()[0].get('id');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    bg_type = "";
                    BILL_ID = "";
                    button_name = 'INPUT';
                    window_ysbztz_xmxx.show();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATES',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    }else{
                        BILL_ID = records[0].get("BILL_ID");
                        XM_ID = records[0].get("XM_ID");
                        AG_NAME = records[0].get("AG_NAME");
                        bg_type = records[0].get("BG_TYPE_ID");
                        button_name = 'UPDATES';
                        initWin_ysbztzlrWindow();
                        loadInfo();
                        setJbxxReadOnly(true);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            deleteTzInfo();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否送审？', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            next();
                        }
                    });
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
                    bg_type = records[0].get("BG_TYPE_ID");
                    button_name = 'VIEW';
                    is_status = '1';
                    initWin_ysbztzlrWindow();
                    loadInfo();
                    //设置所有信息只读
                    setJbxxReadOnly(true);
                    setSzysReadOnly(true);
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return false;
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
                    //设置所有信息只读
                    setJbxxReadOnly(true);
                    setSzysReadOnly(true);
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATES',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    } else {
                        BILL_ID = records[0].get("BILL_ID");
                        XM_ID = records[0].get("XM_ID");
                        bg_type = records[0].get("BG_TYPE_ID");
                        button_name = 'UPDATES';
                        initWin_ysbztzlrWindow();
                        loadInfo();
                        setJbxxReadOnly(true);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            deleteTzInfo();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否送审？', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            next();
                        }
                    });
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
                    bg_type = records[0].get("BG_TYPE_ID");
                    button_name = "VIEW";
                    is_status = '1';
                    initWin_ysbztzlrWindow();
                    loadInfo();
                    //设置所有信息只读
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
 * 刷新收支预算Form信息
 */
function initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("xmsyGrid").getStore();
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZTR_AMT"]')[0].setValue(xmsyStore.sum('TOTAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZCB_AMT"]')[0].setValue(xmsyStore.sum('YSCB_HJ_AMT'));
}
/**
 * 删除信息
 */
function deleteTzInfo() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var bgInfoArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.BILL_ID = record.get("BILL_ID");
        bgInfoArray.push(array);
    });
    //向后台传递变更数据信息
    $.post('/delXmtzInfo.action', {
        bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        } else {
            Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        }
    }, 'json');
}
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
        },
        {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "项目单位",
            "fontSize": "15px",
            "width": 250
        },
        {
            "dataIndex": "XM_CODE",
            "type": "string",
            "width": 250,
            "text": "项目编码",
            "hidden": true
        },
        {
            "dataIndex": "XM_NAME",
            "width": 250,
            "type": "string",
            "text": "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
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
            "dataIndex": "BG_TYPE",
            "width": 150,
            "type": "string",
            "text": "调整类型"
        },
        {
            "dataIndex": "BG_TYPE_ID",
            "width": 150,
            "type": "string",
            "hidden":true,
            "text": "调整类型"
        },
        {
            "dataIndex": "BG_DATE",
            "width": 150,
            "type": "string",
            "text": "调整日期"
        },
        {
            "dataIndex": "BG_REASON",
            "width": 150,
            "type": "string",
            "text": "调整原因"
        },
        {
            "dataIndex": "BG_IMPORT",
            "width": 150,
            "type": "string",
            "text": "调整要点"
        },
        {
            "dataIndex": "CREATE_USER",
            "width": 100,
            "type": "string",
            "text": "调整人"
        },
        {
            "dataIndex": "LX_YEAR",
            "width": 100,
            "type": "string",
            "text": "立项年度"
        },
        {
            "dataIndex": "JSXZ_NAME",
            "width": 150,
            "type": "string",
            "text": "建设性质"
        },
        {
            "dataIndex": "XMXZ_NAME",
            "width": 150,
            "type": "string",
            "text": "项目性质"
        },
        {
            "dataIndex": "XMLX_NAME",
            "type": "string",
            "text": "项目类型",
            "width": 130
        },
        {
            "dataIndex": "BUILD_STATUS_NAME",
            "type": "string",
            "text": "建设状态",
            "width": 130
        },
        {
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
                store: DebtEleStore(json_debt_zt1),
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
                //设置基本信息只读
                setJbxxReadOnly(true);
                setSzysReadOnly(true);
            }
        }
    });
}
/**
 * 创建新增合同变更窗体
 * @type {{window: null, show: window_xmbg_xmxx.show}}
 */
var window_ysbztz_xmxx = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_ysbztz_xmxx();
        }
        this.window.show();
    }
};
/**
 * 初始化项目信息弹出窗口
 */
function initWindow_ysbztz_xmxx() {
    return Ext.create('Ext.window.Window', {
        title: '项目信息', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_ysbztz_xmxx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_ysbztz_xmxx_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        return;
                    }
                    //关闭当前窗口，打开合同变更录入窗口
                    XM_ID = records[0].get("XM_ID");

                    //获取单位的统一社会信用代码
                    $.post("/getAgtyshcode.action", {
                        AG_ID:AG_ID
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        initWin_ysbztzlrWindow();
                        //统一社会信用代码
                        USCCODE = data.data[0].TYSHXYDM;
                        var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];//20210303liyue建设单位统一信用代码
                        jbqkForm.getForm().findField('JSDW_TYSHXY').setValue(USCCODE);
                        jbqkForm.getForm().findField('YYDW_TYSHXY').setValue(USCCODE);
                        loadInfo();
                        //设置所有信息只读
                        setJbxxReadOnly(true);
                    }, "json");
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
                window_ysbztz_xmxx.window = null;
            }
        }
    });
}
/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_ysbztz_xmxx_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            "dataIndex": "XM_ID",
            "type": "string",
            "text": "项目ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "单位名称",
            "fontSize": "15px",
            "width": 250,
        }, {
            "dataIndex": "XM_CODE",
            "type": "string",
            "text": "项目编码",
            "fontSize": "15px",
            "width": 320
        }, {
            "dataIndex": "XM_NAME",
            "type": "string",
            "text": "项目名称",
            "fontSize": "15px",
            "width": 250,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        }, {
            "dataIndex": "LX_YEAR",
            "type": "string",
            "text": "立项年度",
            "fontSize": "15px",
            "width": 100
        }, {
            "dataIndex": "JSXZ_NAME",
            "type": "string",
            "text": "建设性质",
            "fontSize": "15px",
            "width": 100
        }, {
            "dataIndex": "XMXZ_NAME",
            "type": "string",
            "text": "项目性质",
            "fontSize": "15px",
            "width": 200
        }, {
            "dataIndex": "XMLX_NAME",
            "type": "string",
            "text": "项目类型",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "BUILD_STATUS_NAME",
            "type": "string",
            "text": "建设状态",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "XMZGS_AMT",
            "type": "float",
            "text": "项目总概算金额",
            "fontSize": "15px",
            "width": 150
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'grid_ysbztz_xmxx',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        selModel: {
            mode: "SINGLE"
        },
        border: false,
        height: '100%',
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE
        },
        dataUrl: 'getYsbztzXMInfo.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
    //将form添加到表格中
    var searchTool = initWindow_ysbztz_xmxx_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}

/**
 * 初始化录入信息弹出框搜索区域
 */
function initWindow_ysbztz_xmxx_grid_searchTool() {
    //初始化查询控件
    var items = [];
    items.push(
        {
            xtype: 'treecombobox',
            fieldLabel: '项目性质',
            itemId: 'LR_XMXZ_SEARCH',
            displayField: 'name',
            valueField: 'code',
            width: 190,
            labelWidth: 60,
            rootVisible: true,
            lines: false,
            selectModel: 'all',
            store: DebtEleTreeStoreDB("DEBT_ZJYT")
        },
        {
            xtype: 'treecombobox',
            fieldLabel: '项目类型',
            itemId: 'LR_XMLX_SEARCH',
            displayField: 'name',
            valueField: 'code',
            width: 190,
            labelWidth: 60,
            rootVisible: true,
            lines: false,
            selectModel: 'all',
            store: DebtEleTreeStoreDB("DEBT_ZWXMLX")
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: "LR_XM_SEARCH",
            width: 360,
            labelWidth: 60,
            emptyText: '请输入项目单位/项目编码/项目名称/项目内容',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var form = self.up('form');
                        if (form.isValid()) {
                            callBackReload(form);
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
                    }
                }
            }
        }
    );
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid');
    var search_form = searchTool.create({
        items: items, border: true,
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
            var XMXZ_ID = Ext.ComponentQuery.query('treecombobox#LR_XMXZ_SEARCH')[0].getValue();
            var XMLX_ID = Ext.ComponentQuery.query('treecombobox#LR_XMLX_SEARCH')[0].getValue();
            var mhcx = Ext.ComponentQuery.query('textfield#LR_XM_SEARCH')[0].getValue();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["XMXZ_ID"] = XMXZ_ID;
            store.getProxy().extraParams["XMLX_ID"] = XMLX_ID;
            store.getProxy().extraParams["mhcx"] = mhcx;
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
        padding: '0 10 0 0',
        layout: {
            type: 'hbox',
            align: 'center',
            pack: 'start'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    if (form.isValid()) {
                        callBackReload(form);
                    } else {
                        Ext.Msg.alert("提示", "查询区域未通过验证！");
                    }
                }
            },
            '->', {
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
    function callBackReload(form) {
        search_form.callback(form);
    }

    return search_form;
}
function zqxxtbTab(index) {
    var zqxxtbTab = Ext.ComponentQuery.query('[name="EditorPanel"]')[0];
    zqxxtbTab.items.get(index-1).show();
}
