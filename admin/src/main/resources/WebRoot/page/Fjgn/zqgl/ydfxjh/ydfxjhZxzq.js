/**
 * 初始化月度计划编制明细表债券汇总页签grid
 * @param show_type sy 为 首页明细 grid add 为Windows框 明细grid
 * @param tab_type 'zqhz ' 为新增债券
 */

function initWin_ZqhzGrid(sel, name) {

    if (sel == 'sy') { // 首页
        var Json = [
            {
                dataIndex: "YDJH_HZ_ID",
                type: "string",
                text: "明细单ID",
                class: "ty",
                width: 150,
                fontSize: "15px",
                hidden: true
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                text: "地区",
                class: "ty",
                width: 150,
                fontSize: "15px",
                hidden: false
            },
            {
                dataIndex: "PLAN_XZ_AMT", type: "float", text: "申请金额（万元）", class: "xmxz", width: 200, fontSize: "15px",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "REMARK", width: 300, type: "string", text: "备注"}
        ];
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'itemId_sy_zqhz',
            border: false,
            flex: 1,
            headerConfig: {
                headerJson: Json,
                columnAutoWidth: false
            },
            dataUrl: 'getZqhzDtlInfo.action',
            autoLoad: false,
            params: {

            },
            features: [{
                ftype: 'summary'
            }],
            //data: contentGridXzzqData,
            pageConfig: {
                enablePage: false
            }
        };
        var rGrid = simplyGrid.create(config);
        return rGrid;

    } else if (sel = 'add') {
        return insert_add_zqhz();
    }
}

/**
 * 返回添加页面新增债券
 */
function insert_add_zqhz() {
    var headerjson2 = [
        {
            dataIndex: "YDJH_HZ_ID",
            type: "string",
            text: "明细单ID",
            class: "ty",
            width: 150,
            fontSize: "15px",
            hidden: true
        },
        {dataIndex: "AD_NAME", type: "string", text: "地区", class: "ty", width: 150, fontSize: "15px", hidden: false},
        {
            dataIndex: "PLAN_XZ_AMT", type: "float", text: "申请金额（万元）", class: "xmxz", width: 200, fontSize: "15px",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "REMARK", width: 300, type: "string", text: "备注"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'itemId_add_zqhz',
        flex: 1,
        headerConfig: {
            headerJson: headerjson2,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {},
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getZqhzDtlInfo.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqhz_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            'edit': function (editor, context) {

            }
        }
    });
    return grid;

}

/**
 * IS_ZXZQXT_FX为 1或者2 有专项流程 且is_zxzqfb 为1 标准版时初始化债券汇总弹出框
 */
