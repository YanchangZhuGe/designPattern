<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>罚息缴纳确认</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    var ad_code = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var userCode = '${sessionScope.USERCODE}';
   /* var wf_id = getQueryParam("wf_id");//当前流程id
    var node_code = getQueryParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';//当前操作按钮名称
/*
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    var fxjnmx_id = '';
 /*   if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var userName = top.userName;  //经办人
    /**
     *地区下拉框(当前用户区划下级：包含省管县)
     */
    var grid_tree_store = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getRegTreeDataByCode.action',
            extraParams: {
                AD_CODE: ad_code
            },
            reader: {
                type: 'json'
            }
        },
        root: 'nodelist',
        autoLoad: true
    });
    //罚息缴纳主表头
    var HEADERJSON = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "ID", dataIndex: "FXJN_ID", width: 150, type: "string", hidden: true},
        {text: "地区", dataIndex: "AD_NAME", width: 150, type: "string", hidden: true},
        {text: "单位", dataIndex: "AG_NAME", type: "string", width: 150},
        {text: "缴纳日期", dataIndex: "FXJN_DATE", width: 150, type: "string"},
        {
            text: "缴纳罚息金额(元)", dataIndex: "SUM_FXJN_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "免除罚息金额(元)", dataIndex: "SUM_FXMC_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "经办人", dataIndex: "USERNAME", width: 150, type: 'string'},
        {text: "备注", dataIndex: "REMARK", width: 150, type: 'string'}
    ];
    //罚息缴纳明细表头
    var HEADERJSON_DETAIL = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "单位", dataIndex: "AG_NAME", width: 150, type: "string", hidden: true},
        {text: "ZQ_ID", dataIndex: "ZQ_ID", width: 150, type: "string", hidden: true},
        {text: "FXJN_DTL_ID", dataIndex: "FXJN_DTL_ID", width: 150, type: "string", hidden: true},
        {text: "债券编码", dataIndex: "ZQ_CODE", width: 150, type: "string"},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", width: 150, type: "string",
            renderer: function (data, cell, record) {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('ZQ_ID');
                paramValues[1] = ad_code;
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "债券类型", dataIndex: "ZQ_TYPE", width: 150, type: "string"},
        {
            text: "应付罚息(元)", dataIndex: "YFFX_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "缴纳罚息金额(元)", dataIndex: "FXJN_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "免除金额(元)", dataIndex: "FXMC_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "到期日期", dataIndex: "DF_END_DATE", width: 150, type: "string"},
        {
            text: "逾期本金(元)", dataIndex: "YQBJ_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "逾期利息(元)", dataIndex: "YQLX_AMT", width: 150, type: "float", summaryType: "sum",
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "实际还款日期", dataIndex: "PAY_DATE", width: 150, type: "string"},
        {text: "逾期天数", dataIndex: "YQ_DAYS", width: 150, type: "string"},
        {
            text: "罚息率(‰)", dataIndex: "ZNJ_RATE", width: 150, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value * 10, '0,000.00####');
            }
        },
        {text: "债券期限", dataIndex: "ZQQX_NAME", width: 150, type: "string"},
        {text: "债券利率(%)", dataIndex: "ZQ_RATE", width: 150, type: "string"}
    ];
    var fxjn_json_common = {
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
                    text: '确认',
                    name: 'down',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'back',
                    icon: '/image/sysbutton/back.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },
                '->',						//中间空行
                initButton_OftenUsed(),  	//常用 button
                initButton_Screen() 		//全屏 button
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
                    text: '撤销确认',
                    name: 'up',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },
                '->',						//中间 空行
                initButton_OftenUsed(),		//常用  button
                initButton_Screen()			//全屏 button
            ]
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_zt3)
        }
    };

    $(document).ready(function () {
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
    });

    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,			//是否有分割线
                collapsiable: true  	//是否可以折叠
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: fxjn_json_common.items[WF_STATUS]
                }
            ],
            items: [
                initContentRightPanel()
            ]
        });
    }

    //初始化右侧panel ,表格
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,	//相对比例伸缩
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            items: [
                initContentGrid(),
                initContentDetailGrid()
            ]
        });
    }

    //初始化主表格
    function initContentGrid() {
        var headerJson = HEADERJSON;
        return DSYGrid.createGrid(
            {
                itemId: 'contentGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                params: {
                    WF_STATUS: WF_STATUS,
                    wf_id: wf_id,
                    node_code: node_code,
                    SET_YEAR: ''
                },
                features: [{
                    ftype: 'summary'
                }],
                dataUrl: 'dwfxjnConfirm.action',
                checkBox: true,
                border: false,
                autoLoad: true,
                tbar: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        name: 'WF_STATUS',
                        value: WF_STATUS,
                        store: fxjn_json_common.store['WF_STATUS'],
                        width: 110,
                        labelWidth: 30,
                        labelAlign: 'right',
                        editable: false,
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                WF_STATUS = newValue;
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                toolbar.removeAll();
                                toolbar.add(fxjn_json_common.items[WF_STATUS]);
                                DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "datefield",
                        fieldLabel: '还款日期',
                        format: 'Y-m-d',
                        name: 'sdate',
                        width: 163,
                        labelWidth: 58,
                        labelAlign: 'right',
                        editable: false,
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams[self.getName()] = Ext.util.Format.date(newValue, 'Y-m-d');
                                //self.up('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "datefield",
                        fieldLabel: '至',
                        format: 'Y-m-d',
                        name: 'edate',
                        width: 125,
                        labelWidth: 20,
                        labelAlign: 'right',
                        editable: false,
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams[self.getName()] = Ext.util.Format.date(newValue, 'Y-m-d');
                                self.up('grid').getStore().loadPage(1);
                            }
                        }
                    }
                ],
                pageConfig: {
                    pageNum: true //显示煤业条数
                },
                listeners: {
                    itemdblclick: function (self, record) {
                        var fxjn_id = record.get('FXJN_ID');
                        $.post('getDwFxjnData.action', {
                            fxjn_id: fxjn_id
                        }, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert("提示", "加载失败" + data.message);
                                return;
                            }
                            //弹出框
                            var initWin_show = initWinData_show();
                            initWin_show.show();
                            initWin_show.down('form').getForm().setValues(data.list[0]);
                            initWin_show.down('#initWin_tab_show_mxgrid').insertData(null, data.list_dtl);
                        }, 'json');
                    },
                    itemclick: function (self, record) {
                        DSYGrid.getGrid('contentDetailGrid').getStore().getProxy().extraParams['FXJN_ID'] = record.get('FXJN_ID');
                        DSYGrid.getGrid('contentDetailGrid').getStore().loadPage(1);
                    }
                }
            }
        );
    }

    // 初始化罚息缴纳明细
    function initContentDetailGrid() {
        return Ext.create('Ext.tab.Panel', {
            width: '100%',
            height: '100%',
            flex: 1,
            layout: 'fit',
            items: [
                {
                    title: '明细',
                    layout: 'fit',//容器内元素自动填充满
                    scrollable: true,  //是否滚动
                    items: initContentDetailGrid_Data()
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            items: initWin_tab_show_upload(fxjnmx_id)
                        }
                    ],
                    listeners: {
                        beforeactivate: function (self) {
                            //检验明细数据
                            var grid = self.up('tabpanel').down('grid#contentDetailGrid');
                            if (grid.getStore().getCount() < 1) {
                                return;
                            }
                            //获取选中数据
                            var record = grid.getCurrentRecord();  //选中数据
                            //没有选中，则默认为第一条
                            if (!record) {
                                $(grid.getView().getRow(0)).parent('table[data-recordindex=0]').addClass('x-grid-item-click');//选中第一行
                                record = grid.getStore().getAt(0);
                                Ext.toast({
                                    html: "明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                    closable: false, //不显示工具按钮
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            }
                            var panel = self.down('panel');
                            panel.removeAll(true);
                            panel.add(initWin_tab_show_upload(record.get('FXJN_DTL_ID')));
                        }
                    }
                }
            ]
        });
    }

    //初始化明细表格
    function initContentDetailGrid_Data() {
        var config = {
            itemId: 'contentDetailGrid',
            headerConfig: {
                headerJson: HEADERJSON_DETAIL,  //表头
                columnAutoWidth: false  //自动列宽
            },
            flex: 1,
            dataUrl: '/dwfxjnDtlConfirm.action',
            checkBox: true,
            border: true,
            autoLoad: true,
            height: '100%',
            pageConfig: {
                enablePage: false,
                pageNum: true  //显示每页条数
            },
            features: [{
                ftype: 'summary'
            }]
        };
        var grid = DSYGrid.createGrid(config);
        return grid;
    }

    //罚息缴纳确认，工作流变更
    function doWorkFlow(btn) {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length < 1) {
            Ext.MessageBox.alert("提示", "请至少选择一条数据后进行操作");
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get('FXJN_ID'));
        }
        button_name = btn.text;
        if (button_name == '退回') {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + "意见",
                animateTarget: btn,
                value: '',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("dwfxjnConfirmAction.action", {
                            workflow_direction: btn.name,
                            button_name: button_name,
                            node_code: node_code,
                            audit_info: text,
                            wf_id: wf_id,
                            ids: ids
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    sildeInDuration: 400,
                                    minWidth: 400
                                });
                                reloadGrid();  //刷新表格
                            } else {
                                Ext.MessageBox.alert("提示", button_name + data.message);
                            }
                        }, 'json');
                    } else {
                        return;
                    }
                }
            });
        } else {
            //确认对话框
            Ext.Msg.confirm("提示", "是否" + button_name + "?", function (op) {
                if (op == 'yes') {
                    $.post("dwfxjnConfirmAction.action", {
                        workflow_direction: btn.name,
                        button_name: button_name,
                        node_code: node_code,
                        wf_id: wf_id,
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                sildeInDuration: 400,
                                minWidth: 400
                            });
                            reloadGrid();  //刷新表格
                        } else {
                            Ext.MessageBox.alert("提示", button_name + data.message);
                        }
                    }, 'json');
                } else {
                    return;
                }
            });
        }
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

    //弹出框，显示主单数据
    function initWinData_show() {
        var config = {
            title: '罚息缴纳',
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,  //最大化窗口
            maximizable: true,
            itemId: 'window_show',
            buttonAlign: 'right', //按钮显示位置
            modal: true,  //模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destory',
            items: [
                initWin_form_header(),
                initWin_form_body()
            ]
        };
        return Ext.create('Ext.window.Window', config);
    }

    //弹出window头部
    function initWin_form_header() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            layout: 'column',
            defaults: {
                columnWidth: .33,
                margin: '5 5 5 5',
                readOnly: true,
                fieldCls: 'from-unedit',
                labelWidth: 135
            },
            defaultType: 'textfield',
            items: [
                {fieldLabel: "地区", xtype: 'textfield', name: 'AD_NAME', hideTrigger: true, fieldCls: 'from-unedit'},
                {
                    fieldLabel: "<span class='required'>*</span>缴纳日期",
                    xtype: 'datefield',
                    name: 'FXJN_DATE',
                    allowBlank: false,
                    readOnly: true,
                    format: 'Y-m-d',
                    fieldCls: null,
                    blankText: '请选择缴纳日期',
                    value: new Date()
                },
                {fieldLabel: "经办人", xtype: 'textfield', name: 'USERNAME', hideTrigger: true, fieldCls: 'from-unedit'},
                {
                    fieldLabel: "缴纳罚息金额",
                    xtype: 'numberFieldFormat',
                    name: 'SUM_FXJN_AMT',
                    hideTrigger: true,
                    fieldCls: 'from-unedit-number'
                },
                {
                    fieldLabel: "免除罚息金额",
                    xtype: 'numberFieldFormat',
                    name: 'SUM_FXMC_AMT',
                    hideTrigger: true,
                    fieldCls: 'from-unedit-number'
                },
                {fieldLabel: "备注", name: 'REMARK', columnWidth: .66, readOnly: true, fieldCls: null}
            ]
        });
    }

    //弹出weindow的body
    function initWin_form_body() {
        return Ext.create('Ext.tab.Panel', {
            width: '100%',
            height: '100%',
            flex: 1,
            layout: 'fit',
            items: [
                {
                    title: '明细',
                    layout: 'fit',//容器内元素自动填充满
                    scrollable: true,  //是否滚动
                    items: initWin_tab_show_mxgrid()
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            items: initWin_tab_show_upload(fxjnmx_id)
                        }
                    ],
                    listeners: {
                        beforeactivate: function (self) {
                            //检验明细数据
                            var grid = self.up('tabpanel').down('grid#initWin_tab_show_mxgrid');
                            if (grid.getStore().getCount() < 1) {
                                return;
                            }
                            //获取选中数据
                            var record = grid.getCurrentRecord();  //选中数据
                            //没有选中，则默认为第一条
                            if (!record) {
                                $(grid.getView().getRow(0)).parent('table[data-recordindex=0]').addClass('x-grid-item-click');//选中第一行
                                record = grid.getStore().getAt(0);
                                Ext.toast({
                                    html: "明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                    closable: false, //不显示工具按钮
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            }
                            var panel = self.down('panel');
                            panel.removeAll();
                            panel.add(initWin_tab_show_upload(record.get('FXJN_DTL_ID')));
                        }
                    }
                }
            ]
        });
    }

    //明细列显示
    function initWin_tab_show_mxgrid() {
        var headerJson = HEADERJSON_DETAIL;
        var config = {
            itemId: 'initWin_tab_show_mxgrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            width: '100%',
            height: '100%',
            flex: 1,
            autoLoad: false,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code,
                DQ_YEAR: '',
                DQ_MO: ''
            },
            data: [],
            checkBox: true,
            border: false,
            height: '100%',
            pageConfig: {
                enablePage: false,
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'cellEdit',
                    clicksToMoveEditor: 1,
                    listeners: {

                        'beforeedit': function (editor, context) {
                        },
                        'validateedit': function (editor, context) {

                        },
                        'edit': function (editor, context) {

                        }

                    }
                }],
            listeners: {
                selectionchange: function (self, records) {

                }
            }
        };
        var grid = DSYGrid.createGrid(config);
        return grid;
    }

    //明细附件列显示
    function initWin_tab_show_upload(FXJN_DTL_ID) {
        var grid = UploadPanel.createGrid({
            busiType: 'ET248',//业务类型
            busiId: FXJN_DTL_ID,//业务ID
            editable: false,
            gridConfig: {
                itemId: 'initWin_tab_show_upload'
            }
        });
        //附件加载完成后计算总文件数，并写到页签上
        grid.getStore().on('load', function (self, records, successful) {
            var sum = 0;
            if (records != null) {
                for (var i = 0; i < records.length; i++) {
                    if (records[i].data.STATUS == '已上传') {
                        sum++;
                    }
                }
            }
            //去掉第一行
            if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else if ($('span.file_sum')) {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }

    //清空明细表
    function clearmxgrid() {
        var mxgrid = DSYGrid.getGrid('contentDetailGrid').getStore();
        mxgrid.removeAll();
        mxgrid = DSYGrid.getGrid('initWin_tab_show_upload').getStore();
        mxgrid.removeAll();
    }

    //树点击节点时触发，刷新content主表格，明细表置为空
    function reloadGrid() {//TODO 清空明细
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //刷新
        store.loadPage(1);
        clearmxgrid();
    }
</script>
</body>
</html>
