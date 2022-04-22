/**
 * js：新增债券填报
 */

var tab_items = {
    "jbqk": {},
    "bcxx": {},
    "szph": {},
    "bcsb": {},
    "xmcjqy": {"hidden": true},
    "tzjh": {"hidden": true},
    "sdgc": {},
    "zqfj": {},
};

//收支平衡弹出窗口
var window_xekjdr = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config) {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_xekjdr(config);
        }
        this.window.show();
    }
};

/**
 * 默认数据：工具栏
 */
$.extend(zqxm_json_common, {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '新增项目',
                name: 'addXm',
                hidden: is_fxjh == 1 || is_fxjh == 0,
                icon: '/image/sysbutton/projectnew.png',
                handler: function (btn) {
                    is_xz = false;
                    is_zb = false;
                    button_status = btn.name;
                    button_name = btn.text;
                    //获取左侧选择树，初始化全局变量
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_ID = treeArray[1].getSelection()[0].get('id');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    //发送ajax请求，获取新增主表id
                    $.post("/getId.action", function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //弹出弹出框，设置XM_ID
                        window_zqxxtb.XM_ID = data.data[0];
                        window_zqxxtb.file_disabled = false;
                        if(is_fxjh == '0'){
                            window_zqxxtb.show(tab_items, '专项债券需求申报');
                        }else if(is_fxjh == '3') {
                            window_zqxxtb.show(tab_items, '专项债券储备申报');
                        }
                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '遴选项目',
                name: 'add',
                hidden: is_fxjh != 1 && is_fxjh != 4,
                icon: '/image/sysbutton/projectexisting.png',
                handler: function (btn) {
                    is_zb = false;
                    button_status = btn.name;
                    button_name = btn.text;
                    //获取左侧选择树，初始化全局变量
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    initWindow_yyxmtb();

                }
            },
            {
                xtype: 'button',
                text: (is_fxjh == 1) ? '增补项目' : '选择项目',
                name: 'add',
                hidden: (is_fxjh == 1) && IS_SHOW_ZBXM == 0,
                icon: '/image/sysbutton/projectexisting.png',
                handler: function (btn) {
                    is_xz = false;
                    is_zb = (is_fxjh == 1);
                    button_status = btn.name;
                    button_name = btn.text;
                    //获取左侧选择树，初始化全局变量
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    initWindow_yyxmtb();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    button_status = btn.name;
                    button_name = btn.text;
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        btn.setDisabled(false);
                        return;
                    }
                    first = records[0].get("FIRST_BILL");

                    // 20201211 guoyf (需求库)未送审增加是否可修改较验
                    if (sysAdcode == USER_AD_CODE || sysAdcode.concat("00") == USER_AD_CODE) {

                    } else {
                        if (is_fxjh == '0') {
                            var zt = records[0].get('SBZT');
                            if ('1' == zt) {
                                Ext.toast({
                                    html: '所选中数据已审核通过禁止修改!',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.setDisabled(false);
                                return;
                            }
                        }
                    }
                    //获取限额库申报批次所需的参数
                    if (is_fxjh == '1') {//限额库
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                    }
                    window_zqxxtb.XM_ID = records[0].get("XM_ID");
                    window_zqxxtb.file_disabled = false;
                    window_zqxxtb.JH_ID = records[0].get("ID");
                    getKmJcsj(records[0].get("BILL_YEAR"), true);
                    if(is_fxjh == '0'){
                        window_zqxxtb.show(tab_items, '专项债券需求申报');
                    }else if(is_fxjh == '3') {
                        window_zqxxtb.show(tab_items, '专项债券储备申报');
                    }
                    loadXzzq(btn.name);
                    btn.setDisabled(false);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            deleteXzzq();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    //送审
                    doWorkFlow(btn, true);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            fileuploadbutton(),
            fileuploadbutton1(),
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow(btn, false);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '004': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    button_status = btn.name;
                    button_name = btn.text;
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        btn.setDisabled(false);
                        return;
                    }
                    first = records[0].get("FIRST_BILL");
                    // 20201211 guoyf (需求库)被退回增加是否可修改较验
                    if (sysAdcode == USER_AD_CODE || sysAdcode.concat("00") == USER_AD_CODE) {

                    } else {
                        if (is_fxjh == '0') {
                            var zt = records[0].get('SBZT');
                            if ('1' == zt) {
                                Ext.toast({
                                    html: '所选中数据已审核通过禁止修改!',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.setDisabled(false);
                                return;
                            }
                        }
                    }
                    //获取限额库申报批次所需的参数
                    if (is_fxjh == '1') {//限额库
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                        getKmJcsj(BATCH_YEAR, true);
                    }
                    window_zqxxtb.XM_ID = records[0].get("XM_ID");
                    window_zqxxtb.file_disabled = false;
                    window_zqxxtb.JH_ID = records[0].get("ID");
                    getKmJcsj(records[0].get("BILL_YEAR"), true);
                    if(is_fxjh == '0'){
                        window_zqxxtb.show(tab_items, '专项债券需求申报');
                    }else if(is_fxjh == '3') {
                        window_zqxxtb.show(tab_items, '专项债券储备申报');
                    }
                    loadXzzq(btn.name);
                    btn.setDisabled(false);
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function () {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            deleteXzzq();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn, true);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '008': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '010': [{
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                reloadGrid();
            }
        }, {
            xtype: 'button',
            text: '上传文件',
            itemId: 'scwj',
            name: 'scwj',
            icon: '/image/sysbutton/upload.png',
            handler: function (btn) {
                var records = DSYGrid.getGrid('contentGrid').getSelection();
                if (records.length != 1) {
                    Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
                    return false;
                }
                var bill_id = records[0].get("ID");
                var zqlx_id = records[0].get("BOND_TYPE_ID");
                var xm_id = records[0].get("XM_ID");
                // TODO 未改
                initWin_xmInfo_cp_scfj(xm_id, bill_id);
                var zqxxYHSTab = Ext.ComponentQuery.query('panel[itemId="xmxxTab"]')[0];


            }
        },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()]
    },
    items_content_rightPanel_items: function () {
        if (SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
            return [
                {
                    xtype: 'panel',
                    layout: 'vbox',
                    width: '100%',
                    height: '100%',
                    flex: 1,
                    items: [
                        initContentXeGrid(),
                        initContentGrid()
                    ]
                }
            ]
        } else {
            return [
                {
                    xtype: 'panel',
                    layout: 'vbox',
                    width: '100%',
                    height: '100%',
                    flex: 1,
                    items: [
                        initContentGrid()
                    ]
                }
            ]
        }
    },
    item_content_grid_config: {
        border: true,
        flex: 1,
        width: '100%',
        dataUrl: '/xzzqJhsb/getXzzqContentGridYHS.action',
        autoLoad: false,
        params: {
            is_fxjh: is_fxjh,
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            node_type: node_type,
            menucode: menucode,
            is_zxzq: is_zxzq,
            ZQXM_TYPE: is_zxzq=='1'?'02':is_zxzq=='2'?'01':is_zxzq
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_zt),
                width: 110,
                labelWidth: 30,
                editable: false,
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(zqxm_json_common.items[WF_STATUS]);
                        //刷新当前表格
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                    }
                }
            }
        ]
    },
    reloadGrid: function () {
        var grid = DSYGrid.getGrid('contentGrid');
        if (grid) {
            var store = grid.getStore();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["bond_type_id"] = bond_type_id;
            if (SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
                //刷新限额表格,置为空
                var store_details = DSYGrid.getGrid('contentXEGrid').getStore();
                //如果传递参数不为空，就刷新明细表格
                store_details.getProxy().extraParams["AD_CODE"] = AD_CODE;
                store_details.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
                store_details.load();
                store.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
            } else {
                store.getProxy().extraParams["SET_YEAR"] = null;
            }
            if (typeof param != 'undefined' && param != null) {
                for (var i in param) {
                    store.getProxy().extraParams[i] = param[i];
                }
            }
            store.loadPage(1);
        }
    }
});

/**
 * 初始化已有项目债券信息填报弹出窗口
 */
