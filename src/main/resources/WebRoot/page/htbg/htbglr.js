/**
 * js：合同变更录入
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
$.extend(htbg_json_common[wf_id][node_type], {
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
                text: '新增',
                name: 'INPUT',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    if (!AG_CODE || AG_CODE == '') {
                        Ext.Msg.alert('提示', "请选择单位");
                        return;
                    }
                    button_name = 'INPUT';
                    window_htbg_zwxx.show();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    } else {
                        BG_ID = records[0].get("BG_ID");
                        ZW_ID = records[0].get("ZW_ID");
                        button_name = 'UPDATE';
                    }
                    initWin_htbglrWindow();

                    loadBgInfo();

                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    } else {
                        Ext.MessageBox.confirm('提示', '您确认删除选中的记录行吗?', function (e) {
                            if (e == "yes") {
                                deleteBgInfo();
                            }
                        });
                    }
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    Ext.MessageBox.show({
                        title: "提示",
                        msg: "是否确认送审？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn, text) {
                            audit_info = text;
                            if (btn == "ok") {
    	                        next();
    	                    } 
    	                    
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
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
                text: '撤销',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.show({
                            title: "提示",
                            msg: "是否撤销选择的记录？",
                            width: 200,
                            buttons: Ext.MessageBox.OKCANCEL,
                            fn: function (btn, text) {
                                audit_info = text;
                                if (btn == "ok") {
                                    back("CANCEL");
                                }
                            }
                        });
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    dooperation();
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
                text: '修改',
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                        return;
                    } else {
                        BG_ID = records[0].get("BG_ID");

                        button_name = 'UPDATE';
                    }
                    initWin_htbglrWindow();

                    loadBgInfo();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    } else {
                        Ext.MessageBox.confirm('提示', '您确认删除选中的记录行吗?', function (e) {
                            if (e == "yes") {
                                deleteBgInfo();
                            }
                        });
                    }
                }
            },
            {
                xtype: 'button',
                text: '送审',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    Ext.MessageBox.show({
                        title: "提示",
                        msg: "是否确认送审？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn, text) {
                            audit_info = text;
                            if (btn == "ok") {
    	                        next();
    	                    } 
    	                    
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
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
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});
//操作记录
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
        return;
    } else {
        BG_ID = records[0].get("BG_ID");

        fuc_getWorkFlowLog(BG_ID);
    }
}


/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#htbg_contentGrid_search')[0].getValue();
    var zqlx = Ext.ComponentQuery.query('treecombobox#htbg_zqlx')[0].getValue();
    var zwlb = Ext.ComponentQuery.query('treecombobox#htbg_zwlb')[0].getValue();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        mhcx: mhcx,
        zqlx: zqlx,
        zwlb: zwlb,
        url_zwlb_id: zwlb_id,
        CHANGE_TYPE: change_type,
        wf_status: WF_STATUS,
        wf_id: wf_id,
        node_code: node_code
    };
    //刷新表格内容
    store.loadPage(1);
}
/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action, title) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            value: '同意',
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn, text) {
                audit_info = text;
                if (btn == "ok") {
                    if (action == 'NEXT') {
                        next();
                    } else if (action == 'BACK') {
                        back('BACK');
                    }
                }
            },
            //animateTarget: btn_target
        });
    },
    close: function () {
        if (this.window) {
            this.window.close();
        }
    }
};
/**
 * 合同变更信息送审
 */
function next() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
        //判断操作按钮
        if (node_type == 'typing') {
            button_name = '送审';
            msg_success = '送审成功！';
            msg_failure = '送审失败！';
        } else if (node_type == 'reviewed') {
            button_name = '审核';
            msg_success = '审核成功！';
            msg_failure = '审核失败！';
        }
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("BG_ID");
            array.NODE_NEXT_ID = record.get("NODE_NEXT_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'nextBgInfo.action',
            params: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                audit_info: audit_info,
                bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
            },
            async: false,
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_success,
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_failure,
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
}
/**
 * 债务合同信息退回
 */
