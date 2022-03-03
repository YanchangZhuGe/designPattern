//创建转贷信息选择弹出窗口
var window_select1 = {
    window: null,
    show: function (params) {
        this.window = initWindow_select1(params);
        this.window.show();
    }
};

//创建转贷信息填报弹出窗口
var window_input1 = {
    window: null,
    zq_code: null,
    show: function (zd_id) {
        this.window = initWindow_input1(zd_id);
        this.window.show();
    }
};

/**
 * 初始化债券选择弹出窗口
 */
function initWindow_select1(params) {
    return Ext.create('Ext.window.Window', {
        title: '债券选择', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'vbox',
        maximizable: true,
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_select_grid1(params)],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();
                    IS_NEW = record.IS_NEW;
                    ZQ_ID = record.ZQ_ID;
                    ADID = record.AD_CODE;
                    var is_on = 1;
                    if (record.PLAN_HB_AMT != null && record.PLAN_HB_AMT != undefined && record.PLAN_HB_AMT > 0) {
                        is_on = 1;
                    } else {
                        is_on = 0;
                    }
                    $.post("/getDqzqGridData.action?XZ_ZQ_ID=" + record.ZQ_ID + "&ISON=" + is_on + "&ZQLB_ID_TEMP=" + record.ZQLB_ID + "&FLAG=SJ&SJ_AD_CODE=" + AD_CODE, function (data_response) {
                        data_response = $.parseJSON(data_response);
                        for (var i = 0; i < data_response.length; i++) {
                            var $temp = data_response[i];
                            for (var j in $temp) {
                                if (j == 'LEAF') {
                                    $temp['leaf'] = true;
                                }
                                if (j == "EXPANDED") {
                                    $temp['expanded'] = false;
                                }
                            }
                        }
                        store_DQZQ = Ext.create('Ext.data.TreeStore', {
                            model: 'treeModel2',
                            proxy: {
                                type: 'ajax',
                                method: 'POST',
                                url: "/getDqzqGridData.action?SJ_AD_CODE=" + AD_CODE + "&FLAG=BJ&XZ_ZQ_ID=" + record.ZQ_ID + "&ISON=" + is_on + "&ZQLB_ID_TEMP=" + record.ZQLB_ID,
                                reader: {
                                    type: 'json'
                                }
                            },
                            root: {
                                expanded: true,
                                text: "全部债券",
                                children: data_response
                            },
                            autoLoad: false
                        });
                        store_DQZQ_TEMP = store_DQZQ;
                        store_BJ_DQZQ = store_DQZQ;

                        DF_START_DATE_TEMP = record.DF_START_DATE;
                        DF_END_DATE_TEMP = record.DF_END_DATE;
                        record.TQHK_DAYS_P = record.TQHK_DAYS;
                        record.SY_HB_AMT2 = record.SY_HB_AMT;
                        is_zrz = false;
                        if (record.PLAN_HB_AMT != null && record.PLAN_HB_AMT != undefined && record.PLAN_HB_AMT > 0) {
                            is_zrz = true;
                        }
                        //弹出填报页面，并写入债券信息
                        var zd_id = GUID.createGUID();
                        window_input1.zq_code = record.ZQ_CODE;
                        window_input1.show(zd_id);
                        window_input1.window.down('form').getForm().setValues(record);

                        if ((IS_BZB == '1' || IS_BZB == '2') && records[0].get('PLAN_XZ_AMT') > 0) {
                            $.post("getFqdfXzzqZdje.action", {
                                    ZQ_ID : encodeURIComponent(record.ZQ_ID),
                                    ADID : encodeURIComponent(record.AD_CODE)
                                }, function(result) {
                                    result = $.parseJSON(result);
                                    if (result.success) {
                                        // 插入值
                                        zdMap.clear();
                                        for (var index in result.dataList) {
                                            window_input1.window.down('grid#zqzd_grid2').insertData(null, result.dataList[index]);
                                            zdMap.put(result.dataList[index].AD_CODE,result.dataList[index]);
                                        }
                                    } else {
                                        window_input1.window.down('grid#zqzd_grid2').insertData(null, {IS_QEHBFX: 1});
                                    }
                                }
                            );
                        }

                        btn.up('window').close();
                    });
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
}

/**
 * 初始化债券选择弹出框表格
 */
function initWindow_select_grid1(params) {
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {
            "dataIndex": "ZQ_ID",
            "type": "string",
            "text": "债券ID",
            "fontSize": "15px",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "TQHK_DAYS",
            "type": "string",
            "text": "提前还款天数",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "ZQ_CODE",
            "type": "string",
            "text": "债券编码",
            "fontSize": "15px",
            "width": 120
        },
        {
            "dataIndex": "ZQ_NAME",
            "type": "string",
            "width": 300,
            "text": "债券名称",
            "hrefType": "combo",
            renderer: button_name == '主债录入' ? '' : function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1] = encodeURIComponent(AD_CODE);
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            "dataIndex": "ZQ_JC",
            "width": 100,
            "type": "string",
            "text": "债券简称"
        },
        {
            "dataIndex": "ZQQX_NAME",
            "width": 100,
            "type": "string",
            "text": "债券期限"
        },
        {
            "dataIndex": "ZQLB_NAME",
            "type": "string",
            "text": "债券类型",
            "fontSize": "15px",
            "width": 100
        },
        {
            "dataIndex": "ZQLB_ID",
            "type": "string",
            "text": "债券类型",
            "fontSize": "15px",
            "width": 100,
            hidden: true
        },
        {
            "dataIndex": "ZQJE", "text": "债券金额（元）",
            columns: [
                {
                    "dataIndex": "PLAN_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "合计"
                },
                {
                    "dataIndex": "PLAN_XZ_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中新增债券"
                },
                {
                    "dataIndex": "PLAN_ZH_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中置换债券"
                },
                {
                    "dataIndex": "PLAN_HB_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中再融资债券"
                }
            ]
        },
        {
            "dataIndex": "YZD", "text": "已转贷金额（元）",
            columns: [
                {
                    "dataIndex": "ZD_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "合计"
                },
                {
                    "dataIndex": "XZ_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中新增债券"
                },
                {
                    "dataIndex": "ZH_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中置换债券"
                },
                {
                    "dataIndex": "HB_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中再融资债券"
                }
            ]
        },
        {
            "dataIndex": "ZQJE", "text": "本级支出金额（元）",
            columns: [
                {
                    "dataIndex": "PAY_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "合计"
                },
                {
                    "dataIndex": "PAY_XZ_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中新增债券"
                },
                {
                    "dataIndex": "PAY_ZH_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中置换债券"
                },
                {
                    "dataIndex": "PAY_HB_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中再融资债券"
                }
            ]
        },
        {
            "dataIndex": "SYKZD", "text": "剩余可转贷金额（元）",
            columns: [
                {
                    "dataIndex": "SY_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "合计"
                },
                {
                    "dataIndex": "SY_XZ_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中新增债券"
                },
                {
                    "dataIndex": "SY_ZH_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中置换债券"
                },
                {
                    "dataIndex": "SY_HB_AMT",
                    "width": 150,
                    "type": "float",
                    "align": 'right',
                    "text": "其中再融资债券"
                }
            ]
        },
        {
            "dataIndex": "ZQQX_NAME",
            "width": 100,
            "type": "string",
            "align": 'right',
            "text": "债券期限"
        },
        {
            "dataIndex": "FXZQ_NAME",
            "width": 100,
            "type": "string",
            "text": "付息周期"
        },
        {
            "dataIndex": "IS_FTDFF",
            "width": 100,
            "type": "string",
            "text": "分摊兑付费",
            hidden: true
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'grid_select',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        //checkBox: true,
        border: false,
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                xtype: "combobox",
                name: "SET_YEAR",
                store: DebtEleStore(json_debt_year),
                displayField: "name",
                valueField: "id",
                value: new Date().getFullYear(),
                fieldLabel: '债券发行年度',
                editable: false, //禁用编辑
                labelWidth: 100,
                width: 220,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                        self.up('grid').getStore().loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    btn.up('grid').getStore().loadPage(1);

                }
            }
        ],
        tbarHeight: 50,
        params: {
            SET_YEAR: new Date().getFullYear(),
            is_xzzd: is_xzzd
        },
        dataUrl: 'getZqxxMainGridData.action'
    });
}

