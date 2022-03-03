/**
 * 初始化
 */
$(document).ready(function () {
    initContent();
    initButton();

});
var nowDate = Ext.Date.format(new Date(), 'Y-m-d');// 获取系统当前时间
var nowYear=nowDate.substr(0,4);// 截取系统当前年度
var zwsrkm_store = DebtEleTreeStoreDB('DEBT_ZWSRKM',{condition:" and (code like '105%') and year = "+nowYear});
var nd_id = '';
var button_name = '';//录入||修改
var yearclock = false;
var monthclock = false;
var IS_FB = 0;
var is_zxzqfb = getQueryParam("is_zxzqfb");
if (typeof is_zxzqfb == 'undefined' || null == is_zxzqfb) {
    is_zxzqfb = 0;
}
// 债券类型
//var zjlxStore = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2) && is_zxzqfb == 1 ? " and substr(code,0,2)='02' " : ""});
var condition = " AND 1=1 ";
if(IS_BZB == '2'){//若为专项债券系统，则只能选择有收益债券类型
    condition += " AND CODE LIKE '0202%'";
}
var zjlxStore = DebtEleTreeStoreDB('DEBT_ZQLB',{condition:condition});

//年度为1展示2020年,年度为0展示2019年数据.(包含年度及其以后)
var ndkz = 1;
// 区划树
var qhStore = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        //url: 'getAdDataNoCache.action',
        url: 'getRegTreeDataNoCache.action',
        reader: {
            type: 'json'
        }
    },
    root: 'nodelist',
    model: 'treeModel',
    autoLoad: true
});


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
                text: '录入',
                name: 'add',
                xtype: 'button',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    if ("000000" == nd_id || "00" == nd_id.substr(4, 2)) {
                        Ext.MessageBox.alert('提示', '请选择正确的年度月份！');
                        return;
                    }
                    button_name = btn.name;
                    yearclock = false;
                    monthclock = false;
                    window_ydfxjh.show(btn);
                }
            },
            {
                text: '修改',
                name: 'update',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    yearclock = true;
                    monthclock = true;
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    window_ydfxjh.show(btn);

                    var ydjhdata = records[0].getData();
                    var form = Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm();//找到该form

                    form.setValues(ydjhdata);//将记录中的数据写进form表中
                    nd_id = records[0].data["YDJH_YEAR"] + records[0].data["YDJH_MONTH"];
                    //补充数据
                    /*DSYGrid.getGrid('itemId_add_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = records[0].data["YDJH_ID"];
                    DSYGrid.getGrid('itemId_add_zqhz').getStore().loadPage(1);*/
                    DSYGrid.getGrid('add_xzzq_grid').getStore().getProxy().extraParams['YDJH_ID'] = records[0].data["YDJH_ID"];
                    DSYGrid.getGrid('add_xzzq_grid').getStore().getProxy().extraParams['ZQLX_ID'] = "01";
                    DSYGrid.getGrid('add_xzzq_grid').getStore().loadPage(1);
                    DSYGrid.getGrid('add_xzzq_grid').getStore().on('load', function () {

                        checkGridStroe();
                    });
                    DSYGrid.getGrid('add_zrzzq_grid').getStore().getProxy().extraParams['YDJH_ID'] = records[0].data["YDJH_ID"];
                    DSYGrid.getGrid('add_zrzzq_grid').getStore().getProxy().extraParams['ZQLX_ID'] = "03";
                    DSYGrid.getGrid('add_zrzzq_grid').getStore().loadPage(1);
                    DSYGrid.getGrid('add_zrzzq_grid').getStore().on('load', function () {

                        checkGridStroe();
                    });
                }
            },
            {
                text: '删除',
                name: 'del',
                xtype: 'button',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {

                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            var ids = new Array();
                            for (var k = 0; k < records.length; k++) {
                                var ydjh_id = records[k].get("YDJH_ID");
                                ids.push(ydjh_id);
                            }
                            $.post("DelYdjhInfo.action", {
                                ids: Ext.util.JSON.encode(ids),
                            }, function (data_response) {
                                data_response = $.parseJSON(data_response);
                                if (data_response.success) {
                                    Ext.toast({
                                        html: "删除成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    reloadGrid();
                                } else {
                                    Ext.toast({
                                        html: "删除失败！" + data_response.message,
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                            });
                        }
                    });
                }
            }, {
                text: '发布',
                name: 'btn_fb',
                xtype: 'button',
                icon: '/image/sysbutton/audit.png',
                hidden: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false : true,
                handler: function (btn) {
                    updateIsfb(btn);
                }
            }, {
                text: '撤销发布',
                name: 'btn_cxfb',
                xtype: 'button',
                icon: '/image/sysbutton/audit.png',
                hidden: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false : true,
                handler: function (btn) {
                    updateIsfb(btn);
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        items: [
            initContentTree({
                items_tree: function () {
                    return [
                        initContentTree()//年度树
                    ]
                }
            }),
            initContentRightPanel()//初始化右侧2个表格
        ]
    });
}

var isfb_store = DebtEleStore([
    {
        name: '未发布',
        value: 0
    },
    {
        name: '已发布',
        value: 1
    }
]);


function initButton() {
    var btn_fb = Ext.ComponentQuery.query('button[name="btn_fb"]')[0];
    var btn_cxfb = Ext.ComponentQuery.query('button[name="btn_cxfb"]')[0];
    var add = Ext.ComponentQuery.query('button[name="add"]')[0];
    var update = Ext.ComponentQuery.query('button[name="update"]')[0];
    var del = Ext.ComponentQuery.query('button[name="del"]')[0];
    if ((IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1) {
        if (IS_FB == 0) {
            add.show();
            update.show();
            del.show();
            btn_fb.show();
            btn_cxfb.hide();
        } else {
            add.hide();
            update.hide();
            del.hide();
            btn_fb.hide();
            btn_cxfb.show();
        }
    }

}

function initContentTree() {
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'id'}
        ]
    });
    //创建左侧panel
    return Ext.create('Ext.panel.Panel', {
        region: 'west',
        layout: 'vbox',
        height: '100%',
        itemId: 'treePanel_left',
        flex: 1,
        border: true,
        items: initContentTree_ndyd()
    });
}

function DebtXmzStore(debtEle, params) {
    var namecode = '0';
    if (typeof params != 'undefined' && params != null) {
        namecode = params.namecode;
    }
    var debtStore = Ext.create('Ext.data.Store', {
        fields: ['ID', 'CODE', 'NAME'],
        sorters: [{
            property: 'ID',
            direction: 'asc'
        }],
        data: namecode == '1' ? DebtJSONNameWithCode(debtEle) : debtEle
    });
    return debtStore;
}

/**
 * 初始化左侧树：年度树
 */
function initContentTree_ndyd() {
    //加载左侧上方树数据
    var regStore = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getNDdataTree.action',
            extraParams: {
                AD_CODE: AD_CODE,
                IS_ZXZQFB: is_zxzqfb,
                IS_ZXZQXT_FX: IS_ZXZQXT_FX,
                NDKZ: ndkz
            },
            reader: {
                type: 'json'
            }
        },
        root: 'nodelist',
        model: 'treeModel',
        autoLoad: true
    });
    var area_config = {
        itemId: 'tree_dxm',
        store: regStore,
        width: '100%',
        border: true,
        rootVisible: false,
        listeners: {
            afterrender: function (self) {
                //选中第一条数据
                if (self.getSelection() == null || self.getSelection().length <= 0) {
                    //选中第一条数据
                    var record = self.getStore().getRoot().getChildAt(0);
                    if (record) {
                        self.getSelectionModel().select(record);
                        itemclick(self, record);
                    }
                }
            },
            itemclick: itemclick
        }
    };

    //创建左侧panel
    var area_panel = Ext.create('Ext.tree.Panel', area_config);
    regStore.addListener('load', function (self) {
        var treeNodeCount = self.getCount();
        area_panel.setFlex(1);
        //选中第一条数据
        if (area_panel.getSelection() == null || area_panel.getSelection().length <= 0) {
            var record = self.getRoot().getChildAt(0);
            if (record) {
                area_panel.getSelectionModel().select(record);
                itemclick(area_panel, record);
            }
        }
    });
    return area_panel;

    function itemclick(self, record) {
        nd_id = record.get('id');
        reloadGrid();
        //刷新明细表
        DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
        DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "01";
        DSYGrid.getGrid('sy_xzzq').getStore().loadPage(1);
        DSYGrid.getGrid('sy_zrzzq').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
        DSYGrid.getGrid('sy_zrzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "03";
        DSYGrid.getGrid('sy_zrzzq').getStore().loadPage(1);
    }
}

/**
 * 初始化右侧panel，放置1个表格
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
            initContentGrid(),//加载主表信息
            initContentDetilGrid('sy')//加载新增债券，再融资债券表信息
        ]
    });
}

/**
 * 初始化主表格
 */
