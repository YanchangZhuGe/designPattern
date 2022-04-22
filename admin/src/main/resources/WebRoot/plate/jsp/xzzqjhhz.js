/**
 * js：新增债券项目汇总
 * Created by djl on 2016/7/6.
 */
/*var BATCH = '1'; //批次
 var IS_SUM_BY_FXFS = ''; //系统参数：是否必选发行方式
 $.ajax({
 type: "POST",
 url: 'getParamValueAll.action',
 async: false, //设为false就是同步请求
 cache: false,
 success: function (data) {
 data = eval(data);
 IS_SUM_BY_FXFS = data[0].IS_SUM_BY_FXFS;
 }
 });*/
/**
 * 默认数据：工具栏
 */
var userAdCode = (AD_CODE.length == 2 || USER_AD_CODE.length == 4) && !USER_AD_CODE.endWith("00") ? USER_AD_CODE.concat("00") : USER_AD_CODE;
AD_CODE = userAdCode;
$.extend(zqxm_json_common, {
    items: {
        '001': [
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
                text: '汇总',
                name: 'add',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    button_status = btn.name;
                    button_name = btn.text;
                    //校验是否选中区划叶子节点
                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_area')[0];
                    var tree_selected = tree_area.getSelection();
                    if (tree_selected == null || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                        Ext.MessageBox.alert('提示', '请选择一个底级区划再进行操作');
                        return false;
                    }
                    AD_CODE = tree_selected[0].get('code');
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条明细数据再进行操作');
                        return false;
                    }
                    var year = null;
                    var bond_type_id = null;
                    var current_year = null;
                    for (var i in records) {
                        if (bond_type_id == null) {
                            bond_type_id = (records[i].get('BOND_TYPE_ID'));
                        } else if (bond_type_id.substr(0, 2) != (records[i].get('BOND_TYPE_ID')).substr(0, 2)) {
                            Ext.MessageBox.alert('提示', '汇总数据必须是同一债券申请类型！');
                            return false;
                        }
                        if (year == null) {
                            year = parseInt(records[i].get('BILL_YEAR'));
                        } else if (year != parseInt(records[i].get('BILL_YEAR'))) {
                            Ext.MessageBox.alert('提示', '汇总数据必须是同一年度！');
                            return false;
                        }
                    }
                    /*from DEBT_T_ZQGL_BILL_XZHZ where AD_CODE like \'"+AD_CODE+"\' and IS_FXJH like \'"+is_fxjh+"\'   and BATCH_NO \= GUID\)*/
                    /*var querys= " AND not exists \(  count\(1\)  ";
                    current_year="\'"+records[0].get('BILL_YEAR')+"\'"+querys;*/
                    xzhzSbpc(year, bond_type_id);
                    initWindow_sbpc(year, bond_type_id);
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("ID"), sys_right_model == '1' ? 'BRANCH' : '');
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
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
                text: '取消汇总',
                name: 'cancel',
                icon: '/image/sysbutton/undosum.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否取消汇总！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            var ids = [];
                            for (var i in records) {
                                ids.push(records[i].get("HZ_ID"));
                            }
                            //发送ajax请求，校验期间是否被锁定
                            $.post("/checkZqxmXzzqHzGrid_cxsb.action", {
                                HZ_IDS: ids,
                                IS_FXJH: is_fxjh
                            }, function (data) {
                                if (data.success) {
                                    //发送请求修改汇总单信息，并修改明细表状态信息
                                    $.post('updateZqxmXzzqHzGrid_Hz.action', {
                                        button_name: button_name,
                                        AD_CODE: AD_CODE,
                                        IS_FXJH: is_fxjh,
                                        IDS: ids
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({
                                                html: button_name + "成功！" + (data.message ? data.message : ''),
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                        } else {
                                            Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
                                        }
                                        //刷新债券表和限额表
                                        var store = DSYGrid.getGrid('contentHZGrid').getStore();
                                        store.getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                                        store.loadPage(1);
                                        DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
                                    }, 'json');
                                } else {
                                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                }
                            }, "json");
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '汇总表',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {

                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    var hz_ids = '';
                    var fxpc_name = records[0].get('FXPC_NAME');
                    for (var i in records) {

                        if (records[i].get('FXPC_NAME') != fxpc_name) {
                            Ext.MessageBox.alert('提示', '请选择同一批次号的数据！');
                            return;
                        }

                        if (hz_ids != null && hz_ids != '') {
                            hz_ids = hz_ids + ',';
                        }
                        hz_ids = hz_ids + '' + records[i].get("HZ_ID") + '';
                    }
                    var hrefUrl = reportUrl + '/WebReport/ReportServer?reportlet=czb_dz%2F04_xegl%2FDEBT_XM_ZJSQ_HZ.cpt&HZ_IDS=' + encodeURIComponent(hz_ids);
                    if (FR_DEPLOYMENT_MODE == '1') {
                        hrefUrl = hrefUrl.replaceAll("/WebReport", "");
                    }
                    var a = (window.open(hrefUrl));
                }
            },
            {
                xtype: 'button',
                text: '汇总表2',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentHZGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    var hz_ids = '';
                    var fxpc_name = records[0].get('FXPC_NAME');
                    for (var i in records) {
                        if (records[i].get('FXPC_NAME') != fxpc_name) {
                            Ext.MessageBox.alert('提示', '请选择同一批次号的数据！');
                            return;
                        }
                        if (hz_ids != null && hz_ids != '') {
                            hz_ids = hz_ids + ',';
                        }
                        hz_ids = hz_ids + '' + records[i].get("HZ_ID") + '';
                    }
                    var AD_LEVEL = records[0].get('AD_LEVEL');
                    var batch_no = records[0].get('BATCH_NO');
                    var nd = records[0].get('FXPC_YEAR');
                    var hrefUrl = reportUrl + '/WebReport/ReportServer?reportlet=czb_dz%2F04_xegl%2FDEBT_XM_XZZQXM_HZ.cpt&HZ_IDS=' + hz_ids + '&Batch_No=' + batch_no + '&ND=' + nd + '&AD_CODE=' + AD_CODE + '&AD_LEVEL=' + AD_LEVEL + '&IS_FXJH=' + is_fxjh;
                    if (FR_DEPLOYMENT_MODE == '1') {
                        hrefUrl = hrefUrl.replaceAll("/WebReport", "");
                    }
                    var a = (window.open(hrefUrl));
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                    if (!record) {
                        Ext.toast({html: '请选择明细数据!'});
                        return false;
                    }
                    fuc_getWorkFlowLog(record.get("ID"), sys_right_model == '1' ? 'BRANCH' : '');
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    },
    items_content_rightPanel_items: function () {
        return [
            initContentGridHZ()
        ]
    },
    item_content_grid_config: {
        params: {
            is_fxjh: is_fxjh,
            AD_CODE: AD_CODE,
            node_type: node_type,
            STATUS: '20',
            IS_ZXZQXT: is_zxzqxt,
            IS_ZXZQ: is_zxzq
        },
        autoLoad: true,
        width: '100%',
        height: '50%',
        dataUrl: '/getXzzqContentGrid.action',
        pageConfig: {
            pageNum: true
        },
        tbar: [
            {
                xtype: 'displayfield',
                fieldLabel: '当前已汇总金额(万元)',
                name: 'je_sum',
                itemId: 'je_sum',
                value: 0,
                labelWidth: 135,//控件默认标签宽度
                labelAlign: 'left'//控件默认标签对齐方式
            }
        ],
        listeners: {
            selectionchange: function (view, records) {
                var sum = 0;
                for (var i in records) {
                    sum += records[i].get("APPLY_AMOUNT1");
                }
                //sum = sum / 10000;
                sum = Ext.util.Format.number(sum, '0,000.00');
                Ext.ComponentQuery.query('displayfield#je_sum')[0].setValue(sum);
            }
        }
    },
    reloadGrid: function () {
        var store = null;
        if (WF_STATUS == '001') {
            store = DSYGrid.getGrid('contentGrid').getStore();
        } else if (WF_STATUS == '002') {
            store = DSYGrid.getGrid('contentHZGrid').getStore();
            DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
        }
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.loadPage(1);
    }
});
/**
 * 初始化弹出框：汇总选择申报批次
 */

