/**
 * 初始化
 */
$(document).ready(function () {
    initContent();
    initButton();

});

//是否已提交，初始化为0
var IS_TJ = 0;
// 债券类型
var zjlxStore = DebtEleTreeStoreDB('DEBT_ZQLB');

/**
 * 初始化主界面
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: 'contentPanel',
        border: false,
        tbar: [
            {
                text: '查询',
                name: 'search',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                text: '上传',
                name: 'add',
                xtype: 'button',
                icon: '/image/sysbutton/upload.png',
                handler: function (btn) {
                    window_ydfxjh.show(btn);
                }
            },
            {
                text: '修改',
                name: 'upd_fj',
                xtype: 'button',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    var selgrid = DSYGrid.getGrid('contentGrid');
                    var sel = selgrid.getSelection();
                    if (sel.length < 1) {     //未选择项目
                        Ext.toast({
                            html: "请选择至少一条数据后再进行操作!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else if (sel.length > 1) {
                        Ext.toast({
                            html: "不能选择多条数据进行操作!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else {
                        var recordData = sel[0].getData();
                        if (recordData.IS_TJ == '1') {
                            Ext.toast({
                                html: "已经提交的债券不允许修改!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        initwindow_fj(recordData.YDJH_ID, btn.name);
                    }
                }
            }, {

                text: '删除',
                name: 'del',
                xtype: 'button',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var recordData = DSYGrid.getGrid('contentGrid').getSelection();
                    if (recordData.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择一笔月度计划！');
                        return false;
                    }
                    var fxglArray = [];
                    Ext.each(recordData, function (record) {
                        var array = {};
                        array.PLWJ_ID = record.get("PLWJ_ID");
                        array.YDJH_ID = record.get("YDJH_ID");
                        fxglArray.push(array);
                        if (fxglArray.length == recordData.length) {
                            $.ajax({
                                type: "POST",
                                url: 'delPlwjInfo.action',
                                async: false, //设为false就是同步请求
                                cache: false,
                                dataType: 'json',
                                data: {
                                    recordsData: Ext.util.JSON.encode(fxglArray)
                                },
                                success: function (res) {
                                    $.ajax({
                                        type: "POST",
                                        url: 'deleteFile.action',
                                        async: false, //设为false就是同步请求
                                        cache: false,
                                        dataType: 'json',
                                        data: {
                                            fileIdArray: Ext.util.JSON.encode(res.data)
                                        },
                                        success: function () {
                                            Ext.toast({
                                                html: "删除成功！",
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                            reloadGrid();
                                        }
                                    });

                                }, fail: function () {
                                    Ext.toast({
                                        html: "删除失败！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }
                            });

                        }


                    });
                }
            },
            {
                text: '提交',
                name: 'btn_tj',
                xtype: 'button',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    // updateIstj(btn,updaction);
                    var recordData = DSYGrid.getGrid('contentGrid').getSelection();
                    if (recordData.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择一笔月度计划！');
                        return false;
                    }

                    var success = false;
                    Ext.each(recordData, function (record) {
                        $.ajax({
                            type: "POST",
                            url: 'refreshGrid.action',
                            async: false, //设为false就是同步请求
                            cache: false,
                            dataType: 'json',
                            data: {
                                busi_id: record.get("YDJH_ID"),
                                filterParam: 'AD_CODE:' + USER_AD_CODE,
                                busi_type: '',//业务类型
                            },
                            success: function (data) {
                                if (data.list.length == 0) {
                                    Ext.toast({
                                        html: "存在债券未上传披露文件,请检查！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    success = true;
                                    return false;
                                }
                            }, fail: function () {
                                Ext.toast({
                                    html: "债券提交失败！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            }
                        });
                    });
                    if (success) {
                        return false;
                    }
                    var saveFlag=true;
                    Ext.each(recordData, function (record) {
                        $.post('savePlwjInfo.action', {
                            YDJH_ID: record.get("YDJH_ID"),
                            YDJH_YEAR: record.get("YDJH_YEAR"),
                            YDJH_MONTH: record.get("YDJH_MONTH"),
                            ZQ_NAME: record.get("ZQ_NAME"),
                            ZQ_CODE: record.get("ZQ_CODE"),
                            ZQLB_ID: record.get("ZQLB_ID")
                        }, function (data) {
                            if (data.success) {
                            } else {
                                saveFlag=false;
                                Ext.MessageBox.alert('提示', '提交失败!' + data.message);
                                btn.setDisabled(false);
                            }
                        }, 'JSON');
                    });
                    if(saveFlag){
                        Ext.toast({
                            html: '提交成功！',
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    }
                    // var windows=Ext.ComponentQuery.query('window[itemId="zq_sel"]')[0];
                    // windows.close();
                    // btn.up('window').close();
                    // 刷新表格
                    reloadGrid();

                }
            }, {
                text: '撤销提交',
                name: 'btn_cxtj',
                xtype: 'button',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {

                    // updateIstj(btn,updaction);
                    var recordData = DSYGrid.getGrid('contentGrid').getSelection();
                    if (recordData.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择一笔月度计划！');
                        return false;
                    }
                    var fxglArray = [];
                    Ext.each(recordData, function (record) {
                        var array = {};
                        array.PLWJ_ID = record.get("PLWJ_ID");
                        array.YDJH_ID = record.get("YDJH_ID");
                        fxglArray.push(array);
                        if (fxglArray.length == recordData.length) {
                            $.ajax({
                                type: "POST",
                                url: 'delPlwjInfo.action',
                                async: false, //设为false就是同步请求
                                cache: false,
                                dataType: 'json',
                                data: {
                                    recordsData: Ext.util.JSON.encode(fxglArray)
                                },
                                success: function (res) {
                                    if(res.success){
                                        // $.ajax({
                                        //     type: "POST",
                                        //     url: 'deleteFile.action',
                                        //     async: false, //设为false就是同步请求
                                        //     cache: false,
                                        //     dataType: 'json',
                                        //     data: {
                                        //         fileIdArray: Ext.util.JSON.encode(res.data)
                                        //     },
                                        //     success: function () {
                                        Ext.toast({
                                            html: "撤销成功！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                                reloadGrid();
                                            // }
                                        // });
                                    }else{
                                        Ext.toast({
                                            html: res.message,
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                    }
                                }, fail: function (res) {
                                    Ext.toast({
                                        html: "撤销失败！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }
                            });

                        }


                    });
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        items: [
            initContentPanel()//初始化2个表格
        ]
    });
}

var istj_store = DebtEleStore([
    {
        name: '未提交',
        value: 0
    },
    {
        name: '已提交',
        value: 1
    }
]);


function initButton() {
    var btn_tj = Ext.ComponentQuery.query('button[name="btn_tj"]')[0];
    var btn_cxtj = Ext.ComponentQuery.query('button[name="btn_cxtj"]')[0];
    var upd_fj = Ext.ComponentQuery.query('button[name="upd_fj"]')[0];
    var add = Ext.ComponentQuery.query('button[name="add"]')[0];
    var del = Ext.ComponentQuery.query('button[name="del"]')[0];
    if (IS_TJ == 0) {
        del.hide();
        add.hide();
        btn_tj.show();
        upd_fj.hide();
        btn_cxtj.hide();
    } else {
        del.hide();
        add.hide();
        btn_tj.hide();
        btn_cxtj.show();
        upd_fj.hide();
    }
}

/**
 * 初始化panel，放置两个表格
 */
