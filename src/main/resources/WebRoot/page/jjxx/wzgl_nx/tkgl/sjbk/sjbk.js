//存储选择提款主单后的提款明细列表
var store_tkmx = Ext.create('Ext.data.Store', {
    fields: ["TKMX_ID", "TKBZ_ID", "WZXY_ID", "AG_NAME", "LBNR", "LBNR_NAME", "FP_AMT", "ZF_RATE", "SQ_AMT", "PZ_AMT", "ZH_NAME", "ACCOUNT", "ZH_BANK", "ZH_ADDR", "REMARK"],
    remoteSort: true,// 后端进行排序
    proxy: {
        type: 'ajax',
        url: "/wzgl_nx/tkgl/getSjbkTkMx.action",
        method: "POST",
        extraParams: {},
        reader: {
            type: "json",
            root: "list",
            totalProperty: "totalcount"
        },
        actionMethods: {
            read: 'POST' // Store设置请求的方法，与Ajax请求有区别
        },
        timeout: 600000,
        simpleSortMode: true
    },
    autoLoad: false
});
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
                initWin_tk().show();
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
                //刷新下拉框选择提款明细
                store_tkmx.getProxy().extraParams.ID = record.get('TKBZ_ID');
                store_tkmx.reload();
                //发送ajax查询主表与明细表数据
                btn.setDisabled(true);
                $.ajax({
                        type: "POST",
                        url: "/wzgl_nx/tkgl/getSjbkMx.action",
                        data: {
                            ID: record.get('BKD_ID')
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
                        initWin_bk_edit({tkmx_data: result.list, tk_data: record.getData()}).show();
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
                    ids.push(record.get('BKD_ID'));
                }
                Ext.Msg.confirm('提示', '是否确认删除数据？', function (btn) {
                    if (btn == 'yes') {
                        //发送删除请求
                        $.ajax({
                                type: "POST",
                                url: '/wzgl_nx/tkgl/delSjbk.action',
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
        {text: "主单ID", dataIndex: "BKD_ID", type: "string", hidden: true},
        {text: "提款主单ID", dataIndex: "TKBZ_ID", type: "string", hidden: true},
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
        dataUrl: "/wzgl_nx/tkgl/getSjbk.action",
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
                DSYGrid.getGrid('contentDetilGrid').getStore().getProxy().extraParams['ID'] = record.get('BKD_ID');
                DSYGrid.getGrid('contentDetilGrid').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化主表格
 */
function initContentMxGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 50, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "主键ID", dataIndex: "TKDJMX_ID", type: "string", hidden: true},
        {text: "虚拟拨款主单ID", dataIndex: "BKD_ID", type: "string", hidden: true},
        {text: "对应提款主单ID", dataIndex: "XMTK_ID", type: "string", hidden: true},
        {text: "对应提款明细单ID", dataIndex: "TKMX_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
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
            text: "支付比例", dataIndex: "ZF_RATE", type: "float",
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
        {text: "拨款日期", dataIndex: "BF_DATE", type: "string", width: 150},
        {
            text: "核定金额人民币(万元)", dataIndex: "HD_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "美元汇率", dataIndex: "MY_HL", type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "原币汇率", dataIndex: "BF_HL", type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            header: "支付金额", columns: [
                {
                    text: "原币(万元)", dataIndex: "BF_YB_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    text: "美元(万元)", dataIndex: "BF_MY_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    text: "人民币(万元)", dataIndex: "BF_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
            ]
        },
        {text: "上述款项申请汇至", dataIndex: "ZH_NAME", type: "string", width: 300},
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
        dataUrl: "/wzgl_nx/tkgl/getSjbkMx.action",
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
 * 创建选择提款主单信息窗口
 */
function initWin_tk() {
    return Ext.create('Ext.window.Window', {
        title: '选择提款单',
        itemId: 'win_tk',
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
        items: [initWin_tk_grid()],
        buttons: [
            {
                text: '确认',
                name: 'btn_confirm',
                handler: function (btn) {
                    var record = DSYGrid.getGrid('win_tk_grid').getCurrentRecord();
                    if (!record) {
                        Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                        return false;
                    }
                    btn.setDisabled(true);
                    //配置数据
                    /*var config = $.extend(true, {}, {
                        tk_data: record.data
                    });*/
                    //配置数据
                    var config = $.extend(true, {}, {
                        tk_data: record.data,
                        // tkmx_data: result.list
                    });
                    //弹出提款明细编辑窗口
                    initWin_bk_edit(config).show();
                    btn.up('window').close();
                    //查询提款明细数据
                    store_tkmx.getProxy().extraParams.ID = record.get('TKBZ_ID');
                    store_tkmx.reload();
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
 * 初始化选择提款主单列表
 */
function initWin_tk_grid() {
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
        {text: "提款次数", dataIndex: "TKBZ_CODE", type: "string", width: 180},
        {text: "项目类别", dataIndex: "XMLB_NAME", type: "string", width: 180},
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
    var grid = DSYGrid.createGrid({
        itemId: 'win_tk_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: "/wzgl_nx/tkgl/getSjbkTk.action",
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
                            var grid = DSYGrid.getGrid('win_tk_grid');
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
function initWin_bk_edit(config) {
    return Ext.create('Ext.window.Window', {
        title: '拨款填报',
        itemId: 'win_bk',
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
            initWin_bk_edit_form(config),
            initWin_bk_edit_grid(config)
        ],
        buttons: [
            {
                text: '保存',
                name: 'btn_confirm',
                handler: function (btn) {
                    saveBkInfo(btn);
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
function initWin_bk_edit_form(config) {
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'win_bk_edit_form',
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
            {fieldLabel: '虚拟主单ID', name: "BKD_ID", hidden: true},
            {fieldLabel: '外债协议ID', name: "WZXY_ID", hidden: true},
            {fieldLabel: '提款主单ID', name: "TKBZ_ID", hidden: true},
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
function initWin_bk_edit_grid(config) {//表头
    var headerJson = [
        {
            xtype: 'rownumberer', width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "拨款明细ID", dataIndex: "TKDJMX_ID", type: "string", hidden: true},
        {text: "虚拟拨款单ID", dataIndex: "BKD_ID", type: "string", hidden: true},
        {text: "外债协议ID", dataIndex: "WZXY_ID", type: "string", hidden: true},
        {text: "提款主单ID", dataIndex: "TKBZ_ID", type: "string", hidden: true},
        {text: "提款明细ID", dataIndex: "TKMX_ID", type: "string", hidden: true},
        {
            text: "项目区", dataIndex: "AG_NAME", type: "string", cellWrap: true, width: 300,
            editor: {
                xtype: "gridcombobox",
                valueField: 'TKMX_ID',
                displayField: 'AG_NAME',
                editable: false, //禁用编辑
                columns: [
                    {text: "提款明细ID", dataIndex: "TKMX_ID", type: "string", hidden: true},
                    {text: "提款明细显示值", dataIndex: "XM_NAME", type: "string", hidden: true},
                    {text: "项目区", dataIndex: "AG_NAME", type: "string", width: 200},
                    {text: "类别内容", dataIndex: "LBNR", type: "string", hidden: true},
                    {text: "类别内容", dataIndex: "LBNR_NAME", type: "string", width: 200},
                    {
                        text: "发票金额(万元)", dataIndex: "FP_AMT", type: "float", width: 180,
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
                        renderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.######');
                        }
                    },
                    {
                        text: "项目办批准金额(万元)", dataIndex: "PZ_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.######');
                        }
                    },
                    {text: "上述款项申请汇至", dataIndex: "ZH_ADDR", type: "string", width: 300},
                    {text: "户名", dataIndex: "ZH_NAME", type: "string", width: 150},
                    {text: "开户行", dataIndex: "ZH_BANK", type: "string", width: 200},
                    {text: "账号", dataIndex: "ACCOUNT", type: "string", width: 200},
                    {text: "附言", dataIndex: "REMARK", type: "string", width: 300}
                ],
                store: store_tkmx
            }
        },
        {text: "类别内容", dataIndex: "LBNR", type: "string", hidden: true},
        {text: "类别内容", dataIndex: "LBNR_NAME", type: "string", cellWrap: true, width: 200},
        {
            text: "发票金额", dataIndex: "FP_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "支付比例(%)", dataIndex: "ZF_RATE", type: "float", width: 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {
            text: "申请金额", dataIndex: "SQ_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "项目办批准金额", dataIndex: "PZ_AMT", type: "float", width: 180,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "拨款日期", dataIndex: "BF_DATE", type: "string", width: 150, tdCls: 'grid-cell',
            editor: {xtype: 'datefield', format: 'Y-m-d', value: today, editable: false}
        },
        {
            text: "核定金额(人民币)", dataIndex: "HD_AMT", type: "float", width: 180, tdCls: 'grid-cell',
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
            text: "美元汇率", dataIndex: "MY_HL", type: "float", tdCls: 'grid-cell',
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            text: "原币汇率", dataIndex: "BF_HL", type: "float", tdCls: 'grid-cell',
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, allowDecimals: true, decimalPrecision: 6},
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            header: "支付金额", columns: [
                {
                    text: "原币", dataIndex: "BF_YB_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit', summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    text: "美元", dataIndex: "BF_MY_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit', summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    text: "人民币", dataIndex: "BF_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit', summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {text: "资金账户ID", dataIndex: "ZH_ID", type: "string", hidden: true},
        {text: "上述款项申请汇至", dataIndex: "ZH_ADDR", type: "string", width: 300},
        {text: "户名", dataIndex: "ZH_NAME", type: "string", width: 200},
        {text: "开户行", dataIndex: "ZH_BANK", type: "string", width: 300},
        {text: "账号", dataIndex: "ACCOUNT", type: "string", width: 200},
        {text: "附言", dataIndex: "REMARK", type: "string", width: 300}
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
                    BKD_ID: formData.BKD_ID,
                    WZXY_ID: formData.WZXY_ID,
                    TKBZ_ID: formData.TKBZ_ID,
                };
                var grid = DSYGrid.getGrid('win_bk_edit_grid');
                var record = grid.getCurrentRecord();
                var index = null;
                if (!!record) {
                    index = record.recordIndex;
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
                var grid = DSYGrid.getGrid('win_bk_edit_grid');
                var store = grid.getStore();
                var sm = grid.getSelectionModel();
                var records = sm.getSelection();
                //获取删除数据记录的ID
                if (!grid.delete_records) {
                    grid.delete_records = [];
                }
                for (var i = 0; i < records.length; i++) {
                    var id = records[i].get('TKDJMX_ID');
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
    var grid = DSYGrid.createGrid({
        itemId: 'win_bk_edit_grid',
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
                //支付金额人民币=核定金额人民币*支付比例；
                // 支付金额原币=支付金额人民币/原币汇率；
                // 支付金额美元=支付金额人民币/美元汇率
                //编辑核定金额人民币
                if (context.field === 'BF_DATE' && !isNull(context.value)) {
                    context.record.set("BF_DATE", dsyDateFormat(context.value));
                }
                if (context.field === 'HD_AMT' && !isNull(context.value)) {
                    var ZF_RATE = Decimal.divBatch(context.record.get('ZF_RATE'), 100);
                    var BF_RMB_AMT = Decimal.mulBatch(ZF_RATE, context.value);
                    context.record.set("BF_AMT", BF_RMB_AMT);
                    if (!isNull(context.record.get('BF_HL'))) {
                        context.record.set("BF_YB_AMT", Decimal.divBatch(BF_RMB_AMT, context.record.get('BF_HL')));
                    }
                    if (!isNull(context.record.get('MY_HL'))) {
                        context.record.set("BF_MY_AMT", Decimal.divBatch(BF_RMB_AMT, context.record.get('MY_HL')));
                    }
                }
                //编辑原币汇率
                if (context.field === 'BF_HL' && !isNull(context.value)) {
                    var ZF_RATE = Decimal.divBatch(context.record.get('ZF_RATE'), 100);
                    var BF_RMB_AMT = Decimal.mulBatch(ZF_RATE, context.record.get('HD_AMT'));
                    context.record.set("BF_YB_AMT", Decimal.divBatch(BF_RMB_AMT, context.value));
                }
                //编辑美元汇率
                if (context.field === 'MY_HL' && !isNull(context.value)) {
                    var ZF_RATE = Decimal.divBatch(context.record.get('ZF_RATE'), 100);
                    var BF_RMB_AMT = Decimal.mulBatch(ZF_RATE, context.record.get('HD_AMT'));
                    context.record.set("BF_MY_AMT", Decimal.divBatch(BF_RMB_AMT, context.value));
                }
                //选择项目区
                if (context.field === 'AG_NAME' && !isNull(context.value)) {
                    var record = store_tkmx.findRecord('TKMX_ID', context.value, 0, false, true, true);
                    context.record.set("TKMX_ID", record.get('TKMX_ID'));
                    context.record.set("AG_NAME", record.get('AG_NAME'));
                    context.record.set("LBNR", record.get('LBNR'));
                    context.record.set("LBNR_NAME", record.get('LBNR_NAME'));
                    context.record.set("FP_AMT", record.get('FP_AMT'));
                    context.record.set("ZF_RATE", record.get('ZF_RATE'));
                    context.record.set("SQ_AMT", record.get('SQ_AMT'));
                    context.record.set("PZ_AMT", record.get('PZ_AMT'));
                    context.record.set("ZH_ID", record.get('ZH_ID'));
                    context.record.set("ZH_ADDR", record.get('ZH_ADDR'));
                    context.record.set("ZH_NAME", record.get('ZH_NAME'));
                    context.record.set("ZH_BANK", record.get('ZH_BANK'));
                    context.record.set("ACCOUNT", record.get('ACCOUNT'));
                    context.record.set("REMARK", record.get('REMARK'));
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
 * 保存拨款信息
 */
function saveBkInfo(self) {
    //获取表单数据
    var form = Ext.ComponentQuery.query('form#win_bk_edit_form');
    if (!form || form.length <= 0) {
        Ext.MessageBox.alert('提示', '保存失败！无法获取主单数据');
        return false;
    }
    form = form[0];
    var formData = form.getForm().getFieldValues();
    formData = $.extend({}, formData, form.getValues());
    //获取明细新增/修改数据
    var grid = DSYGrid.getGrid('win_bk_edit_grid');
    var store = grid.getStore();

    //校验数据
    var message = '';
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        /*if (isNull(record.get('HD_AMT'))) {
            message += '第' + (i + 1) + '行,核定金额人民币不能为空！\n';
        }
        if (isNull(record.get('BF_HL'))) {
            message += '第' + (i + 1) + '行,原币汇率不能为空！\n';
        }
        if (isNull(record.get('MY_HL'))) {
            message += '第' + (i + 1) + '行,美元汇率不能为空！\n';
        }*/
    }
    if (!isNull(message)) {
        Ext.MessageBox.alert('提示', '保存失败！' + message);
        return false;
    }
    var records_add = [];
    var records_update = [];
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        //区分是新增还是修改数据
        if (isNull(record.get('TKDJMX_ID'))) {
            records_add.push(record.data);
        } else {
            records_update.push(record.data);
        }
    }

    //处理数据
    //表单外债协议名称删除，防止参数值校验不通过
    if (!isNull(formData.WZXY_NAME)) {
        delete formData.WZXY_NAME;
    }
    //判断当前操作为新增/修改
    self.setDisabled(true);
    //发送ajax请求新增/更新数据
    $.ajax({
            type: "POST",
            url: "/wzgl_nx/tkgl/editSjbk.action",
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