function back(btnName) {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
        var msg_name = "";
        if (btnName == 'BACK') {
            msg_name = '退回';
        }
        else if (btnName == 'CANCEL') {
            msg_name = '撤销';
            audit_info = '';
        }
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel()
            .getSelection();
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("BG_ID");
            array.NODE_NEXT_ID = record.get("NODE_NEXT_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'backBgInfo.action',
            params: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: btnName,
                audit_info: audit_info,
                bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
            },
            async: false,
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_name + '成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg_name + '失败',
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
}
/**
 * 删除债务合同信息
 */
function deleteBgInfo() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.BG_ID = record.get("BG_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: "delBgInfo.action",
            params: {
                bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
            },
            async: false,
            success: function (response, action) {
                var respText = Ext.util.JSON.decode(response.responseText);
                if (respText.success) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '删除成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function () {
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }
                    });
                } else {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '删除失败',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function () {
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }
                    });
                }
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '删除失败',
                    width: 200,
                    fn: function () {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
}

/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40
        }, {
            "dataIndex": "ZW_ID",
            "type": "string",
            "text": "债务ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "债务单位",
            "fontSize": "15px",
            "width": 250,
        }, {
            "dataIndex": "AG_CODE",
            "type": "string",
            "text": "单位编码",
            "fontSize": "15px",
            "width": 250,
            "hidden": true
        }, {
            "dataIndex": "ZW_CODE",
            "type": "string",
            "width": 250,
            "text": "债务编码",
            "hrefType": "combo",
            "hidden": true
        }, {
            "dataIndex": "ZW_NAME",
            "width": 250,
            "type": "string",
            "text": "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            "dataIndex": "CHANGE_TYPE",
            "width": 150,
            "type": "string",
            "text": "变更类型"
        },
        {
            "dataIndex": "ZQFL_ID",
            "width": 150,
            "type": "string",
            "text": "债权类型"
        }, {
            "dataIndex": "ZWLB_ID",
            "width": 150,
            "type": "string",
            "text": "债务类别"
        }, {
            "dataIndex": "XY_AMT",
            "width": 100,
            "type": "float",
            "align": 'right',
            "text": "协议金额（原币）"
        }, {
            "dataIndex": "ZQR_FULLNAME",
            "width": 300,
            "type": "string",
            "text": "债权人全称"
        }, {
            "dataIndex": "CHANGE_DATE",
            "width": 100,
            "type": "string",
            "text": "变更日期"
        }, {
            "dataIndex": "CHANGE_REASON",
            "width": 150,
            "type": "string",
            "text": "变更原因"
        }, {
            "dataIndex": "CHANGE_IMPORT",
            "width": 150,
            "type": "string",
            "text": "变更要点"
        }
    ];
    var simplyGrid = new DSYGridV2();
    return simplyGrid.create({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        rowNumber: true,
        border: false,
        height: '80%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt1),
                width: 110,
                allowBlank: false,
                editable: false,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(htbg_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["wf_status"] = WF_STATUS;
                        self.up('grid').getStore().getProxy().extraParams["wf_id"] = wf_id;
                        self.up('grid').getStore().getProxy().extraParams["node_code"] = node_code;
                        self.up('grid').getStore().getProxy().extraParams["CHANGE_TYPE"] = change_type;
                        if (AD_CODE == null || AD_CODE == '') {
                            Ext.Msg.alert('提示', '请选择区划！');
                            return;
                        }
                        self.up('grid').getStore().loadPage(1);
                    }
                }
            }
        ],
        autoLoad:false,
        params: {
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            url_zwlb_id: zwlb_id,
            CHANGE_TYPE: change_type
        },
        dataUrl: 'getHtbgList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                if (WF_STATUS == '008') {
                    BG_ID = record.get("BG_ID");
                    ZW_ID = record.get("ZW_ID");

                    initWin_htbglrWindow();

                    loadBgInfo();
                }

            }
        }
    });
}

