/**
 * js：还本付息资金审核
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
var dw_name = "";
$.extend(hbfx_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ];
    },
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    }
                    button_name = btn.text;
                    opinionWindow.open('NEXT', "审核意见", btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'btn_back',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    }
                    button_name = btn.text;
                    //弹出对话框填写意见
                    opinionWindow.open('BACK', "退回意见", btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
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
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                name: 'cancel',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_name = btn.text;
                    cancleCheck(btn);
                  /*  Ext.MessageBox.show({
                        title: '提示',
                        msg: "是否撤销选择的记录？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btnBox) {
                            if (btnBox == "ok") {
                               
                            }
                        }
                    });*/
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
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
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "HOLD2", width: 150, type: "string", text: "录入类型"},
        {dataIndex: "AG_CODE", width: 100, type: "string", text: "单位编码"},
        {dataIndex: "AG_NAME", width: 200, type: "string", text: "单位名称"},
        {dataIndex: "CHBJ_CODE", width: 230, type: "string", text: "申请单号"},
        {dataIndex: "PAY_AMT_RMB", width: 180, type: "float", text: zwlb_id == 'wb' ? "还款金额(原币)" : "还款金额(元)"},
        {dataIndex: "PAY_AMT_RMB_BJ", width: 180, type: "float", text: "其中本金"},
        {dataIndex: "PAY_AMT_RMB_LX", width: 180, type: "float", text: "其中利息费用"},
        {dataIndex: "CREATE_DATE", width: 100, type: "string", text: "录入日期", hidden: true},
        {dataIndex: "SIGN_NAME", width: 110, type: "string", text: "是否提前还款", align: 'center', hidden: true},
        {dataIndex: "REMARK", width: 250, type: "string", text: "备注"}

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt2_3),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                allowBlank: false,
                editable: false,
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(hbfx_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        if (AD_CODE == null || AD_CODE == '') {
                            return;
                        }
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["wf_status"] = WF_STATUS;
                        self.up('grid').getStore().loadPage(1);

                    }
                }
            }, {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                name: 'contentGrid_search',
                width: 300,
                hidden: true,
                labelWidth: 60,
                labelAlign: 'left',
                emptyText: '请输入单位名称/单位编码...'
            },
            {
                xtype: 'combobox',
                fieldLabel: '是否提前还款',
                width: 170,
                labelWidth: 100,
                labelAlign: 'left',
                name: 'is_tqhk',
                displayField: 'name',
                valueField: 'id',
                rootVisible: true,
                allowBlank: false,
                lines: false,
                hidden: true,
                editable: false, //禁用编辑
                selectModchangel: 'leaf',
                store: DebtEleStore(json_debt_sf_all),
                value: '\%',
                listeners: {//加监听事件
                    change: function (self, newValue) {
                        //后续在补
                    }
                }
            }
        ],
        tbarHeight: 50,
        params: {
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        autoLoad: false,
        dataUrl: 'getHbfxDataList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
//	        features: [{
//	            ftype: 'summary'
//	        }],
        listeners: {
            itemdblclick: function (self, record) {

                //发送ajax请求，查询主表和明细表数据
                $.post("/getChbjGridById.action", {
                    id: record.get('CHBJ_ID')
                }, function (data) {
                    if (!data.success) {
                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                        return;
                    }
                    if(record.data.HOLD2=='红冲录入'){
                        CHBJ_ID=record.data.CHBJ_ID;
                        TITLE='还本红冲查看';
                        chooseHbhcWindow.show();
                        numberFormat(data.data[0]);
                        Ext.ComponentQuery.query('button[name="OK"]')[0].setHidden(true);
                        Ext.ComponentQuery.query('button[name="CLOSE"]')[0].setHidden(true);
                    }else {
                        TITLE = '偿债资金申请单信息查看';
                        window_debt_view_apply.show({
                            gridId: record.get('CHBJ_ID')
                        });
                        window_debt_view_apply.window.down('form#window_debt_view_apply_form').down('grid#debt_view_apply_grid').insertData(null, data.data);
                        window_debt_view_apply.window.down('form#window_debt_view_apply_form').getForm().setValues(data);
                    }
                }, "json");
            }
        }
    });
    return grid;
}
/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield[name="contentGrid_search"]')[0].value;
    var is_tqhk = Ext.ComponentQuery.query('combobox[name="is_tqhk"]')[0].value;
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        wf_status: WF_STATUS,
        wf_id: wf_id,
        node_code: node_code,
        mhcx: mhcx,
        is_tqhk: is_tqhk,
        zwlb_id: zwlb_id
    };
    store.loadPage(1);
}
/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action, title, btn) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            value: btn.name == 'down' ? '同意' : null,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btnBox, text) {
                audit_info = text;
                if (btnBox == "ok") {
                    if (action == 'NEXT') {
                        next(btn);
                    } else if (action == 'BACK') {
                        back(btn);
                    }
                }
            },
        });
    },
    close: function () {
        if (this.window) {
            this.window.close();
        }
    }
};
/**
 * 自有资金还本付息审核节点审核操作
 */
