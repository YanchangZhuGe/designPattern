var is_grid = 1;
var XM_ID = '';
var IS_RZXQ_HIDDEN =true;
var condition = " AND 1=1 ";
var store_xmlx = DebtEleTreeStoreDB('DEBT_ZWXMLX', {condition: condition});
var store_cylx = DebtEleTreeStoreDB('DEBT_BDBCYLX', {condition: condition});
var store_xmxz = DebtEleTreeStoreDB("DEBT_ZJYT",{condition : ''});
Ext.define('Ext.ux.PopupGridForKjhsXM', {
    extend: 'Ext.form.field.ComboBox',
    xtype: 'PopupGridForKjhsXM',

    uses: [
        'Ext.grid.Panel', 'Ext.window.Window'
    ],

    triggerCls: Ext.baseCSSPrefix + 'form-arrow-trigger',

    config: {
        /**
         * @cfg {Ext.data.TreeStore} treeStore
         * A tree store that the tree will be bound to
         */

        window: null,
        grid: null,

        /**
         * @cfg {String} displayField
         * @cfg {Array} displayField
         * The field inside the model that will be used as the node's text.
         * Defaults to the default value of {@link Ext.tree.Panel}'s `displayField` configuration.
         */
        displayField: 'text',
        IS_RZPT: 0,
        valueField: null,
        is_grid: 1,

        /**
         * @cfg {Number} windowHeight
         * The  height of the pop-up window. Defaults to 350.
         */
        windowHeight: 450,

        /**
         * @cfg {Number} windowWidth
         * The minimum width of the pop-up window. Defaults to 600.
         */
        windowWidth: 1000,

        /**
         * @cfg {Boolean} rootVisible
         * 是否显示根节点.Defaults to 'true'.
         */
        //rootVisible: true,
        /**
         * @cfg {String} closeAction
         * 弹出窗口关闭状态，可选值为：'destroy'、'hide'.Defaults to 'true'.
         * hide：关闭时隐藏弹出框
         * destroy：关闭时销毁
         */
        closeAction: 'destroy',
        /**
         * @cfg {Boolean} rootVisible
         * 是否多选.Defaults to 'false'.
         */
        multi: false,

        gridConfig: {}

    },

    editable: false,
    header: [],

    /**
     * @event select
     * Fires when a tree node is selected
     */

    initComponent: function () {
        var me = this;

        me.callParent(arguments);

        me.mon(me.store, {
            scope: me,
            expand: me.onExpand
        });
    },

    /**
     * Runs when the picker is expanded.  Selects the appropriate tree node based on the value of the input element,
     * and focuses the picker so that keyboard navigation will work.
     * @protected
     */
    onExpand: function () {
        var me = this;
        if (!me.window || me.closeAction == 'destroy') {
            // 获取显示字段，若无，默认text
            var displayField = me.displayField;
            // 创建表格
            me.grid = new DSYGridV2();
            var defaultGridConfig = {
                itemId: 'contentGrid_jsxm',
                name : 'PopupGridForZwdjXm',
                headerConfig: {
                    rowNumber: true,
                    headerJson:[ {
                        "dataIndex": "XM_ID",
                        "type": "string",
                        "text": "债务ID",
                        "hidden": true
                    }, {
                        "dataIndex": "XM_CODE",
                        "type": "string",
                        "text": "项目编码",
                        "width": 130
                    },{
                        "dataIndex": "XM_NAME",
                        "type": "string",
                        "text": "项目名称",
                        "width": 160,
                        renderer: function (data, cell, record) {
                            var url = '/page/debt/common/xmyhs.jsp';

                            var paramNames=new Array();
                            paramNames[0]="XM_ID";
                            paramNames[1]='IS_RZXM';

                            var paramValues=new Array();
                            paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                            paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                            var result = '<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">' + data + '</a>';
                            return result;
                        }
                    },{
                        "dataIndex": "LX_YEAR",
                        "type": "string",
                        "text": "立项年度",
                        "width": 130
                    },{
                        "dataIndex": "JSXZ_NAME",
                        "type": "string",
                        "text": "建设性质",
                        "width": 130
                    },{
                        "dataIndex": "XMXZ_NAME",
                        "type": "string",
                        "text": "项目性质",
                        "width": 170
                    },{
                        "dataIndex": "XMLX_NAME",
                        "type": "string",
                        "text": "项目类型",
                        "width": 130
                    },{
                        "dataIndex": "BUILD_STATUS_NAME",
                        "type": "string",
                        "text": "当前建设状态",
                        "width": 130
                    },{
                        "dataIndex": "XMZGS_AMT",
                        "type": "float",
                        "text": "项目总概算金额(万元)",
                        "width": 180,
                        "hidden": me.IS_RZPT == 1 ? true : false,
                        renderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.######');
                        }
                    },{
                        "dataIndex": "XMZTZ_AMT",
                        "type": "float",
                        "text": "项目总投资金额(万元)",
                        "width": 180,
                        "hidden":true,// me.IS_RZPT == 1 ? false : true,
                        renderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.######');
                        }
                    }
                    ],
                    columnAutoWidth: false
                },
                rowNumber: true,
                border: false,
                height: '100%',
                checkBox: true,
                pageConfig: {
                    enablePage : false
                },
                store : me.store
            };

            me.gridConfig = $.extend(me.gridConfig, defaultGridConfig);
            me.grid=new DSYGridV2().create(me.gridConfig);
            // 当树是多选时，添加父子节点级联
            if (me.multi == true) {
                me.grid.checkBox = true;
            }
            //根据控件值选中行 未实现
            me.grid.store.on({load:function(){
                    setTimeout(function(){
                        if(me.grid.store == null){
                            return;
                        }
                        if(me.getValue() != null)
                        {
                            me.grid.store.each(function(record){
                                if(record.get('XM_ID')==me.getValue()){
                                    me.grid.getSelectionModel().select(record,true);
                                }
                            });
                        }
                    },500);
                }
            });

            me.grid.addDocked({
                xtype: 'toolbar',
                layout: 'column',
                items: [
                    '->',
                    /*{
                        xtype: 'button',
                        name: 'jjxxGrid_add',
                        text: '增加',
                        width: 60,
                        name: 'INPUT',
                        handler: function (btn) {
                            title = "建设项目录入";
                            //发送ajax请求，获取新增主表id
                            $.post("/getId.action", function (data) {
                                if (!data.success) {
                                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                    return;
                                }
                                //弹出弹出框，设置XM_ID
                                XM_ID = data.data[0];
                                window_rzxmtb.show(btn.name);
                                // 关闭弹出窗口
                                btn.up("window").close();
                            }, "json");
                        }

                    },
                    {
                        xtype: 'button',
                        name: 'jjxxGrid_update',
                        text: '修改',
                        width: 60,
                        name: 'UPDATE',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid_jsxm').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else if (records[0].get("IS_END") == '1') {
                                Ext.MessageBox.alert('提示', '该项目已经审核,不能修改！');
                                return;
                            } else {
                                XM_ID = records[0].get("XM_ID");
                            }
                            title = "建设项目修改";
                            window_rzxmtb.show(btn.name);
                            loadInfo();
                            // 关闭弹出窗口
                            btn.up("window").close();
                        }
                    },
                    {
                        xtype: 'button',
                        name: 'jjxxGrid_delete',
                        text: '删除',
                        width: 60,
                        handler: function (btn) {
                            //获取表格被选中行
                            var records = DSYGrid.getGrid('contentGrid_jsxm').getSelectionModel().getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm == 'yes') {
                                    deleteBasicInfo_jsxm();
                                }
                            });
                        }
                    },*/
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "XM_SEARCH",
                        width: 450,    //762
                        emptyText: '请输入项目编码/项目名称',
                        enableKeyEvents: true,
                        listeners: {
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    reloadRzxmGrid();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        name: 'SEARCH',
                        text: '搜索',
                        width: 60,
                        listeners: {
                            'click': function (self, e, eOpts) {
                                reloadRzxmGrid();
                            }
                        }
                    }
                ]
            }, 0);
            // 创建弹出窗口
            me.window = Ext.create('Ext.window.Window', {
                closeAction: me.closeAction,
                title: me.fieldLabel,
                width: me.windowWidth,
                height: me.windowHeight,
                layout: 'fit',
                modal: true,
                animateTarget: me,
                buttonAlign: 'center',
                buttons: [
                    {
                        text: '确认',
                        listeners: {
                            'click': function (btn) {
                                //点击确认按钮修改combobox值为tree值
                                var grid = btn.up("window").down('grid');
                                //获取树的值数组，若是不需要复选框，改getChecked为getSelection即可
                                var gridValueArray = grid.getSelection();
                                if(gridValueArray.length == 0|| gridValueArray.length > 1)
                                {
                                    Ext.Msg.alert('提示', '请选择‘一条记录’！');
                                    return;

                                }
                                var comboboxValue = new Array(gridValueArray.length);
                                var comboboxText = '';
                                // 遍历数组生成下拉框值数组
                                comboboxValue[0] = gridValueArray[0].get(me.valueField);
                                var XM_CODE=gridValueArray[0].data.XM_CODE;
                                if (Ext.isArray(displayField)) {
                                    for (var j in displayField) {
                                        comboboxText += gridValueArray[0].get(displayField[j]) + " ";
                                    }

                                } else {
                                    comboboxText += gridValueArray[0].get(me.displayField) ;
                                }
                                if(is_grid == 1) {
                                    var record = DSYGrid.getGrid('kjhsmxGrid').getCurrentRecord();
                                    record.set('PU_NAME', comboboxText);
                                    record.set('PRO_CODE', XM_CODE);
                                } else {
                                    // 给下拉框设置值与显示值
                                    me.setValue(comboboxValue);
                                    me.setRawValue(comboboxText);
                                }
                                // 关闭弹出窗口
                                btn.up("window").close();
                            }
                        }
                    },
                    {
                        text: '取消',
                        listeners: {
                            'click': function (btn) {
                                btn.up("window").close();
                            }
                        }
                    }
                ],
                items: [me.grid]
            });
        }
        if(is_showxmbtn==0){
            me.grid.dockedItems.items["0"].hidden=true;
        }
        me.window.show();
        // 获取下拉框值，并回显到tree上
        var button_value = me.getValue();
        if (button_value != null && button_value.length > 0) {
            if (!Ext.isArray(button_value)) {
                button_value = [button_value];
            }
        }
    }
});