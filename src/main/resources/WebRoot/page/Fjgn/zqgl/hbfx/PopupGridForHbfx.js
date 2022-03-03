/**
 *
 * A ComboBox field that contains a tree panel on its popup, enabling selection of tree nodes.
 */
Ext.define('Ext.ux.PopupGridForZw', {
    extend: 'Ext.form.field.ComboBox',
    xtype: 'popupforhbfxgrid',

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
        valueField: null,

        /**
         * @cfg {Number} windowHeight
         * The  height of the pop-up window. Defaults to 350.
         */
        windowHeight: 350,

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
            var record = DSYGrid.getGrid("dfsq_grid").getCurrentRecord();
            var zq_id=record.get("ZQ_ID");
            var type_id=record.get("ZQLB_CODE");
            var zwStore = getZwStore(type_id,zq_id);
            zwStore.loadPage(1);
            // 获取显示字段，若无，默认text
            var displayField = me.displayField;
            // 创建表格
            me.grid = new DSYGridV2();
            var defaultGridConfig = {
                itemId: 'contentGridHbfx',
                name : 'PopupGridForHbfx',
                autoLoad: false,
                headerConfig: {
                    rowNumber: true,
                    headerJson: [
                        {
                            "dataIndex": "ZQ_ID",
                            "type": "string",
                            "text": "债券名称",
                            "fontSize": "15px",
                            "hidden": true
                        },
                        {
                            "dataIndex": "ZQ_NAME",
                            "type": "string",
                            "text": "债券名称",
                            "fontSize": "15px",
                            "hidden": false,
                            renderer: function (data, cell, record) {
                                // var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                                // return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
                                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                                var paramNames=new Array();
                                paramNames[0]="ZQ_ID";
                                paramNames[1]="AD_CODE";
                                var paramValues=new Array();
                                paramValues[0]=record.get('ZQ_ID');
                                paramValues[1]=AD_CODE;
                                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                                return result;

                            }
                        },
                        {
                            "dataIndex": "HB_AMT",
                            "type": "float",
                            "text": "再融资债券金额(元)",
                            "fontSize": "15px",
                            "hidden": false,
                             editor: {
                                xtype: 'numberFieldFormat',
                                 allowDecimals: true,
                                 decimalPrecision: 2,
                                 hideTrigger: true,
                                 align: 't',
                                 keyNavEnabled: true,
                                 mouseWheelEnabled: true,
                                 editable: false
                            }
                        },
                        {
                            "dataIndex": "HB_AMT_SY",
                            "type": "float",
                            "text": "再融资债券未使用金额(元)",
                            "fontSize": "15px",
                            "width": 200,
                            editor: {
                                xtype: 'numberFieldFormat',
                                allowDecimals: true,
                                decimalPrecision: 2,
                                hideTrigger: true,
                                keyNavEnabled: true,
                                mouseWheelEnabled: true,
                                editable: false
                            }
                        }
                    ],
                    columnAutoWidth: true
                },
                rowNumber: true,
                border: false,
                height: '100%',
                pageConfig: {
                    enablePage : false
                },
                store : zwStore,
                listeners: {
                    afterrender: function (self) {
                    }
                }
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
                    if(me.getValue() != null)
                    {
                        me.grid.store.each(function(record){
                            if(record.get('ZQ_ID')==me.getValue()){
                                me.grid.getSelectionModel().select(record,true);
                            }
                        });
                    }
                },500);
            }
            });
            // 创建弹出窗口
            me.window = Ext.create('Ext.window.Window', {
                closeAction: me.closeAction,
                title: "再融资债券选择",
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
                                if(gridValueArray.length == 0)
                                {
                                    Ext.Msg.alert('提示', '请选择‘一条记录’！');
                                    return;
                                }
                                    gridValueArray=gridValueArray[0].data;
                                    var record = DSYGrid.getGrid("dfsq_grid").getCurrentRecord();
                                    record.set('HBZQ_NAME', gridValueArray.ZQ_NAME);
                                    record.set('HBZQ_ID',gridValueArray.ZQ_ID);
                                    record.set("HBZQ_TYPE",gridValueArray.ZQLB_ID);
                                    record.set("HB_AMT",gridValueArray.HB_AMT);
                                    record.set("HB_AMT_SY",gridValueArray.HB_AMT_SY);

                                    if(record.get("SY_AMT")<gridValueArray.HB_AMT_SY){
                                        // if(YLU_TEMP!=null&&YLU_TEMP!=undefined){
                                        //     if(YLU_TEMP[gridValueArray.ZQ_ID]!=undefined&&YLU_TEMP[gridValueArray.ZQ_ID]>=0){
                                        //         YLU_TEMP[gridValueArray.ZQ_ID]+=record.get("SY_AMT");
                                        //     }else{
                                        //         YLU_TEMP[gridValueArray.ZQ_ID]=record.get("SY_AMT");
                                        //     }
                                        // }
                                    }else{
                                        // if(YLU_TEMP!=null&&YLU_TEMP!=undefined){
                                        //     if(YLU_TEMP[gridValueArray.ZQ_ID]!=undefined&&YLU_TEMP[gridValueArray.ZQ_ID]>=0){
                                        //         YLU_TEMP[gridValueArray.ZQ_ID]+=gridValueArray.HB_AMT_SY;
                                        //     }else{
                                        //         YLU_TEMP[gridValueArray.ZQ_ID]=gridValueArray.HB_AMT_SY;
                                        //     }
                                        // }
                                        record.set("DF_AMT",gridValueArray.HB_AMT_SY);
                                    }
                                      //record.set("HB_AMT_SY",gridValueArray.HB_AMT_SY-record.get("DF_AMT"));

                                inputDfsqForm(DSYGrid.getGrid("dfsq_grid").getStore());
                                // 关闭弹出窗口
                                btn.up("window").close();
                            },
                            'afterrender':function (e,p) {

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
            //未实现
        }
    }

});

function getZwStore(type_id,zq_id) {
    return Ext.create('Ext.data.Store', {
        fields: ["ZQ_ID", "ZQ_NAME", "HB_AMT", "HB_AMT_SY"],
        proxy: {// ajax获取后端数据
            type: "ajax",
            method: "POST",
            url: '/getSimpleHbfxPomp.action?type_id='+type_id+'&zq_id='+zq_id,
            reader: {
                type: "json",
                root: "list"
            },
            simpleSortMode: true
        },
        autoLoad: true
    });
}

