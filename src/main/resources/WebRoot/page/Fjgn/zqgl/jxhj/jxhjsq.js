var dqbj_amt = 0;
$.extend(json_common, {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '申请填报',
                name: 'add',
                icon: '/image/sysbutton/regist.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
                    is_fix = 0;
                    WbLx_is_fix = false;
                    $.post("/getId.action", function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //弹出弹出框，设置ID
                        bill_id_temp = data.data[0];
                        fxjh_choose_zq();
                    }, "json");
                }
            },
            {
                name: 'update',
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
                    is_fix = 1;
                    WbLx_is_fix = false;
                    changeMainGrid();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    delete_main_grid();
                }
            },
            {
                xtype: 'button',
                text: '送审',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow_jxhj();
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
        '002': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadMain();
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow_jxhj();
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
                    reloadMain();
                }
            },
            {
                name: 'update',
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_status = btn.name;
                    is_fix = 1;
                    WbLx_is_fix = false;
                    changeMainGrid();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    delete_main_grid();
                }
            },
            {
                xtype: 'button',
                text: '送审',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    doWorkFlow_jxhj();
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
                    reloadMain();
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
        ]
    },
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    },
    items_content_rightPanel_items: function () {
        return [
            initContentGrid(),
            initContentGrid_MX()
        ]
    }

});
var batch_no_store = DebtEleTreeStoreDB('DEBT_FXPC');
var zqlb_store = (is_zxzqxt == 1) ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: "AND CODE NOT LIKE '01%'"}) : DebtEleTreeStoreDB('DEBT_ZQLB');
var bill_id_temp = '';
var batch_no_store2 = DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND1 like '03%' OR EXTEND1 IS NULL) "});
batch_no_store2.loadPage(1);
/**
 * 表格中树下拉store
 */
var batch_no_store = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: '/store_getFxpcStore.action',
        extraParams: {},
        reader: {
            type: 'json'
        }
    },
    root: {
        expanded: true,
        text: "全部",
        children: [
            {text: "单位", id: "单位", leaf: true}
        ]
    },
    model: 'treeModel',
    autoLoad: true
});

function loadsbpc(form_value, dd) {
    var user_ad_code_temp = USER_AD_CODE;
    if (user_ad_code_temp != null && user_ad_code_temp != undefined && user_ad_code_temp.length < 6 && !user_ad_code_temp.endWith("00")) {
        user_ad_code_temp = user_ad_code_temp + "00";
    }
    var form = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
    var ss_temp = form.findField("BOND_TYPE_ID").getValue();
    var year = Ext.util.Format.date(form.findField("BILL_YEAR").getValue(), 'Y');
    form.findField("BATCH_NO").setStore(null);
    form.findField("BATCH_NO").setStore(batch_no_store);
    form.findField("BATCH_NO").getStore().getProxy().extraParams['year'] = year;
    form.findField("BATCH_NO").getStore().getProxy().extraParams['userAdCode'] = user_ad_code_temp;
    form.findField("BATCH_NO").getStore().getProxy().extraParams['ss_temp'] = ss_temp;
    form.findField("BATCH_NO").getStore().getProxy().extraParams['bill_id_temp'] = bill_id_temp;
    form.findField("BATCH_NO").getStore().getProxy().extraParams['is_fjx'] = is_fix;
    form.findField("BATCH_NO").getStore().loadPage(1);
}

function SetZqlx(record) {
    if (record != null && record != '' && record != undefined) {
        var sqlx = record.ZQLB_ID;
        var data_type = record.DATA_TYPE;
        var df_end_date = record.DF_END_DATE;
        var form = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
        if (form != null && form != undefined) {
            if (sqlx != null && sqlx != "" && sqlx != undefined) {
                if (data_type == 'ZW' && sqlx.length > 2) {
                    sqlx = sqlx.substring(2, 4);
                } else {
                    sqlx = sqlx.substring(0, 2);
                }
                form.findField("BOND_TYPE_ID").setValue(sqlx);
            }
            form.findField("JBR").setValue(userName_jbr);
            if (df_end_date != null && sqlx != "" && df_end_date != undefined) {
                if (df_end_date.length > 2) {
                    df_end_date = df_end_date.substring(0, 4);
                }
                form.findField("BILL_YEAR").setValue(df_end_date);
            }
            form.findField("BILL_ID").setValue(bill_id_temp);
            if (!WbLx_is_fix) {
                loadsbpc();
            }
        }

    }
}

