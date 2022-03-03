/**
 * 初始化
 */
$(document).ready(function () {
    initContent();
    offLock();
});
var YEAR;
var lock;
var nowDate = Ext.Date.format(new Date(), 'Y-m-d');// 获取系统当前时间
var nowYear=nowDate.substr(0,4);// 截取系统当前年度
//开锁
function openLock() {
    lock=true;
    Ext.ComponentQuery.query('button[name="save"]')[0].setDisabled(false);
    Ext.ComponentQuery.query('button[name="del"]')[0].setDisabled(false);
}
//关锁
function offLock() {
    lock=false;
    Ext.ComponentQuery.query('button[name="save"]')[0].setDisabled(true);
    Ext.ComponentQuery.query('button[name="del"]')[0].setDisabled(true);
}
/**
 * 初始化主界面
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        width: '100%',
        height: '100%',
        renderTo: Ext.getBody(),
        layout: {
            type: 'hbox',//竖直布局 item 有一个 flex属性
            align: 'stretch' //拉伸使其充满整个父容器
        },
        tbar: [
            {
                text: '新增',
                name: 'add',
                xtype: 'button',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    initWindow_nd();
                }
            },
            {
                text: '编辑',
                name: 'update',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    openLock();
                }
            },
            {
                text: '取消',
                name: 'cancel',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    offLock();
                }
            },
            {
                text: '保存',
                name: 'save',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    saveFxjhInfo(btn);
                }
            },
            {
                text: '删除',
                name: 'del',
                xtype: 'button',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    deleteFxjhInfo();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        items: [
            initContentTree({
                items_tree: function () {
                    return [
                        initContentTree()//年度树
                    ]
                }
            }),
            initContentRightPanel()
        ]
    });
}
/**
 * 初始化右侧panel，放置表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 10,
        region: 'center',
        layout: {
            type: 'hbox',
            align: 'stretch',

            flex: 1
        },
        border: false,
        items: [
            initContentGrid(),
            {//分割线
                xtype: 'menuseparator',
                margin: '50 0 50 0',
                border: true
            },
            initContentDetilGrid()
        ]
    });
}
function initContentTree(){
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'}
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
        items: initContentTree_nd()
    });
}
/**
 * 初始化左侧树：年度树
 */
function initContentTree_nd() {
    //加载左侧上方树数据
    var regStore = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getYearTree.action',
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
        itemId: 'tree_year',
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
            var record = self.getRoot().getChildAt(0).getChildAt(0);
            if (record) {
                area_panel.getSelectionModel().select(record);
                itemclick(area_panel, record);
            }
        }
    });
    return area_panel;

    function itemclick(self, record) {
        YEAR = record.get('text');
        reloadGrid();
    }
}
/**
 * 弹出年度选择框
 */