var headerstore = [
    {text: "月度计划ID", dataIndex: "YDJH_ID ", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "计划年度", dataIndex: "YDJH_YEAR", width: 150, type: "string", fontSize: "15px", hidden: false},
    {
        text: "计划月份", dataIndex: "YDJH_MONTH", width: 150, type: "string", fontSize: "15px", hidden: false,
        store: DebtEleStore(json_debt_yf),
        renderer: function (value) {
            if (value == '') {
                return;
            }
            var rec = DebtEleStore(json_debt_yf).findRecord('code', value, 0, false, true, true);
            if (rec == null) {
                return '';
            }
            return rec.get('name');
        }
    },
    {
        text: "计划发行时间",
        class: "ty",
        dataIndex: "JHFX_DATE",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false,
        editor: {xtype: "datefield", disabledYears: [2018], format: 'Y-m-d'},
        renderer: function (value) {
            value = Ext.util.Format.date(value, 'Y-m-d');
            return value;
        }
    },
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
        text: "债券期限",
        class: "ty",
        dataIndex: "ZQQX_ID",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: true,
        editable: true
    },
    {
        text: "债券期限",
        class: "ty",
        dataIndex: "ZQQX_NAME",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false,
        editable: true
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
    {
        text: "发行规模（亿元）", dataIndex: "PLAN_AMT", width: 200, type: "float", fontSize: "15px", hidden: false,
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.000000');
        },
        summaryType: 'sum',
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.000000');
        }

    },
    {
        text: "其中新增债券金额（亿元）", dataIndex: "PLAN_XZ_AMT", width: 200, type: "float", fontSize: "15px", hidden: false,
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.000000');
        },
        summaryType: 'sum',
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.000000');
        }

    },
    {
        text: "其中再融资债券金额（亿元）", dataIndex: "PLAN_ZRZ_AMT", width: 250, type: "float", fontSize: "15px", hidden: false,
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.000000');
        },
        summaryType: 'sum',
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.000000');
        }

    },
    {
        text: "信用评级结果",
        class: "ty",
        dataIndex: "XYPJJG",
        width: 250,
        type: "string",
        fontSize: "15px",
        hidden: false,
        editable: true
    },
    {
        text: "还本方式",
        class: "ty",
        dataIndex: "HBFS_ID",
        width: 150,
        hidden: true
    },
    {
        text: "还本方式",
        class: "ty",
        dataIndex: "HBFS_NAME",
        width: 150,
        type: "string",
        fontSize: "15px"
    },
    {
        text: "债务收入科目",
        class: "ty",
        dataIndex: "SRKM_ID",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: true
    },
    {
        text: "债务收入科目",
        class: "ty",
        dataIndex: "SRKM_NAME",
        width: 180,
        type: "string",
        fontSize: "15px",
    },
    {text: "备注", dataIndex: "REMARK", width: 300, type: "string", fontSize: "15px", hidden: false}
];

function initContentGrid() {
    return DSYGrid.createGrid({
        height: '50%',
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerstore,
            columnAutoWidth: false
        },
        flex: 1,
        dataUrl: 'getYdfxjhGridInfo.action',
        checkBox: true,
        border: false,
        autoLoad: true,
        params: {
            IS_ZXZQXT_FX: IS_ZXZQXT_FX,
            IS_FB: IS_FB,
            IS_ZXZQFB: is_zxzqfb,
            NDKZ: ndkz
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: "combobox",
                name: "IS_FB",
                store: isfb_store,
                displayField: "name",
                valueField: "value",
                value: IS_FB,
                fieldLabel: '状态',
                editable: false, //禁用编辑
                width: 150,
                labelWidth: 30,
                allowBlank: false,
                labelAlign: 'right',
                hidden: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false : true,
                listeners: {
                    'select': function () {
                        IS_FB = this.value;
                        initButton();
                        reloadGrid();
                    }
                }
            }],
        /*tbar: [
            {
                xtype: "combobox",
                itemId: "YDJH_YEAR",   //计划年度
                store: DebtEleStoreDB('DEBT_YEAR'),
                fieldLabel: '计划年度',
                displayField: 'code',
                valueField: 'id',
                value: new Date().getFullYear(),
                width: 200,
                labelWidth: 60,
                editable: false,
                listeners: {
                    change: function (btn) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            },{
                xtype: "combobox",
                itemId: "YDJH_MONTH",   //计划月份
                fieldLabel: '计划月份',
                displayField: 'name',
                valueField: 'id',
                width: 200,
                labelWidth: 60,
                editable: false,
                store: DebtEleStore(json_debt_yf),
                listeners: {
                    change: function (btn) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            }
        ],*/
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                /*if ((IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1) {

                }*/
                DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
                DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "01";
                DSYGrid.getGrid('sy_xzzq').getStore().loadPage(1);
                DSYGrid.getGrid('sy_zrzzq').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
                DSYGrid.getGrid('sy_zrzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "03";
                DSYGrid.getGrid('sy_zrzzq').getStore().loadPage(1);
                /*DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = record.get('YDJH_ID');
                DSYGrid.getGrid('itemId_sy_zqhz').getStore().loadPage(1);*/
            }
        }
    });
}

/**
 * 初始化新增债券，再融资债券表格信息
 * @param sel 区分首页grid 和 window框 grid 页签 参数 ‘sy’为首页 add 为 windows框grid
 */
function initContentDetilGrid(sel) {
    return Ext.create('Ext.panel.Panel', {
        name: 'winPanel',
        border: false,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 1,
        autoLoad: true,
        height: '50%',
        items:[
            {
                xtype: 'tabpanel',
                border: false,
                flex: 1,
                itemId: 'winPanel_tabPanel',
                items: [
                    {
                        title: '新增债券',
                        layout: 'fit',
                        name: 'xzzq',
                        items: [initWin_ZqGrid(sel, 'xzzq')]
                    },
                    {
                        title: '再融资债券',
                        layout: 'fit',
                        name: 'zrzzq',
                        items: [initWin_ZqGrid(sel, 'zrzzq')]
                    }
                ] ,
                listeners: {
                    tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                        /*var toolbar = Ext.ComponentQuery.query('tabpanel#winPanel_tabPanel')[0];
                        if (toolbar) {
                            name = newCard.name;
                            if ((name == 'xzzq' || name == 'zrzzq') && (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1) {
                                Ext.ComponentQuery.query('button[name="addBtn"]')[0].setHidden(true);
                                Ext.ComponentQuery.query('button[name="delBtn"]')[0].setHidden(true);
                            } else {
                                Ext.ComponentQuery.query('button[name="addBtn"]')[0].setHidden(true);
                                Ext.ComponentQuery.query('button[name="delBtn"]')[0].setHidden(true);
                            }
                        }*/
                    }
                }
            }
        ]
    });
}

