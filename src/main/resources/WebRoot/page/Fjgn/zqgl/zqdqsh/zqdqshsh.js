var json_wf = [
    {"id": "001", "code": "001", "name": "未审核"},
    {"id": "002", "code": "002", "name": "已审核"},
    {"id": "008", "code": "008", "name": "曾经办"}
];

tbarItem = {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_text = btn.text;
                    button_name = btn.name;
                    doWorkFlow(btn);
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
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                name: 'cancelsh',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_text = btn.text;
                    button_name = btn.name;
                    doWorkFlow(btn);
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
                name: 'cx',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
}

function getScreenBar() {
    return [
        {
            xtype: "combobox",
            fieldLabel: '状态',
            name: 'WF_STATUS',
            store: DebtEleStore(json_wf),
            allowBlank: false,
            labelAlign: 'left',//控件默认标签对齐方式
            labelWidth: 40,
            width: 150,
            editable: false, //禁用编辑
            displayField: "name",
            valueField: "code",
            value: WF_STATUS,
            listeners: {
                'change': function (self, newValue, oldValue) {
                    WF_STATUS = newValue;
                    var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                    toolbar.removeAll();
                    toolbar.add(getTbar());
                    reloadGrid();
                }
            }
        },
        {
            xtype: "textfield",
            name: "mhcx",
            id: "mhcx",
            fieldLabel: '模糊查询',
            allowBlank: true,
            labelWidth: 70,
            width: 260,
            labelAlign: 'right',
            emptyText: '请输入项目编码/名称...',
            enableKeyEvents: true,
            listeners: {
                specialkey: function (field, e) {//监听回车事件
                    reloadGrid();
                }
            }
        },
        {
            xtype: "combobox",
            name: "YEAR",
            store: DebtEleStore(json_debt_year),
            displayField: "name",
            valueField: "id",
            width: 240,
            labelWidth: 60,
            labelAlign: 'right',
            fieldLabel: '绩效年度',
            editable: false, //禁用编辑
            enableKeyEvents: true,
            listeners: {
                specialkey: function (field, e) {//监听回车事件
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        reloadGrid();
                    }
                },
                'change': function (self, newValue, oldValue) {
                    reloadGrid();
                }
            }
        },
    ];
}

function getTbar() {
    if (AD_CODE.endWith("00") || AD_CODE.length < 3) {
        return tbarItem.items[WF_STATUS];
    } else {
        return null;
    }
}

function doWorkFlow(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    var XM_IDS = [];
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    for (var i in records) {
        XM_IDS.push(records[i].get("ZQSH_PLAN_ID"));
    }

    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text,
        animateTarget: btn,
        value: btn.name == 'down' ? '同意' : null,
        fn: function (buttonId, text) {
            if (buttonId === 'ok') {
                btn.setDisabled(true);//防止多次点击保存按钮
                //发送ajax请求，修改节点信息
                $.post("/bjsh/doZqshWorkFlow.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    button_text: button_text,
                    btn: btn.name,
                    audit_info: '',
                    ids: XM_IDS,
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_text + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                    }
                    btn.setDisabled(false);//防止多次点击保存按钮
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        }
    });
}

/**
 * 创建填写意见对话框
 */
function initWindow_opinion(config) {
    var default_config = {
        closeAction: 'destroy',
        title: null,
        buttons: Ext.MessageBox.OKCANCEL,
        width: 350,
        value: '同意',
        animateTarget: null,
        fn: null
    };
    $.extend(default_config, config);
    return Ext.create('Ext.window.MessageBox', {
        closeAction: default_config.closeAction
    }).show({
        multiline: true,
        value: default_config.value,
        width: default_config.width,
        title: default_config.title,
        animateTarget: default_config.animateTarget,
        buttons: default_config.buttons,
        fn: default_config.fn
    });
}