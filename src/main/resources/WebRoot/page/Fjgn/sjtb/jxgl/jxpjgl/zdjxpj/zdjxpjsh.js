/**
 * 默认数据：工具栏
 */
$.extend(zdjxpj_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            MOF_TYPE == "1" ? initContentTree() : initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child // 区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),
            //初始化左侧树
            initContentRightPanel()//初始化右侧表格
        ];
    },
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
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
                        button_name = btn.text;
                        // 判断当前所选中的数据是否是省级项目
                        // 如果是省本级项目，项目审核完以后数据直接可由主管部门查询到，（不需要进行省级重点项目绩效评价地市/区县确认功能）
                        // 但，如果所选的项目是非省本级项目（相当于省级评价地市or区县项目），需要地市or区县进行一次项目确认，数据才可以被
                        // 主管部门查询到，如果地市/区县未进行确认，则主管部门看不到本条数据
                        opinionWindow.open('NEXT', "审核意见", btn);
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'BACK',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        button_name = btn.text;
                        button_text = btn.name;
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', "退回意见", btn);
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
                text: '撤销',
                name: 'CANCEL',
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
        '004': [//被退回
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
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
                        button_name = btn.text;
                        opinionWindow.open('NEXT', "审核意见", btn);
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'BACK',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zdjxpj_contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        button_name = btn.text;
                        button_text = btn.name;
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', "退回意见", btn);
                    }
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
    open: function (action, title, btn) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btn_Box, text) {
                audit_info = text;
                if (btn_Box == "ok") {
                    if (action == 'NEXT') {
                        next(btn);
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