function doWorkFlow_jxhj() {
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length < 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择至少一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else if (sm.length >= 1) {
        var bills = new Array();
        for (var i = 0; i < sm.length; i++) {
            var temp = new Object();
            temp['BILL_ID'] = sm[i].get("BILL_ID");
            bills.push(temp);
        }
        Ext.MessageBox.show({
            title: "提示",
            msg: "是否" + button_name + "?",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (buttonId) {
                if (buttonId === "ok") {
                    Ext.Ajax.request({
                        method: 'POST',
                        url: "/doUpdateWorkFlow.action",
                        params: {
                            AD_CODE: USER_AD_CODE,
                            USERCODE: USER_AD_CODE,
                            WF_ID: wf_id,
                            NODE_CODE: node_code,
                            BUTTON_NAME: button_name,
                            bills: Ext.util.JSON.encode(bills),
                            USER_NAME: userName_jbr,
                            USER_CODE: USER_CODE
                        },
                        async: false,
                        success: function (response, options) {
                            var respText = Ext.util.JSON.decode(response.responseText);
                            if (respText.success) {
                                toast_util(button_name, true);
                                reloadMain();
                            } else {
                                toast_util(button_name, false, respText);
                            }

                        },
                        failure: function (response, options) {
                        }
                    });
                }
            }
        });
    }
}

var is_fix = 0;
var default_zqlb = "01";
var default_zwlb = "01";

function changeMainGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length != 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else {
        var BILL_ID = sm[0].getData().BILL_ID;
        bill_id_temp = BILL_ID;
        changeSomeGrid(null);
    }
}


function getSingleData(BILL_ID) {
    var url = "selectSingleInfo.action?BILL_ID=" + BILL_ID;
    var v_temp_1;
    $.ajax({
        type: "POST",
        url: url,
        async: false, //设为false就是同步请求
        cache: false,
        success: function (data) {
            var dataInsert = $.parseJSON(data);
            v_temp_1 = dataInsert;
        }
    });
    return v_temp_1;
}


function changeSomeGrid(data) {
    var BILL_ID = "";
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length != 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else if (sm.length == 1) {
        BILL_ID = sm[0].getData().BILL_ID;
    }
    var win2 = Ext.ComponentQuery.query('window[itemId="window_dqzq_SURE"]');
    if (win2 == null || win2 == '' || win2 == undefined) {
        var url = "selectSingleInfo.action?BILL_ID=" + BILL_ID;
        var v_temp_1;
        $.ajax({
            type: "POST",
            url: url,
            async: false, //设为false就是同步请求
            cache: false,
            success: function (data2) {
                var dataInsert = $.parseJSON(data2);
                var data = dataInsert;
                var main_data = data.list[0];
                var dtl_data = data.list_dtl;
                var var$temp1 = main_data.BOND_TYPE_ID;
                dqzqsq_sure_window(var$temp1);
                var form_value = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
                form_value.findField("AD_NAME").setValue(main_data.AD_NAME);
                form_value.findField("APPLY_DATE").setValue(main_data.APPLY_DATE);
                form_value.findField("JBR").setValue(main_data.APPLY_INPUTOR);
                form_value.findField("BILL_YEAR").setValue(main_data.BILL_YEAR);
                form_value.findField("BOND_TYPE_ID").setValue(var$temp1);
                form_value.findField("REMARK").setValue(main_data.REMARK);
                form_value.findField("BILL_ID").setValue(main_data.BILL_ID);
                var grid_goal = DSYGrid.getGrid('dqzq_sure_zq');
                loadsbpc();
                form_value.findField("BATCH_NO").getStore().load({
                    callback: function () {
                        form_value.findField("BATCH_NO").setValue(main_data.BATCH_NO);
                    }
                });
                form_value.findField("BOND_TYPE_ID").getStore().load({
                    callback: function () {
                        form_value.findField("BOND_TYPE_ID").setValue(main_data.BOND_TYPE_ID);
                    }
                });
                grid_goal.getStore().insertData(null, dtl_data);
                setForm();
            }
        });
    } else {
        if (win2.length >= 1) {
            win2 = win2[0];
        }
    }
}

function delete_main_grid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length < 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择至少一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    } else if (sm.length >= 1) {
        var bills = new Array();
        for (var i = 0; i < sm.length; i++) {
            var temp = new Object();
            temp['BILL_ID'] = sm[i].get("BILL_ID");
            bills.push(temp);
        }
        Ext.MessageBox.show({
            title: "提示",
            msg: "是否" + button_name + "?",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            //animateTarget: btn,
            fn: function (buttonId) {
                if (buttonId === "ok") {
                    Ext.Ajax.request({
                        method: 'POST',
                        url: "/deleteMainGrid.action",
                        params: {
                            AD_CODE: USER_AD_CODE,
                            BILLS: Ext.util.JSON.encode(bills)
                        },
                        async: false,
                        success: function (response, options) {
                            var respText = Ext.util.JSON.decode(response.responseText);
                            if (respText.success) {
                                toast_util("删除", true);
                                reloadMain();
                            } else {
                                toast_util("删除", false, respText);
                            }
                        },
                        failure: function (response, options) {
                        }
                    });
                }
            }
        });
    }

}

