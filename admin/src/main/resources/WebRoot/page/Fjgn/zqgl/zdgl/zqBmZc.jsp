<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>

    <title>新增债券部门支出</title>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">

</head>
<body>

</body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/page/debt/gxdz/12_tj/peLockCheck.js"></script>
<script type="text/javascript" >
    //天津个性化url参数：12
/*
    var GxdzUrlParam=getQueryParam("GxdzUrlParam");
*/
    var GxdzUrlParam ="${fns:getParamValue('GxdzUrlParam')}";
    // 自定义参数
    var button_name = ''; // 当前操作按钮名称id
    var button_text = ''; // 当前操作按钮名称text
    var editValue = true; // 附件是否可编辑
    var save_button = [
        {
            text: '保存',
            name: 'save',
            handler: function (btn) {
                submitZqxmSjzcTb(btn);
            }
        },
        {
            text: '取消',
            name: 'CLOSE',
            handler: function (btn) {
                btn.up('window').close();
            }
        }
    ];

    // 按钮是否展示
    var button = save_button;
    // 获取session 数据
    var ad_code = '${sessionScope.ADCODE}';  // 获取地区名称
    var nowDate = '${fns:getDbDateDay()}';
    var USER_AG_CODE='${sessionScope.AGCODE}';
    var USER_AG_ID = '${sessionScope.AGID}';
    var USER_AG_NAME = '${sessionScope.AGNAME}';
    var dw_AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");

    // 获取URL参数
    var wf_id = getQueryParam("wf_id"); // 当前工作流流程id
    var node_code = getQueryParam("node_code"); // 当前工作流节点id
    var node_type = getQueryParam("node_type"); // 当前节点名称
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    //新增债券实际支出id，新录一笔数据的时候生成
    var xzzqSjzcId;
    // 自定义json 数据
    var km_year = nowDate.substr(0,4);
    var km_condition = km_year <= 2017 ? " <= '2017' " :" = '"+ km_year +"' ";
    var zcgnfl_store = DebtEleTreeStoreDB('EXPFUNC',{condition: "and year " + km_condition});
    var zcjjfl_store = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});
    var zqSjzcXzMain_toolbar_json = {
        lr: { //录入
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
                        text: '录入',
                        name: 'INPUT',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.name;
                            button_text = btn.text;
                            editValue = true;
                            button = save_button;
                            zqbfmxInfo_select_window(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                editValue = true;
                                button = save_button;
                                button_name = btn.name;
                                button_text = btn.text;
                                xzzqSjzcId = records[0].get('SJZC_ID');
                                zqxmSjzc_insert_window(btn);
                                var xmzxFormRecords = records[0].getData();
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                                xmtztbForm.getForm().setValues(xmzxFormRecords);
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delZqxmBmzcInfo(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
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
                        text: '撤销送审',
                        name: 'cancel',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
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
                '004': [
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
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                editValue = true;
                                button = save_button;
                                button_name = btn.name;
                                button_text = btn.text;
                                xzzqSjzcId = records[0].get('SJZC_ID');
                                zqxmSjzc_insert_window(btn);
                                var xmzxFormRecords = records[0].getData();
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                                xmtztbForm.getForm().setValues(xmzxFormRecords);

                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delZqxmBmzcInfo(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
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
                '008': [
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
        },
        sh: {//审核
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
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销审核',
                        name: 'cancel',
                        icon: '/image/sysbutton/audit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
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
        }
    };
    /**
     *  页面初始化
     */
    $(document).ready(function () {
        initContent();
    });
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'code'},
            {name: 'id'},
            {name: 'leaf'}
        ]
    });
    /**
     *  初始化主面板
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zqSjzcXzMain_toolbar_json[node_type].items[WF_STATUS]
                }
            ],
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            items: [
                /*initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),*///初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
        });

    }

    /**
     * 初始化右侧panel
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'contentFormPanel',
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'padding:0 0 0 0',
                    defaults: {
                        margin: '1 1 2 5',
                        width: 200,
                        labelWidth: 80,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
                        {
                            xtype: 'combobox',
                            fieldLabel: '状态',
                            name: 'WF_STATUS',
                            store: node_type == 'lr' ? DebtEleStore(json_debt_zt1) : DebtEleStore(json_debt_zt2_3),
                            width: 110,
                            labelWidth: 30,
                            editable: false,
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
                                    toolbar.add(zqSjzcXzMain_toolbar_json[node_type].items[WF_STATUS]);
                                    //刷新当前表格
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "MHCX",
                            labelWidth: 80,
                            width: 300,
                            emptyText: '请输入项目名称/债券名称...',
                            enableKeyEvents: true,
                            listeners: {
                                'keydown': function (self, e, eOpts) {
                                    var key = e.getKey();
                                    if (key == Ext.EventObject.ENTER) {
                                        reloadGrid();
                                    }
                                }
                            }
                        }
                    ]
                }
            ],
            border: false,
            items: [
                initContentGrid()
            ]
        });
    }

    /**
     * 初始化右侧Panel主表格
     */
    function initContentGrid() {
        var contentHeaderJson = [
            {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
            {
                dataIndex: "SJZC_ID",
                type: "string",
                text: "ID",
                width: 80,
                hidden: true
            },
            {
                dataIndex: "SJZC_NO",

                type: "string",
                text: "支出单号",
                width: 150
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                text: "项目单位",
                width: 250
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                text: "债券名称",
                width: 300,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('FIRST_ZQ_ID');
                    paramValues[1] = record.get('AD_CODE');
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                text: "项目名称",
                width: 300,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = 'IS_RZXM';

                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                dataIndex: "XMLX_NAME",
                type: "string",
                text: "项目分类",
                width: 150
            },
            {
                dataIndex: "SJZC_AMT", width: 200, type: "float", text: "本次支出金额（元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "ZCZY",
                type: "string",
                text: "支出摘要",
                width: 200
            },
            {
                dataIndex: "SS_AG_NAME",
                type: "string",
                text: "资金使用单位",
                width: 200,
                hidden:node_type=='sh'?false:true
            },
            {
                dataIndex: "XMGYF",
                type: "string",
                text: "项目施工单位",
                width: 200,
                hidden:node_type=='sh'?false:true
            },
            {
                dataIndex: "REMARK",
                type: "string",
                text: "备注",
                width: 200
            },
            {
                dataIndex: "FJ",
                type: "string",
                text: "附件",
                width: 80,
                hidden:node_type=='sh'?false:true,
                renderer: function (data, cell, record) {
                    var ywsjid=record.data.SJZC_ID;
                    return '<button style="height: 20px;width: 50px;" onclick="getFJXX(\''+ywsjid+'\')">'+'附件'+'</button>';
                }
            },
            {
                dataIndex:'SJ_ZC_DATE',width:200,type:'string',text:'上级支出日期',hidden:true
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'contentGrid',
            flex: 1,
            autoLoad: true,
            border: false,
            checkBox: true,
            headerConfig: {
                headerJson: contentHeaderJson,
                columnAutoWidth: false
            },
            enableLocking:false,
            dataUrl: 'getZqxmBmzcInfo.action',
            params: {
                AD_CODE: ad_code,
                AG_ID: USER_AG_ID,
                AG_CODE: USER_AG_CODE,
                wf_id: wf_id,
                node_code: node_code,
                node_type: node_type,
                button_name: button_name,
                WF_STATUS: WF_STATUS
            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            },
            listeners: {
                itemdblclick: function (self, record) {
                    editValue = false;
                    button = [];
                    zqxmSjzc_insert_window();
                    var xmzxFormRecords = record.getData();
                    var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                    xmtztbForm.getForm().setValues(xmzxFormRecords);
                    SetFormItemsReadOnly(xmtztbForm.items);
                }
            }
        });
        return grid;
    }

    /**
     *  获取债券拨付到项目资金明细
     */
    function zqbfmxInfo_select_window(btn) {
        var window = Ext.create('Ext.window.Window', {
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            title: '债券项目实际拨付明细', // 窗口标题
            itemId: 'item_zqbfmxInfo_select_windows', // 窗口标识
            layout: 'fit',
            maximizable: true, //最大化按钮
            buttonAlign: 'right', // 按钮显示的位置
            closeAction: 'destroy', //hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            items: [init_zqbfmxInfo_Grid()],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var records = btn.up('window').down('grid').getSelection(); // 获取选中数据信息
                        if (records.length < 1) {
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                            $.post('/getZqxmBmzcZcNo.action', {
                                AD_CODE: ad_code
                            }, function (data) {
                                if (!data.success) {
                                    btn.setDisabled(true);
                                    Ext.MessageBox.alert('提示', '获取项目相关信息失败！' + data.message);
                                    return;
                                }
                                xzzqSjzcId = GUID.createGUID();
                                zqxmSjzc_insert_window(btn);
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                                var xmtzFormRecords = records[0].getData();
                                xmtzFormRecords.SJZC_ID = xzzqSjzcId;
                                xmtzFormRecords.SJZC_NO = data.list[0].SJZC_NO;
                                xmtztbForm.getForm().setValues(xmtzFormRecords);
                                btn.up('window').close();
                            }, 'json');

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
        window.show();
        return window;
    }

    /**
     *  初始化实际拨付gridpanel
     */
    function init_zqbfmxInfo_Grid() {
        var zxkXmtz_Grid_headerjson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "XM_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
            {dataIndex: "AG_NAME", width: 250, type: "string", text: "项目单位"},
            {dataIndex: "ZQ_CODE", width: 150, type: "string", text: "债券编码"},
            {
                dataIndex: "ZQ_NAME", width: 300, type: "string", text: "债券名称",
                renderer: function (data, cell, record) {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('FIRST_ZQ_ID');
                    paramValues[1] = record.get('AD_CODE');
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
            {
                dataIndex: "XM_NAME", width: 300, type: "string", text: "项目名称",
                renderer: function (data, cell, record) {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = 'IS_RZXM';

                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {dataIndex: "XMLX_NAME", width: 150, type: "string", text: "项目类型"},
            {
                dataIndex: "BF_AMT", width: 150, type: "float", text: "拨付金额（元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "YZC_AMT", width: 180, type: "float", text: "已支出金额（元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "SJZC_AMT", width: 200, type: "float", text: "剩余可支出金额（元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex:'SJ_ZC_DATE',width:200,type:'string',text:'上级支出日期',hidden:true
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'item_zqbfmxInfo_grid',
            flex: 1,
            autoLoad: true,
            border: false,
            checkBox: true,
            headerConfig: {
                headerJson: zxkXmtz_Grid_headerjson,
                columnAutoWidth: false
            },
            dataUrl: 'getZqxmZcInfo_bm.action',
            params: {
                AD_CODE: AD_CODE,
                AG_ID: USER_AG_ID,
                AG_CODE: USER_AG_CODE
            },
            tbar: [
                {
                    xtype: "textfield",
                    fieldLabel: '模糊查询',
                    itemId: "XM_SEARCH",
                    labelWidth: 80,
                    width: 300,
                    emptyText: '请输入项目名称/债券名称...',
                    enableKeyEvents: true,
                    listeners: {
                        'keydown': function (self, e, eOpts) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reloadTzxmGrid(self);
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reloadTzxmGrid(btn);
                    }
                }
            ],
            selModel: {
                mode: "SINGLE"
            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            }
        });
        return grid;
    }

    /**
     * 刷新债券项目拨付信息
     * @param btn
     */
    function reloadTzxmGrid(btn) {
        var xmSelectGrid = btn.up('grid');
        var xmSelectGridStore = xmSelectGrid.getStore();
        xmSelectGridStore.removeAll();
        var xm_search = xmSelectGrid.down('textfield[itemId="XM_SEARCH"]').getValue();
        xmSelectGridStore.getProxy().extraParams = {
            AD_CODE: ad_code,
            AG_ID: USER_AG_ID,
            AG_CODE: USER_AG_CODE,
            XM_SEARCH: xm_search
        };
        xmSelectGridStore.loadPage(1);
    }

    /**
     * 债券项目部门支出信息填报窗口
     */
    function zqxmSjzc_insert_window() {
        var window = Ext.create('Ext.window.Window', {
            width: document.body.clientWidth * 0.8, // 窗口宽度
            height: document.body.clientHeight * 0.8, // 添加
            title: '债券项目部门支出填报',
            itemId: 'item_zqxmSjzcTb_window',
            layout: 'fit',
            frame: true,
            constrain: true, // 防止超出浏览器边界
            buttonAlign: "right", // 按钮显示的位置：右下侧
            maximizable: true,//最大化按钮
            modal: true,//模态窗口
            resizable: true,//可拖动改变窗口大小
            closeAction: 'destroy',
            items: [initWiondow_zqxmSjzcTbForm()],
            buttons: button
        });
        window.show();
        return window;
    }

    /**
     * 债券项目实际支出信息填报
     */
    function initWiondow_zqxmSjzcTbForm() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'item_zqxmSjzcTb_form',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            fileUpload: true,
            border: false,
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor:'100% 55%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 4 5',
                        //padding: '2 5 0 5',
                        columnWidth: .33,
                        labelWidth: 120//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            name: "SJZC_ID",
                            fieldLabel: '虚拟主单id',
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            name: "SJZC_TYPE",
                            fieldLabel: '支出类型',
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            name: "ZC_ID",
                            fieldLabel: '拨付支出单ID',
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            name: "AD_CODE",
                            fieldLabel: '地区编码',
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            name: "AG_ID",
                            fieldLabel: '单位ID',
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            name: "AG_CODE",
                            fieldLabel: '单位编码',
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            name: "AG_NAME",
                            fieldLabel: '单位',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            name: "SJZC_NO",
                            fieldLabel: '支出单号',
                            allowBlank: false,
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'

                        },
                        {
                            xtype: "datefield",
                            name: "SJZC_DATE",
                            fieldLabel: '<span class="required">✶</span>支出日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            value: today,
                            maxValue: nowDate
                        },
                        {
                            xtype: "textfield",
                            name: "XM_ID",
                            fieldLabel: '项目ID',
                            hidden: true,
                            decimalPrecision: 2,
                            allowDecimals: true,
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "XM_CODE",
                            fieldLabel: '项目编码',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            name: "XM_NAME",
                            fieldLabel: '项目名称',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            name: "XMLX_NAME",
                            fieldLabel: '项目分类',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            name: "ZQ_ID",
                            fieldLabel: '债券ID',
                            hidden: true,
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "ZQ_CODE",
                            fieldLabel: '债券编码',
                            fieldStyle: 'background:#E6E6E6',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            editable: false,//禁用编辑
                            hideTrigger: true
                        },
                        {
                            xtype: "textfield",
                            name: "ZQ_NAME",
                            fieldLabel: '债券名称',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "textfield",
                            name: "ZQQX_NAME",
                            fieldLabel: '债券期限',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            hidden: true,
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "BF_AMT",
                            fieldLabel: '拨付金额(元)',
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            readOnly: true,
                            decimalPrecision: 6,
                            emptyText: '0.000000',
                            allowDecimals: true,
                            hideTrigger: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "YZC_AMT",
                            fieldLabel: '已支出金额(元)',
                            editable: false,//禁用编辑
                            fieldStyle: 'background:#E6E6E6',
                            readOnly: true,
                            decimalPrecision: 6,
                            emptyText: '0.000000',
                            allowDecimals: true,
                            hideTrigger: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SJZC_AMT",
                            fieldLabel: '<span class="required">✶</span>本次支出金额(元)',
                            emptyText: '0.000000',
                            allowDecimals: true, // 是否允许小数
                            decimalPrecision: 4, // 小数精度
                            mouseWheelEnabled: false, // 上下调整箭头
                            allowBlank: false, // 是否允许为空
                            editable: true, // 禁用编辑
                            keyNavEnabled: false,
                            hideTrigger: true

                        },
                        {
                            xtype: "treecombobox",
                            name: "GNFL_ID",
                            store: zcgnfl_store,
                            displayField: "name",
                            valueField: "id",
                            selectModel: "leaf",
                            fieldLabel: '支出功能分类',
                            hidden:true,
                            editable: true, //禁用编辑
                            allowBlank: true
                        },
                        {
                            xtype: "treecombobox",
                            name: "JJFL_ID",
                            store: zcjjfl_store,
                            displayField: "name",
                            valueField: "id",
                            selectModel: "leaf",
                            fieldLabel: '支出经济分类',
                            hidden:true,
                            editable: true, //禁用编辑
                            allowBlank: true
                        },
                        {
                            xtype: 'textfield',
                            name: 'ZCZY',
                            fieldLabel: '资金用途',
                            allowBlank: true,
                            columnWidth: .999,
                            maxLength: 500,//限制输入字数
                            maxLengthText: "输入内容过长，最多只能输入500个汉字！"
                        },
                        {
                            xtype: 'textfield',
                            name: 'WQBZCYY',
                            fieldLabel: '未全部支出原因',
                            allowBlank: true,
                            columnWidth: .999,
                            maxLength: 500,//限制输入字数
                            maxLengthText: "输入内容过长，最多只能输入500个汉字！"
                        },
                        {
                            xtype: 'textfield',
                            name: 'REMARK',
                            fieldLabel: '备注',
                            allowBlank: true,
                            columnWidth: .999,
                            maxLength: 500,//限制输入字数
                            maxLengthText: "输入内容过长，最多只能输入500个汉字！"

                        },
                        {
                            xtype: 'datefield',
                            name: 'SJ_ZC_DATE',
                            hidden:true,
                            fieldLabel: '上级支出日期'
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    margin: '5 0 5 0',
                    border: true
                },
                {
                    xtype:'tabpanel',
                    anchor:'100% 45%',
                    items:[
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            layout: 'fit',
                            name: 'fileTab',
                            items: [
                                {
                                    xtype: 'panel',
                                    layout:'fit',
                                    itemId:'sjzc_fjgrid',
                                    items:[init_sjzc_fjGrid()]
                                }
                            ]
                        }
                    ]
                }
            ]
        });
    }

    /**
     * 实际支出必录附件
     */
    function init_sjzc_fjGrid(){
        var grid = UploadPanel.createGrid({
            busiType: 'ET205',//业务类型
            busiId: xzzqSjzcId,//业务ID
            editable:editValue,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_xzzq_sjzctb_contentForm_xmfj_grid'
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }
    /**
     * 提交数据
     */
    function submitZqxmSjzcTb(btn) {
        //获取实际收益情况表单
        var zqxmSjzcTbForm = btn.up('window').down('form');
        if (!zqxmSjzcTbForm.isValid()) {
            Ext.toast({
                html: "请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }

        var bf_amt = zqxmSjzcTbForm.down('numberFieldFormat[name="BF_AMT"]').getValue();
        var yzc_amt = zqxmSjzcTbForm.down('numberFieldFormat[name="YZC_AMT"]').getValue();
        var sjzc_amt = zqxmSjzcTbForm.down('numberFieldFormat[name="SJZC_AMT"]').getValue();
        //本次支出日期
        var bjZCDate = zqxmSjzcTbForm.down('datefield[name="SJZC_DATE"]').getValue();
        //上级支出日期
        var sjZCDate = zqxmSjzcTbForm.down('datefield[name="SJ_ZC_DATE"]').getValue();
        bjZCDate = Ext.Date.format(bjZCDate,"Y-m-d");
        sjZCDate = Ext.Date.format(sjZCDate,"Y-m-d");
        if (sjzc_amt <= 0) {
            Ext.Msg.alert('提示', "本次支出金额不能为0！");
            return false;
        }
        var zc_sum_amt = yzc_amt + sjzc_amt;
        if (bf_amt < zc_sum_amt) {
            Ext.Msg.alert('提示', "本次支出金额与已支出金额的和不能超过拨付金额！");
            return false;
        }
        //拨付金额大于已支出金额与本次支出金额得和时，必须录入未全部支出原因
        var WQBZCYY=zqxmSjzcTbForm.down('[name="WQBZCYY"]').getValue();
        if ((bf_amt > zc_sum_amt)&&!(!!WQBZCYY)) {
            Ext.Msg.alert('提示', "未支出全部金额需填写未全部支出原因！");
            return false;
        }
        //校验本次支出时间需大于等于上级支出时间
        if(bjZCDate<sjZCDate){
            Ext.Msg.alert('提示', "支出时间不能小于上级财政支出时间："+sjZCDate+"日！");
            return false;
        }
        //根据锁定期间校验支出时间,天津个性定制需求
        if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
            var params = {};
            params.ZC_DATE = zqxmSjzcTbForm.down('datefield[name="SJZC_DATE"]').getValue();
            params.AD_CODE = zqxmSjzcTbForm.down('textfield[name="AD_CODE"]').getValue();
            params.AG_CODE = zqxmSjzcTbForm.down('textfield[name="AG_CODE"]').getValue();
            if(!peCheck(params)){
                return false;
            }
        }
        btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
        $.post('/saveZqxmBmzcTb.action', {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            button_text: button_text,
            AD_CODE: ad_code,
            AG_ID: USER_AG_ID,
            AG_NAME: USER_AG_NAME,
            AG_CODE: USER_AG_CODE,
            zqxmSjzcTbForm: Ext.util.JSON.encode([zqxmSjzcTbForm.getValues()])
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                btn.up('window').close();
                // 刷新表格
                reloadGrid()
            } else {
                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                btn.setDisabled(false);
            }
            //刷新表格
        }, "json");
    }

    /**
     * 删除主表格信息
     */
    function delZqxmBmzcInfo(btn) {
        // 检验是否选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                var ids = new Array();
                var btn_text = btn.text;
                for (var k = 0; k < records.length; k++) {
                    var zqxm_sjzc_id = records[k].get("SJZC_ID");
                    ids.push(zqxm_sjzc_id);
                }

                $.post("delZqxmBmzcInfo.action", {
                    ids: Ext.util.JSON.encode(ids)
                }, function (data_response) {
                    data_response = $.parseJSON(data_response);
                    if (data_response.success) {
                        Ext.toast({
                            html: btn_text + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        reloadGrid();
                    } else {
                        Ext.toast({
                            html: btn_text + "失败！" + data_response.message,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                });
            }
        });
    }

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("SJZC_ID"));
        }
        //根据锁定期间校验支出时间,天津个性定制需求
        if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
            if(btn.name =='down' || (node_code > 1 && btn.name == 'cancel') ) {
                var dateArr = [];
                records.forEach(function (record) {
                    var param = {};
                    param.AD_CODE = record.data.AD_CODE;
                    param.AG_CODE = record.data.AG_CODE;
                    param.ZC_DATE = record.data.SJZC_DATE;
                    dateArr.push(param);
                });
                for (var i = 0; i < dateArr.length; i++) {
                    if (!peCheck(dateArr[i])) {
                        return false;
                    }
                }
            }
        }
        button_name = btn.name;
        button_text = btn.text;
        if (btn.text == '送审' || btn.text == '撤销送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("doZqxmBmzcWorkFlow.action", {
                        button_text: button_text,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_text + "成功！" + (data.message ? data.message : ''),
                                closable: false, align: 't', slideInDuration: 400, minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.show({
                                title: '提示',
                                msg: button_text + '失败！' + (data.message ? data.message : ''),
                                minWidth: 300,
                                buttons: Ext.Msg.OK,
                                fn: function (btn) {
                                }
                            });
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + '意见',
                value: btn.text == '审核' ? '同意' : '',
                animateTarget: btn,
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("doZqxmBmzcWorkFlow.action", {
                            button_text: button_text,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids
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
     *  刷新主面板
     */
    function reloadGrid() {
        var gridStore = DSYGrid.getGrid('contentGrid').getStore();
        gridStore.removeAll();
        var xm_search = Ext.ComponentQuery.query('textfield[itemId="MHCX"]')[0].getValue();
        gridStore.getProxy().extraParams = {
            AG_ID: USER_AG_ID,
            AD_CODE: ad_code,
            AG_CODE: USER_AG_CODE,
            wf_id: wf_id,
            node_code: node_code,
            node_type: node_type,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            xm_search: xm_search
            
        };
        //刷新
        gridStore.loadPage(1);

    }

    /**
     *  获取url参数或者查询字符串中的参数
     */
    function getQueryParam(name, queryString) {
        var match = new RegExp(name + '=([^&]*)').exec(queryString || location.search);
        return match && decodeURIComponent(match[1]);
    }

    /**
     * 操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var contentGrid_ID = records[0].get("SJZC_ID");
            fuc_getWorkFlowLog(contentGrid_ID);
        }
    }
    function getFJXX(ywsjid){
        //创建附件框
        var zwqxWindow =Ext.create('Ext.window.Window', {
            title: '项目附件情况',
            itemId: 'xmxxWindow',
            width: document.body.clientWidth * 0.95,
            height: document.body.clientHeight * 0.95,
            maximizable: true,//最大化按钮
            buttonAlign: "right", // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            closeAction: 'destroy',
            layout: 'fit',
            items: [initWin_xmfj(ywsjid)],
            buttons: [
                {
                    text: '关闭',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
        zwqxWindow.show();
    }
    function initWin_xmfj(ywsjid){
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'anchor',
            border: false,
            defaults: {
                width: '100%',
                margin: '0 0 2 0'
            },
            items: [
                Ext.create('Ext.tab.Panel', {
                    anchor: '100% -17',
                    border: false,
                    itemId: 'xmxxTab',
                    items: [
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            scrollable: true,
                            layout: 'fit',
                            itemId: 'xmfj',
                            items: initWin_xmInfo_xmfj(ywsjid)
                        }
                    ]
                })
            ]
        });
    }
    /**
     * 初始化债券信息填报弹出窗口中的项目附件标签页
     */
    function initWin_xmInfo_xmfj(ywsjid) {
        var tag = false;
        var grid = UploadPanel.createGrid({
            busiType: 'ET205',//业务类型
            busiId: ywsjid,//业务ID
            //ruleIds:'',//附件规则id
            editable: tag,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_xmxx_contentForm_tab_xmfj_grid_common'
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }

</script>
</html>