function initWindow_nd() {
    Ext.create('Ext.window.Window', {
        itemId: 'window_nd', // 窗口标识
        title: '编制年度', // 窗口标题
        width: 280, //自适应窗口宽度
        height: 150, //自适应窗口高度
        // layout: 'hbox',
        layout: {
            type: 'hbox',
            padding: '10',
            align: 'middle'
        },
        y: document.body.clientHeight * 0.3,
        buttonAlign: 'center', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items:[
            {
                xtype: 'combobox',
                fieldLabel: '年度',
                labelWidth:50,
                name: 'nd_year',
                editable: false,
                width: 200,
                allowBlank: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreDB('DEBT_YEAR',{condition: " and code >= '"+nowYear+"'"})
            }
        ],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    openLock();
                    confirm_handler(btn);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    offLock();
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}
/**
 * 选择年度后的确认事件
 */
function confirm_handler(btn){
    //获得选的年份
    YEAR = Ext.ComponentQuery.query('combobox[name="nd_year"]')[0].getValue();
    Ext.ComponentQuery.query('displayfield[name="grid_name"]')[0].setValue(YEAR+'年再融资债券发行计划');
    //查询主单数据
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    store.getProxy().extraParams = {
        YEAR: YEAR,
        TYPE:'1'
    };
    //刷新
    store.loadPage(1);
    //将查询条件全部置为空
    Ext.ComponentQuery.query('datefield#STARTDATE')[0].setValue("");
    Ext.ComponentQuery.query('datefield#ENDDATE')[0].setValue("");
    Ext.ComponentQuery.query('combobox#ZQLX')[0].setValue("");
    //查询明细数据
    var grid_detail = DSYGrid.getGrid('contentGrid_detail');
    var store_detail = grid_detail.getStore();
    store_detail.removeAll();
    store_detail.getProxy().extraParams = {
        TYPE:'1',
        YEAR: YEAR
    };
    store_detail.loadPage(1);
    btn.up('window').close();
}

/**
 * 删除数据
 */
function deleteFxjhInfo() {
    $.post('deleteHbFxjhBzInfo.action', {
        YEAR:YEAR
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '删除成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            // 刷新表格
            reloadGrid();
            //刷新左侧树
            reloadTree();
        } else {
            Ext.MessageBox.alert('提示', '删除失败!' + data.message);
        }
    }, 'JSON');
}
/**
 * 保存事件
 * @param self
 */
function saveFxjhInfo(self) {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var grid_detail = DSYGrid.getGrid('contentGrid_detail').getStore();
    //校验金额是否与明细的合计相等
    var xzyb_sum = store.sum("XZYB");
    var xzzx_sum = store.sum("XZZX");
    var zhyb_sum = store.sum("ZHYB");
    var zhzx_sum = store.sum("ZHZX");
    var zrzyb_sum = store.sum("ZRZYB");
    var zrzzx_sum = store.sum("ZRZZX");
    var xzyb_sum_dtl = grid_detail.sum("XZYB_AMT");
    var xzzx_sum_dtl = grid_detail.sum("XZZX_AMT");
    var zhyb_sum_dtl = grid_detail.sum("ZHYB_AMT");
    var zhzx_sum_dtl = grid_detail.sum("ZHZX_AMT");
    var zrzyb_sum_dtl = grid_detail.sum("ZRZYB_AMT");
    var zrzzx_sum_dtl = grid_detail.sum("ZRZZX_AMT");
    if(Math.abs(xzyb_sum - xzyb_sum_dtl) > 0.0000001){
        Ext.MessageBox.alert('提示', '合计中该年新增一般总金额不等于明细中新增一般总金额！');
        return;
    }
    if(Math.abs(xzzx_sum - xzzx_sum_dtl) > 0.0000001){
        Ext.MessageBox.alert('提示', '合计中该年新增专项总金额不等于明细中新增专项总金额！');
        return;
    }
    if(Math.abs(zhyb_sum - zhyb_sum_dtl) > 0.0000001){
        Ext.MessageBox.alert('提示', '合计中该年置换一般总金额不等于明细中置换一般总金额！');
        return;
    }
    if(Math.abs(zhzx_sum - zhzx_sum_dtl) > 0.0000001){
        Ext.MessageBox.alert('提示', '合计中该年置换专项总金额不等于明细中置换专项总金额！');
        return;
    }
    if(Math.abs(zrzyb_sum - zrzyb_sum_dtl) > 0.0000001){
        Ext.MessageBox.alert('提示', '合计中该年再融资一般总金额不等于明细中再融资一般总金额！');
        return;
    }
    if(Math.abs(zrzzx_sum - zrzzx_sum_dtl) > 0.0000001){
        Ext.MessageBox.alert('提示', '合计中该年再融资专项总金额不等于明细中再融资专项总金额！');
        return;
    }
    self.setDisabled(true);
    //获取主表所有数据 进行保存
    var store_data = new Array();
    for (var j = 0; j < store.getCount(); j++) {
        var record=store.getAt(j);
        store_data.push(record.data);
    }
    $.post('saveHbFxjhBzInfo.action', {
        YEAR:YEAR,
        FXJH_DATA: Ext.util.JSON.encode(store_data)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            // 刷新表格
            reloadGrid();
            //刷新左侧树
            reloadTree();
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            self.setDisabled(false);
        }

    }, 'JSON');
}
/**
 * 初始化主表格
 */