function init_window_zqhz() {
    var window = Ext.create('Ext.window.Window', {
        title: '债券汇总', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'init_zqhz_window', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [init_zqhz_panel()],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var grid = btn.up('window').down('grid');
                    if (!!grid) {
                        var sm = grid.getSelectionModel().getSelection();
                        if (sm.length < 1) {
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            //获取已有债券表格
                            for (var i = 0; i < sm.length; i++) {
                                var zqhzGrid = DSYGrid.getGrid('itemId_add_zqhz');
                                 if (zqhzHave(i, sm, zqhzGrid)) {
                                    return Ext.toast({
                                        html: "债券汇总页签中已包含当前选择的数据!",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                } else {
                                    var xzxmData = sm[i].getData();
                                    zqhzGrid.insertData(null, xzxmData);
                                    $.post("getYdjhDtlInfo.action", {
                                        YDJH_HZ_ID: xzxmData['YDJH_HZ_ID']
                                    }, function (data) {
                                        if (data.success) {
                                            var addgrid = DSYGrid.getGrid('add_xzzq_grid');
                                            var zrzgrid = DSYGrid.getGrid('add_zrzzq_grid');
                                            addgrid.insertData(null, data.xzList);
                                            zrzgrid.insertData(null, data.zrzlist);
                                        } else {
                                            Ext.MessageBox.alert('提示', '明细数据加载失败！' + data.message);
                                        }
                                    }, "json");
                                }
                            }
                            var sq_sum_amt = zqhzGrid.getStore().sum('PLAN_XZ_AMT');
                            Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_XZ_AMT"]')[0].setValue(sq_sum_amt / 10000);
                            btn.up('window').close();
                        }

                    }
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    window.show();
    return window;
}

/**
 * 加载地级市编制的月度发行计划编制
 */
function init_zqhz_grid() {
    var ydjhForm = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0];
    var xm_zqlb = ydjhForm.down('treecombobox[name="ZQLB_ID"]').getValue();
    var bz_year = ydjhForm.down('combobox[name="YDJH_YEAR"]').getValue();

    var zqhz_headerJson = [
        {dataIndex: "YDJH_HZ_ID", type: "string", text: "市县编制主单ID", width: 150, hidden: true},
        {dataIndex: "AD_NAME", type: "string", text: "地区", width: 200},
        {
            text: "申请金额（万元）",
            dataIndex: "PLAN_XZ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "REMARK", type: "string", text: "备注", width: 300}
    ];

    var grid = DSYGrid.createGrid({
        itemId: 'itemId_zqhz_grid',
        flex: 1,
        headerConfig: {
            headerJson: zqhz_headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/getZqhzInfo.action',
        autoLoad: true,
        checkBox: true,
        border: false,
        height: '100%',
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'itemId_zqhz_toolbar',
                items: [
                    {
                        xtype: 'treecombobox',
                        itemId: 'AD_CODE',
                        fieldLabel: '区划',
                        labelWidth: 60,
                        width: 200,
                        name: 'AD_CODE',
                        enableKeyEvents: true,
                        displayField: 'text',
                        valueField: 'code',
                        rootVisible: false,
                        store: qhStore
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLB_ID",
                        fieldLabel: '债券类型',
                        store: zjlxStore,
                        rootVisible: false,
                        selectModel: 'leaf',
                        displayField: 'name',
                        valueField: 'id',
                        value: xm_zqlb,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        editable: false, //禁用编辑
                        allowBlank: false
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            //刷新当前表格
                            zqhzload();
                        }
                    }
                ]
            }
        ],
        params: {
            BZ_YEAR: bz_year,
            XM_ZQLB: xm_zqlb
        },
        listeners:{
            itemclick:function(self,record){
                var ydjh_hz_id = record.get('YDJH_HZ_ID');
                DSYGrid.getGrid('ck_xzzq_grid').getStore().getProxy().extraParams['YDJH_HZ_ID'] = ydjh_hz_id;
                DSYGrid.getGrid('ck_xzzq_grid').getStore().getProxy().extraParams['ZQLX_ID'] = '01';
                DSYGrid.getGrid('ck_xzzq_grid').getStore().loadPage(1);
                DSYGrid.getGrid('ck_zrzzq_grid').getStore().getProxy().extraParams['YDJH_HZ_ID'] = ydjh_hz_id;
                DSYGrid.getGrid('ck_zrzzq_grid').getStore().getProxy().extraParams['ZQLX_ID'] = '03';
                DSYGrid.getGrid('ck_zrzzq_grid').getStore().loadPage(1);
            }
        }

    });
    return grid;
}

/**
 * 判断项目中是否已含有选中项
 */
function zqhzHave(i, sm, zqhzGrid) {
    var have = false;
    if (!!zqhzGrid) {
        for (var j = 0; j < zqhzGrid.getStore().getCount(); j++) {
            // 如果当前选择的债券汇总数据存在债券汇总页签中则提示
            if (sm[i].data["YDJH_HZ_ID"] == zqhzGrid.getStore().getAt(j).data["YDJH_HZ_ID"]) {
                return true;
            }
        }
    } else {
        Ext.toast({
            html: "债券汇总页签不存在!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return true;
    }
    return have;
}

/**
 * 刷新债券汇总
 */
function zqhzload() {
    var gridold = DSYGrid.getGrid('itemId_zqhz_grid');
    var store = gridold.getStore();
    store.removeAll();
    var AD_CODE = Ext.ComponentQuery.query('treecombobox[name="AD_CODE"]')[0].getValue();
    var xm_dqyear = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_YEAR;
    var xm_zqlb = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().ZQLB_ID;
    var ydjh_id = Ext.ComponentQuery.query('form[itemId="init_ydfxjh_form"]')[0].getForm().getFieldValues().YDJH_ID;
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        BZ_YEAR: xm_dqyear,
        XM_ZQLB: xm_zqlb,
        YDJH_ID: ydjh_id
    };
    // 刷新债券汇总主表
    store.loadPage(1);
    //债券汇总明细表
    DSYGrid.getGrid('ck_xzzq_grid').getStore().removeAll();
    //债券汇总明细表
    DSYGrid.getGrid('ck_zrzzq_grid').getStore().removeAll();
}

function init_zqhz_panel() {
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
            init_zqhz_grid(),//加载主表信息
            init_zqhz_dtl_grid()//加载新增债券，再融资债券表信息
        ]
    });
}

