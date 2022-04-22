/**
 * js：新增债券计划审核
 */
bond_type_id = null;
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
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    doWorkFlow(btn, true);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
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
            {
                xtype: 'button',
                text: '收益平衡测算',
                hidden: true,
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0 || records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    } else {
                        var xm_id = records[0].get('XM_ID');
                        var bill_id = records[0].get('ID');
                        var config = {
                            xm_id: xm_id,
                            bill_id: bill_id
                        };
                        initwindow_xmcsInfo_select(config).show();
                        loadXmsyphceInfo(records);
                    }
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
            {
                xtype: 'button',
                text: '收益平衡测算',
                hidden: true,
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0 || records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    } else {
                        var xm_id = records[0].get('XM_ID');
                        var bill_id = records[0].get('ID');
                        var config = {
                            xm_id: xm_id,
                            bill_id: bill_id
                        };
                        initwindow_xmcsInfo_select(config).show();
                        loadXmsyphceInfo(records);
                    }
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
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    doWorkFlow(btn, true);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
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
            {
                xtype: 'button',
                text: '收益平衡测算',
                hidden: true,
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0 || records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    } else {
                        var xm_id = records[0].get('XM_ID');
                        var bill_id = records[0].get('ID');
                        var config = {
                            xm_id: xm_id,
                            bill_id: bill_id
                        };
                        initwindow_xmcsInfo_select(config).show();
                        loadXmsyphceInfo(records);
                    }
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
            {
                xtype: 'button',
                text: '收益平衡测算',
                hidden: true,
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0 || records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    } else {
                        var xm_id = records[0].get('XM_ID');
                        var bill_id = records[0].get('ID');
                        var config = {
                            xm_id: xm_id,
                            bill_id: bill_id
                        };
                        initwindow_xmcsInfo_select(config).show();
                        loadXmsyphceInfo(records);
                    }
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    item_content_grid_config: {
        dataUrl: '/xzzqJhsb/getXzzqContentGridYHS.action',
        params: {
            is_fxjh: is_fxjh,
            bond_type_id: bond_type_id,
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            menucode: menucode,
            node_type: node_type,
            is_zxzq: is_zxzq
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
                allowBlank: false,
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(zqxm_json_common.items[WF_STATUS]);
                        //刷新当前表格
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "treecombobox",
                name: "BOND_TYPE_ID",
                store: is_zxzqxt == 1 ? DebtEleTreeStoreDB('DEBT_ZQLB', {
                        condition: "AND CODE NOT LIKE '01%'"
                            + (is_zxzq == '1' ? " AND CODE LIKE '02%' " : is_zxzq == '2' ? " AND CODE LIKE '01%'" : "")
                    })
                    : DebtEleTreeStoreDB('DEBT_ZQLB', {
                        condition:
                            (is_zxzq == '1' ? " AND CODE LIKE '02%' " : is_zxzq == '2' ? " AND CODE LIKE '01%'" : "")
                    }),
                displayField: "name",
                valueField: "id",
                value: bond_type_id,
                fieldLabel: '债券类型',
                editable: false, //禁用编辑
                labelWidth: 70,
                width: 200,
                labelAlign: 'right',
                hidden: true,
                listeners: {
                    change: function (self, newValue) {
                        bond_type_id = newValue;
                        reloadGrid();
                    }
                }
            }
        ]
    }
});

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
            var x = records[i].get("AD_CODE");
            var y = records[i + 1].get("AD_CODE");
            if (x != y) {
                Ext.MessageBox.alert('提示', '请选择同一单位的项目再进行操作');
                return;
            }
        }
    }
    // 弹出负责人信息
    if (fzr) {
        saveFZRxx(btn, records[0].get("AD_CODE"), records[0].get("AD_NAME"));
        return;
    }
    var ids = [];
    var xm_ids = [];
    var is_ends = [];
    var mb_ids = [];
    for (var i in records) {
        ids.push(records[i].get("ID"));
        xm_ids.push(records[i].get("XM_ID"));
        is_ends.push(records[i].get("IS_END"));
        mb_ids.push(records[i].get("MB_ID"));
    }
    button_name = btn.text;
    button_status = btn.name;
    if (button_status == 'cancel') {
        var flag = true;
        for (var i = 0; i < records.length; i++) {
            var record = records[i];
            if (parseInt(record.get("STATUS")) > 20) {
                flag = false;
                break;
            }
        }
        if (!flag) {
            Ext.MessageBox.alert('提示', '待撤销数据已完成后续流程，无法撤销！');
            return;
        }
    }
    showOpinion(btn, ids, xm_ids, is_ends, mb_ids);
}

function showOpinion(btn, ids, xm_ids, is_ends, mb_ids) {
    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text + '意见',
        value: btn.text == '审核' ? '同意' : '',
        animateTarget: btn,
        fn: function (buttonId, text) {
            if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/xzzqJhsb/doXzzqWorkFlowYHS.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    // 上报区划 需求库存在汇总表 储备库存在bill表
                    AD_CODE: is_fxjh == '0' ? '' : AD_CODE,
                    button_name: button_name,
                    audit_info: text,
                    is_fxjh: is_fxjh,
                    is_zxzq: is_zxzq,
                    ids: ids,
                    xm_ids: xm_ids,
                    is_ends: is_ends,
                    mb_ids: mb_ids,
                    menucode: menucode,
                    node_type: node_type
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        }
    });
}