function next(btn) {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        //判断操作按钮
        if (node_code == '1') {
            button_name = 'SEND';
            msg_success = '送审成功！';
            msg_failure = '送审失败！';
        } else if (node_code == '2') {
            button_name = 'AUDIT';
            msg_success = '审核成功！';
            msg_failure = '审核失败！';
        }
        var hbfxInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("CHBJ_ID");
            hbfxInfoArray.push(array);
        });
        var btn_name = 'down';

        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'doWorkFlowAction.action',
            params: {
                workflow_direction: btn_name,
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                audit_info: audit_info,
                is_end: is_end,
                IS_AUTO_PAYMENT_PLAN: IS_AUTO_PAYMENT_PLAN,
                hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)

            },
            async: false,
            callback: function (opt, success, resp) {
                var result = Ext.util.JSON.decode(resp.responseText);
                /*var msg = '';
                 if (result.result == 'successAndFaild') {
                 msg = btn.text + '成功'+result.successCount+'笔，'+button_name+'失败'+result.faildCount+'笔'+result.msg;
                 }else if(result.result == 'successAll') {
                 msg = btn.text + '成功'+result.successCount+'笔';
                 }else if(result.result == 'faildAll') {
                 msg = btn.text + '失败'+result.faildCount+'笔'+result.msg;
                 }*/
                if (result.success) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: result.msg,
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }
                    });
                } else {
                    Ext.MessageBox.alert('提示', result.msg);
                }
            }/*,
             success : function(resp, action) {
             var result=Ext.util.JSON.decode(resp.responseText);
             Ext.MessageBox.show({
             title : '提示',
             msg : result.msg,
             width : 200,
             buttons : Ext.MessageBox.OK,
             fn : function(btn) {
             DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
             }
             });
             },
             failure : function(resp, action) {
             var result=Ext.util.JSON.decode(resp.responseText);
             Ext.MessageBox.show({
             title : '提示',
             msg : result.msg,
             width : 200,
             fn : function(btn) {
             DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
             }
             });
             }*/
        });

}
/**
 * 自有资金还本付息审核节点退回操作
 */
function back(btn) {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        var btn_name = 'up';
        button_name = 'BACK';
        var hbfxInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("CHBJ_ID");
            hbfxInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'doWorkFlowAction.action',
            params: {
                workflow_direction: btn_name,
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                audit_info: audit_info,
                is_end: is_end,
                hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)
            },
            async: false,
            callback: function (opt, success, resp) {
                var result = Ext.util.JSON.decode(resp.responseText);
                /*var msg = '';
                 if (result.result == 'successAndFaild') {
                 msg = btn.text + '成功'+result.successCount+'笔，'+button_name+'失败'+result.faildCount+'笔'+result.msg;
                 }else if(result.result == 'successAll') {
                 msg = btn.text + '成功'+result.successCount+'笔';
                 }else if(result.result == 'faildAll') {
                 msg = btn.text + '失败'+result.faildCount+'笔'+result.msg;
                 }*/
                if (result.success) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: result.msg,
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }
                    });
                } else {
                    Ext.MessageBox.alert('提示', result.msg);
                }
            }/*,
             success : function(resp, action) {
             var result=Ext.util.JSON.decode(resp.responseText);
             Ext.MessageBox.show({
             title : '提示',
             msg : result.msg,
             width : 200,
             buttons : Ext.MessageBox.OK,
             fn : function(btn) {
             DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
             }
             });
             },
             failure : function(resp, action) {
             var result=Ext.util.JSON.decode(resp.responseText);
             Ext.MessageBox.show({
             title : '提示',
             msg : result.msg,
             width : 200,
             fn : function(btn) {
             DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
             }
             });
             }*/
        });

}
/**
 * 还本付息资金审核撤销审核
 */
