/**
 * js：项目资产审核
 */
//变现能力
var BXNL_ID_Store = DebtEleStore(json_debt_bxnl);
var reportUrl = '';
var hidden = false;
var json_zt = json_debt_zt2_3;//当前状态下拉框json数据
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮状态，即为按钮name
//是否显示全部区划
var v_child = '0';
if (node_type == "xmzcsh") {
    //以上node隐藏区划树，默认选中底级区划
    v_child = '1';
}

/**
 * 通用配置json
 */
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
                handler: function () {
                    getHbfxDataList();
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        button_name = btn.text;
                        opinionWindow.open('NEXT', "审核意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'btn_back',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('zctbGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return;
                    } else {
                        button_name = btn.text;
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', "退回意见");
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
                text: '操作记录',
                name: 'log',
                hidden : false,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    //dooperation()
                    operationRecord()
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'log',
                hidden : true,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation()
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
                    getHbfxDataList();
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
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
                "dataIndex": "CZAP_AMT",
                "width": 150,
                "type": "float",
                "text": "财政安排资金"
            }, {
                "dataIndex": "PTRZ_AMT",
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
                store: DebtEleStore(json_debt_sh),
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
          /*  {
                fieldLabel: '上报期间',20210603liyue项目资产取消期间录入
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
            },*/{
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
            AG_ID: '',
            SB_STATUS: '',
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            NODE_CODE: node_code,
            NODE_TYPE:node_type,
            USERCODE:userCode
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
                {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务"}]
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
            xmlx_id: ''
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
                triggers:{
                    clear: {
                        cls: Ext.baseCSSPrefix + 'form-clear-trigger',
                        handler: function(self) {
                            self.setValue('');
                        }
                    }
                }
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
                            var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                            existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                            existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                            existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                            existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
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
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                    existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                    existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                    existingProjectStore.loadPage(1);
                }
            }
        ],
        dataUrl: 'getExistingProjectGrid.action',
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
                allowBlank: true,
                /*triggers:{
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
                            var projectsNotFormingAssetsStore = DSYGrid.getGrid('projectsNotFormingAssetsGrid').getStore();
                            projectsNotFormingAssetsStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                            projectsNotFormingAssetsStore.getProxy().extraParams['AG_ID'] = AG_IDS;
                            projectsNotFormingAssetsStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                            projectsNotFormingAssetsStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
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
                    var projectsNotFormingAssetsStore = DSYGrid.getGrid('projectsNotFormingAssetsGrid').getStore();
                    projectsNotFormingAssetsStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    projectsNotFormingAssetsStore.getProxy().extraParams['AG_ID'] = AG_IDS;
                    projectsNotFormingAssetsStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                    projectsNotFormingAssetsStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
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

function dooperation() {
    var records = DSYGrid.getGrid('contentGrid_detail').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条明细记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var xmzc_dtl_id = records[0].get("XMZC_DTL_ID");
        fuc_getWorkFlowLog(xmzc_dtl_id);
    }
}