/**
 * 默认数据：工具栏
 */
$.extend(zdjxpj_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [/*(!isNull(DW_USER_AG_ID) && !isNull(DW_USER_AG_CODE)) ? [
            //重大项目绩效评价报告上传：菜单挂在单位下，单位用户不展示左侧区划树和单位树
            initContentRightPanel()//仅初始化右侧表格
        ]:[
            MOF_TYPE == "1" ? initContentTree() :*/ initContentTree({
            areaConfig: {
                params: {
                    CHILD: v_child// 区划树参数，1只显示本级，其它显示全部，默认显示全部
                }
            }
        }),
            //初始化左侧树
            initContentRightPanel()// 初始化右侧表格
            // ];
        ]
    },
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
                text: '确认',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.alert('提示', '确认后不予许撤销请确认！');
                        button_name = btn.text;
                        if (is_need_ds_qr == 'dsqx') {
                            var qrArray = [];
                            Ext.each(records, function (record) {
                                // 项目的区划编码小于6位的都是省级项目，除此以外，都是非省级项目
                                if (!(record.data.MOF_DIV_CODE.length < 6)) {
                                    var array = {};
                                    array.PJ_ID = record.get("PJ_ID");
                                    qrArray.push(array);
                                }
                            });
                        }
                        //主管部门确认
                        /*if (is_need_ds_qr == 'zgbm') {
                            var qrArray = [];
                            Ext.each(records, function (record) {
                                // 项目的区划编码小于6位的都是省级项目，除此以外，都是非省级项目
                                if (!(record.data.MOF_DIV_CODE.length < 6)) {
                                    var array = {};
                                    array.PJ_ID = record.get("PJ_ID");
                                    qrArray.push(array);
                                }
                            });
                        }*/
                        opinionWindow.open('NEXT', "确认意见", btn, qrArray);
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                hidden: is_need_ds_qr == 'dsqx' ? true : false,
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
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销确认',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    button_text = btn.name;
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
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
                                    if (is_need_ds_qr == 'dsqx') {
                                        var shArray = [];
                                        Ext.each(records, function (record) {
                                            var array = {};
                                            array.PJ_ID = record.get("PJ_ID");
                                            shArray.push(array);
                                        });
                                        // 将IS_QR字段由1改为2
                                        $.post('/zdjxpj/updateZdjxpjInfoXx.action', {
                                            shArray: Ext.util.JSON.encode(shArray)
                                        }, function (data) {
                                            if (data.success) {
                                                reloadGrid();
                                            }
                                        }, 'json');
                                    } else {
                                        back("CANCEL");
                                    }
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
                hidden: is_need_ds_qr == 'dsqx' ? true : false,
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
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
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
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action, title, btn, qrArray) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        Ext.MessageBox.alert('提示', '确认后不予许撤销请确认！');
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn_Box, text) {
                audit_info = text;
                if (btn_Box == "ok") {
                    if (action == 'NEXT') {
                        if (is_need_ds_qr == 'dsqx') {
                            // 将IS_QR字段由2改为1
                            $.post('/zdjxpj/confirmZdjxpjInfoXx.action', {
                                qrArray: Ext.util.JSON.encode(qrArray)
                            }, function (data) {
                                if (data.success) {
                                    reloadGrid();
                                }
                            }, 'json');
                        } else {
                            next(btn);
                        }
                    } else if (action == 'BACK') {
                        back("BACK");
                    }
                }
            }
        });
    },
    close: function () {
        if (this.window) {
            this.window.close();
        }
    }
};
