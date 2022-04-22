/**
 * 默认数据：工具栏
 */
$.extend(jxmb_json_common[wf_id][node_type], {
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧表格
        ];
    },
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '填报',
                name: 'add',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    if (!AG_CODE || AG_CODE == '') {
                        Ext.Msg.alert('提示', "请选择单位");
                        return;
                    }
                    //获取左侧树及单位
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    button_status = btn.name;
                    button_name = btn.text;
                    mbYear = Ext.ComponentQuery.query('combobox#JX_YEAR')[0].getValue();
                    window_jxmb_xmxx.show();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
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
                        jxmb_id = records[0].get("MB_ID");
                        xm_id = records[0].get("PRO_ID");
                        button_name = btn.text;
                        button_status = btn.name;
                        var xmlx_id = records[0].get("XMLX_ID");
                        initWin_jxmbWindow(xm_id, xmlx_id);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'delete',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            delJxmbInfo(btn);
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                hidden: false,
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
                            next(btn);
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                hidden: false,
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    dooperation();
                }
            },
            {
                xtype: 'button',
                text: '导出绩效目标表',
                hidden: true,
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {

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
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                name: 'CANCEL',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
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
                                    back('CANCEL');
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
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
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
                        jxmb_id = records[0].get("MB_ID");
                        xm_id = records[0].get("PRO_ID");
                        button_name = btn.text;
                        button_status = btn.name;
                        var xmlx_id = records[0].get("XMLX_ID");
                        initWin_jxmbWindow(xm_id, xmlx_id);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'delete',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            delJxmbInfo(btn);
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
                            next(btn);
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
                    reloadGrid();
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
 * 删除绩效自评信息
 */
function delJxmbInfo(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var jxArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("MB_ID");
        jxArray.push(array);
    });
    //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    btn.setDisabled(true);
    //向后台传递变更数据信息
    $.post('/jxmbtb/delJxmbInfo.action', {
        jxArray: Ext.util.JSON.encode(jxArray)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
            reloadGrid();
        }
        btn.setDisabled(false);
    }, 'json');
}

/**
 * 创建窗体
 * @type {{window: null, show: window_jxmb_xmxx.show}}
 */
var window_jxmb_xmxx = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_jxmb_xmxx();
        }
        this.window.show();
    }
};

/**
 * 初始化项目信息弹出窗口
 */
function initWindow_jxmb_xmxx() {
    return Ext.create('Ext.window.Window', {
        title: '遴选项目', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_xmxx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_xmxx_grid()],
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
                    jxmb_id = GUID.createGUID();
                    xm_id = records[0].get("PRO_ID");
                    var xmlx_id = records[0].get("XMLX_ID");
                    //关闭当前窗口，打开录入窗口
                    btn.up('window').close();
                    initWin_jxmbWindow(xm_id, xmlx_id);
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
                window_jxmb_xmxx.window = null;
            }
        }
    });
}

/**
 * 初始化绩效目标填报录入弹出表格
 */
function initWindow_xmxx_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            "dataIndex": "PRO_ID",
            "type": "string",
            "text": "项目ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "AGENCY_ID",
            "type": "string",
            "text": "单位ID",
            "fontSize": "15px",
            "width": 250,
            hidden: true
        }, {
            "dataIndex": "AGENCY_CODE",
            "type": "string",
            "text": "单位编码",
            "fontSize": "15px",
            "width": 250,
            hidden: true
        }, {
            "dataIndex": "AGENCY_NAME",
            "type": "string",
            "text": "单位名称",
            "fontSize": "15px",
            "width": '14%',
        }, {
            "dataIndex": "PRO_CODE",
            "type": "string",
            "text": "项目编码",
            "fontSize": "15px",
            "width": '10%'
        }, {
            "dataIndex": "PRO_NAME",
            "type": "string",
            "text": "项目名称",
            "fontSize": "15px",
            "width": '14%',
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('PRO_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        }, {
            "dataIndex": "LX_YEAR",
            "type": "string",
            "text": "立项年度",
            "fontSize": "15px",
            "width": '6%'
        }, {
            "dataIndex": "XMLX_ID",
            "type": "string",
            "text": "项目类型ID",
            "fontSize": "15px",
            "width": 130,
            hidden: true
        }, {
            "dataIndex": "XMLX_NAME",
            "type": "string",
            "text": "项目类型",
            "fontSize": "15px",
            "width": '13%'
        }, {
            "dataIndex": "BUILD_STATUS_NAME",
            "type": "string",
            "text": "建设状态",
            "fontSize": "15px",
            "width": '10%'
        }, {
            "dataIndex": "XMZGS_AMT",
            "type": "float",
            "text": "项目总概算金额（万元）",
            "fontSize": "15px",
            "width": '14%'
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'grid_jxmb_xmxx',
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
            MB_YEAR: mbYear,
            AG_CODE: AG_CODE
        },
        dataUrl: '/jxmbtb/getLxxmInfo.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
    //将form添加到表格中
    var searchTool = initWindow_xmxx_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}

