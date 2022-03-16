var store_zc_type = DebtEleStoreDB("DEBT_WZZCLX");

/**
 * 刷新表格
 */
function reloadGrid() {
    var store = DSYGrid.getGrid('unitGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#SEARCH')[0].getValue();

    store.getProxy().extraParams["mhcx"] = mhcx;
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
        {dataIndex: "TKXE_ID", type: "string", text: "", hidden: true},
        {dataIndex: "AD_NAME", type: "string", text: "地区", width: 200},
        {dataIndex: "ZCLX_NAME", type: "string", text: "支出类型", width: 200},
        {dataIndex: "SET_YEAR", type: "string", text: "年度", width: 200},
        {
            dataIndex: "XE_RMB", type: "string", text: "限额（万元）", width: 200,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {dataIndex: "REMARK", type: "string", text: "备注", width: 300},
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
        dataUrl: '/wzgl_nx/jcsjgl/getXeInfoGrid.action',
        height: '100%',
        flex: 1,
        tbar: [{
            fieldLabel: '模糊查询',
            xtype: "textfield",
            itemId: "SEARCH",
            width: 350,
            labelWidth: 80,
            emptyText: '请输入地区...',
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
            {name: 'TKXE_ID', hidden: true},
            {                fieldLabel: '<span class="required">✶</span>地区',                name: 'AD_NAME',                allowBlank: false            },
            {
                fieldLabel: '<span class="required">✶</span>支出类型',
                name: 'ZCLX_ID',
                xtype: 'combobox',
                editable: false,
                valueField: 'id',
                displayField: 'name',//仅显示的文本字段id对应的name值
                store: store_zc_type,
                allowBlank: false,
            },
            {fieldLabel: '<span class="required">✶</span>年度', xtype: 'numberfield', name: 'SET_YEAR', hideTrigger: true},
            {
                fieldLabel: '<span class="required">✶</span>限额（万元）',
                name: 'XE_RMB',
                xtype: "numberFieldFormat",
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {fieldLabel: '备注', name: 'REMARK'}
        ]
    });
    if (!!config.record) {
        var xeForm = config.record.data;
        form.getForm().setValues(xeForm);
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
        if (formData.TKXE_ID != "") {
            url = '/wzgl_nx/jcsjgl/updateXeData.action'
        } else if (formData.hasOwnProperty("TKXE_ID")) {
            url = '/wzgl_nx/jcsjgl/addXeData.action'
        }
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
    ;
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
                        title: '新增提款限额维护',
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
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作!');
                        return;
                    }
                    //弹出弹出框
                    initWindow_unitinfo({
                        title: '修改提款限额维护',
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
                        Ext.MessageBox.alert('提示', '请至少选择一条数据记录！');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            var arr = [];
                            Ext.Array.forEach(records, function (record) {
                                arr.push(record.get("TKXE_ID"))
                            });
                            $.post("/wzgl_nx/jcsjgl/deleteXeData.action", {
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