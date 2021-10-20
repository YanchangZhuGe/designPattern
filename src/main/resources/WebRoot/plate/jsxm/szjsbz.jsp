<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>收支决算编制</title>

</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    var AD_CODE = '${sessionScope.ADCODE}';
    /*
        var wf_id = getQueryParam("wf_id");//当前流程id
    */
    var wf_id = "${fns:getParamValue('wf_id')}";
    /*  var node_code = getQueryParam("node_code");//当前节点id*/
    var node_code = "${fns:getParamValue('node_code')}";

    var button_name = '';//当前操作按钮名称
    var button_text = '';//当前操作按钮名称
    /*
        var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    */
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";

    /* if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
         WF_STATUS = '001';
     }*/
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var nowDate = '${fns:getDbDateDay()}';
    /*
        var xmlx = getQueryParam("xmlx");//当前流程id
    */
    var xmlx = "${fns:getParamValue('xmlx')}";
    var xmlx_id = '';//项目类型ID
    var ndgl;//用于年度过滤
    var is_edit = false;//是否可编辑以及保存
    var js_year;//用于获取决算年度
    var ys_year;//记录预算开始年度
    var jzxnzj = 0;
    var grid_relation = {};//grid中的关系
    var is_save = true;//是否可保存

    //还款单和还款单明细表头
    var HEADERJSON = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "虚拟主单ID", dataIndex: "JSD_ID", width: 60, type: "string", hidden: true},
        {text: "项目ID", dataIndex: "XM_ID", width: 60, type: "string", hidden: true},
        {text: "地区", dataIndex: "AD_NAME", width: 100, type: "string"},
        {text: "单位名称", dataIndex: "AG_NAME", width: 200, type: "string"},
        {text: "决算年度", dataIndex: "JS_YEAR", width: 100, type: "string"},
        {text: "预算开始年度", dataIndex: "YS_YEAR", hidden: true, width: 100, type: "string"},
        {text: "项目编码", dataIndex: "XM_CODE", width: 250, type: "string"},
        {
            text: "项目名称", dataIndex: "XM_NAME", width: 250, type: "string",
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('XM_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {text: "项目类型ID", dataIndex: "XMLX_ID", width: 150, type: "string", hidden: true},
        {text: "项目类型", dataIndex: "XMLX_NAME", width: 150, type: "string"},
        {text: "立项年度", dataIndex: "LX_YEAR", width: 150, type: "string"},
        {text: "建设性质", dataIndex: "JSXZ_NAME", width: 150, type: "string"},
        {text: "项目性质", dataIndex: "XMXZ_NAME", width: 150, type: "string"},
        {text: "建设状态", dataIndex: "BUILD_STATUS_NAME", width: 150, type: "string"},
        {text: "备注", dataIndex: "REMARK", width: 250, type: "string"}
    ];
    /**
     * 项目类型数据源
     */
    var store_xmlx = DebtEleStore([
        {id: "00", code: "00 通用", name: "通用"},
        {id: "05", code: "05 土地储备", name: "土地储备"}
    ]);

    /**
     * 通用配置json
     */
    var szjsbz_json_common = {
        100606: {//债券转贷及还款管理
            1: {//决算录入
                items: {
                    '001': [//未送审
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '新增',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                initWindow_select().show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                checkJs();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_del',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                checkJs();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
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
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已送审
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
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
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                checkJs();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_del',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                checkJs();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
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
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
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
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt0)
                }
            },
            2: {//绝算审核
                items: {
                    '001': [//未审核
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        }, {
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
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已审核
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        }, {
                            xtype: 'button',
                            text: '撤销审核',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
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
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
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
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt2)
                }
            },
            3: {//决算复核
                items: {
                    '001': [//未审核
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        }, {
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
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已审核
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        }, {
                            xtype: 'button',
                            text: '查看',
                            name: 'btn_check',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                getView();
                            }
                        }, {
                            xtype: 'button',
                            text: '撤销审核',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_sh)
                }
            }
        }
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
    });

    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: szjsbz_json_common[wf_id][node_code].items[WF_STATUS]
                }
            ],
            items: [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: node_code == 1 || node_code == 2 ? 1 : 0//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
        });
    }

    /**
     * 初始化右侧panel，放置1个表格
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
            items: [
                initContentGrid()
            ]
        });
    }

    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = HEADERJSON;
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                XMLX_ID: xmlx,
                node_code: node_code,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: 'getszjsxm.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: szjsbz_json_common[wf_id][node_code].store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    labelAlign: 'right',
                    editable: false, //禁用编辑
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(szjsbz_json_common[wf_id][node_code].items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                }
            ],
            listeners: {
                itemdblclick: function (self, record) {//双击监听
                    button_name = '';
                    button_text = '查看';
                    Viewshow(record);
                },
                itemclick: function (self, record) {

                }

            }
        });
    }

    /**
     * 创建转贷还款计划弹出窗口
     */
    function initWindow_select() {
        var items = [initWindow_select_grid()];
        return Ext.create('Ext.window.Window', {
            title: '已有项目', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: items,
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作！');
                            return false;
                        }
                        //弹出填报页面，并写入债券信息以及明细信息
                        var window_input = Ext.ComponentQuery.query('window#window_input')[0];
                        var year = Ext.ComponentQuery.query('combobox[name="JS_YEAR"]')[0].value;
                        var XMLX_ID = Ext.ComponentQuery.query('combobox[name="YYXM_XMLX_ID"]')[0].value;
                        xmlx_id = Ext.ComponentQuery.query('combobox[name="YYXM_XMLX_ID"]')[0].value;
                        if (!window_input) {
                            var data = records[0].data;
                            //年度与项目立项年度比较
                            ndgl = year;
                            is_edit = button_text == '查看' ? false : true;//查看为不可编辑，false
                            js_year = data.JS_YEAR = year;
                            ys_year = data.YS_YEAR;
                            //验证是否按顺序录入
                            $.post("/checkJshave.action", {
                                BUTTON_NAME: button_name,
                                XM_ID: records[0].get('XM_ID'),
                                JS_YEAR: year
                            }, function (dataresu) {
                                if (dataresu.success) {
                                    Ext.MessageBox.alert('提示', "未存在" + (Number(js_year) - 1) + "年的决算数据，不允许" + button_text + "!");
                                } else {
                                    window_input = initWin_input(js_year, data.XM_ID, XMLX_ID);

                                    var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                                    var paramNames = new Array();
                                    paramNames[0] = "XM_ID";
                                    var paramValues = new Array();
                                    paramValues[0] = records[0].get('XM_ID');
                                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data.XM_NAME + '</a>';
                                    data.XM_NAME = result;

                                    window_input.down('[name=jslr]').getForm().setValues(data);
                                    window_input.show();
                                    //刷新填报弹出中转贷明细表获取转贷计划
                                    btn.up('window').close();
                                }
                            }, "json");
                        }
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
    }

    /*债务基础数据，下拉框形式，从前台js获取数据*/
    function DebtEleStore(debtEle, params) {
        var namecode = '0';
        if (typeof params != 'undefined' && params != null) {
            namecode = params.namecode;
        }
        var debtStore = Ext.create('Ext.data.Store', {
            fields: ['id', 'code', 'name'],
            sorters: [{
                property: 'code',
                direction: 'asc'
            }],
            data: namecode == '1' ? DebtJSONNameWithCode(debtEle) : debtEle
        });
        return debtStore;
    }

    /**
     * 获取已有预算项目
     */
    function initWindow_select_grid() {
        //设置查询form
        var search_form = DSYSearchTool.createTool({
            itemId: 'window_select_yyysxm_form',
            border: false,
            defaults: {
                labelAlign: 'right',
                labelWidth: 80,
                columnWidth: .25,
                margin: '7 10 3 5'
            },
            items: [
                {
                    xtype: 'combobox',
                    fieldLabel: '项目类型',
                    name: 'YYXM_XMLX_ID',
                    displayField: 'code',
                    value: '05',
                    valueField: 'id',
                    readOnly: false,
                    store: store_xmlx,
                    allowBlank: false,
                    editable: false,
                    listeners: {
                        'change': function (self, newValue, oldValue) {
                            getYyysxm();
                        }

                    }
                },
                {
                    fieldLabel: '模糊查询',
                    xtype: 'textfield',
                    name: 'YYXM_MHCX',
                    emptyText: '请输入项目编码/项目名称...',
                    enableKeyEvents: true,
                    listeners: {
                        keypress: function (self, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                getYyysxm();
                            }
                        }
                    }
                }, {
                    xtype: 'combobox',
                    fieldLabel: '立项年度',
                    name: 'YYXM_BILL_YEAR',
                    labelWidth: 70,
                    editable: false,
                    value: nowDate.substr(0, 4),
                    format: 'Y',
                    labelAlign: 'right',
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                    listeners: {
                        change: function (self, newValue) {
                            getYyysxm();
                        }
                    }
                }, {
                    xtype: 'combobox',
                    fieldLabel: '决算年度',
                    name: 'JS_YEAR',
                    labelWidth: 70,
                    editable: false,
                    value: nowDate.substr(0, 4),
                    format: 'Y',
                    labelAlign: 'right',
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015' "}),
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            getYyysxm();
                        }
                    }
                }
            ],
            bodyStyle: 'border-width:0 0 0 0;',
            dock: 'top',
            // 查询按钮回调函数
            callback: function (self) {
                getYyysxm();
            }
        });
        search_form.remove(search_form.down('toolbar'));
        search_form.addDocked({
            xtype: 'toolbar',
            border: false,
            width: 100,
            dock: 'right',
            layout: {
                type: 'vbox',
                align: 'center'
            },
            items: [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        getYyysxm();
                    }
                }
            ]
        });
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {dataIndex: "XM_ID", type: "string", text: "项目id", hidden: true},
            {
                dataIndex: "XM_NAME", type: "string", text: "项目", width: 180,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    //return '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\,\'' + record.get('ID') + '\')">' + data + '</a>';
                    var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    var paramValues = new Array();
                    paramValues[0] = record.get('XM_ID');
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
            {dataIndex: "YS_YEAR", type: "string", hidden: true, text: "预算开始年度"},
            {dataIndex: "AG_NAME", type: "string", text: "建设单位"},
            {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
            {dataIndex: "XMXZ_NAME", type: "string", text: "项目性质", width: 150},
            {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
            {dataIndex: "BUILD_STATUS_NAME", type: "string", text: "建设状态 ", width: 150},
            {
                dataIndex: "XMZGS_AMT", type: "float", text: "项目总概算金额(万元) ", width: 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00####');
                },
                /*summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00####');
                }*/
            },
            {dataIndex: "JYS_NO", type: "string", text: "项目建议书文号 ", width: 150},
            {dataIndex: "PF_NO", type: "string", text: "可研批复文号", width: 150}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'yyysxm_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getYyYSxmInfo.action',
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            params: {
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                XMLX_ID: Ext.ComponentQuery.query('combobox[name="YYXM_XMLX_ID"]')[0].value,
                BILL_YEAR: Ext.ComponentQuery.query('textfield[name="YYXM_BILL_YEAR"]')[0].value,
                JS_YEAR: Ext.ComponentQuery.query('textfield[name="JS_YEAR"]')[0].value
            },
            autoLoad: true,
            checkBox: true,
            border: false,
            height: '100%',
            width: '100%',
            pageConfig: {
                enablePage: false
            },
            dockedItems: [search_form],
            features: [{
                ftype: 'summary'
            }]
        });
        return grid;
    }

    /**
     * 获取已有预算项目
     */
    function getYyysxm() {
        var XMLX_ID = Ext.ComponentQuery.query('combobox[name="YYXM_XMLX_ID"]')[0].value;
        var MHCX = Ext.ComponentQuery.query('textfield[name="YYXM_MHCX"]')[0].value;
        var BILL_YEAR = Ext.ComponentQuery.query('combobox[name="YYXM_BILL_YEAR"]')[0].value;
        var JS_YEAR = Ext.ComponentQuery.query('combobox[name="JS_YEAR"]')[0].value;
        if (JS_YEAR == null || JS_YEAR == '') {
            Ext.MessageBox.alert('提示', '收支决算年度不能为空');
            return;
        }
        var grid = DSYGrid.getGrid('yyysxm_grid');
        var store = grid.getStore();
        //增加查询参数
        store.getProxy().extraParams["XMLX_ID"] = XMLX_ID;
        store.getProxy().extraParams["MHCX"] = MHCX;
        store.getProxy().extraParams["BILL_YEAR"] = BILL_YEAR;
        store.getProxy().extraParams["JS_YEAR"] = JS_YEAR;
        //刷新
        store.loadPage(1);
    }

    /**
     * 收支决算录入弹出窗口
     */
    function initWin_input(js_year, xm_id, XMLX_ID, JSD_ID) {
        records_delete = [];
        var config = {
            title: '收支决算' + button_text, // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWin_input_form(js_year, xm_id, XMLX_ID, JSD_ID)],
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    hidden: !is_edit,
                    itemId: 'tzjhInsertBtn',
                    handler: function (btn) {
                        if (!is_save) {
                            Ext.MessageBox.alert('提示', " 存在大额数据，请检查数据！ ");
                            return false;
                        }
                        //保存数据
                        //获取项目id,年度
                        var form = Ext.ComponentQuery.query('form[name="jslr"]')[0];
                        var JSD_ID = form.getForm().findField('JSD_ID').getValue();
                        var XM_ID = form.getForm().findField('XM_ID').getValue();
                        var JS_YEAR = form.getForm().findField('JS_YEAR').getValue();
                        var YS_YEAR = form.getForm().findField('YS_YEAR').getValue();
                        //获取grid数据
                        var leftgrid = btn.up('window').down('grid#jsGrid_left');
                        var rightgrid = btn.up('window').down('grid#jsGrid_right');
                        var gridData = [];//所有明细数据
                        for (var i = 0; i < leftgrid.getStore().getCount(); i++) {
                            var record = leftgrid.getStore().getAt(i);
                            if (!record.get("ZXAMT")) {
                                Ext.Msg.alert('提示', '执行数不能为空！');
                                return false;
                            }
                            gridData.push(record.data);
                        }
                        for (var i = 0; i < rightgrid.getStore().getCount(); i++) {
                            var record = rightgrid.getStore().getAt(i);
                            if (!record.get("ZXAMT")) {
                                Ext.Msg.alert('提示', '执行数不能为空！');
                                return false;
                            }
                            gridData.push(record.data);
                        }
                        $.post('saveszjs.action', {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name, //这里要先生成主键id传回后台
                            BUTTON_TEXT: button_text,
                            JSD_ID: JSD_ID,//虚拟主单ID
                            XM_ID: XM_ID,
                            JS_YEAR: JS_YEAR,
                            YS_YEAR: YS_YEAR,
                            XMLX_ID: XMLX_ID,
                            detailList: Ext.util.JSON.encode(gridData)
                        }, function (data) {
                            if (data.success) {
                                btn.up('window').close();
                                Ext.toast({
                                    html: "保存成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                /*Ext.ComponentQuery.query('button[name="edit"]')[0].setDisabled(false);
                                Ext.ComponentQuery.query('button[name="add"]')[0].setDisabled(true);
                                Ext.ComponentQuery.query('button[name="delete"]')[0].setDisabled(true);
                                Ext.ComponentQuery.query('button[name="save"]')[0].setDisabled(true);*/
                                // 刷新表格
                                reloadGrid();
                            } else {
                                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                            }

                        }, 'JSON');
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        };
        return Ext.create('Ext.window.Window', config);
    }

    /**
     * 初始化债券转贷表单
     */
    function initWin_input_form(js_year, xm_id, XMLX_ID, JSD_ID) {
        return Ext.create('Ext.form.Panel', {
            //renderTo : Ext.getBody(),
            name: 'jslr',
            autoHeight: true,
            autoScroll: true,
            stripeRows: true,
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'fieldcontainer',
                    title: '',
                    layout: {
                        type: 'column',//竖直布局 item 有一个 flex属性
                        align: 'stretch' //拉伸使其充满整个父容器
                    },
                    defaultType: 'textfield',
                    border: false,
                    anchor: '100%',
                    collapsible: false,
                    fieldDefaults: {
                        labelWidth: 70,
                        columnWidth: .25,
                        margin: '5 0 5 5'
                    },
                    items: [
                        {
                            xtype: 'textfield',
                            fieldLabel: '决算虚拟主单id',
                            name: 'JSD_ID',
                            hideTrigger: true,
                            readOnly: true,
                            hidden: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '项目id',
                            name: 'XM_ID',
                            hideTrigger: true,
                            readOnly: true,
                            hidden: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        /*{
                            xtype: 'string',
                            fieldLabel: '项目名称',
                            name: 'XM_NAME',
                            //hideTrigger: true,
                            //readOnly: true,
                            //fieldStyle: 'background:#E6E6E6',
                            renderer: function (data, cell, record) {
                                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                                var paramNames=new Array();
                                paramNames[0]="XM_ID";
                                var paramValues=new Array();
                                paramValues[0]=record.get('XM_ID');
                                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                                return result;
                            }
                        },*/
                        {
                            xtype: "displayfield",
                            fieldLabel: '项目名称',
                            name: "XM_NAME",
                            tdCls: 'grid-cell-unedit'
                            //columnWidth: 0.66
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '立项年度',
                            name: 'LX_YEAR',
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '预算开始年度',
                            name: 'YS_YEAR',
                            hideTrigger: true,
                            hidden: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '建设性质',
                            name: 'JSXZ_NAME',
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '项目性质',
                            name: 'XMXZ_NAME',
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '项目类型',
                            name: 'XMLX_NAME',
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '建设状态',
                            name: 'BUILD_STATUS_NAME',
                            hideTrigger: true,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        /*{
                            xtype: 'combobox',
                            fieldLabel: '年度',
                            name: 'XMZTR_AMT',
                            hideTrigger: true,
                            value: nowDate.substr(0, 4),
                            format:'Y',
                            //labelAlign: 'right',
                            displayField: 'name',
                            valueField: 'id',
                            store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"})
                        },*/
                        {
                            fieldLabel: '年度',
                            name: 'JS_YEAR',
                            xtype: 'combobox',
                            //value:ndgl>nowDate.substr(0,4)?ndgl:nowDate.substr(0,4),
                            value: ndgl,
                            editable: false,
                            displayField: 'name',
                            valueField: 'id',
                            readOnly: true,//button_name!='新增'||!is_edit,
                            //fieldStyle:!is_edit? 'background:#E6E6E6':'background:#ffffff',
                            fieldStyle: 'background:#E6E6E6',
                            store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '" + ndgl + "'"}),
                            allowBlank: false,
                            listeners: {
                                change: function (self, newValue) {
                                }
                            }
                        }
                    ]
                },
                insert_grid(js_year, xm_id, XMLX_ID, JSD_ID)
            ],
            listeners: {
                'beforeRender': function () {

                }
            }
        });
    }

    function insert_grid(js_year, xm_id, XMLX_ID, JSD_ID) {
        return Ext.create('Ext.panel.Panel', {
            //renderTo : Ext.getBody(),
            border: false,
            autoHeight: true,
            //autoScroll: true,
            //stripeRows: true,
            layout: {
                type: 'hbox'
            },
            xtype: 'layout-horizontal-box',
            width: '100%',
            frame: false,
            items: [
                insert_leftgrid_panel(js_year, xm_id, XMLX_ID, JSD_ID)
                , insert_rightgrid_panel(js_year, xm_id, XMLX_ID, JSD_ID)
            ]
        });
    }

    function insert_leftgrid_panel(js_year, xm_id, XMLX_ID, JSD_ID) {
        return Ext.create('Ext.panel.Panel', {
            //renderTo : Ext.getBody(),
            border: false,
            autoHeight: true,
            //autoScroll: true,
            //stripeRows: true,
            margin: '1 0 1 1',
            layout: {
                type: 'fit'
            },
            width: '50%',
            frame: false,
            items: [initWindow_zqxxtb_contentForm_tab_xmsy_grid_left(js_year, xm_id, XMLX_ID, JSD_ID)]
        });
    }

    function insert_rightgrid_panel(js_year, xm_id, XMLX_ID, JSD_ID) {
        return Ext.create('Ext.panel.Panel', {
            //renderTo : Ext.getBody(),
            border: false,
            autoHeight: true,
            //autoScroll: true,
            //stripeRows: true,
            margin: '1 1 1 0',
            layout: {
                type: 'fit'
            },
            width: '50%',
            frame: false,
            items: [initWindow_zqxxtb_contentForm_tab_xmsy_grid_right(js_year, xm_id, XMLX_ID, JSD_ID)]
        });
    }

    function initWindow_zqxxtb_contentForm_tab_xmsy_grid_right(js_year, xm_id, XMLX_ID, JSD_ID) {
        var headerJson = [
            {
                dataIndex: "SZLB_NAME", type: "string", text: "项目", width: 230,
                renderer: function (self, value) {
                    if (XMLX_ID == "05") {
                        return getNewName(self, value);
                    } else {
                        return getTyName(self, value);
                    }
                }
            },
            {
                dataIndex: "ZXAMT", type: "string", text: "执行数（万元）",
                editor: {
                    xtype: 'numberFieldFormat',
                    hideTrigger: true,
                    decimalPrecision: 6,
                    value: 0,
                    maxValue: 9999999999,
                    minValue: 0,
                    allowBlank: false,
                    readOnly: !is_edit,
                    editable: is_edit
                }, width: 120,
                renderer: function (value) {
                    return value != '' ? Ext.util.Format.number(value, '0,000.00') : 0;
                }
            },
            {
                dataIndex: "YSAMT", type: "string", text: "预算数（万元）", width: 120,
                renderer: function (value) {
                    return value != '' ? Ext.util.Format.number(value, '0,000.00') : 0;
                }
            },
            {
                dataIndex: "PERCENT", type: "string", text: "预算数为执行数的%", width: 200,
                renderer: function (self, value) {
                    return getNewPercent(self, value);
                }
            }
        ];
        /**
         * 设置表格属性
         */
        var config = {
            itemId: 'jsGrid_right',
            border: false,
            flex: 1,
            dataUrl: 'getszlbSotre.action?IS_TCLB=1&&IS_SZJS=1&&IS_LEFT=0&&YEAR=' + js_year + '&&XM_ID=' + xm_id + '&&JSD_ID=' + JSD_ID + '&&YS_YEAR=' + ys_year + '&&XMLX_ID=' + XMLX_ID,
            params: {},
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: true,
                columnCls: 'normal'
            },
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'xmsyCellEdit',
                    clicksToMoveEditor: 1,
                    listeners: {}
                }
            ],
            listeners: {
                cellclick: function (grid, rowIndex, columnIndex, e) {
                    if (e.data.IS_EDIT == '0' && (button_name == 'btn_insert' || button_name == 'btn_update')) {
                        return false;
                    } else if ((button_name != 'btn_insert' && button_name != 'btn_update') || e.data.SZLB_CODE == '03') {
                        return false;
                    } else {
                        return true;
                    }
                },
                edit: function (editor, context) {
                    //赋值
                    if (XMLX_ID == '05') {
                        set_newvalue(context);
                    } else {
                        set_ty_newvalue(context);
                    }

                }
            }

        };
        //生成表格
        var grid = DSYGrid.createGrid(config);
        //添加关系
        var grid = DSYGrid.createGrid(config);
        grid.getStore().on('load', function () {
            get_relation(grid);
        });
        return grid;
    }

    function initWindow_zqxxtb_contentForm_tab_xmsy_grid_left(js_year, xm_id, XMLX_ID, JSD_ID) {
        var headerJson = [
            {
                dataIndex: "SZLB_NAME", type: "string", text: "项目", width: 230,
                renderer: function (self, value) {
                    if (XMLX_ID == "05") {
                        return getNewName(self, value);
                    } else {
                        return getTyName(self, value);
                    }
                }
            },
            {
                dataIndex: "ZXAMT", type: "string", text: "执行数（万元）",
                editor: {
                    xtype: 'numberFieldFormat', hideTrigger: true, decimalPrecision: 6,
                    value: 0, maxValue: 9999999999, minValue: 0, readOnly: !is_edit, editable: is_edit
                }, width: 120,
                renderer: function (value) {
                    return value != '' ? Ext.util.Format.number(value, '0,000.00') : 0;
                }
            },
            {
                dataIndex: "YSAMT", type: "string", text: "预算数（万元）", width: 120,
                renderer: function (value) {
                    return value != '' ? Ext.util.Format.number(value, '0,000.00') : 0;
                }
            },
            {
                dataIndex: "PERCENT", type: "string", text: "预算数为执行数的%", width: 200,
                renderer: function (self, value) {
                    return getNewPercent(self, value);
                }
            }
        ];
        /**
         * 设置表格属性
         */
        var config = {
            itemId: 'jsGrid_left',
            border: false,
            flex: 1,
            dataUrl: 'getszlbSotre.action?IS_TCLB=1&&IS_SZJS=1&&IS_LEFT=1&&YEAR=' + js_year + '&&XM_ID=' + xm_id + '&&JSD_ID=' + JSD_ID + '&&YS_YEAR=' + ys_year + '&&XMLX_ID=' + XMLX_ID,
            params: {},
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: true,
                columnCls: 'normal'
            },
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'xmsyCellEdit',
                    clicksToMoveEditor: 1,
                    listeners: {}
                }
            ],
            listeners: {
                cellclick: function (grid, rowIndex, columnIndex, e) {
                    if (e.data.IS_EDIT == '0' && (button_name == 'btn_insert' || button_name == 'btn_update')) {
                        return false;
                    } else if (button_name != 'btn_insert' && button_name != 'btn_update') {
                        return false;
                    } else {
                        return true;
                    }
                },
                edit: function (editor, context) {
                    //赋值
                    if (XMLX_ID == '05') {
                        set_newvalue(context);
                    } else {
                        set_ty_newvalue(context);
                    }

                }
            }
        };
        //生成表格
        var grid = DSYGrid.createGrid(config);
        //添加关系
        var grid = DSYGrid.createGrid(config);
        grid.getStore().on('load', function () {
            get_relation(grid);
        });
        return grid;
    }

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        // 选择当前被选中记录的数组
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var inputList = new Array();
        for (var i in records) {
            inputList.push({"ID": records[i].get("JSD_ID")});
        }
        button_text = btn.text;
        if (button_text == '送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/doWorkFlowforJSD.action", {
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        BUTTON_TEXT: button_text,
                        audit_info: '',
                        inputList: Ext.util.JSON.encode(inputList)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({html: button_text + "成功！"});
                        } else {
                            Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + "意见",
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/doWorkFlowforJSD.action", {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            BUTTON_TEXT: button_text,
                            audit_info: text,
                            inputList: Ext.util.JSON.encode(inputList)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({html: button_text + "成功！"});
                            } else {
                                Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                            }
                            //刷新表格
                            reloadGrid();
                        }, "json");
                    }
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

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //AG_CODE 由单位树获取
        store.getProxy().extraParams['AD_CODE'] = AD_CODE;
        store.getProxy().extraParams['AG_CODE'] = AG_CODE;
        store.removeAll();
        //刷新
        store.loadPage(1);
    }

    /**
     * 操作记录
     */
    function oprationRecord() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var JSD_ID = records[0].get("JSD_ID");
            fuc_getWorkFlowLog(JSD_ID);
        }
    }

    /**
     * 获取收支决算录入信息
     */
    function getView() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length != 1) {
            Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
            return;
        }
        Viewshow(records[0]);
    }

    /*显示收支决算编辑框 */
    function Viewshow(record) {
        //弹出填报页面，并写入债券信息以及明细信息
        var window_input = Ext.ComponentQuery.query('window#window_input')[0];
        var JSD_ID = record.data.JSD_ID;
        if (!window_input) {
            var data = record.data;
            //年度与项目立项年度比较
            ndgl = data.JS_YEAR;
            //是否可编辑以及是否可保存
            is_edit = button_text == '查看' ? false : true;//查看为不可编辑，false
            js_year = data.JS_YEAR;
            ys_year = data.YS_YEAR;
            window_input = initWin_input(js_year, data.XM_ID, data.XMLX_ID, JSD_ID);
            xmlx_id = data.XMLX_ID;
            var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
            var paramNames = new Array();
            paramNames[0] = "XM_ID";
            var paramValues = new Array();
            paramValues[0] = record.get('XM_ID');
            var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data.XM_NAME + '</a>';
            data.XM_NAME = result;

            window_input.down('[name=jslr]').getForm().setValues(data);
            window_input.show();
        }
    }

    /*删除已录入的决算单 */
    function DeleteJSD() {
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                var ids = [];
                for (var i in records) {
                    ids.push(records[i].get("JSD_ID"));
                }
                //发送ajax请求，删除数据
                $.post("/deleteszjsxx.action", {
                    ids: ids,
                    wf_id: wf_id,
                    node_code: node_code,
                    wf_status: WF_STATUS
                }, function (data) {
                    if (data.success) {
                        Ext.toast({html: button_text + "成功！"});
                    } else {
                        Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        });
    }

    /**
     * 获取对应关系
     */
    function get_relation(grid) {
        var store = grid.getStore().data;
        for (var i = 0; i < store.length; i++) {
            var record = store.items[i];
            var guid = record.get("SZLB_ID");
            var value = record.get("ZXAMT");
            var infor = [];
            infor[0] = grid.itemId;
            infor[1] = value;
            infor[2] = i;
            grid_relation[guid] = infor;
        }
    }

    /**
     * 通用赋值
     */
    function set_ty_newvalue(context) {
        var jslrForm = Ext.ComponentQuery.query('form[name="jslr"]')[0];
        // 旧值
        var oldValue = context.originalValue;
        // 新值
        var newValue = context.value;
        // 新值与就值差
        var value = newValue - oldValue;
        // 获取当前guid=szlb_id
        var guid = context.record.get("SZLB_ID");
        /*// 给0204赋值
        if(guid == '0301'){//当前为其中：财务费用-专项债券付息，修改（四）财政安排专项债券付息资金
            var store=jslrForm.down('grid#'+grid_relation['0204'][0]+'').getStore();
            var record = store.getAt(grid_relation['0204'][2]);
            record.set(context.field, newValue);
            context.record.set("PERCENT",Getzxysb(record,'0204'));
            grid_relation['0204'][1]=context.value;
            setValue(context,jslrForm);
            return;
        }
        // 给0205赋值
        if(guid == '0302'){//当前为财务费用-市场化融资付息，修改（五）项目单位市场化融资付息资金
            var store=jslrForm.down('grid#'+grid_relation['0205'][0]+'').getStore();
            var record = store.getAt(grid_relation['0205'][2]);
            record.set(context.field, newValue);
            context.record.set("PERCENT",Getzxysb(record,'0205'));
            grid_relation['0205'][1]=context.value;
            setValue(context,jslrForm);
            return;
        }*/
        if (guid == '020201') {
            if (xmlx_id != '05') {
                if (newValue > grid_relation['0202'][1]) {
                    Ext.MessageBox.alert('提示', "其中：用于资本金超出地方政府专项债券！");
                    Ext.ComponentQuery.query('button#tzjhInsertBtn')[0].setDisabled(true);
                } else {
                    Ext.ComponentQuery.query('button#tzjhInsertBtn')[0].setDisabled(false);
                }
            }
            return;
        }
        // 赋值%
        grid_relation[context.record.get("SZLB_ID")][1] = newValue;
        context.record.set('PERCENT', Getzxysb(context.record, context.record.get("SZLB_ID")));
        // 根据上级guid获取需要更改的值
        for (var count = 0; count < guid.length / 2; count++) {
            // 获取上级guid
            var newgrid = guid.substr(0, guid.length - 2 * (count + 1));
            if (newgrid.length < 2) {
                continue;
            }
            var newvalue = 0;
            // 获取上级对应的值，更改对应的值
            if (typeof grid_relation[newgrid] != "undefined") {
                newvalue = Number(grid_relation[newgrid][1]) + value;
                if (newvalue * 10000 > 99999999999999.99) {
                    is_save = false;
                    Ext.MessageBox.alert('提示', " 存在超额情况，请检查数据！ ");
                } else {
                    is_save = true;
                }
                // 重新赋值
                grid_relation[newgrid][1] = newvalue;
                var store = jslrForm.down('grid#' + grid_relation[newgrid][0] + '').getStore();
                var record = store.getAt(grid_relation[newgrid][2]);
                record.set(context.field, grid_relation[newgrid][1]);
                // 赋值%
                record.set('PERCENT', Getzxysb(record, newgrid));
            }
        }
        setValue(context, jslrForm);
    }

    // 重新赋值运算
    function setValue(context, jslrForm) {
        // 给02赋值
        var B = Number(grid_relation['0201'][1]) + Number(grid_relation['0202'][1])
            + Number(grid_relation['0203'][1]) + Number(grid_relation['0204'][1])/*+Number(grid_relation['0205'][1])*/;

        var store = jslrForm.down('grid#' + grid_relation['02'][0] + '').getStore();
        var record = store.getAt(grid_relation['02'][2]);
        record.set(context.field, B);
        record.set('PERCENT', Getzxysb(record, '02'));// 赋值%

        // 赋值结转下年资金
        var M = B - Number(grid_relation['03'][1]) - Number(grid_relation['04'][1]);
        var store = jslrForm.down('grid#' + grid_relation['05'][0] + '').getStore();
        var record = store.getAt(grid_relation['05'][2]);
        record.set(context.field, M);
        record.set('PERCENT', Getzxysb(record, '05'));// 赋值%
    }

    /**
     *  赋值
     */
    function set_newvalue(context) {
        var jslrForm = Ext.ComponentQuery.query('form[name="jslr"]')[0];
        //知道新值，旧值，上层superguid
        var oldValue = context.originalValue;
        var newValue = context.value;
        var value = newValue - oldValue;
        var guid = context.record.get("SZLB_ID");
        //赋值%
        grid_relation[context.record.get("SZLB_ID")][1] = newValue;
        context.record.set('PERCENT', Getzxysb(context.record, context.record.get("SZLB_ID")));
        //根据上级guid获取需要更改的值
        for (var count = 0; count < guid.length / 2; count++) {
            //获取上级guid
            var newgrid = guid.substr(0, guid.length - 2 * (count + 1));
            if (newgrid.length < 2) {
                return;
            }
            var newvalue = 0;
            //获取上级对应的值，更改对应的值
            if (typeof grid_relation[newgrid] != "undefined") {
                newvalue = Number(grid_relation[newgrid][1]) + value;
                if (newvalue * 10000 > 99999999999999.99) {
                    is_save = false;
                    Ext.MessageBox.alert('提示', " 存在超额情况，请检查数据！ ");
                } else {
                    is_save = true;
                }
                //重新赋值
                grid_relation[newgrid][1] = newvalue;
                var store = jslrForm.down('grid#' + grid_relation[newgrid][0] + '').getStore();
                var record = store.getAt(grid_relation[newgrid][2]);
                record.set(context.field, grid_relation[newgrid][1]);
                //赋值%
                record.set('PERCENT', Getzxysb(record, newgrid));
                //重新赋值结转下年资金
                var jzstore = jslrForm.down('grid#' + grid_relation['04'][0] + '').getStore();
                var jzrecord = jzstore.getAt(grid_relation['04'][2]);
                var cwrecord = jzstore.getAt(grid_relation['0302'][2]);

                var jzamt = Number(grid_relation['01'][1]) + Number(grid_relation['02'][1]) - Number(grid_relation['0301'][1]);
                if (newvalue * 10000 > 99999999999999.99) {
                    is_save = false;
                    Ext.MessageBox.alert('提示', " 存在超额情况，请检查数据！ ");
                } else {
                    is_save = true;
                }
                grid_relation['04'][1] = jzamt;
                var K = Number(grid_relation['0202'][1]);
                grid_relation['0302'][1] = K;
                jzrecord.set(context.field, grid_relation['04'][1]);
                cwrecord.set(context.field, K);
                //赋值%
                jzrecord.set('PERCENT', Getzxysb(jzrecord, '04'));
                cwrecord.set('PERCENT', Getzxysb(cwrecord, '0302'));

            }
        }
    }

    /**
     * 获取执行数与预算数的比
     * @constructor
     */
    function Getzxysb(record, gridname) {
        var zx_ys = '';
        if (record.get('YSAMT') == '0') {
            zx_ys = 0.00;
        } else {
            zx_ys = grid_relation[gridname][1] * 100 / record.get('YSAMT');
        }
        return zx_ys.toFixed(2) + '%';
    }

    /**
     * 重新获取收支类别名称
     */
    function getNewName(self, value) {
        var name = {
            "02": "二、本年收到土地储备项目资金",
            "0201": "（一）本年土地储备专项债券资金",
            "0202": "（二）财政安排土地储备专项债券付息资金",
            "0203": "（三）本年其他财政预算资金"
        };
        var guid = value.record.data.SZLB_ID;
        if (typeof name[guid] != "undefined") {
            return name[guid];
        }
        return self;
    }

    /**
     * 重新获取通用收支类别名称
     */
    function getTyName(self, value) {
        var name = {};
        var guid = value.record.data.SZLB_ID;
        if (typeof name[guid] != "undefined") {
            return name[guid];
        }
        return self;
    }

    /**
     * 获取新的%
     * @param self
     * @param value
     */
    function getNewPercent(self, value) {
        var zx_ys = '';
        if (value.record.get('YSAMT') == '0') {
            zx_ys = 0.00;
        } else {
            zx_ys = Number(value.record.get('ZXAMT')) * 100 / Number(value.record.get('YSAMT'));
        }
        return zx_ys.toFixed(2) + '%';
    }

    /**
     * 修改、删除校验决算
     */
    function checkJs() {
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length != 1) {
            Ext.MessageBox.alert('提示', '请选择一条后再进行操作');
            return;
        }
        var XM_ID = records[0].data.XM_ID;
        var JS_YEAR = records[0].data.JS_YEAR;
        //发送ajax请求，删除数据
        $.post("/checkJshave.action", {
            BUTTON_NAME: button_name,
            XM_ID: XM_ID,
            JS_YEAR: JS_YEAR
        }, function (data) {
            if (data.success) {
                Ext.MessageBox.alert('提示', "存在大于" + JS_YEAR + "年的决算数据，不允许" + button_text + "!");
            } else {
                if (button_name == 'btn_update') {
                    getView();
                } else if (button_name == 'btn_del') {
                    DeleteJSD();
                }
            }
        }, "json");
    }

</script>
</body>
</html>