function initWindow_yyxmtb() {
    var title = '选择项目';
    if (is_fxjh == 1) {
        if (is_zb) {
            title = '增补项目';
        } else {
            title = '遴选项目';
        }
    }
    var yyxmWin = Ext.create('Ext.window.Window', {
        itemId: 'window_yyxmtb', // 窗口标识
        name: 'xzzqWin',
        title: title, // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.95, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWindow_yyxmtb_contentGrid()],
        buttons: [
            {
                text: '确定',
                name: 'yes',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('yyxmGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        return;
                    }
                    //需求库入口校验防伪码
                    if (!checkSecuCode({'IDS': [records[0].get("XM_ID")]})) {
                        return;
                    }
                    XM_ID = records[0].get("XM_ID");
                    window_zqxxtb.XM_ID = records[0].get("XM_ID");
                    window_zqxxtb.file_disabled = false;
                    window_zqxxtb.JH_ID = records[0].get("ID");

                    //获取限额库申报批次所需的参数
                    if (is_fxjh == '1') {//限额库
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                        getKmJcsj(BATCH_YEAR, true);
                    }
                    if(is_fxjh == '0'){
                        window_zqxxtb.show(tab_items, '专项债券需求申报');
                    }else if(is_fxjh == '3') {
                        window_zqxxtb.show(tab_items, '专项债券储备申报');
                    }
                    loadXzzq(btn.name);
                    btn.up('window').close();

                    // // var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                    // // var form = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm();
                    // // form.findField('IS_XMZBJ').setValue('0');
                    // loadXzzq_Yyxm();
                    // //加载本次申报页签内容为遴选的年度计划
                    // var data = records[0].data;
                    // if (is_fxjh == '1') {
                    //     //该部分是限额库遴选申报时需要的
                    //     data.FP_AMT = parseFloat(data.APPLY_AMOUNT1);
                    //     var APPLY_ZBJ_AMT = parseFloat(data.APPLY_ZBJ_AMT);
                    //     // var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                    //     // var form = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm();
                    //     // form.findField('ZBJ_AMT').setValue(APPLY_ZBJ_AMT);
                    // } else {
                    //     //需求库中，项目中的资本金和申报form中的资本金字冲突,删除该字段
                    //     //data.ZBJ_AMT = parseFloat(data.ZBJ_AMT) / 10000;
                    //     // delete data.ZBJ_AMT;
                    // }
                    // //续发行默认为否
                    // /*if (isNull(records[0].data.IS_XFX)) {
                    // 	records[0].data.IS_XFX = 0;
                    // }*/
                    // // window_zqxxtb.window.down('form[name=bnsbForm]').getForm().setValues(data);
                    // // Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().setValues(data);
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
    yyxmWin.show();

}

function getKmJcsj(year,autoLoad) {
    var condition_str = year <= 2017 ? " <= '2017' " : " = '"+year+"' ";
    zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '1050402%' or code like '1101102%') and year "+ condition_str);
    zcgnfl_store.proxy.extraParams['condition'] = encode64(" and year "+ condition_str);
    zcjjfl_store.proxy.extraParams['condition'] = encode64(" and year "+ condition_str);

    sbpc_store.proxy.extraParams['BATCH_YEAR'] = year;
    sbpc_store.proxy.extraParams['BOND_TYPE'] = isNull(BATCH_BOND_TYPE_ID)?"":BATCH_BOND_TYPE_ID.substr(0, 2);
    sbpc_store.proxy.extraParams['AD_CODE'] = AD_CODE;
    sbpc_store.proxy.extraParams['is_fxjh'] = is_fxjh;

    if(autoLoad) {
        getKmStoreLoad();
    }
}
function getKmStoreLoad() {
    zwsrkm_store.load();
    zcgnfl_store.load();
    zcjjfl_store.load();
    sbpc_store.load();
}
function loadXzzq(btn_name) {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (btn_name != 'yes' && records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
        return;
    }
    var ID = window_zqxxtb.JH_ID;//records[0].get("ID");
    var XM_ID = window_zqxxtb.XM_ID;//records[0].get("XM_ID");

    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];

    jbqkForm.load({
        url: '/xzzqJhsb/loadXzzqYHS.action',
        params: {
            ID: ID,
            XM_ID: XM_ID,
            isOld_szysGrid: isOld_szysGrid,
            is_fxjh: is_fxjh,
            is_zxzq: is_zxzq,
            IS_XMBCXX: IS_XMBCXX
        },
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            for (var name in tab_items) {
                switch (name) {
                    case "jbqk":
                        // 基本情况
                        setZqxmJbqkForm(action);
                        break;
                    case "bcxx":
                        // 补充信息-前期准备
                        if (IS_XMBCXX == '1') {
                            setZqxmBcxxForm(action);
                        }
                        break;
                    case "szph":
                        // 收支平衡 - 收支预算
                        // setZqxmSzphForm(window_zqxxtb.XM_ID); //根据项目类型统一初始化
                        break;
                    case "bcsb":
                        // 本次申报
                        setZqxmBcsbForm(action);
                        break;
                    case "xmcjqy":
                        // 加载“项目承建企业”页签表格
                        if (is_fxjh == '1') {
                            setZqxmXmcjqyForm(action);
                        }
                        break;
                    case "tzjh":
                        // 投资计划
                        setZqxmTzjhForm(action);
                        break;
                    case "sdgc":
                        // 十大工程
                        if (sysAdcode=='42'||sysAdcode=='21'||is_fxjh=='5'||is_show==false) {
                            setZqxmSdgcForm(action);
                        }
                        break;
                }
            }
            // connNdjh = action.result.data.jbqkForm.CONNNDJH;
            // connZwxx = action.result.data.jbqkForm.CONNZWXX;

            // //判断是否第一单，若是第一单则基本情况可以修改，若不是第一单则不能修改
            // var first_bill = records[0].get("FIRST_BILL");
            // var xmfj = DSYGrid.getGrid('window_zqxxtb_contentForm_tab_xmfj_grid');
            // if (first_bill == '0') {
            //     jbqkForm.items.each(function (item1) {
            //         if (item1.items != undefined && item1.items != "" && item1.items != "null") {
            //             item1.items.each(function (item2) {
            //                 if (item2.items != undefined && item2.items != "" && item2.items != "null") {
            //                     item2.items.each(function (item) {
            //                         if (item.name == 'BUILD_STATUS_ID'
            //                             || item.name == 'START_DATE_ACTUAL'
            //                             || item.name == 'END_DATE_ACTUAL'
            //                             || item.name == 'YSXM_NO'
            //                             || item.name == 'JYS_NO'
            //                             || item.name == 'PF_NO'
            //                             || item.name == 'BILL_PERSON'
            //                             || item.name == 'BILL_PHONE'
            //                             || item.name == 'BUILD_CONTENT'
            //                             || item.name == 'UPPER_XM_ID'
            //                             || item.name == (is_fxjh == 0 ? 'MB_ID' : 'null')
            //                             || item.name == 'ZJTXLY_ID'
            //                             || item.name == 'XMSY_YCYJ'
            //                             || item.name == 'GK_PAY_XMNO'
            //                             || item.name == 'GJZDZLXM_ID'
            //                             || item.name == 'FGW_XMK_CODE'
            //                             || item.name == 'SS_ZGBM_ID'
            //                         ) {
            //                         } else {
            //                             if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
            //                                 SetItemReadOnly(item.items);
            //                                 SetFormItemsReadOnly(item.items);
            //                             } else {
            //                                 if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
            //                                     || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
            //                                     || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
            //                                     || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
            //                                 ) {
            //                                     return;
            //                                 }
            //                                 item.readOnly = true;
            //                                 item.editable = false;
            //                                 if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
            //                                     item.fieldCls = 'form-unedit';
            //                                     if (item.getXType() == 'numberfield' || item.getXType() == 'numberFieldFormat') {
            //                                         item.fieldCls = 'form-unedit-number';
            //                                     }
            //                                 }
            //                                 if (item.setReadOnly && item.setFieldStyle) {
            //                                     item.setReadOnly(true);
            //                                     if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
            //                                         item.setFieldStyle('background:#E6E6E6');
            //                                     }
            //                                 }
            //                             }
            //                             !!xmfj ? xmfj.editable = false : '';
            //                             /*if(item.name!=undefined){
            //                                 item.setReadOnly(true);
            //                                 item.setFieldStyle('background:#E6E6E6');
            //                                 item.readOnly = true;
            //                                 item.fieldStyle = 'background:#E6E6E6';
            //                             }*/
            //                         }
            //                     });
            //                 }
            //             });
            //         }
            //     });
            //     //LxdwRender(xmlx_id);
            // }

            if (tab_items.length > 0) {
                //加载项目只读页签数据
                $.post('getJSXMInfo.action', {
                    XM_ID: XM_ID,
                    isOld_szysGrid: isOld_szysGrid,
                    tab_items: Ext.util.JSON.encode(tab_items)
                }, function (data) {
                    var dataJson = JSON.parse(data);
                    if (dataJson.success) {
                        //加载存量债务页签表格
                        setClzwxx(dataJson);
                        //加载项目资产页签
                        setXmzcxx(dataJson);
                        //加载招投标页签表格
                        setZtbxx(dataJson);
                        //加载建设进度页签表格
                        setJsjdxx(dataJson);
                        //加载实际收益页签表格
                        setSjsyxx(dataJson);
                    } else {
                        alert('加载失败');
                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                    }
                });
            }
            // 发行库 设置只读
            if ("0" == is_fxjh) {
                // 标签页只读
                var jbqkFormZD = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
                SetJBQKFormItemsReadOnly(jbqkFormZD.items);
                var bcxxFormZD = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
                // SetJBQKFormItemsReadOnly(bcxxFormZD.items);
            }
        },
        failure: function (form, action) {
            alert('加载失败');
            Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
        }
    });
}

// 设置只读
function SetJBQKFormItemsReadOnly(Items) {
    Items.each(function (item) {
        if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
            SetJBQKFormItemsReadOnly(item.items);
        } else {
            //防止某些控件不支持setReadOnly
            if (item.setReadOnly && item.setFieldStyle) {
                item.setReadOnly(true);
                if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                    item.setFieldStyle('background:#E6E6E6');
                }
            }
        }
    });
}