function cancleCheck(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
    	Ext.MessageBox.show({
            title: '提示',
            msg: "是否撤销选择的记录？",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (btnBox) {
                if (btnBox == "ok") {
                	 var hbfxInfoArray = [];
                     Ext.each(records, function (record) {
                         var array = {};
                         array.ID = record.get("CHBJ_ID");
                         array.CREATE_DATE = record.get("CREATE_DATE");
                         array.AD_CODE = record.get("AD_CODE");
                         hbfxInfoArray.push(array);
                     });
                     var btn_name = 'cancel';

                     //向后台传递变更数据信息
                     Ext.Ajax.request({
                         method: 'POST',
                         url: 'doWorkFlowAction.action',
                         params: {
                             workflow_direction: btn_name,
                             wf_id: wf_id,
                             node_code: node_code,
                             button_name: button_name,
                             is_end: is_end,
                             IS_AUTO_PAYMENT_PLAN: IS_AUTO_PAYMENT_PLAN,
                             hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)

                         },
                         async: false,
                         callback: function (opt, success, resp) {
                             var result = Ext.util.JSON.decode(resp.responseText);
                             var msg = '';
                             if (result.result == 'successAndFaild') {
                                 msg = btn.text + '成功' + result.successCount + '笔，' + button_name + '失败' + result.faildCount + '笔' + result.msg;
                             } else if (result.result == 'successAll') {
                                 msg = btn.text + '成功' + result.successCount + '笔';
                             } else if (result.result == 'faildAll') {
                                 msg = btn.text + '失败' + result.faildCount + '笔' + result.msg;
                             } else {
                                 msg = result.msg;
                             }
                             Ext.MessageBox.show({
                                 title: '提示',
                                 msg: msg,//'撤销审核成功',
                                 width: 200,
                                 buttons: Ext.MessageBox.OK,
                                 fn: function (btn) {
                                     DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                                 }
                             });
                         }
                         /*success : function(resp, opt) {
                          var result=Ext.util.JSON.decode(resp.responseText);
                          //if(result.success){
                          Ext.MessageBox.show({
                          title : '提示',
                          msg : result.msg,//'撤销审核成功',
                          width : 200,
                          buttons : Ext.MessageBox.OK,
                          fn : function(btn) {
                          DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                          }
                          });
                          //}else{
                          // window_chexiao_list.show();
                          //  window_chexiao_list.window.down('grid').getStore().removeAll();
                          // window_chexiao_list.window.down('grid').insertData(0,result.list);
                          // DSYGrid.getGrid("contentGrid").getStore().loadPage(1);

                          //}
                          },
                          failure : function(resp, opt) {
                          var result=Ext.util.JSON.decode(resp.responseText);
                          Ext.MessageBox.show({
                          title : '提示',
                          msg : result.msg,//'撤销审核失败',
                          width : 200,
                          buttons : Ext.MessageBox.OK,
                          fn : function(btn) {
                          DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                          }
                          });
                          DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                          }*/
                     });
                }
            }
        });
       
    }
}
//创建窗体
var window_chexiao_list = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_chexiao_list();
        }
        this.window.show();
    }
};
/**
 * 初始化利息测算结果信息弹出窗口
 */
function initWindow_chexiao_list() {
    return Ext.create('Ext.window.Window', {
        title: '不允许撤销结果', // 窗口标题
        width: 500, // 窗口宽度
        height: 300, // 窗口高度
        itemId: 'window_chexiao_list', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_chexiao_list_grid()],
        buttons: [
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_chexiao_list.window = null;
            }
        }
    });
}
/**
 *
 */
function initWindow_chexiao_list_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "CHBJ_CODE", width: 250, type: "string", text: "申请单号"},
        {dataIndex: "AG_CODE", width: 250, type: "string", text: "单位编码"}
    ];
    var simplyGrid = new DSYGridV2();
    var grid = simplyGrid.create({
        itemId: 'grid_chexiao_list',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        data: [],
        checkBox: true,
        border: false,
        height: 200
    });
    return grid;
}
/**
 * 简单的换算单位方法
 * @param dataJ
 */
function numberFormat(dataJ){
    var hbhcGrid = DSYGrid.getGrid('hbhcGrid');
    dataJ.APPLY_AMT = dataJ.APPLY_AMT/10000;
    dataJ.APPLY_AMT_RMB = dataJ.APPLY_AMT_RMB/10000;
    hbhcGrid.insertData(null,dataJ);
}
	