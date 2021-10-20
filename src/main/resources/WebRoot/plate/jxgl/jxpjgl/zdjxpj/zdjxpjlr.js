/**
 * 默认数据：工具栏
 */
$.extend(zdjxpj_json_common[wf_id][node_type], {
    items_content: function () {
        // 省级展示区划单位树，地市/区县只展示单位树
        return [
            MOF_TYPE == "1" ? initContentTree() : initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),
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
                    button_text = btn.name;
                    button_name = btn.text;
                    zdjxpj_id = GUID.createGUID();
                    newYear = Ext.ComponentQuery.query('combobox#JX_YEAR')[0].getValue();
                    window_zdjxpj_xmxx.show();
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
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    } else {
                        var PARAM_MOF_DIV_CODE = records[0].get("MOF_DIV_CODE");
                        var PARAM_XMLX_ID = records[0].get("XMLX_ID");
                        var PARAM_PJ_ID = records[0].get("PJ_ID");
                        var params = {
                            "MOF_DIV_CODE": PARAM_MOF_DIV_CODE,
                            "XMLX_ID": PARAM_XMLX_ID,
                            "YHS": ''
                        };
                        zdjxpj_id = records[0].get("PJ_ID");
                        xm_id = records[0].get("PRO_ID");
                        button_name = btn.text;
                        button_text = btn.name;
                        initWin_zdjxpjWindow(xm_id, button_text, '', params);
                        loadZdjxpjInfo(PARAM_PJ_ID);
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
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            delZdjxpjInfo(btn);
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
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
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
            {
                xtype: 'button',
                text: '导出重点项目评价表',
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
                    button_text = btn.name;
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
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
                    reloadGrid();
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
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    } else {
                        zdjxpj_id = records[0].get("PJ_ID");
                        xm_id = records[0].get("PRO_ID");
                        button_name = btn.text;
                        button_text = btn.name;
                        var PARAM_MOF_DIV_CODE = records[0].get("MOF_DIV_CODE");
                        var PARAM_XMLX_ID = records[0].get("XMLX_ID");
                        var params = {
                            "MOF_DIV_CODE": PARAM_MOF_DIV_CODE,
                            "XMLX_ID": PARAM_XMLX_ID,
                            "YHS": ''
                        };
                        initWin_zdjxpjWindow(xm_id, button_text, '', params);
                        loadZdjxpjInfo(zdjxpj_id);
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
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            delZdjxpjInfo(btn);
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
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
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
 * 删除绩效评价信息
 */
function delZdjxpjInfo(btn) {
    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var jxArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.PJ_ID = record.get("PJ_ID");
        jxArray.push(array);
    });
    // 避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    btn.setDisabled(true);
    //向后台传递变更数据信息
    $.post('/zdjxpj/delZdjxpjInfo.action', {
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
 * @type {{window: null, show: window_zdjxpj_xmxx.show}}
 */
var window_zdjxpj_xmxx = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_zdjxpj_xmxx();
        }
        this.window.show();
    }
};

/**
 * 初始化项目信息弹出窗口
 */
function initWindow_zdjxpj_xmxx() {
    return Ext.create('Ext.window.Window', {
        title: '遴选项目', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'zdjxpj_window_xmxx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_zdjxpj_xmxx_grid()],
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
                    xm_id = records[0].get("PRO_ID");
                    // console.log(records[0].get("IS_ALERADY_ZP"));
                    var PARAM_MOF_DIV_CODE = records[0].get("MOF_DIV_CODE");
                    var PARAM_XMLX_ID = records[0].get("XMLX_ID");
                    var params = {
                        "MOF_DIV_CODE": PARAM_MOF_DIV_CODE,
                        "XMLX_ID": PARAM_XMLX_ID,
                        "YHS": ''
                    };
                    var IS_ALREADY_ZP_VALUE = records[0].get("IS_ALERADY_ZP");
                    if (IS_ALREADY_ZP_VALUE == 'wzp') {
                        Ext.Msg.alert('提示', "此项目未进行单位项目自评,请先进行单位自评，再进行重点绩效评价");
                        return;
                    }
                    //关闭当前窗口，打开录入窗口
                    btn.up('window').close();
                    initWin_zdjxpjWindow(xm_id, button_text, '', params);
                    var zdjxpj_xmgy_Form = Ext.ComponentQuery.query('form[name="zdjxpj_xmgy_Form"]')[0];
                    zdjxpj_xmgy_Form.getForm().setValues(records[0].data);
                    zdjxpj_xmgy_Form.getForm().findField('PJ_YEAR').setValue(newYear);
                    json_dfz = [];
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
                window_zdjxpj_xmxx.window = null;
            }
        }
    });
}

/**
 * 初始化绩效自评录入弹出表格
 */
