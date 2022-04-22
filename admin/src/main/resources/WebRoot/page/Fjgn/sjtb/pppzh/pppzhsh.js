/**
 * js：还本付息资金审核
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
var dw_name = "";
$.extend(ppp_json_common[wf_id][node_type], {
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
                        getPPPZhDataList();
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
                    opinionWindow.open('NEXT', "审核意见",btn);
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
                    opinionWindow.open('BACK', "退回意见",btn,records);
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
                        getPPPZhDataList();
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
               /*     Ext.MessageBox.show({
                        title: '提示',
                        msg: "是否撤销选择的记录？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn) {
                            button_name = btn.text;
                            if (btn == "ok") {
                                
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
                        getPPPZhDataList();
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
        {dataIndex: "AG_CODE", width: 100, type: "string", text: "单位编码"},
        {dataIndex: "AG_NAME", width: 200, type: "string", text: "单位名称"},
        {dataIndex: "CHBJ_CODE", width: 200, type: "string", text: zjly_id == '04' ? "核销申请单号" : "转化申请单号"},
        {dataIndex: "PAY_AMT_RMB", width: 150, type: "float", text: zjly_id == '04' ? "核销金额" : "转化金额"},
        {dataIndex: "PAY_DATE", width: 120, type: "string", text: zjly_id == '04' ? '债务核销日期' : "转化生效日期"},
        {dataIndex: "PPPXM_CODE", width: 100, type: "string", text: "PPP项目编码", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "PPPXM_NAME", width: 100, type: "string", text: "PPP项目名称", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "PPPXM_AMT", width: 150, type: "float", text: "项目总投资（万元）", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "XMGS_NAME", width: 150, type: "string", text: "项目公司名称", hidden: zjly_id == '04' ? true : false},
        {dataIndex: "REMARK", width: 250, type: "string", text: zjly_id == '04' ? "核销原因" : "备注"}

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
                allowBlank: false,
                editable: false,
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(ppp_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        if (AD_CODE == null || AD_CODE == '') {
                            return;
                        }
                        getPPPZhDataList();
                        //reloadGrid();

                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                name: 'contentGrid_search',
                width: 300,
                labelWidth: 60,
                labelAlign: 'right',
                emptyText: '请输入单位名称/单位编码...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            getPPPZhDataList();
                        }
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
        dataUrl: 'getPPPZhDataList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
//	        features: [{
//	            ftype: 'summary'
//	        }],
        listeners: {
            itemdblclick: function (self, record) {
                //发送ajax请求，查询主表和明细表数据
                $.post("/getPPPZhChbjGridById.action", {
                    id: record.get('CHBJ_ID')
                }, function (data) {
                    if (!data.success) {
                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                        return;
                    }
                    if (zjly_id == '04') {
                        TITLE = '债务核销申请单查看';
                    } else {
                        TITLE = 'PPP转化申请单查看';
                    }
                    window_debt_view_pppzh.show({
                        gridId: record.get('CHBJ_ID'),
                        disabled: true
                    });
                    var store = window_debt_view_pppzh.window.down('form#window_debt_view_pppzh_form').down('grid#debt_view_apply_grid').getStore();
                    store.insert(0, data.data);
                    window_debt_view_pppzh.window.down('form#window_debt_view_pppzh_form').getForm().setValues(data);
                }, "json");
            }
        }
    });
    return grid;
}

/**
 * 查询按钮实现
 */
function getPPPZhDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield[name="contentGrid_search"]')[0].getValue();

    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        wf_status: WF_STATUS,
        wf_id: wf_id,
        zjly_id: zjly_id,
        node_code: node_code,
        mhcx: mhcx,
        zwlb_id: zwlb_id
    };
    store.loadPage(1);
}
/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action, title,btn) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            value: btn.name == 'down' ? '同意' : null,
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn, text) {
                audit_info = text;
                if (btn == "ok") {
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
 * 还本付息资金审核送审
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
            url: 'doWorkFlowActionPPP.action',
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
            success: function (resp, action) {
                var result = Ext.util.JSON.decode(resp.responseText);
                Ext.MessageBox.show({
                    title: '提示',
                    msg: result.msg,
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (resp, action) {
                var result = Ext.util.JSON.decode(resp.responseText);
                Ext.MessageBox.show({
                    title: '提示',
                    msg: result.msg,
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
}

/**
 * 债务合同信息退回
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
            url: 'doWorkFlowActionPPP.action',
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
            success: function (resp, action) {
                var result = Ext.util.JSON.decode(resp.responseText);
                Ext.MessageBox.show({
                    title: '提示',
                    msg: result.msg,
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (resp, action) {
                var result = Ext.util.JSON.decode(resp.responseText);
                Ext.MessageBox.show({
                    title: '提示',
                    msg: result.msg,
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
}
/**
 * 还本付息资金审核撤销送审
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
             fn: function (btn) {
                  if (btn == "ok") {
                	  var hbfxInfoArray = [];
                      Ext.each(records, function (record) {
                          var array = {};
                          array.ID = record.get("CHBJ_ID");
                          array.PAY_DATE = record.get("PAY_DATE");
                          array.AD_CODE = record.get("AD_CODE");
                          hbfxInfoArray.push(array);
                      });
                      var btn_name = 'cancel';

                      //向后台传递变更数据信息
                      Ext.Ajax.request({
                          method: 'POST',
                          url: 'doWorkFlowActionPPP.action',
                          params: {
                              workflow_direction: btn_name,
                              wf_id: wf_id,
                              node_code: node_code,
                              button_name: button_name,
                              is_end: is_end,
                              hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)

                          },
                          async: false,
                          success: function (resp, opt) {
                              var result = Ext.util.JSON.decode(resp.responseText);
                              //if(result.success){
                              Ext.MessageBox.show({
                                  title: '提示',
                                  msg: result.msg,//'撤销审核成功',
                                  width: 200,
                                  buttons: Ext.MessageBox.OK,
                                  fn: function (btn) {
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
                          failure: function (resp, opt) {
                              var result = Ext.util.JSON.decode(resp.responseText);
                              Ext.MessageBox.show({
                                  title: '提示',
                                  msg: result.msg,//'撤销审核失败',
                                  width: 200,
                                  buttons: Ext.MessageBox.OK,
                                  fn: function (btn) {
                                      DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                                  }
                              });
                              DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                          }
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
	