/**
 * 工作流变更
 */
function doWorkFlow(btn, fzr) {

    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    if (records.length > 1) {
        for (var i = 0; i < records.length - 1; i++) {
            var x = records[i].get("AG_ID");
            var y = records[i + 1].get("AG_ID");
            if (x != y) {
                Ext.MessageBox.alert('提示', '请选择同一单位的项目再进行操作');
                return;
            }
        }
    }
    // 弹出负责人信息
    if (fzr) {
        saveFZRxx(btn, records[0].get("AG_CODE"), records[0].get("AG_NAME"));
        return;
    }
    var isTzXms = [];
    var ids = [];
    var xm_ids = [];
    var is_ends = [];
    var mb_ids = [];
    for (var i in records) {
        ids.push(records[i].get("ID"));
        xm_ids.push(records[i].get("XM_ID"));
        is_ends.push(records[i].get("IS_END"));
        mb_ids.push(records[i].get("MB_ID"));
        if (records[i].get("IS_TZ") == '1') {//需要校验实施方案的项目
            isTzXms.push(records[i].get("XM_ID"));
        }
    }
    var zqlxIds = [];//BOND_TYPE_ID
    //限额库 送审时执行
    if ((is_fxjh == '1') && btn.name === 'down') {
        //获取债券类型
        for (var i in records) {
            zqlxIds.push(records[i].get("BOND_TYPE_ID"));
        }
        //对获取的ZQLX_ID去重 借助indexOf()方法判断此元素在该数组中首次出现的位置下标与循环的下标是否相等
        if (zqlxIds.length > 1) {
            for (var i = 0; i < zqlxIds.length; i++) {
                if (zqlxIds.indexOf(zqlxIds[i]) != i) {
                    zqlxIds.splice(i, 1);//删除数组元素后数组长度减1后面的元素前移
                    i--;//数组下标回退
                }
            }
        }
    }
    button_name = btn.text;
    //增加送审时项目金额校验
    if ((is_fxjh == '1') && btn.name === 'down' && SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0') {
        var xeRec = DSYGrid.getGrid('contentXEGrid').getStore();
        if (xeRec.getCount() <= 0) {
            return xeqkz('限额为空！');
        }
        var ybxe = xeRec.getAt(0).get('SY_YB_AMT') / 10000;
        var yb = null;

        if (DEBT_ZXXEKZFS == '1') {//专项限额控制方式
            var zx_tcxe = xeRec.getAt(0).get('SY_ZX_TC_AMT') / 10000;//土储剩余限额
            var zx_glxe = xeRec.getAt(0).get('SY_ZX_GL_AMT') / 10000;//公路剩余限额
            var zx_pgxe = xeRec.getAt(0).get('SY_ZX_PG_AMT') / 10000;//棚改剩余限额
            var zx_qtxe = xeRec.getAt(0).get('SY_ZX_QT_AMT') / 10000;//其他自平衡、普通专项剩余限额
            var zx_tc = null;
            var zx_gl = null;
            var zx_pg = null;
            var zx_qt = null;
            for (var i in records) {
                if (records[i].get("BOND_TYPE_ID") == '01') {
                    yb = yb ? yb : 0;
                    yb += records[i].get("APPLY_AMOUNT1");
                } else {
                    if (records[i].get("BOND_TYPE_ID") == '020201') {//土地储备
                        zx_tc = zx_tc ? zx_tc : 0;
                        zx_tc += records[i].get("APPLY_AMOUNT1");
                    } else if (records[i].get("BOND_TYPE_ID") == '020202') {//收费公路
                        zx_gl = zx_gl ? zx_gl : 0;
                        zx_gl += records[i].get("APPLY_AMOUNT1");
                    } else if (records[i].get("BOND_TYPE_ID") == '020203') {//棚改
                        zx_pg = zx_pg ? zx_pg : 0;
                        zx_pg += records[i].get("APPLY_AMOUNT1");
                    } else if (records[i].get("BOND_TYPE_ID") == '0201' || records[i].get("BOND_TYPE_ID") == '020299') {//其他自平衡
                        zx_qt = zx_qt ? zx_qt : 0;
                        zx_qt += records[i].get("APPLY_AMOUNT1");
                    }
                }
            }
            if (zx_tc && zx_tc > zx_tcxe) {//土地储备
                return xeqkz('超出新增土地储备专项债券剩余限额!');
            } else if (zx_gl && zx_gl > zx_glxe) {//收费公路
                return xeqkz('超出新增收费公路专项债券剩余限额!');
            } else if (zx_pg && zx_pg > zx_pgxe) {//棚改
                return xeqkz('超出新增棚改专项债券剩余限额!');
            } else if (zx_qt && zx_qt > zx_qtxe) {//其他自平衡
                return xeqkz('超出其他专项债券剩余限额!');
            }
        } else {
            var zxxe = xeRec.getAt(0).get('SY_ZX_AMT') / 10000;
            var zx = null;
            for (var i in records) {
                if (records[i].get("BOND_TYPE_ID") == '01') {
                    yb = yb ? yb : 0;
                    yb += records[i].get("APPLY_AMOUNT1");
                } else {
                    zx = zx ? zx : 0;
                    zx += records[i].get("APPLY_AMOUNT1");
                }
            }
            if (zx && zx > zxxe) {
                return xeqkz('超出专项债券剩余限额!');
            }
        }
        if (yb && yb > ybxe) {
            return xeqkz('超出一般债券剩余限额!');
        }
    }
    Ext.Msg.confirm('提示', '确认' + button_name + '选中记录?', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            //发送ajax请求，修改节点信息
            $.post("/xzzqJhsb/doXzzqWorkFlowYHS.action", {
                workflow_direction: btn.name,
                wf_id: wf_id,
                AD_CODE: AD_CODE,
                node_code: node_code,
                button_name: button_name,
                audit_info: '',
                ids: ids,
                xm_ids: xm_ids,
                is_ends: is_ends,
                mb_ids: mb_ids,
                isTzXms: isTzXms,
                is_fxjh: is_fxjh,
                is_zxzq: is_zxzq,
                node_type: node_type,
                zqlxIds: zqlxIds,
                is_ss: "1",//是否为送审
                menucode: menucode
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: button_name + "成功！" + (data.message ? data.message : ''),
                        closable: false, align: 't', slideInDuration: 400, minWidth: 400
                    });
                } else {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: button_name + '失败！' + (data.message ? data.message : ''),
                        minWidth: 300,
                        buttons: Ext.Msg.OK,
                        fn: function (btn) {
                        }
                    });
                }
                //刷新表格
                reloadGrid();
            }, "json");
        }
    });
}

