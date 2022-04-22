function getXmStore(filterParam){
    var xm_tree_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['ID','CODE', 'NAME'],
        proxy: {
            type: 'ajax',
            url: '/wzgl_reflct.action?method=getZdxm_cq',
            extraParams: filterParam,
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });
    // debugger;
    return xm_tree_store;
}
/**
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var store = DSYGrid.getGrid('unitGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        mhcx: mhcx,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE
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
                button_name = btn.name;
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
                    title: '提款限额维护',
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
                button_name = btn.name;
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
                    title: '提款限额信息',
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
                        var ids = new Array();
                        for (var k = 0; k < records.length; k++) {
                            var tkxe_id = records[k].get("TKXE_ID");
                            ids.push(tkxe_id);
                        }
                        //发送ajax请求，删除数据
                        $.post("/deleteTkxeData.action", {
                            ids: Ext.util.JSON.encode(ids),
                            btn_name: button_name
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
        tbar: items,
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
            {dataIndex: "TKXE_ID", type: "string", text: "id", width: 150,hidden:true},
            {dataIndex: "AD_CODE", type: "string", text: "地区", width: 150,hidden:true},
            {dataIndex: "AD_NAME", type: "string", text: "地区", width: 150},
            {dataIndex: "AG_ID", type: "string", text: "单位", width: 150,hidden:true},
            {dataIndex: "AG_CODE", type: "string", text: "单位", width: 150,hidden:true},
            {dataIndex: "AG_NAME", type: "string", text: "单位", width: 250},
            {dataIndex: "SET_YEAR", type: "string", text: "年度", width: 100},
            {dataIndex: "XM_ID", type: "string", text: "项目ID", width: 100,hidden:true},
            {dataIndex: "XM_NAME", type: "string", text: "项目", width: 300},
            {dataIndex: "XE_RMB", type: "float", text: "限额", width: 200,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            }
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
            autoLoad: true,
            dataUrl: 'getTkxeInfoGrid.action',
            height: '100%',
            flex: 1,
            tbar: [
               {
                    fieldLabel: '模糊查询',
                    name: 'mhcx',
                    xtype: "textfield",
                    width: 300,
                    labelWidth: 60,
                    labelAlign: 'right',
                    emptyText: '请输入项目名称...',
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
            formData.button_name = button_name;
            // var zhBank = form.getForm().findField("ZH_BANK").getRawValue();
            $.post('saveTkxeInfo.action', {
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
        var xmData = getXmStore({AG_ID:config.data.AG_ID,IS_XE:'1'});
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
                    fieldLabel: '限额ID',
                    name: 'TKXE_ID',
                    xtype: 'displayfield',
                    editable: false,
                    hidden: true
                },
                {
                    fieldLabel: '地区',
                    name: 'AD_CODE',
                    xtype: 'displayfield',
                    editable: false,
                    value:config.data.AD_CODE,
                    hidden: true
                },
                {
                    fieldLabel: '地区',
                    name: 'AD_NAME',
                    xtype: 'textfield',
                    editable: false,
                    value:config.data.AD_NAME,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    fieldLabel: '单位ID',
                    name: 'AG_ID',
                    xtype: 'displayfield',
                    editable: false,
                    value:(config.data.AG_ID==null?"":config.data.AG_ID),
                    hidden: true
                },
                {
                    fieldLabel: '单位CODE',
                    name: 'AG_CODE',
                    xtype: 'displayfield',
                    editable: false,
                    value:(config.data.AG_CODE==null?"":config.data.AG_CODE),
                    hidden: true
                },
                {
                    fieldLabel: '单位',
                    name: 'AG_NAME',
                    xtype: 'textfield',
                    editable: false,
                    allowBlank: false,//不允许为空
                    value:(config.data.AG_NAME==null?"":config.data.AG_NAME),
                    hidden: !config.ag_flag,
                    fieldStyle: 'background:#E6E6E6',
                },
                {
                    fieldLabel: '<span class="required">✶</span>立项年度',
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStore(json_debt_year),
                    displayField: "name",
                    valueField: "id",
                    editable: false, //禁用编辑
                    allowBlank: false,//不允许为空
                    value: new Date().getFullYear()
                },
                {
                    fieldLabel: '<span class="required">✶</span>项目',
                    xtype: 'combobox',
                    name: 'XM_ID',
                    displayField: 'NAME',
                    valueField: 'ID',
                    editable: false,
                    allowBlank: false,//不允许为空
                    store: xmData
                },
                {
                    xtype:"textfield",
                    fieldLabel:'<span class="required">✶</span>限额',
                    name:"XE_RMB",
                    allowBlank: false
                }
            ]
        });
        if(config.data.button_name=='edit'){
            //初始化及回显
            form.getForm().setValues(config.record);
        }
        return form;
    }
});