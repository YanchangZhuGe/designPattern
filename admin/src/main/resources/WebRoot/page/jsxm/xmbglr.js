/**
 * js：合同变更录入
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
var is_xz = false;
$.extend(xmbg_json_common[wf_id][node_type], {
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
                    xmlx_id=records[0].get("XMLX_ID");//给项目类型赋值
                    initWin_xmbglrWindow();
                    loadInfo();
                    //设置所有信息只读
                    setAllReadOnly();
                }
            },
            {
                xtype: 'button',
                text: '新增',
                name: 'INPUT',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    if (!AG_ID || AG_ID == '') {
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
                    window_xmbg_xmxx.show();
                    //获取统一社会信用代码
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATE',
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
                    }else{
                        BILL_ID = records[0].get("BILL_ID");
                        XM_ID = records[0].get("XM_ID");
                        AG_NAME = records[0].get("AG_NAME");
                        bg_type = records[0].get("BG_TYPE_ID");
                        xmlx_id=records[0].get("XMLX_ID");//给项目类型赋值
                        button_name = 'UPDATE';
                        initWin_xmbglrWindow();
                        loadInfo();
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
                            deleteBgInfo();
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
                    xmlx_id=records[0].get("XMLX_ID");//给项目类型赋值
                    initWin_xmbglrWindow();
                    loadInfo();
                    //设置所有信息只读
                    setAllReadOnly();
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
                    xmlx_id=records[0].get("XMLX_ID");//给项目类型赋值
                    initWin_xmbglrWindow();
                    loadInfo();
                    //设置所有信息只读
                    setAllReadOnly();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATE',
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
                        button_name = 'UPDATE';
                        initWin_xmbglrWindow();
                        loadInfo();
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
                            deleteBgInfo();
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
                    xmlx_id=records[0].get("XMLX_ID");//给项目类型赋值
                    initWin_xmbglrWindow();
                    loadInfo();
                    //设置所有信息只读
                    setAllReadOnly();
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
 * 删除债务合同信息
 */
function deleteBgInfo() {
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
    $.post('/delXMBgInfo.action', {
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
            "text": "变更类型"
        },
        {
            "dataIndex": "BG_TYPE_ID",
            "width": 150,
            "type": "string",
            "hidden":true,
            "text": "变更类型"
        },
        {
            "dataIndex": "BG_DATE",
            "width": 150,
            "type": "string",
            "text": "变更日期"
        },
        {
            "dataIndex": "BG_REASON",
            "width": 150,
            "type": "string",
            "text": "变更原因"
        },
        {
            "dataIndex": "BG_IMPORT",
            "width": 150,
            "type": "string",
            "text": "变更要点"
        },
        {
            "dataIndex": "CREATE_USER",
            "width": 100,
            "type": "string",
            "text": "变更人"
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
            "text": "建设性质",
            hidden:true
        },
        {
            "dataIndex": "XMXZ_NAME",
            "width": 150,
            "type": "string",
            hidden:true,
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
            "text": "项目总概算金额(万元) ",
            "width": 260,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            // columnAutoWidth: false
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
                        toolbar.add(xmbg_json_common[wf_id][node_type].items[WF_STATUS]);
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
        dataUrl: 'getxmbgList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                BILL_ID = record.get("BILL_ID");
                XM_ID = record.get("XM_ID");
                bg_type = record.get("BG_TYPE_ID");
                button_name = 'VIEW';
                xmlx_id=record.get("XMLX_ID")//给项目类型赋值
                initWin_xmbglrWindow();
                loadInfo();
                //设置所有信息只读
                setAllReadOnly();
            }
        }
    });
}
/**
 * 创建新增合同变更窗体
 * @type {{window: null, show: window_xmbg_xmxx.show}}
 */
var window_xmbg_xmxx = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_xmbg_xmxx();
        }
        this.window.show();
    }
};
/**
 * 初始化项目信息弹出窗口
 */