//创建新增合同变更窗体
var window_htbg_zwxx = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_htbg_zwxx();
        }
        this.window.show();
    }
};
/**
 * 初始化存量债务信息弹出窗口
 */
function initWindow_htbg_zwxx() {
    return Ext.create('Ext.window.Window', {
        title: '存量债务信息', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        itemId: 'window_htbg_zwxx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_htbg_zwxx_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();

                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        return;
                    }
                    //关闭当前窗口，打开合同变更录入窗口
                    ZW_ID = records[0].get("ZW_ID");
                    AG_ID = records[0].get("AG_ID");
                    initWin_htbglrWindow();
                    btn.up('window').close();
                    var jbxxPanel = Ext.ComponentQuery.query('form[name="jbxxForm"]')[0];
                    loadInfo(jbxxPanel);


                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_htbg_zwxx.window = null;
            }
        }
    });
}

/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_htbg_zwxx_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 40
        },

        {"dataIndex": "ZW_ID", "type": "string", "text": "债务ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AG_ID", "type": "string", "text": "单位ID", "fontSize": "15px", "hidden": true},
        {"dataIndex": "AG_NAME", "type": "string", "text": "债务单位", "fontSize": "15px", "width": 250,},
        {
            "dataIndex": "ZW_CODE",
            "type": "string",
            "width": 250,
            "text": "债务编码",
            "hrefType": "combo"
        },
        {
            "dataIndex": "ZW_NAME", "width": 250, "type": "string", "text": "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {"dataIndex": "ZWLB_NAME", "width": 150, "type": "string", "text": "债务类别"},
        {"dataIndex": "SIGN_DATE", "width": 100, "type": "string", "text": "签订日期"},
        {"dataIndex": "ZW_XY_NO", "width": 150, "type": "string", "text": "协议号"},
        {"dataIndex": "ZQFL_ID", "width": 150, "type": "string", "text": "债权类型"},
        {"dataIndex": "ZQR_ID", "width": 150, "type": "string", "text": "债权人"},
        {"dataIndex": "ZQR_FULLNAME", "width": 300, "type": "string", "text": "债权人全称"},
        {"dataIndex": "FM_ID", "width": 100, "type": "string", "text": "币种"},
        {"dataIndex": "HL_RATE", "width": 100, "type": "float", "align": 'right', "text": "汇率"},
        {"dataIndex": "XY_AMT", "width": 150, "type": "float", "align": 'right', "text": "协议金额（原币）"},
        {"dataIndex": "LXTYPE_ID", "width": 150, "type": "string", "text": "利率类型"}


    ];
    var simplyGrid = new DSYGridV2();
    var grid = simplyGrid.create({
        itemId: 'grid_htbg_zwxx',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        rowNumber: true,
        border: false,
        height: '100%',
        tbar: [],
        tbarHeight: 50,
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            url_zwlb_id: zwlb_id,
            IS_END: 1
        },
        dataUrl: 'getBasicInfoGridForCX.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });

    //将form添加到表格中
    var searchTool = initWindow_htbg_zwxx_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}
/**
 * 初始化变更录入债务信息弹出框搜索区域
 */
function initWindow_htbg_zwxx_grid_searchTool() {
    //初始化查询控件
    var items = [];
    items.push(//TODO 债务单位、债务名称查询条件未实现，后端添加查询条件未实现
        {
            xtype: "treecombobox",
            name: "ZQFL_ID",
            store: DebtEleTreeStoreDB('DEBT_ZQLX'),
            displayField: "name",
            valueField: "code",
            fieldLabel: '债权类型',
            width: 250,
            labelWidth: 60,
            labelAlign: 'right',
            selectModel: 'all',
            listeners: {}
        },
        {
            xtype: 'treecombobox',
            fieldLabel: '债务类别',
            width: 250,
            labelWidth: 60,
            name: 'zwlb_id',
            displayField: 'name',
            valueField: 'code',
            rootVisible: false,
            lines: false,
            maxPicekerWidth: '100%',
            selectModel: 'all',
            store: DebtEleTreeStoreDB('DEBT_ZWLX', {condition: condition})
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'mhcx',
            width: 350,
            labelWidth: 60,
            labelAlign: 'right',
            emptyText: '请输入债务名称/单位/债务编码...',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    var key = e.getKey();
                    if (key == Ext.EventObject.ENTER) {
                        reloadGrid();
                    }
                }
            }
        }
    );
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid');
    return searchTool.create({
        items: items,
        dock: 'top',
        defaults: {
            labelWidth: 0,
            labelAlign: 'right',
            columnWidth: null,
            margin: '5 5 5 5'
        },
        // 查询按钮回调函数
        callback: function (self) {
            var store = self.up('grid').getStore();
            // 清空参数中已有的查询项
            for (var search_form_i in self.getValues()) {
                delete store.getProxy().extraParams[search_form_i];
            }
            // 向grid中追加参数
            $.extend(true, store.getProxy().extraParams, self.getValues());
            // 刷新表格
            store.loadPage(1);
        }
    });

}

