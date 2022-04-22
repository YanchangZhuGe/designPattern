/**
 * 项目资产录入
 */
//建设状态
var BUILD_STATUS_ID_Store = DebtEleStoreDB("DEBT_XMJSZT", {condition: " and code = '01' or code = '03' "});
//20210603LIYUE添加资产状态
var ZCZT_Store = DebtEleTreeStoreDB("DEBT_ZCZT");
//变现能力
var BXNL_ID_Store = DebtEleStore(json_debt_bxnl);
//资产性质基础数据
var ZCXZ_Store = DebtEleTreeStoreDB("DEBT_ZCXZ");
//资产类别基础数据
var ZCLB_ID_Store = DebtEleTreeStoreDB("DEBT_ZCLRLB");
//处置类型
var CZLX_ID_Store = DebtEleStoreDB('DEBT_ZCCZLX');

var sbDW_name = '';
var reasonList = [];//未形成资产原因 + 项目ID集合
$.extend(zcgl_json_common[wf_id][node_type], {
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
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
                    getHbfxDataList();
                }
            }, {
                xtype: 'button',
                text: '增加',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_ID = treeArray[1].getSelection()[0].get('id');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                   // initWindow_sbqj(AD_CODE,AG_ID);20210603liyue项目资产取消期间录入
                    chooseProjectWindow.show();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                    existingProjectStore.loadPage(1);
                }
            }, {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                    } else {
                        var XMZC_ID = records[0].get('XMZC_ID');
                        Ext.Ajax.request({
                            url: 'getUpdateXMZCDatas.action',
                            params: {
                                XMZC_ID: XMZC_ID
                            },
                            method: 'post',
                            success: function (data) {
                                var responseText = Ext.util.JSON.decode(data.responseText);
                                if (responseText.success) {
                                    zclrWindow.show();
                                    var lrGrid = DSYGrid.getGrid('zclrGrid');
                                    lrGrid.getStore().insertData(null, responseText.list)
                                    zclrWindow.window.down('form#zclrForm').getForm().setValues(responseText.form[0]);
                                } else {
                                    Ext.MessageBox.alert('提示', responseText.message);
                                }
                            }
                        });
                    }
                }
            }, {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
                    if (records < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else {
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (button) {
                            if (button == 'yes') {
                                var ids = [];
                                Ext.Array.forEach(records, function (r) {
                                    ids.push(r.get("XMZC_ID"));
                                });
                                $.post("/deleteXmzcInfo.action", {
                                    ids: ids
                                }, function (data) {
                                    if (data.success) {
                                        Ext.toast({
                                            html: "删除成功！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        reloadGrid();
                                    } else {
                                        Ext.MessageBox.alert('提示', '删除失败！')
                                    }
                                }, "json");
                            }
                        })
                    }
                }
            },
            {
                xtype: 'button',
                text: '未形成资产项目',
                name: 'wxczc',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //button_name = btn.text;
                    //20210622 fzd 未形成资产项目增加从未录入资产信息过滤，因与增加时选择项目所用方法一致
                    //使用button_name字段，查询时会重置该字段，只有未形成资产项目查询时会增加过滤，框内查询时无此字段
                    button_name = btn.name;
                    var AG_IDS = [];
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.each(records, function (record) {
                        AG_IDS.push(record.get("AG_ID"));
                    });
                    initProjectsNotFormingAssetsWindow(AG_IDS).show();
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否送审？', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            next();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                hidden : false,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    //dooperation()
                    operationRecord()
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
                    getHbfxDataList();
                }
            },
            {
                xtype: 'button',
                text: '未形成资产项目',
                name: 'wxczc',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //button_name = btn.text;
                    button_name = btn.name;
                    var AG_IDS = [];
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.each(records, function (record) {
                        AG_IDS.push(record.get("AG_ID"));
                    });
                    initProjectsNotFormingAssetsWindow(AG_IDS).show();
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return false;
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
                hidden : false,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    //dooperation()
                    operationRecord()
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
                    getHbfxDataList();
                }
            }, {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                    } else {
                        var XMZC_ID = records[0].get('XMZC_ID');
                        Ext.Ajax.request({
                            url: 'getUpdateXMZCDatas.action',
                            params: {
                                XMZC_ID: XMZC_ID
                            },
                            method: 'post',
                            success: function (data) {
                                var responseText = Ext.util.JSON.decode(data.responseText);
                                if (responseText.success) {
                                    zclrWindow.show();
                                    var lrGrid = DSYGrid.getGrid('zclrGrid');
                                    lrGrid.getStore().insertData(null, responseText.list)
                                    zclrWindow.window.down('form#zclrForm').getForm().setValues(responseText.form[0]);
                                } else {
                                    Ext.MessageBox.alert('提示', responseText.message);
                                }
                                console.log(WF_STATUS);
                            }
                        });
                    }
                }
            }, {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
                    if (records < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else {
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (button) {
                            if (button == 'yes') {
                                var ids = [];
                                Ext.Array.forEach(records, function (r) {
                                    ids.push(r.get("XMZC_ID"));
                                });
                                $.post("/deleteXmzcInfo.action", {
                                    ids: ids
                                }, function (data) {
                                    if (data.success) {
                                        Ext.toast({
                                            html: "删除成功！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        reloadGrid();
                                    } else {
                                        Ext.MessageBox.alert('提示', '删除失败！')
                                    }
                                }, "json");
                            }
                        })
                    }
                }
            },
            {
                xtype: 'button',
                text: '未形成资产项目',
                name: 'wxczc',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //button_name = btn.text;
                    button_name = btn.name;
                    var AG_IDS = [];
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.each(records, function (record) {
                        AG_IDS.push(record.get("AG_ID"));
                    });
                    initProjectsNotFormingAssetsWindow(AG_IDS).show();
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    //获取表格被选中行
                    var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return false;
                    }
                    Ext.Msg.confirm('提示', '请确认是否送审？', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            next();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                hidden : false,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    //dooperation()
                    operationRecord()
                }
            }
        ],
        '008': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    getHbfxDataList();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                hidden : false,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    //dooperation()
                    operationRecord()
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});

