// 表格检索 状态下拉 所需数据
var status_seach_json = [
    {"id": "0", "code": "0", "name": "未发布"},
    {"id": "1", "code": "1", "name": "已发布"}
];
// 指标类型
var zblx_seach_json = [
    {"id": "01", "code": "01", "name": "共性指标"},
    {"id": "02", "code": "02", "name": "个性指标"}
]

// 工具栏按钮所需数据
var toolbarItems = [
    {
        xtype: 'button',
        text: '查询',
        name: 'search',
        icon: '/image/sysbutton/search.png',
        handler: function (btn) {
            searchZb(btn);//点击查询时的方法
        }
    },
    {
        xtype: 'button',
        text: '发布',
        name: 'appoint',
        icon: '/image/sysbutton/add.png',
        handler: function (btn) {
            appoint(btn);
        }
    },
    {
        xtype: 'button',
        text: '撤销发布',
        name: 'cancelAppoint',
        hidden: true,
        icon: '/image/sysbutton/edit.png',
        handler: function (btn) {
            cancelAppoint(btn);
        }
    },
    '->',
    initButton_OftenUsed(),
    initButton_Screen()
];

/**
 * 页面加载方法
 */
$(document).ready(function () {
    initContent();
});

/**
 * 初始化主界面方法
 */
function initContent() {
    //创建主面板
    var panel = Ext.create('Ext.panel.Panel', {
        renderTo: Ext.getBody(),
        layout: 'border',
        defaults: {
            split: true,//是否有分割线
            collapsible: false//是否可以折叠
        },
        width: '100%',
        height: '100%',
        border: 'true',
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: toolbarItems
            }
        ],
        items: [
            {
                xtype: 'treepanel',
                itemId: 'zbtxTree',
                region: 'west',//在边界布局的西边
                flex: 1,//占全部的1份
                height: '100%',
                width: '20%',
                store: initZbtxTree(),
                rootVisible: false,
                listeners: {
                    itemclick: function (self, record, item, index, e) {
                        // 如果点击的是项目类型的节点，不进行操作
                        var code = record.get('code').toString();
                        // 赋值全局变量
                        setTreeNode(record);
                        // 刷新表格
                        reloadGrid();
                    },
                    afterrender: function (self) {
                        afterInitTree();
                    }
                }
            },
            {
                xtype: 'panel',
                itemId: 'rightContentPanel',
                height: '100%',
                width: '100%',
                flex: 5,
                region: 'center',
                layout: {
                    type: 'vbox',
                    align: 'stretch',
                    flex: 1
                },
                border: false,
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        dock: 'top',
                        layout: {
                            type: 'column'
                        },
                        defaults: {
                            margin: '5 5 5 0',
                            columnWidth: .20,
                            labelWidth: 100,
                            labelAlign: 'left'//控件默认标签对齐方式
                        },
                        items: [
                            {
                                xtype: "combobox",
                                fieldLabel: "指标年度",
                                name: "FISCAL_YEAR",
                                id: "FISCAL_YEAR",
                                editable: false,
                                displayField: 'name',
                                labelAlign: "left",
                                labelWidth: 65,//设置宽度
                                columnWidth: .15,
                                valueField: 'code',
                                allowBlank: false,
                                value: CURRENT_YEAR,
                                store: DebtEleStore(getYearList({start: 0, end: 10})),
                                listeners: {
                                    change: function (self, newValue, oldValue) {
                                        // 根据年度变化，刷新左侧树
                                        CURRENT_YEAR = newValue;
                                        reloadTree();
                                        reloadGrid();
                                    }
                                }
                            },
                            {
                                xtype: "treecombobox",
                                name: "XMLX_ID",
                                id: 'SEARCH_XMLX_ID',
                                fieldLabel: '项目类型',
                                labelWidth: 60,
                                displayField: 'name',
                                valueField: 'id',
                                hidden: false,
                                lines: false,
                                editable: false,
                                store: DebtEleTreeStoreDBTable("DSY_V_ELE_JXZBK_ZWXMLX"),
                                listeners: {
                                    select: function (obj) {
                                        var xmlx = obj.getValue();
                                        var xmlxName = obj.rawValue;
                                        XMLX_ID_SEL = xmlx;
                                        XMLX_NAME_SEL = xmlxName;
                                        reloadTree();
                                        reloadGrid();
                                    }
                                }
                            },
                            {
                                xtype: "textfield",
                                labelWidth: 60,
                                fieldLabel: '模糊查询',
                                name: 'KEYINFO',
                                id: 'SEARCH_KEYINFO',
                                emptyText: '输入指标编码/指标名称',
                                enableKeyEvents: true,
                                listeners: {
                                    'specialkey': function (self, e) {
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                            var content = self.getValue();
                                            INDCODEORNAME = content;
                                            reloadGrid();
                                        }
                                    }
                                }
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: "指标类型",
                                name: "ZBLX_ID",
                                id: 'SEARCH_ZBLX_ID',
                                editable: false,
                                displayField: 'name',
                                labelAlign: "right",
                                labelWidth: 60,
                                valueField: 'code',
                                allowBlank: true,
                                hidden: true,//隐藏，不用此条件
                                store: DebtEleStore(zblx_seach_json),
                                listeners: {
                                    change: function (self) {
                                        var zblx = self.getValue();
                                        /*if (zblx != "all") {
                                            ZBLX_ID = zblx;
                                        } else {
                                            ZBLX_ID = "";
                                        }*/
                                        ZBLX_ID = zblx;
                                        reloadGrid();
                                    }
                                }
                            }
                        ]
                    }
                ],
                items: [
                    initZbDetailTable()
                ]
            }
        ]
    });
}