function initWindow_xmbg_xmxx() {
    return Ext.create('Ext.window.Window', {
        title: '项目信息', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_xmbg_xmxx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_xmbg_xmxx_grid()],
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
                    xmlx_id=records[0].get("XMLX_ID")//给项目类型赋值
                    $.post("/getAgtyshcode.action", {
                        AG_ID:AG_ID
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //统一社会信用代码
                        USCCODE = data.data[0].TYSHXYDM;
                        initWin_xmbglrWindow();//20210303liyue建设单位统一信用代码
                        var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
                        jbqkForm.getForm().findField('JSDW_TYSHXY').setValue(USCCODE);
                        jbqkForm.getForm().findField('YYDW_TYSHXY').setValue(USCCODE);
                        loadInfo();
                        //设置所有信息只读
                        setAllReadOnly();
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
                window_xmbg_xmxx.window = null;
            }
        }
    });
}
/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_xmbg_xmxx_grid() {
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
            "width": 100,
            hidden:true
        }, {
            "dataIndex": "XMXZ_NAME",
            "type": "string",
            "text": "项目性质",
            hidden:true,
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
            "text": "项目总概算金额(万元)",
            "fontSize": "15px",
            "width": 150
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'grid_xmbg_xmxx',
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
        dataUrl: 'getJSXMBGInfoGrid.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
    //将form添加到表格中
    var searchTool = initWindow_xmbg_xmxx_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}

/**
 * 初始化变更录入债务信息弹出框搜索区域
 */
