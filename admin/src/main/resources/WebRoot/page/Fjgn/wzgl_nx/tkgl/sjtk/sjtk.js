/**
 * 页面初始化
 */
$(document).ready(function () {
    initContent();
});

/**
 * 初始化页面主要内容区域
 */
function initContent() {
    //顶部工具栏
    var tools = [
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                reloadGrid();
            }
        },
        {
            xtype: 'button',
            text: '录入',
            itemId: 'add',
            name: 'add',
            icon: '/image/sysbutton/add.png',
            handler: function (btn) {
                initWin_xy().show();
            }
        },
        {
            xtype: 'button',
            text: '修改',
            itemId: 'edit',
            name: 'edit',
            icon: '/image/sysbutton/edit.png',
            handler: function (btn) {
                var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                if (!record) {
                    Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                    return false;
                }
                var config = $.extend(true, {}, {tk_data: record.getData(), xy_data: record.getData()});
                initWin_tk_edit(config).show();
            }
        },
        {
            xtype: 'button',
            text: '删除',
            itemId: 'delete',
            name: 'delete',
            icon: '/image/sysbutton/delete.png',
            handler: function (btn) {
                var records = DSYGrid.getGrid('contentGrid').getSelection();
                if (records.length <= 0) {
                    Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                    return false;
                }

                var ids = [];
                for (var i = 0; i < records.length; i++) {
                    var record = records[i];
                    ids.push(record.get('TK_ID'));
                }
                Ext.Msg.confirm('提示', '是否确认删除数据？', function (btn) {
                    if (btn == 'yes') {
                        //发送删除请求
                        $.ajax({
                                type: "POST",
                                url: '/wzgl_nx/tkgl/delSjtk.action',
                                data: {
                                    ids: ids
                                },
                                dataType: 'json'
                            }
                        )
                            .done(function (result) {
                                if (!result.success) {
                                    Ext.MessageBox.alert('提示', '删除失败！' + (!result.message ? '' : result.message));
                                    return false;
                                }
                                //请求成功时处理
                                Ext.toast({
                                    html: '保存成功！',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                // 刷新表格
                                reloadGrid();
                            })
                            .fail(function (result) {
                                Ext.MessageBox.alert('提示', '删除失败！' + (!result.message ? '' : result.message));
                                // 刷新表格
                                reloadGrid();
                            });
                        reloadGrid();
                    }
                });
            }
        },
        '->',
        initButton_OftenUsed(),
        initButton_Screen()
    ];
    //创建主面板
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        width: '100%',
        height: '100%',
        // renderTo: Ext.getBody(),
        renderTo: 'unitManage',
        border: false,
        tbar: tools,
        items: [
            initContentGrid()
        ]
    });
}

/**
 * 初始化主表格
 */