// 新增债券，再融资债券通用表格字段
var bz = [{text: "备注", dataIndex: "REMARK", width: 300, type: "string", fontSize: "15px", hidden: false}];
var ba = [{
    text: "备案编码",
    class: "ty",
    dataIndex: "BA_CODE",
    width: 150,
    type: "string",
    fontSize: "15px",
    hidden: false
}];
var xmJson = [
    {text: "明细单ID", class: "ty", dataIndex: "DATA_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "地区code", class: "ty", dataIndex: "AD_CODE", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "地区", class: "ty", dataIndex: "AD_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "单位名称", class: "ty", dataIndex: "AG_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "申报批次", class: "ty", dataIndex: "SBPC_CODE", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "申报批次", class: "ty", dataIndex: "SBPC_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
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
        text: "本次发行金额（万元）",
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
    {
        text: "剩余待发行金额（万元）",
        class: "ty",
        dataIndex: "SURPLUS_AMOUNT",
        width: 150,
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
    {
        text: "项目资本金金额（万元）",
        class: "xmxz",
        dataIndex: "SQ_ZBJ_AMT",
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
    {
        text: "其中:新增赤字（万元）",
        class: "xmxz",
        dataIndex: "XZCZAP_AMT",
        width: 200,
        type: "float",
        fontSize: "15px",
        hidden: false,
        editable: false,
        summaryType: 'sum',
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
    },
    {text: "项目编码", class: "ty", dataIndex: "XM_CODE", width: 350, type: "string", fontSize: "15px", hidden: false},
    {text: "项目类型", class: "ty", dataIndex: "XMLX_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "项目性质", class: "xmxz", dataIndex: "XMXZ_NAME", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "立项年度", class: "xmxz", dataIndex: "LX_YEAR", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "建设性质", class: "xmxz", dataIndex: "JSXZ_NAME", width: 150, type: "string", fontSize: "15px", hidden: true},
    {
        text: "建设状态",
        class: "xmxz",
        dataIndex: "BUILD_STATUS_NAME",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false
    },
    {text: "主管部门", class: "ty", dataIndex: "LXSPBM_NAME", width: 150, type: "string", fontSize: "15px", hidden: false}
];
var zqxxjson = [
    {
        text: "再融资债卷明细单ID",
        class: "xmxz",
        dataIndex: "DATA_ID",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: true
    },
    {text: "债券ID", class: "xmxz", dataIndex: "ZQ_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
    {
        text: "债券/债务名称",
        class: "xmxz",
        dataIndex: "ZQ_NAME",
        width: 250,
        type: "string",
        fontSize: "15px",
        hidden: false,
        renderer: function (data, cell, record) {

            if (record.get('DATA_TYPE') == 'ZW') {
                var url = '/page/debt/common/zwyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "zw_id";
                paramNames[1] = "zwlb_id";
                var paramValues = new Array();
               // paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            } else {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = AD_CODE;
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        }
    },
    {
        text: "再融资申请总金额（万元）",
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
            return Ext.util.Format.number(value, '0,000.000000');
        },
        renderer:function(value){
            return Ext.util.Format.number(value, '0,000.000000');
        },
    },
    {
        text: "债券/债务类型ID",
        class: "xmxz",
        dataIndex: "ZQLB_ID",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: true
    },
    {
        text: "债券/债务类型",
        class: "xmxz",
        dataIndex: "ZQLB_NAME",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false
    },
    {
        text: "申报批次",
        class: "ty",
        dataIndex: "BATCH_NO",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: true
    },
    {
        text: "申报批次",
        class: "ty",
        dataIndex: "BATCH_NAME",
        width: 200,
        type: "string",
        fontSize: "15px",
        hidden: false
    },
    {text: "到期日期", class: "xmxz", dataIndex: "DQDF_DATE", width: 150, type: "string", fontSize: "15px", hidden: false},
    {
        text: "到期金额(万元)", class: "xmxz", dataIndex: "DQ_AMT", width: 200, type: "float", fontSize: "15px", hidden: false,
        // summaryType: 'sum',
        // summaryR
        renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
    },
    /*{text: "发行规模",class:"xmxz",dataIndex: "FX_AMT",width: 150,type: "float",fontSize: "15px",hidden:false},*/
    {text: "期限ID", class: "xmxz", dataIndex: "ZQQX_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
    {text: "期限", class: "xmxz", dataIndex: "ZQQX_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
    {text: "利率(%)", class: "xmxz", dataIndex: "PM_RATE", width: 150, type: "float", fontSize: "15px", hidden: false},
    {
        text: "发行日期",
        class: "xmxz",
        dataIndex: "FX_START_DATE",
        width: 150,
        type: "string",
        fontSize: "15px",
        hidden: false
    }
];

/**
 * 根据名称生成债券表格
 * @param sel sy 为 首页明细grid add 为Windows框 明细grid
 * @param name 'xzzq ' 为新增债券  'zrzzq'再融资债券
 */
function initWin_ZqGrid(sel, name) {
    var Json;
    if (name == 'xzzq') {//添加新增债券使用字段
        Json = xmJson;
        Json.push(bz[0]);
        if ((IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1) {
            Json.splice(6, 0, ba[0]);
        }
    } else if (name == 'zrzzq') {//添加再融资债券使用字段
        Json = zqxxjson;
        Json.push(bz[0]);
    }
    var simplyGrid = new DSYGridV2();

    var grid;
    var config;
    var id = sel + "_" + name;
    if (sel == 'sy') { // 首页
        config = {
            itemId: id,
            border: false,
            flex: 1,
            headerConfig: {
                headerJson: Json,
                columnAutoWidth: false
            },
            dataUrl: 'getYdjhZqGrid.action',
            autoLoad: false,
            params: {
                pjch_id: ''
            },
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

    } else if (sel = 'add') {
        if (name == 'xzzq') {
            return insert_add_xzzq();
        } else if (name == 'zrzzq') {
            return insert_add_zrzzq();
        }
    }
}

/**
 * 返回添加页面再融资债券
 */
function insert_add_zrzzq() {
    var Json = [
        {
            text: "再融资债券明细ID",
            class: "ty",
            dataIndex: "YDJH_HZ_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "再融资债券明细ID",
            class: "ty",
            dataIndex: "DATA_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券ID",
            class: "ty",
            dataIndex: "ZQ_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "区划CODE",
            class: "ty",
            dataIndex: "AD_CODE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券/债务名称",
            class: "ty",
            dataIndex: "ZQ_NAME",
            width: 250,
            type: "string",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    paramNames[1] = "zwlb_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                    paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE;
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            }
        },
        /*{text: "发行规模",class:"ty",dataIndex: "FX_AMT",width: 150,type: "float",fontSize: "15px",hidden:false,editable: false,fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }},*/
        {
            text: "再融资申请总金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                decimalPrecision : 6},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.000000');
            },
        },
        {
            text: "剩余可申请金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.000000');
            },
        },
        {
            text: "到期日期",
            class: "ty",
            dataIndex: "DQDF_DATE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "到期金额",
            class: "ty",
            dataIndex: "DQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            // summaryType: 'sum',summaryR
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "期限ID",
            class: "ty",
            dataIndex: "ZQQX_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "期限",
            class: "xmxz",
            dataIndex: "ZQQX_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券/债务类型ID",
            class: "ty",
            dataIndex: "ZQLB_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券/债务类型",
            class: "ty",
            dataIndex: "ZQLB_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "BATCH_NO",
            width: 150,
            type: "string",
            fontSize: "15px",
            tdCls: 'grid-cell-unedit',
            hidden: true
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "BATCH_NAME",
            width: 200,
            type: "string",
            fontSize: "15px",
            tdCls: 'grid-cell-unedit',
            hidden: false
        },
        {
            text: "备注", dataIndex: "REMARK", width: 300, type: "string", fontSize: "15px", hidden: false,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'add_zrzzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false : true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {},
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getYdjhZqGrid.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jxhj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {}
            }
        ],
        listeners: {
            'edit': function (editor, context) {
                var xzzqStore = grid.getStore();
                if (context.field == 'SQ_AMT') {
                    var zrzStore = grid.getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_ZRZ_AMT"]')[0].setValue(zrzStore.sum('SQ_AMT') / 10000);
                }
            }
        }
    });
    /*//将发行规模赋值给再融资债券金额（亿元）
    grid.getStore().on('endupdate', function () {
        var self = grid.getStore();
        var form = grid.up('window').down('form');
        var fxgm_amt = 0;
        //再融资债券金额赋值为0，避免多次修改在造成累加
        form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').setValue(0);
        //获取发行规模填入金额
        self.each(function (record) {
            fxgm_amt += record.get('PLAN_AMT');
        });
        //获取再融资债券债券金额
        var zrzzq_amt=form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').getValue();
        if(zrzzq_amt!=null&&zrzzq_amt!=""&&zrzzq_amt>0){
            fxgm_amt +=Number(zrzzq_amt)*100000000;
        }
        form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').setValue(Ext.util.Format.number(fxgm_amt/100000000, '0,000.000000'));

    });*/
    return grid;
}

/**
 * 返回添加页面新增债券
 */
function insert_add_xzzq() {
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
        {
            text: "明细单ID",
            class: "ty",
            dataIndex: "DATA_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "项目ID",
            class: "ty",
            dataIndex: "XM_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "地区",
            class: "ty",
            dataIndex: "AD_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "单位名称",
            class: "ty",
            dataIndex: "AG_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "SBPC_CODE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "SBPC_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "项目名称",
            class: "ty",
            dataIndex: "XM_NAME",
            width: 350,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit',
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
            text: "本次发行金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            tdCls: /*(IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? 'grid-cell-unedit' : */'',
            editor: /*(IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false :*/ {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false,
            },

            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },

        },
        {
            text: "本次发行金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_AMT_OLD",
            width: 200,
            type: "float",
            fontSize: "15px",
            editable: false,
            hidden: true
        },
        {
            text: "剩余待发行金额（万元）",
            class: "xmxz",
            dataIndex: "SURPLUS_AMOUNT",
            width: 200,
            type: "float",
            fontSize: "15px",
            fieldStyle: 'background:#E6E6E6',
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }

        },
        {
            text: "项目资本金金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_ZBJ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            editable: false,
            // fieldStyle: 'background:#E6E6E6',
            // tdCls: Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm().findField('ZQLB_ID').value != '01'?'':'grid-cell-unedit',
            editor: /*(IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false :*/ {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            renderer: function(value,cell){
                if(Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm().findField('ZQLB_ID').value == '01'){
                    cell.tdCls = 'grid-cell-unedit';
                    return Ext.util.Format.number(value  , '0,000.00####');
                }else{
                    cell.tdCls = '';
                    return Ext.util.Format.number(value  , '0,000.00####');;
                }
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "其中:新增赤字（万元）",
            class: "xmxz",
            dataIndex: "XZCZAP_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            // fieldStyle: 'background:#E6E6E6',
            // tdCls: Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm().findField('ZQLB_ID').value == '01'?'':'grid-cell-unedit',
            editor: /*(IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false :*/ {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false,
            },
            renderer: function(value,cell){
                if(Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm().findField('ZQLB_ID').value != '01'){
                    cell.tdCls = 'grid-cell-unedit';
                    return Ext.util.Format.number(value  , '0,000.00####');;
                }else{
                    cell.tdCls = '';
                    return Ext.util.Format.number(value  , '0,000.00####');;
                }
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余可申请金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            //hidden: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? true : false,
            hidden:false,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余可申请资本金金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_ZBJ_AMT",
            width: 220,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            //hidden: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? true : false,
            hidden:false,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },

        {
            text: "项目类型",
            class: "ty",
            dataIndex: "XMLX_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "项目性质",
            class: "xmxz",
            dataIndex: "XMXZ_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            tdCls: 'grid-cell-unedit',
            hidden:true
        },
        {
            text: "立项年度",
            class: "xmxz",
            dataIndex: "LX_YEAR",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "建设性质",
            class: "xmxz",
            dataIndex: "JSXZ_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            tdCls: 'grid-cell-unedit',
            hidden:true
        },
        {
            text: "建设状态",
            class: "xmxz",
            dataIndex: "BUILD_STATUS_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            dataIndex: "REMARK", width: 300, type: "string", text: "备注", hidden: false,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        }

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'add_xzzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: headerjson2,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false : true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {},
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getYdjhZqGrid.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jxhj_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            'beforeedit': function (editor, context) {
                if (context.field == 'XZCZAP_AMT' && Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm().findField('ZQLB_ID').value != '01') {
                    return false;
                }
                if (context.field == 'SQ_ZBJ_AMT' && Ext.ComponentQuery.query('form#init_ydfxjh_form')[0].getForm().findField('ZQLB_ID').value == '01') {
                    return false;
                }
            },
            'edit': function (editor, context) {
                if (context.field == 'SQ_AMT') {
                    var xzzqStore = grid.getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_XZ_AMT"]')[0].setValue(xzzqStore.sum('SQ_AMT') / 10000);
                }
                if (context.field == 'SQ_ZBJ_AMT') {
                    var xzzqStore = grid.getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="ZX_FX_AMT"]')[0].setValue(xzzqStore.sum('SQ_ZBJ_AMT') / 10000);
                }
                if (context.field == 'XZCZAP_AMT') {
                    var xzzqStore = grid.getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="XZCZAP_AMT"]')[0].setValue(xzzqStore.sum('XZCZAP_AMT') / 10000);
                }
            }
        }
    });
    /* //将发行规模赋值给新增债券金额（亿元）
     grid.getStore().on('endupdate', function (gridnew ,rowIndex , cellIndex) {
         var self = grid.getStore();
         var form = grid.up('window').down('form');
         var fxgm_amt = 0;
         //新增债券金额赋值为0，避免多次修改在造成累加
         form.down('numberFieldFormat[name="PLAN_XZ_AMT"]').setValue(0);
         //获取发行规模填入金额：循环增加
         self.each(function (record) {
             fxgm_amt += record.get('PLAN_AMT');
         });
         //获取新增债券金额
         var xzzq_amt=form.down('numberFieldFormat[name="PLAN_XZ_AMT"]').getValue();
         if(xzzq_amt!=null&&xzzq_amt!=""&&xzzq_amt>0){
             fxgm_amt +=Number(xzzq_amt)*100000000;
         }
         form.down('numberFieldFormat[name="PLAN_XZ_AMT"]').setValue(Ext.util.Format.number(fxgm_amt/100000000, '0,000.000000000'));

     });*/
    return grid;

}

/**
 * 创建月度发行计划弹出窗口
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
 * 初始化月度发行计划Windows框
 */
function initwindow_select(btn) {

    var window = Ext.create('Ext.window.Window', {
        title: '月度发行计划', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        buttons: [
            {
                xtype: 'button',
                text: '增行',
                id: 'addBtn',
                name: 'addBtn',
                handler: function (btn) {
                    var ZQLB_ID = btn.up('window').down('treecombobox[name="ZQLB_ID"]').value;
                    if (!!ZQLB_ID) {
                        var name = btn.up('window').query('panel[itemId="winPanel_tabPanel"]')[0].getActiveTab().name;
                        if (name == 'xzzq' || name == 'zqhz') {//新增债券
                            Set_chose_xm();
                        } else if (name = 'zrzzq') {//置换债券
                            Set_chose_zq();
                        }
                    } else {
                        Ext.Msg.alert('提示', '请选择债券类型！');
                    }

                }
            },
            {
                xtype: 'button',
                text: '删行',
                id: 'delBtn',
                name: 'delBtn',
                handler: function (btn) {
                    //获取页签信息
                    var gridname;
                    var name=btn.up('window').query('panel[itemId="winPanel_tabPanel"]')[0].getActiveTab().name;
                    if(name=='xzzq'){//新增债券
                        gridname='add_xzzq_grid';
                    }else if(name='zrzzq'){//置换债券
                        gridname='add_zrzzq_grid';
                    }
                    var grid = DSYGrid.getGrid(''+gridname+'');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel().getSelection();
                    var fxzbj=Ext.ComponentQuery.query('numberFieldFormat[name="ZX_FX_AMT"]')[0].value;//专项债用作资本金额
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
                        grid.getView().refresh();
                        store.remove(sm);
                        var sq_sum_amt = store.sum('SQ_AMT');
                        var sq_sum_zbj_amt = store.sum('SQ_ZBJ_AMT');
                        var sq_sum_xzczap_amt = store.sum('XZCZAP_AMT');
                        if(name=='xzzq'){//新增债券
                            Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_XZ_AMT"]')[0].setValue(sq_sum_amt/10000);
                            Ext.ComponentQuery.query('numberFieldFormat[name="ZX_FX_AMT"]')[0].setValue(sq_sum_zbj_amt/10000);
                            Ext.ComponentQuery.query('numberFieldFormat[name="XZCZAP_AMT"]')[0].setValue(sq_sum_xzczap_amt/10000);
                        }else if(name='zrzzq'){//置换债券
                            Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_ZRZ_AMT"]')[0].setValue(sq_sum_amt/10000);
                        }
                        // Ext.ComponentQuery.query('numberFieldFormat[name="ZX_FX_AMT"]')[0].setValue(fxzbj-store.removed[0].data.SQ_ZBJ_AMT/10000);
                        checkGridStroe();
                    }
                }
            },
            {
                text: '保存',
                name: 'btn_update',
                id: 'save',
                handler: function (btn) {
                    var srkm_value = btn.up('window').down('treecombobox[name="SRKM_ID"]').value;
                    var ZQLB_ID = btn.up('window').down('treecombobox[name="ZQLB_ID"]').value;
                    var  PLAN_AMT=btn.up('window').down('numberFieldFormat[name="PLAN_AMT"]').value;
                    var zj = btn.up('window').down('numberFieldFormat[name="ZX_FX_AMT"]').value;
                    var czzj = btn.up('window').down('numberFieldFormat[name="XZCZAP_AMT"]').value;
                    var grid = DSYGrid.getGrid('add_xzzq_grid');
                    var store = grid.getStore();
                    var b = true;
                    store.each(function (record) {
                        if(parseFloat(Ext.util.Format.number(record.get('SQ_AMT'), '00000000.00'))
                            < parseFloat(Ext.util.Format.number(record.get('XZCZAP_AMT'), '00000000.00')) ){
                            Ext.Msg.alert("提示","各项目的其中:新增赤字安排资金不能大于该项目本次发行金额！") ;
                            b = false;
                        }
                        if(parseFloat(Ext.util.Format.number(record.get('SQ_AMT'), '00000000.00'))
                            < parseFloat(Ext.util.Format.number(record.get('SQ_ZBJ_AMT'), '00000000.00'))){
                            Ext.Msg.alert("提示","各项目的专项债用作资本金不能大于该项目本次发行金额！") ;
                            b = false;
                        }
                    });
                    if(!b){
                        return;
                    }
                    if(srkm_value !='' && srkm_value !=undefined){
                        var SRKM_ID = zwsrkm_store.findNode('id', srkm_value, 0, false, true, true);
                        if( ZQLB_ID == '01' && SRKM_ID == null ){
                            Ext.Msg.alert('提示', "债券类型为“一般债券”时，债务收入科目只能选择“一般债务收入”");
                            return;
                        }
                        if( ZQLB_ID.indexOf('02') ==0 &&  SRKM_ID == null ){
                            Ext.Msg.alert('提示', "债券类型为“专项债券”时，债务收入科目只能选择“专项债务收入”");
                            return;
                        }
                        var code = SRKM_ID.get("code");
                        if( ZQLB_ID == '01' && "undefined" != typeof(code) && code.indexOf("1050401") != 0){
                            Ext.Msg.alert('提示', "债券类型为“一般债券”时，债务收入科目只能选择“一般债务收入”");
                            return;
                        }
                        if( ZQLB_ID.indexOf('02') ==0 && "undefined" != typeof(code) && code.indexOf("1050402") != 0){
                            Ext.Msg.alert('提示', "债券类型为“专项债券”时，债务收入科目只能选择“专项债务收入”");
                            return;
                        }
                    }
                    if(ZQLB_ID=='01'&&zj!=null&&zj>0) {
                        Ext.Msg.alert("提示","债券类型为一般债券时不可以录入专项债用作资本金！") ;
                        return;
                    }
                    if(ZQLB_ID!='01'&&czzj!=null&&czzj>0) {
                        Ext.Msg.alert("提示","债券类型为专项债券时不可以录入其中:新增赤字安排资金！") ;
                        return;
                    }

                    if(PLAN_AMT<zj) {
                        Ext.Msg.alert("提示","专项债用作资本金不能大于发行规模！") ;
                        return;
                    }
                    if(PLAN_AMT<czzj) {
                        Ext.Msg.alert("提示","其中:新增赤字安排资金不能大于发行规模！") ;
                        return;
                    }
                    saveYdjhInfo(btn);
                }
            },
            {
                //xtype: 'button',
                text: '取消',
                name: 'btn_delete',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        items: [
            initEditor()
        ]

    });
    return window;
}

/**
 * 生成主表
 */
function initEditor() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'init_ydfxjh_form',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        name: "YDJH_ID",
                        fieldLabel: '月度计划ID',
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "combobox",
                        id: 'YDJH_YEAR',
                        name: "YDJH_YEAR",   //项目立项年度
                        fieldLabel: '<span class="required">✶</span>计划年度',
                        fieldStyle: 'background:#E6E6E6',
                        store: DebtEleStoreDB('DEBT_YEAR'),
                        displayField: 'code',
                        valueField: 'id',
                        allowBlank: false,
                        value: nd_id.substr(0, 4),
                        editable: false,
                        readOnly: true
                    },
                    {
                        xtype: "combobox",
                        id: 'YDJH_MONTH',
                        name: "YDJH_MONTH",   //项目立项月份
                        fieldLabel: '<span class="required">✶</span>计划月份',
                        store: DebtEleStore(json_debt_yf),
                        displayField: 'name',
                        valueField: 'id',
                        value: nd_id.substr(4, 2),
                        allowBlank: false,
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        renderer: function (value) {
                            var array = json_debt_yf;
                            for (var i = 0; i < array.length; i++) {//遍历数组
                                var a = array[i];
                                if (a['id'] == value) {//通过数据库保存的基础数据id来获得对应的对象
                                    var store = a['name'];
                                    return store;//返回相对应id的name值
                                }
                            }
                        }
                    },
                    {
                        xtype: "datefield",
                        name: "JHFX_DATE",
                        fieldLabel: '计划发行时间',
                        format: 'Y-m-d',
                        editable: true, //禁用编辑
                        allowBlank: true,
                        // maxValue:new Date() ,
                        renderer: function (value) {
                            value = Ext.util.Format.date(value, 'Y-m-d');
                            return value;
                        }
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_NAME",
                        fieldLabel: '<span class="required">✶</span>债券名称',
                        allowBlank: false,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        maxLength: 199

                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_CODE",
                        fieldLabel: '债券编码',
                        //allowBlank: false,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        maxLength: 199
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLB_ID",
                        fieldLabel: '<span class="required">✶</span>债券类型',
                        store: zjlxStore,
                        rootVisible: false,
                        selectModel: 'leaf',
                        displayField: 'name',
                        valueField: 'id',
                        value: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? '0201': '01',
                        editable: false, //禁用编辑
                        allowBlank: false,
                        listeners: {
                            change: function (self,newValue,oldValue) {
                                getKmJcsj(newValue,true);
                                Ext.MessageBox.wait('正在获取债务收取科目数据..', '请等待..');
                                zwsrkm_store.load({
                                    callback : function() {
                                        Ext.MessageBox.hide();
                                    }
                                });
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "PLAN_AMT",
                        fieldLabel: '<span class="required">✶</span>发行规模（亿元）',
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        decimalPrecision: 6,
                        emptyText: '0.000000',
                        allowDecimals: true,
                        hideTrigger: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "PLAN_XZ_AMT",
                        fieldLabel: '新增债券金额（亿元）',
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 6,
                        emptyText: '0.000000',
                        allowDecimals: true,
                        hideTrigger: true,
                        listeners: {
                            'change': function (me, newValue) {
                                var form = me.up('window').down('form');
                                var amt = newValue;
                                var zrzzq_amt = form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').getValue();
                                if (zrzzq_amt != null && zrzzq_amt != "" && zrzzq_amt > 0) {
                                    amt += zrzzq_amt;
                                }
                                form.down('numberFieldFormat[name="PLAN_AMT"]').setValue(amt);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "PLAN_ZRZ_AMT",
                        fieldLabel: '再融资债券金额（亿元）',
                        fieldStyle: 'background:#E6E6E6',
                        editable: false,//禁用编辑
                        emptyText: '0.000000',
                        readOnly: true,
                        allowDecimals: true,
                        decimalPrecision: 9,
                        hideTrigger: true,
                        listeners: {
                            'change': function (me, newValue) {
                                var form = me.up('window').down('form');
                                var amt = newValue;
                                var xz_amt = form.down('numberFieldFormat[name="PLAN_XZ_AMT"]').getValue();
                                if (xz_amt != null && xz_amt != "" && xz_amt > 0) {
                                    amt += xz_amt;
                                }
                                form.down('numberFieldFormat[name="PLAN_AMT"]').setValue(amt);
                            }
                        }

                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZX_FX_AMT",
                        fieldLabel: '专项债用作资本金（亿元）',
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        emptyText: '0.000000',
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        allowBlank: true/*,
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6'*/
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "XZCZAP_AMT",
                        fieldLabel: '其中:新增赤字（亿元）',
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        emptyText: '0.000000',
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        allowBlank: true
                    },
                    {
                        xtype: "combobox",
                        name: "ZQQX_ID",
                        fieldLabel: '<span class="required">✶</span>债券期限',
                        store: DebtEleStoreDB("DEBT_ZQQX"),
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,//禁用编辑
                        allowBlank: false
                    },

                ]

            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "PCJH_ID",
                        fieldLabel: '<span class="required">✶</span>发行批次',
                        store: DebtEleStoreDB('DEBT_ZQPC', {condition: " and year like '" + nd_id.substr(0, 4) + "%'"}),
                        displayField: 'name',
                        valueField: 'id',
                        editable: false, //禁用编辑
                        allowBlank: false
                    },
                    {
                        xtype: "textfield",
                        name: "XYPJJG",
                        fieldLabel: '<span class="required">✶</span>信用评级结果',
                        hideTrigger: true,
                        maxLength: 18,
                        allowBlank:false

                    },
                    {
                        xtype: "combobox",
                        name: "HBFS_ID",
                        fieldLabel: '<span class="required">✶</span>还本方式',
                        store: DebtEleStoreDB('DEBT_HBFS'),
                        displayField: 'name',
                        valueField: 'id',
                        editable: false, //禁用编辑
                        allowBlank: false
                    },
                    {
                        xtype: "treecombobox",
                        name: "SRKM_ID",
                        store:DebtEleTreeStoreDB('DEBT_ZWSRKM',{condition:(IS_BZB=='2'?" AND CODE NOT LIKE '1050401%' ":" AND 1=1 ")+" and (code like '105%') and year = "+nowYear}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债务收入科目',
                        allowBlank:true,
                        selectModel:"leaf",
                        editable: false,

                    },
                    {
                        xtype: "textfield",
                        name: "ZQYT",
                        fieldLabel: '债券用途',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        columnWidth: .999,
                        maxLength: 49
                    },
                    {
                        xtype: 'textfield',
                        name: 'REMARK',
                        fieldLabel: '备注',
                        columnWidth: .999,
                        maxLength: 499
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                flex: 1,
                collapsible: false,
                layout: 'fit',
                items: [
                    initContentDetilGrid('add')//加载新增债券，再融资债券表信息
                ]
            }
        ]
    });
}
function getKmJcsj(newvalue,autoLoad) {
    if(newvalue=='01'){
        zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') and (code not like'1050402') and year = "+nowYear);
    }else{
        zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') and (code not like'1050401')and year = "+nowYear);
    }
    if(autoLoad) {
        getKmStoreLoad();
    }
}
function getKmStoreLoad() {
    zwsrkm_store.load();
}
/**
 * 创建债券选择弹出框
 */