function initWindow_xmbg_xmxx_grid_searchTool() {
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
            hidden:true,
            rootVisible: true,
            lines: false,
            selectModel: 'all',
            store:DebtEleTreeStoreDB("DEBT_ZJYT")
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

/**
 * 切换页签
 * @param index
 */
function zqxxtbTab(index) {
    var zqxxtbTab = Ext.ComponentQuery.query('panel[itemId="xmxxTabPanel"]')[0];
    zqxxtbTab.items.get(index-1).show();
}


//去除空格方法
function Trim(m){
    while((m.length>0)&&(m.charAt(0)==' '))
        m  =  m.substring(1, m.length);
    while((m.length>0)&&(m.charAt(m.length-1)==' '))
        m = m.substring(0, m.length-1);
    return m;
}
/**
 * 比较实际开工日期与当前日期
 * @param form
 * @return {boolean}
 */
function compareActualStartDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    START_DATE_ACTUAL = Ext.util.Format.date(START_DATE_ACTUAL, 'Y-m-d');
    if (START_DATE_ACTUAL && START_DATE_ACTUAL > nowDate) {
        return false;
    }
    return true;
}
function submitInfo(workflow,btn) {
    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    //投资计划页签
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    //收支平衡页签
    // var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    var TZJH_XMZGS_AMT=tzjhForm.getForm().findField("TZJH_XMZGS_AMT").getValue();
    if(IS_XMBCXX == '1'){
        if (!bcxxForm.isValid()) {
            Ext.toast({
                html: "补充信息：请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
        // guodg 2021091316 项目补充信息添加校验
        var bcxx15Field = bcxxForm.getForm().findField('BCXX15');
        if (isNull(bcxx15Field.getValue())){
            Ext.Msg.alert('提示', '项目实施方案中需要包含事前绩效评估内容，请确认!');
            setActiveTabPanelByTabTitle('补充信息');
            bcxx15Field.toggleInvalidCls(true);
            return false;
        }
    }
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    var form = Ext.ComponentQuery.query('form[name="bgxxForm"]')[0];
    var bg_date = Ext.ComponentQuery.query('datefield[name="BG_DATE"]')[0].value;
    var bg_reason = Ext.ComponentQuery.query('textarea[name="BG_REASON"]')[0].value;
    var bg_import = Ext.ComponentQuery.query('textarea[name="BG_IMPORT"]')[0].value;
    var bg_type = Ext.ComponentQuery.query('combobox[name="BG_TYPE"]')[0].value;
    if (bg_type == null || bg_type == '' || bg_type == 'undefined'||''==Trim(bg_type)) {
        Ext.Msg.alert('提示', "变更类型不能为空");
        return false;
    }
    if (bg_date == null || bg_date == '' || bg_date == 'undefined'||''==Trim(bg_date)) {
        Ext.Msg.alert('提示', "变更日期不能为空");
        return false;
    }
    if (bg_reason == null || bg_reason == '' || bg_reason == 'undefined'||''==Trim(bg_reason)) {
        Ext.Msg.alert('提示', "变更原因不能为空");
        return false;
    }
    if (bg_import == null || bg_import == '' || bg_import == 'undefined'||''==Trim(bg_import)) {
        Ext.Msg.alert('提示', "变更要点不能为空");
        return false;
    }

    //获取投资计划页签表格
    var tzjhGrid = [];
    //获取收支平衡数据
    var gridData = [];
    var tzjhnd = new Map();
    if(bg_type=='2' || bg_type=='3' || bg_type=='6'){
        var FGW_XMK_CODE = jbqkForm.getForm().findField('FGW_XMK_CODE').getValue();
        if(FGW_XMK_CODE != '无' && !FGW_XMK_CODE.match("^[a-zA-Z0-9_-]*$")){
            Ext.Msg.alert('提示', "发改委审批监管代码仅可录“无”或字母数字编码");
            return false;
        }
        /*if (!comparePlanDate(jbqkForm)) {
            message_error = '计划开工日期应该早于计划竣工日期';
            if (message_error != null && message_error != '') {
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }*/
        if (!compareActualDate(jbqkForm)) {
            message_error = '开工日期应该早于竣工日期';
            if (message_error != null && message_error != '') {
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
        /*if (!compareActualStartDate(jbqkForm)) {
            message_error = '开工日期不应晚于当前时间';
            if (message_error != null && message_error != '') {
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            }
        }*/
        if (!jbqkForm.isValid()) {
            Ext.toast({
                html: "基本情况：请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
    }else if(bg_type=='1'){
        if(DSYGrid.getGrid("tzjhGrid").getStore().getCount() <= 0) {
            message_error = "投资计划：必须录入投资计划！";
            Ext.Msg.alert('提示', message_error);
            return false;
        }else{
            var message_error = null;
            DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
                if (record.get('ND') == null || record.get('ND') == '' || record.get('ND') == 'undefined') {
                    message_error = "请填写投资计划列表中“年度”列";
                    return false;
                }
                if (typeof(tzjhnd.get(record.get('ND'))) != 'undefined') {
                    message_error = "投资计划列表中“年度”不能相同";
                    return false;
                }else {
                    tzjhnd.put(record.get('ND'), '');
                }
                if(record.get('RZZJ_ACTUAL_AMT') < record.get('RZZJ_XJ')){
                    message_error = "投资计划："+record.get('ND')+" 融资资金下实际到位金额不能小于小计金额！";
                    return false ;
                }
                if(record.get('ZTZ_PLAN_AMT') <= 0 && record.get('ZTZ_ACTUAL_AMT') <= 0 ){
                    message_error = record.get('ND')+"年投资计划年度总投资不能为0！";
                    return false ;
                }
                /*if(record.get('ND') < nowDate.substr(0,4) && record.get('ZTZ_ACTUAL_AMT') <= 0 ){
                    message_error = "投资计划："+nowDate.substr(0,4)+"年度之前的投资计划年度总投资下的实际到位资金必须大于0！";
                    return false ;
                }*/
                tzjhGrid.push(record.getData());
            });
            if (message_error != null && message_error != '') {
                Ext.Msg.alert('提示', message_error);
                return false;
            }
            var xmzgs_amt= tzjhForm.down('numberFieldFormat[name="TZJH_XMZGS_AMT"]').getValue();
            var zbj_amt= tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();
            var zbj_zq_amt= tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').getValue();
            var zbj_ys_amt= tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').getValue();
            if (zbj_amt - xmzgs_amt > 0.00001) {
                Ext.Msg.alert('提示', '投资计划：项目资本金总额不得大于项目总概算!');
                return false;
            }
            if ((zbj_zq_amt+zbj_ys_amt) - zbj_amt > 0.00001) {
                Ext.Msg.alert('提示', '投资计划：其中财政预算安排资本金与专项债券安排资本金之和不得大于项目资本金总额!');
                return false;
            }
        }
    }else if(bg_type=='4'){//变更计划为收支平衡调整
        // 获取收支平衡页签表格
        // var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        // var xmsyGrid = xmsyForm.down('grid');
        // for (var i = 0; i < xmsyGrid.getStore().getCount(); i++) {
        //     var record = xmsyGrid.getStore().getAt(i);
        //     gridData.push(record.data);
        // }
        // //----------------------较验
        // // 收支平衡校验
        // if (!xmsyForm.isValid()) {
        //     Ext.toast({
        //         html: "收支预算：请检查是否填写正确！",
        //         closable: false,
        //         align: 't',
        //         slideInDuration: 400,
        //         minWidth: 400,
        //         listeners: {
        //             "show": function () {
        //                 editTab(5);
        //             }
        //         }
        //     });
        //     return false;
        // }
        //
        // var message_error = null;
        // var xmztr_amt = xmsyForm.down('numberFieldFormat[name="XMZTR_AMT"]').getValue(); // 项目预计总收入
        // var xmzcb_amt = xmsyForm.down('numberFieldFormat[name="XMZCB_AMT"]').getValue(); // 项目预算总成本
        // var zfxjjkm_id = xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').getValue();    // 项目对应的政府性基金科目
        // var xm_used_date = xmsyForm.down('datefield[name="XM_USED_DATE"]').getValue();    // 项目投入使用日期
        // var xm_used_limit = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();  // 项目运营期限
        // if(zfxjjkm_id == null || zfxjjkm_id == "" || zfxjjkm_id == undefined){
        //     message_error = "收支预算：项目对应的政府性基金科目不可为空！";
        // }
        // // 如果项目类型非"土地储备" 则校验通用编制计划
        // if (xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) {
        //     var lx_year = Ext.ComponentQuery.query('combobox[name="LX_YEAR"]')[0].getValue();
        //     var newValue = format(xm_used_date, 'yyyy');
        //     if (newValue < lx_year) {
        //         xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue('');
        //         message_error = "收支预算：项目投入使用日期不可小于立项年度！";
        //         Ext.Msg.alert('提示', message_error);
        //         editTab(5);
        //         return false;
        //     }
        // }
        // if (xmztr_amt <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
        //     message_error = "收支预算：项目对应的政府性基金科目不为空时，必须有收入！";
        //     Ext.Msg.alert('提示', message_error);
        //     editTab(5);
        //     return false;
        // }
        //
        // if (xmztr_amt > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
        //     message_error = "收支预算：项目收入合计不为0时，项目对应的政府性基金科目不可为空！";
        //     Ext.Msg.alert('提示', message_error);
        //     editTab(5);
        //     return false;
        // }
        // if (xmztr_amt <= 0 && ((xm_used_date != null && xm_used_date != ""&& xm_used_date != undefined) || (xm_used_limit != null && xm_used_limit != "" && xm_used_limit != undefined))) {
        //     message_error = "收支预算：开始日期或预算年限不为空时，必须有收入！";
        //     Ext.Msg.alert('提示', message_error);
        //     editTab(5);
        //     return false;
        // }
        // if (xmztr_amt > 0 && ( ((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined)  )) {
        //     message_error = "收支预算：项目收入合计不为0时，开始日期和预算期限不能为空！";
        //     Ext.Msg.alert('提示', message_error);
        //     editTab(5);
        //     return false;
        // }
        //获取收支平衡页签表单
        // var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        var szysGrid = xmsyForm.down('grid');
        var xmsyGrid = [];

        var is_negative = false; // 明细中是否存在负数
        var yyqx_count = 4; // 默认显示5年编制计划列
        if (!!xm_used_limit) {
            yyqx_count = xm_used_limit;
        }
        if(xm_used_limit > 30){
            yyqx_count = 30;
        }
        if(is_tdcb){
            if ((!!xmztr_amt) && xmztr_amt <=0) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目预计总收入不能为零');
                editTab(5);
                return false;
            }
            if (!zfxjjkm_id) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目对应的政府性基金科目不能为空');
                editTab(5);
                return false;
            }
            // “评估土地使用权出让收入”之和大于等于“土地储备项目资金支出”之和，否则提示：土储项目应当实现总体收支平衡 01 >= 03
            // 当年“土地储备项目资金”必须大于等于“土地储备项目资金支出”，否则提示：土储项目应当实现年度收支平衡 02 >= 03
            var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]); // 评估土地使用权出让收入 01
            var record_02 = szysGrid.getStore().getAt(gs_relation_guid["02"]); // 土地储备项目资金 02
            var record_03 = szysGrid.getStore().getAt(gs_relation_guid["03"]); // 土地储备项目资金支出 03

            var pgsr_sum_amt = 0.00; // 评估土地使用权出让收入总年度金额
            var zjzc_sum_amt = 0.00; // 土地储备项目资金支出总年度金额

            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;

                if (record_02.get(SR) < record_03.get(ZC)) {
                    Ext.Msg.alert('提示', '土储项目应当实现年度收支平衡');
                    editTab(5);
                    return false;
                }
                pgsr_sum_amt += record_01.get(SR);
                zjzc_sum_amt += record_03.get(ZC);
            }
            if (pgsr_sum_amt < zjzc_sum_amt) {
                Ext.Msg.alert('提示', '土储项目应当实现总体收支平衡');
                editTab(5);
                return false;
            }
        }else{
            // 对还本总金额进行校验
            var record_06 = szysGrid.getStore().getAt(gs_relation_guid["06"]);// 获取专项债券金额
            var record_0203 = szysGrid.getStore().getAt(gs_relation_guid["0202"]);// 获取地方政府专项债券金额
            var record_07 = szysGrid.getStore().getAt(gs_relation_guid["07"]);// 获取市场化融资金额
            var record_0204 = szysGrid.getStore().getAt(gs_relation_guid["0203"]);// 获取项目单位市场化融资金额
            var record_020201 = szysGrid.getStore().getAt(gs_relation_guid["020201"]);// 获取其中用于资本金
            var record_03=szysGrid.getStore().getAt(gs_relation_guid["03"]);
            var record_0301=szysGrid.getStore().getAt(gs_relation_guid["0301"]);
            var record_0302=szysGrid.getStore().getAt(gs_relation_guid["0302"]);
            var record_02 = szysGrid.getStore().getAt(gs_relation_guid["02"]);//项目建设资金来源
            var record_04 = szysGrid.getStore().getAt(gs_relation_guid["04"]);// 四、项目运营支出
            var zxzqhb_amt = 0.00; // 专项债券还本总金额
            var zxzq_amt = 0.00;   // 专项债券总金额
            var schrzhb_amt = 0.00;// 市场化融资还本总金额
            var schrz_amt = 0.00;  // 市场化融资总金额
            var jszjly_amt=0.00;//建设资金来源 总金额
            var xmyyzc_zmt=0.00;//项目运营支出总金额
            var xmjszc_amt=0.00;//项目建设支出总金额
            var xmyysr_amt =0.00//项目运营支出
            // 循环计算所有年度总收入总支出合计值
            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;
                jszjly_amt += parseFloat(record_02.get(SR) == "" ? 0 : record_02.get(SR));//建设资金来源 总金额
                xmyyzc_zmt+=parseFloat(record_04.get(ZC) == "" ? 0 : record_04.get(ZC));//项目运营支出总金额
                xmjszc_amt+=parseFloat(record_03.get(ZC) == "" ? 0 : record_03.get(ZC));//项目运营支出总金额
                zxzqhb_amt += parseFloat(record_06.get(ZC)==""?0:record_06.get(ZC));
                zxzq_amt += parseFloat(record_0203.get(SR)==""?0:record_0203.get(SR));
                schrzhb_amt += parseFloat(record_07.get(ZC)==""?0:record_07.get(ZC));
                schrz_amt += parseFloat(record_0204.get(SR)==""?0:record_0204.get(SR));
                var dfzxzq_amt = parseFloat(record_0203.get(SR)==""?0:record_0203.get(SR));//2地方政府专项债券金额
                var qzsr = parseFloat(record_020201.get(SR)==""?0:record_020201.get(SR));//获取其中用于资本金
                var jsxmzc = parseFloat(record_03.get(ZC)==""?0:record_03.get(ZC));//建设项目支出03
                var cwzyzx = parseFloat(record_0301.get(ZC)==""?0:record_0301.get(ZC));//财务专用专项债券付息
                var cwzysc = parseFloat(record_0302.get(ZC)==""?0:record_0302.get(ZC));//市场化融资付息
                xmyysr_amt += parseFloat(record_01.get(SR) == "" ? 0 : record_01.get(SR));
                if(parseFloat(qzsr).toFixed(6)-parseFloat(dfzxzq_amt).toFixed(6)> 0.000001){//20210420liyue添加用于资本金与地方专项校验
                    Ext.Msg.alert('提示', '其中：用于资本金不能大于地方政府专项债券金额！');
                    return false;
                }
                // if(parseFloat(cwzyzx+cwzysc).toFixed(6)-parseFloat(jsxmzc).toFixed(6)> 0.000001){//20210420liyue添加建设项目支出与其中金额校验
                //     Ext.Msg.alert('提示', '其中：专项债券与市场化融资付息和不能大于项目建设支出！');
                //     return false;
                // }
            }
            if(Math.abs((parseFloat(zxzqhb_amt).toFixed(6)-parseFloat(zxzq_amt).toFixed(6)).toFixed(6)) > 0.000001){
                Ext.Msg.alert('提示', '专项债券还本总金额应等于地方政府专项债券总金额！');
                return false;
            }
            if(Math.abs((parseFloat(schrzhb_amt).toFixed(6)-parseFloat(schrz_amt).toFixed(6)).toFixed(6)) > 0.000001){
                Ext.Msg.alert('提示','市场化融资还本总金额应等于项目单位市场化融资总金额！');
                return false;
            }

            //辽宁特性
            if (parseFloat(zxzqhb_amt).toFixed(6)-parseFloat((jszjly_amt+xmyysr_amt) -(xmyyzc_zmt+xmjszc_amt)).toFixed(6)> 0.000001&&sysAdcode=='21') {//20210420liyue添加建设项目支出与其中金额校验
                Ext.Msg.alert('提示', '（建设资金来源 + 项目运营预期收入） - 项目运营支出 - 项目建设支出小于专项债券还本！');
                return false;
            }
            var xmsyForm = Ext.ComponentQuery.query(formName)[0];
            var store = xmsyForm.down('grid').getStore();
            var bxfg = store.getAt(gs_relation_guid["09"]);
            var XMXZ_ID = jbqkForm.getForm().findField('XMXZ_ID').getValue();
            /*if(XMXZ_ID == '010102') {
                // BXFGBS_XX不为0与不为null则较验
                if (BXFGBS_XX != '0' && BXFGBS_XX != 'null' && BXFGBS_XX != '') {
                    if (bxfg.data.SRAMT_Y0 < parseFloat(BXFGBS_XX)) {
                        Ext.Msg.alert('提示', '本息覆盖倍数必须大于或等于' + BXFGBS_XX + '倍！');
                        return false;
                    }
                }
            }
            if(BXFGBS_SX != '0' && BXFGBS_SX != 'null' && BXFGBS_SX != ''){
                if(bxfg.data.SRAMT_Y0 > parseFloat(BXFGBS_SX)){
                    Ext.Msg.alert('提示','本息覆盖倍数过大，请检查数据！');
                    return false;
                }
            }
            if(checkBxfgFromImport()){//本息覆盖倍数校验
                return false;
            }*/
            /*if (!(xm_used_date == null || (xm_used_date == "") || xm_used_date == undefined)){
                for (var n = 0; n <= yyqx_count; n++) {
                    var SR = "SRAMT_Y" + n;
                    var year = Number(xm_used_date.getFullYear()) + Number(n);
                    var sr_amt = (parseFloat(record_0101.get(SR).toFixed(6))) + (parseFloat(record_0102.get(SR).toFixed(6)));
                    if(parseFloat(sr_amt) > parseFloat(record_01.get(SR))){
                        Ext.Msg.alert('提示',''+year+'年，其中：财政运营补贴收入与其中：土地出让收入相加之和<br/>超出项目预期收入（预期资产评估价值）！');
                        return false;
                    }
                }
            }*/
        }
        // szysGrid.getStore().each(function (record) {
        //     xmsyGrid.push(record.getData());
        // });

    }
    var url;
    var params;

    if(IS_XMBCXX == '1'){
        if (button_name == 'INPUT') {
            url = 'saveXMBgxx.action';
            params = {
                BG_TYPE:bg_type,
                wf_id: wf_id,
                node_code: node_code,
                node_type:node_type,
                XM_ID: XM_ID,
                is_wzxt: is_wzxt,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: AG_ID,
                AG_NAME: AG_NAME,
                button_name: button_name,
                IS_XMBCXX: IS_XMBCXX,
                jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
                bcxxForm: encode64('[' + Ext.util.JSON.encode(bcxxForm.getValues())+ ']'),
                tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues())+ ']'),
                tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
                BILL_ID: guid,
                isOld_szysGrid:isOld_szysGrid,
                // xmsyGrid: encode64(Ext.util.JSON.encode(gridData)),
                // xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']')
            };
        } else if (button_name == 'UPDATE') {
            url = 'updateXMBgxx.action';
            params = {
                BG_TYPE:bg_type,
                wf_id: wf_id,
                node_code: node_code,
                XM_ID: XM_ID,
                is_wzxt: is_wzxt,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: AG_ID,
                AG_NAME: AG_NAME,
                button_name: button_name,
                IS_XMBCXX: IS_XMBCXX,
                jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
                bcxxForm: encode64('[' + Ext.util.JSON.encode(bcxxForm.getValues())+ ']'),
                tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues())+ ']'),
                tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
                // xmsyGrid: encode64(Ext.util.JSON.encode(gridData)),
                // xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
                BILL_ID: BILL_ID,
                node_type:node_type
            };
        }
    }else{
        if (button_name == 'INPUT') {
            url = 'saveXMBgxx.action';
            params = {
                BG_TYPE:bg_type,
                wf_id: wf_id,
                node_code: node_code,
                XM_ID: XM_ID,
                is_wzxt: is_wzxt,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: AG_ID,
                AG_NAME: AG_NAME,
                button_name: button_name,
                IS_XMBCXX: IS_XMBCXX,
                jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
                tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues())+ ']'),
                tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
                // xmsyGrid: encode64(Ext.util.JSON.encode(gridData)),
                // xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
                BILL_ID: guid,
                node_type:node_type
            };
        } else if (button_name == 'UPDATE') {
            url = 'updateXMBgxx.action';
            params = {
                BG_TYPE:bg_type,
                wf_id: wf_id,
                node_code: node_code,
                XM_ID: XM_ID,
                is_wzxt: is_wzxt,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: AG_ID,
                AG_NAME: AG_NAME,
                button_name: button_name,
                IS_XMBCXX: IS_XMBCXX,
                jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
                tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues())+ ']'),
                tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
                // xmsyGrid: encode64(Ext.util.JSON.encode(gridData)),
                // xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
                BILL_ID: BILL_ID,
                node_type:node_type
            };
        }
    }

    //避免网络或操作导致数据错误，按钮置为不可点击
    if(TZJH_XMZGS_AMT>2000000){
        Ext.onReady(function () {
            Ext.MessageBox.show({
                title: "提示",
                msg: "投资计划页签中项目总概算金额超过200亿！",
                fn: function (id, msg) {
                    if(id=="ok"){
                        saveForm();
                    }else {
                        btn.setDisabled(false);
                    }
                },
                buttons: Ext.Msg.OKCANCEL,
            });
        });
    }else{
        //避免网络或操作导致数据错误，按钮置为不可点击
        saveForm();
    }
    //提交表单方法
    function saveForm() {
        if (form.isValid()) {
            if(btn != null){
                btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
            }
            form.submit({
                url: url,
                params: params,
                waitTitle: '请等待',
                waitMsg: '正在保存中...',
                success: function (form, action) {
                    //增加项目总概算校验
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            Ext.ComponentQuery.query('window[name="xmbglrWin"]')[0].close();
                            reloadGrid();
                        }
                    });
                },
                failure: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存失败!' + action.result.message,
                        width: 200,
                    });
                    btn.setDisabled(false);
                }
            });
        } else {
            Ext.Msg.alert('提示', '请将必填项补充完整！');
        }
    }
}