// 上传
function fileuploadbutton() {
    return {
        xtype: 'form',
        hidden: IS_SHOW_SPEC_UPLOAD_BTN == '0' ? true : false,
        itemId: 'form_upload_id',
        name: 'form_upload_name',
        enctype: 'multipart/form-data;charset=UTF-8',
        border: false,
        width: 100,
        baseCls: 'my-panel-no-border',
        margin: '0 15 0 0',
        items: [
            {
                xtype: 'filefield',
                buttonText: '<span style="color: black">导入新增项目</span>',
                itemId: "uploady",
                name: 'upload',
                buttonOnly: true,
                width: 100,
                padding: '0 0 0 0',
                margin: '0 0 0 0',
                hideLabel: true,
                buttonConfig: {
                    icon: '/image/sysbutton/projectnew.png',
                    style: {
                        "border-color": '#D8D8D8',
                        background: '#f6f6f6'
                    }
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form');
                        upload_xzzm(form, 'xz', 'uploady');
                        reloadGrid();
                    }
                }
            }
        ]
    };
}

function fileuploadbutton1() {
    return {
        xtype: 'form',
        hidden: IS_SHOW_SPEC_UPLOAD_BTN == '0' ? true : false,
        itemId: 'form_upload_id1',
        name: 'form_upload_name1',
        //fileUpload: true,
        enctype: 'multipart/form-data;charset=UTF-8',
        border: false,
        width: 100,
        baseCls: 'my-panel-no-border',
        items: [
            {
                xtype: 'filefield',
                buttonText: '<span style="color: black">导入已有项目</span>',
                itemId: "uploady1",
                name: 'upload',
                buttonOnly: true,
                width: 100,
                padding: '0 0 0 0',
                margin: '0 0 0 0',
                hideLabel: true,
                buttonConfig: {
                    icon: '/image/sysbutton/projectnew.png',
                    style: {
                        "border-color": '#D8D8D8',
                        background: '#f6f6f6'
                    }
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form');
                        upload_xzzm(form, 'yy', "uploady1");
                        reloadGrid();
                    }
                }
            }
        ]
    };
}

/**
 * 删除新增债券
 * @param form
 */
function deleteXzzq() {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
        return;
    }
    //获取新增债券表格
    var xzzqArray = [];
    for (var i in records) {
        xzzqArray.push(records[i].getData());
    }
    //设置ajax请求参数
    var url = '/xzzqJhsb/deleteXzzqYHS.action';
    var params = {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        isOld_szysGrid: isOld_szysGrid,
        IS_FXJH: is_fxjh,
        is_zxzq: is_zxzq,
        //ID: ID,
        xzzqArray: encodeURIComponent(Ext.util.JSON.encode(xzzqArray))
    };
    //发送ajax请求，提交数据
    $.post(
        url,
        params,
        function (data) {
            if (data.success) {
                Ext.toast({
                    html: "删除成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
            } else {
                Ext.MessageBox.alert('提示', data.message);
            }
            //刷新表格
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        },
        "json"
    );
}

/**
 * 初始化右侧主表格
 */
function initContentXeGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "XE_ID", width: 100, type: "string", text: "ID", hidden: true},
        {dataIndex: "SET_YEAR", width: 80, type: "string", text: "年度"},
        {dataIndex: "AD_CODE", width: 100, type: "string", text: "区划编码", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "区划名称"},
        {
            dataIndex: "XZYB", width: 150, type: "float", text: "新增一般债券限额(万元)",
            columns: [
                {
                    dataIndex: "XZ_YBZQ_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_YB_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_YB_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX",
            width: 150,
            type: "float",
            text: "新增专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? true : false,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_TC",
            width: 150,
            type: "float",
            text: "新增土地储备专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_TC_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_TC_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_TC_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_GL",
            width: 150,
            type: "float",
            text: "新增收费公路专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_GL_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_GL_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_GL_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_PG",
            width: 150,
            type: "float",
            text: "新增棚改专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_PG_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_PG_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_PG_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_QT",
            width: 150,
            type: "float",
            text: "新增其他专项债券限额（万元）",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_QT_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_QT_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_QT_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentXEGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        border: false,
        autoLoad: false,
        height: 150,
        width: '100%',
        dataUrl: '/getDqxeData.action',
        params: {
            SET_YEAR: '',
            BUSI_TYPE: '0',
            is_tb: '1'
        },
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                fieldLabel: '年度',
                xtype: 'combobox',
                name: 'SET_YEAR',
                value: new Date().getUTCFullYear(),
                width: 145,
                editable: false,
                labelWidth: 30,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                displayField: 'name',
                valueField: 'code',
                allowBlank: false,
                store: DebtEleStore(getYearList({start: -5, end: 5})),
                listeners: {
                    change: function (self, newValue) {
                        SET_YEAR = newValue;
                        reloadGrid();
                    }
                }
            }
        ]
    });
}


/**
 * 初始化债券信息填报弹出窗口中的申报记录标签页中的表格
 */
