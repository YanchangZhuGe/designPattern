/**
 * 页面初始化
 */
$(document).ready(function () {
    initContent();
});
var store_zc_type = null;
store_zc_type = DebtEleStoreDB("DEBT_WZZCLX");

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
                //发送ajax查询主表与明细表数据
                btn.setDisabled(true);
                $.ajax({
                        type: "POST",
                        url: "/wzgl_nx/tkgl/getTkmxMx.action",
                        data: {
                            ID: record.get('TKBZ_ID')
                        },
                        dataType: 'json'
                    }
                )
                    .done(function (result) {
                        btn.setDisabled(false);
                        if (!result.success) {
                            Ext.MessageBox.alert('提示', '明细数据查询失败！' + (!result.message ? '' : result.message));
                            return false;
                        }
                        //请求成功时处理
                        initWin_tk_edit({tkmx_data: result.list, tk_data: record.getData()}).show();
                    })
                    .fail(function (result) {
                        Ext.MessageBox.alert('提示', '明细数据查询失败！' + (!result.message ? '' : result.message));
                        self.setDisabled(false);
                    });
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
                    ids.push(record.get('TKBZ_ID'));
                }
                Ext.Msg.confirm('提示', '是否确认删除数据？', function (btn) {
                    if (btn == 'yes') {
                        //发送删除请求
                        $.ajax({
                                type: "POST",
                                url: '/wzgl_nx/tkgl/delTkmx.action',
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
            {
                xtype: 'panel',
                region: 'center',
                width: '100%',
                height: '100%',
                flex: 1,
                layout: 'vbox',
                defaults: {
                    width: '100%',
                    flex: 1
                },
                items: [
                    initContentGrid(),
                    initContentMxGrid()
                ]
            }
        ]
    });
}

/**
 * 初始化主表格
 */
function initContentGrid() {
    var headerJson = [
        // 项目地区	外债编码	项目名称	项目类别	债权国	执行单位	债务单位	贷款利率	偿还方式	执行情况
        {xtype: 'rownumberer', width: 45},
        {text: "主单ID", dataIndex: "TKBZ_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
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
        {text: "提款次数", dataIndex: "TKBZ_CODE", type: "string"},
        {text: "项目类别", dataIndex: "XMLB_NAME", type: "string"},
        {text: "债权国", dataIndex: "ZQR_NAME", type: "string", width: 150},
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
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: "/wzgl_nx/tkgl/getTkmx.action",
        checkBox: true,
        // selModel:{mode: "SINGLE"},//单选
        enableLocking: false,
        border: false,
        autoLoad: true,
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
        ],
        listeners: {
            itemclick: function (self, record) {
                DSYGrid.getGrid('contentDetilGrid').getStore().getProxy().extraParams['ID'] = record.get('TKBZ_ID');
                DSYGrid.getGrid('contentDetilGrid').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化主表格
 */
function initContentMxGrid() {
    //表头
    var headerJson = [
        {
            xtype: 'rownumberer', width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "提款明细ID", dataIndex: "TKMX_ID", type: "string", hidden: true},
        {text: "项目区", dataIndex: "AG_NAME", type: "string", width: 200},
        {text: "类别内容", dataIndex: "LBNR", type: "string", hidden: true},
        {text: "类别内容", dataIndex: "LBNR_NAME", type: "string", width: 200},
        {
            text: "发票金额(万元)", dataIndex: "FP_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "支付比例", dataIndex: "ZF_RATE", type: "float", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {
            text: "申请金额(万元)", dataIndex: "SQ_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "项目办批准金额(万元)", dataIndex: "PZ_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {text: "上述款项申请汇至", dataIndex: "ZH_ADDR", type: "string", width: 300},
        {text: "户名", dataIndex: "ZH_NAME", type: "string", width: 150},
        {text: "开户行", dataIndex: "ZH_BANK", type: "string", width: 200},
        {text: "账号", dataIndex: "ACCOUNT", type: "string", width: 200},
        {text: "附言", dataIndex: "REMARK", type: "string", width: 300}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentDetilGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        region: 'center',
        dataUrl: "/wzgl_nx/tkgl/getTkmxMx.action",
        checkBox: true,
        // selModel:{mode: "SINGLE"},//单选
        enableLocking: false,
        border: false,
        autoLoad: false,
        features: [{ftype: 'summary'}],
        pageConfig: {
            enablePage: false
        }
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
                    btn.setDisabled(true);
                    //发送ajax请求最大的提款次数
                    $.ajax({
                            type: "POST",
                            url: "/wzgl_nx/tkgl/getTkmxNum.action",
                            data: {ID: record.get('WZXY_ID')},
                            dataType: 'json'
                        }
                    )
                        .done(function (result) {
                            if (!result.success) {
                                Ext.MessageBox.alert('提示', '获取提款次数失败！' + (!result.message ? '' : result.message));
                                btn.setDisabled(false);
                                return false;
                            }
                            btn.up('window').close();
                            //配置数据
                            var TK_CODE = parseInt(result.data) + 1;
                            var config = $.extend(true, {tk_data: {TKBZ_CODE: TK_CODE}}, {tk_data: record.data});
                            //弹出提款明细编辑窗口
                            initWin_tk_edit(config).show();
                        })
                        .fail(function (result) {
                            Ext.MessageBox.alert('提示', '获取提款次数失败！' + (!result.message ? '' : result.message));
                            btn.setDisabled(false);
                        });
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
                            store.getProxy().extraParams.mhcx = mhcx;
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
            labelWidth: 120//控件默认标签宽度
        },
        border: false,
        items: [
            {fieldLabel: '外债协议ID', name: "WZXY_ID", hidden: true},
            {fieldLabel: '提款ID', name: "TKBZ_ID", hidden: true},
            {fieldLabel: '提款次数', name: "TKBZ_CODE", xtype: "numberFieldFormat", editable: false, fieldCls: 'form-unedit-number', hideTrigger: true},
            {fieldLabel: '外债编码', name: "WZXY_CODE", editable: false, columnWidth: .66, fieldCls: 'form-unedit'},
            {fieldLabel: '项目名称', name: "WZXY_NAME", xtype: 'displayfield', columnWidth: .99}
        ]
    });
    //显示选择的项目数据
    if (!!config.tk_data) {
        form.getForm().setValues(config.tk_data);
        if (!isNull(config.tk_data.WZXY_NAME)) {
            var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
            var paramNames = ["WZXY_ID"];
            var paramValues = [encodeURIComponent(config.tk_data.WZXY_ID)];
            var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + config.tk_data.WZXY_NAME + '</a>';
            form.down('[name=WZXY_NAME]').setValue(result);
        }
    }
    return form;
}

/**
 * 初始化选择协议列表
 */
function initWin_tk_edit_grid(config) {//表头
    var store_zjzh = Ext.create('Ext.data.Store', {
        fields: ['ZJZH_ID', 'ZH_TYPE', 'ZH_NAME', 'ACCOUNT', 'ZH_BANK'],
        proxy: {
            type: 'ajax',
            url: "/wzgl_nx/jcsjgl/getZjzhList.action",
            method: "POST",
            params: {},
            reader: {
                type: 'json',
                rootProperty: 'data'
            }
        },
        autoLoad: true
    });
    var headerJson = [
        {
            xtype: 'rownumberer', width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "提款ID", dataIndex: "TKBZ_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "项目区", dataIndex: "AG_NAME", type: "string", cellWrap: true, width: 300, tdCls: 'grid-cell', editor: 'textfield'},
        {
            text: "类别内容", dataIndex: "LBNR", type: "string", cellWrap: true, width: 200, tdCls: 'grid-cell',
            editor: {//   动态获取(下拉框)
                xtype: 'combobox',
                displayField: 'name',//显示在下拉框中的值，就是下拉框时，看到下拉框中的文本
                valueField: 'id',//下拉框的值，即在后台得到的值
                editable: false,
                store: store_zc_type
            },
            renderer: function (value) {
                var record = store_zc_type.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            text: "发票金额", dataIndex: "FP_AMT", type: "float", width: 180, tdCls: 'grid-cell',
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
            text: "支付比例(%)", dataIndex: "ZF_RATE", type: "float", width: 180, tdCls: 'grid-cell',
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {
            text: "申请金额", dataIndex: "SQ_AMT", type: "float", width: 180, tdCls: 'grid-cell',
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
            text: "项目办批准金额", dataIndex: "PZ_AMT", type: "float", width: 180, tdCls: 'grid-cell',
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {text: "资金账户ID", dataIndex: "ZH_ID", type: "string", hidden: true},
        {text: "上述款项申请汇至", dataIndex: "ZH_ADDR", type: "string", width: 300, tdCls: 'grid-cell', editor: 'textfield'},
        {
            text: "户名", dataIndex: "ZH_NAME", type: "string", width: 200, tdCls: 'grid-cell',
            editor: {xtype: 'combobox', displayField: 'ZH_NAME', valueField: 'ZJZH_ID', store: store_zjzh},
        },
        {text: "开户行", dataIndex: "ZH_BANK", type: "string", width: 300, tdCls: 'grid-cell', editor: 'textfield'},
        {text: "账号", dataIndex: "ACCOUNT", type: "string", width: 200, tdCls: 'grid-cell', editor: 'textfield'},
        {text: "附言", dataIndex: "REMARK", type: "string", width: 300, tdCls: 'grid-cell', editor: 'textfield'}
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
                var data = {
                    //TK_ID,WZXY_ID,TK_DATE,TK_AMT,TK_RMB_AMT,HB_AMT,WHB_AMT,DZ_DATE,REMARK
                    WZXY_ID: formData.WZXY_ID,
                    TK_DATE: format(new Date(), 'yyyy-MM-dd')
                };
                var grid = DSYGrid.getGrid('win_tk_edit_grid');
                var record = grid.getCurrentRecord();
                var index = grid.getStore().getCount();
                //复制选中行的项目区与收款账号
                if (!!record) {
                    index = record.recordIndex + 1;
                    data.AG_NAME = record.data.AG_NAME;
                    data.ZH_ID = record.data.ZH_ID;
                    data.ZH_ADDR = record.data.ZH_ADDR;
                    data.ZH_NAME = record.data.ZH_NAME;
                    data.ZH_BANK = record.data.ZH_BANK;
                    data.ACCOUNT = record.data.ACCOUNT;
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
                var records = sm.getSelection();
                //获取删除数据记录的ID
                if (!grid.delete_records) {
                    grid.delete_records = [];
                }
                for (var i = 0; i < records.length; i++) {
                    var id = records[i].get('TKBZ_ID');
                    if (typeof id != 'undefined' && id != null && id.length > 0) {
                        grid.delete_records.push(id);
                    }
                }
                //删除记录
                store.remove(records);
                //默认选中第一条
                if (store.getCount() > 0) {
                    sm.select(0);
                }
            }
        },
        '->',
        {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color"}
    ];
    //如果有提款主单id，说明是修改状态，不显示增行删行按钮
    if (!!config.tk_data && !!config.tk_data.TKBZ_ID) {
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
        data: !!config.tkmx_data ? config.tkmx_data : [],
        checkBox: true,   //显示复选框
        border: true,
        pageConfig: {
            enablePage: false
        },
        flex: 1,
        width: '100%',
        features: [{ftype: 'summary'}],
        plugins: [{ptype: 'cellediting', clicksToEdit: 1, pluginId: 'cellEdit', clicksToMoveEditor: 1}],
        tbar: tbar,
        listeners: {
            'edit': function (editor, context) {
                //账户下拉框选择数据后
                if (context.field === 'ZH_NAME') {
                    var record = store_zjzh.findRecord('ZJZH_ID', context.value);
                    if (record != null) {
                        context.record.set("ZH_NAME", record.get('ZH_NAME'));
                        context.record.set("ACCOUNT", record.get('ACCOUNT'));
                        context.record.set("ZH_BANK", record.get('ZH_BANK'));
                        context.record.set("ZH_ID", record.get('ZJZH_ID'));
                    }
                }
            },
        }
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
    //明细表格数据删除
    DSYGrid.getGrid('contentDetilGrid').getStore().removeAll();
}

/**
 * 保存提款信息
 */
function saveTkInfo(self) {
    //获取表单数据
    var form = Ext.ComponentQuery.query('form#win_tk_edit_form');
    if (!form || form.length <= 0) {
        Ext.MessageBox.alert('提示', '保存失败！无法获取主单数据');
        return false;
    }
    form = form[0];
    var formData = form.getForm().getFieldValues();
    formData = $.extend({}, formData, form.getValues());
    //获取明细新增/修改数据
    var grid = DSYGrid.getGrid('win_tk_edit_grid');
    var store = grid.getStore();

    //校验数据-表单
    var message = '';
    if (!form.isValid() || !formData) {
        message += '表单校验不通过！\n';
    }
    if (isNull(formData.WZXY_ID)) {
        message += '表单未关联到外债协议！\n';
    }
    //校验数据-表格
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        if (isNull(record.get('LBNR'))) {
            message += '第' + (i + 1) + '行,类别内容不能为空！\n';
        }
        if (isNull(record.get('FP_AMT'))) {
            message += '第' + (i + 1) + '行,发票金额不能为空！\n';
        }
        if (isNull(record.get('SQ_AMT'))) {
            message += '第' + (i + 1) + '行,申请金额不能为空！\n';
        }
        if (isNull(record.get('PZ_AMT'))) {
            message += '第' + (i + 1) + '行,批准金额不能为空！\n';
        }
    }
    if (!isNull(message)) {
        Ext.MessageBox.alert('提示', '保存失败！' + message);
        return false;
    }

    //表单外债协议名称删除，防止参数值校验不通过
    if (!isNull(formData.WZXY_NAME)) {
        delete formData.WZXY_NAME;
    }
    //处理数据
    var records_add = [];
    var records_update = [];
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        if (isNull(record.get('TKBZ_ID'))) {
            records_add.push(record.data);
        } else {
            records_update.push(record.data);
        }
    }

    /*var records_add = store.getNewRecords();//新增行
    var records_update = store.getUpdatedRecords();//修改行
    for (var i = 0; i < records_add.length; i++) {
        records_add[i] = records_add[i].data;
    }
    for (var i = 0; i < records_update.length; i++) {
        records_update[i] = records_update[i].data;
    }*/
    //判断当前操作为新增/修改
    self.setDisabled(true);
    //发送ajax请求新增/更新数据
    $.ajax({
            type: "POST",
            url: "/wzgl_nx/tkgl/editTkmx.action",
            data: {
                form_data: JSON.stringify(formData),
                list_add: JSON.stringify(records_add),
                list_update: JSON.stringify(records_update),
                list_del: grid.delete_records
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
            grid.delete_records = [];
            self.up('window').close();
            // 刷新表格
            reloadGrid();
        })
        .fail(function (result) {
            Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
            self.setDisabled(false);
        });
}