function initContentPanel() {
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
            initContentGrid(),//加载主表信息
            initContentDetilGrid()//加载附件,新增债券
        ]
    });
}

/**
 * 初始化主表格(主表格字段与债券选择弹窗字段相同 用用一个json)
 */
var plwj_id = [{text: "披露文件ID", dataIndex: "PLWJ_ID ", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "当前节点", dataIndex: "NODE_CURRENT_ID ", width: 150, type: "string", fontSize: "15px", hidden: true}];
var headerstore = [
    {text: "月度计划ID", dataIndex: "YDJH_ID ", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "计划年度", dataIndex: "YDJH_YEAR", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "计划月度", dataIndex: "YDJH_MONTH", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "发行批次id", dataIndex: "PCJH_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "发行批次", dataIndex: "PCJH_NAME", width: 150, type: "string", fontSize: "15px"},
    {
        text: "债券名称",
        class: "ty",
        dataIndex: "ZQ_NAME",
        width: 250,
        type: "string",
        fontSize: "15px",
        hidden: false,
        editable: true
    },
    {
        text: "债券编码",
        class: "ty",
        dataIndex: "ZQ_CODE",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false,
        editable: true
    },
    {
        text: "债券类型id",
        class: "ty",
        dataIndex: "ZQLB_ID",
        width: 200,
        type: "string",
        fontSize: "15px",
        hidden: true,
        store: zjlxStore
    },
    {
        text: "债券类型",
        class: "ty",
        dataIndex: "ZQLB_NAME",
        width: 200,
        type: "string",
        fontSize: "15px",
        hidden: false,
        store: zjlxStore
    },
    {
        text: "债券用途",
        class: "ty",
        dataIndex: "ZQYT",
        width: 250,
        type: "string",
        fontSize: "15px",
        hidden: false,
        editable: true
    },
    {text: "备注", dataIndex: "REMARK", width: 300, type: "string", fontSize: "15px", hidden: false}
];

function initContentGrid() {
    var json;
    json = headerstore;
    json.concat(plwj_id);
    return DSYGrid.createGrid({
        height: '50%',
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: json,
            columnAutoWidth: false
        },
        flex: 1,
        dataUrl: IS_TJ == '0' ? 'getZQGridInfo.action' : 'getPlwjGridInfo.action',
        checkBox: true,
        border: false,
        autoLoad: true,
        params: {
            IS_TJ: IS_TJ,
            plwjmhsel: ''
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: "combobox",
                name: "IS_TJ",
                store: istj_store,
                displayField: "name",
                valueField: "value",
                value: IS_TJ,
                fieldLabel: '状态',
                editable: false, //禁用编辑
                width: 150,
                labelWidth: 30,
                allowBlank: false,
                labelAlign: 'right',
                listeners: {
                    'select': function () {
                        IS_TJ = this.value;
                        initButton();
                        reloadGrid();

                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "plwj_mh_sel",
                width: 240,
                labelWidth: 60,
                emptyText: '请输入债券名称/债券编码',
                enableKeyEvents: true
            }],
        listeners: {
            itemclick: function (self, record) {
                var filePanel = Ext.ComponentQuery.query('#winPanel')[0].down('#winPanel_tabPanel');
                if (filePanel) {
                    filePanel.removeAll();
                    filePanel.add(initWin_ckfjGrid({
                        editable: IS_TJ == 0 ? true : false,
                        busiId: record.get('YDJH_ID')
                    }));
                }
                //刷新附件
                DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
                DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
                DSYGrid.getGrid('itemId_sy_zqhz').getStore().load();
                // //刷新附件
                // DSYGrid.getGrid('fjckGrid').getStore().getProxy().extraParams['busi_id'] = record.get('YDJH_ID');
                // DSYGrid.getGrid('fjckGrid').getStore().load();
                //刷新明细表
                DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
                DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "01";
                DSYGrid.getGrid('sy_xzzq').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 初始化附件,新增债券
 * @param sel 区分首页grid 和 window框 grid 页签 参数 ‘sy’为首页 add 为 windows框grid
 */
function initContentDetilGrid() {
    return Ext.create('Ext.panel.Panel', {
        name: 'winPanel',
        itemId: "winPanel",
        border: false,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 1,
        autoLoad: true,
        height: '50%',
        items: [
            {
                xtype: 'tabpanel',
                border: false,
                flex: 1,
                items: [

                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'winPanel_tabPanel',
                                items: [initWin_ckfjGrid({editable: IS_TJ == 0 ? true : false, busiId: ''})]
                            }
                        ]
                    },
                    {
                        title: '债券汇总',
                        layout: 'fit',
                        hidden:true,
                        name: 'xzzq',
                        items: [insert_sy_xzzq()]
                    },
                    {
                        title: '新增债券',
                        layout: 'fit',
                        name: 'xzzq',
                        items: [initWin_ZqGrid()]
                    }
                ]
            }
        ]
    });
}

function insert_sy_xzzq() {
    var headerjson2 = [
        {
            dataIndex: "YDJH_HZ_ID",
            type: "string",
            text: "明细单ID",
            class: "ty",
            width: 150,
            fontSize: "15px",
            hidden: true
        },
        {dataIndex: "AD_NAME", type: "string", text: "地区", class: "ty", width: 150, fontSize: "15px", hidden: false},
        {
            dataIndex: "PLAN_XZ_AMT", type: "float", text: "申请金额（万元）", class: "xmxz", width: 200, fontSize: "15px",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "REMARK", width: 300, type: "string", text: "备注"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'itemId_sy_zqhz',
        flex: 1,
        headerConfig: {
            headerJson: headerjson2,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {
            PLWJSC_ID: 'PLWJSC'
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getZqhzDtlInfo.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqhz_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            'edit': function (editor, context) {

            }
        }
    });
    return grid;

}

// 新增债券表格字段
var xmJson = [
    {text: "明细单ID", class: "ty", dataIndex: "DATA_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "地区code", class: "ty", dataIndex: "AD_CODE", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "地区", class: "ty", dataIndex: "AD_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "单位名称", class: "ty", dataIndex: "AG_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "项目ID", class: "ty", dataIndex: "XM_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
    {
        text: "项目名称", class: "ty", dataIndex: "XM_NAME", width: 350, type: "string", fontSize: "15px", hidden: false,
        renderer: function (data, cell, record) {
            var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
            var paramNames = new Array();
            paramNames[0] = "XM_ID";
            var paramValues = new Array();
            paramValues[0] = record.get('XM_ID');
            var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
            return result;
        }
    },

    {
        text: "申请金额（万元）",
        class: "xmxz",
        dataIndex: "SQ_AMT",
        width: 200,
        type: "float",
        fontSize: "15px",
        hidden: false,
        editable: false,
        fieldStyle: 'background:#E6E6E6',
        summaryType: 'sum',
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
    },
    {text: "申报日期", class: "xmxz", dataIndex: "SB_DATE", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "项目编码", class: "ty", dataIndex: "XM_CODE", width: 350, type: "string", fontSize: "15px", hidden: false},
    {text: "项目类型", class: "ty", dataIndex: "XMLX_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "项目性质", class: "xmxz", dataIndex: "XMXZ_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "立项年度", class: "xmxz", dataIndex: "LX_YEAR", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "建设性质", class: "xmxz", dataIndex: "JSXZ_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {
        text: "建设状态",
        class: "xmxz",
        dataIndex: "BUILD_STATUS_NAME",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false
    },
    {text: "主管部门", class: "ty", dataIndex: "LXSPBM_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "备注", dataIndex: "REMARK", width: 300, type: "string", fontSize: "15px", hidden: false}
];

/**
 * 根据名称生成债券表格
 */
function initWin_ZqGrid() {
    var Json;
    Json = xmJson;
    var simplyGrid = new DSYGridV2();
    var config;
    var id = "sy_xzzq";
    config = {
        itemId: id,
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        dataUrl: 'getPlwjZqGrid.action',
        autoLoad: false,
        features: [{
            ftype: 'summary'
        }],
        //data: contentGridXzzqData,
        pageConfig: {
            enablePage: false
        }
    };
    var rGrid = simplyGrid.create(config);
    return rGrid;
}

//上传附件
function initWin_scfjGrid(ydjh_id) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET005',//业务类型
        busiId: ydjh_id,//业务ID
        editable: true,//是否可以修改附件内容
        filterParam: 'AD_CODE:' + USER_AD_CODE,
        addHeaders: [{text: "区划", dataIndex: "AD_NAME", type: "string", index: 2}],
        gridConfig: {
            itemId: 'scfjGrid'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;

}

//查看附件
function initWin_ckfjGrid(config) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET005',//业务类型
        busiId: config.busiId,//业务ID
        editable: config.editable,//是否可以修改附件内容
        filterParam: 'AD_CODE:' + USER_AD_CODE,
        addHeaders: [{text: "区划", dataIndex: "AD_NAME", type: "string", index: 1}],
        gridConfig: {
            itemId: 'fjckGrid'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}


/**
 * 创建月度发行计划债券选择弹出窗口
 */
var window_ydfxjh = {
    window: null,
    btn: null,
    show: function (btn) {
        this.window = initwindow_select(btn);
        this.window.show();
    }
};
/**
 * 创建月度发行计划弹出窗口
 */
var window_fjsc = {
    window: null,
    btn: null,
    show: function (btn) {
        this.window = initwindow_scfj(btn);
        this.window.show();
    }
};

/**
 * 创建项目选择弹出框
 */
function initwindow_select() {
    var window = Ext.create('Ext.window.Window', {
        title: '债券选择', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'zq_sel', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWin_zqxz()],
        buttons: [
            {
                text: '确定',
                name: 'sava_fj',
                handler: function (btn) {
                    var win_input = Ext.ComponentQuery.query('window[itemId="window_input"]');//录入窗口
                    var win_xm_sel = Ext.ComponentQuery.query('window[itemId="zq_sel"]');//项目选择窗口
                    if (win_xm_sel != null && win_xm_sel != undefined) {  //项目选择窗口存在
                        var grid = DSYGrid.getGrid('zq_grid');
                        var sm = grid.getSelectionModel().getSelection();
                        if (sm.length < 1) {     //未选择项目
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else if (sm.length > 1) {
                            Ext.toast({
                                html: "不能选择多条数据进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            var recordData = sm[0].getData();
                            var ydjh_id = recordData.YDJH_ID;
                            initwindow_fj(ydjh_id, btn.name);
                        }
                    }
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    window.show();
    return window;
}

/**
 * 创建附件上传弹出框
 */
function initwindow_fj(ydjh_id, type) {
    var window = Ext.create('Ext.window.Window', {
        title: '附件', // 窗口标题
        width: document.body.clientWidth * 0.8, //自适应窗口宽度
        height: document.body.clientHeight * 0.8, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'fj_sel', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWin_scfjGrid(ydjh_id)],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    if (type == 'upd_fj') {
                        btn.up('window').close();
                        //刷新附件
                        DSYGrid.getGrid('fjckGrid').getStore().getProxy().extraParams['busi_id'] = ydjh_id;
                        DSYGrid.getGrid('fjckGrid').getStore().load();
                        return;
                    }
                    var grid = DSYGrid.getGrid('zq_grid');
                    var sm = grid.getSelectionModel().getSelection();
                    var recordData = sm[0].getData();
                    if (sm.length < 1) {     //未选择项目
                        Ext.toast({
                            html: "请选择至少一条数据后再进行操作!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else {
                        $.post('savePlwjInfo.action', {
                            YDJH_ID: recordData.YDJH_ID,
                            YDJH_YEAR: recordData.YDJH_YEAR,
                            YDJH_MONTH: recordData.YDJH_MONTH,
                            ZQ_NAME: recordData.ZQ_NAME,
                            ZQ_CODE: recordData.ZQ_CODE,
                            ZQLB_ID: recordData.ZQLB_ID
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
                                var windows = Ext.ComponentQuery.query('window[itemId="zq_sel"]')[0];
                                windows.close();

                                // 刷新表格
                                reloadGrid()
                            } else {
                                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                                btn.setDisabled(false);
                            }
                        }, 'JSON');

                    }
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    window.show();
    return window;
}


/**
 * 加载项目选择内容
 */
function initWin_zqxz() {
    //项目选择条件
    var choose_zq = [
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: 'ADD_ZQ_MH_SEL',
            labelWidth: 60,
            width: 280,
            enableKeyEvents: true,
            emptyText: '请输入债券编码或债券名称',
            displayField: 'code',
            valueField: 'id'
        },
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                //刷新当前表格
                zqload();
            }
        }
    ];

    var Json = headerstore;
    var grid = DSYGrid.createGrid({
        itemId: 'zq_grid',
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        dataUrl: 'getZQGridInfo.action',
        autoLoad: true,
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'jxhj_zq_choose_toolbar',
                items: choose_zq
            }
        ],
        params: {}

    });
    return grid;
}

/**
 * 刷新项目列表
 */
function zqload() {
    var gridold = DSYGrid.getGrid('zq_grid');
    var store = gridold.getStore();
    store.removeAll();
    var adsel = Ext.ComponentQuery.query('treecombobox[itemId="ADD_AD_CODE_SEL"]');
    var AD_CODE = adsel.length > 0 ? adsel[0].value : "";
    var mh = Ext.ComponentQuery.query('textfield[itemId="ADD_ZQ_MH_SEL"]');
    var mhsel = mh.length > 0 ? mh[0].value : null;
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        mhsel: mhsel
    };
    // 刷新f
    store.loadPage(1);
}

/**
 * 刷新主界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    var plwjmh = Ext.ComponentQuery.query('textfield[itemId="plwj_mh_sel"]');
    var plwjmhsel = plwjmh.length > 0 ? plwjmh[0].value : null;
    store.removeAll();
    store.getProxy().extraParams = {
        IS_TJ: IS_TJ,
        plwjmhsel: plwjmhsel
    };
    store.loadPage(1);
    //刷新明细表
    DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['YDJH_ID'] = "";
    DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "";
    DSYGrid.getGrid('sy_xzzq').getStore().removeAll();
    DSYGrid.getGrid('sy_xzzq').getStore().load();

    var filePanel = Ext.ComponentQuery.query('#winPanel')[0].down('#winPanel_tabPanel');
    if (filePanel) {
        filePanel.removeAll();
        filePanel.add(initWin_ckfjGrid({
            editable: IS_TJ == 0 ? true : false,
            busiId: ''
        }));
    }
    //刷新附件 附件同样变成0
    DSYGrid.getGrid('fjckGrid').getStore().getProxy().extraParams['busi_id'] = "";
    DSYGrid.getGrid('fjckGrid').getStore().removeAll();
    DSYGrid.getGrid('fjckGrid').getStore().load();

}

function updateIstj(btn, callback) {
    var updbtn_name = btn.name;
    var recordData = DSYGrid.getGrid('contentGrid').getSelection();
    if (recordData.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一笔月度计划！');
        return false;
    }
    var fxglArray = [];
    if (updbtn_name == 'btn_tj') {
        Ext.each(recordData, function (record) {
            var array = {};
            array.PLWJ_ID = record.get("PLWJ_ID");
            $.ajax({
                type: "POST",
                url: 'refreshGrid.action',
                async: false, //设为false就是同步请求
                cache: false,
                dataType: 'json',
                data: {
                    busi_id: record.get("YDJH_ID"),
                    filterParam: 'AD_CODE:' + USER_AD_CODE,
                    busi_type: '',//业务类型
                },
                success: function (data) {
                    if (data.list.length == 0) {
                        Ext.toast({
                            html: "存在债券未上传披露文件,请检查！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    } else {
                        fxglArray.push(array);
                        if (fxglArray.length == recordData.length) {
                            callback(btn, fxglArray)
                        }
                    }

                }, fail: function () {
                    Ext.toast({
                        html: "债券提交失败！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                }
            });
        });
    } else {
        Ext.each(recordData, function (record) {
            var array = {};
            array.PLWJ_ID = record.get("PLWJ_ID");
            array.YDJH_ID = record.get("YDJH_ID");
            fxglArray.push(array);
            if (fxglArray.length == recordData.length) {
                callback(btn, fxglArray)
            }
        });
    }
}

function updaction(btn, fxglArray) {
    var updbtn_name = btn.name;
    var updbtn_text = btn.text;
    $.ajax({
        type: "POST",
        url: 'updPlwjIstj.action',
        async: false, //设为false就是同步请求
        cache: false,
        dataType: 'json',
        data: {
            updbtn_name: updbtn_name,
            recordsData: Ext.util.JSON.encode(fxglArray)
        },
        success: function (data) {
            Ext.toast({
                html: data.msg,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            reloadGrid();
        }, fail: function () {
            Ext.toast({
                html: updbtn_text + "失败！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
        }
    });
}