function getBatchNo(sm) {
    var form = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0]
    if (form != null && form != undefined && form != "") {
        form = form.getForm();
    } else {
        return true;
    }
    if (form != null && form != undefined && form != "") {
        var ss_temp = form.findField("BOND_TYPE_ID").getValue();
        if (ss_temp != null && ss_temp != undefined && ss_temp != "") {
            for (var i = 0; i < sm.length; i++) {
                if (sm[i].data.DATA_TYPE == 'ZW') {
                    if (ss_temp == sm[i].data.ZQLB_ID.substring(2, 4)) {

                    } else {
                        return false;
                    }
                } else {
                    if (ss_temp == sm[i].data.ZQLB_ID.substring(0, 2)) {

                    } else {
                        return false;
                    }
                }

            }
        } else {
            return true;
        }
    } else {
        return true;
    }

    return true;
}

function insertData_init(grid_goal, sm) {
    Ext.MessageBox.wait('正在获取支出信息..', '请等待..');
    var isExist = false;
    var win = Ext.ComponentQuery.query('window[itemId="window_dqzq"]');
    var havaSelectedData = sm;
    var detailList = new Array();
    for (var i = 0; i < sm.length; i++) {
        havaSelectedData = sm[i].getData();
        var record = grid_goal.getStore().findRecord('ZQ_UUID', havaSelectedData.ZQ_UUID, 0, false, true, true);
        if (record == null || record == undefined) {
            if (i == 0) {
                SetZqlx(havaSelectedData);
            }
            detailList.push(havaSelectedData);
        }
        else {
            isExist = true;
            return isExist;
        }
    }
    $.post("/getZqZcxx.action", {
            bill_id: bill_id_temp,
            record: Ext.util.JSON.encode(detailList)
        },
        function (data) {
            var data = $.parseJSON(data);
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询id' + '失败！' + data.message);
                return;
            }
            var columnStore = data.list;
            for (var i = 0; i < columnStore.length; i++) {
                columnStore[i]['IS_PP'] = 0;
                columnStore[i]['PLAN_AMT_SQ'] = columnStore[i]['SY_PAY_AMT'];
                if (columnStore[i]['ZQLB_ID'].substring(0, 2) == '02') {
                    columnStore[i]['XMSYNX'] = columnStore[i]['SYNX'];
                }
            }
            grid_goal.insertData(null, columnStore);
            setForm(null, false);
            Ext.MessageBox.hide();
            closewindow2(win);
        }
    );
    return isExist;
}

function closewindow2(win) {
    if (win != null && win != '' && win != undefined) {
        for (var i = 0; i < win.length; i++) {
            win[i].close();
        }
    }
}