function initWindow_yyxmtb_contentGrid() {
    //设置查询form
    var search_form = DSYSearchTool.createTool({
        itemId: 'window_select_jsxm_grid_searchTool',
        defaults: {
            labelAlign: 'right',
            labelWidth: 80,
            columnWidth: .333,
            margin: '3 5 3 5'
        },
        items: [
            {
                fieldLabel: '模糊查询',
                xtype: 'textfield',
                name: 'YYXM_MHCX',
                columnWidth: .333,
                emptyText: '请输入项目编码/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            reloadYyxmGrid();
                        }
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '项目性质',
                name: 'YYXM_XMXZ_ID',
                displayField: 'name',
                valueField: 'id',
                rootVisible: false,
                lines: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                hidden: true,
                store: DebtEleTreeStoreDB("DEBT_ZJYT", {condition: " and 1=1 and code!='0102' "})
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '项目类型',
                name: 'YYXM_XMLX_ID',
                minPicekerWidth: 250,
                displayField: 'name',
                rootVisible: false,
                valueField: 'id',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                editable: false
            },
            {
                xtype: 'combobox',
                fieldLabel: '建设状态',
                name: 'YYXM_BUILD_STATUS_ID',
                displayField: 'name',
                valueField: 'id',
                store: DebtEleTreeStoreDB("DEBT_XMJSZT", {condition: "AND GUID !='02' AND GUID !='03'AND GUID !='04'AND GUID !='05' "}),
                editable: false
            },
            {
                xtype: 'combobox',
                fieldLabel: '申报年度',
                name: 'BILL_YEAR',
                labelWidth: 70,
                width: 180,
                editable: false,
                value: nowDate.substr(0, 4),
                format: 'Y',
                hidden: (is_fxjh == 1) ? false : true,
                labelAlign: 'right',
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                listeners: {
                    change: function (self, newValue) {
                        reloadGrid({
                            BILL_YEAR: newValue
                        });
                    }
                }
            },
            {
                fieldLabel: '重新申报',
                xtype: 'checkbox',
                name: 'IS_CXSB',
                hidden: is_fxjh == 0 ? false : true// 需求库下显示
            },
            {
                fieldLabel: '申报批次',
                name: 'SB_BATCH_NO',
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                hidden: is_fxjh == 0 ? false : true,// 需求库下显示
                store: DebtEleTreeStoreDB('DEBT_FXPC', {
                    condition: " and year > '2020' and EXTEND1 LIKE '01%'"
                        + " and (EXTEND2 IS NULL OR EXTEND2 = '0') "
                })
            },
            {
                fieldLabel: '是否已发债',
                name: 'SF_FZ',
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                hidden: is_fxjh == '0' ? false : true,
                store:SF_STORE,
                allowblank:false,
                listeners: {
                    change: function (self, newValue) {
                        reloadYyxmGrid({
                            SF_FZ: newValue
                        });
                    }
                }
            }
        ],
        border: true,
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        // 查询按钮回调函数
        callback: function (self) {
            reloadYyxmGrid();
        }
    });
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 100,
        dock: 'right',
        layout: {
            type: 'vbox',
            align: 'center'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //20210507 wq  需求库申报
                    if (is_fxjh == 0 && node_type == "jhtb") {
                        var form = btn.up('form').getForm();
                        var IS_CXSB = form.findField('IS_CXSB').getValue();
                        var SB_BATCH_NO = form.findField('SB_BATCH_NO').getValue();
                        if (IS_CXSB == true && isNull(SB_BATCH_NO)) {
                            Ext.Msg.alert('提示', "请先选择申报批次！");
                            return;
                        }
                    }
                    reloadYyxmGrid();
                }
            },
            {
                xtype: 'button',
                text: '重置',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    form.reset();
                }
            }
        ]
    });
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "ID", type: "string", text: "债券ID", hidden: true},
        {dataIndex: "XM_ID", type: "string", text: "项目id", hidden: true},
        {
            dataIndex: "XM_NAME", type: "string", text: "项目", width: 300,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('XM_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {dataIndex: "AG_NAME", type: "string", text: "建设单位", hidden: true},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质", hidden: true},
        {dataIndex: "XMXZ_NAME", type: "string", text: "项目性质", width: 250, hidden: true},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 250},
        {dataIndex: "BUILD_STATUS_NAME", type: "string", text: "建设状态 ", width: 150},
        {
            dataIndex: "XMZGS_AMT", type: "float", text: "项目总概算金额(万元) ", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "JYS_NO", type: "string", text: "项目建议书文号 ", width: 150, hidden: true},
        {dataIndex: "PF_NO", type: "string", text: "可研批复文号", width: 150, hidden: true}
    ];
    var url = '/xzzqJhsb/getYyxmGridYHS.action';
    if (is_fxjh == 1 && !is_zb) {
        //如果是发行计划，增加发行计划相关列
        url = '/xzzqJhsb/getYyNdjhGridYHS.action';
        headerJson.shift();
        headerJson.unshift(
            {xtype: 'rownumberer', width: 45},
            // {
            //     dataIndex: "APPLY_AMOUNT1", width: 160, type: "float", text: "本年申报数(万元)",
            //     renderer: function (value) {
            //         return Ext.util.Format.number(value / 10000, '0,000.00####');
            //     },
            //     summaryType: 'sum',
            //     summaryRenderer: function (value) {
            //         return Ext.util.Format.number(value / 10000, '0,000.00####');
            //     }
            // },
            // {
            //     dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额(万元)",
            //     renderer: function (value) {
            //         return Ext.util.Format.number(value / 10000, '0,000.00####');
            //     },
            //     summaryType: 'sum',
            //     summaryRenderer: function (value) {
            //         return Ext.util.Format.number(value / 10000, '0,000.00####');
            //     }
            // },
            {dataIndex: "APPLY_DATE", type: "string", text: "申报日期"},
            {dataIndex: "BOND_TYPE_NAME", type: "string", text: "申请类型"}
        );
    }
    var grid = DSYGrid.createGrid({
        itemId: 'yyxmGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false,
            columnCls: 'normal'
        },
        flex: 1,
        dataUrl: url,
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_NAME: AG_NAME,
            BILL_YEAR: Ext.ComponentQuery.query('textfield[name="BILL_YEAR"]')[0].value,
            IS_FXJH: is_fxjh,
            is_zxzq: is_zxzq,
            ZQXM_TYPE: is_zxzq=='1'?'02':is_zxzq=='2'?'01':is_zxzq
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        height: '100%',
        width: '100%',
        pageConfig: {
            enablePage: false
        },
        dockedItems: [search_form],
        features: [{
            ftype: 'summary'
        }]
    });
    return grid;
}

/**
 * 加载已有项目新增页面数据
 * @param form
 */