function initContentGrid() {
    var headerJson = [
        {
            text: "月份",
            dataIndex: "MONTH",
            type: "string",
            width: 60,
            summaryRenderer: function () {
                return '合计';
            },
            fontSize: "15px"
        },
        {
            text: '合计',
            dataIndex: "SUM_AMT",
            type: "float",
            width: 80,
            align: 'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        },
        {
            text: '置换一般',
            dataIndex: "ZHYB",
            type: "float",
            width: 85,
            align: 'right',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.000000',
                hideTrigger: true,
                decimalPrecision:7,
                mouseWheelEnabled: true,
                minValue: 0
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        },
        {
            text: "新增一般",
            dataIndex: "XZYB",
            type: "float",
            width: 85,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.000000',
                hideTrigger: true,
                decimalPrecision:7,
                mouseWheelEnabled: true,
                minValue: 0
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        },
        {
            text: "置换专项",
            dataIndex: "ZHZX",

            type: "float",
            width: 85,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.000000',
                hideTrigger: true,
                decimalPrecision:7,
                mouseWheelEnabled: true,
                minValue: 0
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        },
        {
            text: "新增专项",
            dataIndex: "XZZX",
            type: "float",
            width: 85,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.000000',
                hideTrigger: true,
                decimalPrecision:7,
                mouseWheelEnabled: true,
                minValue: 0
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        },
        {
            text: "再融资一般",
            dataIndex: "ZRZYB",
            type: "float",
            width: 85,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.000000',
                hideTrigger: true,
                decimalPrecision:7,
                mouseWheelEnabled: true,
                minValue: 0
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        }, {
            text: "再融资专项",
            dataIndex: "ZRZZX",
            type: "float",
            width: 85,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.000000',
                hideTrigger: true,
                decimalPrecision:7,
                mouseWheelEnabled: true,
                minValue: 0
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        }
    ];
    return DSYGrid.createGrid({
        height: '50%',
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true,
            columnCls:'normal'
        },
        flex: 0.7,
        dataUrl: 'getHbFxjh.action',
        checkBox: false,
        border: true,
        autoLoad: false,
        pageConfig: {
            enablePage: false//设置显示每页条数
        },
        tbar: [
            {
                xtype: "displayfield",
                fieldLabel: '',
                name: 'grid_name',
                columnWidth: .40,
                labelWidth: 80,
                value: (YEAR!=null && YEAR!='' && YEAR!=undefined) ? YEAR+'年再融资债券发行计划' : '再融资债券发行计划',
                width: 160
            },
            '->',
            {xtype: 'label', text: '单位 : 亿元', width: 80}
        ],
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'FXJH_ID',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            beforeedit: function (editor, context) {
                if (!lock) {
                    return false;
                }
            },
            edit:function (editor,context) {
                if (context.field == 'XZYB' && context.originalValue != context.value) {
                    var XZYB = context.record.get('XZYB');
                    var XZZX = context.record.get('XZZX');
                    var ZHYB = context.record.get('ZHYB');
                    var ZHZX = context.record.get('ZHZX');
                    var ZRZYB = context.record.get('ZRZYB');
                    var ZRZZX = context.record.get('ZRZZX');
                    context.record.set("SUM_AMT", XZYB+XZZX+ZHYB+ZHZX+ZRZYB+ZRZZX);
                }
                if (context.field == 'XZZX' && context.originalValue != context.value) {
                    var XZYB = context.record.get('XZYB');
                    var XZZX = context.record.get('XZZX');
                    var ZHYB = context.record.get('ZHYB');
                    var ZHZX = context.record.get('ZHZX');
                    var ZRZYB = context.record.get('ZRZYB');
                    var ZRZZX = context.record.get('ZRZZX');
                    context.record.set("SUM_AMT", XZYB+XZZX+ZHYB+ZHZX+ZRZYB+ZRZZX);
                }
                if (context.field == 'ZHYB' && context.originalValue != context.value) {
                    var XZYB = context.record.get('XZYB');
                    var XZZX = context.record.get('XZZX');
                    var ZHYB = context.record.get('ZHYB');
                    var ZHZX = context.record.get('ZHZX');
                    var ZRZYB = context.record.get('ZRZYB');
                    var ZRZZX = context.record.get('ZRZZX');
                    context.record.set("SUM_AMT", XZYB+XZZX+ZHYB+ZHZX+ZRZYB+ZRZZX);
                }
                if (context.field == 'ZHZX' && context.originalValue != context.value) {
                    var XZYB = context.record.get('XZYB');
                    var XZZX = context.record.get('XZZX');
                    var ZHYB = context.record.get('ZHYB');
                    var ZHZX = context.record.get('ZHZX');
                    var ZRZYB = context.record.get('ZRZYB');
                    var ZRZZX = context.record.get('ZRZZX');
                    context.record.set("SUM_AMT", XZYB+XZZX+ZHYB+ZHZX+ZRZYB+ZRZZX);
                }
                if (context.field == 'ZRZYB' && context.originalValue != context.value) {
                    var XZYB = context.record.get('XZYB');
                    var XZZX = context.record.get('XZZX');
                    var ZHYB = context.record.get('ZHYB');
                    var ZHZX = context.record.get('ZHZX');
                    var ZRZYB = context.record.get('ZRZYB');
                    var ZRZZX = context.record.get('ZRZZX');
                    context.record.set("SUM_AMT", XZYB+XZZX+ZHYB+ZHZX+ZRZYB+ZRZZX);
                }
                if (context.field == 'ZRZZX' && context.originalValue != context.value) {
                    var XZYB = context.record.get('XZYB');
                    var XZZX = context.record.get('XZZX');
                    var ZHYB = context.record.get('ZHYB');
                    var ZHZX = context.record.get('ZHZX');
                    var ZRZYB = context.record.get('ZRZYB');
                    var ZRZZX = context.record.get('ZRZZX');
                    context.record.set("SUM_AMT", XZYB+XZZX+ZHYB+ZHZX+ZRZYB+ZRZZX);
                }
            }
        }
    });
}

