//收款单位取招投标的建设单位
Ext.define('Ext.ux.PopupGridForSkdw', {
    extend: 'Ext.form.field.ComboBox',
    xtype: 'PopupGridForSkdw',
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
                itemId: 'contentGrid_skdw',
                name : 'PopupGridForSkdw',
                headerConfig: {
                    rowNumber: true,
                    headerJson:[
                        {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
                        {dataIndex: "ZBDW_AG_ID", width: 250, type: "string", text: "指标单位ID",hidden:true},
                        {dataIndex: "AG_NAME", width: 250, type: "string", text: "单位名称",hidden:true},
                        {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码",hidden:true},
                        {dataIndex: "ZB_DATE", width: 150, type: "string", text: "招标日期",hidden:true},
                        {dataIndex: "ZB_TYPE", width: 150, type: "string", text: "招标类型",hidden:true},
                        {dataIndex: "ZBDW", width: 250, type: "string", text: "中标单位"},
                        {dataIndex: "TYSHXY_CODE", width: 250, type: "string", text: "中标单位统一社会信用代码"},
                        {dataIndex: "ZB_AMT", width: 160, type: "float", text: "中标金额（万元）",summaryType: 'sum',
                            renderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00####');
                            },
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00####');
                            }
                        }
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
                        itemId: "SKDW_SEARCH",
                        width: '70%',    //762
                        emptyText: '请输入收款单位名称/收款单位统一社会信用代码',
                        enableKeyEvents: true,
                        listeners: {
                            'change': function (self, e, eOpts) {

                            },
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    let  keydownValue = self.value.trim();
                                    reloadSkdwGrid(keydownValue);
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
                                var SKDW_SEARCH= Ext.ComponentQuery.query('textfield#SKDW_SEARCH')[0].getValue();
                                let  inputValue = SKDW_SEARCH.trim();
                                reloadSkdwGrid(inputValue);
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
                                if (Ext.isArray(displayField)) {
                                    for (var j in displayField) {
                                        comboboxText += gridValueArray[0].get(displayField[j]) + " ";
                                    }

                                } else {
                                    comboboxText += gridValueArray[0].get(me.displayField) ;
                                }
                                // 给下拉框设置值与显示值
                                me.setValue(comboboxValue);
                                me.setRawValue(comboboxText);
                                var TYSHXY_CODE = gridValueArray[0].data.TYSHXY_CODE;
                                Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0].getForm().findField("XPAYEE_ACCT_UNI_CODE").setValue(TYSHXY_CODE);
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
function reloadSkdwGrid(val){
    var grid = DSYGrid.getGrid('contentGrid_skdw');
    var store = grid.getStore();
    store.getProxy().extraParams['keyDownVal'] = val;
    store.removeAll();
    store.loadPage(1);
}