/*function DebtEleStoreDB2(year,debtEle, params) {
    var extraParams = {};
    if (typeof params == 'object') {
        extraParams = params;
    }
    var debtStoreDB = new Ext.data.ArrayStore({
        autoLoad: false,
        fields: ['id', 'code', 'name','year'],
        sorters: [{
            property: 'code',
            direction: 'asc'
        }],
        proxy: {
            type: 'ajax',
            url: 'getDATAHZ.action?AD_CODE='+AD_CODE+'&is_fxjh='+is_fxjh+'&year='+year+'',
            param:{
                AD_CODE:AD_CODE,
                is_fxjh:is_fxjh,
                year:year
            },
            //extraParams: extraParams,
            reader: {
                type: 'json',
                root: 'list'
            }
        }
    });
    return debtStoreDB;
}*/
function xzhzSbpc(year, bond_type_id) {
    sbpc_store.proxy.extraParams['BATCH_YEAR'] = year;
    sbpc_store.proxy.extraParams['BOND_TYPE'] = bond_type_id.substr(0, 2);
    sbpc_store.proxy.extraParams['AD_CODE'] = AD_CODE;
    sbpc_store.proxy.extraParams['is_fxjh'] = is_fxjh == '1' ? "1" : "0";
    sbpc_store.proxy.extraParams['TYPE'] = 'xzhz';
    sbpc_store.load();
}

