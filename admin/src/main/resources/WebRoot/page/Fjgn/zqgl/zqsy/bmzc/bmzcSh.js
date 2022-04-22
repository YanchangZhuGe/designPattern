/**
 * 主页面工具栏
 */
$.extend(bmzc_json_common, {
    button_items: {
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
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed()
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
                text: '撤销审核',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed()
        ]
    },
    status_store: DebtEleStore(json_debt_zt2_3)
});

/**
 * 审核、退回填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (title, btn) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = Ext.MessageBox.show({
            title: title,
            width: 350,
            value: btn.name == 'down' ? '同意' : null,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            fn: function (btnBox, text) {
                if (btnBox == "ok") {
                    doWorkFlowPost(btn, text);
                } else {
                    btn.setDisabled(false);
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