/**
 * 左侧指标体系树-初始化方法
 */
function initZbtxTree() {
    Ext.define('zbtxTreeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'code'},
            {name: 'id'},
            {name: 'leaf'}
        ]
    });
    var xmlxStore = Ext.create('Ext.data.TreeStore', {
        model: 'zbtxTreeModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getZbtxTreeData.action',
            extraParams: {"year": CURRENT_YEAR, "IND_TYPE": IND_TYPE, "XMLX_ID": XMLX_ID_SEL},
            reader: {
                type: 'json'
            }
        },
        root: {text: '全部指标', code: 'root', id: 'root'},//若数据获取错误，则默认显示该根节点
        autoLoad: true
    });
    return xmlxStore;
}

/**
 * 右侧指标体系详情表格-初始化方法
 */
function initZbDetailTable() {
    var headerJson = [
        {xtype: 'rownumberer', width: 38},
        {dataIndex: "MOF_DIV_NAME", type: "string", text: "地区", align: "left", width: 80},
        {dataIndex: "IND_CODE", type: "string", text: "指标编码", align: "left", width: 80},
        {dataIndex: "IND_NAME", type: "string", text: "指标名称", align: "left", width: 160},
        {dataIndex: "LEVEL_NAME", type: "string", text: "指标级别", align: "left", width: 80},
        {dataIndex: "IS_LEAF_TEXT", type: "string", text: "是否末级", align: "left", width: 80},
        {dataIndex: "PARENT_NAME", type: "string", text: "上级指标", align: "left", width: 160},
        {dataIndex: "ZBLX_NAME", type: "string", text: "指标类型", align: "left", width: 80},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", align: "left", width: 120},
        {dataIndex: "FULL_VALUE", type: "string", text: "指标满分值", align: "right", width: 100},
        {dataIndex: "WEIGHT_VALUE", type: "string", text: "权重（%）", align: "right", width: 110, hidden: true},
        {
            dataIndex: "DLDW_NAME",
            type: "string",
            text: "度量单位",
            align: "left",
            width: 90,
            hidden: IND_TYPE == 2 ? false : true
        },
        {
            dataIndex: "TV_TYPE_NAME",
            type: "string",
            text: "目标值类型",
            align: "left",
            width: 90,
            hidden: IND_TYPE == 2 ? false : true
        },
        {dataIndex: "PFBZ", type: "string", text: "指标解释", align: "left", width: 300},
        {dataIndex: "ZBSM", type: "string", text: "指标说明", align: "left", width: 300}
    ];
    var detailTable = DSYGrid.createGrid({
        itemId: 'zbGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        params: {
            AD_CODE: AD_CODE,
            IND_ID: TREE_IND_ID,
            IND_CODE: TREE_IND_CODE,
            year: CURRENT_YEAR,
            IND_TYPE: IND_TYPE,
            XMLX_ID: XMLX_ID_SEL,
            xdStatus: 0
        },
        rowNumber: true,
        border: false,
        autoLoad: true,
        height: '100%',
        width: '100%',
        flex: 1,
        dataUrl: 'getZbtxGridData.action',
        tbar: [
            {
                xtype: "combobox",
                fieldLabel: "状态",
                name: "STATUS",
                id: 'SEARCH_STATUS',
                editable: false,
                displayField: 'name',
                labelAlign: "right",
                width: 135,
                labelWidth: 30,
                valueField: 'code',
                allowBlank: true,
                value: '0',
                store: DebtEleStore(status_seach_json),
                listeners: {
                    change: function (self) {
                        var selectStatus = self.getValue();
                        XDSTATUS = selectStatus;
                        hiddenBtn();
                        reloadGrid();
                    }
                }
            }
        ],
        pageConfig: {
            pageNum: true,//设置显示每页条数
            pageSize: 100
        }
    });

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
            detailTable
        ]
    });
}