/**
 * 初始化债券转贷弹出窗口
 */
function initWindow_input1(zd_id) {
    return Ext.create('Ext.window.Window', {
        title: '债券转贷', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input1', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initWindow_input_contentForm1(zd_id),
        buttons: [
            {
                xtype: 'button',
                text: '分期兑付自动拆分',
                itemId: 'fqdfcpBtn',
                hidden: IS_BZB == '1' || IS_BZB == '2',
                handler: function (btn) {
                    var form = btn.up('window').down('form'); // from表单金额
                    var zzqzdGrid = btn.up('window').down('grid#zzqzd_grid1'); // 主债券转贷金额
                    var zqzdGrid2 = btn.up('window').down('grid#zqzd_grid2'); // 主债券转贷金额
                    var zzqzdGridStore = zzqzdGrid.getStore();
                    var zqzdGridStore = zqzdGrid2.getStore();
                    if (zqzdGridStore.length <= 0) {
                        Ext.Msg.alert('提示', '请先录入主债券转贷信息！');
                        return false;
                    }
                    $.post("/getFqdfZqxx.action", {
                            ZQ_BILL_ID: form.down('textfield[name="ZQ_ID"]').getValue()
                        },
                        function (data_response) {
                            data_response = $.parseJSON(data_response);
                            if (data_response.length > 0) {

                                var records = [];
                                // 该地区转贷总金额 * 分期兑付债券比例 = 该笔子债券分期转贷金额
                                for (var i = 0; i < data_response.length; i++) {
                                    var data = data_response[i];
                                    var zd_id = GUID.createGUID();
                                    zzqzdGridStore.each(function (record) {
                                        var zqzdGridMap = {};
                                        zqzdGridMap.ZD_ID = zd_id;
                                        zqzdGridMap.ZQ_ID = data.ZQ_ID;
                                        zqzdGridMap.IS_QEHBFX = 1;
                                        zqzdGridMap.AD_CODE = record.get('AD_CODE');
                                        zqzdGridMap.QX_DATE = data.QX_DATE;
                                        zqzdGridMap.ZD_AMT = data.FDQF_BL * record.get('XZ_AMT');
                                        zqzdGridMap.XZ_AMT = data.FDQF_BL * record.get('XZ_AMT');
                                        records.push(zqzdGridMap);
                                    });
                                }
                                zqzdGridStore.removeAll();
                                zqzdGrid2.insertData(null, records);
                                zdxxTab(1);
                            }
                        });

                }
            },
            {
                xtype: 'button',
                text: '添加',
                width: 60,
                hidden: IS_BZB == '1' || IS_BZB == '2',
                handler: function (btn) {
                    if (IS_BZB == '1' || IS_BZB == '2') {
                        btn.up('window').down('grid#zqzd_grid2').insertData(null, {IS_QEHBFX: 1});
                        zdxxTab(0);
                    } else {
                        btn.up('window').down('grid#zzqzd_grid1').insertData(null, {IS_QEHBFX: 1});
                        zdxxTab(0);
                    }

                }
            },
            {
                xtype: 'button',
                itemId: 'tzjhDelBtn',
                text: '删除',
                width: 60,
                disabled: true,
                hidden: IS_BZB == '1' || IS_BZB == '2',
                handler: function (btn) {
                    zdxxTab(0);
                    var grid = btn.up('window').down('grid#zqzd_grid2');
                    if (!(IS_BZB == '1' || IS_BZB == '2')) {
                        grid = btn.up('window').down('grid#zzqzd_grid1');
                    }
                    var records = grid.getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                text: '保存',
                itemId: 'tzjhInsertBtn',
                handler: function (btn) {
                    var form = btn.up('window').down('form');
                    var zqzd_grid2 = btn.up('window').down('#zqzd_grid2');
                    var ZQLB_ID_TEMP = form.getForm().findField("ZQLB_ID").getValue();
                    var sy_xz_amt = form.getForm().findField("SY_XZ_AMT").getValue();
                    var xz_sum_amt = zqzd_grid2.getStore().sum('XZ_AMT');
                    var zd_date = Ext.Date.format(form.getForm().findField("ZD_DATE").getValue(), 'Y-m-d');//转贷日期
                    var qx_date = Ext.Date.format(form.getForm().findField("START_DATE").getValue(), 'Y-m-d');//起息日
                    if (xz_sum_amt<=0) {
                        Ext.Msg.alert('提示', "新增债券金额必须大于0！");
                        return false;
                    }
                    if (zd_date < qx_date) {
                        Ext.Msg.alert('提示', "债券转贷日期不能小于债券起息日！");
                        return false;
                    }
                    if (!(IS_BZB == '1' || IS_BZB == '2')) {
                        var zzqzd_grid1 = btn.up('window').down('#zzqzd_grid1');
                        var xz_fqdf_amt = zzqzd_grid1.getStore().sum('XZ_AMT');
                        if (zzqzd_grid1.getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '请填写主债转贷信息！');
                            zdxxTab(0);
                            return false;
                        }
                    }
                    if (zqzd_grid2.getStore().getCount() <= 0) {
                        Ext.Msg.alert('提示', '请填写子债转贷信息！');
                        zdxxTab(1);
                        return false;
                    }
                    if (xz_sum_amt > sy_xz_amt) {
                        Ext.Msg.alert('提示', "子债券转贷信息表中新增债券金额合计值不能超过其中新增债券金额！");
                        return false;
                    }
                    if (xz_fqdf_amt > sy_xz_amt) {
                        Ext.Msg.alert('提示', "主债券转贷信息表中新增债券金额合计值不能超过其中新增债券金额！");
                        return false;
                    }


                    // if (!checkGrid(zqzd_grid2)) {
                    //     Ext.Msg.alert('提示', grid_error_message);
                    //     return false;
                    // }

                    // 获取单据明细数组
                    var recordArray = [];
                    for (var m = 0; m < zqzd_grid2.getStore().getCount(); m++) {
                        var record =zqzd_grid2.getStore().getAt(m);
                        recordArray.push(record.getData());
                    }

                    var parameters = {
                        zd_id: zd_id,
                        wf_id: wf_id,
                        zd_level: zd_level,
                        zq_code: window_input.zq_code,
                        node_code: node_code,
                        button_name: button_name,
                        detailList: Ext.util.JSON.encode(recordArray),
                        ZQLB_ID_TEMP: ZQLB_ID_TEMP,
                        is_fix: is_fix,
                        is_xzzd: is_xzzd
                    };

                    if (form.isValid()) {
                        //保存表单数据及明细数据
                        form.submit({
                            //设置表单提交的url
                            url: 'savefzdfZdxxGrid.action',
                            params: parameters,
                            success: function (form, action) {
                                //关闭弹出框
                                btn.up("window").close();
                                //提示保存成功
                                Ext.toast({
                                    html: '<div style="text-align: center;">保存成功!</div>',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                window_input.zd_id = '';
                                reloadGrid();
                            },
                            failure: function (form, action) {
                                var result = Ext.util.JSON.decode(action.response.responseText);
                                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                // btn.setDisabled(false);
                            }
                        });
                    } else {
                        Ext.Msg.alert('提示', '请检查必填项！');
                    }
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

function zdxxTab(index) {
    var zdxxTab = Ext.ComponentQuery.query('panel[itemId="zqzd_mx_edit1"]')[0];
    zdxxTab.items.get(index).show();
}

function initWindow_input_contentForm1(zd_id) {
    return Ext.create('Ext.form.Panel', {
        name: "form_zqzd_form",
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        border: false,
        defaults: {
            width: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 280,
//                            disabled:true,
                    readOnly: true,
                    labelWidth: 160//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '债券ID',
                        disabled: false,
                        name: "ZQ_ID",
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '是否关联兑付计划',
                        disabled: false,
                        name: "IS_NEW",
                        hidden: debuggers,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "displayfield",
                        fieldLabel: '债券名称',
                        name: "ZQ_NAME",
                        tdCls: 'grid-cell-unedit'
                        //columnWidth: 0.66
                    },
                    {
                        xtype: "combobox",
                        name: "ZQLB_ID",
                        store: DebtEleStore(json_debt_zqlx2),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债券类型',
                        editable: false, //禁用编辑
                        listeners: {
                            change: function (self, newValue) {
                                // bond_type_id = newValue;
                                //reloadGrid();
                            }
                        },
                        hidden: false,
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_AMT",
                        fieldLabel: '剩余可转贷金额（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_XZ_AMT",
                        fieldLabel: '其中新增债券金额（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_ZH_AMT",
                        fieldLabel: '其中置换债券金额（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_HB_AMT",
                        fieldLabel: "其中再融资债券金额（元）",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_HB_AMT2",
                        fieldLabel: "其中再融资债券金额",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        readOnly: true,
                        hidden: debuggers,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_CDBJ_AMT",
                        fieldLabel: '剩余承担本金金额',
                        plugins: {ptype: 'fieldStylePlugin'},
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_CDLX_AMT",
                        fieldLabel: '剩余承担利息本金金额',
                        plugins: {ptype: 'fieldStylePlugin'},
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SY_DQ_AMT",
                        fieldLabel: '剩余到期金额',
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: debuggers,
                        fieldStyle: 'background:#E6E6E6'
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '2 0 2 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 280,
                    labelWidth: 160,//控件默认标签宽度
                    allowBlank: true
                },
                items: [
                    {
                        xtype: "datefield",
                        name: "ZD_DATE",
                        fieldLabel: '<span class="required">✶</span>转贷日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择转贷日期',
                        value: new Date()
                    },
                    {
                        xtype: "datefield",
                        name: "START_DATE",
                        fieldLabel: '<span class="required">✶</span>起息日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择起息日期',
                        value: DF_START_DATE_TEMP,
                        maxValue: DF_END_DATE_TEMP,
                        minValue: DF_START_DATE_TEMP
                    },
                    {
                        xtype: "numberfield",
                        name: "TQHK_DAYS_P",
                        fieldLabel: '提前还款天数(校验)',
                        hidden: true
                    },
                    {
                        xtype: "numberfield",
                        name: "TQHK_DAYS",
                        fieldLabel: '提前还款天数',
                        minValue: 0,
                        maxValue: 99,
                        allowDecimals: false,
                        hideTrigger: true,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {}
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZNJ_RATE",
                        fieldLabel: '滞纳金率(万分之)',
                        emptyText: '0.000000',
                        minValue: 0,
                        allowDecimals: true,
                        allowBlank: false,
                        decimalPrecision: 6,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: 'treecombobox',
                        width: 200,
                        fieldLabel: "偿还到期债券",
                        name: 'CHDQZQ2',  //应该叫CHDQZQ
                        displayField: 'name',
                        valueField: 'id',
                        editable: false, //禁用编辑
                        readOnly: true,
                        hidden: is_xzzd == 1 ? true : false,//新增债券隐藏
                        store: store_BJ_DQZQ,
                        rootVisible: false,
                        listeners: {
                            itemmouseenter: function (self, record, item) {
                                var remark = "简称:" + record.get("ZQ_JC") + "; 类型:" + record.get("ZQLB_NAME") + "; 发行方式:" + record.get("FXFS_NAME") + "; 期限:" + record.get("ZQQX_NAME");
                                if (!remark) {
                                    return
                                }
                                self.tip = Ext.create('Ext.tip.ToolTip', {
                                    target: item,
                                    delegate: self.itemSelector,
                                    trackMouse: true,
                                    renderTo: Ext.getBody(),
                                    listeners: {
                                        beforeshow: function updateTipBody(tip) {
                                            tip.update(remark);
                                        }
                                    }
                                });
                            },
                            'select': function (a, b, c, d) {
                                var form = a.up('window').down('form');
                                var temp$2 = form.getForm().findField('BJ_HKZQ_AMT').getValue();
                                var recordsingle = b.data;
                                $.post("/getDqsyAmtBySelectId.action", {
                                    AD_CODE: AD_CODE,
                                    DQZQ_ID: recordsingle.DQZQ_ID
                                }, function (data) {
                                    if (data != null && data != undefined) {
                                        var result = data.dataList;
                                        var DQ_AMT_SY = result.DQ_AMT_SY;
                                        //var DQZQ_ID=result.DQZQ_ID;
                                        var amt_kongjian = Ext.ComponentQuery.query('numberFieldFormat[name="BJ_HKZQ_AMT_SY"]')[0];
                                        if (amt_kongjian != null && amt_kongjian != undefined) {
                                            amt_kongjian.setValue(DQ_AMT_SY);
                                        }
                                    }
                                }, "json");
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "BJ_HKZQ_AMT",
                        fieldLabel: "本级偿还到期债券金额",
                        emptyText: '0.00',
                        minValue: 0,
                        hidden: is_xzzd == 1 ? true : false,//新增债券隐藏
                        hideTrigger: true,
                        readOnly: true,
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                var grid = DSYGrid.getGrid('zqzd_grid');
                                var self = grid.getStore();
                                var form = grid.up('window').down('form');
                                //如果偿还到期债券为空，则当前不可选了
                                var input_zd_amt = 0;
                                var input_xz_amt = 0;
                                var input_zh_amt = 0;
                                var input_hb_amt = 0;
                                var input_cdbj_amt = 0;
                                var input_cdlx_amt = 0;
                                self.each(function (record) {
                                    if (record.get('IS_QEHBFX') == 1) {
                                        record.set('CDBJ_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                                        //var qecdlx_amt = (record.get('XZ_AMT') + record.get('ZH_AMT')) * form.down('numberfield[name="PM_RATE"]').getValue() * form.down('combobox[name="ZQQX_ID"]').getValue() / 100;
                                        record.set('CDLX_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                                    }
                                    record.set('ZD_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                                    input_zd_amt += record.get('ZD_AMT');
                                    input_xz_amt += record.get('XZ_AMT');
                                    input_zh_amt += record.get('ZH_AMT');
                                    input_hb_amt += record.get('HB_AMT');
                                    input_cdbj_amt += record.get('CDBJ_AMT');
                                    input_cdlx_amt += record.get('CDLX_AMT');
                                });
                                var bj_hkzq_amt = form.down('numberFieldFormat[name="BJ_HKZQ_AMT"]').getValue();
                                if (bj_hkzq_amt != null && bj_hkzq_amt != "" && bj_hkzq_amt > 0) {
                                    input_hb_amt = input_hb_amt + bj_hkzq_amt;
                                    input_zd_amt = input_zd_amt + bj_hkzq_amt;
                                }
                                form.down('numberFieldFormat[name="ZD_XZ_AMT"]').setValue(input_xz_amt);
                                form.down('numberFieldFormat[name="ZD_ZH_AMT"]').setValue(input_zh_amt);
                                form.down('numberFieldFormat[name="CDBJ_AMT"]').setValue(input_cdbj_amt);
                                form.down('numberFieldFormat[name="CDLX_AMT"]').setValue(input_cdlx_amt);
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_hb_amt = me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').setValue(sy_hb_amt - cha);
                                var sy_amt = me.up('form').down('numberFieldFormat[name="SY_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_AMT"]').setValue(sy_amt - cha);
                            }

                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "BJ_HKZQ_AMT_SY",
                        fieldLabel: "偿还到期债券剩余金额",
                        emptyText: '0.00',
                        hideTrigger: true,
                        hidden: true,
                        readOnly: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "BJ_HKZQ_AMT_ORI",
                        fieldLabel: "偿还到期债券金额(校验)",
                        emptyText: '0.00',
                        hideTrigger: true,
                        hidden: debuggers,
                        readOnly: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZD_ZD_AMT",
                        fieldLabel: '<span class="required">✶</span>转贷总金额(元)',
                        emptyText: '0.00',
                        hideTrigger: true,
                        allowBlank: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        readOnly: true,
                        hidden: true,
                        // disabled: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_amt = me.up('form').down('numberFieldFormat[name="SY_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_AMT"]').setValue(sy_amt - cha);
                            }
                        }

                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZD_XZ_AMT",
                        fieldLabel: '其中新增债券金额',
                        emptyText: '0.00',
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        readOnly: true,
                        //disabled: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_xz_amt = me.up('form').down('numberFieldFormat[name="SY_XZ_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_XZ_AMT"]').setValue(sy_xz_amt - cha);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZD_ZH_AMT",
                        fieldLabel: '置换债券金额',
                        emptyText: '0.00',
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        readOnly: true,
                        // disabled: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_zh_amt = me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').setValue(sy_zh_amt - cha);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZD_HB_AMT",
                        fieldLabel: '再融资债券金额',
                        emptyText: '0.00',
                        decimalPrecision: 6,
                        hideTrigger: true,
                        hidden: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        readOnly: true,
                        // disabled: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_hb_amt = me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').setValue(sy_hb_amt - cha);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "CDBJ_AMT",
                        fieldLabel: '承担本金额金额',
                        editable: false,
                        decimalPrecision: 6,
                        hideTrigger: true/* ,
                         hidden: true */,
                        hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_cdbj_amt = me.up('form').down('numberFieldFormat[name="SY_CDBJ_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_CDBJ_AMT"]').setValue(sy_cdbj_amt - cha);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "CDLX_AMT",
                        fieldLabel: '承担利息本金金额',
                        decimalPrecision: 6,
                        editable: false,
                        hideTrigger: true/* ,
                            hidden: true */,
                        hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var cha = newValue - oldValue;
                                var sy_cdlx_amt = me.up('form').down('numberFieldFormat[name="SY_CDLX_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="SY_CDLX_AMT"]').setValue(sy_cdlx_amt - cha);
                            }
                        }
                    },
                    {
                        xtype: "checkbox",
                        name: "is_ftdff",
                        fieldLabel: "是否分摊兑付费:",
                        inputValue: true,
                        columnWidth: .23,
                        checked: IS_FTDFF_CHECKED == 1 ? true : false,
                        width: 138,
                        margin: '2 5 2 5',
                        labelWidth: 140,
                        boxLabelAlign: 'before'
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '转贷明细',
                flex: 1,
                layout: 'fit',
                items: [initContentAddGrid1(zd_id)
                ]
            }
        ]
    });
}

/**
 * 初始化债券转贷表单中转贷明细信息表格
 */
function initContentAddGrid1(callback) {
    return Ext.create('Ext.tab.Panel', {//下面是个tabpanel
        layout: 'fit',
        itemId: 'zqzd_mx_edit1',
        flex: 1,
        autoLoad: true,
        height: '50%',
        items: IS_BZB == '1' || IS_BZB == '2'? [
            {
                title: '子债券转贷信息',
                layout: 'fit',
                items: initWindow_input_contentForm_grid2()
            }
        ] : [
            {
                title: '主债券转贷信息',
                layout: 'fit',
                items: initWindow_input_contentForm_grid1()
            },
            {
                title: '子债券转贷信息',
                layout: 'fit',
                items: initWindow_input_contentForm_grid2()
            }
        ]
    });

}

/**
 * 初始化主债券转贷明细表格
 */
function initWindow_input_contentForm_grid1() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AD_NAME", type: "string", text: "转贷区域", width: 250, hidden: debuggers},//, hidden: true
        {
            dataIndex: "AD_CODE", type: "string", text: "转贷区域", width: 200,
            renderer: function (value) {
                var store = grid_tree_store;
                var record = store.findRecord('CODE', value, 0, false, true, true);
                return record != null ? record.get('TEXT') : value;
            },
            editor: {//   行政区划动态获取(下拉框)
                xtype: 'combobox',
                displayField: 'TEXT',
                valueField: 'CODE',
                store: grid_tree_store
            },
            tdCls: 'grid-cell'
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: minValue,
                maxValue: maxValue,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zzqzd_grid1',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: false,
        dataUrl: 'getPcjhGridData.action',
        border: true,
        flex: 1,
        height: '100%',
        features: [{
            ftype: 'summary'
        }],
        width: '100%',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqzd_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        pageConfig: {
            enablePage: false
        }
    });
    grid.on('selectionchange', function (view, records) {
        grid.up('window').down('#tzjhDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 初始化子债券转贷明细表格
 */
function initWindow_input_contentForm_grid2() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "IS_READY", type: "string", text: "IS_READY", width: 150, hidden: debuggers},//, hidden: true
        {dataIndex: "IS_IMPORT", type: "string", text: "IS_IMPORT", width: 150, hidden: debuggers},//, hidden: true
        {dataIndex: "ZD_ID", type: "string", text: "转贷ID", width: 250, hidden: debuggers},//, hidden: true
        {dataIndex: "ZQ_ID", type: "string", text: "债券ID", width: 250, hidden: debuggers},//, hidden: true
        {
            dataIndex: "AD_CODE", type: "string", text: "转贷区域", width: 200,
            renderer: function (value) {
                var store = grid_tree_store;
                var record = store.findRecord('CODE', value, 0, false, true, true);
                return record != null ? record.get('TEXT') : value;
            },
            editor: {//   行政区划动态获取(下拉框)
                xtype: 'combobox',
                displayField: 'TEXT',
                valueField: 'CODE',
                store: grid_tree_store
            },
            /*  editor: {//   行政区划动态获取（下拉树）
             xtype: 'treecombobox',
             displayField: 'text',
             valueField: 'code',
             store: grid_tree_store,
             rootVisible: false//隐藏根节点
             }, */
            tdCls: 'grid-cell'
        },
        {
            dataIndex: "IS_QEHBFX", type: "string", text: "是否全额还本付息", width: 150,
            tdCls: 'grid-cell',
            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
            renderer: function (value) {
                var record = DebtEleStore(json_debt_sf).findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            },
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                allowBlank: false,
                value: 1,
                store: DebtEleStore(json_debt_sf)
            }
        },
        {
            dataIndex: "ZD_AMT", type: "float", text: "转贷金额(元)", width: 160, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            renderer: function (value, cellmeta, record) {
                value = record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT');
                return Ext.util.Format.number(value, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }

        },
        {
            dataIndex: "CDBJ_AMT", type: "float", text: "需承担本金金额", width: 160,
            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "CDLX_AMT", type: "float", text: "需承担利息本金金额", width: 160,
            hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "XZ_SYZD_AMT", type: "float", text: "新增债券剩余可转贷金额(元)", width: 230,
            hidden: true,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: minValue,
                maxValue: maxValue,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            //summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "XZ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
            hidden: is_xzzd == 2 ? true : false,//置换再融资债券隐藏
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: minValue,
                maxValue: maxValue,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "ZH_AMT", type: "float", text: "置换债券金额(元)", width: 160,
            hidden: true,//新增债券隐藏
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: minValue,
            //     maxValue: maxValue,
            //     allowBlank: false,
            //     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            // },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "HB_AMT", type: "float", text: "再融资债券金额(元)", width: 160,
            hidden: true,//新增债券隐藏
            // editor: {
            //     xtype: "numberFieldFormat",
            //     emptyText: '0.00',
            //     hideTrigger: true,
            //     mouseWheelEnabled: true,
            //     minValue: minValue,
            //     maxValue: maxValue,
            //     allowBlank: false,
            //     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            // },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "HB_AMT_ORI", type: "float", text: "还本债券金额(元)(校验用)", width: 160, hidden: debuggers
        },
        {
            dataIndex: "CHDQZQ", type: "string", text: "偿还到期债券", width: 150,
            hidden: true,//新增债券隐藏
            editor: {
                xtype: 'treecombobox',
                name: 'CHDQZQ3',
                displayField: 'name',
                valueField: 'id',
                editable: true, //禁用编辑
                readOnly: false,
                store: store_DQZQ,
                rootVisible: false,
                listeners: {
                    itemmouseenter: function (self, record, item) {
                        var remark = "简称:" + record.get("ZQ_JC") + "; 类型:" + record.get("ZQLB_NAME") + "; 发行方式:" + record.get("FXFS_NAME") + "; 期限:" + record.get("ZQQX_NAME");
                        if (!remark) {
                            return
                        }
                        self.tip = Ext.create('Ext.tip.ToolTip', {
                            target: item,
                            delegate: self.itemSelector,
                            trackMouse: true,
                            renderTo: Ext.getBody(),
                            listeners: {
                                beforeshow: function updateTipBody(tip) {
                                    tip.update(remark);
                                }
                            }
                        });
                    },
                    'select': function (a, b, c, d) {
                        var record = b.data;

                    }
                }
            }
        },
        {dataIndex: "CHDQZQSYJE", type: "float", text: "到期债券剩余金额", width: 150, hidden: true},
        {dataIndex: "CHDQZQID", type: "string", text: "偿还到期债券id", width: 150, editor: 'textfield', hidden: debuggers},
        {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150, editor: 'textfield'},
        {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'zqzd_grid2',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: false,
        dataUrl: 'getPcjhGridData.action',
        border: true,
        flex: 1,
        height: '100%',
        features: [{
            ftype: 'summary'
        }],
        width: '100%',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zqzd_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if((IS_BZB == '1' || IS_BZB == '2') && (context.field == 'AD_CODE' || context.field == 'XZ_AMT' || context.field == 'HB_AMT_ORI')){
                            return false
                        }
                    }
                }
            }
        ],
        pageConfig: {
            enablePage: false
        }
    });
    grid.on('selectionchange', function (view, records) {
        grid.up('window').down('#tzjhDelBtn').setDisabled(!records.length);
    });
    grid.getStore().on('endupdate', function () {
        //计算录入窗口转贷总金额
        var self = grid.getStore();
        var form = grid.up('window').down('form');
        var input_cdbj_amt = 0;
        var input_cdlx_amt = 0;
        self.each(function (record) {
            if (record.get('IS_QEHBFX') == 1) {
                record.set('CDBJ_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                record.set('CDLX_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
            }
            record.set('ZD_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
            input_cdbj_amt += record.get('CDBJ_AMT');
            input_cdlx_amt += record.get('CDLX_AMT');
        });
        form.down('numberFieldFormat[name="CDBJ_AMT"]').setValue(input_cdbj_amt);
        form.down('numberFieldFormat[name="CDLX_AMT"]').setValue(input_cdlx_amt);
    });
    return grid;
}