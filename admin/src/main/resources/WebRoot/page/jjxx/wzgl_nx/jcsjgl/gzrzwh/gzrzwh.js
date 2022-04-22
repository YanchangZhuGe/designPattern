/**
 * 刷新表格
 */
function reloadGrid() {
    var store = DSYGrid.getGrid('unitGrid').getStore();
    var work_type_id = Ext.getCmp('work_type_id').getValue();
    var START_TIME = Ext.util.Format.date(Ext.ComponentQuery.query('[name="START_TIME"]')[0].getValue(), 'Y-m-d');
    var END_TIME = Ext.util.Format.date(Ext.ComponentQuery.query('[name="END_TIME"]')[0].getValue(), 'Y-m-d');
    var mhcx = Ext.ComponentQuery.query('textfield#SEARCH')[0].getValue();

    store.getProxy().extraParams["mhcx"] = mhcx;
    store.getProxy().extraParams["work_type_id"] = work_type_id;
    store.getProxy().extraParams["start_time"] = START_TIME;
    store.getProxy().extraParams["end_time"] = END_TIME;
    store.loadPage(1);
}

/**
 * 初始化面板放置表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        tbar: [
            {
                fieldLabel: '工作类型',
                name: 'GZLX',
                id: 'work_type_id',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreDB("DEBT_WORKLOG"),
                allowBlank: true,
                width: 250,
                labelWidth: 60,
                labelAlign: 'left'
            },
            {
                fieldLabel: '开始时间',
                name: 'START_TIME',
                xtype: 'datefield',
                format: 'Y-m-d',
                width: 250,
                labelWidth: 60,
                editable: false
                //  labelAlign: 'right'
            },
            {
                fieldLabel: '结束时间',
                name: 'END_TIME',
                xtype: 'datefield',
                format: 'Y-m-d',
                width: 250,
                labelWidth: 60,
                editable: false
                // labelAlign: 'right'
            },
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                itemId: "SEARCH",
                width: 350,
                labelWidth: 80,
                emptyText: '请输入当日工作内容...',
                enableKeyEvents: true,
                labelAlign: 'right',
                //ENTER键刷新表格
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            reloadGrid();
                        }
                    }
                }
            }
        ],
        items: [
            initUnitGrid()
        ]
    });
}

/**
 * 初始化主表格表头
 */
function initUnitGrid() {
    var headerJson = [
        {xtype: 'rownumberer', summaryType: 'count', width: 45},
        {dataIndex: "WORK_ID", type: "string", text: "", hidden: true},
        {dataIndex: "WORK_DATE", type: "string", text: "填报时间", width: 200},
        {dataIndex: "WORK_TYPE_NAME", type: "string", text: "工作类型", width: 200},
        {dataIndex: "WORK_CONTENT", type: "string", text: "当日工作内容", width: 500},
    ];
    return DSYGrid.createGrid({
        itemId: 'unitGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,//多选
        rowNumber: true,
        border: false,
        autoLoad: true,
        dataUrl: '/wzgl_nx/jcsjgl/getRzInfoGrid.action',
        height: '100%',
        flex: 1,
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
}

/**
 * 初始化弹出窗口
 */
function initWindow_unitinfo(config) {
    Ext.create('Ext.window.Window', {
        title: config.title, // 窗口标题
        // 弹出窗口宽高不固定，使用document.body.clientWidth
        width: document.body.clientWidth * 0.5, // 窗口宽度
        height: document.body.clientHeight * 0.5, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_unitinfo', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initWindow_unitinfo_contentForm(config),//初始化表单内容
        buttons: [
            {
                xtype: 'button',
                text: '保存',
                handler: function (self) {
                    submitInfo(config, self);
                }
            }, {
                xtype: 'button',
                text: '取消',
                handler: function (self) {
                    self.up('window').close();
                }
            }
        ]
    }).show();
}

/**
 * 初始化弹出窗口中的表单
 */
function initWindow_unitinfo_contentForm(config) {
    var form = Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        itemId: 'window_unitinfo_contentForm',
        layout: 'column',
        scrollable: true,
        defaultType: 'textfield',
        defaults: {
            margin: '7 8 3 5',//上右下左
            columnWidth: .9,//输入框的长度（百分比）
            labelAlign: "right",
            labelWidth: 110
        },
        items: [
            {
                xtype: 'textarea',
                name: 'WORK_ID',
                hidden: true
            },
            {
                fieldLabel: '<span class="required">✶</span>填报时间',
                name: 'WORK_DATE',
                xtype: 'datefield',
                format: 'Y-m-d',
                editable: false,//false以防止用户直接在字段中键入文本
                allowBlank: false,//不允许为空
            },
            {
                fieldLabel: '<span class="required">✶</span>工作类型',
                name: 'WORK_TYPE_ID',
                xtype: 'combobox',
                editable: false,
                valueField: 'id',
                displayField: 'name',//仅显示的文本字段id对应的name值
                store: DebtEleStoreDB("DEBT_WORKLOG"),
                allowBlank: false,

            },
            {
                fieldLabel: '<span class="required">✶</span>当日工作内容',
                xtype: 'textarea',
                name: 'WORK_CONTENT',
                editable: true,
                disabled: false,//如果为True则禁用该字段 默认为false
                grow: true,
                allowBlank: false
            }
        ]
    });
    if (config.record != null) {
        //form.down('textfield[name="WORK_DATE"]').setDisabled(true);//设置不可修改
        form.getForm().setValues(config.record.data);
    }
    return form;
}

