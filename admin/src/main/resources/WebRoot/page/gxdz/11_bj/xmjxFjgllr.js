var JX_YEAR = null;//绩效年度变量
var ADD_XM_ID = null;//增加按钮中 用到的项目id
var BUIS_ID = null;//增加按钮中 用到的项目id

var json_wf = [
    {"id": "001", "code": "001", "name": "未送审"},
    {"id": "002", "code": "002", "name": "已送审"},
    {"id": "004", "code": "004", "name": "被退回"},
    {"id": "008", "code": "008", "name": "曾经办"}
];

tbarItem = {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '增加',
                name: 'btn_add',
                icon: '/image/sysbutton/edit.png',
                handler: function () {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (!AG_ID || AG_ID == '') {
                        Ext.Msg.alert('提示', "请选择底级单位！");
                        return false;
                    }
                    fuc_addXmzgl(this.name);
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'btn_edit',
                icon: '/image/sysbutton/edit.png',
                handler: function () {
                    fuc_updateFxgl(this.name);
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
                            deleteXmjxInfo();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'btn_up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    xmfjxz();
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
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销送审',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_text = btn.text;
                    button_name = btn.name;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'btn_up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    xmfjxz();
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
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'btn_edit',
                icon: '/image/sysbutton/edit.png',
                handler: function () {
                    fuc_updateFxgl(this.name);
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
                            deleteXmjxInfo();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'btn_up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    xmfjxz();
                }
            },
            '->',
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '008': [
            {
                xtype: 'button',
                text: '查询',
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '导出',
                name: 'btn_up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    xmfjxz();
                }
            },
            '->',
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
}

function getScreenBar() {
    return [
        {
            xtype: "combobox",
            fieldLabel: '状态',
            name: 'WF_STATUS',
            store: DebtEleStore(json_wf),
            allowBlank: false,
            labelAlign: 'left',//控件默认标签对齐方式
            labelWidth: 40,
            width: 150,
            editable: false, //禁用编辑
            displayField: "name",
            valueField: "code",
            value: WF_STATUS,
            listeners: {
                'change': function (self, newValue, oldValue) {
                    WF_STATUS = newValue;
                    var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                    toolbar.removeAll();
                    toolbar.add(getTbar());
                    // 修改数据
                    reloadGrid();
                }
            }
        },
        {
            xtype: "textfield",
            name: "mhcx",
            id: "mhcx",
            fieldLabel: '模糊查询',
            allowBlank: true,
            labelWidth: 70,
            width: 260,
            labelAlign: 'right',
            emptyText: '请输入项目编码/名称...',
            enableKeyEvents: true,
            listeners: {
                specialkey: function (field, e) {//监听回车事件
                    reloadGrid();
                }
            }
        },
        {
            xtype: "combobox",
            name: "YEAR",
            store: DebtEleStore(json_debt_year),
            displayField: "name",
            valueField: "id",
            width: 240,
            labelWidth: 60,
            labelAlign: 'right',
            fieldLabel: '绩效年度',
            editable: false, //禁用编辑
            enableKeyEvents: true,
            listeners: {
                specialkey: function (field, e) {//监听回车事件
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        reloadGrid();
                    }
                },
                'change': function (self, newValue, oldValue) {
                    YEAR = newValue;
                    reloadGrid();
                }
            }
        },
    ];
}

function getTbar() {
    return tbarItem.items[WF_STATUS];
}

function doWorkFlow(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    var XM_IDS = [];
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    for (var i in records) {
        XM_IDS.push(records[i].get("BUIS_ID"));
        // 校验附件
        $.post("/upload/refreshGrid.action?_dc=" + Date.parse(new Date()), {
            rule_ids: null,
            busi_type: 'ET909',
            busi_property: '%',
            editable: false,
            busi_id: records[i].get("BUIS_ID")
        }, function (data) {
            if (data.list.length == 0) {
                Ext.MessageBox.alert('提示', records[i].get("XM_NAME") + ' 项目缺少附件');
                return;
            }
        }, "json");
    }
    Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            //发送ajax请求，修改节点信息
            btn.setDisabled(true);//防止多次点击保存按钮
            $.post("/bj/doxmjxfjWorkFlow.action", {
                workflow_direction: btn.name,
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                button_text: button_text,
                btn: btn.name,
                audit_info: '',
                ids: XM_IDS,
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: button_text + "成功！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                } else {
                    Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                }
                btn.setDisabled(false);//防止多次点击保存按钮
                //刷新表格
                reloadGrid();
            }, "json");
        }
    });
}

/**
 * 修 改
 */
function fuc_updateFxgl(name) {

    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
        return false;
    }
    XM_ID = records[0].get("XM_ID");
    ADD_XM_ID = records[0].get("XM_ID");
    JX_YEAR = records[0].get("JX_YEAR");
    BUIS_ID = records[0].get("BUIS_ID");

    button_name = name;
    //发送ajax请求
    $.post("/bj/getXmjxFjSelect.action", {
        BUIS_ID: BUIS_ID
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '修改失败！' + data.message);
            return;
        }
        //弹出弹出框，并将表数据插入到弹出框form中
        editWindow.show("项目信息修改");
        Ext.ComponentQuery.query('combobox[name="JX_YEAR"]')[0].setValue(data.list[0].JX_YEAR);
        JX_YEAR = data.list[0].JX_YEAR;
        var store = editWindow.window.down('form').down('grid#xm_edit_Grid').getStore();
        store.loadData(data.list);
    }, "json");
}

