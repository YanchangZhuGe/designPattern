var json_zhlx=[
    {"id":"1","code":"001","name":"提款账户"},
    {"id":"2","code":"002","name":"还本付息账户"},
];

Ext.define('sjxmModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',mapping:'DXM_ID'},
        {name: 'name',mapping:'DXM_NAME'}
    ]
});
/**
 * 获取大项目信息
 */
function getSjxmStore(filterParam){
    var sjxmDataStore = Ext.create('Ext.data.Store', {
        model: 'sjxmModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getSjxmData.action",
            reader: {
                type: 'json'
            },
            extraParams:filterParam
        },
        autoLoad: true
    });
    return sjxmDataStore;
}
/**
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var store = DSYGrid.getGrid('unitGrid').getStore();
    var ZHLX = Ext.ComponentQuery.query('combobox[name="ZHLX"]')[0].getValue();
    var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        ZHLX: ZHLX,
        mhcx: mhcx
    };
    //刷新表格内容
    store.loadPage(1);
};
Ext.onReady(function() {
    var button_name = '';//当前操作按钮名称
    var items = [
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function (btn) {
                if (AD_CODE == null || AD_CODE == '') {
                    Ext.Msg.alert('提示', '请选择区划！');
                    return;
                } else {
                    reloadGrid();
                }
            }
        },
        {
            xtype: 'button',
            text: '新增',
            name: 'add',
            icon: '/image/sysbutton/add.png',
            handler: function (btn) {
                //获取左侧选择树，初始化全局变量
                var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                var selected_ad = treeArray[0].getSelection()[0];
                var selected_ag = treeArray[1].getSelection()[0];
                var ad_code=selected_ad.data.code;//获取选中的区划code
                var ad_name=selected_ad.data.text;//获取选中的区划name
                var ag_code=null; //先赋值为空，判断之后显示
                var ag_name=null; //先赋值为空，判断之后显示
                var ag_id=null; //先赋值为空，判断之后显示
                var ag_flag = false;

                if (!selected_ad) {
                    Ext.Msg.alert('提示', "请选择区划！");
                    return;
                }else if(!selected_ag || !selected_ag.data.leaf){
                    Ext.Msg.alert('提示', "请选择底级单位！");
                    return;
                }else if (selected_ag && selected_ag.data.leaf) {
                    ag_flag = true;
                    ag_code=selected_ag.data.code;//获取选中的单位code
                    ag_name=selected_ag.data.text;//获取选中的单位name
                    ag_id= selected_ag.data.id;//获取选中的单位id
                }
                button_name = btn.text;
                var data = {
                    AD_CODE:ad_code,
                    AD_NAME:ad_name,
                    AG_ID: ag_id,
                    AG_CODE:ag_code,
                    AG_NAME:ag_name,
                    button_name:button_name
                };
                //弹出弹出框
                initWindow_unitinfo({
                    title: '资金账户维护',
                    data: data,
                    ag_flag: ag_flag
                });
            }
        },
        {
            xtype: 'button',
            text: '修改',
            name: 'edit',
            icon: '/image/sysbutton/edit.png',
            handler: function (btn) {
                // 检验是否选中数据
                // 获取选中数据
                var selectRecord = DSYGrid.getGrid('unitGrid').getSelection();
                if (selectRecord.length == 0) {
                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    return;
                } else if (selectRecord.length > 1) {
                    Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                    return;
                }
                button_name = btn.text;
                var ag_flag = false;
                var record = selectRecord[0].data;
                if(record.AG_CODE && record.AG_NAME){
                    ag_flag = true;
                }
                var data = {
                    AD_CODE:record.AD_CODE,
                    AD_NAME:record.AD_NAME,
                    AG_ID: record.AG_ID,
                    AG_CODE:record.AG_CODE,
                    AG_NAME:record.AG_NAME,
                    button_name:button_name
                };
                initWindow_unitinfo({
                    title: '修改账户信息',
                    data: data,
                    record : record,
                    ag_flag: ag_flag
                });
            }
        },
        {
            xtype: 'button',
            text: '删除',
            name: 'delete',
            icon: '/image/sysbutton/delete.png',
            handler: function (btn) {
                // 检验是否选中数据
                // 获取选中数据
                var records = DSYGrid.getGrid('unitGrid').getSelectionModel().getSelection();
                if (records.length == 0) {
                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    return;
                }
                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                    if (btn_confirm == 'yes') {
                        button_name = btn.text;
                        var zjzhIdInfoArray = [];
                        Ext.each(records, function (record) {
                            var array = {};
                            array.ZJZH_ID = record.get("ZJZH_ID");
                            zjzhIdInfoArray.push(array);
                        });
                        //发送ajax请求，删除数据
                        $.post("/deleteZjzhData.action", {
                            zjzhIdInfoArray: Ext.util.JSON.encode(zjzhIdInfoArray)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                //刷新表格
                                reloadGrid();
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            }
                        }, "json");
                    }
                });
            }
        },
        '->',
        initButton_OftenUsed(),
        initButton_Screen()
    ];

    //定义右键菜单
    var panel = new Ext.panel.Panel({
        renderTo: 'unitManage',
        height: '100%',
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: items
            }
        ],
        items: [
            initContentTree({
                 param: {
                    AG_ID_notleaf: true,//点击非叶子节点查询全局变量AG_ID
                    AG_NAME_notleaf: true//点击非叶子节点查询全局变量AG_NAME
                 }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧表格
        ]
    });

    /**
     * 初始化右侧panel，放置表格
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
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    defaults: {
                        margin: '5 5 5 5',
                        width: 50,
                        labelWidth: 100,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
                        {
                            fieldLabel: '账户类型',
                            name: 'ZHLX',
                            xtype: 'combobox',
                            editable: false,
                            displayField: 'name',
                            valueField: 'id',
                            store: DebtEleStore(json_zhlx),
                            // allowBlank: false,//不允许为空
                            width: 250,
                            labelWidth: 60,
                            labelAlign: 'left'
                        }, {
                            fieldLabel: '模糊查询',
                            name: 'mhcx',
                            xtype: "textfield",
                            width: 300,
                            labelWidth: 60,
                            labelAlign: 'right',
                            emptyText: '请输入账号/账户名称...',
                            enableKeyEvents: true,
                            listeners: {
                            }
                        }
                    ]
                }
            ],
            items: [
                initUnitGrid()
            ]
        });
    };

    /**
     * 初始化右侧主表格表头
     */
    function initUnitGrid() {
        var headerJson = [
            {xtype: 'rownumberer', summaryType: 'count', width: 45},
            {dataIndex: "ZJZH_ID", type: "string", text: "id", width: 150,hidden:true},
            {dataIndex: "AD_CODE", type: "string", text: "地区", width: 150,hidden:true},
            {dataIndex: "AD_NAME", type: "string", text: "地区", width: 150},
            {dataIndex: "AG_CODE", type: "string", text: "单位", width: 150,hidden:true},
            {dataIndex: "AG_NAME", type: "string", text: "单位", width: 200},
            {dataIndex: "ZH_TYPE", type: "string", text: "账户类型", width: 100,
                renderer: function (value) {
                    var store = DebtEleStore(json_zhlx);
                    var record = store.findRecord('id', value, 0, false, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {dataIndex: "ACCOUNT", type: "string", text: "账号", width: 200},
            {dataIndex: "ZH_NAME", type: "string", text: "账户名称", width: 200},
            {dataIndex: "ZH_BANK", type: "string", text: "开户行", width: 200},
            // {dataIndex: "DXM", type: "string", text: "大项目id", width: 150,hidden:true},
            // {dataIndex: "DXM_CODE", type: "string", text: "大项目编码", width: 150},
            // {dataIndex: "DXM_NAME", type: "string", text: "大项目名称", width: 150}
        ];
        return DSYGrid.createGrid({
            itemId: 'unitGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            // selModel:{mode: "SINGLE"},//单选
            rowNumber: true,
            border: false,
            autoLoad: false,
            dataUrl: 'getZjzhInfoGrid.action',
            height: '100%',
            flex: 1,
            pageConfig: {
                pageNum: true//设置显示每页条数
            }
        });
    };

    /**
     * 初始化添加弹出窗口
     */
    function initWindow_unitinfo(config) {
        Ext.create('Ext.window.Window', {
            title: config.title, // 窗口标题
            width: 500, // 窗口宽度
            height: 330, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_unitinfo', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: initWindow_unitinfo_contentForm(config),
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    handler: function (self) {
                        submitInfo(config,self);
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
    };
    /**
     * 保存事件
     */
    function submitInfo(config,self,msg) {
        var button_name = config.data.button_name;
        var form = self.up('window').down('form');
        if (form.isValid()) {
            var formData = form.getForm().getFieldValues();
            var zhBank = form.getForm().findField("ZH_BANK").getRawValue();
            formData = $.extend({
                AD_CODE:config.data.AD_CODE,
                AD_NAME:config.data.AD_NAME,
                AG_ID:(config.data.AG_ID==null?"":config.data.AG_ID),
                AG_CODE:(config.data.AG_CODE==null?"":config.data.AG_CODE),
                AG_NAME:(config.data.AG_NAME==null?"":config.data.AG_NAME),
                button_name:config.data.button_name
            }, formData, form.getValues());
            formData.ZH_BANK=zhBank;
            if(button_name=='修改'){
                formData.ZJZH_ID=config.record.ZJZH_ID;
            }
            $.post('saveZjzhInfo.action', {
                detailForm: Ext.util.JSON.encode([formData])
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: '保存成功！',
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    self.up('window').close();
                    // 刷新表格
                    DSYGrid.getGrid("unitGrid").getStore().loadPage(1);
                } else {
                    Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                }

            }, 'JSON');
        }
    }
    /**
     * 初始化用户信息表单(点击新增窗口中的内容)
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
                columnWidth:.9,//输入框的长度（百分比）
                labelAlign: "right",
                labelWidth: 110
            },
            items: [
                {
                    fieldLabel: '地区',
                    name: 'AD_CODE',
                    xtype: 'displayfield',
                    editable: false,
                    value:config.data.AD_CODE,
                    hidden: true
                }, {
                    fieldLabel: '地区',
                    name: 'AD_NAME',
                    xtype: 'textfield',
                    editable: false,
                    disabled: true,
                    value:config.data.AD_NAME,
                    allowBlank: true//不允许为空
                }, {
                    fieldLabel: '单位',
                    name: 'AG_CODE',
                    xtype: 'displayfield',
                    editable: false,
                    value:(config.data.AG_CODE==null?"":config.data.AG_CODE),
                    hidden: true
                }, {
                    fieldLabel: '单位',
                    name: 'AG_NAME',
                    xtype: 'textfield',
                    editable: false,
                    allowBlank: true,//不允许为空
                    disabled: true,
                    value:(config.data.AG_NAME==null?"":config.data.AG_NAME),
                    hidden: !config.ag_flag
                }, {
                    fieldLabel: '<span class="required">✶</span>账户类型',
                    name: 'ZH_TYPE',
                    xtype: 'combobox',
                    editable: false,
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStore(json_zhlx),
                    allowBlank: false,//不允许为空
                    listeners: {
                        change: function (self, newValue) {
                            var form = self.up('form').getForm();
                            var DXM = form.findField('DXM');//大项目
                            if (newValue == '1' && !config.ag_flag ) { //两个判断条件
                                DXM.show();
                                DXM.allowBlank=false;
                            } else {
                                DXM.hide();
                                DXM.allowBlank=true;
                            }
                        }
                    }
                }, {
                    fieldLabel: '<span class="required">✶</span>账户名称',
                    name: 'ZH_NAME',
                    xtype: 'textfield',
                    editable: true,
                    displayField: 'name',
                    valueField: 'id',
                    // store: DebtEleTreeStoreDB("DEBT_ZWDWLX"),
                    allowBlank: false//不允许为空
                }, {
                    fieldLabel: '<span class="required">✶</span>账号',
                    xtype: 'textfield',
                    name: 'ACCOUNT',
                    disabled: false,
                    allowBlank: false//不允许为空

                }, {
                    fieldLabel: '<span class="required">✶</span>开户行',
                    xtype: 'textfield',
                    name: 'ZH_BANK',
                    disabled: false,
                    allowBlank: false//不允许为空
                }, {
                    fieldLabel: '<span class="required">✶</span>大项目',
                    xtype: 'combobox',
                    name: 'DXM',
                    displayField: 'name',
                    valueField: 'id',
                    disabled: false,
                    editable: false,
                    allowBlank: config.ag_flag,//不允许为空
                    // store: DebtEleTreeStoreDB("DEBT_SJXM",{condition:(config.data.button_name=='修改'? " and EXTEND1 = "+config.data.AD_CODE : " and EXTEND1 = "+AD_CODE)}),
                    // store: getSjxmStore({EXTEND1:config.data.button_name=='修改'?config.data.AD_CODE : AD_CODE}),
                    store: getSjxmStore({AD_CODE:config.data.AD_CODE}),
                    hidden: config.ag_flag//根据是否选择单位，判断是否隐藏。
                }
            ]
        });
        if(config.data.button_name=='修改'){
            //初始化及回显
            form.getForm().setValues(config.record);
        }
        return form;
    }
});