<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>地区资产汇总上报</title>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    var userCode = '${sessionScope.USERCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id
    var node_name = "lr";//当前节点名称
    var button_name = '';//当前操作按钮名称
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    var v_child = '0';
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var json_debt_dqzc = [//地区资产上报状态
        {id: "001", code: "001", name: "未上报"},
        {id: "002", code: "002", name: "已上报"},
        {id: "004", code: "004", name: "被退回"},
        {id: "008", code: "008", name: "曾经办"}
    ];
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    var json_zt = json_debt_dqzc;
    var AD_CODES = [];
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: initItems_toolbar(node_name, WF_STATUS)
                }
            ],
            items: [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    },
                    items_tree: function () {
                        return [
                            initContentTree_area()//初始化左侧区划树
                        ];
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧panel
            ]
        });
    }
    /**
     * 获取工具栏按钮
     */
    var items_toolbar;//工具栏按钮
    function initItems_toolbar(nodeName, wf_status) {
        //工具栏按钮集合
        var items_toolbar_btns = {

            search: {
                text: '查询', xtype: 'button', name: 'search', icon: '/image/sysbutton/search.png',
                handler: function() {
                    reloadGrid();
                }
            },
            down: {
                text: '上报', xtype: 'button', name: 'down', icon: '/image/sysbutton/report.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        btn.setDisabled(false);
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                        AD_CODES.push(records[i].get('AD_CODE'));
                    }
                    //发送ajax请求，校验数据
                    $.post("/checkBeforeSb.action", {
                        ids: ids,
                        AD_CODE: AD_CODE,
                        AG_CODE: AG_CODE
                    }, function (data) {
                        if (data.success) {
                            var grid = existingProjectGrid();
                            grid.getStore().load(function () {
                                var haveConfirmWindow = true;//是否有确认窗口
                                var count = grid.getStore().getCount();
                                if (count <= 0) {
                                    Ext.Msg.confirm('提示', '上报后不能再新增或修改数据，是否确认上报？', function (btn_confirm) {
                                        if (btn_confirm === 'yes') {
                                            haveConfirmWindow = false;
                                            sumitSB(ids,haveConfirmWindow);
                                        }
                                    });
                                    btn.setDisabled(false);
                                    return false;
                                }
                                ConfirmWindow({height:document.body.clientHeight*0.8,title:'提示',itemId:'confirmWindow',listeners:{beforedestroy: function(){AD_CODES = [];},close: function(){btn.setDisabled(false);}}}, '本地区以下项目未形成资产，并且上报后不能再新增或修改数据，是否确认上报？', grid, function callback() {
                                    sumitSB(ids,haveConfirmWindow);
                                }).show();

                            });
                        } else {
                            Ext.MessageBox.alert(button_name + '失败！', data.message);
                            btn.setDisabled(false);
                        }

                    }, "json");
                }
            },
            cancel: {
                text: '撤销上报', name: 'cancel', xtype: 'button', icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    button_name = btn.text;
                    var ids = [];
                    var sbqj_ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                        sbqj_ids.push(records[i].get('SBQJ_ID'));
                    }
                    Ext.Msg.confirm('提示','是否撤销上报?',function(btn_confirm){
                        if (btn_confirm === 'yes') {
                            //发送ajax请求，撤销上报数据
                            $.post("/updateXmzcHzGrid_CancelSb.action", {
                                ids: ids,
                                userCode: userCode,
                                AD_CODE: AD_CODE,
                                AG_CODE: AG_CODE,
                                sbqj_ids: sbqj_ids
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: button_name + "成功！" + (data.message ? data.message : ''),
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
                    });
                }
            },
            sum: {
                text: '汇总表', name: 'hz', xtype: 'button', icon: '/image/sysbutton/sum.png',
                handler: function () {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_HZ.cpt&HZD_TYPE=1&hzd_id='+ids;
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
                }
            },
            detail: {
                text: '明细表', name: 'hz', xtype: 'button', icon: '/image/sysbutton/detail.png',
                handler: function () {
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_MX.cpt&hzd_type=1&hzd_id='+ids;
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
                }
            },
            log: {
                text: '操作记录', name: 'log', xtype: 'button', icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            pro: {
                xtype: 'button',
                text: '未形成资产项目',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.each(records, function (record) {
                        AD_CODES.push(record.get("AD_CODE"));
                    });
                    chooseProjectWindow.show();
                    var existingProjectStore = DSYGrid.getGrid('existingProjectGrid').getStore();
                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
                    existingProjectStore.loadPage(1);
                   // AD_CODES = [];清空导致后台获取不到值
                }
        }

        };
        items_toolbar = {
            lr: {//录入
                items: {
                    '001': [//未上报
                        items_toolbar_btns.search,
                        items_toolbar_btns.down,
                        items_toolbar_btns.sum,
                        items_toolbar_btns.detail,
                        items_toolbar_btns.log,
                        items_toolbar_btns.pro,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已上报
                        items_toolbar_btns.search,
                        items_toolbar_btns.cancel,
                        items_toolbar_btns.sum,
                        items_toolbar_btns.detail,
                        items_toolbar_btns.log,
                        items_toolbar_btns.pro,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [//被退回
                        items_toolbar_btns.search,
                        items_toolbar_btns.down,
                        //items_toolbar_btns.cancel,
                        items_toolbar_btns.sum,
                        items_toolbar_btns.detail,
                        items_toolbar_btns.log,
                        items_toolbar_btns.pro,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [//曾经办
                        items_toolbar_btns.search,
                        items_toolbar_btns.sum,
                        items_toolbar_btns.detail,
                        items_toolbar_btns.log,
                        items_toolbar_btns.pro,
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            }
        };
        return items_toolbar[nodeName].items[wf_status];
    }
    /**
     * 上报操作
     */
    function sumitSB(ids,haveConfirmWindow) {
        //校验通过，发送ajax请求，进行上报操作
        $.post("/updateXmzcHzGrid_Sb.action", {
            ids: ids,
            userCode: userCode,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: button_name + "成功！" + (data.message ? data.message : ''),
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
            } else {
                Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
            }
            //刷新表格
            reloadGrid();
            if (haveConfirmWindow) {//如果有确认窗口，上报完成后关闭
                Ext.ComponentQuery.query('window#confirmWindow')[0].close();
            }
        }, "json");
    }
    /**
     * 初始化右侧panel，放置表格
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            itemId: 'initContentGrid',
            items: [
                initContentGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "汇总单ID", dataIndex: "HZD_ID", type: "string",hidden:true},
            {text: "地区编码", dataIndex: "AD_CODE", type: "string", width: 150, hidden: true},
            {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
            {text: "项目单位数", dataIndex: "DW_NUMS", type: "string", width: 100, align: "center"},
            {text: "项目数量", dataIndex: "XM_NUMS", type: "string", width: 100, align: "center"},
            {text: "上报期间ID", dataIndex: "SBQJ_ID", type: "string", width: 100, align: "center", hidden: true},
            {text: "上报期间", dataIndex: "SBQJ_NAME", type: "string", width: 100, align: "center"},
            {header: "项目总投资额(万元)", colspan: 2, align: 'center',columns:[
                {text: "合计", dataIndex: "XMTZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "其中一般债务", dataIndex: "XMTZ_YB_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "专项债务", dataIndex: "XMTZ_ZX_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "其他财政性资金", dataIndex: "QT_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "其他资金", dataIndex: "QITA_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {header: "资产价值(万元)", colspan: 2, align: 'center',columns:[
                {text: "原值", dataIndex: "ZJYZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "净值", dataIndex: "ZCJZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "预估价值", dataIndex: "YGJZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {header: "资产运营收益(万元)", colspan: 2, align: 'center',columns:[
                {text: "累计收益", dataIndex: "LJSY_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "本期收益", dataIndex: "SNLJSY_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "每年平均经营性现金流收入", dataIndex: "PJSY_AMT", type: "float", width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "年度平均政府安排财政补贴资金", dataIndex: "PJBT_AMT", type: "float", width: 250,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {text: "本期资产处置收入(万元)", dataIndex: "CZSR_AMT", type: "float", width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "抵押质押及担保金额(万元)", dataIndex: "DYDB_AMT", type: "float", width: 200,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            flex: 1,
            autoLoad: false,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code
            },
            dataUrl: '/getDqhzList.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_zt),
                    width: 110,
                    labelWidth: 30,
                    editable: false, //禁用编辑
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(initItems_toolbar(node_name, WF_STATUS));
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
            }
        });
    }
    //创建已有项目选择窗口
    var chooseProjectWindow = {
        window: null,
        show: function () {
            if (!this.window) {
                this.window = initChooseProjectWindow(true);
            }
            this.window.show();
        }
    };
    function initChooseProjectWindow(param) {
        return Ext.create('Ext.window.Window', {
            height: document.body.clientHeight * 0.9,
            width: document.body.clientWidth * 0.9,
            title: '未形成资产项目',
            maximizable: true,
            modal: true,
            closeAction: 'destroy',
            layout: 'fit',
            items: [existingProjectGrid(param)],
            buttons: [
            ],
            listeners: {
                close: function () {
                    chooseProjectWindow.window = null;
                    AD_CODES = [];
                }
            }
        });
    }
    //创建已有项目表格
    function existingProjectGrid(has_tbar) {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
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
                    {"type": "float", "text": "合计", "dataIndex": "XMTZ_AMT", width: 150,
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {"dataIndex": "XMTZ_YB_AMT", "width": 150, "type": "float", "text": "其中一般债务",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    },
                    {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务",
                        summaryType: 'sum',
                        summaryRenderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.00');
                        }
                    }]
            },
            {"text": "未形成资产原因", "dataIndex": "WXCZC_REASON", "type": "string", "width": 150}

        ];
        var config={
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
            features: [{
                ftype: 'summary'
            }],
            autoLoad: true,
            params: {
                AD_CODE: AD_CODES,
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
                                existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
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
                        existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODES;
                        existingProjectStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                        existingProjectStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                        existingProjectStore.loadPage(1);
                    }
                }
            ],
            dataUrl: 'getExistingProjectGrid.action',
            pageConfig: {
                enablePage: true//设置分页为false
            }
        };
        if(!has_tbar){
            delete config.tbar;
        }
        return DSYGrid.createGrid(config);
    }
    /**
     * 树点击节点时触发，刷新content主表格
     */
    function reloadGrid(param) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //增加查询参数
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.getProxy().extraParams["AG_CODE"] = AG_CODE;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
    }

    /**
     * 操作记录
     */
    function operationRecord() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (!records || records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            fuc_getWorkFlowLog(records[0].get("HZD_ID"));
        }
    }

</script>
</body>
</html>