function loadXzzq_Yyxm() {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('yyxmGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
        return;
    }
    var XM_ID = records[0].get("XM_ID");
    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    //获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    //获取投资计划页签表单
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    //获取收支平衡页签表单
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    jbqkForm.load({
        url: '/xzzqJhsb/loadXzzqYHS.action',
        params: {
            ID: '',
            XM_ID: XM_ID,
            isOld_szysGrid: isOld_szysGrid,
            is_fxjh: is_fxjh,
            is_zxzq: is_zxzq,
            IS_XMBCXX: IS_XMBCXX
        },
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            //加载基本情况页签表单
            // connNdjh = action.result.data.jbqkForm.CONNNDJH;
            // connZwxx = action.result.data.jbqkForm.CONNZWXX;
            jbqkForm.getForm().setValues(action.result.data.jbqkForm);
            if (IS_XMBCXX == '1') {
                bcxxForm.getForm().setValues(action.result.data.bcxxForm);
            }

            // 加载本次申报页签表格
            var bnsbStore = action.result.data.bnsbGrid;
            var bnsbGrid = DSYGrid.getGrid('bnsbGrid');
            bnsbGrid.getStore().removeAll();
            bnsbGrid.insertData(null, bnsbStore);

            // 加载“项目承建企业”页签表格
            if (is_fxjh == '1') {
                var xmcjqyStore = action.result.data.xmcjqyGrid;
                var xmcjqyGrid = DSYGrid.getGrid('xmcjqyGrid');
                xmcjqyGrid.getStore().removeAll();
                xmcjqyGrid.insertData(null, xmcjqyStore);
            }

            // 加载投资计划页签表格
            var tzjhStore = action.result.data.tzjhGrid;
            var tzjhGrid = DSYGrid.getGrid('tzjhGrid');
            tzjhGrid.getStore().removeAll();
            tzjhGrid.insertData(null, tzjhStore);
            initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
            if (tzjhGrid.getStore().getCount() > 0) {
                DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
                    if (record.get("RZZJ_ACTUAL_AMT") <= 0) {
                        var RZZJ_XJ = record.get("RZZJ_YBZQ_AMT") + record.get("RZZJ_ZXZQ_AMT") + record.get("RZZJ_ZHZQ_AMT");
                        record.set("RZZJ_ACTUAL_AMT", RZZJ_XJ);
                    }
                });
            }
            // var ZBJ_AMT = action.result.data.jbqkForm.ZBJ_AMT;
            // var ZBJ_ZQ_AMT = action.result.data.jbqkForm.ZBJ_ZQ_AMT;
            // var ZBJ_YS_AMT = action.result.data.jbqkForm.ZBJ_YS_AMT;
            // tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').setValue(ZBJ_AMT);
            // tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').setValue(ZBJ_ZQ_AMT);
            // tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').setValue(ZBJ_YS_AMT);
            //加载收支平衡页签表格
            if (isOld_szysGrid == '1') {
                var xmsyStore = action.result.data.xmsyGrid;
                for (var i = 0; i < xmsyStore.length; i++) {
                    xmsyStore[i].TOTAL_AMT = xmsyStore[i].YYSR_AMT + xmsyStore[i].CZBZ_AMT + xmsyStore[i].ZCBX_AMT + xmsyStore[i].QT_AMT;
                    xmsyStore[i].YSCB_HJ_AMT = xmsyStore[i].XM_YY_AMT + xmsyStore[i].ZJFY_AMT + xmsyStore[i].LXZC_AMT + xmsyStore[i].SFZC_AMT + xmsyStore[i].HBZC_AMT;
                }
                var xmsyGrid = DSYGrid.getGrid('xmsyGrid');
                xmsyGrid.getStore().removeAll();
                xmsyGrid.insertData(null, xmsyStore);
                if (xmsyStore && xmsyStore.length > 0) {
                    xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').setValue(typeof xmsyStore[0].ZFXJJKM_ID == 'undefined' ? '' : xmsyStore[0].ZFXJJKM_ID);
                    xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue(typeof xmsyStore[0].XM_USED_DATE == 'undefined' ? '' : xmsyStore[0].XM_USED_DATE);
                    xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').setValue(typeof xmsyStore[0].XM_USED_LIMIT == 'undefined' ? '' : xmsyStore[0].XM_USED_LIMIT);
                }
                initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
            }
            //设置基本情况页签不可编辑
            //var xmfj = DSYGrid.getGrid('window_zqxxtb_contentForm_tab_xmfj_grid_xeksb');
            jbqkForm.items.each(function (item1) {
                if (item1.items != undefined && item1.items != "" && item1.items != "null") {
                    item1.items.each(function (item2) {
                        if (item2.items != undefined && item2.items != "" && item2.items != "null") {
                            item2.items.each(function (item) {
                                if (item.name == 'BUILD_STATUS_ID'
                                    || item.name == 'START_DATE_ACTUAL'
                                    || item.name == 'END_DATE_ACTUAL'
                                    || item.name == 'YSXM_NO'
                                    || item.name == 'JYS_NO'
                                    || item.name == 'PF_NO'
                                    || item.name == 'BILL_PERSON'
                                    || item.name == 'BILL_PHONE'
                                    || item.name == 'BUILD_CONTENT'
                                    || item.name == 'UPPER_XM_ID'
                                    || item.name == (is_fxjh == 0 ? 'MB_ID' : 'null')
                                    || item.name == 'ZJTXLY_ID'
                                    || item.name == 'XMSY_YCYJ'
                                    || item.name == 'GK_PAY_XMNO'
                                    || item.name == 'GJZDZLXM_ID'
                                    || item.name == 'FGW_XMK_CODE'
                                    || item.name == 'SS_ZGBM_ID'
                                ) {
                                } else {
                                    if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
                                        SetItemReadOnly(item.items);
                                        SetFormItemsReadOnly(item.items);
                                    } else {
                                        if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                                            || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                                            || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                                            || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
                                        ) {
                                            return;
                                        }
                                        item.readOnly = true;
                                        item.editable = false;
                                        if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                                            item.fieldCls = 'form-unedit';
                                            if (item.getXType() == 'numberfield' || item.getXType() == 'numberFieldFormat') {
                                                item.fieldCls = 'form-unedit-number';
                                            }
                                        }
                                        if (item.setReadOnly && item.setFieldStyle) {
                                            item.setReadOnly(true);
                                            if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                                                item.setFieldStyle('background:#E6E6E6');
                                            }
                                        }
                                    }
                                    //20201218 fzd 发行库遴选项目时附件可补录信息（第三方单位名称等）
                                    //!!xmfj?xmfj.editable=false:'';
                                    /*if(item.name!=undefined) {
                                        item.setReadOnly(true);
                                        item.setFieldStyle('background:#E6E6E6');
                                        item.readOnly = true;
                                        item.fieldStyle = 'background:#E6E6E6';
                                        !!xmfj?xmfj.editable=false:'';
                                    }*/
                                }
                            });
                        }
                    });
                }
            });//LxdwRender();已有项目时不显示单位选项
            calculateRzzjAmount(tzjhGrid);  //计算  投资计划总结
            if (tab_items.length > 0) {
                //加载项目只读页签数据
                $.post('getJSXMInfo.action', {
                    XM_ID: XM_ID,
                    isOld_szysGrid: isOld_szysGrid,
                    tab_items: Ext.util.JSON.encode(tab_items)
                }, function (data) {
                    var dataJson = JSON.parse(data);
                    if (dataJson.success) {
                        // TODO xminfo.js 函数调用
                        //加载存量债务页签表格
                        setClzwxx(dataJson);
                        //加载项目资产页签
                        setXmzcxx(dataJson);
                        //加载招投标页签表格
                        setZtbxx(dataJson);
                        //加载建设进度页签表格
                        setJsjdxx(dataJson);
                        //加载实际收益页签表格
                        setSjsyxx(dataJson);
                    } else {
                        alert('加载失败');
                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                    }
                });
            }
        },
        failure: function (form, action) {
            alert('加载失败');
            Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
        }
    });
}


function getKmStoreLoad() {
    zwsrkm_store.load();
    zcgnfl_store.load();
    zcjjfl_store.load();
}

function upload_xzzm(form2, io_type, button_id) {
    var form = form2.getForm();
    var dataUrl = form.findField('upload').getValue();
    var arr = dataUrl.split('.');
    var fileType = arr[arr.length - 1].toLowerCase();
    if (fileType != 'rar' && fileType != 'zip') {
        Ext.MessageBox.alert('提示', '文件格式不正确！');
        form2.remove(button_id, true);
        if (io_type == 'xz') {
            form2.add(fileuploadbutton());
        } else if (io_type == 'yy') {
            form2.add(fileuploadbutton1());
        }

        return;
    }
    form.submit({
        clientValidation: false,
        url: '/import_file.action',
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        params: {
            wf_id: wf_id,
            node_code: node_code,
            button_status: button_status,
            button_name: button_name,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AD_NAME: userName_jbr,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            BOND_TYPE_ID: bond_type_id,
            IS_FXJH: is_fxjh,
            is_zxzq: is_zxzq,
            io_type: io_type
        },
        success: function (form, action) {
            Ext.MessageBox.show({
                title: '提示',
                msg: '导入成功',
                maxWidth: 400,
                minWidth: 200,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
            reloadGrid();
        },
        failure: function (form, action) {
            Ext.MessageBox.show({
                title: '提示',
                msg: '导入失败！<br>' + (action.result.message ? action.result.message : ''),
                maxWidth: 550,
                minWidth: 200,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
            reloadGrid();
        }

    });
    reloadGrid();

}

/**
 * 刷新已有项目表格
 */
function reloadYyxmGrid() {
    var YYXM_MHCX = Ext.ComponentQuery.query('textfield[name="YYXM_MHCX"]')[0].value;
    var YYXM_XMXZ_ID = Ext.ComponentQuery.query('treecombobox[name="YYXM_XMXZ_ID"]')[0].value;
    var YYXM_XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="YYXM_XMLX_ID"]')[0].value;
    var YYXM_BUILD_STATUS_ID = Ext.ComponentQuery.query('combobox[name="YYXM_BUILD_STATUS_ID"]')[0].value;
    var BILL_YEAR = Ext.ComponentQuery.query('textfield[name="BILL_YEAR"]')[0].value;
    var SB_BATCH_NO = Ext.ComponentQuery.query('treecombobox[name="SB_BATCH_NO"]')[0].value;
    var IS_CXSB = Ext.ComponentQuery.query('checkbox[name="IS_CXSB"]')[0].value;
    var SF_FZ = Ext.ComponentQuery.query('combobox[name="SF_FZ"]')[0].value;
    var grid = DSYGrid.getGrid('yyxmGrid');
    var store = grid.getStore();
    //增加查询参数
    store.getProxy().extraParams["YYXM_MHCX"] = YYXM_MHCX;
    store.getProxy().extraParams["YYXM_XMXZ_ID"] = YYXM_XMXZ_ID;
    store.getProxy().extraParams["YYXM_XMLX_ID"] = YYXM_XMLX_ID;
    store.getProxy().extraParams["YYXM_BUILD_STATUS_ID"] = YYXM_BUILD_STATUS_ID;
    store.getProxy().extraParams["BILL_YEAR"] = BILL_YEAR;
    store.getProxy().extraParams["SB_BATCH_NO"] = SB_BATCH_NO;
    store.getProxy().extraParams["IS_CXSB"] = IS_CXSB;
    store.getProxy().extraParams["sf_fz"] = SF_FZ;
    //刷新
    store.loadPage(1);
}

// TODO 只读函数 后续迁移至公共js
/**
 * 遍历form表单项，修改子级为只读项
 * @param Items
 * @constructor
 */
function SetItemReadOnly(Items) {

    Items.each(function (item, index, length) {
        if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
            SetItemReadOnly(item.items);
        } else {
            if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
            ) {
                return;
            }
            item.readOnly = true;
            item.editable = false;
            if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                item.fieldCls = 'form-unedit';
                if (item.getXType() == 'numberfield' || item.getXType() == 'numberFieldFormat') {
                    item.fieldCls = 'form-unedit-number';
                }
            }
        }
    });
}

