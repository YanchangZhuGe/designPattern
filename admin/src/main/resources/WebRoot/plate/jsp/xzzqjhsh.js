/**
 * js：新增债券计划审核
 */
bond_type_id = null;
//业务处室重新加载页签列表
tab_items_sh = sys_right_model == '1' && is_zxzqxt == 1 && is_zxzq == 1 ? {
    'jbqk': {},
    'bcsb': {},
    'tzjh': {},
    'szys': {}
} : tab_items_sh;
//全局变量  在专项债券系统下的限额库使用
var LSSWS_ID_VALUE;
var KJSWS_ID_VALUE;
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
                //新工作流下业务处室指定事务所显示
                text: sys_right_model == 1 && is_zxzqxt == 1 && is_zxzq == 1 && is_fxjh == 3 && (have_lssws || have_kjsws) ? '指定事务所' : '上传附件',
                itemId: 'zdsws',
                name: 'zdsws',
                hidden: sys_right_model == 1 && is_zxzqxt == 1 && is_zxzq == 1 && is_fxjh == 3 && sh_node != 'bm' ? false : true,
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    //显示填报框
                    choseSWS(btn);
                }
            },
            {
                xtype: 'button',
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
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
                    doWorkFlow(btn);
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
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
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
        dataUrl: '/getXzzqContentGrid.action',
        params: {
            is_fxjh: is_fxjh,
            bond_type_id: bond_type_id,
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            IS_ZXZQXT: is_zxzqxt,
            IS_ZXZQ: is_zxzq,
            menucode: menucode,
            node_type: node_type,
            HAVE_SFJG: HAVE_SFJG
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
                //store: is_zxzqxt == 1 ? (is_zxzq=='1'?DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE LIKE '02%'"}):DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE NOT LIKE '02%'"})) : DebtEleTreeStoreDB('DEBT_ZQLB'),
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                displayField: "name",
                valueField: "id",
                value: bond_type_id,
                fieldLabel: '债券类型',
                editable: false, //禁用编辑
                labelWidth: 70,
                width: 200,
                labelAlign: 'right',
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
 * 弹出业务处室选择会计事务所、律师事务所或上传附件时所需填报框
 * author:fzd
 * time:2020/05/30
 */
function choseSWS(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    //区分数据选择条数以及后续审核框的选择 true:选择一条数据进行会所、律所指定
    //增加业务处室选择会所律所功能(储备库新工作流下专项业务处审核)
    var zqlxIds = [];
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
        return false;
    }
    zqlxIds.push(records[0].get("BOND_TYPE_ID"));
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
    showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, '', []);
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    //增加业务处室选择会所律所功能(储备库新工作流下专项业务处审核)
    var zqlxIds = [];
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
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

    //业务处室选择会所、律所流程增加申报批次校验
    var sbbatch_no = records[0].data.SBBATCH_NO;
    if (is_zxzqxt == '1' && is_zxzq == '1' && !(!!sbbatch_no) && node_type == 'jhsh' && sh_node != 'bm') {
        Ext.MessageBox.alert('提示', '请选择申报批次。');
        return;
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
    showOpinion_shk(btn, ids, xm_ids, is_ends, mb_ids);
}

/**
 * 弹出含有会所、律所选择的项目信息框
 * @param btn 按钮信息
 * @param ids bill表Id集合
 * @param xm_ids 项目id集合
 * @param zqlxIds 债券类型集合
 * @param is_ends bill项目相对应is_end集合
 * @param mb_ids bill项目业务处室id集合
 * @param pszj_id bill项目评审专家集合
 * @param pfbzarray 对应评分标准集合
 */
function showOpinion(btn, ids, xm_ids, zqlxIds, is_ends, mb_ids, pszj_id, pfbzarray) {
    //获取会计事务所、律师事务所
    LSSWS_ID_VALUE = DSYGrid.getGrid('contentGrid').getSelection()[0].data.LSSWS_ID;
    KJSWS_ID_VALUE = DSYGrid.getGrid('contentGrid').getSelection()[0].data.KJSWS_ID;
    var SBBATCH_NO = DSYGrid.getGrid('contentGrid').getSelection()[0].data.SBBATCH_NO;
    //加载申报批次
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
    BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));

    sbpc_store.proxy.extraParams['BATCH_YEAR'] = BATCH_YEAR;
    sbpc_store.proxy.extraParams['BOND_TYPE'] = isNull(BATCH_BOND_TYPE_ID) ? "" : BATCH_BOND_TYPE_ID.substr(0, 2);
    sbpc_store.proxy.extraParams['AD_CODE'] = AD_CODE;
    sbpc_store.proxy.extraParams['is_fxjh'] = is_fxjh;
    sbpc_store.proxy.extraParams['TYPE'] = 'jhsh';
    sbpc_store.load();
    //发送请求获取ruleIds，显示配置的附件
    Ext.Ajax.request({
        method: 'POST',
        url: 'getFjRuleIdsByZqlx.action',
        async: false,//同步请求
        params: {
            ZQLX_ID: zqlxIds[0],
        },
        success: function (form, action) {
            var data = Ext.util.JSON.decode(form.responseText);
            var ruleIds;
            if (data.success) {
                ruleIds = data.list;//传递一个array对象
            } else {
                ruleIds = [];
            }
            var bill_id = ids[0];
            var xm_id = xm_ids[0];
            var is_end = is_ends[0];
            var mb_id = mb_ids[0];
            initWin_xmInfo_cp(xm_id, bill_id, btn.name, zqlxIds, ruleIds, is_end, mb_id, pszj_id, pfbzarray);
            var zqxxYHSTab = Ext.ComponentQuery.query('panel[itemId="xmxxTab"]')[0];
            //重新加载附件页签
            zqxxYHSTab.add({
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                scrollable: true,
                layout: 'fit',
                items: [
                    {
                        xtype: 'panel',
                        itemId: 'zqfjpzPanel',
                        layout: 'fit',
                        border: false,
                        items: initWindow_zqxxtb_contentForm_tab_xmfj({ruleIds: []})
                    }
                ]
            });
            var fjGrid = initWindow_zqxxtb_contentForm_tab_xmfj({ruleIds: ruleIds}, xm_id);
            var KJSWSCombobox = {
                xtype: 'treecombobox',
                fieldLabel: '会计事务所',
                name: 'KJSWS_ID',
                editable: true,
                displayField: 'text',
                valueField: 'id',
                selectModel: "leaf",
                rootVisible: false,
                labelWidth: 100,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                hidden: false,
                value: KJSWS_ID_VALUE,
                store: kjsws_store,
                allowBlank: true
            };
            var LSSWSCombobox = {
                xtype: 'treecombobox',
                fieldLabel: '律师事务所',
                name: 'LSSWS_ID',
                editable: true,
                displayField: 'text',
                valueField: 'id',
                selectModel: "leaf",
                rootVisible: false,
                labelWidth: 100,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                hidden: false,
                value: LSSWS_ID_VALUE,
                store: lssws_store,
                allowBlank: true
            };
            var SBBATCHCombobox = {
                xtype: 'treecombobox',
                fieldLabel: '申报批次',
                name: 'SBBATCH_NO',
                editable: true,
                displayField: 'text',
                valueField: 'id',
                selectModel: "leaf",
                rootVisible: false,
                labelWidth: 100,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                hidden: false,
                value: SBBATCH_NO,
                store: sbpc_store,
                allowBlank: true
            };
            if (have_kjsws) {
                fjGrid.dockedItems.items[1].insert(KJSWSCombobox);
            }
            if (have_lssws) {
                fjGrid.dockedItems.items[1].insert(LSSWSCombobox);
            }
            fjGrid.dockedItems.items[1].insert(SBBATCHCombobox);
            var panel = Ext.ComponentQuery.query('panel#zqfjpzPanel')[0];
            panel.removeAll(true);
            panel.add(fjGrid);
            //跳转页签
            var zqxxtbTab = Ext.ComponentQuery.query('[itemId="xmxxTab"]')[0];
            zqxxtbTab.items.get(4).show();
            /*
            //添加项目评分信息
            var tab = zqxxYHSTab.add({
                title: '项目评分',
                scrollable: true,
                layout:'fit',
                items:[
                    {
                        xtype:'panel',
                        itemId:'xmPfxxPanel',//项目评分信息面板
                        layout:'fit',
                        border:false,
                        items:[]
                    }
                ]
            });
            zqxxYHSTab.setActiveTab(tab);
            var panel2 = Ext.ComponentQuery.query('panel#xmPfxxPanel')[0];
            panel2.removeAll(true);
            //构建项目评分grid，未格式化
            var grid = initXekXMPfxxGrid(zqlxIds[0],bill_id);
            //添加到panel中，触发panel的afterlayout事件
            panel2.add(grid);*/
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}

/**
 * 显示审核意见框
 * @param btn 按钮
 * @param ids    进行审核的项目id（bill）
 * @param xm_ids    进行审核的项目xm_id集合
 * @param is_ends   项目is_end集合
 * @param mb_ids    项目的业务处室集合
 */
function showOpinion_shk(btn, ids, xm_ids, is_ends, mb_ids) {
    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text + '意见',
        value: btn.text == '审核' ? '同意' : '',
        animateTarget: btn,
        fn: function (buttonId, text) {
            if (text.length > 500) {
                Ext.MessageBox.alert('提示', btn.text + "失败！ 最多不超过500个字符");
                return;
            }
            if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/doXzzqWorkFlow.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    //AD_CODE:AD_CODE,20210425_zhuangrx_需求库项目汇总bill表不存ad_level，由汇总表存ad_level
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: text,
                    is_fxjh: is_fxjh,
                    ids: ids,
                    xm_ids: xm_ids,
                    is_ends: is_ends,
                    mb_ids: mb_ids,
                    menucode: menucode,
                    is_zxzqxt: is_zxzqxt,
                    is_zxzq: is_zxzq,
                    node_type: node_type,
                    HAVE_SFJG: HAVE_SFJG,
                    sh_node: sh_node
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

/**
 * @param xm_id
 * @param bill_id
 * @returns
 */
function initWin_xmInfo_cp(xm_id, bill_id, work_direction, zqlxIds, ruleIds, is_end, mb_id, pszj_id, pfbzarray) {

    var zwqxWindow = new Ext.Window({
        title: '项目总体情况',
        itemId: 'xmxxWin',
        width: document.body.clientWidth * 0.95,
        height: document.body.clientHeight * 0.95,
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        closeAction: 'destroy',
        layout: 'fit',
        items: [initWin_xmInfo_contentForm(tab_items_sh, xm_id, ruleIds)],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    saveJgxx(btn);
                    /*btn.name='down';
                    var ids=[bill_id];
                    var xm_ids=[xm_id];
                    var is_ends=[is_end];
                    var md_ids=[mb_id];
                    btn.up('window').close();
                    showOpinion_shk(btn, ids, xm_ids,is_ends,md_ids);*/
                    //checkAndSubmit(xm_id,bill_id,work_direction,btn,zqlxIds,is_end,mb_id,pszj_id,pfbzarray);
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    zwqxWindow.show();
    loadXmxxInfo(tab_items_sh, xm_id, bill_id);
}

/**
 * 初始化债券信息填报弹出窗口中的项目附件标签页
 */
function initWindow_zqxxtb_contentForm_tab_xmfj(config, xm_id) {
    var ruleIds = config.ruleIds;
    var editSSFA = true;
    var grid = UploadPanel.createGrid({
        busiType: 'ET001',//业务类型
        ruleIds: !((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1'))
            || is_scfjgn) ? "" : config.ruleIds,//规则id，若存在，则优先用rule_id获取附件
        //addHeaders:[{text:'上传时间',dataIndex:'UPLOAD_TIME',type:'string',index:0}],
        busiId: xm_id,//业务ID
        editable: true,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_zqxxtb_contentForm_tab_xmfj_grid_xeksb'
        }
    });
    grid.columns[0].renderer = function (value, cell, record, rowIndex, colIndex, store, view) {
        //上传提示信息
        var tipText = '小于' + record.data.MAXLIMIT / 1024 + 'MB';
        var tip = record.data.FILE_SUFFIX + tipText;
        //上传按钮，上层覆盖透明上传表单
        var uploadbtn = '<div title="' + tip + '" class="uploadpanel-btn uploadpanel-btn-upload">' +
            '<form id="uploadpanel-' + view.grid.itemId + '-uploadform-' + rowIndex + '" class="uploadForm" enctype="multipart/form-data">' +
            '<input type="submit" />' +
            '<input type="text" name="rule_id" value=""/>' +
            '<input type="text" name="busi_id" value=""/>' +
            '<input type="text" name="maxlimit" value=""/>' +
            '<input type="file" name="upload" itemId="' + view.grid.itemId + '" rowIndex="' + rowIndex + '" onchange="UploadPanel.uploadFile(this)"/>' +
            '</form></div>';
        var downloadbtn = '<div class="uploadpanel-btn uploadpanel-btn-download" onclick="UploadPanel.downloadFile(\'' + record.get("FILE_ID") + '\')"></div>';
        var deletebtn = '<div class="uploadpanel-btn uploadpanel-btn-delete" onclick="UploadPanel.deleteFile(\'' + record.get("FILE_ID") + '\',\'' + record.get("RULE_ID") + '\',\'' + record.get("FILE_NAME") + '\',\'' + view.grid.itemId + '\',\'' + rowIndex + '\')"></div>';
        //根据是否可编辑，隐藏上传/删除按钮
        //需求库（储备库中）、储备库、发行库非上传附件功能（会所、律所专用）,法律意见书、财评报告禁止上传和删除
        if ((is_fxjh == '1' || is_fxjh == '3' || is_fxjh == '2') && !is_scfjgn) {
            if (((record.data.RULE_ID && record.data.BUSI_PROPERTY_DESC && (record.data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1))
                || (!record.data.RULE_ID && record.data.UPLOAD_USER && userCode != record.data.UPLOAD_USER)) && have_lssws && have_kjsws) {
                uploadbtn = '';
                deletebtn = '';
            }
            //只存在财评报告、法律意见书的权限
            if ((record.data.RULE_ID && record.data.BUSI_PROPERTY_DESC && (record.data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") == -1))) {
                uploadbtn = '';
                deletebtn = '';
            }
        } else {
            if (!store.editable) {
                uploadbtn = '';
                deletebtn = '';
            }
        }
        var preview = ''; // 预览按钮
        //如果文件存在，隐藏上传按钮
        var fileId = record.data.FILE_ID;
        if (typeof fileId != 'undefined' && fileId != null && fileId != '') {
            uploadbtn = ''; // 存在隐藏上传按钮
            var form = record.data.FILE_NAME.split(".")[record.data.FILE_NAME.split(".").length - 1];
            if (form == 'pdf' || form == 'docx' || form == "doc") {
                preview = '<div title="预览" class="uploadpanel-btn uploadpanel-btn-preview" onclick="pdfPreviewFile(\'' + fileId + '\',\'' + form + '\')"></div>';
            }
        } else { //根据文件id是否存在，隐藏下载按钮
            downloadbtn = ''; // 不存在，隐藏下载按钮
        }
        return '<div class="uploadpanel-btsn">' + uploadbtn + downloadbtn + deletebtn + preview + '</div>';
    };
    //附件加载完成后计算总文件数，并写到页签上
    grid.getStore().on('load', function (self, records, successful) {
        //通过项目债券类型获取必录附件，在页面中显示
        var zqlx_id = DSYGrid.getGrid('contentGrid').getSelection()[0].data.BOND_TYPE_ID;
        var entryFjList;
        $.post('getFjRuleIdsByZqlx.action', {ZQLX_ID: zqlx_id, IS_ENTRY: "1"}, function (data) {
            if (data.success) {//加载成功
                var entryFjList = data.list;//传递一个array对象
                var sum = 0;
                if (records != null) {
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].data.STATUS == '已上传') {
                            sum++;
                        }
                        //专项债券需求库填报设置实施方案为必录
                        //if(is_zxzqxt=='1' && is_zxzq == '1'&& (is_fxjh!='1'&&is_fxjh!='3')){
                        if ((is_fxjh != '1' && is_fxjh != '3' && is_fxjh != '4')) {
                            if (records[i].data.BUSI_PROPERTY_DESC && records[i].data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1 && !is_scfjgn
                                && EntryFj(records[i].data.RULE_ID, entryFjList)) {
                                records[i].set("NULLABLE", "N");
                            }
                        }
                        //if(is_zxzqxt=='1' && is_zxzq == '1' && (is_fxjh=='1'||is_fxjh=='3')){
                        if ((is_fxjh == '1' || is_fxjh == '4' || is_fxjh == '3')) {
                            if (ruleIds.indexOf(records[i].data.RULE_ID) != -1) {
                                if (records[i].data.BUSI_PROPERTY_DESC && ((records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1)
                                        || records[i].data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1)
                                    && ((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3')
                                        || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1'))) && EntryFj(records[i].data.RULE_ID, entryFjList)) {
                                    records[i].set("NULLABLE", "N");
                                }
                            }
                            if (!!config.ruleIds) {
                                if (records[i].data.BUSI_PROPERTY_DESC && records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1) {
                                    if (records[i].data.FILE_ID) {
                                        editSSFA = false;
                                    }
                                }
                            }
                        }
                    }
                }
                if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
                    $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
                } else {
                    $('span.file_sum').html('(' + sum + ')');
                }
            }
        }, "json");


    });
    return grid;
}

/**
 * 保存选择的机构信息
 */
function saveJgxx(btn) {

    //获取相关信息
    var bill_id = DSYGrid.getGrid('contentGrid').getSelection()[0].data.ID;
    var lssws_id = Ext.ComponentQuery.query('treecombobox[name="LSSWS_ID"]')[0].getValue();
    var kjsws_id = Ext.ComponentQuery.query('treecombobox[name="KJSWS_ID"]')[0].getValue();
    var SBBATCH_NO = Ext.ComponentQuery.query('treecombobox[name="SBBATCH_NO"]')[0].getValue();
    //校验会所、律所必录
    if (have_lssws && !(!!lssws_id)) {
        Ext.Msg.alert('提示', "请选择律师事务所！");
        return false;
    }
    if (have_kjsws && !(!!kjsws_id)) {
        Ext.Msg.alert('提示', "请选择会计事务所！");
        return false;
    }
    if (!(!!SBBATCH_NO)) {
        Ext.Msg.alert('提示', "请选择申报批次！");
        return false;
    }
    //发送ajax请求，修改节点信息
    $.post('saveXMJgxx.action', {
        bill_id: bill_id,
        lssws_id: lssws_id,
        kjsws_id: kjsws_id,
        SBBATCH_NO: SBBATCH_NO
    }, function (data) {
        if (data.success) {
            Ext.toast({html: "保存成功！"});
            btn.up('window').close();
            //刷新主单信息
            reloadGrid();
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
        //刷新表格
    }, "json");

}