/**
 *  初始化明细表格
 */
function initContentDetilGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "债券编码",
            dataIndex: "ZQ_CODE",
            width: 200,
            type: "string"
        },
        {
            text: '债券名称',
            type: "string",
            dataIndex: "ZQ_NAME",
            width: 200,
            renderer: function (data, cell, record) {
                if(record.get('DATA_TYPE')=='ZW'){
                    var url='/page/debt/common/zwyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="zw_id";
                    paramNames[1]="zwlb_id";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                    paramValues[1]=encodeURIComponent(record.get('ZQLX_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }else{
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=adCode;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            }
        },
        {
            text: '到期日期',
            type: "string",
            dataIndex: "DF_END_DATE",
            width: 100
        },
        {
            text: "到期本金",
            dataIndex: "PLAN_AMT",
            type: "float",
            width: 100,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000');
            }
        },
        {
            header: '申请再融资金额(亿元)', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "FXJH_SUM_AMT",
                    type: "float",
                    text: "合计",
                    width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                },
                {
                    text: '置换一般',
                    dataIndex: "ZHYB_AMT",
                    type: "float",
                    width: 100,
                    align: 'right',
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                },
                {
                    text: "新增一般",
                    dataIndex: "XZYB_AMT",
                    type: "float",
                    width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                },
                {
                    text: "置换专项",
                    dataIndex: "ZHZX_AMT",
                    type: "float",
                    width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                },
                {
                    text: "新增专项",
                    dataIndex: "XZZX_AMT",
                    type: "float",
                    width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },

                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                },
                {
                    text: "再融资一般",
                    dataIndex: "ZRZYB_AMT",
                    type: "float",
                    width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                },
                {
                    text: "再融资专项",
                    dataIndex: "ZRZZX_AMT",
                    type: "float",
                    width: 100,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000');
                    }
                }
            ]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid_detail',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getHbFxjhDetail.action',
        flex: 1,
        border: true,
        autoLoad: false,
        height: '50%',
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                xtype: 'fieldcontainer',
                fieldLabel: '到期日',
                layout: 'hbox',
                // columnWidth: .39,
                width: 300,
                labelWidth: 50,//控件默认标签宽度
                items: [
                    {
                        xtype: 'datefield',
                        itemId: 'STARTDATE',
                        width: 100,
                        format: 'Y-m-d'
                    },
                    {
                        xtype: 'label',
                        text: '至',
                        margin: '3 6 3 6'
                    },
                    {
                        xtype: 'datefield',
                        itemId: 'ENDDATE',
                        width: 100,
                        format: 'Y-m-d'
                    }
                ]
            },
            {
                xtype: 'combobox',
                fieldLabel: '债券类型',
                itemId: "ZQLX",
                displayField: 'name',
                valueField: 'id',
                selectModel: 'leaf',
                editable: false,
                rootVisible: false,
                width: 200,
                labelWidth: 70,
                store: DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE IN ('01','02')"})
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //刷新明细表
                    reloadGridDtl();
                }
            }
        ],
        features: [{
            ftype: 'summary'
        }]
    });
}

