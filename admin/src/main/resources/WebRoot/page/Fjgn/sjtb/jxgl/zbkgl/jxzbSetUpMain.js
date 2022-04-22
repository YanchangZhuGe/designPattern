// 是否选中了左侧树：默认没选，如果选中指标树节点，点击新增按钮，则自动将该节点信息带到指标录入界面
var isSelect = false;

// 录入页：是否末级
var isLeaf_insert_json = [
    {"id": "1", "code": "1", "name": "是"},
    {"id": "0", "code": "0", "name": "否"}
]

// 目标值类型
var tvType_insert_json = [
    {"id": "1", "code": "1", "name": "数值"},
    {"id": "2", "code": "2", "name": "字符"}
]

// 工具栏按钮
var toolbarItems = [
    {
        xtype: 'button',
        text: '查询',
        name: 'search',
        icon: '/image/sysbutton/search.png',
        handler: function (btn) {
            reloadGrid();
            reloadTree();
        }
    },
    {
        xtype: 'button',
        text: '新增',
        name: 'add',
        id: 'addBtn',
        icon: '/image/sysbutton/add.png',
        handler: function (btn) {
            addZb(btn);
        }
    },
    {
        xtype: 'button',
        text: '修改',
        name: 'edit',
        icon: '/image/sysbutton/edit.png',
        handler: function (btn) {
            editZb();
        }
    },
    {
        xtype: 'button',
        text: '删除',
        name: 'delete',
        icon: '/image/sysbutton/delete.png',
        handler: function (btn) {
            delZb();
        }
    },
    {
        xtype: 'button',
        text: '启用',
        name: 'start',
        icon: '/image/sysbutton/yunxu.png',
        hidden: true,
        handler: function (btn) {
            startZb(btn);
        }
    },
    {
        xtype: 'button',
        text: '停用',
        name: 'stop',
        hidden: true,
        icon: '/image/sysbutton/jinzhi.png',
        handler: function (btn) {
            stopZb(btn);
        }
    },
    {
        xtype: 'button',
        text: '导入',
        name: 'import',
        icon: '/image/sysbutton/import.png',
        hidden: true,
        handler: function (btn) {
            importZb(btn);
        }
    },
    '->',
    initButton_OftenUsed(),
    initButton_Screen()
];

/**
 * 页面初始化
 * @author Jiafy 2021/08/10
 */
$(document).ready(function () {
    initContent();
});

/**
 * 初始化主界面：左侧指标体系数，右侧指标体系列表
 * @return void
 * @author Jiafy 2021/08/10
 */
