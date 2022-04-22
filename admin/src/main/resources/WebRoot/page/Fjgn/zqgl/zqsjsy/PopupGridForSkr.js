//根据收款单位获取收款人相关信息
Ext.define('Ext.ux.PopupGridForSkr', {
    extend: 'Ext.form.field.ComboBox',
    xtype: 'PopupGridForSkr',
    uses: [
        'Ext.grid.Panel', 'Ext.window.Window'
    ],
    triggerCls: Ext.baseCSSPrefix + 'form-arrow-trigger',
    config: {
        window: null,
        grid: null,
        displayField: 'text',
        valueField: null,
        is_grid: 0,
        windowHeight: document.body.clientWidth * 0.3,
        windowWidth:  document.body.clientWidth * 0.5,
        closeAction: 'destroy',
        multi: false,
        gridConfig: {}
    },
    editable: false,
    header: [],
    initComponent: function () {
        var me = this;
        me.callParent(arguments);
        me.mon(me.store, {
            scope: me,
            expand: me.onExpand
        });
    },
    onExpand: function () {
        var me = this;
        if (!me.window || me.closeAction == 'destroy') {
            is_grid = me.is_grid;
            // 获取显示字段，若无，默认text
            displayField = me.displayField;
            // 创建表格
            me.grid = new DSYGridV2();
            var defaultGridConfig = {
                itemId: 'contentGrid_skr',
                name : 'PopupGridForSkr',
                headerConfig: {
                    rowNumber: true,
                    headerJson:[
                        {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
                        {dataIndex: "ACC_NAME", width: 250, type: "string", text: "账户名称"},
                        {dataIndex: "ACC_NO", width: 150, type: "string", text: "账号"},
                        {dataIndex: "ACC_BANK_NAME", width: 150, type: "string", text: "开户行"}
                    ],
                    columnAutoWidth: false
                },
                rowNumber: false,
                border: false,
                height: '100%',
                checkBox: false,
                pageConfig: {
                    pageNum: false,//设置显示每页条数
                    enablePage: false
                },

                plugins: [
                    {
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        pluginId: 'olap_manage_edit',
                        clicksToMoveEditor: 1,
                        listeners: {
                            'edit': function (editor, context) {
                                //设置格式化日期
                                if (context.field == 'ETYTIM'  ) {
                                    context.record.set(context.field, Ext.util.Format.date(context.value, 'Ymd'));
                                }
                            },
                        }
                    }
                ],
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
                        if(me.getValue() != null) {
                            me.grid.store.each(function(record){
                                if(record.get('GUID')==me.getValue()){
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
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        labelWidth: 50,
                        itemId: "SKR_SEARCH",
                        width: '70%',    //762
                        emptyText: '请输入账户名称',
                        enableKeyEvents: true,
                        listeners: {
                            'change': function (self, e, eOpts) {

                            },
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    let  keydownValue = self.value.trim();
                                    reloadSkrGrid(keydownValue);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        name: 'SEARCH',
                        text: '搜索',
                        labelWidth: 20,
                        width: 60,
                        listeners: {
                            'click': function (self, e, eOpts) {
                                var SKR_SEARCH= Ext.ComponentQuery.query('textfield#SKR_SEARCH')[0].getValue();
                                let  inputValue = SKR_SEARCH.trim();
                                reloadSkrGrid(inputValue);
                            }
                        }
                    }
                ]
            }, 0);
            // 创建弹出窗口
            me.window = Ext.create('Ext.window.Window', {
                closeAction: me.closeAction,
                itemId: 'window_yhls_query',
                title: me.fieldLabel,
                width: me.windowWidth,
                height: me.windowHeight,
                layout: 'fit',
                modal: true,
                animateTarget: me,
                buttonAlign: 'center',
                buttons: [

                    {
                        text: '确定',
                        listeners: {
                            'click': function (btn) {
                                var gridValueArray = DSYGrid.getGrid('contentGrid_skr').getSelection();
                                if(gridValueArray.length == 0|| gridValueArray.length > 1) {
                                    Ext.Msg.alert('提示', '请选择一条记录！');
                                    return;
                                }
                                var accname = gridValueArray[0].data.ACC_NAME;
                                var accno = gridValueArray[0].data.ACC_NO;
                                var accbankname = gridValueArray[0].data.ACC_BANK_NAME;
                                //给支出表单赋值
                                Ext.ComponentQuery.query('PopupGridForSkr[name="XPAYEE_ACCT_NAME"]')[0].setValue(accname);
                                var myForm = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0].getForm();
                                myForm.findField("XPAYEE_ACCT_NO").setValue(accno);
                                myForm.findField("BANK_DEPOSIT_NAME").setValue(accbankname);
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


/**
 *刷新表格按钮
 */
function reloadSkrGrid(val){
    var grid = DSYGrid.getGrid('contentGrid_skr');
    var store = grid.getStore();
    store.getProxy().extraParams['keyDownVal'] = val;
    store.removeAll();
    store.loadPage(1);
}