function initWindow_sbpc(year, bond_type_id) {
    Ext.create('Ext.window.Window', {
        itemId: 'window_sbpc', // 窗口标识
        title: '请选择申报批次', // 窗口标题
        width: 300, //自适应窗口宽度
        height: 150, //自适应窗口高度
        layout: {
            type: 'hbox',
            padding: '10',
            align: 'middle'
        },
        y: document.body.clientHeight * 0.3,
        buttonAlign: 'center', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [
            {
                xtype: 'treecombobox',
                fieldLabel: '申报批次',
                name: 'BATCH_NO',
                displayField: 'text',
                valueField: 'id',
                editable: false,
                allowBlank: false,
                flex: 1,
                width: 160,
                autoLoad: false,
                selectModel: "leaf",
                labelWidth: 60,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                store: sbpc_store
            }
        ],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var sbpc = btn.up('window').down('treecombobox[name=BATCH_NO]').getValue();
                    if (sbpc == null || sbpc == '') {
                        Ext.Msg.alert('提示', "请选择申报批次");
                        return false;
                    }
                    //汇总数据年度校验
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    var ids = [];
                    var xmids = [];
                    var year = null;
                    var bond_type_id = null;
                    var xm_id = null;
                    for (var i in records) {
                        if (bond_type_id == null) {
                            bond_type_id = (records[i].get('BOND_TYPE_ID'));
                        } else if (bond_type_id.substr(0, 2) != (records[i].get('BOND_TYPE_ID')).substr(0, 2)) {
                            Ext.MessageBox.alert('提示', '汇总数据必须是同一债券底级申请类型！');
                            return false;
                        }
                        if (year == null) {
                            year = parseInt(records[i].get('BILL_YEAR'));
                        } else if (year != parseInt(records[i].get('BILL_YEAR'))) {
                            Ext.MessageBox.alert('提示', '汇总数据必须是同一年度！');
                            return false;
                        }
                        //20201215 fzd 同一批次不能汇总相同的项目
                        if (xm_id == null) {
                            xm_id = records[i].get('XM_ID');
                        } else if (xm_id == records[i].get('XM_ID')) {
                            Ext.MessageBox.alert('提示', '同一批次下不能汇总相同项目！');
                            return false;
                        }
                        ids.push(records[i].get("ID"));
                        xmids.push(records[i].get("XM_ID"));
                    }
                    //获取汇总金额
                    var apply_amount = Ext.ComponentQuery.query('displayfield#je_sum')[0].getValue().replaceAll(',', '');
                    apply_amount = parseFloat(apply_amount) * 10000;
                    //发送请求新增汇总单信息，并修改明细表状态信息
                    btn.setDisabled(true);
                    $.post('/saveZqxmXzzqHzGrid.action', {
                        BATCH_NO: sbpc,
                        AD_CODE: AD_CODE,
                        IS_FXJH: is_fxjh,
                        APPLY_AMOUNT: apply_amount,
                        IDS: ids,
                        XMIDS: xmids,
                        IS_ZXZQ: is_zxzq
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！" + (data.message ? data.message : ''),
                                closable: false, align: 't', slideInDuration: 400, minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
                        }
                        //刷新债券表和限额表
                        reloadGrid();
                        btn.setDisabled(false);
                        btn.up('window').close();
                    }, 'json');
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}

/**
 * 初始化主页面页签Panel
 * @return {Ext.tab.Panel}
 */
function initContentGridHZ() {
    return Ext.create('Ext.tab.Panel', {
        name: 'HzTabPanel',
        layout: 'fit',
        flex: 1,
        border: false,
        defaults: {
            layout: 'fit',
            border: false
        },
        items: [
            {title: '未汇总', opstatus: 0, items: initContentGrid()},
            {title: '已汇总', opstatus: 1, layout: 'vbox', items: [initContentHZGrid(), initContentGrid_detail()]}
        ],
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                toolbar.removeAll();
                if (newCard.opstatus == '0') {
                    WF_STATUS = '001';
                } else if (newCard.opstatus == '1') {
                    WF_STATUS = '002';
                }
                reloadGrid();
                toolbar.add(zqxm_json_common.items[WF_STATUS]);

            }
        }
    });
}

