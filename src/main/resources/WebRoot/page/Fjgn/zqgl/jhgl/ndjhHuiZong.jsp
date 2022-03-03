<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>年度计划汇总</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    <%	/*获取登录用户*/
      /*  String userCode = (String) request.getSession().getAttribute("USERCODE");
        String adCode = (String) request.getSession().getAttribute("ADCODE");*/
    %>
    var userCode = '${sessionScope.USERCODE}';
    var AD_CODE = '${sessionScope.ADCODE}';
    var button_name = '';//当前操作按钮名称
 /*   var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    //全局变量 
    <%--var AD_CODE = '<%=adCode%>';--%>
    var grid_error_message = '';
/*
    var zqlb = getQueryParam('zqlb');//类型：一般/专项
       if (zqlb == null || zqlb == '' || zqlb.toLowerCase() == 'null') {
        zqlb = '01';
    }
*/
    var zqlb ="${fns:getParamValue('zqlb')}";
    if (isNull(zqlb)) {
        zqlb = '01';;
    }
  /*  var fxfs = getQueryParam('fxfs');//方式：公开/定向
    if (fxfs == null || fxfs == '' || fxfs.toLowerCase() == 'null') {
        fxfs = '01';
    }*/
    var fxfs ="${fns:getParamValue('fxfs')}";
    if (isNull(fxfs)) {
        fxfs = '01';
    }
   /* var type = getQueryParam('type');//类别：新增/置换
    if (type == null || type == '' || type.toLowerCase() == 'null') {
        if (fxfs == '02') {
            type = '02';
        } else {
            type = '01';
        }
    }*/
    var type ="${fns:getParamValue('type')}";
    if (isNull(type)) {
        if (fxfs == '02') {
            type = '02';
        } else {
            type = '01';
        }
    }
    /**
     * 通用配置json
     */
    var ndjhhz_json_common = {
        items: {
            '01': {
                '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '汇总',
                        name: 'btn_insert',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                                return;
                            }
                            var record = records[0].getData();
                            var recordArray = [];
                            recordArray.push(record);
                            $.post("/getIsHZByParam.action", {
                                detailList: Ext.util.JSON.encode(recordArray)
                            }, function (data) {
                                if (!data.success) {
                                    Ext.MessageBox.alert('提示', data.message);
                                    return;
                                } else {
                                    //公开发行需要选择填写承销银行
                                    window_input.show();
                                    //弹出填报页面，并写入信息
                                    window_input.window.down('form').getForm().setValues(record);
                                }

                            }, "json");


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
                '002': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销汇总',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            delHZDataSelectedList(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                return;
                            }
                            $.post("/getIsHZById.action", {
                                HZ_ID: records[0].get('HZ_ID')
                            }, function (data) {
                                if (!data.success) {
                                    Ext.MessageBox.alert('提示', data.message);
                                    return;
                                } else {
                                    //修改全局变量的值
                                    button_name = btn.text;
                                    updateHZdata(btn, records[0]);
                                }

                            }, "json");


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
            },
            '02': {
                '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '汇总',
                        name: 'btn_insert',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                                return;
                            }
                            var record = records[0].getData();
                            var recordArray = [];
                            recordArray.push(record);
                            $.post("/getIsHZByParam.action", {
                                detailList: Ext.util.JSON.encode(recordArray)
                            }, function (data) {
                                if (!data.success) {
                                    Ext.MessageBox.alert('提示', data.message);
                                    return;
                                } else {
                                    submitInfo(btn, record);
                                }

                            }, "json");


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
                '002': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销汇总',
                        name: 'btn_update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            delHZDataSelectedList(btn);
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
        store: {
            WF_STATUS: DebtEleStore(json_zqgl_zt1)
        }
    };
    /**
     * validateedit 保存逻辑
     */
    function submitInfo(btn, record) {
        //获取单据明细数组
        var recordArray = [];
        recordArray.push(record);
        var parameters = {
            fxfs: fxfs,
            button_name: button_name,
            detailList: Ext.util.JSON.encode(recordArray)
        };

        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: 'saveHZNdjh.action',
            params: parameters,
            async: false,
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '汇总成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '汇总失败',
                    width: 200,
                    fn: function (btn) {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
    /**
     * validateedit 保存逻辑
     */
    function updateHZdata(btn, record) {

        //发送ajax请求，查询主表和明细表数据
        $.post("/getNdjhHzDetail.action", {
            HZ_ID: record.get('HZ_ID'),
            isAll: true
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                return;
            }
            //弹出弹出框，并将主表和明细表数据插入到弹出框form中
            window_input.show();
            window_input.window.down('form').getForm().setValues(data.data);
            var grid = window_input.window.down('form').down('grid#zqzd_grid');
            grid.insertData(null, data.list);
        }, "json");
    }
    /**
     * 删除按钮实现
     */
    function delHZDataSelectedList(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                button_name = btn.text;
                var ids = new Array();
                for (var i in records) {
                    ids.push(records[i].get("HZ_ID"));
                }
                //发送ajax请求，删除数据
                $.post("/delNdjhHzByHzId.action", {
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            //html: button_name + "成功！",
                            html: data.message,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', data.message);
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        });
    }
    //填写承销确认信息页面
    var window_input = {
        window: null,
        show: function (params) {
            this.window = initWindow_input(params);
            this.window.show();
        }
    };
    /**
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("ZD_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
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
                    items: ndjhhz_json_common.items[fxfs][WF_STATUS]
                }
            ],
            items: [
                initContentTree({
                    items_tree: function () {
                        return [
                            initContentTree_area()
                        ]
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
        });
    }
    /**
     * 初始化右侧panel，放置2个表格
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
            dockedItems: tbar,
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    var tbar = [];
    if (fxfs == '01') {
        var tbar = [
            {
                xtype: 'toolbar',
                layout: 'column',
                defaults: {
                    margin: '5 5 5 5',
                    //columnWidth: .3,
                    width: 210,
                    labelWidth: 80//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: '发行方式',
                        name: 'FXFS',
                        xtype: 'combobox',
                        store: DebtEleStore(json_debt_fxfs),
                        editable: false,
                        readOnly: true,
                        displayField: 'name',
                        valueField: 'code',
                        value: fxfs
                    },
                    {
                        xtype: 'combobox',
                        fieldLabel: '债券类别',
                        name: 'TYPE_NAME',
                        displayField: 'name',
                        editable: false,
                        valueField: 'id',
                        value: type,
                        store: DebtEleStore(json_debt_zqlb),
                        listeners: {
                            change: function (self, newValue) {
                                type = self.getValue();
                                //刷新当前表格
                                reloadGrid({
                                    type: type
                                });
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '债券类型',
                        name: 'TYPE_NAME',
                        displayField: 'name',
                        editable: false,
                        valueField: 'id',
                        value: zqlb,
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        listeners: {
                            change: function (self, newValue) {
                                zqlb = self.getValue();
                                //刷新当前表格
                                reloadGrid({
                                    zqlb: zqlb
                                });
                            }
                        }
                    },
                    {
                        fieldLabel: '申报年度',
                        name: 'APPLY_YEAR',
                        xtype: 'combobox',
                        value: new Date().getFullYear() + 1,
                        store: DebtEleStore(json_debt_year),
                        editable: false,
                        displayField: 'name',
                        valueField: 'code',
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                reloadGrid();
                            }
                        }

                    }
                ]
            }
        ];
    } else {
        var tbar = [
            {
                xtype: 'toolbar',
                layout: 'column',
                defaults: {
                    margin: '5 5 5 5',
                    //columnWidth: .3,
                    width: 210,
                    labelWidth: 80//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: '发行方式',
                        name: 'FXFS',
                        xtype: 'combobox',
                        store: DebtEleStore(json_debt_fxfs),
                        editable: false,
                        readOnly: true,
                        displayField: 'name',
                        valueField: 'code',
                        value: fxfs
                    },
                    {
                        xtype: 'combobox',
                        fieldLabel: '债券类别',
                        name: 'TYPE_NAME',
                        displayField: 'name',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        valueField: 'id',
                        value: type,
                        store: DebtEleStore(json_debt_zqlb),
                        listeners: {
                            change: function (self, newValue) {
                                type = self.getValue()
                                //刷新当前表格
                                reloadGrid({
                                    type: type
                                });
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '债券类型',
                        name: 'ZQLB_NAME',
                        displayField: 'name',
                        editable: false,
                        valueField: 'id',
                        value: zqlb,
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        listeners: {
                            change: function (self, newValue) {
                                zqlb = self.getValue();
                                //刷新当前表格
                                reloadGrid({
                                    zqlb: zqlb
                                });
                            }
                        }
                    },
                    {
                        fieldLabel: '申报年度',
                        name: 'APPLY_YEAR',
                        xtype: 'combobox',
                        value: new Date().getFullYear() + 1,
                        store: DebtEleStore(json_debt_year),
                        editable: false,
                        displayField: 'name',
                        valueField: 'code',
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                reloadGrid();
                            }
                        }

                    }
                ]
            }
        ];
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区"},
            {dataIndex: "CREATE_DATE", width: 150, type: "string", text: "汇总日期"},
            {dataIndex: "ZQLB_NAME", width: 100, type: "string", text: "债券类别"},
            {dataIndex: "TYPE_NAME", width: 100, type: "string", text: "债券类型"},
            {dataIndex: "FX_MONTH", width: 100, type: "string", text: "发行月份"},
            {dataIndex: "APPLY_YEAR", width: 100, type: "string", text: "申报年度"},
            {dataIndex: "APPLY_AMOUNT", width: 150, type: "float", text: "申请金额(万元)"},
            {dataIndex: "CREATE_USER_NAME", width: 150, type: "string", text: "经办人"}
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                type: type,
                zqlb: zqlb,
                fxfs: fxfs
            },
            dataUrl: 'getNdjhHzBill.action',
            checkBox: true,
            // rowNumber: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: ndjhhz_json_common.store['WF_STATUS'],
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
                            toolbar.add(ndjhhz_json_common.items[fxfs][WF_STATUS]);
                            //刷新当前表格
                            reloadGrid({
                                WF_STATUS: newValue
                            });
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            rowNumber: {
                rowNumber: false// 显示行号
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    if (WF_STATUS == '002') {
                        DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                        DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                    }

                }
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid(callback) {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {
                dataIndex: "CXJG_CODE",
                width: 150,
                type: "string",
                text: "承销机构编码"
            },
            {
                dataIndex: "CXJG_NAME",
                width: 150,
                type: "string",
                text: "承销机构名称"
            },
            {
                dataIndex: "CX_AMT", type: "float", text: "承销金额(万元)", width: 150,
                editor: {
                    xtype: "numberfield",
                    emptyText: '0.00',
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
            },
            {
                dataIndex: "BFB", type: "float", text: "比照国债利率上浮BP", width: 120,
                editor: {
                    xtype: "numberfield",
                    emptyText: '0.00',
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
            },
            {
                dataIndex: "REMARK1",
                width: 200,
                type: "string",
                text: "备注"
            }
        ];

        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            rowNumber: true,
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: 'getNdjhHzDetail.action'
        };
        var grid = simplyGrid.create(config);
        return grid;
    }
    /**
     * 初始化债券转贷弹出窗口
     */
    function initWindow_input() {
        return Ext.create('Ext.window.Window', {
            title: '年度计划汇总', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: initWindow_input_contentForm(),
            buttons: [
                {
                    text: '保存',
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        var grid = form.down('grid#zqzd_grid');
                        grid.getPlugin('zqzd_grid_plugin_cell').completeEdit();
                        if (window.flag_validateedit && !window.flag_validateedit.isHidden()) {
                            return false;//如果校验未通过
                        }
                        //获取单据明细数组
                        var recordArray = [];
                        if (form.down('grid').getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '请填写承销明细记录！');
                            return false;
                        }
                        if (!checkGrid(form.down('grid'))) {
                            Ext.Msg.alert('提示', grid_error_message);
                            return false;
                        }
                        form.down('grid').getStore().each(function (record) {
                            recordArray.push(record.getData());
                        });
                        var parameters = {
                            button_name: button_name,
                            detailList: Ext.util.JSON.encode(recordArray)
                        };
                        if (button_name == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.HZ_ID = records[0].get('HZ_ID');
                        }
                        parameters.FXFS_ID = fxfs;
                        if (form.isValid()) {
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveHZNdjh.action',
                                params: parameters,
                                success: function (form, action) {
                                    //关闭弹出框
                                    btn.up("window").close();
                                    //提示保存成功
                                    Ext.toast({
                                        html: '<div style="text-align: center;">保存成功!</div>',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    Ext.Msg.alert('提示', "保存失败！" + action.result ? action.result.message : '无返回响应');
                                }
                            });
                        }
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }
    /**
     * 初始化债券转贷表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'anchor',
            defaults: {
                //anchor: '100% -100',
                margin: '5 5 5 5'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        //columnWidth: .3,
                        width: 240,
//                            disabled:true,
                        //readOnly: true,
                        labelWidth: 120//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            fieldLabel: '汇总单ID',
                            disabled: false,
                            name: "HZ_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {

                            name: 'AD_CODE',
                            xtype: "textfield",
                            editable: false,
                            hidden: true
                        }, {

                            name: 'AD_NAME',
                            xtype: "textfield",
                            editable: false,
                            hidden: true
                        },
                        , {

                            name: 'FX_MONTH',
                            xtype: "textfield",
                            editable: false,
                            hidden: true
                        },
                        {
                            fieldLabel: '发行方式',
                            name: 'FXFS',
                            xtype: 'combobox',
                            store: DebtEleStore(json_debt_fxfs),
                            editable: false,
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            //readOnly: true,
                            displayField: 'name',
                            valueField: 'code',
                            value: fxfs,
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: 'combobox',
                            fieldLabel: '债券类别',
                            name: 'ZQLB_NAME',
                            displayField: 'name',
                            // editable: false,
                            valueField: 'id',
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6',
                            store: DebtEleStore(json_debt_zqlb)
                        }, {
                            xtype: 'combobox',
                            fieldLabel: '债券类别',
                            name: 'ZQLB_ID',
                            hidden: true,
                            displayField: 'name',
                            editable: false,
                            valueField: 'id',
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            store: DebtEleStore(json_debt_zqlb)
                        }, ,
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '债券类型',
                            name: 'TYPE_ID',
                            displayField: 'name',
                            editable: false,
                            hidden: true,
                            valueField: 'id',
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            store: DebtEleTreeStoreDB('DEBT_ZQLB')
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '债券类型',
                            name: 'TYPE_NAME',
                            displayField: 'name',
                            //editable: false,
                            valueField: 'id',
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6',
                            store: DebtEleTreeStoreDB('DEBT_ZQLB')
                        },

                        {
                            fieldLabel: '申报年度',
                            name: 'APPLY_YEAR',
                            xtype: 'combobox',
                            value: new Date().getFullYear() + 1,
                            store: DebtEleStore(json_debt_year),
                            editable: false,
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            displayField: 'name',
                            valueField: 'code',
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'//禁用编辑

                        },
                        {
                            xtype: "numberFieldFormat",
                            fieldLabel: '汇总金额(万元)',
                            valueField: 'id',
                            width: 200,
                            labelWidth: 60,//控件默认标签宽度
                            labelAlign: 'right',//控件默认标签对齐方式
                            name: "APPLY_AMOUNT",
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            name: 'REMARK',
                            fieldLabel: '备注',
                            width: 410,
                            labelWidth: 60,
                            labelAlign: 'right',
                            editable: true
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    columnWidth: 1,
                    title: '承销明细',
                    anchor: '100% -100',
                    collapsible: true,
                    layout: 'fit',
                    items: [initWindow_input_contentForm_grid()]
                }
            ]
        });
    }
    /**
     * 初始化债券转贷表单中转贷明细信息表格
     */
    var store_DEBT_CXJG = DebtEleTreeStoreDB('DEBT_CXJG');
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                "dataIndex": "CXJG_NAME",
                "type": "string",
                "text": "机构编码",
                "hidden": true,
                "width": 150
            },
            {
                "dataIndex": "CXJG_CODE",
                "type": "string",
                "text": "机构名称",
                "width": 200,
                editor: {
                    xtype: 'treecombobox',
                    displayField: 'name',
                    valueField: 'code',
                    store: store_DEBT_CXJG,
                    rootVisible: false,
                    selectModel: 'leaf',
                    allowBlank: false,
                    editable: false
                },
                renderer: function (value) {
                    var record = store_DEBT_CXJG.findRecord('code', value, 0, false, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: "CX_AMT", type: "float", text: "承销金额(万元)", width: 150,
                editor: {
                    xtype: "numberfield",
                    emptyText: '0.00',
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "BFB", type: "float", text: "比照国债利率上浮BP", width: 180,
                editor: {
                    xtype: "numberfield",
                    emptyText: '0.00',
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
            },
            {
                dataIndex: "REMARK1",
                type: "string",
                text: "备注",
                width: 200,
                editor: 'textfield'
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'zqzd_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            checkBox: true,
            data: [],
            border: true,
            height: '100%',
            width: '100%',
            tbar: [
                '->',
                {
                    xtype: 'button',
                    text: '添加',
                    width: 60,
                    handler: function (btn) {
                        btn.up('grid').plugins[0].completeEdit();
                        btn.up('grid').insertData(null, {});
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'tzjhDelBtn',
                    text: '删除',
                    width: 60,
                    disabled: true,
                    handler: function (btn) {
                        var grid = btn.up('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                    }
                }
            ],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'zqzd_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        validateedit: function (editor, context) {
                            if (context.field == 'CXJG_CODE') {
                                window.flag_validateedit = null;
                                var newValue = context.value;
                                context.grid.getStore().each(function (record) {
                                    if (newValue == record.get('CXJG_CODE')) {
                                        window.flag_validateedit = Ext.Msg.alert('提示', '重复的承销机构！');
                                        return false;
                                    }
                                });
                                var record = store_DEBT_CXJG.findRecord('code', context.value, false, true, true);
                                context.record.set('CXJG_NAME', record.get('name'));
                                context.record.set('CXJG_ID', record.get('id'));
                            }
                        }
                    }
                }
            ],
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }]
        });
        grid.on('selectionchange', function (view, records) {
            grid.down('#tzjhDelBtn').setDisabled(!records.length);
        });
        return grid;
    }
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {

        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        var apply_year = Ext.ComponentQuery.query('combobox[name="APPLY_YEAR"]')[0].value;

        //增加查询参数
        store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;
        store.getProxy().extraParams['AD_CODE'] = AD_CODE;
        store.getProxy().extraParams['APPLY_YEAR'] = apply_year;
        store.getProxy().extraParams['zqlb'] = zqlb;
        store.getProxy().extraParams['type'] = type;
        store.getProxy().extraParams['fxfs'] = fxfs;

        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
        //刷新下方表格,置为空
        if (DSYGrid.getGrid('contentGrid_detail')) {
            var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
            //如果传递参数不为空，就刷新明细表格
            if (typeof param_detail != 'undefined' && param_detail != null) {
                for (var name in param_detail) {
                    store_details.getProxy().extraParams[name] = param_detail[name];
                }
                store_details.loadPage(1);
            } else {
                store_details.removeAll();
            }
        }
    }
    /**
     *保存时校验表格数据
     */
    function checkGrid(grid) {
        var flag = true;
        var form = grid.up('form');
        var cx_sum_amt = 0;
        grid.getStore().each(
            function (record) {

                if (record.get('CXJG_CODE') == '' || record.get('CXJG_CODE') == null) {
                    grid_error_message = '承销机构为空！';
                    flag = false;
                    return;
                }
                if (record.get('BFB') == '' || record.get('BFB') == null) {
                    grid_error_message = '比照国债利率上浮BP为空！';
                    flag = false;
                    return;
                }
                cx_sum_amt += record.get('CX_AMT');
            });
        if (flag && cx_sum_amt != form.down('numberFieldFormat[name="APPLY_AMOUNT"]').getValue()) {
            grid_error_message = '总承销金额与汇总单金额不符！';
            flag = false;
            return flag;
        }
        return flag;
    }
</script>
</body>
</html>