/**
 *  点击树时，进行全局变量赋值
 */
function setTreeNode(record) {
    if (!!record) {
        TREE_IND_ID = record.get('id');
        TREE_IND_CODE = record.get('code');
    }
}

/**
 *  在树构造完成后，选中根节点
 */
function afterInitTree() {
    var treePanel = Ext.ComponentQuery.query('treepanel#zbtxTree')[0];
    //获取所有根节点
    var rootNode = treePanel.getRootNode();
    //若第一个根节点存在
    if (rootNode.getChildAt(0)) {
        var record = rootNode.getChildAt(0);
        //设置选中第一个根节点
        treePanel.getSelectionMode().select(record);
        //配置全局变量
        setTreeNode(record);
        //刷新表格
        //reloadGrid();
    }
}

/**
 *  查询方法
 */
function searchZb() {
    hiddenBtn();
    reloadGrid();
    reloadTree();
}

/**
 *  根据下达状态联动隐藏/显示撤销下达按钮
 */
function hiddenBtn() {
    if (XDSTATUS == "1") {
        Ext.ComponentQuery.query('button[name="cancelAppoint"]')[0].setHidden(false);
        Ext.ComponentQuery.query('button[name="appoint"]')[0].setHidden(true);
    } else if (XDSTATUS == "0") {
        Ext.ComponentQuery.query('button[name="cancelAppoint"]')[0].setHidden(true);
        Ext.ComponentQuery.query('button[name="appoint"]')[0].setHidden(false);
    } else {
        Ext.ComponentQuery.query('button[name="cancelAppoint"]')[0].setHidden(true);
        Ext.ComponentQuery.query('button[name="appoint"]')[0].setHidden(true);
    }
}

/**
 *  下达
 */