/**
 * 删除绩效项目信息
 */
function deleteXmjxInfo() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var bgInfoArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.BUIS_ID = record.get("BUIS_ID");
        bgInfoArray.push(array);
    });
    //向后台传递变更数据信息
    $.post('/bj/delXmjxInfo.action', {
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
 * 项目信息增加/修改页面
 */
function fuc_addXmzgl(name) {
    button_name = name;
    ADD_XM_ID = null;
    JX_YEAR = null;
    BUIS_ID = null;
    if (name == 'btn_add') {//增加按钮
        editWindow.show("项目信息增加");
    }
}

/**
 * 编辑弹出框
 */
var editWindow = {
    window: null,
    show: function (title) {
        this.window = Ext.create('Ext.window.Window', {
            title: title,
            itemId: 'editWin',
            width: document.body.clientWidth * 0.9,
            height: document.body.clientHeight * 0.9,
            layout: 'fit',
            maximizable: true,
            frame: true,
            constrain: true,
            buttonAlign: "right", // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            items: [initWin_xmjxglTabPanel()],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    name: 'btn_update',
                    id: 'save',
                    handler: function (btn) {
                        saveXMXX(btn);
                    }
                }, {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        this.window.show();
        initWindow_xmjx_upload();
    }
};

/**
 * 保存项目内容
 */
function saveXMXX(btn) {
    btn.setDisabled(true);
    //校验必录项
    if (isNull(JX_YEAR)) {
        Ext.Msg.alert('提示', "请选择绩效年度！");
        btn.setDisabled(false);
        return;
    }
    var xmgrid = DSYGrid.getGrid('xm_edit_Grid').getStore();
    var xm_store_data = new Array();
    var ids = [];
    if (button_name == 'btn_add' && xmgrid.getCount() == 0) {
        Ext.Msg.alert('提示', "请增加项目信息！");
        btn.setDisabled(false);
        return;
    }
    for (var i = 0; i < xmgrid.getCount(); i++) {
        var xm = xmgrid.getAt(i);
        xm_store_data.push(xm.data);
        ids.push(xm.data.XM_ID);
    }
    // 修改时 去除选中项目
    if (button_name == 'btn_edit') {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        var editID = records[0].get("XM_ID") //获取修改的项目
    } else {
        var editID = null;
    }

    $.post('/bj/chekXmxx.action', {
        JX_YEAR: JX_YEAR,
        ids: ids,
        editID: editID
    }, function (data) {
        if (data.chek) {

            $.post('/bj/saveXmxx.action', {
                button_name: btn.name,//增加还是编辑
                button_text: btn.text,//增加还是编辑
                audit_info: null,//增加还是编辑
                XM_STORE: Ext.util.JSON.encode(xm_store_data),
                JX_YEAR: JX_YEAR,
                WF_ID: wf_id,
                NODE_CODE: node_code,
                IS_END: IS_END,
                NODE_CURRENT_ID: '1',
                NODE_NEXT_ID: '2',
                WF_STATUS: WF_STATUS
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
                    DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                } else {
                    Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                    btn.setDisabled(false);
                }
            }, 'JSON');
        } else {
            btn.setDisabled(false);
            Ext.MessageBox.alert('提示', '所选年度已存在项目: ' + data.result);
        }
    }, 'JSON');
}

// 初始化录入框
function initWin_xmjxglTabPanel() {
    var xmjxTabPanel = Ext.create('Ext.tab.Panel', {
        name: 'EditorPanel',
        flex: 1,
        border: false,
        defaults: {
            border: false
        },
        items: [
            {
                title: '项目信息',
                layout: 'fit',
                items: xmjxfjpzTab()
            },
            {
                title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
                name: 'xmjxFj',
                layout: 'fit',
                items: initContentUploadPanelAdd()
            }
        ]
    });
    return xmjxTabPanel;
}

/**
 * 初始化项目信息编辑框
 */
function xmjxfjpzTab() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'vbox',
        border: false,
        padding: '2 5 2 10',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                margin: '5 5 5 5',
                items: [
                    {
                        xtype: "combobox",
                        name: "JX_YEAR",
                        store: DebtEleStore(json_debt_year),
                        displayField: "name",
                        valueField: "id",
                        width: 240,
                        labelWidth: 80,
                        labelAlign: 'right',
                        fieldLabel: '<span class="required">✶</span>绩效年度',
                        editable: false, //禁用编辑
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                JX_YEAR = newValue;
                            }
                        }
                    },
                ]
            },
            init_contentGrid()
        ]
    });
}