//主表
function initXMZCTBGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            "dataIndex": "AG_ID",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "AG_ID",
            "text":"单位id",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "SYDWXZ_ID",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "AG_CODE",
            "text":"单位编码",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "XMZC_ID",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "XM_ID",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "BUILD_STATUS_ID",
            "type": "string",
            'hidden': true
        },
        {
            "dataIndex": "AD_NAME",
            "type": "string",
            "text": "地区",
            "width": 100
        },
        {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "项目单位",
            "width": 150
        },
        {
            "dataIndex": "XM_NAME",
            "width": 330,
            "type": "string",
            "text": "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            "dataIndex": "USE_UNIT",
            "width": 150,
            "type": "string",
            "text": "管理(使用)单位"
        },
        {
            "dataIndex": "XMLX_NAME",
            "width": 150,
            "type": "string",
            "text": "项目类型"
        },
        {
            "dataIndex": "SBQJ_NAME",
            "width": 150,
            "type": "string",
            "align": 'right',
            'hidden': true,
            "text": "上报期间"
        },
        {
            "dataIndex": "END_DATE_ACTUAL",
            "width": 150,
            "type": "string",
            "align": 'right',
            "text": "竣工时间"
        },
        {
            "header": "项目总投资金额(万元)",
            'colspan': 2,
            'align': 'center',
            'columns': [{
                "dataIndex": "XMTZ_AMT",
                "width": 150,
                "type": "float",
                "text": "合计"
            }, {
                "dataIndex": "XMTZ_YB_AMT",
                "width": 150,
                "type": "float",
                "text": "其中一般债务"
            }, {
                "dataIndex": "XMTZ_ZX_AMT",
                "width": 150,
                "type": "float",
                "text": "专项债务"
            }, {
                "dataIndex": "CZAP_AMT",//20210630 jiafy 添加财政安排资金
                "width": 150,
                "type": "float",
                "text": "财政安排资金"
            }, {
                "dataIndex": "PTRZ_AMT",//20210630 jiafy 添加配套融资资金
                "width": 150,
                "type": "float",
                "text": "配套融资资金"
            }, {
                "dataIndex": "QITA_AMT",
                "width": 150,
                "type": "float",
                "text": "其他资金"
            }]
        },
        {
            "header": "资产价值(万元)",
            'colspan': 2,
            'align': 'center',
            'columns': [{
                "dataIndex": "ZJYZ",
                "width": 150,
                "type": "float",
                "text": "原值"
            }, {
                "dataIndex": "ZCJZ",
                "width": 150,
                "type": "float",
                "text": "净值"
            }, {
                "dataIndex": "YGJZ",
                "width": 150,
                "type": "float",
                "text": "预估价值"
            }]
        },
        {
            "dataIndex": "CZSR",
            "width": 190,
            "type": "float",
            "text": "本期资产处置收入(万元)"
        },
        {
            "dataIndex": "DYDB",
            "width": 220,
            "type": "float",
            "text": "抵押质押及担保金额(万元)"
        },
        {
            "dataIndex": "REMARK",
            "width": 200,
            "type": "string",
            "text": "备注"
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'zctbGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: {
            rowNumber: true
        },
        checkBox: true,
        border: false,
        flex: 1,
        tbar:[
            {
                xtype: "combobox",
                fieldLabel: '状态',
                name: 'SB_STATUS',
                store: DebtEleStore(json_debt_zt0),
                allowBlank: false,
                labelAlign: 'left',//控件默认标签对齐方式
                labelWidth: 40,
                width: '170',
                editable: false, //禁用编辑
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(zcgl_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        //reloadGrid();
                        getHbfxDataList();
                    }
                }
            },
        /*    {
                fieldLabel: '上报期间',//20210603资产填报取消期间录入
                name: 'SBQJ',
                id: 'SBQJ',
                labelAlign: 'right',
                xtype: 'combobox',
                editable: false,
                labelWidth: 80,
                displayField: 'name',
                valueField: 'code',
                store: DebtEleTreeStoreDBTable('dsy_v_ele_period_xmsz'),
                listeners: {
                    change: function (self, newValue) {
                        getHbfxDataList();                    }
                }
            },*/
            {
                xtype: "textfield",
                name: "mhcx",
                fieldLabel: '模糊查询',
                allowBlank: true,  // requires a non-empty value
                labelWidth: 70,
                width: 260,
                labelAlign: 'left',
                emptyText: '请输入单位名称/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            reloadGrid();
                        }
                    }
                }
            }
        ],
        autoLoad: false,
        params: {
            AD_CODE: '',
            mhcx: '',
            SBQJ:'',
            AG_ID: '',
            SB_STATUS: '',
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            NODE_CODE: node_code,
            NODE_TYPE:node_type,
            USERCODE:userCode,
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        },
        dataUrl: 'getXmzcGrid.action',
        pageConfig: {
            pageNum: true, //设置显示每页条数
            enablePage: true
        },
        listeners: {
            itemclick: function (self, record, index, eOpts) {
                var mxGrid = DSYGrid.getGrid('zcmxGrid');
                var mxStore = mxGrid.getStore();
                var XMZC_ID = record.get('XMZC_ID');
                mxStore.getProxy().extraParams["XMZC_ID"] = XMZC_ID;
                mxStore.loadPage(1);
            }
        }
    });
}