function appoint() {
    // 如果没有数据，发布时给出提示
    if (!isCanAppoint(1)) {
        return;
    }
    // 下达前校验是否已经下达过
    var flag = false;
    $.ajax({
        url: "getZbtxGridData.action",
        dataType: "json",
        type: "POST",
        data: {
            xdStatus: 1,
            AD_CODE: AD_CODE,
            year: CURRENT_YEAR,
            IND_TYPE: IND_TYPE,
            XMLX_ID: XMLX_ID_SEL
        },
        async: false,
        success: function (data) {
            if (parseInt(data.totalcount) > 0) {
                flag = true;
            }
        }
    })
    if (flag) {
        Ext.MessageBox.alert('提示', '检测到已经发布过指标，请先撤销发布后再重新进行指标校验并发布！');
        return;
    }
    var msgTitleUnSel = '将发布当前年度所有绩效' + (IND_TYPE == 1 ? '评价' : '目标') + '指标，请确认是否发布！';
    var msgTitleSel = '将发布' + XMLX_NAME_SEL + '类型下所有绩效' + (IND_TYPE == 1 ? '评价' : '目标') + '指标，请确认是否发布！';
    Ext.Msg.confirm('提示', isNull(XMLX_ID_SEL) ? msgTitleUnSel : msgTitleSel, function (btn_confirm) {
        if (btn_confirm == 'yes') {
            Ext.MessageBox.wait('正在校验中...');
            //发送ajax请求
            $.post("updateZbXdStatus.action", {
                IS_XD: 1,
                IND_TYPE: IND_TYPE,
                year: CURRENT_YEAR,
                XMLX_ID: XMLX_ID_SEL
            }, function (data) {
                Ext.MessageBox.hide();
                if (data.success) {
                    Ext.toast({
                        html: "发布成功",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    // 刷新表格
                    reloadGrid();
                    //刷新数
                    Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
                } else {
                    Ext.MessageBox.alert('提示', '发布失败</br>' + data.message);
                }
            }, "json");
        }
    });
}

/**
 *  撤销下达
 */
function cancelAppoint() {
    // 如果没有数据，撤销发布时给出提示
    if (!isCanAppoint(2)) {
        return;
    }
    var msgTitleUnSel = '将撤销发布当前年度所有绩效' + (IND_TYPE == 1 ? '评价' : '目标') + '指标，请确认是否撤销！';
    var msgTitleSel = '将撤销发布' + XMLX_NAME_SEL + '类型下所有绩效' + (IND_TYPE == 1 ? '评价' : '目标') + '指标，请确认是否撤销！';
    Ext.Msg.confirm('提示', isNull(XMLX_ID_SEL) ? msgTitleUnSel : msgTitleSel, function (btn_confirm) {
        if (btn_confirm == 'yes') {
            //发送ajax请求
            $.post("updateZbXdStatus.action", {
                IS_XD: 0,
                IND_TYPE: IND_TYPE,
                year: CURRENT_YEAR,
                XMLX_ID: XMLX_ID_SEL
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: "撤销成功",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    // 刷新表格
                    reloadGrid();
                    //刷新数
                    Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
                } else {
                    Ext.MessageBox.alert('提示', '撤销失败' + data.message);
                }
            }, "json");
        }
    });
}

/**
 * 刷新表格
 */
function reloadGrid() {
    var SEARCH_STATUS = Ext.getCmp('SEARCH_STATUS').getValue();
    var SEARCH_ZBLX_ID = Ext.getCmp('SEARCH_ZBLX_ID').getValue();
    var SEARCH_KEYINFO = Ext.getCmp('SEARCH_KEYINFO').getValue();
    var store = DSYGrid.getGrid('zbGrid').getStore();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        IND_ID: TREE_IND_ID,
        IND_CODE: TREE_IND_CODE,
        INDCODEORNAME: SEARCH_KEYINFO,
        xdStatus: SEARCH_STATUS,
        ZBLX_ID: SEARCH_ZBLX_ID,
        year: CURRENT_YEAR,
        IND_TYPE: IND_TYPE,
        XMLX_ID: XMLX_ID_SEL
    };
    store.loadPage(1);
}

/**
 * 刷新左侧树
 * @param params 查询条件对象
 * @return void
 * @author Jiafy 2021/08/10
 */
function reloadTree(params) {
    var extraParams = {
        year: CURRENT_YEAR,
        XMLX_ID: XMLX_ID_SEL,
        IND_TYPE: IND_TYPE
    };
    var leftTree = Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore();
    // 参数拼接
    if (!!params) {
        extraParams = $.extend(true, {}, extraParams, params);
    }
    leftTree.proxy.extraParams = extraParams;
    leftTree.reload();
}

/**
 * 验证指标是否可发布/撤销发布
 */
function isCanAppoint(type) {
    var gridDataCount = DSYGrid.getGrid('zbGrid').getStore().getData().items.length;
    if (gridDataCount == 0 || !gridDataCount) {
        Ext.MessageBox.alert('提示', type == 1 ? '暂无可发布的指标！' : '暂无可撤销发布的指标！');
        return false;
    }
    return true;
}