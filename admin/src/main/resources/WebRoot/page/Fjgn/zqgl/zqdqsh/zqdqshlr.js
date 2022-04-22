var ADD_ZQ_ID = null;//增加按钮中 用到的项目id
var json_wf = [
    {"id": "001", "code": "001", "name": "未送审"},
    {"id": "002", "code": "002", "name": "已送审"},
    {"id": "004", "code": "004", "name": "被退回"},
    {"id": "008", "code": "008", "name": "曾经办"}
];

var tbarItem = {
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
                handler: function (btn) {
                    add_update_window(btn, "债券信息增加");
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'btn_edit',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    add_update_window(btn, "债券信息修改");
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    deleteInfo(btn);
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
                itemId: 'mbxz',
                text: '模板下载',
                icon: '/image/sysbutton/back.png',
                hidden: false,
                handler: function (btn) {
                    szysExcelDown();//收支平衡表格模板下载
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
                itemId: 'mbxz',
                text: '模板下载',
                icon: '/image/sysbutton/back.png',
                hidden: false,
                handler: function (btn) {
                    szysExcelDown();//收支平衡表格模板下载
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
                handler: function (btn) {
                    add_update_window(btn, "债券信息修改");
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    deleteInfo(btn);
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
                itemId: 'mbxz',
                text: '模板下载',
                icon: '/image/sysbutton/back.png',
                hidden: false,
                handler: function (btn) {
                    szysExcelDown();//收支平衡表格模板下载
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
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                itemId: 'mbxz',
                text: '模板下载',
                icon: '/image/sysbutton/back.png',
                hidden: false,
                handler: function (btn) {
                    szysExcelDown();//收支平衡表格模板下载
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
}

function add_update_window(btn, title) {
    button_name = btn.name;
    button_text = btn.text;

    if (button_name == "btn_add") {
        // 单位校验
        if (!AD_CODE || AD_CODE == '') {
            Ext.Msg.alert('提示', "请选择单位");
            return;
        }
        openWindow.show(title);
    }
    if (button_name == "btn_edit") {
        // 单条校验
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return false;
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
            return false;
        }
        ADD_ZQ_ID = records[0].get("ZQSH_PLAN_ID");
        openWindow.show(title);
        var store = openWindow.window.down('form').down('grid#zq_edit_Grid').getStore();
        store.loadData(records);
    }
}

/**
 * 编辑弹出框
 */
var openWindow = {
    window: null,
    show: function (title) {
        this.window = Ext.create('Ext.window.Window', {
            title: title,
            itemId: 'openWin',
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
            items: [zq_fj_tab()],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    name: 'btn_update',
                    id: 'save',
                    handler: function (btn) {
                        saveBtn(btn);
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
        upload_fj_panel();
    }
};

// 流程
function doWorkFlow(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    var IDS = [];
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    for (var i in records) {
        IDS.push(records[i].get("ZQSH_PLAN_ID"));
    }
    Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
        if (btn_confirm === 'yes') {
            //发送ajax请求，修改节点信息
            btn.setDisabled(true);//防止多次点击保存按钮
            $.post("/bjsh/doZqshWorkFlow.action", {
                workflow_direction: btn.name,
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                button_text: button_text,
                btn: btn.name,
                audit_info: '',
                ids: IDS,
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
 * 删除信息
 */
function deleteInfo(btn) {
    button_name = btn.text;
    button_text = btn.text;

    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
            if (records.length == 0) {
                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                return false;
            }
            var bgInfoArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.ZQSH_PLAN_ID = record.get("ZQSH_PLAN_ID");
                bgInfoArray.push(array);
            });
            //向后台传递变更数据信息
            $.post('/bjsh/delShZqInfo.action', {
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
    });
}

// 初始化-债券-附件-tab层
function zq_fj_tab() {
    return Ext.create('Ext.tab.Panel', {
        name: 'tabPanel',
        flex: 1,
        border: false,
        defaults: {
            border: false
        },
        items: [
            {
                title: '债券信息',
                layout: 'fit',
                items: zqListTab()
            },
            {
                title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
                name: 'fj',
                layout: 'fit',
                items: initFjPanel()
            }
        ]
    });
}

// 初始化债券列表
function zqListTab() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'vbox',
        border: false,
        padding: '2 5 2 10',
        items: [
            zqListGrid()
        ]
    });
}

// 初始化附件
function initFjPanel() {
    return Ext.create('Ext.form.Panel', {
        id: 'upPanelAdd',
        name: 'upPanelNameAdd',
        layout: 'fit',
        border: false,
        items: []
    });
}

// 新增债券页签-债券列表
function zqListGrid() {
    var grid = DSYGrid.createGrid({
        itemId: 'zq_edit_Grid',
        headerConfig: {
            headerJson: getHeaderJson(),
            columnAutoWidth: false
        },
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
                    }
                }
            }
        ],
        listeners: {
            select: function (self, record, index, eOpts) {
            },
            itemclick: function (self, record) {
                // 债券列表点击事件
                ADD_ZQ_ID = record.get("ZQSH_PLAN_ID");

                upload_fj_panel();
            }
        },
        width: '100%',
        height: '20px',
        flex: 1,
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
                text: '增加债券',
                itemId: 'addBtn',
                width: 80,
                handler: function (btn) {
                    // 债券选择框
                    openSelectWin().show();
                }
            }, {
                xtype: 'button',
                text: '删除债券',
                itemId: 'delBtn',
                width: 80,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var records = grid.getSelectionModel().getSelection();
                    Ext.each(records, function (record) {
                        store.remove(record);
                    })
                }
            }]
        }, 0);
    }
    return grid;
}

