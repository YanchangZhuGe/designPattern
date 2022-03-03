<%--suppress ALL --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="UTF-8" import="com.bgd.platform.util.service.*"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
<meta charset="UTF-8">
<title>大项目维护</title>
    <script src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/js/debt/ele_data.js"></script>
    <style type="text/css">
        html,body{
            width: 100%;height:100%;margin: 0px auto;
        }
 
        span.required {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body style="margin: 0px">
<div id="unitManage" style="width: 100%;height:100%;margin: 0px auto;">
</div>
<script type="text/javascript">
    var rel_adcode = '${sessionScope.ADCODE}'.replace(/00$/,"");
    var userName = '${sessionScope.USERNAME}';
    var nowDate = '${fns:getDbDateDay()}';

    Ext.define('sjxmModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id',mapping:'DXM_ID'},
            {name: 'name',mapping:'DXM_NAME'}
        ]
    });
    //区划模型
    Ext.define('QHModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id',mapping:'CODE'},
            {name: 'name',mapping:'NAME'}
        ]
    });
    /**
     * 获取区划数据
     */
    function getQhStore(filterParam){
        var DxmDataStore = Ext.create('Ext.data.Store', {
            model: 'QHModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: "/getQhData.action",
                reader: {
                    type: 'json'
                },
                extraParams:filterParam
            },
            autoLoad: true
        });
        return DxmDataStore;
    }

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
        var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
        //初始化表格Store参数
        store.getProxy().extraParams = {
            //AD_CODE: AD_CODE
            DXM_ID: DXM_ID,
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
                    reloadGrid();
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
                    var Root = selected_ad.parentNode.id;
                    var dxm_id=selected_ad.data.id;//获取选中的大项目code
                    var dxm_name=selected_ad.data.text;//获取选中的大项目name
                    if (dxm_name == "大项目信息" || dxm_name==null || dxm_id.toString().length<20) {
                        dxm_id="";
                        /*Ext.Msg.alert('提示', "请选择大项目");
                        return;*/
                    }
                    button_name = btn.text;
                    var data = {
                        ROOT : Root,
                        DXM_ID:dxm_id,
                        DXM_NAME:dxm_name,
                        button_name:button_name,
                    };
                    var record={
                        U_DXM_ID:null
                    };
                    //弹出弹出框
                    initWindow_unitinfo({
                        title: '大项目维护',
                        data: data,
                        record:record
                    });
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'edit',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    var selectRecord = DSYGrid.getGrid('unitGrid').getSelection();
                    if (selectRecord.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (selectRecord.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    }
                    button_name = btn.text;
                    var record = selectRecord[0].data;
                    var data = {
                        AD_CODE:record.AD_CODE,
                        AD_NAME:record.AD_NAME,
                        button_name:button_name,
                        Root:null
                    };
                    initWindow_unitinfo({
                        title: '修改账户信息',
                        record : record,
                        data: data
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
                            var dxmIdInfoArray = new  Array();
                            Ext.each(records, function (record) {
                                var dxm_id = record.get("DXM_ID");
                                dxmIdInfoArray.push(dxm_id);
                            });
                            //发送ajax请求，删除数据
                            $.post("/delDxmInfo.action", {
                                dxmIdInfoArray: Ext.util.JSON.encode(dxmIdInfoArray)
                            }, function (data) {
                                if (data.success) {
                                    /*Ext.toast({
                                        html: button_name + "成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });*/
                                    Ext.toast({
                                        html: "删除成功！" + (data.message ? data.message : ''),
                                        closable: false, align: 't', slideInDuration: 400, minWidth: 400
                                    });
                                    //刷新表格
                                    reloadGrid();
                                    //刷新左侧树
                                    var unit_tree = Ext.ComponentQuery.query('treepanel#tree_dxm')[0];
                                    var unit_store = unit_tree.getStore();
                                    unit_store.load();
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
                    items_tree: function () {
                        return [
                            //initContentTree_area()//区划树
                            initContentTree()//大项目树
                        ]
                    }
                }),
                initContentRightPanel()//初始化右侧表格
            ]
        });
        function initContentTree(){
            Ext.define('treeModel', {
                extend: 'Ext.data.Model',
                fields: [
                    {name: 'text'},
                    {name: 'code'},
                    {name: 'id'},
                    {name: 'leaf'}
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
                items: initContentTree_dxm()
            });
        }
        /**
         * 初始化左侧树：大项目树
         */
        function initContentTree_dxm() {
            //加载左侧上方树数据
            var regStore = Ext.create('Ext.data.TreeStore', {
                proxy: {
                    type: 'ajax',
                    method: 'POST',
                    url: 'getDxmTree.action',
                    extraParams: {
                        AD_CODE:AD_CODE
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
                DXM_ID = record.get('id');
                reloadGrid();
            }
        }
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
                {dataIndex: "AD_CODE", type: "string", text: "地区编码", width: 150,hidden:true},
                {dataIndex: "AD_NAME", type: "string", text: "地区", width: 150},
                {dataIndex: "DXM_ID", type: "string", text: "项目ID", width: 150,hidden:true},
                {dataIndex: "DXM_CODE", type: "string", text: "编码", width: 150},
                {dataIndex: "U_DXM_ID", type: "string", text: "上级项目ID", width: 150,hidden:true},
                {dataIndex: "U_DXM_NAME", type: "string", text: "上级项目", width: 200},
                {dataIndex: "DXM_NAME", type: "string", text: "名称", width: 200},
                {dataIndex: "JSQX", type: "string", text: "建设期限(止)", width: 150},
                {dataIndex: "JSZT", type: "string", text: "建设状态", width: 150},
//                {
//                    text: '项目分类',
//                    dataIndex: 'XMFL',
//                    type: "string",
//                    renderer: function (value) {
//                        var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
//                        return result != null ? result.get('name') : value;
//                    }
//                },
//                {dataIndex: "ZXDW_NAME", type: "string", text: "项目执行单位", width: 150},
                {dataIndex: "DXM_DESC", type: "string", text: "大项目描述", width: 350}
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
                dataUrl: 'getDxmByID.action',
                height: '100%',
                tbar: [
                    {
                        fieldLabel: '模糊查询',
                        name: 'mhcx',
                        xtype: "textfield",
                        width: 300,
                        labelWidth: 60,
                        labelAlign: 'right',
                        emptyText: '大项目名称...',
                        enableKeyEvents: true,
                        listeners:{
                            specialkey:function(field,e){
                                if(e.getKey()==Ext.EventObject.ENTER){
                                    reloadGrid();
                                }
                            }
                        }
                    }
                ],
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
                height: 400, // 窗口高度
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
         * 保存事件js
         */
        function submitInfo(config,self,msg) {
            var button_name = config.data.button_name;
            var form = self.up('window').down('form');
            var u_dxm_id = form.down('[name=U_DXM_ID]').getValue();
//            if (!compareActDate(form)) {
//                message_error = '建设期限不得早于当前日期!!!';
//                if (message_error != null && message_error != '') {
//                    Ext.Msg.alert('提示', message_error);
//                    return false;
//                }
//            }
            if (form.isValid()) {
                self.setDisabled(true);
                var formData = form.getForm().getFieldValues();
                formData = $.extend({
                    AD_CODE:config.data.AD_CODE,
                    button_name:config.data.button_name
                }, formData, form.getValues());
                if(button_name=='修改'){
                    formData.DXM_ID=config.record.DXM_ID;
                }
                $.post('saveDxmInfo.action', {
                    detailForm: Ext.util.JSON.encode([formData]),
                    button_name:button_name
                }, function (data) {

                    if (data.success) {
                        self.setDisabled(false);
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
                        //刷新左侧树
                        var unit_tree = Ext.ComponentQuery.query('treepanel#tree_dxm')[0];
                        var unit_store = unit_tree.getStore();
                        unit_store.load();

                    } else {
                        self.setDisabled(false);
                        if(data.message != undefined){
                            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                        }else{
                            Ext.MessageBox.alert('提示', '保存失败!' );
                        }
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
                        fieldLabel: '大项目ID',
                        name: 'U_DXM_ID',
                        xtype: 'displayfield',
                        editable: false,
                        value:config.data.DXM_ID,
                        hidden: true
                    }, {
                        fieldLabel: '上级项目名称',
                        name: 'U_DXM_NAME',
                        xtype: 'textfield',
                        editable: false,
                        disabled: true,
                        value:config.data.DXM_ID==''?"":config.data.DXM_NAME,
                        fieldStyle: 'background:#E6E6E6',
                        //allowBlank: false
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>大项目编码',
                        name: 'DXM_CODE',
                        xtype: 'textfield',
                        allowBlank: false//不允许为空
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>大项目名称',
                        xtype: 'textfield',
                        name: 'DXM_NAME',
                        allowBlank: false//不允许为空
                    },
                     {
                        fieldLabel: '<span class="required">✶</span>区划',
                        xtype: 'combobox',
                        name: 'AD_NAME',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                         allowBlank: false,//不允许为空
                        store: getQhStore({DXM_ID:config.data.DXM_ID,adcode:rel_adcode})
                        //hidden: config.data.ROOT == 'root' || (config.data.ROOT == null && config.record.U_DXM_ID =='' ) ? true:false//根据是否为省,判断是否可以录入。
                         /*listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var u_dxm_id = form.findField('U_DXM_ID').value;
                                $.post('/getJsqx.action', {
                                    U_DXM_ID: u_dxm_id
                                }, function (data) {
                                    if (data.success) {
                                        var JSQX = form.findField('JSQX');
                                        JSQX.setValue(data.JSQX);
                                        //JSQX.setEditable(false);
                                        JSQX.setReadOnly(true);
                                    } else {
                                        Ext.MessageBox.alert('提示', data.message);
                                    }
                                }, "json");
                            }
                        }*/
                    },
                    {
                        xtype: 'fieldcontainer',
                        fieldLabel: '<span class="required">✶</span>建设期限',
                        layout: 'hbox',
                        items: [
                            {
                                xtype: 'datefield',
                                format: 'Y-m-d',
                                name: 'JSQX',
                                allowBlank: false,
                                columnWidth: .7,
                            },
                            {
                                xtype: 'label',
                                text: '止',
                                margin:'3 5 2 5'
                            },
                        ]
                    },
                    {
                        fieldLabel: '今天',
                        xtype: 'datefield',
                        format: 'Y-m-d',
                        name: 'TODAY',
                        value:new Date(),
                        hidden:true
                    },
                    {
                        xtype: "combobox",
                        fieldLabel:'项目类型',
                        name:'XMFL',
                        store:DebtEleStore(json_debt_xmfl),
                        allowBlank: true,
                        editable: false, //禁用编辑
                        displayField: "name",
                        valueField: "id",
                        hidden:true
                    },
//                    {
//                        fieldLabel: '项目执行单位',
//                        xtype: 'textfield',
//                        name: 'ZXDW_NAME',
//                        allowBlank: true
//                    },
                    {
                        fieldLabel: '大项目描述',
                        xtype: 'textareafield',
                        name: 'DXM_DESC',
                        allowBlank: true
                    },
                ]
            });
            if(config.data.button_name=='修改'){
                //初始化及回显
                form.getForm().setValues(config.record);
                form.getForm().findField('AD_NAME').setReadOnly(true);
                form.getForm().findField('AD_NAME').setFieldStyle('background:#E6E6E6');
                form.getForm().findField('U_DXM_NAME').setReadOnly(true);
                form.getForm().findField('U_DXM_NAME').setFieldStyle('background:#E6E6E6');
//                form.getForm().findField('JSQX').setReadOnly(true);
               /* form.getForm().findField('DXM_CODE').setReadOnly(true);
                form.getForm().findField('DXM_NAME').setReadOnly(true);
                form.getForm().findField('DXM_CODE').setFieldStyle('background:#E6E6E6');
                form.getForm().findField('DXM_NAME').setFieldStyle('background:#E6E6E6');*/

            }

            var u_dxm_id = config.data.DXM_ID;
            $.post('/getJsqx.action', {
                U_DXM_ID: u_dxm_id
            }, function (data) {
                if (data.success) {
                    var JSQX = form.getForm().findField('JSQX');
                    JSQX.setValue(data.JSQX);
                    //JSQX.setEditable(false);
                    JSQX.setReadOnly(true);
                   /* var AD_CODE = form.getForm().findField('AD_CODE');
                    AD_CODE.setValue(data.AD_CODE);
                    AD_CODE.setReadOnly(true);*/
                } /*else {
                    Ext.MessageBox.alert('提示', data.message);
                }*/
            }, "json");

            return form;
        }
    });

    function compareActDate(form) {
        var JSQX = form.down('[name=JSQX]').getValue();
        var TODAY = form.down('[name=TODAY]').getValue();
        if (JSQX && today && JSQX < TODAY) {
            return false;
        }
        return true;
    }

</script>

</body>
</html>