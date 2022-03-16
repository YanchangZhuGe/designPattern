
Ext.require([
    'Ext.tree.*',
    'Ext.data.*',
    'Ext.layout.container.HBox',
    'Ext.dd.*',
    'Ext.window.MessageBox'
]);
var is_qhbf=false;
var ad;
/**
 * 树点击节点时触发，刷新content主表格
 */
    var dwid='';
    var datas='';
    var xeglAreaStore = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: 'getRegTreeDataZwxe.action',
        extraParams: {
            AD_CODE: USER_AD_CODE,
            CHILD: 0
        },
        reader: {
            type: 'json'
        }
    },
    root: 'nodelist',
    //model: 'treeModel',
    autoLoad: true
});
/*var Treeadcode;
if(Treeadcode==null||Treeadcode==undefined||Treeadcode==""){
    Treeadcode=USER_AD_CODE;
}*/

function getStore(ad_code2) {
 return   Ext.create('Ext.data.ArrayStore', {
        fields: ["ID", "NAME","CODE"],
        proxy: {// ajax获取后端数据
            type: "ajax",
            method: "POST",
            url: '/tygn/getCurrentZgbm.action?ADCODE='+ad_code2+"&time="+new Date().getTime(),
            extraParams: {
                data: ad_code2
            },
            reader: {
                type: "json",
                root: "list"
            },
            simpleSortMode: true
        },
        autoLoad: true
    });

}

/*
function setStore2(store) {
    var tree_area = Ext.ComponentQuery.query('combobox[name="L_SUPDEP"]')[0];
    tree_area.setStore(store);
    tree_area.getStore().load();
}
*/

    function reloadGrid(param) {
    var grid = DSYGrid.getGrid('unitGrid');
    var store = grid.getStore();
    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
    var tree_selected = tree_area.getSelection();
    var data = tree_selected[0];
    if (data != undefined){
        dwid =data.get("id");
        store.getProxy().extraParams["BGQ_ID"]=dwid;
    }
    //增加查询参数
    store.getProxy().extraParams["ADCODE"] = AD_CODE;
    store.getProxy().extraParams["AGCODE"] = AG_CODE;
    if (typeof param != 'undefined' && param != null) {
        for (var name_param in param) {
            store.getProxy().extraParams[name_param] = param[name_param];
        }
    }

    //刷新*/
    store.load();

};