function initContent() {
    // 创建主面板
    Ext.create('Ext.panel.Panel', {
        renderTo: Ext.getBody(),
        layout: 'border',
        defaults: {
            split: true,// 是否有分割线
            collapsible: false// 是否可以折叠
        },
        width: '100%',
        height: '100%',
        border: 'true',
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: toolbarItems // 操作按钮
            }
        ],
        items: [
            {
                xtype: 'treepanel',
                itemId: 'zbtxTree',
                id: 'zbtxTree',
                region: 'west',
                flex: 1,
                height: '100%',
                width: '20%',
                store: initZbtxTree(),
                rootVisible: false,
                listeners: {
                    itemclick: function (self, record, item, index, e) {
                        // 如果点击的是项目类型的节点，不进行操作
                        var code = record.get('code').toString();
                        // 新增按钮置灰
                        if (record.get('level') == '03') {
                            Ext.ComponentQuery.query("button[name = add]")[0].setDisabled(true);
                        } else {
                            Ext.ComponentQuery.query("button[name = add]")[0].setDisabled(false);
                        }
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
            initZbDetailTable()
        ]
    });
}

/**
 * 右侧指标体系详情表格-初始化方法
 * @return Ext.form.Panel
 * @author Jiafy 2021/08/10
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
            XMLX_ID: XMLX_ID_SEL
        },
        rowNumber: true,
        border: false,
        autoLoad: true,
        height: '100%',
        width: '100%',
        checkBox: true,
        flex: 1,
        dataUrl: 'getZbtxGridData.action',
        tbar: [
            {
                xtype: "combobox",
                fieldLabel: "指标年度",
                name: "FISCAL_YEAR",
                id: "FISCAL_YEAR",
                editable: false,
                displayField: 'name',
                labelAlign: "left",
                width: 200,
                labelWidth: 65,
                valueField: 'code',
                allowBlank: false,
                value: CURRENT_YEAR,
                store: DebtEleStore(getYearList({start: -5, end: 5})),
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
                width: 250,
                displayField: 'name',
                valueField: 'id',
                hidden: false,
                lines: false,
                editable: false,
                store: DebtEleTreeStoreDBTable("DSY_V_ELE_JXZBK_ZWXMLX"),
                listeners: {
                    select: function (obj) {
                        var xmlx = obj.getValue();
                        XMLX_ID_SEL = xmlx;
                        reloadTree();
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                labelWidth: 60,
                width: 250,
                fieldLabel: '模糊查询',
                labelAlign: "right",
                name: 'KEYINFO',
                id: 'SEARCH_KEYINFO',
                emptyText: '输入指标编码/指标名称',
                enableKeyEvents: true,
                listeners: {
                    'specialkey': function (self, e) {
                        //回车键
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var content = self.getValue();
                            var param = {
                                INDCODEORNAME: content
                            }
                            reloadGrid(param);// 刷新表格
                        }
                    }
                }
            }
        ],
        pageConfig: {
            pageNum: true,// 设置显示每页条数
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
 * 左侧指标体系树-初始化方法
 * @return Ext.data.TreeStore
 * @author Jiafy 2021/08/10
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
        root: {text: '全部指标', code: 'root', id: 'root'},// 若数据获取错误，则默认显示该根节点
        autoLoad: true
    });
    return xmlxStore;
}

/**
 * 在树构造完成后，选中根节点
 * @return void
 * @author Jiafy 2021/08/10
 */
function afterInitTree() {
    var treePanel = Ext.ComponentQuery.query('treepanel#zbtxTree')[0];
    // 获取所有根节点
    var rootNode = treePanel.getRootNode();
    // 若第一个根节点存在
    if (rootNode.getChildAt(0)) {
        var record = rootNode.getChildAt(0);
        // 设置选中第一个根节点
        treePanel.getSelectionMode().select(record);
        // 配置全局变量
        setTreeNode(record);
        // 刷新表格
        //reloadGrid();
    }
}

/**
 * 选中树中节点时，进行全局变量赋值
 * @param record 树中选中的指标数据
 * @return void
 * @author Jiafy 2021/08/10
 */
function setTreeNode(record) {
    if (!!record) {
        TREE_IND_ID = record.get('id');
        TREE_IND_CODE = record.get('code');
    }
}

/**
 * 新增指标
 * @param btn 新增按钮
 * @return void
 * @author Jiafy 2021/08/10
 */
function addZb(btn) {
    // 获取树中选择的指标
    var treeArray = btn.up('panel').query('treepanel');
    var selected_zb = treeArray[0].getSelection()[0];
    var titleType = IND_TYPE == 1 ? '评价' : '目标';
    var title = '新增' + titleType + '指标信息';
    if (!selected_zb || selected_zb.data.code == "root") {
        isSelect = false;
        initWindow_zb_add({
            title: title
        });
    } else {
        // 选中了某个指标
        var zbSel = selected_zb.get('level');
        if (zbSel && zbSel == 3) {
            // 选择了三级指标
            Ext.Msg.alert('提示', "不可为三级指标添加子指标");
            return;
        }
        if (AD_CODE != ELE_AD_CODE && zbSel != 2) {
            Ext.Msg.alert('提示', "市、县财政用户只可设置三级指标");
            return;
        }

        var xmlxId = '';
        if (selected_zb.get('id').startsWith("xmlx_id")) {
            xmlxId = selected_zb.get('id').split("_")[2];
        } else {
            xmlxId = selected_zb.get('xmlx');
        }
        if(!checkIsCanAdd(xmlxId)){
            Ext.Msg.alert('提示', "当前年度此项目类型的指标体系已下达，请撤销下达后再对指标体系进行修改！");
            return;
        }
        isSelect = true;
        initWindow_zb_add({
            title: title,
            zbObj: selected_zb.data
        });
    }
}

/**
 * 初始化新增模态框
 * @param config 窗口的配置参数
 * @return void
 * @author Jiafy 2021/08/10
 */
function initWindow_zb_add(config) {
    Ext.create('Ext.window.Window', {
        title: config.title, // 窗口标题
        width: document.body.clientWidth * 0.70, // 窗口宽度
        height: document.body.clientHeight * 0.60, // 窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',// hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initWindow_zb_add_contentForm(config),
        buttons: [
            {
                xtype: 'button',
                text: '保存',
                handler: function (self) {
                    var form = self.up('window').down('form');
                    if (form.isValid()) {
                        self.setDisabled(true);
                        var formData = form.getForm().getFieldValues();
                        formData = $.extend({}, formData, form.getValues());
                        if(!checkIsCanAdd(formData.XMLX_ID)){
                            Ext.Msg.alert('提示', "当前年度此项目类型的指标体系已下达，请撤销下达后再对指标体系进行修改！");
                            self.setDisabled(false);
                            return;
                        }
                        $.post('zbInfoAdd.action', {
                            detailForm: Ext.util.JSON.encode([formData])
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "保存成功",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                self.up('window').close();
                                // 刷新表格
                                reloadGrid();
                                // 刷新树
                                Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
                            } else {
                                Ext.MessageBox.alert('提示', '保存失败!</br>' + data.message);
                                self.setDisabled(false);
                            }
                        }, 'JSON');
                    }
                }
            },
            {
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
 * 初始化新增指标表单
 * @param config 配置参数
 * @return Ext.form.Panel
 * @author Jiafy 2021/08/10
 */
function initWindow_zb_add_contentForm(config) {
    var form = Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'column',
        defaultType: 'textfield',
        scrollable: true,
        fieldDefaults: {
            labelWidth: 90,
            columnWidth: .33,
            margin: '10 20 3 10',
            labelStyle: 'text-align:left'
        },
        items: [
            {
                fieldLabel: '指标类型（评价指标、目标指标）', // 隐藏用于保存时获取ind_type
                name: 'IND_TYPE',
                hidden: true,
                value: IND_TYPE
            },
            {
                fieldLabel: '指标年度', // 隐藏用于保存时获取指标年度
                name: 'FISCAL_YEAR',
                hidden: true,
                value: CURRENT_YEAR
            },
            {
                fieldLabel: '指标编码',
                name: 'IND_CODE',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            }, {
                fieldLabel: '指标名称',
                name: 'IND_NAME',
                emptyText: '请输入',
                allowBlank: false// 不允许为空
            }, {
                fieldLabel: '指标级别',
                name: 'LEVEL_NO',
                itemId: 'LEVEL_NO',
                emptyText: '选择',
                allowBlank: false,// 不允许为空
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: AD_CODE == ELE_AD_CODE ? '01' : '',
                store: AD_CODE == ELE_AD_CODE ? DebtEleStoreTable('DSY_V_ELE_JXGL_ZBJB') : DebtEleStoreTable('DSY_V_ELE_JXGL_ZBJB', {condition: "and guid = '03'"}),
                listeners: {
                    change: function (obj) {
                        var levelSel = obj.ownerCt.getComponent('LEVEL_NO');// 指标级别的选择框
                        var isLeafSel = obj.ownerCt.getComponent('IS_LEAF');// 是否末级的选择框
                        var parentSel = obj.ownerCt.getComponent('PARENT_ID');// 上级指标的选择框
                        var weightValInput = obj.ownerCt.getComponent('WEIGHT_VALUE');// 权重的输入框
                        var level = levelSel.getValue();// 获取选择的级别
                        if (!isSelect) {
                            // 根据指标级别重构上级指标
                            SJZB_ADD = levelSel.getValue();
                            parentSel.store.proxy.extraParams['level'] = SJZB_ADD;
                            parentSel.store.reload();
                            // 根据指标级别重构上级指标选择框
                            if (level == '03') {
                                // 如果是三级指标
                                // "是否末级"默认选中末级
                                isLeafSel.setValue(1);
                                isLeafSel.setReadOnly(true);
                                isLeafSel.setFieldStyle('background:#E6E6E6');
                                // 权重设置只读
                                weightValInput.setReadOnly(true);
                                weightValInput.setFieldStyle('background:#E6E6E6');
                                // 上级指标设置可选且必选
                                parentSel.setValue();
                                parentSel.setReadOnly(false);
                                parentSel.setFieldStyle('background:none');
                                parentSel.allowBlank = false;
                            } else {
                                // 非三级指标，也就是一二级指标，指标类型默认选中“共性”
                                // "是否末级"默认选中否
                                isLeafSel.setValue(0);
                                isLeafSel.setReadOnly(true);
                                isLeafSel.setFieldStyle('background:#E6E6E6');
                                // 权重设置只读
                                weightValInput.setReadOnly(false);
                                weightValInput.setFieldStyle('background:none');
                                // 如果选择为一级指标时，“上级指标”选择框置灰，不让选
                                if (level == "01") {
                                    parentSel.setValue();
                                    parentSel.setReadOnly(true);
                                    parentSel.setFieldStyle('background:#E6E6E6');
                                    parentSel.allowBlank = true;
                                } else {
                                    parentSel.setReadOnly(false);
                                    parentSel.setFieldStyle('background:none');
                                    parentSel.allowBlank = false;
                                }
                            }
                        }
                    }
                }
            }, {
                fieldLabel: '是否末级',
                name: 'IS_LEAF',
                itemId: 'IS_LEAF',
                emptyText: '选择',
                allowBlank: false,// 不允许为空
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: '0',
                store: DebtEleStore(isLeaf_insert_json)
            }, {
                fieldLabel: '上级指标',
                name: 'PARENT_ID',
                itemId: 'PARENT_ID',
                emptyText: '选择',
                displayField: 'text',
                valueField: 'id',
                lines: false,
                xtype: 'treecombobox',
                editable: false, // 禁用编辑
                store: initZbtxTree(),
                listeners: {
                    change: function (obj) {
                        var PARENT_ID = obj.ownerCt.getComponent('PARENT_ID');
                        if (!PARENT_ID.getValue() || PARENT_ID.getValue() == 'root') {
                            PARENT_ID.setValue();
                        }
                    }
                }
            }, {
                fieldLabel: '指标类型',
                name: 'IS_COMMON_IND',
                itemId: 'IS_COMMON_IND',
                emptyText: '选择',
                allowBlank: false,// 不允许为空
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: '2',
                store: DebtEleStoreTable('DSY_V_ELE_JXGL_ZBLX'),
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
            }, {
                fieldLabel: '项目类型',
                name: 'XMLX_ID',
                emptyText: '选择',
                displayField: 'name',
                valueField: 'id',
                lines: false,
                xtype: 'treecombobox',
                editable: false, // 禁用编辑
                //store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"})
                store: DebtEleTreeStoreDBTable("DSY_V_ELE_JXZBK_ZWXMLX"),
                allowBlank: false
            }, {
                fieldLabel: '指标满分值',
                name: 'FULL_VALUE',
                itemId: 'FULL_VALUE',
                emptyText: '请输入',
                enableKeyEvents: true,
                allowBlank: false,// 不允许为空
                regex: /(^(\d|[1-9]\d)(\.\d{1,2})?$)|(^100$)/,
                regexText: "请输入0-100且最多为两位小数的数值",
                listeners: {
                    keyup: function (obj) {
                        var level = obj.ownerCt.getComponent('LEVEL_NO');// 指标级别
                        var weightValInput = obj.ownerCt.getComponent('WEIGHT_VALUE');// 权重的输入框
                        var fullValInput = obj.ownerCt.getComponent('FULL_VALUE');// 满分值的输入框
                        var fullVal = fullValInput.getValue();// 获取输入的满分值
                        if (fullVal) {
                            //如果输入了满分值，则不可输入权重
                            weightValInput.setReadOnly(true);
                            weightValInput.setFieldStyle('background:#E6E6E6');
                            weightValInput.allowBlank = true;// 允许为空
                        } else {
                            if (level.getValue() != '03') {
                                weightValInput.setReadOnly(false);
                                weightValInput.setFieldStyle('background:none');
                            }
                            weightValInput.allowBlank = false;// 不允许为空
                        }
                    }
                }
            }, {
                fieldLabel: '权重（%）',
                itemId: 'WEIGHT_VALUE',
                name: 'WEIGHT_VALUE',
                emptyText: '请输入',
                enableKeyEvents: true,
                allowBlank: false,// 不允许为空
                regex: /^([0-9]{1,2}|100)$/,
                regexText: "请输入0-100的正整数",
                hidden: true,//2021/09/14 最新需求不需要权重，隐藏
                listeners: {
                    keyup: function (obj) {
                        var weightValInput = obj.ownerCt.getComponent('WEIGHT_VALUE');// 权重的输入框
                        var fullValInput = obj.ownerCt.getComponent('FULL_VALUE');// 满分值的输入框
                        var weightVal = weightValInput.getValue();// 获取输入的满分值
                        if (weightVal) {
                            fullValInput.setValue(100);
                            fullValInput.setReadOnly(true);
                            fullValInput.setFieldStyle('background:#E6E6E6');
                            fullValInput.allowBlank = true;// 允许为空
                        } else {
                            fullValInput.setValue();
                            fullValInput.setReadOnly(false);
                            fullValInput.setFieldStyle('background:none');
                            fullValInput.allowBlank = false;// 不允许为空
                        }
                    }
                }
            },
            {
                fieldLabel: '度量单位',
                name: 'DLDW_ID',
                itemId: 'DLDW_ID',
                emptyText: '选择',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: '001',
                hidden: IND_TYPE == 2 ? false : true,// 评价指标设置时，不需要度量单位，目标指标设置，需要度量单位
                store: DebtEleStoreTable('DSY_V_ELE_JXGL_DLDW')
            },
            {
                fieldLabel: '目标值类型',
                name: 'TV_TYPE',
                itemId: 'TV_TYPE',
                emptyText: '选择',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: '2',
                hidden: IND_TYPE == 2 ? false : true,// 评价指标设置时，不需要目标值类型，目标指标设置，需要目标值类型
                store: DebtEleStore(tvType_insert_json)
            },
            {
                fieldLabel: '指标解释',
                name: 'PFBZ',
                emptyText: '请输入',
                columnWidth: .99,
                xtype: 'textarea',
                maxLength: 2000,// 限制输入字数
            }, {
                fieldLabel: '指标说明',
                name: 'ZBSM',
                emptyText: '请输入',
                columnWidth: .99,
                xtype: 'textarea',
                maxLength: 1000,// 限制输入字数
                allowBlank: false// 不允许为空
            }
        ]
    });
    if (isSelect) {
        var parentData = config.zbObj;// 获取选中的指标数据，作为父级数据展示在新增页中
        // 如果选中树
        //如果选中的节点时项目类型节点
        if (parentData.id.startsWith("xmlx_id_")) {
            var xmlxId = parentData.id.split("_")[2];
            form.down('textfield[name="PARENT_ID"]').setReadOnly(true);
            form.down('textfield[name="PARENT_ID"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="LEVEL_NO"]').setReadOnly(true);
            form.down('textfield[name="LEVEL_NO"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="IS_LEAF"]').setReadOnly(true);
            form.down('textfield[name="IS_LEAF"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="XMLX_ID"]').setValue(xmlxId);
            form.down('textfield[name="XMLX_ID"]').setReadOnly(true);
            form.down('textfield[name="XMLX_ID"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="XMLX_ID"]').allowBlank = true;
            form.down('textfield[name="TV_TYPE"]').setReadOnly(true);
            form.down('textfield[name="TV_TYPE"]').setFieldStyle('background:#E6E6E6');
        } else {
            // 指标级别：根据父级指标级别 得到新增指标的指标级别
            var zbjb = "0" + (parseInt(parentData.level) + 1);
            form.down('textfield[name="LEVEL_NO"]').setValue(zbjb);
            form.down('textfield[name="LEVEL_NO"]').setReadOnly(true);
            form.down('textfield[name="LEVEL_NO"]').setFieldStyle('background:#E6E6E6');
            // 上级指标：默认选中当前选中树的指标
            form.down('textfield[name="PARENT_ID"]').setValue(parentData.id);
            form.down('textfield[name="PARENT_ID"]').setReadOnly(true);
            form.down('textfield[name="PARENT_ID"]').setFieldStyle('background:#E6E6E6');
            // 项目类型：应该和父级指标的项目类型一致
            form.down('textfield[name="XMLX_ID"]').setValue(parentData.xmlx);
            form.down('textfield[name="XMLX_ID"]').setReadOnly(true);
            form.down('textfield[name="XMLX_ID"]').setFieldStyle('background:#E6E6E6');
            // 是否末级：置灰，并根据父级判断显示“是”或“否”
            // 指标类型：选择一级时，指标类型置灰，默认共性，选择二级时，指标类型不予限制
            // 指标满分值/权重：①选择二级指标时，权重不可输入 ②一级指标为分值时，二级指标也只能为分值
            form.down('textfield[name="IS_LEAF"]').setReadOnly(true);
            form.down('textfield[name="IS_LEAF"]').setFieldStyle('background:#E6E6E6');
            if (parentData.level == '01') {
                // 初始化时上级指标为一级指标，是否末级设为否，指标类型默认为共性指标
                form.down('textfield[name="IS_LEAF"]').setValue(0);
                if (parentData.weight_value == "" || parentData.weight_value == 0) {
                    form.down('textfield[name="WEIGHT_VALUE"]').setReadOnly(true);
                    form.down('textfield[name="WEIGHT_VALUE"]').setFieldStyle('background:#E6E6E6');
                }
                form.down('textfield[name="TV_TYPE"]').setReadOnly(true);
                form.down('textfield[name="TV_TYPE"]').setFieldStyle('background:#E6E6E6');
            } else if (parentData.level == '02') {
                // 初始化时上级指标为二级指标，指标类型默认为共性指标，权重输入框设置为只读
                form.down('textfield[name="IS_LEAF"]').setValue(1);
                form.down('textfield[name="WEIGHT_VALUE"]').setReadOnly(true);
                form.down('textfield[name="WEIGHT_VALUE"]').setFieldStyle('background:#E6E6E6');
                // 指标级别为三级并且为目标指标录入时,指标解释字段设置为必录
                if (IND_TYPE == 2) {
                    form.down('textfield[name="PFBZ"]').allowBlank = false;
                } else {
                    form.down('textfield[name="PFBZ"]').allowBlank = true;
                }
            }
        }
    } else {
        var level = form.down('textfield[name="LEVEL_NO"]').getValue();
        if (level == '01') {
            // 如果打开新增框，默认是一级，将该置灰的置灰
            form.down('textfield[name="IS_LEAF"]').setReadOnly(true);
            form.down('textfield[name="IS_LEAF"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="PARENT_ID"]').setReadOnly(true);
            form.down('textfield[name="PARENT_ID"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="LEVEL_NO"]').setReadOnly(true);
            form.down('textfield[name="LEVEL_NO"]').setFieldStyle('background:#E6E6E6');
            form.down('textfield[name="TV_TYPE"]').setReadOnly(true);
            form.down('textfield[name="TV_TYPE"]').setFieldStyle('background:#E6E6E6');
        }
    }
    return form;
}

/**
 * 新增页面上级指标数-初始化方法
 * @return Ext.data.TreeStore
 * @author Jiafy 2021/08/11
 */
function initZbtxTree_add() {
    Ext.define('zbtxTreeModel_Add', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'code'},
            {name: 'id'},
            {name: 'leaf'}
        ]
    });
    // 获取数据
    var xmlxStore = Ext.create('Ext.data.TreeStore', {
        model: 'zbtxTreeModel_Add',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getZbtxTreeData.action',
            extraParams: {"level": SJZB_ADD},
            reader: {
                type: 'json'
            }
        },
        root: {text: '全部指标', code: 'root', id: 'root'},// 若数据获取错误，则默认显示该根节点
        autoLoad: true
    });
    return xmlxStore;
}