/**
 * 创建合同变更录入弹出窗口
 */
function initWin_htbglrWindow() {
    var iTitle = "合同变更";
    var iWidth = window.screen.availWidth * 3 / 4;
    //var iWidth = 1000;
    var buttons;
    if (WF_STATUS == '008') {
        buttons = [
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ];
    }
    else {
        buttons = [

            {
                text: '保存',
                handler: function (btn) {
                    //保存表单数据
                    submitInfo('');
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ];
    }

    var iHeight = 550;//窗口高度
    var htbglrWindow = new Ext.Window({
        title: iTitle,
        name: 'htbglrWin',
        width: iWidth,
        height: iHeight,
        frame: true,
        constrain: true,
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: false,//大小不可改变
        plain: true,
        layout: 'fit',
        items: [initWin_htbglrTabPanel()],
        buttons: buttons,
        closeAction: 'destroy'
    });
    htbglrWindow.show();
}

/**
 * 初始化合同变更录入弹出窗口内容
 */
function initWin_htbglrTabPanel() {
    var htbglrTabPanel = Ext.create('Ext.tab.Panel', {
        name: 'EditorPanel',
        layout: 'fit',
        border: false,
        padding: '2 2 2 2',
        defaults: {
            layout: 'fit',
            border: false
        },
        items: [
            {
                title: '变更历史',
                items: initWindow_debt_htbglr_contentForm()
            },
            {
                title: '基本信息',
                items: initWin_htbglrTabPanel_Jbxx()
            },
            {
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                // layout: 'fit',
                items: initWin_ZwqxTabPanel_Jbxx_Fj()
            }
        ]
    });

    return htbglrTabPanel;
}
/**
 * 合同修改
 */
function initWin_htbglrTabPanel_Jbxx() {
    var jbxxPanel = Ext.create('Ext.form.Panel', {
        name: 'jbxxPanel',
        layout: 'fit',
        items: [
            initWin_ZwqxTabPanel_Jbxx_form()
        ]
    });

    return jbxxPanel;
}

/**
 * 加载页面数据
 * @param form
 */
function loadInfo(form) {
    form.load({
        url: 'getBasicInfo.action?ZW_ID=' + ZW_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            loadDqlx(action.result.data.SIGN_DATE);
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}


/**
 * 初始化合同变更信息表单
 */
function initWindow_debt_htbglr_contentForm() {
    try {
        return Ext.create('Ext.form.Panel', {
            //title: '详情表单',
            width: '100%',
            height: '100%',
            itemId: 'window_debt_htbglr_contentForm',
            name: 'bgxxForm',
            layout: 'anchor',
            defaults: {
                anchor: '100%',
                margin: '5 5 5 5'
            },
            defaultType: 'textfield',
            items: [
                //{ xtype: 'hiddenfield', name: 'userPageMenu.id' },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .99,

                        labelWidth: 100//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: 'container',
                            layout: 'column',
                            defaultType: 'textfield',
                            defaults: {
                                margin: '5 5 5 5',
                                columnWidth: .5,

                                labelWidth: 100//控件默认标签宽度
                            },
                            items: [{
                                fieldLabel: '<span class="required">✶</span>变更类型',
                                name: 'CHANGE_TYPE',
                                xtype: 'combobox',
                                store: DebtEleStore(json_debt_bglx),
                                displayField: "name",
                                disabled: true,
                                valueField: "id",
                                allowBlank: false,
                                value: change_type,
                                listeners: {
                                    'beforeRender': function () {
                                        var ag = Ext.ComponentQuery.query('treecombobox[name="AG_ID"]')[0];
                                        var zqr = Ext.ComponentQuery.query('treecombobox[name="ZQR_ID"]')[0];
                                        var zqr_fullname = Ext.ComponentQuery.query('textfield[name="ZQR_FULLNAME"]')[0];
                                        var zjyt = Ext.ComponentQuery.query('treecombobox[name="ZJYT_ID"]')[0];
                                        if (change_type == '1') {
                                            ag.setDisabled(true);
                                            zqr.setDisabled(false);
                                            zqr_fullname.setDisabled(false);
                                            zjyt.setDisabled(true);
                                        } else if (change_type == '2') {
                                            ag.setDisabled(false);
                                            zqr.setDisabled(true);
                                            zqr_fullname.setDisabled(true);
                                            zjyt.setDisabled(true);
                                        } else if (change_type == '3') {
                                            ag.setDisabled(true);
                                            zqr.setDisabled(true);
                                            zqr_fullname.setDisabled(true);
                                            zjyt.setDisabled(false);
                                        }

                                    }

                                }
                            },
                                {
                                    fieldLabel: '<span class="required">✶</span>变更日期',
                                    allowBlank: false,
                                    xtype: 'datefield',
                                    name: 'CHANGE_DATE',
                                    format: 'Y-m-d'
                                }
                            ]
                        }
                        , {
                            xtype: 'container',
                            layout: 'column',
                            defaultType: 'textfield',
                            defaults: {
                                margin: '5 5 5 5',
                                columnWidth: 1,

                                labelWidth: 100//控件默认标签宽度
                            },
                            items: [
                                {fieldLabel: '<span class="required">✶</span>变更原因', xtype: "textarea", allowBlank: false, name: 'CHANGE_REASON'},
                                {fieldLabel: '<span class="required">✶</span>变更要点', xtype: "textarea", allowBlank: false, name: 'CHANGE_IMPORT'}
                            ]
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    anchor: '100%',
                    title: '变更历史',
                    layout: 'fit',
                    padding: '10 5 3 10',
                    height: 200,
                    collapsible: false,
                    items: [
                        initWindow_debt_htbglr_contentForm_grid()
                    ]
                }
            ],
            listeners: {
                'beforeRender': function () {
                    if (node_type == "reviewed" || WF_STATUS == "008") {

                        SetItemReadOnly(this.items);

                    }
                }
            }
        });
    }
    catch (err) {
        // 当出现异常时，打印控制台异常

    }
}
/**
 * 初始化合同变更录入弹出表格
 */
function initWindow_debt_htbglr_contentForm_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {"dataIndex": "CHANGE_TYPE", "width": 150, "type": "string", "text": "变更类型"},
        {"dataIndex": "CHANGE_DATE", "width": 100, "type": "string", "text": "变更日期"},
        {"dataIndex": "CHANGE_USER", "width": 150, "type": "string", "text": "变更人"},
        {"dataIndex": "CHANGE_IMPORT", "width": 250, "type": "string", "text": "变更要点"},
        {"dataIndex": "CHANGE_REASON", "width": 250, "type": "string", "text": "变更原因"},
        {"dataIndex": "CHANGE_STATUS", "width": 150, "type": "string", "text": "状态"}
    ];
    var simplyGrid = new DSYGridV2();
    var grid = simplyGrid.create({
        itemId: 'grid_htbg_bgls',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: false,
        border: false,
        height: '90%',
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            ZW_ID: ZW_ID
        },
        dataUrl: 'getBglsInfo.action',
        pageConfig: {
            enablePage: false
        }
    });


    return grid;
}