function initWindow_zdjxpj_xmxx_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            "dataIndex": "PRO_ID",
            "type": "string",
            "text": "项目ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "IS_ALERADY_ZP",
            "type": "string",
            "text": "项目是否已进行过自评",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "MOF_DIV_CODE",
            "type": "string",
            "text": "项目区划",
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
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
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
            "width": '10%'
        }, {
            "dataIndex": "JSXZ_NAME",
            "type": "string",
            "text": "建设性质",
            "fontSize": "15px",
            "width": '10%'
        }, {
            "dataIndex": "XMXZ_NAME",
            "type": "string",
            "text": "项目性质",
            "fontSize": "15px",
            "width": '13%'
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
            "width": '18%'
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'grid_zdjxpj_xmxx',
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
            AG_CODE: AG_CODE,
            MOF_TYPE: MOF_TYPE,
            NEWYEAR: newYear,
            IS_ALREADY_ZP: IS_ALREADY_ZP
        },
        dataUrl: '/zdjxpj/getZdjxpjLxxmInfo.action',
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
        // 是否进行过自评
        {
            xtype: 'combobox',
            fieldLabel: '是否已进行自评',
            itemId: 'IS_ALREADY_ZP',
            displayField: 'name',
            valueField: 'code',
            value: "0",
            store: DebtEleStore(json_debt_is_alerady_zp),
            editable: false,
            labelWidth: 90,
            width: 160,
            columnWidth: .21,
            allowBlank: false,
            listeners: {
                change: function (self, newValue) {
                    IS_ALREADY_ZP = newValue;
                    //刷新当前表格
                    DSYGrid.getGrid('grid_zdjxpj_xmxx').getStore().getProxy().extraParams["IS_ALREADY_ZP"] = IS_ALREADY_ZP;
                    DSYGrid.getGrid('grid_zdjxpj_xmxx').getStore().loadPage(1);
                }
            }
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
            store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"})
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
            store.getProxy().extraParams["IS_ALREADY_ZP"] = IS_ALREADY_ZP;
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
 * 切换页签
 * @param index
 */
function zqxxtbTab(index) {
    var zqxxtbTab = Ext.ComponentQuery.query('panel[itemId="xmxxTabPanel"]')[0];
    zqxxtbTab.items.get(index - 1).show();
}

/**
 * 保存/修改方法
 * @param workflow
 * @param btn
 */
function submitInfo(workflow, btn) {
    var zdjxpj_xmgy_Form = Ext.ComponentQuery.query('form[name="zdjxpj_xmgy_Form"]')[0];
    var zdjxpjGrid = DSYLayUITreeGrid.getDataList('zdjxpjGrid');
    if (zdjxpjGrid.length <= 0) {
        Ext.Msg.alert('提示', "请先发布绩效评价指标，再进行评价操作！");
        return;
    }
    for (var i = 0; i < zdjxpjGrid.length; i++) {
        var row = zdjxpjGrid[i];
        row.SJ_SCORE_VALUE = json_dfz[row.DTL_ID] ? json_dfz[row.DTL_ID] : 0;
    }
    // 绩效评价得分校验
    if (zdjxpj_xmgy_Form.isValid()) {
        for (var i = 0; i < zdjxpjGrid.length; i++) {
            var row = zdjxpjGrid[i];
            if (row['LEVEL_NO'] == '03' && isNull(row['SCORE_VALUE'])) {
                return false;
            }
            if (row['LEVEL_NO'] == '03' && !isNull(row['SCORE_VALUE'])) {
                if (row['SCORE_VALUE'] > row['FULL_VALUE']) {
                    return false;
                }
            }
            var check_msg = /^\d+(\.\d+)?$/;
            if (row['LEVEL_NO'] == '03' && !isNull(row['SCORE_VALUE'])) {
                if (isNaN(row['SCORE_VALUE']) || !check_msg.test(row['SCORE_VALUE'])) {
                    return false;
                }
            }
            var sjTargetValue = zdjxpjGrid[i].SJ_TARGET_VALUE;
            if (!isNull(sjTargetValue)) {
                if (sjTargetValue.length > 2000) {
                    Ext.Msg.alert('提示', "指标名称：'" + row['IND_NAME'] + "',实际完成值输入内容过长！");
                    return;
                }
            }

            var zgyjValue = zdjxpjGrid[i].ZGYJ;
            if (!isNull(zgyjValue)) {
                if (zgyjValue.length > 2000) {
                    Ext.Msg.alert('提示', "指标名称：'" + row['IND_NAME'] + "',整改意见输入内容过长！");
                    return;
                }
            }

            if (row['LEVEL_NO'] == '03' && row['SCORE_VALUE'] <= 0) {
                Ext.Msg.alert('提示', "绩效目标名称'" + row['IND_NAME'] + "',得分必须大于0！");
                return;
            }
        }
        var pj_value = zdjxpj_xmgy_Form.getForm().findField('PJ_VALUE').value;
        if (parseFloat(pj_value) > 100) {
            Ext.Msg.alert('提示', "总分必需小于或等于100！");
            return;
        }

        if (button_text == 'INPUT') {
            var param = {
                WF_ID: wf_id,
                NODE_CODE: node_code,
                NODE_TYPE: node_type,
                AG_CODE: AG_CODE,
                MOF_TYPE: MOF_TYPE,
                BUTTON_NAME: button_name,
                ZDJXPJ_ID: zdjxpj_id,
                xmgyForm: '[' + Ext.util.JSON.encode(zdjxpj_xmgy_Form.getValues()) + ']',
                jxzpGrid: Ext.util.JSON.encode(zdjxpjGrid)
            }
            var url = '/zdjxpj/saveZdjxpjInfo.action';
        } else if (button_text == 'UPDATE') {
            var param = {
                WF_ID: wf_id,
                NODE_CODE: node_code,
                NODE_TYPE: node_type,
                MOF_TYPE: MOF_TYPE,
                AG_CODE: AG_CODE,
                BUTTON_NAME: button_name,
                ZDJXPJ_ID: zdjxpj_id,
                xmgyForm: '[' + Ext.util.JSON.encode(zdjxpj_xmgy_Form.getValues()) + ']',
                jxzpGrid: Ext.util.JSON.encode(zdjxpjGrid)
            }
            var url = '/zdjxpj/changeZdjxpjInfo.action';
        }
        //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
        btn.setDisabled(true);
        // 保存方式修改
        zdjxpj_xmgy_Form.submit({
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
                    Ext.ComponentQuery.query('window[name="zdjxpjWin"]')[0].close();
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

    } else {
        Ext.toast({
            html: "请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return;
    }
}