/**
 * 修改指标
 * @return void
 * @author Jiafy 2021/08/11
 */
function editZb() {
    // 检验是否选中数据并校验
    var record = DSYGrid.getGrid('zbGrid').getSelectionModel().getSelection();
    if (!record || record.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
        return;
    }
    if (record[0].get('LEVEL_NO') != '03' && AD_CODE != ELE_AD_CODE) {
        Ext.MessageBox.alert('提示', "市、县财政用户只可修改三级指标");
        return;
    }
    if (record[0].get('IS_XD') == 1) {
        Ext.MessageBox.alert('提示', "指标已发布，不可修改");
        return;
    }
    if (!isNull(record[0].get('ZB_SOURCE')) && record[0].get('ZB_SOURCE') == '-1') {
        Ext.MessageBox.alert('提示', "财政部内置指标，不可修改");
        return;
    }
    var data = record[0].data;
    var titleType = IND_TYPE == 1 ? '评价' : '目标';
    var title = '修改' + titleType + '指标信息';
    initWindow_zb_edit({
        title: title,
        zbObj: data
    });
}

/**
 * 初始化修改模态框
 * @param config 配置信息
 * @return void
 * @author Jiafy 2021/08/11
 */
function initWindow_zb_edit(config) {
    var zbdata = config.zbObj;
    Ext.create('Ext.window.Window', {
        title: config.title, // 窗口标题
        width: document.body.clientWidth * 0.70, // 窗口宽度
        height: document.body.clientHeight * 0.60, // 窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',// hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initWindow_zb_edit_contentForm(zbdata),
        buttons: [
            {
                xtype: 'button',
                text: '保存',
                handler: function (self) {
                    var form = self.up('window').down('form');
                    if (form.isValid()) {
                        self.setDisabled(true);
                        var formData = form.getForm().getFieldValues();
                        formData = $.extend({}, formData, form.getValues());
                        $.post('updateZbInfo.action', {
                            detailForm: Ext.util.JSON.encode([formData])
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "保存成功",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                self.up('window').close();
                                // 刷新表格
                                reloadGrid();
                                // 刷新树
                                Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
                            } else {
                                Ext.MessageBox.alert('提示', '保存失败!</br>' + data.message);
                                self.setDisabled(false);
                            }
                        }, 'JSON');
                    }
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
 * 初始化修改指标表单
 * @param data 要编辑指标的信息
 * @return Ext.form.Panel
 * @author Jiafy 2021/08/11
 */
function initWindow_zb_edit_contentForm(data) {
    var form = Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'column',
        defaultType: 'textfield',
        scrollable: true,
        defaults: {
            labelWidth: 90,
            columnWidth: .33,
            margin: '10 20 3 10',
            labelStyle: 'text-align:left'
        },
        items: [
            {
                fieldLabel: 'ID',
                name: 'IND_ID',
                hidden: true
            },
            {
                fieldLabel: '指标编码',
                name: 'IND_CODE',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '指标名称',
                name: 'IND_NAME',
                allowBlank: false,// 不允许为空
            }, {
                fieldLabel: '指标级别',
                name: 'LEVEL_NO',
                itemId: 'LEVEL_NO',
                allowBlank: false,// 不允许为空
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreTable('DSY_V_ELE_JXGL_ZBJB'),
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            }, {
                fieldLabel: '是否末级',
                name: 'IS_LEAF',
                itemId: 'IS_LEAF',
                allowBlank: false,// 不允许为空
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: '0',
                store: DebtEleStore(isLeaf_insert_json),
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            }, {
                fieldLabel: '上级指标',
                name: 'PARENT_ID',
                itemId: 'PARENT_ID',
                displayField: 'text',
                valueField: 'id',
                lines: false,
                xtype: 'treecombobox',
                editable: false, // 禁用编辑
                store: initZbtxTree(),
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            }, {
                fieldLabel: '指标类型',
                name: 'IS_COMMON_IND',
                itemId: 'IS_COMMON_IND',
                allowBlank: false,// 不允许为空
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreTable('DSY_V_ELE_JXGL_ZBLX'),
                value: '2',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6'
            }, {
                fieldLabel: '项目类型',
                name: 'XMLX_ID',
                displayField: 'name',
                valueField: 'id',
                lines: false,
                xtype: 'treecombobox',
                editable: false, // 禁用编辑
                //store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"})
                store: DebtEleTreeStoreDBTable("DSY_V_ELE_JXZBK_ZWXMLX")
            }, {
                fieldLabel: '指标满分值',
                name: 'FULL_VALUE',
                itemId: 'FULL_VALUE',
                regex: /(^(\d|[1-9]\d)(\.\d{1,2})?$)|(^100$)/,
                regexText: "请输入0-100且最多为两位小数的数值",
                enableKeyEvents: true,
                listeners: {
                    keyup: function (obj) {
                        var level = obj.ownerCt.getComponent('LEVEL_NO');// 指标级别
                        var weightValInput = obj.ownerCt.getComponent('WEIGHT_VALUE');// 权重的输入框
                        var fullValInput = obj.ownerCt.getComponent('FULL_VALUE');// 满分值的输入框
                        var fullVal = fullValInput.getValue();// 获取输入的满分值
                        if (fullVal) {
                            weightValInput.setValue("")
                            weightValInput.setReadOnly(true);
                            weightValInput.setFieldStyle('background:#E6E6E6');
                            weightValInput.allowBlank = true;// 允许为空
                        } else {
                            if (level.getValue() != '03') {
                                weightValInput.setReadOnly(false);
                                weightValInput.setFieldStyle('background:none');
                            }
                            weightValInput.allowBlank = false;// 不允许为空
                        }
                    }
                }
            }, {
                fieldLabel: '权重（%）',
                itemId: 'WEIGHT_VALUE',
                name: 'WEIGHT_VALUE',
                regex: /^([0-9]{1,2}|100)$/,
                regexText: "请输入0-100的正整数",
                enableKeyEvents: true,
                hidden: true,//2021/09/14 最新需求不需要权重，隐藏
                listeners: {
                    keyup: function (obj) {
                        var weightValInput = obj.ownerCt.getComponent('WEIGHT_VALUE');// 权重的输入框
                        var fullValInput = obj.ownerCt.getComponent('FULL_VALUE');// 满分值的输入框
                        var weightVal = weightValInput.getValue();// 获取输入的满分值
                        if (weightVal) {
                            fullValInput.setValue(100);
                            fullValInput.setReadOnly(true);
                            fullValInput.setFieldStyle('background:#E6E6E6');
                            fullValInput.allowBlank = true;// 允许为空
                        } else {
                            fullValInput.setValue("");
                            fullValInput.setReadOnly(false);
                            fullValInput.setFieldStyle('background:none');
                            fullValInput.allowBlank = false;// 不允许为空
                        }
                    }
                }
            },
            {
                fieldLabel: '度量单位',
                name: 'DLDW_ID',
                itemId: 'DLDW_ID',
                emptyText: '选择',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                value: '001',
                hidden: IND_TYPE == 2 ? false : true,// 评价指标设置时，不需要度量单位，目标指标设置，需要度量单位
                store: DebtEleStoreTable('DSY_V_ELE_JXGL_DLDW')
            },
            {
                fieldLabel: '目标值类型',
                name: 'TV_TYPE',
                itemId: 'TV_TYPE',
                emptyText: '选择',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                hidden: IND_TYPE == 2 ? false : true,// 评价指标设置时，不需要目标值类型，目标指标设置，需要目标值类型
                store: DebtEleStore(tvType_insert_json)
            },
            {
                fieldLabel: '指标解释',
                name: 'PFBZ',
                columnWidth: .99,
                xtype: 'textarea',
                maxLength: 2000,// 限制输入字数
            },
            {
                fieldLabel: '指标说明',
                name: 'ZBSM',
                columnWidth: .99,
                xtype: 'textarea',
                maxLength: 1000,// 限制输入字数
                allowBlank: false// 不允许为空
            }
        ]
    });
    // 将指标信息赋值到表单中
    form.getForm().setValues(data);
    // 通过权重判断如果指标分值类型为权重还是分值
    if (data.WEIGHT_VALUE || data.WEIGHT_VALUE > 0) {
        //满分值设置只读
        form.down('textfield[name="FULL_VALUE"]').setReadOnly(true);
        form.down('textfield[name="FULL_VALUE"]').setFieldStyle('background:#E6E6E6');
    } else {
        //权重设置为只读
        form.down('textfield[name="WEIGHT_VALUE"]').setReadOnly(true);
        form.down('textfield[name="WEIGHT_VALUE"]').setFieldStyle('background:#E6E6E6');
    }
    // 如果修改三级指标，权重不可改，指标类型可变
    if (data.LEVEL_NO == "03") {
        form.down('textfield[name="WEIGHT_VALUE"]').setReadOnly(true);
        form.down('textfield[name="WEIGHT_VALUE"]').setFieldStyle('background:#E6E6E6');
        // 指标级别为三级并且为目标指标录入时,指标解释字段设置为必录
        if (IND_TYPE == 2) {
            form.down('textfield[name="PFBZ"]').allowBlank = false;
        } else {
            form.down('textfield[name="PFBZ"]').allowBlank = true;
        }
    }
    return form;
}

/**
 * 删除指标
 * @author Jiafy 2021/08/11
 */
function delZb() {
    // 获取选中数据并检验
    var grid = DSYGrid.getGrid('zbGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (!sm || sm.length == 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    // id数组
    var delCodes = [];
    for (var i = 0; i < sm.length; i++) {
        if (AD_CODE != ELE_AD_CODE && sm[i].get('LEVEL_NO') != '03') {
            Ext.MessageBox.alert('提示', "市、县财政用户不可删除一、二级指标");
            return;
        }
        if (AD_CODE != ELE_AD_CODE && sm[i].get('MOF_DIV_CODE') != AD_CODE) {
            Ext.MessageBox.alert('提示', "不可删除其他区划设置的指标");
            return;
        }
        if (sm[i].get('IS_XD') == 1) {
            Ext.MessageBox.alert('提示', "指标“" + sm[i].get('IND_NAME') + '”已发布，不可删除');
            return;
        }
        delCodes.push(sm[i].get('IND_CODE'));
    }
    Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            // 发送ajax请求，删除数据
            $.post("zbInfoRemove.action", {
                "delCodes": delCodes,
                "IND_TYPE": IND_TYPE,
                "year": CURRENT_YEAR
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: "删除成功",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    // 刷新表格
                    reloadGrid();
                    // 刷新树
                    Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
                } else {
                    Ext.MessageBox.alert('提示', '删除失败' + data.message);
                }
            }, "json");
        }
    });
}