function fxjh_choose_zq(btn) {
    var window = Ext.create('Ext.window.Window', {
        title: '到期债券/债务选择窗口', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_dqzq', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWindow_fxjh_zq()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var var$temp1 = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].getValue().substr(0, 2);
                    var win = Ext.ComponentQuery.query('window[itemId="window_dqzq"]');
                    var win2 = Ext.ComponentQuery.query('window[itemId="window_dqzq_SURE"]');
                    if (win2 == null || win2 == "" || win2 == undefined) {  //债券确认窗口是否存在
                        var grid = DSYGrid.getGrid('dqzq_grid');
                        var sm = grid.getSelectionModel().getSelection();
                        if (sm.length < 1) {     //是否选择了有效的债券
                            Ext.toast({
                                html: "请选择一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            dqzqsq_sure_window(var$temp1);
                            var grid_goal = DSYGrid.getGrid('dqzq_sure_zq');
                            if (getBatchNo(sm)) {
                                insertData_init(grid_goal, sm);
                            } else {
                                Ext.toast({
                                    html: "请选择同一个债券类型的数据!",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }
                    } else {
                        if (win2.length <= 0) {
                            var grid = DSYGrid.getGrid('dqzq_grid');
                            var sm = grid.getSelectionModel().getSelection();
                            if (sm.length < 1) {
                                Ext.toast({
                                    html: "请选择一条数据后再进行操作!",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            } else {
                                var grid_goal = DSYGrid.getGrid('dqzq_sure_zq');
                                if (getBatchNo(sm)) {
                                    insertData_init(grid_goal, sm);
                                } else {
                                    Ext.toast({
                                        html: "请选择同一个债券类型的数据!",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                            }
                        } else {
                            win2 = win2[0];
                            var grid = DSYGrid.getGrid('dqzq_grid');
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
                                var grid_goal = DSYGrid.getGrid('dqzq_sure_zq');
                                if (getBatchNo(sm)) {
                                    var isExist = insertData_init(grid_goal, sm);
                                } else {
                                    Ext.toast({
                                        html: "请选择同一个债券类型的数据!",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                            }
                            win2.setVisible(true);
                            if (isExist) {
                                Ext.Msg.alert('提示', '每笔债券/债务只可录入一次！');
                            }
                        }
                    }
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    WbLx = null;
                    WbLx_is_fix = false;
                    btn.up('window').close();
                }
            }
        ]
    });
    window.show();
    if (WbLx_is_fix) {
        if (WbLx != null && WbLx != "" && WbLx != undefined) {
            var form = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
            form.findField("BOND_TYPE_ID").setValue(WbLx);
            form.findField("BOND_TYPE_ID").setReadOnly(WbLx_is_fix);
            form.findField("BOND_TYPE_ID").setFieldStyle("background:#E6E6E6");
        }
    }
}

function fj_detail(config) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET249',//业务类型
        busiId: config.busiId,//业务ID
        editable: config.editable,//是否可以修改附件内容
        gridConfig: {
            itemId: 'win_grid_jxhj'
        }
    });
    //附件加载完成后计算总文件数，并写到页签上
    grid.getStore().on('load', function (self, records, successful) {
        var sum = 0;
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if (records[i].data.STATUS == '已上传') {
                    sum++;
                }
            }
        }
        if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else if ($('span.file_sum')) {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

function setForm(context, doaction) {
    var form_var1 = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
    var grid_var1 = DSYGrid.getGrid("dqzq_sure_zq");
    var grid_store = grid_var1.getStore();
    var sq_amt_tatal = 0;
    var dq_hj = 0;
    var dqhjList = new Array();
    for (var i = 0; i < grid_store.getCount(); i++) {
        var record = grid_store.getAt(i);
        var sq_amt_temp = record.get("PLAN_AMT_SQ");
        var dq_hj_temp = record.get("PLAN_AMT");
        var zq_id = record.get("ZQ_ID");
        if (sq_amt_temp == null || sq_amt_temp == "" || sq_amt_temp == undefined) {
        } else {
            sq_amt_tatal += sq_amt_temp;
        }
        if (dq_hj_temp == null || dq_hj_temp == "" || dq_hj_temp == undefined) {
        } else {
            if (i == 0) {
                dq_hj = dq_hj_temp;
                dqhjList.push(zq_id);
            }
            var index = $.inArray(zq_id, dqhjList);//判断该条数据是否已经存在
            if (index < 0) {//不存在
                dq_hj += dq_hj_temp;
                dqhjList.push(zq_id);
            }
        }
    }
    if(grid_store.data.items.length != 0){
        form_var1.findField("AD_NAME").setValue(grid_store.data.items[0].get("AD_NAME"));
    }
    form_var1.findField("APPLY_AMT").setValue(sq_amt_tatal);
    form_var1.findField("DQBJ_HJ").setValue(dq_hj);
}

function checkAmt(context) {
    var grid_var1 = DSYGrid.getGrid("dqzq_sure_zq").getStore();
    if (context.field == 'PLAN_AMT_SQ') {
        if (context.value > (context.record.get("SY_PAY_AMT"))) {
            Ext.MessageBox.alert('提示', "支出超额！");
            return false;
        }
        if (context.value <= 0) {
            Ext.MessageBox.alert('提示', "申请再融资金额大于等于0");
            return false;
        }
    }
    return true;
}

var WbLx = null;
var WbLx_is_fix = false;

function setWbLx() {
    var form = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
    WbLx = form.findField("BOND_TYPE_ID").getValue();
    if (WbLx.length > 2) {
        WbLx = WbLx.substring(0, 2);
    }
    WbLx_is_fix = true;
}

function dqzqsq_sure_window(var$temp1) {
    var config = {
        editable: true,
        busiId: bill_id_temp
    };
    var headerjson2 = [
        {xtype: 'rownumberer', width: 45},
        {text: "明细id", dataIndex: "BILL_DTL_ID", type: "string", hidden: true},
        {dataIndex: "AD_CODE", width: 100, type: "string", text: "地区CODE", tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "AD_NAME", width: 100, type: "string", text: "债券地区", tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "ZQ_ID", width: 150, type: "string", text: "债券ID", tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "ZC_ID", width: 150, type: "string", text: "支出ID", tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "ZQ_CODE", type: "string", text: "债券编码", width: 100, tdCls: 'grid-cell-unedit'},
        {
            text: "债券/债务名称", dataIndex: "ZQ_NAME", type: "string", width: 400, tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    paramNames[1] = "zwlb_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                    paramValues[1] = encodeURIComponent(record.get('ZQLB_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE;
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            }
        },
        {
            dataIndex: "PLAN_AMT_SQ", width: 130, type: "float", text: "申请再融资金额", tdCls: 'grid-cell',
            editor: {
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            }
        },
        {
            dataIndex: "IS_PP",
            width: 200,
            type: "string",
            text: "专项债券与项目期限是否匹配",
            tdCls: 'grid-cell',
            hidden: var$temp1 == '01' ? true : false,
            editor: {
                xtype: 'combobox',
                store: is_pp_store,
                displayField: 'name',
                valueField: 'id'
            },
            renderer: function (value) {
                var record = is_pp_store.findRecord('id', value, 0, true, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: "XMSYNX",
            width: 220,
            type: "int",
            text: "专项债券项目剩余期限（年）",
            tdCls: 'grid-cell',
            hidden: var$temp1 == '01' ? true : false,
            editor: {xtype: 'numberFieldFormat'}
        },
        {
            dataIndex: "QX_NAME", type: "string", text: "债券期限",width: 80, tdCls: 'grid-cell-unedit',
            renderer: function (value, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    return value + "月";
                } else {
                    return value;
                }
            }
        },
        {dataIndex: "ZQLB_NAME", type: "string", text: "债券类型", width: 150, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZC_TYPE", type: "string", text: "支出类型", width: 100, tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "ZC_TYPE_NAME", type: "string", text: "债券性质", width: 100, tdCls: 'grid-cell-unedit'},
        {dataIndex: "DF_END_DATE", type: "string", text: "到期日期", width: 100, tdCls: 'grid-cell-unedit'},
        {dataIndex: "PLAN_AMT", type: "float", text: "到期本金", width: 130, tdCls: 'grid-cell-unedit'},
        {dataIndex: "PLAN_XZ_AMT", type: "float", text: "其中：新增", width: 150, tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "PLAN_ZH_AMT", type: "float", text: "其中：置换", width: 150, tdCls: 'grid-cell-unedit', hidden: true},
        {dataIndex: "PAY_AMT", type: "float", text: "置换/支出金额", width: 150, tdCls: 'grid-cell-unedit'},
        {
            dataIndex: "SY_PAY_AMT",
            type: "float",
            text: "剩余可置换/支出金额",
            width: 160,
            tdCls: 'grid-cell-unedit'
        },
        {text: "项目id", dataIndex: "XM_ID", type: "string", hidden: true},
        {dataIndex: "XM_NAME", text: "项目名称", type: "string",width: 300, tdCls: 'grid-cell-unedit'},
        {dataIndex: "XMLX_NAME", text: "项目类型", type: "string", width: 150, tdCls: 'grid-cell-unedit'},
        {dataIndex: "PAY_DATE", text: "置换/支出日期", type: "string",width: 120, tdCls: 'grid-cell-unedit'},
        {dataIndex: "AG_NAME", text: "债务单位", type: "string",width: 200, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZW_XY_NO", text: "置换债务协议号", type: "string",width: 200, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZW_NAME", text: "置换债务名称", type: "string", width: 400, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZWLX_NAME", text: "置换债务类型", type: "string", width: 120, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZQFL_NAME", text: "债权类型", type: "string",width: 120, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZQR_ID", text: "债权人", type: "string", width: 100, tdCls: 'grid-cell-unedit'},
        {dataIndex: "ZQR_FULLNAME", text: "债权人全称", type: "string", width: 250,tdCls: 'grid-cell-unedit'},
        {dataIndex: "DATA_TYPE", type: "string", text: "数据类型", hidden: true}
    ];

    var grid_zq_sure = DSYGrid.createGrid({
        itemId: 'dqzq_sure_zq',
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
        data: [],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jxhj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    beforeedit: function (editor, context) {
                        if (context.field == 'IS_PP') {
                            var var$temp1 = Ext.ComponentQuery.query('treecombobox[name="BOND_TYPE_ID"]')[0].getValue();
                            var var$temp2 = context.record.get('ZC_TYPE');
                            if (var$temp1 != null && var$temp2 != null && var$temp1 == 02 && var$temp2 == 0) {

                            } else {
                                return false;
                            }
                        }
                        if (context.field == 'XMSYNX') {
                            var var$temp1 = Ext.ComponentQuery.query('treecombobox[name="BOND_TYPE_ID"]')[0].getValue();
                            // var var$temp2 = context.record.get('ZC_TYPE');
                            if (var$temp1 != null && var$temp1 == 02) {

                            } else {
                                return false;
                            }
                        }
                    },
                    validateedit: function (editor, context) {
                        if (context.field == "PLAN_AMT_SQ") {
                            if (!checkAmt(context)) {
                                return false;
                            }
                        }
                    },
                    edit: function (editor, context) {
                        if (context.field == "PLAN_AMT_SQ") {
                            setForm(context, true);
                        }
                    }
                }
            }
        ]
    });

    var zq_main_tab = Ext.create('Ext.tab.Panel', {
        height: '100%',
        region: 'center',
        border: false,
        items: [
            {
                title: '申请',
                layout: 'fit',
                scrollable: true,
                items: {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        labelWidth: 110//控件默认标签宽度
                    },
                    items: [
                        {
                            name: 'BILL_ID',
                            readOnly: true,
                            hidden: true
                        },
                        {
                            fieldLabel: '区划名称',
                            name: 'AD_NAME',
                            readOnly: true,
                            value: USER_AD_NAME,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'datefield',
                            fieldLabel: '申请日期',
                            name: 'APPLY_DATE',
                            format: 'Y-m-d',
                            readOnly: true,
                            value: new Date(),
                            fieldStyle: 'background:#E6E6E6'

                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '经办人',
                            name: "JBR",
                            readOnly: true,
                            value: userName_jbr,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "datefield",
                            fieldLabel: '申报年度',
                            name: "BILL_YEAR",
                            readOnly: true,
                            //value:new Date(),
                            format: 'Y',
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '申请类型',
                            name: 'BOND_TYPE_ID',
                            displayField: 'name',
                            valueField: 'code',
                            store: zqlb_store,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '<span class="required">✶</span>申报批次',
                            name: 'BATCH_NO',
                            displayField: 'text',
                            valueField: 'id',
                            selectModel: 'leaf',
                            allowBlank: false,
                            store: batch_no_store,
                            editable: false
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '申请总金额(元)',
                            name: "APPLY_AMT",
                            regex: /^(([0-9]+[\.]?[0-9]+)|[1-9])$/,
                            regexText: "总申请金额必须大于0",
                            readOnly: true,
                            hideTrigger: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '新增债券',
                            decimalPrecision: 2,
                            name: "APPLY_XZ_AMT",
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6',
                            hidden: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '置换债券',
                            name: 'APPLY_ZH_AMT',
                            decimalPrecision: 2,
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6',
                            hidden: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '到期总金额(元)',
                            name: "DQBJ_HJ",
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            fieldLabel: '备注',
                            name: 'REMARK',
                            allowBlank: true,
                            columnWidth: .99,
                            maxLength: 220,
                            maxLengthText: '输入备注信息过长！'
                        }
                    ]
                }
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                scrollable: true,
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        items: fj_detail(config)
                    }
                ],
                listeners: {
                    beforeactivate: function (self) {
                        // 检验明细是否有数据
                        var panel = self.down('panel');
                        panel.removeAll(true);
                        panel.add(fj_detail({
                            editable: true,
                            busiId: bill_id_temp
                        }));
                    }
                }
            }
        ]
    });

    var zq_tab = Ext.create('Ext.tab.Panel', {
        height: '100%',
        region: 'center',
        border: false,
        items: [
            {
                title: '申请明细',
                layout: 'fit',
                items: grid_zq_sure
            }
        ]
    });

    var form_zq_sure = Ext.create('Ext.form.Panel', {
        name: 'form_zq_sure',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        defaults: {
            width: '100%',
            margin: '2 0 2 5'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                flex: 1,
                collapsible: false, // 是否可以折叠
                layout: 'fit',
                items: [
                    zq_main_tab
                ]
            },
            {
                xtype: 'container',
                flex: 2,
                collapsible: false, // 是否可以折叠
                layout: 'fit',
                items: [
                    zq_tab
                ]
            }
        ]
    });


    var window = Ext.create('Ext.window.Window', {
        title: '申请计划', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_dqzq_SURE', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: form_zq_sure,
        buttons: [
            {
                text: '增行',
                handler: function (btn) {
                    setWbLx();
                    var win = Ext.ComponentQuery.query('window[itemId="window_dqzq"]')[0];
                    if (win != null && win != "" && win != undefined) {
                        win.setVisible(true);
                        if (WbLx != null && WbLx != "" && WbLx != undefined) {
                            var form = Ext.ComponentQuery.query('form[name="form_zq_sure"]')[0].getForm();
                            form.findField("BOND_TYPE_ID").setValue(WbLx);
                            form.findField("BOND_TYPE_ID").setReadOnly(WbLx_is_fix);
                            form.findField("BOND_TYPE_ID").setFieldStyle("background:#E6E6E6");
                        }
                        resetChange();
                    } else {
                        fxjh_choose_zq();
                    }

                }
            },
            {
                text: '删行',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('dqzq_sure_zq');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    var records = sm.getSelection();
                    store.remove(records);
                    setForm(null, false);
                }
            },

            {
                text: '保存',
                handler: function (btn) {
                    var form = btn.up("window").down("form");
                    if (form.isValid()) {
                        submitTBSQ(btn);
                    } else {
                        Ext.toast({
                            html: "输入项未通过校验，请检查！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }

                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    WbLx = null;
                    WbLx_is_fix = false;
                    var win = Ext.ComponentQuery.query('window[itemId="window_dqzq"]');
                    if (win != null && win != '' && win != undefined) {
                        for (var i = 0; i < win.length; i++) {
                            win[i].close();
                        }
                    }
                    var win2 = Ext.ComponentQuery.query('window[itemId="window_dqzq_SURE"]');
                    if (win2 != null && win2 != '' && win2 != undefined) {
                        for (var i = 0; i < win2.length; i++) {
                            win2[i].close();
                        }
                    }
                }
            }
        ]
    });


    window.show();
    return window;
}


function resetChange() {
    var dqzq_grid = DSYGrid.getGrid("dqzq_grid");
    if (dqzq_grid != null && dqzq_grid != "" && dqzq_grid != undefined) {
        dqzq_grid.getSelectionModel().select(0);
    }
}

/**
 * 功能：提交保存再融资编制计划数据
 */
function submitTBSQ(btn) {
    var form = btn.up("window").down("form");
    var grid = btn.up("window").down("form").down('#dqzq_sure_zq');
    var store = grid.getStore();
    var mainList = form.getValues();
    var detailList = new Array();
    var rownumber = 0;
    for (var i = 0; i < store.getCount(); i++) {
        var record = store.getAt(i);
        var data = record.getData();
        rownumber++;
        var sq_sum_amt = data.YBGGYS_AMT + data.ZFXZJ_AMT + data.ZXZQ_XMZXSR_AMT + data.PLAN_AMT_SQ + data.ZJQK_AMT;
        if (sq_sum_amt > data.PAY_AMT) {
            Ext.MessageBox.alert('提示', '申请明细表第' + rownumber + '行预算编制合计资金不能大于置换/支出金额！');
            return false;
        }
        detailList.push(data);
    }
    if (form.isValid()) {
        Ext.Ajax.request({
            method: 'POST',
            url: "/JxhjSaveNewSqBill.action",
            params: {
                AD_CODE: USER_AD_CODE,
                USERCODE: USER_AD_CODE,
                WF_ID: wf_id,
                NODE_CODE: node_code,
                BUTTON_NAME: button_name,
                mainList: Ext.util.JSON.encode(mainList),
                detailList: Ext.util.JSON.encode(detailList),
                USER_NAME: userName_jbr,
                USER_CODE: USER_CODE
            },
            async: false,
            success: function (response, options) {
                var result = Ext.util.JSON.decode(response.responseText);
                if (result.success == true) {
                    toast_util("保存", true);
                    closewindow();
                    reloadMain();
                } else {
                    Ext.MessageBox.show({
                        title: '保存失败',
                        msg: result.message,
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn) {
                        }
                    });
                    return false;
                }
            },
            failure: function (response, options) {
                var result = Ext.util.JSON.decode(response.responseText);
                Ext.MessageBox.show({
                    title: '保存失败',
                    msg: result.message,
                    width: 200,
                    fn: function (btn) {

                    }
                });
                return false;
            }
        });
    } else {
        Ext.MessageBox.alert('提示', '请正确填写数据');
    }
}

function closewindow() {
    var win = Ext.ComponentQuery.query('window[itemId="window_dqzq"]')[0];
    if (win != null && win != "" && win != undefined) {
        win.close();
    }
    var win2 = Ext.ComponentQuery.query('window[itemId="window_dqzq_SURE"]')[0];
    if (win2 != null && win2 != "" && win2 != undefined) {
        win2.close();
    }
}

function reloadMain() {
    var main_grid = DSYGrid.getGrid("contentGrid");
    main_grid.getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
    var sbpc = Ext.ComponentQuery.query('treecombobox[name="BATCH_NO"]')[0].getValue();
    if (sbpc != null && sbpc != "" && sbpc != undefined) {
        main_grid.getStore().getProxy().extraParams['SBPC'] = sbpc;
    } else {
        main_grid.getStore().getProxy().extraParams['SBPC'] = "";

    }
    main_grid.getStore().loadPage(1);
    var mx_grid = DSYGrid.getGrid("contentGrid_detail");
    mx_grid.getStore().getProxy().extraParams['BILL_ID'] = '';
    mx_grid.getStore().loadPage(1);
}

function initWindow_fxjh_zq() {
    var toolbar_choose_zq = [
        {
            xtype: 'combobox',
            fieldLabel: '到期年度',
            labelWidth: 60,
            width: 160,
            name: 'debt_year',
            value: '2022',
            editable: false,
            readOnly: true,
            enableKeyEvents: true,
            displayField: 'name',
            valueField: 'code',
            store: DebtEleStore(json_debt_year),
            listeners: {
                'select': function (self, record) {
                    reload_jm_nh97();
                },
                'keypress': function () {
                    reload_jm_nh97();
                }
            }
        },
        {
            xtype: 'treecombobox',
            fieldLabel: '债券/债务类型',
            labelWidth: 90,
            width: 310,
            name: 'ZQLB_ID',
            readOnly: WbLx_is_fix,
            editable: WbLx_is_fix,
            fieldStyle: WbLx_is_fix ? 'background:#E6E6E6' : 'background:white',
            displayField: 'name',
            valueField: 'code',
            // selectModel: 'root',
            rootVisible: false,
            value: WbLx != null && WbLx != "" && WbLx != undefined ? WbLx : default_zqlb,
            store: DebtEleTreeStoreDB('DEBT_ZQLB'),
            listeners: {
                'select': function (self, record) {
                    if (record.get('code') == '01') {
                        is_zqlb_hidden = 'yb';
                    } else {
                        is_zqlb_hidden = 'zx';
                    }
                    reload_jm_nh97();
                    var ZQLB_ID = Ext.ComponentQuery.query('treecombobox#ZQLB_ID')[0];
                    if (ZQLB_ID != null && ZQLB_ID != "" && ZQLB_ID != undefined) {
                        default_zqlb = ZQLB_ID.getValue();
                    }
                },
                'keypress': function () {
                    reload_jm_nh97();
                    var ZQLB_ID = Ext.ComponentQuery.query('treecombobox#ZQLB_ID')[0];
                    if (ZQLB_ID != null && ZQLB_ID != "" && ZQLB_ID != undefined) {
                        default_zqlb = ZQLB_ID.getValue();
                    }
                }
            }
        },
        {
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                reload_jm_nh97()
            }
        }
    ];
    function reload_jm_nh97() {
        var dqzq_grid = DSYGrid.getGrid("dqzq_grid");
        var v_temp_1 = Ext.ComponentQuery.query('combobox[name="debt_year"]')[0].getValue();
        var v_temp_2 = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].getValue();
        dqzq_grid.getStore().getProxy().extraParams = {
            DQND: v_temp_1,
            ZQLB: v_temp_2
        };
        dqzq_grid.getStore().loadPage(1);
    }

    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "zq唯一的标识列", dataIndex: "ZQ_UUID", type: "string", hidden: true},
        {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "债券地区"},
        {
            text: "债券/债务名称", dataIndex: "ZQ_NAME", type: "string", width: 400,
            renderer: function (data, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    paramNames[1] = "zwlb_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                    paramValues[1] = encodeURIComponent(record.get('ZQLB_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE;
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            }
        },
        {dataIndex: "ZQ_JC", type: "string", text: "债券简称", width: 120},
        {dataIndex: "ZQLB_NAME", type: "string", text: "债券/债务类型", width: 150},
        {dataIndex: "DF_END_DATE", type: "string", text: "到期日期", width: 100},
        {
            dataIndex: "PLAN_AMT", type: "float", text: "到期总金额", width: 150,
            editor: {xtype: 'numberFieldFormat', editable: false}
        },
        {
            dataIndex: "PLAN_XZ_AMT", type: "float", text: "其中：到期新增金额", width: 150,
            editor: {xtype: 'numberFieldFormat', editable: false}
        },
        {
            dataIndex: "PLAN_ZH_AMT", type: "float", text: "其中：到期置换金额", width: 150,
            editor: {xtype: 'numberFieldFormat', editable: false}
        },
        {
            dataIndex: "PLAN_HB_AMT", type: "float", text: "其中：到期再融资金额", width: 180,
            editor: {xtype: 'numberFieldFormat', editable: false}
        },
        {
            dataIndex: "ZQQX_NAME", type: "string", text: "期限", width: 80,
            renderer: function (value, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    return value + "月";
                } else {
                    return value;
                }
            }
        },
        {dataIndex: "ZW_ID", type: "string", text: "ZW_ID", width: 100, hidden: true},
        {dataIndex: "DATA_TYPE", type: "string", text: "数据类型", width: 100, hidden: true},
        {dataIndex: "PM_RATE", type: "string", text: "利率%", width: 80},
        {dataIndex: "QX_DATE", type: "string", text: "发行日期", width: 100}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'dqzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/JxhjChooseGrid.action?AD_CODE=' + USER_AD_CODE + '&bill_id=' + bill_id_temp,
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
                itemId: 'jxhj_zq_choose_toolbar',
                items: toolbar_choose_zq
            }
        ],
        params: {
            ZQLB: WbLx != null && WbLx != "" && WbLx != undefined ? WbLx : default_zqlb,
            AD_CODE: USER_AD_CODE,
            DQND: 2022
        }

    });
    return grid;
}