function submitInfo(workflow) {

    var form = Ext.ComponentQuery.query('form[name="bgxxForm"]')[0];
    var jbxxform = Ext.ComponentQuery.query('form[name="jbxxForm"]')[0];

    var ag_id = '';
    var zjyt_id = '';
    var zqr_id = '';
    var zqr_fullname = '';
    if (change_type == '1') {
        zqr_id = jbxxform.getForm().findField('ZQR_ID').getValue();
        zqr_fullname = jbxxform.getForm().findField('ZQR_FULLNAME').getValue();


        var zqlx = jbxxform.getForm().findField('ZQFL_ID').getValue();
        if (zqlx == "0302") {
            if (zqr_id.indexOf("02") != 0 && ZQR_ID != "03") {
                Ext.Msg.alert('提示', '债权类型为0302外债转贷时，债权人只能选国际金融组织和外国政府！');
                return;
            }
        }
        else if (zqlx.indexOf("01") == 0 || zqlx.indexOf("03") == 0) {
            if (zqlx.indexOf("01") == 0 && zqr_id.indexOf("01") != 0) {
                Ext.Msg.alert('提示', '债权类型为(01)银行贷款时,债权人必须选择金融机构！');
                return;
            }
            if (zqlx.indexOf("03") == 0 && zqr_id.indexOf("04") != 0 && zqr_id.indexOf("05") != 0 && zqr_id.indexOf("06") != 0 && zqr_id.indexOf("07") != 0) {
                Ext.Msg.alert('提示', '债权类型为转贷债务时,债权人为行政、事业、融资平台公司和公用事业单位！');
                return;
            }
        }
        else if (zqlx == "0602" || zqlx == "0506") {
            if (zqr_id.indexOf("01") == 0) {
                Ext.Msg.alert('提示', '债权类型为拖欠工程款和历史集资款时,债权人不能是金融机构.！');
                return;
            }
        }


    } else if (change_type == '2') {
        ag_id = jbxxform.getForm().findField('AG_ID').getValue();
    } else if (change_type == '3') {
        zjyt_id = jbxxform.getForm().findField('ZJYT_ID').getValue();
    }

    var url;
    var params;
    if (button_name == 'INPUT') {
        url = 'saveBgxx.action';
        params = {
            wf_id: wf_id,
            node_code: node_code,
            wf_status: WF_STATUS,
            ZW_ID: ZW_ID,
            AG_ID: ag_id,
            ZQR_ID: zqr_id,
            ZJYT_ID: zjyt_id,
            ZQR_FULLNAME: zqr_fullname,
            CHANGE_TYPE: change_type
        };
    } else if (button_name == 'UPDATE') {
        url = 'updateBgxx.action';
        params = {
            wf_id: wf_id,
            node_code: node_code,
            wf_status: WF_STATUS,
            ZW_ID: ZW_ID,
            AG_ID: ag_id,
            ZQR_ID: zqr_id,
            ZQR_FULLNAME: zqr_fullname,
            ZJYT_ID: zjyt_id,
            CHANGE_TYPE: change_type,
            BG_ID: BG_ID
        };
    }


    if (form.isValid()) {
        form.submit({
            url: url,
            params: params,
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        Ext.ComponentQuery.query('window[name="htbglrWin"]')[0].close();
                        reloadGrid();
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存失败!' + action.result.message,
                    width: 200,
                    fn: function (btn) {
                        Ext.ComponentQuery.query('window[name="htbglrWin"]')[0].close();
                        reloadGrid();
                    }
                });
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}
function loadBgInfo() {
    var form = Ext.ComponentQuery.query('form[name="jbxxForm"]')[0];
    var bgxxform = Ext.ComponentQuery.query('form[name="bgxxForm"]')[0];
    form.load({
        url: 'loadBgInfo.action?BG_ID=' + BG_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            form.getForm().setValues(action.result.data[0]);
            bgxxform.getForm().setValues(action.result.data[0]);

        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}