/**
 * 启用指标
 * @author Jiafy 2021/08/10
 */
function startZb() {
    // 获取选中数据并检验
    var grid = DSYGrid.getGrid('zbGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (!sm || sm.length == 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    // id数组
    var codes = [];
    // 标识，用来判断上级指标是否启用
    for (var i = 0; i < sm.length; i++) {
        codes.push(sm[i].get('IND_CODE'));
        if (sm[i].get('PARENT_IS_ENABLED') != "1" && sm[i].get('PARENT_IS_ENABLED')) {
            Ext.MessageBox.alert('提示', '存在其上级指标未启用的指标');
            return;
        }
    }
    // 发送ajax请求
    $.post("updateZbEnabledStatus.action", {
        IND_CODES: codes,
        IS_ENABLED: 1
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: "启用成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            // 刷新表格
            reloadGrid();
            // 刷新树
            Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
        } else {
            Ext.MessageBox.alert('提示', '启用失败' + data.message);
        }
    }, "json");
}

/**
 * 停用指标
 * @author Jiafy 2021/08/10
 */
function stopZb() {
    // 获取选中数据并检验
    var grid = DSYGrid.getGrid('zbGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (!sm || sm.length == 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var codes = [];
    for (var i = 0; i < sm.length; i++) {
        codes.push(sm[i].get('IND_CODE'));
    }
    // 发送ajax请求
    $.post("updateZbEnabledStatus.action", {
        IND_CODES: codes,
        IS_ENABLED: 2
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: "停用成功",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            // 刷新表格
            reloadGrid();
            // 刷新树
            Ext.ComponentQuery.query('treepanel#zbtxTree')[0].getStore().reload();
        } else {
            Ext.MessageBox.alert('提示', '停用失败' + data.message);
        }
    }, "json");
}