Ext.onReady(function() {
    /*状态*/
    var json_status = [
        {id: "1", code: "1", name: "启用"},
        {id: "2", code: "2", name: "停用"}
    ];
    var button_name = '';//当前操作按钮名称
    var btn_name='';
    var items = [
        {
            xtype: 'button',
            text: '区划变更',
            name: 'qh_change',
            icon: '/image/sysbutton/regist.png',
            handler: function (btn) {
                is_qhbf=true;
                var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                var tree_selected = tree_area.getSelection();
                if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                    Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                    return false;
                }
                button_name = btn.text;
                btn_name=btn.name;
                $.post('/tygn/getJbxx.action', {
                    DW_ID:dwid
                }, function (data) {
                    datas = data.list[0];
                    initWindow_ad_update({
                        title: '区划变更',
                        data:datas
                    });
                }, 'json');
                is_qhbf=false;
            }
        },
        {
            xtype: 'button',
            text: '主管部门变更',
            name: 'zgbm_change',
            icon: '/image/sysbutton/regist.png',
            handler: function (btn) {
                var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                var tree_selected = tree_area.getSelection();
                if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                    Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                    return false;
                }

            /*    var record = DSYGrid.getGrid('unitGrid').getCurrentRecord();
                if (record == null || record == '' || record == 'undefined') {
                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                    return;
                }*/
                button_name = btn.text;
                btn_name=btn.name;
                $.post('/tygn/getJbxx.action', {
                    DW_ID:dwid
                }, function (data) {
                    datas= data.list[0];
                    initWindow_ad_update({
                        title: '主管部门变更',
                        data: datas
                    });
                }, 'json');
            }
        },
        {
            xtype: 'button',
            text: '单位信息变更',
            name: 'dwxx_change',
            icon: '/image/sysbutton/regist.png',
            handler: function (btn) {
                var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                var tree_selected = tree_area.getSelection();
                if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                    Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                    return false;
                }
                button_name = btn.text;
                btn_name=btn.name;
                $.post('/tygn/getJbxx.action', {
                    DW_ID:dwid
                }, function (data) {
                    datas = data.list[0];
                    initWindow_ad_update({
                        title: '单位信息变更',
                        data: datas
                    });
                }, 'json');
            }
        },
        '->',
        initButton_Screen()
    ];

    //定义右键菜单

    var panel=  new Ext.panel.Panel ({
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
                    AG_ID_notleaf: true,//点击非叶子节点查询全局变鲁昂AG_ID
                    AG_NAME_notleaf: true//点击非叶子节点查询全局变鲁昂AG_NAME
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ]

    });

    /**
     * 初始化右侧panel，放置2个表格
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
     * 初始化右侧主表格
     */
    function initUnitGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer',
                width: 35
            },
            {dataIndex: "BGID", type: "string", hidden:true,text: "主键ID", width: 200},
            {dataIndex: "BGLX", type: "string", text: "变更类型" ,width: 200},
            {dataIndex: "AD_BGQ", type: "string", text: "变更前区划编码",width: 150},
            {dataIndex: "AGID_BGQ", type: "string", text: "变更前单位ID", width: 100, hidden:true},
            {dataIndex: "AGCODE_BGQ", type: "string", text: "变更前单位编码", width: 150},
            {dataIndex: "AGNAME_BGQ", type: "string", text: "变更前单位名称", width: 150},
            {dataIndex: "AD_BGH", type: "string", text: "变更后区划", width: 100},
            {dataIndex: "AG_ID_BGH", type: "string", text: "变更后单位ID", width: 150, hidden:true},
            {dataIndex: "AG_CODE_BGH", type: "string", text: "变更后单位编码",width: 150},
            {dataIndex: "AG_NAME_BGH", type: "string", text: "变更后单位名称",width: 150}

        ];
        return DSYGrid.createGrid({
            itemId: 'unitGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: false,
            rowNumber: true,
            border: false,
            autoLoad: false,
            height: '50%',
            flex: 1,
            dataUrl: '/tygn/getGred.action',
            pageConfig: {
                enablePage: false
            },
            listeners: {
                selectionchange: function (view, records) {
//                    //切换工具栏按钮禁用状态
//                    var btns = ['edit', 'delete'];
//                    for (var i = 0; i < btns.length; i++) {
//                        Ext.ComponentQuery.query('button[name="' + btns[i] + '"]')[0].setDisabled(!records.length || records.length <= 0);
//                    }
                }
            }
        });
    };

    /**
     *保存方法
     * @param config
     */

    function initWindow_ad_update(config) {
        var itemss='';
        if (config.title=='区划变更'){
            itemss= initWindow_qh_change_contentForm(config,false);
        } if (config.title=='主管部门变更'){
            itemss= initWindow_zgbm_change_contentForm(config,false);
        }if (config.title=='单位信息变更'){
            itemss= initWindow_dwxx_change_contentForm(config,false);
        }
        Ext.create('Ext.window.Window', {
            title: config.title, // 窗口标题
            width: 720, // 窗口宽度
            height: 510, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_unitinfo', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: itemss,
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    handler: function (self) {
                        var form = self.up('window').down('form');
                        if(config.title == '区划变更'){
                            Ext.Msg.confirm('警告提示', '此操作不可逆，是否需要继续操作？', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                        if (form.isValid()) {
                            var formData = form.getForm().getFieldValues();
                            formData = $.extend({}, formData, form.getValues());
                            $.post('/tygn/updateUnit.action', {
                                detailForm: Ext.util.JSON.encode(formData),
                                title: config.title,
                                DW_ID:dwid,
                                datas:datas
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: "保存成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    self.up('window').close();
                                    // 刷新表格
                                    DSYGrid.getGrid("unitGrid").getStore().loadPage();
                                    var unit_tree = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                                    unit_tree.getStore().load();
                                } else {
                                    Ext.MessageBox.alert('提示', '修改失败!' + data.message);
                                }
                            }, 'JSON');
                        }
                      }
                     });
                    }else {
                            if (form.isValid()) {
                                var formData = form.getForm().getFieldValues();
                                formData = $.extend({}, formData, form.getValues());
                                $.post('/tygn/updateUnit.action', {
                                    detailForm: Ext.util.JSON.encode(formData),
                                    title: config.title,
                                    DW_ID:dwid,
                                    datas:datas
                                }, function (data) {
                                    if (data.success) {
                                        Ext.toast({
                                            html: "保存成功！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        self.up('window').close();
                                        // 刷新表格
                                        DSYGrid.getGrid("unitGrid").getStore().loadPage();
                                        var unit_tree = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                                        unit_tree.getStore().load();
                                    } else {
                                        Ext.MessageBox.alert('提示', '修改失败!' + data.message);
                                    }
                                }, 'JSON');
                            }

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

          /*  var store=getStore(AD_CODE);
            setStore2(store);
*/
    };

    /**
     * 弹出框
     * @param config
     * @returns {Ext.form.Panel}
     */
    function initWindow_qh_change_contentForm(config) {
        var form = Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            itemId: 'window_unitinfo_contentForm',
            layout: 'column',
            scrollable:true,
            defaultType: 'textfield',
            defaults: {
                margin: '3 5 3 5',
                columnWidth: 1,
                labelAlign: "right",
                labelWidth: 110
            },
            items: [
                {
                    xtype: 'fieldset',
                    title: '变更前',
                    flex: 1,
                    items: [
                        {
                            xtype:'container',
                            margin: '0 0 0 0',
                            columnWidth: 1,
                            layout:'column',
                            defaults: {
                                margin: '3 5 3 5',
                                columnWidth: .49,
                                labelAlign: "right",
                                labelWidth: 120//控件默认标签宽度
                            },
                            items:[
                                {
                                    xtype: 'displayfield',
                                    fieldLabel: '上级ID',
                                    name: 'SUPERGUID',
                                    hidden: true
                                },
                                {
                                    xtype: 'displayfield',
                                    fieldLabel: '所属区划',
                                    name: 'ADMDIV',
                                    hidden: true
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '所属区划',
                                    name: 'PROVINCE',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, PROVINCE) {
                                            self.up('form').down('textfield[name="L_PROVINCE"]').setValue(PROVINCE);
                                        }
                                    }
                                },


                                {
                                    fieldLabel: '主管部门',
                                    name: 'SUPDEP',
                                    xtype: 'combobox',
                                    editable: false,
                                    displayField: 'name',
                                    valueField: 'id',
                                    store: DebtEleStoreTable('DSY_V_ELE_ZGBM'),
                                    allowBlank: false,//不允许为空
                                    disabled: true,
                                    listeners: {
                                        change: function (self, id) {
                                           // self.up('form').down('textfield[name="L_SUPDEP"]').setValue(id);
                                        }
                                    }
                                },
                                {
                                    fieldLabel: '单位ID',
                                    name: 'GUID',
                                    hidden: true
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '单位编码',
                                    name: 'CODE',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, CODE) {
                                            var  l_code = CODE.substring(0,3);
                                            var  r_code = CODE.substring(3,6);
                                            self.up('form').down('textfield[name="L_CODE"]').setValue(l_code);
                                            self.up('form').down('textfield[name="R_CODE"]').setValue(r_code);
                                        }
                                    }
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '单位名称',
                                    name: 'NAME',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, NAME) {
                                            self.up('form').down('textfield[name="L_NAME"]').setValue(NAME);
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '变更后单位',
                    flex: 1,
                    items: [
                        {
                            xtype:'container',
                            margin: '0 0 0 0',
                            columnWidth: 1,
                            layout:'column',
                            defaults: {
                                margin: '3 5 3 5',
                                columnWidth: .98,
                                labelAlign: "right",
                                labelWidth: 120//控件默认标签宽度
                            },
                            items: [
                                {
                                    xtype: "treecombobox",
                                    fieldLabel: '<span class="required">✶</span>所属区划',
                                    name: "L_PROVINCE",
                                    labelAlign: 'right',
                                    displayField: 'text' ,selectModel: 'leaf',
                                    valueField: 'code',
                                    rootVisible: false,
                                    allowBlank: false,
                                    editable:false,
                                    store: xeglAreaStore,
                                    listeners: {
                                        'select': function (self, record) {
                                            ad =record.get("code");
                                           Ext.Ajax.request({
                                                url: '/tygn/getCurrentZgbm.action?ADCODE='+ad,
                                                method: 'POST',
                                                success: function (response, options) {
                                                    self.up('form').down('textfield[name="L_SUPDEP"]').setValue(" ");
                                                    var  testJson = Ext.util.JSON.encode("(" + response.responseText + ")");
                                                    ad=testJson.list;
                                                    console.log(ad);
                                                    for (var i=0;i<ad.length;i++){
                                                        ad[i].leaf=1;
                                                    }
                                                    if(ad.length<=0){
                                                        Ext.MessageBox.alert('失败',"该区划下没有主管部门,请重新选择");
                                                        self.up('form').down('textfield[name="L_SUPDEP"]').setValue("");
                                                    }
                                                    var ppp=  DebtEleStore(ad);
                                                    self.up('form').down('[name="L_SUPDEP"]').setStore(ppp);
                                                }
                                            });

                                        }
                                    }
                                },
                                {
                                    fieldLabel: '<span class="required">✶</span>主管部门',
                                    name: 'L_SUPDEP',
                                    xtype: 'combobox',
                                    editable: false,
                                    displayField: 'NAME',
                                    valueField: 'ID',
                                    labelAlign: 'right',
                                    rootVisible: false,
                                    //store: DebtEleStoreTable('DSY_V_ELE_ZGBM'),
                                    store:"",
                                    allowBlank: false,//不允许为空
                                    listeners: {
                                        'select': function (self, record) {
                                            self.up('form').down('textfield[name="L_CODE"]').setValue(record.get("ID"));
                                        }
                                    }

                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 0 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items: [
                                        {
                                            xtype: 'textfield',
                                            fieldLabel: '<span class="required">✶</span>单位编码',
                                            name: 'L_CODE',
                                            disabled: true,
                                            allowBlank: false

                                        },{
                                            xtype: 'textfield',
                                            name: 'R_CODE',
                                            regex: /^[0-9][0-9][0-9]$/,
                                            regexText:'请输入正确的整数',
                                            maxLength: 3,
                                            minLength :3,
                                            disabled: false,
                                            margin: '3 0 0 0',
                                            allowBlank: false//不允许为空

                                        }
                                    ]
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '<span class="required">✶</span>单位名称',
                                    name: 'L_NAME'

                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 5 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items:[
                                        {
                                            fieldLabel: '简称',
                                            xtype: 'textfield',
                                            name: 'ALIAS',
                                            disabled: false,
                                            allowBlank: true//允许为空

                                        },
                                        {
                                            fieldLabel: '<span class="required">✶</span>状态',
                                            name: 'STATUS',
                                            xtype: 'combobox',
                                            editable: false,
                                            displayField: 'name',
                                            valueField: 'id',
                                            value: 1,
                                            store: DebtEleStore(json_status),
                                            allowBlank: false,//不允许为空

                                        }
                                    ]
                                },
                                {
                                    fieldLabel: '<span class="required">✶</span>单位类型',
                                    name: 'ZWDWLX',
                                    xtype: 'treecombobox',
                                    editable: false,
                                    displayField: 'name',
                                    valueField: 'id',
                                    store: DebtEleTreeStoreDB("DEBT_ZWDWLX"),
                                    allowBlank: false//不允许为空
                                },
                                {
                                    fieldLabel: '<span class="required">✶</span>部门分类',
                                    name: 'BMFL',
                                    xtype: 'treecombobox',
                                    editable: false,
                                    displayField: 'name',
                                    valueField: 'id',
                                    rootVisible:false,
                                    selectModel:'leaf',
                                    store: DebtEleTreeStoreDB("DEBT_BMFL"),
                                    allowBlank: false//不允许为空
                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 5 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items:[
                                        {
                                            fieldLabel: '组织机构代码',
                                            xtype: 'textfield',
                                            name: 'ORGCODE',
                                            disabled: false,
                                            allowBlank: true//允许为空

                                        },{
                                            fieldLabel: '社会统一信用码',
                                            xtype: 'textfield',
                                            name: 'USCCODE',
                                            disabled: false,
                                            allowBlank: true//允许为空
                                        },{
                                            fieldLabel: '法人代表',
                                            name: 'FRDB',
                                            xtype: 'textfield',
                                            allowBlank: true//不允许为空
                                        },{
                                            fieldLabel: '财务负责人',
                                            name: 'CWFZR',
                                            xtype: 'textfield',
                                            disabled: false,
                                            allowBlank: true//允许为空

                                        },{
                                            fieldLabel: '联系电话',
                                            name: 'TEL',
                                            xtype: 'textfield',
                                            //regex:/(^(\d{3,4}-)?\d{7,8})$|(13[0-9]{9})/,
                                            // regexText:'请输入正确电话号码',
                                            allowBlank: true//不允许为空
                                        }
                                    ]
                                },
                                    {
                                    fieldLabel: '地址',
                                    name: 'ADDRESS',
                                    allowBlank: true//不允许为空
                                }
                            ]
                        }
                    ]
                }
            ]
        });
        //初始化及回显
        form.getForm().setValues(config.data);
        return form;
    };
    function initWindow_zgbm_change_contentForm(config) {
        var form = Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            itemId: 'window_unitinfo_contentForm',
            layout: 'column',
            scrollable:true,
            defaultType: 'textfield',
            defaults: {
                margin: '3 5 3 5',
                columnWidth: 1,
                labelAlign: "right",
                labelWidth: 110
            },
            items: [
                {
                    xtype: 'fieldset',
                    title: '变更前',
                    flex: 1,
                    items: [
                        {
                            xtype:'container',
                            margin: '0 0 0 0',
                            columnWidth: 1,
                            layout:'column',
                            defaults: {
                                margin: '3 5 3 5',
                                columnWidth: .49,
                                labelAlign: "right",
                                labelWidth: 120//控件默认标签宽度
                            },
                            items:[
                                {
                                    xtype: 'displayfield',
                                    fieldLabel: '所属区划',
                                    name: 'ADMDIV',
                                    hidden: true
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '所属区划',
                                    name: 'PROVINCE',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, PROVINCE) {
                                            self.up('form').down('textfield[name="L_PROVINCE"]').setValue(PROVINCE);
                                        }
                                    }
                                },


                                {
                                    fieldLabel: '主管部门',
                                    name: 'SUPDEP',
                                    xtype: 'combobox',
                                    editable: false,
                                    displayField: 'name',
                                    valueField: 'id',
                                    store: DebtEleStoreTable('DSY_V_ELE_ZGBM'),
                                    allowBlank: false,//不允许为空
                                    disabled: true,
                                    listeners: {
                                        change: function (self, id) {
                                            self.up('form').down('textfield[name="L_SUPDEP"]').setValue(id);
                                        }
                                    }
                                },
                                {
                                    fieldLabel: '单位ID',
                                    name: 'GUID',
                                    hidden: true
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '单位编码',
                                    name: 'CODE',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, CODE) {
                                            var  l_code = CODE.substring(0,3);
                                            var  r_code = CODE.substring(3,6);
                                            self.up('form').down('textfield[name="L_CODE"]').setValue(l_code);
                                            self.up('form').down('textfield[name="R_CODE"]').setValue(r_code);
                                        }
                                    }
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '单位名称',
                                    name: 'NAME',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, NAME) {
                                            self.up('form').down('textfield[name="L_NAME"]').setValue(NAME);
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '变更后单位',
                    flex: 1,
                    items: [
                        {
                            xtype:'container',
                            margin: '0 0 0 0',
                            columnWidth: 1,
                            layout:'column',
                            defaults: {
                                margin: '3 5 3 5',
                                columnWidth: .98,
                                labelAlign: "right",
                                labelWidth: 120//控件默认标签宽度
                            },
                            items: [
                                {
                                    xtype: "treecombobox",
                                    fieldLabel: '所属区划',
                                    name: "L_PROVINCE",
                                    labelAlign: 'right',
                                    displayField: 'text' ,
                                    valueField: 'code',
                                    rootVisible: false,
                                    allowBlank: false,
                                    editable:false,
                                    disabled: true,
                                    store: xeglAreaStore ,
                                    listeners: {
                                        'select': function (self, record) {
                                            // var SET_YEAR = self.up('form').down('combobox[name="SET_YEAR"]').getValue();
                                            // var record = xeglAreaStore.findNode('code', record.get("code"), true, true, true);
                                            //self.up('form').down('textfield[name="PROVINCE"]').setValue(record.get('text'));
                                        }
                                    }
                                },
                                {
                                    fieldLabel: '<span class="required">✶</span>主管部门',
                                    name: 'L_SUPDEP',
                                    xtype: 'combobox',
                                    editable: false,
                                    displayField: 'NAME',
                                    valueField: 'ID',
                                    labelAlign: 'right',
                                    rootVisible: false,
                                    //store: DebtEleStoreTable('DSY_V_ELE_ZGBM'),
                                    store:getStore(AD_CODE),
                                    allowBlank: false,//不允许为空
                                    listeners: {
                                        'select': function (self, record) {
                                            self.up('form').down('textfield[name="L_CODE"]').setValue(record.get("ID"));
                                        }
                                    }

                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 0 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items: [
                                        {
                                            xtype: 'textfield',
                                            fieldLabel: '单位编码',
                                            name: 'L_CODE',
                                            disabled: true

                                        },{
                                            xtype: 'textfield',
                                            name: 'R_CODE',
                                            regex: /^[0-9][0-9][0-9]$/,
                                            regexText:'请输入正确的整数',
                                            maxLength: 3,
                                            minLength :3,
                                            disabled: false,
                                            margin: '3 0 0 0',
                                            allowBlank: false//不允许为空

                                        }
                                    ]
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '<span class="required">✶</span>单位名称',
                                    name: 'L_NAME',
                                    disabled: true

                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 5 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items:[
                                        {
                                            fieldLabel: '简称',
                                            xtype: 'textfield',
                                            name: 'ALIAS',
                                            disabled: false,
                                            disabled: true,
                                            allowBlank: true//允许为空

                                        },
                                        {
                                            fieldLabel: '<span class="required">✶</span>状态',
                                            name: 'STATUS',
                                            xtype: 'combobox',
                                            editable: false,
                                            disabled: true,
                                            displayField: 'name',
                                            valueField: 'id',
                                            value: 1,
                                            store: DebtEleStore(json_status),
                                            allowBlank: false,//不允许为空

                                        }
                                    ]
                                },
                                {
                                    fieldLabel: '<span class="required">✶</span>单位类型',
                                    name: 'ZWDWLX',
                                    xtype: 'treecombobox',
                                    editable: false,
                                    disabled: true,
                                    displayField: 'name',
                                    valueField: 'id',
                                    store: DebtEleTreeStoreDB("DEBT_ZWDWLX"),
                                    allowBlank: false//不允许为空
                                },
                                {
                                    fieldLabel: '部门分类',
                                    name: 'BMFL',
                                    xtype: 'treecombobox',
                                    editable: false,
                                    disabled: true,
                                    displayField: 'name',
                                    valueField: 'id',
                                    rootVisible:false,
                                    selectModel:'leaf',
                                    store: DebtEleTreeStoreDB("DEBT_BMFL"),
                                    allowBlank: true//不允许为空
                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 5 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items:[
                                        {
                                            fieldLabel: '组织机构代码',
                                            xtype: 'textfield',
                                            name: 'ORGCODE',
                                            disabled: true,
                                            allowBlank: true//允许为空

                                        },{
                                            fieldLabel: '社会统一信用码',
                                            xtype: 'textfield',
                                            name: 'USCCODE',
                                            disabled: true,
                                            allowBlank: true//允许为空
                                        },{
                                            fieldLabel: '法人代表',
                                            name: 'FRDB',
                                            xtype: 'textfield',
                                            disabled: true,
                                            allowBlank: true//不允许为空
                                        },{
                                            fieldLabel: '财务负责人',
                                            name: 'CWFZR',
                                            xtype: 'textfield',
                                            disabled: true,
                                            allowBlank: true//允许为空

                                        },{
                                            fieldLabel: '联系电话',
                                            name: 'TEL',
                                            xtype: 'textfield',
                                            disabled: true,
                                            //regex:/(^(\d{3,4}-)?\d{7,8})$|(13[0-9]{9})/,
                                            // regexText:'请输入正确电话号码',
                                            allowBlank: true//不允许为空
                                        }
                                    ]
                                },
                                {
                                    fieldLabel: '地址',
                                    name: 'ADDRESS',
                                    disabled: true,
                                    allowBlank: true//不允许为空
                                }
                            ]
                        }
                    ]
                }
            ]
        });
        //初始化及回显
        form.getForm().setValues(config.data);
        return form;
    };
    function initWindow_dwxx_change_contentForm(config) {
        var form = Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            itemId: 'window_unitinfo_contentForm',
            layout: 'column',
            scrollable:true,
            defaultType: 'textfield',
            defaults: {
                margin: '3 5 3 5',
                columnWidth: 1,
                labelAlign: "right",
                labelWidth: 110
            },
            items: [
                {
                    xtype: 'fieldset',
                    title: '变更前',
                    flex: 1,
                    items: [
                        {
                            xtype:'container',
                            margin: '0 0 0 0',
                            columnWidth: 1,
                            layout:'column',
                            defaults: {
                                margin: '3 5 3 5',
                                columnWidth: .49,
                                labelAlign: "right",
                                labelWidth: 120//控件默认标签宽度
                            },
                            items:[
                                {
                                    xtype: 'displayfield',
                                    fieldLabel: '所属区划',
                                    name: 'ADMDIV',
                                    hidden: true
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '所属区划',
                                    name: 'PROVINCE',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, PROVINCE) {
                                            self.up('form').down('textfield[name="L_PROVINCE"]').setValue(PROVINCE);
                                        }
                                    }
                                },


                                {
                                    fieldLabel: '主管部门',
                                    name: 'SUPDEP',
                                    xtype: 'combobox',
                                    editable: false,
                                    displayField: 'name',
                                    valueField: 'id',
                                    store: DebtEleStoreTable('DSY_V_ELE_ZGBM'),
                                    allowBlank: false,//不允许为空
                                    disabled: true,
                                    listeners: {
                                        change: function (self, id) {
                                            self.up('form').down('textfield[name="L_SUPDEP"]').setValue(id);
                                        }
                                    }
                                },
                                {
                                    fieldLabel: '单位ID',
                                    name: 'GUID',
                                    hidden: true
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '单位编码',
                                    name: 'CODE',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, CODE) {
                                            var  l_code = CODE.substring(0,3);
                                            var  r_code = CODE.substring(3,6);
                                            self.up('form').down('textfield[name="L_CODE"]').setValue(l_code);
                                            self.up('form').down('textfield[name="R_CODE"]').setValue(r_code);
                                        }
                                    }
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '单位名称',
                                    name: 'NAME',
                                    disabled: true,
                                    listeners: {
                                        change: function (self, NAME) {
                                            self.up('form').down('textfield[name="L_NAME"]').setValue(NAME);
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '变更后单位',
                    flex: 1,
                    items: [
                        {
                            xtype:'container',
                            margin: '0 0 0 0',
                            columnWidth: 1,
                            layout:'column',
                            defaults: {
                                margin: '3 5 3 5',
                                columnWidth: .98,
                                labelAlign: "right",
                                labelWidth: 120//控件默认标签宽度
                            },
                            items: [
                                {
                                    xtype: "treecombobox",
                                    fieldLabel: '所属区划',
                                    name: "L_PROVINCE",
                                    labelAlign: 'right',
                                    displayField: 'text' ,
                                    valueField: 'code',
                                    rootVisible: false,
                                    allowBlank: false,
                                    editable:false,
                                    disabled: true,
                                    store: xeglAreaStore ,
                                    listeners: {
                                        'select': function (self, record) {
                                            // var SET_YEAR = self.up('form').down('combobox[name="SET_YEAR"]').getValue();
                                            // var record = xeglAreaStore.findNode('code', record.get("code"), true, true, true);
                                            //self.up('form').down('textfield[name="PROVINCE"]').setValue(record.get('text'));
                                        }
                                    }
                                },
                                {
                                    fieldLabel: '<span class="required">✶</span>主管部门',
                                    name: 'L_SUPDEP',
                                    xtype: 'combobox',
                                    editable: false,
                                    displayField: 'NAME',
                                    valueField: 'ID',
                                    labelAlign: 'right',
                                    rootVisible: false,
                                    disabled: true,
                                    //store: DebtEleStoreTable('DSY_V_ELE_ZGBM'),
                                    store:getStore(AD_CODE),
                                    allowBlank: false,//不允许为空
                                    listeners: {
                                        'select': function (self, record) {
                                            self.up('form').down('textfield[name="L_CODE"]').setValue(record.get("ID"));
                                        }
                                    }

                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 0 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items: [
                                        {
                                            xtype: 'textfield',
                                            fieldLabel: '<span class="required">✶</span>单位编码',
                                            name: 'L_CODE',
                                            disabled: true

                                        },{
                                            xtype: 'textfield',
                                            name: 'R_CODE',
                                            regex: /^[0-9][0-9][0-9]$/,
                                            regexText:'请输入正确的整数',
                                            maxLength: 3,
                                            minLength :3,
                                            disabled: false,
                                            margin: '3 0 0 0',
                                            allowBlank: false//不允许为空

                                        }
                                    ]
                                },
                                {
                                    xtype: 'textfield',
                                    fieldLabel: '<span class="required">✶</span>单位名称',
                                    name: 'L_NAME',
                                    disabled: false

                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 5 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items:[
                                        {
                                            fieldLabel: '简称',
                                            xtype: 'textfield',
                                            name: 'ALIAS',
                                            disabled: false,
                                            disabled: true,
                                            allowBlank: true//允许为空

                                        },
                                        {
                                            fieldLabel: '状态',
                                            name: 'STATUS',
                                            xtype: 'combobox',
                                            editable: false,
                                            disabled: true,
                                            displayField: 'name',
                                            valueField: 'id',
                                            value: 1,
                                            store: DebtEleStore(json_status),
                                            allowBlank: false,//不允许为空

                                        }
                                    ]
                                },
                                {
                                    fieldLabel: '单位类型',
                                    name: 'ZWDWLX',
                                    xtype: 'treecombobox',
                                    editable: false,
                                    disabled: true,
                                    displayField: 'name',
                                    valueField: 'id',
                                    store: DebtEleTreeStoreDB("DEBT_ZWDWLX"),
                                    allowBlank: false//不允许为空
                                },
                                {
                                    fieldLabel: '部门分类',
                                    name: 'BMFL',
                                    xtype: 'treecombobox',
                                    editable: false,
                                    disabled: true,
                                    displayField: 'name',
                                    valueField: 'id',
                                    rootVisible:false,
                                    selectModel:'leaf',
                                    store: DebtEleTreeStoreDB("DEBT_BMFL"),
                                    allowBlank: true//不允许为空
                                },
                                {
                                    xtype:'container',
                                    margin: '0 0 0 0',
                                    columnWidth: 1,
                                    layout:'column',
                                    defaults: {
                                        margin: '3 5 3 5',
                                        columnWidth: .49,
                                        labelAlign: "right",
                                        labelWidth: 120//控件默认标签宽度
                                    },
                                    items:[
                                        {
                                            fieldLabel: '组织机构代码',
                                            xtype: 'textfield',
                                            name: 'ORGCODE',
                                            disabled: true,
                                            allowBlank: true//允许为空

                                        },{
                                            fieldLabel: '社会统一信用码',
                                            xtype: 'textfield',
                                            name: 'USCCODE',
                                            disabled: true,
                                            allowBlank: true//允许为空
                                        },{
                                            fieldLabel: '法人代表',
                                            name: 'FRDB',
                                            xtype: 'textfield',
                                            disabled: true,
                                            allowBlank: true//不允许为空
                                        },{
                                            fieldLabel: '财务负责人',
                                            name: 'CWFZR',
                                            xtype: 'textfield',
                                            disabled: true,
                                            allowBlank: true//允许为空

                                        },{
                                            fieldLabel: '联系电话',
                                            name: 'TEL',
                                            xtype: 'textfield',
                                            disabled: true,
                                            //regex:/(^(\d{3,4}-)?\d{7,8})$|(13[0-9]{9})/,
                                            // regexText:'请输入正确电话号码',
                                            allowBlank: true//不允许为空
                                        }
                                    ]
                                },
                                {
                                    fieldLabel: '地址',
                                    name: 'ADDRESS',
                                    disabled: true,
                                    allowBlank: true//不允许为空
                                }
                            ]
                        }
                    ]
                }
            ]
        });
        //初始化及回显
        form.getForm().setValues(config.data);
        return form;

    };
});