// 新增项目页签-项目列表
function init_contentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40
        },
        {
            "dataIndex": "BUIS_ID",
            "type": "string",
            "text": "唯一ID",
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
                var url = '/page/debt/common/xmyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                paramNames[1] = "IS_RZXM";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
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
            "text": "项目总概算金额(万元)",
            "fontSize": "15px",
            "width": 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'xm_edit_Grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqzd_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            select: function (self, record, index, eOpts) {
                // getUpPane(record.get("XM_ID"));
            },
            itemclick: function (self, record) {
                BUIS_ID = record.get("BUIS_ID")
                // 附件的业务id取 项目绩效年度
                initWindow_xmjx_upload();
            }
        },
        width: '100%',
        height: '20px',
        flex: 1,
        // checkBox: true,
        // singleSelect: true,
        pageConfig: {
            enablePage: false
        },
        autoLoad: false,
        data: []
    });
    // 将增加删除按钮添加到表格中
    if (button_name == 'btn_add') {
        grid.addDocked({
            xtype: 'toolbar',
            layout: 'hbox',
            items: ['', {
                xtype: 'button',
                text: '删除项目',
                itemId: 'delete_editGrid',
                width: 80,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var records = grid.getSelectionModel().getSelection();
                    Ext.each(records, function (record) {
                        store.remove(record);
                    })
                }
            }, {
                xtype: 'button',
                text: '增加项目',
                itemId: 'yyxm',
                width: 80,
                handler: function (btn) {
                    initZjSelectWin().show();
                }
            }]
        }, 0);
    }
    return grid;
}

//  增加按钮-附件页签
function initWindow_xmjx_upload() {

    var grid = UploadPanel.createGrid({
        busiType: 'ET909',//业务类型
        busiId: BUIS_ID,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: true,
        gridConfig: {
            itemId: BUIS_ID
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
        if (grid.up('winPanel_xmjxPanel') && grid.up('winPanel_xmjxPanel').el && grid.up('winPanel_xmjxPanel').el.dom) {
            $(grid.up('winPanel_xmjxPanel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
        } else if ($('span.file_sum_fj')) {
            $('span.file_sum_fj').html('(' + sum + ')');
        }
    });

    var item = [grid];
    var panel = Ext.getCmp('upPanelAdd');
    panel.removeAll();
    panel.add(item);
    panel.doLayout();
}

function initContentUploadPanelAdd() {
    return Ext.create('Ext.form.Panel', {
        id: 'upPanelAdd',
        name: 'upPanelNameAdd',
        layout: 'fit',
        border: false,
        items: []
    });
}

/**
 * 初始化项目选择弹出框window
 * @param self
 * @param store
 * @returns {Ext.window.Window}
 */
function initZjSelectWin() {
    var gridConfig = {
        itemId: 'xmtgGrid',
        name: 'PopupGrid',
        headerConfig: {
            rowNumber: true,
            headerJson: [
                {
                    xtype: 'rownumberer',
                    summaryType: 'count',
                    width: 40
                },
                {
                    "dataIndex": "BUIS_ID",
                    "type": "string",
                    "text": "唯一ID",
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
                        var url = '/page/debt/common/xmyhs.jsp';
                        var paramNames = new Array();
                        paramNames[0] = "XM_ID";
                        paramNames[1] = "IS_RZXM";
                        var paramValues = new Array();
                        paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                        paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));

                        var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
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
                    "text": "项目总概算金额(万元)",
                    "fontSize": "15px",
                    "width": 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ],
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        height: '100%',
        pageConfig: {
            enablePage: true,
            pageNum: true
        },
        dataUrl: '/bj/getJxxmInfo.action',
        checkBox: true,
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            JX_YEAR: JX_YEAR
        },
        dockedItems: [],
        tbar: []
    };
    var grid = new DSYGrid.createGrid(gridConfig);
    var window = Ext.create('Ext.window.Window', {
        closeAction: 'destroy',
        title: '选择项目',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.8,
        layout: 'fit',
        modal: true,
        buttonAlign: 'center',
        buttons: [
            {
                text: '确认',
                listeners: {
                    'click': function (btn) {
                        var yyxmGridStore = DSYGrid.getGrid('xm_edit_Grid').getStore();
                        var yyxmGridItems = yyxmGridStore.data.items;
                        var currentIndex;
                        if (yyxmGridItems.length == 0) {
                            currentIndex = 0;
                        } else {
                            currentIndex = yyxmGridItems.length;
                        }
                        var records = DSYGrid.getGrid('xmtgGrid').getSelection();
                        for (var i = 0; i < records.length; i++) {
                            var buisID = getGuid();
                            records[i].set('BUIS_ID', buisID); //附件关联id
                            DSYGrid.getGrid('xm_edit_Grid').insertData(currentIndex, records[i]);
                        }
                        // 关闭弹出窗口
                        btn.up("window").close();
                    }
                }
            },
            {
                text: '取消',
                listeners: {
                    'click': function (btn) {
                        btn.up("window").close();
                    }
                }
            }
        ],
        items: [grid]
    });
    return window;
}

// 业务ID
function getGuid() {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0,
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}