function initContentGrid() {
    var headerJson = HEADERJSON;
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoLoad: true,
        height: '50%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_zt),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                editable: false,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(json_common.items[WF_STATUS]);
                        //刷新当前表格
                        reloadMain();
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '申报批次',
                displayField: 'name',
                valueField: 'id',
                name: 'BATCH_NO',
                store: batch_no_store2,
                editable: false,
                width: 400,
                labelWidth: 70,
                labelAlign: 'right',
                selectModel: 'leaf',
                listeners: {
                    select: function (combo, record, index) {
                        reloadMain();
                    }
                }
            }
        ],
        params: {
            NODE_CODE: node_code,
            AD_CODE: USER_AD_CODE,
            WF_STATUS: WF_STATUS,
            USERCODE: USER_AD_CODE,
            WF_ID: wf_id
        },
        dataUrl: '/JxhjMainGrid.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }],
        listeners: {
            itemclick: function (self, record) {
                var mx_grid = DSYGrid.getGrid("contentGrid_detail");
                mx_grid.getStore().getProxy().extraParams['BILL_ID'] = record.get("BILL_ID");
                mx_grid.getStore().loadPage(1);
            }
        }
    });
}

function initContentGrid_MX() {
    var headerJson = HEADERJSON_mx;
    var config = {
        itemId: 'contentGrid_detail',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        params: {
            node_type: node_type
        },
        autoLoad: false,
        border: false,
        height: '50%',
        width: '100%',
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/JxhjMainMx.action'
    };

    return DSYGrid.createGrid(config);

}

function operationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("BILL_ID"));
    }
}