/**
 * 刷新表格
 * @param params 查询条件对象
 * @return void
 * @author Jiafy 2021/08/10
 */
function reloadGrid(params) {
    var INDCODEORNAME = Ext.getCmp('SEARCH_KEYINFO').getValue();
    var extraParams = {
        AD_CODE: AD_CODE,
        IND_ID: TREE_IND_ID,
        IND_CODE: TREE_IND_CODE,
        INDCODEORNAME: INDCODEORNAME,
        year: CURRENT_YEAR,
        IND_TYPE: IND_TYPE,
        XMLX_ID: XMLX_ID_SEL
    };
    // 参数拼接
    if (!!params) {
        extraParams = $.extend(true, {}, extraParams, params);
    }
    var store = DSYGrid.getGrid('zbGrid').getStore();
    store.getProxy().extraParams = extraParams;
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
 * 保存时验证当前年度的项目类型下的指标体系是够已经下达，如果下达了，不可以新增
 * @param xmlxId 项目类型id
 * @return void
 * @author Jiafy 2021/11/04
 */
function checkIsCanAdd(xmlxId) {
    var flag = true;
    $.ajax({
        url: "getZbtxGridData.action",
        dataType: "json",
        type: "POST",
        data: {
            year: CURRENT_YEAR,
            XMLX_ID: xmlxId,
            xdStatus: 1,
            IND_TYPE:IND_TYPE
        },
        async: false,
        success: function (data) {
            if (parseInt(data.totalcount) > 0) {
                flag = false;
            }
        }
    })
    return flag;
}