//创建已有项目表格
function existingProjectGrid() {
    var headerJson = [
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区", "width": 100},
        {"dataIndex": "AG_NAME", "type": "string", "text": "项目单位", "width": 200},
        {
            "dataIndex": "XM_NAME", "width": 330, "type": "string", "text": "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {"text": "管理(使用)单位", "dataIndex": "USE_UNIT", "type": "string", "width": 200},
        {"text": "项目类型", "dataIndex": "XMLX_NAME", "type": "string", "width": 150,},
        {"text": "项目性质ID", "dataIndex": "XMXZ_ID", "type": "string", hidden: true},
        {"text": "项目性质", "dataIndex": "XMXZ_NAME", "type": "string", width: 170},
        {
            "dataIndex": "BUILD_STATUS_ID", "type": "string", hidden: true
        }, {
            "dataIndex": "BUILD_STATUS_NAME", "width": 150, "type": "string", "text": "建设状态"
        },
        {"dataIndex": "END_DATE_ACTUAL", "width": 150, "type": "string", "text": "竣工时间"},
        {
            "header": "项目总投资金额(万元)", 'colspan': 2, 'align': 'center',
            'columns': [
                {"type": "float", "text": "合计", "dataIndex": "XMTZ_AMT", width: 150},
                {"dataIndex": "XMTZ_YB_AMT", "width": 150, "type": "float", "text": "其中一般债务"},
                {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务"},
                //2021/06/03 jiafy 添加财政安排资金，配套融资资金，其他资金
                {"dataIndex": "XMTZ_CZAP_AMT", "width": 150, "type": "float", "text": "财政安排资金"},
                {"dataIndex": "XMTZ_PTRZ_AMT", "width": 150, "type": "float", "text": "配套融资资金"},
                {"dataIndex": "QITA_AMT", "width": 150, "type": "float", "text": "其他资金"}
            ]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'existingProjectGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        autoLoad: false,
        params: {
            AD_CODE: '',
            AG_ID: '',
            mhcx_xm: '',
            xmlx_id: '',
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        },
        //顶部工具条
        tbar: [
            {
                xtype: "treecombobox",
                name: "xmlx_id",
                id: 'xmlx_id',
                fieldLabel: '项目类型',
                displayField: 'name',
                valueField: 'code',
                selectModel: 'all',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                labelWidth: 70,
                width: 220,
                labelAlign: 'right',
                editable: false,
                allowBlank: true,
      /*          triggers:{
                    clear: {
                        cls: Ext.baseCSSPrefix + 'form-clear-trigger',
                        handler: function(self) {
                            self.setValue('');
                        }
                    }
                }*/
            },
          /*  {
                fieldLabel: '上报期间',
                name: 'SBQJ',
                id: 'SBQJ',
                labelAlign: 'right',
                xtype: 'combobox',
                editable: false,
                labelWidth: 80,
                displayField: 'name',
                valueField: 'code',
                store: DebtEleStoreDB('DEBT_SBQJ'),
                listeners: {
                change: function (self, newValue) {
                        var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                        var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                        var SBQJ = Ext.ComponentQuery.query('combobox#SBQJ')[0].getValue();
                        var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                        existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                        existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                        existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                        existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                        existingProjectStore.getProxy().extraParams['SBQJ'] = SBQJ;//20210525LIYUR添加期间过滤
                        existingProjectStore.getProxy().extraParams['dwRoleType'] = dwRoleType;//20210522 fzd 增加单位权限
                        existingProjectStore.loadPage(1);
                }
            }
            },*/
            {
                xtype: "textfield",
                name: "mhcx_xm",
                id: 'mhcx_xm',
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 240,
                labelAlign: 'right',
                emptyText: '请输入单位名称/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                            var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                            //var SBQJ = Ext.ComponentQuery.query('combobox#SBQJ')[0].getValue();
                            var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                            existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                            existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                            existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                            existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                            existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                            //existingProjectStore.getProxy().extraParams['SBQJ'] = SBQJ;//20210525LIYUR添加期间过滤
                            existingProjectStore.getProxy().extraParams['dwRoleType'] = dwRoleType;//20210522 fzd 增加单位权限
                            existingProjectStore.loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                    var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                    //var SBQJ = Ext.ComponentQuery.query('combobox#SBQJ')[0].getValue();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                    existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                    existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                    //existingProjectStore.getProxy().extraParams['SBQJ'] = SBQJ;
                    existingProjectStore.getProxy().extraParams['dwRoleType'] = dwRoleType;//20210522 fzd 增加单位权限
                    existingProjectStore.loadPage(1);
                }
            }
        ],
        dataUrl: 'getExistProjectGrid.action',
        pageConfig: {
            enablePage: true//设置分页为false
            //pageNum: true
        }
    });
}

//创建未形成资产项目窗口
function initProjectsNotFormingAssetsWindow(AG_IDS) {
    return Ext.create('Ext.window.Window', {
        height: document.body.clientHeight * 0.9,
        width: document.body.clientWidth * 0.9,
        title: '未形成资产项目',
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'fit',
        items: [projectsNotFormingAssetsGrid(AG_IDS)],
        buttons: [
        ]
    });
}

//创建未形成资产项目表格
function projectsNotFormingAssetsGrid(AG_IDS) {
    var headerJson = [
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区", "width": 100},
        {"dataIndex": "AG_NAME", "type": "string", "text": "项目单位", "width": 200},
        {
            "dataIndex": "XM_NAME", "width": 330, "type": "string", "text": "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {"text": "未形成资产原因", "dataIndex": "WXCZC_REASON", "type": "string", "width": 150,hidden:true},
        {"text": "管理(使用)单位", "dataIndex": "USE_UNIT", "type": "string", "width": 200},
        {"text": "项目类型", "dataIndex": "XMLX_NAME", "type": "string", "width": 150,},
        {"text": "项目性质ID", "dataIndex": "XMXZ_ID", "type": "string", hidden: true},
        {"text": "项目性质", "dataIndex": "XMXZ_NAME", "type": "string", width: 170},
        {
            "dataIndex": "BUILD_STATUS_ID", "type": "string", hidden: true
        }, {
            "dataIndex": "BUILD_STATUS_NAME", "width": 150, "type": "string", "text": "建设状态"
        },
        {"dataIndex": "END_DATE_ACTUAL", "width": 150, "type": "string", "text": "竣工时间"},
        {
            "header": "项目总投资金额(万元)", 'colspan': 2, 'align': 'center',
            'columns': [
                {"type": "float", "text": "合计", "dataIndex": "XMTZ_AMT", width: 150},
                {"dataIndex": "XMTZ_YB_AMT", "width": 150, "type": "float", "text": "其中一般债务"},
                {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务"}]
        }

    ];
    return DSYGrid.createGrid({
        itemId: 'projectsNotFormingAssetsGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        autoLoad: true,
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_IDS,
            mhcx_xm: '',
            xmlx_id: '',
            button_name:button_name
        },
        //顶部工具条
        tbar: [
            {
                xtype: "treecombobox",
                name: "xmlx_id",
                id: 'xmlx_id',
                fieldLabel: '项目类型',
                displayField: 'name',
                valueField: 'code',
                selectModel: 'all',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                labelWidth: 70,
                width: 220,
                labelAlign: 'right',
                editable: false,
                allowBlank: true
  /*              triggers:{
                    clear: {
                        cls: Ext.baseCSSPrefix + 'form-clear-trigger',
                        handler: function(self) {
                            self.setValue('');
                        }
                    }
                }*/
            },
            {
                xtype: "textfield",
                name: "mhcx_xm",
                id: 'mhcx_xm',
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 240,
                labelAlign: 'right',
                emptyText: '请输入单位名称/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                            var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                            //var SBQJ = Ext.ComponentQuery.query('combobox#SBQJ')[0].getValue();
                            var projectsNotFormingAssetsStore = DSYGrid.getGrid('projectsNotFormingAssetsGrid').getStore();
                            projectsNotFormingAssetsStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                            projectsNotFormingAssetsStore.getProxy().extraParams['AG_ID'] = AG_IDS;
                            projectsNotFormingAssetsStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                            projectsNotFormingAssetsStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                           // projectsNotFormingAssetsStore.getProxy().extraParams['SBQJ'] = SBQJ;
                            //20210622 fzd 增加未形成资产项目查询过滤
                            projectsNotFormingAssetsStore.getProxy().extraParams['button_name'] = button_name;
                            projectsNotFormingAssetsStore.loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                    var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                    //var SBQJ = Ext.ComponentQuery.query('combobox#SBQJ')[0].getValue();
                    var projectsNotFormingAssetsStore = DSYGrid.getGrid('projectsNotFormingAssetsGrid').getStore();
                    projectsNotFormingAssetsStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    projectsNotFormingAssetsStore.getProxy().extraParams['AG_ID'] = AG_IDS;
                    projectsNotFormingAssetsStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                    projectsNotFormingAssetsStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                   // projectsNotFormingAssetsStore.getProxy().extraParams['SBQJ'] = SBQJ;
                    //20210622 fzd 增加未形成资产项目查询过滤
                    projectsNotFormingAssetsStore.getProxy().extraParams['button_name'] = button_name;
                    projectsNotFormingAssetsStore.loadPage(1);
                }
            }
        ],
        dataUrl: 'getExistProjectGrid.action',
        pageConfig: {
            enablePage: true//设置分页为false
        }
    });
}

function initChooseProjectWindow() {
    return Ext.create('Ext.window.Window', {
        height: document.body.clientHeight * 0.9,
        width: document.body.clientWidth * 0.9,
        title: '选择已有项目',
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'fit',
        items: [existingProjectGrid()],
        buttons: ['->',
            {
                xtype: 'button',
                text: '确定',
                name: 'OK',
                handler: function (btn) {

                    var existingProjectgrid = DSYGrid.getGrid('existingProjectGrid');
                    var record = existingProjectgrid.getSelectionModel().getSelection();
                    if (record.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择一个单位在进行操作！');
                        return;
                    }
                    btn.up('window').close();
                    if (record[0].data.USE_UNIT == '') {
                        record[0].data.USE_UNIT = record[0].data.AG_NAME;
                    }
                    zclrWindow.show();
                    zclrWindow.window.down('form#zclrForm').getForm().setValues(record[0].data);
                    DSYGrid.getGrid('zclrGrid').getStore().insertData(null, {});
                }
            }, {
                xtype: 'button',
                text: '取消',
                name: 'CLOSE',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                chooseProjectWindow.window = null;
            }
        }
    });
}
//创建已有项目选择窗口
var chooseProjectWindow = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initChooseProjectWindow();
        }
        this.window.show();
    }
};
//创建资产录入窗口form
function initZclrForm() {
    store_temp = Ext.create('Ext.data.Store', {
        fields: ['id', 'code', 'name'],
        proxy: {
            type: 'ajax',
            url: 'getJldwName.action',
            method: "POST",
            params:{
                code: zclb_id_temp
            },
            reader: {
                type: 'json',
                root: 'resultList'
            }
        },
        autoLoad: false
    });
    return Ext.create('Ext.form.Panel', {
        itemId: 'zclrForm',
        layout: 'vbox',
        defaults: {
            width: '100%',
            margin: '2 0 2 5'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                width: '100%',
                layout: 'column',
                border: false,
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 120,
                    columnWidth: .33,
                    labelAlign: 'left',
                    padding: '2 5 2 5'
                },
                items: [{
                    xtype: 'textfield',
                    name: 'AG_ID',
                    hidden: true
                }, {
                    xtype: 'textfield',
                    name: 'AD_CODE',
                    hidden: true
                }, {
                    xtype: 'textfield',
                    name: 'AG_CODE',
                    hidden: true
                }, {
                    xtype: 'textfield',
                    name: 'XM_ID',
                    hidden: true
                }, {
                    xtype: 'textfield',
                    name: 'XMZC_ID',
                    hidden: true
                }, {
                    xtype: 'textfield',
                    name: 'AD_NAME',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    width: '30%',
                    emptyText: '',
                    fieldLabel: '地区'
                }, {
                    xtype: 'textfield',
                    name: 'AG_NAME',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    width: '30%',
                    emptyText: '',
                    fieldLabel: '项目单位'
                }, {
                    xtype: 'textfield',
                    name: 'XM_CODE',
                    width: '30%',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    emptyText: '',
                    fieldLabel: '项目编码'
                }, {
                    xtype: 'textfield',
                    name: 'XM_NAME',
                    width: '30%',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    emptyText: '',
                    fieldLabel: '项目名称'
                }, {
                    xtype: 'textfield',
                    name: 'USE_UNIT',
                    width: '30%',
                    emptyText: '',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    allowBlank: false,
                    fieldLabel: '管理(使用)单位'
                }, {
                    xtype: 'treecombobox',
                    name: 'SYDWXZ_ID',
                    width: '30%',
                    displayField: 'name',
                    valueField: 'code',
                    allowBlank: true,
                    editable: false,
                    hidden: true,
                    store: DebtEleTreeStoreDB('DEBT_XMDWXZ'),
                    selectModel: 'leaf',
                    fieldLabel: '使用单位性质'
                }, {
                    xtype: 'textfield',
                    name: 'XMLX_NAME',
                    width: '30%',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    emptyText: '',
                    fieldLabel: '项目类型'
                }, {
                    xtype: 'textfield',
                    name: 'XMXZ_NAME',
                    width: '30%',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    emptyText: '',
                    fieldLabel: '项目性质'
                }, {
                    xtype: 'combobox',
                    name: 'BUILD_STATUS_ID',
                    width: '30%',
                    displayField: 'name',
                    valueField: 'code',
                    allowBlank: false,
                    editable: false,
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    store: DebtEleStore(json_debt_jszt),
                    fieldLabel: '建设状态'

                }, {
                    xtype: 'datefield',
                    format: 'Y-m-d',
                    name: 'END_DATE_ACTUAL',
                    width: '30%',
                    allowBlank: true,
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    fieldLabel: '竣工时间'
                }, {
                    xtype: 'numberFieldFormat',
                    decimalPrecision: 2,
                    name: 'XMTZ_AMT',
                    width: '30%',
                    emptyText: '',
                    hideTrigger: true,
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    fieldLabel: '项目总投资(万元)',
                    listeners: {
                        'change': function () {
                            var form = Ext.ComponentQuery.query('form[itemId="zclrForm"]')[0].getForm();
                            var XMTZ_AMT = form.findField('XMTZ_AMT').getValue();
                            var XMTZ_YB_AMT = form.findField('XMTZ_YB_AMT').getValue();
                            var XMTZ_ZX_AMT = form.findField('XMTZ_ZX_AMT').getValue();
                            var QT_AMT = form.findField('QT_AMT').getValue();
                            //form.findField('QITA_AMT').setValue(XMTZ_AMT - XMTZ_YB_AMT - XMTZ_ZX_AMT - QT_AMT);
                            form.findField('QITA_AMT').setValue(accSubPro(XMTZ_AMT,XMTZ_YB_AMT,XMTZ_ZX_AMT,QT_AMT));
                        }
                    }
                }, {
                    xtype: 'numberfield',
                    decimalPrecision: 2,
                    name: 'XMTZ_YB_AMT',
                    width: '30%',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    emptyText: 0.00,
                    fieldLabel: '其中一般债务(万元)'
                }, {
                    xtype: 'numberFieldFormat',
                    name: 'XMTZ_ZX_AMT',
                    decimalPrecision: 2,
                    width: '30%',
                    readOnly: true,
                    fieldCls: 'form-unedit',
                    maxValue: 9999999999.99,
                    minValue: 0,
                    emptyText: '',
                    fieldLabel: '专项债务(万元)'
                }, {
                    xtype: 'numberFieldFormat',
                    decimalPrecision: 2,
                    name: 'QT_AMT',
                    width: '30%',
                    maxValue: 9999999999.99,
                    minValue: 0,
                    hideTrigger: true,
                    emptyText: '',
                    value:"0",
                    hidden: true,
                    fieldLabel: '其他财政性资金(万元)',
                    listeners: {
                        'change': function () {
                            var form = Ext.ComponentQuery.query('form[itemId="zclrForm"]')[0].getForm();
                            var XMTZ_AMT = form.findField('XMTZ_AMT').getValue();
                            var XMTZ_YB_AMT = form.findField('XMTZ_YB_AMT').getValue();
                            var XMTZ_ZX_AMT = form.findField('XMTZ_ZX_AMT').getValue();
                            var QT_AMT = form.findField('QT_AMT').getValue();
                            //form.findField('QITA_AMT').setValue(XMTZ_AMT - XMTZ_YB_AMT - XMTZ_ZX_AMT - QT_AMT);
                            form.findField('QITA_AMT').setValue(accSubPro(XMTZ_AMT,XMTZ_YB_AMT,XMTZ_ZX_AMT,QT_AMT));
                        }
                    }
                }, {
                    xtype: 'numberFieldFormat',//20210630 jiafy 添加
                    decimalPrecision: 2,
                    name: 'XMTZ_CZAP_AMT',
                    width: '30%',
                    maxValue: 9999999999.99,
                    minValue: 0,
                    emptyText: '',
                    fieldCls: 'form-unedit',
                    readOnly: true,
                    fieldLabel: '财政安排资金(万元)'
                }, {
                    xtype: 'numberFieldFormat',//20210630 jiafy 添加
                    decimalPrecision: 2,
                    name: 'XMTZ_PTRZ_AMT',
                    width: '30%',
                    maxValue: 9999999999.99,
                    minValue: 0,
                    emptyText: '',
                    fieldCls: 'form-unedit',
                    readOnly: true,
                    fieldLabel: '配套融资资金(万元)'
                }, {
                    xtype: 'numberFieldFormat',
                    decimalPrecision: 2,
                    name: 'QITA_AMT',
                    width: '30%',
                    maxValue: 9999999999.99,
                    minValue: 0,
                    emptyText: '',
                    fieldCls: 'form-unedit',
                    readOnly: true,
                    fieldLabel: '其他资金(万元)'
                },
                    {
                        xtype: "datefield",
                        name: "QD_DATE",
                        fieldLabel: '<span class="required">✶</span>取得日期',
                        allowBlank: false,
                        value:today,
                        displayField: 'name',
                        format: 'Y-m-d',
                        listeners:{
                            change: function (self, newValue) {

                            }
                        }
                    },

                    {
                    xtype: 'textfield',
                    name: 'REMARK',
                    columnWidth: '.99',
                    emptyText: '',
                    fieldLabel: '备注',
                    maxLength: '500'
                }]
            },
            initXMZCLRGrid()
        ]

    });
}
var zclrWindow = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initZclrWindow();
        }
        this.window.show();
    }
};
//创建资产录入或修改窗口
function initZclrWindow() {
    return Ext.create('Ext.window.Window', {
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        title: button_name == "增加"?'资产录入':"资产修改",
        layout: 'fit',
        modal: true,
        maximizable: true,
        closeAction: 'destroy',
        items: [initZclrForm()],
        buttons: [
            {
                text: '增行',
                xtype: 'button',
                name: 'addLine',
                handler: function (btn) {
                    btn.up('window').down('grid').insertData(null, {});
                }
            }, {
                text: '删行',
                xtype: 'button',
                itemId: 'deleteLine',
                name: 'deleteLine',
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('window').down('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }, {
                xtype: 'button',
                text: '保存',
                name: 'OK',
                handler: function (btn) {
                    btn.setDisabled(true);
                    //当前日期
                    var myDate = new Date();
                    var curDate=Ext.Date.format(myDate, 'Y-m-d');
                    //获取form中内容 并做校验
                    var form = btn.up('window').down('form#zclrForm').getForm();
                    if (!form.isValid()) {
                        if(!!form){
                            var newformValues = form.getValues();
                            if(newformValues.QITA_AMT<0){
                                Ext.MessageBox.alert('提示', '其他资金不能为负数');
                                btn.setDisabled(false);
                                return;
                            }
                        }
                        Ext.toast({
                            html: "请检查必填项，以及未通过校验项！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        btn.setDisabled(false);
                        return false;
                    }
                    var formValues = form.getValues();
                    if (formValues.USE_UNIT == '' || formValues.SYDWXZ_ID == '' || formValues.BUILD_STATUS_ID == '') {
                        Ext.MessageBox.alert('提示', '*为必输项!');
                        btn.setDisabled(false);
                        return;
                    }
                    if ( formValues.BUILD_STATUS_ID == '04' || formValues.BUILD_STATUS_ID == '03') {
                        if (formValues.END_DATE_ACTUAL == '') {
                            Ext.MessageBox.alert('提示', '当前建设状态下，竣工日期不可为空！');
                            btn.setDisabled(false);
                            return;
                        }
                        if(!(formValues.END_DATE_ACTUAL == '') && (formValues.END_DATE_ACTUAL > curDate )){
                            Ext.MessageBox.alert('提示', '竣工日期不能大于当前日期！');
                            btn.setDisabled(false);
                            return;
                        }
                    }

                    //如果未输入其他财政性资金  则将其初始化为0
                    if(formValues.QT_AMT==undefined || formValues.QT_AMT=='' || Number(formValues.QT_AMT) == NaN){
                        formValues.QT_AMT=0;
                    }
                    //如果未输入其他资金  则将其初始化为0
                    if(formValues.QITA_AMT==undefined || formValues.QITA_AMT=='' || Number(formValues.QITA_AMT) == NaN){
                        formValues.QITA_AMT=0;
                    }
                    if(formValues.QITA_AMT<0){
                        Ext.MessageBox.alert('提示', '其他资金不能为负数');
                        btn.setDisabled(false);
                        return;
                    }
                    //20210630 jiafy 修改合计判断及提示
                    var xmtz_yb_zx=accAdd(formValues.XMTZ_YB_AMT,formValues.XMTZ_ZX_AMT);
                    var qt=accAdd(accAdd(formValues.XMTZ_CZAP_AMT,formValues.XMTZ_PTRZ_AMT),formValues.QITA_AMT);
                    var result=accAdd(xmtz_yb_zx*1000,qt*1000)/1000;
                    if(Math.abs(formValues.XMTZ_AMT-result)>0.01){
                        Ext.MessageBox.alert('提示', '一般债务、专项债务、财政安排资金、配套融资计划、其他资金之和必须等于项目总投资');
                        btn.setDisabled(false);
                        return;
                    }
                    /*if (Number(formValues.XMTZ_AMT) - (Number(formValues.XMTZ_YB_AMT)*10000 + Number(formValues.XMTZ_ZX_AMT)*10000 +Number(formValues.QT_AMT)*10000 + Number(formValues.QITA_AMT)*10000)/10000) {
                        Ext.MessageBox.alert('提示', '一般债务、专项债务、其他财政性资金、其他资金之和必须等于项目总投资');
                        btn.setDisabled(false);
                        return;
                    }*/
                    var mxData = [];
                    var flag = false;
                    var message = '';
                    var store = DSYGrid.getGrid('zclrGrid').getStore();
                    var data = store.data.items;

                    if (data.length == 0) {
                        Ext.MessageBox.alert('提示', '请添加项目资产明细数据！');
                        btn.setDisabled(false);
                        return;
                    }
                    Ext.Array.forEach(data, function (value) {
                        //alert(value.data.ZCXZ_ID);
                        //alert(value.data.BUILD_STATUS_ID);
                        if(value.data.XMZC_NAME == '') {
                            flag = true;
                            message = '资产名称不能为空！';
                            return;
                        }
                        if(value.data.XMZC_NAME.length>180 ) {
                            flag = true;
                            message = '资产名称超长！';
                            return;
                        }
                        if (value.data.ZCXZ_ID == '') {
                            flag = true;
                            message = '资产性质不能为空！';
                            return;
                        }
                        if (value.data.BXNL_ID == '') {
                            flag = true;
                            message = '变现能力不能为空！';
                            return;
                        }
                        if (value.data.BUILD_STATUS_ID == '') {
                            flag = true;
                            message = '建设状态不能为空！';
                            return;
                        }
                        if ( value.data.ZCLB_ID != '' && (value.data.ZCLB_ID.indexOf('05') == 0 || value.data.ZCLB_ID.indexOf('06') == 0) && !(value.data.YGJZ_AMT > 0)) {
                            flag = true;
                            message = '资产类别为05或06时 ,预估价值不能为空！';
                            return;
                        }
                        if (value.data.ZCLB_ID == '') {
                            flag = true;
                            message = '表格中资产类别不能为空';
                            return;
                        }
                        if (value.data.RZ_DATE == '' || value.data.RZ_DATE == undefined) {
                            flag = true;
                            message = '转固/入账时间日期不能为空';
                            return;
                        }
                        if (!(value.data.ZC_NUM > 0)) {
                            flag = true;
                            message = '表格中数量必须大于0';
                            return;
                        }
                        if (!(value.data.RZ_DATE =='') && (value.data.RZ_DATE > curDate) ) {
                            flag = true;
                            message = '表格中转固/入账时间不能大于当前日期';
                            return;
                        }
                        if (!(value.data.ZJYZ_AMT >0)) {
                            flag = true;
                            message = '表格中资产原值必须大于0';
                            return;
                        }
                        if (!(value.data.ZCJZ_AMT >0) ) {
                            flag = true;
                            message = '表格中资产净值必须大于0';
                            return;
                        }
                        if (!(value.data.ZCJZ_AMT <= value.data.ZJYZ_AMT) ) {
                            flag = true;
                            message = '表格中资产净值必须小于等于资产原值';
                            return;
                        }
                        mxData.push(value.data)
                    });
                    if (flag) {
                        Ext.MessageBox.alert('提示', message);
                        btn.setDisabled(false);
                        return;
                    }
                    //发送请求保存对应信息
                    Ext.Ajax.request({
                        url: 'addOrUpdateXmzcInfo.action',
                        params: {
                            button_name: button_name,
                            mxData: Ext.util.JSON.encode(mxData),
                            AD_CODE: formValues.AD_CODE,
                            AG_NAME: formValues.AG_NAME,
                            BUILD_STATUS_ID: formValues.BUILD_STATUS_ID,
                            END_DATE_ACTUAL: formValues.END_DATE_ACTUAL,
                            QT_AMT: formValues.QT_AMT,
                            QITA_AMT: formValues.QITA_AMT,
                            REMARK: formValues.REMARK,
                            USE_UNIT: formValues.USE_UNIT,
                            USE_UNIT_XZ: formValues.SYDWXZ_ID,
                            XMLX_ID: formValues.XMLX_ID,
                            XMTZ_AMT: formValues.XMTZ_AMT,
                            XMTZ_YB_AMT: formValues.XMTZ_YB_AMT,
                            XMTZ_ZX_AMT: formValues.XMTZ_ZX_AMT,
                            XMTZ_CZAP_AMT: formValues.XMTZ_CZAP_AMT,//20210630 jiafy 增加财政安排资金
                            XMTZ_PTRZ_AMT: formValues.XMTZ_PTRZ_AMT,//20210630 jiafy 增加配套融资资金
                            XM_NAME: formValues.XM_NAME,
                            XMZC_ID: formValues.XMZC_ID,
                            AG_ID: formValues.AG_ID,
                            AG_CODE: formValues.AG_CODE,
                            XM_ID: formValues.XM_ID,
                            QD_DATE: formValues.QD_DATE,
                            WF_ID:wf_id,
                            NODE_CURRENT_ID:node_code,
                            WF_STATUS:WF_STATUS,
                            SBQJ:SBQJ,
                            IS_END:is_end,
                            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
                        },
                        success: function (data) {
                            var respText = Ext.util.JSON.decode(data.responseText);
                            if (respText.success) {
                                Ext.toast({
                                    html: respText.msg,
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.up('window').close();
                                reloadGrid();
                            } else {
                                btn.setDisabled(false);
                                Ext.MessageBox.alert('提示', respText.message);
                            }
                        }
                    });
                }
            }, {
                xtype: 'button',
                text: '取消',
                name: 'CLOSE',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                zclrWindow.window = null;
            }
        }
    });
}
var zclb_id_temp;//记录资产类别id
var store_temp;
var current_record;//记录当前选中record行
//初始化资产录入表格
function initXMZCLRGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            "dataIndex": "XMZC_NAME",
            "width": 170,
            "type": "string",
            "text": "资产名称",
            headerMark: 'star',
            "align": 'right',
            'editor': {
                xtype: 'textfield', maxLength: '180'
            }
        },
        {
            "dataIndex": "ZCLB_ID",
            "type": "string",
            "text": '资产类别',
            headerMark: 'star',
            "width": 170,
            'renderer': function (value, metadata, record) {
                if (value == '') {
                    return;
                }
                var rec = ZCLB_ID_Store.findNode('code', value, true, true, true);
                if (rec == null) {
                    return value;
                }
                return rec.get('name');
            },
            'editor': {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                rootVisible: true,
                lines: false,
                allowBlank: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: ZCLB_ID_Store,
                listeners: {
                    select: function (combo, record, eOpts) {
                        zclb_id_temp = record.get("code");
                        /*store_temp.reload({//重新加载计量单位store  20210604liyue先控制资产类别不去控制计量单位 计量单位手动录入
                            params: {code: zclb_id_temp},
                            callback: function (records, operation, success) {
                                //设置默认值
                                current_record.set('JLDW_NAME', records[0].get("name"));
                            }
                        });*/
                    }
                }
            }
        },
        {
            "dataIndex": "ZCXZ_ID",
            "type": "string",
            "text": '资产性质',
            headerMark: 'star',
            "width": 170,
            'renderer': function (value, metadata, record) {
                if (value == '') {
                    return;
                }
                var rec = ZCXZ_Store.findNode('code', value, true, true, true);
                if (rec == null) {
                    return value;
                }
                return rec.get('name');
            },
            'editor': {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                rootVisible: true,
                lines: false,
                allowBlank: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: ZCXZ_Store,
            }
        },
        {
            "dataIndex": "ZCZT_ID",//2021060319LIYUE添加资产状态
            "type": "string",
            "text": '资产状态',
            headerMark: 'star',
            "width": 170,
            'renderer': function (value, metadata, record) {
                if (value == '') {
                    return;
                }
                var rec = ZCZT_Store.findNode('code', value, true, true, true);
                if (rec == null) {
                    return value;
                }
                return rec.get('name');
            },
            'editor': {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                rootVisible: true,
                lines: false,
                allowBlank: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: ZCZT_Store
            }
        },
        {
            "dataIndex": "BXNL_ID",
            "width": 100,
            "type": "string",
            "text": "变现能力",
            headerMark: 'star',
            "hidden": false,
            'renderer': function (value, metadata, record) {
                if (value == '') {
                    return;
                }
                var rec = BXNL_ID_Store.findRecord('code', value, 0, false, true, true);
                if (rec == null) {
                    return '';
                }
                return rec.get('name');
            },
            'editor': {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                rootVisible: false,
                lines: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: BXNL_ID_Store
            }
        },
        {
            "dataIndex": "BUILD_STATUS_ID",
            "width": 100,
            "type": "string",
            "text": "建设状态",
            headerMark: 'star',
            'renderer': function (value, metadata, record) {
                if (value == '') {
                    return;
                }
                var rec = BUILD_STATUS_ID_Store.findRecord('code', value, 0, false, true, true);
                if (rec == null) {
                    return '';
                }
                return rec.get('name');
            },
            'editor': {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                rootVisible: false,
                lines: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: BUILD_STATUS_ID_Store
            }
        },
       /* {
            "dataIndex": "JLDW_NAME",20210603liyur计量单位根据资产类别自动加载，目前资产类别基础数据有改动，所以计量单位暂时手动录入
            "type": "string",
            "text": "计量单位",
            "width": 100,
            "tdCls": "grid-cell-edit",
            'editor': {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'name',
                rootVisible: false,
                allowBlank: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: store_temp,
                queryMode: 'local'//禁止store自动请求，只手动加载
            }
        },*/
        {
            "dataIndex": "JLDW_NAME",
            "width": 170,
            "type": "string",
            "text": "计量单位",
            //headerMark: 'star',
            "align": 'right',
            'editor': {
                xtype: 'textfield', maxLength: '180'
            }
        },
        {
            "dataIndex": "ZC_NUM",
            "width": 100,
            "type": "number",
            "text": "数量",
            headerMark: 'star',
            "align": 'right',
            'editor': {
                hideTrigger: true, xtype: 'numberFieldFormat', allowDecimals: true,allowBlank: false, decimalPrecision: 6, minValue: 0, maxValue:999999999.999999
            }
        },
        {
            "dataIndex": "RZ_DATE",
            "width": 150,
            "type": "string",
            headerMark: 'star',
            "text": "转固/入账时间",
            'renderer': function (value, metaData, record) {
                var newValue = dsyDateFormat(value);
                record.data.RZ_DATE = newValue;
                return newValue;
            },
            'editor': {
                xtype: 'datefield', format: 'Y-m-d'
            }
        },
        {
            "header": "资产价值(万元)",
            'colspan': 2,
            'align': 'center',
            'columns': [{
                "dataIndex": "ZJYZ_AMT",
                "width": 150,
                "type": "float",
                "text": "原值",
                headerMark: 'star',
                'editor': {
                    hideTrigger: true,
                    xtype: 'numberFieldFormat',
                    allowBlank: false,
                    decimalPrecision: 2,
                    minValue: 0,
                    maxValue: 9999999999.99
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }, {
                "dataIndex": "ZCJZ_AMT",
                "width": 150,
                "type": "float",
                "text": "净值",
                headerMark: 'star',
                'editor': {
                    hideTrigger: true,
                    xtype: 'numberFieldFormat',
                    allowBlank: false,
                    decimalPrecision: 2,
                    minValue: 0,
                    maxValue: 9999999999.99
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },{
                "dataIndex": "YGJZ_AMT",
                "width": 150,
                "type": "float",
                "text": "预估价值",
                'editor': {
                    hideTrigger: true,
                    xtype: 'numberFieldFormat',
                    allowBlank: false,
                    decimalPrecision: 2,
                    minValue: 0
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            }]
        },
        // {
        //     "header": "资产处置情况",
        //     'colspan': 2,
        //     'align': 'center',
        //     'columns': [{
        //         "dataIndex": "CZLX_ID",
        //         "width": 150,
        //         "type": "string",
        //         "text": "处置类型",
        //         'renderer': function (value, metadata, record) {
        //             if (value == '') {
        //                 return;
        //             }
        //             var rec = CZLX_ID_Store.findRecord('code', value, 0, false, true, true);
        //             if (rec == null) {
        //                 return '';
        //             }
        //             return rec.get('name');
        //         },
        //         'editor': {
        //             xtype: 'combobox',
        //             displayField: 'name',
        //             valueField: 'code',
        //             rootVisible: false,
        //             lines: false,
        //             editable: false, //禁用编辑
        //             selectModel: 'leaf',
        //             store: CZLX_ID_Store
        //         }
        //     }, {
        //         "dataIndex": "CZSR_AMT",
        //         "width": 200,
        //         "type": "float",
        //         "text": "本期处置收入(万元)",
        //         'editor': {
        //             hideTrigger: true,
        //             xtype: 'numberFieldFormat',
        //             allowBlank: false,
        //             decimalPrecision: 2,
        //             minValue: 0,
        //             maxValue: 9999999999.99
        //         },
        //         summaryType: 'sum',
        //         summaryRenderer: function (value) {
        //             return Ext.util.Format.number(value, '0,000.00');
        //         }
        //     }]
        // },
        {
                "dataIndex": "CZSR_AMT",
                "width": 200,
                "type": "float",
                "text": "本期资产处置收入(万元)",
                'editor': {
                    hideTrigger: true,
                    xtype: 'numberFieldFormat',
                    allowBlank: false,
                    decimalPrecision: 2,
                    minValue: 0,
                    maxValue: 9999999999.99
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
        },
        {
            "dataIndex": "DYDB_AMT",
            "width": 220,
            "type": "float",
            "text": "抵押质押及担保金额(万元)",
            'editor': {hideTrigger: true, xtype: 'numberFieldFormat', allowBlank: false, decimalPrecision: 2, minValue: 0, maxValue: 9999999999.99},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "REMARK",
            "width": 200,
            "type": "string",
            "text": "备注",
            'editor': {
                xtype: 'textfield', maxLength: '500'
            }
        }
    ];
    return DSYGrid.createGrid({
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        width: '100%',
        flex: 1,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        autoLoad: false,
        itemId: 'zclrGrid',
        data: [],
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false//设置分页为true
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'zclr_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    beforeedit: function (editor,context) {
                        current_record = context.record;
                        //点击计量单位单元格之前先加载计量单位数据
                        if (context.field == 'JLDW_NAME') {
                            var code = context.record.get('ZCLB_ID');
                            if (zclb_id_temp != code) {
                                zclb_id_temp = code;
                                //操作的不是同一个资产类别，需发送请求重新获取计量单位
                                store_temp.reload({//重新加载计量单位store
                                    params: {code: code},
                                    callback: function (records, operation, success) {
                                    }
                                });
                            }
                        }
                    }
                }
            }],
        listeners: {
            selectionchange: function (view, records) {
                var grid = DSYGrid.getGrid('zclrGrid');
                grid.up('window').down('#deleteLine').setDisabled(!records.length);
            }
        }
    })
}

function dooperation() {
    var records = DSYGrid.getGrid('zcmxGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条明细记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var xmzc_dtl_id = records[0].get("XMZC_DTL_ID");
        fuc_getWorkFlowLog(xmzc_dtl_id);
    }
}
//未形成资产Grid表格
//创建已有项目表格
function WeiXingzichan() {
    var headerJson = [
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区", "width": 100,
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }
        },
        {"dataIndex": "AG_NAME", "type": "string", "text": "项目单位", "width": 200,
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }
        },
        {
            "dataIndex": "XM_NAME", "width": 330, "type": "string", "text": "项目名称",
            renderer: function (data, cell, record) {
                cell.tdCls = 'grid-cell-unedit';
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {"text": "未形成资产原因",headerMark: 'star', "dataIndex": "WXCZC_REASON", "type": "string", "width": 800,hidden: (!IS_INPUT_WXCZC_REASON),
            editor : {hideTrigger: true, xtype: 'textfield', allowBlank: false, emptyText: '请输入255字以内...'}
        },
        {"text": "管理(使用)单位", "dataIndex": "USE_UNIT", "type": "string", "width": 200,
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }
        },
        {"text": "项目类型", "dataIndex": "XMLX_NAME", "type": "string", "width": 150,
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }
        },
        {"text": "项目性质ID", "dataIndex": "XMXZ_ID", "type": "string", hidden: true},
        {"text": "项目性质", "dataIndex": "XMXZ_NAME", "type": "string", width: 170,
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }},
        {
            "dataIndex": "BUILD_STATUS_ID", "type": "string", hidden: true
        }, {
            "dataIndex": "BUILD_STATUS_NAME", "width": 150, "type": "string", "text": "建设状态",
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }
        },
        {"dataIndex": "END_DATE_ACTUAL", "width": 150, "type": "string", "text": "竣工时间",
            renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                cellmeta.tdCls = 'grid-cell-unedit';
                return value;
            }
        },
        {
            "header": "项目总投资金额(万元)", 'colspan': 2, 'align': 'center',
            'columns': [
                {"type": "float", "text": "合计", "dataIndex": "XMTZ_AMT", width: 150,
                    renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                        cellmeta.tdCls = 'grid-cell-unedit';
                        return value;
                    }},
                {"dataIndex": "XMTZ_YB_AMT", "width": 150, "type": "float", "text": "其中一般债务",
                    renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                        cellmeta.tdCls = 'grid-cell-unedit';
                        return value;
                    }},
                {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务",
                    renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
                        cellmeta.tdCls = 'grid-cell-unedit';
                        return value;
                    }
                }
            ]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'existingProjectGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        autoLoad: false,
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            SBQJ:SBQJ,
            mhcx_xm: '',
            xmlx_id: ''
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'wxczc_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    edit: function (editor, context) {
                        if(context.field=="WXCZC_REASON") {
                            window.flag_wxczc_validateedit = null;
                            if(getStringLength(context.value) > 512){
                                context.record.set("WXCZC_REASON","");
                                Ext.MessageBox.alert('提示','未形成资产原因不能超过255个字符!');
                                return false;
                            }
                        }
                    }
                }
            }
        ],
        dataUrl: 'getExistingProjectGrid.action',
        pageConfig: {
            /*enablePage: true,//设置分页为false
            pageNum: true*/
            enablePage: false
        }
    });
}
/**
 * 操作记录
 */