function init_zqhz_dtl_grid() {
    return Ext.create('Ext.panel.Panel', {
        name: 'winPanel',
        border: false,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 1,
        autoLoad: true,
        height: '50%',
        items: [
            {
                xtype: 'tabpanel',
                border: false,
                flex: 1,
                itemId: 'winPanel_tabPanel',
                items: [
                    {
                        title: '新增债券',
                        layout: 'fit',
                        name: 'xzzq',
                        items: [insert_ck_xzzq()]
                    },
                    {
                        title: '再融资债券',
                        layout: 'fit',
                        name: 'zrzzq',
                        items: [insert_ck_zrzzq()]
                    }
                ]
            }
        ]
    });
}

/**
 * 返回添加页面新增债券
 */
function insert_ck_xzzq(){
    var headerjson2=[
        {text: "明细单ID",class:"ty",dataIndex: "DATA_ID",width: 150,type: "string",fontSize: "15px",hidden:true},
        {text: "项目ID",class:"ty",dataIndex: "XM_ID",width: 150,type: "string",fontSize: "15px",hidden:true},
        {text: "地区",class:"ty",dataIndex: "AD_NAME",width: 150,type: "string",fontSize: "15px",hidden:false},
        {text: "单位名称",class:"ty",dataIndex: "AG_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "项目名称",class:"ty",dataIndex: "XM_NAME",width: 350,type: "string",fontSize: "15px",hidden: false,
            renderer: function (data, cell, record) {
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "申请金额（万元）",class:"xmxz",dataIndex: "SQ_AMT",width: 200,type: "float",fontSize: "15px", editable:false,
            //tdCls: (IS_ZXZQXT_FX == 1||IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1?'grid-cell-unedit':'',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "剩余可申请金额（万元）",class:"xmxz",dataIndex: "SYSQ_AMT",width: 200,type: "float",fontSize: "15px",hidden:true,editable: false,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "申报日期",class:"xmxz",dataIndex: "SB_DATE",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "项目类型",class:"ty",dataIndex: "XMLX_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "项目性质",class:"xmxz",dataIndex: "XMXZ_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "立项年度",class:"xmxz",dataIndex: "LX_YEAR",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "建设性质",class:"xmxz",dataIndex: "JSXZ_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "建设状态",class:"xmxz",dataIndex: "BUILD_STATUS_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
        {dataIndex: "REMARK", width: 300, type: "string", text: "备注",hidden: false}

    ];
    var grid= DSYGrid.createGrid({
        itemId: 'ck_xzzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: headerjson2,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {
            ZQLX_ID: '01'
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getYdjhdsZqGrid.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jxhj_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            'edit': function (editor, context) {
                if (context.field == 'SQ_AMT' ) {
                    var xzzqStore = grid.getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_XZ_AMT"]')[0].setValue(xzzqStore.sum('SQ_AMT')/10000);
                }
            }
        }
    });
    return grid;

}

function insert_ck_zrzzq(){
    var Json=[
        {text: "再融资债券明细ID",class:"ty",dataIndex: "DATA_ID",width: 150,type: "string",fontSize: "15px",hidden:true,editable: false},
        {text: "债券ID",class:"ty",dataIndex: "ZQ_ID",width: 150,type: "string",fontSize: "15px",hidden:true,editable: false},
        {text: "区划CODE",class:"ty",dataIndex: "AD_CODE",width: 150,type: "string",fontSize: "15px",hidden:true,editable: false},
        {text: "债券/债务名称",class:"ty",dataIndex: "ZQ_NAME",width: 250,type: "string",fontSize: "15px",hidden:false,editable: false,
            renderer: function (data, cell, record) {
                if(record.get('DATA_TYPE')=='ZW'){
                    var url='/page/debt/common/zwyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="zw_id";
                    paramNames[1]="zwlb_id";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1]=encodeURIComponent(record.get('ZWLB_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }else{
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
            }
        },
        /*{text: "发行规模",class:"ty",dataIndex: "FX_AMT",width: 150,type: "float",fontSize: "15px",hidden:false,editable: false,fieldStyle: 'background:#E6E6E6',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }},*/
        {text: "申请金额（万元）",class:"xmxz",dataIndex: "SQ_AMT",width: 200,type: "float",fontSize: "15px",hidden:false,editable: false,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "剩余可申请金额（万元）",class:"xmxz",dataIndex: "SYSQ_AMT",width: 200,type: "float",fontSize: "15px",hidden:true,editable: false,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "申报日期",class:"xmxz",dataIndex: "SB_DATE",width: 150,type: "string",fontSize: "15px",hidden: false},
        {text: "到期日期",class:"ty",dataIndex: "DQDF_DATE",width: 150,type: "string",fontSize: "15px",hidden:false,editable: false},
        {text: "本年到期金额",class:"ty",dataIndex: "DQ_AMT",width: 200,type: "float",fontSize: "15px",hidden:false,editable: false,
            // summaryType: 'sum',summaryR
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "期限ID",class:"ty",dataIndex: "ZQQX_ID",width: 150,type: "string",fontSize: "15px",hidden:true,editable: false},
        {text: "期限",class:"xmxz",dataIndex: "ZQQX_NAME",width: 150,type: "string",fontSize: "15px",hidden:false},
        {text: "债券/债务类型ID",class:"ty",dataIndex: "ZQLB_ID",width: 150,type: "string",fontSize: "15px",hidden:true,editable: false},
        {text: "债券/债务类型",class:"ty",dataIndex: "ZQLB_NAME",width: 150,type: "string",fontSize: "15px",hidden:false,editable: false},
        {text: "备注",dataIndex: "REMARK",width: 300,type: "string",fontSize: "15px",hidden: false}
    ];
    var grid= DSYGrid.createGrid({
        itemId: 'ck_zrzzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {
            ZQLX_ID: '03'
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getYdjhdsZqGrid.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jxhj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners:{

                }
            }
        ],
        listeners: {
            'edit': function (editor, context) {
                var xzzqStore = grid.getStore();
                if (context.field == 'SQ_AMT' ) {
                    var zrzStore = grid.getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="PLAN_ZRZ_AMT"]')[0].setValue(zrzStore.sum('SQ_AMT')/10000);
                }
            }
        }
    });
    /*//将发行规模赋值给再融资债券金额（亿元）
    grid.getStore().on('endupdate', function () {
        var self = grid.getStore();
        var form = grid.up('window').down('form');
        var fxgm_amt = 0;
        //再融资债券金额赋值为0，避免多次修改在造成累加
        form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').setValue(0);
        //获取发行规模填入金额
        self.each(function (record) {
            fxgm_amt += record.get('PLAN_AMT');
        });
        //获取再融资债券债券金额
        var zrzzq_amt=form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').getValue();
        if(zrzzq_amt!=null&&zrzzq_amt!=""&&zrzzq_amt>0){
            fxgm_amt +=Number(zrzzq_amt)*100000000;
        }
        form.down('numberFieldFormat[name="PLAN_ZRZ_AMT"]').setValue(Ext.util.Format.number(fxgm_amt/100000000, '0,000.000000'));

    });*/
    return grid;
}