/**
 * 初始化弹出框搜索区域
 */
function initWindow_xmxx_grid_searchTool() {
    //初始化查询控件
    var items = [];
    items.push(
        {
            xtype: 'treecombobox',
            fieldLabel: '项目类型',
            itemId: 'LR_XMLX_SEARCH',
            displayField: 'name',
            valueField: 'id',
            width: 190,
            labelWidth: 60,
            rootVisible: false,
            lines: false,
            allowBlank: true,
            selectModel: 'all',
            store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"}),
            editable: false,
            listeners: {
                change: function (self) {
                    var form = self.up('form');
                    if (form.isValid()) {
                        callBackReload(form);
                    }
                }
            }
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: "LR_XM_SEARCH",
            width: 360,
            labelWidth: 60,
            emptyText: '请输入单位名称/项目名称/项目编码',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var form = self.up('form');
                        if (form.isValid()) {
                            callBackReload(form);
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
            var XMLX_ID = Ext.ComponentQuery.query('treecombobox#LR_XMLX_SEARCH')[0].getValue();
            var mhcx = Ext.ComponentQuery.query('textfield#LR_XM_SEARCH')[0].getValue();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["XMLX_ID"] = XMLX_ID;
            store.getProxy().extraParams["MHCX"] = mhcx;
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
 * 保存/修改方法
 * @param btn
 * @param xmlx_id
 */
function submitInfo(btn, xmlx_id) {
    var jxmbForm = Ext.ComponentQuery.query('form[itemId="jxmbForm"]')[0]; //获取目标填报表单
    var jxmbObj = getJxmbtbAllDatas();
    if (!jxmbObj) {
        btn.setDisabled(false);
        return false;
    }
    var param = {
        WF_ID: wf_id,
        NODE_CODE: node_code,
        BUTTON_NAME: button_name,
        BUTTON_STATUS: button_status,
        AD_CODE: AD_CODE,
        MB_ID: jxmb_id,
        mbYear: mbYear,
        xm_id: xm_id,
        xmlx_id: xmlx_id,
        NDZTMB: jxmbObj.NDZTMB,
        jxmbGrid: Ext.util.JSON.encode(jxmbObj.jxmbGrid)
    };
    var url = '/jxmbtb/saveJxmbInfo.action';
    //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    btn.setDisabled(true);
    jxmbForm.submit({
        url: url,
        params: param,
        waitTitle: '请等待',
        waitMsg: '正在保存中...',
        success: function (form, action) {
            if (!isNull(action.result)) {
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                Ext.ComponentQuery.query('window[name="jxmbWin"]')[0].close();
                reloadGrid();
            } else {
                // url参数校验不通过提示异常
                Ext.toast({
                    html: '保存失败,数据异常！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                btn.setDisabled(false);
            }
        },
        failure: function (form, action) {
            Ext.MessageBox.alert('提示', '保存失败!' + action.result.message);
            btn.setDisabled(false);
        }
    });
}


/*
* 创建录入弹出窗口
* @param xm_id 项目ID
* @param xmlx_id  项目类型id
*/
function initWin_jxmbWindow(xm_id, xmlx_id) {
    var buttons = [
        {
            text: '保存',
            handler: function (btn) {
                //保存表单数据
                submitInfo(btn, xmlx_id);
            }
        },
        {
            text: '关闭',
            handler: function (btn) {
                btn.up('window').close();
            }
        }
    ];
    Ext.create('Ext.window.Window', {
        title: "项目绩效目标填报",
        name: 'jxmbWin',
        width: document.body.clientWidth, //自适应窗口宽度
        height: document.body.clientHeight, //自适应窗口高度
        maximizable: true,
        itemId: 'window_jxmb', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        layout: 'fit',
        autoScroll: true,
        defaults: {
            width: '100%'
        },
        items: initWindow_contentForm_tab_jxmb(xm_id, jxmb_id, mbYear, xmlx_id),
        buttons: buttons
    }).show();
}