function SetFormItemsReadOnly(Items) {
    Items.each(function (item) {
        if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
            SetFormItemsReadOnly(item.items);
        } else {
            if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
            ) {
                return;
            }
            //防止某些控件不支持setReadOnly
            if (item.setReadOnly && item.setFieldStyle) {
                item.setReadOnly(true);
                if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                    item.setFieldStyle('background:#E6E6E6');
                }
            }
        }
    });
}

//创建债券信息填报弹出窗口
var window_zqxxtb = {
    window: null,
    show: function (tab_items, title) {
        this.window = initWindow_zqxxtb(tab_items, title);
        this.window.show();
        var i = findTabName('基本情况');
        if ("0" == is_fxjh) {
            i = findTabName('收支预算');
        }
        zqxxtbTab(i);
    }
};

/**
 * 初始化债券信息填报弹出窗口
 */
function initWindow_zqxxtb(tab_items, title) {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_zqxxtb', // 窗口标识
        name: 'xzzqWin',
        title: title, // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.95, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_zqxxtb_contentForm(tab_items),
        buttons: [
            {
                xtype: 'button',
                itemId: 'lxcs',
                text: '利息测算',
                hidden: true,
                handler: function (btn) {
                    szysFx();
                }

            },
            {
                xtype: 'button',
                itemId: 'mbxz',
                text: '模板下载',
                hidden: true,
                handler: function (btn) {
                    szysExcelDown();//收支平衡表格模板下载
                }
            },
            {
                xtype: 'button',
                text: '导入',
                itemId: "import",
                name: 'upload',
                fileUpload: true,
                hidden: true,
                buttonOnly: true,
                hideLabel: true,
                buttonConfig: {
                    width: 140,
                    icon: '/image/sysbutton/report.png'
                },
                handler: function (btn) {
                    var xmsyForm = Ext.ComponentQuery.query(formName)[0];
                    //获取运行年限
                    var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
                    if (yyqx == "" || yyqx == undefined) {
                        Ext.MessageBox.alert('提示', "请先填写项目期限!");
                        return false;
                    }
                    window_xekjdr.show({TITLE: '请导入收支平衡表数据', DR_TYPE: '0'});//收支平衡表格模板下载
                }
            },
            {
                xtype: 'button',
                itemId: 'tbsm',
                hidden: true,
                text: '填报说明',
                handler: function (btn) {
                    window.open('/page/debt/common/ystbsmText.jsp');
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    submitXzzq(btn);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    getKmJcsj((is_fxjh == 1) ? SET_YEAR : SET_YEAR + 1, true);
                    btn.up('window').close();
                }
            }
        ]
    });
}


//收支平衡模板下载
function szysExcelDown() {
    window.location.href = 'downExcel.action?file_name=' + encodeURI(encodeURI("收支预算表格模板.xls"));
}


function initWindow_xekjdr(config) {
    return Ext.create('Ext.window.Window', {
        title: config.TITLE,
        width: document.body.clientWidth * 0.4,
        height: document.body.clientHeight * 0.4,
        layout: {
            type: 'fit'
        },
        //maximizable:true,//最大最小化
        modal: true,
        closeAction: 'destroy',
        buttonAlign: 'right',
        items: initxekjdatadrform(config),
    });
}