// 增加按钮-附件页签
function upload_fj_panel() {
    var busiId = ADD_ZQ_ID;

    var grid = UploadPanel.createGrid({
        busiType: 'ET909',//业务类型
        busiId: busiId,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: true,
        gridConfig: {
            itemId: "fjPanelGrid"
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
            emptyText: '请输入债券编码/名称...',
            enableKeyEvents: true,
            listeners: {
                specialkey: function (field, e) {//监听回车事件
                    reloadGrid();
                }
            }
        }
    ];
}

function getTbar() {
    return tbarItem.items[WF_STATUS];
}

/**
 * 保存
 */
function saveBtn(btn) {
    btn.setDisabled(true);
    var gridData = DSYGrid.getGrid('zq_edit_Grid').getStore();
    var storeData = new Array();
    // 非空校验
    if (gridData.getCount() == 0) {
        Ext.Msg.alert('提示', "请增加债券信息！");
        btn.setDisabled(false);
        return;
    }
    for (var i = 0; i < gridData.getCount(); i++) {
        var xm = gridData.getAt(i);
        storeData.push(xm.data);
    }

    $.post('/bjsh/saveShzqxx.action', {
        button_name: btn.name,//增加还是编辑
        button_text: btn.text,//增加还是编辑
        audit_info: null,
        AD_CODE: AD_CODE,
        GRID_STORE: encode64(Ext.util.JSON.encode(storeData)),
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
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
    }, 'JSON');
}

// 债券选择框
function openSelectWin() {
    shOpen = true;

    var gridConfig = {
        itemId: 'select_zq_grid',
        name: 'PopupGrid',
        headerConfig: {
            rowNumber: true,
            headerJson: getHeaderJson(),
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        height: '100%',
        pageConfig: {
            enablePage: false
            // pageNum: true
        },
        dataUrl: '/bjsh/getDqZqList.action',
        checkBox: true,
        params: {
            AD_CODE: AD_CODE
            // ZQSH_PLAN_ID:ADD_ZQ_ID
        },
        dockedItems: [],
        tbar: []
    };
    var grid = new DSYGrid.createGrid(gridConfig);
    var window = Ext.create('Ext.window.Window', {
        closeAction: 'destroy',
        title: '选择债券',
        width: document.body.clientWidth * 0.6,
        height: document.body.clientHeight * 0.8,
        layout: 'fit',
        modal: true,
        buttonAlign: 'center',
        buttons: [
            {
                text: '确认',
                listeners: {
                    'click': function (btn) {
                        var gridStore = DSYGrid.getGrid('zq_edit_Grid').getStore();
                        var gridItems = gridStore.data.items;
                        var currentIndex;
                        if (gridItems.length == 0) {
                            currentIndex = 0;

                        } else {
                            currentIndex = gridItems.length;
                        }

                        var records = DSYGrid.getGrid('select_zq_grid').getSelection();
                        var ZQ_ID = records[0].get("ZQ_ID");
                        for (var i = 0; i < records.length; i++) {
                            var zqshId = getGuid();
                            // 赋值-默认值
                            records[i].set('IS_SH', 1); // 赎回
                            records[i].set('ZQSH_PLAN_ID', zqshId); //附件关联id
                            // if(isNull(records[i].get("ZQSH_PLAN_ID"))){
                            //     records[i].set('ZQSH_PLAN_ID', zqshId); //附件关联id
                            // }

                            DSYGrid.getGrid('zq_edit_Grid').insertData(currentIndex, records[i]);
                        }
                        // 关闭弹出窗口
                        btn.up("window").close();
                        shOpen = false;
                    }
                }
            },
            {
                text: '取消',
                listeners: {
                    'click': function (btn) {
                        btn.up("window").close();
                        shOpen = false;
                    }
                }
            }
        ],
        items: [grid]
    });
    return window;
}

// 模板下载
function szysExcelDown() {
    window.location.href = 'downExcel.action?file_name=' + encodeURI(encodeURI("北京市地方政府含权债券赎回选择权确认单（模板）.docx"));
}

// 业务ID
function getGuid() {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0,
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}