function initContentGrid() {
    //表头
    var headerJson = [
        {xtype: 'rownumberer', width: 50},
        {text: "提款ID", dataIndex: "TK_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "单位", dataIndex: "AG_NAME", type: "string", width: 250},
        {
            text: "项目名称", dataIndex: "WZXY_NAME", type: "string", cellWrap: true, width: 300,
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = ["WZXY_ID"];
                    var paramValues = [encodeURIComponent(record.get('WZXY_ID'))];
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {text: "提款日期", dataIndex: "TK_DATE", type: "string", width: 150},
        {text: "序号", dataIndex: "TK_CODE", type: "string", width: 180},
        {
            text: "申请金额", dataIndex: "SQBF_DATE", type: "string",
            columns: [
                {
                    text: "原币(万元)", dataIndex: "TK_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    text: "人民币(万元)", dataIndex: "TK_RMB_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            text: "回补金额(原币)(万元)", dataIndex: "HB_AMT", type: "float", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "未回补金额(原币)(万元)", dataIndex: "WHB_AMT", type: "float", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {text: "拨付到账日期", dataIndex: "DZ_DATE", type: "string", width: 150},
        {text: "备注", dataIndex: "REMARK", type: "string", width: 300}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        region: 'center',
        dataUrl: "/wzgl_nx/tkgl/getSjtk.action",
        checkBox: true,
        // selModel:{mode: "SINGLE"},//单选
        enableLocking: false,
        border: false,
        autoLoad: true,
        width: '100%',
        height: '100%',
        flex: 1,
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "mhcx",
                width: 250,
                labelWidth: 100,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
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
    });
}

/**
 * 创建选择协议信息窗口
 */
function initWin_xy() {
    return Ext.create('Ext.window.Window', {
        title: '项目选择',
        itemId: 'win_xy',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 添加
        // frame: true,
        // constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'fit',
        // closeAction: 'destroy',
        items: [initWin_xy_grid()],
        buttons: [
            {
                text: '确认',
                name: 'btn_confirm',
                handler: function (btn) {
                    var record = DSYGrid.getGrid('win_xy_grid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                        return false;
                    }
                    btn.up('window').close();
                    var config = $.extend(true, {}, {xy_data: record.data});
                    initWin_tk_edit(config).show();
                    //弹出上级提款编辑窗口
                }
            },
            {
                text: '关闭',
                name: 'btn_delete',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

/**
 * 初始化选择协议列表
 */
function initWin_xy_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "项目地区", dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: "项目地区", dataIndex: "XY_AG_NAME", type: "string", width: 150},
        {text: "外债编码", dataIndex: "WZXY_CODE", type: "string", width: 150},
        {
            text: "项目名称",
            dataIndex: "WZXY_NAME",
            type: "string",
            width: 300,
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = ["WZXY_ID"];
                    var paramValues = [encodeURIComponent(record.get('WZXY_ID'))];
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {text: "项目类别", dataIndex: "XMLB_NAME", type: "string", width: 180},
        {text: "债权国", dataIndex: "ZQR_NAME", type: "string", width: 180},
        {text: "执行单位", dataIndex: "ZXDW", type: "string", width: 150},
        {text: "债务单位", dataIndex: "ZWDW", type: "string", width: 150},
        {
            text: "贷款利率", dataIndex: "LX_RATE", type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {text: "偿还方式", dataIndex: "CHFS_NAME", type: "string"},
        {text: "执行情况", dataIndex: "ZXQK_NAME", type: "string"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'win_xy_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: "/wzgl_nx/xygl/getXmInfoGrid.action",
        checkBox: true,   //显示复选框
        border: false,
        selModel: {
            mode: "SINGLE"     //是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        flex: 1,
        height: '100%',
        width: '100%',
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "mhcx_xy",
                width: 250,
                labelWidth: 100,
                labelAlign: 'right',
                emptyText: '请输入外债名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            var grid = DSYGrid.getGrid('win_xy_grid');
                            var store = grid.getStore();
                            var mhcx = Ext.ComponentQuery.query('textfield#mhcx_xy')[0].getValue();
                            store.getProxy().extraParams = {
                                mhcx: mhcx
                            };
                            //刷新
                            store.loadPage(1);
                        }
                    }
                }
            }
        ]
    });
    return grid;
}

/**
 * 创建选择协议信息窗口
 */
function initWin_tk_edit(config) {
    return Ext.create('Ext.window.Window', {
        title: '提款填报',
        itemId: 'win_tk_xy',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 添加
        // frame: true,
        // constrain: true,//防止超出浏览器边界
        buttonAlign: "right",// 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        layout: 'vbox',
        defaults: {
            width: '100%'
        },
        // closeAction: 'destroy',
        items: [
            initWin_tk_edit_form(config),
            initWin_tk_edit_grid(config)
        ],
        buttons: [
            {
                text: '保存',
                name: 'btn_confirm',
                handler: function (btn) {
                    saveTkInfo(btn);
                    //弹出上级提款编辑窗口
                }
            },
            {
                text: '关闭',
                name: 'btn_delete',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

/**
 * 初始化提款编辑弹框
 */
function initWin_tk_edit_form(config) {
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'win_tk_edit_form',
        width: '100%',
        layout: 'column',
        fileUpload: true,
        defaultType: 'textfield',
        defaults: {
            margin: '2 5 4 5',
            columnWidth: .33,
            labelWidth: 80//控件默认标签宽度
        },
        border: false,
        items: [
            {fieldLabel: '外债协议ID', name: "WZXY_ID", hidden: true},
            {fieldLabel: '提款ID', name: "TK_ID", hidden: true},
            // {fieldLabel: '提款次数', name: "TK_NUM", xtype: "numberFieldFormat", editable: false, fieldCls: 'form-unedit-number', hideTrigger: true},
            {fieldLabel: '外债编码', name: "WZXY_CODE", editable: false, fieldCls: 'form-unedit'},
            {fieldLabel: '项目名称', name: "WZXY_NAME", xtype: 'displayfield', columnWidth: .66}
        ]
    });
    //显示选择的项目数据
    if (!!config.xy_data) {
        form.getForm().setValues(config.xy_data);
        if (!isNull(config.xy_data.WZXY_NAME)) {
            var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
            var paramNames = ["WZXY_ID"];
            var paramValues = [encodeURIComponent(config.xy_data.WZXY_ID)];
            var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + config.xy_data.WZXY_NAME + '</a>';
            form.down('[name=WZXY_NAME]').setValue(result);
        }
    }
    return form;
}

/**
 * 初始化选择协议列表
 */
function initWin_tk_edit_grid(config) {//表头
    var headerJson = [
        {
            xtype: 'rownumberer', width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "提款ID", dataIndex: "TK_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "单位", dataIndex: "AG_NAME", type: "string", width: 250, editor: 'textfield'},
        {
            text: "提款日期", dataIndex: "TK_DATE", type: "string", width: 180,
            editor: {xtype: 'datefield', format: 'Y-m-d', value: today, editable: false},
            renderer: function (value, metaData, record) {
                var newValue = dsyDateFormat(value);
                record.data.TK_DATE = newValue;
                return newValue;
            }
        },
        {text: "序号", dataIndex: "TK_CODE", type: "string", editor: 'textfield', width: 180},
        {
            text: "申请金额", dataIndex: "SQBF_DATE", type: "string",
            columns: [
                {
                    text: "原币", dataIndex: "TK_AMT", type: "float", width: 180,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    text: "人民币", dataIndex: "TK_RMB_AMT", type: "float", width: 180,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            text: "回补金额(原币)", dataIndex: "HB_AMT", type: "float", width: 180,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "未回补金额(原币)", dataIndex: "WHB_AMT", type: "float", width: 180,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "拨付到账日期", dataIndex: "DZ_DATE", type: "string", width: 180,
            editor: {xtype: 'datefield', format: 'Y-m-d', editable: false},
            renderer: function (value, metaData, record) {
                var newValue = dsyDateFormat(value);
                record.data.DZ_DATE = newValue;
                return newValue;
            }
        },
        {text: "备注", dataIndex: "REMARK", type: "string", cellWrap: true, width: 300, editor: 'textfield'}
    ];
    var tbar = [
        {
            xtype: 'button',
            text: '增行',
            name: 'INPUT',
            icon: '/image/sysbutton/add.png',
            width: 70,
            handler: function (btn) {
                var form = btn.up('window').down('form');
                var formData = form.getForm().getFieldValues();
                formData = $.extend({}, formData, form.getValues());
                var currentDate = format(new Date(), 'yyyy-MM-dd');
                var data = {
                    WZXY_ID: formData.WZXY_ID,
                    TK_DATE: currentDate
                };
                var grid = DSYGrid.getGrid('win_tk_edit_grid');
                var record = grid.getCurrentRecord();
                var index = grid.getStore().getCount();
                if (!!record) {
                    index = record.recordIndex + 1;
                }
                grid.insertData(index, data);
            }
        },
        {
            xtype: 'button',
            text: '删行',
            name: 'DELETE',
            icon: '/image/sysbutton/delete.png',
            width: 70,
            handler: function () {
                var grid = DSYGrid.getGrid('win_tk_edit_grid');
                var store = grid.getStore();
                var sm = grid.getSelectionModel();
                store.remove(sm.getSelection());
                if (store.getCount() > 0) {
                    sm.select(0);
                }
            }
        },
        '->',
        {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color"}
    ];
    //如果有提款id，说明是修改状态，不显示增行删行按钮
    if (!!config.tk_data && !!config.tk_data.TK_ID) {
        tbar = [
            '->',
            {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color"}
        ];
    }
    var grid = DSYGrid.createGrid({
        itemId: 'win_tk_edit_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [config.tk_data],
        checkBox: true,   //显示复选框
        border: true,
        pageConfig: {
            enablePage: false
        },
        flex: 1,
        width: '100%',
        features: [{ftype: 'summary'}],
        plugins: [
            {ptype: 'cellediting', clicksToEdit: 1, pluginId: 'cellEdit', clicksToMoveEditor: 1}
        ],
        tbar: tbar
    });
    return grid;
}

/**
 * 刷新界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#mhcx')[0].getValue();
    store.getProxy().extraParams = {
        mhcx: mhcx
    };
    //刷新
    store.loadPage(1);
}

/**
 * 保存提款信息
 */
function saveTkInfo(self) {
    //获取新增/修改数据
    var store = DSYGrid.getGrid('win_tk_edit_grid').getStore();
    var data_sjtk = [];
    //数据校验
    var message = '';
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        if (isNull(record.get('TK_DATE'))) {
            message += '第' + (i + 1) + '行，提款日期不能为空！\n';
        }
        data_sjtk.push(record.getData());
    }
    if (!isNull(message)) {
        Ext.MessageBox.alert('提示', '保存失败！' + message);
        return false;
    }
    //判断当前操作为新增/修改
    var url = "/wzgl_nx/tkgl/addSjtk.action";
    if (data_sjtk.length === 1 && !isNull(data_sjtk[0].TK_ID)) {
        url = "/wzgl_nx/tkgl/editSjtk.action";
    }
    self.setDisabled(true);
    //发送ajax请求新增/更新数据
    $.ajax({
            type: "POST",
            url: url,
            data: {
                data: JSON.stringify(data_sjtk)
            },
            dataType: 'json'
        }
    )
        .done(function (result) {
            self.setDisabled(false);
            if (!result.success) {
                Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
                return false;
            }
            //请求成功时处理
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            self.up('window').close();
            // 刷新表格
            reloadGrid();
        })
        .fail(function (result) {
            Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
            self.setDisabled(false);
        });
}