//初始化导入名录信息form
function initxekjdatadrform(config) {
    return Ext.create('Ext.form.Panel', {
        labelWidth: 70,
        fileUpload: true,
        defaultType: 'textfield',
        layout: 'anchor',
        items: [
            {
                xtype: 'container',
                layout: 'anchor',
                anchor: '100% 100%',
                defaultType: 'textfield',
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                defaults: {
                    margin: '2 5 2 5',
                    //width: 315,
                    fontSize: 20,
                    labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: 'displayfield',
                        fieldLabel: '<span class="required">✶</span>注意事项',
                        margin: '2 5 2 5',
                        anchor: '100% 10%'
                    },
                    {
                        xtype: 'textarea',
                        multiline: true,
                        name: '',
                        editable: false,
                        readOnly: true,
                        anchor: '100% 60%',
                        border: true,
                        fieldStyle: 'background:#E6E6E6',
                        value: '1.导入的Excel文件最大不可超过20M。\n\n' +
                            '2.不可删除Excel中固定的数据列，否则会造成数据错乱。\n\n' +
                            '3.导入年数应与项目期限保持同步!'
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        anchor: '100%',
                        border: true
                    },
                    {
                        xtype: 'filefield',
                        fieldLabel: '请选择文件',
                        name: 'upload',
                        anchor: '100% 30%',
                        msgTarget: 'side',
                        allowBlank: true,
                        margin: '5 5 2 5',
                        width: 70,
                        height: 30,
                        labelWidth: 80,
                        buttonConfig: {
                            width: 100,
                            height: 25,
                            text: '预览',
                            icon: '/image/sysbutton/report.png'
                        }
                    }
                ]
            }
        ],
        buttons: [
            {
                xtype: 'button',
                text: '上传',
                name: 'upload',
                handler: function (btn) {
                    var form = this.up('form').getForm();
                    var file = form.findField('upload').getValue();
                    if (file == null || file == '') {
                        Ext.Msg.alert('提示', '请选择文件！');
                        return;
                    } else if (!(file.endWith('.xls') || file.endWith('.xlsx'))) {
                        Ext.Msg.alert('提示', '请选择Excel类型文件！');
                        return;
                    }
                    if (form.isValid()) {
                        upLoadExcel(form, btn);
                    }
                }
            },
            {
                xtype: 'button',
                text: '取消',
                name: 'cancel',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

// 上传函数
function upLoadExcel(form, btn) {
    var xmsyForm = Ext.ComponentQuery.query(formName)[0];
    //获取运行年限
    var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
    var url = '/importExcel_szys.action';
    form.submit({
        url: url,
        params: {
            "yyqx": yyqx
        },
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        success: function (form, action) {
            var columnStore = action.result.list;
            var grid = DSYGrid.getGrid('xmsyGrid');
            grid.getStore().removeAll();
            grid.insertData(null, columnStore);
            btn.up('window').close();
            updateZjeSqje();
            editLoad(grid, false);
        },
        failure: function (resp, action) {
            var msg = action.result.data.message;
            Ext.MessageBox.show({
                title: '提示',
                msg: '导入失败:' + msg,
                width: 200,
                fn: function (btn) {
                }
            });
        }
    });
}

function submitXzzq(btn) {
    // 重设金额
    updateZjeSqje();
    //获取基本情况页签表单
    var jbqkForm = getSaveZqxmJbqkForm();
    // 获取补充信息页签表单
    var bcxxForm = getSaveZqxmBcxxForm(IS_XMBCXX);
    //获取本次申报页签表单
    var bnsbForm = !!jbqkForm ? getSaveZqxmBcsbForm(is_fxjh, jbqkForm) : false;
    //获取投资计划页签表单
    var tzjhForm = getSaveZqxmTzjhForm();
    //获取投资计划页签下部表格
    // var tzjhGrid = !!bnsbForm ? getSaveZqxmTzjhGrid(is_fxjh, bnsbForm) : false;
    // 项目承建企业
    var xmcjqyGrid = getSaveZqxmXmcjqyForm(is_fxjh);
    //获取收支平衡页签表单
    var xmsy = !!bnsbForm ? getSaveZqxmSzphForm(isOld_szysGrid, IS_XMBCXX, is_tdcb, bnsbForm) : false;
    var xmsyForm = xmsy.xmsyForm;
    var xmsyGrid = xmsy.xmsyGrid;

    if (!jbqkForm || !bcxxForm || !bnsbForm || !tzjhForm || !xmcjqyGrid || !xmsyForm || !xmsyGrid) {
        return false;
    }
    var tzjhGrid = [];
    //获取绩效情况页签表单
    var jxqkForm = {};
    //绩效情况
    var jxqkGrid = [];
    //获取固定资产页签表格
    var gdzcGrid = [];
    //湖北十大工程校验
    var sdgcGrid=[];
    DSYGrid.getGrid("sdgcGrid").getStore().each(function (record) {
        if (record.get('GCLB_ID') == null || record.get('GCLB_ID') == '' || record.get('GCLB_ID') == 'undefined') {
            message_error = is_show?"请选择十大工程页签“工程类别”列":"请选择项目特征页签“项目特征”列";
            return false;
        }
        sdgcGrid.push(record.getData());
    });
    //反写 根据项目资本金 反写 是否用于资本金
    setBcsbYCXX(bnsbForm);
    //反写 投资计划 项目总概算
    setJbxxYCXX(jbqkForm, xmsyGrid);

    var TZJH_XMZGS_AMT = tzjhForm.getForm().findField("XMZGS_AMT").getValue();
    //发送ajax请求，提交数据
    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    if (IS_XMBCXX == '1') {
        var params = {
            is_zxzq: is_zxzq,
            wf_id: wf_id,
            node_code: node_code,
            menucode: menucode,
            button_name: button_name,
            button_status: button_status,
            ID: window_zqxxtb.JH_ID,
            XM_ID: window_zqxxtb.XM_ID,
            HAVE_SFJG: HAVE_SFJG,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            BOND_TYPE_ID: bond_type_id,
            IS_FXJH: is_fxjh,
            node_type: node_type,
            is_fdq: is_fdq,
            isOld_szysGrid: isOld_szysGrid,
            IS_XMBCXX: IS_XMBCXX,
            jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
            bnsbForm: encode64('[' + Ext.util.JSON.encode(bnsbForm.getValues()) + ']'),
            bcxxForm: encode64('[' + Ext.util.JSON.encode(bcxxForm.getValues()) + ']'),
            tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues()) + ']'),
            xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
            xmcjqyGrid: encode64(Ext.util.JSON.encode(xmcjqyGrid)),
            tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
            xmsyGrid: encode64(Ext.util.JSON.encode(xmsyGrid)),
            jxqkForm: encode64('[' + Ext.util.JSON.encode(jxqkForm) + ']'),
            jxqkGrid: encode64(Ext.util.JSON.encode(jxqkGrid)),
            gdzcGrid: encode64(Ext.util.JSON.encode(gdzcGrid)),
            sdgcGrid:encode64(Ext.util.JSON.encode(sdgcGrid))

        };
    } else {
        var params = {
            is_zxzq: is_zxzq,
            wf_id: wf_id,
            node_code: node_code,
            menucode: menucode,
            button_name: button_name,
            button_status: button_status,
            ID: window_zqxxtb.JH_ID,
            XM_ID: window_zqxxtb.XM_ID,
            HAVE_SFJG: HAVE_SFJG,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            BOND_TYPE_ID: bond_type_id,
            IS_FXJH: is_fxjh,
            node_type: node_type,
            is_fdq: is_fdq,
            isOld_szysGrid: isOld_szysGrid,
            jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
            bnsbForm: encode64('[' + Ext.util.JSON.encode(bnsbForm.getValues()) + ']'),
            tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues()) + ']'),
            xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
            xmcjqyGrid: encode64(Ext.util.JSON.encode(xmcjqyGrid)),
            tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
            xmsyGrid: encode64(Ext.util.JSON.encode(xmsyGrid)),
            jxqkForm: encode64('[' + Ext.util.JSON.encode(jxqkForm) + ']'),
            jxqkGrid: encode64(Ext.util.JSON.encode(jxqkGrid)),
            gdzcGrid: encode64(Ext.util.JSON.encode(gdzcGrid)),
            sdgcGrid:encode64(Ext.util.JSON.encode(sdgcGrid))
        }
    }
    $.post('/xzzqJhsb/checkSaveXzzqYHS.action', {
        AD_CODE: AD_CODE,
        IS_FXJH: is_fxjh,
        is_zxzq: is_zxzq,
        XM_ID: window_zqxxtb.XM_ID,
        button_status: button_status,
        bnsbForm: Ext.util.JSON.encode([bnsbForm.getValues()]),
        tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
        sdgcGrid:encode64(Ext.util.JSON.encode(sdgcGrid))
    }, function (data) {
        if (data.success) {
            //20201217 fzd 保存附件信息
            UploadPanel.saveExtraField('window_zqxxtb_contentForm_tab_xmfj_grid_xeksb', false);
            if (TZJH_XMZGS_AMT > 2000000) {
                Ext.onReady(function () {
                    Ext.MessageBox.show({
                        title: "提示",
                        msg: "投资计划页签中项目总概算金额超过200亿！",
                        fn: function (id, msg) {
                            if (id == "ok") {
                                $.post('/xzzqJhsb/saveXzzqYHS.action', params, function (data) {
                                    if (data.success) {
                                        Ext.toast({html: "保存成功！"});
                                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                                        getKmJcsj((is_fxjh != 1 && is_fxjh != 4 && is_fxjh != 3) ? SET_YEAR : SET_YEAR + 1, true);
                                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                                    } else {
                                        Ext.MessageBox.alert('提示', data.message);
                                        btn.setDisabled(false);
                                    }
                                    //刷新表格
                                }, "json");
                            } else {
                                btn.setDisabled(false);
                            }
                        },
                        buttons: Ext.Msg.OKCANCEL,
                    });
                });
            } else {
                $.post('/xzzqJhsb/saveXzzqYHS.action', params, function (data) {
                    if (data.success) {
                        Ext.toast({html: "保存成功！"});
                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                        getKmJcsj((is_fxjh != 1 && is_fxjh != 4 && is_fxjh != 3) ? SET_YEAR : SET_YEAR + 1, true);
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    } else {
                        Ext.MessageBox.alert('提示', data.message);
                        btn.setDisabled(false);
                    }
                    //刷新表格
                }, "json");
            }
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, "json");
}

// 根据资本金设置是否用于项目资本金
function setBcsbYCXX(bnsbForm) {
    var ZBJ_AMT = bnsbForm.getForm().findField('ZBJ_AMT').getValue();
    var IS_XMZBJ = bnsbForm.getForm().findField('IS_XMZBJ');

    if (ZBJ_AMT > 0) {
        IS_XMZBJ.setValue(1);
    } else {
        IS_XMZBJ.setValue(0);
    }
}

// 根据收支预算 反写项目总概算
function setJbxxYCXX(jbqkForm, xmsyGrid) {
    var XMZGS_AMT = jbqkForm.getForm().findField('XMZGS_AMT');
    if (!!xmsyGrid[0] && !!xmsyGrid[0].SRAMT_Y) {
        XMZGS_AMT.setValue(parseFloat(xmsyGrid[0].SRAMT_Y));
    }
}

/**
 * 比较实际竣工日期与当前时间
 */
function compareNowDateActualDate(form) {
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    END_DATE_ACTUAL = Ext.util.Format.date(END_DATE_ACTUAL, 'Y-m-d');
    if (END_DATE_ACTUAL && END_DATE_ACTUAL > nowDate) {
        return false;
    }
    return true;
}

/**
 * 当已完工或已竣工时，开工及竣工时间不能为空校验
 */
function compareBuildActualDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    var BUILD_STATUS_ID = form.down('[name=BUILD_STATUS_ID]').getValue();
    if ((BUILD_STATUS_ID == '03' || BUILD_STATUS_ID == '04') &&
        (START_DATE_ACTUAL == null || START_DATE_ACTUAL == '' || END_DATE_ACTUAL == null || END_DATE_ACTUAL == '')) {
        return false;
    }
    return true;
}