function operationRecord() {
    var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("XMZC_ID"));
    }
}

/*
*  liyue20210526
*  增加时弹出期间选择框，
*  根据期间选择框中所选期间
*  过滤应该加载的项目
* */
function initWindow_sbqj(AD_CODE,AG_ID) {
    Ext.create('Ext.window.Window', {
        itemId: 'window_sbpc', // 窗口标识
        title: '请选择上报期间', // 窗口标题
        width: 300, //自适应窗口宽度
        height: 150, //自适应窗口高度
        layout: {
            type: 'hbox',
            padding: '10',
            align: 'middle'
        },
        y: document.body.clientHeight * 0.3,
        buttonAlign: 'center', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [
            {
                fieldLabel: '上报期间',
                name: 'WSBQJ',
                remoteSort: true,
                id: 'WSBQJ',
                labelAlign: 'right',
                xtype: 'combobox',
                editable: false,
                labelWidth: 80,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleTreeStoreDBTable('dsy_v_ele_period_xmsz'),
            },
        ],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                   SBQJ = btn.up('window').down('combobox[name=WSBQJ]').getValue();
                    if (SBQJ == null || SBQJ == '') {
                        Ext.Msg.alert('提示', "请选择上报期间");
                        return false;
                    }
                    chooseProjectWindow.show();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                    existingProjectStore.getProxy().extraParams['SBQJ'] = SBQJ;
                    existingProjectStore.loadPage(1);
                    btn.up('window').close();
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}