function Set_chose_zq() {
    var window = Ext.create('Ext.window.Window', {
        title: '债券/债务选择', // 窗口标题
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
                handler: function (btn) {
                    var win_input = Ext.ComponentQuery.query('window[itemId="window_input"]');//录入窗口
                    var win_xm_sel = Ext.ComponentQuery.query('window[itemId="zq_sel"]');//债券选择窗口
                    if (win_xm_sel != null && win_xm_sel != undefined) {  //债券选择窗口存在
                        var grid = DSYGrid.getGrid('zrzzq_grid');
                        var sm = grid.getSelectionModel().getSelection();
                        if (sm.length < 1) {     //未选择债券
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            //获取已有债券表格
                            var addzqgrid = DSYGrid.getGrid('add_zrzzq_grid');
                            for (var i = 0; i < sm.length; i++) {
                                if (!ZQhave(i)) {//判断已有的再融资债券中是否已存在该id
                                    var xzzqData = sm[i].getData();
                                    xzzqData.SQ_AMT = sm[i].getData().SYSQ_AMT;
                                    addzqgrid.insertData(null, xzzqData);
                                    var sq_sum_amt = addzqgrid.getStore().sum('SQ_AMT');
                                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_ZRZ_AMT"]')[0].setValue(sq_sum_amt / 10000);
                                } else {
                                    return Ext.toast({
                                        html: "再融资债券中已包含该债券!",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }
                            }

                            checkGridStroe();
                            btn.up('window').close();
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
 * 加载债券选择内容
 */
function initWin_zqxz() {
    var zrz_dqyear = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_YEAR;
    var zrz_zqlb = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().ZQLB_ID;
    var ydjh_id = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_ID;
    var choose_zq = [
        /*{   xtype: 'combobox',
            fieldLabel: '到期年度',
            itemId:'zrz_dqyear',
            labelWidth: 60,
            width: 200,
            enableKeyEvents:true,
            displayField: 'code',
            valueField: 'id',
            store: DebtEleStore(json_debt_year)
        },*//*{   xtype: 'combobox',
            fieldLabel: '债券类型',
            labelWidth: 60,
            width: 260,
            itemId:'zrz_zqlb',
            enableKeyEvents:true,
            displayField: 'text',
            valueField: 'code',
            store: DebtEleTreeStoreDB('DEBT_ZQLB')
        },*/
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: 'ADD_ZQ_MH_SEL',
            labelWidth: 60,
            width: 280,
            enableKeyEvents: true,
            emptyText: '请输入债券/债务编码或债券/债务名称',
            displayField: 'code',
            valueField: 'id'
        },
        {
            xtype: "treecombobox",
            itemId: 'BATCH_NO',
            fieldLabel: '申报批次',
            labelWidth: 60,
            width: 280,
            store: DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND1 like '03%' OR EXTEND1 IS NULL) "}),
            displayField: 'name',
            valueField: 'id',
            editable: false, //禁用编辑
            allowBlank: false
        },
        {
            xtype: "treecombobox",
            name: "ZQLB_ID",
            fieldLabel: '债券/债务类型',
            store: zjlxStore,
            rootVisible: false,
            selectModel: 'leaf',
            displayField: 'name',
            valueField: 'id',
            value: zrz_zqlb,
            readOnly: true,
            fieldStyle: 'background:#E6E6E6',
            editable: false, //禁用编辑
            allowBlank: false
        },
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                loadZrzSelGrid()
            }
        }
    ];
    var Json = [
        {xtype: 'rownumberer', text: '序号', width: 50},
        {
            text: "再融资债券明细ID",
            class: "xmxz",
            dataIndex: "DATA_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {
            text: "区划code",
            class: "xmxz",
            dataIndex: "AD_CODE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {text: "债券ID", class: "xmxz", dataIndex: "ZQ_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
        {
            text: "债券/债务名称",
            class: "xmxz",
            dataIndex: "ZQ_NAME",
            width: 250,
            type: "string",
            fontSize: "15px",
            hidden: false,
            renderer: function (data, cell, record) {

                if (record.get('DATA_TYPE') == 'ZW') {
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    paramNames[1] = "zwlb_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                    paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE;
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            }
        },
        {
            text: "再融资申请总金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_AMT",
            width: 150,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.000000');
            },
        },
        {
            text: "剩余可申请金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.000000');
            },
        },
        {
            text: "债券/债务类型ID",
            class: "xmxz",
            dataIndex: "ZQLB_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {
            text: "债券/债务类型",
            class: "xmxz",
            dataIndex: "ZQLB_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "BATCH_NO",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "BATCH_NAME",
            width: 200,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "到期日期",
            class: "xmxz",
            dataIndex: "DQDF_DATE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "到期金额（万元）",
            class: "xmxz",
            dataIndex: "DQ_AMT",
            width: 150,
            type: "float",
            fontSize: "15px",
            hidden: false,
            // summaryType: 'sum',
            // summaryR
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        /*{text: "发行规模",class:"xmxz",dataIndex: "FX_AMT",width: 150,type: "float",fontSize: "15px",hidden:false},*/
        {text: "期限ID", class: "xmxz", dataIndex: "ZQQX_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
        {
            text: "期限",
            class: "xmxz",
            dataIndex: "ZQQX_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "利率(%)",
            class: "xmxz",
            dataIndex: "PM_RATE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "发行日期",
            class: "xmxz",
            dataIndex: "FX_START_DATE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zrzzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        dataUrl: '/ZQChooseGrid.action',
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
        params: {
            zrz_dqyear: zrz_dqyear,
            zrz_zqlb: zrz_zqlb,
            ydjh_id: ydjh_id,
            BUTTON_NAME: button_name
        }

    });
    return grid;
}

/**
 * 判断债券中是否已含有选中项
 */
function ZQhave(i) {
    var have = false;
    var selgrid = DSYGrid.getGrid('zrzzq_grid');
    var havegrid = DSYGrid.getGrid('add_zrzzq_grid');
    if (selgrid == null || selgrid == undefined || havegrid == null || havegrid == undefined) {
        return true;
    }
    var sel = selgrid.getSelection();
    for (var j = 0; j < havegrid.getStore().getCount(); j++) {
        if (sel[i].data["DATA_ID"] == havegrid.getStore().getAt(j).data["DATA_ID"] && sel[i].data["BATCH_NO"] == havegrid.getStore().getAt(j).data["BATCH_NO"]) {
            return true;
        }
    }
    return have;
}

/**
 * 创建项目选择弹出框
 */
function Set_chose_xm() {
    var window = Ext.create('Ext.window.Window', {
        title: '项目选择', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'xm_sel', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWin_xmxz()],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var win_input = Ext.ComponentQuery.query('window[itemId="window_input"]');//录入窗口
                    var win_xm_sel = Ext.ComponentQuery.query('window[itemId="xm_sel"]');//项目选择窗口
                    if (win_xm_sel != null && win_xm_sel != undefined) {  //项目选择窗口存在
                        var grid = DSYGrid.getGrid('xm_grid');
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
                        } else {
                            //判断是否进行防伪码校验
                            if(!checkSecuCodePlus(sm)){
                                return;
                            }
                            if ('1' == isCreateQRCode) {
                                //校验所选项目是否已经生成二维码，并且根据新项目信息新生成的校验码是否和原来的校验码一致
                                //已生成二维码且校验码一致才允许录入月度发行计划
                                checkXmQRCode(sm, btn);
                            } else {
                                var addgrid = DSYGrid.getGrid('add_xzzq_grid');
                                //获取已有债券表格
                                for (var i = 0; i < sm.length; i++) {
                                    if (!XMhave(i)) {//判断已有的项目中是否已存在该id
                                        var xzxmData = sm[i].getData();
                                        xzxmData.SQ_AMT = sm[i].getData().SYSQ_AMT;
                                        xzxmData.SQ_ZBJ_AMT = sm[i].getData().SYSQ_ZBJ_AMT;
                                        addgrid.insertData(null, xzxmData)
                                        var sq_sum_amt = addgrid.getStore().sum('SQ_AMT');
                                        var sq_amt=addgrid.getStore().sum('SQ_ZBJ_AMT');
                                        var xzczap_amt=addgrid.getStore().sum('XZCZAP_AMT');
                                        Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_XZ_AMT"]')[0].setValue(sq_sum_amt / 10000);
                                        Ext.ComponentQuery.query('numberFieldFormat[name="ZX_FX_AMT"]')[0].setValue(sq_amt / 10000);
                                        Ext.ComponentQuery.query('numberFieldFormat[name="XZCZAP_AMT"]')[0].setValue(xzczap_amt / 10000);
                                    } else {
                                        btn.up('window').close();
                                        return Ext.toast({
                                            html: "新增债券中该批次下已包含该项目!",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                    }
                                }

                                checkGridStroe();
                                btn.up('window').close();
                            }
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
 * 加载项目选择内容
 */
function initWin_xmxz() {
    var xm_zqlb = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().ZQLB_ID;
    var year = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_YEAR;
    //加载批次树
    var sbpc_store = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'xzzq_sbpcReflct.action?method=getSbpcTreeStore',
            extraParams: {
                BATCH_YEAR : year,
                BOND_TYPE : xm_zqlb.substr(0, 2),
                AD_CODE : AD_CODE,
                is_fxjh : 1,
                TYPE : 'xzzq'
            },
            reader: {
                type: 'json'
            }
        },
        root: {
            expanded: true,
            text: "全部",
            children: [
                {text: "需求批次", id:"需求批次", leaf: true}
            ]
        },
        model: 'treeModel',
        autoLoad: true
    });
    //项目选择条件
    var choose_xm = [
        {
            xtype: 'treecombobox',
            itemId: 'ADD_AD_CODE_SEL',
            fieldLabel: '区划',
            labelWidth: 30,
            width: 160,
            name: 'AD_CODE',
            enableKeyEvents: true,
            displayField: 'text',
            valueField: 'code',
            rootVisible: false,
            store: qhStore
        }, {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: 'ADD_XM_MH_SEL',
            labelWidth: 60,
            width: 200,
            enableKeyEvents: true,
            emptyText: '请输入项目编码或项目名称',
            displayField: 'code',
            valueField: 'id'
        },
        {
            fieldLabel: '申报批次',
            name: 'SBBATCH_NO',
            itemId: 'SBBATCH_NO',
            labelWidth: 60,
            width: 160,
            xtype: 'treecombobox',
            displayField: 'text',
            valueField: 'id',
            editable: false,//禁用编辑
            store:sbpc_store,
            allowBlank: false
        },
        {
            xtype: "combobox",
            itemId: 'ZQQX_ID',
            fieldLabel: '期限',
            labelWidth: 30,
            width: 140,
            store: DebtEleStoreDB("DEBT_ZQQX"),
            displayField: 'name',
            valueField: 'id',
            editable: false, //禁用编辑
            allowBlank: false
        },
        {
            xtype: "treecombobox",
            name: "ZQLB_ID",
            fieldLabel: '债券类型',
            labelWidth: 60,
            width: 160,
            store: zjlxStore,
            rootVisible: false,
            selectModel: 'leaf',
            displayField: 'name',
            hidden: true,
            valueField: 'id',
            value: xm_zqlb,
            readOnly: true,
            fieldStyle: 'background:#E6E6E6',
            editable: false, //禁用编辑
            allowBlank: false
        },
        {
            xtype: "combobox",
            itemId: 'XMZ_ID',
            fieldLabel: '项目组',
            labelWidth: 60,
            width: 160,
            store: DebtXmzStore(store_xmz),
            displayField: 'NAME',
            valueField: 'ID',
            editable: false, //禁用编辑
            allowBlank: GxdzUrlParam == eleAdCode ? true : false,
            hidden: GxdzUrlParam == eleAdCode ? false : true
        },
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                //刷新当前表格
                xmload();
            }
        }
    ];

    var Json = [
        {xtype: 'rownumberer', text: '序号', width: 50},
        {text: "明细单ID", class: "ty", dataIndex: "DATA_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
        {text: "地区code", class: "ty", dataIndex: "AD_CODE", width: 150, type: "string", fontSize: "15px", hidden: true},
        {text: "地区", class: "ty", dataIndex: "AD_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
        {text: "单位名称", class: "ty", dataIndex: "AG_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
        {text: "申报批次", class: "ty", dataIndex: "SBPC_CODE", width: 150, type: "string", fontSize: "15px", hidden: true},
        {text: "申报批次", class: "ty", dataIndex: "SBPC_NAME", width: 150, type: "string", fontSize: "15px", hidden: false},
        {text: "项目ID", class: "ty", dataIndex: "XM_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
        {
            text: "项目名称",
            class: "ty",
            dataIndex: "XM_NAME",
            width: 350,
            type: "string",
            fontSize: "15px",
            hidden: false,
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
            text: "本次发行金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_AMT",
            width: 150,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }

        },
        {
            text: "项目资本金金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_ZBJ_AMT",
            width: 180,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "其中:新增赤字（万元）",
            class: "xmxz",
            dataIndex: "XZCZAP_AMT",
            width: 180,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "剩余可申请金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_AMT",
            width: 180,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },
        {
            text: "剩余可申请资本金金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_ZBJ_AMT",
            width: 220,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        },

        {
            text: "项目类型",
            class: "ty",
            dataIndex: "XMLX_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "项目性质",
            class: "xmxz",
            dataIndex: "XMXZ_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden:true
        },
        {
            text: "立项年度",
            class: "xmxz",
            dataIndex: "LX_YEAR",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {
            text: "建设性质",
            class: "xmxz",
            dataIndex: "JSXZ_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden:true
        },
        {
            text: "建设状态",
            class: "xmxz",
            dataIndex: "BUILD_STATUS_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false
        },
        {text: "项目二维码", class: "ty", dataIndex: "QR_ID", width: 150, type: "string", fontSize: "15px", hidden: true},
        {
            text: "项目校验码",
            class: "xmxz",
            dataIndex: "VERICODE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true
        }
    ];
    var xm_dqyear = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_YEAR;
    var xm_dqmonth = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_MONTH;
    var ydjh_id = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_ID;
    var SBBATCH = Ext.ComponentQuery.query('treecombobox[itemId="SBBATCH_NO"]');
    var SBBATCH_NO = SBBATCH.length > 0 ? SBBATCH[0].value : "";
    var xmz = Ext.ComponentQuery.query('combobox[itemId="XMZ_ID"]');
    var xmz_id = xmz.length > 0 ? xmz[0].value : null;
    var grid = DSYGrid.createGrid({
        itemId: 'xm_grid',
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        dataUrl: 'XMChooseGrid.action',
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
                items: choose_xm
            }
        ],
        params: {
            xm_dqyear: xm_dqyear,
            xm_dqmonth:xm_dqmonth,
            xm_zqlb: xm_zqlb,
            YDJH_ID: ydjh_id,
            SBBATCH_NO: SBBATCH_NO,
            BUTTON_NAME: button_name,
            XMZ_ID: xmz_id
        }

    });
    return grid;
}

/**
 * 判断项目中是否已含有选中项
 */
function XMhave(i) {
    var have = false;
    var selgrid = DSYGrid.getGrid('xm_grid');
    var havegrid = DSYGrid.getGrid('add_xzzq_grid');
    if (selgrid == null || selgrid == undefined || havegrid == null || havegrid == undefined) {
        return true;
    }
    var sel = selgrid.getSelection();
    for (var j = 0; j < havegrid.getStore().getCount(); j++) {
        //由原先不能选同一个发行库项目改为不能选同一批次下的相同项目
        if (sel[i].data["XM_ID"] == havegrid.getStore().getAt(j).data["XM_ID"]
           && sel[i].data["SBPC_CODE"] == havegrid.getStore().getAt(j).data["SBPC_CODE"] ) {
            return true;
        }
    }
    return have;
}

/**
 * 保存月度发行计划信息
 */
function saveYdjhInfo(btn) {
    // 获取录入弹出框中主表信息
    var form = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0];
    var formdate = form.getForm().getFieldValues();
    if (!form.isValid()) {
        Ext.Msg.alert('提示', '请检查必填项是否填写完整！');
        return false;
    }
    // 主表信息验证
    if (formdate.PLAN_AMT == null || formdate.PLAN_AMT == undefined || formdate.PLAN_AMT == "" || Number(formdate.PLAN_AMT) < 0) {
        Ext.Msg.alert('提示', "发行规模金额应大于零！");
        return;
    }
    if (formdate.JHFX_DATE != null && formdate.JHFX_DATE != undefined && formdate.JHFX_DATE != "") {
        var xzzq_year = Ext.util.Format.date(formdate.JHFX_DATE, 'Y');
        var xzzq_month = Ext.util.Format.date(formdate.JHFX_DATE, 'm');
        var xzzq_day = Ext.util.Format.date(formdate.JHFX_DATE, 'd');
        if (xzzq_year != formdate.YDJH_YEAR || xzzq_month != formdate.YDJH_MONTH) {
            Ext.Msg.alert('提示', "计划发行时间应选择当月日期！");
            return;
        }
        formdate.JHFX_DATE = xzzq_year + "-" + xzzq_month + "-" + xzzq_day;
    }

    // 获取新增债券信息
    var xzzqgrid = DSYGrid.getGrid('add_xzzq_grid').getStore();
    if (xzzqgrid.getCount() > 0 && (formdate.PLAN_XZ_AMT == null || formdate.PLAN_XZ_AMT == undefined || formdate.PLAN_XZ_AMT == "" || Number(formdate.PLAN_XZ_AMT) <= 0)) {
        Ext.Msg.alert('提示', "新增债券金额应大于零！");
        return;
    }
    //新增债券信息校验
    var xzzq_store_data = new Array();
    for (var i = 0; i < xzzqgrid.getCount(); i++) {
        var xzzq = xzzqgrid.getAt(i);
        if (parseFloat(Ext.util.Format.number(xzzq.get("SQ_AMT"), '00000000.00')) >
            parseFloat(Ext.util.Format.number(xzzq.get("SYSQ_AMT"), '00000000.00'))) {
            Ext.Msg.alert('提示', xzzq.get("XM_NAME") + "申请金额超过了剩余可申请金额！");
            return;
        }
        if (parseFloat(Ext.util.Format.number(xzzq.get("SQ_AMT"), '00000000.00')) >
            parseFloat(Ext.util.Format.number(xzzq.get("SURPLUS_AMOUNT")+xzzq.get("SQ_AMT_OLD"), '00000000.00'))) {
            Ext.Msg.alert('提示', xzzq.get("XM_NAME") + "申请金额超过了剩余待发行金额！");
            return;
        }
        if (parseFloat(Ext.util.Format.number(xzzq.get("SQ_ZBJ_AMT"), '00000000.00'))  >
            parseFloat(Ext.util.Format.number(xzzq.get("SYSQ_ZBJ_AMT"), '00000000.00'))) {
            Ext.Msg.alert('提示', xzzq.get("XM_NAME") + "项目资本金金额超过了剩余可申请资本金金额！");
            return;
        }
        xzzq_store_data.push(xzzq.data);
    }
    //获取再融资债券信息
    var zrzzqgrid = DSYGrid.getGrid('add_zrzzq_grid').getStore();
    if (zrzzqgrid.getCount() > 0 && (formdate.PLAN_ZRZ_AMT == null || formdate.PLAN_ZRZ_AMT == undefined || formdate.PLAN_ZRZ_AMT == "" || Number(formdate.PLAN_ZRZ_AMT) <= 0)) {
        Ext.Msg.alert('提示', "再融资债券金额应大于零！");
        return;
    }
    //再融资债券信息校验
    var zrzzq_store_data = new Array();
    for (var i = 0; i < zrzzqgrid.getCount(); i++) {
        var zrzzq = zrzzqgrid.getAt(i);
        if (formdate.ZQLB_ID.substring(0, 2) != zrzzq.get("ZQLB_ID")) {
            Ext.Msg.alert('提示', "债券类型不一致！");
            return;
        }
        if (zrzzq.get("SQ_AMT") > zrzzq.get("SYSQ_AMT")) {
            Ext.Msg.alert('提示', zrzzq.get("ZQ_NAME") + "申请金额超过了剩余可申请金额！");
            return;
        }
        zrzzq_store_data.push(zrzzq.data);
    }

    var ids = new Array();
    if (button_name == 'update') {
        YDJH_ID = DSYGrid.getGrid('contentGrid').getSelection()[0].data["YDJH_ID"];
        ids.push(YDJH_ID);
    }
    // //专项债：发布
    // if(IS_ZXZQXT_FX == 2 && is_zxzqfb == 1){
    //     checkdqxe(btn,ids,formdate,xzzq_store_data,zrzzq_store_data);
    // }else{
    //
    // }
    save(btn, ids, formdate, xzzq_store_data, zrzzq_store_data);
}

function checkdqxe(btn, ids, formdate, xzzq_store_data, zrzzq_store_data) {
    $.post('checkDQXE.action', {
        YDJH_YEAR: formdate.YDJH_YEAR,
        XZZQ_STORE: Ext.util.JSON.encode(xzzq_store_data)
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        } else {
            save(btn, ids, formdate, xzzq_store_data, zrzzq_store_data);
        }
    }, 'JSON');
}

function save(btn, ids, formdate, xzzq_store_data, zrzzq_store_data) {
    $.post('saveYdfxjhInfo.action', {
        button_name: button_name,//录入还是修改
        ids: Ext.util.JSON.encode(ids),
        YDJH_ID: formdate.YDJH_ID,
        YDJH_YEAR: formdate.YDJH_YEAR,
        YDJH_MONTH: formdate.YDJH_MONTH,
        ZQ_NAME: formdate.ZQ_NAME,
        ZQ_CODE: formdate.ZQ_CODE,
        ZQLB_ID: formdate.ZQLB_ID,
        JHFX_DATE: formdate.JHFX_DATE,
        PCJH_ID: formdate.PCJH_ID,
        PLAN_AMT: formdate.PLAN_AMT,
        PLAN_XZ_AMT: formdate.PLAN_XZ_AMT,
        PLAN_ZRZ_AMT: formdate.PLAN_ZRZ_AMT,
        ZQYT: formdate.ZQYT,
        XYPJJG: formdate.XYPJJG,
        HBFS_ID: formdate.HBFS_ID,
        ZQQX_ID: formdate.ZQQX_ID,
        REMARK: formdate.REMARK,
        SRKM_ID:formdate.SRKM_ID,
        ZX_FX_AMT: formdate.ZX_FX_AMT,
        XZCZAP_AMT: formdate.XZCZAP_AMT,
        XZZQ_STORE: Ext.util.JSON.encode(xzzq_store_data),
        ZRZZQ_STORE: Ext.util.JSON.encode(zrzzq_store_data)
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
            reloadGrid()
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
    }, 'JSON');
}

/**
 * 债券类型校验：如果新增项目和再融资债券页签存在数据，则表单中的债券类型不能更改
 */
function checkGridStroe() {
    //var zqhzStore = DSYGrid.getGrid('itemId_add_zqhz').getStore();
    var xzxmStore = DSYGrid.getGrid('add_xzzq_grid').getStore();
    var zrzStore = DSYGrid.getGrid('add_zrzzq_grid').getStore();
    if (/*zqhzStore.getData().length > 0 || */xzxmStore.data.length > 0 || zrzStore.data.length > 0) {
        Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].readOnly = true;
        Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].setFieldStyle("background:#E6E6E6");
    } else {
        Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].readOnly = false;
        Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].setFieldStyle("background:#FFFFFF");
    }
}

/**
 * 刷新再融资债券选择页面
 */
function loadZrzSelGrid() {
    var grid = DSYGrid.getGrid('zrzzq_grid');
    var store = grid.getStore();
    store.removeAll();
    var zrz_dqyear = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_YEAR;
    var zrz_month = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_MONTH;
    var zrz_zqlb = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().ZQLB_ID;
    var ydjh_id = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_ID;
    var zrz_mh = Ext.ComponentQuery.query('textfield#ADD_ZQ_MH_SEL')[0].getValue();
    var BATCH_NO = Ext.ComponentQuery.query('treecombobox[itemId="BATCH_NO"]')[0].value;
    /*if(Ext.ComponentQuery.query('combobox#zrz_dqyear')==null || Ext.ComponentQuery.query('combobox#zrz_dqyear') == undefined){
        zrz_dqyear=null;
    }else{
        zrz_dqyear=Ext.ComponentQuery.query('combobox#zrz_dqyear')[0].getValue();
    }*/
    if (zrz_zqlb == null || zrz_zqlb == undefined) {
        zrz_zqlb = null;
    }
    if (zrz_mh == null || zrz_mh == undefined) {
        zrz_mh = null;
    }
    store.getProxy().extraParams = {
        BUTTON_NAME: button_name,
        zrz_dqyear: zrz_dqyear,
        zrz_dqmonth: zrz_month,
        ydjh_id: ydjh_id,
        zrz_zqlb: zrz_zqlb,
        zrz_mh: zrz_mh,
        BATCH_NO: BATCH_NO
    };
    //刷新
    store.loadPage(1);
}

/**
 * 刷新项目列表
 */
function xmload() {
    var gridold = DSYGrid.getGrid('xm_grid');
    var store = gridold.getStore();
    store.removeAll();
    var adsel = Ext.ComponentQuery.query('treecombobox[itemId="ADD_AD_CODE_SEL"]');
    var AD_CODE = adsel.length > 0 ? adsel[0].value : "";
    var mh = Ext.ComponentQuery.query('textfield[itemId="ADD_XM_MH_SEL"]');
    var mhsel = mh.length > 0 ? mh[0].value : null;
    var xm_dqyear = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_YEAR;
    var xm_dqmonth = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_MONTH;
    var xm_zqlb = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().ZQLB_ID;
    var ydjh_id = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_ID;
    var SBBATCH = Ext.ComponentQuery.query('treecombobox[itemId="SBBATCH_NO"]');
    var xmz = Ext.ComponentQuery.query('combobox[itemId="XMZ_ID"]');
    var xmz_id = xmz.length > 0 ? xmz[0].value : null;
    var SBBATCH_NO = SBBATCH.length > 0 ? SBBATCH[0].value : "";
    var zqqx =Ext.ComponentQuery.query('combobox[itemId="ZQQX_ID"]');
    var zqqx_id = zqqx.length > 0 ? zqqx[0].value : null;
    store.getProxy().extraParams = {
        BUTTON_NAME: button_name,
        AD_CODE: AD_CODE,
        xm_dqyear: xm_dqyear,
        xm_dqmonth:xm_dqmonth,
        YDJH_ID: ydjh_id,
        xm_zqlb: xm_zqlb,
        mhsel: mhsel,
        SBBATCH_NO: SBBATCH_NO,
        ZQQX_ID:zqqx_id,
        XMZ_ID:xmz_id
    };
    // 刷新
    store.loadPage(1);
}

/**
 * 刷新主界面
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    var YDJH_YEAR = nd_id.substr(0, 4);
    var YDJH_MONTH = nd_id.substr(4, 2);
    store.getProxy().extraParams = {
        YDJH_YEAR: YDJH_YEAR,
        YDJH_MONTH: YDJH_MONTH,
        IS_ZXZQXT_FX: IS_ZXZQXT_FX,
        IS_FB: IS_FB,
        IS_ZXZQFB: is_zxzqfb,
        NDKZ: ndkz
    };
    store.loadPage(1);
    /*if ((IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1) {
        DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = "";
        DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['ZQLX_ID'] = "";
        DSYGrid.getGrid('itemId_sy_zqhz').getStore().removeAll();
        DSYGrid.getGrid('itemId_sy_zqhz').getStore().loadPage(1);
    }*/
    //刷新明细表

    DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['YDJH_ID'] = "";
    DSYGrid.getGrid('sy_xzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "";
    DSYGrid.getGrid('sy_xzzq').getStore().removeAll();
    DSYGrid.getGrid('sy_xzzq').getStore().loadPage(1);
    DSYGrid.getGrid('sy_zrzzq').getStore().getProxy().extraParams['YDJH_ID'] = "";
    DSYGrid.getGrid('sy_zrzzq').getStore().getProxy().extraParams['ZQLX_ID'] = "";
    DSYGrid.getGrid('sy_zrzzq').getStore().removeAll();
    DSYGrid.getGrid('sy_zrzzq').getStore().loadPage(1);

}

/**
 * 校验项目是否生成二维码
 */
function checkXmQRCode(records, btn) {
    if (records == null || !Array.isArray(records)) {
        Ext.Msg.alert('提示', '传入的数组为空或者传入的不是一个数组！');
        return;
    }
    var xmInfos = [];
    records.forEach(function (record) {
        var xmInfo = {};
        xmInfo.XM_ID = record.get("XM_ID");
        xmInfo.QR_ID = record.get("QR_ID");
        xmInfo.XM_CODE = record.get("XM_CODE");
        xmInfo.XM_NAME = record.get("XM_NAME");
        xmInfo.VERICODE = record.get("VERICODE");
        xmInfos.push(xmInfo);
    });
    Ext.Ajax.request({
        method: 'POST',
        async: true,
        timeout: 6000,
        params: {
            xmInfos: Ext.JSON.encode(xmInfos)
        },
        url: 'checkXmQRCode.action',
        success: function (response, opts) {
            var data = Ext.JSON.decode(response.responseText);
            if (data.success) {
                var sm = records;
                var addgrid = DSYGrid.getGrid('add_xzzq_grid');//获取已有债券表格
                for (var i = 0; i < sm.length; i++) {
                    if (!XMhave(i)) {//判断已有的项目中是否已存在该id
                        var xzxmData = sm[i].getData();
                        xzxmData.SQ_AMT = sm[i].getData().SYSQ_AMT;
                        xzxmData.SQ_ZBJ_AMT = sm[i].getData().SYSQ_ZBJ_AMT;
                        addgrid.insertData(null, xzxmData);
                        var sq_sum_amt = addgrid.getStore().sum('SQ_AMT');
                        var sq_amt=addgrid.getStore().sum('SQ_ZBJ_AMT');
                        Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_XZ_AMT"]')[0].setValue(sq_sum_amt / 10000);
                        Ext.ComponentQuery.query('numberFieldFormat[name="ZX_FX_AMT"]')[0].setValue(sq_amt / 10000);
                    } else {
                        return Ext.toast({
                            html: "新增债券中该批次下已包含该项目!",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    }
                    btn.up('window').close();
                }
                //第二步
                checkGridStroe();
            } else {
                Ext.Msg.alert('提示', data.message);
            }
        },
        failure: function (reponse, opts) {
            Ext.Msg.alert("校验失败！" + response.status);
        }
    });


}

function updateIsfb(btn) {
    var updbtn_name = btn.name;
    var updbtn_text = btn.text;
    var recordData = DSYGrid.getGrid('contentGrid').getSelection();
    if (recordData.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一笔月度计划！');
        return;
    }
    var fxglArray = [];
    Ext.each(recordData, function (record) {
        var array = {};
        array.YDJH_ID = record.get("YDJH_ID");
        fxglArray.push(array);
    });
    $.ajax({
        type: "POST",
        url: 'updYdjhIsfb.action',
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


    // $.post("/updYdjhIsfb.action", {
    //     btn_name:btn_name,
    //     records: records
    // }, function (data) {
    //     if (data.success) {
    //         Ext.toast({
    //             html: btn_name + "成功！",
    //             closable: false,
    //             align: 't',
    //             slideInDuration: 400,
    //             minWidth: 400
    //         });
    //     } else {
    //         Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
    //     }
    //     //刷新表格
    //     // reloadGrid();
    // }, "json");


    // Ext.Ajax.request({
    //     method:'POST',
    //     async:true,
    //     timeout:6000,
    //     params:{
    //         btn_name:btn_name,
    //         records: records
    //
    //     },
    //     url:'updYdjhIsfb.action',
    //     success:function(response,opts){
    //
    //     },
    //     failure:function(reponse,opts){
    //         Ext.Msg.alert("修改失败！");
    //     }
    // });
}