/**
 * 刷新界面
 */
function reloadGrid() {
    offLock();
    Ext.ComponentQuery.query('displayfield[name="grid_name"]')[0].setValue(YEAR+'年再融资债券发行计划');
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    store.removeAll();
    store.getProxy().extraParams = {
        YEAR: YEAR,
        TYPE:'2'
    };
    //刷新
    store.loadPage(1);
    //刷新明细表
    var STARTDATE = Ext.ComponentQuery.query('datefield#STARTDATE')[0].getValue();
    if(STARTDATE!=null && STARTDATE!=""){
        STARTDATE=format(STARTDATE, 'yyyy-MM-dd');
    }
    var ENDDATE = Ext.ComponentQuery.query('datefield#ENDDATE')[0].getValue();
    if(ENDDATE!=null && ENDDATE!=""){
        ENDDATE=format(ENDDATE, 'yyyy-MM-dd');
    }
    var ZQLX = Ext.ComponentQuery.query('combobox#ZQLX')[0].getValue();
    var grid_detail = DSYGrid.getGrid('contentGrid_detail');
    var store_detail = grid_detail.getStore();
    store_detail.removeAll();
    store_detail.getProxy().extraParams = {
        TYPE:'2',
        STARTDATE:STARTDATE,
        ENDDATE:ENDDATE,
        ZQLX:ZQLX,
        YEAR: YEAR
    };
    //刷新
    store_detail.loadPage(1);
}
/**
 * 刷新界面
 */
function reloadGridDtl() {
    //刷新明细表
    var STARTDATE = Ext.ComponentQuery.query('datefield#STARTDATE')[0].getValue();
    if(STARTDATE!=null && STARTDATE!=""){
        STARTDATE=format(STARTDATE, 'yyyy-MM-dd');
    }
    var ENDDATE = Ext.ComponentQuery.query('datefield#ENDDATE')[0].getValue();
    if(ENDDATE!=null && ENDDATE!=""){
        ENDDATE=format(ENDDATE, 'yyyy-MM-dd');
    }
    var ZQLX = Ext.ComponentQuery.query('combobox#ZQLX')[0].getValue();
    var grid_detail = DSYGrid.getGrid('contentGrid_detail');
    var store_detail = grid_detail.getStore();
    store_detail.removeAll();
    store_detail.getProxy().extraParams = {
        TYPE:'2',
        STARTDATE:STARTDATE,
        ENDDATE:ENDDATE,
        ZQLX:ZQLX,
        YEAR: YEAR
    };
    //刷新
    store_detail.loadPage(1);
}

/**
 * 刷新左侧树
 */
function reloadTree() {
    //刷新左侧树
    var unit_tree = Ext.ComponentQuery.query('treepanel#tree_year')[0];
    var unit_store = unit_tree.getStore();
    unit_store.load({
        callback: function () {
            //选中最小的一条
            var record = unit_store.getAt(0).getChildAt(0);
            unit_tree.getSelectionModel().select(record);
        }
    });
}