/**
 * 保存事件
 */
function submitInfo(config, self) {
    var form = self.up('window').down('form');
    if (form.isValid()) {
        var formData = form.getForm().getFieldValues();
        formData = $.extend({}, formData, form.getValues());

        var url = '';
        if (formData.WORK_ID != "") {
            url = '/wzgl_nx/jcsjgl/updateRzData.action'
        } else if (formData.hasOwnProperty("WORK_ID")) {
            url = '/wzgl_nx/jcsjgl/addRzData.action'
        }
        // var url = formData.hasOwnProperty("WORK_ID") && formData.WORK_ID != ""
        //     ? '/wzgl_nx/updateRzData.action' : url = '/wzgl_nx/addRzData.action';

        self.setDisabled(true);
        $.post(url, {
            detailForm: Ext.util.JSON.encode([formData])
        }, function (data) {
            if (data.success) {
                self.setDisabled(false);
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                self.up('window').close();
                reloadGrid();
            } else {
                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                self.setDisabled(false);
            }

        }, 'JSON');
    }
}

$(document).ready(function () {
    /**
     * 定义按钮
     */
    var items = [
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
                name: 'add',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    //弹出弹出框
                    initWindow_unitinfo({
                        title: '新增日志信息',
                    });
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'edit',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据 获取选中数据
                    var currentRecord = DSYGrid.getGrid('unitGrid').getCurrentRecord();
                    if (currentRecord == null) {
                        Ext.MessageBox.alert('提示', '请选择至少一条日志再进行操作');
                        return;
                    }
                    //弹出弹出框
                    initWindow_unitinfo({
                        title: '修改日志信息',
                        record: currentRecord
                    });
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'delete',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    //获取表格中数据
                    var records = DSYGrid.getGrid('unitGrid').getSelection();
                    //检验是否远中
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条日志记录！');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            var arr = [];
                            Ext.Array.forEach(records, function (record) {
                                arr.push(record.get("WORK_ID"))
                            });
                            $.post("/wzgl_nx/jcsjgl/deleteRzData.action", {
                                ids: arr
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: "删除成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                } else {
                                    Ext.MessageBox.alert('提示', '删除失败！' + data.message);
                                }
                                //刷新表格
                                reloadGrid();
                            }, "json");
                        }
                    });
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    ;
    /**
     * 定义菜单
     */
    Ext.create('Ext.panel.Panel', {
        renderTo: Ext.getBody(),
        height: '100%',
        width: '100%',
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        border: false,
        tbar: items,
        items: [
            initContentRightPanel()//初始化表格
        ]
    });
});