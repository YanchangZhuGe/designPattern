//银行流水支出grid
Ext.define('Ext.ux.PopupGridForSjzc', {
    extend: 'Ext.form.field.ComboBox',
    xtype: 'popupGridForSjzc',
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
        windowHeight: document.body.clientWidth * 0.4,
        windowWidth:  document.body.clientWidth * 0.9,
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
                itemId: 'contentGrid_yhls',
                name : 'PopupGridForSjzc',
                headerConfig: {
                    rowNumber: true,
                    headerJson:[
                        {
                            "dataIndex": "GUID",
                            "type": "string",
                            "text": "GUID",
                            "hidden":true
                        },
                        {
                            "dataIndex": "AD_NMAE",
                            "type": "string",
                            "text": "地区",
                            "width":150
                        },
                        {
                            "dataIndex": "ACC_NO",
                            "type": "string",
                            "text": "账号",
                            "width":180
                        },
                        {
                            "dataIndex": "ACC_NAME",
                            "type": "string",
                            "text": "账户名称",
                            "width":180
                        },
                        {
                            "dataIndex": "ACC_BANK_NAME",
                            "type": "string",
                            "text": "开户银行名称",
                            "width":180
                        },
                        {
                            "dataIndex": "REFNBR",
                            "type": "string",
                            "text": "银行交易流水号",
                            "width":180
                        },
                        {
                            "dataIndex": "ETYTIM",
                            "type": "string",
                            "text": "交易时间",
                            "width":180
                        },
                        {
                            "dataIndex": "TSDAMT",
                            "type": "float",
                            "text": "流水金额(元)",
                            "width":150
                        },
                        {
                            "dataIndex": "RPYACC",
                            "type": "string",
                            "text": "对方账号",
                            "width":180
                        },
                        {
                            "dataIndex": "RPYNAM",
                            "type": "string",
                            "text": "对方账户名称",
                            "width":180
                        },
                        {
                            "dataIndex": "NUSAGE",
                            "type": "string",
                            "text": "用途"
                        },
                        {
                            "dataIndex": "NAME",
                            "type": "string",
                            "text": "名称",
                            "width": 130,
                            "hidden":true
                        },
                        {
                            "dataIndex": "CODE",
                            "type": "string",
                            "text": "名称",
                            "width": 130,
                            "hidden":true
                        },{
                            "dataIndex": "XM_ID",
                            "type": "string",
                            "text": "xm_id",
                            "width": 130,
                            "hidden":true
                        }
                    ],
                    columnAutoWidth: false
                },
                rowNumber: true,
                border: false,
                height: '100%',
                checkBox: false,
                pageConfig: {
                    pageNum: true,//设置显示每页条数
                    enablePage: true
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
                        xtype: "combobox",
                        name: 'ZHMC',
                        itemId: "ZHMC",
                        fieldLabel: '账号',
                        displayField: 'name',
                        valueField: 'id',
                        labelWidth: 30,
                        editable: false,
                        store: yhzhStore,
                        width: '29%',
                        lines: false,
                        listeners: {
                            'change': function (self, newValue, eOpts) {
                                var ZHMC = newValue;
                                SjzcyhStore.getProxy().extraParams['ZHMC'] = newValue;
                                SjzcyhStore.load();
                            }
                        }

                    },
                    {
                        xtype: "datefield",
                        fieldLabel: '交易日期',
                        id: 'createDate1',
                        allowBlank: true,
                        format: 'Y-m-d',
                        labelWidth: 70,
                        blankText: '请选择日期',
                        emptyText: '请选择日期',
                        width: '16%',
                        listeners: {
                            'change': function (self, newValue, eOpts) {
                                var createDate1 = dsyDateFormat(newValue);
                                SjzcyhStore.getProxy().extraParams['CREATEDATE1'] = createDate1;
                                SjzcyhStore.load();
                            }
                        }
                    }, {
                        xtype: "datefield",
                        fieldLabel: '至',
                        id: 'createDate2',
                        allowBlank: true,
                        format: 'Y-m-d',
                        labelWidth: 25,
                        blankText: '请选择日期',
                        emptyText: '请选择日期',
                        width: '15%',
                        listeners: {
                            'change': function (self, newValue, eOpts) {
                                var createDate2 = dsyDateFormat(newValue);
                                SjzcyhStore.getProxy().extraParams['CREATEDATE2'] = createDate2;
                                SjzcyhStore.load();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        labelWidth: 50,
                        itemId: "YHLS_SEARCH",
                        width: '30%',    //762
                        emptyText: '请输入对方账号/对方账户名称/银行交易流水号',
                        enableKeyEvents: true,
                        listeners: {
                            'change': function (self, e, eOpts) {

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
                                var YHLS_SEARCH= Ext.ComponentQuery.query('textfield#YHLS_SEARCH')[0].getValue();
                                var ZHMC= Ext.ComponentQuery.query('combobox#ZHMC')[0].getValue();
                                var createDate1= Ext.ComponentQuery.query('datefield#createDate1')[0].getValue();
                                var createDate2= Ext.ComponentQuery.query('datefield#createDate2')[0].getValue();
                                createDate1=dsyDateFormat(createDate1);
                                createDate2=dsyDateFormat(createDate2);
                                SjzcyhStore.getProxy().extraParams['ZHMC'] = ZHMC;
                                SjzcyhStore.getProxy().extraParams['MHCX'] = YHLS_SEARCH;
                                SjzcyhStore.getProxy().extraParams['CREATEDATE1'] = createDate1;
                                SjzcyhStore.getProxy().extraParams['CREATEDATE2'] = createDate2;
                                SjzcyhStore.load();
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
                                var gridValueArray = DSYGrid.getGrid('contentGrid_yhls').getSelection();
                                if(gridValueArray.length == 0|| gridValueArray.length > 1) {
                                    Ext.Msg.alert('提示', '请选择一条记录！');
                                    return;
                                }
                                //获取支出信息表中数据
                                var comboboxValue = gridValueArray[0].data.CODE;
                                var comboboxText = gridValueArray[0].data.NAME;
                                var TSDAMT = gridValueArray[0].data.TSDAMT;
                                var RPYACC = gridValueArray[0].data.RPYACC;
                                var RPYNAM = gridValueArray[0].data.RPYNAM;
                                var ACC_BANK_NAME = gridValueArray[0].data.ACC_BANK_NAME;
                                var NUSAGE = gridValueArray[0].data.NUSAGE;
                                //给支出表单赋值
                                Ext.ComponentQuery.query('combobox[name="YHZHSZ"]')[0].setValue(comboboxValue);
                                Ext.ComponentQuery.query('numberFieldFormat[name="SJZC_AMT"]')[0].setValue(TSDAMT);
                                Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_NO"]')[0].setValue(RPYACC);
                                Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_NAME"]')[0].setValue(RPYNAM);
                                Ext.ComponentQuery.query('textfield[name="BANK_DEPOSIT_NAME"]')[0].setValue(ACC_BANK_NAME);
                                Ext.ComponentQuery.query('textfield[name="ZCZY"]')[0].setValue(NUSAGE);

                                // 给下拉框设置值与显示值
                                me.setValue(comboboxValue);
                                me.setRawValue(comboboxText);
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