/**
 * 初始化已汇总页签主表格:汇总单表
 */
function initContentHZGrid() {
    var headerJson = HEADERJSON_HZ;
    return DSYGrid.createGrid({
        itemId: 'contentHZGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: false,
        width: '100%',
        flex: 1,
        params: {
            is_fxjh: is_fxjh,
            AD_CODE: AD_CODE,
            IS_ZXZQXT: is_zxzqxt,
            IS_ZXZQ: is_zxzq
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: '/getZqxmXzzqHzGridForYhz.action',
        pageConfig: {
            pageNum: true
        },
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    });
}

/**
 * 汇总单明细表
 */
function initContentGrid_detail() {
    var headerJson = HEADERJSON;
    var config = {
        itemId: 'contentGrid_detail',
        flex: 1,
        width: '100%',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        checkBox: false,
        border: true,
        autoLoad: false,
        pageConfig: {
            //pageNum: true//设置显示每页条数
            enablePage: false
        },
        dataUrl: '/getZqxmXzzqContentGrid_NoPage.action'
    };
    var contentGrid = DSYGrid.createGrid(config);
    /*contentGrid.getStore().on('load', function () {
        var self = contentGrid.getStore();
        for(var i=0;i<self.getCount();i++) {
            var record = self.getAt(i);
            var apply_amount1 = record.get("APPLY_AMOUNT1");
            record.set("APPLY_AMOUNT1", apply_amount1 / 10000);
            var apply_amount_total = record.get("APPLY_AMOUNT_TOTAL");
            record.set("APPLY_AMOUNT_TOTAL", apply_amount_total / 10000);
            var return_capital = record.get("RETURN_CAPITAL");
            record.set("RETURN_CAPITAL", return_capital / 10000);
            var xmzgs_amt = record.get("XMZGS_AMT");
            record.set("XMZGS_AMT", xmzgs_amt / 10000);
        }
    });*/
    return contentGrid;
}
