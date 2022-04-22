<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>限额批次管理</title>
    <script src="/js/commonUtil.js"></script>
    <%--<script src="/js/plat/dateFormat.js"></script>--%>
    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<script>
    var flag_edit = false;//表格编辑状态
    //数据集:状态
    var store_status = DebtEleStore([
        {id: "0", code: "0", name: "停用"},
        {id: "1", code: "1", name: "启用"}
    ]);
    /**
     * 页面加载完成后执行
     */
    Ext.onReady(function () {
        /*预加载控件*/
        Ext.require([
            'Ext.tree.*',
            'Ext.data.*',
            'Ext.layout.container.HBox',
            'Ext.dd.*',
            'Ext.window.MessageBox'
        ]);
        //加载主表格
        initContent();
        //刷新功能区按钮
        refreshButtonStatus();
    });
    /**
     * 初始化主面板
     */
    function initContent() {
        //功能区按钮
        var tbar = [
            {
                text: '编辑',
                name: 'edit',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    flag_edit = true;
                    refreshButtonStatus();
                }
            },
            {
                text: '保存',
                name: 'save',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/save.png',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid("contentGrid");
                    var store = grid.getStore();
                    var records_add = store.getNewRecords();//新增行
                    var records_update = store.getUpdatedRecords();//修改行
                    if (!validateGrid()) {
                        return false;
                    }
                    for (var i = 0; i < records_add.length; i++) {
                        records_add[i] = records_add[i].data;
                    }
                    for (var i = 0; i < records_update.length; i++) {
                        records_update[i] = records_update[i].data;
                    }
                    $.post('/tygn/saveTygnXepcGrid.action', {
                        listAdd: Ext.util.JSON.encode(records_add),
                        listUpdate: Ext.util.JSON.encode(records_update)
                    }, function (data) {
                        if (data.success) {
                            flag_edit = false;
                            //修改按钮状态
                            refreshButtonStatus();
                            // 刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().load();
                            Ext.toast({
                                html: "保存成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                        }
                    }, 'JSON');
                }
            },
            {
                text: '取消',
                name: 'cancel',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    flag_edit = false;
                    //刷新功能区按钮状态
                    refreshButtonStatus();
                    //取消修改数据
                    DSYGrid.getGrid('contentGrid').getStore().rejectChanges();
                }
            },
            {
                text: '新增',
                name: 'add',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    DSYGrid.getGrid('contentGrid').insertData(null, {
                        STATUS: 1,
                        YEAR: new Date().getFullYear(),
                        STARTTIME: Ext.util.Format.date(new Date(), 'Ymd')
                    });
                }
            },
            {
                text: '删除',
                name: 'delete',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('contentGrid');
                    var records = grid.getSelection();
                    //校验只能删除新增行
                    for (var i = 0; i < records.length; i++) {
                        var id = records[i].get('GUID');
                        if (typeof id != 'undefined' && id != null && id.length > 0) {
                            Ext.Msg.alert('提示', '只能删除新增行！');
                            return false;
                        }
                    }
                    grid.getStore().remove(grid.getSelection());
                }
            },
            {
                text: '启用',
                name: 'start',
                disabled: true,
                xtype: 'button',
                status: 1,
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    updateXepcStatus(btn);
                }
            },
            {
                text: '停用',
                name: 'end',
                xtype: 'button',
                disabled: true,
                status: 0,
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_name = btn.text;
                    updateXepcStatus(btn);
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ];
        //页面主panel
        Ext.create('Ext.panel.Panel', {
            renderTo: Ext.getBody(),
            width: '100%',
            height: '100%',
            itemId: 'contentPanel',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: tbar
                }
            ],
            items: [
                initContentGrid()//初始化主表格
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "CODE", type: "string", text: "编码", width: 150, editor: 'textfield',
                renderer: function (value, cell) {
                    //修改作为必选项的背景色
                    if (flag_edit && (value == null || value.length <= 0)) {
                        cell.tdCls = 'grid-cell';
                    }
                    return value;
                }
            },
            {
                dataIndex: "NAME", type: "string", text: "名称", width: 150, editor: 'textfield',
                renderer: function (value, cell) {
                    //修改作为必选项的背景色
                    if (flag_edit && (value == null || value.length <= 0)) {
                        cell.tdCls = 'grid-cell';
                    }
                    return value;
                }
            },
            {dataIndex: "YEAR", type: "int", text: "年度", editor: 'numberfield'},
            {
                dataIndex: "STATUS", type: "string", text: "状态",
                renderer: function (value, cell) {
                    //修改作为必选项的背景色
                    if (flag_edit && (value == null || value.length <= 0)) {
                        cell.tdCls = 'grid-cell';
                    }
                    var record = store_status.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: "STARTTIME", type: "string", text: "生效时间",
                editor: {
                    xtype: 'datefield',
                    format: 'Ymd'
                }/*,
                renderer: function (value) {
                    var date = Ext.Date.parse(value, 'Ymd');
                    return Ext.util.Format.date(date != null ? date : value, 'Ymd');
                }*/
            },
            {
                dataIndex: "ENDTIME", type: "string", text: "失效时间",
                editor: {
                    xtype: 'datefield',
                    format: 'Ymd'
                }/*,
                renderer: function (value) {
                    var date = Ext.Date.parse(value, 'Ymd');
                    return Ext.util.Format.date(date != null ? date : value, 'Ymd');
                }*/
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            width: '100%',
            height: '100%',
            flex: 1,
            dataUrl: '/tygn/getTygnXepcGrid.action',
            pageConfig: {
                enablePage: false
            },
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'contentGrid_cellediting',
                    clicksToMoveEditor: 1,
                    listeners: {
                        edit: function (editor, context) {
                            if (context.field == 'STARTTIME' || context.field == 'ENDTIME') {
                                context.record.set(context.field, Ext.util.Format.date(context.value, 'Ymd'));
                            }
                        },
                        validateedit: function (editor, context) {
                            if (context.field == 'CODE') {
                                var codes = context.grid.getStore().queryRecords('CODE', context.value);
                                if (codes != null && codes.length > 0) {
                                    if (codes.length > 1 || codes[0].id != context.record.id) {
                                        Ext.Msg.alert('提示', context.record.data.NAME + '批次编码重复！');
                                        return false;
                                    }
                                }
                            }
                        },
                        beforeedit: function (editor, context) {
                            return flag_edit;//是否可编辑
                        }
                    }
                }
            ],
            listeners: {
                selectionchange: function (view, records) {
                    //切换工具栏按钮禁用状态
                    refreshButtonStatus();
                }
            }
        });
    }
    /**
     * 刷新功能按钮状态
     */
    function refreshButtonStatus() {
        //获取工具栏
        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
        //根据编辑状态修改工具栏按钮启用停用状态
        toolbar.down('button[name="edit"]').setDisabled(flag_edit);
        toolbar.down('button[name="save"]').setDisabled(!flag_edit);
        toolbar.down('button[name="cancel"]').setDisabled(!flag_edit);
        toolbar.down('button[name="add"]').setDisabled(!flag_edit);
        toolbar.down('button[name="delete"]').setDisabled(!flag_edit);
        toolbar.down('button[name="start"]').setDisabled(!flag_edit);
        toolbar.down('button[name="end"]').setDisabled(!flag_edit);
        //按钮启用停用状态
        var flag_selected = (typeof DSYGrid.getGrid('contentGrid').getSelection().length != 'undefined' && DSYGrid.getGrid('contentGrid').getSelection().length > 0);
        if (!flag_edit) {
            flag_selected = false;
        }
        toolbar.down('button[name="delete"]').setDisabled(!flag_selected);
        toolbar.down('button[name="start"]').setDisabled(!flag_selected);
        toolbar.down('button[name="end"]').setDisabled(!flag_selected);
    }
    /**
     * 启用/停用
     */
    function updateXepcStatus(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("GUID"));
            records[i].set('STATUS', btn.status);
        }
        //发送ajax请求，启用数据
        /*$.post("/tygn/updateTygnXepcStatus.action", {
         ids: ids,
         STATUS: btn.status
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
         DSYGrid.getGrid('contentGrid').getStore().load();
         }, "json");*/
    }
    /**
     * 校验表格数据
     * @returns {boolean}
     */
    function validateGrid() {
        var grid = DSYGrid.getGrid("contentGrid");
        var store = grid.getStore();
        var records_add = store.getNewRecords();//新增行
        var records_update = store.getUpdatedRecords();//修改行
        if (records_add.length <= 0 && records_update.length <= 0) {
            Ext.toast({
                html: "无新增及修改数据！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
        var records_all = records_add.concat(records_update);
        //循环数据校验生效时间/失效时间
        for (var i = 0; i < records_all.length; i++) {
            var starttime = records_all[i].data.STARTTIME;
            var endtime = records_all[i].data.ENDTIME;
            var code = records_all[i].data.CODE;
            var name = records_all[i].data.NAME;
            var year = records_all[i].data.YEAR;
            //校验非空
            if (typeof code == 'undefined' || code == null || code.length <= 0) {
                Ext.Msg.alert('提示', '编码不能为空');
                return false;
            }
            if (typeof name == 'undefined' || name == null || name.length <= 0) {
                Ext.Msg.alert('提示', '名称不能为空');
                return false;
            }
            if (typeof year == 'undefined' || year == null || year.length <= 0 || year == 0) {
                Ext.Msg.alert('提示', '年度不能为空');
                return false;
            }
            //校验编码是否重复
            var codeArr = store.queryRecords('CODE', code);
            if (codeArr != null && codeArr.length > 1) {
                Ext.Msg.alert('提示', name + '批次编码重复！');
                return false;
            }
            if (starttime != null && starttime.length > 0 && endtime != null && endtime.length > 0) {
                if (parseInt(starttime) > parseInt(endtime)) {
                    Ext.Msg.alert('提示', '失效时间不能早于生效时间');
                    return false;
                }
            }
        }
        return true;
    }
</script>
</body>
</html>